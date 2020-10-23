*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_CRE22
	[Documentation]    This Test Case is used to create user using Demographic Fields only with minimum field lengths with valid fields 
	...    and verify that user is created successfully in AD and SSO
    ...    @author: jloretiz	29JUL2019	- initial create
    
    ${rowid}    Set Variable    22
    Mx Execute Template With Multiple Data    Create User Using Demographic Fields Only With Minimun Field Length    ${APIDataSet}    ${rowid}    Users_Fields