*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_UPD10
    [Documentation]    This test case is used to validate that user is able to Update RiskBook Mark Indicator for a User using Login Id
    ...    @author: dahijara    9SEP2019    - initial create

    ${rowid}    Set Variable    210
    Mx Execute Template With Multiple Data    Update MarkIndicator Using Login ID    ${APIDataSet}    ${rowid}    Riskbook