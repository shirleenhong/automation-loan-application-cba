*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Create Party in Quick Party Onboarding and Validate Duplicate Enterprise Name Across Entities
    [Documentation]    This test case is used to Create Party in Quick Party Onboarding and Validate Duplicate Enterprise Name Across Entities
    ...    @author: javinzon    27OCT2020    - initial create
    [Arguments]    ${ExcelPath}
  
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
   
    Search Process in Party    &{ExcelPath}[Selected_Module]
    
    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    Populate Pre-Existence Check and Validate Duplicate Enterprise Name Across Entities    &{ExcelPath}[Enterprise_Name]    &{ExcelPath}[Party_ID]    &{ExcelPath}[SwitchTo_UserZone]    &{ExcelPath}[SwitchTo_UserBranch]    &{ExcelPath}[Expected_Entity]
    