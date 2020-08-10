*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
DWELIQ_FuncVal19_Zone3
    [Tags]    Zone3_VLS_SCHEDULE
	[Documentation]    This keyword is used to validate fields from CSV to LIQ Screen for VLS_SCHEDULE.
    ...    @author: mgaling    25SEP2019
    
    Set Test Variable    ${rowid}    2    
    Mx Execute Template With Multiple Data    Validate VLS_SCHEDULE Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal19
