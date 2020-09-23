*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***




Enquiry Party Details in Party Details Enquiry Module
    [Documentation]    This keyword is used to search Enquiry for Party details module.
    ...    @author: basuppin    21MAY2020    - initial create.
    [Arguments]    ${ExcelPath}    
    ### INPUTTER ###
     Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}     
     Enquire Party Details Search    &{ExcelPath}[Party_ID]    &{ExcelPath}[Assigned_Branch]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]     &{ExcelPath}[Line_Of_Business]  
     Logout User on Party                   
     





     #Search Process in Party    &{ExcelPath}[Selected_Module]
         
     #Navigate Party Details Enquiry    &{ExcelPath}[Party_ID]
     #Enquire Party Details in Party Enquiry Page    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]                                      
     # Enquire Address Details in Party Details Page    &{ExcelPath}[Address_Type]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]        &{ExcelPath}[Party_Address_Country]    &{ExcelPath}[State_Province]    &{ExcelPath}[Town]                         
     # Enquire Business Activity Details in Party Details Page    &{ExcelPath}[Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]     
     
    # Enquire Party Details in Party Enquiry Page    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]                                      

     
     
                   
     
     
     
     
     
     
     
     

     