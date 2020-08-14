*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

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
    Navigate to "Profiles" tab and Validate 'Add Profile' Button
    
    # # ##...Adding Profile           
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]  
    
    # # ##...Adding Beneficiary Profile Details
    Adding Beneficiary Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    # # ##...Validating Buttons 
    Validate Only 'Add Profile', 'Add Location' and 'Delete' Buttons are Enabled in Profile Tab
    
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
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    # # # ##...Approving Added Remittance Instructions    
    Approve Added Remittance Instructions    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD} 
    
    # # ##...Logout and Relogin in Manager Level
    Close All Windows on LIQ
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    # # # ##...Releasing Added Remittance Instructions
    Release Added Remittance Instructions    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Customer_Location]    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    
    # # ##...Logout and Relogin in Inputter Level
    Close All Windows on LIQ
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    # # ##...Adding Servicing Groups     
    Add Servicing Groups under Profile Tab    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]    &{ExcelPath}[Profile_Type]    &{ExcelPath}[Group_Contact]   &{ExcelPath}[Contact_LastName]   ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}
    ...    &{ExcelPath}[Customer_Location] 
    
    # # ##...Saving Customer Details
    Save Customer Details  
    
    # # # ##...Close Active Customer Window
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}
