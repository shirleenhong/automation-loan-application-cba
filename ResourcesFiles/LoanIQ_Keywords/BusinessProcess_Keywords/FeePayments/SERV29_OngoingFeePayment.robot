*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***

*** Keywords ***
Update Commitment Fee Cycle
    [Documentation]    This keyword will update the existing commitment fee cycle in the created deal
    ...    @author: fmamaril
    ...    @update: ritragel    13MAR2019    Removed the writing and will update it upon checkin on the next testcases
    ...    @update: jdelacru    18MAR2019    Update Username and Password Columns to follow standards, Added writing of ScheduledActivity Report Dates   
    ...    @update: fmamaril    19MAR2019    Remove computation of Projected Cycle Due (To be handled on diff keyword)
    ...    @update: rtarayao    08APR2019    Added Run keyword if for Scenario 6 writings
    ...    @update: fmamaril    23APR2019    Commented writing on projected cycle due for Scenario 6 - Should be handled on Payment
    ...    @update: dahijara    09JUL2020    Updated Writing for Serv29 data set.
    ...    @update: dahijara    05AUG2020    Added writing for fee alias for scenario 5
    [Arguments]    ${ExcelPath}

    ###LoanIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - Summary Tab###  
    ${Fee_Alias}    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type1]
    Run Keyword If    '${SCENARIO}'=='7'    Write Data To Excel    SERV35_Terminate_FacilityDeal    Fee_Alias    ${rowid}    ${Fee_Alias}
    Run Keyword If    '${SCENARIO}'=='6'    Write Data To Excel    SERV29_PaymentFees    Fee_Alias    &{ExcelPath}[rowid]    ${Fee_Alias}
    Run Keyword If    '${SCENARIO}'=='5'    Write Data To Excel    SERV29_PaymentFees    Fee_Alias    &{ExcelPath}[rowid]    ${Fee_Alias}
    
    ###Commitment Fee Notebook - General Tab###  
    ${AdjustedDueDate}    Update Cycle on Commitment Fee   &{ExcelPath}[Fee_Cycle]
    
    ${ScheduleActivity_FromDate}    Subtract Days to Date    ${AdjustedDueDate}    30
    ${ScheduledActivity_ThruDate}    Add Days to Date    ${AdjustedDueDate}    30
    Run Keyword If    '${SCENARIO}'=='6'    Run Keywords    Write Data To Excel    SERV29_PaymentFees    ScheduleActivity_FromDate    &{ExcelPath}[rowid]    ${ScheduleActivity_FromDate}   
    ...    AND    Write Data To Excel    SERV29_PaymentFees    ScheduledActivity_ThruDate    &{ExcelPath}[rowid]    ${ScheduledActivity_ThruDate}        
    ...    AND    Write Data To Excel    SERV29_PaymentFees    ScheduledActivityReport_Date    &{ExcelPath}[rowid]    ${AdjustedDueDate}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    FeePayment_EffectiveDate    &{ExcelPath}[rowid]    ${SystemDate}
    ...    ELSE    Run Keywords    Write Data To Excel    SERV29_PaymentFees    ScheduleActivity_FromDate    ${rowid}    ${ScheduleActivity_FromDate}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    ScheduledActivity_ThruDate    ${rowid}    ${ScheduledActivity_ThruDate}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    FeePayment_EffectiveDate    ${rowid}    ${SystemDate}

    Run Online Acrual to Commitment Fee
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ

Run online accrual on Commitment Fee Notebook
    [Arguments]    ${ExcelPath}
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date
    Set Global Variable    ${SystemDate}    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - Summary Tab###  
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type1]
    
    ###Commitment Fee Notebook - General Tab###  
    Update Cycle on Commitment Fee   &{ExcelPath}[Fee_Cycle]
    ${ProjectedCycleDue}    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[PrincipalAmount]    &{ExcelPath}[RateBasis]    &{ExcelPath}[CycleNumber]    ${SystemDate}
    Write Data To Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue    &{ExcelPath}[rowid]    ${ProjectedCycleDue}
    Run Online Acrual to Commitment Fee
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ

