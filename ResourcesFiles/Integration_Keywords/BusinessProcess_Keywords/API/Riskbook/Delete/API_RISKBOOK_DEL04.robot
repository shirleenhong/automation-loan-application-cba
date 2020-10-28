*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Delete Single Risk Book Using Login Id
    [Documentation]    This keyword is used to validate that user is able to delete single risk book using login Id and response is 200
    ...    @author: dahijara    11SEP2019    - initial create
    ...    @update: cfrancis    06JUL2020    - update to use loginId instead of userId for some keywords
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]
    ...    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    DELETE Request API for Riskbook    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]
    ...    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]

    Run Keyword And Continue On Failure    Validate Risk Book Details to an Existing User in LoanIQ for Delete    &{APIDataSet}[loginId]    &{APIDataSet}[riskBookCode]