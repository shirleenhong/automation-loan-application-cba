*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Commitment Fee for PDS Syndicate Deal
    [Documentation]    This high-level keyword sets up Commitment Fee for PDS Syndicate Deal.
    ...    @author:    shirhong    21JAN2021    - Initial create
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

    Set Facility Pricing Penalty Spread    &{ExcelPath}[PenaltySpread_Value]    &{ExcelPath}[PenaltySpread_Status]
    
    ### Ongoing Fee - Update Details ###
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    Update Ongoing Fee General Information    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[OngoingFee_AccrualEndDate]

    Update Fee Paid By and Servicing Group for Ongoing Fee    ${Borrower_ShortName}    ${Borrower_Location}    ${Borrower_SGName}    ${Borrower_SG_GroupMembers}    ${Borrower_SG_Method}

    Save and Close Ongoing Fee Window
    
Release Ongoing Fee for PDS Syndicate Deal
    [Documentation]    This keyword will release the existing ongoing fee in the created deal
    ...    @author:    shirhong    08FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Facility_Name}    Run Keyword If    '&{ExcelPath}[Test_Case]'== 'Establish Commitment Fee For Facility A'    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    &{ExcelPath}[rowid]
    ...    ELSE IF    '&{ExcelPath}[Test_Case]'== 'Establish Commitment Fee For Facility B'    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    &{ExcelPath}[rowid]

    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Ongoing Fee Notebook ###
    Release Ongoing Fee

    Save Facility Notebook Transaction
    Close All Windows on LIQ

