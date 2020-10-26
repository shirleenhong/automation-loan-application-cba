*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${RemittanceInstruction_DDADescriptionAUDPrefix}    DDA1-AUD
# ${RemittanceInstruction_DDADescriptionUSDPrefix}    DDA2-USD
# ${RemittanceInstruction_SIMTDescriptionAUDPrefix}    SIMT1-AUD  
${RemittanceInstruction_SIMTDescriptionUSDPrefix}    SIMT2-USD     
# ${Taxpayer_ID} | this is commented in case these fields are needed in the future 
# ${Taxpayer_ID1}
# ${External_ID}
# ${External_ID1}

*** Keywords ***
Search Customer and Complete its Borrower Profile Creation
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation
    ...    @author: ghabal
    ...    @update: dahijara    30JUL2020    - Updated writing for Scenario 5 SERV13_InterestCapitalization from Remittance_Description to Borrower1_RemittanceDescription
    [Arguments]    ${ExcelPath}
	
	# Logout from Loan IQ
	### Login to LoanIQ ###
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
	
	##Generating LIQ Remittance Instruction Descriptions
	${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}    Generate LIQ Remittance Instruction Descriptions    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix]    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix]
	
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
 	
 	###Writing for DDA AUD Remittance Instruction Description
	Run Keyword If    '${SCENARIO}'=='3'    Write Data To Excel    SERV24_CreateCashflow    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
	
	Run Keyword If    '${SCENARIO}'=='5'    Run Keywords    Write Data To Excel    SERV13_InterestCapitalization    Borrower1_RemittanceDescription    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Remittance_Description    ${rowid}     ${RemittanceInstruction_DDADescriptionAUD}
    ...    AND    Write Data To Excel    MTAM08_LoanShareAdjustment    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
   
    ###Writing for IMT USD Remittance Instruction Description
    Run Keyword If    '${rowid}'=='5'    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    Remittance_DescriptionB1    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
       
    ###Writing for RTGS AUD Remittance Instruction Description     
    Run Keyword If    '${SCENARIO}'=='1'    Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}    
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    
    Run Keyword If    '${SCENARIO}'=='5'    Run Keywords    Write Data To Excel    SERV01A_TermAndSBLC    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV08C_ComprehensiveRepricing    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower_RemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD} 

    Run Keyword If    '${SCENARIO}'=='6'    Run Keywords    Write Data To Excel    SERV_47_FlexPISchedule    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV23_LoanPaperClip    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV18_Payments    Remittance_Description    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}

	###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    
    ###Validating Customer ID, Short Name and Legal Name Details
    ###Read Excel Data and Validate Customer ID, Short Name and Legal Name fields    &{ExcelPath}[LIQCustomer_ID]     &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[LIQCustomer_LegalName]
    
    ###Adding Customer Notice Type Method
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    
    ###Adding Expense Code Details 
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    ###Adding Department Code Details
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    # ##Adding Classification Code Details      
    # Add Classification Code Details under General tab    &{ExcelPath}[Classification_Code]    &{ExcelPath}[ClassificationCode_Description]	    
        
    # ###Unchecking "Subject to GST" checkbox
    # Uncheck "Subject to GST" checkbox
    
    # ##Adding Province Details in the Legal Address
    # Add Province Details in the Legal Address    &{ExcelPath}[Address_State]
        
    ###Navigating to SIC tab
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    ###Navigating to Profile Tab     
    Navigate to "Profiles" tab and Validate "Add Profile" Button
    
    ${Profile_Type}    Read Data From Excel    ORIG03_Customer    Profile_Type    ${rowid}
    Run Keyword If   '${SCENARIO}'=='4'    Write Data To Excel    SYND05_UpfrontFee_Payment    Borrower_Profile    ${rowid}    ${Profile_Type}
    
    Run Keyword If   '${SCENARIO}'=='6'    Run Keywords    Write Data To Excel    SERV29_PaymentFees    Borrower_Profile    ${rowid}    ${Profile_Type}
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower_Profile    ${rowid}    ${Profile_Type}   
    
    ###Adding Profile          
    Add Profile under Profiles Tab    ${Profile_Type}
          
    ###Adding Borrower Profile Details
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    ###Validating Buttons      
    Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab
    
    ###Adding Location          
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    
    ###Adding Borrowwer/Location Details
    Add Borrower/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    
    
    ###Validating Buttons if Enabled 
    Validate If All Buttons are Enabled
    
    ###Validating Legal Address Details
    ###Check Legal Address Details Under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Address_Code]    &{ExcelPath}[Address_Line1]    &{ExcelPath}[Address_Line2]    &{ExcelPath}[Address_City]    &{ExcelPath}[Address_ZipPostalCode]    &{ExcelPath}[LIQCustomer_ShortName]    
	
	###Adding Fax Details                 
    Add Fax Details under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]    
    
    ${ContactNotice_Method}    Read Data From Excel    ORIG03_Customer    ContactNotice_Method    ${rowid}
    ###Writing for Scenario 4  
    Run Keyword If   '${SCENARIO}'=='4'    Write Data To Excel    SYND05_UpfrontFee_Payment    UpfrontFeePayment_NoticeMethod    ${rowid}    ${ContactNotice_Method}
    
    ${Contact_Email}    Read Data From Excel    ORIG03_Customer    Contact_Email    ${rowid}
    ###Writing for Scenario 2
    Run Keyword If   '${SCENARIO}'=='2'    Run Keywords    Write Data To Excel    SERV01A_LoanDrawdown    Contact_Email    ${rowid}    ${Contact_Email}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Contact_Email    ${rowid}    ${Contact_Email}    
    
    ###Writing for Scenario 6
    Run Keyword If   '${SCENARIO}'=='6'    Run Keywords    Write Data To Excel    SERV_47_FlexPISchedule    Borrower1_ContactEmail    ${rowid}    ${Contact_Email}         
    ...    AND    Write Data To Excel    SERV23_LoanPaperClip    Borrower1_ContactEmail    ${rowid}    ${Contact_Email}
        
    ###Adding Contact Details
    Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]
    ...    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    ${ContactNotice_Method}    ${Contact_Email}
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]    
       
    ##Completing Location              
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ${RemittanceInstruction_DDADescriptionAUD}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}      
    ${RemittanceInstruction_IMTDescriptionUSD}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}
    ${RemittanceInstruction_RTGSDescriptionAUD}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}
    
    ###Adding Remittance Instructions
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Sleep    4s
    mx LoanIQ click    ${RemittanceInstructions_Button} 
    
    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_DDAMethod]    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[RemittanceInstruction_DDAAccountName]    &{ExcelPath}[RemittanceInstruction_DDAAccountNumber] 
    ...    &{ExcelPath}[RemittanceInstruction_DDACurrencyAUD]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    
    ...    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]   
    
    Add IMT Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_IMTMethod]    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
        
    Add RTGS Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
        
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    # Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName]    
                
    ###Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]  
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - First Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
                
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
          
    ###Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - Second Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
    
    ###Releasing Added Remittance Instructions
    Releasing Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[Customer_Location]
    Releasing Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[Customer_Location]
    Releasing Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
                  
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName]
        
    ###Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
    
    ###Adding Servicing Groups     
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ###Rechecked Added Remittance Instructions for Location if they are in 'Approved' status
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[Customer_Location]
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[Customer_Location]
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
        
    Add Servicing Groups Details    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]
    
    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_DDADescriptionAUD}    
    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_IMTDescriptionUSD}
    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_RTGSDescriptionAUD}
    
    Close Servicing Group Remittance Instructions Selection List Window    &{ExcelPath}[LIQCustomer_ShortName]
     
    mx LoanIQ click    ${ServicingGroupWindow_ExitButton}
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
        
    ###Saving Customer Details
    Save Customer Details
    
    ###Close Active Customer Window
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}

