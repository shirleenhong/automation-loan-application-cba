*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET33
    [Documentation]    This test case is used to verify user created via LOB UI using GET All User API.
    ...    @author: jloretiz    13SEP2019    - initial create

    ### PARTY LOB ###
    ${rowid}    Set Variable   5333
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Created User via LOB UI using GET All User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5233
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Created User via LOB UI using GET All User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   5033
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5133
    Mx Execute Template With Multiple Data    Verify Created User via LOB UI using GET All User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields