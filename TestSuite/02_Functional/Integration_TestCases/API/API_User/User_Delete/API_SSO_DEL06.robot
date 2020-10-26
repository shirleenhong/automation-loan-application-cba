*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_DEL06
    [Documentation]    This test case is used to verify that user is able to Delete existing user from Essence 
    ...    (User SSO has 1 associated application and same OS User ID and Login ID)
    ...    @author: amansuet	21AUG2019	 - initial create

    ${rowid}    Set Variable   3106
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable   3006
    Mx Execute Template With Multiple Data    Delete User on Single LOB for Essence    ${APIDataSet}    ${rowid}    Users_Fields