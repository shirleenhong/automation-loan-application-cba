*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_NEG27_CREATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to CREATE if Profile ID is missing and LOBS is COMRLENDING
    ...    send a payload with errors
    ...    validate in FFC if failed
    ...    validate in SSO if created successfully
    ...    validate in LoanIQ it did not create
    ...    author: @clanding
    
    ${rowid}    Set Variable    42701
    Mx Execute Template With Multiple Data    Create User with missing Profile ID and LOBS is COMRLENDING    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_NEG27_UPDATE
    [Documentation]    This Testcase is used to Verify that user is NOT allowed to UPDATE if Profile ID is missing and LOBS is COMRLENDING
    ...    send a payload with errors
    ...    validate in FFC if failed
    ...    validate in SSO if created successfully
    ...    validate in LoanIQ it did not create
    ...    author: @clanding
    
    ${rowid}    Set Variable    42702
    Mx Execute Template With Multiple Data    Update User with missing Profile ID and LOBS is COMRLENDING    ${APIDataSet}    ${rowid}    Users_Fields