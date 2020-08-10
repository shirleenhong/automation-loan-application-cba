*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate to Manual GL
    [Documentation]    This keyword will navigate to Manual GL Entries
    ...    @author: ritragel
    ...    @update: hstone     10JUL2020    - Updated Deal Argument to Optional
    ...                                     - Added condition handling when sDeal_Name=None
    [Arguments]    ${sDeal_Name}=None

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    Select Actions    [Actions];Accounting and Control
    mx LoanIQ activate window    ${LIQ_AccountingAndControl_Window}
    mx LoanIQ enter    ${LIQ_AccountingAndControl_ManualGL}    ON

    Run Keyword If    '${Deal_Name}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_AccountingAndControl_Deal_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_DealSelect_Window}
    ...    AND    Verify Window    ${LIQ_DealSelect_Window}
    ...    AND    mx LoanIQ enter    ${LIQ_DealSelect_Search_TextField}     ${Deal_Name} 
    ...    AND    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}

    mx LoanIQ click    ${LIQ_AccountingAndControl_OK_Button}
    
New Manual GL Select
    [Documentation]    This keyword will select new in Manual GL Select Window
    ...    @author: ritragel
    ...    @update: hstone     10JUL2020    - Removed extra spaces
    mx LoanIQ activate window    ${LIQ_ManualGLSelect_Window}
    mx LoanIQ enter    ${LIQ_ManualGLSelect_New_RadioButton}    ON
    mx LoanIQ click    ${LIQ_ManualGLSelect_OK_Button}
    
Enter Manual GL Details
    [Documentation]    This keyword will enter details for the Manual GL
    ...    @author: ritragel
    ...    @update: hstone      13JUL2020     - Removed extra spaces
    ...                                       - Added a Default Argument: ${sDescription}
    ...                                       - Added Keyword Pre-processing
    [Arguments]    ${sProcessing_Area}    ${sDeal_Currency}    ${sBranch_Code}    ${sEffective_Date}    ${sDescription}=Testing on Manual GL

    ### Keyword Pre-processing ###
    ${Processing_Area}    Acquire Argument Value    ${sProcessing_Area}
    ${Deal_Currency}    Acquire Argument Value    ${sDeal_Currency}
    ${Branch_Code}    Acquire Argument Value    ${sBranch_Code}
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
    ${Description}    Acquire Argument Value    ${sDescription}

    mx LoanIQ activate window    ${LIQ_ManualGL_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_ManualGL_ProcArea_Dropdown}    ${Processing_Area}
    Mx LoanIQ Select Combo Box Value    ${LIQ_ManualGL_Currency_Dropdown}    ${Deal_Currency}
    Mx LoanIQ Select Combo Box Value    ${LIQ_ManualGL_Branch_Dropdown}    ${Branch_Code}
    mx LoanIQ enter    ${LIQ_ManualGL_EffectiveDate_TextBox}    ${Effective_Date}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_ManualGL_Description_TextBox}    ${Description}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGL_General

Add Debit for Manual GL
    [Documentation]    This keyword will enter details for the Debit
    ...    @author: ritragel
    ...    @update: hstone      13JUL2020     - Added Keyword Pre-processing
    ...                                       - Added new arguments: ${sDebit_Type}, ${sDebit_Amount}, ${sDebit_ExpenseCode}, ${sDebit_PortfolioCode}, ${sDebit_SecurityID_Selection}
    ...                                       - Added process for handling Debit Manual GL window field fill-out when arguments are supplied
    [Arguments]    ${sDeal_Name}    ${sDebit_GL_ShortName}    ${sDebit_Type}=Existing WIP    ${sDebit_Amount}=None    ${sDebit_ExpenseCode}=None
    ...    ${sDebit_PortfolioCode}=None    ${sDebit_SecurityID_Selection}=None

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Debit_GL_ShortName}    Acquire Argument Value    ${sDebit_GL_ShortName}
    ${Debit_Type}    Acquire Argument Value    ${sDebit_Type}
    ${Debit_Amount}    Acquire Argument Value    ${sDebit_Amount}
    ${Debit_Amount}    Acquire Argument Value    ${sDebit_Amount}
    ${Debit_ExpenseCode}    Acquire Argument Value    ${sDebit_ExpenseCode}
    ${Debit_PortfolioCode}    Acquire Argument Value    ${sDebit_PortfolioCode}
    ${Debit_SecurityID_Selection}    Acquire Argument Value    ${sDebit_SecurityID_Selection}

    mx LoanIQ activate window    ${LIQ_ManualGL_Window}
    mx LoanIQ click    ${LIQ_ManualGL_AddDebit_Button}
    mx LoanIQ activate window    ${LIQ_DebitGLOffsetDetails_Window}
    mx LoanIQ enter    JavaWindow("title:=Debit GL Offset Details.*").JavaObject("tagname:=Group","text:=Type.*").JavaRadioButton("attached text:=${Debit_Type}")    ON
    Run Keyword If    '${Debit_Amount}'!='None'    mx LoanIQ enter    ${LIQ_DebitGLOffsetDetails_Amount_TextBox}    ${Debit_Amount}
    Mx LoanIQ Select Combo Box Value    ${LIQ_DebitGLOffsetDetails_GLShortName_Dropdown}    ${Debit_GL_ShortName}

    ${WIP_Button_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DebitGLOffsetDetails_WIP_Button}    VerificationData="Yes"
    Run Keyword If    '${WIP_Button_Status}'=='True'    Run Keywords    mx LoanIQ click    ${LIQ_DebitGLOffsetDetails_WIP_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_FeesHeldAwaiting_Window}
    ...    AND    Mx LoanIQ Select String    ${LIQ_FeesHeldAwaiting_JavaTree}    ${Deal_Name}
    ...    AND    mx LoanIQ click    ${LIQ_FeesHeldAwaiting_Use_Button}

    Run Keyword If    '${Debit_ExpenseCode}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_DebitGLOffsetDetails_Expense_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_SelectExpenseCode_Window}
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectExpenseCode_JavaTree}    ${Debit_ExpenseCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_SelectExpenseCode_OK_Button}

    Run Keyword If    '${Debit_PortfolioCode}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_DebitGLOffsetDetails_Portfolio_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_SelectPortfolioCode_Window}
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectPortfolioCode_JavaTree}    ${Debit_PortfolioCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_SelectPortfolioCode_OK_Button}

    ${Debit_SecurityID_Selection}    Run Keyword If    '${Debit_SecurityID_Selection}'=='Deal' or '${Debit_SecurityID_Selection}'=='Customer'    Set Variable    ${Debit_SecurityID_Selection}.*
    Run Keyword If    '${Debit_SecurityID_Selection}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_DebitGLOffsetDetails_SecurityID_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_MakeSelection_Window}
    ...    AND    mx LoanIQ enter    JavaWindow("title:=Make Selection").JavaObject("tagname:=Group","text:=Choices").JavaRadioButton("attached text:=${Debit_SecurityID_Selection}")    ON
    ...    AND    mx LoanIQ click    ${LIQ_MakeSelection_OK_Button}
    ...    AND    Select Existing Deal    ${Deal_Name}

    mx LoanIQ activate window    ${LIQ_DebitGLOffsetDetails_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGL_AddDebit
    mx LoanIQ click    ${LIQ_DebitGLOffsetDetails_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_No_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGL_General
    
Add Credit for Manual GL
    [Documentation]    This keyword will enter details for the Credit
    ...    @author: ritragel
    ...    @update: hstone     14JUL2020     - Added Keyword Pre-processing
    ...                                      - Added new arguments: ${sCredit_Type}, ${sCredit_PortfolioCode}, ${sCredit_SecurityID_Selection}, ${sDeal_Name}
    ...                                      - Added argument processing for the new arguments added
    ...                                      - Removed Manual GL File Save and created a separate keyword for it
    [Arguments]    ${sFee_Amount}    ${sCredit_GL_ShortName}    ${sExpense_Code}    ${sCredit_Type}=Other    ${sCredit_PortfolioCode}=None
    ...    ${sCredit_SecurityID_Selection}=None    ${sDeal_Name}=None

    ### Keyword Pre-processing ###
    ${Fee_Amount}    Acquire Argument Value    ${sFee_Amount}
    ${Credit_GL_ShortName}    Acquire Argument Value    ${sCredit_GL_ShortName}
    ${Expense_Code}    Acquire Argument Value    ${sExpense_Code}
    ${Credit_Type}    Acquire Argument Value    ${sCredit_Type}
    ${Credit_PortfolioCode}    Acquire Argument Value    ${sCredit_PortfolioCode}
    ${Credit_SecurityID_Selection}    Acquire Argument Value    ${sCredit_SecurityID_Selection}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    mx LoanIQ activate window    ${LIQ_ManualGL_Window}
    mx LoanIQ click    ${LIQ_ManualGL_AddCredit_Button}

    mx LoanIQ activate window    ${LIQ_CreditGLOffsetDetails_Window}
    mx LoanIQ enter    JavaWindow("title:=Credit GL Offset Details.*").JavaObject("tagname:=Group","text:=Type.*").JavaRadioButton("attached text:=${Credit_Type}")    ON
    mx LoanIQ enter    ${LIQ_CreditGLOffsetDetails_Amount_Textbox}    ${Fee_Amount}
    Mx LoanIQ Select Combo Box Value    ${LIQ_CreditGLOffsetDetails_GLShortName_Dropdown}    ${Credit_GL_ShortName}

    mx LoanIQ click    ${LIQ_CreditGLOffsetDetails_Expense_Button}
    mx LoanIQ activate    ${LIQ_DealNotebook_ExpenseCode_Window}
    mx LoanIQ enter   ${LIQ_SelectExpenseCode_Search_TextField}    ${Expense_Code}
    mx LoanIQ click    ${LIQ_DealNotebook_ExpenseCode_OK_Button}

    Run Keyword If    '${Credit_PortfolioCode}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_CreditGLOffsetDetails_Portfolio_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_SelectPortfolioCode_Window}
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectPortfolioCode_JavaTree}    ${Credit_PortfolioCode}%s
    ...    AND    mx LoanIQ click    ${LIQ_SelectPortfolioCode_OK_Button}

    ${Credit_SecurityID_Selection}    Run Keyword If    '${Credit_SecurityID_Selection}'=='Deal' or '${Credit_SecurityID_Selection}'=='Customer'    Set Variable    ${Credit_SecurityID_Selection}.*
    Run Keyword If    '${Credit_SecurityID_Selection}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_CreditGLOffsetDetails_SecurityID_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_MakeSelection_Window}
    ...    AND    mx LoanIQ enter    JavaWindow("title:=Make Selection").JavaObject("tagname:=Group","text:=Choices").JavaRadioButton("attached text:=${Credit_SecurityID_Selection}")    ON
    ...    AND    mx LoanIQ click    ${LIQ_MakeSelection_OK_Button}
    ...    AND    Select Existing Deal    ${Deal_Name}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGL_AddCredit
    mx LoanIQ click    ${LIQ_CreditGLOffsetDetails_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_No_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGL_General
   
Send Manual GL to Approval
    [Documentation]    This keyword will send the Manual GL to Approval
    ...    @author: ritragel
    ...    @update: hstone     14JUL2020     - Add Take Screenshot
    mx LoanIQ activate window    ${LIQ_ManualGL_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualGL_JavaTab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGL_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_ManualGL_Workflow_JavaTree}    Send to Approval
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Approve Manual GL
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Upfront Fee Payment.
    ...    @author: ritragel
    ...    @update: fmamaril    08MAY2019     - Remove steps which are handled on standards for work in process
    ...    @update: hstone      14JUL2020     - Add Take Screenshot
    mx LoanIQ activate    ${LIQ_ManualGL_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualGL_JavaTab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGL_Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualGL_Workflow_JavaTree}    Approval%d 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
  
Release Manual GL
    [Documentation]    This  keyword will release the Manual GL
    ...    @author: ritragel
    ...    @update: fmamaril    08MAY2019     - Remove steps which are handled on standards for work in process
    ...    @update: hstone      14JUL2020     - Add Take Screenshot
    mx LoanIQ activate window    ${LIQ_ManualGL_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualGL_JavaTab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGL_Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualGL_Workflow_JavaTree}    Release%d 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    
Validate Events Tab for Manual GL
    [Documentation]    This  keyword will validate Manual GL Events in the Events tab
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_ManualGL_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualGL_JavaTab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_ManualGL_Events_JavaTree}    Released  

Validate GL Entries
    [Documentation]    This keyword will validate GL entries after Release
    ...    @author: ritragel
    [Arguments]    ${sGL_Account_1}    ${sGL_Account_2}    ${sDebit_GL_ShortName}

    ### Keyword Pre-processing ###
    ${GL_Account_1}    Acquire Argument Value    ${sGL_Account_1}
    ${GL_Account_2}    Acquire Argument Value    ${sGL_Account_2}
    ${Debit_GL_ShortName}    Acquire Argument Value    ${sDebit_GL_ShortName}

    mx LoanIQ activate window    ${LIQ_ManualGL_Window}
    mx LoanIQ select    ${LIQ_ManualGL_Options_GLEntries_Menu}
    mx LoanIQ activate window    ${LIQ_ManualGLEntries_Window}
    
    ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ManualGLEntries_JavaTree}    ${GL_Account_2}%Debit Amt%Debit
    ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ManualGLEntries_JavaTree}    ${GL_Account_1}%Credit Amt%Credit 
    
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${DebitAmt}    ${CreditAmt}
    Run Keyword If    ${status}=='True'    Log    Debit and Credit amount is balanced!    level=INFO
    Run Keyword If    ${status}=='False'    Log    Debit and Credit amount is not equal!    level=ERROR
    
    ${UI_Debit_GL_ShortName}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ManualGLEntries_JavaTree}    ${GL_Account_2}%Short Name%Debit    
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UI_Debit_GL_ShortName}    ${Debit_GL_ShortName}
    Run Keyword If    ${status}=='True'    Log    Debit Shortname is succesfully verified!    level=INFO
    Run Keyword If    ${status}=='False'    Log    Debit Shortname amount is not equal!    level=ERROR

    mx LoanIQ click    ${LIQ_ManualGLEntries_Exit_Button}
    
