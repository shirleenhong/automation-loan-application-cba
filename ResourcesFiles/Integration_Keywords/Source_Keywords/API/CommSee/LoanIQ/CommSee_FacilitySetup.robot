*** Settings ***
Resource     ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Term Facility for Syndicated Deal - ComSee 
    [Documentation]    This keyword is used to create a Term Facility with multiple ongoing fees for syndicated deal.
    ...    @author: rtarayao    02SEP2019    - initial create
    ...    @update: jloretiz    07NOV2019....- add writing of details for facility in issuance tab
    [Arguments]    ${ExcelPath}
    
    ###Data Generation###
    ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    ComSee_SC2_Deal    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Issuance    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC2_LoanRepricing    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}

    ${FacilityName}    Read Data From Excel    ComSee_SC2_FacSetup    Facility_Name    ${rowid}    ${ComSeeDataSet}
    
    ###Facility Creation###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395
    
    Set Facility Dates    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType2]
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    Add Facility Currency    &{ExcelPath}[Facility_Currency1]
    Add Facility Currency    &{ExcelPath}[Facility_Currency2]
    Add Facility Borrower - Add All    &{ExcelPath}[Facility_Borrower]
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType1]
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType2]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency2]
    Complete Facility Borrower Setup
    
    ###Get necessary data from created Facility and store to Excel to be used in other transactions###
    ${ExpiryDate}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_ExpiryDate_Datefield}
    Write Data To Excel    ComSee_SC2_Deal    Primary_PortfolioExpiryDate    ${rowid}    ${ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Issuance    SBLC_ExpiryDate    ${rowid}    ${ExpiryDate}    ${ComSeeDataSet}
    
    ${FacilityControlNumber}    Get Facility Control Number
    ${MulitCCYStatus}    Get Facility Multi CCY Status
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_MultiCCY    ${rowid}    ${MulitCCYStatus}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_ControlNumber    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Issuance    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    
    ${Facility_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_EffectiveDate}
    ${Facility_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_ExpiryDate}
    ${Facility_MaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_MaturityDate}
    
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_FinalMaturityDate    ${rowid}    ${Facility_MaturityDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}    ${ComSeeDataSet}
    
    ###Facility Notebook - Codes Tab###
    ${FundingDeskDesc}    Get Facility Funding Desk Description
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_FundingDeskDescription    ${rowid}    ${FundingDeskDesc}    ${ComSeeDataSet}

Set Up Facility - ComSee
    [Documentation]    This keyword is used to create a facility.
    ...    @author: rtarayao    14AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Log In to LIQ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ##Search Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Data Generation###
    ${Facility_Name}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    ComSee_SC1_Deal    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    
    ###New Facility Screen###
    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395
    
    Write Data To Excel    ComSee_SC1_Deal    Primary_PortfolioExpiryDate    ${rowid}     ${Facility_ExpiryDate}    ${ComSeeDataSet}
    
    Enter Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    ${FacilityControlNumber}    Get Facility Control Number
    ${MulitCCYStatus}    Get Facility Multi CCY Status
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_MultiCCY    ${rowid}    ${MulitCCYStatus}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC1_Deal    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_ControlNumber    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}   
    
    ###Facility Notebook - Codes Tab###
    ${FundingDeskDesc}    Get Facility Funding Desk Description
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_FundingDeskDescription    ${rowid}    ${FundingDeskDesc}    ${ComSeeDataSet}
    
    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${Facility_EffectiveDate}
    
    ${Facility_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_EffectiveDate}
    ${Facility_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_ExpiryDate}
    ${Facility_MaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_MaturityDate}
    
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_FinalMaturityDate    ${rowid}    ${Facility_MaturityDate}    ${ComSeeDataSet}
    
