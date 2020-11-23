*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Create Party For Duplicate Short Name Validation
    [Documentation]    This test case is used to check for duplicate short name for Quick Enterprise Party Page
    ...    @author: nbautist    19OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### INPUTTER ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    Search Process in Party    &{ExcelPath}[Selected_Module]
    
    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]
    ...    &{ExcelPath}[Branch_Code]
    Validate Pre-Existence Check Page Fields if Disabled
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    Validate Disabled Fields in Quick Enterprise Party Page    &{ExcelPath}[Country_Region]
    
    Write Data To Excel    QuickPartyOnboarding    Party_ID    ${TESTCASE_NAME_PARTY}    ${Party_ID}    ${PTY_DATASET}        bTestCaseColumn=True
    Write Data To Excel    QuickPartyOnboarding    Enterprise_Name    ${TESTCASE_NAME_PARTY}    ${Enterprise_Name}    ${PTY_DATASET}        bTestCaseColumn=True
    ${sParty_Id}    Convert To String    ${Party_ID}
    Write Data To Excel    QuickPartyOnboarding    Short_Name    ${TESTCASE_NAME_PARTY}    &{ExcelPath}[Short_Name_Prefix]_${sParty_Id}    ${PTY_DATASET}        bTestCaseColumn=True
    Set Global Variable    ${DUPLICATE_SHORT_NAME}    &{ExcelPath}[Short_Name_Prefix]_${sParty_Id}

    Populate Quick Enterprise Party    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Short_Name_Prefix]_${sParty_Id}  
        
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    ### SUPERVISOR ###
    ${Task_ID_From_Supervisor}    Approve Party via Supervisor Account    ${Party_ID}    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    
    ### INPUTTER ###
    Accept Approved Party and Validate Details in Enterprise Summary Details Screen    ${Task_ID_From_Supervisor}    ${Party_ID}    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]
    ...    &{ExcelPath}[Party_Category]    ${Enterprise_Name}    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    ${Short_Name}    
    ...    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[GST_Number]
    ...    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]   

Update Party For Duplicate Short Name Validation
    [Documentation]    This keyword is used to update Party/Customer via Maintain Party Details Module.
    ...    @author: nbautist    22OCT2020    - initial create.
    [Arguments]    ${ExcelPath}
    
    ### INPUTTER ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    Navigate Maintain Party Details    &{ExcelPath}[Party_ID]
    
    ### Edit Short Name
    Enter Short Name and Validate Duplicate Error    ${DUPLICATE_SHORT_NAME}

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser