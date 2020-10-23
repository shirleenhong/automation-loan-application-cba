*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD04
    [Documentation]    This test case is used to validate that user is able to Update RiskBook for a User with no existing RiskBooks using Login Id
    ...    @author: dahijara    4SEP2019    - initial create

    ${rowid}    Set Variable    204
    Mx Execute Template With Multiple Data    Update User with No Existing Risk Book Using Login ID    ${APIDataSet}    ${rowid}    Riskbook