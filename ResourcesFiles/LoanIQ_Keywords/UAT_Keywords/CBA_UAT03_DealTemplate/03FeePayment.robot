*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Collect Break Cost Fee for Early Prepayment D00000476
    [Documentation]    This Keyword initiates Interest Payment of the specified Loan
    ...    @author: ritragel    10SEP2019
    [Arguments]    ${ExcelPath}
    
    ###Login to Original User###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    #LIQ Window
    Search Deal    &{ExcelPath}[Deal_Name]

    #Existing Loans for Facility
    Search Loan   &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    
    #Breakfunding Notebook
    Navigate Breakfunding Fee Notebook    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Pricing_Option_From_Breakfunding]    
    ...    &{ExcelPath}[Currency]
    Request Lender Fees
    Generate Lender Shares for Bilateral Deal    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Legal_Entity_Amount]
    Add Portfolio and Expense Code    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Legal_Entity_Amount]    &{ExcelPath}[Expense_Code]
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction] 
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Legal_Entity_Amount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}   ${ComputedHBTranAmount}
    Create Cashflow     &{ExcelPath}[Borrower_ShortName]    release

    ### Send Fee to Approval
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_USERNAME}
    Select Item in Work in Process    Payments    Awaiting Approval    Break Cost Fee     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Approval 
    
    ### Approve and Release Breakfunding Fee
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Break Cost Fee     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Release

    Close All Windows on LIQ

Collect Extension Fee for D00000476
    [Documentation]    This keyword creates an Upfront Fee for a deal.
    ...    @author: ritragel    25SEP2019    Initial Create     
    ...    @Update: aramos      10OCT2020    Update to Release Cashflows  
    [Arguments]    ${ExcelPath}
    
    ### Approve and Release Breakfunding Fee
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Populate Upfront Fee Payment Notebook    &{Excelpath}[UpfrontFee_Amount]    &{Excelpath}[EstablishmentFee_EffectiveDate]        
    Populate Fee Details Window    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[UpfrontFeePayment_Comment]
    
    ###Upfront Fee Payment Workflow Tab- Create Cashflow Item###
    Navigate Notebook Workflow    ${LIQ_UpfrontFeePayment_Notebook}    ${LIQ_UpfrontFeePayment_Tab}    ${LIQ_UpfrontFeePayment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Create Cashflow    &{ExcelPath}[Borrower_ShortName]    release     
 
    ###Upfront Fee Payment Workflow Tab- Send to Approval Item###
    Send to Approval Upfront Fee Payment    
    
    ###Upfront Fee Payment Workflow Tab- Approval Item###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}   ${SUPERVISOR_PASSWORD}
    Navigate to Payment Notebook via WIP    Payments    Awaiting Approval    Fee Payment From Borrower    &{ExcelPath}[Deal_Name]    
    Approve Upfront Fee Payment
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_UpfrontFeePayment_Tab}    ${LIQ_UpfrontFeePayment_WorkflowItems}    Release Cashflows
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_UpfrontFeePayment_Tab}    ${LIQ_UpfrontFeePayment_WorkflowItems}    Release
