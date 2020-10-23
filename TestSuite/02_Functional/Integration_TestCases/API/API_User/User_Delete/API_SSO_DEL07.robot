*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_DEL07
    [Documentation]    This test case is used to verify that user is able to Delete existing user from Party
    ...    (User SSO has only 1 associated application and same OS User ID and Login ID) 
    ...    @author: amansuet	22AUG2019	- initial create

    ${rowid}    Set Variable   3107
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable   3007
    Mx Execute Template With Multiple Data    Delete User on Single LOB for Party    ${APIDataSet}    ${rowid}    Users_Fields