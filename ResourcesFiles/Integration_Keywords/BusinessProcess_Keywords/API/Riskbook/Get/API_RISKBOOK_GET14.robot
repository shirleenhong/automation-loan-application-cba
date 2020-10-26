*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Add New Risk Book and Validate Risk Book Collection using Login Id
    [Documentation]    This keyword is used to add new riskbook code in LIQ
    ...    and adds the newly created riskbook to the user via API (Update Riskbook to an existing user has API issue. Will use through UI instead)
    ...    and validates if the newly created riskbook is displayed in the riskbook collection in LIQ
    ...    @author: xmiranda    20SEP2019    - initial draft
    ...    @update: cfrancis    03JUL2020    - updated to use loginId instead of userId for some parameters
    [Arguments]    ${APIDataSet}
    
    
    Run Keyword And Continue On Failure    Add New Risk Book Code in Table Maintenance   &{APIDataSet}[riskBookCode]    &{APIDataSet}[riskBookDescription]    &{APIDataSet}[Portfolio]    &{APIDataSet}[Expense]    &{APIDataSet}[OptionalComment]
    
    Run Keyword And Continue On Failure    Update Risk Book to Existing User in LoanIQ    &{APIDataSet}[loginId]    &{APIDataSet}[riskBookCode]
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    sLoginId=&{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Get Riskbook API Response and Validate API Response to Riskbook LoanIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]