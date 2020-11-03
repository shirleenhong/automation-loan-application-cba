*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_UPD05
    [Documentation]    Update existing user for LIQ and from ACTIVE status to INACTIVE with Demographic Update details
    ...    @author: xmiranda    23AUG2019    - initial create
    ...    @update: xmiranda    26AUG2019    - Update only the status Active to Inactive, added Global Variable for setting UserTypeCode in the SSO Keywords 
    
    ${rowID}    Set Variable   351
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowID}    Users_Fields
    
    ${rowID}    Set Variable   35
    Mx Execute Template With Multiple Data    Update Existing User from Active to Inactive    ${APIDataSet}    ${rowID}    Users_Fields