Update Indemnity Fee Cycle
    [Arguments]    ${ExcelPath}
    
    ###Go back to the original user###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ${SystemDate}    Get System Date
    ##Loan IQ Desktop###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - Summary Tab###  
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type2]
    
    ###Commitment Fee Notebook - General Tab###  
    Update Cycle on Indemnity Fee    &{ExcelPath}[Fee_Cycle]
    ${ProjectedCycleDue2}    Compute Indemnity Fee Amount Per Cycle    &{ExcelPath}[PrincipalAmount2]    &{ExcelPath}[RateBasis2]    &{ExcelPath}[CycleNumber2]
    Write Data To Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue2    &{ExcelPath}[rowid]    ${ProjectedCycleDue2} 
    Write Data To Excel    SERV29_PaymentFees    FeePayment_EffectiveDate2    &{ExcelPath}[rowid]    ${SystemDate}
    Run Online Acrual to Indemnity Fee
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
   
Pay Commitment Fee Amount
    [Documentation]    This keyword will pay Commitment Fee Amount on a deal
    ...    @author: fmamaril
    ...    @update: fmamaril    23APR2019    Apply cashflow handling based on standards and removed notices validation for correspondence testing
    ...    @update: fmamaril    29APR2019    Remove commented steps
    ...    @update: ehugo    05JUN2020    - used 'Navigate to Payment Workflow and Proceed With Transaction' instead of 'Navigate Notebook Workflow'
    [Arguments]    ${ExcelPath}    

    ###Return to Scheduled Activity Fiter###
    ${SystemDate}    Get System Date
    Set Global Variable    ${SystemDate}
    ${RemittanceDescription}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD   ${rowid}               
    Navigate to Scheduled Activity Filter

    ###Scheduled Activity Filter###
    Set Scheduled Activity Filter    &{ExcelPath}[ScheduleActivity_FromDate]    &{ExcelPath}[ScheduledActivity_ThruDate]    &{ExcelPath}[ScheduledActivity_Department]    &{ExcelPath}[ScheduledActivity_Branch]    &{ExcelPath}[Deal_Name]

    ###Scheduled Activity Report Window###
    Select Fee Due    &{ExcelPath}[ScheduledActivityReport_FeeType]    &{ExcelPath}[ScheduledActivityReport_Date]    &{ExcelPath}[Facility_Name]
    
    ###Commitment Fee Notebook - General Tab###  
    ${ProjectedCycleDue}    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[PrincipalAmount]    &{ExcelPath}[RateBasis]    &{ExcelPath}[CycleNumber]    ${SystemDate}
    Run Keyword If    '${SCENARIO}'=='1'    Write Data To Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue    ${rowid}    ${ProjectedCycleDue}
    Run Keyword If    '${SCENARIO}'=='7'    Write Data To Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue    ${rowid}    ${ProjectedCycleDue}    
    Run Keyword If    '${SCENARIO}'=='6'    Write Data To Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue    &{ExcelPath}[rowid]    ${ProjectedCycleDue}  

    ###Cycles for Commitment Fee###
    Select Cycle Fee Payment
    
    ###Ongoing Fee Payment Notebook - General Tab### 
    Enter Effective Date for Ongoing Fee Payment    ${SystemDate}    ${ProjectedCycleDue}
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Cashflow - Ongoing Fee
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    ${RemittanceDescription}    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${ProjectedCycleDue}    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${ProjectedCycleDue}
    Send Ongoing Fee Payment to Approval
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    #Work In Process Window###
    Select Item in Work in Process    Payments    Awaiting Approval    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]

    ###Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    ###Generation of Intent Notice is skipped - Customer Notice Method must be updated###
    Select Item in Work in Process    Payments    Release Cashflows    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]
    Navigate to Payment Workflow and Proceed With Transaction    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower1_ShortName]    release
    Release Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ###Deal Notebook - Summary Tab### 
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type1]
    
    ###Commitment Fee Notebook - Acrual Tab###   
    Validate Details on Acrual Tab - Commitment Fee    ${ProjectedCycleDue}    &{ExcelPath}[CycleNumber]
    Validate release of Ongoing Fee Payment
    Validate GL Entries for Ongoing Fee Payment - Bilateral Deal    &{ExcelPath}[Host_Bank]    &{ExcelPath}[Borrower1_ShortName]    ${ProjectedCycleDue}    
    
    ###Get specific Fee Payment Released data for Reversal- MTAM05B##
    ${sFeePayment_Date}    ${sFeePayment_Time}    ${sFeePayment_User}    ${sFeePayment_Comment}    ${sFeePayment_EffectiveDate}    Run Keyword If    '${SCENARIO}'=='6' and '&{ExcelPath}[rowid]'=='2'    Get Commitment Fee Payment Information for Reversal Validation 
    Run Keyword If    '${SCENARIO}'=='6' and '&{ExcelPath}[rowid]'=='2'    Run Keywords    Write Data To Excel    MTAM05B_CycleShareAdjustment    EffectiveDate_FeePayment    ${rowid}    ${sFeePayment_EffectiveDate}       
    ...    AND    Write Data To Excel    MTAM05B_CycleShareAdjustment    FeePayment_Date    ${rowid}    ${sFeePayment_Date}   
    ...    AND    Write Data To Excel    MTAM05B_CycleShareAdjustment    FeePayment_Time    ${rowid}    ${sFeePayment_Time} 
    ...    AND    Write Data To Excel    MTAM05B_CycleShareAdjustment    FeePayment_User    ${rowid}    ${sFeePayment_User} 
    ...    AND    Write Data To Excel    MTAM05B_CycleShareAdjustment    FeePayment_Comment    ${rowid}    ${sFeePayment_Comment}  
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Pay Commitment Fee Amount - Syndicated
    [Arguments]    ${ExcelPath}
    [Documentation]    This keyword will be used for payments and transactions of commitment fee amount for Syndicated Deals
    ...    @author: fmamaril
    ...    @update: ritragel    19MAR2019    Update for the dataSet and Standards
 
    #Return to Scheduled Activity Fiter###    
    Navigate to Scheduled Activity Filter
    
    ${SysDate}    Get System Date
    ${FromDate}    Subtract Days to Date    ${SysDate}    30
    ${ThruDate}    Add Days to Date    ${SysDate}    30
    Write Data To Excel    SERV29_PaymentFees    ScheduleActivity_FromDate    ${rowid}    ${FromDate}
    Write Data To Excel    SERV29_PaymentFees    ScheduledActivity_ThruDate    ${rowid}    ${ThruDate}
    ###Scheduled Activity Filter###
    Set Scheduled Activity Filter    ${FromDate}    ${ThruDate}    &{ExcelPath}[ScheduledActivity_Department]    &{ExcelPath}[ScheduledActivity_Branch]    &{ExcelPath}[Deal_Name]

    ###Scheduled Activity Report Window###
    Select Fee Due    &{ExcelPath}[FeeType1]    &{ExcelPath}[ScheduledActivityReport_Date]    &{ExcelPath}[Facility_Name]
    
    ###Commitment Fee Notebook - General Tab###  
    ${ProjectedCycleDue}    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[PrincipalAmount]    &{ExcelPath}[RateBasis]    &{ExcelPath}[CycleNumber]    ${SysDate}
    Write Data To Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue    &{ExcelPath}[rowid]    ${ProjectedCycleDue}
    
    ##Cycles for Commitment Fee###
    Select Cycle Fee Payment
    
    ###Ongoing Fee Payment Notebook - General Tab###
    Enter Effective Date for Ongoing Fee Payment    ${SysDate}    ${ProjectedCycleDue}
    ${Computed_ProjectedCycleDue}    Read Data From Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue    &{ExcelPath}[rowid]
    
    ###Ongoing Fee Payment Notebook - Workflow Tab###  
    Navigate to Cashflow - Ongoing Fee
    
    ###Cashflow Window###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]

    ${ProjectedCycleDue}    Read Data From Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue    ${rowid}
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]

    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${ProjectedCycleDue}    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    ${ProjectedCycleDue}    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    ${ProjectedCycleDue}    &{ExcelPath}[LenderSharePct2]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender2_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ProjectedCycleDue}
    
    mx LoanIQ click element if present     ${LIQ_PaymentNotebook_Cashflow_OK_Button}      
    Send Ongoing Fee Payment to Approval
    
    #Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    #Work In Process Window###
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    
    ###Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Ongoing Fee Payment Notebook - Workflow Tab###  
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    Generate Intent Notices for Ongoing Fee Payment
    Verify Status and Notice Method in Notices    &{ExcelPath}[Contact_Email]    &{ExcelPath}[Borrower_LegalName]     &{ExcelPath}[Borrower_Contact]    ${MANAGER_USERNAME}    Email    &{ExcelPath}[NoticeStatus]
    
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}     Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]|&{ExcelPath}[Lender1_ShortName]|&{ExcelPath}[Lender2_ShortName]

    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender2_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Credit}|${Lender2_Credit}|${Lender1_Credit}    ${Borrower_Debit} 
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ProjectedCycleDue}


    Release Ongoing Fee Payment

    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ##Deal Notebook - Summary Tab### 
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type1]

    ###Commitment Fee Notebook - Acrual Tab###   
    Validate Details on Acrual Tab    &{ExcelPath}[Computed_ProjectedCycleDue]    &{ExcelPath}[CycleNumber]
    Validate release of Ongoing Fee Payment
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
  
