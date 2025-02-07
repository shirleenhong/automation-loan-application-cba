*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Navigate to Quick Party Onboarding and Validate Branch in Party Onboarding Page
    [Documentation]    This test case is used to navigate to Quick Party Onboarding and validate Branches in Branch List Dialog of Party Onboarding Page
    ...    @author: javinzon    13OCT2020    - initial create
    ...    @update: javinzon    20NOV2020    - Added condition for Logout User and Close Browser keywords
      
    [Arguments]    ${ExcelPath}
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
   
    Search Process in Party    &{ExcelPath}[Selected_Module]
    
    Validate Branch in Party Onboarding Page    &{ExcelPath}[UserBranch]    &{ExcelPath}[Branch_Code]    &{ExcelPath}[Branch_Name]    &{ExcelPath}[Bank_Name]    &{ExcelPath}[Country_Code]    &{ExcelPath}[Assigned_Branch_Code]
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser