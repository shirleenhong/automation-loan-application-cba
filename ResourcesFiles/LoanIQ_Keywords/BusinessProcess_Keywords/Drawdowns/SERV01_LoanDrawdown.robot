*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Initial Loan Drawdown with no Repayment Schedule
    [Documentation]    This keyword is used to create a Loan Drawdown without selecting a Payment Schedule.
    ...    @author: fmamaril
    ...    @update: hstone    05MAY2020    - Commented Release Cashflow Block, Replaced with Drawdown Release Block
    ...    @update: hstone    20MAY2020    - Added 'Release Cashflow Based on Remittance Instruction'
    ...                                    - Replaced 'Navigate Notebook Workflow' with 'Navigate to Loan Drawdown Workflow and Proceed With Transaction'
    ...                                    - Removed commented 'Generate Rate Setting Notices for Drawdown    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[NoticeStatus]'
    ...                                    - Removed commented '${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown   Loan_Alias    ${rowid}'
    ...    @update: mcastro    20OCT2020   - Added argument variable for Get Host Bank Cash in Cashflow
    ...    @update: kduenas    29OCT2020   - Added generation of Rate Setting Notice as pre-requisite of Correspondence testcase
    [Arguments]    ${ExcelPath}    
    
    ###Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}
    Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}
    
    ##Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SERV01_LoanDrawdown   Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    SERV21_InterestPayments   Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    SERV18_Payments   Loan_Alias    ${rowid}    ${Loan_Alias}    
        
    ###Initial Loan Drawdown###
    ###For Scenario 7###
    Run Keyword If    '${SCENARIO}'=='7'    Run Keywords    Write Data To Excel    SERV35_Terminate_FacilityDeal    Loan_Alias    ${rowid}    ${Loan_Alias}
    ...    AND    Write Data To Excel    SERV19_UnscheduledPayments   Loan_Alias    ${rowid}    ${Loan_Alias}
   
    Validate Initial Loan Dradown Details    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_Currency]
    ${AdjustedDueDate}    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    
    Write Data To Excel    SERV21_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}
    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
 
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Facility_Currency]   
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Credit Amt    
    ${UITotalCreditAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Credit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Credit Amt
    ${UITotalDebitAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Debit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Debit Amt   
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[Loan_RequestedAmount]

    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Generate Rate Setting Notices    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Send to Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown     ${Loan_Alias}
    Approve Initial Drawdown Rate
    
    ###Generate Rate Setting Notices###
    Generate Rate Setting Notices for Drawdown    &{ExcelPath}[Borrower1_LegalName]    &{ExcelPath}[NoticeStatus]
    
    ###Cashflow Notebook - Release Cashflows###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower1_ShortName]

    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Create First Term Facility Loan Drawdown
    [Documentation]    This keyword is used to create Term Loan Drawdown for SYNDICATED deal in AUD
    ...    @author: mnanquil
    ...    @update: bernchua    08NOV2018    Get and use Borrower/Lender names from Deal and secondary sale Excel data for integrated scenario.
    ...    @update: bernchua    19NOV2018    Commented out the setting of Day 4 calendar date, since it is initially done in the Deal setup part.
    ...    @update: bernchua    06MAR2019    Updated with standard Cashflow keywords.
    ...    @update: bernchua    07MAR2019    Updated keywords for Workflow navigation to use "Navigate Notebook Workflow"
    ...    @update: bernchua    11APR2019    Added getting of amounts from Facility Notebook to be used in "Validate Global Facility Amounts - Balanced"
    ...    @update: dahijara    03SEP2020    Updated Get Base Rate from Funding Rate Details
    ...                                      Updated workflow navigation
    ...                                      Updated arguments for Verify notices flow.
    ...                                      Uncomment necessary steps.
    ...    @update: dahijara    10SEP2020    Updated hard coded values with variables.
    ...    @update: dahijara    28SEP2020    - Updated sheet name for Loan Merge from COMPR06_LoanMerge to SERV11_Loan Amalgamation
    ...    @update: kduenas    27OCT2020    - added writing of loan alias for API_TC_023 of corro
    [Arguments]    ${ExcelPath}
    
    ### Get Base Rate data generated from TL-API Base Rate test case. ###
    ${BaseRatePercentage}    Get Base Rate from Funding Rate Details    BBSY    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_Currency]
    
    ${Loan_RepricingDate}    Read Data From Excel    API_HolidayCalendar    NonBusinessDay_Date    &{ExcelPath}[rowid]
    ${Holiday_Reason}    Read Data From Excel    API_HolidayCalendar    NonBusinessDay_Reason    &{ExcelPath}[rowid]
    
    Write Data To Excel    SERV01_LoanDrawdown    Loan_RepricingDate    &{ExcelPath}[rowid]    ${Loan_RepricingDate}    multipleValue=Y
    
    Log    ${Holiday_Reason}
    
	${Borrower_ShortName}    Read Data From Excel    SERV01_LoanDrawdown    Borrower_ShortName    &{ExcelPath}[rowid]
    ${Lender1_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender    &{ExcelPath}[rowid]
    ${Lender2_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender_2    &{ExcelPath}[rowid]
    ${Lender1_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal    &{ExcelPath}[rowid]
    ${Lender2_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal2    &{ExcelPath}[rowid]
    ${HostBankLender_Share}    Evaluate    100-(${Lender1_Share}+${Lender2_Share})
    ${Portfolio_Name}    Read Data From Excel    CRED01_DealSetup    Primary_Portfolio    &{ExcelPath}[rowid]
    ${Portfolio_ExpenseCode}    Read Data From Excel    CRED01_DealSetup    Primary_RiskBook    &{ExcelPath}[rowid]
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    
    ### Searching a Deal ###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]  
    ${sNewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${sNewGlobalOutstandings}    Get New Facility Global Outstandings
    ${sCurrentCmtAmt}    Get Current Commitment Amount
    Validate Global Facility Amounts - Balanced    ${sNewAvailToDrawAmount}    ${sNewGlobalOutstandings}    ${sCurrentCmtAmt} 
    Validate Host Bank Share Gross Amounts    ${HostBankLender_Share}
    Close All Windows on LIQ
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ${Lender1_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender1_ShortName}
    ${Lender2_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender2_ShortName}
    
    ### Navigating a Facility ###
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentAvailToDraw    &{ExcelPath}[rowid]    ${AvailToDrawAmount}
    Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentGlobalOutstandings    &{ExcelPath}[rowid]    ${GlobalOutstandings}
    
    ### Outstanding Select Window ###
    Navigate to Outstanding Select Window
    
    ### Create Initial Loan Drawdown Details ###
    ${Drawdown_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Borrower_ShortName}    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Drawdown_Alias}
    Write Data To Excel    SERV11_Loan Amalgamation    Alias_Loan1    &{ExcelPath}[rowid]    ${Drawdown_Alias}
    Write Data To Excel    Correspondence    Loan_Alias    23    ${Drawdown_Alias}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    
    ${Current_Date}    Get System Date
    ${Loan_MaturityDate}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    &{ExcelPath}[rowid]
    
    Enter Loan Drawdown Details for AUD Libor Option    &{ExcelPath}[Loan_RequestedAmount]    ${Current_Date}    ${Loan_MaturityDate}
    ...    &{ExcelPath}[Loan_RepricingFrequency]    ${Loan_RepricingDate}    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    ${Holiday_Reason} 
    
    Write Data To Excel    SERV11_Loan Amalgamation    Outstandings_Loan1    &{ExcelPath}[rowid]    &{ExcelPath}[Loan_RequestedAmount]
    
    Accept Loan Drawdown Rates for Term Facility    ${BaseRatePercentage}
    
    Validate Rate Set    &{ExcelPath}[BaseRate_Description]
    
    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    ${Borrower_ShortName}    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    ${Lender1_ShortName}    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    ${Lender2_ShortName}    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    Verify if Status is set to Do It    ${Borrower_ShortName}
    Verify if Status is set to Do It    ${Lender1_ShortName}
    Verify if Status is set to Do It    ${Lender2_ShortName}
    
    ### Get Transaction Amount for Cashflow ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    ${Borrower_ShortName}
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    ${Lender1_ShortName}
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    ${Lender2_ShortName}
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${HostBankLender_Share}
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${Lender1_Share}
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${Lender2_Share}
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
    
    ### GL Entries ###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    ${HostBank_CustomerPortfolio}    ${DEBIT_AMT_LABEL}
    ${Lender1_Debit}    Get GL Entries Amount    ${Lender1_ShortName}    ${DEBIT_AMT_LABEL}
    ${Lender2_Debit}    Get GL Entries Amount    ${Lender2_ShortName}    ${DEBIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    ${Borrower_ShortName}    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    ${DEBIT_AMT_LABEL}
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]
    
    
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Drawdown_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Drawdown_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_APPROVAL_TRANSACTION}
    
    ${Customer_LegalName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_LegalName    &{ExcelPath}[rowid]
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Click OK In Notices Window
    Verify Customer Notice Method    ${Customer_LegalName}    &{ExcelPath}[Notice_BorrowerContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${SUPERVISOR_USERNAME}    &{ExcelPath}[Notice_BorrowerMethod]    &{ExcelPath}[BorrowerContact_Email]
    Verify Customer Notice Method    ${Lender1_LegalName}    &{ExcelPath}[Notice_Lender1ContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${SUPERVISOR_USERNAME}    &{ExcelPath}[Notice_Lender1Method]    &{ExcelPath}[Lender1Contact_Email]
    Verify Customer Notice Method    ${Lender2_LegalName}    &{ExcelPath}[Notice_Lender2ContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${SUPERVISOR_USERNAME}    &{ExcelPath}[Notice_Lender2Method]    &{ExcelPath}[Lender2Contact_Email]
    Close Notice Group Window
    
    Close All Windows on LIQ
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Drawdown_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    
    Validate Rate Set    ${RELEASED_STATUS}
    
    Close All Windows on LIQ
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]  
    ${sNewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${sNewGlobalOutstandings}    Get New Facility Global Outstandings
    ${sCurrentCmtAmt}    Get Current Commitment Amount
    Validate Global Facility Amounts - Balanced    ${sNewAvailToDrawAmount}    ${sNewGlobalOutstandings}    ${sCurrentCmtAmt}
    Validate Host Bank Share Gross Amounts    ${HostBankLender_Share}
    
    Close All Windows on LIQ 
    
Create Revolver Facility Drawdown
    [Documentation]    This high-level keyword for creating an initial Loan Drawdown from a Revolver Facility with Different Currency, and API validation.
    ...                @author: bernchua
    ...                @update: bernhcua    08MAR2019    Cashflows/GL Entries keyword updates
    ...    @update: dahijara    18SEP2020    Updated Get Base Rate from Funding Rate Details
    ...                                      Updated workflow navigation
    ...                                      Updated arguments for Verify notices flow.
    ...                                      Uncomment necessary steps.
    ...                                      Updated hard coded values with variables.
    ...                                      Replaced logic for releasing of cashflow to make it more dynamic.
    [Arguments]    ${ExcelPath}
    
    ${BaseRatePercentage}    Get Base Rate from Funding Rate Details    LIBOR    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_Currency]
    ${ExchangeRate}    Get Currency Exchange Rate from Treasury Navigation    &{ExcelPath}[CurrencyExchange]
    
    ### Get data from Secondary Sale test case ###
    ${Borrower_ShortName}    Read Data From Excel    CRED01_DealSetup    Borrower_ShortName    1
    ${Lender1_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender    1
    ${Lender2_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender_2    1
    ${Lender1_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal    1
    ${Lender2_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal2    1
    ${HostBankLender_Share}    Evaluate    100-(${Lender1_Share}+${Lender2_Share})
    ${Portfolio_Name}    Read Data From Excel    PTRF_CRE01_PortfolioTransfer    Portfolio    1
    ${Portfolio_ExpenseCode}    Read Data From Excel    PTRF_CRE01_PortfolioTransfer    Expense_Code    1
    ${Portfolio_ExpenseCode}    Fetch From Left    ${Portfolio_ExpenseCode}    -
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    
    ### Open existing Deal and go to Facility Notebook ###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
	### GET CUSTOMER LENDER LEGAL NAME TO BE USED IN INTENT NOTICE VALIDATION ###
    ${Lender1_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender1_ShortName}
    ${Lender2_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender2_ShortName}
    
    Open Facility From Deal Notebook    &{ExcelPath}[Facility_Name]
    ${Facility_Expiry}            Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_ExpiryDate_Datefield}
    ${Facililty_Currency}         Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_Currency_StaticText}
    ${PreOutstandingAmt_GFA}      Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_GlobalFacilityAmount_Outstandings}
    ${PreOutstandingAmt_HBG}      Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_HostBankOutstanding}
    ${PreOutstandingAmt_HBN}      Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_HostBankNet_Outstandings}
    ${PreAvailToDraw_GFA}         Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_HostBankAvailToDraw}
    ${PreAvailToDraw_HBG}         Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}
    ${PreAvailToDraw_HBN}         Get Data From LoanIQ    ${LIQ_FacilityNotebook_Window}    ${LIQ_FacilityNotebook_Tab}    Summary    ${LIQ_FacilitySummary_HostBankNet_AvailToDrawNet}
    
    ### Go to Outstanding Select and create new Loan Drawdown ###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Borrower_ShortName}    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Loan_Alias}
    Write Data To Excel    SERV12_LoanSplit    Loan_Alias    1    ${Loan_Alias}
    
    ### Set General tab details in the Initial Loan Drawdown Notebook ###
    ${API_NBD_Date}    Read Data From Excel    API_HolidayCalendar    NonBusinessDay_Date    1
    ${Current_Date}    Get System Date
    Enter Initial Loan Drawdown General Details    &{ExcelPath}[Loan_RequestedAmount]    ${Current_Date}    ${Facility_Expiry}    &{ExcelPath}[Loan_Accrue]    &{ExcelPath}[Loan_Currency]    &{ExcelPath}[Loan_RepricingFrequency]    ${API_NBD_Date}
    
    ### Set Rates in Initial Drawdown notebook ###
    Set Base Rate In Drawdown Notebook With API Validations    ${BaseRatePercentage}
    
    ### Verify info in Events Tab of Drawdown Notebook ###
    Validate Drawdown Rate Change Event    ${BaseRatePercentage}
    
    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    ${Borrower_ShortName}    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    ${Lender1_ShortName}    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    ${Lender2_ShortName}    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    Verify if Status is set to Do It    ${Borrower_ShortName}
    Verify if Status is set to Do It    ${Lender1_ShortName}
    Verify if Status is set to Do It    ${Lender2_ShortName}
    
    ### Get Transaction Amount for Cashflow ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    ${Borrower_ShortName}
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    ${Lender1_ShortName}
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    ${Lender2_ShortName}
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${HostBankLender_Share}
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${Lender1_Share}
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${Lender2_Share}
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
    
    ### GL Entries ###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    ${HostBank_CustomerPortfolio}    ${DEBIT_AMT_LABEL}
    ${Lender1_Debit}    Get GL Entries Amount    ${Lender1_ShortName}    ${DEBIT_AMT_LABEL}
    ${Lender2_Debit}    Get GL Entries Amount    ${Lender2_ShortName}    ${DEBIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    ${Borrower_ShortName}    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    ${DEBIT_AMT_LABEL}
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]
    
    
    ### Send to Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${AWAITING_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${AWAITING_SEND_TO_RATE_APPROVAL_STATUS}
    
    ### Go back to original user ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Set FX Rates ###
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_SET_FX_RATE_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}    ### commented out in IEE testing
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SET_FX_RATE_TRANSACTION}
    Set Initial Drawdown Spot FX Rate    &{ExcelPath}[CurrencyExchange]    ${ExchangeRate}
    
    ### Send to Rate Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${AWAITING_RATE_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_APPROVAL_TRANSACTION}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${AWAITING_RELEASE_STATUS}
    
    ### Generate Intent Notices ###
    ${Customer_LegalName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_LegalName    1
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Click OK In Notices Window
    Verify Customer Notice Method    ${Customer_LegalName}    &{ExcelPath}[Notice_BorrowerContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${MANAGER_USERNAME}    &{ExcelPath}[Notice_BorrowerMethod]    &{ExcelPath}[BorrowerContact_Email]
    Verify Customer Notice Method    ${Lender1_LegalName}    &{ExcelPath}[Notice_Lender1ContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${MANAGER_USERNAME}    &{ExcelPath}[Notice_Lender1Method]    &{ExcelPath}[Lender1Contact_Email]
    Verify Customer Notice Method    ${Lender2_LegalName}    &{ExcelPath}[Notice_Lender2ContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${MANAGER_USERNAME}    &{ExcelPath}[Notice_Lender2Method]    &{ExcelPath}[Lender2Contact_Email]
    Close Notice Group Window
    
    ### Release Cashflows ###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance2_Instruction]    &{ExcelPath}[Lender1_ShortName]
    
    ### Release ###
    Close All Windows on LIQ
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Validate Window Title Status    ${INITIAL_DRAWDOWN_TITLE}    ${RELEASED_STATUS}
    
    ### Validate details in Currency tab ###
    ${Computed_Current}    ${Computed_HostBankGross}    ${Computed_HostBanknet}    Validate Initial Drawdown Currency Tab Details    &{ExcelPath}[Loan_Currency]    ${Facililty_Currency}    &{ExcelPath}[CurrencyExchange]
    ...    ${ExchangeRate}    &{ExcelPath}[Loan_RequestedAmount]    ${HostBankLender_Share}  
    
    ### Validate Drawdown Released Event ###
    Validate Initial Drawdown Events Tab    ${RELEASED_STATUS}
    
    ### Post Validations in Facility Notebook ###
    Go To Facility From Initial Drawdown Notebook
    Post Validation Of Computed Amounts In Facility After Drawdown    ${HostBankLender_Share}    ${Computed_Current}    ${Computed_HostBankGross}    ${Computed_HostBanknet}
    ...    ${PreOutstandingAmt_GFA}    ${PreOutstandingAmt_HBG}    ${PreOutstandingAmt_HBN}
    Post Validation Of Facility Summary Amounts After Drawdown    ${PreOutstandingAmt_GFA}    ${PreOutstandingAmt_HBG}    ${PreOutstandingAmt_HBN}
    ...    ${PreAvailToDraw_GFA}    ${PreAvailToDraw_HBG}    ${PreAvailToDraw_HBN}
    
    ### Close all windows and go back to original user ###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Create Second Term Facility Loan Drawdown
    [Documentation]    This keyword is used to create Term Loan Drawdown for SYNDICATED deal in AUD
    ...    @author: mnanquil
    ...    @update: bernchua    08NOV2018    Get and use Borrower/Lender names/shares from Deal and Secondary Sale Excel data for integrated scenario.
    ...    @update: bernchua    04MAR2019    Removed old API automation script to be replaced by Transformation Layer scripts
    ...    @update: dahijara    03SEP2020    Removed wait keyword in test case level
    ...                                      Added reading for API_HolidayCalendar - NonBusinessDay_Date to get Loan_RepricingDate
    ...                                      Added writing for Loan_RepricingDate
    ...                                      Aupdated arguments for verify notices.
    ...                                      Uncomment necessary steps.
    ...    @update: dahijara    10SEP2020    Updated hard coded values with variables.
    ...    @update: dahijara    28SEP2020    - Updated sheet name for Loan Merge from COMPR06_LoanMerge to SERV11_Loan Amalgamation
    [Arguments]    ${ExcelPath}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ${BaseRatePercentage}    Get Base Rate from Funding Rate Details    BBSY    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_Currency]
    
    ${Loan_RepricingDate}    Read Data From Excel    API_HolidayCalendar    NonBusinessDay_Date    1
    ${Holiday_Reason}    Read Data From Excel    API_HolidayCalendar    NonBusinessDay_Reason    1
    Log    ${Holiday_Reason}
    
    Write Data To Excel    SERV01_LoanDrawdown    Loan_RepricingDate    &{ExcelPath}[rowid]    ${Loan_RepricingDate}
    ${Borrower_ShortName}    Read Data From Excel    CRED01_DealSetup    Borrower_ShortName    1
    ${Lender1_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender    1
    ${Lender2_ShortName}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender_2    1
    ${Lender1_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal    1
    ${Lender2_Share}    Read Data From Excel    TRP002_SecondarySale    PctofDeal2    1
    ${HostBankLender_Share}    Evaluate    100-(${Lender1_Share}+${Lender2_Share})
    ${Portfolio_Name}    Read Data From Excel    CRED01_DealSetup    Primary_Portfolio    1
    ${Portfolio_ExpenseCode}    Read Data From Excel    CRED01_DealSetup    Primary_RiskBook    1
    ${HostBank_CustomerPortfolio}    Set Variable    CB001/${Portfolio_Name}/${Portfolio_ExpenseCode}
    
    ### Searching a Deal ###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]  
    ${sNewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${sNewGlobalOutstandings}    Get New Facility Global Outstandings
    ${sCurrentCmtAmt}    Get Current Commitment Amount
    Validate Global Facility Amounts - Balanced    ${sNewAvailToDrawAmount}    ${sNewGlobalOutstandings}    ${sCurrentCmtAmt}
    Validate Host Bank Share Gross Amounts    ${HostBankLender_Share}
    Close All Windows on LIQ
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ${Lender1_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender1_ShortName}
    ${Lender2_LegalName}    Get Customer Lender Legal Name Via Lender Shares In Deal Notebook    ${Lender2_ShortName}
    
    ### Navigating a Facility ###
    Navigate to Facility Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]

    ### Outstanding Select Window ###
    Navigate to Outstanding Select Window
    
       
    ### Create Initial Loan Drawdown Details ###
    ${Drawdown_Alias}    New Outstanding Select    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${Borrower_ShortName}    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SERV01_LoanDrawdown    Loan_Alias    &{ExcelPath}[rowid]    ${Drawdown_Alias}
    Write Data To Excel    SERV11_Loan Amalgamation    Alias_Loan2    1    ${Drawdown_Alias}
    
    ${Current_Date}    Get System Date
    ${Loan_MaturityDate}    Read Data From Excel    CRED02_FacilitySetup    Facility_ExpiryDate    1
    
    Enter Loan Drawdown Details for AUD Libor Option    &{ExcelPath}[Loan_RequestedAmount]    ${Current_Date}    ${Loan_MaturityDate}
    ...    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    ${Holiday_Reason}
    
    Write Data To Excel    SERV11_Loan Amalgamation    Outstandings_Loan2    1    &{ExcelPath}[Loan_RequestedAmount]
        
    Accept Loan Drawdown Rates for Term Facility    ${BaseRatePercentage}
    
    Validate Rate Set    &{ExcelPath}[BaseRate_Description]
    
    
    ### Cashflow Notebook - Create Cashflows ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    ${Borrower_ShortName}    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    ${Lender1_ShortName}    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    ${Lender2_ShortName}    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    Verify if Status is set to Do It    ${Borrower_ShortName}
    Verify if Status is set to Do It    ${Lender1_ShortName}
    Verify if Status is set to Do It    ${Lender2_ShortName}
    
    ### Get Transaction Amount for Cashflow ###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    ${Borrower_ShortName}
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    ${Lender1_ShortName}
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    ${Lender2_ShortName}
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${HostBankLender_Share}
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${Lender1_Share}
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    ${Lender2_Share}
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
    
    ### GL Entries ###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    ${HostBank_CustomerPortfolio}    ${DEBIT_AMT_LABEL}
    ${Lender1_Debit}    Get GL Entries Amount    ${Lender1_ShortName}    ${DEBIT_AMT_LABEL}
    ${Lender2_Debit}    Get GL Entries Amount    ${Lender2_ShortName}    ${DEBIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    ${Borrower_ShortName}    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    ${DEBIT_AMT_LABEL}
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]
    
    
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Drawdown_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SEND_TO_RATE_APPROVAL_STATUS}
    
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Drawdown_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_APPROVAL_TRANSACTION}
    
    ${Customer_LegalName}    Read Data From Excel    ORIG03_Customer    LIQCustomer_LegalName    1
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${GENERATE_RATE_SETTING_NOTICES_TRANSACTION}
    Click OK In Notices Window
    Verify Customer Notice Method    ${Customer_LegalName}    &{ExcelPath}[Notice_BorrowerContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${SUPERVISOR_USERNAME}    &{ExcelPath}[Notice_BorrowerMethod]    &{ExcelPath}[BorrowerContact_Email]
    Verify Customer Notice Method    ${Lender1_LegalName}    &{ExcelPath}[Notice_Lender1ContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${SUPERVISOR_USERNAME}    &{ExcelPath}[Notice_Lender1Method]    &{ExcelPath}[Lender1Contact_Email]
    Verify Customer Notice Method    ${Lender2_LegalName}    &{ExcelPath}[Notice_Lender2ContactPerson]    ${AWAITING_RELEASE_NOTICE_STATUS}    ${SUPERVISOR_USERNAME}    &{ExcelPath}[Notice_Lender2Method]    &{ExcelPath}[Lender2Contact_Email]
    Close Notice Group Window
    
    Close All Windows on LIQ
    Navigate Transaction in WIP    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}    ${Drawdown_Alias}    ### added in IEE testing
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    Validate Rate Set    ${RELEASED_STATUS}
    
    Close All Windows on LIQ
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]  
    ${sNewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${sNewGlobalOutstandings}    Get New Facility Global Outstandings
    ${sCurrentCmtAmt}    Get Current Commitment Amount
    Validate Global Facility Amounts - Balanced    ${sNewAvailToDrawAmount}    ${sNewGlobalOutstandings}    ${sCurrentCmtAmt}
    Validate Host Bank Share Gross Amounts    ${HostBankLender_Share}
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}       

Create Initial Loan Drawdown for RPA Deal
    [Documentation]    This keyword is used to create a Loan Drawdown for RPA deal.
    ...    @author: dahijara    28OCT2020    - Initial create
    ...    @update: mcastro     03NOV2020    - Added Writing to SERV08_ComprehensiveRepricing for RPA Scenario 1
    ...    @update: dahijara    04NOV2020    - Added writing for SERV08_ComprehensiveRepricing-Loan_Alias
    ...    @update: mcastro     16NOV2020    - Added condition for RPA scenario 3
    ...    @update: dahijara    19NOV2020    - Added condition for RPA Scenario 5 Loan_Alias data writing to excel
    ...    @update: mcastro     19NOV2020    - Removed condition on writing of Loan_Alias
    [Arguments]    ${ExcelPath}    
    
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ###Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}
    Write Data To Excel    SERV01_LoanDrawdown   Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}
    
    ##Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]
    Write Data To Excel    SERV01_LoanDrawdown   Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    SERV08_ComprehensiveRepricing   Loan_Alias    ${rowid}    ${Loan_Alias}
      
    ###Initial Loan Drawdown###
    Validate Initial Loan Dradown Details    &{ExcelPath}[Loan_FacilityName]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Loan_Currency]
    ${AdjustedDueDate}    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_IntCycleFrequency]    &{ExcelPath}[Loan_Accrue]    
    Write Data To Excel    SERV21_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}
    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  

    ### GL Entries ###
    Navigate to GL Entries
    Close GL Entries and Cashflow Window

    ### Set FX Rates for RPA Scenario 3###
    Run Keyword If    '${SCENARIO}'=='3' and '${rowid}'=='2'  Run Keywords    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${SET_FX_RATE_TRANSACTION}
    ...   AND   Complete Set FX Rate

    ###Approval of Loan###
    Send Initial Drawdown to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Approve Initial Drawdown
    
    ###Rate Setting###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_SEND_TO_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Send Initial Drawdown to Rate Approval
        
    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}
    Approve Initial Drawdown Rate
    
    ###Cashflow Notebook - Release Cashflows###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower1_ShortName]

    Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}