*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Create Customer within Loan IQ for DNR
    [Documentation]    This keyword creates Customer within LoanIQ.
    ...    @author: clanding    04DEC2020    - initial create.
    [Arguments]    ${ExcelPath}

    ### Login to LoanIQ###
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ${LIQCustomer_ShortName}    ${LIQCustomer_LegalName}    Generate LIQ Customer ShortName and Legal Name and Save it to Excel     &{ExcelPath}[LIQCustomerShortName_Prefix]    &{ExcelPath}[LIQCustomerLegalName_Prefix]    ${rowid}   
    Write Data To Excel    SC1_Customer    LIQCustomer_ShortName    ${rowid}    ${LIQCustomer_ShortName}    ${DNR_DATASET}
    Write Data To Excel    SC1_Customer    LIQCustomer_LegalName    ${rowid}    ${LIQCustomer_LegalName}    ${DNR_DATASET}

    Create New Customer   
    
    ${LIQCustomer_ID}    Get Customer ID and Save it to Excel 
    Write Data To Excel    SC1_Customer    LIQCustomer_ID    ${rowid}    ${LIQCustomer_ID}    ${DNR_DATASET}
    
    ${LIQCustomer_ShortName}    Read Data From Excel    SC1_Customer    LIQCustomer_ShortName    ${rowid}    ${DNR_DATASET}
    ${LIQCustomer_LegalName}    Read Data From Excel    SC1_Customer    LIQCustomer_LegalName    ${rowid}    ${DNR_DATASET}         
    Create Customer and Enter Customer ShortName and Legal Name    ${LIQCustomer_ShortName}    ${LIQCustomer_LegalName}    
    Sleep    5s
    
    Add Customer Legal Address Details    &{ExcelPath}[Address_Line1]    &{ExcelPath}[Address_Line2]    &{ExcelPath}[Address_City]    &{ExcelPath}[Address_Country]    &{ExcelPath}[Address_TRA]    &{ExcelPath}[Address_State]    &{ExcelPath}[Address_ZipPostalCode]
    Assign Primary SIC Code    &{ExcelPath}[Primary_SICCode]
    Save Customer Details
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}

Search Customer and Complete its Borrower Profile Creation Until Location for DNR
    [Documentation]    This keyword searches a customer and complete its Borrower Profile creation with default values.
    ...    @author: clanding    04DEC2020    initial create
    [Arguments]    ${ExcelPath}
	
	${RemittanceInstruction_DDADescriptionAUD}    Auto Generate Only 4 Numeric Test Data    &{ExcelPath}[RemittanceInstruction_DDADescriptionAUDPrefix]    
    Log    LIQ Customer DDA AUD Remittance Instruction Description: ${RemittanceInstruction_DDADescriptionAUD}

    ${RemittanceInstruction_IMTDescriptionUSD}    Auto Generate Only 4 Numeric Test Data    &{ExcelPath}[RemittanceInstruction_IMTDescriptionUSDPrefix]  
    Log    LIQ Customer IMT USD Remittance Instruction Description: ${RemittanceInstruction_IMTDescriptionUSD}
    
    ${RemittanceInstruction_RTGSDescriptionAUD}    Auto Generate Only 4 Numeric Test Data    &{ExcelPath}[RemittanceInstruction_RTGSDescriptionAUDPrefix]
    Log    LIQ Customer RTGS AUD Remittance Instruction Description: ${RemittanceInstruction_RTGSDescriptionAUD}
	
	Write Data To Excel    SC1_Customer    RemittanceInstruction_DDADescriptionAUD    ${rowid}    ${RemittanceInstruction_DDADescriptionAUD}    ${DNR_DATASET}
	Write Data To Excel    SC1_Customer    RemittanceInstruction_IMTDescriptionUSD    ${rowid}    ${RemittanceInstruction_IMTDescriptionUSD}    ${DNR_DATASET}
	Write Data To Excel    SC1_Customer    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}    ${RemittanceInstruction_RTGSDescriptionAUD}    ${DNR_DATASET}

	Write Remittance Description    ${SCENARIO}    &{ExcelPath}[Remittance_Instruction]    ${RemittanceInstruction_DDADescriptionAUD}    ${RemittanceInstruction_IMTDescriptionUSD}    ${RemittanceInstruction_RTGSDescriptionAUD}

    Log    ${SCENARIO}	
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

    Uncheck "Subject to GST" checkbox

    Add Classification Code Details under General tab    &{ExcelPath}[Classification_Code]    &{ExcelPath}[ClassificationCode_Description]
    Add Province Details in the Legal Address    None
    Navigate to "SIC" tab and Validate Primary SIC Code    &{ExcelPath}[Primary_SICCode]    &{ExcelPath}[PrimarySICCode_Description]
    
    ###Navigating to Profile Tab     
    Navigate to "Profiles" tab and Validate "Add Profile" Button
    
    ${Profile_Type}    Read Data From Excel    SC1_Customer    Profile_Type    ${rowid}    ${DNR_DATASET}
    Set To Dictionary    ${ExcelPath}    Profile_Type=${Profile_Type}

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
    
	###Adding Fax Details                 
    Add Fax Details under Profiles Tab    &{ExcelPath}[Customer_Location]    &{ExcelPath}[Fax_Number]    &{ExcelPath}[Fax_Description]

    Close All Windows on LIQ
    Logout from Loan IQ

