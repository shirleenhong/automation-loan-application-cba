*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC16
    [Tags]    API_COR_TC16
	[Documentation]    API_COR_TC16 Ensure that error is encountered for CALL BACK when STATUS is not a valid code in Notice Status LIQ table
	...    Pre-Req: Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: cfrancis

    Set Test Variable    ${rowid}    16    
    Mx Execute Template With Multiple Data    Send a Callback with Invalid Status    ${APIDataSet}    ${rowid}    Correspondence
