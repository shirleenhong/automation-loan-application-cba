*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Update Line Fee Cycle for DNR
    [Documentation]    This keyword will update the existing commitment fee cycle in the created deal
    ...    @author: songchan    03DEC2020    - Duplicate from scenario 7 for Comsee use
    [Arguments]    ${ExcelPath}
    ###LoanIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Loan IQ Desktop###
    ${SystemDate}    Get System Date
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - Summary Tab###  
    ${Fee_Alias}    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type1]
    
    ###Commitment Fee Notebook - General Tab###  
    ${AdjustedDueDate}    Update Cycle on Line Fee   &{ExcelPath}[Fee_Cycle]
    
    ${ScheduleActivity_FromDate}    Subtract Days to Date    ${AdjustedDueDate}    30
    ${ScheduledActivity_ThruDate}    Add Days to Date    ${AdjustedDueDate}    30
    Write Data To Excel    SC2_PaymentFees    ScheduleActivity_FromDate    ${rowid}    ${ScheduleActivity_FromDate}    ${DNR_DATASET}    
    Write Data To Excel    SC2_PaymentFees    ScheduledActivity_ThruDate    ${rowid}    ${ScheduledActivity_ThruDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_PaymentFees    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_PaymentFees    FeePayment_EffectiveDate    ${rowid}    ${SystemDate}    ${DNR_DATASET}
    Run Online Acrual to Line Fee
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    

Pay Line Fee Amount - Syndicated for DNR
    [Documentation]    This keyword will be used for payments and transactions of commitment fee amount for Syndicated Deals
    ...    @author: songchan    - initial create
    [Arguments]    ${ExcelPath}
    #Return to Scheduled Activity Fiter###    
    Navigate to Scheduled Activity Filter
    
    ${SysDate}    Get System Date
    ${FromDate}    Subtract Days to Date    ${SysDate}    &{ExcelPath}[Days]
    ${ThruDate}    Add Days to Date    ${SysDate}    &{ExcelPath}[Days]
    Write Data To Excel    SC2_PaymentFees    ScheduleActivity_FromDate    ${rowid}    ${FromDate}    ${DNR_DATASET}
    Write Data To Excel    SC2_PaymentFees    ScheduledActivity_ThruDate    ${rowid}    ${ThruDate}    ${DNR_DATASET}
    ###Scheduled Activity Filter###
    Set Scheduled Activity Filter    ${FromDate}    ${ThruDate}    &{ExcelPath}[ScheduledActivity_Department]    &{ExcelPath}[ScheduledActivity_Branch]    &{ExcelPath}[Deal_Name]

    ###Scheduled Activity Report Window###
    Select Fee Due    &{ExcelPath}[FeeType1]    &{ExcelPath}[ScheduledActivityReport_Date]    &{ExcelPath}[Facility_Name]
    
    ###Line Fee Notebook - General Tab###
    ${ProjectedCycleDue}    ${Rate}    ${RateBasis}    ${BalanceAmount}    Compute Line Fee Amount Per Cycle    &{ExcelPath}[CycleNumber]    ${SysDate}
    Write Data To Excel    SC2_PaymentFees    Computed_ProjectedCycleDue    &{ExcelPath}[rowid]    ${ProjectedCycleDue}    sFilePath=${DNR_DATASET}
    
    ##Cycles for Commitment Fee###
    Select Cycle Due Line Fee Payment 
    
    ###Ongoing Fee Payment Notebook - General Tab###
    Enter Effective Date for Ongoing Fee Payment    ${SysDate}    ${ProjectedCycleDue}
    
    ###Ongoing Fee Payment Notebook - Workflow Tab###  
    Navigate to Cashflow - Ongoing Fee
    
    ###Cashflow Window###
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Remittance_Description]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]

    ${ProjectedCycleDue}    Read Data From Excel    SC2_PaymentFees    Computed_ProjectedCycleDue    ${rowid}    sFilePath=${DNR_DATASET}
    ${HostBankShare}    Get Host Bank Cash in Cashflow
    Write Data to Excel    SC2_PaymentFees    Host_BankShare    ${rowid}    ${HostBankShare}    ${DNR_DATASET}
    ${BorrowerTranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Borrower_ShortName]
    ${Lend1TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender1_ShortName]
    ${Lend2TranAmount}    Get Transaction Amount in Cashflow    &{ExcelPath}[Lender2_ShortName]
    Send Ongoing Fee Payment to Approval
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ###Work In Process Window###
    Select Item in Work in Process    Payments    Awaiting Approval    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]

    
    ###Ongoing Fee Payment Notebook - Workflow Tab### 
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Generation of Intent Notice is skipped - Customer Notice Method must be updated###
    Select Item in Work in Process    Payments    Awaiting Release    Ongoing Fee Payment     &{ExcelPath}[Facility_Name]        
    Release Ongoing Fee Payment

    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Deal Notebook - Summary Tab### 
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Fee_Type1]

    ###Commitment Fee Notebook - Acrual Tab###
    Validate Release of Ongoing Line Fee Payment
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    

Admin Fee Payment for DNR
    [Documentation]    This keyword makes an Admin/Agency Fee Payment.
    ...    @author: songchan    02DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Verify if the Event Fee is not yet released###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Check if Admin Fee is Added
    Verify Admin Fee Status    &{ExcelPath}[Deal_Name]    &{ExcelPath}[AdminFee_Alias]    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ${SysDate}    Get System Date
    ${FromDate}    Subtract Days to Date    ${SysDate}    &{ExcelPath}[Subtract_Days]
    ${ThruDate}    Add Days to Date    ${SysDate}    &{ExcelPath}[Add_Days]
    
    ###Opens the Deal's Scheduled Activity Report from WIP###
    Open Deal Scheduled Activity Report    &{ExcelPath}[Deal_Name]    ${FromDate}    ${ThruDate}
    
    ###Open the transaction in the Scheduled Activity Report###
    Open Transaction In Scheduled Activity Report    &{ExcelPath}[Deal_Name]    &{ExcelPath}[AdminFee_DueDate]    ${ADMIN_FEE_AMORT}
    
    ###Initiate the Admin Fee Payment by entering the required fields###
    ${AdminFeePayment_EffectiveDate}    Get System Date
    Write Data To Excel    SC2_AdminFeePayment    FeePayment_EffectiveDate    ${rowid}    ${AdminFeePayment_EffectiveDate}    ${DNR_DATASET}
    Create Admin Fee Payment    &{ExcelPath}[Deal_Name]    ${AdminFeePayment_EffectiveDate}    &{ExcelPath}[AdminFeePayment_Comment]
    
    ### Create cashflows and verifying the remittance details
    Navigate Notebook Workflow for Admin Fee Payment    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]
 
    Close GL Entries and Cashflow Window
    
    ###Send Admin Fee Payment to Approval###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    ${SEND_TO_APPROVAL_STATUS}

    ### Approve Admin Fee Payment###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}    
    Navigate Transaction in WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${AMORTIZING_ADMIN_FEE_PAYMENT_TYPE}    &{ExcelPath}[Deal_Name]
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    ${APPROVAL_STATUS}


    ### Approve Admin Fee Payment###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate Transaction in WIP    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${AMORTIZING_ADMIN_FEE_PAYMENT_TYPE}    &{ExcelPath}[Deal_Name]
    
    ###Release Admin Fee Payment###
    Navigate Notebook Workflow    ${LIQ_AdminFeePayment_Window}    ${LIQ_AdminFeePayment_Tab}    ${LIQ_AdminFeePayment_Workflow_Tree}    ${RELEASE_STATUS}
    
    ###Close all other LIQ windows except for the main LIQ window###
    Close All Windows on LIQ