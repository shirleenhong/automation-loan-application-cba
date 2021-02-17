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
    ...    @update: added pre-processing keyword and screenshot
    [Arguments]    ${sOngoingFee_Type}    
    ### GetRuntime Keyword Pre-processing ###
    ${OngoingFee_Type}    Acquire Argument Value    ${sOngoingFee_Type}

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_OngoingFeeList}
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Facility_FeeList_JavaTree}    ${sOngoingFee_Type}%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow
    
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
 
Get Notice Details in General Tab for Line Fee
    [Documentation]    This keyword navigates to General Tab and gets data for notice details.
    ...    @author: makcamps    15JAN2021    - Initial Create
    
    mx LoanIQ activate window    ${LIQ_LineFee_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_LineFeeTag_Tab}    General
        
    ${RequestedAmount}    Mx LoanIQ Get Data    ${LIQ_OngoingFeePayment_Requested_Value}    value%test
    ${FeeType}    Mx LoanIQ Get Data    ${LIQ_OngoingFeePayment_FeeType_Text}    value%test
    ${Currency}    Mx LoanIQ Get Data    ${LIQ_OngoingFeePayment_Currency_Text}    value%test
    ${EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_OngoingFeePayment_EffectiveDate_Textfield}    value%test
    
    [Return]    ${RequestedAmount}    ${FeeType}    ${Currency}    ${EffectiveDate}
    
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
    ...    @author: ritragel    06SEP2020
    ...    @update: makcamps    14JAN2021    - added condition that if pay type is provided, update pay type
    ...    @update: makcamps    20JAN2021    - updated sequence for updating line fee
    ...    @update: songchan    25JAN2021    - updated sequence for updating Pay type and Cycle Frequency
    ...    @update: makcamps    08FEB2021    - updated click inquiry button if present
    [Arguments]    ${sEffectiveDate}    ${sActual_DueDate}    ${sAdjusted_DueDate}    ${sCycle_Frequency}    ${sAccrue}    ${sFloatRateDate}=None    ${sPayType}=None
    
    ### Keyword Pre-processing ###
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${Actual_DueDate}    Acquire Argument Value    ${sActual_DueDate}
    ${Cycle_Frequency}    Acquire Argument Value    ${sCycle_Frequency}
    ${Adjusted_DueDate}    Acquire Argument Value    ${sAdjusted_DueDate}
    ${FloatRateDate}    Acquire Argument Value    ${sFloatRateDate}
    ${Accrue}    Acquire Argument Value    ${sAccrue}
    ${PayType}    Acquire Argument Value    ${sPayType}

    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window}
    Mx Click Element If Present    ${LIQ_LineFee_InquiryMode_Button}  
    Run Keyword If    '${PayType}'!='None'    mx LoanIQ Select Combo Box Value    ${LIQ_LineFee_PayType_Dropdown}    ${PayType}
    mx LoanIQ enter    ${LIQ_LineFee_EffectiveDate_Field}    ${EffectiveDate} 
    Mx Press Combination    Key.ENTER 
    Run Keyword If    '${PayType}'!='None'    mx LoanIQ enter    ${LIQ_LineFee_FloatRate_Date}    ${FloatRateDate}
    Mx Click Element If Present    ${LIQ_Warning_OK_Button}
    mx LoanIQ Select Combo Box Value    ${LIQ_LineFee_Cycle}    ${Cycle_Frequency}
    mx LoanIQ enter    ${LIQ_LineFee_ActualDue_Date}    ${Actual_DueDate}
    Mx Click Element If Present    ${LIQ_Warning_OK_Button}
    mx LoanIQ enter    ${LIQ_LineFee_AdjustedDue_Date}    ${Adjusted_DueDate}  
    Mx Click Element If Present    ${LIQ_Warning_OK_Button}
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

Initiate Line Fee Payment
    [Documentation]    This keyword selects a cycle fee payment for projected Due amount.
    ...    @author: dahijara    15OCT2020    Initial Create 
    [Arguments]    ${sCycle_Number} 

    ### GetRuntime Keyword Pre-processing ###
    ${Cycle_Number}    Acquire Argument Value    ${sCycle_Number}

    mx LoanIQ activate window    ${LIQ_LineFee_Window}    
    mx LoanIQ select    ${LIQ_LineFee_General_OptionsPayment_Menu}
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeePayment
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button}

    mx LoanIQ enter    ${LIQ_CommitmentFee_Cycles_ProjectedDue_RadioButton}    ON   

    ${CycleDueAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Cyces_Javatree}    ${Cycle_Number}%Cycle Due%value
    ${CycleDueAmount}    Remove comma and convert to number - Cycle Due    ${CycleDueAmount}
    Write Data To Excel    CAP02_CapitalizedFeePayment    OngoingFee_CycleDue    ${rowid}    ${CycleDueAmount}   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeePayment
    mx LoanIQ click    ${LIQ_CommitmentFee_Cycles_OK_Button} 
    ${SystemDate}    Get System Date
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    mx LoanIQ click element if present    ${LIQ_LineFee_InquiryMode_Button} 
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_EffectiveDate_DateField}    ${SystemDate} 
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_RequestedAmount_Textfield}    ${CycleDueAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeePayment

Initiate Line Fee Payment for LLA Syndicated Deal
    [Documentation]    This keyword selects a cycle fee payment for projected Due amount.
    ...    @author: makcamps    15JAN2021    - Initial Create 
    [Arguments]    ${sCycle_Number}    ${sEffectiveDate}

    ### GetRuntime Keyword Pre-processing ###
    ${Cycle_Number}    Acquire Argument Value    ${sCycle_Number}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}

    mx LoanIQ activate window    ${LIQ_LineFee_Window}    
    mx LoanIQ select    ${LIQ_LineFee_General_OptionsPayment_Menu}
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeePayment
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button}

    mx LoanIQ enter    ${LIQ_CommitmentFee_Cycles_ProjectedDue_RadioButton}    ON   

    ${CycleDueAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CommitmentFee_Cyces_Javatree}    ${Cycle_Number}%Projected Cycle Due%value
    ${CycleDueAmount}    Remove comma and convert to number - Cycle Due    ${CycleDueAmount}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeePayment
    mx LoanIQ click    ${LIQ_CommitmentFee_Cycles_OK_Button}
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    mx LoanIQ click element if present    ${LIQ_LineFee_InquiryMode_Button} 
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_EffectiveDate_DateField}    ${EffectiveDate} 
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_RequestedAmount_Textfield}    ${CycleDueAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeePayment

Close Fee Payment Notice Window
    [Documentation]    This keyword closes Fee Payment Notice Window. 
    ...    @author: dahijara    15OCT2020    - Initial create
    mx LoanIQ click    ${LIQ_FeePayment_Notice_Exit_Button}
    
Retrieve Initial Amounts in Line Fee Accrual Tab and Evaluate Expected Values for Reversal Post Validation
    [Documentation]    This keyword is used retrieve Paid to date and Cycle Due values on the accrual tab before processing Payment Reversal. Expected amount are also computed.
    ...    @author: shirhong    14DEC2020    - initial create
    [Arguments]    ${sCycleNo}    ${sReversalAmount}    ${sRunVar_CycleDue_Expected}=None    ${sRunVar_Paidtodate_Expected}=None

    ### GetRuntime Keyword Pre-processing ###
    ${CycleNo}    Acquire Argument Value    ${sCycleNo}
    ${ReversalAmount}    Acquire Argument Value    ${sReversalAmount}

    mx LoanIQ activate window    ${LIQ_Fee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Fee_Tab}    Accrual

    ###Retrieve Cycle Due before Payment Reversal###
    ${CycleDue_beforeReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FeeNotebook_Accrual_JavaTree}    ${CycleNo}%Cycle Due%value              
    ${CycleDue_beforeReversal}    Remove comma and convert to number    ${CycleDue_beforeReversal}
    
    ###Retrieve Paid to date before Payment Reversal###
    ${Paidtodate_beforeReversal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FeeNotebook_Accrual_JavaTree}    ${CycleNo}%Paid to date%value
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
    
Retrieve Initial Data from GL Entries After Payment for Line Fee
    [Documentation]    This keyword is used retrieve GL Entries detailsof the Line Fee Payment Released.
    ...    @author: shirhong    14DEC2020    - initial create
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
    mx LoanIQ activate window    ${LIQ_Fee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Fee_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Fee_Events_Javatree}   Fee Payment Released
    Mx LoanIQ DoubleClick   ${LIQ_Fee_Events_Javatree}    Fee Payment Released
    
    ###Open GL Entries Window###
    mx LoanIQ select    ${LIQ_Fee_Queries_GLEntries}    
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

    [Return]    ${DebitAmt_Customer}    ${CreditAmt_Customer}    ${DebitAmt_Host}    ${CreditAmt_Host}    ${TotalDebitAmt}    ${TotalCreditAmt}
    
Create Line Fee Payment Reversal After Fee Payment is Released
    [Documentation]    This keyword initiates payment reversal after Line Fee Payment is released.
    ...    @author: shirhong    14DEC2020    - initial create
    [Arguments]    ${sReversal_Comment}    ${sSystemDate}    ${sEffectiveDate_Label}    ${sWindow}    ${sFeePaymentAmount}
    ### GetRuntime Keyword Pre-processing ###
    ${Reversal_Comment}    Acquire Argument Value    ${sReversal_Comment}
    ${SystemDate}    Acquire Argument Value    ${sSystemDate}
    ${EffectiveDate_Label}    Acquire Argument Value    ${sEffectiveDate_Label}
    ${Window}    Acquire Argument Value    ${sWindow}
    ${FeePaymentAmount}    Acquire Argument Value    ${sFeePaymentAmount}

    mx LoanIQ activate window    ${LIQ_OngoingFeePaymentNotebook_Window}  
    mx LoanIQ select    ${LIQ_Fee_ReversePayment}
    Verify If Warning Is Displayed
    mx LoanIQ activate window    ${LIQ_ReverseFee_Window}
    
    ###Verify Window Status after Reverse Payment creation is initiated- now Pending###
    Validate Window Title Status    ${Window}    Pending
    
    ###Supply Reversal comment stating that Interest is waived###
    mx LoanIQ enter    ${LIQ_ReversePayment_Comment_Textfield}    ${Reversal_Comment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ReversePayment
    mx LoanIQ click    ${LIQ_ReversePayment_UpdateMode_Button}   
    
    ${Question_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Question_OK_Button}    VerificationData="Yes"
    Run Keyword If    ${Question_Displayed}==${True}    mx LoanIQ click element if present    ${LIQ_Question_OK_Button}
    
    ###Verify that the Reversal comment is saved###
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Line Fee Reverse Fee.*").JavaEdit("value:=.*${Reversal_Comment}")    VerificationData="Yes"
    ${Comment_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Line Fee Reverse Fee.*").JavaEdit("value:=.*${Reversal_Comment}")    VerificationData="Yes"
    Run Keyword If    ${Comment_Status}==${True}    Log    Reason for Payment Reversal is applied.
    ...    ELSE    Log    Reason for Payment Reversal - Comment is not applied.    level=WARN  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ReversePayment  
    
Get Cashflow Details from Released Cycle Share Adjustment - Payment Reversal
    [Documentation]    This keyword is used to get the cashflow ID and write the value in the dataset
    ...    @author: shirhong    14DEC2020    - initial create
    [Arguments]    ${sBorrower_ShortName}   ${sDeal_Name}
    
    ${Borrower_Shortname}    Acquire Argument Value    ${sBorrower_ShortName}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    ###Navigate to Fee Payment released###
    mx LoanIQ activate window    ${LIQ_Fee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Fee_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Fee_Events_Javatree}   Reverse Payment Released
    Mx LoanIQ DoubleClick   ${LIQ_Fee_Events_Javatree}    Reverse Payment Released
    
    ###Open Cashflow Details From Released Initial Loan Drawdown###
    Open Cashflows Window from Notebook Menu    ${LIQ_ReverseFee_Window}    ${LIQ_ReverseFee_Options_Cashflow}
    mx LoanIQ activate window    ${LIQ_Cashflows_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialLoanDrawdown_CashflowWindow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${Borrower_Shortname}%d
    mx LoanIQ activate window    ${LIQ_Cashflows_DetailsForCashflow_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowDetails
    mx LoanIQ send keys    {F8}
    
    ###Get the Actual Cashflow ID and Open the Deal###
    mx LoanIQ activate window    ${LIQ_UpdateInformation_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflow_UpdateDetails
    mx LoanIQ click    ${LIQ_Cashflows_UpdateInformation_CopyRID_Button}
    mx LoanIQ click    ${LIQ_UpdateInformation_Exit_Button}
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_Exit_Button}
    mx LoanIQ close window    ${LIQ_Cashflows_Window}
    
    Close All Windows on LIQ
    Open Existing Deal    ${Deal_Name}
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
       
    ###Set The Cashflow ID in Variable and Write To Report Validation Sheet###
    ### Tabs with highlight does not return any text and method is not working ###
    ${IsClicked}    Run Keyword And Return Status    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Comments
    Run Keyword If    ${IsClicked}==${False}    Pause Execution    Manually click Comments tab then click OK.     ### Raised TACOE-1193/GDE-9343 for the issue
    mx LoanIQ click    ${LIQ_DealNotebook_CommentsTab_Add_Button}
    mx LoanIQ enter    ${LIQ_DealNotebook_CommentEdit_Comment_Textbox}    /
    mx LoanIQ send keys    ^{V}
    ${CashflowID}    Mx LoanIQ Get Data    ${LIQ_DealNotebook_CommentEdit_Comment_Textbox}    value%rid
    mx LoanIQ close window    ${LIQ_DealNotebook_CommentEdit_Window}    
    ${CashflowID}    Remove String    ${CashflowID}    /
    ${CashflowID}    Strip String    ${CashflowID}    mode=both
    Log To Console    ${CashflowID}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflow_ID
    [Return]    ${CashflowID}

Initiate Payment for Line Fee
    [Documentation]    This keyword selects a cycle fee payment for projected Due amount and validate cycle due amount.
    ...    @author: dahijara    11JAN2021    Initial Create 
    [Arguments]    ${sCycle_Number}    ${sExpectedCycleDueAmt}    ${sEffectiveDate}

    ### GetRuntime Keyword Pre-processing ###
    ${Cycle_Number}    Acquire Argument Value    ${sCycle_Number}
    ${ExpectedCycleDueAmt}    Acquire Argument Value    ${sExpectedCycleDueAmt}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}

    mx LoanIQ activate window    ${LIQ_LineFee_Window}    
    mx LoanIQ select    ${LIQ_LineFee_General_OptionsPayment_Menu}
    mx LoanIQ enter    ${LIQ_ChoosePayment_Fee_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeePayment
    mx LoanIQ click    ${LIQ_ChoosePayment_OK_Button}

    mx LoanIQ enter    ${LIQ_CommitmentFee_Cycles_ProjectedDue_RadioButton}    ON   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeePayment
    mx LoanIQ click    ${LIQ_CommitmentFee_Cycles_OK_Button} 

    mx LoanIQ activate window    ${LIQ_Payment_Window}
    mx LoanIQ click element if present    ${LIQ_LineFee_InquiryMode_Button} 
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_EffectiveDate_DateField}    ${EffectiveDate}
    ${UI_CycleAmount}    Mx LoanIQ Get Data    ${LIQ_OngoingFeePayment_RequestedAmount_Textfield}    text%CycleAmount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${ExpectedCycleDueAmt}    ${UI_CycleAmount}
    Run Keyword If    ${Status}==${True}    Log    Default Requested amount is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Default Requested amount is NOT correct. Expected: ${ExpectedCycleDueAmt} - Actual: ${UI_CycleAmount}
    mx LoanIQ enter    ${LIQ_OngoingFeePayment_RequestedAmount_Textfield}    ${UI_CycleAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeePayment

Verify Details in Accrual Tab for Line Fee
    [Documentation]    This keyword is used for navigating and verifies details in Accrual Tab.
    ...    @author: dahijara    11JAN2021    - initial create
    [Arguments]    ${sCycleNo}    ${sStartDate}    ${sEndDate}    ${sDueDate}    ${sCycleDue}    ${sProjectedCycleDue}

    ### GetRuntime Keyword Pre-processing ###
    ${CycleNo}    Acquire Argument Value    ${sCycleNo}
    ${StartDate}    Acquire Argument Value    ${sStartDate}
    ${EndDate}    Acquire Argument Value    ${sEndDate}
    ${DueDate}    Acquire Argument Value    ${sDueDate}
    ${CycleDue}    Acquire Argument Value    ${sCycleDue}
    ${ProjectedCycleDue}    Acquire Argument Value    ${sProjectedCycleDue}

    
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Accrual
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LineFee_Accrual_Cycles_JavaTree}            VerificationData="Yes"
    
    ${UI_StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%Start Date%value    
    ${UI_EndDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%End Date%value
    ${UI_DueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%Due Date%value
    ${UI_CycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%Cycle Due%value
    ${UI_ProjectedCycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNo}%Projected EOC due%value
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFee_AccrualTab
	
    ### Start Date ###
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${StartDate}    ${UI_StartDate}
    Run Keyword If    ${Status}==${True}    Log    Cycle Start Date is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Cycle Start Date is NOT correct. Expected: ${StartDate} - Actual: ${UI_StartDate}

    ### End Date ###
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${EndDate}    ${UI_EndDate}
    Run Keyword If    ${Status}==${True}    Log    Cycle End Date is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Cycle End Date is NOT correct. Expected: ${EndDate} - Actual: ${UI_EndDate}

    ### Due Date ###
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${DueDate}    ${UI_DueDate}
    Run Keyword If    ${Status}==${True}    Log    Cycle Due Date is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Cycle Due Date is NOT correct. Expected: ${DueDate} - Actual: ${UI_DueDate}

    ### Cycle Due ###
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${CycleDue}    ${UI_CycleDue}
    Run Keyword If    ${Status}==${True}    Log    Cycle Due is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Cycle Due is NOT correct. Expected: ${CycleDue} - Actual: ${UI_CycleDue}

    ### Projected Cycle Due ###
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${ProjectedCycleDue}    ${UI_ProjectedCycleDue}
    Run Keyword If    ${Status}==${True}    Log    Projected Cycle Due is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Projected Cycle Due is NOT correct. Expected: ${ProjectedCycleDue} - Actual: ${UI_ProjectedCycleDue}

Validate Payment Release of Ongoing Line Fee
    [Documentation]    This keyword validates the payment release of Ongoing Fee on Events tab.
    ...    @author: dahijara    11JAN2021    - initial create

    mx LoanIQ activate window    ${LIQ_LineFee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_LineFee_Events_Javatree}   Fee Payment Released
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeeWindow_EventsTab_OngoingFeePayment

Validate After Payment Details on Acrual Tab - Line Fee
    [Documentation]    This keyword validates the after payment details on Acrual Tab for Line Fee.
    ...    @author: dahijara    11JAN2021    - initial create
    ...    @update: makcamps    22JAN2021    - added cycle due argument and condition
    [Arguments]    ${sExpected_PaymentAmt}    ${sCycleNumber}    ${sExpected_CycleDue}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Expected_PaymentAmt}    Acquire Argument Value    ${sExpected_PaymentAmt}
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    ${Expected_CycleDue}    Acquire Argument Value    ${sExpected_CycleDue}

    mx LoanIQ activate window    ${LIQ_LineFeeReleasedNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Accrual
    
    ${CycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNumber}%Cycle Due%CycleDue    
    ${Status}    Run Keyword If    '${Expected_CycleDue}'=='None'    Run Keyword And Return Status    Should Be Equal    0.00    ${CycleDue}
    ...    ELSE    Run Keyword And Return Status    Should Be Equal    ${Expected_CycleDue}    ${CycleDue}
    ${Expected_CycleDue}    Run Keyword If    '${Expected_CycleDue}'=='None'    Set Variable    0.00
    Run Keyword If    ${Status}==${True}    Log    Cycle Due is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Cycle Due is NOT correct. Expected: ${Expected_CycleDue} - Actual: ${CycleDue}
    
    ${PaidToDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineFee_Accrual_Cycles_JavaTree}    ${CycleNumber}%Paid to date%PaidToDate
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${PaidToDate}    ${Expected_PaymentAmt}
    Run Keyword If    ${Status}==${True}    Log    Paid To Date Amount is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Paid To Date Amount is NOT correct. Expected: ${Expected_PaymentAmt} - Actual: ${PaidToDate}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FeeWindow_AccrualTab_LineFeeAccruals

Validate Line Fee Events Tab
    [Documentation]    This keyword validates the Line Fee Events tab.
    ...    @author: ccarriedo    04Feb2021    - initial create
    [Arguments]    ${sEvent_Name}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Event_Name}    Acquire Argument Value    ${sEvent_Name}

    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Events

    ${Event_Selected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_LineFee_Events_Javatree}    ${Event_Name}
    Run Keyword If    ${Event_Selected}==${True}    Log    ${Event_Name} is shown in the Events list of Line Fee Notebook.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${Event_Name} is NOT shown in the Events list of Line Fee Notebook.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LineFeeWindow_EventsTab_Released

Navigate Line Fee Notebook from Deal Notebook
    [Documentation]    This keyword navigates LIQ User to the Line Fee Notebook from Deal Notebook.
    ...    @author: dahijara    16FEB2021    Initial create
    [Arguments]    ${sFacility_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}   
    mx LoanIQ select    ${LIQ_DealNotebook_Options_OngoingFeeList_Menu}
    mx LoanIQ activate window    ${LIQ_DealNotebook_FeeList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeeList_JavaTree}    ${Facility_Name}%d
    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window} 

Validate Rate in Line Fee Notebook - General Tab
    [Documentation]    This keyword is used to validate if rates in Pricing Formula In Effect and Current rate fields are correct.
    ...    @author: dahijara    16FEB2021    Initial create
    [Arguments]    ${sPricing_Formula_In_Effect}    ${sCurrent_Rate}
    
    ### Keyword Pre-processing ###
    ${Pricing_Formula_In_Effect}    Acquire Argument Value    ${sPricing_Formula_In_Effect}
    ${Current_Rate}    Acquire Argument Value    ${sCurrent_Rate}
    
    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Fee_Tab}    ${GENERAL_TAB}
    Validate Loan IQ Details    ${Pricing_Formula_In_Effect}    ${LIQ_LineFee_PricingFormulaInEffect_TextField}    
    Validate Loan IQ Details    ${Current_Rate}    ${LIQ_LineFee_CurrentRate_Field} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CommitmentFeeWindow_GeneralTab_NewRate