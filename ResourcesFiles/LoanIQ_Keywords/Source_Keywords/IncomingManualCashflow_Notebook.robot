*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 

Launch Incoming Manual Cashflow Notebook
    [Documentation]    This Keyword is used for navigating to Incoming  (Debit DDA,  IMT or Nostro) Manual Cashflow Notebook.
    ...    @author: mgaling
    ...    @update: hstone     02JUL2020      - Removed Extra Spaces
    
    mx LoanIQ activate window    ${LIQ_ManualCashflowSelect_Window}
    Mx LoanIQ Set    ${LIQ_ManualCashflowSelect_New_RadioButton}    ON  
    Mx LoanIQ Set    ${LIQ_ManualCashflowSelect_Incoming_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualCashflowSelect
    mx LoanIQ click    ${LIQ_ManualCashflowSelect_OK_Button} 
    
    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    
Populate Incoming Manual Cashflow Notebook - General Tab
    [Documentation]    This Keyword is used for populating Incoming Manual Cashflow Notebook - General Tab.
    ...    @author: mgaling
    ...    @update: hstone      02JUL2020      - Added Keyword Pre-processing
    ...                                        - Removed extra spaces
    ...    @update: hstone      13JUL2020      - Used actual locator for verifying attached text of a static text
    ...    @update: makcamps    17FEB2021      - added search deal expense code before clicking expense code from tree
    [Arguments]    ${sBranch_Code}    ${sEffective_Date}    ${sCurrency}    ${sUpfrontFee_Amount}    ${sDescription}    ${sProc_Area}    ${sDeal_ExpenseCode}    ${sDeal_Borrower}
    ...    ${sCustomer_ServicingGroup}    ${sBranch_ServicingGroup}    ${sDeal_Name}=None    ${sFacility_Name}=None
    
    ### Keyword Pre-processing ###
    ${Branch_Code}    Acquire Argument Value    ${sBranch_Code}
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
    ${Currency}    Acquire Argument Value    ${sCurrency}
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${Description}    Acquire Argument Value    ${sDescription}
    ${Proc_Area}    Acquire Argument Value    ${sProc_Area}
    ${Deal_ExpenseCode}    Acquire Argument Value    ${sDeal_ExpenseCode}
    ${Deal_Borrower}    Acquire Argument Value    ${sDeal_Borrower}
    ${Customer_ServicingGroup}    Acquire Argument Value    ${sCustomer_ServicingGroup}
    ${Branch_ServicingGroup}    Acquire Argument Value    ${sBranch_ServicingGroup}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IncomingManualCashflow_Tab}    General
    
    mx LoanIQ select list    ${LIQ_IncomingManualCashflow_Branch_List}    ${Branch_Code}
    mx LoanIQ enter    ${LIQ_IncomingManualCashflow_EffectiveDate_Field}    ${Effective_Date}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ select list    ${LIQ_IncomingManualCashflow_Currency_List}    ${Currency}
    mx LoanIQ enter    ${LIQ_IncomingManualCashflow_Amount_Field}    ${UpfrontFee_Amount}
    mx LoanIQ enter    ${LIQ_IncomingManualCashflow_Description_Field}    ${Description}
    mx LoanIQ select list    ${LIQ_IncomingManualCashflow_ProcArea_List}    ${Proc_Area}
    
    ### Cashflow Section ###
    ${ExpenseCode_Status}    Run Keyword And Return Status    Validate Loan IQ Details    ${Deal_ExpenseCode}    ${LIQ_IncomingManualCashflow_Expense_Field}
    Run Keyword If    '${ExpenseCode_Status}'=='True'    Log    Deal Expense Code filled-out matches the test data.
    ...    ELSE    Run Keywords    Log    Deal Expense Code filled-out does not match the test data. Test Script will proceed with expense code selection based from test data.
    ...    AND    mx LoanIQ click    ${LIQ_IncomingManualCashflow_Expense_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_SelectExpenseCode_Window}
    ...    AND    mx LoanIQ enter    ${LIQ_SelectExpenseCode_Search_Field}    ${Deal_ExpenseCode}
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectExpenseCode_JavaTree}    ${Deal_ExpenseCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_SelectExpenseCode_OK_Button}

    ${CustomerDisplay_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    JavaWindow("title:=Incoming Manual Cashflow .*").JavaStaticText("attached text:=${Deal_Borrower}")    attached text%${Deal_Borrower}
    Run Keyword If    '${CustomerDisplay_Status}'=='True'    Log    Customer filled-out matches the test data.
    ...    ELSE    Run Keywords    Log    Customer filled-out does not match the test data. Test Script will proceed with expense code selection based from test data.
    ...    AND    mx LoanIQ click    ${LIQ_IncomingManualCashflow_Customer_Button}
    ...    AND    Select Customer by Short Name    ${Deal_Borrower}

    Run Keyword If    '${Deal_Name}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_IncomingManualCashflow_Deal_Button}
    ...    AND    Select Existing Deal    ${Deal_Name}
    Run Keyword If    '${Facility_Name}'!='None'    Mx LoanIQ Select Combo Box Value    ${LIQ_IncomingManualCashflow_Facility_Dropdown}    ${Facility_Name}

    mx LoanIQ click    ${LIQ_IncomingManualCashflow_ServicingGroup_Button}
    mx LoanIQ activate window    ${LIQ_ExistingServicingGroup_Window}
    Mx LoanIQ Select String    ${LIQ_ExistingServicingGroup_JavaTree}    ${Customer_ServicingGroup}
    mx LoanIQ click    ${LIQ_ExistingServicingGroup_OK_Button}
    Mx LoanIQ Verify Runtime Property    JavaWindow("title:=Incoming Manual Cashflow .*").JavaStaticText("attached text:=${Branch_ServicingGroup}")    attached text%${Branch_ServicingGroup}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IncomingManualCashflow_General

Add Credit Offset in Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is for adding Credit in Incoming Manual Cashflow Notebook.
    ...    @author: mgaling
    ...    @update: hstone     03JUL2020     - Added Keyword Pre-processing
    ...                        07JUL2020     - Added Portfolio Code Input Handling
    ...    @update: dahijara    09OCT2020    - Updated keyword for selecting in combobox. From "mx LoanIQ select list" to "Mx LoanIQ Select Combo Box Value"
    [Arguments]    ${sUpfrontFee_Amount}    ${sGL_ShortName}    ${sPortfolioCode}=None
    
    ### Keyword Pre-processing ###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    ${PortfolioCode}    Acquire Argument Value    ${sPortfolioCode}

    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    mx LoanIQ click    ${LIQ_IncomingManualCashflow_AddCreditOffset_Button}
    
    mx LoanIQ activate window    ${LIQ_CreditGLOffsetDetails_Window}
    Mx LoanIQ Set    ${LIQ_CreditGLOffsetDetails_NewWIP_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_CreditGLOffsetDetails_Amount_Field}    ${UpfrontFee_Amount}
    Mx LoanIQ Select Combo Box Value    ${LIQ_CreditGLOffsetDetails_GLShortName_List}    ${GL_ShortName}
    Run Keyword If    '${sPortfolioCode}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_CreditGLOffsetDetails_Portfolio_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_SelectPortfolioCode_Window}
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SelectPortfolioCode
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectPortfolioCode_JavaTree}    ${PortfolioCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_SelectPortfolioCode_OK_Button}
    mx LoanIQ activate window    ${LIQ_CreditGLOffsetDetails_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CreditGLOffsetDetails
    mx LoanIQ click    ${LIQ_CreditGLOffsetDetails_OK_Button}

Add Credit Offset Fee Income in Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is for adding Credit (Fee Income) in Incoming Manual Cashflow Notebook.
    ...    @author: makcamps    17FEB2021    - initial create
    [Arguments]    ${sUpfrontFee_Amount}    ${sGL_ShortName}    ${sPortfolioCode}=None
    
    ### Keyword Pre-processing ###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    ${PortfolioCode}    Acquire Argument Value    ${sPortfolioCode}

    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    mx LoanIQ click    ${LIQ_IncomingManualCashflow_AddCreditOffset_Button}
    
    mx LoanIQ activate window    ${LIQ_CreditGLOffsetDetails_Window}
    Mx LoanIQ Set    ${LIQ_CreditGLOffsetDetails_FeeIncome_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_CreditGLOffsetDetails_Amount_Field}    ${UpfrontFee_Amount}
    Mx LoanIQ Select Combo Box Value    ${LIQ_CreditGLOffsetDetails_GLShortName_List}    ${GL_ShortName}
    Run Keyword If    '${sPortfolioCode}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_CreditGLOffsetDetails_Portfolio_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_SelectPortfolioCode_Window}
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SelectPortfolioCode
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectPortfolioCode_JavaTree}    ${PortfolioCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_SelectPortfolioCode_OK_Button}
    mx LoanIQ activate window    ${LIQ_CreditGLOffsetDetails_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CreditGLOffsetDetails
    mx LoanIQ click    ${LIQ_CreditGLOffsetDetails_OK_Button}

Save and Validate Data in Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is for saving and validating data in Incoming Manual Cashflow Notebook.
    ...    @author: mgaling
    ...    @update: hstone      03JUL2020      - Removed Extra Spaces
    ...                         07JUL2020      - Added Keyword Pre-processing
    [Arguments]    ${sUpfrontFee_Amount}    ${sGL_ShortName}    ${sDeal_ExpenseCode}

    ### Keyword Pre-processing ###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    ${Deal_ExpenseCode}    Acquire Argument Value    ${sDeal_ExpenseCode}
    
    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    mx LoanIQ select    ${LIQ_IncomingManualCashflow_FileSave_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_IncomingManualCashflow_JavaTree}    ${UpfrontFee_Amount}
    Run Keyword If    ${status}==True    Log    ${UpfrontFee_Amount} is reflected   
    Run Keyword If    ${status}==False    Log    Fail    ${UpfrontFee_Amount} is not reflected 
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_IncomingManualCashflow_JavaTree}    ${GL_ShortName}
    Run Keyword If    ${status}==True    Log    ${GL_ShortName} is reflected   
    Run Keyword If    ${status}==False    Log    Fail    ${GL_ShortName} is not reflected 
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_IncomingManualCashflow_JavaTree}    ${Deal_ExpenseCode}
    Run Keyword If    ${status}==True    Log    ${Deal_ExpenseCode} is reflected   
    Run Keyword If    ${status}==False    Log    Fail    ${Deal_ExpenseCode}  is not reflected 
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_IncomingManualCashflow_JavaTree}    TOTAL:${SPACE}${UpfrontFee_Amount}
    Run Keyword If    ${status}==True    Log    TOTAL:${SPACE}${UpfrontFee_Amount} is reflected   
    Run Keyword If    ${status}==False    Log    Fail    TOTAL:${SPACE}${UpfrontFee_Amount} is not reflected 
       
