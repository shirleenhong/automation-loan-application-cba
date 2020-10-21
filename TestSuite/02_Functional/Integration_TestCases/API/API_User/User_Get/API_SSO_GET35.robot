*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET335
    [Documentation]    This test case is used to verify updates made to a user created 
    ...    via LOB UI using GET All User API with LOB Datasource
    ...    @author: jloretiz    16SEP2019    - initial create

    ### PARTY LOB ###
    ${rowid}    Set Variable   5435
    Mx Execute Template With Multiple Data    Create User in Party    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5535
    Mx Execute Template With Multiple Data    Update User in Party    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Updated User Created via LOB UI using GET All User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5235
    Mx Execute Template With Multiple Data    Create User in Essence    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5335
    Mx Execute Template With Multiple Data    Update User in Essence    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Updated User Created via LOB UI using GET All User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   5035
    Mx Execute Template With Multiple Data    Create User in LOANIQ    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5135
    Mx Execute Template With Multiple Data    Update User in LOANIQ    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Updated User Created via LOB UI using GET All User API with Datasource    ${APIDataSet}    ${rowid}    Users_Fields