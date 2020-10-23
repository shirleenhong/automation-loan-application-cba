*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET21
    [Documentation]    This test case is used to verify deleted user created via API using GET Single User API
    ...    @author: jloretiz    12SEP2019    - initial create

    ### PARTY LOB ###
    ${rowid}    Set Variable   5321
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    DELETE User Created via API from LOB and Verify using GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   5221
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    Mx Execute Template With Multiple Data    DELETE User Created via API from LOB and Verify using GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields
    
    ###LOAN IQ LOB ###
    ${rowid}    Set Variable   5021
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    ${rowid}    Set Variable   5121
    Mx Execute Template With Multiple Data    DELETE User Created via API from LOB and Verify using GET Single User API    ${APIDataSet}    ${rowid}    Users_Fields