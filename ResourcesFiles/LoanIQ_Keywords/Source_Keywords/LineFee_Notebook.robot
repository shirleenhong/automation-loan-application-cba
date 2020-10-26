*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Line Fee Capitalization Rule
    [Documentation]    This keyword creates a Capitalization rule for line fee.
    ...    @author: fmamaril    
    ...    @update: dahijara    07OCT2020    Added pre processing keyword and screenshot
    [Arguments]    ${sCapitalizationFeePaymentPercentage}    ${sFacility_Name}    ${sPricingOption}    ${sLoan_Alias}    ${sCurrent_Date}    ${sFuture_Date}

    ### GetRuntime Keyword Pre-processing ###
    ${CapitalizationFeePaymentPercentage}    Acquire Argument Value    ${sCapitalizationFeePaymentPercentage}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${PricingOption}    Acquire Argument Value    ${sPricingOption}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
    ${Current_Date}    Acquire Argument Value    ${sCurrent_Date}
    ${Future_Date}    Acquire Argument Value    ${sFuture_Date}

    ###Navigation to Capitalization Editor###
    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_LineFee_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_LineFee_Capitalization_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
        
    ###Capitalization Editor###
    mx LoanIQ activate window    ${LIQ_LineFee_CapitalizationEditor_Window}
    mx LoanIQ enter    ${LIQ_LineFee_CapitalizationEditor_ActivateFeeCap_CheckBox}    ON
    mx LoanIQ enter    ${LIQ_LineFee_CapitalizationEditor_FromDate_Textfield}    ${Current_Date} 
    mx LoanIQ enter    ${LIQ_LineFee_CapitalizationEditor_ToDate_Textfield}    ${Future_Date}
    mx LoanIQ enter    ${LIQ_LineFee_CapitalizationEditor_PctofPayment_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_LineFee_CapitalizationEditor_PctofPayment_Textfield}    ${CapitalizationFeePaymentPercentage}
    Mx LoanIQ Select Combo Box Value    ${LIQ_LineFee_CapitalizationEditor_ToFacility_DropdownList}    ${Facility_Name}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_LineFee_CapitalizationEditor_ToLoan_DropdownList}    ${PricingOption}${SPACE}Loan${SPACE}(${Loan_Alias})
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFee_CapitalizationEditor_window
    mx LoanIQ click    ${LIQ_LineFee_CapitalizationEditor_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFee_CapitalizationEditor_window
    
Validate Capitalized Line Fee details
    [Documentation]    This keyword validates the detail Capitalization Rule for Line fee.
    ...    @author: fmamaril    
    ...    @update: dahijara    07OCT2020    Added pre processing keyword and screenshot
    [Arguments]    ${sCapitalization_FromDate}    ${sCapitalization_ToDate}    ${sCapitalizationFeePaymentPercentage}    ${sPricingOption}    ${sLoan_Alias}     

    ### GetRuntime Keyword Pre-processing ###
    ${Capitalization_FromDate}    Acquire Argument Value    ${sCapitalization_FromDate}
    ${Capitalization_ToDate}    Acquire Argument Value    ${sCapitalization_ToDate}
    ${CapitalizationFeePaymentPercentage}    Acquire Argument Value    ${sCapitalizationFeePaymentPercentage}
    ${PricingOption}    Acquire Argument Value    ${sPricingOption}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    ###Navigation to Capitalization Editor###
    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window}
    mx LoanIQ select    ${LIQ_LineFee_Capitalization_Menu}  
    mx LoanIQ activate window    ${LIQ_LineFee_CapitalizationEditor_Window}      
    ${UIFromDate}    Mx LoanIQ Get Data    ${LIQ_LineFee_CapitalizationEditor_FromDate_Textfield}    value%date
    ${UIToDate}    Mx LoanIQ Get Data    ${LIQ_LineFee_CapitalizationEditor_ToDate_Textfield}    value%date 
    ${PercentofPayment}    Mx LoanIQ Get Data    ${LIQ_LineFee_CapitalizationEditor_PctofPayment_Textfield}    value%percentage    
    ${UIPercentofPayment}    Remove String    ${PercentofPayment}    .0000%
    ${UILoan}    Mx LoanIQ Get Data    ${LIQ_LineFee_CapitalizationEditor_ToLoan_DropdownList}    value%loan  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFee_CapitalizationEditor_window
    
    ###Validation of Line Fee details###
    Should Be Equal As Strings    ${UIFromDate}    ${Capitalization_FromDate}
    Should Be Equal As Strings    ${UIToDate}    ${Capitalization_ToDate}    
    Should Be Equal As Strings    ${UIPercentofPayment}    ${CapitalizationFeePaymentPercentage}    
    Should Be Equal As Strings    ${UILoan}    ${PricingOption} Loan (${Loan_Alias})       
    mx LoanIQ click    ${LIQ_LineFee_CapitalizationEditor_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFee_CapitalizationEditor_window
    
Save and Exit Line Fee Notebook
    [Documentation]    This keyword saves and exits the the LIQ User from Line fee.
    ...    @author: fmamaril    
    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window}    
    mx LoanIQ select    ${LIQ_LineFee_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    mx LoanIQ select    ${LIQ_LineFee_Exit_Menu} 
    
Navigate to Existing Ongoing Fee Notebook
    [Documentation]    This keyword is used for navigating to Line Fee Notebook
    ...    @author:ritragel    8AUG2019
    [Arguments]    ${sOngoingFee_Type}    
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_OngoingFeeList}
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Facility_FeeList_JavaTree}    ${sOngoingFee_Type}%d
    
Select Payment in Choose a Payment Window
    [Documentation]    This will allow the user to select Payment if it is a Fee Payment of a Paper Clip
    ...    @author: ritragel    08AUG2019
    [Arguments]    ${sPayment_Type}
    
    mx LoanIQ activate window    ${LIQ_ChoosePayment_Window}
    Run Keyword If    "${sPayment_Type}" == "Fee Payment"    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    Run Keyword If    "${sPayment_Type}" == "Paper Clip Payment"    mx LoanIQ enter    ${LIQ_ChoosePayment_Paperclip_RadioButton}    ON   
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button}
    Sleep    3
    
Setup Line Fee Effective Date and Cycle
    [Documentation]    This keyword inputs the Line fee payment of the facility
    ...    @author:fmamaril    09SEP2019    Intial Create
    [Arguments]    ${sEffective_Date}    ${sCycle}      
    mx LoanIQ activate window    ${LIQ_LineFee_Window}
    mx LoanIQ click element if present    ${LIQ_LineFee_InquiryMode_Button}
    mx LoanIQ enter    ${LIQ_LineFee_EffectiveDate_Field}    ${sEffective_Date}
    Mx LoanIQ select combo box value    ${LIQ_LineFee_Cycle_List}    ${sCycle}   
    mx LoanIQ select    ${LIQ_LineFee_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Take Screenshot    LIQ_CommitmentFee_EffectiveDate                
    
Run Online Acrual to Line Fee
    [Documentation]    This keyword runs the online accrual for line fee.
    ...    @author:fmamaril    09SEP2019    Intial Create
    mx LoanIQ activate window    ${LIQ_LineFee_Window}
    mx LoanIQ click element if present    ${LIQ_LineFee_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_LineFee_OnlineAcrual_Menu}
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Line Fee.*;Warning;Yes            strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Line Fee.*;Warning;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    CLine Fee.*;Informational Message.*;OK        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    
Navigate Directly to Line Fee Notebook from Deal Notebook
    [Documentation]    This keyword navigates directly the LIQ User to the Line Fee Notebook from Deal Notebook.
    ...    @author:fmamaril    09SEP2019    Intial Create   
    [Arguments]    ${Facility_Name}   
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}   
    mx LoanIQ select    ${LIQ_DealNotebook_Options_OngoingFeeList_Menu}
    mx LoanIQ activate window    ${LIQ_DealNotebook_FeeList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeeList_JavaTree}    ${Facility_Name}%d
    mx LoanIQ activate window    ${LIQ_LineFee_Window}

Check if Line Fee is already released
    [Documentation]    This keyword verifies the status of line fee is already released
    ...    @author:fmamaril    09SEP2019    Intial Create
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_LineFeeReleasedNotebook_Window}        VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    Run Keywords    Log    ${status}-Line Fee is already released    
    ...    AND    Take Screenshot    LineFeeStatus
    ...    AND    Run Online Acrual to Line Fee    
    ...    AND    Refresh Tables in LIQ
 
    Run Keyword If    '${status}' == 'False'    Run Keywords    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Pending_Window}         
    ...    AND    Mx LoanIQ Select Window Tab    ${LIQ_LineFeeTag_Tab}    Workflow
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LineFeeNotebook_Workflow_JavaTree}    Release%d
    ...    AND    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    ...    AND    Take Screenshot    LineFeeStatus     
    ...    AND    Run Online Acrual to Line Fee  
    ...    AND    Refresh Tables in LIQ
 
Get Data in General Tab for Line Fee
    [Documentation]    This keyword navigates to General Tab wherein it gets and convert the data that will be used for the validation.
    ...    @author:fmamaril    05SEP2019    Initial Create
    
    mx LoanIQ activate window    ${LIQ_LineFee_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_LineFeeTag_Tab}    General
    
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_LineFee_CurrentRate_Field}    value%test
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
           
    
    ${BalanceAmount}    Mx LoanIQ Get Data    ${LIQ_LineFee_BalanceAmount_Field}    value%test 
    ${BalanceAmount}    Remove String    ${BalanceAmount}    ,
    ${BalanceAmount}    Convert To Number    ${BalanceAmount}
   
        
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_LineFee_RateBasis_Field}    text%test 
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Integer    ${RateBasis}
    
    [Return]    ${Rate}    ${BalanceAmount}    ${RateBasis}
    
Compute Line Fee Amount Per Cycle
    [Documentation]    This keyword is used in computing the first Projected Cycle Due of the Line Fee
    ...    @author: fmamaril    05SEP2019    Initial Create
    [Arguments]    ${iCycleNumber}    ${sSystemDate}
    mx LoanIQ activate window    ${LIQ_LineFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFeeTag_Tab}    General
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_LineFee_CurrentRate_Field}    value%test
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_LineFee_RateBasis_Field}    value%test
    ${BalanceAmount}    Mx LoanIQ Get Data    ${LIQ_LineFee_BalanceAmount_Field}    value%test    
    ${BalanceAmount}    Remove String    ${BalanceAmount}    ,
    ${BalanceAmount}    Convert To Number    ${BalanceAmount}
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Integer    ${RateBasis}
    ${ComputedCycleDue}    Evaluate Line Fee    ${BalanceAmount}    ${Rate}    ${RateBasis}    ${iCycleNumber}    ${sSystemDate}
    Log    ${ComputedCycleDue}
    [Return]    ${ComputedCycleDue}    ${Rate}    ${RateBasis}    ${BalanceAmount}
    
