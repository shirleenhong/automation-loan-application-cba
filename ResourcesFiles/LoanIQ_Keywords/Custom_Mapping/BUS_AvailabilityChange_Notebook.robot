*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Validate Availability Change
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    14JUL2020    - initial create
    Run Keyword    Validate Availability Change    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Release Availability Change
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    14JUL2020    - initial create
    Run Keyword    Release Availability Change    ${ARGUMENT_1}
    
BUS_Approve Availability Change
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    14JUL2020    - initial create
    Run Keyword    Approve Availability Change    ${ARGUMENT_1}
    
BUS_Send to Approval Availability Change
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    14JUL2020    - initial create
    Run Keyword    Send to Approval Availability Change
    
BUS_Add Changes in Availability Change General Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    14JUL2020    - initial create
    Run Keyword    Add Changes in Availability Change General Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Add Availability Change
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    14JUL2020    - initial create
    Run Keyword    Add Availability Change
    
BUS_Add Availability Change and Fetch Current Facility Commitment Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    17JUL2020    - initial create
    Run Keyword    Add Availability Change and Fetch Current Facility Commitment Amount