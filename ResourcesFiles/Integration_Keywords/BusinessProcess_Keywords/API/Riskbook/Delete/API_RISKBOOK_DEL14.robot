*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Delete Risk Book Added Via API Using User Id
    [Documentation]    This keyword is used to validate that user is able to delete single risk book added via API using user Id and response is 200
    ...    @author: dahijara    10SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    Update Expected Response for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[userId]    &{APIDataSet}[updateUserId]    &{APIDataSet}[updateUserId]
    ...    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    PUT Request for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    sUserId=&{APIDataSet}[userId]  
    
    Run Keyword And Continue On Failure    Validate Risk Book Details to an Existing User in LoanIQ for PUT    &{APIDataSet}[userId]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]
    ...    &{APIDataSet}[viewPricesIndicator]    &{APIDataSet}[updateUserId]
   
    Run Keyword And Continue On Failure    DELETE Request API for Riskbook    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]
    ...    &{APIDataSet}[OutputAPIDelResponse]    sUserId=&{APIDataSet}[userId]

    Run Keyword And Continue On Failure    Validate Risk Book Details to an Existing User in LoanIQ for Delete    &{APIDataSet}[userId]    &{APIDataSet}[riskBookCode]