*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET26
    [Documentation]    This test case is used to verify that user can Get All Users with different limit value
    ...    @author: amansuet    12SEP2019    - initial create

    ## PARTY LOB ###
    ${rowid}    Set Variable   5126
    Mx Execute Template With Multiple Data    Get All Users for Party with Limit Value 10    ${APIDataSet}    ${rowid}    Users_Fields
    
    # ### ESSENCE LOB ###
    ${rowid}    Set Variable   5226
    Mx Execute Template With Multiple Data    Get All Users for Essence with Limit Value 20    ${APIDataSet}    ${rowid}    Users_Fields
    
    # ### LOAN IQ LOB ###
    ${rowid}    Set Variable   5326
    Mx Execute Template With Multiple Data    Get All Users for LOAN IQ with Limit Value 30    ${APIDataSet}    ${rowid}    Users_Fields