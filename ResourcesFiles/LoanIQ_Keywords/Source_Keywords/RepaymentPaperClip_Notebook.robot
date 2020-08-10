*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 

Initiate Interest Payment for Fixed Principal and Interest
    [Documentation]    This keyword initiates the payment of Loan Interest for a Fixed Principal and Interest type of Payment.
    ...    @author: rtarayao
    [Arguments]    ${CycleNumber}    ${Loan_PricingOption}

    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_RepaymentSchedule_CurrentSchedule_FixedPayment_List}    ${CycleNumber}%s 
    ${RemainingPrincipal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentSchedule_FixedPayment_List}    ${CycleNumber}%Remaining%value     
    mx LoanIQ click    ${LIQ_RepaymentSchedule_CreatePendingTran_Button}
    :FOR    ${i}    IN RANGE    4
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False         
             
    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    ${SystemDate}    Get System Date
    Log    ${SystemDate}
    mx LoanIQ maximize    ${LIQ_Window}
    mx LoanIQ activate window    ${LIQ_Repayment_Window}    
    ${Int_RepaymentEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_Repayment_EffectiveDate_Textfield}    value    
    Log    ${Int_RepaymentEffectiveDate}
    
    ${Status}    Run Keyword And Return Status    Should Not Be Equal    ${SystemDate}    ${Int_RepaymentEffectiveDate} 
    Run Keyword If    ${Status}==True    Run Keywords    mx LoanIQ select    ${LIQ_Repayment_Options_ChangeEffectiveDate}
    ...    AND    mx LoanIQ enter    ${LIQ_Repayment_EnterNewEffectiveDate_Textfield}    ${SystemDate}
    ...    AND    mx LoanIQ click    ${LIQ_Repayment_EnterNewEffectiveDate_OK_Button}       
    
    ${Int_RepaymentEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_Repayment_EffectiveDate_Textfield}    value    
    Log    ${Int_RepaymentEffectiveDate}   
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_Transactions_JavaTree}    ${Loan_PricingOption}${SPACE}Scheduled Interest Payment%d
    mx LoanIQ activate window    ${LIQ_Payment_Window}     
    [Return]    ${Int_RepaymentEffectiveDate}    ${RemainingPrincipal}
    

Initiate Principal Payment for Fixed Principal and Interest
    [Documentation]    This keyword initiates the payment of Principal for a Fixed Principal and Interest type of Payment.
    ...    @author: rtarayao
    [Arguments]    ${CycleNumber}    ${Loan_PricingOption}
    
    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    ${SystemDate}    Get System Date
    Log    ${SystemDate}
    mx LoanIQ maximize    ${LIQ_Window}
    Sleep    2s        
    mx LoanIQ activate    ${LIQ_Repayment_Window}    
    ${Principal_RepaymentEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_Repayment_EffectiveDate_Textfield}    value    
    Log    ${Principal_RepaymentEffectiveDate}
     
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_Transactions_JavaTree}    ${Loan_PricingOption}${SPACE}Scheduled Principal Payment%d
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    
    Write Data To Excel    SERV21_InterestPayments    Principal_RepaymentEffectiveDate    ${rowid}    ${Principal_RepaymentEffectiveDate}

Validate Principal Repayment Details
    [Documentation]    This keyword validates the interest repayment details for a Fixed Principal and Interest type of payment.
    ...    @author: rtarayao
    [Arguments]    ${Deal_Name}    ${Facility_Name}    ${Loan_CalculatedFixedPayment}    ${Loan_Borrower}    ${Loan_Alias}    ${Principal_RepaymentEffectiveDate}    ${Computed_LoanIntProjectedCycleDue}
    
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Principal Payment.*")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Principal Payment.*","displayed:=1").JavaStaticText("attached text:=${Deal_Name}")      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Principal Payment.*","displayed:=1").JavaStaticText("attached text:=${Facility_Name}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Principal Payment.*","displayed:=1").JavaStaticText("attached text:=${Loan_Borrower}")        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Principal Payment.*","displayed:=1").JavaStaticText("attached text:=${Loan_Alias}")                  VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Payment_CashflowFromBorrower_RadioButton}    From Borrower 
    # ${Principal_EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_Payment_EffectiveDate_Textfield}    value
    ${Principal_EffectiveDate}    Mx LoanIQ Get Data    JavaWindow("title:=.*Principal Payment .*").JavaEdit("attached text:=Effective Date:")    value
    Log    ${Principal_EffectiveDate}
    Should Be Equal    ${Principal_RepaymentEffectiveDate}    ${Principal_EffectiveDate}
    Log    ${Principal_RepaymentEffectiveDate} - Principal Effective Date from excel.    
    Log    ${Principal_EffectiveDate} - Principal Effective Date from UI.    
    
    ${Loan_CalculatedFixedPayment}    Remove Comma and Convert to Number    ${Loan_CalculatedFixedPayment}
    
    ${Repayment_PrincipalDue}    Evaluate    ${Loan_CalculatedFixedPayment}-${Computed_LoanIntProjectedCycleDue}
     
    # ${Principal_RequestedAmount}    Mx LoanIQ Get Data    ${LIQ_Payment_PrincipalRequestedAmt_Textfield}    value
    ${Principal_RequestedAmount}    Mx LoanIQ Get Data    JavaWindow("title:=.*Principal Payment.*").JavaEdit("attached text:=Requested:")    value
    # ${Principal_RequestedAmount}    Remove String    ${Principal_RequestedAmount}    ,
    # ${Principal_RequestedAmount}    Convert To Number    ${Principal_RequestedAmount}    2
    ${Principal_RequestedAmount}    Remove Comma and Convert to Number    ${Principal_RequestedAmount}
    Should Be Equal As Numbers    ${Repayment_PrincipalDue}    ${Principal_RequestedAmount}         
    Log    ${Principal_RequestedAmount} - Principal Requested amount in UI.
    Log    ${Repayment_PrincipalDue} - Current Cycle Principal Due      
    Mx LoanIQ Close    ${LIQ_Payment_Window}
    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    [Return]    ${Repayment_PrincipalDue}


Navigate to Paper Clip Intent Notices Window
    [Documentation]    This keyword sends Repayment Notices to the Borrower and Lender.
    ...    @update: rtarayao Added a script to handle the warning message after clicking on the Generate Intent Notices item.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_Repayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Repayment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Repayment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Repayment_WorkflowItems}    Generate Intent Notices
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    Run Keyword And Ignore Error    Repeat Keyword    4    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}         
    mx LoanIQ activate window    ${LIQ_Notice_PaperClipIntentNotice_Window}

Verify Customer Notice Method
    [Documentation]    This keyword validates the Notice method used by a customer. 
    ...    @author: rtarayao    
    [Arguments]    ${CustomerName}    ${Contact}    ${IntentNoticeStatus}    ${User}    ${NoticeMethod}    ${Contact_Email}
    mx LoanIQ activate window    ${LIQ_IntentNotice_Window}
    Mx LoanIQ Select String    ${LIQ_IntentNotice_Information_Table}    ${CustomerName}\t${Contact}\t${IntentNoticeStatus}\t${User}\t${NoticeMethod} 
    Run Keyword If    '${NoticeMethod}'=='Email'    Verify Customer Notice Details    ${Contact_Email}    ${IntentNoticeStatus}          

Verify Customer Notice Details 
    [Documentation]    This keyword validates the Customer's details for an Email Notice Method. 
    ...    @author: rtarayao
    [Arguments]    ${Contact_Email}    ${IntentNoticeStatus}
    mx LoanIQ click    ${LIQ_IntentNotice_EditHighlightedNotice_Button}
    mx LoanIQ activate window    ${LIQ_IntentNotice_Edit_Window}   
    ${ContactEmail}    Mx LoanIQ Get Data    ${LIQ_IntentNotice_Edit_Email}    value%test
    Log    ${ContactEmail}
    Should Be Equal    ${Contact_Email}    ${ContactEmail}          
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=.* Notice created.*").JavaStaticText("attached text:=${IntentNoticeStatus}")    Verified_Status    
    Should Be Equal As Strings    ${IntentNoticeStatus}    ${Verified_Status}
    mx LoanIQ close window    ${LIQ_IntentNotice_Edit_Window} 
    
Send Repayment Paper Clip to Approval
    [Documentation]    This keyword is used to Send the Repayment Paper Clip for Approval.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_Repayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Repayment_Tab}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_Repayment_WorkflowItems}    Send to Approval
    Run Keyword And Ignore Error    Repeat Keyword    4    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}                   
    mx LoanIQ activate window    ${LIQ_Repayment_Window}    
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_Repayment_AwaitingApproval_Status_Window}    
    
Open Repayment Paper Clip Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to open the Repayment Paper Clip Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    Loan_CalculatedFixedPayment is used when the 
    ...    @author: rtarayao
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingApprovalStatus}    ${WIP_PaymentType}    ${Payment}
    ${Payment}    Convert Number With Comma Separators    ${Payment}
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
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Payment}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_Repayment_Window}

Approve Repayment Paper Clip
    [Documentation]    This keyword approves the Repayment Paper Clip.
    ...    @author: rtarayao 
    
    mx LoanIQ activate window    ${LIQ_Repayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Repayment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Repayment_WorkflowItems}    Approval%yes 
    Mx LoanIQ DoubleClick    ${LIQ_Repayment_WorkflowItems}    Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Ignore Error    Repeat Keyword    4    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}          
    mx LoanIQ activate window    ${LIQ_Repayment_Window}

Navigate to Repayment Paper Clip Notebook from Loan Notebook
    [Documentation]    This keyword navigates the User to the Repayment Paper Clip Notebook from the Loan Notebook.
    ...    @author: rtarayao 
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Loan_Events_List}    Interest Payment Released%d    
    mx LoanIQ activate window    ${LIQ_Repayment_Window}

Compute New Global Outstandings After Principal Payment  
    [Documentation]    This keyword computes the new global outstanding amount after principal payment.
    ...    @author: rtarayao
    [Arguments]    ${Repayment_PrincipalAmount}    ${Loan_RequestedAmount}
    ${NewGlobalOustandings}    Evaluate    ${Loan_RequestedAmount} - ${Repayment_PrincipalAmount}
    Log    ${NewGlobalOustandings}
    [Return]    ${NewGlobalOustandings}            

Release Repayment Paper Clip
    [Documentation]    This keyword is used to Release the Repayment Paper Clip made.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_Repayment_Window}
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Repayment_WorkflowItems}    Release%yes 
    Mx LoanIQ DoubleClick    ${LIQ_Repayment_WorkflowItems}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Ignore Error    Repeat Keyword    3    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}          
    mx LoanIQ activate window    ${LIQ_Repayment_Window}        
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_Repayment_Released_Status_Window} 

Get Current Outstandings Host Bank Gross and Host Bank Net
    [Documentation]    This keyword gets the current host bank outstanding amount before principal payment.
    ...    @author: rtarayao
    ...    @update: dahijara    10JUL2020    - added post processing keyword; optional argument for runtime variables; and take screenshot.
    [Arguments]    ${sRunVar_HostBankGross}=None    ${sRunVar_HostBankNet}=None
    ${HostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Field}    HostBankGross
    ${sHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Field}    HostBankNet   
    ${HostBankGross}    Remove String    ${HostBankGross}    ,
    ${HostBankNet}    Remove String    ${sHostBankNet}    ,
    ${HostBankGross}    Convert To Number    ${HostBankGross}    2 
    ${HostBankNet}    Convert To Number    ${HostBankNet}    2 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_CurrentOutstanding
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_HostBankGross}    ${HostBankGross}
    Save Values of Runtime Execution on Excel File    ${sRunVar_HostBankNet}    ${HostBankNet}
    [Return]    ${HostBankGross}    ${HostBankNet}        
         
Validate if Outstanding Amount has decreased after Paper Clip - Syndicated
    [Documentation]    This keyword checks the Geneal Tab if Outstanding Amount was decreased.
    ...    This is only applicable for Syndicated deal.
    ...    @author: fmamaril/rtarayao
    [Arguments]    ${Principal}    ${OldHostBankGross}    ${OldHostBankNet}    ${HostBankPrincipal}
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${sGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Field}    GlobalOriginal
    ${GlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Field}    GlobalCurrent
    ${HostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Field}    HostBankGross
    ${sHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Field}    HostBankNet
    ${GlobalOriginal}    Remove String    ${sGlobalOriginal}    ,
    ${GlobalCurrent}    Remove String    ${GlobalCurrent}    ,
    ${HostBankGross}    Remove String    ${HostBankGross}    ,
    ${HostBankNet}    Remove String    ${sHostBankNet}    ,    
    ${GlobalOriginal}    Convert To Number    ${GlobalOriginal}
    ${GlobalCurrent}    Convert To Number    ${GlobalCurrent} 
    ${HostBankGross}    Convert To Number    ${HostBankGross} 
    ${HostBankNet}    Convert To Number    ${HostBankNet}
    ${Principal}    Convert To Number    ${Principal}
    ${NewGlobalPrincipalAmount}    Evaluate     ${GlobalOriginal} - ${Principal}     
    ${ComputedCurrentHostBankGross}    Evaluate    ${OldHostBankGross} - ${HostBankPrincipal}  
    ${ComputedCurrentHostBankNet}    Evaluate    ${OldHostBankNet} - ${HostBankPrincipal}   
    Should Be Equal As Numbers    ${NewGlobalPrincipalAmount}    ${GlobalCurrent}
    Should Be Equal As Numbers    ${ComputedCurrentHostBankGross}    ${HostBankGross}
    Should Be Equal As Numbers    ${ComputedCurrentHostBankNet}    ${HostBankNet}

Validate Principal Payment for Term Facility on Oustanding Window after Paper Clip - Syndicated
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    This only handles Syndicated deal with one drawdown.
    ...    @author: rtarayao
    [Arguments]    ${Borrower_Name}    ${Loan_RequestedAmount}    ${Repayment_PrincipalAmount}    ${Facility_ProposedCmt}    ${GlobalOriginal}
    ${NewGlobalOustandings}    Evaluate    ${Loan_RequestedAmount} - ${Repayment_PrincipalAmount}
    ${sOutstandings}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Outstandings%sOutstandings
    ${sOutstandings}    Remove String    ${sOutstandings}    ,    
    ${nOutstandings}    Convert To Number    ${sOutstandings}
    Should Be Equal    ${NewGlobalOustandings}    ${nOutstandings}
    ${sAvailable}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Available%sAvailable
    ${sAvailable}    Remove String    ${sAvailable}    ,    
    ${sAvailable}    Convert To Number    ${sAvailable}
    ${Facility_ProposedCmt}    Remove String    ${Facility_ProposedCmt}    ,    
    ${Facility_ProposedCmt}    Convert To Number    ${Facility_ProposedCmt}
    ${ComputedAvailableLoan}    Evaluate     ${Facility_ProposedCmt} - ${GlobalOriginal}
    Should Be Equal    ${ComputedAvailableLoan}    ${sAvailable}  

Validate Principal Payment for Revolver Facility on Oustanding Window after Paper Clip - Syndicated
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    This only handles Syndicated deal with only one drawdown.
    ...    @author: rtarayao
    [Arguments]    ${Borrower_ShortName}    ${NewPrincipalAmount}    ${Facility_ProposedCmt}    ${GlobalOriginal}    ${ActualAmount}
    ${sOutstandings}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_ShortName}%Outstandings%sOutstandings
    ${sOutstandings}    Remove String    ${sOutstandings}    ,    
    ${nOutstandings}    Convert To Number    ${sOutstandings}
    Should Be Equal    ${NewPrincipalAmount}    ${nOutstandings}
    ${sAvailable}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_ShortName}%Available%sAvailable
    ${sAvailable}    Remove String    ${sAvailable}    ,    
    ${sAvailable}    Convert To Number    ${sAvailable}
    ${Facility_ProposedCmt}    Remove String    ${Facility_ProposedCmt}    ,    
    ${Facility_ProposedCmt}    Convert To Number    ${Facility_ProposedCmt}
    ${ComputedAvailableLoan}    Evaluate     (${Facility_ProposedCmt} - ${GlobalOriginal}) + ${ActualAmount}
    Should Be Equal    ${ComputedAvailableLoan}    ${sAvailable}        

Navigate to Paper Clip Repayment Notebook from Loan Notebook
    [Documentation]    This keyword navigates the User to the Initial Drawdown Notebook from the Loan Notebook.
    ...    @author: rtarayao 
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Loan_Events_List}    Released%d    
    mx LoanIQ activate window    ${LIQ_Payment_Window} 
    
Navigate to Repayment Workflow Tab
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    @author: rtarayao
    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Repayment_Tab}    Workflow

Add Residual Value and Validate Host Bank Share
    [Documentation]    This keyword is used to add the residual amount to Host Bank Share when there is an amount difference with the total Shares.
    ...    This keyword also compares the Host Bank share in UI and the Computed Host Bank Share after adding the amount difference.
    ...    @author: rtarayao
    [Arguments]    ${ComputedHostBankShares}    ${ResidualAmount}    ${UIHostBankShares}  
    ${ComputedHostBankShares}    Evaluate    ${ComputedHostBankShares}+${ResidualAmount}
    Should Be Equal As Numbers    ${UIHostBankShares}    ${ComputedHostBankShares}  

Initiate Paper Clip Payment and Return Payment Due Date
    [Documentation]    This keyword initiates the payment of Loan Interest and Returns the Payment Due Date.
    ...    @author: rtarayao
    ...    @update: rtarayao    21MAR2019    Updated container for Due date in alignment with the standards set.
    ...    @update: dahijara    06JUL2020    - Added pre and post processing keywords. Added screenshot and optional argument for runtime variable.
    ...                                      - Updated locator for Current Schedule Table
    [Arguments]    ${sCycleNumber}    ${sRunVar_PaymentDueDate}=None
    ### GetRuntime Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}    
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    ${sPaymentDueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentSchedule_Javatree}    ${CycleNumber}%Actual Due Date%value
    Log    ${sPaymentDueDate}      
    Mx LoanIQ Select String    ${LIQ_RepaymentSchedule_CurrentSchedule_Javatree}    ${CycleNumber}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule  
    mx LoanIQ click    ${LIQ_RepaymentSchedule_CreatePendingTran_Button}
    Run Keyword And Ignore Error    Repeat Keyword    3    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}             

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_PaymentDueDate}    ${sPaymentDueDate}
    [Return]    ${sPaymentDueDate}
 
Input Paper Clip Details
    [Documentation]    This keyword populates the effective date and Paper Clip Transaction Description.
    ...    @author: rtarayao
    ...    @update: dahijara    06JUL2020    - added keyword for pre-processing and for screenshot.
    [Arguments]    ${sCycleNumber}    ${sLoan_PricingOption}
    ### GetRuntime Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption} 
    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    ${SystemDate}    Get System Date
    Log    ${SystemDate}
    mx LoanIQ maximize    ${LIQ_Window}   
    mx LoanIQ activate    ${LIQ_Repayment_Window}    
    ${Int_RepaymentEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_Repayment_EffectiveDate_Textfield}    value    
    Log    ${Int_RepaymentEffectiveDate}
    
    ${Status}    Run Keyword And Return Status    Should Not Be Equal    ${SystemDate}    ${Int_RepaymentEffectiveDate} 
    Run Keyword If    ${Status}==True    Run Keywords    mx LoanIQ select    ${LIQ_Repayment_Options_ChangeEffectiveDate}
    ...    AND    mx LoanIQ enter    ${LIQ_Repayment_EnterNewEffectiveDate_Textfield}    ${SystemDate}
    ...    AND    mx LoanIQ click    ${LIQ_Repayment_EnterNewEffectiveDate_OK_Button}
    
    mx LoanIQ enter    ${LIQ_Repayment_TransactionDescription_Textfield}    Paperclip payment for Loan Drawdown
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Repayment
    mx LoanIQ select    ${LIQ_Repayment_File_Save}           

Add Event Fee for Paper Clip Transaction
    [Documentation]    This keyword adds an event fee for the Paper Clip Transaction.
    ...    This also validates the Added fee is displayed in the Fees and Outstandings window.
    ...    @author: rtarayao
    ...    @update: dahijara    06JUL2020    - added keyword for pre-processing and for screenshot.    
    [Arguments]    ${sCycleNumber}    ${sLoan_PricingOption}    ${sLoan_FacilityName}    ${sFee_RequestedAmount}    ${sFee_FeeType}

    ### GetRuntime Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
    ${Loan_FacilityName}    Acquire Argument Value    ${sLoan_FacilityName}
    ${Fee_RequestedAmount}    Acquire Argument Value    ${sFee_RequestedAmount}
    ${Fee_FeeType}    Acquire Argument Value    ${sFee_FeeType}
    mx LoanIQ activate window    ${LIQ_Repayment_Window}  
    mx LoanIQ click    ${LIQ_Repayment_Add_Button}
    mx LoanIQ activate window    ${LIQ_FeesandOutstandings_Window}            
    Mx LoanIQ Select String    ${LIQ_FeesandOutstandings_Upper_JavaTree}    ${Loan_FacilityName}
    mx LoanIQ enter    ${LIQ_FeesandOutstandings_FreeFormEventFee_RadioButton}    ON
    mx LoanIQ click    ${LIQ_FeesandOutstandings_Add_Button}
    mx LoanIQ activate window    ${LIQ_Fee_Window}
    mx LoanIQ enter    ${LIQ_Fee_RequestedAmount_Textfield}    ${Fee_RequestedAmount}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Fee_FeeType_DropdownList}    ${Fee_FeeType} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FeeWindow
    mx LoanIQ select    ${LIQ_Fee_File_Save}
    Mx LoanIQ Close    ${LIQ_Fee_ArrangerFee_Window}
    mx LoanIQ activate window    ${LIQ_FeesandOutstandings_Window}
    Mx LoanIQ Select String    ${LIQ_FeesandOutstandings_NewTransactions_JavaTree}    ${Fee_FeeType}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FeesandOutstandings
    mx LoanIQ click    ${LIQ_FeesandOutstandings_OK_Button}          

Validate Repayment Paper Clip Transaction Details
    [Documentation]    This keyword validates the Interest Payment, Principal Payment, and the Added Fee.  
    ...    This keyword also returns the total repayment value for the payment cycle.
    ...    @author: rtarayao
    ...    @udpate: rtarayao    21MAR2019    Updated keyword used for number conversion.
    ...    @update: dahijara    07JUL2020    - added pre and post processing keywords. Added optional argument for runtime variable and keyword for screenshot.
    [Arguments]    ${sInterest}    ${sPrincipal}    ${sFee_RequestedAmount}    ${sLoan_PricingOption}    ${sRunVar_TotalRepaymentAmount}=None
    ### GetRuntime Keyword Pre-processing ###
    ${Interest}    Acquire Argument Value    ${sInterest}
    ${Principal}    Acquire Argument Value    ${sPrincipal}
    ${Fee_RequestedAmount}    Acquire Argument Value    ${sFee_RequestedAmount}
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
  
    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    ${sUIInterestAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Transactions_JavaTree}    ${Loan_PricingOption}${SPACE}Scheduled Interest Payment%Amount%value         
    ${sUIInterestAmount}    Remove Comma and Convert to Number    ${sUIInterestAmount}
    Log    ${sUIInterestAmount}   
    ${sUIPrincipalAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Transactions_JavaTree}    ${Loan_PricingOption}${SPACE}Scheduled Principal Payment%Amount%value     
    ${sUIPrincipalAmount}    Remove Comma and Convert to Number    ${sUIPrincipalAmount}  
    Log    ${sUIPrincipalAmount}   
    ${sUIFeeAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Transactions_JavaTree}    Arranger Fee Fee%Amount%value
    ${sUIFeeAmount}    Remove Comma and Convert to Number    ${sUIFeeAmount}    
    Log    ${sUIFeeAmount}    
        
    Should Be Equal As Numbers    ${Interest}    ${sUIInterestAmount}
    Should Be Equal As Numbers    ${Principal}    ${sUIPrincipalAmount}
    Should Be Equal As Numbers    ${Fee_RequestedAmount}    ${sUIFeeAmount}
    
    ${sTotalRepaymentAmount}    Evaluate    ${sUIInterestAmount} + ${sUIPrincipalAmount} + ${sUIFeeAmount}
    ${sTotalRepaymentAmount}    Evaluate    "%.2f" % ${sTotalRepaymentAmount}
    ${sUITotalRepaymentAmount}    Mx LoanIQ Get Data    ${LIQ_Repayment_Amount}    value
    ${sUITotalRepaymentAmount}    Remove Comma and Convert to Number    ${sUITotalRepaymentAmount}
    Should Be Equal As Numbers    ${sTotalRepaymentAmount}    ${sUITotalRepaymentAmount}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Repayment
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_TotalRepaymentAmount}    ${sTotalRepaymentAmount}
    [Return]    ${sTotalRepaymentAmount}      
                      
Validate Remittance Instructions in Cashflow - Repayment Paper Clip Bilateral
    [Documentation]    This keyword is used to validate that the remittance instructions used are correct.
    ...    This cashflow validation is applicable only for Paper Clip Payment (Principal and Interest) 
    ...    @author: rtarayao
    [Arguments]    ${Principal}    ${Interest}    ${FeeAmount}    ${Loan_Currency}    ${Remittance_Description} 
    Verify Borrower Principal Remittance Instruction    ${Principal}    ${Loan_Currency}    ${Remittance_Description}
    Verify Borrower Interest Remittance Instruction    ${Interest}    ${Loan_Currency}    ${Remittance_Description}
    Verify Borrower Fee Remittance Instruction    ${FeeAmount}    ${Loan_Currency}    ${Remittance_Description}
    Verify Borrower Principal Remittance Status    ${Principal}    ${Loan_Currency}
    Verify Borrower Interest Remittance Status    ${Interest}    ${Loan_Currency}
    Verify Borrower Fee Remittance Status    ${FeeAmount}    ${Loan_Currency}  
    
Verify Borrower Principal Remittance Instruction
    [Documentation]    This keyword is used to validate remittance instructions of a Borrower with multiple transactions. 
    ...    This validation keyword is used for Paper Clip transactions.
    ...    @author: rtarayao
    [Arguments]    ${Principal}    ${Loan_Currency}    ${Remittance_Description}      
    ${Principal}    Convert Number With Comma Separators    ${Principal}
    ${UIPrincipalMethod}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${Principal}${SPACE}${Loan_Currency}%Method%test
    Log To Console    ${UIPrincipalMethod}     
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIPrincipalMethod}    NONE
    Run Keyword If    ${status}==True    Add Borrower Principal Remittance Instructions    ${Principal}    ${Loan_Currency}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIPrincipalMethod}    DDA
    Run Keyword If    ${status}==True    Add Borrower Principal Remittance Instructions    ${Principal}    ${Loan_Currency}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIPrincipalMethod}    IMT
    Run Keyword If    ${status}==True    Add Borrower Principal Remittance Instructions    ${Principal}    ${Loan_Currency}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions

Add Borrower Principal Remittance Instructions  
    [Documentation]    This keyword is used to add a borrower's principal remittance instruction thru the Cashflow window.
    ...    @author: rtarayao
    [Arguments]    ${Principal}    ${Loan_Currency}    ${Remittance_Description}  
    Mx LoanIQ Click Javatree Cell    ${LIQ_Repayment_Cashflows_List}    ${Principal}${SPACE}${Loan_Currency}%${Principal}${SPACE}${Loan_Currency}%Original Amount/CCY 
    Mx Native Type    {ENTER}
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_SelectRI_Button}  
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_ChooseRemittance_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_Cashflows_ChooseRemittance_List}    ${Remittance_Description}%s 
    mx LoanIQ click    ${LIQ_Payment_Cashflows_ChooseRemittance_OK_Button}
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_OK_Button}

