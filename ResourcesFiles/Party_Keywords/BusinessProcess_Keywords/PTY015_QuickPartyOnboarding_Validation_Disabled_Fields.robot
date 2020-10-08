*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Variables ***

*** Keywords ***
Validate Disabled Fields in Quick Party Onboarding
    [Documentation]    This test case is used to validate disabled fields in Quick Party Onboarding
    ...    @author: javinzon    08OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
   
    Search Process in Party    &{ExcelPath}[Selected_Module]
    
    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    Validate Pre-Existence Check Page Fields if Disabled
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    
    Validate Disabled Fields in Quick Enterprise Party Page    &{ExcelPath}[Country_Region]
    
    Logout User on Party
    