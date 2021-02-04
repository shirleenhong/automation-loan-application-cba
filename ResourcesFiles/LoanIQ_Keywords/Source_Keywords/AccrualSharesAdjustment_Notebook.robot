*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 
Navigate to Accruals Share Adjustment Notebook
    [Documentation]    This keyword navigates the LIQ User to the Accruals Share Adjustment Notebook and validates the information displayed in the notebook.
    ...    @author: rtarayao
    ...    @update:    fmamaril    Remove validation on current cycle due
    ...    @update: clanding    22JUL2020    - added pre-processing keywords, refactor argument per standard, added screenshot
    [Arguments]    ${iSBLC_CycleNumber}    ${sDeal_Name}    ${sFacility_Name}    ${sDeal_Borrower}    ${sSBLC_Alias}    ${sCurrentCycleDue_Value}
    
    ### GetRuntime Keyword Pre-processing ###
    ${SBLC_CycleNumber}    Acquire Argument Value    ${iSBLC_CycleNumber}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}
    ${SBLC_Alias}    Acquire Argument Value    ${sSBLC_Alias}
    ${CurrentCycleDue_Value}    Acquire Argument Value    ${sCurrentCycleDue_Value}

    mx LoanIQ activate window    ${LIQ_SBLCGuarantee_Window}
    Mx LoanIQ Select String    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${SBLC_CycleNumber}   
    mx LoanIQ click    ${LIQ_SBLCGuarantee_CycleSharesAdjustment_Button}         
    mx LoanIQ activate    ${LIQ_AccrualSharesAdjustment_Pending_Window}
    Mx LoanIQ Verify Object Exist    ${LIQ_AccrualSharesAdjustment_Pending_Window}           VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Deal_Name}")      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Facility_Name}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Deal_Borrower}")        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${SBLC_Alias}")       VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AccrualSharesAdjustment_Pending_Window
    
Validate Accrual Start and End Dates
    [Documentation]    This keyword verifies the Accrual Notebook's Start Date and End Date using the stored SBLC Notebook's Accrual Start Date and End Date. 
    ...    @author: rtarayao
    [Arguments]    ${StartDate_Value}    ${EndDate_Value}    
   
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${StartDate_Value}")        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${EndDate_Value}")        VerificationData="Yes"
    
    
Input Requested Amount, Effective Date, and Comment
    [Documentation]    This keyword is used to input the Requested Amount, Effective Date, and Comment within the Accrual Shares Adjustment Notebook. 
    ...    @author: rtarayao
    ...    @update: dahijara    15JUL2020    - added preprocessing and screenshot; added Tab after entering effective date.
    ...    @update: javinzon    03FEB2021    - updated keyword from 'mx LoanIQ enter' to 'Enter Value on Text field' to accommodate when value in
    ...                                        Requested Amount is negative value.
    [Arguments]    	${sPaidSoFar_Value}    ${sSBLC_EffectiveDate}    ${sAccrual_Comment}
    ### GetRuntime Keyword Pre-processing ###
    ${PaidSoFar_Value}    Acquire Argument Value    ${sPaidSoFar_Value}
    ${SBLC_EffectiveDate}    Acquire Argument Value    ${sSBLC_EffectiveDate}
    ${Accrual_Comment}    Acquire Argument Value    ${sAccrual_Comment}

    Mx LoanIQ Select Window Tab    ${LIQ_AccrualSharesAdjustment_Window_Tab}    General     
    mx LoanIQ activate window    ${LIQ_AccrualSharesAdjustment_Window}
    ${PaidSoFar_Value}    Convert To String    ${PaidSoFar_Value}
    Enter Value on Text field    ${LIQ_AccrualSharesAdjustment_RequestedAmount_Textfield}    ${PaidSoFar_Value}
    mx LoanIQ enter    ${LIQ_AccrualSharesAdjustment_EffectiveDate_Textfield}    ${SBLC_EffectiveDate}
    Mx Press Combination    KEY.TAB
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AccrualSharesAdjustment
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ enter    ${LIQ_AccrualSharesAdjustment_Comment_Textfield}    ${Accrual_Comment}
 
    
Save the Requested Amount, Effective Date, and Comment    
    [Documentation]    This keyword is used to save and validate the Requested Amount, Effective Date, and Comment within the Accrual Shares Adjustment Notebook. 
    ...    @author: rtarayao
    ...    @update: dahijara    15JUL2020    - added preprocessing and screenshot; adjusted keywords indention
    ...    @update: makcamps    20NOV2020    - changed locators dependent on AU data
    ...    @update: javinzon    03FEB2020    - updated keyword from 'Mx LoanIQ Verify Object Exist' to 'Mx LoanIQ Get Data', 
    ...                                        added 'Compare Two Strings' to validate comment value from UI
    [Arguments]    ${sRequested_Amount}    ${sAccrual_EffectiveDate}    ${sAccrual_Comment}
    ### GetRuntime Keyword Pre-processing ###
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}
    ${Accrual_EffectiveDate}    Acquire Argument Value    ${sAccrual_EffectiveDate}
    ${Accrual_Comment}    Acquire Argument Value    ${sAccrual_Comment}

    mx LoanIQ select    ${LIQ_AccrualSharesAdjustment_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaEdit("labeled_containers_path:=Tab:General;Group: Amounts ;","index:=0", "value:=${Requested_Amount}.*")    VerificationData="Yes"
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaEdit("attached text:=Effective Date:", "value:=${Accrual_EffectiveDate}")               VerificationData="Yes"
    ${Accrual_Comment_UI}    Mx LoanIQ Get Data    ${LIQ_AccrualSharesAdjustment_Comment_Textfield}    value%comment
    Compare Two Strings    ${Accrual_Comment}    ${Accrual_Comment_UI}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AccrualSharesAdjustment

Send Adjustment to Approval
    [Documentation]    This keyword sends the Cycle Share Adjustment done to Approval.
    ...    @author: rtarayao
    ...    @update: fmamaril    Remove variable for Status
    ...    @update: dahijara    15JUL2020    - Added screenshot; adjusted keyword indention.
    Mx LoanIQ Select Window Tab    ${LIQ_AccrualSharesAdjustment_Window_Tab}    Workflow   
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AccrualSharesAdjustment_WorkflowAction}    Send to Approval%d
                 
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AccrualSharesAdjustment_Workflow
                 
Approve Cycle Share Adjustment
    [Documentation]    This keyword approves the Cycle Share Adjustment.
    ...    @author: rtarayao
    ...    @update: fmamaril    07MAY2019    Simplify the keyword and apply standards       
    mx LoanIQ activate window    ${LIQ_SBLCGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AccrualSharesAdjustment_Window_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AccrualSharesAdjustment_WorkflowAction}    Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
                  
Release Cycle Share Adjustment
    [Documentation]    This enables the LIQ user to Release the Cycle Share Adjustment made.
    ...    @author: rtarayao
    ...    @update: fmamaril    07MAY2019    Simplify Release Cycle Share Adjustment amd apply standrads
    ...    @update: clanding    22JUL2020    - added screenshot
    
    mx LoanIQ activate window    ${LIQ_SBLCGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AccrualSharesAdjustment_Window_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AccrualSharesAdjustmentWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AccrualSharesAdjustment_WorkflowAction}    Release%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AccrualSharesAdjustmentWindow_WorkflowTab_Released

Close Accrual Shares Adjustment Window
    [Documentation]    This enables the LIQ user to close ther Share Adjustment Window.
    ...    @author: rtarayao     
    ...    @update: dahijara    - added screenshot
    mx LoanIQ select    ${LIQ_AccrualSharesAdjustment_File_Exit}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_AccrualSharesAdjustment_Window}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Should Not Be True    ${status}==True                              
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AccrualSharesAdjustment
Approve Fee Accrual Shares Adjustment
    [Documentation]    This keyword navigates to Accrual Share Adjustment Notebook thru WIP and approve the transaction.
    ...    @author:mgaling
    ...    @update: dahijara    15JUL2020    - added screenshot; removed WIP navigation to use 'Select Item in Work in Process'; Optimized code; Removed arguments

    Wait Until Keyword Succeeds    5x    5s    mx LoanIQ activate window    ${LIQ_AccrualSharesAdjustment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AccrualSharesAdjustment_Window_Tab}    Workflow
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AccrualSharesAdjustment_WorkflowAction}    Approval%d
    Validate if Question or Warning Message is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/WorkInProgress_Workflow
    
Release Fee Accrual Shares Adjustment
    [Documentation]    This keyword navigates to Accrual Share Adjustment Notebook thru WIP and release the transaction.
    ...    @author:mgaling
    ...    @update: dahijara    15JUL2020    - added screenshot; removed WIP navigation to use 'Select Item in Work in Process'; Optimized code; Removed arguments.

    Wait Until Keyword Succeeds    5x    5s    mx LoanIQ activate window    ${LIQ_AccrualSharesAdjustment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AccrualSharesAdjustment_Window_Tab}    Workflow
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AccrualSharesAdjustment_WorkflowAction}    Release%d
    Validate if Question or Warning Message is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/WorkInProgress_Workflow
   
    
Send Payment Reversal Adjustment to Approval
    [Documentation]    This keyword sends the Cycle Share Adjustment done to Approval.
    ...    @author: chanario
    [Arguments]    ${Window}
      
     Mx LoanIQ Select Window Tab    ${LIQ_ReversePayment_Tab}    Workflow
     Mx LoanIQ DoubleClick    ${LIQ_ReversePayment_WorkflowItems_Tree}    Send to Approval
                 
     :FOR    ${i}    IN RANGE    2
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
     
    ###Verify Window Status after Send to Approval is completed - Awaiting Approval###
    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}
    Validate Window Title Status    ${Window}    Awaiting Approval


Approve Payment Reversal
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Payment Reversal cashflow.
    ...    @author: chanario
    [Arguments]    ${Amount}    ${EffectiveDate_FeePayment}    ${Currency}    ${Deal}    ${Facility}    ${EffectiveDate_Label}    ${Window}
    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    Sleep    3s     
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}
   
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}    VerificationData="Yes"
    mx LoanIQ activate    ${LIQ_TransactionInProcess_Window}   
    Mx LoanIQ Active Javatree Item    ${LIQ_TransactionInProcess_Tree}    Payments
    
    mx LoanIQ maximize    ${LIQ_TransactionInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionInProcess_Payments_Tree}    Awaiting Approval
    Mx LoanIQ DoubleClick    ${LIQ_TransactionInProcess_Payments_Tree}    Reverse Fee Payment
    
    Verify Payment Reversal data for Approval and Release    ${Amount}    ${EffectiveDate_FeePayment}    ${Currency}    ${Deal}    ${Facility}    ${EffectiveDate_Label}
    
    ###Approve Payment Reversal Request###        
    Mx LoanIQ Select Window Tab    ${LIQ_ReversePayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ReversePayment_WorkflowItems_Tree}    Approval%d
    
    Validate if Question or Warning Message is Displayed
    
    ###Verify Window Status after Approval is completed - now Awaiting Release###
    Validate Window Title Status    ${Window}    Awaiting Release
    
Verify Payment Reversal data for Approval and Release
    [Documentation]    This keyword validates the Reversal amount and Effective Date of WIP selected for Approval or Release.
    ...    @author: chanario
    [Arguments]    ${Amount}    ${EffectiveDate_FeePayment}    ${Currency}    ${Deal}    ${Facility}    ${EffectiveDate_Label}
        
    ###Verify Reversal Amount (negate)###
    ${Amount_L}    Remove Comma and Convert to Number    ${Amount}
    ${length}    Get Length    ${Amount_L}
    ${length}    Evaluate    int(${length})
    ${Reversepayment}    Evaluate    ${Amount_L}*-1
    ${Reversepayment_String}    Convert To String    ${Reversepayment}               
    ${Reversepayment_Alias_Hundreds}    Remove Comma and Convert to Number    ${Reversepayment_String}
    
    ${Reversepayment_Alias_Thousands}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${Reversepayment_Alias_Hundreds}
            
    ###Access Reverse Fee Window###                        
    Run Keyword If    '${Reversepayment_Alias_Thousands}'=='None'    Mx LoanIQ DoubleClick    ${LIQ_TransactionInProcess_Payments_Tree}    ${EffectiveDate_FeePayment}\t${Reversepayment_Alias_Hundreds}\t\t${Currency}\t${Deal}\t${Facility}
    ...    ELSE    Mx LoanIQ DoubleClick    ${LIQ_TransactionInProcess_Payments_Tree}    ${EffectiveDate_FeePayment}\t${Reversepayment_Alias_Thousands}\t\t${Currency}\t${Deal}\t${Facility}    
    
    mx LoanIQ activate    ${LIQ_ReverseFee_Window}
    
    ###Verify Effective Date is equal to the Fee Payment Effective Date###
    
    Validate if Element is Not Editable    ${LIQ_ReversePayment_EffectiveDate}    ${EffectiveDate_Label}    
    
    ${EffectiveDate_Reversal}    Mx LoanIQ Get Data    ${LIQ_ReversePayment_EffectiveDate}    value%test
    Run Keyword And Continue On Failure    Should Be Equal    ${EffectiveDate_Reversal}    ${EffectiveDate_FeePayment}        
    ${EffectiveDateReversal_status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${EffectiveDate_Reversal}    ${EffectiveDate_FeePayment}    
    
    Run Keyword If    ${EffectiveDateReversal_status}==True    Log    Reversal amount and Effective date is verified.    
        
Release Payment Reversal
    [Documentation]    This keyword navigates the Workflow tab of the Payment Reversal notebook and double clicks the 'Release' item.
    ...    @author: chanario
    
    [ARGUMENTS]    ${Amount}    ${EffectiveDate_FeePayment}    ${Currency}    ${Deal}    ${Facility}    ${EffectiveDate_Label}    ${Window}
    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    Sleep    3s     
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    mx LoanIQ activate    ${LIQ_TransactionInProcess_Window}   
    Mx LoanIQ Active Javatree Item    ${LIQ_TransactionInProcess_Tree}    Payments
    mx LoanIQ maximize    ${LIQ_TransactionInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionInProcess_Payments_Tree}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionInProcess_Payments_Tree}    Reverse Fee Payment
    
    ###Validate Requested Amount and Effective Date###
    Verify Payment Reversal data for Approval and Release    ${Amount}    ${EffectiveDate_FeePayment}    ${Currency}    ${Deal}    ${Facility}    ${EffectiveDate_Label}
 
    Mx LoanIQ Select Window Tab    ${LIQ_ReversePayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ReversePayment_WorkflowItems_Tree}    Release%d     
    
    ${Question_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Question_Window}        VerificationData="Yes"
    Run Keyword If    ${Question_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}          VerificationData="Yes"
    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ###Verify Window Status after Release is completed - Released### 
    ${Window_Exist}    Validate Window Title Status    ${Window}    Released
    Run Keyword If    ${Window_Exist}==True    Log    ayment Reversal is successfully released.
    ...    ELSE    Log    Payment Reversal is not successfully released.    level=Error        

