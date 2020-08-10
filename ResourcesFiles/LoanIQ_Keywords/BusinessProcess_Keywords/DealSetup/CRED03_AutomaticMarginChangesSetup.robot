*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***    
Add Pricing Option for Bilateral Deal with MultiRisk Types
    [Documentation]    This high-level keyword defines the Pricing Options to be used in a Bilateral Deal.
    ...    @author: rtaryao    26Feb2019    initial creation
    [Arguments]    ${ExcelPath}
    
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    
    ...    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    &{ExcelPath}[PricingOption_InitialFractionRate]    &{ExcelPath}[PricingOption_RoundingDecimalPrecision]    &{ExcelPath}[PricingOption_RoundingApplicationMethod]
    ...    &{ExcelPath}[PricingOption_PercentOfRateFormulaUsage]    &{ExcelPath}[PricingOption_RepricingNonBusinessDayRule]    &{ExcelPath}[PricingOption_FeeOnLenderShareFunding]    &{ExcelPath}[PricingOption_InterestDueUponPrincipalPayment]
    ...    &{ExcelPath}[PricingOption_InterestDueUponRepricing]    &{ExcelPath}[PricingOption_ReferenceBanksApply]    &{ExcelPath}[PricingOption_IntentNoticeDaysInAdvance]    &{ExcelPath}[PricingOption_IntentNoticeTime]    &{ExcelPath}[PricingOption_12HrPeriodOption]
    ...    &{ExcelPath}[PricingOption_MaximumDrawdownAmount]    &{ExcelPath}[PricingOption_MinimumDrawdownAmount]    &{ExcelPath}[PricingOption_MinimumPaymentAmount]    &{ExcelPath}[PricingOption_MinimumAmountMultiples]    &{ExcelPath}[PricingOption_Currency]    N   
     
    # This will be read on the respective test cases.
    # ${Deal_PricingOption}    Read Data From Excel    CRED01_PricingOption    Deal_PricingOption    ${rowid}    ${ExcelPath}    Y
    # Write Data To Excel    SERV_47_FlexPISchedule    Loan_PricingOption    ${rowid}    @{Deal_PricingOption}[4]
    # Write Data To Excel    SERV23_LoanPaperClip    Loan_PricingOption    ${rowid}    @{Deal_PricingOption}[4]

Setup Financial Ratio, Fees and Pricing Options for Comprehensive Deal
    [Documentation]    This high-level keyword sets up the Financial Ratio, Upfront Fee and Pricing Options/Rules in a Syndicated Deal without Lenders.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ### Ratios/Conds Tab
    Add Financial Ratio    &{ExcelPath}[RatioType1]    &{ExcelPath}[FinancialRatio]    &{ExcelPath}[FinancialRatioStartDate]
    Add Financial Ratio    &{ExcelPath}[RatioType2]    &{ExcelPath}[FinancialRatio]    &{ExcelPath}[FinancialRatioStartDate]
    
    ### Pricing Rules Tab - Pricing Options
    ### BBSY - Bid
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    ### BBSW - Mid
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption2]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    ### USD LIBOR  Option
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption3]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    
    ### API Validation of Repricing Frequency value.
    Validate Interest Pricing Frequency Addded From Base Rate API    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[BaseRate_Frequency]
    Deal Pricing Option Select All Frequency
    Close Interest Pricing Option Details Window
    
    Validate Interest Pricing Frequency Addded From Base Rate API    &{ExcelPath}[Deal_PricingOption2]    &{ExcelPath}[BaseRate_Frequency]
    Deal Pricing Option Select All Frequency
    Close Interest Pricing Option Details Window
    
    Validate Interest Pricing Frequency Addded From Base Rate API    &{ExcelPath}[Deal_PricingOption3]    &{ExcelPath}[BaseRate_Frequency]
    Deal Pricing Option Select All Frequency
    Close Interest Pricing Option Details Window
    
    ### Pricing Rules
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
    ...    ON    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    Verify Details on Events Tab    &{ExcelPath}[CreatedUser]    &{ExcelPath}[UnrestrictedUser]    &{ExcelPath}[FRCUser]    

Set Up Automated Changes to Margin Based on Dates or External Factors
    [Documentation]    This high-level keyword is used to set up automated changes to margin based on dates or external factors.
    ...    @author: hstone    09JUN2020     - initial creation
    [Arguments]    ${ExcelPath}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Setup Customer Risk Rating ###
    Search by Customer Short Name    ${ExcelPath}[Customer_ShortName]    ${ExcelPath}[Customer_ID]
    Switch Customer Notebook to Update Mode
    Add Internal Risk Rating    ${ExcelPath}[InternalRating_RatingType]    ${ExcelPath}[InternalRating_Rating]    ${ExcelPath}[InternalRating_Percent]
    ...    ${ExcelPath}[InternalRating_EffectiveDate]    ${ExcelPath}[InternalRating_ExpiryDate]
    Validate Internal Risk Rating Table    ${ExcelPath}[InternalRating_RatingType]    ${ExcelPath}[InternalRating_Rating]    ${ExcelPath}[InternalRating_Percent]
    ...    ${ExcelPath}[InternalRating_EffectiveDate]    ${ExcelPath}[InternalRating_ExpiryDate]
    Add External Risk Rating    ${ExcelPath}[ExternalRating_RatingType]    ${ExcelPath}[ExternalRating_Rating]    ${ExcelPath}[ExternalRating_StartDate]
    Validate External Risk Rating Table    ${ExcelPath}[ExternalRating_RatingType]    ${ExcelPath}[ExternalRating_Rating]    ${ExcelPath}[ExternalRating_StartDate]

    ### Add Deal Financial Ratio ###
    Open Existing Deal    ${ExcelPath}[Deal_Name]
    Add Financial Ratio    &{ExcelPath}[DealRationAndConds_RatioType]    &{ExcelPath}[DealRationAndConds_FinancialRatio]    &{ExcelPath}[DealRationAndConds_FinancialRatioStartDate]
    Validate Deal Financial Ratio Added    &{ExcelPath}[DealRationAndConds_RatioType]

    ### Facility Interest Pricing Modification ###
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Modify Interest Pricing

    ### Add First Interest Pricing ###
    Add Interest Pricing    &{ExcelPath}[InterestPricing_Add_PricingItem1]    &{ExcelPath}[InterestPricing_Add_PricingType1]
    Set External Rating on Interest Pricing Modification    &{ExcelPath}[InterestPricing_ExternalRatingType1]    &{ExcelPath}[InterestPricing_MinSign1]    &{ExcelPath}[InterestPricing_MinRating1]
    ...    &{ExcelPath}[InterestPricing_MaxSign1]    &{ExcelPath}[InterestPricing_MaxRating1]
    Validate Interest Pricing Formula    &{ExcelPath}[InterestPricing_Add_PricingItem1]    &{ExcelPath}[InterestPricing_Add_PricingType1]    ${ExcelPath}[Customer_ShortName]
    ...    &{ExcelPath}[InterestPricing_ExternalRatingType1]    &{ExcelPath}[InterestPricing_MinSign1]    &{ExcelPath}[InterestPricing_MinRating1]
    ...    &{ExcelPath}[InterestPricing_MaxSign1]    &{ExcelPath}[InterestPricing_MaxRating1]

    ### Add After for the First Interest Pricing ###
    Select Interest Pricing Formula    &{ExcelPath}[InterestPricing_Add_PricingItem1]    &{ExcelPath}[InterestPricing_Add_PricingType1]    ${ExcelPath}[Customer_ShortName]
    ...    &{ExcelPath}[InterestPricing_ExternalRatingType1]    &{ExcelPath}[InterestPricing_MinSign1]    &{ExcelPath}[InterestPricing_MinRating1]
    ...    &{ExcelPath}[InterestPricing_MaxSign1]    &{ExcelPath}[InterestPricing_MaxRating1]
    Add After Interest Pricing    &{ExcelPath}[InterestPricing_After_PricingItem1]    &{ExcelPath}[InterestPricing_After_PricingType1]
    Set Interest Pricing Option Condition    &{ExcelPath}[OptionCondition_OptionName1]    &{ExcelPath}[OptionCondition_RateBasis1]
    Set Formula Category Values    &{ExcelPath}[FormulaCategory_SpreadType1]    &{ExcelPath}[FormulaCategory_SpreadValue1]
    Validate Interest Pricing Formula    &{ExcelPath}[InterestPricing_After_PricingItem1]    &{ExcelPath}[InterestPricing_After_PricingType1]    ${ExcelPath}[FormulaCategory_SpreadType1]
    ...    &{ExcelPath}[FormulaCategory_SpreadValue1]

    ### Add Second Interest Pricing ###
    Select Interest Pricing Formula    &{ExcelPath}[InterestPricing_Add_PricingItem1]    &{ExcelPath}[InterestPricing_Add_PricingType1]    ${ExcelPath}[Customer_ShortName]
    ...    &{ExcelPath}[InterestPricing_ExternalRatingType1]    &{ExcelPath}[InterestPricing_MinSign1]    &{ExcelPath}[InterestPricing_MinRating1]
    ...    &{ExcelPath}[InterestPricing_MaxSign1]    &{ExcelPath}[InterestPricing_MaxRating1]
    Add Interest Pricing    &{ExcelPath}[InterestPricing_Add_PricingItem2]    &{ExcelPath}[InterestPricing_Add_PricingType2]
    Set External Rating on Interest Pricing Modification    &{ExcelPath}[InterestPricing_ExternalRatingType2]    &{ExcelPath}[InterestPricing_MinSign2]    &{ExcelPath}[InterestPricing_MinRating2]
    ...    &{ExcelPath}[InterestPricing_MaxSign2]    &{ExcelPath}[InterestPricing_MaxRating2]
    Validate Interest Pricing Formula    &{ExcelPath}[InterestPricing_Add_PricingItem2]    &{ExcelPath}[InterestPricing_Add_PricingType2]    ${ExcelPath}[Customer_ShortName]
    ...    &{ExcelPath}[InterestPricing_ExternalRatingType2]    &{ExcelPath}[InterestPricing_MinSign2]    &{ExcelPath}[InterestPricing_MinRating2]
    ...    &{ExcelPath}[InterestPricing_MaxSign2]    &{ExcelPath}[InterestPricing_MaxRating2]

    ### Add After for the Second Interest Pricing ###
    Select Interest Pricing Formula    &{ExcelPath}[InterestPricing_Add_PricingItem2]    &{ExcelPath}[InterestPricing_Add_PricingType2]    ${ExcelPath}[Customer_ShortName]
    ...    &{ExcelPath}[InterestPricing_ExternalRatingType2]    &{ExcelPath}[InterestPricing_MinSign2]    &{ExcelPath}[InterestPricing_MinRating2]
    ...    &{ExcelPath}[InterestPricing_MaxSign2]    &{ExcelPath}[InterestPricing_MaxRating2]
    Add After Interest Pricing    &{ExcelPath}[InterestPricing_After_PricingItem2]    &{ExcelPath}[InterestPricing_After_PricingType2]
    Set Interest Pricing Option Condition    &{ExcelPath}[OptionCondition_OptionName2]    &{ExcelPath}[OptionCondition_RateBasis2]
    Set Formula Category Values    &{ExcelPath}[FormulaCategory_SpreadType2]    &{ExcelPath}[FormulaCategory_SpreadValue2]
    Validate Interest Pricing Formula    &{ExcelPath}[InterestPricing_After_PricingItem2]    &{ExcelPath}[InterestPricing_After_PricingType2]    ${ExcelPath}[FormulaCategory_SpreadType2]
    ...    &{ExcelPath}[FormulaCategory_SpreadValue2]

    ### Add Third Interest Pricing ###
    Select Interest Pricing Formula    &{ExcelPath}[InterestPricing_Add_PricingItem2]    &{ExcelPath}[InterestPricing_Add_PricingType2]    ${ExcelPath}[Customer_ShortName]
    ...    &{ExcelPath}[InterestPricing_ExternalRatingType2]    &{ExcelPath}[InterestPricing_MinSign2]    &{ExcelPath}[InterestPricing_MinRating2]
    ...    &{ExcelPath}[InterestPricing_MaxSign2]    &{ExcelPath}[InterestPricing_MaxRating2]
    Add Interest Pricing    &{ExcelPath}[InterestPricing_Add_PricingItem3]    &{ExcelPath}[InterestPricing_Add_PricingType3]
    Set External Rating on Interest Pricing Modification    &{ExcelPath}[InterestPricing_ExternalRatingType3]    &{ExcelPath}[InterestPricing_MinSign3]    &{ExcelPath}[InterestPricing_MinRating3]
    ...    &{ExcelPath}[InterestPricing_MaxSign3]    &{ExcelPath}[InterestPricing_MaxRating3]
    Validate Interest Pricing Formula    &{ExcelPath}[InterestPricing_Add_PricingItem3]    &{ExcelPath}[InterestPricing_Add_PricingType3]    ${ExcelPath}[Customer_ShortName]
    ...    &{ExcelPath}[InterestPricing_ExternalRatingType3]    &{ExcelPath}[InterestPricing_MinSign3]    &{ExcelPath}[InterestPricing_MinRating3]
    ...    &{ExcelPath}[InterestPricing_MaxSign3]    &{ExcelPath}[InterestPricing_MaxRating3]

    ### Add After for the Third Interest Pricing ###
    Select Interest Pricing Formula    &{ExcelPath}[InterestPricing_Add_PricingItem3]    &{ExcelPath}[InterestPricing_Add_PricingType3]    ${ExcelPath}[Customer_ShortName]
    ...    &{ExcelPath}[InterestPricing_ExternalRatingType3]    &{ExcelPath}[InterestPricing_MinSign3]    &{ExcelPath}[InterestPricing_MinRating3]
    ...    &{ExcelPath}[InterestPricing_MaxSign3]    &{ExcelPath}[InterestPricing_MaxRating3]
    Add After Interest Pricing    &{ExcelPath}[InterestPricing_After_PricingItem3]    &{ExcelPath}[InterestPricing_After_PricingType3]
    Set Interest Pricing Option Condition    &{ExcelPath}[OptionCondition_OptionName3]    &{ExcelPath}[OptionCondition_RateBasis3]
    Set Formula Category Values    &{ExcelPath}[FormulaCategory_SpreadType3]    &{ExcelPath}[FormulaCategory_SpreadValue3]
    Validate Interest Pricing Formula    &{ExcelPath}[InterestPricing_After_PricingItem3]    &{ExcelPath}[InterestPricing_After_PricingType3]    ${ExcelPath}[FormulaCategory_SpreadType3]
    ...    &{ExcelPath}[FormulaCategory_SpreadValue3]

    Validate and Confirm Interest Pricing

    ### Final Validations ###
    Navigate to Interest Pricing Zoom
    Validate Interest Pricing Zoom Matrix    &{ExcelPath}[InterestPricing_Add_PricingItem1]    &{ExcelPath}[InterestPricing_Add_PricingType1]    &{ExcelPath}[InterestPricing_MarginApplied1]
    ...    ${ExcelPath}[Customer_ShortName]    &{ExcelPath}[InterestPricing_ExternalRatingType1]    &{ExcelPath}[InterestPricing_MinSign1]    &{ExcelPath}[InterestPricing_MinRating1]
    ...    &{ExcelPath}[InterestPricing_MaxSign1]    &{ExcelPath}[InterestPricing_MaxRating1]
    Validate Interest Pricing Zoom Matrix    &{ExcelPath}[InterestPricing_Add_PricingItem2]    &{ExcelPath}[InterestPricing_Add_PricingType2]    &{ExcelPath}[InterestPricing_MarginApplied2]
    ...    ${ExcelPath}[Customer_ShortName]    &{ExcelPath}[InterestPricing_ExternalRatingType2]    &{ExcelPath}[InterestPricing_MinSign2]    &{ExcelPath}[InterestPricing_MinRating2]
    ...    &{ExcelPath}[InterestPricing_MaxSign2]    &{ExcelPath}[InterestPricing_MaxRating2]
    Validate Interest Pricing Zoom Matrix    &{ExcelPath}[InterestPricing_Add_PricingItem3]    &{ExcelPath}[InterestPricing_Add_PricingType3]    &{ExcelPath}[InterestPricing_MarginApplied3]
    ...    ${ExcelPath}[Customer_ShortName]    &{ExcelPath}[InterestPricing_ExternalRatingType3]    &{ExcelPath}[InterestPricing_MinSign3]    &{ExcelPath}[InterestPricing_MinRating3]
    ...    &{ExcelPath}[InterestPricing_MaxSign3]    &{ExcelPath}[InterestPricing_MaxRating3]    &{ExcelPath}[ExternalRating_StartDate]
    Validate Interest Pricing Zoom Details    &{ExcelPath}[InterestPricing_After_PricingItem1]    &{ExcelPath}[InterestPricing_After_PricingType1]    ${ExcelPath}[FormulaCategory_SpreadType1]
    ...    &{ExcelPath}[FormulaCategory_SpreadValue1]
    Validate Interest Pricing Zoom Details    &{ExcelPath}[InterestPricing_After_PricingItem2]    &{ExcelPath}[InterestPricing_After_PricingType2]    ${ExcelPath}[FormulaCategory_SpreadType2]
    ...    &{ExcelPath}[FormulaCategory_SpreadValue2]
    Validate Interest Pricing Zoom Details    &{ExcelPath}[InterestPricing_After_PricingItem3]    &{ExcelPath}[InterestPricing_After_PricingType3]    ${ExcelPath}[FormulaCategory_SpreadType3]
    ...    &{ExcelPath}[FormulaCategory_SpreadValue3]

    Close All Windows on LIQ