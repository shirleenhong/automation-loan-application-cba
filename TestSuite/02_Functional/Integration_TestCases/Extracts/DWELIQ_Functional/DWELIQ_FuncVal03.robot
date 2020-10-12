*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal03
    [Tags]    Zone2_VLS_DEAL
    [Documentation]    This keyword is used to validate the fields in VLS_DEAL CSV Extract vs LIQ Screen  
    ...    @author: mgaling    10Sep2019    - initial create
    ...    @update: mgaling    09Oct2020    - updated keyword to handle multi entity test case
        
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001|DWELIQ_Multi_E2E_002
    Set Global Variable    ${TestCase_Name_FuncVal}    DWELIQ_FuncVal02_Z3|DWELIQ_FuncVal02_Z2
    Set Global Variable    ${DWELIQFunc_Dataset_SheetName}  FuncVal03
    Mx Execute Template With Multiple Test Case Name    Get Business Date of Decrypted Files    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE
    
    Set Global Variable    ${TestCase_Name}    DWELIQ_FuncVal02_Z2|DWELIQ_FuncVal02_Z3
    Mx Execute Template With Multiple Test Case Name    Validate VLS_DEAL Extract     ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal03