*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_DEL11
    [Documentation]    This test case is used to verify that user is able to Delete existing user for All LOBs. 
    ...    The Open API method which require only userId as a parameter to be used. There is no explicit argument required as LOB.
    ...    @author: amansuet	27AUG2019	- initial create

    ${rowid}    Set Variable   3111
    Mx Execute Template With Multiple Data    Create User with Multiple LOBs without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable   3011
    Mx Execute Template With Multiple Data    Delete User for All LOBs    ${APIDataSet}    ${rowid}    Users_Fields