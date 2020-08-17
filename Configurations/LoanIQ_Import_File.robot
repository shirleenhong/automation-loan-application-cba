*** Settings ***
Library    BaselineComparator
Library    Collections
Library    CSVLib    
Library    CSVLibrary    
Library    SeleniumLibraryExtended
Library    DatabaseLibrary
Library    DateTime
Library    EssenceLib
Library    ExcelLibrary
Library    GenericLib
Library    HttpLibraryExtended
Library    JSONLibraryKeywords
Library    Keyboard
Library    LoanIQ    exception_handling=No
Library    OperatingSystem
Library    Process
Library    RequestsLibrary
Library    Screenshot
Library    SSHLibrary
Library    String
Library    UFTGeneric    Visibility=True     UFTAddins=Java
Library    Dialogs
Library    XML
Library    base64
#Library    PdfToText
Library    MathLibrary    

### Global Variables ###
Resource    ../Variables/Global_Variables.txt
Resource    ../Variables/Calendar_Properties.txt
Resource    ../Variables/Queries.txt
Resource    ../Variables/Users_Properties.txt
Resource    ../Variables/BaseRatesInterest_Properties.txt
Resource    ../Variables/FXRates_Properties.txt
Resource    ../Variables/Correspondence_Properties.txt

### Configurations ###
Resource    ../Configurations/DB_Connection.txt
Variables    ../Configurations/GenericConfig.py
Variables    ../Configurations/Global_Variables.py

### LoanIQ Variable Files - Locators ###
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_AccountingAndControl_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_AccrualSharesAdjustment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_AdminFee_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ActivityList_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_AdminFeeChangeTransaction_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Amendment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_AssignmentSell_Locator.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_AutomaticShareAdjustment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Batch_Administration_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_BreakfundingFee_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_BusinessEventOutput_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Cashflow_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Circle_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_CommitmentFee_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_CurrecyExchangeRates_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Customer_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Deal_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Decrease_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_EssenceGL_Notebook.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_EventFee_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Facility_AddUnscheduled_CommitmentIncrease_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Facility_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_FrontingCommitmentFee_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_FundingRates_Locator.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Global_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_GuaranteeDrawdown_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_IncomingManualCashflow_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Increase_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_IndemnityFee_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_InterestCapitalization_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_InterestPayments_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Issuance_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_LineFee_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Loan_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_LoanChangeTransaction_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_LoanDrawdown_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_LoanRepricing_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ManualCashflow_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ManualFundFlow_Notebook.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ManualGL_Notebook.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ManualShareAdjustment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Notices_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_OpenAUserProfile_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_OutgoingManualCashflow_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_OngoingFeePayment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_PaperClip_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Portfolio_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_PricingChangeTransaction_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Primaries_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_PrincipalPayment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_RepaymentPaperClip_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ReverseInitialDrawdown_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ReversePrincipalPayment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_RolloverConversion_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_SBLC_Decrease_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_SBLCGuarantee_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ScheduledCommitment_Locator.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ScheduledPrincipalPayment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_ShareAdjustment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_TableMaintenance_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_Tickler_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_TickingFee_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_TreasuryNavigation_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_UnscheduledCommitmentDecrease_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_UnscheduledCommitmentIncrease_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_UnscheduledPrincipalPayment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_UpfrontFeePayment_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_User_Administration_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_WorkInProcess_Locators.py
Variables    ../ObjectMap/LoanIQ_Locators/LIQ_UpfrontFeeDistribution_Locators.py

### FFC Variable Files - Locators ###
Variables    ../ObjectMap/FFC_Locators/Dashboard_Locators.py

### SSO Variable Files - Locators ###
Variables    ../ObjectMap/SSO_Locators/SSO_EnquireUser_Locators.py
Variables    ../ObjectMap/SSO_Locators/SSO_Global_Locators.py

### Generic Resource Files - Custom Mapping ###
Resource    ../ResourcesFiles/Generic_Keywords/Custom_Mapping/BUS_LoanIQ_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Custom_Mapping/BUS_Generic_Keywords.robot

### Generic Resource Files - Utility ###
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/API_UtilityKeywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/BatchAdministration_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/Database_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/GenericKeywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/LoanIQ_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/WinSCP_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/MCH_Keywords.robot
Resource    ../ResourcesFiles/Generic_Keywords/Utility_Keywords/SSO_Keywords.robot

### LoanIQ Resource Files - Business Process ###
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/AdditionalSetUpOptions/SERV13_InterestCapitalization.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/AdditionalSetUpOptions/SERV14_CapsAndFloorsSetUp.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/AdditionalSetUpOptions/SERV17_SetupRepaymentSchedule.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/AdditionalSetUpOptions/SERV45_CreateTemporaryPaymentPlan.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/AdditionalSetUpOptions/SERV46_Reschedule_Temporary_Payment_Plan.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/AdditionalSetUpOptions/SERV47_SetupFlexSchedule.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Changes/SERV39_AvailabilityChange_NonCommittedFacilities.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Adjustments/MTAM04_Adjustment_Send_Cashflows_to_SPAP.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Adjustments/MTAM05_ReversalsAdjustment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Adjustments/MTAM06_AccrualsAdjustment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Adjustments/MTAM07_FacilityShareAdjustment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Adjustments/MTAM08_LoanSharesAdjustment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Adjustments/MTAM16_ResyncAFlexSchedule.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Adjustments/MTAM17_AdjustResyncSettingsForAFlexSchedule.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Amendments/AMCH02_DealAmendmentsNonAgent.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Amendments/AMCH03_DealAmendmentsAgency.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/AutomatedTransactions/AUTO01_SetUpAutomatedTransactions.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/BusinessProcesses/BUPR03_UpfrontFeeDrawdown.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/CashManagement/SERV24_CreateCashflow.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/CashManagement/SERV25_ReleaseCashflows.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/CashManagement/SERV27_CompleteCashflows.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Changes/AMCH04_DealChangeTransaction.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Changes/AMCH05_FacilityChangetransaction.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Changes/AMCH06_PricingChangeTransaction.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Changes/AMCH07_OutstandingChangetransaction.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Changes/AMCH08_RemittanceInstructionsChangeTransaction.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Changes/AMCH09_ContactChangeTransaction.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Changes/AMCH10_AdminFeeChangeTransaction.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Changes/AMCH11_AddNewFacility.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Customer/ORIG02_CreateCustomer.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Customer/ORIG03_CustomerOnboarding.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/DealSetup/CRED01_DealSetUpWithoutOrigination.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/DealSetup/CRED02_SBLCGuaranteeSetUp.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/DealSetup/CRED03_AutomaticMarginChangesSetup.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/DealSetup/CRED05_SetUpCommitmentSchedule.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/DealSetup/CRED13_ApplicationOfOriginationCost.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Drawdowns/SERV01_LoanDrawdown.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Drawdowns/SERV02_LoanDrawdownNonAgent.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Drawdowns/SERV03_DrawingUnderANonCommittedLine.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Drawdowns/SERV05_SBLCIssuance.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Drawdowns/SERV07_SBLCDrawdown.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Decrease/SERV16_UnscheduledCommitmentDecrease.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeePayments/SERV29_OngoingFeePayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeePayments/SERV30_AdminFeePayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeePayments/SERV33_RecurringFeePayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeePayments/SERV42_BorrowingBaseCreation.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeeSetup/CRED06_TickingFeeSetUp.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeeSetup/CRED07_UpfrontFeeSetup.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeeSetup/CRED08_OngoingFeeSetup.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeeSetup/CRED09_AdminFeeSetup.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeeSetup/CRED10_EventDrivenFeeSetUp.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeeSetup/CRED11_EventDrivenFeeAdvanced.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/FeeSetup/CRED15_ReviewFeeActivityList.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/ManualTransactions/MTAM01_ManualGL.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/ManualTransactions/MTAM02_ManualCashflow.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/ManualTransactions/MTAM03_ManualFundsFlow.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Miscellaneous/MTAM09_CreateTickler.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Miscellaneous/MTAM12_ManualGL_NewOrExistingWIPItem.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Miscellaneous/MTAM13_ManualCashflow_Incoming_NewOrExistingWIPItem.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Miscellaneous/MTAM14_ManualCashflow_Outgoing_NewOrExistingWIPItem.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Payments/SERV18_ScheduledPrincipalPayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Payments/SERV19_UnscheduledPrincipalPaymentNoSchedule.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Payments/SERV20_UnschedulePrincipalPayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Payments/SERV21_InterestPayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Payments/SERV22_InterestPaymentNonAgent.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Payments/SERV23_PaperClipPayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/PortfolioManagement/TRPO11_PortfolioTransfer.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/PortfolioManagement/TRPO12_PortfolioSettledDiscountChange.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/PortfolioManagement/TRPO13_PortfolioTradeDateDiscountChange.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Rollovers/SERV08_ComprehensiveRepricing.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Rollovers/SERV09_LoanRepricingNonAgent.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Rollovers/SERV10_ConversionOfInterestType.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Rollovers/SERV11_Loan Amalgamation.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Rollovers/SERV12_LoanSplit.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/SecondaryTrading/TRPO02_SecondarySale.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/SecondaryTrading/TRPO15_EnablingFacilitiesForInclusionInaMassSale.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Servicing/SERV35_DealTerminations.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Servicing/SERV40_Breakfunding.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Syndication/SYND02_PrimaryAllocation.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Syndication/SYND04_TickingFeePayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Syndication/SYND05_UprontFeePayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/BusinessProcess_Keywords/Syndication/SYND06_Distribute Upfront Fee Payment.robot


### LIQ Resource Files - Custom Mapping ###
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_AccrualSharesAdjustment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_ActivityList.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_AdminFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_AdminFeeChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_AdminFeePayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Amendment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_ApplicationOfOriginationCosts_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_AvailabilityChange_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_BreakfundingFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Cashflow.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Circle_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_CommitmentFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Customer_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_ContactChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Deal_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_DealChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Decrease_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_EventFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Facility_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_FacilityChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_GuaranteeDrawdown_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_IncomingManualCashflow_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_InterestCapitalization_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_InterestPayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_IssuanceFeePayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Loan_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_LoanDrawdown_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_LoanRepricing_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_ManualCashflow_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_ManualFundsFlow_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_ManualGL_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_ManualShareAdjustment_Notbeook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_OutgoingManualCashflow_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_RemittanceInstructionChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_OutstandingChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_PortfolioSettledDiscountChange_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Portfolio_Transfer_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_PortfolioTradeDateDiscountChange_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_PricingChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_PrincipalPayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_RepaymentPaperClip_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_RolloverConversion_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_TransactionProcess.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_SBLCGuarantee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_ShareAdjustment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_TableMaintenance_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_TickingFeePayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_Tickler_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_TreasuryNavigation.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_TransactionProcess.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_UnscheduledCommitmentDecrease_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_UnscheduledCommitmentIncrease_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_UnscheduledPrincipalPayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_UpfrontFeeDistribution_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Custom_Mapping/BUS_UpfrontFeePayment_Notebook.robot

### LIQ Resource Files - Source Keywords ###
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/AccrualSharesAdjustment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/ActivityList.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/AdminFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/AdminFeeChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/AdminFeePayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Amendment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/ApplicationOfOriginationCost_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/AvailabilityChange_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/BatchAdministration_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/BreakfundingFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/BreakfundingFeePayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/BusinessEventOutput.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Cashflow.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Circle_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/CommitmentFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Customer_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/CustomerChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Deal_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/DealChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Decrease_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/GuaranteeDrawdown_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/EssenceGL_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/EventFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/EventFeePayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Fac_AddUnscheduled_CommitmentIncrease_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Facility_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/FacilityChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/FrontingCommitmentFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/IncomingManualCashflow_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/IndemnityFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/InterestCapitalization_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/InterestPayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/IssuanceFeePayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/LineFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Loan_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/LoanChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/LoanDrawdown_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/LoanRepricing_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/ManualCashflow_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/ManualGL_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/ManualFundsFlow_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/ManualShareAdjustment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Notices.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/OutgoingManualCashflow_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/OutstandingChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Paperclip_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/PortfolioSettledDiscountChange_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/PortfolioTradeDateDiscountChange_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Portfolio_Transfer_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/PricingChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/PrincipalPayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/RepaymentPaperClip_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/RemittanceInstructionChangeTransaction_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/RolloverConversion_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/SBLCGuarantee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/ScheduledCommitmentDecrease_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/ShareAdjustment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/TableMaintenance.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/Tickler_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/TickingFee_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/TransactionInProcess.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/TreasuryNavigation.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/UnscheduledCommitmentIncrease_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/UnscheduledPrincipalPayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/UnscheduledCommitmentDecrease_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/UpfrontFeePayment_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/UserAdministration_Notebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/Source_Keywords/UpfrontFeeDistribution_Notebook.robot


### CBA UAT Keywords ###
# ### UAT Deal 1 ###
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT01_DealTemplate/01CommitmentFeeNotebook.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT01_DealTemplate/01DealBorrower.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT01_DealTemplate/01DealChangeTransaction.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT01_DealTemplate/01DealNotebook.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT01_DealTemplate/01FacilityNotebook.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT01_DealTemplate/01FeePayment.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT01_DealTemplate/01Outstandings.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT01_DealTemplate/01Paperclip.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT01_DealTemplate/01Repricing.robot

# ### UAT Deal 2 ###
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT02_DealTemplate/02DealBorrower.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT02_DealTemplate/02DealNotebook.robot

### UAT Deal 3 ###
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03DealBorrower.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03CommitmentFeeNotebook.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03DealNotebook.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03Drawdown.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03ExtendFacility.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03FacilityNotebook.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03FeePayment.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03LCCollection.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03LCIssuance.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03LoadRates.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03LoanMerge.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03Paperclip.robot
# Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT03_DealTemplate/03Repricing.robot


### UAT Deal 4 ###
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT04_DealTemplate/04DealBorrower.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT04_DealTemplate/04DealNotebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT04_DealTemplate/04FacilityNotebook.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT04_DealTemplate/04Fees.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT04_DealTemplate/04Outstandings.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT04_DealTemplate/04Repayment.robot
Resource    ../ResourcesFiles/LoanIQ_Keywords/UAT_Keywords/CBA_UAT04_DealTemplate/04Repricing.robot