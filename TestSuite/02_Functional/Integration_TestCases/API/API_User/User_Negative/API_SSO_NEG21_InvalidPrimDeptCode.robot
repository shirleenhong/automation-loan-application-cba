*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG21_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if Primary Department Code is invalid. 
    ...    @author: cfrancis    07AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42101
    Mx Execute Template With Multiple Data    Create User with Invalid Primary Dept Code    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG21_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if Primary Department Code is invalid. 
    ...    @author: cfrancis    07AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42102
    Mx Execute Template With Multiple Data    Update User with Invalid Primary Dept Code    ${APIDataSet}    ${rowid}    Users_Fields