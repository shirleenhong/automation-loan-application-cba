*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET05
    [Documentation]    This test case is used to verify that user is able to get RiskBook for a multiple RiskBooks added via UI for Valid User Id 
    ...    @author: xmiranda    13SEP2019    - initial create

    ${rowid}    Set Variable    5
    Mx Execute Template With Multiple Data    Get RiskBook for a Multiple RiskBook Added via UI for Valid User Id     ${APIDataSet}    ${rowid}    Riskbook