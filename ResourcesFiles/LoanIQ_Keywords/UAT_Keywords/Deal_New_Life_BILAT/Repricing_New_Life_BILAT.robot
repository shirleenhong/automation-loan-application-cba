*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Comprehensive Repricing for New Life BILAT
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for New Life BILAT
    ...    @author: kmagday    11JAN2021    - Initial Create 
    ...    @update: kmagday    13JAN2021    - added writing of NewLoan_ALias in SERV08_ComprehensiveRepricing sheet
    [Arguments]    ${ExcelPath}

    ${Rollover_Amount}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    ${rowid}

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
    ${Effective_Date}    ${NewLoan_Alias}    Set RolloverConversion Notebook General Details    ${Rollover_Amount}    &{ExcelPath}[Repricing_Frequency]
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Close RolloverConversion Notebook

    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}    ${NewLoan_Alias}

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
    Set Base Rate Details    &{ExcelPath}[Base_Rate]    &{ExcelPath}[AcceptRate_FromPricing]
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
    
Loan Combine and Rollover
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for New Life BILAT
    ...    @author: kmagday    18JAN2021    - Initial Create 
    [Arguments]    ${ExcelPath}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
   
    ### get the loans from the excel sheet and split it ###
    ${ExistingLoans}    Split String and Return as a List   &{ExcelPath}[CombineExistingLoans]    &{ExcelPath}[Delimiter]    

    ### open existing loan then navigate to repricing and select the 2 loans ###
    Select Loan to Reprice   @{ExistingLoans}[0]
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Multiple Loan to Merge    @{ExistingLoans}[0]    @{ExistingLoans}[1]

    
    ### Repricing Notebook - Add > Rolllover/Conversion to New ###  
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options     &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    ${Effective_Date}    ${NewLoan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[New_LoanAmount]    &{ExcelPath}[Repricing_Frequency]
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Close RolloverConversion Notebook

    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}    ${NewLoan_Alias}

    ### Repricing Notebook - Add > Add > Interest Payment ###  
    Select Loan to Process    @{ExistingLoans}[1]
    Add Interest Payment for Loan Repricing   
    Select Loan to Process    @{ExistingLoans}[0]
    Add Interest Payment for Loan Repricing

    ### Loan Repricing Workflow Tab  - Send to approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to Do It
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
    Set Base Rate Details    &{ExcelPath}[Base_Rate]    &{ExcelPath}[AcceptRate_FromPricing]
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

    ### Pause execution because of breakfunding part do it manually(steps not included in screenshot)###
    # Pause Execution

    ### Loan Notebook ###
    Validate Release of Loan Repricing    ${RELEASED_STATUS}
    Close All Windows on LIQ

    ### Validate New Loan Amount ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[NewLoan_Alias]
    
Rollover and Principle Repayment
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for New Life BILAT
    ...    @author: kmagday    25JAN2021    - Initial Create 
    [Arguments]    ${ExcelPath}

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[CombineExistingLoans]

    ### Create Repricing ###
    Navigate to Create Repricing Window  
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loan Repricing for Deal    &{ExcelPath}[CombineExistingLoans]

    
    ### Repricing Notebook - Add > Rolllover/Conversion to New ###  
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options     &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    ${Effective_Date}    ${NewLoan_Alias}    Set RolloverConversion Notebook General Details    &{ExcelPath}[New_LoanAmount]    &{ExcelPath}[Repricing_Frequency]
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    Close RolloverConversion Notebook

    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}    ${NewLoan_Alias}

    ###Add Principal Payment###
    Add Principal Payment after New Outstanding Addition    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_RequestedAmount]
    Pause Execution
    Add Auto Generate Interest Payment for Loan Repricing
  
    ### Loan Repricing Workflow Tab  - Send to approval ###
    Navigate to Loan Repricing Workflow and Proceed With Transaction    ${CREATE_CASHFLOWS_TYPE}
    Set All Items to Do It
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
    Set Base Rate Details    &{ExcelPath}[Base_Rate]    &{ExcelPath}[AcceptRate_FromPricing]
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

    ### Pause execution because of breakfunding part do it manually(steps not included in screenshot)###
    # Pause Execution

    ### Loan Notebook ###
    Validate Release of Loan Repricing    ${RELEASED_STATUS}
    Close All Windows on LIQ

    ### Validate New Loan Amount ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    &{ExcelPath}[NewLoan_Alias]
    