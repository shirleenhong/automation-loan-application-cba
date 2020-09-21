*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../../Configurations/Party_Import_File.robot

*** Variables ***

*** Keywords ***
Create Deal Borrower initial details in Quick Party Onboarding for BEPTYLTDATF
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding.
    ...    @author:    gerhabal    25SEP2019    Initial Create, based from "Create Deal Borrower initial details in Quick Party Onboarding for D00000454"     
    [Arguments]    ${ExcelPath}
    ###User Creates a Party Record###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_SSO_URL} 
    Navigate Process    &{ExcelPath}[Selected_Module]
    Populate Party Onboarding    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]          
    ${EnterpriseName}    ${PartyID}    Run Keyword If    '&{ExcelPath}[AutoGen_EnterpriseName]'=='Yes'    Run Keyword    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]    
    ###Writing for Party ID
    Run Keyword If    '&{ExcelPath}[AutoGen_EnterpriseName]'=='Yes'    Run Keywords    Write Data To Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    ORIG03_Customer    Party_ID    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}    
    ###Writing for Legal/Entrerpise Name
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${EnterpriseName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${EnterpriseName}    ${CBAUAT_ExcelPath}
    ###Writing for ShortName;
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Short_Name    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}       
    ...    AND    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}                
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}    
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}    
    ...    AND    Write Data To Excel    UAT02_Runbook    Borrower_Name    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}  
    ...    ELSE    Populate Pre-Existence Check with No Suffix    &{ExcelPath}[Enterprise_Name]
    
Populate Quick Enterprise Party with Approval for BEPTYLTDATF
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding.
    ...    @author:    gerhabal    26SEP2019, based from "Populate Quick Enterprise Party with Approval". shortname is being passed instead of party id
    [Arguments]    ${ExcelPath}           
    ${PartyID}    Read Data From Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${CBAUAT_ExcelPath}    
    ${EnterpriseName}    Read Data From Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${CBAUAT_ExcelPath}
    Populate Quick Enterprise Party    ${PartyID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GSTID]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Town_City]    
    ...    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    ${EnterpriseName}    
     
    Take Screenshot    ${Screenshot_Path}/Screenshots/Party/PartyDetails
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser
    
    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_APPROVER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    ${Task_ID_From_Supervisor}    Approve Registered Party    ${PartyID}
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party 
    Close Browser

    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}   
    Accept Approved Party    ${Task_ID_From_Supervisor}    ${PartyID}
    Validate Enterprise Party Details    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    ${PartyID}    ${EnterpriseName}    &{ExcelPath}[Registered_Number]
    Navigate Party Details Enquiry    ${PartyID}
    Validate Enquire Enterprise Party Details    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    ${EnterpriseName}    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Date_Formed]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    
    Close Browser
    
