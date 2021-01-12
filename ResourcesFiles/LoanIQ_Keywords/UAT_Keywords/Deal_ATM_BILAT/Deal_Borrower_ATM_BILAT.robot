*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Deal Borrower in Quick Party Onboarding for ATM BILAT
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding.
    ...    @author:    nbautist    07DEC2020    - Initial Create
    ...    @author:    ccarriedo    12JAN2021    - Removed keyword Get Short Name Value and Return and replaced with simple Catenate as the required shortname should not have space
    [Arguments]    ${ExcelPath}
    ### INPUTTER ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 

    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]

    Search Process in Party    &{ExcelPath}[Selected_Module]

    ${Entity}    ${Assigned_Branch}    Populate Party Onboarding and Return Values    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]
    
    ${Entity_Name}    Get Substring    ${Entity}    0    2
    
    Validate Pre-Existence Check Page Values and Field State    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]
    ${Enterprise_Name}    ${Party_ID}    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    ${Short_Name}    Catenate    SEPARATOR=    &{ExcelPath}[Short_Name_Prefix]    ${Party_ID}

    Populate Quick Enterprise Party    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    ${Short_Name}    
    
    Write Data To Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${PartyID}
    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${Enterprise_Name}
    Write Data To Excel    PTY001_QuickPartyOnboarding    Short_Name    ${rowid}    ${Short_Name}
    Write Data To Excel    PTY001_QuickPartyOnboarding    LIQBorrower_LegalName    ${rowid}    ${Enterprise_Name}
    Write Data To Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    ${rowid}    ${Short_Name}
    Write Data To Excel    ORIG03_Customer    LIQCustomer_ID    ${rowid}    ${PartyID}
    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${Enterprise_Name}
    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${Short_Name}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${Short_Name}                      
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${Enterprise_Name}   
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}    ${Enterprise_Name}   

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser
    
    ### SUPERVISOR ###
    ${Task_ID_From_Supervisor}    Approve Party via Supervisor Account    ${Party_ID}    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    
    ### INPUTTER ###
    Accept Approved Party and Validate Details in Enterprise Summary Details Screen    ${Task_ID_From_Supervisor}    ${Party_ID}    &{ExcelPath}[Locality]    ${Entity}
    ...    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    ${Enterprise_Name}    &{ExcelPath}[Registered_Number]    
    ...    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    ${Short_Name}    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]
    ...    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[GST_Number]    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]  

Search Customer and Complete Borrower Profile Creation with Default Values for ATM Bilateral Deal
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values
    ...    @author: nbautista    09DEC2020
    ...    @author: ccarriedo    12JAN2021    - Added Update Borrower Servicing Group Alias keyword to populate Borrower_SGAlias column
    [Arguments]    ${ExcelPath}
	
	### Login to LoanIQ ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to Customer Notebook via Customer ID    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode

    ### Adding Customer Notice Type Method ###
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    
    ### Adding Expense Code Details ###
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    ### Adding Department Code Details ###
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]

    ### Navigating to Profile Tab ###
    Navigate to "Profiles" tab and Validate 'Add Profile' Button

    ### Adding Profile ###
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]
          
    ### Adding Borrower Profile Details ###
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    ### Validating Buttons ###
    Validate Only 'Add Profile', 'Add Location' and 'Delete' Buttons are Enabled in Profile Tab
    
    ### Adding Location ###
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    
    ### Adding Borrowwer/Location Details ###
    Add Borrowwer/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    
    
    ### Validating Buttons if Enabled ###
    Validate If All Buttons are Enabled
  
    Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    
    ...    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]
    ...    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]    
       
    ### Completing Location ###
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ### Adding Remittance Instructions ###
    mx LoanIQ click    ${RemittanceInstructions_Button} 
    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RI_DDAMethod]    &{ExcelPath}[RI_DDADescription]    &{ExcelPath}[RI_DDAAccountName]
    ...    &{ExcelPath}[RI_DDAAccountNumber]    &{ExcelPath}[RI_DDACurrency]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    
    ...    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]   
    Activate and Close Remittance List Window
    Add Servicing Groups Details    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Group_Contact]    &{ExcelPath}[Contact_LastName]
    
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[RI_DDADescription]     
     
    Close Servicing Group Remittance Instructions Selection List Window    &{ExcelPath}[LIQCustomer_ShortName]    
    Update Borrower Servicing Group Alias    &{ExcelPath}[Borrower_SGAlias]         
    ### Logout and Relogin in Supervisor Level ###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Searching Customer ###
    Navigate to Customer Notebook via Customer ID    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode
    
    ### Approving Added Remittance Instructions - First Approval ### 
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RI_DDADescription]   &{ExcelPath}[Customer_Location]
    
    ### Logout and Relogin in Manager Level ###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ### Searching Customer ###
    Navigate to Customer Notebook via Customer ID    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode
    
    ### Approving Added Remittance Instructions - Second Approval ###
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RI_DDADescription]   &{ExcelPath}[Customer_Location]
    
    ### Releasing Added Remittance Instructions ###
    Releasing Remittance Instruction    &{ExcelPath}[RI_DDADescription]    &{ExcelPath}[Customer_Location]                 
    Validate 'Active Customer' Window    &{ExcelPath}[Party_ID]
        
    ### Logout and Relogin in Inputter Level ###
    Close All Windows on LIQ
    Logout from Loan IQ
    
