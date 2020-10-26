*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Get User with Single LOB and Update Status from Locked to Unlocked
    [Documentation]    This keyword is used to create prerequisites for execution for PUT API.
    ...    And send a PUT request for a single user to update status from Locked to Unlocked. 
    ...    Verify that the user status was updated.
    ...    And validate MCH UI and verify that data is correct in LOB.
    ...    @author: jloretiz    02SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ${LOB_Dictionary}    Run Keyword And Continue On Failure    Return GET API FFC Response as Dictionary for LIQ    ${APIDataSet}
    
    Run Keyword And Continue On Failure    GET Request for User API Single Lob        &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    Run Keyword And Continue On Failure    Create Expected API Response for GET USER API    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]     &{APIDataSet}[loginId]

    Run Keyword And Continue On Failure    Verify User Lock Status is Correct    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[userLockStatus]
    
    Run Keyword And Continue On Failure    Validate LOANIQ User Lock Status    &{APIDataSet}[userLockStatus]    &{APIDataSet}[status]    &{APIDataSet}[profileId]    &{APIDataSet}[loginId]
    ...    &{LOB_Dictionary}[firstName]    &{LOB_Dictionary}[surname]    &{LOB_Dictionary}[role]