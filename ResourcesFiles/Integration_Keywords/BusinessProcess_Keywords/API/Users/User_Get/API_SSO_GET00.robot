*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Keywords ***
GET API Validation
    [Documentation]    This keyword is used to validate data depending on LOB.
    ...    And GET API expected response for FFC.
    ...    @author: jloretiz    26AUG2019    - initial create
    ...    @update: cfrancis    17SEP2019    - changed from $ to & in reference to values of dictionary with index
    [Arguments]    ${APIDataSet}
    
    Run Keyword If    '&{APIDataSet}[lineOfBusiness]'=='${PARTY}'    GET API Validation for PARTY    ${APIDataSet}
    ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='${COREBANKING}'    GET API Validation for ESSENCE    ${APIDataSet}
    ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='${COMRLENDING}'    GET API Validation for LOANIQ    ${APIDataSet}

GET API Validation for DELETE
    [Documentation]    This keyword is used to validate deleted data depending on LOB.
    ...    @author: jloretiz    10SEP2019    - initial create
    ...    @update: cfrancis    17SEP2019    - changed from $ to & in reference to values of dictionary with index
    [Arguments]    ${APIDataSet}
    
    Run Keyword If    '&{APIDataSet}[lineOfBusiness]'=='${PARTY}'    GET API Delete Validation for PARTY    ${APIDataSet}
    ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='${COREBANKING}'    GET API Delete Validation for ESSENCE    ${APIDataSet}
    ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='${COMRLENDING}'    GET API Delete Validation for LOANIQ    ${APIDataSet}

GET API Validation for Users in Get All User API
    [Documentation]    This keyword is used to validate users found in Get All User API depending on LOB.
    ...    And GET API expected response for FFC.
    ...    @author: amansuet    06SEP2019    - initial create
    ...    @update: cfrancis    16SEP2019    - changed from $ to & in reference to values of dictionary with index
    [Arguments]    ${APIDataSet}
    
    Run Keyword If    '&{APIDataSet}[lineOfBusiness]'=='${PARTY}'    Validate User is Existing for Party in GET All User Success    &{APIDataSet}[loginId]
    ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='${COREBANKING}'    Validate User is Existing for Essence in GET All User Success    &{APIDataSet}[loginId]
    ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='${COMRLENDING}'    Validate User is Existing for LIQ in GET All User Success    &{APIDataSet}[profileId]

GET API Delete Validation for LOANIQ
    [Documentation]    This keyword is used to validate deleted user for LOANIQ LOB.
    ...    @author: jloretiz    10SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Validate Loan IQ for Users with INACTIVE Status    &{APIDataSet}[loginId]  

GET API Delete Validation for PARTY
    [Documentation]    This keyword is used to validate deleted user for PARTY LOB.
    ...    @author: jloretiz    10SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Validate Party for Delete Success    &{APIDataSet}[loginId]   
  
GET API Delete Validation for ESSENCE
    [Documentation]    This keyword is used to validate deleted user for ESSENCE LOB.
    ...    @author: jloretiz    10SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Run Keyword And Continue On Failure    Validate Essence for Delete Success    &{APIDataSet}[loginId]
      
GET API Validation for LOANIQ
    [Documentation]    This keyword is used to validate user details for LOANIQ LOB.
    ...    And GET API expected response for FFC.
    ...    @author: jloretiz    26AUG2019    - initial create
    ...    @update: amansuet    09SEP2019    - replaced APIDataSet input with LIQ Dictionary for defaultBranch
    [Arguments]    ${APIDataSet}
    
    ${LIQ_Dictionary}    Return GET API FFC Response as Dictionary for LIQ    ${APIDataSet}
    Run Keyword And Continue On Failure    Get Line of Business Value and Validate User in LIQ    &{LIQ_Dictionary}[role]    &{LIQ_Dictionary}[countryCode]    
    ...    &{LIQ_Dictionary}[lineOfBusiness]    &{LIQ_Dictionary}[locale]    &{LIQ_Dictionary}[defaultBranch]    &{LIQ_Dictionary}[jobTitle]    
    ...    &{LIQ_Dictionary}[departmentCode]    &{LIQ_Dictionary}[departmentCode]    &{LIQ_Dictionary}[additionalProcessingArea]    
    ...    &{LIQ_Dictionary}[defaultProcessingArea]    &{LIQ_Dictionary}[location]   &{LIQ_Dictionary}[status]   &{LIQ_Dictionary}[profileId]
    ...    &{LIQ_Dictionary}[firstName]    &{LIQ_Dictionary}[surname]    &{LIQ_Dictionary}[email]    &{LIQ_Dictionary}[loginId]    
    ...    &{LIQ_Dictionary}[contactNumber1]    &{LIQ_Dictionary}[userLockStatus]

