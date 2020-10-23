*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG17_InvalidDelete
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to DELETE when user is non existing in all related applications
    ...    Distributor error
    ...    send a payload with errors
    ...    validate in FFC - SSO, AD and LIQ should have errors
    ...    validate in SSO - no user found
    ...    validate in LoanIQ - no user found
    
    ${rowid}    Set Variable    41701    ##all LOB
    Mx Execute Template With Multiple Data    Delete User with Invalid User ID    ${APIDataSet}    ${rowid}    Users_Fields