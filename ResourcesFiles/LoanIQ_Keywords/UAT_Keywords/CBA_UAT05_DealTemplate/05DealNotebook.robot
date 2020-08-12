*** Settings ***
Resource    ../../../../Configurations/Import_File.robot

*** Keywords ***
Setup Deal D00001151
    [Documentation]    This keyword is the template for setting up UAT Deal 5
    ...                @author: hstone    09AUG2019    Initial create
    [Arguments]    ${ExcelPath}
    
    ### New Deal Name Generation ###
    ${Current_Date}    Get System Date
    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    
    ### Fetch Borrower Details ###
    ${Borrower_LegalName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_LegalName    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    ${Borrower_ShortName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_ShortName    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}   
    ${Borrower_Location}    Read Data From Excel    ORIG03_Customer    Customer_Location    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    ${Borrower_LegalName}    Convert To Uppercase    ${Borrower_LegalName}
    
    ### Save Test Data ###
    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_Location    &{ExcelPath}[rowid]    ${Borrower_Location}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Location    &{ExcelPath}[rowid]    ${Borrower_Location}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Borrower_LegalName    &{ExcelPath}[rowid]    ${Borrower_LegalName}    ${CBAUAT_ExcelPath}    Y
    
    ### Fetch Test Data ###
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name   &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    
    ### New Deal Create ###
    Select Actions    [Actions];Deal
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    Unrestrict Deal
   
    ### Summary Tab ###
    Set Deal Borrower    ${Borrower_ShortName}    ${Borrower_Location}
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
    Save Changes on Deal Notebook
    
    ### Personnel Tab ###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ### Calendars Tab ###    
    Set Deal Calendar    &{ExcelPath}[Deal_Calendar]
    
    ### Pricing Rules Tab ###
    Click Add Option In Pricing Rules
    Set Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]
    Set Rounding Application Method    &{ExcelPath}[RoundingApplicationMethod]
    Set Percent Of Rate Formula Usage    &{ExcelPath}[PercentOfRateFormulaUsage]
    Set Non Business Day Rule    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[RepricingNonBusinessDayRule]
    Set Change Application Method    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Tick Interest Due Upon Principal Payment Checkbox 
    Click OK In Interest Pricing Option Details Window
    Validate Added Deal Pricing Option    &{ExcelPath}[Deal_PricingOption]
  
Setup Primaries for Deal D00001151
    [Documentation]    This high-level keyword sets up the Lender for the UAT Deal 5
    ...                @author: hstone    15AUG2019    Initial create
    [Arguments]    ${ExcelPath}
    ### Get Needed Test Data ###
    ${Facility_Name1}    Read Data From Excel    CRED01_DealSetup    Facility_Name    1    ${CBAUAT_ExcelPath}    
    ${Facility_Name2}    Read Data From Excel    CRED01_DealSetup    Facility_Name    2    ${CBAUAT_ExcelPath}
    ${Facility_Name3}    Read Data From Excel    CRED01_DealSetup    Facility_Name    3    ${CBAUAT_ExcelPath}
    ${Facility_Expiry1}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    1    ${CBAUAT_ExcelPath}
    ${Facility_Expiry2}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    2    ${CBAUAT_ExcelPath}
    ${Facility_Expiry3}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    3    ${CBAUAT_ExcelPath}
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1    ${CBAUAT_ExcelPath}
    
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
    Navigate Notebook Workflow    ${LIQ_OrigPrimaries_Window}    ${LIQ_OrigPrimaries_Tab}    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Send to Settlement Approval
    Validate Window Title Status    Orig Primary    Awaiting Settlement Approval
    
    ### Save and Exit
    Circle Notebook Save And Exit
    Exit Primaries List Window
    
    ### Work In Process - Settlment Approval
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    ${Deal_Name}    Host Bank
    
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}

Approve and Close Deal D00001151
    [Documentation]    This keyword Approves and Closes the Deal
    ...                @author: bernchua    16JUL2019    Initial create
    [Arguments]    ${ExcelPath}
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Send to Approval
    Logout from LIQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Approval
    Enter Deal Approved Date    &{ExcelPath}[Deal_ApprovalDate]
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Close
    Enter Deal Close Date    &{ExcelPath}[Deal_CloseDate]
    Verify Deal Status After Deal Close
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
