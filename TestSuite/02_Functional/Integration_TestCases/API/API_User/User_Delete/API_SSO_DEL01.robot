*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_DEL01
        [Documentation]    Delete existing user from LIQ (User SSO has 2 or more associated applications)
    ...    @author: xmiranda    22AUG2019    - initial create

    ${rowid}    Set Variable    30101
    Mx Execute Template With Multiple Data    Create User with Multiple LOBs without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable    30001
    Mx Execute Template With Multiple Data    Delete Existing User from LIQ    ${APIDataSet}    ${rowid}    Users_Fields