*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Validate Portfolio Transfer Using Expense Code
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    13JUL2020    - initial create

    Run Keyword   Validate Portfolio Transfer Using Expense Code    ${ARGUMENT_1}

BUS_Get Remaining Facility Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    13JUL2020    - initial create

    Run Keyword   Get Remaining Facility Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Add Portfolio Transfer
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    13JUL2020    - initial create

    Run Keyword   Add Portfolio Transfer    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}

BUS_Send Portfolio Transfer to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    13JUL2020    - initial create

    Run Keyword   Send Portfolio Transfer to Approval

BUS_Release Portfolio Transfer
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    13JUL2020    - initial create

    Run Keyword   Release Portfolio Transfer

BUS_Validate Portfolio Transfer in Lender Share
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    13JUL2020    - initial create

    Run Keyword   Validate Portfolio Transfer in Lender Share    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}