*** Settings ***
Resource     ../../../../Configurations/Import_File.robot

*** Keywords ***
Initiate LC Collection D00000476
    [Documentation]    High-level keyword for LC Creation of UAT Deal 3 Template
    ...    @author: ritragel
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Verify if Standby Letters of Credit Exist    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    
    ###Letter of Credit Window###    
    Navigate Existing Standby Letters of Credit    &{ExcelPath}[SBLC_Alias]
    

    ###Cycles for Bank Guarantee Window###    
    ${ProjectedCycleDue}    Compute SBLC Issuance Fee Amount Per Cycle    &{ExcelPath}[CycleNumber]    &{ExcelPath}[SBLC_DueDate]
    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Computed_ProjectedCycleDue    &{ExcelPath}[rowid]    ${ProjectedCycleDue}    ${CBAUAT_ExcelPath}
    
    ###SBLC Guarantee Window###
    Navigate To Fees On Lender Shares
    Initiate Issuance Fee Payment    &{ExcelPath}[SBLC_Alias]    &{ExcelPath}[IssuanceFeePayment_EffectiveDate]
    ...    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Computed_ProjectedCycleDue]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    
    #Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Computed_ProjectedCycleDue]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Computed_ProjectedCycleDue]
    
    ### Send to Approval ###
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Send to Approval
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Approval    Issuance Fee Payment     &{ExcelPath}[Facility_Name]
    
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Approval
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]    release

    ### Release ###
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Issuance Fee Payment     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Release
    
