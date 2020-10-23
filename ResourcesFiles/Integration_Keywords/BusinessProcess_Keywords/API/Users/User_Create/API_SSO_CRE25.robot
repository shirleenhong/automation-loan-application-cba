*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Create User for Essence with Valid and Maximum Field Length
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request for Essence. Validates MCH UI for AD, SSO and Essence.
    ...    Then validate success creation in SSO Page and success creation in Essence.
    ...    @author: jloretizo    30JUL2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
    ${Index_COREBANKING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COREBANKING}
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${DefaultBranch_Config}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}
    ${DefaultZone_Config}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}
    ${AddBranch_ConfigList}    Get Additional Branch Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${AddZone_ConfigList}    Get Additional Zone Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${LanguageDesc}    Get Language Description from Code and Return Description    &{APIDataSet}[locale]
    ${Role_ConfigList}    Get Role Configuration and Return Corresponding Value List    &{APIDataSet}[roles]    ${COREBANKING}    ${Index_COREBANKING}
    ${UserType_Desc}    Get User Type Code and Return Description    &{APIDataSet}[userType]
    ${DefaultBranch_DB_COREBANKING}    Create Query for Essence Branch and Return    ${DefaultBranch_Config}
    
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

    Run Keyword And Continue On Failure    Validate User in Essence Page for Success    &{APIDataSet}[loginId]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[jobTitle]    &{APIDataSet}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc}    &{APIDataSet}[locale]
    ...    ${LanguageDesc}    ${DefaultZone_Config}    ${DefaultBranch_DB_COREBANKING}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    ...    ${AddZone_ConfigList}    ${AddBranch_ConfigList}    ${Role_ConfigList}

Create User for Party with Valid and Maximum Field Length
        [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request for Essence. Validates MCH UI for AD, SSO and Party.
    ...    Then validate success creation in SSO Page and success creation in Party.
    ...    @author: jloretizo    30JUL2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
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

    Run Keyword And Continue On Failure    Validate User Details in Party for Success    &{APIDataSet}[loginId]    ${UserType_Desc}    ${2Code_CountryCode}
    ...    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]    &{APIDataSet}[osUserId]    ${CountryDesc}    ${LanguageDesc}    &{APIDataSet}[locale]
    ...    ${DefaultZone_Config}    ${DefaultBranch_DB_PARTY}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    ...    ${AddZone_ConfigList}    ${AddBranch_ConfigList}    ${Role_ConfigList}

Create User for LIQ with Valid and Maximum Field Length
        [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request for Essence. Validates MCH UI for AD, SSO and LIQ.
    ...    Then validate success creation in SSO Page and success creation in LIQ.
    ...    @author: jloretizo    30JUL2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${Index_COMRLENDING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COMRLENDING}
    
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

    Run Keyword And Continue On Failure    Get Line of Business Value and Validate User in LIQ    &{APIDataSet}[roles]    ${2Code_CountryCode}    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[locale]    
    ...    &{APIDataSet}[defaultBusinessEntity]    &{APIDataSet}[jobTitle]    &{APIDataSet}[additionalDepartments]    &{APIDataSet}[primaryDepartment]    
    ...    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[location]    &{APIDataSet}[status]    &{APIDataSet}[profileId]
    ...    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[loginId]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[userLockStatus]
