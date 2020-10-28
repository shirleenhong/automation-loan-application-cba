*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***
CREATE User with Invalid Minimum Field Length - 400
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request for API user multiple LOBS
    ...    And validate error messages are correct.
    ...    @author:    jloretiz    10DEC2019    - initial create
    ...    @author:    jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${APIDataSet}

    ###PRE-REQUISITES###
    ${ErrorList}    Create List     ${400_FNAME_FIELD_LENGTH_MISMATCH}    ${400_LNAME_FIELD_LENGTH_MISMATCH}    ${400_CUSERTYPE_FIELD_LENGTH_MISMATCH}    
    ...    ${400_JOBTITLE_FIELD_LENGTH_MISMATCH}    ${400_COUNTRY_FIELD_LENGTH_MISMATCH}    ${400_COUNTRY_FIELD_LENGTH_MISMATCH}   ${400_LOCALE_FIELD_LENGTH_MISMATCH}
    ...    ${400_ROLE_FIELD_LENGTH_MISMATCH}    ${400_PROCESSING_FIELD_LENGTH_MISMATCH}    ${400_CONTACT1_FIELD_LENGTH_MISMATCH}   ${400_CONTACT2_FIELD_LENGTH_MISMATCH}
    ...    ${400_PROFILE_FIELD_LENGTH_MISMATCH}    ${400_OSUSERID_FIELD_LENGTH_MISMATCH}

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

UPDATE User with Invalid Minimum Field Length - 400
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a PUT request for API user multiple LOBS
    ...    And validate error messages are correct.
    ...    @author:    jloretiz    10DEC2019    - initial create
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