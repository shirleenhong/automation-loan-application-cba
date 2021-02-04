*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Deal for ATM BILAT
    [Documentation]    This keyword is for setting up Deal for ATM Bilateral Deal
    ...    @author: ccarriedo    12JAN2021    - Initial Create
    ...    @update: ccarriedo    20JAN2021    - Added writing of Deal_Name to CRED02_FacilitySetup sheet, deleted Global Variables
    ...    @update: ccarriedo    02FEB2021    - Added writing of Borrower_ShortName to CRED01_DealSetup sheet
    [Arguments]    ${ExcelPath}
	
	### Login to LoanIQ ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias with Numeric Test Data    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]    4

    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    &{ExcelPath}[rowid]  
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    &{ExcelPath}[rowid] 
    ${Borrower_SGAlias}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SGAlias    &{ExcelPath}[rowid] 
    ${Borrower_SG_GroupMembers}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_GroupMembers    &{ExcelPath}[rowid] 
    ${Borrower_PreferredRIMthd}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_PreferredRIMthd    &{ExcelPath}[rowid] 
    ${Borrower_SG_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_SG_Name    &{ExcelPath}[rowid] 
    ${Borrower_Depositor_Indicator}    Read Data From Excel    PTY001_QuickPartyOnboarding    Borrower_Depositor_Indicator    &{ExcelPath}[rowid]
    ${Party_ID1}    Read Data From Excel    PTY001_QuickPartyOnboarding    Party_ID    &{ExcelPath}[rowid]

    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}
    Write Data To Excel    CRED01_DealSetup    Party_ID1    &{ExcelPath}[rowid]    ${Party_ID1}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SERV15_SchComittmentDecrease    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}

    Close All Windows on LIQ
    
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]

    ### Summary Tab ###   
    Add Deal Borrower    ${Borrower_ShortName}
    Select Deal Borrower Location and Servicing Group    ${Borrower_Location}    ${Borrower_SGAlias}    ${Borrower_SG_GroupMembers}    ${Borrower_PreferredRIMthd}    ${Borrower_ShortName}    ${Borrower_SG_Name}
    Select Deal Borrower Remmitance Instruction    ${Borrower_ShortName}    ${Deal_Name}    ${Borrower_Location}    ${Borrower_Depositor_Indicator}
    
    ### Add another borrower ###
    ${Borrower_ShortName2}    Read Data From Excel    ORIG03_Customer    LIQCustomer_ShortName    2
    ${Party_ID2}    Read Data From Excel    PTY001_QuickPartyOnboarding    Party_ID    2
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower1    &{ExcelPath}[rowid]    ${Borrower_ShortName2}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName2    &{ExcelPath}[rowid]    ${Borrower_ShortName2}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower2    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    CRED01_DealSetup    Party_ID2    &{ExcelPath}[rowid]    ${Party_ID2}
    Add Deal Borrower    ${Borrower_ShortName2}
    
    ### Close Deal Borrower window ###
    Close Deal Notebook Window
    
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_RIMethod]    &{ExcelPath}[AdminAgent_SGName]
    Enter Agreement Date    &{ExcelPath}[Deal_AgreementDate]
    Unrestrict Deal

    ### Check Sole Lender checkbox ###
    Set Deal as Sole Lender

    ### Personnel Tab ###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ### Calendars Tab ###
    Delete Existing Holiday on Calendar Table
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar1]
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar2]
    
    ### Pricing Rules Tab ###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    
    ...    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    None    None    &{ExcelPath}[PricingOption_RoundingApplicationMethod]      
    ...    &{ExcelPath}[PricingOption_PercentOfRateFormulaUsage]    &{ExcelPath}[PricingOption_RepricingNonBusinessDayRule]    None    &{ExcelPath}[PricingOption_InterestDueUponPrincipalPayment]    &{ExcelPath}[PricingOption_InterestDueUponRepricing]
    ...    None    None    None    None    None    None    &{ExcelPath}[PricingOption_MinimumPaymentAmount]    &{ExcelPath}[PricingOption_MinimumAmountMultiples]    None    &{ExcelPath}[PricingOption_BillBorrower]     None    None

    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]

    ### Save Changes ###    
    Save Changes on Deal Notebook
    
    ### Logout ###
    Close All Windows on LIQ
    Logout from Loan IQ

Approve and Close ATM BILAT
    [Documentation]    This keyword approves and closes the created Deal
    ...    @author: ccarriedo    02FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${ApproveandCloseDate}    Read Data From Excel    SYND02_PrimaryAllocation    Primary_ExpectedCloseDate    &{ExcelPath}[rowid]

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Deal Notebook ###
    Search Existing Deal    ${Deal_Name}
    Navigate to Deal Notebook Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Existing Deal    ${Deal_Name}
    Approve the Deal    ${ApproveandCloseDate}
    Close the Deal    ${ApproveandCloseDate}
    
    Close All Windows on LIQ
    Logout from Loan IQ