Evaluate Line Fee
    [Documentation]    This keyword evaluates the FIRST Projected Cycle Due.
    ...    @author: fmamaril    05SEP2019    Initial Create
    [Arguments]    ${iBalanceAmount}    ${iRate}    ${iRateBasis}    ${iCycleNumber}    ${sSystemDate}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFeeTag_Tab}    Accrual
    Mx LoanIQ Select Window Tab    ${LIQ_LineFeeTag_Tab}    Workflow
    Mx LoanIQ Select Window Tab    ${LIQ_LineFeeTag_Tab}    Accrual
    ${sDueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${iCycleNumber}%Due Date%duedate
    ${sStartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${iCycleNumber}%Start Date%startdate
    Log    ${sStartDate}
    Log    ${sDueDate}
    ${sSystemDate}    Convert Date    ${sSystemDate}     date_format=%d-%b-%Y
    ${sStartDate}    Convert Date    ${sStartDate}     date_format=%d-%b-%Y
    ${sDueDate}    Convert Date    ${sDueDate}     date_format=%d-%b-%Y
    ${iNumberof Days1}    Subtract Date From Date    ${sSystemDate}    ${sStartDate}    verbose    
    ${iNumberof Days2}    Subtract Date From Date    ${sDueDate}    ${sStartDate}    verbose 
    Log    ${iNumberof Days1}
    Log    ${iNumberof Days2}
    ${iNumberof Days1}    Remove String    ${iNumberof Days1}     days    seconds    day
    ${iNumberof Days1}    Convert To Number    ${iNumberof Days1}
    ${iNumberof Days2}    Remove String    ${iNumberof Days2}     days    seconds    day
    ${iNumberof Days2}    Convert To Number    ${iNumberof Days2}        
    ${iNumberof Days}   Run Keyword If    '${iNumberof Days2}' == '0.0'    Set Variable    ${iNumberof Days1}
    ...    ELSE IF    ${iNumberof Days1} > ${iNumberof Days2}    Set Variable    ${iNumberof Days2}    
    ...    ELSE IF    '${iNumberof Days1}' == '${iNumberof Days2}'    Set Variable    ${iNumberof Days2}
    ...    ELSE IF    '${iNumberof Days1}' == '0.0'    Set Variable    ${iNumberof Days2}    
    ...    ELSE    Set Variable    ${iNumberof Days1}
    ${iComputedCycleDue}    Evaluate    (((${iBalanceAmount})*(${iRate}))*(${iNumberof Days}))/${iRateBasis}
    ${iComputedCycleDue}    Convert To Number    ${iComputedCycleDue}    2
    [Return]    ${iComputedCycleDue}
    
Select Cycle Due Line Fee Payment 
    [Documentation]    This keyword selects a cycle fee payment for Cycle Due amount.
    ...    @author: fmamaril    05SEP2019    Initial Create 
    
    mx LoanIQ activate window    ${LIQ_LineFee_Window}    
    mx LoanIQ select    ${LIQ_LineFee_General_OptionsPayment_Menu}
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button} 
    mx LoanIQ enter    ${LIQ_CommitmentFee_Cycles_CycleDue_RadioButton}    ON   
    mx LoanIQ click    ${LIQ_CommitmentFee_Cycles_OK_Button}
    Take Screenshot    CycleDueAmount
    
Select Latest Cycle Due Line Fee Payment 
    [Documentation]    This keyword selects a cycle fee payment for Cycle Due amount.
    ...    @author: cfrancis    25SEP2020    Initial Create 
    
    mx LoanIQ activate window    ${LIQ_LineFee_Window}    
    mx LoanIQ select    ${LIQ_LineFee_General_OptionsPayment_Menu}
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button}
    mx LoanIQ enter    ${LIQ_CommitmentFee_Cycles_CycleDue_RadioButton}    ON   
    ${rowcount}    Mx LoanIQ Get Data    ${LIQ_LineFee_Cycles_List}    input=items count%value
    Log    The total rowcount is ${rowcount}
    Write Data To Excel    ComSee_SC7_OngoingFeePayment    CycleNumber    ${rowid}    ${rowcount}    ${ComSeeDataSet}
    ${Due_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Cycles_List}    ${rowcount}%Due Date%amount
    Mx LoanIQ Select String    ${LIQ_LineFee_Cycles_List}    ${Due_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CycleDue_Row
    mx LoanIQ click    ${LIQ_CommitmentFee_Cycles_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CycleDue
    
Enter Effective Date for Line Fee-Cycle Due Payment
    [Documentation]    This keywod populates the effective date for ongoing fee-cycle dues payment.
    ...    @author: fmamaril    05SEP2019    Initial Create
    [Arguments]    ${sFeePayment_EffectiveDate}
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_EffectiveDate_Field}    ${sFeePayment_EffectiveDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    EffectiveDate 

Navigate to GL Entries from Ongoing Fee Payment
    [Documentation]    This keyword will be used to navigate to GL Entries from Ongoing Fee Payment Window
    ...    @author: fmamaril    05SEP2019    Initial Create
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}   
    mx LoanIQ select    ${LIQ_LineFee_Queries_GLEntries} 
    mx LoanIQ activate window  ${LIQ_GL_Entries_Window}   
    mx LoanIQ maximize    ${LIQ_GL_Entries_Window}
    
Choose Payment Type for Line Fee
    [Documentation]    Keyword used to choose a payment type for the Line Fee payment
    ...                @author: bernchua    24SEP2019    Initial create 
    [Arguments]    ${sOngoingFee_PaymentType}
    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window}    
    mx LoanIQ select    ${LIQ_LineFee_General_OptionsPayment_Menu}
    Mx LoanIQ Set    JavaWindow("title:=Choose a Payment.*").JavaRadioButton("label:=${sOngoingFee_PaymentType}")    ON
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button}
    
