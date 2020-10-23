*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET09
    [Documentation]    This test case is used to verify the RiskBook Collection for Valid User Id after a RiskBook has been deleted via UI
    ...    @author: xmiranda    16SEP2019    - initial create
    ...    @update: xmiranda    18SEP2019    - removed GET Request API for Riskbook before Delete Riskbook in LIQ for RB_GET_09 HighLevel Keyword

    ${rowid}    Set Variable    91
    Mx Execute Template With Multiple Data    Update Risk Book Without LIQ Validation     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    9
    Mx Execute Template With Multiple Data    Verify the RiskBook Collection for Valid User Id after a RiskBook has been Deleted via UI     ${APIDataSet}    ${rowid}    Riskbook