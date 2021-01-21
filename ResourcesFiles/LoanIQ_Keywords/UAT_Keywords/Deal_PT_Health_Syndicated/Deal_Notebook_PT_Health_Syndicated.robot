*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Syndicated Deal for PT Health Syndicated
    [Documentation]    This keyword is used to create a Syndicated Deal for PT Health
    ...    @author: songchan    04JAN2021    - initial create
    ...    @update: songchan    14JAN2021    - Change keyword for pricing option and added holiday calendar
    [Arguments]    ${ExcelPath}
    
    ###Data Generation###
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias with Numeric Test Data    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]    5
    
    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]  
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    &{ExcelPath}[rowid] 
    ${Borrower_SGAlias}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SGAlias    &{ExcelPath}[rowid] 
    ${Borrower_SG_GroupMembers}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_GroupMembers    &{ExcelPath}[rowid] 
    ${Borrower_PreferredRIMthd}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_PreferredRIMthd    &{ExcelPath}[rowid] 
    ${Borrower_SG_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid] 
    ${Borrower_Depositor_Indicator}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_Depositor_Indicator    &{ExcelPath}[rowid] 

    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SYND02_PrimaryAllocation    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SERV29_CommitmentFeePayment    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    
    ###Deal Select Window###
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]
    
    ###Summary Tab###
    Unrestrict Deal
        
    ###Deal Borrower Setup###
    Add Deal Borrower    ${Borrower_ShortName}
    Select Deal Borrower Location and Servicing Group    ${Borrower_Location}    ${Borrower_SGAlias}    ${Borrower_SG_GroupMembers}    ${Borrower_PreferredRIMthd}    ${Borrower_ShortName}    ${Borrower_SG_Name}
    Select Deal Borrower Remmitance Instruction    ${Borrower_ShortName}    ${Deal_Name}    ${Borrower_Location}    ${Borrower_Depositor_Indicator}
    
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    ###Deal Admin Agent Setup###
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]    &{ExcelPath}[Deal_AdminAgent]  
    Enter Agreement Date and Proposed Commitment Amount    &{ExcelPath}[Deal_AgreementDate]    &{ExcelPath}[Deal_ProposedCmt]
    
    ###Personnel Tab###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Calendars Tab###
    Set Deal Calendar    &{ExcelPath}[HolidayCalendar]
    Set Deal Calendar    &{ExcelPath}[HolidayCalendar2]
    Set Deal Calendar    &{ExcelPath}[HolidayCalendar3]
    
    ###Pricing Rules Tab - Pricing Options###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]
    ...    &{ExcelPath}[PricingOption_RateChangeAppMthd]    sPricingOption_RoundingDecimalPrecision=&{ExcelPath}[RoundingDecimal_Precision]
    ...    sPricingOption_IntentNoticeDaysInAdvance=&{ExcelPath}[PricingOption_IntentNoticeDay]   sPricingOption_IntentNoticeTime=&{ExcelPath}[PricingOption_IntentNoticeTime]
    ...    sPricingOption_MinimumPaymentAmount=&{ExcelPath}[Minimum_Payment_Amount]    sPricingOption_InterestDueUponPrincipalPayment=&{ExcelPath}[PricingOption_InterestDueUponPrincipalPayment]
    ...    sPricingOption_InterestDueUponRepricing=&{ExcelPath}[PricingOption_InterestDueUponRepricing]    sPricingOption_BillBorrower=&{ExcelPath}[PricingOption_BillBorrower]
    
    ###Pricing Rules###
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
    ...    OFF    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    Save Changes on Deal Notebook
    
Setup Primaries for PT Health Syndicated Deal
    [Documentation]    This keyword adds Lenders in a PT Health Syndicated Deal. Specifically, 1 Host Bank and 1 Non-Host Banks.
    ...    @author: songchan    19JAN2021    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Primary Lender - Host Bank###
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primary_TransactionType]
    ${SellAmount}    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook 
    Populate Amts or Dates Tab in Pending Orig Primary    ${SellAmount}    &{ExcelPath}[Expected_CloseDate]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    &{ExcelPath}[ServicingGroupMember]    &{ExcelPath}[AdminAgent_SGAlias1]
    Close Orig Primaries Window
    
    ### Circle Notebook Complete Portfolio Allocation, Circling ###
    ${HostBank_ShareAmount}    Circle Notebook Workflow Navigation for PT Health Syndicated Deal    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_CircledDate]
    ...    &{ExcelPath}[IsLenderAHostBank]    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]
    ...    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Approval using a different user###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Deal_Name]    &{ExcelPath}[LenderType1]
    Close All Windows on LIQ
    
