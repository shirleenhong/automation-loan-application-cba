*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC18
    [Tags]    API_COR_TC18
	[Documentation]    API_COR_TC18 Ensure that error is encountered for CALL BACK MESSAGE ID in payload contains more than 100 characters
	...    Pre-Req: Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: chanario
    
    Set Test Variable    ${rowid}    18
    Mx Execute Template With Multiple Data    Send a Callback with Correlation ID of more than 100 characters    ${APIDataSet}    ${rowid}    Correspondence
