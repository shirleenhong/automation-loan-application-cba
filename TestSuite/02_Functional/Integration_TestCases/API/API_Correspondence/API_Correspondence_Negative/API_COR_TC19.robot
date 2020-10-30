*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC19
    [Tags]    API_COR_TC19
	[Documentation]    API_COR_TC19 Ensure that error is encountered in FFC for CALL BACK when ERROR MESSAGE in payload contains more than 200 characters
	...    Pre-Req: Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: chanario

    Set Test Variable    ${rowid}    19    
    Mx Execute Template With Multiple Data    Send a Callback with Error Message of more than 200 characters    ${APIDataSet}    ${rowid}    Correspondence
