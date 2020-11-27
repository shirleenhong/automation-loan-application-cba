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
    
    Write Data To Excel    SC2_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_AdminFee    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_EventFee    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanDrawdown    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
      
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
    
    
    ### Write Data To Excel    SERV30_AdminFeePayment    Borrower_Name    ${rowid}    ${Borrower_Name}
    ### Write Data To Excel    SERV30_AdminFeePayment    Customer_LegalName    ${rowid}    ${Customer_LegalName}
    Write Data To Excel    SC2_EventFee    Borrower_Name    ${rowid}    ${Borrower_Name}    ${DNR_DATASET}
    
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    ###Deal Admin Agent Setup###
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Set Deal Admin Agent Servicing Group    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_ServicingGroup]    &{ExcelPath}[AdminAgent_ContactName]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Go To Admin Agent Preferred RI Window
    Add Preferred Remittance Instruction    ${Deal_Name}    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Complete Deal Admin Agent Setup
    ${Deal_AgreementDate}    Get System Date
    Write Data To Excel    SC2_EventFee    Borrower_Name    ${rowid}    ${Borrower_Name}    ${DNR_DATASET}  
    
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
    Write Data To Excel    SC2_AdminFee    AdminFee_EffectiveDate    ${rowid}    ${Date}    ${DNR_DATASET}
    Write Data To Excel    SC2_AdminFee    AdminFee_ActualDueDate    ${rowid}    ${AdminFee_DueDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilitySetup    Facility_AgreementDate    ${rowid}    ${Date}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${Date}    ${DNR_DATASET}
    ${ScheduledActivityFilter_FromDate}    Subtract Days to Date    ${Date}    30
    ${ScheduledActivityFilter_ThruDate}    Add Days to Date    ${Date}    30
    
Setup Term Facility for Syndicated Deal for DNR
    [Documentation]    This keyword is used to create a Term Facility.
    ...    @author:fluberio    25NOV2020    initial create
    [Arguments]    ${ExcelPath}
    
    ###Data Generation###
    ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    SC2_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_EventFee    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    ${DNR_DATASET}
    
    ${FacilityName}    Read Data From Excel    SC2_FacilitySetup    Facility_Name    ${rowid}    ${DNR_DATASET}
    
    Mx LoanIQ Maximize    ${LIQ_Window} 
    ###Facility Creation###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395
    
    Write Data To Excel    SC2_LoanDrawdown    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}    ${DNR_DATASET}
    
    Set Facility Dates    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType2]
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    Add Facility Currency    &{ExcelPath}[Facility_Currency1]
    Add Facility Currency    &{ExcelPath}[Facility_Currency2]
    Add Facility Borrower - Add All    &{ExcelPath}[Facility_Borrower]
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType1]
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType2]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency2]
    Complete Facility Borrower Setup
    
    ###Get necessary data from created Facility and store to Excel to be used in other transactions###
    ${EffectiveDate}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_EffectiveDate_Datefield}
    ${ExpiryDate}    Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_ExpiryDate_Datefield}
    Write Data To Excel    SC2_DealSetup    ApproveDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    CloseDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    ApproveDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_PrimaryAllocation    CloseDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    Primary_CircledDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_DealSetup    Primary_PortfolioExpiryDate    ${rowid}    ${ExpiryDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_EventFee    EventFee_EffectiveDate    ${rowid}    ${EffectiveDate}    ${DNR_DATASET}
    
    ${EventFee_NoRecurrencesAfterDate}    Get Back Dated Current Date    -365
    Write Data To Excel    SC2_EventFee    EventFee_NoRecurrencesAfterDate    ${rowid}    ${EventFee_NoRecurrencesAfterDate}    ${DNR_DATASET}
    