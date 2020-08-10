*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal14_Zone3
    [Tags]    Zone3_VLS_FAM_GLOBAL2
	[Documentation]    This keyword is used to validate GB2_TID_TABLE_ID for VLS_FAM_GLOBAL2.
    ...    @author: ehugo    06SEP2019
    
    Set Test Variable    ${rowid}    2    
    Mx Execute Template With Multiple Data    Validate VLS_FAM_GLOBAL2 Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal14
