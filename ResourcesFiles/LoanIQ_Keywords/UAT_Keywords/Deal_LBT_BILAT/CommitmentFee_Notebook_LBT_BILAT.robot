*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Commitment Fee for LBT Bilateral Deal
    [Documentation]    This keyword is used to set up Commitment Fee for LBT Bilateral Deal.
    ...    @author: javinzon    10DEC2020    - Initial create
    [Arguments]    ${ExcelPath}
    
    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    &{ExcelPath}[rowid]
    ${Borrower_SGName}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid]
    ${Borrower_SG_GroupMembers}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_GroupMembers    &{ExcelPath}[rowid]
    ${Borrower_SG_Method}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_PreferredRIMthd    &{ExcelPath}[rowid]

    ### Facility Notebook - Pricing Tab ###
    ### Modify Ongoing Fees ###
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]
    Add After Item to Facility Ongoing Fee    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_AfterItem1]    &{ExcelPath}[OngoingFee_AfterItemType1]
    Set Outside Condition to Facility Ongoing Fee    &{ExcelPath}[OutsideCondition_Type]    &{Excelpath}[OutsideCondition_RadioButton]
    Add After Item to Facility Ongoing Fee    &{ExcelPath}[OngoingFee_AfterItemType1]    &{ExcelPath}[OngoingFee_AfterItem2]    &{ExcelPath}[OngoingFee_AfterItemType2]
    Set Formula Category For Fees    &{ExcelPath}[OngoingFee_FormulaCategoryType]    &{ExcelPath}[Facility_Percent1]    &{ExcelPath}[OngoingFee_SpreadType]
   
    Add Facility Matrix to Ongoing Fee or Interest Pricing with Existing Matrix For Facility Pricing    &{ExcelPath}[OngoingFee_AfterItemType1]    &{ExcelPath}[OngoingFee_AfterItem1]    &{ExcelPath}[OngoingFee_AfterItemType1]
    Set Outside Condition to Facility Ongoing Fee    &{ExcelPath}[OutsideCondition_Type]    
    Add After Item to Facility Ongoing Fee    &{ExcelPath}[OngoingFee_AfterItemType1]    &{ExcelPath}[OngoingFee_AfterItem2]    &{ExcelPath}[OngoingFee_AfterItemType2]
    Set Formula Category For Fees    &{ExcelPath}[OngoingFee_FormulaCategoryType]    &{ExcelPath}[Facility_Percent2]    &{ExcelPath}[OngoingFee_SpreadType]
    Validate Ongoing Fee or Interest

    ### Modify Interest Pricing ###
    Navigate to Facitily Interest Pricing Window
    Add Item to Ongoing Fee or Interest Pricing For Facility Pricing    &{ExcelPath}[Interest_Item1]    &{ExcelPath}[Interest_ItemType1]
    Set Facility Utilized Percentage Matrix    &{ExcelPath}[Commitment_PctType]    &{ExcelPath}[Commitment_BalanceType]    &{ExcelPath}[Commitment_GreaterThan1]    &{ExcelPath}[Commitment_LessThan]
    ...    &{ExcelPath}[Commitment_MnemonicStatus_OFF]    &{ExcelPath}[Minimum_Value1]    &{ExcelPath}[Maximum_Value1]
    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[Interest_AfterItem1]    &{ExcelPath}[Interest_AfterItemType1]
    Add After Option Item - Second    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_SpreadAmt1]    

    Add Facility Matrix to Ongoing Fee or Interest Pricing with Existing Matrix For Facility Pricing    &{ExcelPath}[Commitment_PctType]    &{ExcelPath}[Interest_Item1]    &{ExcelPath}[Interest_ItemType1]
    Set Facility Utilized Percentage Matrix    &{ExcelPath}[Commitment_PctType]    &{ExcelPath}[Commitment_BalanceType]    &{ExcelPath}[Commitment_GreaterThan2]    &{ExcelPath}[Commitment_LessThan]
    ...    &{ExcelPath}[Commitment_MnemonicStatus_OFF]    &{ExcelPath}[Minimum_Value2]    &{ExcelPath}[Maximum_Value2]
    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[Interest_AfterItem1]    &{ExcelPath}[Interest_AfterItemType1]
    Add After Option Item - Second    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_SpreadAmt2]    

    Add Facility Matrix to Ongoing Fee or Interest Pricing with Existing Matrix For Facility Pricing    &{ExcelPath}[Commitment_PctType]    &{ExcelPath}[Interest_Item1]    &{ExcelPath}[Interest_ItemType1]
    Set Facility Utilized Percentage Matrix    &{ExcelPath}[Commitment_PctType]    &{ExcelPath}[Commitment_BalanceType]    &{ExcelPath}[Commitment_GreaterThan2]    &{ExcelPath}[Commitment_LessThan]
    ...    &{ExcelPath}[Commitment_MnemonicStatus_OFF]    &{ExcelPath}[Minimum_Value3]    &{ExcelPath}[Maximum_Value3]
    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[Interest_AfterItem1]    &{ExcelPath}[Interest_AfterItemType1]
    Add After Option Item - Second    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_SpreadAmt3]    
    
    Add Facility Matrix to Ongoing Fee or Interest Pricing with Existing Matrix For Facility Pricing    &{ExcelPath}[Commitment_PctType]    &{ExcelPath}[Interest_Item1]    &{ExcelPath}[Interest_ItemType1]
    Set Facility Utilized Percentage Matrix    &{ExcelPath}[Commitment_PctType]    &{ExcelPath}[Commitment_BalanceType]    &{ExcelPath}[Commitment_GreaterThan2]    &{ExcelPath}[Commitment_LessThan]
    ...    &{ExcelPath}[Commitment_MnemonicStatus_ON]    &{ExcelPath}[Minimum_Value4]    &{ExcelPath}[Maximum_Value4]
    Add After Item to Existing Selection For Facility Pricing    &{ExcelPath}[Interest_AfterItem1]    &{ExcelPath}[Interest_AfterItemType1]
    Add After Option Item - Second    &{ExcelPath}[Interest_OptionName1]    &{ExcelPath}[Interest_RateBasis1]    &{ExcelPath}[Interest_SpreadAmt4]    
    Validate Ongoing Fee or Interest
    
    ### Ongoing Fee - Update Details ###
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    Update Ongoing Fee General Information    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[OngoingFee_AccrualEndDate]    &{ExcelPath}[Cycle_Frequency]

    Update Fee Paid By and Servicing Group for Ongoing Fee    ${Borrower_ShortName}    ${Borrower_Location}    ${Borrower_SGName}    ${Borrower_SG_GroupMembers}    ${Borrower_SG_Method}

    Save and Close Ongoing Fee Window

    Close All Windows on LIQ

Setup Primary for LBT Bilateral Deal
    [Documentation]    This keyword will Setup primary for LBT BILAT deal
    ...    @author: javinzon    14DEC2020    - Initial create
    [Arguments]    ${ExcelPath}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender]    &{ExcelPath}[Primary_LenderLoc]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    ${SellAmount}    Get Circle Notebook Sell Amount 
    Populate Amts or Dates Tab in Pending Orig Primary    ${SellAmount}    &{ExcelPath}[Expected_CloseDate]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    Select Servicing Group on Primaries    None    &{ExcelPath}[Primary_SGAlias]
      
    Mx LoanIQ close window    ${LIQ_OrigPrimaries_Window}
    
    ### Circle Notebook Complete Portfolio Allocation, Circling, and Sending to Settlement Approval ###
    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender]    &{ExcelPath}[Primary_CircledDate]    &{ExcelPath}[Lender_Hostbank]    &{ExcelPath}[Primary_Portfolio]
    ...    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount}    None    &{ExcelPath}[Primary_RiskBook]
    
    Close All Windows on LIQ

Release Commitment Fee for LBT Bilateral Deal
    [Documentation]    This keyword will release the existing commitment fee in the created deal
    ...    @author: javinzon    16DEC2020    - Initial create
    [Arguments]    ${ExcelPath}
    
    Navigate to Facility Notebook  &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Commitment Fee Notebook ###
    Release Commitment Fee

    Save Facility Notebook Transaction
    Close All Windows on LIQ

