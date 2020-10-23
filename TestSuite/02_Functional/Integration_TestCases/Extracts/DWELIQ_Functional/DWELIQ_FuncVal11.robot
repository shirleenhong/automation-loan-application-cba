*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal11
	[Documentation]    This keyword is used to validate RPE_CDE_EXPENSE, RPE_CDE_PORTFOLIO and RPE_CDE_RISK_BOOK vs LIQ screen
    ...    @author: ehugo    28AUG2019    - initial create
    ...    @update: mgaling    23OCT2020    - added keyword to handle multi entity test cases
    
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001|DWELIQ_Multi_E2E_002
    Set Global Variable    ${TestCase_Name_FuncVal}    DWELIQ_FuncVal11_Z3|DWELIQ_FuncVal11_Z2
    Set Global Variable    ${DWELIQFunc_Dataset_SheetName}    FuncVal11
    Mx Execute Template With Multiple Test Case Name    Get Business Date of Decrypted Files    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE

    Set Global Variable    ${TestCase_Name}    DWELIQ_FuncVal11_Z3|DWELIQ_FuncVal11_Z2        
    Mx Execute Template With Multiple Test Case Name    Validate VLS_RISK_PORT_EXP Extract    ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal11