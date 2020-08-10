*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Validate Event Fee Notebook General Tab Details
    [Documentation]    This keyword validates the Deal Name, Borrower Name, and The Facility Name in the Event Fee Notebook's General Tab.
    ...    @author: bernchua
    [Arguments]    ${s_Deal_Name}    ${s_Facility_Name}    ${s_Borrower_Name}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${s_Deal_Name}
    ${Facility_Name}    Acquire Argument Value    ${s_Facility_Name}
    ${Borrower_Name}    Acquire Argument Value    ${s_Borrower_Name}

    Verify If Text Value Exist as Static Text on Page    Fee    ${Deal_Name}
    Verify If Text Value Exist as Static Text on Page    Fee    ${Facility_Name}
    ${Verify_Borrower}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Fee.*").JavaStaticText("x:=144","y:=34","label:=${Borrower_Name}.*")    VerificationData="Yes"
    Run Keyword If    ${Verify_Borrower}==True    Log    ${Borrower_Name} is displayed in the window.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/EventFee_BorrowerNameVaidation

Set Event Fee General Tab Details
    [Documentation]    This keyword sets the details in the Event Fee Notebook's General tab.
    ...    
    ...    | Arguments |
    ...    'RecurringFeeStatus' = Accepts 'ON' as value. If ON, will tick "Recurring Fee" checkbox, and will enter a "No Recurrences After Date".
    ...    
    ...    @author: bernchua
    ...    @update: ritragel    27FEB19    Removed Writing in Lowlevel
    ...    @update:    sahalder    23JUL2020    Added step for screenshot capture
    [Arguments]    ${s_FeeType}    ${s_RequestedAmount}    ${s_EffectivDate}    ${s_BillingDays}    ${s_Comment}    ${s_RecurringFeeStatus}    ${s_NoRecurrencesAfterDate}
    
    ### GetRuntime Keyword Pre-processing ###
    ${FeeType}    Acquire Argument Value    ${s_FeeType}
    ${RequestedAmount}    Acquire Argument Value    ${s_RequestedAmount}
    ${EffectivDate}    Acquire Argument Value    ${s_EffectivDate}
    ${BillingDays}    Acquire Argument Value    ${s_BillingDays}
    ${Comment}    Acquire Argument Value    ${s_Comment}
    ${RecurringFeeStatus}    Acquire Argument Value    ${s_RecurringFeeStatus}
    ${NoRecurrencesAfterDate}    Acquire Argument Value    ${s_NoRecurrencesAfterDate}
    
    
    mx LoanIQ activate    ${LIQ_EventFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_EventFee_Javatab}    General    
    mx LoanIQ enter    ${LIQ_EventFee_RequestedAmount_Textfield}    ${RequestedAmount}
    Mx LoanIQ Select Combo Box Value    ${LIQ_EventFee_FeeType_Combobox}    ${FeeType}    
    mx LoanIQ enter    ${LIQ_EventFee_General_EffectiveDate}    ${EffectivDate}
    mx LoanIQ enter    ${LIQ_EventFee_BillingDays_Textfield}    ${BillingDays}
    mx LoanIQ enter    ${LIQ_EventFee_Comment_Textfield}    ${Comment}
    Run Keyword If    '${RecurringFeeStatus}'=='ON'	Run Keywords
    ...    Mx LoanIQ Set    ${LIQ_EventFee_RecurringFee_Checkbox}    ON
    ...    AND    mx LoanIQ enter    ${LIQ_EventFeeNotebook_NoRecurrencesAfter_Datefield}    ${NoRecurrencesAfterDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/EventFee_GeneralDetails
    
Set Event Fee Frequency Tab Details
    [Documentation]    This keyword sets the details in the Event Fee Notebook's Frequency Tab.
    ...    @author: bernchua
    ...    @update:    sahalder    23JUL2020    Added step for screenshot capture
    [Arguments]    ${s_EffectiveDate}    ${s_Frequency}    ${s_NonBusinessDayRule}
    
    ### GetRuntime Keyword Pre-processing ###
    ${EffectiveDate}    Acquire Argument Value    ${s_EffectiveDate}
    ${Frequency}    Acquire Argument Value    ${s_Frequency}
    ${NonBusinessDayRule}    Acquire Argument Value    ${s_NonBusinessDayRule}

    mx LoanIQ activate    ${LIQ_EventFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_EventFee_Javatab}    Frequency
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_EventFee_Frequency_EffectiveDate}    value%${EffectiveDate}
    Run Keyword If    ${status}==True    Log    Effective Date is verified.
    Mx LoanIQ Select Combo Box Value    ${LIQ_EventFee_Frequency_Combobox}    ${Frequency}
    Mx LoanIQ Select Combo Box Value    ${LIQ_EventFee_NonBussDayRule_Combobox}    ${NonBusinessDayRule}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/EventFee_FrequencyTab

Save and Close Event Fee Window and Exit from Facility Window
    [Documentation]    This Keyword is use to save and exit from the event fee window and also exit from facility notebook window
    ...    @author: sahalder
    mx LoanIQ select    ${LIQ_EventFee_File_Save}
    mx LoanIQ select    ${LIQ_EventFee_File_Exit}
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}    
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}

Activate Facility Notebook and Select Event Fee
    [Documentation]    This Keyword is use to activate the facility notebook window and select event fee from options 
    ...    @author: sahalder 
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Options_EventFee}
    ${System_Date}    Get System Date
    [Return]    ${System_Date}
    
Navigate Event Fee Notebook in WIP
    [Documentation]    This Keyword is use to navigate the event fee notebook from work in process
    ...    @author: jcdelacruz
    ...    @updated:Archana 06/08/2020 Updated Pre-processing keyword   
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingCreateCashflowsStatus}    ${sWIP_OutstandingType}    ${sFacility_Name} 
     ### Keyword Pre-processing ###
    ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
    ${WIP_AwaitingCreateCashflowsStatus}    Acquire Argument Value    ${sWIP_AwaitingCreateCashflowsStatus}
    ${WIP_OutstandingType}    Acquire Argument Value    ${sWIP_OutstandingType}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
     
    mx LoanIQ activate window    ${LIQ_Window}    
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingCreateCashflowsStatus}
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Mx Native Type    {ENTER} 
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Facility_Name}%yes  
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Facility_Name}%d
    Sleep    3s  
    mx LoanIQ activate    ${LIQ_EventFeeNotebook_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_EventFee_Pending_Window}                VerificationData="Yes"


Create Cashflow for Event Fee
    [Documentation]    This keyword creates cashflow for the event fee
    ...    @author: jcdelacruz
    ...    @update:    sahalder    23JUL2020    Added step for screenshot capture
    mx LoanIQ activate    ${LIQ_EventFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_EventFeeNotebook_PendingTab_Window}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/EventFee_Cashflows
    Mx LoanIQ DoubleClick    ${LIQ_EventFee_WorkflowItems_Pending_List}    Create Cashflows
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_EventFee_Cashflow_Window}                 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_EventFee_Cashflow_Window}    VerificationData="Yes"

Add Remittance Instruction in Cashflow - Event Fee
    [Documentation]    This keyword is use to add remittance instruction and verify if status is set to do it
    [Arguments]    ${Borrower}    ${Lender2}    ${Lender3}    ${Remittance_Description}
    Verify if Method has Remittance Instruction - Event Fee    ${Borrower}    ${Remittance_Description}
	Verify if Method has Remittance Instruction - Event Fee    ${Lender2}    ${Remittance_Description}
	Verify if Method has Remittance Instruction - Event Fee    ${Lender3}    ${Remittance_Description}

	Verify if Status is set to Do It - Event Fee    ${Borrower}
	Verify if Status is set to Do It - Event Fee    ${Lender2}
	Verify if Status is set to Do It - Event Fee    ${Lender3}


Verify if Method has Remittance Instruction - Event Fee
    [Documentation]    This keyword is used to validate the Cashflow Information.
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}    ${Remittance_Description}
    ${CashflowMethod}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_EventFee_Cashflows_List}    ${LIQCustomer_ShortName}%Method%Method_Variable
    Log To Console    ${CashflowMethod}     
    # ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowMethod}    NONE
    # Run Keyword If    ${status}==True    Add Remittance Instructions - Event Fee    ${LIQCustomer_ShortName}    ${Remittance_Description}
    # ...    ELSE    Log    Method already has remittance instructions
    # ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowMethod}    DDA
    # Run Keyword If    ${status}==True    Add Remittance Instructions - Event Fee    ${LIQCustomer_ShortName}    ${Remittance_Description}
    # ...    ELSE    Log    Method already has remittance instructions
    # ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowMethod}    IMT
    # Run Keyword If    ${status}==True    Add Remittance Instructions - Event Fee    ${LIQCustomer_ShortName}    ${Remittance_Description}
    # ...    ELSE    Log    Method already has remittance instructions
    # Run Keyword If    '${CashflowMethod}'!='RTGS'    Add Remittance Instructions - Event Fee    ${LIQCustomer_ShortName}    ${Remittance_Description}
    # ...    ELSE    Log    Method already has remittance instructions
   
Verify if Status is set to Do It - Event Fee
    [Documentation]    This keyword is used to validate the event fee Cashflow Status
    ...    @author: jcdelacruz
    [Arguments]    ${LIQCustomer_ShortName}
     ${CashflowStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_EventFee_Cashflows_List}    ${LIQCustomer_ShortName}%Status%MStatus_Variable
    Log To Console    ${CashflowStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_EventFee_Cashflows_List}    ${LIQCustomer_ShortName}%s   
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_EventFee_Cashflows_DoIt_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete

Get Transaction Amount - Event Fee
    [Documentation]    This keyword is used to get transaction amount from Cashflow
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    ${BrwTransactionAmount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_EventFee_Cashflows_List}    ${LIQCustomer_ShortName}%Tran Amount%Tran
    ${CashflowTranAmount}    Remove String    ${BrwTransactionAmount}    ,
    ${UiTranAmount}    Convert To Number    ${CashflowTranAmount}    2
    Log To Console    ${UiTranAmount} 
    [Return]    ${UiTranAmount}
 
Compute Lender Share Transaction Amount - Event Fee
    [Documentation]    This keyword is used to compute for the Lender Share Transaction Amount.
    ...    @author: rtarayao  
    [Arguments]    ${LenderSharePct}
    
    Log    ${LenderSharePct}
    ${EventFee_CalculatedFixedPayment}    Read Data From Excel    SERV33_RecurringFee    EventFee_RequestedAmount    ${rowid}
    Log    ${EventFee_CalculatedFixedPayment} 
    
    ${status}    Run Keyword And Return Status    Should Contain    ${EventFee_CalculatedFixedPayment}    ,           
    Run Keyword If    '${status}'=='True'    Remove String    ${EventFee_CalculatedFixedPayment}    ,
    ${LenderSharePct}    Evaluate    ${LenderSharePct}/100
    ${LenderShareTranAmt}    Evaluate    ${EventFee_CalculatedFixedPayment}*${LenderSharePct}   
    ${LenderShareTranAmt}    Convert To Number    ${LenderShareTranAmt}    2
    Log    ${LenderShareTranAmt}
    [Return]    ${LenderShareTranAmt}
    
Get Host Bank Cash - Event Fee
    [Documentation]    This keyword is used to get Host Bank cash value
    ...    @author: ritragel
    ${HostBankShares}    Mx LoanIQ Get Data    ${LIQ_EventFee_Cashflow_HostBankCash_JavaEdit}    value%value 
    ${UiHostBank}    Strip String    ${HostBankShares}    mode=Right    characters= AUD
    #${status}    Run Keyword And Return Status    Should Contain    ${UiHostBank}    ,
    #Run Keyword If    '${status}'=='True'    
    ${UiHostBank}    Remove String    ${UiHostBank}    ,
    ${HBShares}    Convert To Number    ${UiHostBank}    2
    [Return]    ${HBShares}
    
