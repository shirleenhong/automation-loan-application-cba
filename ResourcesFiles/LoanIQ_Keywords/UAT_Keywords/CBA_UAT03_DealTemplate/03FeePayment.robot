*** Settings ***
Resource    ../../../../Configurations/Import_File.robot


*** Keywords ***
Collect LFIA Payment D00000476
    [Documentation]    This keyword is the template for setting up UAT Deal 3
    ...    @author: ritragel    07AUG2019
    ...    @update: jloretiz    27SEP2019    - added additional field population for Line Fee
    [Arguments]    ${ExcelPath}
        
    ### Login to LIQ ###
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ### Launch Facility ###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Line Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Select Menu Item ###
    Update Line Fee Dates    ${LIQ_LineFeeNotebook_Window}    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Rate_Start_Date]    
    ...    &{ExcelPath}[Actual_Due]    &{ExcelPath}[Cycle_Frequency]
    Select Menu Item    ${LIQ_LineFeeNotebook_Window}    Options    Payment
    Select Payment in Choose a Payment Window    &{ExcelPath}[Payment_Type]
    Select Cycle for Payment    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Prorate_With]
    
    ### Populate fields
    Enter Effective Date for Ongoing Fee Payment    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Cycle_Frequency]
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_PaymentNotebook_Tab}    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Create Cashflow
    
    ### Cashflow Window ###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[LineFee_Amount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${ComputedHBTranAmount}
     
    ### GL Entries ###
    Navigate to GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    ${Borrower_Credit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001     Debit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001     Credit Amt
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}    ${HostBank_Debit}
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalDebitAmt}    &{ExcelPath}[LineFee_Amount]
    
    ### Send to Approval ###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_PaymentNotebook_Tab}    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Send to Approval
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Approval    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]
    
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_PaymentNotebook_Tab}    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Approval
    
    ### Release ###
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]
    # Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_PaymentNotebook_Tab}    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Release Cashflows
    # Release Cashflow    &{ExcelPath}[Borrower1_ShortName]    release
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_PaymentNotebook_Tab}    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Release

Collect Break Cost Fee for Early Prepayment D00000476
    [Documentation]    This Keyword initiates Interest Payment of the specified Loan
    ...    @author: ritragel    10SEP2019
    [Arguments]    ${ExcelPath}
    
    ###Login to Original User###
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    #LIQ Window
    Search Deal    &{ExcelPath}[Deal_Name]

    #Existing Loans for Facility
    Search Loan   &{ExcelPath}[Type]    &{ExcelPath}[Search_By]    &{ExcelPath}[Facility_Name]
    
    #Breakfunding Notebook
    Navigate Breakfunding Fee Notebook    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Pricing_Option_From_Breakfunding]    
    ...    &{ExcelPath}[Currency]
    Request Lender Fees
    Generate Lender Shares for Bilateral Deal    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Legal_Entity_Amount]
    Add Portfolio and Expense Code    &{ExcelPath}[Legal_Entity]    &{ExcelPath}[Legal_Entity_Amount]    &{ExcelPath}[Expense_Code]
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction] 
    
    ###Get Transaction Amount for Cashflow###
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${ComputedHBTranAmount}    Compute Lender Share Transaction Amount    &{ExcelPath}[Legal_Entity_Amount]    &{ExcelPath}[HostBankSharePct]
    
    Compare UIAmount versus Computed Amount    ${HostBankShare}   ${ComputedHBTranAmount}
    Create Cashflow     &{ExcelPath}[Borrower_ShortName]    release

    ### Send Fee to Approval
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Send to Approval
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_USERNAME}
    Select Item in Work in Process    Payments    Awaiting Approval    Break Cost Fee     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Approval 
    
    ### Approve and Release Breakfunding Fee
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Break Cost Fee     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_Breakfunding_Window}    ${LIQ_Breakfunding_Workflow_Tab}    ${LIQ_Breakfunding_WorkflowItems_List}    Release

    Close All Windows on LIQ

Collect Extension Fee for D00000476
    [Documentation]    This keyword creates an Upfront Fee for a deal.
    ...    @author: ritragel    25SEP2019    Initial Create       
    [Arguments]    ${ExcelPath}
    
    ### Approve and Release Breakfunding Fee
    Logout from LIQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Populate Upfront Fee Payment Notebook    &{Excelpath}[UpfrontFee_Amount]    &{Excelpath}[EstablishmentFee_EffectiveDate]        
    Populate Fee Details Window    &{ExcelPath}[UpfrontFee_Type]    &{ExcelPath}[UpfrontFeePayment_Comment]
    
    ###Upfront Fee Payment Workflow Tab- Create Cashflow Item###
    Navigate Notebook Workflow    ${LIQ_UpfrontFeePayment_Notebook}    ${LIQ_UpfrontFeePayment_Tab}    ${LIQ_UpfrontFeePayment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Create Cashflow    &{ExcelPath}[Borrower_ShortName]    release     
 
    ###Upfront Fee Payment Workflow Tab- Send to Approval Item###
    Send to Approval Upfront Fee Payment    
    
    ###Upfront Fee Payment Workflow Tab- Approval Item###
    Logout from LIQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}   ${SUPERVISOR_PASSWORD}
    Navigate to Payment Notebook via WIP    Payments    Awaiting Approval    Fee Payment From Borrower    &{ExcelPath}[Deal_Name]    
    Approve Upfront Fee Payment
    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_UpfrontFeePayment_Tab}    ${LIQ_UpfrontFeePayment_WorkflowItems}    Release
