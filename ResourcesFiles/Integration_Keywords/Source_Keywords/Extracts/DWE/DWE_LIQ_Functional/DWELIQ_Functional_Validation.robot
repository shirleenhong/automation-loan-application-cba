*** Settings ***
Resource    ../../../../../../Configurations/Integration_Import_File.robot

*** Variables ***


*** Keywords ***

Validate the Short Name Code and Natural Balance records in LIQ Screen
    [Documentation]    This keyword is used to validate the Short Name Code and Natural Balance records from CSV in LIQ Screen.
    ...    @author: mgaling    23Aug2019    Initial Create
    [Arguments]    ${aTable_NameList}    ${iColumnIndex_SHTNAME}    ${iColumnIndex_SHTNAME_DSC}    ${iColumnIndex_NATURL_BAL}
    
    
    ${VLS_GL_SHORT_NAME_Data_Rows}    Get Length    ${aTable_NameList}
    :FOR    ${INDEX}    IN RANGE    ${VLS_GL_SHORT_NAME_Data_Rows}
    \    ${Table_NameList}    Set Variable    @{aTable_NameList}[${INDEX}]
    \    Log    ${Table_NameList}    
    \    ${ShortName}    Remove String    @{Table_NameList}[${iColumnIndex_SHTNAME}]    "
    \    ${ShortName_Desc}    Remove String    @{Table_NameList}[${iColumnIndex_SHTNAME_DSC}]    "    
    \    ${NaturalBalance}    Remove String    @{Table_NameList}[${iColumnIndex_NATURL_BAL}]    "
    \    Run Keyword If    "${ShortName}"!="SNM_CDE_GL_SHTNAME" and "${ShortName_Desc}"!="SNM_DSC_GL_SHTNAME"    Check the Short Name Code in GL Short Name Window    ${ShortName.strip()}    ${ShortName_Desc.strip()}
    \    Run Keyword If    '${NaturalBalance}'!='SNM_CDE_NATURL_BAL'    Check the Natural Balance value in GL Short Name Update Window    ${NaturalBalance.strip()}
    
    Close All Windows on LIQ

Get Risk Book List of Code
    [Documentation]    This keyword retrieves the list of code from Risk Book
    ...    @author: ehugo    29AUG2019    - initial create
    ...    @update: mgaling    23OCT2020    - added screenshot path
    
    ${RiskBook_Items}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_BrowseRiskBook_JavaTree}    RiskBook_Items    Processtimeout=180
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/RiskBook_Items
    Log    ${RiskBook_Items}    
    
    ${Codes_List}    Create List
    
    @{Row_Item}    Split String    ${RiskBook_Items}    ,Y
    ${Row_Item_Count}    Get Length    ${Row_Item}
    :FOR    ${i}    IN RANGE    1    ${Row_Item_Count}
    \    ${TempVar}    Set Variable    @{Row_Item}[${i}]
    \    ${TempVar}    Set Variable    ${TempVar.strip()}
    \    ${TempVar}    Set Variable    ${TempVar.split(' ',1)[0]}
    \    ${TempVar}    Set Variable    ${TempVar.split('\t',1)[0]}
    \    Append To List     ${Codes_List}    ${TempVar}
    
    Close All Windows on LIQ
    
    [Return]    ${Codes_List}
    
Validate Records for RPE_CDE_RISK_BOOK exist in LIQ
    [Documentation]    This keyword validates if records for RPE_CDE_RISK_BOOK exist in LIQ
    ...    @author: ehugo    29AUG2019    - initial create
    ...    @update: mgaling    23OCT2020    - removed Read Csv File To List keyword and updated arguments
    [Arguments]    ${aRiskPortExp_CSV_Content}    ${aCodes_List}
    
    ${RiskPortExp_Header}    Get From List    ${aRiskPortExp_CSV_Content}    0
    ${RiskPortExp_Length}    Get Length    ${aRiskPortExp_CSV_Content}
    ${RPE_CDE_RISK_BOOK_Index}    Get Index From List    ${RiskPortExp_Header}    RPE_CDE_RISK_BOOK    
    
    :FOR    ${i}    IN RANGE    1    ${RiskPortExp_Length}
    \    ${RiskPortExp_Row_Item}    Get From List    ${aRiskPortExp_CSV_Content}    ${i}
    \    ${RiskPortExp_Row_Value}    Get From List    ${RiskPortExp_Row_Item}    ${RPE_CDE_RISK_BOOK_Index}
    \    ${count}    Get Match Count    ${aCodes_List}    ${RiskPortExp_Row_Value.strip()}    
    \    Run Keyword If    ${count}==0    Run Keyword And Continue On Failure    FAIL    ${RiskPortExp_Row_Value} does not exist in LIQ Risk Book.
         ...    ELSE    Log    ${RiskPortExp_Row_Value} is available in LIQ Risk Book.       

Validate CUS_CID_CUST_ID and CUS_XID_CUST_ID in LIQ for VLS_Customer
    [Documentation]    This keyword validates CUS_CID_CUST_ID and CUS_XID_CUST_ID in LIQ for VLS_Customer
    ...    @author: ehugo    29AUG2019
    ...    updated: mgaling    10FEB2020    Added on the loop function to handle UNKNOWN data
    ...    updated: mgaling    07OCT2020    Created separate keyword for CUS_XID_CUST_ID validation  
    [Arguments]    ${sCustomer_CSVFileName}    
    
    ${Customer_CSV_Content}    Read Csv File To List    ${sCustomer_CSVFileName}    |
    ${Record_Count}    Get Length    ${Customer_CSV_Content}
    
    ${CUS_CID_CUST_ID_Index}    Get the Column index of the Header    ${sCustomer_CSVFileName}    CUS_CID_CUST_ID    
    ${CUS_XID_CUST_ID_Index}    Get the Column index of the Header    ${sCustomer_CSVFileName}    CUS_XID_CUST_ID
    
    :FOR    ${i}    IN RANGE    1    ${Record_Count}
    \    ${CUS_CID_CUST_ID_Value}    Get the Column Value using Row Number and Column Index    ${sCustomer_CSV_FileName}    ${i}    ${CUS_CID_CUST_ID_Index}    
    \    ${CUS_XID_CUST_ID_Value}    Get the Column Value using Row Number and Column Index    ${sCustomer_CSV_FileName}    ${i}    ${CUS_XID_CUST_ID_Index}
    \    
    \    Continue For Loop If    '${CUS_CID_CUST_ID_Value.strip()}'=='NONE' or '${CUS_CID_CUST_ID_Value.strip()}'=='UNKNOWN' 
    \        
    \    Run Keyword And Continue On Failure    Validate CUS_XID_CUST_ID in Customer Notebook    ${CUS_CID_CUST_ID_Value.strip()}    ${CUS_XID_CUST_ID_Value.strip()}
    \    Close All Windows on LIQ       

Validate BSG_CDE_CURRENCY in LIQ for VLS_Bal_Subledger
    [Documentation]    This keyword validates BSG_CDE_CURRENCY in LIQ for VLS_Bal_Subledger
    ...    @author: ehugo    30AUG2019
    [Arguments]    ${sCSV_FileName}    
    
    ${CSV_Content}    Read Csv File To List    ${sCSVFileName}    |
    ${Record_Count}    Get Length    ${CSV_Content}
    
    ${BSG_PID_DEAL_Index}    Get the Column index of the Header    ${sCSV_FileName}    BSG_PID_DEAL    
    ${BSG_CDE_CURRENCY_Index}    Get the Column index of the Header    ${sCSV_FileName}    BSG_CDE_CURRENCY    
    
    :FOR    ${i}    IN RANGE    1    ${Record_Count}
    \    ${BSG_PID_DEAL_Value}    Get the Column Value using Row Number and Column Index    ${sCSV_FileName}    ${i}    ${BSG_PID_DEAL_Index}    
    \    ${BSG_CDE_CURRENCY_Value}    Get the Column Value using Row Number and Column Index    ${sCSV_FileName}    ${i}    ${BSG_CDE_CURRENCY_Index}   
    \
    \    ###Select By RID###
    \    Select By RID    Deal    ${BSG_PID_DEAL_Value.strip()}
    \
    \    ###Deal Notebook Window###
    \    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    \    ${Currency_Field}    Set Variable    JavaWindow("title:=Deal Notebook -.*","displayed:=1").JavaStaticText("attached text:=${BSG_CDE_CURRENCY_Value.strip()}")
    \    ${CorrectCurrency_IsDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Currency_Field}    VerificationData="Yes"
    \    Run Keyword If     ${CorrectCurrency_IsDisplayed}==${False}    Run Keyword And Continue On Failure    FAIL   ${BSG_CDE_CURRENCY_Value.strip()} currency is not displayed.
         ...    ELSE    Log    ${BSG_CDE_CURRENCY_Value.strip()} is displayed.
    \    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Currency
    \    
    \    mx LoanIQ close window    ${LIQ_DealNotebook_Window}
       
Validate BSG_CDE_GL_ACCOUNT in LIQ for VLS_Bal_Subledger
    [Documentation]    This keyword validates BSG_CDE_GL_ACCOUNT in LIQ for VLS_Bal_Subledger
    ...    @author: ehugo    30AUG2019
    [Arguments]    ${sBal_Subledger_CSV_Filename}    ${sGL_Account_CSV_Filename}
    
    ${CSV_Content}    Read Csv File To List    ${sBal_Subledger_CSV_FileName}    |
    ${Record_Count}    Get Length    ${CSV_Content}
    
    ${BSG_CDE_GL_ACCOUNT_Index}    Get the Column index of the Header    ${sBal_Subledger_CSV_FileName}    BSG_CDE_GL_ACCOUNT    
    
    ###Navigate to Actions -> Table Maintenance###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    G/L Account Number
    
    ${Account_List}    Create List
    
    :FOR    ${i}    IN RANGE    1    ${Record_Count}
    \    ${BSG_CDE_GL_ACCOUNT_Value}    Get the Column Value using Row Number and Column Index    ${sBal_Subledger_CSV_Filename}    ${i}    ${BSG_CDE_GL_ACCOUNT_Index}    
    \    ${count}    Get Match Count    ${Account_List}    ${BSG_CDE_GL_ACCOUNT_Value.strip()}
    \    Run Keyword If    ${count}==0    Append To List    ${Account_List}    ${BSG_CDE_GL_ACCOUNT_Value.strip()}
    \    Continue For Loop If    ${count}>0
    \    ${Description}    Get Reference Column Value using Source Column Value - Single Reference    ${sGL_Account_CSV_Filename}    ACN_CDE_ACCT_NUM    ${BSG_CDE_GL_ACCOUNT_Value.strip()}    ACN_DSC_ACCT_NUM
    \
    \    ###Search for the G/L Account Number###
    \    mx LoanIQ activate window    ${LIQ_BrowseGLAccountNumber_Window}
    \    ${GL_Account_Number_List}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_BrowseGLAccountNumber_Tables_JavaTree}    GL_Account_Number_List    Processtimeout=180
    \    ${GL_Account_Number_IsExist}    Run Keyword And Return Status    Should Contain    ${GL_Account_Number_List}    ${BSG_CDE_GL_ACCOUNT_Value.strip()}    
    \    Run Keyword If    ${GL_Account_Number_IsExist}==${False}    Run Keyword And Continue On Failure    FAIL    ${BSG_CDE_GL_ACCOUNT_Value.strip()} is not displayed in LIQ.
         ...    ELSE    Log    ${BSG_CDE_GL_ACCOUNT_Value.strip()} is displayed in LIQ.
    \
    \    Mx LoanIQ Select String    ${LIQ_BrowseGLAccountNumber_Tables_JavaTree}    ${BSG_CDE_GL_ACCOUNT_Value.strip()}\t${Description.strip()}
    \    Mx Press Combination    KEY.ENTER
    \
    \    Run Keyword And Ignore Error    Mx LoanIQ Click Button On Window    .*Account Number.*;Warning.*;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    \
    \    ###G/L Account Number Update Window###
    \    mx LoanIQ activate window    ${LIQ_BrowseGLAccountNumber_Update_Window}
    \    ${AccountNumber_IsExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=G/L Account Number Update").JavaEdit("text:=${BSG_CDE_GL_ACCOUNT_Value.strip()}")        VerificationData="Yes"
    \    Take Screenshot    ${screenshot_path}/Screenshots/DWE/GL_AccountNumber
    \    Run Keyword If    ${AccountNumber_IsExist}==${False}    Run Keyword And Continue On Failure    FAIL    Incorrect GL_AccountNumber value is displayed in LIQ. Expected: ${BSG_CDE_GL_ACCOUNT_Value.strip()}
         ...    ELSE    Log    Correct GL_AccountNumber value is displayed in LIQ.
    \    
    \    mx LoanIQ close window    ${LIQ_BrowseGLAccountNumber_Update_Window}    
    
    Close All Windows on LIQ

Validate BSG_CDE_GL_SHTNAME in LIQ for VLS_Bal_Subledger
    [Documentation]    This keyword validates BSG_CDE_GL_SHTNAME in LIQ for VLS_Bal_Subledger
    ...    @author: ehugo    30AUG2019
    [Arguments]    ${sBal_Subledger_CSV_Filename}    ${sShortName_CSV_Filename}
    
    ${CSV_Content}    Read Csv File To List    ${sBal_Subledger_CSV_Filename}    |
    ${Record_Count}    Get Length    ${CSV_Content}
    
    ${BSG_CDE_GL_SHTNAME_Index}    Get the Column index of the Header    ${sBal_Subledger_CSV_Filename}    BSG_CDE_GL_SHTNAME    
    
    ##Navigate to Actions -> Table Maintenance###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    G/L Short Name
        
    ${ShortName_List}    Create List
        
    :FOR    ${i}    IN RANGE    1    ${Record_Count}
    \    ${BSG_CDE_GL_SHTNAME_Value}    Get the Column Value using Row Number and Column Index    ${sBal_Subledger_CSV_Filename}    ${i}    ${BSG_CDE_GL_SHTNAME_Index}
    \    ${count}    Get Match Count    ${ShortName_List}    ${BSG_CDE_GL_SHTNAME_Value.strip()}
    \    Run Keyword If    ${count}==0    Append To List    ${ShortName_List}    ${BSG_CDE_GL_SHTNAME_Value.strip()}
    \    Continue For Loop If    ${count}>0   
    \    ${Description}    Get Reference Column Value using Source Column Value - Single Reference    ${sShortName_CSV_Filename}    SNM_CDE_GL_SHTNAME    ${BSG_CDE_GL_SHTNAME_Value.strip()}    SNM_DSC_GL_SHTNAME
    \    
    \    ###Search for the G/L Short Name###
    \    mx LoanIQ activate window    ${LIQ_BrowseGLShortName_Window}
    \    ${GL_ShortName_List}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_BrowseGLShortName_JavaTree}    GL_ShortName_List    Processtimeout=180
    \    ${GL_ShortName_IsExist}    Run Keyword And Return Status    Should Contain    ${GL_ShortName_List}    ${BSG_CDE_GL_SHTNAME_Value.strip()}    
    \    Run Keyword If    ${GL_ShortName_IsExist}==${False}    Run Keyword And Continue On Failure    FAIL    ${BSG_CDE_GL_SHTNAME_Value.strip()} is not displayed in LIQ.
         ...    ELSE    Log    ${BSG_CDE_GL_SHTNAME_Value.strip()} is displayed in LIQ.
    \
    \    Mx LoanIQ Select String    ${LIQ_BrowseGLShortName_JavaTree}    ${BSG_CDE_GL_SHTNAME_Value.strip()}\t${Description.strip()}
    \    Mx Press Combination    KEY.ENTER
    \
    \    Run Keyword And Ignore Error    Mx LoanIQ Click Button On Window    .*Short Name.*;Warning.*;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    \
    \    ###G/L Short Name Update Window###
    \    mx LoanIQ activate window    ${LIQ_BrowseGLShortName_Update_Window}
    \    ${Code}    Mx LoanIQ Get Data    ${LIQ_BrowseGLShortName_Update_Code_Field}    Code    
    \    Log    Expected: ${BSG_CDE_GL_SHTNAME_Value.strip()}
    \    Log    Actual: ${Code}
    \    ${Verify_Equal}    Run Keyword And Return Status    Should Be Equal As Strings    ${BSG_CDE_GL_SHTNAME_Value.strip()}    ${Code.strip()}    
    \    Take Screenshot    ${screenshot_path}/Screenshots/DWE/GL_ShortName
    \    Run Keyword If    ${Verify_Equal}==${False}    Run Keyword And Continue On Failure    FAIL    Incorrect GL_ShortName value '${Code}' is displayed in LIQ.
         ...    ELSE    Log    Correct GL_ShortName value '${Code}' is displayed in LIQ.
    \    
    \    mx LoanIQ close window    ${LIQ_BrowseGLShortName_Update_Window}
    
    Close All Windows on LIQ

Get Reference Column Value using Source Column Value - Single Reference
    [Documentation]    This keyword retrieves the reference column value using source column value. For single reference column.
    ...    @author: ehugo    02SEP2019
    [Arguments]    ${CSV_Filename}    ${Source_Header_Name}    ${Source_Column_Value}    ${Reference_Header_Name}
    
    ${CSV_Content}    Read Csv File To List    ${CSV_Filename}    |
    ${Header}    Get From List    ${CSV_Content}    0
    ${Length}    Get Length    ${CSV_Content}
    ${Source_Index}    Get Index From List    ${Header}    ${Source_Header_Name}
    ${Reference_Index}    Get Index From List    ${Header}    ${Reference_Header_Name}
    
    :FOR    ${i}    IN RANGE    1    ${Length}
    \    ${Row_Item}    Get From List    ${CSV_Content}    ${i}
    \    ${Source_Value}    Get From List    ${Row_Item}    ${Source_Index}
    \    ${Reference_Value}    Get From List    ${Row_Item}    ${Reference_Index}
    \    Exit For Loop If    '${Source_Value.strip()}'=='${Source_Column_Value.strip()}'
    
    [Return]    ${Reference_Value}
    
Get Reference Column Value using Source Column Value - Multi Reference
    [Documentation]    This keyword retrieves the reference column value using source column value. For multiple reference column.
    ...    @author: ehugo    05SEP2019
    [Arguments]    ${CSV_Filename}    ${Source_Header_Name}    ${Source_Column_Value}    ${Reference_Header_Name}
    
    @{Split_Reference}    Split String    ${Reference_Header_Name}    |
    ${Split_Reference_Length}    Get Length    ${Split_Reference}
    
    ${CSV_Content}    Read Csv File To List    ${CSV_Filename}    |
    ${Header}    Get From List    ${CSV_Content}    0
    ${Length}    Get Length    ${CSV_Content}
    ${Source_Index}    Get Index From List    ${Header}    ${Source_Header_Name}
    
    ${Reference_Dictionary}    Create Dictionary    
    
    :FOR    ${i}    IN RANGE    0    ${Split_Reference_Length}
    \    ${temp_value}    Get Index From List    ${Header}    @{Split_Reference}[${i}]
    \    Set To Dictionary    ${Reference_Dictionary}    Reference_Index${i}=${temp_value}
    
    
    :FOR    ${i}    IN RANGE    1    ${Length}
    \    ${Row_Item}    Get From List    ${CSV_Content}    ${i}
    \    ${Source_Value}    Get From List    ${Row_Item}    ${Source_Index}
    \    ${Value_Dictionary}    Loop for Get Reference Column Value using Source Column Value - Multi Reference    ${Split_Reference_Length}    ${Row_Item}    ${Reference_Dictionary}
    \    Exit For Loop If    '${Source_Value.strip()}'=='${Source_Column_Value.strip()}'
    
    [Return]    ${Value_Dictionary}
    
Loop for Get Reference Column Value using Source Column Value - Multi Reference
    [Documentation]    This keyword is only used for Get Reference Column Value using Source Column Value - Multi Reference keyword
    ...    @author: ehugo    05SEP2019
    [Arguments]    ${Split_Reference_Length}    ${Row_Item}    ${Reference_Dictionary}
    
    ${Value_Dictionary}    Create Dictionary
    
    :FOR    ${i}    IN RANGE    0    ${Split_Reference_Length}
    \    ${temp_index}    Get From Dictionary    ${Reference_Dictionary}    Reference_Index${i}
    \    ${temp_value}    Get From List    ${Row_Item}    ${temp_index}
    \    Set To Dictionary    ${Value_Dictionary}    Value${i}=${temp_value}
    
    [Return]    ${Value_Dictionary}

Validate BSG_CDE_BRANCH in LIQ for VLS_Bal_Subledger
    [Documentation]    This keyword validates BSG_CDE_BRANCH in LIQ for VLS_Bal_Subledger
    ...    @author: ehugo    30AUG2019
    [Arguments]    ${sBal_Subledger_CSV_Filename}    ${sBranch_CSV_Filename}
    
    ${CSV_Content}    Read Csv File To List    ${sBal_Subledger_CSV_Filename}    |
    ${Record_Count}    Get Length    ${CSV_Content}
    
    ${BSG_CDE_BRANCH_Index}    Get the Column index of the Header    ${sBal_Subledger_CSV_Filename}    BSG_CDE_BRANCH    
    
    ###Navigate to Actions -> Table Maintenance###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Branch
    
	${BranchCode_List}    Create List
    
    :FOR    ${i}    IN RANGE    1    ${Record_Count}
    \    ${BSG_CDE_BRANCH_Value}    Get the Column Value using Row Number and Column Index    ${sBal_Subledger_CSV_Filename}    ${i}    ${BSG_CDE_BRANCH_Index}   
	\	 ${count}    Get Match Count    ${BranchCode_List}    ${BSG_CDE_BRANCH_Value.strip()}
    \    Run Keyword If    ${count}==0    Append To List    ${BranchCode_List}    ${BSG_CDE_BRANCH_Value.strip()}
    \    Continue For Loop If    ${count}>0   
    \    ${Dictionary}    Get Reference Column Value using Source Column Value - Multi Reference    ${sBranch_CSV_Filename}    BRN_CDE_BRANCH    ${BSG_CDE_BRANCH_Value.strip()}    BRN_DSC_BRANCH|BRN_CDE_BANK
    \    ${Description}    Get From Dictionary    ${Dictionary}    Value0
    \    ${Bank}    Get From Dictionary    ${Dictionary}    Value1
    \
    \    ###Search for the Branch###
    \    mx LoanIQ activate window    ${LIQ_Branch_Window}
    \    ${Branch_List}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_Branch_Tree}    Branch_List    Processtimeout=180
    \    ${Branch_IsExist}    Run Keyword And Return Status    Should Contain    ${Branch_List}    ${BSG_CDE_BRANCH_Value.strip()}    
    \    Run Keyword If    ${Branch_IsExist}==False    FAIL    ${BSG_CDE_BRANCH_Value.strip()} is not displayed in LIQ.
         ...    ELSE    Log    ${BSG_CDE_BRANCH_Value.strip()} is displayed in LIQ.
    \
    \    Mx LoanIQ Select String    ${LIQ_Branch_Tree}    ${BSG_CDE_BRANCH_Value.strip()}\t${Bank.strip()}\t${Description.strip()}
    \    Mx Press Combination    KEY.ENTER
    \    Mx LoanIQ Click Button On Window    .*Branch.*;Informational Message.*;OK        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    \    
    \    ###Branch Update Window###
    \    mx LoanIQ activate window    ${LIQ_Branch_Update_Window}
    \    ${Code}    Mx LoanIQ Get Data    ${LIQ_Branch_Update_Code_Field}    Code    
    \    Log    Expected: ${BSG_CDE_BRANCH_Value.strip()}
    \    Log    Actual: ${Code}
    \    ${Verify_Equal}    Run Keyword And Return Status    Should Be Equal As Strings    ${BSG_CDE_BRANCH_Value.strip()}    ${Code.strip()}    
    \    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Branch
    \    Run Keyword If    ${Verify_Equal}==False    Run Keyword And Continue On Failure    FAIL    Incorrect Branch value '${Code}' is displayed in LIQ.
         ...    ELSE    Log    Correct Branch value '${Code}' is displayed in LIQ.
    \    
    \    mx LoanIQ close window    ${LIQ_Branch_Update_Window}
    
    Close All Windows on LIQ

Validate BSG_CDE_EXPENSE in LIQ for VLS_Bal_Subledger
    [Documentation]    This keyword validates BSG_CDE_EXPENSE in LIQ for VLS_Bal_Subledger
    ...    @author: ehugo    30AUG2019
    [Arguments]    ${sBal_Subledger_CSV_Filename}    ${sExpense_CSV_Filename}
    
    ${CSV_Content}    Read Csv File To List    ${sBal_Subledger_CSV_Filename}    |
    ${Record_Count}    Get Length    ${CSV_Content}
    
    ${BSG_CDE_EXPENSE_Index}    Get the Column index of the Header    ${sBal_Subledger_CSV_Filename}    BSG_CDE_EXPENSE    
    
    ###Navigate to Actions -> Table Maintenance###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Expense
    
	${ExpenseCode_List}    Create List
	
    :FOR    ${i}    IN RANGE    1    ${Record_Count}
    \    ${BSG_CDE_EXPENSE_Value}    Get the Column Value using Row Number and Column Index    ${sBal_Subledger_CSV_Filename}    ${i}    ${BSG_CDE_EXPENSE_Index}   
	\	 ${count}    Get Match Count    ${ExpenseCode_List}    ${BSG_CDE_EXPENSE_Value.strip()}
    \    Run Keyword If    ${count}==0    Append To List    ${ExpenseCode_List}    ${BSG_CDE_EXPENSE_Value.strip()}
    \    Continue For Loop If    ${count}>0   
    \    ${Dictionary}    Get Reference Column Value using Source Column Value - Multi Reference    ${sExpense_CSV_Filename}    EXP_CDE_EXPENSE    ${BSG_CDE_EXPENSE_Value.strip()}    EXP_DSC_EXPENSE|EXP_CDE_PARENT|EXP_CDE_EXP_RECAP
    \    ${Description}    Get From Dictionary    ${Dictionary}    Value0
    \    ${Parent}    Get From Dictionary    ${Dictionary}    Value1
    \    ${Recap}    Get From Dictionary    ${Dictionary}    Value2
    \
    \    ###Search for the Expense###
    \    mx LoanIQ activate window    ${LIQ_Expense_Window}
    \    ${Expense_List}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_Expense_JavaTree}    Expense_List    Processtimeout=180
    \    ${Expense_IsExist}    Run Keyword And Return Status    Should Contain    ${Expense_List}    ${BSG_CDE_EXPENSE_Value.strip()}    
    \    Run Keyword If    ${Expense_IsExist}==False    FAIL    ${BSG_CDE_EXPENSE_Value.strip()} is not displayed in LIQ.
         ...    ELSE    Log    ${BSG_CDE_EXPENSE_Value.strip()} is displayed in LIQ.
    \
    \    Mx LoanIQ Select String    ${LIQ_Expense_JavaTree}    ${BSG_CDE_EXPENSE_Value.strip()}\t${Parent.strip()}\t${Recap.strip()}\t${Description.strip()}
    \    Mx Press Combination    KEY.ENTER
    \
    \    Run Keyword And Ignore Error    Mx LoanIQ Click Button On Window    .*Expense.*;Warning.*;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    \
    \    ###Expense Update Window###
    \    mx LoanIQ activate window    ${LIQ_Expense_Update_Window}
    \    ${Code}    Mx LoanIQ Get Data    ${LIQ_Expense_Update_Code_Field}    Code    
    \    Log    Expected: ${BSG_CDE_EXPENSE_Value.strip()}
    \    Log    Actual: ${Code}
    \    ${Verify_Equal}    Run Keyword And Return Status    Should Be Equal As Strings    ${BSG_CDE_EXPENSE_Value.strip()}    ${Code.strip()}    
    \    
    \    Run Keyword If    ${Verify_Equal}==False    Run Keyword And Continue On Failure    FAIL    Incorrect Expense value '${Code}' is displayed in LIQ.
         ...    ELSE    Log    Correct Expense value '${Code}' is displayed in LIQ.
    \    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Expense
    \    mx LoanIQ close window    ${LIQ_Expense_Update_Window}
    
    Close All Windows on LIQ

Validate BSG_CDE_PORTFOLIO in LIQ for VLS_Bal_Subledger
    [Documentation]    This keyword validates BSG_CDE_PORTFOLIO in LIQ for VLS_Bal_Subledger
    ...    @author: ehugo    30AUG2019    - initial create
    ...    @update: mgaling    14OCT2020    - created a separate keyword for Portfolio Update Window validation
    [Arguments]    ${sBal_Subledger_CSV_Filename}    ${sPortfolio_CSV_Filename}
    
    ${CSV_Content}    Read Csv File To List    ${sBal_Subledger_CSV_Filename}    |
    ${Record_Count}    Get Length    ${CSV_Content}
    
    ${BSG_CDE_PORTFOLIO_Index}    Get the Column index of the Header    ${sBal_Subledger_CSV_Filename}    BSG_CDE_PORTFOLIO    
    
    ###Navigate to Actions -> Table Maintenance###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Portfolio
    
	${PortfolioCode_List}    Create List
	
    :FOR    ${i}    IN RANGE    1    ${Record_Count}
    \    ${BSG_CDE_PORTFOLIO_Value}    Get the Column Value using Row Number and Column Index    ${sBal_Subledger_CSV_Filename}    ${i}    ${BSG_CDE_PORTFOLIO_Index}   
	\	 ${count}    Get Match Count    ${PortfolioCode_List}    ${BSG_CDE_PORTFOLIO_Value.strip()}
    \    Run Keyword If    ${count}==0    Append To List    ${PortfolioCode_List}    ${BSG_CDE_PORTFOLIO_Value.strip()}
    \    Continue For Loop If    ${count}>0   
    \    ${Description}    Get Reference Column Value using Source Column Value - Single Reference    ${sPortfolio_CSV_Filename}    PTF_CDE_PORTFOLIO    ${BSG_CDE_PORTFOLIO_Value.strip()}    PTF_DSC_PORTFOLIO
    \
    \    Run Keyword if    '${BSG_CDE_PORTFOLIO_Value.strip()}'!='${EMPTY}' and '${BSG_CDE_PORTFOLIO_Value.strip()}'!='NONE'    Run Keyword And Continue On Failure    Validate BSG_CDE_PORTFOLIO_Value in Portfolio Update Window    ${BSG_CDE_PORTFOLIO_Value.strip()}    ${Description.strip()}
	
	Close All Windows on LIQ
    
Validate RPE_CDE_RISK_BOOK records exist in LIQ for VLS_RISK_PORT_EXP
    [Documentation]    This keyword validates RPE_CDE_RISK_BOOK records exist in LIQ for VLS_RISK_PORT_EXP
    ...    @author: ehugo    30AUG2019    - initial create
    ...    @update: mgaling    23OCT2020    - updated arguments and variable
    [Arguments]    ${aRiskPortExp_CSV_Content}    
    
    ###Navigate to Actions -> Table Maintenance###
    mx LoanIQ activate window    ${LIQ_Window}
    Select Actions    [Actions];Table Maintenance
    
    ###Table Maintenance Window###
    Search in Table Maintenance    Risk Book
    
    ###Browse data from Risk Book Window###
    mx LoanIQ activate window    ${LIQ_BrowseRiskBook_Window}
    ${Codes_List}    Get Risk Book List of Code
    
    ###Validate Records exist in LIQ###
    Validate Records for RPE_CDE_RISK_BOOK exist in LIQ    ${aRiskPortExp_CSV_Content}    ${Codes_List}

Get Distinct Column Data 
    [Documentation]    This keyword is used to get distinct data of a certain column.
    ...    @author: mgaling    29Aug2019
    [Arguments]    ${aCSV_Content}    ${sCSV_FileName}    ${sHeader_Name}
    
    ${Row_Count}    Get Length    ${aCSV_Content}  
    ${Header_Index}    Get the Column index of the Header    ${sCSV_FileName}    ${sHeader_Name}
    
    ${Column_Records}    Create List
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${aCSV_Content}    ${i}
    \    ${Table_Row_Value}    Get From List    ${Table_Row_Item}    ${Header_Index}
    \    Append To List     ${Column_Records}    ${Table_Row_Value.strip()}
    
    ${DistinctData_List}    Remove Duplicates    ${Column_Records}        
    Log    ${DistinctData_List}  
    
    [Return]    ${DistinctData_List}   
    
Validate Fee Type Data from CSV in LIQ Screen
    [Documentation]    This keyword is used to validate GLE_CDE_FEE_TYPE data from VLS_GL_ENTRY extract to LIQ screen.
    ...    @author: mgaling    30Aug2019
    [Arguments]    ${aDistinctData_List}    
     
    ### Navigate to Pricing Fee Type Window ###
    Select Actions    [Actions];Table Maintenance
    
    ${count}    Get Length    ${aDistinctData_List}
    :FOR    ${INDEX}    IN RANGE    ${count}
    \    ${RowValue}    Set Variable    @{aDistinctData_List}[${INDEX}]   
    \    Run Keyword If    "${RowValue.strip()}" != "ADMI" and "${RowValue.strip()}" != "${EMPTY}"    Run Keyword And Continue On Failure    Validate the Pricing Fee Type Code in LIQ    ${RowValue.strip()} 
    \    Run Keyword If    "${RowValue.strip()}" != "ADMI" and "${RowValue.strip()}" != "${EMPTY}"    Log    ${RowValue} is a Pricing Fee Type       
    \    Run Keyword If    "${RowValue.strip()}" == "ADMI" and "${RowValue.strip()}" != "${EMPTY}"    Run Keyword And Continue On Failure    Validate the Pricing Fee Category Code in LIQ    ${RowValue.strip()}
    \    Run Keyword If    "${RowValue.strip()}" == "ADMI" and "${RowValue.strip()}" != "${EMPTY}"   Log    ${RowValue} is a Pricing Fee Category   
    
    Close All Windows on LIQ   
    
Validate Facility Type Data from CSV in LIQ Screen
    [Documentation]    This keyword is used to validate FAT_CDE_FAC_TYPE data from VLS_FACILITY_TYPE extract to LIQ screen.
    ...    @author: mgaling    02Sep2019
    [Arguments]    ${aDistinctData_List}    
     
    ### Navigate to Pricing Fee Type Window ###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Facility Type
    
    ### Facility Type Code Validation ###
    mx LoanIQ activate window    ${LIQ_BrowseFacilityType_Window}
    mx LoanIQ enter    ${LIQ_BrowseFacilityType_ShowAll_RadioButton}    ON
    
    ${count}    Get Length    ${aDistinctData_List}
    :FOR    ${INDEX}    IN RANGE    ${count}
    \    ${RowValue}    Set Variable    @{aDistinctData_List}[${INDEX}]   
    \    Validate the Facility Type Code in LIQ    ${RowValue.strip()}    
    
    Close All Windows on LIQ
    
Validate Portfolio Code Data from CSV in LIQ Screen
    [Documentation]    This keyword is used to validate FPP_CDE_PORTFOLIO data from  VLS_FAC_PORT_POS extract to LIQ screen.
    ...    @author: mgaling    03SEP2019    - initial create
	...    @update: mgaling    14OCT2020    - added keywords for reading and getting data from CSV file
	...										- updated the loop function
    [Arguments]    ${sVLS_FAC_PORT_POS_CSVFileName}    
	
	### Get Distinct data in FPP_CDE_PORTFOLIO column from VLS_FAC_PORT_POS extract ###
	${CSV_Content}    Read Csv File To List    ${sVLS_FAC_PORT_POS_CSVFileName}    |
    Log List    ${CSV_Content}
    
	${DistinctData_List}    Get Distinct Column Data    ${CSV_Content}    ${sVLS_FAC_PORT_POS_CSVFileName}    FPP_CDE_PORTFOLIO
    Log    ${DistinctData_List}
	
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Portfolio
    
    ### Portfolio Window Validation ###
    mx LoanIQ activate window    ${LIQ_Portfolio_Window}
    
    ${count}    Get Length    ${DistinctData_List}
    :FOR    ${INDEX}    IN RANGE    ${count}
    \    ${RowValue}    Set Variable    @{DistinctData_List}[${INDEX}]   
    \    Run Keyword If    '${RowValue.strip()}'!='NONE' and '${RowValue.strip()}'!='${EMPTY}'    Run Keyword and Continue on Failure    Validate the Porfolio Codes in LIQ    ${RowValue.strip()}
         ...    ELSE    Log    ${RowValue} is empty.            
    
    Close All Windows on LIQ
    
Get Row Data 
    [Documentation]    This keyword is used to get the row data for a certain column.
    ...    @author: mgaling    29Aug2019    Initial Create
    [Arguments]    ${aCSV_Content}    ${sColumn}    ${Row_No}    
             
    ### Get Details from CSV ###
    ${Column_Header}    Get From List    ${aCSV_Content}    0
    
    ${ColumnHeader_Index}    Get Index From List    ${Column_Header}    ${sColumn}
    Log    ${ColumnHeader_Index}
    
    ${Row_Item}    Get From List    ${aCSV_Content}    ${Row_No}
    ${Column_RowValue}    Get From List    ${Row_Item}    ${ColumnHeader_Index}    
    Log    ${Column_RowValue}
    
    [Return]    ${Column_RowValue}
    
Validate FPP_CDE_PORTFOLIO in LIQ Facility Portfolio Allocation
    [Documentation]    This keyword is used to validate FPP_CDE_PORTFOLIO data from  VLS_FAC_PORT_POS extract to LIQ Transaction - Facility Portfolio Allocation Window.
    ...    @author: mgaling    03SEP2019    - initial create
    ...    @update: mgaling    15OCT2020    - added loop function to validate all data from extract file
    ...                                     - created separate keyword for Facility Notebook validation
    [Arguments]    ${sCSV_FileName}
    
    ${CSV_Content}    Read Csv File To List    ${sCSV_FileName}    |
    ${Record_Count}    Get Length    ${CSV_Content}
    
    ${FPP_CDE_PORTFOLIO_Index}    Get the Column index of the Header    ${sCSV_FileName}    FPP_CDE_PORTFOLIO    
    ${FPP_PID_FACILITY_Index}    Get the Column index of the Header    ${sCSV_FileName}    FPP_PID_FACILITY
    ${FPP_CDE_BRANCH_Index}    Get the Column index of the Header    ${sCSV_FileName}    FPP_CDE_BRANCH

    :FOR    ${i}    IN RANGE    1    ${Record_Count}
    \    ${FPP_CDE_PORTFOLIO_Value}    Get the Column Value using Row Number and Column Index    ${sCSV_FileName}    ${i}    ${FPP_CDE_PORTFOLIO_Index}
    \    ${FPP_PID_FACILITY_Value}    Get the Column Value using Row Number and Column Index    ${sCSV_FileName}    ${i}    ${FPP_PID_FACILITY_Index}
    \    ${FPP_CDE_BRANCH_Value}    Get the Column Value using Row Number and Column Index    ${sCSV_FileName}    ${i}    ${FPP_CDE_BRANCH_Index}
    \
    \    ### Navigate to Portfolio Window ###
    \    Run Keyword If    '${FPP_CDE_PORTFOLIO_Value.strip()}'!='NONE' and '${FPP_CDE_PORTFOLIO_Value.strip()}'!='${EMPTY}'    Run Keywords    Select Actions    [Actions];Table Maintenance    
         ...    AND    Search in Table Maintenance    Portfolio
         ...    ELSE    Log    ${FPP_CDE_PORTFOLIO_Value} is empty.
    \    ${Row_Desc}    Run Keyword If    '${FPP_CDE_PORTFOLIO_Value.strip()}'!='NONE' and '${FPP_CDE_PORTFOLIO_Value.strip()}'!='${EMPTY}'    Run Keyword And Continue On Failure    Validate the Porfolio Codes in LIQ    ${FPP_CDE_PORTFOLIO_Value.strip()}
         ...    ELSE    Log    ${FPP_CDE_PORTFOLIO_Value} is empty.  
    \    ### Branch Customer Value ###
    \    ${Branch_Customer}    Run Keyword If    '${FPP_CDE_BRANCH_Value.strip()}'=='${BRANCH_CB001}'    Set Variable    ${BRANCH_CB001_Customer} 
         ...    ELSE IF    '${FPP_CDE_BRANCH_Value.strip()}'=='${BRANCH_CB022}'    Set Variable    ${BRANCH_CB022_Customer}
         ...    ELSE IF    '${FPP_CDE_BRANCH_Value.strip()}=="${BRANCH_CG852}'    Set Variable    ${BRANCH_CG852_Customer}
         ...    ELSE    Log    ${FPP_CDE_BRANCH_Value} is new and not yet configured.    
    \  
    \    Close All Windows on LIQ
    \    Run Keyword If    '${FPP_CDE_PORTFOLIO_Value.strip()}'!='NONE' and '${FPP_CDE_PORTFOLIO_Value.strip()}'!='${EMPTY}'    Run Keyword And Continue On Failure    Validate FPP_CDE_PORTFOLIO Value in LIQ    ${FPP_PID_FACILITY_Value}    ${Row_Desc}
         ...    ${Branch_Customer}    ${FPP_CDE_PORTFOLIO_Value.strip()}    ${FPP_CDE_BRANCH_Value.strip()}
         ...    ELSE    Log    ${FPP_CDE_PORTFOLIO_Value} is empty.    

Validate FPP_CDE_PORTFOLIO Value in LIQ
    [Documentation]    This keyword is used to navigate Host Bank Circle Notebook and validate FPP_CDE_PORTFOLIO value in Portfolio Allocation Window.
    ...    @author: mgaling    15OCT2020    - initial create
    [Arguments]    ${sFPP_PID_FACILITY_Value}    ${sRow_Desc}    ${sBranch_Customer}    ${sFPP_CDE_PORTFOLIO_Value}    ${sFPP_CDE_BRANCH_Value}
   
    ### Launch Facility Notebook and Get the Facility Name ### 
    Navigate to Notebook Window thru RID    Facility    ${sFPP_PID_FACILITY_Value}
    
    :FOR    ${i}    IN RANGE    15
    \    ${AlertsWindow_isDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_Alerts_Window}         VerificationData="Yes"
    \    Run Keyword If     ${AlertsWindow_isDisplayed}==${True}    Run Keywords
         ...    mx LoanIQ activate window    ${LIQ_Facility_Alerts_Window}
         ...    AND    mx LoanIQ click    ${LIQ_Facility_Alerts_Cancel_Button}
         ...    AND    Mx Activate Window    ${LIQ_FacilityNotebook_Window}
    \    Exit For Loop If    ${AlertsWindow_isDisplayed}==${True}
    
    Mx Activate Window    ${LIQ_FacilityNotebook_Window}
    ${FacilityName}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_FacilityName_Text}    attached text%Facility Name       
    
    ### Navigate to Host Bank Circle Notebook ###
    Mx LoanIQ Select    ${LIQ_FacilityNotebook_Options_DealNotebook}


    :FOR    ${i}    IN RANGE    15
    \    ${AlertsWindow_isDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_Alerts_Window}         VerificationData="Yes"
    \    Run Keyword If     ${AlertsWindow_isDisplayed}==${True}    Run Keywords
         ...    mx LoanIQ activate window    ${LIQ_Facility_Alerts_Window}
         ...    AND    mx LoanIQ click    ${LIQ_Facility_Alerts_Cancel_Button}
         ...    AND    Mx Activate Window    ${LIQ_DealNotebook_Window}
    \    Exit For Loop If    ${AlertsWindow_isDisplayed}==${True}
    
    Mx Activate Window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select    ${LIQ_DealNotebook_DistributionPrimaries_Menu}

    Mx Close    ${LIQ_FacilityNotebook_Window}
    Mx Activate Window    ${LIQ_PrimariesList_Window}
    Mx LoanIQ DoubleClick    ${LIQ_PrimariesList_JavaTree}    ${sBranch_Customer}
    Mx Click    ${LIQ_CircleNotebook_InquiryMode_Button}
    Mx LoanIQ Select String    ${LIQ_Circle_Amounts_JavaTree}    ${FacilityName}
    Mx Click    ${LIQ_Circle_PortfolioAllocations_Button}   
    
    ### Portfolio allocation Window ###   
    mx LoanIQ activate window    ${LIQ_Cirlce_PortfolioAllocation_Window}
   
    ${status}    Run Keyword And Return Status     Mx LoanIQ Verify Text In Javatree    ${LIQ_PortfolioAllocation_PortfolioExpense_JavaTree}    ${sFPP_CDE_BRANCH_Value}/${sRow_Desc}
    Run Keyword If    ${status}==${True}    Log    ${sFPP_CDE_PORTFOLIO_Value}-${sRow_Desc} is available
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sRow_Desc} is not available  
    
    Take Screenshot     ${screenshot_path}/Screenshots/DWE/${sFPP_CDE_PORTFOLIO_Value}                      
    mx LoanIQ click    ${LIQ_PortfolioAllocation_Exit_Button}
    
    Close All Windows on LIQ
                
Validate GB2_TID_TABLE_ID in LIQ for VLS_FAM_GLOBAL2
    [Documentation]    This keyword validates GB2_TID_TABLE_ID in LIQ for VLS_FAM_GLOBAL2
    ...    @author: ehugo    09SEP2019
    [Arguments]    ${aDistinct_List}    
    
    ###Navigate to Actions -> Table Maintenance###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Code Tables
    
    ${Distinct_List_Count}    Get Length    ${aDistinct_List}
    
    :FOR    ${i}    IN RANGE    0    ${Distinct_List_Count}
         ###Search for the Code###
    \    mx LoanIQ activate window    ${LIQ_BrowseCodeTables_Window}
    \    ${Current_Code}    Set Variable    ${aDistinct_List}[${i}]
    \    ${Code_List}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_BrowseCodeTables_JavaTree}    Code_List    Processtimeout=180
    \    ${Code_IsExist}    Run Keyword And Return Status    Should Contain    ${Code_List}    \t${Current_Code.strip()}\t    
    \    Run Keyword If    ${Code_IsExist}==${False}    Run Keyword And Ignore Error    FAIL    ${Current_Code.strip()} is not displayed in LIQ.
         ...    ELSE    Validate Code Tables in LIQ    ${Current_Code}
    
    Close All Windows on LIQ

Navigate to Notebook Window thru RID
    [Documentation]    This keyword is used to navigate a certain window thru RID.
    ...    @author: mgaling    05SEP2019    - initial create
    ...    @update: mgaling    15OCT2020    - added screenshot path
    ...    @update: mgaling    26OCT2020    - added screenshot path for LIQ Error
    [Arguments]    ${sDataObject_Value}    ${sRID_Value}    
    
    ### Navigate to Options -> RID Select ###
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    mx LoanIQ activate window    ${LIQ_Window}    
    mx LoanIQ select    ${LIQ_Options_RIDSelect}
    
    ### Select by RID window ###
    mx LoanIQ activate window    ${LIQ_SelectByRID_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_SelectByRID_DataObject_Field}    ${sDataObject_Value}    
    mx LoanIQ enter    ${LIQ_SelectByRID_RID_Field}    ${sRID_Value}
    Take Screenshot     ${screenshot_path}/Screenshots/DWE/RID Code Validation        
    mx LoanIQ click    ${LIQ_SelectByRID_OK_Button}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Error_Window}            VerificationData="Yes"
    Run Keyword If    ${status}==${False}    Log    RID Code ${sRID_Value} is Available in LIQ.
    ...    ELSE    Run Keywords    Run Keyword And Continue On Failure    FAIL    RID Code ${sRID_Value} is not Available.
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Error_Window
    ...    AND    mx LoanIQ click    ${LIQ_Error_OK_Button}    
    ...    AND    Close All Windows on LIQ                    
    
Get the Accrual Cycle Details from CSV Extract
    [Documentation]    This keyword is used to get the Accrual Cycle Item details (ACC_RID_OWNER,ACC_DTE_CYCLE_STRT,ACC_DTE_END and ACC_AMT_ACR_PAID) from CSV Extract
    ...    @author: mgaling    05Sep2019    Initial Create
    [Arguments]    ${sCSV_FileName}    ${sColumn_Name}    ${CSV_Content}    ${OST_RID_OUTSTANDNG_Value}            
    
     ${ACC_RID_OWNER_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_RID_OWNER
     ${ACC_DTE_CYCLE_STRT_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_DTE_CYCLE_STRT    
     ${ACC_DTE_CYCLE_END_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_DTE_CYCLE_END
     ${Column_Index}    Get the Column index of the Header    ${sCSV_FileName}    ${sColumn_Name}
    
     
    ${count}	Get Length    ${CSV_Content}
    :FOR    ${Index}    IN RANGE    1    ${count}
    \    ${Table_NameList}    Set Variable    @{CSV_Content}[${INDEX}]
    \    Log    ${Table_NameList}    
    \    ${ACC_RID_OWNER_Value}    Remove String    @{Table_NameList}[${ACC_RID_OWNER_Index}]    "
    \    
    \    ${ACC_DTE_CYCLE_STRT_Value}    Remove String    @{Table_NameList}[${ACC_DTE_CYCLE_STRT_Index}]    "
    \    ${ACC_DTE_CYCLE_STRT_Value}    Convert Date Without Zero    ${ACC_DTE_CYCLE_STRT_Value}
    \    
    \    ${ACC_DTE_CYCLE_END_Value}    Remove String    @{Table_NameList}[${ACC_DTE_CYCLE_END_Index}]    "
    \    ${ACC_DTE_CYCLE_END_Value}    Convert Date Without Zero    ${ACC_DTE_CYCLE_END_Value}    
    \    
    \    ${Column__Value}    Remove String    @{Table_NameList}[${Column_Index}]    "  
    \                      
    \    Exit For Loop If    "${ACC_RID_OWNER_Value.strip()}"=="${OST_RID_OUTSTANDNG_Value.strip()}"  
    [Return]    ${ACC_RID_OWNER_Value}    ${ACC_DTE_CYCLE_STRT_Value}    ${ACC_DTE_CYCLE_END_Value}    ${Column_Value} 
    
Validate Loans in VLS_ACCRUAL_CYCLE Table
    [Documentation]    This keyword is used to validate the loans from VLS_OUTSTANDING table in VLS_Accrual Cycle Table
    ...    @author: mgaling    09Sep2019    Initial Create
    [Arguments]    ${Result}
        
    ${Result_isEmpty}    Run Keyword And Return Status    Should Be Empty    ${Result}
    
    Run Keyword If    ${Result_isEmpty}==True    Log    No Orphan Records.
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    Record count is not equal to 0. Current record count is ${Result}. Source Table has orphan records.

Validate Accrual Cycles from CSV and LIQ Screen
    [Documentation]    This keyword is used to validate the accrual cycles from CSV to LIQ Screen - Accrual Tab
    ...    @author: mgaling    09Sep2019    Initial Create
    [Arguments]    ${aResult}    ${sCSV_FileName}    ${aCSV_Content}        
      
    ${count}	Get Length    ${aResult}
   
    :FOR    ${i}    IN RANGE    ${count}        
    \    ${Records_Row_Value}    Get From List    ${aResult}    ${i}
    \    ${Records_Row_Value}    Convert To String    ${Records_Row_Value}
    \    ${Records_Row_Value}=    Remove String    ${Records_Row_Value}    [    (    '     ,    '    )    ]
    \    ${ACC_RID_OWNER_Value}    ${ACC_DTE_CYCLE_STRT_Value}    ${ACC_DTE_CYCLE_END_Value}    ${ACC_DTE_CYCLE_DUE_Value}    ${ACC_AMT_ACR_PAID_Value}    ${ACC_AMT_ACCRUAL_Value}    ${ACC_AMT_PROJ_EOC_Value}    Get the Accrual Cycle Fields Value from CSV Extract    ${sCSV_FileName}    ${aCSV_Content}    ${Records_Row_Value}         
    \    Navigate to Notebook Window thru RID    Outstanding    ${Records_Row_Value}
    \    Validate Accrual Fields from Extract in LIQ Accrual Tab    ${ACC_DTE_CYCLE_STRT_Value}    ${ACC_DTE_CYCLE_END_Value}    ${ACC_DTE_CYCLE_DUE_Value}    ${ACC_AMT_ACR_PAID_Value}    ${ACC_AMT_ACCRUAL_Value}    ${ACC_AMT_PROJ_EOC_Value}

Get the Accrual Cycle Fields Value from CSV Extract
    [Documentation]    This keyword is used to get the Accrual Cycle Item details (ACC_RID_OWNER,ACC_DTE_CYCLE_STRT,ACC_DTE_END, ACC_AMT_ACR_PAID, ACC_DTE_CYCLE_DUE, ACC_AMT_ACCRUAL, ACC_AMT_PROJ_EOC) from CSV Extract
    ...    @author: mgaling    05Sep2019    Initial Create
    [Arguments]    ${sCSV_FileName}    ${CSV_Content}    ${OST_RID_OUTSTANDNG_Value}            
    
     ${ACC_RID_OWNER_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_RID_OWNER
     ${ACC_DTE_CYCLE_STRT_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_DTE_CYCLE_STRT    
     ${ACC_DTE_CYCLE_END_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_DTE_CYCLE_END
     ${ACC_DTE_CYCLE_DUE_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_DTE_CYCLE_DUE
     ${ACC_AMT_ACCRUAL_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_AMT_ACCRUAL
     ${ACC_AMT_PROJ_EOC_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_AMT_PROJ_EOC
     ${ACC_AMT_ACR_PAID_Index}    Get the Column index of the Header    ${sCSV_FileName}    ACC_AMT_ACR_PAID
    
    ${count}	Get Length    ${CSV_Content}
    :FOR    ${Index}    IN RANGE    1    ${count}
    \    ${Table_NameList}    Set Variable    @{CSV_Content}[${INDEX}]
    \    Log    ${Table_NameList}   
    \     
    \    ${ACC_RID_OWNER_Value}    Remove String    @{Table_NameList}[${ACC_RID_OWNER_Index}]    "
    \    
    \    ${ACC_DTE_CYCLE_STRT_Value}    Remove String    @{Table_NameList}[${ACC_DTE_CYCLE_STRT_Index}]    "
    \    ${ACC_DTE_CYCLE_STRT_Value}    Convert Date Without Zero    ${ACC_DTE_CYCLE_STRT_Value}
    \    
    \    ${ACC_DTE_CYCLE_END_Value}    Remove String    @{Table_NameList}[${ACC_DTE_CYCLE_END_Index}]    "
    \    ${ACC_DTE_CYCLE_END_Value}    Convert Date Without Zero    ${ACC_DTE_CYCLE_END_Value}    
    \    
    \    ${ACC_DTE_CYCLE_DUE_Value}    Remove String    @{Table_NameList}[${ACC_DTE_CYCLE_DUE_Index}]    "
    \    ${ACC_DTE_CYCLE_DUE_Value}    Convert Date Without Zero    ${ACC_DTE_CYCLE_DUE_Value}   
    \    
    \    ${ACC_AMT_ACR_PAID_Value}    Remove String    @{Table_NameList}[${ACC_AMT_ACR_PAID_Index}]    "  
    \    ${ACC_AMT_ACCRUAL_Value}    Remove String    @{Table_NameList}[${ACC_AMT_ACCRUAL_Index}]    " 
    \    ${ACC_AMT_PROJ_EOC_Value}    Remove String    @{Table_NameList}[${ACC_AMT_PROJ_EOC_Index}]    " 
    \                     
    \    Exit For Loop If    "${ACC_RID_OWNER_Value.strip()}"=="${OST_RID_OUTSTANDNG_Value.strip()}"  
    [Return]    ${ACC_RID_OWNER_Value}    ${ACC_DTE_CYCLE_STRT_Value}    ${ACC_DTE_CYCLE_END_Value}    ${ACC_DTE_CYCLE_DUE_Value}    ${ACC_AMT_ACR_PAID_Value}    ${ACC_AMT_ACCRUAL_Value}    ${ACC_AMT_PROJ_EOC_Value}
    
Validate Accrual Fields from Extract in LIQ Accrual Tab
    [Documentation]    This keyword is used to validate Accrual Cycle values from CSV in LIQ Screen - Accrual Tab
    ...    @author: mgaling    06Sep2019    Initial Create
    [Arguments]    ${ACC_DTE_CYCLE_STRT_Value}    ${ACC_DTE_CYCLE_END_Value}    ${ACC_DTE_CYCLE_DUE_Value}    ${ACC_AMT_ACR_PAID_Value}    ${ACC_AMT_ACCRUAL_Value}    ${ACC_AMT_PROJ_EOC_Value}            
    
    ### Loan Notebook Window ###  
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_Pending_Window}    Processtimeout=180    VerificationData="Yes"
    Log    ${status}
    
    Run Keyword If    ${status}==${True}    Run Keywords    Log    Loan Notebook is in Pending Status
    ...    AND    mx LoanIQ activate window    ${LIQ_Loan_Pending_Window}    
    ...    AND    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Pending_Tab}    Accrual
    ...    AND    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_Pending_Accrual_JavaTree}            VerificationData="Yes"
    ...    AND    Take Screenshot    Accrual Tab
    ...    AND    Mx LoanIQ Select String    ${LIQ_Loan_Pending_Accrual_JavaTree}    ${ACC_DTE_CYCLE_STRT_Value}\t${ACC_DTE_CYCLE_END_Value}
    ...    AND    Mx Press Combination    KEY.ENTER
      
    Run Keyword If    ${status}==${False}    Run Keywords    Log    Loan Notebook is in Active Status
    ...    AND    mx LoanIQ activate window    ${LIQ_Loan_Window}   
    ...    AND    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ...    AND    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_AccrualTab_Cycles_Table}     VerificationData="Yes"
    ...    AND    Take Screenshot    Accrual Tab
    ...    AND    Mx LoanIQ Select String    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${ACC_DTE_CYCLE_STRT_Value}\t${ACC_DTE_CYCLE_END_Value}
    ...    AND    Mx Press Combination    KEY.ENTER 
    
    ### Accrual Cycle Detail Window Validation ###
    mx LoanIQ activate window    ${LIQ_AccrualCycleDetail_Window} 
    Take Screenshot    Accrual Cycle Details  
    
    ### ACC_DTE_CYCLE_DUE_Value Validation ###
    ${status}    Mx LoanIQ Verify Object Exist    ${LIQ_AccrualCycleDetail_Window}.JavaEdit("attached text:=${ACC_DTE_CYCLE_DUE_Value}")        VerificationData="Yes"
    Log    ${status} 
    
    Run Keyword If    ${status}==${True}    Log    ${ACC_DTE_CYCLE_DUE_Value} value under ACC_DTE_CYCLE_DUE field from Extract is reflected in LIQ Screen.
    ...    ELSE    Log    Fail    CSV ${ACC_DTE_CYCLE_DUE_Value} value is incorrect. 
    
    ### ACC_AMT_ACR_PAID_Value Validation ### 
    Validate the Amount Value in Accrual Cycle Detail    ${LIQ_AccrualCycleDetail_PaidToDate_Field}    ${ACC_AMT_ACR_PAID_Value}    ACC_AMT_ACR_PAID
    
    ### ACC_AMT_ACCRUAL_Value Validation ###
    Validate the Amount Value in Accrual Cycle Detail    ${LIQ_AccrualCycleDetail_AccruedToDate_Field}    ${ACC_AMT_ACCRUAL_Value}    ACC_AMT_ACCRUAL
    
    ### ACC_AMT_PROJ_EOC_Value Validation ###
    Validate the Amount Value in Accrual Cycle Detail    ${LIQ_AccrualCycleDetail_ProjectedEOCAccrual_Field}    ${ACC_AMT_PROJ_EOC_Value}    ACC_AMT_PROJ_EOC_Value 
    
    mx LoanIQ close window    ${LIQ_AccrualCycleDetail_Window}        
    Close All Windows on LIQ

Validate the Amount Value in Accrual Cycle Detail
    [Documentation]    This keyword is used to validate the actual and expected value in Accrual Cycle Detail Window 
    ...    @author: mgaling    10Sep2019    Initial Create
    [Arguments]    ${sLIQ_AccrualCycleDetail_Field}    ${iCSV_Value}    ${sCSV_Field}
    
    ${LIQAmount}    Mx LoanIQ Get Data    ${sLIQ_AccrualCycleDetail_Field}    text%value
    ${LIQAmount}    Remove String    ${LIQAmount}    ,    
    ${iLIQAmount}    Convert To Number    ${LIQAmount}   
    Log    ${iLIQAmount}  
    
    ${iCSV_Value}    Convert To Number    ${iCSV_Value}    
    ${status}    Run Keyword And Return Status    Should Be Equal    ${iCSV_Value}    ${iLIQAmount}
    Run Keyword If    ${status}==${True}    Log    ${iCSV_Value} value under ${sCSV_Field} field from Extract is reflected in LIQ Screen.
    ...    ELSE    Log    FAIL    CSV ${iCSV_Value} and LIQ Screen ${iLIQAmount} values are not matched. 

Get Column Records for VLS_OST_RATES
    [Documentation]    This keyword retrieves the unique values for ORT_RID_OUTSTANDNG. Then get the values for the following column: ORT_PCT_BASE_RATE, ORT_PCT_SPREAD, ORT_CDE_RATE_BASIS, ORT_PCT_BALI_RATE.
    ...    @author: ehugo    10SEP2019
    [Arguments]    ${sCSV_Filename}    
    
    ${CSV_Content}    Read Csv File To List    ${sCSV_Filename}    |
    
    ${Row_Count}    Get Length    ${CSV_Content}  
    ${Outstanding_Header}    Get the Column index of the Header    ${sCSV_Filename}    ORT_RID_OUTSTANDNG
    ${Base_Rate_Header}    Get the Column index of the Header    ${sCSV_Filename}    ORT_PCT_BASE_RATE
    ${Spread_Header}    Get the Column index of the Header    ${sCSV_Filename}    ORT_PCT_SPREAD
    ${Rate_Basis_Header}    Get the Column index of the Header    ${sCSV_Filename}    ORT_CDE_RATE_BASIS
    ${AllIn_Rate_Header}    Get the Column index of the Header    ${sCSV_Filename}    ORT_PCT_BALI_RATE
    
    ${Base_Rate_Dictionary}    Create Dictionary
    ${Spread_Dictionary}    Create Dictionary
    ${Rate_Basis_Dictionary}    Create Dictionary
    ${AllIn_Rate_Dictionary}    Create Dictionary
    
    ${Outstanding_List}    Create List
    
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${CSV_Content}    ${i}
    \    ${Outstanding_Value}    Get From List    ${Table_Row_Item}    ${Outstanding_Header}
    \    ${Base_Rate_Value}    Get From List    ${Table_Row_Item}    ${Base_Rate_Header}
    \    ${Spread_Value}    Get From List    ${Table_Row_Item}    ${Spread_Header}
    \    ${Rate_Basis_Value}    Get From List    ${Table_Row_Item}    ${Rate_Basis_Header}
    \    ${AllIn_Rate_Value}    Get From List    ${Table_Row_Item}    ${AllIn_Rate_Header}
    \    ${Count}    Get Match Count    ${Outstanding_List}    ${Outstanding_Value.strip()}    
    \    Run Keyword If    ${Count}==0    Append To List    ${Outstanding_List}    ${Outstanding_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Base_Rate_Dictionary}    ${Outstanding_Value.strip()}=${Base_Rate_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Spread_Dictionary}    ${Outstanding_Value.strip()}=${Spread_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Rate_Basis_Dictionary}    ${Outstanding_Value.strip()}=${Rate_Basis_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${AllIn_Rate_Dictionary}    ${Outstanding_Value.strip()}=${AllIn_Rate_Value.strip()}
    
    [Return]    ${Outstanding_List}    ${Base_Rate_Dictionary}    ${Spread_Dictionary}    ${Rate_Basis_Dictionary}    ${AllIn_Rate_Dictionary}
    
Validate ORT_PCT_BASE_RATE, ORT_PCT_SPREAD, ORT_CDE_RATE_BASIS, ORT_PCT_BALI_RATE in LIQ for VLS_OST_RATES
    [Documentation]    This keyword validates ORT_PCT_BASE_RATE, ORT_PCT_SPREAD, ORT_CDE_RATE_BASIS, ORT_PCT_BALI_RATE in LIQ for VLS_OST_RATES
    ...    @author: ehugo    10SEP2019
    [Arguments]    ${aOutstanding_List}    ${aBase_Rate_Dictionary}    ${aSpread_Dictionary}    ${aRate_Basis_Dictionary}    ${aAllIn_Rate_Dictionary}
    
    ${Row_Count}    Get Length    ${aOutstanding_List}    
    ${RateBasis_Description_Dictionary}    Create Dictionary
    ${RateBasis_Code_List}    Get Dictionary Values    ${aRate_Basis_Dictionary}
    ${RateBasis_Code_List}    Remove Duplicates    ${RateBasis_Code_List}
    ${RateBasis_Code_Count}    Get Length    ${RateBasis_Code_List}
    
    ###Navigate to Actions -> Table Maintenance###
    mx LoanIQ activate window    ${LIQ_Window}
    Select Actions    [Actions];Table Maintenance
    
    :FOR    ${i}    IN RANGE    0    ${RateBasis_Code_Count}
    \    Search in Table Maintenance    Rate Basis
    \    ${RateBasis_Description}    Get Single Description from Table Maintanance    ${RateBasis_Code_List}[${i}]    ${LIQ_BrowseRateBasis_Window}    ${LIQ_BrowseRateBasis_JavaTree}    ${LIQ_BrowseRateBasis_ShowAll_Button}    ${LIQ_BrowseRateBasis_Exit_Button}
    \    Set To Dictionary    ${RateBasis_Description_Dictionary}    ${RateBasis_Code_List}[${i}]=${RateBasis_Description}
    
    Close All Windows on LIQ
    
    :FOR    ${i}    IN RANGE    0    ${Row_Count}
    \    ###Select By RID###
    \    Select By RID    Outstanding    ${aOutstanding_List}[${i}]
    \    
    \    ###Loan Window###
    \    mx LoanIQ activate window    ${LIQ_Loan_AnyStatus_Window}
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Select Window Tab    ${LIQ_Loan_AnyStatus_Tab}    Rates
    \    Run Keyword If    ${status}==False    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    \    Run Keyword If    ${status}==False    Close All Windows on LIQ
    \    Continue For Loop If    ${status}==False
    \    
    \    ${Base_Rate_CSV_Value}    Get From Dictionary    ${aBase_Rate_Dictionary}    ${aOutstanding_List}[${i}]
    \    ${Base_Rate_LIQ_Value}    Mx LoanIQ Get Data    ${LIQ_Loan_AnyStatus_RatesTab_BaseRate_Field}    text%Base_Rate_LIQ_Value
    \    ${Base_Rate_LIQ_Value}    Convert Percentage to Decimal    ${Base_Rate_LIQ_Value.strip()}
    \    ${BaseRate_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${Base_Rate_CSV_Value.strip()}    ${Base_Rate_LIQ_Value.strip()}
    \    Run Keyword If    ${BaseRate_isEqual}==True    Log    ${Base_Rate_CSV_Value} CSV value is equal to ${Base_Rate_LIQ_Value} LIQ value.
    \    Run Keyword If    ${BaseRate_isEqual}==False    Run Keyword If    '${Base_Rate_CSV_Value}'=='${EMPTY}' or '${Base_Rate_CSV_Value}'==''    Log    Base Rate for ${aOutstanding_List}[${i}] is empty in CSV.
    \    Run Keyword If    ${BaseRate_isEqual}==False    Run Keyword If    '${Base_Rate_CSV_Value}'!='${EMPTY}' or '${Base_Rate_CSV_Value}'!=''    Run Keyword And Continue On Failure    Fail    ${Base_Rate_CSV_Value} CSV value is not equal to ${Base_Rate_LIQ_Value} LIQ value.
    \    
    \    ${Spread_CSV_Value}    Get From Dictionary    ${aSpread_Dictionary}    ${aOutstanding_List}[${i}]
    \    ${Spread_LIQ_Value}    Mx LoanIQ Get Data    ${LIQ_Loan_AnyStatus_RatesTab_Spread_Field}    text%Spread_LIQ_Value
    \    ${Spread_LIQ_Value}    Convert Percentage to Decimal    ${Spread_LIQ_Value.strip()}
    \    ${Spread_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${Spread_CSV_Value.strip()}    ${Spread_LIQ_Value.strip()}
    \    Run Keyword If    ${Spread_isEqual}==True    Log    ${Spread_CSV_Value} CSV value is equal to ${Spread_LIQ_Value} LIQ value.
    \    Run Keyword If    ${Spread_isEqual}==False    Run Keyword If    '${Spread_CSV_Value}'=='${EMPTY}' or '${Spread_CSV_Value}'==''    Log    Spread for ${aOutstanding_List}[${i}] is empty in CSV.
    \    Run Keyword If    ${Spread_isEqual}==False    Run Keyword If    '${Spread_CSV_Value}'!='${EMPTY}' or '${Spread_CSV_Value}'!=''    Run Keyword And Continue On Failure    Fail    ${Spread_CSV_Value} CSV value is not equal to ${Spread_LIQ_Value} LIQ value.
    \    
    \    ${Rate_Basis_CSV_Value}    Get From Dictionary    ${aRate_Basis_Dictionary}    ${aOutstanding_List}[${i}]
    \    ${Rate_Basis_CSV_Value}    Get From Dictionary    ${RateBasis_Description_Dictionary}    ${Rate_Basis_CSV_Value}
    \    ${Rate_Basis_LIQ_Value}    Mx LoanIQ Get Data    ${LIQ_Loan_AnyStatus_RateBasis_Dropdownlist}    text%Rate_Basis_LIQ_Value
    \    ${RateBasis_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${Rate_Basis_CSV_Value.strip()}    ${Rate_Basis_LIQ_Value.strip()}
    \    Run Keyword If    ${RateBasis_isEqual}==True    Log    ${Rate_Basis_CSV_Value} CSV value is equal to ${Rate_Basis_LIQ_Value} LIQ value.
    \    Run Keyword If    ${RateBasis_isEqual}==False    Run Keyword If    '${Rate_Basis_CSV_Value}'=='${EMPTY}' or '${Rate_Basis_CSV_Value}'==''    Log    Rate Basis for ${aOutstanding_List}[${i}] is empty in CSV.
    \    Run Keyword If    ${RateBasis_isEqual}==False    Run Keyword If    '${Rate_Basis_CSV_Value}'!='${EMPTY}' or '${Rate_Basis_CSV_Value}'!=''    Run Keyword And Continue On Failure    Fail    ${Rate_Basis_CSV_Value} CSV value is not equal to ${Rate_Basis_LIQ_Value} LIQ value.
    \    
    \    ${AllIn_Rate_CSV_Value}    Get From Dictionary    ${aAllIn_Rate_Dictionary}    ${aOutstanding_List}[${i}]
    \    ${AllIn_Rate_LIQ_Value}    Mx LoanIQ Get Data    ${LIQ_Loan_AnyStatus_AllInRate}    text%AllIn_Rate_LIQ_Value
    \    ${AllIn_Rate_LIQ_Value}    Convert Percentage to Decimal    ${AllIn_Rate_LIQ_Value.strip()}
    \    ${AllInRate_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${AllIn_Rate_CSV_Value.strip()}    ${AllIn_Rate_LIQ_Value.strip()}
    \    Run Keyword If    ${AllInRate_isEqual}==True    Log    ${AllIn_Rate_CSV_Value} CSV value is equal to ${AllIn_Rate_LIQ_Value} LIQ value.
    \    Run Keyword If    ${AllInRate_isEqual}==False    Run Keyword If    '${AllIn_Rate_CSV_Value}'=='${EMPTY}' or '${AllIn_Rate_CSV_Value}'==''    Log    AllIn Rate for ${aOutstanding_List}[${i}] is empty in CSV.
    \    Run Keyword If    ${AllInRate_isEqual}==False    Run Keyword If    '${AllIn_Rate_CSV_Value}'!='${EMPTY}' or '${AllIn_Rate_CSV_Value}'!=''    Run Keyword And Continue On Failure    Fail    ${AllIn_Rate_CSV_Value} CSV value is not equal to ${AllIn_Rate_LIQ_Value} LIQ value.
    \    
    \    Take Screenshot    Rates
    \    Mx LoanIQ Close    ${LIQ_Loan_AnyStatus_Window}
    
    Close All Windows on LIQ

Get Column Records for VLS_OST_TRAN
    [Documentation]    This keyword retrieves the unique values for OTR_RID_OST_TRAN. Then get the values for the following column: OTR_RID_OST_TRAN, OTR_RID_LINK_TRN, OTR_CDE_TYPE, OTR_AMT_ACTUAL
    ...    @author: ehugo    11SEP2019
    [Arguments]    ${sCSV_Filename}    
    
    ${CSV_Content}    Read Csv File To List    ${sCSV_Filename}    |
    
    ${Row_Count}    Get Length    ${CSV_Content}  
    ${Outstanding_Transaction_Header}    Get the Column index of the Header    ${sCSV_Filename}    OTR_RID_OST_TRAN
    ${Link_Transaction_Header}    Get the Column index of the Header    ${sCSV_Filename}    OTR_RID_LINK_TRN
    ${Transaction_Type_Header}    Get the Column index of the Header    ${sCSV_Filename}    OTR_CDE_TYPE
    ${Actual_Amount_Header}    Get the Column index of the Header    ${sCSV_Filename}    OTR_AMT_ACTUAL
    
    ${Transaction_Type_Dictionary}    Create Dictionary
    ${Actual_Amount_Dictionary}    Create Dictionary
    
    ${Link_Transaction_List}    Create List
    ${Outstanding_Transaction_List}    Create List
    
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${CSV_Content}    ${i}
    \    ${Outstanding_Transaction_Value}    Get From List    ${Table_Row_Item}    ${Outstanding_Transaction_Header}
    \    ${Link_Transaction_Value}    Get From List    ${Table_Row_Item}    ${Link_Transaction_Header}
    \    ${Transaction_Type_Value}    Get From List    ${Table_Row_Item}    ${Transaction_Type_Header}
    \    ${Actual_Amount_Value}    Get From List    ${Table_Row_Item}    ${Actual_Amount_Header}
    \    ${Count}    Get Match Count    ${Outstanding_Transaction_List}    ${Outstanding_Transaction_Value.strip()}    
    \    Run Keyword If    ${Count}==0    Append To List    ${Outstanding_Transaction_List}    ${Outstanding_Transaction_Value.strip()}
    \    Run Keyword If    ${Count}==0    Append To List    ${Link_Transaction_List}    ${Link_Transaction_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Transaction_Type_Dictionary}    ${Outstanding_Transaction_Value.strip()}=${Transaction_Type_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Actual_Amount_Dictionary}    ${Outstanding_Transaction_Value.strip()}=${Actual_Amount_Value.strip()}
    
    [Return]    ${Outstanding_Transaction_List}    ${Transaction_Type_Dictionary}    ${Actual_Amount_Dictionary}    ${Link_Transaction_List}
    
Validate OTR_AMT_ACTUAL in LIQ for VLS_OST_TRAN
    [Documentation]    This keyword validates OTR_AMT_ACTUAL in LIQ for VLS_OST_TRAN
    ...    @author: ehugo    11SEP2019
    [Arguments]    ${sExcelPath}    ${aOutstanding_Transaction_List}    ${aTransaction_Type_Dictionary}    ${aActual_Amount_Dictionary}    ${aLink_Transaction_List}
    
    ${Row_Count}    Get Length    ${aOutstanding_Transaction_List}    
    
    :FOR    ${i}    IN RANGE    0    ${Row_Count}
    \    ${Transaction_Type_Code}    Get From Dictionary    ${aTransaction_Type_Dictionary}    ${aOutstanding_Transaction_List}[${i}]
    \    
    \    ###Select By RID###
    \    Run Keyword If    '${Transaction_Type_Code}'!='IBT'    Select By RID    Outstanding Transaction    ${aOutstanding_Transaction_List}[${i}]
    \    Run Keyword If    '${Transaction_Type_Code}'=='IBT'    Select By RID    Outstanding Transaction    ${aLink_Transaction_List}[${i}]
    \    
    \    ###Re-fetch Transaction Type Code if initial code is IBT###
    \    ${Transaction_Type_Code}    Run Keyword If    '${Transaction_Type_Code}'=='IBT'    Get From Dictionary    ${aTransaction_Type_Dictionary}    ${aLink_Transaction_List}[${i}]
         ...    ELSE    Set Variable    ${Transaction_Type_Code}
    \    
    \    mx LoanIQ activate window    &{sExcelPath}[OST_Locator_${Transaction_Type_Code}]
    \    
    \    ${Actual_Amount}    Get From Dictionary    ${aActual_Amount_Dictionary}    ${aOutstanding_Transaction_List}[${i}]
    \    Run Keyword If    ${Actual_Amount.strip()}!=0    Validate Actual Amount in LIQ for VLS_OST_TRAN    &{sExcelPath}[OST_Actual_Amount_Locator_${Transaction_Type_Code}]    ${Actual_Amount}
    \    Run Keyword If    ${Actual_Amount.strip()}==0    Log    Outstanding Transaction ${aOutstanding_Transaction_List}[${i}], Type ${Transaction_Type_Code}: Actual Amount validation was skipped since value in CSV is equal to 0.
    \    
    \    Mx LoanIQ Close    &{sExcelPath}[OST_Locator_${Transaction_Type_Code}]

Validate Actual Amount in LIQ for VLS_OST_TRAN
    [Documentation]    This keyword validates 
    ...    @author: ehugo    11SEP2019
    [Arguments]    ${sActual_Amount_Field_Locator}    ${iCSV_ActualAmount}    
    
    ${LIQ_ActualAmount}    Mx LoanIQ Get Data    ${sActual_Amount_Field_Locator}    text%LIQ_ActualAmount    
    ${LIQ_ActualAmount}    Convert Number with comma to Integer    ${LIQ_Actual_Amount}
    ${iCSV_ActualAmount}    Remove String    ${iCSV_ActualAmount}    -
    ${ActualAmount_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${iCSV_ActualAmount}    ${LIQ_ActualAmount.strip()}    
    Run Keyword If    ${ActualAmount_isEqual}==True    Log    Actual Amount ${iCSV_ActualAmount} from CSV is equal to Actual Amount ${LIQ_ActualAmount} in LIQ.
    Run Keyword If    ${ActualAmount_isEqual}==False    Run Keyword And Continue On Failure    Fail    Actual Amount ${iCSV_ActualAmount} from CSV is not equal to Actual Amount ${LIQ_ActualAmount} in LIQ.    
    
    Take Screenshot    Actual_Amount_Validation

Validate OTR_IND_ST_TR_UNSC for VLS_OST_TRAN
    [Documentation]    This keyword validates that OTR_IND_ST_TR_UNSC column for VLS_OST_TRAN have values.
    ...    @author: ehugo    12SEP2019
    [Arguments]    ${sCSV_Filename}    
    
    ${CSV_Content}    Read Csv File To List    ${sCSV_Filename}    |
    
    ${Row_Count}    Get Length    ${CSV_Content}    
    ${Outstanding_Transaction_Header}    Get the Column index of the Header    ${sCSV_Filename}    OTR_RID_OST_TRAN
    ${OTR_IND_ST_TR_UNSC_Header}    Get the Column index of the Header    ${sCSV_Filename}    OTR_IND_ST_TR_UNSC
    
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${CSV_Content}    ${i}
    \    ${Outstanding_Transaction_Value}    Get From List    ${Table_Row_Item}    ${Outstanding_Transaction_Header}
    \    ${OTR_IND_ST_TR_UNSC_Value}    Get From List    ${Table_Row_Item}    ${OTR_IND_ST_TR_UNSC_Header}
    \    ${OTR_IND_ST_TR_UNSC_Length}    Get Length    ${OTR_IND_ST_TR_UNSC_Value.strip()}
    \    Run Keyword If    ${OTR_IND_ST_TR_UNSC_Length}>0    Log    OTR_IND_ST_TR_UNSC column contains a value for ${Outstanding_Transaction_Value} outstanding transaction.
    \    Run Keyword If    ${OTR_IND_ST_TR_UNSC_Length}==0    Run Keyword And Continue On Failure    Fail    OTR_IND_ST_TR_UNSC column does not contains value for ${Outstanding_Transaction_Value} outstanding transaction.
    
Get Outstanding Transaction Type List of Code
    [Documentation]    This keyword retrieves the list of code from Outstanding Transaction Type
    ...    @author: ehugo    12SEP2019
    
    ${Outstanding_Transaction_Type_Items}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_BrowseOutstandingTransactionType_JavaTree}    Outstanding_Transaction_Type_Items    Processtimeout=180
    Take Screenshot    Outstanding_Transaction_Type_Items
    Log    ${Outstanding_Transaction_Type_Items}    
    
    ${Codes_List}    Create List
    
    @{Row_Item}    Split String    ${Outstanding_Transaction_Type_Items}    ,Y
    ${Row_Item_Count}    Get Length    ${Row_Item}
    :FOR    ${i}    IN RANGE    1    ${Row_Item_Count}
    \    ${TempVar}    Set Variable    @{Row_Item}[${i}]
    \    ${TempVar}    Set Variable    ${TempVar.strip()}
    \    ${TempVar}    Set Variable    ${TempVar.split(' ',1)[0]}
    \    ${TempVar}    Set Variable    ${TempVar.split('\t',1)[0]}
    \    Append To List     ${Codes_List}    ${TempVar}
    
    Close All Windows on LIQ
    
    [Return]    ${Codes_List}
    
Validate Records for OTR_CDE_TYPE exist in LIQ
    [Documentation]    This keyword validates if records for OTR_CDE_TYPE exist in LIQ
    ...    @author: ehugo    12SEP2019
    [Arguments]    ${ExcelPath}    ${Codes_List}
    
    ${OutstandingTransactionType_CSV_Content}    Read Csv File To List    ${dataset_path}&{ExcelPath}[CSV_FilePath]&{ExcelPath}[OST_TRAN_CSV_FileName].csv    |
    ${OutstandingTransactionType_Header}    Get From List    ${OutstandingTransactionType_CSV_Content}    0
    ${OutstandingTransactionType_Length}    Get Length    ${OutstandingTransactionType_CSV_Content}
    ${OTR_RID_OST_TRAN_Index}    Get Index From List    ${OutstandingTransactionType_Header}    OTR_CDE_TYPE    
    
    ${OutstandingTransactionType_List}    Create List
    
    :FOR    ${i}    IN RANGE    1    ${OutstandingTransactionType_Length}
    \    ${OutstandingTransactionType_Row_Item}    Get From List    ${OutstandingTransactionType_CSV_Content}    ${i}
    \    ${OutstandingTransactionType_Row_Value}    Get From List    ${OutstandingTransactionType_Row_Item}    ${OTR_RID_OST_TRAN_Index}
    \    ${Count}    Get Match Count    ${OutstandingTransactionType_List}    ${OutstandingTransactionType_Row_Value.strip()}    
    \    Run Keyword If    ${Count}==0    Append To List    ${OutstandingTransactionType_List}    ${OutstandingTransactionType_Row_Value.strip()}
    
    ${OutstandingTransactionType_List_Length}    Get Length    ${OutstandingTransactionType_List}
    
    :FOR    ${i}    IN RANGE    0    ${OutstandingTransactionType_List_Length}
    \    ${Count}    Get Match Count    ${Codes_List}    ${OutstandingTransactionType_List}[${i}]    
    \    Run Keyword If    ${Count}==0    Run Keyword And Continue On Failure    Fail    ${OutstandingTransactionType_List}[${i}] does not exist in LIQ Outstanding Transaction Type.
    \    Run Keyword If    ${Count}!=0    Log    ${OutstandingTransactionType_List}[${i}] exists in LIQ Outstanding Transaction Type.

Validate OTR_CDE_TYPE records exist in LIQ for VLS_OST_TRAN
    [Documentation]    This keyword validates OTR_CDE_TYPE records exist in LIQ for VLS_OST_TRAN
    ...    @author: ehugo    12SEP2019
    [Arguments]    ${ExcelPath}    
    
    ###Navigate to Actions -> Table Maintenance###
    mx LoanIQ activate window    ${LIQ_Window}
    Select Actions    [Actions];Table Maintenance
    
    ###Table Maintenance Window###
    Search in Table Maintenance    Outstanding Transaction Type
    
    ###Browse data from Outstanding Transaction Type Window###
    mx LoanIQ activate window    ${LIQ_BrowseOutstandingTransactionType_Window}
    ${Codes_List}    Get Outstanding Transaction Type List of Code
    
    ###Validate Records exist in LIQ###
    Validate Records for OTR_CDE_TYPE exist in LIQ    ${ExcelPath}    ${Codes_List}

Validate CSV values in LIQ for VLS_Deal
    [Documentation]    This keyword is used to validate the Deal CSV values from CSV to LIQ Screen - Deal Notebook
    ...    @author: mgaling    10Sep2019    - initial Create
    ...    @update: mgaling    17Feb2020    - Added strip for Class and condition for Deal Notebook status validation

    [Arguments]    ${aTable_NameList}    ${DEA_PID_DEAL_Index}    ${DEA_DTE_APPROVED_Index}    ${DEA_DTE_TERM_EFF_Index}    ${DEA_DTE_CANCEL_EFF_Index}    ${DEA_CDE_ORIG_CCY_Index}
    ...    ${DEA_IND_ACTIVE_Index}    ${DEA_IND_SOLE_LENDR_Index}    ${DEA_CDE_EXPENSE_Index}    ${DEA_DTE_DEAL_CLSD_Index}                
    ...    ${DEA_DTE_AGREEMENT_Index}    ${DEA_CDE_DEAL_STAT_Index}    ${DEA_CDE_DEAL_CLASS_Index}    ${DEA_CDE_BRANCH_Index}
        
    ${VLS_DEAL_Data_Rows}    Get Length    ${aTable_NameList}
    
    :FOR    ${INDEX}    IN RANGE    1    ${VLS_DEAL_Data_Rows}
    \    ${Table_NameList}    Set Variable    @{aTable_NameList}[${INDEX}]
    \    Log    ${Table_NameList}    
    \    ${RID_Deal}    Remove String    @{Table_NameList}[${DEA_PID_DEAL_Index}]    "
    \    ${DTE_APPROVED}    Remove String    @{Table_NameList}[${DEA_DTE_APPROVED_Index}]    "
    \    ${DTE_TERM}    Remove String    @{Table_NameList}[${DEA_DTE_TERM_EFF_Index}]    "
    \    ${DTE_CANCEL}    Remove String    @{Table_NameList}[${DEA_DTE_CANCEL_EFF_Index}]    "
    \    ${CURRENCY}    Remove String    @{Table_NameList}[${DEA_CDE_ORIG_CCY_Index}]    "
    \    ${IND_ACTIVE}    Remove String    @{Table_NameList}[${DEA_IND_ACTIVE_Index}]    "
    \    ${IND_SOLE_LENDR}    Remove String    @{Table_NameList}[${DEA_IND_SOLE_LENDR_Index}]    "
    \    ${EXPENSE_CODE}    Remove String    @{Table_NameList}[${DEA_CDE_EXPENSE_Index}]    "
    \    ${DTE_CLSD}    Remove String    @{Table_NameList}[${DEA_DTE_DEAL_CLSD_Index}]    "
    \    ${DTE_AGRMNT}    Remove String    @{Table_NameList}[${DEA_DTE_AGREEMENT_Index}]    "
    \    ${STATUS}    Remove String    @{Table_NameList}[${DEA_CDE_DEAL_STAT_Index}]    "
    \    ${CLASS}    Remove String    @{Table_NameList}[${DEA_CDE_DEAL_CLASS_Index}]    "
    \    ${BRANCH}    Remove String    @{Table_NameList}[${DEA_CDE_BRANCH_Index}]    "
    \    
    \    ### Get Class Classification Code Description in Table Maintenance ###
    \    Run Keyword If    "${CLASS.strip()}"!="${EMPTY}"    Run Keywords    Select Actions    [Actions];Table Maintenance
         ...    AND    Search in Table Maintenance    Deal Classification
    \    ${Class_Desc}    Run Keyword If    "${CLASS.strip()}"!="${EMPTY}"    Get Single Description from Table Maintanance    ${CLASS.strip()}    ${LIQ_BrowseDealClassification_Window}    ${LIQ_BrowseDealClassification_JavaTree}    ${LIQ_BrowseDealClassification_ShowAll_Button}    ${LIQ_BrowseDealClassification_Exit_Button}    
    \    Close All Windows on LIQ
    \    ### Launch Deal thru RID ###
    \    ${RID_IsExist}    Run Keyword And Return Status    Navigate to Notebook Window thru RID    Deal    ${RID_Deal.strip()}
    \    Run Keyword If    "${RID_IsExist}"=="${False}"    Run Keyword And Continue On Failure    Fail    ${RID_Deal} does not exist!        
    \    ### Events Tab Validation ###
    \    Run Keyword If    "${DTE_APPROVED}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"     Run Keyword And Continue On Failure    Validate CSV Date values in LIQ Events Tab    ${DTE_APPROVED}    Approved    DEA_DTE_APPROVED
    \    Run Keyword If    "${DTE_TERM}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate CSV Date values in LIQ Events Tab    ${DTE_TERM}    Terminated    DEA_DTE_TERM_EFF      
    \    Run Keyword If    "${DTE_CANCEL}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate CSV Date values in LIQ Events Tab    ${DTE_CANCEL}    Cancelled    DEA_DTE_CANCEL_EFF
    \    Run Keyword If    "${DTE_CLSD}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate CSV Date values in LIQ Events Tab    ${DTE_CLSD}    Closed    DEA_DTE_DEAL_CLSD
    \    ### Summary Tab Validation ###
    \    ${DTE_AGRMNT_Converted}    Run Keyword If    "${DTE_AGRMNT}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword    Convert Date With Zero    ${DTE_AGRMNT}
    \    
    \    Run Keyword If    "${CURRENCY.strip()}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate CSV Values in LIQ Summary Tab    DEA_CDE_ORIG_CCY    ${CURRENCY.strip()}
    \    Run Keyword If    "${IND_SOLE_LENDR.strip()}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate CSV Values in LIQ Summary Tab    DEA_IND_SOLE_LENDR    None    ${IND_SOLE_LENDR.strip()}
    \    Run Keyword If    "${DTE_AGRMNT}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate CSV Values in LIQ Summary Tab    DEA_DTE_AGREEMENT    None    None    ${DTE_AGRMNT_Converted}
    \    Run Keyword If    "${CLASS.strip()}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate CSV Values in LIQ Summary Tab    DEA_CDE_DEAL_CLASS    None    None    None    ${CLASS.strip()}    ${Class_Desc}
    \    ### PERSONNEL Tab Validation ###
    \    Run Keyword If    "${EXPENSE_CODE.strip()}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate CSV Values in LIQ Personnel Tab    DEA_CDE_EXPENSE    ${EXPENSE_CODE.strip()}
    \    ### Deal Status Validation ###
    \    Run Keyword If    "${IND_ACTIVE.strip()}"!="${EMPTY}" and "${STATUS.strip()}"!="${EMPTY}" and "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate CSV Values in LIQ Deal Notebook Status    ${IND_ACTIVE.strip()}    ${STATUS.strip()}    ${BRANCH.strip()}
    \    
    \    Close All Windows on LIQ
    \    Refresh Tables in LIQ

Validate CSV Date values in LIQ Events Tab
    [Documentation]    This keyword is used to validate the Date values from CSV to LIQ-Deal Notebook Events Tab.
    ...    @author: mgaling    11Sep2019    Initial Create
    ...    @update: mgaling    17Feb2020    Replaced keyword for Events Java Tree validation    
    [Arguments]    ${dValue}    ${sStatus}    ${sField_Name}
     
    ${Date}    Convert Date With Zero    ${dValue}
    
    ### Deal Notebook Validation ###
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    Take Screenshot    ${sField_Name}
    ${Effective_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Events_Javatree}    ${sStatus}%Effective%value             
    ${status}    Run Keyword And Return Status    Should Be Equal    ${Date}    ${Effective_Date}            
    Run Keyword If    ${status}==${True}    Log    CSV Value ${Date} is reflected in LIQ - Deal Notebook Event Screen 
    ...    ELSE    Log    Fail    Incorrect Date value!

Validate CSV Values in LIQ Summary Tab
    [Documentation]    This keyword is used to validate the values from CSV to LIQ-Deal Notebook Summary Tab.
    ...    @author: mgaling    11Sep2019    Initial Create
    [Arguments]    ${sField_Name}    ${sCURRENCY}=None    ${sIND_SOLE_LENDR}=None    ${dDTE_AGRMNT}=None    ${sCLASS}=None    ${Class_Desc}=None    
         
    ### Deal Notebook Validation ###
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    Take Screenshot    Summary_Tab
    
    ### Deal Currency Validation ###
    Run Keyword If    "${sField_Name}"=="DEA_CDE_ORIG_CCY"    Run Keywords    Log    Deal Currency Validation
    ...    AND    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}    
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_Window}.JavaStaticText("attached text:=${sCURRENCY}")    VerificationData="Yes"
    ...    ELSE IF    "${sField_Name}"=="DEA_IND_SOLE_LENDR" and "${sIND_SOLE_LENDR}"=="Y"    Run Keywords    Log    Sole Lender is Checked    ### Deal Sole Lender Validation ###
    ...    AND    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_DealSummary_SoleLender_Checkbox}    value%1
    ...    ELSE IF    "${sField_Name}"=="DEA_IND_SOLE_LENDR" and "${sIND_SOLE_LENDR}"=="N"    Run Keywords    Log    Sole Lender is not Checked
    ...    AND    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_DealSummary_SoleLender_Checkbox}    value%0
    ...    ELSE IF    "${sField_Name}"=="DEA_DTE_AGREEMENT"    Run Keywords    Log    Deal Agreement Date Validation
    ...    AND    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_DealSummaryAgreementDate_Textfield}    value%${dDTE_AGRMNT}    
    ...    ELSE IF    "${sField_Name}"=="DEA_CDE_DEAL_CLASS"    Run Keywords    Log    Deal Classification Validation
    ...    AND    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_Window}.JavaEdit("text:=${Class_Desc}")            VerificationData="Yes"
    ...    ELSE    Run Keyword And Continue On Failure    Fail    No existing keyword for '${sField_Name}' validation!
      
Validate CSV Values in LIQ Personnel Tab
    [Documentation]    This keyword is used to validate the values from CSV to LIQ-Deal Notebook Personnel Tab.
    ...    @author: mgaling    11Sep2019    Initial Create
    [Arguments]    ${sField_Name}    ${sEXPENSE_CODE}=None    
    
    ### Deal Notebook Validation ###
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Personnel
    Take Screenshot    Personnel_Tab
    
    Run Keyword If    "${sField_Name}"=="DEA_CDE_EXPENSE"    Run Keywords    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_DealPersonnelExpenseCode_Textfield}    value%${sEXPENSE_CODE}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    No existing keyword for '${sField_Name}' validation!        

Validate CSV Values in LIQ Deal Notebook Status
    [Documentation]    This keyword is used to validate the values from CSV to LIQ-Deal Notebook Status.
    ...    @author: mgaling    12Sep2019    Initial Create
    [Arguments]    ${sIND_ACTIVE}    ${sSTATUS}    ${BRANCH}        
    
    ### Deal Notebook Validation ###
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    
    Run Keyword If    "${sIND_ACTIVE}"=="N" and "${sSTATUS}"=="TERM"    Run Keywords    Log    Deal Notebook is in Terminated Status
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_TerminatedDeal_Window}            VerificationData="Yes"
    ...    ELSE IF    "${sIND_ACTIVE}"=="N" and "${sSTATUS}"=="CAN"    Run Keywords    Log    Deal Notebook is in Cancelled Status
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_CancelledDeal_Window}    VerificationData="Yes"
    ...    ELSE IF    "${sIND_ACTIVE}"=="Y" and "${sSTATUS}"=="PEND"    Run Keywords    Log    Deal Notebook is in Pending Status
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PendingDeal_Window}    VerificationData="Yes"
    ...    ELSE IF    "${sIND_ACTIVE}"=="Y" and "${sSTATUS}"=="APRVD"    Run Keywords    Log    Deal Notebook is in Approved Status
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_ApproveDeal_Window}    VerificationData="Yes"
    ...    ELSE IF    "${sIND_ACTIVE}"=="Y" and "${sSTATUS}"=="RFAPR"    Run Keywords    Log    Deal Notebook is in Awaiting Approval Status
    ...    AND    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_AwaitingApprovalDeal_Window}    VerificationData="Yes"
    ...    ELSE IF    "${sIND_ACTIVE}"=="Y" and "${sSTATUS}"=="AGENT"    Run Keywords    Log    Deal Notebook is in CLOSED-AGENT 
    ...    AND    Run Keyword And Continue On Failure    Check if Deal is Agent    ${BRANCH}
    ...    ELSE IF    "${sIND_ACTIVE}"=="Y" and "${sSTATUS}"=="CLOSE"    Run Keywords    Log    Deal Notebook is in CLOSED-NONAGENT
    ...    AND    Run Keyword And Continue On Failure    Check if Deal is Non Agent    ${BRANCH}        
        
