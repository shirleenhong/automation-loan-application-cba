*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Get Riskbook API Response and Validate Response to LoanIQ Using Login ID 
    [Documentation]    This keyword is used to GET Request API for Risk Book
    ...    and saves an output file for the response payload
    ...    then gets the API Response for validation to Riskbook LoanIQ
    ...    @author: xmiranda    09SEP2019    - initial draft
    ...    @update: cfrancis    03JUL2020    - removed UserID being passed for GET Request API for Riskbook and modified Login ID to be passed only
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook   &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]       
    
    Run Keyword And Continue On Failure    Get Riskbook API Response and Validate API Response to Riskbook LoanIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]