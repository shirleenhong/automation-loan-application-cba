*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot
*** Keywords ***   
Select Cycle Indemnity Fee Payment
    [Documentation]    This keywod selects a cycle fee payment.
    ...    @author: fmamaril
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}    
    mx LoanIQ select    ${LIQ_IndemnityFee_General_OptionsPayment_Menu}
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button} 
    mx LoanIQ enter    ${LIQ_CommitmentFee_Cycles_ProjectedDue_RadioButton}    ON
    mx LoanIQ click    ${LIQ_CommitmentFee_Cycles_OK_Button}
    Sleep    5
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Indemnity Fee.*;Warning;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
             
Update Cycle on Indemnity Fee
    [Documentation]    This keywod populates the effective date for ongoing fee payment.
    ...    @author: fmamaril 
    [Arguments]    ${Fee_Cycle} 
    mx LoanIQ activate    ${LIQ_IndemnityFee_Window}
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_IndemnityFee_InquiryMode_Button}
    Mx LoanIQ select combo box value    ${LIQ_IndemnityFee_Cycle_List}    ${Fee_Cycle}
    mx LoanIQ select    ${LIQ_IndemnityFee_Save_Menu}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;OK              strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
Send Ongoing Fee Payment to Approval - Indemnity
    
    [Documentation]    This keywod sends the ongoing fee payment to approval.
    ...    @author: fmamaril 
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Send to Approval%d
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_MessageBox}      VerificationData="Yes"
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes         strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Ongoing Fee Payment - Awaiting Approval.*")    VerificationData="Yes"
    
Approve Ongoing Fee Payment - Indemnity
    [Documentation]    This keyword approves the Ongoing Fee Payment from LIQ.
    ...    @author: fmamaril 
    # [Arguments]    ${ApproveDate}
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Approval%d
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Question;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes          strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Ongoing Fee Payment - Awaiting Release.*")    VerificationData="Yes"
    
Release Ongoing Fee Payment - Indemnity
    [Documentation]    This keyword releases the Ongoing Fee Payment from LIQ.
    ...    @author: fmamaril 
    # [Arguments]    ${ApproveDate}
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Release%d
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes         strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Question;Yes         strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Ongoing Fee Payment - Released.*")    VerificationData="Yes"
    
Send Indemnity Fee to Approval
    [Documentation]    This keyword sends a indemnity fee to approval.
    ...    @author: fmamaril
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_IndemnityFee_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_IndemnityFeeNotebook_Workflow_JavaTree}    Send to Approval%d  
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes         strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:= Commitment Fee / Awaiting Approval.*")    VerificationData="Yes"
Approve Indemnity Fee
    [Documentation]    This keyword approves the indemnity Fee from LIQ.
    ...    @author: fmamaril 
    # [Arguments]    ${ApproveDate}
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_IndemnityFee_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_IndemnityFeeNotebook_Workflow_JavaTree}    Approval%d
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Question;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes          strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:= Commitment Fee / Awaiting Release.*")    VerificationData="Yes"
    
Release Indemnity Fee
    [Documentation]    This keyword releases the Commitment Fee from LIQ.
    ...    @author: fmamaril 
    # [Arguments]    ${ApproveDate}
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_IndemnityFee_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_IndemnityFeeNotebook_Workflow_JavaTree}    Release%d
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Question;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes          strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:= Commitment Fee / Released.*")    VerificationData="Yes"
    mx LoanIQ select    ${LIQ_IndemnityFee_OnlineAcrual_Menu}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes            strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Informational Message.*;OK        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    
