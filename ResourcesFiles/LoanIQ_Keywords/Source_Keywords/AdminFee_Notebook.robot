*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Set General Tab Details in Admin Fee Notebook
    [Documentation]    This keyword sets the details in the General tab of the Admin Fee Notebook
    ...    @author: bernchua
    ...    @update: mnanquil    make all the required arguments to become optional this is to handle bpb deal creation.
    ...    @update: fmamaril    Added currency and Bill borrower checkbox as input on General Tab
    ...    @update: bernchua    02JUL2019    Updated amount variable name and amount object locator
    ...    @update: fmamaril    15MAY2020    - added argument for keyword pre processing
    [Arguments]    ${sAmount}=None    ${sEffectiveDate}=None    ${sFrequency}=None    ${sActualDueDate}=None    ${sBillingNumberOfDays}=None    ${sBillBorrower}=OFF    ${sAdminFee_Currency}=None
    
    ### GetRuntime Keyword Pre-processing ###
    ${Amount}    Acquire Argument Value    ${sAmount}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${Frequency}    Acquire Argument Value    ${sFrequency}
    ${ActualDueDate}    Acquire Argument Value    ${sActualDueDate}
    ${BillingNumberOfDays}    Acquire Argument Value    ${sBillingNumberOfDays}
    ${BillBorrower}    Acquire Argument Value    ${sBillBorrower}
    ${AdminFee_Currency}    Acquire Argument Value    ${sAdminFee_Currency}
        
    mx LoanIQ click element if present    ${LIQ_Warning_No_Button}
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeNotebook_JavaTab}    General
    Run keyword if    '${Amount}' != 'None'    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_Amount_Textfield}    ${Amount}
    Run keyword if    '${EffectiveDate}' != 'None'    Run Keywords
    ...    Run Keyword And Ignore Error    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_EffectiveDate_Datefield}    ${EffectiveDate}
    ...    AND    Run Keyword And Ignore Error    mx LoanIQ enter    ${LIQ_AccruingAdminFee_EffectiveDate}    ${EffectiveDate}
    Run keyword if    '${EffectiveDate}' != 'None'    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run keyword if    '${Frequency}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_AdminFeeNotebook_PeriodFrequency_Combobox}    ${Frequency}
    Run keyword if    '${ActualDueDate}' != 'None'    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_ActualDueDate_Datefield}    ${ActualDueDate}
    Run keyword if    '${ActualDueDate}' != 'None'    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run keyword if    '${BillingNumberOfDays}' != 'None'    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_BillingNumber_Textfield}    ${BillingNumberOfDays}    
    Run keyword if    '${BillBorrower}' != 'OFF'    Mx LoanIQ Check Or Uncheck    ${LIQ_AdminFee_BillBorrower_Checkbox}    ${BillBorrower}
    Run Keyword If    '${AdminFee_Currency}' != 'None'    Mx LoanIQ select combo box value    ${LIQ_AdminFeeNotebook_Currency_Combobox}    ${AdminFee_Currency}        
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AdminFeeWindow_General

Set Admin Fee General Details
    [Documentation]    This keyword sets the general details in the Admin Fee Notebook
    ...    @author: bernchua    09JUL2019    Initial create
    ...    @updated: ritragel    17SEP2019    Updated logic and locator. Removed Ignore error.
    [Arguments]    ${sAdminFee_AmountType}    ${sAdminFee_Amount}    ${sAdminFee_EffectiveDate}    ${sAdminFee_Frequency}
    ${SysDate}    Get System Date
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeNotebook_JavaTab}    General
    Mx LoanIQ Set    JavaWindow("title:=.*Admin Fee /.*","displayed:=1").JavaRadioButton("label:=${sAdminFee_AmountType}")    ON
    Run Keyword if    '${sAdminFee_AmountType}'=='Flat Amount'    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_Amount_Textfield}    ${sAdminFee_Amount}
    Run Keyword if    '${sAdminFee_AmountType}'=='Formula'    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_Amortize_Amount_Textfield}    ${sAdminFee_Amount}    
    mx LoanIQ enter    JavaWindow("title:=.*Admin Fee.*").JavaEdit("attached text:=${SysDate}")    ${sAdminFee_EffectiveDate}
    mx LoanIQ enter    ${LIQ_AccruingAdminFee_EffectiveDate}    ${sAdminFee_EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AdminFeeNotebook_PeriodFrequency_Combobox}    ${sAdminFee_Frequency}

Set Admin Fee Currency
    [Documentation]    This keyword sets the Currency in the Admin Fee Notebook
    ...                @author: bernchua    09JUL2019
    [Arguments]    ${sAdminFee_Currency}
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AdminFeeNotebook_Currency_Combobox}    ${sAdminFee_Currency}
    Validate String Data In LIQ Object    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_Currency_Combobox}    ${sAdminFee_Currency}
            
Tick Admin Fee Bill Borrower
    [Documentation]    This keyword ticks the Bill Borrower in the Admin Fee Notebook.
    ...                @author: bernchua    09JUL2019    Initial create
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Set    ${LIQ_AdminFeeNotebook_BillBorrower_CheckBox}    ON
    Validate if Element is Checked    ${LIQ_AdminFeeNotebook_BillBorrower_CheckBox}    Bill Borrower
        
Set Admin Fee Billing Number Of Days
    [Documentation]    This keyword sets the Billing Number of Days in the Admin Fee Notebook.
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${sAdminFee_BillingDays}
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_BillingNumber_Textfield}    ${sAdminFee_BillingDays}
    Validate String Data In LIQ Object    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_BillingNumber_Textfield}    ${sAdminFee_BillingDays}
    
Set Admin Fee Non Business Day Rule
    [Documentation]    This keyword sets the Non Business Day Rule in the Admin Fee Notebook.
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${sAdminFee_NBDRule}
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AdminFee_NonBusinessDayRule_Combobox}    ${sAdminFee_NBDRule}
    Validate String Data In LIQ Object    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFee_NonBusinessDayRule_Combobox}    ${sAdminFee_NBDRule}
    
Set Admin Fee Accrue
    [Documentation]    This keyword sets the 'Accrue' combobox data in the Admin Fee Notebook.
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${sAdminFee_Accrue}
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AdminFee_Accrue_Combobox}    ${sAdminFee_Accrue}
    Validate String Data In LIQ Object    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFee_Accrue_Combobox}    ${sAdminFee_Accrue}
    
Set Admin Fee Actual Due Date
    [Documentation]    This keyword sets the Actual Due Date in the Admin Fee Notebook
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${sAdminFee_ActualDueDate}
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_ActualDueDate_Datefield}    ${sAdminFee_ActualDueDate}
    Validate String Data In LIQ Object    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_ActualDueDate_Datefield}    ${sAdminFee_ActualDueDate}
    
Set Admin Fee Adjusted Due Date
    [Documentation]    This keyword sets the Adjusted Due Date in the Admin Fee Notebook
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${sAdminFee_AdjustedDueDate}
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    mx LoanIQ enter    ${LIQ_AdminFee_AdjustedDueDate_Datefield}    ${sAdminFee_AdjustedDueDate}
    Validate String Data In LIQ Object    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFee_AdjustedDueDate_Datefield}    ${sAdminFee_AdjustedDueDate}
    
Set Admin Fee End Date
    [Documentation]    This keyword sets the End Date in the Admin Fee Notebook
    ...                @author: bernchua    09JUL2019    Initial create
    [Arguments]    ${sAdminFee_AccrualEndDate}
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    mx LoanIQ enter    ${LIQ_AdminFee_EndDate_Datefield}    ${sAdminFee_AccrualEndDate}
    Validate String Data In LIQ Object    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFee_EndDate_Datefield}    ${sAdminFee_AccrualEndDate}
    
Set Distribution Details in Admin Fee Notebook
    [Documentation]    This keyword adds a bank as Funds Receiver for the Admin Fee.
    ...    @author: bernchua
    ...    @update: bernchua    27MAY2019    search customer first before clicking ok
    ...    @update: fmamaril    15MAY2020    - added argument for keyword pre processing
    [Arguments]    ${sCustomer}    ${sLocation}    ${sExpenseCode}    ${sPercentOfFee}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Customer}    Acquire Argument Value    ${sCustomer}
    ${Location}    Acquire Argument Value    ${sLocation}
    ${ExpenseCode}    Acquire Argument Value    ${sExpenseCode}
    ${PercentOfFee}    Acquire Argument Value    ${sPercentOfFee}
    
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeNotebook_JavaTab}    Distribution
    mx LoanIQ click    ${LIQ_AdminFeeNotebook_Distribution_Add_Button}    
    mx LoanIQ enter    ${LIQ_CustomerSelect_ShortName_Field}    ${Customer}
    mx LoanIQ click    ${LIQ_CustomerSelect_Search_Button}
    mx LoanIQ click    ${LIQ_CustomerListByShortName_OK_Button}
    ${ServicingGroup}    Mx LoanIQ Get Data    ${LIQ_FundReceiverDetails_ServicingGroup_StaticText}    text%text
    Run Keyword If    '${ServicingGroup}'=='NONE'    Run Keywords
    ...    mx LoanIQ click    ${LIQ_FundReceiverDetails_ServicingGroup_Button}
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FundReceiverDetails_Location_JavaTree}    ${Location}%d  
    ...    AND    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    ${ExpenseCodeButton_Status}    Mx LoanIQ Get Data    ${LIQ_FundReceiverDetails_ExpenseCode_Button}    enabled%value       
    Run Keyword If    '${ExpenseCodeButton_Status}'=='1'    Set Admin Fee Funds Receiver Expense Code    ${ExpenseCode}    
    mx LoanIQ enter    ${LIQ_FundReceiverDetails_PercentageFees_Textfield}    ${PercentOfFee}
    mx LoanIQ click    ${LIQ_FundReceiverDetails_OK_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AdminFeeNotebook_Distribution_JavaTree}    ${Customer}%s
    Run Keyword If    ${status}==True    Log    ${Customer} has been added successfully as Funds Receiver.  
    mx LoanIQ select    ${LIQ_AdminFee_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AdminFeeWindow_Distribution   
    
Set Admin Fee Funds Receiver Expense Code
    [Documentation]    This keyword sets the Expense Code of the Admin Fee Funds Receiver.
    ...    @author: bernchua
    ...    @updatE: ritragel    29JUL2019    Changed keyword for selecting string since the ExpenseCode is not working
    [Arguments]    ${ExpenseCode}
    mx LoanIQ click    ${LIQ_FundReceiverDetails_ExpenseCode_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_ExpenseCode_Window}    VerificationData="Yes"
    Run Keyword If    ${status}==True    Run Keywords
    ...    Mx LoanIQ Select String    ${LIQ_DealNotebook_ExpenseCode_JavaTree}    ${ExpenseCode}
    ...    AND    mx LoanIQ click    ${LIQ_DealNotebook_ExpenseCode_OK_Button}
    ...    ELSE    mx LoanIQ enter    ${LIQ_FundReceiverDetails_ExpenseCode_Textfield}    ${ExpenseCode}

Get Admin Fee Due Date
    [Documentation]    This keyword gets the Admin Fee's Due Date from the Notebook's Periods tab.
    ...    @author: bernchua
    ...    @update: fmamaril    15MAY2020    - added argument for keyword pre processing
    [Arguments]    ${sRuntime_Variable}=None
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeNotebook_JavaTab}    Periods
    ${DueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_AdminFeeNotebook_Periods_JavaTree}    1%Due Date%date
    
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${DueDate}
    [Return]    ${DueDate}
    
Admin Fee Save And Exit
    [Documentation]    This keyword saves the Admin Fee and Exits the Notebook.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    mx LoanIQ select    ${LIQ_AdminFee_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}    
    mx LoanIQ select    ${LIQ_AdminFee_File_Exit}    
 
Send Admin Fee to Approval
    [Documentation]    This keyword will send the Admin Fee to Approval
    ...    @author: ritragel
    ...    <update> 14Dec18 - bernchua : Removed logging out from LIQ after sending transaction to approval.
    [Arguments]    ${FeeAlias}
    Mx LoanIQ DoubleClick    ${LIQ_Deal_AdminFees_JavaTree}    ${FeeAlias}
    mx LoanIQ activate window    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeNotebook_JavaTab}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Send to Approval
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ close window    ${LIQ_AdminFeeNotebook_Window}
    # Logout from Loan IQ
    # Login to Loan IQ    ${username}    ${password}
  
Approve Admin Fee
    [Documentation]    This keyword will approve the Admin Fee
    ...    @author: ritragel
    ...    <update> 14Dec18 - bernchua : Removed Releasing of transaction in the keyword since the keyword is for Approving the Admin Fee transaction.
    [Arguments]    ${Deal_Name}    ${FeeAlias}    ${username}    ${password}
    Logout from Loan IQ
    Login to Loan IQ  ${username}    ${password}
    Search for Deal    ${Deal_Name}
    Check if Admin Fee is Added    ${FeeAlias}
    Mx LoanIQ DoubleClick    ${LIQ_Deal_AdminFees_JavaTree}    ${FeeAlias}
    mx LoanIQ activate window    ${LIQ_AdminFeeNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeNotebook_JavaTab}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    # Mx LoanIQ DoubleClick    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Release
    # Mx Click Element If Present    ${LIQ_Question_Yes_Button}
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    # Close All Windows on LIQ
           
