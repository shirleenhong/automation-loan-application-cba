*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***
Get User with Single LOB and No Datasource Specified
    [Documentation]    This keyword is used to get single user using LoginId at LOB with NO Datasource specified.
    ...    And create prerequisites for execution for GET API. 
    ...    Then validate MCH UI and verify that data is correct in LOB.
    ...    @author: amansuet    02SEP2019    - initial create
    [Arguments]    ${APIDataSet}

    ###OPEN API###
    Run Keyword And Continue On Failure    Get Request for User API Single Lob    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    ${FALSE}

    ###PREREQUISITES###
    Run Keyword And Continue On Failure    Create Expected API Response for GET USER API    ${APIDataSet}

    ###FFC VALIDATION###
    Run Keyword And Continue On Failure    Validate FFC for GET API Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]

    ###LOB VALIDATION###
    Run Keyword And Continue On Failure    GET API Validation    ${APIDataSet}