Enter Effective Date for Indemnity Fee Payment
    [Documentation]    This keyword populates commitment effective and float rate start date.
    ...    @author: fmamaril 
    [Arguments]    ${FeePayment_EffectiveDate} 
    mx LoanIQ activate window    ${LIQ_IndemnityFeePayment_Window}
    mx LoanIQ enter    ${LIQ_IndemnityFeePayment_EffectiveDate_Field}    ${FeePayment_EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Compute Indemnity Fee Amount Per Cycle
    [Documentation]    This keyword is used in computing the first Projected Cycle Due of the Commitment Fee and saves it to Excel.
    ...    @author: fmamaril
    [Arguments]    ${PrincipalAmount}    ${RateBasis}    ${CycleNumber}
    mx LoanIQ activate    ${LIQ_IndemnityFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    General
    # ${PrincipalAmount}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_BalanceAmount_Field}    value%test
    # Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Tab}    Rates
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_IndemnityFee_CurrentRate_Field}    value%test
    ${Cycle}    Mx LoanIQ Get Data    ${LIQ_IndemnityFee_Cycle_List}    value%test
    # ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_RateBasis_Text}    value%test
    ${PrincipalAmount}    Remove String    ${PrincipalAmount}    ,
    ${PrincipalAmount}    Convert To Number    ${PrincipalAmount}
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100    
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    # Mx Activate Window    ${LIQ_OngoingFeePayment_Window}
    # Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    Accrual
    ${ProjectedCycleDue}    Evaluate Indemnity Fee    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}
    Log    ${ProjectedCycleDue}
    [Return]    ${ProjectedCycleDue}
        
Evaluate Indemnity Fee
    [Documentation]    This keyword evaluates the FIRST Projected Cycle Due on a 'Weekly' cycle.
    ...    @author: fmamaril
    [Arguments]    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}
    ${StartDate}    Mx LoanIQ Get Data    ${LIQ_IndemnityFee_EffectiveDate_Field}    value%StartDate
    ${EndDate}    Mx LoanIQ Get Data    ${LIQ_IndemnityFee_AccrualEndDate_Field}    value%EndDate
    ##${EndDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFee_Acrual_JavaTree}    ${CycleNumber}%End Date%End Date
    Log    ${StartDate}
    Log    ${EndDate}
    ${StartDate}    Convert Date    ${StartDate}     date_format=%d-%b-%Y
    ${EndDate}    Convert Date    ${EndDate}     date_format=%d-%b-%Y    
    ${Numberof Days}    Subtract Date From Date    ${EndDate}    ${StartDate}    verbose 
    Log    ${Numberof Days}
    ${Numberof Days}    Remove String    ${Numberof Days}     days
    ${Numberof Days}    Convert To Number    ${Numberof Days}
    ${Numberof Days}   Evaluate    ${Numberof Days} + 1           
    # ${Time}    Set Variable    7
    [Return]    ${ProjectedCycleDue} 
    # ${Time}    Convert To Integer    ${Time}
    ${ProjectedCycleDue}    Evaluate    (((${PrincipalAmount})*(${Rate}))*(${Numberof Days}))/${RateBasis}
    ${ProjectedCycleDue}    Convert To Number    ${ProjectedCycleDue}    2
    
Validate GL Entries for Ongoing Fee Payment - Indemnity
    [Documentation]    This keyword validates the GL Entries of the Ongoing Fee Payment.
    ...    @author: fmamaril
    [Arguments]    ${HostBank_GLAccount}    ${Borrower_GLAccount}    ${Loan_RequestedAmount}     
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    mx LoanIQ select    ${LIQ_IndemnityFee_Queries_GLEntries}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Indemnity Fee.*;Warning;Yes             strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_GLEntries_Window}  
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_IndemnityFeePayment_GLEntries_Table}    ${Borrower_GLAccount}%s  
    ${DebitAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFeePayment_GLEntries_Table}    ${Borrower_GLAccount}%Debit Amt%test 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_IndemnityFeePayment_GLEntries_Table}    ${HostBank_GLAccount}%s    
    ${CreditAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFeePayment_GLEntries_Table}    ${HostBank_GLAccount}%Credit Amt%test 
    Log    Debit Amount: ${DebitAmount}
    Log    Credit Amount: ${CreditAmount}
    ${DebitAmount}    Remove String    ${DebitAmount}    ,
    ${CreditAmount}    Remove String    ${CreditAmount}    ,    
    ${DebitAmount}    Convert To Number    ${DebitAmount}
    ${CreditAmount}    Convert To Number    ${CreditAmount} 
    ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}                
    Should Be Equal    ${DebitAmount}    ${CreditAmount}
    Should Be Equal    ${Loan_RequestedAmount}    ${DebitAmount}
    Should Be Equal    ${Loan_RequestedAmount}    ${CreditAmount}        
    mx LoanIQ click    ${LIQ_OngoingFeePayment_GLEntries_Exit_Button}
        
