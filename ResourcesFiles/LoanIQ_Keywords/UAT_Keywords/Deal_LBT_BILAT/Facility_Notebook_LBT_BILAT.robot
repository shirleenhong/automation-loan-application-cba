*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Class A Note Facility for LBT Bilateral Deal
    [Documentation]    This keyword creates Class A Note Facility for LBT Bilateral Deal
    ...    @author: javinzon    10DEC2020    - Intial create
    ...    @update: javinzon    16DEC2020    - Added Write Data To Excel of Facility Name for CRED08_OngoingFeeSetup
    ...    @update: javinzon    18DEC2020    - Added keywords Write Data to Excel for Facility_Name of SERV01_LoanDrawdown
    ...    @update: javinzon    13JAN2021    - Added keyword Write Data to Excel for Facility_Name of Correspondence rows 1 and 2.
    [Arguments]    ${ExcelPath}

    ${Facility_Name}    Auto Generate Only 5 Numeric Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    CRED01_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    2    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    3    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Facility_Name    2    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
   
    ${Facility_ServicingGroup}    Read Data From Excel    CRED01_DealSetup    AdminAgent_SGName    &{ExcelPath}[rowid] 
    ${Facility_Customer}    Read Data From Excel    CRED01_DealSetup    Deal_AdminAgent    &{ExcelPath}[rowid] 
    ${Facility_SGLocation}    Read Data From Excel    CRED01_DealSetup    AdminAgent_Location    &{ExcelPath}[rowid] 
    ${Facility_BorrowerSGName}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid]
    ${Facility_Borrower}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]

    ### Open Deal Notebook if not present ###
    Open Deal Notebook If Not Present    ${Deal_Name}

    ### New Facility Screen ###
    ${Facility_ProposedCmtAmt}    New Facility Select    ${Deal_Name}    ${Facility_Name}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ### Facility Notebook - Summary Tab ###
    Enter Dates on Facility Summary    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[Facility_EffectiveDate]    &{ExcelPath}[Facility_ExpiryDate]    &{ExcelPath}[Facility_MaturityDate]
    Verify Main SG Details    ${Facility_ServicingGroup}    ${Facility_Customer}    ${Facility_SGLocation}
    
    ### Facility Notebook - Types/Purpose Tab ###
    Add Risk Type    &{ExcelPath}[Facility_RiskType]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
   
    ### Facility Notebook - Restrictions Tab ###
    Add Currency Limit    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGAlias]

    ### Facility Notebook - Sublimit/Cust Tab ###
    Add Borrower    &{ExcelPath}[Facility_Currency]    ${Facility_BorrowerSGName}    &{ExcelPath}[Facility_BorrowerPercent]    ${Facility_Borrower}
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    &{ExcelPath}[Facility_EffectiveDate]
