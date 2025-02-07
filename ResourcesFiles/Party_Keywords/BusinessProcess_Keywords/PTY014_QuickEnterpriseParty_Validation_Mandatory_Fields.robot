*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Navigate to Quick Party Onboarding and Validate Mandatory Fields in Quick Enterprise Party Page
    [Documentation]    This test case is used to validate mandatory fields in Quick Enterprise Party Page
    ...    @author: javinzon    14OCT2020    - initial create
    ...    @update: javinzon    20NOV2020    - Added condition for Logout User and Close Browser keywords
    [Arguments]    ${ExcelPath}
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
   
    Search Process in Party    &{ExcelPath}[Selected_Module]
    
    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    
    Validate Mandatory Fields in Quick Enterprise Party Page    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[GST_Number]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]   
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    