*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Setup Bilateral Deal - ComSee
    [Documentation]    This keyword is used to create a Deal with a Single Lender (Host Bank as Admin Agent).    
    ...    @author: rtaryao    12AUG2019    - Initial Create
    [Arguments]    ${ExcelPath}
    ###Get LIQ System Date###
    ${SystemDate}    Get System Date
    
    ###Generate Deal Name and Alias###    
    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    Write Data To Excel    ComSee_SC1_Deal    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}    
    
    ###Loan IQ Deasktop###                     
    Select Actions    [Actions];Deal
    
    ###New Deal Screen###
    Validate Fields on Deal Select Screen    
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_DepartmentDescription]    &{ExcelPath}[Deal_SalesGroup]
        
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
    ${TrackingNumber}    Get Deal Tracking Number
    Write Data To Excel    ComSee_SC1_Deal    Deal_TrackingNumber    ${rowid}    ${TrackingNumber}    ${ComSeeDataSet}    
    
    ###Deal Notebook - Personnel Tab###
    Uncheck Early Discussion Deal Checkbox
    ${DeptCode}    Get Deal Department Code on Personnel Tab    &{ExcelPath}[Deal_DepartmentDescription]
        
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    ${ExpenseDesc}    Get Deal Expense Description
    Write Data To Excel    ComSee_SC1_Deal    Deal_ExpenseDescription    ${rowid}    ${ExpenseDesc}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC1_Deal    Deal_DepartmentCode    ${rowid}    ${DeptCode}    ${ComSeeDataSet}   
    
    ###Deal Notebook - Calendars Tab###
    Delete Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    ###Deal Notebook - Pricing Rules Tab###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]    &{ExcelPath}[PricingRule_BillBorrowerStatus1]    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    ###Deal Notebook - Events Tab###    
    Verify Details on Events Tab    ${INPUTTER_USERNAME}    ${INPUTTER_USERNAME}
    Close All Windows on LIQ
    
    ###Logout and Log back in using ADMIN1###
    Logout from Loan IQ
    Login to Loan IQ    ${LIQ_ADMIN_USERNAME}    ${LIQ_ADMIN_PASSWORD}
    
    ###User Profile###
    Navigate to User Profile Notebook    ${INPUTTER_USERNAME}
    ${ProcAreaDesc}    ${ProcAreaCode}    Get User Processing Area Description and Code
    ${BranchDesc}    ${BranchCode}    Get User Branch Description and Code
    
    Write Data To Excel    ComSee_SC1_Deal    Deal_ProcessingAreaCode    ${rowid}    ${ProcAreaCode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_Deal    Deal_ProcessingAreaDescription    ${rowid}    ${ProcAreaDesc}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_Processing_Code    ${rowid}    ${ProcAreaCode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_Processing_Desc    ${rowid}    ${ProcAreaDesc}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_BranchCode    ${rowid}    ${BranchCode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_BranchDescription    ${rowid}    ${BranchDesc}    ${ComSeeDataSet}
    
    ###Logout from LIQ###
    Logout from Loan IQ
   

Setup a Primary Notebook - ComSee
    [Documentation]    This keyword is used to create a Deal with a Single Lender (Host Bank as Admin Agent).    
    ...    @author: rtarayao    12AUG2019    - Initial Create
    [Arguments]    ${ExcelPath}
    ###Circle Notebook - Facilites Tab### 
    ${SystemDate}    Get System Date
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Add Pricing Comment    &{ExcelPath}[Primary_Comment]
    
    ###Circle Notebook - Contacts Tab### 
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Delete Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    &{ExcelPath}[ServicingGroupMember]    &{ExcelPath}[AdminAgent_SGAlias]
    Validate Delete Error on Servicing Group    &{ExcelPath}[FundReceiverDetailCustomer]
    
    ##Circle Notebook - Workflow Tab###
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Primary_RiskBook]  
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_PortfolioDescription    ${rowid}    &{ExcelPath}[Primary_Portfolio]    ${ComSeeDataSet} 
         
    Circling for Primary Workflow    ${SystemDate}
    Close Primaries Windows
    
    ###Deal Notebook - Workflow Tab###
    Send Deal to Approval    
    Close All Windows on LIQ
    Logout from Loan IQ
    
    ###Log Back in to LIQ###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ##Approve LIQ###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    ${SystemDate}
    Close All Windows on LIQ
    Logout from Loan IQ
    
    ###Close Deal LIQ###
    Login to Loan IQ   ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Close the Deal    ${SystemDate}
    ${ClosedDate}    Convert LIQ Date to Year-Month-Day Format    ${SystemDate}        
    Write Data To Excel    ComSee_SC1_Deal    Deal_ClosedDate    ${rowid}    ${ClosedDate}    ${ComSeeDataSet}     
    Close All Windows on LIQ
    Logout from Loan IQ
    

Write Post Deal Details for ComSee
    [Documentation]    This keyword is used to write all the Post Deal Details needed for Commsee fields.    
    ...    @author: rtaryao    12AUG2019    - Initial Create
    [Arguments]    ${ExcelPath}
    ###LIQ Desktop
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook - Global and Host Bank's Current and Closing Cmt Amt Validation###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${GlobalClosingCmt}    ${GlobalCurrentCmt}    Get Deal Global Current and Closing Cmt Amounts 
    ${HBClosingCmt}    ${HBNetCmt}    Get Deal Host Bank Net and Closing Cmt Amounts
    ${GlobalClosingCmt}    Remove Comma and Convert to Number    ${GlobalClosingCmt} 
    ${GlobalCurrentCmt}    Remove Comma and Convert to Number    ${GlobalCurrentCmt}
    ${HBClosingCmt}    Remove Comma and Convert to Number    ${HBClosingCmt}
    ${HBNetCmt}    Remove Comma and Convert to Number    ${HBNetCmt}
    
    Write Data To Excel    ComSee_SC1_Deal    Deal_GlobalDealClosingCommitment    ${rowid}    ${GlobalClosingCmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_Deal    Deal_GlobalDealCurrentCommitment    ${rowid}    ${GlobalCurrentCmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_Deal    Deal_HostBankClosingCommitment    ${rowid}    ${HBClosingCmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_Deal    Deal_HostBankNetCommitment    ${rowid}    ${HBNetCmt}    ${ComSeeDataSet}
    
    ###Get Facility Amount
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    ${FacHBNetCmtAmt}    ${FacHBFundableCmtAmt}    Get Facility Host Bank Net and Fundable Cmt Amount
    ${FacHBOutstandingNetAmt}    ${FacHBNetAvailToDrawAmt}    Get Facility Host Bank Outstanding Net and Avail to Draw Amount
    ${FacGlobalCurrentCmtAmt}    ${FacGlobalClosingCmtAmt}    Get Facility Global Closing and Current Cmt Amount
    ${FacGlobalOutstandingAmt}    ${FacGlobalAvailtoDrawAmt}    Get Facility Global Outstanding and Available to Draw Amount
    ${FacHBNetCmtAmt}    Remove Comma and Convert to Number    ${FacHBNetCmtAmt}
    ${FacHBFundableCmtAmt}    Remove Comma and Convert to Number    ${FacHBFundableCmtAmt}
    ${FacHBOutstandingNetAmt}    Remove Comma and Convert to Number    ${FacHBOutstandingNetAmt}
    ${FacHBNetAvailToDrawAmt}    Remove Comma and Convert to Number    ${FacHBNetAvailToDrawAmt}
    ${FacGlobalCurrentCmtAmt}    Remove Comma and Convert to Number    ${FacGlobalCurrentCmtAmt}
    ${FacGlobalClosingCmtAmt}    Remove Comma and Convert to Number    ${FacGlobalClosingCmtAmt}
    ${FacGlobalOutstandingAmt}    Remove Comma and Convert to Number    ${FacGlobalOutstandingAmt}
    ${FacGlobalAvailtoDrawAmt}    Remove Comma and Convert to Number    ${FacGlobalAvailtoDrawAmt}
    
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_HostBankNetCommitment    ${rowid}    ${FacHBNetCmtAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_HostBankFundableCommitment    ${rowid}    ${FacHBFundableCmtAmt}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_HostBankNetOutstandings    ${rowid}    ${FacHBOutstandingNetAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_HostBankNetAvailableToDraw    ${rowid}    ${FacHBNetAvailToDrawAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_GlobalCurrentCommitment    ${rowid}    ${FacGlobalCurrentCmtAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_GlobalClosingCommitment    ${rowid}    ${FacGlobalClosingCmtAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_GlobalOutstandings    ${rowid}    ${FacGlobalOutstandingAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_GlobalAvailableToDraw    ${rowid}    ${FacGlobalAvailtoDrawAmt}    ${ComSeeDataSet}
  
    ###Expense Code Writing
    ${ExpenseCodeDesc}    Get Expense Description from Table Maintenance    &{ExcelPath}[Primary_RiskBook]   
    ${FacExpenseCode}    Get Facility Expense Code and Description Combined    &{ExcelPath}[Primary_RiskBook]    ${ExpenseCodeDesc}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_ExpenseCode    ${rowid}    ${FacExpenseCode}    ${ComSeeDataSet}        
    
    ##Portfolio Code Writing
    ${PortfolioCode}    Get Portfolio Code from Table Maintenance    &{ExcelPath}[Primary_Portfolio]
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_PortfolioCode    ${rowid}    ${PortfolioCode}    ${ComSeeDataSet}
    
    ###Funding Desk Code Writing
    ${FundingDeskCode}    Get Funding Desk Code from Table Maintenance    &{ExcelPath}[Primary_PortfolioBranch]
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_FundingDeskCode    ${rowid}    ${FundingDeskCode}    ${ComSeeDataSet}  
    
    ###Lender, Facility, Borrower, and Facility Outstanding Count Writing
    ${LenderCount}    Get Lender Count    &{ExcelPath}[Primary_Lender1]    ,
    ${FacilityCount}    Get Facility Count    &{ExcelPath}[Facility_Name]    ${EMPTY}
    ${BorrowerCount}    Get Borrower Count    &{ExcelPath}[Borrower1_ShortName]    ${EMPTY}
    ${OutstandingCount}    Get Facility Outstanding Count    ${EMPTY}    ${EMPTY}
    
    Write Data To Excel    ComSee_SC1_Deal    Deal_NoOfLenders    ${rowid}    ${LenderCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_NoOfLenders    ${rowid}    ${LenderCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_Deal    Deal_NoOfFacitlities    ${rowid}    ${FacilityCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_Deal    Deal_NoOfBorrowers    ${rowid}    ${BorrowerCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_NoOfBorrowers    ${rowid}    ${BorrowerCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC1_FacSetup    Facility_NoOfOutstanding    ${rowid}    ${OutstandingCount}    ${ComSeeDataSet}
    
    Close All Windows on LIQ
    
Create Deal Setup for SBLC - ComSee
    [Documentation]    This high level keyword creates SBLC Baseline Deal for ComSee. 
    ...    @author: jdelacru    20AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Date Setup###    
    ${SystemDate}    Get System Date
    
    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    Write Data To Excel    ComSee_SC3_Deal    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_FacSetup    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_Issuance    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    
    ${Deal_Name}    Read Data From Excel    ComSee_SC3_Deal    Deal_Name    ${rowid}    ${ComSeeDataSet}        
    ###Loan IQ Deasktop###
    Select Actions    [Actions];Deal
    
    ###New Deal Screen###
    Validate Fields on Deal Select Screen    
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_Department]    &{ExcelPath}[Deal_SalesGroup]
    
    ###Deal Notebook - Summary Tab###   
    Add Deal Borrower    &{ExcelPath}[Deal_Borrower]   
    Select Deal Borrower Location and Servicing Group    &{ExcelPath}[Borrower_Location]    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_SG_Method]    &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[Borrower_SG_Name]
    Select Deal Borrower Remmitance Instruction    &{ExcelPath}[Deal_Borrower]    ${Deal_Name}    &{ExcelPath}[Borrower_Location]
	Set Deal as Sole Lender
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Select Servicing group and Remittance Instrucion for Admin Agent    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]    &{ExcelPath}[AdminAgent_ServicingGroup]
    Enter Agreement Date and Proposed Commitment Amount    ${SystemDate}    &{ExcelPath}[Deal_ProposedCmt]
    Unrestrict Deal
    
    ###Deal Notebook - Personnel Tab###
    Uncheck Early Discussion Deal Checkbox
    # Enter Department on Personel Tab    &{ExcelPath}[DepartmentCode]    &{ExcelPath}[Department]
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    
    ###Deal Notebook - Calendars Tab###
    Delete Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    ###Deal Notebook - Pricing Rules Tab###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption2]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]     
    Add Pricing Option for SBLC    &{ExcelPath}[PricingRule_LOC]    &{ExcelPath}[InitialFractionRate_Round_LOC]    &{ExcelPath}[RoundingDecimal_Round_LOC]    &{ExcelPath}[NonBusinessDayRule_LOC]    &{ExcelPath}[BillingNumberOfDays_LOC]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]    &{ExcelPath}[PricingRule_BillBorrowerStatus1]    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    
    ### Deal Notebook - Bank Roles Tab ###
    Add Bank Role    SBLC/Guarantee Issuer    &{ExcelPath}[Bank_Name]    &{ExcelPath}[BankRole_SG_Alias]    &{ExcelPath}[BankRole_SG]    &{ExcelPath}[BankRole_SG_GroupMembers]
    ...    &{ExcelPath}[BankRole_SG_Method]    &{ExcelPath}[BankRole_Portfolio]    &{ExcelPath}[BankRole_ExpenseCode]    &{ExcelPath}[BankRole_ExpenseCodeDesc]
    
Setup a Primary Notebook with SBLC - ComSee
    [Documentation]    This keyword adds the lender to the Deal.
    ...    @author: rtarayao    22AUG2019    Initial Create
    [Arguments]    ${ExcelPath}
    ###Circle Notebook - Facilites Tab### 
    ${SystemDate}    Get System Date
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Add Pricing Comment    &{ExcelPath}[Primary_Comment]
    
    ###Circle Notebook - Contacts Tab### 
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Delete Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    &{ExcelPath}[Primary_Contact1]    &{ExcelPath}[AdminAgent_SGAlias]
    Validate Delete Error on Servicing Group    &{ExcelPath}[FundReceiverDetailCustomer]
    
    ###Circle Notebook - Workflow Tab###    
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]    &{ExcelPath}[Primary_PortfolioExpiryDate]
    Circling for Primary Workflow    ${SystemDate}
    Close Primaries Windows
    
    ###Deal Notebook - Workflow Tab###
    Send Deal to Approval
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    ${SystemDate}
    Mx LoanIQ Close    ${LIQ_DealNotebook_Window}
    Logout from Loan IQ
    Login to Loan IQ   ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Close the Deal    ${SystemDate}
    Close All Windows on LIQ
    
    ###Get Borrower's External ID for ComSee
    Navigate to Customer Notebook    &{ExcelPath}[Deal_Borrower]
    ${CustomerExternalId}    Get Customer ID
    Write Data To Excel    ComSee_SC3_Issuance    Customer_ExternalID    ${rowid}    ${CustomerExternalId}    ${ComSeeDataSet}   
    Write Data To Excel    ComSee_SC3_IssuanceFeePayment    Customer_ExternalID    ${rowid}    ${CustomerExternalId}    ${ComSeeDataSet} 
    
    Close All Windows on LIQ
    Logout from Loan IQ
    
Setup Bilateral Deal - Scenario 7 ComSee
    [Documentation]    This keyword is used to create a Deal with a Single Lender (Host Bank as Admin Agent).    
    ...    @author: rtaryao    12AUG2019    - Initial Create
    [Arguments]    ${ExcelPath}
    ###Get LIQ System Date###
    ${SystemDate}    Get System Date
    
    ###Generate Deal Name and Alias###    
    ${Deal_Name}    ${Deal_Alias}    Generate And Return Deal Name And Alias    &{ExcelPath}[Deal_NamePrefix]    &{ExcelPath}[Deal_AliasPrefix]
    Write Data To Excel    ComSee_SC7_Deal    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_Loan    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}  
    Write Data To Excel    ComSee_SC7_LoanInterestPayment    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_PrincipalLoanPayment    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    ScheduledActivity_DealName    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    
    ###Loan IQ Deasktop###                     
    Select Actions    [Actions];Deal
    
    ###New Deal Screen###
    Validate Fields on Deal Select Screen    
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_DepartmentDescription]    &{ExcelPath}[Deal_SalesGroup]
        
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
    ${TrackingNumber}    Get Deal Tracking Number
    Write Data To Excel    ComSee_SC7_Deal    Deal_TrackingNumber    ${rowid}    ${TrackingNumber}    ${ComSeeDataSet}    
    
    ###Deal Notebook - Personnel Tab###
    Uncheck Early Discussion Deal Checkbox
    ${DeptCode}    Get Deal Department Code on Personnel Tab    &{ExcelPath}[Deal_DepartmentDescription]
        
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    ${ExpenseDesc}    Get Deal Expense Description
    Write Data To Excel    ComSee_SC7_Deal    Deal_ExpenseDescription    ${rowid}    ${ExpenseDesc}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_Deal    Deal_DepartmentCode    ${rowid}    ${DeptCode}    ${ComSeeDataSet}   
    
    ###Deal Notebook - Calendars Tab###
    Delete Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    Add Holiday on Calendar    &{ExcelPath}[HolidayCalendar]
    
    ###Deal Notebook - Pricing Rules Tab###
    Add Pricing Option    &{ExcelPath}[Deal_PricingOption1]    &{ExcelPath}[InitialFractionRate_Round]    &{ExcelPath}[RoundingDecimal_Round]    &{ExcelPath}[NonBusinessDayRule]    &{ExcelPath}[PricingOption_BillNoOfDays]    &{ExcelPath}[PricingOption_MatrixChangeAppMthd]    &{ExcelPath}[PricingOption_RateChangeAppMthd]
    Add Fee Pricing Rules    &{ExcelPath}[PricingRule_Fee1]    &{ExcelPath}[PricingRule_MatrixChangeAppMthd1]    &{ExcelPath}[PricingRule_NonBussDayRule1]    &{ExcelPath}[PricingRule_BillBorrowerStatus1]    &{ExcelPath}[PricingRule_BillNoOfDays1]
    
    ###Deal Notebook - Events Tab###    
    Verify Details on Events Tab    ${INPUTTER_USERNAME}    ${INPUTTER_USERNAME}
    Close All Windows on LIQ
    
    ###Logout and Log back in using ADMIN1###
    Logout from Loan IQ
    Login to Loan IQ    ${LIQ_ADMIN_USERNAME}    ${LIQ_ADMIN_PASSWORD}
    
    ###User Profile###
    Navigate to User Profile Notebook    ${INPUTTER_USERNAME}
    ${ProcAreaDesc}    ${ProcAreaCode}    Get User Processing Area Description and Code
    ${BranchDesc}    ${BranchCode}    Get User Branch Description and Code
    
    Write Data To Excel    ComSee_SC7_Deal    Deal_ProcessingAreaCode    ${rowid}    ${ProcAreaCode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Deal    Deal_ProcessingAreaDescription    ${rowid}    ${ProcAreaDesc}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_Processing_Code    ${rowid}    ${ProcAreaCode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_Processing_Desc    ${rowid}    ${ProcAreaDesc}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_BranchCode    ${rowid}    ${BranchCode}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_BranchDescription    ${rowid}    ${BranchDesc}    ${ComSeeDataSet}
    
    ###Logout from LIQ###
    Logout from Loan IQ
    
Setup a Primary Notebook for Bilateral Deal - Scenario 7 ComSee
    [Documentation]    This keyword is used to create a Deal with a Single Lender (Host Bank as Admin Agent).    
    ...    @author: rtarayao    12AUG2019    - Initial Create
    [Arguments]    ${ExcelPath}
    ###Circle Notebook - Facilites Tab### 
    ${SystemDate}    Get System Date
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primaries_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Add Pricing Comment    &{ExcelPath}[Primary_Comment]
    
    ###Circle Notebook - Contacts Tab### 
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Delete Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    &{ExcelPath}[ServicingGroupMember]    &{ExcelPath}[AdminAgent_SGAlias]
    Validate Delete Error on Servicing Group    &{ExcelPath}[FundReceiverDetailCustomer]
    
    ##Circle Notebook - Workflow Tab###
    Complete Portfolio Allocations Workflow    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    &{ExcelPath}[Primary_PortfolioAllocation]    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Primary_RiskBook]  
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_PortfolioDescription    ${rowid}    &{ExcelPath}[Primary_Portfolio]    ${ComSeeDataSet} 
         
    Circling for Primary Workflow    ${SystemDate}
    Close Primaries Windows
    
    ###Deal Notebook - Workflow Tab###
    Send Deal to Approval    
    Close All Windows on LIQ
    Logout from Loan IQ
    
    ###Log Back in to LIQ###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ##Approve LIQ###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Approve the Deal    ${SystemDate}
    Close All Windows on LIQ
    Logout from Loan IQ
    
    ###Close Deal LIQ###
    Login to Loan IQ   ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Close the Deal    ${SystemDate}
    ${ClosedDate}    Convert LIQ Date to Year-Month-Day Format    ${SystemDate}        
    Write Data To Excel    ComSee_SC7_Deal    Deal_ClosedDate    ${rowid}    ${ClosedDate}    ${ComSeeDataSet} 
    Close All Windows on LIQ
    
    ###Get Borrower's External ID for ComSee
    Navigate to Customer Notebook    &{ExcelPath}[Borrower1_ShortName]
    ${CustomerExternalId}    Get Customer ID
    Write Data To Excel    ComSee_SC7_FacFeeSetup    Customer_ExternalID    ${rowid}    ${CustomerExternalId}    ${ComSeeDataSet}
        
    Close All Windows on LIQ
    Logout from Loan IQ
    

Write Post Deal Details for Scenario 7 ComSee
    [Documentation]    This keyword is used to write all the Post Deal Details needed for Commsee fields.    
    ...    @author: rtaryao    12AUG2019    - Initial Create
    [Arguments]    ${ExcelPath}
    ###LIQ Desktop
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook - Global and Host Bank's Current and Closing Cmt Amt Validation###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${GlobalClosingCmt}    ${GlobalCurrentCmt}    Get Deal Global Current and Closing Cmt Amounts 
    ${HBClosingCmt}    ${HBNetCmt}    Get Deal Host Bank Net and Closing Cmt Amounts
    ${GlobalClosingCmt}    Remove Comma and Convert to Number    ${GlobalClosingCmt} 
    ${GlobalCurrentCmt}    Remove Comma and Convert to Number    ${GlobalCurrentCmt}
    ${HBClosingCmt}    Remove Comma and Convert to Number    ${HBClosingCmt}
    ${HBNetCmt}    Remove Comma and Convert to Number    ${HBNetCmt}
    
    Write Data To Excel    ComSee_SC7_Deal    Deal_GlobalDealClosingCommitment    ${rowid}    ${GlobalClosingCmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Deal    Deal_GlobalDealCurrentCommitment    ${rowid}    ${GlobalCurrentCmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Deal    Deal_HostBankClosingCommitment    ${rowid}    ${HBClosingCmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Deal    Deal_HostBankNetCommitment    ${rowid}    ${HBNetCmt}    ${ComSeeDataSet}
    
    ###Get Facility Amount
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    ${FacHBNetCmtAmt}    ${FacHBFundableCmtAmt}    Get Facility Host Bank Net and Fundable Cmt Amount
    ${FacHBOutstandingNetAmt}    ${FacHBNetAvailToDrawAmt}    Get Facility Host Bank Outstanding Net and Avail to Draw Amount
    ${FacGlobalCurrentCmtAmt}    ${FacGlobalClosingCmtAmt}    Get Facility Global Closing and Current Cmt Amount
    ${FacGlobalOutstandingAmt}    ${FacGlobalAvailtoDrawAmt}    Get Facility Global Outstanding and Available to Draw Amount
    ${FacHBNetCmtAmt}    Remove Comma and Convert to Number    ${FacHBNetCmtAmt}
    ${FacHBFundableCmtAmt}    Remove Comma and Convert to Number    ${FacHBFundableCmtAmt}
    ${FacHBOutstandingNetAmt}    Remove Comma and Convert to Number    ${FacHBOutstandingNetAmt}
    ${FacHBNetAvailToDrawAmt}    Remove Comma and Convert to Number    ${FacHBNetAvailToDrawAmt}
    ${FacGlobalCurrentCmtAmt}    Remove Comma and Convert to Number    ${FacGlobalCurrentCmtAmt}
    ${FacGlobalClosingCmtAmt}    Remove Comma and Convert to Number    ${FacGlobalClosingCmtAmt}
    ${FacGlobalOutstandingAmt}    Remove Comma and Convert to Number    ${FacGlobalOutstandingAmt}
    ${FacGlobalAvailtoDrawAmt}    Remove Comma and Convert to Number    ${FacGlobalAvailtoDrawAmt}
    
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_HostBankNetCommitment    ${rowid}    ${FacHBNetCmtAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_HostBankFundableCommitment    ${rowid}    ${FacHBFundableCmtAmt}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_HostBankNetOutstandings    ${rowid}    ${FacHBOutstandingNetAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_HostBankNetAvailableToDraw    ${rowid}    ${FacHBNetAvailToDrawAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_GlobalCurrentCommitment    ${rowid}    ${FacGlobalCurrentCmtAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_GlobalClosingCommitment    ${rowid}    ${FacGlobalClosingCmtAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_GlobalOutstandings    ${rowid}    ${FacGlobalOutstandingAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_GlobalAvailableToDraw    ${rowid}    ${FacGlobalAvailtoDrawAmt}    ${ComSeeDataSet}
  
    ###Expense Code Writing
    ${ExpenseCodeDesc}    Get Expense Description from Table Maintenance    &{ExcelPath}[Primary_RiskBook]   
    ${FacExpenseCode}    Get Facility Expense Code and Description Combined    &{ExcelPath}[Primary_RiskBook]    ${ExpenseCodeDesc}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_ExpenseCode    ${rowid}    ${FacExpenseCode}    ${ComSeeDataSet}        
    
    ##Portfolio Code Writing
    ${PortfolioCode}    Get Portfolio Code from Table Maintenance    &{ExcelPath}[Primary_Portfolio]
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_PortfolioCode    ${rowid}    ${PortfolioCode}    ${ComSeeDataSet}
    
    ###Funding Desk Code Writing
    ${FundingDeskCode}    Get Funding Desk Code from Table Maintenance    &{ExcelPath}[Primary_PortfolioBranch]
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_FundingDeskCode    ${rowid}    ${FundingDeskCode}    ${ComSeeDataSet}  
    
    ###Lender, Facility, Borrower, and Facility Outstanding Count Writing
    ${LenderCount}    Get Lender Count    &{ExcelPath}[Primary_Lender1]    ,
    ${FacilityCount}    Get Facility Count    &{ExcelPath}[Facility_Name]    ${EMPTY}
    ${BorrowerCount}    Get Borrower Count    &{ExcelPath}[Borrower1_ShortName]    ${EMPTY}
    ${OutstandingCount}    Get Facility Outstanding Count    ${EMPTY}    ${EMPTY}
    
    Write Data To Excel    ComSee_SC7_Deal    Deal_NoOfLenders    ${rowid}    ${LenderCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_NoOfLenders    ${rowid}    ${LenderCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Deal    Deal_NoOfFacitlities    ${rowid}    ${FacilityCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_Deal    Deal_NoOfBorrowers    ${rowid}    ${BorrowerCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_NoOfBorrowers    ${rowid}    ${BorrowerCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC7_FacSetup    Facility_NoOfOutstanding    ${rowid}    ${OutstandingCount}    ${ComSeeDataSet}
    
    Close All Windows on LIQ
    Logout from Loan IQ
    
Setup Primaries for Syndicated Deal - ComSee
    [Documentation]    This keyword adds Lenders in a Syndicated Deal. Specifically, 1 Host Bank and 2 Non-Host Banks.
    ...    @author: rtarayao    23AUG2019    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Primary Lender - Host Bank###
    Add Lender and Location    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender1]    &{ExcelPath}[Primary_LenderLoc1]    &{ExcelPath}[Primary_RiskBook]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal1]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact1]
    Select Servicing Group on Primaries    None    &{ExcelPath}[AdminAgent_SGAlias]
    ${SellAmount}    Get Circle Notebook Sell Amount
    Write Data To Excel    ComSee_SC2_Deal    Primary_PortfolioAllocation    ${rowid}    ${SellAmount}    ${ComSeeDataSet}
    Close Primary Notebook Window
    
    ###Secondary Lender - Non Host Bank###
    Add Non-Host Bank Lenders for a Syndicated Deal    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender2]    &{ExcelPath}[Primary_LenderLoc2]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal2]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact2]
    Select Servicing Group on Primaries    None    &{ExcelPath}[AdminAgent_SGAlias_Secondary]
    Close Primary Notebook Window
    
    ###Secondary Lender - Non Host Bank###
    Add Non-Host Bank Lenders for a Syndicated Deal    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Primary_Lender3]    &{ExcelPath}[Primary_LenderLoc3]    &{ExcelPath}[Primary_TransactionType]
    Set Sell Amount and Percent of Deal    &{ExcelPath}[Primary_PctOfDeal3]
    Add Pro Rate    &{ExcelPath}[Primary_BuySellPrice]
    Verify Buy/Sell Price in Circle Notebook
    Add Contact in Primary    &{ExcelPath}[Primary_Contact3]
    Select Servicing Group on Primaries    None    &{ExcelPath}[AdminAgent_SGAlias_Third]
    Close Primary Notebook Window
    
    
    ##Circle Notebook Complete Portfolio Allocation, Circling, and Sending to Settlement Approval###
    ${Primary_PortfolioAllocation}    Read Data From Excel    ComSee_SC2_Deal    Primary_PortfolioAllocation    ${rowid}    ${ComSeeDataSet}    
    ${CircleDate}    Get System Date
    ${HostBank_ShareAmount}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender1]    ${CircleDate}
    ...    Yes    &{ExcelPath}[Primary_Portfolio]    &{ExcelPath}[Primary_PortfolioBranch]    ${Primary_PortfolioAllocation}    &{ExcelPath}[Primary_PortfolioExpiryDate]    &{ExcelPath}[Deal_ExpenseCode]
    ${Lender_ShareAmount1}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender2]    ${CircleDate}
    ${Lender_ShareAmount2}    Circle Notebook Workflow Navigation    &{ExcelPath}[Primary_Lender3]    ${CircleDate}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_PortfolioDescription    ${rowid}    &{ExcelPath}[Primary_Portfolio]    ${ComSeeDataSet}
    
    
    ###Approval using a different user###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Actions    [Actions];Work In Process
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender1]    Host Bank
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender2]    Non-Host Bank
    Circle Notebook Settlement Approval    &{ExcelPath}[Primary_Lender3]    Non-Host Bank

Setup Syndicated Deal - ComSee
    [Documentation]    This keyword is used to create a Syndicated Deal where the Admin Agent is CBA.
    ...    This syndicated deal is used for ComSee test validations.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    ...    @update: jloretiz    07NOV2019    - Add 'Add Banks' keywords for the approval of loan outstandings
    [Arguments]    ${ExcelPath}

    ###Data Generation###
    ${Deal_Name}    Auto Generate Name Test Data    &{ExcelPath}[Deal_NamePrefix]
    ${Deal_Alias}    Auto Generate Name Test Data    &{ExcelPath}[Deal_AliasPrefix]  
    Write Data To Excel    ComSee_SC2_Deal    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    Deal_Alias    ${rowid}    ${Deal_Alias}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_AdminFee    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Issuance    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_LoanRepricing    Deal_Name    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    
    ${Deal_Name}    Read Data From Excel    ComSee_SC2_Deal    Deal_Name    ${rowid}    ${ComSeeDataSet}   
    ${Deal_Alias}    Read Data From Excel    ComSee_SC2_Deal    Deal_Alias    ${rowid}    ${ComSeeDataSet}
    
    Write Data To Excel    ComSee_SC2_Issuance    Fee_Name    ${rowid}    ${EMPTY}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Issuance    Outstanding_Alias    ${rowid}    ${EMPTY}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_LoanRepricing    Outstanding_Alias    ${rowid}    ${Deal_Name}    ${ComSeeDataSet}
    
    ###Deal Select Window###
    Select Actions    [Actions];Deal
    Validate Fields on Deal Select Screen
    Create New Deal    ${Deal_Name}    ${Deal_Alias}    &{ExcelPath}[Deal_Currency]    &{ExcelPath}[Deal_DepartmentDescription]    &{ExcelPath}[Deal_SalesGroup]
    
    ###Summary Tab###
    Unrestrict Deal
    
    ###Deal Notebook - MIS Codes Tab###
    ${TrackingNumber}    Get Deal Tracking Number
    Write Data To Excel    ComSee_SC2_Deal    Deal_TrackingNumber    ${rowid}    ${TrackingNumber}    ${ComSeeDataSet}  
        
    ###Deal Borrower Setup###
    Add Deal Borrower    &{ExcelPath}[Borrower_ShortName]
    Set Deal Borrower Servicing Group    &{ExcelPath}[Borrower_SGAlias]    &{ExcelPath}[Borrower_SG_Name]    &{ExcelPath}[Borrower_SG_GroupMembers]    &{ExcelPath}[Borrower_PreferredRIMthd1]
    Go To Deal Borrower Preferred RI Window
    Add Preferred Remittance Instruction    ${Deal_Name}    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_PreferredRIMthd1]
    Complete Deal Borrower Setup
    
    Select Deal Classification    &{ExcelPath}[Deal_ClassificationCode]    &{ExcelPath}[Deal_ClassificationDesc]
    
    ###Deal Admin Agent Setup###
    Select Admin Agent    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_Location]
    Set Deal Admin Agent Servicing Group    &{ExcelPath}[AdminAgent_SGAlias]    &{ExcelPath}[AdminAgent_ServicingGroup]    &{ExcelPath}[AdminAgent_ContactName]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Go To Admin Agent Preferred RI Window
    Add Preferred Remittance Instruction    ${Deal_Name}    &{ExcelPath}[Deal_AdminAgent]    &{ExcelPath}[AdminAgent_PreferredRIMthd1]
    Complete Deal Admin Agent Setup
    ${Deal_AgreementDate}    Get System Date
    Write Data To Excel    ComSee_SC2_Deal    Deal_AgreementDate    ${rowid}    ${Deal_AgreementDate}    ${ComSeeDataSet}   
    
    Enter Agreement Date and Proposed Commitment Amount    ${Deal_AgreementDate}    &{ExcelPath}[Deal_ProposedCmt]
    
    ###Personnel Tab###
    Uncheck Early Discussion Deal Checkbox
    ${DeptCode}    Get Deal Department Code on Personnel Tab    &{ExcelPath}[Deal_DepartmentDescription]
        
    Enter Expense Code    &{ExcelPath}[Deal_ExpenseCode]
    ${ExpenseDesc}    Get Deal Expense Description
    Write Data To Excel    ComSee_SC2_Deal    Deal_ExpenseDescription    ${rowid}    ${ExpenseDesc}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC2_Deal    Deal_DepartmentCode    ${rowid}    ${DeptCode}    ${ComSeeDataSet}  
    
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
    
    ### Deal Notebook - Bank Roles Tab ###
    Add Bank Role    SBLC/Guarantee Issuer    &{ExcelPath}[Bank_Name]    &{ExcelPath}[BankRole_SG_Alias]    &{ExcelPath}[BankRole_SG]    &{ExcelPath}[BankRole_SG_GroupMembers]
    ...    &{ExcelPath}[BankRole_SG_Method]    &{ExcelPath}[BankRole_Portfolio]    &{ExcelPath}[BankRole_ExpenseCode]    &{ExcelPath}[BankRole_ExpenseCodeDesc]
    
    
    ###Get necessary data from created Deal to be used in succeeding transactions###
    ${Date}    Get Data From LoanIQ    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    Summary    ${LIQ_DealSummaryAgreementDate_Textfield}
    ${AdminFee_DueDate}    Add Days to Date    ${Date}    30
    Write Data To Excel    ComSee_SC2_AdminFee    AdminFee_ActualDueDate    ${rowid}    ${AdminFee_DueDate}    ${ComSeeDataSet}
 

Approve and Close Syndicated Deal - ComSee
    [Documentation]    This keywords Approves and Closes the created Syndicated Deal.
    ...    @author: rtarayao    23AUG2019    - initial create
    [Arguments]    ${ExcelPath}
    
    ###Close all windows and Login as original user###
    ${SystemDate}    Get System Date
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}  
    Navigate Notebook Workflow    ${LIQ_DealNotebook_Window}    ${LIQ_DealNotebook_Tab}    ${LIQ_DealNotebook_Workflow_JavaTree}    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    Approve the Deal    ${SystemDate}
    Close the Deal    ${SystemDate}
    ${ClosedDate}    Convert LIQ Date to Year-Month-Day Format    ${SystemDate}        
    Write Data To Excel    ComSee_SC2_Deal    Deal_ClosedDate    ${rowid}    ${ClosedDate}    ${ComSeeDataSet} 
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary

    ###Validate Deal, Facility and Circle Notebooks status after Deal Close.
    Verify Circle Notebook Status After Deal Close    &{ExcelPath}[Primary_Lender1]
    Verify Facility Status After Deal Close    &{ExcelPath}[Facility_Name]
    Verify Deal Status After Deal Close
    Validate Deal Closing Cmt With Facility Total Global Current Cmt
    ${Deal_ClosingCmt}    Get Deal Closing Cmt
    
    Close All Windows on LIQ
    
    ###Get Borrower's External ID for ComSee
    Navigate to Customer Notebook    &{ExcelPath}[Borrower_ShortName]
    ${CustomerExternalId}    Get Customer ID
    Write Data To Excel    ComSee_SC2_Deal    Customer_ExternalID    ${rowid}    ${CustomerExternalId}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Loan    Customer_ExternalID    ${rowid}    ${CustomerExternalId}    ${ComSeeDataSet}
    Close All Windows on LIQ
    
Write Post Deal Details for Scenario 2 ComSee
    [Documentation]    This keyword is used to write all the Post Deal Details needed for Commsee fields for a Syndicated Deal.    
    ...    @author: rtaryao    12AUG2019    - Initial Create
    [Arguments]    ${ExcelPath}
    ###LIQ Desktop
    # Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook - Global and Host Bank's Current and Closing Cmt Amt Validation###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    ${GlobalClosingCmt}    ${GlobalCurrentCmt}    Get Deal Global Current and Closing Cmt Amounts 
    ${HBClosingCmt}    ${HBNetCmt}    Get Deal Host Bank Net and Closing Cmt Amounts
    ${GlobalClosingCmt}    Remove Comma and Convert to Number    ${GlobalClosingCmt} 
    ${GlobalCurrentCmt}    Remove Comma and Convert to Number    ${GlobalCurrentCmt}
    ${HBClosingCmt}    Remove Comma and Convert to Number    ${HBClosingCmt}
    ${HBNetCmt}    Remove Comma and Convert to Number    ${HBNetCmt}
    
    Write Data To Excel    ComSee_SC2_Deal    Deal_GlobalDealClosingCommitment    ${rowid}    ${GlobalClosingCmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    Deal_GlobalDealCurrentCommitment    ${rowid}    ${GlobalCurrentCmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    Deal_HostBankClosingCommitment    ${rowid}    ${HBClosingCmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    Deal_HostBankNetCommitment    ${rowid}    ${HBNetCmt}    ${ComSeeDataSet}
    
    ###Get Facility Amount
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    ${FacHBNetCmtAmt}    ${FacHBFundableCmtAmt}    Get Facility Host Bank Net and Fundable Cmt Amount
    ${FacHBOutstandingNetAmt}    ${FacHBNetAvailToDrawAmt}    Get Facility Host Bank Outstanding Net and Avail to Draw Amount
    ${FacGlobalCurrentCmtAmt}    ${FacGlobalClosingCmtAmt}    Get Facility Global Closing and Current Cmt Amount
    ${FacGlobalOutstandingAmt}    ${FacGlobalAvailtoDrawAmt}    Get Facility Global Outstanding and Available to Draw Amount
    ${FacHBNetCmtAmt}    Remove Comma and Convert to Number    ${FacHBNetCmtAmt}
    ${FacHBFundableCmtAmt}    Remove Comma and Convert to Number    ${FacHBFundableCmtAmt}
    ${FacHBOutstandingNetAmt}    Remove Comma and Convert to Number    ${FacHBOutstandingNetAmt}
    ${FacHBNetAvailToDrawAmt}    Remove Comma and Convert to Number    ${FacHBNetAvailToDrawAmt}
    ${FacGlobalCurrentCmtAmt}    Remove Comma and Convert to Number    ${FacGlobalCurrentCmtAmt}
    ${FacGlobalClosingCmtAmt}    Remove Comma and Convert to Number    ${FacGlobalClosingCmtAmt}
    ${FacGlobalOutstandingAmt}    Remove Comma and Convert to Number    ${FacGlobalOutstandingAmt}
    ${FacGlobalAvailtoDrawAmt}    Remove Comma and Convert to Number    ${FacGlobalAvailtoDrawAmt}
    
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_HostBankNetCommitment    ${rowid}    ${FacHBNetCmtAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_HostBankFundableCommitment    ${rowid}    ${FacHBFundableCmtAmt}    ${ComSeeDataSet} 
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_HostBankNetOutstandings    ${rowid}    ${FacHBOutstandingNetAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_HostBankNetAvailableToDraw    ${rowid}    ${FacHBNetAvailToDrawAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_GlobalCurrentCommitment    ${rowid}    ${FacGlobalCurrentCmtAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_GlobalClosingCommitment    ${rowid}    ${FacGlobalClosingCmtAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_GlobalOutstandings    ${rowid}    ${FacGlobalOutstandingAmt}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_GlobalAvailableToDraw    ${rowid}    ${FacGlobalAvailtoDrawAmt}    ${ComSeeDataSet}
  
    ###Expense Code Writing
    ${ExpenseCodeDesc}    Get Expense Description from Table Maintenance    &{ExcelPath}[Primary_RiskBook]   
    ${FacExpenseCode}    Get Facility Expense Code and Description Combined    &{ExcelPath}[Primary_RiskBook]    ${ExpenseCodeDesc}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_ExpenseCode    ${rowid}    ${FacExpenseCode}    ${ComSeeDataSet}        
    
    ##Portfolio Code Writing
    ${PortfolioCode}    Get Portfolio Code from Table Maintenance    &{ExcelPath}[Primary_Portfolio]
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_PortfolioCode    ${rowid}    ${PortfolioCode}    ${ComSeeDataSet}
    
    ###Funding Desk Code Writing
    ${FundingDeskCode}    Get Funding Desk Code from Table Maintenance    &{ExcelPath}[Primary_PortfolioBranch]
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_FundingDeskCode    ${rowid}    ${FundingDeskCode}    ${ComSeeDataSet}  
    
    ###Lender, Facility, Borrower, and Facility Outstanding Count Writing
    
    ${LenderCount}    Get Lender Count    &{ExcelPath}[Primary_Lender1],&{ExcelPath}[Primary_Lender2],&{ExcelPath}[Primary_Lender3]    ,
    ${FacilityCount}    Get Facility Count    &{ExcelPath}[Facility_Name]    ${EMPTY}
    ${BorrowerCount}    Get Borrower Count    &{ExcelPath}[Borrower_ShortName]    ${EMPTY}
    ${OutstandingCount}    Get Facility Outstanding Count    ${EMPTY}    ${EMPTY}
    
    Write Data To Excel    ComSee_SC2_Deal    Deal_NoOfLenders    ${rowid}    ${LenderCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_NoOfLenders    ${rowid}    ${LenderCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    Deal_NoOfFacitlities    ${rowid}    ${FacilityCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_Deal    Deal_NoOfBorrowers    ${rowid}    ${BorrowerCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_NoOfBorrowers    ${rowid}    ${BorrowerCount}    ${ComSeeDataSet}
    Write Data To Excel    ComSee_SC2_FacSetup    Facility_NoOfOutstanding    ${rowid}    ${OutstandingCount}    ${ComSeeDataSet}
    
    Close All Windows on LIQ
    Logout from LoanIQ  