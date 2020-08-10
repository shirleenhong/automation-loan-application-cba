*** Settings ***
RResource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal24_Zone2
    [Tags]    Zone2_VLS_PROD_GUARANTEE
	[Documentation]    This test case is used to validate VLS_PROD_GUARANTEE Extract.
    ...    @author: dahijara    23SEP2019
    
    Set Test Variable    ${rowid}    1    
    Mx Execute Template With Multiple Data    Validate VLS_PROD_GUARANTEE Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal24
