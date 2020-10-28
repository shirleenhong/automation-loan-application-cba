*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***
    
DELETE User API with Multiple LOB
    [Documentation]    This keyword is used to create prerequisites for execution for DELETE API with Multiple LOB.
    ...    Send a delete request for multiple LOB while LIQ User Profile is displayed.
    ...    Validate that Party and Essence User is deleted.
    ...    Validate that SSO and LIQ is still active.
    ...    @author: jloretiz    21JAN2020    - initial create
    [Arguments]    ${APIDataSet}

    ###SEARCH USER IN LIQ###
    Verify User Status in LIQ    &{APIDataSet}[loginId]    ACTIVE

    ##PRE-REQUISITES### 
    Update Expected XML Elements for wsFinalLIQDestination - Delete    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]

    Run Keyword And Continue On Failure    DELETE Request on Single or Multiple or All LOB for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]

    ###FFC VALIDATION###
    Run Keyword And Continue On Failure    Validate FFC for Multiple LOB for Successful Delete    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputFFCResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[osUserId]    &{APIDataSet}[loginId]
    ...    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Actual_wsFinalLIQDestination]    &{APIDataSet}[InputJson]    sLIQError=TRUE

    ###PARTY AND ESSENCE DELETE VALIDATION###
    Run Keyword And Continue On Failure    Validate User If Not Existing in Database    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]    False    sLIQError=TRUE

    ###VERIFY USER IS STILL ACTIVE###
    Close All Windows on LIQ
    Verify User Status in LIQ    &{APIDataSet}[loginId]    ACTIVE
    Close All Windows on LIQ