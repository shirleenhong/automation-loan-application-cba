*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Create Line Fee Capitalization Rule
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07OCT2020    - initial create

    Run Keyword    Create Line Fee Capitalization Rule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    ...    ${ARGUMENT_6}

BUS_Validate Capitalized Line Fee details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07OCT2020    - initial create

    Run Keyword    Validate Capitalized Line Fee details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Save and Exit Line Fee Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    07OCT2020    - initial create

    Run Keyword    Save and Exit Line Fee Notebook

BUS_Navigate to Existing Ongoing Fee Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16OCT2020    - initial create

    Run Keyword   Navigate to Existing Ongoing Fee Notebook    ${ARGUMENT_1}

BUS_Initiate Line Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16OCT2020    - initial create

    Run Keyword   Initiate Line Fee Payment    ${ARGUMENT_1}

BUS_Close Fee Payment Notice Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16OCT2020    - initial create

    Run Keyword   Close Fee Payment Notice Window

BUS_Validate Release of Ongoing Line Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    16OCT2020    - initial create

    Run Keyword   Validate Release of Ongoing Line Fee Payment
