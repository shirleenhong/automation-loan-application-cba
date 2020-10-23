*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG24_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if Additional Processing Area is invalid. 
    ...    @author: cfrancis    11AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42401
    Mx Execute Template With Multiple Data    Create User with Invalid Additional Proc Area    ${APIDataSet}    ${rowid}    Users_Fields
    
API_SSO_NEG24_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if Additional Processing Area is invalid. 
    ...    @author: cfrancis    11AUG2020    - refactored codes to use negative scenarios
    
    ${rowid}    Set Variable    42402
    Mx Execute Template With Multiple Data    Update User with Invalid Additional Proc Area    ${APIDataSet}    ${rowid}    Users_Fields