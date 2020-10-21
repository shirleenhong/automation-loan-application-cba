*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG13_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when Central User Type is invalid.
    ...    @author: cfrancis    07AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    41301    
    Mx Execute Template With Multiple Data    Create User with Invalid Central User Type    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG13_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when Central User Type is invalid.
    ...    @author: cfrancis    07AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    41302
    Mx Execute Template With Multiple Data    Update User with Invalid Central User Type    ${APIDataSet}    ${rowid}    Users_Fields