*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Process Incoming Cash Movements Outside of Transaction Notebooks Using a New or Existing WIP
    [Documentation]    This keyword is used to Process Incoming Cash Movements Outside of Transaction Notebooks Using a New or Existing WIP.
    ...    @author: hstone      17JUN2020      - Initial Create
    [Arguments]    ${ExcelPath}

    ### Login As Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Create Incoming Manual Cashflow ###
    Navigate to Manual Cashflow Select
    Launch Incoming Manual Cashflow Notebook
    Populate Incoming Manual Cashflow Notebook - General Tab    &{ExcelPath}[Branch_Code]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Currency]
    ...    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[Description]    &{ExcelPath}[Processing_Area]   &{ExcelPath}[Deal_ExpenseCode]
    ...    &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[Customer_ServicingGroup]    &{ExcelPath}[Branch_ServicingGroup]
    ...    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Add Credit Offset in Incoming Manual Cashflow Notebook    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[GL_ShortName]    &{ExcelPath}[Portfolio_Code]
    Save and Validate Data in Incoming Manual Cashflow Notebook    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[GL_ShortName]   &{ExcelPath}[Deal_ExpenseCode]
    Navigate to Cashflow in Incoming Manual Cashflow Notebook
    Verify if Method has Remittance Instruction    &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Deal_Borrower]
    Click OK In Cashflows
    Send Incoming Manual Cashflow to Approval
    Close All Windows on LIQ
    
    ### Login As Supervisor ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ### Approve Incoming Manual Cashflow ###
    Navigate Transaction in WIP    ManualTrans    Awaiting Approval    Manual Cashflow Transaction    &{ExcelPath}[Deal_Name]
    Approve Incoming Manual Cashflow to Approval
    Close All Windows on LIQ

    ### Login As Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Release Incoming Manual Cashflow ###
    Navigate to Manual Cashflow Select
    Open Existing Incoming Manual Cashflow Notebook    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[IncomingManualCashflowDesc_AwaitingRelease]
    Release Cashflows for Incoming Manual Cashflow    &{ExcelPath}[Deal_Borrower]
    Release Incoming Manual Cashflow

    ### Validate Incoming Manual Cashflow ###
    Validate Credit Offset Detail at Incoming Manual Cashflow Table    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[Expected_GLShortName]    &{ExcelPath}[Expected_ExpenseCode]
    Validate GL Entries in Incoming Manual Cashflow Notebook    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[GL_Entries_RIMethod]    &{ExcelPath}[GL_Entries_ShortName]
    Close All Windows on LIQ