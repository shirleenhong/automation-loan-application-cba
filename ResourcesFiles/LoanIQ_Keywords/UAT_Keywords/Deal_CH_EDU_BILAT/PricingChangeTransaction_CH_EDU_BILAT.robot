*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Update Ongoing Fee and Interest Fee Pricing for CH EDU Bilateral Deal
    [Documentation]    The keyword will Update Ongoing Fee and Interest Fee Pricing for CH EDU Bilateral Deal
    ...    @author: dahijara    15FEB2021    - Initial create
    [Arguments]    ${ExcelPath}

    ### Read Excel Data ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${Facility_Name}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1

    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Update Ongoing Fee and Interest Pricing ###
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Pricing Change Transaction Menu
    Input Pricing Change Transaction General Information    ${Deal_Name}    ${Facility_Name}    &{ExcelPath}[PricingChange_TransactionNo]    &{ExcelPath}[PricingChange_EffectiveDate]    &{ExcelPath}[PricingChange_Desc]

    ### Ongoing Fee Pricing ###
    Navigate to Modify Ongoing Fees Window from PCT Notebook

    Clear Ongoing Fee Pricing Current Values
    
    Add Facility Ongoing Fee - Matrix for Pricing Change Transaction    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]

    Set Financial Ratio for Pricing Change Transaction    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[FinancialRatio_MnemonicStatus1]    &{ExcelPath}[FinancialRatio_GreaterThan1]    &{ExcelPath}[FinancialRatio_LessThan1]    &{ExcelPath}[FinancialRatio_MinimumValue1]    &{ExcelPath}[FinancialRatio_MaximumValue1]

    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[OngoingFee_AfterItem1]    &{ExcelPath}[OngoingFee_AfterItemType1]

    Set Formula Category For Fees    &{ExcelPath}[FormulaCategory_Type]    &{ExcelPath}[Facility_Percent1]    &{ExcelPath}[FormulaCategory_SpreadType1]

    Add Facility Matrix to Ongoing Fee or Interest Pricing with Existing Matrix for Pricing Change Transaction    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]

    Set Financial Ratio for Pricing Change Transaction    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[FinancialRatio_MnemonicStatus2]    &{ExcelPath}[FinancialRatio_GreaterThan2]    &{ExcelPath}[FinancialRatio_LessThan2]    &{ExcelPath}[FinancialRatio_MinimumValue2]    &{ExcelPath}[FinancialRatio_MaximumValue2]

    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[OngoingFee_AfterItem2]    &{ExcelPath}[OngoingFee_AfterItemType2]

    Set Formula Category For Fees    &{ExcelPath}[FormulaCategory_Type]    &{ExcelPath}[Facility_Percent2]    &{ExcelPath}[FormulaCategory_SpreadType2]

    Validate Ongoing Fee or Interest

    Click OK Button in Ongoing Fees Window

    ### Interest Pricing ###
    Navigate to PCT Existing Interest Pricing

    Clear Pricing Window Current Values

    Add Item to Ongoing Fee or Interest Pricing for Pricing Change Transaction    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]

    Set Financial Ratio for Pricing Change Transaction    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[Interest_FinancialRatio_MnemonicStatus1]    &{ExcelPath}[Interest_FinancialRatio_GreaterThan1]    &{ExcelPath}[Interest_FinancialRatio_LessThan1]    &{ExcelPath}[Interest_FinancialRatio_MinimumValue1]    &{ExcelPath}[Interest_FinancialRatio_MaximumValue1]

    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[Interest_AfterItem1]    &{ExcelPath}[Interest_AfterItemType1]

    Add After Option Item - Second    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_Facility_Percent1]    sFormulaText=&{ExcelPath}[Interest_FormulaText1]

    Close Option Condition Window

    Add Facility Matrix to Ongoing Fee or Interest Pricing with Existing Matrix for Pricing Change Transaction    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]

    Set Financial Ratio for Pricing Change Transaction    &{ExcelPath}[FinancialRatio_RatioType]    &{ExcelPath}[Interest_FinancialRatio_MnemonicStatus2]    &{ExcelPath}[Interest_FinancialRatio_GreaterThan2]    &{ExcelPath}[Interest_FinancialRatio_LessThan2]    &{ExcelPath}[Interest_FinancialRatio_MinimumValue2]    &{ExcelPath}[Interest_FinancialRatio_MaximumValue2]

    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[Interest_AfterItem2]    &{ExcelPath}[Interest_AfterItemType2]

    Add After Option Item - Second    &{ExcelPath}[Interest_OptionName2]    &{ExcelPath}[Interest_RateBasis2]    &{ExcelPath}[Interest_Facility_Percent2]    sFormulaText=&{ExcelPath}[Interest_FormulaText2]

    Close Option Condition Window

    Validate Ongoing Fee or Interest

    Click OK Button in Pricing Window

    ### Send to Approval ###
    Select Pricing Change Transaction Send to Approval
    Logout from Loan IQ

    ### Approval ###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Pricing Change Transaction Menu
    Approve Price Change Transaction
    Logout from Loan IQ

    ### Release ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${FACILITIES_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${PRICING_CHANGE_TRANSACTION}     ${Facility_Name}
    Select Pricing Change Transaction Release
    Close All Windows on LIQ
   
    ### Validate Released Event ###
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Validate an Event in Events Tab of Facility Notebook    ${PRICING_CHANGE_TRANSACTION_RELEASED}
    Close All Windows on LIQ
    Open Deal Notebook If Not Present    ${Deal_Name}
    Navigate Line Fee Notebook from Deal Notebook    ${Facility_Name}
    Validate Rate in Line Fee Notebook - General Tab    &{ExcelPath}[PricingFormula_InEffect]    &{ExcelPath}[Current_Rate]
    Close All Windows on LIQ