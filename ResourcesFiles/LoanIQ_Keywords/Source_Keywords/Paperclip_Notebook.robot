*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Add Transaction to Pending Paperclip
    [Documentation]    This keyword will add transaction to Pending Paperclip
    ...    @author: ritragel
    [Arguments]    ${sEffectiveDate}    ${sDescription}
    mx LoanIQ activate window    ${LIQ_PendingPaperClip_Window} 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}  
    mx LoanIQ activate window    ${LIQ_PendingPaperClip_Window}    
    mx LoanIQ enter    ${LIQ_PendingPaperClip_EffectiveDate_TextField}    ${sEffectiveDate}
    mx LoanIQ enter    ${LIQ_PendingPaperClip_TransactionDescription_Textfield}    ${sDescription} 
    mx LoanIQ click    ${LIQ_PendingPaperClip_Add_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  

Select Outstanding Item
    [Documentation]    This keyword will select the SBLC item/Loan Item in Events and Fees
    ...    @author: ritragel
    [Arguments]    ${sOustanding_Alias}
    mx LoanIQ activate window    ${LIQ_FeesAndOutstandings_Window} 
    mx LoanIQ click    ${LIQ_FeesAndOutstandings_ExpandAll_Button}
    Mx LoanIQ Select String    ${LIQ_FeesAndOutstandings_Outstandings_JavaTree}    ${sOustanding_Alias} 

Add Transaction Type
    [Documentation]    This keyword will select an appropriate Transaction Type for the Fee/Outstanding
    ...    @author: ritragel
    [Arguments]    ${sTransaction_Type}    ${iAmount}=null    ${sComplete}=No
    mx LoanIQ activate window    ${LIQ_FeesAndOutstandings_Window} 
    mx LoanIQ enter    JavaWindow("title:=Fees and Outstandings").JavaObject("tagname:=Group","text:=Add Transaction Type").JavaRadioButton("attached text:=${sTransaction_Type}")    ON
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    Run Keyword If    '${iAmount}'!='null'    mx LoanIQ enter    ${LIQ_FeesAndOutstandings_EnterAmount_Textbox}    ${iAmount}
    mx LoanIQ click    ${LIQ_PendingPaperClip_AddTransactionType_Button}
    Run Keyword If    '${sComplete}'=='Yes'    mx LoanIQ click    ${LIQ_FeesAndOutstandings_OK_Button}

Select Cycle for Payment
    [Documentation]    This keyword will select a Prorate with option and choose a cycle to make a payment against
    ...    @author: ritragel
    [Arguments]    ${Cycle_Number}    ${ProrateWith}
    mx LoanIQ activate window    ${LIQ_CyclesForBankGuarantee_Window}
    mx LoanIQ enter    JavaWindow("title:=Cycles for.*").JavaRadioButton("attached text:=${ProrateWith}")    ON
    Mx LoanIQ Select String    ${LIQ_CyclesForBankGuarantee_Cycle_JavaTree}    ${Cycle_Number}      
    mx LoanIQ click    ${LIQ_CyclesForBankGuarantee_OK_Button}    

Add Freeform Event Fee
    [Documentation]    This keyword will add a Freeform Event Fee
    ...    @author: ritragel
    [Arguments]    ${Facility_Name}    ${Fee_Requested_Amount}    ${Fee_Type}
    mx LoanIQ activate window    ${LIQ_FeesAndOutstandings_Window}
    Mx LoanIQ Select String    ${LIQ_FeesAndOutstandings_Outstandings_JavaTree}    ${Facility_Name}           
    mx LoanIQ click    ${LIQ_PendingPaperClip_AddTransactionType_Button}
    mx LoanIQ activate window    ${LIQ_PendingFee_Window}
    mx LoanIQ enter    ${LIQ_PendingFee_RequestedAmount_JavaEdit}    ${Fee_Requested_Amount}    
    mx LoanIQ select    ${LIQ_PendingFee_FeeType_Dropdown}    ${Fee_Type}    
    mx LoanIQ select    ${LIQ_PendingFee_File_Save_Menu} 
    mx LoanIQ close window    ${LIQ_PendingServiceFee_Window}          

Verify New Transactions
    [Documentation]    This keyword will verify new transactions
    ...    @author: ritragel
    [Arguments]    ${SBLC_Alias}    ${Fee_Type}
    mx LoanIQ activate window    ${LIQ_FeesAndOutstandings_Window}
    Mx LoanIQ Select String    ${LIQ_FeesAndOutstandings_JavaTree}    Bank Guarantee/Letter of Credit/Synd Fronted Bank (${SBLC_Alias})Issuance
    Mx LoanIQ Select String    ${LIQ_FeesAndOutstandings_JavaTree}    ${Fee_Type}
    mx LoanIQ click    ${LIQ_FeesAndOutstandings_OK_Button}
    ${SBLC_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PaperClip_Transactions_JavaTree}    GTEE/Issuing%Amount%Amount
    Write Data To Excel    SERV23_PaperclipTransaction    SBLC_Amount    ${rowid}    ${SBLC_Amount}

Verify Added Paperclip Payments
    [Documentation]    This keyword will verify the added transactions in Paperclip payment
    ...    @author: ritragel    09SEP2019
    [Arguments]    ${sTransactions}
    mx LoanIQ activate window    ${LIQ_FeesAndOutstandings_Window}
    @{aTransactions}    Split String    ${sTransactions}    |
    ${iTransactions}    Get Length    ${aTransactions}  
    :FOR    ${i}    IN RANGE    ${iTransactions}
    \    Log    @{aTransactions}[${i}] 
    \    Run Keyword    Mx LoanIQ Select String    ${LIQ_FeesAndOutstandings_JavaTree}    @{aTransactions}[${i}]
    \    Log   Transaction is present in the JavaTree  
    mx LoanIQ click    ${LIQ_FeesAndOutstandings_OK_Button}

Navigate to Create Cashflow for Paperclip
    [Documentation]    This keyword will navigate from General tab to Workflow and Create Cashflows
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_PendingPaperClip_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_Tabs}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_Workflow_Tab}    Create Cashflows

