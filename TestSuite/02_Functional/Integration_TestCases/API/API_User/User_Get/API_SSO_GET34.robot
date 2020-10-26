*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET34
    [Documentation]    This test case is used to verify updates made to a user created 
    ...    via LOB UI using GET single User API with LOB Datasource
    ...    @author: jloretiz    16SEP2019    - initial create

    ### PARTY LOB ###
    ${rowid}    Set Variable   5434
    Mx Execute Template With Multiple Data    Create User in Party    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5534
    Mx Execute Template With Multiple Data    Update User in Party    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Updated User Created via LOB UI using GET Single User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5234
    Mx Execute Template With Multiple Data    Create User in Essence    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5334
    Mx Execute Template With Multiple Data    Update User in Essence    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Updated User Created via LOB UI using GET Single User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   5034
    Mx Execute Template With Multiple Data    Create User in LOANIQ    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5134
    Mx Execute Template With Multiple Data    Update User in LOANIQ    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Updated User Created via LOB UI using GET Single User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields