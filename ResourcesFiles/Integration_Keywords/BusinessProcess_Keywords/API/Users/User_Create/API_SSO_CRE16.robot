*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Create User for Party without Usertype and Verify Default to N
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request for Party user. And validate MCH UI for AD, SSO and Party.
    ...    Then validate success creation in SSO Page. Then validate success creation without userType in Party Page.
    ...    @author: jloretizo	25JUL2019	- initial create
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
    ${Index_PARTY}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${PARTY}
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${LanguageDesc}    Get Language Description from Code and Return Description    &{APIDataSet}[locale]
    ${UserType_Desc_PARTY}    Get User Type Code and Return Description    &{APIDataSet}[userType]    ${Index_PARTY}
    ${Title_Config_COREBANKING}    Get Job Title Configuration and Return Corresponding Config Value    &{APIDataSet}[jobTitle]    ${COREBANKING}
    ${DefaultBranch_Config_PARTY}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${DefaultZone_Config_PARTY}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${AddBranch_ConfigList_PARTY}    Get Additional Branch Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${AddZone_ConfigList_PARTY}    Get Additional Zone Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${Role_ConfigList_PARTY}    Get Role Configuration and Return Corresponding Value List    &{APIDataSet}[roles]    ${PARTY}    ${Index_PARTY}
    ${Title_Config_PARTY}    Get Job Title Configuration and Return Corresponding Config Value    &{APIDataSet}[jobTitle]    ${PARTY}
    ${DefaultBranch_DB_PARTY}    Create Query for Party Branch and Return    ${DefaultBranch_Config_PARTY}
    
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
    ###END OF PRE-REQUISITES###
    
    Run Keyword And Continue On Failure    POST Request for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]
    
    Run Keyword And Continue On Failure    Validate FFC for Multiple LOB for Success    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]    &{APIDataSet}[osUserId]
    ...    &{APIDataSet}[Expected_wsLIQUserDestination]    &{APIDataSet}[Actual_wsLIQUserDestination]    
    ...    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Actual_wsFinalLIQDestination]  
    
    Run Keyword And Continue On Failure    Validate SSO for Post Success    ${2Code_CountryCode}    ${CountryDesc}    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]
    ...    &{APIDataSet}[email]    &{APIDataSet}[osUserId]    &{APIDataSet}[lineOfBusiness]

    Run Keyword And Continue On Failure    Validate User Details in Party for Success    &{APIDataSet}[loginId]    ${UserType_Desc_PARTY}    ${2Code_CountryCode}
    ...    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    ${Title_Config_PARTY}    &{APIDataSet}[osUserId]    ${CountryDesc}    ${LanguageDesc}    &{APIDataSet}[locale]
    ...    ${DefaultZone_Config_PARTY}    ${DefaultBranch_DB_PARTY}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    ...    ${AddZone_ConfigList_PARTY}    ${AddBranch_ConfigList_PARTY}    ${Role_ConfigList_PARTY}
