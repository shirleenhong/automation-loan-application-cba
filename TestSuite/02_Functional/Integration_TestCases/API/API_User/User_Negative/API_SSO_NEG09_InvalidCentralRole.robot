*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG09_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when central role is invalid
    ...    @author: cfrancis    06AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    4901
    Mx Execute Template With Multiple Data    Create User with Invalid Role    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG09_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when central role is invalid
    ...    @author: cfrancis    06AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    4902
    Mx Execute Template With Multiple Data    Update User with Invalid Role    ${APIDataSet}    ${rowid}    Users_Fields