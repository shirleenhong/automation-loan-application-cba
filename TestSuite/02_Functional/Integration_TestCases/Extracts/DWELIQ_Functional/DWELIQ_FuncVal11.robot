*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal11_Zone2
    [Tags]    Zone2_VLS_RISK_PORT_EXP
	[Documentation]    This keyword is used to validate RPE_CDE_EXPENSE, RPE_CDE_PORTFOLIO and RPE_CDE_RISK_BOOK vs LIQ screen
    ...    @author: ehugo    28AUG2019
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_RISK_PORT_EXP Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal11

DWELIQ_FuncVal11_Zone3
    [Tags]    Zone3_VLS_RISK_PORT_EXP
	[Documentation]    This keyword is used to validate RPE_CDE_EXPENSE, RPE_CDE_PORTFOLIO and RPE_CDE_RISK_BOOK vs LIQ screen
    ...    @author: ehugo    28AUG2019
    
    Set Test Variable    ${rowid}    2    
    Mx Execute Template With Multiple Data    Validate VLS_RISK_PORT_EXP Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal11