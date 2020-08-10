*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Enter Upfront Fee Distribution Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Enter Upfront Fee Distribution Details    ${ARGUMENT_1}    ${ARGUMENT_2}
    

BUS_Enter Fee Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Enter Fee Details    ${ARGUMENT_1}
    

BUS_Approve Upfront Fee Distribution
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Approve Upfront Fee Distribution
    

BUS_Release Upfront Fee Distribution
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Release Upfront Fee Distribution
    

BUS_Navigate Notebook Workflow in Distribute Upfront Fee Payment Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    10JUN2020    - initial create

    Run Keyword   Navigate Notebook Workflow in Distribute Upfront Fee Payment Notebook    ${ARGUMENT_1}