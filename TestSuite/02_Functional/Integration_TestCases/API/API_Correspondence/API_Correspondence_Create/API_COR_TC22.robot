*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC22
    [Tags]    API_COR_TC22
	[Documentation]    API_COR_TC22 Ensure that user is able to successfully resend out a NOTICE that is already in FAILED status
	...    Pre-Req: Bilateral Deal with Loan, Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name, Loan_Alias
    ...    @author: cfrancis
    Set Test Variable    ${rowid}    22    
    Mx Execute Template With Multiple Data    Resend a Failed Notice   ${APIDataSet}    ${rowid}    Correspondence
