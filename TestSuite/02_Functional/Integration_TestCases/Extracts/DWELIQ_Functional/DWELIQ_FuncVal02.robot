*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal02
    [Tags]    VLS_CUSTOMER
	[Documentation]    This keyword is used to validate CUS_XID_CUST_ID and CUS_CID_CUST_ID in CSV vs LIQ screen
    ...    @author: ehugo    28AUG2019    - initial create
    ...    @update: mgaling    12OCT2020    - updated keyword to handle multi entity test case
    
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001|DWELIQ_Multi_E2E_002
    Set Global Variable    ${TestCase_Name_FuncVal}    DWELIQ_FuncVal02_Z3|DWELIQ_FuncVal02_Z2
    Set Global Variable    ${DWELIQFunc_Dataset_SheetName}  FuncVal02
    Mx Execute Template With Multiple Test Case Name    Get Business Date of Decrypted Files    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE

    Set Test Variable    ${TestCase_Name}    DWELIQ_FuncVal02_Z3|DWELIQ_FuncVal02_Z2      
    Mx Execute Template With Multiple Test Case Name    Validate VLS_CUSTOMER Extract    ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal02