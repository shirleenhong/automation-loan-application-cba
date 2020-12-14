*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Ongoing Fee Setup for DNR
    [Documentation]    This high-level keyword sets up Ongoing Fee from the Deal Notebook.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Facility Notebook - Pricing Tab###
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[OngoingFee_Type1]    &{ExcelPath}[OngoingFee_RateBasis1]
    Modify Ongoing Fee Pricing - Insert After   &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[Facility_PercentWhole]    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[Facility_Percent] 
    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadAmt1]    &{ExcelPath}[Interest_BaseRateCode1]
    
    ###Facility Notebook - Pricing Rules Tab###
    Verify Pricing Rules    &{ExcelPath}[Interest_OptionName1]
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    Close All Windows on LIQ

Setup Fees for Term Facility for DNR
    [Documentation]    Sets up the Ongoing Fees and Interests in a Term Facility for DNR.
    ...    @author: shirhong    04DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    Navigate to Modify Ongoing Fee Window
    Validate Facility Pricing Window    &{ExcelPath}[Facility_Name]    Ongoing Fee
    
    Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[OngoingFee_Type1]    &{ExcelPath}[OngoingFee_RateBasis1]
    ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    ...    &{ExcelPath}[FormulaCategory_Type1]    &{ExcelPath}[OngoingFee_SpreadType1]    &{ExcelPath}[OngoingFee_SpreadAmt1]
      
    Validate Ongoing Fee or Interest
    
    ##Interest Pricing###
    Validate Facility Pricing Window    &{ExcelPath}[Facility_Name]    Interest
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode1]

    Validate Ongoing Fee or Interest
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_OngoingFeeInterest_OK_Button}
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption1]
    
    ###Facility Validation and close###
    Validate Facility
    Close Facility Notebook and Navigator Windows
