*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Populate Amendment Notebook
    [Documentation]    This keyword validates the availability of the fields and buttons under Deal Select Window.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Fixed tabbing issue
    [Tags]    Validation
    [Arguments]    ${sDeal_Name}    ${sEffectiveDate}    ${sAmendmentNumber_Prefix}    ${sComment}
    
    ### GetRuntime Keyword Pre-processing ###
	${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
	${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
	${AmendmentNumber_Prefix}    Acquire Argument Value    ${sAmendmentNumber_Prefix}
	${Comment}    Acquire Argument Value    ${sComment}
  
    Select Actions    [Actions];Amendments
    
    ###Deal Select Window###
    mx LoanIQ activate    ${LIQ_DealSelect_Window}    
    mx LoanIQ enter    ${LIQ_AMD_DealSelect_Name_TextField}    ${Deal_Name}
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}
    
    ###Amendment List Window###
    mx LoanIQ activate    ${LIQ_AmendmentList_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AmendmentList_Window}    VerificationData="Yes"
        
        ##Validate Buttons in Amendment List Window
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_ShowCancelledTrans_CheckBox}     VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_ExpandAll_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_CollapseAll_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_OpenNtbk_Button}      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_Add_Button}       VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_Refresh_Button}      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_Exit_Button}      VerificationData="Yes"
    
    mx LoanIQ click    ${LIQ_AMD_Add_Button}  

    ####Amendment Notebook - Pending###
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AmendmentNotebookPending_Window}    VerificationData="Yes"
        
    ##Validate Fields and Buttons in Amendment Notebook - General Tab
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_EffectiveDate}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AmendmentNo}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_Comment}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AmendmentTrans_Section}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_General_Add_Button}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_General_Delete_Button}    VerificationData="Yes"
   
    mx LoanIQ enter    ${LIQ_AMD_EffectiveDate}    ${EffectiveDate}  

    ${AmendmentNo}    Auto Generate Only 4 Numeric Test Data    ${AmendmentNumber_Prefix}   

    mx LoanIQ enter    ${LIQ_AMD_AmendmentNo}    ${AmendmentNo}
    mx LoanIQ enter    ${LIQ_AMD_Comment}    ${Comment}
    
Populate Facility Select Window - Amendment Notebook
    [Documentation]    This keyword navigate Add Facility Option and populate the Facility Select window.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    [Arguments]    ${sDeal_Name}    ${sNewFacility_Name}    ${sFacility_Type}    ${sCurrency}  
    
    ### GetRuntime Keyword Pre-processing ###
	${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
	${NewFacility_Name}    Acquire Argument Value    ${sNewFacility_Name}
	${Facility_Type}    Acquire Argument Value    ${sFacility_Type}
	${Currency}    Acquire Argument Value    ${sCurrency}     

    mx LoanIQ activate    ${LIQ_AmendmentNotebookPending_Window}     
    mx LoanIQ select    ${LIQ_AmmendmentNotebook_OptionsAddFacility_Menu}
       
    ##Validate Fields and Buttons in Facility Select Window - Amendment Notebook
    Validate Loan IQ Details    ${Deal_Name}    ${LIQ_AMD_DealName_FacSelect_TextField}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_New_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_Existing_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_TicketMod_Checkbox}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_FacilityName_Text}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_FacilityType_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_FacilityType_Combobox}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_FCN_Textfield}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_ANSI_Textfield}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_Currency_List}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_OK_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_FacilitySelect_Search_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_Cancel_Button}    VerificationData="Yes"
    
    ##Populate the fields in Facility Select Window - Amendment Notebook      
    mx LoanIQ enter    ${LIQ_FacilitySelect_FacilityName_Text}    ${NewFacility_Name}  
    mx LoanIQ select list    ${LIQ_FacilitySelect_FacilityType_Combobox}    ${Facility_Type}
    mx LoanIQ select list    ${LIQ_FacilitySelect_Currency_List}    ${Currency}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_FacilityDetails

Validate Fields and Buttons in Amendment Notebook - General Tab
       [Documentation]    This keyword validates the availability of fields and buttons under Amendment Notebook- General Tab Window.
    ...    @author: mgaling
    [Tags]    Validation 
    
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_EffectiveDate}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AmendmentNo}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_Comment}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AmendmentTrans_Section}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_General_Add_Button}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_General_Delete_Button}    VerificationData="Yes"

Validate the Entered Values in Amendment Notebook - General Tab
      [Documentation]    This keyword validates if the entered data in Amendment Notebook- General Tab Window are matched with the data in Test Data sheet.
    ...    @author: mgaling
    ...    @update: clanding    30JUL2020    - fixed tabbing issue; refactor keyword name
    [Tags]    Validation 
    [Arguments]    ${sEffectiveDate}    ${sComment}  
    
    ###Pre-Processing Keyword####
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${Comment}    Acquire Argument Value    ${sComment}   
    
    Validate Loan IQ Details    ${EffectiveDate}    ${LIQ_AMD_EffectiveDate}
    Validate Loan IQ Details    ${Comment}    ${LIQ_AMD_Comment}

Validate the Entered Values in Facility Select Window - Amendment Notebook
      [Documentation]    This keyword validates if the entered data in Facility Select Window are matched with the data in Test Data sheet.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Removed Read Data From Excel; Added screenshot; Refactor keyword name
    [Tags]    Validation 
    [Arguments]    ${sNewFacility_Name}    ${sFacility_Type}    ${sCurrency}  
    
    ### GetRuntime Keyword Pre-processing ###
	${NewFacility_Name}    Acquire Argument Value    ${sNewFacility_Name}
	${Facility_Type}    Acquire Argument Value    ${sFacility_Type}
	${Currency}    Acquire Argument Value    ${sCurrency}
  
    Validate Loan IQ Details    ${NewFacility_Name}    ${LIQ_FacilitySelect_FacilityName_Text}
    Validate Loan IQ Details    ${Facility_Type}    ${LIQ_FacilitySelect_FacilityType_Combobox}
    Validate Loan IQ Details    ${Currency}    ${LIQ_FacilitySelect_Currency_List}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_FacilityValidation
    mx LoanIQ click    ${LIQ_FacilitySelect_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_FacilityValidation

Populate the Fields in Facility Notebook - Summary Tab  
     [Documentation]    This keyword populate the required fields under Facility Notebook- Summary Tab.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Fixed tabbing; updated hard coded values to global variables; removed writing of dataset; refactor keyword name
    ...    @update: clanding    20AUG2020    Added Portfolio in argument
    [Arguments]    ${sMSG_Customer}    ${sFacility_AgreementDate}    ${sExpiry_Date}    ${sFinalmaturity_Date}    
    
    ### GetRuntime Keyword Pre-processing ###
	${MSG_Customer}    Acquire Argument Value    ${sMSG_Customer}
	${Facility_AgreementDate}    Acquire Argument Value    ${sFacility_AgreementDate}
	${Expiry_Date}    Acquire Argument Value    ${sExpiry_Date}
	${Finalmaturity_Date}    Acquire Argument Value    ${sFinalmaturity_Date}

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${SUMMARY_TAB}     
      
    mx LoanIQ click    ${LIQ_FacilitySummary_MainSG_Button}
    mx LoanIQ activate window     ${LIQ_MainCustomer_Window}

    mx LoanIQ select list    ${LIQ_MainCustomer_Customer_List}    ${MSG_Customer}    

    mx LoanIQ click    ${LIQ_MainCustomer_SG_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/MainCustomer_SG
    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/MainCustomer_SG
    mx LoanIQ click    ${LIQ_MainCustomer_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/MainCustomer_SG
    
    mx LoanIQ enter    ${LIQ_FacilitySummary_AgreementDate_Datefield}    ${Facility_AgreementDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}         
    mx LoanIQ enter    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    ${Expiry_Date}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}    ${Finalmaturity_Date}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook
    
Validate the Entered Values in Facility Notebook - Summary Tab
     [Documentation]    This keywod validates if the entered data in Amendment List- General Tab Window are matched with the data in Test Data sheet.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Refactor keyword name
    [Tags]    Validation 
    [Arguments]    ${sFacility_AgreementDate}    ${sExpiry_Date}    ${sFinalmaturity_Date}
    
    ### GetRuntime Keyword Pre-processing ###
	${Facility_AgreementDate}    Acquire Argument Value    ${sFacility_AgreementDate}
	${Expiry_Date}    Acquire Argument Value    ${sExpiry_Date}
	${Finalmaturity_Date}    Acquire Argument Value    ${sFinalmaturity_Date}
    
    Validate Loan IQ Details    ${Facility_AgreementDate}    ${LIQ_FacilitySummary_AgreementDate_Datefield}
    Validate Loan IQ Details    ${Expiry_Date}    ${LIQ_FacilitySummary_ExpiryDate_Datefield}
    Validate Loan IQ Details    ${Finalmaturity_Date}    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_Fac_SummaryTab
           
Set Facility Loan Purpose
    [Documentation]    This keyword adds Loan Purpose Type.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Updated hard coded values to global variables
    [Arguments]    ${sLoanPurposeType}
    
    ### GetRuntime Keyword Pre-processing ###
	${LoanPurposeType}    Acquire Argument Value    ${sLoanPurposeType}    

    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${TYPES_PURPOSE_TAB} 
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_LoanPurposeTypes_Button}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_LoanPurposeTypesSelection_JavaList}    ${LoanPurposeType}%s    
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_LoanPurpose_OK_Button} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_Fac_PurposeTab   
   
Add Currency in Facility Notebook - Restriction Tab
        [Documentation]    This keyword populate the required fields under Facility Notebook- Restriction Tab.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Updated hard coded values to global variable; added screenshot
    [Arguments]    ${sCurrency}    ${sSG_Customer}         
    
    ### GetRuntime Keyword Pre-processing ###
	${Currency}    Acquire Argument Value    ${sCurrency}
	${SG_Customer}    Acquire Argument Value    ${sSG_Customer}

    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${RESTRICTIONS_TAB}
    mx LoanIQ click    ${LIQ_Facility_Restriction_Add_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Facility_SelectCurrency_JavaTree}    ${Currency}%s
    mx LoanIQ click    ${LIQ_Facility_SelectCurrency_OK_Button}
    mx LoanIQ click    ${LIQ_CurrencyDetail_SG_Button}
    mx LoanIQ select list    ${LIQ_SGProductCurrency_Customer}    ${SG_Customer}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_Fac_RestrictionTab
    mx LoanIQ click    ${LIQ_SGProductCurrency_SG_Button}
    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button} 
    mx LoanIQ click    ${LIQ_SGProductCurrency_OK_Button}  
    mx LoanIQ click    ${LIQ_CurrencyDetail_OK_Button}   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_Fac_RestrictionTab
      
Add Borrower in Facility Notebook - SublimitCust Tab
        [Documentation]    This keyword populate the required fields under Facility Notebook- Sublimit/Cust Tab.
    ...    @author: mgaling
    ...    @update: clanding    30JUL2020    - updated hard coded value to global variables; added screenshot
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${SUBLIMIT_CUST_TAB}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_SublimitCustTab
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_Button}
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_AddAll_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AddBorrower
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AddBorrower     
         
Modify Ongoing Fee - Insert After
    [Documentation]    This keyword adds ongoing fee - after on facility.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Replaced Sleep keyword; added split string and for loop for add item list
    [Arguments]    ${sFacilityItemAfter}    ${sFacilityItemTypeAfter}    ${sPercent}  
    
    ### GetRuntime Keyword Pre-processing ###
	${FacilityItemAfter}    Acquire Argument Value    ${sFacilityItemAfter}
	${FacilityItemTypeAfter}    Acquire Argument Value    ${sFacilityItemTypeAfter}
	${Percent}    Acquire Argument Value    ${sPercent}
	
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_After_Button}
    ${FacilityItemAfter_List}    Split String    ${FacilityItemAfter}    |
    :FOR    ${Item_After_List}    IN    @{FacilityItemAfter_List}
    \    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityPricing_OngoingFees_After_AddItemList}    ${Item_After_List}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityPricing_OngoingFees_After_AddItemType}    ${FacilityItemTypeAfter}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_Cancel_Button}       VerificationData="Yes"
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}
    mx LoanIQ enter    ${LIQ_FacilityPricing_FormulaCategory_Percent_Radiobutton}    ${ON}
    Sleep    2
    mx LoanIQ enter    ${LIQ_FacilityPricing_FormulaCategory_Percent_Textfield}    ${Percent}
    mx LoanIQ click    ${LIQ_FacilityPricing_FormulaCategory_OK_Button}
    

Validate Ongoing Fee Values
    [Documentation]    This keyword validates the values.
    ...    @author: mgaling
    ...    @update: clanding    30JUL2020    - refactor keyword name
    [Tags]    Validation 
    mx LoanIQ click    ${LIQ_FacilityPricicng_Validate_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Validation_Congratulations_Window}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CongratulationsWindow
    mx LoanIQ click    ${LIQ_Congratulations_OK_Button}
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow

Validate Interest Pricing Values
    [Documentation]    This keyword validates the values.
    ...    @author: mgaling
    ...    @update: clanding    30JUL2020    - refactor keyword name; added screenshot
    [Tags]    Validation 
    mx LoanIQ click    ${LIQ_FacilityPricicng_Validate_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Validation_Congratulations_Window}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow
    mx LoanIQ click    ${LIQ_Congratulations_OK_Button}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow
    
   
Modify Interest Pricing - Insert Add (Options Item)
     [Documentation]    This keyword add an Option Type Interest Pricing.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Updated hard coded values to global variables
     [Tags]    Validation
    [Arguments]    ${sInterestPricingItem}    ${sOptionName1}    ${sRateBasisInterestPricing}    ${sSpread1}    ${sOptionName2}    ${sSpread2}
    
    ### GetRuntime Keyword Pre-processing ###
	${InterestPricingItem}    Acquire Argument Value    ${sInterestPricingItem}
	${OptionName1}    Acquire Argument Value    ${sOptionName1}
	${RateBasisInterestPricing}    Acquire Argument Value    ${sRateBasisInterestPricing}
	${Spread1}    Acquire Argument Value    ${sSpread1}
    ${OptionName2}    Acquire Argument Value    ${sOptionName2}
	${Spread2}    Acquire Argument Value    ${sSpread2}

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    ${PRICING_TAB}     
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_Window}        VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_Add_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${InterestPricingItem}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItemType_List}    ${OptionName1}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_OptionName_List}    ${OptionName1}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_RateBasis_List}    ${RateBasisInterestPricing}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OptionCondition_OK_Button}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ${ON}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread1}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button}
    
    Validate Loan IQ Details    ${OptionName2}    ${LIQ_OptionCondition_OptionName_List}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_RateBasis_List}    ${RateBasisInterestPricing}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OptionCondition_OK_Button}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ${ON}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread2}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_Fac_PricingTab  
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button}
    
Add Facility in Amendment Transaction
       [Documentation]    This keyword add the facility and Transaction Type.
    ...    @author: mgaling
    ...    @update: clanding    30JUL2020    - fixed tabbing
    [Arguments]    ${sFacility_Name}    ${sTransaction_Type}   
    
    ### GetRuntime Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Transaction_Type}    Acquire Argument Value    ${sTransaction_Type}
     
    mx LoanIQ click    ${LIQ_AmmendmentNotebook_Add_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_NewTransaction_Window}    VerificationData="Yes"
         
    ###Validate and populate the Fields and Buttons in New Transaction - Amendment Notebook     
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_NewTran_Facility_Dropdown}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_NewTran_TransactionType_Dropdown}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_NewTran_Ok_Button}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_NewTran_Cancel_Button}    VerificationData="Yes"
   
    Mx LoanIQ Select Combo Box Value    ${LIQ_NewTran_Facility_Dropdown}    ${Facility_Name}   
    Mx LoanIQ Select Combo Box Value    ${LIQ_NewTran_TransactionType_Dropdown}    ${Transaction_Type}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_Transaction     
    mx LoanIQ click    ${LIQ_NewTran_Ok_Button} 

Populate Add Transaction Window
    [Documentation]    This keyword populate the Add Transaction Type.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Added ELSE in condition for warning; updated hard coded values to global variables
    [Arguments]    ${sNewTran_Amount}    ${sNewTran_PercentofCurrentBal} 
    
    ### GetRuntime Keyword Pre-processing ###
	${NewTran_Amount}    Acquire Argument Value    ${sNewTran_Amount}
	${NewTran_PercentofCurrentBal}    Acquire Argument Value    ${sNewTran_PercentofCurrentBal}   
 
    ##Validate and populate the Fields and Buttons in Add Transaction - Amendment Notebook       
    mx LoanIQ activate    ${LIQ_AMD_AddTransaction_Window}    
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AddTransaction_Window}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_Increase_RadioButton}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_Decrease_RadioButton}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_Amount_Field}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_PercentofCurrentBal_Field}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_EffectiveDate_Field}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_OK_Button}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_Cancel_Button}    VerificationData="Yes"
    mx LoanIQ enter    ${LIQ_AddTran_Amount_Field}    ${NewTran_Amount}    
    mx LoanIQ enter    ${LIQ_AddTran_PercentofCurrentBal_Field}    ${NewTran_PercentofCurrentBal} 
    mx LoanIQ click    ${LIQ_AddTran_OK_Button}
    
    :FOR    ${i}    IN RANGE    3
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==${True}    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
         ...    ELSE    Log    No warning message displayed.      
    \    Exit For Loop If    ${Warning_Displayed}==${False}  

