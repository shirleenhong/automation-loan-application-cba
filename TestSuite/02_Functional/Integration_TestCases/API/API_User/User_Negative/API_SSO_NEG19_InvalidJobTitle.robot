*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG19_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when job title is invalid
    ...    @author: cfrancis    07AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    41901
    Mx Execute Template With Multiple Data    Create User with Invalid Job Title    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG19_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when job title is invalid
    ...    @author: cfrancis    07AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    41902
    Mx Execute Template With Multiple Data    Update User with Invalid Job Title    ${APIDataSet}    ${rowid}    Users_Fields