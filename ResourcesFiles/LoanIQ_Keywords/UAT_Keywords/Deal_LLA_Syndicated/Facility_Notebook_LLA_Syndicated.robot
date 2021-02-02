*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Revolver Facility for LLA Syndicated Deal
    [Documentation]    This high-level keyword is used to create an initial set up of Revolver Facility for LLA Syndicated Deal
    ...    @author: makcamps    04JAN2021    - Initial Create
    ...    @update: makcamps    15JAN2021    - updated data used for dates to follow dates from screenshots provided
    ...    @update: makcamps    20JAN2021    - added write method for notice
    ...    @update: makcamps    02FEB2021    - fixed arguments for Add Arguments
    [Arguments]    ${ExcelPath}
    
    ###Test Data Generation and Writings###
	${FacilityName}    Generate Facility Name with 5 Numeric Test Data    &{ExcelPath}[Facility_NamePrefix]
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name    ${rowid}    ${FacilityName}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${FacilityName}
    Write Data To Excel    Correspondence    Facility_Name    ${rowid}    ${FacilityName}    multipleValue=Y    bTestCaseColumn=True    sColumnReference=rowid
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
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]
    ...    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]
    
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

Update Facility Expiry and Maturity Date Through FCT
    [Documentation]    This keyword is used to update Facility's Expiry and Maturity Date.
    ...    @author: makcamps    28JAN2021    - Initial create
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Facility Notebook ###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ### Navigate to Facility Change Transaction ###
    Add Facility Change Transaction
    Update Facility Details    Expiry Date    &{ExcelPath}[New_ExpiryDate]
    Update Facility Details    Maturity Date    &{ExcelPath}[New_MaturityDate]
    Send to Approval Facility Change Transaction
    
    ### Approve Facility Change Transaction Notebook ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Approve Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    ### Release Facility Change Transaction Notebook ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Release Facility Change Transaction    &{ExcelPath}[Deal_Name]
    
    ### Validate Changes in Facility Notebook ###
    Validate Facility Change Transaction    &{ExcelPath}[New_MaturityDate]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[New_ExpiryDate]
    Close All Windows on LIQ

Update Borrowers External Credit Rating History
    [Documentation]    This keyword is used to update Borrower's External Credit Rating History
    ...    @author: makcamps    28JAN2021    - Initial create
    [Arguments]    ${ExcelPath}

    ${Party_ID}    Read Data From Excel    PTY001_QuickPartyOnboarding    Party_ID    ${rowid}
    
    ### Login Loan IQ ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Navigate to Customer ###
    Navigate to Customer Notebook via Customer ID    ${Party_ID}
    
    ### Navigate to Facility Notebook ###
    Switch Customer Notebook to Update Mode
    Update External Risk Rating Table    &{ExcelPath}[ExternalRatingType2]    &{ExcelPath}[RatingType]    &{ExcelPath}[MinType4]    &{ExcelPath}[New_StartDate]
    
    ### Validate External Risk Rating Changes ###
    Validate External Risk Rating Table    &{ExcelPath}[RatingType2]    &{ExcelPath}[MinType4]    &{ExcelPath}[New_StartDate]
    Validate Change of External Rating Event
    
Create PCT for Pricing Matrix
    [Documentation]    This keyword is used to update Borrower's External Credit Rating History
    ...    @author: makcamps    28JAN2021    - Initial create
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Facility Notebook ###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    
    ### Navigate to PCT Menu ###
    Navigate to Pricing Change Transaction Menu
    
    ### Navigate to PCT Menu ###
    Input Pricing Change Transaction General Information    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[PricingChange_TransactionNo]    &{ExcelPath}[PricingChange_EffectiveDate]    &{ExcelPath}[PricingChange_Desc]
    
    ### Modify Ongoing Fee Pricing ###
    Navigate to Modify Ongoing Fees Window from PCT Notebook
    Modify Ongoing Fees from PCT Notebook    &{ExcelPath}[PricingChange_OngoingFeeStr]    &{ExcelPath}[CurrentGlobalRate1]    &{ExcelPath}[OngoingFeePercent1]    &{ExcelPath}[GlobalCurrentRate1]
    Modify Ongoing Fees from PCT Notebook    &{ExcelPath}[PricingChange_OngoingFeeStr]    &{ExcelPath}[CurrentGlobalRate2]    &{ExcelPath}[OngoingFeePercent2]    &{ExcelPath}[GlobalCurrentRate2]
    Modify Ongoing Fees from PCT Notebook    &{ExcelPath}[PricingChange_OngoingFeeStr]    &{ExcelPath}[CurrentGlobalRate3]    &{ExcelPath}[OngoingFeePercent3]    &{ExcelPath}[GlobalCurrentRate3]
    Mx LoanIQ Click    ${LIQ_PricingChangeTransaction_OngoingFees_OK_Button}
    
    ### Modify Interest Pricing ###
    Navigate to PCT Existing Interest Pricing
    Update Existing Interest Pricing via PCT    7    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Computation]    &{ExcelPath}[PricingCode]
    ...    &{ExcelPath}[PricingPercent]    &{ExcelPath}[Interest_CurrentSpread1]    &{ExcelPath}[Interest_NewSpread1]
    Update Existing Interest Pricing via PCT    15    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Computation]    &{ExcelPath}[PricingCode]
    ...    &{ExcelPath}[PricingPercent]    &{ExcelPath}[Interest_CurrentSpread2]    &{ExcelPath}[Interest_NewSpread2]
    Update Existing Interest Pricing via PCT    19    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Computation]    &{ExcelPath}[PricingCode]
    ...    &{ExcelPath}[PricingPercent]    &{ExcelPath}[Interest_CurrentSpread3]    &{ExcelPath}[Interest_NewSpread3]
    Click OK Button in Interest Pricing Window
    
    ##Send to Approval##
    Select Pricing Change Transaction Send to Approval
    Logout from Loan IQ

    ##Approver Supervisor##
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Pricing Change Transaction Menu
    Approve Price Change Transaction
    Logout from Loan IQ

    ##Approver Manager##
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Facilities    Awaiting Release    Pricing Change Transaction     &{ExcelPath}[Facility_Name]
    Select Pricing Change Transaction Release
    
    ##Verify Events##
    Select Events Tab then Verify the Events    &{ExcelPath}[Created_Event]    &{ExcelPath}[OngoingFeePricingChanged_Event]
    Close the Pricing Change Transaction Window
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}