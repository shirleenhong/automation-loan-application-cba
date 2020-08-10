*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Send to Approval Scheduled Commitment Decrease Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo	initial create

    Run Keyword    Send to Approval Scheduled Commitment Decrease Transaction   

BUS_Approval Scheduled Commitment Decrease Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dfajardo	initial create

    Run Keyword    Approval Scheduled Commitment Decrease Transaction    ${ARGUMENT_1}
    
