*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC17
    [Tags]    API_COR_TC17
	[Documentation]    API_COR_TC17 Ensure that error is encountered in FFC for CALL BACK when STATUS in payload contains more than 8 characters
	...    Pre-Req: Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: chanario

    Set Test Variable    ${rowid}    17    
    Mx Execute Template With Multiple Data    Send a Callback with Status of more than 8 characters    ${APIDataSet}    ${rowid}    Correspondence
