*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../../Configurations/Party_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***

Create Deal Borrower Initial Details in Quick Party Onboarding for LLA Syndicated Deal
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding for LLA Syndicated Deal.
    ...    @author:    makcamps    17DEC2020    Initial Create
    [Arguments]    ${ExcelPath}

    ### INPUTTER ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]

    Search Process in Party    &{ExcelPath}[Selected_Module]

    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    ${Entity_Name}    Get Substring    ${Entity}    0    2
    
    Validate Pre-Existence Check Page Values and Field State    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    ${Short_Name}    Get Short Name Value and Return    &{ExcelPath}[Short_Name_Prefix]    ${Party_ID}

    Write Data To Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${Party_ID}
    Write Data To Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    ${rowid}    ${Short_Name.upper()}
    Write Data To Excel    PTY001_QuickPartyOnboarding    LIQBorrower_LegalName    ${rowid}    ${Enterprise_Name}
    
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

    Pause Execution

    Validate Party Details in Loan IQ    ${Party_ID}    ${Short_Name}    ${Enterprise_Name}    &{ExcelPath}[GST_Number]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Business_Country]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    ${Entity_Name}
    
Search Customer and Complete Borrower Profile Creation with Default Values for LLA Syndicated Deal
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values
    ...    @author: makcamps    17DEC2020
    [Arguments]    ${ExcelPath}
	
	###Login to LoanIQ
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to Customer Notebook via Customer ID    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode

    ###General Tab - Add Customer Notice Type Method, Expense Code, Department Code
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    ###Corporate Tab - Verifying Values in Corporate tab
    Validate Corporate Tab Values    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[LIQBorrower_LegalName]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Business_Country]

    ###Risk Tab - Add External Risk Rating
    Add External Risk Rating    &{ExcelPath}[RatingType1]    &{ExcelPath}[Rating1]    &{ExcelPath}[RatingStartDate1]
    Add External Risk Rating    &{ExcelPath}[RatingType2]    &{ExcelPath}[Rating2]    &{ExcelPath}[RatingStartDate2]
    Validate External Risk Rating Table    &{ExcelPath}[RatingType1]    &{ExcelPath}[Rating1]    &{ExcelPath}[RatingStartDate1]
    Validate External Risk Rating Table    &{ExcelPath}[RatingType2]    &{ExcelPath}[Rating2]    &{ExcelPath}[RatingStartDate2]

    ###SIC Tab - Validate Sic Code and Desc
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[SICCode]    ${ENTITY} / &{ExcelPath}[Business_Activity]

    ##Profile Tab - Adding Profile, Borrower Profile, Location, Contact, and Remittance Instruction
    Navigate to "Profiles" tab and Validate 'Add Profile' Button
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    Validate Only 'Add Profile', 'Add Location' and 'Delete' Buttons are Enabled in Profile Tab
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]
    Add Borrowwer/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Validate If All Buttons are Enabled  
    Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]
    ...    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]
    ...    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]
    ...    &{ExcelPath}[BalanceType_Principal_Checkbox]    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    mx LoanIQ click    ${RemittanceInstructions_Button}
    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RI_DDAMethod]    &{ExcelPath}[RI_DDADescription]    &{ExcelPath}[RI_DDAAccountName]
    ...    &{ExcelPath}[RI_DDAAccountNumber]    &{ExcelPath}[RI_DDACurrency]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]
    ...    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]
    Activate and Close Remittance List Window
    Add Servicing Groups Details    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Group_Contact]    &{ExcelPath}[Contact_LastName]    
    Run Keyword If    '&{ExcelPath}[Borrower_SGAlias]'!='None'    Update Borrower Servicing Group Alias    &{ExcelPath}[Borrower_SGAlias]
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[RI_DDADescription]     
    Close Servicing Group Remittance Instructions Selection List Window    &{ExcelPath}[LIQCustomer_ShortName]    
             
    ###Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Searching Customer
    Navigate to Customer Notebook via Customer ID    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - First Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RI_DDADescription]   &{ExcelPath}[Customer_Location]
    
    ###Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Searching Customer
    Navigate to Customer Notebook via Customer ID    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - Second Approval
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RI_DDADescription]   &{ExcelPath}[Customer_Location]
    
    ###Releasing Added Remittance Instructions
    Releasing Remittance Instruction    &{ExcelPath}[RI_DDADescription]    &{ExcelPath}[Customer_Location]          
    Validate 'Active Customer' Window    &{ExcelPath}[Party_ID]
        
    ###Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Update Party Details in Maintain Party Details Module for LLA Syndicated Deal
    [Documentation]    This keyword is used to update Party/Customer via Maintain Party Details Module and validate in Loan IQ.
    ...    @author: makcamps    17DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### INPUTTER ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    
    Navigate Maintain Party Details    &{ExcelPath}[Party_ID]        

    ${New_Enterprise_Name}    ${New_Short_Name}    Update Business Activity, Short Name and Enterprise Name in Enterprise Party Page    &{ExcelPath}[New_Enterprise_Prefix]
    ...    &{ExcelPath}[New_Short_Name_Prefix]    &{ExcelPath}[Party_ID]    &{ExcelPath}[New_Industry_Sector]    &{ExcelPath}[New_Business_Activity]
    
    Write Data To Excel    PTY001_QuickPartyOnboarding    New_Enterprise_Name     ${TestCase_Name}    ${New_Enterprise_Name}    bTestCaseColumn=True
    Write Data To Excel    PTY001_QuickPartyOnboarding    New_Short_Name    ${TestCase_Name}    ${New_Short_Name}    bTestCaseColumn=True   
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser
    
    ### SUPERVISOR ###
    ${TaskID_ForPartyDetails}    Approve Party via Supervisor Account    &{ExcelPath}[Party_ID]    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    
    ### INPUTTER ###
    Accept Approved Updated Selected Details Party    ${TaskID_ForPartyDetails}    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]  
    
    ${Enterprise_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    New_Enterprise_Name    ${TestCase_Name}    sTestCaseColReference=Test_Case 
    ${Short_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    New_Short_Name    ${TestCase_Name}    sTestCaseColReference=Test_Case
    
    Validate Enquire Enterprise Party After Amendment    &{ExcelPath}[Business_Country]    &{ExcelPath}[New_Industry_Sector]    &{ExcelPath}[New_Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Locality]    
    ...    &{ExcelPath}[Entity]    &{ExcelPath}[Assigned_Branch]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Party_ID]    ${Enterprise_Name}    &{ExcelPath}[Registered_Number]   
    ...    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    ${Short_Name}    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]
    ...    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Country_Region]    &{ExcelPath}[GST_Number]
    
    ${Entity_Name}    Get Substring    &{ExcelPath}[Entity]    0    2
    
    Pause Execution

    Validate Party Details in Loan IQ    &{ExcelPath}[Party_ID]    ${Short_Name}    ${Enterprise_Name}    &{ExcelPath}[GST_Number]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[New_Business_Activity]    &{ExcelPath}[Business_Country]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    ${Entity_Name}
    