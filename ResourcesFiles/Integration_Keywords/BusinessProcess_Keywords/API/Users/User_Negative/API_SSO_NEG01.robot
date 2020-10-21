*** Settings ***
Resource    ../../../../Configurations/Import_File.robot
    
*** Keywords ***
CREATE User with Invalid Maximum Field Length - 400
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request for API user multiple LOBS
    ...    And validate error messages are correct.
    ...    @author:    jloretiz    11DEC2019    - initial create
    ...    @author:    jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${APIDataSet}

    ###PRE-REQUISITES###
    ${ErrorList}    Create List     ${400_FNAME_FIELD_LENGTH_MISMATCH}    ${400_LNAME_FIELD_LENGTH_MISMATCH}    ${400_CUSERTYPE_FIELD_LENGTH_MISMATCH}    
    ...    ${400_JOBTITLE_FIELD_LENGTH_MISMATCH}    ${400_COUNTRY_FIELD_LENGTH_MISMATCH}    ${400_COUNTRY_FIELD_LENGTH_MISMATCH}   ${400_LOCALE_FIELD_LENGTH_MISMATCH}
    ...    ${400_ROLE_FIELD_LENGTH_MISMATCH}    ${400_PROCESSING_FIELD_LENGTH_MISMATCH}    ${400_CONTACT1_FIELD_LENGTH_MISMATCH}   ${400_CONTACT2_FIELD_LENGTH_MISMATCH}
    ...    ${400_PROFILE_FIELD_LENGTH_MISMATCH}    ${400_DEPTCODE_FIELD_LENGTH_MISMATCH}    ${400_OSUSERID_FIELD_LENGTH_MISMATCH}   ${400_EMAIL_FIELD_LENGTH_MISMATCH}
    ...    ${400_LOCATION_FIELD_LENGTH_MISMATCH}

    Update Key Values of Input JSON File for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]
    ...    &{APIDataSet}[surname]    &{APIDataSet}[countryCode]    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]
    ...    &{APIDataSet}[osUserId]    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[additionalBusinessEntity]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[additionalDepartments]
    ...    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[roles]    &{APIDataSet}[status]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[userType]
    ...    &{APIDataSet}[profileId]
    ###END OF PRE-REQUISITES###

    Run Keyword And Continue On Failure    POST Request for User API with Error    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]

    ###VALIDATION###
    Run Keyword And Continue On Failure    Validate Technical Errors on API User Response     ${RESPONSECODE_400}     ${ErrorList}

UPDATE User with Invalid Maximum Field Length - 400
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a PUT request for API user multiple LOBS
    ...    And validate error messages are correct.
    ...    @author:    jloretiz    11DEC2019    - initial create
    ...    @author:    jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${APIDataSet}

    ###PRE-REQUISITES###
    ${ErrorList}    Create List     ${400_FNAME_FIELD_LENGTH_MISMATCH}    ${400_LNAME_FIELD_LENGTH_MISMATCH}    ${400_CUSERTYPE_FIELD_LENGTH_MISMATCH}    
    ...    ${400_JOBTITLE_FIELD_LENGTH_MISMATCH}    ${400_COUNTRY_FIELD_LENGTH_MISMATCH}    ${400_COUNTRY_FIELD_LENGTH_MISMATCH}   ${400_LOCALE_FIELD_LENGTH_MISMATCH}
    ...    ${400_ROLE_FIELD_LENGTH_MISMATCH}    ${400_PROCESSING_FIELD_LENGTH_MISMATCH}    ${400_CONTACT1_FIELD_LENGTH_MISMATCH}   ${400_CONTACT2_FIELD_LENGTH_MISMATCH}
    ...    ${400_PROFILE_FIELD_LENGTH_MISMATCH}    ${400_OSUSERID_FIELD_LENGTH_MISMATCH}

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

