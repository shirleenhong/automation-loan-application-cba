*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Process Outgoing Cash Movements Outside of Transaction Notebooks Using a New or Existing WIP
    [Documentation]    This keyword is used to Process Outgoing Cash Movements Outside of Transaction Notebooks Using a New or Existing WIP.
    ...    @author: hstone      07JUL2020      - Initial Create
    [Arguments]    ${ExcelPath}

    ### Login As Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Create Outgoing Manual Cashflow ###
    Navigate to Manual Cashflow Select
    Launch Outgoing Manual Cashflow Notebook
    Populate Outgoing Manual Cashflow Notebook - General Tab    &{ExcelPath}[Branch_Code]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Currency]
    ...    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[Description]    &{ExcelPath}[Processing_Area]   &{ExcelPath}[Deal_ExpenseCode]
    ...    &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[Customer_ServicingGroup]    &{ExcelPath}[Branch_ServicingGroup]
    ...    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
    Add Debit Offset in Outgoing Manual Cashflow Notebook    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[GL_ShortName]    &{ExcelPath}[Portfolio_Code]
    Save and Validate Data in Outgoing Manual Cashflow Notebook    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[GL_ShortName]   &{ExcelPath}[Deal_ExpenseCode]
    Navigate to Cashflow in Outgoing Manual Cashflow Notebook
    Verify if Method has Remittance Instruction    &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[Borrower_RemittanceDescription]    &{ExcelPath}[Borrower_RemittanceInstruction]
    Verify if Status is set to Do It    &{ExcelPath}[Deal_Borrower]
    Click OK In Cashflows
    Send Outgoing Manual Cashflow to Approval
    Close All Windows on LIQ
    
    ### Login As Supervisor ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ### Approve Outgoing Manual Cashflow ###
    Navigate Transaction in WIP    ManualTrans    Awaiting Approval    Manual Cashflow Transaction    &{ExcelPath}[Deal_Name]
    Approve Outgoing Manual Cashflow to Approval
    Close All Windows on LIQ

    ### Login As Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Release Outgoing Manual Cashflow ###
    Navigate to Manual Cashflow Select
    Open Existing Outgoing Manual Cashflow Notebook    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[OutgoingManualCashflowDesc_AwaitingRelease]
    Release Cashflows for Outgoing Manual Cashflow    &{ExcelPath}[Deal_Borrower]
    Release Outgoing Manual Cashflow

    ### Validate Outgoing Manual Cashflow ###
    Validate Debit Offset Detail at Outgoing Manual Cashflow Table    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[Expected_GLShortName]    &{ExcelPath}[Expected_ExpenseCode]
    Validate GL Entries in Outgoing Manual Cashflow Notebook    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[GL_Entries_RIMethod]    &{ExcelPath}[GL_Entries_ShortName]
    Close All Windows on LIQ