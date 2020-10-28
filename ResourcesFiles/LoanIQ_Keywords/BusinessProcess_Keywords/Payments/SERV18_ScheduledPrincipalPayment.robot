*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***

*** Keywords ***
Manual Schedule Principal Payment
    [Documentation]    This keyword will pay Principal with Schedule
    ...    @update: fmamaril    23APR2019    Apply standards for release cashflow
    ...    @update: bernchua    25JUN2019    Updated condition logic during post validation of amounts
    ...    @update: ehugo       01JUN2020    - updated keyword 'Navigate Notebook Workflow' to 'Navigate to Payment Workflow and Proceed With Transaction'
    ...    @update: makcamps    26OCT2020    Updated get host bank cash in cashflow with EU currency and added release cashflow based on remittance instruction
    [Arguments]    ${ExcelPath}
    
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date     
    Navigate to Oustanding Facility Window    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${OutstandingBeforePayment}    ${AvailToDrawBeforePayment}    ${CurrentCmtBeforePayment}    Get Current Commitment, Outstanding and Available to Draw on Facility Before Payment    &{ExcelPath}[Borrower1_ShortName]          
    Search Loan    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[Loan_Alias]  
    Navigate from Loan to Repayment Schedule
    
    ###Repayment Schedule###
    ${ActualAmount}    Create Pending Transaction for Payment Schedule    &{ExcelPath}[Fee_Cycle]    ${SystemDate}
    Write Data To Excel    SERV18_Payments    ActualAmount    ${rowid}    ${ActualAmount}
    Navigate to Scheduled Principal Payment Cashflow Window
    
    ##Cashflow Notebook - Create Cashflows### 
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Run Keyword If   '&{ExcelPath}[Entity]'=='EU'    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
	...    ELSE    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${ActualAmount}    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${ActualAmount}
   
    Send Scheduled Principal Payment to Approval
    
    ###Loan IQ Desktop###  
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Search Loan    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    
    ###Loan Window###  
    Open Existing Loan    &{ExcelPath}[Loan_Alias]
    Navigate from Loan to Repayment Schedule
    
    ###Repayment Schedule###    
    Open Scheduled Principal Payment Notebook from Repayment Schedule    &{ExcelPath}[Fee_Cycle]
    
    ##Scheduled Principal Payment - Workflow### 
    Approve Scheduled Principal Payment
    
    ##Loan IQ Desktop###  
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    Select Item in Work in Process    Payments    Awaiting Release    Scheduled Loan Principal Payment     &{ExcelPath}[Deal_Name]    
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Cashflow_DataType]    Payment
    Release Scheduled Principal Payment
        
    ###Loan IQ Desktop###  
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Search Loan    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    
    ###Loan Window###  
    Open Existing Loan    &{ExcelPath}[Loan_Alias]   
    ${GlobalOriginal}    ${NewPrincipalAmount}    ${sGlobalOriginal}    ${sHostBankNet}    Validate if Outstanding Amount has decreased    ${ActualAmount}
    Validate Loan on Repayment Schedule    ${sGlobalOriginal}    ${sHostBankNet}    ${ActualAmount}    &{ExcelPath}[Fee_Cycle]
    Validate on Events Tab for Principal Payment
    Close All Windows on LIQ
    Navigate to Oustanding Facility Window    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${OutstandingAfterPayment}    ${AvailToDrawAfterPayment}    ${CurrentCmtAfterPayment}    Get Current Commitment, Outstanding and Available to Draw on Facility After Payment    &{ExcelPath}[Borrower1_ShortName]
    Run Keyword If    '&{ExcelPath}[Facility_Type]'=='Term' and '${rowid}'!='7'    Validate Principal Payment for Term Facility on Oustanding Window    ${ActualAmount}    ${CurrentCmtBeforePayment}    ${CurrentCmtAfterPayment}    ${OutstandingBeforePayment}    ${OutstandingAfterPayment}    ${AvailToDrawBeforePayment}    ${AvailToDrawAfterPayment}   
    ...    ELSE IF    '&{ExcelPath}[Facility_Type]'=='Term' and '${rowid}'!='1'    Validate Principal Payment for Term Facility on Oustanding Window    ${ActualAmount}    ${CurrentCmtBeforePayment}    ${CurrentCmtAfterPayment}    ${OutstandingBeforePayment}    ${OutstandingAfterPayment}    ${AvailToDrawBeforePayment}    ${AvailToDrawAfterPayment}
    ...    ELSE IF    '&{ExcelPath}[Facility_Type]'=='Revolver'    Validate Principal Payment for Revolver Facility on Oustanding Window    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[NewPrincipalAmount]    &{ExcelPath}[Facility_ProposedCmt]    ${GlobalOriginal}    ${ActualAmount}    ${OutstandingBeforePayment}    ${OutstandingAfterPayment}    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Manual Schedule Principal Payment - Bilateral Deal with Multiple Risk
    [Documentation]    This keyword will pay Principal with Schedule
    ...    @update: fmamaril    14OCT2019    Remove unused lines of code
    ...    @update: dahijara    10JUL2020    Updated hardcoded branch code for getting GL entries amount. Replaced 'Navigate Notebook Workflow' with 'Navigate to Payment Workflow and Proceed With Transaction'.
    [Arguments]    ${ExcelPath}
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date
    ${RemittanceDescription}    Read Data From Excel    ORIG03_Customer    RemittanceInstruction_RTGSDescriptionAUD   ${rowid}
    Navigate to Oustanding Facility Window    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility2_Name]
    ${OutstandingBeforePayment}    ${AvailToDrawBeforePayment}    ${CurrentCmtBeforePayment}    Get Current Commitment, Outstanding and Available to Draw on Facility Before Payment    &{ExcelPath}[Borrower1_ShortName]          
    Search Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility2_Name]
    Open Existing Loan    &{ExcelPath}[Loan_Alias]  
    ${OldHostBankGross}    ${OldHostBankNet}    Get Current Outstandings Host Bank Gross and Host Bank Net
    Navigate from Loan to Repayment Schedule
    
    ###Repayment Schedule Window>>Scheduled Principal Repayment Creation###
    ${ScheduledPrincipalPayment_Amount}    Create Pending Transaction for Payment Flex Schedule    &{ExcelPath}[Fee_Cycle]    ${SystemDate}   
    Write Data To Excel    SERV18_Payments    ScheduledPrincipalPayment_Amount    ${rowid}    ${ScheduledPrincipalPayment_Amount}
    
    ###Scheduled Principal Payment - Workflow>>Create Cashflows###
    Navigate to Payment Workflow and Proceed With Transaction    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    ${RemittanceDescription}    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]
    ${sHostBankShare}    Get Host Bank Cash in Cashflow
    ${sBorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${sComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${ScheduledPrincipalPayment_Amount}    100
    Compare UIAmount versus Computed Amount    ${sHostBankShare}    ${sComputedHBTranAmount}
    
    ###Workflow Tab - Create Cashfows>>GL Entries###
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[HostBank_GLAccount]   Credit Amt
    ${UITotalDebitAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Debit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Debit Amt        
    ${UITotalCreditAmt}    Run Keyword If    '&{ExcelPath}[BranchCode]' != 'None'    Get GL Entries Amount    ${SPACE}Total For: &{ExcelPath}[BranchCode]     Credit Amt
    ...    ELSE    Get GL Entries Amount    ${SPACE}Total For: CB001     Credit Amt

    Compare UIAmount versus Computed Amount    ${HostBank_Credit}    ${sComputedHBTranAmount}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Credit}    ${Borrower_Debit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ScheduledPrincipalPayment_Amount}
    
    ##Workflow Tab - Send Payment to Approval###
    Navigate to Payment Workflow and Proceed With Transaction    Send to Approval
    
    ##Loan IQ Desktop###  
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Search Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility2_Name]
    
    ###Loan Window###  
    Open Existing Loan    &{ExcelPath}[Loan_Alias]
    Navigate from Loan to Repayment Schedule
    
    ##Repayment Schedule###    
    Open Scheduled Principal Payment Notebook from Repayment Flex Schedule    &{ExcelPath}[Fee_Cycle]
    
    ###Scheduled Principal Payment - Workflow>>Approve Payment### 
    Navigate to Payment Workflow and Proceed With Transaction    Approval

    ###Loan IQ Desktop###  
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Search Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility2_Name]
    
    ###Loan Window###  
    Open Existing Loan    &{ExcelPath}[Loan_Alias]
    Navigate from Loan to Repayment Schedule
    
    ##Repayment Schedule###    
    Open Scheduled Principal Payment Notebook from Repayment Flex Schedule    &{ExcelPath}[Fee_Cycle]
    
    ###Release Payment - Workflow Tab####
    Navigate to Payment Workflow and Proceed With Transaction    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower1_ShortName]    release    
    Close Selected Windows for Payment Release
    Release Scheduled Principal Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Search Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility2_Name]
    
    ###Loan Window###  
    Open Existing Loan    &{ExcelPath}[Loan_Alias]
    ${sGlobalOriginal}    ${sHostBankNet}    Validate if Outstanding Amount has decreased after Principal Payment    ${OldHostBankGross}    ${ScheduledPrincipalPayment_Amount}  
    ${sGlobalOriginal}    Convert Number With Comma Separators    ${sGlobalOriginal}
    ${sHostBankNet}    Convert Number With Comma Separators    ${sHostBankNet}     
    Validate Loan on Repayment Schedule    ${sGlobalOriginal}    ${sHostBankNet}   ${ScheduledPrincipalPayment_Amount}    &{ExcelPath}[Fee_Cycle]
    Validate on Events Tab for Principal Payment
    Close All Windows on LIQ
    
    ###LoanIQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Amount Validation for the Term Facility###
    Navigate to Oustanding Facility Window    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility2_Name]
    ${OutstandingAfterPayment}    ${AvailToDrawAfterPayment}    ${CurrentCmtAfterPayment}    Get Current Commitment, Outstanding and Available to Draw on Facility After Payment    &{ExcelPath}[Borrower1_ShortName]
    Run Keyword If    '&{ExcelPath}[Facility_Type]'=='Term'    Validate Principal Payment for Term Facility on Oustanding Window    ${ScheduledPrincipalPayment_Amount}    ${CurrentCmtBeforePayment}    ${CurrentCmtAfterPayment}    ${OutstandingBeforePayment}    ${OutstandingAfterPayment}    ${AvailToDrawBeforePayment}    ${AvailToDrawAfterPayment}
    Run Keyword If    '&{ExcelPath}[Facility_Type]'=='Revolver'    Validate Principal Payment for Revolver Facility on Oustanding Window    ${ScheduledPrincipalPayment_Amount}    ${CurrentCmtBeforePayment}    ${CurrentCmtAfterPayment}    ${OutstandingBeforePayment}    ${OutstandingAfterPayment}    ${AvailToDrawBeforePayment}    ${AvailToDrawAfterPayment}
    Close All Windows on LIQ

