*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
API_COR_TC03
    [Tags]    API_COR_TC03
    [Documentation]    API_COR_TC03 Ensure that user is able to successfully sent out a DRAWDOWN INTENT NOTICE via Notice Application
    ...    Pre-Req: Loan Test Case with Drawdown Intent Notice
    ...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name, Loan_Alias
    ...    @author: mgaling                    
    Set Test Variable    ${rowid}    3
    Mx Execute Template With Multiple Data    Send a Drawdown Intent Notice via Notice Application    ${APIDataSet}    ${rowid}    Correspondence