*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Setup Syndicated Deal for DNR
    [Documentation]    This keyword is used to create a Syndicated Deal.
    ...    Primarily entering data in multiple tabs of the Deal Notebook and adding Pricing Options.
    ...    @author: clanding    09NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    ###Data Generation###
    ${Deal_Name}    Auto Generate Name Test Data    &{ExcelPath}[Deal_NamePrefix]
    ${Deal_Alias}    Auto Generate Name Test Data    &{ExcelPath}[Deal_AliasPrefix]  
      
    ###Deal Select Window###
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    
    ###Summary Tab###
    Unrestrict Deal
        
    ###Deal Borrower Setup###
    Add Deal Borrower    &{ExcelPath}[Borrower_ShortName]
    Set Deal Borrower Servicing Group    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_Name]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_PreferredRIMthd1]
    Go To Deal Borrower Preferred RI Window
    Add Preferred Remittance Instruction    ${Deal_Name}    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_PreferredRIMthd1]
    Complete Deal Borrower Setup
    
    ${Borrower_Name}    Get Borrower Name From Deal Notebook
    ${Customer_LegalName}    Get Customer Legal Name From Customer Notebook Via Deal Notebook
    
    Write Data To Excel    CRED10_EventFee    Borrower_Name    ${rowid}    ${Borrower_Name}
    
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    ###Deal Admin Agent Setup###
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Set Deal Admin Agent Servicing Group    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_ServicingGroup]    &{ExcelPath}[AdminAgent_ContactName]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Go To Admin Agent Preferred RI Window
    Add Preferred Remittance Instruction    ${Deal_Name}    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Complete Deal Admin Agent Setup
    ${Deal_AgreementDate}    Get System Date
    Write Data To Excel    CRED01_DealSetup    Deal_AgreementDate    ${rowid}    ${Deal_AgreementDate}   
    
    Enter Agreement Date and Proposed Commitment Amount    ${Deal_AgreementDate}    &{ExcelPath}[Deal_ProposedCmt]
    
    ###Personnel Tab###
    Uncheck Early Discussion Deal Checkbox
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Calendars Tab###
    Set Deal Calendar    &{ExcelPath}[HolidayCalendar]
    
    ###Pricing Rules Tab###
    ###Pricing Options###
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption2]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption3]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption4]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    
    ###Pricing Rules###
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
    ...    ON    &{ExcelPath}[PricingRule_BillNoOfDays1]
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee2]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
    ...    ON    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    Save Changes on Deal Notebook 
    
    ###Get necessary data from created Deal to be used in succeeding transactions###
    ${Date}    Get Data From LoanIQ    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    Summary    ${LIQ_DealSummaryAgreementDate_Textfield}
    ${AdminFee_DueDate}    Add Days to Date    ${Date}    30
    Write Data To Excel    CRED09_AdminFee    AdminFee_EffectiveDate    ${rowid}    ${Date}
    Write Data To Excel    CRED09_AdminFee    AdminFee_ActualDueDate    ${rowid}    ${AdminFee_DueDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    ${rowid}    ${Date}
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${Date}
    Write Data To Excel    SERV30_AdminFeePayment    AdminFee_DueDate    &{ExcelPath}[rowid]    ${AdminFee_DueDate}
    ${ScheduledActivityFilter_FromDate}    Subtract Days to Date    ${Date}    30
    ${ScheduledActivityFilter_ThruDate}    Add Days to Date    ${Date}    30
    Write Data To Excel    SERV30_AdminFeePayment    ScheduledActivityFilter_FromDate    &{ExcelPath}[rowid]    ${ScheduledActivityFilter_FromDate}
    Write Data To Excel    SERV30_AdminFeePayment    ScheduledActivityFilter_ThruDate    &{ExcelPath}[rowid]    ${ScheduledActivityFilter_ThruDate}