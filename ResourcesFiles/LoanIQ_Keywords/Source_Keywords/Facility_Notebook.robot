*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
New Facility Select
    [Documentation]    This keyword creates a new facility.
    ...    @author: fmamaril
    ...    @update: amansuet    23APR2020    Updated to align with automation standards and added keyword pre and post processing
    # ...    @author: ghabal: updated ${LIQ_FacilitySummary_ClosingCmt_Textfield} to remove comma for comparison for Scenario 4
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}    ${sFacility_Type}    ${sFacility_ProposedCmtAmt}    ${sFacility_Currency}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    ### Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}    ${ARG_TYPE_UNIQUE_NAME_VALUE}

    mx LoanIQ activate window     ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}    
    mx LoanIQ select   ${LIQ_DealNotebook_Options_Facilities}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}      
    mx LoanIQ click    ${LIQ_FacilityNavigator_Add_Button}
    Validation on Facility Add
    mx LoanIQ enter    ${LIQ_FacilitySelect_New_RadioButton}    ON
    Validate on Facility New Window         
    mx LoanIQ enter    ${LIQ_FacilitySelect_DealName_Textfield}    ${Deal_Name}
    mx LoanIQ enter    ${LIQ_FacilitySelect_FacilityName_Text}    ${Facility_Name}
    mx LoanIQ click    ${LIQ_FacilitySelect_FacilityType_Button}
    mx LoanIQ enter    ${LIQ_FacilityTypeSelect_SearchByDescription_Textfield}    ${sFacility_Type}
    mx LoanIQ click    ${LIQ_FacilityTypeSelect_OK_Button}    
    mx LoanIQ enter    ${LIQ_FacilitySelect_ProposedCmt_Textfield}    ${sFacility_ProposedCmtAmt}
    Mx LoanIQ select combo box value    ${LIQ_FacilitySelect_Currency_List}    ${sFacility_Currency}
    mx LoanIQ click    ${LIQ_FacilitySelect_OK_Button} 
    :FOR    ${i}    IN RANGE    2
    \    Sleep    10
    \    ${LIQ_FacilityNoebook_WindowExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNotebook_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${LIQ_FacilityNoebook_WindowExist}==True    
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Facility -    ${sFacility_Type}
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Facility -    ${sFacility_Name}  
    Validate Loan IQ Details    ${sFacility_ProposedCmtAmt}    ${LIQ_FacilitySummary_ClosingCmt_Textfield}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_Window
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sFacility_Name}    ${Facility_Name}

    [Return]    ${sFacility_ProposedCmtAmt}

Validation on Facility Add
    [Documentation]    This keyword verifies details on Facility Add
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_New_RadioButton}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_Existing_RadioButton}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_OK_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_Search_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_Cancel_Button}            VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_DealName_Textfield}        VerificationData="Yes"

Validate on Facility New Window
    [Documentation]    This keyword verifies details on Facility New
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FacilitySelect_TicketMod_Checkbox}    Ticket Mod
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FacilitySelect_DealName_Textfield}    Deal Name
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FacilitySelect_FacilityName_Text}    Facility Name
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FacilitySelect_FacilityType_Button}    Facility Type Select
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_FCN_Textfield}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist        ${LIQ_FacilitySelect_ANSI_Textfield}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FacilitySelect_ProposedCmt_Textfield}    Proposed Cmt Amount
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilitySelect_Currency_List}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FacilitySelect_OK_Button}    OK
    Run Keyword And Continue On Failure    Validate if Element is Disabled    ${LIQ_FacilitySelect_Search_Button}    Search
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_FacilitySelect_Cancel_Button}    Cancel          
                
Enter Dates on Facility Summary
    [Documentation]    This keyword enters dates on facility summary.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    @update: rtarayao
    ...    added mx click element if present for holiday warning button on line 73 and 75
    ...    added optional argument for filePath to accomadate other path of excel file.
    ...    added optional agument for Write to Excel and rowid to accommodate facility with no loan/drawdown yet.
    ...    added mx click element if present to handle holiday warning message for expiry and maturity dates.
    ...    @update: fmamaril    12MAR2019    Remove writing on Excel for low level keyword 
    [Arguments]    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}    ${filePath}=${ExcelPath}    ${WriteToExcel}=Y
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    mx LoanIQ enter    ${LIQ_FacilitySummary_AgreementDate_Datefield}    ${Facility_AgreementDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    mx LoanIQ enter    ${LIQ_FacilitySummary_EffectiveDate_Datefield}    ${Facility_EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    ${Facility_ExpiryDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}    ${Facility_MaturityDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}   
    
Validate Dates on Facility Summary
    [Documentation]    This keyword verifies dates on facility summary
    ...    @author: fmamaril
    [Tags]    Validation
    [Arguments]    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Validate Loan IQ Details    ${Facility_AgreementDate}    ${LIQ_FacilitySummary_AgreementDate_Datefield}
    Validate Loan IQ Details    ${Facility_EffectiveDate}    ${LIQ_FacilitySummary_EffectiveDate_Datefield}
    Validate Loan IQ Details    ${Facility_ExpiryDate}    ${LIQ_FacilitySummary_ExpiryDate_Datefield}       
    Validate Loan IQ Details    ${Facility_MaturityDate}    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}
    
Verify Main SG Details
    [Documentation]    This keyword verifies the Main SG details.
    ...    @author: fmamaril
    ...    @update: bernchua: Added condition if MainSG does not contain value, and added 'Facility_SGLocation' argument for adding MainSG details.
    ...    @update: bernchua: Returns the Facility Main SG name.
    ...                       Set default value of 'Facility_SGLocation' to ${EMPTY}
    ...    @update: jdelacru    13DEC2019    - Added for loop logic in clicking Main SG button
    ...    @update: clanding    28JUL2020    - Added pre-processing/post-processing keywords; refactor arguments
    ...                                      - Updated ${Facility_SGLocation} to ${Facility_ServicingGroup} in selecting in servicing group
    [Arguments]    ${sFacility_ServicingGroup}    ${sFacility_Customer}    ${sFacility_SGLocation}=${EMPTY}    ${sRunTimeVar_MainSG_Name}=None
    
    ### GetRuntime Keyword Pre-processing ###
    ${Facility_ServicingGroup}    Acquire Argument Value    ${sFacility_ServicingGroup}
    ${Facility_Customer}    Acquire Argument Value    ${sFacility_Customer}
    ${Facility_SGLocation}    Acquire Argument Value    ${sFacility_SGLocation}

    Mx LoanIQ Activate Window     ${LIQ_FacilityNotebook_Window}
    :FOR    ${Index}    IN RANGE    3
    \    Mx LoanIQ Click    ${LIQ_FacilitySummary_MainSG_Button}
    \    Repeat Keyword    3 times    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}
    \    ${MainSGWindow_Status}    Run Keyword and Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_MainCustomer_Window}
    \    Exit For Loop If    ${MainSGWindow_Status}==${TRUE}
    Mx LoanIQ Activate Window     ${LIQ_MainCustomer_Window}
    ${MainSG_Status}    Run Keyword And Return Status    Validate Loan IQ Details    ${Facility_Customer}    ${LIQ_MainCustomer_Customer_List}
    Run Keyword If    ${MainSG_Status}==True    Run Keywords
    ...    Validate Loan IQ Details    ${Facility_Customer}    ${LIQ_MainCustomer_Customer_List} 
    ...    AND    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Main Customer    ${Facility_ServicingGroup}
    ...    ELSE    Run Keywords
    ...    Mx LoanIQ Select Combo Box Value    ${LIQ_MainCustomer_Customer_List}    ${Facility_Customer}
    ...    AND    mx LoanIQ click    ${LIQ_MainCustomer_ServicingGroup_Button}
    ...    AND    Mx LoanIQ Select String    ${LIQ_MainCustomer_ServicingGroups_Location_Tree}    ${Facility_ServicingGroup}
    ...    AND    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    ...    AND    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Main Customer    ${Facility_ServicingGroup}
    mx LoanIQ click    ${LIQ_MainCustomer_OK_Button}
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Facility -    ${Facility_Customer} / ${Facility_ServicingGroup}
    ${MainSG_Name}    Set Variable    ${Facility_Customer} / ${Facility_ServicingGroup}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Summary
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_MainSG_Name}    ${MainSG_Name}
    [Return]    ${MainSG_Name}
    
Add Loan Purpose Type
    [Documentation]    This keyword adds a loan purpose type on a facility.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    Changed mx loaniq verify text in javatree to mx loaniq select string
    [Arguments]    ${LIQ_LoanPurposeTypesSelection}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Types/Purpose
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_LoanPurposeTypes_Button}
    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window     ${LIQ_LoanPurposeTypesSelection_Window}
    Validation on Loan Purpose Window  
    Mx LoanIQ Select String    ${LIQ_LoanPurposeTypesSelection_JavaList}    ${LIQ_LoanPurposeTypesSelection}
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_LoanPurpose_OK_Button}
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_FacilityTypesPurpose_LoanPurpose_JavaTree}    ${LIQ_LoanPurposeTypesSelection}   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_TypesPurpose

Validation on Loan Purpose Window
    [Documentation]    This keyword verifies dates on facility summary
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LoanPurposeTypesSelection_Window}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityTypesPurpose_LoanPurpose_OK_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LoanPurposeTypesSelection_Cancel_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LoanPurposeTypesSelection_SelectAll_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LoanPurposeTypesSelection_DeselectAll_Button}          VerificationData="Yes"
    
Add Risk Type
    [Documentation]    This keyword adds a risk type on a facility.
    ...    @author: fmamaril
    ...    @update: mnanquil
    ...    Changed mx loaniq verify text in javatree to mx loaniq select string
    [Arguments]    ${RiskTypes}    ${RiskTypeLimit}    ${Currency} 
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Types/Purpose
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_RiskType_Add_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window     ${LIQ_RiskType_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_RiskType_Window}    VerificationData="Yes"
    Mx LoanIQ select combo box value    ${LIQ_FacilityTypesPurpose_RiskType_ComboBox}    ${RiskTypes}
    mx LoanIQ enter    ${LIQ_RiskType_Limit_Field}    ${RiskTypeLimit}
    Mx LoanIQ Set    ${LIQ_RiskType_Active_Checkbox}    ON
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Risk Type Details    ${Currency}    
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_RiskTypeDetails_OK_Button}
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_FacilityTypesPurpose_RiskType_JavaTree}    ${RiskTypes}
    
Modify Ongoing Fee Pricing - Insert Add
    [Documentation]    This keyword adds ongoing fee - add on facility.
    ...    @author: fmamaril
    ...    @update: fmamaril    01MAR2019    - add action for warning message after modify ongoing fee
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    - updated hard coded values to global variables; replaced Sleep keyword
    [Arguments]    ${sFacilityItem}    ${sFeeType}    ${sRateBasisOngoingFeePricing} 
    
    ### GetRuntime Keyword Pre-processing ###
	${FacilityItem}    Acquire Argument Value    ${sFacilityItem}
	${FeeType}    Acquire Argument Value    ${sFeeType}
	${RateBasisOngoingFeePricing}    Acquire Argument Value    ${sRateBasisOngoingFeePricing}

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    ${PRICING_TAB}     
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_Add_Button}
    mx LoanIQ activate window    ${LIQ_Facility_InterestPricing_AddItem_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityPricing_OngoingFees_AddItemList}    ${FacilityItem}   
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FeeSelection_Category_List}    ${FacilityItem}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FeeSelection_Type_List}    ${FeeType} 
    Mx LoanIQ Select Combo Box Value    ${LIQ_FeeSelection_RateBasis_List}    ${RateBasisOngoingFeePricing} 
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_FreeSelection_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Ongoing Fee Pricing.*").JavaTree("developer name:=.*${FacilityItem}.*")    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
    
Modify Ongoing Fee Pricing - Insert After
    [Documentation]    This keyword adds ongoing fee - after on facility.
    ...    @author: fmamaril
    ...    @update: clanding    30JUL2020    - replaced sleep keywords
    [Arguments]    ${FacilityItemAfter}    ${Facility_PercentWhole}    ${FacilityItem}    ${Facility_Percent}  
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_After_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    Copy Interest Pricing Matrix
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    FormulaCategory
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    Matrix
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${FacilityItemAfter}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_Cancel_Button}       VerificationData="Yes"
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}
    mx LoanIQ enter    ${LIQ_FacilityPricing_FormulaCategory_Percent_Radiobutton}    ON
    mx LoanIQ activate window    ${LIQ_FormulaCategory_Window}
    mx LoanIQ enter    ${LIQ_FacilityPricing_FormulaCategory_Percent_Textfield}    ${Facility_Percent}
    mx LoanIQ click    ${LIQ_FacilityPricing_FormulaCategory_OK_Button}
    mx LoanIQ activate window    ${LIQ_Warning_Window}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Ongoing Fee Pricing.*").JavaTree("developer name:=.*${Facility_PercentWhole}.*")    VerificationData="Yes"
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*${Facility_PercentWhole}.*")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*${FacilityItem}.*")    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
        
Modify Interest Pricing - Insert Add
    [Documentation]    This keyword adds interest pricing on facility.
    ...    @author: fmamaril
    ...    @update: mnanquil - added condition to handle if locator add item list exist
    ...    @update: rtarayao 01/07/2019: Added condition to handle pricing options' Pricing Formula and added action to handle warning message.
    ...    @update: dahijara    26JUN2020    - added keyword pre-processing
    [Arguments]    ${sInterestPricingItem}    ${sOptionName}    ${sRateBasisInterestPricing}    ${sSpread}    ${sInterestPricingCode}    ${sPercentOfRateFormulaUsage}=None

    ### GetRuntime Keyword Pre-processing ###
    ${InterestPricingItem}    Acquire Argument Value    ${sInterestPricingItem}
    ${OptionName}    Acquire Argument Value    ${sOptionName}
    ${RateBasisInterestPricing}    Acquire Argument Value    ${sRateBasisInterestPricing}
    ${Spread}    Acquire Argument Value    ${sSpread}
    ${InterestPricingCode}    Acquire Argument Value    ${sInterestPricingCode}
    ${PercentOfRateFormulaUsage}    Acquire Argument Value    ${sPercentOfRateFormulaUsage}

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Pricing     
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_Window}        VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_Add_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_AddItem_List}      VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${InterestPricingItem}
    Run Keyword If    '${status}' == 'True'    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_OptionName_List}    ${OptionName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_RateBasis_List}    ${RateBasisInterestPricing}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OptionCondition_OK_Button}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ON
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread} 
    Run Keyword If    '${PercentOfRateFormulaUsage}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_FormulaCategory_PercentOfRateFormulaUsage_List}    ${PercentOfRateFormulaUsage}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Facility_InterestPricing_OptionCondition_Cancel_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*${InterestPricingCode}.*")     VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
        
Get Interest Base Rate Code  
    [Documentation]    This keyword returns the actual Base Rate Code based from the given Spread Value and Base Rate Code Formula.
    ...    @author: henstone    08AUG2019    INITIAL CREATION
    [Arguments]    ${sBase_Rate_Code}    ${sSpread_Value}    ${sSpread_Var}
    [Return]    ${result}  
    ${result}    Replace String    ${sBase_Rate_Code}    ${sSpread_Var}    ${sSpread_Value} 

Convert to Formula with Escape Sequence 
    [Documentation]    This keyword returns a Formula with escape sequence on symbols.
    ...    @author: henstone    08AUG2019    INITIAL CREATION
    [Arguments]    ${sFormula}   
    [Return]    ${result}  
    ${result}    Replace String    ${sFormula}    (    \\(  
    ${result}    Replace String    ${result}    )    \\)  
    ${result}    Replace String    ${result}    +    \\+
    ${result}    Replace String    ${result}    .    \\.
    
Verify Pricing Rules
    [Documentation]    This keyword verifies the Pricing Rules on Facility Level.
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Updated hard coded value to global variable
    [Arguments]    ${sFacility_PricingRuleOption}
    
    ### GetRuntime Keyword Pre-processing ###
	${Facility_PricingRuleOption}    Acquire Argument Value    ${sFacility_PricingRuleOption}    

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    ${PRICING_RULES_TAB}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*${Facility_PricingRuleOption}.*")         VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_PricingRules
    
Add Borrower
    [Documentation]    This keyword adds a borrower on a deal.
    ...    @author: fmamaril
    ...    @update: added optional argument to handle adding of currency. 
    ...    Set the value for add all currency to N if you want to add spefici currency.
    ...    Added two optional argument for currency name and risk type.
    ...    @update: rtarayao - Added optional argument to handle adding of sublimit.
    ...    Added mx click element if present to handle warning message if the sublimit amount is less than the facility proposed cmt amount.
    ...    Added conditional script for the currency text validation.
    ...    Added conditional argument to handle two risktypes.
    ...    @update: clanding    28JUL2020    - added pre-processing keywords; refactor arguments
    ...    @update: makcamps    15OCT2020    - added upper case method for borrower name in facility notebook
    ...    @update: makcamps    25NOV2020    - updated java window name to Borrower/Depositor.*
    [Arguments]    ${sCurrency}    ${sFacility_BorrowerSGName}    ${sFacility_BorrowerPercent}    ${sFacility_Borrower}    ${sFacility_GlobalLimit}    ${sFacility_BorrowerMaturity}    ${sFacility_EffectiveDate}=None
    ...    ${sAdd_All}=Y    ${sRiskType}=None    ${sCurrency_Name}=None    ${sSublimitName}=None
    
    ### GetRuntime Keyword Pre-processing ###
    ${Currency}    Acquire Argument Value    ${sCurrency}
    ${Facility_BorrowerSGName}    Acquire Argument Value    ${sFacility_BorrowerSGName}
    ${Facility_BorrowerPercent}    Acquire Argument Value    ${sFacility_BorrowerPercent}
    ${Facility_Borrower}    Acquire Argument Value    ${sFacility_Borrower}
    ${Facility_GlobalLimit}    Acquire Argument Value    ${sFacility_GlobalLimit}
    ${Facility_BorrowerMaturity}    Acquire Argument Value    ${sFacility_BorrowerMaturity}
    ${Facility_EffectiveDate}    Acquire Argument Value    ${sFacility_EffectiveDate}
    ${Add_All}    Acquire Argument Value    ${sAdd_All}
    ${RiskType}    Acquire Argument Value    ${sRiskType}
    ${Currency_Name}    Acquire Argument Value    ${sCurrency_Name}
    ${SublimitName}    Acquire Argument Value    ${sSublimitName}
 
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Sublimit/Cust
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window     ${LIQ_BorrowerDepositorSelect_Window}  
    Mx LoanIQ Select Combo Box Value    ${LIQ_BorrowerDepositorSelect_AddBorrower_Name_Field}    ${Facility_Borrower}
    Validation on Borrower Window
    ${status}    Run Keyword And Return Status    Verify If Text Value Exist as Static Text on Page    Borrower/Depositor Select    ${Currency}
    Run Keyword If    ${status}==True    Log    Currency text is validated.
    ...    ELSE IF    ${status}==False    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Borrower/Depositor.*").JavaStaticText("text:=.*${Currency}.*")                    VerificationData="Yes"
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Borrower/Depositor Select    ${Facility_BorrowerSGName.upper()}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Borrower/Depositor.*").JavaEdit("value:=${Facility_BorrowerPercent}","attached text:=Percent:")    VerificationData="Yes"
    Validate Loan IQ Details    ${Facility_Borrower}   ${LIQ_BorrowerDepositorSelect_AddBorrower_Name_Field}    
    Validate Loan IQ Details    ${Facility_GlobalLimit}   ${LIQ_BorrowerDepositorSelect_AddBorrower_GlobalLimit_Field}   
    Validate Loan IQ Details    ${Facility_BorrowerMaturity}   ${LIQ_BorrowerDepositorSelect_AddBorrower_Maturity_Field}
    Run Keyword If    '${Facility_EffectiveDate}'!='None'    Validate Loan IQ Details    ${Facility_EffectiveDate}    ${LIQ_BorrowerDepositorSelect_AddBorrower_EffectiveDate_Field}
    Run Keyword If    '${Add_All}' == 'Y'    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_AddAll_Button}
    Run Keyword If    '${Add_All}' == 'N'    Run Keyword If    '${SublimitName}' != 'None'    Add Borrower Sublimits Limits    ${SublimitName} 
    Run Keyword If    '${Add_All}' == 'N'    Run Keyword If    '${RiskType}' != 'None'    Add Borrower Risk Type Limits    ${RiskType}                   
    Run Keyword If    '${Add_All}' == 'N'    Run Keyword If    '${Currency_Name}' != 'None'    Add Borrower Currency Limits    ${Currency_Name} 
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_OK_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_SublimitCust
   
Validation on Borrower Window
    [Documentation]    This keyword verifies elements on borrower window
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_Sublimit_JavaTree}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_RiskType_JavaTree}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_Currency_JavaTree}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_AddAll_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_Cancel_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_AddCurrency_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_DeleteCurrency_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_AddSublimit_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_DeleteSublimit_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_AddRisk_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BorrowerDepositorSelect_AddBorrower_DeleteRisk_Button}        VerificationData="Yes"
        
Add Currency Limit
    [Documentation]    This keyword adds a currency limit on a facility.
    ...    @author: fmamaril
    ...    @updated: mnanquil
    ...    Changed verify text in javatree to mx loan iq select string.
    ...    Changed Validate Loan IQ Details on line 314 to verify currency. Issue encountered was
    ...    that the old keyword is working only for AUD currency but not with multiple currency.
    ...    Changed made was to verify if object with specified currency is existing.
    ...    <update> fmamaril: Added option to enter Loan Repricing FX Tolerance  
    ...    @updated: rtarayao
    ...    Created a loop to handle multiple Currency limits. 
    ...    Ex Multiple Input: Currency 1 | Currency 2 | Currency 3 and so on..
    ...    Ex Single Input: Currency 1
    [Arguments]    ${Currency}    ${GlobalLimit}    ${CustomerServicingGroupCurrency}    ${Facility_SLAlias}    ${CurrencyLimit_LoanRepricingFXTolerance}=None
    @{CurrencyArray}    Split String    ${Currency}    |
    ${CurrencyCount}    Get Length    ${CurrencyArray}  
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Restrictions
    :FOR    ${INDEX}    IN RANGE    ${CurrencyCount}
    \    ${Currency}    Strip String    ${SPACE}@{CurrencyArray}[${INDEX}]${SPACE}
    \    mx LoanIQ click    ${LIQ_Facility_Restriction_Add_Button}       
    \    Mx LoanIQ Select String    ${LIQ_Facility_SelectCurrency_JavaTree}    ${Currency}
    \    mx LoanIQ click    ${LIQ_Facility_SelectCurrency_OK_Button}
    \    mx LoanIQ activate window     ${LIQ_CurrencyDetail_Window}
    \    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_CurrencyDetail_Window}    VerificationData="Yes"
    \    Validate Loan IQ Details    ${GlobalLimit}   ${LIQ_CurrencyDetail_DrawLimit_Field}    
    \    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Currency Detail").JavaStaticText("attached text:=${Currency}")        VerificationData="Yes"
    \    mx LoanIQ click    ${LIQ_CurrencyDetail_ServicingGroup_Button}
    \    mx LoanIQ activate window     ${LIQ_ServicingGroupForProductCurrency_Window}
    \    Mx LoanIQ Select Combo Box Value    ${LIQ_ServicingGroupForProductCurrency_Customer_List}    ${CustomerServicingGroupCurrency}
    \    mx LoanIQ click    ${LIQ_ServicingGroupForProductCurrency_ServicingGroup_Button}
    \    Mx LoanIQ Select String    ${LIQ_ServicingGroupForProductCurrency_ServicingGroup_Tree}    ${Facility_SLAlias}
    \    mx LoanIQ click    ${LIQ_ServicingGroupForProductCurrency_OK_Button}
    \    mx LoanIQ activate window     ${LIQ_ServicingGroupForProductCurrency_Window}
    \    mx LoanIQ click    ${LIQ_ServicingGroupForProductCurrencySelector_OK_Button}
    \    mx LoanIQ click    ${LIQ_CurrencyDetail_PreferredRI_Button}
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}   
    \    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Ok_Button}
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    \    mx LoanIQ click    ${LIQ_CurrencyDetail_OK_Button}
    \    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    \    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_Facility_Restriction_JavaTree}    ${Currency}
    Run Keyword If    '${CurrencyLimit_LoanRepricingFXTolerance}' != 'None'    mx LoanIQ enter    ${LIQ_Facility_Restriction_RepricingFXTolerance_Field}    ${CurrencyLimit_LoanRepricingFXTolerance}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Restrictions

Validate Facility
    [Documentation]    This keyword validates a facility for closing.
    ...    @author: fmamaril
    ...    @update: bernchua    20AUG2019    Used generic keyword for warning messages
    ...    @update: ritragel    09SEP2019    Added another Warning message for Non Business Dates
    ...    @update: ehugo    30JUN2020    - added screenshot; added another handling for warning message for Non Business Dates
    ...    @update: fluberio    27NOV2020    - added clicking of warning Yes button if present
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    File    Save
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    Options    Validate for Deal Close
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_ValidationMessage}    VerificationData="Yes"
    Run Keyword If    '${status}'=='${TRUE}'    mx LoanIQ click element if present    ${LIQ_Facility_ValidationMessage_OK_Button}
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_ValidateFacility
    
Add Facility Currency
    [Documentation]    This keyword adds a currency on the facility
    ...    @author: fmamaril
    ...    @update: ehugo    29MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sFacilityCurrency}    ${Currency_DrawLimit}=FLOAT

    ### GetRuntime Keyword Pre-processing ###
    ${FacilityCurrency}    Acquire Argument Value    ${sFacilityCurrency}

    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Restrictions
    mx LoanIQ click    ${LIQ_Facility_Restriction_Add_Button}
    Mx LoanIQ Select String    ${LIQ_Facility_SelectCurrency_JavaTree}    ${FacilityCurrency}    
    mx LoanIQ click    ${LIQ_Facility_SelectCurrency_OK_Button}    
    mx LoanIQ click    ${LIQ_CurrencyDetail_OK_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_RestrictionsTab_Currency
    
Add Facility Ongoing Fees
    [Documentation]    Adds Ongoing Fees on the Facility Notebook's Ongoing Fee Pricing window.
    ...    ${FormulaCategoryType} = The Formula Category the Ongoing Fee will be using (Flat Amount / Formula)
    ...    @update: bernchua    20AUG2019    Updated keyword documentation
    ...    @update: dahijara    26JUN2020    - added keyword pre-processing and keyword for screenshot
    [Arguments]    ${sOngoingFee_Category}    ${sOngoingFee_Type}    ${sOngoingFee_RateBasis}    ${sOngoingFee_AfterItem}    
    ...    ${sOngoingFee_AfterItem_Type}    ${sFormulaCategoryType}    ${sOngoingFee_SpreadType}    ${sOngoingFee_SpreadAmount}

    ### GetRuntime Keyword Pre-processing ###
    ${OngoingFee_Category}    Acquire Argument Value    ${sOngoingFee_Category}
    ${OngoingFee_Type}    Acquire Argument Value    ${sOngoingFee_Type}
    ${OngoingFee_RateBasis}    Acquire Argument Value    ${sOngoingFee_RateBasis}
    ${OngoingFee_AfterItem}    Acquire Argument Value    ${sOngoingFee_AfterItem}
    ${OngoingFee_AfterItem_Type}    Acquire Argument Value    ${sOngoingFee_AfterItem_Type}
    ${FormulaCategoryType}    Acquire Argument Value    ${sFormulaCategoryType}
    ${OngoingFee_SpreadType}    Acquire Argument Value    ${sOngoingFee_SpreadType}
    ${OngoingFee_SpreadAmount}    Acquire Argument Value    ${sOngoingFee_SpreadAmount}

    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("items count:=0")    VerificationData="Yes"
    Run Keyword If    ${status}==False    Mx Press Combination    Key.UP
    ${ContinueAdd}    Run Keyword    Add Item to Facility Ongoing Fee or Interest   ${OngoingFee_Category}    ${OngoingFee_Type}
    Run Keyword If    ${ContinueAdd}==True    Run Keywords
    ...    Set Fee Selection Details    ${OngoingFee_Category}    ${OngoingFee_Type}    ${OngoingFee_RateBasis}
    ...    AND    Add After Item to Facility Ongoing Fee    ${OngoingFee_Type}    ${OngoingFee_AfterItem}    ${OngoingFee_AfterItem_Type}
    ...    AND    Set Formula Category For Fees    ${FormulaCategoryType}    ${OngoingFee_SpreadAmount}    ${OngoingFee_SpreadType}
    ...    AND    Validate Facility Pricing Items    ${OngoingFee_Category}
    ...    AND    Validate Facility Pricing Items    ${OngoingFee_Type}
    ...    AND    Validate Facility Pricing Items    ${OngoingFee_SpreadAmount}    ${OngoingFee_SpreadType}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_OngoingFeePricing

Validate Ongoing Fee or Interest
    [Documentation]    This keyword clicks the 'Validate' button and verifies if added fees are complete.
    ...    @author: bernchua
    ...    @update: rtarayao    04MAR2019    Added an action to Click on OK button to close the window.
    ...    @update: bernchua    20AUG2019    Added click element if present for warning message
    ...    @update: dahijara    26JUN2020    - added keyword for screenshot
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_Validate_Button}
    mx LoanIQ activate    ${LIQ_Congratulations_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Congratulations_Window}        VerificationData="Yes"
    ${OngoingFee_ValidationPassed}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Congratulations_MessageBox}    value%Validation completed successfully.
    Run Keyword If    ${OngoingFee_ValidationPassed}==True    Run Keywords    Log    Ongoing Fee Validation Passed.
    ...    AND    mx LoanIQ click element if present    ${LIQ_Congratulations_OK_Button}
    ...    AND    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_OK_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_OngoingFeeInterest_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_OngoingFeePricing

Add Facility Interest
    [Documentation]    Set ups the Interest Pricing of the Facility Notebook.
    ...                @author: bernchua
    ...    
    ...    Interest_JavaTreeValue
    ...    -    Any variable that was previously added in the Interest Pricing window Tree.
    ...    -    This is the first value to be selected (if existing) in the Interest Pricing window, for the 'Add' button to be enabled.
    ...    -    Used in 'Validate Interest Pricing Window for Add' keyword.
    ...    
    ...    @update: bernchua : Added new arguments 'RateFormula', 'RateFormulaUsage' with default values ${EMPTY}
    ...    @update: ehugo    30JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sInterest_Category}    ${sInterest_OptionName}    ${sInterest_RateBasis}
    ...    ${sInterest_SpreadType}    ${sInterest_SpreadValue}    ${sInterest_BaseRateCode}
    ...    ${sRateFormula}=${EMPTY}    ${sRateFormulaUsage}=${EMPTY}

    ### GetRuntime Keyword Pre-processing ###
    ${Interest_Category}    Acquire Argument Value    ${sInterest_Category}
    ${Interest_OptionName}    Acquire Argument Value    ${sInterest_OptionName}
    ${Interest_RateBasis}    Acquire Argument Value    ${sInterest_RateBasis}
    ${Interest_SpreadType}    Acquire Argument Value    ${sInterest_SpreadType}
    ${Interest_SpreadValue}    Acquire Argument Value    ${sInterest_SpreadValue}
    ${Interest_BaseRateCode}    Acquire Argument Value    ${sInterest_BaseRateCode}
    ${RateFormula}    Acquire Argument Value    ${sRateFormula}
    ${RateFormulaUsage}    Acquire Argument Value    ${sRateFormulaUsage}

    mx LoanIQ activate    ${LIQ_FacilityPricing_OngoingFeeInterest_Window}
    ${AddStatus}    Validate Interest Pricing Window for Add
    ${InitialAdd}    Run Keyword And Return Status    Should Be Equal    ${AddStatus}    Initial Add
    ${NextAdd}    Run Keyword And Return Status    Should Be Equal    ${AddStatus}    Next Add
    ${NewAddFromPricing}    Run Keyword And Return Status    Should Be Equal    ${AddStatus}    New Add From Pricing
    Run Keyword If    ${InitialAdd} == True or ${NewAddFromPricing} == True    Add Item to Facility Ongoing Fee or Interest    ${Interest_Category}    ${Interest_OptionName}
    ...    ELSE IF    ${NextAdd} == True    mx LoanIQ activate    ${LIQ_FacilityPricing_Interest_OptionCondition_Window}
    Set Option Condition Details    ${Interest_OptionName}    ${Interest_RateBasis}
    Set Formula Category For Interest    ${Interest_SpreadType}    ${Interest_SpreadValue}    ${Interest_BaseRateCode}    ${RateFormula}    ${RateFormulaUsage}
    Validate Facility Pricing Items    ${Interest_OptionName}
    Validate Facility Pricing Items    ${Interest_SpreadValue}    ${Interest_SpreadType}    ${Interest_BaseRateCode}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_AddFacilityInterest
    
Validate Interest Pricing Window for Add
    [Documentation]    This keyword validates if a previously added item is existing in the Facility Interest Pricing window, and if the "Option Condition" window exists.
    ...    @author: bernchua
    ${JavaTree_ValueExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("items count:=2")    VerificationData="Yes"
    # ${JavaTree_ValueExist}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricing_OngoingFeeInterest_Tree}    ${JavaTree_Value}%s   
    ${OptionCondition_WindowExists}    Run Keyword    Validate if Option Condition Window Exist
    Return From Keyword If    ${JavaTree_ValueExist} == False and ${OptionCondition_WindowExists} == False    Initial Add
    Return From Keyword If    ${JavaTree_ValueExist} == True and ${OptionCondition_WindowExists} == True    Next Add
    Return From Keyword If    ${JavaTree_ValueExist} == True and ${OptionCondition_WindowExists} == False    New Add From Pricing
    
Add Item to Facility Ongoing Fee or Interest
    [Documentation]    Adds a new Ongoing Fee or Interest in the Pricing tab of the Facility Notebook.
    ...    @author: bernchua
    [Arguments]    ${Fee_Interest_Category}    ${Fee_Interest_Type}
    ${FinancialRatio_AddItem}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("developer name:=.*Financial Ratio.*")    VerificationData="Yes"
    Run Keyword If    ${FinancialRatio_AddItem}==False    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_Add_Button}
    ...    ELSE IF    ${FinancialRatio_AddItem}==True    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_After_Button}
    ${AddItem_WindowExists}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_AddItem_Window}    VerificationData="Yes"
    Run Keyword If    ${AddItem_WindowExists} == True    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    ${Fee_Interest_Category}
    ${ItemType_IsEmpty}    Run Keyword    Check Add Item Type If Value Exists    ${Fee_Interest_Type}
    Run Keyword If    ${ItemType_IsEmpty}==True    mx LoanIQ click    ${LIQ_AddItem_Cancel_Button}
    ...    ELSE    Run Keywords    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    ${Fee_Interest_Type}
    ...    AND    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    ...    AND    Return From Keyword    True

Add After Item to Facility Ongoing Fee
    [Documentation]    Adds an After Item to an Ongoing Fee in the Facility Notebook.
    ...    @author: bernchua
    [Arguments]    ${OngoingFee_Type}    ${OngoingFee_AfterItem}    ${OngoingFee_AfterItem_Type}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricing_OngoingFeeInterest_Tree}    ${OngoingFee_Type}%s
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_After_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    ${OngoingFee_AfterItem}
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    ${OngoingFee_AfterItem_Type}
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    
Set Formula Category For Interest
    [Documentation]    Sets the details in the Formula Category for the Interest Pricing under the Facility Notebook's Pricing tab.
    ...                @author: bernchua
    ...                @update: bernchua : Added new arguments 'RateFormula', 'RateFormulaUsage' with default values ${EMPTY}
    [Arguments]    ${FormulaCategory_SpreadType}    ${FormulaCategory_SpreadValue}    ${BaseRateCode}
    ...            ${RateFormula}=${EMPTY}    ${RateFormulaUsage}=${EMPTY}
    Mx LoanIQ Set    JavaWindow("title:=Formula Category").JavaRadioButton("attached text:=${FormulaCategory_SpreadType}")    ON
    mx LoanIQ enter    ${LIQ_FormulaCategory_Spread_Textfield}    ${FormulaCategory_SpreadValue}
    ${Get_InterestBaseRateCode}    Mx LoanIQ Get Data    ${LIQ_FormulaCategory_FormulaText_Textfield}    value%code
    Run Keyword If    '${Get_InterestBaseRateCode}'=='${EMPTY}'    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FormulaCategory_Tree}    ${BaseRateCode}%d
    
    Run Keyword If    '${RateFormula}'!='${EMPTY}'    Run Keywords    mx LoanIQ enter    ${LIQ_FormulaCategory_PercentOfRateFormula_Textfield}    ${RateFormula}
    ...    AND    Mx LoanIQ Select Combo Box Value    ${LIQ_FormulaCategory_PercentOfRateFormulaUsage_List}    ${RateFormulaUsage}
    
    mx LoanIQ click    ${LIQ_FormulaCategory_OK_Button}
    mx LoanIQ click element if present    ${LIQ_PleaseConfirm_Yes_Button}
    
Set Formula Category For Fees
    [Documentation]    Sets the details in the Formula Category for Ongoing Fees/Upfront Fees under Deal Notebook's Fees tab or Facility Notebook's Pricing tab.
    ...    
    ...    FormulaCategoryType = The Formula Category that the Fee will be using. Either "Flat Amount" or "Formula".
    ...    Amount = The actual amount of the Fee.
    ...    SpreadType = The spread type used if Formula Category "Formula" is used. Either "Basis Points" or "Percent".
    ...    
    ...    @author: bernchua
    [Arguments]    ${FormulaCategoryType}    ${Amount}    ${SpreadType}=null
    Mx LoanIQ Set    JavaWindow("title:=Formula Category").JavaRadioButton("label:=${FormulaCategoryType}")    ON
    Run Keyword If    '${FormulaCategoryType}'=='Flat Amount'    mx LoanIQ enter    ${LIQ_FormulaCategory_FlatAmount_Textfield}    ${Amount}
    ...    ELSE IF    '${FormulaCategoryType}'=='Formula'    Run Keywords
    ...    Mx LoanIQ Set    JavaWindow("title:=Formula Category").JavaRadioButton("attached text:=${SpreadType}")    ON
    ...    AND    mx LoanIQ enter    ${LIQ_FormulaCategory_Spread_Textfield}    ${Amount}
    mx LoanIQ click    ${LIQ_FormulaCategory_OK_Button}
    
Add New Facility
    [Documentation]    Goes to Facility Navigator from the Deal Notebook and adds a new Facility.
    ...    
    ...    Requires the Deal Name for validation of the Facility Navigator Window Name and Facility Window Name
    ...    Requires the Deal Currency for validation of the Facility Navigator Window Name
    ...    
    ...    @author: bernchua
    ...    @update: bernchua    21AUG2019    - Added Take Screenshot keyword
    ...    @update: gerhabal    27SEP2019    - added Mx Activate Window  before FacilityNavigator Add_Button   
    ...    @update: ehugo    29MAY2020    - added keyword pre-processing for non-unique arguments; updated screenshot location
    [Arguments]    ${sDeal_Name}    ${sDeal_Currency}    ${sFacility_Name}    ${sFacility_Type}    ${sFacility_CmtAmt}    ${sFacility_Currency}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Deal_Currency}    Acquire Argument Value    ${sDeal_Currency}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}    ${ARG_TYPE_UNIQUE_NAME_VALUE}
    ${Facility_Type}    Acquire Argument Value    ${sFacility_Type}
    ${Facility_CmtAmt}    Acquire Argument Value    ${sFacility_CmtAmt}
    ${Facility_Currency}    Acquire Argument Value    ${sFacility_Currency}
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Select Menu Item    ${LIQ_DealNotebook_Window}    Options    Facilities...
	
    ${status}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNavigator_Window}    VerificationData="Yes"
    ${verify}    Run Keyword And Return Status    Run Keyword If    ${status}==True
    ...    Mx LoanIQ Verify Runtime Property    JavaWindow("title:=Facility Navigator - ${Deal_Name} in ${Deal_Currency}")    title%Facility Navigator - ${Deal_Name} in ${Deal_Currency}
    Run Keyword If    ${verify}==True    Run Keywords
    ...    Log    Facility Navigator Name verified from Deal Name
    ...    AND    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}
    ...    AND    mx LoanIQ click    ${LIQ_FacilityNavigator_Add_Button}
    ...    AND    mx LoanIQ enter    ${LIQ_FacilitySelect_FacilityName_Text}    ${Facility_Name}
    ...    AND    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilitySelect_FacilityType_Combobox}    ${Facility_Type}
    ...    AND    mx LoanIQ enter    ${LIQ_FacilitySelect_ProposedCmt_Textfield}    ${Facility_CmtAmt}
    ...    AND    Mx LoanIQ Select Combo Box Value      ${LIQ_FacilitySelect_Currency_List}    ${Facility_Currency}
    ...    AND    Validate Loan IQ Details    ${Facility_Name}    ${LIQ_FacilitySelect_FacilityName_Text}
    ...    AND    Validate Loan IQ Details    ${Facility_Type}    ${LIQ_FacilitySelect_FacilityType_Combobox}
    ...    AND    Validate Loan IQ Details    ${Facility_CmtAmt}    ${LIQ_FacilitySelect_ProposedCmt_Textfield}
    ...    AND    Validate Loan IQ Details    ${Facility_Currency}    ${LIQ_FacilitySelect_Currency_List}
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilitySelect_Window
    ...    AND    mx LoanIQ click    ${LIQ_FacilitySelect_OK_Button}
    ...    AND    Validate Facility Window Summary Tab Details    ${Facility_Name}    ${Facility_CmtAmt}
    
    Save Values of Runtime Execution on Excel File    ${sFacility_Name}    ${Facility_Name}

Validate Facility Window Summary Tab Details
    [Documentation]    This keyword validates the Facility Cmt and Facility Name
    ...    @author: bernchua
    ...    @update: hstone    27AUG2019    Added Facility Current Cmt Amount Validation
    [Arguments]    ${Facility_Name}    ${Facility_CmtAmt}    ${sFacility_CurrAmt}=None
    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNotebook_Window}    VerificationData="Yes"
    Validate Loan IQ Details    ${Facility_CmtAmt}    ${LIQ_FacilitySummary_ProposedCmt_Textfield}
    Run Keyword If    '${sFacility_CurrAmt}'!='None'    Validate Loan IQ Details    ${sFacility_CurrAmt}    ${LIQ_FacilitySummary_CurrentCmt_Textfield}    
    ${Verify_FacilityName}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property
    ...    JavaWindow("title:=Facility -.*").JavaStaticText("text:=${Facility_Name}")    text%${Facility_Name}
    Run Keyword If    ${Verify_FacilityName} == True    Log    Facility Name Verified
    
Set Facility Dates
    [Documentation]    Sets the Agreement, Effective, Expiry & Final Maturity dates of a Facility.
    ...    @author: bernchua
    ...    @update: ehugo    29MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sAgreementDate}    ${sEffectiveDate}    ${sExpiryDate}    ${sFinalMaturityDate}

    ### GetRuntime Keyword Pre-processing ###
    ${AgreementDate}    Acquire Argument Value    ${sAgreementDate}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${ExpiryDate}    Acquire Argument Value    ${sExpiryDate}
    ${FinalMaturityDate}    Acquire Argument Value    ${sFinalMaturityDate}
    
    mx LoanIQ enter    ${LIQ_FacilitySummary_AgreementDate_Datefield}    ${AgreementDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilitySummary_EffectiveDate_Datefield}    ${EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    ${ExpiryDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}    ${FinalMaturityDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_FacilityDates
    
Set Facility Risk Type
    [Documentation]    Adds a Risk Type to the Facility
    ...    @author: bernchua
    ...    @update: bernchua : Added 'RiskType_Limit' argument with FLOAT default value
    ...    @update: ehugo    29MAY2020    - added keyword pre-processing; added screenshot
    ...                                   - used ${RiskType_Limit) variable for populating the field
    ...    @update: clanding    28JUL2020    - refactor ${RiskType_Limit}
    ...    @update: clanding    30JUL2020    - updated hard coded values to global variables
    [Arguments]    ${sRiskType}    ${sRiskType_Limit}=FLOAT

    ### GetRuntime Keyword Pre-processing ###
    ${RiskType}    Acquire Argument Value    ${sRiskType}
    ${RiskType_Limit}    Acquire Argument Value    ${sRiskType_Limit}

    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${TYPES_PURPOSE_TAB}
    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${SUMMARY_TAB}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${TYPES_PURPOSE_TAB}
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_RiskType_Add_Button}
    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityTypesPurpose_RiskType_ComboBox}    ${RiskType}
    mx LoanIQ enter    ${LIQ_RiskType_Limit_Field}    ${RiskType_Limit}    
    ${Active_CheckboxEnabled}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_RiskType_Active_Checkbox}    enabled%1
    Run Keyword If    ${Active_CheckboxEnabled}==False    Mx LoanIQ Set    ${LIQ_RiskType_Active_Checkbox}    ON
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_RiskTypeDetails_OK_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_TypesPurposeTab_RiskType
    
Set Facility Loan Purpose Type
    [Documentation]    Sets the Facility's Loan Purpose Type.
    ...    @author: bernchua
    ...    @update: ehugo    29MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sLoanPurposeType}

    ### GetRuntime Keyword Pre-processing ###
    ${LoanPurposeType}    Acquire Argument Value    ${sLoanPurposeType}

    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Types/Purpose 
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_LoanPurposeTypes_Button}
    Mx LoanIQ Select String    ${LIQ_LoanPurposeTypesSelection_JavaList}    ${LoanPurposeType}    
    mx LoanIQ click    ${LIQ_FacilityTypesPurpose_LoanPurpose_OK_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_TypesPurposeTab_LoanPurposeType
    
Add Facility Borrower
    [Documentation]    Adds a Borrower/Depositor to the Facility with a specified Risk Type.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Sublimit/Cust
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_Button}
    mx LoanIQ click element if present     ${LIQ_Warning_Yes_Button}
    Set Facility Borrower Risk Type    ${ExcelPath}
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_OK_Button}
    
Add Facility Borrower - Add All
    [Documentation]    Adds a Borrower/Depositor to the Facility and Clicks "Add All" in the Borrower/Depositor Select Window.
    ...                @author: bernchua
    ...                @author: bernchua : Added argument 'Borrower_Name' with default value ${EMPTY} used for validation
    ...    @update: ehugo    29MAY2020    - added screenshot
    [Arguments]    ${sBorrower_Name}=${EMPTY}

    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_Name}    Acquire Argument Value    ${sBorrower_Name}

    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Sublimit/Cust
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_Button}
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_AddAll_Button}
    ${BorrowerName_UI}    Run Keyword If    '${Borrower_Name}'!='${EMPTY}'    Mx LoanIQ Get Data    ${LIQ_BorrowerDepositorSelect_AddBorrower_Name_Field}    value%name
    Run Keyword If    '${BorrowerName_UI}'=='${Borrower_Name}'    Log    Borrower ${Borrower_Name} verified.
    ...    ELSE    Log    Borrower name not verified.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_SublimitCustTab_AddBorrower
    
Complete Facility Borrower Setup
    [Documentation]    This keyword completes the adding of Facility Borrower by clicking the OK button in the "Borrower/Depositor Select" window.
    ...    @author: bernchua
    ...    @update: ehugo    29MAY2020    - added screenshot

    mx LoanIQ activate    ${LIQ_BorrowerDepositorSelect_Window}
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_OK_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_SublimitCustTab_Borrower
    
Validate Risk Type in Borrower Select
    [Documentation]    This keyword validates the added Risk Types in the Facility - Borrower/Depositor Select window's Risk Type Limits.
    ...    @update: ehugo    29MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sRiskType}

    ### GetRuntime Keyword Pre-processing ###
    ${RiskType}    Acquire Argument Value    ${sRiskType}

    mx LoanIQ activate    ${LIQ_BorrowerDepositorSelect_Window}
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BorrowerDepositorSelect_AddBorrower_RiskType_JavaTree}    ${RiskType}
    Run Keyword If    ${STATUS}==True    Log    ${RiskType} is successfully added under Risk Type Limits.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_SublimitCustTab_AddBorrower_RiskType
    
Validate Currency Limit in Borrower Select
    [Documentation]    This keyword validates the added currencies in the Facility - Borrower/Depositor Select window's Currency Limits.
    ...    @author: bernchua
    ...    @update: ehugo    29MAY2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sCurrency}

    ### GetRuntime Keyword Pre-processing ###
    ${Currency}    Acquire Argument Value    ${sCurrency}

    mx LoanIQ activate    ${LIQ_BorrowerDepositorSelect_Window}
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BorrowerDepositorSelect_AddBorrower_Currency_JavaTree}    ${Currency}
    Run Keyword If    ${STATUS}==True    Log    ${Currency} is successfully added under Currency Limits.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_SublimitCustTab_AddBorrower_Currency
    
Set Facility Borrower Risk Type
    [Documentation]    Sets the Borrower's Risk Type in the Facility Notebook.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    mx LoanIQ activate    ${LIQ_BorrowerDepositorSelect_Window}
    mx LoanIQ click    ${LIQ_BorrowerDepositorSelect_AddBorrower_AddRisk_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_RiskTypeLimit_RiskType_List}    &{ExcelPath}[Borrower_RiskType]
    mx LoanIQ click    ${LIQ_RiskTypeLimit_OK_Button}
    
Validate Multi CCY Facility
    [Documentation]    Validates the Facility for Multi-Currency.
    ...    @author: bernchua
    ...    @update: ehugo    29MAY2020    - added screenshot

    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_FacilitySummary_MultiCurrencyFacility_Checkbox}    value%1
    Run Keyword If    ${status}==True    Log    Facility is Multi-currency.
    ...    ELSE    Log    Facility is not Multi-currency.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_SummaryTab_MultiCurrencyFacility

Validate Facility Pricing Rule Items
    [Documentation]    This keyword verifies the items listed in the Facility's Pricing Rules tab based on what Pricing Options are added in the Deal Notebook.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sPricingOption}

    ### GetRuntime Keyword Pre-processing ###
    ${PricingOption}    Acquire Argument Value    ${sPricingOption}

    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing Rules
    ${ItemsExist}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricingRules_Option_Tree}    ${PricingOption}%s    
    Run Keyword If    ${ItemsExist}==True    Log    ${PricingOption} is listed.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_PricingRulesTab_ValidatePricingRules

Validate Facility Pricing Items
    [Documentation]    This keyword validates the added Ongoing Fee or Interest Pricing items in the Facility Notebook.
    ...    
    ...    ItemToBeValidated
    ...    -    The name of the Ongoing Fee/Interest.
    ...    -    The Ongoing Fee Category and Type is concatenated as 1 item in the UI, but are validated individually in this keyword.
    ...    -    If to be used to validate the spread, this would be the actual spread amount.
    ...    
    ...    SpreadType = This is required if to be used to validate the spread type, either 'Basis Points' or 'Percent'.
    ...    BaseRateCode = This is required if to be used to validate the spread under Interest Pricing.
    ...    
    ...    @author: bernchua
    ...    @update: dahijara    26JUN2020    - Added keywords for pre-processing.
    [Arguments]    ${sItemToBeValidated}    ${sSpreadType}=null    ${sBaseRateCode}=null

    ### GetRuntime Keyword Pre-processing ###
    ${ItemToBeValidated}    Acquire Argument Value    ${sItemToBeValidated}
    ${SpreadType}    Acquire Argument Value    ${sSpreadType}
    ${BaseRateCode}    Acquire Argument Value    ${sBaseRateCode}

    ${ValidateForSpread}    Run Keyword And Return Status    Should Not Be Equal    ${SpreadType}    null
    ${ValidateForInterest}    Run Keyword And Return Status    Should Not Be Equal    ${BaseRateCode}    null
    Run Keyword If    ${ValidateForSpread}==False    Run Keyword    Validate Facility Pricing First Item    ${ItemToBeValidated}
    ...    ELSE IF    ${ValidateForSpread}==True and ${ValidateForInterest}==False    Run Keyword    Validate Facility Pricing Ongoing Fee Item Spread    ${ItemToBeValidated}    ${SpreadType}
    ...    ELSE IF    ${ValidateForSpread}==True and ${ValidateForInterest}==True    Run Keyword    Validate Facility Pricing Interest Item Spread    ${ItemToBeValidated}    ${SpreadType}    ${BaseRateCode}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_FacilityPricingItems

Validate Facility Pricing First Item
    [Documentation]    This validates the actual name of the Fee or Interest.
    ...    @author: bernchua
    [Arguments]    ${ItemToBeValidated}
    ${ValidatedItem}    Regexp Escape    ${ItemToBeValidated}
    ${FacilityPricingNotebook_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFeeInterest_Window}        VerificationData="Yes"
    ${ItemExist}    Run Keyword If    ${FacilityPricingNotebook_Exist}==True    Run Keyword And Return Status        
    ...    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("developer name:=.*${ValidatedItem}.*")    VerificationData="Yes"
    ...    ELSE    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*${ValidatedItem}.*")    VerificationData="Yes"
    Run Keyword If    ${ItemExist}==True    Log    ${ItemToBeValidated} is listed.
    
Validate Facility Pricing Ongoing Fee Item Spread
    [Documentation]    This validates the actual Ongoing Fee amount or percentage.
    ...    @author: bernchua
    [Arguments]    ${SpreadValue}    ${SpreadType}
    ${BasisPoints}    Run Keyword And Return Status    Should Be Equal    ${SpreadType}    Basis Points
    ${Percent}    Run Keyword And Return Status    Should Be Equal    ${SpreadType}    Percent
    ${SpreadType}    Set Variable If    ${BasisPoints}==True    BP
    ...    ${Percent}==True    %
    ${FacilityPricingNotebook_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFeeInterest_Window}        VerificationData="Yes"
    ${ItemExist}    Run Keyword If    ${FacilityPricingNotebook_Exist}==True    Run Keyword And Return Status
    ...    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("developer name:=.*${SpreadValue}${SpreadType}.*")    VerificationData="Yes"
    ...    ELSE      Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*${SpreadValue}${SpreadType}.*")        VerificationData="Yes"
    Run Keyword If    ${ItemExist}==True    Log    Outstandings X Rate (${SpreadValue}${SpreadType}) is listed.
    
Validate Facility Pricing Interest Item Spread
    [Documentation]    This validates the actual Interest amount or percentage.
    ...    @author: bernchua 
    [Arguments]    ${SpreadValue}    ${SpreadType}    ${BaseRateCode}
    ${BasisPoints}    Run Keyword And Return Status    Should Be Equal    ${SpreadType}    Basis Points
    ${Percent}    Run Keyword And Return Status    Should Be Equal    ${SpreadType}    Percent
    ${SpreadType}    Set Variable If    ${BasisPoints}==True    BP
    ...    ${Percent}==True    %
    ${FacilityPricingNotebook_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFeeInterest_Window}    Processtimeout=3    VerificationData="Yes"
    ${ItemExist}    Run Keyword If    ${FacilityPricingNotebook_Exist}==True    Run Keyword And Return Status
    ...    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("developer name:=.*${BaseRateCode}.*${SpreadValue}${SpreadType}.*")    VerificationData="Yes"
    ...    ELSE    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*${BaseRateCode}.*${SpreadValue}${SpreadType}.*")       VerificationData="Yes"
    Run Keyword If    ${ItemExist}==True    Log    ${BaseRateCode} + Spread (${SpreadValue}${SpreadType}) X PCT (1) is listed.
    
Validate Facility Pricing Window
    [Documentation]    This keyword validates the name of the Facility Pricing window for Ongoing Fees or Interests.
    ...    Since the Facility Pricing window title contains the "Current Business Date", this keyword gets the Current Date from the main LIQ window.
    ...    
    ...    FacilityPricingType = Either "Ongoing Fee" or "Interest"
    ...    
    ...    @author: bernchua
    ...    @update: dahijara    26JUN2020    - added keyword for screenshot. added keyword processing for ${Facility_PricingType}
    [Arguments]    ${sFacility_Name}    ${sFacility_PricingType}
	### GetRuntime Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Facility_PricingType}    Acquire Argument Value    ${sFacility_PricingType}
    
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    ${WindowTitle}    Mx LoanIQ Get Data    ${LIQ_Window}    title%LIQtitle
    ${CurrentDate}    Fetch From Right    ${WindowTitle}    :
    ${CurrentDate}    Strip String    ${CurrentDate}    mode=left
    ${result}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${Facility_Name}.*${CurrentDate}.*${Facility_PricingType}.*")        VerificationData="Yes"
    Run Keyword If    ${result}==True    Log    Facility ${Facility_PricingType} Pricing window exists.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_FacilityPricing

Validate General Information Details
    [Documentation]     This keyword validates the SIC of the facility based on the borrower.
    ...    @author: henstone
    ...    @update: mcastro    27Aug2020    Added screenshot with correct path
    [Arguments]    ${SIC}    ${OwningBranch}    ${FundingDesk}    ${ProcessingArea}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Codes
    
    ### Static Text Verify: SIC ###
    ${Verify_SIC}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property
    ...    JavaWindow("title:=Facility -.*").JavaStaticText("text:=${SIC}")    text%${SIC}
    Run Keyword If    ${Verify_SIC} == True    Log    SIC Verified
    
    ### Static Text Verify: Owning Branch ###
    ${Verify_OwningBranch}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property
    ...    JavaWindow("title:=Facility -.*").JavaStaticText("text:=${OwningBranch}")    text%${OwningBranch}
    Run Keyword If    ${Verify_OwningBranch} == True    Log    SIC Verified
    
    ### Static Text Verify: Funding Desk ###
    ${Verify_FundingDesk}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property
    ...    JavaWindow("title:=Facility -.*").JavaStaticText("text:=${FundingDesk}")    text%${FundingDesk}
    Run Keyword If    ${Verify_FundingDesk} == True    Log    SIC Verified
    
    ### Static Text Verify: Processing Area ###
    ${Verify_ProcessingArea}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property
    ...    JavaWindow("title:=Facility -.*").JavaStaticText("text:=${ProcessingArea}")    text%${ProcessingArea}
    Run Keyword If    ${Verify_ProcessingArea} == True    Log    SIC Verified
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Codes Tab
    
Verify If Facility Window Does Not Exist
    [Documentation]    This keyword validates if the Facility Window is not existing then navigates from Deal Notebook
    ...    @autor: jdelacruz
    ...    @update: amansuet    22JUN2020    - updated keyword by removing navigation as there is an existing keyword for navigation.

    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNotebook_Window}    VerificationData="Yes"
    Run Keyword If    '${Status}' == 'False'    Log    Facility Window is not displayed.
    ...    ELSE    Fail    Facility Window is displayed.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanIQWindow

Navigate to Facility Notebook  
    [Documentation]    This keyword is used to navigate the user from the LIQ homepage to the Facility Notebook of a Deal.
    ...    @author: rtarayao
    ...    @update: amansuet    24APR2020    Updated to align with automation standards and added keyword pre-processing
    ...    @update: hstone      22MAY2020    - Added Take Screenshot
    ...    @update: clanding    26NOV2020    - added mx LoanIQ click element if present    ${LIQ_Alerts_OK_Button}
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}   

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    Open Existing Deal    ${Deal_Name}
    Navigate to Facility Notebook from Deal Notebook    ${Facility_Name}
    mx LoanIQ click element if present    ${LIQ_Alerts_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook
     
Check Pending Transaction in Facility
    [Documentation]    This keyword is used to check there is/are pending transaction in a facility
    ...    @author: ghabal   
    ...    @update: dfajardo 22JUL2020    -Added pre processing and screenshot
    [Arguments]    ${sDeal_Name}    ${sFacility_Name} 
   
    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}     
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    Navigate to Facility Notebook from Deal Notebook    ${Facility_Name}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Pending
    Run Keyword And Continue On Failure    mx LoanIQ activate window    JavaWindow("title:=.*${Facility_Name}.*${Deal_Name}.*").JavaTree("attached text:=Pending Transactions.*","items count:=0")
    ${result}    Run Keyword And Return Status    mx LoanIQ activate window    JavaWindow("title:=.*${Facility_Name}.*${Deal_Name}.*").JavaTree("attached text:=Pending Transactions.*","items count:=0")    
    Run Keyword If   '${result}'=='True'    Log    "Confirmed. There is no pending transaction in the Facility"
    ...     ELSE    Log    "Termination Halted. There is/are pending transaction in the Facility.  Please settle these transactions first."
       
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Pending

    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}    
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
      
  
      
Modify Current Amortization Schedule
    [Documentation]    This keyword is used to modify the current amortization schedule
    ...    @author: ghabal
    ...    @update: fmamaril  
    ...    @update: dfajardo    22JUL2020    - Added Screenshot  
    [Arguments]    ${rowid}
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Inc/Dec Schedule
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_CreateModifyScheduleButton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_Window}
    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_List}    Scheduled        
    ${CurrentBusinessDate}    Get System Date
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_ModifyButton}    
    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_ModifyScheduleItem_ScheduleDateField}    ${CurrentBusinessDate}                      
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_ModifyScheduleItem_OKButton}
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_Window}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_SaveButton}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityNotebook_FacilityChangeTrasaction
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_ExitButton}      
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_Window}
   
Navigate to Ammortization Schedule for Facility Change Transaction
    [Documentation]    This keyword is used to navigate to Ammortization Schedule for Facility Change Transaction Window.
    ...    @author: hstone    19AUG2019    INITIAL CREATE
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Inc/Dec Schedule
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_CreateModifyScheduleButton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
   
Modify Current Amortization Amount
    [Documentation]    This keyword is used to modify the current amortization schedule
    ...    @author: hstone    19AUG2019    INITIAL CREATE
    [Arguments]    ${sChangeType}    ${sAmount}    ${sDate}=None
    ${Change_Type}    Convert To Uppercase    ${sChangeType}
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_Window}
    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_List}    Scheduled        
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_ModifyButton}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${Change_Type}'=='DECREASE'    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_ModifyScheduleItem_Decrease_RadioButton}    ON 
    ...    ELSE    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_ModifyScheduleItem_Increase_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_ModifyScheduleItem_AmountField}    ${sAmount}
    Run Keyword If    '${sDate}'!='None'    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_ModifyScheduleItem_ScheduleDateField}    ${sDate}                      
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_ModifyScheduleItem_OKButton}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
 
Add Scheduled Facility Limit Change
    [Documentation]    This keyword is used to add amortization schedule
    ...    @author: hstone    19AUG2019    INITIAL CREATE 
    [Arguments]    ${sChangeType}    ${sAmount}    ${sDate}=None
    ${Change_Type}    Convert To Uppercase    ${sChangeType}
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_Window}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_AddButton}   
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Run Keyword If    '${Change_Type}'=='DECREASE'    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_AddScheduleItem_Decrease_RadioButton}    ON 
    ...    ELSE    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_AddScheduleItem_Increase_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_AddScheduleItem_AmountField}    ${sAmount}   
    Run Keyword If    '${sDate}'!='None'    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_AddScheduleItem_ScheduleDateField}    ${sDate}                    
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AddScheduleItem_OKButton}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
   
Validate Facility Current Commitment Amount
    [Documentation]    This keyword is used to verify the current commitment amount.
    ...    @author: hstone    20AUG2019    INITIAL CREATE
    [Arguments]    ${sExpectedCurrentCmtAmount}
    # ${iExpectedCurrentCmtAmount}    Convert To Number    ${sExpectedCurrentCmtAmount}    
    ${DisplayedCurrentCommitment}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__CurrentCommitment_Field}    testdata
    # Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${DisplayedCurrentCommitment}    ${iExpectedCurrentCmtAmount}        
    ${result}    Run Keyword And Return Status    Should Be Equal    ${DisplayedCurrentCommitment}    ${sExpectedCurrentCmtAmount}
    Run Keyword If   '${result}'=='True'    Log    "Current Commitment Amount is confirmed ${DisplayedCurrentCommitment}"    
    ...     ELSE    Log    "Current Commitment Amount is ${DisplayedCurrentCommitment} instead of ${sExpectedCurrentCmtAmount}"
      
Save Scheduled Facility Limit Change
    [Documentation]    This keyword is used to save amortization schedule settings.
    ...    @author: hstone    19AUG2019    INITIAL CREATE   
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_Window}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_SaveButton}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_ExitButton}      
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflow_FacilityChangeTransaction_ModifyScheduleItem   

Create Pending Transaction from Schedule item
    [Documentation]    This keyword is used to create pending transaction from Schedule Item
    ...    @author: ghabal
    ...    @update: fmamaril    24APR2019    Remove Read Data on low level keyword
    ...    @update: hstone    23AUG2019    Added Take Screenshow on Ammortization Schedule
    ...    @update: dfajardo    22JUL2020    Added pre processing and screenshot
    [Arguments]    ${sEffectiveDate}
   
    ### Keyword Pre-processing ###
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}

    mx LoanIQ select    ${LIQ_FacilityNotebook_Options_IncreaseDecreaseSchedule}
    
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_Window}
   
    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_List}    Scheduled
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_FacilityChangeTransaction   
   
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_AmortizationSchedule_CreatePendingButton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_CreatePending_EffectiveDateField}    ${EffectiveDate}   
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_CreatePending_OKButton}   
  
      
   
Verify if Facility is Terminated
    [Documentation]    This keyword is used to check if the Facility is terminated
    ...    @author: ghabal
    ...    @author: dfajardo    22JUL2020    Added pre processing keywords and screenshot
    [Arguments]    ${sDeal_Name}    ${sTerminatedFacility_Status}
   
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}   
    ${TerminatedFacility_Status}    Acquire Argument Value    ${sTerminatedFacility_Status}  

    Open Existing Deal    ${Deal_Name}    
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    ${FacilityStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityNavigator_FacilitySelection}    ${TerminatedFacility_Status}%Status%FacilityStatus
    Log    ${FacilityStatus}
    Run Keyword And Continue On Failure    Should Be Equal As Strings    Terminated    ${FacilityStatus}
    ${result}    Run Keyword And Return Status    Should Be Equal As Strings    Terminated    ${FacilityStatus}    
    Run Keyword If   '${result}'=='True'    Log    Facility is confirmed 'Terminated'"
    ...     ELSE    Log    "Termination Halted. Facility is not 'Terminated'. Please recheck the Facility"   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Options
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}  

Add Interest Pricing Financial Ratio
    [Documentation]    This keyword adds an Interest Pricing Matrix-FinancialRatio in the Facility Notebook.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_FacilityPricing_OngoingFeeInterest_Window}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFeeInterest_NoItems_JavaTree}    VerificationData="Yes"        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${status}==False    Interest Pricing Window Press Up Key Until Add Button is Enabled
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_Add_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    Matrix
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    Financial Ratio
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeInterestWindow_AddInterestPricingFinancialRation

Interest Pricing Window Press Up Key Until Add Button is Enabled
    [Documentation]    @author: bernchua
    :FOR    ${i}    IN RANGE    10
    \    ${AfterButton_Status}    Mx LoanIQ Get Data    ${LIQ_FacilityPricing_OngoingFeeInterest_After_Button}    enabled%after
    \    Run Keyword If    '${AfterButton_Status}'=='0'    Mx Press Combination    KEY.UP
    \    Exit For Loop If    '${AfterButton_Status}'=='1'
    
Set Financial Ratio
    [Documentation]    This keyword sets the Financial Ratio.
    ...    
    ...    | Arguments |
    ...    'RatioType' = The name of the Financial Ratio to be used.
    ...    'MnemonicStatus' = Accepts 'ON' or 'OFF' values.
    ...                       If 'ON', will tick Mnemonic checkbox and set MaximumValue to "Maximum".
    ...                       If 'OFF', will leave Mnemonic checkbox unticked and will require a MaximumValue.
    ...    'GreaterThan', 'LessThan' = Accepts '0' or '1' values.
    ...                                If '0', will enable "Greater/Less Than or Equal" radio button.
    ...                                If '1', will enable "Greater/Less Than" radio button.
    ...    'MinimumValue' = The minimum value of the matrix.
    ...    'MaximumValue' = The maximum value of the matrix. Will require numeric value if Mnemonic checkbox is unticked.
    ...    
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added keyword pre-processing; added screenshot
    ...    @update: clanding    29JUL2020    - updated data type for GreaterThan and LessThan
    [Arguments]    ${sRatioType}    ${sMnemonicStatus}    ${iGreaterThan}    ${iLessThan}    ${sMinimumValue}    ${sMaximumValue}=Maximum

    ### Keyword Pre-processing ###
    ${RatioType}    Acquire Argument Value    ${sRatioType}
    ${MnemonicStatus}    Acquire Argument Value    ${sMnemonicStatus}
    ${GreaterThan}    Acquire Argument Value    ${iGreaterThan}
    ${LessThan}    Acquire Argument Value    ${iLessThan}
    ${MinimumValue}    Acquire Argument Value    ${sMinimumValue}
    ${MaximumValue}    Acquire Argument Value    ${sMaximumValue}

    mx LoanIQ activate    ${LIQ_FinancialRatio_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FinancialRatio_Type_Combobox}    ${RatioType}
    Run Keyword If    '${GreaterThan}'=='0'    Mx LoanIQ Set    ${LIQ_FinancialRatio_GreaterThanEqual_RadioButton}    ON
    ...    ELSE IF    '${GreaterThan}'=='1'    Mx LoanIQ Set    ${LIQ_FinancialRatio_GreaterThan_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_FinancialRatio_MinimumValue_Field}    ${MinimumValue}
    Run Keyword If    '${MnemonicStatus}'=='ON'    Run Keywords
    ...    Mx LoanIQ Set    ${LIQ_FinancialRatio_Mnemonic_CheckBox}    ON
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_FinancialRatio_LessThanEqual_RadioButton}    enabled%1
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_FinancialRatio_Mnemonic_List}    value%${MaximumValue}
    Run Keyword If    '${MnemonicStatus}'=='OFF'    Set Financial Ratio Maximum    ${LessThan}    ${MaximumValue}
    mx LoanIQ click    ${LIQ_FinancialRatio_OK_Button}
    
    ${RatioType_ToVerify}    Regexp Escape    ${RatioType}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("developer name:=.*Financial Ratio.*${RatioType_ToVerify}.*${MinimumValue}.*${MaximumValue}.*")        VerificationData="Yes"        VerificationData="Yes"
    ...    VerificationData="Yes"
    Run Keyword If    ${status}==True    Log    ${RatioType} with minimum value ${MinimumValue} and maximum value ${MaximumValue} has been successfully added.
    ...    ELSE    Fail    Financial Ratio has not been added.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FinancialRatioWindow_SetFinancialRatio
    
Set Financial Ratio Maximum
    [Documentation]    This keyword sets the Maximum value if Mnemonix checkbox is unticked.
    ...    @author: bernchua
    [Arguments]    ${LessThan}    ${MaximumValue}
    Run Keyword If    '${LessThan}'=='0'    Mx LoanIQ Set    ${LIQ_FinancialRatio_LessThanEqual_RadioButton}    ON
    ...    ELSE IF    '${LessThan}'=='1'    Mx LoanIQ Set    ${LIQ_FinancialRatio_LessThan_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_FinancialRatio_MaximumValue_Field}    ${MaximumValue}
    
View/Update Lender Shares Make Selection
    [Documentation]    This keyword selects Options > View/Update Lender Shares in the Facility Notebook, and validates all the objects in the "Make Selection" window.
    ...    @author: bernchua
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps, modified keyword as per BNS framework
    [Arguments]    ${sMakeSelection_Choice}
    
    ### GetRuntime Keyword Pre-processing ###
	${MakeSelection_Choice}    Acquire Argument Value    ${sMakeSelection_Choice}    

    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}    
    mx LoanIQ select    ${LIQ_FacilityNotebook_Options_AdjustLenderShares}
    mx LoanIQ activate    ${LIQ_MakeSelection_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_MakeSelection_ServicingGroupChange_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_MakeSelection_PortfolioTransfer_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_MakeSelection_PortfolioSettledDiscount_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_MakeSelection_PortfolioTradeDate_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_MakeSelection_PortfolioAssignableChange_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_MakeSelection_PortfolioDeferredPLChange_RadioButton}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_MakeSelection_PortfolioDeferredPLIndicator_RadioButton}    VerificationData="Yes"
    Mx LoanIQ Set    JavaWindow("title:=Make Selection").JavaObject("tagname:=Group","text:=Choices").JavaRadioButton("label:=${MakeSelection_Choice}")    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Lender_Shares_Adjust
    mx LoanIQ click    ${LIQ_MakeSelection_OK_Button}

Get Borrower Name From Facility Notebook
    [Documentation]    This keyword gets the Borrower from the Facility Notebook's Sublimit/Cust Tab.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Sublimit/Cust
    ${Borrower}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilitySublimitCust_Borrowers_Tree}    *%Borrower/Depositor%name
    [Return]    ${Borrower}

Get Currency From Facility Notebook
    [Documentation]    This keyword gets the Currency of the Facility.
    ...    It verifies what currency is shown in the UI and returns the appropriate Currency based on what object exists.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    ${CCY_AUD}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaStaticText("attached text:=AUD")    VerificationData="Yes"
    ${CCY_USD}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaStaticText("attached text:=USD")    VerificationData="Yes"
    ${Currency}    Set Variable If    ${CCY_AUD}==True    AUD
    ...    ELSE IF    ${CCY_USD}==True    USD
    [Return]    ${Currency}
    
Launch Existing Facility
    [Documentation]    This keyword is used for launching Facility Notebook via Facility Icon.
    ...    @author:mgaling
    ...    @update: hstone    28APR2020    - Added Keyword Pre-process: Acquire Argument Value
    ...    @update: ehugo    01JUN2020    - added screenshot
    ...    @update: dahijara    03JUL2020    - added code for press TAB before clicking of search button 
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}    

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    
    Select Actions    [Actions];Facility
    mx LoanIQ activate window    ${LIQ_FacilitySelect_Window}
    Mx LoanIQ Set    ${LIQ_FacilitySelect_Existing_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_FacilitySelect_DealName_Textfield}    ${Deal_Name}
    Mx Press Combination    KEY.TAB
    mx LoanIQ click    ${LIQ_FacilitySelect_Search_Button}    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Search_Facility}    ${Facility_Name}%d  

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook
    
Navigate to Commitment Fee Notebook
    [Documentation]    This keyword is used for navigating Commitment Fee Notebook
    ...    @author:mgaling
    ...    @update: added pre processing keyword and screenshot
    [Arguments]    ${sOngoingFee_Type}    
    ### GetRuntime Keyword Pre-processing ###
    ${OngoingFee_Type}    Acquire Argument Value    ${sOngoingFee_Type}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_OngoingFeeList}
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_FeeList
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Facility_FeeList_JavaTree}    ${OngoingFee_Type}%d

Navigate to Outstanding Select Window
    [Documentation]    This keyword enables the LIQ User to navigate to the Outstanding Select window thru the Facility Notebook.
    ...    @author: rtarayao
    ...    @update: clanding    10AUG2020    - added screenshot
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}       
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_OutstandingSelect}
    mx LoanIQ activate    ${LIQ_OutstandingSelect_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelectWindow

Navigate to Facility Increase Decrease Schedule
    [Documentation]    This keyword will navigate to Increase/Decrease Schedule in Facility
    ...    @author: ritragel
    ...    @update: dahijara    01JUL2020 - Added keyword pre-processing
    [Arguments]    ${sFacility2_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Facility2_Name}    Acquire Argument Value    ${sFacility2_Name}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityNavigator_Tree}    ${Facility2_Name}%d    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}  
    mx LoanIQ select    ${LIQ_FacilityNotebook_Options_IncreaseDecreaseSchedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Enter Date With Business Day and Non-Business Day Validations
    [Documentation]    This keyword enters a date in LIQ and validates it in relation to the Calendar API Business Days and Non-Business Days.
    ...                @author: bernchua
    ...    @update: dahijara    23JUL2020    - Added TAB press action after entering the date.
    [Arguments]    ${Locator}    ${Date}    ${HolidayName}=${EMPTY}
    ${Day}    Convert Date    ${Date}    date_format=%d-%b-%Y    result_format=%a
    mx LoanIQ enter    ${Locator}    ${Date}
    Mx Press Combination    KEY.TAB
    Run Keyword If    '${HolidayName}'!='${EMPTY}'    Verify Date For Non-Business Day    ${Date}    ${HolidayName}
    Verify Date If Converted To Business Date    ${Date}    ${Day}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Enter Facility Dates With Business Day and Non-Business Day Validations for Term Facility
    [Documentation]    This keyword enters a date in LIQ and validates it in relation to the Calendar API Business Days and Non-Business Days.
    ...                @author: ehugo    30JUN2020    - initial create
    [Arguments]    ${sCurrentDate}    ${sNBD_ExpiryDate}    ${sNBD_HolidayName}    ${sMaturityDate}    ${sExpiryDate}

    ### GetRuntime Keyword Pre-processing ###
    ${CurrentDate}    Acquire Argument Value    ${sCurrentDate}
    ${NBD_ExpiryDate}    Acquire Argument Value    ${sNBD_ExpiryDate}
    ${NBD_HolidayName}    Acquire Argument Value    ${sNBD_HolidayName}
    ${MaturityDate}    Acquire Argument Value    ${sMaturityDate}
    ${ExpiryDate}    Acquire Argument Value    ${sExpiryDate}
    
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_AgreementDate_Datefield}    ${CurrentDate}
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_EffectiveDate_Datefield}    ${CurrentDate}
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    ${NBD_ExpiryDate}    ${NBD_HolidayName}
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}    ${MaturityDate}
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    ${ExpiryDate}

Enter Facility Dates With Business Day and Non-Business Day Validations for Revolver Facility
    [Documentation]    This keyword enters a date in LIQ and validates it in relation to the Calendar API Business Days and Non-Business Days.
    ...                @author: ehugo    30JUN2020    - initial create
    [Arguments]    ${sCurrentDate}    ${sNBD_MaturityDate}    ${sNBD_HolidayName}    ${sMaturityDate}    ${sExpiryDate}

    ### GetRuntime Keyword Pre-processing ###
    ${CurrentDate}    Acquire Argument Value    ${sCurrentDate}
    ${ExpiryDate}    Acquire Argument Value    ${sExpiryDate}
    ${NBD_MaturityDate}    Acquire Argument Value    ${sNBD_MaturityDate}
    ${NBD_HolidayName}    Acquire Argument Value    ${sNBD_HolidayName}
    ${MaturityDate}    Acquire Argument Value    ${sMaturityDate}
    
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_AgreementDate_Datefield}    ${CurrentDate}
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_EffectiveDate_Datefield}    ${CurrentDate}
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    ${ExpiryDate}
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}    ${NBD_MaturityDate}    ${NBD_HolidayName}
    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}    ${MaturityDate}
    
Verify Date For Non-Business Day
    [Documentation]    This keyword verifies a date if it's a non-business day.
    ...    @author: bernchua
    ...    @update: bernchua    27MAR2019    Added validation for warning message "cannot be less than expiration date".
    [Arguments]    ${APICalender_Date}    ${APICalendar_HolidayName}
    ${warning_exist}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    ${message}    Run Keyword If    ${warning_exist}==True    Mx LoanIQ Get Data    ${LIQ_Warning_MessageBox}    text%message
    ${verify_ifNBD}    Run Keyword And Return Status    Should Contain    ${message}    non-business day
    ${verify_ifLess}    Run Keyword And Return Status    Should Contain    ${message}    cannot be less than
    ${verify_ifRepricingDate}    Run Keyword And Return Status    Should Contain    ${message}    Repricing Date        
    
    Run Keyword If    ${verify_ifNBD}==False or ${verify_ifLess}==True    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    ${HolidayName}    Run Keyword If    ${verify_ifNBD}==True and ${verify_ifLess}==False    Get Holiday Name From NBD Warning Message    ${message}
    ${HolidayDate}    Run Keyword If    ${verify_ifNBD}==True and ${verify_ifRepricingDate}==False and ${verify_ifLess}==False    Get Date From NBD Warning Message    ${message}
    
    Run Keyword If    '${HolidayName}'=='${APICalendar_HolidayName}' and '${HolidayDate}'=='${APICalender_Date}'
    ...    Run Keywords
    ...    Log    ${HolidayDate} falls on ${HolidayName}, and verified as a Non-Business Day.
    ...    AND    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    ...    ELSE IF    '${HolidayName}'=='${APICalendar_HolidayName}' and '${HolidayDate}'!='${APICalender_Date}'
    ...    Run Keywords
    ...    Log    Repricing Date ${APICalender_Date} falls on ${HolidayName}, and verified as a Non-Business Day.
    ...    AND    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    
Get Holiday Name From NBD Warning Message
    [Documentation]    This keyword gets the Holiday Name from the warning message if a date is a Non-Business date.
    ...    @author: bernchhua
    [Arguments]    ${message}
    ${HolidayName}    Fetch From Left    ${message}    ,
    ${HolidayName}    Fetch From Right    ${HolidayName}    falls on
    ${HolidayName}    Strip String    ${HolidayName}
    Log    ${HolidayName}
    [Return]    ${HolidayName}

Get Date From NBD Warning Message
    [Documentation]    This keywords gets the Date from the warning message for Non-Business Day dates.
    ...    @author: bernchua
    [Arguments]    ${message}
    ${HolidayDate}    Fetch From Left    ${message}    )
    ${HolidayDate}    Fetch From Right    ${HolidayDate}    (
    Log    ${HolidayDate}
    [Return]    ${HolidayDate}
    
Verify Date If Converted To Business Date
    [Documentation]    This keyword verifies a date if it's a Non-Business date updated to a Business Date.
    ...    @author: bernchua
    [Arguments]    ${Date}    ${Day}
    ${warning_exist}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    Run Keyword If    '${Day}'=='Sat' and ${warning_exist}==False    Log    ${Date} falls on a Saturday. It is a Non-Business Date converted to a Business Date.
    ...    ELSE IF    '${Day}'=='Sun' and ${warning_exist}==False    Log    ${Date} falls on a Sunday. It is a Non-Business Date converted to a Business Date.

Reschedule Facility
    [Documentation]    This keyword will reschedule facility
    ...    @author ritragel
    ...    @update: dahijara    01JUL2020    - added keyword pre-processing. 
    ...    - Replaced Mx Native Type TAB with Mx Press Combination KEY.TAB. 
    ...    - Added screenshot.
    [Arguments]    ${sNumberOfCycle}    ${sFacility_Amount}    ${sCycle_Frequency}    ${sTrigger_Date}
    
    ### GetRuntime Keyword Pre-processing ###
    ${NumberOfCycle}    Acquire Argument Value    ${sNumberOfCycle}
    ${Facility_Amount}    Acquire Argument Value    ${sFacility_Amount}
    ${Cycle_Frequency}    Acquire Argument Value    ${sCycle_Frequency}
    ${Trigger_Date}    Acquire Argument Value    ${sTrigger_Date}

    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
    mx LoanIQ click    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Reschedule_Button}  
    mx LoanIQ click    ${LIQ_PleaseConfirm_Yes_Button} 
    mx LoanIQ activate window    ${LIQ_Facility_AmortizationScheduleSetup_Window}
    mx LoanIQ enter    ${LIQ_Facility_AmortizationScheduleSetup_NoCycItems_Input}    ${sNumberOfCycle}
    Mx Press Combination    KEY.TAB
    mx LoanIQ select    ${LIQ_Facility_AmortizationScheduleSetup_Frequency_Dropdown}    ${sCycle_Frequency}
    Verify if Percentage is Correct    ${sNumberOfCycle}    ${sFacility_Amount}    ${sCycle_Frequency}
    mx LoanIQ enter    ${LIQ_Facility_AmortizationScheduleSetup_TriggerDate_Input}    ${sTrigger_Date}
    Mx Press Combination    KEY.TAB
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_RescheduleFacility
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click    ${LIQ_Facility_AmortizationScheduleSetup_OK_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
      
Verify if Percentage is Correct
    [Documentation]    This keyword will compute if the computed Amount and Percentage is correct from the No Cyc of Items
    ...    @author ritragel
    [Arguments]    ${NumberOfCycle}    ${Facility_Amount}    ${Cycle_Frequency}
    # Compute Amounts and Percentages
    ${Percentage}    Evaluate    100/${NumberOfCycle}
    Log    ${Percentage}
    ${Percentage}    Convert To Number    ${Percentage}
    ${Facility_Amount}    Remove Comma, Negative Character and Convert to Number    ${Facility_Amount}
    ${Facility_Amount}    Convert To Number    ${Facility_Amount}    2
    ${Computed_Amount}    Evaluate    (${Percentage}/100)*${Facility_Amount}
    ${Computed_Amount}    Convert To Number    ${Computed_Amount}    2
    ${Computed Amount}    Convert To String    ${Computed_Amount}
    ${Computed_Amount}    Convert Number With Comma Separators    ${Computed_Amount}
    ${Percentage}    Convert To String    ${Percentage}
    ${Percentage}    Convert To Number    ${Percentage}    4
    # Get Ui Values
    ${UiAmount}    Mx LoanIQ Get Data    ${LIQ_Facility_AmortizationScheduleSetup_Amount_Input}    value%value
    ${UiPercentage}    Mx LoanIQ Get Data    ${LIQ_Facility_AmortizationScheduleSetup_Percentage_Input}    value%value
    ${UiPercentage}    Strip String    ${UiPercentage}    characters=%    
    # Compare the created
    ${result}    Run Keyword And Return Status    Should Be Equal As Strings    ${Computed_Amount}    ${UiAmount}
    Run Keyword If    '${result}'=='True'    Log    Computed Amount is correct    level=INFO
    Run Keyword If    '${result}'=='False'    Log    Computed Amount is correct    level=ERROR  
    ${result}    Run Keyword And Return Status    Should Be Equal As Strings    ${Percentage}    ${UiPercentage}
    Run Keyword If    '${result}'=='True'    Log    Computed Percentage is correct    level=INFO
    Run Keyword If    '${result}'=='False'    Log    Computed Percentage is correct    level=ERROR  

Increase Facility Schedule
    [Documentation]    This keyword will increase the Created Facility Schedule
    ...    @author ritragel
    ...    @updated: dahijara    01JUL2020    - Added keyword preprocessing. Added screenshot. Added Mx Press Combination KEY.TAB.
    [Arguments]    ${sIncrease_Amount}    ${sFacility_Amount}    ${sTriggerDate}

    ### GetRuntime Keyword Pre-processing ###
    ${Increase_Amount}    Acquire Argument Value    ${sIncrease_Amount}
    ${Facility_Amount}    Acquire Argument Value    ${sFacility_Amount}
    ${TriggerDate}    Acquire Argument Value    ${sTriggerDate}

    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
	Mx LoanIQ Select String    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    1 
    mx LoanIQ click    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Add_Button}  
    mx LoanIQ activate window    ${LIQ_Facility_AddScheduleItem_Window}    
    mx LoanIQ enter    ${LIQ_Facility_AddScheduleItem_Increase_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_Facility_AddScheduleItem_Amount_Input}    ${Increase_Amount}
    mx LoanIQ enter    ${LIQ_Facility_AddScheduleItem_ScheduleDate_Input}    ${TriggerDate}
	Mx Press Combination    KEY.TAB
	# Get Data from UI
	${UiPercent}    Mx LoanIQ Get Data    ${LIQ_Facility_AddScheduleItem_Percent_Input}    value%value    
	${Facility_Amount}    Remove Comma, Negative Character and Convert to Number    ${Facility_Amount}
	${Increase_Amount}    Remove Comma, Negative Character and Convert to Number    ${Increase_Amount}	
    ${Percentage}    Evaluate    (${Increase_Amount}/${Facility_Amount})*100
	${UiPercent}    Strip String    ${UiPercent}    characters=%
	${UiPercent}    Convert To Number    ${UiPercent}    1
	# Compare Values
	${result}    Run Keyword And Return Status    Should Be Equal As Strings    ${Percentage}    ${UiPercent}
    Run Keyword If    '${result}'=='True'    Log    Computed Percentage is correct    level=INFO
    Run Keyword If    '${result}'=='False'    Log    Computed Percentage is correct    level=ERROR 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_IncreaseFacilitySchedule
    mx LoanIQ click    ${LIQ_Facility_AddScheduleItem_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
 
    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
    ${Ui_IncreaseAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    ${TriggerDate}%Amount%value
    ${Ui_IncreaseAmount}    Remove Comma, Negative Character and Convert to Number    ${Ui_IncreaseAmount}
    ${result}    Run Keyword And Return Status    Should Be Equal As Numbers    ${Increase_Amount}    ${Ui_IncreaseAmount}
    Run Keyword If    '${result}'=='True'    Log    Increase Amount is correct and visible in JavaTree   level=INFO
    Run Keyword If    '${result}'=='False'    Log    Increase Amount is wrong    level=ERROR  
    mx LoanIQ select    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_AmortizationScheduleStatus_Dropdown}    Final
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_IncreaseFacilitySchedule    

Decrease Facility Schedule
    [Documentation]    This keyword will increase the Created Facility Schedule
    ...    @author ritragel
    ...    @updated: dahijara    01JUL2020    - Added keyword preprocessing. Added screenshot. Added Mx Press Combination KEY.TAB.    
    [Arguments]    ${sDecrease_Amount}    ${sFacility_Amount}    ${sTriggerDate}

    ### GetRuntime Keyword Pre-processing ###
    ${Decrease_Amount}    Acquire Argument Value    ${sDecrease_Amount}
    ${Facility_Amount}    Acquire Argument Value    ${sFacility_Amount}
    ${TriggerDate}    Acquire Argument Value    ${sTriggerDate}

    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
	Mx LoanIQ Select String    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    1 
    mx LoanIQ click    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Add_Button}  
    mx LoanIQ activate window    ${LIQ_Facility_AddScheduleItem_Window}    
    mx LoanIQ enter    ${LIQ_Facility_AddScheduleItem_Decrease_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_Facility_AddScheduleItem_Amount_Input}    ${Decrease_Amount}
    mx LoanIQ enter    ${LIQ_Facility_AddScheduleItem_ScheduleDate_Input}    ${TriggerDate}
	Mx Press Combination    KEY.TAB
	# Get Data from UI
	${UiPercent}    Mx LoanIQ Get Data    ${LIQ_Facility_AddScheduleItem_Percent_Input}    value%value    
	${Facility_Amount}    Remove Comma, Negative Character and Convert to Number    ${Facility_Amount}
	${Decrease_Amount}    Remove Comma, Negative Character and Convert to Number    ${Decrease_Amount}	
    ${Percentage}    Evaluate    (${Decrease_Amount}/${Facility_Amount})*100
	${UiPercent}    Strip String    ${UiPercent}    characters=%
	${UiPercent}    Convert To Number    ${UiPercent}    1
	# Compare Values
	${result}    Run Keyword And Return Status    Should Be Equal As Strings    ${Percentage}    ${UiPercent}
    Run Keyword If    '${result}'=='True'    Log    Computed Percentage is correct    level=INFO
    Run Keyword If    '${result}'=='False'    Log    Computed Percentage is correct    level=ERROR 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_DecreaseFacilitySchedule
    mx LoanIQ click    ${LIQ_Facility_AddScheduleItem_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    
    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
    ${Ui_DecreaseAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    ${TriggerDate}%Amount%value
    ${Ui_DecreaseAmount}    Remove Comma, Negative Character and Convert to Number    ${Ui_DecreaseAmount}
    ${result}    Run Keyword And Return Status    Should Be Equal As Numbers    ${Decrease_Amount}    ${Ui_DecreaseAmount}
    Run Keyword If    '${result}'=='True'    Log    Decrease Amount is correct and visible in JavaTree   level=INFO
    Run Keyword If    '${result}'=='False'    Log    Decrease Amount is wrong    level=ERROR   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_DecreaseFacilitySchedule

Verify Remaining Amount after Increase
    [Documentation]    This keyword will verify if the increase was successfully added in the remaining amount of the given cycle
    ...    @author: ritragel
    ...    @updated: dahijara    01JUL2020    - Added keyword preprocessing. Added screenshot. 
    [Arguments]    ${sIncrease_Amount}    ${sCommitment_CycleNumber}    ${sIncreaseDate}

    ### GetRuntime Keyword Pre-processing ###
    ${Increase_Amount}    Acquire Argument Value    ${sIncrease_Amount}
    ${Commitment_CycleNumber}    Acquire Argument Value    ${sCommitment_CycleNumber}
    ${IncreaseDate}    Acquire Argument Value    ${sIncreaseDate}

    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
    ${Cycle1_RemainingAmount}    Mx LoanIQ Store TableCell To Clipboard     ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    ${Commitment_CycleNumber}%Remaining Amount%value    
    ${Cycle2_RemainingAmount}    Mx LoanIQ Store TableCell To Clipboard     ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    ${IncreaseDate}%Remaining Amount%value 

    ${IncreaseAmount}    Remove Comma, Negative Character and Convert to Number    ${IncreaseAmount}
    ${Cycle1_RemainingAmount}    Remove Comma, Negative Character and Convert to Number    ${Cycle1_RemainingAmount}
    ${Cycle2_RemainingAmount}    Remove Comma, Negative Character and Convert to Number    ${Cycle2_RemainingAmount}
    ${Validated_Amount}    Evaluate    ${Increase_Amount}+${Cycle1_RemainingAmount}
    ${result}    Run Keyword And Return Status    Should Be Equal As Numbers    ${Validated_Amount}    ${Cycle2_RemainingAmount}
    Run Keyword If    '${result}'=='True'    Log    Increase Amount is successfully Added to the selected Cycle   level=INFO
    Run Keyword If    '${result}'=='False'    Log    Increase Amount is not added to the remaining amount   level=ERROR
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_AmortizationSchedule   

Verify Remaining Amount after Decrease
    [Documentation]    This keyword will verify if the decrease was successfully subtracted in the remaining amount of the given cycle
    ...    @author: ritragel
    ...    @updated: dahijara    01JUL2020    - Added keyword preprocessing. Added screenshot.   
    [Arguments]    ${sDecrease_Amount}    ${sIncreaseDate}    ${sDecreaseDate}

    ### GetRuntime Keyword Pre-processing ###
    ${Decrease_Amount}    Acquire Argument Value    ${sDecrease_Amount}
    ${IncreaseDate}    Acquire Argument Value    ${sIncreaseDate}
    ${DecreaseDate}    Acquire Argument Value    ${sDecreaseDate}

    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
    ${Cycle2_RemainingAmount}    Mx LoanIQ Store TableCell To Clipboard     ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    ${IncreaseDate}%Remaining Amount%value    
    ${Cycle3_RemainingAmount}    Mx LoanIQ Store TableCell To Clipboard     ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    ${DecreaseDate}%Remaining Amount%value 

    ${Decrease_Amount}    Remove Comma, Negative Character and Convert to Number    ${Decrease_Amount}
    ${Cycle2_RemainingAmount}    Remove Comma, Negative Character and Convert to Number    ${Cycle2_RemainingAmount}
    ${Cycle3_RemainingAmount}    Remove Comma, Negative Character and Convert to Number    ${Cycle3_RemainingAmount}
    ${Validated_Amount}    Evaluate    ${Cycle2_RemainingAmount}-${Decrease_Amount}
    ${result}    Run Keyword And Return Status    Should Be Equal As Numbers    ${Validated_Amount}    ${Cycle3_RemainingAmount}
    Run Keyword If    '${result}'=='True'    Log    Decrease Amount is successfully Subtracted to the selected Cycle   level=INFO
    Run Keyword If    '${result}'=='False'    Log    Decrease Amount is not added to the remaining amount   level=ERROR 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_AmortizationSchedule   

Equalize Amounts and Verify that Remaining Amount is Zero
    [Documentation]    This keyword will equalize the decrease and increase amounts and verify if the remaining amount in the last item is 0
    ...    @author: ritragel
    ...    @update: rtarayao - changed the row reference from Maturity Date to Amortization Cycle Number.
    ...    @updated: dahijara    01JUL2020    - Added keyword preprocessing. Added screenshot. 
    [Arguments]    ${sAmortizationCycleNo}

    ### GetRuntime Keyword Pre-processing ###
    ${AmortizationCycleNo}    Acquire Argument Value    ${sAmortizationCycleNo}

    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
	Mx LoanIQ Select String    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    1 
    mx LoanIQ click    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_EqualizeAmounts_Button}
    mx LoanIQ click element if present    ${LIQ_PleaseConfirm_Yes_Button}    
    ${Remaining_Amount}    Mx LoanIQ Store TableCell To Clipboard     ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    ${AmortizationCycleNo}%Remaining Amount%value
    ${result}    Run Keyword And Return Status    Should Be Equal As Numbers    ${Remaining_Amount}    0.00
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_AmortizationSchedule   
    Run Keyword If    '${result}'=='True'    Log    Remaining Amount is Zero   level=INFO
    Run Keyword If    '${result}'=='False'    Run Keywords    Fatal Error    msg=Remaining Amount not zero
    ...    AND    Close All Windows on LIQ      
    
Create Notices
    [Documentation]    This keyword will Create notices and validate the inputs
    ...    @author: ritragel
    ...    @updated: dahijara    01JUL2020    - Added keyword preprocessing. Added screenshot. 
    [Arguments]    ${sBorrower_LegalName}

    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_LegalName}    Acquire Argument Value    ${sBorrower_LegalName}

    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
    mx LoanIQ click    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_CreateNotices_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_Facility_GroupAddressedNotice_Window}
    mx LoanIQ click    ${LIQ_Facility_GroupAddressedNotice_Create_Button}
    mx LoanIQ activate    ${LIQ_Facility_Notices_Window}
    mx LoanIQ click    ${LIQ_Facility_Notices_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_Facility_AddressedGroup_Window}  
    ${Customer_ExternalNotice}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_AddressedGroup_JavaTree}    External Notice Method%Customer%value 
    ${Customer_Email}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_AddressedGroup_JavaTree}    Email%Customer%value
    
    ${result}    Run Keyword And Return Status    Should Be Equal As Strings    ${Customer_ExternalNotice}    ${Borrower_LegalName}
    Run Keyword If    '${result}'=='True'    Log    External Notice for Customer is available   level=INFO
    Run Keyword If    '${result}'=='False'    Log    External Notice for Customer is not available    level=ERROR  
    
    ${result}    Run Keyword And Return Status    Should Be Equal As Strings    ${Customer_Email}    ${Borrower_LegalName}
    Run Keyword If    '${result}'=='True'    Log    Email notice for Customer is available    level=INFO
    Run Keyword If    '${result}'=='False'    Log    External Notice for Customer is not available    level=ERROR
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Notices
    mx LoanIQ click    ${LIQ_Facility_AddressedGroup_Exit_Button}        

Set Schedule Status to Final and Save
    [Documentation]    This keyword will set Amortization Status to Final
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}
    mx LoanIQ select    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_AmortizationScheduleStatus_Dropdown}    Final  
    mx LoanIQ click    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Save_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Exit_Button} 
    mx LoanIQ activate    ${LIQ_FacilityNavigator_Window}
    mx LoanIQ close window        ${LIQ_FacilityNavigator_Window} 

Validate Commitment Amount
    [Documentation]    This keyword will validate the Commitment Amount that should be equal with the Host Bank Amount
    ...    @author: ritragel
    ...    @update: dahijara    03JUL2020    - Added keyword for pre-processing
    [Arguments]    ${sCommitment_Amount} 

    ### GetRuntime Keyword Pre-processing ###
    ${Commitment_Amount}    Acquire Argument Value    ${sCommitment_Amount}

    mx LoanIQ activate window    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Window}  
    ${HostBank_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_JavaTree}    TOTAL: %Host Bank Amount%value
    
    ${Commitment_Amount}    Remove Comma, Negative Character and Convert to Number    ${Commitment_Amount}
    ${HostBank_Amount}    Remove Comma, Negative Character and Convert to Number    ${HostBank_Amount}    
     
    ${result}    Run Keyword And Return Status    Should Be Equal As Strings    ${Commitment_Amount}    ${HostBank_Amount}
    Run Keyword If    '${result}'=='True'    Log    Commitment Amount and Host Bank total is equal    level=INFO
    Run Keyword If    '${result}'=='True'    mx LoanIQ click    ${LIQ_FacilityIncreaseDecreaseSchedule_AmortizationSchedule_Exit_Button}    
    Run Keyword If    '${result}'=='False'    Log    Commitment Amount and Host Bank total is not equal    level=ERROR
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_AmortizationSchedule
    mx LoanIQ click element if present    ${LIQ_Facility_AmortizationScheduleSetup_Exiting_ExitNoSave_Button}    
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window} 
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}   
    
Get Original Amount on Summary Tab of Facility Notebook
    [Documentation]    This keyword will get the original amount under Summary Tab.
    ...    @author:mgaling
    ...    @update: dahijara    24SEP2020    Added post processing keywords and optional arguments and screenshot.
    [Arguments]    ${sRunVar_Orig_FacilityCurrentCmt}=None    ${sRunVar_Orig_FacilityAvailableToDraw}=None    ${sRunVar_Orig_FacilityHBContrGross}=None    ${sRunVar_Orig_FacilityHBOutstandings}=None    ${sRunVar_Orig_FacilityHBAvailToDraw}=None
    ...    ${sRunVar_Orig_FacilityNetCmt}=None    ${sRunVar_Orig_FacilityHBNetFundableCmt}=None    ${sRunVar_Orig_FacilityHBNetOutstandings_Funded}=None    ${sRunVar_Orig_FacilityHBNetAvailToDraw_Fundable}=None    ${sRunVar_Orig_FacilityHBNetAvailToDraw}=None
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    
    ###Get the necessary data under Global Facility Amounts Section###
    ${Orig_FacilityCurrentCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%Amount 
    ${Orig_FacilityCurrentCmt}    Remove String    ${Orig_FacilityCurrentCmt}     ,
    ${Orig_FacilityCurrentCmt}    Convert To Number    ${Orig_FacilityCurrentCmt}    2         
    
    ${Orig_FacilityAvailableToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%Amount
    ${Orig_FacilityAvailableToDraw}    Remove String    ${Orig_FacilityAvailableToDraw}    ,
    ${Orig_FacilityAvailableToDraw}    Convert To Number    ${Orig_FacilityAvailableToDraw}    2  
    
    ###Get the necessary data under Host Bank Share Gross Amount Section###
    ${Orig_FacilityHBContrGross}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_ContrGross}    value%Amount  
    ${Orig_FacilityHBContrGross}    Remove String    ${Orig_FacilityHBContrGross}    ,
    ${Orig_FacilityHBContrGross}    Convert To Number    ${Orig_FacilityHBContrGross}    2  
    
    ${Orig_FacilityHBOutstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_Outstandings}    value%Amount  
    
    ${Orig_FacilityHBAvailToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_AvailToDraw}    value%Amount 
    ${Orig_FacilityHBAvailToDraw}    Remove String    ${Orig_FacilityHBAvailToDraw}    ,
    ${Orig_FacilityHBAvailToDraw}    Convert To Number    ${Orig_FacilityHBAvailToDraw}    2  
    
    ###Get the necessary data under Host Bank Share Net Amounts Section### 
    ${Orig_FacilityNetCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_NetCmt}    value%Amount  
    ${Orig_FacilityNetCmt}    Remove String    ${Orig_FacilityNetCmt}    ,
    ${Orig_FacilityNetCmt}    Convert To Number    ${Orig_FacilityNetCmt}    2  
    
    ${Orig_FacilityHBNetFundableCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_FundableCmt}    value%Amount  
    ${Orig_FacilityHBNetFundableCmt}    Remove String    ${Orig_FacilityHBNetFundableCmt}    ,
    ${Orig_FacilityHBNetFundableCmt}    Convert To Number    ${Orig_FacilityHBNetFundableCmt}    2  
    
    ${Orig_FacilityHBNetOutstandings_Funded}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_Outstandings_Funded}    value%Amount  
    
    ${Orig_FacilityHBNetAvailToDraw_Fundable}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_AvailToDraw_Fundable}    value%Amount
    ${Orig_FacilityHBNetAvailToDraw_Fundable}    Remove String    ${Orig_FacilityHBNetAvailToDraw_Fundable}    ,
    ${Orig_FacilityHBNetAvailToDraw_Fundable}    Convert To Number    ${Orig_FacilityHBNetAvailToDraw_Fundable}  
    
    ${Orig_FacilityHBNetAvailToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank__NetAvailToDraw}    value%Amount 
    ${Orig_FacilityHBNetAvailToDraw}    Remove String    ${Orig_FacilityHBNetAvailToDraw}    ,
    ${Orig_FacilityHBNetAvailToDraw}    Convert To Number    ${Orig_FacilityHBNetAvailToDraw}    2  
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_SummaryTab
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityCurrentCmt}    ${Orig_FacilityCurrentCmt}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityAvailableToDraw}    ${Orig_FacilityAvailableToDraw}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityHBContrGross}    ${Orig_FacilityHBContrGross}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityHBOutstandings}    ${Orig_FacilityHBOutstandings}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityHBAvailToDraw}    ${Orig_FacilityHBAvailToDraw}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityNetCmt}    ${Orig_FacilityNetCmt}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityHBNetFundableCmt}    ${Orig_FacilityHBNetFundableCmt}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityHBNetOutstandings_Funded}    ${Orig_FacilityHBNetOutstandings_Funded}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityHBNetAvailToDraw_Fundable}    ${Orig_FacilityHBNetAvailToDraw_Fundable}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacilityHBNetAvailToDraw}    ${Orig_FacilityHBNetAvailToDraw}

    [Return]    ${Orig_FacilityCurrentCmt}    ${Orig_FacilityAvailableToDraw}    ${Orig_FacilityHBContrGross}    ${Orig_FacilityHBOutstandings}
    ...    ${Orig_FacilityHBAvailToDraw}    ${Orig_FacilityNetCmt}    ${Orig_FacilityHBNetFundableCmt}
    ...    ${Orig_FacilityHBNetOutstandings_Funded}    ${Orig_FacilityHBNetAvailToDraw_Fundable}    ${Orig_FacilityHBNetAvailToDraw} 
    
    
Get Original Amount on Facility Lender Shares
    [Documentation]    This keyword will get the original amount Lender Shares.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sHostBank_Lender}    ${sLender1}    ${sLender2}    ${sRunVar_Original_UIFacHBActualAmount}=None    ${sRunVar_riginal_UIFacLender1ActualAmount}=None    ${sRunVar_Original_UIFacLender2ActualAmount}=None    ${sRunVar_Orig_FacPrimariesAssignees_ActualTotal}=None    
    ...    ${sRunVar_Original_UIFacHBSharesActualAmount}=None    ${sRunVar_Orig_FacHostBankShares_ActualNetAllTotal}=None 
    
    ### GetRuntime Keyword Pre-processing ###
	${HostBank_Lender}    Acquire Argument Value    ${sHostBank_Lender}
	${Lender1}    Acquire Argument Value    ${sLender1}
    ${Lender2}    Acquire Argument Value    ${sLender2} 

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_LenderShares}
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    ###Get the Orginal Actual Amount under Primaries/Assignees Section###
    ${Original_UIFacHBActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_Lender}%Actual Amount%Original_UIHBActualAmount
    ${Original_UIFacHBActualAmount}    Remove String    ${Original_UIFacHBActualAmount}    ,
    ${Original_UIFacHBActualAmount}    Convert To Number    ${Original_UIFacHBActualAmount}            
    
    ${Original_UIFacLender1ActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender1}%Actual Amount%Original_UILender1ActualAmount
    ${Original_UIFacLender1ActualAmount}    Remove String    ${Original_UIFacLender1ActualAmount}    ,
    ${Original_UIFacLender1ActualAmount}    Convert To Number    ${Original_UIFacLender1ActualAmount}  
    
    ${Original_UIFacLender2ActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender2}%Actual Amount%Original_UILender2ActualAmount 
    ${Original_UIFacLender2ActualAmount}    Remove String    ${Original_UIFacLender2ActualAmount}    ,
    ${Original_UIFacLender2ActualAmount}    Convert To Number    ${Original_UIFacLender2ActualAmount} 
    
    ###Get the Original value of Actual Total under Primaries/Assignees Section###
    ${Orig_FacPrimariesAssignees_ActualTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_PrimariesAssignees_ActualTotal}    value%Total 
    ${Orig_FacPrimariesAssignees_ActualTotal}    Remove String    ${Orig_FacPrimariesAssignees_ActualTotal}    \
    ${Orig_FacPrimariesAssignees_ActualTotal}    Remove String    ${Orig_FacPrimariesAssignees_ActualTotal}    ,
    ${Orig_FacPrimariesAssignees_ActualTotal}    Convert To Number    ${Orig_FacPrimariesAssignees_ActualTotal}  
    
    ###Get the Original Actual Amount of Host Bank under Host Bank Shares Section###
    ${Original_UIFacHBSharesActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_HostBankShares_List}    ${HostBank_Lender}%Actual Amount%Original_UIHBSharesActualAmount
    ${Original_UIFacHBSharesActualAmount}    Remove String    ${Original_UIFacHBSharesActualAmount}    ,
    ${Original_UIFacHBSharesActualAmount}    Convert To Number    ${Original_UIFacHBSharesActualAmount} 
     
    ###Get the Orginal value of Actual Net All Total under Host Bank Shares Section###
    ${Orig_FacHostBankShares_ActualNetAllTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_HostBankShares_ActualNetAllTotal}    value%Total 
    ${Orig_FacHostBankShares_ActualNetAllTotal}    Remove String    ${Orig_FacHostBankShares_ActualNetAllTotal}    \
    ${Orig_FacHostBankShares_ActualNetAllTotal}    Remove String    ${Orig_FacHostBankShares_ActualNetAllTotal}    ,
    ${Orig_FacHostBankShares_ActualNetAllTotal}    Convert To Number    ${Orig_FacHostBankShares_ActualNetAllTotal} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityLender_Shares 
    
    mx LoanIQ close window    ${LIQ_LenderShares_Window} 
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Original_UIFacHBActualAmount}    ${Original_UIFacHBActualAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_riginal_UIFacLender1ActualAmount}    ${Original_UIFacLender1ActualAmount}   
    Save Values of Runtime Execution on Excel File    ${sRunVar_Original_UIFacLender2ActualAmount}    ${Original_UIFacLender2ActualAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacPrimariesAssignees_ActualTotal}    ${Orig_FacPrimariesAssignees_ActualTotal} 
    Save Values of Runtime Execution on Excel File    ${sRunVar_Original_UIFacHBSharesActualAmount}    ${Original_UIFacHBSharesActualAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_FacHostBankShares_ActualNetAllTotal}    ${Orig_FacHostBankShares_ActualNetAllTotal}  

    [Return]    ${Original_UIFacHBActualAmount}    ${Original_UIFacLender1ActualAmount}    ${Original_UIFacLender2ActualAmount}    ${Orig_FacPrimariesAssignees_ActualTotal}    ${Original_UIFacHBSharesActualAmount}    ${Orig_FacHostBankShares_ActualNetAllTotal}        
                        
Validate Host Bank Share Gross Amounts
    [Documentation]    This keyword will compute the percentage share amount of the host bank.
    ...    @author: mnanquilada
    ...    10/19/2018
    ...    <updated> bernchua 11/13/2018: updated computation for facilityOutstanding1 and facilityAvailToDraw1
    ...    @update: dahijara    03AUG2020    - Added keyword processing and screenshot. Removed commented lines.
    [Arguments]    ${sHostBankPercentageAmount}
    ### GetRuntime Keyword Pre-processing ###
    ${HostBankPercentageAmount}    Acquire Argument Value    ${sHostBankPercentageAmount}

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}  
    ${proposedCMTHostBank}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankProposeCmt}    testData
    ${contrGrossAmount}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankContrGross}    testData
    ${outstanding}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankOutstanding}    testData
    ${facilityOutstanding}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    testData
    ${availToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankAvailToDraw}    testData
    ${facilityAvailToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    testData
    
    ###Host Bank Total Share
    ${proposedCMTHostBank}    Remove String    ${proposedCMTHostBank}    ,
    ${proposedCMTHostBank}    Convert To Number    ${proposedCMTHostBank}    
    ${contrGrossAmtResult}    Evaluate    (${proposedCMTHostBank}*${sHostBankPercentageAmount})/100
    ${contrGrossAmtResult}     Convert To String    ${contrGrossAmtResult} 
    ${contrGrossAmtResult}    Convert Number With Comma Separators    ${contrGrossAmtResult}
    
    ###Host Bank Total Facility Share
    ${facilityOutstanding1}    Remove String    ${facilityOutstanding}    ,
    ${facilityOutstanding1}    Convert To Number    ${facilityOutstanding1}
    
    ${sHostBankPercentageAmount}    Evaluate    ${sHostBankPercentageAmount}/100    
    
    ${facilityOutstanding1}    Evaluate    ${facilityOutstanding1}*${sHostBankPercentageAmount}
    ${facilityOutstanding1}      Convert To String    ${facilityOutstanding1}
    ${facilityOutstanding1}     Convert Number With Comma Separators    ${facilityOutstanding1}
    
    
    ###Host Bank Total Facility Share
    ${facilityAvailToDraw1}    Remove String    ${facilityAvailToDraw}    ,
    ${facilityAvailToDraw1}    Convert To Number    ${facilityAvailToDraw1}
    ${facilityAvailToDraw1}    Evaluate    ${facilityAvailToDraw1}*${sHostBankPercentageAmount}
    ${facilityAvailToDraw1}      Convert To String    ${facilityAvailToDraw1}
    ${facilityAvailToDraw1}     Convert Number With Comma Separators    ${facilityAvailToDraw1}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilitySummary
    
    Log    <font size=10><b>${facilityAvailToDraw1} == ${availToDraw}</b></font>    INFO    html=True
    Log    <font size=10><b>${contrGrossAmtResult} == ${contrGrossAmount}</b></font>    INFO    html=True
    Log    <font size=10><b>${facilityOutstanding1} == ${outstanding}</b></font>    INFO    html=True

Validate the Updates on Facility Notebook Summary Tab 
    [Documentation]    This keyword will get the updated amount under Summary Tab in Facility Notebook.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sIncrease_Amount}    ${sOrig_FacilityCurrentCmt}    ${sOrig_FacilityAvailableToDraw}    ${sOrig_FacilityHBContrGross}    ${sComputed_HBActualAmount}    ${sOrig_FacilityHBOutstandings}    ${sOrig_FacilityHBAvailToDraw}     
    ...    ${sOrig_FacilityHBNetOutstandings_Funded}    ${sOrig_FacilityHBNetAvailToDraw_Fundable}    ${sOrig_FacilityHBNetAvailToDraw}    
    
    ### GetRuntime Keyword Pre-processing ###
    ${Increase_Amount}    Acquire Argument Value    ${sIncrease_Amount}
    ${Orig_FacilityCurrentCmt}    Acquire Argument Value    ${sOrig_FacilityCurrentCmt}
    ${Orig_FacilityAvailableToDraw}    Acquire Argument Value    ${sOrig_FacilityAvailableToDraw}	
    ${Orig_FacilityHBContrGross}    Acquire Argument Value    ${sOrig_FacilityHBContrGross}
    ${Computed_HBActualAmount}    Acquire Argument Value    ${sComputed_HBActualAmount}
    ${Orig_FacilityHBOutstandings}    Acquire Argument Value    ${sOrig_FacilityHBOutstandings}
    ${Orig_FacilityHBAvailToDraw}    Acquire Argument Value    ${sOrig_FacilityHBAvailToDraw}
    ${Orig_FacilityHBNetOutstandings_Funded}    Acquire Argument Value    ${sOrig_FacilityHBNetOutstandings_Funded}
    ${Orig_FacilityHBNetAvailToDraw_Fundable}    Acquire Argument Value    ${sOrig_FacilityHBNetAvailToDraw_Fundable}
    ${Orig_FacilityHBNetAvailToDraw}    Acquire Argument Value    ${sOrig_FacilityHBNetAvailToDraw}

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary        
   
    ${Increase_Amount}    Convert To Number    ${Increase_Amount}    2   
    
    ###Validate the updated data under Global Facility Amounts Section###
    ${Updated_UIFaciltyCurrentCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%Amount 
    ${Updated_UIFaciltyCurrentCmt}    Remove String    ${Updated_UIFaciltyCurrentCmt}     ,
    ${Updated_UIFaciltyCurrentCmt}    Convert To Number    ${Updated_UIFaciltyCurrentCmt}    2    
    
    ${Calculated_FacilityCurrentCmt}    Evaluate    ${Orig_FacilityCurrentCmt}+${Increase_Amount}
    Should Be Equal    ${Calculated_FacilityCurrentCmt}    ${Updated_UIFaciltyCurrentCmt}
    Log    ${Calculated_FacilityCurrentCmt}=${Updated_UIFaciltyCurrentCmt}        
         
    
    ${Updated_UIFacilityAvailableToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%Amount
    ${Updated_UIFacilityAvailableToDraw}    Remove String    ${Updated_UIFacilityAvailableToDraw}    ,
    ${Updated_UIFacilityAvailableToDraw}    Convert To Number    ${Updated_UIFacilityAvailableToDraw}    2  
    
    ${Calculated_FacilityAvailableToDraw}    Evaluate    ${Orig_FacilityAvailableToDraw}+${Increase_Amount}
    Should Be Equal    ${Calculated_FacilityAvailableToDraw}    ${Updated_UIFacilityAvailableToDraw}
    Log    ${Calculated_FacilityAvailableToDraw}=${Updated_UIFaciltyCurrentCmt} 
    
    ###Validate the updated data under Host Bank Share Gross Amount Section###
    ${Updated_UIFacilityHBContrGross}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_ContrGross}    value%Amount  
    ${Updated_UIFacilityHBContrGross}    Remove String    ${Updated_UIFacilityHBContrGross}    ,
    ${Updated_UIFacilityHBContrGross}    Convert To Number    ${Updated_UIFacilityHBContrGross}    2  
    
    ${Calculated_FacilityHBContrGross}    Evaluate    ${Orig_FacilityHBContrGross}+${Computed_HBActualAmount}
    Should Be Equal    ${Calculated_FacilityHBContrGross}    ${Updated_UIFacilityHBContrGross}
    Log    ${Calculated_FacilityHBContrGross}=${Updated_UIFacilityHBContrGross} 
    
    ${Updated_UIFacilityHBOutstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_Outstandings}    value%Amount  
    Should Be Equal    ${Orig_FacilityHBOutstandings}    ${Updated_UIFacilityHBOutstandings}
    Log    ${Orig_FacilityHBOutstandings}=${Updated_UIFacilityHBOutstandings}
    
    ${Updated_UIFacilityHBAvailToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_AvailToDraw}    value%Amount 
    ${Updated_UIFacilityHBAvailToDraw}    Remove String    ${Updated_UIFacilityHBAvailToDraw}    ,
    ${Updated_UIFacilityHBAvailToDraw}    Convert To Number    ${Updated_UIFacilityHBAvailToDraw}    2  
    
    ${Calculated_FacilityHBAvailToDraw}    Evaluate    ${Orig_FacilityHBAvailToDraw}+${Computed_HBActualAmount}
    Should Be Equal    ${Calculated_FacilityHBAvailToDraw}    ${Updated_UIFacilityHBAvailToDraw}
    Log    ${Calculated_FacilityHBAvailToDraw}=${Updated_UIFacilityHBAvailToDraw}
    
    ###Validate the updated data  under Host Bank Share Net Amounts Section### 
    ${Updated_UIFacilityNetCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_NetCmt}    value%Amount  
    ${Updated_UIFacilityNetCmt}    Remove String    ${Updated_UIFacilityNetCmt}    ,
    ${Updated_UIFacilityNetCmt}    Convert To Number    ${Updated_UIFacilityNetCmt}    2 
    
    Should Be Equal    ${Updated_UIFacilityNetCmt}    ${Updated_UIFacilityHBContrGross}
    Log    ${Updated_UIFacilityNetCmt}=${Updated_UIFacilityHBContrGross} 
    
    ${Updated_UIFacilityHBNetFundableCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_FundableCmt}    value%Amount  
    ${Updated_UIFacilityHBNetFundableCmt}    Remove String    ${Updated_UIFacilityHBNetFundableCmt}    ,
    ${Updated_UIFacilityHBNetFundableCmt}    Convert To Number    ${Updated_UIFacilityHBNetFundableCmt}    2  
    
    Should Be Equal    ${Updated_UIFacilityNetCmt}    ${Updated_UIFacilityHBNetFundableCmt}
    Log    ${Updated_UIFacilityNetCmt}=${Updated_UIFacilityHBNetFundableCmt} 
    
    ${Updated_UIFacilityHBNetOutstandings_Funded}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_Outstandings_Funded}    value%Amount  
    
    Should Be Equal    ${Updated_UIFacilityHBNetOutstandings_Funded}    ${Orig_FacilityHBNetOutstandings_Funded}
    Log    ${Updated_UIFacilityHBNetOutstandings_Funded}=${Orig_FacilityHBNetOutstandings_Funded} 
    
    ${Updated_UIFacilityHBNetAvailToDraw_Fundable}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_AvailToDraw_Fundable}    value%Amount
    ${Updated_UIFacilityHBNetAvailToDraw_Fundable}    Remove String    ${Updated_UIFacilityHBNetAvailToDraw_Fundable}    ,
    ${Updated_UIFacilityHBNetAvailToDraw_Fundable}    Convert To Number    ${Updated_UIFacilityHBNetAvailToDraw_Fundable}  
    
    ${Calculated_FacilityHBNetAvailToDraw_Fundable}    Evaluate    ${Orig_FacilityHBNetAvailToDraw_Fundable}+${Computed_HBActualAmount}
    Should Be Equal    ${Calculated_FacilityHBNetAvailToDraw_Fundable}    ${Updated_UIFacilityHBNetAvailToDraw_Fundable}
    Log    ${Calculated_FacilityHBNetAvailToDraw_Fundable}=${Updated_UIFacilityHBNetAvailToDraw_Fundable} 
    
    ${Updated_UIFacilityHBNetAvailToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank__NetAvailToDraw}    value%Amount 
    ${Updated_UIFacilityHBNetAvailToDraw}    Remove String    ${Updated_UIFacilityHBNetAvailToDraw}    ,
    ${Updated_UIFacilityHBNetAvailToDraw}    Convert To Number    ${Updated_UIFacilityHBNetAvailToDraw}    2 
    
    ${Calculated_FacilityHBNetAvailToDraw}    Evaluate    ${Orig_FacilityHBNetAvailToDraw}+${Computed_HBActualAmount}
    Should Be Equal    ${Updated_UIFacilityHBNetAvailToDraw}    ${Calculated_FacilityHBNetAvailToDraw}
    Log    ${Updated_UIFacilityHBNetAvailToDraw}=${Calculated_FacilityHBNetAvailToDraw} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacNotebook_SummaryTab
    [Return]    ${Updated_UIFaciltyCurrentCmt}
     
Validate Restrictions and Events Tab
    [Documentation]    This keyword is for validating data under Restrictions and Events Tab after Facility Commitment Increase transaction.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sUpdated_UIFaciltyCurrentCmt}  
    
    ### GetRuntime Keyword Pre-processing ###
    ${Updated_UIFaciltyCurrentCmt}    Acquire Argument Value    ${sUpdated_UIFaciltyCurrentCmt}

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    ###Validate the updated data under Commitment Availability###
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Restrictions
    
    ${Commitment_Availability}    Mx LoanIQ Get Data    ${LIQ_Facility_Restriction_CommitmentAvailability}    value%Available
    ${Commitment_Availability}    Remove String    ${Commitment_Availability}    ,
    ${Commitment_Availability}    Convert To Number    ${Commitment_Availability}    2 
    
    Should Be Equal    ${Commitment_Availability}    ${Updated_UIFaciltyCurrentCmt}
    Log    ${Commitment_Availability}=${Updated_UIFaciltyCurrentCmt}  
    
    ###Validate the updates under Events Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_FacilityEvents_JavaTree}    Commitment Increase Released%yes
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/EventsTab          
        
Validate the Updates on Facility Lender Shares
    [Documentation]    This keyword validates the new amount under Lender Shares of Facility after the Facility Commitment Increase Transaction.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sHostBank_Lender}    ${sLender1}    ${sLender2}    ${sComputed_HBActualAmount}    ${sOriginal_UIFacHBActualAmount}    ${sComputed_Lender1ActualAmount}    ${sOriginal_UIFacLender1ActualAmount}
    ...    ${sComputed_Lender2ActualAmount}    ${sOriginal_UIFacLender2ActualAmount}        
    
    ### GetRuntime Keyword Pre-processing ###
    ${HostBank_Lender}    Acquire Argument Value    ${sHostBank_Lender}
    ${Lender1}    Acquire Argument Value    ${sLender1}
    ${Lender2}    Acquire Argument Value    ${sLender2}	
    ${Computed_HBActualAmount}    Acquire Argument Value    ${sComputed_HBActualAmount}
    ${Original_UIFacHBActualAmount}    Acquire Argument Value    ${sOriginal_UIFacHBActualAmount}
    ${Computed_Lender1ActualAmount}    Acquire Argument Value    ${sComputed_Lender1ActualAmount}
    ${Original_UIFacLender1ActualAmount}    Acquire Argument Value    ${sOriginal_UIFacLender1ActualAmount}
    ${Computed_Lender2ActualAmount}    Acquire Argument Value    ${sComputed_Lender2ActualAmount}
    ${Original_UIFacLender2ActualAmount}    Acquire Argument Value    ${sOriginal_UIFacLender2ActualAmount}

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
     
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_LenderShares}
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    ###Get the Updated Actual Amount under Primaries/Assignees Section###
    ${Updated_UIFacHBActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_Lender}%Actual Amount%Original_UIHBActualAmount
    ${Updated_UIFacHBActualAmount}    Remove String    ${Updated_UIFacHBActualAmount}    ,
    ${Updated_UIFacHBActualAmount}    Convert To Number    ${Updated_UIFacHBActualAmount}            
    
    ${Updated_UIFacLender1ActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender1}%Actual Amount%Original_UILender1ActualAmount
    ${Updated_UIFacLender1ActualAmount}    Remove String    ${Updated_UIFacLender1ActualAmount}    ,
    ${Updated_UIFacLender1ActualAmount}    Convert To Number    ${Updated_UIFacLender1ActualAmount}  
    
    ${Updated_UIFacLender2ActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender2}%Actual Amount%Original_UILender2ActualAmount 
    ${Updated_UIFacLender2ActualAmount}    Remove String    ${Updated_UIFacLender2ActualAmount}    ,
    ${Updated_UIFacLender2ActualAmount}    Convert To Number    ${Updated_UIFacLender2ActualAmount} 
    
    
    ###Get the Updated value of Actual Total under Primaries/Assignees Section###
    ${Updated_FacPrimariesAssignees_ActualTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_PrimariesAssignees_ActualTotal}    value%Total 
    ${Updated_FacPrimariesAssignees_ActualTotal}    Remove String    ${Updated_FacPrimariesAssignees_ActualTotal}    \
    ${Updated_FacPrimariesAssignees_ActualTotal}    Remove String    ${Updated_FacPrimariesAssignees_ActualTotal}    ,
    ${Updated_FacPrimariesAssignees_ActualTotal}    Convert To Number    ${Updated_FacPrimariesAssignees_ActualTotal}  
    
    ###Get the Updated Actual Amount of Host Bank under Host Bank Shares Section###
    ${Updated_UIFacHBSharesActualAmount}     Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LenderShares_HostBankShares_List}    ${HostBank_Lender}%Actual Amount%Original_UIHBSharesActualAmount
    ${Updated_UIFacHBSharesActualAmount}    Remove String    ${Updated_UIFacHBSharesActualAmount}    ,
    ${Updated_UIFacHBSharesActualAmount}    Convert To Number    ${Updated_UIFacHBSharesActualAmount} 
     
    ###Get the Updated value of Actual Net All Total under Host Bank Shares Section###
    ${Updated_FacHostBankShares_ActualNetAllTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_HostBankShares_ActualNetAllTotal}    value%Total 
    ${Updated_FacHostBankShares_ActualNetAllTotal}    Remove String    ${Updated_FacHostBankShares_ActualNetAllTotal}    \
    ${Updated_FacHostBankShares_ActualNetAllTotal}    Remove String    ${Updated_FacHostBankShares_ActualNetAllTotal}    ,
    ${Updated_FacHostBankShares_ActualNetAllTotal}    Convert To Number    ${Updated_FacHostBankShares_ActualNetAllTotal}   
    
    ###Update Validation on Primaries/Assignees Section###
    
    ${Computed_FacHBActualAmount}    Evaluate    ${Computed_HBActualAmount}+${Original_UIFacHBActualAmount}    
    Should Be Equal    ${Computed_FacHBActualAmount}    ${Updated_UIFacHBActualAmount}
    Log    ${Computed_FacHBActualAmount}=${Updated_UIFacHBActualAmount}      
    
    ${Computed_FacLender1ActualAmount}    Evaluate    ${Computed_Lender1ActualAmount}+${Original_UIFacLender1ActualAmount}    
    Should Be Equal    ${Computed_FacLender1ActualAmount}    ${Updated_UIFacLender1ActualAmount}
    Log    ${Computed_FacLender1ActualAmount}=${Updated_UIFacLender1ActualAmount}    
    
    ${Computed_FacLender2ActualAmount}    Evaluate    ${Computed_Lender2ActualAmount}+${Original_UIFacLender2ActualAmount}    
    Should Be Equal    ${Computed_FacLender2ActualAmount}    ${Updated_UIFacLender2ActualAmount}
    Log    ${Computed_FacLender2ActualAmount}=${Updated_UIFacLender2ActualAmount}      
    
    ${Computed_FacPrimariesAssignees_ActualTotal}    Evaluate    ${Updated_UIFacHBActualAmount}+${Updated_UIFacLender1ActualAmount}+${Updated_UIFacLender2ActualAmount}
    Should Be Equal    ${Computed_FacPrimariesAssignees_ActualTotal}    ${Updated_FacPrimariesAssignees_ActualTotal}  
    Log    ${Computed_FacPrimariesAssignees_ActualTotal}=${Updated_FacPrimariesAssignees_ActualTotal} 
    
    ###Update Validation on Host Bank Shares Section###     
    Should Be Equal    ${Updated_UIFacHBActualAmount}    ${Updated_UIFacHBSharesActualAmount}
    Log    ${Updated_UIFacHBActualAmount}=${Updated_UIFacHBSharesActualAmount}      
    
    Should Be Equal    ${Updated_UIFacHBSharesActualAmount}    ${Updated_FacHostBankShares_ActualNetAllTotal}  
    Log    ${Updated_UIFacHBSharesActualAmount}=${Updated_FacHostBankShares_ActualNetAllTotal}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_LenderShares                   
    
    mx LoanIQ close window    ${LIQ_LenderShares_Window} 
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}   

Get Original Data on Global Facility Amounts Section
    [Documentation]    This keyword is for getting the original data before the Payment Transaction.
    ...    @author:mgaling
    ...    @update: ehugo    01JUN2020    - added keyword post-processing; added optional runtime arguments; added screenshot
    [Arguments]    ${sRunTimeVar_OrigFacilityProposedcmt}=None    ${sRunTimeVar_OrigFacilityClosingCmt}=None    ${sRunTimeVar_OrigFacilityCurrentCmt}=None
    ...    ${sRunTimeVar_OrigFacilityOutstandings}=None    ${sRunTimeVar_OrigFacilityAvailableToDraw}=None
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    
    ${Orig_FacilityProposedcmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ProposedCmt_Textfield}    value%Amount 
    ${Orig_FacilityProposedcmt}    Remove String    ${Orig_FacilityProposedcmt}     ,
    ${Orig_FacilityProposedcmt}    Convert To Number    ${Orig_FacilityProposedcmt}    2  
    
    ${Orig_FacilityClosingCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ClosingCmt_Textfield}    value%Amount 
    ${Orig_FacilityClosingCmt}    Remove String    ${Orig_FacilityClosingCmt}     ,
    ${Orig_FacilityClosingCmt}    Convert To Number    ${Orig_FacilityClosingCmt}    2 
    
    ${Orig_FacilityCurrentCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%Amount 
    ${Orig_FacilityCurrentCmt}    Remove String    ${Orig_FacilityCurrentCmt}     ,
    ${Orig_FacilityCurrentCmt}    Convert To Number    ${Orig_FacilityCurrentCmt}    2         
    
    ${Orig_FacilityOutstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    value%Amount
    ${Orig_FacilityOutstandings}    Remove String    ${Orig_FacilityOutstandings}    ,
    ${Orig_FacilityOutstandings}    Convert To Number    ${Orig_FacilityOutstandings}    2  
      
    ${Orig_FacilityAvailableToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%Amount
    ${Orig_FacilityAvailableToDraw}    Remove String    ${Orig_FacilityAvailableToDraw}    ,
    ${Orig_FacilityAvailableToDraw}    Convert To Number    ${Orig_FacilityAvailableToDraw}    2 

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_SummaryTab

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigFacilityProposedcmt}    ${Orig_FacilityProposedcmt}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigFacilityClosingCmt}    ${Orig_FacilityClosingCmt}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigFacilityCurrentCmt}    ${Orig_FacilityCurrentCmt}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigFacilityOutstandings}    ${Orig_FacilityOutstandings}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigFacilityAvailableToDraw}    ${Orig_FacilityAvailableToDraw}
    
    [Return]    ${Orig_FacilityProposedcmt}    ${Orig_FacilityClosingCmt}    ${Orig_FacilityCurrentCmt}    ${Orig_FacilityOutstandings}    ${Orig_FacilityAvailableToDraw}                 
       
Get Updated Data on Global Facility Amounts Section after Principal Payment
    [Documentation]    This Keyword is used to get updated data after Principal Payment transaction.
    ...    @author:mgaling
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sOrig_FacilityProposedcmt}    ${sOrig_FacilityClosingCmt}    ${sOrig_FacilityCurrentCmt}    ${sPrincipalPayment_RequestedAmount}    ${sOrig_FacilityOutstandings}    ${sOrig_FacilityAvailableToDraw}            
    
    ### GetRuntime Keyword Pre-processing ###
    ${Orig_FacilityProposedcmt}    Acquire Argument Value    ${sOrig_FacilityProposedcmt}
    ${Orig_FacilityClosingCmt}    Acquire Argument Value    ${sOrig_FacilityClosingCmt}
    ${Orig_FacilityCurrentCmt}    Acquire Argument Value    ${sOrig_FacilityCurrentCmt}
    ${PrincipalPayment_RequestedAmount}    Acquire Argument Value    ${sPrincipalPayment_RequestedAmount}
    ${Orig_FacilityOutstandings}    Acquire Argument Value    ${sOrig_FacilityOutstandings}
    ${Orig_FacilityAvailableToDraw}    Acquire Argument Value    ${sOrig_FacilityAvailableToDraw}

    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    mx LoanIQ select    ${LIQ_PrincipalPayment_OptionsFacilityNotebook}
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    
    ${New_FacilityProposedcmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ProposedCmt_Textfield}    value%Amount 
    ${New_FacilityProposedcmt}    Remove String    ${New_FacilityProposedcmt}     ,
    ${New_FacilityProposedcmt}    Convert To Number    ${New_FacilityProposedcmt}    2  
    
    Should Be Equal    ${New_FacilityProposedcmt}    ${Orig_FacilityProposedcmt}   
    Log    ${New_FacilityProposedcmt}=${Orig_FacilityProposedcmt}     
    
    ${New_FacilityClosingCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ClosingCmt_Textfield}    value%Amount 
    ${New_FacilityClosingCmt}    Remove String    ${New_FacilityClosingCmt}     ,
    ${New_FacilityClosingCmt}    Convert To Number    ${New_FacilityClosingCmt}    2 
    
    Should Be Equal    ${New_FacilityClosingCmt}    ${Orig_FacilityClosingCmt}   
    Log    ${New_FacilityClosingCmt}=${Orig_FacilityClosingCmt}
    
    ${New_FacilityCurrentCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%Amount 
    ${New_FacilityCurrentCmt}    Remove String    ${New_FacilityCurrentCmt}     ,
    ${New_FacilityCurrentCmt}    Convert To Number    ${New_FacilityCurrentCmt}    2         
    
    ${Computed_FacilityCurrentCmt}    Evaluate    ${Orig_FacilityCurrentCmt}-${PrincipalPayment_RequestedAmount}   
    ${Computed_FacilityCurrentCmt}    Convert To Number    ${Computed_FacilityCurrentCmt}    2
    Should Be Equal    ${New_FacilityCurrentCmt}    ${Computed_FacilityCurrentCmt}   
    Log    ${New_FacilityCurrentCmt}=${Computed_FacilityCurrentCmt}
    
    ${New_FacilityOutstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    value%Amount
    ${New_FacilityOutstandings}    Remove String    ${New_FacilityOutstandings}    ,
    ${New_FacilityOutstandings}    Convert To Number    ${New_FacilityOutstandings}    2  
    
    ${Computed_FacilityOutstandings}    Evaluate    ${Orig_FacilityOutstandings}-${PrincipalPayment_RequestedAmount}
    ${Computed_FacilityOutstandings}    Convert To Number    ${Computed_FacilityOutstandings}    2
    Should Be Equal    ${New_FacilityOutstandings}    ${Computed_FacilityOutstandings}   
    Log    ${New_FacilityOutstandings}=${Computed_FacilityOutstandings}
      
    ${New_FacilityAvailableToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%Amount
    ${New_FacilityAvailableToDraw}    Remove String    ${New_FacilityAvailableToDraw}    ,
    ${New_FacilityAvailableToDraw}    Convert To Number    ${New_FacilityAvailableToDraw}    2 
    
    Should Be Equal    ${New_FacilityAvailableToDraw}    ${Orig_FacilityAvailableToDraw}   
    Log    ${New_FacilityAvailableToDraw}=${Orig_FacilityAvailableToDraw}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_GlobalFacilityAmounts
                   
Validate Facility Events Tab after Payment Transaction
    [Documentation]    This Keyword is used to validate Events Tab after Principal Payment transaction.
    ...    @author:mgaling 
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sPrincipalPayment_RequestedAmount}    

    ### GetRuntime Keyword Pre-processing ###
    ${PrincipalPayment_RequestedAmount}    Acquire Argument Value    ${sPrincipalPayment_RequestedAmount}
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Events
    
    Mx LoanIQ Verify Text In Javatree    ${LIQ_FacilityEvents_JavaTree}    Commitment Decrease Released%yes
    Mx LoanIQ Select String    ${LIQ_FacilityEvents_JavaTree}    Commitment Decrease Released  
    ${Comment}    Mx LoanIQ Get Data    ${LIQ_FacilityEvents_Comment_Field}    value%comment
    
    ${PrincipalPayment_RequestedAmount}    Evaluate    "%.2f" % ${PrincipalPayment_RequestedAmount}    
    ${PrincipalPayment_RequestedAmount}    Convert Number With Comma Separators    ${PrincipalPayment_RequestedAmount}
    
    Should Be Equal As Strings    ${Comment}    Unscheduled decrease of ${PrincipalPayment_RequestedAmount} due to prepayment.
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_EventsTab

    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window} 

    mx LoanIQ close window    ${LIQ_PrincipalPayment_Window}

Validate Updated Facility Amounts After Payment - Capitalized Ongoing Fee
    [Documentation]    This keyword validates the new data on Loan Amounts Section.
    ...    @author:rtarayao
    ...    @update: dahijara    16OCT2020    - Added screenshot and pre-processing keywords
    [Arguments]    ${sOrig_FacilityCurrentCmt}    ${sOrig_FacilityOutstandings}    ${sOrig_FacilityAvailableToDraw}    ${sCapitalization_PctofPayment}    ${sCycleDue}    
    
    ### GetRuntime Keyword Pre-processing ###
    ${Orig_FacilityCurrentCmt}    Acquire Argument Value    ${sOrig_FacilityCurrentCmt}
    ${Orig_FacilityOutstandings}    Acquire Argument Value    ${sOrig_FacilityOutstandings}
    ${Orig_FacilityAvailableToDraw}    Acquire Argument Value    ${sOrig_FacilityAvailableToDraw}
    ${Capitalization_PctofPayment}    Acquire Argument Value    ${sCapitalization_PctofPayment}
    ${CycleDue}    Acquire Argument Value    ${sCycleDue}
	
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_SummaryTab
    ####### Validate 'Current Commitment' Amount
    ${Orig_FacilityCurrentCmt}    Convert To Number    ${Orig_FacilityCurrentCmt}    2
    
    ${New_FacilityCurrentCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%Amount 
    ${New_FacilityCurrentCmt}    Remove String    ${New_FacilityCurrentCmt}     ,
    ${New_FacilityCurrentCmt}    Convert To Number    ${New_FacilityCurrentCmt}    2         
       
    Should Be Equal    ${New_FacilityCurrentCmt}    ${Orig_FacilityCurrentCmt}   
    Log    There is no change in the current commitment amount of the Facility          
    
    ####### Validate 'Outstanding' Amount
    ${New_FacilityOutstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    value%Amount
    ${New_FacilityOutstandings}    Remove String    ${New_FacilityOutstandings}    ,
    ${New_FacilityOutstandings}    Convert To Number    ${New_FacilityOutstandings}    2  
    
    ${GlobalFacOutstandings_IncreasedAmt}    Evaluate    ${New_FacilityOutstandings}-${Orig_FacilityOutstandings}    
    ${GlobalFacOutstandings_IncreasedAmt}    Convert To Number    ${GlobalFacOutstandings_IncreasedAmt}    2
    
    ${CapitalizationPercentage}    Evaluate    ${Capitalization_PctofPayment}/100       
    ${Computed_IncreasedAmount}    Evaluate    ${CycleDue}*${CapitalizationPercentage} 
    ${Computed_IncreasedAmount}    Convert To Number    ${Computed_IncreasedAmount}    2
    
    Should Be Equal    ${GlobalFacOutstandings_IncreasedAmt}    ${Computed_IncreasedAmount}   
    Log    An increased amount of ${GlobalFacOutstandings_IncreasedAmt} is confirmed based on the computation of the conversion of the increase     
    
    ####### Validate 'Available to Draw' Amount
    ${New_FacilityAvailableToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%Amount
    ${New_FacilityAvailableToDraw}    Remove String    ${New_FacilityAvailableToDraw}    ,
    ${New_FacilityAvailableToDraw}    Convert To Number    ${New_FacilityAvailableToDraw}    2 
    
    ${Computed_FacilityAvailableToDraw}    Evaluate    ${Orig_FacilityAvailableToDraw}-${New_FacilityAvailableToDraw}
    ${Computed_FacilityAvailableToDraw}    Convert To Number    ${Computed_FacilityAvailableToDraw}    2
    Should Be Equal    ${Computed_FacilityAvailableToDraw}    ${Computed_IncreasedAmount}   
    Log    A decreased amount of ${Computed_FacilityAvailableToDraw} is confirmed based on the computation of the conversion of the decrease
       
    ####### Validate'Outstanding' and 'Available to Draw' Amount
    ${TotalAmount}    Evaluate    ${New_FacilityOutstandings}+${New_FacilityAvailableToDraw} 
    Should Be Equal    ${New_FacilityCurrentCmt}    ${TotalAmount}   
    Log    Total Amount for 'Outstanding' and 'Available to Draw' is confirmed equal to the current Facility commitment amount
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_SummaryTab

Get Global Facility Amounts
    [Documentation]    This keyword returns the Current Cmt, Outstandings amount, and Avail To Draw amount from the Facility Notebook's Summary Tab "Global Facility Amounts"
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    ${UI_GFA_CurrentCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%amount
    ${UI_GFA_Outstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    value%amount
    ${UI_GFA_AvailToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_AvailToDraw_Amount}    value%amount
    [Return]    ${UI_GFA_CurrentCmt}    ${UI_GFA_Outstandings}    ${UI_GFA_AvailToDraw}
    
Get Host Bank Share Gross Amounts
    [Documentation]    This keyword returns the Contr. Gross, Outstandings amount, and Avail To Draw amount from the Facility Notebook's Summary Tab "Host Bank Share Gross Amounts"
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    ${UI_HBG_ContrGross}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankContrGross}    value%amount
    ${UI_HBG_Outstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankOutstanding}    value%amount
    ${UI_HBG_AvailToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankAvailToDraw}    value%amount
    [Return]    ${UI_HBG_ContrGross}    ${UI_HBG_Outstandings}    ${UI_HBG_AvailToDraw}
    
Get Host Bank Share Net Amounts
    [Documentation]    This keyword returns the Contr. Gross, Outstandings amount, and Avail To Draw amount from the Facility Notebook's Summary Tab "Host Bank Share Gross Amounts"
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    ${UI_HBN_NetCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankNet_NetCmt}    value%amount
    ${UI_HBN_Outstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankNet_Outstandings}    value%amount
    ${UI_HBN_AvailToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankNet_AvailToDrawNet}    value%amount
    [Return]    ${UI_HBN_NetCmt}    ${UI_HBN_Outstandings}    ${UI_HBN_AvailToDraw}

Compute Avail To Draw After Drawdown
    [Documentation]    This keyword computes for the Avail To Draw amount in the Facility Notebook
    ...                @author: bernchua
    [Arguments]    ${CommitmentAmount}    ${OutstandingAmount}
    ${CommitmentAmount}    Remove Comma, Negative Character and Convert to Number    ${CommitmentAmount}
    ${OutstandingAmount}    Remove Comma, Negative Character and Convert to Number    ${OutstandingAmount}
    ${AvailToDraw}    Evaluate    ${CommitmentAmount}-${OutstandingAmount}
    ${AvailToDraw}    Convert To String    ${AvailToDraw}
    ${AvailToDraw}    Convert Number With Comma Separators    ${AvailToDraw}
    [Return]    ${AvailToDraw}

Compute Host Bank Share Commitment Amount
    [Documentation]    This keyword computes for the Host Bank Share Commitment Amount
    ...                @author: bernchua
    [Arguments]    ${Facility_ProposedCmt}    ${HostBank_Share}
    ${Facility_ProposedCmt}    Remove Comma, Negative Character and Convert to Number    ${Facility_ProposedCmt}
    ${HostBank_Share}    Evaluate    ${HostBank_Share}/100
    ${Commitment_Amount}    Evaluate    ${Facility_ProposedCmt}*${HostBank_Share}
    ${Commitment_Amount}    Convert To String    ${Commitment_Amount}
    ${Commitment_Amount}    Convert Number With Comma Separators    ${Commitment_Amount}
    [Return]    ${Commitment_Amount}
    
Validate Outstanding Amount After Drawdown
    [Documentation]    This kewyord computes for the Outstanding Amount in the Facility Notebook after Drawdown,
    ...                by adding the previous amount to the current outstanding amount, and should be equal to what is displayed.
    ...                @author: bernchua
    [Arguments]    ${Pre_OutstandingAmt}    ${Post_OutstandingAmt}    ${Current_OutstandingAmt}
    ${Pre_OutstandingAmt}    Remove Comma, Negative Character and Convert to Number    ${Pre_OutstandingAmt}
    ${Current_OutstandingAmt}    Remove Comma, Negative Character and Convert to Number    ${Current_OutstandingAmt}
    ${Computed_OutstandingAmt}    Evaluate    ${Pre_OutstandingAmt}+${Current_OutstandingAmt}
    ${Computed_OutstandingAmt}    Convert To String    ${Computed_OutstandingAmt}
    ${Computed_OutstandingAmt}    Convert Number With Comma Separators    ${Computed_OutstandingAmt}
    ${OutstandingAmt_ValidateStatus}    Set Variable If    '${Post_OutstandingAmt}'=='${Computed_OutstandingAmt}'    True
    [Return]    ${OutstandingAmt_ValidateStatus}
    
Post Validation Of Computed Amounts In Facility After Drawdown
    [Documentation]    This keyword validates the amounts shown in the Facility Notebook after an Initial Drawdown.
    ...                @author: bernchua
    ...                @update: dahijara    22SEP2020    - Added pre processing and screenshot.
    [Arguments]    ${sHostBank_Share}    ${sComputed_GlobalOutstanding}    ${sComputed_HostBankGrossOutstanding}    ${sComputed_HostBankNetOutstanding}
    ...    ${sPreOutstandingAmt_GFA}    ${sPreOutstandingAmt_HBG}    ${sPreOutstandingAmt_HBN}

    ### GetRuntime Keyword Pre-processing ###
    ${HostBank_Share}    Acquire Argument Value    ${sHostBank_Share}
    ${Computed_GlobalOutstanding}    Acquire Argument Value    ${sComputed_GlobalOutstanding}
    ${Computed_HostBankGrossOutstanding}    Acquire Argument Value    ${sComputed_HostBankGrossOutstanding}
    ${Computed_HostBankNetOutstanding}    Acquire Argument Value    ${sComputed_HostBankNetOutstanding}
    ${PreOutstandingAmt_GFA}    Acquire Argument Value    ${sPreOutstandingAmt_GFA}
    ${PreOutstandingAmt_HBG}    Acquire Argument Value    ${sPreOutstandingAmt_HBG}
    ${PreOutstandingAmt_HBN}    Acquire Argument Value    ${sPreOutstandingAmt_HBN}

    ${UI_GFA_CurrentCmt}    ${UI_GFA_Outstandings}    ${UI_GFA_AvailToDraw}    Get Global Facility Amounts
    ${UI_HBG_ContrGross}    ${UI_HBG_Outstandings}    ${UI_HBG_AvailToDraw}    Get Host Bank Share Gross Amounts
    ${UI_HBN_NetCmt}    ${UI_HBN_Outstandings}    ${UI_HBN_AvailToDraw}    Get Host Bank Share Net Amounts
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook
    
    ${HostBankShareGross_CommitAmt}    Compute Host Bank Share Commitment Amount    ${UI_GFA_CurrentCmt}    ${HostBank_Share}
    ${HostBankShareNet_CommitAmt}    Compute Host Bank Share Commitment Amount    ${UI_GFA_CurrentCmt}    ${HostBank_Share}
    
    ${Computed_GlobalAvailToDraw}    Compute Avail To Draw After Drawdown    ${UI_GFA_CurrentCmt}    ${UI_GFA_Outstandings}
    ${Computed_HostBankGrossAvailToDraw}    Compute Avail To Draw After Drawdown    ${UI_HBG_ContrGross}    ${UI_HBG_Outstandings}
    ${Computed_HostBankNetAvailToDraw}    Compute Avail To Draw After Drawdown    ${UI_HBN_NetCmt}    ${UI_HBN_Outstandings}
    
    ${GFAOutstanding_Status}    Validate Outstanding Amount After Drawdown    ${PreOutstandingAmt_GFA}    ${UI_GFA_Outstandings}    ${Computed_GlobalOutstanding}
    ${HBGOutstanding_Status}    Validate Outstanding Amount After Drawdown    ${PreOutstandingAmt_HBG}    ${UI_HBG_Outstandings}    ${Computed_HostBankGrossOutstanding}
    ${HBNOutstanding_Status}    Validate Outstanding Amount After Drawdown    ${PreOutstandingAmt_HBN}    ${UI_HBN_Outstandings}    ${Computed_HostBankNetOutstanding}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook
    Run Keyword If    '${HostBankShareGross_CommitAmt}'=='${UI_HBG_ContrGross}'    Log    Host Bank Share Gross Contr. Gross Amount of ${HostBankShareGross_CommitAmt} verified.
	Run Keyword If    '${HostBankShareNet_CommitAmt}'=='${UI_HBN_NetCmt}'    Log	Host Bank Share Net Net Cmt Amount of ${HostBankShareNet_CommitAmt} verified.
    
    Run Keyword If    ${GFAOutstanding_Status}==True    Log    Global Facility Outstanding Amount of ${UI_GFA_Outstandings} verified.
    Run Keyword If    ${HBGOutstanding_Status}==True    Log    Host Bank Share Gross Outstanding Amount of ${UI_HBG_Outstandings} verified.
    Run Keyword If    ${HBNOutstanding_Status}==True    Log    Host Bank Share Net Outstanding Amount of ${Computed_HostBankNetOutstanding} verified.
    
    Run Keyword If    '${Computed_GlobalAvailToDraw}'=='${UI_GFA_AvailToDraw}'    Log    Global Facility Avail To Draw Amount of ${Computed_GlobalAvailToDraw} verified.
    Run Keyword If    '${Computed_HostBankGrossAvailToDraw}'=='${UI_HBG_AvailToDraw}'    Log    Host Bank Share Gross Avail To Draw Amount of ${Computed_HostBankGrossAvailToDraw} verified.
    Run Keyword If    '${Computed_HostBankNetAvailToDraw}'=='${UI_HBN_AvailToDraw}'    Log    Host Bank Share Net Avail To Draw Amount of ${Computed_HostBankNetAvailToDraw} verified.
    
Post Validation Of Facility Summary Amounts After Drawdown
    [Documentation]    This keyword validates the Amounts shown in the Facility Notebook's Summary Tab after Drawdown.
    ...                It checks the before and after values, and verifies that the amount should not be equal.
    ...                @author: bernchua
    [Arguments]    ${sPreOutstandingAmt_GFA}    ${sPreOutstandingAmt_HBG}    ${sPreOutstandingAmt_HBN}
    ...    ${sPreAvailToDraw_GFA}    ${sPreAvailToDraw_HBG}    ${sPreAvailToDraw_HBN}

    ### GetRuntime Keyword Pre-processing ###
    ${PreOutstandingAmt_GFA}    Acquire Argument Value    ${sPreOutstandingAmt_GFA}
    ${PreOutstandingAmt_HBG}    Acquire Argument Value    ${sPreOutstandingAmt_HBG}
    ${PreOutstandingAmt_HBN}    Acquire Argument Value    ${sPreOutstandingAmt_HBN}
    ${PreAvailToDraw_GFA}    Acquire Argument Value    ${sPreAvailToDraw_GFA}
    ${PreAvailToDraw_HBG}    Acquire Argument Value    ${sPreAvailToDraw_HBG}
    ${PreAvailToDraw_HBN}    Acquire Argument Value    ${sPreAvailToDraw_HBN}

    ${UI_GFA_CurrentCmt}    ${UI_GFA_Outstandings}    ${UI_GFA_AvailToDraw}    Get Global Facility Amounts
    ${UI_HBG_ContrGross}    ${UI_HBG_Outstandings}    ${UI_HBG_AvailToDraw}    Get Host Bank Share Gross Amounts
    ${UI_HBN_NetCmt}    ${UI_HBN_Outstandings}    ${UI_HBN_AvailToDraw}    Get Host Bank Share Net Amounts
    Should Not Be Equal    ${PreOutstandingAmt_GFA}    ${UI_GFA_Outstandings}
    Should Not Be Equal    ${PreOutstandingAmt_HBG}    ${UI_HBG_Outstandings}    
    Should Not Be Equal    ${PreOutstandingAmt_HBN}    ${UI_HBN_Outstandings}
    Should Not Be Equal    ${PreAvailToDraw_GFA}    ${UI_GFA_AvailToDraw}
    Should Not Be Equal    ${PreAvailToDraw_HBG}    ${UI_HBG_AvailToDraw}
    Should Not Be Equal    ${UI_HBN_Outstandings}    ${UI_HBN_AvailToDraw}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook

Validate the New Total Global Facility Amounts after Drawdown
    [Documentation]    This keyword validates the Facility Current Global Outstandings Amount, Current Facility Commitment Amount, And Current Facility Avail To Draw Amount. 
    ...    This keyword also validates that the Sum of Outstandings and Avail to Draw Amount less the Current Commitment Amount is equal to zero(0).
    ...    If Loan is in Foreign Currency, the Total Converted Drawdown amount should be supplied for the TotalCurrentDrawdownAmt variable. 
    ...    @author: rtarayao 
    [Arguments]    ${TotalCurrentDrawdownAmt}    ${OriginalGlobalOutstandingAmt}    ${TotalComputedAvailToDrawAmt}    ${OriginalAvailToDrawAmt}    
    ${NewGlobalOutstandings}    Get New Facility Global Outstandings
    ${TotalComputedOutstandingAmt}    Evaluate    ${OriginalGlobalOutstandingAmt}+${TotalCurrentDrawdownAmt}
    Should Be Equal As Numbers    ${TotalComputedOutstandingAmt}    ${NewGlobalOutstandings}        
    Log    Total Computed Outstanding ${TotalComputedOutstandingAmt} is equal to Facility Outstanding ${NewGlobalOutstandings} 
    
    ${NewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${TotalComputedAvailToDrawAmt}    Evaluate    ${OriginalAvailToDrawAmt}-${TotalCurrentDrawdownAmt} 
    Should Be Equal As Numbers    ${TotalComputedAvailToDrawAmt}    ${NewAvailToDrawAmount}
    Log    Total ${TotalComputedAvailToDrawAmt} is equal to the Facility ${NewAvailToDrawAmount}                  
             
    ${CurrentCmtAmt}    Get Current Commitment Amount
    ${Computed_CurrentCmtAmt}    Evaluate    ${NewAvailToDrawAmount}+${NewGlobalOutstandings}
    Should Be Equal As Numbers    ${Computed_CurrentCmtAmt}    ${CurrentCmtAmt}
  
    ${SumTotal}    Evaluate    ${NewAvailToDrawAmount}+${NewGlobalOutstandings}
    ${DiffAmount}    Evaluate    ${SumTotal}-${CurrentCmtAmt}    
    ${DiffAmount}    Convert to String    ${DiffAmount}        
    Should Be Equal    ${DiffAmount}    0.0

Enter Dates on Facility Summary for Agency One Deal
    [Documentation]    This keyword enters dates on facility summary for Agency One Deal without excel writing.
    ...    @author: fmamaril
    [Arguments]    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    mx LoanIQ enter    ${LIQ_FacilitySummary_AgreementDate_Datefield}    ${Facility_AgreementDate}
    mx LoanIQ enter    ${LIQ_FacilitySummary_EffectiveDate_Datefield}    ${Facility_EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    mx LoanIQ enter    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    ${Facility_ExpiryDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}         
    mx LoanIQ enter    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}    ${Facility_MaturityDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}

Navigate to Facility Interest Pricing
    [Documentation]    This keyword navigates to the the Facility > Pricing > Modify Interest Pricing
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    
Complete Facility Pricing Setup
    [Documentation]    This keyword completes the Facility Ongoing / Interest Pricing setup by clikcing the OK button in the Pricing window.
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_FacilityPricing_OngoingFeeInterest_Window}
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_OK_Button}
    
Set Facility Pricing Penalty Spread
    [Documentation]    This keyword sets the Penalty Spread in the Facility > Pricing Tab.
    ...                @author: bernchua
    ...    @update: mcastro    27Aug2020    Added screenshot with correct path
    [Arguments]        ${PenaltySpread_Value}    ${PenaltySpread_Status}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_PenaltySpread_Modify_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_PenaltySpreadEditor_Window}
    mx LoanIQ enter    ${LIQ_PenaltySpreadEditor_Spread_Textfield}    ${PenaltySpread_Value}
    Mx LoanIQ Select Combo Box Value    ${LIQ_PenaltySpreadEditor_Status_List}    ${PenaltySpread_Status}
    mx LoanIQ click    ${LIQ_PenaltySpreadEditor_OK_Button}
    ${PenaltySpread_UI}    Mx LoanIQ Get Data    ${LIQ_FacilityPricing_PenaltySpread_Rate_Text}    value%spread
    ${PenaltySpread_UI}    Remove String    ${PenaltySpread_UI}    %
    ${PenaltySpread_UI}    Convert To Number    ${PenaltySpread_UI}
    ${PenaltySpread_Value}    Convert To Number    ${PenaltySpread_Value}
    Run Keyword If    '${PenaltySpread_UI}'=='${PenaltySpread_Value}'    Log    Penalty spread sucessfully added.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Pricing Tab
    
Add Sublimit for Facility
    [Documentation]    This keyword is used to add a Sublimit to the Facility.
    ...    @author: rtarayao 
    [Arguments]    ${SublimitName}    ${Currency}    ${EffectiveDate}    ${RiskType}    ${GlobalAmount}=FLOAT  
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Sublimit/Cust
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddSublimit_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window    ${LIQ_FacilitySublimitCust_SublimitDetails_Window}    
    mx LoanIQ enter    ${LIQ_FacilitySublimitCust_SublimitDetails_Name_Textfield}    ${SublimitName}
    Run Keyword If    '${GlobalAmount}' != 'FLOAT'    mx LoanIQ enter    ${LIQ_FacilitySublimitCust_SublimitDetails_GlobalAmt_Textfield}    ${GlobalAmount}        
    Mx LoanIQ Optional Select    ${LIQ_FacilitySublimitCust_SublimitDetails_Currency_Javalist}    ${Currency}
    mx LoanIQ enter    ${LIQ_FacilitySublimitCust_SublimitDetails_EffectiveDate}    ${EffectiveDate} 
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_SublimitDetails_RiskTypes_Modify_Button} 
    mx LoanIQ activate window    ${LIQ_FacilitySublimitCust_ModifyRiskTypes_Window}  
    Mx LoanIQ Select Or DoubleClick In Javatree  ${LIQ_FacilitySublimitCust_ModifyRiskTypes_Available_JavaTable}    ${RiskType}%s
    Mx Native Type    {DOWN}{1}   
    Mx Native Type    {SPACE}  
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_ModifyRiskTypes_OK_Button} 
    mx LoanIQ activate window    ${LIQ_FacilitySublimitCust_SublimitDetails_Window}   
    Mx LoanIQ Select String    ${LIQ_FacilitySublimitCust_SublimitDetails_RiskTypes_Javatree}    ${RiskType}  
    mx LoanIQ click    ${LIQ_FacilitySublimitCust_SublimitDetails_OK_Button}      

Add Facility Ongoing Fee - Matrix
    [Documentation]    Adds Ongoing Fee Matrix on the Facility Notebook's Ongoing Fee Pricing window.
    ...    @author: rtarayao
    [Arguments]    ${OngoingFee_Category}    ${OngoingFee_Type}    ${OngoingFee_RateBasis}
    ...    ${OngoingFee_AfterItem}    ${OngoingFee_AfterItem_Type}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("items count:=0")    VerificationData="Yes"
    Run Keyword If    ${status}==False    Mx Native Type    KEY.UP
    ${ContinueAdd}    Run Keyword    Add Item to Facility Ongoing Fee or Interest   ${OngoingFee_Category}    ${OngoingFee_Type}
    Run Keyword If    ${ContinueAdd}==True    Run Keywords
    ...    Set Fee Selection Details    ${OngoingFee_Category}    ${OngoingFee_Type}    ${OngoingFee_RateBasis}
    ...    AND    Add After Item to Facility Ongoing Fee    ${OngoingFee_Type}    ${OngoingFee_AfterItem}    ${OngoingFee_AfterItem_Type}
 
Set Commitment Fee Percentage Matrix
    [Documentation]    Sets the details in the Commitment Fee Percentage Matrix under Facility Notebook's Pricing tab.
    ...    FormulaCategoryType = The Formula Category that the Fee will be using. Either "Flat Amount" or "Formula".
    ...    Amount = The actual amount of the Fee.
    ...    SpreadType = The spread type used if Formula Category "Formula" is used. Either "Basis Points" or "Percent".
    ...    
    ...    @author: rtarayao
    [Arguments]    ${CommitmentPctType}    ${BalanceType}    ${GreaterThan}    ${LessThan}    ${MnemonicStatus}    ${MinimumValue}    ${MaximumValue}=Maximum
    Mx LoanIQ Select Combo Box Value    ${LIQ_PercentageCommitmentMatrix_Type_ComboBox}    ${CommitmentPctType}   
    Run Keyword If    '${BalanceType}'=='Deal'    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_DealBalance_RadioButton}    ON
    Run Keyword If    '${BalanceType}'=='Facility'    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_FacilityBalance_RadioButton}    ON
    Run Keyword If    '${GreaterThan}'=='>='    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_GreaterThanOrEqual_RadioButton}    ON
    ...    ELSE IF    '${GreaterThan}'=='>'    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_GreaterThan_RadioButton}    ON    
    mx LoanIQ enter    ${LIQ_PercentageCommitmentMatrix_MinimumValue_Field}    ${MinimumValue}
    Run Keyword If    '${MnemonicStatus}'=='ON'    Run Keywords
    ...    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_Mnemonic_Checkbox}    ON
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_PercentageCommitmentMatrix_LessThanOrEqual_RadioButton}    enabled%1
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_PercentageCommitmentMatrix_Mnemonic_JavaList}    value%Maximum
    Run Keyword If    '${MnemonicStatus}'=='OFF'    Set Commitment Fee Percentage Maximum    ${LessThan}    ${MaximumValue}
    mx LoanIQ click    ${LIQ_PercentageCommitmentMatrix_OK_Button}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("developer name:=.*Facility Ongoing Fee - Commitment Fee.*${CommitmentPctType}.*${MinimumValue}.*${MaximumValue}.*")        VerificationData="Yes"        VerificationData="Yes"
    ...    VerificationData="Yes"
    Run Keyword If    ${status}==True    Log    ${CommitmentPctType} with minimum value ${MinimumValue} and maximum value ${MaximumValue} has been successfully added.
    ...    ELSE    Fail    Commitment Fee Percentage Matrix has not been added.

Set Facility Utilized Percentage Matrix
    [Documentation]    Sets the details in the Facility Utilized Percentage Matrix under Facility Notebook's Pricing tab - Modify Interest Pricing.
    ...    FormulaCategoryType = The Formula Category that the Fee will be using. Either "Flat Amount" or "Formula".
    ...    Amount = The actual amount of the Fee.
    ...    SpreadType = The spread type used if Formula Category "Formula" is used. Either "Basis Points" or "Percent".   
    ...    @author: javinzon    11DEC2020    - Initial create
    [Arguments]    ${sCommitmentPctType}    ${sBalanceType}    ${sGreaterThan}    ${sLessThan}    ${sMnemonicStatus}    ${sMinimumValue}    ${sMaximumValue}=Maximum
    
    ### Keyword Pre-processing ###
    ${CommitmentPctType}    Acquire Argument Value    ${sCommitmentPctType}
    ${BalanceType}    Acquire Argument Value    ${sBalanceType}
    ${GreaterThan}    Acquire Argument Value    ${sGreaterThan}
    ${LessThan}    Acquire Argument Value    ${sLessThan}
    ${MnemonicStatus}    Acquire Argument Value    ${sMnemonicStatus}
    ${MinimumValue}    Acquire Argument Value    ${sMinimumValue}
    ${MaximumValue}    Acquire Argument Value    ${sMaximumValue}

    Mx LoanIQ Select Combo Box Value    ${LIQ_PercentageCommitmentMatrix_Type_ComboBox}    ${CommitmentPctType}   
    Run Keyword If    '${BalanceType}'=='Deal'    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_DealBalance_RadioButton}    ON
    Run Keyword If    '${BalanceType}'=='Facility'    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_FacilityBalance_RadioButton}    ON
    Run Keyword If    '${GreaterThan}'=='>='    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_GreaterThanOrEqual_RadioButton}    ON
    ...    ELSE IF    '${GreaterThan}'=='>'    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_GreaterThan_RadioButton}    ON    
    mx LoanIQ enter    ${LIQ_PercentageCommitmentMatrix_MinimumValue_Field}    ${MinimumValue}
    Run Keyword If    '${MnemonicStatus}'=='ON'    Run Keywords
    ...    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_Mnemonic_Checkbox}    ON
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_PercentageCommitmentMatrix_LessThanOrEqual_RadioButton}    enabled%1
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_PercentageCommitmentMatrix_Mnemonic_JavaList}    value%Maximum
    Run Keyword If    '${MnemonicStatus}'=='OFF'    Set Commitment Fee Percentage Maximum    ${LessThan}    ${MaximumValue}
    mx LoanIQ click    ${LIQ_PercentageCommitmentMatrix_OK_Button}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility.*Pricing").JavaTree("developer name:=.*${CommitmentPctType}.*${MinimumValue}.*${MaximumValue}.*")        VerificationData="Yes"        VerificationData="Yes"
    ...    VerificationData="Yes"
    Run Keyword If    ${status}==True    Log    ${CommitmentPctType} with minimum value ${MinimumValue} and maximum value ${MaximumValue} has been successfully added.
    ...    ELSE    Fail    Facility Utilized Percentage Matrix has not been added.

Set Commitment Fee Percentage Maximum
    [Documentation]    This keyword sets the Maximum value if Mnemonix checkbox is unticked.
    ...    @author: rtarayao
    [Arguments]    ${LessThan}    ${MaximumValue}
    Run Keyword If    '${LessThan}'=='<='    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_LessThanOrEqual_RadioButton}    ON
    ...    ELSE IF    '${LessThan}'=='<'    Mx LoanIQ Set    ${LIQ_PercentageCommitmentMatrix_LessThan_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_PercentageCommitmentMatrix_MaximumValue_Field}    ${MaximumValue}

Navigate to Facility Notebook - Modify Interest Pricing
    [Documentation]    This keyword navigates to Interest Pricing Window.
    ...    @author:mgaling
    ...    @mgaling: Added item to handle warning message
   
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Pricing     
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}

Save Facility Notebook Transaction
    [Documentation]    This keyword saves the current Facility Notebook transaction	
    ...    @author: bernchua	
    ...    @update: hstone     05JUN2020      - Added Warning OK Button Click
    ...    @update: mcastro    05JAN2021    - Added additional clicking of warning or question button
    
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}    
    mx LoanIQ select    ${LIQ_FacilityNotebook_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Validate if Question or Warning Message is Displayed

Add Borrower Sublimits Limits
    [Documentation]    This keyword adds Sublimit to the Borrower.
    ...    @author: rtarayao
    ...    Ex Multiple Input: Sublimit 1 | Sublimit 2 | Sublimit 3 and so on..
    ...    Ex Single Input: Sublimit 1
    [Arguments]    ${SublimitName}
    @{SublimitNameArray}    Split String    ${SublimitName}    |
    ${SublimitNameCount}    Get Length    ${SublimitNameArray}      
    mx LoanIQ activate window     ${LIQ_BorrowerDepositorSelect_Window}
    :FOR    ${INDEX}    IN RANGE    ${SublimitNameCount}
    \    ${SublimitName}    Strip String    ${SPACE}@{SublimitNameArray}[${INDEX}]${SPACE}
    \    mx LoanIQ click    ${LIQ_BorrowerDepositorSelect_AddBorrower_AddSublimit_Button}
    \    Mx LoanIQ Select Combo Box Value    ${LIQ_SublimitEditor_Sublimit_List}    ${SublimitName}
    \    mx LoanIQ click    ${LIQ_SublimitEditor_OK_Button}
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Mx LoanIQ Select String    ${LIQ_BorrowerDepositorSelect_AddBorrower_Sublimit_JavaTree}    ${SublimitName}

Add Borrower Risk Type Limits
    [Documentation]    This keyword adds Risk Types Limits upon adding a Borrower/Depositor in the Facility.
    ...    @author: rtarayao
    ...    Ex Multiple Input: RiskType 1 | RiskType 2 | RiskType 3 and so on..
    ...    Ex Single Input: RiskType 1
    [Arguments]    ${RiskType}
    @{RiskTypeArray}    Split String    ${RiskType}    |
    ${RiskTypeCount}    Get Length    ${RiskTypeArray}      
    mx LoanIQ activate window     ${LIQ_BorrowerDepositorSelect_Window}
    :FOR    ${INDEX}    IN RANGE    ${RiskTypeCount}
    \    ${RiskType}    Strip String    ${SPACE}@{RiskTypeArray}[${INDEX}]${SPACE}
    \    mx LoanIQ click    ${LIQ_BorrowerDepositorSelect_AddBorrower_AddRisk_Button}
    \    Mx LoanIQ Select Combo Box Value    ${LIQ_RiskTypeLimit_RiskType_List}    ${RiskType}
    \    mx LoanIQ click    ${LIQ_RiskTypeLimit_OK_Button}
    \    Mx LoanIQ Select String    ${LIQ_BorrowerDepositorSelect_AddBorrower_RiskType_JavaTree}    ${RiskType}

Add Borrower Currency Limits
    [Documentation]    This keyword adds Currency Limits upon adding a Borrower/Depositor in the Facility.
    ...    @author: rtarayao
    ...    Ex Multiple Input: Currency 1 | Currency 2 | Currency 3 and so on..
    ...    Ex Single Input: Currency 1
    [Arguments]    ${Currency}
    @{CurrencyArray}    Split String    ${Currency}    |
    ${CurrencyCount}    Get Length    ${CurrencyArray}      
    mx LoanIQ activate window     ${LIQ_BorrowerDepositorSelect_Window}
    :FOR    ${INDEX}    IN RANGE    ${CurrencyCount}
    \    ${Currency}    Strip String    ${SPACE}@{CurrencyArray}[${INDEX}]${SPACE}
    \    mx LoanIQ click    ${LIQ_FacilitySublimitCust_AddBorrower_AddCurr_Button}
    \    mx LoanIQ activate window    ${LIQ_Currency_Limit_Edit_Window}
    \    Mx LoanIQ Select Combo Box Value    ${LIQ_Currency_Limit_Edit_Currency_ComboBox}    ${Currency}
    \    mx LoanIQ click    ${LIQ_Currency_Limit_Edit_Ok_Button}
    \    Mx LoanIQ Select String    ${LIQ_BorrowerDepositorSelect_AddBorrower_Currency_JavaTree}    ${Currency}


Ongoing Fee Pricing Window Press Up Key Until Add Button is Enabled
    [Documentation]    This keyword is used to press the UP key until the Add Button is Enabled.    
    ...    @author: rtarayao
    :FOR    ${i}    IN RANGE    10
    \    ${AfterButton_Status}    Mx LoanIQ Get Data    ${LIQ_FacilityPricing_OngoingFees_Add_Button}    enabled%add
    \    Run Keyword If    '${AfterButton_Status}'=='0'    Mx Press Combination    Key.Up
    \    Exit For Loop If    '${AfterButton_Status}'=='1'

Add Item to an Exisiting Facility Ongoing Fee
    [Documentation]    Adds another Item to an existing Ongoing Fee in the Facility Notebook.
    ...    This is used to add item for multiple matrix for the same ongoing fee.
    ...    @author: rtarayao
    [Arguments]    ${OngoingFee_Item}    ${OngoingFee_Type}
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_Add_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    ${OngoingFee_Item}
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    ${OngoingFee_Type}
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}

Add After Item to an Existing Facility Ongoing Fee
    [Documentation]    Adds another After Item to an existing Ongoing Fee in the Facility Notebook.
    ...    This is used to add after item for multiple matrix for the same ongoing fee.
    ...    @author: rtarayao
    [Arguments]    ${OngoingFee_Type}    ${OngoingFee_AfterItem}    ${OngoingFee_AfterItem_Type}
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_After_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    ${OngoingFee_AfterItem}
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    ${OngoingFee_AfterItem_Type}
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Navigate to Ongoing Fee Pricing Window
    [Documentation]    This keyword is used to navigate the user from any Tab within the Facility Notebook to open the Ongoing Fee window under Pricing Tab.
    ...    @author: rtarayao    04MAR2019    Initial create
    ...    @update: dahijara    26JUN2020    - added keyword to take screenshot
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_OngoingFeePricing

Navigate to Interest Fee Pricing Window
    [Documentation]    This keyword is used to navigate the user from any Tab within the Facility Notebook to open the Interest Fee window under Pricing Tab.
    ...    @author: rtarayao    06MAR2019    Initial create
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 

Close Facility Notebook and Navigator Windows
    [Documentation]    This keyword is used to close the Facility Notebook and Navigtor windows when a user tries to add another Facility to a Deal.
    ...    @author: rtarayao    07MAR2019    Initial create
    ...    @update: clanding    13AUG2020    Added screenshot
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebookWindow
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNavigatorWindow
    
Add MIS Code
    [Documentation]    This keyword is used to add MIS Codes at the Facility Notebook
    ...    @author: henstone    14AUG2019    Initial create
    ...    @author: mcastro    27Aug2020    Added correct screenshot path   
    [Arguments]    ${sMIS_Code}    ${sValue}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    MIS Codes
    mx LoanIQ click    ${LIQ_FacilityMISCodes_Add_Button}
    mx LoanIQ activate window    ${LIQ_FacilityMISCodes_FacilityMISCodeDetails_Window}
    mx LoanIQ select list    ${LIQ_FacilityMISCodes_MISCode_List}    ${sMIS_Code}   
    
    ### MIS Value Verification ###
    ${verifyResult}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property
    ...    ${LIQ_FacilityMISCodes_Value_Field}    MIS_Value%${sValue}
    Run Keyword If    ${verifyResult} == True    Log    MIS Value Field Verified
    
    ### Confirm MIS Code Addition ###
    mx LoanIQ click    ${LIQ_FacilityMISCodes_OK_Button}
    
    ### Get MIS Value at the MIS Code Tree ###
    ${sMIS_Value_JavaTree}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityMISCodes_MISCodes_JavaTree}    ${sMIS_Code}%Value%value  
    
    ### Verify MIS Value Acquired ###
    ${result}    Run Keyword And Return Status    Should Be Equal As Strings    ${sMIS_Value_JavaTree}    ${sValue}
    Run Keyword If    '${result}'=='True'    Log    MIS Code Value is Verified   level=INFO
    Run Keyword If    '${result}'=='False'    Log    MIS Code Value is ${sMIS_Value_JavaTree} instead of ${sValue}    level=ERROR  

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_MIS Code
    
Go to Facility Pricing Tab
    [Documentation]    This keyword will go to the Facility's Pricing Tab.
    ...                @author: bernchua    20AUG2019    Initial create
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    
Click Modify Ongoing Fees In Facility Pricing
    [Documentation]    This keyword will click the 'Modify Ongoing Fees' button in the Facility Pricing
    ...                @author: bernchua    20AUG2019    Initial create
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Click Modify Interest Pricing In Facility
    [Documentation]    This keyword will click the 'Modify Ongoing Fees' button in the Facility Pricing
    ...                @author: bernchua    20AUG2019    Initial create
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Set Facility SIC Details
    [Documentation]    This keyword will set the SIC details in the Codes tab of the Facility Notebook
    ...                @author: bernchua    21AUG2019    Initial create
    ...                @author: bernchua    22AUG2019    Update to get description first before entering code
    [Arguments]    ${SIC_Country}    ${SIC_SearchBy}    ${SIC_Code}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Codes
    mx LoanIQ click    ${LIQ_FacilityCodes_SIC_Button}
    mx LoanIQ activate    ${LIQ_SICSelect_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_SICSelect_Country_List}    ${SIC_Country}
    Mx LoanIQ Set    JavaWindow("title:=SIC Select").JavaRadioButton("label:=${SIC_SearchBy}")    ON
    ${SIC_Description}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SICSelect_Code_List}    ${SIC_Code}%Description%description
    mx LoanIQ enter    ${LIQ_SICSelect_Code_Textfield}    ${SIC_Code}
    ${SICCode_Descrition}    Set Variable    ${SIC_Code} - AU / ${SIC_Description}
    mx LoanIQ click    ${LIQ_SICSelect_OK_Button}
    ${UI_SICCodeDescription}    Mx LoanIQ Get Data    ${LIQ_FacilityCodes_SICDescription_Text}    value%data
    ${VALIDATE_SIC}    Run Keyword And Return Status    Should Be Equal    ${SICCode_Descrition}    ${UI_SICCodeDescription}
    Run Keyword If    ${VALIDATE_SIC}==True    Log    SIC Code successfully added and validated.
    ...    ELSE    Fail    SIC Code validation not successful.

Get Facility Host Bank Net and Fundable Cmt Amount
    [Documentation]    This keyword returns the amount for both the Host Bank Net Commitment and Host Bank Bank Fundable Commitment.
    ...    @author: rtarayao    16AUG2019    Initial Create
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    ${FacHBNetCmtAmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_NetCmt}    value%FacHBNetCmt
    Log    The Facility Host Bank Net Commitment amount is ${FacHBNetCmtAmt}            
    ${FacHBFundableCmtAmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_FundableCmt}    value%FacHBFundableCmt
    Log    The Facility Host Bank Fundable Commitment amount is ${FacHBFundableCmtAmt}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Facility Amts
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FacHBNetCmtAmt}    ${FacHBFundableCmtAmt}

Get Facility Host Bank Outstanding Net and Avail to Draw Amount
    [Documentation]    This keyword returns the amount for both the Host Bank Outstanding Net and Host Available to Draw.
    ...    @author: rtarayao    16AUG2019    Initial Create 
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    ${FacHBOutstandingNetAmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_Outstandings_Funded}    value%FacHBOutstandingNet             
    Log    The Facility Host Bank Net Outstanding amount is ${FacHBOutstandingNetAmt}
    ${FacHBNetAvailToDrawAmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_AvailToDraw_Fundable}    value%FacHBNetAvailToDraw
    Log    The Facility Host Bank Net Available to draw amount is ${FacHBNetAvailToDrawAmt}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Facility Amts
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FacHBOutstandingNetAmt}    ${FacHBNetAvailToDrawAmt} 
    
Get Facility Global Closing and Current Cmt Amount
    [Documentation]    This keyword returns the amount for both the Facility Global Closing Commitment and Global Current Commitment.
    ...    @author: rtarayao    16AUG2019    Initial Create     
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    ${FacGlobalCurrentCmtAmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%FacGlobalCurrentCmt
    Log    The Facility Global Current Commitment amount is ${FacGlobalCurrentCmtAmt}
    ${FacGlobalClosingCmtAmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ClosingCmt_Textfield}    value%FacGlobalClosingCmt
    Log    The Facility Global Closing Commitment amount is ${FacGlobalClosingCmtAmt}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Facility Amts
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FacGlobalCurrentCmtAmt}    ${FacGlobalClosingCmtAmt}        
    
Get Facility Global Outstanding and Available to Draw Amount
    [Documentation]    This keyword returns the amount for both the Global Outstanding and Global Available to Draw.
    ...    @author: rtarayao    16AUG2019    Initial Create     
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    ${FacGlobalOutstandingAmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    value%FacGlobalOutstanding
    Log    The Facility Global Outstanding amount is ${FacGlobalOutstandingAmt}
    ${FacGlobalAvailtoDrawAmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%FacGlobalAvailtoDraw
    Log    The Facility Global Avail to draw amount is ${FacGlobalAvailtoDrawAmt}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Facility Amts
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FacGlobalOutstandingAmt}    ${FacGlobalAvailtoDrawAmt}  

Get Facility Multi CCY Status
    [Documentation]    This keyword is used to validate the Facility Multi currency checkbox and return its status.
    ...    @author: rtarayao    16AUG2019    Initial Create
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_FacilitySummary_MultiCurrencyFacility_Checkbox}    value%1
    Log    Multi Currency status is ${status}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Multi Currency
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${status}    
    
Get Facility Control Number
    [Documentation]    This keyword returns the Facility Control Number.
    ...    @author: rtarayao    16AUG2019    Initial Create
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    ${FacilityControlNumber}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_FCN_Text}    text%FCN 
    Log    The Facility Control Number is ${FacilityControlNumber} 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    FCN
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FacilityControlNumber}

Get Facility Outstanding Count
    [Documentation]    This keyword returns the number of Outstanding in a Facility.
    ...    Example: sLender=OutstandingAlias1|OutstandingAlias2|OutstandingAlias3 . . . 
    ...             sDelimiter=|
    ...    @author: rtarayao    16AUG2019    Initial Create
    [Arguments]    ${sOutstandingAlias}    ${sDelimiter}
    @{OutstandingList}    Split String    ${sOutstandingAlias}    ${sDelimiter}
    Log    ${OutstandingList}    
    ${OutstandingCount}    Get Length    ${OutstandingList}
    Log    The number of Borrower is ${OutstandingCount}        
    [Return]    ${OutstandingCount}

Get Facility Funding Desk Description
    [Documentation]    This keyword returns the facility funding desk description.
    ...    @author: rtarayao    16AUG2019    Initial Create
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Codes
    ${FundingDeskDesc}    Mx LoanIQ Get Data    ${LIQ_Facility_Codes_FundingDesk_Text}    text%FundingDeskDesc
    Log    The Facility funding desk description is ${FundingDeskDesc} 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Funding Desk
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FundingDeskDesc}
    
Get Facility Expense Code and Description Combined
    [Documentation]    This keyword returns the facility expense code and description used.
    ...    @author: rtarayao    16AUG2019    Initial Create
    [Arguments]    ${sExpenseCode}    ${sExpenseDesc}
    Log    Expense code and description are ${sExpenseCode} and ${sExpenseDesc} respectively.
    ${FacExpenseCode}    Catenate    SEPARATOR=|    ${sExpenseCode}    ${sExpenseDesc}        
    Log    The combined expense code and description is ${FacExpenseCode}          
    [Return]    ${FacExpenseCode}

Close Facility Navigator Window
    [Documentation]    This keyword is used to close the Facility Navigtor window.
    ...    @author: rtarayao    19AUG2019    Initial create
    ...    @update: clanding    04AUG2020    Added screenshot
    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNavigatorWindow
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNavigatorWindow

Convert LIQ Date to Year-Month-Day Format
    [Documentation]    This keyword converts the LIQ date format to Y-M-D format
    ...    @author: rtarayao    20AUG2019    Initial Create
    [Arguments]    ${sLIQDate}
    ${sDate}    Convert Date    ${sLIQDate}    result_format=%Y-%m-%d    date_format=%d-%b-%Y
    Log    ${sDate}
    [Return]    ${sDate}
    
Add Facility Ongoing Fees with Matrix
    [Documentation]    Adds Ongoing Fees on the Facility Notebook's Ongoing Fee Pricing window.
    ...                ${FormulaCategoryType} = The Formula Category the Ongoing Fee will be using (Flat Amount / Formula)
    ...                @update: fmamaril    26AUG2019    Updated keyword documentation
    [Arguments]    ${sOngoingFee_Category}    ${sOngoingFee_Type}    ${sOngoingFee_RateBasis}    ${sOngoingFee_AfterItem}    
    ...    ${sOngoingFee_AfterItem_Type}    ${sFormulaCategoryType}    ${sOngoingFee_SpreadType}    ${sOngoingFee_SpreadAmount}
    ...    ${sInterest_FinancialRatioType}    ${sMnemonic_Status}    ${iGreater_Than}    ${iLess_Than}    ${iFinancialRatio_Minimum}    ${iFinancialRatio_Maximum}    ${sSetFeeSelectionDetails}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFeeInterest_NoItems_JavaTree}    VerificationData="Yes"
    Run Keyword If    ${status}==False    Mx Press Combination    Key.Up   
    ${ContinueAdd}    Run Keyword    Add Item to Facility Ongoing Fee or Interest   ${sOngoingFee_Category}    ${sOngoingFee_Type}    
    Run Keyword If    ${ContinueAdd}==True and ${sSetFeeSelectionDetails}==True    Set Fee Selection Details    ${sOngoingFee_Category}    ${sOngoingFee_Type}    ${sOngoingFee_RateBasis}
    Run Keyword If    ${ContinueAdd}==True    Run Keywords    Add After Item to Facility Ongoing Fee    ${sOngoingFee_Type}    ${sOngoingFee_AfterItem}    ${sOngoingFee_AfterItem_Type}
    ...    AND    Set Financial Ratio    ${sInterest_FinancialRatioType}    ${sMnemonic_Status}    ${iGreater_Than}    ${iLess_Than}    ${iFinancialRatio_Minimum}    ${iFinancialRatio_Maximum}
    ...    AND    Add After Item to Facility Ongoing Fee    ${sInterest_FinancialRatioType}    FormulaCategory    Normal
    ...    AND    Set Formula Category For Fees    Formula    ${sOngoingFee_SpreadAmount}    ${sOngoingFee_SpreadType}
    # ...    AND    Validate Facility Pricing Items    ${sOngoingFee_Category}
    # ...    AND    Validate Facility Pricing Items    ${sOngoingFee_Type}
    # ...    AND    Validate Facility Pricing Items    ${sOngoingFee_SpreadAmount}    ${sOngoingFee_SpreadType} 
    
Add Multiple Ratio
    [Documentation]    Adds Ongoing Fees on the Facility Notebook's Ongoing Fee Pricing window.
    ...                ${FormulaCategoryType} = The Formula Category the Ongoing Fee will be using (Flat Amount / Formula)
    ...                @author: fmamaril    20AUG2019    Updated keyword documentation
    [Arguments]    ${sOngoingFee_Category}    ${sOngoingFee_Type}    ${sOngoingFee_RateBasis}    
    ...    ${sOngoingFee_SpreadType}    ${sOngoingFee_SpreadAmount}    ${sInterest_FinancialRatioType}    ${sMnemonic_Status}
    ...    ${iGreater_Than}    ${iLess_Than}    ${iFinancialRatio_Minimum}    ${iFinancialRatio_Maximum}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFeeInterest_NoItems_JavaTree}    VerificationData="Yes"
    Run Keyword If    ${status}==False    Mx Press Combination    Key.Up 
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_Add_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    ${sOngoingFee_Category}
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    ${sOngoingFee_Type}
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    # Set Fee Selection Details    ${sOngoingFee_Category}    ${sOngoingFee_Type}    ${sOngoingFee_RateBasis}
    Set Financial Ratio    ${sInterest_FinancialRatioType}    ${sMnemonic_Status}    ${iGreater_Than}    ${iLess_Than}    ${iFinancialRatio_Minimum}    ${iFinancialRatio_Maximum}
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_After_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    FormulaCategory
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    Normal
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    Set Formula Category For Fees    Formula    ${sOngoingFee_SpreadAmount}    ${sOngoingFee_SpreadType}
    
Navigate to Interest Pricing
    [Documentation]    High Level Keyword for navigating to Interest Pricing
    ...    @author: fmamaril    26AUG2019    Initial Create
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}         
    Run Keyword And Ignore Error    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
        
Navigate to Ongoing Fees
    [Documentation]    This keyword navigates the user to Ongoing Fees
    ...    @author: fmamaril    26AUG2019    Initial Create 
    Run Keyword and Ignore Error    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OK_Button}    
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Modify Multiple Ongoing Fee Pricing - Insert Add
    [Documentation]    This keyword adds ongoing fee - add on facility.
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${FacilityItem}    ${FeeType}    ${RateBasisOngoingFeePricing} 
   
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_Add_Button}
    Sleep    2
    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityPricing_OngoingFees_AddItemList}    ${FacilityItem}   
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FeeSelection_Category_List}    ${FacilityItem}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FeeSelection_Type_List}    ${FeeType} 
    Mx LoanIQ Select Combo Box Value    ${LIQ_FeeSelection_RateBasis_List}    ${RateBasisOngoingFeePricing} 
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_FreeSelection_OK_Button}        
    
Navigate to Facility Business Event
    [Documentation]    This keyword navigates LoanIQ to the deal's business event window.
    ...    @create: hstone    05SEP2019    Initial create
    ...    @update: amansuet    02OCT2019    Added screenshot
    ...    @update: rtarayao    17FEB2020    - added logic to handle Start Date greater than End Date in the Event Queue Output window.
    ...    @update: mcastro   10SEP2020    Updated screenshot path
    [Arguments]    ${sEvent}=None
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Events
    
    ${sFetchedEvent}    Run Keyword If    '${sEvent}'!='None'    Select Java Tree Cell Value First Match    ${LIQ_FacilityEvents_JavaTree}    ${sEvent}    Event
    ...    ELSE    Set Variable    None 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_Business_Event
    ${IsMatched}    Run Keyword And Return Status    Should Be Equal As Strings    ${sFetchedEvent}    ${sEvent}        
    Run Keyword If    ${IsMatched}==${True}    Log    Event Verification Passed        
    ...    ELSE    Fail    Event Verification Failed. ${sFetchedEvent} != ${sEvent}
    
    ${sEffectiveDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityEvents_JavaTree}    ${sFetchedEvent}%Effective%EffectiveDate
    ${sEffectiveDate}    Convert Date    ${sEffectiveDate}    date_format=%d-%b-%Y    result_format=%Y-%m-%d
    ${sEndDate}    Get Current Date    result_format=%Y-%m-%d                
    ${diff}    Subtract Date From Date    ${sEndDate}    ${sEffectiveDate}    result_format=verbose
    Log    ${diff}
    ${diff}    Remove String    ${diff}    ${SPACE}    day    s
          
    mx LoanIQ click    ${LIQ_FacilityEvents_EventsQueue_Button}    
    
    Run Keyword If    ${diff} == 0 or ${diff} > 0    Mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE     Run Keywords    Mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    ...    AND    Mx LoanIQ Enter    ${LIQ_BusinessEventOutput_StartDate_Field}    ${sEndDate}
    ...    AND    Mx LoanIQ Click    ${LIQ_BusinessEventOutput_Refresh_Button}
    ...    AND    Mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    
Get Borrower Details From Facility Notebook
    [Documentation]    This keyword gets the Borrower Details from the Facility Notebook's Sublimit/Cust Tab.
    ...    @author: hstone
    [Arguments]    ${sCustomerName}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Sublimit/Cust
    
    ${BorrowerFlag}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilitySublimitCust_Borrowers_Tree}    ${sCustomerName}%Borrower%value
    ${sCustomerProfileType}    Run Keyword If    '${BorrowerFlag}'=='Y'    Set Variable    Borrower
    Log    ${sCustomerName} Customer Profile Type is "${sCustomerProfileType}".
  
    ${PrimaryBorrowerFlag}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilitySublimitCust_Borrowers_Tree}    ${sCustomerName}%Pri%value
    ${bPrimaryBorrower}    Run Keyword If    '${PrimaryBorrowerFlag}'=='*'    Set Variable    true
    ...    ELSE    Set Variable    false
    Log    ${sCustomerName} Primary Borrower Flag is "${bPrimaryBorrower}".
    [Return]    ${sCustomerProfileType}    ${bPrimaryBorrower}

Navigate to Commitment Fee List
    [Documentation]    This keyword is used for navigating Commitment Fee List from Facility Notebook.
    ...    @author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_OngoingFeeList}
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}

Get Ongoing Fee Alias and Status 
    [Documentation]    This keyword returns the Fee Alias and Status for a specific Ongoing Fee.
    ...    Ongoing Fees are as follows:
    ...        Commitment Fee
    ...        Fronting Commitment Fee (SFBG)
    ...        Fronting Line Fee (SFBG)
    ...        Indemnity Fee – Commitment (SFBG)
    ...        Indemnity Fee – Line (SFBG)
    ...        Indemnity Fee – Usage (SFBG)
    ...        Line Fee
    ...        Risk Cover Premium Fee
    ...        Usage Fee
    ...    @author: rtarayao    30AUG2019    - Initial Create
    [Arguments]    ${sFeeType}
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    ${Fee_Status}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FeeList_JavaTree}    ${sFeeType}%Status%Fee Status
    ${Fee_Alias}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FeeList_JavaTree}    ${sFeeType}%Fee Alias%Fee Alias  
    [Return]    ${Fee_Status}    ${Fee_Alias}
Get Facility Ongoing Fee Alias
    [Documentation]    Keyword used to get the Fee Alias of the Facility's Ongoing Fee after Deal Close.
    ...                @author: bernchua
    [Arguments]    ${sFacility_Name}
    Open Facility Navigator from Deal Notebook
    Open Ongoing Fee List from Facility Navigator    ${sFacility_Name}
    ${Fee_Alias}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FeeList_JavaTree}    ${sFacility_Name}%Fee Alias%alias
    mx LoanIQ close window    ${LIQ_Facility_FeeList}
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    [Return]    ${Fee_Alias}
    
Open Ongoing Fee List from Facility Navigator
    [Documentation]    Keyword used to select a Facility from the Facility Navigator and open it's Ongoing Fee List
    ...                @author: bernchua    17SEP2019    Initial create
    [Arguments]    ${sFacility_Name}
    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}
    Mx LoanIQ Select String    ${LIQ_FacilityNavigator_Tree}    ${sFacility_Name}
    mx LoanIQ click    ${LIQ_FacilityNavigator_OngoingFees_Button}
    
Open Pending Ongoing Fee from Ongoing Fee List
    [Documentation]    Keyword used to Open a Pending Ongoing Fee from the Ongoing Fee List
    ...                @author: bernchua    17SEP2019    Initial create
    [Arguments]    ${sFee_Alias}
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    ${OngoingFee_STATUS}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FeeList_JavaTree}    ${sFee_Alias}%Status%status
    Run Keyword If    '${OngoingFee_STATUS}'=='Pending'    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeeList_JavaTree}    ${sFee_Alias}%d
    ...    ELSE IF    '${OngoingFee_STATUS}'!='Pending'   Fail    Selected Ongoing Fee Alias is already Released.

Create Pending Transaction in Facility Schedule
    [Documentation]    This keyword is used to create a Pending Transaction in a Facility Schedule
    ...    @author: ritragel    23SEP2019    Initial Create
    [Arguments]    ${sCycleNumber}    ${sEffectiveDate}
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    Options    Increase/Decrease Schedule...
    mx LoanIQ activate window    ${LIQ_AMD_AmortizationSchedforFacility_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${AmortizationSchedforFacility_CurrentSchedule}    ${sCycleNumber}%s
    mx LoanIQ click    ${LIQ_AMD_AmortSched_CreatePending_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_CreatePending_EffectiveDateField}    ${sEffectiveDate}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_CreatePending_OKButton}

Enter Facility Schedule Commitment Details
    [Documentation]    This keyword is used to enter details in Schedule Commitment window
    ...    @author: ritragel    23SEP2019    Initial Create
    [Arguments]    ${sMessage}=Testing
    mx LoanIQ activate window    ${LIQ_ScheduledCommitment_Notebook}
    mx LoanIQ enter    ${LIQ_ScheduledCommitment_Comment_JavaEdit}    ${sMessage}
    Select Menu Item    ${LIQ_ScheduledCommitment_Notebook}    File    Save

Rename Facility Name at Facility Notebook
    [Documentation]    Keyword used to rename a Facility at the facility notebook.
    ...                @author: hstone    23SEP2019    Initial create
    [Arguments]    ${sNew_Facility_Name}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    Options    Rename Facility...
    mx LoanIQ enter    ${LIQ_FacilityNotebook_Rename_NewName_Field}    ${sNew_Facility_Name}
    mx LoanIQ click    ${LIQ_FacilityNotebook_Rename_OK_Button}

Open Ongoing Fee from Fee List
    [Documentation]    Keyword used to open an Ongoing Fee from the Fee List window
    ...                @author: bernchua    24SEP2019    Initial create
    [Arguments]    ${sFee_Alias}
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeeList_JavaTree}    ${sFee_Alias}%d

Add New Facility without Facility Cmt Amt
    [Documentation]    Goes to Facility Navigator from the Deal Notebook and adds a new Facility without Facility Cmt Amt
    ...    
    ...    Requires the Deal Name for validation of the Facility Navigator Window Name and Facility Window Name
    ...    Requires the Deal Currency for validation of the Facility Navigator Window Name
    ...    
    ...    @author: ehugo    27SEP2019    Initial create
    
    [Arguments]    ${Deal_Name}    ${Deal_Currency}    ${Facility_Name}    ${Facility_Type}    ${Facility_Currency}
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    ${status}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNavigator_Window}    VerificationData="Yes"
    ${verify}    Run Keyword And Return Status    Run Keyword If    ${status}==True
    ...    Mx LoanIQ Verify Runtime Property    JavaWindow("title:=Facility Navigator - ${Deal_Name} in ${Deal_Currency}")    title%Facility Navigator - ${Deal_Name} in ${Deal_Currency}
    Run Keyword If    ${verify}==True    Run Keywords
    ...    Log    Facility Navigator Name verified from Deal Name
    ...    AND    mx LoanIQ click    ${LIQ_FacilityNavigator_Add_Button}
    ...    AND    mx LoanIQ enter    ${LIQ_FacilitySelect_FacilityName_Text}    ${Facility_Name}
    ...    AND    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilitySelect_FacilityType_Combobox}    ${Facility_Type}
    ...    AND    Mx LoanIQ Select Combo Box Value      ${LIQ_FacilitySelect_Currency_List}    ${Facility_Currency}
    ...    AND    Validate Loan IQ Details    ${Facility_Name}    ${LIQ_FacilitySelect_FacilityName_Text}
    ...    AND    Validate Loan IQ Details    ${Facility_Type}    ${LIQ_FacilitySelect_FacilityType_Combobox}
    ...    AND    Validate Loan IQ Details    ${Facility_Currency}    ${LIQ_FacilitySelect_Currency_List}
    ...    AND    Take Screenshot    FacilitySelect_Window
    ...    AND    mx LoanIQ click    ${LIQ_FacilitySelect_OK_Button}

Set Specific Facility Dates
    [Documentation]    Sets the specific Agreement, Effective, Expiry & Final Maturity dates of a Facility.
    ...    Set to empty if a specific date field will not be populated 
    ...    
    ...    @author: ehugo
    [Arguments]    ${AgreementDate}    ${EffectiveDate}    ${ExpiryDate}    ${FinalMaturityDate}
    
    Run Keyword If    '${AgreementDate}'!='${EMPTY}'    mx LoanIQ enter    ${LIQ_FacilitySummary_AgreementDate_Datefield}    ${AgreementDate}
    Run Keyword If    '${AgreementDate}'!='${EMPTY}'    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${EffectiveDate}'!='${EMPTY}'    mx LoanIQ enter    ${LIQ_FacilitySummary_EffectiveDate_Datefield}    ${EffectiveDate}
    Run Keyword If    '${EffectiveDate}'!='${EMPTY}'    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${ExpiryDate}'!='${EMPTY}'    mx LoanIQ enter    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    ${ExpiryDate}
    Run Keyword If    '${ExpiryDate}'!='${EMPTY}'    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${FinalMaturityDate}'!='${EMPTY}'    mx LoanIQ enter    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}    ${FinalMaturityDate}
    Run Keyword If    '${FinalMaturityDate}'!='${EMPTY}'    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${AgreementDate}'!='${EMPTY}'    Validate Loan IQ Details    ${AgreementDate}    ${LIQ_FacilitySummary_AgreementDate_Datefield}
    Run Keyword If    '${EffectiveDate}'!='${EMPTY}'    Validate Loan IQ Details    ${EffectiveDate}    ${LIQ_FacilitySummary_EffectiveDate_Datefield}
    Run Keyword If    '${ExpiryDate}'!='${EMPTY}'    Validate Loan IQ Details    ${ExpiryDate}    ${LIQ_FacilitySummary_ExpiryDate_Datefield}
    Run Keyword If    '${FinalMaturityDate}'!='${EMPTY}'    Validate Loan IQ Details    ${FinalMaturityDate}    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}


Get Customer ID from Active Guarantor Via Facility Notebook
    [Documentation]    This keyword gets the Customer ID from the Customer Notebook through the Deal Notebook.
    ...    @author: amansuet    27SEP2019    - initial create
    [Arguments]    ${sGuarantorName}
    
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Guarantees
    mx LoanIQ click element if present    ${LIQ_FacilityChangeTransaction_InquiryMode_Button}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_GuaranteesTab_AddGuarantee_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorSelect_Window}
    mx LoanIQ enter    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorSelect_Textfield}    ${sGuarantorName}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorSelect_SearchButton}
    mx LoanIQ activate    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorListByShortName_Window}
    ${CustomerID}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorListByShortName_JavaTree}    ${sGuarantorName}%Customer ID%value
    Log    (Get Customer ID from Active Customer Notebook Via Deal Notebook) CustomerID = ${CustomerID}
    mx LoanIQ close window    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorListByShortName_Window}
    mx LoanIQ click    ${LIQ_FacilityChangeTransaction_GuaranteesTab_GuarantorSelect_CancelButton}
    [Return]    ${CustomerID}

Get Facility Effective Date
    [Documentation]    Gets the Facility Effective Date on Facility Notebook Summary Tab.
    ...    @author: hstone
    ...    @update: hstone    16JAN2020    Added Window Activate and Tab Selection routine.
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Summary
    ${sEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_EffectiveDate_Datefield}    text    
    [Return]    ${sEffectiveDate}
   
Close Facility Fee List Window
    [Documentation]    This keyword closes the Facility Ongoing Fee list window. 
    ...    @author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    mx LoanIQ close window    ${LIQ_Facility_FeeList}    

Rename Facility
    [Documentation]    This keyword is used to modify the Deal's current name.
    ...    @author: rtarayao    24SEP2019    - Initial Create 
    [Arguments]    ${sFacilityName}
    mx LoanIQ select    ${LIQ_FacilityNotebook_RenameFacility_Menu}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_RenameFacility_Window}  
    mx LoanIQ enter    ${LIQ_FacilityNotebook_RenameFacility_FacilityNewName_Textbox}    ${sFacilityName}
    mx LoanIQ click    ${LIQ_FacilityNotebook_RenameFacility_OK_Button}

Validate Facility Status
    [Documentation]    This keyword is used to validate Facility status is Active or Expired.
    ...    @author: amansuet    28OCT2019    - Initial Create
    ...    @update: clanding    09DEC2020    - added Run Keyword And Continue On Failure on Fail
    [Arguments]    ${sFacilityName}    ${sFacilityStatus}
    
    mx LoanIQ activate    ${LIQ_FacilityNavigator_Window}
    Take Screenshot    Facility_Status_FacilityNavigator
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_FacilityNavigator_Tree}    ${sFacilityName}\t${sFacilityStatus}
    Run Keyword If    '${status}'=='${True}'    Log    Facility Status of '${sFacilityName}' is '${sFacilityStatus}'.
    ...    ELSE IF    '${status}'=='${False}'    Run Keyword And Continue On Failure    Fail    Facility Status of '${sFacilityName}' is NOT '${sFacilityStatus}'.

Get Facility Type
    [Documentation]    Gets the Facility Type on Facility Notebook Summary Tab.
    ...    @author: hstone    16JAN2020    Initial Create
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Summary
    ${sFacilityType}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_FacilityType_Text}    text    
    [Return]    ${sFacilityType}
 
Get Facility Owning Branch
    [Documentation]    Gets the Facility Owning Branch on Facility Notebook Codes Tab.
    ...    @author: hstone    16JAN2020    Initial Create
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Codes
    ${sFacilityOwningBranch}    Mx LoanIQ Get Data    ${LIQ_FacilityCodes_OwningBranch_Text}    text    
    [Return]    ${sFacilityOwningBranch}

Get Facility Processing Area
    [Documentation]    Gets the Facility Processing Area on Facility Notebook Codes Tab.
    ...    @author: hstone    16JAN2020    Initial Create
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Codes
    ${sFacilityOwningBranch}    Mx LoanIQ Get Data    ${LIQ_FacilityCodes_ProcessingArea_Text}    text    
    [Return]    ${sFacilityOwningBranch}

Get Facility Event Effective Date
    [Documentation]    Gets the Facility Processing Area on Facility Notebook Codes Tab.
    ...    @author: hstone    16JAN2020    Initial Create
    [Arguments]    ${sEvent}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Events
    
    Select Java Tree Cell Value First Match    ${LIQ_FacilityEvents_JavaTree}    ${sEvent}    Event
    Take Screenshot    Facility_Events
    
    ${sEventEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_FacilityEvents_EffectiveDate_Text}    text  
    [Return]    ${sEventEffectiveDate}

Navigate to Modify Ongoing Fee Window
    [Documentation]    Navigates the user to Modify Ongoing Fee Window.
    ...    @author: fmamaril    10MAY2020    Initial Create   
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Go to Facility Notebook Update Mode
    [Documentation]    This keyword is used to go to Facility Notebook update mode.
    ...    @author: hstone     03JUN2020     - Initial Create
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNotebook_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    '${Status}'=='True'  mx LoanIQ select    ${LIQ_FacilityNotebook_Options_Update}

Navigate to Facility Interest Pricing Option Details
    [Documentation]    This keyword is used to Navigate to Facility Interest Pricing Option Details.
    ...    @author: hstone      03JUN2020     - Initial Create
    [Arguments]    ${sPricing_Option}

    ### Keyword Pre-processing ###
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}

    ### Facility Notebook Window ###
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing Rules
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_PricingRules
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricingRules_Option_Tree}    ${Pricing_Option}%d

Setup Facility All-In Rate Cap
    [Documentation]    This keyword is used to setup facility cap.
    ...    @author: hstone      03JUN2020     - Initial Create
    [Arguments]    ${sAll_In_Rate_Cap}    ${sRate_Change_Method}    ${sStart_Date}    ${sEnd_Date}

    ### Keyword Pre-processing ###
    ${All_In_Rate_Cap}    Acquire Argument Value    ${sAll_In_Rate_Cap}
    ${Rate_Change_Method}    Acquire Argument Value    ${sRate_Change_Method}
    ${Start_Date}    Acquire Argument Value    ${sStart_Date}
    ${End_Date}    Acquire Argument Value    ${sEnd_Date}

    ### Facility Interest Pricing Option Details Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityInterestPricingOptionDetails
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_Button}

    ### All-In Rate Cap History Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/All-InRateCapHistory
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_Insert_Button}

    ### All-In Rate Cap Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_AllInRateCap_Window}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_AllInRateCap_Rate_TextField}    ${All_In_Rate_Cap}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AllInRateCap_RateChangeMethod_List}    ${Rate_Change_Method}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_AllInRateCap_StartDate_TextField}    ${Start_Date}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_AllInRateCap_EndDate_TextField}    ${End_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/All-InRateCap
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateCap_OK_Button}

    ### All-In Rate Cap History Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/All-InRateCapHistory
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Facility_ValidationMessage_OK_Button}

    ### Facility Interest Pricing Option Details Window ###
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityInterestPricingOptionDetails

Setup Facility All-In Rate Floor
    [Documentation]    This keyword is used to setup facility floor.
    ...    @author: hstone      03JUN2020     - Initial Create
    [Arguments]    ${sAll_In_Rate_Floor}    ${sRate_Change_Method}    ${sStart_Date}    ${sEnd_Date}

    ### Keyword Pre-processing ###
    ${All_In_Rate_Floor}    Acquire Argument Value    ${sAll_In_Rate_Floor}
    ${Rate_Change_Method}    Acquire Argument Value    ${sRate_Change_Method}
    ${Start_Date}    Acquire Argument Value    ${sStart_Date}
    ${End_Date}    Acquire Argument Value    ${sEnd_Date}

    ### Facility Interest Pricing Option Details Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityInterestPricingOptionDetails
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_Button}

    ### All-In Rate Floor History Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/All-InRateFloorHistory
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_Insert_Button}

    ### All-In Rate Floor Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_AllInRateFloor_Window}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_AllInRateFloor_Rate_TextField}    ${All_In_Rate_Floor}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AllInRateFloor_RateChangeMethod_List}    ${Rate_Change_Method}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_AllInRateFloor_StartDate_TextField}    ${Start_Date}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_AllInRateFloor_EndDate_TextField}    ${End_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/All-InRateFloor
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateFloor_OK_Button}

    ### All-In Rate Floor History Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/All-InRateFloorHistory
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Facility_ValidationMessage_OK_Button}

    ### Facility Interest Pricing Option Details Window ###
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityInterestPricingOptionDetails

Validate Facility Cap Settings
    [Documentation]    This keyword is used to Validate Facility Cap Settings.
    ...    @author: hstone      03JUN2020     - Initial Create
    [Arguments]    ${sAll_In_Rate_Cap}    ${sRate_Change_Method}    ${sStart_Date}    ${sEnd_Date}    ${sPricing_Option}

    ### Keyword Pre-processing ###
    ${Expected_All_In_Rate_Cap}    Acquire Argument Value    ${sAll_In_Rate_Cap}
    ${Rate_Change_Method}    Acquire Argument Value    ${sRate_Change_Method}
    ${Expected_Start_Date}    Acquire Argument Value    ${sStart_Date}
    ${Expected_End_Date}    Acquire Argument Value    ${sEnd_Date}
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}

    ### Facility Interest Pricing Option Details Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityInterestPricingOptionDetails
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_Button}

    ### All-In Rate Cap History Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/All-InRateCapHistory

    ### Rate Change Method Reference Conditions ###
    ${Reference_Rate_Change_Method}    Run Keyword If    '${Rate_Change_Method}'=='Effective Date of Change'    Set Variable    EFFEC
    ...    ELSE IF    '${Rate_Change_Method}'=='Does Not Affect'    Set Variable    DNAFF
    ...    ELSE IF    '${Rate_Change_Method}'=='Next Repricing Date'    Set Variable    NEXTR
    ...    ELSE    Fail    Log    '${Rate_Change_Method}' is not registered as a valid Rate Change Method in the Script. Please add a condition if if necessary at 'Validate Facility Cap Settings' Keyword.

    ### Pricing Options Reference Conditions ###
    ${Reference_Pricing_Option}    Run Keyword If    '${sPricing_Option}'=='Fixed Rate Option'    Set Variable    FIXED Option
    ...    ELSE IF    Fail    Log    '${sPricing_Option}' is not registered as a valid Pricing Option in the Script. Please add a condition if if necessary at 'Validate Facility Cap Settings' Keyword.

    ### Acquire Actual UI Values ###
    ${Actual_Start_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_JavaTree}    ${Reference_Rate_Change_Method}%Start Date%Start_Date
    ${Actual_End_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_JavaTree}    ${Reference_Rate_Change_Method}%End Date%End_Date
    ${Actual_All_In_Rate_Cap}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_JavaTree}    ${Reference_Rate_Change_Method}%${Reference_Pricing_Option} All-In Rate Cap%All_In_Rate_Cap
    Log    ${Actual_Start_Date}
    Log    ${Actual_End_Date}
    Log    ${Actual_All_In_Rate_Cap}

    ### Expected Value Conversion ###
    ${Expected_All_In_Rate_Cap}    Convert Percentage to Decimal Value    ${Expected_All_In_Rate_Cap}

    ### Compare Actual UI Values to Expected Values ###
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_Start_Date}    ${Expected_Start_Date}
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_End_Date}    ${Expected_End_Date}
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_All_In_Rate_Cap}    ${Expected_All_In_Rate_Cap}

    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateCapHistory_Cancel_Button}

Validate Facility Floor Settings
    [Documentation]    This keyword is used to Validate Facility Floor Settings.
    ...    @author: hstone      03JUN2020     - Initial Create
    [Arguments]    ${sAll_In_Rate_Cap}    ${sRate_Change_Method}    ${sStart_Date}    ${sEnd_Date}    ${sPricing_Option}

    ### Keyword Pre-processing ###
    ${Expected_All_In_Rate_Cap}    Acquire Argument Value    ${sAll_In_Rate_Cap}
    ${Rate_Change_Method}    Acquire Argument Value    ${sRate_Change_Method}
    ${Expected_Start_Date}    Acquire Argument Value    ${sStart_Date}
    ${Expected_End_Date}    Acquire Argument Value    ${sEnd_Date}
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}

    ### Facility Interest Pricing Option Details Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityInterestPricingOptionDetails
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_Button}

    ### All-In Rate Floor History Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/All-InRateFloorHistory

    ### Rate Change Method Reference Conditions ###
    ${Reference_Rate_Change_Method}    Run Keyword If    '${Rate_Change_Method}'=='Effective Date of Change'    Set Variable    EFFEC
    ...    ELSE IF    '${Rate_Change_Method}'=='Does Not Affect'    Set Variable    DNAFF
    ...    ELSE IF    '${Rate_Change_Method}'=='Next Repricing Date'    Set Variable    NEXTR
    ...    ELSE    Fail    Log    '${Rate_Change_Method}' is not registered as a valid Rate Change Method in the Script. Please add a condition if if necessary at 'Validate Facility Floor Settings' Keyword.

    ### Pricing Options Reference Conditions ###
    ${Reference_Pricing_Option}    Run Keyword If    '${sPricing_Option}'=='Fixed Rate Option'    Set Variable    FIXED Option
    ...    ELSE IF    Fail    Log    '${sPricing_Option}' is not registered as a valid Pricing Option in the Script. Please add a condition if if necessary at 'Validate Facility Floor Settings' Keyword.

    ### Acquire Actual UI Values ###
    ${Actual_Start_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_JavaTree}    ${Reference_Rate_Change_Method}%Start Date%Start_Date
    ${Actual_End_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_JavaTree}    ${Reference_Rate_Change_Method}%End Date%End_Date
    ${Actual_All_In_Rate_Cap}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_JavaTree}    ${Reference_Rate_Change_Method}%${Reference_Pricing_Option} All-In Rate Floor%All_In_Rate_Cap
    Log    ${Actual_Start_Date}
    Log    ${Actual_End_Date}
    Log    ${Actual_All_In_Rate_Cap}

    ### Expected Value Conversion ###
    ${Expected_All_In_Rate_Cap}    Convert Percentage to Decimal Value    ${Expected_All_In_Rate_Cap}

    ### Compare Actual UI Values to Expected Values ###
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_Start_Date}    ${Expected_Start_Date}
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_End_Date}    ${Expected_End_Date}
    Run Keyword And Continue On Failure    Should Be Equal   ${Actual_All_In_Rate_Cap}    ${Expected_All_In_Rate_Cap}

    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AllInRateFloorHistory_Cancel_Button}

Confirm Facility Interest Pricing Options Settings
    [Documentation]    This keyword is used to Confirm Facility Cap and Floor Setup.
    ...    @author: hstone      03JUN2020     - Initial Create

    ### Facility Interest Pricing Option Details Window ###
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityInterestPricingOptionDetails
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OK_Button}

Modify Interest Pricing
    [Documentation]    This keyword modifies interest pricing on facility.
    ...    @author: hstone     09JUN2020      - Initial Create

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Pricing
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Add Interest Pricing
    [Documentation]    This keyword adds interest pricing on facility.
    ...    @author: hstone     09JUN2020      - Initial Create
    [Arguments]    ${sInterestPricingItem}    ${sInterestPricingType}

    ### Keyword Pre-processing ###
    ${InterestPricingItem}    Acquire Argument Value    ${sInterestPricingItem}
    ${InterestPricingType}    Acquire Argument Value    ${sInterestPricingType}

    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_Window}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_Add_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_AddItem_List}    VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${InterestPricingItem}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_Type_List}    VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_Type_List}    ${InterestPricingType}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing_AddItem
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}

Validate Interest Pricing Formula
    [Documentation]    This keyword validates interest pricing formula on a facility.
    ...    @author: hstone     09JUN2020      - Initial Create
    [Arguments]    ${sInterestPricingItem}    ${sInterestPricingType}    @{sFormulaValues}

    ### Keyword Pre-processing ###
    ${InterestPricingItem}    Acquire Argument Value    ${sInterestPricingItem}
    ${InterestPricingType}    Acquire Argument Value    ${sInterestPricingType}
    ${FormulaValues}    Acquire Argument Values From List    ${sFormulaValues}

    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing
    Extract Interest Pricing Formula    ${InterestPricingItem}    ${InterestPricingType}    NO    ${FormulaValues}
    ${InterestPricingFormula_NoEscapeSequence}    Remove String    ${FAC_INTPRICING_FORMULA}    \\
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Interest Pricing").JavaTree("developer name:=.*${FAC_INTPRICING_FORMULA}.*")    VerificationData="Yes"
    Run Keyword If    '${Status}'=='True'    Log    '${InterestPricingFormula_NoEscapeSequence}' exists at the Interest Pricing Table.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    '${InterestPricingFormula_NoEscapeSequence}' does not exist at the Interest Pricing Table.

Select Interest Pricing Formula
    [Documentation]    This keyword selects interest pricing formula on a facility.
    ...    @author: hstone     09JUN2020      - Initial Create
    [Arguments]    ${sInterestPricingItem}    ${sInterestPricingType}    @{sFormulaValues}

    ### Keyword Pre-processing ###
    ${InterestPricingItem}    Acquire Argument Value    ${sInterestPricingItem}
    ${InterestPricingType}    Acquire Argument Value    ${sInterestPricingType}
    ${FormulaValues}    Acquire Argument Values From List    ${sFormulaValues}

    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing
    Extract Interest Pricing Formula    ${InterestPricingItem}    ${InterestPricingType}    NO    ${FormulaValues}
    ${InterestPricingFormula_NoEscapeSequence}    Remove String    ${FAC_INTPRICING_FORMULA}    \\
    Mx LoanIQ Select Or DoubleClick In Javatree    JavaWindow("title:=.*Interest Pricing").JavaTree("developer name:=.*${FAC_INTPRICING_FORMULA}.*")    ${InterestPricingFormula_NoEscapeSequence}%s

Extract Interest Pricing Formula
    [Documentation]    This keyword extracts interest pricing formula.
    ...    @author: hstone     09JUN2020      - Initial Create
    [Arguments]    ${sInterestPricingItem}    ${sInterestPricingType}    ${sMarginApplied}    ${sFormulaValuesList}

    Set Global Variable    ${FAC_INTPRICING_FORMULA}

    ### External Rating Formula Extraction: Margin Not Applied ###
    Run Keyword If    '${sInterestPricingItem}'=='Matrix' and '${sInterestPricingType}'=='External Rating' and '${sMarginApplied}'=='NO'    Run Keywords    Set Global Variable    ${FAC_INTPRICING_FORMULA}    ${FAC_INTPRICING_FORMULA_EXTERNALRATING}
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {BORROWER}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_BORROWER}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {RATING_TYPE}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_TYPE}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {MIN_SIGN}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_MINSIGN}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {MIN_RATING}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_MINRATING}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {MAX_SIGN}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_MAXSIGN}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {MAX_RATING}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_MAXRATING}]
    ### External Rating Formula Extraction: Margin Applied ###
    ...    ELSE IF    '${sInterestPricingItem}'=='Matrix' and '${sInterestPricingType}'=='External Rating' and '${sMarginApplied}'=='YES'    Run Keywords    Set Global Variable    ${FAC_INTPRICING_FORMULA}    ${FAC_INTPRICING_FORMULA_EXTERNALRATING_MARGINAPPLIED}
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {BORROWER}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_BORROWER}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {RATING_TYPE}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_TYPE}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {MIN_SIGN}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_MINSIGN}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {MIN_RATING}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_MINRATING}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {MAX_SIGN}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_MAXSIGN}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {MAX_RATING}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_MAXRATING}]
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {EXTERNAL_RATING_EFFECTIVE_DATE}    @{sFormulaValuesList}[${FAC_INTPRICING_EXTRATING_EFFECTIVEDATE}]
    ### Fixed Rate Option - Percent Formula Extraction ###
    ...    ELSE IF    '${sInterestPricingItem}'=='Option' and '${sInterestPricingType}'=='Fixed Rate Option' and '@{sFormulaValuesList}[${FAC_INTPRICING_FIXRATEOPT_SPREADTYPE}]'=='Percent' and '${sMarginApplied}'=='NO'    Run Keywords    Set Global Variable    ${FAC_INTPRICING_FORMULA}    ${FAC_INTPRICING_FORMULA_FIXEDRATEOPTION_PERCENT}
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {SPREAD_VALUE}    @{sFormulaValuesList}[${FAC_INTPRICING_FIXRATEOPT_SPREADVALUE}]
    ### Fixed Rate Option - Basis Points Formula Extraction ###
    ...    ELSE IF    '${sInterestPricingItem}'=='Option' and '${sInterestPricingType}'=='Fixed Rate Option' and '@{sFormulaValuesList}[${FAC_INTPRICING_FIXRATEOPT_SPREADTYPE}]'=='Basis Points' and '${sMarginApplied}'=='NO'    Run Keywords    Set Global Variable    ${FAC_INTPRICING_FORMULA}    ${FAC_INTPRICING_FORMULA_FIXEDRATEOPTION_BASISPOINTS}
    ...    AND    Replace Variable on Global Interest Pricing Formula    ${FAC_INTPRICING_FORMULA}    {SPREAD_VALUE}    @{sFormulaValuesList}[${FAC_INTPRICING_FIXRATEOPT_SPREADVALUE}]
    ### Error Handling ###
    ...    ELSE    Fail    Interest Pricing Formula Condition does not exist. Please check test data or add a condition on 'Extract Interest Pricing Formula' keyword if necessary.

    Log    ${FAC_INTPRICING_FORMULA}

Replace Variable on Global Interest Pricing Formula
    [Documentation]    This keyword replaces the variable on the interest pricing formula.
    ...    @author: hstone     10JUN2020      - Initial Create
    [Arguments]    ${sInterestPricingFormula}    ${sInterestPricingFormulaVar}    ${sInterestPricingFormulaValue}

    ${InterestPricingFormulaValue}    Replace String    ${sInterestPricingFormulaValue}    +    \\+
    ${Result}    Replace String    ${sInterestPricingFormula}    ${sInterestPricingFormulaVar}    ${InterestPricingFormulaValue}
    Set Global Variable    ${FAC_INTPRICING_FORMULA}    ${Result}

Add After Interest Pricing
    [Documentation]    This keyword adds an after interest pricing on facility.
    ...    @author: hstone     09JUN2020      - Initial Create
    [Arguments]    ${sInterestPricingItem}    ${sInterestPricingType}

    ### Keyword Pre-processing ###
    ${InterestPricingItem}    Acquire Argument Value    ${sInterestPricingItem}
    ${InterestPricingType}    Acquire Argument Value    ${sInterestPricingType}

    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_Window}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_After_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_AddItem_List}    VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${InterestPricingItem}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_Type_List}    VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_Type_List}    ${InterestPricingType}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing_AddItem
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}

Set External Rating on Interest Pricing Modification
    [Documentation]    This keyword adds sets the external rating on interest pricing modification.
    ...    @author: hstone     09JUN2020      - Initial Create
    [Arguments]    ${sExternalRatingType}    ${sMinSign}    ${sMinRating}    ${sMaxSign}    ${sMaxRating}    ${sBorrower}=None

    ### Keyword Pre-processing ###
    ${ExternalRatingType}    Acquire Argument Value    ${sExternalRatingType}
    ${MinSign}    Acquire Argument Value    ${sMinSign}
    ${MinRating}    Acquire Argument Value    ${sMinRating}
    ${MaxSign}    Acquire Argument Value    ${sMaxSign}
    ${MaxRating}    Acquire Argument Value    ${sMaxRating}
    ${Borrower}    Acquire Argument Value    ${sBorrower}

    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_ExternalRating_Window}
    Validate if Element is Checked    ${LIQ_Facility_InterestPricing_ExternalRating_Borrower_RadioButton}    External Rating Window - Borrower Radio Button

    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_Type_List}    ${sExternalRatingType}

    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_MinRating_List}    ${MinRating}
    Run Keyword If    '${MinSign}'=='>='    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_GreaterThanOrEqual_RadioButton}    ON
    ...    ELSE IF    '${MinSign}'=='>'    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_GreaterThan_RadioButton}    ON
    ...    ELSE    Fail    (Set External Rating on Interest Pricing Modification) '${MinSign}' is not a valid Min Rating Symbol

    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_MaxRating_List}    ${MaxRating}
    Run Keyword If    '${MaxSign}'=='<'    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_LessThan_RadioButton}    ON
    ...    ELSE IF    '${MaxSign}'=='<='    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_LessThanOrEqual_RadioButton}    ON
    ...    ELSE    Fail    (Set External Rating on Interest Pricing Modification) '${MaxSign}' is not a valid Max Rating Symbol

    Run Keyword If    '${Borrower}'!='None'    Run Keywords    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_Borrower_RadioButton}    ON
    ...    AND    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_Customer_List}    ${Borrower}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing_ExternalRating
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_ExternalRating_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing

Set Interest Pricing Option Condition
    [Documentation]    This keyword sets the interest pricing option condition.
    ...    @author: hstone     09JUN2020      - Initial Create
    [Arguments]    ${sOptionName}    ${sRateBasis}

    ### Keyword Pre-processing ###
    ${OptionName}    Acquire Argument Value    ${sOptionName}
    ${RateBasis}    Acquire Argument Value    ${sRateBasis}

    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_OptionName_List}    ${OptionName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_RateBasis_List}    ${RateBasis}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing_OptionCondition
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OptionCondition_OK_Button}

Set Formula Category Values
    [Documentation]    This keyword sets the formula category values.
    ...    @author: hstone     09JUN2020      - Initial Create
    [Arguments]    ${sSpreadType}    ${sSpreadValue}

    ### Keyword Pre-processing ###
    ${SpreadType}    Acquire Argument Value    ${sSpreadType}
    ${SpreadValue}    Acquire Argument Value    ${sSpreadValue}

    Run Keyword If    '${SpreadType}'=='Percent'    mx LoanIQ enter    ${LIQ_FacilityPricing_FormulaCategory_Percent_Radiobutton}    ON
    ...    ELSE IF    '${SpreadType}'=='Basis Points'    mx LoanIQ enter    ${LIQ_FacilityPricing_FormulaCategory_BasisPoints_Radiobutton}    ON
    ...    ELSE    Fail    (Set Formula Category Values) '${SpreadType}' is not a valid Spread Type Value. Please add a condition on the keyword if necessary.

    mx LoanIQ enter    ${LIQ_FacilityPricing_FormulaCategory_Spread_Textfield}    ${SpreadValue}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing_FormulaCategory
    mx LoanIQ click    ${LIQ_FacilityPricing_FormulaCategory_OK_Button}
    mx LoanIQ click element if present    ${LIQ_PleaseConfirm_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing

Validate and Confirm Interest Pricing
    [Documentation]    This keyword clicks the 'Validate' button and verifies if added fees are complete.
    ...    @author: hstone     10JUN2020     - Initial Create
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_Validate_Button}
    mx LoanIQ activate    ${LIQ_Congratulations_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Congratulations_Window}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InterestPricing_Validation
    ${OngoingFee_ValidationPassed}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Congratulations_MessageBox}    value%Validation completed successfully.
    Run Keyword If    ${OngoingFee_ValidationPassed}==True    Run Keywords    Log    Ongoing Fee Validation Passed.
    ...    AND    mx LoanIQ click element if present    ${LIQ_Congratulations_OK_Button}
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InterestPricing_Validation
    ...    AND    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OK_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Navigate to Interest Pricing Zoom
    [Documentation]    This keyword navigates to interest pricing zoom on facility.
    ...    @author: hstone     10JUN2020      - Initial Create

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Pricing
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_InterestPricingZoom_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Validate Interest Pricing Zoom Matrix
    [Documentation]    This keyword validates the to interest pricing zoom details on a facility.
    ...    @author: hstone     10JUN2020      - Initial Create
    [Arguments]    ${sInterestPricingItem}    ${sInterestPricingType}    ${sMarginApplied}    @{sFormulaValues}

    ### Keyword Pre-processing ###
    ${InterestPricingItem}    Acquire Argument Value    ${sInterestPricingItem}
    ${InterestPricingType}    Acquire Argument Value    ${sInterestPricingType}
    ${MarginApplied}    Acquire Argument Value    ${sMarginApplied}
    ${FormulaValues}    Acquire Argument Values From List    ${sFormulaValues}

    ${MarginApplied}    Convert To Uppercase    ${MarginApplied}

    mx LoanIQ activate window     ${LIQ_Facility_InterestPricingZoom_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InterestPricingZoom
    Extract Interest Pricing Formula    ${InterestPricingItem}    ${InterestPricingType}    ${MarginApplied}    ${FormulaValues}
    ${InterestPricingFormula_NoEscapeSequence}    Remove String    ${FAC_INTPRICING_FORMULA}    \\
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Interest Pricing.*").JavaTree("developer name:=.*${FAC_INTPRICING_FORMULA}.*")    VerificationData="Yes"
    Run Keyword If    '${Status}'=='True'    Log    '${InterestPricingFormula_NoEscapeSequence}' exists at the Interest Pricing Table.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    '${InterestPricingFormula_NoEscapeSequence}' does not exist at the Interest Pricing Table.

Validate Interest Pricing Zoom Details
    [Documentation]    This keyword validates the to interest pricing zoom details on a facility.
    ...    @author: hstone     10JUN2020      - Initial Create
    [Arguments]    ${sInterestPricingItem}    ${sInterestPricingType}    @{sFormulaValues}

    ### Keyword Pre-processing ###
    ${InterestPricingItem}    Acquire Argument Value    ${sInterestPricingItem}
    ${InterestPricingType}    Acquire Argument Value    ${sInterestPricingType}
    ${FormulaValues}    Acquire Argument Values From List    ${sFormulaValues}

    mx LoanIQ activate window     ${LIQ_Facility_InterestPricingZoom_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InterestPricingZoom
    Extract Interest Pricing Formula    ${InterestPricingItem}    ${InterestPricingType}    NO    ${FormulaValues}
    ${InterestPricingFormula_NoEscapeSequence}    Remove String    ${FAC_INTPRICING_FORMULA}    \\
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Interest Pricing.*").JavaTree("developer name:=.*${FAC_INTPRICING_FORMULA}.*")    VerificationData="Yes"
    Run Keyword If    '${Status}'=='True'    Log    '${InterestPricingFormula_NoEscapeSequence}' exists at the Interest Pricing Table.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    '${InterestPricingFormula_NoEscapeSequence}' does not exist at the Interest Pricing Table.

Go to Modify Ongoing Fee
    [Documentation]    This keyword is used to click Mondify Ongoing Fee Button.
    ...    @author: clanding     04AUG2020      - Initial Create
    
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${PRICING_TAB}
    
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeInterestWindow_Warning
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_FacilityPricing_OngoingFeeInterest_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeInterestWindow

Click Modify Interest Pricing Button
    [Documentation]    This keyword is used to click Modify Interest Pricing button in Facility Pricing window.
    ...    @author: clanding    04AUG2020    - initial create

    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeInterestWindow

Get Effective and Expiry Date from Summary Tab in Facility Notebook
    [Documentation]    This keyword is used to get Effective and Expiry Date from Fcility Notebook > Summary tab.
    ...    @author: clanding    04AUG2020    - initial create
    [Arguments]    ${sRunTimeVar_EffectiveDate}=None    ${sRunTimeVar_ExpiryDate}=None

    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${SUMMARY_TAB}
    ${EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_EffectiveDate_Datefield}    value%date
    ${ExpiryDate}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    value%date
    
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_EffectiveDate}    ${EffectiveDate}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ExpiryDate}    ${ExpiryDate}
    [Return]    ${EffectiveDate}    ${ExpiryDate}

Retrieve Facility Notebook Amounts prior to Loan Merge
    [Documentation]    This keyword is used to get Facility Notebook Amounts for Loan Merge
    ...    @author: dahijara    28SEP2020    - initial create
    [Arguments]    ${sRunVar_GlobalFacility_ProposedCmtBeforeMerge}=None    ${sRunVar_GlobalFacility_CurrentCmtBeforeMerge}=None    ${sRunVar_GlobalFacility_OutstandingsBeforeMerge}=None
    ...    ${sRunVar_GlobalFacility_AvailToDrawBeforeMerge}=None    ${sRunVar_HostBank_ProposedCmtBeforeMerge}=None    ${sRunVar_HostBank_ContrGrossBeforeMerge}=None
    ...    ${sRunVar_HostBank_OutstandingsBeforeMerge}=None    ${sRunVar_HostBank_AvailToDrawBeforeMerge}=None

    ${GlobalFacility_ProposedCmtBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ProposedCmt_Textfield}    input=GlobalFacility_ProposedCmtBeforeMerge        
    ${GlobalFacility_CurrentCmtBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    input=GlobalFacility_CurrentCmtBeforeMerge        
    ${GlobalFacility_OutstandingsBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    input=GlobalFacility_OutstandingsBeforeMerge        
    ${GlobalFacility_AvailToDrawBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    input=GlobalFacility_AvailToDrawBeforeMerge 
    
    ${HostBank_ProposedCmtBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankProposeCmt}    input=HostBank_ProposedCmtBeforeMerge        
    ${HostBank_ContrGrossBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankContrGross}    input=HostBank_ContrGrossBeforeMerge        
    ${HostBank_OutstandingsBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankOutstanding}    input=HostBank_OutstandingsBeforeMerge        
    ${HostBank_AvailToDrawBeforeMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBankAvailToDraw}    input=HostBank_AvailToDrawBeforeMerge 
	
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_FacilityAmounts

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_GlobalFacility_ProposedCmtBeforeMerge}    ${GlobalFacility_ProposedCmtBeforeMerge}
    Save Values of Runtime Execution on Excel File    ${sRunVar_GlobalFacility_CurrentCmtBeforeMerge}    ${GlobalFacility_CurrentCmtBeforeMerge}
    Save Values of Runtime Execution on Excel File    ${sRunVar_GlobalFacility_OutstandingsBeforeMerge}    ${GlobalFacility_OutstandingsBeforeMerge}
    Save Values of Runtime Execution on Excel File    ${sRunVar_GlobalFacility_AvailToDrawBeforeMerge}    ${GlobalFacility_AvailToDrawBeforeMerge}
    Save Values of Runtime Execution on Excel File    ${sRunVar_HostBank_ProposedCmtBeforeMerge}    ${HostBank_ProposedCmtBeforeMerge}
    Save Values of Runtime Execution on Excel File    ${sRunVar_HostBank_ContrGrossBeforeMerge}    ${HostBank_ContrGrossBeforeMerge}
    Save Values of Runtime Execution on Excel File    ${sRunVar_HostBank_OutstandingsBeforeMerge}    ${HostBank_OutstandingsBeforeMerge}
    Save Values of Runtime Execution on Excel File    ${sRunVar_HostBank_AvailToDrawBeforeMerge}    ${HostBank_AvailToDrawBeforeMerge}

    [Return]    ${GlobalFacility_ProposedCmtBeforeMerge}    ${GlobalFacility_CurrentCmtBeforeMerge}    ${GlobalFacility_OutstandingsBeforeMerge}    ${GlobalFacility_AvailToDrawBeforeMerge}
    ...    ${HostBank_ProposedCmtBeforeMerge}    ${HostBank_ContrGrossBeforeMerge}    ${HostBank_OutstandingsBeforeMerge}    ${HostBank_AvailToDrawBeforeMerge}

Close Option Condition Window
    [Documentation]    This keyword is used to close Option Condition dialog window.
    ...    @author: clanding    09NOV2020    - initial create
    
    ${IsDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_Interest_OptionCondition_Cancel_Button}    VerificationData="Yes"
    Run Keyword If    ${IsDisplayed}==${True}    mx LoanIQ click    ${LIQ_FacilityPricing_Interest_OptionCondition_Cancel_Button}
    ...    ELSE    Log    No Option Condition window is displayed.

Update Branch and Processing Area of a Facility
    [Documentation]    This keyword updates Branch and Processing Area in Facility Notebook.
    ...    @author: mcastro    11NOV2020    - initial create
    [Arguments]    ${sBranchName}    ${sProcessingArea}

    ### Keyword Pre-processing ###
    ${BranchName}    Acquire Argument Value    ${sBranchName}
    ${ProcessingArea}    Acquire Argument Value    ${sProcessingArea}

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}    
    mx LoanIQ select   ${LIQ_FacilityNotebook_Options_ChangeBranch_ProcArea}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window     ${LIQ_ChangeBranchProcArea_Window}
    Mx LoanIQ select combo box value    ${LIQ_ChangeBranchProcArea_Branch_Combobox}    ${BranchName}
    Mx LoanIQ select combo box value    ${LIQ_ChangeBranchProcArea_ProcessingArea_Combobox}    ${ProcessingArea}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ChangeBranchProcArea_Window
    mx LoanIQ click    ${LIQ_ChangeBranchProcArea_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ChangeBranchProcArea_Window

Add Item to Facility Ongoing Fee
    [Documentation]    Adds an Item to an Ongoing Fee in the Facility Notebook
    ...    @author: mcastro    03DEC2020    - Initial Create
    [Arguments]    ${sOngoingFee_Type}    ${sOngoingFee_Item}    ${sOngoingFee_Item_Type}
    
    ### Keyword Pre-processing ###
    ${OngoingFee_Type}    Acquire Argument Value    ${sOngoingFee_Type}
    ${OngoingFee_Item}    Acquire Argument Value    ${sOngoingFee_Item}
    ${OngoingFee_Item_Type}    Acquire Argument Value    ${sOngoingFee_Item_Type}

    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricing_OngoingFeeInterest_Tree}    ${OngoingFee_Type}%s
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_Add_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    ${OngoingFee_Item}
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    ${OngoingFee_Item_Type}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_FacilityPricing
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_FacilityPricing
    
Add Details in Comments Tab in Facility Notebook
    [Documentation]    This keyword is used to add details in the Comments tab of a Facility.
    ...    @author: clanding    24NOV2020    - initial create
    [Arguments]    ${sSubject}    ${sComment}
    
    ### Keyword Pre-processing ###
    ${Subject}    Acquire Argument Value    ${sSubject}
    ${Comment}    Acquire Argument Value    ${sComment}

    ### Input Comment ###
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    Comments
    mx LoanIQ click    ${LIQ_FacilityNotebook_CommentsTab_Add_Button}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_CommentEdit_Window}
    mx LoanIQ enter    ${LIQ_FacilityNotebook_CommentEdit_Subject_Textbox}    ${Subject}
    mx LoanIQ enter    ${LIQ_FacilityNotebook_CommentEdit_Comment_Textbox}    ${Comment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommentsEdit_Window
    mx LoanIQ click    ${LIQ_FacilityNotebook_CommentEdit_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommentsEdit_Window
    
    ### Validate Comment if added ###
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_FacilityNotebook_CommentsTab_JavaTree}    ${Subject}
    Run Keyword If    ${IsSelected}==${True}    Log    ${Subject} is successfully added in the Comments tab.
    ...    ELSE     Run Keyword And Continue On Failure    FAIL    ${Subject} is NOT successfully added in the Comments tab.

    ### Get Author and Date ###
    ${Comment_Author}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityNotebook_CommentsTab_JavaTree}    ${Subject}%Author%Comment_Author
    ${Comment_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FacilityNotebook_CommentsTab_JavaTree}    ${Subject}%Date%Comment_Date
    
    [Return]    ${Comment_Author}    ${Comment_Date}

Add Alerts in Facility Notebook
    [Documentation]    This keyword is used to add Alerts details in Facility Notebook.
    ...    @author: clanding    24NOV2020    - initial create
    [Arguments]    ${sDealName}    ${sFacilityName}    ${sShortDescription}    ${sDetail}
    
    ### Keyword Pre-processing ###
    ${DealName}    Acquire Argument Value    ${sDealName}
    ${FacilityName}    Acquire Argument Value    ${sFacilityName}
    ${ShortDescription}    Acquire Argument Value    ${sShortDescription}
    ${Detail}    Acquire Argument Value    ${sDetail}
    
    ${Current_Local_Date}    Get Current Date    result_format=%d-%b-%Y %H:%M:%S
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    Options    Alerts
    ${IsExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Question_Yes_Button}
    Run Keyword If    ${IsExist}==${True}    mx LoanIQ click    ${LIQ_Question_Yes_Button}
    ...    ELSE    Run Keywords    mx LoanIQ activate window    ${LIQ_FacilityNotebook_AlertManagementScreen_Window}
    ...    AND    mx LoanIQ click    ${LIQ_FacilityNotebook_AlertManagementScreen_Create_Button}
    ...    AND    mx LoanIQ enter    ${LIQ_FacilityNotebook_AlertManagementScreen_ChooseAnEntity_Facility_RadioButton}    ON
    ...    AND    mx LoanIQ click    ${LIQ_FacilityNotebook_AlertManagementScreen_ChooseAnEntity_OK_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_FacilityNotebook_AlertManagementScreen_FacilitySelect_Window}
    ...    AND    mx LoanIQ enter    ${LIQ_FacilityNotebook_AlertManagementScreen_FacilitySelect_Deal_Textbox}    ${DealName}
    ...    AND    mx LoanIQ enter    ${LIQ_FacilityNotebook_AlertManagementScreen_FacilitySelect_IdentifyByValue_Textbox}    ${FacilityName}
    ...    AND    mx LoanIQ click    ${LIQ_FacilityNotebook_AlertManagementScreen_FacilitySelect_Search_Button}
    ...    AND    mx LoanIQ click    ${LIQ_FacilityNotebook_AlertManagementScreen_FacilityListByName_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_AlertManagementScreen_AlertEditor_Window}
    mx LoanIQ enter    ${LIQ_FacilityNotebook_AlertManagementScreen_AlertEditor_ShortDescription_Textbox}    ${ShortDescription}
    ${Current_Local_Date}    Get Current Date    result_format=%d-%b-%Y %H:%M:%S
    mx LoanIQ enter    ${LIQ_FacilityNotebook_AlertManagementScreen_AlertEditor_Details_Textbox}    ${Detail}${SPACE}${Current_Local_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AlertEditor_Window
    mx LoanIQ click    ${LIQ_FacilityNotebook_AlertManagementScreen_AlertEditor_OK_Button}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_AlertManagementScreen_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AlertManagementScreen_Window

    mx LoanIQ close window    ${LIQ_FacilityNotebook_AlertManagementScreen_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CloseAlertManagementScreen_Window
    [Return]    ${Detail}${SPACE}${Current_Local_Date}    ${Current_Local_Date}

New Facility Select for Pending Status
    [Documentation]    This keyword creates a new facility.
    ...    @author: clanding    09DEC2020    - initial create
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}    ${sFacility_Type}    ${sFacility_Currency}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Type}    Acquire Argument Value    ${sFacility_Type}
    ${Facility_Currency}    Acquire Argument Value    ${sFacility_Currency}
    
    ### Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}    ${ARG_TYPE_UNIQUE_NAME_VALUE}

    mx LoanIQ activate window     ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}    
    mx LoanIQ select   ${LIQ_DealNotebook_Options_Facilities}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}      
    mx LoanIQ click    ${LIQ_FacilityNavigator_Add_Button}
    Validation on Facility Add
    mx LoanIQ enter    ${LIQ_FacilitySelect_New_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_FacilitySelect_DealName_Textfield}    ${Deal_Name}
    mx LoanIQ enter    ${LIQ_FacilitySelect_FacilityName_Text}    ${Facility_Name}
    mx LoanIQ click    ${LIQ_FacilitySelect_FacilityType_Button}
    mx LoanIQ enter    ${LIQ_FacilityTypeSelect_SearchByDescription_Textfield}    ${Facility_Type}
    mx LoanIQ click    ${LIQ_FacilityTypeSelect_OK_Button}    
    Mx LoanIQ select combo box value    ${LIQ_FacilitySelect_Currency_List}    ${Facility_Currency}
    mx LoanIQ click    ${LIQ_FacilitySelect_OK_Button} 
    :FOR    ${i}    IN RANGE    2
    \    Sleep    10
    \    ${LIQ_FacilityNoebook_WindowExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNotebook_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${LIQ_FacilityNoebook_WindowExist}==True    
    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Facility -    ${Facility_Type}
    Run Keyword And Continue On Failure    Verify If Text Value Exist as Static Text on Page    Facility -    ${Facility_Type}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_Window

Get Outstandings Amount from Facility Notebook
    [Documentation]    This keyword returns the Facility Host Bank Share Gross Amounts Outstandings Amount.
    ...    @author: ccarriedo    09DEC2020    Initial Create

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    ${Facility_Outstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_Outstandings}    value%Amount
    ${Facility_Outstandings_Amount}    Remove Comma and Convert to Number    ${Facility_Outstandings} 
    Log    The Facility ost Bank Share Gross Amounts Outstandings Amount is ${Facility_Outstandings_Amount} 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Outstandings Amount
    Take Screenshot    ${SCREENSHOT_FILENAME}
    
    [Return]    ${Facility_Outstandings_Amount}

Add Ongoing Fee using Matrix and Outside Condition
    [Documentation]    This keyword adds ongoing fee
    ...    @author: kmagday    10DEC2020    - initial create
    [Arguments]    ${sFacilityItemAfter}    ${sFacilityItem}    ${sOutsideCondition_RadioButton}=OFF  

    ### Keyword Pre-processing ###
    ${FacilityItemAfter}    Acquire Argument Value    ${sFacilityItemAfter}
    ${FacilityItem}    Acquire Argument Value    ${sFacilityItem}
    ${OutsideCondition_RadioButton}    Acquire Argument Value    ${sOutsideCondition_RadioButton}

    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_After_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${FacilityItemAfter}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_Type_List}    ${FacilityItem}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_Cancel_Button}       VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}

    Run Keyword If    '${OutsideCondition_RadioButton}'=='ON'    mx LoanIQ click    ${LIQ_OutsideConditions_Matrix_RadioButton_True}
    ...    ELSE    mx LoanIQ click    ${LIQ_OutsideConditions_Matrix_RadioButton_False}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
    mx LoanIQ click    ${LIQ_Edit_OutsideConditions_OK_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing

Insert After Ongoing Fee using Matrix and Outside Condition 
    [Documentation]    This keyword adds ongoing fee - after on facility.
    ...    @author: kmagday    10DEC2020    - initial create
    [Arguments]    ${sFacilityItemAfter}    ${sFacilityItem}    ${sOutsideCondition_RadioButton}=OFF  

    ### Keyword Pre-processing ###
    ${FacilityItemAfter}    Acquire Argument Value    ${sFacilityItemAfter}
    ${FacilityItem}    Acquire Argument Value    ${sFacilityItem}
    ${OutsideCondition_RadioButton}    Acquire Argument Value    ${sOutsideCondition_RadioButton}

    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_Add_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${FacilityItemAfter}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_Type_List}    ${FacilityItem}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_Cancel_Button}       VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}

    Run Keyword If    '${OutsideCondition_RadioButton}'=='ON'    mx LoanIQ click    ${LIQ_OutsideConditions_Matrix_RadioButton_True}
    ...    ELSE    mx LoanIQ click    ${LIQ_OutsideConditions_Matrix_RadioButton_False}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
    mx LoanIQ click    ${LIQ_Edit_OutsideConditions_OK_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing

Insert After Ongoing Fee Pricing using Outside Condition
    [Documentation]    This keyword adds ongoing fee - after on facility.
    ...    @author: kmagday    10DEC2020    - initial create
    [Arguments]    ${sFacilityItemAfter}    ${iFacility_PercentWhole}    ${sFacilityItem}    ${iFacility_Percent}  

    ### Keyword Pre-processing ###
    ${FacilityItemAfter}    Acquire Argument Value    ${sFacilityItemAfter}
    ${Facility_PercentWhole}    Acquire Argument Value    ${iFacility_PercentWhole}
    ${FacilityItem}    Acquire Argument Value    ${sFacilityItem}
    ${Facility_Percent}    Acquire Argument Value    ${iFacility_Percent}

    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_After_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${FacilityItemAfter}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_Cancel_Button}       VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}
    mx LoanIQ enter    ${LIQ_FacilityPricing_FormulaCategory_Percent_Radiobutton}    ON
    mx LoanIQ activate window    ${LIQ_FormulaCategory_Window}
    mx LoanIQ enter    ${LIQ_FacilityPricing_FormulaCategory_Percent_Textfield}    ${Facility_Percent}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_FormulaCategory_OK_Button}
    mx LoanIQ activate window    ${LIQ_Warning_Window}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Ongoing Fee Pricing.*").JavaTree("developer name:=.*${Facility_PercentWhole}.*")    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing

Select Text in Ongoing Fee Pricing List 
    [Documentation]    This keyword selects/clicks a value from the ongoing pricing list java tree
    ...    @author: kmagday    10DEC2020    - initial create
    [Arguments]    ${sText}

    ### Keyword Pre-processing ###
    ${Text}    Acquire Argument Value    ${sText}

    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_FacilityPricing_OngoingFeeInterest_Tree}    ${Text}%s

Add After Item to Existing Selection For Facility Pricing
    [Documentation]    Adds an After Item to an Existing Selection For Facility Pricing Notebook.
    ...    @author: dahijara    09DEC2020    - Initial create
    [Arguments]    ${sOngoingFee_AfterItem}    ${sOngoingFee_AfterItem_Type}

    ### Keyword Pre-processing ###
    ${OngoingFee_AfterItem}    Acquire Argument Value    ${sOngoingFee_AfterItem}
    ${OngoingFee_AfterItem_Type}    Acquire Argument Value    ${sOngoingFee_AfterItem_Type}

    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_After_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    ${OngoingFee_AfterItem}
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    ${OngoingFee_AfterItem_Type}
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityPricing_Window

Add Facility Matrix to Ongoing Fee or Interest Pricing with Existing Matrix For Facility Pricing
    [Documentation]    Adds Ongoing Fee Matrix on the Facility Notebook's Ongoing Fee Pricing window.
    ...    @author: dahijara    09DEC2020    - Initial Create
    [Arguments]    ${sOngoingFee_MatrixType}    ${sOngoingFee_Item}    ${sOngoingFee_Item_Type}

    ### Keyword Pre-processing ###
    ${OngoingFee_MatrixType}    Acquire Argument Value    ${sOngoingFee_MatrixType}
    ${OngoingFee_Item}    Acquire Argument Value    ${sOngoingFee_Item}
    ${OngoingFee_Item_Type}    Acquire Argument Value    ${sOngoingFee_Item_Type}

    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricing_OngoingFeeInterest_Tree}    ${sOngoingFee_MatrixType}%s
    Add Item to Ongoing Fee or Interest Pricing For Facility Pricing    ${OngoingFee_Item}    ${OngoingFee_Item_Type}

Add Item to Ongoing Fee or Interest Pricing For Facility Pricing
    [Documentation]    Adds an Item to an Existing Selection For Facility Pricing Notebook.
    ...    @author: dahijara    09DEC2020    - Initial create
    [Arguments]    ${sOngoingFee_AfterItem}    ${sOngoingFee_AfterItem_Type}

    ### Keyword Pre-processing ###
    ${OngoingFee_AfterItem}    Acquire Argument Value    ${sOngoingFee_AfterItem}
    ${OngoingFee_AfterItem_Type}    Acquire Argument Value    ${sOngoingFee_AfterItem_Type}

    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_Add_Button}
    Mx LoanIQ Optional Select    ${LIQ_AddItem_List}    ${OngoingFee_AfterItem}
    Mx LoanIQ Optional Select    ${LIQ_AddItemType_List}    ${OngoingFee_AfterItem_Type}
    mx LoanIQ click    ${LIQ_AddItem_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityPricing_OngoingFeeInterest_Window

Navigate to Facitily Interest Pricing Window
    [Documentation]    This keyword adds interest pricing on facility.
    ...    @author: dahijara    09DEC2020    - Initial create

    mx LoanIQ activate window     ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab     ${LIQ_FacilityNotebook_Tab}    ${PRICING_TAB}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityPricing_Tab
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityPricing_Window

Set Outside Condition to Facility Ongoing Fee
    [Documentation]    This keyword is used to set an Outside condition for Commitment Fee
    ...    @author: javinzon    11DEC2020    - Initial create
    [Arguments]    ${sOutsideCondition_Type}    ${sOutsideCondition_RadioButton}=OFF
    
    ### Keyword Pre-processing ###
    ${OutsideCondition_Type}    Acquire Argument Value    ${sOutsideCondition_Type}
    ${OutsideCondition_RadioButton}    Acquire Argument Value    ${sOutsideCondition_RadioButton}
    
    mx LoanIQ select    ${LIQ_FacilityPricing_OngoingFeeInterest_OutsideCondition_Type_Dropdown}    ${OutsideCondition_Type}
    Run Keyword If    '${OutsideCondition_RadioButton}'=='ON'    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_OutsideCondition_True_RadioButton}
    ...    ELSE    mxLoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_OutsideCondition_False_RadioButton}
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFeeInterest_OutsideCondition_OK_Button}

Verify Facility Pricing Option Details
    [Documentation]    This keyword verifies fields in facility Pricing Option.
    ...    Note: currently, keyword only verifies Matrix Change Application Method field. Add Optional fields as necessary.
    ...    @author: dahijara    11DEC2020    Initial create
    [Arguments]    ${sPricingOption}    ${sMatrixChangeAppMethod}

    ### Keyword Pre-processing ###
    ${PricingOption}    Acquire Argument Value    ${sPricingOption}
    ${MatrixChangeAppMethod}    Acquire Argument Value    ${sMatrixChangeAppMethod}

	Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    ${PRICING_RULES_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricing_AllowedPricingOption_JavaTree}    ${PricingOption}%d
    Mx LoanIQ activate window    ${LIQ_InterestPricingOption_Window}

    ${UI_MatrixChangeAppMethod}    Mx LoanIQ Get Data    ${LIQ_FacilityPricing_PricingOption_MatrixChangeAppMthd_Combobox}    text
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingOption_InterestPricingOption

    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${UI_MatrixChangeAppMethod}    ${MatrixChangeAppMethod}
    Run Keyword If    ${isMatched}==${TRUE}    Log    Matrix Change Application Method is correct. Value: ${UI_MatrixChangeAppMethod}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Matrix Change Application Method is NOT correct. Value: ${UI_MatrixChangeAppMethod}

    Mx LoanIQ click    ${LIQ_InterestPricingOption_Cancel_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_PricingRulesTab_PricingOption

