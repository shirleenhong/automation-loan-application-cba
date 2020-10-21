*** Settings ***
Resource    ../../../../Configurations/Import_File.robot
    
*** Keywords ***
    
DELETE User API with Incorrect URL
    [Documentation]    This keyword is used to create prerequisites for execution for DELETE API.
    ...    Send a delete request with an invalid URL, length for login does not meet the required characters
    ...    @author: jloretiz    17JAN2020    - initial create
    [Arguments]    ${APIDataSet}
    
    ${ErrorList}    Create List     ${400_LOGINID_FIELD_LENGTH_MISMATCH}

    ##PRE-REQUISITES### 
    Update Expected XML Elements for wsFinalLIQDestination - Delete    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    
    ...   &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]
    ###END OF PRE-REQUISITES###

    ###OPEN API###
    Run Keyword And Continue On Failure    DELETE Request on Single or Multiple or All LOB for User API with Error    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]

    ###VALIDATION###
    Run Keyword And Continue On Failure    Validate Technical Errors on API User Response     ${RESPONSECODE_400}     ${ErrorList}