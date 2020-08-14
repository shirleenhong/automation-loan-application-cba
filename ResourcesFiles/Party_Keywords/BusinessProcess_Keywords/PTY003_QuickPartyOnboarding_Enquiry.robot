*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Enquiry Party Details in Party Details Enquiry Module
    [Documentation]    This keyword is used to Enquiry for Party details module.
    ...    @author: basuppin    21MAY2020    - initial create.
    [Arguments]    ${ExcelPath}    
    ### INPUTTER ###
     Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}     
     Search Process in Party    &{ExcelPath}[Selected_Module]
     # Enquire Party ID in Party Details Page   &{ExcelPath}[Party_ID]    
     # Enquire Party Details in Party Enquiry Page    &{ExcelPath}[Locality]    &{ExcelPath}[Entity]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Enterprise_Name]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Goods_and_Service_Tax_Nunmber]        &{ExcelPath}[Assigned_Branch]    &{ExcelPath}[Party_Type]        &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Short_Name]                                                
     # Enquire Address Details in Party Details Page    &{ExcelPath}[Address_Type]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]        &{ExcelPath}[Party_Address_Country]    &{ExcelPath}[State_Province]    &{ExcelPath}[Town]                         
     # Enquire Business Activity Details in Party Details Page    &{ExcelPath}[Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]     
     Logout User on Party                   
     
     
                   
     
     
     
     
     
     
     
     

     