Verify Borrower Interest Remittance Instruction
    [Documentation]    This keyword is used to validate interest remittance instructions of a Borrower with multiple transactions. 
    ...    This validation keyword is used for Paper Clip transactions.
    ...    @author: rtarayao
    [Arguments]    ${Interest}    ${Loan_Currency}    ${Remittance_Description}     
    ${Interest}    Convert Number With Comma Separators    ${Interest}
    ${UIInterestMethod}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${Interest}${SPACE}${Loan_Currency}%Method%test
    Log To Console    ${UIInterestMethod}     
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIInterestMethod}    NONE
    Run Keyword If    ${status}==True    Add Borrower Interest Remittance Instructions    ${Interest}    ${Loan_Currency}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIInterestMethod}    DDA
    Run Keyword If    ${status}==True    Add Borrower Interest Remittance Instructions    ${Interest}    ${Loan_Currency}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIInterestMethod}    IMT
    Run Keyword If    ${status}==True    Add Borrower Interest Remittance Instructions    ${Interest}    ${Loan_Currency}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions

Add Borrower Interest Remittance Instructions  
    [Documentation]    This keyword is used to add a borrower's interest remittance instruction thru the Cashflow window.
    ...    @author: rtarayao
    [Arguments]    ${Interest}    ${Loan_Currency}    ${Remittance_Description}  
    Mx LoanIQ Click Javatree Cell    ${LIQ_Repayment_Cashflows_List}    ${Interest}${SPACE}${Loan_Currency}%${Interest}${SPACE}${Loan_Currency}%Original Amount/CCY 
    Mx Native Type    {ENTER}
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_SelectRI_Button}  
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_ChooseRemittance_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_Cashflows_ChooseRemittance_List}    ${Remittance_Description}%s 
    mx LoanIQ click    ${LIQ_Payment_Cashflows_ChooseRemittance_OK_Button}
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_OK_Button}

Verify Borrower Fee Remittance Instruction
    [Documentation]    This keyword is used to validate interest remittance instructions of a Borrower with multiple transactions. 
    ...    This validation keyword is used for Paper Clip transactions.
    ...    @author: rtarayao
    [Arguments]    ${FeeAmount}    ${Loan_Currency}    ${Remittance_Description}    
    ${FeeAmount}    Convert Number With Comma Separators    ${FeeAmount}
    ${UIFeeMethod}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${FeeAmount}${SPACE}${Loan_Currency}%Method%test
    Log To Console    ${UIFeeMethod}     
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIFeeMethod}    NONE
    Run Keyword If    ${status}==True    Add Borrower Fee Remittance Instructions    ${FeeAmount}    ${Loan_Currency}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIFeeMethod}    DDA
    Run Keyword If    ${status}==True    Add Borrower Fee Remittance Instructions    ${FeeAmount}    ${Loan_Currency}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIFeeMethod}    IMT
    Run Keyword If    ${status}==True    Add Borrower Fee Remittance Instructions    ${FeeAmount}    ${Loan_Currency}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions

Add Borrower Fee Remittance Instructions  
    [Documentation]    This keyword is used to add a borrower's interest remittance instruction thru the Cashflow window.
    ...    @author: rtarayao
    [Arguments]    ${FeeAmount}    ${Loan_Currency}    ${Remittance_Description}  
    Mx LoanIQ Click Javatree Cell    ${LIQ_Repayment_Cashflows_List}    ${FeeAmount}${SPACE}${Loan_Currency}%${FeeAmount}${SPACE}${Loan_Currency}%Original Amount/CCY
    Mx Native Type    {ENTER}
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_SelectRI_Button}  
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_ChooseRemittance_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_Cashflows_ChooseRemittance_List}    ${Remittance_Description}%s 
    mx LoanIQ click    ${LIQ_Payment_Cashflows_ChooseRemittance_OK_Button}
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_OK_Button}

Verify Borrower Principal Remittance Status
    [Documentation]    This keyword is used to validate the Repayment Cashflow Remittance Status of the Paper Clip Principal.
    ...    @author: rtarayao
    [Arguments]    ${Principal}    ${Loan_Currency}
    ${Principal}    Convert Number With Comma Separators    ${Principal}
    ${UIBorrowerPrinRemittanceStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${Principal}${SPACE}${Loan_Currency}%Status%test
    Log To Console    ${UIBorrowerPrinRemittanceStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIBorrowerPrinRemittanceStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Click Javatree Cell    ${LIQ_Repayment_Cashflows_List}    ${Principal}${SPACE}${Loan_Currency}%${Principal}${SPACE}${Loan_Currency}%Original Amount/CCY  
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Repayment_Cashflows_SetToDoIt_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete
    
Verify Borrower Interest Remittance Status
    [Documentation]    This keyword is used to validate the Repayment Cashflow Remittance Status of the Paper Clip Interest.
    ...    @author: rtarayao
    [Arguments]    ${Interest}    ${Loan_Currency}
    ${Interest}    Convert Number With Comma Separators    ${Interest}
    ${UIBorrowerIntRemittanceStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${Interest}${SPACE}${Loan_Currency}%Status%test
    Log To Console    ${UIBorrowerIntRemittanceStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIBorrowerIntRemittanceStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Click Javatree Cell    ${LIQ_Repayment_Cashflows_List}    ${Interest}${SPACE}${Loan_Currency}%${Interest}${SPACE}${Loan_Currency}%Original Amount/CCY   
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Repayment_Cashflows_SetToDoIt_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete  

Verify Borrower Fee Remittance Status
    [Documentation]    This keyword is used to validate the Repayment Cashflow Remittance Status of the Paper Clip Interest.
    ...    @author: rtarayao
    [Arguments]    ${FeeAmount}    ${Loan_Currency} 
    ${FeeAmount}    Convert Number With Comma Separators    ${FeeAmount}
    ${UIBorrowerFeeRemittanceStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${FeeAmount}${SPACE}${Loan_Currency}%Status%test
    Log To Console    ${UIBorrowerFeeRemittanceStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIBorrowerFeeRemittanceStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Click Javatree Cell    ${LIQ_Repayment_Cashflows_List}    ${FeeAmount}${SPACE}${Loan_Currency}%${FeeAmount}${SPACE}${Loan_Currency}%Original Amount/CCY  
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Repayment_Cashflows_SetToDoIt_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete 

Get Borrower Principal Transaction Amount
    [Documentation]    This keyword is used to get the borrower's principal transaction amount from Cashflows window.
    ...    @author: rtarayao
    [Arguments]    ${Principal}    ${Loan_Currency}       
    ${BorrowerPrinTranAmount}    Convert Number With Comma Separators    ${Principal}                       
    ${UIBorrowerPrinTranAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${BorrowerPrinTranAmount}${SPACE}${Loan_Currency}%Tran Amount%test
    ${UIBorrowerPrinTranAmount}    Remove String    ${UIBorrowerPrinTranAmount}    ,
    ${UIBorrowerPrinTranAmount}    Convert To Number    ${UIBorrowerPrinTranAmount}    2
    Log    ${UIBorrowerPrinTranAmount}        
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${Principal}    ${UIBorrowerPrinTranAmount} 
    Run Keyword If    '${status}'=='True'    Log    ${UIBorrowerPrinTranAmount} = Cashflow amount is correct.
    ...    ELSE IF    '${status}'=='False'    Log    ${UIBorrowerPrinTranAmount} = Cashflow amount is incorrect.  
    [Return]    ${UIBorrowerPrinTranAmount}

Get Borrower Interest Transaction Amount
    [Documentation]    This keyword is used to get the borrower's interest transaction amount from Cashflows window.
    ...    @author: rtarayao
    [Arguments]    ${Interest}    ${Loan_Currency}           
    ${BorrowerIntTranAmount}    Convert Number With Comma Separators    ${Interest}                       
    ${UIBorrowerIntTranAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${BorrowerIntTranAmount}${SPACE}${Loan_Currency}%Tran Amount%test
    ${UIBorrowerIntTranAmount}    Remove String    ${UIBorrowerIntTranAmount}    ,
    ${UIBorrowerIntTranAmount}    Convert To Number    ${UIBorrowerIntTranAmount}    2
    Log    ${UIBorrowerIntTranAmount}        
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${Interest}    ${UIBorrowerIntTranAmount} 
    Run Keyword If    '${status}'=='True'    Log    ${UIBorrowerIntTranAmount} = Cashflow amount is correct.
    ...    ELSE IF    '${status}'=='False'    Log    ${UIBorrowerIntTranAmount} = Cashflow amount is incorrect.  
    [Return]    ${UIBorrowerIntTranAmount}

Get Borrower Fee Transaction Amount
    [Documentation]    This keyword is used to get the borrower's interest transaction amount from Cashflows window.
    ...    @author: rtarayao
    [Arguments]    ${FeeAmount}    ${Loan_Currency}      
    ${BorrowerFeeTranAmount}    Convert Number With Comma Separators    ${FeeAmount}                       
    ${UIBorrowerFeeTranAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${BorrowerFeeTranAmount}${SPACE}${Loan_Currency}%Tran Amount%test
    ${UIBorrowerFeeTranAmount}    Remove String    ${UIBorrowerFeeTranAmount}    ,
    ${UIBorrowerFeeTranAmount}    Convert To Number    ${UIBorrowerFeeTranAmount}    2
    Log    ${UIBorrowerFeeTranAmount}        
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${FeeAmount}    ${UIBorrowerFeeTranAmount} 
    Run Keyword If    '${status}'=='True'    Log    ${UIBorrowerFeeTranAmount} = Cashflow amount is correct.
    ...    ELSE IF    '${status}'=='False'    Log    ${UIBorrowerFeeTranAmount} = Cashflow amount is incorrect.  
    [Return]    ${UIBorrowerFeeTranAmount}

Get Borrower Interest Debit Amount
    [Documentation]    This keyword is used to get interest debit amount for Borrower in GL Entries.
    ...    @author: rtarayao
    [Arguments]    ${Interest}
    Log    ${Interest}
    ${BorrowerIntTranAmount}    Convert Number With Comma Separators    ${Interest}    
    Mx LoanIQ Click Javatree Cell    ${LIQ_GLEntries_Javatree}    ${BorrowerIntTranAmount}%${BorrowerIntTranAmount}%Credit Amt
    ${BorrowerIntTranAmount}    Remove String    ${BorrowerIntTranAmount}    ,
    ${BorrowerIntTranAmount}    Convert To Number    ${BorrowerIntTranAmount}    2   
    [Return]    ${BorrowerIntTranAmount}  

Get Borrower Principal Debit Amount
    [Documentation]    This keyword is used to get principal debit amount for Borrower in GL Entries.
    ...    @author: rtarayao
    [Arguments]    ${Principal}
    Log    ${Principal}
    ${BorrowerPrinTranAmount}    Convert Number With Comma Separators    ${Principal}    
    Mx LoanIQ Click Javatree Cell    ${LIQ_GLEntries_Javatree}    ${BorrowerPrinTranAmount}%${BorrowerPrinTranAmount}%Credit Amt
    ${BorrowerPrinTranAmount}    Remove String    ${BorrowerPrinTranAmount}    ,
    ${BorrowerPrinTranAmount}    Convert To Number    ${BorrowerPrinTranAmount}    2   
    [Return]    ${BorrowerPrinTranAmount}   

Get Borrower Fee Debit Amount
    [Documentation]    This keyword is used to get fee debit amount for Borrower in GL Entries.
    ...    @author: rtarayao
    [Arguments]    ${FeeAmount}
    Log    ${FeeAmount}
    ${BorrowerFeeTranAmount}    Convert Number With Comma Separators    ${FeeAmount}    
    Mx LoanIQ Click Javatree Cell    ${LIQ_GLEntries_Javatree}    ${BorrowerFeeTranAmount}%${BorrowerFeeTranAmount}%Credit Amt
    ${BorrowerFeeTranAmount}    Remove String    ${BorrowerFeeTranAmount}    ,
    ${BorrowerFeeTranAmount}    Convert To Number    ${BorrowerFeeTranAmount}    2   
    [Return]    ${BorrowerFeeTranAmount}  
      
Validate if Outstanding Amount has decreased after Paper Clip - Bilateral
    [Documentation]    This keyword checks the Geneal Tab if Outstanding Amount was decreased.
    ...    This is only applicable for Bilateral deal.
    ...    @author: fmamaril/rtarayao
    ...    @update: dahijara    07JUL2020    - add pre-processing keyword and keyword for screenshot.
    [Arguments]    ${sPrincipal}
    ### GetRuntime Keyword Pre-processing ###
    ${Principal}    Acquire Argument Value    ${sPrincipal}
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${sGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Field}    GlobalOriginal
    ${GlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Field}    GlobalCurrent
    ${HostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Field}    HostBankGross
    ${sHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Field}    HostBankNet
    ${GlobalOriginal}    Remove String    ${sGlobalOriginal}    ,
    ${GlobalCurrent}    Remove String    ${GlobalCurrent}    ,
    ${HostBankGross}    Remove String    ${HostBankGross}    ,
    ${HostBankNet}    Remove String    ${sHostBankNet}    ,
    ${Principal}    Remove String    ${Principal}    ,    
    ${GlobalOriginal}    Convert To Number    ${GlobalOriginal}
    ${GlobalCurrent}    Convert To Number    ${GlobalCurrent} 
    ${HostBankGross}    Convert To Number    ${HostBankGross} 
    ${HostBankNet}    Convert To Number    ${HostBankNet}
    ${Principal}    Convert To Number    ${Principal}
    ${NewGlobalPrincipalAmount}    Evaluate     ${GlobalOriginal} - ${Principal}
    Should Be Equal As Numbers    ${NewGlobalPrincipalAmount}    ${GlobalCurrent}
    Should Be Equal As Numbers    ${NewGlobalPrincipalAmount}    ${HostBankGross}
    Should Be Equal As Numbers    ${NewGlobalPrincipalAmount}    ${HostBankNet}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanWindow

Validate Principal Payment for Term Facility on Oustanding Window after Paper Clip - Bilateral
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    This only handles Bilateral deal with one drawdown.
    ...    @author: rtarayao
    [Arguments]    ${Borrower_Name}    ${Principal}    ${Facility_ProposedCmt}    ${GlobalOriginal}
    ${NewGlobalOustandings}    Evaluate    ${GlobalOriginal} - ${Principal}
    ${sOutstandings}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Outstandings%sOutstandings
    ${sOutstandings}    Remove String    ${sOutstandings}    ,    
    ${nOutstandings}    Convert To Number    ${sOutstandings}
    Should Be Equal As Numbers    ${NewGlobalOustandings}    ${nOutstandings}
    ${sAvailable}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Available%sAvailable
    ${sAvailable}    Remove String    ${sAvailable}    ,    
    ${sAvailable}    Convert To Number    ${sAvailable}
    ${Facility_ProposedCmt}    Remove String    ${Facility_ProposedCmt}    ,    
    ${Facility_ProposedCmt}    Convert To Number    ${Facility_ProposedCmt}
    ${ComputedAvailableLoan}    Evaluate     ${Facility_ProposedCmt} - ${GlobalOriginal}
    Should Be Equal As Numbers    ${ComputedAvailableLoan}    ${sAvailable}

Validate Principal Payment for Revolver Facility on Oustanding Window after Paper Clip - Bilateral
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    This only handles Bilateral deal with one drawdown.
    ...    @author: fmamaril
    [Arguments]    ${Borrower_Name}    ${NewPrincipalAmount}    ${Facility_ProposedCmt}    ${GlobalOriginal}    ${ActualAmount}
    ${sOutstandings}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Outstandings%sOutstandings
    ${sOutstandings}    Remove String    ${sOutstandings}    ,    
    ${nOutstandings}    Convert To Number    ${sOutstandings}
    Should Be Equal    ${NewPrincipalAmount}    ${nOutstandings}
    ${sAvailable}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Available%sAvailable
    ${sAvailable}    Remove String    ${sAvailable}    ,    
    ${sAvailable}    Convert To Number    ${sAvailable}
    ${Facility_ProposedCmt}    Remove String    ${Facility_ProposedCmt}    ,    
    ${Facility_ProposedCmt}    Convert To Number    ${Facility_ProposedCmt}
    ${ComputedAvailableLoan}    Evaluate     (${Facility_ProposedCmt} - ${GlobalOriginal}) + ${ActualAmount}
    Should Be Equal    ${ComputedAvailableLoan}    ${sAvailable}                                                                                   
    
##############COMPUTATION Scenario 6#####################
Compute Principal Payment Amount
    [Documentation]    This keyword computes the Paper Clip first cycle's principal.  
    ...    @author: rtarayao
    ...    @update: rtarayao    21MAR2019    Updated keyword used for number conversion.
    ...    @update: dahijara    07JUL2020    - added pre and post processing keywords
    [Arguments]    ${sInterest}    ${sRepayment_FirstPaymentAmount}    ${sRunVar_Computed_PrincipalAmount}=None
    ### GetRuntime Keyword Pre-processing ###
    ${Interest}    Acquire Argument Value    ${sInterest}
    ${Repayment_FirstPaymentAmount}    Acquire Argument Value    ${sRepayment_FirstPaymentAmount}
    ${sRepayment_FirstPaymentAmount}    Evaluate    "%.2f" % ${Repayment_FirstPaymentAmount}
    ${sComputed_PrincipalAmount}    Evaluate    ${sRepayment_FirstPaymentAmount} - ${Interest} 
    Log    ${sComputed_PrincipalAmount}
    ${sComputed_PrincipalAmount}    Evaluate    "%.2f" % ${sComputed_PrincipalAmount}
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Computed_PrincipalAmount}    ${sComputed_PrincipalAmount}
    [Return]    ${sComputed_PrincipalAmount}        

Validate Interest and Principal Payments on Loan Events Tab
    [Documentation]    This keyword validates the Interest and Principal Repayment transaction in Loan Events Tab.
    ...    @author: rtarayao
    ...    @update: rtarayao    04APR2019    Comma separator keyword for number is omitted.
    ...    @update: dahijra    07JUL2020    - added pre-processing keyword and screenshot.
    [Arguments]    ${sRepaymentInterest}    ${sRepaymentPrincipal}    ${sPaymentDueDate}
    ### GetRuntime Keyword Pre-processing ###
    ${RepaymentInterest}    Acquire Argument Value    ${sRepaymentInterest}
    ${RepaymentPrincipal}    Acquire Argument Value    ${sRepaymentPrincipal}
    ${PaymentDueDate}    Acquire Argument Value    ${sPaymentDueDate}
    mx LoanIQ activate window    ${LIQ_Loan_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events  
    ${Comment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_Events_List}    Interest Payment Released%Comment%test     
    Should Be Equal    ${Comment}    Fixed Rate Option Scheduled Interest Payment of ${RepaymentInterest} has been applied. (Item due on ${PaymentDueDate})
    ${Comment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_Events_List}    Principal Payment Applied%Comment%test     
    Should Be Equal    ${Comment}    Scheduled Principal Payment of ${RepaymentPrincipal} was applied to the outstanding. Commitment amount decreased. (Item due on ${PaymentDueDate})          
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_Events

Get Principal Repayment Details
    [Documentation]    This keyword gets the Principal repayment details for a Paper Clip payment.
    ...    @author: rtarayao
    [Arguments]    ${RepaymentInterest}    ${Loan_CalculatedFixedPayment}
    ${Repayment_PrincipalDue}    Evaluate    ${Loan_CalculatedFixedPayment} - ${RepaymentInterest} 
    ${UIPrincipal_RequestedAmount}    Mx LoanIQ Get Data    ${LIQ_Payment_PrincipalRequestedAmt_Textfield}    value
    ${UIPrincipal_RequestedAmount}    Remove String    ${UIPrincipal_RequestedAmount}    ,
    ${UIPrincipal_RequestedAmount}    Convert To Number    ${UIPrincipal_RequestedAmount}    2
    ${UIPrincipal_RequestedAmount}    Evaluate    "%.2f" % ${UIPrincipal_RequestedAmount}    
    Should Be Equal    ${Repayment_PrincipalDue}    ${UIPrincipal_RequestedAmount}         
    Log    ${UIPrincipal_RequestedAmount} - Principal Requested amount in UI.
    Log    ${Repayment_PrincipalDue} - Computed Current Cycle Principal Due      
    Mx LoanIQ Close    ${LIQ_Payment_Window}
    
    [Return]    ${UIPrincipal_RequestedAmount}        

Navigate to Scheduled Interest Payment Notebook from Loan Notebook
    [Documentation]    This keyword navigates the LIQ User to Scheduled Interest Payment Notebook from Loan Notebook after Paper Clip Payment.
    ...    @author: rtarayao 
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events    
    Mx LoanIQ Select String    ${LIQ_Loan_Events_List}    Interest Payment Released    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Loan_Events_List}    Interest Payment Released%d
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    
    
Validate Fee, Interest and Principal Payments on Repayment
    [Documentation]    This keyword validates the Fee, Interest, and Principal Repayment transaction in Loan Events Tab.
    ...    @author: rtarayao 
    ...    @update: dahijra    07JUL2020    - added pre-processing keyword and screenshot.    
    [Arguments]    ${sFeeAmount}    ${sLoan_Currency}    ${sLoan_PricingOption}
    ### GetRuntime Keyword Pre-processing ###
    ${FeeAmount}    Acquire Argument Value    ${sFeeAmount}
    ${Loan_Currency}    Acquire Argument Value    ${sLoan_Currency}
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
    mx LoanIQ activate window    ${LIQ_Payment_Window}    
    mx LoanIQ select    ${LIQ_Payment_Options_PaperClipNotebook}
    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    mx LoanIQ close window    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_Transactions_JavaTree}    Arranger Fee Fee%d
    mx LoanIQ activate window    ${LIQ_Fee_ArrangerFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_EventFee_Javatab}    Events
    ${Comment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_EventFee_Events_JavaTree}    Payment Released%Comment%test     
    Should Be Equal    ${Comment}    Payment for ${Loan_Currency} ${FeeAmount} released.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/EventFee_Events
    mx LoanIQ close window    ${LIQ_Fee_ArrangerFee_Window} 
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_Transactions_JavaTree}    ${Loan_PricingOption}${SPACE}Scheduled Interest Payment%d
    mx LoanIQ activate window    ${LIQ_Payment_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Payment_Events_JavaTree}    Released
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Payments_Events     
    mx LoanIQ close window    ${LIQ_Payment_Window}   
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_Transactions_JavaTree}    ${Loan_PricingOption}${SPACE}Scheduled Principal Payment%d
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Payment_Events_JavaTree}    released
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Payments_Events
    mx LoanIQ close window    ${LIQ_Payment_Window}
    
Create Pending Transaction for Payment Flex Schedule
    [Documentation]    This keywod creates a pending transaction for Repayment Schedule.
    ...    @author: fmamaril
    ...    @update: rtarayao - changed locators to handle  
    ...    @update: dahijara    10JUL2020    - added pre & post processing keywords; Optional arguments for runtime var; screenshot; Removed unnecessary commented codes
    ...                                      - updated locator for Repayment Schedule java tree.
    ...    @update: dahijara    16JUL2020    - Fix warnings; Multiple variables assigned to the keyword
    [Arguments]    ${sFee_Cycle}    ${sEffective_Date}    ${sRunVar_ScheduledPrincipalPayment_Amount}=None
    ### GetRuntime Keyword Pre-processing ###
    ${Fee_Cycle}    Acquire Argument Value    ${sFee_Cycle}
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}

    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}    
    Mx LoanIQ Click Javatree Cell    ${LIQ_RepaymentSchedule_CurrentSchedule_Javatree}    ${Fee_Cycle}%Item
    mx LoanIQ click    ${LIQ_RepaymentSchedule_CreatePending_Button} 
    Mx LoanIQ Click Button On Window    Commitment Schedule.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_Loan_ChoosePayment_Window}
    mx LoanIQ click    ${LIQ_Loan_ChoosePayment_OK_Button}                         
    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}
    ${ScheduledPrincipalPayment_Amount}    Mx LoanIQ Get Data    ${LIQ_ScheduledPrincipalPayment_RequestedAmount_Field}    value%Amount    
    mx LoanIQ enter    ${LIQ_ScheduledPrincipalPayment_EffectiveDate_Field}    ${Effective_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledPrincipalPayment
    mx LoanIQ select    ${LIQ_ScheduledPrincipalPayment_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}    
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_ScheduledPrincipalPayment_Amount}    ${ScheduledPrincipalPayment_Amount}    
    [Return]    ${ScheduledPrincipalPayment_Amount}    
            
Verify if Status is set to Do It - Repayment
    [Documentation]    This keyword is used to validate the breakfunding Cashflow Status
    ...    @author: fmamaril
    [Arguments]    ${LIQCustomer_ShortName}
     ${CashflowStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Repayment_Cashflows_List}    ${LIQCustomer_ShortName}%Status%MStatus_Variable
    Log To Console    ${CashflowStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_Cashflows_List}    ${LIQCustomer_ShortName}%s   
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Repayment_Cashflows_SetToDoIt_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete
    mx LoanIQ click element if present     ${LIQ_Repayment_Cashflows_DetailsforCashflow_OK_Button}  
        
Add Remittance Instructions - Repayment
    [Documentation]    This keyword is used to select remittance instruction thru the Cashflow window for breakfunding.
    ...    @author: fmamaril
    [Arguments]    ${LIQCustomer_ShortName}    ${Remittance_Description}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_Cashflows_List}    ${LIQCustomer_ShortName}%d
    mx LoanIQ activate window    ${LIQ_Repayment_Cashflows_DetailsforCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Repayment_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Repayment_Cashflows_DetailsforCashflow_SelectRI_Button}  
    mx LoanIQ activate window    ${LIQ_Repayment_Cashflows_ChooseRemittance_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_Cashflows_ChooseRemittance_List}    ${Remittance_Description}%s 
    mx LoanIQ click    ${LIQ_Repayment_Cashflows_ChooseRemittance_OK_Button}
    mx LoanIQ click    ${LIQ_Repayment_Cashflows_DetailsforCashflow_OK_Button}    

Verify Borrower Remittance Instruction - Repayment
    [Documentation]    This keyword is used to validate remittance instructions. 
    ...    @author: fmamaril
    [Arguments]    ${Borrower_ShortName}    ${Remittance_Description}
    ${UIBorrowerMethod}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${Borrower_ShortName}%Method%test
    Log To Console    ${UIBorrowerMethod}     
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIBorrowerMethod}    NONE
    Run Keyword If    ${status}==True    Add Remittance Instructions - Repayment    ${Borrower_ShortName}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIBorrowerMethod}    DDA
    Run Keyword If    ${status}==True    Add Remittance Instructions - Repayment    ${Borrower_ShortName}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UIBorrowerMethod}    IMT
    Run Keyword If    ${status}==True    Add Remittance Instructions - Repayment    ${Borrower_ShortName}    ${Remittance_Description}
    ...    ELSE    Log    Method already has remittance instructions    
                
