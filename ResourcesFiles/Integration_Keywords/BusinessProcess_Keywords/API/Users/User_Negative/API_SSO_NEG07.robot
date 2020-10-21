*** Settings ***
Resource    ../../../../Configurations/Import_File.robot
    
*** Keywords ***
CREATE User API with Invalid LOB on Endpoint
    [Documentation]    This keyword is used to create prerequisites for execution for CREATE API.
    ...    And send a POST request for a single user with invalid LOB.
    ...    Then validates response error 400.
    ...    @author: jloretiz    13JAN2020    - initial create
    ...    @update: jloretiz    17JAN2020    - renamed the keyword to make it generic
    [Arguments]    ${APIDataSet}
    
    ${ErrorList}    Create List     ${400_LOB_INVALID}

    ###OPEN API###
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

UPDATE User API with Invalid LOB on Endpoint
    [Documentation]    This keyword is used to create prerequisites for execution for UPDATE API.
    ...    And send a PUT request for a single user with invalid LOB.
    ...    @author: jloretiz    13JAN2020    - initial create
    ...    @update: jloretiz    17JAN2020    - renamed the keyword to make it generic
    ...    @update: cfrancis    06AUG2020    - updated LOB to get from dataset instead of being a fixed value
    [Arguments]    ${APIDataSet}
    
    ${ErrorList}    Create List     ${400_LOB_INVALID}  

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
    
Process Fields Invalid Field Value
    [Documentation]    This keyword is used to create a user with invalid field value
    ...    @author:chanario
    ...    12/20/2018 updated by clanding: Changed userID to loginId
    [Arguments]    ${APIDataSet}
    #userId    M
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    loginId    6    8    
    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    Login_ID
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    Login_ID
    
    #lobs
    ${lobs}    Get Data from JSON file and handle list data    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    lobs    
    :FOR   ${lob}   IN  @{lobs}
    \   Log  ${lob}
    # \    lineOfBusiness    M
    \   ${FieldValue_Status}    Evaluate Config File for Invalid Field value    ${Valid_LOB}    &{APIDataSet}[lineOfBusiness]    
    \    ${LOB_Value}    Catenate    &{APIDataSet}[lineOfBusiness]    :${SPACE}    
    \    Run Keyword If    ${FieldValue_Status}==False    Run Keywords    
         ...    Append To File    ${Expected_Err_List}    ${LOB_Value}
         ...    AND    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    3    User_Lob
         ...    ELSE IF    ${FieldValue_Status}==True    Log    LOB value is valid.
     # \    status    M
    \   ${FieldValue_Status}    Evaluate Config File for Invalid Field value    ${Valid_Status}    &{APIDataSet}[status]    
    \    Run Keyword If    ${FieldValue_Status}==False    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    8    User_Status
         ...    ELSE IF    ${FieldValue_Status}==True    Log    Status Value is Valid.
    # \    userLockStatus    M
    \   ${FieldValue_Status}    Evaluate Config File for Invalid Field value    ${Valid_userLockStatus}    &{APIDataSet}[userLockStatus]    
    \    Run Keyword If    ${FieldValue_Status}==False    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    8    User_UserLockStatus
         ...    ELSE IF    ${FieldValue_Status}==True    Log    UserLockStatus Value is Valid.
    
    
