*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Commitment Fee for LBT Bilateral Deal
    [Documentation]    This keyword is used to set up Commitment Fee for LBT Bilateral Deal.
    ...    @author: javinzon    10DEC2020    - Initial create
    ...    @update: javinzon    17DEC2020    - Added keyword 'Set Facility Pricing Penalty Spread'
    ...    @update: javinzon    01MAR2020    - Replaced keyword 'Navigate to Commitment Fee Notebook' with 'Navigate Ongoing Fee 
    ...                                        Notebook', Added keyword to get Fee Alias and Write to Excel
    [Arguments]    ${ExcelPath}
    
    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    &{ExcelPath}[rowid]
    ${Borrower_SGName}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid]
    ${Borrower_SG_GroupMembers}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_GroupMembers    &{ExcelPath}[rowid]
    ${Borrower_SG_Method}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_PreferredRIMthd    &{ExcelPath}[rowid]

    ### Facility Notebook - Pricing Tab ###
    Set Facility Pricing Penalty Spread    &{ExcelPath}[Penalty_Spread]    &{ExcelPath}[Penalty_Status]
    
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
    ${Fee_Alias}    Get Fee Alias using Status from Ongoing Fee List    ${PENDING_STATUS}
    Write Data To Excel    CRED08_OngoingFeeSetup    Fee_Alias    ${rowid}    ${Fee_Alias}
    Navigate to Ongoing Fee Notebook    ${Fee_Alias}

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
    ...    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount}    &{ExcelPath}[Primary_PortfolioExpDate]    &{ExcelPath}[Primary_RiskBook]
    
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

Complete Cycle Shares Adjustment for LBT Bilateral Deal
    [Documentation]    This is a high-level keyword to complete cycle shares adjustment for LBT Bilateral Deal
    ...    @author: javinzon    01FEB2021    - Initial Create 
    [Arguments]    ${ExcelPath}

	${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    ${rowid}
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    ${rowid}
	
	Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Accrual in Commitment Fee Notebook ###
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    Get and Validate Dates in Accrual Tab    ${ExcelPath}[Cycle_No]    ${ExcelPath}[Start_Date]    ${ExcelPath}[End_Date]

    ### Accrual Share Adjustment Notebook ###
    Navigate and Verify Accrual Share Adjustment Notebook    ${ExcelPath}[Start_Date]    ${Deal_Name}    ${Facility_Name}    ${Borrower_Name}    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[Current_Cycle_Due]
    ...    &{ExcelPath}[Projected_Cycle_Due]    
    Input Requested Amount, Effective Date, and Comment    &{ExcelPath}[Requested_Amount]    ${ExcelPath}[Effective_Date]     &{ExcelPath}[Accrual_Comment]
    Save the Requested Amount, Effective Date, and Comment    &{ExcelPath}[Requested_Amount]    ${ExcelPath}[Effective_Date]     &{ExcelPath}[Accrual_Comment]
 
    ### Send to Approval ###
    Send Adjustment to Approval
    Logout from Loan IQ
    
    ### Approval ###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    &{ExcelPath}[WIPTransaction_Type]    ${AWAITING_APPROVAL_STATUS}    &{ExcelPath}[FacilitiesTransaction_Type]     ${Deal_Name}
    Approve Fee Accrual Shares Adjustment
    Logout from Loan IQ
    
    ### Release ###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    &{ExcelPath}[WIPTransaction_Type]    ${AWAITING_RELEASE_STATUS}    &{ExcelPath}[FacilitiesTransaction_Type]     ${Deal_Name}
    Release Fee Accrual Shares Adjustment
    Close Accrual Shares Adjustment Window
    Logout from Loan IQ
    
    ### Verify the Updates in Accrual Tab ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    
    Validate Manual Adjustment Value    &{ExcelPath}[Cycle_No]    &{ExcelPath}[Requested_Amount] 
    Validate Cycle Due New Value    &{ExcelPath}[Cycle_No]    &{ExcelPath}[Current_Cycle_Due]     &{ExcelPath}[Requested_Amount]
    Validate Projected EOC Due New Value    &{ExcelPath}[Cycle_No]    &{ExcelPath}[Projected_Cycle_Due]     &{ExcelPath}[Requested_Amount]        
    Validate Accrual Shares Adjustment Applied Event
    Close All Windows on LIQ 
    
Fee Payment for LBT Bilateral Deal
    [Documentation]    This keyword is used to create Fee Payment for LBT Bilateral Deal
    ...    @author: javinzon    03FEB2021    - Initial create
    ...    @update: javinzon    05FEB2021    - Added required arguments in keyword 'Validate Dues on Accrual Tab for Commitment Fee'
    ...    @update: javinzon    23FEB2021    - Added required arguments in keyword 'Initiate Commitment Fee Ongoing Fee Payment'
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    ${rowid}
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    ${rowid}
    
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    
    Initiate Commitment Fee Ongoing Fee Payment    &{ExcelPath}[Expected_RequestedAmt]    &{ExcelPath}[Expected_CurrentCycleDue]    &{ExcelPath}[Expected_ProjectedCycleDue]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Comment]
    
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
    Logout from Loan IQ
    
    ### Payment Approval ####
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Close All Windows on LIQ
    Logout from Loan IQ
    
    ### Release Payment ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ
   
    ### Validation ###
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    Validate release of Ongoing Fee Payment
    Close Ongoing Fee Payment Notebook Window
    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[AfterPayment_CycleDueAmt]    &{ExcelPath}[Cycle_No]    &{ExcelPath}[AfterPayment_Projected_EOCAccrual]    &{ExcelPath}[AfterPayment_Projected_EOCDue]    &{ExcelPath}[AfterPayment_PaidToDate]   
    Close All Windows on LIQ

