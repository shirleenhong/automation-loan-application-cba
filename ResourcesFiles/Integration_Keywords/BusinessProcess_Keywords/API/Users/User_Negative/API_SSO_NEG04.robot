*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot
    
*** Keywords ***
CREATE User with Mandatory Fields Removed on the Payload
    [Documentation]    This keyword is used to create a user with mandatory field removed on the payload
    ...    @author:    jloretiz    12DEC2019    - initial create
    ...    @author:    jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${APIDataSet}

    ###PRE-REQUISITES###
    ${FieldList}    Create List     loginId    firstName    surname    jobTitle    countryCode
    ${ErrorList}    Create List     ${400_FNAME_FIELD_MISSING}    ${400_LNAME_FIELD_MISSING}    ${400_LOGINID_FIELD_MISSING}    ${400_JOBTITLE_FIELD_MISSING}    ${400_COUNTRY_FIELD_MISSING}

    Update Key Values of Input JSON File for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]
    ...    &{APIDataSet}[surname]    &{APIDataSet}[countryCode]    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]
    ...    &{APIDataSet}[osUserId]    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[additionalBusinessEntity]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[additionalDepartments]
    ...    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[roles]    &{APIDataSet}[status]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[userType]
    ...    &{APIDataSet}[profileId]
    Remove Fields on JSON Payload    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    ${FieldList}
    ###END OF PRE-REQUISITES###

    Run Keyword And Continue On Failure    POST Request for User API with Error    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]

    ###VALIDATION###
    Run Keyword And Continue On Failure    Validate Technical Errors on API User Response     ${RESPONSECODE_400}     ${ErrorList}


UPDATE User with Mandatory Fields Removed on the Payload
    [Documentation]    This keyword is used to create a user with mandatory field removed on the payload
    ...    @author:    jloretiz    12DEC2019    - initial create
    ...    @author:    jloretiz    14JAN2020    - renamed the keyword to a more generic name
    [Arguments]    ${APIDataSet}

    ###PRE-REQUISITES###
    ${FieldList}    Create List     loginId    firstName    surname    jobTitle    countryCode
    ${ErrorList}    Create List     ${400_FNAME_FIELD_MISSING}    ${400_LNAME_FIELD_MISSING}    ${400_LOGINID_FIELD_MISSING}    ${400_JOBTITLE_FIELD_MISSING}    ${400_COUNTRY_FIELD_MISSING}
    
    Verify User Exists in LOBs      &{APIDataSet}[loginId]      &{APIDataSet}[lineOfBusiness]
    Update Key Values of Input JSON File for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]
    ...    &{APIDataSet}[surname]    &{APIDataSet}[countryCode]    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]
    ...    &{APIDataSet}[osUserId]    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[additionalBusinessEntity]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[additionalDepartments]
    ...    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[roles]    &{APIDataSet}[status]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[userType]
    ...    &{APIDataSet}[profileId]
    Remove Fields on JSON Payload    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    ${FieldList}
    ###END OF PRE-REQUISITES###
    
    Run Keyword And Continue On Failure    PUT Request for User API with Error    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]    &{APIDataSet}[loginId]

    ###VALIDATION###
    Run Keyword And Continue On Failure    Validate Technical Errors on API User Response     ${RESPONSECODE_400}     ${ErrorList}