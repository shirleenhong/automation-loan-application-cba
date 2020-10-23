*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Update New Riskbook Created Via UI Using User ID
    [Documentation]    This keyword is used to validate that user is able to Update a new Riskbook created via UI using User Id.
    ...    Create risk book via LIQ then Update added risk book via API using User id.
    ...    Delete updated risk book via API after validation for update.
    ...    @author: dahijara    12SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    Update Risk Book to Existing User in LoanIQ    &{APIDataSet}[userId]    &{APIDataSet}[riskBookCode]
    
    Run Keyword And Continue On Failure    Get Risk Book Details to an Existing User Before Any Transaction    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputLIQData]    &{APIDataSet}[userId]
    
    Run Keyword And Continue On Failure    Update LIQ Risk Book Data for Comparison    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputLIQData]
    
    Run Keyword And Continue On Failure    Compare Input and Actual Risk Book Data for LIQ    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputLIQData]

    Run Keyword And Continue On Failure    Update Expected Response for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[userId]    &{APIDataSet}[updateUserId]    &{APIDataSet}[updateUserId]
    ...    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    PUT Request for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    sUserId=&{APIDataSet}[userId]

    Run Keyword And Continue On Failure    Validate Risk Book Details to an Existing User in LoanIQ for PUT    &{APIDataSet}[userId]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]
    ...    &{APIDataSet}[viewPricesIndicator]    &{APIDataSet}[updateUserId]

    Run Keyword And Continue On Failure    DELETE Request API for Riskbook    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]
    ...    &{APIDataSet}[OutputAPIDelResponse]    sUserId=&{APIDataSet}[userId]