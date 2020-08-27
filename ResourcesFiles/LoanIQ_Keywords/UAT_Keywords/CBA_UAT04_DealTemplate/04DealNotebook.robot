*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Deal D00000963
    [Documentation]    This high-level keyword is for setting up UAT Deal 4 (D00000963).
    ...                @author: bernchua    19AUG2019    Initial create
    ...                @update: bernchua    21AUG2019    Added keyword for setting Deal as Sole Lender
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    ${Borrower_ShortName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_ShortName    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}   
    ${Borrower_Location}    Read Data From Excel    ORIG03_Customer    Customer_Location    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_Location    &{ExcelPath}[rowid]    ${Borrower_Location}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    CRED02_FacilitySetup    Interest_OptionName    &{ExcelPath}[rowid]    &{ExcelPath}[Deal_PricingOption]    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV01_LoanDrawdown    Pricing_Option    &{ExcelPath}[rowid]    &{ExcelPath}[Deal_PricingOption]    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    UAT04_Fees    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    UAT04_Fees    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y    
    Write Data To Excel    UAT04_Runbook    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    UAT04_Runbook    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    
    Select Actions    [Actions];Deal
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    Unrestrict Deal
    
    ### Summary Tab ###
    Set Deal Borrower    ${Borrower_ShortName}    ${Borrower_Location}
    Set Deal Borrower Servicing Group    &{ExcelPath}[Borrower_SG_Alias]    &{ExcelPath}[Borrower_SG_Name]    &{ExcelPath}[Borrower_ContactName]    &{ExcelPath}[Borrower_PreferredRIMthd]
    Go To Deal Borrower Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Borrower Setup
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Set Deal Admin Agent Servicing Group    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_SGName]    &{ExcelPath}[AdminAgent_ContactName]    &{ExcelPath}[AdminAgent_RIMethod]
    Go To Admin Agent Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Admin Agent Setup
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Enter Agreement Date and Proposed Commitment Amount    &{ExcelPath}[Deal_AgreementDate]    &{ExcelPath}[Deal_ProposedCmt]
    Set Deal as Sole Lender
    Save Changes on Deal Notebook

    
    ### Personnel Tab ###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ### Calendars Tab ###
    Set Deal Calendar    &{ExcelPath}[Deal_Calendar]
    
    ### Pricing Rules Tab ###
    ${RoundingDecimalPrecision}    Set Variable    &{ExcelPath}[RoundingDecimal_Precision]
    ${MinPayAmount}    Set Variable    &{ExcelPath}[MinimumPaymentAmount]
    ${MinAmountMultiples}    Set Variable    &{ExcelPath}[MinimumAmountMultiples]
    Click Add Option In Pricing Rules
    Set Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    sRoundingDecimalPrecision=${RoundingDecimalPrecision}
    Set Rounding Application Method    &{ExcelPath}[RoundingApplicationMethod]
    Set Percent Of Rate Formula Usage    &{ExcelPath}[PercentOfRateFormulaUsage]
    Set Non Business Day Rule    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[RepricingNonBusinessDayRule]
    Set Change Application Method    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Set Interest Pricing Option Amounts And Multiples    sMinPayAmount=${MinPayAmount}    sMinAmountMultiples=${MinAmountMultiples}
    Tick Interest Due Upon Repciring Checkbox
    Tick Interest Due Upon Principal Payment Checkbox
    Set Pricing Option Intent Notice Details    &{ExcelPath}[IntentNotice_DaysInAdvance]    &{ExcelPath}[IntentNotice_Time]    &{ExcelPath}[IntentNotice_AMPM]
    Click OK In Interest Pricing Option Details Window
    Validate Added Deal Pricing Option    &{ExcelPath}[Deal_PricingOption]
    
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]
    
    
Setup Primaries for Deal D00000963
    [Documentation]    This high-level keyword sets up the Lender for the UAT Deal 4
    ...                @author: bernchua    20AUG2019    Initial create
    ...                @update: bernchua    21AUG2019    Removed Settlement Approval workflow
    [Arguments]    ${ExcelPath}
    ${Facility_Name1}    Read Data From Excel    CRED01_DealSetup    Facility_Name    1    ${CBAUAT_ExcelPath}    
    ${Facility_Name2}    Read Data From Excel    CRED01_DealSetup    Facility_Name    2    ${CBAUAT_ExcelPath}
    ${Facility_Expiry1}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    1    ${CBAUAT_ExcelPath}
    ${Facility_Expiry2}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    2    ${CBAUAT_ExcelPath}
    
    ### Add Host Bank Primary Lender
    ${ExpCode_Description}    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender]    &{ExcelPath}[Primary_LenderLoc]    &{ExcelPath}[Primary_RiskBookExpCode]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    
    ### Primary Servicing Group Remittance Instruction validation.
    Open Primary Servicing Groups
    Validate Primary SG Remittance Instructions    &{ExcelPath}[Primary_SGRIMethod]
    Complete Primary Servicing Group Setup
    
    ### Get Sell Amount Data and store to Excel for Portfolio Allocation    
    ${SellAmount1}    Get Circle Notebook Sell Amount Per Facility    ${Facility_Name1}
    ${SellAmount2}    Get Circle Notebook Sell Amount Per Facility    ${Facility_Name2}
    Write Data To Excel    CRED01_DealSetup    PrimaryFacility_Allocation    1    ${SellAmount1}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    PrimaryFacility_Allocation    2    ${SellAmount2}    ${CBAUAT_ExcelPath}
    
    ### Save and Exit
    Circle Notebook Save And Exit
    
    ### Circle Notebook Portfolio Allocation
    Open Lender Circle Notebook From Primaries List    &{ExcelPath}[Primary_Lender]
    Click Portfolio Allocations from Circle Notebook
    Circle Notebook Portfolio Allocation Per Facility    ${Facility_Name1}    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount1}    ${Facility_Expiry1}    &{ExcelPath}[Primary_RiskBookExpCode]    ${ExpCode_Description}
    Circle Notebook Portfolio Allocation Per Facility    ${Facility_Name2}    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount2}    ${Facility_Expiry2}    &{ExcelPath}[Primary_RiskBookExpCode]    ${ExpCode_Description}
    Complete Circle Notebook Portfolio Allocation
    
    ### Workflow Tab - Circling and Sending to Settlement Approval
    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]
    Circle Notebook Save And Exit
    Exit Primaries List Window
    
    
