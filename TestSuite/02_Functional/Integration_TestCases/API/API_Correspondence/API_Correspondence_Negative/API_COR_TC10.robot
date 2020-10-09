*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot


*** Test Cases ***
API_COR_TC10
    [Tags]    API_COR_TC10
    [Documentation]    API_COR_TC10 Ensure that error is encountered for CALL BACK when CORRELATION ID and STATUS are missing
    ...    Pre-Req: Rate Setting Notice
    ...    Pre-Req in API_Data_Set: Deal_Name
    ...    @author: cfrancis

    Set Test Variable    ${rowid}    10    
    Mx Execute Template With Multiple Data    Send a Callback with missing Correlation ID and Status    ${APIDataSet}    ${rowid}    Correspondence