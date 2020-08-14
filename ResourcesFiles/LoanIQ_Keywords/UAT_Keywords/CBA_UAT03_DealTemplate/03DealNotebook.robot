*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Setup Deal D00000476
    [Documentation]    This keyword is the template for setting up UAT Deal 3
    ...                @author: bernchua    28JUN2019    Initial create
    [Arguments]    ${ExcelPath}
    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    ${Borrower_ShortName}    Read Data From Excel    ORIG03_Customer    Party_ID    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    ${Borrower_Location}    Read Data From Excel    ORIG03_Customer    Customer_Location    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}

    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_Location    &{ExcelPath}[rowid]    ${Borrower_Location}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower1    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    CRED01_Primaries    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV05_SBLCIssuance    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    SERV01A_LoanDrawdown    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    SERV23_Paperclip    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y 
    Write Data To Excel    SERV40_BreakFunding    Deal_Name   &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    SERV29_CommitmentFeePayment    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    CommitmentFee    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y
    Write Data To Excel    SERV29_Payments    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y    
    Write Data To Excel    AMCH05_ExtendFacility    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y 
    Write Data To Excel    CRED01_UpfrontFee    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y 
    Write Data To Excel    COM06_LoanMerge    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    multipleValue=Y 

    Select Actions    [Actions];Deal
    Screenshot.Take Screenshot    Deal_Notebook
    
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    Unrestrict Deal
    Screenshot.Take Screenshot    Unrestrict_Deal
    ### Summary Tab ###
    Set Deal Borrower    ${Borrower_ShortName}    ${Borrower_Location}
    Set Deal Borrower Servicing Group    &{ExcelPath}[Borrower_SG_Alias]    &{ExcelPath}[Borrower_SG_Name]    &{ExcelPath}[Borrower_ContactName]    &{ExcelPath}[Borrower_PreferredRIMthd1]
    Go To Deal Borrower Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Borrower Setup
    Screenshot.Take Screenshot    Borrower_Setup
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

Setup Deal Bank Role
    [Documentation]    This high-level keyword is used to add a Bank Role in the Deal Notebook.
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${ExcelPath}
    Add Bank Role    &{ExcelPath}[BankRole_Type]    &{ExcelPath}[BankRole_BankName]    &{ExcelPath}[BankRole_SGAlias]    &{ExcelPath}[BankRole_SGName]    &{ExcelPath}[BankRole_SGContactName]
    ...    &{ExcelPath}[BankRole_SGRIMethod]    &{ExcelPath}[BankRole_Portfolio]    &{ExcelPath}[BankRole_ExpenseCode]    &{ExcelPath}[BankRole_ExpenseCodeDesc]
    
Setup Deal Admin Fee
    [Documentation]    This high-level keyword is used to add an Admin Fee in the Deal Notebook.
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${ExcelPath}
    Add Admin Fee in Deal Notebook    &{ExcelPath}[AdminFee_IncomeMethod]
    Set Admin Fee General Details    &{ExcelPath}[AdminFee_AmountType]    &{ExcelPath}[AdminFee_Amount]    &{ExcelPath}[AdminFee_EffectiveDate]    &{ExcelPath}[AdminFee_Frequency]
    Set Distribution Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_Customer]    &{ExcelPath}[AdminFee_CustomerLocation]    &{ExcelPath}[AdminFee_ExpenseCode]    &{ExcelPath}[AdminFee_PercentOfFee]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Accruing Admin Fee    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Approval
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
Setup Deal Calendar
    [Documentation]    This high-level keyword is used to add a Holiday Calendar in the Deal Notebook.
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${ExcelPath}
    Set Deal Calendar    &{ExcelPath}[Deal_Calendar]
    
Setup Deal Interest Pricing Options
    [Documentation]    This high-level keyword is used to add Interest Pricing Options in the Deal Notebook
    ...                @author: bernchua    09JUL2019    Intiial create
    [Arguments]    ${ExcelPath}
    Click Add Option In Pricing Rules
    ${RoundingDecimalPrecision}    Set Variable    &{ExcelPath}[RoundingDecimalPrecision]
    Set Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    sRoundingDecimalPrecision=${RoundingDecimalPrecision}
    Set Rounding Application Method    &{ExcelPath}[RoundingApplicationMethod]
    Set Percent Of Rate Formula Usage    &{ExcelPath}[PercentOfRateFormulaUsage]
    Set Non Business Day Rule    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[RepricingNonBusinessDayRule]
    Set Change Application Method    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Run Keyword If    '&{ExcelPath}[rowid]'!='5'    Run Keywords
    ...    Tick Interest Due Upon Repciring Checkbox
    ...    AND    Tick Interest Due Upon Principal Payment Checkbox
    ${MinDrawAmount}    Set Variable    &{ExcelPath}[MinimumPaymentAmount]
    ${MinAmountMultiples}    Set Variable    &{ExcelPath}[MinimumAmountMultiples]
    Run Keyword If    '&{ExcelPath}[rowid]'=='3' or '&{ExcelPath}[rowid]'=='4'    Set Interest Pricing Option Amounts And Multiples    iMinPayAmount=${MinDrawAmount}
    ...    ELSE    Set Interest Pricing Option Amounts And Multiples    iMinPayAmount=${MinDrawAmount}    iMinAmountMultiples=${MinAmountMultiples}
    Click OK In Interest Pricing Option Details Window
    Validate Added Deal Pricing Option    &{ExcelPath}[Deal_PricingOption]
    
Setup Deal Fee Pricing Rules
    [Documentation]    This high-level keyword is used to add Fee Pricing Rules in the Deal Notebook
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${ExcelPath}
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee2]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd2]    &{ExcelPath}[PricingRule_NonBussDayRule2]
   
Setup Primaries D00000476
    [Documentation]    This keyword adds Primary Lender for Deal 3 Deal Template
    ...    @author: ritragel
    [Arguments]    ${ExcelPath}

    ###Primary Lender - Host Bank###
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender]    &{ExcelPath}[Primary_LenderLoc]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    
    ###Primary Tab###
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    Select Servicing Group on Primaries    None    &{ExcelPath}[BankRole_SGAlias]
    ${SellAmount}    Get Circle Notebook Sell Amount
    Write Data To Excel    CRED01_DealSetup    Primary_PortfolioAllocation    ${rowid}    ${SellAmount}    ${CBAUAT_ExcelPath}
    
    ####Complete Portfolio Allocations###
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]
    ...    &{ExcelPath}[Primary_PortfolioAllocation1]|&{ExcelPath}[Primary_PortfolioAllocation2]|&{ExcelPath}[Primary_PortfolioAllocation3]|&{ExcelPath}[Primary_PortfolioAllocation4]
    ...    None|None|None|None
    ...    &{ExcelPath}[Facility_Name1]|&{ExcelPath}[Facility_Name2]|&{ExcelPath}[Facility_Name3]|&{ExcelPath}[Facility_Name4]
    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]
    Send to Settlement Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Deal_Name]    Host Bank
    
    ###Login to Original User### 
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
Approve and Close UAT Deal
    [Documentation]    This keyword Approves and Closes the Deal
    ...                @author: bernchua    16JUL2019    Initial create
    [Arguments]    ${ExcelPath}
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
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
