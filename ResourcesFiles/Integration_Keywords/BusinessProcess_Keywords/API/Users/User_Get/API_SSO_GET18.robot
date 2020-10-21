*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Verify Manually Updated User from New User is Existing in GET Single User API
    [Documentation]    This keyword is used to create prerequisites for execution for GET API.
    ...    And send a GET Single User API request for an Updated user using LoginID and LOB. 
    ...    And validate MCH UI and verify that data is correct in LOB.
    ...    @author: amansuet    18SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Get Request for User API Single Lob    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]

    ### Validate Fields Updated ###
    Run Keyword And Continue On Failure    Validate Updated Fields via LOB UI using GET Single API    &{APIDataSet}[firstName]    sFieldtoCheck=firstName
    Run Keyword And Continue On Failure    Validate Updated Fields via LOB UI using GET Single API    &{APIDataSet}[surname]    sFieldtoCheck=surname
    
    ### PRE-REQUISITES ###
    Run Keyword And Continue On Failure    Create Expected API Response for GET USER API    ${APIDataSet}
    ### END OF PRE-REQUISITES ###
    
    ### FFC VALIDATION ###
    Run Keyword And Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]
    
    ### LOB VALIDATION ###
    Run Keyword And Continue On Failure    GET API Validation    ${APIDataSet}