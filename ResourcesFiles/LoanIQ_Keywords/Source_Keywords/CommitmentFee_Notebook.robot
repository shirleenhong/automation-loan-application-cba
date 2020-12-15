*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate to Scheduled Activity Filter
    [Documentation]    This keywod navigates to scheduled activity filter.
    ...    @author: fmamaril
    ...    @update: ehugo    04JUN2020    - added screenshot; removed Sleep

    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate window    ${LIQ_TransactionsInProcess_Window}
    mx LoanIQ select    ${LIQ_TransactionsInProcess_ScheduledActivity_Menu}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TransactionsInProcessWindow_ScheduledActivity
    
Set Scheduled Activity Filter
    [Documentation]    This keywod sets the scheduled activity filter.
    ...    @author: fmamaril    
    ...    @update: ehugo    04JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sScheduleActivity_FromDate}    ${sScheduledActivity_ThruDate}    ${sScheduledActivity_Department}    ${sScheduledActivity_Branch}    ${sScheduledActivity_DealName}   

    ### GetRuntime Keyword Pre-processing ###
    ${ScheduleActivity_FromDate}    Acquire Argument Value    ${sScheduleActivity_FromDate}
    ${ScheduledActivity_ThruDate}    Acquire Argument Value    ${sScheduledActivity_ThruDate}
    ${ScheduledActivity_Department}    Acquire Argument Value    ${sScheduledActivity_Department}
    ${ScheduledActivity_Branch}    Acquire Argument Value    ${sScheduledActivity_Branch}
    ${ScheduledActivity_DealName}    Acquire Argument Value    ${sScheduledActivity_DealName}

    mx LoanIQ activate window    ${LIQ_ScheduledActivityFilter_Window}    
    mx LoanIQ enter    ${LIQ_ScheduledActivityFilter_FromDate_Field}    ${ScheduleActivity_FromDate}
    mx LoanIQ enter    ${LIQ_ScheduledActivityFilter_ThruDate_Field}    ${ScheduledActivity_ThruDate}
    Mx LoanIQ select combo box value    ${LIQ_ScheduledActivityFilter_Department_List}    ${ScheduledActivity_Department}
    Mx LoanIQ select combo box value    ${LIQ_ScheduledActivityFilter_Branch_List}    ${ScheduledActivity_Branch}
    mx LoanIQ click    ${LIQ_ScheduledActivityFilter_Deal_Button}
    mx LoanIQ enter    ${LIQ_DealSelect_DealIdentifyBy_Textfield}    ${ScheduledActivity_DealName}   
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button} 
    mx LoanIQ click    ${LIQ_ScheduledActivityFilter_OK_Button}
    Verify Window    ${LIQ_ScheduledActivityReport_Window}     
    mx LoanIQ activate    ${LIQ_ScheduledActivityReport_Window}
    mx LoanIQ maximize    ${LIQ_ScheduledActivityReport_Window}
    mx LoanIQ click    ${LIQ_ScheduledActivityReport_ExpandAll_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledActivityReportWindow

Select Fee Due
    [Documentation]    This keywod selects an unutilized fee on scheduled activity.
    ...    @author: fmamaril
    ...    @update: rtarayao    11APR2019    Updated the input for Click Javatree Cell, then deleted Deal_Name as argument.
    ...    @update: ehugo    04JUN2020    - added keyword pre-processing; added screenshot; removed Sleep
    ...    @update: clanding    01DEC2020    - updated Mx Native Type    {ENTER}
    [Arguments]    ${sFeeType}    ${sScheduledActivityReport_Date}    ${sFacility_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${FeeType}    Acquire Argument Value    ${sFeeType}
    ${ScheduledActivityReport_Date}    Acquire Argument Value    ${sScheduledActivityReport_Date}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    mx LoanIQ activate window    ${LIQ_ScheduledActivityReport_Window}
    mx LoanIQ click   ${LIQ_ScheduledActivityReport_CollapseAll_Button}             
    Mx Loaniq Expand    ${LIQ_ScheduledActivityReport_List}    ${ScheduledActivityReport_Date}
    Mx Loaniq Expand    ${LIQ_ScheduledActivityReport_List}    ${ScheduledActivityReport_Date};${FeeType}  
    Mx LoanIQ Click Javatree Cell   ${LIQ_ScheduledActivityReport_List}    ${Facility_Name}%${Facility_Name}%Facility
    Mx Press Combination    KEY.ENTER

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledActivityReportWindow_Fee
    
Select Cycle Fee Payment
    [Documentation]    This keywod selects a cycle fee payment.
    ...    @author: fmamaril
    ...    @update: fmamaril    17APR2019    Modified handling to Ignore Error for Payments using either Commitment or Indemnity fee  only    
    ...    @update: ehugo    05JUN2020    - added screenshot; removed Sleep
    ...    @update: dahijara    16JUL2020    - Fix warnings - too many variables assigned in Mx LoanIQ Click Button On Window 

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}    
    mx LoanIQ select    ${LIQ_CommitmentFee_General_OptionsPayment_Menu}
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button} 
    mx LoanIQ enter    ${LIQ_CommitmentFee_Cycles_ProjectedDue_RadioButton}    ON
    mx LoanIQ click    ${LIQ_CommitmentFee_Cycles_OK_Button}
    Run Keyword And Ignore Error     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Ignore Error     Mx LoanIQ Click Button On Window    .* Indemnity Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_CycleFeePayment
    
Enter Effective Date for Ongoing Fee Payment
    [Documentation]    This keywod populates the effective date for ongoing fee payment.
    ...    @author: fmamaril 
    ...    @update: ritragel    08AUG2019    Updated to accommodate testcase that no need to enter cycle due
    ...    @update: ehugo    05JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sFeePayment_EffectiveDate}    ${sProjectedCycleDue}

    ### GetRuntime Keyword Pre-processing ###
    ${FeePayment_EffectiveDate}    Acquire Argument Value    ${sFeePayment_EffectiveDate}
    ${ProjectedCycleDue}    Acquire Argument Value    ${sProjectedCycleDue}

    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_EffectiveDate_Field}    ${FeePayment_EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Run Keyword If    "${ProjectedCycleDue}" != "null"    mx LoanIQ enter    ${LIQ_Payment_RequestedAmount_Textfield}    ${ProjectedCycleDue}     

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeePaymentWindow_EffectiveDate

Send Ongoing Fee Payment to Approval
    [Documentation]    This keywod sends the ongoing fee payment to approval.
    ...    @author: fmamaril 
    ...    @update: ritragel    20MAR2019    Updated validation for Warning and Question
    ...    @update: ehugo    05JUN2020    - added screenshot

    mx LoanIQ click element if present     ${LIQ_PaymentNotebook_Cashflow_OK_Button} 
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Send to Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeePaymentWindow_SendToApproval

Navigate Work in Process for Ongoing Fee Payment Approval
    [Documentation]    This keyword navigates the Deal w/ pending awaiting approval for the Ongoing Fee Payment in Work in Process module
    ...    @author: fmamaril
    [Arguments]    ${Facility_Name}
    # Mx Activate Window   ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}    
    Select Actions    [Actions];Work In Process
    Sleep    5    
    mx LoanIQ maximize    ${LIQ_TransactionInProcess_Window}    
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Transactions_List}    Payments    
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Approval         
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Ongoing Fee Payment    
    Mx Native Type    {ENTER}
    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Facility_Name}    
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}    
    
Navigate Work in Process for Ongoing Fee Payment Release
    [Documentation]    This keyword navigates the Deal w/ pending release for the Ongoing Fee Payment in Work in Process module
    ...    @author: fmamaril
    ...    @update: rtarayao - added action to close the transaction in process window, and activating the Payment window.
    [Arguments]    ${Facility_Name}
    # Mx Activate Window   ${LIQ_Window}
    Select Actions    [Actions];Work In Process
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    Payments    
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Ongoing Fee Payment
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Facility_Name}
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window}
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}    
    
Approve Ongoing Fee Payment
    [Documentation]    This keyword approves the Ongoing Fee Payment from LIQ.
    ...    @author: fmamaril 
    ...    @update: ehugo    05JUN2020    - added screenshot
    ...    @update: dahijara    16JUL2020    - Fix warnings - too many variables assigned in Mx LoanIQ Click Button On Window

    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Approval%d
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Fee.*;Question;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeePaymentWindow_WorkflowTab_Approval

Release Ongoing Fee Payment
    [Documentation]    This keyword releases the Ongoing Fee Payment from LIQ.
    ...    @author: fmamaril
    ...    @update: bernchua    25JUN2019    Used generic keyword for clicking warning/question messages
    ...    @update: ehugo    05JUN2020    - added screenshot

    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_OngoingFeePaymentNotebook_Workflow_JavaTree}    Release%d
    Validate if Question or Warning Message is Displayed

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeePaymentWindow_WorkflowTab_Release

Open Ongoing Fee from Deal Notebook
    [Documentation]    This keyword navigates to Ongoing Fee notebook from Deal Notebook.
    ...    @author: fmamaril
    ...    <update> 12Dec18 - bernchua : Gets and returns the "Fee Alias"
    ...    @update: ehugo    04JUN2020    - added keyword pre-processing and post-processing; added optional runtime variable; added screenshot
    [Arguments]    ${sFacility_Name}    ${sFee_Type}    ${sRunTimeVar_FeeAlias}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Fee_Type}    Acquire Argument Value    ${sFee_Type}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select   ${LIQ_DealNotebook_Options_Facilities}
    mx LoanIQ activate window     ${LIQ_FacilityNavigator_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityNavigator_Tree}    ${Facility_Name}%s
    mx LoanIQ click    ${LIQ_FacilityNavigator_OngoingFees_Button}
    ${Fee_Alias}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FeeList_JavaTree}    ${Fee_Type}%Fee Alias%alias
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeeList_JavaTree}    ${Fee_Type}%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNavigatorWindow_OngoingFee

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_FeeAlias}    ${Fee_Alias}

    [Return]    ${Fee_Alias}
    
Validate Details on Acrual Tab
    [Documentation]    This keyword validates the details on Acrual Tab.
    ...    @author: fmamaril
    [Arguments]    ${Computed_ProjectedCycleDue}    ${CycleNumber}
    mx LoanIQ activate window    ${LIQ_CommitmentFeeNotebook_Window}         
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual
    ${ProjectedEOCDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Acrual_JavaTree}    ${CycleNumber}%Projected EOC due%ProjectedEOCDue
    ${ProjectedEOCAccrual}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Acrual_JavaTree}    ${CycleNumber}%Projected EOC accrual%ProjectedEOCAccrual
    ${ProjectedEOCAccrual}    Remove Comma and Convert to Number    ${ProjectedEOCAccrual}
    ${Computed_ProjectedCycleDue}    Remove Comma and Convert to Number    ${Computed_ProjectedCycleDue}
    ${Computed_ProjectedEOCDue}    Evaluate    ${ProjectedEOCAccrual}-${Computed_ProjectedCycleDue}
    ${ProjectedEOCDue}    Remove Comma and Convert to Number    ${ProjectedEOCDue}
    Should Be Equal As Numbers    ${Computed_ProjectedEOCDue}    ${ProjectedEOCDue}
    # ${CycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Acrual_JavaTree}    ${CycleNumber}%Cycle Due%CycleDue
    # Should Be Equal As Strings    0.00    ${CycleDue}
    ${PaidToDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Acrual_JavaTree}    ${CycleNumber}%Paid to Date%PaidToDate
    ${PaidToDate}    Remove Comma and Convert to Number    ${PaidToDate}
    Should Be Equal As Numbers    ${Computed_ProjectedCycleDue}     ${PaidToDate}

Validate Details on Acrual Tab - Commitment Fee
    [Documentation]    This keyword validates the details on Acrual Tab.
    ...    @author: fmamaril
    ...    update: mgaling    22Aug2019    Added Take Screenshot keyword
    ...    @update: ehugo    05JUN2020    - added keyword pre-processing; updated screenshot location
    ...    @update: mcastro    11DEC2020    - Added Run Keyword And Continue On Failure on validation 
    [Arguments]    ${sComputed_ProjectedCycleDue}    ${sCycleNumber}     

    ### GetRuntime Keyword Pre-processing ###
    ${Computed_ProjectedCycleDue}    Acquire Argument Value    ${sComputed_ProjectedCycleDue}
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}

    mx LoanIQ activate window    ${LIQ_Fee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual
    ${CycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Acrual_JavaTree}    ${CycleNumber}%Cycle Due%CycleDue    
    Run Keyword And Continue On Failure    Should Be Equal As Strings    0.00    ${CycleDue}
    ${PaidToDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Acrual_JavaTree}    ${CycleNumber}%Paid to date%PaidToDate
    ${PaidToDate}    Remove Comma, Negative Character and Convert to Number    ${PaidToDate}    
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${PaidToDate}    ${Computed_ProjectedCycleDue}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FeeWindow_AccrualTab_CommitmentFeeAccruals 
    
Validate Details of Ongoing Fee on Accruals Tab
    [Documentation]    This keyword validates the details on Acrual Tab.
    ...    @author: fmamaril/ghabal
    [Arguments]    ${Computed_ProjectedCycleDue}    ${CycleNumber}     
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual
    ${CycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Acrual_JavaTree}    ${CycleNumber}%Cycle Due%CycleDue
    Should Be Equal As Strings    ${Computed_ProjectedCycleDue}    ${CycleDue}
   
Run Online Acrual to Commitment Fee
    [Documentation]    This keyword runs the online accrual for commitment fee.
    ...    @author: fmamaril
    ...    @update: fmamaril    18SEP2019    Add click to toogle inquiry mode
    ...    @update: ehugo    04JUN2020    - added screenshot
    ...    @update: dahijara    16JUL2020    - Fix warnings - too many variables assigned in Mx LoanIQ Click Button On Window
    ...    @update: makcamps	22OCT2020	 - added click warning buttons if present
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Workflow
    mx LoanIQ click element if present    ${LIQ_OngoingFee_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_CommitmentFee_OnlineAcrual_Menu}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Fee.*;Informational Message.*;OK    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_WorkflowTab_OnlineAccrual
            
Update Cycle on Commitment Fee
    [Documentation]    This keyword populates commitment effective and float rate start date.
    ...    @author: fmamaril
    ...    @update: ehugo    04JUN2020    - added keyword pre-processing and post-processing; added optional runtime variable; added screenshot
    ...    @update: dahijara    16JUL2020    - Fix warnings - too many variables assigned in Mx LoanIQ Click Button On Window
    [Arguments]    ${sFee_Cycle}    ${sRunTimeVar_AdjustedDueDate}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Fee_Cycle}    Acquire Argument Value    ${sFee_Cycle}

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    General
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_CommitmentFee_InquiryMode_Button}
    Mx LoanIQ select combo box value    ${LIQ_CommitmentFee_Cycle_List}    ${Fee_Cycle}
    mx LoanIQ select    ${LIQ_CommitmentFee_Save_Menu}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Fee.*;Informational Message.*;OK    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    ${AdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_AdjustedDueDate}    AdjustedDueDate

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_GeneralTab_CycleList

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_AdjustedDueDate}    ${AdjustedDueDate}

    [Return]    ${AdjustedDueDate}             
 
Compute Commitment Fee Amount Per Cycle
    [Documentation]    This keyword is used in computing the first Projected Cycle Due of the Commitment Fee and saves it to Excel.
    ...    @author: fmamaril
    ...    @update: rtarayao - added an action to get the Rate Basis from the Commitment fee window, and deleted the action getting the cycle frequency as it is not needed in the scripts.
    ...    @update: fmamaril    19MAR2019    Remove writing on Excel for low level keyword
    ...    @update: rtarayao    11APR2019    Principal amount is changed to Balance Amount.
    ...                                      Added Get data for the Balance Amount.
    ...    @update: fmamaril    11SEP2019    
    ...    @update: ehugo    04JUN2020    - added keyword pre-processing and post-processing; added optional runtime argument; added screenshot
    [Arguments]    ${sPrincipalAmount}    ${sRateBasis}    ${sCycleNumber}    ${sSystemDate}    ${sTotal}=None    ${sRunTimeVar_ProjectedCycleDue}=None    ${sAccrualRule}=Pay in Arrears

    ### GetRuntime Keyword Pre-processing ###
    ${PrincipalAmount}    Acquire Argument Value    ${sPrincipalAmount}
    ${RateBasis}    Acquire Argument Value    ${sRateBasis}
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    ${SystemDate}    Acquire Argument Value    ${sSystemDate}
    ${Total}    Acquire Argument Value    ${sTotal}

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_CurrentRate_Field}    value%test
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_RateBasis_Text}    value%test
    ${BalanceAmount}   Run Keyword If    '${Total}' != 'None'    Set Variable    ${PrincipalAmount}
    ...    ELSE    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_BalanceAmount_Field}    value%test   
    ${BalanceAmount}    Remove String    ${BalanceAmount}    ,
    ${BalanceAmount}    Convert To Number    ${BalanceAmount}
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Integer    ${RateBasis}
    ${ProjectedCycleDue}    Evaluate Commitment Fee    ${BalanceAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}    ${SystemDate}
    Log    Projected Cycle Due: ${ProjectedCycleDue}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_FeeAmount

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ProjectedCycleDue}    ${ProjectedCycleDue}

    [Return]    ${ProjectedCycleDue}
    
Evaluate Commitment Fee
    [Documentation]    This keyword evaluates the FIRST Projected Cycle Due on a 'Weekly' cycle.
    ...    @author: fmamaril
    ...    @update: jdelacru - updated actions that assign the value for variable '${Numberof Days}', used ELSE instead of using two Run Keyword If's
    [Arguments]    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}    ${SystemDate}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual
    ${StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Acrual_JavaTree}    ${CycleNumber}%Start Date%startdate
    ${DueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Acrual_JavaTree}    ${CycleNumber}%Due Date%duedate
    Log    ${StartDate}
    Log    ${DueDate}
    ${SystemDate}    Convert Date    ${SystemDate}     date_format=%d-%b-%Y
    ${StartDate}    Convert Date    ${StartDate}     date_format=%d-%b-%Y
    ${DueDate}    Convert Date    ${DueDate}     date_format=%d-%b-%Y
    ${Numberof Days1}    Subtract Date From Date    ${SystemDate}    ${StartDate}    verbose    
    ${Numberof Days2}    Subtract Date From Date    ${DueDate}    ${StartDate}    verbose 
    Log    ${Numberof Days1}
    Log    ${Numberof Days2}
    ${Numberof Days1}    Remove String    ${Numberof Days1}     days    seconds    day
    ${Numberof Days1}    Convert To Number    ${Numberof Days1}
    ${Numberof Days2}    Remove String    ${Numberof Days2}     days    seconds    day
    ${Numberof Days2}    Convert To Number    ${Numberof Days2}        
    ${Numberof Days}   Run Keyword If    '${Numberof Days2}' == '0.0'    Set Variable    ${Numberof Days1}
    ...    ELSE IF    ${Numberof Days1} > ${Numberof Days2}    Set Variable    ${Numberof Days2}    
    ...    ELSE IF    '${Numberof Days1}' == '${Numberof Days2}'    Set Variable    ${Numberof Days2}
    ...    ELSE IF    '${Numberof Days1}' == '0.0'    Set Variable    ${Numberof Days2}    
    ...    ELSE    Set Variable    ${Numberof Days1}
    ${ProjectedCycleDue}    Evaluate    (((${PrincipalAmount})*(${Rate}))*(${Numberof Days}))/${RateBasis}
    ${ProjectedCycleDue}    Convert To Number    ${ProjectedCycleDue}    2
    [Return]    ${ProjectedCycleDue} 
    
Validate GL Entries for Ongoing Fee Payment
    [Documentation]    This keyword validates the GL Entries of the Ongoing Fee Payment.
    ...    @author: fmamaril
    ...    @update: dahijara    16JUL2020    - Fix warnings - too many variables assigned in Mx LoanIQ Click Button On Window
    ...                                      - Removed commented lines
    [Arguments]    ${HostBank_GLAccount}    ${Borrower_GLAccount}    ${Loan_RequestedAmount}     
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    mx LoanIQ select    ${LIQ_CommitmentFee_Queries_GLEntries}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_OngoingFeePayment_GLEntries_Window}  
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_OngoingFeePayment_GLEntries_Table}    ${Borrower_GLAccount}%s  
    ${DebitAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OngoingFeePayment_GLEntries_Table}    ${Borrower_GLAccount}%Debit Amt%test 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_OngoingFeePayment_GLEntries_Table}    ${HostBank_GLAccount}%s    
    ${CreditAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OngoingFeePayment_GLEntries_Table}    ${HostBank_GLAccount}%Credit Amt%test 
    Log    Debit Amount: ${DebitAmount}
    Log    Credit Amount: ${CreditAmount}
    ${DebitAmount}    Remove String    ${DebitAmount}    ,
    ${CreditAmount}    Remove String    ${CreditAmount}    ,    
    ${DebitAmount}    Convert To Number    ${DebitAmount}
    ${CreditAmount}    Convert To Number    ${CreditAmount}
    Should Be Equal    ${DebitAmount}    ${CreditAmount}
    Should Be Equal    ${Loan_RequestedAmount}    ${DebitAmount}
    Should Be Equal    ${Loan_RequestedAmount}    ${CreditAmount}        
    mx LoanIQ click    ${LIQ_OngoingFeePayment_GLEntries_Exit_Button}    

Validate release of Ongoing Fee Payment
    [Documentation]    This keyword validates the release of Ongoing Fee Payment on Events.
    ...    @author: fmamaril
    ...    update: mgaling    22Aug2019 Added Take Screenshot keyword
    ...    @update: ehugo    05JUN2020    - updated screenshot location

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_CommitmentFee_Events_Javatree}   Fee Payment Released
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_EventsTab_OngoingFeePayment
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_CommitmentFee_Events_Javatree}    Fee Payment Released%d
    mx LoanIQ activate window    ${LIQ_OngoingFeePaymentNotebook_Window}
    
Navigate to Cashflow - Ongoing Fee
    [Documentation]    This keyword creates cashflow for the breakfunding
    ...    @author: fmamaril
    ...    @update: ehugo    05JUN2020    - added screenshot
    ...    @update: dahijara    16JUL2020    - Fix warnings - too many variables assigned in Mx LoanIQ Click Button On Window
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Mx LoanIQ DoubleClick    ${LIQ_OngoingFeePayment_WorkflowItems}    Create Cashflows
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_Payment_Cashflows_Window}                 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_Cashflows_Window}    VerificationData="Yes"

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PaymentCashflowsWindow

Validate GL Entries for Ongoing Fee Payment on Secondary Sale
    [Documentation]    This keyword validates the GL Entries of the Ongoing Fee Payment.
    ...    @author: fmamaril
    ...    @update: jdelacru    21MAR2019    - Applied standard GL Entries validation keywords
    ...    @update: dahijara    16JUL2020    - Fix warnings - too many variables assigned in Mx LoanIQ Click Button On Window
    [Arguments]    ${Host_Bank}    ${Borrower1_ShortName}    ${Computed_ProjectedCycleDue}    ${Lender1_ShortName}     
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    mx LoanIQ select    ${LIQ_CommitmentFee_Queries_GLEntries}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_OngoingFeePayment_GLEntries_Window}

    ${HostBank_Debit}    Get GL Entries Amount    ${Host_Bank}    Credit Amt
    ${Lender1_Debit}    Get GL Entries Amount    ${Lender1_ShortName}    Credit Amt
    ${Borrower_Credit}    Get GL Entries Amount    ${Borrower1_ShortName}    Debit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Credit Amt
    ${UITotalCreditAmt}    Get GL Entries Amount    Total For:    Debit Amt
    
    Validate if Debit and Credit Amt is Balanced    ${HostBank_Debit}|${Lender1_Debit}    ${Borrower_Credit}
    Validate if Debit and Credit Amt is equal to Transaction Amount    ${UITotalCreditAmt}    ${UITotalCreditAmt}    ${Computed_ProjectedCycleDue}

Validate GL Entries for Ongoing Fee Payment - Bilateral Deal
    [Documentation]    This keyword validates the GL Entries of the Ongoing Fee Payment.
    ...    @author: fmamaril
    ...    @update: ehugo    05JUN2020    - added keyword pre-processing; added screenshot
    ...                                   - converted 'Loan_RequestedAmount' to number
    ...    @update: dahijara    16JUL2020    - Fix warnings - too many variables assigned in Mx LoanIQ Click Button On Window
    ...    @update: clanding    01DEC2020    - added removing of comma in ${Loan_RequestedAmount}
    [Arguments]    ${sHost_Bank}    ${sBorrower_ShortName}    ${sLoan_RequestedAmount}         

    ### GetRuntime Keyword Pre-processing ###
    ${Host_Bank}    Acquire Argument Value    ${sHost_Bank}
    ${Borrower_ShortName}    Acquire Argument Value    ${sBorrower_ShortName}
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    mx LoanIQ select    ${LIQ_CommitmentFee_Queries_GLEntries}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"	WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_OngoingFeePayment_GLEntries_Window}   
    ${DebitAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OngoingFeePayment_GLEntries_Table}    ${Borrower_ShortName}%Debit Amt%test    
    ${CreditAmount1}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OngoingFeePayment_GLEntries_Table}    ${Host_Bank}%Credit Amt%test      
    Log    Debit Amount: ${DebitAmount}
    Log    Credit Amount: ${CreditAmount1}
    ${DebitAmount}    Remove String    ${DebitAmount}    ,
    ${CreditAmount1}    Remove String    ${CreditAmount1}    ,     
    ${DebitAmount}    Convert To Number    ${DebitAmount}
    ${CreditAmount1}    Convert To Number    ${CreditAmount1}
    ${Loan_RequestedAmount}    Remove String    ${Loan_RequestedAmount}    ,
    ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}                         
    Should Be Equal    ${DebitAmount}    ${CreditAmount1}
    Should Be Equal    ${Loan_RequestedAmount}    ${DebitAmount}
    Should Be Equal    ${Loan_RequestedAmount}    ${CreditAmount1} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeePaymentWindow_ValidateGLEntries
    mx LoanIQ click    ${LIQ_OngoingFeePayment_GLEntries_Exit_Button}
    mx LoanIQ close window    ${LIQ_OngoingFeePaymentNotebook_Window}    
    
Validate Ongoing Fee List
    [Documentation]    This keyword validates the ongoing Fee List from Deal notebook
    ...    @author: ghabal
    ...    @update: rtarayao - removed fee alias argument as it is not being used by the underlying keywords.
    ...    @udpate: dfajardo    22Jul2020    - added pre processing and screenshot
    [Arguments]    ${sFacility_Name}    ${sFee_Type}    ${sProjectedCycleDue}    ${sCycleNumber}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Fee_Type}    Acquire Argument Value    ${sFee_Type}
    ${ProjectedCycleDue}    Acquire Argument Value    ${sProjectedCycleDue}
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    
    Open Ongoing Fee from Deal Notebook    ${Facility_Name}    ${Fee_Type}
    Validate Details of Ongoing Fee on Accruals Tab    ${ProjectedCycleDue}    ${CycleNumber}    
    Validate release of Ongoing Fee Payment
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeNotebook_OngoingFee
    Close All Windows on LIQ
    mx LoanIQ maximize    ${LIQ_Window}
    
Generate Intent Notices for Ongoing Fee Payment
    [Documentation]    This keyword sends Payment Notices to the Borrower and Lender.
    ...    @author: fmamaril
    ...    @update: makcamps	11Nov2020	Added closing of Notice Window
    mx LoanIQ activate window   ${LIQ_OngoingFeePayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow   
    Mx LoanIQ DoubleClick    ${LIQ_OngoingFeePayment_WorkflowItems}    Generate Intent Notices
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    :FOR    ${i}    IN RANGE    1
    \    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False
    mx LoanIQ click element if present    ${LIQ_OngoingFeePayment_Notice_Exit_Button}
    
Verify Status and Notice Method in Notices
    [Documentation]    This keyword verifies the status and notice method in notices for all ongoing fee payments
    ...    @author: fmamaril
    [Arguments]    ${Contact_Email}    ${Customer}    ${Contact}    ${UserID}    ${NoticeMethod}    ${Status}
    mx LoanIQ activate window    ${LIQ_Notice_Window}  
    Mx LoanIQ Select String    ${LIQ_IntentNotice_Information_Table}    ${Customer}\t${Contact}\t${Status}\t${UserID}\t${NoticeMethod}
    Run Keyword If    '${NoticeMethod}'=='Email'    Edit Highlighted Notice    ${Contact_Email}
    
Edit Highlighted Notice
    [Documentation]    This keyword updates the hihglighted notice for all ongoing fee payments
    [Arguments]    ${Contact_Email}   
    mx LoanIQ click    ${LIQ_IntentNotice_EditHighlightedNotice_Button}
    Mx LoanIQ Verify Object Exist    ${LIQ_IntentNotice_Edit_Window}      VerificationData="Yes"
    ${ContactEmail}    Mx LoanIQ Get Data    ${LIQ_IntentNotice_Edit_Email}    value%test
    Log    ${ContactEmail}
    Should Be Equal    ${Contact_Email}    ${ContactEmail}          
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=.* Notice created.*").JavaStaticText("attached text:=Awaiting release")    Verified_Status    
    Should Be Equal As Strings    Awaiting release    ${Verified_Status}
    Mx LoanIQ Close    ${LIQ_IntentNotice_Edit_Window}    

Close Notice Window
    [Documentation]    This keyword closes the window for all ongoing fee payments
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    mx LoanIQ click    ${LIQ_Notice_Exit_Button}
        
Get Data in General Tab
    [Documentation]    This keyword navigates to General Tab wherein it gets and convert the data that will be used for the validation.
    ...    @author:mgaling
    ...    update: mgaling    15Aug2019   Removed the Write data to Excel scripts
    
    mx LoanIQ activate window    ${LIQ_CommitmentFeeNotebook_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    General
    
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_CurrentRate_Field}    value%test
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
           
    
    ${BalanceAmount}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_BalanceAmount_Field}    value%test 
    ${BalanceAmount}    Remove String    ${BalanceAmount}    ,
    ${BalanceAmount}    Convert To Number    ${BalanceAmount}
   
        
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_RateBasis_Text}    text%test 
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Integer    ${RateBasis}
    
    [Return]    ${Rate}    ${BalanceAmount}    ${RateBasis}  

Navigate and Verify Accrual Tab
    [Documentation]    This keyword is used for navigating and verifies data in Accrual Tab.
    ...    @author:mgaling
    ...    @update: updated the value to be fetched from the javatree from Projected EOC due to Projected EOC accrual.
    ...    @update: dahijara    14JUL2020    - added pre-processing keywords and screenshot
    ...    @update: dahijara    16JUL2020    - removed writing to excel; added return and post processing keywords
    [Arguments]    ${sRowid}    ${sCycleNo}    ${sRunVar_StartDate}=None    ${sRunVar_EndDate}=None    ${sRunVar_DueDate}=None    ${sRunVar_CycleDue}=None    ${sRunVar_ProjectedCycleDue}=None
    ...    ${sRunVar_Orig_TotalCycleDue}=None    ${sRunVar_Orig_TotalManualAdjustment}=None    ${sRunVar_Orig_TotalProjectedEOCAccrual}=None
    ### GetRuntime Keyword Pre-processing ###
    ${rowid}    Acquire Argument Value    ${sRowid}
    ${CycleNo}    Acquire Argument Value    ${sCycleNo}
    
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}            VerificationData="Yes"
    
    ${StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Start Date%value    
    ${EndDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%End Date%value
    ${DueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Due Date%value
    ${CycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Cycle Due%value
    ${ProjectedCycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Projected EOC due%value
    ${Orig_TotalCycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    TOTAL: %Cycle Due%value       
    ${Orig_TotalManualAdjustment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    TOTAL: %Manual adjustmt%value
    ${Orig_TotalProjectedEOCAccrual}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    TOTAL: %Projected EOC accrual%value
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_AccrualTab
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_StartDate}    ${StartDate}
    Save Values of Runtime Execution on Excel File    ${sRunVar_EndDate}    ${EndDate}
    Save Values of Runtime Execution on Excel File    ${sRunVar_DueDate}    ${DueDate}
    Save Values of Runtime Execution on Excel File    ${sRunVar_CycleDue}    ${CycleDue}
    Save Values of Runtime Execution on Excel File    ${sRunVar_ProjectedCycleDue}    ${ProjectedCycleDue}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_TotalCycleDue}    ${Orig_TotalCycleDue}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_TotalManualAdjustment}    ${Orig_TotalManualAdjustment}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Orig_TotalProjectedEOCAccrual}    ${Orig_TotalProjectedEOCAccrual}
	
    [Return]    ${StartDate}    ${EndDate}    ${DueDate}    ${CycleDue}    ${ProjectedCycleDue}    ${Orig_TotalCycleDue}    ${Orig_TotalManualAdjustment}    ${Orig_TotalProjectedEOCAccrual}
    

Navigate and Verify Accrual Share Adjustment Notebook
    [Documentation]    This keyword is used for navigating Accrual Share Adjustment Notebook from Commitment Notebook.
    ...    @author:mgaling
    [Arguments]    ${StartDate}    ${Deal_Name}    ${Facility_Name}    ${Deal_Borrower}    ${OngoingFee_Type}    ${CurrentCycleDue_Value}    ${ProjectedCycleDue_Value}           
       
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual 
    Mx LoanIQ Select String    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${StartDate}  
    # Mx Native Type    {DOWN 1}
    mx LoanIQ click    ${LIQ_CommitmentFeeNotebook_CycleShareAdjustment_Button}
    mx LoanIQ activate window    ${LIQ_AccrualSharesAdjustment_Window} 
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Deal_Name}")      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Facility_Name}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Deal_Borrower}")        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${OngoingFee_Type}")    VerificationData="Yes"
    
    ###Amounts Section###
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaEdit("x:=231","y:=51", "value:=${CurrentCycleDue_Value}")      VerificationData="Yes"
    # Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaEdit("x:=231","y:=84", "value:=${ProjectedCycleDue_Value}")    VerificationData="Yes"
    
Validate Manual Adjustment Value
    [Documentation]    This keyword is used for navigating back to Commitment Notebook to validate if the requested amount reflects in Manual Adjustment column.
    ...    @author:mgaling
    ...    @update: dahijara    15JUL2020    - Added pre processing and screenshot
    [Arguments]    ${sCycleNo}    ${sRequested_Amount}    
    ### GetRuntime Keyword Pre-processing ###
    ${CycleNo}    Acquire Argument Value    ${sCycleNo}
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}
    
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual
    ${ManualAdj_Value}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Manual adjustmt%value    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Accrual
    Should Be Equal    ${Requested_Amount}    ${ManualAdj_Value}
    Log    ${Requested_Amount}=${ManualAdj_Value} 
 
