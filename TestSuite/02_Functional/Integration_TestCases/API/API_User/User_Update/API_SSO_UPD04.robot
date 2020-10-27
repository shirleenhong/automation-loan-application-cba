*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_UPD04
    [Documentation]    This testcase is used to verify that user is able to UPDATE a user with multiple LOBs.
    ...    @author: clanding
    ...    @update: clanding    23APR2019    - changed keyword name
    ...    @update: dahijara    20AUG2019    - Added keyword to create multiple LOB data for execution.
    
    ${rowID}    Set Variable    341
    Mx Execute Template With Multiple Data    Create User with Multiple LOBs without FFC Validation    ${APIDataSet}    ${rowID}    Users_Fields    
    
    ${rowID}    Set Variable    34
    Mx Execute Template With Multiple Data    Update Existing User for Multiple LOBs    ${APIDataSet}    ${rowID}    Users_Fields