GET API Validation for PARTY
    [Documentation]    This keyword is used to validate user details for PARTY LOB.
    ...    And GET API expected response for FFC.
    ...    @author: jloretiz    26AUG2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ${PAR_Dictionary}    Return GET API FFC Response as Dictionary ESSENCE or PARTY    ${APIDataSet}
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{PAR_Dictionary}[countryCode]
    ${LanguageDesc}    Get Language Description from Code and Return Description   &{PAR_Dictionary}[locale]
    ${DefaultBranch_DB}    Create Query for Party Branch and Return    &{PAR_Dictionary}[defaultBranch]
    ${Locale}    Convert To Lowercase    &{PAR_Dictionary}[locale] 
    ${Role}    Create List    &{PAR_Dictionary}[role] 
    ${UserType_Desc}    Get User Type Code and Return Description    &{PAR_Dictionary}[userType]
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{PAR_Dictionary}[countryCode]
    Run Keyword And Continue On Failure    Validate User Details in Party for Success    &{PAR_Dictionary}[loginId]    ${UserType_Desc}   
    ...    ${2Code_CountryCode}    &{PAR_Dictionary}[firstName]    &{PAR_Dictionary}[surname]    &{PAR_Dictionary}[jobTitle]    &{PAR_Dictionary}[osUserId]    
    ...    ${CountryDesc}    ${LanguageDesc}    ${Locale}    &{PAR_Dictionary}[businessEntityName]    ${DefaultBranch_DB}    &{PAR_Dictionary}[contactNumber1]   
    ...    &{PAR_Dictionary}[email]    &{PAR_Dictionary}[addZone]     &{PAR_Dictionary}[addBranch]       ${Role}

GET API Validation for ESSENCE
    [Documentation]    This keyword is used to validate user details for ESSENCE LOB.
    ...    And GET API expected response for FFC.
    ...    @author: jloretiz    26AUG2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ${ESS_Dictionary}    Return GET API FFC Response as Dictionary ESSENCE or PARTY    ${APIDataSet}
    ${CountryDesc}    Get Country Desc from the input 2-code country    &{ESS_Dictionary}[countryCode]
    ${LanguageDesc}    Get Language Description from Code and Return Description   &{ESS_Dictionary}[locale]
    ${DefaultBranch_DB}    Create Query for Essence Branch and Return    &{ESS_Dictionary}[defaultBranch]
    ${Locale}    Convert To Lowercase    &{ESS_Dictionary}[locale] 
    ${Role}    Create List    &{ESS_Dictionary}[role] 
    ${UserType_Desc}    Get User Type Code and Return Description    &{ESS_Dictionary}[userType]    0
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    &{ESS_Dictionary}[countryCode]
    Run Keyword And Continue On Failure    Validate User in Essence Page for Success     &{ESS_Dictionary}[loginId]    &{ESS_Dictionary}[firstName]    &{ESS_Dictionary}[surname]
    ...    &{ESS_Dictionary}[jobTitle]    &{ESS_Dictionary}[osUserId]    ${2Code_CountryCode}    ${CountryDesc}    ${UserType_Desc}    ${Locale}
    ...    ${LanguageDesc}     &{ESS_Dictionary}[businessEntityName]    ${DefaultBranch_DB}    &{ESS_Dictionary}[contactNumber1]    &{ESS_Dictionary}[email]
    ...    &{ESS_Dictionary}[addZone]     &{ESS_Dictionary}[addBranch]     ${Role}
