*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD07
    [Documentation]    This test case is used to validate that user is able to Update RiskBook Buy/Sell Indicator for a User using User Id
    ...    @author: dahijara    9SEP2019    - initial create

    ${rowid}    Set Variable    207
    Mx Execute Template With Multiple Data    Update BuySellIndicator Using User Id    ${APIDataSet}    ${rowid}    Riskbook