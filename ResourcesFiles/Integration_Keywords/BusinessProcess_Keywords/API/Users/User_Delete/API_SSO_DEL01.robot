*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Delete Existing User from LIQ
    [Documentation]    Delete existing user from LIQ (User SSO has 2 or more associated applications)
    ...    And send a DELETE request. Then validate if delete user is sent to FFC
    ...    And Validate if User is not existing in Loan IQ Application
    ...    And Validate if User is still existing in Essence and PARTY Database
    ...    @author: xmiranda	22AUG2019    - initial create
    ...    @update: jdelacru    22NOV2019    - added InputJson as argument for FFC validation
    [Arguments]    ${APIDataSet}
    
    ##PRE-REQUISITES### 
    Update Expected XML Elements for wsFinalLIQDestination - Delete    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]
    ###END OF PRE-REQUISITES###
    
    Run Keyword And Continue On Failure    DELETE Request on Single or Multiple or All LOB for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    Run Keyword And Continue On Failure    Validate FFC for Multiple LOB for Successful Delete    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[osUserId]    &{APIDataSet}[loginId]
    ...    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Actual_wsFinalLIQDestination]    &{APIDataSet}[InputJson]
    
    Run Keyword And Continue On Failure    Validate Loan IQ for Users with INACTIVE Status    &{APIDataSet}[loginId]    
    
    Run Keyword And Continue On Failure    Validate User If Existing in Database    &{APIDataSet}[loginId]    ${COREBANKING}
    
    Run Keyword And Continue On Failure    Validate User If Existing in Database    &{APIDataSet}[loginId]    ${PARTY}