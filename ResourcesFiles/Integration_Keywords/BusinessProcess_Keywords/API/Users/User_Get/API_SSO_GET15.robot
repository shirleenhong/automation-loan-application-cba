*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***
Get All Users per LOB from LOB Datasource
    [Documentation]    This keyword is used to get all user per LOB from LOB Datasource
    ...    @author: amansuet    11SEP2019    - initial create
    [Arguments]    ${APIDataSet}

    Run Keyword and Continue On Failure    GET Request for All User API per LOB    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    ### PRE-REQUISITES ###
    Run Keyword and Continue On Failure    Create Expected API Response for Get All User API    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    ${JSON}    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[lineOfBusiness]
    ### END OF PRE-REQUISITES ###
    
    ## FFC Validation ###
    Run Keyword and Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]
    
    ## LOB Validation ###
    Run Keyword And Continue On Failure    GET API Validation for Users in Get All User API    ${APIDataSet}