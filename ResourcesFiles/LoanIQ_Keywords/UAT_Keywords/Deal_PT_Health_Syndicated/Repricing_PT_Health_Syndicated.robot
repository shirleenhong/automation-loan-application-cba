*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Comprehensive Repricing for PT Health
    [Documentation]    This keyword is to create comprehensive repricing for PT Health
    ...    @author: songchan    - initial create
    ...    @update: songchan    - Add Repricing Date for Rollover conversion
    [Arguments]    ${ExcelPath}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[Loan_Alias]

    ### Create Repricing ###
    Navigate to Create Repricing Window  
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
    
    ### Repricing Notebook - Add > Rolllover/Conversion to New ###  
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options     &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    ${Effective_Date}    ${NewLoan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[Repricing_Date]
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Close RolloverConversion Notebook
    
    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}    ${NewLoan_Alias}
    
    ### Repricing Notebook - Principal Payment ###
    Cick Add in Loan Repricing Notebook
    Select Repricing Detail Add Options - Principal Payment
    
    ### Repricing Notebook - Interest Payment ###  
    Add Interest Payment for Loan Repricing    &{ExcelPath}[Cycles_For_Loan]    &{ExcelPath}[Interest_Requested_Amount]
    
    ### Loan Repricing Workflow Tab  - Send to approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to Do It
    Send Loan Repricing for Approval
    
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[Base_Rate]    &{ExcelPath}[AcceptRate_FromPricing]
    Close All Windows on LIQ

    ### Approve Loan Repricing ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Approve Loan Repricing  

    ### Rate Setting ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_SEND_TO_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}     &{ExcelPath}[Deal_Name]
    Send to Rate Approval

    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}     &{ExcelPath}[Deal_Name]
    Approve Rate Setting Notice

    ### Release Repricing ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Loan Notebook ###
    Validate Release of Loan Repricing    ${RELEASED_STATUS}
    Close All Windows on LIQ

    ### Validate New Loan Amount ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    ${NewLoan_Alias}
    Validate Loan Drawdown Amounts in General Tab    &{ExcelPath}[Expected_LoanGlobalOriginal]    &{ExcelPath}[Expected_LoanGlobalCurrent]    &{ExcelPath}[Expected_LoanHostBankGross]    &{ExcelPath}[Expected_LoanHostBankNet]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expected_LoanCurrentBaseRate]    &{ExcelPath}[Expected_LoanSpread]    &{ExcelPath}[Expected_LoanAllInRate]
    Validate Repricing Loan from Facility     &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[New_LoanAmount]