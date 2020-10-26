*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET03
    [Documentation]    This test case is used to verify that user is able to get RiskBook for a single RiskBook added via UI for Valid User Id 
    ...    @author: xmiranda    06SEP2019    - initial create
    ...    @update: xmiranda    16SEP2019    - added Refresh Tables in LIQ for Update Risk Book to Existing User in LoanIQ keyword

    ${rowid}    Set Variable    3
    Mx Execute Template With Multiple Data    Get RiskBook for a Single RiskBook Added via UI for Valid User Id     ${APIDataSet}    ${rowid}    Riskbook