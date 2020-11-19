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
    ...    @update: fluberio    29OCT2020    - added condition for setting the RowId based on the given pricing option, Added the Set FX Rates
    ...    @update: fluberio    30OCT2020    - added condition for EU to get the latest value in Excel, added the conversion of the Request amount based on the Loan Currency
    ...                                      - added keywords to removed decimals number upon comparing actual and expected amounts 
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
    
    ${rowid}    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Get the Row Id for Given Pricing Option    &{ExcelPath}[Loan_PricingOption]
    
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
    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU' and '&{ExcelPath}[Loan_PricingOption]' != 'Euro LIBOR Option'    Set FX Rates Loan Drawdown    &{ExcelPath}[Loan_Currency]    Spot
    
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
    
    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Close All Windows on LIQ
    
    ##Facility###
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]

    ${CurrentCmtAmt}    Get Current Commitment Amount
    ${Loan_Alias}    Read Data From Excel    SERV02_LoanDrawdownNonAgent    Loan_Alias    ${rowid}
    ${CovertedLoanRequested_Amount}    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU' and '&{ExcelPath}[Loan_PricingOption]' != 'Euro LIBOR Option'    Convert Loan Requested Amount Based On Currency FX Rate    &{ExcelPath}[Facility_Currency]    &{ExcelPath}[Loan_Currency]    &{ExcelPath}[Loan_RequestedAmount]    ${Loan_Alias}    &{ExcelPath}[Outstanding_Type]    &{ExcelPath}[Facility_Name]    ${Loan_EffectiveDate}
    ...    ELSE    Read Data From Excel    SERV02_LoanDrawdownNonAgent    Loan_RequestedAmount    ${rowid}
    ${Excel_FacilityCurrentGlobalOutstandings}    Read Data From Excel    SERV02_LoanDrawdownNonAgent    Facility_CurrentGlobalOutstandings    ${rowid}
    
    ###Facility Global Outstandings Validation#####
    ${NewGlobalOutstandings}    Get New Facility Global Outstandings
    ${Computed_GlobalOutstandings}    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Compute New Global Outstandings     ${Excel_FacilityCurrentGlobalOutstandings}    ${CovertedLoanRequested_Amount}
    ...    ELSE    Compute New Global Outstandings     &{ExcelPath}[Facility_CurrentGlobalOutstandings]    &{ExcelPath}[Loan_RequestedAmount]
    ${NewGlobalOutstandings}    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Split the Value with Decimal and Return the Whole Number    ${NewGlobalOutstandings}
    ${Computed_GlobalOutstandings}    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Split the Value with Decimal and Return the Whole Number    ${Computed_GlobalOutstandings}
    Compare Two Numbers    ${Computed_GlobalOutstandings}    ${NewGlobalOutstandings}
    
    ${Excel_FacilityCurrentAvailToDraw}    Read Data From Excel    SERV02_LoanDrawdownNonAgent    Facility_CurrentAvailToDraw    ${rowid}
    ####Facility Available to Draw Validation####
    ${NewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${Computed_AvailToDrawAmt}    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Compute New Facility Available to Draw Amount    ${Excel_FacilityCurrentAvailToDraw}    ${CovertedLoanRequested_Amount}
    ...    ELSE    Compute New Facility Available to Draw Amount    &{ExcelPath}[Facility_CurrentAvailToDraw]    &{ExcelPath}[Loan_RequestedAmount]
    ${NewAvailToDrawAmount}    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Split the Value with Decimal and Return the Whole Number    ${NewAvailToDrawAmount}
    ${Computed_AvailToDrawAmt}    Run Keyword If   '${SCENARIO}'=='4' and '&{ExcelPath}[Entity]' == 'EU'    Split the Value with Decimal and Return the Whole Number    ${Computed_AvailToDrawAmt}
    Compare Two Numbers    ${Computed_AvailToDrawAmt}    ${NewAvailToDrawAmount}    
    
    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
