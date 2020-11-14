*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_CRE19
	[Documentation]    This Test Case is used to create user with Demographic Fields only without optional fields 
	...    and verify that user is created successfully in AD and SSO
    ...    @author: jloretizo	26JUL2019	- initial create
    
    ${rowid}    Set Variable    19
    Mx Execute Template With Multiple Data    Create User Using Demographic Fields Only Without Optional Fields    ${APIDataSet}    ${rowid}    Users_Fields