*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Setup Deal D00000454
    [Documentation]    This keyword is the template for setting up UAT Deal 1
    ...                @author: fmamaril    20AUG2019    Initial create
    ...                @update: fmamaril    03SEP2019    Add writing of deal name to SERV29
    [Arguments]    ${ExcelPath}
    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    ${Borrower_ShortName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_ShortName    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}   
    ${Borrower_Location}    Read Data From Excel    ORIG03_Customer    Customer_Location    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED01_DealSetup    Borrower_Location    &{ExcelPath}[rowid]    ${Borrower_Location}    ${CBAUAT_ExcelPath}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    CRED01_Primaries    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y    
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    &{ExcelPath}[rowid]    ${Borrower_ShortName}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y    
    Write Data To Excel    SERV29_CommitmentFeePayment    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    AMCH04_DealChangeTransaction    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    
    Write Data To Excel    SERV40_BreakFunding    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV23_Paperclip    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}    Y
    Write Data To Excel    COMPR06_LoanMerge    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    ${CBAUAT_ExcelPath}
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
        
    ###Deal Notebook - Ratios/Conds Tab###
    Add Financial Ratio    &{ExcelPath}[Ratio_Type]    &{ExcelPath}[Financial_Ratio]    &{ExcelPath}[Ratio_StartDate]
    
    ###Add Multiple Bank Roles###
    Add Multiple Bank Roles    &{ExcelPath}[BankRole_BankName]    &{ExcelPath}[BankRole_SGAlias]    &{ExcelPath}[BankRole_SGName]    &{ExcelPath}[BankRole_SGContactName]
    ...    &{ExcelPath}[BankRole_SGRIMethod]    &{ExcelPath}[BankRole_Portfolio]    &{ExcelPath}[BankRole_ExpenseCode]    &{ExcelPath}[BankRole_ExpenseCodeDesc]
    ...    &{ExcelPath}[Reference_Bank]    &{ExcelPath}[Bid_Bank]    &{ExcelPath}[SBLC_Issuer]    &{ExcelPath}[Swingline_Bank]    &{ExcelPath}[BA_Issuing_Bank]
    ...    &{ExcelPath}[BA_Reference_Bank]    &{ExcelPath}[BA_Owner_Bank]    &{ExcelPath}[RAC_Reference_Bank]    &{ExcelPath}[BankRole_Percent]
    
    ###Add Fee Pricing Rules###
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee2]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd2]    &{ExcelPath}[PricingRule_NonBussDayRule2]    

Setup Deal D00000454 Interest Pricing Options
    [Documentation]    This high-level keyword is used to add Interest Pricing Options in the Deal Notebook
    ...                @author: fmamaril    21AUG2019    Intiial create
    [Arguments]    ${ExcelPath}
    Click Add Option In Pricing Rules
    ${RoundingDecimalPrecision}    Set Variable    &{ExcelPath}[RoundingDecimalPrecision]
    Set Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    sRoundingDecimalPrecision=${RoundingDecimalPrecision}
    Set Rounding Application Method    &{ExcelPath}[RoundingApplicationMethod]
    Set Percent Of Rate Formula Usage    &{ExcelPath}[PercentOfRateFormulaUsage]
    Set Non Business Day Rule    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[RepricingNonBusinessDayRule]
    Set Change Application Method    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Run Keywords
    ...    Tick Interest Due Upon Repciring Checkbox
    ...    AND    Tick Interest Due Upon Principal Payment Checkbox
    Click OK In Interest Pricing Option Details Window
    Validate Added Deal Pricing Option    &{ExcelPath}[Deal_PricingOption]    
  
Setup Deal Amortizing Admin Fee
    [Documentation]    This high-level keyword is used to add an Admin Fee in the Deal Notebook.
    ...                @author: fmamaril    21AUG2019    Initial create
    [Arguments]    ${ExcelPath}
    Add Admin Fee in Deal Notebook    &{ExcelPath}[AdminFee_IncomeMethod]
    Set Amortizing Admin Fee General Details    &{ExcelPath}[AdminFee_AmountType]    &{ExcelPath}[AdminFee_Amount]    &{ExcelPath}[AdminFee_EffectiveDate]    &{ExcelPath}[AdminFee_Frequency]
    Set Distribution Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_Customer]    &{ExcelPath}[AdminFee_CustomerLocation]    &{ExcelPath}[AdminFee_ExpenseCode]    &{ExcelPath}[AdminFee_PercentOfFee]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Amortizing Admin Fee    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Approval
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
Setup Initial Primary Details for D00000454
    [Documentation]    This keyword sets up the Primary in a Syndicated Deal for Secondary Sale.
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Add Host Bank Primary Lender
    ${ExpCode_Description}    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Lender]    &{ExcelPath}[Primary_LenderLoc]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    
