*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
DWELIQ_FuncVal02
    [Tags]    VLS_CUSTOMER
	[Documentation]    This keyword is used to validate CUS_XID_CUST_ID and CUS_CID_CUST_ID in CSV vs LIQ screen
    ...    @author: ehugo    28AUG2019
    
    Set Test Variable    ${TestCase_Name}    DWELIQ_FuncVal02_Z2|DWELIQ_FuncVal02_Z3      
    Mx Execute Template With Multiple Test Case Name    Validate VLS_CUSTOMER Extract    ${DWELIQFunc_Dataset}    Test_Case    ${TestCase_Name}    FuncVal02