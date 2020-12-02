*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***


*** Keywords ***
Create Deal Borrower in Quick Party Onboarding for PIM Future BILAT
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding and Validates in LIQ.
    ...    @author:    mcastro    24NOV2020    - Initial Create
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

    Populate Quick Enterprise Party    ${Party_ID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GST_Number]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]
    ...    &{ExcelPath}[Town_City]    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    ${Short_Name}    
    
    Write Data To Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${PartyID}
    Write Data To Excel    ORIG03_Customer    LIQCustomer_ID    ${rowid}    ${PartyID}
    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    &{ExcelPath}[Enterprise_Prefix] ${PartyID}
    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    &{ExcelPath}[Enterprise_Prefix] ${PartyID}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    &{ExcelPath}[Enterprise_Prefix]                      
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    &{ExcelPath}[Enterprise_Prefix]   
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}    &{ExcelPath}[Enterprise_Prefix]   

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser
    
    ## SUPERVISOR ###
    ${Task_ID_From_Supervisor}    Approve Party via Supervisor Account    ${Party_ID}    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    
    ### INPUTTER ###
    Accept Approved Party and Validate Details in Enterprise Summary Details Screen    ${Task_ID_From_Supervisor}    ${Party_ID}    &{ExcelPath}[Locality]    ${Entity}    ${Assigned_Branch}    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]
    ...    &{ExcelPath}[Party_Category]    ${Enterprise_Name}    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    ${Short_Name}    
    ...    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[GST_Number]
    ...    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]  

    Validate Party Details in Loan IQ    ${Party_ID}    ${Short_Name}    ${Enterprise_Name}    &{ExcelPath}[GST_Number]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Business_Country]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    &{ExcelPath}[Town_City]
    ...    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    ${Entity_Name}

    Close All Windows on LIQ
    Logout from Loan IQ

Search Customer and Complete its Borrower Profile in LIQ for PIM Future BILAT
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation.
    ...    @author: mcastro     24NOV2020    - Initial Create
    ...    @update: mcastro     02DEC2020    - Added updating of Servicing group Alias
    [Arguments]    ${ExcelPath}	
    ### Login To LIQ ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

	### Search Customer ###  	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    
    ### General Tab Details ###
    Read Excel Data and Validate Customer ID, Short Name and Legal Name fields    &{ExcelPath}[LIQCustomer_ID]     &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[LIQCustomer_LegalName]
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    ### SIC Tab ###
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    ### Profile Tab Details ###               
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]    
    Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab         
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    Add Borrower/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    
    Validate If All Buttons are Enabled
    Check Legal Address Details Under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Address_Code]    &{ExcelPath}[Address_Line1]    &{ExcelPath}[Address_Line2]    &{ExcelPath}[Address_City]    &{ExcelPath}[Address_ZipPostalCode]    &{ExcelPath}[LIQCustomer_ShortName]                    
    Add Fax Details under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]    

    ### Add Contacts ###
    Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]
    ...    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]    
    
    ### Complete Location ###             
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]

    ### Add Remittance Instruction ###
    Navigate to Remittance List Page
    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_Method]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[RemittanceInstruction_AccountName]    &{ExcelPath}[RemittanceInstruction_AccountNumber] 
    ...    &{ExcelPath}[RemittanceInstruction_Currency]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    
    ...    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]     
                
    ### Login as Supervisor ####
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Search Customer ### 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]  
    Switch Customer Notebook to Update Mode
    
    ### Approve Added Remittance Instructions ###  
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[Remittance_Description]   &{ExcelPath}[Customer_Location]
        
    ### Login as Manager ###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ### Search Customer ###	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
    
    ###Approve Added Remittance Instructions - Second Approval ###   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[Remittance_Description]   &{ExcelPath}[Customer_Location]
  
    ### ReleaseAdded Remittance Instructions ###
    Releasing Remittance Instruction    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Customer_Location]
                       
    ### Login as Inputter ###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Search Customer ### 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode    
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Customer_Location]
    Mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    
    ### Add Servicing Group ### 
    Add Servicing Groups Details    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]  
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[Remittance_Description] 
    Close Servicing Group Remittance Instructions Selection List Window    &{ExcelPath}[LIQCustomer_ShortName]
    Update Borrower Servicing Group Alias    &{ExcelPath}[Borrower_SGAlias]

    ### Save Customer Details ###
    Save Customer Details
    
    Close All Windows on LIQ