Setup Multi-Currency SBLC Facility - ComSee
    [Documentation]    Sets up a multi-currency SBLC Facility.
    ...    @author: rtarayao    20AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Test Data Name Generation
    ${FacilityName}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    ComSee_SC3_FacSetup    Facility_Name    ${rowid}    ${FacilityName}    ${ComSeeDataSet}
	Write Data To Excel    ComSee_SC3_Issuance    Facility_Name    ${rowid}    ${FacilityName}    ${ComSeeDataSet}    
	Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Facility_Name    ${rowid}    ${FacilityName}    ${ComSeeDataSet}
	${FacilityName}    Read Data From Excel    ComSee_SC3_FacSetup    Facility_Name    ${rowid}    ${ComSeeDataSet}
    
    ###Date Generation
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395 
    Write Data To Excel    ComSee_SC3_Deal    Primary_PortfolioExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    SBLC_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    
    ###Facility Notebook
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]
    ...    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Set Facility Dates    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}     
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    Add Facility Currency    &{ExcelPath}[Facility_CurrencyCode1]
    Add Facility Currency    &{ExcelPath}[Facility_CurrencyCode2]
    Add Facility Borrower - Add All
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency2]
    Complete Facility Borrower Setup
    Validate Multi CCY Facility
    
    ###Get FCN Number
    ${FacilityControlNumber}    Get Facility Control Number
    Write Data To Excel    ComSee_SC3_Issuance    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    
Setup Fees for Term Facility - ComSee
    [Documentation]    Sets up the Ongoing Fees and Interests in a Term Facility.
    ...    @author: rtarayao    26AUG2019    - initial create
    [Arguments]    ${ComSeeDataSet}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    
    ###Ongoing Fee###
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate Facility Pricing Window    &{ComSeeDataSet}[Facility_Name]    Ongoing Fee
    
    Add Facility Ongoing Fees    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[OngoingFee_Type1]    &{ComSeeDataSet}[OngoingFee_RateBasis1]
    ...    &{ComSeeDataSet}[OngoingFee_AfterItem]    &{ComSeeDataSet}[OngoingFee_AfterItemType]
    ...    &{ComSeeDataSet}[FormulaCategory_Type1]    &{ComSeeDataSet}[OngoingFee_SpreadType1]    &{ComSeeDataSet}[OngoingFee_SpreadAmt1]
      
    Add Facility Ongoing Fees    &{ComSeeDataSet}[OngoingFee_Category1]    &{ComSeeDataSet}[OngoingFee_Type2]    &{ComSeeDataSet}[OngoingFee_RateBasis1]
    ...    &{ComSeeDataSet}[OngoingFee_AfterItem]    &{ComSeeDataSet}[OngoingFee_AfterItemType]
    ...    &{ComSeeDataSet}[FormulaCategory_Type1]    &{ComSeeDataSet}[OngoingFee_SpreadType1]    &{ComSeeDataSet}[OngoingFee_SpreadAmt1]
    Add Facility Ongoing Fees    &{ComSeeDataSet}[OngoingFee_Category2]    &{ComSeeDataSet}[OngoingFee_Type3]    &{ComSeeDataSet}[OngoingFee_RateBasis1]
    ...    &{ComSeeDataSet}[OngoingFee_AfterItem]    &{ComSeeDataSet}[OngoingFee_AfterItemType]
    ...    &{ComSeeDataSet}[FormulaCategory_Type1]    &{ComSeeDataSet}[OngoingFee_SpreadType1]    &{ComSeeDataSet}[OngoingFee_SpreadAmt1]
    Add Facility Ongoing Fees    &{ComSeeDataSet}[OngoingFee_Category2]    &{ComSeeDataSet}[OngoingFee_Type4]    &{ComSeeDataSet}[OngoingFee_RateBasis1]
    ...    &{ComSeeDataSet}[OngoingFee_AfterItem]    &{ComSeeDataSet}[OngoingFee_AfterItemType]
    ...    &{ComSeeDataSet}[FormulaCategory_Type1]    &{ComSeeDataSet}[OngoingFee_SpreadType1]    &{ComSeeDataSet}[OngoingFee_SpreadAmt1]
    Validate Ongoing Fee or Interest
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_OngoingFeeInterest_OK_Button}
    
    ##Interest Pricing###
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    Validate Facility Pricing Window    &{ComSeeDataSet}[Facility_Name]    Interest
    Add Facility Interest    &{ComSeeDataSet}[Interest_AddItem]    &{ComSeeDataSet}[Interest_OptionName1]    &{ComSeeDataSet}[Interest_RateBasis]
    ...    &{ComSeeDataSet}[Interest_SpreadType1]    &{ComSeeDataSet}[Interest_SpreadValue1]    &{ComSeeDataSet}[Interest_BaseRateCode1]
    Add Facility Interest    &{ComSeeDataSet}[Interest_AddItem]    &{ComSeeDataSet}[Interest_OptionName2]    &{ComSeeDataSet}[Interest_RateBasis]
    ...    &{ComSeeDataSet}[Interest_SpreadType1]    &{ComSeeDataSet}[Interest_SpreadValue2]    &{ComSeeDataSet}[Interest_BaseRateCode2]
    Add Facility Interest    &{ComSeeDataSet}[Interest_AddItem]    &{ComSeeDataSet}[Interest_OptionName3]    &{ComSeeDataSet}[Interest_RateBasis]
    ...    &{ComSeeDataSet}[Interest_SpreadType1]    &{ComSeeDataSet}[Interest_SpreadValue1]    &{ComSeeDataSet}[Interest_BaseRateCode3]
    Validate Ongoing Fee or Interest
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_OngoingFeeInterest_OK_Button}
    Validate Facility Pricing Rule Items    &{ComSeeDataSet}[Facility_PricingRuleOption1]
    Validate Facility Pricing Rule Items    &{ComSeeDataSet}[Facility_PricingRuleOption2]
    Validate Facility Pricing Rule Items    &{ComSeeDataSet}[Facility_PricingRuleOption3]
    Validate Facility Pricing Rule Items    &{ComSeeDataSet}[Facility_PricingRuleOption4]
    
    ###Facility Validation and close###
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}

    # ###Ongoing Fee Details
    # ##Ongoing Fee Details
    # Navigate to Facility Notebook from Deal Notebook    ${FacilityName}
    # Navigate to Commitment Fee List
    
    # ###Get and Write Fronting Commitment Fee (SFBG) Details
    # ${LineFee}    Read Data From Excel    ComSee_SC7_FacFeeSetup    OngoingFee_Type1    ${rowid}    ${ComSeeDataSet}
    # ${LineFee_Status}    ${LineFee_Alias}    Get Ongoing Fee Alias and Status    ${LineFee}
    
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_Type    ${rowid}    ${LineFee}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_Status    ${rowid}    ${LineFee_Status}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_FeeAlias    ${rowid}    ${LineFee_Alias}    ${ComSeeDataSet}
    
    # ###Close Fee List Window
    # Close Facility Fee List Window
    
    # ###Navigate to Commitment Fee Notebook
    # Navigate to Commitment Fee Notebook    ${LineFee}
    
    # ###Write Fee Details for Comsee
    # ${LineFeeRate}    Get Fee Current Rate    ${LIQ_LineFee_Window}    ${LIQ_LineFee_CurrentRate_Field}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_CurrentRate    ${rowid}    ${LineFeeRate}    ${ComSeeDataSet}
    
    # ${LineFeeCurrency}    Get Fee Currency    ${LIQ_LineFee_Window}    ${LIQ_LineFee_Currency_Text}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_Currency    ${rowid}    ${LineFeeCurrency}    ${ComSeeDataSet}

    # ${LineFeeEffectiveDate}    ${LineFeeActualExpiryDate}    Get Fee Effective and Actual Expiry Date    ${LIQ_LineFee_Window}    ${LIQ_LineFee_Effective_Date}    ${LIQ_LineFee_ActualExpiryDate_Text}
    # ${LineFeeEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeEffectiveDate}
    # ${LineFeeActualExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeActualExpiryDate}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_EffectiveDate    ${rowid}    ${LineFeeEffectiveDate}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_ExpiryDate    ${rowid}    ${LineFeeActualExpiryDate}    ${ComSeeDataSet}
    
    # ${LineFeeCycleStartDate}    ${LineFeeAccrualEndDate}    Get Fee Accrual Cycle Start and End Date    ${LIQ_LineFee_Window}    ${LIQ_LineFee_CycleStartDate_Text}    ${LIQ_LineFee_AccrualEnd_Date}
    # ${LineFeeCycleStartDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeCycleStartDate}
    # ${LineFeeAccrualEndDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeAccrualEndDate}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_CycleStartDate    ${rowid}    ${LineFeeCycleStartDate}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_AccrualEndDate    ${rowid}    ${LineFeeAccrualEndDate}    ${ComSeeDataSet}

    # ${LineFeeAdjustedDueDate}    Get Fee Adjusted Due Date    ${LIQ_LineFee_Window}    ${LIQ_LineFee_AdjustedDue_Date}
    # ${LineFeeAdjustedDueDate}    Convert LIQ Date to Year-Month-Day Format    ${LineFeeAdjustedDueDate}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_DueDate    ${rowid}    ${LineFeeAdjustedDueDate}    ${ComSeeDataSet}
    
    # ${LineAccruedtodateAmount}    Get Fee Accrued to Date Amount    ${LIQ_LineFee_Window}    ${LIQ_LineFee_Tab}    ${LIQ_LineFee_Accrual_Cycles_JavaTree}
    # ${LineAccruedtodateAmount}    Remove Comma and Convert to Number    ${LineAccruedtodateAmount}
    # Write Data To Excel    ComSee_SC7_FacFeeSetup    Fee_AccruedToDate    ${rowid}    ${LineAccruedtodateAmount}    ${ComSeeDataSet}
    
    # ${OngoingFee_PaidToDate}    Get Fee Paid to Date Amount    ${LIQ_LineFee_Window}    ${LIQ_LineFee_Tab}    ${LIQ_LineFee_Accrual_Cycles_JavaTree}
    # ${OngoingFee_PaidToDate}    Remove Comma and Convert to Number    ${OngoingFee_PaidToDate}
    # Write Data To Excel    ComSee_SC3_Issuance    Fee_PaidToDate    ${rowid}    ${OngoingFee_PaidToDate}    ${ComSeeDataSet}
    
    # Close All Windows on LIQ  
    
Setup Facility - Scenario 7 ComSee
    [Documentation]    This keyword is used to create a facility.
    ...    @author: rtarayao    11SEP2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Log In to LIQ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ##Search Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Data Generation###
    ${Facility_Name}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    ComSee_SC7_Deal    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_Loan    Loan_FacilityName    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_PrincipalLoanPayment    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_LoanInterestPayment    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_LoanInterestPayment    Loan_FacilityName    ${rowid}    ${Facility_Name}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    
    ###New Facility Screen###
    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395
    
    Write Data To Excel    ComSee_SC7_Deal    Primary_PortfolioExpiryDate    ${rowid}     ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Loan_MaturityDate    ${rowid}     ${Facility_MaturityDate}    ${ComSeeDataSet}
    
    Enter Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    ${FacilityControlNumber}    Get Facility Control Number
    ${MulitCCYStatus}    Get Facility Multi CCY Status
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_MultiCCY    ${rowid}    ${MulitCCYStatus}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_Deal    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_ControlNumber    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}  
    Write Data To Excel    ComSee_SC7_FacFeeSetup    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet} 
    
    # ###Facility Notebook - Codes Tab###
    ${FundingDeskDesc}    Get Facility Funding Desk Description
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_FundingDeskDescription    ${rowid}    ${FundingDeskDesc}    ${ComSeeDataSet}
        
    
    # ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${Facility_EffectiveDate}
    
    ${Facility_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_EffectiveDate}
    ${Facility_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_ExpiryDate}
    ${Facility_MaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_MaturityDate}
    
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_FinalMaturityDate    ${rowid}    ${Facility_MaturityDate}    ${ComSeeDataSet}
    
Setup Expired Facility - Scenario 7 ComSee
    [Documentation]    This keyword is used to create a facility.
    ...    @author: cfrancis    06OCT2020    - Initial Create
    [Arguments]    ${ExcelPath}
    ###Log In to LIQ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ##Search Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Data Generation###
    ${Facility_Name}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    ComSee_SC7_Deal    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_Loan    Loan_FacilityName    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_PrincipalLoanPayment    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_LoanInterestPayment    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    # Write Data To Excel    ComSee_SC7_LoanInterestPayment    Loan_FacilityName    ${rowid}    ${Facility_Name}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    Facility_Name    ${rowid}    ${Facility_Name}    ${ComSeeDataSet}
    
    ###New Facility Screen###
    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    1
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    31
    
    Write Data To Excel    ComSee_SC7_Deal    Primary_PortfolioExpiryDate    ${rowid}     ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Loan    Loan_MaturityDate    ${rowid}     ${Facility_MaturityDate}    ${ComSeeDataSet}
    
    Enter Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    ${FacilityControlNumber}    Get Facility Control Number
    ${MulitCCYStatus}    Get Facility Multi CCY Status
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_MultiCCY    ${rowid}    ${MulitCCYStatus}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_Deal    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_ControlNumber    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet}  
    Write Data To Excel    ComSee_SC7_FacFeeSetup    COM_ID    ${rowid}    ${FacilityControlNumber}    ${ComSeeDataSet} 
    
    # ###Facility Notebook - Codes Tab###
    ${FundingDeskDesc}    Get Facility Funding Desk Description
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_FundingDeskDescription    ${rowid}    ${FundingDeskDesc}    ${ComSeeDataSet}
        
    
    # ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${Facility_EffectiveDate}
    
    ${Facility_EffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_EffectiveDate}
    ${Facility_ExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_ExpiryDate}
    ${Facility_MaturityDate}    Convert LIQ Date to Year-Month-Day Format    ${Facility_MaturityDate}
    
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_FinalMaturityDate    ${rowid}    ${Facility_MaturityDate}    ${ComSeeDataSet}

Write Facility Ongoing Fee Details for Syndicated Deal - ComSee
    [Documentation]    This test case writes the test ongoing fee details for comsee use.
    ...    @author: rtarayao    02SEP2019    - Initial create
    [Arguments]    ${ExcelPath}
    
    ###LIQ Login
    # Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Read Facility Name
    ${FacilityName}    Read Data From Excel    ComSee_SC2_FacFeeSetup    Facility_Name    ${rowid}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC2_Deal    Fee_Name    ${rowid}    ${FacilityName},${FacilityName}    ${ComSeeDataSet}  
    
    ###Search Deal and Write Facility Name for ComSee
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Ongoing Fee Details
    Navigate to Facility Notebook from Deal Notebook    ${FacilityName}
    Navigate to Commitment Fee List
    
    ###Get and Write Commitment Fee Status and Alias Details
    ${IndemnityFee}    Read Data From Excel    ComSee_SC2_FacFeeSetup    OngoingFee_Type1    ${rowid}    ${ComSeeDataSet}
    ${IndemnityFee_Status}    ${IndemnityFee_Alias}    Get Ongoing Fee Alias and Status    ${IndemnityFee}
    
    ###Get and Write Fronting Commitment Fee (SFBG) Details
    ${CommitmentFee}    Read Data From Excel    ComSee_SC2_FacFeeSetup    OngoingFee_Type2    ${rowid}    ${ComSeeDataSet}
    ${CommitmentFee_Status}    ${CommitmentFee_Alias}    Get Ongoing Fee Alias and Status    ${CommitmentFee}
    
    Write Data To Excel    ComSee_SC2_Deal    Fee_Type    ${rowid}    ${IndemnityFee},${CommitmentFee}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    Fee_Status    ${rowid}    ${IndemnityFee_Status},${CommitmentFee_Status}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    Fee_FeeAlias    ${rowid}    ${IndemnityFee_Alias},${CommitmentFee_Alias}    ${ComSeeDataSet}
    
    ###Close Fee List Window
    Close Facility Fee List Window
    
    ###Navigate to Commitment Fee Notebook
    Navigate to Indemnity Fee Usage Notebook     ${IndemnityFee}
    
    ###Get and Write Commitment Fee Details
    ${IndemnityFeeRate}    Get Indemnity Fee Usage Current Rate
    ${IndemnityFeeCurrency}    Get Indemnity Fee Usage Currency
    ${IndemnityFeeEffectiveDate}    ${IndemnityFeeActualExpiryDate}    Get Indemnity Fee Usage Effective and Actual Expiry Date
    ${IndemnityFeeEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${IndemnityFeeEffectiveDate}
    ${IndemnityFeeActualExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${IndemnityFeeActualExpiryDate}
    ${IndemnityFeeAdjustedDueDate}    Get Indemnity Fee Usage Adjusted Due Date
    ${IndemnityFeeAdjustedDueDate}    Convert LIQ Date to Year-Month-Day Format    ${IndemnityFeeAdjustedDueDate}
    ${IndemnityAccruedtodateAmount}    Get Indemnity Fee Usage Accrued to Date Amount
    ${IndemnityAccruedtodateAmount}    Remove Comma and Convert to Number    ${IndemnityAccruedtodateAmount}
    ${TotalRowCount}    Get Accrual Row Count    ${LIQ_IndemnityFee_Window}    ${LIQ_IndemnityFee_Acrual_JavaTree}
    ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_IndemnityFee_Tab}    ${LIQ_IndemnityFee_Acrual_JavaTree}
    ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    Validate Accrued to Date Amount    ${AccruedtoDateAmt}    ${IndemnityAccruedtodateAmount}
    
    ###Close Fee windows
    Close Indemnity Fee Usage and Fee List Windows
    
    ###Navigate to Commitment Fee Notebook
    Navigate to Commitment Fee Notebook    ${CommitmentFee}
    
    ###Write Fee Details for Comsee
    ${CommitmentFeeRate}    Get Fee Current Rate     ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_CurrentRate_Field}
    Write Data To Excel    ComSee_SC2_Deal    Fee_CurrentRate    ${rowid}    ${IndemnityFeeRate},${CommitmentFeeRate}    ${ComSeeDataSet}
    
    ${CommitmentFeeCurrency}    Get Fee Currency    ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_Currency_Text}
    Write Data To Excel    ComSee_SC2_Deal    Fee_Currency    ${rowid}    ${IndemnityFeeCurrency},${CommitmentFeeCurrency}    ${ComSeeDataSet}

    ${CommitmentFeeEffectiveDate}    ${CommitmentFeeActualExpiryDate}    Get Fee Effective and Actual Expiry Date    ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_EffectiveDate_Field}    ${LIQ_CommitmentFee_ActualExpiryDate_Text}    
    ${CommitmentFeeEffectiveDate}    Convert LIQ Date to Year-Month-Day Format    ${CommitmentFeeEffectiveDate}
    ${CommitmentFeeActualExpiryDate}    Convert LIQ Date to Year-Month-Day Format    ${CommitmentFeeActualExpiryDate}
    Write Data To Excel    ComSee_SC2_Deal    Fee_EffectiveDate    ${rowid}    ${IndemnityFeeEffectiveDate},${CommitmentFeeEffectiveDate}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    Fee_ExpiryDate    ${rowid}    ${IndemnityFeeActualExpiryDate},${CommitmentFeeActualExpiryDate}    ${ComSeeDataSet}
    
    ${CommitmentFeeAdjustedDueDate}    Get Fee Adjusted Due Date    ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_AdjustedDueDate}
    ${CommitmentFeeAdjustedDueDate}    Convert LIQ Date to Year-Month-Day Format    ${CommitmentFeeAdjustedDueDate}
    Write Data To Excel    ComSee_SC2_Deal    Fee_DueDate    ${rowid}    ${IndemnityFeeAdjustedDueDate},${CommitmentFeeAdjustedDueDate}    ${ComSeeDataSet}
    
    ${CommitmentAccruedtodateAmount}    Get Fee Accrued to Date Amount    ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_Tab}    ${LIQ_CommitmentFee_Acrual_JavaTree}
    ${CommitmentAccruedtodateAmount}    Remove Comma and Convert to Number    ${CommitmentAccruedtodateAmount}
    ${TotalRowCount}    Get Accrual Row Count    ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_Acrual_JavaTree}
    ${AccruedtoDateAmt}    Compute Total Accruals for Fee    ${TotalRowCount}    ${LIQ_CommitmentFee_Tab}    ${LIQ_CommitmentFee_Acrual_JavaTree}
    ${AccruedtoDateAmt}    Remove Comma and Convert to Number    ${AccruedtoDateAmt}
    Validate Accrued to Date Amount    ${AccruedtoDateAmt}    ${CommitmentAccruedtodateAmount}
    Write Data To Excel    ComSee_SC2_Deal    Fee_AccruedToDate    ${rowid}    ${IndemnityAccruedtodateAmount},${CommitmentAccruedtodateAmount}    ${ComSeeDataSet}
    
    Close All Windows on LIQ
    
    Logout from LoanIQ
    