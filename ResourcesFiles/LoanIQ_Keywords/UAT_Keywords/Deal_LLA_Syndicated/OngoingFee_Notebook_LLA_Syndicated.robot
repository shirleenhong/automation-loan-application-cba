*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***

Update Ongoing Fee for LLA Syndicated Deal
    [Documentation]    This keyword will release the existing ongoing fee in the created deal
    ...    @author: makcamps    12JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}

    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type]

    ### Ongoing Fee Notebook ###
    Enter Line Fee Details    &{ExcelPath}[EffectiveDate]    &{ExcelPath}[ActualDueDate]    &{ExcelPath}[AdjustedDueDate]    
    ...    &{ExcelPath}[CycleFrequency]    &{ExcelPath}[Accrue]    &{ExcelPath}[FloatRateStartDate]    &{ExcelPath}[PayType]

    Save Facility Notebook Transaction
    Close All Windows on LIQ
    
Setup Line Fee in Arrears for LLA Syndicated Deal
    [Documentation]    This keyword will setup Line Fee for LLA Syndicated Deal.
    ...    @author: makcamps    14JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    Navigate Directly to Line Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Run Online Acrual to Line Fee
    Initiate Line Fee Payment for LLA Syndicated Deal    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Effective_Date]
    
    ### Cashflow Notebook - Create Cashflows ###
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDesc]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Lender_RemittanceDesc]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_ShortName]
    
    ###Line Fee Notebook - Send to Approval###
    Send Ongoing Fee Payment to Approval
    
    ###Line Fee Notebook - Generate Intent Notice###
    Generate Intent Notices for Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ###Work In Process###
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    
    ###Ongoing Fee Notebook### 
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Work In Process###  
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    
    ###Ongoing Fee Notebook###
    Release Ongoing Fee Payment
       
    ###Loan IQ Desktop###
    Close All Windows on LIQ