*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Get RiskBook Collection for multiple RiskBooks created using User Id
    [Documentation]    This keyword is used to get RiskBook using User Id via API
    ...    and validates if the Risk Book exists in the Risk Book Access in LoanIQ
    ...    @author: xmiranda    12SEP2019    - initial draft
    [Arguments]    ${APIDataSet}
    
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook   &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sUserId=&{APIDataSet}[userId]
    
    Run Keyword And Continue On Failure    Validate Risk Book Details to an Existing User in LoanIQ for PUT        &{APIDataSet}[userId]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[viewPricesIndicator]    &{APIDataSet}[updateUserId]