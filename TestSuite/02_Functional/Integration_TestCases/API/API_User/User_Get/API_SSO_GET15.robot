*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET15
    [Documentation]    This test case is used to verify that user is able to GET All Users created via API from LOB DataSource
    ...    @author: amansuet    11SEP2019    - initial create

    ## PARTY LOB ###
    ${rowid}    Set Variable   51150
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5115
    Mx Execute Template With Multiple Data    Get All Users per LOB from LOB Datasource    ${APIDataSet}    ${rowid}    Users_Fields

    ## ESSENCE LOB ###
    ${rowid}    Set Variable   52150
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5215
    Mx Execute Template With Multiple Data    Get All Users per LOB from LOB Datasource    ${APIDataSet}    ${rowid}    Users_Fields

    ## LOAN IQ LOB ###
    ${rowid}    Set Variable   53150
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5315
    Mx Execute Template With Multiple Data    Get All Users per LOB from LOB Datasource    ${APIDataSet}    ${rowid}    Users_Fields