*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variable ***
${sCurrency}

*** Keywords ***
Collect Early Prepayment via Paper Clip D00000476
    [Arguments]    ${ExcelPath}
    
    Logout from LIQ
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Search for Existing Loan
    ${Date}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    Loan    &{ExcelPath}[Facility_Name]
    Initiate Paperclip payment via Outstanding Select    &{ExcelPath}[Loan_Alias]
    
    ### Initiate Paperclip Payment   
    Select Payment in Choose a Payment Window    Paper Clip Payment
    Add Transaction to Pending Paperclip    ${Date}    &{ExcelPath}[Principal_Amount] Early Prepayment
    Select Outstanding Item    &{ExcelPath}[Loan_Alias]
    Add Transaction Type    Principal    &{ExcelPath}[Principal_Amount]
    Add Transaction Type    Interest    null
    Select Cycles for Loan Item    &{ExcelPath}[Loan_ProrateWith]    &{ExcelPath}[Loan_CycleNumber]
    Verify Added Paperclip Payments    &{ExcelPath}[Pricing_Option]${SPACE}(&{ExcelPath}[Loan_Alias])Principal|&{ExcelPath}[Pricing_Option]${SPACE}(&{ExcelPath}[Loan_Alias])Interest

    
    ### Create Cashflows for Paperclip ###
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Create Cashflow
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ${iTotalAmount}    Add Principal and Borrower Transaction Amount    &{ExcelPath}[Principal_Amount]    &{ExcelPath}[Interest_Amount]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${iTotalAmount}    &{ExcelPath}[HostBankSharePct]
    Compare UIAmount versus Computed Amount    ${HostBankShare}   ${ComputedHBTranAmount}
    Create Cashflow     &{ExcelPath}[Borrower_ShortName]    release 
    
    ### Send Paperclip to Approval
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Send to Approval
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ### Approve Paperclip Transaction
    Select Item in Work in Process    Payments    Awaiting Approval    Paper Clip     &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Approval
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]    release
    
    #### Release PaperClip
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Paper Clip     &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Release
    Run Keyword If    &{ExcelPath}[rowid] < 3    Select Breakfunding Reason    Repricing Date Changed 
    Close All Windows on LIQ  