Check if Deal is Agent
    [Documentation]    This keyword is used to validate if the Deal is Agented.
    ...    @author: mgaling    12Sep2019    Initial Create
    [Arguments]    ${BRANCH}    
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    Take Screenshot    Summary_Tab
                
    ${AdminAgent_Value}    Mx LoanIQ Get Data    ${LIQ_DealSummary_AdminAgent_Textfield}    value
    Log    ${AdminAgent_Value}  
    
    Run Keyword If    "${BRANCH}"=="${BRANCH_CB001}"    Run Keyword And Continue On Failure    Should Be Equal    ${BRANCH_CB001_Customer}    ${AdminAgent_Value}
    ...    ELSE IF    "${BRANCH}"=="${BRANCH_CB022}"    Run Keyword And Continue On Failure    Should Be Equal    ${BRANCH_CB022_Customer}    ${AdminAgent_Value}
    ...    ELSE IF    "${BRANCH}"=="${BRANCH_CG852}"    Run Keyword And Continue On Failure    Should Be Equal    ${BRANCH_CG852_Customer}    ${AdminAgent_Value}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${BRANCH} Code is now Active, no existing keywords!                      
           
Check if Deal is Non Agent
    [Documentation]    This keyword is used to validate if the Deal is Non-Agent.
    ...    @author: mgaling    12Sep2019    Initial Create
    [Arguments]    ${BRANCH}        
    
    ### Deal Notebook - Summary Tab ###
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    Take Screenshot    Summary_Tab
                
    ${AdminAgent_Value}    Mx LoanIQ Get Data    ${LIQ_DealSummary_AdminAgent_Textfield}    value
    Log    ${AdminAgent_Value}  
    
    Run Keyword If    "${BRANCH}"=="${BRANCH_CB001}"    Run Keyword And Continue On Failure    Should Not Be Equal    ${BRANCH_CB001_Customer}    ${AdminAgent_Value}
    ...    ELSE IF    "${BRANCH}"=="${BRANCH_CB022}"    Run Keyword And Continue On Failure    Should Not Be Equal    ${BRANCH_CB022_Customer}    ${AdminAgent_Value}
    ...    ELSE IF    "${BRANCH}"=="${BRANCH_CG852}"    Run Keyword And Continue On Failure    Should Not Be Equal    ${BRANCH_CG852_Customer}    ${AdminAgent_Value}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${BRANCH} Code is now Active, no existing keyword!
    
    ### Deal Notebook Primaries ###
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_DistributionPrimaries_Menu}
    
    mx LoanIQ activate window    ${LIQ_PrimariesList_Window}
    Take Screenshot    Primary_Notebook
    
    Run Keyword If    "${BRANCH}"=="${BRANCH_CB001}"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PrimariesList_JavaTree}    ${BRANCH_CB001_Customer}                   
    ...    ELSE IF    "${BRANCH}"=="${BRANCH_CB022}"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PrimariesList_JavaTree}    ${BRANCH_CB022_Customer}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${BRANCH} Code is now Active, no existing keyword!    
    
    mx LoanIQ close window    ${LIQ_PrimariesList_Window}

Get Column Records for VLS_FACILITY
    [Documentation]    This keyword retrieves the unique values for FAC_PID_FACILITY. Then get the values for the following column: 
    ...    FAC_DTE_TERM_FAC, FAC_IND_MULTI_CURR, FAC_DTE_FL_DRAWDWN, FAC_DTE_EFFECTIVE, FAC_DTE_FINAL_MAT, FAC_DTE_EXPIRY, FAC_CDE_CURRENCY, FAC_IND_COMMITTED, FAC_CDE_FAC_TYPE, FAC_CDE_BRANCH
    ...    
    ...    @author: ehugo    16SEP2019
    [Arguments]    ${sCSV_Filename}    
    
    ${CSV_Content}    Read Csv File To List    ${sCSV_Filename}    |
    
    ${Row_Count}    Get Length    ${CSV_Content}  
    ${FacilityID_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_PID_FACILITY
    ${Termination_Date_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_DTE_TERM_FAC
    ${Multi_Currency_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_IND_MULTI_CURR
    ${FirstLoan_Drawdown_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_DTE_FL_DRAWDWN
    ${Effective_Date_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_DTE_EFFECTIVE
    ${Final_Maturity_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_DTE_FINAL_MAT
    ${Expiry_Date_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_DTE_EXPIRY
    ${Currency_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_CDE_CURRENCY
    ${Committed_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_IND_COMMITTED
    ${Agreement_Date_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_DTE_AGREEMENT
    ${Facility_Type_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_CDE_FAC_TYPE
    ${Branch_Header}    Get the Column index of the Header    ${sCSV_Filename}    FAC_CDE_BRANCH
    
    
    ${Termination_Date_Dictionary}    Create Dictionary
    ${Multi_Currency_Dictionary}    Create Dictionary
    ${FirstLoan_Drawdown_Dictionary}    Create Dictionary
    ${Effective_Date_Dictionary}    Create Dictionary
    ${Final_Maturity_Dictionary}    Create Dictionary
    ${Expiry_Date_Dictionary}    Create Dictionary
    ${Currency_Dictionary}    Create Dictionary
    ${Committed_Dictionary}    Create Dictionary
    ${Agreement_Date_Dictionary}    Create Dictionary
    ${Facility_Type_Dictionary}    Create Dictionary
    ${Branch_Dictionary}    Create Dictionary
    
    ${FacilityID_List}    Create List
    
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${CSV_Content}    ${i}
    \    ${FacilityID_Value}    Get From List    ${Table_Row_Item}    ${FacilityID_Header}
    \    ${Termination_Date_Value}    Get From List    ${Table_Row_Item}    ${Termination_Date_Header}
    \    ${Termination_Date_Value}    Run Keyword If    '${Termination_Date_Value}'=='${EMPTY}'    Set Variable    0    ELSE    Set Variable    ${Termination_Date_Value}
    \    ${Multi_Currency_Value}    Get From List    ${Table_Row_Item}    ${Multi_Currency_Header}
    \    ${FirstLoan_Drawdown_Value}    Get From List    ${Table_Row_Item}    ${FirstLoan_Drawdown_Header}
    \    ${FirstLoan_Drawdown_Value}    Run Keyword If    '${FirstLoan_Drawdown_Value}'=='${EMPTY}'    Set Variable    0    ELSE    Set Variable    ${FirstLoan_Drawdown_Value}
    \    ${Effective_Date_Value}    Get From List    ${Table_Row_Item}    ${Effective_Date_Header}
    \    ${Effective_Date_Value}    Run Keyword If    '${Effective_Date_Value}'=='${EMPTY}'    Set Variable    0    ELSE    Set Variable    ${Effective_Date_Value}
    \    ${Final_Maturity_Value}    Get From List    ${Table_Row_Item}    ${Final_Maturity_Header}
    \    ${Final_Maturity_Value}    Run Keyword If    '${Final_Maturity_Value}'=='${EMPTY}'    Set Variable    0    ELSE    Set Variable    ${Final_Maturity_Value}
    \    ${Expiry_Date_Value}    Get From List    ${Table_Row_Item}    ${Expiry_Date_Header}
    \    ${Expiry_Date_Value}    Run Keyword If    '${Expiry_Date_Value}'=='${EMPTY}'    Set Variable    0    ELSE    Set Variable    ${Expiry_Date_Value}
    \    ${Currency_Value}    Get From List    ${Table_Row_Item}    ${Currency_Header}
    \    ${Committed_Value}    Get From List    ${Table_Row_Item}    ${Committed_Header}
    \    ${Agreement_Date_Value}    Get From List    ${Table_Row_Item}    ${Agreement_Date_Header}
    \    ${Agreement_Date_Value}    Run Keyword If    '${Agreement_Date_Value}'=='${EMPTY}'    Set Variable    0    ELSE    Set Variable    ${Agreement_Date_Value}
    \    ${Facility_Type_Value}    Get From List    ${Table_Row_Item}    ${Facility_Type_Header}
    \    ${Branch_Value}    Get From List    ${Table_Row_Item}    ${Branch_Header}
    \    ${Count}    Get Match Count    ${FacilityID_List}    ${FacilityID_Value.strip()}    
    \    Run Keyword If    ${Count}==0    Append To List    ${FacilityID_List}    ${FacilityID_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Termination_Date_Dictionary}    ${FacilityID_Value.strip()}=${Termination_Date_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Multi_Currency_Dictionary}    ${FacilityID_Value.strip()}=${Multi_Currency_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${FirstLoan_Drawdown_Dictionary}    ${FacilityID_Value.strip()}=${FirstLoan_Drawdown_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Effective_Date_Dictionary}    ${FacilityID_Value.strip()}=${Effective_Date_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Final_Maturity_Dictionary}    ${FacilityID_Value.strip()}=${Final_Maturity_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Expiry_Date_Dictionary}    ${FacilityID_Value.strip()}=${Expiry_Date_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Currency_Dictionary}    ${FacilityID_Value.strip()}=${Currency_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Committed_Dictionary}    ${FacilityID_Value.strip()}=${Committed_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Agreement_Date_Dictionary}    ${FacilityID_Value.strip()}=${Agreement_Date_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Facility_Type_Dictionary}    ${FacilityID_Value.strip()}=${Facility_Type_Value.strip()}
    \    Run Keyword If    ${Count}==0    Set To Dictionary    ${Branch_Dictionary}    ${FacilityID_Value.strip()}=${Branch_Value.strip()}
    
    [Return]    ${FacilityID_List}    ${Termination_Date_Dictionary}    ${Multi_Currency_Dictionary}    ${FirstLoan_Drawdown_Dictionary}    ${Effective_Date_Dictionary}    ${Final_Maturity_Dictionary}
    ...    ${Expiry_Date_Dictionary}    ${Currency_Dictionary}    ${Committed_Dictionary}    ${Agreement_Date_Dictionary}    ${Facility_Type_Dictionary}    ${Branch_Dictionary}

Validate Records for VLS_FACILITY
    [Documentation]    This keyword validates the records for VLS_Facility
    ...    @author: ehugo    16SEP2019
    ...    @update: mgaling    17FEB2020    added Run Keyword And Continue On Failure on the validation keywords
    [Arguments]    ${aFacilityID_List}    ${aMulti_Currency_Dictionary}    ${aEffective_Date_Dictionary}    ${aFinal_Maturity_Dictionary}    ${aExpiry_Date_Dictionary}    ${aCurrency_Dictionary}
    ...    ${aAgreement_Date_Dictionary}    ${aFacility_Type_Dictionary}    ${aTermination_Date_Dictionary}    ${aFL_Drawdown_Date_Dictionary}    ${aCommitted_Dictionary}    ${aBranch_Dictionary}
    
    ${Facility_Type_List}    ${Facility_Type_Dictionary}    Get Facility Type List of Codes
    
    ${Customer_Description_Dictionary}    Create Dictionary
    ${Branch_Description_Dictionary}    Create Dictionary
    
    ${Row_Count}    Get Length    ${aFacilityID_List}    
    
    :FOR    ${i}    IN RANGE    0    ${Row_Count}
    \    ${Current_FacilityID}    Set Variable    ${aFacilityID_List}[${i}]
    \    Run Keyword If    '${Current_FacilityID.strip()}'=='NONE'    Log    Facility ID is NONE. Skipping record.
    \    Continue For Loop If    '${Current_FacilityID.strip()}'=='NONE'
    \    
    \    ${Current_Multi_Currency}    Get From Dictionary    ${aMulti_Currency_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_Effective_Date}    Get From Dictionary    ${aEffective_Date_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_Final_Maturity}    Get From Dictionary    ${aFinal_Maturity_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_Expiry_Date}    Get From Dictionary    ${aExpiry_Date_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_Currency}    Get From Dictionary    ${aCurrency_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_Agreement_Date}    Get From Dictionary    ${aAgreement_Date_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_Facility_Type}    Get From Dictionary    ${aFacility_Type_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_Termination_Date}    Get From Dictionary    ${aTermination_Date_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_FL_Drawdown_Date}    Get From Dictionary    ${aFL_Drawdown_Date_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_Committed}    Get From Dictionary    ${aCommitted_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${Current_Branch}    Get From Dictionary    ${aBranch_Dictionary}    ${aFacilityID_List}[${i}]
    \    
    \    ###Select By RID###
    \    Select By RID    Facility    ${aFacilityID_List}[${i}]
    \    
    \    Sleep    2s    
    \    ${AlertsWindow_isDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_Alerts_Window}         VerificationData="Yes"
    \    Run Keyword If     ${AlertsWindow_isDisplayed}==True    Run Keywords
        ...    mx LoanIQ activate window    ${LIQ_Facility_Alerts_Window}
        ...    AND    mx LoanIQ click    ${LIQ_Facility_Alerts_Cancel_Button}
    \    Sleep    2s
    \    ${LockoutsWindow_isDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_Lockouts_Window}        VerificationData="Yes"
    \    Run Keyword If     ${LockoutsWindow_isDisplayed}==True    Run Keywords
        ...    mx LoanIQ activate window    ${LIQ_FacilityLockouts_Window}
    	...    AND    mx LoanIQ click    ${LIQ_Facility_Lockouts_Cancel_Button}    
    \    
    \    Run Keyword And Continue On Failure    Validate FAC_IND_MULTI_CURR for VLS_FACILITY - Summary Tab    ${aFacilityID_List}[${i}]    ${Current_Multi_Currency}
    \    Run Keyword And Continue On Failure    Validate FAC_DTE_EFFECTIVE for VLS_FACILITY    ${aFacilityID_List}[${i}]    ${Current_Effective_Date}
    \    Run Keyword And Continue On Failure    Validate FAC_DTE_FINAL_MAT for VLS_FACILITY    ${aFacilityID_List}[${i}]    ${Current_Final_Maturity}
    \    Run Keyword And Continue On Failure    Validate FAC_DTE_EXPIRY for VLS_FACILITY    ${aFacilityID_List}[${i}]    ${Current_Expiry_Date}
    \    Run Keyword And Continue On Failure    Validate FAC_CDE_CURRENCY for VLS_FACILITY    ${aFacilityID_List}[${i}]    ${Current_Currency}
    \    Run Keyword And Continue On Failure    Validate FAC_DTE_AGREEMENT for VLS_FACILITY    ${aFacilityID_List}[${i}]    ${Current_Agreement_Date}
    \    Run Keyword And Continue On Failure    Validate FAC_CDE_FAC_TYPE for VLS_FACILITY    ${aFacilityID_List}[${i}]    ${Current_Facility_Type}    ${Facility_Type_List}    ${Facility_Type_Dictionary}
    \    Run Keyword And Continue On Failure    Validate FAC_DTE_TERM_FAC for VLS_FACILITY    ${aFacilityID_List}[${i}]    ${Current_Termination_Date}
    \    Run Keyword And Continue On Failure    Validate FAC_DTE_FL_DRAWDWN for VLS_FACILITY - Events Tab    ${aFacilityID_List}[${i}]    ${Current_FL_Drawdown_Date}
    \    Run Keyword And Continue On Failure    Validate FAC_IND_COMMITTED for VLS_FACILITY    ${aFacilityID_List}[${i}]    ${Current_Committed}
    \    Run Keyword And Continue On Failure    Validate FAC_DTE_FL_DRAWDWN for VLS_FACILITY - Existing Loans Window    ${aFacilityID_List}[${i}]    ${Current_FL_Drawdown_Date}
    \
    \    ${Customer_Description}    ${Branch_Description}    Get Branch value for FAC_CDE_BRANCH in VLS_FACILITY    ${aFacilityID_List}[${i}]
    \    Run Keyword If    '${Customer_Description}'!='${EMPTY}'    Set To Dictionary    ${Customer_Description_Dictionary}    ${aFacilityID_List}[${i}]=${Customer_Description}
    \    Run Keyword If    '${Customer_Description}'=='${EMPTY}'    Set To Dictionary    ${Branch_Description_Dictionary}    ${aFacilityID_List}[${i}]=${Branch_Description}
    \    
    \    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}    
    
    Validate FAC_CDE_BRANCH for VLS_FACILITY    ${aFacilityID_List}    ${aBranch_Dictionary}    ${Customer_Description_Dictionary}    ${Branch_Description_Dictionary}
    
    Close All Windows on LIQ

Validate FAC_IND_MULTI_CURR for VLS_FACILITY - Summary Tab
    [Documentation]    This keyword validates FAC_IND_MULTI_CURR in Facility Notebook Summary Tab for VLS_Facility
    ...    @author: ehugo    16SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_MultiCurrency_Value}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}    
    Take Screenshot    MultiCurrency_SummaryTab
    ${Actual_MultiCurrency_Value}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_MultiCurrencyFacility_Checkbox}    value%Actual_MultiCurrency_Value
    Run Keyword If    '${sExpected_MultiCurrency_Value}'=='Y' and '${Actual_Multi_Currency_Value}'=='1'    Log    Multi-Currency checkbox is correctly ticked for ${sFacilityID}
    Run Keyword If    '${sExpected_MultiCurrency_Value}'=='N' and '${Actual_Multi_Currency_Value}'=='0'    Log    Multi-Currency checkbox is correctly unticked for ${sFacilityID}
    Run Keyword If    '${sExpected_MultiCurrency_Value}'=='Y' and '${Actual_Multi_Currency_Value}'=='0'    Run Keyword And Continue On Failure    Fail    Multi-Currency checkbox for ${sFacilityID} is unticked in LIQ but is expected to be ticked in CSV.
    Run Keyword If    '${sExpected_MultiCurrency_Value}'=='N' and '${Actual_Multi_Currency_Value}'=='1'    Run Keyword And Continue On Failure    Fail    Multi-Currency checkbox for ${sFacilityID} is ticked in LIQ but is expected to be unticked in CSV.
    
Validate FAC_DTE_EFFECTIVE for VLS_FACILITY
    [Documentation]    This keyword validates FAC_DTE_EFFECTIVE for VLS_Facility
    ...    @author: ehugo    16SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_EffectiveDate_Value}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Take Screenshot    Effective_Date    
    ${Actual_EffectiveDate_Value}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_EffectiveDate_Datefield}    text%Actual_EffectiveDate_Value
    Run Keyword If    '${sExpected_EffectiveDate_Value}'=='0'    Log    No Effective Date value in CSV for Facility ID ${sFacilityID}
    Return From Keyword If    '${sExpected_EffectiveDate_Value}'=='0'    
    ${sExpected_EffectiveDate_Value}    Convert CSV Date Format to LIQ Date Format    ${sExpected_EffectiveDate_Value}
    ${EffectiveDate_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpected_EffectiveDate_Value.strip()}    ${Actual_EffectiveDate_Value.strip()}       
    Run Keyword If    ${EffectiveDate_isEqual}==True    Log    Effective Date ${sExpected_EffectiveDate_Value} for ${sFacilityID} is correct.
    Run Keyword If    ${EffectiveDate_isEqual}==False    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Expected Effective Date ${sExpected_EffectiveDate_Value} is not equal to Actual Effective Date ${Actual_EffectiveDate_Value}

Validate FAC_DTE_FINAL_MAT for VLS_FACILITY
    [Documentation]    This keyword validates FAC_DTE_FINAL_MAT for VLS_Facility
    ...    @author: ehugo    18SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_FinalMaturity_Value}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Take Screenshot    Final_Maturity_Date    
    ${Actual_FinalMaturity_Value}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_FinalMaturityDate_Datefield}    text%Actual_FinalMaturity_Value
    Run Keyword If    '${sExpected_FinalMaturity_Value}'=='0'    Log    No Final Maturity value in CSV for Facility ID ${sFacilityID}
    Return From Keyword If    '${sExpected_FinalMaturity_Value}'=='0'   
    ${sExpected_FinalMaturity_Value}    Convert CSV Date Format to LIQ Date Format    ${sExpected_FinalMaturity_Value}
    ${FinalMaturity_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpected_FinalMaturity_Value.strip()}    ${Actual_FinalMaturity_Value.strip()}       
    Run Keyword If    ${FinalMaturity_isEqual}==True    Log    Final Maturity ${sExpected_FinalMaturity_Value} for ${sFacilityID} is correct.
    Run Keyword If    ${FinalMaturity_isEqual}==False    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Expected Final Maturity ${sExpected_FinalMaturity_Value} is not equal to Actual Final Maturity ${Actual_FinalMaturity_Value}

Validate FAC_DTE_EXPIRY for VLS_FACILITY
    [Documentation]    This keyword validates FAC_DTE_EXPIRY for VLS_Facility
    ...    @author: ehugo    18SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_Expiry_Value}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Take Screenshot    Expiry_Date    
    ${Actual_Expiry_Value}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ExpiryDate_Datefield}    text%Actual_Expiry_Value
    Run Keyword If    '${sExpected_Expiry_Value}'=='0'    Log    No Expiry value in CSV for Facility ID ${sFacilityID}
    Return From Keyword If    '${sExpected_Expiry_Value}'=='0'    
    ${sExpected_Expiry_Value}    Convert CSV Date Format to LIQ Date Format    ${sExpected_Expiry_Value}
    ${Expiry_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpected_Expiry_Value.strip()}    ${Actual_Expiry_Value.strip()}       
    Run Keyword If    ${Expiry_isEqual}==True    Log    Expiry ${sExpected_Expiry_Value} for ${sFacilityID} is correct.
    Run Keyword If    ${Expiry_isEqual}==False    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Expected Expiry ${sExpected_Expiry_Value} is not equal to Actual Expiry ${Actual_Expiry_Value}

Validate FAC_CDE_CURRENCY for VLS_FACILITY
    [Documentation]    This keyword validates FAC_CDE_CURRENCY for VLS_Facility
    ...    @author: ehugo    18SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_Currency_Value}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Take Screenshot    Currency    
    ${Actual_Currency_Value}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_Currency_StaticText}    text%Actual_Currency_Value
    ${Currency_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpected_Currency_Value.strip()}    ${Actual_Currency_Value.strip()}       
    Run Keyword If    ${Currency_isEqual}==True    Log    Currency ${sExpected_Currency_Value} for ${sFacilityID} is correct.
    Run Keyword If    ${Currency_isEqual}==False    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Expected Currency ${sExpected_Currency_Value} is not equal to Actual Currency ${Actual_Currency_Value}
    
Validate FAC_DTE_AGREEMENT for VLS_FACILITY
    [Documentation]    This keyword validates FAC_DTE_AGREEMENT for VLS_Facility
    ...    @author: ehugo    18SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_Agreement_Value}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Take Screenshot    Agreement_Date    
    ${Actual_Agreement_Value}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_AgreementDate_Datefield}    text%Actual_Agreement_Value
    Run Keyword If    '${sExpected_Agreement_Value}'=='0'    Log    No Agreement value in CSV for Facility ID ${sFacilityID}
    Return From Keyword If    '${sExpected_Agreement_Value}'=='0'    
    ${sExpected_Agreement_Value}    Convert CSV Date Format to LIQ Date Format    ${sExpected_Agreement_Value}
    ${Agreement_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpected_Agreement_Value.strip()}    ${Actual_Agreement_Value.strip()}       
    Run Keyword If    ${Agreement_isEqual}==True    Log    Agreement ${sExpected_Agreement_Value} for ${sFacilityID} is correct.
    Run Keyword If    ${Agreement_isEqual}==False    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Expected Agreement ${sExpected_Agreement_Value} is not equal to Actual Agreement ${Actual_Agreement_Value}
    
Get Facility Type List of Codes
    [Documentation]    This keyword retrieves the Facility Type List of Codes from Table Maintenance
    ...    @author: ehugo    18SEP2019
    
    ###Navigate to Actions -> Table Maintenance###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Facility Type
    
    ###Browse data from Facility Type Window###
    mx LoanIQ activate window    ${LIQ_BrowseFacilityType_Window}
    
    ${FacilityType_Items}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_BrowseFacilityType_JavaTree}    FacilityType_Items    Processtimeout=180
    Take Screenshot    FacilityType_Items
    Log    ${FacilityType_Items}    
    
    ${Codes_List}    Create List
    ${Codes_Dictionary}    Create Dictionary    
    
    @{Row_Item}    Split String    ${FacilityType_Items}    ,Y
    ${Row_Item_Count}    Get Length    ${Row_Item}
    :FOR    ${i}    IN RANGE    1    ${Row_Item_Count}
    \    ${TempVar}    Set Variable    @{Row_Item}[${i}]
    \    ${TempVar}    Set Variable    ${TempVar.strip()}
    \    ${CodeVar}    Set Variable    ${TempVar.split(' ',1)[0]}
    \    ${CodeVar}    Set Variable    ${CodeVar.split('\t',1)[0]}
    \    ${DescVar}    Set Variable    ${TempVar.split('\t',1)[1]}
    \    ${DescVar}    Set Variable    ${DescVar.split('\t',1)[0]}
    \    Append To List     ${Codes_List}    ${CodeVar}
    \    Set To Dictionary    ${Codes_Dictionary}    ${CodeVar.strip()}=${DescVar.strip()}
    
    Close All Windows on LIQ
    
    [Return]    ${Codes_List}    ${Codes_Dictionary}
    
Validate FAC_CDE_FAC_TYPE for VLS_FACILITY
    [Documentation]    This keyword validates FAC_CDE_FAC_TYPE for VLS_Facility
    ...    @author: ehugo    18SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_FacilityType_Value}    ${aFacilityType_List}    ${aFacilityType_Dictionary}
    
    ${Count}    Get Match Count    ${aFacilityType_List}    ${sExpected_FacilityType_Value.strip()}    
    Run Keyword If    ${Count}>0    Log    Facility ID ${sFacilityID}: Facility Type ${sExpected_FacilityType_Value} exists in Facility Type List in Table Maintenance
    Run Keyword If    ${Count}==0    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Facility Type ${sExpected_FacilityType_Value} does not exists in Facility Type List in Table Maintenance
    
    ${FacilityType_Description}    Get From Dictionary    ${aFacilityType_Dictionary}    ${sExpected_FacilityType_Value}
    ${hasOpenParenthesis}    Run Keyword And Return Status    Should Contain    ${FacilityType_Description.strip()}    (
    ${FacilityType_Description}    Run Keyword If    ${hasOpenParenthesis}==True    Replace String    ${FacilityType_Description.strip()}    (    \\(
    ...    ELSE    Set Variable    ${FacilityType_Description.strip()}
    ${hasCloseParenthesis}    Run Keyword And Return Status    Should Contain    ${FacilityType_Description.strip()}    )
    ${FacilityType_Description}    Run Keyword If    ${hasCloseParenthesis}==True    Replace String    ${FacilityType_Description.strip()}    )    \\)
    ...    ELSE    Set Variable    ${FacilityType_Description.strip()}
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    ${FacilityType_Field}    Set Variable    JavaWindow("title:=Facility -.*","displayed:=1").JavaStaticText("attached text:=${FacilityType_Description.strip()}")
    ${FacilityType_IsDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${FacilityType_Field}    VerificationData="Yes"
    Take Screenshot    FacilityType
    Run Keyword If    ${FacilityType_IsDisplayed}==True    Log    Facility Type ${sExpected_FacilityType_Value} for ${sFacilityID} is correct.
    Run Keyword If    ${FacilityType_IsDisplayed}==False    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Expected Facility Type ${sExpected_FacilityType_Value} does not exists in LIQ Facility Window
    
Validate FAC_CDE_BRANCH for VLS_FACILITY
    [Documentation]    This keyword validates FAC_CDE_BRANCH for VLS_Facility
    ...    @author: ehugo    18SEP2019
    [Arguments]    ${aFacilityID_List}    ${aBranch_Dictionary}    ${aCustomer_Description_Dictionary}    ${aBranch_Description_Dictionary}
    
    ###Navigate to Actions -> Table Maintenance###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Branch
    
    ###Browse data from Branch Window###
    mx LoanIQ activate window    ${LIQ_Branch_Window}
    
    ${Code_CustomerDescription_Dictionary}    Create Dictionary
    ${Code_BranchDescription_Dictionary}    Create Dictionary
    
    ${Row_Item_Count}    Get Length    ${aFacilityID_List}
    :FOR    ${i}    IN RANGE    0    ${Row_Item_Count}
    \    ${Branch_Code}    Get From Dictionary    ${aBranch_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${FacilityID_isExist}    Run Keyword And Return Status    Get From Dictionary    ${aCustomer_Description_Dictionary}    ${aFacilityID_List}[${i}]
    \    Continue For Loop If    ${FacilityID_isExist}==False
    \    ${Branch_Description}    Get From Dictionary    ${aCustomer_Description_Dictionary}    ${aFacilityID_List}[${i}]
    \    
    \    ${BranchCode_isChecked}    Run Keyword And Return Status    Dictionary Should Contain Key    ${Code_CustomerDescription_Dictionary}    ${Branch_Code}
    \    Run Keyword If    ${BranchCode_isChecked}==False    Validate Customer Description for FAC_CDE_BRANCH in VLS_FACILITY    ${Branch_Code}    ${Branch_Description}    ${aFacilityID_List}[${i}]
    \    Run Keyword If    ${BranchCode_isChecked}==False    Set To Dictionary    ${Code_CustomerDescription_Dictionary}    ${Branch_Code}=${Branch_Description}
    \    ${BranchDescription_Expected}    Run Keyword If    ${BranchCode_isChecked}==True    Get From Dictionary    ${Code_CustomerDescription_Dictionary}    ${Branch_Code}
    \    Run Keyword If    ${BranchCode_isChecked}==True and '${BranchDescription_Expected}'!='${Branch_Description}'    Validate Customer Description for FAC_CDE_BRANCH in VLS_FACILITY    ${Branch_Code}    ${Branch_Description}    ${aFacilityID_List}[${i}]
    \    Run Keyword If    ${BranchCode_isChecked}==True and '${BranchDescription_Expected}'!='${Branch_Description}'    Set To Dictionary    ${Code_CustomerDescription_Dictionary}    ${Branch_Code}=${Branch_Description}
    \    Run Keyword If    ${BranchCode_isChecked}==True and '${BranchDescription_Expected}'=='${Branch_Description}'    Log    Branch Code ${Branch_Code} with Description ${Branch_Description} already checked.
    
    ${Branch_Desc_Dictionary_Length}    Get Length    ${aBranch_Description_Dictionary}
    Return From Keyword If    ${Branch_Desc_Dictionary_Length}==0
    
    ${Row_Item_Count}    Get Length    ${aFacilityID_List}
    :FOR    ${i}    IN RANGE    0    ${Row_Item_Count}
    \    ${Branch_Code}    Get From Dictionary    ${aBranch_Dictionary}    ${aFacilityID_List}[${i}]
    \    ${FacilityID_isExist}    Run Keyword And Return Status    Get From Dictionary    ${aBranch_Description_Dictionary}    ${aFacilityID_List}[${i}]
    \    Continue For Loop If    ${FacilityID_isExist}==False
    \    ${Branch_Description}    Get From Dictionary    ${aBranch_Description_Dictionary}    ${aFacilityID_List}[${i}]
    \    
    \    ${BranchCode_isChecked}    Run Keyword And Return Status    Dictionary Should Contain Key    ${Code_BranchDescription_Dictionary}    ${Branch_Code}
    \    Run Keyword If    ${BranchCode_isChecked}==False    Validate Branch Description for FAC_CDE_BRANCH in VLS_FACILITY    ${Branch_Code}    ${Branch_Description}    ${aFacilityID_List}[${i}]
    \    Run Keyword If    ${BranchCode_isChecked}==False    Set To Dictionary    ${Code_BranchDescription_Dictionary}    ${Branch_Code}=${Branch_Description}
    \    ${BranchDescription_Expected}    Run Keyword If    ${BranchCode_isChecked}==True    Get From Dictionary    ${Code_BranchDescription_Dictionary}    ${Branch_Code}
    \    Run Keyword If    ${BranchCode_isChecked}==True and '${BranchDescription_Expected}'!='${Branch_Description}'    Validate Branch Description for FAC_CDE_BRANCH in VLS_FACILITY    ${Branch_Code}    ${Branch_Description}    ${aFacilityID_List}[${i}]
    \    Run Keyword If    ${BranchCode_isChecked}==True and '${BranchDescription_Expected}'!='${Branch_Description}'    Set To Dictionary    ${Code_BranchDescription_Dictionary}    ${Branch_Code}=${Branch_Description}
    \    Run Keyword If    ${BranchCode_isChecked}==True and '${BranchDescription_Expected}'=='${Branch_Description}'    Log    Branch Code ${Branch_Code} with Description ${Branch_Description} already checked.

Validate Customer Description for FAC_CDE_BRANCH in VLS_FACILITY
    [Documentation]    This keyword validates customer description for FAC_CDE_BRANCH for VLS_Facility
    ...    @author: ehugo    19SEP2019
    [Arguments]    ${sBranch_Code}    ${sBranch_Description}    ${sFacilityID}    
    
    Mx LoanIQ Select String    ${LIQ_Branch_Tree}    ${sBranch_Code.strip()}
    Mx Press Combination    KEY.ENTER
    Mx LoanIQ Click Button On Window    .*Branch.*;Informational Message.*;OK        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    
    ###Branch Update Window###
    mx LoanIQ activate window    ${LIQ_Branch_Update_Window}
    ${Branch_Description_Field}    Set Variable    JavaWindow("title:=Branch Update").JavaEdit("text:=${sBranch_Description}")
    ${Branch_Description_IsDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Branch_Description_Field}    VerificationData="Yes" 
    Take Screenshot    Branch_Customer
    Run Keyword If    ${Branch_Description_IsDisplayed}==True    Log    Branch Customer ${sBranch_Description} is correct.
    Run Keyword If    ${Branch_Description_IsDisplayed}==False    Run Keyword And Continue On Failure    Fail    Branch Customer ${sBranch_Description} for ${sFacilityID} is incorrect.
    
    mx LoanIQ close window    ${LIQ_Branch_Update_Window}

Validate Branch Description for FAC_CDE_BRANCH in VLS_FACILITY
    [Documentation]    This keyword validates branch description for FAC_CDE_BRANCH for VLS_Facility
    ...    @author: ehugo    19SEP2019    - initial create
    ...    @update: mgaling    14OCT2020    - updated Mx Native Type    {ENTER} keyword into Mx Press Combination    KEY.ENTER 
    [Arguments]    ${sBranch_Code}    ${sExpected_Branch_Description}    ${sFacilityID}    
    
    Mx LoanIQ Select String    ${LIQ_Branch_Tree}    ${sBranch_Code.strip()}
    Mx Press Combination    KEY.ENTER
    Mx LoanIQ Click Button On Window    .*Branch.*;Informational Message.*;OK        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    
    ###Branch Update Window###
    mx LoanIQ activate window    ${LIQ_Branch_Update_Window}
    ${Branch_Description_Field}    Set Variable    JavaWindow("title:=Branch Update").JavaEdit("text:=${sExpected_Branch_Description}")
    ${Branch_Description_IsDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Branch_Description_Field}    VerificationData="Yes"
    Take Screenshot    Branch_Description
    Run Keyword If    ${Branch_Description_IsDisplayed}==True    Log    Branch Description ${sExpected_Branch_Description} is correct.
    Run Keyword If    ${Branch_Description_IsDisplayed}==False    Run Keyword And Continue On Failure    Fail    Branch Description ${sExpected_Branch_Description} for ${sFacilityID} is incorrect.
    
    mx LoanIQ close window    ${LIQ_Branch_Update_Window}

Get Branch value for FAC_CDE_BRANCH in VLS_FACILITY
    [Documentation]    This keyword retrieves the Branch value FAC_CDE_BRANCH for VLS_Facility
    ...    @author: ehugo    19SEP2019
    [Arguments]    ${sFacilityID}
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilitySummary_Tab}    Summary    
    mx LoanIQ click    ${LIQ_FacilityNotebook_InquiryMode_Button}
    mx LoanIQ click    ${LIQ_FacilitySummary_MainSG_Button}
    
    ###Main Customer Window###
    mx LoanIQ activate window    ${LIQ_MainCustomer_Window}
    ${Customer_Value}    Mx LoanIQ Get Data    ${LIQ_MainCustomer_Customer_List}    value%Customer_Value
    mx LoanIQ close window    ${LIQ_MainCustomer_Window}
    
    Run Keyword If    '${Customer_Value}'=='${EMPTY}'    Run Keywords    Run Keyword And Continue On Failure    Fail    Customer for Facility ID ${sFacilityID} does not exists.
    ...    AND    Take Screenshot    Failed_Branch
    ...    AND    mx LoanIQ select    ${LIQ_FacilityNotebook_Options_ChangeBranch_ProcArea}
    ...    AND    mx LoanIQ activate window    ${LIQ_FacilityNotebook_ChangeBranchProcArea_Window}
    ${Branch_Value}    Run Keyword If    '${Customer_Value}'=='${EMPTY}'    Mx LoanIQ Get Data    ${LIQ_FacilityNotebook_ChangeBranchProcArea_Branch_Field}    value%Branch_Value
    Run Keyword If    '${Customer_Value}'=='${EMPTY}'    mx LoanIQ close window    ${LIQ_FacilityNotebook_ChangeBranchProcArea_Window}
    
    [Return]    ${Customer_Value}    ${Branch_Value}
    
Validate FAC_DTE_TERM_FAC for VLS_FACILITY
    [Documentation]    This keyword validates FAC_DTE_TERM_FAC for VLS_Facility
    ...    @author: ehugo    18SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_TerminationDate_Value}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Run Keyword If    '${sExpected_TerminationDate_Value}'=='0'    Log    No Termination Date value in CSV for Facility ID ${sFacilityID}
    Return From Keyword If    '${sExpected_TerminationDate_Value}'=='0'    
    ${sExpected_TerminationDate_Value}    Convert CSV Date Format to LIQ Date Format    ${sExpected_TerminationDate_Value}
    
    ###Events Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_FacilitySummary_Tab}    Events    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityEvents_JavaTree}    Terminated%s
    ${EffectiveDate_Field}    Set Variable    JavaWindow("title:=Facility -.*").JavaStaticText("labeled_containers_path:=Tab:Events;Group:Event Details;","attached text:=${sExpected_TerminationDate_Value}")
    ${TerminationDate_IsDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${EffectiveDate_Field}    VerificationData="Yes"
    Take Screenshot    TerminationDate
    Run Keyword If    ${TerminationDate_IsDisplayed}==True    Log    Termination Date ${sExpected_TerminationDate_Value} for ${sFacilityID} is correct.
    Run Keyword If    ${TerminationDate_IsDisplayed}==False    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Expected Termination Date ${sExpected_TerminationDate_Value} does not exists in LIQ Facility Window

Validate FAC_DTE_FL_DRAWDWN for VLS_FACILITY - Events Tab
    [Documentation]    This keyword validates FAC_DTE_FL_DRAWDWN in Facility Notebook Events Tab for VLS_Facility
    ...    @author: ehugo    19SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_FL_Drawdown_Date_Value}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Run Keyword If    '${sExpected_FL_Drawdown_Date_Value}'=='0'    Log    No First Loan Drawdown Date value in CSV for Facility ID ${sFacilityID}
    Return From Keyword If    '${sExpected_FL_Drawdown_Date_Value}'=='0'    
    ${sExpected_FL_Drawdown_Date_Value}    Convert CSV Date Format to LIQ Date Format    ${sExpected_FL_Drawdown_Date_Value}
    
    ###Events Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_FacilitySummary_Tab}    Events    
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_FacilityEvents_JavaTree}    First Loan Drawdown Date Changed%s
    ${EffectiveDate_Field}    Set Variable    JavaWindow("title:=Facility -.*").JavaStaticText("labeled_containers_path:=Tab:Events;Group:Event Details;","attached text:=${sExpected_FL_Drawdown_Date_Value}")
    ${FL_Drawdown_Date_IsDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${EffectiveDate_Field}    VerificationData="Yes"
    Take Screenshot    FL_Drawdown_Date
    Run Keyword If    ${FL_Drawdown_Date_IsDisplayed}==True    Log    First Loan Drawdown Date ${sExpected_FL_Drawdown_Date_Value} for ${sFacilityID} is correct.
    Run Keyword If    ${FL_Drawdown_Date_IsDisplayed}==False    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Expected First Loan Drawdown Date ${sExpected_FL_Drawdown_Date_Value} does not exists in LIQ Facility Window    
    
Validate FAC_IND_COMMITTED for VLS_FACILITY
    [Documentation]    This keyword validates FAC_IND_COMMITTED for VLS_Facility
    ...    @author: ehugo    19SEP2019
    [Arguments]    ${sFacilityID}    ${sExpected_Committed_Value}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_FacilityTypeDetails}    
    
    ###Facility Type Details Window###
    mx LoanIQ activate window    ${LIQ_Facility_Type_Details_Window}
    ${Committed_IsDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_Type_Details_Committed_Field}    VerificationData="Yes"
    Take Screenshot    Committed
    Run Keyword If    '${sExpected_Committed_Value}'=='Y' and ${Committed_IsDisplayed}==True    Log    Committed is shown for ${sFacilityID}. Expected output is correct.
    Run Keyword If    '${sExpected_Committed_Value}'=='N' and ${Committed_IsDisplayed}==False    Log    Committed is not shown for ${sFacilityID}. Expected output is correct.
    Run Keyword If    '${sExpected_Committed_Value}'=='Y' and ${Committed_IsDisplayed}==False    Run Keyword And Continue On Failure    Fail    Committed is not shown for ${sFacilityID}. Expected out is incorrect.
    Run Keyword If    '${sExpected_Committed_Value}'=='N' and ${Committed_IsDisplayed}==True    Run Keyword And Continue On Failure    Fail    Committed is shown for ${sFacilityID}. Expected out is incorrect.
    
    mx LoanIQ click    ${LIQ_Facility_Type_Details_Exit_Button}    
    
Validate FAC_DTE_FL_DRAWDWN for VLS_FACILITY - Existing Loans Window
    [Documentation]    This keyword validates FAC_DTE_FL_DRAWDWN in Existing Loans Window for VLS_Facility
    ...    @author: ehugo    19SEP2019
    ...    For improvement
    [Arguments]    ${sFacilityID}    ${sExpected_FL_Drawdown_Date_Value}    
    
    Run Keyword If    '${sExpected_FL_Drawdown_Date_Value}'=='0'    Log    No First Loan Drawdown Date value in CSV for Facility ID ${sFacilityID}
    Return From Keyword If    '${sExpected_FL_Drawdown_Date_Value}'=='0'    
    ${sExpected_FL_Drawdown_Date_Value}    Convert CSV Date Format to LIQ Date Format without Zero    ${sExpected_FL_Drawdown_Date_Value}
    
    ###Outstanding Select Window###
    Navigate to Outstanding Select Window
    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Inactive_Checkbox}    ON
    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Pending_Checkbox}    ON
    ${Facility_Value}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Facility_Dropdown}    value%Facility_Value
    ${Facility_Length}    Get Length    ${Facility_Value.strip()}
    ${ExistingLoan_Window}    Run Keyword If    ${Facility_Length}>0    Set Variable    ${LIQ_ExistingLoansForFacility_Window}
    ...    ELSE    Set Variable    ${LIQ_ExistingLoansForDeal_Loan_Window}
    ${ExistingLoan_JavaTree}    Run Keyword If    ${Facility_Length}>0    Set Variable    ${LIQ_ExistingLoansForFacility_Loan_List}
    ...    ELSE    Set Variable    ${LIQ_ExistingLoansForDeal_Loan_List}
    
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    
    ###Existing Loans For Facility Window###
    mx LoanIQ activate window    ${ExistingLoan_Window}
    ${Effective_Date}    Mx LoanIQ Store TableCell To Clipboard   ${ExistingLoan_JavaTree}    ${sExpected_FL_Drawdown_Date_Value}%Effective Date%var    Processtimeout=10
    
    Take Screenshot    FL_Drawdown_Date_LoanList
    ${FL_Drawdown_Date_isEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpected_FL_Drawdown_Date_Value.strip()}    ${Effective_Date.strip()}       
    Run Keyword If    ${FL_Drawdown_Date_isEqual}==True    Log    First Loan Drawdown Date ${sExpected_FL_Drawdown_Date_Value} for ${sFacilityID} is correct.
    Run Keyword If    ${FL_Drawdown_Date_isEqual}==False    Run Keyword And Continue On Failure    Fail    Facility ID ${sFacilityID}: Expected First Loan Drawdown Date ${sExpected_FL_Drawdown_Date_Value} is not equal to Actual First Loan Drawdown Date ${Effective_Date}
    
    mx LoanIQ close window    ${ExistingLoan_Window}
    mx LoanIQ close window    ${LIQ_OutstandingSelect_Window}
    
