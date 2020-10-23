*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG11_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when Business Entity Name is invalid.
    ...    @author: cfrancis    07AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    41101    
    Mx Execute Template With Multiple Data    Create User with Invalid Business Entity Name    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG11_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when Business Entity Name is invalid.
    ...    @author: cfrancis    07AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    41102
    Mx Execute Template With Multiple Data    Update User with Invalid Business Entity Name    ${APIDataSet}    ${rowid}    Users_Fields