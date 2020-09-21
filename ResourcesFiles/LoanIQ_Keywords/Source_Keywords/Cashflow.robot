*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Verify if Method has Remittance Instruction
    [Documentation]    This keyword is used to validate the Cashflow Information.
    ...    @author: ritragel
    ...    @update: ritragel    03MAR2019    Updated for the global of cashflow keywords
    ...    @update: rtarayao    27MAR2019    Added transaction amount and currency as optional values to cater multiple entries with same customer
    ...    @update: rtarayao    02APR2019    Added set variable for the two conditions on Cashflow method.
    ...    @update: bernchua    27JUN2019    Updated condition logic
    ...    @update: amansuet    added keyword pre processing
    ...    @update: hstone      12MAY20202   Updated Acquire Argument Value Return variable names to match keyword processing variables.
    ...                                      Added ${sColumnValue} Argmument with a Default value of 'Method'
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing for other arguments; added screenshot
    ...    @update: dfajardo    16JUL2020    added keyword pre processing
    ...    @update: sahalder    22072020    added condition for handling the SPAP remittance instruction
    [Arguments]    ${sCustomerShortName}    ${sRemittanceDescription}    ${sRemittanceInstruction}    ${sTransactionAmount}=None    ${sCurrency}=None

    ### Keyword Pre-processing ###
    ${CustomerShortName}    Acquire Argument Value    ${sCustomerShortName}
    ${RemittanceDescription}    Acquire Argument Value    ${sRemittanceDescription}
    ${RemittanceInstruction}    Acquire Argument Value    ${sRemittanceInstruction}
    ${TransactionAmount}    Acquire Argument Value    ${sTransactionAmount}
    ${Currency}    Acquire Argument Value    ${sCurrency}

    ${CashflowMethod}    Set Variable
    ${CashflowMethod1}    Run Keyword If    '${TransactionAmount}'=='None' and '${Currency}'=='None'    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Tree}    ${CustomerShortName}%Method%Value_Variable
    Run Keyword If    '${TransactionAmount}'=='None'    Set Global Variable    ${CashflowMethod}    ${CashflowMethod1}
    ${CashflowMethod2}    Run Keyword If    '${TransactionAmount}'!='None'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Cashflows_Tree}    ${TransactionAmount}${SPACE}${Currency}%Method%Value_Variable
    Run Keyword If    '${TransactionAmount}'!='None'    Set Global Variable    ${CashflowMethod}    ${CashflowMethod1}
    Log    ${CashflowMethod}
    Run Keyword If    '${CashflowMethod}'!='${RemittanceInstruction}'    Run Keyword If    '${RemittanceInstruction}'=='SPAP'    Add SPAP As Remittance Instructions    ${CustomerShortName}    ${RemittanceDescription}    ${TransactionAmount}    ${Currency}
    ${CashflowMethod1}    Run Keyword If    '${TransactionAmount}'=='None' and '${Currency}'=='None'    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Tree}    ${CustomerShortName}%Method%Value_Variable
    Run Keyword If    '${TransactionAmount}'=='None'    Set Global Variable    ${CashflowMethod}    ${CashflowMethod1}
    ${CashflowMethod2}    Run Keyword If    '${TransactionAmount}'!='None'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Cashflows_Tree}    ${TransactionAmount}${SPACE}${Currency}%Method%Value_Variable
    Run Keyword If    '${TransactionAmount}'!='None'    Set Global Variable    ${CashflowMethod}    ${CashflowMethod1}
    Log    ${CashflowMethod}
    Run Keyword If    '${CashflowMethod}'!='${RemittanceInstruction}'    Add Remittance Instructions    ${CustomerShortName}    ${RemittanceDescription}    ${TransactionAmount}    ${Currency}
    ...    ELSE    Log    Remittance Instruction is already correct

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowNotebook

Add Remittance Instructions
    [Documentation]    This keyword is used to select remittance instruction thru the Cashflow window.
    ...    @author: ritragel
    ...    @update: ritragel    03MAR2019    Updated for the global of cashflow keywords
    ...    @update: rtarayao    27MAR2019    Added transaction amount and currency as optional values to cater multiple entries with same customer
    ...    @upated: dfajardo    04AUG2020    Added Run Keyword if for buttons: LIQ_Cashflows_DetailsForCashflow_SelectRI_Button and LIQ_Cashflows_DetailsForCashflow_ViewRI_Button
    ...    @update: AmitP       15SEPT2020   Added  argument  for ${sLoanGlobalInterest} to add in the Transaction Amount.
    [Arguments]    ${sCustomerShortName}    ${sRemittanceDescription}    ${sTransactionAmount}=None    ${sCurrency}=None    ${sLoanGlobalInterest}=None
    Log    ${sLoanGlobalInterest}
    Log    ${sTransactionAmount}
    ${LoanGlobalInterest}    Remove String    ${sLoanGlobalInterest}    ,
    ${TransactionAmount}    Remove String    ${sTransactionAmount}    ,     
    ${TotalTransactionAmount}    Run Keyword If    '${sLoanGlobalInterest}'!='None'    Evaluate    ${TransactionAmount}+${LoanGlobalInterest}
    ...    ELSE    Set Variable    ${TransactionAmount}    
    ${TotalTransactionAmount}    Convert Number With Comma Separators    ${TotalTransactionAmount}        
    Run Keyword If    '${sTransactionAmount}'=='None'    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${sCustomerShortName}%d
    Run Keyword If    '${sTransactionAmount}'!='None'    Run keywords    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Tree}    ${TotalTransactionAmount}${SPACE}${sCurrency}%${TotalTransactionAmount}${SPACE}${sCurrency}%Original Amount/CCY
    ...    AND    Mx Press Combination    Key.ENTER  
    mx LoanIQ activate    ${LIQ_Cashflows_DetailsForCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Cashflows_DetailsForCashflow_Window}     VerificationData="Yes"
    ${LIQ_Cashflows_DetailsForCashflow_SelectRI_ButtonVisible}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Cashflows_DetailsForCashflow_SelectRI_Button}    VerificationData="Yes"
    Run Keyword If    ${LIQ_Cashflows_DetailsForCashflow_SelectRI_ButtonVisible}==True    mx LoanIQ click    ${LIQ_Cashflows_DetailsForCashflow_SelectRI_Button} 
    ...    ELSE      mx LoanIQ click    ${LIQ_Cashflows_DetailsForCashflow_ViewRI_Button} 
    mx LoanIQ activate    ${LIQ_Cashflows_ChooseRemittanceInstructions_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_ChooseRemittanceInstructions_Tree}    ${sRemittanceDescription}%s 
    mx LoanIQ click    ${LIQ_Cashflows_ChooseRemittanceInstructions_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowVerification
    mx LoanIQ click    ${LIQ_Cashflows_DetailsForCashflow_OK_Button}

Verify if Status is set to Do It
    [Documentation]    This keyword will verify the status of the Cashflow then set it to Do It.
    ...    @author: jdelacru
    ...    @update: ritragel    03MAR19    Updated for the global use of cashflow keywords
    ...    @update: rtarayao    27MAR2019    Added remittance transaction and transaction amount as optional values to cater multiple entries with same customer
    ...    @update: rtarayao    11OCT2019    Added selection of status for remittance instruction
    ...    @update: amansuet    added keyword pre processing
    ...    @update: ehugo    01JUN2020    - updated screenshot location
    ...    @update: dfajardo    16JUL2020    added keyword pre processing
    [Arguments]    ${sCustomerShortName}    ${sRemittanceInstruction}=None    ${sTransactionAmount}=None

    ### GetRuntime Keyword Pre-processing ###
    ${CustomerShortName}    Acquire Argument Value    ${sCustomerShortName}
    ${RemittanceInstruction}    Acquire Argument Value    ${sRemittanceInstruction}
    ${TransactionAmount}    Acquire Argument Value    ${sTransactionAmount}

    ${CashflowStatus}    Set Variable    
    ${CashflowStatus1}    Run Keyword If    '${RemittanceInstruction}'=='None'    Run Keyword If    '${TransactionAmount}'=='None'   Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Tree}    ${sCustomerShortName}%Status%Status_Variable
    Run Keyword If    '${RemittanceInstruction}'=='None'    Set Global Variable    ${CashflowStatus}    ${CashflowStatus1}
    ${CashflowStatus2}    Run Keyword If    '${RemittanceInstruction}'!='None'    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Tree}    ${RemittanceInstruction}%Status%Status_Variable
    Run Keyword If    '${RemittanceInstruction}'!='None'    Set Global Variable    ${CashflowStatus}    ${CashflowStatus2}
    ${CashflowStatus3}    Run Keyword If    '${TransactionAmount}'!='None'    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Tree}    ${TransactionAmount}%Status%Status_Variable
    Run Keyword If    '${TransactionAmount}'!='None'    Set Global Variable    ${CashflowStatus}    ${CashflowStatus3}
    Log    ${CashflowStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowStatus}    PEND
    Run Keyword If    '${status}'=='True'    Run Keyword If    '${RemittanceInstruction}'=='None'    Run Keyword If    '${TransactionAmount}'=='None'    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${sCustomerShortName}%s    
    Run Keyword If    '${status}'=='True'    Run Keyword If    '${RemittanceInstruction}'!='None'    Run Keywords    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Tree}    ${RemittanceInstruction}%${RemittanceInstruction}%Method
    ...    AND    mx LoanIQ click    ${LIQ_Cashflows_SetSelectedItemTo_Button}      
    Run Keyword If    '${status}'=='True'    Run Keyword If    '${TransactionAmount}'!='None'    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Tree}    ${TransactionAmount}%${TransactionAmount}%Tran Amount    
    Run Keyword If    '${status}'=='True'    Run Keyword If    '${RemittanceInstruction}'=='None'    mx LoanIQ click    ${LIQ_Cashflows_SetSelectedItemTo_Button}    
    Run Keyword If    '${status}'=='True'    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowNotebook_CashflowVerification
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowsForLoanRepricing
    
Get Transaction Amount in Cashflow
    [Documentation]    This keyword will use the Customer Shortname as the index for identifying the Tran Amount inside the Cashflow
    ...    @author: ritragel
    ...    @update: hstone    27APR2020    - Added Keyword Post-processing: Runtime Value Save
    ...                                    - Added ${sRuntimeVar_TransactionAmount} argument
    ...                                    - Added Keyword Pre-processing: Acquire Argument Value
    ...    @update: ehugo    05JUN2020    - added screenshot
    [Arguments]    ${sCustomerShortName}    ${sRuntimeVar_TransactionAmount}=None

    ### Keyword Pre-processing ###
    ${CustomerShortName}    Acquire Argument Value    ${sCustomerShortName}

    ${UiTranAmount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Tree}    ${CustomerShortName}%Tran Amount%Tran
    ${UiTranAmount}    Remove Comma and Convert to Number    ${UiTranAmount}
    Log To Console    UI Transaction Amount: ${UiTranAmount}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflows_TransactionAmount

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntimeVar_TransactionAmount}    ${UiTranAmount}

    [Return]    ${UiTranAmount}

Get Host Bank Cash in Cashflow
    [Documentation]    This keyword is used to get Host Bank cash value
    ...    @author: ritragel
    ...    @update: hstone    27APR2020    - Added Keyword Post-processing: Runtime Value Save
    ...                                    - Added ${sRuntimeVar_HostBankShares} argument
    ...    @update: ehugo    01JUN2020    - added screenshot
    ...    @update: dfajardo    16JUL2020    added keyword pre processing
    [Arguments]    ${sCurrency}=AUD    ${sRuntimeVar_HostBankShares}=None
    
    ### Keyword Pre-processing ###
    ${Currency}    Acquire Argument Value    ${sCurrency}
    Log    ${Currency}
    ${HostBankShares}    Mx LoanIQ Get Data    ${LIQ_Cashflows_HostBankCashNet_Text}    value%value  
    ${HostBankShares}    Strip String    ${HostBankShares}    characters=${Currency}
    ${HostBankShares}    Remove Comma and Convert to Number    ${HostBankShares}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowNotebook_HostBankCash

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntimeVar_HostBankShares}    ${HostBankShares}

    [Return]    ${HostBankShares}

Add Principal and Borrower Transaction Amount
    [Documentation]    This keyword will add the Principal and Borrower Amount for Paperclip Transactions
    ...    @author: ritragel    27SEP2019    Initial Create
    [Arguments]    ${sPrincipalAmount}    ${sBorrowerTranAmount}
    ${iPrincipalAmount}    Remove Comma and Convert to Number    ${sPrincipalAmount}
    ${iBorrowerTranAmount}    Remove Comma and Convert to Number    ${sBorrowerTranAmount}
    ${iTotalAmount}    Evaluate    ${iPrincipalAmount}+${iBorrowerTranAmount}
    [Return]    ${iTotalAmount}

Compute Lender Share Transaction Amount
    [Documentation]    This keyword will compute the Lender Share transaction based on the defined percentage in Primaries
    ...    @author: ritragel
    ...    @update: jdelacru    08MAR2019    - added conversion to number of iLenderSharePct
    ...                         20MAR2019    - Added convertion to number after evaluation to return two decimal places
    ...    @update: hstone      27APR2020    - Added ${sRuntimeVar_LenderShareTranAmt} Argument
    ...                                      - Added Keyword Post-processing for runtime value save
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing
    [Arguments]    ${iTranAmount}    ${iLenderSharePct}    ${sRuntimeVar_LenderShareTranAmt}=None

    ### GetRuntime Keyword Pre-processing ###
    ${TransactionAmount}    Acquire Argument Value    ${iTranAmount}
    ${LenderSharePct}    Acquire Argument Value    ${iLenderSharePct}

    Log    Transaction Amount: ${TransactionAmount}
    Log    Lender Share Percent: ${LenderSharePct}
    ${TransactionAmount}    Remove Comma and Convert to Number    ${TransactionAmount}
    ${LenderSharePct}    Remove Comma and Convert to Number    ${LenderSharePct}
    ${LenderSharePct}    Evaluate    ${LenderSharePct}/100
    ${iLenderShareTranAmt}    Evaluate    ${TransactionAmount}*${LenderSharePct}
    ${iLenderShareTranAmtTwoDecimalPlaces}    Remove Comma and Convert to Number    ${iLenderShareTranAmt}
    ${sLenderShareTranAmt}    Convert To String    ${iLenderShareTranAmtTwoDecimalPlaces}
    Log    ${sLenderShareTranAmt}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntimeVar_LenderShareTranAmt}    ${sLenderShareTranAmt}

    [Return]    ${sLenderShareTranAmt}

Compare UIAmount versus Computed Amount
    [Documentation]    This keyword will compare the computed amount of Cashflow versus the amount in LoanIQ UI.
    ...    Note that UI amount and Computed amount values should arrangement should be Host Bank, Lender1, Lender2
    ...    Pipeline | will serve as the delimiter for each values
    ...    @author: ritragel
    ...    @update: hstone    27APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...    @update: ehugo     01JUN2020    - updated screenshot location
    ...    @update: hsdtone   19JUN2020    - Added:
    ...                                        > '${UiAmount}    Remove Comma and Convert to Number    ${UiAmount}'
    ...                                        > '${ComputedAmount}    Remove Comma and Convert to Number    ${ComputedAmount}'
    [Arguments]    ${sUIAmount}    ${sComputedAmount}

    ### Keyword Pre-processing ###
    ${UIAmount}    Acquire Argument Value    ${sUIAmount}
    ${ComputedAmount}    Acquire Argument Value    ${sComputedAmount}

    @{aUIAmount}    Split String    ${UIAmount}    |
    @{aComputedAmount}    Split String    ${ComputedAmount}    |
    ${iTotalUiAmount}    Get Length    ${aUIAmount}
    :FOR    ${i}    IN RANGE    ${iTotalUiAmount}
    \    Log    ${i}
    \    ${UiAmount}    Strip String    ${SPACE}@{aUIAmount}[${i}]${SPACE}
    \    ${ComputedAmount}    Strip String    ${SPACE}@{aComputedAmount}[${i}]${SPACE}
    \    ${UiAmount}    Remove Comma and Convert to Number    ${UiAmount}
    \    ${ComputedAmount}    Remove Comma and Convert to Number    ${ComputedAmount}
    \    Should Be Equal As Numbers    ${UiAmount}    ${ComputedAmount}
    \    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowVerification

Navigate to GL Entries
    [Documentation]    This keyword will be used to navigate to GL Entries from Cashflow Window
    ...    @author: ritragel
    ...    @update: ehugo    01JUN2020    - added screenshot

    mx LoanIQ activate window    ${LIQ_Cashflows_Window}    
    mx LoanIQ select    ${LIQ_Cashflows_Queries_GLEntries} 
    mx LoanIQ activate window  ${LIQ_GL_Entries_Window}   
    mx LoanIQ maximize    ${LIQ_GL_Entries_Window}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GLEntriesWindow

Get GL Entries Amount
    [Documentation]    This keyword is used to get credit amount in GL Entries
    ...    @author: ritragel
    ...    @update: hstone    27APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                    - Added Keyword Post-processing: Runtime Value Save
    ...                                    - Added ${sRuntimeVar_UIValue} Argument
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing for other arguments; added screenshot
    [Arguments]    ${sRowValue}    ${sGLColumnName}    ${sRuntimeVar_UIValue}=None

    ### Keyword Pre-processing ###
    ${RowValue}    Acquire Argument Value    ${sRowValue}
    ${GLColumnName}    Acquire Argument Value    ${sGLColumnName}

    Log    Row value: ${sRowValue}
    ${UI_Value}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${RowValue}%${GLColumnName}%var    Processtimeout=180
    ${UI_Value}    Remove Comma and Convert to Number    ${UI_Value}
    Log    ${GLColumnName} value is ${UI_Value}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GLEntriesWindow_GLEntriesAmount

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntimeVar_UIValue}    ${UI_Value}

    [Return]    ${UI_Value} 

Validate if Debit and Credit Amt is Balanced
    [Documentation]    This keyword will equalize both debit and credit amount from GL Entries
    ...    @author: ritragel
    ...    @update: hstone    27APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...    @update: ehugo     01JUN2020    - updated screenshot location
    ...    @update: hstone    19JUN2020    - Replace 'Convert to Number' with 'Remove Comma and Convert to Number'
    [Arguments]    ${sLenderShares}    ${sBorrowerShares}

    ### Keyword Pre-processing ###
    ${aLenderShares}    Acquire Argument Value    ${sLenderShares}
    ${aBorrowerShares}    Acquire Argument Value    ${sBorrowerShares}

    @{aLenderShares}    Split String    ${aLenderShares}    |
    @{aBorrowerShares}    Split String    ${aBorrowerShares}    |
    ${iLenderShares}    Get Length    ${aLenderShares}
    ${iBorrowerShares}    Get Length    ${aBorrowerShares}
    Set Test Variable    ${iTotalLenderShares}    0
    :FOR    ${i}    IN RANGE    ${iLenderShares}
    \    Log    ${i}
    \    ${iLenderShares}    Strip String    ${SPACE}@{aLenderShares}[${i}]${SPACE}
    \    ${iLenderShares}    Remove Comma and Convert to Number    ${iLenderShares}                                    
    \    ${iSum}    Evaluate    ${iTotalLenderShares}+${iLenderShares}
    \    Set Test Variable    ${iTotalLenderShares}    ${iSum}
    \    Log    ${iTotalLenderShares}
    \    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowVerification

    
    Set Test Variable    ${iTotalBorrowerShares}    0
    :FOR    ${i}    IN RANGE    ${iBorrowerShares}
    \    Log    ${i}
    \    ${iBorrowerShares}    Strip String    ${SPACE}@{aBorrowerShares}[${i}]${SPACE}
    \    ${iBorrowerShares}    Remove Comma and Convert to Number    ${iBorrowerShares}                                    
    \    ${iSum}    Evaluate    ${iTotalBorrowerShares}+${iBorrowerShares}
    \    Set Test Variable    ${iTotalBorrowerShares}    ${iSum}
    \    Log    ${iTotalBorrowerShares}
    \    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowVerification

    ${status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${iTotalLenderShares}    ${iTotalBorrowerShares}  
    Run Keyword If    '${status}'=='True'    Log    Passed: Credit and Debit is balanced
    ...    ELSE    Log    Failed: Credit and Debit is not balanced  
    
Validate if Debit and Credit Amt is equal to Transaction Amount
    [Documentation]    This keyword will validate if the computed tran amount from UI is equal to the Total Tran Amount
    ...    @author: ritragel
    ...    @update: rtarayao    10OCT2019    added keyword for warning message
    ...    @update: hstone      27APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...    @update: ehugo    01JUN2020    - added screenshot
    [Arguments]    ${sUICreditAmt}    ${sUIDebitAmt}    ${sTotalAmount}
    
    ### Keyword Pre-processing ###
    ${iUICreditAmt}    Acquire Argument Value    ${sUICreditAmt}
    ${iUIDebitAmt}    Acquire Argument Value    ${sUIDebitAmt}
    ${iTotalAmount}    Acquire Argument Value    ${sTotalAmount}

    ${iTotalAmount}    Remove Comma and Convert to Number    ${iTotalAmount}
    
    ${status}    Run Keyword And Return Status    Should Be Equal    ${iUICreditAmt}    ${iTotalAmount}  
    Run Keyword If    '${status}'=='True'    Log    Passed: Credit Amount is equal to Total Amount
    ...    ELSE    Log    Failed: UI Value and Computed Value is not the same    LEVEL=ERROR
    
    ${status}    Run Keyword And Return Status    Should Be Equal    ${iUIDebitAmt}    ${iTotalAmount}  
    Run Keyword If    '${status}'=='True'    Log    Passed: Debit Amount is equal to Total Amount
    ...    ELSE    Log    Failed: UI Value and Computed Value is not the same    LEVEL=ERROR    

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GLEntriesWindow_Verification

    mx LoanIQ close window    ${LIQ_GL_Entries_Window}
    mx LoanIQ click element if present   ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present   ${LIQ_Warning_Yes_Button}

Release Cashflow
    [Documentation]    This keyword will release the Cashflows applicable for any transaction types
    ...    Transaction amounts can also be used as argument
    ...    @author: jdelacru
    ...    @update: ritragel    22MAR2019    - Added condition that if the testcase will be Admin Fee, it will already proceed to release
    ...    @update: rtarayao    28MAR2019    - Added remittance instruction as optional value to cater multiple entries with same customer
    ...    @update: hstone      19MAY2020    - Fixed keyword line spacing
    ...    @update: hstone      22MAY2020    - Added Take Screenshot
    ...    @update: hstone      06JUL2020    - Added 'mx LoanIQ activate window    ${LIQ_Cashflows_Window}'
    ...    @update: hstone      20JUL2020    - Added Keyword Pre-processing
    [Arguments]    ${sName}    ${sTestCase}=default    ${sDataType}=default

    ### Keyword Pre-processing ####
    ${Name}    Acquire Argument Value    ${sName}
    ${TestCase}    Acquire Argument Value    ${sTestCase}
    ${DataType}    Acquire Argument Value    ${sDataType}

    mx LoanIQ activate window    ${LIQ_Cashflows_Window}

    @{aName}    Split String    ${Name}    |
    ${iTotalNames}    Get Length    ${aName}  
    :FOR    ${i}    IN RANGE    ${iTotalNames}
    \    Log    Data Type: ${DataType}
    \    Verify if Status is set to Release it    @{aName}[${i}]    ${DataType}
    Run Keyword If    '${TestCase}'=='release'  mx LoanIQ click    ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflows
    mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}

Create Cashflow
    [Documentation]    This keyword replicates the keyword of Release cashflow with the same logic of the keyword
    ...    Transaction amounts can also be used as argument
    ...    @author: ritragel
    ...    @update: hstone      19MAY2020    - Fixed keyword line spacing
    ...                                      - Added Keyword Pre-processing
    ...    @update: hstone      22MAY2020    - Added Take Screenshot
    [Arguments]    ${sName}    ${sTestCase}=default

    ### Keyword Pre-processing ###
    ${Name}    Acquire Argument Value    ${sName}
    ${TestCase}    Acquire Argument Value    ${sTestCase}

    @{aName}    Split String    ${Name}    |
    ${iTotalNames}    Get Length    ${aName}  
    :FOR    ${i}    IN RANGE    ${iTotalNames}
    \    Verify if Status is set to Do It    @{aName}[${i}]
    Run Keyword If    '${TestCase}'=='release'    mx LoanIQ click    ${LIQ_Cashflows_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflows
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}

Verify if Status is set to Release it
    [Documentation]    This keyword will used to set the Cashflow entry to Release it. Customer name will be the unique identifier inside the JavaTree
    ...    @author: jdelacru    Initial Create
    ...    @update: rtarayao    28MAR2019    Added remittance instruction as argument to cater multiple entries with same customer    
    ...    @update: rtarayao    04APR2019    Updated arguments and logic to handle any type of data input.
    [Arguments]    ${sTableValue}    ${sDataType}
    ${CashflowStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Tree}    ${sTableValue}%Status%var
    Log To Console    ${CashflowStatus} 
    Log    ${sDataType}
    Run Keyword If    '${sDataType}'=='default'    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_Cashflows_Tree}    ${sTableValue}%s
    Run Keyword If    '${sDataType}'=='int'    Mx LoanIQ Click Javatree Cell   ${LIQ_Cashflows_Tree}    ${sTableValue}%${sTableValue}%Tran Amount
    mx LoanIQ click    ${LIQ_Cashflows_MarkSelectedItemForRelease_Button}
    Take Screenshot    CashflowVerification
    Log    Verify Status is set to Release It is complete 

Open Cashflows Window from Notebook Menu
    [Documentation]    This keyword opens the Cashflow window from any Notebook's menu
    ...                @author: bernchua    09MAR2019    initial create
    [Arguments]        ${sNotebookLocator}    ${sNotebookMenuLocator}    
    mx LoanIQ activate    ${sNotebookLocator}
    mx LoanIQ select    ${sNotebookMenuLocator}
    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}

Click OK In Cashflows
    [Documentation]    This keyword clicks the OK button in the Cashflows window after all validations are complete.
    ...    @author: bernchua    03JUN2019    Initial create
    mx LoanIQ activate    ${LIQ_Cashflows_Window}
    mx LoanIQ click    ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
Cashflows Mark All To Release
    [Documentation]    This keyword clicks the "Mark All To Release" menu in the Cashflows window.
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_Cashflows_Window}
    mx LoanIQ select    ${LIQ_Cashflow_Options_MarkAllRelease}

# Navigate to Payment Cashflow Window
    # [Documentation]    This keyword is used to navigate to the Payment Cashflow Window thru the Workflow action - Create Cashflow.
    # ...    @author: rtarayao
    # ...    @author: ghabal/mgaling: added 'Mx Activate Window ${LIQ_Payment_Cashflows_Window}' prior to 'Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_Window}'    VerificationData="Yes"
    # ...    for Scenario 4 integration
    # ...    @update: fmamaril: Added click element if present for warning - 10/16/2018
    # ...    @update: ritragel: Added additional warning for Non-Business Day
    
    # Mx Activate Window    ${LIQ_Payment_Window}
    # Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    # Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Create Cashflows
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    # Mx Activate Window    ${LIQ_Payment_Cashflows_Window}                     
    
# Navigate to Interest Payment Cashflow Window
    # [Documentation]    This keyword is used to navigate to the Interest Payment Cashflow Window thru the Workflow action - Create Cashflow.
    # ...    @author: rtarayao
    # ...    <update> @author: ghabal - created separate keyword for Scenario 8 due to different locator    
    # Mx Activate Window    ${LIQ_Payment_Window}
    # Mx LoanIQ Select Window Tab    ${LIQ_InterestPayment_Tab}    Workflow
    # Mx LoanIQ DoubleClick    ${LIQ_Interest_WorkflowItems}    Create Cashflows
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    # Mx Activate Window    ${LIQ_Payment_Cashflows_Window}                         

# Open Payment Notebook via WIP - Awaiting Release Cashflow
    # [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting Release Cashflow Status thru the LIQ WIP Icon.
    # ...    @author: rtarayao
    # [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingReleaseCashflowsStatus}    ${WIP_PaymentType}    ${Loan_Alias}
    # Mx Click    ${LIQ_WorkInProgress_Button}
    # Mx Activate    ${LIQ_WorkInProgress_Window}   
    # Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window} 
    # Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflowsStatus}         
    # Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflowsStatus}
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    # Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
    # Mx Maximize    ${LIQ_WorkInProgress_Window}  
    # Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    # Mx Native Type    {PGDN} 
    # Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%s
    # Mx Wait    3s  
    # Mx Close Window    ${LIQ_WorkInProgress_Window} 
    # Mx Activate    ${LIQ_Payment_Window}
    
