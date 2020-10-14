*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Variables ***

*** Keywords ***
Navigate to Quick Party Onboarding and Validate Branch in Party Onboarding Page
    [Documentation]    This test case is used to navigate to Quick Party Onboarding and validate Branches in Branch List Dialog of Party Onboarding Page
    ...    @author: javinzon    13OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
   
    Search Process in Party    &{ExcelPath}[Selected_Module]
    
    Validate Branch in Party Onboarding Page    &{ExcelPath}[UserBranch]    &{ExcelPath}[Branch_Code]
    
    Logout User on Party