*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Keywords ***

Update User with COMRLENDING LOB without FFC Validation for GET API
    [Documentation]    This keyword is used to update COMRLENDING data for execution.
    ...    This will send a PUT request for LIQ user.
    ...    @author: jloretiz    09SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ###PREREQUISITES###  
    Run Keyword And Continue On Failure    GET Request for User API Single Lob    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputFFCResponse]    
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
      
    ${LOB_Dictionary}    Run Keyword And Continue On Failure    Return GET API FFC Response as Dictionary for LIQ    ${APIDataSet}
    ${CentralRoles}    Return No Tag Value for Empty Variables    &{LOB_Dictionary}[centralRoles]
    ${AddBussEntity}    Return No Tag Value for Empty Variables    &{LOB_Dictionary}[addBussEntity]
    ${AddDepartments}    Return No Tag Value for Empty Variables    &{LOB_Dictionary}[additionalDepartments]
    ${UserType}    Return No Tag Value for Empty Variables    &{LOB_Dictionary}[userType]
    ${CentralUserType}    Return No Tag Value for Empty Variables    &{LOB_Dictionary}[centralUserType]
    ${Index_COMRLENDING}    Get LOB Application from Input and Return Index    &{LOB_Dictionary}[lineOfBusiness]    0
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{LOB_Dictionary}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{LOB_Dictionary}[countryCode]
    ${UserType_Desc}    Get User Type Code and Return Description    ${CentralUserType}
    ${Status}    Return GET API Response Data If APIDataSet is Empty    &{APIDataSet}[status]    &{LOB_Dictionary}[status] 
    ${UserLockStatus}    Return GET API Response Data If APIDataSet is Empty    &{APIDataSet}[userLockStatus]    &{LOB_Dictionary}[userLockStatus]
    
    Update Key Values of Input JSON File for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{LOB_Dictionary}[loginId]    &{LOB_Dictionary}[jobTitle]    &{LOB_Dictionary}[firstName]
    ...    &{LOB_Dictionary}[surname]    &{LOB_Dictionary}[countryCode]    &{LOB_Dictionary}[locale]    &{LOB_Dictionary}[contactNumber1]    &{LOB_Dictionary}[contactNumber2]    &{LOB_Dictionary}[email]
    ...    &{LOB_Dictionary}[osUserId]   &{LOB_Dictionary}[centralUserType]    ${CentralRoles}    &{LOB_Dictionary}[lineOfBusiness]    &{LOB_Dictionary}[defaultBusinessEntityName]|&{LOB_Dictionary}[defaultBranch]
    ...    ${AddBussEntity}    &{LOB_Dictionary}[defaultProcessingArea]    &{LOB_Dictionary}[additionalProcessingArea]    ${AddDepartments}
    ...    &{LOB_Dictionary}[departmentCode]    &{LOB_Dictionary}[location]    &{LOB_Dictionary}[role]    ${Status}    ${UserLockStatus}    ${UserType}
    ...    &{LOB_Dictionary}[profileId]
    
    Update Expected API Response for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    &{LOB_Dictionary}[loginId]    &{LOB_Dictionary}[jobTitle]    &{LOB_Dictionary}[firstName]
    ...    &{LOB_Dictionary}[surname]    &{LOB_Dictionary}[countryCode]    &{LOB_Dictionary}[locale]    &{LOB_Dictionary}[contactNumber1]    &{LOB_Dictionary}[contactNumber2]    &{LOB_Dictionary}[email]
    ...    &{LOB_Dictionary}[osUserId]   &{LOB_Dictionary}[centralUserType]    ${CentralRoles}    &{LOB_Dictionary}[lineOfBusiness]    &{LOB_Dictionary}[defaultBusinessEntityName]|&{LOB_Dictionary}[defaultBranch]
    ...    ${AddBussEntity}    &{LOB_Dictionary}[defaultProcessingArea]    &{LOB_Dictionary}[additionalProcessingArea]    ${AddDepartments}
    ...    &{LOB_Dictionary}[departmentCode]    &{LOB_Dictionary}[location]    &{LOB_Dictionary}[role]    ${Status}    ${UserLockStatus}    ${UserType}
    ...    &{LOB_Dictionary}[profileId]
    
    Create Prerequisites for COMRLENDING    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Expected_wsLIQUserDestination]    
    ...    &{APIDataSet}[HTTPMethodType]    &{LOB_Dictionary}[loginId]    &{LOB_Dictionary}[jobTitle]    &{LOB_Dictionary}[firstName]    &{LOB_Dictionary}[surname]
    ...    &{LOB_Dictionary}[locale]    &{LOB_Dictionary}[contactNumber1]    &{LOB_Dictionary}[contactNumber2]    &{LOB_Dictionary}[email]    &{LOB_Dictionary}[defaultBusinessEntityName]|&{LOB_Dictionary}[defaultBranch]
    ...    &{LOB_Dictionary}[defaultProcessingArea]    &{LOB_Dictionary}[additionalProcessingArea]    &{LOB_Dictionary}[departmentCode]    &{LOB_Dictionary}[location]    ${Status}
    ...    &{LOB_Dictionary}[profileId]    &{LOB_Dictionary}[osUserId]     ${UserLockStatus}    &{LOB_Dictionary}[role]    ${2Code_CountryCode}    0
    ###END OF PREREQUISITES###
    
    Run Keyword And Continue On Failure    PUT Request for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]
    ...    &{LOB_Dictionary}[loginId]

Update User for PARTY or ESSENCE LOB without FFC Validation
    [Documentation]    This keyword is used to update PARTY or ESSENCE data for execution without FFC Validation.
    ...    This will send a PUT request for PARTY or ESSENCE user.
    ...    And then save the API response in a global variable.
    ...    @author: amansuet    17SEP2019    - initial create
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
    ###END OF PRE-REQUISITES###
    
    Run Keyword And Continue On Failure    PUT Request for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]
    ...    &{APIDataSet}[loginId]
    
    Get API Response from File for PUT and POST User API    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[HTTPMethodType]
    
Update User for Loan IQ LOB without FFC Validation
    [Documentation]    This keyword is used to update Loan IQ data for execution without FFC Validation.
    ...    This will send a PUT request for Loan IQ user.
    ...    And then save the API response in a global variable.
    ...    @author: amansuet    17SEP2019    - initial create 
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
    
    ${Index_COMRLENDING}    Get LOB Application from Input and Return Index    &{APIDataSet}[lineOfBusiness]    ${COMRLENDING}
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
    ${UserType_Desc}    Get User Type Code and Return Description    &{APIDataSet}[centralUserType]
    
    Create Prerequisites for COMRLENDING    &{APIDataSet}[InputFilePath]    &{APIDataSet}[Expected_wsFinalLIQDestination]    &{APIDataSet}[Expected_wsLIQUserDestination]    
    ...    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]
    ...    &{APIDataSet}[locale]    &{APIDataSet}[contactNumber1]    &{APIDataSet}[contactNumber2]    &{APIDataSet}[email]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[location]    &{APIDataSet}[status]
    ...    &{APIDataSet}[profileId]    &{APIDataSet}[osUserId]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[roles]    ${2Code_CountryCode}    ${Index_COMRLENDING}
    ###END OF PRE-REQUISITES###
    
    Run Keyword And Continue On Failure    PUT Request for User API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[InputFile_AccessToken_FilePath]    &{APIDataSet}[InputFile_AccessToken]
    ...    &{APIDataSet}[loginId]
    
    Get API Response from File for PUT and POST User API    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[HTTPMethodType]
