*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Initiate Repayment Paper Clip for Bilateral Deal
    [Documentation]
    ...    @update: dahijara    06JUL2020    - Updated keywords tab(4 spaces). Updated code for getting GL entries amounts.
    [Arguments]    ${ExcelPath}

    ${Borrower1_RTGSRemittanceDescription}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD   1    
    ###Facility Notebook####
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility2_Name]
    ${GlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    ${GlobalFacAvailtoDrawAmount}    Get Current Facility Outstandings, Avail to Draw, Commitment Amount  
    Navigate to Outstanding Select Window
    
    ###Loan Notebook####
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility2_Name]    &{ExcelPath}[Loan_Alias]   
    ${sComputed_LoanIntDue}    Compute Interest Payment Amount Per Cycle    &{ExcelPath}[CycleNumber]
    Write Data To Excel    SERV23_LoanPaperClip    Computed_LoanIntDue    ${rowid}    ${sComputed_LoanIntDue}
    ${sComputed_LoanIntDue}    Read Data From Excel    SERV23_LoanPaperClip    Computed_LoanIntDue    ${rowid}
    Navigate to Repayment Schedule from Loan Notebook
    
    ##Repayment Paper Clip Notebbok####
    ${sPaymentDueDate}    Initiate Paper Clip Payment and Return Payment Due Date    &{ExcelPath}[CycleNumber]
    Input Paper Clip Details    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Loan_PricingOption]
    Add Event Fee for Paper Clip Transaction    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Facility2_Name]    &{ExcelPath}[Fee_RequestedAmount]    &{ExcelPath}[Fee_FeeType]
    ${sComputed_PrincipalAmount}    Compute Principal Payment Amount    ${sComputed_LoanIntDue}    &{ExcelPath}[Repayment_FirstPaymentAmount]
    ${sTotalRepaymentAmount}    Validate Repayment Paper Clip Transaction Details    ${sComputed_LoanIntDue}    ${sComputed_PrincipalAmount}    &{ExcelPath}[Fee_RequestedAmount]    &{ExcelPath}[Loan_PricingOption]
    ${sTaxedFeeAmt}    ${sVATAmt}    Evaluate Fee Payment Amount with VAT Inclusion    &{ExcelPath}[Fee_RequestedAmount]    
    ${sTaxedFeeAmt}    Convert Number With Comma Separators    &{ExcelPath}[Fee_RequestedAmount]
    ${sComputed_PrincipalAmount}    Convert Number With Comma Separators    ${sComputed_PrincipalAmount}
    ${sComputed_LoanIntDue}    Convert Number With Comma Separators    ${sComputed_LoanIntDue}
   
    ###Workflow Tab - Create Cashfows###
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Create Cashflows 
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    ${Borrower1_RTGSRemittanceDescription}    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    ${sTaxedFeeAmt}    &{ExcelPath}[Loan_Currency]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    ${Borrower1_RTGSRemittanceDescription}    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    ${sComputed_PrincipalAmount}    &{ExcelPath}[Loan_Currency]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    ${Borrower1_RTGSRemittanceDescription}    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    ${sComputed_LoanIntDue}    &{ExcelPath}[Loan_Currency]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    ${sTaxedFeeAmt}      
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    ${sComputed_PrincipalAmount}
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    ${sComputed_LoanIntDue}
    
    ###Workflow Tab - Create Cashfows>>GL Entries###
    Navigate to GL Entries
    Verify GL Entries Amount    ${sTaxedFeeAmt}    Debit Amt    &{ExcelPath}[Borrower1_ShortName]    Customer/Portfolio
    Verify GL Entries Amount    ${sComputed_PrincipalAmount}    Debit Amt    &{ExcelPath}[Borrower1_ShortName]    Customer/Portfolio
    Verify GL Entries Amount    ${sComputed_LoanIntDue}    Debit Amt    &{ExcelPath}[Borrower1_ShortName]    Customer/Portfolio
    Verify GL Entries Amount    ${sVATAmt}    Credit Amt    &{ExcelPath}[Borrower1_ShortName]    Customer/Portfolio
    Verify GL Entries Amount    &{ExcelPath}[Fee_RequestedAmount]    Credit Amt    &{ExcelPath}[Lender1_Portfolio]    Customer/Portfolio    FEESSYAGPNL
    Verify GL Entries Amount    ${sComputed_PrincipalAmount}    Credit Amt    &{ExcelPath}[Lender1_Portfolio]    Customer/Portfolio    LOANPRNEFIX
    Verify GL Entries Amount    ${sComputed_LoanIntDue}    Credit Amt    &{ExcelPath}[Lender1_Portfolio]    Customer/Portfolio    LOANINTEFIX
    ${UITotalCreditAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Credit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Credit Amt
    ${UITotalDebitAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Debit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Debit Amt   
   
    ${sComputed_PrincipalAmount}    Remove Comma and Convert to Number    ${sComputed_PrincipalAmount}
    ${sComputed_LoanIntDue}    Remove Comma and Convert to Number    ${sComputed_LoanIntDue}
    ${sTaxedFeeAmt}    Remove Comma and Convert to Number    ${sTaxedFeeAmt}
    ${sTotalPaperClipAmt}    Compute Paper Clip Total Amount with VAT Inclusion for Fee    ${sComputed_PrincipalAmount}    ${sComputed_LoanIntDue}    ${sTaxedFeeAmt}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${sTotalPaperClipAmt}
  
    ###Workflow Tab - Send to Approval###
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Send to Approval
   
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
   
    ###Work in Process - Approval/Generate Intent Notices#####
    ${sTotalRepaymentAmount}    Convert Number With Comma Separators    ${sTotalRepaymentAmount}
    Navigate Transaction in WIP    Payments    Awaiting Approval    Repayment Paper Clip    ${sTotalRepaymentAmount}
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Approval
    Close All Windows on LIQ

    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    ###Paper Clip Payment - Workflow Tab###
    ${sTaxedFeeAmt}    Convert Number With Comma Separators    ${sTaxedFeeAmt}
    ${sComputed_PrincipalAmount}    Convert Number With Comma Separators    ${sComputed_PrincipalAmount}
    ${sComputed_LoanIntDue}    Convert Number With Comma Separators    ${sComputed_LoanIntDue}
    Navigate Transaction in WIP    Payments    Awaiting Release Cashflows    Repayment Paper Clip    ${sTotalRepaymentAmount}
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Release Cashflows
    Release Cashflow    ${sTaxedFeeAmt}|${sComputed_LoanIntDue}|${sComputed_PrincipalAmount}    default    int 
    Navigate Notebook Workflow    ${LIQ_Repayment_Window}    ${LIQ_Repayment_Tab}    ${LIQ_Repayment_WorkflowItems}    Release
    
    ###Facility Notebook###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility2_Name]  
    ${NewGlobalFacCommitmentAmount}    ${NewGlobalFacOutstandingAmount}    ${NewGlobalFacAvailtoDrawAmount}    Get Current Facility Outstandings, Avail to Draw, Commitment Amount
    Navigate to Outstanding Select Window
   
    ###Loan Notebook###
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility2_Name]    &{ExcelPath}[Loan_Alias]
    Validate if Outstanding Amount has decreased after Paper Clip - Bilateral    ${sComputed_PrincipalAmount}
    Validate Interest Payment in Loan Accrual Tab    &{ExcelPath}[CycleNumber]    ${sComputed_LoanIntDue}    
    Validate Interest and Principal Payments on Loan Events Tab    ${sComputed_LoanIntDue}    ${sComputed_PrincipalAmount}    ${sPaymentDueDate}
    Navigate to Scheduled Interest Payment Notebook from Loan Notebook
    Validate Fee, Interest and Principal Payments on Repayment    &{ExcelPath}[Fee_RequestedAmount]    &{ExcelPath}[Loan_Currency]    &{ExcelPath}[Loan_PricingOption]
    Close All Windows on LIQ
   
    ###Loan Amount Vlaidation for TERM an REVOLVER Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility2_Name] 
    Run Keyword If    '&{ExcelPath}[Facility_Type]'=='Term'    Validate New Global Current Cmt, Outstandings, and Avail to Draw for Term Facility    ${GlobalFacCommitmentAmount}    ${NewGlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    ${NewGlobalFacOutstandingAmount}    
    ...    ${GlobalFacAvailtoDrawAmount}    ${NewGlobalFacAvailtoDrawAmount}    ${sComputed_PrincipalAmount}    
    Run Keyword If    '&{ExcelPath}[Facility_Type]'=='Revolver'    Validate New Global Current Cmt, Outstandings, and Avail to Draw for Revolver Facility    ${GlobalFacCommitmentAmount}    ${NewGlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    
    ...    ${NewGlobalFacOutstandingAmount}    ${GlobalFacAvailtoDrawAmount}    ${NewGlobalFacAvailtoDrawAmount}    
    Close All Windows on LIQ
   

Create Paperclip Transaction including SBLC and Facing Fee
    [Documentation]   This keyword will creae Paperclip Transaction including SBLC and Facing Fee
    ...    @author: ritragel
    [Arguments]    ${ExcelPath}
    
    ###Deal Notebook###
    Search for Deal    &{ExcelPath}[Deal_Name]
    
    ###Paperclip Notebook###
    ${SysDate}    Get System Date
    Select Menu Item    ${LIQ_DealNotebook_Window}    Payments    Paper Clip Transaction
    Add Transaction to Pending Paperclip    ${SysDate}    Repayment  
    Select Outstanding Item    &{ExcelPath}[SBLC_Alias]
    Add Transaction Type    &{ExcelPath}[SBLC_Transaction_Type]
    Select Cycle for Payment    &{ExcelPath}[SBLC_CycleNumber]    &{ExcelPath}[SBLC_ProrateWith]
    
    ###Add Event Fee###
    Add Freeform Event Fee    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Requested_Amount]    &{ExcelPath}[Fee_Type]
    
    ###Validations###
    Verify New Transactions    &{ExcelPath}[SBLC_Alias]    &{ExcelPath}[Fee_Type]
    ${SBLC_Amount}    Read Data From Excel    SERV23_PaperclipTransaction    SBLC_Amount    ${rowid}
    ${TotalBorrowerPayment}    Add SBLC and Fee Amount    ${SBLC_Amount}    &{ExcelPath}[Fee_Requested_Amount]

    ###Cashflows for Paperclip###
    Navigate to Create Cashflow for Paperclip
    Add Remittance Instuctions for Customer    ${SBLC_Amount}    &{ExcelPath}[Fee_Requested_Amount]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[LenderSharePct1]
    ...    &{ExcelPath}[LenderSharePct2]    &{ExcelPath}[HostBankSharePct]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]
    Get Transaction Amount and Validate GL Entries - Paperclip - Scenario 2    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[LenderSharePct1]
    ...    &{ExcelPath}[LenderSharePct2]    &{ExcelPath}[HostBankSharePct]    &{ExcelPath}[Host_Bank]    ${TotalBorrowerPayment}    &{ExcelPath}[SBLC_Amount]    &{ExcelPath}[Fee_Requested_Amount]
    
    ###Approval###
    Send Paperclip Payment for Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Approval    Paper Clip    &{ExcelPath}[Deal_Name]
    Approve Paperclip
    
    ###Release Cashflows###
    Release Cashflows for Paperclip    &{ExcelPath}[SBLC_Amount]    &{ExcelPath}[Fee_Requested_Amount]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[LenderSharePct1]
    ...    &{ExcelPath}[LenderSharePct2]    &{ExcelPath}[HostBankSharePct]
    
    ###Generate Intent Notice Validation####
    Generate Intent Notices for Paper Clip    &{ExcelPath}[Customer_Legal_Name]    &{ExcelPath}[NoticeStatus]
    
    ###Release Paperclip Transaction###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Paper Clip    &{ExcelPath}[Deal_Name]
    Release Paperclip Transaction
    Close All Windows on LIQ