Validate Cycle Due New Value
    [Documentation]    This keyword is used for navigating back to Commitment Notebook to validate if the requested amount added in Cycle Due column.
    ...    @author:mgaling
    ...    @update: dahijara    15JUL2020    - Added pre processing and screenshot
    [Arguments]    ${sCycleNo}    ${sCycleDue}    ${sRequested_Amount}     
    ### GetRuntime Keyword Pre-processing ###
    ${CycleNo}    Acquire Argument Value    ${sCycleNo}
    ${CycleDue}    Acquire Argument Value    ${sCycleDue}
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}

    ###Get the New Cycle Due and Convert to Number###
    ${CycleDue_NewValue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Cycle Due%value
    ${CycleDue_NewValue}    Remove String    ${CycleDue_NewValue}    ,
    ${CycleDue_NewValue}    Convert To Number    ${CycleDue_NewValue}    2 
    
    ###Cycle Due Original Value - Convert to Number###
    ${CycleDue_OriginalValue}    Remove String    ${CycleDue}    ,
    ${CycleDue_OriginalValue}    Convert To Number    ${CycleDue_OriginalValue}    2 
    
    ###Calculate the New Cycle Due based on the adjustment###
    ${Requested_Amount}    Remove String    ${Requested_Amount}    ,
    ${Requested_Amount}    Convert To Number    ${Requested_Amount}    2 
    
    ${Calculated_CycleDue}    Evaluate    ${CycleDue_OriginalValue}+${Requested_Amount}         
    ${Calculated_CycleDue}    Convert To Number    ${Calculated_CycleDue}    2
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Accrual
    Should Be Equal    ${Calculated_CycleDue}    ${CycleDue_NewValue}
    Log    ${Calculated_CycleDue}=${CycleDue_NewValue}        
     
Validate Projected EOC Due New Value
    [Documentation]    This keyword is used for navigating back to Commitment Notebook to validate if the requested amount added in Projected EOC due column.
    ...    @author:mgaling
    ...    @update: dahijara    15JUL2020    - Added pre processing and screenshot
    [Arguments]    ${sCycleNo}    ${sProjectedCycleDue}    ${sRequested_Amount}     
    ### GetRuntime Keyword Pre-processing ###
    ${CycleNo}    Acquire Argument Value    ${sCycleNo}
    ${ProjectedCycleDue}    Acquire Argument Value    ${sProjectedCycleDue}
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}

    ###Get the New Cycle Due and Convert to Number###
    ${PEOCDue_NewValue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Projected EOC due%value
    ${PEOCDue_NewValue}    Remove String    ${PEOCDue_NewValue}    ,
    ${PEOCDue_NewValue}    Convert To Number    ${PEOCDue_NewValue}    2 
    
    ###Cycle Due Original Value - Convert to Number###
    ${PEOCDue_OriginalValue}    Remove String    ${ProjectedCycleDue}    ,
    ${PEOCDue_OriginalValue}    Convert To Number    ${PEOCDue_OriginalValue}    2 
    
    ###Calculate the New Cycle Due based on the adjustment###
    ${Requested_Amount}    Remove String    ${Requested_Amount}    ,
    ${Requested_Amount}    Convert To Number    ${Requested_Amount}    2 
    
    ${Calculated_PEOCDue}    Evaluate    ${PEOCDue_OriginalValue}+${Requested_Amount}
    ${Calculated_PEOCDue}    Convert To Number    ${Calculated_PEOCDue}    2         
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Accrual
    Should Be Equal    ${Calculated_PEOCDue}    ${PEOCDue_NewValue}
    Log    ${Calculated_PEOCDue}=${PEOCDue_NewValue}              

Validate Manual Adjustment Total Value
    [Documentation]    This keyword is used for checking the Total Amount.
    ...    @author:mgaling
    ...    @update: dahijara    15JUL2020    - Added pre processing and screenshot
    [Arguments]    ${srowid}    ${sRequested_Amount} 
    ### GetRuntime Keyword Pre-processing ###
    ${rowid}    Acquire Argument Value    ${srowid}
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}

    ${New_TotalManualAdjustment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    TOTAL: %Manual adjustmt%value
    Write Data To Excel    MTAM06B_CycleShareAdjustment    New_TotalManualAdjustment    ${rowid}    ${New_TotalManualAdjustment}
    ${New_TotalManualAdjustment}    Remove String    ${New_TotalManualAdjustment}    ,
    ${New_TotalManualAdjustment}    Convert To Number    ${New_TotalManualAdjustment}    2 
    
    ${Orig_TotalManualAdjustment}    Read Data From Excel    MTAM06B_CycleShareAdjustment    Orig_TotalManualAdjustment    ${rowid} 
    ${Orig_TotalManualAdjustment}    Remove String    ${Orig_TotalManualAdjustment}    ,
    ${Orig_TotalManualAdjustment}    Convert To Number    ${Orig_TotalManualAdjustment}    2
    
    ${Requested_Amount}    Remove String    ${Requested_Amount}    ,
    ${Requested_Amount}    Convert To Number    ${Requested_Amount}    2
    
    ${Calculated_TotalCycleDue}    Evaluate    ${Orig_TotalManualAdjustment}+${Requested_Amount}
    ${Calculated_TotalCycleDue}    Convert To Number    ${Calculated_TotalCycleDue}    2
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Accrual
    Should Be Equal    ${New_TotalManualAdjustment}    ${Calculated_TotalCycleDue}
    Log    ${New_TotalManualAdjustment}=${Calculated_TotalCycleDue}        
    
    
Validate Cycle Due Total Value
    [Documentation]    This keyword is used for checking the Total Amount.
    ...    @author:mgaling
    ...    @update: dahijara    15JUL2020    - Added pre processing and screenshot
    [Arguments]    ${srowid}    ${sRequested_Amount} 
    ### GetRuntime Keyword Pre-processing ###
    ${rowid}    Acquire Argument Value    ${srowid}
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}

    ${New_TotalCycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    TOTAL: %Cycle Due%value       
    Write Data To Excel    MTAM06B_CycleShareAdjustment    New_TotalCycleDue    ${rowid}    ${New_TotalCycleDue}
    ${New_TotalCycleDue}    Remove String    ${New_TotalCycleDue}    ,
    ${New_TotalCycleDue}    Convert To Number    ${New_TotalCycleDue}    2 
    
    ${Orig_TotalCycleDue}    Read Data From Excel    MTAM06B_CycleShareAdjustment    Orig_TotalCycleDue    ${rowid}
    ${Orig_TotalCycleDue}    Remove String    ${Orig_TotalCycleDue}    ,
    ${Orig_TotalCycleDue}    Convert To Number    ${Orig_TotalCycleDue}    2
    
    ${Requested_Amount}    Remove String    ${Requested_Amount}    ,
    ${Requested_Amount}    Convert To Number    ${Requested_Amount}    2
    
    ${Calculated_TotalCycleDue}    Evaluate    ${Orig_TotalCycleDue}+${Requested_Amount}
    ${Calculated_TotalCycleDue}    Convert To Number    ${Calculated_TotalCycleDue}    2      
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Accrual
    Should Be Equal    ${New_TotalCycleDue}    ${Calculated_TotalCycleDue}
    Log    ${New_TotalCycleDue}=${Calculated_TotalCycleDue}     

Validate Projected EOC Due Total Value
    [Documentation]    This keyword is used for checking the Total Amount.
    ...    @author:mgaling
    [Arguments]    ${rowid}    ${Requested_Amount} 
    ${New_TotalProjectedEOCDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    TOTAL: %Projected EOC due%value
    Write Data To Excel    MTAM06B_CycleShareAdjustment    New_TotalProjectedEOCDue    ${rowid}    ${New_TotalProjectedEOCDue}
    ${New_TotalProjectedEOCDue}    Remove String    ${New_TotalProjectedEOCDue}    ,
    ${New_TotalProjectedEOCDue}    Convert To Number    ${New_TotalProjectedEOCDue}    2 
    
                    
    ${Orig_TotalProjectedEOCDue}    Read Data From Excel    MTAM06B_CycleShareAdjustment    Orig_TotalProjectedEOCDue    ${rowid}
    ${Orig_TotalProjectedEOCDue}    Remove String    ${Orig_TotalProjectedEOCDue}    ,
    ${Orig_TotalProjectedEOCDue}    Convert To Number    ${Orig_TotalProjectedEOCDue}    2 
    
    ${Requested_Amount}    Remove String    ${Requested_Amount}    ,
    ${Requested_Amount}    Convert To Number    ${Requested_Amount}    2
    
    ${Calculated_TotalProjEOCDue}    Evaluate    ${Orig_TotalProjectedEOCDue}+${Requested_Amount}
    ${Calculated_TotalProjEOCDue}    Convert To Number    ${Calculated_TotalProjEOCDue}    2
    
    Should Be Equal    ${New_TotalProjectedEOCDue}    ${Calculated_TotalProjEOCDue}
    Log    ${New_TotalProjectedEOCDue}=${Calculated_TotalProjEOCDue}
    
    mx LoanIQ close window    ${LIQ_CommitmentFeeNotebook_Window}
    mx LoanIQ close window    ${LIQ_Facility_FeeList}    
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}

Create Payment Reversal
    [Documentation]    This keyword initiates payment reversal after Fee Payment is released.
    ...    @author: chanario
    ...    @update: dahijara    16JUL2020    - added pre processing and screenshot.
    [Arguments]    ${sReversal_Comment}    ${sSystemDate}    ${sEffectiveDate_Label}    ${sWindow}    ${sFeePaymentAmount}
    ### GetRuntime Keyword Pre-processing ###
    ${Reversal_Comment}    Acquire Argument Value    ${sReversal_Comment}
    ${SystemDate}    Acquire Argument Value    ${sSystemDate}
    ${EffectiveDate_Label}    Acquire Argument Value    ${sEffectiveDate_Label}
    ${Window}    Acquire Argument Value    ${sWindow}
    ${FeePaymentAmount}    Acquire Argument Value    ${sFeePaymentAmount}

    mx LoanIQ activate window    ${LIQ_OngoingFeePaymentNotebook_Window}  
    mx LoanIQ select    ${LIQ_CommitmentFee_ReversePayment}
    Verify If Warning Is Displayed
    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}
    
    ###Verify Window Status after Reverse Payment creation is initiated- now Pending###
    Validate Window Title Status    ${Window}    Pending
    
    ###Verify if effective date is matched with the Fee payment Effective Date and not editable###
    Validate if Element is Not Editable    ${LIQ_ReversePayment_EffectiveDate}    ${EffectiveDate_Label}    
    ${EffectiveDate_Reversal}    Mx LoanIQ Get Data    ${LIQ_ReversePayment_EffectiveDate}    value%test
    Run Keyword And Continue On Failure    Should Be Equal    ${EffectiveDate_Reversal}    ${SystemDate}        
    ${EffectiveDateReversal_status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${EffectiveDate_Reversal}    ${SystemDate}    

    Run Keyword If    ${EffectiveDateReversal_status}==True    Log    Effective Date of Fee Payment and Reversal matched.
    ...    ELSE    Log    Discrepancy in Fee payment effective date and reversal payment date.    level=Error          
            
    ###Verify if Requested Reversal amount is matched with the Fee payment Amount and not editable###
    ${RequestedAmount_Reversal}    Mx LoanIQ Get Data    ${LIQ_ReversePayment_Amount}    value%test
    
    ${FeePaymentAmount}    Remove comma and convert to number    ${FeePaymentAmount}
    ${RequestedAmount_Reversal}    Remove comma and convert to number    ${RequestedAmount_Reversal}
    
    Run Keyword And Continue On Failure    Should Be Equal    ${RequestedAmount_Reversal}    ${FeePaymentAmount}        
    ${ReversalAmount_status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${RequestedAmount_Reversal}    ${FeePaymentAmount} 

    Run Keyword If    ${ReversalAmount_status}==True    Log    Requested Amount is made in FULL.
    ...    ELSE    Run Keywords    mx LoanIQ enter    ${LIQ_ReversePayment_Amount}    ${FeePaymentAmount}        
    ...    AND    Log    Discrepancy Requested Reversal Amount and Fee Payment, Requested Amount is altered to match full amount.    level=WARN  
    
    ###Supply Reversal comment stating that Interest is waived###
    mx LoanIQ enter    ${LIQ_ReversePayment_Comment_Textfield}    ${Reversal_Comment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ReversePayment
    mx LoanIQ click    ${LIQ_ReversePayment_UpdateMode_Button}   
    
    ${Question_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Question_OK_Button}    VerificationData="Yes"
    Run Keyword If    ${Question_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Question_OK_Button}
    
    ###Verify that the Reversal comment is saved###
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Commitment Fee Reverse Fee.*").JavaEdit("value:=.*${Reversal_Comment}")    VerificationData="Yes"
    ${Comment_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Commitment Fee Reverse Fee.*").JavaEdit("value:=.*${Reversal_Comment}")    VerificationData="Yes"
    Run Keyword If    ${Comment_Status}==True    Log    Reason for Payment Reversal is applied.
    ...    ELSE    Log    Reason for Payment Reversal - Comment is not applied.    level=WARN  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ReversePayment  
   
Validate Payment Reversal in Accrual Tab
    [Documentation]    This keyword is used for navigating back to Commitment Notebook to validate if the requested Reversal amount is reflected on the Accrual Tab.
    ...    @author:chanario
    ...    @update:dahijara    16JUL2020    - added pre processing and screenshot
    [Arguments]    ${sCycleNo}    ${sCycleDue_Expected}    ${sPaidtodate_Expected}
    ### GetRuntime Keyword Pre-processing ###
    ${CycleNo}    Acquire Argument Value    ${sCycleNo}
    ${CycleDue_Expected}    Acquire Argument Value    ${sCycleDue_Expected}
    ${Paidtodate_Expected}    Acquire Argument Value    ${sPaidtodate_Expected}

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual

    ${Paidtodate_Expected}    Convert To String    ${Paidtodate_Expected}
    ${CycleDue_Expected}    Convert To String    ${CycleDue_Expected}    
    ${Paidtodate_Expected}    Remove comma and convert to number    ${Paidtodate_Expected}
    ${CycleDue_Expected}    Remove comma and convert to number    ${CycleDue_Expected}
         
    ###Validate that Cycle Due is now set back with the amount Requested for reversal###
    ${CycleDue_Value}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Cycle Due%value    
    ${CycleDue_Value}    Convert To String    ${CycleDue_Value}
    ${CycleDue_Value}    Remove comma and convert to number    ${CycleDue_Value}
       
    Run Keyword and Continue on Failure    Should Be Equal    ${CycleDue_Expected}    ${CycleDue_Value}
    ${CycleDue_Status}    Run Keyword and Return Status    Run Keyword and Continue on Failure    Should Be Equal    ${CycleDue_Expected}    ${CycleDue_Value}    
    Run Keyword If    ${CycleDue_Status}==True    Log    Verified that reversal is successful! Previous Fee Payment:${CycleDue_Expected} is reflected back as Cycle Due Amount:${CycleDue_Value}
    ...    ELSE    Log    Payment Reversal is unsuccessful! Previous Fee Payment is not relected back in the Cycle Due.    level=Error

    ###Validate that Paid to date value is now set back to zero###
    ${Paidtodate_Value}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Paid to date%value    
    ${Paidtodate_Value}    Remove comma and convert to number    ${Paidtodate_Value}
    Run Keyword and Continue on Failure    Should Be Equal    ${Paidtodate_Value}    ${Paidtodate_Expected}
    ${Paidtodate_status}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${Paidtodate_Value}    ${Paidtodate_Expected}        
    Run Keyword If    ${Paidtodate_status}==True    Log    Verified that reversal is successful! Paid to date is set to zero.
    ...    ELSE    Log    Payment Reversal is unsuccessful! Previous Fee Payment (${Paidtodate_Value}) is still reflecting as Paid to date.    level=Error
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeNotebook_Accrual
    
Validate Payment Reversal in Events Tab
        
    [Documentation]    This keyword is used for navigating back to Commitment Notebook to validate if the requested Reversal amount is reflected on the Events Tab.
    ...    @author:chanario
    ...    @update: dahijara    16JUL2020    - added pre processing keywords and screenshot
    [Arguments]    ${sEvent}    ${sRequested_Amount}    ${sEffectiveDate}    ${sDebitAmt_Customer}    ${sCreditAmt_Customer}
    ...    ${sDebitAmt_Host}    ${sCreditAmt_Host}    ${sTotalDebitAmt}    ${sTotalCreditAmt}    ${sCustomer}    ${sHost}    
    ### GetRuntime Keyword Pre-processing ###
    ${Event}    Acquire Argument Value    ${sEvent}
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${DebitAmt_Customer}    Acquire Argument Value    ${sDebitAmt_Customer}
    ${CreditAmt_Customer}    Acquire Argument Value    ${sCreditAmt_Customer}
    ${DebitAmt_Host}    Acquire Argument Value    ${sDebitAmt_Host}
    ${CreditAmt_Host}    Acquire Argument Value    ${sCreditAmt_Host}
    ${TotalDebitAmt}    Acquire Argument Value    ${sTotalDebitAmt}
    ${TotalCreditAmt}    Acquire Argument Value    ${sTotalCreditAmt}
    ${Customer}    Acquire Argument Value    ${sCustomer}
    ${Host}    Acquire Argument Value    ${sHost}

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Events
    Run Keyword and Continue on Failure    Mx LoanIQ Select String    ${LIQ_CommitmentFee_Events_Javatree}   Reverse Payment Released
    
    ###Copy latest log for Payment Fee Reversal###
    ${Comment_EventLog}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Events_Javatree}    ${Event}%Comment%Comment_EventLog
            
    ###Generate expected Comment###
    
    ${Amount_L}    Remove comma and convert to number    ${Requested_Amount}
    ${length}    Get Length    ${Amount_L}
    ${length}    Evaluate    int(${length})
    ${Reversepayment_String}    Convert To String    ${Amount_L}    
    ${Reversepayment_Alias_Hundreds}    Remove comma and convert to number    ${Reversepayment_String}
    ${Reversepayment_Alias_Hundreds}    Evaluate    "%.2f" % ${Reversepayment_Alias_Hundreds}            
    
    ${Reversepayment_Alias_Thousands}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${Reversepayment_Alias_Hundreds}
            
    ###Access Reverse Fee Window###
    ${ExpectedComment_AfterReversal}    Run Keyword If    '${Reversepayment_Alias_Thousands}'=='None'    Set Variable    Reverse Fee of ${Reversepayment_Alias_Hundreds} has been applied.
    ...    ELSE    Set Variable    Reverse Fee of ${Reversepayment_Alias_Thousands} has been applied.
 
    ###Compare expected with actual###
    Run Keyword And Continue On Failure    Should Be Equal    ${Comment_EventLog}    ${ExpectedComment_AfterReversal}
    ${Comment_Status}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${Comment_EventLog}    ${ExpectedComment_AfterReversal}                
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Events
    ###Additional validation for Effective Date###
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_CommitmentFee_Events_Javatree}    Reverse Payment Released%d
    
    ${EffectiveDate_Reversal}    Mx LoanIQ Get Data    ${LIQ_ReversePayment_EffectiveDate}    value%test
    Run Keyword And Continue On Failure    Should Be Equal    ${EffectiveDate_Reversal}    ${EffectiveDate}        
    ${EffectiveDateReversal_status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${EffectiveDate_Reversal}    ${EffectiveDate}    
    
    Run Keyword If    ${EffectiveDateReversal_status}==True and ${Comment_Status}==True      Log    Successful Payment Reversal!    level=INFO
    ...    ELSE    Log    Unsuccessful Payment Reversal!	level=ERROR
    
    ###Verify correctness of GL Entries Data###
    Validate GL Entries for Payment Reversal    ${ExcelPath}    ${DebitAmt_Customer}    ${CreditAmt_Customer}    ${DebitAmt_Host}    ${CreditAmt_Host}    ${TotalDebitAmt}    ${TotalCreditAmt}    ${Customer}    ${Host}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Events
    
Validate GL Entries for Payment Reversal
    [Documentation]    This keyword is used to validate the GL Entries for Payment Reversal.
    ...    @author:chanario    
    ...    @update: dahijara    16JUL2020    - Added pre processing and screenshot
    [Arguments]    ${sExcelPath}    ${sDebitAmt_Customer}    ${sCreditAmt_Customer}    ${sDebitAmt_Host}    ${sCreditAmt_Host}    ${sTotalDebitAmt}    ${sTotalCreditAmt}    ${sCustomer_Name}    ${sHost}         
    
    ### GetRuntime Keyword Pre-processing ###
    ${ExcelPath}    Acquire Argument Value    ${sExcelPath}
    ${DebitAmt_Customer}    Acquire Argument Value    ${sDebitAmt_Customer}
    ${CreditAmt_Customer}    Acquire Argument Value    ${sCreditAmt_Customer}
    ${DebitAmt_Host}    Acquire Argument Value    ${sDebitAmt_Host}
    ${CreditAmt_Host}    Acquire Argument Value    ${sCreditAmt_Host}
    ${TotalDebitAmt}    Acquire Argument Value    ${sTotalDebitAmt}
    ${TotalCreditAmt}    Acquire Argument Value    ${sTotalCreditAmt}
    ${Customer_Name}    Acquire Argument Value    ${sCustomer_Name}
    ${Host}    Acquire Argument Value    ${sHost}

    mx LoanIQ select    ${LIQ_ReversePayment_Queries_GLEntries}
    mx LoanIQ activate window    ${LIQ_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_GLEntries_Window}
    
    ###Retrieve values for debit and credit amounts for Customer and Host as well as Total Amount###
    
    ${Branch}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Customer_Name}%Branch%Branch
    
    ${DebitAmt_CustomerAfterReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Customer_Name}%Debit Amt%DebitAmt
    ${CreditAmt_CustomerAfterReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Customer_Name}%Credit Amt%CreditAmt
    
    ${DebitAmt_CustomerAfterReversal}    Run Keyword If    '${DebitAmt_CustomerAfterReversal}'!=''    Remove comma and convert to number    ${DebitAmt_CustomerAfterReversal}      
    ...    ELSE    Log    Customer Debit Amount is NULL.
   
    ${CreditAmt_CustomerAfterReversal}    Run Keyword If    '${CreditAmt_CustomerAfterReversal}'!=''    Remove comma and convert to number    ${CreditAmt_CustomerAfterReversal}
    ...    ELSE    Log    Customer Credit Amount is NULL.
    
    ${DebitAmt_HostAfterReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Host}%Debit Amt%DebitAmt
    ${CreditAmt_HostAfterReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Host}%Credit Amt%CreditAmt
    
    ${DebitAmt_HostAfterReversal}    Run Keyword If    '${DebitAmt_HostAfterReversal}'!=''    Remove comma and convert to number    ${DebitAmt_HostAfterReversal}      
    ...    ELSE    Log    Host Debit Amount is NULL.
   
    ${CreditAmt_HostAfterReversal}    Run Keyword If    '${CreditAmt_HostAfterReversal}'!=''    Remove comma and convert to number    ${CreditAmt_HostAfterReversal}
    ...    ELSE    Log    Host Credit Amount is NULL.
    
    ${Branch}    Set Variable    ${Branch.strip()}    
    ${TotalAmount}    Catenate     ${space}Total For:    ${Branch}
            
    ${TotalDebitAmtAfterReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${TotalAmount}%Debit Amt%TotalDebitAmt
    ${TotalCreditAmtAfterReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}   ${TotalAmount}%Credit Amt%TotalCreditAmt                              

    ${TotalDebitAmtAfterReversal}    Run Keyword If    '${TotalDebitAmtAfterReversal}'!=''    Remove comma and convert to number    ${TotalDebitAmtAfterReversal}      
    ...    ELSE    Log    Total Debit Amount is NULL.
   
    ${TotalCreditAmtAfterReversal}    Run Keyword If    '${TotalCreditAmtAfterReversal}'!=''    Remove comma and convert to number    ${TotalCreditAmtAfterReversal}
    ...    ELSE    Log    Total Credit Amount is NULL.
    
    ###Verify that Fee Payment values interchanged with the Payment reversal values###
        
    ${CreditAmt_Customer}    Run Keyword If    '${CreditAmt_Customer}'!=''    Remove comma and convert to number    ${CreditAmt_Customer}      
    ...    ELSE    Log    Before Reversal : Customer Credit Amount is NULL.
   
    ${DebitAmt_Customer}    Run Keyword If    '${DebitAmt_Customer}'!=''    Remove comma and convert to number    ${DebitAmt_Customer}
    ...    ELSE    Log    Before Reversal : Customer Debit Amount is NULL.

    Run Keyword And Continue On Failure    Should Be Equal    ${DebitAmt_CustomerAfterReversal}    ${CreditAmt_Customer}
    ${CustomerDebit_Status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${DebitAmt_CustomerAfterReversal}    ${CreditAmt_Customer}
    Run Keyword And Continue On Failure    Should Be Equal    ${CreditAmt_CustomerAfterReversal}    ${DebitAmt_Customer}
    ${CustomerCredit_Status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${CreditAmt_CustomerAfterReversal}    ${DebitAmt_Customer}
    
    Run Keyword If    ${CustomerDebit_Status}==True and ${CustomerCredit_Status}==True    Log    Customer Debit and Credit Data are correct.
    ...    ELSE    Log    Customer Debit and Credit Data are incorrect!    level=ERROR     
    
    ${DebitAmt_Host}    Run Keyword If    '${DebitAmt_Host}'!=''    Remove comma and convert to number    ${DebitAmt_Host}      
    ...    ELSE    Log    Before Reversal : Host Debit Amount is NULL.
   
    ${CreditAmt_Host}    Run Keyword If    '${CreditAmt_Host}'!=''    Remove comma and convert to number    ${CreditAmt_Host}
    ...    ELSE    Log    Before Reversal : Host Credit Amount is NULL.    
    
    Run Keyword And Continue On Failure    Should Be Equal    ${DebitAmt_HostAfterReversal}    ${CreditAmt_Host}
    ${HostDebit_Status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${DebitAmt_HostAfterReversal}    ${CreditAmt_Host}
    Run Keyword And Continue On Failure    Should Be Equal    ${CreditAmt_HostAfterReversal}    ${DebitAmt_Host}
    ${HostDebit_Status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${CreditAmt_HostAfterReversal}    ${DebitAmt_Host}
    
    Run Keyword If    ${HostDebit_Status}==True and ${HostDebit_Status}==True    Log    Host Debit and Credit Data are correct.
    ...    ELSE    Log    Host Debit and Credit Data are incorrect!    level=ERROR    

    ${TotalDebitAmt}    Run Keyword If    '${TotalDebitAmt}'!=''    Remove comma and convert to number    ${TotalDebitAmt}      
    ...    ELSE    Log    Before Reversal : Total Debit Amount is NULL.
   
    ${TotalCreditAmt}    Run Keyword If    '${TotalCreditAmt}'!=''    Remove comma and convert to number    ${TotalCreditAmt}
    ...    ELSE    Log    Before Reversal : Total Credit Amount is NULL.    
    
    Run Keyword And Continue On Failure    Should Be Equal    ${TotalDebitAmtAfterReversal}    ${TotalCreditAmt}
    ${TotalDebit_Status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal   ${TotalDebitAmtAfterReversal}    ${TotalCreditAmt}
    Run Keyword And Continue On Failure    Should Be Equal    ${TotalCreditAmtAfterReversal}    ${TotalDebitAmt}
    ${TotalCredit_Status}    Run Keyword and Return Status    Run Keyword And Continue On Failure    Should Be Equal   ${TotalCreditAmtAfterReversal}    ${TotalDebitAmt}
    
    Run Keyword If    ${TotalDebit_Status}==True and ${TotalCredit_Status}==True    Log    Total Debit and Credit Data are correct.
    ...    ELSE    Log    Total Debit and Credit Data are incorrect!    level=ERROR    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GL_Entries

Retrieve Intial Amounts in Accrual Tab and Evaluate Expected Values for Reversal Post Validation
    [Documentation]    This keyword is used retrieve Paid to date and  Cycle Due values on the accrual tab before processing Payment Reversal. Expected amount are also computed.
    ...    @author:chanario
    ...    @update: dahijara    16JUL2020    - Added pre and post processing keywords; Screenshot; Added optional arguments for runtime variable.
    [Arguments]    ${sCycleNo}    ${sReversalAmount}    ${sRunVar_CycleDue_Expected}=None    ${sRunVar_Paidtodate_Expected}=None

    ### GetRuntime Keyword Pre-processing ###
    ${CycleNo}    Acquire Argument Value    ${sCycleNo}
    ${ReversalAmount}    Acquire Argument Value    ${sReversalAmount}

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual

    ###Retrieve Cycle Due before Payment Reversal###
    ${CycleDue_beforeReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Cycle Due%value              
    ${CycleDue_beforeReversal}    Remove comma and convert to number    ${CycleDue_beforeReversal}
    
    ###Retrieve Paid to date before Payment Reversal###
    ${Paidtodate_beforeReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFeeNotebook_Accrual_JavaTree}    ${CycleNo}%Paid to date%value
    ${Paidtodate_beforeReversal}    Remove comma and convert to number    ${Paidtodate_beforeReversal}
    
    ###Evaluate Values for Post Validation###
    ${ReversalAmount}    Remove comma and convert to number    ${ReversalAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Accrual
    ${CycleDue_Expected}    Evaluate    ${CycleDue_beforeReversal}+${ReversalAmount}
    ${Paidtodate_Expected}    Evaluate    ${Paidtodate_beforeReversal}-${ReversalAmount}
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_CycleDue_Expected}    ${CycleDue_Expected}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Paidtodate_Expected}    ${Paidtodate_Expected}
    [RETURN]    ${CycleDue_Expected}    ${Paidtodate_Expected}    
    
Retrieve Initial Data From GL Entries After Payment
    
    [Documentation]    This keyword is used retrieve GL Entries detailsof the Fee Payment Released.
    ...    @author:chanario
    ...    @update: dahijara    16JUL2020    - Added pre and post processing keywords; screenshot; optional arguments for runtime variable
    [Arguments]    ${sCustomer_Name}    ${sHost_ShortName}    ${sFeePayment_Date}    ${sFeePayment_Time}    ${sFeePayment_User}    ${sEffectiveDate_FeePayment}    ${sFeePayment_Comment}
    ...    ${sRunVar_DebitAmt_Customer}=None    ${sRunVar_CreditAmt_Customer}=None    ${sRunVar_DebitAmt_Host}=None    ${sRunVar_CreditAmt_Host}=None    ${sRunVar_TotalDebitAmt}=None    ${sRunVar_TotalCreditAmt}=None
    ### GetRuntime Keyword Pre-processing ###
    ${Customer_Name}    Acquire Argument Value    ${sCustomer_Name}
    ${Host_ShortName}    Acquire Argument Value    ${sHost_ShortName}
    ${FeePayment_Date}    Acquire Argument Value    ${sFeePayment_Date}
    ${FeePayment_Time}    Acquire Argument Value    ${sFeePayment_Time}
    ${FeePayment_User}    Acquire Argument Value    ${sFeePayment_User}
    ${EffectiveDate_FeePayment}    Acquire Argument Value    ${sEffectiveDate_FeePayment}
    ${FeePayment_Comment}    Acquire Argument Value    ${sFeePayment_Comment}

    ###Navigate to Fee Payment released###
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_CommitmentFee_Events_Javatree}   Fee Payment Released\t${FeePayment_Date}\t${FeePayment_Time}\t${FeePayment_User}\t${EffectiveDate_FeePayment}\t${FeePayment_Comment}
    Mx LoanIQ DoubleClick   ${LIQ_CommitmentFee_Events_Javatree}    Fee Payment Released\t${FeePayment_Date}\t${FeePayment_Time}\t${FeePayment_User}\t${EffectiveDate_FeePayment}\t${FeePayment_Comment}
    
    ###Open GL Entries Window###
    mx LoanIQ select    ${LIQ_CommitmentFee_Queries_GLEntries}    
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_OngoingFeePayment_GLEntries_Window}    
    
    ###Retrieve Data for Debit and Credit Amounts for post validation use###
    ${Branch}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Customer_Name}%Branch%Branch
    
    ${DebitAmt_Customer}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Customer_Name}%Debit Amt%DebitAmt
    ${CreditAmt_Customer}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Customer_Name}%Credit Amt%CreditAmt

    ${DebitAmt_Host}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Host_ShortName}%Debit Amt%DebitAmt
    ${CreditAmt_Host}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${Host_ShortName}%Credit Amt%CreditAmt
    
    ${Branch}    Set Variable    ${Branch.strip()}    
    ${TotalAmount}    Catenate     ${space}Total For:    ${Branch}
            
    ${TotalDebitAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}    ${TotalAmount}%Debit Amt%TotalDebitAmt
    ${TotalCreditAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_GL_Entries_JavaTree}   ${TotalAmount}%Credit Amt%TotalCreditAmt                              
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/GL_Entries
    ###Exit GL Entries###
    mx LoanIQ click    ${LIQ_OngoingFeePayment_GLEntries_Exit_Button}
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_DebitAmt_Customer}    ${DebitAmt_Customer}
    Save Values of Runtime Execution on Excel File    ${sRunVar_CreditAmt_Customer}    ${CreditAmt_Customer}
    Save Values of Runtime Execution on Excel File    ${sRunVar_DebitAmt_Host}    ${DebitAmt_Host}
    Save Values of Runtime Execution on Excel File    ${sRunVar_CreditAmt_Host}    ${CreditAmt_Host}
    Save Values of Runtime Execution on Excel File    ${sRunVar_TotalDebitAmt}    ${TotalDebitAmt}
    Save Values of Runtime Execution on Excel File    ${sRunVar_TotalCreditAmt}    ${TotalCreditAmt}

    [RETURN]    ${DebitAmt_Customer}    ${CreditAmt_Customer}    ${DebitAmt_Host}    ${CreditAmt_Host}    ${TotalDebitAmt}    ${TotalCreditAmt}
    
Open Ongoing Fee from Facility Notebook
    [Documentation]    This keyword navigates to Ongoing Fee notebook from Facility Notebook.
    ...    @author: rtarayao
    [Arguments]    ${Facility_Name}    ${Fee_Type}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}    
    mx LoanIQ click    ${LIQ_FacilityNavigator_OngoingFees_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeeList_JavaTree}    ${Fee_Type}%d