Send Principal Payment to Approval - Repayment
    [Documentation]    This keywod sends the scheduled principal payment to approval (repayment).
    ...    @author: fmamaril
    ...    @update: dahijara    16JUL2020    - Fix warnings; Multiple variables assigned to the keyword
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_WorkflowItems}    Send to Approval%d
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_MessageBox}      VerificationData="Yes"
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .*Repayment for.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .*Repayment for.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Awaiting Approval Repayment.*")                 VerificationData="Yes"
          
Release Scheduled Principal Payment - Repayment
    [Documentation]    This keyword releases the Ongoing Fee Payment from LIQ.
    ...    @author: fmamaril 
    ...    @author: rtarayao - updated the few steps on the script, disabled the closing of windows, window activation changed to repayment window from scheduled principal payment window.
    ...    @update: dahijara    16JUL2020    - Fix warnings; Multiple variables assigned to the keyword; removed commented out codes.

    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Repayment_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_WorkflowItems}    Release%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Ignore Error     Mx LoanIQ Click Button On Window    .*Repayment.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"	WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .*Repayment.*;Question;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"	WaitForProcessing=500
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Released Repayment.*")    VerificationData="Yes"
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .*Repayment.*;Informational Message;OK    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
        
Validate Repayment on GL Entries - Paper Clip Notebook
    [Documentation]    This keyword validates the GL Entries for Principal Payment.
    ...    @author: fmamaril
    [Arguments]    ${ScheduledPrincipalPayment_Amount}    ${Borrower_ShortName}    ${Host_Bank}
    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}
    mx LoanIQ select    ${LIQ_ScheduledPrincipalPayment_PaperClip_Menu}
    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    mx LoanIQ select    ${LIQ_Repayment_GLEntries_Menu}
    
    mx LoanIQ activate window    ${LIQ_Repayment_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_Repayment_GLEntries_Window}  
    # Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_Repayment_GLEntries_Table}    ${Borrower_ShortName}%s  
    ${DebitAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_GLEntries_Table}    ${Borrower_ShortName}%Debit Amt%test 
    # Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Repayment_GLEntries_Table}    ${Host_Bank}%s    
    ${CreditAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_GLEntries_Table}    ${Host_Bank}%Credit Amt%test
    
    Log    Debit Amount: ${DebitAmount}
    Log    Credit Amount: ${CreditAmount}
    ${DebitAmount}    Remove String    ${DebitAmount}    ,
    ${CreditAmount}    Remove String    ${CreditAmount}    , 
    ${ScheduledPrincipalPayment_Amount}    Remove String    ${ScheduledPrincipalPayment_Amount}    ,    
    ${DebitAmount}    Convert To Number    ${DebitAmount}
    ${CreditAmount}    Convert To Number    ${CreditAmount} 
    ${ScheduledPrincipalPayment_Amount}    Convert To Number    ${ScheduledPrincipalPayment_Amount}
    Set Global Variable    ${${ScheduledPrincipalPayment_Amount}}    
    # ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}                
    Should Be Equal As Strings    ${DebitAmount}    ${CreditAmount}
    Should Be Equal As Strings    ${DebitAmount}    ${ScheduledPrincipalPayment_Amount}
    Should Be Equal As Strings    ${CreditAmount}    ${ScheduledPrincipalPayment_Amount}        
    Mx LoanIQ Close    ${LIQ_Repayment_GLEntries_Window}   

Verify Lender Interest Remittance Status (Scenario 8)
    [Documentation]    This keyword is used to validate the Repayment Cashflow Remittance Status of the Paper Clip Interest.
    ...    @author: rtarayao
    ...    <update> @ghabal - created separate keyword since some the keywords from the original keyword has 'Read Excel Data' for Scenario 2. Has discussed this with @rtarayo
    [Arguments]    ${LenderSharePct}    ${Loan_Currency}    ${Loan_CalculatedFixedPayment}
    ${LenderIntTranAmount}    Compute Lender Interest Transaction Amount (Scenario 8)    ${LenderSharePct}    ${Loan_CalculatedFixedPayment}
    ${LenderIntTranAmount}    Convert Number With Comma Separators    ${LenderIntTranAmount}
    ${UILenderIntRemittanceStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${LenderIntTranAmount}${SPACE}${Loan_Currency}%Status%test
    Log To Console    ${UILenderIntRemittanceStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UILenderIntRemittanceStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Click Javatree Cell    ${LIQ_Repayment_Cashflows_List}    ${LenderIntTranAmount}${SPACE}${Loan_Currency}%${LenderIntTranAmount}${SPACE}${Loan_Currency}%Tran Amount   
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Repayment_Cashflows_SetToDoIt_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete

Get Lender Interest Released Remittance Status (Scenario 8)
    [Documentation]    This keyword gets the Interest Remittance Status of a Lender on a Paper Clip transaction.
    ...    @author: rtarayao
    [Arguments]    ${LenderSharePct}    ${Loan_Currency}    ${Computed_LoanIntProjectedCycleDue}
    ${LenderIntTranAmount}    Compute Lender Interest Transaction Amount (Scenario 8)    ${LenderSharePct}    ${Computed_LoanIntProjectedCycleDue}
    ${LenderIntTranAmount}    Convert Number With Comma Separators    ${LenderIntTranAmount}
    ${UILenderIntRemittanceStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${LenderIntTranAmount}${SPACE}${Loan_Currency}%Status%test
    Log To Console    ${UILenderIntRemittanceStatus} 
    [Return]    ${UILenderIntRemittanceStatus}   

Verify Lender Interest Remittance Instruction (Scenario 8)
    [Documentation]    This keyword is used to validate remittance instructions. 
    ...    @author: rtarayao
    ...    <update> @ghabal - created separate keyword since some the keywords from the original keyword has 'Read Excel Data' for Scenario 2. Has discussed this with @rtarayo
    [Arguments]    ${LenderSharePct}    ${Remittance_Description}    ${Loan_Currency}    ${Lender_ShareAmount2}    
    ${LenderIntTranAmount}    Compute Lender Interest Transaction Amount (Scenario 8)    ${LenderSharePct}    ${Lender_ShareAmount2}
    ${LenderIntTranAmount}    Convert Number With Comma Separators    ${LenderIntTranAmount}
    ${UILenderMethod}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Cashflows_List}    ${LenderIntTranAmount}${SPACE}${Loan_Currency}%Method%test
    Log To Console    ${UILenderMethod}     
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UILenderMethod}    NONE
    Run Keyword If    ${status}==True    Add Lender Interest Remittance Instructions (Scenario 8)    ${LenderSharePct}    ${Remittance_Description}    ${Lender_ShareAmount2}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UILenderMethod}    DDA
    Run Keyword If    ${status}==True    Add Lender Interest Remittance Instructions (Scenario 8)    ${LenderSharePct}    ${Remittance_Description}    ${Lender_ShareAmount2}
    ...    ELSE    Log    Method already has remittance instructions
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${UILenderMethod}    IMT
    Run Keyword If    ${status}==True    Add Lender Interest Remittance Instructions (Scenario 8)    ${LenderSharePct}    ${Remittance_Description}    ${Lender_ShareAmount2}
    ...    ELSE    Log    Method already has remittance instructions

Add Lender Interest Remittance Instructions (Scenario 8)  
    [Documentation]    This keyword is used to add a lender's interest remittance instruction thru the Cashflow window.
    ...    @author: rtarayao
    ...    <update> @ghabal - created separate keyword since some the keywords from the original keyword has 'Read Excel Data' for Scenario 2. Has discussed this with @rtarayo
    [Arguments]    ${LenderSharePct}    ${Remittance_Description}    ${Loan_CalculatedFixedPayment}       
    ${LenderIntTranAmount}    Compute Lender Interest Transaction Amount (Scenario 8)    ${LenderSharePct}    ${Loan_CalculatedFixedPayment}
    ${LenderIntTranAmount}    Convert Number With Comma Separators    ${LenderIntTranAmount}
    Mx LoanIQ Click Javatree Cell    ${LIQ_Repayment_Cashflows_List}    ${LenderIntTranAmount}%${LenderIntTranAmount}%Tran Amount 
    Mx Native Type    {ENTER}
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_SelectRI_Button}  
    mx LoanIQ activate    ${LIQ_Payment_Cashflows_ChooseRemittance_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_Cashflows_ChooseRemittance_List}    ${Remittance_Description}%s 
    mx LoanIQ click    ${LIQ_Payment_Cashflows_ChooseRemittance_OK_Button}
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_OK_Button}  

Compute Lender Interest Transaction Amount (Scenario 8)
    [Documentation]    This keyword is used to compute the lender's interest transaction amount.
    ...    @author: rtarayao
    ...    <update> @ghabal - created separate keyword since some the keywords from the original keyword has 'Read Excel Data' for Scenario 2. Has discussed this with @rtarayo    
    [Arguments]    ${LenderSharePct}    ${Computed_LoanIntProjectedCycleDue}
    ${LenderSharePct}    Evaluate    ${LenderSharePct}/100
    ${LenderIntTranAmount}    Evaluate    ${Computed_LoanIntProjectedCycleDue}*${LenderSharePct}
    ${LenderIntTranAmount}    Convert To Number    ${LenderIntTranAmount}    
    ${LenderIntTranAmount}    Evaluate    "%.2f" % ${LenderIntTranAmount}     
    Log    ${LenderIntTranAmount}
    [Return]    ${LenderIntTranAmount}

Navigate to Payment Workflow Tab (Scenario 8)
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    @author: rtarayao
    ...    <update> @ghabal - updated keyword to accomodate new locators for Interest Payment window    
    mx LoanIQ activate window    ${LIQ_InterestPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InterestPayment_Tab}    Workflow 

Evaluate Fee Payment Amount with VAT Inclusion
    [Documentation]    This keyword computes the taxed amount for the Fee payment. 
    ...    This keyword also returns two values, the tax amount and the Fee Amount after tax.
    ...    @author: rtarayao    27MAR2019    Initial Create
    ...    @update: dahijara    07JUL2020    - added pre and post processing keywords. Added optional argument for run time variables.
    [Arguments]    ${sFeeAmount}    ${sVATPercentage}=0.1    ${sRunVar_TaxedFeeAmt}=None    ${sRunVar_VATAmt}=None
    ### GetRuntime Keyword Pre-processing ###
    ${FeeAmount}    Acquire Argument Value    ${sFeeAmount}
    ${VATPercentage}    Acquire Argument Value    ${sVATPercentage}
    ${sVATAmt}    Evaluate    ${sFeeAmount}*${sVATPercentage}
    ${sVATAmt}    Evaluate    "%.2f" % ${sVATAmt}
    ${sTaxedFeeAmt}    Evaluate    ${sFeeAmount}+${sVATAmt} 
    ${sTaxedFeeAmt}    Evaluate    "%.2f" % ${sTaxedFeeAmt}
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_TaxedFeeAmt}    ${sTaxedFeeAmt}
    Save Values of Runtime Execution on Excel File    ${sRunVar_VATAmt}    ${sVATAmt}    
    [Return]    ${sTaxedFeeAmt}    ${sVATAmt}  

Compute Paper Clip Total Amount with VAT Inclusion for Fee
    [Documentation]    This keyword computes the taxed amount for the Fee payment. 
    ...    This keyword also returns two values, the tax amount and the Fee Amount after tax.
    ...    @author: rtarayao    27MAR2019    Initial Create
    ...    @update: dahijara    07JUL2020    - added pre and post processing keywords. Added optional argument for run time variables.
    [Arguments]    ${sPrincipalAmt}    ${sInterestAmt}    ${sTaxedFeeAmt}    ${sRunVar_TotalPaperClipAmt}=None
    ### GetRuntime Keyword Pre-processing ###
    ${PrincipalAmt}    Acquire Argument Value    ${sPrincipalAmt}
    ${InterestAmt}    Acquire Argument Value    ${sInterestAmt}
    ${TaxedFeeAmt}    Acquire Argument Value    ${sTaxedFeeAmt}            
    ${sTotalPaperClipAmt}    Evaluate    ${sPrincipalAmt}+${sInterestAmt}+${sTaxedFeeAmt}
    ${sTotalPaperClipAmt}    Evaluate    "%.2f" % ${sTotalPaperClipAmt}
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_TotalPaperClipAmt}    ${sTotalPaperClipAmt}    
    [Return]    ${sTotalPaperClipAmt}
    
Validate PaperClip Notebook Details for Interest and Principal Payment
    [Documentation]    This keyword will validate the Interest Amount, Principal Amount, Effective Date, and the Total Amount in the Repayment Paperclip Notebook.
    ...                @author: bernchua    09AUG2019    Initial create
    ...                @author: bernchua    21AUG2019    Added taking of screenshot
    [Arguments]    ${sInterest_Amount}    ${sPrincipal_Amount}    ${sEffective_Date}    ${sPricing_Option}    ${sTransaction_Type}
    mx LoanIQ activate    ${LIQ_Repayment_Window}
    
    ${InterestPayment_Desc}    Set Variable    ${sPricing_Option} ${sTransaction_Type} Interest Payment
    ${PrincipalPayment_Desc}    Set Variable    ${sPricing_Option} ${sTransaction_Type} Principal Payment
    ${UI_TotalAmount}    Mx LoanIQ Get Data    ${LIQ_Repayment_Amount}    value%totalamount
    ${UI_EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_Repayment_EffectiveDate_Textfield}    value%effectivedate
    ${UI_InterestAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Transactions_JavaTree}    ${InterestPayment_Desc}%Amount%interest
    ${UI_PrincipalAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Repayment_Transactions_JavaTree}    ${PrincipalPayment_Desc}%Amount%principal
    
    ${Converted_InterestAmt}    Remove Comma, Negative Character and Convert to Number    ${sInterest_Amount}
    ${Converted_PrincipalAmt}    Remove Comma, Negative Character and Convert to Number    ${sPrincipal_Amount}
    ${sPrincipal_Amount}    Remove String    ${sPrincipal_Amount}    -
    
    ${Computed_Amount}    Evaluate    ${Converted_InterestAmt}+${Converted_PrincipalAmt}
    ${Computed_Amount}    Convert To String    ${Computed_Amount}
    ${Computed_Amount}    Convert Number With Comma Separators    ${Computed_Amount}
    
    ${VALIDTE_TOTALAMOUNT}    Run Keyword And Return Status    Should Be Equal    ${UI_TotalAmount}    ${Computed_Amount}        
    ${VALIDATE_EFFECTIVEDATE}    Run Keyword And Return Status    Should Be Equal    ${UI_EffectiveDate}    ${sEffective_Date}
    ${VALIDATE_INTEREST}    Run Keyword And Return Status    Should Be Equal    ${UI_InterestAmount}    ${sInterest_Amount}
    ${VALIDATE_PRINCIPAL}    Run Keyword And Return Status    Should Be Equal    ${UI_PrincipalAmount}    ${sPrincipal_Amount}
    
    Run Keyword If    ${VALIDTE_TOTALAMOUNT}==True    Log    Total amount successfully verified.
    ...    ELSE    Fail    Total amount validation not successful.    
    Run Keyword If    ${VALIDATE_EFFECTIVEDATE}==True    Log    Effective date successfully verified.
    ...    ELSE    Fail    Effective date validation not successful.
    Run Keyword If    ${VALIDATE_INTEREST}==True    Log    Interest amount successfully verified.
    ...    ELSE    Fail    Interest amount validation not successful.
    Run Keyword If    ${VALIDATE_PRINCIPAL}==True    Log    Principal amount successfully verified.
    ...    ELSE    Fail    Principal amount validation not successful.
    
    Take Screenshot    RepaymentPaperclip-General
    
Validate Principal Payment Notebook Details
    [Documentation]    This keyword will open the Principal Payment transaction from the Paperclip notebook,
    ...                and will validate the details in the Principal Payment Notebook.
    ...                | Arguments |
    ...                ${sPrepayment_Status} = 0 or 1
    ...                                        1 if checkbox is enabled, 0 if disabled.
    ...                @author: bernchua    19AUG2019    Initial create
    ...                @author: bernchua    21AUG2019    Added taking of sceenshot
    [Arguments]    ${sRequested_Amount}    ${sPrepayment_Status}    ${sEffectiveDate}    ${sPricing_Option}    ${sTransaction_Type}
    mx LoanIQ activate window    ${LIQ_Repayment_Window}
    
    ${PrincipalPayment_Desc}    Set Variable    ${sPricing_Option} ${sTransaction_Type} Principal Payment
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Repayment_Transactions_JavaTree}    ${PrincipalPayment_Desc}%d
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    Run Keyword If    '${sPrepayment_Status}'=='1'    Mx LoanIQ Set    ${LIQ_PrincipalPayment_Prepayment_Checkbox}    ON
    ...    ELSE IF    '${sPrepayment_Status}'=='0'    Mx LoanIQ Set    ${LIQ_PrincipalPayment_Prepayment_Checkbox}    OFF
    
    ${UI_RequestedAmount}    Mx LoanIQ Get Data    ${LIQ_PrincipalPayment_Requested_Amount}    value%amount
    ${UI_EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_PrincipalPayment_EffectiveDate_Field}    value%amount
    ${UI_PrepaymentStatus}    Mx LoanIQ Get Data    ${LIQ_PrincipalPayment_Prepayment_Checkbox}    enabled%status
    
    ${VALIDATE_REQUESTEDAMOUNT}    Run Keyword And Return Status    Should Be Equal    ${UI_RequestedAmount}    ${sRequested_Amount}        
    ${VALIDATE_EFFECTIVEDATE}    Run Keyword And Return Status    Should Be Equal    ${UI_EffectiveDate}    ${sEffectiveDate}
    ${VALIDATE_PREPAYMENTSTATUS}    Run Keyword And Return Status    Should Be Equal    ${UI_PrepaymentStatus}    ${sPrepayment_Status}
    
    Run Keyword If    ${VALIDATE_REQUESTEDAMOUNT}==True    Log    Principal Payment Requested Amount successfully verified.
    ...    ELSE    Fail    Principal Payment Requested Amount validation not successful.
    Run Keyword If    ${VALIDATE_EFFECTIVEDATE}==True    Log    Principal Payment Effective Date successfully verified.
    ...    ELSE    Fail    Principal Payment Effective Date validation not successful.
    Run Keyword If    ${VALIDATE_PREPAYMENTSTATUS}==True    Log    Principal Payment Prepayment status successfully verified.
    ...    ELSE    Fail    Principal Payment Prepayment status validation not successful.
    
    Take Screenshot    PrincipalPaymentNotebook-General
    mx LoanIQ close window    ${LIQ_PrincipalPayment_Window}
    
        
