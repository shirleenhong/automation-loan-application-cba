*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Populate Upfront Fee Payment Notebook
     [Documentation]    This keyword is used to populate data in Fee Details Window.
    ...    @author: mgaling
    ...    @update:Archana 14Jul2020 
    ...            -Added Pre-processing keywords and Screenshot path
    [Arguments]    ${sUpfrontFee_Amount}    ${sEffective_Date}=None
    
    ###Pre-processing keyword###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
          
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_PaymentUpfrontFeeBorr_Menu}
    mx LoanIQ activate window    ${LIQ_UpfrontFeePayment_Notebook}       
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeePayment_Notebook}            VerificationData="Yes"
    Run Keyword If    '${sEffective_Date}'!='None'    mx LoanIQ enter    ${LIQ_UpfrontFee_EffectiveDate_Field}    ${sEffective_Date}
    mx LoanIQ enter    ${LIQ_UpfrontFeeAmount_Field}    ${UpfrontFee_Amount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FeePaymentNotebook
  
Populate Fee Details Window 
    [Documentation]    This keyword is used to populate data in Fee Details Window.
    ...    @author: mgaling
    ...    @update: archana     14JUL2020    - Added Pre-processing keywords and Screenshot path                  
    ...    @update: hstone      21JUL2020    - Replaced 'Mx Native Type' with 'Mx Press Combination'
    ...    @update: jloretiz    06AUG2020    - updated the variable name to use Fee Details
    [Arguments]    ${sFee_Type}    ${sUpfrontFeePayment_Comment}
    
    ###Pre-processing keyword###
    ${Fee_Type}    Acquire Argument Value    ${sFee_Type}
    ${UpfrontFeePayment_Comment}    Acquire Argument Value    ${sUpfrontFeePayment_Comment}       
    
    mx LoanIQ activate window    ${LIQ_UpfrontFeePayment_Notebook}
    mx LoanIQ click    ${LIQ_FeeDetail_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FeeDetails
    :FOR    ${i}    IN RANGE    3
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False
    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FeeDetails_Window}    VerificationData="Yes"
    mx LoanIQ click    ${LIQ_FeeDetails_Add_Button}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FeeDetail_Window}    VerificationData="Yes"
    mx LoanIQ select    ${LIQ_FeeDetail_FeeType_List}    ${Fee_Type}
    mx LoanIQ click    ${LIQ_FeeDetail_FeeType_OK_Button} 
    
    mx LoanIQ click    ${LIQ_FeeDetails_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    mx LoanIQ enter    ${LIQ_UpfrontFee_Comment_Field}    ${UpfrontFeePayment_Comment}
    Mx Press Combination    Key.BACKSPACE
    
Generate Intent Notices For Upfront Fee Payment
    [Documentation]    This keyword navigates the Issuance Fee Payment Notebook's Workflow tab and generates Intent Notices for the payment.
    ...    @author: mgaling
    ...    @update: hstone     22JUL2020    - Added Keyword Pre-processing
    ...                                     - Added Screenshot Path
    ...    @update: fluberio    22OCT2020    - Added condition in Writing Contact and Notice Method in Excel
    [Arguments]    ${sUpfrontFeePayment_NoticeMethod}   ${sEntity}=None

    ### Keyword Pre-processing ###
    ${UpfrontFeePayment_NoticeMethod}    Acquire Argument Value    ${sUpfrontFeePayment_NoticeMethod}
    ${Entity}    Acquire Argument Value    ${sEntity}

    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeePayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeePayment_WorkflowItems}    Generate Intent Notices%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    mx LoanIQ activate window    ${LIQ_UpfrontFeePaymentGroup_IntentNoticeGroup_Window}
    
    ${Contact}    Run Keyword If   '${SCENARIO}'=='4' and '${sEntity}' == 'EU'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UpfrontFeePaymentGroup_Tree}    Y%Contact%Contact     
    ${Notice_Method}    Run Keyword If   '${SCENARIO}'=='4' and '${sEntity}' == 'EU'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UpfrontFeePaymentGroup_Tree}    Y%Notice Method%Notice_Method
    Run Keyword If    '${SCENARIO}'=='4'    Run Keywords    Write Data to Excel    Correspondence    Contact    ${rowid}    ${Contact}
    ...    AND    Write Data to Excel    Correspondence    Notice_Method    ${rowid}    ${Notice_Method}

    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_UpfrontFeePaymentGroup_Tree}    ${UpfrontFeePayment_NoticeMethod}%s
    mx LoanIQ click    ${LIQ_UpfrontFeePaymentGroup_Edit_Button}
    mx LoanIQ activate window    ${LIQ_UpfrontFeePaymentGroup_IntentNotice_Window}
    mx LoanIQ select    ${LIQ_UpfrontFeePaymentGroup_IntentNotice_File_Preview}
    mx LoanIQ activate window    ${LIQ_Notice_Preview}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_Preview}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NoticePreview
    mx LoanIQ close window    ${LIQ_Notice_Preview}    
    mx LoanIQ close window    ${LIQ_UpfrontFeePaymentGroup_IntentNotice_Window}
    mx LoanIQ click    ${LIQ_UpfrontFeePaymentGroup_Exit_Button}

Send to Approval Upfront Fee Payment 
    [Documentation]    This keyword sends the Upfront Fee Payment to Approval. 
    ...    @author: mgaling
    ...    @update: clanding    05AUG2020    - updated hard coded values to global variables
    mx LoanIQ activate    ${LIQ_UpfrontFeePayment_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeePayment_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeePayment_WorkflowItems}    ${SEND_TO_APPROVAL_STATUS}%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_UpfrontFeePayment_Notebook}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeePaymentNotebook_AwaitingApproval}    VerificationData="Yes"
    
Approve Upfront Fee Payment
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Upfront Fee Payment.
    ...    @author: mgaling
    ...    @update: fmamaril    08MAY2019    Remove steps which is part of the generic keyword for work in process navigation
    ...    @update: clanding    05AUG2020    Updated hard coded values to global variables
    mx LoanIQ activate window    ${LIQ_UpfrontFeePayment_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeePayment_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeePayment_WorkflowItems}    ${APPROVAL_STATUS}%d 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    
Release Upfront Fee Payment
    [Documentation]    This keyword navigates the 'Work In Process' window and release the Upfront Fee Payment.
    ...    @author: mgaling
    ...    @update: fmamaril    08MAY2019    Remove steps which is part of the generic keyword for work in process navigation
    ...    @update: clanding    05AUG2020    Updated hard coded values to global variables
    mx LoanIQ activate    ${LIQ_UpfrontFeePayment_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeePayment_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeePayment_WorkflowItems}    ${RELEASE_STATUS}%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeePaymentNotebook_Released}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeePaymentNotebook_WorkflowTab_NoItems}    VerificationData="Yes"
    Close All Windows on LIQ

Release Upfront Fee Payment with Custom Instructions
    [Documentation]    This keyword navigates the 'Work In Process' window and release the Upfront Fee Payment.
    ...    @author: mgaling
    ...    @update: hstone     22JUL2020     - Removed WIP Navigation Code
    ...                                      - Added 'mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}'
    mx LoanIQ activate window    ${LIQ_UpfrontFeePayment_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeePayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeePayment_WorkflowItems}    Release%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeePaymentNotebook_Released}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeePaymentNotebook_WorkflowTab_NoItems}    VerificationData="Yes"

Validate Upfront Fee Notebook - Events Tab   
    [Documentation]    This keyword validates the Events Tab after the Upfront Fee Payment Transaction.
    ...    @author:mgaling  
    
    mx LoanIQ activate window    ${LIQ_UpfrontFeePayment_Notebook}
    
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeePayment_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_UpfrontFeePayment_Events_Items}    Released 
   
Navigate to Upfront Fee Payment then Input Details
    [Documentation]    This keyword will be used to navigate Upfront Fee and Enter Details
    ...    @author: ritragel
	...	   <update> 17Dec18 - bernchua : Removed last 2 lines because Fee Detail window is already open before executing this keyword.
    ...    @update: hstone      20JUL2020     - Added Keyword Pre-processing
    ...                                       - Removed Commented Lines
    [Arguments]    ${sFee_Amount}    ${sFee_Currency}

    ### Keyword Pre-processing ####
    ${Fee_Amount}    Acquire Argument Value    ${sFee_Amount}
    ${Fee_Currency}    Acquire Argument Value    ${sFee_Currency}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_PaymentUpfrontFeeBorr_Menu}
    mx LoanIQ activate window    ${LIQ_UpfrontFeePayment_Notebook} 
    mx LoanIQ enter    ${LIQ_UpfrontFeeAmount_Field}    ${Fee_Amount}
    Mx LoanIQ Select Combo Box Value    ${LIQ_UpfrontFeePaymentNotebook_Currency_Dropdown}    ${Fee_Currency}
    
Generate Intent Notices For Fee Payment
    [Documentation]    This keyword navigates the Issuance Fee Payment Notebook's Workflow tab and generates Intent Notices for the payment.
    ...    @author: ritragel/magaling
    [Arguments]    ${UpfrontFeePayment_NoticeMethod}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeePayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeePayment_WorkflowItems}    Generate Intent Notices%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    mx LoanIQ activate window    ${LIQ_UpfrontFeePayment_NoticeGroup_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_UpfrontFeePaymentGroup_Tree}    ${UpfrontFeePayment_NoticeMethod}%s
    mx LoanIQ click    ${LIQ_UpfrontFeePaymentGroup_Edit_Button}
    mx LoanIQ maximize    ${LIQ_UpfrontFeePaymentGroup_IntentNotice_Window}       
    mx LoanIQ select    ${LIQ_UpfrontFeePaymentGroup_IntentNotice_File_Preview}
    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_Preview}          VerificationData="Yes"
    Sleep    5s
    Take Screenshot
    mx LoanIQ close window    ${LIQ_Notice_Preview}    
    mx LoanIQ close window    ${LIQ_UpfrontFeePaymentGroup_IntentNotice_Window}
    mx LoanIQ activate window    ${LIQ_UpfrontFeePayment_NoticeGroup_Window}
    mx LoanIQ click    ${LIQ_UpfrontFeePayment_NoticeGroup_Exit_Button}
    
