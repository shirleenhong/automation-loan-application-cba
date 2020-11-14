*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET17
    [Documentation]    This test case is used to verify that user is able to Amend then Get All Users created via API from LOB DataSource
    ...    @author: amansuet    11SEP2019    - initial create

    # PARTY LOB ###
    ${rowid}    Set Variable   51170
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   51171
    Mx Execute Template With Multiple Data    Update User for PARTY or ESSENCE LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   51172
    Mx Execute Template With Multiple Data    Get All Users on LOB from Updated User    ${APIDataSet}    ${rowid}    Users_Fields

    ## ESSENCE LOB ###
    ${rowid}    Set Variable   52170
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   52171
    Mx Execute Template With Multiple Data    Update User for PARTY or ESSENCE LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   52172
    Mx Execute Template With Multiple Data    Get All Users on LOB from Updated User    ${APIDataSet}    ${rowid}    Users_Fields

    ## ESSENCE LOB ###
    ${rowid}    Set Variable   53170
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   53171
    Mx Execute Template With Multiple Data    Update User for Loan IQ LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   53172
    Mx Execute Template With Multiple Data    Get All Users on LOB from Updated User    ${APIDataSet}    ${rowid}    Users_Fields