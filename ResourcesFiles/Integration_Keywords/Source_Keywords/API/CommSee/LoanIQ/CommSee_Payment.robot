*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
   
*** Keywords ***
Pay SBLC Issuance - ComSee
    [Documentation]    This high-level keyword is used when customer pays for the Issuance Fee.
    ...    This also writes the details needed for the Comsee outstanding fee details validations.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    [Arguments]    ${ExcelPath}
    ###LIQ Window###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ${SystemDate}    Get System Date
    Verify if Standby Letters of Credit Exist    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    
    ###Letter of Credit Window###    
    Navigate Existing Standby Letters of Credit    &{ExcelPath}[Outstanding_Alias]
        
    ###Cycles for Bank Guarantee Window###    
    ${ComputedCycleDue}    Compute SBLC Issuance Fee Amount Per Cycle    &{ExcelPath}[CycleNumber]    ${SystemDate}
    
    ###SBLC Guarantee Window###
    Navigate To Fees On Lender Shares
    Initiate Issuance Fee Payment    &{ExcelPath}[Outstanding_Alias]    ${SystemDate}
    ...    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    ${ComputedCycleDue}
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${ComputedCycleDue}    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${ComputedCycleDue}

    ###Bank Guarantee - Workflow Tab###
    Send Issuance Fee Payment to Approval
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    #Work In Process Window###
    Select Item in Work in Process    Payments    Awaiting Approval    Issuance Fee Payment     &{ExcelPath}[Facility_Name]
    
    ##Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve Issuance Fee Payment for Lender Share
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    ###Transactions in Process###
    Select Item in Work in Process    Payments    Release Cashflows    Issuance Fee Payment     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Release Cashflows    
    Release Cashflow    &{ExcelPath}[Borrower1_ShortName]    release           
    Release Issuance Fee Payment for Lender Share

    ###Loan IQ Desktop###    
    Close All Windows on LIQ
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Outstanding Navigation###
    Navigate to Existing SBLC Guarantee    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Outstanding_Alias]
    
    ###Get and Write Rates Tab Details for Comsee
    ${IssuanceRiskType}    Get Issuance Risk Type 
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_RiskType    ${rowid}    ${IssuanceRiskType}    ${ComSeeDataSet}
    
    ${IssuanceCCY}    Get Issuance Currency
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_Currency    ${rowid}    ${IssuanceCCY}    ${ComSeeDataSet}
    
    ${IssuanceEffectiveDate}    ${IssuanceAdjustedExpiryDate}    Get Issuance Effective and Maturity Expiry Dates
    ${IssuanceEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${IssuanceEffectiveDate}
    ${IssuanceAdjustedExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${IssuanceAdjustedExpiryDate}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_EffectiveDate    ${rowid}    ${IssuanceEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_MaturityExpiryDate    ${rowid}    ${IssuanceAdjustedExpiryDate}    ${ComSeeDataSet}
    
    ${HBGrossAmount}    ${HBNetAmount}    Get Issuance Host Bank Net and Gross Amount
    ${HBGrossAmount}    Remove Comma and Convert to Number    ${HBGrossAmount}
    ${HBNetAmount}    Remove Comma and Convert to Number    ${HBNetAmount}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_HBGrossAmount    ${rowid}    ${HBGrossAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_HBNetAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_HBNetFacCCYAmount    ${rowid}    ${HBNetAmount}    ${ComSeeDataSet}
    
    ${GlobalOriginalAmount}    ${GlobalCurrentAmount}    Get Issuance Global Original and Current Amount
    ${GlobalOriginalAmount}    Remove Comma and Convert to Number    ${GlobalOriginalAmount}
    ${GlobalCurrentAmount}    Remove Comma and Convert to Number    ${GlobalCurrentAmount}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_GlobalOriginalAmount    ${rowid}    ${GlobalOriginalAmount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Outstanding_GlobalCurrentAmount    ${rowid}    ${GlobalCurrentAmount}    ${ComSeeDataSet}
     
    ${Fee_Type}    Get Issuance Fee Type
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Fee_Type    ${rowid}    ${Fee_Type}    ${ComSeeDataSet} 
    
    ${Fee_Currency}    Get SBLC Accrual CCY
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Fee_Currency    ${rowid}    ${Fee_Currency}    ${ComSeeDataSet}
    
    ${Fee_CurrentRate}    Get Issuance Rate
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Fee_CurrentRate    ${rowid}    ${Fee_CurrentRate}    ${ComSeeDataSet}
    
    ${Fee_EffectiveDate}    ${Fee_ExpiryDate}    ${Fee_DueDate}    Get Issuance Accrual Dates
    ${Fee_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Fee_EffectiveDate}
    ${Fee_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Fee_ExpiryDate}
    ${Fee_DueDate}    Convert LIQ Date to Year-Month-Day Format    ${Fee_DueDate}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Fee_EffectiveDate    ${rowid}    ${Fee_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Fee_ExpiryDate    ${rowid}    ${Fee_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Fee_DueDate    ${rowid}    ${Fee_DueDate}    ${ComSeeDataSet}
    
    ###Accrual Tab - Get Total Accrued to Date
    ${IssuanceFee_AccruedToDate}    Get Issuance Accrued to Date Amount
    ${IssuanceFee_AccruedToDate}    Remove Comma and Convert to Number    ${IssuanceFee_AccruedToDate}
    # ${TotalRowCount}    Get Accrual Row Count    ${LIQ_BankGuarantee_Window}    ${LIQ_BankGuarantee_Accrual_JavaTree}
    # ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_SBLCGuarantee_Window_Tab}    ${LIQ_BankGuarantee_Accrual_JavaTree}
    # ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    # Validate Accrued to Date Amount    ${AccruedtoDateAmt}    ${IssuanceFee_AccruedToDate}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Fee_AccruedToDate    ${rowid}    ${IssuanceFee_AccruedToDate}    ${ComSeeDataSet}
    
    ${IssuanceFee_PaidToDate}    Get Issuance Paid to Date Amount
    ${IssuanceFee_PaidToDate}    Remove Comma and Convert to Number    ${IssuanceFee_PaidToDate}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Fee_PaidToDate    ${rowid}    ${IssuanceFee_PaidToDate}    ${ComSeeDataSet}
    
    Logout from Loan IQ
    
Update Line Fee Cycle - Scenario 7 ComSee
    [Documentation]    This keyword will update the existing commitment fee cycle in the created deal
    ...    @author: rtarayao    12SEP2019    - Duplicate from scenario 7 for Comsee use
    [Arguments]    ${ExcelPath}
    ###LoanIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - Summary Tab###  
    ${Fee_Alias}    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type1]
    
    ###Commitment Fee Notebook - General Tab###  
    ${AdjustedDueDate}    Update Cycle on Line Fee   &{ExcelPath}[Fee_Cycle]
    
    ${ScheduleActivity_FromDate}    Subtract Days to Date    ${AdjustedDueDate}    30
    ${ScheduledActivity_ThruDate}    Add Days to Date    ${AdjustedDueDate}    30
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    ScheduleActivity_FromDate    ${rowid}    ${ScheduleActivity_FromDate}    ${ComSeeDataSet}    
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    ScheduledActivity_ThruDate    ${rowid}    ${ScheduledActivity_ThruDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    FeePayment_EffectiveDate    ${rowid}    ${SystemDate}    ${ComSeeDataSet}
    Run Online Acrual to Line Fee
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Pay Line Fee Amount - Scenario 7 ComSee
    [Documentation]    This keyword will pay Commitment Fee Amount on a deal
    ...    @author: rtarayao    13SEP2019    - Duplicate high level keyword from Scenario 7 to be used for Comsee
    ...    @update: cfrancis    01OCT2020    - Added getting overpayment field for computing projected cycle due
    ...    @update: cfrancis    05OCT2020    - Added handling when overpayment field is empty in the dataset
    [Arguments]    ${ComSeeDataSet}    
    ###Return to Scheduled Activity Fiter###
    ${SystemDate}    Get System Date
    Set Global Variable    ${SystemDate}        
    Navigate to Scheduled Activity Filter

    ###Scheduled Activity Filter###
    Set Scheduled Activity Filter    &{ComSeeDataSet}[ScheduleActivity_FromDate]    &{ComSeeDataSet}[ScheduledActivity_ThruDate]    &{ComSeeDataSet}[ScheduledActivity_Department]    &{ComSeeDataSet}[ScheduledActivity_Branch]    &{ComSeeDataSet}[Deal_Name]

    ###Scheduled Activity Report Window###
    Select Fee Due    &{ComSeeDataSet}[ScheduledActivityReport_FeeType]    &{ComSeeDataSet}[ScheduledActivityReport_Date]    &{ComSeeDataSet}[Facility_Name]
    
    ###Line Fee Notebook - General Tab###  
    # ${ProjectedCycleDue}    Compute Line Fee Amount Per Cycle    &{ComSeeDataSet}[PrincipalAmount]    &{ComSeeDataSet}[RateBasis]    &{ComSeeDataSet}[CycleNumber]    ${SystemDate}
    ${ProjectedCycleDue}    ${Rate}    ${RateBasis}    ${BalanceAmount}    Compute Line Fee Amount Per Cycle    &{ComSeeDataSet}[CycleNumber]    ${SystemDate}
    
    ###Cycles for Line Fee###
    # Select Cycle Fee Payment
    Select Latest Cycle Due Line Fee Payment
    
    ###Ongoing Fee Payment Notebook - General Tab###
    ${ProjectedCycleDue}    Run Keyword If    '&{ComSeeDataSet}[OverPayment]'!='${EMPTY}'    Evaluate    ${ProjectedCycleDue} + &{ComSeeDataSet}[OverPayment]
    ...    ELSE    Set Variable    ${ProjectedCycleDue}
    Enter Effective Date for Ongoing Fee Payment    ${SystemDate}    ${ProjectedCycleDue}
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Cashflow - Ongoing Fee
    Verify if Method has Remittance Instruction    &{ComSeeDataSet}[Borrower1_ShortName]    &{ComSeeDataSet}[Borrower1_RTGSRemittanceDescription]    &{ComSeeDataSet}[Borrower1_RTGSRemittanceInstruction]
    Verify if Status is set to Do It    &{ComSeeDataSet}[Borrower1_ShortName]  
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ComSeeDataSet}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${ProjectedCycleDue}    &{ComSeeDataSet}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ComSeeDataSet}[Host_Bank]    Credit Amt
    ${Borrower_Debit}    Get GL Entries Amount    &{ComSeeDataSet}[Borrower1_ShortName]    Debit Amt
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
    Select Item in Work in Process    Payments    Awaiting Approval    Ongoing Fee Payment     &{ComSeeDataSet}[Facility_Name]

    ###Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    ###Generation of Intent Notice is skipped - Customer Notice Method must be updated###
    Select Item in Work in Process    Payments    Release Cashflows    Ongoing Fee Payment     &{ComSeeDataSet}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Release Cashflows    
    Release Cashflow    &{ComSeeDataSet}[Borrower1_ShortName]    release           
    Release Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ComSeeDataSet}[Deal_Name]

    ###Deal Notebook - Summary Tab### 
    Open Ongoing Fee from Deal Notebook    &{ComSeeDataSet}[Facility_Name]    &{ComSeeDataSet}[Fee_Type1]
    
    ###Line Fee Notebook - Acrual Tab###   
    # Validate Details on Acrual Tab - Line Fee    ${ProjectedCycleDue}    &{ComSeeDataSet}[CycleNumber]
    Validate Release of Ongoing Line Fee Payment
    Validate GL Entries for Ongoing Line Fee Payment - Bilateral Deal    &{ComSeeDataSet}[Host_Bank]    &{ComSeeDataSet}[Borrower1_ShortName]    ${ProjectedCycleDue}    
    
    Close All Windows on LIQ
    Logout from Loan IQ
    
Create Cycle Share Adjustment for Fee Accrual - Scenario 7 ComSee
    [Documentation]    This keyword is for creating cycle share adjustment for Bilateral Deal (MTAM06B).
    ...    @author: cfrancis    28SEP2020    - Initial create
    [Arguments]    ${ExcelPath}
   
    ###Launch Facility Notebook###
    ${SystemDate}    Get System Date
    ${FacilityName}    Read Data From Excel    ComSee_SC7_FacFeeSetup    Facility_Name    ${rowid}    ${ComSeeDataSet}
    ${DealName}    Read Data From Excel    ComSee_SC7_Deal    Deal_Name    ${rowid}    ${ComSeeDataSet} 
    Launch Existing Facility    ${DealName}    ${FacilityName}
    
    ###Navigate to Line Fee Notebook
    ${LineFee}    Read Data From Excel    ComSee_SC7_FacFeeSetup    OngoingFee_Type1    ${rowid}    ${ComSeeDataSet}
    Navigate to Commitment Fee Notebook    ${LineFee}
    
    ${StartDate}    ${EndDate}    ${DueDate}    ${CycleDue}    ${ProjectedCycleDue}    ${Orig_TotalCycleDue}    ${Orig_TotalManualAdjustment}    ${Orig_TotalProjectedEOCAccrual}    Navigate Line Fee and Verify Accrual Tab    ${rowid}    1    # &{ExcelPath}[CycleNo]
    
    ###Accrual Share Adjustment Notebook###
    Navigate Line Fee and Verify Accrual Share Adjustment Notebook    ${StartDate}    ${DealName}    ${FacilityName}    ${LineFee}    ${CycleDue}    ${ProjectedCycleDue}
    ${RequestedAmount}    Evaluate    ${CycleDue} - 10
    Input Requested Amount, Effective Date, and Comment    ${RequestedAmount}    ${StartDate}     Adjustment
    Save the Requested Amount, Effective Date, and Comment    ${RequestedAmount}    ${StartDate}     Adjustment
    
    ###Accrual Share Adjustment Notebook - Workflow Items (INPUTTER)###
    Send Adjustment to Approval
    Logout from Loan IQ
    
    ###Accrual Share Adjustment Notebook - Workflow Items (APPROVER)###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Facilities    Awaiting Approval    Fee Accrual Shares Adjustment     ${FacilityName}
    Approve Fee Accrual Shares Adjustment
    Logout from Loan IQ
    
    ###Accrual Share Adjustment Notebook - Workflow Items (APPROVER2)###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Facilities    Awaiting Release    Fee Accrual Shares Adjustment     ${FacilityName}
    Release Fee Accrual Shares Adjustment
    Close Accrual Shares Adjustment Window
    Logout from Loan IQ
    
Create Payment Reversal - Scenario 7 ComSee
    [Documentation]    This keyword initiates payment reversal after Fee Payment is released.
    ...    @author: cfrancis    01OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Launch Facility Notebook###
    ${SystemDate}    Get System Date
    ${FacilityName}    Read Data From Excel    ComSee_SC7_FacFeeSetup    Facility_Name    ${rowid}    ${ComSeeDataSet}
    ${DealName}    Read Data From Excel    ComSee_SC7_Deal    Deal_Name    ${rowid}    ${ComSeeDataSet} 
    Launch Existing Facility    ${DealName}    ${FacilityName}
    
    ###Navigate to Line Fee Notebook###
    ${LineFee}    Read Data From Excel    ComSee_SC7_FacFeeSetup    OngoingFee_Type1    ${rowid}    ${ComSeeDataSet}
    Navigate to Commitment Fee Notebook    ${LineFee}
    
    ###Line Fee Reversal Creation###
    ${ProjectedCycleDue}    Create Line Fee Payment Reversal
    Navigate to Cashflow - Reverse Fee
    ${Borrower}    Read Data From Excel    ComSee_SC7_OngoingFeePayment    Borrower1_ShortName    ${rowid}    ${ComSeeDataSet}
    ${RIDescrption}    Read Data From Excel    ComSee_SC7_OngoingFeePayment    Borrower1_RTGSRemittanceDescription    ${rowid}    ${ComSeeDataSet}
    ${RemittanceInstruction}    Read Data From Excel    ComSee_SC7_OngoingFeePayment    Borrower1_RTGSRemittanceInstruction    ${rowid}    ${ComSeeDataSet}
    Verify if Method has Remittance Instruction    ${Borrower}    ${RIDescrption}    ${RemittanceInstruction}
    Verify if Status is set to Do It    ${Borrower}
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankSharePct}    Read Data From Excel    ComSee_SC7_OngoingFeePayment    HostBankSharePct    ${rowid}    ${ComSeeDataSet}  
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    ${Borrower}
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${ProjectedCycleDue}    ${HostBankSharePct}
    
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
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${ProjectedCycleDue}
    Send Reverse Fee Payment to Approval
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ###Work In Process Window###
    Select Item in Work in Process    Payments    Awaiting Approval    Reverse Fee Payment     ${FacilityName}

    ###Reverse Fee Payment Notebook - Workflow Tab### 
    Approve Reverse Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    ###Release Reverse Fee Payment###       
    Select Item in Work in Process    Payments    Awaiting Release Cashflows   Reverse Fee Payment     ${FacilityName}
    Navigate Notebook Workflow    ${LIQ_ReverseFee_Window}    ${LIQ_LineFee_ReversePayment_Tab}    ${LIQ_LineFee_ReversePayment_WorkflowItems}    Release Cashflows   
    Release Cashflow    ${Borrower}    release    
    Release Reverse Fee Payment
    Close All Windows on LIQ
    Logout from Loan IQ