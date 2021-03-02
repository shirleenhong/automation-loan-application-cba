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

Release Ongoing Fee for CH EDU Bilateral Deal
    [Documentation]    This keyword will release the existing ongoing fee in the created deal
    ...    @author: dahijara    10DEC2020    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Facility_Name}    Run Keyword If    '&{ExcelPath}[OngoingFee_Type]'== 'Commitment Fee'    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    &{ExcelPath}[rowid]
    ...    ELSE IF    '&{ExcelPath}[OngoingFee_Type]'== 'Line Fee'    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    &{ExcelPath}[rowid]

    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Ongoing Fee Notebook ###
    Release Ongoing Fee

    Save Facility Notebook Transaction
    Close All Windows on LIQ

Pay Line Fee for CH EDU Bilateral Deal
    [Documentation]    This keyword is used for line fee payment for CH EDU Bilateral Deal
    ...    @author: dahijara    11JAN2021    - Initial Create
    ...    @update: dahijara    13JAN2020    - Updated keyword name from 'Select Notices Recepients' to 'Select Notices Recipients'
    [Arguments]    ${ExcelPath} 

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    1

    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Ongoing Fee Payment ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]
    Verify Details in Accrual Tab for Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Cycle_StartDate]    &{ExcelPath}[Cycle_EndDate]
    ...    &{ExcelPath}[Cycle_DueDate]    &{ExcelPath}[Expected_CycleDueAmt]    &{ExcelPath}[ProjectedCycleDue]

    Initiate Payment for Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Expected_CycleDueAmt]    &{ExcelPath}[Effective_Date]
    
    ### Create Cashflows ###
    Navigate to Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to Do It

    ### Generate Intent Notice ###
    Navigate to Payment Workflow and Proceed With Transaction        ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Sending Payment For Approval ###
    Navigate to Payment Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Close All Windows on LIQ

    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Payment Approval ####
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Close All Windows on LIQ
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Release Payment ###
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ
   
    ### Validation ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]
    Validate Payment Release of Ongoing Line Fee
    Validate After Payment Details on Acrual Tab - Line Fee    &{ExcelPath}[Expected_CycleDueAmt]    &{ExcelPath}[Cycle_Number]

Pay Commitment Fee for CH EDU Bilateral Deal
    [Documentation]    This keyword is used for commitment fee payment for CH EDU Bilateral Deal
    ...    @author: mcastro    15FEB2021    - Initial create
    [Arguments]    ${ExcelPath} 

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    1

    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Ongoing Fee Payment ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]

    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[ProjectedCycleDue]    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Projected_EOCAccrual]    
    ...    &{ExcelPath}[Projected_EOCDue]    &{ExcelPath}[Expected_PaidToDate]

    Select Cycle Fee Payment 
    Enter Effective Date for Ongoing Fee Payment    &{ExcelPath}[Effective_Date]    &{ExcelPath}[ProjectedCycleDue]
    Enter Ongoing Fee Comment    &{ExcelPath}[Fee_Comment]
    
    ### Create Cashflows ###
    Navigate to Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to None

    ### Generate Intent Notice ###
    Navigate to Payment Workflow and Proceed With Transaction        ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Add Group Comment for Notices    &{Excelpath}[Notice_Subject]    &{Excelpath}[Notice_Comment]   
    Exit Notice Window

    ### Sending Payment For Approval ###
    Navigate to Payment Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Close All Windows on LIQ

    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Payment Approval ####
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Close All Windows on LIQ
    
    ### Loan IQ Desktop ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Release Payment ###
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ
   
    ### Validation ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]
    Validate Details on Acrual Tab - Commitment Fee    &{ExcelPath}[ProjectedCycleDue]    &{ExcelPath}[Cycle_Number]
    Validate release of Ongoing Fee Payment
    Close All Windows on LIQ 

Complete Commitment Fee Cashflow for CH EDU Bilateral Deal 
    [Documentation]    This keyword is used for completing commitment fee cashflow for CH EDU Bilateral Deal
    ...    @author: mcastro    16FEB2021    - Initial create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1
    ${Expense_Code}    Read Data From Excel    CRED01_DealSetup    Deal_ExpenseCode    1

    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Ongoing Fee List ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]

    ### Commitment Fee Notebook ###
    Navigate Notebook Events    ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_Tab}    ${LIQ_CommitmentFee_Events_Javatree}   ${FEE_PAYMENT_RELEASED_STATUS}
    
    ### Ongoing Fee Payment Notebook ###
    Navigate to Payment Workflow and Proceed With Transaction    ${COMPLETE_CASHFLOWS_WORKFLOW}
    Match and Verify WIP Items    ${Borrower_Name}    &{ExcelPath}[GLShortName]    &{ExcelPath}[Commitment_EffectiveDate]    &{ExcelPath}[Fee_Amount]    ${Expense_Code}
    Verify Customer Status in Cashflow Window    ${Borrower_Name}    &{ExcelPath}[CashFlow_AfterStatus]
    Verify Customer Method in Cashflow Window    ${Borrower_Name}    &{ExcelPath}[CashFlow_AfterMethod]
    Click OK In Cashflows
    Verify if Cashflow is Completed for Ongoing Fee Payment

    Close All Windows on LIQ

Capitalize Interest and Pay Commitment Fee for CH EDU Bilateral Deal
    [Documentation]    This keyword is used to capitalize interest and pay commitment fee for CH EDU Bilateral Deal
    ...    @author: mcastro    23FEB2021    - Initial create
    [Arguments]    ${ExcelPath} 

    ### Retrieve Data from Excel Data Sheet ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    1
    ${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    9
    ${Pricing_Option}    Read Data From Excel    SERV01_LoanDrawdown    Pricing_Option    9

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Ongoing Fee Payment ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]

    ### Fee Capitalization Window ###
    Navigate to Capitalize Interest Payment from Ongoing Fee Notebook
    Enter Fee Capitalization Details    &{ExcelPath}[InterestCapitalization_Status]    &{ExcelPath}[Cycle_StartDate]    &{ExcelPath}[Cycle_DueDate]
    ...    ${Loan_Alias}    ${Pricing_Option}    ${FacilityName}

    ### Commitment Fee Accrual Tab ###
    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[ProjectedCycleDue]    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Projected_EOCAccrual]    
    ...    &{ExcelPath}[Projected_EOCDue]    &{ExcelPath}[Expected_PaidToDate]

    Select Cycle Fee Payment 
    Enter Effective Date for Ongoing Fee Payment    &{ExcelPath}[Effective_Date]    &{ExcelPath}[ProjectedCycleDue]
    
    ### Create Cashflows ###
    Navigate to Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Validate Cashflow Error is Displayed

    ### Generate Intent Notice ###
    Navigate to Payment Workflow and Proceed With Transaction        ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Add Group Comment for Notices    &{Excelpath}[Notice_Subject]    &{Excelpath}[Notice_Comment]   
    Exit Notice Window

    ### Sending Payment For Approval ###
    Navigate to Payment Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Close All Windows on LIQ

    ### Loan IQ Desktop ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Payment Approval ####
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Close All Windows on LIQ
    
    ### Loan IQ Desktop ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Release Payment ###
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ
   
    ### Validation ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]
    Validate Details on Acrual Tab - Commitment Fee    &{ExcelPath}[ProjectedCycleDue]    &{ExcelPath}[Cycle_Number]
    Validate release of Ongoing Fee Payment
    Close All Windows on LIQ 