Add Remittance Instuctions for Customer
    [Documentation]    This keyword will verify if Method has Remittance Instruction then add if there is none in borrower and lender
    ...    @author: ritragel
    [Arguments]    ${SBLC_Amount}    ${Fee_Requested_Amount}    ${Borrower_ShortName}    ${LenderSharePc1}    ${LenderSharePc2}    ${LenderSharePc3}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status} 
    # Get Issuance Value then verify in Cashflow JavaTree
    ${Lender1_SBLC_TranAmount}    Compute Lender Share Amount    ${SBLC_Amount}    ${LenderSharePc3}
    ${Lender2_SBLC_TranAmount}    Compute Lender Share Amount    ${SBLC_Amount}    ${LenderSharePc2}
    ${Lender1_ServiceFee_TranAmount}    Compute Lender Share Amount    ${Fee_Requested_Amount}    ${LenderSharePc3}
    ${Lender2_ServiceFee_TranAmount}    Compute Lender Share Amount    ${Fee_Requested_Amount}    ${LenderSharePc2} 
    ${BorrowerTranAmount}    Get Transaction Amount - Paperclip   ${Borrower_ShortName}
    ${BorrowerTranAmount}    Convert To String    ${BorrowerTranAmount}
    ${BorrowerTranAmount}    Convert Number With Comma Separators    ${BorrowerTranAmount}
    Verify if Method has Remittance Instruction - Paperclip    ${BorrowerTranAmount}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Instruction}
    Verify if Method has Remittance Instruction - Paperclip    ${Lender1_SBLC_TranAmount}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Instruction}
    Verify if Method has Remittance Instruction - Paperclip    ${Lender1_ServiceFee_TranAmount}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Instruction}    
    Verify if Method has Remittance Instruction - Paperclip    ${Lender2_SBLC_TranAmount}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Instruction}    
    Verify if Method has Remittance Instruction - Paperclip    ${Lender2_ServiceFee_TranAmount}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Instruction}
    mx LoanIQ select    ${LIQ_Cashflows_Paperclip_SetToDoIt_Cashflow}    

    
Verify if Method has Remittance Instruction - Paperclip
    [Documentation]    This keyword is used to validate the Drawdown Cashflow Information.
    ...    @author: ritragel
    [Arguments]    ${Amount}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status}
    Log    ${Amount} 
    # ${RemittanceInstruction}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Paperclip_JavaTree}    ${Amount}%Method%Method_Variable
    # Log To Console    ${RemittanceInstruction}     
    # ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${RemittanceInstruction}    NONE
    # Run Keyword If    ${status}==True    Add Remittance Instructions - Paperclip    ${Amount}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status}
    # ...    ELSE    Log    Method already has remittance instructions
    # ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${RemittanceInstruction}    DDA
    # Run Keyword If    ${status}==True    Add Remittance Instructions - Paperclip    ${Amount}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status}
    # ...    ELSE    Log    Method already has remittance instructions
    # ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${RemittanceInstruction}    IMT
    # Run Keyword If    ${status}==True    Add Remittance Instructions - Paperclip    ${Amount}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status}
    # ...    ELSE    Log    Method already has remittance instructions

Add SBLC and Fee Amount
    [Documentation]    This keyword is used to add SBLC and Fee
    ...    @author: ritragel
    [Arguments]    ${SBLC_Alias}    ${Fee_Requested_Amount}
    ${TotalBorrowerPayment}    Evaluate    ${SBLC_Alias}+${Fee_Requested_Amount}
    ${TotalBorrowerPayment}    Convert To String    ${TotalBorrowerPayment}
    ${TotalBorrowerPayment}    Convert Number With Comma Separators    ${TotalBorrowerPayment}
    Log    ${TotalBorrowerPayment}
    [Return]    ${TotalBorrowerPayment}  


Get Transaction Amount and Validate GL Entries - Paperclip - Scenario 2
    [Documentation]    This keyword is used to get the Transaction amount from Cashflow and compare this to the records inside GL Entries
    ...    @author: ritragel
    [Arguments]    ${Borrower_ShortName}    ${Lender1_ShortName}    ${Lender2_ShortName}   ${LenderSharePc1}    ${LenderSharePc2}
    ...    ${LenderSharePc3}    ${Host_Bank}    ${TotalBorrowerPayment}    ${SBLC_Amount}    ${Fee_Requested_Amount}
    
    # Compare the computed total Borrower Payment to the Borrower Tran Amount
    ${BorrowerTranAmount}    Get Transaction Amount - Paperclip   ${Borrower_ShortName}
    ${BorrowerTranAmount}    Convert To String    ${BorrowerTranAmount}
    ${BorrowerTranAmount}    Convert Number With Comma Separators    ${BorrowerTranAmount}
    Should Be Equal    ${BorrowerTranAmount}    ${TotalBorrowerPayment}    
    
    # Get Issuance Value then verify in Cashflow JavaTree
    ${Lender1_SBLC_TranAmount}    Compute Lender Share Amount    ${SBLC_Amount}    ${LenderSharePc3}
    ${Lender2_SBLC_TranAmount}    Compute Lender Share Amount    ${SBLC_Amount}    ${LenderSharePc2}
    ${Lender3_SBLC_TranAmount}    Compute Lender Share Amount    ${SBLC_Amount}    ${LenderSharePc1}
    ${Lender1_ServiceFee_TranAmount}    Compute Lender Share Amount    ${Fee_Requested_Amount}    ${LenderSharePc3}
    ${Lender2_ServiceFee_TranAmount}    Compute Lender Share Amount    ${Fee_Requested_Amount}    ${LenderSharePc2}
    ${Lender3_ServiceFee_TranAmount}    Compute Lender Share Amount    ${Fee_Requested_Amount}    ${LenderSharePc1}     

    # Verify if Amount is in JavaTree
    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Paperclip_JavaTree}    ${Lender1_SBLC_TranAmount}%${Lender1_SBLC_TranAmount}%Tran Amount
    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Paperclip_JavaTree}    ${Lender2_SBLC_TranAmount}%${Lender2_SBLC_TranAmount}%Tran Amount    
    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Paperclip_JavaTree}    ${Lender1_ServiceFee_TranAmount}%${Lender1_ServiceFee_TranAmount}%Tran Amount    
    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Paperclip_JavaTree}    ${Lender2_ServiceFee_TranAmount}%${Lender2_ServiceFee_TranAmount}%Tran Amount    
    
    # Get Host Bank Share and Match
    ${UiHostBankShares}     Get Host Bank Cash - Paperclip
    ${TotalHostBankShares}    Evaluate    ${Lender3_SBLC_TranAmount}+${Lender3_ServiceFee_TranAmount}
    Should Be Equal As Numbers    ${UiHostBankShares}    ${TotalHostBankShares}    
    
    # Open GL Entries
    mx LoanIQ activate window    ${LIQ_Cashflows_Paperclip}    
    mx LoanIQ select    ${LIQ_Cashflows_Paperclip_GLEntries_Cashflow} 
    mx LoanIQ activate window  ${LIQ_GL_Entries_Window}   
    
    ${BorrowerDebitAmount}    Get Debit Amount - Paperclip    ${BorrowerTranAmount}
    ${Lender1_SBLC_CreditAmt}    Get Credit Amount - Paperclip    ${Lender1_SBLC_TranAmount}
    ${Lender2_SBLC_CreditAmt}    Get Credit Amount - Paperclip    ${Lender2_SBLC_TranAmount}
    ${Lender3_SBLC_CreditAmt}    Get Credit Amount - Paperclip    ${Lender3_SBLC_TranAmount}
    ${Lender1_ServiceFee_Credit_Amt}    Get Credit Amount - Paperclip    ${Lender1_ServiceFee_TranAmount}
    ${Lender2_ServiceFee_Credit_Amt}    Get Credit Amount - Paperclip    ${Lender2_ServiceFee_TranAmount}
    ${Lender3_ServiceFee_Credit_Amt}    Get Credit Amount - Paperclip    ${Lender3_ServiceFee_TranAmount}
    
    # Get Total Debit Amt
    ${TotalDebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${Borrower_ShortName}%Debit Amt%Debit
    Should Be Equal As Strings    ${TotalDebitAmt}    ${TotalBorrowerPayment}
    
    # Compute Credit Amt
    ${TotalCreditAmt}    Evaluate    ${Lender1_SBLC_TranAmount}+${Lender2_SBLC_TranAmount}+${Lender3_SBLC_TranAmount}+${Lender1_ServiceFee_TranAmount}+${Lender2_ServiceFee_TranAmount}+${Lender3_ServiceFee_TranAmount}
    ${TotalCreditAmt}    Convert To String    ${TotalCreditAmt}
    ${TotalCreditAmt}    Convert Number With Comma Separators    ${TotalCreditAmt}
    Should Be Equal As Strings    ${TotalDebitAmt}    ${TotalCreditAmt}    
    
    mx LoanIQ close window    ${LIQ_GL_Entries_Window}
    mx LoanIQ activate window    ${LIQ_Cashflows_Paperclip}        
    mx LoanIQ click    ${LIQ_Cashflows_Paperclip_OK_Button}    
    
Compute Lender Share Amount 
    [Documentation]    This keyword will compute the total amount for issuance based on the percentage of the primaries
    ...    @author: ritragel
    [Arguments]    ${Fee_Amount}    ${LenderSharePct}
    ${Fee_Amount}    Remove Comma and Convert to Number    ${Fee_Amount}
    ${status}    Run Keyword And Return Status    Should Contain    ${Fee_Amount}    ,           
    Run Keyword If    '${status}'=='True'    Remove String    ${Fee_Amount}    ,
    ${LenderSharePct}    Evaluate    ${LenderSharePct}/100
    ${LenderShareTranAmt}    Evaluate    ${Fee_Amount}*${LenderSharePct}   
    ${LenderShareTranAmt}    Convert To Number    ${LenderShareTranAmt}    2
    Log    ${LenderShareTranAmt}
    [Return]    ${LenderShareTranAmt}    

Get Transaction Amount - Paperclip
    [Documentation]    This keyword is used to get transaction amount from Cashflow
    ...    @author: ritragel
    [Arguments]    ${LIQ_BorrowerShortName}
    ${BrwTransactionAmount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Paperclip_JavaTree}    ${LIQ_BorrowerShortName}%Tran Amount%Tran
    ${CashflowTranAmount}    Remove String    ${BrwTransactionAmount}    ,
    ${UiTranAmount}    Convert To Number    ${CashflowTranAmount}    2
    Log To Console    ${UiTranAmount} 
    [Return]    ${UiTranAmount}

Get Debit Amount - Paperclip
    [Documentation]    This keyword is used to get debit amount in GL Entries
    ...    @author: ritragel
    [Arguments]    ${Computed_Fee_Amount}
    ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${Computed_Fee_Amount}%Debit Amt%Debit
    ${GLEntryAmt}    Remove String    ${DebitAmt}    ,
    ${UiGLEntryAmt}    Convert To Number    ${GLEntryAmt}    2
    Log To Console    ${UiGLEntryAmt} 
    [Return]    ${UiGLEntryAmt}    

Get Credit Amount - Paperclip
    [Documentation]    This keyword is used to get credit amount in GL Entries
    ...    @author: ritragel
    [Arguments]    ${Computed_Fee_Amount}
    Log    ${Computed_Fee_Amount}
    ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${Computed_Fee_Amount}%Credit Amt%Credit
    ${GLEntryAmt}    Remove String    ${CreditAmt}    ,
    ${UiGLEntryAmt}    Convert To Number    ${GLEntryAmt}    2
    Log To Console    ${UiGLEntryAmt} 
    [Return]    ${UiGLEntryAmt}  
    
Get Host Bank Cash - Paperclip
    [Documentation]    This keyword is used to get Host Bank cash value
    ...    @author: ritragel
    ${UiHostBank}    Mx LoanIQ Get Data    ${LIQ_Cashflows_Paperclip_HostBankCash_JavaEdit}    value%value 
    ${UiHostBank}    Strip String    ${UiHostBank}    mode=Right    characters=${SPACE}${SPACE}AUD
    ${status}    Run Keyword And Return Status    Should Contain    ${UiHostBank}    ,           
    Run Keyword If    '${status}'=='True'   Remove String    ${UiHostBank}    ,
    Run Keyword If    '${status}'=='True'   Convert To Number    ${UiHostBank}    2
    Run Keyword If    '${status}'=='False'    Convert To Number    ${UiHostBank}    2
    [Return]    ${UiHostBank}
    
Send Paperclip Payment for Approval
    [Documentation]    This keyword will navigate from General tab to Workflow and Send to Approval
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_PendingPaperClip_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_Tabs}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_Workflow_Tab}    Send to Approval
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    

Approve Paperclip 
    [Documentation]    This keyword will navigate from General tab to Workflow and Approve
    ...    @author: ritragel
    ...    @update: mcastro    16DEC2020    - Added additional Validation for Question or warning if present, added Take screenshot
    mx LoanIQ activate window    ${LIQ_PendingPaperClip_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_Tabs}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_Workflow_Tab}    Approval
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ApprovedPaperClip
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate if Question or Warning Message is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ApprovedPaperClip
    
Release Cashflows for Paperclip
    [Documentation]    This keyword will release cashflow for Paperclip
    ...    @author: ritragel
    [Arguments]    ${SBLC_Amount}    ${Fee_Requested_Amount}    ${Borrower_ShortName}    ${LenderSharePc1}    ${LenderSharePc2}    ${LenderSharePc3}
    mx LoanIQ activate window    ${LIQ_PendingPaperClip_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_Tabs}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_Workflow_Tab}    Release Cashflows
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 

    ${Lender1_SBLC_TranAmount}    Compute Lender Share Amount    ${SBLC_Amount}    ${LenderSharePc3}
    ${Lender2_SBLC_TranAmount}    Compute Lender Share Amount    ${SBLC_Amount}    ${LenderSharePc2}
    ${Lender1_ServiceFee_TranAmount}    Compute Lender Share Amount    ${Fee_Requested_Amount}    ${LenderSharePc3}
    ${Lender2_ServiceFee_TranAmount}    Compute Lender Share Amount    ${Fee_Requested_Amount}    ${LenderSharePc2} 
    ${BorrowerTranAmount}    Get Transaction Amount - Paperclip   ${Borrower_ShortName}
    ${BorrowerTranAmount}    Convert To String    ${BorrowerTranAmount}
    ${BorrowerTranAmount}    Convert Number With Comma Separators    ${BorrowerTranAmount}

    Verify if Status is set to Release it - Paperclip    ${BorrowerTranAmount}
    Verify if Status is set to Release it - Paperclip    ${Lender1_SBLC_TranAmount}
    Verify if Status is set to Release it - Paperclip    ${Lender2_SBLC_TranAmount}    
    Verify if Status is set to Release it - Paperclip    ${Lender1_ServiceFee_TranAmount}    
    Verify if Status is set to Release it - Paperclip    ${Lender2_ServiceFee_TranAmount}    
   
    mx LoanIQ click    ${LIQ_Cashflows_Paperclip_OK_Button}    
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
Verify if Status is set to Release it - Paperclip
    [Arguments]    ${Amount}
    ${CashflowStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Paperclip_JavaTree}    ${Amount}%Status%Status_Variable
    Log To Console    ${CashflowStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowStatus}    DOIT
    Run Keyword If    ${status}==True    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Paperclip_JavaTree}    ${Amount}%${Amount}%Tran Amount   
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Cashflows_Paperclip_MarkSelectedItemForRelease_Button}    
    ...    ELSE    Log    Status is already set to Do it
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Click Javatree Cell    ${LIQ_Cashflows_Paperclip_JavaTree}    ${Amount}%${Amount}%Tran Amounts   
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Cashflows_Paperclip_MarkSelectedItemForRelease_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to Release It is complete   

Release Paperclip Transaction
    [Documentation]    This keyword will navigate from General tab to Workflow and Rekease the Paperclip Transaction
    ...    @author: ritragel
    ...    @update: mcastro    16DEC2020    - Added additional validation of question or warning if displayed, added Take screenshot

    mx LoanIQ activate window    ${LIQ_PendingPaperClip_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_Tabs}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_Workflow_Tab}    Release
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ReleasePaperClip
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    Validate if Question or Warning Message is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ReleasePaperClip    

Generate Intent Notices for Paper Clip
    [Documentation]    This keyword is used to Generate Intent Notice for Paper Clip
    ...    @author: ritragel
    [Arguments]    ${Customer_Legal_Name}    ${NoticeStatus}
    mx LoanIQ activate window    ${LIQ_PendingPaperClip_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_Tabs}    Workflow  
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_Workflow_Tab}    Generate Intent Notices  
    mx LoanIQ activate window    ${LIQ_Notices_Window}   
    mx LoanIQ click    ${LIQ_Notices_OK_Button}      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_Rollover_Intent_Notice_Window}
    Mx LoanIQ Select String    ${LIQ_Notice_Information_Table}    ${Customer_Legal_Name}
    mx LoanIQ click    ${LIQ_Rollover_EditHighlightedNotice_Button}       
    mx LoanIQ activate window    ${LIQ_Rollover_NoticeCreate_Window}
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=.*Notice created.*","displayed:=1").JavaEdit("text:=${Customer_Legal_Name}")    Verified_Customer    
    Should Be Equal As Strings    ${Customer_Legal_Name}    ${Verified_Customer}
    Log    ${Verified_Customer}    
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=.*Notice created.*","displayed:=1").JavaObject("tagname:=Group","text:=Status").JavaStaticText("text:=${NoticeStatus}")    Verified_Status    
    Should Be Equal As Strings    ${NoticeStatus}    ${Verified_Status}
    Log    ${Verified_Status} - Status is correct! 
    mx LoanIQ close window    ${LIQ_Rollover_NoticeCreate_Window}
    mx LoanIQ close window    ${LIQ_Rollover_Intent_Notice_Window}    
    
Navigate to Paper Clip Notebook from Loan Notebook
    [Documentation]    This keyword navigates the LIQ User to the Paper Clip Notebook from Loan Notebook.
    ...    @author: rtarayao
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ select    ${LIQ_Loan_Options_Payment}
    mx LoanIQ activate window    ${LIQ_Loan_ChoosePayment_Window}
    mx LoanIQ enter    ${LIQ_Loan_ChoosePayment_PaperClipPayment_RadioButton}    ON
    mx LoanIQ click    ${LIQ_Loan_ChoosePayment_OK_Button}
    mx LoanIQ activate window    ${LIQ_PaperClip_Window} 

