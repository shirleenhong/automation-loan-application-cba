*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal21_Zone2
    [Tags]    Zone2_VLS_CURRENCY
    [Documentation]    This keyword is used to validate the fields in VLS_CURRENCY CSV vs LIQ Screen 
    ...    @author: mgaling    20Sep2019    - initial create
        
    Set Global Variable    ${rowid}    1        
    Mx Execute Template With Multiple Data    Validate VLS_CURRENCY Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal21

DWELIQ_FuncVal21_Zone3
    [Tags]    Zone3_VLS_CURRENCY
    [Documentation]    This keyword is used to validate the fields in VLS_CURRENCY CSV vs LIQ Screen 
    ...    @author: mgaling    20Sep2019    - initial create
        
    Set Global Variable    ${rowid}    1        
    Mx Execute Template With Multiple Data    Validate VLS_CURRENCY Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal21