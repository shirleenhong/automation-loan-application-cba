*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Get RiskBook Collection for a Newly Created RiskBook Code using Login Id
    [Documentation]    This keyword is used to get RiskBook using Login Id via API
    ...    and validates if the Risk Book exists in the Risk Book Access in LoanIQ
    ...    @author: xmiranda    12SEP2019    - initial draft
    ...    @update: cfrancis    03JUL2020    - update to use loginId on some parameters instead of userId
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook   &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Validate Risk Book Details to an Existing User in LoanIQ for PUT        &{APIDataSet}[loginId]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[viewPricesIndicator]    &{APIDataSet}[updateUserId]