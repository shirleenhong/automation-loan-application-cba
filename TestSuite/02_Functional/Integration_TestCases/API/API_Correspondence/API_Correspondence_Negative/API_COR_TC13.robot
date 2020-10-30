*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC13
    [Tags]    API_COR_TC13
	[Documentation]    API_COR_TC13 Ensure that error is encountered for CALL BACK when MESSAGE ID is NULL
	...    Pre-Req: Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: chanario
    
    Set Test Variable    ${rowid}    13
    Mx Execute Template With Multiple Data    Send a Callback with Null Message ID    ${APIDataSet}    ${rowid}    Correspondence
   