Add Comments in Customer for DNR
    [Documentation]    This keyword is used to add comments in active customer.
    ...    @author: clanding    04DEC2020    - initial create.
    [Arguments]    ${ExcelPath}

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    ${Status_UI}    Get Profile Status from Profiles Tab    &{ExcelPath}[Profile_Type]
    Compare Two Strings    Not In Use    ${Status_UI}
    ${Comment_Details}    ${Comment_DateWithTime}    Add Details in Comments Tab in Active Customer    &{ExcelPath}[Comments_Subject]    &{ExcelPath}[Comments_Prefix]
    Write Data To Excel    SC1_PrimaryAllocation    User_ID    ${rowid}    ${INPUTTER_USERNAME}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Comments_DateAddedAmended    ${rowid}    ${Comment_DateWithTime}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Comments_Details    ${rowid}    ${Comment_Details}    ${DNR_DATASET}

    ### Writing for Comments Report ###
    Write Data To Excel    CMMNT    Customer_Name    CMMNT_010    &{ExcelPath}[LIQCustomer_LegalName]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    CIF_Number    CMMNT_010    &{ExcelPath}[LIQCustomer_ID]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Heading    CMMNT_010    &{ExcelPath}[Comments_Subject]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Detail    CMMNT_010    ${Comment_Details}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    User_ID    CMMNT_010    ${INPUTTER_USERNAME}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Date_Added_Amended    CMMNT_010    ${Comment_DateWithTime}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ
    Logout from Loan IQ

Update Comments in Customer for DNR
    [Documentation]    This keyword is used to update comments in active customer.
    ...    @author: clanding    05DEC2020    - initial create.
    [Arguments]    ${ExcelPath}

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    ${Status_UI}    Get Profile Status from Profiles Tab    &{ExcelPath}[Profile_Type]
    Compare Two Strings    Not In Use    ${Status_UI}
    ${New_Subect}    ${New_Comment_Details}    ${Comment_DateWithTime}    Update Details in Comments Tab in Active Customer    &{ExcelPath}[Comments_Subject]
    Write Data To Excel    SC1_PrimaryAllocation    User_ID    ${rowid}    ${INPUTTER_USERNAME}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Comments_DateAddedAmended    ${rowid}    ${Comment_DateWithTime}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Comments_Details    ${rowid}    ${New_Comment_Details}    ${DNR_DATASET}

    ### Writing for Comments Report ###
    Write Data To Excel    CMMNT    Customer_Name    CMMNT_010_Update    &{ExcelPath}[LIQCustomer_LegalName]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    CIF_Number    CMMNT_010_Update    &{ExcelPath}[LIQCustomer_ID]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Heading    CMMNT_010_Update    ${New_Subect}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Detail    CMMNT_010_Update    ${New_Comment_Details}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    User_ID    CMMNT_010_Update    ${INPUTTER_USERNAME}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Date_Added_Amended    CMMNT_010_Update    ${Comment_DateWithTime}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ
    Logout from Loan IQ

Add Alerts in Customer for DNR
    [Documentation]    This keyword is used to add comments in active customer.
    ...    @author: clanding    05DEC2020    - initial create.
    [Arguments]    ${ExcelPath}

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    ${Status_UI}    Get Profile Status from Profiles Tab    &{ExcelPath}[Profile_Type]
    Compare Two Strings    Not In Use    ${Status_UI}
    ${Alerts_Details}    ${Date_Added}    ${Current_Local_Date_WithoutTime}    Add Alerts in Active Customer    &{ExcelPath}[Alerts_ShortDescription]    &{ExcelPath}[Alerts_DetailsPrefix]
    Write Data To Excel    SC1_Customer    Alerts_Details    ${rowid}    ${Alerts_Details}    ${DNR_DATASET}
    Write Data To Excel    SC1_Customer    Alerts_DateAddedAmended    ${rowid}    ${Date_Added}    ${DNR_DATASET}

    ${FName_UI}    ${LName_UI}    Get First Name of a User    ${INPUTTER_USERNAME}

    ### Writing for Alerts Report ###
    Write Data To Excel    ALERT    Customer_Name    ${TestCase_Name}    &{ExcelPath}[LIQCustomer_LegalName]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    CIF_Number    ${TestCase_Name}    &{ExcelPath}[LIQCustomer_ID]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Heading    ${TestCase_Name}    &{ExcelPath}[Alerts_ShortDescription]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Content    ${TestCase_Name}    ${Alerts_Details}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    User_Name    ${TestCase_Name}    ${FName_UI}${SPACE}${LName_UI}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Date_Added_Amended    ${TestCase_Name}    ${Date_Added}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ
    Logout from Loan IQ

Update Alerts in Customer for DNR
    [Documentation]    This keyword is used to update comments in active customer.
    ...    @author: clanding    05DEC2020    - initial create.
    [Arguments]    ${ExcelPath}

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Customer    &{ExcelPath}[Customer_Search]    &{ExcelPath}[LIQCustomer_ID]    &{ExcelPath}[LIQCustomer_ShortName]          
    ${Status_UI}    Get Profile Status from Profiles Tab    &{ExcelPath}[Profile_Type]
    Compare Two Strings    Not In Use    ${Status_UI}
    ${Alerts_Details}    ${Date_Added}    ${Current_Local_Date_WithoutTime}    Update Alerts in Active Customer    &{ExcelPath}[Alerts_ShortDescription]

    ${FName_UI}    ${LName_UI}    Get First Name of a User    ${INPUTTER_USERNAME}

    ### Writing for Alerts Report ###
    Write Data To Excel    ALERT    Customer_Name    ${TestCase_Name}    &{ExcelPath}[LIQCustomer_LegalName]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    CIF_Number    ${TestCase_Name}    &{ExcelPath}[LIQCustomer_ID]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Heading    ${TestCase_Name}    &{ExcelPath}[Alerts_ShortDescription]    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Alert_Content    ${TestCase_Name}    ${Alerts_Details}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    User_Name    ${TestCase_Name}    ${FName_UI}${SPACE}${LName_UI}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Date_Added_Amended    ${TestCase_Name}    ${Date_Added}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ
    Logout from Loan IQ