*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Initiate Issuance Fee Payment
    [Documentation]    This keyword selects the first cycle  in the "Cycles for Bank Guarantee..." window and creates a fee payment transaction.
    ...    This validates the details in the Issuance Fee Payment Notebook, sets the Effective date, and saves the transaction.
    ...    @author: bernchua
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sSBLC_Alias}    ${sIssuanceFeePayment_EffectiveDate}    ${sDeal_Name}    ${sFacility_Name}    ${sBorrower_Name}    ${sProjectedCycleDue}    ${sCycleNumber}

    ### GetRuntime Keyword Pre-processing ###
    ${SBLC_Alias}    Acquire Argument Value    ${sSBLC_Alias}
    ${IssuanceFeePayment_EffectiveDate}    Acquire Argument Value    ${sIssuanceFeePayment_EffectiveDate}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Borrower_Name}    Acquire Argument Value    ${sBorrower_Name}
    ${ProjectedCycleDue}    Acquire Argument Value    ${sProjectedCycleDue}
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}

    mx LoanIQ activate    ${LIQ_CyclesForBankGuarantee_Window}
    ${CyclesForBank_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${SBLC_Alias}.*")        VerificationData="Yes"
    Run Keyword If    ${CyclesForBank_Exist}==True    Log    Window title is verified with ${SBLC_Alias}.
    Validate if Element is Checked    ${LIQ_CyclesForBankGuarantee_ProjectedDue_RadioButton}    Projected Due
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_CyclesForBankGuarantee_Tree}    ${CycleNumber}%s
    :FOR    ${i}    IN RANGE    3
    \    mx LoanIQ click    ${LIQ_CyclesForBankGuarantee_OK_Button}
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    ${IssuanceFeePayment_WindowExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_IssuanceFeePaymentNotebook_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${IssuanceFeePayment_WindowExist}==True
    Validate Issuance Fee Payment Notebook Details    ${Deal_Name}    ${Facility_Name}    ${Borrower_Name}    ${SBLC_Alias}    ${ProjectedCycleDue}
    mx LoanIQ enter    ${LIQ_IssuanceFeePaymentNotebook_EffectiveDate_Field}    ${IssuanceFeePayment_EffectiveDate}
    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ select    ${LIQ_IssuanceFeePaymentNotebook_File_Save}
    :FOR    ${i}    IN RANGE    5
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Exit For Loop If    ${Warning_Displayed}==False
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate Loan IQ Details    ${IssuanceFeePayment_EffectiveDate}    ${LIQ_IssuanceFeePaymentNotebook_EffectiveDate_Field}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IssuanceFeePaymentWindow
    
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_OK_Button}    
    
Validate Issuance Fee Payment Notebook Details
    [Documentation]    This keyword validates the details in the Issuance Fee Payment Notebook.
    ...    @author: bernchua
    ...    @update: fmamaril    29APR2019    Add Input of Projected Cycle Due
    [Arguments]    ${Deal_Name}    ${Facility_Name}    ${Borrower_Name}    ${SBLC_Alias}    ${ProjectedCycleDue}
    mx LoanIQ activate window    ${LIQ_IssuanceFeePaymentNotebook_Window}
    Verify If Text Value Exist as Static Text on Page    Issuance Fee Payment    ${Deal_Name}
    Verify If Text Value Exist as Static Text on Page    Issuance Fee Payment    ${Facility_Name}
    Verify If Text Value Exist as Static Text on Page    Issuance Fee Payment    ${Borrower_Name}
    Verify If Text Value Exist as Static Text on Page    Issuance Fee Payment    ${SBLC_Alias}

    ${ProjectedDue}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Issuance Fee Payment.*").JavaObject("tagname:=Group","text:=.*Amounts.*").JavaEdit("editable:=0","value:=${ProjectedCycleDue}")    VerificationData="Yes"        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${ProjectedDue}==True    Log    ${ProjectedCycleDue} is displayed as the Projected Cycle Due for this payment.
    mx LoanIQ enter    ${LIQ_BankGuarantee_RequestedAmount_Field}    ${ProjectedCycleDue}    
    
