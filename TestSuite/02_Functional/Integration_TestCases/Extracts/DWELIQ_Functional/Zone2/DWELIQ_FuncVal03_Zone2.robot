*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal03_Zone2
    [Tags]    Zone2_VLS_DEAL
    [Documentation]    This keyword is used to validate the fields in VLS_DEAL CSV Extract vs LIQ Screen  
    ...    @author: mgaling    10Sep2019    - initial create
        
    Set Global Variable    ${rowid}    1       
    Mx Execute Template With Multiple Data    Validate VLS_DEAL Extract     ${DWELIQFunc_Dataset}    ${rowid}    FuncVal03