Select Manual Transaction on Work in Process
    [Documentation]    This keyword is used to select ManualTrans on Transactions In Process window.
    ...    @author: fmamaril
    ...    @update: hstone     2020JUL2020     - Added Keyword Pre-processing
    ...                                        - Removed Sleep
    ...                                        - Removed Commented Codes
    ...                                        - Removed Extra Spaces
    ...                                        - Replaced 'Mx Native Type' with 'Mx Press Combination'
    [Arguments]    ${sTransactionItem}    ${sTransactionStatus}    ${sTransactionType}    ${sAlias}

    ### Keyword Pre-processing ####
    ${TransactionItem}    Acquire Argument Value    ${sTransactionItem}
    ${TransactionStatus}    Acquire Argument Value    ${sTransactionStatus}
    ${TransactionType}    Acquire Argument Value    ${sTransactionType}
    ${Alias}    Acquire Argument Value    ${sAlias}

    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${TransactionItem}
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_ManualTrans_List}    ${TransactionStatus}
    Mx Press Combination    Key.PAGE DOWN
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_ManualTrans_List}    Manual GL Transaction
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_ManualTrans_List}    ${Alias}
    Mx Press Combination    Key.ENTER
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window}

Save Manual GL Changes
    [Documentation]    This keyword will save the Manual GL changes
    ...    @author: hstone     14JUL2020    - Initial Create

    mx LoanIQ select    ${LIQ_ManualGL_File_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}

