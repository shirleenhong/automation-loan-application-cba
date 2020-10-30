*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC15
    [Tags]    API_COR_TC15
	[Documentation]    API_COR_TC15 Ensure that error is encountered for CALL BACK when CORRELATION ID is not present in LIQ
	...    Pre-Req: Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: cfrancis

    Set Test Variable    ${rowid}    15    
    Mx Execute Template With Multiple Data    Send a Callback with Non-existing Correlation ID    ${APIDataSet}    ${rowid}    Correspondence