Generate Intent Notices For Issuance Fee Payment
    [Documentation]    This keyword navigates the Issuance Fee Payment Notebook's Workflow tab and generates Intent Notices for the payment.
    ...    @author: bernchua
    [Arguments]    ${SBLCFeePayment_NoticeMethod}
    Mx LoanIQ Select Window Tab    ${LIQ_IssuanceFeePaymentNotebook_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_IssuanceFeePaymentNotebook_Workflow_Tree}    Generate Intent Notices%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    ${Notice_WindowDisplayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Notices_Window}        VerificationData="Yes"
    Run Keyword If    ${Notice_WindowDisplayed}==True    mx LoanIQ click    ${LIQ_Notices_Ok_Button}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_SBLCGuaranteeFeePaymentGroup_Tree}    ${SBLCFeePayment_NoticeMethod}%s
    mx LoanIQ select    ${LIQ_SBLCGuaranteeFeePaymentGroup_File_Preview}
    :FOR    ${i}    IN RANGE    3
    \    ${Error_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Error_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${Error_Exist}==True
    Run Keyword If    ${Error_Exist}==True    Run Keywords
    ...    Mx LoanIQ Verify Runtime Property    ${LIQ_Error_MessageBox}    text%Selected notice is not a scripted notice, So PDF/XML preview will not be available.
    ...    AND    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    mx LoanIQ click    ${LIQ_SBLCGuaranteeFeePaymentGroup_Edit_Button}
    mx LoanIQ maximize    ${LIQ_SBLCGuaranteeFeePaymentGroup_Notice_Window}
    Sleep    5s
    Take Screenshot
    mx LoanIQ close window    ${LIQ_SBLCGuaranteeFeePaymentGroup_Notice_Window}
    mx LoanIQ click    ${LIQ_SBLCGuaranteeFeePaymentGroup_Exit_Button}     

Send Issuance Fee Payment to Approval
    [Documentation]    This keywod sends the issuance fee payment to approval.
    ...    @author: fmamaril    29APR2019
    ...    @update: ehugo    02JUN2020    - added screenshot

    mx LoanIQ click element if present     ${LIQ_PaymentNotebook_Cashflow_OK_Button}
    mx LoanIQ activate window    ${LIQ_IssuanceFeePaymentNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IssuanceFeePaymentNotebook_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_IssuanceFeePaymentNotebook_Workflow_Tree}    Send to Approval%d    
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IssuanceFeePaymentNotebook_WorkflowTab_SendToApproval
    
Approve Issuance Fee Payment for Lender Share
    [Documentation]    This keyword approves the Issuance Fee Payment from LIQ.
    ...    @author: fmamaril    29APR2019 
    ...    @update: rtarayao    29AUG2019    - Added additional warning message handler
    ...    @update: ehugo    02JUN2020    - added screenshot

    mx LoanIQ activate window    ${LIQ_IssuanceFeePaymentNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IssuanceFeePaymentNotebook_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_IssuanceFeePaymentNotebook_Workflow_Tree}    Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IssuanceFeePaymentNotebook_WorkflowTab_Approval
    
Release Issuance Fee Payment for Lender Share
    [Documentation]    This keyword releases the Issuance Fee Payment from LIQ.
    ...    @author: fmamaril
    ...    @update: ehugo    02JUN2020    - added screenshot
    ...    @update: clanding    21JUL2020    - added additional warning message handler

    mx LoanIQ activate window    ${LIQ_IssuanceFeePaymentNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IssuanceFeePaymentNotebook_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_IssuanceFeePaymentNotebook_Workflow_Tree}    Release%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IssuanceFeePaymentNotebook_WorkflowTab_Release
