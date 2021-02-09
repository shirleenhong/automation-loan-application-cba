*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Deal for PDS SYND Deal
    [Documentation]    This keyword is for setting up Deal for LBT Bilateral Deal with outside condition
    ...    @author: shirhong    12JAN2021    - Initial create 
    [Arguments]    ${ExcelPath}
 
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias with Numeric Test Data    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]    4

    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]  
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    &{ExcelPath}[rowid] 
    ${Borrower_SGAlias}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SGAlias    &{ExcelPath}[rowid] 
    ${Borrower_SG_GroupMembers}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_GroupMembers    &{ExcelPath}[rowid] 
    ${Borrower_PreferredRIMthd}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_PreferredRIMthd    &{ExcelPath}[rowid] 
    ${Borrower_SG_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid] 
    ${Borrower_Depositor_Indicator}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_Depositor_Indicator    &{ExcelPath}[rowid] 

    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}
    
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]

    ### Summary Tab ###   
    Add Deal Borrower    ${Borrower_ShortName}
    Select Deal Borrower Location and Servicing Group    ${Borrower_Location}    ${Borrower_SGAlias}    ${Borrower_SG_GroupMembers}    ${Borrower_PreferredRIMthd}    ${Borrower_ShortName}    ${Borrower_ShortName}
    Select Deal Borrower Remmitance Instruction    ${Borrower_ShortName}    ${Deal_Name}    ${Borrower_Location}    ${Borrower_Depositor_Indicator}
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]    &{ExcelPath}[Deal_AdminAgent]
    Enter Agreement Date    &{ExcelPath}[Deal_AgreementDate]
    Unrestrict Deal
    
    ### Personnel Tab ###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ### Calendars Tab ###
    Delete Existing Holiday on Calendar Table
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar_1]|&{ExcelPath}[HolidayCalendar_2]|&{ExcelPath}[HolidayCalendar_3]|&{ExcelPath}[HolidayCalendar_4]|&{ExcelPath}[HolidayCalendar_5]
    
    ### Pricing Rules Tab ###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]
    ...    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    &{ExcelPath}[PricingOption_InitialFractionRate]    &{ExcelPath}[PricingOption_RoundingDecimalPrecision]    &{ExcelPath}[PricingOption_RoundingApplicationMethod]
    ...    &{ExcelPath}[PricingOption_PercentOfRateFormulaUsage]    &{ExcelPath}[PricingOption_RepricingNonBusinessDayRule]    &{ExcelPath}[PricingOption_FeeOnLenderShareFunding]    &{ExcelPath}[PricingOption_InterestDueUponPrincipalPayment]
    ...    &{ExcelPath}[PricingOption_InterestDueUponRepricing]    &{ExcelPath}[PricingOption_ReferenceBanksApply]    &{ExcelPath}[PricingOption_IntentNoticeDaysInAdvance]    &{ExcelPath}[PricingOption_IntentNoticeTime]    &{ExcelPath}[PricingOption_12HrPeriodOption]
    ...    &{ExcelPath}[PricingOption_MaximumDrawdownAmount]    &{ExcelPath}[PricingOption_MinimumDrawdownAmount]    &{ExcelPath}[PricingOption_MinimumPaymentAmount]    &{ExcelPath}[PricingOption_MinimumAmountMultiples]
    ...    &{ExcelPath}[PricingOption_CCY]    &{ExcelPath}[PricingOption_BillBorrower]    &{ExcelPath}[PricingOption_RateSettingTime]    &{ExcelPath}[PricingOption_RateSettingPeriodOption]

    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]
    ...    &{ExcelPath}[PricingRule_BillBorrowerStatus]    &{ExcelPath}[PricingRule_BillNoOfDays]
    
    Save Changes on Deal Notebook
    
Setup Primaries for PDS Syndicate Deal
    [Documentation]    This keyword will setup primaries for PDS Syndicate Deal
    ...    @author:    shirhong    04FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Primary_LenderLoc}    Read Data From Excel    CRED01_DealSetup    AdminAgent_Location    &{ExcelPath}[rowid]
    ${FacilityName_1}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    &{ExcelPath}[rowid]
    ${FacilityName_2}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    &{ExcelPath}[rowid]

    Open Existing Deal    ${Deal_Name}
    Add Lender and Location    ${Deal_Name}    &{ExcelPath}[Primary_Lender]    ${Primary_LenderLoc}    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount using Percent of Deal    &{ExcelPath}[Primary_PctOfDeal]
    Set Facility Sell Amounts in Primaries    ${FacilityName_1}    &{ExcelPath}[Sell_Amount1]    &{ExcelPath}[Primary_BuySellPrice]
    Set Facility Sell Amounts in Primaries    ${FacilityName_2}    &{ExcelPath}[Sell_Amount2]    &{ExcelPath}[Primary_BuySellPrice]
    
    Add Contact in Primary    &{ExcelPath}[Primary_Contact]
    Select Servicing Group on Primaries    &{ExcelPath}[Primary_SGMember]    &{ExcelPath}[Primary_SGAlias]

    Circling for Primary Workflow    &{ExcelPath}[Primary_CircledDate]
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]|&{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Sell_Amount1]|&{ExcelPath}[Sell_Amount2]    &{ExcelPath}[Primary_PortfolioExpiryDate]|&{ExcelPath}[Primary_PortfolioExpiryDate]    ${FacilityName_1}|${FacilityName_2}    &{ExcelPath}[Deal_ExpenseCode]    
    Send to Settlement Approval

    Close All Windows on LIQ

    ###Approval as Supervisor###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    ${Deal_Name}    &{ExcelPath}[LenderType1]
    Close All Windows on LIQ
    
PDS Syndicated Deal Approval and Close
    [Documentation]    This keywords Approves and Closes the created PDS Syndicated Deal.
    ...    @author:    shirhong    08FEB2021    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${ApproveandCloseDate}    Read Data From Excel    SYND02_PrimaryAllocation    Expected_CloseDate    &{ExcelPath}[rowid]
    ${FacilityName_1}    Read Data From Excel    CRED02_FacilitySetup_A    Facility_Name    &{ExcelPath}[rowid]
    ${FacilityName_2}    Read Data From Excel    CRED02_FacilitySetup_B    Facility_Name    &{ExcelPath}[rowid]

    ###Logout from LIQ and Login as Inputter###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
          
    ### Deal Notebook ###
    Search Existing Deal    ${Deal_Name}
    Navigate to Deal Notebook Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Existing Deal    ${Deal_Name}
    Approve the Deal    ${ApproveandCloseDate}
    Close the Deal    ${ApproveandCloseDate}

    ###Validate Deal, Facility and Circle Notebooks status after Deal Close.
    Verify Circle Notebook Status After Deal Close    &{ExcelPath}[Primary_Lender]
    Verify Facility Status After Deal Close    ${FacilityName_1}
    Verify Facility Status After Deal Close    ${FacilityName_2}
    Verify Deal Status After Deal Close
    Validate Deal Closing Cmt With Facility Total Global Current Cmt
    ${Deal_ClosingCmt}    Get Deal Closing Cmt
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
 