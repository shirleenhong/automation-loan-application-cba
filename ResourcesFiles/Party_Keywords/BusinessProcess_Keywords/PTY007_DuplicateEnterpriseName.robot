*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Variables ***

*** Keywords ***
Check and Reject a Duplicate Enterprise Name 
    [Documentation]    This test case is used to check and reject a Duplicate Enterprise Name
    ...    @author:    javinzon    28SEP2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
   
    Search Process in Party    &{ExcelPath}[Selected_Module]
    
    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    Populate Pre-Existence Check and Validate the Duplicate Enterprise Name    &{ExcelPath}[Enterprise_Name]
    
    