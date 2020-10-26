*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG08_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when role is invalid for LOB
    ...    @author: cfrancis    06AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    4801
    Mx Execute Template With Multiple Data    Create User with Invalid Role-LOBS    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG08_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when role is invalid for LOB
    ...    @author: cfrancis    06AUG2020    - refactored based from existing codes for negative scenarios
    
    ${rowid}    Set Variable    4802
    Mx Execute Template With Multiple Data    Update User with Invalid Role-LOBS    ${APIDataSet}    ${rowid}    Users_Fields