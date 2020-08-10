*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Send to Approval Scheduled Commitment Decrease Transaction
    [Documentation]    This keyword sends the Scheduled Commitment Decrease Transaction for approval
    ...    @author: ghabal
    ...    @author: dfajardo    22JUL2020    - Added Screenshot
    Mx LoanIQ Select Window Tab    ${LIQ_ScheduledCommitmentDecrease_AwaitingSendtoApprovalTab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ScheduledCommitmentDecrease_AwaitingSendtoApprovalWorkflowList}    Send to Approval%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
     Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledCommitmentDecreaseNotebook_AwaitingSendtoApproval   

Approval Scheduled Commitment Decrease Transaction
    [Documentation]    This keyword approves the Scheduled Commitment Decrease Transaction
    ...    @author: ghabal
    ...    @update: fmamaril    24APR2019    Steps for Question and Warning message box are now mandatory   
    ...    @update: hstone    20AUG2019    Checking for Warning and Question Windows if existing 
    ...    @update: hstone    23AUG2019    Added Take Screenshot for Scheduled Commitment Decrease General Tab
    ...    @update: dfajardo    22JUL2020    Added pre processing keywords and Screenshot
    [Arguments]    ${sDeal_Name}
    
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    Select Actions    [Actions];Work In Process
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    Facilities    
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Approval
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Scheduled Commitment Decrease
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Deal_Name}
    mx LoanIQ activate    ${LIQ_ScheduledCommitmentDecrease_AwaitingApprovalWindow}
     Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledCommitmentDecreaseNotebook_GeneralTab  
    Mx LoanIQ Select Window Tab    ${LIQ_ScheduledCommitmentDecrease_AwaitingApprovalTab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ScheduledCommitmentDecrease_AwaitingApprovalWorkflowList}    Approval%d
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Question_Yes_Button}    VerificationData="Yes"
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Question_Yes_Button}    VerificationData="Yes"
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Release Scheduled Commitment Decrease Transaction
    [Documentation]    This keyword releases the Scheduled Commitment Decrease Transaction
    ...    @author: ghabal
    ...    @update: dfajardo    22JUL2020    Added pre processing keywords and screenshot
    [Arguments]    ${sDeal_Name}
    
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    Select Actions    [Actions];Work In Process
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    Facilities    
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Scheduled Commitment Decrease
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Deal_Name}
    mx LoanIQ activate    ${LIQ_ScheduledCommitmentDecrease_AwaitingReleaseWindow}
    Mx LoanIQ Select Window Tab    ${LIQ_ScheduledCommitmentDecrease_AwaitingReleaseTab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ScheduledCommitmentDecrease_AwaitingReleaseWorkflowList}    Release%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}        
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledCommitmentDecreaseNotebook_GeneralTab 
    
    Mx LoanIQ Verify Object Exist    ${LIQ_ScheduledCommitmentDecrease_Released_WorkflowNoItems}    VerificationData="Yes"
    mx LoanIQ select    ${LIQ_ScheduledCommitmentDecrease_Released_FileExitMenu}
    mx LoanIQ activate    ${LIQ_TransactionInProcess_Window}
    mx LoanIQ select    ${LIQ_TransactionsInProcess_FileExit_Menu}
    
    

