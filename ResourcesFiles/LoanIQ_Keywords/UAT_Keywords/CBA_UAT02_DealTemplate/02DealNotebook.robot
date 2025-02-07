*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Setup Deal D00001053
    [Documentation]    This keyword is the template for setting up UAT Deal 2
    ...                @author: bernchua    28JUN2019    Initial create
    ...                @update: bernchua    21AUG2019    Added keyword for setting Deal as Sole Lender
    ...                @update: rmendoza    26AUG2020    converted borrower name to upppercase
    [Arguments]    ${ExcelPath}
    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    ${Borrower_ShortName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_ShortName    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}   
    ${Borrower_Location}    Read Data From Excel    ORIG03_Customer    Customer_Location    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_Location    &{ExcelPath}[rowid]    ${Borrower_Location}    ${CBAUAT_ExcelPath}
    Write Data To Excel    Correspondence    Deal_Name    16    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    UAT02_Runbook    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    UAT02_Runbook    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    
    Select Actions    [Actions];Deal
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    Unrestrict Deal
    
    ### Summary Tab ###
    ${Converted_BorrowerName}    Convert To UpperCase    ${Borrower_ShortName}
    Set Deal Borrower    ${Converted_BorrowerName}    ${Borrower_Location}
    Set Deal Borrower Servicing Group    &{ExcelPath}[Borrower_SG_Alias]    &{ExcelPath}[Borrower_SG_Name]    &{ExcelPath}[Borrower_ContactName]    &{ExcelPath}[Borrower_PreferredRIMthd1]
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
    Click Add Option In Pricing Rules
    Set Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]
    Set Pricing Option Currency    &{ExcelPath}[PricingOption_CCY]
    Set Rounding Application Method    &{ExcelPath}[RoundingApplicationMethod]
    Set Percent Of Rate Formula Usage    &{ExcelPath}[PercentOfRateFormulaUsage]
    Set Non Business Day Rule    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[RepricingNonBusinessDayRule]
    Set Change Application Method    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Tick Interest Due Upon Principal Payment Checkbox
        
    Click OK In Interest Pricing Option Details Window
    Validate Added Deal Pricing Option    &{ExcelPath}[Deal_PricingOption]
    
    ### Admin/Event Fees Tab ###
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee_Name]    &{ExcelPath}[EventFee_Amount]    &{ExcelPath}[EventFee_Type]    
        
Setup Primaries for Deal D00001053
    [Documentation]    This high-level keyword sets up the Lender for the UAT Deal 2
    ...                @author: bernchua    19JUL2019    Initial create
    ...                @update: bernchua    21AUG2019    Updates made on keywords 'Add Lender and Location' and 'Circle Notebook Portfolio Allocation Per Facility'
    ...                                                  Removed Settlement Approval workflow
    [Arguments]    ${ExcelPath}
    ${Facility_Name1}    Read Data From Excel    CRED01_DealSetup    Facility_Name    1    ${CBAUAT_ExcelPath}    
    ${Facility_Name2}    Read Data From Excel    CRED01_DealSetup    Facility_Name    2    ${CBAUAT_ExcelPath}
    ${Facility_Name3}    Read Data From Excel    CRED01_DealSetup    Facility_Name    3    ${CBAUAT_ExcelPath}
    ${Facility_Expiry1}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    1    ${CBAUAT_ExcelPath}
    ${Facility_Expiry2}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    2    ${CBAUAT_ExcelPath}
    ${Facility_Expiry3}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    3    ${CBAUAT_ExcelPath}
    
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
    ${SellAmount3}    Get Circle Notebook Sell Amount Per Facility    ${Facility_Name3}
    Write Data To Excel    CRED01_DealSetup    PrimaryFacility_Allocation    1    ${SellAmount1}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    PrimaryFacility_Allocation    2    ${SellAmount2}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    PrimaryFacility_Allocation    3    ${SellAmount3}    ${CBAUAT_ExcelPath}
    
    ### Save and Exit
    Circle Notebook Save And Exit
    
    ### Circle Notebook Portfolio Allocation
    Open Lender Circle Notebook From Primaries List    &{ExcelPath}[Primary_Lender]
    Click Portfolio Allocations from Circle Notebook
    Circle Notebook Portfolio Allocation Per Facility    ${Facility_Name1}    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount1}    ${Facility_Expiry1}    &{ExcelPath}[Primary_RiskBookExpCode]    ${ExpCode_Description}
    Circle Notebook Portfolio Allocation Per Facility    ${Facility_Name2}    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount2}    ${Facility_Expiry2}    &{ExcelPath}[Primary_RiskBookExpCode]    ${ExpCode_Description}
    Circle Notebook Portfolio Allocation Per Facility    ${Facility_Name3}    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${SellAmount3}    ${Facility_Expiry3}    &{ExcelPath}[Primary_RiskBookExpCode]    ${ExpCode_Description}
    Complete Circle Notebook Portfolio Allocation
    
    ### Workflow Tab - Circling and Sending to Settlement Approval
    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]
    Circle Notebook Save And Exit
    Exit Primaries List Window
    
