*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Validate Party Details in Maintain Party Details Module
    [Documentation]    This keyword is used to Navigate to Maintain Party Details Module and validate existing details.
    ...    @author: javinzon    24SEP2020    - initial create.
    [Arguments]    ${ExcelPath}    
    
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Navigate Maintain Party Details    &{ExcelPath}[Party_ID]
    
    Validate Enterprise Party Summary in Maintain Party Details    &{ExcelPath}[Locality]    &{ExcelPath}[Entity]    &{ExcelPath}[Assigned_Branch]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    
    ...    &{ExcelPath}[Party_Category]  &{ExcelPath}[Party_ID]    &{ExcelPath}[Enterprise_Name]    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]   
    ...    &{ExcelPath}[Short_Name]    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]
    ...    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[GST_Number]

Update Party Details in Maintain Party Details Module
    [Documentation]    This keyword is used to update Party/Customer via Maintain Party Details Module and validate in Loan IQ.
    ...    @author: dahijara    27APR2020    - initial create.
    ...    @update: javinzon    03NOV2020    - updated documentation and scripts
    [Arguments]    ${ExcelPath}
    
    ### INPUTTER ###
    ${New_Enterprise_Name}    ${Short_Name}    Update Party Details in Enterprise Party Page    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Enterprise_Prefix]    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Short_Name_Prefix]    
    ...    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    
    ...    &{ExcelPath}[GST_Number]
    
    Write Data To Excel    QuickPartyOnboarding    Enterprise_Name     ${TestCase_Name}    ${New_Enterprise_Name}    ${PTY_DATASET}    bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Short_Name    ${TestCase_Name}    ${Short_Name}    ${PTY_DATASET}    bTestCaseColumn=True   
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    ### SUPERVISOR ###
    ${TaskID_ForPartyDetails}    Approve Updated Party via Supervisor Account    &{ExcelPath}[Party_ID]    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    ${TaskID_ForAddress}    ${TaskID_ForPartyDetails}    Approve Updated Party via Supervisor Account    &{ExcelPath}[Party_ID]    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    
    ### INPUTTER ###
    Accept Approved Updated Party    ${TaskID_ForPartyDetails}    ${TaskID_ForAddress}    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]  
    
    ${Enterprise_Name}    Read Data From Excel    QuickPartyOnboarding    Enterprise_Name    ${TestCase_Name}    ${PTY_DATASET}    sTestCaseColReference=Test_Case 
    ${Short_Name}    Read Data From Excel    QuickPartyOnboarding    Short_Name    ${TestCase_Name}    ${PTY_DATASET}    sTestCaseColReference=Test_Case
    
    Validate Enquire Enterprise Party After Amendment    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Locality]    
    ...    &{ExcelPath}[Entity]    &{ExcelPath}[Assigned_Branch]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Party_ID]    ${Enterprise_Name}    &{ExcelPath}[Registered_Number]   
    ...    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    ${Short_Name}    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]
    ...    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Country_Region]    &{ExcelPath}[GST_Number]
    
    ${Entity_Name}    Get Substring    &{ExcelPath}[Entity]    0    2
    
    Validate Party Details in Loan IQ    &{ExcelPath}[Party_ID]    ${Short_Name}    ${Enterprise_Name}    &{ExcelPath}[GST_Number]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Business_Country]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    ${Entity_Name}
    