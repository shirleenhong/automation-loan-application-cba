*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 

Launch Outgoing Manual Cashflow Notebook
    [Documentation]    This Keyword is used for navigating to Outgoing  (Debit DDA,  IMT or Nostro) Manual Cashflow Notebook.
    ...    @author: hstone     07JUL2020      - Initial Create
    
    mx LoanIQ activate window    ${LIQ_ManualCashflowSelect_Window}
    Mx LoanIQ Set    ${LIQ_ManualCashflowSelect_New_RadioButton}    ON  
    Mx LoanIQ Set    ${LIQ_ManualCashflowSelect_Outgoing_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualCashflowSelect
    mx LoanIQ click    ${LIQ_ManualCashflowSelect_OK_Button} 
    
    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    
Populate Outgoing Manual Cashflow Notebook - General Tab
    [Documentation]    This Keyword is used for populating Outgoing Manual Cashflow Notebook - General Tab.
    ...    @author: hstone     07JUL2020      - Initial Create
    ...    @update: hstone     13JUL2020      - Used actual locator for verifying attached text of a static text
    ...    @update: makcamps   17FEB2021      - added search deal expense code before clicking expense code from tree
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

    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OutgoingManualCashflow_Tab}    General
    
    mx LoanIQ select list    ${LIQ_OutgoingManualCashflow_Branch_List}    ${Branch_Code}
    mx LoanIQ enter    ${LIQ_OutgoingManualCashflow_EffectiveDate_Field}    ${Effective_Date}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ select list    ${LIQ_OutgoingManualCashflow_Currency_List}    ${Currency}
    mx LoanIQ enter    ${LIQ_OutgoingManualCashflow_Amount_Field}    ${UpfrontFee_Amount}
    mx LoanIQ enter    ${LIQ_OutgoingManualCashflow_Description_Field}    ${Description}
    mx LoanIQ select list    ${LIQ_OutgoingManualCashflow_ProcArea_List}    ${Proc_Area}
    
    ### Cashflow Section ###
    ${ExpenseCode_Status}    Run Keyword And Return Status    Validate Loan IQ Details    ${Deal_ExpenseCode}    ${LIQ_OutgoingManualCashflow_Expense_Field}
    Run Keyword If    '${ExpenseCode_Status}'=='True'    Log    Deal Expense Code filled-out matches the test data.
    ...    ELSE    Run Keywords    Log    Deal Expense Code filled-out does not match the test data. Test Script will proceed with expense code selection based from test data.
    ...    AND    mx LoanIQ click    ${LIQ_OutgoingManualCashflow_Expense_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_SelectExpenseCode_Window}
    ...    AND    mx LoanIQ enter    ${LIQ_SelectExpenseCode_Search_Field}    ${Deal_ExpenseCode}
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectExpenseCode_JavaTree}    ${Deal_ExpenseCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_SelectExpenseCode_OK_Button}

    ${CustomerDisplay_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    JavaWindow("title:=Outgoing Manual Cashflow .*").JavaStaticText("attached text:=${Deal_Borrower}")    attached text%${Deal_Borrower}
    Run Keyword If    '${CustomerDisplay_Status}'=='True'    Log    Customer filled-out matches the test data.
    ...    ELSE    Run Keywords    Log    Customer filled-out does not match the test data. Test Script will proceed with expense code selection based from test data.
    ...    AND    mx LoanIQ click    ${LIQ_OutgoingManualCashflow_Customer_Button}
    ...    AND    Select Customer by Short Name    ${Deal_Borrower}

    Run Keyword If    '${Deal_Name}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_OutgoingManualCashflow_Deal_Button}
    ...    AND    Select Existing Deal    ${Deal_Name}
    Run Keyword If    '${Facility_Name}'!='None'    Mx LoanIQ Select Combo Box Value    ${LIQ_OutgoingManualCashflow_Facility_Dropdown}    ${Facility_Name}

    mx LoanIQ click    ${LIQ_OutgoingManualCashflow_ServicingGroup_Button}
    mx LoanIQ activate window    ${LIQ_ExistingServicingGroup_Window}
    Mx LoanIQ Select String    ${LIQ_ExistingServicingGroup_JavaTree}    ${Customer_ServicingGroup}
    mx LoanIQ click    ${LIQ_ExistingServicingGroup_OK_Button}
    Mx LoanIQ Verify Runtime Property    JavaWindow("title:=Outgoing Manual Cashflow .*").JavaStaticText("attached text:=${Branch_ServicingGroup}")    attached text%${Branch_ServicingGroup}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutgoingManualCashflow_General

Add Debit Offset in Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is for adding Debit in Outgoing Manual Cashflow Notebook.
    ...    @author: hstone     07JUL2020      - Initial Create
    [Arguments]    ${sUpfrontFee_Amount}    ${sGL_ShortName}    ${sPortfolioCode}=None
    
    ### Keyword Pre-processing ###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    ${PortfolioCode}    Acquire Argument Value    ${sPortfolioCode}

    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    mx LoanIQ click    ${LIQ_OutgoingManualCashflow_AddDebittOffset_Button}
    
    mx LoanIQ activate window    ${LIQ_DebitGLOffsetDetails_Window}
    Mx LoanIQ Set    ${LIQ_DebitGLOffsetDetails_NewWIP_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_DebitGLOffsetDetails_Amount_Field}    ${UpfrontFee_Amount}
    mx LoanIQ select list    ${LIQ_DebitGLOffsetDetails_GLShortName_List}    ${GL_ShortName}
    Run Keyword If    '${sPortfolioCode}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_DebitGLOffsetDetails_Portfolio_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_SelectPortfolioCode_Window}
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SelectPortfolioCode
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectPortfolioCode_JavaTree}    ${PortfolioCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_SelectPortfolioCode_OK_Button}
    mx LoanIQ activate window    ${LIQ_DebitGLOffsetDetails_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DebitGLOffsetDetails
    mx LoanIQ click    ${LIQ_DebitGLOffsetDetails_OK_Button}

Add Debit Offset Fee Income in Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is for adding Debit in Outgoing Manual Cashflow Notebook.
    ...    @author: makcamps     17FEB2021      - Initial Create
    [Arguments]    ${sUpfrontFee_Amount}    ${sGL_ShortName}    ${sPortfolioCode}=None
    
    ### Keyword Pre-processing ###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    ${PortfolioCode}    Acquire Argument Value    ${sPortfolioCode}

    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    mx LoanIQ click    ${LIQ_OutgoingManualCashflow_AddDebittOffset_Button}
    
    mx LoanIQ activate window    ${LIQ_DebitGLOffsetDetails_Window}
    Mx LoanIQ Set    ${LIQ_DebitGLOffsetDetails_FeeIncome_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_DebitGLOffsetDetails_Amount_Field}    ${UpfrontFee_Amount}
    mx LoanIQ select list    ${LIQ_DebitGLOffsetDetails_GLShortName_List}    ${GL_ShortName}
    Run Keyword If    '${sPortfolioCode}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_DebitGLOffsetDetails_Portfolio_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_SelectPortfolioCode_Window}
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SelectPortfolioCode
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectPortfolioCode_JavaTree}    ${PortfolioCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_SelectPortfolioCode_OK_Button}
    mx LoanIQ activate window    ${LIQ_DebitGLOffsetDetails_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DebitGLOffsetDetails
    mx LoanIQ click    ${LIQ_DebitGLOffsetDetails_OK_Button}

Save and Validate Data in Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is for saving and validating data in Outgoing Manual Cashflow Notebook.
    ...    @author: hstone     07JUL2020      - Initial Create
    [Arguments]    ${sUpfrontFee_Amount}    ${sGL_ShortName}    ${sDeal_ExpenseCode}

    ### Keyword Pre-processing ###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    ${Deal_ExpenseCode}    Acquire Argument Value    ${sDeal_ExpenseCode}
    
    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    mx LoanIQ select    ${LIQ_OutgoingManualCashflow_FileSave_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_OutgoingManualCashflow_JavaTree}    ${UpfrontFee_Amount}
    Run Keyword If    ${status}==True    Log    ${UpfrontFee_Amount} is reflected   
    Run Keyword If    ${status}==False    Log    Fail    ${UpfrontFee_Amount} is not reflected 
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_OutgoingManualCashflow_JavaTree}    ${GL_ShortName}
    Run Keyword If    ${status}==True    Log    ${GL_ShortName} is reflected   
    Run Keyword If    ${status}==False    Log    Fail    ${GL_ShortName} is not reflected 
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_OutgoingManualCashflow_JavaTree}    ${Deal_ExpenseCode}
    Run Keyword If    ${status}==True    Log    ${Deal_ExpenseCode} is reflected   
    Run Keyword If    ${status}==False    Log    Fail    ${Deal_ExpenseCode}  is not reflected 
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_OutgoingManualCashflow_JavaTree}    TOTAL:${SPACE}${UpfrontFee_Amount}
    Run Keyword If    ${status}==True    Log    TOTAL:${SPACE}${UpfrontFee_Amount} is reflected   
    Run Keyword If    ${status}==False    Log    Fail    TOTAL:${SPACE}${UpfrontFee_Amount} is not reflected 
       
Navigate to Cashflow in Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is for creating cashflow in Outgoing Manual Cashflow Notebook.
    ...    @author: hstone     07JUL2020      - Initial Create
    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OutgoingManualCashflow_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutgoingManualCashflow_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_OutgoingManualCashflow_WorkflowItems}    Create Cashflows
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Send Outgoing Manual Cashflow to Approval
    [Documentation]    This keyword is for Sending to Approval Transaction.
    ...    @author: hstone     07JUL2020      - Initial Create
    ...    @update: hstone     13JUL2020      - Replaced code process with Send to Approval Routine
    
    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}     
    Mx LoanIQ Select Window Tab    ${LIQ_OutgoingManualCashflow_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IncomingManualCashflow_Workflow
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OutgoingManualCashflow_WorkflowItems}    Send to Approval%d 
	:FOR    ${i}    IN RANGE    3
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False  

Release Outgoing Manual Cashflow
    [Documentation]    This keyword release the Outgoing Manual Cashflow Transaction.
    ...    @author: hstone     07JUL2020      - Initial Create
    
    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OutgoingManualCashflow_Tab}    Workflow
    
    Mx LoanIQ DoubleClick    ${LIQ_OutgoingManualCashflow_WorkflowItems}    Release
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  

Validate Outgoing Manual Cashflow Notebook - Events Tab
    [Documentation]    This keyword verifies if Outgoing Manual Cashflow Transaction Released event is displayed.
    ...    @author: makcamps    22FEB2021      - Initial Create
    
    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OutgoingManualCashflow_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_OutgoingManualCashflow_EventsItems}    Released
    
