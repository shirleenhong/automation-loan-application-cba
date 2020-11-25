*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../../Configurations/Party_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***

Create Deal Borrower initial details in Quick Party Onboarding for CH EDU Bilateral Deal
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding for CH EDU Bilateral Deal.
    ...    @author:    dahijara    24NOV2020    Initial Create
    [Arguments]    ${ExcelPath}

    ### INPUTTER ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]

    Search Process in Party    &{ExcelPath}[Selected_Module]

    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    ${Entity_Name}    Get Substring    ${Entity}    0    2
    
    Validate Pre-Existence Check Page Values and Field State    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    # ${Party_ID}    Generate Unique Number or Text for Party
    # Populate Pre-Existence Check with No Suffix    &{ExcelPath}[Enterprise_Prefix]
    ${Short_Name}    Get Short Name Value and Return    &{ExcelPath}[Short_Name_Prefix]    ${Party_ID}
    # Run Keyword If    '${SCENARIO}'=='0'    Write Data To Excel    QuickPartyOnboarding    Party_ID    PTY001_QuickPartyOnboarding    ${Party_ID}    ${PTY_DATASET}        bTestCaseColumn=True
    
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

    Validate Party Details in Loan IQ    ${Party_ID}    ${Short_Name}    ${Enterprise_Name}    &{ExcelPath}[GST_Number]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Business_Country]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    ${Entity_Name}

    Write Data To Excel    PTY001_QuickPartyOnboarding    LIQBorrower_ID    ${rowid}    ${Party_ID}
    Write Data To Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    ${rowid}    ${Short_Name.upper()}
    Write Data To Excel    PTY001_QuickPartyOnboarding    LIQBorrower_LegalName    ${rowid}    ${Enterprise_Name}

Search Customer and Complete its Borrower Profile Creation with default values for CH EDU Bilateral Deal
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values
    ...    @author: dahijara    25NOV2020
    [Arguments]    ${ExcelPath}
	
	###Login to LoanIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to Customer Notebook via Customer ID    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode

    ###Adding Customer Notice Type Method
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    
    ###Adding Expense Code Details 
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    ###Adding Department Code Details
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]

    ##Navigating to Profile Tab 
    Navigate to "Profiles" tab and Validate 'Add Profile' Button

    ###Adding Profile          
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]
          
    ###Adding Borrower Profile Details
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    ##Validating Buttons 
    Validate Only 'Add Profile', 'Add Location' and 'Delete' Buttons are Enabled in Profile Tab
    
    ###Adding Location          
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    
    ###Adding Borrowwer/Location Details
    Add Borrowwer/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    
    
    ###Validating Buttons if Enabled 
    Validate If All Buttons are Enabled
  
    Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]
    ...    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]    
       
    ##Completing Location              
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ###Adding Remittance Instructions
    mx LoanIQ click    ${RemittanceInstructions_Button} 
    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RI_DDAMethod]    &{ExcelPath}[RI_DDADescription]    &{ExcelPath}[RI_DDAAccountName]    &{ExcelPath}[RI_DDAAccountNumber]    &{ExcelPath}[RI_DDACurrency]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    
    ...    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]   
    Activate and Close Remittance List Window
    Add Servicing Groups Details    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Group_Contact]    &{ExcelPath}[Contact_LastName]
    
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