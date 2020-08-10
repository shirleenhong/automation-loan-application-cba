*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***     
Add Unscheduled Transaction
    [Documentation]    This keyword adds an Unscheduled Principal Payment.
    ...    @author: rtarayao
    ...    @update: bernchua    15AUG2019    used generic keyword for warning messages
    ...    @update: sahalder    03JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sUnscheduledPrincipal_PrincipalAmt}
    
    ### GetRuntime Keyword Pre-processing ###
    ${UnscheduledPrincipal_PrincipalAmt}    Acquire Argument Value    ${sUnscheduledPrincipal_PrincipalAmt}

    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    ${UnschedPrincipalPaymentAmout}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentSchedule_List}    1%Unpaid Principal%Variable
    ${UnschedPrincipalPaymentAmout}    Remove Comma and Convert to Number    ${UnschedPrincipalPaymentAmout}
    ${UnscheduledPrincipal_PrincipalAmt}    Evaluate    ${UnschedPrincipalPaymentAmout}*.9
    ${UnscheduledPrincipal_PrincipalAmt}    Convert To Number    ${UnscheduledPrincipal_PrincipalAmt}    2
    Write Data To Excel    SERV20_UnschedPrincipalPayments    UnscheduledPrincipal_PrincipalAmt    ${rowid}    ${UnscheduledPrincipal_PrincipalAmt}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_AddUnschTran_Button}
    mx LoanIQ activate window    ${LIQ_AddTransaction_Window}    
    Validate Window Title    Add Transaction
    ${SystemDate}    Get System Date
    Log    ${SystemDate}
    mx LoanIQ maximize    ${LIQ_Window}
    mx LoanIQ activate window    ${LIQ_AddTransaction_Window}
    mx LoanIQ enter    ${LIQ_AddTransaction_Principal_Textfield}    ${UnscheduledPrincipal_PrincipalAmt}    
    mx LoanIQ enter    ${LIQ_AddTransactionEffectiveDate_Textfield}    ${SystemDate}
    mx LoanIQ enter    ${LIQ_AddTransaction_ApplyPrincipalToNextSchedPayment_RadioButton}    ON
    mx LoanIQ click    ${LIQ_AddTransaction_OK_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_AddTransaction_OK_Button}
    
    
    Verify If Warning Is Displayed
    
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    
    Verify If Warning Is Displayed    

    ${RemainingUnscheduledPrincipal_PrincipalAmt}    Evaluate    ${UnschedPrincipalPaymentAmout}*.1
    ${RemainingUnscheduledPrincipal_PrincipalAmt}    Convert To Number    ${RemainingUnscheduledPrincipal_PrincipalAmt}    2
    Write Data To Excel    SERV20_UnschedPrincipalPayments    RemainingUnscheduledPrincipal_PrincipalAmt    ${rowid}    ${RemainingUnscheduledPrincipal_PrincipalAmt}

Navigate to Unscheduled Principal Payment Notebook
    [Documentation]    This keyword navigates the LIQ User to the Unscheduled Unscheduled Principal Payment Notebook.
    ...    @author: rtarayao
    ...    update: mnanquilada
    ...    @update: sahalder    03JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sUnscheduledPrincipal_PrincipalAmt}
    
    ### GetRuntime Keyword Pre-processing ###
    ${UnscheduledPrincipal_PrincipalAmt}    Acquire Argument Value    ${sUnscheduledPrincipal_PrincipalAmt}

    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    ${UnscheduledPrincipal_PrincipalAmt}=      Evaluate     "{:,}".format(${UnscheduledPrincipal_PrincipalAmt})
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_RepaymentSchedule_CurrentSchedule_List}    ${UnscheduledPrincipal_PrincipalAmt}%s
    mx LoanIQ click    ${LIQ_RepaymentSchedule_TransactionNB_Button}
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${status}    Run Keyword And Return Status    Validate Warning Message Box
    \    Exit For Loop If    ${status}==False
    mx LoanIQ activate window    ${LIQ_Payment_Window}

Send Unscheduled Principal Payment to Approval
    [Documentation]    This keyword is used to Send the Unscheduled Principal Payment for Approval.
    ...    @author: rtarayao
    ...    @update: sahalder    09JUL2020    Added step for clicking Cashflows OK button press
    mx LoanIQ click element if present    ${LIQ_Payment_Cashflows_OK_Button}
    mx LoanIQ activate    ${LIQ_Payment_Window }   
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Send to Approval%s
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Send to Approval            
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Validate Warning Message Box 
    \    Exit For Loop If    ${Warning_Status}==False
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_Payment_AwaitingApproval_Status_Window}
    
    
Open Unscheduled Principal Payment Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to open the Repayment Paper Clip Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    @author: mnanquilada
    ...    @update: sahalder    03JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingApprovalStatus}    ${sWIP_PaymentType}    ${sLoan_Alias} 
    
    ### GetRuntime Keyword Pre-processing ###
	${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
	${WIP_AwaitingApprovalStatus}    Acquire Argument Value    ${sWIP_AwaitingApprovalStatus}
	${WIP_PaymentType}    Acquire Argument Value    ${sWIP_PaymentType}
	${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}	
    
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
    
    mx LoanIQ activate    ${LIQ_Payment_Window}

Release Unscheduled Principal Payment
    [Documentation]    This keyword release the unscheduled interest payment
    ...    @author: mnanquilada
    mx LoanIQ activate window    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Release%s 
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Release
    :FOR    ${i}    IN RANGE    5
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
    Verify If Information Message is Displayed
    ${message}    Mx LoanIQ Get Data    ${LIQ_BreakFunding_Message}    Message
    Run Keyword And Continue On Failure    Should Contain    ${message}    This transaction would cause breakfunding. Do you want to create a breakfunding fee payment?           
    mx LoanIQ click    ${LIQ_BreakFunding_Yes_Button}
    mx LoanIQ activate window    ${LIQ_UnscheduledPrincipalPayment_Breakfunding_Window}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_UnscheduledPrincipalPayment_Breakfunding_ComboBox}     Borrower Decision
    mx LoanIQ click    ${LIQ_UnscheduledPrincipalPayment_Breakfunding_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Release
    :FOR    ${i}    IN RANGE    5
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
    mx LoanIQ activate window    ${LIQ_Payment_Released_Status_Window}

Open Unscheduled Payment Notebook via WIP - Awaiting Generate Intent Notices
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
    mx LoanIQ activate    ${LIQ_Payment_Window}  

Navigate to Payment Intent Notice Window
    [Documentation]    This keyword sends Repayment Notices to the Borrower and Lender.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices
    Verify If Warning Is Displayed
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Validate Warning Message Box 
    \    Exit For Loop If    ${Warning_Status}==False
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
     
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Validate Warning Message Box    
    \    Exit For Loop If    ${Warning_Status}==False
    
    mx LoanIQ activate window    ${LIQ_Notice_PaymentIntentNotice_Window}
     
Get Global Current and Host Bank Gross Loan Amounts 
    [Documentation]    This keyword gets the current amount of the Current Global Loan Amount and Host Bank Gross Loan Amount.
    ...    @author: rtarayao   
    ${GlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Field}    GlobalCurrent
    ${status_GlobalCurrent}    Run Keyword And Return Status    Should Contain    ${GlobalCurrent}    ,           
    ${GlobalCurrent}    Run Keyword If    '${status_GlobalCurrent}'=='True'    Remove String    ${GlobalCurrent}    ,
    ...    ELSE    Set Variable If    '${status_GlobalCurrent}'=='False'    ${GlobalCurrent}
    ${GlobalCurrent}    Convert To Number    ${GlobalCurrent}    2

    ${HostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Field}    HostBankGross
    ${status_HostBankGross}    Run Keyword And Return Status    Should Contain    ${HostBankGross}    ,           
    ${HostBankGross}    Run Keyword If    '${status_HostBankGross}'=='True'    Remove String    ${HostBankGross}    ,
    ...    ELSE    Set Variable If    '${status_HostBankGross}'=='False'    ${HostBankGross}
    ${HostBankGross}    Convert To Number    ${HostBankGross}    2
    
    Log    ${GlobalCurrent}
    Log    ${HostBankGross}
    [Return]    ${GlobalCurrent}    ${HostBankGross}            
    
Validate if Outstanding Amount has decreased after Unscheduled Payment
    [Documentation]    This keyword checks the Geneal Tab if Outstanding Amount was decreased.
    ...    This is applicable for loans that had aready been completed the first cycle of the Principal and Interest Payment.
    ...    @author: fmamaril/rtarayao
    [Arguments]    ${OldGlobalCurrentAmount}    ${UnscheduledPrincipal_PrincipalAmt}    ${OldHostBankGross}    ${Cashflows_HostBankTranAmount}
    Log    ${UnscheduledPrincipal_PrincipalAmt}
    Log    ${Cashflows_HostBankTranAmount}  
    
    ${UnscheduledPrincipal_PrincipalAmt}    Remove Comma and Convert to Number    ${UnscheduledPrincipal_PrincipalAmt}
    # ${status}    Run Keyword And Return Status    Should Contain    ${UnscheduledPrincipal_PrincipalAmt}    ,           
    # ${UnscheduledPrincipal_PrincipalAmt}    Run Keyword If    '${status}'=='True'    Remove String    ${UnscheduledPrincipal_PrincipalAmt}    ,   
    # ${UnscheduledPrincipal_PrincipalAmt}    Convert To Number    ${UnscheduledPrincipal_PrincipalAmt}    2
    
    ${Cashflows_HostBankTranAmount}    Remove Comma and Convert to Number    ${Cashflows_HostBankTranAmount}
    # ${status}    Run Keyword And Return Status    Should Contain    ${Cashflows_HostBankTranAmount}    ,           
    # Run Keyword If    '${status}'=='True'    Remove String    ${Cashflows_HostBankTranAmount}    ,
    # ${Cashflows_HostBankTranAmount}    Convert To Number    ${Cashflows_HostBankTranAmount}    2
    
    ${NewGlobalCurrentAmount}    Evaluate    ${OldGlobalCurrentAmount} - ${UnscheduledPrincipal_PrincipalAmt}
    ${NewHostBankGross}    Evaluate    ${OldHostBankGross} - ${Cashflows_HostBankTranAmount}   
    
       
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${sGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Field}    GlobalOriginal
    ${GlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Field}    GlobalCurrent
    ${HostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Field}    HostBankGross
    ${sHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Field}    HostBankNet
    
    
    ${sGlobalOriginal}    Remove Comma and Convert to Number    ${sGlobalOriginal}
    ${GlobalCurrent}    Remove Comma and Convert to Number    ${GlobalCurrent}
    ${HostBankGross}    Remove Comma and Convert to Number    ${HostBankGross}
    ${HostBankNet}    Remove Comma and Convert to Number    ${sHostBankNet}
    
    
    # ${GlobalOriginal}    Remove String    ${sGlobalOriginal}    ,
    # ${GlobalCurrent}    Remove String    ${GlobalCurrent}    ,
    # ${HostBankGross}    Remove String    ${HostBankGross}    ,
    # ${HostBankNet}    Remove String    ${sHostBankNet}    ,
    
      
    # ${GlobalOriginal}    Convert To Number    ${GlobalOriginal}
    # ${GlobalCurrent}    Convert To Number    ${GlobalCurrent} 
    # ${HostBankGross}    Convert To Number    ${HostBankGross} 
    # ${HostBankNet}    Convert To Number    ${HostBankNet}
    
    
    
    Should Be Equal    ${NewGlobalCurrentAmount}    ${GlobalCurrent}
    Should Be Equal As Numbers    ${NewHostBankGross}    ${HostBankGross}
    Should Be Equal As Numbers    ${NewHostBankGross}    ${HostBankNet}
   
Validate Principal Payment for Term Facility on Oustanding Window after Unscheduled Payment
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    This only handles Syndicated deal with one drawdown.
    ...    @author: rtarayao
    [Arguments]    ${Borrower_Name}    ${NewPrincipalAmount}    ${Facility_ProposedCmt}    ${GlobalOriginal}
    ${sOutstandings}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Outstandings%sOutstandings
    ${sOutstandings}    Remove String    ${sOutstandings}    ,    
    ${nOutstandings}    Convert To Number    ${sOutstandings}
    Should Be Equal    ${NewPrincipalAmount}    ${nOutstandings}
    ${sAvailable}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Available%sAvailable
    ${sAvailable}    Remove String    ${sAvailable}    ,    
    ${sAvailable}    Convert To Number    ${sAvailable}
    ${Facility_ProposedCmt}    Remove String    ${Facility_ProposedCmt}    ,    
    ${Facility_ProposedCmt}    Convert To Number    ${Facility_ProposedCmt}
    ${ComputedAvailableLoan}    Evaluate     ${Facility_ProposedCmt} - ${GlobalOriginal}
    Should Be Equal    ${ComputedAvailableLoan}    ${sAvailable} 
    
Validate Principal Payment for Revolver Facility on Oustanding Window after Unscheduled Payment
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    This only handles Bilateral deal with only one drawdown.
    ...    Updated few steps to cater the unscheduled payment done. 
    ...    @author: fmamaril/rtarayao
    [Arguments]    ${Borrower_ShortName}    ${NewPrincipalAmount}    ${Facility_ProposedCmt}    ${ActualAmount}
    ${sOutstandings}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_ShortName}%Outstandings%sOutstandings
    ${sOutstandings}    Remove String    ${sOutstandings}    ,    
    ${nOutstandings}    Convert To Number    ${sOutstandings}
    Should Be Equal    ${NewPrincipalAmount}    ${nOutstandings}
    ${sAvailable}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_ShortName}%Available%sAvailable
    ${sAvailable}    Remove String    ${sAvailable}    ,    
    ${sAvailable}    Convert To Number    ${sAvailable}
    ${Facility_ProposedCmt}    Remove String    ${Facility_ProposedCmt}    ,    
    ${Facility_ProposedCmt}    Convert To Number    ${Facility_ProposedCmt}
    ${ComputedAvailableLoan}    Evaluate     (${Facility_ProposedCmt} - ${ActualAmount}) + ${ActualAmount}
    Should Be Equal    ${ComputedAvailableLoan}    ${sAvailable}      
    
Navigate to Payment Workflow Tab
    [Documentation]    This keyword navigates the LIQ User to the workflow tab of the Payment Notebook.
    ...    @author: rtarayao
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    mx LoanIQ click element if present   ${LIQ_OngoingFeePaymentInquiryMode_Button}

Approve Unscheduled Principal Payment
    [Documentation]    This keyword approves the unscheduled interest payment
    ...    @author: mnanquilada 
    mx LoanIQ activate window    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Approval%s 
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Approval 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    2
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Validate Warning Message Box 
     \    Exit For Loop If    ${Warning_Status}==False
    
############Computation#################   

Get Loan Interest Rate, Rate Basis, and New Start Date
    [Documentation]    This keyword is used in to get the Loan Interest Rate, Rate Basis, and New Start Date after Repayment of a Cycle.
    ...    Please note that this shall be used only when calculating the Interest for the next Scheduled Payment.
    ...    @author: rtarayao
    ...    @update: sahalder    03JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sCycleNumber}
    
    ### GetRuntime Keyword Pre-processing ###
	${CycleNumber}    Acquire Argument Value    ${sCycleNumber}

    mx LoanIQ activate    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Rates
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_Loan_AllInRate}    value%test
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_Loan_RateBasis_Dropdownlist}    value%test
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Integer    ${RateBasis}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ${StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${CycleNumber}%Due Date%Start Date
    [Return]    ${Rate}    ${RateBasis}    ${StartDate}    

Compute Next Payment Amount after Adding Unscheduled Principal
    [Documentation]    This keyword is used in computing the new Cycle Payment amount after Unscheduled Principal Payment.
    ...    @author: rtarayao
    [Arguments]    ${Loan_CalculatedFixedPayment}    ${UnscheduledPrincipal_PrincipalAmt}     
    Log    ${Loan_CalculatedFixedPayment}
    Log    ${UnscheduledPrincipal_PrincipalAmt}
    ${UnscheduledPrincipal_PrincipalAmt}    Remove Comma and Convert to Number    ${UnscheduledPrincipal_PrincipalAmt}
    ${Loan_CalculatedFixedPayment}    Remove Comma and Convert to Number    ${Loan_CalculatedFixedPayment}
    # ${status}    Run Keyword And Return Status    Should Contain    ${UnscheduledPrincipal_PrincipalAmt}    ,           
    # ${UnscheduledPrincipal_PrincipalAmt}    Run Keyword If    '${status}'=='True'    Remove String    ${UnscheduledPrincipal_PrincipalAmt}    ,
    # ${UnscheduledPrincipal_PrincipalAmt}    Convert To Number    ${UnscheduledPrincipal_PrincipalAmt}    2      
    ${PaymentAmount}    Evaluate    ${Loan_CalculatedFixedPayment} - ${UnscheduledPrincipal_PrincipalAmt}
    Log    ${PaymentAmount}
    [Return]    ${PaymentAmount}
    
Compute Interest for the New Payment Amount 
    [Documentation]    This keyword is used in computing the new Interest Amount after adding an Unscheduled Principal Payment.
    ...    @author: rtarayao
    [Arguments]    ${CycleNumber}    ${Repayment_RemainingPrincipal}    ${UnscheduledPrincipal_PrincipalAmt}    ${Rate}    ${RateBasis}    ${StartDate}
    ${PrincipalAmount}    Compute New Remaining Principal Amount   ${Repayment_RemainingPrincipal}    ${UnscheduledPrincipal_PrincipalAmt}
    ${EndDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_JavaTree}    ${CycleNumber}%Adjusted Due Date%End Date
    Log    ${StartDate}
    Log    ${EndDate}
    ${StartDate}    Convert Date    ${StartDate}     date_format=%d-%b-%Y
    ${EndDate}    Convert Date    ${EndDate}     date_format=%d-%b-%Y    
    ${NumberofDays}    Subtract Date From Date    ${EndDate}    ${StartDate}    verbose 
    Log    ${NumberofDays}
    ${NumberofDays}    Remove String    ${NumberofDays}     days
    ${NumberofDays}    Convert To Number    ${Numberof Days}
    # ${NumberofDays}   Evaluate    ${NumberofDays} + 1           
    ${InterestCycleDue}    Evaluate    (((${PrincipalAmount})*(${Rate}))*(${Numberof Days}))/${RateBasis}
    ${InterestCycleDue}    Convert To Number    ${InterestCycleDue}    2
    [Return]    ${InterestCycleDue} 
        
Compute New Remaining Principal Amount
    [Documentation]    This keyword is used in computing the New Remaining Principal after adding Unscheduled Principal.
    ...    @author: rtarayao
    [Arguments]    ${Repayment_RemainingPrincipal}    ${UnscheduledPrincipal_PrincipalAmt}
    Log    ${Repayment_RemainingPrincipal}
    ${Repayment_RemainingPrincipal}    Remove Comma and Convert to Number    ${Repayment_RemainingPrincipal}
    # ${status}    Run Keyword And Return Status    Should Contain    ${Repayment_RemainingPrincipal}    ,           
    # ${Repayment_RemainingPrincipal}    Run Keyword If    '${status}'=='True'    Remove String    ${Repayment_RemainingPrincipal}    ,
    # ${Repayment_RemainingPrincipal}    Convert To Number    ${Repayment_RemainingPrincipal}    2
    Log    ${UnscheduledPrincipal_PrincipalAmt}
    ${UnscheduledPrincipal_PrincipalAmt}    Remove Comma and Convert to Number    ${UnscheduledPrincipal_PrincipalAmt}
    # ${status}    Run Keyword And Return Status    Should Contain    ${UnscheduledPrincipal_PrincipalAmt}    ,           
    # ${UnscheduledPrincipal_PrincipalAmt}    Run Keyword If    '${status}'=='True'    Remove String    ${UnscheduledPrincipal_PrincipalAmt}    ,
    # ${UnscheduledPrincipal_PrincipalAmt}    Convert To Number    ${UnscheduledPrincipal_PrincipalAmt}    2
    ${ComputedNewPrincipalAmt}    Evaluate    ${Repayment_RemainingPrincipal} - ${UnscheduledPrincipal_PrincipalAmt}
    Log    ${ComputedNewPrincipalAmt}    
    [Return]    ${ComputedNewPrincipalAmt} 
    
Validate Next Payment Amount
    [Documentation]    This keyword is used in computing the new Cycle Payment amount after adding an Unscheduled Principal.
    ...    @author: rtarayao
    [Arguments]    ${Loan_CalculatedFixedPayment}    ${UnscheduledPrincipal_PrincipalAmt}    ${CycleNumber}     
    ${ComputedPaymentAmount}    Compute Next Payment Amount after Adding Unscheduled Principal    ${Loan_CalculatedFixedPayment}    ${UnscheduledPrincipal_PrincipalAmt}
    Log    ${ComputedPaymentAmount}
    ${UIPaymentAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_JavaTree}    ${CycleNumber}%Payment%value 
    ${UINewPrincipalAmt}    Remove String    ${UIPaymentAmount}    -    
    ${UINewPrincipalAmt}    Remove Comma and Convert to Number    ${UINewPrincipalAmt} 
    # ${status}    Run Keyword And Return Status    Should Contain    ${UINewPrincipalAmt}    ,           
    # ${UINewPrincipalAmt}    Run Keyword If    '${status}'=='True'    Remove String    ${UINewPrincipalAmt}    , 
    # ${UINewPrincipalAmt}    Convert To Number    ${UINewPrincipalAmt}    2  
    Should Be Equal As Numbers    ${ComputedPaymentAmount}    ${UINewPrincipalAmt}
    
Validate New Remaining Principal Amount   
    [Documentation]    This keyword validates the New Remaining Principal after Unscheduled Payment.
    ...    @author: rtarayao
    [Arguments]    ${Repayment_RemainingPrincipal}    ${UnscheduledPrincipal_PrincipalAmt}
    ${ComputedNewPrincipalAmt}    Compute New Remaining Principal Amount   ${Repayment_RemainingPrincipal}    ${UnscheduledPrincipal_PrincipalAmt}
    Log    ${ComputedNewPrincipalAmt}
    ${UINewPrincipalAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_JavaTree}    ${UnscheduledPrincipal_PrincipalAmt}%Remaining%value
    ${UINewPrincipalAmt}    Remove Comma and Convert to Number    ${UINewPrincipalAmt}
    # ${status}    Run Keyword And Return Status    Should Contain    ${UINewPrincipalAmt}    ,           
    # ${UINewPrincipalAmt}    Run Keyword If    '${status}'=='True'    Remove String    ${UINewPrincipalAmt}    , 
    # ${UINewPrincipalAmt}    Convert To Number    ${UINewPrincipalAmt}    2  
    Should Be Equal As Numbers    ${ComputedNewPrincipalAmt}    ${UINewPrincipalAmt}

Validate Next Cycle Unpaid Principal Amount
    [Documentation]    This keyword validates the Next Cylce Unpaid Principal Amount.
    ...    @author: rtarayao
    [Arguments]    ${Repayment_RemainingPrincipal}    ${Loan_CalculatedFixedPayment}    ${UnscheduledPrincipal_PrincipalAmt}    ${CycleNumber}    ${Rate}    ${RateBasis}    ${StartDate}
    ${NewPaymentAmt}    Compute Next Payment Amount after Adding Unscheduled Principal    ${Loan_CalculatedFixedPayment}    ${UnscheduledPrincipal_PrincipalAmt}  
    ${InterestCycleDue}    Compute Interest for the New Payment Amount    ${CycleNumber}    ${Repayment_RemainingPrincipal}    ${UnscheduledPrincipal_PrincipalAmt}    ${Rate}    ${RateBasis}    ${StartDate}
    ${NextCycleUnpaidPrincipalAmt}    Evaluate    ${NewPaymentAmt} - ${InterestCycleDue}
    ${UIUnpaidPrincipal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_JavaTree}    ${CycleNumber}%Unpaid Principal%test
    ${UIUnpaidPrincipal}    Remove Comma and Convert to Number    ${UIUnpaidPrincipal}
    # ${status}    Run Keyword And Return Status    Should Contain    ${UIUnpaidPrincipal}    ,           
    # ${UIUnpaidPrincipal}    Run Keyword If    '${status}'=='True'    Remove String    ${UIUnpaidPrincipal}    ,
    # ${UIUnpaidPrincipal}    Convert To Number    ${UIUnpaidPrincipal}    2       
    Should Be Equal As Numbers    ${NextCycleUnpaidPrincipalAmt}    ${UIUnpaidPrincipal}       

Get Current Facility Outstandings, Avail to Draw, Commitment Amount
    [Documentation]    This keyword gets the Current Facility Outstandings, Avail to Draw, Commitment Amount.
    ...    @author: rtarayao   
    ...    @update: rtarayao    13SEP2019    - deleted disabled keywords
    ...    @update: dahijara    06JUL2020    - Added keywords for post processing. Added optional arguments for runtime variable. Added keyword for screenshot.
    [Arguments]    ${sRunVar_GlobalFacCommitmentAmount}=None    ${sRunVar_GlobalFacOutstandingAmount}=None    ${sRunVar_GlobalFacAvailtoDrawAmount}=None
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    ${GlobalFacCommitmentAmount}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    text%value 
    ${GlobalFacOutstandingAmount}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    text%value
    ${GlobalFacAvailtoDrawAmount}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    text%value 
         
    ${GlobalFacCommitmentAmount}    Remove Comma and Convert to Number    ${GlobalFacCommitmentAmount}
    ${GlobalFacOutstandingAmount}    Remove Comma and Convert to Number    ${GlobalFacOutstandingAmount}
    ${GlobalFacAvailtoDrawAmount}    Remove Comma and Convert to Number    ${GlobalFacAvailtoDrawAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilitySummary_GlobalFacilityAmount

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_GlobalFacCommitmentAmount}    ${GlobalFacCommitmentAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_GlobalFacOutstandingAmount}    ${GlobalFacOutstandingAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_GlobalFacAvailtoDrawAmount}    ${GlobalFacAvailtoDrawAmount}
    [Return]    ${GlobalFacCommitmentAmount}    ${GlobalFacOutstandingAmount}    ${GlobalFacAvailtoDrawAmount}     

Validate New Global Current Cmt, Outstandings, and Avail to Draw for Term Facility
    [Documentation]    This keyword validates the New Global Current Cmt, Outstandings, and Avail to Draw for Term Facility.
    ...    @author: rtarayao
    ...    @update: sahalder    03JUL2020    Added keyword pre-processing steps
    ...    @update: dahijara    09JUL2020    - removed unnecessary commented lines.	
    [Arguments]    ${sGlobalFacCommitmentAmount}    ${sNewGlobalFacCommitmentAmount}    ${sGlobalFacOutstandingAmount}    ${sNewGlobalFacOutstandingAmount}    ${sGlobalFacAvailtoDrawAmount}    ${sNewGlobalFacAvailtoDrawAmount}    ${sPrincipalAmount}
    
    ### GetRuntime Keyword Pre-processing ###
	${GlobalFacCommitmentAmount}    Acquire Argument Value    ${sGlobalFacCommitmentAmount}
	${NewGlobalFacCommitmentAmount}    Acquire Argument Value    ${sNewGlobalFacCommitmentAmount}
	${GlobalFacOutstandingAmount}    Acquire Argument Value    ${sGlobalFacOutstandingAmount}
	${NewGlobalFacOutstandingAmount}    Acquire Argument Value    ${sNewGlobalFacOutstandingAmount}
	${GlobalFacAvailtoDrawAmount}    Acquire Argument Value    ${sGlobalFacAvailtoDrawAmount}
	${NewGlobalFacAvailtoDrawAmount}    Acquire Argument Value    ${sNewGlobalFacAvailtoDrawAmount}
	${PrincipalAmount}    Acquire Argument Value    ${sPrincipalAmount}

    ${PrincipalAmount}    Remove Comma and Convert to Number    ${PrincipalAmount}
    
    ${Computed_NewCommitmentAmount}    Evaluate    ${GlobalFacCommitmentAmount} - ${PrincipalAmount}
    Should Be Equal As Numbers    ${NewGlobalFacCommitmentAmount}    ${Computed_NewCommitmentAmount}        
    
    ${Computed_NewOutstandings}    Evaluate    ${GlobalFacOutstandingAmount} - ${PrincipalAmount}
    Should Be Equal As Numbers    ${NewGlobalFacOutstandingAmount}    ${Computed_NewOutstandings}
    
    Should Be Equal As Numbers    ${GlobalFacAvailtoDrawAmount}    ${NewGlobalFacAvailtoDrawAmount}    

Validate New Global Current Cmt, Outstandings, and Avail to Draw for Revolver Facility
    [Documentation]    This keyword validates the New Global Current Cmt, Outstandings, and Avail to Draw for Revolver Facility.
    ...    @author: rtarayao
    ...    @update: sahalder    03JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sGlobalFacCommitmentAmount}    ${sNewGlobalFacCommitmentAmount}    ${sGlobalFacOutstandingAmount}    ${sNewGlobalFacOutstandingAmount}    ${sGlobalFacAvailtoDrawAmount}    ${sNewGlobalFacAvailtoDrawAmount} 
    
    ### GetRuntime Keyword Pre-processing ###
	${GlobalFacCommitmentAmount}    Acquire Argument Value    ${sGlobalFacCommitmentAmount}
	${NewGlobalFacCommitmentAmount}    Acquire Argument Value    ${sNewGlobalFacCommitmentAmount}
	${GlobalFacOutstandingAmount}    Acquire Argument Value    ${sGlobalFacOutstandingAmount}
	${NewGlobalFacOutstandingAmount}    Acquire Argument Value    ${sNewGlobalFacOutstandingAmount}
	${GlobalFacAvailtoDrawAmount}    Acquire Argument Value    ${sGlobalFacAvailtoDrawAmount}
	${NewGlobalFacAvailtoDrawAmount}    Acquire Argument Value    ${sNewGlobalFacAvailtoDrawAmount}    
    
    Should Be Equal As Numbers    ${GlobalFacCommitmentAmount}    ${NewGlobalFacCommitmentAmount}
    Should Be Equal As Numbers    ${GlobalFacOutstandingAmount}    ${NewGlobalFacOutstandingAmount}
    Should Be Equal As Numbers    ${GlobalFacAvailtoDrawAmount}    ${NewGlobalFacAvailtoDrawAmount} 
    
Validate Loan on Repayment Schedule - Unscheduled
    [Documentation]    This keyword validates the Loan details on Repayment Schedule.
    ...    @author: fmamaril/rtarayao
    [Arguments]    ${CycleNumber}    ${Loan_CalculatedFixedPayment}    ${UnscheduledPrincipal_PrincipalAmt}
    
    ${SystemDate}    Get System Date
    Log    ${SystemDate}
    mx LoanIQ maximize    ${LIQ_Window}
    ${Comment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ScheduledPrincipalPayment_RapaymentHistory_JavaTree}    ${SystemDate}%Comment%Comment
    Should Be Equal    ${Comment}    Principal Prepayment of ${UnscheduledPrincipal_PrincipalAmt}. was applied to the outstanding. Commitment amount decreased. (Item due on ${SystemDate})    
    
    ${ComputedPaymentAmount}    Compute Next Payment Amount after Adding Unscheduled Principal    ${Loan_CalculatedFixedPayment}    ${UnscheduledPrincipal_PrincipalAmt}
    ${UIPaymentAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_JavaTree}    ${CycleNumber}%Payment%value 
    ${UINewPrincipalAmt}    Remove String    ${UIPaymentAmount}    -     
    ${UINewPrincipalAmt}    Remove Comma and Convert to Number    ${UINewPrincipalAmt}
    # ${status}    Run Keyword And Return Status    Should Contain    ${UINewPrincipalAmt}    ,           
    # ${UINewPrincipalAmt}    Run Keyword If    '${status}'=='True'    Remove String    ${UINewPrincipalAmt}    , 
    # ${UINewPrincipalAmt}    Convert To Number    ${UINewPrincipalAmt}    2  
    Should Be Equal As Numbers    ${ComputedPaymentAmount}    ${UINewPrincipalAmt} 
       
    mx LoanIQ click    ${LIQ_ScheduledPrincipalPayment_Exit_Button}

Validate Principal Prepayment in Loan Events Tab
    [Documentation]    This keyword validates the Loan details on Events Tab for the Unscheduled Principal Payment.
    ...    @author: fmamaril/rtarayao
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Loan_Event_JavaTree}   Principal Prepayment Applied
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_Loan_Event_JavaTree}    Principal Prepayment Applied%d
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    
Open Unscheduled Payment Notebook via WIP - Awaiting Release
    [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting release thru the LIQ WIP Icon.
    ...    @author: sahalder    initial create
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingRelease}    ${sWIP_PaymentType}    ${sLoan_Alias}
    
    ### GetRuntime Keyword Pre-processing ###
	${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
	${WIP_AwaitingRelease}    Acquire Argument Value    ${sWIP_AwaitingRelease}
	${WIP_PaymentType}    Acquire Argument Value    ${sWIP_PaymentType}
	${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

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
    mx LoanIQ activate    ${LIQ_Payment_Window}
    
Navigate to Principal Payment Notebook Workflow
    [Documentation]    This keyword navigates the Workflow tab of Principal Payment Notebook, and does a specific transaction.
    ...    
    ...    | Arguments |
    ...    
    ...    'Transaction' = The type of transaction listed under Workflow. Ex. Send to Approval, Approve, Release
    ...    
    ...    @author: sahalder    initial create
    
    [Arguments]    ${sTransaction}    

    ###Pre-processing Keyword##
    
    ${Transaction}    Acquire Argument Value    ${sTransaction} 

    mx LoanIQ activate window    ${LIQ_Payment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button} 

Open Payment Notebook via WIP - Awaiting Release Cashflow
    [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting release cashflow thru the LIQ WIP Icon.
    ...    @author: sahalder    initial create
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingReleaseCashflow}    ${sWIP_PaymentType}    ${sLoan_Alias}
    
    ### GetRuntime Keyword Pre-processing ###
	${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
	${WIP_AwaitingReleaseCashflow}    Acquire Argument Value    ${sWIP_AwaitingReleaseCashflow}
	${WIP_PaymentType}    Acquire Argument Value    ${sWIP_PaymentType}
	${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflow}         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflow}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_Payment_Window}
    
Release Payment Cashflows with Three Lenders
    [Documentation]    This keyword is used to open the cashflows notebook and generate the cashflows for the three lenders.
    ...    @author: sahalder    initial create
    [Arguments]    ${sBorrower_ShortName}    ${sLender1_ShortName}    ${sLender2_ShortName}    ${sRemittance_Description}    ${sRemittance_Instruction}
    
    ### GetRuntime Keyword Pre-processing ###
	${Borrower_ShortName}    Acquire Argument Value    ${sBorrower_ShortName}
	${Lender1_ShortName}    Acquire Argument Value    ${sLender1_ShortName}
	${Lender2_ShortName}    Acquire Argument Value    ${sLender2_ShortName}
	${Remittance_Description}    Acquire Argument Value    ${sRemittance_Description}
	${Remittance_Instruction}    Acquire Argument Value    ${sRemittance_Instruction}
	
    mx LoanIQ activate window    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Release%s 
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Release Cashflows
    :FOR    ${i}    IN RANGE    5
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
    Verify If Information Message is Displayed
    Mx LoanIQ Activate Window    ${LIQ_Cashflows_Window}
    Verify if Method has Remittance Instruction    ${Borrower_ShortName}    ${Remittance_Description}    ${Remittance_Instruction}    
    Verify if Method has Remittance Instruction    ${Lender1_ShortName}    ${Remittance_Description}    ${Remittance_Instruction}
    Verify if Method has Remittance Instruction    ${Lender2_ShortName}    ${Remittance_Description}    ${Remittance_Instruction}
    
