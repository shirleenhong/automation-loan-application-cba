*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Create Admin Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    16JUN2020    - initial create

    Run Keyword    Create Admin Fee Payment    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    

BUS_Navigate Notebook Workflow for Admin Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    16JUN2020    - initial create

    Run Keyword    Navigate Notebook Workflow for Admin Fee Payment    ${ARGUMENT_1}