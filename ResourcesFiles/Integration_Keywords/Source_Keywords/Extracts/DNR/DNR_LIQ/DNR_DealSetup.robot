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

Setup a Bilateral Deal for DNR
    [Documentation]    Create a Bilateral Deal with no Origination System
    ...    @author: clanding     24NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    ###Set Dates for transactions###
    ${SystemDate}    Get System Date
    Write Data To Excel    SC1_DealSetup    FinancialRatioStartDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_DealSetup    CreatedEffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_DealSetup    UnrestrictedEffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_DealSetup    FRCEffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_DealSetup    ActualDueDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_DealSetup    Deal_AgreementDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_DealSetup    Deal_EffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_EffectiveDate    2    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    ApproveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    CloseDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Primary_CircledDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_PaymentFees    Fee_EffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_PaymentFees    Fee_FloatRateStartDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_PaymentFees    FeePayment_EffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Write Data To Excel    SC1_UnscheduledPayments    Loan_EffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}    

    ##Generate Deal Name and Alias###    
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]    ${rowid}
    Write Data To Excel    SC1_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}    ${DNR_DATASET}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Deal_Name    2    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_PaymentFees    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_PaymentFees    ScheduledActivity_DealName    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC1_UnscheduledPayments    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    
    ###For Scenario 1 Deal Setup###
    Write Data To Excel    SC1_FacilitySetup    Facility_Currency1    ${rowid}    ${ExcelPath}[Deal_Currency]    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_Currency    ${rowid}    ${ExcelPath}[Deal_Currency]    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Deal_Currency    ${rowid}    ${ExcelPath}[Deal_Currency]    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_SGLocation    ${rowid}    ${ExcelPath}[AdminAgent_Location]    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_Customer    ${rowid}    ${ExcelPath}[Deal_AdminAgent]    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_Currency1    2    ${ExcelPath}[Deal_Currency]    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_Currency    2    ${ExcelPath}[Deal_Currency]    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Deal_Currency    2    ${ExcelPath}[Deal_Currency]    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_SGLocation    2    ${ExcelPath}[AdminAgent_Location]    ${DNR_DATASET}
    Write Data To Excel    SC1_FacilitySetup    Facility_Customer    2    ${ExcelPath}[Deal_AdminAgent]    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Primary_LenderLoc1    ${rowid}    ${ExcelPath}[AdminAgent_Location]    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    Primary_Lender1    ${rowid}    ${ExcelPath}[Deal_AdminAgent]    ${DNR_DATASET}
    Write Data To Excel    SC1_PrimaryAllocation    FundReceiverDetailCustomer    ${rowid}    ${ExcelPath}[Deal_AdminAgent]    ${DNR_DATASET}

    ###New Deal Screen###   
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    
    ###Deal Notebook - Summary Tab###   
    Add Deal Borrower    &{ExcelPath}[Borrower1_ShortName]  
    Select Deal Borrower Location and Servicing Group    &{ExcelPath}[Borrower_Location]    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_SG_Method]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower_SG_Name]
    Select Deal Borrower Remmitance Instruction    &{ExcelPath}[Borrower1_ShortName]    ${Deal_Name}    &{ExcelPath}[Borrower_Location]
	Set Deal as Sole Lender
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]    &{ExcelPath}[AdminAgent_ServicingGroup]
    Enter Agreement Date and Proposed Commitment Amount    ${SystemDate}    &{ExcelPath}[Deal_ProposedCmt]
    Unrestrict Deal

    ###Deal Notebook - MIS Codes Tab###
    Validate and Update Branch and Processing Area in MIS Codes Tab    &{ExcelPath}[PortfolioBranch]    &{ExcelPath}[ProcessingArea]
    
    ###Deal Notebook - Personnel Tab###
    Uncheck Early Discussion Deal Checkbox
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Deal Notebook - Calendars Tab###
    Delete Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    ###Deal Notebook - Ratios/Conds Tab###
    Add Financial Ratio    &{ExcelPath}[RatioType1]    &{ExcelPath}[FinancialRatio]    ${SystemDate}
    
    ###Deal Notebook - Pricing Rules Tab###
    ${PricingOption_CCY}    Run Keyword If    '&{ExcelPath}[Deal_PricingOption1_CCY]' == '${EMPTY}' or '&{ExcelPath}[Deal_PricingOption1_CCY]' == '${None}'    Set Variable    None
    ...    ELSE    Set Variable    &{ExcelPath}[Deal_PricingOption1_CCY]
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]
    ...    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    PricingOption_CCY=${PricingOption_CCY}
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]    &{ExcelPath}[PricingRule_BillBorrowerStatus1]    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    ##Deal Notebook - Events Tab###    
    Verify Details on Events Tab    ${INPUTTER_USERNAME.upper()}    ${INPUTTER_USERNAME.upper()}    ${INPUTTER_USERNAME.upper()}
    
    Close All Windows on LIQ

Update Alerts in Deal for DNR
    [Documentation]    This keyword is used to update Comments details for Deal level.
    ...    @author: clanding    03DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${Alert_Heading}    Read Data From Excel    ALERT    Alert_Heading    ALERT_006    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case
    ${Deal_Name}    Read Data From Excel    ALERT    Deal_Name    ALERT_006    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case
    ${Deal_Tracking_Number}    Read Data From Excel    ALERT    Deal_Tracking_Number    ALERT_006    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case
    ${User_Name}    Read Data From Excel    ALERT    User_Name    ALERT_006    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_USERNAME}
    Open Existing Deal    ${Deal_Name}
    ${Alerts_Details}    ${Date_Added}    Update Alerts in Deal Notebook    &{ExcelPath}[Alert_Heading]
    ${FName_UI}    ${LName_UI}    Get First Name of a User    ${INPUTTER_USERNAME}
    Write Data To Excel    ALERT    Alert_Content    ${TestCase_Name}    ${Alerts_Details}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Date_Added_Amended    ${TestCase_Name}    ${Date_Added}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Deal_Name    ${TestCase_Name}    ${Deal_Name}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Deal_Tracking_Number    ${TestCase_Name}    ${Deal_Tracking_Number}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    User_Name    ${TestCase_Name}    ${FName_UI}${SPACE}${LName_UI}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ


