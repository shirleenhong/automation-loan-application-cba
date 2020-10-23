*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD12
    [Documentation]    This test case is used to validate that user is able to Update RiskBook ViewPrice Indicator for a User using Login Id
    ...    @author: dahijara    9SEP2019    - initial create

    ${rowid}    Set Variable    212
    Mx Execute Template With Multiple Data    Update ViewPriceIndicator Using Login ID    ${APIDataSet}    ${rowid}    Riskbook