Add a Schedule Item
      [Documentation]    This keyword add a Schedule Item in Amortization Schedule for Facility Window.
    ...    @author: mgaling  
    ...    @update: ritragel    1MAY2019    Updated as per scripting standards
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Updated hard coded values; added Run Keyword And Continue On Failure on FAIL
    ...    @update: clanding    20AUG2020    Added optional argument Portfolio
    [Arguments]    ${sNewTran_Amount}    ${sNewTran_PercentofCurrentBal}    ${sSchedule_Date}    ${sCurrent_Schedule}    ${sDeal_Name}    ${sMSG_Customer}    ${sPortfolio_Expense}    ${sPercentOfDeal_HB}
    ...    ${sPortfolio}=None   
    
    ### GetRuntime Keyword Pre-processing ###
	${NewTran_Amount}    Acquire Argument Value    ${sNewTran_Amount}
	${NewTran_PercentofCurrentBal}    Acquire Argument Value    ${sNewTran_PercentofCurrentBal}
	${Schedule_Date}    Acquire Argument Value    ${sSchedule_Date}
	${Current_Schedule}    Acquire Argument Value    ${sCurrent_Schedule}
	${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
	${MSG_Customer}    Acquire Argument Value    ${sMSG_Customer}
	${Portfolio_Expense}    Acquire Argument Value    ${sPortfolio_Expense}
	${PercentOfDeal_HB}    Acquire Argument Value    ${sPercentOfDeal_HB}
	${Portfolio}    Acquire Argument Value    ${sPortfolio}
    
    mx LoanIQ activate    ${LIQ_AMD_AmortizationSchedforFacility_Window}    
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AmortizationSchedforFacility_Window}    VerificationData="Yes"
    mx LoanIQ click    ${LIQ_AMD_AmortSched_Add_Button}
    
    ##Validate and populate the Fields and Buttons in Add Schedule Item - Amendment Notebook      
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AmortSched_AddScheduleItem_Window}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddSchedItem_Increase_RadioButton}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddSchedItem_Decrease_RadioButton}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddSchedItem_Amount_Field}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddSchedItem_PercentofCurrentBal_Field}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddSchedItem_ScheduleDate_Field}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddSchedItem_OK_Button}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddSchedItem_Cancel_Button}    VerificationData="Yes"
    
    mx LoanIQ enter    ${LIQ_AddSchedItem_Amount_Field}    ${NewTran_Amount}    
    mx LoanIQ enter    ${LIQ_AddSchedItem_PercentofCurrentBal_Field}    ${NewTran_PercentofCurrentBal}    
    
    mx LoanIQ enter    ${LIQ_AddSchedItem_ScheduleDate_Field}    ${Schedule_Date}
    Mx LoanIQ Click    ${LIQ_AddSchedItem_OK_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_AddSchedItem_OK_Button}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${AmortizationSchedforFacility_CurrentSchedule}    ${Current_Schedule}         
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${AmortizationSchedforFacility_CurrentSchedule}    ${Current_Schedule}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Current Schedule is not available 
    
    mx LoanIQ click    ${LIQ_AMD_AmortSched_TranNB_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    Validate the Facility Add/Unscheduled Commitment Increase/Awaiting Approval Window - General Tab    ${Deal_Name}         
  
   ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_HostBankShares_LE}    ${MSG_Customer}          
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_HostBankShares_LE}    ${MSG_Customer} 
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Customers is not available   
  
    mx LoanIQ click    ${LIQ_HostBankShare_AddPortfolioExpenseCode_Button}
    mx LoanIQ activate    ${LIQ_PortfolioSelect_Window}
    
    ${status}    Run Keyword If    '${Portfolio}'=='None'    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_PortfolioSelect_PotfolioExpenseCode}    ${Portfolio_Expense}
    ...    ELSE    Run Keyword And Return Status    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_PortfolioSelect_PotfolioExpenseCode}    ${Portfolio}\t${Portfolio_Expense}%s
    Run Keyword If    ${status}==${True} and '${Portfolio}'=='None'    Run Keywords    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_PortfolioSelect_PotfolioExpenseCode}    ${Portfolio_Expense}%s
    ...    AND    mx LoanIQ click    ${LIQ_PortfolioSelect_OK_Button}
    ...    ELSE IF    ${status}==${True} and '${Portfolio}'!='None'    Mx LoanIQ DoubleClick    ${LIQ_PortfolioSelect_PotfolioExpenseCode}    ${Portfolio}\t${Portfolio_Expense}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Portfolio Expense is not available

    ${Actual_Amount}    Evaluate    (${NewTran_Amount})*(${PercentOfDeal_HB})
    ${Actual_Amount}    Convert To Integer    ${Actual_Amount}
    mx LoanIQ enter    ${LIQ_PortfolioShareEdit_ActualAmount_Field}    ${Actual_Amount}
    mx LoanIQ click    ${LIQ_PortfolioShareEdit_OK_Button}
    mx LoanIQ click    ${LIQ_HostBankShare_OK_Button}
    mx LoanIQ click    ${LIQ_FacShares_OK_Button}
    mx LoanIQ activate    ${LIQ_FacAddUnsched_Window}    
    mx LoanIQ select    ${LIQ_FacAddUnsched_FileExitFacility_Menu}
    mx LoanIQ activate    ${LIQ_AMD_AmortizationSchedforFacility_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Add_Scheduled_Item
    mx LoanIQ click    ${LIQ_AMD_AmortSched_Save_Button}
    mx LoanIQ click    ${LIQ_AMD_AmortSched_Exit_Button}
    
Amendment Send to Approval
      [Documentation]    This keyword is for Send to Approval Window.
    ...    @author: mgaling
    ...    @update: clanding    30JUL2020    - updated hard coded values to global variables
    mx LoanIQ activate    ${LIQ_AmendmentNotebook}     
    Mx LoanIQ Select Window Tab    ${LIQ_AMD_Tab}    ${WORKFLOW_TAB}
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AMD_Workflow_JavaTree}    ${SEND_TO_APPROVAL_STATUS}%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
	:FOR    ${i}    IN RANGE    4
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==${True}    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
         ...    ELSE    Log    No warning message displayed.
    \    Exit For Loop If    ${Warning_Displayed}==${False}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_SendToApproval
	   
