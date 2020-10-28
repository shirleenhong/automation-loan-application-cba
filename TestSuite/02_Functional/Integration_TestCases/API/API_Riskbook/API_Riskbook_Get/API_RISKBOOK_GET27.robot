*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET27
    [Documentation]    This test case is used to verify that user is able to get RiskBook for a multiple RiskBooks added via API for Valid Login ID
    ...    @author: xmiranda    12SEP2019    - initial create
    ...    @update: cfrancis    03JUL2020    - updated to use keyword Update Update an Risk Book Without LIQ Validation using Login Id

    ${rowid}    Set Variable    271
    Mx Execute Template With Multiple Data    Update an Risk Book Without LIQ Validation using Login Id     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    27
    Mx Execute Template With Multiple Data    Get RiskBook Collection for Multiple RiskBooks created using Login Id     ${APIDataSet}    ${rowid}    Riskbook