*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Facility A for PDS Syndicate Deal
    [Documentation]    This keyword creates Facility A for PDS Syndicated Deal
    ...    @author: shirhong    18JAN2021    - Intial Create
    ...    @update: shirhong    28JAN2021    - Updated keyword name to specific Facility
    ...    @update: shirhong    09FEB2021    - Added writing of Facility Name in Ongoing Fee Setup sheet
    [Arguments]    ${ExcelPath}

    ${Facility_Name}    Auto Generate Only 5 Numeric Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    CRED02_FacilitySetup_A    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    CRED08_OngoingFeeSetup_A    Facility_Name    ${rowid}    ${Facility_Name}
    ${Facility_BorrowerSGName}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid]
    ${Facility_Borrower}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]

    ###Open Deal Notebook If Not present###
    Open Deal Notebook If Not Present    ${Deal_Name}

    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    ${Deal_Name}    ${Facility_Name}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    Enter Dates on Facility Summary    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
   
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGAlias]

    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    ${Facility_BorrowerSGName}    &{ExcelPath}[Facility_BorrowerPercent]    ${Facility_Borrower}
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]

Add Repayment Schedule for PDS Syndicate Deal - Facility A
    [Documentation]    This keyword creates Repayment Schedule for Facility A
    ...    @author: shirhong    25JAN2021    - Intial Create
    ...    @update: shirhong    28JAN2021    - Updated modify schdule item keyword
    [Arguments]    ${ExcelPath}

    ### Add Amortization / Repayment Schedule ###
    Navigate to Increase Decrease Schedule from Facility Notebook Window

    Add Amortization Schedule Frequency    &{ExcelPath}[Amortization_Frequency]

    Add Amortization Schedule Status    &{ExcelPath}[Amortization_Status]    &{ExcelPath}[Amortization_ScheduleType]

    Modify Schedule Item for Amortization    &{ExcelPath}[ModifyScheduleItem_Amount]    &{ExcelPath}[ModifyScheduleItem_PercentofCurrent]    &{ExcelPath}[ModifyScheduleItem_Date]

    Add Scheduled Amortization Item    &{ExcelPath}[ScheduleItem_Amount1]    &{ExcelPath}[ScheduleItem_PercentofCurrent1]    &{ExcelPath}[ScheduleItem_Date1]
    Add Scheduled Amortization Item    &{ExcelPath}[ScheduleItem_Amount2]    &{ExcelPath}[ScheduleItem_PercentofCurrent2]    &{ExcelPath}[ScheduleItem_Date2]
    Add Scheduled Amortization Item    &{ExcelPath}[ScheduleItem_Amount3]    &{ExcelPath}[ScheduleItem_PercentofCurrent3]    &{ExcelPath}[ScheduleItem_Date3]
    
    Save and Exit Amortization Schedule for Facility Window

    Close All Windows on LIQ
    
Create Facility B for PDS Syndicate Deal
    [Documentation]    This keyword creates Facility B for PDS Syndicated Deal
    ...    @author: shirhong    28JAN2021    - Intial Create
    ...    @update: shirhong    09FEB2021    - Added writing of Facility Name in Ongoing Fee Setup sheet
    [Arguments]    ${ExcelPath}

    ${Facility_Name}    Auto Generate Only 5 Numeric Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    CRED02_FacilitySetup_B    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    CRED08_OngoingFeeSetup_B    Facility_Name    ${rowid}    ${Facility_Name}
    ${Facility_BorrowerSGName}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid]
    ${Facility_Borrower}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]

    ###Open Deal Notebook If Not present###
    Open Deal Notebook If Not Present    ${Deal_Name}

    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    ${Deal_Name}    ${Facility_Name}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Summary Tab###
    Enter Dates on Facility Summary    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
   
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGAlias]

    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    ${Facility_BorrowerSGName}    &{ExcelPath}[Facility_BorrowerPercent]    ${Facility_Borrower}
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]

Add Repayment Schedule for PDS Syndicate Deal - Facility B
    [Documentation]    This keyword creates Repayment Schedule for Facility B
    ...    @author: shirhong    28JAN2021    - Intial Create
    [Arguments]    ${ExcelPath}

    ### Add Amortization / Repayment Schedule ###
    Navigate to Increase Decrease Schedule from Facility Notebook Window

    Add Amortization Schedule Status    &{ExcelPath}[Amortization_Status]    &{ExcelPath}[Amortization_ScheduleType]

    Modify Schedule Item for Amortization    &{ExcelPath}[ModifyScheduleItem_Amount]    &{ExcelPath}[ModifyScheduleItem_PercentofCurrent]    &{ExcelPath}[ModifyScheduleItem_Date]

    Add Scheduled Amortization Item    &{ExcelPath}[ScheduleItem_Amount1]    &{ExcelPath}[ScheduleItem_PercentofCurrent1]    &{ExcelPath}[ScheduleItem_Date1]
    Add Scheduled Amortization Item    &{ExcelPath}[ScheduleItem_Amount2]    &{ExcelPath}[ScheduleItem_PercentofCurrent2]    &{ExcelPath}[ScheduleItem_Date2]
    Add Scheduled Amortization Item    &{ExcelPath}[ScheduleItem_Amount3]    &{ExcelPath}[ScheduleItem_PercentofCurrent3]    &{ExcelPath}[ScheduleItem_Date3]
    Add Scheduled Amortization Item    &{ExcelPath}[ScheduleItem_Amount4]    &{ExcelPath}[ScheduleItem_PercentofCurrent4]    &{ExcelPath}[ScheduleItem_Date4]
    
    Save and Exit Amortization Schedule for Facility Window

    Close All Windows on LIQ