Validate release of Ongoing Fee Payment - Indemnity
    [Documentation]    This keyword validates the release of Ongoing Fee Payment on Events.
    ...    @author: fmamaril
    mx LoanIQ activate    ${LIQ_IndemnityFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_IndemnityFee_Events_Javatree}   Fee Payment Released
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_IndemnityFee_Events_Javatree}    Fee Payment Released%d
    # Mx Activate Window    ${LIQ_OngoingFeePaymentNotebook_Window}
    
Run Online Acrual to Indemnity Fee
    [Documentation]    This keyword runs the online accrual for commitment fee.
    ...    @author: fmamaril 
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    Workflow
    mx LoanIQ select    ${LIQ_IndemnityFee_OnlineAcrual_Menu}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes            strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Warning;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Indemnity Fee.*;Informational Message.*;OK        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    
Validate Details on Acrual Tab - Indemnity
    [Documentation]    This keyword validates the details on Acrual Tab.
    ...    @author: fmamaril
    [Arguments]    ${Computed_ProjectedCycleDue}    ${CycleNumber}         
    # Mx Activate Window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    Accrual
    ${ProjectedEOCDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFee_Acrual_JavaTree}    ${CycleNumber}%Projected EOC due%ProjectedEOCDue    
    Should Be Equal As Strings    0.00    ${ProjectedEOCDue}
    ${CycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFee_Acrual_JavaTree}    ${CycleNumber}%Cycle Due%CycleDue
    ${Status}    Run Keyword And Return Status    Should Contain    ${CycleDue}    , 
    ${nCycleDue}    Run Keyword If    '${Status}'=='True'    Remove comma and convert to number - Cycle Due     ${CycleDue}    
    ...    ELSE    Run Keyword    Convert To Number    ${CycleDue}    2   
    ${AccruedToDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFee_Acrual_JavaTree}    ${CycleNumber}%Accrued to date%AccruedToDate
    ${Status}    Run Keyword And Return Status    Should Contain    ${AccruedToDate}    ,
    ${nAccruedToDate}    Run Keyword If    '${Status}'=='True'    Remove comma and convert to number    ${AccruedToDate}
    ...    ELSE    Run Keyword    Convert To Number    ${AccruedToDate}    2
    ${PaidToDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFee_Acrual_JavaTree}    ${CycleNumber}%Paid to date%PaidToDate
    ${Status}    Run Keyword And Return Status    Should Contain    ${PaidToDate}    ,
    ${nPaidToDate}    Run Keyword If    '${Status}'=='True'    Remove comma and convert to number    ${PaidToDate}
    ...    ELSE    Run Keyword    Convert To Number    ${PaidToDate}    2   
    ${s1ComputedCycleDue}    Run Keyword If    '${AccruedToDate}'!='0.00' and '${Status}'=='True'    Subtract Paid to Date to Accrued to Date    ${nPaidToDate}    ${nAccruedToDate}
    ${s2ComputedCycleDue}    Run Keyword If    '${AccruedToDate}'!='0.00' and '${Status}'!='True'    Subtract Paid to Date to Accrued to Date    ${PaidToDate}    ${AccruedToDate}     
    Run Keyword If    '${AccruedToDate}'!='0.00' and '${Status}'=='True'    Should Be Equal As Strings    ${s1ComputedCycleDue}    ${nCycleDue}
    Run Keyword If    '${AccruedToDate}'!='0.00' and '${Status}'!='True'    Should Be Equal As Strings    ${s2ComputedCycleDue}    ${CycleDue}
    Run Keyword If    '${AccruedToDate}'=='0.00'    Should Be Equal As Strings    0.00    ${CycleDue}    
    Run Keyword If    '${Status}'=='True'    Should Be Equal As Strings    ${Computed_ProjectedCycleDue}     ${nPaidToDate}
    Run Keyword If    '${Status}'!='True'    Should Be Equal As Strings    ${Computed_ProjectedCycleDue}     ${PaidToDate}
    
