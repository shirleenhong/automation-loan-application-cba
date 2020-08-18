*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../../Configurations/Party_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***
Create Deal Borrower initial details in Quick Party Onboarding
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding.
    ...    @author:    fmamaril    26JUN2019
    [Arguments]    ${ExcelPath}
    ###User Creates a Party Record###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_SSO_URL} 
    Navigate Process    &{ExcelPath}[Selected_Module]    
    Populate Party Onboarding    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Type]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Branch_Code]          
    ${EnterpriseName}    ${PartyID}    Run Keyword If    '&{ExcelPath}[AutoGen_EnterpriseName]'=='Yes'    Run Keyword    Populate Pre-Existence Check    &{ExcelPath}[Enterprise_Prefix]
    Run Keyword If    '&{ExcelPath}[AutoGen_EnterpriseName]'=='Yes'    Run Keywords    Write Data To Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    ORIG03_Customer    Party_ID    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    ORIG03_Customer    LIQCustomer_LegalName    ${rowid}    ${EnterpriseName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${EnterpriseName}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Borrower_Name    ${rowid}    ${PartyID}    ${CBAUAT_ExcelPath}    Y
    ...    ELSE    Populate Pre-Existence Check with No Suffix    &{ExcelPath}[Enterprise_Name]    

Populate Quick Enterprise Party with Approval
    [Documentation]    This keyword creates a Deal Borrower in Quick Party Onboarding.
    ...    @author:    fmamaril    26JUN2019
    [Arguments]    ${ExcelPath}           
        ${PartyID}    Read Data From Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}    ${CBAUAT_ExcelPath}    
    ${EnterpriseName}    Read Data From Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    ${rowid}    ${CBAUAT_ExcelPath}
    Populate Quick Enterprise Party    ${PartyID}    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Document_Collection_Status]
    ...    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]
    ...    &{ExcelPath}[GSTID]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Town_City]    
    ...    &{ExcelPath}[State_Province]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Registered_Number]    ${EnterpriseName}    
       
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Party Details
    Take Screenshot    ${SCREENSHOT_FILENAME}
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
    
Search Customer and Complete its Borrower Profile Creation with default values for Deal Template Three
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values
    ...    @author: fmamaril    06AUG2019
    [Arguments]    ${ExcelPath}
	
	# # ## Login to LoanIQ###
	# # Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

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
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL3-Customer-General
    Take Screenshot    ${SCREENSHOT_FILENAME}
    
    ###Adding Province Details in the Legal Address
    Add Province Details in the Legal Address    None
        
    ###Navigating to SIC tab
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL3-Customer-SIC
    Take Screenshot    ${SCREENSHOT_FILENAME}
    
    ###Navigating to Profile Tab
    Navigate to "Profiles" tab and Validate "Add Profile" Button

    ###Adding Profile
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]
          
    ###Adding Borrower Profile Details
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    ###Validating Buttons
    Validate Only 'Add Profile Button' is Enabled in Profile Tab
    
    ###Adding Location
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    
    ###Adding Borrowwer/Location Details
    # Add Borrowwer/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    
    
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
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL3-Customer-Profile
    Take Screenshot    ${SCREENSHOT_FILENAME}
    
    ###Adding Remittance Instructions
    Navigate to Remittance List Page
    
Add IMT message code for UAT Deal
    [Documentation]    This keyword adds an IMT message code for the customer
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}
	# Add IMT Message in Remittance Instructions Detail    &{ExcelPath}[IMT_MessageCode]
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL3-Customer-RemittanceInstructionDetail
    Take Screenshot    ${SCREENSHOT_FILENAME}