Select Cycle for Line Fee Payment
    [Documentation]    Keyword used to select the Prorate and Cycle for the Line Fee Payment
    ...                @author: bernchua    24SEP2019    Initial create
    [Arguments]    ${sLineFeePayment_CycleProrate}    ${sLineFeePayment_DueDate}
    mx LoanIQ activate window    ${LIQ_LineFee_Cycles_Window}
    Mx LoanIQ Set    JavaWindow("title:=Cycles for Line Fee.*").JavaRadioButton("label:=${sLineFeePayment_CycleProrate}")    ON
    ${CycleDue_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Cycles_List}    ${sLineFeePayment_DueDate}%Cycle Due%amount
    Mx LoanIQ Select String    ${LIQ_LineFee_Cycles_List}    ${sLineFeePayment_DueDate}
    mx LoanIQ click    ${LIQ_LineFee_Cycles_OKButton}
    [Return]    ${CycleDue_Amount}
    
Set Ongoing Fee Payment General Tab Details
    [Documentation]    Keyword used to set the General tab details of the Ongoing Fee Payment
    ...                @author: bernchua    24SEP2019    Initial create
    [Arguments]    ${sRequested_Amount}    ${sEffective_Date}
    mx LoanIQ activate window    ${LIQ_OngoingFeePayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    General
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_Requested_Textfield}    ${sRequested_Amount}
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_EffectiveDate_Textfield}    ${sEffective_Date}
     
Enter Line Fee Details
    [Documentation]    This keyword will handle the dynamic updates in setting Line Fee dates
    ...   @author: ritragel    06SEP2020
    [Arguments]    ${sEffectiveDate}    ${sActual_DueDate}    ${sAdjusted_DueDate}    ${sCycle_Frequency}    ${sAccrue}
    
    ### Keyword Pre-processing ###
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${Actual_DueDate}    Acquire Argument Value    ${sActual_DueDate}
    ${Cycle_Frequency}    Acquire Argument Value    ${sCycle_Frequency}
    ${Adjusted_DueDate}    Acquire Argument Value    ${sAdjusted_DueDate}
    ${Accrue}    Acquire Argument Value    ${sAccrue}

    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window}
    mx LoanIQ click    ${LIQ_LineFee_InquiryMode_Button}
    mx LoanIQ enter    ${LIQ_LineFee_EffectiveDate_Field}    ${EffectiveDate} 
    Mx Press Combination    Key.ENTER
    Mx Click Element If Present    ${LIQ_Warning_OK_Button}    
    mx LoanIQ enter    ${LIQ_LineFee_ActualDue_Date}    ${Actual_DueDate} 
    Mx Click Element If Present    ${LIQ_Warning_OK_Button}   
    mx LoanIQ enter    ${LIQ_LineFee_AdjustedDue_Date}    ${Adjusted_DueDate}  
    Mx Click Element If Present    ${LIQ_Warning_OK_Button}   
    mx LoanIQ Select Combo Box Value    ${LIQ_LineFee_Cycle}    ${Cycle_Frequency}
    mx LoanIQ Select Combo Box Value    ${LIQ_LineFee_Accrue_Dropdown}    ${Accrue}
    Select Menu Item    ${LIQ_LineFeeNotebook_Window}    File    Save
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Mx Click Element If Present    ${LIQ_Warning_Yes_Button}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFee_Notebook               
    Select Menu Item    ${LIQ_LineFeeNotebook_Window}    File    Exit
    