Validate GL Entries in Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword validates the GL Entries after the Outgoing Manual Cashflow Transaction.
    ...    @author: hstone     07JUL2020      - Initial Create
    [Arguments]    ${sUpfrontFee_Amount}    ${sRI_Method}    ${sGL_ShortName}

    ### Keyword Pre-processing ###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${RI_Method}    Acquire Argument Value    ${sRI_Method}
    ${GL_ShortName}    Acquire Argument Value    ${sGL_ShortName}
    
    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    mx LoanIQ select    ${LIQ_OutgoingManualCashflow_Options_GLEntries}
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${UpfrontFee_Amount}    Remove Comma and Convert to Number    ${UpfrontFee_Amount}
    
    ###Debit and Credit Amount Validation###
    ${DebitAmt}    Get Debit Amount - Outgoing Manual Cashflow    ${GL_ShortName}
    ${CreditAmt}    Get Credit Amount - Outgoing Manual Cashflow    ${RI_Method}
    
    Compare Two Numbers    ${UpfrontFee_Amount}    ${DebitAmt}
    Compare Two Numbers    ${UpfrontFee_Amount}    ${CreditAmt}
    
    ###Total Amount of Debit and Credit Validation###
    ${DebitTotalAmt}    Get Debit Total Amount - Outgoing Manual Cashflow
    Compare Two Numbers    ${DebitTotalAmt}    ${DebitAmt}
    ${CreditTotalAmt}    Get Credit Total Amount - Outgoing Manual Cashflow
    ${CreditTotalAmt}    Remove Comma and Convert to Number    ${CreditTotalAmt}
    Compare Two Numbers    ${CreditTotalAmt}    ${CreditAmt}
   
    Compare Two Numbers    ${DebitTotalAmt}    ${CreditTotalAmt}
    Log    Debit Total Amount ${DebitTotalAmt}= Credit Total Amount ${CreditTotalAmt} are equal.
    
    mx LoanIQ click    ${LIQ_ManualCashflow_GLEntries_Exit_Button}
        
Get Debit Amount - Outgoing Manual Cashflow
    [Documentation]    This keyword is used to get debit amount in GL Entries
    ...    @author: hstone     07JUL2020      - Initial Create
    [Arguments]    ${RI_Method}
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${RI_Method}%Debit Amt%Debit
    ${DebitAmt}    Remove Comma and Convert to Number    ${DebitAmt}
    Log To Console    ${DebitAmt} 
    [Return]    ${DebitAmt}    

