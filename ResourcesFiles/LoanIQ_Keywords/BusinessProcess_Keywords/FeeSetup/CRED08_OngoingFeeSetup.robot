*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Fees for Term Facility
    [Documentation]    Sets up the Ongoing Fees and Interests in a Term Facility.
    ...    @author: bernchua
    ...    @update: jdelacru    20FEB2019    - Removed Indemnity Fee Setup
    ...    @update: dahijara    06AUG2020    - Adjusted addition of on going facility to apply commitment fee only for scenario 2 and 5. Commented out extra addition of ongoing fees.
    [Arguments]    ${ExcelPath}
    Navigate to Modify Ongoing Fee Window
    Validate Facility Pricing Window    &{ExcelPath}[Facility_Name]    Ongoing Fee
    
    Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[OngoingFee_Type1]    &{ExcelPath}[OngoingFee_RateBasis1]
    ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    ...    &{ExcelPath}[FormulaCategory_Type1]    &{ExcelPath}[OngoingFee_SpreadType1]    &{ExcelPath}[OngoingFee_SpreadAmt1]
      
    # Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[OngoingFee_Type2]    &{ExcelPath}[OngoingFee_RateBasis1]
    # ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    # ...    &{ExcelPath}[FormulaCategory_Type1]    &{ExcelPath}[OngoingFee_SpreadType1]    &{ExcelPath}[OngoingFee_SpreadAmt1]
    # Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category2]    &{ExcelPath}[OngoingFee_Type3]    &{ExcelPath}[OngoingFee_RateBasis1]
    # ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    # ...    &{ExcelPath}[FormulaCategory_Type1]    &{ExcelPath}[OngoingFee_SpreadType1]    &{ExcelPath}[OngoingFee_SpreadAmt1]
    # Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category2]    &{ExcelPath}[OngoingFee_Type4]    &{ExcelPath}[OngoingFee_RateBasis1]
    # ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    # ...    &{ExcelPath}[FormulaCategory_Type1]    &{ExcelPath}[OngoingFee_SpreadType1]    &{ExcelPath}[OngoingFee_SpreadAmt1]
    Validate Ongoing Fee or Interest
    
    ##Interest Pricing###
    Validate Facility Pricing Window    &{ExcelPath}[Facility_Name]    Interest
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue2]    &{ExcelPath}[Interest_BaseRateCode2]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName3]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode3]
    Validate Ongoing Fee or Interest
    mx LoanIQ click element if present    ${LIQ_FacilityPricing_OngoingFeeInterest_OK_Button}
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption1]
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption2]
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption3]
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption4]
    
    ###Facility Validation and close###
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}

Setup Ongoing Fees for Multi-Currency and Multi-Risk Revolver Facility
    [Documentation]    Sets up the Ongoing Fees for Multi-Currency and Multi-Risk Revolver Facility.
    ...    @author: ritragel
    ...    @update: rtarayao    04MAR2019    Updated comments and low-level keywords used.
    [Arguments]    ${ExcelPath1}
    
    ###Read Data to be Used###
    ${Category}    Read Data From Excel    CRED08_RevFacilityOngoingFee    OngoingFee_Category    ${rowid}    ${ExcelPath}    Y
    ${FeeType}    Read Data From Excel    CRED08_RevFacilityOngoingFee    OngoingFee_Type    ${rowid}    ${ExcelPath}    Y
    ${RateBasis}    Read Data From Excel    CRED08_RevFacilityOngoingFee    OngoingFee_RateBasis    ${rowid}    ${ExcelPath}    Y
    ${FeeAfterItem}    Read Data From Excel    CRED08_RevFacilityOngoingFee    OngoingFee_AfterItem    ${rowid}    ${ExcelPath}    Y
    ${FeeAfterItemType}    Read Data From Excel    CRED08_RevFacilityOngoingFee    OngoingFee_AfterItem_Type    ${rowid}    ${ExcelPath}    Y
    ${FormulaCategoryType}    Read Data From Excel    CRED08_RevFacilityOngoingFee    FormulaCategory_Type    ${rowid}    ${ExcelPath}    Y
    ${SpreadType}    Read Data From Excel    CRED08_RevFacilityOngoingFee    OngoingFee_SpreadType    ${rowid}    ${ExcelPath}    Y
    ${SpreadAmt}    Read Data From Excel    CRED08_RevFacilityOngoingFee    OngoingFee_SpreadAmt    ${rowid}    ${ExcelPath}    Y
    
    ###Facility Notebook - Pricing Tab###
    Navigate to Ongoing Fee Pricing Window
    Validate Facility Pricing Window    &{ExcelPath1}[Facility_Name]    Ongoing Fee
    Add Facility Ongoing Fees    @{Category}[0]    @{FeeType}[0]    @{RateBasis}[0]    @{FeeAfterItem}[0]
    ...    @{FeeAfterItemType}[0]    @{FormulaCategoryType}[0]    @{SpreadType}[0]    @{SpreadAmt}[0]
    Add Facility Ongoing Fees    @{Category}[1]    @{FeeType}[1]    @{RateBasis}[1]    @{FeeAfterItem}[1]
    ...    @{FeeAfterItemType}[1]    @{FormulaCategoryType}[1]    @{SpreadType}[1]    @{SpreadAmt}[1]
    Add Facility Ongoing Fees    @{Category}[2]    @{FeeType}[2]    @{RateBasis}[2]    @{FeeAfterItem}[2]
    ...    @{FeeAfterItemType}[2]    @{FormulaCategoryType}[2]    @{SpreadType}[2]    @{SpreadAmt}[2]
    Validate Ongoing Fee or Interest
  
    ###Facility Notebook - Pricing Tab (Ongoing Fee Validations)###
    Validate Facility Pricing Items    @{Category}[0]    
    Validate Facility Pricing Items    @{FeeType}[0]
    Validate Facility Pricing Items    @{SpreadAmt}[0]    @{SpreadType}[0]
    Validate Facility Pricing Items    @{Category}[1]    
    Validate Facility Pricing Items    @{FeeType}[1]
    Validate Facility Pricing Items    @{SpreadAmt}[1]    @{SpreadType}[1]
    Validate Facility Pricing Items    @{Category}[2]    
    Validate Facility Pricing Items    @{FeeType}[2]
    Validate Facility Pricing Items    @{SpreadAmt}[2]    @{SpreadType}[2]
    
    ###Close existing Facility Notebook and Navigator windows###
    Close Facility Notebook and Navigator Windows

Setup Interest Pricing Fees for Multi-Currency and Multi-Risk Revolver Facility
    [Documentation]    Sets up the Interest Fees for Multi-Currency and Multi-Risk Revolver Facility.
    ...    @author: rtarayao    04MAR2019    Initial create
    [Arguments]    ${ExcelPath}
    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadValue]    &{ExcelPath}[Interest_BaseRateCode]    &{ExcelPath}[Interest_PricingFormula]   
    
Setup Ongoing Fees for Multi-Currency and Multi-Risk Term Facility
    [Documentation]    Sets up the Ongoing Fees and Interests in a Term Facility.
    ...    @author: ritragel
    ...    @update: rtarayao    06MAR2019    Updated read and write of data, comments 
    [Arguments]    ${ExcelPath1}
    
    ###Read Data to be Used###
    ${Category}    Read Data From Excel    CRED08_TermFacilityOngoingFee    OngoingFee_Category    ${rowid}    ${ExcelPath}    Y
    ${FeeType}    Read Data From Excel    CRED08_TermFacilityOngoingFee    OngoingFee_Type    ${rowid}    ${ExcelPath}    Y
    ${RateBasis}    Read Data From Excel    CRED08_TermFacilityOngoingFee    OngoingFee_RateBasis    ${rowid}    ${ExcelPath}    Y
    ${FeeAfterItem}    Read Data From Excel    CRED08_TermFacilityOngoingFee    OngoingFee_AfterItem    ${rowid}    ${ExcelPath}    Y
    ${FeeAfterItemType}    Read Data From Excel    CRED08_TermFacilityOngoingFee    OngoingFee_AfterItem_Type    ${rowid}    ${ExcelPath}    Y
    ${FormulaCategoryType}    Read Data From Excel    CRED08_TermFacilityOngoingFee    FormulaCategory_Type    ${rowid}    ${ExcelPath}    Y
    ${SpreadType}    Read Data From Excel    CRED08_TermFacilityOngoingFee    OngoingFee_SpreadType    ${rowid}    ${ExcelPath}    Y
    ${SpreadAmt}    Read Data From Excel    CRED08_TermFacilityOngoingFee    OngoingFee_SpreadAmt    ${rowid}    ${ExcelPath}    Y
    
    ###Facility Notebook - Pricing Tab###
    Navigate to Ongoing Fee Pricing Window
    Validate Facility Pricing Window    &{ExcelPath1}[Facility2_Name]    Ongoing Fee
    Add Facility Ongoing Fees    @{Category}[0]    @{FeeType}[0]    @{RateBasis}[0]    @{FeeAfterItem}[0]
    ...    @{FeeAfterItemType}[0]    @{FormulaCategoryType}[0]    @{SpreadType}[0]    @{SpreadAmt}[0]
    Add Facility Ongoing Fees    @{Category}[1]    @{FeeType}[1]    @{RateBasis}[1]    @{FeeAfterItem}[1]
    ...    @{FeeAfterItemType}[1]    @{FormulaCategoryType}[1]    @{SpreadType}[1]    @{SpreadAmt}[1]
    Validate Ongoing Fee or Interest
    Write Data To Excel    SERV29_PaymentFees    Fee_Type1    ${rowid}    @{FeeType}[1]
    Write Data To Excel    MTAM06B_CycleShareAdjustment    OngoingFee_Type    ${rowid}    @{FeeType}[1]
    Write Data To Excel    MTAM05B_CycleShareAdjustment    OngoingFee_Type    ${rowid}    @{FeeType}[1]
  
    ###Facility Notebook - Pricing Tab (Ongoing Fee Validations)###
    Validate Facility Pricing Items    @{Category}[0]    
    Validate Facility Pricing Items    @{FeeType}[0]
    Validate Facility Pricing Items    @{SpreadAmt}[0]    @{SpreadType}[0]
    Validate Facility Pricing Items    @{Category}[1]    
    Validate Facility Pricing Items    @{FeeType}[1]
    Validate Facility Pricing Items    @{SpreadAmt}[1]    @{SpreadType}[1]
    
    ###Close existing Facility Notebook an Navigator windows###
    Close Facility Notebook and Navigator Windows

Setup Interest Pricing Fees for Multi-Currency and Multi-Risk Term Facility
    [Documentation]    Sets up the Interest Fees for Multi-Currency and Multi-Risk Term Facility.
    ...    @author: rtarayao    04MAR2019    Initial create
    [Arguments]    ${ExcelPath}
    ###Facility Notebook - Pricing Tab (Add Interest Pricing)###
    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadValue]    &{ExcelPath}[Interest_BaseRateCode]    &{ExcelPath}[Interest_PricingFormula]   
     

NonAgent-HostBank Syndicated Deal - Setup Revolver Facility Fees and Interest
    [Documentation]    This keyword set ups the Ongoing Fees and Interest Pricing for the Non Agent and Host Bank Syndicated Deal.
    ...    @author: bernchua
    ...    @update: clanding    29JUL2020    - updated hard coded values to global variables; removed mx keywords
    [Arguments]    ${ExcelPath}
    
    #### Ongoing Fee ####
    Go to Modify Ongoing Fee    
    Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[OngoingFee_Type1]    &{ExcelPath}[OngoingFee_RateBasis1]
    ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    ...    &{ExcelPath}[FormulaCategory_Type1]    &{ExcelPath}[OngoingFee_SpreadType1]    &{ExcelPath}[OngoingFee_SpreadAmt1]
    Validate Ongoing Fee or Interest
    
    #### Interest Pricing ###
    Click Modify Interest Pricing Button
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    ${OFF}    &{ExcelPath}[Greater_Than]    &{ExcelPath}[Less_Than]    &{ExcelPath}[FinancialRatio_Minimum1]    &{ExcelPath}[FinancialRatio_Maximum1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode2]
    
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    ${OFF}    &{ExcelPath}[Greater_Than]    &{ExcelPath}[Less_Than]    &{ExcelPath}[FinancialRatio_Minimum2]    &{ExcelPath}[FinancialRatio_Maximum2]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue2]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue2]    &{ExcelPath}[Interest_BaseRateCode2]
    
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    ${OFF}    &{ExcelPath}[Greater_Than]    &{ExcelPath}[Less_Than]    &{ExcelPath}[FinancialRatio_Minimum3]    &{ExcelPath}[FinancialRatio_Maximum3]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue3]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue3]    &{ExcelPath}[Interest_BaseRateCode2]
    
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    ${ON}    &{ExcelPath}[Greater_Than]    &{ExcelPath}[Less_Than]    &{ExcelPath}[FinancialRatio_Minimum4]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue4]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue4]    &{ExcelPath}[Interest_BaseRateCode2]
    
    Validate Ongoing Fee or Interest
    
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption1]
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption2]
    
    #### Get Dates from Facility Notebook Summary Tab and Write to Primaries Syndication Trade/Expiry Date and Deal Approval/Close Date.
    ${EffectiveDate}    ${ExpiryDate}    Get Effective and Expiry Date from Summary Tab in Facility Notebook
    Write Data To Excel    SYND02_Primary_Allocation    TradeDate    &{ExcelPath}[rowid]    ${EffectiveDate}
    Write Data To Excel    SYND02_Primary_Allocation    Expiry_Date    &{ExcelPath}[rowid]    ${Expiry_Date}
    Write Data To Excel    CRED01_DealSetup    ApproveDate    &{ExcelPath}[rowid]    ${EffectiveDate}
    Write Data To Excel    CRED01_DealSetup    CloseDate    &{ExcelPath}[rowid]    ${EffectiveDate}
    
    #### Facility Validation and close.
    Validate Facility
    Close Facility Navigator Window
    