Add Swift Role in IMT message for UAT Deal
    [Documentation]    This keyword adds a swift role for the customer in UAT Deal
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}	
	# Add Swift Role in IMT message    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]    &{ExcelPath}[Swift_Role]    &{ExcelPath}[SwiftID]    &{ExcelPath}[Swift_Description]
	# ...    &{ExcelPath}[ClearingType]    &{ExcelPath}[ClearingNumber]    &{ExcelPath}[AccountNumber]
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL3-Customer-SwiftRole
    Take Screenshot    ${SCREENSHOT_FILENAME}

Update Swift Role in IMT message for UAT Deal
    [Documentation]    This keyword updates a swift role in IMT message for a UAT Deal
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}	
	# Update Swift Role in IMT message    &{ExcelPath}[Swift_Role]    &{ExcelPath}[Swift_Description]    &{ExcelPath}[ClearingType]
	# ...    &{ExcelPath}[ClearingNumber]    &{ExcelPath}[AccountNumber]	
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL3-Customer-SwiftRole
    Take Screenshot    ${SCREENSHOT_FILENAME}
		
Populate Details on IMT for UAT Deal
    [Documentation]    This keyword populates the details on IMT for UAT Deal
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}		
    # Populate Details on IMT    &{ExcelPath}[Details_Of_Charges]    &{ExcelPath}[BOC_Level]    &{ExcelPath}[DetailsOfPayment]    &{ExcelPath}[SenderToReceiverInfo]    &{ExcelPath}[OrderingCustomer]
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL3-Customer-IMTDetails
    Take Screenshot    ${SCREENSHOT_FILENAME}
    mx LoanIQ click    ${RemittanceList_Window_RemittanceInstructionsDetail_IMT_OKButton}        
    mx LoanIQ select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_SaveMenu}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    
Send Remittance Instruction to Approval and Close RI Notebook
    [Documentation]    This keyword sends RI to approval and closes the RI notebook
    ...    @author: fmamaril    19AUG2019
    Send Remittance Instruction to Approval
    mx LoanIQ select    ${LIQ_RemittanceInstruction_Notebook_FileMenu_ExitMenu}        	

Complete Servicing Group Details
    [Documentation]    This keyword populates the details on IMT for UAT Deal
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}	        
    mx LoanIQ click element if present    ${RemittanceList_Window_ExitButton}
    # Add Servicing Groups Details    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]

Add Remittance Instruction to Servicing Group in UAT
    [Documentation]    This keyword adds a Remittance Instruction to Servicing Group in UAT
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}	
    Add Remittance Instruction to Servicing Group    &{ExcelPath}[RemittanceInstruction_Description]
    
Logout and Search Customer in UAT - 1st Approver
    [Documentation]    This keyword logsout and search customer in UAT
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}	             
    ###Logout and Relogin in Supervisor Level###
    mx LoanIQ click element if present    ${ServicingGroupWindow_SelectionList_OkButton}
    mx LoanIQ click element if present    ${ServicingGroupWindow_ExitButton}
    mx LoanIQ click element if present    ${RemittanceList_Window_ExitButton}    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Searching Customer
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Party_ID]  
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - First Approval
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]

Approve Remittance Instruction in UAT
    [Documentation]    This keyword logsout and search customer in UAT
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}	     
    Approving Remittance Instruction    &{ExcelPath}[RemittanceInstruction_Description]   &{ExcelPath}[Customer_Location]

Logout and Search Customer in UAT - 2nd Approver
    [Documentation]    This keyword logsout and search customer in UAT
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}	                          
    ###Logout and Relogin in Manager Level###
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Searching Customer###
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Party_ID]
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - Second Approval###
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]

Logout and Search Customer in UAT - Inputter
    [Documentation]    This keyword logsout and search customer in UAT (Inputter)
    ...    @author: fmamaril    19AUG2019
    [Arguments]    ${ExcelPath}
    ###Validate status of Customer###
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[Party_ID]
    Set Test Variable    ${SCREENSHOT_FILENAME}    UATDEAL3-Customer-SwiftRole
    Take Screenshot    ${SCREENSHOT_FILENAME}    
    ###Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
