*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal15_Zone3
    [Tags]    Zone3_VLS_INT_PRC_OPTION
	[Documentation]    This keyword is used to validate IPO_PID_DEAL for VLS_INT_PRC_OPTION.
    ...    @author: ehugo    09SEP2019
    
    Set Test Variable    ${rowid}    2    
    Mx Execute Template With Multiple Data    Validate VLS_INT_PRC_OPTION Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal15
