*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${rowid}    1

*** Keywords ***
Setup Deal for New Life BILAT
    [Documentation]    This keyword is for setting up Deal for New Life Bilateral Deal
    ...    @author:    kmagday    07DEC2020    Initial create 
    ...    @update:    kmagday    10DEC2020    added writing of deal alias to CRED01_DealSetup sheet
    ...    @update:    kmagday    15DEC2020    Added writing of Deal_Name and Borrower_ShortName in SERV01_LoanDrawdown sheet
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias with 5 Numeric Test Data    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    ${Borrower_ShortName}    Read Data From Excel    PTY001_QuickPartyOnboarding    LIQCustomer_ShortName    ${rowid}  
    ${Borrower_Location}    Read Data From Excel    PTY001_QuickPartyOnboarding    Customer_Location    ${rowid} 
    Write Data To Excel    CRED01_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    ${rowid}    ${Borrower_ShortName}
    Write Data To Excel    CRED01_DealSetup    Borrower_Location    ${rowid}    ${Borrower_Location}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_Name    ${rowid}    ${Borrower_ShortName}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Borrower    ${rowid}    ${Borrower_ShortName}
    Write Data To Excel    SERV29_CommitmentFeePayment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SYND02_PrimaryAllocation    Deal_Name    ${rowid}    ${Deal_Name}

    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    ${ExcelPath}[Deal_SalesGroup]

    ### Summary Tab ###   
    ### Add borrower ###
    Add Deal Borrower    &{ExcelPath}[Borrower_ShortName]  
    Click OK Button To Close Borrowers Notebook
    

    ### Check Sole Lender checkbox ###
    Set Deal as Sole Lender
    
    ### Deal Classification ###
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    ### Admin Agent ###
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_RIMethod]    &{ExcelPath}[AdminAgent_SGName]
    
    ### Agreement date and propose amount ###
    Enter Agreement Date and Proposed Commitment Amount    ${ExcelPath}[Deal_AgreementDate]    ${ExcelPath}[Deal_ProposedCmt]
    Unrestrict Deal

    ### Personnel Tab ###
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ### Calendars Tab ###
    Delete Existing Holiday on Calendar Table
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    ### Pricing Rules Tab ###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    
    ...    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    &{ExcelPath}[PricingOption_InitialFractionRate]    &{ExcelPath}[PricingOption_RoundingDecimalPrecision]    &{ExcelPath}[PricingOption_RoundingApplicationMethod]      
    ...    &{ExcelPath}[PricingOption_PercentOfRateFormulaUsage]    &{ExcelPath}[PricingOption_RepricingNonBusinessDayRule]    &{ExcelPath}[PricingOption_FeeOnLenderShareFunding]    &{ExcelPath}[PricingOption_InterestDueUponPrincipalPayment]    &{ExcelPath}[PricingOption_InterestDueUponRepricing]
    ...    &{ExcelPath}[PricingOption_ReferenceBanksApply]    &{ExcelPath}[PricingOption_IntentNoticeDaysInAdvance]    &{ExcelPath}[PricingOption_IntentNoticeTime]    sPricingOption_MinimumDrawdownAmount=&{ExcelPath}[MinimumDrawdownAmount]   sPricingOption_BillBorrower=&{ExcelPath}[PricingOption_BillBorrower]     

    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]

    ### Ratios/Conds Tab ###
    Add Outside Conditions    &{ExcelPath}[Ratios_And_Cons_Index]    &{ExcelPath}[Ratios_And_Cons_Description]    &{ExcelPath}[Ratios_And_Cons_StartDate]    &{ExcelPath}[Ratios_And_Cons_RadioButton]