Setup Fees and Interest for Term Facility
    [Documentation]    This keyword set ups the Ongoing Fees and Interest Pricing for a Syndicated Deal with no Lenders.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    
    # Ongoing Fee
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[OngoingFee_Type1]    &{ExcelPath}[OngoingFee_RateBasis1]
    ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    ...    &{ExcelPath}[FormulaCategory_Type1]    &{ExcelPath}[OngoingFee_SpreadType1]    &{ExcelPath}[OngoingFee_SpreadAmt1]
    Validate Ongoing Fee or Interest
    
    # Interest Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    OFF    0    1    &{ExcelPath}[FinancialRatio_Minimum1]    &{ExcelPath}[FinancialRatio_Maximum1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue3]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue3]    &{ExcelPath}[Interest_BaseRateCode2]
    mx LoanIQ click    ${LIQ_FacilityPricing_Interest_OptionCondition_Cancel_Button}
    
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    OFF    0    1    &{ExcelPath}[FinancialRatio_Minimum2]    &{ExcelPath}[FinancialRatio_Maximum2]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue2]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue2]    &{ExcelPath}[Interest_BaseRateCode2]
    mx LoanIQ click    ${LIQ_FacilityPricing_Interest_OptionCondition_Cancel_Button}
    
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    ON    0    1    &{ExcelPath}[FinancialRatio_Minimum3]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue1]    &{ExcelPath}[Interest_BaseRateCode2]
    mx LoanIQ click    ${LIQ_FacilityPricing_Interest_OptionCondition_Cancel_Button}
    
    Validate Ongoing Fee or Interest
    
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption1]
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption2]
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption3]
    
    # Facility Validation and close.
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    
Setup Fees and Interest for Revolver Facility
    [Documentation]    This keyword set ups the Ongoing Fees and Interest Pricing for a Syndicated Deal with no Lenders.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    
    ### Ongoing Fee
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Add Facility Ongoing Fees    &{ExcelPath}[OngoingFee_Category1]    &{ExcelPath}[OngoingFee_Type1]    &{ExcelPath}[OngoingFee_RateBasis1]
    ...    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    ...    &{ExcelPath}[FormulaCategory_Type1]    &{ExcelPath}[OngoingFee_SpreadType1]    &{ExcelPath}[OngoingFee_SpreadAmt2]
    Validate Ongoing Fee or Interest
    
    ### Interest Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyInterestPricing_Button}
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    OFF    0    1    &{ExcelPath}[FinancialRatio_Minimum1]    &{ExcelPath}[FinancialRatio_Maximum1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue2]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue2]    &{ExcelPath}[Interest_BaseRateCode2]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName3]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue2]    &{ExcelPath}[Interest_BaseRateCode3]
    
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    OFF    0    1    &{ExcelPath}[FinancialRatio_Minimum2]    &{ExcelPath}[FinancialRatio_Maximum2]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue3]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue3]    &{ExcelPath}[Interest_BaseRateCode2]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName3]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue3]    &{ExcelPath}[Interest_BaseRateCode3]
    
    Add Interest Pricing Financial Ratio
    Set Financial Ratio    &{ExcelPath}[Interest_FinancialRatioType1]    ON    0    1    &{ExcelPath}[FinancialRatio_Minimum3]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue4]    &{ExcelPath}[Interest_BaseRateCode1]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue4]    &{ExcelPath}[Interest_BaseRateCode2]
    Add Facility Interest    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName3]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Interest_SpreadType1]    &{ExcelPath}[Interest_SpreadValue4]    &{ExcelPath}[Interest_BaseRateCode3]
    
    Validate Ongoing Fee or Interest
    
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption1]
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption2]
    Validate Facility Pricing Rule Items    &{ExcelPath}[Facility_PricingRuleOption3]
    
    ### Facility Validation and close.
    Validate Facility
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}    
       
Ongoing Fee Setup
    [Documentation]    This high-level keyword sets up Ongoing Fee from the Deal Notebook.
    ...    @author: fmamaril
    ...    @update: makcamps    15OCT2020    - added closing of all LIQ windows to coordinate w/ next tc
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
