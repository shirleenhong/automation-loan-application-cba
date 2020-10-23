*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_GET07
    [Documentation]    This keyword is used to create prerequisites for execution for GET API.
    ...    And send a PUT request for a single user to update status from Active to Inactive.
    ...    @author: jloretiz    05SEP2019    - initial create
    
    ${rowid}    Set Variable    5107
    Mx Execute Template With Multiple Data    Update User with COMRLENDING LOB without FFC Validation for GET API    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable    5207
    Mx Execute Template With Multiple Data    GET User with Single LOB and Update Status from Active to Inactive    ${APIDataSet}    ${rowid}    Users_Fields