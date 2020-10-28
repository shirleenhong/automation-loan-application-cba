*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_SSO_UPD01
    [Documentation]    This testcase is used to verify that user is able to UPDATE a user with a SINGLE LOB - LIQ.
    ...    @author: clanding
    ...    @update: dahijara    20AUG2019    - Added keyword to create LIQ data for execution.
    
    
    ${rowID}    Set Variable   311
    Mx Execute Template With Multiple Data    Create User with COMRLENDING LOB without FFC Validation    ${APIDataSet}    ${rowID}    Users_Fields
    
    ${rowID}    Set Variable   31
    Mx Execute Template With Multiple Data    Update Existing LIQ User    ${APIDataSet}    ${rowID}    Users_Fields
    
