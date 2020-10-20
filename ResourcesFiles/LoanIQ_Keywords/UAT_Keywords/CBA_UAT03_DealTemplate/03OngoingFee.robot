*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Collect LFIA Payment D00000476
    [Documentation]    This keyword is the template for setting up UAT Deal 3
    ...    @author: ritragel    07AUG2019
    ...    @update: jloretiz    27SEP2019    - added additional field population for Line Fee
    [Arguments]    ${ExcelPath}
        
    ### Login to LIQ ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ### Launch Facility ###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    # ### Select Menu Item ###
    # Update Line Fee Dates    ${LIQ_LineFeeNotebook_Window}    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Rate_Start_Date]    
    # ...    &{ExcelPath}[Actual_Due]    &{ExcelPath}[Cycle_Frequency]
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
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Approval    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]
    
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_PaymentNotebook_Tab}    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Approval
    
    ### Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_PaymentNotebook_Tab}    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Release Cashflows
<<<<<<< HEAD
    # Release Cashflow    &{ExcelPath}[Borrower1_ShortName]    release
=======
    Release Cashflow    &{ExcelPath}[Borrower1_ShortName]    release
>>>>>>> 87a8729be1debee4a65802404e0ed4980499c149
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_PaymentNotebook_Tab}    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Release

Collect Commitment Fee Payment
    [Documentation]    This keyword collects the commitment fee payment of the facility
    ...    @author:mgaling    31July2019    Intial Create
    [Arguments]    ${ExcelPath}
    
    ${Date}    Get System Date
    
    ### Login to LIQ ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ### Launch Facility ###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Commitment Fee Notebook - General Tab ###  
    ${Rate}    ${BalanceAmount}    ${RateBasis}    Get Data in General Tab
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate    ${rowid}    ${Rate}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Balance_Amount    ${rowid}    ${BalanceAmount}    ${CBAUAT_ExcelPath}
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate_Basis    ${rowid}    ${RateBasis}    ${CBAUAT_ExcelPath}
    
    ${ProjectedCycleDue}    Compute Commitment Fee Amount Per Cycle    &{ExcelPath}[Balance_Amount]    &{ExcelPath}[Rate_Basis]    &{ExcelPath}[Cycle_Number]    ${Date}
    Write Data To Excel    SERV29_CommitmentFeePayment    Computed_CycleDue    ${rowid}    ${ProjectedCycleDue}    ${CBAUAT_ExcelPath}
    
    ## Ongoing Fee Payment ###
    Select Cycle Due Fee Payment 
    Enter Effective Date for Ongoing Fee-Cycle Due Payment    ${Date}
    Select Menu Item    ${LIQ_OngoingFeePayment_Window}    File    Save
    
    ### Ongoing Fee Payment - Cashflow Validation ###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    Create Cashflow
    
    ### Cashflow Window ###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    
    ### GL Entries Validation ###
    ${ProjectedCycleDue}    Read Data From Excel    SERV29_CommitmentFeePayment    Computed_CycleDue    &{ExcelPath}[rowid]    ${CBAUAT_ExcelPath}
    
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    Debit Amt
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    Credit Amt
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}
    
    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   Credit Amt
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    Debit Amt
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    ${ProjectedCycleDue}
        
    ### Send to Approval ###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    Send to Approval
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Approval    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]
    
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    Approval
    
    ### Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    Payments    Awaiting Release    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    Release Cashflows
    Release Cashflow    &{ExcelPath}[Borrower_ShortName]    release
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_PaymentNotebook_Tab}    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Release
    
    ### Payment Transaction Validation ###
    Close All Windows on LIQ
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    
    ### Launch Facility ###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Validate Accrual Details ###
    Validate Details on Acrual Tab - Commitment Fee    ${ProjectedCycleDue}    &{ExcelPath}[Cycle_Number]
    Validate release of Ongoing Fee Payment
    Close All Windows on LIQ   

Setup Ongoing Fee D00000476
    [Documentation]    This keyword will update the Setup the Ongoing Fees in the Deal
    ...    @author:    ritragel    09SEP2020    Addded selection of Due Date
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Commitment Fee Notebook ###
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type]
    
    ### Enter Details
    Run Keyword If    '&{ExcelPath}[rowid]' != '4'    Enter Commitment Fee Details    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Actual_DueDate]    &{ExcelPath}[Adjusted_DueDate]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[Accrue]
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Enter Line Fee Details    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Actual_DueDate]    &{ExcelPath}[Adjusted_DueDate]    &{ExcelPath}[Cycle_Frequency]    &{ExcelPath}[Accrue]
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Refresh Tables in LIQ


Release Ongoing Fee D00000476
    [Documentation]    This keyword will release the set ongoing Fee for UAT Deal3
    ...    @author: ritragel    17SEP2020    Initial Commit
    [Arguments]    ${ExcelPath}
    
    ##LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Deal Notebook###
    Open Existing Deal    &{ExcelPath}[Deal_Name]

    ### Navigate to Commitment Fee Notebook ###
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type]
    
    ### Enter Details
    Run Keyword If    '&{ExcelPath}[rowid]' != '4'    Release Commitment Fee
    Run Keyword If    '&{ExcelPath}[rowid]' == '4'    Release Line Fee
    Refresh Tables in LIQ

Commitment Fee Release
    [Documentation]    This keyword validates the status of commitment fee notebook of the facility.
    ...    @author:mgaling    31July2019    Intial Create
    [Arguments]    ${ExcelPath}
    
    ### Navigate to Commitment Fee Notebook ###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    # Navigate Directly to Commitment Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    
    # ### Workflow Tab ###
    # Validate Commitment Fee Notebook Status
    

    
    
    