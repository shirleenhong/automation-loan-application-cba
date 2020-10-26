*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET16
    [Documentation]    This test case is used to verify that user is able to get RiskBook for a single RiskBook was added via API for Valid Login Id
    ...    @author: xmiranda    12SEP2019    - initial create

    ${rowid}    Set Variable    161
    Mx Execute Template With Multiple Data    Update an Risk Book Without LIQ Validation using Login Id     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    16
    Mx Execute Template With Multiple Data    Get RiskBook Collection for a Newly Created RiskBook Code using Login Id     ${APIDataSet}    ${rowid}    Riskbook