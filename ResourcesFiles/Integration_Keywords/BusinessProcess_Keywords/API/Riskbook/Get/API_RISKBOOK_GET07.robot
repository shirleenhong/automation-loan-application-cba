*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Add New Risk Book and Validate Risk Book Collection
    [Documentation]    This keyword is used to add new riskbook code in LIQ
    ...    and adds the newly created riskbook to the user via API (Update Riskbook to an existing user has API issue. Will use through UI instead)
    ...    and validates if the newly created riskbook is displayed in the riskbook collection in LIQ
    ...    @author: xmiranda    19SEP2019    - initial draft
    [Arguments]    ${APIDataSet}
        
    Run Keyword And Continue On Failure    Add New Risk Book Code in Table Maintenance   &{APIDataSet}[riskBookCode]    &{APIDataSet}[riskBookDescription]    &{APIDataSet}[Portfolio]    &{APIDataSet}[Expense]    &{APIDataSet}[OptionalComment]
    
    Run Keyword And Continue On Failure    Update Risk Book to Existing User in LoanIQ    &{APIDataSet}[userId]    &{APIDataSet}[riskBookCode]
    
    Run Keyword And Continue On Failure    GET Request API for Riskbook    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]       sUserId=&{APIDataSet}[userId]
    
    Run Keyword And Continue On Failure    Get Riskbook API Response and Validate API Response to Riskbook LoanIQ    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]       &{APIDataSet}[userId]