*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Verify the RiskBook Collection for Valid User Id after all RiskBook has been Deleted via UI
    [Documentation]    This keyword is used to delete a Riskbook from Riskbook user API
    ...    and validates if all Riskbook is deleted in the Risk Book Access in LoanIQ
    ...    @author: xmiranda    17SEP2019    - initial draft
    [Arguments]    ${APIDataSet}

    Run Keyword And Continue On Failure    Delete RiskBook in LIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[userId]
       
    Run Keyword And Continue On Failure    GET Request API for Riskbook    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sUserId=&{APIDataSet}[userId]
    
    Run Keyword And Continue On Failure    Validate Empty Riskbook API Response and Validate Riskbook User ID not Displayed in LoanIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[userId]
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook and Validate if Riskbook is Not Existing    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[riskBookCode]    sUserId=&{APIDataSet}[userId]