*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET27
    [Documentation]    This test case is used to verify that user can Get default values for limits.
    ...    @author: amansuet    13SEP2019    - initial create

    ### PARTY LOB ###
    ${rowid}    Set Variable   51270
    Mx Execute Template With Multiple Data    Get All Users per LOB with Empty Limit Value    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   51271
    Mx Execute Template With Multiple Data    Get All Users per LOB with No Limit Set    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### ESSENCE LOB ###
    ${rowid}    Set Variable   52270
    Mx Execute Template With Multiple Data    Get All Users per LOB with Empty Limit Value    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   51271
    Mx Execute Template With Multiple Data    Get All Users per LOB with No Limit Set    ${APIDataSet}    ${rowid}    Users_Fields
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   53270
    Mx Execute Template With Multiple Data    Get All Users per LOB with Empty Limit Value    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   51271
    Mx Execute Template With Multiple Data    Get All Users per LOB with No Limit Set    ${APIDataSet}    ${rowid}    Users_Fields