Remove comma and convert to number - Accrued to Date 
    [Arguments]    ${AccruedToDate}
    ${AccruedToDate}    Remove String    ${AccruedToDate}    ,
    ${nAccruedToDate}    Convert To Number    ${AccruedToDate}    2
    [Return]    ${nAccruedToDate}
    
Remove comma and convert to number - Paid to Date 
    [Arguments]    ${PaidToDate}
    ${PaidToDate}    Remove String    ${PaidToDate}    ,
    ${nPaidToDate}    Convert To Number    ${PaidToDate}    2
    [Return]    ${nPaidToDate}
    
Remove comma and convert to number - Cycle Due 
    [Arguments]    ${CycleDue}
    ${CycleDue}    Remove String    ${CycleDue}    ,
    ${nCycleDue}    Convert To Number    ${CycleDue}    2
    [Return]    ${nCycleDue}
    
Subtract Paid to Date to Accrued to Date    
    [Arguments]    ${nPaidToDate}    ${nAccruedToDate}
    ${ComputedCycleDue}    Evaluate    ${nAccruedToDate} - ${nPaidToDate}
    ${ComputedCycleDue}    Convert To String    ${ComputedCycleDue}
    # ${ComputedCycleDue}    Catenate    SEPARATOR=    -    ${ComputedCycleDue}
    ${Status}    Run Keyword And Return Status    Should Contain    ${ComputedCycleDue}    -        
    Run Keyword If    '${Status}'=='True'    Remove String    ${ComputedCycleDue}    - 
    [Return]    ${ComputedCycleDue}
    
Validate release of Indemnity Fee Payment
    [Documentation]    This keyword validates the release of Ongoing Fee Payment on Events.
    ...    @author: fmamaril
    mx LoanIQ activate window    ${LIQ_IndemnityFee}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_IndemnityFee_Events_Javatree}   Fee Payment Released
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_IndemnityFee_Events_Javatree}    Fee Payment Released%d
    mx LoanIQ activate window    ${LIQ_OngoingFeePaymentNotebook_Window}
    
Validate GL Entries for Indemnity Fee Payment - Syndicated
    [Documentation]    This keyword validates the GL Entries of the Ongoing Fee Payment.
    ...    @author: fmamaril
    [Arguments]    ${Host_Bank}    ${Borrower_ShortName}    ${Loan_RequestedAmount}    ${Lender1_ShortName}    ${Lender2_ShortName}     
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    mx LoanIQ select    ${LIQ_IndemnityFee_Queries_GLEntries}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes             strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_OngoingFeePayment_GLEntries_Window}   
    ${DebitAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OngoingFeePayment_GLEntries_Table}    ${Borrower_ShortName}%Debit Amt%test    
    ${CreditAmount1}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OngoingFeePayment_GLEntries_Table}    ${Host_Bank}%Credit Amt%test  
    ${CreditAmount2}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OngoingFeePayment_GLEntries_Table}    ${Lender1_ShortName}%Credit Amt%test    
    ${CreditAmount3}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OngoingFeePayment_GLEntries_Table}    ${Lender2_ShortName}%Credit Amt%test   
    Log    Debit Amount: ${DebitAmount}
    Log    Credit Amount: ${CreditAmount1}
    ${DebitAmount}    Remove String    ${DebitAmount}    ,
    ${Loan_RequestedAmount}    Remove String    ${Loan_RequestedAmount}    ,
    ${CreditAmount1}    Remove String    ${CreditAmount1}    ,  
    ${CreditAmount2}    Remove String    ${CreditAmount2}    , 
    ${CreditAmount3}    Remove String    ${CreditAmount3}    ,   
    ${DebitAmount}    Convert To Number    ${DebitAmount}
    ${CreditAmount1}    Convert To Number    ${CreditAmount1} 
    ${CreditAmount2}    Convert To Number    ${CreditAmount2}     
    ${CreditAmount3}    Convert To Number    ${CreditAmount3}
    ${CreditAmountTotal}   Evaluate    ${CreditAmount1} + ${CreditAmount2} + ${CreditAmount3}      
    ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}                
    Should Be Equal    ${DebitAmount}    ${CreditAmountTotal}
    Should Be Equal    ${Loan_RequestedAmount}    ${DebitAmount}
    Should Be Equal    ${Loan_RequestedAmount}    ${CreditAmountTotal}        
    mx LoanIQ click    ${LIQ_OngoingFeePayment_GLEntries_Exit_Button}
    
