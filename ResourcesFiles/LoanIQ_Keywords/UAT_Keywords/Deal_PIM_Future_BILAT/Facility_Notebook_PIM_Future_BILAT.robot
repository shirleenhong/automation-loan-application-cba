*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Facility for PIM Future BILAT
    [Documentation]    This keyword is used to create a Facility for PIM Future Bilateral deal
    ...    @author: mcastro    02DEC2020    - Initial Create
    ...    @update: mcastro    09DEC2020    - Added writing of Facility_name to Correspondence
    ...    @update: mcastro    11DEC2020    - Added writing of Facility_name to Correspondence row 3
    ...    @update: mcastro    15DEC2020    - Added writing of Facility_name to Correspondence row 4 and 5
    ...    @update: mcastro    08JAN2021    - Added writing of Facility_name to SERV01_LoanDrawdown for the 2nd loan
    ...    @udpate: mcastro    15JAN2021    - Replace writing of Facility_name to Correspondence to use multipleValue=Y value
    [Arguments]    ${ExcelPath}
    
    ${Facility_NamePrefix}    Read Data From Excel    CRED02_FacilitySetup    Facility_NamePrefix    ${rowid}
    ${Facility_Name}    Generate Facility Name with 5 Numeric Test Data    ${Facility_NamePrefix}
    Write Data To Excel    CRED01_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    multipleValue=Y
    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name    ${rowid}    ${Facility_Name} 
    Write Data To Excel    SERV08_ComprehensiveRepricing    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    Correspondence    Facility_Name    ${rowid}    ${Facility_Name}    multipleValue=Y   
    
    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ##Facility Notebook - Summary Tab###
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
   
Setup Facility Ongoing Fee for PIM Future BILAT
    [Documentation]    This high-level keyword sets up Ongoing Fee from the Deal Notebook
    ...    @author: mcastro    02DEC2020    - Initial Create
    ...    @update: mcastro    17DEC2020    - Added setting of facility Pricing Penalty Spread
    [Arguments]    ${ExcelPath}

    Navigate to Modify Ongoing Fee Window
    Validate Facility Pricing Window    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Pricing_Type]

    ### Ongoing Fee ###
    Add Facility Ongoing Fee - Matrix    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type1]    &{ExcelPath}[OngoingFee_RateBasis1]    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]
    Set Commitment Fee Percentage Matrix    &{ExcelPath}[Commitment_PctType]    &{ExcelPath}[Commitment_BalanceType]    &{ExcelPath}[Commitment_GreaterThan]    &{ExcelPath}[Commitment_LessThan]
    ...    &{ExcelPath}[Commitment_MnemonicStatus]    &{ExcelPath}[Minimum_Value]    &{ExcelPath}[Maximum_Value]

    Add After Item to Facility Ongoing Fee    &{ExcelPath}[OngoingFee_Type2]    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    Set Formula Category For Fees    &{ExcelPath}[OngoingFee_CategoryType]    &{ExcelPath}[OngoingFee_Amount]    &{ExcelPath}[OngoingFee_SpreadType]
    
    Add Item to Facility Ongoing Fee    &{ExcelPath}[OngoingFee_Type2]    &{ExcelPath}[OngoingFee_Item]    &{ExcelPath}[OngoingFee_ItemType]
    Set Commitment Fee Percentage Matrix    &{ExcelPath}[Commitment_PctType]    &{ExcelPath}[Commitment_BalanceType]    &{ExcelPath}[Commitment_GreaterThan2]    &{ExcelPath}[Commitment_LessThan]
    ...    &{ExcelPath}[Commitment_MnemonicStatus2]    &{ExcelPath}[Minimum_Value2]

    Add After Item to Facility Ongoing Fee    &{ExcelPath}[OngoingFee_Type2]    &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[OngoingFee_AfterItemType]
    Set Formula Category For Fees    &{ExcelPath}[OngoingFee_CategoryType]    &{ExcelPath}[OngoingFee_Amount2]    &{ExcelPath}[OngoingFee_SpreadType]
    Validate Ongoing Fee or Interest

    ### Interest Pricing ###
    Modify Interest Pricing - Insert Add    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadAmt]    &{ExcelPath}[Interest_BaseRateCode]

    ### Penalty Spread ###
    Set Facility Pricing Penalty Spread    &{ExcelPath}[Penalty_Spread]    &{ExcelPath}[Penalty_Status]

    Validate Facility
    Mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    Close All Windows on LIQ

Update Commitment for PIM Future BILAT
    [Documentation]    This keyword will update the existing commitment fee in the created deal
    ...    @author: mcastro    03DEC2020    - Initial Create
    ...    @update: mcastro    21JAN2020    - Added variable Commitment_Cycle_Frequency
    [Arguments]    ${ExcelPath}
    
    Navigate to Facility Notebook  &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type] 
    
    ### Commitment Fee Notebook - General Tab ###  
    Update Commitment Fee    &{ExcelPath}[Commitment_EffectiveDate]    &{ExcelPath}[Commitment_ActualDate]    &{ExcelPath}[Commitment_AdjustedDueDate]    &{ExcelPath}[Commitment_Accrue]    &{ExcelPath}[Commitment_AccrualEndDate]    &{ExcelPath}[Commitment_Cycle_Frequency]

    Close All Windows on LIQ 

Setup Primary for PIM Future BILAT
    [Documentation]    This keyword will Setup primary for PIM Future BILAT deal
    ...    @author: mcastro    03DEC2020    - Initial Create
    ...    @update: mcastro    14DEC2020    - Update workflow process, approval not needed for the deal
    ...    @update: mcastro    21JAN2021    - Update None to variables
    [Arguments]    ${ExcelPath}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    Select Servicing Group on Primaries    &{ExcelPath}[Primary_SG_Member]    &{ExcelPath}[Primary_SGAlias]
    ${SellAmount}    Get Circle Notebook Sell Amount   
    
    ### Circle Notebook Complete Portfolio Allocation and Circling ###
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount}    &{ExcelPath}[Primary_ExpiryDate]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Primary_RiskBook]
    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]

    Close All Windows on LIQ

Approve and Close Deal
    [Documentation]    This keyword approves and closes the created Deal
    ...    @author: mcastro    04DEC2020    - Initial Create
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

Release Commitment Fee For PIM Future BILAT
    [Documentation]    This keyword will release the existing commitment fee in the created deal
    ...    @author: mcastro    04DEC2020    - Initial Create
    [Arguments]    ${ExcelPath}
    
    Navigate to Facility Notebook  &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Commitment Fee Notebook ###
    Release Commitment Fee

    Save Facility Notebook Transaction
    Close All Windows on LIQ
