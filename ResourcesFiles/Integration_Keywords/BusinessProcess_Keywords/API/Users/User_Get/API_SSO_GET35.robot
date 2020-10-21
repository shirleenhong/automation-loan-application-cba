*** Settings ***
Resource    ../../../../Configurations/Import_File.robot
    
*** Keywords ***
Verify Updated User Created via LOB UI using GET All User API with Datasource
    [Documentation]    This keyword is used to create prerequisites for execution for GET API.
    ...    Verify an updated user that is created via LOB UI.
    ...    And send a GET ALL User API request for a single lob user using LoginID and LOB. 
    ...    And validate MCH UI and verify that data is correct in LOB.
    ...    @author: jloretiz    16SEP2019    - initial create
    [Arguments]    ${APIDataSet}

    Run Keyword and Continue On Failure    GET Request for All User API per LOB    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    ### PRE-REQUISITES ###
    Run Keyword and Continue On Failure    Create Expected API Response for Get All User API    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    ${JSON}    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[lineOfBusiness]
    
    ### FFC Validation ###
    Run Keyword and Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]
    
    ### Validate Updated Fields ###
    Run Keyword and Continue On Failure    Validate Updated Fields via LOB UI using GET ALL API    &{APIDataSet}[loginId]    &{APIDataSet}[firstName]    firstName
    Run Keyword and Continue On Failure    Validate Updated Fields via LOB UI using GET ALL API    &{APIDataSet}[loginId]    &{APIDataSet}[surname]      surname
    
    ### LOB Validation ###
    Run Keyword And Continue On Failure    GET API Validation for Users in Get All User API    ${APIDataSet}
