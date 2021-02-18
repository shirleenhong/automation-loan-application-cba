*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Setup Line Fee in Advance for ATM BILAT
    [Documentation]    This keyword collects the line fee payment of the facility.
    ...    @author: ccarriedo    02FEB2021    - Intial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED08_OngoingFeeSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Facility_Name2}    Read Data From Excel    CRED08_OngoingFeeSetup    Facility_Name2    &{ExcelPath}[rowid]
    ${OngoingFee_Type1}    Read Data From Excel    CRED08_OngoingFeeSetup    OngoingFee_Type1    &{ExcelPath}[rowid]
    ${OngoingFee_AccrualRule}    Read Data From Excel    CRED08_OngoingFeeSetup    OngoingFee_AccrualRule    &{ExcelPath}[rowid]
    
    ### Open Deal Notebook If Not present ###
    Open Deal Notebook If Not Present    ${Deal_Name}
        
    ### Launch Facility ###
    Launch Existing Facility    ${Deal_Name}    ${Facility_Name2}
    
    ### Ongoing Fee - Update Details ###
    Navigate to Existing Ongoing Fee Notebook    ${OngoingFee_Type1}

    Update Ongoing Fee General Information    &{ExcelPath}[OngoingFee_EffectiveDate]    &{ExcelPath}[OngoingFee_ActualDate]    &{ExcelPath}[OngoingFee_AdjustedDueDate]    &{ExcelPath}[OngoingFee_Accrue]    &{ExcelPath}[OngoingFee_AccrualEndDate]
    Select Pay In Advance/Arrears    ${OngoingFee_AccrualRule}
    
    ${OngoingFee_EffectiveDate}    ${OngoingFee_AccrualEndDate}    ${OngoingFee_DueDate}    Navigate and Verify Line Fee Accrual Tab    &{ExcelPath}[OngoingFee_CycleNo]
 
    Save and Close Ongoing Fee Window
    Close All Windows on LIQ
    Logout from Loan IQ

Release Ongoing Fee for ATM BILAT
    [Documentation]    This keyword will release the existing ongoing fee in the created deal
    ...    @author: ccarriedo    02FEB2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]
    ${Facility_Name}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name2    &{ExcelPath}[rowid]

    ### Login to LIQ ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Navigate to Facility Notebook    ${Deal_Name}    ${Facility_Name}
    Navigate to Commitment Fee Notebook    &{ExcelPath}[OngoingFee_Type1]

    ### Ongoing Fee Notebook ###
    Release Ongoing Fee

    Validate Line Fee Events Tab    ${RELEASED_STATUS}
    
    Save Facility Notebook Transaction
    Close All Windows on LIQ
    Logout from Loan IQ
    
Pay Line Fee with Online Accrual for Facility ATM
    [Documentation]    This keyword will setup an online accrual and payment for Line Fee
    ...    @author: ccarriedo    17FEB2021    - initial create
    [Arguments]    ${ExcelPath}
    
    ### LIQ Window ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Run Online Accrual###
    Search Existing Deal    &{ExcelPath}[Deal_Name]    
    Navigate Directly to Line Fee Notebook from Deal Notebook    &{ExcelPath}[Facility_Name2]
    Run Online Acrual to Line Fee

    ###Validate Online Accrual and Initiate Line Fee Payment###
    Navigate to Facility Notebook   &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name2]
    Navigate to Existing Ongoing Fee Notebook    &{ExcelPath}[OngoingFee_Type2]
    Verify Details in Accrual Tab for Line Fee    &{ExcelPath}[Cycle_Number]    &{ExcelPath}[Cycle_StartDate]    &{ExcelPath}[Cycle_EndDate]
    ...    &{ExcelPath}[Cycle_DueDate]    &{ExcelPath}[Expected_CycleDueAmt]    &{ExcelPath}[ProjectedCycleDue]    

    Close All Windows on LIQ

Collect Full Prepayment via Paper Clip for Facility ATM
    [Documentation]    This is a high-level keyword to collect full prepayment via paperclip and Generate Intent Notice
    ...    @author: ccarriedo    17FEB2021    - initial create    
    [Arguments]    ${ExcelPath}

    ${Deal_Name}    Read Data From Excel    CRED02_FacilitySetup    Deal_Name    ${rowid}
    ${Facility_Name}    Read Data From Excel    CRED02_FacilitySetup    Facility_Name2    ${rowid}
    ${Outstanding_Type}    Read Data From Excel    SERV01_LoanDrawdown    Outstanding_Type    2
    ${Borrower_Name}    Read Data From Excel    CRED02_FacilitySetup    Facility_Borrower2    ${rowid}
    ${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    2

    ### Open Loan Notebook ###
    Search for Deal    ${Deal_Name}
    Search for Existing Outstanding    ${Outstanding_Type}    ${Facility_Name}
    Open Existing Loan    ${Loan_Alias}
    
    ### Payment Window ###
    Navigate to Choose a Payment Window
    Select Payment in Choose a Payment Window    &{ExcelPath}[Payment_Type]

    ### Paper Clip Window ###
    Add Transaction to Pending Paperclip    &{ExcelPath}[Paperclip_EffectiveDate]    &{ExcelPath}[Paperclip_TransactionDescription]
    
    ### Cycles for Loan Window ###
    Select Multiple Cycles Item     &{ExcelPath}[Paperclip_Name_Alias]    &{ExcelPath}[Cycles_ForLoan]    &{ExcelPath}[Loan_DueDates]    &{ExcelPath}[Delimiter]
    
    Verify Added Paperclip Payments    ${Facility_Name}${SPACE}&{ExcelPath}[Paperclip_Name_Alias]|${Facility_Name}${SPACE}&{ExcelPath}[Paperclip_Name_Alias]
    
    Validate Total Amount of Prepayment on Paper Clip    &{ExcelPath}[Paperclip_Total_Prepayment_Amount]
    
    ### Create Cashflows ###
    Navigate to Create Cashflow for Paperclip
    Verify if Method has Remittance Instruction    ${Borrower_Name}    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Remittance_Instruction]    
    Verify if Status is set to Do It    ${Borrower_Name}  
    Navigate to GL Entries
    Close GL Entries and Cashflow Window
    
    ### Generate Intent Notice ###
    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    ${GENERATE_INTENT_NOTICES} 
    Generate Intent Notices    ${Borrower_Name}
    Close Generate Notice Window
    
    ### Send for Approval and Approve ###
    Send Paperclip Payment for Approval
    Logout from Loan IQ
    
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${PAPER_CLIP}    ${Deal_Name}
    Approve Paperclip
    
    ### Release Paperclip Transaction ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${PAYMENTS_TRANSACTION}    ${AWAITING_RELEASE_STATUS}    ${PAPER_CLIP}    ${Deal_Name}
    Release Paperclip Transaction
    
    ### Validate Release ###
    Validate Release of Paper Clip Payment
    Close All Windows on LIQ

    Logout from Loan IQ
    