*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Validate Business Activity Options in Quick Party Onboarding
    [Documentation]    This test case is used to validate available SIC (Business Activity) in Quick Party Onboarding.
    ...    @author:    javinzon    02OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
   
    Search Process in Party    &{ExcelPath}[Selected_Module]
    
    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]   
    
    Validate Available Options in Business Activity Field    &{ExcelPath}[Business_Country]

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser