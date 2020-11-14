*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD03
    [Documentation]    This test case is used to validate that user is able to Update RiskBook for a User with no existing RiskBooks using User Id
    ...    @author: dahijara    4SEP2019    - initial create

    ${rowid}    Set Variable    203
    Mx Execute Template With Multiple Data    Update User with No Existing Risk Book Using User ID    ${APIDataSet}    ${rowid}    Riskbook