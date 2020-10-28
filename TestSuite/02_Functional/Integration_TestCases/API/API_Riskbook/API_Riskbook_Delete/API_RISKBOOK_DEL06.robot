*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_DEL06
    [Documentation]    This test case is used to validate that user is able to delete all risk books using login Id and response is 200
    ...    @author: dahijara    11SEP2019    - initial create
    ...    @update: cfrancis    06JUL2020    - updated to use update using Login Id keyword

    ${rowid}    Set Variable    3061
    Mx Execute Template With Multiple Data    Update an Risk Book Without LIQ Validation using Login Id    ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    306
    Mx Execute Template With Multiple Data    Delete All Risk Books Using Login Id    ${APIDataSet}    ${rowid}    Riskbook