Pay Indemnity Fee Amount - Syndicated
    [Arguments]    ${ExcelPath}
    [Documentation]    This keyword will be used for the payment of the Indemnity Fee Amount for Syndicated deal
    ...    @author: fmamaril
    ...    @update: ritragel    20MAR2019    Updated for automation scripting standard and cashflow standards
  
    #Return to Scheduled Activity Fiter###    
    Navigate to Scheduled Activity Filter
    
    ${SysDate}    Get System Date
    ${FromDate}    Subtract Days to Date    ${SysDate}    30
    ${ThruDate}    Add Days to Date    ${SysDate}    30
    Write Data To Excel    SERV29_PaymentFees    ScheduleActivity_FromDate    ${rowid}    ${FromDate}
    Write Data To Excel    SERV29_PaymentFees    ScheduledActivity_ThruDate    ${rowid}    ${ThruDate}
  
    ###Scheduled Activity Filter###
    Set Scheduled Activity Filter    ${FromDate}   ${ThruDate}    &{ExcelPath}[ScheduledActivity_Department]    &{ExcelPath}[ScheduledActivity_Branch]    &{ExcelPath}[Deal_Name]

    ###Scheduled Activity Report Window###
    Select Fee Due    &{ExcelPath}[FeeType2]    &{ExcelPath}[ScheduledActivityReport_Date]    &{ExcelPath}[Facility_Name]
    
    ###Commitment Fee Notebook - General Tab###  
    ${ProjectedCycleDue}    Compute Indemnity Fee Amount Per Cycle    &{ExcelPath}[PrincipalAmount]    &{ExcelPath}[RateBasis]    &{ExcelPath}[CycleNumber]
    Write Data To Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue2    ${rowid}    ${ProjectedCycleDue}
    
    ###Cycles for Commitment Fee###
    Select Cycle Indemnity Fee Payment
    
    ###Ongoing Fee Payment Notebook - General Tab### 
    Enter Effective Date for Indemnity Fee Payment    ${SysDate}
    ${Computed_ProjectedCycleDue2}    Read Data From Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue2    ${rowid}

    ###Ongoing Fee Payment Notebook - Workflow Tab###  
    Navigate to Cashflow - Ongoing Fee

    ###Cashflow Window###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]

    ${ProjectedCycleDue}    Read Data From Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue    ${rowid}
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]

    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${ProjectedCycleDue}    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    ${ProjectedCycleDue}    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    ${ProjectedCycleDue}    &{ExcelPath}[LenderSharePct2]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    &{ExcelPath}[GLTotal_RowName]   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    &{ExcelPath}[GLTotal_RowName]    Debit Amt
    ${Lender2_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Credit Amt
    ${Lender1_Credit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt

    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}|${Lender1_Credit}|${Lender2_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ProjectedCycleDue}
    
    mx LoanIQ click element if present     ${LIQ_PaymentNotebook_Cashflow_OK_Button}    
    Send Ongoing Fee Payment to Approval
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ###Work In Process Window###
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    
    ###Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Ongoing Fee Payment Notebook - Workflow Tab###  
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    
    # ##Ongoing Fee Payment Notebook - Workflow Tab###      
    # ${ReleaseCashflow_Status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Release Cashflows%s     
    # Run Keyword If    ${ReleaseCashflow_Status}==True    Run Keywords    Open Loan Initial Drawdown Notebook via WIP - Awaiting Release Cashflow    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseCashflowsStatus]    &{ExcelPath}[WIP_OutstandingType]    &{ExcelPath}[Loan_Alias]
    # ...    AND    Release Drawdown Cashflows    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Loan_Currency]    &{ExcelPath}[Loan_RequestedAmount]
    # Generate Intent Notices for Ongoing Fee Payment
    # Release Ongoing Fee Payment
    
    
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_Drawdown_WorkflowItems}    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]|&{ExcelPath}[Lender1_ShortName]|&{ExcelPath}[Lender2_ShortName]

    ###GL Entries###
    Navigate to GL Entries
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    &{ExcelPath}[GLTotal_RowName]   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    &{ExcelPath}[GLTotal_RowName]    Debit Amt
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    ${Lender2_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Debit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Debit Amt

    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ProjectedCycleDue}
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    # ##Deal Notebook - Summary Tab### 
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type2]

    ##Commitment Fee Notebook - Acrual Tab###   
    Validate Details on Acrual Tab - Indemnity    &{ExcelPath}[Computed_ProjectedCycleDue2]    &{ExcelPath}[CycleNumber2]
    Validate release of Indemnity Fee Payment
    Close All Windows on LIQ

