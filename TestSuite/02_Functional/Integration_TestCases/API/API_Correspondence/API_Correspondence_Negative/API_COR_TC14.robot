*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC14
    [Tags]    API_COR_TC14
	[Documentation]    API_COR_TC14 Ensure that error is encountered for CALL BACK when STATUS is NULL
	...    Pre-Req: Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: cmartill
    
    Set Test Variable    ${rowid}    14
    Mx Execute Template With Multiple Data    Send a Callback with Null Status    ${APIDataSet}    ${rowid}    Correspondence
