*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***    
Setup Fees For SBLC Facility
    [Documentation]    Sets up the Ongoing Fees and Interests for SBLC Facility.
    ...    @author: bernchua
    ...    @update: jdelacru    11APR19    Used Mx Click Element If Present in clicking LIQ_FacilityPricing_OngoingFeeInterest_OK_Button
    ...    @update: clanding    16JUL2020    - removed commented duplicate codes for Add Facility Ongoing Fees and Validate Facility Pricing Items
    [Arguments]    ${ExcelPath}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Validate Facility Pricing Window    &{ExcelPath}[Facility_Name]    Ongoing Fee
    Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[OngoingFee_Type1]    &{ExcelPath}[OngoingFee_RateBasis1]
    ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    ...    &{ExcelPath}[FormulaCategory_Type1]    &{ExcelPath}[OngoingFee_SpreadType1]    &{ExcelPath}[OngoingFee_SpreadAmt1]
    
    Validate Ongoing Fee or Interest
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_OngoingFeeInterest_OK_Button}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Validate Facility Pricing Items    &{ExcelPath}[OngoingFee_Category1]
    Validate Facility Pricing Items    &{ExcelPath}[OngoingFee_Type1]
    Validate Facility Pricing Items    &{ExcelPath}[OngoingFee_SpreadAmt1]    &{ExcelPath}[OngoingFee_SpreadType1]
    
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    Validate Facility Pricing Window    &{ExcelPath}[Facility_Name]    Interest
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode1]
    Validate Ongoing Fee or Interest
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_OngoingFeeInterest_OK_Button}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Validate Facility Pricing Items    &{ExcelPath}[Interest_OptionName1]
    Validate Facility Pricing Items    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_BaseRateCode1]
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_Interest_OptionCondition_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Facility_InterestPricing_FormulaCategory_Cancel_Button}
    
Setup Multi-Currency SBLC Facility
    [Documentation]    Sets up a multi-currency SBLC Facility.
    ...    @update    04APR19    Deleted commented codes
    ...    @update    10OCT2019    Change the column where Facility Currency Code will be retrieved, from Facility_CurrencyABR1 to Facility_CurrencyCode1
    ...    @update: ehugo    29MAY2020    - moved writing of facility data from 'Create Deal - Baseline SBLC'
    ...    @update: ehugo    01JUN2020    - moved keyword from 'CRED01_DealSetUpWithoutOrigination.robot' to 'CRED02_SBLCGuaranteeSetUp.robot'
    ...    @update: clanding    16JUL2020    - updated sheet name from CRED08_FacilityFeeSetup to CRED08_OngoingFeeSetup; added writing of Facility_ExpiryDate
    ...                                      - updated &{ExcelPath}[Facility_Name] to ${FacilityName}
    ...    @update: clanding    20JUL2020    - added writing of Facility_ExpiryDate to SERV05_SBLCIssuance
    ...    @update: clanding    23JUL2020    - updated hardcoded values to dataset input
    [Arguments]    ${ExcelPath}

    ${FacilityName}    Generate Facility Name    &{ExcelPath}[Facility_NamePrefix]
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    CRED01_DealSetup    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    SERV05_SBLCIssuance    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    MTAM05A_CycleShareAdjustment    Facility_Name    ${rowid}   ${FacilityName}
	Write Data To Excel    SERV05_SBLCDecrease    Facility_Name    ${rowid}   ${FacilityName}

	:FOR    ${i}    IN RANGE    3
    \    ${DealNotebook_Exist}    Run Keyword And Return Status    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    \    Exit For Loop If    ${DealNotebook_Exist}==True
    
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    &{ExcelPath}[Facility_AddToExpiryDate]
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    &{ExcelPath}[Facility_AddToMaturityDate] 
    
    Write Data To Excel    CRED01_DealSetup    Primary_PortfolioExpiryDate    ${rowid}   ${Facility_ExpiryDate}
    Write Data To Excel    SERV05_SBLCIssuance    Expiry_Date    ${rowid}   ${Facility_ExpiryDate}
	
	Refresh Tables in LIQ
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