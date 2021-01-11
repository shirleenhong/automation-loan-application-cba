*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../../Configurations/Party_Import_File.robot

*** Variables ***

*** Keywords ***

Create Deal Borrower Initial Details in Quick Party Onboarding for PT Health Syndicated Deal
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding for PT Health Syndicated Deal.
    ...    @author:    songchan    05JAN2021    Initial Create
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
    
Search Customer and Complete Borrower Profile Creation with Default Values for PT Health Syndicated Deal
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values
    ...    @author: songchan    05JAN2021    - initial create
    [Arguments]    ${ExcelPath}
	
	###Login to LoanIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to Customer Notebook via Customer ID    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode

    ###General Tab - Add Customer Notice Type Method, Expense Code, Department Code
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    ###Corporate Tab - Verifying Values in Corporate tab
    Validate Corporate Tab Values    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[LIQBorrower_LegalName]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Business_Country]

    ###SIC Tab - Validate Sic Code and Desc
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[SICCode]    ${ENTITY} / &{ExcelPath}[Business_Activity]

    ###Profile Tab - Adding Profile, Borrower Profile, Location, Contact, and Remittance Instruction
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
    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RI_DDAMethod]    &{ExcelPath}[RI_DDADescription]    &{ExcelPath}[RI_DDAAccountName]
    ...    &{ExcelPath}[RI_DDAAccountNumber]    &{ExcelPath}[RI_DDACurrency]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]
    ...    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]
    Add RTGS Remittance Instruction for UAT Deal    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RI_RTGSMethod]    &{ExcelPath}[RI_RTGSDescription]    &{ExcelPath}[RI_RTGSCurrency]    &{ExcelPath}[RI_RTGS_DirectionSelected]
    ...    &{ExcelPath}[RI_IMT_Code]	&{ExcelPath}[BOC_Level]    &{ExcelPath}[RI_RTGS_FromCust_Checkbox]    &{ExcelPath}[RI_RTGS_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
    ...    &{ExcelPath}[Notice_Summary]    &{ExcelPath}[RI_RTGS_ToCust_Checkbox]
    Add IMT Message in Remittance Instruction    &{ExcelPath}[RI_IMT_Code]    &{ExcelPath}[BOC_Level]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]    &{ExcelPath}[Swift_Role]    
    ...    &{ExcelPath}[Swift_Code]    &{ExcelPath}[AWI_ClearingNumber]    &{ExcelPath}[SwiftRole_OC]    &{ExcelPath}[SwiftRole_BC]    &{ExcelPath}[Details_Of_Charges]
    ...    &{ExcelPath}[BC_AccountNumber]    

    Activate and Close Remittance List Window
    Add Servicing Groups Details    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Group_Contact]    &{ExcelPath}[Contact_LastName]    
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[RI_DDADescription]
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[RI_RTGSDescription]     
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
    Approving Remittance Instruction    &{ExcelPath}[RI_RTGSDescription]    &{ExcelPath}[Customer_Location]
    
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
    Approving Remittance Instruction    &{ExcelPath}[RI_RTGSDescription]   &{ExcelPath}[Customer_Location]
    
    ###Releasing Added Remittance Instructions
    Releasing Remittance Instruction    &{ExcelPath}[RI_DDADescription]    &{ExcelPath}[Customer_Location]
    Releasing Remittance Instruction    &{ExcelPath}[RI_RTGSDescription]    &{ExcelPath}[Customer_Location]
    Click Loan IQ Element    ${RemittanceList_Window_ExitButton}
    Verify Window    ${LIQ_ActiveCustomer_Window}           
    Validate 'Active Customer' Window    &{ExcelPath}[Party_ID]
        
    ###Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    

    