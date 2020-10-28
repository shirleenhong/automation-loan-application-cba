*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG26_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if Profile ID is already existing
    ...    @author: cfrancis    12AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42601
    Mx Execute Template With Multiple Data    Create User with existing Profile ID    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG26_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if Profile ID is non-existing
    ...    @author: cfrancis    12AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42602
    Mx Execute Template With Multiple Data    Update User with existing Profile ID    ${APIDataSet}    ${rowid}    Users_Fields