*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***
    
CREATE User with Invalid Email Format
    [Documentation]    This keyword is used to create a user with invalid email format.
    ...    And send a POST request for a single user with Email Format error.
    ...    Then validates response error 400.
    ...    @author: jloretiz    13JAN2020    - initial create
    ...    @update: jloretiz    17JAN2020    - renamed the keyword to make it generic
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
    ${ErrorList}    Create List     ${400_EMAIL_INVALID}

    Update Key Values of Input JSON File for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]
    ...    &{APIDataSet}[surname]    &{APIDataSet}[countryCode]    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]
    ...    &{APIDataSet}[osUserId]    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[additionalBusinessEntity]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[additionalDepartments]
    ...    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[roles]    &{APIDataSet}[status]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[userType]
    ...    &{APIDataSet}[profileId]

    Run Keyword And Continue On Failure    POST Request for User API with Error    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]
  
    ###VALIDATION###
    Run Keyword And Continue On Failure    Validate Technical Errors on API User Response     ${RESPONSECODE_400}     ${ErrorList}

UPDATE User with Invalid Email Format
    [Documentation]    This keyword is used to update a user with invalid email format.
    ...    And send a PUT request for a single user with Email Format error.
    ...    Then validates response error 400.
    ...    @author: jloretiz    13JAN2020    - initial create
    ...    @update: jloretiz    17JAN2020    - renamed the keyword to make it generic
    [Arguments]    ${APIDataSet}
    
    ${ErrorList}    Create List     ${400_EMAIL_INVALID}
    
    Verify User Exists in LOBs      &{APIDataSet}[loginId]      &{APIDataSet}[lineOfBusiness]
    Update Key Values of Input JSON File for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]
    ...    &{APIDataSet}[surname]    &{APIDataSet}[countryCode]    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]
    ...    &{APIDataSet}[osUserId]    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[additionalBusinessEntity]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[additionalDepartments]
    ...    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[roles]    &{APIDataSet}[status]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[userType]
    ...    &{APIDataSet}[profileId]
    ###END OF PRE-REQUISITES###
    
    Run Keyword And Continue On Failure    PUT Request for User API with Error    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    &{APIDataSet}[loginId]

    ###VALIDATION###
    Run Keyword And Continue On Failure    Validate Technical Errors on API User Response     ${RESPONSECODE_400}     ${ErrorList}
    
Process Field Invalid Email    
    [Arguments]    ${APIDataSet}   
    ${val2}    ${val}    ${key}    Get Data from JSON file and handle invalid email   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    email    5    80    
    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Email
    Run Keyword If    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Email
    Run Keyword If    ${val2}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    3    User_Email