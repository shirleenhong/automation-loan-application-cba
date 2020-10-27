*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_GET19
    
    [Documentation]    This test case is used to verify that user is able to create then GET New Single User created via API from LOB DataSource
    ...    @author: cfrancis    17SEP2019    - initial create
    
    ## LOAN IQ LOB ###
    ${rowid}    Set Variable   5019
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5119
    Mx Execute Template With Multiple Data    Update User for Loan IQ LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5219
    Mx Execute Template With Multiple Data    Get User with Single LOB from Updated Secondary Processing    ${APIDataSet}    ${rowid}    Users_Fields