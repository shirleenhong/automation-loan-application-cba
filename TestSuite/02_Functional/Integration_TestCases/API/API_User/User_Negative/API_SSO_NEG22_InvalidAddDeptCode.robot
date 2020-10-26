*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG22_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if Additional Department Code is invalid. 
    ...    @author: cfrancis    10AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42201
    Mx Execute Template With Multiple Data    Create User with Invalid Additional Dept Code    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG22_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if Additional Department Code is invalid. 
    ...    @author: cfrancis    10AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42202
    Mx Execute Template With Multiple Data    Update User with Invalid Additional Dept Code    ${APIDataSet}    ${rowid}    Users_Fields