*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_UPD07
    [Documentation]    This testcase is used to verify that user sent with LIQ LOB and from LOCKED account to UNLOCKED account.
    ...    @author: clanding
    ...    @update: clanding    23APR2019    - changed keyword name
    ...    @update: dahijara    20AUG2019    - Added keyword to create LIQ data for execution.
    

    ${rowID}    Set Variable   371
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowID}    Users_Fields
        
    ${rowID}    Set Variable    37
    Mx Execute Template With Multiple Data    Update Existing User for Single LOB and From LOCKED Account to UNLOCKED    ${APIDataSet}    ${rowID}    Users_Fields