Initiate Ongoing Fee Payment
    [Documentation]    This keyword initiates an capitalized ongoing fee payment.
    ...    Poulates the requested amount as well as the effective date of the payment.
    ...    @author: rtarayao   
    [Arguments]    ${Cycle_Number} 
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    mx LoanIQ select    ${LIQ_CommitmentFee_Payment_Menu}
    mx LoanIQ activate window    ${LIQ_ChoosePayment_Window}
    Validate Choose Payment Modal Window - Commitment Fee
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button}
    
    mx LoanIQ enter    ${LIQ_CommitmentFee_Cycles_ProjectedDue_RadioButton}    ON
    ${CycleDueAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Cyces_Javatree}    ${Cycle_Number}%Cycle Due%value
    ${CycleDueAmount}    Remove comma and convert to number - Cycle Due    ${CycleDueAmount}
    Write Data To Excel    CAP02_CapitalizedFeePayment    OngoingFee_CycleDue    ${rowid}    ${CycleDueAmount}   
    mx LoanIQ click    ${LIQ_CommitmentFee_Cycles_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    mx LoanIQ click element if present    ${LIQ_CommitmentFee_InquiryMode_Button} 
    # Mx Click Element If Present    ${LIQ_Question_OK_Button}
    ${SystemDate}    Get System Date
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_EffectiveDate_DateField}    ${SystemDate} 
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_RequestedAmount_Textfield}    ${CycleDueAmount}
        
