*** Settings ***
Resource    ../../../../Configurations/Import_File.robot
    
*** Keywords ***

Create User Invalid Country Code
    [Documentation]    This keyword is used to create a user with invalid country code
    ...    @author: jaquitan/clanding
    ...    @update: cfrancis    06AUG2020    - refactored codes
    [Arguments]    ${APIDataSet}
    
    ${ErrorList}    Create List     ${400_COUNTRY_INVALID} {'&{APIDataSet}[countryCode]'} ${400_INVALID}

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
    
Update User with Invalid Country Code
    [Documentation]    This keyword is used to update a user with Invalid Country Code.
    ...    @author: clandingin
    ...    @update: cfrancis    06AUG2020    - refactored codes
    [Arguments]    ${APIDataSet}
    
    ${ErrorList}    Create List     ${400_COUNTRY_INVALID} {'&{APIDataSet}[countryCode]'} ${400_INVALID}  

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

AUDIT LOG USER SSO AD Error
    [Documentation]    This keyword is used to validate OpenAPI Audit Log and Distributor Audit Log for User/SSO API when AD have errors.
    ...    @author: clandingin
    [Arguments]    ${APIDataSet}
    
    ${ffcresp}    OperatingSystem.Get File    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputFFCResponse].json
    
    ${expected_message}    Catenate    Country code provided is not as per ISO standard
    Run Keyword And Continue On Failure    Validate OpenAPI Audit Log    ${OpenAPI_Audit_File}    &{APIDataSet}[HTTPMethodType]    ${details_name}    ${ffcresp}    ${UsersName}
    Run Keyword And Continue On Failure    Validate User Distributor Audit Log - AD Error    ${Distributor_Audit_File}    ${APIDataSet}    ${expected_message}
