*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Verify the RiskBook Collection for Valid Login Id after All RiskBook has been Deleted via API 
    [Documentation]    This keyword is used to delete a Riskbook from Riskbook user API
    ...    and validates if All Riskbook are deleted in the Risk Book Access in LoanIQ
    ...    @author: xmiranda    16SEP2019    - initial draft
    ...    @update: cfrancis    03JUL2020    - updated to use loginId instead of userId 
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API   &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[buySellIndicator]	&{APIDataSet}[markIndicator]	&{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
        
    Run Keyword And Continue On Failure    DELETE Request API for Riskbook    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[OutputAPIDelPath]    &{APIDataSet}[OutputAPIDelResponse]    sLoginId=&{APIDataSet}[loginId]
     
    Run Keyword And Continue On Failure    GET Request API for Riskbook    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Validate Empty Riskbook API Response and Validate Riskbook User ID not Displayed in LoanIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]