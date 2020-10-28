*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET16
    [Documentation]    This test case is used to verify that user is able to Amend then Get New Single User created via API from LOB DataSource
    ...    @author: amansuet    17SEP2019    - initial create

    ## PARTY LOB ###
    ${rowid}    Set Variable   51160
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   51161
    Mx Execute Template With Multiple Data    Update User for PARTY or ESSENCE LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
      
    ${rowid}    Set Variable   51162
    Mx Execute Template With Multiple Data    Get Single User on LOB from Updated User    ${APIDataSet}    ${rowid}    Users_Fields

    ## ESSENCE LOB ###
    ${rowid}    Set Variable   52160
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   52161
    Mx Execute Template With Multiple Data    Update User for PARTY or ESSENCE LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   52162
    Mx Execute Template With Multiple Data    Get Single User on LOB from Updated User    ${APIDataSet}    ${rowid}    Users_Fields
    
    ## ESSENCE LOB ###
    ${rowid}    Set Variable   53160
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   53161
    Mx Execute Template With Multiple Data    Update User for Loan IQ LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   53162
    Mx Execute Template With Multiple Data    Get Single User on LOB from Updated User    ${APIDataSet}    ${rowid}    Users_Fields