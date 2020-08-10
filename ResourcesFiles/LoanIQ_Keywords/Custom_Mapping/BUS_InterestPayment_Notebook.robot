*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate to the Scheduled Activity Filter
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Navigate to the Scheduled Activity Filter

BUS_Open Scheduled Activity Report
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Open Scheduled Activity Report    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Open Loan Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Open Loan Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Compute Interest Payment Amount Per Cycle - Zero Cycle Due
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Compute Interest Payment Amount Per Cycle - Zero Cycle Due    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Initiate Loan Interest Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Initiate Loan Interest Payment    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Input Effective Date and Requested Amount for Loan Interest Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Input Effective Date and Requested Amount for Loan Interest Payment    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Send Interest Payment to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Send Interest Payment to Approval

BUS_Open Interest Payment Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Open Interest Payment Notebook via WIP - Awaiting Approval    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Approve Interest Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Approve Interest Payment

BUS_Validate Interest Payment in Loan Accrual Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Validate Interest Payment in Loan Accrual Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Navigate to Payment Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    01JUN2020    - initial create

    Run Keyword    Navigate to Payment Workflow and Proceed With Transaction    ${ARGUMENT_1}

BUS_Compute Interest Payment Amount Per Cycle
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    06JUL2020    - initial create

    Run Keyword    Compute Interest Payment Amount Per Cycle    ${ARGUMENT_1}    ${ARGUMENT_2}