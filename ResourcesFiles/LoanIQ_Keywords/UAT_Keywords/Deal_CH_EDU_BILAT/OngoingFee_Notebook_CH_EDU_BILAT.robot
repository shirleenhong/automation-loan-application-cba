*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***
Setup Commitment Fee for CH EDU Bilateral Deal
    [Documentation]    This high-level keyword sets up Commitment Fee for CH EDU Bilateral Deal.
    ...    @author: dahijara    04DEC2020    - Initial create
    [Arguments]    ${ExcelPath}

    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    &{ExcelPath}[rowid]
    ${Borrower_SGName}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid]
    ${Borrower_SG_GroupMembers}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_GroupMembers    &{ExcelPath}[rowid]
    ${Borrower_SG_Method}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_PreferredRIMthd    &{ExcelPath}[rowid]

    ###Facility Notebook - Pricing Tab###
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]
    
    Modify Ongoing Fee Pricing - Insert After   &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[Facility_PercentWhole]    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[Facility_Percent]

    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadAmt]    &{ExcelPath}[Interest_BaseRateCode]

    ### Ongoing Fee - Update Details ###
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    Update Ongoing Fee General Information    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[OngoingFee_AccrualEndDate]

    Update Fee Paid By and Servicing Group for Ongoing Fee    ${Borrower_ShortName}    ${Borrower_Location}    ${Borrower_SGName}    ${Borrower_SG_GroupMembers}    ${Borrower_SG_Method}

    Save and Close Ongoing Fee Window

    Close All Windows on LIQ

Setup Line Fee in Arrears for CH EDU Bilateral Deal
    [Documentation]    This high-level keyword sets up Commitment Fee for CH EDU Bilateral Deal.
    ...    @author: dahijara    07DEC2020    - Initial create
    [Arguments]    ${ExcelPath}

    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    &{ExcelPath}[rowid]
    ${Borrower_SGName}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid]
    ${Borrower_SG_GroupMembers}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_GroupMembers    &{ExcelPath}[rowid]
    ${Borrower_SG_Method}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_PreferredRIMthd    &{ExcelPath}[rowid]

    ### Ongoing Fee Pricing ###
    Navigate to Modify Ongoing Fee Window
    Add Facility Ongoing Fee - Matrix    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]

    Set Financial Ratio    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[FinancialRatio_MnemonicStatus1]    &{ExcelPath}[FinancialRatio_GreaterThan1]    &{ExcelPath}[FinancialRatio_LessThan1]    &{ExcelPath}[FinancialRatio_MinimumValue1]    &{ExcelPath}[FinancialRatio_MaximumValue1]

    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[OngoingFee_AfterItem1]    &{ExcelPath}[OngoingFee_AfterItemType1]

    Set Formula Category For Fees    &{ExcelPath}[FormulaCategory_Type]    &{ExcelPath}[Facility_Percent1]    &{ExcelPath}[FormulaCategory_SpreadType1]

    Add Facility Matrix to Ongoing Fee or Interest Pricing with Existing Matrix For Facility Pricing    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]

    Set Financial Ratio    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[FinancialRatio_MnemonicStatus2]    &{ExcelPath}[FinancialRatio_GreaterThan2]    &{ExcelPath}[FinancialRatio_LessThan2]    &{ExcelPath}[FinancialRatio_MinimumValue2]    &{ExcelPath}[FinancialRatio_MaximumValue2]

    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[OngoingFee_AfterItem2]    &{ExcelPath}[OngoingFee_AfterItemType2]

    Set Formula Category For Fees    &{ExcelPath}[FormulaCategory_Type]    &{ExcelPath}[Facility_Percent2]    &{ExcelPath}[FormulaCategory_SpreadType2]

    Validate Ongoing Fee or Interest

    ### Interest Pricing ###
    Navigate to Facitily Interest Pricing Window

    Add Item to Ongoing Fee or Interest Pricing For Facility Pricing    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]

    Set Financial Ratio    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[Interest_FinancialRatio_MnemonicStatus1]    &{ExcelPath}[Interest_FinancialRatio_GreaterThan1]    &{ExcelPath}[Interest_FinancialRatio_LessThan1]    &{ExcelPath}[Interest_FinancialRatio_MinimumValue1]    &{ExcelPath}[Interest_FinancialRatio_MaximumValue1]

    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[Interest_AfterItem1]    &{ExcelPath}[Interest_AfterItemType1]

    Add After Option Item - Second    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_Facility_Percent1]    sFormulaText=&{ExcelPath}[Interest_FormulaText1]

    Add Facility Matrix to Ongoing Fee or Interest Pricing with Existing Matrix For Facility Pricing    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]

    Set Financial Ratio    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[Interest_FinancialRatio_MnemonicStatus2]    &{ExcelPath}[Interest_FinancialRatio_GreaterThan2]    &{ExcelPath}[Interest_FinancialRatio_LessThan2]    &{ExcelPath}[Interest_FinancialRatio_MinimumValue2]    &{ExcelPath}[Interest_FinancialRatio_MaximumValue2]

    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[Interest_AfterItem2]    &{ExcelPath}[Interest_AfterItemType2]

    Add After Option Item - Second    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis2]    &{ExcelPath}[Interest_Facility_Percent2]    sFormulaText=&{ExcelPath}[Interest_FormulaText2]

    Validate Ongoing Fee or Interest

    ### Ongoing Fee - Update Details ###
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    Update Ongoing Fee General Information    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[OngoingFee_AccrualEndDate]

    Update Fee Paid By and Servicing Group for Ongoing Fee    ${Borrower_ShortName}    ${Borrower_Location}    ${Borrower_SGName}    ${Borrower_SG_GroupMembers}    ${Borrower_SG_Method}

    Save and Close Ongoing Fee Window

    Close All Windows on LIQ