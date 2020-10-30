*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${temp}    temp

*** Keywords ***
Setup a Bilateral Deal
    [Documentation]    Create a Bilateral Deal with no Origination System
    ...    @author: fmamaril     DDMMMYYYY    - initial create
    ...    @update: amansueto    15APR2020    - merged select actions and validate field keywords to Create New Deal
    ...    @update: hstone       04MAY2020    - Deleted SAPWUL Related Write Data To Excel
    ...    @update: jloretiz     15JUN2020    - added writing of deal name for API_COR_TC01, removed the reading from excel to shorten runtime
    ...    @update: kduenas      23SEP2020    - added writing of deal name to corro api dataset for API_COR_TC03
    ...    @UPDATE: kduenas      08OCT2020    - added writing of deal name to corro api dataset for API_COR_TC05
    ...    @UPDATE: kduenas      08OCT2020    - added writing of deal name to corro api dataset for API_COR_TC06
    ...    @update: makcamps     15OCT2020    - added writing of method name in excel
    ...    @UPDATE: kduenas      27OCT2020    - added writing of deal name to corro api dataset for API_COR_TC21
    ...    @update: makcamps     28OCT2020    - added writing of method name in excel
    ...    @update: makcamps     29OCT2020    - added writing of deal name to corro api dataset for API_COR_TC14
    [Arguments]    ${ExcelPath}

    ###Set Dates for transactions###
    ${SystemDate}    Get System Date
    Write Data To Excel    CRED01_DealSetup    FinancialRatioStartDate    ${rowid}    ${SystemDate}
    Write Data To Excel    CRED01_DealSetup    CreatedEffectiveDate    ${rowid}    ${SystemDate}   
    Write Data To Excel    CRED01_DealSetup    UnrestrictedEffectiveDate    ${rowid}    ${SystemDate}   
    Write Data To Excel    CRED01_DealSetup    FRCEffectiveDate    ${rowid}    ${SystemDate}        
    Write Data To Excel    CRED01_DealSetup    ActualDueDate    ${rowid}    ${SystemDate}
    Write Data To Excel    CRED01_DealSetup    Deal_AgreementDate    ${rowid}    ${SystemDate}       
    Write Data To Excel    CRED01_DealSetup    Deal_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV01_LoanDrawdown    Loan_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV01_LoanDrawdown    Repayment_TriggerDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV29_PaymentFees    Fee_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV29_PaymentFees    Fee_FloatRateStartDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV29_PaymentFees    FeePayment_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    AMCH06_PricingChangeTransaction    PricingChange_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV21_InterestPayments    InterestPayment_EffectiveDate    ${rowid}    ${SystemDate}                                       
    Write Data To Excel    SERV18_Payments    Loan_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV18_Payments    LoanEffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    AMCH04_DealChangeTransaction    Date    ${rowid}    ${SystemDate}
    Write Data To Excel    SYND02_PrimaryAllocation    ApproveDate    ${rowid}    ${SystemDate}   
    Write Data To Excel    SYND02_PrimaryAllocation    CloseDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SYND02_PrimaryAllocation    Primary_CircledDate    ${rowid}    ${SystemDate}

    ###For Scenario 7###
    Run Keyword If    '${SCENARIO}'=='7'    Run Keywords    Write Data To Excel    SERV19_UnscheduledPayments    Loan_EffectiveDate    ${rowid}    ${SystemDate}
    ...    AND    Write Data To Excel    SERV19_UnscheduledPayments    LoanEffectiveDate    ${rowid}    ${SystemDate}
        
    ##Generate Deal Name and Alias###    
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]    ${rowid}
    Write Data To Excel    AMCH06_PricingChangeTransaction    Deal_Name    ${rowid}    ${Deal_Name}    
    Write Data To Excel    CRED01_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SYND02_PrimaryAllocation    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}    
    Write Data To Excel    AMCH04_DealChangeTransaction    Deal_Name    ${rowid}    ${Deal_Name}     
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV18_Payments    Deal_Name    ${rowid}    ${Deal_Name}    
    Write Data To Excel    SERV21_InterestPayments    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV29_PaymentFees    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV29_PaymentFees    ScheduledActivity_DealName    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}
    
    ###For Scenario 1 Deal Setup###
    Run Keyword If    '${SCENARIO}'=='1'   Run Keywords    Write Data To Excel    CRED02_FacilitySetup    Facility_CustomerServicingGroup    ${rowid}    ${ExcelPath}[OwningBranch]
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Currency1    ${rowid}    ${ExcelPath}[Deal_Currency]
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Currency    ${rowid}    ${ExcelPath}[Deal_Currency]
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Deal_Currency    ${rowid}    ${ExcelPath}[Deal_Currency]
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_SGLocation    ${rowid}    ${ExcelPath}[AdminAgent_Location]
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_Customer    ${rowid}    ${ExcelPath}[Deal_AdminAgent]
    ...    AND    Write Data To Excel    SYND02_PrimaryAllocation    Primary_PortfolioBranch    ${rowid}    ${ExcelPath}[OwningBranch]
    ...    AND    Write Data To Excel    SYND02_PrimaryAllocation    Primary_LenderLoc1    ${rowid}    ${ExcelPath}[AdminAgent_Location]
    ...    AND    Write Data To Excel    SYND02_PrimaryAllocation    Primary_Lender1    ${rowid}    ${ExcelPath}[Deal_AdminAgent]
    ...    AND    Write Data To Excel    SYND02_PrimaryAllocation    FundReceiverDetailCustomer    ${rowid}    ${ExcelPath}[Deal_AdminAgent]
    
    Run Keyword If    '${SCENARIO}'=='1'   Run Keywords    Write Data To Excel    Correspondence    Deal_Name    ${rowid}    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    Correspondence    Deal_Name    3    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    Correspondence    Deal_Name    5    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    Correspondence    Deal_Name    6    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    Correspondence    Deal_Name    21    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    
    ###For Scenario 7###
    Run Keyword If    '${SCENARIO}'=='7'    Run Keywords    Write Data To Excel    SERV35_Terminate_FacilityDeal    Deal_Name    ${rowid}    ${Deal_Name}
    ...    AND    Write Data To Excel    SERV19_UnscheduledPayments    Deal_Name    ${rowid}    ${Deal_Name}
    ...    AND    Write Data To Excel    Correspondence    Deal_Name    14    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
             
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
    Validate and Update Branch and Processing Area in MIS Codes Tab    &{ExcelPath}[OwningBranch]    &{ExcelPath}[ProcessingArea]
    
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
    
    Run Keyword If    '&{ExcelPath}[Entity]' == 'EU'    Write Data To Excel    SERV01_LoanDrawdown    Remittance_Instruction    ${rowid}    &{ExcelPath}[Borrower_SG_Method]
    
    ##Deal Notebook - Events Tab###    
    Verify Details on Events Tab    ${INPUTTER_USERNAME.upper()}    ${INPUTTER_USERNAME.upper()}    ${INPUTTER_USERNAME.upper()}
    
Create Facility
    [Documentation]    This keyword is used to create a Facility.
    ...    @author: fmamaril     DDMMMYYYY    - initial create
    ...    @update: hstone       04MAY2020    - Used 'Add Time from From Date and Returns Weekday' for ${Facility_ExpiryDate} and ${Facility_MaturityDate}
    ...    @update: dahijara     15JUN2020    - Changed value being passed to Loan_MaturityDate for SERV01. From ${Facility_ExpiryDate} to ${Facility_MaturityDate}.
    ...    @update: jloretiz     15JUN2020    - added writing of deal name, loan alias and facility name for API_COR_TC01, removed the reading from excel to shorten runtime
    ...    @update: kduenas      23SEP2020    - added writing of facility name to corro api dataset for API_COR_TC03
    ...    @update: kduenas      08OCT2020    - added writing of facility name to corro api dataset for API_COR_TC05
    ...    @update: kduenas      08OCT2020    - added writing of facility name to corro api dataset for API_COR_TC06
    ...    @update: kduenas      27OCT2020    - added writing of facility name to corro api dataset for API_COR_TC21
    [Arguments]    ${ExcelPath}
    
    ###Data Generation###
    ${Facility_NamePrefix}    Read Data From Excel    CRED02_FacilitySetup    Facility_NamePrefix    ${rowid}
    ${Facility_Name}    Auto Generate Name Test Data    ${Facility_NamePrefix}
    Write Data To Excel    CRED01_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Loan_FacilityName    ${rowid}    ${Facility_Name}         
    Write Data To Excel    SERV18_Payments    Facility_Name    ${rowid}    ${Facility_Name}     
    Write Data To Excel    SERV29_PaymentFees    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    AMCH06_PricingChangeTransaction    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    SERV21_InterestPayments    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    Correspondence    Facility_Name    ${rowid}    ${Facility_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Facility_Name    3    ${Facility_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Facility_Name    5    ${Facility_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Facility_Name    6    ${Facility_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Facility_Name    21    ${Facility_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid

    ###For Scenario 4###
    Run Keyword If    '${rowid}'=='4'    Run Keywords    Write Data To Excel    AMCH02_LenderShareAdjustment    Facility_Name    ${rowid}    ${Facility_Name}        
    ...    AND    Write Data To Excel    SERV09C_LoanRepricing    Facility_Name    ${rowid}    ${Facility_Name}        
    ...    AND    Write Data To Excel    SERV22_InterestPayments    Facility_Name    ${rowid}    ${Facility_Name}    
    ...    AND    Write Data To Excel    SERV22_InterestPayments    Loan_FacilityName    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    AMCH05_ExtendMaturityDate    Facility_Name    ${rowid}    ${Facility_Name} 

    ###For Scenario 7###
    Run Keyword If    '${SCENARIO}'=='7'    Run Keywords    Write Data To Excel    SERV35_Terminate_FacilityDeal    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV19_UnscheduledPayments    Facility_Name    ${rowid}    ${Facility_Name}     
    
    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Write Data To Excel    SERV18_Payments    Facility_ProposedCmt    ${rowid}    ${Facility_ProposedCmtAmt}
    
    ##Facility Notebook - Summary Tab###
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Time from From Date and Returns Weekday    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Time from From Date and Returns Weekday    ${Facility_EffectiveDate}    396
    Write Data To Excel    SERV01_LoanDrawdown   Loan_MaturityDate    ${rowid}     ${Facility_MaturityDate}
    Enter Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Run Keyword If    '${SCENARIO}'=='1'    Run Keywords    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    SYND02_PrimaryAllocation    Primary_PortfolioExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate} 
    Run Keyword If    '${SCENARIO}'=='4'    Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Loan_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Repayment_TriggerDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    AMCH02_LenderShareAdjustment    AssignmentSell_CircledDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    CRED01_DealSetup    Primary_PortfolioExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_MaturityDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate} 
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType1]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency1]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
   
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency1]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency1]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${Facility_EffectiveDate}

Setup Syndicated Deal
    [Documentation]    This keyword is used to create a Syndicated Deal.
    ...    Primarily entering data in multiple tabs of the Deal Notebook and adding Pricing Options.
    ...    @author: bernchua
    ...    @update: amansueto    15APR2020    - merged select actions and validate field keywords to Create New Deal
    ...    @update: kduenas    08OCT2020    - added writing of deal name to corro api dataset for API_CORRO_TC07
    [Arguments]    ${ExcelPath}

    ###Data Generation###
    ${Deal_Name}    Auto Generate Name Test Data    &{ExcelPath}[Deal_NamePrefix]
    ${Deal_Alias}    Auto Generate Name Test Data    &{ExcelPath}[Deal_AliasPrefix]  
    Write Data To Excel    CRED01_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED09_AdminFee    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED10_EventFee    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV01A_LoanDrawdown    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    AMCH10_ChangeAgencyFee    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    MTAM07_FacilityShareAdjustment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV29_PaymentFees    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV08_ComprehensiveRepricing    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV30_AdminFeePayment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV21_InterestPayments    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV33_RecurringFee    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV40_BreakFunding    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV23_PaperclipTransaction    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV05_SBLCIssuance    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    AMCH10_ChangeAgencyFee    Deal_Alias    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV20_UnschedPrincipalPayments    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SYND02_PrimaryAllocation    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    7    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Deal_Name    20    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
      
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

Setup Term Facility for Syndicated Deal 
    [Documentation]    This keyword is used to create a Term Facility.
    ...    @author: bernchua
    ...    @update: ritragel    21FEB2019    Updated Writing and dataSet
    ...    @update: dahijara    24JUL2020    Added scenario 5 condition for writing Facility_Name in SYND02_PrimaryAllocation
    ...    @update: dahijara    25 AUG2020    Added writing for scenario 5 Facility name - SERV10_ConversionOfInterestType
    ...    @update: kduenas     08OCT2020    Added writing of facility name to corro apidataset for API_CORRO_TC07
    ...    @update: kduenas     08OCT2020    Added writing of facility name to corro apidataset for API_CORRO_TC22
    [Arguments]    ${ExcelPath}
    
    ###Data Generation###
    ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    Write Data To Excel    CRED01_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}
    Write Data To Excel    CRED10_EventFee    Facility_Name    ${rowid}    ${Facility_Name}
    Run Keyword If    '${SCENARIO}'!='5'    Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name    ${rowid}    ${Facility_Name}
    
    Run Keyword If    '${SCENARIO}'=='2'    Run Keywords    Write Data To Excel    MTAM07_FacilityShareAdjustment    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV01A_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV08_ComprehensiveRepricing    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV33_RecurringFee    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV20_UnschedPrincipalPayments    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV40_BreakFunding    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV23_PaperclipTransaction    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV05_SBLCIssuance    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    Correspondence    Facility_Name    7    ${Facility_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    Correspondence    Facility_Name    20    ${Facility_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid

    
    Run Keyword If    '${SCENARIO}'=='5'    Run Keywords    Write Data To Excel    SERV13_InterestCapitalization    Loan_FacilityName    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV01A_TermAndSBLC    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV21_InterestPayments    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV08C_ComprehensiveRepricing    Facility_Name    ${rowid}    ${Facility_Name}  
    ...    AND    Write Data To Excel    SERV29_PaymentFees    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    MTAM08_LoanShareAdjustment    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    SERV10_ConversionOfInterestType    Facility_Name    ${rowid}    ${Facility_Name}
    ...    AND    Write Data To Excel    Correspondence    Facility_Name    22    ${Facility_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}
    
    ###Facility Creation###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]    ${FacilityName}
    ...    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${Facility_EffectiveDate}    365
    ${Facility_MaturityDate}    Add Days to Date    ${Facility_EffectiveDate}    395

    Run Keyword If    '${SCENARIO}'=='5'    Run Keywords    Write Data To Excel    SERV13_InterestCapitalization    Capitalization_FromDate    ${rowid}    ${Facility_AgreementDate}    
    ...    AND    Write Data To Excel    SERV13_InterestCapitalization    Capitalization_ToDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}
    
    Run Keyword If    '${SCENARIO}'=='2'    Write Data To Excel    SERV01A_LoanDrawdown    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}
    
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
    Write Data To Excel    CRED01_DealSetup    ApproveDate    ${rowid}    ${EffectiveDate}
    Write Data To Excel    CRED01_DealSetup    CloseDate    ${rowid}    ${EffectiveDate}
    Write Data To Excel    CRED01_DealSetup    Primary_CircledDate    ${rowid}    ${EffectiveDate}
    Write Data To Excel    CRED01_DealSetup    Primary_PortfolioExpiryDate    ${rowid}    ${ExpiryDate}
    Write Data To Excel    CRED10_EventFee    EventFee_EffectiveDate    ${rowid}    ${EffectiveDate}
    ${EventFee_NoRecurrencesAfterDate}    Get Back Dated Current Date    -365
    Write Data To Excel    CRED10_EventFee    EventFee_NoRecurrencesAfterDate    ${rowid}    ${EventFee_NoRecurrencesAfterDate}
        
Syndicated Deal Approval and Close
    [Documentation]    This keywords Approves and Closes the created Syndicated Deal.
    ...    @author: bernchua
    ...    @update: ritragel    27FEB2019    Remove unnecessary updates, removed Writing, complied with automation checklist, removed 2nd Facility verification
    ...    @update: clanding    29JUL2020    Updated hard coded values to global variables; removed mx keywords
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
   
Approve and Close Comprehensive Deal
    [Documentation]    This keywords Approves and Closes the created Syndicated Deal.
    ...    @author: bernchua
    ...    <updated> @author: ghabal- added scripts to relogin an inputter upon approval
    ...    <updated> @author: ghabal- removed closed all windows keywords at the end of ths script
    ...    @update: ehugo    30JUN2020    - used 'Navigate to Deal Notebook Workflow and Proceed With Transaction' instead of 'Navigate Notebook Workflow'
    ...    @update: dahijara    22JUL2020    - added excel writing for SYND04_TickingFeePayment
    [Arguments]    ${ExcelPath}

    ${CurrentDate}    Get System Date
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}  
    Navigate to Deal Notebook Workflow and Proceed With Transaction    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    ${CurrentDate}
    Close the Deal    ${CurrentDate}
    
    ### Validate Deal, Facility and Circle Notebooks status after Deal Close.
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    Verify Circle Notebook Status After Deal Close    &{ExcelPath}[Primary_Lender1]
    Verify Facility Status After Deal Close    &{ExcelPath}[Facility_Name]
    Verify Facility Status After Deal Close    &{ExcelPath}[Facility2_Name]
    Verify Deal Status After Deal Close
    Validate Deal Closing Cmt With Facility Total Global Current Cmt
    ${Deal_ClosingCmt}    Get Deal Closing Cmt
    Write Data To Excel    CRED08_TickingFee    Deal_ClosingCmt    &{ExcelPath}[rowid]    ${Deal_ClosingCmt}
    Write Data To Excel    SYND04_TickingFeePayment    Deal_ClosingCmt    &{ExcelPath}[rowid]    ${Deal_ClosingCmt}
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Create Deal - Baseline SBLC
    [Documentation]    This high level keyword creates SBLC Baseline Deal dedicated for Scenario 3
    ...    @update:    jdelacru    10APR19    Applied automation coding standards
    ...    @update:    jdelacru    11APR19    Deleted Keyword for Modify Financial Ratio and Modify Upfront Fees as per GS Review
    ...    @update: bernchua    28JUN2019    Removed 1 argument in Create New Deal keyword
    ...    @author: bernchua    10JUL2019    Updated passed argument for Add Bank Role keyword
    ...    @update: ehugo    10OCT2019    Added writing of CreatedUser, UnrestrictedUser and FRCUser to test data
    ...    @update: ehugo    16OCT2019    Directly used INPUTTER_USERNAME value from IDT>py for CreatedUser, UnrestrictedUser and FRCUser
    ...    @update: amansueto    15APR2020    - merged select actions and validate field keywords to Create New Deal
    ...    @update: ehugo    29MAY2020    - removed writing of facility data
    ...    @update: clanding    17JUL2020    - removed commented code 'Get Current Date and Save on Excel'
    ...    @update: clanding    21JUL2020    - added getting of Branch Code for Primary_PortfolioBranch value and write it to Branch_Code for SERV24_CreateCashflow
    ...                                      - added getting of Method Desc and Method Type from Remittance List and write it to Remittance_Instruction for SERV24_CreateCashflow
    [Arguments]    ${ExcelPath}
    
    ## Get Table Maintenance Code for Branch
    ${Branch_Code}    Get Branch Code from Table Maintenance    &{ExcelPath}[Primary_PortfolioBranch]
    Close All Windows on LIQ
    Write Data To Excel    SERV24_CreateCashflow    Branch_Code    ${rowid}    ${Branch_Code}
    Write Data To Excel    SERV24_CreateCashflow    Host_Bank    ${rowid}    ${Branch_Code}/&{ExcelPath}[BankRole_Portfolio]/&{ExcelPath}[BankRole_ExpenseCode]
    
    ###Date Setup###    
    ${CurrentDate}    Get System Date on LIQ and Save on Excel    ${temp}    ${rowid}    &{ExcelPath}[Deal_DaysSubtractedFromSystemDate]
    Write Data To Excel    CRED01_DealSetup    FinancialRatioStartDate    ${rowid}    ${CurrentDate}
    Write Data To Excel    CRED01_DealSetup    CreatedEffectiveDate    ${rowid}    ${CurrentDate}
    Write Data To Excel    CRED01_DealSetup    UnrestrictedEffectiveDate    ${rowid}    ${CurrentDate}   
    Write Data To Excel    CRED01_DealSetup    FRCEffectiveDate    ${rowid}    ${CurrentDate}
    Write Data To Excel    CRED01_DealSetup    CreatedEventDate    ${rowid}    ${CurrentDate}
    Write Data To Excel    CRED01_DealSetup    UnrestrictedEventDate    ${rowid}   ${CurrentDate}
    Write Data To Excel    CRED01_DealSetup    FRCEventDate    ${rowid}    ${CurrentDate} 
    Write Data To Excel    CRED01_DealSetup    Primary_CircledDate    ${rowid}    ${CurrentDate}      
    Write Data To Excel    CRED01_DealSetup    ApproveDate    ${rowid}    ${CurrentDate}   
    Write Data To Excel    CRED01_DealSetup    CloseDate    ${rowid}    ${CurrentDate}  
    Write Data To Excel    CRED01_DealSetup    ActualDueDate    ${rowid}    ${CurrentDate}   
    Write Data To Excel    CRED01_DealSetup    Deal_EffectiveDate    ${rowid}    ${CurrentDate} 
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${CurrentDate}
    Write Data To Excel    SERV05_SBLCIssuance    Effective_Date    ${rowid}    ${CurrentDate}   
    
    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    Write Data To Excel    CRED01_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Deal_Name    ${rowid}    ${Deal_Name} 
    Write Data To Excel    SERV05_SBLCDecrease    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    MTAM05A_CycleShareAdjustment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV05_SBLCIssuance    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
    ${Deal_Alias}    Read Data From Excel    CRED01_DealSetup    Deal_Alias    ${rowid}
    ${FinancialRatioStartDate}    Read Data From Excel    CRED01_DealSetup    FinancialRatioStartDate    ${rowid}
    
    ###New Deal Screen###
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    
    ###Deal Notebook - Summary Tab###   
    Add Deal Borrower    &{ExcelPath}[Deal_Borrower]
    ${Method_Desc}    ${MethodType_Desc}    Get Method Description from Borrower    &{ExcelPath}[BankRole_SG_Method]        &{ExcelPath}[Borrower_Location]
    Write Data To Excel    SERV24_CreateCashflow    Remittance_Instruction    ${rowid}    ${Method_Desc}
    Write Data To Excel    SERV24_CreateCashflow    RemittanceInstruction_RTGSDescriptionAUD    ${rowid}    ${MethodType_Desc}
    Select Deal Borrower Location and Servicing Group    &{ExcelPath}[Borrower_Location]    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_SG_Method]    &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[Borrower_SG_Name]
    Select Deal Borrower Remmitance Instruction    &{ExcelPath}[Deal_Borrower]    ${Deal_Name}    &{ExcelPath}[Borrower_Location]
	Set Deal as Sole Lender
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]    &{ExcelPath}[AdminAgent_ServicingGroup]
    Enter Agreement Date and Proposed Commitment Amount    &{ExcelPath}[Deal_AgreementDate]    &{ExcelPath}[Deal_ProposedCmt]
    Unrestrict Deal
    
    ###Deal Notebook - Personnel Tab###
    Uncheck Early Discussion Deal Checkbox
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Deal Notebook - Calendars Tab###
    Delete Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    ###Deal Notebook - Pricing Rules Tab###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption2]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]     
    Add Pricing Option for SBLC    &{ExcelPath}[PricingRule_LOC]    &{ExcelPath}[InitialFractionRate_Round_LOC]    &{ExcelPath}[RoundingDecimal_Round_LOC]    &{ExcelPath}[NonBusinessDayRule_LOC]    &{ExcelPath}[BillingNumberOfDays_LOC]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]    &{ExcelPath}[PricingRule_BillBorrowerStatus1]    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    ##Deal Notebook - Events Tab###  
    Verify Details on Events Tab    ${INPUTTER_USERNAME.upper()}    ${INPUTTER_USERNAME.upper()}    ${INPUTTER_USERNAME.upper()}    
    
    ### Deal Notebook - Bank Roles Tab ###
    Add Bank Role    SBLC/Guarantee Issuer    &{ExcelPath}[Bank_Name]    &{ExcelPath}[BankRole_SG_Alias]    &{ExcelPath}[BankRole_SG]    &{ExcelPath}[BankRole_SG_GroupMembers]
    ...    &{ExcelPath}[BankRole_SG_Method]    &{ExcelPath}[BankRole_Portfolio]    &{ExcelPath}[BankRole_ExpenseCode]    &{ExcelPath}[BankRole_ExpenseCodeDesc]
        
Setup Syndicated Deal for Non-Agent and Host Bank
    [Documentation]    This keyword is used to create a Syndicated Deal for a Host Bank and a Non-Agent Bank.
    ...    Primarily entering data in multiple tabs of the Deal Notebook and adding Pricing Options.
    ...    @author: bernchua
    ...    @update: amansueto    15APR2020    - merged select actions and validate field keywords to Create New Deal
    ...    @update: clanding    29JUL2020    - updated hardcoded values to dataset/global variable; removed writing for CRED09
    ...    @update: clanding    10AUG2020    - added writing of Deal to SERV02
    ...    @update: clanding    13AUG2020    - added writing of Deal to SERV09
    ...    @update: fluberio    12OCT2020    - added condition in Holdiay Creation and Pricing Rules for EU since in EU there are 5 Holiday Calendar and 4 Pricing Options
    ...    @update: fluberio    22OCT2020    - added writing of Deal Name to Notices_UpfrontFee
    ...    @update: kduenas     29OCT2020    - added writing of deal name to corro api dataset for API_COR_TC15   
    [Arguments]    ${ExcelPath}
    
	###Switch to Original User###
	Logout from Loan IQ
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Data Generation###
    ${Deal_Name}    Auto Generate Name Test Data    &{ExcelPath}[Deal_NamePrefix]
    ${Deal_Alias}    Auto Generate Name Test Data    &{ExcelPath}[Deal_AliasPrefix]
    Write Data to Excel    CRED01_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    CRED01_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}
    Write Data to Excel    CRED10_EventFee    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    SYND02_Primary_Allocation    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    AMCH11_AddFacility    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    SYND05_UpfrontFee_Payment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    AMCH06_PricingChangeTransaction    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    SERV22_InterestPayments    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    AMCH02_LenderShareAdjustment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    AMCH05_ExtendMaturityDate    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    SERV02_LoanDrawdownNonAgent    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data to Excel    SERV09_LoanRepricing    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    15    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Write Data to Excel    Correspondence    Deal_Name    ${rowid}    ${Deal_Name}
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}
    ${Deal_Alias}    Read Data From Excel    CRED01_DealSetup    Deal_Alias    ${rowid}
    
    ###Deal Select Window###
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    
    ###Summary Tab###
    Unrestrict Deal
    
    ###Deal Borrower Setup###
    Add Deal Borrower    &{ExcelPath}[Borrower_ShortName]
    Set Deal Borrower Servicing Group    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_Name]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_PreferredRIMthd1]
    Go To Deal Borrower Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Borrower Setup
    
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    ###Deal Admin Agent Setup###
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Set Deal Admin Agent Servicing Group    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_ServicingGroup]    &{ExcelPath}[AdminAgent_ContactName]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Go To Admin Agent Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Admin Agent Setup
    Write Data To Excel    CRED02_FacilitySetup    Facility_ProposedCmtAmt    ${rowid}    &{ExcelPath}[Deal_ProposedCmt]
    Write Data To Excel    SYND02_Primary_Allocation    Deal_Amount    ${rowid}    &{ExcelPath}[Deal_ProposedCmt]
    
    ${Deal_AgreementDate}    Get System Date
    ${AdminFee_DueDate}    Add Days to Date    ${Deal_AgreementDate}    &{ExcelPath}[Add_To_Deal_AgreementDate]
    Run Keyword If   '${SCENARIO}'=='4'    Run Keywords    Write Data To Excel    CRED01_DealSetup    Deal_AgreementDate    ${rowid}    ${Deal_AgreementDate}
    ...    AND    Write Data To Excel    CRED01_DealSetup    FinancialRatioStartDate    ${rowid}    ${Deal_AgreementDate}
    ...    AND    Write Data To Excel    CRED01_DealSetup    CreatedEffectiveDate    ${rowid}    ${Deal_AgreementDate}
    ...    AND    Write Data To Excel    CRED01_DealSetup    UnrestrictedEffectiveDate    ${rowid}    ${Deal_AgreementDate}
    ...    AND    Write Data To Excel    CRED01_DealSetup    FRCEffectiveDate    ${rowid}    ${Deal_AgreementDate}
    ...    AND    Write Data To Excel    CRED01_DealSetup    ActualDueDate    ${rowid}    ${Deal_AgreementDate}
    ...    AND    Write Data To Excel    CRED01_DealSetup    Deal_EffectiveDate    ${rowid}    ${Deal_AgreementDate}    
           
    Enter Agreement Date and Proposed Commitment Amount    ${Deal_AgreementDate}    &{ExcelPath}[Deal_ProposedCmt]
    
    ###Personnel Tab###
    Uncheck Early Discussion Deal Checkbox
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Calendars Tab###
    Run Keyword If    '&{ExcelPath}[Entity]' == 'EU'    Run Keywords    Set Deal Calendar    &{ExcelPath}[HolidayCalendar]
    ...    AND    Set Deal Calendar    &{ExcelPath}[HolidayCalendar2]
    ...    AND    Set Deal Calendar    &{ExcelPath}[HolidayCalendar3]
    ...    AND    Set Deal Calendar    &{ExcelPath}[HolidayCalendar4]
    ...    AND    Set Deal Calendar    &{ExcelPath}[HolidayCalendar5]
    ...    ELSE IF    '&{ExcelPath}[Entity]' == 'AU'    Set Deal Calendar    &{ExcelPath}[HolidayCalendar]
    
    
    ###Pricing Rules Tab###
    ###Pricing Options###
    Run Keyword If    '&{ExcelPath}[Entity]' == 'EU'    Run Keywords    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    ...    AND    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption2]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    ...    AND    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption3]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    ...    AND    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption4]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    ...    ELSE IF    '&{ExcelPath}[Entity]' == 'AU'    Run Keywords    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    ...    AND    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption2]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    
    ###Pricing Rules###
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
    ...    ${ON}    &{ExcelPath}[PricingRule_BillNoOfDays1] 

Create Revolver Facility
    [Documentation]    This high-level keyword is used to create an initial set up of Revolver Facility
    ...    @author: ritragel
    ...    @update: clanding    27JUL2020    - updated SERV09C_LoanRepricing to SERV09_LoanRepricing
    ...                                      - updated SERV01_LoanDrawdown to SERV02_LoanDrawdownNonAgent
    ...    @update: clanding    10AUG2020    - added writing of facility to SERV02_LoanDrawdownNonAgent
    ...    @update: fluberio    22OCT2020    - added writing of Facility Name to Notices_UpfrontFee
    [Arguments]    ${ExcelPath}
    
    ###Test Data Generation and Writings###
	${FacilityName}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${FacilityName}   
	Write Data To Excel    CRED01_DealSetup    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${FacilityName}
    Write Data to Excel    AMCH06_PricingChangeTransaction    Facility_Name    ${rowid}    ${FacilityName}
	Write Data to Excel    SERV09_LoanRepricing    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    SERV22_InterestPayments    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    AMCH02_LenderShareAdjustment    Facility_Name    ${rowid}    ${Facility_Name}
	Write Data to Excel    AMCH05_ExtendMaturityDate    Facility_Name    ${rowid}    ${Facility_Name}
	Write Data to Excel    SERV02_LoanDrawdownNonAgent    Facility_Name    ${rowid}    ${Facility_Name}
	Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Write Data to Excel    Correspondence    Facility_Name    ${rowid}    ${Facility_Name}
	Set To Dictionary    ${ExcelPath}    Facility_Name=${FacilityName}
	
	###Add Revolver Facility###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]
    ...    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Date Settings##
    ${SystemDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${SystemDate}    &{ExcelPath}[Add_To_Facility_ExpiryDate]
    ${Facility_MaturityDate}    Add Days to Date    ${SystemDate}    &{ExcelPath}[Add_To_Facility_MaturityDate]  
    Set Facility Dates    ${SystemDate}    ${SystemDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate} 
	Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
	Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate}
	Write Data To Excel    SERV02_LoanDrawdownNonAgent    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    ${rowid}    ${SystemDate}  
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${SystemDate}     
    
    ###Facility Notebook - Types/Purpose###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType]
    
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ###Facility Notebook - Restrictions###
    Add Facility Currency    &{ExcelPath}[Facility_Currency]
    
    ###Facility Notebook - Sublimit/Cust###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${SystemDate} 
    
    ###Facility Notebook - Summary###
    Validate Multi CCY Facility
    
Setup Syndicated Deal For Secondary Sale
    [Documentation]    This keyword is used to create a Syndicated Deal for Secondary Sale.
    ...    Primarily entering data in multiple tabs of the Deal Notebook and adding Pricing Options.
    ...    @author: bernchua
    ...    @update: jdelacru    20FEB2019    - Added Deal Calendar for USD
    ...    @update: jdelacru    27FEB2019    - Moved writing of Deal Name and Deal Alias in highlevel keyword
    ...    @update: bernchua    28JUN2019    Removed 1 argument in Create New Deal keyword
    ...    @update: amansueto    15APR2020    - merged select actions and validate field keywords to Create New Deal
    ...    @update: dahijara    25 AUG2020    Added writing for scenario 5 Deal name - SERV10_ConversionOfInterestType
    ...    @update: kduenas     07OCT2020    - Added writing of deal name to corro api dataset for API_CORRO_TC04
    ...    @update: kduenas     27OCT2020    - Added writing of deal name to corro api dataset for API_CORRO_TC22
    [Arguments]    ${ExcelPath}
    ###Data Generation###
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]    &{ExcelPath}[rowid]
    
    Write Data To Excel    CRED01_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED09_AdminFee    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED10_EventFee    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    MTAM08_LoanShareAdjustment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV01A_TermAndSBLC    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV01_TermLoanDrawdowninUSD    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV10_ConversionOfInterestType    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV08C_ComprehensiveRepricing    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV13_InterestCapitalization    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV21_InterestPayments    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV29_PaymentFees    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV29_PaymentFees    ScheduledActivity_DealName    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV30_AdminFeePayment    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    TRP002_SecondarySale    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    4    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Deal_Name    22    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Deal_Alias}    Read Data From Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]
    
    ###Deal Select Window###
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    
    ###Summary Tab###
    Unrestrict Deal
    
    ###Deal Borrower Setup###
    Add Deal Borrower    &{ExcelPath}[Deal_Borrower]
    Set Deal Borrower Servicing Group    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_Name]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_PreferredRIMthd1]
    Go To Deal Borrower Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Borrower Setup
    
    ${Borrower_Name}    Get Borrower Name From Deal Notebook
    ${Customer_LegalName}    Get Customer Legal Name From Customer Notebook Via Deal Notebook
    Write Data To Excel    SERV30_AdminFeePayment    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_Name}
    Write Data To Excel    SERV30_AdminFeePayment    Customer_LegalName    &{ExcelPath}[rowid]    ${Customer_LegalName}
    Write Data To Excel    CRED10_EventFee    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_Name}
    
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    ###Deal Admin Agent Setup
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Set Deal Admin Agent Servicing Group    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_ServicingGroup]    &{ExcelPath}[AdminAgent_ContactName]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Go To Admin Agent Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Admin Agent Setup
    ${Deal_AgreementDate}    Get System Date
    Write Data To Excel    CRED01_DealSetup    Deal_AgreementDate    ${rowid}    ${Deal_AgreementDate}
    Enter Agreement Date and Proposed Commitment Amount    ${Deal_AgreementDate}    &{ExcelPath}[Deal_ProposedCmt]
    
    # Personnel Tab
    Uncheck Early Discussion Deal Checkbox
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    # Calendars Tab
    Set Deal Calendar    &{ExcelPath}[HolidayCalendarAUD]
    Set Deal Calendar    &{ExcelPath}[HolidayCalendarUSD]
    
    # Pricing Rules Tab
    # Pricing Options
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption2]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption3]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Deal Pricing Options    &{ExcelPath}[Deal_PricingOption4]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    
    ...    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    # Pricing Rules
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
    ...    ON    &{ExcelPath}[PricingRule_BillNoOfDays1]
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee2]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]
    ...    ON    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    # Get necessary data from created Deal to be used in succeeding transactions
    ${Date}    Get Data From LoanIQ    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    Summary    ${LIQ_DealSummaryAgreementDate_Textfield}
    Write Data To Excel    CRED09_AdminFee    AdminFee_EffectiveDate    ${rowid}    ${Date}
    Write Data To Excel    CRED09_AdminFee    AdminFee_ActualDueDate    ${rowid}    ${Date}
    Write Data To Excel    CRED09_AdminFee    AdminFee_AdjustedDueDate    ${rowid}    ${Date}
    Write Data To Excel    SERV30_AdminFeePayment    AdminFeePayment_EffectiveDate    ${rowid}    ${Date}
    Write Data To Excel    SERV30_AdminFeePayment    AdminFee_DueDate    ${rowid}    ${Date}
    
    ${ScheduledActivityFilter_FromDate}    Subtract Days to Date     ${Date}    30
    ${ScheduledActivityFilter_ThruDate}    Add Days to Date    ${Date}    30
    Write Data To Excel    SERV30_AdminFeePayment    ScheduledActivityFilter_FromDate    ${rowid}    ${ScheduledActivityFilter_FromDate}
    Write Data To Excel    SERV30_AdminFeePayment    ScheduledActivityFilter_ThruDate    ${rowid}    ${ScheduledActivityFilter_ThruDate}
    
    ###Mx Select    ${LIQ_DealNotebook_File_Save}
    