Setup Deal for ATM BILAT
    [Documentation]    This keyword is for setting up Deal for ATM Bilateral Deal
    ...    @author: ccarriedo    12JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}
	
	### Login to LoanIQ ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias with Numeric Test Data    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]    4

    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]  
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    &{ExcelPath}[rowid] 
    ${Borrower_SGAlias}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SGAlias    &{ExcelPath}[rowid] 
    ${Borrower_SG_GroupMembers}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_GroupMembers    &{ExcelPath}[rowid] 
    ${Borrower_PreferredRIMthd}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_PreferredRIMthd    &{ExcelPath}[rowid] 
    ${Borrower_SG_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid] 
    ${Borrower_Depositor_Indicator}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_Depositor_Indicator    &{ExcelPath}[rowid] 

    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}
    Close All Windows on LIQ
    
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]

    ### Summary Tab ###   
    Add Deal Borrower    ${Borrower_ShortName}
    Select Deal Borrower Location and Servicing Group    ${Borrower_Location}    ${Borrower_SGAlias}    ${Borrower_SG_GroupMembers}    ${Borrower_PreferredRIMthd}    ${Borrower_ShortName}    ${Borrower_SG_Name}
    Select Deal Borrower Remmitance Instruction    ${Borrower_ShortName}    ${Deal_Name}    ${Borrower_Location}    ${Borrower_Depositor_Indicator}
    
    ### Add another borrower ###
    ${Borrower_ShortName2}    Read Data From Excel    ORIG03_Customer    LIQCustomer_ShortName    2
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName2    &{ExcelPath}[rowid]    ${Borrower_ShortName2}
    Add Deal Borrower    ${Borrower_ShortName2}
    
    ### Close Deal Borrower window ###
    mx LoanIQ click    ${LIQ_DealBorrower_Ok_Button}
    
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_RIMethod]    &{ExcelPath}[AdminAgent_SGName]
    Enter Agreement Date    &{ExcelPath}[Deal_AgreementDate]
    Unrestrict Deal

    ### Check Sole Lender checkbox ###
    Set Deal as Sole Lender

    ### Personnel Tab ###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ### Calendars Tab ###
    Delete Existing Holiday on Calendar Table
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar1]
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar2]
    
    ### Pricing Rules Tab ###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    
    ...    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    None    None    &{ExcelPath}[PricingOption_RoundingApplicationMethod]      
    ...    &{ExcelPath}[PricingOption_PercentOfRateFormulaUsage]    &{ExcelPath}[PricingOption_RepricingNonBusinessDayRule]    None    &{ExcelPath}[PricingOption_InterestDueUponPrincipalPayment]    &{ExcelPath}[PricingOption_InterestDueUponRepricing]
    ...    None    None    None    None    None    None    &{ExcelPath}[PricingOption_MinimumPaymentAmount]    &{ExcelPath}[PricingOption_MinimumAmountMultiples]    None    &{ExcelPath}[PricingOption_BillBorrower]     None    None

    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]

    ### Save Changes ###    
    Save Changes on Deal Notebook
    
    ### Set variables for adding another borrower on next keyword ####
    Set Global Variable    ${Deal_Name}
    Set Global Variable    ${Deal_Alias}
    
    ### Logout and Relogin in Inputter Level ###
    Close All Windows on LIQ
    Logout from Loan IQ
