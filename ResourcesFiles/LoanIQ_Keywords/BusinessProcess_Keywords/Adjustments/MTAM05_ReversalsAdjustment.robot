*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***

*** Keywords ***
   
Create Cycle Share Adjustment
    [Documentation]    This keyword will create a Cycle Share Adjustment on a deal
    ...    @author: rtarayao
    [Arguments]    ${ExcelPath}
    ###Get Current Date###    
    ${SBLC_EffectiveDate}    Get System Date
    
    ###Launch SBLC Notebook###
    Open SBLC Guarantee Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[SBLC_Alias]
    
    ###Bank Guarantee/Letter of Credit/Synd Fronted Bank###
    Navigate to Accrual Tab
    ${Current_Cycle_Due}    ${Cycle_StartDate}    ${Cycle_EndDate}    ${Paid_to_Date}    Store Cycle Start Date, End Date, and Paid Fee    &{ExcelPath}[SBLC_CycleNumber]
    Write Data To Excel    MTAM05A_CycleShareAdjustment    CurrentCycleDue_Value    ${rowid}    ${Current_Cycle_Due}
    Write Data To Excel    MTAM05A_CycleShareAdjustment    PaidSoFar_Value    ${rowid}    ${Paid_to_Date}
    Write Data To Excel    MTAM05A_CycleShareAdjustment    EndDate_Value    ${rowid}    ${Cycle_EndDate}
    Write Data To Excel    MTAM05A_CycleShareAdjustment    StartDate_Value    ${rowid}    ${Cycle_StartDate}
    ${ProjectedCycleDue}    Compute Issuance Interest Payment Amount Per Cycle    &{ExcelPath}[SBLC_CycleNumber]
    Write Data To Excel    MTAM05A_CycleShareAdjustment    Computed_ProjectedCycleDue    ${rowid}    ${ProjectedCycleDue}
    Validate SBLC Issuance Fee Per Cycle in Accrual Tab    &{ExcelPath}[SBLC_CycleNumber]    &{ExcelPath}[Sheet_Name]    &{ExcelPath}[rowid]    ${ExcelPath}[Computed_ProjectedCycleDue]

    ###Accrual Share Adjustment Notebook - Workflow Items (INPUTTER)###
    Navigate to Accruals Share Adjustment Notebook    &{ExcelPath}[SBLC_CycleNumber]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower1_ShortName]    &{ExcelPath}[SBLC_Alias]    ${ProjectedCycleDue}
    Input Requested Amount, Effective Date, and Comment    ${Paid_to_Date}    ${SBLC_EffectiveDate}    &{ExcelPath}[Accrual_Comment]
    Save the Requested Amount, Effective Date, and Comment    ${Paid_to_Date}    ${SBLC_EffectiveDate}    &{ExcelPath}[Accrual_Comment]
    Send Adjustment to Approval    

    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    #Work In Process Window###
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${FEE_ACCRUAL_SHARES_ADJUSTMENT_TYPE}     &{ExcelPath}[Facility_Name]
    
    ###Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve Cycle Share Adjustment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}

    ##Transactions in Process###
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${FEE_ACCRUAL_SHARES_ADJUSTMENT_TYPE}     &{ExcelPath}[Facility_Name]             
    Release Cycle Share Adjustment

    ###Loan IQ Desktop###    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

Create Cycle Share Adjustment for Fee Accrual- Payment Reversal
    [Documentation]    This keyword is for creating and validating a successful Reversal for Fee Payments in FULL.
    ...    @author:chanario
    ...    @update: dahijara    16JUL2020    - update keyword for Natigating to Reverse Fee Workflow. Added logout after manager's release
    [Arguments]    ${ExcelPath}  

    ###Navigate to the applicable Deal/Facility/Outstanding and open Payment Notebook###
    ${SystemDate}    Get System Date
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    
    ###Create interest Payment Reversal in full###
    ${CycleDue_Expected}    ${Paidtodate_Expected}     Retrieve Intial Amounts in Accrual Tab and Evaluate Expected Values for Reversal Post Validation    &{ExcelPath}[CycleNo]    &{ExcelPath}[Amount]  
  
    ${DebitAmt_Customer}    ${CreditAmt_Customer}    ${DebitAmt_Host}    ${CreditAmt_Host}    ${TotalDebitAmt}    ${TotalCreditAmt}    Retrieve Initial Data From GL Entries After Payment    &{ExcelPath}[Customer_Name]    &{ExcelPath}[Host_ShortName]    &{ExcelPath}[FeePayment_Date] 
    ...    &{ExcelPath}[FeePayment_Time]    &{ExcelPath}[FeePayment_User]    &{ExcelPath}[EffectiveDate_FeePayment]    &{ExcelPath}[FeePayment_Comment]    

    Create Payment Reversal    &{ExcelPath}[Reversal_Comment]    &{ExcelPath}[EffectiveDate_FeePayment]    &{ExcelPath}[EffectiveDate_Label]    &{ExcelPath}[Window_name]    &{ExcelPath}[Amount]

    ## Create Cashflows for Paperclip ###
    Navigate to Reverse Fee Workflow and Proceed With Transaction    Create Cashflow
    Verify if Method has Remittance Instruction    &{ExcelPath}[Customer_Name]    &{ExcelPath}[Borrower1_RTGSRemittanceDescription]    &{ExcelPath}[Borrower1_RTGSRemittanceInstruction]    
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
    Logout from Loan IQ

    ###Verify the Updates in Accrual Tab###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]    

    Validate Payment Reversal in Accrual Tab    &{ExcelPath}[CycleNo]    ${CycleDue_Expected}    ${Paidtodate_Expected}
    Validate Payment Reversal in Events Tab    &{ExcelPath}[Event]    &{ExcelPath}[Amount]    &{ExcelPath}[EffectiveDate_FeePayment]    ${DebitAmt_Customer}    ${CreditAmt_Customer}    ${DebitAmt_Host}    ${CreditAmt_Host}    ${TotalDebitAmt}    ${TotalCreditAmt}    &{ExcelPath}[Customer_Name]    &{ExcelPath}[Host_ShortName]
    Close All Windows on LIQ    
