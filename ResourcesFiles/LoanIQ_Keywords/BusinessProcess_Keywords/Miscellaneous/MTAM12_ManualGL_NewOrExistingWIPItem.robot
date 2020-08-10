*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Process Manual GL of Transaction Notebooks Using a New or Existing WIP
    [Documentation]    This keyword is used to Process Outgoing Cash Movements Outside of Transaction Notebooks Using a New or Existing WIP.
    ...    @author: hstone      07JUL2020      - Initial Create
    [Arguments]    ${ExcelPath}

    ### Login As Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Create Manual GL ###
    Navigate to Manual GL
    New Manual GL Select
    Enter Manual GL Details    &{ExcelPath}[Processing_Area]    &{ExcelPath}[Currency]    &{ExcelPath}[Branch_Code]
    ...    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Description]
    Add Debit for Manual GL    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Debit_GL_ShortName]    &{ExcelPath}[Debit_Type]
    ...    &{ExcelPath}[Debit_Amount]    &{ExcelPath}[Debit_ExpenseCode]    &{ExcelPath}[Debit_PortfolioCode]    &{ExcelPath}[Debit_SecurityID_SelectionType]
    Add Credit for Manual GL    &{ExcelPath}[Credit_FeeAmount]    &{ExcelPath}[Credit_GL_ShortName]    &{ExcelPath}[Credit_ExpenseCode]
    ...    &{ExcelPath}[Credit_Type]    &{ExcelPath}[Credit_PortfolioCode]    &{ExcelPath}[Credit_SecurityID_SelectionType]    &{ExcelPath}[Deal_Name]
    Add Manual GL Transaction Description    &{ExcelPath}[Test_Case]
    Save Manual GL Changes
    Send Manual GL to Approval
    Close All Windows on LIQ

    ### Login As Supervisor ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}

    ### Approve Incoming Manual Cashflow ###
    Navigate Transaction in WIP    ManualTrans    Awaiting Approval    Manual GL Transaction    &{ExcelPath}[Deal_Name]
    Approve Manual GL
    Close All Windows on LIQ

    ### Login As Inputter ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}

    ### Release Manual GL ###
    Navigate to Manual GL
    Open Existing Manual GL Notebook    &{ExcelPath}[Effective_Date]    &{ExcelPath}[Effective_Date]    &{ExcelPath}[ManualGLDesc_AwaitingRelease]
    Release Manual GL

    ### Validate Manual GL ###
    Validate Debit Details at Manual GL Table    &{ExcelPath}[Debit_Amount]    &{ExcelPath}[DebitDetails_Expected_GLShortName]    &{ExcelPath}[DebitDetails_Expected_ExpenseCode]
    Validate Credit Details at Manual GL Table    &{ExcelPath}[Credit_FeeAmount]    &{ExcelPath}[CreditDetails_Expected_GLShortName]    &{ExcelPath}[CreditDetails_Expected_ExpenseCode]
    Validate GL Entries    &{ExcelPath}[Credit_Account]    &{ExcelPath}[Deal_Borrower]    &{ExcelPath}[Debit_GL_ShortName]
    Close All Windows on LIQ