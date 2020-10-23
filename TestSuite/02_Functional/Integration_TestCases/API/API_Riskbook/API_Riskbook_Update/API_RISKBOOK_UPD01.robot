*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD01
    [Documentation]    This test case is used to validate that user is able to update an existing risk book using Login Id and response is 200
    ...    @author: dahijara    4SEP2019    - initial create

    ${rowid}    Set Variable    201
    Mx Execute Template With Multiple Data    Update an Existing Risk Book Using User ID    ${APIDataSet}    ${rowid}    Riskbook