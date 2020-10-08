*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot


*** Variables ***
${rowid}    1

*** Keywords ***
Create Party in Quick Party Onboarding and Reject Referral
    [Documentation]    This keyword is used to create party via quick party Onboarding screen.
    ...    @author: dahijara    11MAY2020    - initial create.
    ...    @author: bagregado   08OCT2020    - Create Party in Quick Party Onboarding and Reject Referral, updated the target test case name for generating data
    [Arguments]    ${ExcelPath}
    ### INPUTTER ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]

    Search Process in Party    &{ExcelPath}[Selected_Module]

    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    Validate Pre-Existence Check Page Values and Field State    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    ${Short_Name}    Get Short Name Value and Return    &{ExcelPath}[Short_Name_Prefix]    ${Party_ID}
    Write Data To Excel    QuickPartyOnboarding    Party_ID    PTY005_PartyDetailsEnquiryReject    ${Party_ID}    ${PTY_DATASET}        bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Entity    PTY005_PartyDetailsEnquiryReject    ${Entity}    ${PTY_DATASET}        bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Assigned_Branch    PTY005_PartyDetailsEnquiryReject    ${Assigned_Branch}    ${PTY_DATASET}        bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Enterprise_Name    PTY005_PartyDetailsEnquiryReject    ${Enterprise_Name}    ${PTY_DATASET}        bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Short_Name    PTY005_PartyDetailsEnquiryReject    ${Short_Name}    ${PTY_DATASET}        bTestCaseColumn=True

    Populate Quick Enterprise Party    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    ${Short_Name}    
   
    Logout User on Party
 
    ### SUPERVISOR ###
    ${Task_ID_From_Supervisor}    Reject Party via Supervisor Account    ${Party_ID}
    
    ### INPUTTER ###
    Accept Rejected Party and Validate Details in Quick Enterprise Details Screen    ${Task_ID_From_Supervisor}    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Town_City]    
    ...    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    ${Short_Name}    
    ...    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]
