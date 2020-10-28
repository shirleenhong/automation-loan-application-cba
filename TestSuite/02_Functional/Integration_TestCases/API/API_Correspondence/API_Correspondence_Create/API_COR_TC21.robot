*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC21
    [Tags]    API_COR_TC21
	[Documentation]    API_COR_TC21 Ensure that user is able to successfully resend out a NOTICE that is already in SENT status
	...    Pre-Req: Bilateral Deal with Loan, Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name, Loan_Alias
    ...    @author: cfrancis
    Set Test Variable    ${rowid}    21    
    Mx Execute Template With Multiple Data    Resend a Sent Notice   ${APIDataSet}    ${rowid}    Correspondence
