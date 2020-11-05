*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC26
    [Tags]    API_COR_TC26
	[Documentation]    API_COR_TC26 Ensure that user is able to successfully sent out a PAPER CLIP INTENT NOTICE via Notice application
	...    Pre-Req: Loan Test Case, Paperclip Intent Notice (Principal + Interest Payment)
	...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name, Loan_Alias
    ...    @author: ehugo    06SEP2019    initial create
    Set Test Variable    ${rowid}    26    
    Mx Execute Template With Multiple Data    Send Paperclip Intent Notice via Notice Application   ${APIDataSet}    ${rowid}    Correspondence
