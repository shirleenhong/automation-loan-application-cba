*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG25_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if UserLockStatus is invalid
    ...    @author: cfrancis    11AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42501
    Mx Execute Template With Multiple Data    Create User with Invalid User Lock Status    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG25_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if UserLockStatus is invalid
    ...    @author: cfrancis    11AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42502    
    Mx Execute Template With Multiple Data    Update User with Invalid User Lock Status    ${APIDataSet}    ${rowid}    Users_Fields