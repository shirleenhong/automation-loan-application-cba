*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC23
    [Tags]    API_COR_TC23
	[Documentation]    API_COR_TC23 Ensure that user is able to successfully send out a NOTICE even if there is an error message
	...    Pre-Req: Bilateral Deal with Loan, Rate Setting Notice
	...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name, Loan_Alias
    ...    @author: cfrancis
    Set Test Variable    ${rowid}    23    
    Mx Execute Template With Multiple Data    Send Successful Notice with Error Message   ${APIDataSet}    ${rowid}    Correspondence
