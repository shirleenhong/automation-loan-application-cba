*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
    
BUS_Navigate to Manual GL
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Navigate to Manual GL    ${ARGUMENT_1}

BUS_New Manual GL Select
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   New Manual GL Select

BUS_Enter Manual GL Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Enter Manual GL Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Add Debit for Manual GL
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Add Debit for Manual GL    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    ...    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Add Credit for Manual GL
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Add Credit for Manual GL    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    ...    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Add Manual GL Transaction Description
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Add Manual GL Transaction Description    ${ARGUMENT_1}

BUS_Save Manual GL Changes
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Save Manual GL Changes

BUS_Send Manual GL to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Send Manual GL to Approval

BUS_Approve Manual GL
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Approve Manual GL

BUS_Open Existing Manual GL Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Open Existing Manual GL Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Release Manual GL
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Release Manual GL

BUS_Validate Debit Details at Manual GL Table
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Validate Debit Details at Manual GL Table    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate Credit Details at Manual GL Table
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Validate Credit Details at Manual GL Table    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate GL Entries
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUL2020    - initial create

    Run Keyword   Validate GL Entries    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Select Manual Transaction on Work in Process
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    21JUL2020    - initial create

    Run Keyword   Select Manual Transaction on Work in Process    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Validate Events Tab for Manual GL
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    21JUL2020    - initial create

    Run Keyword   Validate Events Tab for Manual GL