Navigate Work in Process for Reversal Fee Payment Generate Intent Notices
    [Documentation]    This keyword navigates the Deal w/ pending awaiting generate intent notices for the Reversal Fee Payment in Work in Process module
    ...    @author: rtarayao
    [Arguments]    ${Facility_Name}
    mx LoanIQ activate window   ${LIQ_Window} 
    mx LoanIQ maximize    ${LIQ_Window}    
    Select Actions    [Actions];Work In Process
    Sleep    5    
    mx LoanIQ maximize    ${LIQ_TransactionInProcess_Window}    
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Transactions_List}    Payments    
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Generate Intent Notices         
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Reverse Fee Payment    
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Facility_Name}    
    Mx Native Type    {ENTER}
    mx LoanIQ close window    ${LIQ_TransactionInProcess_Window}    
    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}


Generate Intent Notices for Reversal Fee Payment
    [Documentation]    This keyword sends Payment Notices to the Borrower and Lender.
    ...    @author: fmamaril
    mx LoanIQ activate window   ${LIQ_ReverseFee_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_ReversePayment_Tab}    Workflow  
    Mx LoanIQ DoubleClick    ${LIQ_ReversePayment_WorkflowItems_Tree}    Generate Intent Notices
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    :FOR    ${i}    IN RANGE    1
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False

Navigate Work in Process for Reversal Fee Payment Release Cashflows
    [Documentation]    This keyword navigates the Deal w/ pending awaiting release cashflows for the Reversal Fee Payment in Work in Process module
    ...    @author: fmamaril/rtarayao
    [Arguments]    ${Facility_Name}    
    Select Actions    [Actions];Work In Process
    Sleep    5    
    mx LoanIQ maximize    ${LIQ_TransactionInProcess_Window}    
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Transactions_List}    Payments    
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Release Cashflows         
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Reverse Fee Payment    
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Facility_Name}    
    Mx Native Type    {ENTER}
    mx LoanIQ close window    ${LIQ_TransactionInProcess_Window}    
    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}

Modify Requested Amount for Accrual Shares Adjustment
    [Documentation]    This keyword is used to update requested amount if Requested field is disabled for user edit.
    ...    @author: javinzon    02FEB2021    - Initial Create
    [Arguments]    ${sRequestedAmount}
    
    ### GetRuntime Keyword Pre-processing ###
    ${RequestedAmount}    Acquire Argument Value    ${sRequestedAmount}
    
    mx LoanIQ select    ${LIQ_AccrualSharesAdjustment_Options_ModifyRequestedAmount_Dropdown}
    Sleep    3s     
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window} 
    Mx LoanIQ Enter    ${LIQ_AccrualSharesAdjustment_UpdateRequestedAmount_RequestedAmount_TextField}    ${RequestedAmount} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UpdateRequestedAmount
    Mx LoanIQ click    ${LIQ_AccrualSharesAdjustment_UpdateRequestedAmount_OK_Button}