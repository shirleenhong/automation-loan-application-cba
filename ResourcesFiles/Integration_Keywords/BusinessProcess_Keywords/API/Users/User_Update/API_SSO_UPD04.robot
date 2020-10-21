*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Keywords ***

Update Existing User for Multiple LOBs
    [Documentation]    This keyword is used to update user with mutliple LOBs.
    ...    @author: clanding
    ...    @update: clanding    23APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: dahijara    19AUG2019    - added needed keywords to validate updates for a multiple LOB
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
    
    ${Index_COREBANKING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COREBANKING}
    ${Index_COMRLENDING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COMRLENDING}
    ${Index_PARTY}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${PARTY}
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${LanguageDesc}    Get Language Description from Code and Return Description    &{APIDataSet}[locale]
    ${UserType_Desc_COREBANKING}    Get User Type Code and Return Description    &{APIDataSet}[userType]    ${Index_COREBANKING}
    ${ProfileID_COMRLENDING}    Get ProfileID and Return Corresponding Value from Excel    &{APIDataSet}[profileId]    ${Index_COMRLENDING}
    ${UserType_Desc_PARTY}    Get User Type Code and Return Description    &{APIDataSet}[userType]    ${Index_PARTY}
    ${LIQ_JobFunctionList}    Get Job Function Code from Config Setup    &{APIDataSet}[roles]    ${Index_COMRLENDING}
    ${DefaultBranch_Config_COREBANKING}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${DefaultZone_Config_COREBANKING}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${AddBranch_ConfigList_COREBANKING}    Get Additional Branch Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${AddZone_ConfigList_COREBANKING}    Get Additional Zone Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${COREBANKING}    ${Index_COREBANKING}
    ${Role_ConfigList_COREBANKING}    Get Role Configuration and Return Corresponding Value List    &{APIDataSet}[roles]    ${COREBANKING}    ${Index_COREBANKING}
    ${DefaultBranch_Config_PARTY}    Get Default Branch Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${DefaultZone_Config_PARTY}    Get Default Zone Configuration and Return Corresponding Value    &{APIDataSet}[defaultBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${AddBranch_ConfigList_PARTY}    Get Additional Branch Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${AddZone_ConfigList_PARTY}    Get Additional Zone Configuration and Return Corresponding Value List    &{APIDataSet}[additionalBusinessEntity]    |    ${PARTY}    ${Index_PARTY}
    ${Role_ConfigList_PARTY}    Get Role Configuration and Return Corresponding Value List    &{APIDataSet}[roles]    ${PARTY}    ${Index_PARTY}
    
    ${DefaultBranch_DB_COREBANKING}    Create Query for Essence Branch and Return    ${DefaultBranch_Config_COREBANKING}
    ${DefaultBranch_DB_PARTY}    Create Query for Party Branch and Return    ${DefaultBranch_Config_PARTY}
    
    Create Prerequisites for COMRLENDING    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Expected_wsLIQUserDestination]    
    ...    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[status]
    ...    &{APIDataSet}[profileId]    &{APIDataSet}[osUserId]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[roles]    ${2Code_CountryCode}    ${Index_COMRLENDING}
    
    Run Keyword And Continue On Failure    Get SSO User Values    &{APIDataSet}[centralRoles]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    Run Keyword And Continue On Failure    Compare SSO Data from Input Data    ${2Code_CountryCode}    ${CountryDesc}    &{APIDataSet}[centralUserType]    &{APIDataSet}[centralRoles]
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[contactNumber1]
    ...    &{APIDataSet}[locale]    &{APIDataSet}[osUserId]    &{APIDataSet}[lineOfBusiness]
    
    Add Current Value to JSON for User Comparison Report for SSO    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    Add Input Value to JSON for User Comparison Report for SSO    &{APIDataSet}[InputFilePath]    ${2code_countrycode}    &{APIDataSet}[loginId]    &{APIDataSet}[centralUserType]
    ...    &{APIDataSet}[locale]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]    &{APIDataSet}[email]    &{APIDataSet}[contactNumber1]
    ...    &{APIDataSet}[osUserId]
    Compare Input and Actual SSO Data    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    
    #LIQ Validation
    Get LoanIQ Data Before Any Transaction    ${ProfileID_COMRLENDING}
    Add Current Value to JSON for User Comparison Report for LIQ    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    Compare Input Data with LoanIQ Details    &{APIDataSet}[InputFilePath]    ${2Code_CountryCode}    &{APIDataSet}[roles]    &{APIDataSet}[locale]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[jobTitle]    &{APIDataSet}[additionalDepartments]    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[defaultProcessingArea]
    ...    &{APIDataSet}[location]    &{APIDataSet}[profileId]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[contactNumber1]
    ...    &{APIDataSet}[status]    &{APIDataSet}[loginId]    &{APIDataSet}[userLockStatus]    ${Index_COMRLENDING}
    Compare Input and Actual LIQ Data    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]    
    
    #ESSENCE VALIDATION
    Get Essence User Values    &{APIDataSet}[loginId]
    Compare Essence Data from Input Data    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]    &{APIDataSet}[osUserId]    ${2Code_CountryCode}
    ...    ${CountryDesc}    ${UserType_Desc_COREBANKING}    &{APIDataSet}[locale]    ${LanguageDesc}    ${DefaultZone_Config_COREBANKING}    ${DefaultBranch_DB_COREBANKING}
    ...    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    Add Current Value to JSON for User Comparison Report for Essence    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    Add Input Value to JSON for User Comparison Report for Essence    &{APIDataSet}[InputFilePath]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]
    ...    &{APIDataSet}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc_COREBANKING}    &{APIDataSet}[locale]    ${LanguageDesc}    ${DefaultZone_Config_COREBANKING}
    ...    ${DefaultBranch_DB_COREBANKING}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    Compare Input and Actual Essence Data    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]    
    
    #PARTY VALIDATION
    Get Party User Values    &{APIDataSet}[loginId]
    Compare Party Data from Input Data    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]    &{APIDataSet}[osUserId]    ${2Code_CountryCode}
    ...    ${CountryDesc}    ${UserType_Desc_PARTY}    &{APIDataSet}[locale]    ${LanguageDesc}    ${DefaultZone_Config_PARTY}    ${DefaultBranch_DB_PARTY}
    ...    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]    ${Role_ConfigList_PARTY}
    Add Current Value to JSON for User Comparison Report for Party    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    Add Input Value to JSON for User Comparison Report for Party    &{APIDataSet}[InputFilePath]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]
    ...    &{APIDataSet}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc_PARTY}    &{APIDataSet}[locale]    ${LanguageDesc}    ${DefaultZone_Config_PARTY}
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
    
    Run Keyword And Continue On Failure    Validate Update User in Essence Page    &{APIDataSet}[loginId]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[jobTitle]    &{APIDataSet}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc_COREBANKING}    &{APIDataSet}[locale]
    ...    ${LanguageDesc}    ${DefaultZone_Config_COREBANKING}    ${DefaultBranch_DB_COREBANKING}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    ...    ${AddZone_ConfigList_COREBANKING}    ${AddBranch_ConfigList_COREBANKING}    ${Role_ConfigList_COREBANKING}

    Run Keyword And Continue On Failure    Validate Update User in Party Page    &{APIDataSet}[loginId]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[jobTitle]    &{APIDataSet}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc_PARTY}    &{APIDataSet}[locale]
    ...    ${LanguageDesc}    ${DefaultZone_Config_PARTY}    ${DefaultBranch_DB_PARTY}    &{APIDataSet}[contactNumber1]    &{APIDataSet}[email]
    ...    ${AddZone_ConfigList_PARTY}    ${AddBranch_ConfigList_PARTY}    ${Role_ConfigList_PARTY}

    Run Keyword And Continue On Failure    Validate LoanIQ for Users for Put    &{APIDataSet}[roles]    ${2Code_CountryCode}    &{APIDataSet}[locale]
    ...    &{APIDataSet}[defaultBusinessEntity]    &{APIDataSet}[jobTitle]    &{APIDataSet}[additionalDepartments]    &{APIDataSet}[primaryDepartment]
    ...    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[location]    ${ProfileID_COMRLENDING}    &{APIDataSet}[status]
    ...    &{APIDataSet}[contactNumber1]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[loginId]
    ...    ${INDEX_COMRLENDING}    
    
