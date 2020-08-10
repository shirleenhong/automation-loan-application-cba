*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Enter Interest Capitalization Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    28MAY2020    - initial create

    Run Keyword    Enter Interest Capitalization Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    ...    ${ARGUMENT_6}


BUS_Enter Capitalize Interest Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    28MAY2020    - initial create

    Run Keyword    Enter Capitalize Interest Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}


BUS_Validate Capitalize Interest Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    28MAY2020    - initial create

    Run Keyword    Validate Capitalize Interest Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}