Add Manual GL Transaction Description
    [Documentation]    This keyword will add a transaction description for the Manual GL
    ...    @author: hstone     14JUL2020    - Initial Create
    [Arguments]    ${sTransaction_Desription}=Manual GL Transaction

    ### Keyword Pre-processing ###
    ${Transaction_Desription}    Acquire Argument Value    ${sTransaction_Desription}

    mx LoanIQ activate    ${LIQ_ManualGL_Window}
    mx LoanIQ click    ${LIQ_ManualGL_TransactionDescription_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    mx LoanIQ activate    ${LIQ_TransactionDescription_Window}
    mx LoanIQ enter   ${LIQ_TransactionDescription_TextBox}    ${Transaction_Desription}
    mx LoanIQ click    ${LIQ_TransactionDescription_OK_Button}

Open Existing Manual GL Notebook
    [Documentation]    This Keyword is used for opening existing Manual GL notebook.
    ...    @author: hstone     14JUL2020      - Initial Create
    [Arguments]    ${sFrom_Date}    ${sTo_Date}    ${sDescription}

    ### Keyword Pre-processing ###
    ${From_Date}    Acquire Argument Value    ${sFrom_Date}
    ${To_Date}    Acquire Argument Value    ${sTo_Date}
    ${Description}    Acquire Argument Value    ${sDescription}

    mx LoanIQ activate window    ${LIQ_ManualGLSelect_Window}
    Mx LoanIQ Set    ${LIQ_ManualGLSelect_Existing_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_ManualGLSelect_FromDate_TextField}    ${From_Date}
    mx LoanIQ enter    ${LIQ_ManualGLSelect_ToDate_TextField}    ${To_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGLSelect
    mx LoanIQ click    ${LIQ_ManualGLSelect_Search_Button} 
    
    mx LoanIQ activate window    ${LIQ_ManualGLTransactionList_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualGLTransactionList
    Mx LoanIQ Set    ${LIQ_ManualGLTransactionList_RemainOpen_CheckBox}    OFF
    Mx LoanIQ Set    ${LIQ_ManualGLTransactionList_OpenNotebookInUpdateMode_CheckBox}    ON
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualGLTransactionList_JavaTree}    ${Description}%s
    mx LoanIQ click    ${LIQ_ManualGLTransactionList_OK_Button}

    mx LoanIQ activate window    ${LIQ_ManualGL_Window}

Validate Debit Details at Manual GL Table
    [Documentation]    This keyword used to validate debit details at Manual GL Table.
    ...    @author: hstone    14JUL2020     - Initial Create
    [Arguments]    ${sExpected_Amount}    ${sExpected_GLShortName}    ${sExpected_ExpenseCode}

    ### Keyword Pre-processing ###
    ${Expected_Amount}    Acquire Argument Value    ${sExpected_Amount}
    ${Expected_GLShortName}    Acquire Argument Value    ${sExpected_GLShortName}
    ${Expected_ExpenseCode}    Acquire Argument Value    ${sExpected_ExpenseCode}

    mx LoanIQ activate window    ${LIQ_ManualGL_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualGL_JavaTab}    General
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IncomingManualCashflow_General

    ${UI_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ManualGL_DebitDetails_JavaTree}    ${Expected_Amount}%Amount%value
    ${UI_GLShortName}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ManualGL_DebitDetails_JavaTree}    ${Expected_Amount}%GL Short Name%value
    ${UI_ExpenseCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ManualGL_DebitDetails_JavaTree}    ${Expected_Amount}%Expense Code%value

    Compare Two Strings    ${Expected_Amount}    ${UI_Amount}    Manual GL Debit Details Table Amount Validation
    Compare Two Strings    ${Expected_GLShortName}    ${UI_GLShortName}    Manual GL Debit Details Table GL Short Name Validation
    Compare Two Strings    ${Expected_ExpenseCode}    ${UI_ExpenseCode}    Manual GL Debit Details Table Expense Code Validation

Validate Credit Details at Manual GL Table
    [Documentation]    This keyword used to validate debit details at Manual GL Table.
    ...    @author: hstone    14JUL2020     - Initial Create
    [Arguments]    ${sExpected_Amount}    ${sExpected_GLShortName}    ${sExpected_ExpenseCode}

    ### Keyword Pre-processing ###
    ${Expected_Amount}    Acquire Argument Value    ${sExpected_Amount}
    ${Expected_GLShortName}    Acquire Argument Value    ${sExpected_GLShortName}
    ${Expected_ExpenseCode}    Acquire Argument Value    ${sExpected_ExpenseCode}

    mx LoanIQ activate window    ${LIQ_ManualGL_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualGL_JavaTab}    General
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IncomingManualCashflow_General

    ${UI_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ManualGL_CreditDetails_JavaTree}    ${Expected_Amount}%Amount%value
    ${UI_GLShortName}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ManualGL_CreditDetails_JavaTree}    ${Expected_Amount}%GL Short Name%value
    ${UI_ExpenseCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ManualGL_CreditDetails_JavaTree}    ${Expected_Amount}%Expense Code%value

    Compare Two Strings    ${Expected_Amount}    ${UI_Amount}    Manual GL Debit Details Table Amount Validation
    Compare Two Strings    ${Expected_GLShortName}    ${UI_GLShortName}    Manual GL Debit Details Table GL Short Name Validation
    Compare Two Strings    ${Expected_ExpenseCode}    ${UI_ExpenseCode}    Manual GL Debit Details Table Expense Code Validation