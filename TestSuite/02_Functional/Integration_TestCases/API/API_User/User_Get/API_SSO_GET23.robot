*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_GET23
    [Documentation]    This test case is used to verify that DELETED user manually be set to INACTIVE and would reflect in GET all.
    ...    @author: amansuet    18SEP2019    - initial create
    
    ### LOAN IQ LOB ###
    ${rowid}    Set Variable   50230
    Mx Execute Template With Multiple Data    Delete User where status is set to INACTIVE and Verify using GET All User API    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   50231
    Mx Execute Template With Multiple Data    Update User for Loan IQ LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields