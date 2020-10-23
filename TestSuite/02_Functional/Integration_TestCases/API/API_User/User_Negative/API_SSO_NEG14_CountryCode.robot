*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG14_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when invalid country code
    ...    @author: cfrancis    06AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    41401
    Mx Execute Template With Multiple Data    Create User Invalid Country Code    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG14_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when invalid country code
    ...    @author: cfrancis    06AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    41402
    Mx Execute Template With Multiple Data    Update User with Invalid Country Code    ${APIDataSet}    ${rowid}    Users_Fields