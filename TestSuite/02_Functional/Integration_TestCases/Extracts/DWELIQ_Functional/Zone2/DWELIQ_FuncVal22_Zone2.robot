*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***


*** Test Cases ***
DWELIQ_FuncVal22_Zone2
    [Tags]    Zone2_VLS_CROSS_CURRENCY
    [Documentation]    This keyword is used to validate the fields in VLS_CROSS_CURRENCY CSV vs LIQ Screen 
    ...    @author: mgaling    20Sep2019    - initial create
        
    Set Global Variable    ${rowid}    1      
    Mx Execute Template With Multiple Data    Validate VLS_CROSS_CURRENCY Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal22
