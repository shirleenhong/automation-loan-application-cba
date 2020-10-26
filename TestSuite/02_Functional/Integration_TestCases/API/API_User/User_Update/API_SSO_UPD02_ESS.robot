*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_UPD02
    [Documentation]    This testcase is used to verify that user is able to UPDATE a user with a SINGLE LOB - Essence.
    ...    @author: clanding
    ...    @update: dahijara    16AUG2019    - Continuation of API_SSO_UPD02
    
    ${rowid}    Set Variable    321        ###Data Preparation
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowID}    Set Variable    32
    Mx Execute Template With Multiple Data    Update Existing Essence User    ${APIDataSet}    ${rowID}    Users_Fields
