*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Update Risk Book Without LIQ Validation
    [Documentation]    This keyword is used to validate that user is able to update an existing risk book using User Id and response is 200
    ...    @author: dahijara    2SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]

    Run Keyword And Continue On Failure    Update Expected Response for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[userId]    &{APIDataSet}[updateUserId]    &{APIDataSet}[updateUserId]
    ...    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    PUT Request for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    sUserId=&{APIDataSet}[userId]
   
Update an Risk Book Without LIQ Validation using Login Id
    [Documentation]    This keyword is used to validate that user is able to update an existing risk book using Login Id and response is 200
    ...    @author: xmiranda    12SEP2019    - initial create
    ...    @update: cfrancis    03JUL2020    - updated parameter to use loginId instead of userId for Update Expected Response for Risk Book API keyword
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]
    ...    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]

    Run Keyword And Continue On Failure    Update Expected Response for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[updateUserId]    &{APIDataSet}[updateUserId]
    ...    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    PUT Request for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    sLoginId=&{APIDataSet}[loginId]