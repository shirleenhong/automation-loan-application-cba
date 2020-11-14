*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_CRE07
    [Documentation]    This testcase is used to verify that user is able to add new LOB for existing users.
    ...    @author: clanding
    ...    @update: dahijara    22JUL2019    - Continued automation scripting for API_SSO_CRE07
    
    ${rowid}    Set Variable    711        ###Data Preparation
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable    71
    Mx Execute Template With Multiple Data    Add New LOB for Existing LIQ Users    ${APIDataSet}    ${rowid}    Users_Fields


    ${rowid}    Set Variable    721        ###Data Preparation
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields

    ${rowid}    Set Variable    72
    Mx Execute Template With Multiple Data    Add New LOB for Existing Essence Users    ${APIDataSet}    ${rowid}    Users_Fields

        
    ${rowid}    Set Variable    731        ###Data Preparation 
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
        
    ${rowid}    Set Variable    73
    Mx Execute Template With Multiple Data    Add New LOB for Existing Party Users    ${APIDataSet}    ${rowid}    Users_Fields