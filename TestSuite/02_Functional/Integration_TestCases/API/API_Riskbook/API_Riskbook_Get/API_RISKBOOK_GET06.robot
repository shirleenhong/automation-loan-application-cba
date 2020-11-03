*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET06
    [Documentation]    This test case is used to verify that user is able to get RiskBook for a multiple RiskBooks added via API for Valid User Id
    ...    @author: xmiranda    12SEP2019    - initial create

    ${rowid}    Set Variable    61
    Mx Execute Template With Multiple Data    Update Risk Book Without LIQ Validation     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    6
    Mx Execute Template With Multiple Data    Get RiskBook Collection for multiple RiskBooks created using User Id     ${APIDataSet}    ${rowid}    Riskbook