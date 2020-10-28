*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_CRE20
	[Documentation]    This Test Case is used to create user per LOB (LIQ, Essence, Party) with minimum field lengths for all fields 
	...    and verify that there is no error in CCB
    ...    @author: jloretiz	05AUG2019	- initial create
    
    ${rowid_ess}    Set Variable    202
    Mx Execute Template With Multiple Data    Create User for Essence with Minimum Field Length	    ${APIDataSet}    ${rowid_ess}    Users_Fields
    
    ${rowid_par}    Set Variable    203
    Mx Execute Template With Multiple Data    Create User for Party with Minimum Field Length	    ${APIDataSet}    ${rowid_par}    Users_Fields
    
    ${rowid_liq}    Set Variable    201
    Mx Execute Template With Multiple Data    Create User for LIQ with Minimum Field Length	        ${APIDataSet}    ${rowid_liq}    Users_Fields