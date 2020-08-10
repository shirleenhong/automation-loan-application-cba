*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Set Ticking Fee Definition Details
    [Documentation]    This keyword enters the details in the Ticking Fee Definition window.
    ...    @author: bernchua
    [Arguments]    ${sDealProposedCmtAmt_XRate}    ${sEffective_Date}    ${sCurrent_Balance}    ${sRate_Basis}    ${sTickingFee_Currency}
    ...    ${sDeal_Borrower}    ${sBorrower_SGName}    ${sBorrower_SGAlias}    ${sBorrower_Location}
       
       ##Keyword Preprocessing### 
    
    ${DealProposedCmtAmt_XRate}    Acquire Argument Value    ${sDealProposedCmtAmt_XRate}
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
    ${Current_Balance}    Acquire Argument Value    ${sCurrent_Balance}
    ${Rate_Basis}    Acquire Argument Value    ${sRate_Basis}
    ${TickingFee_Currency}    Acquire Argument Value    ${sTickingFee_Currency}
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}
    ${Borrower_SGName}    Acquire Argument Value    ${sBorrower_SGName}
    ${Borrower_SGAlias}    Acquire Argument Value    ${sBorrower_SGAlias}  
    ${Borrower_Location}    Acquire Argument Value    ${sBorrower_Location}   

    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Payments_TickingFeeDefinition_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_TickingFeeDefinition_Window}
    ${ServicingGroup}    Set Variable    ${Borrower_SGName}(alias:${Borrower_SGAlias})(${sBorrower_Location})
    Validate Ticking Fee Definition Details    ${Current_Balance}    ${TickingFee_Currency}    ${Deal_Borrower}    ${ServicingGroup}
    mx LoanIQ enter    ${LIQ_TickingFeeDefinition_DealProposedCmtAmt_Textfield}    ${DealProposedCmtAmt_XRate}
    mx LoanIQ enter    ${LIQ_TickingFeeDefinition_EffectiveDate_Field}    ${Effective_Date}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_TickingFeeDefinition_RateBasis_Combobox}    ${Rate_Basis}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFeeDefinition
    
Complete Ticking Fee Setup
    [Documentation]    This keyword completes the Ticking Fee setup by clicking the 'Ok' button.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_TickingFeeDefinition_Window}    
    mx LoanIQ click    ${LIQ_TickingFeeDefinition_Ok_Button}    
        
Validate Ticking Fee 'to Today' Projected Amount
    [Documentation]    This keyword validates the Ticking Fee ' to Today' Projected Amount.
    ...    @author: bernchua
    ${ProjAmtToToday_Computed}    Compute Ticking Fee 'To Today' Projected Amount
    ${ProjAmtToToday_UI}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_ProjectedAmtToToday_Text}    value%amount
    ${ProjAmtToToday_UI}    Remove Comma, Negative Character and Convert to Number    ${ProjAmtToToday_UI}
    ${ProjAmtToToday_VerifyStatus}    Run Keyword And Return Status    Should Be Equal As Numbers    ${ProjAmtToToday_Computed}    ${ProjAmtToToday_UI}        
    Run Keyword If    ${ProjAmtToToday_VerifyStatus}==True    Log    Projected Amount 'to Today' value verified.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFee
    
Validate Ticking Fee 'to Proj Deal Close Date' Projected Amount
    [Documentation]    This keyword verified if the Projected Close Date in the Deal Notebook is Empty or not.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    ${Deal_ProjectedCloseDate}    Mx LoanIQ Get Data    ${LIQ_DealNotebook_ProjectedCloseDate_Textfield}    value%date
    Run Keyword If    '${Deal_ProjectedCloseDate}'!='${EMPTY}'    Validate 'to Proj Deal Close Date' Amount
    ...    ELSE    Log    Deal Projected Close Date is Empty.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook_ValidateTickingFee
    
Validate 'to Proj Deal Close Date' Amount
    [Documentation]    This keyword validates the "to Proj. Deal Close Date" Projected Amount in the Ticking Fee Definition.
    ...    @author: bernchua
    ${ProjAmtToClose_Computed}    Compute Ticking Fee 'To Proj Deal Close Date' Projected Amount
    ${ProjAmtToClose_UI}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_ProjectedAmtToToday_Text}    value%amount
    ${ProjAmtToClose_UI}    Remove Comma, Negative Character and Convert to Number    ${ProjAmtToClose_UI}
    ${ProjAmtToClose_VerifyStatus}    Run Keyword And Return Status    Should Be Equal As Numbers    ${ProjAmtToClose_Computed}    ${ProjAmtToClose_UI}        
    Run Keyword If    ${ProjAmtToClose_VerifyStatus}==True    Log    Projected Amount 'to Today' value verified.
    