Get Debit Amount - Event Fee
    [Documentation]    This keyword is used to get debit amount in GL Entries
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${LIQCustomer_ShortName}%Debit Amt%Debit
    ${GLEntryAmt}    Remove String    ${DebitAmt}    ,
    ${UiGLEntryAmt}    Convert To Number    ${GLEntryAmt}    2
    Log To Console    ${UiGLEntryAmt} 
    [Return]    ${UiGLEntryAmt}    

Get Credit Amount - Event Fee
    [Documentation]    This keyword is used to get credit amount in GL Entries
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${LIQCustomer_ShortName}%Credit Amt%Credit
    ${GLEntryAmt}    Remove String    ${CreditAmt}    ,
    ${UiGLEntryAmt}    Convert To Number    ${GLEntryAmt}    2
    Log To Console    ${UiGLEntryAmt} 
    [Return]    ${UiGLEntryAmt}


Generate Intent Notices - Event Fee
    [Documentation]    This keyword is use to generate intent notice for breakfunding
    ...    @author: jcdelacruz
    mx LoanIQ click element if present    ${LIQ_EventFee_Cashflow_Ok_Button}
    mx LoanIQ activate window    ${LIQ_EventFee_AwaitingSend_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_EventFee_AwaitingSend_Tab}    Workflow
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_EventFee_WorkflowItems_AwaitingSend_List}    Generate Intent Notices%yes
    Mx LoanIQ DoubleClick    ${LIQ_EventFee_WorkflowItems_AwaitingSend_List}    Generate Intent Notices
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_Notices_Window}
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Notices_Lenders_Checkbox}    Lenders
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Notices_BorrowerDepositor_Checkbox}    Borrower / Depositor
    mx LoanIQ click    ${LIQ_Notices_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_EventFeePaymentGroup_Window}
    mx LoanIQ click    ${LIQ_EventFeePaymentGroup_Exit_Button}
    
Send Event Fee to Approval
    [Documentation]    This keyword is use to send the event fee transaction for approval
    ...    @author: jcdelacruz
    ...    @update    sahalder    22072020    added step for handling error popup
    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    mx LoanIQ activate window    ${LIQ_EventFee_AwaitingSend_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_EventFee_AwaitingSend_Tab}    Workflow
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_EventFee_WorkflowItems_AwaitingSend_List}    Send to Approval
    Mx LoanIQ DoubleClick    ${LIQ_EventFee_WorkflowItems_AwaitingSend_List}    Send to Approval
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Approve Event Fee via WIP LIQ Icon
    [Documentation]    This keyword navigates the event fee to be approved from Work in Process window
    ...     @author: jcdelacruz
    ...     @update:Archana 08June2020 added pre-processing keyword
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingApprovalStatus}    ${sWIP_OutstandingType}
    
####Pre processing keywords###
    ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}    
    ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_AwaitingApprovalStatus}
    ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_OutstandingType}    

    ${Facility_Name}    Read Data From Excel    SERV33_RecurringEventFeePayment    Facility_Name    ${rowid}
    Open Event Fee Notebook via WIP - Awaiting Approval    ${sWIP_TransactionType}    ${sWIP_AwaitingApprovalStatus}    ${sWIP_OutstandingType}    ${Facility_Name}
    Approve Event Fee    


Open Event Fee Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to open the Event Fee Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...     @author: jcdelacruz
    ...    @update : Archana  08June2020  Added Pre-processing keyword               
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingApprovalStatus}    ${sWIP_OutstandingType}    ${sLoan_Alias} 
    