Populate Paper Clip Initial Details- General Tab
    [Documentation]    This keyword is used to populate the initial details within general tab of the Paper Clip transaction.
    ...    @author: rtarayao
    [Arguments]    ${TransactionDescription}    ${EffectiveDate}    
    mx LoanIQ activate window    ${LIQ_PaperClip_Window}    
    mx LoanIQ enter    ${LIQ_PaperClip_TransactionDescription_TextBox}    ${TransactionDescription}
    mx LoanIQ enter    ${LIQ_PendingPaperClip_EffectiveDate_TextField}    ${EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ select    ${LIQ_PendingFee_File_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
          
Add Interest - Paper Clip   
    [Documentation]    This keyword is used to add an Interest Payment for the Paper Clip transaction.
    ...    @author: rtarayao
    [Arguments]    ${Loan_FacilityName}    ${Outstanding_Type}    ${Loan_Alias}    ${Pro_Rate}
    ###Interest###
    mx LoanIQ click    ${LIQ_PendingPaperClip_Add_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ activate window    ${LIQ_FeesandOutstandings_Window}
    Mx LoanIQ Select String    ${LIQ_FeesandOutstandings_Upper_JavaTree}    ${Loan_FacilityName}
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_FeesandOutstandings_Upper_JavaTree}    ${Outstanding_Type}
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_FeesandOutstandings_Upper_JavaTree}    ${Loan_Alias}
    mx LoanIQ enter    ${LIQ_FeesAndOutstandings_Interest_RadioButton}    ON
    mx LoanIQ click    ${LIQ_FeesandOutstandings_Add_Button}
    mx LoanIQ activate window    ${LIQ_Loan_CyclesforLoan_Window}   
    mx LoanIQ enter    JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=${Pro_Rate}")    ON 
    
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click    ${LIQ_Loan_CyclesforLoan_OK_Button}
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FeesandOutstandings_Window}                      VerificationData="Yes"
    \    Exit For Loop If    ${status}==True          
    

Add Principal - Paper Clip   
    [Documentation]    This keyword is used to add a Principal Payment for the Paper Clip transaction.
    ...    @author: rtarayao
    [Arguments]    ${PrincipalAmount} 
    mx LoanIQ activate window    ${LIQ_FeesandOutstandings_Window}
    mx LoanIQ enter    ${LIQ_FeesAndOutstandings_Principal_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_FeesAndOutstandings_EnterAmount_Textbox}    ${PrincipalAmount} 
    mx LoanIQ click    ${LIQ_FeesandOutstandings_Add_Button}

Add Event Fee - Paper Clip   
    [Documentation]    This keyword is used to add an Event Fee for the Paper Clip transaction.
    ...    @author: rtarayao
    [Arguments]    ${Fee_RequestedAmount}    ${Fee_FeeType}
    mx LoanIQ activate window    ${LIQ_FeesandOutstandings_Window}
    mx LoanIQ enter    ${LIQ_FeesandOutstandings_FreeFormEventFee_RadioButton}    ON
    mx LoanIQ click    ${LIQ_FeesandOutstandings_Add_Button}   

    mx LoanIQ activate window    ${LIQ_Fee_Window}
    mx LoanIQ enter    ${LIQ_Fee_RequestedAmount_Textfield}    ${Fee_RequestedAmount}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Fee_FeeType_DropdownList}    ${Fee_FeeType} 
    mx LoanIQ select    ${LIQ_Fee_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Mx LoanIQ Close    ${LIQ_Fee_ServiceFee_Window}
    Mx LoanIQ Select String    ${LIQ_FeesandOutstandings_NewTransactions_JavaTree}    ${Fee_FeeType}
    mx LoanIQ click    ${LIQ_FeesandOutstandings_OK_Button}

Validate Paper Clip Transaction Details
    [Documentation]    This keyword validates the Interest Payment, Principal Payment, and the Added Fee.  
    ...    @author: rtarayao
    [Arguments]    ${Interest}    ${Principal}    ${Fee_RequestedAmount}    ${TransactionType1}    ${TransactionType2}    ${Fee_FeeType}  
    mx LoanIQ activate window    ${LIQ_PaperClip_Window}
    ${UIInterestAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PaperClip_Transactions_JavaTree}   FIXED/${TransactionType1}%Amount%value         
    ${UIInterestAmount}    Remove String    ${UIInterestAmount}    ,
    ${UIInterestAmount}    Convert To Number    ${UIInterestAmount}    2
    ${UIInterestAmount}    Evaluate    "%.2f" % ${UIInterestAmount}
    Log    ${UIInterestAmount}    
    
    ${UIPrincipalAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PaperClip_Transactions_JavaTree}    FIXED/${TransactionType2}%Amount%value       
    ${UIPrincipalAmount}    Remove String    ${UIPrincipalAmount}    ,
    ${UIPrincipalAmount}    Convert To Number    ${UIPrincipalAmount}    2
    ${UIPrincipalAmount}    Evaluate    "%.2f" % ${UIPrincipalAmount}
    Log    ${UIPrincipalAmount}   
    
    ${UIFeeAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PaperClip_Transactions_JavaTree}    ${Fee_FeeType}${SPACE}(Free Form Fee)%Amount%value       
    ${UIFeeAmount}    Remove String    ${UIFeeAmount}    ,
    ${UIFeeAmount}    Convert To Number    ${UIFeeAmount}    2
    ${UIFeeAmount}    Evaluate    "%.2f" % ${UIFeeAmount}    
    Log    ${UIFeeAmount}    
        
    Should Be Equal As Numbers    ${Interest}    ${UIInterestAmount}
    Should Be Equal As Numbers    ${Principal}    ${UIPrincipalAmount}
    Should Be Equal As Numbers    ${Fee_RequestedAmount}    ${UIFeeAmount}
    
    ${ComputedTotalPapaerClipAmount}    Evaluate    ${UIInterestAmount} + ${UIPrincipalAmount} + ${UIFeeAmount}
    ${ComputedTotalPapaerClipAmount}    Convert To Number    ${ComputedTotalPapaerClipAmount}    2
    ${ComputedTotalPapaerClipAmount}    Evaluate    "%.2f" % ${ComputedTotalPapaerClipAmount}
    ${UITotalPaperClipAmount}    Mx LoanIQ Get Data    ${LIQ_PaperClip_Amount}    value
    ${UITotalPaperClipAmount}    Remove String    ${UITotalPaperClipAmount}    ,
    ${UITotalPaperClipAmount}    Convert To Number    ${UITotalPaperClipAmount}    2
    ${UITotalPaperClipAmount}    Evaluate    "%.2f" % ${UITotalPaperClipAmount}
    
    Should Be Equal As Numbers    ${ComputedTotalPapaerClipAmount}    ${UITotalPaperClipAmount}    
    
    Write Data To Excel    SERV23_LoanPaperClip    PaperClip_TotalPaymentAmount    ${rowid}    ${UITotalPaperClipAmount}                   
    

Navigate to Paper Clip Cashflow Window
    [Documentation]    This keyword is used to navigate to the Paper Clip Cashflows Window thru the Workflow action - Create Cashflows.
    ...    @author: rtarayao
    
    mx LoanIQ activate    ${LIQ_PaperClip_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_Tabs}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_PaperClip_WorkflowItems}    Create Cashflows%yes 
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_WorkflowItems}    Create Cashflows
    mx LoanIQ activate window    ${LIQ_Cashflows_Window}                 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Cashflows_Window}        VerificationData="Yes"
    
Send Paper Clip to Approval
    [Documentation]    This keyword is used to Send the Repayment Paper Clip for Approval.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_PaperClip_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_Tabs}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PaperClip_WorkflowItems}    Send to Approval%s
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_WorkflowItems}    Send to Approval
    Run Keyword And Ignore Error    Repeat Keyword    3    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}                   
    mx LoanIQ activate window    ${LIQ_PaperClip_Window}    
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_Repayment_AwaitingApproval_Status_Window}              

Open Paper Clip Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to open the Paper Clip Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingApprovalStatus}    ${WIP_PaymentType}    ${Loan_Alias}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_PaperClip_Window}

Approve Paper Clip - Bilateral
    [Documentation]    This keyword approves the Paper Clip Payment for a Bilateral Deal.
    ...    @author: rtarayao 
    mx LoanIQ activate window    ${LIQ_Repayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_Tabs}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_PaperClip_WorkflowItems}    Approval%yes 
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_WorkflowItems}    Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Ignore Error    Repeat Keyword    4    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}          
    mx LoanIQ activate window    ${LIQ_Repayment_Window}

Open Paper Clip Notebook via WIP - Awaiting Generate Intent Notices
    [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting Generate Intent Notices thru the LIQ WIP Icon.
    ...    @author: rtarayao
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingGenerateIntentNotices}    ${WIP_PaymentType}    ${Loan_Alias}

    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingGenerateIntentNotices}         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingGenerateIntentNotices}  

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
   
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_PaperClip_Window}

Open Paper Clip Notebook via WIP - Awaiting Release
    [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting Release Cashflow Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingRelease}    ${WIP_PaymentType}    ${Loan_Alias}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRelease}         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRelease}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_PaperClip_Window}
    
Navigate to Paper Clip Workflow Tab
    [Documentation]    This keyword navigates the LIQ User to the Paper Clip Workflow tab.
    ...    @author: rtarayao
    mx LoanIQ activate window    ${LIQ_PaperClip_Tabs}
    Mx LoanIQ Select Window Tab    ${LIQ_PaperClip_WorkflowItems}    Workflow
    
Open Paper Clip Notebook via WIP - Awaiting Release Cashflow
    [Documentation]    This keyword is used to open the Paper Clip Notebook with an Awaiting Release Cashflow Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingReleaseCashflowsStatus}    ${WIP_PaymentType}    ${Loan_Alias}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflowsStatus}         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflowsStatus} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_PaperClip_Window}    
    
Release Paper Clip Payment
    [Documentation]    This keyword is used to Release the Paper Clip Payment made for Bilateral Deal.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_PaperClip_Window}
    Mx LoanIQ Verify Text In Javatree    ${LIQ_PaperClip_WorkflowItems}    Release%yes 
    Mx LoanIQ DoubleClick    ${LIQ_PaperClip_WorkflowItems}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Ignore Error    Repeat Keyword    3    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}          
    mx LoanIQ activate window    ${LIQ_PaperClip_Window}        
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_Repayment_Released_Status_Window}
    
Initiate Paperclip payment via Outstanding Select
    [Documentation]    This keyword is used to initiate a paperclip payment from Outstanding Select window
    ...    @author: ritragel    09SEP2019
    [Arguments]    ${Loan_Alias}
    mx LoanIQ activate    ${LIQ_ExistingOutstandings_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ExistingOutstandings_Table}    ${Loan_Alias}%d
    mx LoanIQ activate    ${LIQ_Loan_Window}
    Select Menu Item    ${LIQ_Loan_Window}    Options    Payment
    
