*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET04
    [Documentation]    This test case is used to verify that user is able to get RiskBook for a single RiskBook was added via API for Valid User Id
    ...    @author: xmiranda    11SEP2019    - initial create

    ${rowid}    Set Variable    41
    Mx Execute Template With Multiple Data    Update Risk Book Without LIQ Validation     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    4
    Mx Execute Template With Multiple Data    Get RiskBook Collection for a Newly Created RiskBook Code using User Id     ${APIDataSet}    ${rowid}    Riskbook