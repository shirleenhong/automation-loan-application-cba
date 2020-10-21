*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Keywords ***
Verify Updated User Created via LOB UI using GET Single User API with Datasource
    [Documentation]    This keyword is used to create prerequisites for execution for GET API.
    ...    Verify an updated user that is created via LOB UI.
    ...    And send a GET Single User API request for a single lob user using LoginID and LOB. 
    ...    And validate MCH UI and verify that data is correct in LOB.
    ...    @author: jloretiz    16SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ###OPEN API###
    Run Keyword And Continue On Failure    Get Request for User API Single Lob    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]

    ###PREREQUISITES###
    Run Keyword And Continue On Failure    Create Expected API Response for GET USER API    ${APIDataSet}
    
    ###FFC VALIDATION###
    Run Keyword And Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]
    
    ### Validate Updated Fields ###
    Run Keyword And Continue On Failure    Validate Updated Fields via LOB UI using GET Single API    &{APIDataSet}[firstName]    firstName
    Run Keyword And Continue On Failure    Validate Updated Fields via LOB UI using GET Single API    &{APIDataSet}[surname]      surname
    
    ###LOB VALIDATION###
    Run Keyword And Continue On Failure    GET API Validation    ${APIDataSet}
