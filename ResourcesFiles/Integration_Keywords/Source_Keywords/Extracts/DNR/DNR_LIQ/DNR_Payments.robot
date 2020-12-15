*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Pay Commitment Fee Amount for DNR
    [Documentation]    This keyword will pay Commitment Fee Amount on a deal
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}   
     
    ###Re-login to reset date###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ##Return to Scheduled Activity Fiter###
    ${SystemDate}    Get System Date
    Set Global Variable    ${SystemDate}
       
    Navigate to Scheduled Activity Filter

    ###Scheduled Activity Filter###
    Set Scheduled Activity Filter    &{ExcelPath}[ScheduleActivity_FromDate]    &{ExcelPath}[ScheduledActivity_ThruDate]    &{ExcelPath}[ScheduledActivity_Department]    &{ExcelPath}[ScheduledActivity_Branch]    &{ExcelPath}[Deal_Name]

    ###Scheduled Activity Report Window###
    Select Fee Due    &{ExcelPath}[ScheduledActivityReport_FeeType]    &{ExcelPath}[ScheduledActivityReport_Date]    &{ExcelPath}[Facility_Name]
    
    ###Cycles for Commitment Fee###
    Select Cycle Fee Payment
    
    ###Ongoing Fee Payment Notebook - General Tab### 
    Enter Effective Date for Ongoing Fee Payment    ${SystemDate}    &{ExcelPath}[RequestedAmount]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate to Cashflow - Ongoing Fee
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow    &{ExcelPath}[Loan_Currency]
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[RequestedAmount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[RequestedAmount]
    Send Ongoing Fee Payment to Approval
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    #Work In Process Window###
    Select Item in Work in Process    Payments    Awaiting Approval    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]

    ###Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    ###Generation of Intent Notice is skipped - Customer Notice Method must be updated###
    Select Item in Work in Process    Payments    Release    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]    
    Navigate to Payment Workflow and Proceed With Transaction    Release
    Release Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ###Deal Notebook - Summary Tab### 
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type]
    
    ###Commitment Fee Notebook - Acrual Tab###   
    Validate Details on Acrual Tab    &{ExcelPath}[RequestedAmount]    &{ExcelPath}[CycleNumber]
    Validate release of Ongoing Fee Payment
    Validate GL Entries for Ongoing Fee Payment - Bilateral Deal    &{ExcelPath}[Host_Bank]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[RequestedAmount]
    
    ###Get specific Fee Payment Released data for Reversal- MTAM05B##        
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Unscheduled Principal Payment - No Schedule for DNR
    [Documentation]    This keyword will pay Principal without Schedule
    ...    @author: clanding    01DEC2020    - initial create
    ...    @update: makcamps    11DEC2020    - added re-login to refresh system date
    [Arguments]    ${ExcelPath}
    
    ### LIQ Desktop ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date
    Write Data To Excel    SC1_UnscheduledPayments    PrincipalPayment_EffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}  
    Navigate to Oustanding Facility Window    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${OutstandingBeforePayment}    ${AvailToDrawBeforePayment}    ${CurrentCmtBeforePayment}    Get Current Commitment, Outstanding and Available to Draw on Facility Before Payment    &{ExcelPath}[Borrower1_ShortName]          
    Search Loan    &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[Loan_Alias]  
    
    Navigate to Principal Payment
    Populate Principal Payment General Tab    &{ExcelPath}[PrincipalPayment_RequestedAmount]    ${SystemDate}    &{ExcelPath}[Reason]

    ##Cashflow Notebook - Create Cashflows###
    Navigate to Payment Workflow and Proceed With Transaction    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower1_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[ActualAmount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower1_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[ActualAmount]
   
    ###Workflow Tab - Send to Approval###
    Send Principal Payment to Approval
   
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    #Work In Process Window###
    Select Item in Work in Process    Payments   Awaiting Approval    Loan Principal Prepayment    &{ExcelPath}[Loan_Alias]
    Approve Principal Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    Select Item in Work in Process    Payments   Awaiting Release    Loan Principal Prepayment    &{ExcelPath}[Facility_Name]
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Cashflow_DataType]    Payment
    Navigate to Payment Workflow and Proceed With Transaction    Release

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    

