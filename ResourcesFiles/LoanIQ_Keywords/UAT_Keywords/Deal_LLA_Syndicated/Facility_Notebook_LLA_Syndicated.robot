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
	Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name    ${rowid}    ${FacilityName}
	Set To Dictionary    ${ExcelPath}    Facility_Name=${FacilityName}
	
	###Add Revolver Facility###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Facility_Name]
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Date Settings##
    ${SystemDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${SystemDate}    &{ExcelPath}[Add_To_Facility_ExpiryDate]
    ${Facility_MaturityDate}    Add Days to Date    ${SystemDate}    &{ExcelPath}[Add_To_Facility_MaturityDate]
    ${Primary_PortfolioExpiryDate}    Add Days to Date    ${SystemDate}    1
	Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
	Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate}
	Write Data To Excel    SYND02_PrimaryAllocation    Primary_PortfolioExpiryDate    ${rowid}    ${Primary_PortfolioExpiryDate}
    Set Facility Dates    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    ${Facility_ExpiryDate}    ${Facility_MaturityDate}    
    
    ###Facility Notebook - Types/Purpose###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType]
    
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ###Facility Notebook - Restrictions###
    Add Facility Currency    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Sublimit/Cust###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]
    
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
    Modify Ongoing Fee Pricing - Insert After Matrix of External Rating    &{ExcelPath}[FacilityItemAfter]    &{ExcelPath}[Facility_Percent1]
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
    Modify Ongoing Fee Pricing - Insert After Matrix of External Rating    &{ExcelPath}[FacilityItemAfter]    &{ExcelPath}[Facility_Percent2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition2]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType3]
    ...    &{ExcelPath}[MaxType4]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType5]
    ...    &{ExcelPath}[MaxType3]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Ongoing Fee Pricing - Insert After Matrix of External Rating    &{ExcelPath}[FacilityItemAfter]    &{ExcelPath}[Facility_Percent3]    
    Confirm Facility Ongoing Fee Pricing Options Settings
    
    Verify If Text Value Exist as Java Tree on Page    Facility -    &{ExcelPath}[Facility_PercentWhole1]
    Verify If Text Value Exist as Java Tree on Page    Facility -    &{ExcelPath}[Facility_PercentWhole2]
    Verify If Text Value Exist as Java Tree on Page    Facility -    &{ExcelPath}[Facility_PercentWhole3]
    Verify If Text Value Exist as Java Tree on Page    Facility -    &{ExcelPath}[FacilityItem]
    
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
    Modify Interest Pricing - Insert After Matrix of External Rating    &{ExcelPath}[InterestPricingItem]    &{ExcelPath}[OptionName]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[FormulaText]    &{ExcelPath}[Spread1]
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
    Modify Interest Pricing - Insert After Matrix of External Rating    &{ExcelPath}[InterestPricingItem]    &{ExcelPath}[OptionName]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[FormulaText]    &{ExcelPath}[Spread2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition2]    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[MinType3]
    ...    &{ExcelPath}[MaxType4]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]
    Modify Interest Pricing - Insert Matrix of External Rating    &{ExcelPath}[Condition3]    &{ExcelPath}[ExternalRatingType1]    &{ExcelPath}[MinType5]
    ...    &{ExcelPath}[MaxType3]    &{ExcelPath}[MinValue2]    &{ExcelPath}[MaxValue2]    
    Modify Interest Pricing - Insert After Matrix of External Rating    &{ExcelPath}[InterestPricingItem]    &{ExcelPath}[OptionName]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[FormulaText]    &{ExcelPath}[Spread3]    
    Confirm Facility Interest Pricing Options Settings
    
    Verify If Text Value Exist as Java Tree on Page    Facility -    &{ExcelPath}[Code]
    