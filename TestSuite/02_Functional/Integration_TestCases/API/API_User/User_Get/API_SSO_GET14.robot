*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET14
    [Documentation]    This test case is used to verify that user is able to create then GET New Single User created via API from LOB DataSource
    ...    @author: amansuet    09SEP2019    - initial create

    ## PARTY LOB ###
    ${rowid}    Set Variable   51140
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5114
    Mx Execute Template With Multiple Data    Get User with Single LOB from Created User    ${APIDataSet}    ${rowid}    Users_Fields

    ## ESSENCE LOB ###
    ${rowid}    Set Variable   52140
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5214
    Mx Execute Template With Multiple Data    Get User with Single LOB from Created User    ${APIDataSet}    ${rowid}    Users_Fields

    ## LOAN IQ LOB ###
    ${rowid}    Set Variable   53140
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5314
    Mx Execute Template With Multiple Data    Get User with Single LOB from Created User    ${APIDataSet}    ${rowid}    Users_Fields