Search Customer and Complete its Borrower Profile Creation for Comprehensive Deal
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation for Comprehensive Deal
    ...    @author: ghabal
    ...    @author: gerhabal    17JULY2019    - commented the following scripts, when customer is created from Party. They are not editable when Customer is created from Party
    ...    Adding Classification Code Details    
    ...    Adding Province Details in the Legal Address        
    ...    @Update: dahijara    03SEP2020    - Added writing for SERV01_LoanDrawdown
    [Arguments]    ${ExcelPath}       
	
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

	# ###Generating LIQ Remittance Instruction Descriptions for Location 1 and 2
	Generate LIQ Remittance Instruction Descriptions for Location 1 and 2    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix]    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix]
	...        &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix2]    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix2]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix2]
	
	#Generating LIQ Remittance Instruction Descriptions for Location 1
	${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}    Generate LIQ Remittance Instruction Descriptions    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix]    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix]
	
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
	Write Data To Excel    MTAM01_ManualGL    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    2    ${RemittanceInstruction_DDADescriptionAUD}
    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    3    ${RemittanceInstruction_IMTDescriptionUSD}
	 	
	##Generating LIQ Remittance Instruction Descriptions for Location 2
	${RemittanceInstruction_DDADescriptionAUD2}    ${RemittanceInstruction_IMTDescriptionUSD2}    ${RemittanceInstruction_RTGSDescriptionAUD2}    Generate LIQ Remittance Instruction Descriptions    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix2]    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix2]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix2]
	
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD2    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD2}
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD2    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD2}
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD2    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD2}
		
	###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    
    ###Validating Customer ID, Short Name and Legal Name Details
    ###Read Excel Data and Validate Customer ID, Short Name and Legal Name fields    &{ExcelPath}[LIQCustomer_ID]     &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[LIQCustomer_LegalName]
    
    ###Adding Customer Notice Type Method
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    
    ###Adding Expense Code Details 
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    ###Adding Department Code Details
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    ###Adding Classification Code Details      
    # Add Classification Code Details under General tab    &{ExcelPath}[Classification_Code]    &{ExcelPath}[ClassificationCode_Description]	    
    
    ###Unchecking "Subject to GST" checkbox
    Uncheck "Subject to GST" checkbox
    
    ###Adding Province Details in the Legal Address
    # Add Province Details in the Legal Address    &{ExcelPath}[Address_State]
    
    ###Navigating to SIC tab
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    ###Navigating to Profile Tab     
    Navigate to "Profiles" tab and Validate "Add Profile" Button
    
    ###Adding Profile          
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    ###Adding Borrower Profile Details
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    ###Validating Buttons      
    Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab
    
    ###Adding Location 1
    Add and Complete Location, Fax and Contact Details    &{ExcelPath}[Customer_Location]     &{ExcelPath}[Profile_Type]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    
    ...    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]
     
    ${RemittanceInstruction_DDADescriptionAUD}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}      
    ${RemittanceInstruction_IMTDescriptionUSD}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}
    ${RemittanceInstruction_RTGSDescriptionAUD}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}   
   
    ###Adding Remittance Instructions for Location 1
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Sleep    4s
    mx LoanIQ click    ${RemittanceInstructions_Button} 
    
    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_DDAMethod]    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[RemittanceInstruction_DDAAccountName]    &{ExcelPath}[RemittanceInstruction_DDAAccountNumber] 
    ...    &{ExcelPath}[RemittanceInstruction_DDACurrencyAUD]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    
    ...    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]   
    
    Add IMT Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_IMTMethod]    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
        
    Add RTGS Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
        
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    ###Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName]    
     
    ###Adding Location 2
    Add and Complete Location, Fax and Contact Details    &{ExcelPath}[Customer_Location2]     &{ExcelPath}[Profile_Type]    &{ExcelPath}[Fax_Number2]    &{ExcelPath}[Fax_Description2]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName2]    
    ...    &{ExcelPath}[Contact_LastName2]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone2]    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email2]
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]
    
    ${RemittanceInstruction_DDADescriptionAUD2}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD2    ${rowid}      
    ${RemittanceInstruction_IMTDescriptionUSD2}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD2    ${rowid}
    ${RemittanceInstruction_RTGSDescriptionAUD2}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD2    ${rowid}   
    
    ###Adding Remittance Instructions for Location 2
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Sleep    4s
    mx LoanIQ click    ${RemittanceInstructions_Button} 
    
    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location2]    &{ExcelPath}[RemittanceInstruction_DDAMethod]    ${RemittanceInstruction_DDADescriptionAUD2}    &{ExcelPath}[RemittanceInstruction_DDAAccountName]    &{ExcelPath}[RemittanceInstruction_DDAAccountNumber] 
    ...    &{ExcelPath}[RemittanceInstruction_DDACurrencyAUD]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    
    ...    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]   
    
    Add IMT Remittance Instruction    &{ExcelPath}[Customer_Location2]    &{ExcelPath}[RemittanceInstruction_IMTMethod]    ${RemittanceInstruction_IMTDescriptionUSD2}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
        
    Add RTGS Remittance Instruction    &{ExcelPath}[Customer_Location2]    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    ${RemittanceInstruction_RTGSDescriptionAUD2}    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
        
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    ###Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName]   
    
    ###Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
      
    ###Approving Added Remittance Instructions - Location 1 - First Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
                
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
    
    ###Approving Added Remittance Instructions - Location 2 - First Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location2]
    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD2}   &{ExcelPath}[Customer_Location2]
    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD2}   &{ExcelPath}[Customer_Location2]
    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD2}    &{ExcelPath}[Customer_Location2]
                
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
    
    ###Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ##Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - Location 1 - Second Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
                
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
    
    ###Approving Added Remittance Instructions - Location 2 - Second Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location2]
    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD2}   &{ExcelPath}[Customer_Location2]
    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD2}   &{ExcelPath}[Customer_Location2]
    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD2}    &{ExcelPath}[Customer_Location2]
                
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
    
    #Releasing Added Remittance Instructions
    Release Added Remittance Instructions for Location 1 and 2    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    
    ...    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    ${RemittanceInstruction_DDADescriptionAUD2}    ${RemittanceInstruction_IMTDescriptionUSD2}    ${RemittanceInstruction_RTGSDescriptionAUD2}    &{ExcelPath}[Customer_Location2] 
            
    #Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
    
    ###Adding Servicing Groups     
    Add Servicing Groups under Profile Tab for Location 1 and 2    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]  
    ...    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    ${RemittanceInstruction_DDADescriptionAUD2}    ${RemittanceInstruction_IMTDescriptionUSD2}    ${RemittanceInstruction_RTGSDescriptionAUD2}    
    ...    &{ExcelPath}[Group_Contact2]    &{ExcelPath}[Contact_LastName2]    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Customer_Location2] 
    
    ###Saving Customer Details
    Save Customer Details
    
    ##Close Active Customer Window
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}
    
