*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***

Enquiry Party Details in Party Details Enquiry Module
    [Documentation]    This keyword is used to search Enquiry for Party details module.
    ...    @author: basuppin    21MAY2020    - initial create.
    ...    @author: gagregado   28SEPT2020   - created validation for Enquire Enterprise, BUsiness activity page and Search.
    [Arguments]    ${ExcelPath}    
     Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}     
     Navigate Party Details Enquiry    &{ExcelPath}[Party_ID]
     Validate Enquire Enterprise Party   &{ExcelPath}[Party_ID]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Enterprise_Prefix]     &{ExcelPath}[Assigned_Branch]     &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]     &{ExcelPath}[Beneficial_Owners]    &{ExcelPath}[Principal_Directors]    &{ExcelPath}[Signatories]    &{ExcelPath}[Parent]    &{ExcelPath}[Num_Employees]    &{ExcelPath}[Manager_ID]    &{ExcelPath}[Registered_Number]     &{ExcelPath}[Short_Name]    &{ExcelPath}[Tax_ID_GST_Number]            
     Validate Enterprise Business Activity Page    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]                                             
     Enquire Party Details Search    &{ExcelPath}[Party_ID]    &{ExcelPath}[Assigned_Branch]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]     &{ExcelPath}[Line_Of_Business]    &{ExcelPath}[Alternate_Party_ID]    &{ExcelPath}[Party_Name]    &{ExcelPath}[Date_Formed]    &{ExcelPath}[National_ID]    &{ExcelPath}[Tax_ID_GST_Number]    
     Logout User on Party                   


     
                   
     
     
     
     
     
     
     
     

     