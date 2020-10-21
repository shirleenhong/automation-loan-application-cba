*** Settings ***
Resource    ../../../../Configurations/Import_File.robot
    
*** Keywords ***
Delete User where status is set to INACTIVE and Verify using GET All User API
    [Documentation]    This keyword is used to delete user where status is set to INACTIVE and verify using GET All User API.
    ...    @author: amansuet    18SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Set ACTIVE Loan IQ User to INACTIVE    &{APIDataSet}[profileId]    &{APIDataSet}[status]

    Run Keyword and Continue On Failure    GET Request for All User API per LOB    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    ${FALSE}
    
    Run Keyword And Continue On Failure    Validate Updated Fields via LOB UI using GET ALL API    &{APIDataSet}[loginId]    &{APIDataSet}[status]    sFieldtoCheck=status
    
    ### PRE-REQUISITES ###
    Run Keyword and Continue On Failure    Create Expected API Response for Get All User API    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    ${JSON}    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[lineOfBusiness]
    ### END OF PRE-REQUISITES ###
    
    ## FFC Validation ###
    Run Keyword and Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]
    
    ## LOB Validation ###
    Run Keyword And Continue On Failure    GET API Validation for Users in Get All User API    ${APIDataSet}