Select Existing loan for Facility
    [Documentation]    This keyword is used to select existing loan for facility
    ...    @author: fmamaril    20SEP2019
    [Arguments]    ${Loan_Alias}
    mx LoanIQ activate    ${LIQ_ExistingOutstandings_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ExistingOutstandings_Table}    ${Loan_Alias}%d    

Select Cycles Item
    [Documentation]    This keyword will select an item in the 'Cycles for Loan' window and select a specific 'Prorate With' option.
    ...    @author: mcastro    16DEC2020    - Initial Create
    [Arguments]    ${sProrate_With}    ${iCycle_No}

    ### Pre-processing Keyword ###
    ${Prorate_With}    Acquire Argument Value    ${sProrate_With}
    ${Cycle_No}    Acquire Argument Value    ${iCycle_No}

    Mx LoanIQ activate window    ${LIQ_Loan_CyclesforLoan_Window}
    Mx LoanIQ Set    JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("label:=${Prorate_With}")    ON
    Run Keyword If    '${Prorate_With}'=='Projected Due'    Set Test Variable    ${ProrateWith}    Projected Cycle Due
    Mx LoanIQ Select String    ${LIQ_Loan_CyclesforLoan_List}    ${Cycle_No}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CyclesForLoan

Validate Payment Amount and Interest Due on Cycles for Loan
    [Documentation]    This keyword will validate the payment amount and interest due on cycles for loan window.
    ...    @author: mcastro    16DEC2020    - Initial Create
    [Arguments]    ${sPayment_Amount}    ${sInterest_Due}

    ### Pre-processing Keyword ###
    ${Payment_Amount}    Acquire Argument Value    ${sPayment_Amount}
    ${Interest_Due}    Acquire Argument Value    ${sInterest_Due}

    ### Validate Payment Amount ###
    ${Payment_Amount}    Remove Comma and Convert to Number    ${Payment_Amount}
    ${ForPaymentAmount}    Mx LoanIQ Get Data    ${LIQ_CyclesForLoan_forPaymentAmount_Text}    ForPaymentAmount 
    ${ForPaymentAmount}    Remove Comma and Convert to Number    ${ForPaymentAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CyclesForLoan
    ${Status}    Run keyword and Return Status    Should Be Equal    ${Payment_Amount}    ${ForPaymentAmount}
    Run Keyword If    ${Status}==${True}    Log    for Payment Amount is correct
    ...    ELSE    Run Keyword and Continue on Failure    Fail    for Payment Amount is incorrect. Expected amount is ${Payment_Amount}

    ### Validate Interest Due ###
    ${Interest_Due}    Remove Comma and Convert to Number    ${Interest_Due}
    ${currentInterestDue}    Mx LoanIQ Get Data    ${LIQ_CyclesForLoan_Interest_Text}    currentInterestDue
    ${currentInterestDue}    Remove Comma and Convert to Number    ${currentInterestDue}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CyclesForLoan
    ${Status}    Run keyword and Return Status    Should Be Equal    ${Interest_Due}    ${currentInterestDue}
    Run Keyword If    ${Status}==${True}    Log    Interest Due is correct
    ...    ELSE    Run Keyword and Continue on Failure    Fail    Interest due is incorrect. Expected amount is ${Interest_Due}

Close Cycles for Loan Window
    [Documentation]    This keyword will select an item in the 'Cycles for Loan' window and select a specific 'Prorate With' option.
    ...    @author: mcastro    16DEC2020    - Initial Create

    Mx LoanIQ activate window    ${LIQ_Loan_CyclesforLoan_Window}
    Mx LoanIQ click    ${LIQ_Loan_CyclesforLoan_OK_Button}
    Mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CyclesForLoan

Navigate to Split Cashflows from Paper Clip
    [Documentation]    This keyword will go to split cashflow window from Paper clip notebook.
    ...    @author: mcastro    16DEC2020    - Initial Create

    Navigate Notebook Workflow    ${LIQ_PendingPaperClip_Window}    ${LIQ_PaperClip_Tabs}    ${LIQ_PaperClip_Workflow_Tab}    ${CREATE_CASHFLOW_TYPE}
    Mx LoanIQ activate window    ${LIQ_Cashflows_Window}
    Mx LoanIQ select    ${LIQ_Cashflow_Options_SplitCashflows}
    Mx LoanIQ activate window    ${LIQ_SplitCashflows_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SplitCashflow

Populate Split Cashflow Split Interest Amount
    [Documentation]    This keyword will populate split interest amount on split cashflow window.
    ...    @author: mcastro    16DEC2020    - Initial Create
    [Arguments]    ${sSplit_Interest}
   
    ### Pre-processing Keyword ###
    ${Split_Interest}    Acquire Argument Value    ${sSplit_Interest}

    Mx LoanIQ activate window    ${LIQ_SplitCashflows_Window}
    Mx LoanIQ click    ${LIQ_SplitCashflows_Add_Button}
    mx LoanIQ enter    ${LIQ_SplitCashflowsDetail_SplitInterest_Field}    ${Split_Interest}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SplitCashflowDetail
    mx LoanIQ click    ${LIQ_SplitCashflowsDetail_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SplitCashflow
    mx LoanIQ click    ${LIQ_SplitCashflows_Exit_Button}
    mx LoanIQ activate window    ${LIQ_Cashflows_Window}