Setup Multiple Facility Sell Amounts for D00000454
    [Documentation]    This keyword sets up Multiple Facility Sell Amount.
    ...    @author: fmamaril    27AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    Log    To be updated
    # Set Facility Sell Amounts in Primaries    &{ExcelPath}[Facility_Name1]    &{ExcelPath}[Sell_Amount1]
    # Run Keyword If    '&{ExcelPath}[rowid]'!='3'    Set Facility Sell Amounts in Primaries    &{ExcelPath}[Facility_Name2]    &{ExcelPath}[Sell_Amount2]
    
Complete Primaries for D00000454
    [Documentation]    This keyword completes Primaries for Syndicated Deal-Multiple Facility.
    ...    @author: fmamaril    27AUG2019    Initial Create    
    [Arguments]    ${ExcelPath}
    ###Primaries###     
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]    
    Run Keyword If    '&{ExcelPath}[rowid]'=='1'    Run Keywords    Navigate to Portfolio Allocations from Circle Notebook
    ...    AND    Circle Notebook Portfolio Allocation Per Facility    &{ExcelPath}[Facility_Name1]    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Sell_Amount1]    &{ExcelPath}[Primary_ExpiryDate]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[ExpenseCode_Description]
    ...    AND    Circle Notebook Portfolio Allocation Per Facility    &{ExcelPath}[Facility_Name2]    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Sell_Amount2]    &{ExcelPath}[Primary_ExpiryDate]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[ExpenseCode_Description]
    ...    AND    Complete Circle Notebook Portfolio Allocation
    
    ###Workflow Tab - Circling and Sending to Settlement Approval###
    Circling for Primary Workflow    &{ExcelPath}[Primary_CircleDate]
    Navigate Notebook Workflow    ${LIQ_OrigPrimaries_Window}    ${LIQ_OrigPrimaries_Tab}    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Send to Settlement Approval
    Validate Window Title Status    Orig Primary    Awaiting Settlement Approval
    
    ###Save and Exit###
    Circle Notebook Save And Exit
    Exit Primaries List Window

Settlement Approval for D00000454
    [Documentation]    This keyword completes settlement approval for Syndicated Deal-Multiple Facility.
    ...    @author: fmamaril    27AUG2019    Initial Create       
    [Arguments]    ${ExcelPath}      
    ## Work In Process - Settlment Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Deal_Name]    Host Bank
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender2]    Non-Host Bank
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender3]    Non-Host Bank
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]

Create Upfront Fee for D00000454
    [Documentation]    This keyword creates an Upfront Fee for a deal.
    ...    @author: fmamaril    27AUG2019    Initial Create       
    [Arguments]    ${ExcelPath}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Set Deal Upfront Fees    &{ExcelPath}[UpfrontFee_Category]    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[UpfrontFee_RateBasis]    Flat Amount    &{ExcelPath}[UpfrontFee_Amount]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Category]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Type]
    Validate Upfront Fee Pricing    &{ExcelPath}[UpfrontFee_Amount]
    Populate Upfront Fee Payment Notebook    &{Excelpath}[UpfrontFee_Amount]    &{Excelpath}[EstablishmentFee_EffectiveDate]        
    Populate Fee Details Window    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[UpfrontFeePayment_Comment]
    
    ###Upfront Fee Payment Workflow Tab- Create Cashflow Item###
    Navigate Notebook Workflow    ${LIQ_UpfrontFeePayment_Notebook}    ${LIQ_UpfrontFeePayment_Tab}    ${LIQ_UpfrontFeePayment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Borrower_PreferredRIMthd]
    Create Cashflow    &{ExcelPath}[Borrower_ShortName]    release     
 
    ###Upfront Fee Payment Workflow Tab- Send to Approval Item###
    Send to Approval Upfront Fee Payment    
    
    ###Upfront Fee Payment Workflow Tab- Approval Item###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}   ${SUPERVISOR_PASSWORD}
    Navigate to Payment Notebook via WIP    Payments    Awaiting Approval    Fee Payment From Borrower    &{ExcelPath}[Deal_Name]    
    Approve Upfront Fee Payment
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_UpfrontFeePayment_Tab}    ${LIQ_UpfrontFeePayment_WorkflowItems}    Release

                 
