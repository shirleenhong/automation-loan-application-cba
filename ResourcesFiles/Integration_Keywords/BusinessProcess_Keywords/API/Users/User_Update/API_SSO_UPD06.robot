*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Update Existing User from Inactive to Active
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a PUT request for existing LIQ user, update status from Inactive to Active. And validate MCH UI for AD, SSO and LIQ.
    ...    Then validate success update in SSO Page. Then validate success update in LIQ.
    ...    @author: xmiranda    28AUG2019    - initial create
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
    
    Run Keyword And Continue On Failure    Get SSO User Values    &{APIDataSet}[centralRoles]    &{APIDataSet}[loginId]    &{APIDataSet}[lineOfBusiness]
    Run Keyword And Continue On Failure    Compare SSO Data from Input Data    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc}    &{APIDataSet}[centralRoles]
    ...    &{APIDataSet}[loginId]    &{APIDataSet}[jobTitle]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[contactNumber1]
    ...    &{APIDataSet}[locale]    &{APIDataSet}[osUserId]    &{APIDataSet}[lineOfBusiness]
    
    Add Current Value to JSON for User Comparison Report for SSO    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    Add Input Value to JSON for User Comparison Report for SSO    &{APIDataSet}[InputFilePath]    ${2code_countrycode}    &{APIDataSet}[loginId]    &{APIDataSet}[centralUserType]
    ...    &{APIDataSet}[locale]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[jobTitle]    &{APIDataSet}[email]    &{APIDataSet}[contactNumber1]
    ...    &{APIDataSet}[osUserId]
    Compare Input and Actual SSO Data    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    Get LoanIQ Data Before Any Transaction    &{APIDataSet}[profileId]
    Add Current Value to JSON for User Comparison Report for LIQ    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
    Compare Input Data with LoanIQ Details    &{APIDataSet}[InputFilePath]    ${2Code_CountryCode}    &{APIDataSet}[roles]    &{APIDataSet}[locale]    &{APIDataSet}[defaultBusinessEntity]
    ...    &{APIDataSet}[jobTitle]    &{APIDataSet}[additionalDepartments]    &{APIDataSet}[primaryDepartment]    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[defaultProcessingArea]
    ...    &{APIDataSet}[location]    &{APIDataSet}[profileId]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[contactNumber1]
    ...    &{APIDataSet}[status]    &{APIDataSet}[loginId]    &{APIDataSet}[userLockStatus]    ${Index_COMRLENDING}
    Compare Input and Actual LIQ Data    &{APIDataSet}[InputFilePath]    &{APIDataSet}[OutputFilePath]
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
    
    Run Keyword And Continue On Failure    Validate LoanIQ for Users for Put    &{APIDataSet}[roles]    ${2Code_CountryCode}    &{APIDataSet}[locale]
    ...    &{APIDataSet}[defaultBusinessEntity]    &{APIDataSet}[jobTitle]    &{APIDataSet}[additionalDepartments]    &{APIDataSet}[primaryDepartment]
    ...    &{APIDataSet}[additionalProcessingArea]    &{APIDataSet}[defaultProcessingArea]    &{APIDataSet}[location]    &{APIDataSet}[profileId]    &{APIDataSet}[status]
    ...    &{APIDataSet}[contactNumber1]    &{APIDataSet}[userLockStatus]    &{APIDataSet}[firstName]    &{APIDataSet}[surname]    &{APIDataSet}[email]    &{APIDataSet}[loginId]
    ...    ${INDEX_COMRLENDING}