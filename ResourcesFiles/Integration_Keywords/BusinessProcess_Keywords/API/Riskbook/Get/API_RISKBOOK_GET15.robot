*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Get RiskBook for a Single RiskBook Added via UI for Valid Login Id
    [Documentation]    This keyword is used to get RiskBook for a single RiskBook added via UI for Valid Login Id
    ...    and validates if there are no Risk Book Access in LoanIQ
    ...    @author: xmiranda    13SEP2019    - initial draft
    ...    @update: cfrancis    03JUL2020    - update to use loginId instead of userId for some parameters of the keyword
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Risk Book to Existing User in LoanIQ    &{APIDataSet}[loginId]    &{APIDataSet}[riskBookCode]
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Get Riskbook API Response and Validate API Response to Riskbook LoanIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API   &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[buySellIndicator]	&{APIDataSet}[markIndicator]	&{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    DELETE Request API for Riskbook    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[OutputAPIDelPath]    &{APIDataSet}[OutputAPIDelResponse]    sLoginId=&{APIDataSet}[loginId]