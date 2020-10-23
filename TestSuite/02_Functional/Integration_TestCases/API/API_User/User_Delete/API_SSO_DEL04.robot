*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_DEL04_LIQESS
    [Documentation]    This test case is used to verify that user is able to Delete existing user for multiple LOBs.
    ...    The deleted lobs for this test case are loan iq and essence.
    ...    @author: amansuet	23AUG2019    - initial create

    ${rowid}    Set Variable   31041
    Mx Execute Template With Multiple Data    Create User with Multiple LOBs without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable   30041
    Mx Execute Template With Multiple Data    Delete User on Loan IQ and Essence LOBs    ${APIDataSet}    ${rowid}    Users_Fields
   
API_SSO_DEL04_LIQPTY
    [Documentation]    This test case is used to verify that user is able to Delete existing user for multiple LOBs.
    ...    The deleted lobs for this test case are loan iq and party.
    ...    @author: amansuet	27AUG2019    - initial create

    ${rowid}    Set Variable   31042
    Mx Execute Template With Multiple Data    Create User with Multiple LOBs without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable   30042
    Mx Execute Template With Multiple Data    Delete User on Loan IQ and Party LOBs    ${APIDataSet}    ${rowid}    Users_Fields

API_SSO_DEL04_ESSPTY
    [Documentation]    This test case is used to verify that user is able to Delete existing user for multiple LOBs.
    ...    The deleted lobs for this test case are essence and party.
    ...    @author: amansuet	27AUG2019    - initial create

    ${rowid}    Set Variable   31043
    Mx Execute Template With Multiple Data    Create User with Multiple LOBs without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable   30043
    Mx Execute Template With Multiple Data    Delete User on Essence and Party LOBs    ${APIDataSet}    ${rowid}    Users_Fields