Search Customer and Complete its Borrower Profile Creation with default values for Deal Template
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values
    ...    @author: fmamaril    06AUG2019
    [Arguments]    ${ExcelPath}
	
	## Login to LoanIQ###
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

	###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[LIQCustomer_LegalName]          
    
    ###Adding Customer Notice Type Method
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    
    ###Adding Expense Code Details 
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    ###Adding Department Code Details
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    ##Adding Classification Code Details      	    
    Add Classification Code Details under General tab    None    None
        
    ###Unchecking "Subject to GST" checkbox
    Uncheck "Subject to GST" checkbox
    
    ###Adding Province Details in the Legal Address
    Add Province Details in the Legal Address    None
        
    ###Navigating to SIC tab
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    ###Navigating to Profile Tab     
    # Navigate to "Profiles" tab and Validate 'Add Profile' Button

    ###Adding Profile          
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]
          
    ###Adding Borrower Profile Details
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    ###Validating Buttons      
    # Validate Only 'Add Profile', 'Add Location' and 'Delete' Buttons are Enabled in Profile Tab
    
    ###Adding Location          
    Add Location under Profiles Tab for UAT Deal    &{ExcelPath}[Customer_Location]
    
    ###Adding Borrowwer/Location Details
    Add Borrowwer/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ###Validating Buttons if Enabled 
    Validate If All Buttons are Enabled
    
	###Adding Fax Details                 
    Add Fax Details under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]    
  
    Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]
    ...    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]    
       
    ##Completing Location              
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ###Adding Remittance Instructions
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Sleep    4s
    mx LoanIQ click    ${RemittanceInstructions_Button} 
    
    # Add RTGS Remittance Instruction for UAT Deal    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]
    # ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    # ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
    # ...    &{ExcelPath}[NoticesSummary]    &{ExcelPath}[RI_ToCust_Checkbox]
    
    # Add IMT Message in Remittance Instruction    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
    # ...    &{ExcelPath}[Swift_Role]    &{ExcelPath}[AWI_SwiftID]    &{ExcelPath}[AWI_ClearingNumber]    &{ExcelPath}[SwiftRole_OC]    
    # ...    &{ExcelPath}[SwiftRole_BC]    &{ExcelPath}[Details_Of_Charges]    &{ExcelPath}[BC_AccountNumber]

    # Add RTGS Remittance Instruction for UAT Deal    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]
    # ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    # ...    &{ExcelPath}[RI_FromCust_Checkbox2]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
    # ...    &{ExcelPath}[NoticesSummary]    &{ExcelPath}[RI_ToCust_Checkbox2]
    
    # Add IMT Message in Remittance Instruction    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
    # ...    &{ExcelPath}[Swift_Role]    &{ExcelPath}[AWI_SwiftID]    &{ExcelPath}[AWI_ClearingNumber]    &{ExcelPath}[SwiftRole_OC]    
    # ...    &{ExcelPath}[SwiftRole_BC]    &{ExcelPath}[Details_Of_Charges]    &{ExcelPath}[BC_AccountNumber]
        
    # mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    # Add Servicing Groups Details    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]
    Close Servicing Group Remittance Instructions Selection List Window    &{ExcelPath}[LIQCustomer_ShortName]
    mx LoanIQ click    ${ServicingGroupWindow_ExitButton}
         
    ###Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Party_ID]  
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - First Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]   &{ExcelPath}[Customer_Location]
                
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
          
    ##Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - Second Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]   &{ExcelPath}[Customer_Location]
    
    ###Releasing Added Remittance Instructions
    Releasing Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]    &{ExcelPath}[Customer_Location]
    Releasing Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]    &{ExcelPath}[Customer_Location]
                  
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[Party_ID]
        
    ###Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Search Customer and Complete its Borrower Profile Creation with default values for Deal Template Two
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values
    ...    @author: gerhabal    25SEP2019    - initial create    
    ...    @update: gerhabal    27SEP2019    - added writing for Remittance Description in multiple row    
    ...    @update: rmendoza    20AUG2020    - updated to follow new framework design [GDE-6722]
    [Arguments]    ${ExcelPath}
	
	# Login to LoanIQ###
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

	###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[LIQCustomer_LegalName]          
    
    ###Adding Customer Notice Type Method
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    
    ###Adding Expense Code Details 
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    ###Adding Department Code Details
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    ##Adding Classification Code Details      	    
    Add Classification Code Details under General tab    None    None
        
    ###Unchecking "Subject to GST" checkbox
    Uncheck "Subject to GST" checkbox
    
    ###Adding Province Details in the Legal Address
    Add Province Details in the Legal Address    None
        
    ###Navigating to SIC tab
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    ###Navigating to Profile Tab     
    Navigate to "Profiles" tab and Validate 'Add Profile' Button

    ###Adding Profile          
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]
          
    ###Adding Borrower Profile Details
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    ###Validating Buttons      
    Validate Only 'Add Profile', 'Add Location' and 'Delete' Buttons are Enabled in Profile Tab
    
    ###Adding Location          
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    
    ###Adding Borrowwer/Location Details
    Add Borrowwer/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    
    
    ###Validating Buttons if Enabled 
    Validate If All Buttons are Enabled
    
	###Adding Fax Details                 
    Add Fax Details under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]    
  
    Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]
    ...    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]    
       
    ##Completing Location              
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ###Adding Remittance Instructions
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
 
    mx LoanIQ click    ${RemittanceInstructions_Button} 
    
    Add RTGS Remittance Instruction for UAT Deal    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
    ...    &{ExcelPath}[NoticesSummary]    &{ExcelPath}[RI_ToCust_Checkbox]
    
    Add IMT Message in Remittance Instruction    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]    &{ExcelPath}[Swift_Role]    
    ...    &{ExcelPath}[AWI_SwiftID]    &{ExcelPath}[AWI_ClearingNumber]    &{ExcelPath}[SwiftRole_OC]    &{ExcelPath}[SwiftRole_BC]    &{ExcelPath}[Details_Of_Charges]
    ...    &{ExcelPath}[BC_AccountNumber]
    
    Add RTGS Remittance Instruction for UAT Deal    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox2]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
    ...    &{ExcelPath}[NoticesSummary]    &{ExcelPath}[RI_ToCust_Checkbox2]
    
    Add IMT Message in Remittance Instruction    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]    &{ExcelPath}[Swift_Role]    
    ...    &{ExcelPath}[AWI_SwiftID]    &{ExcelPath}[AWI_ClearingNumber]    &{ExcelPath}[SwiftRole_OC]    &{ExcelPath}[SwiftRole_BC]    &{ExcelPath}[Details_Of_Charges]
    ...    &{ExcelPath}[BC_AccountNumber]
    
    ${RemittanceDescription}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD   ${rowid}    ${CBAUAT_ExcelPath}    
    
    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceDescription}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    UAT02_Runbook    Remittance_Description    ${rowid}    ${RemittanceDescription}    ${CBAUAT_ExcelPath}    multipleValue=Y
    
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    
    Add Servicing Groups Details    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Group_Contact]    &{ExcelPath}[Contact_LastName]
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]
    Close Servicing Group Remittance Instructions Selection List Window    &{ExcelPath}[LIQCustomer_ShortName]
    ## mx LoanIQ click    ${ServicingGroupWindow_ExitButton}
         
    ###Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Party_ID]  
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - First Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]   &{ExcelPath}[Customer_Location]
                
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
          
    ##Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - Second Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]   &{ExcelPath}[Customer_Location]
    
    ###Releasing Added Remittance Instructions
    Releasing Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD]    &{ExcelPath}[Customer_Location]
    Releasing Remittance Instruction    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUD2]    &{ExcelPath}[Customer_Location]
                  
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[Party_ID]
        
    ###Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Create Deal D00000963 Borrower initial details in Quick Party Onboarding
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding.
    ...    @author:    gerhabal    02OCT2019    Initial Create, based from "Create Deal Borrower initial details in Quick Party Onboarding"     
    [Arguments]    ${ExcelPath}
    ### User Creates a Party Record###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_SSO_URL} 
    Navigate Process    &{ExcelPath}[Selected_Module]    
    Populate Party Onboarding    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]          
    ${EnterpriseName}    ${PartyID}    Run Keyword If    '&{ExcelPath}[AutoGen_EnterpriseName]'=='Yes'    Run Keyword    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    
    ### Writing for Party ID
    Run Keyword If    '&{ExcelPath}[AutoGen_EnterpriseName]'=='Yes'    Run Keywords    Write Data To Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    ORIG03_Customer    Party_ID    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}    
    
    ### Writing for Legal/Entrerpise Name
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${EnterpriseName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${EnterpriseName}    ${CBAUAT_ExcelPath}
    
    ### Writing for ShortName;
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Short_Name    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_ShortName    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}       
    ...    ELSE    Populate Pre-Existence Check with No Suffix    &{ExcelPath}[Enterprise_Name]  
