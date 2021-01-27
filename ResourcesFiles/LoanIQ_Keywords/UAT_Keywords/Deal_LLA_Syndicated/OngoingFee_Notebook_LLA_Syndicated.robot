*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Variables ***
${SCENARIO}

*** Keywords ***

Update Ongoing Fee for LLA Syndicated Deal
    [Documentation]    This keyword will release the existing ongoing fee in the created deal
    ...    @author: makcamps    12JAN2021    - Initial Create
    ...    @update: makcamps    15JAN2021    - updated data used to get from data set
    ...                                      - removed releasing of fee as it is expected to be automatically released after close
    ...                                      - added updating of line fee details
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
    ...    @update: makcamps    20JAN2021    - removed closing of all windows
    ...    @update: makcamps    22JAN2021    - added validation of successful line fee and fixed comments
    [Arguments]    ${ExcelPath}
    
    ###Run Online Accrual###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    Navigate Directly to Line Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Run Online Acrual to Line Fee
    
    ###Initiate Line Fee Payment###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    Navigate Directly to Line Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name]
    Initiate Line Fee Payment for LLA Syndicated Deal    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Effective_Date]
    
    ###Cashflow Notebook - Create Cashflows###
    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    Create Cashflows
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDesc]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Lender_RemittanceDesc]    &{ExcelPath}[Lender_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Borrower_ShortName]
    Verify if Status is set to Do It    &{ExcelPath}[Lender_ShortName]
    
    ###Send Line Fee Payment to Approval###
    Send Ongoing Fee Payment to Approval
    
    ###Generate Intent Notice for Line Fee Notebook###
    Generate Intent Notices for Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ###Approve Line Fee Payment###
    Navigate Work in Process for Ongoing Fee Payment Approval    &{ExcelPath}[Facility_Name]
    Approve Ongoing Fee Payment
    
    ###Loan IQ Desktop###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    ###Release Line Fee Payment###
    Navigate Work in Process for Ongoing Fee Payment Release    &{ExcelPath}[Facility_Name]
    Release Ongoing Fee Payment
    Close All Windows on LIQ
    
    ###Validate Released Line Fee Payment###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    Open Ongoing Fee from Deal Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[OngoingFee_Type]
    Validate After Payment Details on Acrual Tab - Line Fee    &{ExcelPath}[Expected_PaidToDate]    &{ExcelPath}[CycleNumber]    &{ExcelPath}[Expected_CycleDueAmt]
    Validate Release of Ongoing Line Fee Payment
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}