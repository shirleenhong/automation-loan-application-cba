*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal04
	[Documentation]    This keyword is used to validate the following columns for VLS_FACILITY:
	...    FAC_DTE_TERM_FAC, FAC_DTE_FL_DRAWDWN, FAC_DTE_EFFECTIVE, FAC_DTE_FINAL_MAT, FAC_DTE_EXPIRY, FAC_CDE_CURRENCY, FAC_IND_COMITTED, FAC_DTE_AGREEMENT, FAC_IND_MULTI_CURR,
	...    fac_cde_fac_type, fac_cde_branch
    ...    @author: ehugo    16SEP2019    - initial create
    ...    @update: mgaling    27OCT2020    - added keyword to handle multi entity test case
    
    Set Global Variable    ${TestCase_Name}    DWELIQ_Multi_E2E_001|DWELIQ_Multi_E2E_002
    Set Global Variable    ${TestCase_Name_FuncVal}    DWELIQ_FuncVal04_Z3|DWELIQ_FuncVal04_Z2
    Set Global Variable    ${DWELIQFunc_Dataset_SheetName}  FuncVal04
    Mx Execute Template With Multiple Test Case Name    Get Business Date of Decrypted Files    ${DWE_DATASET}    Test_Case    ${TestCase_Name}    DWE

    Set Global Variable    ${TestCase_Name}    DWELIQ_FuncVal04_Z3|DWELIQ_FuncVal04_Z2
    Mx Execute Template With Multiple Test Case Name    Validate VLS_FACILITY Extract    ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal04