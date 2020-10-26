*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_UPD10
    [Documentation]    This testcase is used to verify that user is able to UPDATE a single LOB user for an existing Multi LOB user.
    ...    (update userType for Essence or Party and verify if other LOB is not updated)
    ...    @author: clanding
    ...    @update: clanding    23APR2019    - changed keyword name
    ...    @update: dahijara    19AUG2019    - Added keywords for data preparation to succesfully execute update functionality.
    
    ${rowID}    Set Variable    3101
    Mx Execute Template With Multiple Data    Create User with Essence and Party LOBs without FFC Validation     ${APIDataSet}    ${rowID}    Users_Fields    

    ${rowID}    Set Variable    310
    Mx Execute Template With Multiple Data    Update Single LOB Details for an Existing Multi LOB User     ${APIDataSet}    ${rowID}    Users_Fields