Navigate to Release Payment via WIP
    [Documentation]    This keyword will navigate to Release via WIP
    ...    @author: ritragel
    [Arguments]    ${Deal_Name}
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate    ${LIQ_TransactionInProcess_Window}   
    Mx LoanIQ Active Javatree Item    ${LIQ_TransactionInProcess_Tree}    Payments
    mx LoanIQ maximize    ${LIQ_TransactionInProcess_Window}
    Mx LoanIQ DoubleClick    ${LIQ_TransactionInProcess_Payments_Tree}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionInProcess_Payments_Tree}    Fee Payment From Borrower
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_TransactionInProcess_Payments_Tree}    ${Deal_Name}%d
    mx LoanIQ activate    ${LIQ_UpfrontFeePayment_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeePayment_Tab}    Workflow

Navigate to Upfront Fee Payment Workflow and Proceed With Transaction
    [Documentation]    This keyword navigates to the Upfront Fee Payment Workflow and proceeds with the desired Transaction
    ...  @author: hstone    20JUL2020    Initial create
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_UpfrontFeePayment_Notebook}    ${LIQ_UpfrontFeePayment_Tab}    ${LIQ_UpfrontFeePayment_WorkflowItems}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UpfrontFeePayment_Workflow

Populate Upfront Fee From Borrower / Agent
    [Documentation]    This keyword navigates to the Upfront Fee Payment Fee From Borrower.
    ...    Populates the field in Upfront Fee from Borrower Notebook.
    ...    @author: jloretiz    29JUL2020    - initial create
    [Arguments]    ${sBranch}    ${sAmount}    ${sCurrency}

    ###Keyword Pre-processing###
    ${Branch}    Acquire Argument Value    ${sBranch}
    ${Amount}    Acquire Argument Value    ${sAmount}
    ${Currency}    Acquire Argument Value    ${sCurrency}

    ###Navigate to Upfront Fee From Borrower in Loan Drawdown###
    Mx LoanIQ Select    ${LIQ_InitialDrawdown_Options_UpfrontFreeFromBorrower}
    Mx LoanIQ Activate    ${LIQ_UpfrontFeeFromBorrower_Window}

    ###Populate Fields###
    Mx LoanIQ Select Combo Box Value    ${LIQ_UpfrontFeeFromBorrower_Branch_ComboBox}    ${Branch}
    Mx LoanIQ Enter    ${LIQ_UpfrontFeeFromBorrower_Amount_Textfield}    ${sAmount}

    ###Validate Currency and Navigate to Fee Details###
    ${UI_Currency}    Mx LoanIQ Get Data    ${LIQ_UpfrontFeeFromBorrower_Currency_ComboBox}    Currency
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${UI_Currency}    ${Currency}
    Run Keyword If    '${IsEqual}'=='${FALSE}'    Fail    Expected Currency(${Currency}) is not equal to Actual Currency(${UI_Currency})!
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UpfrontFeeFromBorrower

Save and Exit Upfront Fee From Borrower / Agent
    [Documentation]    This keyword saves the changes for Upfront Fee From borrower and close the notebook.
    ...    @author: jloretiz    29JUL2020    - initial create

    Mx LoanIQ Select    ${LIQ_UpfrontFeeFromBorrower_Options_Save}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_OK_Button}
    Mx LoanIQ Select    ${LIQ_UpfrontFeeFromBorrower_Options_Exit}
    
Get Upfront Fee Details in Upfront Fee Payment Notebook 
    [Documentation]    This keyword returns Effective Date, Upfront Fee Ammount and Branch Description in Upfront Fee Payment Notebook
    ...    @author: fluberio    28OCT2020    Initial Create
    
    ${Effective_Date}    Mx LoanIQ Get Data    ${LIQ_UpfrontFeeFromBorrower_EffectiveDate_Textfield}    text%Effective_Date
    ${UpfrontFee_Amount}    Mx LoanIQ Get Data    ${LIQ_UpfrontFeeFromBorrower_Amount_Textfield}    text%UpfrontFee_Amount
    ${Branch_Description}   Mx LoanIQ Get Data    ${LIQ_UpfrontFeeFromBorrower_Branch_ComboBox}    text%Branch_Description
    [Return]    ${Effective_Date}    ${UpfrontFee_Amount}    ${Branch_Description}