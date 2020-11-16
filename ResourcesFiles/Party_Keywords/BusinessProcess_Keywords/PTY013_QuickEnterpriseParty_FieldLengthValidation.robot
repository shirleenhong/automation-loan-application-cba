*** Settings ***    
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Validate Length of Fields in Quick Enterprise Party
    [Documentation]    This test case is used to populate and validate field length of the following fields in Quick Enterprise Party:
    ...    Enterprise Name, Post Code, Address Line 1, Address Line 2, Address Line 3, Address Line 4, Address City, Short Name.
    ...    @author:    javinzon    06NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
   
    Search Process in Party    &{ExcelPath}[Selected_Module]
    
    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]   

    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Name]
  
	Populate Quick Enterprise Party    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    
    ...    &{ExcelPath}[Document_Collection_Status]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]
    ...    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    
    ...    &{ExcelPath}[Short_Name]    ${FIELDLENGTH_ENTERPRISENAME_ERROR_MESSAGE}
    Mx Click Element    ${Party_Footer_Previous_Button}
 
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    
    Populate and Validate Length of Fields in Quick Enterprise Party    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    
    ...    &{ExcelPath}[Invalid_Post_Code]    &{ExcelPath}[Document_Collection_Status]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]
    ...    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    &{ExcelPath}[Invalid_Address_Line_1]    &{ExcelPath}[Invalid_Address_Line_2]    &{ExcelPath}[Invalid_Address_Line_3]    &{ExcelPath}[Invalid_Address_Line_4]    &{ExcelPath}[Town_City]    
    ...    &{ExcelPath}[Invalid_Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    
    ...    &{ExcelPath}[Short_Name]    ${FIELDLENGTH_POSTCODE_ERROR_MESSAGE}    ${FIELDLENGTH_ADDRESSLINE_ERROR_MESSAGE}    ${FIELDLENGTH_ADDRESSCITY_ERROR_MESSAGE}
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser