*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG10_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when LOB Default Branch inside Default Business Entity is invalid.
    ...    @author: cfrancis    06AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    41001
    Mx Execute Template With Multiple Data    Create User with Invalid Default Branch    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG10_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when LOB Default Branch inside Default Business Entity is invalid.
    ...    @author: cfrancis    06AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    41002
    Mx Execute Template With Multiple Data    Update User with Invalid Default Branch    ${APIDataSet}    ${rowid}    Users_Fields