Update Actual Due Date and Cycle Frequency for LBT Bilateral Deal
    [Documentation]    This keyword is used to update the Cycle Frequency and Actual Due Date of Commitment fee for LBT Bilateral Deal.
    ...    @author: javinzon    - Initial create
    [Arguments]    ${ExcelPath}

    Update Commitment Fee    &{ExcelPath}[New_EffectiveDate]    &{ExcelPath}[New_ActualDueDate]    &{ExcelPath}[New_AdjustedDueDate]    &{ExcelPath}[New_Accrue]    &{ExcelPath}[New_AccrualEndDate]    &{ExcelPath}[New_CycleFrequency]   
    Get and Validate Dates in Accrual Tab    &{ExcelPath}[Cycle_No]    &{ExcelPath}[StartDate]    &{ExcelPath}[New_AccrualEndDate]
    Close All Windows on LIQ

Change Commitment Fee Expiry Date for LBT Bilateral Deal
    [Documentation]    This keyword change the expiry date of the commitment fee for LBT Bilateral Deal.
    ...    @author: javinzon    19FEB2021    - Initial create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    1
	
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ### Launch Facility ###
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Commitment Fee Notebook - General Tab ###  
    Update Cycle on Commitment Fee    ${ExcelPath}[Cycle_Frequency]
    Change Expiry Date    ${ExcelPath}[Actual_ExpiryDate]
    Validate General Tab of Commitment Fee Notebook    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_AccrualEndDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[Actual_ExpiryDate]    &{ExcelPath}[Original_ExpiryDate] 

    ### Perform Online Accrual ###
    Perform Online Accrual in Commitment Fee Notebook
    Close All Windows on LIQ
    
Create New Ongoing Fee for LBT Bilateral Deal
    [Documentation]    This keyword will create new ongoing fee for LBT Bilateral Deal 
    ...    @author: javinzon	22FEB2021    - Initial create
    ...    @update: javinzon    23FEB2021    - Added Keyword 'Write Data to Excel' and updated documentation
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    1
    
    Close All Windows on LIQ
        
    ### Launch Facility ###
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    ${Fee_Alias}    Create New Ongoing Fee
    Write Data To Excel    CRED08_OngoingFeeSetup    Fee_Alias    ${rowid}    ${Fee_Alias}

    ### Update and Release Commitment Fee ###
    Update Commitment Fee    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[OngoingFee_AccrualEndDate]    ${ExcelPath}[Cycle_Frequency] 
    Navigate Notebook Workflow    ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_Tab}    ${LIQ_CommitmentFeeNotebook_Workflow_JavaTree}    ${RELEASE_STATUS}
    
    ### Validate Released Event ###
    Validate an Event in Events Tab of Commitment Fee Notebook    ${RELEASED_STATUS}
    
    ### Perform Online Accrual ### 
    Perform Online Accrual in Commitment Fee Notebook
    
    ### Validate General Tab and Accruals Tab ###
    Validate General Tab of Commitment Fee Notebook    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_AccrualEndDate]    &{ExcelPath}[OngoingFee_Accrue]
    Get and Validate Dates in Accrual Tab    &{ExcelPath}[Cycle_Number1]    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_AccrualEndDate]
    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[Cycle1_CycleDueAmt]    &{ExcelPath}[Cycle_Number1]    &{ExcelPath}[Cycle1_Projected_EOCAccrual]    &{ExcelPath}[Cycle1_Projected_EOCDue]   
    Get and Validate Dates in Accrual Tab    &{ExcelPath}[Cycle_Number2]    &{ExcelPath}[Cycle2_StartDate]    &{ExcelPath}[Cycle2_EndDate]
    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[Cycle2_CycleDueAmt]    &{ExcelPath}[Cycle_Number2]    &{ExcelPath}[Cycle2_Projected_EOCAccrual]    &{ExcelPath}[Cycle2_Projected_EOCDue]   
    
