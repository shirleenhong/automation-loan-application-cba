*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Upfront Fee From Drawdown for Bilateral
    [Documentation]    Initiate Upfront Fee From Drawdown for Bilateral(Syndicated) Deals.
    ...    @author: jloretiz    28JUL2020    - initial Create
    [Arguments]    ${Excelpath}
    
    ### Login as Inputter User ###
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open the Existing Closed Deal ###  
    Navigate to Facility Notebook    &{Excelpath}[Deal_Name]    &{Excelpath}[Facility_Name]
    
    ### Open Outstanding Select Window and Create New Outstanding ###
    Navigate to Outstanding Select Window
    ${Loan_Alias}    Input Initial Loan Drawdown Details    &{Excelpath}[Outstanding_Type]    &{Excelpath}[Facility_Name]    
    ...    &{Excelpath}[Borrower_ShortName]    &{Excelpath}[Loan_PricingOption]    &{Excelpath}[Loan_Currency]
    Write Data To Excel    BUPR03_UpfrontFeeDrawdown   Loan_Alias    ${rowid}    ${Loan_Alias}

    ### Input and Validate Initial Loan Drawdown ###
    ${CurrentDate}    Get System Date
    Validate Initial Loan Dradown Details    &{Excelpath}[Facility_Name]    &{Excelpath}[Borrower_ShortName]    &{Excelpath}[Loan_Currency]
    ${AdjustedDueDate}    Input General Loan Drawdown Details    &{Excelpath}[Loan_RequestedAmount]    ${CurrentDate}    sLoan_IntCycleFrequency=&{Excelpath}[Loan_IntCycleFrequency]
    Write Data To Excel    BUPR03_UpfrontFeeDrawdown    Adjusted_Due_Date    ${rowid}    ${AdjustedDueDate}

    ### Add MIS Codes ###
    Add MIS Code in Loan Drawdown    &{Excelpath}[MIS_Code]    &{Excelpath}[MIS_Value]

    ### Add Holiday Calendar ###
    Add Holiday Calendar Date    &{Excelpath}[HolidayCalendar]    &{Excelpath}[HolidayCalendar]    ${TRUE}    &{Excelpath}[Borrower_Intent_Notice]    &{Excelpath}[FXRate_Setting_Notice]
    ...    &{Excelpath}[InterestRate_Setting_Notice]    &{Excelpath}[Effective_Date]    &{Excelpath}[Payment_Advice_Dates]    &{Excelpath}[Billing]

    ### Navigate to Upfront Fee From Borrower ###
    Populate Upfront Fee From Borrower / Agent    &{Excelpath}[Branch]    &{Excelpath}[Fee_Amount]    &{Excelpath}[Loan_Currency]
    Populate Fee Details Window    &{Excelpath}[Fee_Type]    &{Excelpath}[UpfrontFeePayment_Comment]
    Save and Exit Upfront Fee From Borrower / Agent

    ### Loan Drawdown Workflow - Create Cashflow ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Create Cashflows
    Verify if Method has Remittance Instruction    &{Excelpath}[Borrower_ShortName]    &{Excelpath}[Remittance_Description]    &{Excelpath}[Remittance_Instruction]
    Verify if Status is set to Do It    &{Excelpath}[Borrower_ShortName]
    Mx LoanIQ Click    ${LIQ_Cashflows_OK_Button}

    ### Loan Drawdown Workflow - Rate Settin ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Rate Setting
    Set Base Rate Details    None    Y
    
    ### Loan Drawdown Workflow - Send to Approval ###
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Send to Approval
    Close All Windows on LIQ 

    ### Loan Drawdown Workflow - Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Approval
    Close All Windows on LIQ 
    
    ### Loan Drawdown Workflow - Send to Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to an Existing Loan    &{Excelpath}[Deal_Name]    &{Excelpath}[Facility_Name]    ${Loan_Alias}    N    N    Y
    Navigate to Loan Pending Tab and Proceed with the Pending Transaction    Awaiting Send to Rate Approval
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Send to Rate Approval
    Close All Windows on LIQ

    ### Loan Drawdown Workflow - Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Navigate Transaction in WIP    Outstandings    Awaiting Rate Approval    Loan Initial Drawdown    ${Loan_Alias}
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Rate Approval
    Close All Windows on LIQ 

    ### Loan Drawdown Workflow - Drawdown Release ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Navigate to an Existing Loan    &{Excelpath}[Deal_Name]    &{Excelpath}[Facility_Name]    ${Loan_Alias}    N    N    Y
    Navigate to Loan Pending Tab and Proceed with the Pending Transaction    Awaiting Release
    Generate Rate Setting Notices for Drawdown    &{Excelpath}[Borrower_LegalName]    &{Excelpath}[NoticeStatus]
    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release

    ### Validate GL Entries Created ###
    Go To Initial Drawdown GL Entries
    ${HostBank_Debit}    Get GL Entries Amount    &{Excelpath}[Lender_GLPortfolioName]    Debit Amt
    ${Borrower_Credit1}    Get GL Entries Amount    &{Excelpath}[GLShortname_Desc1]    Credit Amt
    ${Borrower_Credit2}    Get GL Entries Amount    &{Excelpath}[GLShortname_Desc2]    Credit Amt
    ${Borrower_TotalCredit}    Add All Amounts    ${Borrower_Credit1}    ${Borrower_Credit2}
    ${Borrower_TotalCredit}    Remove Comma and Convert to Number    ${Borrower_TotalCredit}
    ${Loan_RequestedAmount}    Remove Comma and Convert to Number    &{Excelpath}[Loan_RequestedAmount]
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}    ${Borrower_TotalCredit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${HostBank_Debit}    ${Borrower_TotalCredit}    ${Loan_RequestedAmount}
    
    Close All Windows on LIQ
    Logout from Loan IQ
