*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal02_Zone2
    [Tags]    Zone2_VLS_CUSTOMER
	[Documentation]    This keyword is used to validate CUS_XID_CUST_ID and CUS_CID_CUST_ID in CSV vs LIQ screen
    ...    @author: ehugo    28AUG2019
    
    Set Test Variable    ${rowid}    1   
    Mx Execute Template With Multiple Data    Validate VLS_CUSTOMER Extract    ${DWELIQFunc_Dataset}    ${rowid}    FuncVal02