Charge Monthly Commitment Fee for LBT Bilateral Deal (3/4/2020 to 15/5/2020)
    [Documentation]    This keyword is used to charge commitment fee (3/4/2020 to 15/5/2020) for LBT Bilateral Deal
    ...    @author: javinzon    23FEB2021    - Initial create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1
    ${Fee_Alias}    Read Data From Excel    CRED08_OngoingFeeSetup    Fee_Alias    3
    
    Close All Windows on LIQ
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Ongoing Fee Notebook    ${Fee_Alias}
    Initiate Commitment Fee Ongoing Fee Payment    &{ExcelPath}[Expected_RequestedAmt]    &{ExcelPath}[Expected_CurrentCycleDue]    &{ExcelPath}[Expected_ProjectedCycleDue]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Comment]
    
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
    Logout from Loan IQ
    
    ### Payment Approval ####
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${Facility_Name}
    Navigate to Payment Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Close All Windows on LIQ
    Logout from Loan IQ
    
    ### Release Payment ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${Facility_Name}
    Navigate to Payment Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ
   
    ### Validation ###
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Ongoing Fee Notebook    ${Fee_Alias}
    Validate release of Ongoing Fee Payment
    Close Ongoing Fee Payment Notebook Window
    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[AfterPayment_CycleDueAmt]    &{ExcelPath}[Cycle_No]    &{ExcelPath}[AfterPayment_Projected_EOCAccrual]    &{ExcelPath}[AfterPayment_Projected_EOCDue]    &{ExcelPath}[AfterPayment_PaidToDate]   
    Close All Windows on LIQ

Create Reversal Payment for LBT Bilateral Deal
    [Documentation]    This keyword initiates payment reversal for LBT Bilateral Deal
    ...    @author: javinzon    01MAR2021    - Initial create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    1
	${Fee_Alias}    Read Data From Excel    CRED08_OngoingFeeSetup    Fee_Alias    1
	${Borrower_Shortname}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1
        
    ### Launch Facility ###
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Ongoing Fee Notebook    ${Fee_Alias}

    ### Create Payment reversal ###
    Perform Reverse Payment Under Events Tab in Commitment Fee Notebook    &{ExcelPath}[Event]    &{ExcelPath}[Comment]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Expected_RequestedAmt]

    ### Create Cashflow ###
    Navigate Notebook Workflow    ${LIQ_ReverseFee_Window}    ${LIQ_ReversePayment_Tab}    ${LIQ_ReversePayment_WorkflowItems_Tree}    ${CREATE_CASHFLOW_TYPE}
    Set the Status to Send all to SPAP
    Verify if Status is set to Do It    ${Borrower_Shortname}  
    Close GL Entries and Cashflow Window

    ### Send to Approval and Approve ###
    Navigate Notebook Workflow    ${LIQ_ReverseFee_Window}    ${LIQ_ReversePayment_Tab}    ${LIQ_ReversePayment_WorkflowItems_Tree}    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${REVERSE_FEE_PAYMENT_TRANSACTION}     ${Facility_Name}
    Navigate Notebook Workflow    ${LIQ_ReverseFee_Window}    ${LIQ_ReversePayment_Tab}    ${LIQ_ReversePayment_WorkflowItems_Tree}    ${APPROVAL_STATUS}
    
    ### Generate Intent Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_GENERATE_INTENT_NOTICES_STATUS}    ${REVERSE_FEE_PAYMENT_TRANSACTION}     ${Facility_Name}
    Navigate Notebook Workflow    ${LIQ_ReverseFee_Window}    ${LIQ_ReversePayment_Tab}    ${LIQ_ReversePayment_WorkflowItems_Tree}    ${GENERATE_INTENT_NOTICES}
    Generate Intent Notices    ${Borrower_Shortname}
    Close Generate Notice Window
    Navigate Notebook Workflow    ${LIQ_ReverseFee_Window}    ${LIQ_ReversePayment_Tab}    ${LIQ_ReversePayment_WorkflowItems_Tree}    ${RELEASE_STATUS}
    
    ### Validate Released Event and Accruals ###
    Close All Windows on LIQ
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Ongoing Fee Notebook    ${Fee_Alias}
    Validate an Event in Events Tab of Commitment Fee Notebook    ${REVERSE_PAYMENT_RELEASED}
    Validate Payment Reversal in Accrual Tab    &{ExcelPath}[Cycle_No]    &{ExcelPath}[AfterPayment_CycleDueAmt]    &{ExcelPath}[AfterPayment_PaidToDate]
    
Complete Cycle Shares Adjustment to Correct Annual Fee Notebook for LBT Bilateral Deal 
    [Documentation]    This is a high-level keyword to complete cycle shares adjustment to correct Annual Fee Notebook for LBT Bilateral Deal 
    ...    @author: javinzon    02MAR2021    - Initial create 
    [Arguments]    ${ExcelPath}

	${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    1
    ${Borrower_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    1
    ${Fee_Alias}    Read Data From Excel    CRED08_OngoingFeeSetup    Fee_Alias    1

    ### Accrual Share Adjustment Notebook ###
    Navigate and Verify Accrual Share Adjustment Notebook    ${ExcelPath}[Start_Date]    ${Deal_Name}    ${Facility_Name}    ${Borrower_Name}    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[Current_Cycle_Due]
    ...    &{ExcelPath}[Projected_Cycle_Due]    
    Input Requested Amount, Effective Date, and Comment    &{ExcelPath}[Requested_Amount]    ${ExcelPath}[Effective_Date]     &{ExcelPath}[Accrual_Comment]
    Save the Requested Amount, Effective Date, and Comment    &{ExcelPath}[Requested_Amount]    ${ExcelPath}[Effective_Date]     &{ExcelPath}[Accrual_Comment]
 
    ### Send to Approval ###
    Send Adjustment to Approval
    Logout from Loan IQ
    
    ### Approval ###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    &{ExcelPath}[WIPTransaction_Type]    ${AWAITING_APPROVAL_STATUS}    &{ExcelPath}[FacilitiesTransaction_Type]     ${Deal_Name}
    Approve Fee Accrual Shares Adjustment
    Logout from Loan IQ
    
    ### Release ###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    &{ExcelPath}[WIPTransaction_Type]    ${AWAITING_RELEASE_STATUS}    &{ExcelPath}[FacilitiesTransaction_Type]     ${Deal_Name}
    Release Fee Accrual Shares Adjustment
    Close Accrual Shares Adjustment Window
    Logout from Loan IQ
    
    ### Verify the Updates in Accrual Tab ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Ongoing Fee Notebook    ${Fee_Alias}
    
    Validate Accrual Shares Adjustment Applied Event
    Validate Accrual Adjustment Value    &{ExcelPath}[Cycle_No]    &{ExcelPath}[AccrualAdjustment_Amount] 
    Validate Manual Adjustment Value    &{ExcelPath}[Cycle_No]    &{ExcelPath}[ManualAdjustment_Amount] 
    Validate Cycle Due New Value    &{ExcelPath}[Cycle_No]    &{ExcelPath}[Current_Cycle_Due]     &{ExcelPath}[Requested_Amount]
    Validate Projected EOC Due New Value    &{ExcelPath}[Cycle_No]    &{ExcelPath}[Projected_Cycle_Due]     &{ExcelPath}[Requested_Amount]    
    
Change Commitment Fee Expiry Date for LBT Bilateral Deal (4/3/2019) 
    [Documentation]    This keyword change the expiry date of the commitment fee to 03/04/2019 for LBT Bilateral Deal.
    ...    @author: javinzon    03MAR2021    - Initial create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    1
	${Fee_Alias}    Read Data From Excel    CRED08_OngoingFeeSetup    Fee_Alias    1
	
    ### Commitment Fee Notebook - General Tab ###  
    Change Expiry Date    ${ExcelPath}[Actual_ExpiryDate]
    Validate General Tab of Commitment Fee Notebook    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_AccrualEndDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[Actual_ExpiryDate]    &{ExcelPath}[Original_ExpiryDate] 

    ### Perform Online Accrual ###
    Perform Online Accrual in Commitment Fee Notebook
    
    ### Validate Accruals ###
    Close All Windows on LIQ
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Ongoing Fee Notebook    ${Fee_Alias}
    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[Cycle1_CycleDueAmt]    &{ExcelPath}[Cycle_Number1]    &{ExcelPath}[Cycle1_Projected_EOCAccrual]    &{ExcelPath}[Cycle1_Projected_EOCDue]
    
Create New Ongoing Fee and Check Line Items for LBT Bilateral Deal
    [Documentation]    This keyword will create new ongoing fee and check line items for LBT Bilateral Deal 
    ...    @author: javinzon	03MAR2021    - Initial create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    1
	${Fee_Alias}    Read Data From Excel    CRED08_OngoingFeeSetup    Fee_Alias    5
    
    Close All Windows on LIQ
        
    ### Launch Facility ###
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    ${Fee_Alias}    Create New Ongoing Fee
    Write Data To Excel    CRED08_OngoingFeeSetup    Fee_Alias    ${rowid}    ${Fee_Alias}

    ### Update and Release Commitment Fee ###
    Update Commitment Fee    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[OngoingFee_AccrualEndDate]    ${ExcelPath}[Cycle_Frequency] 
    Navigate Notebook Workflow    ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_Tab}    ${LIQ_CommitmentFeeNotebook_Workflow_JavaTree}    ${RELEASE_STATUS}
    
    ### Validate Released Event ###
    Validate an Event in Events Tab of Commitment Fee Notebook    ${RELEASED_STATUS}
    
    ### Perform Online Accrual ### 
    Perform Online Accrual in Commitment Fee Notebook
    
    ### Validate General Tab and Accruals Tab ###
    Close All Windows on LIQ
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Ongoing Fee Notebook    ${Fee_Alias}
    Validate General Tab of Commitment Fee Notebook    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_AccrualEndDate]    &{ExcelPath}[OngoingFee_Accrue]
    Get and Validate Dates in Accrual Tab    &{ExcelPath}[Cycle_Number1]    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_AccrualEndDate]
    Get and Validate Dates in Accrual Tab    &{ExcelPath}[Cycle_Number2]    &{ExcelPath}[Cycle2_StartDate]    &{ExcelPath}[Cycle2_EndDate]
    Navigate to Line Items from Accrual Tab of Commitment Fee Notebook    &{ExcelPath}[Cycle_Number1]
    
Change Commitment Fee Expiry Date for LBT Bilateral Deal (4/3/2020) 
    [Documentation]    This keyword change the expiry date of the commitment fee to 4/3/2020 for LBT Bilateral Deal.
    ...    @author: javinzon    03MAR2021    - Initial create
    [Arguments]    ${ExcelPath}
	
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
	${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    1
	${Fee_Alias}    Read Data From Excel    CRED08_OngoingFeeSetup    Fee_Alias    5

    Close All Windows on LIQ
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Navigate to Ongoing Fee Notebook    ${Fee_Alias}
    
    ### Commitment Fee Notebook - General Tab ###  
    Change Expiry Date    ${ExcelPath}[Actual_ExpiryDate]
    
    ### Commitment Fee Notebook - Check Accruals Tab ###
    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[Cycle1_CycleDueAmt]    &{ExcelPath}[Cycle_Number1]    &{ExcelPath}[Cycle1_Projected_EOCAccrual]    &{ExcelPath}[Cycle1_Projected_EOCDue]   
    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[Cycle2_CycleDueAmt]    &{ExcelPath}[Cycle_Number2]    &{ExcelPath}[Cycle2_Projected_EOCAccrual]    &{ExcelPath}[Cycle2_Projected_EOCDue]   
    
    
    
