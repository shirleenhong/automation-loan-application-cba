*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Initiate Interest Payment for Agency Deal
    [Documentation]    This keyword will pay Interest Fees for Agency Deal
    ...    @update: amansuet    17JUN2020    - updated flow as cashflow details should be for lender and replaced navigation keywords that uses locators as inputs
    ...    @update: amansuet    18JUN2020    - updated Release a Cashflow
    ...    @update: amansuet    22JUN2020    - used generic keyword 'Release Cashflow Based on Remittance Instruction'
	[Arguments]    ${ExcelPath} 
    
    ###Navigate to Existing Loan###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Navigate to Outstanding Select Window from Deal
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[New_Loan_Alias]
    ${ScheduledActivityReport_Date}    Get Interest Actual Due Date on Loan Notebook
    Write Data To Excel    SERV22_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${ScheduledActivityReport_Date}
    
    Close All Windows on LIQ 
    ${SystemDate}    Get System Date
    Navigate to the Scheduled Activity Filter
    Open Scheduled Activity Report    &{ExcelPath}[ScheduledActivity_FromDate]    &{ExcelPath}[ScheduledActivity_ThruDate]    &{ExcelPath}[Deal_Name]
   
    ###Loan Notebook####
    Open Loan Notebook    ${ScheduledActivityReport_Date}    &{ExcelPath}[ScheduledActivityReport_ActivityType]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[New_Loan_Alias]
    ${CycleDue}    Compute Interest Payment Amount Per Cycle - Zero Cycle Due    &{ExcelPath}[CycleNumber]    ${SystemDate}
    Write Data To Excel    SERV22_InterestPayments    Payment_Amount    ${rowid}    ${CycleDue}

    ###Interest Payment Notebook####
    Initiate Loan Interest Payment   &{ExcelPath}[CycleNumber]    &{ExcelPath}[Pro_Rate]
    Input Effective Date and Requested Amount for Loan Interest Payment    ${SystemDate}    ${CycleDue}
     
    ###For Debugging###
    ###${CycleDue}    Read Data From Excel    SERV21_InterestPayments    Payment_Amount    ${rowid}    
     
    ##Cashflow Notebook - Create Cashflows###
    Navigate to Payment Workflow and Proceed With Transaction    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Lender_Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_ShortName]  
     
    ##Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${LenderTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    ${CycleDue}    &{ExcelPath}[HostBankSharePct]
     
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
      
    ###GL Entries###
    Navigate to GL Entries
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Lender_Debit}    Get GL Entries Amount    &{ExcelPath}[Lender_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    Total For:    Debit Amt
     
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is Balanced    ${Lender_Debit}    ${HostBank_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    ${ComputedHBTranAmount}
    
    ###Workflow Tab - Send to Approval###
    Send Interest Payment to Approval
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Work in Process#####
    Open Interest Payment Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[New_Loan_Alias]
    Approve Interest Payment
    ### Commented out for Correspondence Testing Generate Intent Notices for Payment    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Contact_Email]

    ##Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    ###Interest Payment Notebook - Workflow Tab###  
    Select Item in Work in Process    Payments    Awaiting Release    Interest Payment     &{ExcelPath}[Facility_Name]
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Lender_Remittance_Instruction]    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Cashflow_DataType]    Payment
    Navigate to Payment Workflow and Proceed With Transaction    Release
    
    ##Facility Notebook####
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]   
   
    ####Outstanding Select####  
    Navigate to Outstanding Select Window
   
    ###Loan Notebook####
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[New_Loan_Alias]
   
    Validate Interest Payment in Loan Accrual Tab    &{ExcelPath}[CycleNumber]    ${CycleDue}
   
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
