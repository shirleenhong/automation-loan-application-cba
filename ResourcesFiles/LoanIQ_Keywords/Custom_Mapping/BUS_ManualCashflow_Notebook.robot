*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate to Manual Cashflow Select
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create
    ...    @update: hstone    13JUL2020    - Moved from 'BUS_IncomingManualCashflow_Notebook.robot' to 'BUS_ManualCashflow_Notebook.robot'

    Run Keyword   Navigate to Manual Cashflow Select    ${ARGUMENT_1}    ${ARGUMENT_2}