# Open Payment Notebook via WIP - Awaiting Release
    # [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting Release Status thru the LIQ WIP Icon.
    # ...    @author: rtarayao
    # [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingRelease}    ${WIP_PaymentType}    ${Loan_Alias}
    # Mx Click    ${LIQ_WorkInProgress_Button}
    # Mx Activate    ${LIQ_WorkInProgress_Window}   
    # Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window} 
    # Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRelease}         
    # Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRelease}
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    # Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
    # Mx Maximize    ${LIQ_WorkInProgress_Window}  
    # Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    # Mx Native Type    {PGDN} 
    # Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    # Mx Wait    3s  
    # Mx Close Window    ${LIQ_WorkInProgress_Window} 
    # Mx Activate    ${LIQ_Payment_Window}
    
# Open Repayment Paper Clip Notebook via WIP - Awaiting Release
    # [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting Release Status thru the LIQ WIP Icon.
    # ...    @author: rtarayao
    # [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingRelease}    ${WIP_PaymentType}    ${Payment}
    # Log    ${Payment}    
    # ${Payment}    Convert Number With Comma Separators    ${Payment}
    # Mx Click    ${LIQ_WorkInProgress_Button}
    # Mx Activate    ${LIQ_WorkInProgress_Window}   
    # Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window} 
    # Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRelease}         
    # Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRelease}
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    # Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
    # Mx Maximize    ${LIQ_WorkInProgress_Window}  
    # Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    # Mx Native Type    {PGDN} 
    # Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Payment}%d
    # Mx Wait    3s  
    # Mx Close Window    ${LIQ_WorkInProgress_Window} 
    # Mx Activate    ${LIQ_Repayment_Window}

# Open Repayment Paper Clip Notebook via WIP - Awaiting Generate Intent Notices
    # [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting Generate Intent Notices thru the LIQ WIP Icon.
    # ...    @author: rtarayao
    # [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingGenerateIntentNotices}    ${WIP_PaymentType}    ${Payment}
    # Log    ${Payment}    
    # ${Payment}    Convert Number With Comma Separators    ${Payment}
    # Mx Click    ${LIQ_WorkInProgress_Button}
    # Mx Activate    ${LIQ_WorkInProgress_Window}   
    # Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window} 
    # Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingGenerateIntentNotices}         
    # Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingGenerateIntentNotices}  

    # ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    # Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
   
    # Mx Maximize    ${LIQ_WorkInProgress_Window}  
    # Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    # Mx Native Type    {PGDN} 
    # Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Payment}%d
    # Mx Wait    3s  
  
    # Mx Close Window    ${LIQ_WorkInProgress_Window} 
    
    # Mx Activate    ${LIQ_Repayment_Window}

# Release Interest Payment Cashflows with Two Lenders
    # [Documentation]    This keyword is used to Release the Repayment Cashflows.
    # ...    This is only applicable for interest payment cashflows with two Lenders. 
    # ...    @author: rtarayao
    # [Arguments]    ${Borrower_ShortName}    ${NonHostBank_ShortName}
    
    # Mx Activate    ${LIQ_Payment_Window}
    # Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    # Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Release Cashflows%yes    
    # Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Release Cashflows
    # ####Cashflows#####
    # Mx Activate Window    ${LIQ_Cashflows_Window}
    # Mx Select    ${LIQ_Cashflows_Options_MarkAllToRelease}                                             
    
    # Mx Click    ${LIQ_Cashflows_OK_Button}
    # Mx Click Element If Present    ${LIQ_Question_Yes_Button}    
    # ####Back to Payment Window#####
    # Mx activate    ${LIQ_Payment_Window}
    # Mx Select    ${LIQ_Payment_Options_Cashflow}
    # ###Back to Cashflows window####
    # Mx activate    ${LIQ_Cashflows_Window}
    # ${UIBorrowerRemittanceStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Javatree}    ${Borrower_ShortName}%Status%test
    # ${UINonHBIntRemittanceStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Javatree}    ${NonHostBank_ShortName}%Status%test
  
    # ${RLSED}    Convert To String    RLSED 
    
    # Should Be Equal    ${RLSED}    ${UINonHBIntRemittanceStatus}
    # Should Be Equal    ${RLSED}    ${UIBorrowerRemittanceStatus}
    
    # Validate Lender Payment IMT Swift Message    ${NonHostBank_ShortName}
    # Validate Borrower Payment IMT Swift Message    ${Borrower_ShortName}
    
    # Mx Click    ${LIQ_Cashflows_OK_Button}
    
# Release Payment Cashflows
    # [Documentation]    This keyword is used to Release the Payment Cashflows.
    # ...    @author: rtarayao
    # [Arguments]    ${Remittance_Instruction}    ${Remittance_Status}    ${LIQCustomer_ShortName}    ${Loan_Currency}    ${Payment_Amount}
     
    # Mx Activate    ${LIQ_Payment_Window}
    # Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    # Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Release Cashflows%yes    
    # Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Release Cashflows
    
    # Mx Activate Window    ${LIQ_Payment_Cashflows_Window}           
    
    # ${CashflowMethod_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Payment_Cashflows_List}    ${Remittance_Instruction}%Method%Method_Variable
    # Log To Console    ${CashflowMethod_Variable} 
    # ${CashflowCustomer_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Payment_Cashflows_List}    ${Remittance_Instruction}%Customer%Customer_Variable
    # Log To Console    ${CashflowCustomer_Variable} 
    # ${CashflowStatus_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Payment_Cashflows_List}    ${Remittance_Instruction}%Status%Status_Variable
    # Log To Console    ${CashflowStatus_Variable}
    # ${CashflowCurrency_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Payment_Cashflows_List}    ${Remittance_Instruction}%CCY%Currency_Variable
    # Log To Console    ${CashflowCurrency_Variable}
    # ${CashflowAmount_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Payment_Cashflows_List}    ${Remittance_Instruction}%Tran Amount%Amount_Variable
    # Log To Console    ${CashflowAmount_Variable}
    # ${CashflowAmount_Variable}    Remove Comma and Convert to Number    ${CashflowAmount_Variable}
    # Log To Console    ${Payment_Amount}
    # ${Payment_Amount}    Remove Comma and Convert to Number    ${Payment_Amount}    
    
    # Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Remittance_Instruction}    ${CashflowMethod_Variable}
    # Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQCustomer_ShortName}    ${CashflowCustomer_Variable}
    # Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Remittance_Status}    ${CashflowStatus_Variable}  
    # Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Loan_Currency}    ${CashflowCurrency_Variable}   
    # Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Payment_Amount}    ${CashflowAmount_Variable}                                 
    
    # Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_Cashflows_List}    ${LIQCustomer_ShortName}%s
    
    # Mx Click    ${LIQ_Payment_Cashflows_MarkSelectedItemForRelease_Button}
    # Mx Click    ${LIQ_Payment_Cashflows_OK_Button}
    # Mx Click Element If Present    ${LIQ_Question_Yes_Button}    
    
    # Mx Activate    ${LIQ_Payment_Window}
    # Mx Select    ${LIQ_Payment_Options_Cashflow}
    
    # Mx Activate    ${LIQ_Payment_Cashflows_Window}
    # ${CashflowStatus_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Payment_Cashflows_List}    ${Remittance_Instruction}%Status%Status_Variable
    # Log To Console    ${CashflowStatus_Variable}  
    
    # ${RLSED}    Convert To String    RLSED 
    # Should Be Equal    ${RLSED}    ${CashflowStatus_Variable}
    
    # Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_Cashflows_List}    ${LIQCustomer_ShortName}%d
    # Mx Activate    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}    
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_DetailsforCashflow_IMTDetail_Button}       VerificationData="Yes"
    # Run Keyword If    ${status}==True    Run Keyword    Validate Payment IMT Window      
    
    # Mx Click    ${LIQ_Payment_Cashflows_DetailsforCashflow_Exit_Button}    
    # Mx Click    ${LIQ_Payment_Cashflows_OK_Button}

# Release Payment Cashflows (Scenario 8)
    # [Documentation]    This keyword is used to Release the Repayment Cashflows.
    # ...    @author: rtarayao
    # [Arguments]    ${Borrower_ShortName}    ${LenderSharePct1}    ${LenderSharePct2}    ${Loan_Currency}    ${Computed_LoanIntProjectedCycleDue}    ${Lender_ShareAmount2}
    
    # Mx Activate    ${LIQ_InterestPayment_Window}
    # Mx LoanIQ Select Window Tab    ${LIQ_InterestPayment_Tab}    Workflow
    # Mx LoanIQ Verify Text In Javatree    ${LIQ_Interest_WorkflowItems}    Release Cashflows%yes    
    # Mx LoanIQ DoubleClick    ${LIQ_Interest_WorkflowItems}    Release Cashflows
    # ####Cashflows#####
    # Mx Activate Window    ${LIQ_Payment_Cashflows_Window}
    # Mx Select    ${LIQ_Payment_Cashflows_Options_MarkAllToRelease}                                             
    
    # Mx Click    ${LIQ_Payment_Cashflows_OK_Button}
    # Mx Click Element If Present    ${LIQ_Question_Yes_Button}    
    # ####Back to Repayment Window#####
    # Mx Activate    ${LIQ_InterestPayment_Window}
    # Mx Select    ${LIQ_Interest_Options_Cashflow}
    # ###Back to Cashflows window####
    # Mx activate    ${LIQ_Payment_Cashflows_Window}
    # ${UIBorrowerRemittanceStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Repayment_Cashflows_List}    ${Borrower_ShortName}%Status%test
    # ${UILender1IntRemittanceStatus}    Get Lender Interest Released Remittance Status (Scenario 8)    ${LenderSharePct1}    ${Loan_Currency}    ${Computed_LoanIntProjectedCycleDue}
    # ${UILender2IntRemittanceStatus}    Get Lender Interest Released Remittance Status (Scenario 8)    ${LenderSharePct2}    ${Loan_Currency}    ${Computed_LoanIntProjectedCycleDue}  
    # ${RLSED}    Convert To String    RLSED 
    # Should Be Equal    ${RLSED}    ${UILender1IntRemittanceStatus}
    # Should Be Equal    ${RLSED}    ${UILender2IntRemittanceStatus}
    # Should Be Equal    ${RLSED}    ${UIBorrowerRemittanceStatus}
    
    # Validate Lender Interest IMT Swift Message (Scenario 8)    ${LenderSharePct1}    ${Loan_Currency}    ${Lender_ShareAmount2}
    # Validate Lender Interest IMT Swift Message (Scenario 8)    ${LenderSharePct2}    ${Loan_Currency}    ${Lender_ShareAmount2}
    # Validate Borrower IMT Swift Message    ${Borrower_ShortName}
        
    # Mx Click    ${LIQ_Payment_Cashflows_OK_Button}
        
# Release Drawdown Cashflows
    # [Documentation]    This keyword is used to Release the Loan Initial Drawdown Cashflows.
    # ...    @author: rtarayao
    # [Arguments]    ${Remittance_Instruction}    ${Remittance_Status}    ${LIQCustomer_ShortName}    ${Loan_Currency}    ${Loan_RequestedAmount}
    # Mx Activate    ${LIQ_Drawdown_Window}
    # Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    # Mx LoanIQ Verify Text In Javatree    ${LIQ_Drawdown_WorkflowItems}    Release Cashflows%yes    
    # Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    Release Cashflows
    # Mx Activate Window    ${LIQ_Drawdown_Cashflows_Window}           
    # ${CashflowMethod_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Drawdown_Cashflows_List}    ${Remittance_Instruction}%Method%Method_Variable
    # Log To Console    ${CashflowMethod_Variable} 
    # ${CashflowCustomer_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Drawdown_Cashflows_List}    ${Remittance_Instruction}%Customer%Customer_Variable
    # Log To Console    ${CashflowCustomer_Variable} 
    # ${CashflowStatus_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Drawdown_Cashflows_List}    ${Remittance_Instruction}%Status%Status_Variable
    # Log To Console    ${CashflowStatus_Variable}
    # ${CashflowCurrency_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Drawdown_Cashflows_List}    ${Remittance_Instruction}%CCY%Currency_Variable
    # Log To Console    ${CashflowCurrency_Variable}
    # ${CashflowAmount_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Drawdown_Cashflows_List}    ${Remittance_Instruction}%Tran Amount%Amount_Variable
    # ${CashflowAmount_Variable}    Remove String    ${CashflowAmount_Variable}    ,    
    # ${CashflowAmount_Variable}    Convert To Number    ${CashflowAmount_Variable}    2
    # Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Remittance_Instruction}    ${CashflowMethod_Variable}
    # Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIQCustomer_ShortName}    ${CashflowCustomer_Variable}
    # Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Remittance_Status}    ${CashflowStatus_Variable}  
    # Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Loan_Currency}    ${CashflowCurrency_Variable} 
    # ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}    2  
    # Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${Loan_RequestedAmount}    ${CashflowAmount_Variable}                                 
    # Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Drawdown_Cashflows_List}    ${LIQCustomer_ShortName}%s
    # Mx Click    ${LIQ_Drawdown_Cashflows_MarkSelectedItemForRelease_Button}
    # Mx Click    ${LIQ_Drawdown_Cashflows_OK_Button}
    # Mx Click Element If Present    ${LIQ_Question_Yes_Button}    
    # Mx activate    ${LIQ_Drawdown_Window}
    # Mx Select    ${LIQ_Drawdown_Options_Cashflow}
    # Mx activate    ${LIQ_Drawdown_Cashflows_Window}
    # ${CashflowStatus_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Drawdown_Cashflows_List}    ${Remittance_Instruction}%Status%Status_Variable
    # Log To Console    ${CashflowStatus_Variable}
    # ${RLSED}    Convert To String    RLSED 
    # Should Be Equal    ${RLSED}    ${CashflowStatus_Variable}
    # Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Drawdown_Cashflows_List}    ${LIQCustomer_ShortName}%d
    # Mx Activate    ${LIQ_Drawdown_Cashflows_DetailsforCashflow_Window}    
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Drawdown_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Drawdown_Cashflows_DetailsforCashflow_IMTDetail_Button}       VerificationData="Yes"

    # Run Keyword If    ${status}==True    Run Keyword    Validate Drawdown IMT Window       
    # Mx Click    ${LIQ_Drawdown_Cashflows_DetailsforCashflow_Exit_Button}    
    # Mx Click    ${LIQ_Drawdown_Cashflows_OK_Button}

# Validate Payment IMT Window
    # [Documentation]    This keyword is used to validate the IMT Detail Window of a Payment.
    # ...    @author: rtarayao
    
    # Mx Click    ${LIQ_Payment_Cashflows_DetailsforCashflow_IMTDetail_Button}
    # ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Drawdown_Cashflows_ViewOutgoingIMTMessages_Window}       VerificationData="Yes"
    # Run Keyword If    ${status}==True    Run Keyword    Validate Payment IMT Swift Message Code
    # ...    ELSE IF    ${status}==False    Run Keyword     Mx LoanIQ Click Button On Window    Details for Cashflow.*;Error;OK        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500

# Validate Payment IMT Swift Message Code
    # [Documentation]    This keyword is used to validate the IMT Swift Message Code of a Payment.
    # ...    @author: rtarayao
    
    # Mx Activate Window    ${LIQ_Payment_Cashflows_ViewOutgoingIMTMessages_Window}
    # ${IMTSwiftMessageCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Payment_Cashflows_ViewOutgoingIMTMessages_List}    PEND%SWIFT Message%SwiftMessageCode
    # Log    ${IMTSwiftMessageCode} = IMT Swift Message to be sent. 
    # Mx Click    ${LIQ_Payment_Cashflows_ViewOutgoingIMTMessages_Cancel_Button}                    
    # :FOR    ${i}    IN RANGE    1
     # \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     # \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     # \    Exit For Loop If    ${Warning_Status}==False
     # Run Keyword And Continue On Failure    Verify Window    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}
    
# Create Cashflows
    # [Documentation]    This keyword navigates the Cashflows window to add/update the Remittance Instruction Methods of Customers.
    # ...    
    # ...    | Arguments |
    # ...    'Deal_Name' = Name of the Deal where the Cashflow is transacted.
    # ...    'Customer_Name' = Name of the Customer/Bank who has a transaction in the Cashflow.
    # ...    'RI_Method' = DDA, IMT or RTGS
    # ...    'Amount' = The amount of the transaction.
    # ...    'Currency' = The currency of the transaction.
    # ...    
    # ...    @author: bernchua
    # [Arguments]    ${Deal_Name}    ${Customer_Name}    ${RI_Method}    ${Amount}    ${Currency}
    # Mx Activate    ${LIQ_Cashflows_Window}    
    # Verify If Text Value Exist as Static Text on Page    Cashflows    ${Deal_Name}
    # ${Cashflows_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Cashflows_Tree}    ${Customer_Name}%Tran Amount%amount
    # ${Cashflows_Amount}    Remove Comma, Negative Character and Convert to Number    ${Cashflows_Amount}
    # ${Amount}    Remove Comma, Negative Character and Convert to Number    ${Amount}
    # ${Cashflows_CCY}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Cashflows_Tree}    ${Customer_Name}%CCY%ccy
    # ${Cashflows_Method}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Cashflows_Tree}    ${Customer_Name}%Method%method
    # Run Keyword If    '${Cashflows_Amount}'=='${Amount}'    Log    Customer Cashflow Amount verified.
    # Run Keyword If    '${Cashflows_CCY}'=='${Currency}'    Log    Customer Cashflow Currency verified.    
    # ${Update_Success}    Run Keyword If    '${Cashflows_Method}'=='NONE' or '${Cashflows_Method}'!='${RI_Method}'    Run Keyword And Return Status    
    # ...    Add Or Update Remittance Instructions Method For Cashflow    ${Customer_Name}    ${RI_Method}
    # ...    ELSE IF    '${Cashflows_Method}'=='${RI_Method}'    Run Keyword And Return Status    Get Cashflow Item Status and Set To DoIt If Empty    ${Customer_Name}
    # Run Keyword If    ${Update_Success}==True    Log    Cashflows for ${Customer_Name} verified with Do it ${RI_Method} RI Method.
    