Circle Notebook Workflow Navigation for PT Health Syndicated Deal
    [Documentation]    This navigates the Workflow tab of the Lender's Circle Notebook, to Complete Portfolio Allocations, Circling and Send to Settlement Approval.
    ...    This is initiated in the "Primaries List" window for selecting a Lender.
    ...    This keyword returns the "Sell Amount" of the Lender to be used in later transactions.
    ...    
    ...    | Arguments |
    ...    'IsLenderAHostBank' = Accepts 'Yes' for conditional statement. If Yes, this keyword will execute "Complete Portfolio Allocations Worflow" keyword,
    ...                          and will require the Arguments needed for the said keyword.
    ...    
    ...    @author: songchan    21JAN2021    - initial create
    [Arguments]    ${sLender_Name}    ${sCircledDate}    ${sIsLenderAHostBank}=null    ${sPrimary_Portfolio}=null    ${sPrimary_PortfolioBranch}=null
    ...    ${sPrimary_PortfolioAllocation}=null    ${sPrimary_PortfolioExpDate}=null    ${sExpenseCode}=null    ${sRuntime_Variable}=None
    
    ### GetRuntime Keyword Pre-processing ###
    ${Lender_Name}    Acquire Argument Value    ${sLender_Name}
    ${CircledDate}    Acquire Argument Value    ${sCircledDate}
    ${IsLenderAHostBank}    Acquire Argument Value    ${sIsLenderAHostBank}
    ${Primary_Portfolio}    Acquire Argument Value    ${sPrimary_Portfolio}
    ${Primary_PortfolioBranch}    Acquire Argument Value    ${sPrimary_PortfolioBranch}
    ${Primary_PortfolioAllocation}    Acquire Argument Value    ${sPrimary_PortfolioAllocation}
    ${Primary_PortfolioExpDate}    Acquire Argument Value    ${sPrimary_PortfolioExpDate}
    ${ExpenseCode}    Acquire Argument Value    ${sExpenseCode}
    ${Runtime_Variable}    Acquire Argument Value    ${sRuntime_Variable}

    mx LoanIQ activate    ${LIQ_PrimariesList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimariesList_JavaTree}    ${Lender_Name}%d
    Validate Circle Notebook Lender Name and Sell Amount    ${Lender_Name}
    ${ShareAmount}    Mx LoanIQ Get Data    ${LIQ_OrigPrimaries_SellAmount_Textfield}    value%amount
    Circling for Primary Workflow    ${CircledDate}
    Run Keyword If    '${IsLenderAHostBank}'=='Yes'
    ...    Complete Portfolio Allocations Workflow    ${Primary_Portfolio}    ${Primary_PortfolioBranch}    ${Primary_PortfolioAllocation}    ${Primary_PortfolioExpDate}    None    ${ExpenseCode}
    Navigate Notebook Workflow    ${LIQ_OrigPrimaries_Window}    ${LIQ_OrigPrimaries_Tab}    ${LIQ_PrimaryCircle_Workflow_JavaTree}    Send to Settlement Approval
    Validate Window Title Status    Orig Primary    Awaiting Settlement Approval
    Save Values of Runtime Execution on Excel File    ${Runtime_Variable}    ${ShareAmount}
    [Return]    ${ShareAmount}
    
PT Health Syndicated Deal Approval and Close
    [Documentation]    This keywords Approves and Closes the created PT Health Syndicated Deal.
    ...    @author: songchan    019JAN2021    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Close all windows and Login as original user###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    &{ExcelPath}[ApproveDate]
    Close the Deal    &{ExcelPath}[CloseDate]

    ###Validate Deal, Facility and Circle Notebooks status after Deal Close.
    Verify Circle Notebook Status After Deal Close    &{ExcelPath}[Primary_Lender1]
    Verify Facility Status After Deal Close    &{ExcelPath}[Facility_Name]
    Verify Deal Status After Deal Close
    Validate Deal Closing Cmt With Facility Total Global Current Cmt
    ${Deal_ClosingCmt}    Get Deal Closing Cmt
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
 