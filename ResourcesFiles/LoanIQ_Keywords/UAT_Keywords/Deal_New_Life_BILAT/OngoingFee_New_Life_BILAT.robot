*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Collect Commitment Fee Payment For New Life BILAT
    [Documentation]    This keyword collects the commitment fee payment of the facility.
    ...    @author: kmagday    06012021    - Intial Create
    [Arguments]    ${ExcelPath}
       
    ### Login to LIQ ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ### Launch Facility ###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Commitment Fee Notebook - General Tab ###  
    ${Rate}    ${BalanceAmount}    ${RateBasis}    Get Data in General Tab
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate    ${rowid}    ${Rate}
    Write Data To Excel    SERV29_CommitmentFeePayment    Balance_Amount    ${rowid}    ${BalanceAmount}
    Write Data To Excel    SERV29_CommitmentFeePayment    Rate_Basis    ${rowid}    ${RateBasis}  

    ${ProjectedCycleDue}    Compute Commitment Fee Amount Per Cycle    ${BalanceAmount}    ${RateBasis}    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Commitment_AdjustedDueDate]    None    None    &{ExcelPath}[Commitment_Accrue]    
    Write Data To Excel    SERV29_CommitmentFeePayment    Computed_CycleDue    ${rowid}    ${ProjectedCycleDue}

    ### Ongoing Fee Payment ###
    Select Cycle Fee Payment 
    Enter Effective Date for Ongoing Fee-Cycle Due Payment    &{ExcelPath}[Commitment_AdjustedDueDate]
    Select Menu Item    ${LIQ_OngoingFeePayment_Window}    File    Save

    ### Create Cashflow ###
    Navigate Notebook Workflow    ${LIQ_OngoingFeePayment_Window}    ${LIQ_OngoingFeePayment_Tab}    ${LIQ_OngoingFeePayment_WorkflowItems}    ${CREATE_CASHFLOW_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]  
    Close GL Entries and Cashflow Window
    
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
    Validate Details on Acrual Tab - Commitment Fee    ${ProjectedCycleDue}    &{ExcelPath}[Cycle_Number]
    Validate release of Ongoing Fee Payment
    Close All Windows on LIQ   
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
Change Commitment Fee to Expiry Date
    [Documentation]    This keyword change the expiry date of the commitment fee.
    ...    @author: kmagday    31Jan2021    - Intial Create
    [Arguments]    ${ExcelPath}

    ### Login to LIQ ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ### Launch Facility ###
    Launch Existing Facility    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Commitment Fee Notebook - General Tab ###  
    Change Expiry Date    ${ExcelPath}[Commitment_ExpiryDate]

    ### Perform Online Accrual ###
    Perform Online Accrual in Commitment Fee Notebook

 