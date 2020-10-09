*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC11
    [Tags]    API_COR_TC11
	[Documentation]    API_COR_TC11 Ensure that error is encountered for CALL BACK when CORRELATION ID is missing
	...    Pre-Req: Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: cfrancis

    Set Test Variable    ${rowid}    11    
    Mx Execute Template With Multiple Data    Send a Callback with missing Correlation ID only    ${APIDataSet}    ${rowid}    Correspondence
