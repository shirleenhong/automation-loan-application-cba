*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate to Loan Increase from Loan Notebook
    [Documentation]    This keyword is used to open Loan Increase from Loan notebook
    ...    @author: mcastro    19JAN2021    - Initial create

    Mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ click element if present    ${LIQ_Loan_InquiryMode_Button}
    Mx LoanIQ select    ${LIQ_Loan_Options_Increase}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease 
    Mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Input General Loan Increase Details
    [Documentation]    This keyword is used to input details on Loan Increase General tab
    ...    @author: mcastro    19JAN2021    - Initial create
    [Arguments]    ${iRequested_Amt}    ${sEffective_Date}    ${sReason}=None
    
    ### Keyword Pre-processing ###
    ${Requested_Amt}    Acquire Argument Value    ${iRequested_Amt}
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
    ${Reason}    Acquire Argument Value    ${sReason}

    Mx LoanIQ activate window    ${LIQ_Increase_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Increase_Window_Tab}    ${GENERAL_TAB} 
    Mx LoanIQ enter    ${LIQ_Increase_Requested_Amt_Text}    ${Requested_Amt} 
    Mx LoanIQ enter    ${LIQ_Increase_EffectiveDate_Text}    ${Effective_Date} 
    Run Keyword If    '${Reason}'!='None'    Mx LoanIQ enter    ${LIQ_Increase_Reason_Text}    ${Reason}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease_GeneralTab

Navigate to Create Cashflow for Loan Increase
    [Documentation]    This keyword is used to navigate Create Cashflow in Loan Increase
    ...    @author: mcastro    19JAN2021   - Initial create

    Mx LoanIQ Activate Window    ${LIQ_Increase_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Increase_Window_Tab}    ${WORKFLOW_TAB}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease_WorkflowTab
    Mx LoanIQ DoubleClick    ${LIQ_Increase_Workflow_Javatree}    ${CREATE_CASHFLOWS_TYPE}    
    Validate if Question or Warning Message is Displayed
    Mx LoanIQ Activate Window    ${LIQ_Cashflows_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease_CashflowWindow

Navigate to Loan Increase Workflow and Proceed with Transaction
    [Documentation]    This keyword is used to navigate to workflow tab and proceed with transaction
    ...    @author: mcastro    19JAN2021    - Initial create
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Mx LoanIQ activate window    ${LIQ_Increase_Window}   
    Mx LoanIQ Select Window Tab    ${LIQ_Increase_Window_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease_WorkflowTab
    
    ${Status}    Run Keyword and Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_Increase_Workflow_Javatree}    ${Transaction}
    Run Keyword If    ${Status}==${True}    Log    ${Transaction} is displayed in Loan Increase workflow
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${Transaction} is not displayed in Loan Increase workflow

    Mx LoanIQ DoubleClick    ${LIQ_Increase_Workflow_Javatree}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease_Workflow
    Validate if Question or Warning Message is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease_Workflow

Validate Release of Loan Increase
    [Documentation]    This keyword validates the Released status of Loan Increase
    ...    @author: mcastro    19JAN2021    - Initial Create
    
    Mx LoanIQ activate window    ${LIQ_Increase_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Increase_Window_Tab}    ${EVENTS_TAB}
    ${Event_Selected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_Increase_Events_Javatree}    ${RELEASED_STATUS}
    Run Keyword If    ${Event_Selected}==${True}    Log    ${RELEASED_STATUS} is shown in the Events list of the Loan Increase notebook.
    ...    ELSE    Run Keyword and Continue on Failure    Fail    Loan Increase is not Released.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease_EventsTab

Validate Loan Increase Details in General Tab
    [Documentation]    This keyword validates the amounts of Loan Increase in general tab
    ...    @author: mcastro    19JAN2021    - Initial Create
    [Arguments]    ${iExpected_Outstanding}    ${iExpected_RequestedAmt}    ${iExpectedActual_Amt}

    ### Keyword Pre-processing ###
    ${Expected_Outstanding}    Acquire Argument Value    ${iExpected_Outstanding}
    ${Expected_RequestedAmt}    Acquire Argument Value    ${iExpected_RequestedAmt}
    ${ExpectedActual_Amt}    Acquire Argument Value    ${iExpectedActual_Amt}
    
    Mx LoanIQ activate window    ${LIQ_Increase_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Increase_Window_Tab}    ${GENERAL_TAB}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease_GeneralTab

    ### Outstanding amount ###
    ${Outstanding_Amount}    Mx LoanIQ Get Data    ${LIQ_Increase_Outstanding_Amt_Field}    value%Amount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${Outstanding_Amount}    ${Expected_Outstanding}
    Run Keyword If    ${Status}==${True}    Log    Outstanding amount is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Outstanding amount is incorrect. Expected: ${Expected_Outstanding} - Actual: ${Outstanding_Amount}

    ### Requested amount ###
    ${Requested_Amount}    Mx LoanIQ Get Data    ${LIQ_Increase_Requested_Amt_Text}    value%Amount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${Requested_Amount}    ${Expected_RequestedAmt}
    Run Keyword If    ${Status}==${True}    Log    Requested amount is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Requested amount is incorrect. Expected: ${Expected_RequestedAmt} - Actual: ${Requested_Amount}

    ### Actual amount ###
    ${Actual_Amount}    Mx LoanIQ Get Data    ${LIQ_Increase_Actual_Amt_Field}    value%Amount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${Actual_Amount}    ${ExpectedActual_Amt}
    Run Keyword If    ${Status}==${True}    Log    Actual amount is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Actual amount is incorrect. Expected: ${ExpectedActual_Amt} - Actual: ${Actual_Amount}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIncrease_GeneralTab