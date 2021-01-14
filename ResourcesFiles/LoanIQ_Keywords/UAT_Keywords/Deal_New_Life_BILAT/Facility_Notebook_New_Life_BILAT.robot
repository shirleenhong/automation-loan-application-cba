*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Create Facility for New Life BILAT
    [Documentation]    This keyword is used to create a Facility for PIM Future Bilateral deal
    ...    @author: kmagday    10DEC2020    Initial Create
    ...    @update: kmagday    09JAN2021    Update writing of Facility_Name to SERV29_CommitmentFeePayment from row 1 to 7
    ...    @update: kmagday    11JAN2021    Added writing of Deal_Name, Borrower_ShortName to SERV08_ComprehensiveRepricing sheet
    ...    @update: kmagday    13JAN2021    Added multipleValue=Y to writing of Facility_Name in SERV01_LoanDrawdown
    [Arguments]    ${ExcelPath}
    
    ${Facility_NamePrefix}    Read Data From Excel    CRED02_FacilitySetup    Facility_NamePrefix    ${rowid}
    ${Facility_Name}    Generate Facility Name with 5 Numeric Test Data    ${Facility_NamePrefix}
    Write Data To Excel    CRED01_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    multipleValue=Y
    Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    ${rowid}    ${Facility_Name}    multipleValue=Y 
    Write Data To Excel    SERV08_ComprehensiveRepricing    Facility_Name    ${rowid}    ${Facility_Name}    multipleValue=Y

    ###Open Deal Notebook If Not present###
    Open Deal Notebook If Not Present    &{ExcelPath}[Deal_Name]
         
    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    Enter Dates on Facility Summary    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    Write Data To Excel    SERV01_LoanDrawdown   Loan_MaturityDate    ${rowid}     &{ExcelPath}[Facility_MaturityDate]

    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
   
    ###Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_ServicingGroup]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]

   
   
Setup Facility Ongoing Fee for New Life BILAT
    [Documentation]    This high-level keyword sets up Ongoing Fee from the Deal Notebook
    ...    @author: kmagday    12DEC2020    Initial Create
    [Arguments]    ${ExcelPath}
    
    ### Ongoing Fee ###
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]
    Add Ongoing Fee using Matrix and Outside Condition   &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]    &{ExcelPath}[OutsideCondition_RadioButton]
    Insert After Ongoing Fee Pricing using Outside Condition   &{ExcelPath}[OngoingFee_AfterItem1]    &{ExcelPath}[Facility_PercentWhole1]    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[Facility_Percent1] 
    Select Text in Ongoing Fee Pricing List     If( &{ExcelPath}[OngoingFee_Type1]1 )
    Insert After Ongoing Fee using Matrix and Outside Condition   &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    Insert After Ongoing Fee Pricing using Outside Condition   &{ExcelPath}[OngoingFee_AfterItem1]    &{ExcelPath}[Facility_PercentWhole2]    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[Facility_Percent2] 
    Validate Ongoing Fee or Interest
    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadAmt]    &{ExcelPath}[Interest_BaseRateCode]

Setup Primary for New Life BILAT
    [Documentation]    This keyword will Setup primary for New Life BILAT deal
    ...    @author: kmagday    12DEC2020    Initial Create
    [Arguments]    ${ExcelPath}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Populate Amts or Dates Tab for Orig Primary    &{ExcelPath}[Orig_Primary_ExpectedCloseDate]    
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    Select Servicing Group on Primaries    &{ExcelPath}[Primary_ServicingGroupMember]    &{ExcelPath}[Primary_SGAlias]
    ${SellAmount}    Get Circle Notebook Sell Amount  
    
    ### Circle Notebook Complete Portfolio Allocation, Circling ###
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount}    &{ExcelPath}[Primary_ExpiryDate]    &{ExcelPath}[Primary_FacilityName]    &{ExcelPath}[Primary_RiskBook]
    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]

    Close All Windows on LIQ

Approve and Close Deal for New Life Bilat
    [Documentation]    This keyword approves and closes the created Deal
    ...    @author: kmagday    12DEC2020     Initial Create
    [Arguments]    ${ExcelPath}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Deal Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Deal Notebook Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    &{ExcelPath}[ApproveDate]
    Close the Deal    &{ExcelPath}[CloseDate]
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Update Commitment Fee for New Life BILAT
    [Documentation]    This keyword will update the existing commitment fee in the created deal
    ...    @author: kmagday    15DEC2020    Initial Create
    [Arguments]    ${ExcelPath}
    
    Navigate to Facility Notebook  &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Commitment Fee Notebook - General Tab ###  
    Update Commitment Fee    &{ExcelPath}[Commitment_EffectiveDate]    &{ExcelPath}[Commitment_ActualDate]    &{ExcelPath}[Commitment_AdjustedDueDate]    &{ExcelPath}[Commitment_Accrue]    &{ExcelPath}[Commitment_AccrualEndDate]    ${ExcelPath}[Commitment_CycleFrequency] 
    
    Save Facility Notebook Transaction
    Close All Windows on LIQ

Release Commitment Fee for New Life Bilat
    [Documentation]    This keyword will update the existing commitment fee in the created deal
    ...    @author: kmagday    15DEC2020    Initial Create
    [Arguments]    ${ExcelPath}
    
    Navigate to Facility Notebook  &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Commitment Fee Notebook ###
    Release Commitment Fee
    
    Save Facility Notebook Transaction
    Close All Windows on LIQ

    
