*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Setup Syndicated Deal for DNR
    [Documentation]    This keyword is used to create a Syndicated Deal.
    ...    Primarily entering data in multiple tabs of the Deal Notebook and adding Pricing Options.
    ...    @author: clanding    09NOV2020    - initial create
    ...    @update: shirhong    04DEC2020    - updated keywords for DNR deal setup
    [Arguments]    ${ExcelPath}

    ###Data Generation###
    ${Deal_Name}    Auto Generate Name Test Data    &{ExcelPath}[Deal_NamePrefix]
    ${Deal_Alias}    Auto Generate Name Test Data    &{ExcelPath}[Deal_AliasPrefix]  
	 
    Write Data To Excel    SC2_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}    	
    Write Data To Excel    SC2_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}    ${DNR_DATASET}	
    Write Data To Excel    SC2_AdminFee    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}	
    Write Data To Excel    SC2_EventFee    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}	
    Write Data To Excel    SC2_PrimaryAllocation    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET} 
    Write Data To Excel    SC2_LoanDrawdown    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_PaymentFees    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_CycleShareAdjustment    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_AdminFeePayment    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}	
    Write Data To Excel    SC2_LoanDrawdownNonAgent    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_FacilityShareAdjustment    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}
    Write Data To Excel    SC2_LoanRepricing    Deal_Name    ${rowid}    ${Deal_Name}    ${DNR_DATASET}

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
    Write Data To Excel    SC2_DealSetup    Deal_AgreementDate    ${rowid}    ${Deal_AgreementDate}    ${DNR_DATASET}

    
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
    Run Keyword If    '${rowid}'=='3'    Run Keywords    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption2]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    ...    AND    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption3]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    ...    AND    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption4]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]

    ###Pricing Rules###
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
    ...    ON    &{ExcelPath}[PricingRule_BillNoOfDays1]
    Run Keyword If    '${rowid}'=='3'    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee2]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
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
    Write Data To Excel     SC2_AdminFeePayment    ScheduledActivityFilter_FromDate     &{ExcelPath}[rowid]    ${ScheduledActivityFilter_FromDate}    ${DNR_DATASET}
    Write Data To Excel     SC2_AdminFeePayment    ScheduledActivityFilter_ThruDate    &{ExcelPath}[rowid]    ${ScheduledActivityFilter_FromDate}    ${DNR_DATASET}

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
    Write Data To Excel    SC1_UnscheduledPayments    Loan_EffectiveDate    3    ${SystemDate}    ${DNR_DATASET}

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
    Write Data To Excel    SC1_UnscheduledPayments    Deal_Name    3    ${Deal_Name}    ${DNR_DATASET}
    
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
    ...    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    sPricingOption_CCY=${PricingOption_CCY}
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

Update Comments in Deal for DNR
    [Documentation]    This keyword is used to update Comments details for Deal level.
    ...    @author: clanding    03DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Current_Comment_Heading}    Read Data From Excel    CMMNT    Comment_Heading    CMMNT_006    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case
    ${Deal_Name}    Read Data From Excel    CMMNT    Deal_Name    CMMNT_006    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case
    ${Deal_Tracking_Number}    Read Data From Excel    CMMNT    Deal_Tracking_Number    CMMNT_006    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}
    ${Comment_Details}    ${Comment_DateWithTime}    Update Details in Comments Tab in Deal Notebook    ${Current_Comment_Heading}    &{ExcelPath}[Comment_Heading]
    Write Data To Excel    CMMNT    User_ID    ${TestCase_Name}    ${INPUTTER_USERNAME}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Date_Added_Amended    ${TestCase_Name}    ${Comment_DateWithTime}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Detail    ${TestCase_Name}    ${Comment_Details}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Deal_Name    ${TestCase_Name}    ${Deal_Name}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Deal_Tracking_Number    ${TestCase_Name}    ${Deal_Tracking_Number}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ

Delete Comments in Deal for DNR
    [Documentation]    This keyword is used to deleteComments details for Deal level.
    ...    @author: clanding    04DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Comment_Heading}    Read Data From Excel    CMMNT    Comment_Heading    CMMNT_008    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case
    ${Comment_Detail}    Read Data From Excel    CMMNT    Comment_Detail    CMMNT_008    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case
    ${Deal_Name}    Read Data From Excel    CMMNT    Deal_Name    CMMNT_006    ${DNR_DATASET}    bTestCaseColumn=True    sTestCaseColReference=Test_Case

    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    ${Deal_Name}
    Delete Details in Comments Tab in Deal Notebook    ${Comment_Heading}
    Write Data To Excel    CMMNT    Comment_Heading    ${TestCase_Name}    ${Comment_Heading}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Comment_Detail    ${TestCase_Name}    ${Comment_Detail}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Deal_Name    ${TestCase_Name}    ${Deal_Name}    ${DNR_DATASET}    bTestCaseColumn=True

    Close All Windows on LIQ


Setup Deal Administrative Fees for DNR
    [Documentation]    This keyword is for adding Administrative Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: shirhong    04DEC2020    - initial create
    [Arguments]    ${ExcelPath}
        
    ###Deal Notebook###
    ${AdminFee_EffectiveDate}    Get System Date
    Write Data To Excel    SC2_AdminFee    AdminFee_EffectiveDate    ${rowid}    ${AdminFee_EffectiveDate}    ${DNR_DATASET}
    
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Add Admin Fee in Deal Notebook    &{ExcelPath}[AdminFee_IncomeMethod]
    Set General Tab Details in Admin Fee Notebook    &{ExcelPath}[AdminFee_FlatAmount]    ${AdminFee_EffectiveDate}    &{ExcelPath}[AdminFee_PeriodFrequency]
    ...    &{ExcelPath}[AdminFee_ActualDueDate]    &{ExcelPath}[AdminFee_BillNoOfDays]
    Set Distribution Details in Admin Fee Notebook    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[AdminFee_CustomerLocation]    &{ExcelPath}[AdminFee_ExpenseCode]    &{ExcelPath}[AdminFee_PercentOfFee]
    
    ${AdminFee_Alias}    Copy Alias To Clipboard and Get Data    ${LIQ_AdminFeeNotebook_Window}
    ${AdminFee_DueDate}    Get Admin Fee Due Date
    Write Data To Excel    SC2_AdminFee    AdminFee_Alias    ${rowid}    ${AdminFee_Alias}    ${DNR_DATASET}
    Write Data To Excel    SC2_AdminFeePayment    AdminFee_Alias    ${rowid}    ${AdminFee_Alias}    ${DNR_DATASET}
    Write Data To Excel    SC2_AdminFeePayment    AdminFee_DueDate    ${rowid}    ${AdminFee_DueDate}    ${DNR_DATASET}

    ###Send to Approval###
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Send to Approval
    mx LoanIQ close window    ${LIQ_AdminFeeNotebook_Window}
    Save Notebook Transaction    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_File_Save}
       
    ###Approve Admin Fee###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    Deals    Awaiting Approval    Amortizing Admin Fee    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Approval
    
    ###Verify Admin Fee if successfully Added###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${AdminFee_Alias}    Read Data From Excel    SC2_AdminFee    AdminFee_Alias    &{ExcelPath}[rowid]    ${DNR_DATASET}
    Validate Admin Fee If Added    ${AdminFee_Alias}
    Save Notebook Transaction    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_File_Save}

Setup Deal Event Fees for DNR
    [Documentation]    This keyword is for adding Event Fees from the Deal Notebook's Admin/Event Fees tab.
    ...    @author: shirhong    04DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    Add Event Fees in Deal Notebook    &{ExcelPath}[EventFee]    &{ExcelPath}[EventFee_Amount]    &{ExcelPath}[EventFee_Type]
    
Syndicated Deal Approval and Close for DNR
    [Documentation]    This keywords Approves and Closes the created Syndicated Deal for DNR.
    ...    @author: shirhong    04DEC2020    - initial create
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