Validate Choose Payment Modal Window - Commitment Fee
        [Documentation]    This keyword validates the payment options and buttons of the Choose Payment modal window under Commitment Fee Notebook.
    ...    @author: rtarayao 
    Mx LoanIQ Verify Object Exist    ${LIQ_ChoosePayment_Fee_RadioButton}    VerificationData="Yes"
    Mx LoanIQ Verify Object Exist    ${LIQ_ChoosePayment_Paperclip_RadioButton}     VerificationData="Yes"
    Mx LoanIQ Verify Object Exist    ${LIQ_ChoosePayment_OK_Button}     VerificationData="Yes"
    Mx LoanIQ Verify Object Exist    ${LIQ_ChoosePayment_Cancel_Button}     VerificationData="Yes"
           
Validate Lender Shares - Ongoing Fee Payment
    [Documentation]    This keyword validates the Lender Shares for an Ongoing fee payment.
    ...    @author: rtarayao 
    [Arguments]    ${HBShortName}    ${Lender1ShortName}    ${Lender2ShortName}    ${HBSharePct}    ${Lender1SharePct}    ${Lender2SharePct}    ${CycleDue}
    mx LoanIQ click element if present    ${LIQ_OngoingFeePayment_InquiryMode_Button}    
    mx LoanIQ select    ${LIQ_OngoingFeePayment_ViewUpdateLenderShares_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window    ${LIQ_CommitmentFee_LenderShares_Window}
    
    ${UIHBShares}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_LenderShares_Javatree}    ${HBShortName}%Actual Amount%value 
    ${UIHBShares}    Remove String    ${UIHBShares}    ,
    ${UIHBShares}    Convert To Number    ${UIHBShares}    2
    
    ${UILender1Shares}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_LenderShares_Javatree}    ${Lender1ShortName}%Actual Amount%value 
    ${UILender1Shares}    Remove String    ${UILender1Shares}    ,
    ${UILender1Shares}    Convert To Number    ${UILender1Shares}    2
    
    ${UILender2Shares}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_LenderShares_Javatree}    ${Lender2ShortName}%Actual Amount%value 
    ${UILender2Shares}    Remove String    ${UILender2Shares}    ,
    ${UILender2Shares}    Convert To Number    ${UILender2Shares}    2
            
    ${Computed_HBFeeShares}    Compute Host Bank Share - Ongoing Fee    ${HBSharePct}    ${CycleDue}
    ${Computed_Lender1FeeShares}    Compute Lender Share - Ongoing Fee    ${Lender1SharePct}    ${CycleDue}
    ${Computed_Lender2FeeShares}    Compute Lender Share - Ongoing Fee    ${Lender2SharePct}    ${CycleDue}
    
    Should Be Equal    ${UIHBShares}    ${Computed_HBFeeShares}    
    Should Be Equal    ${UILender1Shares}    ${Computed_Lender1FeeShares}
    Should Be Equal    ${UILender2Shares}    ${Computed_Lender2FeeShares}        
    
    ${status}    Run Keyword And Return Status    Validate if Element is Enabled    ${LIQ_CommitmentFee_LenderShares_OK_Button}    OK    
    Run Keyword If    ${status}==True    mx LoanIQ click   ${LIQ_CommitmentFee_LenderShares_OK_Button}
    ...    ELSE IF    ${status}==False    Run Keyword    mx LoanIQ close window    ${LIQ_CommitmentFee_LenderShares_Window}        
    
Compute Host Bank Share - Ongoing Fee
    [Documentation]    This keyword computes the Host Bank's Share for the Ongoing fee.
    ...    @author: rtarayao 
    [Arguments]    ${HBSharePct}    ${CycleDue}
    ${HBSharePercentage}    Evaluate    ${HBSharePct}/100    
    ${HBFeeShares}    Evaluate    ${CycleDue}*${HBSharePercentage}
    ${HBFeeShares}    Convert To Number    ${HBFeeShares}    2    
    [Return]    ${HBFeeShares}        
    
Compute Lender Share - Ongoing Fee
    [Documentation]    This keyword validates the Lender's Shares for an Ongoing fee payment.
    ...    @author: rtarayao 
    [Arguments]    ${LenderSharePct}    ${CycleDue}
    ${LenderSharePercentage}    Evaluate    ${LenderSharePct}/100    
    ${LenderFeeShares}    Evaluate    ${CycleDue}*${LenderSharePercentage}
    ${LenderFeeShares}    Convert To Number    ${LenderFeeShares}    2
    [Return]    ${LenderFeeShares}  

Validate Capitalized Ongoing Fee (Amounts) Cashflow Details
    [Documentation]    This keyword is used to validate remittance instructions. 
    ...    This keyword is applicable only for syndicated deal with three lenders.
    ...    @author: rtarayao
    [Arguments]    ${Capitalization_RemainingFeePercentage}    ${CycleDue}    ${HostBankPct}    ${Lender1Pct}    ${Lender2Pct}
    ...    ${Borrower_ShortName}    ${Lender1_ShortName}    ${Lender2_ShortName}
    mx LoanIQ activate window    ${LIQ_Payment_Cashflows_Window}
    
    ${UIIncCashFromBorrower}    Mx LoanIQ Get Data    ${LIQ_Cashflows_IncCashFromBorrower_Amount}    value%value 
    ${UIIncCashFromBorrower}    Strip String    ${UIIncCashFromBorrower}    mode=Right    characters=${SPACE}${SPACE}AUD
    ${UIIncCashFromBorrower}    Remove String    ${UIIncCashFromBorrower}    ,
    ${UIIncCashFromBorrower}    Convert To Number    ${UIIncCashFromBorrower}    2
    ${UIIncCashFromBorrower}    Evaluate    "%.2f" % ${UIIncCashFromBorrower}        
    
    ${UIIncCashToLender}    Mx LoanIQ Get Data    ${LIQ_Cashflows_IncCashToLender_Amount}    value%value 
    ${UIIncCashToLender}    Strip String    ${UIIncCashToLender}    mode=Right    characters=${SPACE}${SPACE}AUD
    ${UIIncCashToLender}    Remove String    ${UIIncCashToLender}    ,
    ${UIIncCashToLender}    Convert To Number    ${UIIncCashToLender}    2
    ${UIIncCashToLender}    Evaluate    "%.2f" % ${UIIncCashToLender}
    
    
    ${UIHostBankCashNet}    Mx LoanIQ Get Data    ${LIQ_Cashflows_HostBankCashNet_Amount}    value%value 
    ${UIHostBankCashNet}    Strip String    ${UIHostBankCashNet}    mode=Right    characters=${SPACE}${SPACE}AUD
    ${UIHostBankCashNet}    Remove String    ${UIHostBankCashNet}    ,
    ${UIHostBankCashNet}    Convert To Number    ${UIHostBankCashNet}    2
    ${UIHostBankCashNet}    Evaluate    "%.2f" % ${UIHostBankCashNet}
    
    ${CapitalizedOngoingFee}    Compute Capitalized - Ongoing Fee    ${Capitalization_RemainingFeePercentage}    ${CycleDue}
    ${HostBankShare}    Compute Host Bank Capitalized - Ongoing Fee    ${HostBankPct}    ${CapitalizedOngoingFee}
    
    ${Lender1Share}    Compute Lender Capitalized - Ongoing Fee    ${Lender1Pct}    ${CapitalizedOngoingFee}
    ${Lender2Share}    Compute Lender Capitalized - Ongoing Fee    ${Lender2Pct}    ${CapitalizedOngoingFee}
    ${TotalNonHBLenderShare}    Evaluate    ${Lender1Share}+${Lender2Share}
  
    Should Be Equal As Numbers    ${UIIncCashFromBorrower}    ${CapitalizedOngoingFee}
    Should Be Equal As Numbers    ${UIIncCashToLender}    ${TotalNonHBLenderShare} 
    Should Be Equal As Numbers    ${UIHostBankCashNet}    ${HostBankShare} 
    
    ${UIBorrowerTranAmount}    Mx LoanIQ Store TableCell To Clipboard     ${LIQ_Cashflows_Tree}   ${Borrower_ShortName}%Tran Amount%value  
    ${UIBorrowerTranAmount}    Remove String    ${UIBorrowerTranAmount}    ,   
    ${UIBorrowerTranAmount}    Convert To Number    ${UIBorrowerTranAmount}    2
    
    ${UILender1TranAmount}    Mx LoanIQ Store TableCell To Clipboard     ${LIQ_Cashflows_Tree}   ${Lender1_ShortName}%Tran Amount%value  
    ${UILender1TranAmount}    Remove String    ${UILender1TranAmount}    ,   
    ${UILender1TranAmount}    Convert To Number    ${UILender1TranAmount}    2
    
    ${UILender2TranAmount}    Mx LoanIQ Store TableCell To Clipboard     ${LIQ_Cashflows_Tree}   ${Lender2_ShortName}%Tran Amount%value  
    ${UILender2TranAmount}    Remove String    ${UILender2TranAmount}    ,   
    ${UILender2TranAmount}    Convert To Number    ${UILender2TranAmount}    2 
    
    Should Be Equal As Numbers    ${UIBorrowerTranAmount}    ${CapitalizedOngoingFee}
    Should Be Equal As Numbers    ${UILender1TranAmount}    ${Lender1Share}
    Should Be Equal As Numbers    ${UILender2TranAmount}    ${Lender2Share}
                           
Compute Capitalized - Ongoing Fee
    [Documentation]    This keyword is used to compute for the uncapitalized ongoing fee amount.
    ...    @author: rtarayao
    [Arguments]    ${Capitalization_RemainingFeePercentage}    ${CycleDue}
    ${RemainingCapitalizedPercentage}    Evaluate    ${Capitalization_RemainingFeePercentage}/100    
    ${CapitalizedOngoingFee}    Evaluate    ${CycleDue}*${RemainingCapitalizedPercentage}  
    ${CapitalizedOngoingFee}    Convert To Number    ${CapitalizedOngoingFee}    2    
    [Return]    ${CapitalizedOngoingFee}      
    
Compute Lender Capitalized - Ongoing Fee
    [Documentation]    This keyword is used to compute the Lender Share of the uncapitalized ongoing fee.
    ...    @author: rtarayao
    [Arguments]    ${LenderPct}    ${CapitalizedOngoingFee}
    ${LenderSharePercentage}    Evaluate    ${LenderPct}/100    
    ${LenderShare}    Evaluate    ${CapitalizedOngoingFee}*${LenderSharePercentage} 
    ${LenderShare}    Convert To Number    ${LenderShare}    2
    [Return]    ${LenderShare}    
     
Compute Host Bank Capitalized - Ongoing Fee
    [Documentation]    This keyword is used to compute the Host Bank Share of the uncapitalized ongoing fee.
    ...    @author: rtarayao
    [Arguments]    ${HostBankPct}    ${CapitalizedOngoingFee}
    ${HostBankSharePercentage}    Evaluate    ${HostBankPct}/100    
    ${HostBankShare}    Evaluate    ${CapitalizedOngoingFee}*${HostBankSharePercentage} 
    ${HostBankShare}    Convert To Number    ${HostBankShare}    2
    [Return]    ${HostBankShare}   
                                
Send Payment to Approval
    [Documentation]    This keyword is used to send the payment for Approval.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Send to Approval%s
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Send to Approval
    Run Keyword And Ignore Error    Repeat Keyword    4    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}                   
    mx LoanIQ activate window    ${LIQ_Payment_Window}    
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_Payment_AwaitingApproval_Status_Window} 

Open Payment Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
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
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%s
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_Payment_Window}   
            
Approve Payment
    [Documentation]    This keyword approves the Repayment Paper Clip.
    ...    @author: rtarayao 
    
    mx LoanIQ activate window    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Approval%yes 
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Ignore Error    Repeat Keyword    4    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
            

Open Fee Payment Notebook via WIP - Awaiting Generate Intent Notices
    [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting Generate Intent Notices thru the LIQ WIP Icon.
    ...    @author: rtarayao
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingGenerateIntentNotices}    ${WIP_PaymentType}    ${Payment}
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
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Payment}%d
    Sleep    3s  
  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    
    mx LoanIQ activate    ${LIQ_Payment_Window}