Approve and Close UAT Deal D00000963
    [Documentation]    This keyword Approves, Closes the Deal, and gets the Ongoing Fee Alias of the Facilities after Deal Close
    ...                @author: bernchua    17SEP2019    Initial create
    [Arguments]    ${ExcelPath}
    
    ${Facility1_Name}    Read Data From Excel    CRED01_DealSetup    Facility_Name    1    ${CBAUAT_ExcelPath}
    ${Facility2_Name}    Read Data From Excel    CRED01_DealSetup    Facility_Name    2    ${CBAUAT_ExcelPath}
    
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Approval
    Enter Deal Approved Date    &{ExcelPath}[Deal_ApprovedDate]
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Close
    Enter Deal Close Date    &{ExcelPath}[Deal_CloseDate]
    Verify Deal Status After Deal Close
    
    ${OngoingFee_Alias1}    Get Facility Ongoing Fee Alias    ${Facility1_Name}
    ${OngoingFee_Alias2}    Get Facility Ongoing Fee Alias    ${Facility2_Name}
    Write Data To Excel    UAT04_Fees    OngoingFee_Alias    1    ${OngoingFee_Alias1}    ${CBAUAT_ExcelPath}
    Write Data To Excel    UAT04_Fees    OngoingFee_Alias    2    ${OngoingFee_Alias2}    ${CBAUAT_ExcelPath}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    