Validate Ticking Fee Definition Details
    [Documentation]    This keyword validates all the necessary information in the Ticking Fee Definition windwo.
    ...    @author: bernchua
    [Arguments]    ${sCurrent_Balance}    ${sTickingFee_Currency}    ${sDeal_Borrower}    ${sServicingGroup}
    
    ##Keyword Preprocessing### 
    
    ${sCurrent_Balance}    Acquire Argument Value    ${sCurrent_Balance}
    ${TickingFee_Currency}    Acquire Argument Value    ${sTickingFee_Currency}
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}
    ${ServicingGroup}    Acquire Argument Value    ${sServicingGroup}    

    mx LoanIQ activate    ${LIQ_TickingFeeDefinition_Window}
    ${Validate_CBalance}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_TickingFeeDefinition_CurrentBalance_StaticText}    value%${sCurrent_Balance}
    ${Validate_Currency}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_TickingFeeDefinition_Currency_StaticText}    value%${TickingFee_Currency}    
    ${Validate_Borrower}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_TickingFeeDefinition_FeePaidBy_StaticText}    value%${Deal_Borrower}
    ${Validate_SrvGroup}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_TickingFeeDefinition_ServicingGroup_StaticText}    value%${ServicingGroup}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFeeDefinition
    
Compute Ticking Fee 'To Today' Projected Amount
    [Documentation]    This keyword computed for the Ticking Fee's 'To Today' Projected Amount
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - remove post-processing keyword as this keyword is not called from business process keywords
    ...    @update: dahijara    06JUL2020    - addressed review point: retained post-processing keyword, added argument for runtime variable.
    [Arguments]    ${sRunTimeVar_ToTodayProjectedAmount}=None  
    # Get all necessary values from the UI for the computation
    ${CurrentBalance}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_CurrentBalance_StaticText}    value%balance
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_DealProposedCmtAmt_Textfield}    value%rate
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_RateBasis_Combobox}    value%ratebasis
    ${EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_EffectiveDate_Field}    value%date
    ${CurrentDate}    Get System Date
    
    # Compute for the time, remove non-numeric characters from the string, and convert the strings to numbers
    ${CurrentBalance}    Remove Comma, Negative Character and Convert to Number    ${CurrentBalance}
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Number    ${RateBasis}
    ${Time}    Get Number Of Days Betweeen Two Dates    ${CurrentDate}    ${EffectiveDate}
    
    # Evaluate for the actual amount
    ${ToToday_ProjectedAmount}    Evaluate    ((${CurrentBalance}*${Rate})/${RateBasis})*${Time}
    ${ToToday_ProjectedAmount}    Convert To Number    ${ToToday_ProjectedAmount}    2

    ###post keyword processing###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ToTodayProjectedAmount}    ${ToToday_ProjectedAmount}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFeeDefinition
    [Return]    ${ToToday_ProjectedAmount}

Compute Ticking Fee 'To Proj Deal Close Date' Projected Amount
    [Documentation]    This keyword computed for the Ticking Fee's 'To Proj. Deal Close Date' Projected Amount
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - removed keyword post-processing as this keyword is not being called from business process keywords
    ...    @update: dahijara    06JUL2020    - addressed review point: retained post-processing keyword, added argument for runtime variable. Added keyword for taking screenshot.   
    [Arguments]    ${sRunTimeVar_ToCloseDateProjectedAmount}=None       
    # Get all necessary values from the UI for the computation
    ${CurrentBalance}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_CurrentBalance_StaticText}    value%balance
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_DealProposedCmtAmt_Textfield}    value%rate
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_RateBasis_Combobox}    value%ratebasis
    ${CloseDate}    Mx LoanIQ Get Data    ${LIQ_DealNotebook_ProjectedCloseDate_Textfield}    value%date
    ${EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_EffectiveDate_Field}    value%date
    
    # Compute for the time, remove non-numeric characters from the string, and convert the strings to numbers
    ${CurrentBalance}    Remove Comma, Negative Character and Convert to Number    ${CurrentBalance}
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Number    ${RateBasis}
    ${Time}    Get Number Of Days Betweeen Two Dates    ${CloseDate}    ${EffectiveDate}
    
    # Evaluate for the actual amount
    ${ToCloseDate_ProjectedAmount}    Evaluate    ((${CurrentBalance}*${Rate})/${RateBasis})*${Time}
    ${ToCloseDate_ProjectedAmount}    Convert To Number    ${ToCloseDate_ProjectedAmount}    2
    ###post keyword processing###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ToCloseDateProjectedAmount}    ${ToCloseDate_ProjectedAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFeeDefinition
    [Return]    ${ToCloseDate_ProjectedAmount}

Complete Ticking Fee Definition Setup
    [Documentation]    This keyword clicks The 'Ok' button in the Ticking Fee Definition window to complete the setup.
    ...    @author: bernchua
    ...    @update: ehugo    30JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_TickingFeeDefinition_Window}
    mx LoanIQ click    ${LIQ_TickingFeeDefinition_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TickingFeeDefinitionWindow_CompleteTickingFeeDefinition
    
Get Ticking Fee Amount From Definition
    [Documentation]    This keyword gets the Ticking Fee Amount from the Ticking Fee Definition.
    ...    @author: bernchua
    ...    @update: fmamaril    27MAY2020    - added optional argument for keyword post processing
    [Arguments]    ${sRuntime_Variable}=None
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Payments_TickingFeeDefinition_Menu}        
    mx LoanIQ activate    ${LIQ_TickingFeeDefinition_Window}    
    ${TickingFee_Amount}    Mx LoanIQ Get Data    ${LIQ_TickingFeeDefinition_TickingFeeAmount_Text}    value%amount
    mx LoanIQ close window    ${LIQ_TickingFeeDefinition_Window}
   
    ####post keyword processing###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${TickingFee_Amount}   
    [Return]    ${TickingFee_Amount}     
 
Create Ticking Fee Payment
    [Documentation]    This keyword initiates a Ticking Fee Payment.
    ...    @author: bernchua
    ...    @update: fmamaril    27MAY2020    Add Screemshot Path
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Payments_TickingFee_Menu}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFee
    
Validate Ticking Fee Details
    [Documentation]    This keyword validates the details in the Ticking Fee Notebook's General Tab.
    ...    @author: bernchua
    ...    @update: archana   22MAY2020    - added optional argument for keyword pre processing
    [Arguments]    ${sDeal_Name}    ${sDeal_ProposedCmt}    ${sTickingFee_Amount}    ${sDeal_BorrowerName}
    
    ##Keyword Preprocessing### 
    
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Deal_ProposedCmt}    Acquire Argument Value    ${sDeal_ProposedCmt}
    ${TickingFee_Amount}    Acquire Argument Value    ${sTickingFee_Amount}
    ${Deal_BorrowerName}    Acquire Argument Value    ${sDeal_BorrowerName} 
    
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ activate    ${LIQ_TickingFeeNotebook_Window}
    ${TickingFee_DealName}    Mx LoanIQ Get Data    ${LIQ_TickingFeeNotebook_DealName_Text}    value%name
    ${TickingFee_ProposedCmt}    Mx LoanIQ Get Data    ${LIQ_TickingFeeNotebook_DealProposedCmt_Text}    value%amount
    ${TickingFee_Amount}    Mx LoanIQ Get Data    ${LIQ_TickingFeeNotebook_DealProposedCmt_Text}    value%amount    
    ${TickingFee_BorrowerName}    Mx LoanIQ Get Data    ${LIQ_TickingFeeNotebook_DealBorrowerName_Text}    value%name
    Run Keyword If    '${TickingFee_DealName}'=='${Deal_Name}'    Log    Ticking Fee Deal Name verified.     
    Run Keyword If    '${TickingFee_ProposedCmt}'=='${Deal_ProposedCmt}'    Log    Ticking Fee Deal Proposed Cmt verified.
    Run Keyword If    '${TickingFee_Amount}'=='${TickingFee_Amount}'    Log    Ticking Fee Amount verified.
    Run Keyword If    '${TickingFee_BorrowerName}'=='${Deal_BorrowerName}'    Log    Ticking Fee Borrower Name verified.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFee
    
