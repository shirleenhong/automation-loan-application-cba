*** Settings ***
Resource    ../../../../Configurations/Import_File.robot


*** Keywords ***
Collect Break Cost Fee for Early Prepayment D00000454
    [Documentation]    This Keyword initiates break cost fee of the specified Loan
    ...    @author: fmamaril    17SEP2019
    [Arguments]    ${ExcelPath}
    ###Login to Original User###
    Logout from LIQ
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
    Generate Lender Shares for Bilateral Deal    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Legal_Entity_Amount]
    Generate Lender Shares for Bilateral Deal    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Legal_Entity_Amount]
    Add Portfolio and Expense Code    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Legal_Entity_Amount]    &{ExcelPath}[Expense_Code]
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction] 
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Lender2_RemittanceDescription]    &{ExcelPath}[Lender2_RemittanceInstruction]
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[HostBank_LenderShare]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[Lender1_Share]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount with exact percentage    &{ExcelPath}[Loan_TotalGlobalInterest]    &{ExcelPath}[Lender2_Share]
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
    
    Create Cashflow     &{ExcelPath}[Borrower_ShortName]    release

    ### Send Fee to Approval
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Send to Approval
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Approval    Break Cost Fee     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_AwaitingApproval_Tab}    ${LIQ_Breakfunding_WorkflowItems_AwaitingApproval_List}    Approval 
    
    ### Approve and Release Breakfunding Fee
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Break Cost Fee     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_AwaitingRelease_Tab}    ${LIQ_Breakfunding_WorkflowItems_AwaitingRelease_List}    Release

    Close All Windows on LIQ
