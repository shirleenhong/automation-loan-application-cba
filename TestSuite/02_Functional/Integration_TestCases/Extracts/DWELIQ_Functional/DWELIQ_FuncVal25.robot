*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal25_Zone2
    [Tags]    Zone2_VLS_FAC_BORR_DETL
	[Documentation]    This test case is used to validate VLS_FAC_BORR_DETL Extract.
    ...    @author: dahijara    25SEP2019    - Initial Create
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_FAC_BORR_DETL Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal25

DWELIQ_FuncVal25_Zone3
    [Tags]    Zone3_VLS_FAC_BORR_DETL
	[Documentation]    This test case is used to validate VLS_FAC_BORR_DETL Extract.
    ...    @author: dahijara    25SEP2019    - Initial Create
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_FAC_BORR_DETL Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal25