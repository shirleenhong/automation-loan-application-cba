*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_DEL03
        [Documentation]    Delete existing user from Party (User SSO has 2 or more associated applications)
    ...    @author: xmiranda    21AUG2019    - initial create

    ${rowid}    Set Variable    3103
    Mx Execute Template With Multiple Data    Create User with Multiple LOBs without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable    3003
    Mx Execute Template With Multiple Data    Delete Existing User from Party    ${APIDataSet}    ${rowid}    Users_Fields