*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Set General Tab Details in Admin Fee Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    14MAY2020    - initial create

    Run Keyword    Set General Tab Details in Admin Fee Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    ...    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Set Distribution Details in Admin Fee Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    14MAY2020    - initial create

    Run Keyword    Set Distribution Details in Admin Fee Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Copy Alias To Clipboard and Get Data
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    14MAY2020    - initial create

    Run Keyword    Copy Alias To Clipboard and Get Data    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Get Admin Fee Due Date
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    14MAY2020    - initial create

    Run Keyword    Get Admin Fee Due Date    ${ARGUMENT_1}
     
BUS_Validate Admin Fee If Added
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    14MAY2020    - initial create

    Run Keyword    Validate Admin Fee If Added    ${ARGUMENT_1}    

BUS_Navigate to Admin Fee Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    29JUN2020    - initial create

    Run Keyword    Navigate to Admin Fee Workflow and Proceed With Transaction    ${ARGUMENT_1}        