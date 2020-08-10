*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Add Financial Ratio Deal Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    22MAY2020    - initial create
    Run Keyword    Add Financial Ratio Deal Change Transaction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    

BUS_Send Approval Deal Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    22MAY2020    - initial create
    Run Keyword    Send Approval Deal Change Transaction    ${ARGUMENT_1}
    
BUS_Approve Deal Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    22MAY2020    - initial create
    Run Keyword    Approve Deal Change Transaction
    
BUS_Release Deal Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    22MAY2020    - initial create
    Run Keyword    Release Deal Change Transaction
    
BUS_Validate added financial ratio on the deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    22MAY2020    - initial create
    Run Keyword    Validate added financial ratio on the deal    ${ARGUMENT_1}  