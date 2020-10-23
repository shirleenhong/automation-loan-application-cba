*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Add New LOB for Existing LIQ Users
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request for Essence and Party user. And validate MCH UI for AD, SSO, and corresponding application (Essence and Party).
    ...    Then validate success creation in SSO Page. Then validate success creation in Essence and Party.
    ...    @author: clanding
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: jdelacru    28MAY2019    - corrected arguments for validation of essence and party page
    ...    @update: dahijara    22JUL2019    - corrected arguments for validation of essence and party page
    ...    AND   - added needed variables in pre-requisites.
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
    ${Index_COREBANKING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COREBANKING}
    ${Index_COMRLENDING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COMRLENDING}
    ${Index_PARTY}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${PARTY}
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${LanguageDesc}    Get Language Description from Code and Return Description    &{APIDataSet}[locale]
    ${UserType_Desc_COREBANKING}    Get User Type Code and Return Description    &{APIDataSet}[userType]    ${Index_COREBANKING}
    ${UserType_Desc_PARTY}    Get User Type Code and Return Description    &{APIDataSet}[userType]    ${Index_PARTY}
    ${LIQ_JobFunctionList}    Get Job Function Code from Config Setup    &{APIDataSet}[roles]    ${Index_COMRLENDING}
    ${DefaultBranch_Config_COREBANKING}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${DefaultZone_Config_COREBANKING}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${AddBranch_ConfigList_COREBANKING}    Get Additional Branch Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${AddZone_ConfigList_COREBANKING}    Get Additional Zone Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${Role_ConfigList_COREBANKING}    Get Role Configuration and Return Corresponding Value List    &{APIDataSet}[roles]    ${COREBANKING}    ${Index_COREBANKING}
    # ${Title_Config_COREBANKING}    Get Job Title Configuration and Return Corresponding Config Value    &{APIDataSet}[jobTitle]    ${COREBANKING}
    ${DefaultBranch_Config_PARTY}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${DefaultZone_Config_PARTY}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${AddBranch_ConfigList_PARTY}    Get Additional Branch Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${AddZone_ConfigList_PARTY}    Get Additional Zone Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${Role_ConfigList_PARTY}    Get Role Configuration and Return Corresponding Value List    &{APIDataSet}[roles]    ${PARTY}    ${Index_PARTY}
    ${Title_Config_PARTY}    Get Job Title Configuration and Return Corresponding Config Value    &{APIDataSet}[jobTitle]    ${PARTY}
    
    ${DefaultBranch_DB_COREBANKING}    Create Query for Essence Branch and Return    ${DefaultBranch_Config_COREBANKING}
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
    
    Get SSO User Values    &{APIDataSet}[centralRoles]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
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
    
    Run Keyword And Continue On Failure    Validate User in Essence Page for Success    &{APIDataSet}[loginId]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[jobTitle]     &{APIDataSet}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc_COREBANKING}    &{APIDataSet}[locale]
    ...    ${LanguageDesc}    ${DefaultZone_Config_COREBANKING}    ${DefaultBranch_DB_COREBANKING}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    ...    ${AddZone_ConfigList_COREBANKING}    ${AddBranch_ConfigList_COREBANKING}    ${Role_ConfigList_COREBANKING}
   
Add New LOB for Existing Party Users
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request for LIQ and Essence user. And validate MCH UI for AD, SSO, and corresponding application (LIQ and Essence).
    ...    Then validate success creation in SSO Page. Then validate success creation in LIQ, Essence or Party.
    ...    @author: clanding    22APR2019  - initial create
    ...    @update: dahijara    22JUL2019    - corrected arguments for validation of essence and LIQ page
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
    ${Index_COREBANKING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COREBANKING}
    ${Index_COMRLENDING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COMRLENDING}
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${LanguageDesc}    Get Language Description from Code and Return Description    &{APIDataSet}[locale]
    ${UserType_Desc}    Get User Type Code and Return Description    &{APIDataSet}[userType]
    ${LIQ_JobFunctionList}    Get Job Function Code from Config Setup    &{APIDataSet}[roles]    ${Index_COMRLENDING}
    ${DefaultBranch_Config_COREBANKING}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${DefaultZone_Config_COREBANKING}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${AddBranch_ConfigList_COREBANKING}    Get Additional Branch Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${AddZone_ConfigList_COREBANKING}    Get Additional Zone Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${Role_ConfigList_COREBANKING}    Get Role Configuration and Return Corresponding Value List    &{APIDataSet}[roles]    ${COREBANKING}    ${Index_COREBANKING}
    ${Title_Config_COREBANKING}    Get Job Title Configuration and Return Corresponding Config Value    &{APIDataSet}[jobTitle]    ${COREBANKING}
    ${UserType_Desc_COREBANKING}    Get User Type Code and Return Description    &{APIDataSet}[userType]    ${Index_COREBANKING}
    ${DefaultBranch_DB_COREBANKING}    Create Query for Essence Branch and Return    ${DefaultBranch_Config_COREBANKING}
    
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
    
    Create Prerequisites for COMRLENDING    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Expected_wsLIQUserDestination]    
    ...    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[status]
    ...    &{APIDataSet}[profileId]    &{APIDataSet}[osUserId]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[roles]    ${2Code_CountryCode}    ${Index_COMRLENDING}
    
    Get SSO User Values    &{APIDataSet}[centralRoles]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
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
    
    Run Keyword And Continue On Failure    Validate User in Essence Page for Success    &{APIDataSet}[loginId]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[jobTitle]     &{APIDataSet}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc_COREBANKING}    &{APIDataSet}[locale]
    ...    ${LanguageDesc}    ${DefaultZone_Config_COREBANKING}    ${DefaultBranch_DB_COREBANKING}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    ...    ${AddZone_ConfigList_COREBANKING}    ${AddBranch_ConfigList_COREBANKING}    ${Role_ConfigList_COREBANKING}
    
    Run Keyword And Continue On Failure    Get Line of Business Value and Validate User in LIQ    &{APIDataSet}[roles]    ${2Code_CountryCode}    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[locale]    
    ...    &{APIDataSet}[defaultBusinessEntity]    &{APIDataSet}[jobTitle]    &{APIDataSet}[additionalDepartments]    &{APIDataSet}[primaryDepartment]    
    ...    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[location]    &{APIDataSet}[status]    &{APIDataSet}[profileId]
    ...    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[loginId]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[userLockStatus]
    
Add New LOB for Existing Essence Users
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request for LIQ and Party user. And validate MCH UI for AD, SSO, and corresponding application (LIQ and Party).
    ...    Then validate success creation in SSO Page. Then validate success creation in LIQ and Party.
    ...    @author: clanding    22APR2019    - initial create
    ...    @update: dahijara    25JUL2019    - corrected arguments for validation of party and LIQ page.
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
    ${Index_COMRLENDING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COMRLENDING}
    ${Index_PARTY}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${PARTY}
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${LanguageDesc}    Get Language Description from Code and Return Description    &{APIDataSet}[locale]
    ${UserType_Desc}    Get User Type Code and Return Description    &{APIDataSet}[userType]
    ${UserType_Desc_PARTY}    Get User Type Code and Return Description    &{APIDataSet}[userType]    ${Index_PARTY}
    ${LIQ_JobFunctionList}    Get Job Function Code from Config Setup    &{APIDataSet}[roles]    ${Index_COMRLENDING}
    ${DefaultBranch_Config_COREBANKING}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}
    ${DefaultBranch_Config_PARTY}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${DefaultZone_Config_PARTY}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}
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
    
    Create Prerequisites for COMRLENDING    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Expected_wsLIQUserDestination]    
    ...    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[status]
    ...    &{APIDataSet}[profileId]    &{APIDataSet}[osUserId]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[roles]    ${2Code_CountryCode}    ${Index_COMRLENDING}
    
    Get SSO User Values    &{APIDataSet}[centralRoles]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
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
    
    Run Keyword And Continue On Failure    Get Line of Business Value and Validate User in LIQ    &{APIDataSet}[roles]    ${2Code_CountryCode}    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[locale]    
    ...    &{APIDataSet}[defaultBusinessEntity]    &{APIDataSet}[jobTitle]    &{APIDataSet}[additionalDepartments]    &{APIDataSet}[primaryDepartment]    
    ...    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[location]    &{APIDataSet}[status]    &{APIDataSet}[profileId]
    ...    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[loginId]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[userLockStatus]

