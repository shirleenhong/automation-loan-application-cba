*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal26
	[Documentation]    This test case is used to validate VLS_DEAL_BORROWER Extract.
    ...    @author: dahijara    24SEP2019    - initial create
    ...    @update: mgaling    27OCT2020    - added keyword to handle multi entity test case
    
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001|DWELIQ_Multi_E2E_002
    Set Global Variable    ${TestCase_Name_FuncVal}    DWELIQ_FuncVal26_Z3|DWELIQ_FuncVal26_Z2
    Set Global Variable    ${DWELIQFunc_Dataset_SheetName}    FuncVal26
    Mx Execute Template With Multiple Test Case Name    Get Business Date of Decrypted Files    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE

    Set Global Variable    ${TestCase_Name}    DWELIQ_FuncVal26_Z3|DWELIQ_FuncVal26_Z2    
    Mx Execute Template With Multiple Test Case Name    Validate VLS_DEAL_BORROWER Extract    ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal26