*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Test Cases ***

API_RISKBOOK_GET21
    [Documentation]    This test case is used to verify the RiskBook Collection for a Valid Login Id after all RiskBook has been deleted via UI
    ...    @author: xmiranda    17SEP2019    - initial create
    ...    @update: xmiranda    18SEP2019    - removed GET Request API for Riskbook before Delete Riskbook in LIQ for RB_GET_21 HighLevel Keyword

    ${rowid}    Set Variable    2101
    Mx Execute Template With Multiple Data    Update an Risk Book Without LIQ Validation using Login Id     ${APIDataSet}    ${rowid}    Riskbook
    
    ${rowid}    Set Variable    21
    Mx Execute Template With Multiple Data    Verify the RiskBook Collection for Valid Login Id after all RiskBook has been Deleted via UI     ${APIDataSet}    ${rowid}    Riskbook