Update Cycle on Line Fee
    [Documentation]    This keyword populates line effective and float rate start date.
    ...    @author: cfrancis    23SEP2020    - initial create
    [Arguments]    ${sFee_Cycle}    ${sRunTimeVar_AdjustedDueDate}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Fee_Cycle}    Acquire Argument Value    ${sFee_Cycle}

    mx LoanIQ activate window    ${LIQ_LineFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    General
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_LineFee_InquiryMode_Button}
    Mx LoanIQ select combo box value    ${LIQ_LineFee_Cycle_List}    ${Fee_Cycle}
    mx LoanIQ select    ${LIQ_LineFee_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    ${AdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_LineFee_AdjustedDueDate}    AdjustedDueDate

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeeWindow_GeneralTab_CycleList

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_AdjustedDueDate}    ${AdjustedDueDate}

    [Return]    ${AdjustedDueDate}
    
Validate Details on Acrual Tab - Line Fee
    [Documentation]    This keyword validates the details on Acrual Tab.
    ...    @author: cfrancis    23SEP2020    - initial create
    [Arguments]    ${sComputed_ProjectedCycleDue}    ${sCycleNumber}     

    ### GetRuntime Keyword Pre-processing ###
    ${Computed_ProjectedCycleDue}    Acquire Argument Value    ${sComputed_ProjectedCycleDue}
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}

    mx LoanIQ activate window    ${LIQ_Fee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Accrual
    ${CycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNumber}%Cycle Due%CycleDue    
    Should Be Equal As Strings    0.00    ${CycleDue}
    ${PaidToDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNumber}%Paid to date%PaidToDate
    ${PaidToDate}    Remove Comma, Negative Character and Convert to Number    ${PaidToDate}    
    Should Be Equal As Strings    ${PaidToDate}    ${Computed_ProjectedCycleDue}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FeeWindow_AccrualTab_LineFeeAccruals
    
Validate Release of Ongoing Line Fee Payment
    [Documentation]    This keyword validates the release of Ongoing Fee Payment on Events.
    ...    @author: cfrancis    24SEP2020    - initial create

    mx LoanIQ activate window    ${LIQ_LineFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_LineFee_Events_Javatree}   Fee Payment Released
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeeWindow_EventsTab_OngoingFeePayment
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_LineFee_Events_Javatree}    Fee Payment Released%d
    mx LoanIQ activate window    ${LIQ_OngoingFeePaymentNotebook_Window}
    
Validate GL Entries for Ongoing Line Fee Payment - Bilateral Deal
    [Documentation]    This keyword validates the GL Entries of the Ongoing Fee Payment.
    ...    @author: fmamaril
    ...    @update: ehugo    05JUN2020    - added keyword pre-processing; added screenshot
    ...                                   - converted 'Loan_RequestedAmount' to number
    ...    @update: dahijara    16JUL2020    - Fix warnings - too many variables assigned in Mx LoanIQ Click Button On Window
    [Arguments]    ${sHost_Bank}    ${sBorrower_ShortName}    ${sLoan_RequestedAmount}         

    ### GetRuntime Keyword Pre-processing ###
    ${Host_Bank}    Acquire Argument Value    ${sHost_Bank}
    ${Borrower_ShortName}    Acquire Argument Value    ${sBorrower_ShortName}
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}

    mx LoanIQ activate window    ${LIQ_LineFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_OngoingFeePayment_Tab}    Workflow
    mx LoanIQ select    ${LIQ_LineFee_Queries_GLEntries}
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
    ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}                         
    Should Be Equal    ${DebitAmount}    ${CreditAmount1}
    Should Be Equal    ${Loan_RequestedAmount}    ${DebitAmount}
    Should Be Equal    ${Loan_RequestedAmount}    ${CreditAmount1} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OngoingFeePaymentWindow_ValidateGLEntries
    mx LoanIQ click    ${LIQ_OngoingFeePayment_GLEntries_Exit_Button}
    mx LoanIQ close window    ${LIQ_OngoingFeePaymentNotebook_Window}   

