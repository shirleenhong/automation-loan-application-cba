*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
*** Test Cases ***

API_SSO_GET18
    [Documentation]    This test case is used to verify that user is able to AMEND manually from New User and get existing SINGLE user from LOB
    ...    @author: amansuet    18SEP2019    - initial create
    
    ### PARTY LOB ###
    ${rowid}    Set Variable   51180
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   51181
    Mx Execute Template With Multiple Data    Update User in Party    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Manually Updated User from New User is Existing in GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   52180
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   52181
    Mx Execute Template With Multiple Data    Update User in Essence    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Manually Updated User from New User is Existing in GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields
    
    # ### LOAN IQ LOB ###
    ${rowid}    Set Variable   53180
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   53181
    Mx Execute Template With Multiple Data    Update User in LOANIQ    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    Verify Manually Updated User from New User is Existing in GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields