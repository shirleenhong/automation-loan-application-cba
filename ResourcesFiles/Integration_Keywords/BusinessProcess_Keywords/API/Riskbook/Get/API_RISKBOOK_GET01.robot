*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Get Riskbook API Response and Validate Response to LoanIQ 
    [Documentation]    This keyword is used to GET Request API for Risk Book
    ...    and saves an output file for the response payload
    ...    then gets the API Response for validation to Riskbook LoanIQ
    ...    @author: xmiranda    29AUG2019    - initial draft
    ...    @update: dahijara    21MAY2020    - Updated arguments for GET request API for Riskbook. Removed LoginID parameter.
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook   &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sUserId=&{APIDataSet}[userId]    
    
    Run Keyword And Continue On Failure    Get Riskbook API Response and Validate API Response to Riskbook LoanIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[userId]