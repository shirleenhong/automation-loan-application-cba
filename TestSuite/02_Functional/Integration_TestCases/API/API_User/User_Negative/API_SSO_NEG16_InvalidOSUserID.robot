*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG16_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE when invalid osuserid
    ...    @author: cfrancis    07AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    41601
    Mx Execute Template With Multiple Data    Create User with Invalid OSUserID    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG16_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE when invalid osuserid
    ...    @author: cfrancis    07AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    41602
    Mx Execute Template With Multiple Data    Update User with Invalid OSUserID    ${APIDataSet}    ${rowid}    Users_Fields