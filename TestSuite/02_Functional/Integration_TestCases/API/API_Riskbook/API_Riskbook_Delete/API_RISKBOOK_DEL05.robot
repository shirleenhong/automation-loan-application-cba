*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL05
    [Documentation]    This test case is used to validate that user is able to delete multiple risk books using login Id and response is 200
    ...    @author: dahijara    11SEP2019    - initial create
    ...    @update: cfrancis    06JUL2020    - updated to use update using login Id keyword

    ${rowid}    Set Variable    3051
    Mx Execute Template With Multiple Data    Update an Risk Book Without LIQ Validation using Login Id    ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    305
    Mx Execute Template With Multiple Data    Delete Multiple Risk Books Using Login Id    ${APIDataSet}    ${rowid}    Riskbook