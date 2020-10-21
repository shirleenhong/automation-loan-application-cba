*** Settings ***
Resource    ../../../../Configurations/Import_File.robot
    
*** Keywords ***
Get Party User After User is Deleted via UI
    [Documentation]    This keyword is used to get user for Party that is deleted via UI.
    ...    Validate that response is correct in FFC for GET deleted user.
    ...    @author: dahijara    18SEP2019    - initial create
    [Arguments]    ${APIDataSet}

    
    Run Keyword And Continue On Failure    GET Request for User API Single Lob    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    Run Keyword And Continue On Failure    Delete Party User in Party UI    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    GET Request for User API Single Lob    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    sIsDelete=${TRUE}
    
    Run Keyword and Continue On Failure    Validate FFC for GET API Deleted User    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]
   
    Run Keyword And Continue On Failure    GET API Validation for DELETE    ${APIDataSet}
    
Get Essence User After User is Deleted via UI
    [Documentation]    This keyword is used to get user for Essence that is deleted via UI.
    ...    Validate that response is correct in FFC for GET deleted user.
    ...    @author: dahijara    19SEP2019    - initial create
    [Arguments]    ${APIDataSet}

    
    Run Keyword And Continue On Failure    GET Request for User API Single Lob    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    
    Run Keyword And Continue On Failure    Delete User in Essence    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    GET Request for User API Single Lob    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    sIsDelete=${TRUE}
    
    Run Keyword and Continue On Failure    Validate FFC for GET API Deleted User    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[InputFFCResponse]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]
   
    Run Keyword And Continue On Failure    GET API Validation for DELETE    ${APIDataSet}    
    

    