Navigate to Payment Intent Notices Window
    [Documentation]    This keyword navigates the LIQ User payment Notices to the Borrower and Lender.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    Run Keyword And Ignore Error    Repeat Keyword    4    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}         
    mx LoanIQ activate window    ${LIQ_Payment_Window}
        
Navigate to Ongoing Fee Payment Notebook from Commitment Fee Notebook
    [Documentation]    This keyword navigates the User to the Ongoing Fee Payment Notebook from the Commitment Fee Notebook.
    ...    @author: rtarayao 
    mx LoanIQ activate window    ${LIQ_CommitmentFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_CommitmentFee_Events_Javatree}    Fee Payment Released%d    
    mx LoanIQ activate window    ${LIQ_Payment_Window}

Get Commitment Fee Payment Information for Reversal Validation
    [Documentation]    This keyword returns the Date, Time, User, Comment, and Effective Date of the commitment fee transaction that will be used for fee payment reversal validation.
    ...    Date = The exact date the fee payment was completed.
    ...    Time = The exact time the fee payment was made.
    ...    Effective Date = The date when the transaction was made.
    ...    User = The LoanIQ user which initiated and/or completed the transaction.
    ...    Comment = Auto generated comment when the trasaction was completed.
    ...    @author: rtarayao    01APR2019    Initial Create
    ...    @update: ehugo    05JUN2020    - added keyword post-processing; added optional runtime arguments; added screenshot
    [Arguments]    ${sRunTimeVar_FeePaymentDate}=None    ${sRunTimeVar_FeePaymentTime}=None    ${sRunTimeVar_FeePaymentUser}=None
    ...    ${sRunTimeVar_FeePaymentComment}=None    ${sRunTimeVar_FeePaymentEffectiveDate}=None

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_CommitmentFee_Events_Javatree}   Fee Payment Released
    ${sFeePayment_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Events_Javatree}    Fee Payment Released%Date%FeePayment_Date
    ${sFeePayment_Time}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Events_Javatree}    Fee Payment Released%Time%FeePayment_Time
    ${sFeePayment_User}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Events_Javatree}    Fee Payment Released%User%FeePayment_User
    ${sFeePayment_Comment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Events_Javatree}    Fee Payment Released%Comment%FeePayment_Comment
    ${sFeePayment_EffectiveDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Events_Javatree}    Fee Payment Released%Effective%FeePayment_EffectiveDate

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_EventsTab_PaymentInfo

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_FeePaymentDate}    ${sFeePayment_Date}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_FeePaymentTime}    ${sFeePayment_Time}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_FeePaymentUser}    ${sFeePayment_User}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_FeePaymentComment}    ${sFeePayment_Comment}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_FeePaymentEffectiveDate}    ${sFeePayment_EffectiveDate}

    [Return]    ${sFeePayment_Date}    ${sFeePayment_Time}    ${sFeePayment_User}    ${sFeePayment_Comment}    ${sFeePayment_EffectiveDate}

Close GL Entries and Cashflow Window
    [Documentation]    This keyword closes the GL Entries and Cashflow window.
    ...    @author:fmamaril    09SEP019    Initial Create
    mx LoanIQ click element if present    ${LIQ_GL_Entries_Exit_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present   ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
                
     	
Navigate to Reverse Fee Workflow and Proceed With Transaction
    [Documentation]    This keyword navigates to the Reverse Fee Workflow using the desired Transaction
    ...  @author: dahijara    16JUL2020    Initial create
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_ReverseFee_Window}    ${LIQ_ReversePayment_Tab}    ${LIQ_ReversePayment_WorkflowItems_Tree}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ReverseFeeWindow_WorkflowTab
      
Enter Commitment Fee Details
    [Documentation]    This keyword will handle the dynamic updates in setting Commitment Fee days
    ...   @author: ritragel    06SEP2020
    [Arguments]    ${sEffectiveDate}    ${sActual_DueDate}    ${sAdjusted_DueDate}    ${sCycle_Frequency}    ${sAccrue}
    
    ### Keyword Pre-processing ###
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${Actual_DueDate}    Acquire Argument Value    ${sActual_DueDate}
    ${Cycle_Frequency}    Acquire Argument Value    ${sCycle_Frequency}
    ${Adjusted_DueDate}    Acquire Argument Value    ${sAdjusted_DueDate}
    ${Accrue}    Acquire Argument Value    ${sAccrue}

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    mx LoanIQ click    ${LIQ_CommitmentFee_InquiryMode_Button}
    mx LoanIQ enter    ${LIQ_CommitmentFee_EffectiveDate_Field}    ${EffectiveDate} 
    Mx Press Combination    Key.ENTER
    Mx Click Element If Present    ${LIQ_Warning_OK_Button}    
    mx LoanIQ enter    ${LIQ_CommitmentFee_ActualDueDate_Field}    ${Actual_DueDate} 
    Mx Click Element If Present    ${LIQ_Warning_OK_Button}   
    mx LoanIQ enter    ${LIQ_CommitmentFee_AdjustedDueDate}    ${Adjusted_DueDate}  
    Mx Click Element If Present    ${LIQ_Warning_OK_Button}   
    mx LoanIQ Select Combo Box Value    ${LIQ_CommitmentFee_Cycle_Frequency_Dropdown}    ${Cycle_Frequency}
    mx LoanIQ Select Combo Box Value    ${LIQ_CommitmentFee_Accrue_Dropdown}    ${Accrue}
    Select Menu Item    ${LIQ_CommitmentFee_Window}    File    Save
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Mx Click Element If Present    ${LIQ_Warning_Yes_Button}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Notebook               
    Select Menu Item    ${LIQ_CommitmentFee_Window}    File    Exit
    
Release Commitment Fee
    [Documentation]    This keyword will handle the dynamic updates in releasing Commitment Fe
    ...   @author: ritragel    17SEP2020    Initial Commit
    
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    mx LoanIQ click    ${LIQ_CommitmentFee_InquiryMode_Button}
    Navigate Notebook Workflow    ${LIQ_CommitmentFee_Window}    ${LIQ_CommitmentFee_Tab}    ${LIQ_CommitmentFeeNotebook_Workflow_JavaTree}    Release
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFee_Notebook     
    

Close Commitment Fee and Fee List Windows
    [Documentation]    This keyword exits the Commitment Fee List and Commitment Fee Notebook.
    ...    author: rtarayao    19AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window} 
    mx LoanIQ close window    ${LIQ_CommitmentFee_Window}
    mx LoanIQ close window    ${LIQ_Facility_FeeList}
    
Close Line Fee and Fee List Windows
    [Documentation]    This keyword exits the Line Fee List and Line Fee Notebook.
    ...    author: cfrancis    18SEP2020    - Initial Create
    mx LoanIQ activate window    ${LIQ_LineFee_Window} 
    mx LoanIQ close window    ${LIQ_LineFee_Window}
    mx LoanIQ close window    ${LIQ_Facility_FeeList}
    
Compute Total Accruals for Fee
    [Documentation]    This keyword returns the total Accrued to date value of a Fee.
    ...    @author: rtarayao    04SEP2019    - Initial Create
    [Arguments]    ${iRowCount}    ${sTab_Locator}    ${sAccrualCycle_Locator}
    Mx LoanIQ Select Window Tab    ${sTab_Locator}    Accrual
    ${iRowCount}    Evaluate    ${iRowCount}+1    
    ${TotalAmount}    Set Variable    0
    :FOR    ${Index}    IN RANGE    1    ${iRowCount}
    \    ${AccruedtodateAmount}    Mx LoanIQ Store TableCell To Clipboard    ${sAccrualCycle_Locator}    ${Index}%Accrued to date%Amount
    \    ${AccruedtodateAmount}    Remove Comma and Convert to Number    ${AccruedtodateAmount}
    \    ${TotalAmount}    Evaluate    ${TotalAmount}+${AccruedtodateAmount}
    \    Log    ${TotalAmount}
    \    Exit For Loop If    ${Index}==${iRowCount}
    [Return]    ${TotalAmount}
        
Validate Accrued to Date Amount
    [Documentation]    This keyword validate that the computed total value for the accrued to date is the same as the one displayed in LIQ.
    ...    @author: rtarayao    05SEP2019    - Initial Create
    [Arguments]    ${iComputedValue}    ${iUIValue}
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${iComputedValue}    ${iUIValue}    
    ${Computation_status}    Run Keyword And Return Status    Should Be Equal As Numbers    ${iComputedValue}    ${iUIValue}    
    Run Keyword If    '${Computation_status}' == 'True'    Log    Correct!! Computed Sum is the same as the total displayed value in LIQ.
    ...    ELSE    Log    Incorrect!! Computed Sum is different from the total displayed value in LIQ.    level=ERROR
   
Get Fee Current Rate
    [Documentation]    This keyword gets the Fee Rate and returns the value.
    ...    @author: cfrancis    18SEP2020    - Initial Create
    [Arguments]    ${sLIQ_Fee_Window}    ${sLIQ_Fee_CurrentRate_Locator}
    mx LoanIQ activate window    ${sLIQ_Fee_Window}
    ${Rate}    Mx LoanIQ Get Data    ${sLIQ_Fee_CurrentRate_Locator}    value%Rate
    ${Rate}    Convert To String    ${Rate}
    ${Rate}    Remove String    ${Rate}    .000000%    
    Log    The Line Fee Rate is ${Rate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Fee_Rate
    [Return]    ${Rate}
        
Get Fee Currency
    [Documentation]    This keyword gets the Fee Currency and returns the value.
    ...    @author: cfrancis    18SEP2020    - Initial Create
    [Arguments]    ${sLIQ_Fee_Window}    ${sLIQ_Fee_Currency_Locator}
    mx LoanIQ activate window    ${sLIQ_Fee_Window}
    ${FeeCurrency}    Mx LoanIQ Get Data    ${sLIQ_Fee_Currency_Locator}    value%Currency
    Log    The Fee Currency is ${FeeCurrency}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Fee_Currency
    [Return]    ${FeeCurrency}
    
Get Fee Effective and Actual Expiry Date
    [Documentation]    This keyword returns the Fee Effective and Expiry Date value.
    ...    @author: cfrancis    18SEP2020    - Initial Create
    [Arguments]    ${sLIQ_Fee_Window}    ${sLIQ_Fee_EffectiveDate_Locator}    ${sLIQ_Fee_ActualExpiryDate_Locator}
    mx LoanIQ activate window    ${sLIQ_Fee_Window}
    ${FeeEffectiveDate}    Mx LoanIQ Get Data    ${sLIQ_Fee_EffectiveDate_Locator}    value%EffectiveDate
    ${FeeActualExpiryDate}    Mx LoanIQ Get Data    ${sLIQ_Fee_ActualExpiryDate_Locator}    value%ActualExpiryDate
    Log    The Fee Effective Date is ${FeeEffectiveDate}
    Log    The Fee Actual Expiry Date is ${FeeActualExpiryDate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Fee_Effective_and_Expiry_Dates
    [Return]    ${FeeEffectiveDate}    ${FeeActualExpiryDate}
    
Get Fee Accrual Cycle Start and End Date
    [Documentation]    This keyword returns the Fee Effective and Expiry Date value.
    ...    @author: cfrancis    18SEP2020    - Initial Create
    [Arguments]    ${sLIQ_Fee_Window}    ${sLIQ_Fee_CycleStartDate_Locator}    ${sLIQ_Fee_CycleEndDate_Locator}
    mx LoanIQ activate window    ${sLIQ_Fee_Window}
    ${FeeCycleStartDate}    Mx LoanIQ Get Data    ${sLIQ_Fee_CycleStartDate_Locator}    value%CurrentCycleStartDate
    ${FeeCycleEndDate}    Mx LoanIQ Get Data    ${sLIQ_Fee_CycleEndDate_Locator}    value%AccrualEndDate
    Log    The Fee Cycle Start Date is ${FeeCycleStartDate}
    Log    The Fee Accrual End Date is ${FeeCycleEndDate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Fee_CycleStart_and_CycleDue_Dates
    [Return]    ${FeeCycleStartDate}    ${FeeCycleEndDate}
    
Get Fee Adjusted Due Date
    [Documentation]    This keyword returns the Fee Adjusted Due Date value.
    ...    @author: cfrancis    18SEP2020    - Initial Create
    [Arguments]    ${sLIQ_Fee_Window}    ${sLIQ_Fee_AdjustedDueDate_Locator}
    mx LoanIQ activate window    ${sLIQ_Fee_Window}
    ${FeeAdjustedDueDate}    Mx LoanIQ Get Data    ${sLIQ_Fee_AdjustedDueDate_Locator}    value%AdjDueDate
    Log    The Fee Adjusted Due Date is ${FeeAdjustedDueDate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Fee_Adj_Due_Date
    [Return]    ${FeeAdjustedDueDate}
    
Get Fee Accrued to Date Amount
    [Documentation]    This keyword returns the Fee accrued to date total amount.
    ...    @author: cfrancis    18SEP2020    - Initial Create
    [Arguments]    ${sLIQ_Fee_Window}    ${sLIQ_Fee_Tab_Locator}    ${sLIQ_Fee_Accrual_Cycles_JavaTree_Locator}
    mx LoanIQ activate window    ${sLIQ_Fee_Window}
    Mx LoanIQ Select Window Tab    ${sLIQ_Fee_Tab_Locator}    Accrual
    ${AccruedtodateAmount}    Mx LoanIQ Store TableCell To Clipboard    ${sLIQ_Fee_Accrual_Cycles_JavaTree_Locator}    TOTAL:${SPACE}%Accrued to date%Accruedtodate    
    Log    The Accrued to Date amount is ${AccruedtodateAmount} 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Fee_Accrual_Screen
    [Return]    ${AccruedtodateAmount}

Get Fee Cycle Due Amount
    [Documentation]    This keyword returns the Fee total paid to date amount.
    ...    @author: cfrancis    09OCT2020    - Initial Create
    [Arguments]    ${sLIQ_Fee_Window}    ${sLIQ_Fee_Tab_Locator}    ${sLIQ_Fee_Accrual_Cycles_JavaTree_Locator}
    mx LoanIQ activate window    ${sLIQ_Fee_Window}
    # Mx LoanIQ Select Window Tab    ${sLIQ_Fee_Tab_Locator}    Accrual
    ${rowcount}    Mx LoanIQ Get Data    ${sLIQ_Fee_Accrual_Cycles_JavaTree_Locator}    input=items count%value
    ${rowcount}    Evaluate    ${rowcount} - 2
    Log    The total rowcount is ${rowcount}
    ${CycleDueAmount}    Mx LoanIQ Store TableCell To Clipboard    ${sLIQ_Fee_Accrual_Cycles_JavaTree_Locator}    TOTAL:${SPACE}%Cycle Due%amount
    Log    The Fee Cycle Due amount is ${CycleDueAmount} 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Fee_Cycle_Due
    [Return]    ${CycleDueAmount}
    
Get Fee Paid to Date Amount
    [Documentation]    This keyword returns the Fee total paid to date amount.
    ...    @author: cfrancis    18SEP2020    - Initial Create
    ...    @update: clanding    28OCT2020    - added condition for EU entity
    [Arguments]    ${sLIQ_Fee_Window}    ${sLIQ_Fee_Tab_Locator}    ${sLIQ_Fee_Accrual_Cycles_JavaTree_Locator}
    mx LoanIQ activate window    ${sLIQ_Fee_Window}
    ${rowcount}    Mx LoanIQ Get Data    ${sLIQ_Fee_Accrual_Cycles_JavaTree_Locator}    input=items count%value
    ${rowcount}    Evaluate    ${rowcount} - 2
    ${rowcount}    Run Keyword If    '${ENTITY}'=='EU'    Set Variable    1
    ...    ELSE    Set Variable    ${rowcount}
    Log    The total rowcount is ${rowcount}
    ${PaidtodateAmount}    Mx LoanIQ Store TableCell To Clipboard    ${sLIQ_Fee_Accrual_Cycles_JavaTree_Locator}    ${rowcount}%Paid to date%amount
    Log    The Fee Paid to Date amount is ${PaidtodateAmount} 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Fee_Paid_To_Date
    [Return]    ${PaidtodateAmount}

Navigate Directly to Commitment Fee Notebook from Deal Notebook
    [Documentation]    This keyword navigates directly the LIQ User to the Commitment Fee Notebook from Deal Notebook.
    ...    @author: rtarayao    
    [Arguments]    ${Facility_Name}
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}   
    mx LoanIQ select    ${LIQ_DealNotebook_Options_OngoingFeeList_Menu}
    mx LoanIQ activate window    ${LIQ_DealNotebook_FeeList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeeList_JavaTree}    ${Facility_Name}%d
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window} 
    
Select Cycle Due Fee Payment 
    [Documentation]    This keyword selects a cycle fee payment for Cycle Due amount.
    ...    @author: mgaling
    ...    @update: makcamps    17Nov2020    Added clicking of warning buttons and changed screenshot path.
    
    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}    
    mx LoanIQ select    ${LIQ_CommitmentFee_General_OptionsPayment_Menu}
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button} 
    mx LoanIQ enter    ${LIQ_CommitmentFee_Cycles_CycleDue_RadioButton}    ON   
    mx LoanIQ click    ${LIQ_CommitmentFee_Cycles_OK_Button}
    Run Keyword And Ignore Error     Mx LoanIQ Click Button On Window    .* Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Ignore Error     Mx LoanIQ Click Button On Window    .* Indemnity Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_CycleDueAmount
    
