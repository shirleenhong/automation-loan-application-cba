*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal04_Zone2
    [Tags]    Zone2_VLS_FACILITY
	[Documentation]    This keyword is used to validate the following columns for VLS_FACILITY:
	...    FAC_DTE_TERM_FAC, FAC_DTE_FL_DRAWDWN, FAC_DTE_EFFECTIVE, FAC_DTE_FINAL_MAT, FAC_DTE_EXPIRY, FAC_CDE_CURRENCY, FAC_IND_COMITTED, FAC_DTE_AGREEMENT, FAC_IND_MULTI_CURR,
	...    fac_cde_fac_type, fac_cde_branch
	...    
    ...    @author: ehugo    16SEP2019
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_FACILITY Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal04

DWELIQ_FuncVal04_Zone3
    [Tags]    Zone3_VLS_FACILITY
	[Documentation]    This keyword is used to validate the following columns for VLS_FACILITY:
	...    FAC_DTE_TERM_FAC, FAC_DTE_FL_DRAWDWN, FAC_DTE_EFFECTIVE, FAC_DTE_FINAL_MAT, FAC_DTE_EXPIRY, FAC_CDE_CURRENCY, FAC_IND_COMITTED, FAC_DTE_AGREEMENT, FAC_IND_MULTI_CURR,
	...    fac_cde_fac_type, fac_cde_branch
	...    
    ...    @author: ehugo    16SEP2019
    
    Set Test Variable    ${rowid}    2    
    Mx Execute Template With Multiple Data    Validate VLS_FACILITY Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal04