Pay Commitment Fee Amount - Syndicated with Secondary Sale
    [Documentation]    This high level keyword pays the commitment fee for Secondary Sale Deal
    ...    @update: jdelacru    09MAR2019    - Applied the latest cashflow keywords
    ...    @update: dahijara    04AUG2020    - Updated create cashflow navigation. Updated variables for Verify Status and Notice Method in Notices. Removed commented codes.
    [Arguments]    ${ExcelPath}    
    ${SystemDate}    Get System Date
    Set Global Variable    ${SystemDate}   
    ###Scheduled Activity Filter###      
    Navigate to Scheduled Activity Filter
    Set Scheduled Activity Filter    &{ExcelPath}[ScheduleActivity_FromDate]    &{ExcelPath}[ScheduledActivity_ThruDate]    &{ExcelPath}[ScheduledActivity_Department]    &{ExcelPath}[ScheduledActivity_Branch]    &{ExcelPath}[Deal_Name]
    Select Fee Due    &{ExcelPath}[FeeType1]    &{ExcelPath}[ScheduledActivityReport_Date]    &{ExcelPath}[Facility_Name]
        
    ###Commitment Fee Notebook###  
    ${ProjectedCycleDue}    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[PrincipalAmount]    &{ExcelPath}[RateBasis]    &{ExcelPath}[CycleNumber]    ${SystemDate}
    Write Data To Excel    SERV29_PaymentFees    Computed_ProjectedCycleDue    ${rowid}    ${ProjectedCycleDue}
    Select Cycle Fee Payment
    
    ###Ongoing Fee Payment Notebook### 
    Enter Effective Date for Ongoing Fee Payment    &{ExcelPath}[FeePayment_EffectiveDate]    ${ProjectedCycleDue}
    
    ###Cashflow###
    Navigate to Cashflow - Ongoing Fee
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender1_RemittanceDescription]    &{ExcelPath}[Lender1_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Computed_ProjectedCycleDue]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Computed_ProjectedCycleDue]    &{ExcelPath}[LenderSharePct1]
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}

    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Credit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${HostBank_Debit}|${Lender1_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Computed_ProjectedCycleDue]

    ###Ongoing Fee Notebook###
    Send Ongoing Fee Payment to Approval
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ###Work In Process###
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    
    ###Ongoing Fee Notebook### 
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Work In Process###  
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    
    ###Intent Notice###
    Generate Intent Notices for Ongoing Fee Payment
    Verify Status and Notice Method in Notices    &{ExcelPath}[Lender1_Contact_Email]    &{ExcelPath}[Lender1_LegalName]     &{ExcelPath}[Lender_Contact]    ${MANAGER_USERNAME}    &{ExcelPath}[Lender1_NoticeMethod]    &{ExcelPath}[NoticeStatus]
    Verify Status and Notice Method in Notices    &{ExcelPath}[Borrower1_Contact_Email]    &{ExcelPath}[Borrower1_LegalName]     &{ExcelPath}[Borrower_Contact]    ${MANAGER_USERNAME}    &{ExcelPath}[Borrower1_NoticeMethod]    &{ExcelPath}[NoticeStatus]
    Close Notice Window
    
    ###Ongoing Fee Notebook###
    Release Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - Summary Tab### 
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type1]

    ###Commitment Fee Notebook - Acrual Tab###   
    Validate Details on Acrual Tab - Commitment Fee    &{ExcelPath}[Computed_ProjectedCycleDue]    &{ExcelPath}[CycleNumber]
    Validate Release of Ongoing Fee Payment
    
    ###GL Entries###
    Validate GL Entries for Ongoing Fee Payment on Secondary Sale    &{ExcelPath}[Host_Bank]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Computed_ProjectedCycleDue]    &{ExcelPath}[Lender1_ShortName]      
    
    ###LIQ Window###
    Close All Windows on LIQ

