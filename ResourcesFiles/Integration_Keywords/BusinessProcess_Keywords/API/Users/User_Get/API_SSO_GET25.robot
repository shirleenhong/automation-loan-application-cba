*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
GET Request for All User API per LOB with Different Offset
    [Documentation]    This keyword is used to get all user per LOB with different offset values.
    ...    And validate MCH UI and verify that data is correct in LOB.
    ...    @author: cfrancis    16SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ###OPEN API###
    Run Keyword and Continue On Failure    Generate Random Valid Offset for Get All User per LOB    &{APIDataSet}[lineOfBusiness]
    Run Keyword and Continue On Failure    GET Request for All User API per LOB    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    sOffSetValue=${GETALLUSER_OFFSET}
    
    ### PRE-REQUISITES ###
    Run Keyword and Continue On Failure    Create Expected API Response for Get All User API    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    ${JSON}    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[lineOfBusiness]
    ### END OF PRE-REQUISITES ###
    
    ## FFC Validation ###
    Run Keyword and Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]