*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG15_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when invalid locale
    ...    @author: cfrancis    06AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    41501
    Mx Execute Template With Multiple Data    Create User Invalid Locale    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG15_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when invalid locale
    ...    @author: cfrancis    06AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    41502
    Mx Execute Template With Multiple Data    Update User with Invalid Locale    ${APIDataSet}    ${rowid}    Users_Fields