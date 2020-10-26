*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal13
    [Documentation]    This keyword is used to validate the FPP_CDE_PORTFOLIO  field in CSV vs LIQ Screen  
    ...    @author: mgaling    03SEP2019    - initial create
    ...    @update: mgaling    14OCT2020    - added keyword to handle multi entity test case
        
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001|DWELIQ_Multi_E2E_002
    Set Global Variable    ${TestCase_Name_FuncVal}    DWELIQ_FuncVal13_Z3|DWELIQ_FuncVal13_Z2
    Set Global Variable    ${DWELIQFunc_Dataset_SheetName}  FuncVal13
    Mx Execute Template With Multiple Test Case Name    Get Business Date of Decrypted Files    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE

    Set Global Variable    ${TestCase_Name}    DWELIQ_FuncVal13_Z3|DWELIQ_FuncVal13_Z2            
    Mx Execute Template With Multiple Test Case Name    Validate VLS_FAC_PORT_POS Extract     ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal13