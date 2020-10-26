*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE26
    [Documentation]    This testcase is used to create user for multiple LOB (LIQ, Essence, Party) without using the optional fields.
    ...    And verify that response status is 201 and passed CCB validation.
    ...    ANd user is not successfully created in SSO, LIQ, PARTY and ESSENCE.
    ...    @author: dahijara    7AUG2019    - Initial Create
    
    ${rowid}    Set Variable    26
    Mx Execute Template With Multiple Data    Create User for Multiple LOB without Using Optional Fields    ${APIDataSet}    ${rowid}    Users_Fields