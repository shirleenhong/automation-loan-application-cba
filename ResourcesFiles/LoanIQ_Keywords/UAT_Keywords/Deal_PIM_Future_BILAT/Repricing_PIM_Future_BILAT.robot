*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Comprehensive Repricing for PIM Future BILAT
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for PIM Future BILAT
    ...    @author: mcastro    14DEC2020    - Initial Create    
    [Arguments]    ${ExcelPath}

    ${Rollover_Amount}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    ${rowid}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[Loan_Alias]

    ### Loan Capitalization Window ###
    Enter Capitalize Interest Percent of Payment    &{ExcelPath}[Capitalize_PercentOfPayment]  

    ### Create Repricing ###
    Navigate to Create Repricing Window  
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[Loan_Alias]
       
    ### Repricing Notebook - Setup Repricing ###  
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options     &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    ${Effective_Date}    ${NewLoan_Alias}    Set RolloverConversion Notebook General Details    ${Rollover_Amount}    &{ExcelPath}[Repricing_Frequency]
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Close RolloverConversion Notebook

    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}    ${NewLoan_Alias}
    Write Data To Excel    Correspondence    Loan_Alias    4    ${NewLoan_Alias}
    Write Data To Excel    Correspondence    Loan_Alias    5    ${NewLoan_Alias}

    ### Adding of Interest Payment ###
    Add Interest Payment for Loan Repricing

    ### Loan Repricing Workflow Tab  - Send to approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Validate Cashflow Error is Displayed
    Send Loan Repricing for Approval
    Close All Windows on LIQ

    ### Approve Loan Repricing ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Approve Loan Repricing
    
    ### Generate Intent Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${GENERATE_INTENT_NOTICES}    ${LOAN_REPRICING}     &{ExcelPath}[Deal_Name]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES} 
    Generate Intent Notices    &{ExcelPath}[Borrower_Name]
    Close Generate Notice Window

    ### Rate Setting ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    None    &{ExcelPath}[AcceptRate_FromPricing]
    Send to Rate Approval

    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}     &{ExcelPath}[Deal_Name]
    Approve Rate Setting Notice
    
    ### Generate Rate Setting Notice and Release Loan ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Deal_Name]
    Generate Rate Setting Notices    &{ExcelPath}[Borrower_Name]    ${AWAITING_RELEASE_NOTICE_STATUS}
    
    ### Release Repricing ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Loan Notebook ###
    Validate Release of Loan Repricing    ${RELEASED_STATUS}
    Close All Windows on LIQ

    ### Validate New Loan Amount ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[NewLoan_Alias]
    Validate Loan Amount was Updated after Repricing    &{ExcelPath}[New_LoanAmount]

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    