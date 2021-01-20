*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Facility for PDS Syndicate Deal
    [Documentation]    This keyword creates Capitalization Facility for CH EDU Bilateral Deal
    ...    @author: shirhong    18JAN2021    - Intial Create
    [Arguments]    ${ExcelPath}

    ${Facility_Name}    Auto Generate Only 5 Numeric Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    CRED02_FacilitySetup_A    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
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
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGAlias]

    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency]    ${Facility_BorrowerSGName}    &{ExcelPath}[Facility_BorrowerPercent]    ${Facility_Borrower}
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]
