*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG23_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if Default Processing Area is invalid. 
    ...    @author: cfrancis    10AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42301
    Mx Execute Template With Multiple Data    Create User with Invalid Default Proc Area    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG23_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if Default Processing Area is invalid. 
    ...    @author: cfrancis    10AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42302
    Mx Execute Template With Multiple Data    Update User with Invalid Default Proc Area    ${APIDataSet}    ${rowid}    Users_Fields