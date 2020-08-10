*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Admin Fee Payment
    [Documentation]    This keyword initiates an Admin Fee Payment from the Admin Fee Notebook.
    ...    @author: bernchua
    ...    @update: dahijara    06AUG2020    - Added screenshot. Added Tab action after entering date
    ...    @update: dahijara    07AUG2020    - updated argument name per standard
    [Arguments]    ${sDealName}    ${sAdminFeePayment_EffectiveDate}    ${sAdminFeePayment_Comment}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDealName}
    ${AdminFeePayment_EffectiveDate}    Acquire Argument Value    ${sAdminFeePayment_EffectiveDate}
    ${AdminFeePayment_Comment}    Acquire Argument Value    ${sAdminFeePayment_Comment}

    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_AdminFeeNotebook_InquiryMode_Button}    
    mx LoanIQ select    ${LIQ_AdminFee_Options_Payment}
    mx LoanIQ activate    ${LIQ_AdminFeePayment_Window}
    Verify If Text Value Exist as Static Text on Page    Admin Fee Payment    ${Deal_Name}
    ${AmountDue}    Mx LoanIQ Get Data    ${LIQ_AdminFeePayment_AmountDue_StaticText}    value%amount
    ${Requested}    Mx LoanIQ Get Data    ${LIQ_AdminFeePayment_Requested_Textfield}    value%amount
    Run Keyword If    '${AmountDue}'=='${Requested}'    Log    Amount Due and Requested is verified.
    mx LoanIQ enter    ${LIQ_AdminFeePayment_Effective_Datefield}    ${AdminFeePayment_EffectiveDate}
    Mx Press Combination    Key.TAB
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ enter    ${LIQ_AdminFeePayment_Comment_Textfield}    ${AdminFeePayment_Comment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledActivity
    mx LoanIQ select    ${LIQ_AdminFeePayment_File_Save}
    

Navigate Notebook Workflow for Admin Fee Payment
    [Documentation]    This keyword navigates the Workflow tab of a Notebook, and does a specific transaction.
    ...    
    ...    | Arguments |
    ...    
    ...    'Notebook_Locator' = Locator of the main Notebook window
    ...    'NotebookTab_Locator' = JavaTab locator of the Notebook
    ...    'NotebookWorkflow_Locator' = JavaTree locator of the Workflow object.
    ...    'Transaction' = The type of transaction listed under Workflow. Ex. Send to Approval, Approve, Release
    ...    
    ...    @author: sahalder    16JUN2020    initial create
    [Arguments]    ${s_Transaction}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${s_Transaction}

    mx LoanIQ activate window    ${LIQ_AdminFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeePayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AdminFeePayment_Workflow_Tree}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button} 
    
