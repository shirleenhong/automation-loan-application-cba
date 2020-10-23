*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***
API_SSO_GET24
    [Documentation]    This keyword is used to get user that is deleted via UI.
    ...    @author: dahijara    18SEP2019    - initial create

    ## PARTY LOB ###
    ${rowid}    Set Variable   52410
    Mx Execute Template With Multiple Data    Create User with PARTY LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5241
    Mx Execute Template With Multiple Data    Get Party User After User is Deleted via UI    ${APIDataSet}    ${rowid}    Users_Fields

    # ESSENCE LOB ###
    ${rowid}    Set Variable   52420
    Mx Execute Template With Multiple Data    Create User with COREBANKING LOB without FFC Validation    ${APIDataSet}    ${rowid}    Users_Fields
    
    ${rowid}    Set Variable   5242
    Mx Execute Template With Multiple Data    Get Essence User After User is Deleted via UI    ${APIDataSet}    ${rowid}    Users_Fields