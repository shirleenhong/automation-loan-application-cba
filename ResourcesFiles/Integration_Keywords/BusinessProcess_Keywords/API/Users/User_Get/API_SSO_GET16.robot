*** Settings ***
Resource    ../../../../Configurations/Import_File.robot
    
*** Keywords ***
Get Single User on LOB from Updated User
    [Documentation]    This keyword is used to get single user on LOB from Updated/Amended User via API.
    ...    Then validate the fields updated are reflected in the GET Single User API Response.
    ...    @author: amansuet    11SEP2019    - initial create
    [Arguments]    ${APIDataSet}

    Run Keyword and Continue On Failure    Get Request for User API Single Lob    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    ## Validate Fields Updated ##
    Run Keyword and Continue On Failure    Validate PUT API Response Field and GET Single API Response Field    sFieldtoCheck=jobTitle
    Run Keyword and Continue On Failure    Validate PUT API Response Field and GET Single API Response Field    sFieldtoCheck=firstName
    Run Keyword and Continue On Failure    Validate PUT API Response Field and GET Single API Response Field    sFieldtoCheck=surname
    Run Keyword and Continue On Failure    Validate PUT API Response Field and GET Single API Response Field    sFieldtoCheck=contactNumber1
    Run Keyword and Continue On Failure    Validate PUT API Response Field and GET Single API Response Field    sFieldtoCheck=email
    
    ### PRE-REQUISITES ###
    Run Keyword And Continue On Failure    Create Expected API Response for GET USER API    ${APIDataSet}
    ### END OF PRE-REQUISITES ###
    
    ## FFC Validation ###
    Run Keyword And Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]
    
    ## LOB Validation ###
    Run Keyword And Continue On Failure    GET API Validation    ${APIDataSet}
