*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_UPD09
    [Documentation]    This testcase is used to verify that user sent with LIQ LOB and from UNLOCKED account to LOCKED account.
    ...    @author: clanding
    ...    @update: clanding    23APR2019    - changed keyword name
    ...    @update: dahijara    27AUG2019    - Added keyword to create LIQ data for execution.

    ${rowID}    Set Variable   381
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowID}    Users_Fields
        
    ${rowID}    Set Variable    38
    Mx Execute Template With Multiple Data    Update Existing User for Single LOB and From UNLOCKED Status to LOCKED    ${APIDataSet}    ${rowID}    Users_Fields