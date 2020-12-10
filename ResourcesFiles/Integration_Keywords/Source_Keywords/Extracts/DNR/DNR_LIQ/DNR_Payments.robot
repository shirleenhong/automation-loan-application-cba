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
    ...    @clanding: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date     
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