*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Comprehensive Repricing for Non-Agent Syndicated Deal
    [Documentation]    This keyword is use to add comprehensive repricing for the specified Loan
    ...    @author: jdelacru
    ...    @update: hstone     29MAY2020     - Replaced 'Search Deal' with 'Open Existing Deal'
    ...                                      - Removed 'mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}'
    ...                                      - Removed 'Verify if Status is set to Do It' and replaced with 'Create Cashflow
    ...                                      - Replaced 'Add Days to Date' with 'Add Time from From Date and Returns Weekday'
    ...                                      - Replaced 'Navigate Notebook Workflow' with 'Navigate to Loan Repricing Workflow and Proceed With Transaction'
    ...                                      - Added 'Release Cashflow Based on Remittance Instruction'
    ...                                      - Removed commented codes
    ...                                      - Deleted 'Add Repricing Detail    &{ExcelPath}[Repricing_Add_Option]    ${rowid}    &{ExcelPath}[Pricing_Option]'
    ...                                      - Added 'Add Interest Payment for Loan Repricing    &{ExcelPath}[Cycles_For_Loan]    &{ExcelPath}[Interest_Requested_Amount]'
    ...                                      - Added '${NewLoanAlias}    Add Rollover Conversion to New    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_NewOutstanding]'
    ...                                      - Removed Existing Setup for Repricing
    ...                                      - Removed Scheduled Repricing (since it is not included on the test case)
    ...                                      - Replaced WIP navigations with Deal>Facility>Loan>Loan Repricing Navigations
    ...                                      - Added Login to Original User at the end of the Test Script
    ...    @update: amansuet    15JUN2020    - Updated as Cashflow details is not correct and must only have Lender which in for NonHostBank
    ...    @update: amansuet    18JUN2020    - Replaced hardcoded values and added new keyword to get accurate Cycle Due for trans amount calculation
    ...    @update: amansuet    22JUN2020    - Updated base on the 'Release Cashflow Based on Remittance Instruction' keyword updates
    ...    @update: clanding    13AUG2020    - Updated hard coded values to global variables/dataset value
    [Arguments]    ${ExcelPath}
    
    ###Login to Original User###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Search for Existing Deal###
    Open Existing Deal    &{ExcelPath}[Deal_Name]
    
    ###Search for Existing Outstanding###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    
    ###Select Loan to Reprice###
    Select Loan to Reprice    &{ExcelPath}[Loan_Alias]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]

    ### Add Loan Repricing Details ###
    ${InterestPaymentRequestedAmount}    Add Interest Payment for Loan Repricing    &{ExcelPath}[Cycles_For_Loan]
    ${Cycle_Due_Date}    Get Cycle Due Date for Loan Repricing    &{ExcelPath}[Pricing_Option] ${INTEREST_PAYMENT} (&{ExcelPath}[Loan_Alias])
    ${Calculated_CycleDue}    Get Calculated Cycle Due Amount and Validate    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[AllInRate_Value]    &{ExcelPath}[RateBasis_Days]    ${InterestPaymentRequestedAmount}    &{ExcelPath}[Loan_EffectiveDate]
    ...    ${Cycle_Due_Date}
    ${NewLoanAlias}    ${IncreaseAmount}    Add Rollover Conversion to New    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Base_Rate]    &{ExcelPath}[Loan_NewOutstanding]
    
    ### Compute Lender Share Trans Amount for Cash Flow ###
    ${ComputedLender_InterestPaymentTransAmount}    Compute Lender Share Transaction Amount - Repricing    ${Calculated_CycleDue}    &{ExcelPath}[LenderSharePc1]
    ${ComputedLender_IncreaseTransAmount}    Compute Lender Share Transaction Amount - Repricing    ${IncreaseAmount}    &{ExcelPath}[LenderSharePc1]
    
    ### Cashflows Notebook - Create Cashflows ###
    Navigate to Create Cashflow for Loan Repricing
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]    ${ComputedLender_IncreaseTransAmount}    &{ExcelPath}[Loan_Currency]
    Verify if Method has Remittance Instruction    &{ExcelPath}[Lender1_ShortName]    &{ExcelPath}[Remittance1_Description]    &{ExcelPath}[Remittance1_Instruction]    ${ComputedLender_InterestPaymentTransAmount}    &{ExcelPath}[Loan_Currency]
    
    Create Cashflow    &{ExcelPath}[Lender1_ShortName]    ${RELEASE_TRANSACTION}

    ${SysDate}    Get System Date
    ${AdjustedDueDate}    Add Time from From Date and Returns Weekday    ${SysDate}    &{ExcelPath}[Add_To_SysDate]
    Write Data To Excel    SERV09_LoanRepricing    New_Loan_Alias    ${rowid}    ${NewLoanAlias}
    Write Data To Excel    SERV22_InterestPayments    ScheduledActivityReport_Date    ${rowid}    ${AdjustedDueDate}
    Write Data To Excel    SERV22_InterestPayments    New_Loan_Alias    ${rowid}    ${NewLoanAlias}
    Write Data To Excel    AMCH02_LenderShareAdjustment    New_Loan_Alias    ${rowid}    ${NewLoanAlias}
    Send Loan Repricing for Approval
    
    ### Loan Repricing: Approval and Send to Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Outstanding Select Window
    Navigate to Existing Loan    &{ExcelPath}[OutstandingSelect_Type]     &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Navigate to Loan Pending Tab and Proceed with the Transaction     ${LOAN_REPRICING_FOR_THE_DEAL} &{ExcelPath}[Deal_Name].
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${APPROVAL_STATUS}
    Send to Rate Approval
    
    ### Loan Repricing: Rate Approval, Release Cashflows and Release Loan Repricing ###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Navigate to Outstanding Select Window
    Navigate to Existing Loan    &{ExcelPath}[OutstandingSelect_Type]     &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    Navigate to Loan Pending Tab and Proceed with the Transaction     ${LOAN_REPRICING_FOR_THE_DEAL} &{ExcelPath}[Deal_Name].
    Close Facility Notebook and Navigator Windows
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_APPROVAL_TRANSACTION}

    ### Release Cashflows ###
    Release Cashflow Based on Remittance Instruction    &{ExcelPath}[Remittance1_Instruction]    ${ComputedLender_InterestPaymentTransAmount}|${ComputedLender_IncreaseTransAmount}    &{ExcelPath}[Cashflow_DataType]    ${LOAN_REPRICING}

    ### Release Loan Repricing ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}
    
    Close All Windows on LIQ

    ###Login to Original User###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}