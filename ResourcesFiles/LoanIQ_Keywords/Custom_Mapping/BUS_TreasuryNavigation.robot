*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
BUS_Get Base Rate from Funding Rate Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    09JUN2020    - initial create

    Run Keyword   Get Base Rate from Funding Rate Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}