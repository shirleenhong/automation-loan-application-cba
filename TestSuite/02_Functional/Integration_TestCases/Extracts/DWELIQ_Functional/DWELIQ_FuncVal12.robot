*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal12_Zone2
    [Tags]    Zone2_VLS_ACCRUAL_CYCLE
    [Documentation]    This keyword is used to validate the fields in VLS_ACCRUAL_CYCLE CSV Extract vs LIQ Screen  
    ...    @author: mgaling    03Sep2019    - initial create
        
    Set Global Variable    ${rowid}    1       
    Mx Execute Template With Multiple Data    Validate VLS_ACCRUAL_CYCLE Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal12

DWELIQ_FuncVal12_Zone3
    [Tags]    Zone3_VLS_ACCRUAL_CYCLE
    [Documentation]    This keyword is used to validate the fields in VLS_ACCRUAL_CYCLE CSV Extract vs LIQ Screen  
    ...    @author: mgaling    03Sep2019    - initial create
        
    Set Global Variable    ${rowid}    1       
    Mx Execute Template With Multiple Data    Validate VLS_ACCRUAL_CYCLE Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal12