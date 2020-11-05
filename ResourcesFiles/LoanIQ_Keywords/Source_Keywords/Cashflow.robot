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

    ## Keyword Pre-processing ###   
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
    ...    @update: aramos      20SEP2020    Added conversion to 2 decimal points for Total Transaction
    ...    @update: aramos      02OCT2020    Added Run If to 2 decimal points suppression
    ...    @update: shirhong    15OCT2020    Modified Test Steps when Transaction Amount is available
    [Arguments]    ${sCustomerShortName}    ${sRemittanceDescription}    ${sTransactionAmount}=None    ${sCurrency}=None    ${sLoanGlobalInterest}=None
    Log    ${sLoanGlobalInterest}
    Log    ${sTransactionAmount}
    ${TotalTransactionAmount}    Run Keyword If    '${sLoanGlobalInterest}'!='None'    Evaluate    ${sTransactionAmount}+${sLoanGlobalInterest}
    ...    ELSE    Set Variable    ${sTransactionAmount}           
    
    Run Keyword If    '${sTransactionAmount}'=='None'    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${sCustomerShortName}%d
    
    Run Keyword If    '${sTransactionAmount}'!='None'    Log    ${TotalTransactionAmount}${SPACE}${sCurrency}%${TotalTransactionAmount}${SPACE}${sCurrency}%Original Amount/CCY
    Run Keyword If    '${sTransactionAmount}'!='None'    Log    ${sTransactionAmount}
    ${TotalTransactionAmount}    Run Keyword If    '${sTransactionAmount}'!='None'    Remove Comma and Convert to Number    ${sTransactionAmount}
    ${TotalTransactionAmount}    Run Keyword If    '${sTransactionAmount}'!='None'    Evaluate    "%.2f" % ${TotalTransactionAmount}
    ${TotalTransactionAmount}    Run Keyword If    '${sTransactionAmount}'!='None'    Convert Number With Comma Separators    ${TotalTransactionAmount}
    Run Keyword If    '${sTransactionAmount}'!='None'    Log    ${TotalTransactionAmount}${SPACE}${sCurrency}%${TotalTransactionAmount}${SPACE}${sCurrency}%Original Amount/CCY
    Run Keyword If    '${sTransactionAmount}'!='None'    Log    ${TotalTransactionAmount}   
    
    Run Keyword If    '${sTransactionAmount}'!='None'    Run keywords    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Tree}    ${TotalTransactionAmount}${SPACE}${sCurrency}%${TotalTransactionAmount}${SPACE}${sCurrency}%Original Amount/CCY
    ...    AND    Mx Press Combination    Key.ENTER  
    mx LoanIQ activate    ${LIQ_Cashflows_DetailsForCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Cashflows_DetailsForCashflow_Window}     VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Cashflows_DetailsForCashflow_SelectRI_Button}  
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
    ...    @update: fluberio    21OCT2020    - Added Condition to add Release Cashflow when Remittance Instruction is Set to IMT
    ...    @update: makcamps    28OCT2020    - Added Condition to add Release Cashflow when Remittance Instruction is Set to IMT and Transaction is Loan Drawdown
    ...    @update: amitp       26OCT2020    - Remove Relase Cashflow Keyword and Add Log for Remittance Instruction RTGS.
    [Arguments]    ${sRemittanceInstruction}    ${sCashflowReference}    ${sDataType}=default    ${sNavigateToWorkflow}=Loan Drawdown

    ### Keyword Pre-processing ###
    ${RemittanceInstruction}    Acquire Argument Value    ${sRemittanceInstruction}
    ${CashflowReference}    Acquire Argument Value    ${sCashflowReference}
    ${DataType}    Acquire Argument Value    ${sDataType}
    ${NavigateToWorkflow}    Acquire Argument Value    ${sNavigateToWorkflow}    
    ${RemittanceInstruction}    Convert To Uppercase    ${RemittanceInstruction}
    
    Run Keyword If    '${RemittanceInstruction}'=='RTGS' and '${NavigateToWorkflow}'=='Loan Drawdown'    Run Keywords    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release Cashflows
    ...    AND    Log    Cashflow Released   
    ...    ELSE IF    '${RemittanceInstruction}'=='RTGS' and '${NavigateToWorkflow}'=='Loan Repricing'    Run Keywords    Navigate to Loan Repricing Workflow and Proceed With Transaction    Release Cashflows
    ...    AND    Log    Cashflow Released    
    ...    ELSE IF    '${RemittanceInstruction}'=='RTGS' and '${NavigateToWorkflow}'=='Payment'    Run Keywords    Navigate to Payment Workflow and Proceed With Transaction    Release Cashflows
    ...    AND    Log    Cashflow Released
    ...    ELSE IF    '${RemittanceInstruction}'=='IMT' and '${NavigateToWorkflow}'=='Loan Drawdown'    Navigate to Loan Drawdown Workflow and Proceed With Transaction    Release Cashflows
    ...    ELSE IF    '${RemittanceInstruction}'=='IMT' and '${NavigateToWorkflow}'=='Payment'    Navigate to Payment Workflow and Proceed With Transaction    Release Cashflows
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

Open Cashflow Window from Loan Repricing Menu
    [Documentation]    This keyword opens the Cashflow window from Loan Repricing Notebook's menu
    ...    @author: dahijara    23SEP2020    initial create

    Open Cashflows Window from Notebook Menu    ${LIQ_LoanRepricing_Window}    ${LIQ_LoanRepricing_CashFlows_Menu}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing_CashFlowWindow

Set All Items to Do It
    [Documentation]    This keyword will handle the behavior of the cashflow window where the Java Tree is not updating in realtine. Cashflow window must be saved an re-opened again for the
    ...    changes to  take effect
    ...    @author: ritargel    10/10/2020    initial create
    Mx LoanIQ Activate    ${LIQ_Cashflows_Window}
    Select Menu Item    ${LIQ_Cashflows_Window}    Options    Set All To 'Do It'
    Mx LoanIQ click    ${LIQ_Cashflows_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowVerification