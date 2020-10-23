*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Update Riskbook for an Invalid Riskbook Code Using Login Id and Verify Response Status
    [Documentation]    This keyword is used to update Riskbook for an Invalid Riskbook Code
    ...    and Verify if the response status code is 400
    ...    @author: xmiranda    23OCT2019    - initial draft
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values and Set Default Indicator Value of Input JSON File for Risk Book API   &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    PUT Request for Risk Book API and Verify Response Status Code 400    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]