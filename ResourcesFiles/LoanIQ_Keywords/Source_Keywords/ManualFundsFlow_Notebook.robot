*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Navigate to Manual Funds Flow Notebook
    [Documentation]    This keyword will navigate to Manual Funds Flow 
    ...    @author: Archana 20JUL2020
    Select Actions    [Actions];Accounting and Control
    mx LoanIQ activate window    ${LIQ_AccountingAndControl_Window}    
    Mx LoanIQ Enter    ${LIQ_AccountingAndControl_ManualFundFlow}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow
    mx LoanIQ click    ${LIQ_AccountingAndControl_OK_Button}
    
Select New Manual Fund Flow
    [Documentation]    This keyword is used to select new Manul Fund Flow
    ...    @author:Archana 20JUL2020
    Mx LoanIQ Activate Window    ${LIQ_SelectManualFundFlow_Window}
    Mx LoanIQ Enter    ${LIQ_SelectManualFundFlow_New_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlowNewButton
    Mx LoanIQ Click    ${LIQ_SelectManualFundFlow_Ok_Button}
    
Manual FundFlow Details
    [Documentation]    This keyword is used to enter details in Manual FundFlow Notebook
    ...    @author:Archana 20JUL2020
    [Arguments]    ${sManualFundFlow_Branch}    ${sEffective_Date}    ${sCurrency}    ${sDescription}    ${sProcessing_Area}
    
    ###Pre-Processing Keyword###
    ${ManualFundFlow_Branch}    Acquire Argument Value    ${sManualFundFlow_Branch}
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
    ${Currency}    Acquire Argument Value    ${sCurrency}
    ${Description}    Acquire Argument Value    ${sDescription}
    ${Processing_Area}    Acquire Argument Value    ${sProcessing_Area}  

    Mx LoanIQ Activate Window    ${LIQ_ManualFundFlow_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_ManualFundFlow_Branch_JavaList}    ${ManualFundFlow_Branch}        
    Mx LoanIQ Enter    ${LIQ_ManualFundFlow_EffectiveDate}    ${Effective_Date}
    Mx LoanIQ Select Combo Box Value    ${LIQ_ManualFundFlow_Currency}    ${Currency}
    Mx LoanIQ Enter    ${LIQ_ManualFundFlow_Description}    ${Description}
    Mx LoanIQ Select Combo Box Value    ${LIQ_ManualFundFlow_ProcessingArea}    ${Processing_Area}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlowDetails    
    Mx LoanIQ Click    ${LIQ_MaualFundFlow_Expense_Button} 
       
Select Expense Code
    [Documentation]    This keyword is used to select Expense Code
    ...    @author:Archana 20JUL2020
    [Arguments]    ${sExpenseCode}
    
    ###Pre-Processing Keyword###
    ${ExpenseCode}    Acquire Argument Value    ${sExpenseCode}
        
    Mx LoanIQ Activate Window    ${LIQ_ManualFundFlow_Expense_Window}    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualFundFlow_ExpenseCode_JavaTree}    ${ExpenseCode}%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_ExpenseCode
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_Expense_Ok_Button}    
    
Select Security ID
    [Documentation]    This keyword is used to select Security ID
    ...    @author:Archana 20JUL2020
    Mx LoanIQ Activate Window    ${LIQ_ManualFundFlow_Window}
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_SecurityID_Button}              
    Mx LoanIQ Activate Window    ${LIQ_ManualFundFlow_SecurityID_Select_Window}
    Mx LoanIQ Enter    ${LIQ_ManualFundFlow_securityID_Deal_Radiobutton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_SecurityID    
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_SecurityID_Select_OK_Button}    
    
Select Deal
    [Documentation]    This keyword is used to select Deal
    ...    @author:Archana 20JUL2020
    [Arguments]    ${sDeal_Name}
    
    ###Pre-processing Keyword###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name} 
           
    mx LoanIQ activate window    ${LIQ_DealSelect_Window}   
    mx LoanIQ enter    ${LIQ_DealSelect_Search_TextField}     ${Deal_Name} 
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}
    
Add IncomingFunds
    [Documentation]    This keyword is used to Add Incoming Funds
    ...    @author:Archana 20JUL2020
    [Arguments]    ${sIncomingFund_Amount}    ${sCustomer}
    
    ###Pre-processing keyword###
    
    ${IncomingFund_Amount}    Acquire Argument Value    ${sIncomingFund_Amount}    
    ${Customer}    Acquire Argument Value    ${sCustomer}
     
    Mx LoanIQ Activate Window    ${LIQ_ManualFundFlow_Window}    
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_IncomingFundAdd_Button}
    Mx LoanIQ Activate Window    ${LIQ_ManualFundFlow_IncomingFund_Window}
    Mx LoanIQ Enter    ${LIQ_ManualFundFlow_IncomingFund_Amount}    ${IncomingFund_Amount}
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_IncomingFund_Customer_Button}
    Select Customer    ${Customer}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_IncomingFund
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_IncomingFund_OK_Button}           
    
Select Customer
    [Documentation]    This keyword is used to select the Customer
    ...    @author:Archana 20JUL2020
    [Arguments]    ${sLIQCustomer_ShortName}
    
    ###Pre-processing keyword###
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}
        
    Mx LoanIQ Activate    ${LIQ_CustomerSelect_Window}       
    Mx LoanIQ Enter    ${LIQ_CustomerSelect_Search_Inputfield}     ${LIQCustomer_ShortName}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/CustomerSelectWindow
    Mx LoanIQ Click    ${LIQ_CustomerSelect_OK_Button}
    
Add OutgoingFunds
    [Documentation]    This keyword is used to Add Outgoing Funds
    ...    @author:Archana 20JUL2020
    [Arguments]    ${sOutgoingFund_Amount}    ${sCustomer}
    
    ###Pre-processing keyword###
    
    ${OutgoingFund_Amount}    Acquire Argument Value    ${sOutgoingFund_Amount}    
    ${OutgoingFund_Amount}    Acquire Argument Value    ${sCustomer}
    
    Mx LoanIQ Activate Window    ${LIQ_ManualFundFlow_Window}    
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_OutgoingFundAdd_Button}
    Mx LoanIQ Activate Window    ${LIQ_ManualFundFlow_OutgoingFund_Window}
    Mx LoanIQ Enter    ${LIQ_ManualFundFlow_OutgoingFund_Amount}    ${OutgoingFund_Amount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_OutgoingFund
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_OutgoingFund_Customer_Button}
    Select Customer    ${sCustomer}
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_OutgoingFund_OK_Button}
    
Navigate Notebook Workflow - Cashflow Creation
    [Documentation]    This keyword is used to create cashflow in workflow
    ...    @author:Archana 21JUL2020
    mx LoanIQ activate    ${LIQ_ManualFundFlow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualFundFlow_JavaTab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualFundFlow_WorkflowItems}    Create Cashflows%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

Close Cashflow Window
    [Documentation]    This keywrd is used to close cashflow window
    ...    @author: Archana 22JUL2020
     Mx LoanIQ Close Window   ${LIQ_Cashflows_Window} 
        
Send Manual Fund Flow to Approval
    [Documentation]    This keyword will send the Manual Fund Flow to Approval
    ...    @author: Archana 21JUL2020  
    mx LoanIQ activate window    ${LIQ_ManualFundFlow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualFundFlow_JavaTab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_ManualFundFlow_WorkflowItems}    Send to Approval
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Approve Manual Fund Flow
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Manual Fund Flow.
    ...    @author: Archana 21JUL2020   
    mx LoanIQ activate    ${LIQ_ManualFundFlow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualFundFlow_JavaTab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualFundFlow_WorkflowItems}    Approval%d 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
  
Release Manual Fund Flow
    [Documentation]    This  keyword will release the Manual Fund Flow
    ...    @author: Archana 21JUL2020    
    mx LoanIQ activate window    ${LIQ_ManualFundFlow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualFundFlow_JavaTab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualFundFlow_WorkflowItems}    Release%d 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 

Navigate to Release Cashflow - Manual Fund Flow
    [Documentation]    This  keyword will release the Manual GL
    ...    @author: Archana 21JUL2020    
    mx LoanIQ activate window    ${LIQ_ManualFundFlow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualFundFlow_JavaTab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualFundFlow_WorkflowItems}    Release Cashflows%d 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Validate Events Tab for Manual Fund Flow
    [Documentation]    This  keyword will validate Manual Fund Flow Events in the Events tab
    ...    @author: Archana 21JUL2020
    mx LoanIQ activate window    ${LIQ_ManualFundFlow_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualFundFlow_JavaTab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_ManualFundFlow_Events_Javatree}    Released
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_ReleasedStatus
    
Select Existing Manual Fund Flow
    [Documentation]    This keyword is used to select Existing Manul Fund Flow
    ...    @author:Archana 20JUL2020
    [Arguments]    ${sRange_From}    ${sRange_To}  
    
    ###Pre-processing keyword###
    ${Range_From}    Acquire Argument Value    ${sRange_From}    
    ${Range_To}    Acquire Argument Value    ${sRange_To} 
     
    Mx LoanIQ Activate Window    ${LIQ_SelectManualFundFlow_Window}
    Mx LoanIQ Enter    ${LIQ_SelectManualFundFlow_Existing_RadioButton}    ON
    Mx LoanIQ Enter    ${LIQ_SelectManualFundFlow_RangeFrom}    ${Range_From}
    Mx LoanIQ Enter    ${LIQ_SelectManualFundFlow_RangeTo}    ${Range_To}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_Range
    Mx LoanIQ Click    ${LIQ_SelectManualFundFlow_Search_Button}    
    
Select Manual Fund Flow Transaction From List
    [Documentation]    This keyword is used to select Transaction from the List
    ...    @author: Archana 20JUL2020
    [Arguments]    ${sTransaction_List} 
    
    ###Pre-processing keyword###
    ${Transaction_List}    Acquire Argument Value    ${sTransaction_List}
        
    Mx LoanIQ Activate Window    ${LIQ_ManualFundFlow_TransactionList_Window}    
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_ManualFundFlow_TransactionList_Javatree}    ${Transaction_List}%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ManualFundFlow_TransactionList    
    Mx LoanIQ Click    ${LIQ_ManualFundFlow_TransactionList_Ok_Button}  
    Mx LoanIQ Close Window    ${LIQ_ManualFundFlow_TransactionList_Window}      
    
Validation Of GL Entries
    [Documentation]    This keyword is used to validate the GL Entries of Manual Fund Flow Transaction
    ...    @author: Archana 21JUL2020
    mx LoanIQ activate window    ${LIQ_ManualFundFlow_Window}
    Select Menu Item    ${LIQ_ManualFundFlow_Window}    Options    GL Entries
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GLEntries
 
Close GL Entries_Manual Fund Flow Notebook
    [Documentation]    This keyword is used to close GL Entries Notebook
    ...    @author:Archana 22JUL2020
    Mx LoanIQ Close Window    ${LIQ_ManualFundFlow_GLEntries_Window} 