*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET37
    [Documentation]    This test case is used to verify deleted user created via LOB UI using GET All User API
    ...    @author: jloretiz    10SEP2019    - initial create

    ## PARTY LOB ###
    ${rowid}    Set Variable   5337
    Mx Execute Template With Multiple Data    Create User in Party    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    DELETE User Created via LOB UI and Verify using GET All User API    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5237
    Mx Execute Template With Multiple Data    Create User in Essence    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    DELETE User Created via LOB UI and Verify using GET All User API    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   5137
    Mx Execute Template With Multiple Data    Create User in LOANIQ    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    DELETE User Created via LOB UI and Verify using GET All User API    ${APIDataSet}    ${rowid}    Users_Fields