Create Cycle Share Adjustment for Fee Accrual- Payment Reversal for DNR
    [Documentation]    This keyword is for creating and validating a successful Reversal for Fee Payments in FULL.
    ...    @author: shirhong    14DEC2020    - initial create
    [Arguments]    ${ExcelPath}  
    
    ###Write Effective Date Details to Cycle Share Adjustment Sheet####
    ${Payment_EffectiveDate}    Read Data From Excel    SC2_PaymentFees    FeePayment_EffectiveDate    &{ExcelPath}[rowid]    ${DNR_DATASET}
    Write Data To Excel	   SC2_CycleShareAdjustment    Payment_EffectiveDate    ${rowid}    ${Payment_EffectiveDate}   ${DNR_DATASET}
    
    ###Navigate to the applicable Deal/Facility/Outstanding and open Payment Notebook###
    ${SystemDate}    Get System Date
    Write Data To Excel	   SC2_CycleShareAdjustment    Payment_ProcessingDate    ${rowid}    ${SystemDate}   ${DNR_DATASET}
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    
    ###Create interest Payment Reversal in full###
    ${CycleDue_Expected}    ${Paidtodate_Expected}    Retrieve Intial Amounts in Line Fee Accrual Tab and Evaluate Expected Values for Reversal Post Validation    &{ExcelPath}[CycleNo]    &{ExcelPath}[Amount]  
  
    ${DebitAmt_Customer}    ${CreditAmt_Customer}    ${DebitAmt_Host}    ${CreditAmt_Host}    ${TotalDebitAmt}    ${TotalCreditAmt}    Retrieve Initial Data From GL Entries After Payment for Line Fee    &{ExcelPath}[Customer_Name]    &{ExcelPath}[Host_ShortName]    &{ExcelPath}[FeePayment_Date] 
    ...    &{ExcelPath}[FeePayment_Time]    &{ExcelPath}[FeePayment_User]    &{ExcelPath}[EffectiveDate_FeePayment]    &{ExcelPath}[FeePayment_Comment]    

    Create Line Fee Payment Reversal After Fee Payment Is Released    &{ExcelPath}[Reversal_Comment]    &{ExcelPath}[EffectiveDate_FeePayment]    &{ExcelPath}[EffectiveDate_Label]    &{ExcelPath}[Window_name]    &{ExcelPath}[Amount]

    ## Create Cashflows for Paperclip ###
    Navigate to Reverse Fee Workflow and Proceed With Transaction    Create Cashflow
    Verify if Method has Remittance Instruction    &{ExcelPath}[Customer_Name]    &{ExcelPath}[Borrower1_RemittanceDescription]    &{ExcelPath}[Borrower1_RemittanceInstruction]    
    Verify if Status is set to Do It    &{ExcelPath}[Customer_Name]  
    Create Cashflow     &{ExcelPath}[Customer_Name]    release
    
    ###Send Created Cashflow/Payment Reversal for Approval###
    Navigate to Reverse Fee Workflow and Proceed With Transaction    Send to Approval
    Logout from Loan IQ
    
    ###Accrual Share Adjustment Notebook - Workflow Items (APPROVER)###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    ### Approve Paperclip Transaction
    Select Item in Work in Process    Payments    Awaiting Approval    Reverse Fee Payment     &{ExcelPath}[Deal_Name]
    Navigate to Reverse Fee Workflow and Proceed With Transaction    Approval
    Logout from Loan IQ
    
    ###Accrual Share Adjustment Notebook - Workflow Items (APPROVER2)###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Reverse Fee Payment     &{ExcelPath}[Deal_Name]
    Navigate to Reverse Fee Workflow and Proceed With Transaction    Release
    Close All Windows on LIQ  
    


    
