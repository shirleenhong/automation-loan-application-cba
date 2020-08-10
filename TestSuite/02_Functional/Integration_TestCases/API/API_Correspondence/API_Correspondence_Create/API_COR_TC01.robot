*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
API_COR_TC01
	[Documentation]    API_COR_TC01 Ensure that user is able to successfully sent out a RATE SETTING NOTICE (Drawdown) via Notice application
    ...    Pre-Req: Loan Test Case with Rate Setting Notice (Drawdown)
    ...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name, Loan_Alias
    ...    @author: magaling    DDMMMYYYY    - initial create
    ...    @update: jloretiz    10JUL2020    - added prerequisite of getting the Pre-requisite data from scenarios
    [Tags]    API_COR_TC01

    ### Send Notice via Notice Application ###
    Set Test Variable    ${rowid}    1
    Mx Execute Template With Multiple Data    Send Notice via Notice Application    ${APIDataSet}    ${rowid}    Correspondence
