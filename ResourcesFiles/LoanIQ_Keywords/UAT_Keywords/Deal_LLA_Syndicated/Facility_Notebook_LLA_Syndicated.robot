*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Revolver Facility for LLA Syndicated Deal
    [Documentation]    This high-level keyword is used to create an initial set up of Revolver Facility for LLA Syndicated Deal
    ...    @author: makcamps    04JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ###Test Data Generation and Writings###
	${FacilityName}    Generate Facility Name with 5 Numeric Test Data    &{ExcelPath}[Facility_NamePrefix]
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${FacilityName}
	Set To Dictionary    ${ExcelPath}    Facility_Name=${FacilityName}
	
	###Add Revolver Facility###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Facility_Name]
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Date Settings##
    ${SystemDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${SystemDate}    &{ExcelPath}[Add_To_Facility_ExpiryDate]
    ${Facility_MaturityDate}    Add Days to Date    ${SystemDate}    &{ExcelPath}[Add_To_Facility_MaturityDate]  
    Set Facility Dates    ${SystemDate}    ${SystemDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate} 
	Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
	Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    ${rowid}    ${SystemDate}  
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${SystemDate}     
    
    ###Facility Notebook - Types/Purpose###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType]
    
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ###Facility Notebook - Restrictions###
    Add Facility Currency    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Sublimit/Cust###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${SystemDate} 
    
    ###Facility Notebook - Summary###
    Validate Multi CCY Facility

Setup Pricing for LLA Syndicated Deal
    [Documentation]    This keyword is used to set up Pricing for LLA Syndicated Deal.
    ...    @author: makcamps    05JAN2021    - Initial create
    [Arguments]    ${ExcelPath}
    
    ### Facility Notebook - Pricing Tab ###
    Set Facility Pricing Penalty Spread    &{ExcelPath}[Penalty_Spread]    &{ExcelPath}[Penalty_Status]
    
    ### Modify Ongoing Fees ###
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition1]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType1]
    ...    &{ExcelPath}[MaxType1]    &{ExcelPath}[MinValue1]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType2]
    ...    &{ExcelPath}[MaxType2]    &{ExcelPath}[MinValue1]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType1]
    ...    &{ExcelPath}[MaxType1]    &{ExcelPath}[MinValue1]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType6]
    ...    &{ExcelPath}[MaxType3]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType4]
    ...    &{ExcelPath}[MaxType4]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType2]
    ...    &{ExcelPath}[MaxType2]    &{ExcelPath}[MinValue1]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert After for LLA    &{ExcelPath}[FacilityItemAfter]    &{ExcelPath}[Facility_Percent1]   
    Mx Press Combination    KEY.UP
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition2]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType4]
    ...    &{ExcelPath}[MaxType5]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType6]
    ...    &{ExcelPath}[MaxType6]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType4]
    ...    &{ExcelPath}[MaxType5]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType6]
    ...    &{ExcelPath}[MaxType3]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType4]
    ...    &{ExcelPath}[MaxType4]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType6]
    ...    &{ExcelPath}[MaxType6]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert After for LLA    &{ExcelPath}[FacilityItemAfter]    &{ExcelPath}[Facility_Percent2]       
    Mx Press Combination    KEY.UP
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition2]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType3]
    ...    &{ExcelPath}[MaxType4]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType5]
    ...    &{ExcelPath}[MaxType3]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert After for LLA    &{ExcelPath}[FacilityItemAfter]    &{ExcelPath}[Facility_Percent3]
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*&{ExcelPath}[Facility_PercentWhole1].*")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*&{ExcelPath}[Facility_PercentWhole2].*")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*&{ExcelPath}[Facility_PercentWhole3].*")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*&{ExcelPath}[FacilityItem].*")    VerificationData="Yes"
    
    ### Modify Interest Pricing ###
    Navigate to Facility Notebook - Modify Interest Pricing
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition2]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType1]
    ...    &{ExcelPath}[MaxType1]    &{ExcelPath}[MinValue1]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType2]
    ...    &{ExcelPath}[MaxType2]    &{ExcelPath}[MinValue1]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType1]
    ...    &{ExcelPath}[MaxType1]    &{ExcelPath}[MinValue1]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType6]
    ...    &{ExcelPath}[MaxType3]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType4]
    ...    &{ExcelPath}[MaxType4]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType2]
    ...    &{ExcelPath}[MaxType2]    &{ExcelPath}[MinValue1]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert After for LLA    &{ExcelPath}[InterestPricingItem]    &{ExcelPath}[OptionName]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[FormulaText]    &{ExcelPath}[Spread1]
    Mx Press Combination    KEY.UP
    Mx Press Combination    KEY.UP
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition2]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType4]
    ...    &{ExcelPath}[MaxType5]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType6]
    ...    &{ExcelPath}[MaxType6]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType4]
    ...    &{ExcelPath}[MaxType5]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType6]
    ...    &{ExcelPath}[MaxType3]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition4]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType4]
    ...    &{ExcelPath}[MaxType4]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType6]
    ...    &{ExcelPath}[MaxType6]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]    
    Modify Interest Pricing - Insert After for LLA    &{ExcelPath}[InterestPricingItem]    &{ExcelPath}[OptionName]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[FormulaText]    &{ExcelPath}[Spread2]
    Mx Press Combination    KEY.UP
    Mx Press Combination    KEY.UP
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition2]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType3]
    ...    &{ExcelPath}[MaxType4]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType5]
    ...    &{ExcelPath}[MaxType3]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]    
    Modify Interest Pricing - Insert After for LLA    &{ExcelPath}[InterestPricingItem]    &{ExcelPath}[OptionName]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[FormulaText]    &{ExcelPath}[Spread3]
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Facility -.*").JavaTree("developer name:=.*&{ExcelPath}[Code].*")     VerificationData="Yes"
    
Modify Ongoing Fee Pricing - Insert Matrix of External Rating
    [Documentation]    This keyword adds ongoing fee on facility for Matrix of External Rating.
    ...    @author: makcamps    05JAN2021    - Initial Create
    [Arguments]    ${sCondition}    ${sExtRatingType}    ${sExtRatingMinValue}    ${sExtRatingMaxValue}    ${sExtRatingMin}=>=    ${sExtRatingMax}=<
    
    ### Keyword Pre-processing ###
    ${Condition}    Acquire Argument Value    ${sCondition}
    ${ExternalRatingType}    Acquire Argument Value    ${sExtRatingType}
    ${ExternalRatingMin}    Acquire Argument Value    ${sExtRatingMin}
    ${ExternalRatingMinValue}    Acquire Argument Value    ${sExtRatingMinValue}
    ${ExternalRatingMax}    Acquire Argument Value    ${sExtRatingMax}
    ${ExternalRatingMaxValue}    Acquire Argument Value    ${sExtRatingMaxValue}
    
    Run Keyword If    '${Condition}'=='After'    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_After_Button}
    ...    ELSE IF    '${Condition}'=='Add'    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_Add_Button}
    ...    ELSE IF    '${Condition}'=='And'    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_And_Button}
    ...    ELSE IF    '${Condition}'=='Or'    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_Or_Button}
    ...    ELSE    Fail    '${Condition}' is not a valid condition

    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    Matrix
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_Type_List}    External Rating
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_OngoingFees_AddItem_Cancel_Button}       VerificationData="Yes"
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_AddItem_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_Pricing
    
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_ExternalRating_Window}
    Validate if Element is Checked    ${LIQ_Facility_InterestPricing_ExternalRating_Borrower_RadioButton}    External Rating Window - Borrower Radio Button
    
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_Type_List}    ${ExternalRatingType}

    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_MinRating_List}    ${ExternalRatingMinValue}
    Run Keyword If    '${ExternalRatingMin}'=='>='    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_GreaterThanOrEqual_RadioButton}    ON
    ...    ELSE IF    '${ExternalRatingMin}'=='>'    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_GreaterThan_RadioButton}    ON
    ...    ELSE    Fail    (Set External Rating on Interest Pricing Modification) '${ExternalRatingMin}' is not a valid Min Rating Symbol

    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_MaxRating_List}    ${ExternalRatingMaxValue}
    Run Keyword If    '${ExternalRatingMax}'=='<'    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_LessThan_RadioButton}    ON
    ...    ELSE IF    '${ExternalRatingMax}'=='<='    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_LessThanOrEqual_RadioButton}    ON
    ...    ELSE    Fail    (Set External Rating on Interest Pricing Modification) '${ExternalRatingMax}' is not a valid Max Rating Symbol
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyOngoingFeePricing_ExternalRating
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_ExternalRating_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyPricingTab
    
Modify Ongoing Fee Pricing - Insert After for LLA
    [Documentation]    This keyword adds ongoing fee - after on facility.
    ...    @author: makcamps    06JAN2021    - Initial Create
    [Arguments]    ${sFacilityItemAfter}    ${sFacility_Percent}
    
    ### Keyword Pre-processing ###
    ${FacilityItemAfter}    Acquire Argument Value    ${sFacilityItemAfter}
    ${Facility_Percent}    Acquire Argument Value    ${sFacility_Percent}
    
    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_After_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    FormulaCategory
    Run Keyword And Continue On Failure    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    Matrix
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
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Ongoing Fee Pricing").JavaTree("developer name:=.*${Facility_Percent}.*")    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeePricing
    
Modify Interest Pricing - Insert Matrix of External Rating
    [Documentation]    This keyword adds interest pricing on facility.
    ...    @author: makcamps    06JAN2021    - Initial Create
    [Arguments]    ${sCondition}    ${sExtRatingType}    ${sExtRatingMinValue}    ${sExtRatingMaxValue}    ${sExtRatingMin}=>=    ${sExtRatingMax}=<

    ### Keyword Pre-processing ###
    ${Condition}    Acquire Argument Value    ${sCondition}
    ${ExternalRatingType}    Acquire Argument Value    ${sExtRatingType}
    ${ExternalRatingMinValue}    Acquire Argument Value    ${sExtRatingMinValue}
    ${ExternalRatingMin}    Acquire Argument Value    ${sExtRatingMin}
    ${ExternalRatingMaxValue}    Acquire Argument Value    ${sExtRatingMaxValue}
    ${ExternalRatingMax}    Acquire Argument Value    ${sExtRatingMax}
    
    Run Keyword If    '${Condition}'=='After'    mx LoanIQ click    ${LIQ_Facility_InterestPricing_After_Button}
    ...    ELSE IF    '${Condition}'=='Add'    mx LoanIQ click    ${LIQ_Facility_InterestPricing_Add_Button}
    ...    ELSE IF    '${Condition}'=='And'    mx LoanIQ click    ${LIQ_Facility_InterestPricing_And_Button}
    ...    ELSE IF    '${Condition}'=='Or'    mx LoanIQ click    ${LIQ_FacilityPricing_OngoingFees_Or_Button}
    ...    ELSE    Fail    '${Condition}' is not a valid condition

    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    Matrix
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_AddItem_List}      VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_Type_List}    External Rating
    Run Keyword If    '${status}' == 'True'    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}
    
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_ExternalRating_Window}
    Validate if Element is Checked    ${LIQ_Facility_InterestPricing_ExternalRating_Borrower_RadioButton}    External Rating Window - Borrower Radio Button
    
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_Type_List}    ${ExternalRatingType}

    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_MinRating_List}    ${ExternalRatingMinValue}
    Run Keyword If    '${ExternalRatingMin}'=='>='    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_GreaterThanOrEqual_RadioButton}    ON
    ...    ELSE IF    '${ExternalRatingMin}'=='>'    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_GreaterThan_RadioButton}    ON
    ...    ELSE    Fail    (Set External Rating on Interest Pricing Modification) '${ExternalRatingMin}' is not a valid Min Rating Symbol

    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_ExternalRating_MaxRating_List}    ${ExternalRatingMaxValue}
    Run Keyword If    '${ExternalRatingMax}'=='<'    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_LessThan_RadioButton}    ON
    ...    ELSE IF    '${ExternalRatingMax}'=='<='    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_ExternalRating_LessThanOrEqual_RadioButton}    ON
    ...    ELSE    Fail    (Set External Rating on Interest Pricing Modification) '${ExternalRatingMax}' is not a valid Max Rating Symbol
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing_ExternalRating
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_ExternalRating_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ModifyInterestPricing
    
Modify Interest Pricing - Insert After for LLA
    [Documentation]    This keyword adds interest pricing on facility.
    ...    @author: makcamps    06JAN2021    - Initial Create
    [Arguments]    ${sInterestPricingItem}    ${sOptionName}    ${sRateBasisInterestPricing}    ${sFormulaText}    ${sSpread}    ${sPercentOfRateFormulaUsage}=None

    ### Keyword Pre-processing ###
    ${InterestPricingItem}    Acquire Argument Value    ${sInterestPricingItem}
    ${OptionName}    Acquire Argument Value    ${sOptionName}
    ${RateBasisInterestPricing}    Acquire Argument Value    ${sRateBasisInterestPricing}
    ${FormulaText}    Acquire Argument Value    ${sFormulaText}
    ${Spread}    Acquire Argument Value    ${sSpread}
    ${PercentOfRateFormulaUsage}    Acquire Argument Value    ${sPercentOfRateFormulaUsage}
 
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_Window}        VerificationData="Yes"  
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_After_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_InterestPricing_AddItem_List}      VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${InterestPricingItem}
    Run Keyword If    '${status}' == 'True'    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_OptionName_List}    ${OptionName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_RateBasis_List}    ${RateBasisInterestPricing}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OptionCondition_OK_Button}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategoryFormulaText_TextField}    ${FormulaText}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ON
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread} 
    Run Keyword If    '${PercentOfRateFormulaUsage}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_FormulaCategory_PercentOfRateFormulaUsage_List}    ${PercentOfRateFormulaUsage}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button}
    mx LoanIQ click element if present    ${LIQ_PleaseConfirm_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InterestPricing