Search Customer and Complete its Borrower Profile Creation with default values
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values
    ...    @author: fmamaril
    ...    @update: hstone     04MAY2020    - Updated 'Add Classification Code Details under General tab' Arguments to take Excel Data Values
    ...    @update: dahijara    07JUL2020    - added writing in SERV23_LoanPaperClip for Borrower1_RTGSRemittanceDescription
    ...    @update: dahijara    08JUL2020    - added writing for scenario 6 - SERV29_PaymentFees-Borrower1_ContactEmail
    ...    @update: makcamps    08OCT2020    - Deleted click ServicingGroupWindow_ExitButton before Validate Active Window Customer method because
    ...                                        Servicing Group Window is closed in Close Servicing Group Remittance Instructions Selection List Window method
    ...    @update: fjluberio    10OCT2020    -added Entity conditions for EU when adding remittance instruction
    ...    @update: makcamps    09OCT2020    - Added write data to excel method for Deal and Facility Setup data
    ...    @update: makcamps    15OCT2020    - Added write data to excel method for Scenario 1 and EU Initial Loan Creation
	...    @update: makcamps    22OCT2020    - Updated write data to excel method for Scenario 1 and EU SERV29
    [Arguments]    ${ExcelPath}
	
	## Login to LoanIQ###
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
	
	#${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}    Generate LIQ Remittance Instruction Descriptions    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix]    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix]
	
	${RemittanceInstruction_DDADescriptionAUD}    Auto Generate Only 4 Numeric Test Data    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix]    
    log    LIQ Customer DDA AUD Remittance Instruction Description: ${RemittanceInstruction_DDADescriptionAUD}

    ${RemittanceInstruction_IMTDescriptionUSD}    Auto Generate Only 4 Numeric Test Data    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix]  
    log    LIQ Customer IMT USD Remittance Instruction Description: ${RemittanceInstruction_IMTDescriptionUSD}
    
    ${RemittanceInstruction_RTGSDescriptionAUD}    Auto Generate Only 4 Numeric Test Data    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix]
    Log    LIQ Customer RTGS AUD Remittance Instruction Description: ${RemittanceInstruction_RTGSDescriptionAUD}
	
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
	Write Data To Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
	
    Write Data To Excel    CRED01_DealSetup    Borrower_SG_GroupMembers    ${rowid}    &{ExcelPath}[Contact_FullName]
    Write Data To Excel    CRED01_DealSetup    Borrower_SG_Alias    ${rowid}    &{ExcelPath}[Contact_Initials]
    Write Data To Excel    CRED01_DealSetup    Borrower_SG_Name    ${rowid}    &{ExcelPath}[Group_Contact]
    Write Data To Excel    CRED01_DealSetup    Borrower1_ShortName    ${rowid}   &{ExcelPath}[LIQCustomer_ShortName]
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    &{ExcelPath}[LIQCustomer_ShortName]
    Write Data To Excel    CRED02_FacilitySetup    Facility_BorrowerSGName    ${rowid}    &{ExcelPath}[Group_Contact]
	
	Write Remittance Description    ${SCENARIO}    &{ExcelPath}[Remittance_Instruction]    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}

	###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    
    ###Validating Customer ID, Short Name and Legal Name Details
    ###Read Excel Data and Validate Customer ID, Short Name and Legal Name fields    &{ExcelPath}[LIQCustomer_ID]     &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[LIQCustomer_LegalName]
    
    ###Adding Customer Notice Type Method
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]

    ###Adding Expense Code Details 
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    ###Adding Department Code Details
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]    

    Run Keyword If    '&{ExcelPath}[Entity]' == 'AU'    Uncheck "Subject to GST" checkbox

    Run Keyword If    '&{ExcelPath}[CustomerSourceApp]' == 'LIQ'    Run Keywords    Add Classification Code Details under General tab    &{ExcelPath}[Classification_Code]    &{ExcelPath}[ClassificationCode_Description]
    ...    AND    Add Province Details in the Legal Address    None
    ...    AND    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    ###Navigating to Profile Tab     
    Navigate to "Profiles" tab and Validate "Add Profile" Button
    
    ${Profile_Type}    Read Data From Excel    ORIG03_Customer    Profile_Type    ${rowid}

    ###Adding Profile          
    Add Profile under Profiles Tab    ${Profile_Type}
          
    ###Adding Borrower Profile Details
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    ###Validating Buttons      
    Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab
    
    ###Adding Location          
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    
    ###Adding Borrowwer/Location Details
    Add Borrower/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    
    
    ###Validating Buttons if Enabled 
    Validate If All Buttons are Enabled
    
    ###Validating Legal Address Details
    ###Check Legal Address Details Under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Address_Code]    &{ExcelPath}[Address_Line1]    &{ExcelPath}[Address_Line2]    &{ExcelPath}[Address_City]    &{ExcelPath}[Address_ZipPostalCode]    &{ExcelPath}[LIQCustomer_ShortName]    
	
	###Adding Fax Details                 
    Add Fax Details under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]    
  
    ##Writing for Scenario 1
    Run Keyword If   '${SCENARIO}'=='1'    Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Contact_Email    ${rowid}    &{ExcelPath}[Contact_Email]
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Borrower1_LegalName    ${rowid}    &{ExcelPath}[LIQCustomer_LegalName]     
    ...    AND    Write Data To Excel    SERV18_Payments    Contact_Email    ${rowid}    &{ExcelPath}[Contact_Email]       
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower_ContactEmail    ${rowid}    &{ExcelPath}[Contact_Email]       
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Contact_Email    ${rowid}    &{ExcelPath}[Contact_Email]
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Contact_Email    ${rowid}    &{ExcelPath}[Contact_Email]    
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower_Contact    ${rowid}    &{ExcelPath}[Contact_FirstName] &{ExcelPath}[Contact_LastName]
        
    ###Writing for Scenario 2
    Run Keyword If   '${SCENARIO}'=='2'    Run Keywords    Write Data To Excel    SERV01A_LoanDrawdown    Contact_Email    ${rowid}    &{ExcelPath}[Contact_Email]
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Contact_Email    ${rowid}    &{ExcelPath}[Contact_Email]    
    
    ##Writing for Scenario 6
    Run Keyword If   '${SCENARIO}'=='6'    Run Keywords    Write Data To Excel    MTAM05B_CycleShareAdjustment    Contact_Email    ${rowid}    &{ExcelPath}[Contact_Email]
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower_Email    ${rowid}    &{ExcelPath}[Contact_Email]
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Contact_Email    ${rowid}    &{ExcelPath}[Contact_Email]           
    ...    AND    Write Data To Excel    SERV23_LoanPaperClip    Borrower_ContactEmail    ${rowid}    &{ExcelPath}[Contact_Email]
    ...    AND    Write Data To Excel    SERV23_LoanPaperClip    Borrower1_RTGSRemittanceDescription    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_ContactEmail    ${rowid}    &{ExcelPath}[Contact_Email]
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_ContactEmail    2    &{ExcelPath}[Contact_Email]
        
    
    Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]
    ...    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]    
       
    ##Completing Location              
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ${RemittanceInstruction_DDADescriptionAUD}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}      
    ${RemittanceInstruction_IMTDescriptionUSD}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}
    ${RemittanceInstruction_RTGSDescriptionAUD}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}
    
    ###Adding Remittance Instructions
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Sleep    4s
    mx LoanIQ click    ${RemittanceInstructions_Button} 
    
    Run Keyword If    '&{ExcelPath}[Entity]' == 'AU'    Run Keywords    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_DDAMethod]    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[RemittanceInstruction_DDAAccountName]    &{ExcelPath}[RemittanceInstruction_DDAAccountNumber] 
    ...    &{ExcelPath}[RemittanceInstruction_DDACurrencyAUD]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    
    ...    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]   
    ...    AND    Add IMT Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_IMTMethod]    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
    ...    AND    Add RTGS Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
    ...    ELSE IF    '&{ExcelPath}[Entity]' == 'EU'    Add IMT Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_IMTMethod]    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
        
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    # Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName]    
                
    ###Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]  
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - First Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Run Keyword If    '&{ExcelPath}[Entity]' == 'AU'    Run Keywords    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}   &{ExcelPath}[Customer_Location]
    ...    AND    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
    ...    AND    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
 
    Run Keyword If    '&{ExcelPath}[Entity]' == 'EU'    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
                
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
          
    ##Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - Second Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Run Keyword If    '&{ExcelPath}[Entity]' == 'AU'    Run Keywords    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}   &{ExcelPath}[Customer_Location]
    ...    AND    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
    ...    AND    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
    ...    ELSE IF    '&{ExcelPath}[Entity]' == 'EU'    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
    
    ###Releasing Added Remittance Instructions
    Run Keyword If    '&{ExcelPath}[Entity]' == 'AU'    Run Keywords    Releasing Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[Customer_Location]
    ...    AND    Releasing Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[Customer_Location]
    ...    AND    Releasing Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
    ...    ELSE IF    '&{ExcelPath}[Entity]' == 'EU'    Releasing Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[Customer_Location]
                  
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName]
        
    ###Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
    
    ###Adding Servicing Groups     
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ###Rechecked Added Remittance Instructions for Location if they are in 'Approved' status
    Run Keyword If    '&{ExcelPath}[Entity]' == 'AU'    Run Keywords    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[Customer_Location]
    ...    AND    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[Customer_Location]
    ...    AND    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
    ...    ELSE IF    '&{ExcelPath}[Entity]' == 'EU'     Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[Customer_Location]
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
        
    Add Servicing Groups Details    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]
    
    Run Keyword If    '&{ExcelPath}[Entity]' == 'AU'    Run Keywords    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_DDADescriptionAUD}   
    ...    AND    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    ELSE IF    '&{ExcelPath}[Entity]' == 'EU'    Run Keywords    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_IMTDescriptionUSD}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Description    ${rowid}    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSD]
    ...    AND    Write Data To Excel    SERV18_Payments    Borrower1_RTGSRemittanceDescription    ${rowid}    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSD]
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Borrower1_RTGSRemittanceDescription    ${rowid}    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSD]
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceInstruction    ${rowid}    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSD]
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Instruction    ${rowid}    &{ExcelPath}[Remittance_Instruction]
    ...    AND    Write Data To Excel    SERV18_Payments    Remittance_Instruction    ${rowid}    &{ExcelPath}[Remittance_Instruction]
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Remittance_Instruction    ${rowid}    &{ExcelPath}[Remittance_Instruction]    
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Borrower1_RTGSRemittanceDescription    ${rowid}    &{ExcelPath}[Remittance_Instruction]
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Currency    ${rowid}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_Currency    ${rowid}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    AND    Write Data To Excel    SERV18_Payments    Loan_Currency    ${rowid}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Loan_Currency    ${rowid}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Loan_Currency    ${rowid}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    Close Servicing Group Remittance Instructions Selection List Window    &{ExcelPath}[LIQCustomer_ShortName]
     
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
        
    ###Saving Customer Details
    Save Customer Details
    
    ###Close Active Customer Window
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}
    
Search Customer and Complete its Beneficiary Profile Creation
    [Documentation]    This keyword searches a customer and complete its Beneficiary Profile creation
    ...    @author: ghabal
    # ##... Mx Launch UFT    Visibility=True    UFTAddins=Java    Processtimeout=200
    # ##... Mx LoanIQ Launch    Processtimeout=300
     
    [Arguments]    ${ExcelPath}       
    # Mx Set Global Timeout    5
    
    # # ##...Generating LIQ Remittance Instruction Descriptions
	Generate LIQ Remittance Instruction Descriptions_TDP    ${rowid}    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix]    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix]      
    
    # # ##...Searching Customer    
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    
    # ##...Validating Customer ID, Short Name and Legal Name Details  
    Read Excel Data and Validate Customer ID, Short Name and Legal Name fields    &{ExcelPath}[LIQCustomer_ID]     &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[LIQCustomer_LegalName]
    
    # # ##...Adding Expense Code Details  
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    # # ##...Adding Department Code Details
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    # # ##...Adding Classification Code Details       
    Add Classification Code Details under General tab    &{ExcelPath}[Classification_Code]    &{ExcelPath}[ClassificationCode_Description]	    
    
    # # ##...Unchecking "Subject to GST" checkbox
    Uncheck "Subject to GST" checkbox
    
    # # ##...Adding Province Details in the Legal Address
    Add Province Details in the Legal Address    &{ExcelPath}[Address_State]
    
    # # ##...Navigating to SIC tab
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    # # ##...Navigating to Profile Tab         
    Navigate to "Profiles" tab and Validate "Add Profile" Button
    
    # # ##...Adding Profile           
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]  
    
    # # ##...Adding Beneficiary Profile Details
    Adding Beneficiary Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    # # ##...Validating Buttons 
    Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab
    
    # # ##...Adding Location                 
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    
    # # ##...Adding Beneficiary/Location Details
    Adding Beneficiary/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    # # ##...Validating Buttons if Enabled   
    Validate If All Buttons are Enabled
    
    # ##...Validating Legal Address Details
    Check Legal Address Details Under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Address_Code]    &{ExcelPath}[Address_Line1]    &{ExcelPath}[Address_Line2]    &{ExcelPath}[Address_City]    &{ExcelPath}[Address_ZipPostalCode]    &{ExcelPath}[LIQCustomer_ShortName]    
	
	# # ##...Adding Fax Details                   
    Add Fax Details under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]    
    
    # ### Gerald to update the keyword to handle 15 arguments
    # # # ##...Adding Contact Details
    # Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    
    # # ##...Completing Location                  
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
        
    ${RemittanceInstruction_DDADescriptionAUD}    Read Data From Excel    TDP_ORIG03Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}      
    ${RemittanceInstruction_IMTDescriptionUSD}    Read Data From Excel    TDP_ORIG03Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}
    ${RemittanceInstruction_RTGSDescriptionAUD}    Read Data From Excel    TDP_ORIG03Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}
    
    # # ##...Adding Remittance Instructions
    Add DDA/IMT/RTGS Remittance Instructions    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_DDAMethod]   ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[RemittanceInstruction_DDAAccountName]    &{ExcelPath}[RemittanceInstruction_DDAAccountNumber]    &{ExcelPath}[RemittanceInstruction_DDACurrencyAUD]    
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[RemittanceInstruction_IMTMethod]   &{ExcelPath}[LIQCustomer_ShortName]    ${RemittanceInstruction_IMTDescriptionUSD} 	&{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]    
    ...    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]     
    
    # ##...Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    # # # ##...Approving Added Remittance Instructions    
    Approve Added Remittance Instructions    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD} 
    
    # # ##...Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    # # # ##...Releasing Added Remittance Instructions
    Release Added Remittance Instructions    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    
    # # ##...Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    # # ##...Adding Servicing Groups     
    Add Servicing Groups under Profile Tab    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]   ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    &{ExcelPath}[Customer_Location] 
    
    # # ##...Saving Customer Details
    Save Customer Details  
    
    # # # ##...Close Active Customer Window
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}

