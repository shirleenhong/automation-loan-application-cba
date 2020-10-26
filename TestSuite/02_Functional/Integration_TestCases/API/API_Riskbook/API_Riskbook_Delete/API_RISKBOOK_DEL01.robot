*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL01
    [Documentation]    This test case is used to validate that user is able to delete single risk book using user Id and response is 200
    ...    @author: dahijara    10SEP2019    - initial create

    ${rowid}    Set Variable    3011
    Mx Execute Template With Multiple Data    Update Risk Book Without LIQ Validation    ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    301
    Mx Execute Template With Multiple Data    Delete Single Risk Book Using User Id    ${APIDataSet}    ${rowid}    Riskbook