Initiate Fee On Lender Shares Payment
    [Documentation]    This high-level keyword will cater the initiation of Fee on Lender Shares Payment
    ...    @author: 
    ...    @update: fmamaril    29APR2019    Conform with Coding Standards
    ...    @update: clanding    21JUL2020    Added writing of ${SystemDate} to IssuanceFeePayment_EffectiveDate for SERV18_FeeOnLenderSharesPayment
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    ${SystemDate}    Get System Date
    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    IssuanceFeePayment_EffectiveDate    ${rowid}    ${SystemDate}    

    Verify if Standby Letters of Credit Exist    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    
    ###Letter of Credit Window###    
    Navigate Existing Standby Letters of Credit    &{ExcelPath}[SBLC_Alias]
        
    ###Cycles for Bank Guarantee Window###    
    ${ComputedCycleDue}    Compute SBLC Issuance Fee Amount Per Cycle    &{ExcelPath}[CycleNumber]    ${SystemDate}
    Write Data To Excel    SERV18_FeeOnLenderSharesPayment    Computed_ProjectedCycleDue    &{ExcelPath}[rowid]    ${ComputedCycleDue}
    Write Data To Excel    SERV24_CreateCashflow    Computed_ProjectedCycleDue    &{ExcelPath}[rowid]    ${ComputedCycleDue}
    
    ###SBLC Guarantee Window###
    Navigate To Fees On Lender Shares
    Initiate Issuance Fee Payment    &{ExcelPath}[SBLC_Alias]    ${SystemDate}
    ...    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    ${ComputedCycleDue}
    
Workflow Navigation For Fee On Lender Shares Payment
    [Documentation]    This high-level keyword will cater the workflow navigation of Fee on Lender Shares Payment
    ...    @author: 
    ...    @update: fmamaril    29APR2019    Conform with Coding Standards
    ...    @update: ehugo    10OCT2019    Added 'release' parameter value to Release Cashflow
    ...    @update: ehugo    02JUN2020    - updated keyword 'Navigate Notebook Workflow' to 'Navigate to Payment Workflow and Proceed With Transaction'
    [Arguments]    ${ExcelPath}

    ###Bank Guarantee - Workflow Tab###
    Send Issuance Fee Payment to Approval
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    #Work In Process Window###
    Select Item in Work in Process    Payments    Awaiting Approval    Issuance Fee Payment     &{ExcelPath}[Facility_Name]
    
    ###Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve Issuance Fee Payment for Lender Share
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    ###Transactions in Process###
    Select Item in Work in Process    Payments    Release Cashflows    Issuance Fee Payment     &{ExcelPath}[Facility_Name]
    Navigate to Payment Workflow and Proceed With Transaction    Release Cashflows    
    Release Cashflow    &{ExcelPath}[Borrower1_ShortName]    release   
    Release Issuance Fee Payment for Lender Share

    ###Loan IQ Desktop###    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Principal Payment for Comprehensive Deal
    [Arguments]    ${ExcelPath}
    ### <update> 16Dec18 - bernchua : Scenario 8 integration. GEt data from Excel of previous transactions / test cases.
    ${Lender1}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender    &{ExcelPath}[rowid]
    ${Lender2}    Read Data From Excel    TRP002_SecondarySale    Buyer_Lender_2    &{ExcelPath}[rowid]
    ${HostBank}    Read Data From Excel    TRP002_SecondarySale    Seller_LegalEntity    &{ExcelPath}[rowid]
    
    ###Get Original Data Before the Payment Transaction###
    ${SystemDate}    Get System Date
    Write Data To Excel    SERV18_Payments    PrincipalPayment_EffectiveDate    ${rowid}    ${SystemDate}
    
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]     
    
    ${Orig_FacilityProposedcmt}    ${Orig_FacilityClosingCmt}    ${Orig_FacilityCurrentCmt}    ${Orig_FacilityOutstandings}    ${Orig_FacilityAvailableToDraw}    Get Original Data on Global Facility Amounts Section      
    Write Data To Excel    SERV18_Payments    Orig_FacilityProposedcmt    ${rowid}    ${Orig_FacilityProposedcmt}
    Write Data To Excel    SERV18_Payments    Orig_FacilityClosingCmt    ${rowid}    ${Orig_FacilityClosingCmt}
    Write Data To Excel    SERV18_Payments    Orig_FacilityCurrentCmt    ${rowid}    ${Orig_FacilityCurrentCmt}
    Write Data To Excel    SERV18_Payments    Orig_FacilityOutstandings    ${rowid}    ${Orig_FacilityOutstandings}
    Write Data To Excel    SERV18_Payments    Orig_FacilityAvailableToDraw    ${rowid}    ${Orig_FacilityAvailableToDraw}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ### <update> 16Dec18 - bernchua : Scenario 8 integration. Get borrower/lenders remittance instruction description via deal notebook.
    ${Borrower_RIDescription}    Get Deal Borrower Remittance Instruction Description    &{ExcelPath}[Borrower_Name]    &{ExcelPath}[Remittance_Instruction]
    ${Lender1_RIDescription}    Get Customer Lender Remittance Instruction Desc Via Lender Shares In Deal Notebook    ${Lender1}    &{ExcelPath}[Remittance_Instruction]
    ${Lender2_RIDescription}    Get Customer Lender Remittance Instruction Desc Via Lender Shares In Deal Notebook    ${Lender2}    &{ExcelPath}[Remittance_Instruction]
    
    Search Loan    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[Loan_Alias]
    
    
    ${Orig_LoanGlobalOriginal}    ${Orig_LoanGlobalCurrent}    ${Orig_LoanHostBankGross}    ${Orig_LoanHostBankNet}    Get Original Data on Loan Amounts Section  
    Write Data To Excel    SERV18_Payments    Orig_LoanGlobalOriginal    ${rowid}    ${Orig_LoanGlobalOriginal}
    Write Data To Excel    SERV18_Payments    Orig_LoanGlobalCurrent    ${rowid}    ${Orig_LoanGlobalCurrent}
    Write Data To Excel    SERV18_Payments    Orig_LoanHostBankGross    ${rowid}    ${Orig_LoanHostBankGross}
    Write Data To Excel    SERV18_Payments    Orig_LoanHostBankNet    ${rowid}    ${Orig_LoanHostBankNet}
    
    ### Step 2-3: Navigate to Principal Payment###
    Navigate to Principal Payment
    
    
    ###Step 4: Input data on fields under General Tab###
    ${PrincipalPayment_EffectiveDate}    Read Data From Excel    SERV18_Payments    PrincipalPayment_EffectiveDate    ${rowid}
    Populate Principal Payment General Tab    &{ExcelPath}[PrincipalPayment_RequestedAmount]    ${PrincipalPayment_EffectiveDate}    &{ExcelPath}[Reason]
    
    ### <update> 16Dec18 - bernchua : Scenario 8 integration. Compute for the lender share percetanges.
    ${HostBankShare}    Compute For Lender Share Percentage    ${HostBank}    &{ExcelPath}[PrincipalPayment_RequestedAmount]
    ${LenderShare1}    Compute For Lender Share Percentage    ${Lender1}    &{ExcelPath}[PrincipalPayment_RequestedAmount]
    ${LenderShare2}    Compute For Lender Share Percentage    ${Lender2}    &{ExcelPath}[PrincipalPayment_RequestedAmount]
    
    ###Step 5-6: Principal Payment - Workflow Tab Create Cashflow Item###
    ###Commented first as this will still be updated for Scenario 8###
    # Navigate to Payment Cashflow Window
    # Validate Incomplete Cash and Host Bank Cash Amount    &{ExcelPath}[PrincipalPayment_RequestedAmount]    ${LenderShare1}    ${LenderShare2}    ${HostBankShare}
    # Validate the Tran Amount of Borrower and Lenders    &{ExcelPath}[PrincipalPayment_RequestedAmount]    &{ExcelPath}[Borrower_Name]    ${Lender1}    ${LenderShare1}    ${Lender2}    ${LenderShare2} 
    # Add Remittance Instruction in Cashflow - Payment    &{ExcelPath}[Borrower_Name]    ${Lender1}    ${Lender2}    ${Borrower_RIDescription}    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance2_Description]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Status]
    
    ##Step 7-8: Principal Payment - Workflow Tab Generate Intent Notice Item###
    Generate Intent Notices on Principal Payment
    
    ##Step 9: Principal Payment - Workflow Tab Send to Approval Item###
    Send Principal Payment to Approval
    Logout from Loan IQ
    
    ###Step 10: Principal Payment - Workflow Tab Approval Item (SUPERVISOR)###
    Login to Loan IQ    &{ExcelPath}[ApproverUsername]    &{ExcelPath}[ApproverPassword]
    Select Item in Work in Process    Payments   Awaiting Approval    Loan Principal Prepayment    &{ExcelPath}[Loan_Alias]
    Approve Principal Payment
    Logout from Loan IQ
    
    ###Step 11: Principal Payment - Workflow Tab Release Item (MANAGER)###
    Login to Loan IQ    &{ExcelPath}[ApproverUsername2]    &{ExcelPath}[ApproverPassword2]
    Select Item in Work in Process    Payments   Awaiting Release    Loan Principal Prepayment    &{ExcelPath}[Loan_Alias]
    Release Principal Payment    
     
    ##Step 12: Validation on Principal Payment Notebook (MANAGER)###
    Validation on Principal Payment Notebook - Events Tab 
    ${Computed_CreditAmt1}    ${Computed_CreditAmt2}    ${Computed_CreditAmt3}    Validation on Principal Payment Notebook - GL Entries Window    &{ExcelPath}[PrincipalPayment_RequestedAmount]    &{ExcelPath}[Borrower_Name]    ${Lender1}    ${LenderShare1}    ${Lender2}    ${LenderShare2}    ${HostBankShare}
    Validation on Principal Payment Notebook - Lender Shares Window    ${HostBank}    ${Computed_CreditAmt3}    ${Lender1}    ${Computed_CreditAmt1}    ${Lender2}    ${Computed_CreditAmt2}    &{ExcelPath}[PrincipalPayment_RequestedAmount] 
    
    ###Step 13: Validation on Loan Notebook (MANAGER)###
    ${Orig_LoanGlobalOriginal}    Read Data From Excel    SERV18_Payments    Orig_LoanGlobalOriginal    ${rowid}    
    ${Orig_LoanGlobalCurrent}    Read Data From Excel    SERV18_Payments    Orig_LoanGlobalCurrent    ${rowid}    
    ${Orig_LoanHostBankGross}    Read Data From Excel    SERV18_Payments    Orig_LoanHostBankGross    ${rowid}    
    ${Orig_LoanHostBankNet}    Read Data From Excel    SERV18_Payments    Orig_LoanHostBankNet    ${rowid}    
    
    Get Updated Data on Loan Amounts Section after Principal Payment     ${Orig_LoanGlobalOriginal}    ${Orig_LoanGlobalCurrent}    &{ExcelPath}[PrincipalPayment_RequestedAmount]    ${Orig_LoanHostBankGross}    ${Computed_CreditAmt3}    ${Orig_LoanHostBankNet} 
    
    ###Step 14: Validation on Facility Notebook (MANAGER)###
    ${Orig_FacilityProposedcmt}    Read Data From Excel    SERV18_Payments    Orig_FacilityProposedcmt    ${rowid}    
    ${Orig_FacilityClosingCmt}    Read Data From Excel    SERV18_Payments    Orig_FacilityClosingCmt    ${rowid}    
    ${Orig_FacilityCurrentCmt}    Read Data From Excel    SERV18_Payments    Orig_FacilityCurrentCmt    ${rowid}    
    ${Orig_FacilityOutstandings}    Read Data From Excel    SERV18_Payments    Orig_FacilityOutstandings    ${rowid}    
    ${Orig_FacilityAvailableToDraw}    Read Data From Excel    SERV18_Payments    Orig_FacilityAvailableToDraw    ${rowid}    
    
    Get Updated Data on Global Facility Amounts Section after Principal Payment    ${Orig_FacilityProposedcmt}    ${Orig_FacilityClosingCmt}    ${Orig_FacilityCurrentCmt}    &{ExcelPath}[PrincipalPayment_RequestedAmount]    ${Orig_FacilityOutstandings}    ${Orig_FacilityAvailableToDraw} 
    Validate Facility Events Tab after Payment Transaction    &{ExcelPath}[PrincipalPayment_RequestedAmount]
