*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***
DELETE User Created via LOB UI and Verify using GET All User API
    [Documentation]    This keyword is used to create prerequisites for execution for GET API.
    ...    And send a GET request for a single lob user using LoginID and LOB. 
    ...    And validate MCH UI and verify that data is correct in LOB.
    ...    @author: jloretiz    02SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword and Continue On Failure    GET Request for All User API per LOB    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    Run Keyword And Continue On Failure    DELETE Request on Single or Multiple or All LOB for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    Run Keyword and Continue On Failure    GET Request for All User API per LOB    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    sIsDelete=${TRUE}
    
    ### PRE-REQUISITES ###
    Run Keyword and Continue On Failure    Create Expected API Response for Get All User API    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    ${JSON}    &{APIDataSet}[InputFilePath]    
    ...    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[lineOfBusiness]
    ### END OF PRE-REQUISITES ###
    
    ## FFC Validation ###
    Run Keyword and Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]
    
    ## LOB Validation ###
    Run Keyword And Continue On Failure    GET API Validation for DELETE    ${APIDataSet}