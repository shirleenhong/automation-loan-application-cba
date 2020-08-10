*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***

BUS_Get System Date
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    29APR2020    - initial create

    Run Keyword    Get System Date    ${ARGUMENT_1}

BUS_Convert Number With Comma Separators
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    29APR2020    - initial create

    Run Keyword    Convert Number With Comma Separators    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Remove Comma and Convert to Number
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    29APR2020    - initial create

    Run Keyword    Remove Comma and Convert to Number    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Compare Two Numbers
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19MAY2020    - initial create

    Run Keyword    Compare Two Numbers    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Add Time from From Date and Returns Weekday
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUN2020    - initial create

    Run Keyword    Add Time from From Date and Returns Weekday    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Validate Window Title Status
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUN2020    - initial create

    Run Keyword    Validate Window Title Status    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Select Actions
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Select Actions    ${ARGUMENT_1}    