*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Riskbook User with Empty Response Using Login ID
    [Documentation]    This keyword is used to get an empty response from Riskbook user API
    ...    and validates if there are no Risk Book Access in LoanIQ
    ...    @author: xmiranda    09SEP2019    - initial draft
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook   &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[userId]    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Validate Empty Riskbook API Response and Validate Riskbook User ID not Displayed in LoanIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[userId]