Validate GL Entries for Indemnity Fee Payment - Secondary Sale
    [Documentation]    This keyword validates the GL Entries of the Ongoing Fee Payment.
    ...    @author: fmamaril
    [Arguments]    ${Host_Bank}    ${Borrower_ShortName}    ${Loan_RequestedAmount}    ${Lender1_ShortName}         
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFeePayment_Tab}    Workflow
    mx LoanIQ select    ${LIQ_IndemnityFee_Queries_GLEntries}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes             strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_GLEntries_Window}   
    ${DebitAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFeePayment_GLEntries_Table}    ${Borrower_ShortName}%Debit Amt%test    
    ${CreditAmount1}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFeePayment_GLEntries_Table}    ${Host_Bank}%Credit Amt%test  
    ${CreditAmount2}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFeePayment_GLEntries_Table}    ${Lender1_ShortName}%Credit Amt%test      
    Log    Debit Amount: ${DebitAmount}
    Log    Credit Amount: ${CreditAmount1}
    ${DebitAmount}    Remove String    ${DebitAmount}    ,
    ${Loan_RequestedAmount}    Remove String    ${Loan_RequestedAmount}    ,
    ${CreditAmount1}    Remove String    ${CreditAmount1}    ,  
    ${CreditAmount2}    Remove String    ${CreditAmount2}    ,    
    ${DebitAmount}    Convert To Number    ${DebitAmount}
    ${CreditAmount1}    Convert To Number    ${CreditAmount1} 
    ${CreditAmount2}    Convert To Number    ${CreditAmount2}     
    ${CreditAmountTotal}   Evaluate    ${CreditAmount1} + ${CreditAmount2}     
    ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}                
    Should Be Equal    ${DebitAmount}    ${CreditAmountTotal}
    Should Be Equal    ${Loan_RequestedAmount}    ${DebitAmount}
    Should Be Equal    ${Loan_RequestedAmount}    ${CreditAmountTotal}        
    mx LoanIQ click    ${LIQ_OngoingFeePayment_GLEntries_Exit_Button}
    
Compute Lender Share Transaction Amount - Indemnity Fee
    [Documentation]    This keyword is used to compute for the Lender Share Transaction Amount.
    ...    @author: fmamaril  
    [Arguments]    ${LenderSharePct}    ${SheetName}
    ##Update: Hardcode ColumnName
    ${Computed_ProjectedCycleDue}    Read Data From Excel    ${SheetName}    Computed_ProjectedCycleDue2    ${rowid}
    Log    ${Computed_ProjectedCycleDue} 
    Log    ${LenderSharePct}    
    ${status}    Run Keyword And Return Status    Should Contain    ${Computed_ProjectedCycleDue}    ,           
    Run Keyword If    '${status}'=='True'    Remove String    ${Computed_ProjectedCycleDue}    ,
    ${LenderSharePct}    Evaluate    ${LenderSharePct}/100
    ${LenderShareTranAmt}    Evaluate    ${Computed_ProjectedCycleDue}*${LenderSharePct}   
    ${LenderShareTranAmt}    Convert To Number    ${LenderShareTranAmt}    2
    Log    ${LenderShareTranAmt}
    [Return]    ${LenderShareTranAmt}

Navigate to Indemnity Fee Usage Notebook
    [Documentation]    This keywod navigates to Indemnity Fee Usage Notebook from Facility.
    ...    @author: rtarayao    30AUG2019    - Initial Create
    [Arguments]    ${sFeeType}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_OngoingFeeList}
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Facility_FeeList_JavaTree}    ${sFeeType}%d


Get Indemnity Fee Usage Current Rate
    [Documentation]    This keyword gets the Indemnity Fee Usage Rate and returns the value.
    ...    author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_IndemnityFee_CurrentRate_Field}    value%Rate
    ${Rate}    Convert To String    ${Rate}
    ${Rate}    Remove String    ${Rate}    .000000%    
    Log    The Indemnity Fee Usage Rate is ${Rate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Commitment Rate
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${Rate}

Get Indemnity Fee Usage Currency
    [Documentation]    This keyword gets the Indemnity Fee Usage Currency and returns the value.
    ...    author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    ${FeeCurrency}    Mx LoanIQ Get Data    ${LIQ_IndemnityFee_Currency_Text}    value%Currency
    Log    The Indemnity Fee Usage Currency is ${FeeCurrency}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Indemnity Fee Usage Currency
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FeeCurrency}

Get Indemnity Fee Usage Effective and Actual Expiry Date
    [Documentation]    This keyword returns the Indemnity Fee Usage Effective and Expiry Date value.
    ...    author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    ${FeeEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_IndemnityFee_EffectiveDate_Field}    value%EffectiveDate
    ${FeeActualExpiryDate}    Mx LoanIQ Get Data    ${LIQ_IndemnityFee_ActualExpiryDate_Text}    value%ActualExpiryDate
    Log    The Indemnity Fee Usage Effective Date is ${FeeEffectiveDate}
    Log    The Indemnity Fee Usage Actual Expiry Date is ${FeeActualExpiryDate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Indemnity Fee Usage Effective and Expiry Dates
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FeeEffectiveDate}    ${FeeActualExpiryDate}
    
Get Indemnity Fee Usage Adjusted Due Date
    [Documentation]    This keyword returns the Indemnity Fee Usage Adjusted Due Date value.
    ...    author: rtarayao    30AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    ${FeeAdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_IndemnityFee_AdjustedDueDate}    value%AdjDueDate
    Log    The Indemnity Fee Usage Adjusted Due Date is ${FeeAdjustedDueDate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Indemnity Fee Usage Adj Due Date
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${FeeAdjustedDueDate}
    
Get Indemnity Fee Usage Accrued to Date Amount
    [Documentation]    This keyword returns the Indemnity Fee Usage total fee accrued to date value.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_IndemnityFee_Tab}    Accrual
    ${AccruedtodateAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_IndemnityFee_Acrual_JavaTree}    TOTAL:${SPACE}%Accrued to date%Accruedtodate    
    Log    The Indemnity Fee Usage Accrued to Date amount is ${AccruedtodateAmount} 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Indemnity Fee Usage Accrual Screen
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${AccruedtodateAmount}

Close Indemnity Fee Usage and Fee List Windows
    [Documentation]    This keyword exits the Ongoing Fee List and Indemnity Fee Usage Notebook.
    ...    author: rtarayao    19AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_IndemnityFee_Window} 
    mx LoanIQ close window    ${LIQ_IndemnityFee_Window}
    mx LoanIQ close window    ${LIQ_Facility_FeeList} 
    


    
    
