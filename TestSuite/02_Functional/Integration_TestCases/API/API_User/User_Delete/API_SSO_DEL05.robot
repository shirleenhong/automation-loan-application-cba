*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_DEL05
    [Documentation]    This test case is used to verify that user is able to Delete existing user from LIQ
    ...    (User SSO has only 1 associated application and same OS User ID and Login ID)
    ...    @author: amansuet	13AUG2019    - initial create
    
    ${rowid}    Set Variable   3105
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable   3005
    Mx Execute Template With Multiple Data    Delete User on Single LOB for Loan IQ    ${APIDataSet}    ${rowid}    Users_Fields
