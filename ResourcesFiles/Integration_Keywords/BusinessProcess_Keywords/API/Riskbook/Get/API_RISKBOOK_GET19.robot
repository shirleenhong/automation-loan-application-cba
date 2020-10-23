*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Verify the RiskBook Collection for Valid Login Id after a RiskBook has been Deleted via UI
    [Documentation]    This keyword is used to delete a Riskbook from Riskbook user API
    ...    and validates if all Riskbook is deleted in the Risk Book Access in LoanIQ
    ...    @author: xmiranda    17SEP2019    - initial draft
    ...    @update: cfrancis    03JUL2020    - updated to use loginId instead of userId
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Delete RiskBook in LIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[riskBookCode]    &{APIDataSet}[loginId]
        
    Run Keyword And Continue On Failure    Validate Non-Existing Risk Book Code in Risk Book Collection    &{APIDataSet}[riskBookCode]    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook and Validate if Riskbook is Not Existing    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[riskBookCode]    sLoginId=&{APIDataSet}[loginId]