Set Ticking Fee General Tab Details
    [Documentation]    This keyword sets the required details in the Ticking Fee Notebook.
    ...    @author: bernchua
    ...    @update: archana   22MAY2020    - added optional argument for keyword pre processing
    [Arguments]    ${sTickingFee_RequestedAmount}    ${sTickingFee_EffectiveDate}    ${sTickingFee_Comment}
    
    ##Keyword Preprocessing### 
    
    ${TickingFee_RequestedAmount}    Acquire Argument Value    ${sTickingFee_RequestedAmount}
    ${TickingFee_EffectiveDate}    Acquire Argument Value     ${sTickingFee_EffectiveDate}
    ${TickingFee_Comment}    Acquire Argument Value    ${sTickingFee_Comment}

    mx LoanIQ activate    ${LIQ_TickingFeeNotebook_Window}
    mx LoanIQ enter    ${LIQ_TickingFeeNotebook_RequestedAmount_Textfield}    ${TickingFee_RequestedAmount}
    mx LoanIQ enter    ${LIQ_TickingFeeNotebook_EffectiveDate_Field}    ${TickingFee_EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_TickingFeeNotebook_Comment_Textfield}    ${TickingFee_Comment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFee
    
Save Ticking Fee
    [Documentation]    This keyword saves the details set in the Ticking Fee Notebook's General Tab for the Payment.
    ...    @author: bernchua
    ...    @update: archana   22MAY2020    - added oscreenshot path
    mx LoanIQ activate    ${LIQ_TickingFeeNotebook_Window}
    mx LoanIQ select    ${LIQ_TickingFeeNotebook_Menu_Save}
    Wait Until Keyword Succeeds    10 min    3 sec    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Wait Until Keyword Succeeds    5 min    3 sec    Mx Click Element If Present    ${LIQ_Warning_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFeeDefinition
    
Generate Intent Notices For Ticking Fee Payment
    [Documentation]    This keyword navigates the transaction workflow and generates intent notices.
    ...    @author: bernchua
    [Arguments]    ${sCustomer_Name}        
    
    mx LoanIQ activate    ${LIQ_Notices_Window}    
    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_PaymentGroupCreatedBy_Window}
    ${Notice_Contact}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PaymentGroupCreatedBy_Tree}    ${sCustomer_Name}%Contact%contact    
    ${Notice_Method}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PaymentGroupCreatedBy_Tree}    ${sCustomer_Name}%Notice Method%method
    mx LoanIQ select    ${LIQ_PaymentGroupCreatedBy_File_Preview}
    ${Error_Displayed}    Run Keyword And Return Status    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    Run Keyword If    ${Error_Displayed}==True    Run Keywords
    ...    mx LoanIQ click    ${LIQ_PaymentGroupCreatedBy_EditHighlightedNotices_Button}
    ...    AND    Verify If Text Value Exist in Textfield on Page    Payment created by    ${sCustomer_Name}
    ...    AND    Verify If Text Value Exist in Textfield on Page    Payment created by    ${Notice_Contact}    
    ...    AND    Validate Loan IQ Details    ${Notice_Method}    ${LIQ_PaymentCreatedBy_NoticeMethod_Combobox}
    ...    AND    mx LoanIQ select    ${LIQ_PaymentCreatedBy_File_Preview}
    ...    AND    Sleep    10
    ...    AND    mx LoanIQ close window    ${LIQ_NoticePreview_Window}
    ...    AND    mx LoanIQ close window    ${LIQ_PaymentCreatedBy_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFee
    mx LoanIQ click    ${LIQ_PaymentGroupCreatedBy_Exit_Button}

### Keyword Post-processing ###

    Save Values of Runtime Execution on Excel File    ${sCustomer_Name}    ${Notice_Contact}         
    Save Values of Runtime Execution on Excel File    ${sCustomer_Name}    ${Notice_Method} 
    [Return]    ${Notice_Contact}    ${Notice_Method}    

Validate Ticking Fee Events
    [Documentation]    This keyword validates the Events Tab of the Ticking Fee Notebook.
    ...    @author: bernchua
    ...    @update: archana   22MAY2020    - added optional argument for keyword pre processing
    [Arguments]    ${sConvertedTickingFee_Amount}
    
     ##Keyword Preprocessing### 
    
    ${ConvertedTickingFee_Amount}    Acquire Argument Value    ${sConvertedTickingFee_Amount}
    
    mx LoanIQ activate    ${LIQ_TickingFeeNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_TickingFeeNotebook_Tab}    Events
    ${Transaction_Status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_TickingFeeNotebook_Events_Tree}    Released%s
    ${Payment_Status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_TickingFeeNotebook_Events_Tree}    Payment Released%s
    ${TickingFeePayment_EventsComment}    Mx LoanIQ Get Data    ${LIQ_TickingFeeNotebook_Events_Comment}    value%comment    
    ${Verify_PaymentComment}    Run Keyword And Return Status    Should Contain    ${TickingFeePayment_EventsComment}    ${ConvertedTickingFee_Amount}        
    Run Keyword If    ${Transaction_Status}==True    Log    Ticking Fee Transaction is verified as Released.
    ...    ELSE    Log    Ticking Fee Transaction is not Released.
    Run Keyword If    ${Payment_Status}==True    Log    Ticking Fee Payment Transaction is verified as Released.
    ...    ELSE    Log    Ticking Fee Payment Transaction is not Released.
    Run Keyword If    ${Verify_PaymentComment}==True    Log     A Ticking Fee Payment with an amount of ${ConvertedTickingFee_Amount} is verified as Released.
    ...    ELSE    Log    A Ticking Fee Payment for the amount of ${ConvertedTickingFee_Amount} is not found.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFeeEvents
    
Validate Ticking Fee Notebook Pending Tab
    [Documentation]    This keyword validates the items in the Ticking Fee Notebook's Pending Tab.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_TickingFeeNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_TickingFeeNotebook_Tab}    Pending
    ${PendingTransaction_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_TickingFeeNotebook_PendingTransactions_EmptyTree}        VerificationData="Yes"
    Run Keyword If    ${PendingTransaction_Status}==True    Log    There are no Pending Transactions in the Ticking Fee Notebook.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFeeNotebook
    
Validate Ticking Fee In Deal Notebook's Events And Pending Tabs
    [Documentation]    This keyword verifies the Ticking Fee transaction in the Deal Notebook's Events and Pending Tabs.
    ...    @author: bernchua
    ...    @update: archana   22MAY2020    - added optional argument for keyword pre processing
    [Arguments]    ${sConvertedTickingFee_Amount}
    
     ##Keyword Preprocessing### 
    
    ${ConvertedTickingFee_Amount}    Acquire Argument Value    ${sConvertedTickingFee_Amount}    

    mx LoanIQ select    ${LIQ_TickingFeeNotebook_Menu_DealNotebook}
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}    
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    ${DealEvent_TickingFeeStatus}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Events_Javatree}    Ticking Fee Released%s       
    ${DealEvent_TickingFeeComment}    Run Keyword If    ${DealEvent_TickingFeeStatus}==True    Mx LoanIQ Get Data    ${LIQ_Events_Comment_Textfield}    value%comment
    ...    ELSE    Fail    Log    No Event in the Deal Notebook for Ticking Fee exists with Released status.    ...    
    ${Verify_TickingFeeComment}    Run Keyword And Return Status    Should Contain    ${DealEvent_TickingFeeComment}    ${ConvertedTickingFee_Amount}          
    Run Keyword If    ${Verify_TickingFeeComment}==True    Log    Deal Notebook Event for Ticking Fee Transaction is verified as Released with an amount of ${ConvertedTickingFee_Amount}.    
    ...    ELSE    Fail    Log    No Ticking Fee amount of ${ConvertedTickingFee_Amount} found in the comment for the Ticking Fee entry in the Deal Notebook's Events list.
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pending
    ${DealPending_TickingFeeStatus}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_PendingTransactions_Tree_Empty}    VerificationData="Yes"
    Run Keyword If    ${DealPending_TickingFeeStatus}==True    Log    No Pending Transactions for Ticking Fee listed in Deal Notebook.
    ...    ELSE    Fail    Log    Pending Transaction exists in the Deal Notebook for Ticking Fee.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_TickingFeePendingTab    

Navigate to Ticking Fee Workflow and Proceed With Transaction
    [Documentation]    This keyword navigates to the Ticking Fee Workflow using the desired Transaction
    ...  @author: dahijara    22JUL2020    Initial create
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_TickingFeeNotebook_Window}    ${LIQ_TickingFeeNotebook_Tab}    ${LIQ_TickingFeeNotebook_Tree}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TickingFeeWindow_WorkflowTab