Validate Records in VLS_FUNDING_DESK exist in LIQ
    [Documentation]    This keyword validates if records for VLS_FUNDING_DESK exist in LIQ
    ...    @author: amansuet    20SEP2019    - initial create
    [Arguments]    ${sCSV_Filename}    ${aDistinctData_List}
    
    ###Navigate to Actions -> Table Maintenance###  
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Funding Desk
    
    ###Search for the Funding Desk###
    mx LoanIQ activate window    ${LIQ_BrowseFundingDesk_Window}
    Mx LoanIQ Set    ${LIQ_BrowseFundingDesk_ShowALL_RadioBtn}    ON
    mx LoanIQ activate window    ${LIQ_BrowseFundingDesk_Window}
    
    ${count}    Get Length    ${aDistinctData_List}
    :FOR    ${INDEX}    IN RANGE    ${count}
    \    ${RowValue}    Set Variable    @{aDistinctData_List}[${INDEX}]
    \    ${Dictionary}    Get Reference Column Value using Source Column Value - Multi Reference    ${sCSV_Filename}    FDE_CDE_FUND_DESK    ${RowValue}    
         ...    FDE_IND_ACTIVE|FDE_DSC_FUND_DESK|FDE_CDE_CURRENCY|FDE_CDE_COUNTRY|FDE_CDE_OFFSET_EXP|FDE_PCT_TOLERANCE|FDE_TXT_TRS_CUTOFF
    \    ${FundDesk_StatusIndicator}    Get From Dictionary    ${Dictionary}    Value0
    \    ${FundDesk_Description}    Get From Dictionary    ${Dictionary}    Value1
    \    ${FundDesk_Currency}    Get From Dictionary    ${Dictionary}    Value2
    \    ${FundDesk_Country}    Get From Dictionary    ${Dictionary}    Value3
    \    ${FundDesk_OffsetExpense}    Get From Dictionary    ${Dictionary}    Value4
    \    ${FundDesk_FXRateTolerance}    Get From Dictionary    ${Dictionary}    Value5
    \    ${FundDesk_TreasuryCutOff}    Get From Dictionary    ${Dictionary}    Value6
    \    ${FundDesk_Code}    Set Variable    ${RowValue}
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BrowseFundingDesk_Tree}    ${FundDesk_StatusIndicator}\t${FundDesk_Code}\t${FundDesk_Description}\t${FundDesk_Currency}\t${FundDesk_Country}\t${FundDesk_OffsetExpense}\t${FundDesk_FXRateTolerance}\t${FundDesk_TreasuryCutOff}
    \    Run Keyword If    '${status}'=='${False}'    Run Keyword And Continue On Failure    Fail    Incorrect Funding Desk values in '${FundDesk_Code}' code are displayed in LIQ.
         ...    ELSE    Log    Correct Funding Desk values in '${FundDesk_Code}' code are displayed in LIQ.
    Take Screenshot    Funding_Desk
    Close All Windows on LIQ
    
Validate CSV values in LIQ for VLS_CROSS_CURRENCY
    [Documentation]    This keyword is used to validate values CRC_AMT_EXCHG_RATE field from CSV to Currency Exchange Rates in LIQ. 
    ...    @author: mgaling    20Sep2019    Initial Create
    [Arguments]    ${aTable_NameList}    ${sCRC_CDE_FUND_DESK_Index}    ${sCRC_CDE_CURRENCY_Index}    ${iCRC_AMT_EXCHG_RATE_Index}        
    
    ### Navigate to Currency Exchange Rates ###
    Select Treasury Navigation    Currency Exchange Rates
 
    ${Data_Rows}    Get Length    ${aTableName_List}
    :FOR    ${Index}    IN RANGE    1    ${Data_Rows}
    \    ${Table_NameList}    Set Variable    @{aTable_NameList}[${INDEX}]
    \    Log    ${Table_NameList} 
    \    ${FUND_DESK}    Remove String    @{Table_NameList}[${sCRC_CDE_FUND_DESK_Index}]    "
    \    ${CURRENCY}    Remove String    @{Table_NameList}[${sCRC_CDE_CURRENCY_Index}]    "
    \    ${AMT_EXCHG_RATE}    Remove String    @{Table_NameList}[${iCRC_AMT_EXCHG_RATE_Index}]    "
    \    
    \    ### Computation for the Equivalent FX Rate in LIQ ###
    \    ${Computed_Value}    Evaluate    1/${AMT_EXCHG_RATE}
    \    Log    ${Computed_Value}
    \    
    \    Run Keyword If    "${FUND_DESK.strip()}"=="AUD"    Run Keyword And Continue On Failure    Compare FX Rates from CSV to LIQ    ${FUND_DESK.strip()}    ${CURRENCY.strip()}    ${Computed_Value}       
    
    Close All Windows on LIQ
      
Compare FX Rates from CSV to LIQ
    [Documentation]    This keyword is used to compare FX Rates for AUD Funding Desk values from CSV to LIQ Screen.
    ...    @author: mgaling    20SEP2019    - initial Create
    ...    @update: mgaling    14OCT2020    - updated Mx Native Type    {ENTER} keyword into Mx Press Combination    KEY.ENTER
    [Arguments]    ${sFUND_DESK}    ${sCURRENCY}    ${iComputed_FXRateValue}   
    
    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}
    mx LoanIQ select    ${LIQ_ExchangeRate_FundingDesk_List}    Australian (Sydney)
    
    ${Exchange}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_CurrencyExchangeRate_Tree}    Exchange    Processtimeout=180
    ${status}    Run Keyword And Return Status    Should Contain    ${Exchange}    ${sFUND_DESK} to ${sCURRENCY}
    Run Keyword If    ${status}==False    Run Keywords    
    ...    Take Screenshot    Exchange_NotExist
    ...    AND    Run Keyword And Continue On Failure    Fail    Exchange '${sFUND_DESK} to ${sCURRENCY}' does not exist in LIQ Currency Exchange Rate List.
    Return From Keyword If    ${status}==False    
    
    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Tree}    ${sFUND_DESK} to ${sCURRENCY}
    Mx Press Combination    KEY.ENTER
    
    ### Please Enter Currency Exchange Rate Window ###
    mx LoanIQ activate window    ${LIQ_ExchangeRate_Window}    
    Take Screenshot    ${sFUND_DESK}_${sCURRENCY}
    
    ${ActualValue}    Mx LoanIQ Get Data    ${LIQ_ExchangeRate_Field}    value
    ${ActualValue}    Convert To Number    ${ActualValue}
    Log    ${ActualValue}
    
    ${iComputed_FXRateValue}    Convert To Number    ${iComputed_FXRateValue}    
    
    ${status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${ActualValue}    ${iComputed_FXRateValue}
    Run Keyword If    ${status}==True    Log    ${ActualValue}=${iComputed_FXRateValue}     
    mx LoanIQ click    ${LIQ_ExchangeRate_Cancel_Button}
    
Validate CSV values in LIQ for VLS_CURRENCY
    [Documentation]    This keyword is used to validate values CCY_DSC_CURRENCY and CCY_IND_ACTIVE fields values from CSV to Currency in LIQ. 
    ...    @author: mgaling    20Sep2019    Initial Create
    [Arguments]    ${aTable_NameList}    ${sCCY_CDE_CURRENCY_Index}    ${sCCY_DSC_CURRENCY_Index}    ${sCCY_IND_ACTIVE_Index}        
    
    ### Navigate to Currency Exchange Rates ###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Currency
 
    ${Data_Rows}    Get Length    ${aTableName_List}
    :FOR    ${Index}    IN RANGE    1    ${Data_Rows}
    \    ${Table_NameList}    Set Variable    @{aTable_NameList}[${INDEX}]
    \    Log    ${Table_NameList}
    \    ${CDE_CURRENCY}    Remove String    @{Table_NameList}[${sCCY_CDE_CURRENCY_Index}]    " 
    \    ${DSC_CURRENCY}    Remove String    @{Table_NameList}[${sCCY_DSC_CURRENCY_Index}]    "
    \    ${IND_ACTIVE}    Remove String    @{Table_NameList}[${sCCY_IND_ACTIVE_Index}]    "
    \    
    \    Run Keyword If    "${DSC_CURRENCY.strip()}"!="${EMPTY}"    Run Keyword And Continue On Failure    Check Currency Description from CSV to LIQ    ${CDE_CURRENCY.strip()}    ${DSC_CURRENCY.strip()}    ${IND_ACTIVE.strip()}      
    
    Close All Windows on LIQ

Check Currency Description from CSV to LIQ
    [Documentation]    This keyword is used to check the Currency Description and Active Indicator values from CSV to LIQ Screen.
    ...    @author: mgaling    20SEP2019    - initial create
    ...    @update: mgaling    19FEB2020    - Added ${sIND_ACTIVE} on select string keyword
    ...    @update: mgaling    14OCT2020    - updated Mx Native Type    {ENTER} keyword into Mx Press Combination    KEY.ENTER
    [Arguments]    ${sCDE_CURRENCY}    ${sDSC_CURRENCY}    ${sIND_ACTIVE}   
    
    mx LoanIQ activate window    ${LIQ_BrowseCurrency_Window}
    mx LoanIQ enter    ${LIQ_BrowseCurrency_ShowAllButton}    ON
    
    Mx LoanIQ Select String    ${LIQ_BrowseCurrency_Tree}    ${sIND_ACTIVE}\t${sCDE_CURRENCY}\t${sDSC_CURRENCY}
    Mx Press Combination    KEY.ENTER
    
    ### Currency Update Winodw Validation ###
    mx LoanIQ activate window    ${LIQ_CurrencyUpdate_Window}    
    Take Screenshot    ${sCDE_CURRENCY}
    Mx LoanIQ Verify Runtime Property    ${LIQ_CurrencyUpdate_Description_Field}    value%${sDSC_CURRENCY}
                
    Run Keyword If    "${sIND_ACTIVE}"=="Y"    Run Keywords    Log    Currency Code ${sCDE_CURRENCY} is Active
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_CurrencyUpdate_Active_CheckBox}    value%1
    ...    ELSE IF    "${sIND_ACTIVE}"=="N"    Run Keywords    Log    Currency Code ${sCDE_CURRENCY} is Inactive
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_CurrencyUpdate_Active_CheckBox}    value%0
    
    mx LoanIQ click    ${LIQ_CurrencyUpdate_Cancel_Button}

Validate CSV Values in LIQ for VLS_FUNDING_DESK
    [Documentation]    This keyword validates values FDE_CDE_FUND_DESK, FDE_DSC_FUND_DESK and FDE_IND_ACTIVE fields values from CSV to Currency in LIQ. 
    ...    @author: amansuet    20SEP2019    - initial create
    [Arguments]    ${aTable_NameList}    ${sFDE_IND_ACTIVE_Index}    ${sFDE_DSC_FUND_DESK_Index}    ${sFDE_CDE_FUND_DESK_Index}
    
    ###Navigate to Actions -> Table Maintenance###  
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Funding Desk
    
    ###Search for the Funding Desk###
    mx LoanIQ activate window    ${LIQ_BrowseFundingDesk_Window}
    Mx LoanIQ Set    ${LIQ_BrowseFundingDesk_ShowALL_RadioBtn}    ON
    mx LoanIQ activate window    ${LIQ_BrowseFundingDesk_Window}
    
    ${Data_Rows}    Get Length    ${aTable_NameList}
    :FOR    ${INDEX}    IN RANGE    1    ${Data_Rows}
    \    ${Table_NameList}    Set Variable    @{aTable_NameList}[${INDEX}]
    \    Log    ${Table_NameList}
    \    ${FDE_IND_ACTIVE}    Remove String    @{Table_NameList}[${sFDE_IND_ACTIVE_Index}]    "
    \    ${FDE_DSC_FUND_DESK}    Remove String    @{Table_NameList}[${sFDE_DSC_FUND_DESK_Index}]    "
    \    ${FDE_CDE_FUND_DESK}    Remove String    @{Table_NameList}[${sFDE_CDE_FUND_DESK_Index}]    "
    \    Run Keyword If    "${FDE_DSC_FUND_DESK.strip()}"!="${EMPTY}"    Run Keyword And Continue On Failure    Check Funding Desk Description from CSV to LIQ     ${FDE_CDE_FUND_DESK.strip()}    ${FDE_DSC_FUND_DESK.strip()}    ${FDE_IND_ACTIVE.strip()}      

    Close All Windows on LIQ
    
Check Funding Desk Description from CSV to LIQ
    [Documentation]    This keyword is used to check the Funding Desk Description and Active Indicator values from CSV to LIQ Screen.
    ...    @author: amansuet    20SEP2020    - initial create
    ...    @update: mgaling    14OCT2020    - updated Mx Native Type    {ENTER} keyword into Mx Press Combination    KEY.ENTER
    [Arguments]    ${sFDE_CDE_FUND_DESK}    ${sFDE_DSC_FUND_DESK}    ${sFDE_IND_ACTIVE}   
    
    mx LoanIQ activate window    ${LIQ_BrowseFundingDesk_Window}
    mx LoanIQ enter    ${LIQ_BrowseFundingDesk_ShowALL_RadioBtn}    ON
    
    Mx LoanIQ Select String    ${LIQ_BrowseFundingDesk_Tree}    ${sFDE_CDE_FUND_DESK}\t${sFDE_DSC_FUND_DESK}
    Mx Press Combination    KEY.ENTER
    
    ### Funding Desk Update Window Validation ###
    mx LoanIQ activate window    ${LIQ_FundingDeskUpdate_Window}    
    Take Screenshot    ${sFDE_CDE_FUND_DESK}
    Mx LoanIQ Verify Runtime Property    ${LIQ_FundingDeskUpdate_Window_Description_Field}    value%${sFDE_DSC_FUND_DESK}
                
    Run Keyword If    "${sFDE_IND_ACTIVE}"=="Y"    Run Keywords    Log    Funding Desk Code ${sFDE_CDE_FUND_DESK} is Active
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_FundingDeskUpdate_Window_Active_Checkbox}    value%1
    ...    ELSE IF    "${sFDE_IND_ACTIVE}"=="N"    Run Keywords    Log    Funding Desk Code ${sFDE_CDE_FUND_DESK} is Inactive
    ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_FundingDeskUpdate_Window_Active_Checkbox}    value%0
    
    mx LoanIQ click    ${LIQ_FundingDeskUpdate_Window_Cancel_Button}

Validate CSV values in LIQ for VLS_PROD_POS_CUR
    [Documentation]    This keyword is used to validate fields values from CSV in LIQ. 
    ...    @author: mgaling    23SEP2019    - initial create
    ...    @update: mgaling    25OCT2020    - added Get Index From List keywords and updated FOR LOOP keywords
    [Arguments]    ${aCSV_Content}        
    
    ### Read and Get the Index of the Fields from CSV File ###
    ${header}    Get From List    ${aCSV_Content}    0
    
    ${PDC_PID_PRODUCT_ID_Index}    Get Index From List    ${header}    PDC_PID_PRODUCT_ID
    ${PDC_CDE_PROD_TYPE_Index}    Get Index From List    ${header}    PDC_CDE_PROD_TYPE
    
    ${PDC_AMT_BNK_NT_CMT_Index}    Get Index From List    ${header}    PDC_AMT_BNK_NT_CMT
    ${PDC_AMT_BNK_GR_OUT_Index}    Get Index From List    ${header}    PDC_AMT_BNK_GR_OUT
    ${PDC_AMT_BNK_NT_OUT_Index}    Get Index From List    ${header}    PDC_AMT_BNK_NT_OUT
    ${PDC_AMT_GLOBAL_CMT_Index}    Get Index From List    ${header}    PDC_AMT_GLOBAL_CMT
    ${PDC_AMT_BNK_GR_CMT_Index}    Get Index From List    ${header}    PDC_AMT_BNK_GR_CMT

    ${Data_Rows}    Get Length    ${aCSV_Content}
    
    :FOR    ${Index}    IN RANGE    1    ${Data_Rows}
    \    ${Table_NameList}    Set Variable    @{aCSV_Content}[${INDEX}]
    \    Log    ${Table_NameList}
    \    ${PID_PRODUCT_ID}    Remove String    @{Table_NameList}[${PDC_PID_PRODUCT_ID_Index}]    " 
    \    ${CDE_PROD_TYPE}    Remove String    @{Table_NameList}[${PDC_CDE_PROD_TYPE_Index}]    "
    \    ${AMT_BNK_NT_CMT}    Remove String    @{Table_NameList}[${PDC_AMT_BNK_NT_CMT_Index}]    " 
    \    ${AMT_BNK_GR_OUT}    Remove String    @{Table_NameList}[${PDC_AMT_BNK_GR_OUT_Index}]    "
    \    ${AMT_BNK_NT_OUT}    Remove String    @{Table_NameList}[${PDC_AMT_BNK_NT_OUT_Index}]    "
    \    ${AMT_GLOBAL_CMT}    Remove String    @{Table_NameList}[${PDC_AMT_GLOBAL_CMT_Index}]    "
    \    ${AMT_BNK_GR_CMT}    Remove String    @{Table_NameList}[${PDC_AMT_BNK_GR_CMT_Index}]    "
    \    
    \    ${RID_IsExist}    Run Keyword If    "${PID_PRODUCT_ID}"!="${EMPTY}" and "${CDE_PROD_TYPE.strip()}"=="DEA"     Run Keyword And Return Status     Navigate to Notebook Window thru RID    Deal    ${PID_PRODUCT_ID.strip()}
         ...    ELSE IF    "${PID_PRODUCT_ID}"!="${EMPTY}" and "${CDE_PROD_TYPE.strip()}"=="FAC"     Run Keyword And Return Status     Navigate to Notebook Window thru RID    Facility    ${PID_PRODUCT_ID.strip()}
         ...    ELSE    Log    PID_PRODUCT_ID is empty or ${CDE_PROD_TYPE} is not yet configured.        
    \    Run Keyword If    ${RID_IsExist}==${True} and "${CDE_PROD_TYPE.strip()}"=="DEA"    Run Keyword And Continue On Failure    Check VLS_PROD_POS_CUR values in Deal Notebook    ${AMT_GLOBAL_CMT.strip()}    ${AMT_BNK_GR_CMT.strip()}    
         ...    ELSE IF    ${RID_IsExist}==${True} and "${CDE_PROD_TYPE.strip()}"=="FAC"    Run Keyword And Continue On Failure    Check VLS_PROD_POS_CUR values in Facility Notebook    ${AMT_BNK_NT_CMT.strip()}    ${AMT_BNK_NT_OUT.strip()}    ${AMT_BNK_GR_OUT.strip()}
         ...    ELSE IF    ${RID_IsExist}==${False}    Run Keyword And Continue On Failure    FAIL    RID ${PID_PRODUCT_ID} does not exist!
         ...    ELSE    Log    PID_PRODUCT_ID is empty or ${CDE_PROD_TYPE} is not yet configured.
    \   Close All Windows on LIQ

Check VLS_PROD_POS_CUR values in Deal Notebook
    [Documentation]    This keyword is used to validate the values of the fields PDC_AMT_GLOBAL_CMT and PDC_AMT_BNK_GR_CMT from CSV to LIQ Screen.
    ...    @author: mgaling    23SEP2019    - initial Create
    ...    @update: mgaling    25OCT2020    - added keywords to handle alert window, updated locators and added screenshot path
    [Arguments]    ${iAMT_GLOBAL_CMT}    ${iAMT_BNK_GR_CMT}
    
    ### Alert Window Validation ###
    :FOR    ${i}    IN RANGE    15
    \    ${AlertsWindow_isDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_Alerts_Window}         VerificationData="Yes"
    \    Run Keyword If     ${AlertsWindow_isDisplayed}==${True}    Run Keywords
         ...    mx LoanIQ activate window    ${LIQ_Facility_Alerts_Window}
         ...    AND    mx LoanIQ click    ${LIQ_Facility_Alerts_Cancel_Button}
         ...    AND    Mx Activate Window    ${LIQ_FacilityNotebook_Window}
    \    Exit For Loop If    ${AlertsWindow_isDisplayed}==${True}     
    
    ### Deal Notebook Validation ###
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Summary
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Deal_Notebook
    
    ### PDC_AMT_GLOBAL_CMT Validation ###
    ${UI_AMT_GLOBAL_CMT}    Mx LoanIQ Get Data    ${LIQ_DealSummary_ClosingCmt_Text}    text
    ${UI_AMT_GLOBAL_CMT}    Remove Comma and Convert to Number    ${UI_AMT_GLOBAL_CMT}
    
    ${iAMT_GLOBAL_CMT}    Convert To Number    ${iAMT_GLOBAL_CMT}    
    
    ${status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${iAMT_GLOBAL_CMT}    ${UI_AMT_GLOBAL_CMT}
    Run Keyword If    ${status}==${True}    Log    CSV value(${iAMT_GLOBAL_CMT}) and UI Value (${UI_AMT_GLOBAL_CMT}) are matched!
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    CSV value(${iAMT_GLOBAL_CMT}) and UI Value (${UI_AMT_GLOBAL_CMT}) are not matched!  
    
    ### PDC_AMT_BNK_GR_CMT Validation ###
    ${UI_AMT_BNK_GR_CMT}    Mx LoanIQ Get Data    ${LIQ_DealSummary_HBClosingCmt_Text}    text
    ${UI_AMT_BNK_GR_CMT}    Remove Comma and Convert to Number    ${UI_AMT_BNK_GR_CMT}
    
    ${iAMT_BNK_GR_CMT}    Convert To Number    ${iAMT_BNK_GR_CMT}    
    
    ${status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${iAMT_BNK_GR_CMT}    ${UI_AMT_BNK_GR_CMT}
    Run Keyword If    ${status}==${True}    Log    CSV value(${iAMT_BNK_GR_CMT}) and UI Value (${UI_AMT_BNK_GR_CMT}) are matched!
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    CSV Value (${iAMT_BNK_GR_CMT}) and UI Value (${UI_AMT_BNK_GR_CMT}) are not matched! 
        
    mx LoanIQ close window    ${LIQ_DealNotebook_Window}
         
    
Check VLS_PROD_POS_CUR values in Facility Notebook
    [Documentation]    This keyword is used to validate the values of the fields PDC_AMT_BNK_NT_CMT, PDC_AMT_BNK_GR_OUT and PDC_AMT_BNK_NT_OUT from CSV to LIQ Screen.
    ...    @author: mgaling    23SEP2019    - initial create
    ...    @update: mgaling    25OCT2020    - added keywords to handle alert window, updated locators and added screenshot path
    [Arguments]    ${iAMT_BNK_NT_CMT}    ${iAMT_BNK_NT_OUT}    ${iAMT_BNK_GR_OUT}         
    
    ### Alert Window Validation ###
    :FOR    ${i}    IN RANGE    15
    \    ${AlertsWindow_isDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Facility_Alerts_Window}         VerificationData="Yes"
    \    Run Keyword If     ${AlertsWindow_isDisplayed}==${True}    Run Keywords
         ...    mx LoanIQ activate window    ${LIQ_Facility_Alerts_Window}
         ...    AND    mx LoanIQ click    ${LIQ_Facility_Alerts_Cancel_Button}
         ...    AND    Mx Activate Window    ${LIQ_FacilityNotebook_Window}
    \    Exit For Loop If    ${AlertsWindow_isDisplayed}==${True} 
    
    ### Facility Notebook ###
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Facility_Notebook
    
    ###    PDC_AMT_BNK_NT_CMT: Net gross amount of the Facility ###
    ${UI_AMT_BNK_NT_CMT}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_NetCmt}    text
    ${UI_AMT_BNK_NT_CMT}    Remove Comma and Convert to Number    ${UI_AMT_BNK_NT_CMT}
    
    ${iAMT_BNK_NT_CMT}    Convert To Number    ${iAMT_BNK_NT_CMT}    2    
    
    ${status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${iAMT_BNK_NT_CMT}    ${UI_AMT_BNK_NT_CMT}
    Run Keyword If    ${status}==${True}    Log    CSV value(${iAMT_BNK_NT_CMT}) and UI Value (${UI_AMT_BNK_NT_CMT}) are matched!
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    CSV value(${iAMT_BNK_NT_CMT}) and UI Value (${UI_AMT_BNK_NT_CMT}) are not matched!  
    
    
    ###    PDC_AMT_BNK_GR_OUT: Verify the gross effective utilisation of the facility ###
    ${UI_AMT_BNK_NT_OUT}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_Outstandings_Funded}    text
    ${UI_AMT_BNK_NT_OUT}    Remove Comma and Convert to Number    ${UI_AMT_BNK_NT_OUT}
    
    ${iAMT_BNK_NT_OUT}    Convert To Number    ${iAMT_BNK_NT_OUT}    2    
    
    ${status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${iAMT_BNK_NT_OUT}    ${UI_AMT_BNK_NT_OUT}
    Run Keyword If    ${status}==${True}    Log    CSV value(${iAMT_BNK_NT_OUT}) and UI Value (${UI_AMT_BNK_NT_OUT}) are matched!
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    CSV value(${iAMT_BNK_NT_OUT}) and UI Value (${UI_AMT_BNK_NT_OUT}) are not matched! 
    
    ###    PDC_AMT_BNK_GR_OUT: Verify the gross effective utilisation of the facility ###
    ${UI_AMT_BNK_GR_OUT}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_Outstandings}    text
    ${UI_AMT_BNK_GR_OUT}    Remove Comma and Convert to Number    ${UI_AMT_BNK_GR_OUT}
    
    ${iAMT_BNK_GR_OUT}    Convert To Number    ${iAMT_BNK_GR_OUT}    2
    
    ${status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${iAMT_BNK_GR_OUT}    ${UI_AMT_BNK_GR_OUT}
    Run Keyword If    ${status}==${True}    Log    CSV value(${iAMT_BNK_GR_OUT}) and UI Value (${UI_AMT_BNK_GR_OUT}) are matched!
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    CSV value(${iAMT_BNK_GR_OUT}) and UI Value (${UI_AMT_BNK_GR_OUT}) are not matched!
    
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}

Validate CSV values in Loan IQ for VLS_PROD_GUARANTEE
    [Documentation]    This keyword is used to navigate on LIQbased on product type and validate guarantor.
    ...    @author: dahijara    23SEP2019
    [Arguments]    ${sCSV_Content}    ${sProd_Type_Header_Index}    ${sProd_Id_Header_Index}    ${sCust_Id_Header_Index}    ${sGuarantor_Exp_Dt_Header_Index}
    
    ${Row_Count}    Get Length    ${sCSV_Content}
    
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${sCSV_Content}    ${i}
    \    ${val_Prod_Type}    Get From List    ${Table_Row_Item}    ${sProd_Type_Header_Index}
    \    ${val_Prod_Type}    Strip String    ${val_Prod_Type}
    \    ${val_Prod_Id}    Get From List    ${Table_Row_Item}    ${sProd_Id_Header_Index}
    \    ${val_Cust_Id}    Get From List    ${Table_Row_Item}    ${sCust_Id_Header_Index}
    \    ${val_Guarantor_Exp_Dt}    Get From List    ${Table_Row_Item}    ${sGuarantor_Exp_Dt_Header_Index}
    \    ${val_Guarantor_Exp_Dt}    Run Keyword If    '${val_Guarantor_Exp_Dt}'!='${EMPTY}'    Convert Date With Zero    ${val_Guarantor_Exp_Dt}
    \    Refresh Tables in LIQ
    \    ${val_Guarantor_ShortName}    Run Keyword If    '${val_Prod_Type}'=='FAC' or '${val_Prod_Type}'=='DEA'    Run Keyword And Continue On Failure    Get and Return Guarantor Short Name Using Customer RID    ${val_Cust_Id}
    \    
    \    ${RID_IsExist}    Run Keyword If    '${val_Prod_Type}'=='DEA'    Run Keyword And Return Status    Navigate to Notebook Window thru RID    Deal    ${val_Prod_Id}
         ...    ELSE IF    '${val_Prod_Type}'=='FAC'    Run Keyword And Return Status    Navigate to Notebook Window thru RID    Facility    ${val_Prod_Id}
    \    Run Keyword If    "${RID_IsExist}"=="${False}"    Run Keyword And Continue On Failure    Fail    ${val_Prod_Id} does not exist!
    \    
    \    Run Keyword If    '${val_Prod_Type}'=='DEA' and '${RID_IsExist}'=='${True}'    Run Keyword And Continue On Failure    Validate Guarantor in Deal NoteBook    ${val_Guarantor_ShortName}    ${val_Guarantor_Exp_Dt}
         ...    ELSE IF    '${val_Prod_Type}'=='FAC' and '${RID_IsExist}'=='${True}'    Run Keyword And Continue On Failure    Validate Guarantor in Facility NoteBook    ${val_Guarantor_ShortName}    ${val_Guarantor_Exp_Dt}
    
Validate Guarantor in Deal NoteBook
    [Documentation]    This keyword is used to navigate on Deal noteboook and validate guarantor.
    ...    @author: dahijara    23SEP2019
    [Arguments]    ${sGuarantor_ShortName}    ${dPolRIskExpiry}
    
    ### Launch DEAL Notebook ### 
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_JavaTab}    Risk/Regulatory
    
    Mx LoanIQ Select String    ${LIQ_RiskRegulatory_Guarantees_JavaTree}    ${sGuarantor_ShortName}
    Take Screenshot    Risk_Regulatory_Tab
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_RiskRegulatory_Guarantees_JavaTree}    ${sGuarantor_ShortName}%d
    ### Deal Guarantor Details ###
    mx LoanIQ activate window    ${LIQ_DealGuarantorDetails_Window}
    Take Screenshot    DealGuarantorDetails_Window
    ${Deal_Guarantor_Short_Name}    Mx LoanIQ Get Data    ${LIQ_DealGuarantorDetails_Guarantor_JavaEdit}    Deal_Guarantor_Short_Name
    
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sGuarantor_ShortName}    ${Deal_Guarantor_Short_Name}
    Run Keyword If    ${IsEqual}==${True}    Log    Deal Guarantor and Customer Guarantor are equal. ${sGuarantor_ShortName}=${Deal_Guarantor_Short_Name}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Deal Guarantor and Customer Guarantor are NOT equal. ${sGuarantor_ShortName}!=${Deal_Guarantor_Short_Name}

    Run Keyword If    '${dPolRIskExpiry}'!='${EMPTY}' and '${dPolRIskExpiry}'!='None'    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_DealGuarantorDetails_PolRiskExpiry_JavaEdit}    value%${dPolRIskExpiry}
    
    Refresh Tables in LIQ

