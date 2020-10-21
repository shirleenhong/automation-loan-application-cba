*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Keywords ***
Delete Existing User from Party
    [Documentation]    Delete existing user from Party (User SSO has 2 or more associated applications)
    ...    And send a DELETE request. Then validate if delete user is sent to FFC
    ...    And Validate if User is not existing in Party Enquire Page 
    ...    And Validate if User is still existing in LIQ and Essence Database
    ...    @author: xmiranda	21AUG2019	- initial create
    ...    @update: jdelacru    22NOV2019    - added InputJson as argument for FFC validation
    [Arguments]    ${APIDataSet}

    Run Keyword And Continue On Failure    DELETE Request on Single or Multiple or All LOB for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    Run Keyword And Continue On Failure    Validate FFC for Multiple LOB for Successful Delete    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[osUserId]    &{APIDataSet}[loginId]
    ...    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Actual_wsFinalLIQDestination]    &{APIDataSet}[InputJson]
    
    Run Keyword And Continue On Failure    Validate Party for Delete Success    &{APIDataSet}[loginId]    
    
    Run Keyword And Continue On Failure    Validate User If Existing in Database    &{APIDataSet}[loginId]    ${COMRLENDING}
    
    Run Keyword And Continue On Failure    Validate User If Existing in Database    &{APIDataSet}[loginId]    ${COREBANKING}
    
