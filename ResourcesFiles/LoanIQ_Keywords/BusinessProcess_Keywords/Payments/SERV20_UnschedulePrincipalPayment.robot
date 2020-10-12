*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Initiate Unscheduled Principal Payment
    [Documentation]    This keyword is used to initiate an UNSCHEDULED Principal Payment from the Deal facility notebook
    ...    @update: sahalder    03JUL2020    updated as per new BNS framework
    ...    @update: dfajardo    27AUG2020    Removed Hard coded values
    [Arguments]    ${ExcelPath}
    
    ###Facility Notebook###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${GlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    ${GlobalFacAvailtoDrawAmount}    Get Current Facility Outstandings, Avail to Draw, Commitment Amount
    Navigate to Outstanding Select Window
    
    ###Loan Notebook###
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    ${OldGlobalCurrentAmount}    ${OldHostBankGross}    Get Global Current and Host Bank Gross Loan Amounts
    ${Rate}    ${RateBasis}    ${StartDate}    Get Loan Interest Rate, Rate Basis, and New Start Date    &{ExcelPath}[CycleNumber]
    

    Write Data To Excel    SERV20_UnschedPrincipalPayments    GlobalFacCommitmentAmount    ${rowid}    ${GlobalFacCommitmentAmount}
    Write Data To Excel    SERV20_UnschedPrincipalPayments    GlobalFacOutstandingAmount    ${rowid}    ${GlobalFacOutstandingAmount}
    Write Data To Excel    SERV20_UnschedPrincipalPayments    GlobalFacAvailtoDrawAmount    ${rowid}    ${GlobalFacAvailtoDrawAmount}
    
    Write Data To Excel    SERV20_UnschedPrincipalPayments    OldGlobalCurrentAmount    ${rowid}    ${OldGlobalCurrentAmount}
    Write Data To Excel    SERV20_UnschedPrincipalPayments    OldHostBankGross    ${rowid}    ${OldHostBankGross}
    
    Write Data To Excel    SERV20_UnschedPrincipalPayments    Rate    ${rowid}    ${Rate}
    Write Data To Excel    SERV20_UnschedPrincipalPayments    RateBasis    ${rowid}    ${RateBasis}
    Write Data To Excel    SERV20_UnschedPrincipalPayments    StartDate    ${rowid}    ${StartDate}
    
    ${GlobalFacCommitmentAmount}    Read Data From Excel    SERV20_UnschedPrincipalPayments    GlobalFacCommitmentAmount    ${rowid}
    ${GlobalFacOutstandingAmount}    Read Data From Excel    SERV20_UnschedPrincipalPayments    GlobalFacOutstandingAmount    ${rowid}
    ${GlobalFacAvailtoDrawAmount}    Read Data From Excel    SERV20_UnschedPrincipalPayments    GlobalFacAvailtoDrawAmount    ${rowid}
    
    ${OldGlobalCurrentAmount}    Read Data From Excel    SERV20_UnschedPrincipalPayments    OldGlobalCurrentAmount    ${rowid}
    ${OldHostBankGross}    Read Data From Excel    SERV20_UnschedPrincipalPayments    OldHostBankGross    ${rowid}
    
    ${Rate}    Read Data From Excel    SERV20_UnschedPrincipalPayments    Rate    ${rowid}
    ${RateBasis}    Read Data From Excel    SERV20_UnschedPrincipalPayments    RateBasis    ${rowid}
    ${StartDate}    Read Data From Excel    SERV20_UnschedPrincipalPayments    StartDate    ${rowid}
    
    
    ###Repyament Schedule Window####
    Navigate to Repayment Schedule from Loan Notebook
    Add Unscheduled Transaction    &{ExcelPath}[UnscheduledPrincipal_PrincipalAmt]
    
    ###Unscheduled Principal Payment Notebook###
    Navigate to Unscheduled Principal Payment Notebook    &{ExcelPath}[UnscheduledPrincipal_PrincipalAmt]
    
    ###Cashflows###
    Navigate to Principal Payment Notebook Workflow    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]   
            
    ###Workflow Tab - Send To Approval###
    Send Unscheduled Principal Payment to Approval
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Work in Process###
    Open Unscheduled Principal Payment Notebook via WIP - Awaiting Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
    Approve Unscheduled Principal Payment
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Workflow Tab - Releasing of Cashflows/Payment###
    Open Interest Payment Notebook via WIP - Awaiting Release    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingReleaseCashflowsStatus]    &{ExcelPath}[WIP_PaymentType]    &{ExcelPath}[Loan_Alias]
    
    ###Cashflow Notebook - Release Cashflows###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance_Instruction]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Cashflow_DataType]    ${PAYMENT_WORKFLOW}
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance1_Instruction]    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Cashflow_DataType]    ${PAYMENT_WORKFLOW}
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance2_Instruction]    &{ExcelPath}[Lender2_ShortName]    &{ExcelPath}[Cashflow_DataType]    ${PAYMENT_WORKFLOW}
    Release Unscheduled Principal Payment
    Close All Windows on LIQ 
        
    ###Facility Notebook###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    ${NewGlobalFacCommitmentAmount}    ${NewGlobalFacOutstandingAmount}    ${NewGlobalFacAvailtoDrawAmount}    Get Current Facility Outstandings, Avail to Draw, Commitment Amount
    Navigate to Outstanding Select Window
    
    ###Loan Notebook###      
    Navigate to Existing Loan    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Validate Principal Prepayment in Loan Events Tab
    Close All Windows on LIQ
    
    ####Loan Amount Validation for TERM and REVOLVER Facility####
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name] 
    Run Keyword If    '&{ExcelPath}[Facility_Type]'=='Term'    Validate New Global Current Cmt, Outstandings, and Avail to Draw for Term Facility    ${GlobalFacCommitmentAmount}    ${NewGlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    ${NewGlobalFacOutstandingAmount}    
     ...    ${GlobalFacAvailtoDrawAmount}    ${NewGlobalFacAvailtoDrawAmount}    &{ExcelPath}[UnscheduledPrincipal_PrincipalAmt]    
    Run Keyword If    '&{ExcelPath}[Facility_Type]'=='Revolver'    Validate New Global Current Cmt, Outstandings, and Avail to Draw for Revolver Facility    ${GlobalFacCommitmentAmount}    ${NewGlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    
    ...    ${NewGlobalFacOutstandingAmount}    ${GlobalFacAvailtoDrawAmount}    ${NewGlobalFacAvailtoDrawAmount}    
    Close All Windows on LIQ
