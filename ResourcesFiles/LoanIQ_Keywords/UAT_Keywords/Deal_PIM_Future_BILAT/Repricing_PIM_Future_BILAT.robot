*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Create Comprehensive Repricing for PIM Future BILAT
    [Documentation]    This is a high-level keyword to Create Comprehensive Repricing for PIM Future BILAT
    ...    @author: mcastro    14DEC2020    - Initial Create 
    ...    @update: mcastro    05JAN2021    - Added writing of New loan alias to Correspondence  
    ...    @update: mcastro    15JAN2021    - Removed writing on breakfunding sheet, added writing of loan_alias on correspondence
    ...    @update: mcastro    22JAN2021    - Added writing of Loan_Alias to correspondence, updated variable from &{ExcelPath}[NewLoan_Alias] to ${NewLoan_Alias}
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
    Write Data To Excel    Correspondence    Loan_Alias    6    ${NewLoan_Alias}
    Write Data To Excel    Correspondence    Loan_Alias    7    ${NewLoan_Alias}
    Write Data To Excel    Correspondence    Loan_Alias    10    ${NewLoan_Alias}
    Write Data To Excel    Correspondence    Loan_Alias    13    ${NewLoan_Alias}

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
    Open Existing Loan    ${NewLoan_Alias}
    Validate Loan Amount was Updated after Repricing    &{ExcelPath}[New_LoanAmount]

    Close All Windows on LIQ
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}    

Combine All Loans and Capitalize Interest for PIM Future BILAT 
    [Documentation]    This is a high-level keyword to merge all loans (Loan1, Loan2, and Loan3) and capitalize interest for PIM Future BILAT. 
    ...    @author: mcastro    28JAN2021    - Initial Create 
    [Arguments]    ${ExcelPath}
    
    ${Loan1_Alias}    Read Data From Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    1
    ${Loan2_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    2
    ${Loan3_Alias}    Read Data From Excel    SERV01_LoanDrawdown    Loan_Alias    3
    ${Loan1_Amount}    Read Data From Excel    SERV40_BreakFunding    Expected_Outstanding    3
    ${Loan2_Amount}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    2
    ${Loan3_Amount}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RequestedAmount    3
    ${Repricing_Frequency}    Read Data From Excel    SERV01_LoanDrawdown    Loan_RepricingFrequency    1

    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ### Open Loan Notebook ###
    Search for Deal    &{ExcelPath}[Deal_Name]
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]

    ### Set Loan Capitalization for Loan 2 ###
    Open Existing Loan    ${Loan2_Alias}
    Navigate to Capitalize Interest Payment from Loan Notebook
    Set Activate Interest Capitalization and Select To Loan Value    &{ExcelPath}[InterestCapitalization_Status]    &{ExcelPath}[Pricing_Option]    ${Loan2_Alias}
    Close Loan Notebook

    ### Set Loan Capitalization for Loan 3 ###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Open Existing Loan    ${Loan3_Alias}
    Navigate to Capitalize Interest Payment from Loan Notebook
    Set Activate Interest Capitalization and Select To Loan Value    &{ExcelPath}[InterestCapitalization_Status]    &{ExcelPath}[Pricing_Option]    ${Loan3_Alias}
    Close Loan Notebook
    
    ### Merge 3 Loans ###
    Search for Existing Outstanding    &{ExcelPath}[OutstandingSelect_Type]    &{ExcelPath}[Facility_Name]
    Select Loan to Reprice    ${Loan1_Alias}
    Select Repricing Type    &{ExcelPath}[Repricing_Type]
    Select Loans to Merge    ${Loan1_Alias}|${Loan2_Alias}|${Loan3_Alias}

    Validate Loan Amounts of Existing Outstandings    &{ExcelPath}[Pricing_Option]    ${Loan1_Alias}|${Loan2_Alias}|${Loan3_Alias}    ${Loan1_Amount}|${Loan2_Amount}|${Loan3_Amount}    &{ExcelPath}[New_LoanAmount]

    ### Repricing Notebook - Setup Repricing ###  
    Cick Add in Loan Repricing Notebook
    Set Repricing Detail Add Options     &{ExcelPath}[Repricing_Add_Option_Setup]    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Borrower_Name]
    ${Alias_LoanMerge}    Validate Rollover/Conversion General Tab    ${Repricing_Frequency}    &{ExcelPath}[New_LoanAmount]    &{ExcelPath}[OutstandingSelect_Type]
    
    Write Data To Excel    SERV08_ComprehensiveRepricing    NewLoan_Alias    ${rowid}    ${Alias_LoanMerge}

    Validate New Outstanding Amount for Loan Repricing    &{ExcelPath}[Pricing_Option]    ${Alias_LoanMerge}    &{ExcelPath}[New_LoanAmount]
    Validate and Add Interest Payment for Loan Repricing    ${Loan1_Alias}    &{ExcelPath}[Loan1_InterestAmt]
    Validate and Add Interest Payment for Loan Repricing    ${Loan2_Alias}    &{ExcelPath}[Loan2_InterestAmt]
    Validate and Add Interest Payment for Loan Repricing    ${Loan3_Alias}    &{ExcelPath}[Loan3_InterestAmt]

    ### Loan Repricing Workflow Tab  - Send to Approval ###
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
    Open Existing Loan    ${Alias_LoanMerge}
    Validate Event Status in Loan Events Tab    ${RELEASED_STATUS}
    Validate Loan Amount was Updated after Repricing    &{ExcelPath}[LoanAmt_WithInterest]
    Validate Loan Drawdown General Details in General Tab    &{ExcelPath}[Pricing_Option]    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Repricing_Frequency]    &{ExcelPath}[Loan_RepricingDate]    &{ExcelPath}[Loan_PaymentMode]    &{ExcelPath}[Expctd_Loan_IntCycleFrequency]
    Validate Loan Drawdown Rates in Rates Tab    &{ExcelPath}[Expctd_LoanCurrentBaseRate]    &{ExcelPath}[Expctd_LoanSpread]    &{ExcelPath}[Expctd_LoanAllInRate]

    Close All Windows on LIQ 