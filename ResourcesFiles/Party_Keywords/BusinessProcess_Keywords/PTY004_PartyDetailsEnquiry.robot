*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***

Enquiry Party Details in Party Details Enquiry Module
    [Documentation]    This keyword is used to search Enquiry for Party details module.
    ...    @author: basuppin    21MAY2020    - initial create.
    ...    @author: gagregado   28SEPT2020   - created validation for Enquire Enterprise, BUsiness activity page and Search.
    [Arguments]    ${ExcelPath}    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}     
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    Navigate Party Details Enquiry    &{ExcelPath}[Party_ID]
    Validate Enquire Enterprise Party   &{ExcelPath}[Party_ID]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Enterprise_Prefix]     &{ExcelPath}[Assigned_Branch]     &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]     &{ExcelPath}[Beneficial_Owners]    &{ExcelPath}[Principal_Directors]    &{ExcelPath}[Signatories]    &{ExcelPath}[Parent]    &{ExcelPath}[Num_Employees]    &{ExcelPath}[Manager_ID]    &{ExcelPath}[Registered_Number]     &{ExcelPath}[Short_Name]    &{ExcelPath}[Tax_ID_GST_Number]            
    Validate Enterprise Business Activity Page    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]                                             
    Enquire Party Details Search    &{ExcelPath}[Party_ID]    &{ExcelPath}[Assigned_Branch]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]     &{ExcelPath}[Line_Of_Business]    &{ExcelPath}[Alternate_Party_ID]    &{ExcelPath}[Party_Name]    &{ExcelPath}[Date_Formed]    &{ExcelPath}[National_ID]    &{ExcelPath}[Tax_ID_GST_Number]    
    Logout User on Party                   


     
                   
     
Create Party in Quick Party Onboarding for Party Details Enquiry Search
    [Documentation]    This keyword is used to create party via quick party Onboarding screen for use in Party Details Enquiry Search
    ...    @author: gbagregado    02OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### INPUTTER ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]

    Search Process in Party    &{ExcelPath}[Selected_Module]

    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    Validate Pre-Existence Check Page Values and Field State    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    ${Short_Name}    Get Short Name Value and Return    &{ExcelPath}[Short_Name_Prefix]    ${Party_ID}
    Write Data To Excel    QuickPartyOnboarding    Party_ID    PTY004_PartyDetailsEnquirySearch    ${Party_ID}    ${PTY_DATASET}        bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Entity    PTY004_PartyDetailsEnquirySearch    ${Entity}    ${PTY_DATASET}        bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Assigned_Branch    PTY004_PartyDetailsEnquirySearch    ${Assigned_Branch}    ${PTY_DATASET}        bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Enterprise_Name    PTY004_PartyDetailsEnquirySearch    ${Enterprise_Name}    ${PTY_DATASET}        bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Short_Name    PTY004_PartyDetailsEnquirySearch    ${Short_Name}    ${PTY_DATASET}        bTestCaseColumn=True

    Populate Quick Enterprise Party    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    ${Short_Name}    
   

    Logout User on Party
    
    ### SUPERVISOR ###
    ${Task_ID_From_Supervisor}    Approve Party via Supervisor Account    ${Party_ID}    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    
    ### INPUTTER ###
    Accept Approved Party and Validate Details in Enterprise Summary Details Screen    ${Task_ID_From_Supervisor}    ${Party_ID}    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]
    ...    &{ExcelPath}[Party_Category]    ${Enterprise_Name}    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    ${Short_Name}    
    ...    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[GST_Number]
    ...    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]       
     
     
     
     
     
     

     