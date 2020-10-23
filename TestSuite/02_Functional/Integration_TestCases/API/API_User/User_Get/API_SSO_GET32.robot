*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET32
    [Documentation]    This test case is used to verify user created via LOB UI using GET single User API
    ...    @author: jloretiz    13SEP2019    - initial create

    ### PARTY LOB ###
    ${rowid}    Set Variable   5332
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Created User via LOB UI using GET Single User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5232
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Created User via LOB UI using GET Single User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   5032
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5132
    Mx Execute Template With Multiple Data    Verify Created User via LOB UI using GET Single User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields