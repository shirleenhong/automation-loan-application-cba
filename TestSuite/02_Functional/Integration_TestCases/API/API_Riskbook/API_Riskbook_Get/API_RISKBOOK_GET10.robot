*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET10
    [Documentation]    This test case is used to verify the RiskBook Collection for Valid User Id after a RiskBook has been deleted via API 
    ...    @author: xmiranda    16SEP2019    - initial create

    ${rowid}    Set Variable    101
    Mx Execute Template With Multiple Data    Update Risk Book Without LIQ Validation     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    10
    Mx Execute Template With Multiple Data    Verify the RiskBook Collection for Valid User Id after All RiskBook has been Deleted via API     ${APIDataSet}    ${rowid}    Riskbook