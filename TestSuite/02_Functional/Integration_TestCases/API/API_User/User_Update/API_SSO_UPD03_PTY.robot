*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_UPD03
    [Documentation]    This testcase is used to verify that user is able to UPDATE a user with a SINGLE LOB - Party.
    ...    @author: clanding
    ...    @update: dahijara    16AUG2019    - Continuation of API_SSO_UPD03


    ${rowid}    Set Variable    331        ###Data Preparation 
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields 
        
    ${rowID}    Set Variable    33
    Mx Execute Template With Multiple Data    Update Existing Party User    ${APIDataSet}    ${rowID}    Users_Fields