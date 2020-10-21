*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Keywords ***

Update Existing Party User
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a PUT request for existing Party user. And validate MCH UI for AD, SSO and Party.
    ...    Then validate success update in SSO Page. Then validate success update in Party.
    ...    @author: clanding    23APR2019    - initial create
    ...    @update: clanding    25APR2019    - adding validation for Party
    ...    @update: dahijara    15AUG2019    - Updated keyword to validate SSO Page. Remove titleconfig variable and 
    ...    used jobtitle instead as there is no longer need to convert the jobtitle.
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
    Update Key Values of Input JSON File for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]
    ...    &{APIDataSet}[surname]    &{APIDataSet}[countryCode]    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]
    ...    &{APIDataSet}[osUserId]    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[additionalBusinessEntity]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[additionalDepartments]
    ...    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[roles]    &{APIDataSet}[status]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[userType]
    ...    &{APIDataSet}[profileId]
    
    Update Expected API Response for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]
    ...    &{APIDataSet}[surname]    &{APIDataSet}[countryCode]    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]
    ...    &{APIDataSet}[osUserId]    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[additionalBusinessEntity]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[additionalDepartments]
    ...    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[roles]    &{APIDataSet}[status]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[userType]
    ...    &{APIDataSet}[profileId]
    
    ${Index_PARTY}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${PARTY}
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${DefaultBranch_Config}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}
    ${DefaultZone_Config}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}
    ${AddBranch_ConfigList}    Get Additional Branch Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${AddZone_ConfigList}    Get Additional Zone Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${LanguageDesc}    Get Language Description from Code and Return Description    &{APIDataSet}[locale]
    ${Role_ConfigList}    Get Role Configuration and Return Corresponding Value List    &{APIDataSet}[roles]    ${PARTY}    ${Index_PARTY}
    ${UserType_Desc}    Get User Type Code and Return Description    &{APIDataSet}[userType]
    ${DefaultBranch_DB_PARTY}    Create Query for Party Branch and Return    ${DefaultBranch_Config}
    
    Get SSO User Values    &{APIDataSet}[centralRoles]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    Compare SSO Data from Input Data    ${2Code_CountryCode}    ${CountryDesc}    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[contactNumber1]
    ...    &{APIDataSet}[locale]    &{APIDataSet}[osUserId]    &{APIDataSet}[lineOfBusiness]
    Add Current Value to JSON for User Comparison Report for SSO    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    Add Input Value to JSON for User Comparison Report for SSO    &{APIDataSet}[InputFilePath]    ${2code_countrycode}    &{APIDataSet}[loginId]    ${UserType_Desc}
    ...    &{APIDataSet}[locale]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]    &{APIDataSet}[email]    &{APIDataSet}[contactNumber1]
    ...    &{APIDataSet}[osUserId]
    Compare Input and Actual SSO Data    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    
    Get Party User Values    &{APIDataSet}[loginId]
    Compare Party Data from Input Data    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]    &{APIDataSet}[osUserId]    ${2Code_CountryCode}
    ...    ${CountryDesc}    ${UserType_Desc}    &{APIDataSet}[locale]    ${LanguageDesc}    ${DefaultZone_Config}    ${DefaultBranch_DB_PARTY}
    ...    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]    ${Role_ConfigList}
    Add Current Value to JSON for User Comparison Report for Party    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    Add Input Value to JSON for User Comparison Report for Party    &{APIDataSet}[InputFilePath]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]
    ...    &{APIDataSet}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc}    &{APIDataSet}[locale]    ${LanguageDesc}    ${DefaultZone_Config}
    ...    ${DefaultBranch_DB_PARTY}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    Compare Input and Actual Party Data    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    ###END OF PRE-REQUISITES###
    
    Run Keyword And Continue On Failure    PUT Request for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]
    ...    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Validate FFC for Multiple LOB for Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]    &{APIDataSet}[osUserId]
    ...    &{APIDataSet}[Expected_wsLIQUserDestination]    &{APIDataSet}[Actual_wsLIQUserDestination]    &{APIDataSet}[Expected_wsFinalLIQDestination]    
    ...    &{APIDataSet}[Actual_wsFinalLIQDestination]
    
    Run Keyword And Continue On Failure    Validate SSO Page for Put    ${2Code_CountryCode}    ${CountryDesc}    &{APIDataSet}[centralUserType]    &{APIDataSet}[firstName]
    ...    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]    &{APIDataSet}[osUserId]    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    ...    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Validate Update User in Party Page    &{APIDataSet}[loginId]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[jobTitle]    &{APIDataSet}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc}    &{APIDataSet}[locale]
    ...    ${LanguageDesc}    ${DefaultZone_Config}    ${DefaultBranch_DB_PARTY}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    ...    ${AddZone_ConfigList}    ${AddBranch_ConfigList}    ${Role_ConfigList}