Navigate to Cashflow in Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is for creating cashflow in Incoming Manual Cashflow Notebook.
    ...    @author:mgaling
    ...    @update: fmamaril    21MAY2019    remove spaces and activate window  
    ...    @update: hstone      03JUL2020    - removed extra spaces
    ...                                      - Added Take Screenshot
    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IncomingManualCashflow_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IncomingManualCashflow_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_IncomingManualCashflow_WorkflowItems}    Create Cashflows
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Send Incoming Manual Cashflow to Approval
    [Documentation]    This keyword is for Sending to Approval Transaction.
    ...    @author: mgaling
    ...    @update: hstone     03JUL2020     - Added Take Screenshot
    
    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}     
    Mx LoanIQ Select Window Tab    ${LIQ_IncomingManualCashflow_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IncomingManualCashflow_Workflow
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_IncomingManualCashflow_WorkflowItems}    Send to Approval%d 
	:FOR    ${i}    IN RANGE    3
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False   

Select Manual Transactions in WIP
    [Documentation]    This keyword is used for selecting Manual Tran in WIP.
    ...    @author: mgaling
    [Arguments]    ${TransactionItem}    ${TransactionStatus}    ${TransactionType}    ${Deal_Name}
          
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${TransactionItem}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WIP_ManualTrans_TransactionStatus_List}    ${TransactionStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick   ${LIQ_WIP_ManualTrans_TransactionStatus_List}    ${TransactionStatus} 

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WIP_ManualTrans_TransactionStatus_List}    ${TransactionType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WIP_ManualTrans_TransactionStatus_List}    ${TransactionType} 
   
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WIP_ManualTrans_TransactionStatus_List}    ${Deal_Name}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WIP_ManualTrans_TransactionStatus_List}    ${Deal_Name} 

Approve Incoming Manual Cashflow to Approval
    [Documentation]    This keyword approves the Incoming Manual Cashflow Transaction.
    ...    @author: mgaling
    ...    @update: hstone     06JUL2020     - Added Question Window Confirmation if Present
    
    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IncomingManualCashflow_Tab}    Workflow
    
    Mx LoanIQ DoubleClick    ${LIQ_IncomingManualCashflow_WorkflowItems}    Approval
    :FOR    ${i}    IN RANGE    3
    \    ${Question_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Question_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Question_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False and ${Question_Displayed}==False

Release Incoming Manual Cashflow
    [Documentation]    This keyword release the Incoming Manual Cashflow Transaction.
    ...    @author: mgaling
    ...    @update: hstone     23JUL2020     - Added 'mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}'
    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IncomingManualCashflow_Tab}    Workflow
    
    Mx LoanIQ DoubleClick    ${LIQ_IncomingManualCashflow_WorkflowItems}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 

Validate Incoming Manual Cashflow Notebook - Events Tab
    [Documentation]    This keyword validates the Events Tab after the Incoming Manual Cashflow Transaction.
    ...    @author:mgaling  
    
    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    
    Mx LoanIQ Select Window Tab    ${LIQ_IncomingManualCashflow_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_IncomingManualCashflow_Events_Items}    Released    
    
Validate GL Entries in Incoming Manual Cashflow Notebook
    [Documentation]    This keyword validates the GL Entries after the Incoming Manual Cashflow Transaction.
    ...    @author: mgaling
    ...    @update: hstone     06JUL2020     - Removed Extra Spaces
    ...                                      - Replaced 'Convert To Number' with 'Remove Comma and Convert to Number'
    ...                                      - Replaced all 'Should Be Equal' with 'Compare Two Numbers'
    ...                                      - Added 'Remove Comma and Convert to Number' for all UI Value Acquired
    ...                                      - Added Keyword Pre-processing
    [Arguments]    ${sUpfrontFee_Amount}    ${sRI_Method}    ${sGL_ShortName}

    ### Keyword Pre-processing ###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${RI_Method}    Acquire Argument Value    ${sRI_Method}
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    
    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    mx LoanIQ select    ${LIQ_IncomingManualCashflow_Options_GLEntries}
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${UpfrontFee_Amount}    Remove Comma and Convert to Number    ${UpfrontFee_Amount}
    
    ###Debit and Credit Amount Validation###
    ${DebitAmt}    Get Debit Amount - Incoming Manual Cashflow    ${RI_Method}
    ${CreditAmt}    Get Credit Amount - Incoming Manual Cashflow    ${GL_ShortName}

    ${DebitAmt}    Remove Comma and Convert to Number    ${DebitAmt}
    ${CreditAmt}    Remove Comma and Convert to Number    ${CreditAmt}
    
    Compare Two Numbers    ${UpfrontFee_Amount}    ${DebitAmt}
    Compare Two Numbers    ${UpfrontFee_Amount}    ${CreditAmt}
    
    ###Total Amount of Debit and Credit Validation###
    
    ${DebitTotalAmt}    Get Debit Total Amount - Incoming Manual Cashflow
    ${DebitTotalAmt}    Remove Comma and Convert to Number    ${DebitTotalAmt}
    Compare Two Numbers    ${DebitTotalAmt}    ${DebitAmt}
    ${CreditTotalAmt}    Get Credit Total Amount - Incoming Manual Cashflow
    ${CreditTotalAmt}    Remove Comma and Convert to Number    ${CreditTotalAmt}
    Compare Two Numbers    ${CreditTotalAmt}    ${CreditAmt}
   
    Compare Two Numbers    ${DebitTotalAmt}    ${CreditTotalAmt}
    Log    Debit Total Amount ${DebitTotalAmt}= Credit Total Amount ${CreditTotalAmt} are equal.
    
    mx LoanIQ click    ${LIQ_ManualCashflow_GLEntries_Exit_Button}
        
Get Debit Amount - Incoming Manual Cashflow
    [Documentation]    This keyword is used to get debit amount in GL Entries
    ...    @author: mgaling
    [Arguments]    ${RI_Method}    
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${RI_Method}%Debit Amt%Debit
    ${DebitAmt}    Remove String    ${DebitAmt}    ,
    ${DebitAmt}    Convert To Number    ${DebitAmt}    2
    Log To Console    ${DebitAmt} 
    [Return]    ${DebitAmt}    

Get Credit Amount - Incoming Manual Cashflow
    [Documentation]    This keyword is used to get credit amount in GL Entries
    ...    @author: mgaling
    [Arguments]    ${GL_ShortName}
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${GL_ShortName}%Credit Amt%Credit
    ${CreditAmt}    Remove String    ${CreditAmt}    ,
    ${CreditAmt}    Convert To Number    ${CreditAmt}    2
    Log To Console    ${CreditAmt} 
    [Return]    ${CreditAmt}  

Get Debit Total Amount - Incoming Manual Cashflow
    [Documentation]    This keyword is used to get debit total amount in GL Entries
    ...    @author: mgaling
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${DebitTotalAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${SPACE}Total For: CB001%Debit Amt%Debit
    ${DebitTotalAmt}    Remove String    ${DebitTotalAmt}    ,
    ${DebitTotalAmt}    Convert To Number    ${DebitTotalAmt}    2
    [Return]    ${DebitTotalAmt}

Get Credit Total Amount - Incoming Manual Cashflow
    [Documentation]    This keyword is used to get debit total amount in GL Entries
    ...    @author: mgaling
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${CreditTotalAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${SPACE}Total For: CB001%Credit Amt%Credit
    ${CreditTotalAmt}    Remove String    ${CreditTotalAmt}    ,
    ${CreditTotalAmt}    Convert To Number    ${CreditTotalAmt}    2
    [Return]    ${CreditTotalAmt}
           
Add Custom Remittance Instruction for Payment
    [Documentation]    This keyword is for choosing Custom Instructions.
    ...    @author:mgaling
    [Arguments]    ${LIQCustomer_ShortName}    ${CustomRI_Method}    ${Method}    
    
    Select Custom Remittance Instruction    ${LIQCustomer_ShortName}    ${CustomRI_Method}    ${Method}
    #Verify if Status is set to Do It - Payment Cashflow    ${LIQCustomer_ShortName}
    
Select Custom Remittance Instruction 
    [Documentation]    This keyword is for choosing Custom Instructions.
    ...    @author:mgaling
    [Arguments]    ${LIQCustomer_ShortName}    ${CustomRI_Method}    ${Method}  
    mx LoanIQ activate window    ${LIQ_Payment_Cashflows_Window}    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_Cashflows_List}    ${LIQCustomer_ShortName}%d
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_SelectRI_Button}  
    mx LoanIQ activate window    ${LIQ_Payment_Cashflows_ChooseRemittance_Window}
    Mx LoanIQ Set    ${LIQ_Payment_Cashflows_ChooseRemittance_CustomInstructions_CheckBox}    ON   
    mx LoanIQ click    ${LIQ_Payment_Cashflows_ChooseRemittance_Details_Button}
    
    mx LoanIQ activate window    ${LIQ_Payment_Cashflows_RemittanceInstructionsDetail_Window}
    mx LoanIQ select    ${LIQ_Payment_Cashflows_RemittanceInstructionsDetail_Tab}    General
    mx LoanIQ select list    ${LIQ_Payment_Cashflows_RemittanceInstructionsDetail_Method_List}    ${CustomRI_Method}
    Mx LoanIQ Verify Runtime Property    ${LIQ_Payment_Cashflows_RemittanceInstructionsDetail_Description_Field}    value%CUSTOM 
    mx LoanIQ select    ${LIQ_Payment_Cashflows_RemittanceInstructionsDetail_FileSave_Menu}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}                
    mx LoanIQ select    ${LIQ_Payment_Cashflows_RemittanceInstructionsDetail_FileExit_Menu}        
        
    mx LoanIQ click    ${LIQ_Payment_Cashflows_ChooseRemittance_OK_Button}
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_OK_Button} 
    
    mx LoanIQ activate window    ${LIQ_Payment_Cashflows_Window}
    ${UI_Method}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Payment_Cashflows_List}    DOIT%Method%value        
    Should Be Equal As Strings    ${UI_Method}    SPAP 
    
Validate Tran Amount under Cashflows for Payment
    [Documentation]    This keyword is for validating the Tran Amount value.
    ...    @author:mgaling
    [Arguments]    ${Deal_Borrower}    ${UpfrontFee_Amount}     
    
    mx LoanIQ activate window    ${LIQ_Payment_Cashflows_Window}
    
    ${UI_TranAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Payment_Cashflows_List}    ${Deal_Borrower}%Tran Amount%value
    ${UI_TranAmount}    Remove String    ${UI_TranAmount}    , 
    ${UI_TranAmount}    Convert To Number    ${UI_TranAmount} 
    
    ${UpfrontFee_Amount}    Convert To Number    ${UpfrontFee_Amount} 
    Should Be Equal    ${UI_TranAmount}    ${UpfrontFee_Amount}
    mx LoanIQ click    ${LIQ_Cashflows_OK_Button}             

