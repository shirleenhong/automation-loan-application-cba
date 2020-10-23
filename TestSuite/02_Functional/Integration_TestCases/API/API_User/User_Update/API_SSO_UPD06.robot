*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_UPD06
    [Documentation]    Update existing user for LIQ and from INACTIVE status to ACTIVE with Demographic Update details
    ...    @author: xmiranda    28AUG2019    - initial create
    
    
    ${rowID}    Set Variable   361
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowID}    Users_Fields
    
    ${rowID}    Set Variable   36
    Mx Execute Template With Multiple Data    Update Existing User from Inactive to Active    ${APIDataSet}    ${rowID}    Users_Fields