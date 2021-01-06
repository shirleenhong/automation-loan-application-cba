*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Approve Deal Change Transaction
    [Documentation]    This keywod will approve the deal change transaction
    ...    @author: mnanquilada
    ...    @update: fmamaril    22MAY2020    - Add Screenshot path
    Mx LoanIQ Select Window Tab    ${LIQ_DealChangeTransaction_AwaitingApproval_Tab}    Workflow
    Mx LoanIQ select    ${LIQ_DealChangeTransaction_Status_Approve}
    Validate Question Message Box        
    Mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Validate Warning Message Box               
    Mx LoanIQ click element if present   ${LIQ_Warning_Yes_Button}
    Mx LoanIQ click element if present   ${LIQ_Warning_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Awaiting Release / Deal Change Transaction.*.*")    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealChangeTransaction_Workflow    

Release Deal Change Transaction
    [Documentation]    This keyword will release the deal change transaction
    ...    @author: mnanquilada
    ...    @update: fmamaril    22MAY2020    - Add Screenshot path
    ...    @update: kmagday    04JAN2020     - Close Deal Notebook before releasing(can't release if deal notebook is open)

    ${dealNotebookIsOpen}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_Window}
    Run Keyword If    ${dealNotebookIsOpen}==${True}    Mx LoanIQ close window    ${LIQ_DealNotebook_Window}
 
    Mx LoanIQ select    ${LIQ_DealChangeTransaction_Status_Release}
    Mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate Question Message Box
    Mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ close window    ${LIQ_DealChange_JavaWindow}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealChangeTransaction_Workflow

Send Approval Deal Change Transaction
    [Documentation]    This keyword will send the deal change transaction to approval
    ...    @author: mnanquilada
    ...    @update: fmamaril    18MAR2019    Modify Mx Click to Mx Click element if present for Warning Yes
    ...    @update: bernchua    05APR2019    Added click element if present for cancel button if Set Financial Ratio window is present.
    ...    @update: fmamaril    22MAY2020    Updated to align with automation standards and added keyword pre processing
    [Arguments]    ${sCurrentDate}

    ### GetRuntime Keyword Pre-processing ###
    ${CurrentDate}    Acquire Argument Value    ${sCurrentDate}

    Mx LoanIQ click element if present    ${LIQ_DealChangeTransaction_SelectFinancialRatio_Cancel_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_DealChangeTransaction_Tab}    Workflow
    Mx LoanIQ select    ${LIQ_DealChangeTransaction_Status_SendToApproval}        
    Validate Warning Message Box               
    Mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    Mx LoanIQ Click Javatree Cell    ${LIQ_DealChangeTransaction_WorkFlow_AwaitingApproval_JavaTree}    Approval%s
    Mx LoanIQ Click Javatree Cell    ${LIQ_DealChangeTransaction_WorkFlow_AwaitingApproval_JavaTree}    ${CurrentDate}%s
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Awaiting Approval / Deal Change Transaction.*.*")    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealChangeTransaction_Workflow

Add Financial Ratio Deal Change Transaction
    [Documentation]    This keyword will add a financial ratio in Deal Change Transaction
    ...    @author: mnanquilada
    ...    @update: fmamaril    18MAR2019    Modify Mx Click to Mx Click Element If Present for Warning Yes
    ...    @update    bernchua    31MAY2019    updated Mx LoanIQ Click Javatree Cell to Mx LoanIQ Select String after adding new ratio
    ...    @update: fmamaril    20MAY2020    Updated to align with automation standards and added keyword pre processing
    [Arguments]    ${sLIQ_FinancialRatio}    ${sLIQ_FinancialPrice}    ${sLIQ_DealChange_Date}    ${sFinancial_Ratio_Type}
    
    ### GetRuntime Keyword Pre-processing ###
    ${LIQ_FinancialRatio}    Acquire Argument Value    ${sLIQ_FinancialRatio}
    ${LIQ_FinancialPrice}    Acquire Argument Value    ${sLIQ_FinancialPrice}
    ${LIQ_DealChange_Date}    Acquire Argument Value    ${sLIQ_DealChange_Date}
    ${Financial_Ratio_Type}    Acquire Argument Value    ${sFinancial_Ratio_Type}
        
    Mx LoanIQ Select Window Tab    ${LIQ_DealChangeTransaction_Tab}    Ratios
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealChangeTransaction_Ratios_Add_Button}    Add
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealChangeTransaction_Ratios_Delete_Button}    Delete  
    Mx LoanIQ click    ${LIQ_DealChangeTransaction_Ratios_Add_Button}
    Mx LoanIQ enter    ${LIQ_DealChangeTransaction_FinancialRatio_SearchBox}    ${Financial_Ratio_Type}
    Mx LoanIQ click    ${LIQ_DealChangeTransaction_SelectFinancialRatio_Ok_Button}   
    Mx LoanIQ activate window    ${LIQ_DealChangeTransaction_FinancialRatioAdd_Window}                                                
    Mx LoanIQ enter    ${LIQ_DealChangeTransaction_FinantialRatio_Field}    ${LIQ_FinancialPrice}
    Mx LoanIQ enter    ${LIQ_DealChangeTransaction_FinantialRatio_Date_Field}    ${LIQ_DealChange_Date}
    ${LIQ_DealChange_Date}    Mx LoanIQ Get Data    ${LIQ_DealChangeTransaction_FinantialRatio_Date_Field}    LIQ_DealChange_Date
    Set Global Variable    ${LIQ_DealChange_Date}    
    Log    ${LIQ_DealChange_Date}       
    Mx LoanIQ click    ${LIQ_DealChangeTransaction_FinancialRatio_Ok_Button}
    Validate Warning Message Box       
    Mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_DealChangeTransaction_FinancialRatio_JavaTree}    ${LIQ_FinancialRatio}    
    Run Keyword If    '${status}'=='True'    Log    Successfully validated the value inside java tree        
    Run Keyword If    '${status}'=='False'    Fail    Failed to validate text inside the Java Tree   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealChangeTransaction_Ratios

Validate Status of Deal and Navigate to Deal Change Transaction    
    [Documentation]    This keyword will validate status of the closed deal and trigger deal change transaction.
    ...    @author: fmamaril
    ...    @update: rtarayao    23SEP2019    - Added keyword to handle warning message
    ...    @update: fmamaril    22MAY2020    - Add Screenshot path
    Mx LoanIQ activate window    ${LIQ_DealNotebook_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Deal Notebook - Closed Deal.*")    VerificationData="Yes"
    Mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}    
    Mx LoanIQ select    ${LIQ_DealNotebook_Options_DealChangeTransactions}
    Mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealChangeTransaction     
    
Validate added financial ratio on the deal
    [Documentation]    This keyword will validates if the financial ratio is added via deal change.
    ...    @author: fmamaril
    ...    @update: fmamaril    20MAY2020    Updated to align with automation standards and added keyword pre processing
    [Arguments]    ${sFinancial_Ratio_Type}

    ### GetRuntime Keyword Pre-processing ###
    ${Financial_Ratio_Type}    Acquire Argument Value    ${sFinancial_Ratio_Type}
    
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Ratios/Conds
    Mx LoanIQ Click Javatree Cell    ${LIQ_FinantialRatio_JavaTree}    ${Financial_Ratio_Type}%s
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Events_Javatree}   Deal Change Transaction Released            
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealChangeTransaction
    Close All Windows on LIQ
    
Modify Financial Ratio via Deal Change Transaction
    [Documentation]    This keyword will modify a financial ratio in Deal Change Transaction
    ...    @author: fmamaril    10SEP2019    Initial Create
    [Arguments]    ${iLIQ_FinancialRatio}    ${sFinancial_Ratio_Type}
    Mx LoanIQ Select Window Tab    ${LIQ_DealChangeTransaction_Tab}    Ratios
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealChangeTransaction_Ratios_Add_Button}    Add
    Run Keyword And Continue On Failure    Validate if Element is Enabled    ${LIQ_DealChangeTransaction_Ratios_Delete_Button}    Delete
    Mx LoanIQ Select String    ${LIQ_DealChangeTransaction_FinancialRatio_JavaTree}    ${sFinancial_Ratio_Type}
    Mx Native Type    {ENTER}
    Mx LoanIQ activate window    ${LIQ_DealChangeTransaction_FinancialRatioUpdate_Window}
    Mx LoanIQ enter    ${LIQ_DealChangeTransaction_FinantialRatio_Field}    ${iLIQ_FinancialRatio}      
    Mx LoanIQ click    ${LIQ_DealChangeTransaction_FinancialRatio_Ok_Button}       
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_DealChangeTransaction_FinancialRatio_JavaTree}    ${iLIQ_FinancialRatio}
    Run Keyword If    '${status}'=='True'    Log    Successfully validated the value inside java tree        
    Run Keyword If    '${status}'=='False'    Fail    Failed to validate text inside the Java Tree  

Modify Deal Expense Code and Processing Area
    [Documentation]    This keyword updates the Deal's Expense Code and Processing Area.
    ...    This also returns the updated Expense and Processing Area Desciption. 
    ...    @author: rtarayao    24SEP2019    - Initial Create 
    [Arguments]    ${sExpenseCode}    ${sProcessingAreaCode}
    Mx LoanIQ click    ${LIQ_DealChangeTransaction_ExpenseCode_Button}
    Mx LoanIQ click    ${LIQ_SelectExpenseCode_All_Button}
    ${ExpenseDescription}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SelectExpenseCode_JavaTree}    ${sExpenseCode}%Description%CodeDescription
    Mx LoanIQ enter    ${LIQ_SelectExpenseCode_Search_TextField}    ${sExpenseCode}
    Log    Expense Description for ${sExpenseCode} is ${ExpenseDescription}  
    Mx LoanIQ click    ${LIQ_SelectExpenseCode_OK_Button}
    Mx LoanIQ click    ${LIQ_DealChangeTransaction_ProcessingArea_Button}
    ${ProcessingAreaDescription}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_DealChangeTransaction_ProcessingArea_JavaTree}    ${sProcessingAreaCode}%Description%ProcAreaDescription
    Mx LoanIQ enter    ${LIQ_DealChangeTransaction_ProcessingArea_Search_TextField}    ${sProcessingAreaCode}
    Log    Processing Area Description for ${sProcessingAreaCode} is ${ProcessingAreaDescription}
    Mx LoanIQ click    ${LIQ_DealChangeTransaction_ProcessingArea_OK_Button}
    [Return]    ${ExpenseDescription}    ${ProcessingAreaDescription} 


Validate added outside condition on the deal
    [Documentation]    This keyword will validates if the false outside condition is added via deal change.
    ...    @author: kmagday    04JAN2021    - Initial create
    [Arguments]    ${sStartDate}  

    ### Keyword Pre-processing ###
    ${startDate}    Acquire Argument Value    ${sStartDate}
    
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Ratios/Conds
    mx LoanIQ click    ${LIQ_OutsideConditions_History_Button}

    Mx LoanIQ Click Javatree Cell    ${LIQ_OutsideConditions_JavaTree}    ${startDate}%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealChangeTransaction
    mx LoanIQ click    ${LIQ_OutsideConditions_Cancel_Button}

    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events    
    Mx LoanIQ Select String    ${LIQ_Events_Javatree}    Deal Change Transaction Released            
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealChangeTransaction

    Close All Windows on LIQ
             
                  
    
            
        
