*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Get Riskbook Using Login Id and Verify Response Status
    [Documentation]    This keyword is used to get riskbook and verify if the response status is 404 
    ...    @author: xmiranda    22OCT2019    - initial draft
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook and Verify Response Status Code 404    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]