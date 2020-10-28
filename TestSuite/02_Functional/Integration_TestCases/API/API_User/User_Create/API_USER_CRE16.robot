*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE16
    [Documentation]    This test case is used to verify that user is able to create user for Party without userType.
	...    and verify that user is created successfully in SSO and Party.
    ...    @author: jloretiz	25JUL2019	- initial create
    
    ${rowid_party}    Set Variable    16
    Mx Execute Template With Multiple Data    Create User for Party Without Usertype and Verify Default to N    ${APIDataSet}    ${rowid_party}    Users_Fields