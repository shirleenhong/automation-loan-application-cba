*** Settings ***
Resource     ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

###Verify the Updates in Accrual Tab###

Validate Payment Manual Adjustment Transaction
    [Documentation]    Verify the cycleDue and paidToDate values from the payload response after the manual adjustment transaction is made in Loan Oustanding
    ...    @author: sacuisia 16OCT2020
    ...	   @update: makcamps 25NOV2020	-added release cashflows and release steps, used generate intent notice keyword, and used data set for currency
    [Arguments]    ${ExcelPath}
    
    ${Outstanding_Alias}    Read Data From Excel    ComSee_SC2_Loan    Outstanding_Alias    ${rowid}    ${ComSeeDataSet}
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Outstanding_Alias}
    
    ###Interest Payment Reversal Creation###
    ${CycleDue}    Create Interest Payment Reversal
    Navigate to Cashflow - Reverse Interest Payment
    ${Borrower}    Read Data From Excel    ComSee_SC2_Loan    Borrower_ShortName    ${rowid}    ${ComSeeDataSet}
    ${RIDescrption}    Read Data From Excel    ComSee_SC2_Loan    Remittance_Instruction    ${rowid}    ${ComSeeDataSet}
    ${RemittanceInstruction}    Read Data From Excel    ComSee_SC2_Loan    Remittance_Instruction    ${rowid}    ${ComSeeDataSet}
    Verify if Method has Remittance Instruction    ${Borrower}    ${RIDescrption}    ${RemittanceInstruction}
    Verify if Status is set to Do It    ${Borrower}
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankSharePct}    Read Data From Excel    ComSee_SC2_Loan    HostBankSharePct    ${rowid}    ${ComSeeDataSet}  
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Outstanding_Currency]
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    ${Borrower}
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${CycleDue}    ${HostBankSharePct}
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    ${HostBank}    Read Data From Excel    ComSee_SC2_Loan    Host_Bank    ${rowid}    ${ComSeeDataSet} 
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    ${HostBank}    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    ${Borrower}    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Credit}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${CycleDue}
    
    ###Workflow Tab - Send to Approval###
    Send Reverse Interest Payment to Approval
   
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
   
    ###Work in Process#####
    Select Item in Work in Process    Payments    Awaiting Approval    Reverse Interest Payment     &{ExcelPath}[Facility_Name]

    Approve Interest Payment
    Generate Intent Notices of an Interest Payment-CommSee    ${ExcelPath}[Borrower_ShortName]

    ###Release Reverse Interest Payment###
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Release Cashflows
	Release Payment
    
    ###Validate Cycle Due paidToDate after EOD###
    Navigate to Share Accrual Cycle    &{ExcelPath}[Lender1_ShortName]
    
    ${LoanCycleDueAmount}    Get Cycle Due Amount
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_cycleDue    ${rowid}    ${LoanCycleDueAmount}    ${ComSeeDataSet}
    
    ${LoanPaidDueAmount}   Get PaidToDate   
    Write Data To Excel    ComSee_SC2_Loan   Outstanding_paidToDate    ${rowid}    ${LoanPaidDueAmount}    ${ComSeeDataSet}
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ

Navigate to Accruals Share Adjustment Loans
     [Documentation]    This keyword navigates the LIQ User to the Accruals Share Adjustment Notebook and validates the information displayed in the notebook.
    ...    @author: rtarayao
    ...    @update:    fmamaril    Remove validation on current cycle due
    ...    @update: clanding    22JUL2020    - added pre-processing keywords, refactor argument per standard, added screenshot
    [Arguments]    ${iSBLC_CycleNumber}    ${sDeal_Name}    ${sFacility_Name}    ${sDeal_Borrower}    ${sSBLC_Alias}
    
    
    ${SBLC_CycleNumber}    Acquire Argument Value    ${iSBLC_CycleNumber}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}
    ${SBLC_Alias}    Acquire Argument Value    ${sSBLC_Alias}
    
    Mx LoanIQ Select String    ${LIQ_Outstanding_Accrual_JavaTree}    ${SBLC_CycleNumber}   
    mx LoanIQ click    ${LIQ_Outstanding_AccrualShared_Button}         
    mx LoanIQ activate    ${LIQ_AccrualSharesAdjustment_Pending_Window}
    Mx LoanIQ Verify Object Exist    ${LIQ_AccrualSharesAdjustment_Pending_Window}           VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Deal_Name}")      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Facility_Name}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Deal_Borrower}")        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${SBLC_Alias}")       VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AccrualSharesAdjustment_Pending_Window


