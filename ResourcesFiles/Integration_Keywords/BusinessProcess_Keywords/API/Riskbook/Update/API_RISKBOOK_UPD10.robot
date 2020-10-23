*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Update MarkIndicator Using Login ID
    [Documentation]    This keyword is used to validate that user is able to Update RiskBook Mark Indicator for a User using Login Id
    ...    @author: dahijara    9SEP2019    - initial create
    ...    @update: cfrancis    06JUL2020    - update to use loginId instead of userId for some keywords
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    Get Risk Book Details to an Existing User Before Any Transaction    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputLIQData]    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Update LIQ Risk Book Data for Comparison    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputLIQData]
    
    Run Keyword And Continue On Failure    Compare Input and Actual Risk Book Data for LIQ    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputLIQData]

    Run Keyword And Continue On Failure    Update Expected Response for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[updateUserId]    &{APIDataSet}[updateUserId]
    ...    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    PUT Request for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    sLoginId=&{APIDataSet}[loginId]

    Run Keyword And Continue On Failure    Validate Risk Book Details to an Existing User in LoanIQ for PUT    &{APIDataSet}[loginId]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]
    ...    &{APIDataSet}[viewPricesIndicator]    &{APIDataSet}[updateUserId]