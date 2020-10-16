*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal01
	[Documentation]    This keyword is used to validate BSG_CDE_GL_ACCOUNT, BSG_CDE_GL_SHTNAME, BSG_CDE_BRANCH, BSG_CDE_EXPENSE, BSG_CDE_PORTFOLIO, BSG_CDE_CURRENCY for VLS_BAL_SUBLEDGER.
    ...    @author: ehugo    29AUG2019    - initial create
    ...    @update: mgaling    13OCT2020    - added keyword to handle multi entity test case 
    
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001|DWELIQ_Multi_E2E_002
    Set Global Variable    ${TestCase_Name_FuncVal}    DWELIQ_FuncVal01_Z3|DWELIQ_FuncVal01_Z2
    Set Global Variable    ${DWELIQFunc_Dataset_SheetName}  FuncVal01
    Mx Execute Template With Multiple Test Case Name    Get Business Date of Decrypted Files    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE

    Set Global Variable    ${TestCase_Name}    DWELIQ_FuncVal01_Z3|DWELIQ_FuncVal01_Z2      
    Mx Execute Template With Multiple Test Case Name    Validate VLS_BAL_SUBLEDGER Extract    ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal01