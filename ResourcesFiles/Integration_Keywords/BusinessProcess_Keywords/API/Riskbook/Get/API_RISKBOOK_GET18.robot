*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Verify the RiskBook Collection for Valid Login Id after a RiskBook has been Deleted via API
    [Documentation]    This keyword is used to delete a Riskbook from Riskbook user API
    ...    and validates if the Riskbook is deleted in the Risk Book Access in LoanIQ
    ...    @author: xmiranda    11SEP2019    - initial draft
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Update Key Values of Input JSON File for Risk Book API   &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[buySellIndicator]	&{APIDataSet}[markIndicator]	&{APIDataSet}[primaryIndicator]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[viewPricesIndicator]
        
    Run Keyword And Continue On Failure    DELETE Request API for Riskbook    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]        sLoginId=&{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Validate Non-Existing Risk Book Code in Risk Book Collection    &{APIDataSet}[riskBookCode]    sLoginId=&{APIDataSet}[loginId]