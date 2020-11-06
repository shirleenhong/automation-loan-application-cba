*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Verify if Standby Letters of Credit Exist
    [Documentation]    This keyword verifies if Existing Standby Letters of Credit window is not visible and search
    ...    @author: jcdelacruz
    ...    @update: fmamaril    30APR2019    Rename keyword
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sDeal_Name}    ${sType}    ${sSearch_By}    ${sFacility_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Type}    Acquire Argument Value    ${sType}
    ${Search_By}    Acquire Argument Value    ${sSearch_By}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    ${Status}    Verify if Existing Standby Letters of Credit Window is Visible and Return Status
    Run Keyword If    '${Status}' == 'False'    Search Deal    ${Deal_Name}    
    Run Keyword If    '${Status}' == 'False'    Select Outstanding Loan    ${Type}    ${Search_By}    ${Facility_Name}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/VerifySBLCExist
    
Verify if Existing Standby Letters of Credit Window is Visible and Return Status
    [Documentation]    This keyword verifies if Existing Standby Letters of Credit window is visible and returns the status
    ...    @author: jcdelacruz
    [Return]    ${Status}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_ExistingStandbyLettersOfCredit_Window}    VerificationData="Yes"
    
Search Deal
    [Documentation]    This keyword searches Deal from LIQ
    ...    @author: jcdelacruz
    [Arguments]    ${Deal_Name}
    mx LoanIQ activate window   ${LIQ_Window}     
    Select Actions    [Actions];Deal
    mx LoanIQ enter   ${LIQ_DealSelect_Search_TextField}    ${Deal_Name}
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}
    
Select Outstanding Loan
    [Documentation]    This keyword searches outstanding loan from Deal
    ...    @author: jcdelacruz
    ...    @update: ehugo    03JUN2020    - used 'Mx LoanIQ Select Combo Box Value' keyword in selecting value for 'LIQ_OutstandingSelect_Facility_Dropdown'
    [Arguments]    ${Type}    ${Search_By}    ${Facility_Name}

    mx LoanIQ select    ${LIQ_Deal_OutstandingSelect_Menu}    
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Existing_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Active_Checkbox}    ON
    mx LoanIQ select list    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Type}
    mx LoanIQ select list    ${LIQ_OutstandingSelect_SearchBy_Dropdown}    ${Search_By}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}    
    
Set Up Existing Letters of Credit Settings for SBLC Decrease
    [Documentation]    This keyword modifies the settings in Existing Letter of Credit Window in preparation for SBLC decrease 
    ...    @author: jcdelacruz
    ...    @update :Archana 11June20 - Added Pre-processing keyword 
    ...       
    [Arguments]    ${sExisting_Standby_Letters_of_Credit_Alias}    
    ### Keyword Pre-processing ###
    ${Existing_Standby_Letters_of_Credit_Alias}    Acquire Argument Value    ${sExisting_Standby_Letters_of_Credit_Alias}
         
    mx LoanIQ activate window    ${LIQ_ExistingStandbyLettersOfCredit_Window}    
    mx LoanIQ enter    ${LIQ_ExistingStandbyLettersOfCredit_OpenNotebookInUpdateMode_Checkbox}    ON
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_ExistingStandbyLettersOfCredit_OpenNotebookInUpdateMode_Checkbox}    Open notebook in update mode
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ExistingStandbyLettersOfCredit_List}    ${Existing_Standby_Letters_of_Credit_Alias}%s
    mx LoanIQ click    ${LIQ_ExistingStandbyLettersOfCredit_Decrease_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCDecrease
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Decrease .*(${Existing_Standby_Letters_of_Credit_Alias}.*) / Pending")        VerificationData="Yes"
    
Populate Bank Guarantee/Letter of Credit/Synd Fronted Bank Decrease Fields
    [Documentation]    This keyword populates the fields from Pending SBLC Decrease window
    ...    @author: jcdelacruz
    ...    @update:Archana 11June20 - Added Pre-processing keyword
    ...    @update: clanding    22JUL2020    - replaced Mx Native Type to Mx Press Combination
    [Arguments]    ${sRequested_Amount}    ${sReason}
    
    ###Pre-processing Keyword####
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}
    ${Reason}    Acquire Argument Value    ${sReason}
        
    ${SystemDate}    Get System Date    
    mx LoanIQ enter    ${LIQ_SBLCDecreasePending_RequestedAmount_TextField}    ${Requested_Amount}
    mx LoanIQ enter    ${LIQ_SBLCDecreasePending_EffectiveDate_TextField}    ${SystemDate}
    mx LoanIQ enter    ${LIQ_SBLCDecreasePending_Reason_TextField}    ${Reason}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCDecrease
    Mx Press Combination    KEY.BACKSPACE
    
Remove Comma, Negative Character and Convert to Number
    [Documentation]    This keyword removes Comma and Negative Characters in a given variable
    ...    @author: jcdelacruz
    ...    @update: bernchua    26NOV2018    updated remove string keyword to include currencies
    [Arguments]    ${VariableToBeConverted}
    [Return]    ${ConvertedVariable}
    ${ConvertedVariable}    Set Variable    ${VariableToBeConverted}
	${ConvertedVariable}    Remove String    ${ConvertedVariable}    AUD    USD    ,    -
    ${ConvertedVariable}    Convert To Number    ${ConvertedVariable}    2
    
    
Validate View/Update Lender Shares Details
    [Documentation]    This keyword verifies the Requested Amount and New Balance values in Lender Shares Details
    ...    @author: jcdelacruz
    ...    @update:Archana 11June20 - Added Pre-processing keyword
    ...    @update: clanding    22JUL2020    - added Run Keyword And Continue On Failure to Should Be Equal As Numbers    ${NewBalanceFromUi}    ${NewBalance}
    [Arguments]    ${sCurrency}    ${sExisting_Standby_Letters_of_Credit_Alias}    ${sDeal_Name}    ${sFacility_Name}    ${sLegal_Entity}    ${sRequested_Amount}    ${sNon_Loan_Amount}
    
    ###Pre-processing keyword###
    ${Currency}    Acquire Argument Value    ${sCurrency}    
    ${Existing_Standby_Letters_of_Credit_Alias}    Acquire Argument Value    ${sExisting_Standby_Letters_of_Credit_Alias}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Legal_Entity}    Acquire Argument Value    ${sLegal_Entity}
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}
    ${Non_Loan_Amount}    Acquire Argument Value    ${sNon_Loan_Amount}

    mx LoanIQ select    ${LIQ_SBLCDecreasePending_ViewUpdateLenderShares_Menu}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_MessageBox}            VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_No_Button}    VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present   ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    JavaWindow("title:=Shares for .*(${Currency}.*) Bank Guarantee/Letter of Credit/Synd Fronted Bank Decrease .*(${Existing_Standby_Letters_of_Credit_Alias}.*) in Facility: ${Deal_Name} / ${Facility_Name}") 
    ${ActualAmountFromUITemp}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesForSBLCDecrease_HostBankShares_List}    ${Legal_Entity}%Actual Amount%ActualAmount_Variable
    ${ActualAmountFromUI}    Remove Comma, Negative Character and Convert to Number    ${ActualAmountFromUITemp}
    ${RequestedAmount}    Remove Comma, Negative Character and Convert to Number    ${Requested_Amount}
    Run Keyword And Continue On Failure    Should Be Equal    ${ActualAmountFromUI}    ${RequestedAmount}
    ${NewBalanceFromUi}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesForSBLCDecrease_HostBankShares_List}    ${Legal_Entity}%New Balance%NewBalance_Variable
    ${NewBalance} =    Evaluate    ${Non_Loan_Amount}-${Requested_Amount}
    ${ConvertedBalanceFromUi}    Remove Comma and Convert to Number    ${NewBalanceFromUi}
    ${ConvertedBalance}    Remove Comma and Convert to Number    ${NewBalance}
      
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCLenderShares
    Log    New Balance from UI in Lender Shares is ${NewBalanceFromUi}
    Log    Evaluated New Balance for Lender Shares is ${NewBalance}
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${ConvertedBalanceFromUi}    ${ConvertedBalance} 
    mx LoanIQ click    ${LIQ_SharesForSBLCDecrease_Ok_Button}

