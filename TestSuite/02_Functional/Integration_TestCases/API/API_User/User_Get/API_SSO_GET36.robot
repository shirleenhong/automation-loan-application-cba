*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET36
    [Documentation]    This test case is used to verify deleted user created via UI using GET Single User API
    ...    @author: jloretiz    11SEP2019    - initial create

    ### PARTY LOB ###
    ${rowid}    Set Variable   5336
    Mx Execute Template With Multiple Data    Create User in Party    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    DELETE User Created via LOB UI and Verify using GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5236
    Mx Execute Template With Multiple Data    Create User in Essence    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    DELETE User Created via LOB UI and Verify using GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields
    
    ###LOAN IQ LOB ###
    ${rowid}    Set Variable   5136
    Mx Execute Template With Multiple Data    Create User in LOANIQ    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    DELETE User Created via LOB UI and Verify using GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields