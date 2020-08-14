*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Variables ***                     
# ${Taxpayer_ID} | this is commented in case these fields are needed in the future 
# ${Taxpayer_ID1}
# ${External_ID}
# ${External_ID1}

*** Keywords ***
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
    Navigate to "Profiles" tab and Validate 'Add Profile' Button
    
    ${Profile_Type}    Read Data From Excel    TDP_ORIG03Customer    Profile_Type    ${rowid}
    Run Keyword If   '${SCENARIO}'=='4'    Write Data To Excel    SYND05_UpfrontFee_Payment    Borrower_Profile    ${rowid}    ${Profile_Type}
    
    ###Adding Profile          
    Add Profile under Profiles Tab    ${Profile_Type}  
    
    Adding Lender Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
        
    Validate Only 'Add Profile', 'Add Location' and 'Delete' Buttons are Enabled in Profile Tab
              
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
    Logout from LIQ
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
    Logout from LIQ
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
    Logout from LIQ
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
        
    Add Servicing Groups Details    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]
    
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
    
