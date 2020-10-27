*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET11
    [Documentation]    This test case is used to verify the RiskBook Collection for a Valid User Id after all RiskBook has been deleted via UI
    ...    @author: xmiranda    17SEP2019    - initial create
    ...    @update: xmiranda    18SEP2019    - removed GET Request API for Riskbook before Delete Riskbook in LIQ for RB_GET_11 HighLevel Keyword

    ${rowid}    Set Variable    111
    Mx Execute Template With Multiple Data    Update Risk Book Without LIQ Validation     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    11
    Mx Execute Template With Multiple Data    Verify the RiskBook Collection for Valid User Id after all RiskBook has been Deleted via UI     ${APIDataSet}    ${rowid}    Riskbook