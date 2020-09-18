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