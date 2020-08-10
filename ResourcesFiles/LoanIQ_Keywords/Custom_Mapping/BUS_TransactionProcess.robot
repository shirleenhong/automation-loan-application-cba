*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate Transaction in WIP
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Navigate Transaction in WIP    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Open Deal Scheduled Activity Report
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Open Deal Scheduled Activity Report    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Open Transaction In Scheduled Activity Report
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    27APR2020    - initial create

    Run Keyword   Open Transaction In Scheduled Activity Report    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}