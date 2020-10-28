*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Delete an Invalid Riskbook Code to a User using UserId and Verify Response Status 400
    [Documentation]    This keyword is used to verify that User will get an error when deleting a RiskBook Code that the User does not have using User ID - Response 400
    ...    @author: xmiranda    28OCT2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values and Set Default Indicator Value of Input JSON File for Risk Book API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]
    ...    &{APIDataSet}[buySellIndicator]    &{APIDataSet}[markIndicator]    &{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
    
    Run Keyword And Continue On Failure    DELETE Request API for Riskbook and Verify Response Status Code 400 and Response Message    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]
    ...    &{APIDataSet}[OutputAPIResponse]    sUserId=&{APIDataSet}[userId]