Process Fields Maximum Field Length
    [Documentation]    This keyword is used to process fields with invalid input for maximum field length
    ...    @author:jaquitan/chanario
    ...    12/20/2018 updated by clanding: Changed userID to loginId, changed loginId min/max to 2/20, added profileId,
    ...    changed Get keyword for lineOfBusiness to 'Get Data from JSON object and handle single data'
    [Arguments]    ${APIDataSet}
    
      #userId    M
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    loginId    2    20    
    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_LoginID
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_LoginID
    
     # #firstName    M
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    firstName    1   20    
    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_FirstName
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_FirstName

    # #surname    M 
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    surname    1    20    
    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_SurName
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_SurName
    
    # #contactNumber1 
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    contactNumber1    5    40    
    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_ContactNumber1
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_ContactNumber1

    #contactNumber2 
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    contactNumber2    5    40    
    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_ContactNumber2
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_ContactNumber2
    
    # #countryCode    M 
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    countryCode    3    3    
        Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_CountryCode
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_CountryCode
    
     # #locale     
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    locale    2    10    
        Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Locale
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Locale
    
     # #jobTitle    M 
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    jobTitle    2    20    
        Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_JobTitle
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_JobTitle
    
    # #email     
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    email    5    80    
        Run Keyword If    ${val}==True    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Email
    ...    AND    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    3    User_Email
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Email
    
    # #osUserId     
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    osUserId    1    30    
        Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_OsUserId
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_OsUserId
    
     # centralRoles
     ${centralRoles}    Get Data from JSON file and handle list data    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    centralRoles 
    :FOR   ${role}   IN  @{centralRoles}
    \   Log  ${role}
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${role}    $..role    1    20
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Role
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Role
    
    # #centralUserType     
    ${val}    ${key}    Get Data from JSON file and handle single data   ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    centralUserType    1    2    
        Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_CentralUserType
    ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_CentralUserType
    
    #lobs
    ${lobs}    Get Data from JSON file and handle list data    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json    lobs    
    :FOR   ${lob}   IN  @{lobs}
    \   Log  ${lob}
    # \    defaultBusinessEntity
    \   ${val}    ${key}    Get Data from JSON object and handle single data with inner field name    ${lob}    $..defaultBusinessEntity    businessEntityName    2    20
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_BusinessEntityName
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_BusinessEntityName 
    \   ${val}    ${key}    Get Data from JSON object and handle single data with inner field name    ${lob}    $..defaultBusinessEntity    defaultBranch    2    10
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_DefaultBranch
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_DefaultBranch
    # additionalBusinessEntity
    \    @{additionalBusinessEntity}=    Get Data from JSON object and handle list data    ${lob}    additionalBusinessEntity    
    \    Handle AdditionalBusinessEntity    @{additionalBusinessEntity} 
    #   # defaultProcessingArea    M
    \   ${val}    ${key}    Get Data from JSON object and handle single data with inner field name    ${lob}    $..defaultProcessingArea    processingArea    2    5
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_ProcessingAreaCode
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_ProcessingAreaCode
    #    additionalProcessingArea    M
    \    @{additionalProcessingArea}=    Get Data from JSON object and handle list data    ${lob}    additionalProcessingArea    
    \    Handle AdditionalProcessingArea    @{additionalProcessingArea} 
    #    primaryDepartment    M
    \   ${val}    ${key}    Get Data from JSON object and handle single data with inner field name    ${lob}    $..primaryDepartment    departmentCode    1    5
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_DepartmentCode
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_DepartmentCode
    # \    additionalDepartments    M
    \    @{additionalDepartments}=    Get Data from JSON object and handle list data    ${lob}    additionalDepartments    
    \    Handle AdditionalDepartments    @{additionalDepartments} 
    #    location
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${lob}    $..location    1    20
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Location
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Location
    #    roles    M
    \    @{roles}=    Get Data from JSON object and handle list data    ${lob}    roles    
    \    Handle Roles    @{roles} 
    # \    status    M
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${lob}    $..status    1    10
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Status
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Status
    # #     userType   
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${lob}    $..userType    1    2
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Type
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Type
    \    
    \   ## profileId##   
    \   ${val}    ${key}    Get Data from JSON object and handle single data    ${lob}    $..profileId    2    20
    \    Run Keyword If    ${val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_ProfileId
         ...    ELSE IF    ${key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_ProfileId