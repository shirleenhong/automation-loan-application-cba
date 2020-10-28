*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC20
    [Tags]    API_COR_TC20
	[Documentation]    API_COR_TC02 Ensure that user is able to successfully sent out a RATE SETTING NOTICE for SYNDICATED Deal via WIP
	...    Pre-Req: Syndicated Deal with Loan, Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name, Loan_Alias
    ...    @author: mgaling
    Set Test Variable    ${rowid}    20    
    Mx Execute Template With Multiple Data    Send a SENT Callback for Rate Setting Notice for SYNDICATED Deal via WIP   ${APIDataSet}    ${rowid}    Correspondence
