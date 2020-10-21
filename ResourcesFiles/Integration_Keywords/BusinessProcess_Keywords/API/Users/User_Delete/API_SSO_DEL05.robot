*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***

Delete User on Single LOB for Loan IQ
    [Documentation]    This keyword is used to delete user with single lob for Loan IQ
    ...    and validate successful delete in FFC, SSO and Loan IQ
    ...    @author: amansuet	14AUG2019	- initial create
    ...    @update: jdelacru    22NOV2019    - added InputJson as argument for FFC validation
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES### 
    Update Expected XML Elements for wsFinalLIQDestination - Delete    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]
    ###END OF PRE-REQUISITES###
    
    Run Keyword And Continue On Failure    DELETE Request on Single or Multiple or All LOB for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    Run Keyword And Continue On Failure    Validate FFC for Multiple LOB for Successful Delete    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[osUserId]    &{APIDataSet}[loginId]
    ...    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Actual_wsFinalLIQDestination]    &{APIDataSet}[InputJson]
    
    # Run Keyword And Continue On Failure    Validate SSO for Delete Success    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Validate Loan IQ for Users with INACTIVE Status    &{APIDataSet}[profileId]