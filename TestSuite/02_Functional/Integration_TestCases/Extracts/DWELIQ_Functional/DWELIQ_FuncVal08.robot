*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal08
    [Documentation]    This keyword is used to validate the fields in VLS_OUTSTANDING CSV vs LIQ Screen 
    ...    @author: mgaling    26SEP2020    - initial create
    ...    @update: mgaling    25OCT2020    - added keyword to handle multi entity test cases
        
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001|DWELIQ_Multi_E2E_002
    Set Global Variable    ${TestCase_Name_FuncVal}    DWELIQ_FuncVal08_Z3|DWELIQ_FuncVal08_Z2
    Set Global Variable    ${DWELIQFunc_Dataset_SheetName}    FuncVal08
    Mx Execute Template With Multiple Test Case Name    Get Business Date of Decrypted Files    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE

    Set Global Variable    ${TestCase_Name}    DWELIQ_FuncVal08_Z3|DWELIQ_FuncVal08_Z2
    Mx Execute Template With Multiple Test Case Name    Validate VLS_OUTSTANDING Extract    ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal08