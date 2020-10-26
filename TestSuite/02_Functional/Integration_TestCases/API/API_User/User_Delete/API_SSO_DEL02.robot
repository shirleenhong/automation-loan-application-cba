*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_DEL02
        [Documentation]    Delete existing user from Essence (User SSO has 2 or more associated applications)
    ...    @author: xmiranda    14AUG2019    - initial create
    ...    @update: xmiranda    22AUG2019    - removed High level keyword for create with multiple LOBs, used the existing keyword without validation

    ${rowid}    Set Variable    3102
    Mx Execute Template With Multiple Data    Create User with Multiple LOBs without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable    3002
    Mx Execute Template With Multiple Data    Delete Existing User from Essence    ${APIDataSet}    ${rowid}    Users_Fields