Release Line Fee
    [Documentation]    This keyword will handle the dynamic updates in releasing Line Fee
    ...   @author: ritragel    17SEP2020    Initial Commit
    
    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window}
    mx LoanIQ click    ${LIQ_LineFee_InquiryMode_Button}
    Navigate Notebook Workflow    ${LIQ_LineFeeNotebook_Window}    ${LIQ_LineFeeTag_Tab}    ${LIQ_LineFeeNotebook_Workflow_JavaTree}    Release
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFee_Notebook
    
Navigate Line Fee and Verify Accrual Tab
    [Documentation]    This keyword is used for navigating and verifies data in Accrual Tab.
    ...    @author: cfrancis    - 30SEP2020    - initial create
    [Arguments]    ${sRowid}    ${sCycleNo}    ${sRunVar_StartDate}=None    ${sRunVar_EndDate}=None    ${sRunVar_DueDate}=None    ${sRunVar_CycleDue}=None    ${sRunVar_ProjectedCycleDue}=None
    ...    ${sRunVar_Orig_TotalCycleDue}=None    ${sRunVar_Orig_TotalManualAdjustment}=None    ${sRunVar_Orig_TotalProjectedEOCAccrual}=None
    ### GetRuntime Keyword Pre-processing ###
    ${rowid}    Acquire Argument Value    ${sRowid}
    ${CycleNo}    Acquire Argument Value    ${sCycleNo}
    
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Accrual
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LineFee_Accrual_Cycles_JavaTree}            VerificationData="Yes"
    
    ${StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%Start Date%value    
    ${EndDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%End Date%value
    ${DueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%Due Date%value
    ${CycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%Cycle Due%value
    ${ProjectedCycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%Projected EOC due%value
    ${Orig_TotalCycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    TOTAL: %Cycle Due%value       
    ${Orig_TotalManualAdjustment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    TOTAL: %Manual adjustmt%value
    ${Orig_TotalProjectedEOCAccrual}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    TOTAL: %Projected EOC accrual%value
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFee_AccrualTab
	
    [Return]    ${StartDate}    ${EndDate}    ${DueDate}    ${CycleDue}    ${ProjectedCycleDue}    ${Orig_TotalCycleDue}    ${Orig_TotalManualAdjustment}    ${Orig_TotalProjectedEOCAccrual}
    
Navigate Line Fee and Verify Accrual Share Adjustment Notebook
    [Documentation]    This keyword is used for navigating Accrual Share Adjustment Notebook from Line Fee Notebook.
    ...    @author: cfrancis    - 30SEP2020    - initial create
    [Arguments]    ${StartDate}    ${Deal_Name}    ${Facility_Name}    ${OngoingFee_Type}    ${CurrentCycleDue_Value}    ${ProjectedCycleDue_Value}           
       
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Accrual 
    Mx LoanIQ Select String    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${StartDate}
    mx LoanIQ click    ${LIQ_LineFeeNotebook_CycleShareAdjustment_Button}
    mx LoanIQ activate window    ${LIQ_AccrualSharesAdjustment_Window} 
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Deal_Name}")      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${Facility_Name}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Accrual Shares Adjustment -.*").JavaStaticText("attached text:=${OngoingFee_Type}")    VerificationData="Yes"
    
Create Line Fee Payment Reversal
    [Documentation]    This keyword is used for creating Payment Reversal
    ...    @author: cfrancis    - 01OCT2020    - initial create
    ...    @update: cfrancis    - 05OCT2020    - added logic of getting requested amount if current cycle due is 0.0
    
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_LineFee_Events_Javatree}    Fee Payment Released%d
    mx LoanIQ activate window    ${LIQ_OngoingFeePaymentNotebook_Window}  
    Mx LoanIQ Select    ${LIQ_LineFee_ReversePayment}
    Verify If Warning Is Displayed  
    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}
    
    ${CurrentCycleDue}    Mx LoanIQ Get Data    ${LIQ_LineFee_ReversePayment_CurrentCycleDue}    Amount
    ${CurrentCycleDue}    Remove String    ${CurrentCycleDue}    -
    ${CurrentCycleDue}    Remove Comma, Negative Character and Convert to Number    ${CurrentCycleDue}
    
    ${CurrentCycleDue}    Run Keyword If    '${CurrentCycleDue}'=='0.0'    Mx LoanIQ Get Data    ${LIQ_LineFee_ReversePayment_RequestedAmount}    Amount
    ...    ELSE    Set Variable    ${CurrentCycleDue}
    
    mx LoanIQ enter    ${LIQ_LineFee_ReversePayment_RequestedAmount}    ${CurrentCycleDue}
    
    [Return]    ${CurrentCycleDue}
    
Navigate to Cashflow - Reverse Fee
    [Documentation]    This keyword creates cashflow for the breakfunding
    ...    @author: cfrancis    - 01OCT2020    - initial create
    
    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_ReversePayment_Tab}    Workflow
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Line Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Mx LoanIQ DoubleClick    ${LIQ_LineFee_ReversePayment_WorkflowItems}    Create Cashflows
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    .* Line Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_LineFee_ReversePayment_Cashflows_Window}                 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LineFee_ReversePayment_Cashflows_Window}    VerificationData="Yes"
    