Validate View/Update Issuing Bank Shares Details
    [Documentation]    This keyword verifies the Requested Amount and New Balance values in Issuing Bank Shares Details
    ...    @author: jcdelacruz
    ...    @update:Archana 11June20 - Added Pre-processing keyword
    ...    @update: clanding    22JUL2020    - added Run Keyword And Continue On Failure to Should Be Equal As Numbers    ${NewBalanceFromUi}    ${NewBalance}
    [Arguments]    ${sCurrency}    ${sExisting_Standby_Letters_of_Credit_Alias}    ${sLegal_Entity}    ${sRequested_Amount}    ${sNon_Loan_Amount}
    
    ###Pre-processing Keyword####
    ${Currency}    Acquire Argument Value    ${sCurrency}    
    ${Existing_Standby_Letters_of_Credit_Alias}    Acquire Argument Value    ${sExisting_Standby_Letters_of_Credit_Alias}
    ${Legal_Entity}    Acquire Argument Value    ${sLegal_Entity}
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}
    ${Non_Loan_Amount}    Acquire Argument Value    ${sNon_Loan_Amount}

    mx LoanIQ select    ${LIQ_SBLCDecreaseAwaitingSendToApproval_ViewUpdateIssuingBankShares_Menu}
    mx LoanIQ activate window    JavaWindow("title:=Shares for .*(${Currency}.*) Issuing Banks of Bank Guarantee/Letter of Credit/Synd Fronted Bank Decrease .*(${Existing_Standby_Letters_of_Credit_Alias}.*)")
    ${ActualAmountFromUITemp}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesForSBLCDecrease_HostBankShares_List}    ${Legal_Entity}%Actual Amount%ActualAmount_Variable
    ${ActualAmountFromUI}    Remove Comma, Negative Character and Convert to Number    ${ActualAmountFromUITemp}
    ${RequestedAmount}    Remove Comma, Negative Character and Convert to Number    ${Requested_Amount}
    Run Keyword And Continue On Failure    Should Be Equal    ${ActualAmountFromUI}    ${RequestedAmount}
    ${NewBalanceFromUi}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesForSBLCDecrease_HostBankShares_List}    ${Legal_Entity}%New Balance%NewBalance_Variable
    ${NewBalance} =    Evaluate    ${Non_Loan_Amount}-${Requested_Amount}
    
    ${ConvertedBalanceFromUi}    Remove Comma and Convert to Number    ${NewBalanceFromUi}
    ${ConvertedBalance}    Remove Comma and Convert to Number    ${NewBalance}
    
    Log    New Balance from UI in Issuing Bank Shares is ${NewBalanceFromUi}
    Log    Evaluated New Balance in Issuing Bank Shares is ${NewBalance}
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${ConvertedBalanceFromUi}    ${ConvertedBalance}    
    mx LoanIQ click    ${LIQ_SharesForSBLCDecrease_Ok_Button}      
    
Generate Intent Notices for SBLC Decrease
    [Documentation]    This keyword generates intent notices for the SBLC Decrease
    ...    @author: jcdelacruz
    [Arguments]    ${Existing_Standby_Letters_of_Credit_Alias}    ${User}    ${Current_Date}
    mx LoanIQ activate window    JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Decrease .*(${Existing_Standby_Letters_of_Credit_Alias}.*) / Awaiting Send To Approval")
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCDecrease_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_SBLCDecreaseAwaitingSendToApproval_Workflow_ItemList}    Generate Intent Notices%yes
    Mx LoanIQ Verify Text In Javatree    ${LIQ_SBLCDecreaseAwaitingSendToApproval_Workflow_ItemList}    Send to Approval%yes    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SBLCDecreaseAwaitingSendToApproval_Workflow_ItemList}    Generate Intent Notices%d
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Notices_BorrowerDepositor_Checkbox}    Borrower / Depositor
    mx LoanIQ click    ${LIQ_Notices_Ok_Button}
    mx LoanIQ activate window    JavaWindow("title:=SBLC/Guarantee Change Intent Notice Group created by ${User} on ${Current_Date}","displayed:=1")
       
Validate Notice Details
    [Documentation]    This keyword validates the details from Notice Preview report
    ...    @author: jcdelacruz
    [Arguments]    ${User}    ${Current_Date}    
    mx LoanIQ click    ${LIQ_SBLCGuaranteeChangeIntentNotice_EditHighlightedNotices_Button}
    #Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=SBLC/Guarantee Change Intent Notice created by .*${User} on ${Current_Date}")            VerificationData="Yes"
    mx LoanIQ activate window    JavaWindow("title:=SBLC/Guarantee Change Intent Notice created by ${User} on ${Current_Date}")
    mx LoanIQ select    ${LIQ_SBLCGuaranteeChangeIntentNotice_Preview_Menu}
    mx LoanIQ activate window    ${LIQ_Notice_Preview_Window}
    Take Screenshot   Notice Preview        
    mx LoanIQ close window   ${LIQ_Notice_Preview_Window}
    mx LoanIQ close window   ${LIQ_SBLCGuaranteeChangeIntentNoticeCreated_Window}   
    mx LoanIQ close window   ${LIQ_SBLCGuaranteeChangeIntentNoticeGroup_Window}
    
Send SBLC Decrease for Approval
    [Documentation]    This keyword sends the SBLC Decrease for approval
    ...    @author: jcdelacruz
    ...    @update: fmamaril    30APR2019    Add tab selection and warning message handling
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCDecrease_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SBLCDecreaseAwaitingSendToApproval_Workflow_ItemList}    Send to Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Navigate Work in Process for SLBC Decrease Approval
    [Documentation]    This keyword navigates the Deal w/ pending awaiting approval for the SBLC Decrease in Work in Process module
    ...    @author: jcdelacruz
    [Arguments]    ${Existing_Standby_Letters_of_Credit_Alias}
    mx LoanIQ activate window   ${LIQ_Window}
    Select Actions    [Actions];Work In Process
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    Outstandings    
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Approval
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    SBLC/Guarantee Decrease
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Existing_Standby_Letters_of_Credit_Alias}
    
Navigate Work in Process for SLBC Decrease Release
    [Documentation]    This keyword navigates the Deal w/ pending awaiting approval for the SBLC Decrease in Work in Process module
    ...    @author: jcdelacruz
    [Arguments]    ${Existing_Standby_Letters_of_Credit_Alias}
    mx LoanIQ activate window   ${LIQ_Window}
    Select Actions    [Actions];Work In Process
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    Outstandings    
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    SBLC/Guarantee Decrease
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Existing_Standby_Letters_of_Credit_Alias}
    
Approve SBLC Decrease
    [Documentation]    This keyword approves the SBLC Decrease from Workflow items
    ...    @author: jcdelacruz
    ...    @update: fmamaril    30APR2019    added handling on messagebox
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCDecrease_Tab}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_SBLCDecreaseAwaitingSendToApproval_Workflow_ItemList}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}   
    
Release SBLC Decrease
    [Documentation]    This keyword releases the SLBC Decrease from Workflow Items
    ...    @author: jcdelacruz
    ...    @update: fmamaril    30APR2019    added handling on messagebox
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCDecrease_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_SBLCDecreaseAwaitingSendToApproval_Workflow_ItemList}    Release%yes
    Mx LoanIQ DoubleClick    ${LIQ_SBLCDecreaseAwaitingSendToApproval_Workflow_ItemList}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Bank Guarantee/Letter of Credit/Synd Fronted Bank Decrease.*").JavaTab("text:=Workflow").JavaTree("attached text:=Drill down to perform Workflow item","items count:=0")    VerificationData="Yes"
    Mx LoanIQ Close    ${LIQ_SBLCGuarantee_Window}
