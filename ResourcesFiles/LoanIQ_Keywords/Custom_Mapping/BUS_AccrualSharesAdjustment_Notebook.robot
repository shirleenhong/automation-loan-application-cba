*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Input Requested Amount, Effective Date, and Comment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Input Requested Amount, Effective Date, and Comment    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Save the Requested Amount, Effective Date, and Comment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Save the Requested Amount, Effective Date, and Comment    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Send Adjustment to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Send Adjustment to Approval

BUS_Approve Fee Accrual Shares Adjustment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Approve Fee Accrual Shares Adjustment

BUS_Release Fee Accrual Shares Adjustment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Release Fee Accrual Shares Adjustment

BUS_Close Accrual Shares Adjustment Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    15JUL2020    - initial create

    Run Keyword    Close Accrual Shares Adjustment Window

BUS_Navigate to Accruals Share Adjustment Notebook
    [Documentation]    This keyword will navigate the LIQ User to the Accruals Share Adjustment Notebook and validates the information displayed in the notebook.  
    ...    @author:clanding    27JUL2020    - initial create

    Run Keyword    Navigate to Accruals Share Adjustment Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}

BUS_Approve Cycle Share Adjustment
    [Documentation]    This keyword will approve the Cycle Share Adjustment.  
    ...    @author:clanding    27JUL2020    - initial create

    Run Keyword    Approve Cycle Share Adjustment

BUS_Release Cycle Share Adjustment
    [Documentation]    This keyword will approve the Cycle Share Adjustment.  
    ...    @author:clanding    27JUL2020    - initial create

    Run Keyword    Release Cycle Share Adjustment