Send Reverse Fee Payment to Approval
    [Documentation]    This keywod sends the reverse fee payment to approval.
    ...    @author: cfrancis    - 01OCT2020    - initial create

    mx LoanIQ click element if present     ${LIQ_LineFee_ReversePayment_Cashflow_OK_Button} 
    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LineFee_ReversePayment_WorkflowItems}    Send to Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeeReverseWindow_SendToApproval
    
Approve Reverse Fee Payment
    [Documentation]    This keyword approves the Ongoing Fee Payment from LIQ.
    ...    @author: cfrancis    - 01OCT2020    - initial create

    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_ReversePayment_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LineFee_ReversePayment_WorkflowItems}    Approval%d
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Fee.*;Question;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500
    Run Keyword And Continue On Failure     Mx LoanIQ Click Button On Window    Commitment Fee.*;Warning;Yes    strProcessingObj="JavaWindow(\"title:=Processing.*\")"    WaitForProcessing=500

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeeReverseWindow_WorkflowTab_Approval
    
Release Reverse Fee Payment
    [Documentation]    This keyword releases the Ongoing Fee Payment from LIQ.
    ...    @author: cfrancis    - 01OCT2020    - initial create

    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_ReversePayment_Tab}    Workflow
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LineFee_ReversePayment_WorkflowItems}    Release%d
    Validate if Question or Warning Message is Displayed

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeeReverseWindow_WorkflowTab_Release
    
Change Expiry Date of Line Fee
    [Documentation]    This keyword changes the expiry date of the Line Fee from LIQ
    ...    @author: cfrancis    -06OCT2020    - initial create
    [Arguments]    ${sExpiryDate}
    
    mx LoanIQ activate window    ${LIQ_LineFee_Window}
    Mx LoanIQ Select    ${LIQ_LineFee_Update_Menu}
    Mx LoanIQ Select    ${LIQ_LineFee_ChangeExpiryDate_Menu}
    mx LoanIQ enter    ${LIQ_LineFee_ExpiryDate}    ${sExpiryDate}
    mx LoanIQ click    ${LIQ_LineFee_ExpiryDate_OK_Button}
    mx LoanIQ click element if present    ${LIQ_LineFee_ExpiryDate_OK_Button}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeeWindow_ChangeExpiryDate