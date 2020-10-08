*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC02
    [Tags]    API_COR_TC02
    [Documentation]    API_COR_TC02 Ensure that user is able to successfully sent out a Fee Payment Notice via WIP
    ...    Pre-Req: Line Fee Payment Test Case (Bilateral Deal)
    ...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name
    ...    @author: mgaling
    Set Test Variable    ${rowid}    2    
    Mx Execute Template With Multiple Data    Send Notice via WIP    ${APIDataSet}    ${rowid}    Correspondence