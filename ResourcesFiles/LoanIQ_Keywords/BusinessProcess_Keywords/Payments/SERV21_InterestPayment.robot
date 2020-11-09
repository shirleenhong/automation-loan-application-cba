*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***


*** Keywords ***
Initiate Interest Payment
   [Documentation]    This keyword will pay Interest Fees on a bilateral deal
   ...    @update: fmamaril    23APR2019    Apply standards for release cashflow
   ...    @update: bernchua    25JUN2019    Used generic keyword for navigatong Notebook Workflow
   ...    @update: amansuet    17JUN2020    - replaced navigation keywords that uses locators as inputs
   ...    @update: amansuet    18JUN2020    - updated Release a Cashflow
   ...    @update: amansuet    22JUN2020    - used generic keyword 'Release Cashflow Based on Remittance Instruction'
   ...    @update: makcamps    23OCT2020    - added condition for EU config for Currency and deleted Release Cashflow
   ...    @update: makcamps    04NOV2020    - added Generate Intent Notices for EU End to End script for Scenario 1
   [Arguments]    ${ExcelPath}   
   ###Navigate to Existing Loan###
   Open Existing Deal    &{ExcelPath}[Deal_Name]
   Navigate to Outstanding Select Window from Deal
   Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
   ${ScheduledActivityReport_Date}    Get Interest Actual Due Date on Loan Notebook
   # Write Data To Excel    SERV21_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${ScheduledActivityReport_Date}
   Close All Windows on LIQ 
   ${SystemDate}    Get System Date
   ${ScheduledActivity_FromDate}    Subtract Days to Date     ${SystemDate}    365
   ${ScheduledActivity_ThruDate}    Add Days to Date    ${SystemDate}    365
   Navigate to the Scheduled Activity Filter
   Open Scheduled Activity Report    ${ScheduledActivity_FromDate}    ${ScheduledActivity_ThruDate}    &{ExcelPath}[Deal_Name]
   
   ###Loan Notebook####
   Open Loan Notebook    &{ExcelPath}[ScheduledActivityReport_Date]    &{ExcelPath}[ScheduledActivityReport_ActivityType]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_Alias]
   ${CycleDue}    Compute Interest Payment Amount Per Cycle - Zero Cycle Due    &{ExcelPath}[CycleNumber]    ${SystemDate}
   Write Data To Excel    SERV21_InterestPayments    Payment_Amount    ${rowid}    ${CycleDue}

   ###Interest Payment Notebook####
   Initiate Loan Interest Payment   &{ExcelPath}[CycleNumber]    &{ExcelPath}[Pro_Rate]
   Input Effective Date and Requested Amount for Loan Interest Payment    ${SystemDate}    ${CycleDue}
    
   ###For Debugging###
   ###${CycleDue}    Read Data From Excel    SERV21_InterestPayments    Payment_Amount    ${rowid}    
    
   ##Cashflow Notebook - Create Cashflows###
   Navigate to Payment Workflow and Proceed With Transaction    Create Cashflows
   Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Remittance_Instruction]
   Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
   ##Get Transaction Amount for Cashflow###
   ${HostBankShare}    Run Keyword If   '&{ExcelPath}[Entity]'=='EU'    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
   ...    ELSE    Get Host Bank Cash in Cashflow
   ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
   ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${CycleDue}    &{ExcelPath}[HostBankSharePct]
    
   Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
   ###GL Entries###
   Navigate to GL Entries
   ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
   ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
   ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
   ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
   Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
   Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
   Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${CycleDue}
   
   ###Workflow Tab - Send to Approval###
   Send Interest Payment to Approval
   
   ###Loan IQ Desktop###
   Logout from Loan IQ
   Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
   
   ###Work in Process#####
   Open Interest Payment Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
   Approve Interest Payment
   ### Commented out for Correspondence Testing Generate Intent Notices for Payment    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Contact_Email]

   ##Loan IQ Desktop###
   Close All Windows on LIQ
   Logout from Loan IQ
   Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

   ###Interest Payment Notebook - Workflow Tab###  
   Select Item in Work in Process    Payments    Awaiting Release    Interest Payment     &{ExcelPath}[Facility_Name]

   # ##Intent Notices Generation
   Run Keyword If    '${ExcelPath}[Entity]'=='EU'    Generate Intent Notices of an Interest Payment    &{ExcelPath}[Borrower1_LegalName]    &{ExcelPath}[Contact_Email]    &{ExcelPath}[Borrower1_LegalName]    &{ExcelPath}[Notice_Status]
   Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Cashflow_DataType]    Payment
   Navigate to Payment Workflow and Proceed With Transaction    Release
    
   ##Facility Notebook####
   Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]   
   
   ####Outstanding Select####  
   Navigate to Outstanding Select Window
   
   ###Loan Notebook####
   Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]    
   Validate Interest Payment in Loan Accrual Tab    &{ExcelPath}[CycleNumber]    ${CycleDue}
   
   Close All Windows on LIQ
   Logout from Loan IQ
   Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
      
Initiate Repayment Paper Clip with Three Lenders - Interest and Principal
    [Arguments]    ${ExcelPath}
    
    Logout from Loan IQ
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Facility Notebook###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${GlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    ${GlobalFacAvailtoDrawAmount}    Get Current Facility Outstandings, Avail to Draw, Commitment Amount
    
    Write Data To Excel    SERV21_InterestPayments    GlobalFacCommitmentAmount    ${rowid}    ${GlobalFacCommitmentAmount}
    Write Data To Excel    SERV21_InterestPayments    GlobalFacOutstandingAmount    ${rowid}    ${GlobalFacOutstandingAmount}
    Write Data To Excel    SERV21_InterestPayments    GlobalFacAvailtoDrawAmount    ${rowid}    ${GlobalFacAvailtoDrawAmount}
    
    
    Close All Windows on LIQ
    ${SysDate}    Get System Date
    ${FromDate}    Subtract Days to Date    ${SysDate}    30
    ${ThruDate}    Add Days to Date    ${SysDate}    90
  	Write Data To Excel    SERV21_InterestPayments    ScheduledActivity_FromDate    ${rowid}    ${FromDate}
    Write Data To Excel    SERV21_InterestPayments    ScheduledActivity_ThruDate    ${rowid}    ${ThruDate}
    
    ###Work in Process####
    Navigate to the Scheduled Activity Filter
    Open Scheduled Activity Report    ${FromDate}    ${ThruDate}    &{ExcelPath}[Deal_Name]
    
    ###Loan Notebook####
    Open Loan Notebook    &{ExcelPath}[ScheduledActivityReport_Date]    &{ExcelPath}[ScheduledActivityReport_ActivityType]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_Alias]  
    ${OldHostBankGross}    ${OldHostBankNet}    Get Current Outstandings Host Bank Gross and Host Bank Net 
    Write Data To Excel    SERV21_InterestPayments    OldHostBankGross    ${rowid}    ${OldHostBankGross}
    Write Data To Excel    SERV21_InterestPayments    OldHostBankNet    ${rowid}    ${OldHostBankNet}
    
    ${ProjectedCycleDue}    Compute Interest Payment Amount Per Cycle    &{ExcelPath}[CycleNumber]
    Write Data To Excel    SERV21_InterestPayments    Computed_LoanIntProjectedCycleDue    ${rowid}    ${ProjectedCycleDue}
    ${Computed_LoanIntProjectedCycleDue}    Read Data From Excel    SERV21_InterestPayments    Computed_LoanIntProjectedCycleDue    ${rowid}
    
    ###Repayment Schedule####
    Navigate to Repayment Schedule from Loan Notebook
    
    ###Repayment Paper Clip Notebook####
    ${Int_RepaymentEffectiveDate}    ${RemainingPrincipal}    Initiate Interest Payment for Fixed Principal and Interest    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Loan_PricingOption]
    Write Data To Excel    SERV21_InterestPayments    Int_RepaymentEffectiveDate    ${rowid}    ${Int_RepaymentEffectiveDate}
    Write Data To Excel    SERV20_UnschedPrincipalPayments    Repayment_RemainingPrincipal    ${rowid}    ${RemainingPrincipal}
    
    ${Int_RepaymentEffectiveDate}    Read Data From Excel    SERV21_InterestPayments    Int_RepaymentEffectiveDate    ${rowid} 
    # Validate Interest Repayment Details    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_Alias]    ${Int_RepaymentEffectiveDate}    ${Computed_LoanIntProjectedCycleDue}
    Initiate Principal Payment for Fixed Principal and Interest    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Loan_PricingOption]
    ${Principal_RepaymentEffectiveDate}    Read Data From Excel    SERV21_InterestPayments    Principal_RepaymentEffectiveDate    ${rowid}
    ${Repayment_PrincipalDue}    Validate Principal Repayment Details    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_CalculatedFixedPayment]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_Alias]    ${Principal_RepaymentEffectiveDate}    ${Computed_LoanIntProjectedCycleDue}
    Write Data To Excel    SERV21_InterestPayments    Repayment_PrincipalAmount    ${rowid}    ${Repayment_PrincipalDue}
    ${Repayment_PrincipalAmount}    Read Data From Excel    SERV21_InterestPayments    Repayment_PrincipalAmount    ${rowid}
    
    ###Workflow Tab - Create Cashfows and GL Entries###
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Create Cashflows  
    ${ProjectedInterest}    Convert Number With Comma Separators    ${ProjectedCycleDue}
    ${Repayment_PrincipalDue}    Convert Number With Comma Separators    ${Repayment_PrincipalDue}
    ${ComputedLend1InterestAmount}    Compute Lender Share Transaction Amount    ${ProjectedInterest}    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend1Principal}    Compute Lender Share Transaction Amount    ${Repayment_PrincipalDue}    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2InterestAmount}    Compute Lender Share Transaction Amount    ${ProjectedInterest}    &{ExcelPath}[LenderSharePct2]
    ${ComputedLend2Principal}    Compute Lender Share Transaction Amount    ${Repayment_PrincipalDue}    &{ExcelPath}[LenderSharePct2]
    ${ComputedLend2InterestAmount}    Evaluate    ${ComputedLend2InterestAmount}+0.01    
    ${ComputedLend1InterestAmount}    Convert Number With Comma Separators    ${ComputedLend1InterestAmount}
    ${ComputedLend1Principal}    Convert Number With Comma Separators    ${ComputedLend1Principal}
    ${ComputedLend2InterestAmount}    Convert Number With Comma Separators    ${ComputedLend2InterestAmount}
    ${ComputedLend2Principal}    Convert Number With Comma Separators    ${ComputedLend2Principal}
    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]   
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]    ${ComputedLend1InterestAmount}    &{ExcelPath}[Loan_Currency]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]    ${ComputedLend1Principal}    &{ExcelPath}[Loan_Currency]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]    ${ComputedLend2InterestAmount}    &{ExcelPath}[Loan_Currency]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]    ${ComputedLend2Principal}    &{ExcelPath}[Loan_Currency]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    ${ComputedLend1InterestAmount}    
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    ${ComputedLend1Principal}
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    ${ComputedLend2InterestAmount}
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    ${ComputedLend2Principal}
        
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    ${ComputedLend1InterestAmount}
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_CalculatedFixedPayment]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_CalculatedFixedPayment]    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_CalculatedFixedPayment]    &{ExcelPath}[LenderSharePct2] 

    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Debit Amt
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    Debit Amt
    ${Lender2_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    Debit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Loan_RequestedAmount]
    Close GL and Cashflow Windows

    ###Workflow Tab - Send to Approval###
    Send Repayment Paper Clip to Approval
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
   
    ###Loan 
    ###Workflow Tab - Send to Approval###
    Send Repayment Paper Clip to Approval
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
   
    ###Work in Process - Approval###
    ${Loan_CalculatedFixedPayment}    Convert Number With Comma Separators    &{ExcelPath}[Loan_CalculatedFixedPayment]
    Select Item in Work in Process    Payments    Awaiting Approval    Repayment Paper Clip    ${Loan_CalculatedFixedPayment}
    Open Repayment Paper Clip Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    ${Loan_CalculatedFixedPayment}
    Approve Repayment Paper Clip
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Approval  
   
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Worflow Tab - Generate Intent Notices###
    #Open Repayment Paper Clip Notebook via WIP - Awaiting Generate Intent Notices    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingGenerateIntentNotices]    &{ExcelPath}[WIP_PaymentType]    ${Loan_CalculatedFixedPayment}
    Select Item in Work in Process    Payments    Awaiting Generate Intent Notices    Repayment Paper Clip    ${Loan_CalculatedFixedPayment}
    Navigate to Paper Clip Intent Notices Window
    # Verify Customer Notice Method    &{ExcelPath}[Borrower_LegalName]    &{ExcelPath}[Borrower_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    External Notice Method    &{ExcelPath}[Borrower_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Borrower_LegalName]    &{ExcelPath}[Borrower_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    Email    &{ExcelPath}[Borrower_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Lender1_LegalName]    &{ExcelPath}[Lender1_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    Email    &{ExcelPath}[Lender1_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Lender2_LegalName]    &{ExcelPath}[Lender2_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    External Notice Method    &{ExcelPath}[Lender2_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Lender2_LegalName]    &{ExcelPath}[Lender2_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    Email    &{ExcelPath}[Lender2_ContactEmail]
    mx LoanIQ click     ${LIQ_IntentNotice_Exit_Button}
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Workflow Tab - Paper Clip Payment###  
    Select Item in Work in Process    Payments    Awaiting Release Cashflows    Repayment Paper Clip    ${Loan_CalculatedFixedPayment}
    #Open Repayment Paper Clip Notebook via WIP - Awaiting Release    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingRelease]    &{ExcelPath}[WIP_PaymentType]    ${Loan_CalculatedFixedPayment} 
    ###Cashflow Notebook - Release Cashflows###
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Release Cashflows  
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]|${ComputedLend1InterestAmount}|${ComputedLend1Principal}|${ComputedLend2InterestAmount}|${ComputedLend2Principal}    release    int
    
    ###Cashflow Notebook - Complete Cashflows###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance3_Description]    &{ExcelPath}[Remittance3_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Release Cashflow    &{ExcelPath}[Lender2_ShortName]
    Release Repayment Paper Clip
    Close All Windows on LIQ
   
    ##Facility Notebook####
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name] 
    ${NewGlobalFacCommitmentAmount}    ${NewGlobalFacOutstandingAmount}    ${NewGlobalFacAvailtoDrawAmount}    Get Current Facility Outstandings, Avail to Draw, Commitment Amount 

    ####Outstanding Select####  
    Navigate to Outstanding Select Window
    
    ###Loan Notebook####
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    
    ${OldHostBankGross}    Read Data From Excel    SERV21_InterestPayments    OldHostBankGross    ${rowid}
    ${OldHostBankNet}    Read Data From Excel    SERV21_InterestPayments    OldHostBankNet    ${rowid}
    ${Cashflows_HostBankPrinTranAmount}    Read Data From Excel    SERV21_InterestPayments    Cashflows_HostBankPrinTranAmount    ${rowid}
    
    Validate if Outstanding Amount has decreased after Paper Clip - Syndicated    ${Repayment_PrincipalAmount}    ${OldHostBankGross}    ${OldHostBankNet}    ${Cashflows_HostBankPrinTranAmount}
    Validate Interest Payment in Loan Accrual Tab    &{ExcelPath}[CycleNumber]    ${Computed_LoanIntProjectedCycleDue}    
    Close All Windows on LIQ
    
    ###Loan Amount Vlaidation for TERM and REVOLVER Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name] 
    
    ${GlobalFacCommitmentAmount}    Read Data From Excel    SERV21_InterestPayments    GlobalFacCommitmentAmount    ${rowid}
    ${GlobalFacOutstandingAmount}    Read Data From Excel    SERV21_InterestPayments    GlobalFacOutstandingAmount    ${rowid}
    ${GlobalFacAvailtoDrawAmount}    Read Data From Excel    SERV21_InterestPayments    GlobalFacAvailtoDrawAmount    ${rowid}
    
    Run Keyword If    '&{ExcelPath}[Facility_Type]'=='Term'    Validate New Global Current Cmt, Outstandings, and Avail to Draw for Term Facility    ${GlobalFacCommitmentAmount}    ${NewGlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    ${NewGlobalFacOutstandingAmount}    
     ...    ${GlobalFacAvailtoDrawAmount}    ${NewGlobalFacAvailtoDrawAmount}    ${Repayment_PrincipalAmount}    
    Run Keyword If    '&{ExcelPath}[Facility_Type]'=='Revolver'    Validate New Global Current Cmt, Outstandings, and Avail to Draw for Revolver Facility    ${GlobalFacCommitmentAmount}    ${NewGlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    
    ...    ${NewGlobalFacOutstandingAmount}    ${GlobalFacAvailtoDrawAmount}    ${NewGlobalFacAvailtoDrawAmount}    
    Close All Windows on LIQ
   
Initiate Interest Payment with Two Lenders
    [Arguments]    ${ExcelPath}
   
    ###Facility Notebook###
    ${SystemDate}    Get System Date
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
   
    ####Outstanding Select####  
    Navigate to Outstanding Select Window
    
    ###Loan Notebook####
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
     
    ${Computed_LoanIntProjectedCycleDue}    Compute Interest Payment Amount Per Cycle    &{ExcelPath}[CycleNumber]
    ${Computed_LoanIntProjectedCycleDue}    Read Data From Excel    SERV21_InterestPayments    Computed_LoanIntProjectedCycleDue    ${rowid}
     
    # ###Interest Payment Notebook####
    Initiate Loan Interest Payment    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Pro_Rate]  

    ${Loan_InterestCycleDueDate}    Read Data From Excel    SERV21_InterestPayments    Loan_InterestCycleDueDate    ${rowid}
    ${Loan_InterestCycleStartDate}    Read Data From Excel    SERV21_InterestPayments    Loan_InterestCycleStartDate    ${rowid}
   
    Validate Loan Interest Payment Details    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Borrower]    &{ExcelPath}[Loan_Alias]    ${Loan_InterestCycleDueDate}    ${Loan_InterestCycleStartDate}
    Input Effective Date and Requested Amount for Loan Interest Payment    ${SystemDate}    ${Computed_LoanIntProjectedCycleDue}  

    ###Workflow Tab - Create Cashfows and GL Entries###
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Create Cashflows  
    ###Cashflow Notebook - Create Cashflows###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]

    ###Workflow Tab - Send to Approval###
    Send Interest Payment to Approval
   
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    &{ExcelPath}[ApproverUsername]    &{ExcelPath}[ApproverPassword]
   
    ###Work in Process - Approval###
    Open Interest Payment Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
    Approve Interest Payment
  
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    &{ExcelPath}[UserName_Original]    &{ExcelPath}[Password_Original]
   
    ##Worflow Tab - Generate Intent Notices###
    Open Interest Payment Notebook via WIP - Awaiting Generate Intent Notices    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingGenerateIntentNotices]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
    Navigate to Interest Payment Intent Notices Window
    Verify Customer Notice Method    &{ExcelPath}[Borrower_LegalName]    &{ExcelPath}[Borrower_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    Email    &{ExcelPath}[Borrower_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Lender2_LegalName]    &{ExcelPath}[Lender2_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    External Notice Method    &{ExcelPath}[Lender2_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Lender2_LegalName]    &{ExcelPath}[Lender2_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    Email    &{ExcelPath}[Lender2_ContactEmail]
    mx LoanIQ click     ${LIQ_IntentNotice_Exit_Button}
   
    ##Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    &{ExcelPath}[ApproverUsername]    &{ExcelPath}[ApproverPassword]
   
    ##Workflow Tab - Paper Clip Payment###  
    Open Interest Payment Notebook via WIP - Awaiting Release    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingRelease]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
    Navigate to Interest Payment Workflow Tab
    ${ReleaseCashflow_Status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Release Cashflows%s   
    # Run Keyword If    ${ReleaseCashflow_Status}==True    Run Keywords    Open Interest Payment Notebook via WIP - Awaiting Release Cashflow    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseCashflowsStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
    # ...    AND    Release Interest Payment Cashflows with Two Lenders    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Lender2_ShortName]s
    Release Payment
    Close All Windows on LIQ
   
    ##Facility Notebook####
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name] 

    ####Outstanding Select####  
    Navigate to Outstanding Select Window
    
    ###Loan Notebook Validation####
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Validate Loan Events Tab after Interest Payment
    Validate Interest Payment in Loan Accrual Tab - Paid Projected Cycle Due    &{ExcelPath}[CycleNumber]    ${Computed_LoanIntProjectedCycleDue}    
    Close All Windows on LIQ
    
Initiate Interest Payment with Three Lenders
    [Documentation]    This keyword will pay Interest Fees with three Lenders on a Comprehensive Reprcing for SYNDICATED deal using PRINCIPAL
    ...    @author: dfajardo

    [Arguments]    ${ExcelPath}
   
    ###Facility Notebook###
    ${SystemDate}    Get System Date
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
   
    ####Outstanding Select####  
    Navigate to Outstanding Select Window
    
    ###Loan Notebook####
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
     
    ${Computed_LoanIntProjectedCycleDue}    Compute Interest Payment Amount Per Cycle    &{ExcelPath}[CycleNumber]
    ${Computed_LoanIntProjectedCycleDue}    Read Data From Excel    SERV21_InterestPayments    Computed_LoanIntProjectedCycleDue    ${rowid}
     
    # ###Interest Payment Notebook####
    Initiate Loan Interest Payment    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Pro_Rate]  

    ${Loan_InterestCycleDueDate}    Read Data From Excel    SERV21_InterestPayments    Loan_InterestCycleDueDate    ${rowid}
    ${Loan_InterestCycleStartDate}    Read Data From Excel    SERV21_InterestPayments    Loan_InterestCycleStartDate    ${rowid}
   
    Validate Loan Interest Payment Details    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Borrower]    &{ExcelPath}[Loan_Alias]    ${Loan_InterestCycleDueDate}    ${Loan_InterestCycleStartDate}
    Input Effective Date and Requested Amount for Loan Interest Payment    ${SystemDate}    ${Computed_LoanIntProjectedCycleDue}  

    ###Workflow Tab - Create Cashfows and GL Entries###
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    &{ExcelPath}[Create_Cashflow]  
    ###Cashflow Notebook - Create Cashflows###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance2_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Verify if Status is set to Do It    &{ExcelPath}[Lender1_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender2_ShortName]
    
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]
    
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    ${ComputedLend1TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[LenderSharePct1]
    ${ComputedLend2TranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[LenderSharePct2] 
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${ComputedHBTranAmount}|${ComputedLend1TranAmount}|${ComputedLend2TranAmount}
 
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    ${CREDIT_AMT_LABEL}
    ${Lender1_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender1_ShortName]    ${CREDIT_AMT_LABEL}
    ${Lender2_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender2_ShortName]    ${CREDIT_AMT_LABEL}
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    ${DEBIT_AMT_LABEL}
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For:    ${DEBIT_AMT_LABEL}
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}|${Lend1TranAmount}|${Lend2TranAmount}    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}|${Lender2_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Computed_LoanIntProjectedCycleDue]
    
    ###Workflow Tab - Send to Approval###
    Send Interest Payment to Approval
   
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
   
    ###Work in Process - Approval###
    Open Interest Payment Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
    Approve Interest Payment
  
    # ##Worflow Tab - Generate Intent Notices###
    Navigate to Interest Payment Intent Notices Window
    Verify Customer Notice Method    &{ExcelPath}[Borrower_LegalName]    &{ExcelPath}[Borrower_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    CBA Email with PDF Attachment    &{ExcelPath}[Borrower_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Lender1_LegalName]    &{ExcelPath}[Lender1_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    Email    &{ExcelPath}[Lender1_ContactEmail]
    Verify Customer Notice Method    &{ExcelPath}[Lender2_LegalName]    &{ExcelPath}[Lender2_IntenNoticeContact]    &{ExcelPath}[IntentNoticeStatus]    &{ExcelPath}[UserName_Original]    CBA Email with PDF Attachment    &{ExcelPath}[Lender2_ContactEmail]
    Close All Windows on LIQ
   
    ##Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    Open Interest Payment Notebook via WIP - Awaiting Release    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseCashflowsStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
    
    ###Cashflow Notebook - Release Cashflows###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Cashflow_DataType]    Payment
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance1_Instruction]    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Cashflow_DataType]    Payment
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance2_Instruction]    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Cashflow_DataType]    Payment
    Release Payment

    
    ##Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ##Facility Notebook####
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name] 

    ####Outstanding Select####  
    Navigate to Outstanding Select Window

    
    ###Deal Notebook
    Search Loan    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Active]
    Open Existing Inactive Loan from a Facility    &{ExcelPath}[Loan_Alias]