Create Cycle Share Adjustment for Loan Outstanding
    [Documentation]    This keyword is for creating cycle share adjustment for Bilateral Deal
    ...    @author: sacuisia    10OCT2021
    [Arguments]    ${ExcelPath}
    
   
    ${SBLC_EffectiveDate}    Get System Date

    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Outstanding_Alias]
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ##Acrued Amount after EOD
    ${LoanAccruedtodateAmount}    Get Loan Accrued to Date Amount
    ${LoanAccruedtodateAmount}    Remove Comma and Convert to Number    ${LoanAccruedtodateAmount}
    ${TotalRowCount}    Get Accrual Row Count    ${LIQ_Loan_Window}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_Loan_Tab}    ${LIQ_Loan_AccrualTab_Cycles_Table}
    ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_AccruedInterest    ${rowid}    ${LoanAccruedtodateAmount}    ${ComSeeDataSet}
    
    ##Validate Cycle Due paidToDate after EOD
    Navigate to Share Accrual Cycle    &{ExcelPath}[Host_Bank]
    
    ${Current_Cycle_Due}    Get Cycle Due Amount
    ${Current_Cycle_Due}    Remove comma and convert to number - Cycle Due    ${Current_Cycle_Due}
    Write Data To Excel    ComSee_SC2_Loan    Outstanding_cycleDue    ${rowid}    ${Current_Cycle_Due}    ${ComSeeDataSet}
    
    ${Paid_to_Date}   Get PaidToDate    
    ${Paid_to_Date}    Remove comma and convert to number - Paid to Date    ${Paid_to_Date}
    Write Data To Excel    ComSee_SC2_Loan   Outstanding_paidToDate    ${rowid}    ${Paid_to_Date}    ${ComSeeDataSet}
    
    Mx LoanIQ click    ${LIQ_ServicingGroup_Exit_Button}
    Mx LoanIQ click    ${LIQ_SharesFor_Cancel_Button}
    
    Navigate to Accruals Share Adjustment Loans    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Outstanding_Alias]    
    Input Requested Amount, Effective Date, and Comment    ${Paid_to_Date}    ${SBLC_EffectiveDate}    &{ExcelPath}[Accrual_Comment]
    Save the Requested Amount, Effective Date, and Comment    ${Paid_to_Date}    ${SBLC_EffectiveDate}    &{ExcelPath}[Accrual_Comment]
  
    Send Adjustment to Approval 
    
    Close All Windows on LIQ
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    Navigate Transaction in WIP    Payments    Awaiting Approval    Loan Accrual Shares Adjustment    &{ExcelPath}[Deal_Name]
    
    Approve Cycle Share Adjustment
    
    Release Cycle Share Adjustment
    
    Close Accrual Shares Adjustment Window

    ###Loan IQ Desktop###    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Store Cycle Start Date, End Date, and Paid Fee for Loan Outstanding
    [Documentation]    This keyword is used to save the Current Cycle Start Date, End Date, and Paid to Date values in Excel.
    ...    @author: rtarayao
    ...    @author: fmamaril    30APR2019    Remove writing and delete unnecessary arguments
    ...    @update: clanding    22JUL2020    - added pre-processing keywords, refactor argument per standard, added screenshot
    ...                                      - added post-processing keywords
    ...    @update: sacuisia    14OCT2020    - change locators for Loan Outstanding
    [Arguments]    ${iSBLC_CycleNumber}    ${sRunTimeVar_Current_Cycle_Due}=None    ${sRunTimeVar_Cycle_Paid_to_Date}=None

    ### GetRuntime Keyword Pre-processing ###
    ${SBLC_CycleNumber}    Acquire Argument Value    ${iSBLC_CycleNumber}

    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Outstanding_Accrual_JavaTree}    ${SBLC_CycleNumber}%s
    ${Current_Cycle_Due}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Outstanding_Accrual_JavaTree}    ${SBLC_CycleNumber}%Cycle Due%Current_Cycle_Due
    ${Paid_to_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Outstanding_Accrual_JavaTree}    ${SBLC_CycleNumber}%Paid to date%Paid_to_Date
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCGuaranteeWindow_Accrual

    ### Keyword Post-processing ###
    
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Current_Cycle_Due}    ${Current_Cycle_Due}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Cycle_Paid_to_Date}    ${Paid_to_Date}

    [Return]    ${Current_Cycle_Due}    ${Paid_to_Date}

Generate Intent Notices of an Interest Payment-CommSee
    [Documentation]    This keyword generates Intent Notices of an Interest Payment
    ...    @author: ghabal    
    ...	   @update: makcamps 26NOV2020	- change Exit notice button to dynamic
    [Arguments]    ${LIQCustomer_ShortName}    

    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}    
        
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    ${NoticeStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Notice_Information_Table}    ${LIQCustomer_ShortName}%Status%test    
    Log    ${NoticeStatus}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Notice_Information_Table}    ${LIQCustomer_ShortName}%s 
	
    mx LoanIQ click    ${LIQ_Notice_Exit_Button}

Release Interest Payment
    [Documentation]    This keyword will release the Loan Drawdown
    ...    @author: ritragel
    ...    @update: ritragel    06MAR19    Added handling of closing Cashflows window
    ...    @update: makcamps	25NOV20    Added handling of closing Cashflows window at the end
    mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}   
    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Complete Cashflows 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
Initiate Interest Payment - Scenario 7 ComSee
   [Documentation]    This keyword will pay Interest Fees on a bilateral deal
   ...    @author: rtarayao    13SEP2019    - Duplicate from Scenario 7 of the Functional Scenarios
   ...    @author: makcamps    01DEC2020    - added condition for currency in eu
   [Arguments]    ${ExcelPath}
   
   ###Navigate to Existing Loan###
   Open Existing Deal    &{ExcelPath}[Deal_Name]
   Navigate to Outstanding Select Window from Deal
   Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
   ${ScheduledActivityReport_Date}    Get Interest Adjusted Due Date on Loan Notebook
   ${LoanEffectiveDate}    ${LoanMaturityDate}    Get Loan Effective and Maturity Expiry Dates
   Write Data To Excel    ComSee_SC7_LoanInterestPayment    ScheduledActivityReport_Date    ${rowid}    ${ScheduledActivityReport_Date}    ${ComSeeDataSet}
   Close All Windows on LIQ 
   ${SystemDate}    Get System Date
   Navigate to the Scheduled Activity Filter
   Open Scheduled Activity Report    ${LoanEffectiveDate}    ${LoanMaturityDate}    &{ExcelPath}[Deal_Name]
   
   ###Loan Notebook####
   Open Loan Notebook    ${ScheduledActivityReport_Date}    &{ExcelPath}[ScheduledActivityReport_ActivityType]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_Alias]
   ${CycleDue}    Compute Interest Payment Amount Per Cycle - Zero Cycle Due    &{ExcelPath}[CycleNumber]    ${SystemDate}
   Write Data To Excel    ComSee_SC7_LoanInterestPayment    Payment_Amount    ${rowid}    ${CycleDue}    ${ComSeeDataSet}

   ###Interest Payment Notebook####
   Initiate Loan Interest Payment   &{ExcelPath}[CycleNumber]    &{ExcelPath}[Pro_Rate]
   Input Effective Date and Requested Amount for Loan Interest Payment    ${SystemDate}    ${CycleDue}
    
   ##Cashflow Notebook - Create Cashflows###
   Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Create Cashflows
   Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Remittance_Instruction]
   Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
   ##Get Transaction Amount for Cashflow###
   ${HostBankShare}    Run Keyword If    '${ENTITY}'!='EU'    Get Host Bank Cash in Cashflow
   ...    ELSE    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
   ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
   ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${CycleDue}    &{ExcelPath}[HostBankSharePct]
    
   Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
   ###GL Entries###
   Navigate to GL Entries
   ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
   ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
   ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
   ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
   Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
   Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
   Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${CycleDue}
   
   ###Workflow Tab - Send to Approval###
   Send Interest Payment to Approval
   
   ###Loan IQ Desktop###
   Logout from Loan IQ
   Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
   
   ###Work in Process#####
   Open Interest Payment Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
   Approve Interest Payment

   ##Loan IQ Desktop###
   Close All Windows on LIQ
   Logout from Loan IQ
   Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

   ###Interest Payment Notebook - Workflow Tab###  
   Select Item in Work in Process    Payments    Awaiting Release    Interest Payment     &{ExcelPath}[Facility_Name]
   Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Release Cashflows
   Release Payment
    
   ##Facility Notebook####
   Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]   
   
   ####Outstanding Select####  
   Navigate to Outstanding Select Window
   
   ###Loan Notebook####
   Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
   ${CycleDue}    Convert To String    ${CycleDue}       
   Validate Interest Payment in Loan Accrual Tab    &{ExcelPath}[CycleNumber]    ${CycleDue}
   
   Close All Windows on LIQ
   Logout from Loan IQ
   