Release Admin Fee
    [Documentation]    This keyword will Release the Admin Fee
    ...    @author: ritragel
    ...    <update> 14Dec18 - bernchua : Added closing all windows in LIQ, and re-opening the Deal and Admin Fee Notebook for Release.
    [Arguments]    ${Deal_Name}    ${FeeAlias}
    Close All Windows on LIQ
    Search for Deal    ${Deal_Name}
    Check if Admin Fee is Added    ${FeeAlias}
    Mx LoanIQ DoubleClick    ${LIQ_Deal_AdminFees_JavaTree}    ${FeeAlias}
    mx LoanIQ activate window    ${LIQ_AdminFeeNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeNotebook_JavaTab}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Add Distribution Details in Admin Fee Notebook - Complete Fields
    [Documentation]    This keyword adds a bank as Funds Receiver for the Admin Fee.
    ...    @author: fmamaril
    [Arguments]    ${Customer}    ${Location}    ${ExpenseCode}    ${PercentOfFee}    ${AdminFee_Alias}    ${AdminFee_ServicingGroup}    ${AdminFee_Method}
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeNotebook_JavaTab}    Distribution
    mx LoanIQ click    ${LIQ_AdminFeeNotebook_Distribution_Add_Button}    
    mx LoanIQ enter    ${LIQ_CustomerSelect_ShortName_Field}    ${Customer}
    mx LoanIQ click    ${LIQ_CustomerSelect_OK_Button}
    Verify If Text Value Exist as Static Text on Page    Funds Receiver Details    ${Customer}
    ${ServicingGroup}    Mx LoanIQ Get Data    ${LIQ_FundReceiverDetails_ServicingGroup_StaticText}    text%text
    Run Keyword If    '${ServicingGroup}'=='NONE'    Run Keywords
    ...    mx LoanIQ click    ${LIQ_FundReceiverDetails_ServicingGroup_Button}
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FundReceiverDetails_Location_JavaTree}    ${Location}%d
    ...    AND    Mx LoanIQ Select String    ${LIQ_ServicingGroups_JavaTree}   ${AdminFee_Alias}
    ...    AND    Mx LoanIQ Select String    ${LIQ_ServicingGroups_GroupMembers_JavaTree}   ${AdminFee_ServicingGroup}
    ...    AND    Mx LoanIQ Select String    ${LIQ_ServicingGroups_RemittanceInctructions_JavaTree}   ${AdminFee_Method}  
    ...    AND    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    ${ExpenseCodeButton_Status}    Mx LoanIQ Get Data    ${LIQ_FundReceiverDetails_ExpenseCode_Button}    enabled%value       
    Run Keyword If    '${ExpenseCodeButton_Status}'=='1'    Set Admin Fee Funds Receiver Expense Code    ${ExpenseCode}    
    mx LoanIQ enter    ${LIQ_FundReceiverDetails_PercentageFees_Textfield}    ${PercentOfFee}
    mx LoanIQ click    ${LIQ_FundReceiverDetails_OK_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AdminFeeNotebook_Distribution_JavaTree}    ${Customer}%s
    Run Keyword If    ${status}==True    Log    ${Customer} has been added successfully as Funds Receiver.
    mx LoanIQ select    ${LIQ_AdminFee_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    

Get Admin Fee Notebook Name
    [Documentation]    This keyword returns the value "Admin Fee" from its window name.
    ...    @author: rtarayao    02SEP2019    - initial create
    ${WindowName}    Mx LoanIQ Get Data    ${LIQ_AdminFeeNotebook_Window}    text%notebook    
    ${IntialList}    Split String    ${WindowName}    ${SPACE}/
    ${InitialListValue}    Get From List    ${IntialList}    0
    ${status}    Run Keyword And Return Status    Should Contain    ${InitialListValue}    Amortizing
    ${FinalList}    Run Keyword If    '${status}'=='True'    Split String    ${InitialListValue}    :${SPACE}Amortizing${SPACE}
    ...    ELSE IF    '${status}'=='False'    Split String    ${InitialListValue}    :${SPACE}Accruing${SPACE}    
    ${FinalListValue}    Get From List    ${FinalList}    1
    Log    The final list value is ${FinalListValue}
    [Return]    ${FinalListValue}     

Set Amortizing Admin Fee General Details
    [Documentation]    This keyword sets the general details in the Admin Fee Notebook
    ...    @author: fmamaril    27SEP2019    Initial create
    [Arguments]    ${sAdminFee_AmountType}    ${sAdminFee_Amount}    ${sAdminFee_EffectiveDate}    ${sAdminFee_Frequency}
    ${SysDate}    Get System Date
    mx LoanIQ activate    ${LIQ_AdminFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AdminFeeNotebook_JavaTab}    General
    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_Amortize_NextPeriodAmount_Textfield}    ${sAdminFee_Amount}    
    mx LoanIQ enter    ${LIQ_AdminFeeNotebook_EffectiveDate_Datefield}    ${sAdminFee_EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AdminFeeNotebook_PeriodFrequency_Combobox}    ${sAdminFee_Frequency}

Navigate to Admin Fee Workflow and Proceed With Transaction
    [Documentation]    This keyword navigates to the Admin Fee Workflow using the desired Transaction
    ...  @author: ehugo    29JUN2020    Initial create
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_AdminFeeNotebook_Window}    ${LIQ_AdminFeeNotebook_JavaTab}    ${LIQ_AdminFeeNotebook_Workflow_JavaTree}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AdminFee_Workflow