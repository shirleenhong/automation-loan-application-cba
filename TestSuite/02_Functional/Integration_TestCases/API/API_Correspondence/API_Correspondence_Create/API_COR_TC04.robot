*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC04
    [Tags]    API_COR_TC04
	[Documentation]    API_COR_TC04 Ensure that user is able to successfully sent a FAIL callback in FEE PAYMENT NOTICE via WIP
    ...    Pre-Req: Fee Payment Test Case
    ...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: mgaling
    Set Test Variable    ${rowid}    4    
    Mx Execute Template With Multiple Data    Send a FAIL callback in NOTICE via WIP    ${APIDataSet}    ${rowid}    Correspondence
