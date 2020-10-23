*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG12_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when User Type is invalid.
    ...    @author: cfrancis    07AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    41201
    Mx Execute Template With Multiple Data    Create User with Invalid User Type    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG12_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when User Type is invalid.
    ...    @author: cfrancis    07AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    41202
    Mx Execute Template With Multiple Data    Update User with Invalid User Type    ${APIDataSet}    ${rowid}    Users_Fields