Search the Newly Added Facility
    [Documentation]    This keyword search the newly created Facility.
    ...    @author: mgaling
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    31JUL2020    Removed Read Data From Excel; moved screenshot
    [Arguments]    ${sDeal_Name}    ${sNewFacility_Name}
    
    ### GetRuntime Keyword Pre-processing ###
	${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
	${NewFacility_Name}    Acquire Argument Value    ${sNewFacility_Name}

    Select Actions    [Actions];Facility
    ##Validate Facility Select Window 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_New_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_Existing_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_DealName_Textfield}    VerificationData="Yes"
    mx LoanIQ enter    ${LIQ_FacilitySelect_DealName_Textfield}    ${Deal_Name}    
    :FOR    ${Index}    IN RANGE    5
    \    mx LoanIQ click    ${LIQ_FacilitySelect_Search_Button}
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_Search_Facility}    ${NewFacility_Name}
    \    Exit For Loop If    ${status}==${True}
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_Search_Facility}    ${NewFacility_Name}
    ...    ELSE    Fail    New Facility is not available
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNotebook_Window}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NewFacility_Verification
    mx LoanIQ select    ${LIQ_FacilityNotebook_File_Exit}

Amendment Approval
    [Documentation]    This keyword is for approval of Amendment Notebook.
    ...    @author: mgaling
    ...    @update: bernchua    13MAR2019    Update to use "Validate if Question or Warning Message is Displayed" keyword for warning/question messages
    ...    @update: clanding    30JUL2020    Fixed tabbing; added Run Keyword And Continue On Failure on FAIL
    [Arguments]    ${sWIPTransaction_Type}    ${sTransaction_Status_AwaitingApproval}    ${sDealTransaction_Type}    ${sDeal_Name}
    
    ######Pre-Processing keywords####
    ${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}    
    ${Transaction_Status_AwaitingApproval}    Acquire Argument Value    ${sTransaction_Status_AwaitingApproval}
    ${DealTransaction_Type}    Acquire Argument Value    ${sDealTransaction_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    ##Open Amendment Notebook thru WIP - Awaiting Approval     
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${Transaction_Status_AwaitingApproval}         
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${Transaction_Status_AwaitingApproval}   
    ...    ELSE    Run Keyword And Continue On Failure    Fail    'Awaiting Approval' is not available
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${DealTransaction_Type}
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${DealTransaction_Type}  
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Transaction Type is not available
    
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${Deal_Name}%d
    Sleep    3s 
	
	Mx LoanIQ Select Window Tab    ${LIQ_AMD_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AMD_Workflow_JavaTree}    ${APPROVAL_STATUS}%d
    
    Validate if Question or Warning Message is Displayed
    mx LoanIQ click    ${LIQ_Amendment_OK_Button}
    Validate if Question or Warning Message is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_Approval
    
Amendment Release
     [Documentation]    This keyword is for the release of Amendment Notebook.
    ...    @author: mgaling
    ...    @update: bernchua    13MAR2019    Update to use "Validate if Question or Warning Message is Displayed" keyword for warning/question messages
    ...    @update: clanding    30JUL2020    Updated hard coded values to global variables; added Run Keyword And Continue On Failure on FAIL 
    [Arguments]    ${sWIPTransaction_Type}    ${sTransaction_Status_AwaitingRelease}    ${sDealTransaction_Type}    ${sDeal_Name}       

    ######Pre-Processing keywords####
    ${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}    
    ${Transaction_Status_AwaitingRelease}    Acquire Argument Value    ${sTransaction_Status_AwaitingRelease}
    ${DealTransaction_Type}    Acquire Argument Value    ${sDealTransaction_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    ###Open Amendment Notebook thru WIP - Awaiting Release Approval     
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${Transaction_Status_AwaitingRelease}         
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${Transaction_Status_AwaitingRelease}   
    ...    ELSE    Run Keyword And Continue On Failure    Fail    'Awaiting Release' is not available
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${DealTransaction_Type}
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${DealTransaction_Type}    
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Transaction Type is not available
    
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProcess_TransactionStatus_DealList}    ${Deal_Name}%d   
    
    Mx LoanIQ Select Window Tab    ${LIQ_AMD_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AMD_Workflow_JavaTree}    ${RELEASE_STATUS}%d
    
    Validate if Question or Warning Message is Displayed
    mx LoanIQ click element if present    ${LIQ_Amendment_OK_Button}
    Validate if Question or Warning Message is Displayed
    
    mx LoanIQ activate    ${LIQ_AmendmentNotebookReleased_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AmmendmentNotebook_WorkflowTab_NoItems}    VerificationData="Yes"
    
    mx LoanIQ activate    ${LIQ_AmendmentNotebookReleased_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AMD_Tab}    ${EVENTS_TAB}
    Mx LoanIQ Select String    ${LIQ_AMD_Events_JavaTree}    ${RELEASED_STATUS}
    mx LoanIQ activate    ${LIQ_AmendmentNotebookReleased_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AmendmentNotebook_Released
    mx LoanIQ select    ${LIQ_AmendmentNotebookReleased_FileExit_Menu}
    mx LoanIQ activate    ${LIQ_TransactionInProcess_Window}
    mx LoanIQ select    ${LIQ_TransactionsInProcess_FileExit_Menu}
     
Populate General Tab in Amendment Notebook
    [Documentation]    This keyword populates fields under General Tab.
    ...    @author:mgaling
    ...    <Update>    Removed the Read and Write Codes
    [Arguments]    ${sAmendmentNumber_Prefix}    ${sAMD_EffectiveDate}    ${sComment}	${AmendmentNo}=None
    
   ####Pre-processing Keywords####
   ${AmendmentNumber_Prefix}    Acquire Argument Value    ${sAmendmentNumber_Prefix}
   ${Amendment_Number}    Acquire Argument Value    ${sAMD_EffectiveDate}
   ${Comment}    Acquire Argument Value    ${sComment}     
    
    ${AmendmentNo}    Auto Generate Only 4 Numeric Test Data    ${AmendmentNumber_Prefix}   
     
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AmendmentNotebookPending_Window}    VerificationData="Yes"
    
    Mx LoanIQ Select Window Tab    ${LIQ_AMD_Tab}    General    
        ##Validate Fields and Buttons in Amendment Notebook - General Tab
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_EffectiveDate}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AmendmentNo}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_Comment}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AmendmentTrans_Section}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_General_Add_Button}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_General_Delete_Button}    VerificationData="Yes"
   
    mx LoanIQ enter    ${LIQ_AMD_EffectiveDate}    ${sAMD_EffectiveDate}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
         
    mx LoanIQ enter    ${LIQ_AMD_AmendmentNo}    ${AmendmentNo}
    mx LoanIQ enter    ${LIQ_AMD_Comment}    ${Comment}
    Mx Press Combination    KEY.BACKSPACE 
   
    
### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${AmendmentNumber_Prefix}    ${AmendmentNo} 
    [Return]    ${AmendmentNo}
    
Populate Add Transaction Window for the Facility Increase
    [Documentation]    This keyword populate the Add Transaction Type.
    ...    @author: mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sNewTran_Amount}    ${sAMD_EffectiveDate}
    
    ### GetRuntime Keyword Pre-processing ###
	${NewTran_Amount}    Acquire Argument Value    ${sNewTran_Amount}
	${AMD_EffectiveDate}    Acquire Argument Value    ${sAMD_EffectiveDate} 
   
    ##Validate and populate the Fields and Buttons in Add Transaction - Amendment Notebook       
    mx LoanIQ activate window    ${LIQ_AMD_AddTransaction_Window}    
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AddTransaction_Window}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_Increase_RadioButton}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_Decrease_RadioButton}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_Amount_Field}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_PercentofCurrentBal_Field}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_EffectiveDate_Field}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_OK_Button}    VerificationData="Yes"
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AddTran_Cancel_Button}    VerificationData="Yes"
    mx LoanIQ enter    ${LIQ_AddTran_Amount_Field}    ${NewTran_Amount}
    Validate Loan IQ Details    ${AMD_EffectiveDate}    ${LIQ_AddTran_EffectiveDate_Field}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacIncr_AddTransaction       
    mx LoanIQ click    ${LIQ_AddTran_OK_Button}
    
    :FOR    ${i}    IN RANGE    3
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False 

Populate Amortization Schedule Window
    [Documentation]    This populates the fields under Amortization Schedule for Facility window.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sAmortSched_Status}
    
    ### GetRuntime Keyword Pre-processing ###
	${AmortSched_Status}    Acquire Argument Value    ${sAmortSched_Status}
    
    mx LoanIQ activate window    ${LIQ_AMD_AmortizationSchedforFacility_Window}    
    Run Keyword and Continue on Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AMD_AmortizationSchedforFacility_Window}    VerificationData="Yes"
    mx LoanIQ select list    ${LIQ_AMD_AmortSched_Status_Dropdown}    ${AmortSched_Status}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacIncr_AmortSchedule
        
    
Navigate to Unscheduled Commitment Increase Notebook
    [Documentation]    This navigates to Unscheduled Commitment Increase Notebook.
    ...    @author:mgaling   
    ...    @update: sahalder    06AUG2020    Added Screenshot steps
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${AmortizationSchedforFacility_CurrentSchedule}    U*         
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${AmortizationSchedforFacility_CurrentSchedule}    U*%s
    Run Keyword If    ${status}==False    Log    Fail    Unscheduled is not available 
    
    mx LoanIQ click    ${LIQ_AMD_AmortSched_TranNB_Button}
    :FOR    ${i}    IN RANGE    3
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False 
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Window} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Unschd_Comm_Incr_Notebook
       
    
Create Notices for Unscheduled Item
    [Documentation]    This keyword is for creating notices for the Unscheduled Item
    ...    @author:mgaling  
    ...    @update: sahalder    06AUG2020    Added Screenshot steps
    
    mx LoanIQ activate window    ${LIQ_AMD_AmortizationSchedforFacility_Window}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${AmortizationSchedforFacility_CurrentSchedule}    U*        
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${AmortizationSchedforFacility_CurrentSchedule}    U*%s
    Run Keyword If    ${status}==False    Log    Fail    Unscheduled is not available
    
    mx LoanIQ click    ${LIQ_AMD_AmortSched_CreateNotices_Button}
    mx LoanIQ activate window    ${LIQ_AmortSched_CreateGroupAddressedNotice_Window}
    Take Screenshot     
    mx LoanIQ click    ${LIQ_AmortSched_CreateGroupAddressedNotice_Create_Button}     
    mx LoanIQ activate window    ${LIQ_Notices_Window}
    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_AmortSched_FacilityAddGroup_Window}
    mx LoanIQ click    ${LIQ_AmortSched_FacilityAddGroup_Exit_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Create_Notices
    
Equalize Amounts under Current Schedule Section
    [Documentation]    This keyword is for equalizing amounts under Current Schedule Section.
    ...    @author:mgaling
    
    mx LoanIQ activate window    ${LIQ_AMD_AmortizationSchedforFacility_Window}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${AmortizationSchedforFacility_CurrentSchedule}    U*         
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${AmortizationSchedforFacility_CurrentSchedule}    U*%s
    Run Keyword If    ${status}==False    Log    Fail    Unscheduled is not available
    
    mx LoanIQ click    ${LIQ_AMD_AmortSched_EqualizeAmounts_Button}
    mx LoanIQ activate window    ${LIQ_EqualizingAmounts_PleaseConfirm_Window}    
    mx LoanIQ click    ${LIQ_EqualizingAmounts_PleaseConfirm_Yes_Button} 
    
    mx LoanIQ activate window    ${LIQ_AMD_AmortizationSchedforFacility_Window}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${AmortizationSchedforFacility_CurrentSchedule}    Scheduled         
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${AmortizationSchedforFacility_CurrentSchedule}    Scheduled%s 
    Run Keyword If    ${status}==False    Log    Fail    Scheduled Item is not available
    
    ${Sched_RemainingAmt}    Mx LoanIQ Store TableCell To Clipboard    ${AmortizationSchedforFacility_CurrentSchedule}    Scheduled%Remaining Amount%value
    Log    ${Sched_RemainingAmt}
    
    Should Be Equal    ${Sched_RemainingAmt}    0.00  
    
    mx LoanIQ click    ${LIQ_AMD_AmortSched_Exit_Button}
    
Create New Transaction for Amendment to Add New facility or Unscheduled Increase
    [Documentation]    This keyword creates new transaction for amendment to Add New facility or Unscheduled Increase
    ...    @author: ehugo    25SEP2019    Initial create
    [Arguments]    ${sFacilityName}    ${sAmendmentNumber_Prefix}    ${sAMD_EffectiveDate}    ${sComment}    ${sNew_TransactionAmount}    ${sNew_PercentOfCurrentBalance}
    ...    ${sNew_Facility_MaturityDate}    ${sDealName}    ${sFacility_Customer}    ${sExpenseCode}    ${sExpenseDescription}
    
    Create Amendment via Deal Notebook
    ${AmendmentNumber}    Populate General Tab in Amendment Notebook    ${sAmendmentNumber_Prefix}    ${sAMD_EffectiveDate}    ${sComment}
    Add Facility in Amendment Transaction	${sFacilityName}    Facility Add/Unscheduled Commitment Increase
    Populate Add Transaction Window    ${sNew_TransactionAmount}    ${sNew_PercentOfCurrentBalance}
    Add a Schedule Item    ${sNew_TransactionAmount}    ${sNew_PercentOfCurrentBalance}    ${sNew_Facility_MaturityDate}    Unscheduled    ${sDealName}    ${sFacility_Customer}    ${sExpenseCode}-${sExpenseDescription}    1
    Amendment Send to Approval
    
    ###Logout LIQ and Login as Approver###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    Open Existing Deal    ${sDealName}
    Select Existing Deal Amendment from Deal Notebook    ${AmendmentNumber}    
    
    ###Approve and Release Amendment###
    Approve Amendment in Amendment Window
    Release Amendment in Amendment Window
    
    Close All Windows on LIQ
    
    [Return]    ${AmendmentNumber}
    
Send to Approval Amendment in Amendment Window
    [Documentation]    This keyword is for Amendment Approval in Amendment Window
    ...    @author: ehugo    30SEP2019    Initial create
    
    mx LoanIQ activate    ${LIQ_AmendmentNotebook}     
    Mx LoanIQ Select Window Tab    ${LIQ_AMD_Tab}    Workflow
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AMD_Workflow_JavaTree}    Send to Approval%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}

