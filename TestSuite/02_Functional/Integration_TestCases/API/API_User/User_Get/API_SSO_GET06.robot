*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET06
    [Documentation]    This keyword is used to create prerequisites for execution for GET API.
    ...    And send a PUT request for a single user to update status from Locked to Unlocked.
    ...    @author: jloretiz    07SEP2019    - initial create
    
    ${rowid}    Set Variable    5106
    Mx Execute Template With Multiple Data    Update User with COMRLENDING LOB without FFC Validation for GET API    ${APIDataSet}    ${rowid}    Users_Fields
     
    ${rowid}    Set Variable    5206
    Mx Execute Template With Multiple Data    Get User with Single LOB and Update Status from Locked to Unlocked    ${APIDataSet}    ${rowid}    Users_Fields