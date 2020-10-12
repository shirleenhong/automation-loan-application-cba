*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC07
    [Tags]    API_COR_TC07
	[Documentation]    API_COR_TC07 Ensure that user is able to successfully sent out a FEE PAYMENT NOTICE via WIP with NO error when MESSAGE is NULL.
    ...    Pre-Req: Commitment Fee Payment Test Case
    ...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name
    ...    @author: mgaling
    Set Test Variable    ${rowid}    7    
    Mx Execute Template With Multiple Data    NO error for SENT CALL BACK when MESSAGE is NULL   ${APIDataSet}    ${rowid}    Correspondence