Capitalized Ongoing Fee Payment
    [Documentation]    This keyword is used to pay the Capitalized Ongoing Fee - Fee Level.
    ...    @author: rtarayao
    [Arguments]    ${ExcelPath}
    ### <update> 12Dec18 - bernchua : Scenario 8 integration. Get data from Excel of previous transactions / test scripts
    ${Lender1}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender    &{ExcelPath}[rowid]
    ${Lender2}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender_2    &{ExcelPath}[rowid]
    ${HostBank}    Read Data From Excel    TRP002_SecondarySale    Seller_LegalEntity    &{ExcelPath}[rowid]
    ${LenderShare1}    Read Data From Excel    TRP002_SecondarySale    PctofDeal    &{ExcelPath}[rowid]
    ${LenderShare2}    Read Data From Excel    TRP002_SecondarySale    PctofDeal2    &{ExcelPath}[rowid]
    ${HostBankShare}    Evaluate    100-(${LenderShare1}+${LenderShare2})
    
    ###Facility and Loan Notebook (Pre-validation)###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ### 12Dec18 - bernchua : Get lender legal names
    ${Lender1_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender1}
    ${Lender2_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender2}
    
    ### 13Dec18 - bernchua : Get lender remittance instruction descriptions
    ${Borrower_RIDescription}    Get Deal Borrower Remittance Instruction Description    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Instruction]
    ${Lender1_RIDescription}    Get Customer Lender Remittance Instruction Desc Via Lender Shares In Deal Notebook    ${Lender1}    &{ExcelPath}[Remittance_Instruction]
    ${Lender2_RIDescription}    Get Customer Lender Remittance Instruction Desc Via Lender Shares In Deal Notebook    ${Lender2}    &{ExcelPath}[Remittance_Instruction]    
    
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    # Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ${Orig_FacilityProposedcmt}    ${Orig_FacilityClosingCmt}    ${Orig_FacilityCurrentCmt}    ${Orig_FacilityOutstandings}    ${Orig_FacilityAvailableToDraw}    Get Original Data on Global Facility Amounts Section
    Write Data To Excel    CAP02_CapitalizedFeePayment    Orig_FacilityCurrentCmt    ${rowid}    ${Orig_FacilityCurrentCmt}
    Write Data To Excel    CAP02_CapitalizedFeePayment    Orig_FacilityOutstandings    ${rowid}    ${Orig_FacilityOutstandings}
    Write Data To Excel    CAP02_CapitalizedFeePayment    Orig_FacilityAvailableToDraw    ${rowid}    ${Orig_FacilityAvailableToDraw}
    
    Navigate to Outstanding Select Window
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    ${Orig_LoanGlobalOriginal}    ${Orig_LoanGlobalCurrent}    ${Orig_LoanHostBankGross}    ${Orig_LoanHostBankNet}    Get Original Data on Loan Amounts Section
    Write Data To Excel    CAP02_CapitalizedFeePayment    Orig_LoanGlobalOriginal    ${rowid}    ${Orig_LoanGlobalOriginal}
    Write Data To Excel    CAP02_CapitalizedFeePayment    Orig_LoanGlobalCurrent    ${rowid}    ${Orig_LoanGlobalCurrent}
    Write Data To Excel    CAP02_CapitalizedFeePayment    Orig_LoanHostBankGross    ${rowid}    ${Orig_LoanHostBankGross}
    Write Data To Excel    CAP02_CapitalizedFeePayment    Orig_LoanHostBankNet    ${rowid}    ${Orig_LoanHostBankNet}
    
    ###Step 1 & 2 : Naviagtion to Commitment Notebook###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name] 
    Open Ongoing Fee from Facility Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type]
    
    ###Step 3 - 6: Fee Payment Initiation###
    Initiate Ongoing Fee Payment    &{ExcelPath}[Cycle_Number]
    
    ###Step 7 - 8: Lender Share Validation####
    ${CycleDue}    Read Data From Excel    CAP02_CapitalizedFeePayment    OngoingFee_CycleDue    ${rowid}
    # Validate Lender Shares - Ongoing Fee Payment    ${HostBank}    ${Lender1}    ${Lender2}    ${HostBankShare}    
    # ...    ${LenderShare1}    ${LenderShare2}    ${CycleDue}
    
    # ###Step 9 - 13 Cashflows and GL Entries Validation####
    # Navigate to Payment Cashflow Window
    # # Validate Capitalized Ongoing Fee (Amounts) Cashflow Details    &{ExcelPath}[Capitalization_RemainingFeePercentage]    ${CycleDue}    ${HostBankShare}    ${LenderShare1}    
    # # ...        ${LenderShare2}    &{ExcelPath}[Borrower_ShortName]    ${Lender1}    ${Lender2}
    # Validate Remittance Instructions in Cashflow - Ongoing Fee Payment with Three Lenders    &{ExcelPath}[Borrower_ShortName]    ${Lender1}    ${Lender2}    ${Borrower_RIDescription}
    # ...    ${Lender1_RIDescription}    ${Lender2_RIDescription}
    # Click OK In Cashflows
    # Get Transaction Amount and Validate GL Entries - Capitalized Ongoing Fee    &{ExcelPath}[Borrower_ShortName]    ${Lender1}    ${Lender2}    &{ExcelPath}[HostBank_PrincipalLoanGLAcct]    &{ExcelPath}[HostBank_LendingFeeGLAcct]        
    # ...    &{ExcelPath}[Capitalization_PctofPayment]    ${HostBankShare}    ${LenderShare1}    ${LenderShare2}    ${CycleDue}
    
    ###Step 15: Sending of Payment Approval###
    Send Payment to Approval
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    &{ExcelPath}[ApproverUserName]    &{ExcelPath}[ApproverPassword]
    
   ###Step 16: Payment Approval#####
   Open Payment Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Facility_Name]
   Approve Payment
    
   ###Loan IQ Desktop###
   Logout from Loan IQ
   Login to Loan IQ    &{ExcelPath}[UserName_Original]    &{ExcelPath}[Password_Original]
   
   ###Sending of Intent Notices###
   Open Fee Payment Notebook via WIP - Awaiting Generate Intent Notices    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingGenerateIntentNotices]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Facility_Name]
   Navigate to Payment Intent Notices Window
   Verify Customer Notice Method    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    Email    &{ExcelPath}[Borrower_ContactEmail]
   Verify Customer Notice Method    ${Lender1_LegalName}    &{ExcelPath}[Lender1_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    Email    &{ExcelPath}[Lender1_ContactEmail]
   Verify Customer Notice Method    ${Lender2_LegalName}    &{ExcelPath}[Lender2_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    External Notice Method    &{ExcelPath}[Lender2_ContactEmail]
   Verify Customer Notice Method    ${Lender2_LegalName}    &{ExcelPath}[Lender2_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    Email    &{ExcelPath}[Lender2_ContactEmail]
   mx LoanIQ close window     ${LIQ_IntentNotice_Window}
   
   ####Loan IQ Desktop#####
   Logout from Loan IQ
   Login to Loan IQ    &{ExcelPath}[ApproverUserName]    &{ExcelPath}[ApproverPassword]
   
   ###Step 17: Release Payment###
   # Open Payment Notebook via WIP - Awaiting Release    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingRelease]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Facility_Name]
   Navigate to Payment Workflow Tab
   ${ReleaseCashflow_Status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Release Cashflows%s   
   # Run Keyword If    ${ReleaseCashflow_Status}==True    Run Keywords    Open Payment Notebook via WIP - Awaiting Release Cashflow    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseCashflowsStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Facility_Name]
   # ...    AND    Release Fee Payment Cashflows with Three Lenders    &{ExcelPath}[Borrower_ShortName]    ${Lender1}    ${Lender2}
   Release Payment
   Close All Windows on LIQ
   
   #############POST VALIDATIONS#################
   
   ###Deal Notebook###
   Search Existing Deal    &{ExcelPath}[Deal_Name]
    
   ###Step 18 - Lender validation###
   Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type]
   Navigate to Ongoing Fee Payment Notebook from Commitment Fee Notebook
  mx LoanIQ close window    ${LIQ_CommitmentFeeNotebook_Window}
   # Validate Lender Shares - Ongoing Fee Payment    ${HostBank}    ${Lender1}    ${Lender2}    ${HostBankShare}    
    # ...    ${LenderShare1}    ${LenderShare2}    ${CycleDue}
   Close All Windows on LIQ
   
   ###Step 19 - Loan Validation###
   ${Orig_LoanGlobalOriginal}    Read Data From Excel    CAP02_CapitalizedFeePayment    Orig_LoanGlobalOriginal    ${rowid}
   ${Orig_LoanGlobalCurrent}    Read Data From Excel    CAP02_CapitalizedFeePayment    Orig_LoanGlobalCurrent    ${rowid}
   ${Orig_LoanHostBankGross}    Read Data From Excel    CAP02_CapitalizedFeePayment    Orig_LoanHostBankGross    ${rowid}
   ${Orig_LoanHostBankNet}    Read Data From Excel    CAP02_CapitalizedFeePayment    Orig_LoanHostBankNet    ${rowid}
   
   Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    
   Navigate to Outstanding Select Window
   Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
   Validate Updated Loan Amount After Payment - Capitalized Ongoing Fee    ${Orig_LoanGlobalOriginal}    ${Orig_LoanGlobalCurrent}    ${Orig_LoanHostBankGross}    ${Orig_LoanHostBankNet}    &{ExcelPath}[Capitalization_PctofPayment]    ${HostBankShare}    ${CycleDue}

   ###Step 21 - Events Tab and Pending Tab Validation###
   Validate Loan Events Tab after Payment - Capiltalized Ongoing Fee
   Validate Loan Pending Tab- Capitalized Ongoing Fee
   
   Close All Windows on LIQ
   
   ###Step 22 - Facility Validation###
   ${Orig_FacilityCurrentCmt}    Read Data From Excel    CAP02_CapitalizedFeePayment    Orig_FacilityCurrentCmt    ${rowid}
   ${Orig_FacilityOutstandings}    Read Data From Excel    CAP02_CapitalizedFeePayment    Orig_FacilityOutstandings    ${rowid}
   ${Orig_FacilityAvailableToDraw}    Read Data From Excel    CAP02_CapitalizedFeePayment    Orig_FacilityAvailableToDraw    ${rowid}
   
   # Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
   # Validate Updated Facility Amounts After Payment - Capitalized Ongoing Fee    ${Orig_FacilityCurrentCmt}    ${Orig_FacilityOutstandings}    ${Orig_FacilityAvailableToDraw}    &{ExcelPath}[Capitalization_PctofPayment]
   
   ### <update> 13Dec18 - bernchua : Return to original user
   Logout from Loan IQ
   Login to Loan IQ    &{ExcelPath}[UserName_Original]    &{ExcelPath}[Password_Original]
   
Interest Capitalization Payment 
    [Documentation]    This keyword is used to setup Interest Capitalization
    ...    @author: ghabal
         
    [Arguments]    ${ExcelPath} 
    ##Loan Drawdown - Workflow Tab#### 
    Logout from Loan IQ
    Login to Loan IQ    &{ExcelPath}[Username]    &{ExcelPath}[Password]

    #Initial Loan Interest Payments###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_FacilityName]  
    Navigate to Outstanding Select Window
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Loan_Alias]
    Initiate Loan Interest Payment Details from Loan Notebook   
    ${InterestPayment_EffectiveDate}    Get System Date
    Write Data To Excel    SERV13_InterestCapitalization    InterestPayment_EffectiveDate    ${rowid}    ${InterestPayment_EffectiveDate}
    Input Effective Date and Requested Amount for Loan Interest Payment - S2/S4    ${InterestPayment_EffectiveDate}

    ##Workflow Tab - Send to Approval###
    Send Loan Payment to Approval
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    &{ExcelPath}[Approver_Username]    &{ExcelPath}[Approver_Password]
   
    ###Work in Process#####
    Open Loan Interest Payment Notebook     &{ExcelPath}[WIP_TransactionTypePayments]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
    
    ##Workflow Tab - Approval###
    Approve Interest Payment
    
    ### Workflow Tab - Generate Intent Notices###        
    Generate Intent Notices of an Interest Payment    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_Email]    &{ExcelPath}[Loan_Borrower]    &{ExcelPath}[InterestPaymentNotice_Status]   
     
    #Workflow Tab - Release###   
    Release Payment
    Close All Windows on LIQ
       
   
