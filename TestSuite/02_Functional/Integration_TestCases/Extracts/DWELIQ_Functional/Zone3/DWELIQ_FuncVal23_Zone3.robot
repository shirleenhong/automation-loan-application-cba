*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal23_Zone3
    [Tags]    Zone3_VLS_FUNDING_DESK
	[Documentation]    This keyword is used to validate in VLS_FUNDING_DESK extract vs LIQ screen.
    ...    @author: amansuet    20SEP2019
    
    Set Test Variable    ${rowid}    2    
    Mx Execute Template With Multiple Data    Validate VLS_FUNDING_DESK Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal23    
