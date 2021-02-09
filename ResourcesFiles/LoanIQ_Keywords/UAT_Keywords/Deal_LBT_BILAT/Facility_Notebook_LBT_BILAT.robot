*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Class A Note Facility for LBT Bilateral Deal
    [Documentation]    This keyword creates Class A Note Facility for LBT Bilateral Deal
    ...    @author: javinzon    10DEC2020    - Intial create
    ...    @update: javinzon    16DEC2020    - Added Write Data To Excel of Facility Name for CRED08_OngoingFeeSetup
    ...    @update: javinzon    18DEC2020    - Added keywords Write Data to Excel for Facility_Name of SERV01_LoanDrawdown
    ...    @update: javinzon    13JAN2021    - Added keyword Write Data to Excel for Facility_Name of Correspondence rows 1 and 2.
    ...    @update: javinzon    26JAN2021    - Added argument 'multipleValue=Y' when writing FacilityName in SERV01_LoanDrawdown
    [Arguments]    ${ExcelPath}

    ${Facility_Name}    Auto Generate Only 5 Numeric Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    CRED01_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    multipleValue=Y    bTestCaseColumn=True    sColumnReference=rowid
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

Change Facility Expiry Date for LBT Bilateral Deal
    [Documentation]    This keyword is used to update the Facility Expiry Date of LBT Bilateral Deal via Facility Change Transaction
    ...    @author: javinzon    05FEB2021    - Initial create
    [Arguments]    ${ExcelPath}
   
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
    ${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    ${rowid}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Add Facility Change Transaction
    Update Expiry Date in Facility Change Transaction	&{ExcelPath}[New_ExpiryDate]

    ### Send To Approval ###
    Send to Approval Facility Change Transaction

    ### Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Approve Facility Change Transaction    ${Deal_Name}

    ### Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Release Facility Change Transaction    ${Deal_Name}

    ### Validate Released Event ###
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name}
    Validate Released Facility Change Transaction
    Validate and Compare Maturity and Expiry Date in Facility Change Transaction	&{ExcelPath}[MaturityDate]    &{ExcelPath}[New_ExpiryDate]
    Close All Windows on LIQ

Create Pricing Change Transaction for LBT Bilateral Deal
    [Documentation]    The keyword will Create Pricing Change Transaction for LBT Bilateral Deal.
    ...    @author: javinzon    05FEB2021    - Initial create
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
    ${Facility_Name}    Read Data From Excel    CRED01_FacilitySetup    Facility_Name    ${rowid}
    
    ### Update Ongoing Fee and Interest Pricing ###
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Pricing Change Transaction Menu
    Input Pricing Change Transaction General Information    ${Deal_Name}    ${Facility_Name}    &{ExcelPath}[PricingChange_TransactionNo]    &{ExcelPath}[PricingChange_EffectiveDate]    &{ExcelPath}[PricingChange_Desc]
    Navigate to Modify Ongoing Fees Window from PCT Notebook
    Clear Ongoing Fee Pricing Current Values
    Insert Add in Modify Ongoing Fees of Pricing Change Transaction    &{ExcelPath}[Facility_Item]    &{ExcelPath}[Fee_Type]    &{ExcelPath}[Rate_Basis]  
    Insert After in Modify Ongoing Fees of Pricing Change Transaction    &{ExcelPath}[Facility_Item_After]    &{ExcelPath}[Facility_Percent]
    Validate Ongoing Fee or Interest
    Click OK Button in Ongoing Fees Window
    
    ### Send to Approval ###
    Select Pricing Change Transaction Send to Approval
    Logout from Loan IQ

    ### Approval ###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Pricing Change Transaction Menu
    Approve Price Change Transaction
    Logout from Loan IQ

    ### Release ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${FACILITIES_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${PRICING_CHANGE_TRANSACTION}     ${Facility_Name}
    Select Pricing Change Transaction Release
    Close All Windows on LIQ
   
    ### Validate Released Event ###
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Validate an Event in Events Tab    ${PRICING_CHANGE_TRANSACTION_RELEASED}
    Validate Updated Ongoing Fees in Facility Notebook    &{ExcelPath}[OngoingFee_NewRate]
    Close All Windows on LIQ
    Open Deal Notebook If Not Present    ${Deal_Name}
    Navigate Directly to Commitment Fee Notebook from Deal Notebook    ${Facility_Name}
    Validate New Rate in General Tab of Commitment Fee Notebook    &{ExcelPath}[PricingFormula_InEffect]    &{ExcelPath}[Current_Rate]
    