Get Credit Amount - Outgoing Manual Cashflow
    [Documentation]    This keyword is used to get credit amount in GL Entries
    ...    @author: hstone     07JUL2020      - Initial Create
    [Arguments]    ${GL_ShortName}
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${GL_ShortName}%Credit Amt%Credit
    ${CreditAmt}    Remove Comma and Convert to Number    ${CreditAmt}
    Log To Console    ${CreditAmt} 
    [Return]    ${CreditAmt}  

Get Debit Total Amount - Outgoing Manual Cashflow
    [Documentation]    This keyword is used to get debit total amount in GL Entries
    ...    @author: hstone     07JUL2020      - Initial Create
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${DebitTotalAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${SPACE}Total For: CB001%Debit Amt%Debit
    ${DebitTotalAmt}    Remove Comma and Convert to Number    ${DebitTotalAmt}
    [Return]    ${DebitTotalAmt}

Get Credit Total Amount - Outgoing Manual Cashflow
    [Documentation]    This keyword is used to get debit total amount in GL Entries
    ...    @author: hstone     07JUL2020      - Initial Create
    
    mx LoanIQ activate window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    ${CreditTotalAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${SPACE}Total For: CB001%Credit Amt%Credit
    ${CreditTotalAmt}    Remove Comma and Convert to Number    ${CreditTotalAmt}
    [Return]    ${CreditTotalAmt}

Open Existing Outgoing Manual Cashflow Notebook
    [Documentation]    This Keyword is used for opening existing outgoing manual cashflow notebook.
    ...    @author: hstone     07JUL2020      - Initial Create
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

    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}

Release Cashflows for Outgoing Manual Cashflow
    [Documentation]    This keyword release the Outgoing Manual Cashflow Transaction.
    ...    @author: hstone     07JUL2020      - Initial Create
    [Arguments]    @{sCustomer_Names}

    ### Keyword Pre-processing ###
    ${Customer_Names}    Acquire Argument Values From List    ${sCustomer_Names}

    ${Customer_Names_TokenSeparated}    Convert List to a Token Separated String    ${Customer_Names}
    
    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OutgoingManualCashflow_Tab}    Workflow
    
    Mx LoanIQ DoubleClick    ${LIQ_OutgoingManualCashflow_WorkflowItems}    Release Cashflows
    Release Cashflow    ${Customer_Names_TokenSeparated}

Validate Debit Offset Detail at Outgoing Manual Cashflow Table
    [Documentation]    This keyword used to validate outgoing manual cashflow table.
    ...    @author: hstone     07JUL2020      - Initial Create
    ...    @update: hstone     13JUL2020      - Updated keyword name from 'Validate Credit Offset Detail at Outgoing Manual Cashflow Table'
    ...                                         to 'Validate Debit Offset Detail at Outgoing Manual Cashflow Table'
    [Arguments]    ${sExpected_Amount}    ${sExpected_GLShortName}    ${sExpected_ExpenseCode}

    ### Keyword Pre-processing ###
    ${Expected_Amount}    Acquire Argument Value    ${sExpected_Amount}
    ${Expected_GLShortName}    Acquire Argument Value    ${sExpected_GLShortName}
    ${Expected_ExpenseCode}    Acquire Argument Value    ${sExpected_ExpenseCode}

    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OutgoingManualCashflow_Tab}    General
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutgoingManualCashflow_General

    ${UI_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutgoingManualCashflow_JavaTree}    ${Expected_Amount}%Amount%value
    ${UI_GLShortName}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutgoingManualCashflow_JavaTree}    ${Expected_Amount}%GL Short Name%value
    ${UI_ExpenseCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutgoingManualCashflow_JavaTree}    ${Expected_Amount}%Expense Code%value

    Compare Two Strings    ${Expected_Amount}    ${UI_Amount}    Outgoing Manual Cashflow Table Amount Validation
    Compare Two Strings    ${Expected_GLShortName}    ${UI_GLShortName}    Outgoing Manual Cashflow Table GL Short Name Validation
    Compare Two Strings    ${Expected_ExpenseCode}    ${UI_ExpenseCode}    Outgoing Manual Cashflow Table Expense Code Validation
   
Approve Outgoing Manual Cashflow to Approval
    [Documentation]    This keyword approves the Outgoing Manual Cashflow Transaction.
    ...    @author: hstone     13JUL2020     - Initial Create
    
    mx LoanIQ activate window    ${LIQ_OutgoingManualCashflow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OutgoingManualCashflow_Tab}    Workflow
    
    Mx LoanIQ DoubleClick    ${LIQ_OutgoingManualCashflow_WorkflowItems}    Approval
    :FOR    ${i}    IN RANGE    3
    \    ${Question_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Question_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Question_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False and ${Question_Displayed}==False