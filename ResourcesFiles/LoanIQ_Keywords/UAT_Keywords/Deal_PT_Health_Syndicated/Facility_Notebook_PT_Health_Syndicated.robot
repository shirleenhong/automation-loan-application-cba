*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Facility for PT Health
    [Documentation]    This keyword is used to create facility for PT Health
    ...    @author: songchan    15JAN2021    - initial create
    ...    @update: songchan    29JAN2021    - Add writing of Facility Name for Loan Drawdown to dataset
    ...    @update: songchan    01FEB2021    - Add writing of Facility Name in Ongoing Fee Setup sheet
    ...    @update: songchan    09FEB2021    - Add writing of Facility Name in Comprehensive repricing sheet
    ...    @update: songchan    03MAR2021    - Add writing of Facility Name in AccrualsAdjustment sheet
    [Arguments]    ${ExcelPath}
    
    ${Facility_NamePrefix}    Read Data From Excel    CRED02_FacilitySetup    Facility_NamePrefix    ${rowid}
    ${Facility_Name}    Generate Facility Name with 4 Numeric Test Data    ${Facility_NamePrefix}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    SERV29_CommitmentFeePayment    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    SERV08_ComprehensiveRepricing    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    MTAM06_AccrualsAdjustment    Facility_Name    ${row_id}    ${Facility_Name}

    ###Open Deal Notebook If Not present###
    Open Deal Notebook If Not Present    &{ExcelPath}[Deal_Name]
         
    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    Enter Dates on Facility Summary    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]

    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
   
    ###Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_ServicingGroup]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]

Setup Pricing for PT Health Syndicated Deal
    [Documentation]    This keyword is used to set up Pricing for PT Health Syndicated Deal.
    ...    @author: songchan    18JAN2021    - Initial create
    [Arguments]    ${ExcelPath}
    
    ### Facility Notebook - Pricing Tab ###
    Set Facility Pricing Penalty Spread    &{ExcelPath}[Penalty_Spread]    &{ExcelPath}[Penalty_Status]
    
    ### Modify Ongoing Fees ###
    Modify Ongoing Fee Pricing - Insert Add    &{ExcelPath}[OngoingFee_Category]    &{ExcelPath}[OngoingFee_Type]    &{ExcelPath}[OngoingFee_RateBasis]
    Modify Ongoing Fee Pricing - Insert After Matrix of External Rating    &{ExcelPath}[FacilityItemAfter]    &{ExcelPath}[Facility_Percent1]
  
    Confirm Facility Ongoing Fee Pricing Options Settings
    
    Verify If Text Value Exist as Java Tree on Page    Facility -    &{ExcelPath}[Facility_PercentWhole1]
    Verify If Text Value Exist as Java Tree on Page    Facility -    &{ExcelPath}[FacilityItem]
    
    ### Modify Interest Pricing ###
    Modify Interest Pricing - Insert Add    &{ExcelPath}[InterestPricingItem]    &{ExcelPath}[OptionName]    &{ExcelPath}[Interest_RateBasis]
    ...    &{ExcelPath}[Spread1]    &{ExcelPath}[Code]
        
    Verify If Text Value Exist as Java Tree on Page    Facility -    &{ExcelPath}[Code]
    
Update Line Fee for PT Health Syndicated
    [Documentation]    This keyword will update the existing commitment fee in the created deal
    ...    @author: songchan    20JAN2021    Initial Create
    [Arguments]    ${ExcelPath}
    
    Navigate to Facility Notebook  &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Commitment Fee Notebook - General Tab ###  
    Enter Line Fee Details    &{ExcelPath}[Commitment_EffectiveDate]    &{ExcelPath}[Commitment_ActualDate]    &{ExcelPath}[Commitment_AdjustedDueDate]    ${ExcelPath}[Commitment_CycleFrequency]    &{ExcelPath}[Commitment_Accrue]
    ...    &{ExcelPath}[FloatRateDate]    &{ExcelPath}[PayType]  
    
    Save Facility Notebook Transaction
    Close All Windows on LIQ
    
Release Line Fee for PT Health Syndicated
    [Documentation]    This keyword will update the existing commitment fee in the created deal
    ...    @author: songchan    20JAN2021    Initial Create
    [Arguments]    ${ExcelPath}
    
    Navigate to Facility Notebook  &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Line Fee Notebook ###
    Release Line Fee
    
    Save Facility Notebook Transaction
    Close All Windows on LIQ
    
Update Facility Fee Expiry Date for PT Health Syndicated
    [Documentation]    This keyword will update the existing commitment fee in the created deal for Fee Expiry Date
    ...    @author: songchan    20JAN2021    Initial Create
    [Arguments]    ${ExcelPath}
    
    Navigate to Facility Notebook  &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    Change Expiry Date of Line Fee    &{ExcelPath}[Fee_ExpiryDate]
    
    Save Facility Notebook Transaction
    Close All Windows on LIQ