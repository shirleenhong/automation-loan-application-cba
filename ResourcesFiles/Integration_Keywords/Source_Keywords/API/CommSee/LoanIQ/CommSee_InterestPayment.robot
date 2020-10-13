*** Settings ***
Resource     ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
    
Generate Intent Notices of an Interest Payment-CommSee
    [Documentation]    This keyword generates Intent Notices of an Interest Payment
    ...    @author: ghabal    
    [Arguments]    ${LIQCustomer_ShortName}    

    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}    
        
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    ${NoticeStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Notice_Information_Table}    ${LIQCustomer_ShortName}%Status%test    
    Log    ${NoticeStatus}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Notice_Information_Table}    ${LIQCustomer_ShortName}%s 
    

    mx LoanIQ click    ${LIQ_InterestPayment_Notice_Exit_Button}

Release Interest Payment
    [Documentation]    This keyword will release the Loan Drawdown
    ...    @author: ritragel
    ...    @update: ritragel    06MAR19    Added handling of closing Cashflows window
    mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}   
    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Complete Cashflows 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
Initiate Interest Payment - Scenario 7 ComSee
   [Documentation]    This keyword will pay Interest Fees on a bilateral deal
   ...    @author: rtarayao    13SEP2019    - Duplicate from Scenario 7 of the Functional Scenarios
   [Arguments]    ${ExcelPath}
   
   ###Navigate to Existing Loan###
   Open Existing Deal    &{ExcelPath}[Deal_Name]
   Navigate to Outstanding Select Window from Deal
   Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
   ${ScheduledActivityReport_Date}    Get Interest Adjusted Due Date on Loan Notebook
   ${LoanEffectiveDate}    ${LoanMaturityDate}    Get Loan Effective and Maturity Expiry Dates
   Write Data To Excel    ComSee_SC7_LoanInterestPayment    ScheduledActivityReport_Date    ${rowid}    ${ScheduledActivityReport_Date}    ${ComSeeDataSet}
   Close All Windows on LIQ 
   ${SystemDate}    Get System Date
   Navigate to the Scheduled Activity Filter
   Open Scheduled Activity Report    ${LoanEffectiveDate}    ${LoanMaturityDate}    &{ExcelPath}[Deal_Name]
   
   ###Loan Notebook####
   Open Loan Notebook    ${ScheduledActivityReport_Date}    &{ExcelPath}[ScheduledActivityReport_ActivityType]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_Alias]
   ${CycleDue}    Compute Interest Payment Amount Per Cycle - Zero Cycle Due    &{ExcelPath}[CycleNumber]    ${SystemDate}
   Write Data To Excel    ComSee_SC7_LoanInterestPayment    Payment_Amount    ${rowid}    ${CycleDue}    ${ComSeeDataSet}

   ###Interest Payment Notebook####
   Initiate Loan Interest Payment   &{ExcelPath}[CycleNumber]    &{ExcelPath}[Pro_Rate]
   Input Effective Date and Requested Amount for Loan Interest Payment    ${SystemDate}    ${CycleDue}
    
   ##Cashflow Notebook - Create Cashflows###
   Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Create Cashflows
   Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Remittance_Instruction]
   Verify if Status is set to Do It    &{ExcelPath}[Borrower1_ShortName]  
    
   ##Get Transaction Amount for Cashflow###
   ${HostBankShare}    Get Host Bank Cash in Cashflow
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

   ##Loan IQ Desktop###
   Close All Windows on LIQ
   Logout from Loan IQ
   Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

   ###Interest Payment Notebook - Workflow Tab###  
   Select Item in Work in Process    Payments    Awaiting Release    Interest Payment     &{ExcelPath}[Facility_Name]
   Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Release Cashflows
   Release Payment
    
   ##Facility Notebook####
   Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]   
   
   ####Outstanding Select####  
   Navigate to Outstanding Select Window
   
   ###Loan Notebook####
   Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
   ${CycleDue}    Convert To String    ${CycleDue}       
   Validate Interest Payment in Loan Accrual Tab    &{ExcelPath}[CycleNumber]    ${CycleDue}
   
   Close All Windows on LIQ
   Logout from Loan IQ