*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Create User for Multiple LOB without Using Optional Fields
    [Documentation]    This keyword is used to create prerequisites for execution.
    ...    And send a POST request to create user for multiple LOB (LIQ, Essence, Party) without using the optional fields.
    ...    And validate that the user is not created in LIQ, Essence, Party.
    ...    @author: dahijara   7AUG2019    - Initial create
    [Arguments]    ${APIDataSet}
    
    ###PRE-REQUISITES###
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{APIDataSet}[countryCode]
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{APIDataSet}[countryCode]
   
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
    
    Run Keyword And Continue On Failure    Validate AD Failed Response in FFC for User API    &{APIDataSet}[lineOfBusiness]    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]
    ...    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[HTTPMethodType]    &{APIDataSet}[loginId]    &{APIDataSet}[osUserId]
    
    Run Keyword And Continue On Failure    Validate User is Not Created in SSO    &{APIDataSet}[loginId]
        
    Run Keyword And Continue On Failure    Create Query for LIQ and Validate User is Not Existing    &{APIDataSet}[loginId]

    Run Keyword And Continue On Failure    Create Query for Essence Global User and Validate User is Not Existing    &{APIDataSet}[loginId]
    
    Run Keyword And Continue On Failure    Create Query for Party User and Validate User is Not Existing    &{APIDataSet}[loginId]