Setup Bank Role Syndicated Deal With Secondary Sale
    [Documentation]    This keyword sets up the Bank Role in a Syndicated Deal for Secondary Sale.
    ...    @author: bernchua
    ...    @author: bernchua    10JUL2019    Updated passed argument for Add Bank Role keyword
    [Arguments]    ${ExcelPath}
    Add Bank Role    SBLC/Guarantee Issuer    &{ExcelPath}[BankRole_Lender]    &{ExcelPath}[BankRole_SGAlias]    &{ExcelPath}[BankRole_SGName]    &{ExcelPath}[BankRole_SGGroupMember]
    ...    &{ExcelPath}[BankRole_RIMthd]    &{ExcelPath}[BankRole_Portfolio]    &{ExcelPath}[Deal_ExpenseCode]    &{ExcelPath}[BankRole_ExpenseCodeDesc]

Setup Bilateral Deal with Multiple Risk Type
    [Documentation]    This high-level keyword set ups a Bilateral Deal with Multiple Risk Types.
    ...    @author: bernchua
    ...    @update: rtarayao    26FEB2019    Updated read and write actions; deleted "add deal pricing options"
    ...    @author: bernchua    10JUL2019    Updated passed argument for Add Bank Role keyword
    ...    @update: amansueto    15APR2020    - merged select actions and validate field keywords to Create New Deal
    ...    @update: kduenas    28OCT2020    added writing of deal name to corro dataset for api_cor_tc13
    [Arguments]    ${ExcelPath}
    
    ###Test Data Generation###
    ${Deal_Name}    Generate Name Test Data    &{ExcelPath}[Deal_NamePrefix]
    ${Deal_Alias}    Generate Name Test Data    &{ExcelPath}[Deal_AliasPrefix] 
    Write Data To Excel    CRED01_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV_47_FlexPISchedule    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV05_SBLCIssuance    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV23_LoanPaperClip    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV29_PaymentFees    Deal_Name    ${rowid}    ${Deal_Name} 
    Write Data To Excel    SERV29_PaymentFees    Deal_Name    2    ${Deal_Name}    
    Write Data To Excel    SERV18_Payments    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    PTRF_CRE01_PortfolioTransfer   Deal_Name    ${rowid}    ${Deal_Name}     
    Write Data To Excel    MTAM06B_CycleShareAdjustment   Deal_Name    ${rowid}    ${Deal_Name} 
    Write Data To Excel    MTAM05B_CycleShareAdjustment   Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    13    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias} 
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    ${rowid}  
    ${Deal_Alias}    Read Data From Excel    CRED01_DealSetup    Deal_Alias    ${rowid}
    
    ${SystemDate}    Get System Date                    
    
    ###New Deal Screen###
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    
    ###Deal Notebook - Summary Tab (Setting up Customer within the Deal)###
    Add Deal Borrower    &{ExcelPath}[Deal_Borrower]
    Set Deal Borrower Servicing Group    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_Name]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_PreferredRIMthd1]
    Go To Deal Borrower Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Borrower Setup
    
	Set Deal as Sole Lender
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    ###Deal Notebook - Summary Tab >> Admin Agent Setup###
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Set Deal Admin Agent Servicing Group    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_ServicingGroup]    &{ExcelPath}[AdminAgent_ContactName]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Go To Admin Agent Preferred RI Window
    Add Preferred Remittance Instruction    ${Deal_Name}    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Add Preferred Remittance Instruction    ${Deal_Name}    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_PreferredRIMthd2]
    Complete Deal Admin Agent Setup
    
    Enter Agreement Date and Proposed Commitment Amount    &{ExcelPath}[Deal_AgreementDate]    &{ExcelPath}[Deal_ProposedCmt]
    Unrestrict Deal
    
    ###Deal Notebook - Personnel Tab (Declaration of Expense Code to be Used)###
    Uncheck Early Discussion Deal Checkbox
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Deal Notebook - Calendars Tab###
    Delete Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    ###Deal Notebook - Ratios/Conds Tab###
    Add Financial Ratio    &{ExcelPath}[RatioType]    &{ExcelPath}[FinancialRatio]    ${SystemDate}
    
    ###Deal Notebook - Fees Tab###
    # Modify Upfront Fees    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[UpfrontFee_RateBasis]    &{ExcelPath}[UpfrontFee_Percent]
    
    ###Deal Notebook - Pricing Rules Tab###
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd]    &{ExcelPath}[PricingRule_NonBussDayRule]    &{ExcelPath}[PricingRule_BillBorrowerStatus]    &{ExcelPath}[PricingRule_BillNoOfDays]
    Write Data To Excel    SERV29_PaymentFees    Fee_Type1    ${rowid}    &{ExcelPath}[PricingRule_Fee1]
    Write Data To Excel    MTAM06B_CycleShareAdjustment    OngoingFee_Type    ${rowid}    &{ExcelPath}[PricingRule_Fee1]
    Write Data To Excel    MTAM05B_CycleShareAdjustment    OngoingFee_Type    ${rowid}    &{ExcelPath}[PricingRule_Fee1]
  
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee2]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd2]    &{ExcelPath}[PricingRule_NonBussDayRule2]    &{ExcelPath}[PricingRule_BillBorrowerStatus2]    &{ExcelPath}[PricingRule_BillNoOfDays2]

    ###Deal Notebook - Events Tab (Validation of Deal Events)###    
    Verify Details on Events Tab    &{ExcelPath}[CreatedUser]    &{ExcelPath}[UnrestrictedUser]    &{ExcelPath}[FRCUser]
    
    ###Deal Notebook - Bank Roles Tab###
    Add Bank Role    SBLC/Guarantee Issuer    &{ExcelPath}[BankRole_Lender]    &{ExcelPath}[BankRole_SGAlias]    &{ExcelPath}[BankRole_SGName]    &{ExcelPath}[BankRole_SGGroupMember]
    ...    &{ExcelPath}[BankRole_RIMthd]    &{ExcelPath}[BankRole_Portfolio]    &{ExcelPath}[BankRole_ExpenseCode]    &{ExcelPath}[BankRole_ExpenseCodeDesc]

Setup Multi-Currency and Multi-Risk Revolver Facility
    [Documentation]    This high-level keyword is used to create an initial set up or baseline for Revolver Facility with Multiple Risk Types and Multiple Currency.
    ...    @author: ritragel
    ...    @update: rtarayao    04MAR2019    Updated documentation, data writings, comments, and low-level keywords used.
    ...    @update: rtarayao    23APR2019    Added Writing for Scenario6
    ...    @update: dahijara    03JUL2020    - Added writing for Expiry_Date in SERV05_SBLCIssuance
    ...    @update: dahijara    08JUL2020    - Added writing for PrincipalAmount in SERV29_PaymentFees
    [Arguments]    ${ExcelPath}
    
    ###Test Data Generation and Writings###
	${FacilityName}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
	Write Data To Excel    CRED08_RevFacilityOngoingFee    Facility_Name    ${rowid}    ${FacilityName}    multipleValue=Y
	Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${FacilityName}   
	Write Data To Excel    SERV05_SBLCIssuance    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    CRED01_DealSetup    Facility_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    SERV29_PaymentFees    Facility_Name    ${rowid}    ${FacilityName}
	
	###Add Revolver Facility###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]
    ...    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Write Data To Excel    SERV29_PaymentFees    PrincipalAmount    ${rowid}    &{ExcelPath}[Facility_ProposedCmtAmt]    
    
    ###Facility Notebook - Date Settings##
    ${SystemDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${SystemDate}    1095
    ${Facility_MaturityDate}    Add Days to Date    ${SystemDate}    1095  
    Set Facility Dates    ${SystemDate}    ${SystemDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate} 
	Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
	Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate}	     
    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    ${rowid}    ${SystemDate}  
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV05_SBLCIssuance    Expiry_Date    ${rowid}    ${Facility_ExpiryDate}  
    
    ###Facility Notebook - Types/Purpose###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType2]
    
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ###Facility Notebook - Restrictions###
    Add Facility Currency    &{ExcelPath}[Facility_Currency1]
    Add Facility Currency    &{ExcelPath}[Facility_Currency2]
    
    ###Facility Notebook - Sublimit/Cust###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${SystemDate} 
    
    ###Facility Notebook - Summary###
    Validate Multi CCY Facility

Setup Multi-Currency and Multi-Risk Term Facility
    [Documentation]    This high-level keyword is used to create an initial set up or baseline for Term Facility with Multiple Risk Types and Multiple Currency.
    ...    @author: ritragel
    ...    @update: rtarayao    06MAR2019    Updated documentation, data writings, comments, and low-level keywords used
    ...    @update: rtarayao    23APR2019    Added Writing for Scenario6
    ...    @update: dahijara    08JUL2020    Updated rowID for writing in SERV29_PaymentFees - PrincipalAmount
    [Arguments]    ${ExcelPath}
    
    ###Test Data Generation and Writings###
    ${FacilityName}    Generate Name Test Data    &{ExcelPath}[Facility2_NamePrefix]
	Write Data To Excel    CRED02_FacilitySetup    Facility2_Name    ${rowid}    ${FacilityName}
	Write Data To Excel    CRED08_TermFacilityOngoingFee    Facility2_Name    ${rowid}    ${FacilityName}    multipleValue=Y
	Write Data To Excel    CRED01_DealSetup    Facility2_Name    ${rowid}    ${FacilityName}
    Write Data To Excel    SERV_47_FlexPISchedule    Facility2_Name    ${rowid}    ${FacilityName}
    Write Data To Excel    SERV23_LoanPaperClip    Facility2_Name    ${rowid}    ${FacilityName}
    Write Data To Excel    SERV29_PaymentFees    Facility_Name    2    ${FacilityName}
    Write Data To Excel    SERV18_Payments    Facility2_Name    ${rowid}    ${FacilityName}
    Write Data To Excel    PTRF_CRE01_PortfolioTransfer    Facility_Name    ${rowid}    ${FacilityName}
    Write Data To Excel    MTAM06B_CycleShareAdjustment    Facility_Name    ${rowid}    ${FacilityName}
    Write Data To Excel    MTAM05B_CycleShareAdjustment    Facility_Name    ${rowid}    ${FacilityName}
    
    ###Add Term Facility###
    Add New Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Deal_Currency]
    ...    ${FacilityName}    &{ExcelPath}[Facility2_Type]    &{ExcelPath}[Facility2_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    Write Data To Excel    SERV23_LoanPaperClip    Facility_Type    ${rowid}    &{ExcelPath}[Facility2_Type]
    Write Data To Excel    SERV18_Payments    Facility_Type    ${rowid}    &{ExcelPath}[Facility2_Type]
    Write Data To Excel    SERV29_PaymentFees    PrincipalAmount    2    &{ExcelPath}[Facility2_ProposedCmtAmt]
    Write Data To Excel    SERV18_Payments    Facility_Type    ${rowid}    &{ExcelPath}[Facility2_Type]
    Write Data To Excel    SERV23_LoanPaperClip    Facility_Type    ${rowid}    &{ExcelPath}[Facility2_Type]
    
    ###Date Settings for Term Facility###
    ${SystemDate}    Get System Date
    ${Facility_ExpiryDate}    Add Days to Date    ${SystemDate}    730
    ${Facility_MaturityDate}    Add Days to Date    ${SystemDate}    730
    Set Facility Dates    ${SystemDate}    ${SystemDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility2_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
	Write Data To Excel    CRED02_FacilitySetup    Facility2_MaturityDate    ${rowid}    ${Facility_MaturityDate} 
    Write Data To Excel    SERV_47_FlexPISchedule    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility2_AgreementDate    ${rowid}    ${SystemDate}  
    Write Data To Excel    CRED02_FacilitySetup    Facility2_EffectiveDate    ${rowid}    ${SystemDate}   
    
    ###Facility Notebook - Types/Purpose###
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType2]
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType3]
    
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ###Facility Notebook - Restrictions###
    Add Facility Currency    &{ExcelPath}[Facility_Currency1]
    Add Facility Currency    &{ExcelPath}[Facility_Currency2]
    
    ###Facility Notebook - Sublimit/Cust###
    Add Borrower    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${SystemDate}
    
    ###Facility Notebook - Summary###
    Validate Multi CCY Facility
        
Setup Comprehensive Deal
    [Documentation]    This high-level keyword sets up a Syndicated Deal with no Lenders, and the "Sole Lender" checkbox is unticked.
    ...    @author: ritragel
    ...    @update: amansueto    15APR2020    - merged select actions and validate field keywords to Create New Deal
    ...    @update: ehugo    22JUN2020    - updated 'Borrower_Name' to 'Borrower_ShortName' for COMPR06_LoanMerge
    ...    @update: dahijara    22JUL2020    - added excel writing for SYND04_TickingFeePayment-Deal_Name
    ...    @update: dahijara    28SEP2020    - Updated sheet name for Loan Merge from COMPR06_LoanMerge to SERV11_Loan Amalgamation
    ...    @update: kiduenas    27OCT2020    - added writing of deal name for API_TC_023 of corro
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    ${Current_Date}    Get System Date
    
    ${Borrower_ShortName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_ShortName    &{ExcelPath}[rowid]
    ${Borrower_ContactFirstName}    Read Data From Excel    ORIG03_Customer    Contact_FirstName    &{ExcelPath}[rowid]
    ${Borrower_ContactLastName}    Read Data From Excel    ORIG03_Customer    Contact_LastName    &{ExcelPath}[rowid]
    ${Borrower_ContactName}    Set Variable    ${Borrower_ContactLastName}${SPACE}${SPACE}${Borrower_ContactFirstName}    
    
    ### Deal Name
    Write Data To Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED09_AdminFee    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED08_TickingFee    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SYND04_TickingFeePayment    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    TRP002_SecondarySale    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    PTRF_CRE01_PortfolioTransfer    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}    multipleValue=Y
    Write Data To Excel    DLCH01_DealChangeTransaction    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    AMCH06_PricingChangeTransaction    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SERV12_LoanSplit    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SERV11_Loan Amalgamation    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CAP02_InterestCapitalRule    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CAP03_InterestPayment    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CAP03_OngoingFeeCapitalization    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CAP02_CapitalizedFeePayment    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    MTAM01_ManualGL    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    MTAM02_ManualCashflow    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    SERV18_Payments    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    Correspondence    Deal_Name    23    ${Deal_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    
    ### Deal Alias
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    &{ExcelPath}[rowid]    ${Deal_Alias}
    
    ### Current Date
    Write Data To Excel    CRED01_DealSetup    Deal_AgreementDate    &{ExcelPath}[rowid]    ${Current_Date}
    Write Data To Excel    CRED01_DealSetup    Deal_ProjectedCloseDate    &{ExcelPath}[rowid]    ${Current_Date}
    Write Data To Excel    CRED01_DealSetup    FinancialRatioStartDate    &{ExcelPath}[rowid]    ${Current_Date}

    ### Deal Borrower Name
    Write Data To Excel    CRED01_DealSetup    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    CRED08_TickingFee    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    SYND04_TickingFeePayment    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    SERV01_LoanDrawdown    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}    multipleValue=Y
    Write Data To Excel    SERV12_LoanSplit    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    SERV11_Loan Amalgamation    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    CAP03_InterestPayment    Loan_Borrower    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    CAP02_CapitalizedFeePayment    Borrower_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    MTAM01_ManualGL    Borrower1_ShortName    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    MTAM02_ManualCashflow    Deal_Borrower    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    Write Data To Excel    SERV18_Payments    Borrower_Name    &{ExcelPath}[rowid]    ${Borrower_ShortName}
    
    ${Deal_AgreementDate}    Read Data From Excel    CRED01_DealSetup    Deal_AgreementDate    &{ExcelPath}[rowid]
    ${Deal_ProjectedCloseDate}    Read Data From Excel    CRED01_DealSetup    Deal_ProjectedCloseDate    &{ExcelPath}[rowid]
        
    # Deal Select Window
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    
    ### Summary Tab ###
    Unrestrict Deal
    
    # Deal Borrower Setup
    Set Deal Borrower    ${Borrower_ShortName}    &{ExcelPath}[Borrower_Location]
    Set Deal Borrower Servicing Group    &{ExcelPath}[Borrower_SG_Alias]    &{ExcelPath}[Borrower_SG_Name]    ${Borrower_ContactName}    &{ExcelPath}[Borrower_PreferredRIMthd1]
    Go To Deal Borrower Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Borrower Setup
    
    Validate Deal As Not Sole Lender
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    # Deal Admin Agent Setup
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Set Deal Admin Agent Servicing Group    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_SGName]    &{ExcelPath}[AdminAgent_ContactName]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Go To Admin Agent Preferred RI Window
    Mark All Preferred Remittance Instruction
    Complete Deal Admin Agent Setup
    
    Enter Agreement Date and Proposed Commitment Amount    ${Deal_AgreementDate}    &{ExcelPath}[Deal_ProposedCmt]
    Save Changes on Deal Notebook
    Enter Deal Projected Close Date    ${Deal_ProjectedCloseDate}
    
    ### Personnel Tab ###
    Uncheck Early Discussion Deal Checkbox
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ### Calendars Tab ###
    ${API_CalendarName}    Read Data From Excel    API_HolidayCalendar    Calendar_Description    &{ExcelPath}[rowid]
    Delete Calendar from Deal Notebook    Sydney, Australia
    Set Deal Calendar    ${API_CalendarName}
    Set Deal Calendar    &{ExcelPath}[HolidayCalendar]
    
Setup Term Facility for Comprehensive Deal
    [Documentation]    This high-level keyword is for setting up a Term Facility With API Validation.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - update sheet name from 'CRED08_OngoingFeeSetup' to 'CRED08_FacilityFeeSetup'
    ...                                   - used 'Enter Facility Dates With Business Day and Non-Business Day Validations for Term Facility' instead of 'Enter Date With Business Day and Non-Business Day Validations'
    ...    @update: clanding    16JUL2020    - updated sheet name from CRED08_FacilityFeeSetup to CRED08_OngoingFeeSetup
    ...    @update: dahijara    28SEP2020    - Updated sheet name for Loan Merge from COMPR06_LoanMerge to SERV11_Loan Amalgamation
    ...    @update: kduenas    27OCT2020    - added writing of facility name for API_TC_023 of corro
    [Arguments]    ${ExcelPath}
    ### Data Generation
    ${Facility_Name}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${CurrentDate}    Get System Date
    
    Write Data To Excel    CRED01_DealSetup    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    TRP002_SecondarySale    Term_Facility_1    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}    multipleValue=Y
    Write Data To Excel    SERV01_LoanDrawdown    Loan_FacilityName    &{ExcelPath}[rowid]    ${Facility_Name}    multipleValue=Y
    Write Data To Excel    AMCH03_UnschedFacilityIncrease    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    SERV11_Loan Amalgamation    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    CAP03_OngoingFeeCapitalization    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    CAP02_CapitalizedFeePayment    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    SERV18_Payments    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    TRP002_SecondarySale    Facility_Amount_1    &{ExcelPath}[rowid]    &{ExcelPath}[Facility_ProposedCmtAmt]
    Write Data To Excel    Correspondence    Facility_Name    23    ${Facility_Name}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    
    
    ### Facility Creation
    Add New Facility    ${Deal_Name}    &{ExcelPath}[Deal_Currency]    ${Facility_Name}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ### Summary Tab ###
    ### Facility Dates
    ${NBD_ExpiryDate}    Read Data From Excel    API_HolidayCalendar    NonBusinessDay_Date    2
    ${NBD_HolidayName}    Read Data From Excel    API_HolidayCalendar    NonBusinessDay_Reason    2
    ${MaturityDate}    Get Future Date    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[NumberOfDays_ToAdd]
    ${ExpiryDate}    Get Future Date    &{ExcelPath}[Facility_AgreementDate]    &{ExcelPath}[NumberOfDays_ToAdd]
    
    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    &{ExcelPath}[rowid]    ${CurrentDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    &{ExcelPath}[rowid]    ${CurrentDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    &{ExcelPath}[rowid]    ${MaturityDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    &{ExcelPath}[rowid]    ${ExpiryDate}
    
    Enter Facility Dates With Business Day and Non-Business Day Validations for Term Facility    ${CurrentDate}    ${NBD_ExpiryDate}    ${NBD_HolidayName}    ${MaturityDate}    ${ExpiryDate}
    
    ### Types/Purpose Tab ###
    ### Facility Risk Type
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    
    ### Facility Loan Purpose Type
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ### Restrictions Tab ###
    ### Currency Limits
    ### Add AUD Currency
    Add Facility Currency    &{ExcelPath}[Facility_Currency1]
    
    ### Sublimit/Cust Tab ###
    Add Facility Borrower - Add All
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency1]
    Complete Facility Borrower Setup
    
    
    
Setup Revolver Facility for Comprehensive Deal
    [Documentation]    This high-level keyword is for setting up a Term Facility With API Validation.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - updated sheet from 'CRED08_OngoingFeeSetup' to 'CRED08_FacilityFeeSetup'
    ...                                   - used 'Enter Facility Dates With Business Day and Non-Business Day Validations for Revolver Facility' instead of 'Enter Date With Business Day and Non-Business Day Validations'
    ...    @update: clanding    16JUL2020    - updated sheet name from CRED08_FacilityFeeSetup to CRED08_OngoingFeeSetup
    [Arguments]    ${ExcelPath}
    ### Data Generation
    ${Facility_Name}    Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${CurrentDate}    Get System Date
    
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    &{ExcelPath}[rowid]    ${Deal_Name}
    Write Data To Excel    CRED02_FacilitySetup    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    CRED01_DealSetup    Facility2_Name    1    ${Facility_Name}
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    &{ExcelPath}[rowid]    ${Facility_Name}
    Write Data To Excel    TRP002_SecondarySale    Term_Facility_2    1    ${Facility_Name}
    Write Data To Excel    PTRF_CRE01_PortfolioTransfer    Facility_Name    1    ${Facility_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    3    ${Facility_Name}
    Write Data To Excel    AMCH06_PricingChangeTransaction    Facility_Name    1    ${Facility_Name}
    Write Data To Excel    SERV12_LoanSplit    Facility_Name    1    ${Facility_Name}
    Write Data To Excel    CAP02_InterestCapitalRule    Facility_Name    1    ${Facility_Name}
    Write Data To Excel    CAP03_InterestPayment    Loan_FacilityName    1    ${Facility_Name}
        
    Write Data To Excel    TRP002_SecondarySale    Facility_Amount_2    1    &{ExcelPath}[Facility_ProposedCmtAmt]
    
    ### Facility Dates
    ${ExpiryDate}    Get Future Date    ${CurrentDate}    &{ExcelPath}[NumberOfDays_ToAdd]
    ${MaturityDate}    Get Future Date    ${CurrentDate}    &{ExcelPath}[NumberOfDays_ToAdd]
    ${NBD_MaturityDate}    Read Data From Excel    API_HolidayCalendar    NonBusinessDay_Date    1
    ${NBD_HolidayName}    Read Data From Excel    API_HolidayCalendar    NonBusinessDay_Reason    1
    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    &{ExcelPath}[rowid]    ${CurrentDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    &{ExcelPath}[rowid]    ${CurrentDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    &{ExcelPath}[rowid]    ${ExpiryDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    &{ExcelPath}[rowid]    ${MaturityDate}
    
    ### Facility Creation
    Add New Facility    ${Deal_Name}    &{ExcelPath}[Deal_Currency]    ${Facility_Name}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ### Summary Tab ###
    ### Facility Dates
    Enter Facility Dates With Business Day and Non-Business Day Validations for Revolver Facility    ${CurrentDate}    ${NBD_MaturityDate}    ${NBD_HolidayName}    ${MaturityDate}    ${ExpiryDate}
    
    ### Types/Purpose Tab ###
    ### Facility Risk Type
    Set Facility Risk Type    &{ExcelPath}[Facility_RiskType1]
    
    ### Facility Loan Purpose Type
    Set Facility Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
    
    ### Restrictions Tab ###
    ### Currency Limits
    ### Add AUD Currency
    Add Facility Currency    &{ExcelPath}[Facility_Currency1]
    ### Add USD Currency
    Add Facility Currency    &{ExcelPath}[Facility_Currency2]
    
    ### Sublimit/Cust Tab ###
    Add Facility Borrower - Add All
    Validate Risk Type in Borrower Select    &{ExcelPath}[Facility_RiskType1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency1]
    Validate Currency Limit in Borrower Select    &{ExcelPath}[Facility_Currency2]
    Complete Facility Borrower Setup         

Setup RPA Internal Deal
    [Documentation]    Create a RPA Internal Deal with no Origination System
    ...    @author: fmamaril
    ...    @update: mcastro    12OCT2020    - added writing to TRPO12_PortfolioSettledDisc 
    ...    @update: mcastro    20OCT2020    - added writing to Loan drawdown for other facility rows
    ...    @update: dahijara    21OCT2020    - added writing for scenario 4 - CRED07_UpfrontFee_Payment
    ...    @update: mcastro    23OCT2020    - added writing to CRED07_UpfrontFee_Payment for scenario 1
    ...    @update: mcastro    27OCT2020    - added writing for RPA Scenario 2, added arguments for Add Pricing Option
    [Arguments]    ${ExcelPath}
    ###Set Dates for transactions###
    ${SystemDate}    Get System Date
    Write Data To Excel    CRED01_DealSetup    FinancialRatioStartDate    ${rowid}    ${SystemDate}
    Write Data To Excel    CRED01_DealSetup    CreatedEffectiveDate    ${rowid}    ${SystemDate}   
    Write Data To Excel    CRED01_DealSetup    UnrestrictedEffectiveDate    ${rowid}    ${SystemDate}   
    Write Data To Excel    CRED01_DealSetup    FRCEffectiveDate    ${rowid}    ${SystemDate}        
    Write Data To Excel    CRED01_DealSetup    ActualDueDate    ${rowid}    ${SystemDate}
    Write Data To Excel    CRED01_DealSetup    Deal_AgreementDate    ${rowid}    ${SystemDate}       
    Write Data To Excel    CRED01_DealSetup    Deal_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV01_LoanDrawdown    Loan_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV01_LoanDrawdown    Repayment_TriggerDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV29_PaymentFees    Fee_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV29_PaymentFees    Fee_FloatRateStartDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SERV29_PaymentFees    FeePayment_EffectiveDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SYND02_PrimaryAllocation    ApproveDate    ${rowid}    ${SystemDate}   
    Write Data To Excel    SYND02_PrimaryAllocation    CloseDate    ${rowid}    ${SystemDate}
    Write Data To Excel    SYND02_PrimaryAllocation    Primary_CircledDate    ${rowid}    ${SystemDate}
        
    ##Generate Deal Name and Alias###    
    ${Deal_Name}    ${Deal_Alias}    Generate Deal Name and Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]    ${rowid}    
    Write Data To Excel    CRED01_DealSetup    Deal_Name    ${rowid}    ${Deal_Name}    multipleValue=Y
    Write Data To Excel    SYND02_PrimaryAllocation    Deal_Name    ${rowid}    ${Deal_Name}    multipleValue=Y
    Write Data To Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}    ${Deal_Name}    multipleValue=Y        
    Write Data To Excel    CRED07_UpfrontFeeSetup    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    ${rowid}    ${Deal_Name}
    Write Data To Excel    SERV29_PaymentFees    Deal_Name    ${rowid}    ${Deal_Name}    
    Write Data To Excel    SERV29_PaymentFees    ScheduledActivity_DealName    ${rowid}    ${Deal_Name}
    Write Data To Excel    CRED01_DealSetup    Deal_Alias    ${rowid}    ${Deal_Alias}    multipleValue=Y
    Write Data To Excel    TRPO12_PortfolioSettledDisc    Deal_Name    ${rowid}    ${Deal_Name}
        
    ###For RPA Scenario 1###
    Run Keyword If    '${SCENARIO}'=='1' and '${rowid}'=='1'    Run Keywords    Write Data To Excel    TRPO12_PortfolioSettledDisc    Deal_Name    ${rowid}    ${Deal_Name}
    ...    AND    Write Data To Excel    TRPO12_PortfolioSettledDisc    AwaitingDispose    ${rowid}    ${Deal_Name}
    ...    AND    Write Data To Excel    TRPO12_PortfolioSettledDisc    Closed_Date    ${rowid}    ${SystemDate}
    Run Keyword If    '${SCENARIO}'=='1'    Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    2    ${Deal_Name}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_EffectiveDate    2    ${SystemDate}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Repayment_TriggerDate    2    ${SystemDate}
    ...    AND    Write Data To Excel    CRED07_UpfrontFee_Payment    Deal_Name    ${rowid}    ${Deal_Name}

    ###For RPA Scenario 2###
    Run Keyword If    '${SCENARIO}'=='2' and '${rowid}'=='1'    Run Keywords    Write Data To Excel    TRPO12_PortfolioSettledDisc    Deal_Name    ${rowid}    ${Deal_Name}
    ...    AND    Write Data To Excel    TRPO12_PortfolioSettledDisc    AwaitingDispose    ${rowid}    ${Deal_Name}
    ...    AND    Write Data To Excel    TRPO12_PortfolioSettledDisc    Closed_Date    ${rowid}    ${SystemDate}
    Run Keyword If    '${SCENARIO}'=='2'    Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Deal_Name    2    ${Deal_Name}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_EffectiveDate    2    ${SystemDate}
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Repayment_TriggerDate    2    ${SystemDate}
    ...    AND    Write Data To Excel    CRED07_UpfrontFee_Payment    Deal_Name    ${rowid}    ${Deal_Name}

    Run Keyword If    '${SCENARIO}'=='4'    Write Data To Excel    CRED07_UpfrontFee_Payment    Deal_Name    ${rowid}    ${Deal_Name}
          
    ###New Deal Screen###   
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    
    ###Deal Notebook - Summary Tab###   
    Add Deal Borrower    &{ExcelPath}[Borrower1_ShortName]  
    Select Deal Borrower Location and Servicing Group    &{ExcelPath}[Borrower_Location]    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_SG_Method]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower_SG_Name]
    Select Deal Borrower Remmitance Instruction    &{ExcelPath}[Borrower1_ShortName]    ${Deal_Name}    &{ExcelPath}[Borrower_Location]
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]    &{ExcelPath}[AdminAgent_ServicingGroup]
    Enter Agreement Date and Proposed Commitment Amount    ${SystemDate}    &{ExcelPath}[Deal_ProposedCmt]
    Unrestrict Deal

    ###Deal Notebook - MIS Codes Tab###
    Validate and Update Branch and Processing Area in MIS Codes Tab    &{ExcelPath}[OwningBranch]    &{ExcelPath}[ProcessingArea]
    
    ###Deal Notebook - Personnel Tab###
    Uncheck Early Discussion Deal Checkbox
    Enter Department on Personel Tab    &{ExcelPath}[Deal_DepartmentCode]    &{ExcelPath}[Deal_Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Deal Notebook - Calendars Tab###
    Delete Existing Holiday on Calendar Table
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    
    ###Deal Notebook - Pricing Rules Tab###
    ${PricingOption_CCY}    Run Keyword If    '&{ExcelPath}[Deal_PricingOption1_CCY]' == '${EMPTY}' or '&{ExcelPath}[Deal_PricingOption1_CCY]' == '${None}'    Set Variable    None
    ...    ELSE    Set Variable    &{ExcelPath}[Deal_PricingOption1_CCY]
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]
    ...    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]    None
    ...    None    None    &{ExcelPath}[PricingOption_PercentOfRateFormulaUsage]    &{ExcelPath}[PricingOption_RepricingNonBusinessDayRule]    None    &{ExcelPath}[PricingOption_InterestDueUponPrincipalPayment]    &{ExcelPath}[PricingOption_InterestDueUponRepricing]
    ...    None    &{ExcelPath}[PricingOption_IntentNoticeDaysInAdvance]    None    None    None    None    None    None    None    &{ExcelPath}[PricingOption_BillBorrower]           
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]    &{ExcelPath}[PricingRule_BillBorrowerStatus1]    &{ExcelPath}[PricingRule_BillNoOfDays1]

Create Facility for RPA Deal
    [Documentation]    This keyword is used to create a Facility for RPA Deal.
    ...    @author: fmamaril
    ...    @update: mcastro    12OCT2020    - added writing to TRPO12_PortfolioSettledDisc with condition
    ...    @update: dahijara    20OCT2020    - added data writing for Scenario 4
    ...    @update: mcastro    20OCT2020    - added condition to open Deal notebook when Deal notebook is not displayed
    ...                                     - added writing to SERV01_LoanDrawdown for RPA Scenario 1
    ...    @update: mcastro    27OCT2020    - added writing for RPA Scenario 2
    ...    @update: dahijara    28OCT2020    - Added writing for SERV01 Loan Drawdown for Scenario 4
    [Arguments]    ${ExcelPath}
    Log    ${rowid}       
    ###Data Generation###
    ${Facility_Name}    Auto Generate Name Test Data    &{ExcelPath}[Facility_NamePrefix]    
    Write Data To Excel    CRED01_DealSetup    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid

    Write Data To Excel    CRED02_FacilitySetup    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    CRED08_OngoingFeeSetup    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    SYND02_PrimaryAllocation    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    
    ###For RPA Scenario 1###
    Run Keyword If    '${SCENARIO}'=='1' and '${rowid}'=='1'    Run Keywords    Write Data To Excel    TRPO12_PortfolioSettledDisc    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    TRPO12_PortfolioSettledDisc    Portfolio_Position    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    CRED07_UpfrontFee_Payment    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid  
    Run Keyword If    '${SCENARIO}'=='1'   Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_FacilityName    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid 
    
    ###For RPA Scenario 2###
    Run Keyword If    '${SCENARIO}'=='2' and '${rowid}'=='1'    Run Keywords    Write Data To Excel    TRPO12_PortfolioSettledDisc    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    TRPO12_PortfolioSettledDisc    Portfolio_Position    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    CRED07_UpfrontFee_Payment    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid  
    Run Keyword If    '${SCENARIO}'=='2'   Run Keywords    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_FacilityName    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid 

    ###Open Deal Notebook If Not present###
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_Window}    VerificationData="Yes"
    Run Keyword If    ${Status}!=${True}    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ...    ELSE    Log    Deal Notebook Is Already Displayed

    ###New Facility Screen###
    ${Facility_ProposedCmtAmt}    New Facility Select    &{ExcelPath}[Deal_Name]    ${FacilityName}    &{ExcelPath}[Facility_Type]    &{ExcelPath}[Facility_ProposedCmtAmt]    &{ExcelPath}[Facility_Currency]
    
    ##Facility Notebook - Summary Tab###
    ${Facility_AgreementDate}    Get System Date
    ${Facility_EffectiveDate}    Get System Date
    ${Facility_ExpiryDate}    Add Time from From Date and Returns Weekday    ${Facility_EffectiveDate}    &{ExcelPath}[NumberOfDays_ToAdd]
    ${Facility_MaturityDate}    Add Time from From Date and Returns Weekday    ${Facility_EffectiveDate}    &{ExcelPath}[NumberOfDays_ToAdd]
    Enter Dates on Facility Summary    ${Facility_AgreementDate}    ${Facility_EffectiveDate}    ${Facility_ExpiryDate}    ${Facility_MaturityDate}
    Run Keyword If    '${SCENARIO}'=='1'    Run Keywords    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    SYND02_PrimaryAllocation    Primary_PortfolioExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate}    
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}

    Run Keyword If    '${SCENARIO}'=='2'    Run Keywords    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    SYND02_PrimaryAllocation    Primary_PortfolioExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate}    
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}

    Run Keyword If    '${SCENARIO}'=='4'    Run Keywords    Write Data To Excel    CRED02_FacilitySetup    Facility_AgreementDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}
    ...    AND    Write Data To Excel    SYND02_PrimaryAllocation    Primary_PortfolioExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_ExpiryDate    ${rowid}    ${Facility_ExpiryDate}
    ...    AND    Write Data To Excel    CRED02_FacilitySetup    Facility_MaturityDate    ${rowid}    ${Facility_MaturityDate}
    ...    AND    Write Data To Excel    TRPO12_PortfolioSettledDisc    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    TRPO12_PortfolioSettledDisc    Portfolio_Position    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Facility_Name    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_FacilityName    ${rowid}    ${Facility_Name}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_EffectiveDate    ${rowid}    ${Facility_EffectiveDate}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    SERV01_LoanDrawdown    Loan_MaturityDate    ${rowid}    ${Facility_MaturityDate}
   
    Verify Main SG Details    &{ExcelPath}[Facility_ServicingGroup]    &{ExcelPath}[Facility_Customer]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Types/Purpose Tab###
    Add Risk Type    &{ExcelPath}[Facility_RiskType1]    &{ExcelPath}[Facility_RiskTypeLimit]   &{ExcelPath}[Facility_Currency1]
    Add Loan Purpose Type    &{ExcelPath}[Facility_LoanPurposeType]
   
    ##Facility Notebook - Restrictions Tab###
    Add Currency Limit    &{ExcelPath}[Facility_Currency1]    &{ExcelPath}[Facility_GlobalLimit]   &{ExcelPath}[Facility_CustomerServicingGroup]    &{ExcelPath}[Facility_SGLocation]
    
    ###Facility Notebook - Sublimit/Cust Tab###
    Add Borrower    &{ExcelPath}[Facility_Currency1]    &{ExcelPath}[Facility_BorrowerSGName]    &{ExcelPath}[Facility_BorrowerPercent]    &{ExcelPath}[Facility_Borrower]
    ...    &{ExcelPath}[Facility_GlobalLimit]    &{ExcelPath}[Facility_BorrowerMaturity]    ${Facility_EffectiveDate}

RPA Deal Approval and Close
    [Documentation]    This keywords Approves and Closes the created RPA Deal.
    ...    @author: dahijara    21OCT2020    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ###Close all windows and Login as original user###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Deal Notebook Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    &{ExcelPath}[ApproveDate]
    Close the Deal    &{ExcelPath}[CloseDate]
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}