*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Rollover Repayment Schedule for ATM BILAT
    [Documentation]    This is a high-level keyword to Rollover Repayment Schedule for ATM BILAT
    ...    @author: kmagday    11JAN2021    - Initial Create 
    [Arguments]    ${ExcelPath}

    ${Loan_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    1
    ${Loan_RequestedAmount}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    1
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name1]
    Open Existing Loan    ${Loan_Alias}

    ### Create Repricing ###
    Navigate to Create Repricing Window  
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    ${Loan_Alias}

    ### Update the existing Loan ###
    Select Existing Outstandings for Loan Repricing and Update the Requested Amount    ${Loan_Alias}    ${Loan_RequestedAmount}

       
    ### Repricing Notebook - Add > Rolllover/Conversion to New ###  
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options     &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name1]    &{ExcelPath}[Borrower_Name]
    ${Effective_Date}    ${NewLoan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[Loan_RequestedAmount]    &{ExcelPath}[Repricing_Frequency]
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Close RolloverConversion Notebook

    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}    ${NewLoan_Alias}

    ###Add Principal Payment###
    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_RequestedAmount]

    ### Repricing Notebook - Add > Add > Interest Payment ###  
    Add Interest Payment for Loan Repricing

    ### Loan Repricing Workflow Tab  - Send to approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to Do It
    Send Loan Repricing for Approval
    Close All Windows on LIQ

    ### Approve Loan Repricing ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_APPROVAL_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Facility_Name1]
    Approve Loan Repricing
    
    ### Generate Intent Notice ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${GENERATE_INTENT_NOTICES}    ${LOAN_REPRICING}     &{ExcelPath}[Facility_Name1]
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${GENERATE_INTENT_NOTICES} 
    Generate Intent Notices    &{ExcelPath}[Borrower_Name]
    Close Generate Notice Window

    ### Rate Setting ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RATE_SETTING_TRANSACTION}
    Set Base Rate Details    &{ExcelPath}[Base_Rate]    &{ExcelPath}[AcceptRate_FromPricing]
    Send to Rate Approval

    ### Rate Approval ###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_RATE_APPROVAL_STATUS}    ${LOAN_REPRICING}     &{ExcelPath}[Facility_Name1]
    Approve Rate Setting Notice
    
    ### Generate Rate Setting Notice and Release Loan ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Select Item in Work in Process    ${OUTSTANDINGS_TRANSACTION}    ${AWAITING_GENERATE_RATE_SETTING_NOTICES_STATUS}    ${LOAN_REPRICING}    &{ExcelPath}[Facility_Name1]
   
    ### Get the enterprise name from quick partyonboarding sheet because borrower_name doesn't have PRIVATE in name ###
    ${Enterprise_Name}    Read Data From Excel    PTY001_QuickPartyOnboarding    Enterprise_Name    2
    Generate Rate Setting Notices    ${Enterprise_Name}    ${AWAITING_RELEASE_NOTICE_STATUS}

    ### Release Repricing ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${RELEASE_STATUS}

    ### Loan Notebook ###
    Validate Release of Loan Repricing    ${RELEASED_STATUS}
    Close All Windows on LIQ

    ### Validate New Loan Amount ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name1]
    Open Existing Loan    &{ExcelPath}[NewLoan_Alias]
    Validate Loan Amount was Updated after Repricing    &{ExcelPath}[New_LoanAmount]
    
