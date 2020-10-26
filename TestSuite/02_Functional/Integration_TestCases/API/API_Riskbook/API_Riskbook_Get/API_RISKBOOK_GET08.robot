*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET08
    [Documentation]    This test case is used to verify the RiskBook Collection for a Valid User Id after RiskBook has been deleted via API
    ...    @author: xmiranda    10SEP2019    - initial create
    
    ${rowid}    Set Variable    81
    Mx Execute Template With Multiple Data    Update Risk Book Without LIQ Validation     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    8
    Mx Execute Template With Multiple Data    Verify the RiskBook Collection for Valid User Id after a RiskBook has been Deleted via API      ${APIDataSet}    ${rowid}    Riskbook