*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG20_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when LOB Location is invalid to the branch.
    ...    @author: cfrancis    07AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42001    
    Mx Execute Template With Multiple Data    Create User with Invalid Location    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG20_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when LOB Location is invalid to the branch.
    ...    @author: cfrancis    07AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42002    
    Mx Execute Template With Multiple Data    Update User with Invalid Location    ${APIDataSet}    ${rowid}    Users_Fields