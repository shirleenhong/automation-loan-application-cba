*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Set Automated Transactions in Table Maintenance
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: jloretiz    28JUL2020    - initial create

    Run Keyword    Set Automated Transactions in Table Maintenance    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Validate Transaction Type in Automated Transactions in Table Maintenance
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: jloretiz    28JUL2020    - initial create

    Run Keyword    Validate Transaction Type in Automated Transactions in Table Maintenance    ${ARGUMENT_1}    ${ARGUMENT_2}