*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_GLOffset Interest Income Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:    sahalder    24JUL2020    - initial create

    Run Keyword   GLOffset Interest Income Details    ${ARGUMENT_1}
    
BUS_Verification of Portfolio Selection Discount Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author:    sahalder    27JUL2020    - initial create

    Run Keyword   Verification of Portfolio Selection Discount Change Transaction