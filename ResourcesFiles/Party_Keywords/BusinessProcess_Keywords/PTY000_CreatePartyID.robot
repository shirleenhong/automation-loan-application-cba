*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Create Party ID Successfully in Quick Party Onboarding
    [Documentation]    This keyword is used to create party successfully via quick party Onboarding screen.
    ...    @author: javinzon    22OCT2020    - initial create
    ...    @update: javinzon    26OCT2020    - Added Write Data To Excel for PTY010_DuplicateShortName_AcrossEntities
    ...    @update: javinzon    27OCT2020    - Added condition for writing data to excel, Added Write Data To Excel keyword 
    ...                                        for PTY008_DuplicateEnterpriseName_AcrossEntities, Added ELSE condition to Close Browser
    ...	   @update: javinzon	29OCT2020	 - Added Write Data To Excel keyword of PartyID for PTY020_PartyCrossReferenceDetails
    ...    @update: javinzon    03NOV2020    - Added Write Data To Excel for PTY002_CreatePartyID_MaintainPartyDetails
    ...    @update: javinzon    13NOV2020    - Added Write Data To Excel for PTY019_GLTBCrossReference_ColumnsValidation

    [Arguments]    ${ExcelPath}
    
    ### INPUTTER ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]

    Search Process in Party    &{ExcelPath}[Selected_Module]

    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    Validate Pre-Existence Check Page Values and Field State    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    ${Short_Name}    Get Short Name Value and Return    &{ExcelPath}[Short_Name_Prefix]    ${Party_ID}
    
    Run Keyword If    '${TestCase_Name}'=='PTY007_CreatePartyID_DuplicateEnterpriseName'   Run Keywords      Write Data To Excel    QuickPartyOnboarding    Enterprise_Name    PTY007_DuplicateEnterpriseName    ${Enterprise_Name}    ${PTY_DATASET}        bTestCaseColumn=True
    ...    AND    Write Data To Excel    QuickPartyOnboarding    Party_ID    PTY007_DuplicateEnterpriseName    ${Party_ID}    ${PTY_DATASET}    bTestCaseColumn=True
    ...    ELSE IF    '${TestCase_Name}'=='PTY008_CreatePartyID_DuplicateEnterpriseName_AcrossEntities'    Run Keywords    Write Data To Excel    QuickPartyOnboarding    Enterprise_Name    PTY008_DuplicateEnterpriseName_AcrossEntities    ${Enterprise_Name}    ${PTY_DATASET}        bTestCaseColumn=True
    ...    AND    Write Data To Excel    QuickPartyOnboarding    Party_ID    PTY008_DuplicateEnterpriseName_AcrossEntities    ${Party_ID}    ${PTY_DATASET}        bTestCaseColumn=True
    ...    ELSE IF    '${TestCase_Name}'=='PTY009_CreatePartyID_DuplicateShortName'    Write Data To Excel    QuickPartyOnboarding    Short_Name    PTY009_DuplicateShortName    ${Short_Name}    ${PTY_DATASET}    bTestCaseColumn=True
    ...    ELSE IF    '${TestCase_Name}'=='PTY010_CreatePartyID_DuplicateShortName_AcrossEntities'    Write Data To Excel    QuickPartyOnboarding    Short_Name    PTY010_DuplicateShortName_AcrossEntities    ${Short_Name}    ${PTY_DATASET}    bTestCaseColumn=True
    ...    ELSE IF    '${TestCase_Name}'=='PTY002_CreatePartyID_MaintainPartyDetails'    Run Keywords    Write Data To Excel    QuickPartyOnboarding    Party_ID    ${TestCase_Name}    ${Party_ID}    ${PTY_DATASET}    bTestCaseColumn=True
    ...    AND    Write Data To Excel    QuickPartyOnboarding    Entity    ${TestCase_Name}    ${Entity}    ${PTY_DATASET}        bTestCaseColumn=True
    ...    AND    Write Data To Excel    QuickPartyOnboarding    Assigned_Branch    ${TestCase_Name}    ${Assigned_Branch}    ${PTY_DATASET}        bTestCaseColumn=True
    ...    AND    Write Data To Excel    QuickPartyOnboarding    Enterprise_Name    ${TestCase_Name}    ${Enterprise_Name}    ${PTY_DATASET}        bTestCaseColumn=True
    ...    AND    Write Data To Excel    QuickPartyOnboarding    Short_Name    ${TestCase_Name}    ${Short_Name}    ${PTY_DATASET}        bTestCaseColumn=True
    ...    AND    Write Data To Excel    QuickPartyOnboarding    Party_ID    PTY002_MaintainPartyDetails    ${Party_ID}    ${PTY_DATASET}    bTestCaseColumn=True
    ...    AND    Write Data To Excel    QuickPartyOnboarding    Entity    PTY002_MaintainPartyDetails    ${Entity}    ${PTY_DATASET}        bTestCaseColumn=True
    ...    AND    Write Data To Excel    QuickPartyOnboarding    Assigned_Branch    PTY002_MaintainPartyDetails    ${Assigned_Branch}    ${PTY_DATASET}        bTestCaseColumn=True
    ...    ELSE IF    '${TestCase_Name}'=='PTY019_GLTBCrossReference_ColumnsValidation'    Write Data To Excel    QuickPartyOnboarding    Party_ID    ${TestCase_Name}    ${Party_ID}    ${PTY_DATASET}    bTestCaseColumn=True
    ...    ELSE IF    '${TestCase_Name}'=='PTY020_PartyCrossReferenceDetails'    Write Data To Excel    QuickPartyOnboarding    Party_ID    ${TestCase_Name}    ${Party_ID}    ${PTY_DATASET}    bTestCaseColumn=True

    Populate Quick Enterprise Party    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    ${Short_Name}    
   
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    ### SUPERVISOR ###
    ${Task_ID_From_Supervisor}    Approve Party via Supervisor Account    ${Party_ID}    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    
    ### INPUTTER ###
    Accept Approved Party and Validate Details in Enterprise Summary Details Screen    ${Task_ID_From_Supervisor}    ${Party_ID}    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]
    ...    &{ExcelPath}[Party_Category]    ${Enterprise_Name}    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    ${Short_Name}    
    ...    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[GST_Number]
    ...    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch] 