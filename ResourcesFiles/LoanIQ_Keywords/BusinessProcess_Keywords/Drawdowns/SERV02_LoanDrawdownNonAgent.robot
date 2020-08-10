*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Initial Loan Drawdown with Repayment Schedule for Non Agent Syndication
    [Documentation]    This keyword is used to creat an initial loan drawdown with repayment schedule for a non-agent syndication
    ...    @update: hstone    19MAY2020    - Replaced 'Add Days to Date' with 'Add Time from From Date and Returns Weekday'
    ...                                    - Replaced 'Should Be Equal As Numbers' with 'Compare Two Numbers'
    ...                                    - Added user logout and login as INPUTTER_USERNAME at the end of the test case
    ...    @update: hstone    22MAY2020    - Removed '${Loan_Alias}    Read Data From Excel    SERV02_LoanDrawdownNonAgent    Loan_Alias    ${rowid}'
    [Arguments]    ${ExcelPath}
    
    ###Upfront Fee Payment Workflow Tab- Release Item###
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
        
    ###Facility###
    ${Loan_EffectiveDate}    Get System Date
    ${Loan_TriggerDate}    Add Time from From Date and Returns Weekday    ${Loan_EffectiveDate}    30
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]

    ${AvailToDrawAmount}    Get Facility Global Available to Draw Amount
    ${GlobalOutstandings}    Get Facility Global Outstandings
    Write Data To Excel    SERV02_LoanDrawdownNonAgent    Facility_CurrentAvailToDraw    ${rowid}    ${AvailToDrawAmount}
    Write Data To Excel    SERV02_LoanDrawdownNonAgent    Facility_CurrentGlobalOutstandings    ${rowid}    ${GlobalOutstandings}
    Write Data To Excel    SERV02_LoanDrawdownNonAgent    Loan_EffectiveDate    ${rowid}    ${Loan_EffectiveDate}
    
    ###Outstanding Select Window###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_Currency]    
    Write Data To Excel    SERV02_LoanDrawdownNonAgent    Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    SERV22_InterestPayments    Loan_Alias    ${rowid}    ${Loan_Alias}
    Write Data To Excel    AMCH02_LenderShareAdjustment    Loan_Alias    ${rowid}    ${Loan_Alias}
    
    ###Initial Loan Drawdown###
    Validate Initial Loan Dradown Details    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_ShortName]    &{ExcelPath}[Loan_Currency]
    Input General Loan Drawdown Details    &{ExcelPath}[Loan_RequestedAmount]    ${Loan_EffectiveDate}    &{ExcelPath}[Loan_MaturityDate]
    ...    &{ExcelPath}[Loan_RepricingFrequency]    &{ExcelPath}[Loan_IntCycleFrequency]    to the actual due date

    Input Loan Drawdown Rates    &{ExcelPath}[Borrower_BaseRate]    &{ExcelPath}[Facility_Spread]
    
    ###Repayment Schedule###
    Create Principal Repayment Schedule    &{ExcelPath}[Repayment_ScheduleFrequency]    &{ExcelPath}[Repayment_NumberOfCycles]    ${Loan_EffectiveDate}    &{ExcelPath}[Repayment_NonBusDayRule]    &{ExcelPath}[Loan_RequestedAmount]
    
    ###Cashflows###
    Navigate to Drawdown Cashflow Window
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender_ShortName]    &{ExcelPath}[Remittance_Description]    &{ExcelPath}[Lender_Remittance_Instruction]
    Create Cashflow   &{ExcelPath}[Lender_ShortName]    release
    
    ###Loan Drawdown - Workflow Tab####
    Send Loan Drawdown to Approval
    
    ###WorkInProcess####
    Approve Loan Drawdown via WIP LIQ Icon    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingApprovalStatus]    &{ExcelPath}[WIP_OutstandingType]    ${Loan_Alias}

    ###Rate Approval###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Select Item in Work in Process    Outstandings    Awaiting Send to Rate Approval    Loan Initial Drawdown     ${Loan_Alias}

    ###Loan Drawdown - Workflow Tab####
    Send Loan Drawdown Rates to Approval
    
    ###LIQ Desktop####
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
	    
    ###WorkInProcess###
	Open Loan Initial Drawdown Notebook via WIP - Awaiting Rate Approval    &{ExcelPath}[WIP_TransactionType]    &{ExcelPath}[WIP_AwaitingRateApprovalStatus]    &{ExcelPath}[WIP_OutstandingType]    ${Loan_Alias}
	Navigate to Loan Drawdown Workflow and Proceed With Transaction    Rate Approval

    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Lender_Remittance_Instruction]    &{ExcelPath}[Lender_ShortName]
    
    Release Loan Initial Drawdown
    
    ##Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]

    Get Current Commitment Amount
    
    ###Facility Global Outstandings Validation#####
    ${NewGlobalOutstandings}    Get New Facility Global Outstandings
    ${Computed_GlobalOutstandings}    Compute New Global Outstandings     &{ExcelPath}[Facility_CurrentGlobalOutstandings]    &{ExcelPath}[Loan_RequestedAmount]
    Compare Two Numbers    ${Computed_GlobalOutstandings}    ${NewGlobalOutstandings}
    
    ####Facility Available to Draw Validation####
    ${NewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${Computed_AvailToDrawAmt}    Compute New Facility Available to Draw Amount    &{ExcelPath}[rowid]    &{ExcelPath}[Facility_CurrentAvailToDraw]    &{ExcelPath}[Loan_RequestedAmount]
    Compare Two Numbers    ${Computed_AvailToDrawAmt}    ${NewAvailToDrawAmount}    
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
