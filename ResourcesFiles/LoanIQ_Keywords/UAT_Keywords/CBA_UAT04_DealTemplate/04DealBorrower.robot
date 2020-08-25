*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot
Resource    ../../../../Configurations/Party_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***
Search Customer and Complete its Borrower Profile Creation with default values for Deal Template Four
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values
    ...    @author: fmamaril    23AUG2019
    ...    @update: aramos      19AUG2020  Update to Add Remittance Instructions Inclusion Steps.
    [Arguments]    ${ExcelPath}
	
	# ## Login to LoanIQ###
	# Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

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
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_General
    
    ###Adding Province Details in the Legal Address
    Add Province Details in the Legal Address    None
        
    ###Navigating to SIC tab
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]

    Take Screenshot     ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_SIC
    
    # ###Navigating to Profile Tab     
 
    # ###Adding Profile          
    Add Profile under Profiles Tab    &{ExcelPath}[Profile_Type]
          
    # ###Adding Borrower Profile Details
    Add Borrower Profile Details under Profiles Tab    &{ExcelPath}[Profile_Type]
    
    # ###Validating Buttons      
    
    # ###Adding Location          
    Add Location under Profiles Tab for UAT Deal     &{ExcelPath}[Customer_Location]  
       
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
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ActiveCustomerWindow_Location
    
    ###Adding Remittance Instructions
    Add Remittance Instruction   &{ExcelPath}[LIQCustomer_ShortName]
    
Release Remittance Instruction in UAT
    [Documentation]    This keyword releases remittance instructions
    ...    @author: arammos    20AUG2020
    [Arguments]    ${ExcelPath}	
    Releasing Remittance Instruction    &{ExcelPath}[RemittanceInstruction_Description]    &{ExcelPath}[Customer_Location]


    
