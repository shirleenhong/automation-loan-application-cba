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
    
Pay Line Fee for LLA Syndicated Deal
    [Documentation]    This keyword is used for line fee payment for LLA Syndicated Deal
    ...    @author: makcamps    27JAN2021    - Initial Create
    [Arguments]    ${ExcelPath} 

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    1

    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Ongoing Fee Payment ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]
    Verify Details in Accrual Tab for Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Cycle_StartDate]    &{ExcelPath}[Cycle_EndDate]
    ...    &{ExcelPath}[Cycle_DueDate]    &{ExcelPath}[Expected_CycleDueAmt]    &{ExcelPath}[ProjectedCycleDue]

    Initiate Payment for Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[RequestedAmount]    &{ExcelPath}[Effective_Date]
    
    ### Create Cashflows ###
    Navigate to Payment Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Verify if Method has Remittance Instruction    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Borrower_RemittanceDesc]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Lender_RemittanceDesc]    &{ExcelPath}[Lender_RemittanceInstruction]
    Set All Items to Do It

    ### Generate Intent Notice ###
    Navigate to Payment Workflow and Proceed With Transaction        ${GENERATE_INTENT_NOTICES}
    Select Notices Recipients
    Exit Notice Window

    ### Sending Payment For Approval ###
    Navigate to Payment Workflow and Proceed With Transaction    ${SEND_TO_APPROVAL_STATUS}
    Close All Windows on LIQ

    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ### Payment Approval ####
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Close All Windows on LIQ
    
    ###Loan IQ Desktop###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Release Payment ###
    Navigate Transaction in WIP     ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${ONGOING_FEE_PAYMENT_TRANSACTION}    ${FacilityName}
    Navigate to Payment Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    Close All Windows on LIQ
   
    ### Validation ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]
    Validate Payment Release of Ongoing Line Fee
    Validate After Payment Details on Acrual Tab - Line Fee    &{ExcelPath}[Expected_PaidToDate]    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Expected_CycleDueAmt]
    
Manual Adjustment of Line Fee for LLA Syndicated Deal
    [Documentation]    This keyword is used for adjusting line fee payment for LLA Syndicated Deal
    ...    @author: makcamps    02MAR2021    - Initial Create
    [Arguments]    ${ExcelPath} 

    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    1

    ### LIQ Window ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Ongoing Fee Payment ###
    Navigate to Facility Notebook    ${Deal_Name}    ${FacilityName}
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[Fee_Type]
    Verify Details in Accrual Tab for Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Cycle_StartDate]    &{ExcelPath}[Cycle_EndDate]
    ...    &{ExcelPath}[Cycle_DueDate]    &{ExcelPath}[Expected_CycleDueAmt]    &{ExcelPath}[ProjectedCycleDue]

    ###Accrual Share Adjustment Notebook###
    Navigate Line Fee and Verify Accrual Share Adjustment Notebook    &{ExcelPath}[Cycle_StartDate]    ${Deal_Name}    ${FacilityName}    &{ExcelPath}[Fee_Type]
    ...    &{ExcelPath}[Expected_CycleDueAmt]    &{ExcelPath}[ProjectedCycleDue] 
    Input Requested Amount, Effective Date, and Comment    &{ExcelPath}[RequestedAmount]    &{ExcelPath}[Effective_Date]     &{ExcelPath}[Accrual_Comment]
    Save the Requested Amount, Effective Date, and Comment    &{ExcelPath}[RequestedAmount]    &{ExcelPath}[Effective_Date]     &{ExcelPath}[Accrual_Comment]

    ###Accrual Share Adjustment Notebook - Workflow Items (INPUTTER)###
    Send Adjustment to Approval
    Logout from Loan IQ
    
    ###Accrual Share Adjustment Notebook - Workflow Items (APPROVER)###
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    &{ExcelPath}[WIPTransaction_Type]    ${AWAITING_APPROVAL_STATUS}    &{ExcelPath}[FacilitiesTransaction_Type]     ${Deal_Name}
    Approve Fee Accrual Shares Adjustment
    Logout from Loan IQ
    
    ###Accrual Share Adjustment Notebook - Workflow Items (APPROVER2)###
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    &{ExcelPath}[WIPTransaction_Type]    ${AWAITING_RELEASE_STATUS}    &{ExcelPath}[FacilitiesTransaction_Type]     ${Deal_Name}
    Release Fee Accrual Shares Adjustment
    Close Accrual Shares Adjustment Window
    Logout from Loan IQ
    
    ###Verify the Updates in Accrual Tab###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Launch Existing Facility    ${Deal_Name}    ${FacilityName}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[Fee_Type]
    Validate Manual Adjustment Value in Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[RequestedAmount]
    Validate Cycle Due New Value in Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Expected_CycleDueAmt]     &{ExcelPath}[RequestedAmount]
    Validate Projected EOC Due New Value in Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[ProjectedCycleDue]     &{ExcelPath}[RequestedAmount]
    Validate Line Items Details from Line Fee    &{ExcelPath}[Cycle_EndDate]    &{ExcelPath}[Expected_PaidToDate]    #Expected_PaidToDate value is based on screenshots provided
    Validate Accrual Shares Adjustment Applied Event in Line Fee
    Close All Windows on LIQ
    
Update Facility Fee Expiry Date for LLA Syndicated Deal
    [Documentation]    This high-level keyword updates Ongoing Fee Expiry Date for Facility.
    ...    @author: makcamps    04MAR2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ###LIQ Login###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Read Deal Name, Facility Name and Facility Fee### 
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FacilityName}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name    1

    ###Search Deal and Write Facility Name for ComSee
    Open Existing Deal    ${DealName}
    
    ###Navigate to Line Fee Notebook From Facility###
    Navigate to Facility Notebook from Deal Notebook    ${FacilityName}
    Navigate to Commitment Fee List
    Close Facility Fee List Window
    Navigate to Commitment Fee Notebook    &{ExcelPath}[Fee_Type]
    
    ###Updating Expiry Date on Line Fee Notebook###
    Change Expiry Date of Line Fee    &{ExcelPath}[Cycle_StartDate]
    
    Close All Windows on LIQ
    Logout from Loan IQ