####Pre processing keyword###
     ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
     ${WIP_AwaitingApprovalStatus}    Acquire Argument Value    ${sWIP_AwaitingApprovalStatus} 
     ${WIP_OutstandingType}    Acquire Argument Value    ${sWIP_OutstandingType}
     ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
     
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus}
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Mx Native Type    {ENTER} 
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_EventFee_AwaitingApproval_Window}
    
    
Approve Event Fee
    [Documentation]    This keyword approves the Event Fee.
    ...     @author: jcdelacruz    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_EventFee_AwaitingApproval_Window}        VerificationData="Yes"
    Mx LoanIQ Select Window Tab    ${LIQ_EventFee_AwaitingApproval_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_EventFee_WorkflowItems_AwaitingApproval_List}    Approval%yes 
    Mx LoanIQ DoubleClick    ${LIQ_EventFee_WorkflowItems_AwaitingApproval_List}    Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    2
    \    ${Warning_Status}    Run Keyword And Return Status    Run Keyword And Ignore Error    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False
    \    Run Keyword And Ignore Error    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_EventFee_AwaitingRelease_Window}    VerificationData="Yes"
    
Release Event Fee via WIP LIQ Icon
    [Documentation]    This keyword navigates the Event Fee to be approved from Work in Process window
    ...     @author: jcdelacruz
    ...    @update : Archana  08June2020 Added pre-processing keyword
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingReleaseStatus}    ${sWIP_OutstandingType}
    
    ####Pre processing keyword###
     ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
     ${WIP_AwaitingReleaseStatus}    Acquire Argument Value    ${sWIP_AwaitingReleaseStatus}
     ${WIP_OutstandingType}    Acquire Argument Value    ${sWIP_OutstandingType}
     
    ${Facility_Name}    Read Data From Excel    SERV33_RecurringEventFeePayment    Facility_Name    ${rowid}
    Open Event Fee Notebook via WIP - Awaiting Release    ${WIP_TransactionType}    ${WIP_AwaitingReleaseStatus}    ${WIP_OutstandingType}    ${Facility_Name}
    Release Event Fee
    
Open Event Fee Notebook via WIP - Awaiting Release
    [Documentation]    This keyword is used to open the Event Fee Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...     @author: jcdelacruz
    ...    @update: Archana  08June2020 Added Pre-processing keyword
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingReleaseStatus}    ${sWIP_OutstandingType}    ${sFacility_Name}  
    
####Pre processing keyword###
     ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
     ${WIP_AwaitingReleaseStatus}    Acquire Argument Value    ${sWIP_AwaitingReleaseStatus} 
     ${WIP_OutstandingType}    Acquire Argument Value    ${sWIP_OutstandingType}
     ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
      
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionList}    Payments
    Mx Native Type    {ENTER}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseStatus} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Facility_Name}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate window    ${LIQ_EventFee_AwaitingRelease_Window}
    
Release Event Fee
    [Documentation]    This keyword approves the Event Fee.
    ...     @author: jcdelacruz
    mx LoanIQ activate window    ${LIQ_EventFee_AwaitingRelease_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_EventFee_AwaitingRelease_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_EventFee_WorkflowItems_AwaitingRelease_List}    Release%yes 
    Mx LoanIQ DoubleClick    ${LIQ_EventFee_WorkflowItems_AwaitingRelease_List}    Release  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    2
    \    ${Warning_Status}    Run Keyword And Return Status    Run Keyword And Ignore Error    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False
    \    Run Keyword And Ignore Error    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_EventFee_Released_Window}    VerificationData="Yes"
    Mx LoanIQ Select Window Tab    ${LIQ_EventFee_Released_Tab}    Events
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_EventFee_Events_Tree}    Released%yes        
    mx LoanIQ select    ${LIQ_EventFeeNotebook_FileExit_Menu}         
    
Save Event Fee Window
    [Documentation]    This Keyword is use to save the event fee window
    ...    @author: sahalder    22072020    initial create
    mx LoanIQ select    ${LIQ_EventFee_File_Save}