# Add Or Update Remittance Instructions Method For Cashflow
    # [Documentation]    This keyword selects or updates a RI Method in Cashflows when the Customer's Method is 'NONE' or not equal to what should be the RI Method.
    # ...    @author: bernchua
    # [Arguments]    ${Customer_Name}    ${RI_Method}
    # ${RI_Method}    Set Variable If    '${RI_Method}'=='DDA'    DDA (Demand Deposit Acct)
    # ...    '${RI_Method}'=='IMT'    International Money Transfer
    # ...    '${RI_Method}'=='RTGS'    High Value Local RTGS (AUD)
    # Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${Customer_Name}%d
    # Mx Activate    ${LIQ_Cashflows_DetailsForCashflow_Window}
    # Mx Click    ${LIQ_Cashflows_DetailsForCashflow_SelectRI_Button}
    # Verify If Text Value Exist as Static Text on Page    Choose Remittance Instructions    ${Customer_Name}
    # Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_ChooseRemittanceInstructions_Tree}    ${RI_Method}%s
    # Mx Click    ${LIQ_Cashflows_ChooseRemittanceInstructions_OK_Button}
    # ${PaymentMethod_UI}    Mx LoanIQ Get Data    ${LIQ_Cashflows_DetailsForCashflow_PaymentMethod_StaticText}    value%method    
    # Run Keyword If    '${PaymentMethod_UI}'=='${RI_Method}'    mx LoanIQ click    ${LIQ_Cashflows_DetailsForCashflow_OK_Button}
    # ...    ELSE IF    '${PaymentMethod_UI}'!='${RI_Method}'    Add Or Update Remittance Instructions Method For Cashflow    ${Customer_Name}    ${RI_Method}
    
# Get Cashflow Item Status and Set To DoIt If Empty
    # [Documentation]    This keyword gets the Cashflow Item's status, and clicks the "Set Selected Item to 'Do it'" button when the status is blank.
    # ...    @author: bernchua
    # [Arguments]    ${Customer_Name}
    # ${Cashflows_Status}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Cashflows_Tree}    ${Customer_Name}%Status%status
    # Run Keyword If    '${Cashflows_Status}'=='PEND'    Run Keywords
    # ...    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${Customer_Name}%s    
    # ...    AND    mx LoanIQ click    ${LIQ_Cashflows_SetSelectedItemTo_Button}

# Validate Facility Lender Share GL Entries
    # [Documentation]    This keyword opens the GL Entries from the Cashflows window and verifies the amounts.
    # ...    @author: bernchua
    # Mx Activate    ${LIQ_Cashflows_Window}
    # Mx Select    ${LIQ_Cashflows_Queries_GLEntries}
    # Mx Activate    ${LIQ_GLEntries_Window}
    # ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GLEntries_Tree}    ${SPACE}Total For:%Debit Amt%amount
    # ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GLEntries_Tree}    ${SPACE}Total For:%Credit Amt%amount
    # Run Keyword If    '${DebitAmt}'=='${CreditAmt}'    Log    GL Entries for Share Adjustment in Facility verified.
    # Mx Click    ${LIQ_GLEntries_Exit_Button}

# Set up DO IT status in Split Cashflow  
    # [Documentation]    This keyword is used for setting all methods in Split Cashflow to DO IT status.
    # ...    @author: mgaling
    # [Arguments]    ${Remittance_Instruction}    ${Split_Method}    ${Remittance_Status}    
    
    # Mx Select    ${LIQ_Drawdown_Options_Cashflow}    
    # Mx Activate    ${LIQ_Drawdown_Cashflows_Window}
    # Mx Select    ${LIQ_Cashflow_Options_SetAllDOIT}    
            
    # ${CashflowStatus_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Drawdown_Cashflows_List}    ${Remittance_Instruction}%Status%Status_Variable
    # Log To Console    ${CashflowStatus_Variable}
    
    # ${CashflowStatus_Variable}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Drawdown_Cashflows_List}    ${Split_Method}%Status%Status_Variable
    # Log To Console    ${CashflowStatus_Variable}
    
    # ${StatusString_Status}    Run Keyword And Return Status    Should Be Equal As Strings    ${Remittance_Status}    ${CashflowStatus_Variable}
    # Run Keyword If    ${StatusString_Status}==True    mx LoanIQ click    ${LIQ_Drawdown_Cashflows_OK_Button}
    # ...    ELSE    Fail    Log    Status are not equal
    
    
# Validate GL Entries for Split Cashflow in Drawdown 
    # [Documentation]    This keyword validates the GL Entries of the transaction.
    # ...    @author: mgaling
    # [Arguments]    ${HostBank_GLAccount}    ${BorrowerDDA_ShortName}    ${BorrowerRTGS_ShortName}    ${Loan_RequestedAmount}
        
    # Mx Activate Window    ${LIQ_Drawdown_Window}
    # Mx Select    ${LIQ_Drawdown_Queries_GLEntries}        
    # Mx Activate Window    ${LIQ_Drawdown_GLEntries_Window}
    # Mx Maximize    ${LIQ_Drawdown_GLEntries_Window}
       
    # Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_Drawdown_GLEntries_Table}    ${HostBank_GLAccount}%s  
    # ${DebitAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Drawdown_GLEntries_Table}    ${HostBank_GLAccount}%Debit Amt%test
    # Log    ${DebitAmount} 
    # Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Drawdown_GLEntries_Table}    ${BorrowerDDA_ShortName}%s    
    # ${DDACreditAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Drawdown_GLEntries_Table}    ${BorrowerDDA_ShortName}%Credit Amt%test
    # Log    ${DDACreditAmount}
    # Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Drawdown_GLEntries_Table}    ${BorrowerRTGS_ShortName}%s    
    # ${RTGSCreditAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Drawdown_GLEntries_Table}    ${BorrowerRTGS_ShortName}%Credit Amt%test  
    # Log    ${RTGSCreditAmount}
    
    # ${DebitAmount}    Remove String    ${DebitAmount}    ,
    # ${DDACreditAmount}    Remove String    ${DDACreditAmount}    ,
    # ${RTGSCreditAmount}    Remove String    ${RTGSCreditAmount}    ,     
    # ${DebitAmount}    Convert To Number    ${DebitAmount}
    # ${DDACreditAmount}    Convert To Number    ${DDACreditAmount}
    # ${RTGSCreditAmount}    Convert To Number    ${RTGSCreditAmount} 
    # ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}                
    
    # ${TotalCreditAmt}    Evaluate    ${DDACreditAmount}+${RTGSCreditAmount}    
    # Should Be Equal    ${Loan_RequestedAmount}    ${DebitAmount}
    # Should Be Equal    ${Loan_RequestedAmount}    ${TotalCreditAmt}        
    
    # Mx Click    ${LIQ_Drawdown_GLEntries_Exit_Button}        
    
# Validate Incomplete Cash and Host Bank Cash Amount
    # [Documentation]    This keyword validates the data of Incomplete Cash From Borrower, Incomplete Cash to Lenders and Host Bank Cash Net.
    # ...    @author:mgaling
    # [Arguments]    ${PrincipalPayment_RequestedAmount}    ${Lender1_Percentage}    ${Lender2_Percentage}    ${HostBankLender_Percentage}        
    
    # ###Convert Requested Amount into Number###
    
    # ${PrincipalPayment_RequestedAmount}    Convert To Number    ${PrincipalPayment_RequestedAmount}    2 
    
    # Mx Activate Window    ${LIQ_Payment_Cashflows_Window}
    
    # ###Get and Validate the Incomplete Cash From Borrower Data###
    # ${IncompleteCashFromBorrower_Amount}    Mx LoanIQ Get Data    ${LIQ_Payment_Cashflows_IncompleteCashFromBorrower_StaticText}    text%amount
    # ${IncompleteCashFromBorrower_Amount}    Remove String    ${IncompleteCashFromBorrower_Amount}    ,
    # ${IncompleteCashFromBorrower_Amount}    Remove String    ${IncompleteCashFromBorrower_Amount}    \
    # ${IncompleteCashFromBorrower_Amount}    Remove String    ${IncompleteCashFromBorrower_Amount}    AUD
    # ${IncompleteCashFromBorrower_Amount}    Convert To Number    ${IncompleteCashFromBorrower_Amount}    2   
    
    # Should Be Equal    ${IncompleteCashFromBorrower_Amount}    ${PrincipalPayment_RequestedAmount}
    # Log    ${IncompleteCashFromBorrower_Amount}=${PrincipalPayment_RequestedAmount}         
    
    # ###Get and Validate the Incomplete Cash to Lenders Data###
    # ${IncompleteCashtoLenders_Amount}    Mx LoanIQ Get Data    ${LIQ_Payment_Cashflows_IncompleteCashtoLenders_StaticText}    text%amount
    # ${IncompleteCashtoLenders_Amount}    Remove String    ${IncompleteCashtoLenders_Amount}    ,
    # ${IncompleteCashtoLenders_Amount}    Remove String    ${IncompleteCashtoLenders_Amount}    \
    # ${IncompleteCashtoLenders_Amount}    Remove String    ${IncompleteCashtoLenders_Amount}    AUD
    # ${IncompleteCashtoLenders_Amount}    Convert To Number    ${IncompleteCashtoLenders_Amount}    2 
    
    # ${Computed_IncompleteCashtoLenders}    Evaluate    ${PrincipalPayment_RequestedAmount}*((${Lender1_Percentage}+${Lender2_Percentage})/100)
    # ${Computed_IncompleteCashtoLenders}    Convert To Number    ${Computed_IncompleteCashtoLenders}    2
    
    # Should Be Equal    ${IncompleteCashtoLenders_Amount}    ${Computed_IncompleteCashtoLenders}
    # Log    ${IncompleteCashtoLenders_Amount}=${Computed_IncompleteCashtoLenders}   
    
    # ###Get and Validate the Host Bank Cash Net Data###
    # ${HostBankCashNet_Amount}    Mx LoanIQ Get Data    ${LIQ_Payment_Cashflows_HostBankCashNet_StaticText}    text%amount 
    # ${HostBankCashNet_Amount}    Remove String    ${HostBankCashNet_Amount}    ,
    # ${HostBankCashNet_Amount}    Remove String    ${HostBankCashNet_Amount}    \
    # ${HostBankCashNet_Amount}    Remove String    ${HostBankCashNet_Amount}    AUD
    # ${HostBankCashNet_Amount}    Convert To Number    ${HostBankCashNet_Amount}    2  
    
    # ${Computed_HostBankCashNet}    Evaluate    ${PrincipalPayment_RequestedAmount}*(${HostBankLender_Percentage}/100)
    # ${Computed_HostBankCashNet}    Convert To Number    ${Computed_HostBankCashNet}    2
    
    # Should Be Equal    ${HostBankCashNet_Amount}    ${Computed_HostBankCashNet}
    # Log    ${HostBankCashNet_Amount}=${Computed_HostBankCashNet} 
    
# Validate the Tran Amount of Borrower and Lenders
    # [Documentation]    This keyword validates the Tran Amount of Borrower and Lenders.
    # ...    @author:mgaling
    # [Arguments]    ${PrincipalPayment_RequestedAmount}    ${Borrower_Name}    ${Lender1}    ${Lender1_Percentage}    ${Lender2}    ${Lender2_Percentage}        
    
    # ###Convert Requested Amount into Number###
    
    # ${PrincipalPayment_RequestedAmount}    Convert To Number    ${PrincipalPayment_RequestedAmount}    2 
    
    # Mx Activate Window    ${LIQ_Payment_Cashflows_Window}
    
    # ###Validate Tran Amount of Borrower###
    # ${Borrower_TranAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Cashflows_Tree}    ${Borrower_Name}%Tran Amount%Amount 
    # ${Borrower_TranAmt}    Remove String    ${Borrower_TranAmt}    ,
    # ${Borrower_TranAmt}    Remove String    ${Borrower_TranAmt}    \
    # ${Borrower_TranAmt}    Convert To Number    ${Borrower_TranAmt}    2 
    
    # Should Be Equal    ${PrincipalPayment_RequestedAmount}    ${Borrower_TranAmt}
    # Log    ${PrincipalPayment_RequestedAmount}=${Borrower_TranAmt}      
    
    # ###Validate Tran Amount of Lender1###
    # ${Lender1_TranAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Cashflows_Tree}    ${Lender1}%Tran Amount%Amount 
    # ${Lender1_TranAmt}    Remove String    ${Lender1_TranAmt}    ,
    # ${Lender1_TranAmt}    Remove String    ${Lender1_TranAmt}    \
    # ${Lender1_TranAmt}    Convert To Number    ${Lender1_TranAmt}    2 
    
    # ${Computed_Lender1TranAmount}    Evaluate    ${PrincipalPayment_RequestedAmount}*(${Lender1_Percentage}/100)    
    
    # Should Be Equal    ${Computed_Lender1TranAmount}    ${Lender1_TranAmt}
    # Log    ${Computed_Lender1TranAmount}=${Lender1_TranAmt} 
    
    # ###Validate Tran Amount of Lender2###
    # ${Lender2_TranAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Cashflows_Tree}    ${Lender2}%Tran Amount%Amount   
    # ${Lender2_TranAmt}    Remove String    ${Lender2_TranAmt}    ,
    # ${Lender2_TranAmt}    Remove String    ${Lender2_TranAmt}    \
    # ${Lender2_TranAmt}    Convert To Number    ${Lender2_TranAmt}    2 
    
    # ${Computed_Lender2TranAmount}    Evaluate    ${PrincipalPayment_RequestedAmount}*(${Lender2_Percentage}/100)
    
    # Should Be Equal    ${Computed_Lender2TranAmount}    ${Lender2_TranAmt}
    # Log    ${Computed_Lender2TranAmount}=${Lender2_TranAmt} 
    
# Verify if Status is set to Do It - Payment Cashflow
    # [Documentation]    This keyword is used to validate the Payment Cashflow Status.
    # ...    @author: mgaling
    # [Arguments]    ${LIQCustomer_ShortName}
    
     # ${CashflowStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Tree}    ${LIQCustomer_ShortName}%Status%MStatus_Variable
    # Log To Console    ${CashflowStatus} 
    # ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowStatus}    PEND
    # Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${LIQCustomer_ShortName}%s   
    # Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Cashflows_SetToDoIt_Button}
    # ...    ELSE    Log    Status is already set to Do it
    # Log    Verify Status is set to do it is complete 
    
# Validate GL Entries for Payment with Custom Instruction
    # [Documentation]    This keyword validates the GL Entries for Customized Instructions.
    # ...    @author:mgaling
    # [Arguments]    ${UpfrontFee_Amount}    ${SPAP_GLAccount}    ${FHAD_GLAccount}             
    
    # Mx Activate Window    ${LIQ_Payment_Window}
    # Mx Select    ${LIQ_Payment_Queries_GLEntries}
    
    # Mx Activate Window    ${LIQ_Payment_GLEntries_Window}
    
    # ${UpfrontFee_Amount}    Convert To Number    ${UpfrontFee_Amount}
    
    # ###Debit and Credit Amount Validation###
    # ${DebitAmt}    Get Debit Amount - Payment Cashflow    ${SPAP_GLAccount}
    # ${CreditAmt}    Get Credit Amount - Payment Cashflow    ${FHAD_GLAccount}
    
    # Should Be Equal    ${UpfrontFee_Amount}    ${DebitAmt} 
    # Should Be Equal    ${UpfrontFee_Amount}    ${CreditAmt}
    
    # ###Total Amount of Debit and Credit Validation###
    
    # ${DebitTotalAmt}    Get Debit Total Amount - Payment Cashflow
    # Should Be Equal    ${DebitTotalAmt}    ${DebitAmt}
    # ${CreditTotalAmt}    Get Credit Total Amount - Payment Cashflow
    # Should Be Equal    ${CreditTotalAmt}    ${CreditAmt}
   
    # Should Be Equal    ${DebitTotalAmt}    ${CreditTotalAmt}
    # Log    Debit Total Amount ${DebitTotalAmt}= Credit Total Amount ${CreditTotalAmt} are equal.    
    
    # Mx Click    ${LIQ_Payment_GLEntries_Exit_Button}    
        
# Get Debit Amount - Payment Cashflow
    # [Documentation]    This keyword is used to get debit amount in GL Entries
    # ...    @author: mgaling
    # [Arguments]    ${SPAP_GLAccount}    
    
    # Mx Activate Window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    # ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${SPAP_GLAccount}%Debit Amt%Debit
    # ${DebitAmt}    Remove String    ${DebitAmt}    ,
    # ${DebitAmt}    Convert To Number    ${DebitAmt}    2
    # Log To Console    ${DebitAmt} 
    # [Return]    ${DebitAmt}    

# Get Credit Amount - Payment Cashflow
    # [Documentation]    This keyword is used to get credit amount in GL Entries
    # ...    @author: mgaling
    # [Arguments]    ${FHAD_GLAccount}
    
    # Mx Activate Window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    # ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${FHAD_GLAccount}%Credit Amt%Credit
    # ${CreditAmt}    Remove String    ${CreditAmt}    ,
    # ${CreditAmt}    Convert To Number    ${CreditAmt}    2
    # Log To Console    ${CreditAmt} 
    # [Return]    ${CreditAmt}  

# Get Debit Total Amount - Payment Cashflow
    # [Documentation]    This keyword is used to get debit total amount in GL Entries
    # ...    @author: mgaling
    
    # Mx Activate Window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    # ${DebitTotalAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${SPACE}Total For: CB001%Debit Amt%Debit
    # ${DebitTotalAmt}    Remove String    ${DebitTotalAmt}    ,
    # ${DebitTotalAmt}    Convert To Number    ${DebitTotalAmt}    2
    # [Return]    ${DebitTotalAmt}

# Get Credit Total Amount - Payment Cashflow
    # [Documentation]    This keyword is used to get debit total amount in GL Entries
    # ...    @author: mgaling
    
    # Mx Activate Window    ${LIQ_ManualCashflow_GLEntries_Window}
    
    # ${CreditTotalAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${SPACE}Total For: CB001%Credit Amt%Credit
    # ${CreditTotalAmt}    Remove String    ${CreditTotalAmt}    ,
    # ${CreditTotalAmt}    Convert To Number    ${CreditTotalAmt}    2
    # [Return]    ${CreditTotalAmt}

Verify GL Entries Amount
    [Documentation]    This keyword is used to check GL Entry amount with respect to the Customer/Lender.
    ...    Customer Short Name should be coming from the data set.
    ...    @author: rtarayao    27MAR2019    Initial Create
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    [Arguments]    ${sRowValue}    ${sAccountingEntryType}    ${sCustomerShortName}    ${sCustomerColumn}    ${sGLAccount}=None    
    
    ### Keyword Pre-processing ###
    ${RowValue}    Acquire Argument Value    ${sRowValue}
    ${AccountingEntryType}    Acquire Argument Value    ${sAccountingEntryType}
    ${CustomerShortName}    Acquire Argument Value    ${sCustomerShortName}
    ${CustomerColumn}    Acquire Argument Value    ${sCustomerColumn}
    ${GLAccount}    Acquire Argument Value    ${sGLAccount}

    ${UI_CustomerName}    Set Variable
    ${UI_Value}    Run Keyword If    '${GLAccount}'=='None'    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${RowValue}%${AccountingEntryType}%var
    ${UI_CustomerName1}    Run Keyword If    '${GLAccount}'!='None'    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${GLAccount}%${CustomerColumn}%var
    Run Keyword If    '${GLAccount}'!='None'    Set Global Variable    ${UI_CustomerName}    ${UI_CustomerName1}  
    Run Keyword If    '${GLAccount}'!='None'    Log    ${UI_CustomerName}
    ${UI_CustomerName2}    Run Keyword If    '${GLAccount}'=='None'    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${UI_Value}%${CustomerColumn}%var  
    Run Keyword If    '${GLAccount}'=='None'    Set Global Variable    ${UI_CustomerName}    ${UI_CustomerName2}
    Log    ${UI_CustomerName}     
    ${status}    Run Keyword And Return Status   Should Be Equal    ${UI_CustomerName}    ${CustomerShortName} 
    Run Keyword If    '${status}'=='True'    Run Keyword If    '${GLAccount}'=='None'    Log    ${UI_Value} is the GL Entry ${sAccountingEntryType} for ${CustomerShortName}
    Run Keyword If    '${status}'=='True'    Run Keyword If    '${GLAccount}'!='None'    Log    UI Customer ${UI_CustomerName} is correct.
    ...    ELSE    Log    ${UI_CustomerName} is not equal to ${CustomerShortName}         
    
Compute Lender Share Transaction Amount with exact percentage
    [Documentation]    This keyword will compute the Lender Share transaction based on the defined percentage in Primaries
    ...    @author: fmamaril    11SEP2019    Initial Create
    [Arguments]    ${iTranAmount}    ${iLenderSharePct}
    Log    ${iTranAmount}
    Log    ${iLenderSharePct}
    ${iTranAmount}    Remove Comma and Convert to Number with exact percentage    ${iTranAmount}
    ${iLenderSharePct}    Remove Comma and Convert to Number with exact percentage    ${iLenderSharePct}
    ${iLenderSharePct}    Evaluate    ${iLenderSharePct}/100
    ${iLenderShareTranAmt}    Evaluate    ${iTranAmount}*${iLenderSharePct}
    ${iLenderShareTranAmtTwoDecimalPlaces}    Remove Comma and Convert to Number    ${iLenderShareTranAmt}
    ${sLenderShareTranAmt}    Convert To String    ${iLenderShareTranAmtTwoDecimalPlaces}
    Log    ${sLenderShareTranAmt}
    [Return]    ${sLenderShareTranAmt} 

Close GL and Cashflow Windows
    [Documentation]    This keyword exits the user from GL Entries and Cashflows windows.
    ...    @author: rtarayao    04OCT2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_GL_Entries_Window}
    mx LoanIQ close window    ${LIQ_GL_Entries_Window}        
    mx LoanIQ close window    ${LIQ_Cashflows_Window}   

Release a Cashflow
    [Documentation]    This keyword will release all the Cashflows applicable for any transaction types
    ...    This keyword is created to be usable to as an excel keyword
    ...    @author: hstone    29APR2020    - Initial Create
    ...    @update: amansuet    03JUN2020    - added 'sTestCase' argument and set datatype as optional
    [Arguments]    ${sCashFlow_Name}    ${sDataType}=default    ${sTestCase}=default
   
    ### Keyword Pre-processing ###
    ${CashFlow_Name}    Acquire Argument Value    ${sCashFlow_Name}
    ${DataType}    Acquire Argument Value    ${sDataType}
    ${TestCase}    Acquire Argument Value    ${sTestCase}
    Release Cashflow    ${CashFlow_Name}    ${TestCase}    ${DataType}

Release Cashflow Based on Remittance Instruction
    [Documentation]    This keyword will proceed to cashflow release based on the Remittance Instruction Supplied
    ...    @author: hstone    08MAY2020    - Initial Create
    ...    @update: hstone    19MAY2020    - Added Keyword Pre-processing
    ...                                    - Replaced argument ${sBorrowerName} with ${sCustomerName}
    ...    @update: hstone    20MAY2020    - Added 'Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release Cashflows'
    ...                                    - Added ${sDataType} argument for Release Cashflow parameter
    ...                                    - Added Acquire Argument Value for ${sDataType}
    ...                                    - Replaced ${sCustomerName} arg with ${sCashflowReference} arg
    ...    @update: amansuet    16JUN2020    - Replaced 'Navigate to Loan Drawdown Workflow and Proceed With Transaction' to 'Navigate to Loan Repricing Workflow and Proceed With Transaction'
    ...    @update: amansuet    22JUN2020    - Revert changes and added new argument to make keyword generic on its Workflow Navigation
    ...    @update: amansuet    22JUN2020    - Added Condition for 'Navigate to Payment Workflow and Proceed With Transaction'
    [Arguments]    ${sRemittanceInstruction}    ${sCashflowReference}    ${sDataType}=default    ${sNavigateToWorkflow}=Loan Drawdown

    ### Keyword Pre-processing ###
    ${RemittanceInstruction}    Acquire Argument Value    ${sRemittanceInstruction}
    ${CashflowReference}    Acquire Argument Value    ${sCashflowReference}
    ${DataType}    Acquire Argument Value    ${sDataType}
    ${NavigateToWorkflow}    Acquire Argument Value    ${sNavigateToWorkflow}

    ${RemittanceInstruction}    Convert To Uppercase    ${RemittanceInstruction}
    Run Keyword If    '${RemittanceInstruction}'=='RTGS' and '${NavigateToWorkflow}'=='Loan Drawdown'    Run Keywords    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release Cashflows
    ...    AND    Release Cashflow    ${CashflowReference}    default    ${DataType}
    ...    ELSE IF    '${RemittanceInstruction}'=='RTGS' and '${NavigateToWorkflow}'=='Loan Repricing'    Run Keywords    Navigate to Loan Repricing Workflow and Proceed With Transaction    Release Cashflows
    ...    AND    Release Cashflow    ${CashflowReference}    default    ${DataType}
    ...    ELSE IF    '${RemittanceInstruction}'=='RTGS' and '${NavigateToWorkflow}'=='Payment'    Run Keywords    Navigate to Payment Workflow and Proceed With Transaction    Release Cashflows
    ...    AND    Release Cashflow    ${CashflowReference}    default    ${DataType}
    ...    ELSE    Log    Release of Cashflow is Not Needed for '${RemittanceInstruction}' Remittance Instruction

Compute Lender Share Transaction Amount - Repricing
    [Documentation]    This keyword will compute the Lender Share transaction based on the defined percentage in Primaries
    ...    @author: amansuet    17JUN2020    - initial create
    ...    @update: amansuet    18JUN2020    - added keyword pre-processing
    [Arguments]    ${iTranAmount}    ${iLenderSharePct}    ${sRuntimeVar_LenderShareTranAmt}=None
    
    ### Keyword Pre-processing ###
    ${TranAmount}    Acquire Argument Value    ${iTranAmount}
    ${LenderSharePct}    Acquire Argument Value    ${iLenderSharePct}

    Log    ${TranAmount}
    Log    ${LenderSharePct}

    ${TranAmount}    Remove Comma and Convert to Number    ${TranAmount}
    ${LenderSharePct}    Remove Comma and Convert to Number    ${LenderSharePct}
    ${LenderSharePct}    Evaluate    ${LenderSharePct}/100
    ${iLenderShareTranAmt}    Evaluate    ${TranAmount}*${LenderSharePct}
    ${iLenderShareTranAmtTwoDecimalPlaces}    Evaluate    "{0:,.2f}".format(${iLenderShareTranAmt})
    ${sLenderShareTranAmt}    Convert To String    ${iLenderShareTranAmtTwoDecimalPlaces}
    Log    ${sLenderShareTranAmt}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntimeVar_LenderShareTranAmt}    ${sLenderShareTranAmt}

    [Return]    ${sLenderShareTranAmt}
    
Add SPAP As Remittance Instructions
    [Documentation]    This keyword is used to select SPAP as remittance instruction through the Cashflow window.
    ...    @author:     sahalder    22072020    initial create
    [Arguments]    ${sCustomerShortName}    ${sRemittanceDescription}    ${sTransactionAmount}=None    ${sCurrency}=None    
    Run Keyword If    '${sTransactionAmount}'=='None'    Run Keyword If    '${sTransactionAmount}'=='None'    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${sCustomerShortName}%d
    Run Keyword If    '${sTransactionAmount}'!='None'    Run keywords    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Tree}    ${sTransactionAmount}${SPACE}${sCurrency}%${sTransactionAmount}${SPACE}${sCurrency}%Original Amount/CCY
    ...    AND    Mx Native Type    {ENTER}  
    mx LoanIQ activate    ${LIQ_Cashflows_DetailsForCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Cashflows_DetailsForCashflow_Window}     VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Cashflows_DetailsForCashflow_SelectRI_Button}  
    mx LoanIQ activate    ${LIQ_Cashflows_ChooseRemittanceInstructions_Window}
    Mx LoanIQ Set    ${LIQ_Cashflows_ChooseRemittanceInstructions_CustomInstructions_Checkbox}    ON
    Mx LoanIQ Click    ${LIQ_Cashflows_ChooseRemittanceInstructions_Details_Button}
    Mx LoanIQ Activate    ${LIQ_Cashflows_RemittanceInstructionsDetail_Window}
    mx LoanIQ select    ${LIQ_Payment_Cashflows_RemittanceInstructionsDetail_FileSave_Menu}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ select    ${LIQ_Payment_Cashflows_RemittanceInstructionsDetail_FileExit_Menu}
    mx LoanIQ activate    ${LIQ_Cashflows_ChooseRemittanceInstructions_Window}      
    mx LoanIQ click    ${LIQ_Cashflows_ChooseRemittanceInstructions_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowVerification
    mx LoanIQ click    ${LIQ_Cashflows_DetailsForCashflow_OK_Button}

Set the Status to Send all to SPAP
    [Documentation]    This keyword will change the status of the Cashflow then set it to Send all to SPAP.
    ...    @author:    sahalder    22072020    initial create
    mx LoanIQ activate window    ${LIQ_Cashflows_Window}    
    mx LoanIQ select    ${LIQ_Cashflows_Options_SendAllToSPAP}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Workflow_SendStatusToSPAP