*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Delete Risk Book Using an Invalid Login ID
    [Documentation]    This keyword is used to validate that User is unable to delete using an Invalid Login ID - Response 404.
    ...    @author: dahijara    23OCT2019    - initial create
    ...    @update: cfrancis    06JUL2020    - updated to use loginId instead of userId
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]
    ...    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    DELETE Request API for Riskbook and Verify Response Status Code 404    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]
    ...    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]