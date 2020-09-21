*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal26_Zone2
    [Tags]    Zone2_VLS_DEAL_BORROWER
	[Documentation]    This test case is used to validate VLS_DEAL_BORROWER Extract.
    ...    @author: dahijara    24SEP2019    - Initial Create
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_DEAL_BORROWER Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal26

DWELIQ_FuncVal26_Zone3
    [Tags]    Zone3_VLS_DEAL_BORROWER
	[Documentation]    This test case is used to validate VLS_DEAL_BORROWER Extract.
    ...    @author: dahijara    24SEP2019    - Initial Create
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_DEAL_BORROWER Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal26