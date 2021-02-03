*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Create Facility for ATM BILAT
    [Documentation]    This keyword is used to create a Facility for ATM BILAT deal
    ...    @author: ccarriedo    20JAN2021    Initial Create
    ...    @update: ccarriedo    02FEB2021    - Added writing to SYND02_PrimaryAllocation and CRED08_OngoingFeeSetup sheets. Removed unnecessary writing to SERV15_SchComittmentDecrease
    [Arguments]    ${ExcelPath}
    
    ### Login to LoanIQ ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
	${Facility_Name1}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name1    &{ExcelPath}[rowid]
	${Facility_Name2}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name2    &{ExcelPath}[rowid]
	${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    Write Data To Excel    CRED01_DealSetup    Facility_Name1    ${rowid}    ${Facility_Name1}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name1    ${rowid}    ${Facility_Name1}
    Write Data To Excel    SYND02_PrimaryAllocation    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name1    ${rowid}    ${Facility_Name1}
    Write Data To Excel    CRED01_DealSetup    Facility_Name2    ${rowid}    ${Facility_Name2}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name2    ${rowid}    ${Facility_Name2}
    Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name2    ${rowid}    ${Facility_Name2}
    Write Data To Excel    CRED08_OngoingFeeSetup    Deal_Name    ${rowid}    ${Deal_Name}
    
    ###Open Deal Notebook If Not present###
    Open Deal Notebook If Not Present    ${Deal_Name}
         
    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    &{ExcelPath}[Deal_Name]    ${Facility_Name1}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
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
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower1]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]

    Setup Interest Pricing for ATM Bilateral Deal    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadAmt]

Add Another Facility with Ongoing Fees for ATM BILAT
    [Documentation]    This keyword is used to add another facility for ATM BILAT deal
    ...    @author: ccarriedo    21JAN2021    Initial Create
    [Arguments]    ${ExcelPath}
    
    ### Login to LoanIQ ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ${Facility_Name2}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name2    &{ExcelPath}[rowid]
	${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
	
    ### Open Deal Notebook If Not present ###
    Open Deal Notebook If Not Present    ${Deal_Name}
    
    ### New Facility Screen ###
    ${Facility_ProposedCmtAmt}    New Facility Select    ${Deal_Name}    ${Facility_Name2}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt2]    &{ExcelPath}[Facility_Currency]
    
    ### Facility Notebook - Summary Tab ###
    Enter Dates on Facility Summary    &{ExcelPath}[Facility_AgreementDate2]    &{ExcelPath}[Facility_EffectiveDate2]    &{ExcelPath}[Facility_ExpiryDate2]    &{ExcelPath}[Facility_MaturityDate2]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ### Facility Notebook - Types/Purpose Tab ###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType2]
    
    ### Facility Notebook - Restrictions Tab ###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_ServicingGroup]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower2]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate2]

    Setup Interest Pricing for ATM Bilateral Deal    &{ExcelPath}[Interest_AddItem]    &{ExcelPath}[Interest_OptionName]    &{ExcelPath}[Interest_RateBasis]    &{ExcelPath}[Interest_SpreadAmt]

    ### Facility Penalty Spread ###
    Set Facility Pricing Penalty Spread    &{ExcelPath}[Penalty_Spread]    &{ExcelPath}[Penalty_Status]
    
    ### Modify Ongoing Fees ###
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]    
    Modify Ongoing Fee Pricing - Insert After   &{ExcelPath}[OngoingFee_AfterItem]    &{ExcelPath}[Facility_PercentWhole]    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[Facility_Percent] 

    Close All Windows on LIQ
    
Set Multiple Amortization Schedule for Facility
    [Documentation]    This high-level keyword sets up Amortization Schedule for Facility.
    ...    @author: ccarriedo    19JAN2021    - Initial create
    ...    @update: ccarriedo    21JAN2021    - Added close all windows and logout
    [Arguments]    ${ExcelPath}

    ${Facility_LimitChangeDecreaseAmount_List}    ${Facility_LimitChangeDecreaseAmount_Count}    Split String with Delimiter and Get Length of the List    &{ExcelPath}[Facility1_LimitChangeDecreaseAmount]    &{ExcelPath}[Delimiter]        
    ${Facility_LimitChangeDecreaseAmtSched_List}    ${Facility_LimitChangeDecreaseAmtSched_Count}    Split String with Delimiter and Get Length of the List    &{ExcelPath}[Facility1_LimitChangeDecreaseAmtSched]    &{ExcelPath}[Delimiter]
    
    ### Set amortization schedule ammounts ###
    Navigate to Amortization Schedule for Facility
    Select Amortization Schedule Status for Facility    &{ExcelPath}[Facility_AmortizationScheduleStatus]
    Delete Current Amortization Schedule for Facility
    Add Multiple Amortization Schedule for Facility    ${Facility_LimitChangeDecreaseAmount_Count}    ${Facility_LimitChangeDecreaseAmount_List}    ${Facility_LimitChangeDecreaseAmtSched_List}
    Save Amortization Schedule for Facility
        
    ###Facility Validation and close###
    Validate Facility
    
    ### Logout and Relogin in Inputter Level ###
    Close All Windows on LIQ
    Logout from Loan IQ
    
Setup Primaries for ATM BILAT
    [Documentation]    This keyword will Setup primaries for ATM Bilateral Deal
    ...    @author: ccarriedo    02FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Primary_Lender}    Read Data From Excel    CRED01_DealSetup    Deal_AdminAgent    &{ExcelPath}[rowid]
    ${Primary_LenderLoc}    Read Data From Excel    CRED01_DealSetup    AdminAgent_Location    &{ExcelPath}[rowid]
    ${FacilityName_1}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name1    &{ExcelPath}[rowid]
    ${PortfolioAllocation_2}    Read Data From Excel    CRED02_FacilitySetup    Facility_ProposedCmtAmt    &{ExcelPath}[rowid]
    ${FacilityName_2}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name2    &{ExcelPath}[rowid]
    ${PortfolioAllocation_1}    Read Data From Excel    CRED02_FacilitySetup    Facility_ProposedCmtAmt2    &{ExcelPath}[rowid]

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Open Existing Deal    ${Deal_Name}
    
    Add Lender and Location    ${Deal_Name}    ${Primary_Lender}    ${Primary_LenderLoc}    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Populate Amts or Dates Tab for Orig Primary    &{ExcelPath}[Primary_ExpectedCloseDate]

    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    Select Servicing Group on Primaries    None    &{ExcelPath}[Primary_SGAlias]

    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]|&{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${PortfolioAllocation_1}|${PortfolioAllocation_2}    None|None    ${FacilityName_2}|${FacilityName_1}    &{ExcelPath}[Primary_ExpenseCode]
    
    Close All Windows on LIQ
    Logout from Loan IQ
