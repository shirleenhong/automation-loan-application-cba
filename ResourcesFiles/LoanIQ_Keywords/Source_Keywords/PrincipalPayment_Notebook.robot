*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Open Existing Loan
    [Documentation]    This keyword opens an existing loan on Existing Loan for Facility window.
    ...    @author: fmamaril
    ...    @update: hstone    28AUG2019    Added option to select existing loan using the current amount value
    ...    @update: fmamaril    03JUNE2020    Updated to align with automation standards and added keyword pre processing
    [Arguments]    ${sLoan_Alias}    ${sCurrrentAmt}=None
    
    ### Keyword Pre-processing ###
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}    ${ARG_TYPE_UNIQUE_NAME_VALUE}
    ${CurrrentAmt}    Acquire Argument Value    ${sCurrrentAmt}    ${ARG_TYPE_UNIQUE_NAME_VALUE}

    mx LoanIQ activate    ${LIQ_ExistingLoanForFacility_Window}
    mx LoanIQ enter    ${LIQ_ExistingLoanForFacility_Update_Checkbox}    ON
    mx LoanIQ enter    ${LIQ_ExistingLoanForFacility_RemainOpen_Checkbox }    OFF
    Run Keyword If    '${CurrrentAmt}'!='None'    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_ExistingLoanForFacility_Tree}    ${sCurrrentAmt}%d    
    ...    ELSE    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_ExistingLoanForFacility_Tree}    ${Loan_Alias}%d
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanWindow
    
Navigate from Loan to Repayment Schedule
    [Documentation]    This keyword creates/opens a Repayment Schedule in a Loan
    ...    @author: fmamaril
    ...    @update: bernchua    09AUG2019    Updated keyword documentation
    ...                                      Used generic keyword for clicking warning messages
    ...    @update: ehugo    01JUN2020    - added screenshot; removed sleep

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Wait Until Keyword Succeeds    5x    3s    mx LoanIQ select    ${LIQ_LoanNotebook_RepaymentSchedule_Menu}
    Verify If Warning Is Displayed       
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Run Keyword And Continue On Failure     Verify Window    ${LIQ_RepaymentSchedule_Window} 

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentScheduleWindow
    
Create Pending Transaction for Payment Schedule
    [Documentation]    This keywod creates a pending transaction for Repayment Schedule.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing and post-processing; added optional runtime argument; added screenshot
    ...    @update: dahijara    16JUL2020    - Fix warnings; Multiple variables assigned to the keyword
    [Arguments]    ${sFee_Cycle}    ${sLoanEffectiveDate}    ${sRunTimeVar_ActualAmount}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Fee_Cycle}    Acquire Argument Value    ${sFee_Cycle}
    ${LoanEffectiveDate}    Acquire Argument Value    ${sLoanEffectiveDate}

    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Click Javatree Cell    ${LIQ_RepaymentSchedule_CurrentSchedule_JavaTree}    ${Fee_Cycle}%Item
    mx LoanIQ click    ${LIQ_RepaymentSchedule_CreatePending_Button}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Schedule.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Schedule.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Schedule.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Verify Window    ${LIQ_ChoosePayment_Window}
    mx LoanIQ activate window    ${LIQ_ChoosePayment_Window}
    mx LoanIQ enter    ${LIQ_Payment_PrincipalPayment_RadioButton}    ON
    mx LoanIQ click    ${LIQ_Payment_OK_Button}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .*Payment.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}
    Run Keyword And Continue On Failure     Verify Window    ${LIQ_ScheduledPrincipalPayment_Window}
    mx LoanIQ enter    ${LIQ_ScheduledPrincipalPayment_EffectiveDate_Field}    ${LoanEffectiveDate}    
    ${OutstandingAmount}    Mx LoanIQ Get Data    ${LIQ_ScheduledPrincipalPayment_OutstandingAmount_Field}    OutstandingAmount              
    ${RequestedAmount}    Mx LoanIQ Get Data    ${LIQ_ScheduledPrincipalPayment_RequestedAmount_Field}    RequestedAmount
    ${ActualAmount}    Mx LoanIQ Get Data    ${LIQ_ScheduledPrincipalPayment_ActualAmount_Field}    ActualAmount

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledPrincipalPaymentWindow

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ActualAmount}    ${ActualAmount}

    [Return]    ${ActualAmount}
        
Send Scheduled Principal Payment to Approval
    [Documentation]    This keywod sends the scheduled principal payment to approval.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added screenshot
    ...    @update: dahijara    16JUL2020    - Fix warnings; Multiple variables assigned to the keyword
    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ScheduledPrincipalPayment_Workflow_JavaTree}    Send to Approval%d
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_MessageBox}      VerificationData="Yes"
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .*Scheduled Principal Payment.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .*Scheduled Principal Payment.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Scheduled Principal Payment.*Awaiting Approval.*")     VerificationData="Yes"

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledPrincipalPaymentWindow_WorkflowTab

Open Scheduled Principal Payment Notebook from Repayment Schedule
    [Documentation]    This keywod opens scheduled principal payment.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sFee_Cycle}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Fee_Cycle}    Acquire Argument Value    ${sFee_Cycle}

    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Click Javatree Cell    ${LIQ_RepaymentSchedule_CurrentSchedule_JavaTree}    ${Fee_Cycle}*%Item
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Transaction_NB_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledPrincipalPaymentNotebook

Approve Scheduled Principal Payment
    [Documentation]    This keyword approves the Scheduled Principal payment from LIQ.
    ...    @author: fmamaril 
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing; added screenshot
    ...    @update: dahijara    16JUL2020    - Fix warnings; Multiple variables assigned to the keyword
    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ScheduledPrincipalPayment_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ScheduledPrincipalPayment_Workflow_JavaTree}    Approval%d
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .*Scheduled Principal Payment.*;Question;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .*Scheduled Principal Payment.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Scheduled Principal Payment.*Awaiting Release.*")     VerificationData="Yes"

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledPrincipalPaymentNotebook_WorkflowTab

Release Scheduled Principal Payment
    [Documentation]    This keyword releases the Ongoing Fee Payment from LIQ.
    ...    @author: fmamaril 
    ...    @update: fmamaril    23APR2019    Remove argument and closing of unnecessary window
    ...    @update: bernchua    25JUN2019    Used generic keyword for validating window title status and for clicking warning/question messages    
    ...    @update: ehugo    01JUN2020    - added screenshot

    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ScheduledPrincipalPayment_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ScheduledPrincipalPayment_Workflow_JavaTree}    Release%d
    Validate if Question or Warning Message is Displayed
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Validate Window Title Status    Principal Payment    Released

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledPrincipalPaymentNotebook_WorkflowTab
        
Validate if Outstanding Amount has decreased
    [Documentation]    This keyword checks the Geneal Tab if Outstanding Amount was decreased.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing and post-processing; added optional runtime arguments; added screenshot
    [Arguments]    ${sActualAmount}    ${sRunTimeVar_GlobalOriginal}=None    ${sRunTimeVar_NewPrincipalAmount}=None    ${sRunTimeVar_ActualGlobalOriginal}=None    ${sRunTimeVar_HostBankNet}=None

    ### Keyword Pre-processing ###
    ${ActualAmount}    Acquire Argument Value    ${sActualAmount}

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${sActual_GlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Field}    GlobalOriginal
    ${GlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Field}    GlobalCurrent
    ${HostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Field}    HostBankGross
    ${sHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Field}    HostBankNet
    ${GlobalOriginal}    Remove String    ${sActual_GlobalOriginal}    ,
    ${GlobalCurrent}    Remove String    ${GlobalCurrent}    ,
    ${HostBankGross}    Remove String    ${HostBankGross}    ,
    ${HostBankNet}    Remove String    ${sHostBankNet}    ,
    ${ActualAmount}    Remove String    ${ActualAmount}    ,    
    ${GlobalOriginal}    Convert To Number    ${GlobalOriginal}
    ${GlobalCurrent}    Convert To Number    ${GlobalCurrent} 
    ${HostBankGross}    Convert To Number    ${HostBankGross} 
    ${HostBankNet}    Convert To Number    ${HostBankNet}
    ${ActualAmount}    Convert To Number    ${ActualAmount}
    ${NewPrincipalAmount}    Evaluate     ${GlobalOriginal} - ${ActualAmount}
    Should Be Equal As Strings    ${NewPrincipalAmount}    ${GlobalCurrent}
    Should Be Equal As Strings    ${NewPrincipalAmount}    ${HostBankGross}
    Should Be Equal As Strings    ${NewPrincipalAmount}    ${HostBankNet}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_OutstandingAmount

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_GlobalOriginal}    ${GlobalOriginal}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_NewPrincipalAmount}    ${NewPrincipalAmount}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ActualGlobalOriginal}    ${sActual_GlobalOriginal}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_HostBankNet}    ${sHostBankNet}

    [Return]    ${GlobalOriginal}    ${NewPrincipalAmount}    ${sActual_GlobalOriginal}    ${sHostBankNet}  
    
Validate Loan on Repayment Schedule
    [Documentation]    This keyword validates the Loan details on Repayment Schedule.
    ...    @author: fmamaril
    ...    update: added number conversion to the amounts being passed on.
    ...    @update: rtarayao    12APR2019    Deleted Removed comma keyword for number conversion.
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sGlobalOriginal}    ${sHostBankNet}    ${sActualAmount}    ${sFee_Cycle}

    ### Keyword Pre-processing ###
    ${GlobalOriginal}    Acquire Argument Value    ${sGlobalOriginal}
    ${HostBankNet}    Acquire Argument Value    ${sHostBankNet}
    ${ActualAmount}    Acquire Argument Value    ${sActualAmount}
    ${Fee_Cycle}    Acquire Argument Value    ${sFee_Cycle}

    Navigate from Loan to Repayment Schedule
    Validate Loan IQ Details    ${GlobalOriginal}    ${LIQ_RepaymentSchedule_OriginalLoanAmount_Field}
    Validate Loan IQ Details    ${HostBankNet}    ${LIQ_RepaymentSchedule_CurrentLoanAmount_Field} 
    Validate Loan IQ Details    ${HostBankNet}    ${LIQ_RepaymentSchedule_CurrentHostAmount_Field}
    Mx LoanIQ Verify Text In Javatree    ${LIQ_ScheduledPrincipalPayment_RapaymentHistory_JavaTree}    Scheduled Principal Payment of ${ActualAmount}.*     

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentScheduleWindow_ValidateLoan
    mx LoanIQ click    ${LIQ_ScheduledPrincipalPayment_Exit_Button}
    
Validate on Events Tab for Principal Payment
    [Documentation]    This keyword validates the Loan details on Events Tab for Principal Payment.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added screenshot

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Loan_Event_JavaTree}   Principal Payment Applied
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_Loan_Event_JavaTree}    Principal Payment Applied%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_EventsTab
    
Validate Principal Payment on GL Entries
    [Documentation]    This keyword validates the GL Entries for Principal Payment.
    ...    @author: fmamaril
    [Arguments]    ${ActualAmount}    ${Borrower_GLAccount}    ${HostBank_GLAccount}
    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}
    mx LoanIQ select    ${LIQ_ScheduledPrincipalPayment_Queries_GLEntries}
    # Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes             strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_PrincipalPayment_GLEntries_Window}  
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_PrincipalPayment_GLEntries_Table}    ${Borrower_GLAccount}%s  
    ${DebitAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PrincipalPayment_GLEntries_Table}    ${Borrower_GLAccount}%Debit Amt%test 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_PrincipalPayment_GLEntries_Table}    ${HostBank_GLAccount}%s    
    ${CreditAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PrincipalPayment_GLEntries_Table}    ${HostBank_GLAccount}%Credit Amt%test 
    Log    Debit Amount: ${DebitAmount}
    Log    Credit Amount: ${CreditAmount}
    ${DebitAmount}    Remove String    ${DebitAmount}    ,
    ${CreditAmount}    Remove String    ${CreditAmount}    , 
    ${ActualAmount}    Remove String    ${ActualAmount}    ,    
    ${DebitAmount}    Convert To Number    ${DebitAmount}
    ${CreditAmount}    Convert To Number    ${CreditAmount} 
    ${ActualAmount}    Convert To Number    ${ActualAmount}
    # ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}                
    Should Be Equal    ${DebitAmount}    ${CreditAmount}
    Should Be Equal    ${DebitAmount}    ${ActualAmount}
    Should Be Equal    ${CreditAmount}    ${ActualAmount}        
    mx LoanIQ click    ${LIQ_PrincipalPayment_GLEntries_Exit_Button}

Navigate to Oustanding Facility Window
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing; added screenshot
    ...                                   - removed Sleep
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    Open Existing Deal    ${Deal_Name}        
    mx LoanIQ select   ${LIQ_DealNotebook_Options_Facilities}
    mx LoanIQ activate window     ${LIQ_FacilityNavigator_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityNavigator_Tree}    ${Facility_Name}%d  
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ click    ${LIQ_FacilitySummary_Outstandings_Button}
    mx LoanIQ activate window    ${LIQ_OutstandingForFacility_Window}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_OutstandingForFacilityWindow
    
Validate Principal Payment for Term Facility on Oustanding Window
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    This only handles Bilateral deal with one drawdown.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing; added screenshot
    ...                                   - updated validation to 'Should Be Equal As Numbers'
    [Arguments]    ${sScheduledPrincipalPayment_Amount}    ${sCurrentCmtBeforePayment}    ${sCurrentCmtAfterPayment}    ${sOutstandingBeforePayment}    ${sOutstandingAfterPayment}    ${sAvailToDrawBeforePayment}    ${sAvailToDrawAfterPayment}

    ### GetRuntime Keyword Pre-processing ###
    ${ScheduledPrincipalPayment_Amount}    Acquire Argument Value    ${sScheduledPrincipalPayment_Amount}
    ${CurrentCmtBeforePayment}    Acquire Argument Value    ${sCurrentCmtBeforePayment}
    ${CurrentCmtAfterPayment}    Acquire Argument Value    ${sCurrentCmtAfterPayment}
    ${OutstandingBeforePayment}    Acquire Argument Value    ${sOutstandingBeforePayment}
    ${OutstandingAfterPayment}    Acquire Argument Value    ${sOutstandingAfterPayment}
    ${AvailToDrawBeforePayment}    Acquire Argument Value    ${sAvailToDrawBeforePayment}
    ${AvailToDrawAfterPayment}    Acquire Argument Value    ${sAvailToDrawAfterPayment}

    ${ScheduledPrincipalPayment_Amount}   Remove comma and convert to number - Cycle Due    ${ScheduledPrincipalPayment_Amount}
    ${CalculatedCurrentCMT}    Evaluate    ${CurrentCmtBeforePayment} - ${ScheduledPrincipalPayment_Amount}
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${CalculatedCurrentCMT}    ${CurrentCmtAfterPayment}     
    ${CalculatedOutstandingAfterPayment}    Evaluate     ${OutstandingBeforePayment} - ${ScheduledPrincipalPayment_Amount}
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${CalculatedOutstandingAfterPayment}    ${OutstandingAfterPayment} 
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${AvailToDrawBeforePayment}    ${AvailToDrawAfterPayment}    

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingWindow_ValidatePrincipalPaymentForTermFacility
    
Validate Principal Payment for Revolver Facility on Oustanding Window
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    This only handles Bilateral deal with one drawdown.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing; added screenshot
    ...                                   - updated validation to 'Should Be Equal As Numbers'
    [Arguments]    ${sScheduledPrincipalPayment_Amount}    ${sCurrentCmtBeforePayment}    ${sCurrentCmtAfterPayment}    ${sOutstandingBeforePayment}    ${sOutstandingAfterPayment}    ${sAvailToDrawBeforePayment}    ${sAvailToDrawAfterPayment}

    ### GetRuntime Keyword Pre-processing ###
    ${ScheduledPrincipalPayment_Amount}    Acquire Argument Value    ${sScheduledPrincipalPayment_Amount}
    ${CurrentCmtBeforePayment}    Acquire Argument Value    ${sCurrentCmtBeforePayment}
    ${CurrentCmtAfterPayment}    Acquire Argument Value    ${sCurrentCmtAfterPayment}
    ${OutstandingBeforePayment}    Acquire Argument Value    ${sOutstandingBeforePayment}
    ${OutstandingAfterPayment}    Acquire Argument Value    ${sOutstandingAfterPayment}
    ${AvailToDrawBeforePayment}    Acquire Argument Value    ${sAvailToDrawBeforePayment}
    ${AvailToDrawAfterPayment}    Acquire Argument Value    ${sAvailToDrawAfterPayment}

    ${ScheduledPrincipalPayment_Amount}   Remove comma and convert to number - Cycle Due    ${ScheduledPrincipalPayment_Amount}
    ${CalculatedCurrentCMT}    Evaluate    ${CurrentCmtBeforePayment} - ${ScheduledPrincipalPayment_Amount}
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${CalculatedCurrentCMT}    ${CurrentCmtAfterPayment}     
    ${CalculatedOutstandingAfterPayment}    Evaluate     ${OutstandingBeforePayment} - ${ScheduledPrincipalPayment_Amount}
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${CalculatedOutstandingAfterPayment}    ${OutstandingAfterPayment}
    ${CalculatedAvailToDraw}    Evaluate    ${AvailToDrawBeforePayment} + ${ScheduledPrincipalPayment_Amount}
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${CalculatedAvailToDraw}}    ${AvailToDrawAfterPayment}   

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingWindow_ValidatePrincipalPaymentForRevolverFacility
    
Open Scheduled Principal Payment Notebook from Repayment Flex Schedule
    [Documentation]    This keywod opens scheduled principal payment.
    ...    @author: fmamaril
    ...    @update: dahijara    10JUL2020    -Add pre-processing keywords and screenshot. Removed commented codes. Updated locator for Current schedule java tree.
    [Arguments]    ${sFee_Cycle}
    ### GetRuntime Keyword Pre-processing ###
    ${Fee_Cycle}    Acquire Argument Value    ${sFee_Cycle}

    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Click Javatree Cell    ${LIQ_RepaymentSchedule_CurrentSchedule_Javatree}    ${Fee_Cycle}*%Item
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Transaction_NB_Button}

Get Current Commitment, Outstanding and Available to Draw on Facility Before Payment
    [Documentation]    This keyword gets the current value for Commitment, Outstanding and Available to Draw on Facility
    ...    This only handles Bilateral deal with one drawdown.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing and post-processing; added optional runtime variables; added screenshot
    [Arguments]    ${sBorrower_Name}    ${sRunTimeVar_OutstandingBeforePayment}=None    ${sRunTimeVar_AvailToDrawBeforePayment}=None    ${sRunTimeVar_CurrentCmtBeforePayment}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_Name}    Acquire Argument Value    ${sBorrower_Name}

    mx LoanIQ activate window    ${LIQ_OutstandingForFacility_Window}    
    ${OutstandingBeforePayment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Outstandings%Outstanding
    ${OutstandingBeforePayment}    Remove String    ${OutstandingBeforePayment}    ,    
    ${OutstandingBeforePayment}    Convert To Number    ${OutstandingBeforePayment}
    Set Global Variable    ${OutstandingBeforePayment}    
    ${AvailToDrawBeforePayment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Available%Available
    ${AvailToDrawBeforePayment}    Remove String    ${AvailToDrawBeforePayment}    ,    
    ${AvailToDrawBeforePayment}    Convert To Number    ${AvailToDrawBeforePayment}
    Set Global Variable    ${AvailToDrawBeforePayment}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingForFacilityWindow_OutstandingAndAvailableToDraw
    mx LoanIQ close window    ${LIQ_OutstandingForFacility_Window}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}              
    ${CurrentCmtBeforePayment}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%CurrentCmtBeforePayment
    ${CurrentCmtBeforePayment}   Remove String    ${CurrentCmtBeforePayment}    ,    
    ${CurrentCmtBeforePayment}    Convert To Number    ${CurrentCmtBeforePayment}
    Set Global Variable    ${CurrentCmtBeforePayment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_CurrentCmt
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OutstandingBeforePayment}    ${OutstandingBeforePayment}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_AvailToDrawBeforePayment}    ${AvailToDrawBeforePayment}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_CurrentCmtBeforePayment}    ${CurrentCmtBeforePayment}

    [Return]    ${OutstandingBeforePayment}    ${AvailToDrawBeforePayment}    ${CurrentCmtBeforePayment}
    
Get Current Commitment, Outstanding and Available to Draw on Facility After Payment
    [Documentation]    This keyword gets the current value for Commitment, Outstanding and Available to Draw on Facility
    ...    This only handles Bilateral deal with one drawdown.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing and post-processing; added optional runtime arguments; added screenshot
    [Arguments]    ${sBorrower_Name}    ${sRunTimeVar_OutstandingAfterPayment}=None    ${sRunTimeVar_AvailToDrawAfterPayment}=None    ${sRunTimeVar_CurrentCmtAfterPayment}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_Name}    Acquire Argument Value    ${sBorrower_Name}

    ${OutstandingAfterPayment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Outstandings%Outstanding
    ${OutstandingAfterPayment}    Remove String    ${OutstandingAfterPayment}    ,    
    ${OutstandingAfterPayment}    Convert To Number    ${OutstandingAfterPayment}
    Set Global Variable    ${OutstandingAfterPayment}    
    ${AvailToDrawAfterPayment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OutstandingForFacility_JavaTree}    ${Borrower_Name}%Available%Available
    ${AvailToDrawAfterPayment}    Remove String    ${AvailToDrawAfterPayment}    ,    
    ${AvailToDrawAfterPayment}    Convert To Number    ${AvailToDrawAfterPayment}
    Set Global Variable    ${AvailToDrawAfterPayment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingForFacilityWindow_OutstandingAndAvailableToDraw
    mx LoanIQ close window    ${LIQ_OutstandingForFacility_Window}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}    
    ${CurrentCmtAfterPayment}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%CurrentCmtAfterPayment
    ${CurrentCmtAfterPayment}   Remove String    ${CurrentCmtAfterPayment}    ,    
    ${CurrentCmtAfterPayment}    Convert To Number    ${CurrentCmtAfterPayment}
    Set Global Variable    ${CurrentCmtAfterPayment}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_CurrentCmt

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OutstandingAfterPayment}    ${OutstandingAfterPayment}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_AvailToDrawAfterPayment}    ${AvailToDrawAfterPayment}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_CurrentCmtAfterPayment}    ${CurrentCmtAfterPayment}

    [Return]    ${OutstandingAfterPayment}    ${AvailToDrawAfterPayment}    ${CurrentCmtAfterPayment}          

Navigate from General to Workflow - Principal Payment
    [Documentation]    This keyword navigates from General to Workflow Tab.
    ...    @author: fmamaril    
    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ScheduledPrincipalPayment_Tab}    Workflow
    
Navigate to Scheduled Principal Payment Cashflow Window
    [Documentation]    This keyword is used to navigate to the Payment Cashflow Window thru the Workflow action - Create Cashflow.
    ...    @author: fmamaril
    ...    @update: ehugo    01JUN2020    - added screenshot
    ...                                   - used 'Mx LoanIQ Select Or Doubleclick In Tree By Text' for double-clicking Create Cashflows
    ...                                   - used 'Verify If Warning Is Displayed' for clicking Yes or warning message

    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_ScheduledPrincipalPayment_Tab}    Workflow
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_ScheduledPrincipalPayment_Workflow_JavaTree}    Create Cashflows%d             
    Verify If Warning Is Displayed       
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_Window}    VerificationData="Yes"

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledPrincipalPaymentWindow_WorkflowTab

Populate Principal Payment General Tab
    [Documentation]    This keyword inputs data on the fields under General Tab.
    ...    @author:mgaling
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sPrincipalPayment_RequestedAmount}    ${sPrincipalPayment_EffectiveDate}    ${sReason}
    
    ### GetRuntime Keyword Pre-processing ###
    ${PrincipalPayment_RequestedAmount}    Acquire Argument Value    ${sPrincipalPayment_RequestedAmount}
    ${PrincipalPayment_EffectiveDate}    Acquire Argument Value    ${sPrincipalPayment_EffectiveDate}
    ${Reason}    Acquire Argument Value    ${sReason}

    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_PrincipalPayment_Tab}    General
    
    mx LoanIQ enter    ${LIQ_PrincipalPayment_Requested_Amount}    ${PrincipalPayment_RequestedAmount}
    mx LoanIQ enter    ${LIQ_PrincipalPayment_EffectiveDate_Field}    ${PrincipalPayment_EffectiveDate}
    mx LoanIQ enter    ${LIQ_PrincipalPayment_Reason_Field}    ${Reason}
    Mx Press Combination    Key.BACKSPACE
   
    mx LoanIQ select    ${LIQ_PrincipalPayment_FileSave}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrincipalPaymentWindow_GeneralTab
    
Verify if Status is set to Do It - Payment
    [Documentation]    This keyword is used to validate the Payment Cashflow Status
    ...    @author: mgaling
    [Arguments]    ${LIQCustomer_ShortName}
     ${CashflowStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Cashflows_Tree}    ${LIQCustomer_ShortName}%Status%MStatus_Variable
    Log To Console    ${CashflowStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${LIQCustomer_ShortName}%s   
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_LoanRepricing_Cashflows_DoIt_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete  
    
Generate Intent Notices on Principal Payment
    [Documentation]    This keyword is for generating Intent Notices under Work flow Tab.
    ...    @author:mgaling
    ...    @update: ehugo    02JUN2020    - added screenshot
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PrincipalPayment_Tab}    Workflow
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices         
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%d   
    Run Keyword If    ${status}==False    Log    Fail    'Generate Intent Notices' item is not available    
    
    mx LoanIQ activate window    ${LIQ_Notices_Window}
    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_NoticeGroup_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrincipalPaymentWindow_NoticeGroup
    mx LoanIQ click    ${LIQ_PrincipalPayment_NoticeGroup_Exit_Button}

Send Principal Payment to Approval
    [Documentation]    This keyword is for Send to Approval Window.
    ...    @author: mgaling
    ...    @update: ehugo    02JUN2020    - added screenshot
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}     
    Mx LoanIQ Select Window Tab    ${LIQ_PrincipalPayment_Tab}    Workflow
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Send to Approval%d 
	:FOR    ${i}    IN RANGE    3
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrincipalPaymentWindow_WorkflowTab_SendToApproval

Approve Principal Payment
     [Documentation]    This keyword is for approval of Principal Payment Notebook.
    ...    @author: mgaling
    ...    @update: fmamaril    24APR2019    Added Question message box handling
    ...    @update: ehugo    02JUN2020    - added screenshot

    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}     
    Mx LoanIQ Select Window Tab    ${LIQ_PrincipalPayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Approval%d  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrincipalPaymentWindow_WorkflowTab_Approval
    mx LoanIQ close window    ${LIQ_PrincipalPayment_Window}       
 
Release Principal Payment
    [Documentation]    This keyword is for releasing of Principal Payment Notebook.
    ...    @author: mgaling
    ...    @update: ehugo    02JUN2020    - added screenshot
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}     
    Mx LoanIQ Select Window Tab    ${LIQ_PrincipalPayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Release%d  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    2
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False 
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrincipalPaymentWindow_WorkflowTab_Release
    
Validation on Principal Payment Notebook - Events Tab
    [Documentation]    This keyword is for validates Principal Payment Notebook Events Tab.
    ...    @author: mgaling
    ...    @update: ehugo    02JUN2020    - added screenshot
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PrincipalPayment_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_PrincipalPayment_Events_JavaTree}    Released%yes
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrincipalPaymentWindow_EventsTab_Released

Validation on Principal Payment Notebook - GL Entries Window
    [Documentation]    This keyword is for validates Principal Payment Notebook GL Entries.
    ...    @author: mgaling
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing and post-processing; added optional runtime arguments; added screenshot
    [Arguments]    ${sPrincipalPayment_RequestedAmount}    ${sBorrower_Name}    ${sLender1}    ${sLender1_Percentage}    ${sLender2}    ${sLender2_Percentage}    ${sHostBankLender_Percentage}
    ...    ${sRunTimeVar_ComputedCreditAmt1}=None    ${sRunTimeVar_ComputedCreditAmt2}=None    ${sRunTimeVar_ComputedCreditAmt3}=None
    
    ### GetRuntime Keyword Pre-processing ###
    ${PrincipalPayment_RequestedAmount}    Acquire Argument Value    ${sPrincipalPayment_RequestedAmount}
    ${Borrower_Name}    Acquire Argument Value    ${sBorrower_Name}
    ${Lender1}    Acquire Argument Value    ${sLender1}
    ${Lender1_Percentage}    Acquire Argument Value    ${sLender1_Percentage}
    ${Lender2}    Acquire Argument Value    ${sLender2}
    ${Lender2_Percentage}    Acquire Argument Value    ${sLender2_Percentage}
    ${HostBankLender_Percentage}    Acquire Argument Value    ${sHostBankLender_Percentage}

    ${PrincipalPayment_RequestedAmount}    Convert To Number    ${PrincipalPayment_RequestedAmount}    2   
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    mx LoanIQ select    ${LIQ_PrincipalPayment_QueriesGLEntries} 
    
    ###Debit and Credit Amount###
    ${DebitAmt}    Get Debit Amount - Principal Payment    ${Borrower_Name}
    Should Be Equal    ${PrincipalPayment_RequestedAmount}    ${DebitAmt}
    Log    ${PrincipalPayment_RequestedAmount}=${DebitAmt}        
    
    ${CreditAmt}    Get Credit Amount - Principal Payment    ${Lender1}  
    ${Computed_CreditAmt1}    Evaluate    ${PrincipalPayment_RequestedAmount}*(${Lender1_Percentage}/100) 
    Should Be Equal    ${Computed_CreditAmt1}    ${CreditAmt} 
    Log    ${Computed_CreditAmt1}=${CreditAmt}      
    
    ${CreditAmt}    Get Credit Amount - Principal Payment    ${Lender2}
    ${Computed_CreditAmt2}    Evaluate    ${PrincipalPayment_RequestedAmount}*(${Lender2_Percentage}/100) 
    Should Be Equal    ${Computed_CreditAmt2}    ${CreditAmt} 
    Log    ${Computed_CreditAmt2}=${CreditAmt} 
    
    ${CreditAmt}    Get Credit Amount - Principal Payment    Principal Loan Account
    ${Computed_CreditAmt3}    Evaluate    ${PrincipalPayment_RequestedAmount}*(${HostBankLender_Percentage}/100) 
    Should Be Equal    ${Computed_CreditAmt3}    ${CreditAmt} 
    Log    ${Computed_CreditAmt3}=${CreditAmt} 
    
    ###Debit and Credit Total Amount###
    ${DebitTotalAmt}    Get Debit Total Amount - Principal Payment
    Should Be Equal    ${DebitAmt}    ${DebitTotalAmt} 
    Log    ${DebitAmt}=${DebitTotalAmt}   
    
    ${CreditTotalAmt}    Get Credit Total Amount - Principal Payment
    ${Computed_CreditTotalAmt}    Evaluate    ${Computed_CreditAmt1}+${Computed_CreditAmt2}+${Computed_CreditAmt3}
    Should Be Equal    ${CreditTotalAmt}    ${Computed_CreditTotalAmt} 
    Log    ${CreditTotalAmt}=${Computed_CreditTotalAmt}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrincipalPaymentWindow_GLEntries
    mx LoanIQ click    ${LIQ_PrincipalPayment_GLEntries_Exit_Button}   
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ComputedCreditAmt1}    ${Computed_CreditAmt1}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ComputedCreditAmt2}    ${Computed_CreditAmt2}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ComputedCreditAmt3}    ${Computed_CreditAmt3}

    [Return]    ${Computed_CreditAmt1}    ${Computed_CreditAmt2}    ${Computed_CreditAmt3}    

Get Debit Amount - Principal Payment
    [Documentation]    This keyword is used to get debit amount in GL Entries
    ...    @author: mgaling
    [Arguments]    ${LIQCustomer_ShortName}
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_GLEntries_Window}
    
    ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${LIQCustomer_ShortName}%Debit Amt%Debit
    ${DebitAmt}    Remove String    ${DebitAmt}    ,
    ${DebitAmt}    Convert To Number    ${DebitAmt}    2
    Log To Console    ${DebitAmt} 
    [Return]    ${DebitAmt}    

Get Credit Amount - Principal Payment
    [Documentation]    This keyword is used to get credit amount in GL Entries
    ...    @author: mgaling
    [Arguments]    ${LIQCustomer_ShortName}
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_GLEntries_Window}
    
    ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${LIQCustomer_ShortName}%Credit Amt%Credit
    ${CreditAmt}    Remove String    ${CreditAmt}    ,
    ${CreditAmt}    Convert To Number    ${CreditAmt}    2
    Log To Console    ${CreditAmt} 
    [Return]    ${CreditAmt}  

Get Debit Total Amount - Principal Payment
    [Documentation]    This keyword is used to get debit total amount in GL Entries
    ...    @author: mgaling
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_GLEntries_Window}
    
    ${DebitTotalAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${SPACE}Total For: CB001%Debit Amt%Debit
    ${DebitTotalAmt}    Remove String    ${DebitTotalAmt}    ,
    ${DebitTotalAmt}    Convert To Number    ${DebitTotalAmt}    2
    [Return]    ${DebitTotalAmt}

Get Credit Total Amount - Principal Payment
    [Documentation]    This keyword is used to get debit total amount in GL Entries
    ...    @author: mgaling
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_GLEntries_Window}
    
    ${CreditTotalAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${SPACE}Total For: CB001%Credit Amt%Credit
    ${CreditTotalAmt}    Remove String    ${CreditTotalAmt}    ,
    ${CreditTotalAmt}    Convert To Number    ${CreditTotalAmt}    2
    [Return]    ${CreditTotalAmt}
    
Validation on Principal Payment Notebook - Lender Shares Window
    [Documentation]    This Keyword is used to validate the Lender Share values
    ...    @author:mgaling
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sHostBank_Lender}    ${sComputed_CreditAmt3}    ${sLender1}    ${sComputed_CreditAmt1}    ${sLender2}    ${sComputed_CreditAmt2}    ${sPrincipalPayment_RequestedAmount}                    
    
    ### GetRuntime Keyword Pre-processing ###
    ${HostBank_Lender}    Acquire Argument Value    ${sHostBank_Lender}
    ${Computed_CreditAmt3}    Acquire Argument Value    ${sComputed_CreditAmt3}
    ${Lender1}    Acquire Argument Value    ${sLender1}
    ${Computed_CreditAmt1}    Acquire Argument Value    ${sComputed_CreditAmt1}
    ${Lender2}    Acquire Argument Value    ${sLender2}
    ${Computed_CreditAmt2}    Acquire Argument Value    ${sComputed_CreditAmt2}
    ${PrincipalPayment_RequestedAmount}    Acquire Argument Value    ${sPrincipalPayment_RequestedAmount}

    ${PrincipalPayment_RequestedAmount}    Convert To Number    ${PrincipalPayment_RequestedAmount}    2
      
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    mx LoanIQ select    ${LIQ_PrincipalPayment_OptionsViewUpdateLenderShares} 
    
    ${HostBank_ActualAmount}    Get Host Bank Payment Lender Share under PrimariesAssignees Section    ${HostBank_Lender}
    Should Be Equal    ${HostBank_ActualAmount}    ${Computed_CreditAmt3}    
    Log    ${HostBank_ActualAmount}=${Computed_CreditAmt3} 
    
    ${NonHostBank_ActualAmount}    Get Non Host Bank Payment Lender Share under PrimariesAssignees Section    ${Lender1}
    Should Be Equal    ${NonHostBank_ActualAmount}    ${Computed_CreditAmt1}
    Log    ${NonHostBank_ActualAmount}=${Computed_CreditAmt1} 
    
    ${NonHostBank_ActualAmount}    Get Non Host Bank Payment Lender Share under PrimariesAssignees Section    ${Lender2}  
    Should Be Equal    ${NonHostBank_ActualAmount}    ${Computed_CreditAmt2}
    Log    ${NonHostBank_ActualAmount}=${Computed_CreditAmt2}  
    
    ${HostBankShare_ActualAmount}    Get Host Bank Payment Lender Share under Host Bank Share Section    ${HostBank_Lender} 
    Should Be Equal    ${HostBankShare_ActualAmount}    ${HostBank_ActualAmount}
    Log    ${HostBankShare_ActualAmount}=${HostBank_ActualAmount}
    
    ${ActualTotal}    Get Actual Total in Payment Lender Share
    Should Be Equal    ${ActualTotal}    ${PrincipalPayment_RequestedAmount}
    Log    ${ActualTotal}=${PrincipalPayment_RequestedAmount} 
    
    ${ActualNetAllTotal}    Get Actual Net All Total in Payment Lender Share    
    Should Be Equal    ${ActualNetAllTotal}    ${HostBankShare_ActualAmount}
    Log    ${ActualNetAllTotal}=${HostBankShare_ActualAmount}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PrincipalPaymentWindow_LenderShares
    
    mx LoanIQ close window    ${LIQ_LenderShares_Window}    
    
Get Host Bank Payment Lender Share under PrimariesAssignees Section
    [Documentation]    This Keyword is used to get data under Primaries/Assignees Section.
    ...    @author:mgaling
    [Arguments]    ${HostBank_Lender}
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    ${HostBank_ActualAmount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_Lender}%Actual Amount%Amount
    ${HostBank_ActualAmount}    Remove String    ${HostBank_ActualAmount}    -
    ${HostBank_ActualAmount}    Remove String    ${HostBank_ActualAmount}    ,
    ${HostBank_ActualAmount}    Convert To Number    ${HostBank_ActualAmount}    2
    [Return]    ${HostBank_ActualAmount}
    
Get Non Host Bank Payment Lender Share under PrimariesAssignees Section  
    [Documentation]    This Keyword is used to get data under Primaries/Assignees Section.
    ...    @author:mgaling
    [Arguments]    ${Lender}
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    ${NonHostBank_ActualAmount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender}%Actual Amount%Amount
    ${NonHostBank_ActualAmount}    Remove String    ${NonHostBank_ActualAmount}    -
    ${NonHostBank_ActualAmount}    Remove String    ${NonHostBank_ActualAmount}    ,
    ${NonHostBank_ActualAmount}    Convert To Number    ${NonHostBank_ActualAmount}    2
    [Return]    ${NonHostBank_ActualAmount}

Get Host Bank Payment Lender Share under Host Bank Share Section
    [Documentation]    This Keyword is used to get data under Primaries/Assignees Section.
    ...    @author:mgaling
    [Arguments]    ${HostBank_Lender}
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    ${HostBankShare_ActualAmount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_LenderShares_PrimariesAssignees_List}    ${HostBank_Lender}%Actual Amount%Amount
    ${HostBankShare_ActualAmount}    Remove String    ${HostBankShare_ActualAmount}    -
    ${HostBankShare_ActualAmount}    Remove String    ${HostBankShare_ActualAmount}    ,
    ${HostBankShare_ActualAmount}    Convert To Number    ${HostBankShare_ActualAmount}    2
    [Return]    ${HostBankShare_ActualAmount}

Get Actual Total in Payment Lender Share  
    [Documentation]    This Keyword is used to get Actual Total data under Primaries/Assignees Section.
    ...    @author:mgaling
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    ${ActualTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_PrimariesAssignees_ActualTotal}    value%Total    
    ${ActualTotal}    Remove String    ${ActualTotal}    -
    ${ActualTotal}    Remove String    ${ActualTotal}    ,
    ${ActualTotal}    Convert To Number    ${ActualTotal}    2
    [Return]    ${ActualTotal}
    
Get Actual Net All Total in Payment Lender Share  
    [Documentation]    This Keyword is used to get Actual Net All Total under Host Bank Shares Section.
    ...    @author:mgaling
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    
    ${ActualNetAllTotal}    Mx LoanIQ Get Data    ${LIQ_LenderShares_HostBankShares_ActualNetAllTotal}    value%Total    
    ${ActualNetAllTotal}    Remove String    ${ActualNetAllTotal}    -
    ${ActualNetAllTotal}    Remove String    ${ActualNetAllTotal}    ,
    ${ActualNetAllTotal}    Convert To Number    ${ActualNetAllTotal}    2

    [Return]    ${ActualNetAllTotal}
    
Open Scheduled Principal Payment Notebook via WIP - Awaiting Release
    [Documentation]    This keyword is used to open the Scheduled Principal Payment Notebook with an Awaiting Release Status thru the LIQ WIP Icon.
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
    mx LoanIQ activate window    ${LIQ_Repayment_Window}

Generate Intent Notices for Principal Payment
    [Documentation]    This keyword sends Payment Notices to the Borrower and Lender.
    ...    @author: fmamaril
    mx LoanIQ activate window   ${LIQ_Repayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Repayment_Tab}    Workflow
    # Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Repayment_WorkflowItems}    Generate Intent Notices
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    :FOR    ${i}    IN RANGE    1
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False

Generate Intent Notices for Scheduled Principal Payment
    [Documentation]    This keyword sends Payment Notices to the Borrower and Lender.
    ...    @author: rtarayao
    mx LoanIQ activate window   ${LIQ_ScheduledPrincipalPayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_ScheduledPrincipalPayment_Tab}    Workflow
    # Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_ScheduledPrincipalPayment_Workflow_JavaTree}    Generate Intent Notices
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    :FOR    ${i}    IN RANGE    1
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False

Validate Payment on GL Entries - Scheduled Principal Payment
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
    Set Global Variable    ${ScheduledPrincipalPayment_Amount}    
    # ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}                
    Should Be Equal As Strings    ${DebitAmount}    ${CreditAmount}
    Should Be Equal As Strings    ${DebitAmount}    ${ScheduledPrincipalPayment_Amount}
    Should Be Equal As Strings    ${CreditAmount}    ${ScheduledPrincipalPayment_Amount}        
    Mx LoanIQ Close    ${LIQ_Repayment_GLEntries_Window}

