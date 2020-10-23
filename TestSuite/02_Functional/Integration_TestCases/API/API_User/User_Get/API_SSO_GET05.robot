*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET05
    [Documentation]    This keyword is used to create prerequisites for execution for GET API.
    ...    Verify an existing user and send a GET Single User API request for a single lob user using LoginID and LOB. 
    ...    And validate MCH UI and verify that data is correct in LOB.
    ...    @author: jloretiz    16SEP2019    - initial create

    ### PARTY LOB ###
    ${rowid}    Set Variable   5305
    Mx Execute Template With Multiple Data    Update User in Party    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Updated User with GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields
    ${rowid}    Set Variable   5405
    Mx Execute Template With Multiple Data    Update User in Party    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5205
    Mx Execute Template With Multiple Data    Update User in Essence    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Updated User with GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields
    ${rowid}    Set Variable   5505
    Mx Execute Template With Multiple Data    Update User in Essence    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   5105
    Mx Execute Template With Multiple Data    Update User in LOANIQ    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Updated User with GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields
    ${rowid}    Set Variable   5605
    Mx Execute Template With Multiple Data    Update User in LOANIQ    ${APIDataSet}    ${rowid}    Users_Fields