Initiate Latest Cycle Interest Payment - Scenario 7 ComSee
   [Documentation]    This keyword will pay Interest Fees on a bilateral deal
   ...    @author: rtarayao    13SEP2019    - Duplicate from Scenario 7 of the Functional Scenarios
   ...	  @update: makcamps	   26NOV2020	- added configuration for getting currency from data
   [Arguments]    ${ExcelPath}
   
   ###Navigate to Existing Loan###
   Open Existing Deal    &{ExcelPath}[Deal_Name]
   Navigate to Outstanding Select Window from Deal
   Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
   ${ScheduledActivityReport_Date}    Get Interest Adjusted Due Date on Loan Notebook
   ${LoanEffectiveDate}    ${LoanMaturityDate}    Get Loan Effective and Maturity Expiry Dates
   Write Data To Excel    ComSee_SC7_LoanInterestPayment    ScheduledActivityReport_Date    ${rowid}    ${ScheduledActivityReport_Date}    ${ComSeeDataSet}
   Close All Windows on LIQ 
   ${SystemDate}    Get System Date
   Navigate to the Scheduled Activity Filter
   Open Scheduled Activity Report    ${LoanEffectiveDate}    ${LoanMaturityDate}    &{ExcelPath}[Deal_Name]
   
   ###Loan Notebook####
   Open Loan Notebook    ${ScheduledActivityReport_Date}    &{ExcelPath}[ScheduledActivityReport_ActivityType]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_Alias]
   ${CycleNumber}    Get Latest Interest Cycle Row
   Write Data To Excel    ComSee_SC7_LoanInterestPayment    CycleNumber    ${rowid}    ${CycleNumber}    ${ComSeeDataSet}
   ${CycleDue}    Compute Interest Payment Amount Per Cycle - Zero Cycle Due    ${CycleNumber}    ${SystemDate}
   Write Data To Excel    ComSee_SC7_LoanInterestPayment    Payment_Amount    ${rowid}    ${CycleDue}    ${ComSeeDataSet}

   ###Interest Payment Notebook####
   Initiate Loan Latest Cycle Interest Payment   ${CycleNumber}    &{ExcelPath}[Pro_Rate]
   Input Effective Date and Requested Amount for Loan Interest Payment    ${SystemDate}    ${CycleDue}
    
   ##Cashflow Notebook - Create Cashflows###
   Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Create Cashflows
   Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Remittance_Instruction]
   Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
   ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Run Keyword If    '&{ExcelPath}[Entity]'=='EU'    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ...    ELSE    Get Host Bank Cash in Cashflow
   ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
   ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${CycleDue}    &{ExcelPath}[HostBankSharePct]
    
   Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
   ###GL Entries###
   Navigate to GL Entries
   ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
   ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
   ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
   ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
   Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
   Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
   Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${CycleDue}
   
   ###Workflow Tab - Send to Approval###
   Send Interest Payment to Approval
   
   ###Loan IQ Desktop###
   Logout from Loan IQ
   Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
   
   ###Work in Process#####
   Open Interest Payment Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
   Approve Interest Payment

   ##Loan IQ Desktop###
   Close All Windows on LIQ
   Logout from Loan IQ
   Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

   ###Interest Payment Notebook - Workflow Tab###  
   Select Item in Work in Process    Payments    Awaiting Release    Interest Payment     &{ExcelPath}[Facility_Name]
   Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Release Cashflows
   Release Payment
    
   ##Facility Notebook####
   Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]   
   
   ####Outstanding Select####  
   Navigate to Outstanding Select Window
   
   ###Loan Notebook####
   Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
   ${CycleDue}    Convert To String    ${CycleDue}       
   Validate Interest Payment in Loan Accrual Tab    &{ExcelPath}[CycleNumber]    ${CycleDue}
   
   Close All Windows on LIQ
   Logout from Loan IQ
   
Create Loan Interest Payment Reversal - Scenario 7 ComSee
    [Documentation]    This keyword initiates payment reversal after Fee Payment is released.
    ...    @author: cfrancis    16OCT2020    - initial create
    ...    @update: makcamps    26NOV2020    - added condition for currency to be from excel path
    [Arguments]    ${ExcelPath}
    
    ###Navigate to Existing Loan###    
    ${Outstanding_Alias}    Read Data From Excel    ComSee_SC7_Loan    Outstanding_Alias    ${rowid}    ${ComSeeDataSet}
    Launch Loan Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Outstanding_Alias}
    
    
    ###Interest Payment Reversal Creation###
    ${CycleDue}    Create Interest Payment Reversal
    Navigate to Cashflow - Reverse Interest Payment
    ${Borrower}    Read Data From Excel    ComSee_SC7_LoanInterestPayment    Borrower1_ShortName    ${rowid}    ${ComSeeDataSet}
    ${RIDescrption}    Read Data From Excel    ComSee_SC7_LoanInterestPayment    Borrower1_RTGSRemittanceDescription    ${rowid}    ${ComSeeDataSet}
    ${RemittanceInstruction}    Read Data From Excel    ComSee_SC7_LoanInterestPayment    Remittance_Instruction    ${rowid}    ${ComSeeDataSet}
    Verify if Method has Remittance Instruction    ${Borrower}    ${RIDescrption}    ${RemittanceInstruction}
    Verify if Status is set to Do It    ${Borrower}
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankSharePct}    Read Data From Excel    ComSee_SC7_LoanInterestPayment    HostBankSharePct    ${rowid}    ${ComSeeDataSet}
    ${HostBankShare}    Run Keyword If    '&{ExcelPath}[Entity]'=='EU'    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ...    ELSE    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    ${Borrower}
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${CycleDue}    ${HostBankSharePct}
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    ${HostBank}    Read Data From Excel    ComSee_SC7_OngoingFeePayment    Host_Bank    ${rowid}    ${ComSeeDataSet} 
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    ${HostBank}    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    ${Borrower}    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Credit}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${CycleDue}
    
    ###Workflow Tab - Send to Approval###
    Send Reverse Interest Payment to Approval
   
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
   
    ###Work in Process#####
    Select Item in Work in Process    Payments    Awaiting Approval    Reverse Interest Payment     &{ExcelPath}[Facility_Name]
    
    ###Approve Reverse Interest Payment###
    Approve Reverse Interest Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    ###Release Reverse Interest Payment###  
    Select Item in Work in Process    Payments    Awaiting Release Cashflows    Reverse Interest Payment     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_ReverseInterestPayment_Window}    ${LIQ_ReverseInterestPayment_Tab}    ${LIQ_ReverseInterestPayment_WorkflowItems}    Release Cashflows   
    Release Reverse Interest Payment
    Close All Windows on LIQ
    Logout from Loan IQ
