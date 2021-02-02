*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Collect Commitment Fee Payment For PIM Future BILAT
    [Documentation]    This keyword collects the commitment fee payment of the facility.
    ...    @author: mcastro    10DEC2020    - Intial Create
    ...    @update: mcastro    01FEB2021    - Remove uncessary keywords for computation and removed writing on data set for computation
    ...                                     - Added additional validation on Accrual Tab
    [Arguments]    ${ExcelPath}
       
    ### Login to LIQ ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ### Launch Facility ###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Ongoing Fee Payment ###
    Validate Dues on Accrual Tab for Commitment Fee    &{ExcelPath}[Projected_CycleDue]    &{ExcelPath}[Cycle_Number]
    Select Cycle Fee Payment 
    Enter Effective Date for Ongoing Fee Payment    &{ExcelPath}[Commitment_AdjustedDueDate]    &{ExcelPath}[Projected_CycleDue]
    Select Menu Item    ${LIQ_OngoingFeePayment_Window}    File    Save

    ### Create Cashflow ###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    ${CREATE_CASHFLOW_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    
    ### GL Entries Validation ###    
    Navigate to GL Entries
    ${Borrower_Debit}    Get GL Entries Amount    &{ExcelPath}[Borrower_ShortName]    ${DEBIT_AMT_LABEL}
    ${HostBank_Credit}    Get GL Entries Amount    &{ExcelPath}[Host_Bank]    ${CREDIT_AMT_LABEL}
    Validate if Debit and Credit Amt is Balanced    ${Borrower_Debit}    ${HostBank_Credit}

    ${UITotalCreditAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001   ${CREDIT_AMT_LABEL}
    ${UITotalDebitAmt}    Get GL Entries Amount    ${SPACE}Total For: CB001    ${DEBIT_AMT_LABEL}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalDebitAmt}    ${UITotalCreditAmt}    &{ExcelPath}[Projected_CycleDue]
        
    ### Send to Approval and Approve ###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    ${SEND_TO_APPROVAL_STATUS}
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    ${APPROVAL_STATUS}
    
    ### Generate Intent Notice and Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${GENERATE_INTENT_NOTICES}    ${ONGOING_FEE_PAYMENT_TRANSACTION}     &{ExcelPath}[Facility_Name]
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    ${GENERATE_INTENT_NOTICES} 
    Generate Intent Notices    &{ExcelPath}[Borrower_ShortName]
    Close Generate Notice Window
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    ${RELEASE_STATUS}
    
    ### Validation Of Payment Amount and Release Status ###
    Close All Windows on LIQ
    Search Existing Deal    &{ExcelPath}[Deal_Name]
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]
    Validate Details on Acrual Tab - Commitment Fee    &{ExcelPath}[Projected_CycleDue]    &{ExcelPath}[Cycle_Number]
    Validate release of Ongoing Fee Payment
    Close All Windows on LIQ 
    