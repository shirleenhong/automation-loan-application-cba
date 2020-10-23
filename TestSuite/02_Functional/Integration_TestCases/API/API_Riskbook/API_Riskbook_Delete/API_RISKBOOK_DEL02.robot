*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL02
    [Documentation]    This test case is used to validate that user is able to delete multiple risk books using user Id and response is 200
    ...    @author: dahijara    11SEP2019    - initial create

    ${rowid}    Set Variable    3021
    Mx Execute Template With Multiple Data    Update Risk Book Without LIQ Validation    ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    302
    Mx Execute Template With Multiple Data    Delete Multiple Risk Books Using User Id    ${APIDataSet}    ${rowid}    Riskbook