Search Customer and Complete its Guarantor Profile Creation
    [Documentation]    This keyword searches a customer and complete its Guarantor Profile creation
    ...    @author: ghabal
    # ##... Mx Launch UFT    Visibility=True    UFTAddins=Java    Processtimeout=200
    # ##... Mx LoanIQ Launch    Processtimeout=300
     
    [Arguments]    ${ExcelPath}       
# Mx Set Global Timeout    5
    
    # # ##...Generating LIQ Remittance Instruction Descriptions
	Generate LIQ Remittance Instruction Descriptions_TDP    ${rowid}    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix]    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix]      
    
    # # ##...Searching Customer    
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    
    # ##...Validating Customer ID, Short Name and Legal Name Details  
    Read Excel Data and Validate Customer ID, Short Name and Legal Name fields    &{ExcelPath}[LIQCustomer_ID]     &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[LIQCustomer_LegalName]
    
    # # ##...Adding Expense Code Details  
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    # # ##...Adding Department Code Details
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    # # ##...Adding Classification Code Details       
    Add Classification Code Details under General tab    &{ExcelPath}[Classification_Code]    &{ExcelPath}[ClassificationCode_Description]	    
    
    # # ##...Unchecking "Subject to GST" checkbox
    Uncheck "Subject to GST" checkbox
    
    # # ##...Adding Province Details in the Legal Address
    Add Province Details in the Legal Address    &{ExcelPath}[Address_State]
    
    # # ##...Navigating to SIC tab
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    # # ##...Navigating to Profile Tab         
    Navigate to "Profiles" tab and Validate "Add Profile" Button
                 
    # # ##...Adding Profile           
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]  
    
    # # ##...Adding Guarantor Profile Details
    Adding Guarantor Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
      
   # # ##...Validating Buttons 
    Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab
    
    # # ##...Adding Location                 
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    
    # # ##...Adding Guarantor/Location Details             
    Adding Guarantor/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
       
     # # ##...Validating Buttons if Enabled   
    Validate If All Buttons are Enabled
    
    # ##...Validating Legal Address Details
    Check Legal Address Details Under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Address_Code]    &{ExcelPath}[Address_Line1]    &{ExcelPath}[Address_Line2]    &{ExcelPath}[Address_City]    &{ExcelPath}[Address_ZipPostalCode]    &{ExcelPath}[LIQCustomer_ShortName]    
	                   
    # # ##...Adding Fax Details                   
    Add Fax Details under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]    
    
    # ### Gerald to update the keyword to handle 15 arguments
    # # ##...Adding Contact Details
    # Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    
    # # ##...Completing Location                  
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
        
    ${RemittanceInstruction_DDADescriptionAUD}    Read Data From Excel    TDP_ORIG03Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}      
    ${RemittanceInstruction_IMTDescriptionUSD}    Read Data From Excel    TDP_ORIG03Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}
    ${RemittanceInstruction_RTGSDescriptionAUD}    Read Data From Excel    TDP_ORIG03Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}
    
    # # ##...Adding Remittance Instructions
    Add DDA/IMT/RTGS Remittance Instructions    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_DDAMethod]   ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[RemittanceInstruction_DDAAccountName]    &{ExcelPath}[RemittanceInstruction_DDAAccountNumber]    &{ExcelPath}[RemittanceInstruction_DDACurrencyAUD]    
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[RemittanceInstruction_IMTMethod]   &{ExcelPath}[LIQCustomer_ShortName]    ${RemittanceInstruction_IMTDescriptionUSD} 	&{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]    
    ...    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]     
    
    # ##...Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    # # # ##...Approving Added Remittance Instructions    
    Approve Added Remittance Instructions    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD} 
    
    # # ##...Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    # # # ##...Releasing Added Remittance Instructions
    Release Added Remittance Instructions    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    
    # # ##...Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    # # ##...Adding Servicing Groups     
    Add Servicing Groups under Profile Tab    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]   ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    &{ExcelPath}[Customer_Location] 
    
    # # ##...Saving Customer Details
    Save Customer Details  
    
    # # # ##...Close Active Customer Window
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}
    
