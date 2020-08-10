*** Settings ***
Resource    ../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal01_Zone2
    [Tags]    Zone2_VLS_BAL_SUBLEDGER
	[Documentation]    This keyword is used to validate BSG_CDE_GL_ACCOUNT, BSG_CDE_GL_SHTNAME, BSG_CDE_BRANCH, BSG_CDE_EXPENSE, BSG_CDE_PORTFOLIO, BSG_CDE_CURRENCY for VLS_BAL_SUBLEDGER.
    ...    @author: ehugo    29AUG2019
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_BAL_SUBLEDGER Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal01
