*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Initial Loan Drawdown for Non Agent Syndication
    [Documentation]    This keyword is used to creat an initial loan drawdown with repayment schedule for a non-agent syndication
    ...    @update: hstone    19MAY2020    - Replaced 'Add Days to Date' with 'Add Time from From Date and Returns Weekday'
    ...                                    - Replaced 'Should Be Equal As Numbers' with 'Compare Two Numbers'
    ...                                    - Added user logout and login as INPUTTER_USERNAME at the end of the test case
    ...    @update: hstone    22MAY2020    - Removed '${Loan_Alias}    Read Data From Excel    SERV02_LoanDrawdownNonAgent    Loan_Alias    ${rowid}'
    ...    @update: clanding    10AUG2020    - updated hard coded values to dataset/global variables; removed Create Principal Repayment Schedule as per scenario review
    ...    @update: clanding    13AUG2020    - added writing of Loan_Alias and Loan_EffectiveDate to SERV09_LoanRepricing
    [Arguments]    ${ExcelPath}
    
    ###Upfront Fee Payment Workflow Tab- Release Item###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ###Facility###
    ${Loan_EffectiveDate}    Get System Date
    ${Loan_TriggerDate}    Add Time from From Date and Returns Weekday    ${Loan_EffectiveDate}    &{ExcelPath}[Add_To_Loan_EffectiveDate]
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]

    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    SERV02_LoanDrawdownNonAgent    Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}
    Write Data To Excel    SERV02_LoanDrawdownNonAgent    Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}
    Write Data To Excel    SERV02_LoanDrawdownNonAgent    Loan_EffectiveDate    ${rowid}    ${Loan_EffectiveDate}
    Write Data To Excel    SERV09_LoanRepricing    Loan_EffectiveDate    ${rowid}    ${Loan_EffectiveDate}
    
    ###Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]    
    Write Data To Excel    SERV02_LoanDrawdownNonAgent    Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    SERV22_InterestPayments    Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    AMCH02_LenderShareAdjustment    New_Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    SERV09_LoanRepricing    Loan_Alias    ${rowid}    ${Loan_Alias}
    
    ###Initial Loan Drawdown###
    Validate Initial Loan Dradown Details    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_Currency]
    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    ${Loan_EffectiveDate}    &{ExcelPath}[Loan_MaturityDate]
    ...    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_IntCycleFrequency]    ${TO_THE_ACTUAL_DUE_DATE}

    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    ###Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Lender_Remittance_Instruction]
    Create Cashflow   &{ExcelPath}[Lender_ShortName]    ${RELEASE_TRANSACTION}
    
    ###Loan Drawdown - Workflow Tab####
    Send Loan Drawdown to Approval
    
    ###WorkInProcess####
    Approve Loan Drawdown via WIP LIQ Icon    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_OutstandingType]    ${Loan_Alias}

    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_SEND_TO_RATE_APPROVAL_STATUS}    ${LOAN_INITIAL_DRAWDOWN_TYPE}     ${Loan_Alias}

    ###Loan Drawdown - Workflow Tab####
    Send Loan Drawdown Rates to Approval
    
    ###LIQ Desktop####
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
	    
    ###WorkInProcess###
	Open Loan Initial Drawdown Notebook via WIP - Awaiting Rate Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingRateApprovalStatus]    &{ExcelPath}[WIP_OutstandingType]    ${Loan_Alias}
	Navigate to Loan Drawdown Workflow and Proceed With Transaction    ${RATE_APPROVAL_TRANSACTION}

    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Lender_Remittance_Instruction]    &{ExcelPath}[Lender_ShortName]
    
    Release Loan Initial Drawdown
    
    ##Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]

    ${CurrentCmtAmt}    Get Current Commitment Amount
    
    ###Facility Global Outstandings Validation#####
    ${NewGlobalOutstandings}    Get New Facility Global Outstandings
    ${Computed_GlobalOutstandings}    Compute New Global Outstandings     &{ExcelPath}[Facility_CurrentGlobalOutstandings]    &{ExcelPath}[Loan_RequestedAmount]
    Compare Two Numbers    ${Computed_GlobalOutstandings}    ${NewGlobalOutstandings}
    
    ####Facility Available to Draw Validation####
    ${NewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${Computed_AvailToDrawAmt}    Compute New Facility Available to Draw Amount    &{ExcelPath}[Facility_CurrentAvailToDraw]    &{ExcelPath}[Loan_RequestedAmount]
    Compare Two Numbers    ${Computed_AvailToDrawAmt}    ${NewAvailToDrawAmount}    
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
