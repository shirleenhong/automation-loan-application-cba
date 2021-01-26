*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Deal for LBT BILAT Deal
    [Documentation]    This keyword is for setting up Deal for LBT Bilateral Deal with outside condition
    ...    @author: javinzon    09DEC2020    - Initial create 
    ...    @update: javinzon    14DEC2020    - Added Write Data to Excel for Deal_Name of SYND02_PrimaryAllocation and 
    ...										   CRED08_OngoingFeeSetup, Added Set Deal as Sole Lender keyword
    ...    @update: javinzon    18DEC2020    - Added keywords Write Data to Excel for Deal_Name of SERV01_LoanDrawdown
    ...    @update: javinzon    13JAN2021    - Added keywords Write Data to Excel for Deal_Name of Correspondence and LegalName
    ...                                        for 1st and 2nd row of Correspondence
    ...    @update: javinzon    26JAN2021    - Added keywords Write Data to Excel for Deal_Name of SERV01_LoanDrawdown for rows 4-10
    [Arguments]    ${ExcelPath}
 
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
    Write Data To Excel    SYND02_PrimaryAllocation    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    2    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    3    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    4    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    5    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    6    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    7    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    8    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    9    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    10    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    Correspondence    Deal_Name    2    ${Deal_Name}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    2    ${Borrower_ShortName}    

    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]

    ### Summary Tab ###   
    Add Deal Borrower    ${Borrower_ShortName}
    Select Deal Borrower Location and Servicing Group    ${Borrower_Location}    ${Borrower_SGAlias}    ${Borrower_SG_GroupMembers}    ${Borrower_PreferredRIMthd}    ${Borrower_ShortName}    ${Borrower_SG_Name}
    Select Deal Borrower Remmitance Instruction    ${Borrower_ShortName}    ${Deal_Name}    ${Borrower_Location}    ${Borrower_Depositor_Indicator}
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Set Deal as Sole Lender
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_RIMethod]    &{ExcelPath}[AdminAgent_SGName]
    Enter Agreement Date    &{ExcelPath}[Deal_AgreementDate]
    Unrestrict Deal
    
    ### Personnel Tab ###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ### Calendars Tab ###
    Delete Existing Holiday on Calendar Table
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    ### Pricing Rules Tab ###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    
    ...    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    None    None    &{ExcelPath}[PricingOption_RoundingApplicationMethod]      
    ...    &{ExcelPath}[PricingOption_PercentOfRateFormulaUsage]    &{ExcelPath}[PricingOption_RepricingNonBusinessDayRule]    None    &{ExcelPath}[PricingOption_InterestDueUponPrincipalPayment]    &{ExcelPath}[PricingOption_InterestDueUponRepricing]
    ...    None    &{ExcelPath}[PricingOption_IntentNoticeDaysInAdvance]    None    None    None    None    None    None    None    &{ExcelPath}[PricingOption_BillBorrower]     &{ExcelPath}[PricingOption_RateSettingTime]    &{ExcelPath}[PricingOption_RateSettingPeriodOption]

    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]
    
    ### Ratios/Conds Tab ###
    Add Outside Conditions    &{ExcelPath}[Ratios_And_Cons_Index]    &{ExcelPath}[Ratios_And_Cons_Description]    &{ExcelPath}[Ratios_And_Cons_StartDate]    &{ExcelPath}[Ratios_And_Cons_RadioButton]