Navigate to Scheduled Principal Payment Workflow Tab
    [Documentation]    This keyword validates the Facility Details on Dashboard after Payment
    ...    @author: rtarayao
    mx LoanIQ activate window    ${LIQ_ScheduledPrincipalPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ScheduledPrincipalPayment_Tab}    Workflow
    
Compute For Lender Share Percentage
    [Documentation]    This keyword gets the Actual Amount per Lender from the Principal Payment Notebook > View/Update Lender Shares menu,
    ...                and computes for the lender share perncetage from the Payment requested amount.
    ...                @author: bernchua
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing and post-processing; added optional runtime argument; added screenshot
    [Arguments]    ${sLender_Name}    ${sRequested_Amount}    ${sRunTimeVar_LenderSharePercent}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Lender_Name}    Acquire Argument Value    ${sLender_Name}
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}

    mx LoanIQ activate    ${LIQ_PrincipalPayment_Window}    
    mx LoanIQ select    ${LIQ_PrincipalPayment_OptionsViewUpdateLenderShares}
    mx LoanIQ activate    ${LIQ_SharesFor_Window}
    ${Actual_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SharesFor_Primaries_Tree}    ${Lender_Name}%Actual Amount%amount
    ${Actual_Amount}    Remove String    ${Actual_Amount}    ,    -
    ${Actual_Amount}    Convert To Number    ${Actual_Amount}
    ${LenderShare_Percent}    Evaluate    ${Actual_Amount}/${Requested_Amount}
    ${LenderShare_Percent}    Evaluate    ${LenderShare_Percent}*100    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SharesForWindow_LenderSharePercentage
    mx LoanIQ close window    ${LIQ_SharesFor_Window}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_LenderSharePercent}    ${LenderShare_Percent}

    [Return]    ${LenderShare_Percent}
    
Validate if Outstanding Amount has decreased after Principal Payment
    [Documentation]    This keyword checks the General Tab if Outstanding Amount was decreased.
    ...    This is only applicable for bilateral deal.
    ...    @author: fmamaril
    ...    @update: rtarayao - added argument that contains the old host bank gross value.
    ...    @update: dahijara    - added pre and post processing keywords; optional argument for run time variable; screenshot
    [Arguments]    ${sOldHostBankGross}    ${sPrincipalAmount}    ${sRunVar_GlobalOriginal}=None    ${sRunVar_HostBankNet}=None
    ### GetRuntime Keyword Pre-processing ###
    ${OldHostBankGross}    Acquire Argument Value    ${sOldHostBankGross}
    ${PrincipalAmount}    Acquire Argument Value    ${sPrincipalAmount}
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${sGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Field}    GlobalOriginal
    ${GlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Field}    GlobalCurrent
    ${HostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Field}    HostBankGross
    ${sHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Field}    HostBankNet
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_Window
    ${sGlobalOriginal}    Remove Comma and Convert to Number    ${sGlobalOriginal}
    ${GlobalCurrent}    Remove Comma and Convert to Number    ${GlobalCurrent}
    ${HostBankGross}    Remove Comma and Convert to Number    ${HostBankGross}
    ${sHostBankNet}    Remove Comma and Convert to Number    ${sHostBankNet}
    ${OldHostBankGross}    Remove Comma and Convert to Number    ${OldHostBankGross}
    ${PrincipalAmount}    Remove Comma and Convert to Number    ${PrincipalAmount}
    ${ComputedGlobalCurrentAmount}    Evaluate     ${OldHostBankGross} - ${PrincipalAmount}
    Should Be Equal As Numbers    ${ComputedGlobalCurrentAmount}    ${GlobalCurrent}
    Should Be Equal As Numbers    ${ComputedGlobalCurrentAmount}    ${HostBankGross}
    Should Be Equal As Numbers    ${ComputedGlobalCurrentAmount}    ${sHostBankNet}
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_GlobalOriginal}    ${sGlobalOriginal}
    Save Values of Runtime Execution on Excel File    ${sRunVar_HostBankNet}    ${sHostBankNet}    
    [Return]    ${sGlobalOriginal}    ${sHostBankNet}

Create Repayment Schedule for Fixed Loan with Interest
    [Documentation]    This keyword selects the repayment schedule as Fixed Loan with Interest
    ...    This is only applicable for bilateral deal.
    ...    @author: fmamaril
    ...    @update: dahijara    15JUN2020    - added wait for window processing
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}    
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_RepaymentSchedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_RepaymentSchedule_ScheduleType_Cancel_Button}
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}    
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Reschedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate Loan Repayment Schedule Types
    Mx LoanIQ Verify Runtime Property    ${LIQ_RepaymentSchedule_ScheduleType_Prorate_CheckBox}    enabled%1
    mx LoanIQ enter    ${LIQ_RepaymentSchedule_ScheduleType_FPPID_RadioButton}    ON
    mx LoanIQ click    ${LIQ_RepaymentSchedule_ScheduleType_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ activate    ${LIQ_AutomaticScheduleFPPID_Window}
    mx LoanIQ click    ${LIQ_AutomaticScheduleFPPID_Accept_Button}
    mx LoanIQ click    ${LIQ_AutomaticScheduleFPPID_OK_Button}
    Mx LoanIQ Wait For Processing Window    ${LIQ_RepaymentSchedule_Window}    Processtimeout=1000
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Exit_Button}

Tick Principal Payment Prepayment Checkbox
    [Documentation]    Keyword used to tick the 'Prepayment' checkbox in the Principal Payment Notebook
    ...                @author: bernchua    18SEP2019    Initial create
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    ${STATUS}    Mx LoanIQ Get Data    ${LIQ_PrincipalPayment_Prepayment_Checkbox}    enabled%status
    Run Keyword If    '${STATUS}'=='0'    Mx LoanIQ Set    ${LIQ_PrincipalPayment_Prepayment_Checkbox}    ON
    ...    ELSE IF    '${STATUS}'=='1'    Log    Prepayment checkbox already ticked.

Close Selected Windows for Payment Release
    [Documentation]    Keyword used to close selected windows for Payment Release
    ...                @author: fmamaril    14OCT2019    Initial create
    mx LoanIQ close window    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ close window    ${LIQ_Loan_Window}