Search Customer and Complete its Lender Profile Creation
    [Documentation]    This keyword searches a customer and complete its Lender Profile creation
    ...    @author: ghabal
    ...    @update: ghabal    21MAR2019    - Updated based from latest keywords from Borrower Profile creation
    [Arguments]    ${ExcelPath}          
          
    ###Generating LIQ Remittance Instruction Descriptions
	${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}    Generate LIQ Remittance Instruction Descriptions    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix]    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix]    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix]
	
	Write Data To Excel    TDP_ORIG03Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}
	Write Data To Excel    TDP_ORIG03Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}
	Write Data To Excel    TDP_ORIG03Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}
 	
 	###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    
    ###Validating Customer ID, Short Name and Legal Name Details
    ###Read Excel Data and Validate Customer ID, Short Name and Legal Name fields    &{ExcelPath}[LIQCustomer_ID]     &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[LIQCustomer_LegalName]
    
    ###Adding Customer Notice Type Method
    Select Customer Notice Type Method    &{ExcelPath}[CustomerNotice_TypeMethod]
    
    ###Adding Expense Code Details 
    Add Expense Code Details under General tab    &{ExcelPath}[Expense_Code]
    
    ###Adding Department Code Details
    Add Department Code Details under General tab    &{ExcelPath}[Deparment_Code]
    
    ###Adding Classification Code Details      
    Add Classification Code Details under General tab    &{ExcelPath}[Classification_Code]    &{ExcelPath}[ClassificationCode_Description]	    
    
    ###Unchecking "Subject to GST" checkbox
    Uncheck "Subject to GST" checkbox
    
    ##Adding Province Details in the Legal Address
    Add Province Details in the Legal Address    &{ExcelPath}[Address_State]
        
    ###Navigating to SIC tab
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    ###Navigating to Profile Tab     
    Navigate to "Profiles" tab and Validate "Add Profile" Button
    
    ${Profile_Type}    Read Data From Excel    TDP_ORIG03Customer    Profile_Type    ${rowid}
    Run Keyword If   '${SCENARIO}'=='4'    Write Data To Excel    SYND05_UpfrontFee_Payment    Borrower_Profile    ${rowid}    ${Profile_Type}
    
    ###Adding Profile          
    Add Profile under Profiles Tab    ${Profile_Type}  
    
    Adding Lender Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
        
    Validate Only "Add Profile" and "Add Location" and "Delete" Buttons are Enabled in Profile Tab
              
    Add Location under Profiles Tab    &{ExcelPath}[Customer_Location]  
    
    Adding Lender/Location Details under Profiles Tab   &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
       
    Validate If All Buttons are Enabled
    
    ###Check Legal Address Details Under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Address_Code]    &{ExcelPath}[Address_Line1]    &{ExcelPath}[Address_Line2]    &{ExcelPath}[Address_City]    &{ExcelPath}[Address_ZipPostalCode]    &{ExcelPath}[LIQCustomer_ShortName]    
	                 
    ###Adding Fax Details                   
    Add Fax Details under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]    
    
    ###Adding Contact Details
    Add Contact under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Contact_FirstName]    &{ExcelPath}[Contact_LastName]    &{ExcelPath}[Contact_PreferredLanguage]    &{ExcelPath}[Contact_PrimaryPhone]
    ...    &{ExcelPath}[BorrowerContact_Phone]    &{ExcelPath}[Contact_PurposeType]    &{ExcelPath}[ContactNotice_Method]    &{ExcelPath}[Contact_Email]
    ...    &{ExcelPath}[ProductSBLC_Checkbox]    &{ExcelPath}[ProductLoan_Checkbox]    &{ExcelPath}[BalanceType_Principal_Checkbox]
    ...    &{ExcelPath}[BalanceType_Interest_Checkbox]    &{ExcelPath}[BalanceType_Fees_Checkbox]    &{ExcelPath}[Address_Code]    
        
    ###Completing Location                  
    Complete Location under Profile Tab    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
        
    ${RemittanceInstruction_DDADescriptionAUD}    Read Data From Excel    TDP_ORIG03Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}      
    ${RemittanceInstruction_IMTDescriptionUSD}    Read Data From Excel    TDP_ORIG03Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}
    ${RemittanceInstruction_RTGSDescriptionAUD}    Read Data From Excel    TDP_ORIG03Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}
    
    ###Adding Remittance Instructions
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Sleep    4s
    mx LoanIQ click    ${RemittanceInstructions_Button} 
    
    Add DDA Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_DDAMethod]    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[RemittanceInstruction_DDAAccountName]    &{ExcelPath}[RemittanceInstruction_DDAAccountNumber] 
    ...    &{ExcelPath}[RemittanceInstruction_DDACurrencyAUD]    &{ExcelPath}[RI_ProductLoan_Checkbox]    &{ExcelPath}[RI_ProductSBLC_Checkbox]    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_ToCust_Checkbox]    &{ExcelPath}[RI_BalanceType_Principal_Checkbox]    
    ...    &{ExcelPath}[RI_BalanceType_Interest_Checkbox]    &{ExcelPath}[RI_BalanceType_Fees_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]   
    
    Add IMT Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_IMTMethod]    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[RemittanceInstruction_IMTCurrencyUSD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
        
    Add RTGS Remittance Instruction    &{ExcelPath}[Customer_Location]    &{ExcelPath}[RemittanceInstruction_RTGSMethod]    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[RemittanceInstruction_RTGSCurrencyAUD]
    ...    &{ExcelPath}[RemittanceInstruction_DirectionSelected]    &{ExcelPath}[IMT_MessageCode]    &{ExcelPath}[BOC_Level]    
    ...    &{ExcelPath}[RI_FromCust_Checkbox]    &{ExcelPath}[RI_AutoDoIt_Checkbox]    &{ExcelPath}[RI_SendersCorrespondent_Checkbox]
        
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    ###Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName]    
                
    ###Logout and Relogin in Supervisor Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]  
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - First Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
                
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
          
    ###Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
    
    ###Approving Added Remittance Instructions - Second Approval   
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}   &{ExcelPath}[Customer_Location]
    Approving Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
    
    ###Releasing Added Remittance Instructions
    Releasing Remittance Instruction    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[Customer_Location]
    Releasing Remittance Instruction    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[Customer_Location]
    Releasing Remittance Instruction    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
                  
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
    Sleep    4s
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName]
        
    ###Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Searching Customer 	
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]
    Switch Customer Notebook to Update Mode
    
    ###Adding Servicing Groups     
    Access Remittance List upon Login    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]
    
    ###Rechecked Added Remittance Instructions for Location if they are in 'Approved' status
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_DDADescriptionAUD}    &{ExcelPath}[Customer_Location]
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_IMTDescriptionUSD}    &{ExcelPath}[Customer_Location]
    Read Excel Data and Validate Remittance Instructions Data Added in the Remittance List Window    ${RemittanceInstruction_RTGSDescriptionAUD}    &{ExcelPath}[Customer_Location]
    mx LoanIQ click    ${RemittanceList_Window_ExitButton}
        
    Add Servicing Groups Details    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]
    
    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_DDADescriptionAUD}    
    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_IMTDescriptionUSD}
    Add Remittance Instruction to Servicing Group    ${RemittanceInstruction_RTGSDescriptionAUD}
    
    Close Servicing Group Remittance Instructions Selection List Window    &{ExcelPath}[LIQCustomer_ShortName]
     
    mx LoanIQ click    ${ServicingGroupWindow_ExitButton}
    Validate 'Active Customer' Window    &{ExcelPath}[LIQCustomer_ShortName] 
        
    ###Saving Customer Details
    Save Customer Details
    
    ###Close Active Customer Window
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}