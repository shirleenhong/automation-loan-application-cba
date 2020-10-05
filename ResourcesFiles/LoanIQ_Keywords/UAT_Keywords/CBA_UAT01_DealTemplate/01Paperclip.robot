*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Collect Early Prepayment via Paper Clip D00000454
    [Documentation]    This Keyword creates a partial early payment via paperclip
    ...    @author: fmamaril    17SEP2019
    ...    @author: rjuarez    05Oct2020    Commented selection of remittance, remittance already been displayed and selected in  borrower&lender
    ...    @author: rjuarez    05Oct2020    Commented select breakfunding step, reason for breakfunding did not show for selection upon release workflow
    [Arguments]    ${ExcelPath}
    Logout from Loan IQ
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ## Search for Existing Loan
    ${Date}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    Loan    &{ExcelPath}[Facility_Name]
    Select Existing loan for Facility    &{ExcelPath}[Loan_Alias]
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    # Set Outstanding Servicing Group Details    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Instruction]
    # Set Outstanding Servicing Group Details    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceInstruction]
    # Set Outstanding Servicing Group Details    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Lender2_RemittanceInstruction]
    Initiate Paperclip payment via Outstanding Select    &{ExcelPath}[Loan_Alias]
    
    ### Initiate Paperclip Payment
    Select Payment in Choose a Payment Window    Paper Clip Payment
    Add Transaction to Pending Paperclip    ${Date}    $20M Early Prepayment
    Pause Execution
    Select Outstanding Item    &{ExcelPath}[Principal_Amount]
    Add Transaction Type    Principal    &{ExcelPath}[Loan_Alias]
    Add Transaction Type    Interest    null
    Select Cycles for Loan Item    Cycle Due    1
    Verify Added Paperclip Payments    &{ExcelPath}[Pricing_Option]${SPACE}(&{ExcelPath}[Loan_Alias])Principal|&{ExcelPath}[Pricing_Option]${SPACE}(&{ExcelPath}[Loan_Alias])Interest

    
    ## Create Cashflows for Paperclip ###
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Create Cashflow
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Lender2_RemittanceInstruction]    &{ExcelPath}[Lender2_RemittanceDescription]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]
     
    ### GL Entries Validation ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]

    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${BorrowerTranAmount}    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${BorrowerTranAmount}    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${BorrowerTranAmount}    &{ExcelPath}[LenderSharePct2]
    
    Create Cashflow     &{ExcelPath}[Borrower_ShortName]    release 
    
    ### Send Paperclip to Approval
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ### Approve Paperclip Transaction
    Select Item in Work in Process    Payments    Awaiting Approval    Paper Clip     &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Approval
    
    #### Release PaperClip
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Paper Clip     &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]
    Release Cashflow    &{ExcelPath}[Lender1_ShortName]
    Release Cashflow    &{ExcelPath}[Lender2_ShortName]    release    
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Release
    # Select Breakfunding Reason    Repricing Date Changed 
    Close All Windows on LIQ
    
Collect Full Payment via Paper Clip Outstanding B1 D00000454
    [Documentation]    This Keyword initiates full payment via paper clip
    ...    @author: fmamaril    17SEP2019
    [Arguments]    ${ExcelPath}
    
    ### Search for Existing Loan
    ${Date}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    Loan    &{ExcelPath}[Facility_Name]
    Select Existing loan for Facility    &{ExcelPath}[Loan_Alias]
    mx LoanIQ activate window    ${LIQ_Loan_Window}    
    Set Loan Servicing Group Details    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Instruction]
    Set Loan Servicing Group Details    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceInstruction]
    Select Menu Item    ${LIQ_Loan_Window}    Options    Payment
    
    ### Initiate Paperclip Payment
    Select Payment in Choose a Payment Window    Paper Clip Payment
    Add Transaction to Pending Paperclip    ${Date}    $10M Full Repayment
    Select Outstanding Item    &{ExcelPath}[Loan_Alias]
    Add Transaction Type    Principal    &{ExcelPath}[Loan_RequestedAmount]
    Add Transaction Type    Interest    null
    Select Cycles for Loan Item    Pro Rate Shares based on Partial Principal Prepayment    1
    Verify Added Paperclip Payments    &{ExcelPath}[Pricing_Option]${SPACE}(&{ExcelPath}[Loan_Alias])Principal|&{ExcelPath}[Pricing_Option]${SPACE}(&{ExcelPath}[Loan_Alias])Interest

    
    ## Create Cashflows for Paperclip ###
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Create Cashflow
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender_RemittanceDescription]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
     
    ### GL Entries Validation ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]

    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${BorrowerTranAmount}    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount with exact percentage    ${BorrowerTranAmount}    &{ExcelPath}[LenderSharePct1]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}
    Create Cashflow     &{ExcelPath}[Borrower_ShortName]    release 
    
    ### Send Paperclip to Approval
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ### Approve Paperclip Transaction
    Select Item in Work in Process    Payments    Awaiting Approval    Paper Clip     &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Approval
    
    #### Release PaperClip
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Paper Clip     &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]
    Release Cashflow    &{ExcelPath}[Lender1_ShortName]    release    
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    Release
    Close All Windows on LIQ  