Enter Effective Date for Ongoing Fee-Cycle Due Payment
    [Documentation]    This keywod populates the effective date for ongoing fee-cycle dues payment.
    ...    @author: mgaling 
    [Arguments]    ${sFeePayment_EffectiveDate}
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_EffectiveDate_Field}    ${sFeePayment_EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    EffectiveDate

Update Cycle on Usage Fee
    [Documentation]    This keyword populates Usage effective and float rate start date.
    ...    @author: mcastro    18NOV2020    - Initial Create
    [Arguments]    ${sFee_Cycle}

    ### GetRuntime Keyword Pre-processing ###
    ${Fee_Cycle}    Acquire Argument Value    ${sFee_Cycle}

    mx LoanIQ activate window    ${LIQ_OngoingFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFee_Tab}    General
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_OngoingFee_InquiryMode_Button}
    Mx LoanIQ select combo box value    ${LIQ_OngoingFee_Cycle_List}    ${Fee_Cycle}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UsageFeeWindow_FeeCycle
    mx LoanIQ select    ${LIQ_OngoingFee_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UsageFeeWindow_FeeCycle

Run Online Acrual to Usage Fee
    [Documentation]    This keyword runs the online accrual for Usage fee.
    ...    @author: mcastro    18NOV2020    - Initial Create
    mx LoanIQ activate window    ${LIQ_OngoingFee_Window}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    mx LoanIQ click element if present    ${LIQ_OngoingFee_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_OngoingFee_OnlineAcrual_Menu}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UsageFeeWindow_WorkflowTab_OnlineAccrual
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UsageFeeWindow_WorkflowTab_OnlineAccrual

Update Commitment Fee
    [Documentation]    This keyword updates the values on the commitment fee notebook
    ...    @author: mcastro    03DEC2020    - Initial Create
    [Arguments]    ${sFeePayment_EffectiveDate}    ${sFeePayment_ActualDate}    ${sFeePayment_AdjustedDueDate}    ${sAccrue}    ${sFeePayment_AccrualEndDate}    

    ### Keyword Pre-processing ###
    ${FeePayment_EffectiveDate}    Acquire Argument Value    ${sFeePayment_EffectiveDate}
    ${FeePayment_ActualDate}    Acquire Argument Value    ${sFeePayment_ActualDate}
    ${FeePayment_AdjustedDueDate}    Acquire Argument Value    ${sFeePayment_AdjustedDueDate}
    ${Accrue}    Acquire Argument Value    ${sAccrue}
    ${FeePayment_AccrualEndDate}    Acquire Argument Value    ${sFeePayment_AccrualEndDate}

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    ${GENERAL_TAB}
    Run Keyword And Continue On Failure    Mx LoanIQ click element if present    ${LIQ_CommitmentFee_InquiryMode_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeNotebook_General
    Mx LoanIQ Enter    ${LIQ_CommitmentFee_EffectiveDate_Field}    ${FeePayment_EffectiveDate}
    Mx LoanIQ Enter    ${LIQ_CommitmentFee_FloatRateStartDate_Field}    ${FeePayment_EffectiveDate}
    Mx LoanIQ Enter    ${LIQ_CommitmentFee_ActualDueDate_Field}    ${FeePayment_ActualDate}
    Mx LoanIQ Enter    ${LIQ_CommitmentFee_AdjustedDueDate}    ${FeePayment_AdjustedDueDate}
    Mx LoanIQ select combo box value    ${LIQ_CommitmentFee_Accrue_Dropdown}    ${Accrue}
    Mx LoanIQ Enter    ${LIQ_CommitmentFee_AccrualEndDate_Field}    ${FeePayment_AccrualEndDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeNotebook_General
    Mx LoanIQ select    ${LIQ_CommitmentFee_Save_Menu}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeNotebook_General
    
Get Actual and Adjusted Due Date
    [Documentation]    This keyword is used to get Actual and Adjusted Due Date.
    ...    @author: clanding    27NOV2020    - initial create

    ${ActualDueDate}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_ActualDueDate_Field}    ActualDueDate
    ${AdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_AdjustedDueDate}    AdjustedDueDate
    [Return]    ${ActualDueDate}    ${AdjustedDueDate}

Update Adjusted Due Date on Commitment Fee
    [Documentation]    This keyword is used to update Adjusted Due Date on Commitment Fee.
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${sAdd_To_AdjustedDueDate}    ${sRunTimeVar_New_AdjustedDueDate}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Add_To_AdjustedDueDate}    Acquire Argument Value    ${sAdd_To_AdjustedDueDate}

    mx LoanIQ activate window    ${LIQ_CommitmentFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    General
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_CommitmentFee_InquiryMode_Button}

    ${AdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_AdjustedDueDate}    AdjustedDueDate
    ${New_AdjustedDueDate}    Add Days to Date    ${AdjustedDueDate}    ${Add_To_AdjustedDueDate}

    mx LoanIQ enter    ${LIQ_CommitmentFee_AdjustedDueDate}    ${New_AdjustedDueDate}
    mx LoanIQ select    ${LIQ_CommitmentFee_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_GeneralTab

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_New_AdjustedDueDate}    ${New_AdjustedDueDate}

    [Return]    ${New_AdjustedDueDate}    

Update Ongoing Fee General Information
    [Documentation]    This keyword updates the general tab values for an ongoing fee notebook/
    ...    @author: dahijara    04DEC2020    - Initial Create
    [Arguments]    ${sFee_EffectiveDate}    ${sFee_ActualDate}    ${sFee_AdjustedDueDate}    ${sFee_Accrue}    ${sFee_AccrualEndDate}

    ### Keyword Pre-processing ###
    ${Fee_EffectiveDate}    Acquire Argument Value    ${sFee_EffectiveDate}
    ${Fee_ActualDate}    Acquire Argument Value    ${sFee_ActualDate}
    ${Fee_AdjustedDueDate}    Acquire Argument Value    ${sFee_AdjustedDueDate}
    ${Fee_Accrue}    Acquire Argument Value    ${sFee_Accrue}
    ${Fee_AccrualEndDate}    Acquire Argument Value    ${sFee_AccrualEndDate}

    mx LoanIQ activate window    ${LIQ_OngoingFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFee_Tab}    ${GENERAL_TAB}
    Run Keyword And Continue On Failure    Mx LoanIQ click element if present    ${LIQ_OngoingFee_InquiryMode_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeNotebook_General
    Mx LoanIQ Enter    ${LIQ_OngoingFee_EffectiveDate_Field}    ${Fee_EffectiveDate}
    Mx LoanIQ Enter    ${LIQ_OngoingFee_FloatRateStartDate_Field}    ${Fee_EffectiveDate}
    Mx LoanIQ Enter    ${LIQ_OngoingFee_ActualDueDate_Field}    ${Fee_ActualDate}
    Mx LoanIQ Enter    ${LIQ_OngoingFee_AdjustedDueDate}    ${Fee_AdjustedDueDate}
    Mx LoanIQ select combo box value    ${LIQ_OngoingFee_Accrue_Dropdown}    ${Fee_Accrue}
    Mx LoanIQ Enter    ${LIQ_OngoingFee_AccrualEndDate_Field}    ${Fee_AccrualEndDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeNotebook_General

Update Fee Paid By and Servicing Group for Ongoing Fee
    [Documentation]    This keyword updates the fee paid by and servicing groups for an ongoing fee notebook.
    ...    @author: dahijara    04DEC2020    - Initial Create
    [Arguments]    ${sBorrower_ShortName}    ${sBorrower_Location}    ${sBorrower_SGName}    ${sBorrower_SG_GroupMembers}    ${sBorrower_SG_Method}

    ### Keyword Pre-processing ###
    ${Borrower_ShortName}    Acquire Argument Value    ${sBorrower_ShortName}
    ${Borrower_Location}    Acquire Argument Value    ${sBorrower_Location}
    ${Borrower_SGName}    Acquire Argument Value    ${sBorrower_SGName}
    ${Borrower_SG_GroupMembers}    Acquire Argument Value    ${sBorrower_SG_GroupMembers}
    ${Borrower_SG_Method}    Acquire Argument Value    ${sBorrower_SG_Method}

    ### Customer Select ###
    Mx LoanIQ Click    ${LIQ_OngoingFee_FeePaidBy_Button}
    Mx LoanIQ Activate    ${LIQ_CustomerSelect_Window}
    Mx LoanIQ Enter    ${LIQ_CustomerSelect_Search_Inputfield}     ${Borrower_ShortName}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OngoingFee_CustomerSelectWindow
    Mx LoanIQ Click    ${LIQ_CustomerSelect_OK_Button}

    ### Locations ###
    Mx LoanIQ Activate    ${LIQ_Locations_Window}
    Mx LoanIQ Select String    ${LIQ_Locations_JavaTree}    ${Borrower_Location}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFee_Locations
    Mx LoanIQ Click    ${LIQ_Locations_OK_Button}

    ### Servicing Group ###
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroup_Window}    VerificationData="Yes"
    Mx LoanIQ activate window    ${LIQ_ServicingGroup_Window}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_JavaTree}   ${Borrower_SGName}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_GroupMembers_JavaTree}   ${Borrower_SG_GroupMembers}
    Mx LoanIQ Select String    ${LIQ_ServicingGroups_RemittanceInctructions_JavaTree}   ${Borrower_SG_Method}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFee_ServicingGroupsFor
    Mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    Mx LoanIQ activate window    ${LIQ_OngoingFee_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeNotebook_General

Save and Close Ongoing Fee Window
    [Documentation]    This keyword saves and closes an ongoing fee notebook.
    ...    @author: dahijara    04DEC2020    - Initial Create

    Mx LoanIQ activate window    ${LIQ_OngoingFee_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeeNotebook_General
    Mx LoanIQ select    ${LIQ_OngoingFee_Save_Menu}
    Mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Mx LoanIQ select    ${LIQ_OngoingFee_Exit_Menu}

Release Ongoing Fee
    [Documentation]    This keyword will handle the releasing of ongoing Fe
    ...   @author: dahijara    10DEC2020    Initial Commit
    
    mx LoanIQ activate window    ${LIQ_OngoingFee_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ click element if present    ${LIQ_OngoingFee_InquiryMode_Button}
    Navigate Notebook Workflow    ${LIQ_OngoingFee_Window}    ${LIQ_OngoingFee_Tab}    ${LIQ_OngoingFee_Workflow_JavaTree}    Release
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFee_Notebook     