Validate Guarantor in Facility NoteBook
    [Documentation]    This keyword is used to navigate on Facility noteboook and validate guarantor.
    ...    @author: dahijara    23SEP2019
    [Arguments]    ${sGuarantor_ShortName}    ${dPolRIskExpiry}
    
    ### Facility Notebook ### 
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Risk
    Mx LoanIQ Select String    ${LIQ_FacilityNoteBook_Risk_Guarantees_JavaTree}    ${sGuarantor_ShortName}
    Take Screenshot    FacilityNoteBook_Risk_Tab
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_FacilityNoteBook_Risk_Guarantees_JavaTree}    ${sGuarantor_ShortName}%d
    ### Facility Guarantor Details ###
    mx LoanIQ activate window    ${LIQ_FacilityGuarantorDetails_Window}
    Take Screenshot    FacilityGuarantorDetails_Window
    ${Facility_Guarantor_Short_Name}    Mx LoanIQ Get Data    ${LIQ_FacilityGuarantorDetails_Guarantor_JavaEdit}    Facility_Guarantor_Short_Name
    
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sGuarantor_ShortName}    ${Facility_Guarantor_Short_Name}
    Run Keyword If    ${IsEqual}==${True}    Log    Facility Guarantor and Customer Guarantor are equal. ${sGuarantor_ShortName}=${Facility_Guarantor_Short_Name}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Facility Guarantor and Customer Guarantor are NOT equal. ${sGuarantor_ShortName}!=${Facility_Guarantor_Short_Name}

    Run Keyword If    '${dPolRIskExpiry}'!='${EMPTY}' and '${dPolRIskExpiry}'!='None'    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_FacilityGuarantorDetails_PolRiskExpiry_JavaEdit}    value%${dPolRIskExpiry}
    
    mx LoanIQ close window    ${LIQ_FacilityGuarantorDetails_Window}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Events
    
    ${isExisting}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_FacilityEvents_JavaTree}    Facility Change Transaction Released
    Take Screenshot    FacilityNoteBook_EventsTab
    Run Keyword If    ${isExisting}==${True}    Validate Guarantor in Facility Change Transaction NoteBook    ${sGuarantor_ShortName}    ${dPolRIskExpiry}

Validate Guarantor in Facility Change Transaction NoteBook
    [Documentation]    This keyword is used to navigate on Facility noteboook and validate guarantor.
    ...    @author: dahijara    23SEP2019
    [Arguments]    ${sGuarantor_ShortName}    ${dPolRIskExpiry}
    
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_FacilityEvents_JavaTree}    Facility Change Transaction Released%d
    
    ### Launch FCT Notebook ### 
    mx LoanIQ activate window    ${LIQ_FacilityChangeTransaction_ReleasedWindow}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityChangeTransaction_Tab}    Guarantees
    Mx LoanIQ Select String    ${LIQ_FacilityChangeTransaction_Guarantees_Javatree}    ${sGuarantor_ShortName}
    Take Screenshot    FCT_Guarantees_Tab
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_FacilityChangeTransaction_Guarantees_Javatree}    ${sGuarantor_ShortName}%d
    
    ### Facility Guarantor Details ###
    mx LoanIQ activate window    ${LIQ_FacilityGuarantorDetails_Window}
    Take Screenshot    FacilityGuarantorDetails_Window
    ${Facility_Guarantor_Short_Name}    Mx LoanIQ Get Data    ${LIQ_FacilityGuarantorDetails_Guarantor_JavaEdit}    Facility_Guarantor_Short_Name
    
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${sGuarantor_ShortName}    ${Facility_Guarantor_Short_Name}
    Run Keyword If    ${IsEqual}==${True}    Log    Facility Guarantor and Customer Guarantor are equal. ${sGuarantor_ShortName}=${Facility_Guarantor_Short_Name}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Facility Guarantor and Customer Guarantor are NOT equal. ${sGuarantor_ShortName}!=${Facility_Guarantor_Short_Name}

    Run Keyword If    '${dPolRIskExpiry}'!='${EMPTY}' and '${dPolRIskExpiry}'!='None'    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_FacilityGuarantorDetails_PolRiskExpiry_JavaEdit}    value%${dPolRIskExpiry}
    
    mx LoanIQ close window    ${LIQ_FacilityGuarantorDetails_Window}
    

Get and Return Guarantor Short Name Using Customer RID
    [Documentation]    This keyword is used to navigate on Deal noteboook and validate guarantor.
    ...    @author: dahijara    23SEP2019
    [Arguments]    ${sCust_Id}
   
    ### Launch Active Customer Window ### 
    Navigate to Notebook Window thru RID    Customer    ${sCust_Id}
    mx LoanIQ activate window    ${LIQ_ActiveCustomer_Window}
    Take Screenshot    ActiveCustomer_Window
    ${Guarantor_Short_Name}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_ShortName}    Guarantor_Short_Name
    
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}    
    
    [Return]    ${Guarantor_Short_Name}
      
Validate CSV values in Loan IQ for VLS_DEAL_BORROWER
    [Documentation]    This keyword is used to navigate on LIQbased on product type and validate guarantor.
    ...    @author: dahijara    24SEP2019
    [Arguments]    ${sCSV_Content}    ${sProd_Id_Header_Index}    ${sCust_Id_Header_Index}    ${sBorrowerInd_Header_Index}    ${sDepositorInd_Header_Index}
    
    ${Row_Count}    Get Length    ${sCSV_Content}
    
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${sCSV_Content}    ${i}
    \    ${val_Prod_Id}    Get From List    ${Table_Row_Item}    ${sProd_Id_Header_Index}
    \    ${val_Cust_Id}    Get From List    ${Table_Row_Item}    ${sCust_Id_Header_Index}
    \    ${val_BorrowerInd}    Get From List    ${Table_Row_Item}    ${sBorrowerInd_Header_Index}
    \    ${val_DepositorInd}    Get From List    ${Table_Row_Item}    ${sDepositorInd_Header_Index}
    \    Refresh Tables in LIQ
    \    ${val_ShortName}    Run Keyword And Continue On Failure    Get and Return Guarantor Short Name Using Customer RID    ${val_Cust_Id}
    \    
    \    ${RID_IsExist}    Run Keyword And Return Status    Navigate to Notebook Window thru RID    Deal    ${val_Prod_Id}
    \    Run Keyword If    "${RID_IsExist}"=="${False}"    Run Keyword And Continue On Failure    Fail    ${val_Prod_Id} does not exist!
    \    Run Keyword If    "${RID_IsExist}"=="${True}"    Run Keyword And Continue On Failure    Validate Borrower in Deal NoteBook    ${val_ShortName}    ${val_BorrowerInd}    ${val_DepositorInd}

Validate Borrower in Deal NoteBook
    [Documentation]    This keyword is used to navigate on Deal noteboook and validate guarantor.
    ...    @author: dahijara    23SEP2019
    [Arguments]    ${sShortName}    ${sBorrowerInd}    ${sDepositorInd}
    
    ### Launch DEAL Notebook ### 
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select String        ${LIQ_DealSummary_BorrowerDepositor_JavaTree}    ${sShortName}
    Take Screenshot    Deal_Summary_Tab
    
    ### Validate Borrower Indicator ###
    ${val_Borrower}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_DealSummary_BorrowerDepositor_JavaTree}    ${sShortName}%Borrower%val_Borrower
    ${IsMatched}    Run Keyword And Return Status    Should Be Equal As Strings    ${val_Borrower}    ${sBorrowerInd}
    Run Keyword If    ${IsMatched}==${True}    Log    Borrower Indicators are equal. CSV Borrower Indicator: ${val_Borrower} = LIQ Deal Borrower Indicator: ${sBorrowerInd}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Borrower Indicators are NOT equal. CSV Borrower Indicator: ${val_Borrower} != LIQ Deal Borrower Indicator: ${sBorrowerInd}
    
    ### Validate Depositor Indicator ###
    ${val_Depositor}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_DealSummary_BorrowerDepositor_JavaTree}    ${sShortName}%Depositor%val_Depositor
    ${IsMatched}    Run Keyword And Return Status    Should Be Equal As Strings    ${val_Depositor}    ${sDepositorInd}
    Run Keyword If    ${IsMatched}==${True}    Log    Depositor Indicators are equal. CSV Depositor Indicator: ${val_Depositor} = LIQ Deal Depositor Indicator: ${sDepositorInd}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Depositor Indicators are NOT equal. CSV Depositor Indicator: ${val_Depositor} != LIQ Deal Depositor Indicator: ${sDepositorInd}
    
    ### Select Short Name Row ###
    Mx LoanIQ Select Or Doubleclick In Javatree    ${LIQ_DealSummary_BorrowerDepositor_JavaTree}    ${sShortName}%d
    
    ### Deal Guarantor Details ###
    mx LoanIQ activate window    ${LIQ_DealBorrower_Window}
    Take Screenshot    DealBorrower_Window
    
    ${ShortName_Locator}    Set Static Text to Locator Single Text    Deal Borrower    ${sShortName}
    ${isExisting}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${ShortName_Locator}    VerificationData="Yes"
    Run Keyword If    ${isExisting}==${True}    Log    Borrower ${sShortName} exists in Deal Borrower window.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Borrower ${sShortName} does NOT exist in Deal Borrower window.

    Refresh Tables in LIQ  

Validate CSV values in Loan IQ for VLS_FAC_BORR_DETL
    [Documentation]    This keyword is used to navigate on LIQbased on product type and validate guarantor.
    ...    @author: dahijara    24SEP2019
    [Arguments]    ${sCSV_Content}    ${sFacility_Id_Header_Index}
    ...    ${sBorrower_Details_RID_Header_Index}    ${sFBD_Active_Ind_Header_Index}    ${sFBD_RID_DEAL_BORR_Header_Index}    ${Target_CSV_File}
    
    ${Row_Count}    Get Length    ${sCSV_Content}
    
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${sCSV_Content}    ${i}
    \    
    \    ${val_FBD_RID_DEAL_BORR}    Get From List    ${Table_Row_Item}    ${sFBD_RID_DEAL_BORR_Header_Index}
    \    ${val_Cust_Id}    Run Keyword And Continue On Failure    Get Single Data From CSV File    ${Target_CSV_File}    DBR_RID_DEAL_BORR    ${val_FBD_RID_DEAL_BORR}    DBR_CID_CUST_ID
    \    ${val_Facility_Id}    Get From List    ${Table_Row_Item}    ${sFacility_Id_Header_Index}
    \    ${val_Borrower_Details_RID}    Get From List    ${Table_Row_Item}    ${sBorrower_Details_RID_Header_Index}
    \    ${val_sFBD_Active_Ind}    Get From List    ${Table_Row_Item}    ${sFBD_Active_Ind_Header_Index}
    \    
    \    Refresh Tables in LIQ
    \    ${val_ShortName}    Run Keyword And Continue On Failure    Get and Return Guarantor Short Name Using Customer RID    ${val_Cust_Id}
    \    Refresh Tables in LIQ
    \    ${RID_IsExist}    Run Keyword And Return Status    Navigate to Notebook Window thru RID    Facility    ${val_Facility_Id}
    \    Run Keyword If    "${RID_IsExist}"=="${False}"    Run Keyword And Continue On Failure    Fail    ${val_Facility_Id} does not exist!
    \    Run Keyword If    "${RID_IsExist}"=="${True}" and '${val_sFBD_Active_Ind}'=='Y'    Run Keyword And Continue On Failure    Validate Borrower Details RID Through Facility Notebook    ${val_ShortName}    ${val_Borrower_Details_RID}
    \    Run Keyword If    "${RID_IsExist}"=="${True}" and '${val_sFBD_Active_Ind}'=='N'    Run Keyword And Continue On Failure    Validate Inactive Borrower in Facility Notebook    ${val_ShortName}    ${val_Borrower_Details_RID}
    \    Close All Windows on LIQ
    \    Refresh Tables in LIQ

Get Single Data From CSV File
    [Documentation]    This keyword is used to get data from CSV file based from input header and value.
    ...    And return result.
    ...    @author: dahijara    25SEP2019
    [Arguments]    ${TargetCSV_File}    ${sInputHeader}    ${sInputValue}    ${sTargetHeader}
    
    ${CSV_Content}    Read Csv File To List    ${TargetCSV_File}    |
    ${Row_Count}    Get Length    ${CSV_Content}
    
    ${InputHeader_Index}    Get the Column index of the Header    ${TargetCSV_File}    ${sInputHeader}
    ${TargetHeader_Index}    Get the Column index of the Header    ${TargetCSV_File}    ${sTargetHeader}
    
    :FOR    ${i}    IN RANGE    1    ${Row_Count}
    \    ${Table_Row_Item}    Get From List    ${CSV_Content}    ${i}
    \    ${val_Input}    Get From List    ${Table_Row_Item}    ${InputHeader_Index}
    \    
    \    ${val_Output}    Run Keyword If    '${val_Input}'=='${sInputValue}'    Get From List    ${Table_Row_Item}    ${TargetHeader_Index}
    \    Exit For Loop If    '${val_Input}'=='${sInputValue}'

    Run Keyword If    '${val_Output}'=='${EMPTY}' or '${val_Output}'==''    Run Keyword And Continue On Failure    Fail    No Data Found!
    
    [Return]    ${val_Output}

    
Validate Borrower Details RID Through Facility Notebook
    [Documentation]    This keyword is used to navigate on facility noteboook - Sublimit/Cust Tab and validate Borrower Details RID.
    ...    @author: dahijara    23SEP2019
    [Arguments]    ${sShortName}    ${sBorrower_Details_RID}
        
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Sublimit/Cust
    Mx LoanIQ Select String    ${LIQ_FacilitySublimitCust_Borrowers_Tree}    ${sShortName}
    Take Screenshot    FacilityNoteBook_Sublimit_Cust_Tab
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_FacilitySublimitCust_Borrowers_Tree}    ${sShortName}%d
    
   ### Borrower/Depositor Window ###
    mx LoanIQ activate window    ${LIQ_BorrowerDepositor_Window}
    
    ${BorrowerDepositor_Short_Name}    Mx LoanIQ Get Data    ${LIQ_BorrowerDepositor_ShortName_Javalist}    BorrowerDepositor_Short_Name

    ${IsEqual}    Run Keyword And Return Status    Should Be Equal As Strings    ${BorrowerDepositor_Short_Name}    ${sShortName}
    Run Keyword If    ${IsEqual}==${True}    Log    Facility Short Name and Customer Short Name are equal. ${BorrowerDepositor_Short_Name}=${sShortName}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Facility Short Name and Customer Short Name are equal. ${BorrowerDepositor_Short_Name}!=${sShortName}
    Take Screenshot    FacilityBorrowerDepositor_Window
    
    ### Navigate to Update Information ###
    Mx Native Type    {F8}
    mx LoanIQ activate window    ${LIQ_UpdateInformation_Window}
    Take Screenshot    UpdateInformationRID_Window
    
    mx LoanIQ close window    ${LIQ_UpdateInformation_Window}
    mx LoanIQ close window    ${LIQ_BorrowerDepositor_Window}

Validate Inactive Borrower in Facility Notebook
    [Documentation]    This keyword is used to navigate on facility noteboook and validate that there's no borrower under Sublimit/Cust Tab.
    ...    @author: dahijara    23SEP2019    - Initial Create
    [Arguments]    ${sShortName}    ${sBorrower_Details_RID}
        
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Sublimit/Cust
    ${isExisting}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_FacilitySublimitCust_Borrowers_Tree}    ${sShortName}
    Run Keyword If    ${isExisting}==${False}    Log    Borrower Does Not Exist.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Borrower Does Not Exist.
    Take Screenshot    FacilityNoteBook_Sublimit_Cust_Tab

Validate CSV values in LIQ for VLS_SCHEDULE
    [Documentation]    This keyword is used to validate fields values from CSV in LIQ. 
    ...    @author: mgaling    25SEP2020    - initial Create
    ...    @update: mgaling    22OCT2020    - removed other Run Keyword If keywords
    [Arguments]    ${aTableName_List}    ${sRID_OWNER_Index}    ${sCDE_BAL_TYPE_Index}    ${sAMT_RESIDUAL_Index}
    
    ${Data_Rows}    Get Length    ${aTableName_List}
    
    :FOR    ${Index}    IN RANGE    1    ${Data_Rows}
    \    ${Table_NameList}    Set Variable    @{aTable_NameList}[${INDEX}]
    \    Log    ${Table_NameList}
    \    ${RID_OWNER}    Remove String    @{Table_NameList}[${sRID_OWNER_Index}]    " 
    \    ${CDE_BAL_TYPE}    Remove String    @{Table_NameList}[${sCDE_BAL_TYPE_Index}]    "
    \    ${AMT_RESIDUAL}    Remove String    @{Table_NameList}[${sAMT_RESIDUAL_Index}]    "
    \    ### SCH_AMT_RESIDUAL Field Validation ###
    \    Run Keyword And Continue On Failure    Should Be Equal    ${AMT_RESIDUAL.strip()}    0
    \    ### SCH_CDE_BAL_TYPE Field Validation ###
    \    ${OutstandingRID_IsExist}    Run Keyword If    "${RID_OWNER}"!="${EMPTY}" and "${CDE_BAL_TYPE.strip()}"=="PRIN"    Run Keyword And Return Status     Navigate to Notebook Window thru RID    Outstanding    ${RID_OWNER.strip()}    
         ...    ELSE IF    "${RID_OWNER}"!="${EMPTY}" and "${CDE_BAL_TYPE.strip()}"=="PRINB"    Run Keyword And Return Status     Navigate to Notebook Window thru RID    Outstanding    ${RID_OWNER.strip()}
         ...    ELSE IF    "${RID_OWNER}"!="${EMPTY}" and "${CDE_BAL_TYPE.strip()}"=="PRINI"    Run Keyword And Return Status     Navigate to Notebook Window thru RID    Outstanding    ${RID_OWNER.strip()}
         ...    ELSE IF    "${RID_OWNER}"!="${EMPTY}" and "${CDE_BAL_TYPE.strip()}"=="FIXED"    Run Keyword And Return Status     Navigate to Notebook Window thru RID    Outstanding    ${RID_OWNER.strip()}
         ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${RID_OWNER} is empty or None or ${CDE_BAL_TYPE.strip} is not yet configured.     
    \    Run Keyword If    ${OutstandingRID_IsExist}==${True}    Run Keyword And Continue On Failure    Check CSV Values in Repayment Schedule    ${CDE_BAL_TYPE.strip()}   
         ...    ELSE    Run Keyword And Continue On Failure    FAIL    Oustanding RID ${RID_OWNER} does not exist! 
    \    Close All Windows on LIQ    
    
Check CSV Values in Repayment Schedule
    [Documentation]    This keyword is used to validate SCH_CDE_BAL_TYPE field values from CSV in LIQ - Repayment Schedule Screen. 
    ...    @author: mgaling    25SEP2019    - initial create
    ...    @update: mgaling    22OCT2020    - added validation for the loan window status, updated locator and added screenshot path
    [Arguments]    ${sCDE_BAL_TYPE}   
     
    ### Outstanding Notebook ###
    Mx LoanIQ Activate Window    ${LIQ_Loan_Generic_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Oustanding_Notebook
    
    ${LoanNotebook_Title}    Mx LoanIQ Get Data    ${LIQ_Loan_Generic_Window}    title
    ${LoanNotebook_Status}    Fetch From Right    ${LoanNotebook_Title}    /
    
    ${LoanNotebook_Status}    Replace Variables    ${LoanNotebook_Status}
    ${LIQ_Loan_Generic_IntCycleFreq_Dropdownlist}    Replace Variables    ${LIQ_Loan_Generic_IntCycleFreq_Dropdownlist}
    ${LIQ_Loan_Generic_Options_RepaymentSchedule}    Replace Variables    ${LIQ_Loan_Generic_Options_RepaymentSchedule}
                    
    Mx LoanIQ Activate Window    ${LIQ_Loan_Generic_Window}
    ${cyclefreq_value}    Mx LoanIQ Get Data    ${LIQ_Loan_Generic_IntCycleFreq_Dropdownlist}    value
    mx LoanIQ select    ${LIQ_Loan_Generic_Options_RepaymentSchedule}
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Repayment_Schedule
    
    ### SCH_CDE_BAL_TYPE Field Validation ###
    
    Run Keyword If    "${sCDE_BAL_TYPE}"=="PRIN" or "${sCDE_BAL_TYPE}"=="PRINB"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_Window}.JavaStaticText("attached text:=Bullet")    VerificationData="Yes"
    ...    ELSE IF    "${sCDE_BAL_TYPE}"=="PRINI" or "${sCDE_BAL_TYPE}"=="FIXED"    Run Keyword And Continue On Failure    Run Keywords    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_Window}.JavaObject("text:=Current Schedule - Fixed.*")    VerificationData="Yes"
    ...    AND    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_Window}.JavaStaticText("labeled_containers_path:=Group:Current Schedule.*","text:=${cyclefreq_value}")     VerificationData="Yes"
    ...    ELSE    Log    ${sCDE_BAL_TYPE} is not yet configured.
              
    mx LoanIQ close window    ${LIQ_RepaymentSchedule_Window}
    Close All Windows on LIQ
    
Validate CSV values in LIQ for VLS_Outstanding
    [Documentation]    This keyword is used to validate CSV Values from VLS_Outstanding Extract to LIQ Screen
    ...    @author: mgaling    26SEP2020    - initial create
    ...    @update: mgaling    26OCT2020    - removed quotes on ${True} and ${False} condition and added ELSE Condition
    [Arguments]    ${aTable_NameList}    ${iOST_RID_OUTSTANDNG_Index}    ${iOST_DTE_EXPIRY_ENT_Index}    ${iOST_DTE_REPRICING_Index}    ${iOST_CDE_REPR_FREQ_Index}    ${iOST_IND_FLOAT_RATE_Index}
    ...    ${iOST_DTE_EFFECTIVE_Index}    ${iOST_CDE_ACR_PERIOD_Index}    ${iOST_CDE_PRICE_OPT_Index}    ${iOST_DTE_EXPIRY_CLC_Index}    ${iOST_CDE_CURRENCY_Index}    ${iOST_AMT_BANK_NET_Index}
    ...    ${iOST_CDE_RISK_TYPE_Index}    ${iOST_NME_ALIAS_Index}    ${iOST_CID_BORROWER_Index}    ${iOST_CDE_OB_ST_CTG_Index}    ${iOST_CDE_OBJ_STATE_Index}    ${iOST_CDE_PERF_STAT_Index}
    ...    ${iOST_AMT_FC_CURRENT_Index}    ${iOST_CDE_LOAN_PURP_Index}    ${iOST_RTE_FC_RATE_Index}                    
        
    ${VLS_Outstanding_Data_Rows}    Get Length    ${aTable_NameList}
    
    :FOR    ${INDEX}    IN RANGE    1    ${VLS_Outstanding_Data_Rows}
    \    ${Table_NameList}    Set Variable    @{aTable_NameList}[${INDEX}]
    \    Log    ${Table_NameList}    
    \    ${RID_Outstanding}    Remove String    @{Table_NameList}[${iOST_RID_OUTSTANDNG_Index}]    "
    \    ${DTE_EXPIRY}    Remove String    @{Table_NameList}[${iOST_DTE_EXPIRY_ENT_Index}]    "
    \    ${DTE_REPRICING}    Remove String    @{Table_NameList}[${iOST_DTE_REPRICING_Index}]    "
    \    ${REPR_FREQ}    Remove String    @{Table_NameList}[${iOST_CDE_REPR_FREQ_Index}]    "
    \    ${IND_FLOAT_RATE}    Remove String    @{Table_NameList}[${iOST_IND_FLOAT_RATE_Index}]    "
    \    ${DTE_EFFECTIVE}    Remove String    @{Table_NameList}[${iOST_DTE_EFFECTIVE_Index}]    "
    \    ${ACR_PERIOD}    Remove String    @{Table_NameList}[${iOST_CDE_ACR_PERIOD_Index}]    "
    \    ${PRICE_OPT}    Remove String    @{Table_NameList}[${iOST_CDE_PRICE_OPT_Index}]    "
    \    ${DTE_EXPIRY_Adj}    Remove String    @{Table_NameList}[${iOST_DTE_EXPIRY_CLC_Index}]    "
    \    ${CURRENCY}    Remove String    @{Table_NameList}[${iOST_CDE_CURRENCY_Index}]    "
    \    ${AMT_BANK_NET}    Remove String    @{Table_NameList}[${iOST_AMT_BANK_NET_Index}]    "
    \    ${RISK_TYPE}    Remove String    @{Table_NameList}[${iOST_CDE_RISK_TYPE_Index}]    "
    \    ${NME_ALIAS}    Remove String    @{Table_NameList}[${iOST_NME_ALIAS_Index}]    "
    \    ${RID_BORROWER}    Remove String    @{Table_NameList}[${iOST_CID_BORROWER_Index}]    "
    \    ${OB_ST_CTG}    Remove String    @{Table_NameList}[${iOST_CDE_OB_ST_CTG_Index}]    "
    \    ${OBJ_STATE}    Remove String    @{Table_NameList}[${iOST_CDE_OBJ_STATE_Index}]    "
    \    ${PERF_STAT}    Remove String    @{Table_NameList}[${iOST_CDE_PERF_STAT_Index}]    "
    \    ${AMT_FC_CURRENT}    Remove String    @{Table_NameList}[${iOST_AMT_FC_CURRENT_Index}]    "
    \    ${LOAN_PURP}    Remove String    @{Table_NameList}[${iOST_CDE_LOAN_PURP_Index}]    "
    \    ${RTE_FC_RATE}    Remove String    @{Table_NameList}[${iOST_RTE_FC_RATE_Index}]    "
    \    ###    Get Frequency Code Description    ###
    \    Run Keyword If    "${REPR_FREQ}"!="${EMPTY}"    Run Keywords    Select Actions    [Actions];Table Maintenance
         ...    AND    Search in Table Maintenance    Base Rate Frequency
         ...    ELSE    Log    REPR_FREQ is empty.    
    \    ${Freq_Desc}    Run Keyword If    "${REPR_FREQ}"!="${EMPTY}"    Get Single Description from Table Maintanance    ${REPR_FREQ.strip()}    ${LIQ_BaseRateFrequency_Window}    ${LIQ_BaseRateFrequency_Tree}    ${LIQ_BaseRateFrequency_ShowAll_RadioBtn}    ${LIQ_BaseRateFrequency_Exit_Button}
         ...    ELSE    Log    REPR_FREQ is empty. 
    \    Refresh Tables in LIQ
    \    ###    Get Accrual Period Code Description    ###
    \    Run Keyword If    "${ACR_PERIOD}"!="${EMPTY}"    Run Keywords    Select Actions    [Actions];Table Maintenance
         ...    AND    Search in Table Maintenance    Accrual Period
         ...    ELSE    Log    ACR_PERIOD is empty.
    \    ${Period_Desc}    Run Keyword If    "${ACR_PERIOD}"!="${EMPTY}"    Get Single Description from Table Maintanance    ${ACR_PERIOD.strip()}    ${LIQ_BrowseAccrualPeriod_Window}    ${LIQ_BrowseAccrualPeriod_JavaTree}    ${LIQ_BrowseAccrualPeriod_ShowAll_Button}    ${LIQ_BrowseAccrualPeriod_Exit_Button}
         ...    ELSE    Log    ACR_PERIOD is empty.
    \    Refresh Tables in LIQ
    \    ###    Get Risk Code Description    ###
    \    Run Keyword If    "${RISK_TYPE}"!="${EMPTY}"    Run Keywords    Select Actions    [Actions];Table Maintenance
         ...    AND    Search in Table Maintenance    Risk Type
         ...    ELSE    Log    RISK_TYPE is empty.
    \    ${RiskType_Desc}    Run Keyword If    "${RISK_TYPE}"!="${EMPTY}"    Get Single Description from Table Maintanance    ${RISK_TYPE.strip()}    ${LIQ_BrowseRiskType_Window}    ${LIQ_BrowseRiskType_JavaTree}    ${LIQ_BrowseRiskType_ShowAll_Button}    ${LIQ_BrowseRiskType_Exit_Button}
         ...    ELSE    Log    RISK_TYPE is empty.
    \    Refresh Tables in LIQ
    \    ###    Get Purpose Description ###
    \    Run Keyword If    "${LOAN_PURP}"!="${EMPTY}"    Run Keywords    Select Actions    [Actions];Table Maintenance
         ...    AND    Search in Table Maintenance    Loan Purpose
         ...    ELSE    Log    LOAN_PURP is empty.
    \    ${LoanPurpose_Desc}    Run Keyword If    "${LOAN_PURP}"!="${EMPTY}"    Get Single Description from Table Maintanance    ${LOAN_PURP.strip()}    ${LIQ_BrowseLoanPurpose_Window}    ${LIQ_BrowseLoanPurpose_JavaTree}    ${LIQ_BrowseLoanPurpose_ShowAll_Button}    ${LIQ_BrowseLoanPurpose_Exit_Button}
         ...    ELSE    Log    LOAN_PURP is empty.
    \    Refresh Tables in LIQ
    \    ###    Get Customer Short Name ###
    \    ${Cust_ShortName}    Run Keyword If    "${RID_BORROWER.strip()}"!="${EMPTY}" and "${RID_BORROWER.strip()}"!="NONE"     Run Keyword And Continue On Failure    Get and Return Customer Short Name Using Customer RID    ${RID_BORROWER.strip()}    
         ...    ELSE    Log    RID_BORROWER is NONE or Empty.
    \    Refresh Tables in LIQ
    \    ### Launch Outstanding Notebook thru RID ###
    \    ${RID_IsExist}    Run Keyword If   "${RID_Outstanding}"!="${EMPTY}" and "${RID_Outstanding}"!="NONE"    Run Keyword And Return Status    Navigate to Notebook Window thru RID    Outstanding    ${RID_Outstanding.strip()}
         ...    ELSE    Log    RID_Outstanding is NONE or Empty.
    \    Run Keyword If    ${RID_IsExist}==${True}    Log    Outstanding RID ${RID_Outstanding} is available.
         ...    ELSE IF    ${RID_IsExist}==${False}    Run Keyword And Continue On Failure    FAIL    ${RID_Outstanding.strip()} does not exist!
         ...    ELSE    Log    RID_Outstanding is NONE or Empty.     
    \    Run Keyword If    ${RID_IsExist}==${True} and "${OB_ST_CTG}"!="${EMPTY}" and "${OBJ_STATE}"!="${EMPTY}" and "${OBJ_STATE}"!="${PRICE_OPT}"    Run Keyword And Continue On Failure    Validate Loan Notebook Status    ${OB_ST_CTG.strip()}    ${OBJ_STATE.strip()}
         ...    ELSE    Log   No available data to validate.    
    \    Run Keyword If    ${RID_IsExist}==${True}    Run Keyword And Continue On Failure    Validate CSV Values in Outstanding Notebook General Tab    ${OBJ_STATE.strip()}    ${DTE_EXPIRY.strip()}    ${DTE_REPRICING.strip()}    ${Freq_Desc}    ${IND_FLOAT_RATE}    ${RISK_TYPE.strip()}    ${DTE_EFFECTIVE}    ${Period_Desc}    ${PRICE_OPT}    ${DTE_EXPIRY_Adj}    ${CURRENCY}
         ...    ${AMT_BANK_NET}    ${RiskType_Desc}    ${Cust_ShortName}
         ...    ELSE    Log   No available data to validate.
    \    Run Keyword If    ${RID_IsExist}==${True} and "${CURRENCY}"!="${EMPTY}" and "${AMT_FC_CURRENT}"!="${EMPTY}"    Run Keyword And Continue On Failure     Validate CSV Values in Outstanding Notebook Currency Tab    ${AMT_FC_CURRENT}    None    ${CURRENCY}    ${OBJ_STATE.strip()}
         ...    ELSE    Log   No available data to validate. 
    \    Run Keyword If    ${RID_IsExist}==${True} and "${CURRENCY}"!="${EMPTY}" and "${RTE_FC_RATE}"!="${EMPTY}"    Run Keyword And Continue On Failure     Validate CSV Values in Outstanding Notebook Currency Tab    None    ${RTE_FC_RATE}    ${CURRENCY}    ${OBJ_STATE.strip()}                
         ...    ELSE    Log   No available data to validate.
    \    Run Keyword If    ${RID_IsExist}==${True} and "${PERF_STAT}"!="${EMPTY}" and "${OB_ST_CTG}"=="ACTUA"    Run Keyword And Continue On Failure    Check Loan Performing Status    ${PERF_STAT.strip()}    ${OBJ_STATE.strip()}
         ...    ELSE    Log   No available data to validate.     
    \    Run Keyword If    ${RID_IsExist}==${True} and "${LOAN_PURP}"!="${EMPTY}"    Run Keyword And Continue On Failure    Validate CSV Values in Facility Notebook Purpose Tab    ${OBJ_STATE.strip()}    ${LoanPurpose_Desc.strip()}
         ...    ELSE    Log   No available data to validate.    
    \    Close All Windows on LIQ
    \    Refresh Tables in LIQ
   

Validate Loan Notebook Status
    [Documentation]    This keyword is used to validate the Loan Notebook status based from the CSV values.
    ...    @author: mgaling    19SEP2019    - initial create
    ...    @update: mgaling    26OCT2020    - added ELSE condition and take screenshot keyword
    [Arguments]    ${sOB_ST_CTG}    ${sOBJ_STATE}
        
    Run Keyword If    "${sOB_ST_CTG}"=="ACTUA"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Loan.* ${${sOBJ_STATE}_Window}")    VerificationData="Yes"
    ...    ELSE IF    "${sOB_ST_CTG}"=="INACT"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Loan.* ${${sOBJ_STATE}_Window}")    VerificationData="Yes"
    ...    ELSE IF    "${sOB_ST_CTG}"=="POTEN"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Loan.* ${${sOBJ_STATE}_Window}")            VerificationData="Yes"
    ...    ELSE    Log    ${sOB_ST_CTG} is not yet configured.

    Take Screenshot    ${screenshot_path}/Screenshots/DWE/LoanStatus    

Validate CSV Values in Outstanding Notebook General Tab
    [Documentation]    This keyword is used to validate values under Loan Notebook - General Tab.
    ...    @author: mgaling    19SEP2019    - initial create
    ...    @update: mgaling    26OCT2020    - added screenshotpath, condition for OST_IND_FLOAT_RATE validation and ELSE Condition
    [Arguments]    ${sOBJ_STATE}    ${dDTE_EXPIRY}    ${dDTE_REPRICING}    ${sFreq_Desc}    ${sIND_FLOAT_RATE}    ${sRISK_TYPE}    ${dDTE_EFFECTIVE}    ${sPeriod_Desc}    ${sPRICE_OPT}    ${dDTE_EXPIRY_Adj}    ${sCURRENCY}
    ...    ${iAMT_BANK_NET}    ${sRiskType_Desc}    ${sCust_ShortName}                    
    
    mx LoanIQ activate window    JavaWindow("title:=.* Loan.* ${${sOBJ_STATE}_Window}")
    mx LoanIQ select    JavaWindow("title:=.* Loan.* ${${sOBJ_STATE}_Window}").JavaTab("tagname:=TabFolder")    General        
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Outstanding_NB
    
    ### OST_DTE_EXPIRY_ENT field value vs LIQ - Maturity Date Field ###
    ${dDTE_EXPIRY}    Run Keyword If    "${dDTE_EXPIRY}"!="${EMPTY}" and "${dDTE_EXPIRY}"!="None"    Convert Date With Zero     ${dDTE_EXPIRY}
    ...    ELSE    Log    DTE_EXPIRY is Empty or NONE.
    Run Keyword If    "${dDTE_EXPIRY}"!="${EMPTY}" and "${dDTE_EXPIRY}"!="None"     Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist     JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaEdit("labeled_containers_path:=Tab:General;","index:=0","text:=${dDTE_EXPIRY}")                VerificationData="Yes"
    ...    ELSE    Log    DTE_EXPIRY is Empty or NONE.

    ### OST_DTE_REPRICING field value vs LIQ - Repricing Date Field ###    
    ${dDTE_REPRICING}    Run Keyword If    "${dDTE_REPRICING}"!="${EMPTY}" and "${dDTE_REPRICING}"!="None"    Convert Date With Zero     ${dDTE_REPRICING}
    ...    ELSE    Log    DTE_REPRICING is Empty or NONE.
    Run Keyword If    "${dDTE_REPRICING}"!="${EMPTY}" and "${dDTE_REPRICING}"!="None"     Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist     JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaStaticText("labeled_containers_path:=Tab:General;","attached text:=${dDTE_REPRICING}")    VerificationData="Yes"
    ...    ELSE    Log    DTE_REPRICING is Empty or NONE.

    ### OST_CDE_REPR_FREQ field value vs LIQ - Repricing Frequency Field ###
    Run Keyword If    "${sFreq_Desc}"!="${EMPTY}" and "${sFreq_Desc}"!="None"   Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist     JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaList("attached text:=Repricing Frequency:","value:=${sFreq_Desc}")    VerificationData="Yes"
    ...    ELSE    Log    Freq_Desc is Empty or NONE.

    ### OST_IND_FLOAT_RATE field value vs LIQ - Repricing Date Field Validation ###
    ${IsExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist     JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaStaticText("attached text:=Repricing Date:")    VerificationData="Yes"
    Run Keyword If    ${IsExist}==${True}    Run Keyword And Continue On Failure    Should Be Equal    ${sIND_FLOAT_RATE}    N                                                    
    ...    ELSE IF    ${IsExist}==${False} and "${sRISK_TYPE}"=="LOANS" and "${sOBJ_STATE}"!="PEND"    Run Keyword And Continue On Failure    Should Be Equal    ${sIND_FLOAT_RATE}    Y
    ...    ELSE IF    ${IsExist}==${False} and "${sRISK_TYPE}"=="FIXED" and "${sOBJ_STATE}"!="PEND"    Run Keyword And Continue On Failure    Should Be Equal    ${sIND_FLOAT_RATE}    N
    ...    ELSE IF    ${IsExist}==${False} and "${sOBJ_STATE}"=="PEND"    Log    Repricing Date Field is not available in pending loan.                 
    ...    ELSE    Fail    Repricing Date Field Validation condition is not available  
    
    ### OST_DTE_EFFECTIVE field value vs LIQ - Effective Date Field ###
    ${dDTE_EFFECTIVE}    Run Keyword If    "${dDTE_EFFECTIVE}"!="${EMPTY}" and "${dDTE_EFFECTIVE}"!="None"    Convert Date With Zero     ${dDTE_EFFECTIVE}
    ...    ELSE    Log    DTE_EFFECTIVE is Empty or NONE.
    Run Keyword If    "${dDTE_EFFECTIVE}"!="${EMPTY}" and "${dDTE_EFFECTIVE}"!="None"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist     JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaStaticText("labeled_containers_path:=Tab:General;", "attached text:=${dDTE_EFFECTIVE}")    VerificationData="Yes"
    ...    ELSE    Log    DTE_EFFECTIVE is Empty or NONE.

    ### OST_CDE_ACR_PERIOD field value vs LIQ - Int. Cycle Freq Field ###
    Run Keyword If    "${sPeriod_Desc}"!="${EMPTY}" and "${sPeriod_Desc}"!="None"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist     JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaList("attached text:=Int\. Cycle Freq:","value:=${sPeriod_Desc}")    VerificationData="Yes"
    ...    ELSE    Log    Period_Desc is Empty or NONE.
    
    ### OST_CDE_PRICE_OPT field value vs LIQ - Pricing Option Field ###
    Run Keyword If    "${sPRICE_OPT}"!="${EMPTY}" and "${sPRICE_OPT}"!="None"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist     JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaStaticText("labeled_containers_path:=Tab:General;","attached text:=${sPRICE_OPT}")        VerificationData="Yes"
    ...    ELSE    Log    PRICE_OPT is Empty or NONE.

    ### OST_DTE_EXPIRY_CLC value vs LIQ - Adjusted Field ###
    ${dDTE_EXPIRY_Adj}    Run Keyword If    "${dDTE_EXPIRY_Adj}"!="${EMPTY}"    Convert Date With Zero     ${dDTE_EXPIRY_Adj}
    ...    ELSE    Log    DTE_EXPIRY_Adj is Empty or NONE.
    Run Keyword If    "${dDTE_EXPIRY_Adj}"!="${EMPTY}" and "${dDTE_EXPIRY_Adj}"!="None"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaEdit("attached text:=Adjusted Expiry:","value:=${dDTE_EXPIRY_Adj}")    VerificationData="Yes"
    ...    ELSE    Log    DTE_EXPIRY_Adj is Empty or NONE.

    ### OST_CDE_CURRENCY field value vs LIQ - Currency Field ###
    Run Keyword If    "${sCURRENCY}"!="${EMPTY}"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaStaticText("labeled_containers_path:=Tab:General;Group:Loan Amounts;","attached text:=${sCURRENCY}")    VerificationData="Yes"
    ...    ELSE    Log    CURRENCY is Empty or NONE.

    ### OST_AMT_BANK_NET field value vs LIQ - Host Bank Net Field ###
    ${iAMT_BANK_NET}    Convert To Number    ${iAMT_BANK_NET}        
    ${UI_AMT_BANK_NET}    Mx LoanIQ Get Data    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaEdit("attached text:=Host Bank Net:")    value
    ${UI_AMT_BANK_NET}    Remove Comma and Convert to Number    ${UI_AMT_BANK_NET}  
    Run Keyword If    "${iAMT_BANK_NET}"!="${EMPTY}"    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${iAMT_BANK_NET}    ${UI_AMT_BANK_NET}    
    ...    ELSE    Log    AMT_BANK_NET is Empty or NONE.

    ### OST_CDE_RISK_TYPE field value vs LIQ - Risk Type Field ### 
    Run Keyword If    "${sRiskType_Desc}"!="${EMPTY}"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaStaticText("labeled_containers_path:=Tab:General;","attached text:=${sRiskType_Desc}")        VerificationData="Yes"
    
    ### OST_CID_BORROWER  field value vs LIQ - Borrower Field ### 
    Run Keyword If    "${sCust_ShortName}"!="${EMPTY}"    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaStaticText("labeled_containers_path:=Tab:General;","attached text:=${sCust_ShortName}")     VerificationData="Yes"
    ...    ELSE    Log    Cust_ShortName is Empty or NONE.

Get and Return Customer Short Name Using Customer RID
    [Documentation]    This keyword is used to navigate on Deal noteboook and get the Customer Short Name.
    ...    @author: mgaling    23SEP2019    - initial create
    ...    @update: mgaling    26OCT2020    - added screenshotpath
    [Arguments]    ${sCust_Id}
   
    ### Launch Active Customer Window ### 
    Navigate to Notebook Window thru RID    Customer    ${sCust_Id}
    mx LoanIQ activate window    ${LIQ_ActiveCustomer_Window}    
    ${Cust_ShortName}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_ShortName}    value
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/ActiveCustomer_Window
    
    [Return]    ${Cust_ShortName}

Validate CSV Values in Outstanding Notebook Currency Tab
    [Documentation]    This keyword is used to validate the Loan Notebook Currency Tab based from the CSV OST_AMT_FC_CURRENT and OST_RTE_FC_RATE field values.
    ...    @author: mgaling    27SEP2020    - initial create
    ...    @update: mgaling    26OCT2020    - removed quotes in True and False Condition, added screenshotpath and updated keywords
    [Arguments]    ${iAMT_FC_CURRENT}==None    ${iRTE_FC_RATE}==None    ${sCURRENCY}==None    ${sOBJ_STATE}==None    
    
    mx LoanIQ activate window    JavaWindow("title:=.* Loan.* ${${sOBJ_STATE}_Window}")
    ${CurrencyTab_IsExist}    Run Keyword And Return Status    mx LoanIQ select    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaTab("tagname:=TabFolder")    Currency       
    
    mx LoanIQ activate window    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}") 
    Run Keyword If    ${CurrencyTab_IsExist}==${True} and "${${sOBJ_STATE}_Window}"!="Pending"     Run Keywords    mx LoanIQ click    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaButton("attached text:=History")
    ...    AND    mx LoanIQ activate window    ${LIQ_Loan_Currency_RateHistory_Window}
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Rate_History
    ...    AND    mx LoanIQ close window    ${LIQ_Loan_Currency_RateHistory_Window}
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Currency_Tab
    ...    ELSE IF    ${CurrencyTab_IsExist}==${True}	Take Screenshot    ${screenshot_path}/Screenshots/DWE/Currency_Tab                    
    ...    ELSE    Log    Currency Tab is not applicable in this Outstanding Notebook.       
    
    ### OST_AMT_FC_CURRENT field value vs LIQ - Current field ###
    ${UI_AMT_FC_CURRENT}    Run Keyword If    "${iAMT_FC_CURRENT}"!="None" and ${CurrencyTab_IsExist}==${True} and "${${sOBJ_STATE}_Window}"!="Pending"    Run Keyword    Mx LoanIQ Get Data    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaStaticText("labeled_containers_path:=Tab:Currency;Group:Amounts in Facility Currency;","index:=3")    value
    ...    ELSE    Log    Currency Validation is not applicable in this Outstanding Notebook.
    ${UI_AMT_FC_CURRENT}    Run Keyword If    "${iAMT_FC_CURRENT}"!="None" and ${CurrencyTab_IsExist}==${True} and "${${sOBJ_STATE}_Window}"!="Pending"    Run Keyword    Remove Comma and Convert to Number    ${UI_AMT_FC_CURRENT} 
    ...    ELSE    Log    Currency Validation is not applicable in this Outstanding Notebook.

    Run Keyword If    "${iAMT_FC_CURRENT}"!="None" and ${CurrencyTab_IsExist}==${True} and "${${sOBJ_STATE}_Window}"!="Pending"    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${iAMT_FC_CURRENT}    ${UI_AMT_FC_CURRENT}
    ...    ELSE    Log    Currency Validation is not applicable in this Outstanding Notebook.
    
    ### OST_RTE_FC_RATE field value vs LIQ - F/X Rate field ###
    ${UI_RTE_FC_RATE}    Run Keyword If    "${sCURRENCY}"!="None" and ${CurrencyTab_IsExist}==${True} and "${${sOBJ_STATE}_Window}"!="Pending"    Run Keyword    Mx LoanIQ Get Data    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaStaticText("labeled_containers_path:=Tab:Currency;Group:F/X Rate;","index:=0")    text
    ...    ELSE    Log    F/X Rate Validation is not applicable in this Outstanding Notebook.
    ${UI_RTE_FC_RATE}    Run Keyword If    "${sCURRENCY}"!="None" and ${CurrencyTab_IsExist}==${True} and "${${sOBJ_STATE}_Window}"!="Pending"    Run Keyword    Remove String    ${UI_RTE_FC_RATE}    AUD to ${sCURRENCY}
    ...    ELSE    Log    F/X Rate Validation is not applicable in this Outstanding Notebook.
    ${UI_RTE_FC_RATE}    Run Keyword If    "${sCURRENCY}"!="None" and ${CurrencyTab_IsExist}==${True} and "${${sOBJ_STATE}_Window}"!="Pending"    Run Keyword    Convert To Number    ${UI_RTE_FC_RATE}
    ...    ELSE    Log    F/X Rate Validation is not applicable in this Outstanding Notebook.

    ${iRTE_FC_RATE}    Run Keyword If    ${CurrencyTab_IsExist}==${True} and "${iRTE_FC_RATE}"!="None" and "${${sOBJ_STATE}_Window}"!="Pending"    Run Keyword    Convert To Number    ${iRTE_FC_RATE}   
    ...    ELSE    Log    F/X Rate Validation is not applicable in this Outstanding Notebook.
    ${iRTE_FC_RATE}    Run Keyword If    ${CurrencyTab_IsExist}==${True} and "${iRTE_FC_RATE}"!="None" and "${${sOBJ_STATE}_Window}"!="Pending"    Run Keyword    Evaluate    1/${iRTE_FC_RATE}    
    ...    ELSE    Log    F/X Rate Validation is not applicable in this Outstanding Notebook.

    ${status}    Run Keyword If    ${CurrencyTab_IsExist}==${True} and "${iRTE_FC_RATE}"!="None" and "${${sOBJ_STATE}_Window}"!="Pending"     Run Keyword And Return Status    Should Be Equal As Numbers    ${iRTE_FC_RATE}    ${UI_RTE_FC_RATE}
    ...    ELSE    Log    F/X Rate Validation is not applicable in this Outstanding Notebook.

    Run Keyword If    ${status}==${True}    Log    CSV and UI Data are matched!
    ...    ELSE IF    ${status}==${False}   Run Keyword And Continue On Failure    FAIL    ${iRTE_FC_RATE} CSV and ${UI_RTE_FC_RATE}UI Data are not matched!
    ...    ELSE    Log    F/X Rate Validation is not applicable in this Outstanding Notebook. 


Check Loan Performing Status
    [Documentation]    This keyword is used to validate the performing status of Loan Notebook..
    ...    @author: mgaling    27SEP2019    - initial create
    ...    @update: mgaling    26OCT2020    - added screenshotpath
    [Arguments]    ${sPERF_STAT}    ${sOBJ_STATE}    
    
    mx LoanIQ activate window    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}")
    mx LoanIQ click element if present    JavaWindow("title:=.*${${sOBJ_STATE}_Window}").JavaButton("attached text:=Notebook in Inquiry Mode - F7")          
    mx LoanIQ select    JavaWindow("title:=.*${${sOBJ_STATE}_Window}").JavaMenu("label:=Accounting").JavaMenu("label:=Change Performing Status")
    
    mx LoanIQ activate window    JavaWindow("title:=Change Performing Status")
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Change Performing Status").JavaStaticText("attached text:=${${sPERF_STAT}_Desc}")    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Perf_Stat
    mx LoanIQ click    JavaWindow("title:=Change Performing Status").JavaButton("attached text:=Cancel")       
    
Validate CSV Values in Facility Notebook Purpose Tab
    [Documentation]    This keyword is used to validate that the Loan Notebook has Purpose on its linked Facility Notebook.
    ...    @author: mgaling    27SEP2019    - initial create
    ...    @update: mgaling    26OCT2020    - added screenshotpath
    [Arguments]    ${sOBJ_STATE}    ${sLoanPurpose_Desc}
    
    mx LoanIQ activate window    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}")   
    mx LoanIQ select    JavaWindow("title:=.* ${${sOBJ_STATE}_Window}").JavaMenu("label:=Options").JavaMenu("label:=Facility Notebook")
    
    ### Facility Notebook ###
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window} 
    mx LoanIQ select    ${LIQ_FacilityNotebook_Tab}    Types/Purpose
    mx LoanIQ click    ${LIQ_FacilityNotebook_InquiryMode_Button}       
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/Loan_Purpose
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_FacilityTypesPurpose_LoanPurpose_JavaTree}    ${sLoanPurpose_Desc}  

Validate CUS_XID_CUST_ID in Customer Notebook
	[Documentation]    This keyword validates CUS_XID_CUST_ID value in LIQ Customer Notebook
    ...    @author: mgaling    07OCT2020    - initial create
    [Arguments]    ${CUS_CID_CUST_ID_Value}    ${CUS_XID_CUST_ID_Value}

    ###Select By RID###
    Select By RID    Customer    ${CUS_CID_CUST_ID_Value}

    ###Customer Notebook###

    mx LoanIQ activate window    ${LIQ_ActiveCustomer_Window}    120  
    ${CustomerID}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_CustomerID}    value%CustomerID
    
	###Validate Customer ID###
	${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CustomerID.strip()}    ${CUS_XID_CUST_ID_Value}
    Take Screenshot    CustomerID_${CUS_XID_CUST_ID_Value}
    Run Keyword If    ${status}==False    Run Keyword And Continue On Failure    Fail    Customer ID is not the same.
    mx LoanIQ close window    ${LIQ_ActiveCustomer_Window}

Get Business Date of Decrypted Files
    [Documentation]    This keyword is used to get the business date of the decrypted files.
    ...    @author: mgaling    10OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Log    ${ExcelPath}
    Log    &{ExcelPath}[Business_Date]
    ${Business_Date}    Convert Date    &{ExcelPath}[Business_Date]    result_format=%Y%m%d    date_format=%Y-%m-%d 
    Log    ${Business_Date}        

    ${TestCase_Name_FuncVal_List}    Split String    ${TestCase_Name_FuncVal}    |
    Write Data to Excel    ${DWELIQFunc_Dataset_SheetName}    Business_Date    @{TestCase_Name_FuncVal_List}[${DATAROW_INDEX}]    ${Business_Date}    ${DWELIQFunc_Dataset}    bTestCaseColumn=True

Validate BSG_CDE_PORTFOLIO_Value in Portfolio Update Window
	[Documentation]    This keyword validates BSG_CDE_PORTFOLIO in LIQ - Portfolio Update Window
	...    @author: mgaling    14OCT2020    - initial create
    [Arguments]    ${sBSG_CDE_PORTFOLIO_Value}    ${sDescription}    
	
	###Search for the Portfolio###
    mx LoanIQ activate window    ${LIQ_Portfolio_Window}
    ${Portfolio_List}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_Portfolio_Tree}    Portfolio_List    Processtimeout=180
    Log    ${Portfolio_List}            
    ${Portfolio_IsExist}    Run Keyword And Return Status    Should Contain    ${Portfolio_List}    ${sBSG_CDE_PORTFOLIO_Value}    
    Run Keyword If    ${Portfolio_IsExist}==${False}    Run Keyword And Continue On Failure    FAIL    ${sBSG_CDE_PORTFOLIO_Value} is not displayed in LIQ.
    ...    ELSE    Log    ${sBSG_CDE_PORTFOLIO_Value} is displayed in LIQ.
  
    Mx LoanIQ Select String    ${LIQ_Portfolio_Tree}    ${sBSG_CDE_PORTFOLIO_Value}\t${sDescription}
    Mx Press Combination    KEY.ENTER
    
	###Portfolio Update Window###
    mx LoanIQ activate window    ${LIQ_BrowsePortfolio_Update_Window}
    ${Code}    Mx LoanIQ Get Data    ${LIQ_BrowsePortfolio_Update_Code_Field}    Code    
    Log    Expected: ${sBSG_CDE_PORTFOLIO_Value}
    Log    Actual: ${Code}
    ${Verify_Equal}    Run Keyword And Return Status    Should Be Equal As Strings    ${sBSG_CDE_PORTFOLIO_Value}    ${Code.strip()}    
    
    Run Keyword If    ${Verify_Equal}==${False}    Run Keyword And Continue On Failure    FAIL    Incorrect Portfolio value '${Code}' is displayed in LIQ.
    ...    ELSE    Log    Correct Portfolio value '${Code}' is displayed in LIQ.
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/${Code}
   
    mx LoanIQ close window    ${LIQ_BrowsePortfolio_Update_Window}