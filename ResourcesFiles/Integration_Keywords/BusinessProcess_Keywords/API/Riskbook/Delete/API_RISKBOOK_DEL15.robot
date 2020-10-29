*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Delete Risk Book Added Via GUI Using User Id
    [Documentation]    This keyword is used to validate that user is able to delete single risk added via GUI book using user Id and response is 200
    ...    @author: dahijara    17SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]

    Run Keyword And Continue On Failure    Update Risk Book to Existing User in LoanIQ    &{APIDataSet}[userId]    &{APIDataSet}[riskBookCode]    
    
    Run Keyword And Continue On Failure    DELETE Request API for Riskbook    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]
    ...    &{APIDataSet}[OutputAPIDelResponse]    sUserId=&{APIDataSet}[userId]

    Run Keyword And Continue On Failure    Validate Risk Book Details to an Existing User in LoanIQ for Delete    &{APIDataSet}[userId]    &{APIDataSet}[riskBookCode]