Open Existing Incoming Manual Cashflow Notebook
    [Documentation]    This Keyword is used for opening existing incoming manual cashflow notebook.
    ...    @author: hstone     06JUL2020      - Initial Create
    [Arguments]    ${sFrom_Date}    ${sTo_Date}    ${sDescription}

    ### Keyword Pre-processing ###
    ${From_Date}    Acquire Argument Value    ${sFrom_Date}
    ${To_Date}    Acquire Argument Value    ${sTo_Date}
    ${Description}    Acquire Argument Value    ${sDescription}

    mx LoanIQ activate window    ${LIQ_ManualCashflowSelect_Window}
    Mx LoanIQ Set    ${LIQ_ManualCashflowSelect_Existing_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_ManualCashflowSelect_FromDate_TextField}    ${From_Date}
    mx LoanIQ enter    ${LIQ_ManualCashflowSelect_ToDate_TextField}    ${To_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualCashflowSelect
    mx LoanIQ click    ${LIQ_ManualCashflowSelect_Search_Button} 
    
    mx LoanIQ activate window    ${LIQ_ManualCashflowSelect_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualCashflowTransactionList
    Mx LoanIQ Set    ${LIQ_ManualCashflowTransactionList_RemainOpenAfterSelection_CheckBox}    OFF
    Mx LoanIQ Set    ${LIQ_ManualCashflowTransactionList_OpenNotebookInUpdateMode_CheckBox}    ON
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualCashflowTransactionList_JavaTree}    ${Description}%s
    mx LoanIQ click    ${LIQ_ManualCashflowTransactionList_OK_Button}

    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}

Release Cashflows for Incoming Manual Cashflow
    [Documentation]    This keyword release the Incoming Manual Cashflow Transaction.
    ...    @author: hstone     06JUL2020     - Initial Create
    ...    @update: hstone     22JUL2020     - 'mx Lo'anIQ click element if present    ${LIQ_Question_Yes_Button}
    ...    @update: hstone     23JUL2020     - Added checking if Release Cashflows is present under workflow items
    [Arguments]    @{sCustomer_Names}

    ### Keyword Pre-processing ###
    ${Customer_Names}    Acquire Argument Values From List    ${sCustomer_Names}

    ${Customer_Names_TokenSeparated}    Convert List to a Token Separated String    ${Customer_Names}
    
    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IncomingManualCashflow_Tab}    Workflow
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Item In Tree    ${LIQ_IncomingManualCashflow_WorkflowItems}    Release Cashflows    verificationdata=Yes
    Run Keyword If    '${status}'=='True'    Run Keywords    Mx LoanIQ DoubleClick    ${LIQ_IncomingManualCashflow_WorkflowItems}    Release Cashflows
    ...    AND    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    ...    AND    Release Cashflow    ${Customer_Names_TokenSeparated}

Validate Credit Offset Detail at Incoming Manual Cashflow Table
    [Documentation]    This keyword used to validate incoming manual cashflow table.
    ...    @author: hstone    06JUL2020     - Initial Create
    [Arguments]    ${sExpected_Amount}    ${sExpected_GLShortName}    ${sExpected_ExpenseCode}

    ### Keyword Pre-processing ###
    ${Expected_Amount}    Acquire Argument Value    ${sExpected_Amount}
    ${Expected_GLShortName}    Acquire Argument Value    ${sExpected_GLShortName}
    ${Expected_ExpenseCode}    Acquire Argument Value    ${sExpected_ExpenseCode}

    mx LoanIQ activate window    ${LIQ_IncomingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IncomingManualCashflow_Tab}    General
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IncomingManualCashflow_General

    ${UI_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IncomingManualCashflow_JavaTree}    ${Expected_Amount}%Amount%value
    ${UI_GLShortName}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IncomingManualCashflow_JavaTree}    ${Expected_Amount}%GL Short Name%value
    ${UI_ExpenseCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IncomingManualCashflow_JavaTree}    ${Expected_Amount}%Expense Code%value

    Compare Two Strings    ${Expected_Amount}    ${UI_Amount}    Incoming Manual Cashflow Table Amount Validation
    Compare Two Strings    ${Expected_GLShortName}    ${UI_GLShortName}    Incoming Manual Cashflow Table GL Short Name Validation
    Compare Two Strings    ${Expected_ExpenseCode}    ${UI_ExpenseCode}    Incoming Manual Cashflow Table Expense Code Validation