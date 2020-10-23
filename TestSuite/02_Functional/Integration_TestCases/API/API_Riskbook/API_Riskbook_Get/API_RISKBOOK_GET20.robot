*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET20
    [Documentation]    This test case is used to verify the RiskBook Collection for Valid Login Id after a RiskBook has been deleted via API 
    ...    @author: xmiranda    16SEP2019    - initial create

    ${rowid}    Set Variable    2001
    Mx Execute Template With Multiple Data    Update an Risk Book Without LIQ Validation using Login Id     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    20
    Mx Execute Template With Multiple Data    Verify the RiskBook Collection for Valid Login Id after All RiskBook has been Deleted via API     ${APIDataSet}    ${rowid}    Riskbook