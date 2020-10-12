*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC12
    [Tags]    API_COR_TC12
	[Documentation]    API_COR_TC12 Ensure that error is encountered for CALL BACK when STATUS is missing
	...    Pre-Req: Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: cfrancis

    Set Test Variable    ${rowid}    12    
    Mx Execute Template With Multiple Data    Send a Callback with missing Status only    ${APIDataSet}    ${rowid}    Correspondence
