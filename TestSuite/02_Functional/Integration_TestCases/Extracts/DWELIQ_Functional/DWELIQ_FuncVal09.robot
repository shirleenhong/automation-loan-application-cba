*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal09
    [Documentation]    This keyword is used to validate the columns in CSV vs LIQ Screen 
    ...    @author: mgaling    23SEP2019    - initial create
    ...    @update: mgaling    25OCT2020    - added keyword to handle multi entity test cases
    
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001|DWELIQ_Multi_E2E_002
    Set Global Variable    ${TestCase_Name_FuncVal}    DWELIQ_FuncVal09_Z3|DWELIQ_FuncVal09_Z2
    Set Global Variable    ${DWELIQFunc_Dataset_SheetName}    FuncVal09
    Mx Execute Template With Multiple Test Case Name    Get Business Date of Decrypted Files    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE

    Set Global Variable    ${TestCase_Name}    DWELIQ_FuncVal09_Z3|DWELIQ_FuncVal09_Z2    
    Mx Execute Template With Multiple Test Case Name    Validate VLS_PROD_POS_CUR Extract     ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal09