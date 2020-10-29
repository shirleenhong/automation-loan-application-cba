*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Default Value if False incase the Fields are Missing in Payload using Login Id
    [Documentation]    This keyword is used to update Riskbook API
    ...    and validates if the default value for indicators are false in case fields are missing when sending a payload
    ...    and validates in LIQ application if the indicators are tagged to No/N
    ...    @author: xmiranda    18SEP2019    - initial draft
    ...    @update: cfrancis    06JUL2020    - update to use loginId instead of userId for some keywords
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values and Set Default Indicator Value of Input JSON File for Risk Book API   &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    Update Expected Response and Default Indicator Value for Risk Book API   &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[loginId]    &{APIDataSet}[createUserId]    &{APIDataSet}[updateUserId]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    PUT Request for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    sLoginId=&{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook and Validate Default Indicator Values are False    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Get Riskbook API Response and Validate API Response to Riskbook LoanIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]