Approve Amendment in Amendment Window
    [Documentation]    This keyword is for Amendment Approval in Amendment Window
    ...    @author: ehugo    30SEP2019    Initial create
    
    mx LoanIQ activate    ${LIQ_AmendmentNotebook}     
    Mx LoanIQ Select Window Tab    ${LIQ_AMD_Tab}    Workflow
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AMD_Workflow_JavaTree}    Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click    ${LIQ_Amendment_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
	
Release Amendment in Amendment Window
    [Documentation]    This keyword is for Amendment Release in Amendment Window
    ...    @author: ehugo    30SEP2019    Initial create
    
    mx LoanIQ activate    ${LIQ_AmendmentNotebook}     
    Mx LoanIQ Select Window Tab    ${LIQ_AMD_Tab}    Workflow
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AMD_Workflow_JavaTree}    Release%d
    mx LoanIQ click    ${LIQ_Amendment_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
	
Select Existing Deal Amendment from Deal Notebook
    [Documentation]    This keyword selects existing Deal Amendment from Deal Notebook
    ...    @author: ehugo    30SEP2019    Initial create
    [Arguments]    ${sAmendmentNumber}
    
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${IQ_DealNotebook_Queries_AmendmentQuery} 
    mx LoanIQ activate    ${LIQ_AmendmentList_Window}
    Mx LoanIQ Select String    ${LIQ_AMD_JavaTree}    Amendment ${sAmendmentNumber}    
    mx LoanIQ click    ${LIQ_AMD_OpenNtbk_Button}
    mx LoanIQ close window    ${LIQ_AmendmentList_Window}
    mx LoanIQ activate    ${LIQ_AmendmentNotebook}     

Create New Transaction for Amendment
    [Documentation]    This keyword creates new transaction for amendment
    ...    @author: hstone    21OCT2019    Initial create
    [Arguments]    ${sFacilityName}    ${sTransactionType}    ${sAmendmentNumber_Prefix}    ${sAMD_EffectiveDate}    ${sComment}    ${sNew_TransactionAmount}    ${sNew_PercentOfCurrentBalance}
    ...    ${sDealName}
    Create Amendment via Deal Notebook
    ${AmendmentNumber}    Populate General Tab in Amendment Notebook    ${sAmendmentNumber_Prefix}    ${sAMD_EffectiveDate}    ${sComment}
    Add Facility in Amendment Transaction	${sFacilityName}    ${sTransactionType}
    Populate Add Transaction Window    ${sNew_TransactionAmount}    ${sNew_PercentOfCurrentBalance}
    Create Pending For Scheduled Commitment Decrease    ${sAMD_EffectiveDate}
    Navigate Notebook Workflow    ${LIQ_ScheduledCommitment_Notebook}    ${LIQ_ScheduledCommitment_Tab}    ${LIQ_ScheduledCommitment_Workflow_JavaTree}    Send to Approval
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Close All Windows on LIQ
    
    ### Logout LIQ and Login as Approver ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    Navigate Transaction in WIP    Facilities    Awaiting Approval    Scheduled Commitment Decrease    ${sDealName}
    Navigate Notebook Workflow    ${LIQ_ScheduledCommitment_Notebook}    ${LIQ_ScheduledCommitment_Tab}    ${LIQ_ScheduledCommitment_Workflow_JavaTree}    Approval  
    Navigate Notebook Workflow    ${LIQ_ScheduledCommitment_Notebook}    ${LIQ_ScheduledCommitment_Tab}    ${LIQ_ScheduledCommitment_Workflow_JavaTree}    Release
    Close All Windows on LIQ
    
    ### Logout LIQ and Login as User ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
      
    Open Existing Deal    ${sDealName}
    Select Existing Deal Amendment from Deal Notebook    ${AmendmentNumber}
    Navigate Notebook Workflow    ${LIQ_AmendmentNotebook}    ${LIQ_AMD_Tab}    ${LIQ_AMD_Workflow_JavaTree}    Send to Approval
    
    ### Logout LIQ and Login as Approver ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    Open Existing Deal    ${sDealName}
    Select Existing Deal Amendment from Deal Notebook    ${AmendmentNumber}
    
    ### Approve and Release Amendment ###
    Approve Amendment in Amendment Window
    Release Amendment in Amendment Window
    
    Close All Windows on LIQ
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    [Return]    ${AmendmentNumber}
    
Create Pending For Scheduled Commitment Decrease
    [Documentation]    This keyword creates pending transaction for a scheduled commitment decrease
    ...    @author: hstone    22OCT2019    Initial create
    [Arguments]    ${sEffectiveDate}
    mx LoanIQ activate    ${LIQ_AMD_AmortizationSchedforFacility_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AmortizationSchedforFacility_CurrentSchedule}    Scheduled%s    
    mx LoanIQ click    ${LIQ_AMD_AmortSched_CreatePending_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_AmortSched_EffectiveDate_TextField}    ${sEffectiveDate}
    mx LoanIQ click    ${LIQ_AmortSched_EffectiveDate_OK_Button}

Finalize Amortization Schedule
    [Documentation]    This keyword creates pending transaction for a scheduled commitment decrease
    ...    @author: hstone    12DEC2019    Initial create
    Mx LoanIQ Select Combo Box Value    ${LIQ_AMD_AmortSched_Status_Dropdown}    Final
    mx LoanIQ click    ${LIQ_AMD_AmortSched_Exit_Button}
    mx LoanIQ click    ${LIQ_AMD_AmortSched_ExitAndSave_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
        
Create Unscheduled Commitment Increase
    [Documentation]    This keyword creates a new unscheduled faility commitment increase
    ...    @author: hstone    12DEC2019    Initial create
    [Arguments]    ${sFacilityName}    ${sTransactionType}    ${sAmendmentNumber_Prefix}    ${sAMD_EffectiveDate}    ${sComment}    ${sNew_TransactionAmount}    ${sNew_PercentOfCurrentBalance}
    ...    ${sDealName}
    Create Amendment via Deal Notebook
    ${AmendmentNumber}    Populate General Tab in Amendment Notebook    ${sAmendmentNumber_Prefix}    ${sAMD_EffectiveDate}    ${sComment}
    Add Facility in Amendment Transaction	${sFacilityName}    ${sTransactionType}
    Populate Add Transaction Window    ${sNew_TransactionAmount}    ${sNew_PercentOfCurrentBalance}
    Finalize Amortization Schedule

    Send to Approval Amendment in Amendment Window
    Close All Windows on LIQ
    
    ### Logout LIQ and Login as Approver ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    Navigate Transaction in WIP    Deals    Awaiting Approval    Deal Amendment    ${sDealName}
    Approve Amendment in Amendment Window
    Release Amendment in Amendment Window
    Close All Windows on LIQ
    
    ### Logout LIQ and Login as Approver ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    [Return]    ${AmendmentNumber}
    
Share Adjustment in Facility Notebook
    [Documentation]    This keyword is used to adjust shares in Facility Notebook
    ...    @author: Archana
    [Arguments]    ${sBuySellPrice}    ${sCommentTextField}    ${sDeal_Name}    ${sFacility_Name}    ${sAmendment_Number}    ${sDeal_NameR}=None    ${sFacility_NameR}=None
    
######Pre-Processing keywords####

     ${BuySellPrice}    Acquire Argument Value    ${sBuySellPrice}    
     ${CommentTextField}    Acquire Argument Value    ${sCommentTextField}
     ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
     ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
     ${Amendment_Number}    Acquire Argument Value    ${sAmendment_Number}
     ${Deal_NameR}    Acquire Argument Value    ${sDeal_NameR}
     ${Facility_NameR}    Acquire Argument Value    ${sFacility_NameR}

    Mx LoanIQ Activate Window    ${LIQ_ShareAdjustment_Window}    
    ${Deal_NameR}    Mx LoanIQ Get Data    ${LIQ_ShareAdjustment_DealName}    input=attached-text
    ${Facility_NameR}    Mx LoanIQ Get Data    ${LIQ_ShareAdjustment_FacilityName}    input=attached-text   
    Should Be Equal    ${Deal_Name}    ${Deal_NameR}
    Should Be Equal    ${Facility_Name}    ${Facility_NameR} 
    Mx LoanIQ enter    ${LIQ_ShareAdjustment_BuySellPrice_Textfield}    ${BuySellPrice} 
    Mx LoanIQ enter    ${LIQ_ShareAdjustment_Comment_Textfield}    ${CommentTextField}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ShareAdjustment 
    Select Menu Item    ${LIQ_ShareAdjustment_Window}    File    Save  
    
Close Share Adjustment in Facility Notebook    
    [Documentation]    This keyword is used to close the Share Adjustment in Facility Notebook  
    ...    @author:Archana    
    Mx LoanIQ Close    ${LIQ_ShareAdjustment_Window}
    
Covenant Change in Facility Notebook
    [Documentation]    This keyword is used to adjust shares in Facility Notebook
    ...    @author: Archana
    [Arguments]    ${sCovenantCommentText}    ${sAmendment_Number}    ${sAmendment_NumberR}=None
    
#####Pre-processing keywords###
      ${CovenantCommentText}    Acquire Argument Value    ${sCovenantCommentText}
      ${Amendment_Number}    Acquire Argument Value    ${sAmendment_Number}
      ${Amendment_NumberR}    Acquire Argument Value    ${sAmendment_NumberR}   
  
    Mx LoanIQ Activate Window    ${LIQ_CovenantChange_Window}  
    ${Amendment_NumberR}    Mx LoanIQ Get Data    ${LIQ_CovenantChange_AmendmentNO}    input=value    
    Should Be Equal    ${Amendment_Number}    ${Amendment_NumberR}
    Mx LoanIQ enter    ${LIQ_CovenantChange_Comment}    ${CovenantCommentText}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CovenantChange   
    Select Menu Item    ${LIQ_CovenantChange_Window}    File    Save
    Mx LoanIQ Close    ${LIQ_CovenantChangeAwaitingApproval}
    
    
    
    
   
    

   
    
           
       