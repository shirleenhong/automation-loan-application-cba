*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL04
    [Documentation]    This test case is used to validate that user is able to delete single risk book using login Id and response is 200
    ...    @author: dahijara    11SEP2019    - initial create
    ...    @update: cfrancis    06JUL2020    - updated to use Update using Login Id

    ${rowid}    Set Variable    3041
    Mx Execute Template With Multiple Data    Update an Risk Book Without LIQ Validation using Login Id    ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    304
    Mx Execute Template With Multiple Data    Delete Single Risk Book Using Login Id    ${APIDataSet}    ${rowid}    Riskbook