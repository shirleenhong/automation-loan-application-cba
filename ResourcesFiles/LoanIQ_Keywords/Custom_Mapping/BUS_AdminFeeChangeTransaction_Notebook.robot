*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Set Admin Fee Change Transaction General Tab Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUN2020    - initial create

    Run Keyword    Set Admin Fee Change Transaction General Tab Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Navigate to Admin Fee Change Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    15JUN2020    - initial create

    Run Keyword    Navigate to Admin Fee Change Workflow and Proceed With Transaction    ${ARGUMENT_1}