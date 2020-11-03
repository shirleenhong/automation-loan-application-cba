*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Update Riskbook with an Empty Payload Using Login Id and Verify Response Status 400
    [Documentation]    This keyword is used to update Riskbook with an Empty Array using Login Id
    ...    and Verify if the response status code is 400
    ...    @author: xmiranda    25OCT2019    - initial draft
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values and Set Default Indicator Value of Input JSON File for Risk Book API   &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    PUT Request for Risk Book API and Verify Response Status Code 400 and Exception Message    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]