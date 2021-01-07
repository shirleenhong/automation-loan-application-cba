*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate to Drawdown Cashflow Window
    [Documentation]    This keyword is used to navigate to the Drawdown Cashflow Window thru the Workflow action - Create Cashflow.
    ...    @author: rtarayao
    ...    @update: mnanquilada - Add Mx Click Element If Present
    ...    @update: ritragel    03MAR19    Updated for the global of cashflow keywords
    ...    @update: hstone     22MAY2020     - Updated the logic for Cashflows Window Displayed Validation
    ...                                      - Removed Sleep
    ...                                      - Added Take Screenshot
    ...    @update: clanding    10AUG2020    - Replaced hard coded values to global variables
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    ${CREATE_CASHFLOWS_TYPE}
   :FOR    ${i}    IN RANGE    7
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==${False} 
    Wait Until Keyword Succeeds    3x    5 sec    Mx LoanIQ Verify Object Exist    ${LIQ_Cashflows_Window}      VerificationData="Yes"
    mx LoanIQ activate window    ${LIQ_Cashflows_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Chashflows

Input Initial Loan Drawdown Details
    [Documentation]    This keyword is used to fill out the Initial information needed in the Outstanding Select Window to proceed on the creation of the Loan Drawdown.
    ...    @author: rtarayao
    ...    @author: ghabal - added write option for Scenario 4
    ...    @update: mnanquil 12/18/2018
    ...    @update: fmamaril    05MAR2019    Comment Writing on Low Level keyword
    ...    @update: amansuet    24APR2020    added keyword pre and post-processing
    ...    @update: hstone      18JUN2020    Added additioanl acquire argmument values
    ...                                      Added Take Screenshot
    [Arguments]    ${sOutstanding_Type}    ${sLoan_FacilityName}    ${sLoan_Borrower}    ${sLoan_PricingOption}    ${sLoan_Currency}    ${sRuntime_Variable}=None
    
    ### GetRuntime Keyword Pre-processing ###
    ${Outstanding_Type}    Acquire Argument Value    ${sOutstanding_Type}
    ${Loan_FacilityName}    Acquire Argument Value    ${sLoan_FacilityName}
    ${Loan_Borrower}    Acquire Argument Value    ${sLoan_Borrower}
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
    ${Loan_Currency}    Acquire Argument Value    ${sLoan_Currency}

    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}    
    mx LoanIQ enter    ${LIQ_OutstandingSelect_New_RadioButton}    ON        
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Outstanding_Type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Loan_FacilityName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Borrower_Dropdown}    ${Loan_Borrower}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    ${Loan_PricingOption}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Currency_Dropdown}    ${Loan_Currency}      
    ${Loan_Alias}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Alias_JavaEdit}    Loan Alias    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect
    
    mx LoanIQ click    ${LIQ_OutstandingSelect_OK_Button}
    
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${status}==False
    
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${Loan_Alias}

    [Return]    ${Loan_Alias}
        
Validate Initial Loan Dradown Details
    [Documentation]    This keyword is used to validate Initial Loan Drawdown.
    ...    @author: rtarayao
    ...    @update: amansuet    added keyword pre processing
    ...    @update: hstone    22MAY2020     - Added Take Screenshot
    ...    @update: hstone    17JUN2020     - Added additional acquire argument value
    [Arguments]    ${sLoan_FacilityName}    ${sLoan_Borrower}    ${sLoan_Currency}

    ### GetRuntime Keyword Pre-processing ###
    ${Loan_FacilityName}    Acquire Argument Value    ${sLoan_FacilityName}
    ${Loan_Borrower}    Acquire Argument Value    ${sLoan_Borrower}
    ${Loan_Currency}    Acquire Argument Value    ${sLoan_Currency}
    
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    General
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Initial Drawdown .*").JavaStaticText("attached text:=${Loan_FacilityName}")          VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Initial Drawdown .*").JavaStaticText("attached text:=${Loan_Borrower}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_InitialDrawdown_RequestedCCY_StaticDropdown}    value%${Loan_Currency}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_General
       
Input General Loan Drawdown Details
    [Documentation]    This keyword is used to input Loan Drawdown details in the General tab.
    ...    @update: mnanquil                 Added save loan drawdown details
    ...    @update: bernchua    22AUG2019    Updated get data line, used generic keyword for warning messages.
    ...    @update: bernchua    23AUG2019    Added taking of screenshots  
    ...    @update: hstone      04SEP2019    Added optional repricing date setting
    ...    @update: fmamaril    09SEP2019    Added handling for the maturity date can be default 
    ...    @update: rtarayao    01OCT2019    Added optional argument for Risk Type
    ...    @update: hstone      22MAY2020    Updated Take Screenshot Path
    ...    @update: hstone      18JUN2020    Added Keyword Pre-processing
    ...                                      Added Optional Argument: ${sRunTimeVar_AdjustedDueDate}
    ...                                      Added Keyword Post-processing
    ...    @update: clanding    10AUG2020    Replaced hard coded value to global variable
    [Arguments]    ${sLoan_RequestedAmount}    ${sLoan_EffectiveDate}    ${sLoan_MaturityDate}=None    ${sLoan_RepricingFrequency}=None    ${sLoan_IntCycleFrequency}=None    ${sLoan_Accrue}=None    ${sRepricing_Date}=None    ${sLoan_RiskType}=None
    ...        ${sRunTimeVar_AdjustedDueDate}=None
    
    ### Keyword Pre-processing ###
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}
    ${Loan_EffectiveDate}    Acquire Argument Value    ${sLoan_EffectiveDate}
    ${Loan_MaturityDate}    Acquire Argument Value    ${sLoan_MaturityDate}
    ${Loan_RepricingFrequency}    Acquire Argument Value    ${sLoan_RepricingFrequency}
    ${Loan_IntCycleFrequency}    Acquire Argument Value    ${sLoan_IntCycleFrequency}
    ${Loan_Accrue}    Acquire Argument Value    ${sLoan_Accrue}
    ${Repricing_Date}    Acquire Argument Value    ${sRepricing_Date}
    ${Loan_RiskType}    Acquire Argument Value    ${sLoan_RiskType}

    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    ${GENERAL_TAB} 
    mx LoanIQ enter    ${LIQ_InitialDrawdown_RequestedAmt_Textfield}    ${Loan_RequestedAmount} 
    mx LoanIQ enter    ${LIQ_InitialDrawdown_EffectiveDate_Datefield}    ${Loan_EffectiveDate}
    Run Keyword If    '${Loan_MaturityDate}'!='None'    mx LoanIQ enter    ${LIQ_InitialDrawdown_MaturityDate_Datefield}    ${Loan_MaturityDate} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_General
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_General
    Log    ${Loan_RepricingFrequency}
    Run Keyword If    '${Loan_RepricingFrequency}'!='None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Repricing_Dropdownlist}    ${Loan_RepricingFrequency}
    Run Keyword If    '${Loan_IntCycleFrequency}'!='None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_IntCycleFreq_Dropdownlist}    ${Loan_IntCycleFrequency}
    Run Keyword If    '${Loan_Accrue}'!='None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Accrue_Dropdownlist}    ${Loan_Accrue} 
    Run Keyword If    '${Repricing_Date}'!='None'    mx LoanIQ enter    ${LIQ_InitialDrawdown_RepricingDate_Datefield}    ${Repricing_Date}  
    Run Keyword if    '${Loan_RiskType}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_InitialDrawdown_RiskType_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_InitialDrawdown_SelectRiskType_Window}
    ...    AND    Mx LoanIQ Select String    ${LIQ_InitialDrawdown_SelectRiskType_JavaTree}    ${Loan_RiskType}
    ...    AND    mx LoanIQ click    ${LIQ_InitialDrawdown_SelectRiskType_OK_Button}    
    ${AdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_AdjustedDueDate_Datefield}    value%date
    Verify If Warning Is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_General

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_AdjustedDueDate}    ${AdjustedDueDate}

    [Return]    ${AdjustedDueDate}

Input Loan Drawdown Rates
    [Documentation]    This keyword is used to input Loan Drawdown Base Rate within the Rates tab.
    ...    @author: rtarayao
    ...    @update: ritragel    03SEP2019    Updated to 4 decimal places
    ...    @update: hstone      13MAY2020    Added Click Element if Present for a Warning Message
    ...    @update: hstone      22MAY2020    - Added Take Screenshot
    ...    @update: dahijara    03JUL2020    - Added keywords for pre-processing
    ...    @update: clanding    10AUG2020    - Replaced hard coded value to global variable; refactor argument
    [Arguments]    ${sBorrower_BaseRate}    ${sFacility_Spread}    ${sWriteBaseRate}=Y    ${sRuntime_Variable_AllInRate}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_BaseRate}    Acquire Argument Value    ${sBorrower_BaseRate}
    ${Facility_Spread}    Acquire Argument Value    ${sFacility_Spread}
    ${writeBaseRate}    Acquire Argument Value    ${sWriteBaseRate}

    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    ${RATES_TAB}
    mx LoanIQ click    ${LIQ_InitialDrawdown_BaseRate_Button}
      
    :FOR    ${i}    IN RANGE    4
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${status}    Run Keyword And Return Status    Validate Warning Message Box          
    \    Exit For Loop If    ${status}==False
    
    mx LoanIQ click element if present    ${LIQ_Question_No_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    Run Keyword If    '${writeBaseRate}'=='Y'    mx LoanIQ enter    ${LIQ_InitialDrawdown_BorrowerBaseRate_Textfield}    ${Borrower_BaseRate} 
    mx LoanIQ click    ${LIQ_InitialDrawdown_SetBaseRate_OK_Button}       
    
    ${Computed_AllInRate}    Evaluate    ${Borrower_BaseRate}+${Facility_Spread}
    Convert To Number    ${Computed_AllInRate}    4
            
    ${AllInRate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_AllInRate}    value%AllInRate
    ${AllInRate}    Remove String    ${AllInRate}    %
    ${AllInRate}    Convert To Number    ${AllInRate}    4    
    
    Should Be Equal As Numbers    ${Computed_AllInRate}    ${AllInRate} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_Rates
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable_AllInRate}    ${AllInRate}
    [Return]    ${AllInRate}          
        
Create Principal Repayment Schedule
    [Documentation]    This keyword is used to create a Loan Repayment Schedule.
    ...    @author: rtarayao
    ...    @update: fmamaril    05MAR2019    - Remove writing on excel for low level keyword
    ...    @update: ritragel    07MAY2019    - Removed writing and updated as per scripting standards
    ...    @update: hstone      19MAY2020    - Added Keyword Pre-processing
    ...                                      - Added ${sRuntime_Variable} optional argument
    ...                                      - Added Keyword Post-processing
    ...   @update: hstone       22MAY2020    - Removed duplicate 'mx LoanIQ click    ${LIQ_AutomaticScheduleSetup_OK_Button}'
    ...                                      - Added Take Screenshots
    ...   @update: clanding     10AUG2020    - Replaced hard coded values to global variables
    [Arguments]    ${sRepayment_ScheduleFrequency}    ${sRepayment_NumberOfCycles}    ${sRepayment_TriggerDate}    ${sRepayment_NonBusDayRule}    ${sLoan_RequestedAmount}    ${sRuntime_Variable}=None
    
    ### Keyword Pre-processing ###
    ${Repayment_ScheduleFrequency}    Acquire Argument Value    ${sRepayment_ScheduleFrequency}
    ${Repayment_NumberOfCycles}    Acquire Argument Value    ${sRepayment_NumberOfCycles}
    ${Repayment_TriggerDate}    Acquire Argument Value    ${sRepayment_TriggerDate}
    ${Repayment_NonBusDayRule}    Acquire Argument Value    ${sRepayment_NonBusDayRule}
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}

    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}    
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_RepaymentSchedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_RepaymentSchedule_ScheduleType_Cancel_Button}
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule
    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_CurrentSchedule_POBM_Text}        VerificationData="Yes"
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Reschedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
   
    Validate Loan Repayment Schedule Types
    
    Mx LoanIQ Verify Runtime Property    ${LIQ_RepaymentSchedule_ScheduleType_Prorate_CheckBox}    enabled%1
    mx LoanIQ enter    ${LIQ_RepaymentSchedule_ScheduleType_PrincipalOnly_RadioButton}    ${ON}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule
    mx LoanIQ click    ${LIQ_RepaymentSchedule_ScheduleType_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate    ${LIQ_AutomaticScheduleSetup_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AutomaticScheduleSetup
    Run Keyword If   '${SCENARIO}'=='7'    Mx LoanIQ Select Combo Box Value    ${LIQ_AutomaticScheduleSetup_Frequency_Dropdown}    ${Repayment_ScheduleFrequency}
    Run Keyword If   '${SCENARIO}'=='7'    mx LoanIQ enter    ${LIQ_AutomaticScheduleSetup_NumberOfCycles_Textfield}    ${Repayment_NumberOfCycles}
    mx LoanIQ enter    ${LIQ_AutomaticScheduleSetup_TriggerDate_Textfield}    ${Repayment_TriggerDate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AutomaticScheduleSetup
    mx LoanIQ click    ${LIQ_AutomaticScheduleSetup_OK_Button}
    
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${status}==${False}   
    
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_CurrentSchedule_PrincipalOnly_Text}        VerificationData="Yes"
    ${Repayment_RemainingBalance}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentSchedule_List}    ${Repayment_NumberOfCycles}%Remaining%RepaymentBalance   
    Log    ${Repayment_RemainingBalance}
    Should Be Equal    0.00    ${Repayment_RemainingBalance}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_RepaymentSchedule_NonBusDayRule_Dropdown}    ${Repayment_NonBusDayRule}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    
    :FOR    ${i}    IN RANGE    3
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${status}==${False}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Exit_Button}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${Repayment_NumberOfCycles}

    [RETURN]    ${Repayment_NumberOfCycles}
    
Compute Loan Principal Repayment Amount Per Cycle
    [Documentation]    This keyword computes and validate the Amount per cycle for Scheduled Principal payment.
    ...    @author: rtarayao
    ...    @update: ritragel    Updated locators for Automatic Schedule Setup
    [Arguments]    ${Loan_RequestedAmount}
    
    mx LoanIQ activate    ${LIQ_AutomaticScheduleSetup_Window}    
    ${Repayment_Cycle}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_NumberOfPayments}    value%Cycle 
    ${Amount}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_Amount}    value%Amount
    
    ${Repayment_Amount}    Remove Comma and Convert to Number    ${Amount}
    
    ${Repayment_ComputedAmountPerCycle}    Evaluate    ${Loan_RequestedAmount}/${Repayment_Cycle}
    ${Repayment_ComputedAmountPerCycle}    Convert To Number    ${Repayment_ComputedAmountPerCycle}    2
           
    Should Be Equal    ${Repayment_Amount}    ${Repayment_ComputedAmountPerCycle}
     
    Log    Repayment_Amount UI Value=${Repayment_Amount}
    Log    Computed Amount=${Repayment_ComputedAmountPerCycle}     
    
Validate Loan Repayment Schedule Types
    [Documentation]    This keyword is used to verify that all Options for Repayment Schedule exists within the Choose Schedule Type window.
    ...    @author: rtarayao   
        
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_ChooseScheduleType_Window}
    
    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_ScheduleType_PrincipalOnly_RadioButton}      VerificationData="Yes"
    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_ScheduleType_FPPID_RadioButton}    VerificationData="Yes"
    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_ScheduleType_POBM_RadioButton}     VerificationData="Yes"
    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_ScheduleType_FPPI_RadioButton}    VerificationData="Yes"
    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_ScheduleType_FlexSchedule_RadioButton}    VerificationData="Yes"
         
Send Loan Drawdown to Approval
    [Documentation]    This keyword is used to Send the Loan Drawdown for Approval.
    ...    @author: rtarayao
    ...    @update: mnanquilada - Change the verify text in javatree to max loaniq selec string
    ...    @update: fmamaril    08MAR2019    Update Mx Activate to Mx Activate Window
    ...    @update: hstone      22MAY2020    - Added Take Screenshots
    ...    @update: clanding    10AUG2020    - Replaced hard coded values to global variables
    mx LoanIQ activate window    ${LIQ_Drawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select String    ${LIQ_Drawdown_WorkflowItems}    ${SEND_TO_APPROVAL_STATUS}
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    ${SEND_TO_APPROVAL_STATUS}
                 
    :FOR    ${i}    IN RANGE    6
    \    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==${False} 
     
     Run Keyword And Continue On Failure    Verify Window    ${LIQ_InitialDrawdown_AwaitingApproval_Status_Window}
     Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_Workflow
       
Approve Loan Drawdown via WIP LIQ Icon
    [Documentation]    This keyword allows an LIQ Approver User to approve the Initial Loan Drawdown thru WIP. 
    ...    @author: rtarayao
    ...    @update: hstone     19MAY2020    - Added keyword Pre-processing
    [Arguments]    ${sApproverUsername}    ${sApproverPassword}    ${sWIP_TransactionType}    ${sWIP_AwaitingApprovalStatus}    ${sWIP_OutstandingType}    ${sLoan_Alias}
    
    ### Keyword Pre-processing ###
    ${ApproverUsername}    Acquire Argument Value    ${sApproverUsername}
    ${ApproverPassword}    Acquire Argument Value    ${sApproverPassword}
    ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
    ${WIP_AwaitingApprovalStatus}    Acquire Argument Value    ${sWIP_AwaitingApprovalStatus}
    ${WIP_OutstandingType}    Acquire Argument Value    ${sWIP_OutstandingType}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    Logout from Loan IQ
    Login to Loan IQ    ${ApproverUsername}    ${ApproverPassword}
    Open Loan Initial Drawdown Notebook via WIP - Awaiting Approval    ${WIP_TransactionType}    ${WIP_AwaitingApprovalStatus}    ${WIP_OutstandingType}    ${Loan_Alias}
    Approve Loan Drawdown
    
Open Loan Initial Drawdown Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    ...    @update: mnanquil - removed read loan alias from excel
    ...    @update: hstone     20MAY2020     - Replaced '%s" with '%d' on 'Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}'
    ...    @update: hstone     22MAY2020     - Removed Sleep
    ...                                      - Added 'Wait Until Keyword Succeeds' for 'Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d'
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingApprovalStatus}    ${WIP_OutstandingType}    ${Loan_Alias}     
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus} 

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
   
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN} 
    Wait Until Keyword Succeeds    3x    5 sec    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/WorkInProgress_${WIP_TransactionType}
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    
    mx LoanIQ activate    ${LIQ_Drawdown_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Drawdown_General
    
Approve Loan Drawdown
    [Documentation]    This keyword approves the Loan Initial Drawdown.
    ...    @author: rtarayao
    ...    @update: mnanquilada
    ...    Change Mx LoanIQ Verify Text In Javatree to Mx LoanIQ Select String
    ...    @update: jdelacru    08MAR2019    - Added question message box handler 
    
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    Mx LoanIQ Select String     ${LIQ_Drawdown_WorkflowItems}    Approval 
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    Approval  
   
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
    :FOR    ${i}    IN RANGE    5
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Send Loan Drawdown Rates to Approval
    [Documentation]    This keyword is used to Send the Loan Drawdown Rates set for Approval.
    ...    @author: rtarayao
    ...    @update: mnanquilada
    ...    Change Mx LoanIQ Verify Text In Javatree to Mx LoanIQ Select String
    ...    added handling of warning message. 
    ...    @update: jdelacru    08MAR2019    - Added question message box handler
    ...    @update: hstone      22MAY2020    - Added Take Screenshot
    
    mx LoanIQ activate    ${LIQ_Drawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    Mx LoanIQ Select String    ${LIQ_Drawdown_WorkflowItems}    Send to Rate Approval   
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    Send to Rate Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
    :FOR    ${i}    IN RANGE    5
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False 
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_InitialDrawdown_AwaitingRateApproval_Status_Window}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_Workflow

Open Loan Initial Drawdown Notebook via WIP - Awaiting Rate Approval
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Rate Approval Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    ...    @update: mnanquil - removed reading of loan alias from spreadsheet.
    ...    @update: hstone     05MAY2020     - Replaced '%s" with '%d' on 'Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}'
    ...    @update: hstone      22MAY2020    - Removed Sleep
    ...                                      - Added 'Wait Until Keyword Succeeds' for 'Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d'
    ...                                      - Added Take Screenshots
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingRateApprovalStatus}    ${WIP_OutstandingType}    ${Loan_Alias}

    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRateApprovalStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRateApprovalStatus} 

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
   
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN} 
    Wait Until Keyword Succeeds    3x    5 sec    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/WorkInProgress
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    
    mx LoanIQ activate    ${LIQ_Drawdown_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Drawdown_General
          
Approve Loan Drawdown Rates
    [Documentation]    This keyword approves the Loan Initial Drawdown Rates set.
    ...    @author: rtarayao 
    ...    @update: mnanquilada
    ...    Change Mx LoanIQ Verify Text In Javatree to Mx LoanIQ Select String
    ...    Added handling of warning message
    ...    @update: jdelacru    08MAR2019    - Added question message box handler 
    
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    Mx LoanIQ Select String   ${LIQ_Drawdown_WorkflowItems}    Rate Approval 
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    Rate Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    3
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False 
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_InitialDrawdown_AwaitingRelease_Status_Window}

Generate Drawdown Rate Setting Notices
    [Documentation]    This keyword is used to send Rate Setting Notice to the Borrower and Lender. 
    ...    @author: rtarayao
    ...    @update: mnanquil
    ...    Added mx click element if present after double clicking generate notices
    [Arguments]    ${LIQCustomer_ShortName}    ${Contact_Email}
    
    mx LoanIQ activate    ${LIQ_Drawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    Mx LoanIQ Select String    ${LIQ_Drawdown_WorkflowItems}    Generate Rate Setting Notices   
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    Generate Rate Setting Notices
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
   :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False 
    
    mx LoanIQ activate window    ${LIQ_Notice_RateSettingNotice_Window}
    ${NoticeStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Notice_RateSettingNotice_Information_Table}    ${LIQCustomer_ShortName}%Status%test    
    Log    ${NoticeStatus}
    
    mx LoanIQ click    ${LIQ_Notice_RateSettingNotice_EditHighlightedNotice_Button}
    mx LoanIQ activate window    ${LIQ_Notice_RateSettingNotice_Edit_Window}   

    ${ContactEmail}    Mx LoanIQ Get Data    ${LIQ_Notice_RateSettingNotice_EditHighlightedNotice_Button}    value%test
    Log    ${ContactEmail}
    Should Be Equal    ${Contact_Email}    ${ContactEmail}          
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=Rate .* Notice created.*").JavaEdit("text:=${LIQCustomer_ShortName}")    Verified_Customer    
    Log    ${Verified_Customer}
    Should Be Equal As Strings    ${LIQCustomer_ShortName}    ${Verified_Customer}
    Log    ${Verified_Customer}    
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=Rate .* Notice created.*").JavaStaticText("attached text:=${NoticeStatus}")    Verified_Status    
    Should Be Equal As Strings    ${NoticeStatus}    ${Verified_Status}
     
    mx LoanIQ close window    ${LIQ_Notice_RateSettingNotice_Edit_Window}                   
    ####To be executed once the functionality for sending notices is fixed.####
    # Mx Click    ${LIQ_Notice_Send_Button}
    
    # :FOR    ${i}    IN RANGE    2
    # \    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    # \    ${Information_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Information_Window}     VerificationData="Yes"
    # \    Exit For Loop If    ${Information_Status}==False  
    
    # Mx Activate Window    ${LIQ_Notice_Window}
    # ${NewNoticeStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Notice_Information_Table}    ${LIQCustomer_ShortName}%Status%test
    # Log    ${NewNoticeStatus}
    
    # Should Not Be Equal As Strings    ${NoticeStatus}    ${NewNoticeStatus}         
         
    mx LoanIQ click    ${LIQ_Notice_RateSettingNotice_Exit_Button}
    
Open Loan Initial Drawdown Notebook via WIP - Awaiting Release Cashflow
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Release Cashflow Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    ...    @update: rtarayao
    ...    deleted the read data keyword that will be handled in the the high level keywords.
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingReleaseCashflowsStatus}    ${WIP_OutstandingType}    ${Loan_Alias}
    
     
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflowsStatus}         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflowsStatus}  

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
   
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Sleep    5s 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%s
    Sleep    3s  
  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate window    ${LIQ_Drawdown_Window}
                 
Release Loan Initial Drawdown
    [Documentation]    This keyword is used to Release the Loan Initial Drawdown.
    ...    @author: rtarayao     
    ...    @update: hstone    22MAY2020     - Added Take Screenshot
    ...    @update: clanding    10AUG2020    - Replaced hard coded values to global variables
    
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_InitialDrawdown_AwaitingRelease_Status_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    ${RELEASE_STATUS}
    
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==${False}
             
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
    :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==${False} 
        
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
     
     :FOR    ${i}    IN RANGE    2
    \    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    \    ${Information_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Information_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Information_Status}==${False}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Drawdown_Workflow
    
Get Facility Global Available to Draw Amount
    [Documentation]    This keyword gets the current available to draw amount in a Facility.
    ...    @author: rtarayao  
    ...    @update: amansuet    27APR2020    - added optional argument for keyword post processing
    [Arguments]    ${sRuntime_Variable}=None

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}  
    ${AvailToDrawAmount}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%test
    Log    ${AvailToDrawAmount}
    
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${AvailToDrawAmount}

    [Return]    ${AvailToDrawAmount}

Get Facility Global Outstandings
    [Documentation]    This keyword gets the current global outstanding amount in a Facility.
    ...    @author: rtarayao  
    ...    @update: amansuet    22APR2020    - added optional argument for keyword post processing
    [Arguments]    ${sRuntime_Variable}=None

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}  
    ${GlobalOutstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    value%test
    Log    ${GlobalOutstandings}

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${GlobalOutstandings}

    [Return]    ${GlobalOutstandings}

Get New Facility Global Outstandings
    [Documentation]    This keyword gets the new global outstanding amount in a Facility.
    ...    @author: rtarayao 
    ...    @update: rtarayao    19MAR2019    Updated keyword used for number conversion
    ...    @update: hstone      29APR2020    - Added Optional Arguments: ${sRunTimeVar_NewGlobalOutstandings}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    ...    @update: hstone      22MAY2020    - Added Take Screenshot
    [Arguments]    ${sRunTimeVar_NewGlobalOutstandings}=None
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}  
    ${sNewGlobalOutstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    value%test
    ${sNewGlobalOutstandings}    Remove Comma and Convert to Number    ${sNewGlobalOutstandings}    
    Log    ${sNewGlobalOutstandings}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_General

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_NewGlobalOutstandings}    ${sNewGlobalOutstandings}

    [Return]    ${sNewGlobalOutstandings}

Get New Facility Available to Draw Amount
    [Documentation]    This keyword validates the new available to draw amount in a Facility.
    ...    @author: rtarayao  
    ...    @update: rtarayao    19MAR2019    Updated keyword used for number conversion
    ...    @update: hstone      29APR2020    - Added Optional Arguments: ${sRunTimeVar_NewAvailToDrawAmount}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    ...    @update: hstone      22MAY2020    - Added Take Screenshot
    [Arguments]    ${sRunTimeVar_NewAvailToDrawAmount}=None
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}  
    ${NewAvailToDrawAmount}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%test
    ${NewAvailToDrawAmount}    Remove Comma and Convert to Number    ${NewAvailToDrawAmount}  
    Log    ${NewAvailToDrawAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_General

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_NewAvailToDrawAmount}    ${NewAvailToDrawAmount}

    [Return]    ${NewAvailToDrawAmount}
    
Compute New Global Outstandings of the Facility
    [Documentation]    This keyword computes the new global outstandings amount in a Facility after Drawdown.
    ...    @author: rtarayao/ghabal
    ...    removed the read data and moved it to high level. removed the rowid argument as well 
    ...    @update: rtarayao    19MAR2019    Updated keyword used for number conversion.
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Added Optional Arguments: ${sRunTimeVar_ComputedGlobalOutstandings}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    [Arguments]    ${sFacility_CurrentGlobalOutstandings}    ${sLoan_RequestedAmount}    ${sRunTimeVar_ComputedGlobalOutstandings}=None

    ### Keyword Pre-processing ###
    ${Facility_CurrentGlobalOutstandings}    Acquire Argument Value    ${sFacility_CurrentGlobalOutstandings}
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}

    ${Facility_CurrentGlobalOutstandings}    Remove Comma and Convert to Number    ${Facility_CurrentGlobalOutstandings}
    ${Loan_RequestedAmount}    Remove Comma and Convert to Number    ${Loan_RequestedAmount}
    ${Computed_GlobalOutstandings}    Evaluate    ${Facility_CurrentGlobalOutstandings}+${Loan_RequestedAmount}
    ${Computed_GlobalOutstandings}    Evaluate    "%.2f" % ${Computed_GlobalOutstandings}
    Log    ${Computed_GlobalOutstandings}    

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ComputedGlobalOutstandings}    ${Computed_GlobalOutstandings}

    [Return]    ${Computed_GlobalOutstandings}
    
Compute New Global Outstandings
    [Documentation]    This keyword computes the new global outstandings amount in a Facility after Drawdown.
    ...    @author: rtarayao/ghabal 
    ...    <update>@mgaling: Created a variable for Read Data from Excel Sheet Name
    ...    @update: rtarayao - removed the read data and moved it to high level. removed the rowid and sheetname argument as well
    ...    @update: mnanquil - added remove string , for loan requested amount.
    ...    @update: clanding    10AUG2020    - added saving of runtime value; add pre processing keywords
    [Arguments]    ${sFacility_CurrentGlobalOutstandings}    ${sLoan_RequestedAmount}    ${sRunTimeVar_ComputedGlobalOutstandings}=None
    
    ### Keyword Pre-processing ###
    ${Facility_CurrentGlobalOutstandings}    Acquire Argument Value    ${sFacility_CurrentGlobalOutstandings}
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}

    Log    ${Facility_CurrentGlobalOutstandings}   
    ${Facility_CurrentGlobalOutstandings}    Remove String    ${Facility_CurrentGlobalOutstandings}    ,
    ${Loan_RequestedAmount}   Remove String    ${Loan_RequestedAmount}    ,
    ${Facility_CurrentGlobalOutstandings}    Convert To Number    ${Facility_CurrentGlobalOutstandings}       
    
    Log    ${Facility_CurrentGlobalOutstandings}
    Log    ${Loan_RequestedAmount}
    
    ${Computed_GlobalOutstandings}    Evaluate    ${Facility_CurrentGlobalOutstandings}+${Loan_RequestedAmount}
    
    Log    ${Computed_GlobalOutstandings}    
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ComputedGlobalOutstandings}    ${Computed_GlobalOutstandings}
    
    [Return]    ${Computed_GlobalOutstandings}

Compute New Facility Available to Draw Amount
    [Documentation]    This keyword computes the new available to draw amount in a Facility after Drawdown.
    ...    @author: rtarayao
    ...    @update: clanding    10AUG2020    - added saving of runtime value; added pre processing
    [Arguments]    ${sFacility_CurrentAvailToDraw}    ${sLoan_RequestedAmount}    ${sRunTimeVar_Computed_AvailToDrawAmt}=None
    
    ### Keyword Pre-processing ###
    ${Facility_CurrentAvailToDraw}    Acquire Argument Value    ${sFacility_CurrentAvailToDraw}
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}    

    ${Facility_CurrentAvailToDraw}    Remove String    ${Facility_CurrentAvailToDraw}    ,
    ${Loan_RequestedAmount}   Remove String    ${Loan_RequestedAmount}    ,
    ${Facility_CurrentAvailToDraw}    Convert To Number    ${Facility_CurrentAvailToDraw}       

    ${Computed_AvailToDrawAmt}    Evaluate    ${Facility_CurrentAvailToDraw}-${Loan_RequestedAmount}
    
    Log    ${Computed_AvailToDrawAmt}    
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Computed_AvailToDrawAmt}    ${Computed_AvailToDrawAmt}
    
    [Return]    ${Computed_AvailToDrawAmt}


Get Current Commitment Amount
    [Documentation]    This keyword gets  Current Commitment Amount of the Facility.
    ...    @author: rtarayao
    ...    @update: rtarayao    19MAR2019    Updated keyword used for number conversion. 
    ...    @update: hstone      29APR2020    - Added Optional Arguments: ${sRunTimeVar_CurrentCmtAmt}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    ...    @update: hstone      22MAY2020    - Added Take Screenshot
    ...    @update: clanding    11AUG2020    - Removed s in CurrentCmtAmt
    [Arguments]    ${sRunTimeVar_CurrentCmtAmt}=None
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}  
    ${CurrentCmtAmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%test
    ${CurrentCmtAmt}    Remove Comma and Convert to Number    ${CurrentCmtAmt}  
    Log    ${CurrentCmtAmt}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_General

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_CurrentCmtAmt}    ${CurrentCmtAmt}

    [Return]    ${CurrentCmtAmt}
    

Validate Global Facility Amounts - Balanced
    [Documentation]    This keyword validates that the Sum of Outstandings and Avail to Draw Amount less the Current Commitment Amount is equal to zero(0).
    ...    @author: rtarayao 
    ...    @update: rtarayao    19MAR2019    Updated keyword used for number conversion. 
    [Arguments]    ${sNewAvailToDrawAmount}    ${sNewGlobalOutstandings}    ${sCurrentCmtAmt}

    ### Keyword Pre-processing ###
    ${NewAvailToDrawAmount}    Acquire Argument Value    ${sNewAvailToDrawAmount}
    ${NewGlobalOutstandings}    Acquire Argument Value    ${sNewGlobalOutstandings}
    ${CurrentCmtAmt}    Acquire Argument Value    ${sCurrentCmtAmt}

    ${sComputed_CurrentCmtAmt}    Evaluate    ${NewAvailToDrawAmount}+${NewGlobalOutstandings}
    ${sComputed_CurrentCmtAmt}    Evaluate    "%.2f" % ${sComputed_CurrentCmtAmt}
    Log    ${sComputed_CurrentCmtAmt}
    Should Be Equal    ${sComputed_CurrentCmtAmt}    ${CurrentCmtAmt}
  
    ${sSumTotal}    Evaluate    ${NewAvailToDrawAmount}+${NewGlobalOutstandings}
    ${sSumTotal}    Evaluate    "%.2f" % ${sSumTotal}     
    Log    ${sSumTotal}
    ${sDiffAmount}    Evaluate    ${sSumTotal}-${CurrentCmtAmt}    
    ${sDiffAmount}    Evaluate    "%.2f" % ${sDiffAmount}       
    Should Be Equal    ${sDiffAmount}    0.00

Validate Global Facility Amounts - Balanced for Term Loan Drawdown for SYNDICATED deal in USD     
    [Documentation]    This keyword validates that the Sum of Outstandings and Avail to Draw Amount less the Current Commitment Amount is equal to zero(0).
    ...    @author: rtarayao/ghabal 

    ${NewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${NewGlobalOutstandings}    Get New Facility Global Outstandings
    ${CurrentCmtAmt}    Get Current Commitment Amount
    
    ${Computed_CurrentCmtAmt}    Evaluate    ${NewAvailToDrawAmount}+${NewGlobalOutstandings}
    Log    ${Computed_CurrentCmtAmt}
    
    Should Be Equal    ${Computed_CurrentCmtAmt}    ${CurrentCmtAmt}
  
    ${SumTotal}    Evaluate    ${NewAvailToDrawAmount}+${NewGlobalOutstandings}
    Log    ${SumTotal}
    ${DiffAmount}    Evaluate    ${SumTotal}-${CurrentCmtAmt}    
    ${DiffAmount}    Convert to String    ${DiffAmount}        
    
    Run Keyword And Continue On Failure    Should Be Equal    ${DiffAmount}    0.0
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${DiffAmount}    0.0    
    Run Keyword If   '${result}'=='True'    Log    Amounts are correct! Facility reflected the correct amount! 
    ...     ELSE    Log    Amounts are not correct! Please recheck your facility and loan!      


    
Navigate to Initial Drawdown Notebook from Loan Notebook
    [Documentation]    This keyword navigates the User to the Initial Drawdown Notebook from the Loan Notebook.
    ...    @author: rtarayao 
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events   
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Loan_Events_List}    Released%d     
    mx LoanIQ activate window    ${LIQ_Drawdown_Window}


########Ge and Ritz Code#########

Release Loan Initial Drawdown after Interest Capitalization
    [Documentation]    This keyword is used to Release the Loan Initial Drawdown.
    ...    @author: rtarayao/ghabal
    ...    commmented "Mx LoanIQ Verify Object Exist ${LIQ_Information_Window}" and replace it with "Mx Click Element If Present    ${LIQ_Information_OK_Button}" 
    ...    @jdelacru    08MAR2019    - Added question message box handler
    mx LoanIQ activate    ${LIQ_Drawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow    
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Drawdown_WorkflowItems}    Release%yes 
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
    :FOR    ${i}    IN RANGE    2
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False 
    
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    # Mx LoanIQ Verify Object Exist    ${LIQ_Information_Window}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}   
    
    mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}

Navigate to Outstanding Select Window from Deal
     [Documentation]    This keyword enables the LIQ User to navigate to the Outstanding Select window thru the Deal Notebook.
    ...    @author: ritragel
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards
    
    Mx LoanIQ Select    ${LIQ_DealNotebook_Queries_OutstandingSelect}
    Mx LoanIQ Activate    ${LIQ_OutstandingSelect_Window}

Create Loan Outstanding
    [Documentation]    This keyword is used for the creation of Outsanding Select Loan for Syndicated Deal
    ...    @author: ritragel
    ...    @update: ritragel    28FEB19    Renamed keyword, added return value for LoanAlias and removed writing
    ...    @update: rtarayao    01OCT2019    - Added selection of Borrower to cater multiple borrower within a facility
    [Arguments]    ${Outstanding_Type}    ${Loan_FacilityName}    ${Loan_Borrower}    ${Loan_PricingOption}    ${Loan_Currency}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Submenu}
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    Verify Window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Outstanding_Type}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_New_RadioButton}    ON 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Type_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Facility_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Currency_Dropwdown}     VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Alias_JavaEdit}       VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Borrower_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Deal_JavaButton}            VerificationData="Yes"
    mx LoanIQ select    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Loan_FacilityName}
    mx LoanIQ select    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    ${Loan_PricingOption}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Borrower_Dropdown}    ${Loan_Borrower}  
    ${Alias}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Alias_JavaEdit}    alias_from_LoanIQ
    mx LoanIQ click    ${LIQ_OutstandingSelect_OK_Button} 
    mx LoanIQ click element if present    ${LIQ_OutstandingSelect_Warning_Yes_Button}        
    mx LoanIQ click element if present   ${LIQ_OutstandingSelect_InformationalMessage_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    [Return]    ${Alias}
 
Input General Loan Drawdown Details with Accrual End Date
    [Documentation]    This keyword is used to input Loan Drawdown details in the General tab including Accrual End Date
    ...    @author: ritragel
    ...    @update: rtarayao    01OCT2019    - Added optional argument and action for Loan Risk Type selection
    ...                                      - This is needed when Multiple Risk types are selected in the Deal level
    ...                                      - Added optional argument for Fixed and Loan Risk Type
    ...    @update: ritragel    13SETP20    Added additional arguments for UAT Deals and Added Preprocessing
    ...    @update: shirhong    01DEC2020    Added additional handling for warning messages
    [Arguments]    ${sLoan_RequestedAmount}    ${sLoan_MaturityDate}    ${sLoan_RepricingFrequency}    ${sLoan_EffectiveDate}
    ...    ${sLoan_RepricingDate}=None    ${sLoan_RiskType}=None    ${sFixedandLoanRiskType}=None
    ...    ${sLoan_PaymentMode}=None    ${sLoan_Accrue}=None    ${sLoan_AccrueEndDate}=None

    ### Keyword Pre-processing ###
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}
    ${Loan_MaturityDate}    Acquire Argument Value    ${sLoan_MaturityDate}
    ${Loan_RepricingFrequency}    Acquire Argument Value    ${sLoan_RepricingFrequency}
    ${Loan_EffectiveDate}    Acquire Argument Value    ${sLoan_EffectiveDate}
    ${Loan_RepricingDate}    Acquire Argument Value    ${sLoan_RepricingDate}
    ${Loan_RiskType}    Acquire Argument Value    ${sLoan_RiskType}
    ${FixedandLoanRiskType}    Acquire Argument Value    ${sFixedandLoanRiskType}
    ${Loan_PaymentMode}    Acquire Argument Value    ${sLoan_PaymentMode}
    ${Loan_Accrue}    Acquire Argument Value    ${sLoan_Accrue}
    ${Loan_AccrueEndDate}    Acquire Argument Value    ${sLoan_AccrueEndDate}

    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    General
    Mx LoanIQ Enter    ${LIQ_InitialDrawdown_RequestedAmt_Textfield}    ${Loan_RequestedAmount}
    Mx LoanIQ Enter    ${LIQ_InitialDrawdown_EffectiveDate_Datefield}    ${Loan_EffectiveDate}
    Mx LoanIQ Enter    ${LIQ_InitialDrawdown_MaturityDate_Datefield}    ${Loan_MaturityDate}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Repricing_Dropdownlist}    ${Loan_RepricingFrequency}
    Run Keyword If    '${Loan_RepricingDate}'!='None'    mx LoanIQ enter    ${LIQ_InitialDrawdown_RepricingDate_Datefield}    ${Loan_RepricingDate}
    Run Keyword If    '${Loan_RiskType}'!='None'    Run Keyword If    '${FixedandLoanRiskType}'!='None'    Run Keywords    mx LoanIQ click    ${LIQ_InitialDrawdown_RiskType_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_InitialDrawdown_SelectRiskType_Window}
    ...    AND    Mx LoanIQ DoubleClick By InputOccurence    ${LIQ_InitialDrawdown_SelectRiskType_JavaTree}    Loan:2
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${Loan_Accrue}'!='None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Accrue_Dropdown}    ${Loan_Accrue}
    Run Keyword If    '${Loan_PaymentMode}'!='None'    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_PaymentMode_Dropdown}    ${Loan_PaymentMode}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    ${AdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_AdjustedDueDate_Datefield}    value%test
    Run Keyword If    '${Loan_AccrueEndDate}'=='None'    mx LoanIQ enter    ${LIQ_InitialDrawdown_AccrualEndDate_Datefield}    ${AdjustedDueDate}
    Run Keyword If    '${Loan_AccrueEndDate}'!='None'    mx LoanIQ enter    ${LIQ_InitialDrawdown_AccrualEndDate_Datefield}    ${sLoan_AccrueEndDate}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_General
    Select Menu Item    ${LIQ_InitialDrawdown_Window}    File    Save
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Create Repayment Schedule - Fixed Payment
    [Documentation]    This keyword is used to input Loan Drawdown details in the General tab including Accrual End Date
    ...    @author: ritragel
    ...    <update> @ghabal - added 3 "Mx Click Element If Present ${LIQ_Warning_Yes_Button}" during integration of Scenario
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_RepaymentSchedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}   
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_CurrentSchedule_POBM_Text}        VerificationData="Yes"
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Reschedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate Loan Repayment Schedule Types
    mx LoanIQ enter    ${LIQ_RepaymentSchedule_ScheduleType_FPPI_RadioButton}    ON
    mx LoanIQ click    ${LIQ_RepaymentSchedule_ScheduleType_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Get Data from Automatic Schedule Setup
    [Documentation]    This keyword will get all the data generated in Automatic Schedule Setup for Fixed Payment (Principal and Interest)
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_AutomaticScheduleSetup_Window}    
    ${Amount}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_Amount_TextField}    value  
    #${EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_EffectiveDate_TextField}    value%value
    #${MaturityDate}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_MaturityDate_TextField}    value%value
    #${InterestCycleFrequency}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_InterestCycleFrequency_TextField}    value%value
    ${AllInRate}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_AllInRate_TextField}    value
    #${RateBasis}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_RateBasis_TextField}    value%value
    #${InterestTriggerDate}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_InterestTriggerDate_TextField}    value%value
    #${NumberOfPayments}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_NumberOfPayments_TextField}    value%value
    #${AmortizationPeriods}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_AmortizationPeriods_TextField}    value%value    
    #${AmortizationEndDate}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_AmortizationEndDate_TextField}    value%value        
    ${RepricingFrequency}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_FirstScheduleDate_Dropdown}    value    
    mx LoanIQ click    ${LIQ_AutomaticScheduleSetup_OK_Button}   

Verify Select Fixed Payment Amount
    [Documentation]    This keyword verify if the calculated fixed mount is correct
    ...    @author: ritragel
    ...    @update: ritragel    28FEB2019    Removed Writing for InterestPayments, added return value
    mx LoanIQ activate window    ${LIQ_SelectFixedPaymentAmount_Window}
    ${CalculatedFixedPayment}    Mx LoanIQ Get Data    ${LIQ_SelectFixedPaymentAmount_CalculatedFixedPayment_JavaEdit}    value
    ${CalculatedFixedPayment}    Remove Comma and Convert to Number    ${CalculatedFixedPayment}   
    Validate if Element is Checked    ${LIQ_SelectFixedPaymentAmount_AcceptCalculatedFixedPayment_Checkbox}    Accept Calculated Fixed Payment
    mx LoanIQ click    ${LIQ_SelectFixedPaymentAmount_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Exit_Button}
    [Return]    ${CalculatedFixedPayment} 

Send Initial Drawdown to Approval
    [Documentation]    This keyword is used to send approval and approve the loan drawdown
    ...    @author: ritragel
    ...    <updated> @ghabal - added another "Mx Click Element If Present ${LIQ_Warning_Yes_Button}" for Scenario 2 integratin testing
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Send to Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  

Approve Initial Drawdown
    [Documentation]    This keyword will approve the Loan awaiting for approval
    ...    @author: ritragel
    ...    @update: ritragel    06MAR19    Added Additional Verification for Question Message
    ...    @update: aramos      05OCT20    Added Additional Verification for Appriving GBP Libor Option 
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}   
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Send Initial Drawdown to Rate Approval
    [Documentation]    This keyword will sent the loan to Rate Approval
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Send to Rate Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Approve Initial Drawdown Rate 
    [Documentation]    This keyword will approve the Rates of the initial drawdown
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Rate Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}

Release Loan Drawdown
    [Documentation]    This keyword will release the Loan Drawdown
    ...    @author: ritragel
    ...    @update: ritragel    06MAR19    Added handling of closing Cashflows window
    ...    @update: cfrancis    08OCT2020    - Added another Warning Yes for Generate Rate Setting Notices
    mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}   
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Release 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    
# Complete Cashflow for Initial Drawdown - Scenario 2
    # [Documentation]    This keyword will release the Cashflow for Initial Drawdown
    # ...    @author: ritragel
    # [Arguments]    ${Borrower_ShortName}    ${Lender1_ShortName}    ${Lender2_ShortName}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status}
    # Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    # Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Complete Cashflows 
    # Verify if Method has Remittance Instruction - Loan Drawdown    ${Borrower_ShortName}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status}
    # Verify if Method has Remittance Instruction - Loan Drawdown   ${Lender1_ShortName}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status}
    # Verify if Method has Remittance Instruction - Loan Drawdown  ${Lender2_ShortName}    ${Remittance_Description}    ${Remittance_Instruction}    ${Remittance_Status}
    # Verify if Status is Set to Release it - Loan Drawdown    ${Borrower_ShortName}    
    # Verify if Status is Set to Release it - Loan Drawdown    ${Lender1_ShortName}
    # Verify if Status is Set to Release it - Loan Drawdown    ${Lender2_ShortName}
    # Mx Click    ${LIQ_Drawdown_Cashflows_OK_Button}   
    # Mx Close Window    ${LIQ_InitialDrawdown_Window}

Approve Loan Drawdown via WIP
    [Documentation]    This keyword allows an LIQ Approver User to approve the Initial Loan Drawdown thru WIP. 
    ...    @author: rtarayao/ghabal
    ...    adjusted script to accomodate setup Interest Capitalization test case 
    [Arguments]    ${ApproverUsername}    ${ApproverPassword}    ${WIP_TransactionType}    ${WIP_AwaitingApprovalStatus}    ${WIP_OutstandingType}    ${Loan_Alias}
        
    Logout from Loan IQ
    Login to Loan IQ    ${ApproverUsername}    ${ApproverPassword}
    Open Loan Initial Drawdown Notebook via WIP    ${WIP_TransactionType}    ${WIP_AwaitingApprovalStatus}    ${WIP_OutstandingType}    ${Loan_Alias}
    Approve Loan Drawdown

Open Loan Initial Drawdown Notebook via WIP
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    ...    @author: rtarayao/ghabal
    ...    adjusted script to accomodate setup Interest Capitalization test case
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingApprovalStatus}    ${WIP_OutstandingType}    ${Loan_Alias}      

    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus} 

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
   
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN}
    
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}
    Mx Native Type    {ENTER}
    # Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%s
        
    Sleep    3s  
  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    
    mx LoanIQ activate    ${LIQ_Drawdown_Window} 

Awaiting Rate Approval for Initial Loan Drawdown Notebook 
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Rate Approval Status thru the LIQ WIP Icon.
    ...    @author: rtarayao/ghabal
    ...    adjusted script to accomodate setup Interest Capitalization test case
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingRateApprovalStatus}    ${WIP_OutstandingType}    ${Loan_Alias}
    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRateApprovalStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRateApprovalStatus} 

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
   
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%s
    Sleep    3s  
  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    
    mx LoanIQ activate    ${LIQ_Drawdown_Window}   
    
    Approve Loan Drawdown Rates
    
Validate Outstandings
     [Documentation]    This keyword validates the outstandings amounts
     ...    @author: ghabal
     ...    @update: rtarayao    19MAR2019    Deleted rowid as argument.
     ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
     [Arguments]    ${sNewGlobalOutstandings}    ${sComputed_GlobalOutstandings}

     ### Keyword Pre-processing ###
    ${NewGlobalOutstandings}    Acquire Argument Value    ${sNewGlobalOutstandings}
    ${Computed_GlobalOutstandings}    Acquire Argument Value    ${sComputed_GlobalOutstandings}

     Run Keyword And Continue On Failure    Should Be Equal    ${NewGlobalOutstandings}    ${Computed_GlobalOutstandings}
     ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${NewGlobalOutstandings}    ${Computed_GlobalOutstandings}    
     Run Keyword If   '${result}'=='True'    Log    Outstandings are correct! Facility reflected the correct amount! 
     ...     ELSE    Log    Outstandings are not correct! Please recheck your facility and loan!
      
Validate Draw Amounts
     [Documentation]    This keyword validates the Draw Amounts
     ...    @author: ghabal
     ...    @update: rtarayao    19MAR2019    Deleted rowid as argument.
     ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
     [Arguments]    ${sComputed_AvailToDrawAmt}    ${sNewAvailToDrawAmount}

     ### Keyword Pre-processing ###
    ${Computed_AvailToDrawAmt}    Acquire Argument Value    ${sComputed_AvailToDrawAmt}
    ${NewAvailToDrawAmount}    Acquire Argument Value    ${sNewAvailToDrawAmount}

     Run Keyword And Continue On Failure    Should Be Equal    ${Computed_AvailToDrawAmt}    ${NewAvailToDrawAmount}
     ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${Computed_AvailToDrawAmt}    ${NewAvailToDrawAmount}    
     Run Keyword If   '${result}'=='True'    Log    Draw Amounts are correct! Facility reflected the correct amount! 
     ...     ELSE    Log    Draw Amounts are not correct! Please recheck your facility and loan!
      
Validate New Facility Available to Draw Amount
    [Documentation]    This keyword validates the new available to draw amount in a Facility.
    ...    @author: rtarayao
    ...    @update: hstone     18JUN2020     - Updated ${NewAvailToDrawAmount} Data Conversion
    ...                                      - Added Argument '${sExpectedAmount}'
    ...                                      - Added Keyword Pre-processing
    ...                                      - Added 'Should Be Equal As Numbers    ${ExpectedAmount}    ${NewAvailToDrawAmount}'
    ...                                      - Replaced '${LIQ_FacilitySummary_HostBank_AvailToDraw_Amount}' with '${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}'
    ...                                      - Added Take Screenshot
    [Arguments]    ${sExpectedAmount}

    ### Keyword Pre-processing ###
    ${ExpectedAmount}    Acquire Argument Value    ${sExpectedAmount}

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook_Summary
    ${NewAvailToDrawAmount}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%test
    ${NewAvailToDrawAmount}    Remove Comma and Evaluate to Number    ${NewAvailToDrawAmount}
    ${ExpectedAmount}    Remove Comma and Evaluate to Number    ${ExpectedAmount}
    Should Be Equal As Numbers    ${ExpectedAmount}    ${NewAvailToDrawAmount}
    
Compute New Facility Available to Draw Amount after Drawdown
    [Documentation]    This keyword computes the new available to draw amount in a Facility after Drawdown.
    ...    @author: rtarayao/ghabal 
    ...    @update: rtarayao removed read data from excel, it must be declared together with high level keywords.
    ...    @update: jdelacru    27MAR2019    - Used of number conversion from generic keywords
    ...    @update: rtarayao    16APR2019    - Used of number conversion from generic keywords for computed avail to draw amount.
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Added Optional Arguments: ${sRunTimeVar_ComputedAvailToDrawAmt}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    [Arguments]    ${sFacility_CurrentAvailToDraw}    ${sLoan_RequestedAmount}    ${sRunTimeVar_ComputedAvailToDrawAmt}=None
   
    ### Keyword Pre-processing ###
    ${Facility_CurrentAvailToDraw}    Acquire Argument Value    ${sFacility_CurrentAvailToDraw}
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}
    
    ${Facility_CurrentAvailToDraw}    Remove Comma and Convert to Number    ${Facility_CurrentAvailToDraw}  
    ${Loan_RequestedAmount}    Remove Comma and Convert to Number    ${Loan_RequestedAmount}     

    ${Computed_AvailToDrawAmt}    Evaluate    ${Facility_CurrentAvailToDraw}-${Loan_RequestedAmount}
    ${Computed_AvailToDrawAmt}    Remove Comma and Convert to Number    ${Computed_AvailToDrawAmt}
    
    Log    ${Computed_AvailToDrawAmt}    

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ComputedAvailToDrawAmt}    ${Computed_AvailToDrawAmt}
    
    [Return]    ${Computed_AvailToDrawAmt}

Input Loan Drawdown Rates for Term Facility (USD)
    [Documentation]    This keyword is used to input Loan Drawdown Rates for Term Facility (USD)
    ...    @author: ghabal
    ...    @update: dahijara    24AUG2020    - Added pre processing keywords and screenshot.
    [Arguments]    ${sBorrower_BaseRate} 
    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_BaseRate}    Acquire Argument Value    ${sBorrower_BaseRate}

    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Rates
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_BaseRate
    mx LoanIQ click    ${LIQ_InitialDrawdown_BaseRate_Button}
    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_BaseRate
    mx LoanIQ enter    ${LIQ_InitialDrawdown_BorrowerBaseRate_Textfield}    ${Borrower_BaseRate} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_BaseRate
    mx LoanIQ click    ${LIQ_InitialDrawdown_SetBaseRate_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_BaseRate
 
Generate Rate Setting Notices for Initial Loan Drawdown Notebook
    [Documentation]    This keyword is used to generate Rate Setting Notices 
    ...    @author: ghabal
    ...    @update: jdelacru    12MAR2019    - Added activate window for notices
    [Arguments]    ${Lender_LegalName}    ${RateSettingNotice_Status}  
    mx LoanIQ activate    ${LIQ_Drawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Drawdown_WorkflowItems}    Generate Rate Setting Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    Generate Rate Setting Notices
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Wait Until Keyword Succeeds    10    5    mx LoanIQ activate window    ${LIQ_Notices_Window}       
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Notice_Information_Table}    ${Lender_LegalName}%s 
    mx LoanIQ click    ${LIQ_RateSettingNoticeGroup_EditHighlightedNotice_Button}
    mx LoanIQ activate window    ${LIQ_RateSetting_Notice_Email_Window}
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=Rate Setting Notice created.*","displayed:=1").JavaEdit("text:=${Lender_LegalName}")    Verified_Customer    
    Should Be Equal As Strings    ${Lender_LegalName}    ${Verified_Customer}
    Log    ${Verified_Customer}    
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=Rate Setting Notice created.*","displayed:=1").JavaObject("tagname:=Group","text:=Status").JavaStaticText("text:=${RateSettingNotice_Status}")    Verified_Status    
    Should Be Equal As Strings    ${RateSettingNotice_Status}    ${Verified_Status}
    Log    ${Verified_Status} - Status is correct!
        
    mx LoanIQ select    ${LIQ_RateSetting_Notice_FileMenu_PreviewMenu}
    Sleep    3s        
    Take Screenshot
    Sleep    3s
    mx LoanIQ select    ${LIQ_SBLC_NoticePreview_FileMenu_ExitMenu}
        
    mx LoanIQ close window    ${LIQ_RateSetting_Notice_Email_Window}
    mx LoanIQ click    ${LIQ_RateSettingNoticeGroup_Exit_Button}

Enter Initial Loan Drawdown Details
    [Documentation]    This keyword is used to enter Initial Loan Drawdown Details
    ...    @author: ghabal
    ...    @update: jdelacru    07MAR2019    - Return loan alias on high level and removed writing of loan alias
    ...    @update: jdelacru    08MAR2019    - Added informational message box handler
    ...    @update: dahijara    30JUL2020    - Added pre & post processing keywords and screenshot. Removed commented codes for writing.
    [Arguments]    ${sOutstanding_Type}    ${sLoan_FacilityName}    ${sLoan_Borrower}    ${sLoan_PricingOption}    ${sLoan_Currency}    ${sRowid}    ${sFacility_Currency}    ${sRunVar_Loan_Alias}=None
    ### GetRuntime Keyword Pre-processing ###
    ${Outstanding_Type}    Acquire Argument Value    ${sOutstanding_Type}
    ${Loan_FacilityName}    Acquire Argument Value    ${sLoan_FacilityName}
    ${Loan_Borrower}    Acquire Argument Value    ${sLoan_Borrower}
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
    ${Loan_Currency}    Acquire Argument Value    ${sLoan_Currency}
    ${Rowid}    Acquire Argument Value    ${sRowid}
    ${Facility_Currency}    Acquire Argument Value    ${sFacility_Currency}

    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}    
    mx LoanIQ enter    ${LIQ_OutstandingSelect_New_RadioButton}    ON    
    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Outstanding_Type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Loan_FacilityName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Borrower_Dropdown}    ${Loan_Borrower}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    ${Loan_PricingOption}
    Validate Loan IQ Details    ${Facility_Currency}    ${LIQ_OutstandingSelect_Currency_Dropdown}
    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Currency_Dropdown}    ${Loan_Currency}  
    
    ${loan_alias}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Alias_JavaEdit}    Loan Alias    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect
    mx LoanIQ click    ${LIQ_OutstandingSelect_OK_Button}
    
    mx LoanIQ click element if present   ${LIQ_Information_OK_Button}

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Loan_Alias}    ${loan_alias}
    [Return]    ${loan_alias}
 
    
Enter Loan Drawdown Details for USD Libor Option
    [Documentation]    This keyword is used to enter Loan Drawdown Details for USD Libor Option
    ...    @author: ghabal
    ...    @update: jdelacru    05MAR2019    - Added message question box handler after entering the maturity date
    ...    @update: dahijara    24AUG2020    - Added pre processing keywords and screenshot. Added tab action after entering dates.
    ...                                      - Added argument and steps for Risk type selection
    [Arguments]    ${sLoan_RequestedAmount}    ${sLoan_EffectiveDate}    ${sLoan_MaturityDate}    ${sLoan_RepricingFrequency}    ${sLoan_IntCycleFrequency}    ${sLoan_Accrue}    ${sRiskType}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}
    ${Loan_EffectiveDate}    Acquire Argument Value    ${sLoan_EffectiveDate}
    ${Loan_MaturityDate}    Acquire Argument Value    ${sLoan_MaturityDate}
    ${Loan_RepricingFrequency}    Acquire Argument Value    ${sLoan_RepricingFrequency}
    ${Loan_IntCycleFrequency}    Acquire Argument Value    ${sLoan_IntCycleFrequency}
    ${Loan_Accrue}    Acquire Argument Value    ${sLoan_Accrue}
    ${RiskType}    Acquire Argument Value    ${sRiskType}

    Mx LoanIQ Activate Window    ${LIQ_InitialDrawdown_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    General

    mx LoanIQ click    ${LIQ_InitialDrawdown_RiskType_Button}
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_SelectRiskType_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_InitialDrawdown_SelectRiskType_JavaTree}    ${RiskType}%s
    mx LoanIQ click    ${LIQ_InitialDrawdown_SelectRiskType_OK_Button}       

    mx LoanIQ enter    ${LIQ_InitialDrawdown_RequestedAmt_Textfield}    ${Loan_RequestedAmount} 
    mx LoanIQ enter    ${LIQ_InitialDrawdown_EffectiveDate_Datefield}    ${Loan_EffectiveDate}
    Mx Press Combination    KEY.TAB
    mx LoanIQ enter    ${LIQ_InitialDrawdown_MaturityDate_Datefield}    ${Loan_MaturityDate}   
    Mx Press Combination    KEY.TAB
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Repricing_Dropdownlist}    ${Loan_RepricingFrequency}

    ${IntCycleFrequency}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_IntCycleFreq_Dropdownlist}    value%Monthly    
    Run Keyword If    '${IntCycleFrequency}'=='${Loan_IntCycleFrequency}'    Log    Int. Cycle Frequence is Monthly
    
    ${Displayed_ActualDueDate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_ActualDueDate_Datefield}    testdata    
    ${Displayed_AdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_AdjustedDueDate_Datefield}    testdata
    Run Keyword If    '${Displayed_ActualDueDate}'=='${Displayed_AdjustedDueDate}'    Log    Accrual End Date is confirmed equal to the Actual Due Date
    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Accrue_Dropdownlist}    ${Loan_Accrue} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown
    
 
Enter Loan Drawdown Details
    [Documentation]    This keyword is used to enter Loan Drawdown Details Prior to Interest Capitalization
    ...    @author: ghabal
    ...    @update: jdelacru    12MAR2019    - Added selection of Accrue Ruling
    ...    @update: dahijara    30JUL2020    - Added pre processing keywords and screenshot. Added tab action after entering dates.
    ...                                      - Added argument and steps for Risk type selection
    [Arguments]    ${sLoan_RequestedAmount}    ${sLoan_EffectiveDate}    ${sLoan_MaturityDate}    ${sLoan_RepricingFrequency}    ${sLoan_IntCycleFrequency}    ${sLoan_Accrue}    ${sRiskType}

    ### GetRuntime Keyword Pre-processing ###
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}
    ${Loan_EffectiveDate}    Acquire Argument Value    ${sLoan_EffectiveDate}
    ${Loan_MaturityDate}    Acquire Argument Value    ${sLoan_MaturityDate}
    ${Loan_RepricingFrequency}    Acquire Argument Value    ${sLoan_RepricingFrequency}
    ${Loan_IntCycleFrequency}    Acquire Argument Value    ${sLoan_IntCycleFrequency}
    ${Loan_Accrue}    Acquire Argument Value    ${sLoan_Accrue}
    ${RiskType}    Acquire Argument Value    ${sRiskType}

    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    General
    
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window} 

    mx LoanIQ click    ${LIQ_InitialDrawdown_RiskType_Button}
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_SelectRiskType_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_InitialDrawdown_SelectRiskType_JavaTree}    ${RiskType}%s
    mx LoanIQ click    ${LIQ_InitialDrawdown_SelectRiskType_OK_Button}       

    mx LoanIQ enter    ${LIQ_InitialDrawdown_RequestedAmt_Textfield}    ${Loan_RequestedAmount} 
    mx LoanIQ enter    ${LIQ_InitialDrawdown_EffectiveDate_Datefield}    ${Loan_EffectiveDate}
    Mx Press Combination    KEY.TAB
    mx LoanIQ enter    ${LIQ_InitialDrawdown_MaturityDate_Datefield}    ${Loan_MaturityDate}
    Mx Press Combination    KEY.TAB
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Repricing_Dropdownlist}    ${Loan_RepricingFrequency}
    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Accrue_Dropdownlist}    ${Loan_Accrue}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    ${IntCycleFrequency}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_IntCycleFreq_Dropdownlist}    value%Monthly
    Run Keyword If    '${IntCycleFrequency}'=='${Loan_IntCycleFrequency}'    Log    Int. Cycle Frequence is Monthly
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown
    
Enter Loan Drawdown Rates
    [Documentation]    This keyword is used to enter Loan Drawdown Rates Prior to Interest Capitalization
    ...    @author: ghabal
    ...    @update: dahijara    30JUL2020    - Added pre processing keywords and screenshot.
    [Arguments]    ${sBorrower_BaseRate}    ${sFacility_Spread} 
    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_BaseRate}    Acquire Argument Value    ${sBorrower_BaseRate}
    ${Facility_Spread}    Acquire Argument Value    ${sFacility_Spread}

    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Rates
    mx LoanIQ click    ${LIQ_InitialDrawdown_BaseRate_Button}
      
    :FOR    ${i}    IN RANGE    5
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    '${status}' == 'True'    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Exit For Loop If    '${status}' == 'False'
        
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_InitialDrawdown_BorrowerBaseRate_Textfield}        VerificationData="Yes"
    Run Keyword If    '${status}' == 'True'    mx LoanIQ enter    ${LIQ_InitialDrawdown_BorrowerBaseRate_Textfield}    ${Borrower_BaseRate}
    Run Keyword If    '${status}' == 'False'    mx LoanIQ enter    ${LIQ_InitialDrawdown_BaseRate_Textfield}    ${Borrower_BaseRate}     
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_BaseRate
    mx LoanIQ click    ${LIQ_InitialDrawdown_SetBaseRate_OK_Button}    
    
Create Repayment Schedule - Fixed Principal Plus Interest Due
    [Documentation]    This keyword is used to create Repayment Schedule - Fixed Principal Plus Interest Due
    ...    @author: ghabal
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_RepaymentSchedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Reschedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate Loan Repayment Schedule Types
    mx LoanIQ enter    ${LIQ_RepaymentSchedule_ScheduleType_FPPIDue_RadioButton}    ON
    mx LoanIQ click    ${LIQ_RepaymentSchedule_ScheduleType_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
            
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Reschedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
                
Verify Fixed Principal Payment Amount
    [Documentation]    This keyword is used to verify if the Fixed Principal Payment Amount is correct
    ...    @author: ghabal
    ...    @update: dahijara    24AUG2020    - Added post processing and screenshot. Removed writing in the keyword and added return value.
    [Arguments]    ${sRunVar_DisplayFixedPrincipalPaymentAmount}=None
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_AutomaticScheduleSetup
    mx LoanIQ click    ${LIQ_AutomaticScheduleSetup_Accept_Button}
    mx LoanIQ activate window    ${LIQ_AutomaticScheduleSetup_Window}
    
    ${CalculatedFixedPrincipalPayment}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_CalculatedFixedPrincipalAmount}    value    
    ${DisplayFixedPrincipalPaymentAmount}    Mx LoanIQ Get Data    ${LIQ_AutomaticScheduleSetup_FixedPrincipalPaymentAmount}    value
    Run Keyword If    '${CalculatedFixedPrincipalPayment}'=='${DisplayFixedPrincipalPaymentAmount}'    Log    Displayed 'Fixed Principal Payment Amount' is the same value with the 'Calculated Fixed Principal Payment' amount
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_AutomaticScheduleSetup
    mx LoanIQ click    ${LIQ_AutomaticScheduleSetup_Principal_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_AutomaticScheduleSetup

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_DisplayFixedPrincipalPaymentAmount}    ${DisplayFixedPrincipalPaymentAmount}
    [Return]    ${DisplayFixedPrincipalPaymentAmount}
          
Validate Total Amount of the Repayment Schedule vs Current Host Bank Amount
    [Documentation]    This keyword is used to validate Total Amount of the Repayment Schedule vs Current Host Bank Amount
    ...    @author: ghabal
    ...    @update: dahijara    24AUG2020    - Added post processing and screenshot. Removed writing in the keyword and added return value. Updated Locator for Current Schedule List.
    [Arguments]    ${sRunVar_DisplayCurrentHostBankAmount}=None
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_CurrentSchedule_FixedPrincipalPlusInterestDue_Text}        VerificationData="Yes"
     
    ${DisplayCurrentHostBankAmount}    Mx LoanIQ Get Data    ${LIQ_RepaymentSchedule_CurrentSchedule_CurrentHostBank_TextField}    value
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_RepaymentSchedule
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_RepaymentSchedule_CurrentSchedule_List}    ${DisplayCurrentHostBankAmount}%s    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_RepaymentSchedule_CurrentSchedule_List}    ${DisplayCurrentHostBankAmount}%s 

    Run Keyword If    '${status}'=='True'    Log    The total amount of the repayment schedule (in Host Bank Principal column) is EQUAL to the loan amount of the current Host Bank
    ...     ELSE    Log    The total amount of the repayment schedule (in Host Bank Principal column) is NOT equal to the loan amount of the current Host Bank    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_RepaymentSchedule
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Exit_Button} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_RepaymentSchedule
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_DisplayCurrentHostBankAmount}    ${DisplayCurrentHostBankAmount}
    [Return]    ${DisplayCurrentHostBankAmount}

Validate Details of the Cashflow/GL Entries Amount     
    [Documentation]    This keyword is used to validate cashflow/GL entries amounts based on the assigned percentage
    ...    @author: ghabal  
    [Arguments]    ${LenderAmount}    ${Lender_Percentage}    ${rowid}    ${BasisAmount}  
    
    # # ##...Get the the Borrower Transaction Amount
    Log    ${BasisAmount}
    
    # # ##...Get the Displayed Amount    
    Log    ${LenderAmount}
    
    # # ##...Get the Percentage
    ${Lender_Percentage}    Evaluate    ${Lender_Percentage}/100
    ${Lender_Percentage}    Convert To Number    ${Lender_Percentage}    2
    Log    ${Lender_Percentage}
          
    # # ##...Compute Percentage if it matches what's been assigned based on amounts
    ${CashflowLender_ComputedAmountPercentage}    Evaluate    ${LenderAmount}/${BasisAmount}
    ${CashflowLender_ComputedAmountPercentage}    Convert To Number    ${CashflowLender_ComputedAmountPercentage}    2
    Log    ${CashflowLender_ComputedAmountPercentage}   
        
    ${status}    Run Keyword And Return Status    Should Be Equal    ${Lender_Percentage}    ${CashflowLender_ComputedAmountPercentage}
    Run Keyword If    ${status}==True    Run Keyword    Log    Displayed Amount matches the computed amount based on percentage
    ...    ELSE    Fail    Displayed Amount does not matched the computed amount based on percentage
    [Return]    ${LenderAmount}                   
    
Validate Cashflow Amount for Incomplete Cash From Borrower Amount
    [Documentation]    This keyword is used to validate cashflow amounts based on the assigned percentage
    ...    @author: ghabal  
    [Arguments]    ${IncompleteCashfromBorrower_Percentage}    ${rowid}    ${Computed_LoanIntProjectedCycleDue}  
    
    # # ##...Get the the Borrower Transaction Amount
    Log    ${Computed_LoanIntProjectedCycleDue}
    
    # # ##...Get the Displayed Amount
    ${IncompleteCashfromBorrower_UIAmount}    Mx LoanIQ Get Data    ${LIQ_Payment_Cashflow_IncompleteCashfromBorrower_Amount}    data
    ${IncompleteCashfromBorrower_UIAmount}    Strip String    ${IncompleteCashfromBorrower_UIAmount}    mode=Right    characters=USD 
    ${status}    Run Keyword And Return Status    Should Contain    ${IncompleteCashfromBorrower_UIAmount}    ,           
    ${IncompleteCashfromBorrower_UIAmount}    Run Keyword If    '${status}'=='True'    Remove String    ${IncompleteCashfromBorrower_UIAmount}    ,   
    Write Data To Excel    CAP03_InterestPayment    IncompleteCashfromBorrower_Amount    ${rowid}   ${IncompleteCashfromBorrower_UIAmount}    
    Log    ${IncompleteCashfromBorrower_UIAmount}
    
    # # ##...Get the Percentage
    ${IncompleteCashfromBorrower_Percentage}    Evaluate    ${IncompleteCashfromBorrower_Percentage}/100
    ${IncompleteCashfromBorrower_Percentage}    Convert To Number    ${IncompleteCashfromBorrower_Percentage}    2
    Log    ${IncompleteCashfromBorrower_Percentage}
          
    # # ##...Compute Percentage if it matches what's been assigned based on amounts
    ${IncompleteCashfromBorrower_ComputedAmountPercentage}    Evaluate    ${IncompleteCashfromBorrower_UIAmount}/${Computed_LoanIntProjectedCycleDue}
    ${IncompleteCashfromBorrower_ComputedAmountPercentage}    Convert To Number    ${IncompleteCashfromBorrower_ComputedAmountPercentage}    2
    Log    ${IncompleteCashfromBorrower_ComputedAmountPercentage}   
        
    ${status}    Run Keyword And Return Status    Should Be Equal    ${IncompleteCashfromBorrower_Percentage}    ${IncompleteCashfromBorrower_ComputedAmountPercentage}
    Run Keyword If    ${status}==True    Run Keyword    Log    Displayed Amount matches the computed amount based on percentage
    ...    ELSE    Fail    Displayed Amount does not matched the computed amount based on percentage
    [Return]    ${IncompleteCashfromBorrower_UIAmount}                   

Validate Cashflow Amount for Incomplete Cash to Lenders Amount
    [Documentation]    This keyword is used to validate cashflow amounts based on the assigned percentage
    ...    @author: ghabal  
    [Arguments]    ${IncompleteCashtoLender_Percentage}    ${rowid}    ${BorrowerTranAmount}  
    
    # # ##...Get the the Borrower Transaction Amount
    Log    ${BorrowerTranAmount}
    
    # # ##...Get the Displayed Amount
    ${IncompleteCashtoLender_UIAmount}    Mx LoanIQ Get Data    ${LIQ_Payment_Cashflow_IncompleteCashtoLender_Amount}    data
    ${IncompleteCashtoLender_UIAmount}    Strip String    ${IncompleteCashtoLender_UIAmount}    mode=Right    characters=USD
    ${status}    Run Keyword And Return Status    Should Contain    ${IncompleteCashtoLender_UIAmount}    ,           
    Run Keyword If    '${status}'=='True'    Remove String    ${IncompleteCashtoLender_UIAmount}    ,    
    Run Keyword If    '${status}'=='False'    Log    ${IncompleteCashtoLender_UIAmount}    
    Write Data To Excel    CAP03_InterestPayment    IncompleteCashtoLender_Amount    ${rowid}   ${IncompleteCashtoLender_UIAmount}    
            
    # # ##...Get the Percentage
    ${IncompleteCashtoLender_Percentage}    Evaluate    ${IncompleteCashtoLender_Percentage}/100
    ${IncompleteCashtoLender_Percentage}    Convert To Number    ${IncompleteCashtoLender_Percentage}    2
    Log    ${IncompleteCashtoLender_Percentage}
   
    # # ##...Compute Percentage if it matches what's been assigned based on amounts
    ${IncompleteCashtoLender_ComputedAmountPercentage}    Evaluate    ${IncompleteCashtoLender_UIAmount}/${BorrowerTranAmount}
    ${IncompleteCashtoLender_ComputedAmountPercentage}    Convert To Number    ${IncompleteCashtoLender_ComputedAmountPercentage}    2
    Log    ${IncompleteCashtoLender_ComputedAmountPercentage}   
   
    ${status}    Run Keyword And Return Status    Should Be Equal    ${IncompleteCashtoLender_Percentage}    ${IncompleteCashtoLender_ComputedAmountPercentage}
    Run Keyword If    ${status}==True    Run Keyword    Log    Displayed Amount matches the computed amount based on percentage        
    ...    ELSE    Fail    Displayed Amount does not matched the computed amount based on percentage
    [Return]    ${IncompleteCashtoLender_UIAmount} 
       
Validate Cashflow Amount for Host Bank Cash Net Amount
    [Documentation]    This keyword is used to validate cashflow amounts based on the assigned percentage
    ...    @author: ghabal  
    [Arguments]    ${HostBankCashNet_Percentage}    ${rowid}    ${BorrowerTranAmount}  
    
    # # ##...Get the the Borrower Transaction Amount
    Log    ${BorrowerTranAmount}
    
    # # ##...Get the Displayed Amount
    ${HostBankCashNet_UIAmount}    Mx LoanIQ Get Data    ${LIQ_Payment_Cashflow_HostBankCashNet_Amount}    data
    ${HostBankCashNet_UIAmount}    Strip String    ${HostBankCashNet_UIAmount}    mode=Right    characters=USD
    ${status}    Run Keyword And Return Status    Should Contain    ${HostBankCashNet_UIAmount}    ,           
    Run Keyword If    '${status}'=='True'    Remove String    ${HostBankCashNet_UIAmount}    ,    
    Run Keyword If    '${status}'=='False'    Log    ${HostBankCashNet_UIAmount}    
    Write Data To Excel    CAP03_InterestPayment    HostBankCashNet_Amount    ${rowid}   ${HostBankCashNet_UIAmount}    
            
    # # ##...Get the Percentage
    ${HostBankCashNet_Percentage}    Evaluate    ${HostBankCashNet_Percentage}/100
    ${HostBankCashNet_Percentage}    Convert To Number    ${HostBankCashNet_Percentage}    2
    Log    ${HostBankCashNet_Percentage}
   
    # # ##...Compute Percentage if it matches what's been assigned based on amounts
    ${HostBankCashNet_ComputedAmountPercentage}    Evaluate    ${HostBankCashNet_UIAmount}/${BorrowerTranAmount}
    ${HostBankCashNet_ComputedAmountPercentage}    Convert To Number    ${HostBankCashNet_ComputedAmountPercentage}    2
    Log    ${HostBankCashNet_ComputedAmountPercentage}   
   
    ${status}    Run Keyword And Return Status    Should Be Equal    ${HostBankCashNet_Percentage}    ${HostBankCashNet_ComputedAmountPercentage}
    Run Keyword If    ${status}==True    Run Keyword    Log    Displayed Amount matches the computed amount based on percentage        
    ...    ELSE    Fail    Displayed Amount does not matched the computed amount based on percentage
    [Return]    ${HostBankCashNet_UIAmount} 
    
Compute Borrower Share Transaction Amt
    [Documentation]    This keyword is used to compute for the Borrower Share Transaction Amt.
    ...    @author: rtarayao/ghabal  
    [Arguments]    ${LenderSharePct}    ${SheetName}    ${rowid}    ${TotalLender_PercentShare}  
    
    # # ##...Get Requested Amount of Loan
    ${Loan_CalculatedFixedPayment}    Read Data From Excel    ${SheetName}    Loan_RequestedAmount    ${rowid}
    Log    ${Loan_CalculatedFixedPayment}
    
    # # ##...Get Requested Amount of Loan
    ${HostBankCashNet_Amount}    Read Data From Excel    ${SheetName}    HostBank_Amount    ${rowid}
    Log    ${HostBankCashNet_Amount}
    
    # # ##...Compute Incomplete Cash Amount From Lenders
    ${TotalAmountforLenders}    Evaluate    ${Loan_CalculatedFixedPayment}-${HostBankCashNet_Amount}
    Log    ${TotalAmountforLenders}
    
    # # ##...Compute Incomplete Cash Amount From Lenders
    ${TotalAmountforHostBank}    Evaluate    ${TotalAmountforLenders}+${HostBankCashNet_Amount}
    Log    ${TotalAmountforHostBank}
    
    ${status}    Run Keyword And Return Status    Should Contain    ${TotalAmountforHostBank}    ,           
    Run Keyword If    '${status}'=='True'    Remove String    ${TotalAmountforHostBank}    ,
    ${LenderSharePct}    Evaluate    (${LenderSharePct}+${TotalLender_PercentShare})/100
    Log    ${LenderSharePct}
    ${LenderShareTranAmt}    Evaluate    ${TotalAmountforHostBank}*${LenderSharePct}
    Log    ${LenderShareTranAmt}   
    ${LenderShareTranAmt}    Convert To Number    ${LenderShareTranAmt}    2
    Log    ${LenderShareTranAmt}
    [Return]    ${LenderShareTranAmt}      

Get Total Percent Share of Lenders
    [Documentation]    This keyword is used get the total percentage share of Lenders 
    ...    @author: ghabal
    [Arguments]    ${LenderSharePc2}    ${LenderSharePc3}    
    ${Total_PercentShare}    Evaluate    ${LenderSharePc2}+${LenderSharePc3}            
    Log    ${Total_PercentShare} 
    [Return]    ${Total_PercentShare}

Verify SBLC in WIP
    [Documentation]    This keyword will verify the SBLC in Work in Process
    ...    @author: ritragel/ghabal    
    [Arguments]    ${Deal_Name}
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    Sleep    1
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate window    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ Double Click In Javalist    ${LIQ_TransactionsInProcess_Transations_JavaTree}    Outstandings
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    SBLC/Guarantee Issuance
    Mx LoanIQ Select Or Doubleclick In Tree By Text   ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    ${Deal_Name}%d
    Log    SBLC Issuance is present in Work in Process  
    mx LoanIQ close window    ${LIQ_TransactionsInProcess_Window} 
    
Approve Initial Loan Drawdown via WIP
    [Documentation]    This keyword is used to do the 'Approval' process for the initial Loan drawdown
    ...    @author: ghabal
    ...    @update: dahijara    25AUG2020    Added pre processing keyword and screenshot
    [Arguments]    ${sAlias}

    ### GetRuntime Keyword Pre-processing ###
    ${Alias}    Acquire Argument Value    ${sAlias}

    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ Double Click In Javalist    ${LIQ_TransactionsInProcess_Transations_JavaTree}    Outstandings
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Awaiting Approval
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Loan Initial Drawdown
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialLoanDrawdown_WIP
    Mx LoanIQ Select Or Doubleclick In Tree By Text   ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    ${Alias}%d
    mx LoanIQ close window    ${LIQ_TransactionsInProcess_Window}
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialLoanDrawdown_Wrokflow
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialLoanDrawdown_Wrokflow
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Verify If Warning Is Displayed   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialLoanDrawdown_Wrokflow
    
Send to Rate Approval Initial Loan Drawdown via WIP
    [Documentation]    This keyword is used to do the 'Send to Rate Approval' process for the initial Loan drawdown
    ...    @author: ghabal
    ...    @update: dahijara    25AUG2020    Added pre processing keyword and screenshot
    [Arguments]    ${sAlias}
    ### GetRuntime Keyword Pre-processing ###
    ${Alias}    Acquire Argument Value    ${sAlias}

    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ Double Click In Javalist    ${LIQ_TransactionsInProcess_Transations_JavaTree}    Outstandings
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Awaiting Send to Rate Approval
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Loan Initial Drawdown
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_WIP
    Mx LoanIQ Select Or Doubleclick In Tree By Text   ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    ${Alias}%d
    mx LoanIQ close window    ${LIQ_TransactionsInProcess_Window}
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Send to Rate Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    
Rate Approval Initial Loan Drawdown via WIP
    [Documentation]    This keyword is used to do the 'Rate Approval' process for the initial Loan drawdown
    ...    @author: ghabal
    ...    @update: dahijara    25AUG2020    Added pre processing keyword and screenshot
    [Arguments]    ${sAlias}
    ### GetRuntime Keyword Pre-processing ###
    ${Alias}    Acquire Argument Value    ${sAlias}

    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ Double Click In Javalist    ${LIQ_TransactionsInProcess_Transations_JavaTree}    Outstandings
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Awaiting Rate Approval
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Loan Initial Drawdown
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_WIP
    Mx LoanIQ Select Or Doubleclick In Tree By Text   ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    ${Alias}%d
    mx LoanIQ close window    ${LIQ_TransactionsInProcess_Window}
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Rate Approval  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
 
Generate Rate Setting Notices via WIP
    [Documentation]    This keyword is used to generate Rate Setting Notices 
    ...    @author: ghabal
    ...    @update: dahijara    25AUG2020    Added pre processing keyword and screenshot
    [Arguments]    ${sLender_LegalName}    ${sRateSettingNotice_Status}    ${sAlias}  
    ### GetRuntime Keyword Pre-processing ###
    ${Lender_LegalName}    Acquire Argument Value    ${sLender_LegalName}
    ${RateSettingNotice_Status}    Acquire Argument Value    ${sRateSettingNotice_Status}
    ${Alias}    Acquire Argument Value    ${sAlias}

    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_TransactionsInProcess_Window}
    Mx LoanIQ Double Click In Javalist    ${LIQ_TransactionsInProcess_Transations_JavaTree}    Outstandings
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Loan Initial Drawdown
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_WIP
    Mx LoanIQ Select Or Doubleclick In Tree By Text   ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    ${Alias}%d
    mx LoanIQ close window    ${LIQ_TransactionsInProcess_Window}
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Generate Rate Setting Notices
    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Verify If Warning Is Displayed    
               
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    Verify If Warning Is Displayed  
    
    Mx LoanIQ Select String    ${LIQ_RateSettingNoticeGroup_Table}    ${Lender_LegalName}
    mx LoanIQ click    ${LIQ_RateSettingNoticeGroup_EditHighlightedNotice_Button}
    mx LoanIQ activate window    ${LIQ_RateSetting_Notice_Email_Window}
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=Rate Setting Notice created.*","displayed:=1").JavaEdit("text:=${Lender_LegalName}")    Verified_Customer    
    Should Be Equal As Strings    ${Lender_LegalName}    ${Verified_Customer}
    Log    ${Verified_Customer}    
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=Rate Setting Notice created.*","displayed:=1").JavaObject("tagname:=Group","text:=Status").JavaStaticText("text:=${RateSettingNotice_Status}")    Verified_Status    
    Should Be Equal As Strings    ${RateSettingNotice_Status}    ${Verified_Status}
    Log    ${Verified_Status} - Status is correct!
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RateSettingNoticeGroup
    mx LoanIQ select    ${LIQ_RateSetting_Notice_FileMenu_PreviewMenu}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RateSettingNotice
    mx LoanIQ select    ${LIQ_SBLC_NoticePreview_FileMenu_ExitMenu}
        
    mx LoanIQ close window    ${LIQ_RateSetting_Notice_Email_Window}
    mx LoanIQ click    ${LIQ_RateSettingNoticeGroup_Exit_Button}
 
Release Initial Loan Drawdown
    [Documentation]    This keyword is used to do the 'Rate Approval' process for the initial Loan drawdown
    ...    @author: ghabal
    ...    @update: jdelacru    26MAR2019    - Deleted work in process navigation
    ...    @update: dahijara    25AUG2020    Added pre processing keyword and screenshot
    [Arguments]    ${sAlias}
    ### GetRuntime Keyword Pre-processing ###
    ${Alias}    Acquire Argument Value    ${sAlias}
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Verify If Warning Is Displayed
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow

Populate Outstanding Select Window
    [Documentation]    This keyword is used for populating Outstanding Select window for the Loan details.
    ...    This keyword also returns the Loan Alias of the outstanding.
    ...    @author: mgaling
    ...    @update: rtarayao    19MAR2019    Deleted Write Data keyword.
    ...    @update: hstone    28APR2020    - Added Keyword Pre-process: Acquire Argument Value
    ...                                    - Added Keyword Post-process: Save Runtime Value
    ...                                    - Added Optional Argument: ${sRunTimeVar_LoanAlias}
    ...    @updated: dahijara    03JUL2020    - added keyword to take screenshot
    [Arguments]    ${sOutstanding_Type}    ${sLoan_FacilityName}    ${sLoan_Borrower}    ${sLoan_PricingOption}    ${sLoan_Currency}    ${sRunTimeVar_LoanAlias}=None

    ### Keyword Pre-processing ###
    ${Outstanding_Type}    Acquire Argument Value    ${sOutstanding_Type}
    ${Loan_FacilityName}    Acquire Argument Value    ${sLoan_FacilityName}
    ${Loan_Borrower}    Acquire Argument Value    ${sLoan_Borrower}
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
    ${Loan_Currency}    Acquire Argument Value    ${sLoan_Currency}

    Mx LoanIQ Set    ${LIQ_OutstandingSelect_New_RadioButton}    ON    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Outstanding_Type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Loan_FacilityName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Borrower_Dropdown}    ${Loan_Borrower}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    ${Loan_PricingOption}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Currency_Dropdown}    ${Loan_Currency} 
    ${sLoanAlias}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Alias_JavaEdit}    Loan Alias
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect
    mx LoanIQ click    ${LIQ_OutstandingSelect_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_LoanAlias}    ${sLoanAlias}

    [Return]    ${sLoanAlias}   

Populate General Tab in Initial Drawdown
    [Documentation]    This keyword is used for populating Loan Drawdown details in the General tab.
    ...    @author:mgaling
    ...    @update: rtarayao    11MAR2019    Deleted Write and Read of data, deleted rowid as argument.
    ...    @update: hstone    28APR2020    - Added Keyword Pre-process: Acquire Argument Value
    ...    @update: dahijara    03JUL2020    - added keyword to take screenshot
    [Arguments]    ${sLoan_RiskType}    ${sLoan_RequestedAmount}    ${sLoan_EffectiveDate}    ${sLoan_MaturityDate}    ${sLoan_RepricingFrequency}

    ### Keyword Pre-processing ###
    ${Loan_RiskType}    Acquire Argument Value    ${sLoan_RiskType}
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}
    ${Loan_EffectiveDate}    Acquire Argument Value    ${sLoan_EffectiveDate}
    ${Loan_MaturityDate}    Acquire Argument Value    ${sLoan_MaturityDate}
    ${Loan_RepricingFrequency}    Acquire Argument Value    ${sLoan_RepricingFrequency}

    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    General
    mx LoanIQ click    ${LIQ_InitialDrawdown_RiskType_Button}
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_SelectRiskType_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_InitialDrawdown_SelectRiskType_JavaTree}    ${Loan_RiskType}%s
    mx LoanIQ click    ${LIQ_InitialDrawdown_SelectRiskType_OK_Button}                
    mx LoanIQ enter    ${LIQ_InitialDrawdown_RequestedAmt_Textfield}    ${Loan_RequestedAmount} 
    mx LoanIQ enter    ${LIQ_InitialDrawdown_EffectiveDate_Datefield}    ${Loan_EffectiveDate}
    
    mx LoanIQ enter    ${LIQ_InitialDrawdown_MaturityDate_Datefield}    ${Loan_MaturityDate}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_IntCycleFreq_Dropdownlist}    ${Loan_RepricingFrequency}
    Mx LoanIQ Set    ${LIQ_InitialDrawdown_RepaymentScheduleSync_Checkbox}    OFF
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_GeneralTab
  
Create Flex Repayment Schedule
    [Documentation]    This keyword is used for navigating Flex Repayment Schedule.
    ...    @author: mgaling
    ...    @update: hstone      02JUN2020     - Added Checking if Loan Notebook is on update mode
    ...                                       - Updated Options>Repaymant Schedule Locator
    mx LoanIQ activate window    ${LIQ_Loan_Window}

    ${InquiryMode_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${InquiryMode_Status}==True    mx LoanIQ click    ${LIQ_Loan_InquiryMode_Button}
    ...    ELSE    Run Keyword    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_UpdateMode_Button}    VerificationData="Yes"

    mx LoanIQ select    ${LIQ_Loan_Options_RepaymentSchedule}
    :FOR    ${i}    IN RANGE    4
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False 
    
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_ChooseScheduleType_Window}
    Mx LoanIQ Set    ${LIQ_RepaymentSchedule_ScheduleType_FlexSchedule_RadioButton}    ON
    mx LoanIQ click    ${LIQ_RepaymentSchedule_ScheduleType_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}

Create Flex Repayment Schedule for Initial Drawdown
    [Documentation]    This keyword is used for navigating Flex Repayment Schedule.
    ...    @author:mgaling
    ...    @update: dahijara    03JUL2020    - added keyword for taking screenshot
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_RepaymentSchedule}
    :FOR    ${i}    IN RANGE    4
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False 
    
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_ChooseScheduleType_Window}
    Mx LoanIQ Set    ${LIQ_RepaymentSchedule_ScheduleType_FlexSchedule_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule
    mx LoanIQ click    ${LIQ_RepaymentSchedule_ScheduleType_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}    
        
Add Fixed PI Items in Flexible Schedule
    [Documentation]    This keyword is for adding items in Flexible Schedule window.
    ...    This keyword also returns the Fixed PI Date.
    ...    @author: mgaling
    ...    @update: rtarayao    11MAR2019    Deleted Read Data keyword, deleted rowid argument, and added documentation.
    ...    @update: hstone      28APR2020    - Added Keyword Pre-proecssing: Acquire Argument Value
    ...                                      - Added Optional Argument: ${sRunTimeVar_FixedPIDate}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    ...    @update: dahijara    03JUL2020    - Added screenshot keyword
    [Arguments]    ${sItem_NoOFPayments}    ${sItem_Frequency}    ${sItem_type}    ${sItem_PIAmount}    ${sNonBusinessDayRule}    ${sRunTimeVar_FixedPIDate}=None
    
    ### Keyword Pre-processing ###
    ${Item_NoOFPayments}    Acquire Argument Value    ${sItem_NoOFPayments}
    ${Item_Frequency}    Acquire Argument Value    ${sItem_Frequency}
    ${Item_type}    Acquire Argument Value    ${sItem_type}
    ${Item_PIAmount}    Acquire Argument Value    ${sItem_PIAmount}
    ${NonBusinessDayRule}    Acquire Argument Value    ${sNonBusinessDayRule}

    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}
    mx LoanIQ click    ${LIQ_FlexibleSchedule_AddItems_Button}
    mx LoanIQ activate window    ${LIQ_FSched_AddItems_Window}
    
   ###Check the Pay Thru Maturiy CheckBox###
    
   ${ONstatus}    Run Keyword And Return Status    Mx LoanIQ Set    ${LIQ_FSched_AddItems_PayThruMaturity_CheckBox}    ON
   Run Keyword If    ${ONstatus}==True    Mx LoanIQ Verify Object Exist    ${LIQ_FSched_AddItems_AmortizeThru_Field}    VerificationData="Yes"
   ...    ELSE    Fail    Log    AmortizeThru Field does not exist
   
   ${OFFstatus}    Run Keyword And Return Status    Mx LoanIQ Set    ${LIQ_FSched_AddItems_PayThruMaturity_CheckBox}    OFF
   Run Keyword If    ${ONstatus}==True    Mx LoanIQ Verify Object Exist    ${LIQ_FSched_AddItems_NoOFPayments_Field}    VerificationData="Yes"
   ...    ELSE    Fail    Log    Number of Days Field does not exist
   
   ###Populate the required fields###
   
   mx LoanIQ enter    ${LIQ_FSched_AddItems_NoOFPayments_Field}    ${Item_NoOFPayments}
   Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Frequency_Field}    ${Item_Frequency} 
   Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Type_Field}    ${Item_type} 
   
   ${sDate}    Mx LoanIQ Get Data   ${LIQ_FSched_AddItems_Date_Field}    value%Date

   Mx LoanIQ Set    ${LIQ_FSched_AddItems_PI_CheckBox}    ON    
   mx LoanIQ enter    ${LIQ_FSched_AddItems_PrincipaAmount_Field}    ${Item_PIAmount}
   Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FlexibleSchedule_AddItems
   mx LoanIQ click    ${LIQ_FSched_AddItems_OK_Button}
   mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
   Mx LoanIQ Select Combo Box Value    ${LIQ_FlexibleSchedule_NonBusinessDayRule_Field}    ${NonBusinessDayRule}        
   mx LoanIQ click element if present    ${LIQ_Information_OK_Button}   
   
   Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree   ${LIQ_FlexibleSchedule_JavaTree}    ${Item_type}%yes
   Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_FlexibleSchedule_JavaTree}    items count%${Item_NoOFPayments}       
   Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FlexibleSchedule
   ### Keyword Post-processing ###
   Save Values of Runtime Execution on Excel File    ${sRunTimeVar_FixedPIDate}    ${sDate}

   [Return]    ${sDate}
   
Add Principal Only Item in Flexible Schedule
    [Documentation]    This keyword is for adding items in Flexible Schedule window.
    ...    This keyword also returns values for Orig_RemainingVal and PrincipalOnlyRemainingVal.
    ...    Orig_RemainingVal = This refers to the original remainig value of the.. 
    ...    PrincipalOnlyRemainingVal = This refers to the Principal Only Remaining value of the..
    ...    @author: mgaling
    ...    @update: rtarayao    11MAR2019    Deleted Write Data keyword, rowid argument, and documentation.
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Added Optional Arguments: ${sRunTimeVar_OrigRemainingVal}, ${sRunTimeVar_PrincipalOnlyRemainingVal}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    [Arguments]    ${sFixedPI_Date}    ${sItem_NoOFPayments}    ${sItem_Frequency}    ${sItem_type}    ${sAddedDays}    ${sItem_PrincipalAmount}    ${sAutoGen_Item}
    ...    ${sRunTimeVar_OrigRemainingVal}=None    ${sRunTimeVar_PrincipalOnlyRemainingVal}=None
    
    ### Keyword Pre-processing ###
    ${FixedPI_Date}    Acquire Argument Value    ${sFixedPI_Date}
    ${Item_NoOFPayments}    Acquire Argument Value    ${sItem_NoOFPayments}
    ${Item_Frequency}    Acquire Argument Value    ${sItem_Frequency}
    ${Item_type}    Acquire Argument Value    ${sItem_type}
    ${AddedDays}    Acquire Argument Value    ${sAddedDays}
    ${Item_PrincipalAmount}    Acquire Argument Value    ${sItem_PrincipalAmount}
    ${AutoGen_Item}    Acquire Argument Value    ${sAutoGen_Item}

    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}
    
    mx LoanIQ click    ${LIQ_FlexibleSchedule_AddItems_Button}
    mx LoanIQ activate window    ${LIQ_FSched_AddItems_Window}
    
    ###Populate the required fields###
    mx LoanIQ enter    ${LIQ_FSched_AddItems_NoOFPayments_Field}    ${Item_NoOFPayments}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Frequency_Field}    ${Item_Frequency} 
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Type_Field}    ${Item_type}
    
    ${Conv_FixedPIDate}    Convert Date    ${FixedPI_Date}     date_format=%d-%b-%Y
    ${Principal_Date}    Add Time To Date    ${Conv_FixedPIDate}    ${AddedDays}days          
    mx LoanIQ enter    ${LIQ_FSched_AddItems_Date_Field}    ${Principal_Date}     
   
    Mx LoanIQ Set    ${LIQ_FSched_AddItems_PrincipalAmount_CheckBox}    ON
    mx LoanIQ enter    ${LIQ_FSched_AddItems_PrincipaAmount_Field}    ${Item_PrincipalAmount}   
    mx LoanIQ click    ${LIQ_FSched_AddItems_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}    
    
    ###Get the Remaining Balance value from the line item (First Line)###
    ${Orig_RemainingVal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${FixedPI_Date}%Remaining%Remaining 
    ${Orig_RemainingVal}    Remove String    ${Orig_RemainingVal}     ,
    ${Orig_RemainingVal}    Convert To Number    ${Orig_RemainingVal}    2
    
    ###Get the Remaining Balance value from the line item (Principal Only Line)###
    ${PrincipalOnlyRemainingVal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${Item_type}%Remaining%Remaining 
    ${PrincipalOnlyRemainingVal}    Remove String    ${PrincipalOnlyRemainingVal}     ,
    ${PrincipalOnlyRemainingVal}    Convert To Number    ${PrincipalOnlyRemainingVal}    2
    
    ${Calculated_RemainingBal}    Evaluate    ${Orig_RemainingVal}-${Item_PrincipalAmount}
    ${Calculated_RemainingBal}    Convert To Number    ${Calculated_RemainingBal}    2     
    
    Should Be Equal As Numbers    ${PrincipalOnlyRemainingVal}    ${Calculated_RemainingBal}
    Log    ${PrincipalOnlyRemainingVal}=${Calculated_RemainingBal}    
    
    ###Validate if the added item are displayed###
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree   ${LIQ_FlexibleSchedule_JavaTree}    ${Item_type}%yes
    Run Keyword And Continue On Failure    Mx LoanIQ Click Javatree Cell    ${LIQ_FlexibleSchedule_JavaTree}    ${Item_type}%${Item_PrincipalAmount}%Principal    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree   ${LIQ_FlexibleSchedule_JavaTree}    ${AutoGen_Item}%yes

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigRemainingVal}    ${Orig_RemainingVal}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_PrincipalOnlyRemainingVal}    ${PrincipalOnlyRemainingVal}
    
    [Return]    ${Orig_RemainingVal}    ${PrincipalOnlyRemainingVal}

Add Interest Only Item in Flexible Schedule
    [Documentation]    This keyword is for adding items in Flexible Schedule window.
    ...    @author:mgaling
    ...    @udpate: rtarayao    11MAR2019    Deleted Read Data keywords and updated the arguments to be used.
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Added Optional Arguments: ${sRunTimeVar_RateBasisValue}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    ...    @update: dahijara    03JUL2020    - Added screenshot keyword.
    [Arguments]    ${sFixedPI_Date}    ${sOrig_RemainingVal}    ${sPrincipalOnlyRemainingVal}    ${sItem_NoOFPayments}    ${sItem_Frequency}    ${sItem_type}    ${sAddedDays}    ${sAllInRate_Value}    ${sItem2AddedDays}    ${sAutoGen_Item}
    ...    ${sRunTimeVar_RateBasisValue}=None
    
    ### Keyword Pre-processing ###
    ${FixedPI_Date}    Acquire Argument Value    ${sFixedPI_Date}
    ${Orig_RemainingVal}    Acquire Argument Value    ${sOrig_RemainingVal}
    ${PrincipalOnlyRemainingVal}    Acquire Argument Value    ${sPrincipalOnlyRemainingVal}
    ${Item_NoOFPayments}    Acquire Argument Value    ${sItem_NoOFPayments}
    ${Item_Frequency}    Acquire Argument Value    ${sItem_Frequency}
    ${Item_type}    Acquire Argument Value    ${sItem_type}
    ${AddedDays}    Acquire Argument Value    ${sAddedDays}
    ${AllInRate_Value}    Acquire Argument Value    ${sAllInRate_Value}
    ${Item2AddedDays}    Acquire Argument Value    ${sItem2AddedDays}
    ${AutoGen_Item}    Acquire Argument Value    ${sAutoGen_Item}

    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}
    mx LoanIQ click    ${LIQ_FlexibleSchedule_AddItems_Button}
    mx LoanIQ activate window    ${LIQ_FSched_AddItems_Window}
    
    ###Populate the required fields###
    mx LoanIQ enter    ${LIQ_FSched_AddItems_NoOFPayments_Field}    ${Item_NoOFPayments}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Frequency_Field}    ${Item_Frequency} 
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Type_Field}    ${Item_type}  
   
    ${FixedPI_Date}    Convert Date    ${FixedPI_Date}     date_format=%d-%b-%Y
    ${Interest_Date}    Add Time To Date    ${FixedPI_Date}    ${AddedDays}days        
    mx LoanIQ enter    ${LIQ_FSched_AddItems_Date_Field}    ${Interest_Date} 
   
    mx LoanIQ click    ${LIQ_FSched_AddItems_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    
    ###Get Rate Basis VAlue###
    ${sRateBasis_Value}    Mx LoanIQ Get Data    ${LIQ_FlexibleSchedule_RateBasis_Value}    text%RateBasis    
    ${sRateBasis_Value}    Remove String    ${sRateBasis_Value}    Actual/
    ${sRateBasis_Value}    Convert To Number    ${sRateBasis_Value}
     
    
    ###Get Number of Days from First Due Date until the Due Date for Interest Only###
    ${InterestFixed_NoDays}    Subtract Date From Date    ${Interest_Date}    ${FixedPI_Date}    verbose
    Log    ${InterestFixed_NoDays}
    ${InterestFixed_NoDays}    Remove String    ${InterestFixed_NoDays}    days    
    ${InterestFixed_NoDays}    Convert To Number    ${InterestFixed_NoDays}    2
    ${PrincipalInterest_NoDays}    Evaluate    ${InterestFixed_NoDays} - ${Item2AddedDays}         
    
    ###Verify the Payment value for Interest Only Item###Update FJ
    ${Calculated_InterestOnlyPayment1}    Evaluate   ((${Orig_RemainingVal})*(${AllInRate_Value}/100))*(${item2_AddedDays}/${sRateBasis_Value})
    ${Calculated_InterestOnlyPayment2}    Evaluate   ((${PrincipalOnlyRemainingVal})*(${AllInRate_Value}/100))*(${PrincipalInterest_NoDays}/${sRateBasis_Value})
    ${Calculated_InterestOnlyPayment}    Evaluate    ${Calculated_InterestOnlyPayment1} + ${Calculated_InterestOnlyPayment2}    
    ${Calculated_InterestOnlyPayment}    Convert To Number    ${Calculated_InterestOnlyPayment}    2        
   
    ${UI_InterestOnlyPayment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${Item_type}%Payment%Payment
    ${UI_InterestOnlyPayment}    Remove String    ${UI_InterestOnlyPayment}     ,
    ${UI_InterestOnlyPayment}    Convert To Number    ${UI_InterestOnlyPayment}    2
    
    #Run Keyword And Continue On Failure    Should Be Equal    ${Calculated_InterestOnlyPayment}    ${UI_InterestOnlyPayment}
    
    ###Verify if the Remaining Value in Principal Only and Interest Only is the same###
    ${UI_InterestOnlyRemaining}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${Item_type}%Remaining%Remaining
    ${UI_InterestOnlyRemaining}    Remove String    ${UI_InterestOnlyRemaining}     ,
    ${UI_InterestOnlyRemaining}    Convert To Number    ${UI_InterestOnlyRemaining}    2 
    
    Should Be Equal    ${PrincipalOnlyRemainingVal}    ${UI_InterestOnlyRemaining}
    Log    ${PrincipalOnlyRemainingVal}=${UI_InterestOnlyRemaining}          
    
    ###Validate if the added item are displayed###
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree   ${LIQ_FlexibleSchedule_JavaTree}    ${Item_type}%yes
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree   ${LIQ_FlexibleSchedule_JavaTree}    ${AutoGen_Item}%yes
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FlexibleSchedule
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_RateBasisValue}    ${sRateBasis_Value}

    [Return]    ${sRateBasis_Value}
   
Calculate Payments in Flexible Schedule
    [Documentation]    This keyword is for calculating the payment items in Flexible Schedule window.
    ...    @author:mgaling
    ...    @update: rtarayao - deleted auto gen item validation. 
    ...    @update: hstone    29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...    @update: dahijara    03JUL2020    - added keyword for screenshot
    [Arguments]    ${sFixedPI_Date}

    ### Keyword Pre-processing ###
    ${FixedPI_Date}    Acquire Argument Value    ${sFixedPI_Date}

    mx LoanIQ click    ${LIQ_FlexibleSchedule_CalculatePayments_Button}
    
    ###Get the data from the line item (First Line)###
    ${FixedPIitem_Payment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${FixedPI_Date}%Payment%Payment 
    ${FixedPIitem_Payment}    Remove String    ${FixedPIitem_Payment}     ,
    ${FixedPIitem_Payment}    Convert To Number    ${FixedPIitem_Payment}    2
    
    ${FixedPIitem_Principal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${FixedPI_Date}%Principal%Principal
    ${FixedPIitem_Principal}    Remove String    ${FixedPIitem_Principal}     ,
    ${FixedPIitem_Principal}    Convert To Number    ${FixedPIitem_Principal}    2
    
    ${FixedPIitem_Interest}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${FixedPI_Date}%Interest%Interest
    ${FixedPIitem_Interest}    Convert To Number    ${FixedPIitem_Interest}    2
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FlexibleSchedule_CalculatePayments

    ###Verify the Principal and Interest data###
    ${CalculatedPayment_Value}    Evaluate    ${FixedPIitem_Principal}+${FixedPIitem_Interest}
    Should Be Equal As Numbers    ${FixedPIitem_Payment}    ${CalculatedPayment_Value}
    Log    ${FixedPIitem_Payment}=${CalculatedPayment_Value} 
    
Generate Rate Setting Notices for Drawdown
    [Documentation]    This keyword will approve the Rates of the initial drawdown
    ...    @author: ritragel
    ...    @update: amansuet    added keyword pre processing
    ...    @update: dahijara    15JUN2020    - Added code to get only the last 11 digits for Customer Name
    ...                                      - Update the validation for Customer Name in UI
    ...    @update: makcamps    15OCT2020	 - added upper() method to borrower name because it is displayed as all caps
    [Arguments]    ${sCustomer_Legal_Name}    ${NoticeStatus}

    ### GetRuntime Keyword Pre-processing ###
    ${Customer_Legal_Name}    Acquire Argument Value    ${sCustomer_Legal_Name}
    ${CustomerNameLength}    Get Length    ${Customer_Legal_Name}
    ${Customer_Legal_Name}    Run Keyword If    ${CustomerNameLength} > 11    Get Substring    ${Customer_Legal_Name}    -11
    ...    ELSE    Set Variable    ${Customer_Legal_Name}
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Generate Rate Setting Notices 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}   
    mx LoanIQ activate window    ${LIQ_Notices_Window}   
    mx LoanIQ click    ${LIQ_Notices_OK_Button}      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}   
    mx LoanIQ activate window    ${LIQ_Rollover_Intent_Notice_Window} 
    Mx LoanIQ Select String    ${LIQ_Notice_Information_Table}    ${Customer_Legal_Name}
    mx LoanIQ click    ${LIQ_Rollover_EditHighlightedNotice_Button}       
    mx LoanIQ activate window    ${LIQ_Rollover_NoticeCreate_Window}
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=.*Notice created.*","displayed:=1").JavaEdit("text:=.*${Customer_Legal_Name.upper()}")    Verified_Customer    
    Should Contain    ${Verified_Customer}    ${Customer_Legal_Name.upper()}
    Log    ${Verified_Customer}    
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=.*Notice created.*","displayed:=1").JavaObject("tagname:=Group","text:=Status").JavaStaticText("text:=${NoticeStatus}")    Verified_Status    
    Should Be Equal As Strings    ${NoticeStatus}    ${Verified_Status}
    Log    ${Verified_Status} - Status is correct! 
    mx LoanIQ close window    ${LIQ_Rollover_NoticeCreate_Window}
    mx LoanIQ close window    ${LIQ_Rollover_Intent_Notice_Window} 

Enter Loan Drawdown Details for AUD Libor Option
    [Documentation]    This keyword is used to enter Loan Drawdown Details for USD Libor Option
    ...    @author: mnanquil
    ...    <update> bernchua 11/13/2018: added click element if present for warning messages when entering dates.
    ...    @update: dahijara    29JUL2020    -  Added Keyword processing and screenshot.. Added key Tab after entering repricing date.
    [Arguments]    ${sLoan_RequestedAmount}    ${sLoan_EffectiveDate}    ${sLoan_MaturityDate}    ${sLoan_RepricingFrequency}    ${sRepricing_Date}    ${sLoan_IntCycleFrequency}    ${sLoan_Accrue}    ${sWarning_Message}            

    ### GetRuntime Keyword Pre-processing ###
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}
    ${Loan_EffectiveDate}    Acquire Argument Value    ${sLoan_EffectiveDate}
    ${Loan_MaturityDate}    Acquire Argument Value    ${sLoan_MaturityDate}
    ${Loan_RepricingFrequency}    Acquire Argument Value    ${sLoan_RepricingFrequency}
    ${Repricing_Date}    Acquire Argument Value    ${sRepricing_Date}
    ${Loan_IntCycleFrequency}    Acquire Argument Value    ${sLoan_IntCycleFrequency}
    ${Loan_Accrue}    Acquire Argument Value    ${sLoan_Accrue}
    ${Warning_Message}    Acquire Argument Value    ${sWarning_Message}

    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    General
    
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window} 
    mx LoanIQ enter    ${LIQ_InitialDrawdown_RequestedAmt_Textfield}    ${Loan_RequestedAmount} 
    mx LoanIQ enter    ${LIQ_InitialDrawdown_EffectiveDate_Datefield}    ${Loan_EffectiveDate}
    mx LoanIQ enter    ${LIQ_InitialDrawdown_MaturityDate_Datefield}    ${Loan_MaturityDate}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Repricing_Dropdownlist}    ${Loan_RepricingFrequency}
    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Repricing_Dropdownlist}    ${Loan_RepricingFrequency}
    mx LoanIQ enter    ${LIQ_InitialDrawdown_RepricingDate_Datefield}    ${Repricing_Date}
    Mx Press Combination    KEY.TAB
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown
    Validate Text of Warning Message    ${Warning_Message}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    ${IntCycleFrequency}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_IntCycleFreq_Dropdownlist}    value%Daily    
    Run Keyword If    '${IntCycleFrequency}'=='${Loan_IntCycleFrequency}'    Log    Int. Cycle Frequence is Daily
    ${Displayed_ActualDueDate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_ActualDueDate_Datefield}    testdata    
    ${Displayed_AdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_AdjustedDueDate_Datefield}    testdata
    Run Keyword If    '${Displayed_ActualDueDate}'=='${Displayed_AdjustedDueDate}'    Log    Accrual End Date is confirmed equal to the Actual Due Date
    mx LoanIQ enter    ${LIQ_InitialDrawdown_AccrualEndDate_Datefield}    ${Displayed_ActualDueDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}	    
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Accrue_Dropdownlist}    ${Loan_Accrue} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown

Input Loan Drawdown Rates for Term Drawdown
    [Documentation]    This keyword is used to input Loan Drawdown Base Rate within the Rates tab.
    ...    @author: ritragel
    [Arguments]    ${Borrower_BaseRate} 
    
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Rates
    mx LoanIQ click    ${LIQ_InitialDrawdown_BaseRate_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}      
    mx LoanIQ enter    ${LIQ_InitialDrawdown_BorrowerBaseRate_Textfield}    ${Borrower_BaseRate} 

    mx LoanIQ click    ${LIQ_InitialDrawdown_SetBaseRate_OK_Button}         

Accept Loan Drawdown Rates for Term Facility
    [Documentation]    This keyword will accept the base rate
    ...    @author: mnanquil
	...	   <update> bernchua 12/3/2018: modified loop check first if warning message exits then click button if true.
    ...    @update: dahijara    29JUL2020    - Added Keyword processing and screenshot.
    [Arguments]    ${sBorrower_BaseRate} 
    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_BaseRate}    Acquire Argument Value    ${sBorrower_BaseRate}

    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Rates
    mx LoanIQ click    ${LIQ_InitialDrawdown_BaseRate_Button}
    :FOR    ${INDEX}    IN RANGE    10
    \    ${status}    Run keyword and Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Exit For Loop If    ${status}==False
    mx LoanIQ click element if present    ${LIQ_Question_No_Button}
    mx LoanIQ click    ${LIQ_InitialDrawdown_AcceptBaseRate}         
    ${baseRate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_BorrowerBaseRate_Textfield}    testData
    Should Be Equal    ${Borrower_BaseRate}    ${baseRate}     
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_BorrowerBaseRate
    mx LoanIQ click    ${LIQ_InitialDrawdown_SetBaseRate_OK_Button}        


Validate Rate Set
    [Documentation]    This keyword will validate the rate set on events tab
    ...    @author: mnanquilada
    ...    10/10/2018
    ...    @update: dahijara    29JUL2020    - Added Keyword processing and screenshot.
    [Arguments]    ${sRateSetup}
    ### GetRuntime Keyword Pre-processing ###
    ${RateSetup}    Acquire Argument Value    ${sRateSetup}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Events
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_SetRate
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_InitialDrawdown_SetRateJavaTree}    ${sRateSetup}%d
    Log    Successfully clicked ${sRateSetup}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_SetRate

Add Holiday Calendar Date
    [Documentation]    This keyword will add holiday calendar date on existing loan
    ...    @author: mnanquil    10OCT2018    - initial create
    ...    @update: jloretiz    29JUL2020    - add pre-processing of keyword, add screenshots, updated the logic for deleting calendar
    ...                                      - change the checkboxes argument to variable to make it dynamic
    [Arguments]    ${sHolidayCalendar}    ${sHolidayCalendarRemove}    ${removeCalendar}=${FALSE}    ${sBorrowerIntentNotice}=ON    ${sFXRateSettingNotice}=ON
    ...    ${sInterestRateSettingNotice}=ON    ${sEffectiveDate}=ON    ${sPaymentAdviceDates}=ON    ${sBilling}=ON

    ###Argument Pre-processing###
    ${HolidayCalendar}    Acquire Argument Value    ${sHolidayCalendar}
    ${RemoveCalendar}    Acquire Argument Value    ${sHolidayCalendarRemove}
    ${BorrowerIntentNotice}    Acquire Argument Value    ${sBorrowerIntentNotice}
    ${FXRateSettingNotice}    Acquire Argument Value    ${sFXRateSettingNotice}
    ${InterestRateSettingNotice}    Acquire Argument Value    ${sInterestRateSettingNotice}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${PaymentAdviceDates}    Acquire Argument Value    ${sPaymentAdviceDates}
    ${Billing}    Acquire Argument Value    ${sBilling}

    ###Navigate to Calendars Tab###
    Mx LoanIQ Activate    ${LIQ_InitialDrawdown_Window} 
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Calendars

    ###Delete Existing Calendar###
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_Calendar_BeforeDeleteHoliday
    Run Keyword If    '${removeCalendar}'=='${TRUE}'    Run Keywords    Mx LoanIQ Select String    ${LIQ_InitialDrawdown_Calendar_JavaTree}    ${RemoveCalendar}
    ...    AND    Mx LoanIQ Click    ${LIQ_InitialDrawdown_Calendar_DeleteButton}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_Calendar_AfterDeleteHoliday
    
    ###Add New Holiday Calendar###
    Mx LoanIQ Click    ${LIQ_InitialDrawdown_Calendar_AddButton}
    Mx LoanIQ Activate Window    ${LIQ_InitialDrawdown_Calendar_HolidayCalendar_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Calendar_HolidayCalendar}    ${HolidayCalendar}
    Mx LoanIQ Set    ${LIQ_InitialDrawdown_Calendar_BorrowerIntentNotice_CheckBox}    ${BorrowerIntentNotice}
    Mx LoanIQ Set    ${LIQ_InitialDrawdown_Calendar_FXRateSettingNotice_CheckBox}    ${FXRateSettingNotice}
    Mx LoanIQ Set    ${LIQ_InitialDrawdown_Calendar_InterestRateSettingNotice_CheckBox}    ${InterestRateSettingNotice}
    Mx LoanIQ Set    ${LIQ_InitialDrawdown_Calendar_EffectiveDate_CheckBox}    ${EffectiveDate}
    Mx LoanIQ Set    ${LIQ_InitialDrawdown_Calendar_PaymentAdviceDates_CheckBox}    ${PaymentAdviceDates}
    Mx LoanIQ Set    ${LIQ_InitialDrawdown_Calendar_Billing_CheckBox}    ${Billing}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDrawdown_Calendar_AddHolidayCalendar
    Mx LoanIQ Click    ${LIQ_InitialDrawdown_Calendar_HolidayCalendar_OkButton}

Calculate Payments in Flexible Schedule After Adding Items
    [Documentation]    This keyword is for calculating the payment items in Flexible Schedule window.
    ...    @author:mgaling
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Added Optional Arguments: ${sRunTimeVar_FixedPIitemPayment}, ${sRunTimeVar_UINewInterestOnly_Payment}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    ...    @update: dahijara    03JUL2020    - Added screenshot keyword.
    [Arguments]    ${sFixedPI_Date}    ${sItem2_type}    ${sItem3_type}    ${sOrig_RemainingVal}    ${sAllInRate_Value}    ${sRateBasis_Value}    ${sPrincipalOnlyRemainingVal}    ${sAutoGen_Item}
    ...    ${sRunTimeVar_FixedPIitemPayment}=None    ${sRunTimeVar_UINewInterestOnly_Payment}=None

    ### Keyword Pre-processing ###
    ${FixedPI_Date}    Acquire Argument Value    ${sFixedPI_Date}
    ${Item2_type}    Acquire Argument Value    ${sItem2_type}
    ${Item3_type}    Acquire Argument Value    ${sItem3_type}
    ${Orig_RemainingVal}    Acquire Argument Value    ${sOrig_RemainingVal}
    ${AllInRate_Value}    Acquire Argument Value    ${sAllInRate_Value}
    ${RateBasis_Value}    Acquire Argument Value    ${sRateBasis_Value}
    ${PrincipalOnlyRemainingVal}    Acquire Argument Value    ${sPrincipalOnlyRemainingVal}
    ${AutoGen_Item}    Acquire Argument Value    ${sAutoGen_Item}

    mx LoanIQ click    ${LIQ_FlexibleSchedule_CalculatePayments_Button}
    ###Get the data from the line item (First Line)###
    ${sFixedPIitem_Payment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${FixedPI_Date}%Payment%Payment 
    ${sFixedPIitem_Payment}    Remove Comma and Convert to Number    ${sFixedPIitem_Payment}
    
    ${sUINewInterestOnly_Payment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${Item3_type}%Payment%Payment 
    ${sUINewInterestOnly_Payment}    Remove Comma and Convert to Number    ${sUINewInterestOnly_Payment}
    
    ###Compute No of Days for Interest Calculation###
    ${Principal_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${Item2_type}%Actual Due Date%Actual Due Date 
    ${Interest_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FlexibleSchedule_JavaTree}    ${Item3_type}%Actual Due Date%Actual Due Date  
    ${FixedPI_Date}    Convert Date    ${FixedPI_Date}     date_format=%d-%b-%Y
    ${Principal_Date}    Convert Date    ${Principal_Date}     date_format=%d-%b-%Y
    ${Interest_Date}    Convert Date    ${Interest_Date}     date_format=%d-%b-%Y
    
    ${PrincipalFixedPI_NoDays}    Subtract Date From Date    ${Principal_Date}    ${FixedPI_Date}    verbose
    Log    ${PrincipalFixedPI_NoDays}
    ${PrincipalFixedPI_NoDays}    Remove String    ${PrincipalFixedPI_NoDays}    days    
    ${PrincipalFixedPI_NoDays}    Convert To Number    ${PrincipalFixedPI_NoDays}    2 
    
    ${InterestPrincipal_NoDays}    Subtract Date From Date    ${Interest_Date}    ${Principal_Date}    verbose
    Log    ${InterestPrincipal_NoDays}
    ${InterestPrincipal_NoDays}    Remove String    ${InterestPrincipal_NoDays}    days    
    ${InterestPrincipal_NoDays}    Convert To Number    ${InterestPrincipal_NoDays}    2 
    
    ###Verify the auto Adjusted Payment for Interest Only###
    ${PrincipalFixedPI_Interest}    Evaluate    ((${Orig_RemainingVal}*(${AllInRate_Value}/100))*(${PrincipalFixedPI_NoDays})/${RateBasis_Value})
    ${PrincipalFixedPI_Interest}    Convert To Number    ${PrincipalFixedPI_Interest}    2 
    ${InterestPrincipal_Interest}    Evaluate    ((${PrincipalOnlyRemainingVal}*(${AllInRate_Value}/100))*(${InterestPrincipal_NoDays})/${RateBasis_Value})
    ${InterestPrincipal_Interest}    Convert To Number    ${InterestPrincipal_Interest}    2
    
    ${sCalculated_TotalInterest}    Evaluate    ${PrincipalFixedPI_Interest}+${InterestPrincipal_Interest}  
    ${sCalculated_TotalInterest}    Remove Comma and Convert to Number    ${sCalculated_TotalInterest}   
    
    # Should Be Equal    ${sUINewInterestOnly_Payment}    ${sCalculated_TotalInterest}    
    
    Run Keyword And Continue On Failure    Mx LoanIQ Click Javatree Cell    ${LIQ_FlexibleSchedule_JavaTree}    ${AutoGen_Item}%0.00%Remaining
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_FlexibleSchedule_JavaTree}    items count%12 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FlexibleSchedule
    mx LoanIQ click    ${LIQ_FlexibleSchedule_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_FixedPIitemPayment}    ${sFixedPIitem_Payment}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_UINewInterestOnly_Payment}    ${sUINewInterestOnly_Payment}
    
    [Return]    ${sFixedPIitem_Payment}    ${sUINewInterestOnly_Payment}                

Validate Flex Schedule Details in Repayment Schedule 
    [Documentation]    This keyword is for verifying Payment and Remaining value.
    ...    @author:mgaling
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...    @update: dahijara    03JUL2020    - Added keyword for screenshot
    [Arguments]    ${sItem_PrincipalAmount}    ${sUINewInterestOnly_Payment}
    
    ### Keyword Pre-processing ###
    ${Item_PrincipalAmount}    Acquire Argument Value    ${sItem_PrincipalAmount}
    ${UINewInterestOnly_Payment}    Acquire Argument Value    ${sUINewInterestOnly_Payment}

    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_FlexSchedule_Section}    VerificationData="Yes"
    
    ${UIPrincipalOnly_Payment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentFlexSchedule_JavaTree}    2%Payment%Payment
    Log    ${UIPrincipalOnly_Payment}
    ${UIPrincipalOnly_Payment}    Remove String    ${UIPrincipalOnly_Payment}    -
    ${UIPrincipalOnly_Payment}    Remove String    ${UIPrincipalOnly_Payment}    ,  
    ${UIPrincipalOnly_Payment}    Convert To Number    ${UIPrincipalOnly_Payment}    2  
    
    ${Item_PrincipalAmount}    Convert To Number    ${Item_PrincipalAmount}    2
    Should Be Equal    ${Item_PrincipalAmount}    ${UIPrincipalOnly_Payment}    
     
    ${UIInterest_Payment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentFlexSchedule_JavaTree}    3%Payment%Payment
    Log    ${UIInterest_Payment}
    ${UIInterest_Payment}    Remove String    ${UIInterest_Payment}    - 
    ${UIInterest_Payment}    Convert To Number    ${UIInterest_Payment}    2
    
    ${UINewInterestOnly_Payment}    Convert To Number    ${UINewInterestOnly_Payment}    2
    Should Be Equal    ${UINewInterestOnly_Payment}    ${UIInterest_Payment}  
                
    ${LastItem_RemainingVal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentFlexSchedule_JavaTree}    12%Remaining%Value
    Should Be Equal    ${LastItem_RemainingVal}    0.00
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule_CurrentFlexSchedule
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Exit_Button} 
    
Navigate Split Cashflows for Drawdown 
    [Documentation]    This keyword is for splitting Cashflows.
    ...    @author:mgaling 
    
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_Cashflow} 
    mx LoanIQ activate window    ${LIQ_Cashflows_Window}
    mx LoanIQ select    ${LIQ_Cashflow_Options_SplitCashflows}
    mx LoanIQ activate window    ${LIQ_SplitCashflows_Window}
    
Populate Split Cashflow Details
    [Documentation]    This keyword is for adding remittance instruction for splitting Cashflows.
    ...    This keyword also returns both split amounts of the split cashflow.
    ...    @author: mgaling
    ...    @update: rtarayao    19MAR2019    Updated data containers format.
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Added Optional Arguments: ${sRunTimeVar_SplitPrincipalValue}, ${sRunTimeVar_TransactionAmount}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    [Arguments]    ${sSplit_Method}    ${sLoan_RequestedAmount}    ${sSplitPrincipal_Percent}    ${sRunTimeVar_SplitPrincipalValue}=None    ${sRunTimeVar_TransactionAmount}=None
    
    ### Keyword Pre-processing ###
    ${Split_Method}    Acquire Argument Value    ${sSplit_Method}
    ${Loan_RequestedAmount}    Acquire Argument Value    ${sLoan_RequestedAmount}
    ${SplitPrincipal_Percent}    Acquire Argument Value    ${sSplitPrincipal_Percent}

    mx LoanIQ click    ${LIQ_SplitCashflows_Add_Button}    
    mx LoanIQ click    ${LIQ_SplitCashflowsDetail_RemittanceInstruction_Button}
    
    mx LoanIQ activate window    ${LIQ_SelectRemittanceInstruction_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectRemittanceInstruction_JavaTree}    ${Split_Method}%s
    mx LoanIQ click    ${LIQ_SelectRemittanceInstruction_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_SplitCashflowsDetail_Window}   
    
    ###Add Correct Value###
    ${Loan_RequestedAmount}    Convert To Number    ${Loan_RequestedAmount}    2
    
    ${SplitPrincipal_Value}    Evaluate    ${Loan_RequestedAmount}*${SplitPrincipal_Percent}/100
    ${SplitPrincipal_Value}    Evaluate    "%.2f" % ${SplitPrincipal_Value}
    ${Loan_RequestedAmount}    Evaluate    "%.2f" % ${Loan_RequestedAmount}

    mx LoanIQ enter    ${LIQ_SplitCashflowsDetail_SplitPrincipal_Field}    ${SplitPrincipal_Value}
    mx LoanIQ click    ${LIQ_SplitCashflowsDetail_OK_Button}
    
    ###Add Bigger Value###
    mx LoanIQ click    ${LIQ_SplitCashflows_Add_Button}    
    
    ${SplitPrincipal_Value2}    Evaluate    ${Loan_RequestedAmount}*${SplitPrincipal_Percent}/100    
    
    mx LoanIQ enter    ${LIQ_SplitCashflowsDetail_SplitPrincipal_Field}    ${SplitPrincipal_Value2}  
    
    ${ErrorExist}    Run Keyword And Return Status    mx LoanIQ activate window    ${LIQ_Error_Window}
    ${ErrorExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Error_Window}    VerificationData="Yes"
    Run Keyword If    ${ErrorExist}==True    Run Keywords    Log    Split Principal amount may not be greater than Transaction Amount
    ...    AND    mx LoanIQ click    ${LIQ_Error_OK_Button}  
    ${TransactionAmount}    Run Keyword If    ${ErrorExist}==True    Input Lesser than Available Transaction Amount    ${SplitPrincipal_Percent}
    ...    ELSE    Evaluate    ${Loan_RequestedAmount}-${SplitPrincipal_Value}

    ${TransactionAmount}    Evaluate    "%.2f" % ${TransactionAmount}
    
    Run Keyword If    ${ErrorExist}==False    Run Keywords
    ...    Log    Split Principal amount is within Transaction Amount
    ...    AND    mx LoanIQ click    ${LIQ_SplitCashflowsDetail_OK_Button}
    
    ###Delete the NONE Method###      
    Mx LoanIQ Click Javatree Cell    ${LIQ_SplitCashflows_JavaTree}    NONE%NONE%Method
    mx LoanIQ click    ${LIQ_SplitCashflows_Delete_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
    mx LoanIQ click    ${LIQ_SplitCashflows_Exit_Button}
    mx LoanIQ activate window    ${LIQ_Cashflows_Window}  
 
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_SplitPrincipalValue}    ${SplitPrincipal_Value}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_TransactionAmount}    ${TransactionAmount}

    [Return]    ${SplitPrincipal_Value}    ${TransactionAmount}
              
Input Lesser than Available Transaction Amount
     [Documentation]    This keyword is for populating the current available Transaction Amount into Split Principal.
    ...    @author: mgaling
    ...    @update: rtarayao    19MAR2019    Updated keyword used in converting the transaction amount. 
    [Arguments]    ${SplitPrincipal_Percent}
    ${sTransactionAmount}    Mx LoanIQ Get Data    ${LIQ_SplitCashflowsDetail_TransactionAmount_Static}    text%value 
    ${sTransactionAmount}    Remove Comma and Convert to Number    ${sTransactionAmount}
    ${sSplitPrincipal_Value}    Evaluate    ${sTransactionAmount}*${SplitPrincipal_Percent}/100       
    mx LoanIQ enter    ${LIQ_SplitCashflowsDetail_SplitPrincipal_Field}    ${sSplitPrincipal_Value}
    mx LoanIQ click    ${LIQ_SplitCashflowsDetail_OK_Button}        
    [Return]    ${sTransactionAmount} 
    
Send Loan with Flex Schedule Repayment to Approval
    [Documentation]    This keyword is for sending the Loan drawdown for approval.
    ...    @author:mgaling 
    
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Drawdown_WorkflowItems}    Send to Approval%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    Send to Approval            
     :FOR    ${i}    IN RANGE    4
     \    Sleep    2s
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
     
    Sleep    3s    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    
Process Loan with Flex Schedule Repayment Workflow Item
    [Documentation]    This keyword is for approving Loan drawdown with Flex Schedule Repayment.
    ...    @author:mgaling
    [Arguments]    ${WIPTransaction_Type}    ${Outstanding_Status}    ${OutstandingTransaction_Type}    ${Deal_Name}    ${LIQ_WorkflowItem}          
    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    Sleep    3s     
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_WIP_Outstanding_JavaTree}    ${Outstanding_Status}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WIP_Outstanding_JavaTree}    ${Outstanding_Status}          
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WIP_Outstanding_JavaTree}    ${Outstanding_Status}    
    Run Keyword If    ${status}==False    Log    'Awaiting Approval' status is not available    

    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_WIP_Outstanding_JavaTree}    ${OutstandingTransaction_Type}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WIP_Outstanding_JavaTree}    ${OutstandingTransaction_Type}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WIP_Outstanding_JavaTree}    ${OutstandingTransaction_Type}  
    Run Keyword If    ${status}==False    Log    Loan Initial Drawdown is not available
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_WIP_Outstanding_JavaTree}    ${Deal_Name}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WIP_Outstanding_JavaTree}    ${Deal_Name}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WIP_Outstanding_JavaTree}    ${Deal_Name}  
    Run Keyword If    ${status}==False    Log    Deal is not available          
    
    Sleep    3s   
    
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Drawdown_WorkflowItems}    ${LIQ_WorkflowItem}%d
    Sleep    3s
           
     :FOR    ${i}    IN RANGE    4
        
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
     \    ${Question_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Question_Window}    VerificationData="Yes"
     \    Run Keyword If    ${Warning_Status}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    Run Keyword If    ${Question_Status}==True    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
     \    Exit For Loop If    ${Warning_Status}==False 

Generate Loan with Flex Schedule Rate Setting Notices
    [Documentation]    This keyword is used to send Rate Setting Notice to the Borrower. 
    ...    @author: mgaling

    [Arguments]    ${LIQCustomer_LegalName}    ${Contact_Email}    ${NoticeStatus}        
    
    mx LoanIQ activate    ${LIQ_Drawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Drawdown_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Drawdown_WorkflowItems}    Generate Rate Setting Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Drawdown_WorkflowItems}    Generate Rate Setting Notices
    
    mx LoanIQ activate window    ${LIQ_Notices_Window}       
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    
    
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Notice_Information_Table}    ${Contact_Email}%s
    
    mx LoanIQ click    ${LIQ_Notice_EditHighlightedNotice_Button}
    mx LoanIQ activate window    ${LIQ_Notice_RateSettingNotice_Window}   
    ${ContactEmail}    Mx LoanIQ Get Data    ${LIQ_Notice_RateSettingNotice_Email}    value%test
    Log    ${ContactEmail}
    Should Be Equal    ${Contact_Email}    ${ContactEmail}          
    mx LoanIQ activate window    ${LIQ_Notice_RateSettingNotice_Window}
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=Rate .* Notice created.*").JavaEdit("text:=${LIQCustomer_LegalName}")    Verified_Customer    
    Log    ${Verified_Customer}
    Should Be Equal As Strings    ${LIQCustomer_LegalName}    ${Verified_Customer}
    Log    ${Verified_Customer}    
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=Rate .* Notice created.*").JavaStaticText("attached text:=${NoticeStatus}")    Verified_Status    
    Should Be Equal As Strings    ${NoticeStatus}    ${Verified_Status}
    Take Screenshot
    mx LoanIQ close window    ${LIQ_Notice_RateSettingNotice_Window}                        
    mx LoanIQ click    ${LIQ_Notice_Exit_Button} 


Validate Global Facility Amounts - Loan Split
    [Documentation]    This keyword validates that the Sum of Outstandings and Avail to Draw Amount less the Current Commitment Amount is equal to zero(0).
    ...    @author: mnanquil
    ...    @update: fmamaril    20MAY2019    Update Validation from Should be equal to Should be equal as string
    ...    @update: bernchua    03JUN2019    Added line to evaluate variable '${Computed_CurrentCmtAmt}' to have 2 decimal places
    ...                                      Used 'Should Be Equal' instead of 'Should Be Equal As Strings' in comparing numbers 
    ...    @update: dahijara    24SEP2020    Added pre processing keywords. 
    ...                                      Updated number formatter for Total outstanding
    ...                                      Added screenshots.
    [Arguments]    ${sTotalOutstanding}    
    ### GetRuntime Keyword Pre-processing ###
    ${TotalOutstanding}    Acquire Argument Value    ${sTotalOutstanding}

    ${NewAvailToDrawAmount}    Get New Facility Available to Draw Amount
    ${NewGlobalOutstandings}    Get New Facility Global Outstandings
    ${TotalOutstanding}    Remove Comma and Convert to Number    ${TotalOutstanding}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook
    Should Be Equal As Strings    ${TotalOutstanding}    ${NewGlobalOutstandings}
    Log    Total Computed Outstanding ${TotalOutstanding} is equal to Facility Outstanding ${NewGlobalOutstandings}          
    ${CurrentCmtAmt}    Get Current Commitment Amount
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook
    
    ${Computed_CurrentCmtAmt}    Evaluate    ${NewAvailToDrawAmount}+${NewGlobalOutstandings}
    ${Computed_CurrentCmtAmt}    Evaluate    "%.2f" % ${Computed_CurrentCmtAmt}
    Log    ${Computed_CurrentCmtAmt}
    
    Should Be Equal    ${Computed_CurrentCmtAmt}    ${CurrentCmtAmt}
    
    ${SumTotal}    Evaluate    ${NewAvailToDrawAmount}+${NewGlobalOutstandings}
    Log    ${SumTotal}
    ${DiffAmount}    Evaluate    ${SumTotal}-${CurrentCmtAmt}
    ${DiffAmount}    Convert to String    ${DiffAmount}        
    Should Be Equal    ${DiffAmount}    0.0
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook

Get Original Data on Loan Amounts Section 
    [Documentation]    This keyword is for getting the original data under Loan Amounts Section.
    ...    @author:mgaling
    ...    @update: ehugo    01JUN2020    - added keyword post-processing; added optional runtime variables; added screenshot
    [Arguments]    ${sRunTimeVar_OrigLoanGlobalOriginal}=None    ${sRunTimeVar_OrigLoanGlobalCurrent}=None    ${sRunTimeVar_OrigLoanHostBankGross}=None    ${sRunTimeVar_OrigLoanHostBankNet}=None 

    mx LoanIQ activate window    ${LIQ_Loan_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General    
    
    ${Orig_LoanGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Amount}    value%Amount 
    ${Orig_LoanGlobalOriginal}    Remove String    ${Orig_LoanGlobalOriginal}     ,
    ${Orig_LoanGlobalOriginal}    Convert To Number    ${Orig_LoanGlobalOriginal}    2  
    
    ${Orig_LoanGlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Amount}    value%Amount 
    ${Orig_LoanGlobalCurrent}    Remove String    ${Orig_LoanGlobalCurrent}     ,
    ${Orig_LoanGlobalCurrent}    Convert To Number    ${Orig_LoanGlobalCurrent}    2 
    
    ${Orig_LoanHostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Amount}    value%Amount 
    ${Orig_LoanHostBankGross}    Remove String    ${Orig_LoanHostBankGross}     ,
    ${Orig_LoanHostBankGross}    Convert To Number    ${Orig_LoanHostBankGross}    2         
    
    ${Orig_LoanHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Amount}    value%Amount
    ${Orig_LoanHostBankNet}    Remove String    ${Orig_LoanHostBankNet}    ,
    ${Orig_LoanHostBankNet}    Convert To Number    ${Orig_LoanHostBankNet}    2  

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_GeneralTab

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigLoanGlobalOriginal}    ${Orig_LoanGlobalOriginal}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigLoanGlobalCurrent}    ${Orig_LoanGlobalCurrent}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigLoanHostBankGross}    ${Orig_LoanHostBankGross}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_OrigLoanHostBankNet}    ${Orig_LoanHostBankNet}
    
    [Return]    ${Orig_LoanGlobalOriginal}    ${Orig_LoanGlobalCurrent}    ${Orig_LoanHostBankGross}    ${Orig_LoanHostBankNet} 

Navigate to Principal Payment
    [Documentation]    This keyword navigates to Principal Payment from Loan Notebook.
    ...    @author:mgaling
    ...    @update: ehugo    02JUN2020    - added screenshot

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ select    ${LIQ_Loan_Options_Payment}
    mx LoanIQ activate window    ${LIQ_Loan_ChoosePayment_Window}
    Mx LoanIQ Set    ${LIQ_Loan_ChoosePayment_PrincipalPayment_RadioButton}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_PrincipalPayment
    mx LoanIQ click    ${LIQ_Loan_ChoosePayment_OK_Button}
    
Get Updated Data on Loan Amounts Section after Principal Payment
    [Documentation]    This keyword validates the new data on Loan Amounts Section.
    ...    @author:mgaling 
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sOrig_LoanGlobalOriginal}    ${sOrig_LoanGlobalCurrent}    ${sPrincipalPayment_RequestedAmount}    ${sOrig_LoanHostBankGross}    ${sComputed_CreditAmt3}    ${sOrig_LoanHostBankNet}                                  
    
    ### GetRuntime Keyword Pre-processing ###
    ${Orig_LoanGlobalOriginal}    Acquire Argument Value    ${sOrig_LoanGlobalOriginal}
    ${Orig_LoanGlobalCurrent}    Acquire Argument Value    ${sOrig_LoanGlobalCurrent}
    ${PrincipalPayment_RequestedAmount}    Acquire Argument Value    ${sPrincipalPayment_RequestedAmount}
    ${Orig_LoanHostBankGross}    Acquire Argument Value    ${sOrig_LoanHostBankGross}
    ${Computed_CreditAmt3}    Acquire Argument Value    ${sComputed_CreditAmt3}
    ${Orig_LoanHostBankNet}    Acquire Argument Value    ${sOrig_LoanHostBankNet}

    ${PrincipalPayment_RequestedAmount}    Convert To Number    ${PrincipalPayment_RequestedAmount}    2
    
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    mx LoanIQ select    ${LIQ_PrincipalPayment_OptionsLoanNotebook}
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General    
    
    ${New_LoanGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Amount}    value%Amount 
    ${New_LoanGlobalOriginal}    Remove String    ${New_LoanGlobalOriginal}     ,
    ${New_LoanGlobalOriginal}    Convert To Number    ${New_LoanGlobalOriginal}    2
    
    Should Be Equal    ${New_LoanGlobalOriginal}    ${Orig_LoanGlobalOriginal} 
    Log    ${New_LoanGlobalOriginal}=${Orig_LoanGlobalOriginal}         
    
    ${New_LoanGlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Amount}    value%Amount 
    ${New_LoanGlobalCurrent}    Remove String    ${New_LoanGlobalCurrent}     ,
    ${New_LoanGlobalCurrent}    Convert To Number    ${New_LoanGlobalCurrent}    2 
    
    ${Computed_LoanGlobalCurrent}    Evaluate    ${Orig_LoanGlobalCurrent}-${PrincipalPayment_RequestedAmount}
    Should Be Equal    ${New_LoanGlobalCurrent}    ${Computed_LoanGlobalCurrent} 
    Log    ${New_LoanGlobalCurrent}=${Computed_LoanGlobalCurrent}   
    
    ${New_LoanHostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Amount}    value%Amount 
    ${New_LoanHostBankGross}    Remove String    ${New_LoanHostBankGross}     ,
    ${New_LoanHostBankGross}    Convert To Number    ${New_LoanHostBankGross}    2  
    
    ${Computed_LoanHostBankGross}    Evaluate    ${Orig_LoanHostBankGross}-${Computed_CreditAmt3}
    Should Be Equal    ${New_LoanHostBankGross}    ${Computed_LoanHostBankGross} 
    Log    ${New_LoanHostBankGross}=s${Computed_LoanHostBankGross}       
    
    ${New_LoanHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Amount}    value%Amount
    ${New_LoanHostBankNet}    Remove String    ${New_LoanHostBankNet}    ,
    ${New_LoanHostBankNet}    Convert To Number    ${New_LoanHostBankNet}    2  
    
    ${Computed_LoanHostBankNet}    Evaluate    ${Orig_LoanHostBankNet}-${Computed_CreditAmt3}
    Should Be Equal    ${New_LoanHostBankNet}    ${Computed_LoanHostBankNet} 
    Log    ${New_LoanHostBankNet}=${Computed_LoanHostBankNet}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_GeneralTab_LoanAmounts
    
    mx LoanIQ close window    ${LIQ_Loan_Window}
   
Get Updated and Validate Data on Loan Amounts Section
    [Documentation]    This keyword validates the new data on Loan Amounts Section.
    ...    @author:mgaling 
    ...    <updated> @ghabal - for Scenario 8 computation
    ...    @update: dahijara    13OCT2020    - Add preprocessing keyword and screenshot
    [Arguments]    ${sOrig_LoanGlobalOriginal}    ${sOrig_LoanGlobalCurrent}    ${sComputed_LoanIntProjectedCycleDue}    ${sCurrentAmount_ExpectedIncreasePercentage}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Orig_LoanGlobalOriginal}    Acquire Argument Value    ${sOrig_LoanGlobalOriginal}
    ${Orig_LoanGlobalCurrent}    Acquire Argument Value    ${sOrig_LoanGlobalCurrent}
    ${Computed_LoanIntProjectedCycleDue}    Acquire Argument Value    ${sComputed_LoanIntProjectedCycleDue}
    ${CurrentAmount_ExpectedIncreasePercentage}    Acquire Argument Value    ${sCurrentAmount_ExpectedIncreasePercentage}

    ${Computed_LoanIntProjectedCycleDue}    Convert To Number    ${Computed_LoanIntProjectedCycleDue}    2
    
    mx LoanIQ activate window    ${LIQ_InterestPayment_Window}
    mx LoanIQ select    ${LIQ_Interest_Options_LoanNotebook}
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Payment_GeneralTab
    ${New_LoanGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Amount}    value%Amount 
    ${New_LoanGlobalOriginal}    Remove String    ${New_LoanGlobalOriginal}     ,
    ${New_LoanGlobalOriginal}    Convert To Number    ${New_LoanGlobalOriginal}    2
    
    Should Be Equal    ${New_LoanGlobalOriginal}    ${Orig_LoanGlobalOriginal} 
    Log    There is no change in the Original amount of the Loan          
    
    ${New_LoanGlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Amount}    value%Amount 
    ${New_LoanGlobalCurrent}    Remove String    ${New_LoanGlobalCurrent}     ,
    ${New_LoanGlobalCurrent}    Convert To Number    ${New_LoanGlobalCurrent}    2 
    
    ${DifferenceAmount}    Evaluate    ${New_LoanGlobalCurrent}-${Orig_LoanGlobalCurrent}    
    ${DifferenceAmount}    Convert To Number    ${DifferenceAmount}    2
    
    ${Computed_IncreasedAmount}    Validate Details of the Cashflow/GL Entries Amount    ${DifferenceAmount}    ${CurrentAmount_ExpectedIncreasePercentage}    ${rowid}    ${Computed_LoanIntProjectedCycleDue}
    Log    ${Computed_IncreasedAmount}
    ${Computed_IncreasedAmount}    Convert To Number    ${Computed_IncreasedAmount}    2
        
    ${Difference_Status}    Run Keyword And Return Status    Should Be Equal    ${DifferenceAmount}    ${Computed_IncreasedAmount}         
    Run Keyword If    ${Difference_Status}==True    Run Keywords    Write Data To Excel  CAP03_InterestPayment    Computed_IncreasedCurrentAmount    ${rowid}    ${Computed_IncreasedAmount}    
    ...    AND    Log    An increased by ${CurrentAmount_ExpectedIncreasePercentage}% of the Requested amount has been confirmed
    Run Keyword If    ${Difference_Status}==False    Log    An increased by ${CurrentAmount_ExpectedIncreasePercentage}% of the Requested amount has been NOT confirmed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Payment_GeneralTab

Get Updated and Validate Loan Amounts
    [Documentation]    This keyword validates the new data on Loan Amounts Section.
    ...    @author:mgaling 
    ...    <updated> @ghabal - for Scenario 8 computation
    ...    @update: dahijara    13OCT2020    - Added pre-processing and screenshot
    ...    @update: dahijara    14OCT2020    - Removed Convert to Number Keyword for Host Bank percentage. Reason: Rounding off to 2 decimal causes issue in computation.
    
    [Arguments]    ${sOrig_LoanGlobalOriginal}    ${sOrig_LoanGlobalCurrent}    ${sComputed_LoanIntProjectedCycleDue}    ${sCurrentAmount_ExpectedIncreasePercentage}    
    ...    ${sOrig_LoanHostBankGross}    ${sOrig_LoanHostBankNet}    ${sHostBankGross_Percentage}    ${sHostBankNet_Percentage}    ${sComputed_IncreasedCurrentAmountinUSD}

    ### GetRuntime Keyword Pre-processing ###
    ${Orig_LoanGlobalOriginal}    Acquire Argument Value    ${sOrig_LoanGlobalOriginal}
    ${Orig_LoanGlobalCurrent}    Acquire Argument Value    ${sOrig_LoanGlobalCurrent}
    ${Computed_LoanIntProjectedCycleDue}    Acquire Argument Value    ${sComputed_LoanIntProjectedCycleDue}
    ${CurrentAmount_ExpectedIncreasePercentage}    Acquire Argument Value    ${sCurrentAmount_ExpectedIncreasePercentage}
    ${Orig_LoanHostBankGross}    Acquire Argument Value    ${sOrig_LoanHostBankGross}
    ${Orig_LoanHostBankNet}    Acquire Argument Value    ${sOrig_LoanHostBankNet}
    ${HostBankGross_Percentage}    Acquire Argument Value    ${sHostBankGross_Percentage}
    ${HostBankNet_Percentage}    Acquire Argument Value    ${sHostBankNet_Percentage}
    ${Computed_IncreasedCurrentAmountinUSD}    Acquire Argument Value    ${sComputed_IncreasedCurrentAmountinUSD}
    
    ${Computed_LoanIntProjectedCycleDue}    Convert To Number    ${Computed_LoanIntProjectedCycleDue}    2
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_GeneralTab
    ####### Validate 'Global Original' Amounts
    ${New_LoanGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Amount}    value%Amount 
    ${New_LoanGlobalOriginal}    Remove String    ${New_LoanGlobalOriginal}     ,
    ${New_LoanGlobalOriginal}    Convert To Number    ${New_LoanGlobalOriginal}    2
    
    Should Be Equal    ${New_LoanGlobalOriginal}    ${Orig_LoanGlobalOriginal} 
    Log    There is no change in the Original amount of the Loan          
    
    ####### Validate 'Global Current' Amounts
    ${New_LoanGlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Amount}    value%Amount 
    ${New_LoanGlobalCurrent}    Remove String    ${New_LoanGlobalCurrent}     ,
    ${New_LoanGlobalCurrent}    Convert To Number    ${New_LoanGlobalCurrent}    2 
    
    ${DifferenceAmount}    Evaluate    ${New_LoanGlobalCurrent}-${Orig_LoanGlobalCurrent}    
    ${DifferenceAmount}    Convert To Number    ${DifferenceAmount}    2
    
    ${Computed_IncreasedCurrentAmountinUSD}    Convert To Number    ${Computed_IncreasedCurrentAmountinUSD}    2
        
    ${Difference_Status}    Run Keyword And Return Status    Should Be Equal    ${DifferenceAmount}    ${Computed_IncreasedCurrentAmountinUSD}         
    Run Keyword If    ${Difference_Status}==True    Run Keyword    Log    An increased by ${CurrentAmount_ExpectedIncreasePercentage}% of the Requested amount has been confirmed
    Run Keyword If    ${Difference_Status}==False    Log    An increased by ${CurrentAmount_ExpectedIncreasePercentage}% of the Requested amount has been NOT confirmed    
    
    ####### Validate 'Host Bank Gross' Amounts
    ${New_LoanHostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Amount}    value%Amount 
    ${New_LoanHostBankGross}    Remove String    ${New_LoanHostBankGross}     ,
    ${New_LoanHostBankGross}    Convert To Number    ${New_LoanHostBankGross}    2  
    
    ${HostBankGross_Percentage}    Evaluate    ${HostBankGross_Percentage}/100
    Log    ${HostBankGross_Percentage}
    
    ${Computed_LoanHostBankGross}    Evaluate    ${New_LoanGlobalCurrent}*${HostBankGross_Percentage}
    ${Computed_LoanHostBankGross}    Convert To Number    ${Computed_LoanHostBankGross}    2
    Should Be Equal    ${New_LoanHostBankGross}    ${Computed_LoanHostBankGross} 
    Log    Host Bank Gross amount is confirmed ${HostBankGross_Percentage}% of the Global Current       
    
    ####### Validate 'Host Bank Net' Amounts
    ${New_LoanHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Amount}    value%Amount
    ${New_LoanHostBankNet}    Remove String    ${New_LoanHostBankNet}    ,
    ${New_LoanHostBankNet}    Convert To Number    ${New_LoanHostBankNet}    2  
    
    ${HostBankNet_Percentage}    Evaluate    ${HostBankNet_Percentage}/100
    Log    ${HostBankNet_Percentage}
        
    ${Computed_LoanHostBankNet}    Evaluate    ${New_LoanGlobalCurrent}*${HostBankNet_Percentage}
    ${Computed_LoanHostBankNet}    Convert To Number    ${Computed_LoanHostBankNet}    2
    Should Be Equal    ${New_LoanHostBankNet}    ${Computed_LoanHostBankNet} 
    Log    Host Bank Net amount is confirmed ${HostBankNet_Percentage}% of the Global Current
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_GeneralTab

Get Updated and Validate Facility Amounts
    [Documentation]    This keyword validates the new data on Loan Amounts Section.
    ...    @author:mgaling 
    ...    <updated> @ghabal - for Scenario 8 computation
    ...    @update: dahijara    13OCT2020    - Added pre-processing and screenshot
    [Arguments]    ${sOrig_FacilityCurrentCmt}    ${sOrig_FacilityOutstandings}    ${sOrig_FacilityAvailableToDraw}    ${sComputed_IncreasedCurrentAmountinAUD}    

    ### GetRuntime Keyword Pre-processing ###
    ${Orig_FacilityCurrentCmt}    Acquire Argument Value    ${sOrig_FacilityCurrentCmt}
    ${Orig_FacilityOutstandings}    Acquire Argument Value    ${sOrig_FacilityOutstandings}
    ${Orig_FacilityAvailableToDraw}    Acquire Argument Value    ${sOrig_FacilityAvailableToDraw}
    ${Computed_IncreasedCurrentAmountinAUD}    Acquire Argument Value    ${sComputed_IncreasedCurrentAmountinAUD}

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ select    ${LIQ_LoanNotebook_FacilityNotebook_Menu}

    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_SummaryTab
    ${Computed_IncreasedCurrentAmountinAUD}    Convert To Number    ${Computed_IncreasedCurrentAmountinAUD}    2
    
    ####### Validate 'Current Commitment' Amount
    ${Orig_FacilityCurrentCmt}    Convert To Number    ${Orig_FacilityCurrentCmt}    2
    
    ${New_FacilityCurrentCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    value%Amount 
    ${New_FacilityCurrentCmt}    Remove String    ${New_FacilityCurrentCmt}     ,
    ${New_FacilityCurrentCmt}    Convert To Number    ${New_FacilityCurrentCmt}    2         
       
    Should Be Equal    ${New_FacilityCurrentCmt}    ${Orig_FacilityCurrentCmt}   
    Log    There is no change in the current commitment amount of the Facility          
    
    ####### Validate 'Outstanding' Amount
    ${New_FacilityOutstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    value%Amount
    ${New_FacilityOutstandings}    Remove String    ${New_FacilityOutstandings}    ,
    ${New_FacilityOutstandings}    Convert To Number    ${New_FacilityOutstandings}    2  
    
    ${Computed_FacilityOutstandings}    Evaluate    ${New_FacilityOutstandings}-${Orig_FacilityOutstandings}
    ${Computed_FacilityOutstandings}    Convert To Number    ${Computed_FacilityOutstandings}    2
    Should Be Equal    ${Computed_FacilityOutstandings}    ${Computed_IncreasedCurrentAmountinAUD}   
    Log    An increased amount of ${Computed_FacilityOutstandings} is confirmed based on the computation of the conversion of the increase     
    
    ####### Validate 'Available to Draw' Amount
    ${New_FacilityAvailableToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    value%Amount
    ${New_FacilityAvailableToDraw}    Remove String    ${New_FacilityAvailableToDraw}    ,
    ${New_FacilityAvailableToDraw}    Convert To Number    ${New_FacilityAvailableToDraw}    2 
    
    ${Computed_FacilityAvailableToDraw}    Evaluate    ${Orig_FacilityAvailableToDraw}-${New_FacilityAvailableToDraw}
    ${Computed_FacilityAvailableToDraw}    Convert To Number    ${Computed_FacilityOutstandings}    2
    Should Be Equal    ${Computed_FacilityAvailableToDraw}    ${Computed_IncreasedCurrentAmountinAUD}   
    Log    A decreased amount of ${Computed_FacilityAvailableToDraw} is confirmed based on the computation of the conversion of the decrease
       
    ####### Validate'Outstanding' and 'Available to Draw' Amount
    ${TotalAmount}    Evaluate    ${New_FacilityOutstandings}+${New_FacilityAvailableToDraw} 
    Should Be Equal    ${New_FacilityCurrentCmt}    ${TotalAmount}   
    Log    Total Amount for 'Outstanding' and 'Available to Draw' is confirmed equal to the current Facility commitment amount
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_SummaryTab
    
Validate Currency against FX rate in API   
    [Documentation]    This keyword validates the FX rates against API 
    ...    @author:@ghabal
    ...    @update: dahijara    13OCT2020    - Added pre-processing keyword and screenshot.
    [Arguments]    ${sFXrate_fromAPI}    

    ### GetRuntime Keyword Pre-processing ###
    ${FXrate_fromAPI}    Acquire Argument Value    ${sFXrate_fromAPI}
    
    mx LoanIQ activate window    ${LIQ_InterestPayment_Window}
    mx LoanIQ select    ${LIQ_Interest_Options_LoanNotebook}
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Currency
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanWindow_CurrencyTab
    
    ${FXrate_fromUI}    Mx LoanIQ Get Data    ${LIQ_Loan_Currency_FXRateAUDtoUSD}    value%Amount
    ${FXrate_fromUI}    Strip String    ${FXrate_fromUI}    characters=AUD to USD
    Log    ${FXrate_fromUI}            
        
    Should Be Equal    ${FXrate_fromAPI}    ${FXrate_fromUI}
    Log    The FX rate is confirmed correct based from the Loan Split API value          

Validate Conversion Amount for the Increase in Loan Amount   
    [Documentation]    This keyword validates the conversion amount from AUD to USD  
    ...    @author:@ghabal
    ...    @update: dahijara    13OCT2020    - Added pre-processing keyword and screenshot.
    [Arguments]    ${sFXrate_fromAPI}    ${sComputed_IncreasedCurrentAmount}    ${sOrig_FacilityOutstandings}    

    ### GetRuntime Keyword Pre-processing ###
    ${FXrate_fromAPI}    Acquire Argument Value    ${sFXrate_fromAPI}
    ${Computed_IncreasedCurrentAmount}    Acquire Argument Value    ${sComputed_IncreasedCurrentAmount}
    ${Orig_FacilityOutstandings}    Acquire Argument Value    ${sOrig_FacilityOutstandings}

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ select    ${LIQ_LoanNotebook_FacilityNotebook_Menu}
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Summary
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityWindow_SummaryTab
    
    ${New_FacilityOutstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    value%Amount
    ${New_FacilityOutstandings}    Remove String    ${New_FacilityOutstandings}    ,
    ${New_FacilityOutstandings}    Convert To Number    ${New_FacilityOutstandings}    2            
    
    ${DifferenceAmountinAUD}    Evaluate    ${New_FacilityOutstandings}-${Orig_FacilityOutstandings}    
    ${DifferenceAmountinAUD}    Convert To Number    ${DifferenceAmountinAUD}    2
    
    ######## Evaluate Conversion
    ${IncreasedAmountfromUSDtoAUD}    Evaluate    ${Computed_IncreasedCurrentAmount}/${FXrate_fromAPI}    
    ${IncreasedAmountfromUSDtoAUD}    Convert To Number    ${IncreasedAmountfromUSDtoAUD}    2
    Write Data To Excel    CAP03_InterestPayment    Computed_IncreasedCurrentAmountinAUD    ${rowid}    ${IncreasedAmountfromUSDtoAUD}
    
    Should Be Equal    ${DifferenceAmountinAUD}    ${IncreasedAmountfromUSDtoAUD}
    Log    The converted amount from USD to AUD is confirmed correct based on the Loan Split API value

New Outstanding Select
    [Documentation]    This keyword creates a new Outstanding Select, where it enters and verifies the details displayed in the window.
    ...    This keyword also returns the Alias generated.
    ...    @author: bernchua
    ...    @update: bernchua    23AUG2019    Added taking of screenshots
    ...    @update: dahijara    08SEP2020    Added Pre and Post Processing and Screenshot.
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}    ${sBorrower_Name}    ${sOutstanding_Type}    ${sPricing_Option}    ${sOutstanding_Currency}    ${sRunVar_Alias}=None

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Borrower_Name}    Acquire Argument Value    ${sBorrower_Name}
    ${Outstanding_Type}    Acquire Argument Value    ${sOutstanding_Type}
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${Outstanding_Currency}    Acquire Argument Value    ${sOutstanding_Currency}

    mx LoanIQ activate    ${LIQ_OutstandingSelect_Window}
    Mx LoanIQ Set    ${LIQ_OutstandingSelect_New_RadioButton}    ON
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Outstanding_Type}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    
    ${DealName_UI}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Deal_JavaEdit}    value%name
    ${FacilityName_UI}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Facility_Dropdown}    value%name    
    ${BorrowerName_UI}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Borrower_Dropdown}    value%name
    Run Keyword If    '${DealName_UI}'=='${Deal_Name}'    Log    Deal name verified.
    ...    ELSE    Fail    Deal name not verified.
    Run Keyword If    '${FacilityName_UI}'=='${Facility_Name}'    Log    Facility name verified.
    ...    ELSE    Fail    Facility name not verified.
    Run Keyword If    '${BorrowerName_UI}'=='${Borrower_Name}'    Log    Borrower name verified.
    ...    ELSE    Fail    Borrower name not verified.
    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    ${Pricing_Option}
    ${OutstandingCCY_UI}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Currency_Dropwdown}    value%ccy
    Run Keyword If    '${OutstandingCCY_UI}'=='${Outstanding_Currency}'    Log    Outstanding currency verified.
    
    ${Alias}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Alias_JavaEdit}    value%alias    
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelectWindow
    mx LoanIQ click    ${LIQ_OutstandingSelect_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelectWindow

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Alias}    ${Alias}
    [Return]    ${Alias}
    
Enter Initial Loan Drawdown General Details
    [Documentation]    This keywors enters the details in the General tab of the Initial Drawdown Notebook.
    ...                @author: bernchua
    ...                @update: bernchua    07JAN2019    Set default values for some arguments
    ...                @update: bernchua    07JAN2019    Added conditions for variables with default values
    ...                @update: fluberio    27NOV2020    Added condition for maturity date
    [Arguments]    ${Requested_Amount}    ${Effective_Date}    ${Maturity_Date}    ${Accrue}    ${Drawdown_Currency}
    ...    ${Repricing_Frequency}=${EMPTY}    ${Repricing_Date}=${EMPTY}    ${NBD_Reason}=${EMPTY}    ${IntCycleFreq}=${EMPTY}
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    General
    mx LoanIQ enter    ${LIQ_InitialDrawdown_RequestedAmt_Textfield}    ${Requested_Amount}
    mx LoanIQ enter    ${LIQ_InitialDrawdown_EffectiveDate_Datefield}    ${Effective_Date}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${Maturity_Date}'!='${EMPTY}'    Run Keywords    mx LoanIQ enter    ${LIQ_InitialDrawdown_MaturityDate_Datefield}    ${Maturity_Date}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    :FOR    ${i}    IN RANGE    3
    \    Run Keyword If    '${Repricing_Frequency}'!='${EMPTY}'    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Repricing_Dropdownlist}    ${Repricing_Frequency}
    \    ${errorDisplayed}    Run Keyword If    '${Repricing_Frequency}'!='${EMPTY}'    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Error_Window}    VerificationData="Yes"
    \    Run Keyword If    ${errorDisplayed}==True    mx LoanIQ click    ${LIQ_Error_OK_Button}
    \    Exit For Loop If    ${errorDisplayed}==False
    Run Keyword If    '${Repricing_Date}'!='${EMPTY}'    Enter Date With Business Day and Non-Business Day Validations    ${LIQ_InitialDrawdown_RepricingDate_Datefield}    ${Repricing_Date}    ${NBD_Reason}
    Run Keyword If    '${IntCycleFreq}'!='${EMPTY}'    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_IntCycleFreq_Dropdownlist}    ${IntCycleFreq}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InitialDrawdown_Accrue_Dropdown}    ${Accrue}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    ${Drawdown_ActualDueDate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_ActualDueDate_Datefield}    value%date
    mx LoanIQ enter    ${LIQ_InitialDrawdown_AccrualEndDate_Datefield}    ${Drawdown_ActualDueDate}    
   
    ${Drawdown_ActualCCY}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_ActualCCY_StaticText}    value%ccy
    Run Keyword If    '${Drawdown_ActualCCY}'=='${Drawdown_Currency}'    Log    Initial Drawdown Actual CCY ${Drawdown_Currency} verified.
    ...    ELSE    Fail    Initial Drawdown currency validation failed.
    
Set Base Rate In Drawdown Notebook With API Validations
    [Documentation]    This keyword sets the base rates in the Initial Drawdown Notebook.
    ...                @author: bernchua
    [Arguments]    ${Base_Rate}
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Rates    
    mx LoanIQ click    ${LIQ_InitialDrawdown_BaseRate_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    ${NBDWarning_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}            VerificationData="Yes"
    ${NBDWarning_Message}    Run Keyword If    ${NBDWarning_Exist}==True    Mx LoanIQ Get Data    ${LIQ_Warning_MessageBox}    value%message
    ${NBDMessage_Validate}    Run Keyword And Return Status    Should Contain    ${NBDWarning_Message}    non-business day
    Run Keyword If    ${NBDMessage_Validate}==True    Run Keywords
    ...    Log    Non-business day warning message is verified.
    ...    AND    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    Verify If Warning Is Displayed
    mx LoanIQ click element if present    ${LIQ_Question_No_Button}
    ${BaseRateFromPricing}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_BaseRateFromPricing_Text}    value%rate
    Run Keyword If    '${BaseRateFromPricing}'=='${Base_Rate}'    Run Keywords
    ...    Log    Base Rate ${Base_Rate} is verified.
    ...    AND    mx LoanIQ click    ${LIQ_InitialDrawdown_AcceptBaseRate}
    ...    ELSE    Fail    Base Rate from Pricing not verified.
    ${BorrowerBaseRate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_BorrowerBaseRate_Textfield}    value%rate    
    Run Keyword If    '${BorrowerBaseRate}'=='${BaseRateFromPricing}'    Log    Borrower Base Rate is verified with the value of ${BorrowerBaseRate}, and is equal to the Base Rate from Pricing.
    ...    ELSE    Fail    Borrower Base Rate not verified.
    mx LoanIQ click    ${LIQ_InitialDrawdown_SetBaseRate_OK_Button}
    ${BaseRate_Current}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_BaseRate_Current_Text}    value%rate
    Run Keyword If    '${BaseRate_Current}'=='${Base_Rate}'    Log    Base Rate with the value of ${BaseRate_Current} is successfully set.
    
Validate Drawdown Rate Change Event
    [Documentation]    This keyword validates the Rate change event in the Intial Drawdown Notebook's Events tab.
    ...                @author: bernchua
    [Arguments]    ${Rate}
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Events
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}    2
    ${Rate}    Catenate    SEPARATOR=    ${Rate}    %
    Mx LoanIQ Select String    ${LIQ_DrawdownEvents_List}    Rates Set
    ${Comment}    Mx LoanIQ Get Data    ${LIQ_DrawdownEvents_Comment}    value%comment
    ${Comment_Status}    Run Keyword And Return Status    Should Contain    ${Comment}    ${Rate}    
    Run Keyword If    ${Comment_Status}==True    Log    Rate change with amount of ${Rate} is verified.
    ...    ELSE    Fail    Rate change event validation not verified.

Validate Initial Drawdown Events Tab
    [Documentation]    This keyword validates the Initial Drawdown Notebook's Event Tab
    ...                @author: bernchua
    [Arguments]    ${Event_Name}
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Events
    ${Event_Selected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_DrawdownEvents_List}    ${Event_Name}
    Run Keyword If    ${Event_Selected}==True    Log    ${Event_Name} is shown in the Events list of the Drawdown notebook.
    ...    ELSE    Fail    Event not verified.

Compute Transaction Amount
    [Documentation]    This keyword computes for the Lender's Tran Amount based from the Drawdown amount and Lender share percent, to be used in validating the amounts shown in the Cashflows
    ...                @author: bernchua
    [Arguments]    ${Drawdown_Amount}    ${Lender_Share}
    ${Drawdown_Amount}    Remove Comma, Negative Character and Convert to Number    ${Drawdown_Amount}
    ${Lender_Share}    Convert To Number    ${Lender_Share}
    ${Lender_Share}    Evaluate    ${Lender_Share}/100    
    ${TranAmount}    Evaluate    ${Drawdown_Amount}*${Lender_Share}
    [Return]    ${TranAmount} 
   
Set Initial Drawdown Spot FX Rate
    [Documentation]    This keyword sets the FX Rates in the Initial Drawdown Notebook.
    ...                @author: bernchua    
    [Arguments]    ${Exchange_Currencies}    ${Exchange_Rate}
    mx LoanIQ activate    ${LIQ_FXRate_Window}
    ${ExchangeCCY_UI}    Mx LoanIQ Get Data    ${LIQ_FXRate_UserSpotRate_Button}    label%text
    ${SpotExchangeRate_UI}    Mx LoanIQ Get Data    ${LIQ_FXRate_SpotRate_Text}    value%rate    
    ${Validate_ExchangeCCY}    Run Keyword And Return Status    Should Contain    ${ExchangeCCY_UI}    ${Exchange_Currencies}
    ${validate_ExchangeRate}    Run Keyword And Return Status    Should Be Equal    ${Exchange_Rate}    ${SpotExchangeRate_UI}        
    Run Keyword If    ${Validate_ExchangeCCY}==True    Log    Exchange rate is verified for ${Exchange_Currencies}.
    ...    ELSE    Fail    Exchange currency not verified.
    Run Keyword If    ${validate_ExchangeRate}==True    Log    Spot Rate for ${Exchange_Currencies} is verified with the value of ${Exchange_Rate}.'
    ...    ELSE    Fail    Exchange rate is not verified.
    mx LoanIQ click    ${LIQ_FXRate_UserSpotRate_Button}
    ${ActualRate_UI}    Mx LoanIQ Get Data    ${LIQ_FXRate_Rate_Textfield}    value%rate    
    Run Keyword If    '${ActualRate_UI}'=='${SpotExchangeRate_UI}'    Log    Actual Rate ${ActualRate_UI} is equal to the Spot Exchange Rate ${SpotExchangeRate_UI}.
    mx LoanIQ click    ${LIQ_FXRate_OK_Button}

Add Calendar In Inital Drawdown Notebook
    [Documentation]    This keyword adds and verifies the added Holiday Calendar in the Initial Drawdown Notebook.
    ...                @author: bernchua
    [Arguments]    ${Calendar_Name}
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Calendars
    ${CalendarItem_Exist}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_InitialDrawdown_Calendar_JavaTree}    ${Calendar_Name}%s
    Run Keyword If    ${CalendarItem_Exist}==True    Run Keywords    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_Calendar_JavaTree}    ${Calendar_Name}
    ...    AND    Validate Deal Holiday Calendar Items
    ...    AND    mx LoanIQ click    ${LIQ_HolidayCalendar_Cancel_Button}
    ...    ELSE    Run Keywords    mx LoanIQ click    ${LIQ_InitialDrawdown_Calendar_AddButton}
    ...    AND    Mx LoanIQ Select Combo Box Value    ${LIQ_HolidayCalendar_ComboBox}    ${Calendar_Name}
    ...    AND    Validate Deal Holiday Calendar Items
    ...    AND    mx LoanIQ click    ${LIQ_HolidayCalendar_OK_Button}
    
Validate Initial Drawdown Currency Tab Details
    [Documentation]    This keyword validates the details in the Currency Tab of the Initial Drawdown Notebook.
    ...                @author: bernchua
    ...                @update: dahijara    22SEP2020    - Added pre and post processing keyword and screenshot.
    [Arguments]    ${sDrawdown_Currency}    ${sFacility_Currency}    ${sFXRate_Currency}    ${sFXRate_ExchangeRate}    ${sDrawdown_Amount}    ${sHostBankShare}    ${sRunVar_Computed_Current}=None    ${sRunVar_Computed_HostBankGross}=None    ${sRunVar_Computed_HostBanknet}=None
    ### GetRuntime Keyword Pre-processing ###
    ${Drawdown_Currency}    Acquire Argument Value    ${sDrawdown_Currency}
    ${Facility_Currency}    Acquire Argument Value    ${sFacility_Currency}
    ${FXRate_Currency}    Acquire Argument Value    ${sFXRate_Currency}
    ${FXRate_ExchangeRate}    Acquire Argument Value    ${sFXRate_ExchangeRate}
    ${Drawdown_Amount}    Acquire Argument Value    ${sDrawdown_Amount}
    ${HostBankShare}    Acquire Argument Value    ${sHostBankShare}

    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Currency    
    ${Currency_UI}    Mx LoanIQ Get Data    ${LIQ_DrawdownCurrencyTab_Currency_StaticText}    value%ccy    
    ${FacilityCurrency_UI}    Mx LoanIQ Get Data    ${LIQ_DrawdownCurrencyTab_FacilityCurrency_StaticText}    value%ccy
    ${FXRate_UI}    Mx LoanIQ Get Data    ${LIQ_DrawdownCurrencyTab_FXRate_StaticText}    value%rate
    ${Current_UI}    Mx LoanIQ Get Data    ${LIQ_DrawdownCurrencyTab_Current_StaticText}    value%current    
    ${HostBankGross_UI}    Mx LoanIQ Get Data    ${LIQ_DrawdownCurrencyTab_HostBankGross_StaticText}    value%gross    
    ${HostBankNet_UI}    Mx LoanIQ Get Data    ${LIQ_DrawdownCurrencyTab_HostBankNext_StaticText}    value%net
    ${FXRate_ExchangeRate}    Convert To Number    ${FXRate_ExchangeRate}
    ${FXRate_ExchangeRate}    Convert To String    ${FXRate_ExchangeRate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DrawdownCurrencyTab
    ${Computed_Current}    ${Computed_HostBankGross}    ${Computed_HostBanknet}    Compute 'Amounts in Facility Currency' In Initial Drawdown Notebook    ${FXRate_ExchangeRate}
    ...    ${Drawdown_Amount}    ${HostBankShare}
    ${Validate_FXRateCurrency}    Run Keyword And Return Status    Should Contain    ${FXRate_UI}    ${FXRate_Currency}
    ${Validate_FXExchangeRate}    Run Keyword And Return Status    Should Contain    ${FXRate_UI}    ${FXRate_ExchangeRate}
    
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Currency
    Run Keyword If    '${Drawdown_Currency}'=='${Currency_UI}'    Log    FX Rate Currency of ${Drawdown_Currency} is verified.
    ...    ELSE    Fail    FX Rate currency not verified.
    Run Keyword If    '${Facility_Currency}'=='${FacilityCurrency_UI}'    Log    Facility Currency of ${Facility_Currency} is verified.
    ...    ELSE    Fail    Facility Currency not verified.
    Run Keyword If    ${Validate_FXRateCurrency}==True and ${Validate_FXExchangeRate}==True    Log    FX Rate Currency and Exchange Rate of ${FXRate_Currency} - ${FXRate_ExchangeRate} is verified.
    ...    ELSE    Fail    Actual FX Rate not verified.
    Run Keyword If    '${Computed_Current}'=='${Current_UI}'    Log    Current amount of ${Computed_Current} is verified.
    ...    ELSE    Fail    Current amount not verified.
    Run Keyword If    '${Computed_HostBankGross}'=='${HostBankGross_UI}'    Log    Host Bank Gross with the amount of ${Computed_HostBankGross} is verified.
    ...    ELSE    Fail    Host Bank Gross amount not verified.
    Run Keyword If    '${Computed_HostBanknet}'=='${HostBankNet_UI}'    Log    Host Bank Net with the amount of ${Computed_HostBanknet} is verified.
    ...    ELSE    Fail    Host Bank Net amount not verified.

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Computed_Current}    ${Computed_Current}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Computed_HostBankGross}    ${Computed_HostBankGross}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Computed_HostBanknet}    ${Computed_HostBanknet}
    [Return]    ${Computed_Current}    ${Computed_HostBankGross}    ${Computed_HostBanknet}
    
Compute 'Amounts in Facility Currency' In Initial Drawdown Notebook
    [Documentation]    This keyword computes for the amounts shown in the "Amounts in Facility Currency",
    ...                based from the Loan's Global Currnent, Host Bank Gross and the FX Rate.
    ...                @author: bernchua
    [Arguments]    ${FXRate}    ${Current}    ${HostBankShare}
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    General
    ${FXRate}    Convert To Number    ${FXRate}    
    ${Current}    Remove Comma, Negative Character and Convert to Number    ${Current}
    ${HostBankShare}    Evaluate    ${HostBankShare}/100    
    ${Computed_Current}    Evaluate    ${Current}/${FXRate}
    ${Computed_HostBankGross}    Evaluate    ${Computed_Current}*${HostBankShare}
    ${Computed_HostBanknet}    Evaluate    ${Computed_Current}*${HostBankShare}
    
    ${Computed_Current}    Convert To Number    ${Computed_Current}    2
    ${Computed_HostBankGross}    Convert To Number    ${Computed_HostBankGross}    2
    ${Computed_HostBanknet}    Convert To Number    ${Computed_HostBanknet}    2
    ${Computed_Current}    Convert To String    ${Computed_Current}
    ${Computed_HostBankGross}    Convert To String    ${Computed_HostBankGross}
    ${Computed_HostBanknet}    Convert To String    ${Computed_HostBanknet}
    
    ${Computed_Current}    Convert Number With Comma Separators    ${Computed_Current}
    ${Computed_HostBankGross}    Convert Number With Comma Separators    ${Computed_HostBankGross}
    ${Computed_HostBanknet}    Convert Number With Comma Separators    ${Computed_HostBanknet}
    
    [Return]    ${Computed_Current}    ${Computed_HostBankGross}    ${Computed_HostBanknet}

    
Go To Initial Drawdown GL Entries
    [Documentation]    This keyword goes to the GL Entries from the Initial Drawdown Notebook.
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}    
    mx LoanIQ select    ${LIQ_Drawdown_Queries_GLEntries}    

Exit Initial Drawdown GL Entries Window
    [Documentation]    This keyword exits the GL Entries Window of the Initial Drawdown notebook.
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_GLEntries_Window}
    mx LoanIQ click    ${LIQ_GLEntries_Exit_Button}    
    
Go To Facility From Initial Drawdown Notebook
    [Documentation]    This keyword goes to the Facility Notebook from the Initial Drawdown's menu.
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_Facility}    
    mx LoanIQ activate    ${LIQ_FacilityNotebook_Window}
    
Navigate to Pending Loan
    [Documentation]    This keyword navigates the LIQ User to the Pending Loan Notebook.     
    ...    @author: ritragel
    ...    @update: jdelacru    08MAR2019    - Added activate pending window and select string before double clicking the object
    [Arguments]    ${Outstanding_Type}    ${Loan_FacilityName}    ${Loan_Alias}    
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Pending_RadioButton}    ON 
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Outstanding_Type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Loan_FacilityName}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    mx LoanIQ activate window    ${LIQ_PendingLoanTransactions_Window}
    Mx LoanIQ Select String    ${LIQ_PendingLoanTransactions_JavaTree}    ${Loan_Alias}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingLoanTransactions_JavaTree}    ${Loan_Alias}%d
    mx LoanIQ close window    ${LIQ_PendingLoanTransactions_Window}
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}

Navigate to Active Loan from Outstandings
    [Documentation]    This keyword navigates the LIQ User to the Pending Loan Notebook.     
    ...    @author: clanding    26NOV2020    - initial create
    [Arguments]    ${Outstanding_Type}    ${Loan_FacilityName}    ${Loan_Alias}

    Select Actions    [Actions];
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Pending_RadioButton}    ON 
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Outstanding_Type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Loan_FacilityName}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    mx LoanIQ activate window    ${LIQ_PendingLoanTransactions_Window}
    Mx LoanIQ Select String    ${LIQ_PendingLoanTransactions_JavaTree}    ${Loan_Alias}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingLoanTransactions_JavaTree}    ${Loan_Alias}%d
    mx LoanIQ close window    ${LIQ_PendingLoanTransactions_Window}
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}
 
Input Loan Drawdown Rates for Agency One Deal
    [Documentation]    This keyword is used to input Loan Drawdown Base Rate within the Rates tab on Agency One Deal.
    ...    @author: fmamaril
    [Arguments]    ${Borrower_BaseRate} 
    
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Rates
    mx LoanIQ click    ${LIQ_InitialDrawdown_BaseRate_Button}
      
    :FOR    ${i}    IN RANGE    4
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${status}    Run Keyword And Return Status    Validate Warning Message Box          
    \    Exit For Loop If    ${status}==False     
    
    mx LoanIQ enter    ${LIQ_InitialDrawdown_BorrowerBaseRate_Field}    ${Borrower_BaseRate} 
    mx LoanIQ click    ${LIQ_InitialDrawdown_SetBaseRate_OK_Button}       
 
Set Initial Drawdown Spot FX Rates
    [Documentation]    This keyword sets the FX Rates in the Initial Drawdown Notebook.
    ...                @author: mnanquil
    [Arguments]    ${currencyRate}   
    mx LoanIQ activate    ${LIQ_FXRate_Window}
    mx LoanIQ enter    ${LIQ_Loan_Currency_Textbox}    ${currencyRate}    
    mx LoanIQ click    ${LIQ_FXRate_OK_Button}
    :FOR    ${i}    IN RANGE    3
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    '${status}' == 'True'    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Run Keyword If    '${status}' == 'False'    Exit For Loop

Enter Initial Loan Drawdown Spread Rate
    [Documentation]    This keyword will enter a spread rate on initial loan drawdown rates.
    ...    @author: mnanquil
    ...    Jan-07-2018
    ...    @update: added navigation to rates tab
    [Arguments]    ${spreadRate}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    ${RATES_TAB}
    mx LoanIQ click    ${LIQ_InitialDrawdown_SpreadRate_Button}
    mx LoanIQ enter    ${LIQ_InitialDrawdown_SpreadRate_TextField}    ${spreadRate}
    mx LoanIQ click    ${LIQ_InitialDrawdown_SpreadRate_OKButton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Save Initial Drawdown Notebook
    [Documentation]    This keyword saves the Initial Drawdown notebook transaction.
    ...                @author: bernchua
    mx LoanIQ activate    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ select    ${LIQ_InitialDrawdown_File_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Validate Drawdown GL Entry Debit and Credit Amounts for Single Lender
    [Documentation]    This keyword validates the Debit and Credit amounts in the Initial Drawdown GL Entries window.
    ...                @author: bernchua
    [Arguments]        ${Debit_Amt}    ${Credit_Amt}
    mx LoanIQ activate    ${LIQ_GLEntries_Window}
    Run Keyword If    '${Debit_Amt}'=='${Credit_Amt}'    Log    GL Entries Debit and Credit Amounts are equal and is verifed.
    ...    ELSE    Fail    GL Entries amount not successfully verified.

Set FX Rates Loan Drawdown
    [Documentation]    This keyword set the FX rates of USD Drawdown from workflow before Rate Approval
    ...    @author: jdelacru    26MAR2019    - Initial Keyword
    ...    @update: ritragel    19SEP2019    Update for dynamic keyword
    ...    @update: dahijara    25AUG2020    Added pre processing keyword and screenshot.
    ...    @update: aramos      05OCT2020    Add click warning button. 
    ...    @update: shirhong    06OCT2020    Added condition for Set FX Rate "Use Spot"
    [Arguments]    ${sCurrency}    ${FxRate_Origin}=None
    ### GetRuntime Keyword Pre-processing ###
    ${Currency}    Acquire Argument Value    ${sCurrency}

    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Workflow   
    Mx LoanIQ DoubleClick    ${LIQ_InitialDrawdown_WorkflowAction}    Set F/X Rate
    mx LoanIQ activate window    ${LIQ_FacilityCurrency_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    Run Keyword If    '${FxRate_Origin}' == 'Spot'    mx LoanIQ click    JavaWindow("title:=Facility Currency.*","displayed:=1").JavaButton("attached text:=Use Spot.*to ${sCurrency} Rate")
    ...    ELSE    mx LoanIQ click    JavaWindow("title:=Facility Currency.*","displayed:=1").JavaButton("attached text:=Use Facility.*to ${sCurrency} Rate")
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    mx LoanIQ click    ${LIQ_FacilityCurrency_Facility_Rate_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow

Set FX Rates Loan Repricing
    [Documentation]    This keyword set the FX rates of any currency repricing from workflow before Rate Approval
    ...    @author: xmiranda    27SEP2019    - initial draft
    ...    @update: shirhong    16OCT2020    Added condition for Set FX Rate "Use Spot"
    ...    @update: fluberio    12NOV2020    added click Yes Button if Present
    [Arguments]    ${sCurrency}    ${FxRate_Origin}=None
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Tab}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_WorkFlowAction}    Set F/X Rate
    # mx LoanIQ activate window    ${LIQ_LoanRepricing_Confirmation_Window}
    # mx LoanIQ click    ${LIQ_LoanRepricing_ConfirmationWindow_Yes_Button}
    mx LoanIQ activate window    ${LIQ_FacilityCurrency_Window}
    # mx LoanIQ click    JavaWindow("title:=Facility Currency.*","displayed:=1").JavaButton("attached text:=Use Facility.*to ${sCurrency} Rate")
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FXLoanRepricing_Workflow
    Run Keyword If    '${FxRate_Origin}' == 'Spot'    mx LoanIQ click    JavaWindow("title:=Facility Currency.*","displayed:=1").JavaButton("attached text:=Use Spot.*to ${sCurrency} Rate")
    ...    ELSE    mx LoanIQ click    JavaWindow("title:=Facility Currency.*","displayed:=1").JavaButton("attached text:=Use Facility.*to ${sCurrency} Rate")
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FXLoanRepricing_Workflow
    mx LoanIQ click    ${LIQ_FacilityCurrency_Facility_Rate_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FXLoanRepricing_Workflow

Navigate to Rates Tab
    [Documentation]    This keyword navigates to the Rates tab of the Initial Drawdown Notebook.
    ...                @author: bernchua    25JUL2019    Initial create
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Rates
        
Set Base Rate Details
    [Documentation]    This keyword sets the Base Rate data of the Initial Drawdown Notebook
    ...                @author: bernchua    27JUL2019    Initial create
    ...                @update: bernchua    23AUG2019    Added taking of screenshots
    ...                @update: hstone      05SEP2019    Added Question Window Confirmation
    ...                @update: hstone      18JUN2020    Added Keyword Pre-processing
    ...                @update: mcastro     03SEP2020    Updated screenshot path
    ...                @update: dahijara    04JAN2021    Added optional argument for Accept Rate from Interpolation
    ...                @update: dahijara    04JAN2021    Added condition for clicking Accept Rate from Interpolation
    [Arguments]    ${sBorrowerBaseRate}    ${sAcceptRateFromPricing}=N    ${sAcceptRateFromInterpolation}=N

    ### Keyword Pre-processing ###
    ${BorrowerBaseRate}    Acquire Argument Value    ${sBorrowerBaseRate}
    ${AcceptRateFromPricing}    Acquire Argument Value    ${sAcceptRateFromPricing}
    ${AcceptRateFromInterpolation}    Acquire Argument Value    ${sAcceptRateFromInterpolation}

    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_SetBaseRate_Window}    VerificationData="Yes"
    Run Keyword If    ${STATUS}==False    Run Keywords
    ...    mx LoanIQ click    ${LIQ_InitialDrawdown_BaseRate_Button}
    ...    AND    Verify If Warning Is Displayed
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword If    '${AcceptRateFromPricing}'=='N' and '${AcceptRateFromInterpolation}'=='N'    mx LoanIQ enter    ${LIQ_InitialDrawdown_BorrowerBaseRate_Field}    ${BorrowerBaseRate}
    ...    ELSE IF    '${AcceptRateFromPricing}'=='Y' and '${AcceptRateFromInterpolation}'=='N'    mx LoanIQ click    ${LIQ_InitialDrawdown_AcceptBaseRate}
    ...    ELSE IF    '${AcceptRateFromPricing}'=='N' and '${AcceptRateFromInterpolation}'=='Y'    mx LoanIQ click    ${LIQ_InitialDrawdown_AcceptRateFromInterpolation}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BaseRate-Window
    mx LoanIQ click    ${LIQ_InitialDrawdown_SetBaseRate_OK_Button}
    Verify If Warning Is Displayed

Add Borrower Base Rate and Facility Spread
    [Documentation]    This keyword returns the sum of the Borrower Base Rate and the Facility Spread as the the All-In-Rate in the Initial Drawdown notebook.
    ...                @author: bernchua    08AUG2019    Initial create
    ...                @author: bernchua    22AUG2019    Added line to evaluate and return value with 6 decimal places
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    ...                @update: dahijara    25AUG2020    Inserted validation for all in rate (from test case level.)
    ...                @update: mcastro     07SEP2020    Added condition to handle latest inserted validation
    ...                @update: AmitP       15SEP2020    Added flag variable in a condition which is always true by default for adding condition for Validate String Data In LIQ Object
    [Arguments]    ${sBorrowerBaseRate}    ${sFacitliySpread}    ${flag}=true
    
    ### GetRuntime Keyword Pre-processing ###
    ${BorrowerBaseRate}    Acquire Argument Value    ${sBorrowerBaseRate}
    ${FacitliySpread}    Acquire Argument Value    ${sFacitliySpread}

    ${BorrowerBaseRate}    Convert To Number    ${BorrowerBaseRate}
    ${FacitliySpread}    Convert To Number    ${FacitliySpread}
    ${Loan_AllInRate}    Evaluate    ${BorrowerBaseRate}+${FacitliySpread}
    ${Loan_AllInRate}    Evaluate    "%.6f" % ${Loan_AllInRate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing-Rates
    ${STATUS}    Run Keyword And Return Status    Run Keyword If    '${flag}'=='true'    Mx LoanIQ Verify Object Exist    ${LIQ_InitialDrawdown_Window}    VerificationData="Yes"       
    Run Keyword If    ${STATUS}==False    Validate String Data In LIQ Object    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_AllInRate_Text}    ${Loan_AllInRate}%
    [Return]    ${Loan_AllInRate}

Set Outstanding Servicing Group Details
    [Documentation]    This keyword sets the loan Outstanding Servicing Group Details.
    ...  @author: hstone    04SEP2019    Initial create
    ...  @update: fmamaril    20SEP2019    Added handling for Inquiry mode
    [Arguments]    ${sCustomerName}    ${sRemittanceInstruction}
    # Mx Activate    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ click element if present    ${LIQ_LoanInquire_Button}
    Run keyword and Ignore Error    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_OutstandingServicingGroupDetails}
    Run keyword and Ignore Error    mx LoanIQ select    ${LIQ_Loan_Options_OutstandingServicingGroupDetails}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    mx LoanIQ activate    ${LIQ_ServicingGroupSelectionList_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text     ${LIQ_ServicingGroupSelectionList_Table}    ${sCustomerName}%d  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    mx LoanIQ activate    ${LIQ_OutstandingServicingGroupDetails_Window}
    mx LoanIQ click    ${LIQ_OutstandingServicingGroupDetails_Add_Button}
      
    mx LoanIQ activate window    ${LIQ_PreferredRemittanceInstructions_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_PreferredRemittanceInstructions_Javatree}   ${sRemittanceInstruction}%s
    Mx Native Type    {SPACE}
    mx LoanIQ click    ${LIQ_PreferredRemittanceInstructions_Ok_Button}
    
    mx LoanIQ activate    ${LIQ_OutstandingServicingGroupDetails_Window}
    mx LoanIQ click    ${LIQ_OutstandingServicingGroupDetails_OK_Button}
    
    mx LoanIQ activate    ${LIQ_ServicingGroupSelectionList_Window}
    mx LoanIQ click    ${LIQ_ServicingGroupSelectionList_Exit_Button}
    
Set Spread Details
    [Documentation]    This keyword modifies the spread data of the Initial Drawdown Notebook
    ...                @author: fmamaril    12SEP2019    Initial create
    [Arguments]    ${iSpread}
    mx LoanIQ click    ${LIQ_InitialDrawdown_SpreadRate_Button}
    mx LoanIQ activate window    ${LIQ_OverrideSpread_Window}
    mx LoanIQ enter    ${LIQ_InitialDrawdown_SpreadRate_TextField}    ${iSpread}
    mx LoanIQ click    ${LIQ_InitialDrawdown_SpreadRate_OKButton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Set Loan Servicing Group Details
    [Documentation]    This keyword sets the loan Outstanding Servicing Group Details.
    ...  @author: fmamaril    20SEP2019    Initial create
    [Arguments]    ${sCustomerName}    ${sRemittanceInstruction}
    mx LoanIQ activate    ${LIQ_Loan_Window}
    mx LoanIQ click element if present    ${LIQ_LoanInquire_Button}
    mx LoanIQ select    ${LIQ_Loan_Options_OutstandingServicingGroupDetails}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    mx LoanIQ activate    ${LIQ_ServicingGroupSelectionList_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text     ${LIQ_ServicingGroupSelectionList_Table}    ${sCustomerName}%d  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    mx LoanIQ activate    ${LIQ_OutstandingServicingGroupDetails_Window}
    mx LoanIQ click    ${LIQ_OutstandingServicingGroupDetails_Add_Button}
      
    mx LoanIQ activate window    ${LIQ_PreferredRemittanceInstructions_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_PreferredRemittanceInstructions_Javatree}   ${sRemittanceInstruction}%s
    Mx Native Type    {SPACE}
    mx LoanIQ click    ${LIQ_PreferredRemittanceInstructions_Ok_Button}
    
    mx LoanIQ activate    ${LIQ_OutstandingServicingGroupDetails_Window}
    mx LoanIQ click    ${LIQ_OutstandingServicingGroupDetails_OK_Button}
    
    mx LoanIQ activate    ${LIQ_ServicingGroupSelectionList_Window}
    mx LoanIQ click    ${LIQ_ServicingGroupSelectionList_Exit_Button}

Navigate to Loan Drawdown Workflow and Proceed With Transaction
    [Documentation]    This keyword navigates to the Loan Drawdown Workflow using the desired Transaction
    ...  @author: hstone    29APR2020    Initial create
    ...  @update: hstone    22MAY2020    - Added Take Screenshot
    ...  @update: hstone    26MAY2020    - Added Keyword Pre-processing
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_InitialDrawdown_Window}    ${LIQ_InitialDrawdown_Tab}    ${LIQ_InitialDrawdown_WorkflowAction}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanDradown_Workflow

Navigate to Loan Pending Tab and Proceed with the Transaction
    [Documentation]    This keyword navigates to the Loan Drawdown Pending Tab and Proceeds with the transaction
    ...  @author: hstone    28AMAY2020    Initial create
    ...    @update: amansuet    15JUN2020    - updated take screenshot
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Pending Transaction    ${LIQ_Loan_Window}    ${LIQ_Loan_Tab}    ${LIQ_Loan_PendingTab_JavaTree}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanWindow_PendingTab

Add Items in Flexible Schedule
    [Documentation]    This keyword is used for adding items in Flexible Scheule.
    ...    @author: hstone     01JUN2020      - Initial Create
    ...    @update: hstone     08JUN2020      - Fixed missing Mx on loan iq lib keywords
    ...    @update: hstone     28JUL2020      - Added P&I Amount Input Handling
    ...                                       - Removed '${sRunTimeVar_Date}=None' argument, since there is no return value
    ...                                       - Added Remittance Instruction Selection Handling
    ...                                       - Added Flex Schedule Window Processing Wait
    ...    @udpate: hstone     07AUG2020      - Replaced Single '#' with '###'
    [Arguments]    ${sPay_Thru_Maturity}    ${sItem_Frequency}    ${sItem_type}    ${sConsolidation_Type}    ${sRemittance_Instruction}    ${sItem_Principal_Amount}=None
    ...    ${sItem_NoOFPayments}=None    ${sItem_PandI_Amount}=None
    
    ### Keyword Pre-processing ###
    ${Pay_Thru_Maturity}    Acquire Argument Value    ${sPay_Thru_Maturity}
    ${Item_Frequency}    Acquire Argument Value    ${sItem_Frequency}
    ${Item_type}    Acquire Argument Value    ${sItem_type}
    ${Consolidation_Type}    Acquire Argument Value    ${sConsolidation_Type}
    ${Remittance_Instruction}    Acquire Argument Value    ${sRemittance_Instruction}
    ${Item_Principal_Amount}    Acquire Argument Value    ${sItem_Principal_Amount}
    ${Item_NoOFPayments}    Acquire Argument Value    ${sItem_NoOFPayments}
    ${Item_PandI_Amount}    Acquire Argument Value    ${sItem_PandI_Amount}

    ### Open Add Items Window ###
    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule_Options
    mx LoanIQ click    ${LIQ_FlexibleSchedule_AddItems_Button}
    mx LoanIQ activate window    ${LIQ_FSched_AddItems_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule_AddItems

    ### Pay Thru Maturity Checkbox Tick ###
    Run Keyword If    '${Pay_Thru_Maturity}'=='True'    Mx LoanIQ Set    ${LIQ_FSched_AddItems_PayThruMaturity_CheckBox}    ON
    ...    ELSE    Mx LoanIQ Set    ${LIQ_FSched_AddItems_PayThruMaturity_CheckBox}    OFF
    
    ### Pay Thru Maturity Checkbox Tick Validations ###
    ### Check Visible Objects
    Run Keyword If    '${Pay_Thru_Maturity}'=='True'    Mx LoanIQ Verify Object Exist    ${LIQ_FSched_AddItems_AmortizeThru_Field}    VerificationData="Yes"
    ...    ELSE IF    '${Pay_Thru_Maturity}'=='False'    Mx LoanIQ Verify Object Exist    ${LIQ_FSched_AddItems_NoOFPayments_Field}    VerificationData="Yes"

    ### Check Non-visible Objects
    ${NoOFPayments_Field_State}    Run Keyword And Return Status     Mx LoanIQ Verify Object Exist    ${LIQ_FSched_AddItems_NoOFPayments_Field}    VerificationData="Yes"
    ${AmortizeThru_Field_State}    Run Keyword And Return Status     Mx LoanIQ Verify Object Exist    ${LIQ_FSched_AddItems_AmortizeThru_Field}    VerificationData="Yes"
    Run Keyword If    '${Pay_Thru_Maturity}'=='True' and '${NoOFPayments_Field_State}'=='False'    Log    'No. of Payments Field' field is not visible when 'Pay Thru Maturity' checkbox is ticked.
    ...    ELSE IF    '${Pay_Thru_Maturity}'=='True' and '${NoOFPayments_Field_State}'=='True'    Fail    Log    'No. of Payments Field' is visible when 'Pay Thru Maturity' checkbox is ticked.
    ...    ELSE IF    '${Pay_Thru_Maturity}'=='False' and '${AmortizeThru_Field_State}'=='False'    Log    'Amortize Thru' field is not visible when 'Pay Thru Maturity' checkbox is ticked.
    ...    ELSE IF    '${Pay_Thru_Maturity}'=='False' and '${AmortizeThru_Field_State}'=='True'    Fail    Log    'No. of Payments Field' is visible when 'Pay Thru Maturity' checkbox is ticked.

    ### Populate Dropdown Fields ###
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Frequency_Field}    ${Item_Frequency}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Type_Field}    ${Item_type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_ConsolidationType_List}    ${Consolidation_Type}
    
    ### Populate Principal Amount ###
    Run Keyword If    '${Item_Principal_Amount}'!='None'    Run Keywords   Mx LoanIQ Set    ${LIQ_FSched_AddItems_PrincipalAmount_CheckBox}    ON 
    ...    AND    mx LoanIQ enter    ${LIQ_FSched_AddItems_PrincipaAmount_Field}    ${Item_Principal_Amount}

    ### Populate P&I Amount ###
    Run Keyword If    '${Item_PandI_Amount}'!='None'    Mx LoanIQ Set    ${LIQ_FSched_AddItems_PandIAmount_CheckBox}    ON
    Run Keyword If    '${Item_PandI_Amount}'!='None' and '${Pay_Thru_Maturity}'=='True'    mx LoanIQ enter    ${LIQ_FSched_AddItems_PandIAmount_PayThruMaturity_Field}    ${Item_PandI_Amount}
    ### Comment first until the locator issue is fixed...    ELSE IF    '${Item_PandI_Amount}'!='None' and '${Pay_Thru_Maturity}'=='False'    mx LoanIQ enter    ${LIQ_FSched_AddItems_PandIAmount_Field}    ${Item_PandI_Amount}
   
    ### Populate No. Of Payments ###
    Run Keyword If    '${Item_NoOFPayments}'!='None'    mx LoanIQ enter    ${LIQ_FSched_AddItems_NoOFPayments_Field}    ${Item_NoOFPayments}

    ### Choose Borrower Remittance Instruction ###
    mx LoanIQ click    ${LIQ_FSched_AddItems_BorrowRemittanceInstruction_Button}
    mx LoanIQ activate window    ${LIQ_FSched_ChooseRI_Window}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_FSched_ChooseRI_JavaTree}    ***${Remittance_Instruction}%Yes
    Run Keyword If    '${status}'=='True'    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FSched_ChooseRI_JavaTree}    ***${Remittance_Instruction}%s
    ...    ELSE    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FSched_ChooseRI_JavaTree}    ${Remittance_Instruction}%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule_ChooseRI
    mx LoanIQ click    ${LIQ_FSched_ChooseRI_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule_AddItems

    ### Finish Adding Items in Flexible Schedule Window ###
    mx LoanIQ click    ${LIQ_FSched_AddItems_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click    ${LIQ_FlexibleSchedule_OK_Button}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Create Temporary Payment Plan on Repayment Schedule
    [Documentation]    This keyword is used for creating temporary payment plan on repayment schedule window.
    ...    @author: hstone     01JUN2020      - Initial Create
        ### Create Temporary Payment Plan ###
    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_CreateTemporaryPaymentPlan}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_No_Button}

    ### Save Tempoaray Payment Plan ###
    mx LoanIQ activate window    ${LIQ_TemporaryRepaymentSchedule_Window}
    mx LoanIQ click    ${LIQ_TemporaryRepaymentSchedule_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TemporaryRepaymentSchedule

    ### Exit Temporary Payment Plan ###
    mx LoanIQ click    ${LIQ_TemporaryRepaymentSchedule_Exit_Button}

Navigate to View/Update Lender Share via Loan Drawdown Notebook
    [Documentation]    This keyword is for navigating Lender Shares Window via Loan Drawdown Notebook
    ...    @author: hstone    17JUN2020    - Initial Create
    
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_ViewOrUpdateLenderShares}
    mx LoanIQ activate window    ${LIQ_SharesFor_Window} 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_SharesFor_Window}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ViewOrUpdateLenderShares
    
Create Flex Reschedule
    [Documentation]    This keyword is used for doing a Reschedule with flex repayment.
    ...    @author:    sahalder    27JUL2020    initial create
    mx LoanIQ activate window    ${LIQ_Loan_Window}

    ${InquiryMode_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${InquiryMode_Status}==True    mx LoanIQ click    ${LIQ_Loan_InquiryMode_Button}
    ...    ELSE    Run Keyword    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_UpdateMode_Button}    VerificationData="Yes"

    mx LoanIQ select    ${LIQ_Loan_Options_RepaymentSchedule}
    :FOR    ${i}    IN RANGE    4
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False 
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Reschedule}
    :FOR    ${i}    IN RANGE    4
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_ChooseScheduleType_Window}
    Mx LoanIQ Set    ${LIQ_RepaymentSchedule_ScheduleType_FlexSchedule_RadioButton}    ON
    mx LoanIQ click    ${LIQ_RepaymentSchedule_ScheduleType_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}

Add Items in Flexible Reschedule Add Window
    [Documentation]    This keyword is used for adding items in Flexible Rescheule Add window.
    ...    @author:    sahalder     27JUN2020      - Initial Create
    [Arguments]    ${sPay_Thru_Maturity}    ${sItem_Frequency}    ${sItem_type}    ${sConsolidation_Type}    ${sItem_Nominal_Amount}    ${sItem_NoOFPayments}
    
    ### Keyword Pre-processing ###
    ${Pay_Thru_Maturity}    Acquire Argument Value    ${sPay_Thru_Maturity}
    ${Item_Frequency}    Acquire Argument Value    ${sItem_Frequency}
    ${Item_type}    Acquire Argument Value    ${sItem_type}
    ${Consolidation_Type}    Acquire Argument Value    ${sConsolidation_Type}
    ${Item_Nominal_Amount}    Acquire Argument Value    ${sItem_Nominal_Amount}
    ${Item_NoOFPayments}    Acquire Argument Value    ${sItem_NoOFPayments}

    ### Open Add Items Window ###
    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule_Options
    mx LoanIQ click    ${LIQ_FlexibleSchedule_AddItems_Button}
    mx LoanIQ activate window    ${LIQ_FSched_AddItems_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule_AddItems

    ### Pay Thru Maturity Checkbox Tick ###
    Run Keyword If    '${Pay_Thru_Maturity}'=='True'    Mx LoanIQ Set    ${LIQ_FSched_AddItems_PayThruMaturity_CheckBox}    ON
    ...    ELSE    Mx LoanIQ Set    ${LIQ_FSched_AddItems_PayThruMaturity_CheckBox}    OFF
    
    
    ### Populate Dropdown Fields ###
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Frequency_Field}    ${Item_Frequency}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Type_Field}    ${Item_type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_ConsolidationType_List}    ${Consolidation_Type}
    
    ### Populate No. Of Payments ###
    Run Keyword If    '${Item_NoOFPayments}'!='None'    mx LoanIQ enter    ${LIQ_FSched_AddItems_NoOFPayments_Field}    ${Item_NoOFPayments}
    
    mx LoanIQ enter    ${LIQ_FSched_AddItems_NominalAmount_Field}    ${Item_Nominal_Amount}   
   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule_AddItems

    ### Finish Adding Items in Flexible Schedule Window ###
    mx LoanIQ click    ${LIQ_FSched_AddItems_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    :FOR    ${i}    IN RANGE    4
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False 
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click    ${LIQ_FlexibleSchedule_OK_Button}
    mx LoanIQ activate window    ${LIQ_Confirmation_Window}
    mx LoanIQ click element if present    ${LIQ_Confirmation_Yes_Button}
    :FOR    ${i}    IN RANGE    4
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    
   
Create Temporary Payment Plan After Reschedule
    [Documentation]    This keyword is used for creating temporary payment plan on repayment schedule window after reschedule.
    ...    @author:    sahalder    27JUL2020    Initial Create
 
    ### Create Temporary Payment Plan ###
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_CreateTemporaryPaymentPlan}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ###Save Tempoaray Payment Plan###
    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}
    mx LoanIQ click    ${LIQ_FlexibleSchedule_OK_Button}
    mx LoanIQ activate window    ${LIQ_TemporaryRepaymentSchedule_Window}
    mx LoanIQ click    ${LIQ_TemporaryRepaymentSchedule_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TemporaryRepaymentSchedule

Become Legal Payment Plan on Temporary Payment Plan
    [Documentation]    This keyword is used for becoming the legal payment plan on repayment schedule window after flex reschedule.
    ...    @author:    sahalder    27JUL2020    Initial Create
    
    ### Create Temporary Payment Plan ###
    mx LoanIQ activate window    ${LIQ_TemporaryRepaymentSchedule_Window}
    mx LoanIQ select    ${LIQ_TemporaryRepaymentSchedule_Options_BecomeLegalPaymentPlan}
    :FOR    ${i}    IN RANGE    3
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False 
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    ${Window_Title_Verify}    Mx LoanIQ Get Data    ${LIQ_RepaymentSchedule_Window}    title
    Log To Console    Current Window title:${Window_Title_Verify}

Save And Exit Repayment Schedule Window
    [Documentation]    This keyword is used to save and exit from the repayment schedule window after flex reschedule.
    ...    @author:    sahalder    27JUL2020    Initial Create
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TemporaryRepaymentSchedule

    ### Exit Repayment Schedule Plan ###
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Exit_Button}
    
Add MIS Code in Loan Drawdown
    [Documentation]    This keyword is used to add MIS Codes in Loan Drawdown Notebook
    ...    @author: jloretiz    29JUL2019    - initial create
    [Arguments]    ${sMIS_Code}    ${sValue}

    ${MIS_Code}    Acquire Argument Value    ${sMIS_Code}
    ${Value}    Acquire Argument Value    ${sValue}

    ###Navigate to MIS Code Tables###
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Codes
    mx LoanIQ click    ${LIQ_InitialDrawdown_MISCodes_Add_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BeforeAddMISCode

    ###Return If All Avalaible MIS Codes Types are Defined###
    ${IsExist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_InitialDrawdown_MISCodeDetails_Window}    VerificationData="Yes"
    Return From Keyword If    '${IsExist}'=='${FALSE}'

    ### Input MIS Details ###
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_MISCodeDetails_Window}
    mx LoanIQ select list    ${LIQ_InitialDrawdown_MISCode_List}    ${MIS_Code}   
    ${Result}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_InitialDrawdown_Value_Field}    MIS_Value%${Value}
    Run Keyword If    '${Result}'=='${TRUE}'    Log    MIS Value Field Verified
    mx LoanIQ click    ${LIQ_InitialDrawdown_OK_Button}
    
    ### Verify MIS Value Acquired ###
    ${MIS_Value}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_InitialDrawdown_MISCodes_JavaTree}    ${MIS_Code}%Value%value  
    ${Result}    Run Keyword And Return Status    Should Be Equal As Strings    ${MIS_Value}    ${Value}
    Run Keyword If    '${Result}'=='${TRUE}'    Log    MIS Code Value is Verified   level=INFO
    ...    ELSE    Log    MIS Code Value is ${MIS_Value} instead of ${Value}    level=ERROR
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AfterMISCode    

Convert Loan Requested Amount Based On Currency FX Rate
    [Documentation]    This keyword is used to Convert Loan Requested Amount Based On Currency FX Rate
    ...    @author: dahijara    26AUG2019    - initial create
    [Arguments]    ${sFacilityCurrency}    ${sLoanCurrency}    ${sLoanRequested_Amount}    ${sLoanAlias}    ${sOutstanding_Type}    ${sFacility_Name}    ${sLoanCreationDate}    ${sRunVar_CovertedLoanRequested_Amount}=None

    ${FacilityCurrency}    Acquire Argument Value    ${sFacilityCurrency}
    ${LoanCurrency}    Acquire Argument Value    ${sLoanCurrency}
    ${LoanRequested_Amount}    Acquire Argument Value    ${sLoanRequested_Amount}
    ${LoanAlias}    Acquire Argument Value    ${sLoanAlias}
    ${Outstanding_Type}    Acquire Argument Value    ${sOutstanding_Type}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${LoanCreationDate}    Acquire Argument Value    ${sLoanCreationDate}

    ${isMatched}    Run Keyword And Return Status    Should Be Equal As Strings    ${FacilityCurrency}    ${LoanCurrency}

    ${FXRate}    Run Keyword If    '${isMatched}'=='${FALSE}'    Get Loan FX Rate    ${LoanAlias}    ${Outstanding_Type}    ${Facility_Name}    ${LoanCreationDate}
    ${LoanRequested_Amount}    Run Keyword If    '${isMatched}'=='${FALSE}'    Remove Comma and Convert to Number    ${LoanRequested_Amount}
    ${CovertedLoanRequested_Amount}    Run Keyword If    '${isMatched}'=='${FALSE}'    Evaluate    ${LoanRequested_Amount}/${FXRate}
    ...    ELSE    Set Variable    ${LoanRequested_Amount}
    ${CovertedLoanRequested_Amount}    Remove Comma and Convert to Number    ${CovertedLoanRequested_Amount}
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_CovertedLoanRequested_Amount}    ${CovertedLoanRequested_Amount}
    [Return]    ${CovertedLoanRequested_Amount}

Get Loan FX Rate 
    [Documentation]    This keyword is used to Get Loan FX Rate in Loan notebook.
    ...    @author: dahijara    26AUG2019    - initial create
    [Arguments]    ${sLoanAlias}    ${sOutstanding_Type}    ${sFacility_Name}    ${sLoanCreationDate}    ${sRunVar_FXRate}=None

    ${LoanAlias}    Acquire Argument Value    ${sLoanAlias}
    ${Outstanding_Type}    Acquire Argument Value    ${sOutstanding_Type}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${LoanCreationDate}    Acquire Argument Value    ${sLoanCreationDate}

    Navigate to Outstanding Select Window
    Navigate to Existing Loan    ${Outstanding_Type}    ${Facility_Name}    ${LoanAlias}
    Mx LoanIQ Activate Window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    ${CURRENCY_TAB}
    Mx LoanIQ click Element If Present    ${LIQ_Loan_InquiryMode_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_Currency
    Mx LoanIQ Click    ${LIQ_Loan_History_Button}
    Mx LoanIQ Activate Window    ${LIQ_Loan_Currency_RateHistory_Window}
    ${FXRate}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Loan_Currency_RateHistory_Table}    ${LoanCreationDate}%Rate%var    Processtimeout=180
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_RateHistory    
    Mx LoanIQ Click    ${LIQ_Loan_Currency_RateHistory_OK_Button}
    Mx LoanIQ close window    ${LIQ_Loan_Window}
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_FXRate}    ${FXRate}
    [Return]    ${FXRate}
    
Get Loan Cycle Due Amount
    [Documentation]    This keyword returns the Fee total paid to date amount.
    ...    @author: cfrancis    09OCT2020    - Initial Create

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ${rowcount}    Mx LoanIQ Get Data    ${LIQ_Loan_AccrualTab_Cycles_Table}    input=items count%value
    ${rowcount}    Evaluate    ${rowcount} - 2
    Log    The total rowcount is ${rowcount}
    ${CycleDueAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    TOTAL:${SPACE}%Cycle Due%amount
    Log    The Fee Paid to Date amount is ${CycleDueAmount}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_Cycle_Due
    [Return]    ${CycleDueAmount}

Get Loan Paid to Date Amount
    [Documentation]    This keyword returns the Fee total paid to date amount.
    ...    @author: cfrancis    09OCT2020    - Initial Create

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ${rowcount}    Mx LoanIQ Get Data    ${LIQ_Loan_AccrualTab_Cycles_Table}    input=items count%value
    ${rowcount}    Evaluate    ${rowcount} - 2
    Log    The total rowcount is ${rowcount}
    ${PaidtodateAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${rowcount}%Paid to date%amount  
    Log    The Fee Paid to Date amount is ${PaidtodateAmount}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_Paid_To_Date
    [Return]    ${PaidtodateAmount}

Validate and Delete if Repayment Schedule Exists in the Loan
    [Documentation]    This keyword Validates if Repayment schedule exists when navigating to Principal Payment from Loan Notebook.
    ...    and deletes  the existing repayment schedule if there is.
    ...    @author: dahijara    27OCT2020    - Initial Create

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_PrincipalPayment
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Error_Window}    VerificationData="Yes"    Processtimeout=100
    ${Err_Msg}    Run Keyword If    ${Err_exist}==${True}    Mx LoanIQ Get Data    ${LIQ_Error_MessageBox}    text%data
    ${IsMatched}    Run Keyword And Return Status    Should Contain    ${Err_Msg}    repayment schedule exists
    Run Keyword If    ${Err_exist}==${True} and ${IsMatched}==${True}    Run Keywords    Mx LoanIQ Click    ${LIQ_Error_OK_Button}
    ...    AND    Mx LoanIQ activate window    ${LIQ_Loan_ChoosePayment_Window}
    ...    AND    Mx LoanIQ click    ${LIQ_Loan_ChoosePayment_Cancel_Button}
    ...    AND    Delete Repayment Schedule in the Loan
    ...    ELSE IF    ${Err_exist}==${False} or ${IsMatched}==${False}    Log    Repayment Schedule does not exist

Delete Repayment Schedule in the Loan
    [Documentation]    This keyword deletes Repayment schedule from Loan Notebook.
    ...    @author: dahijara    27OCT2020    - Initial Create

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ click element if present    ${LIQ_Loan_InquiryMode_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook
    mx LoanIQ select    ${LIQ_Loan_Options_RepaymentSchedule}
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_DeleteSchedule}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_RepaymentSchedule
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Click Element If Present     ${LIQ_Warning_Yes_Button}
    :FOR    ${i}    IN RANGE    3
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_RepaymentSchedule

Complete Set FX Rate
    [Documentation]    This keyword completes the FX Rates in the Initial Drawdown Notebook.
    ...    @author: mcastro    16NOV2020    - Initial Create  

    mx LoanIQ activate    ${LIQ_FXRate_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FxRate_Window
    mx LoanIQ click    ${LIQ_FXRate_UserSpotRate_Button}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FxRate_Window 
    mx LoanIQ click    ${LIQ_FXRate_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FxRate_Window
    Validate if Question or Warning Message is Displayed    
    
Get Cashflow Details from Released Initial Loan Drawdown
    [Documentation]    This keyword is used to get the cashflow ID and write the value in the dataset
    ...    @author: shirhong    04DEC2020    - initial create
    ...    @update: clanding    08DEC2020    - added manually clicking Comments tab when it is highlighted
    [Arguments]    ${sBorrower_ShortName}
    
    ${Borrower_Shortname}    Acquire Argument Value    ${sBorrower_ShortName}

    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Loan_Events_List}    Released%d
    
    ###Open Cashflow Details From Released Initial Loan Drawdown###
    Open Cashflows Window from Notebook Menu    ${LIQ_InitialDrawdown_Released_Status_Window}    ${LIQ_InitialDrawdown_Options_Cashflow}
    mx LoanIQ activate window    ${LIQ_Cashflows_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialLoanDrawdown_CashflowWindow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${Borrower_Shortname}%d
    mx LoanIQ activate window    ${LIQ_Cashflows_DetailsForCashflow_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowDetails
    mx LoanIQ send keys    {F8}
    
    ###Get the Actual Cashflow ID and Return to Loan###
    mx LoanIQ activate window    ${LIQ_UpdateInformation_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflow_UpdateDetails
    mx LoanIQ click    ${LIQ_Cashflows_UpdateInformation_CopyRID_Button}
    mx LoanIQ click    ${LIQ_UpdateInformation_Exit_Button}
    mx LoanIQ click    ${LIQ_Payment_Cashflows_DetailsforCashflow_Exit_Button}
    mx LoanIQ close window    ${LIQ_Cashflows_Window}
    mx LoanIQ close window    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ activate window    ${LIQ_Loan_Window}
       
    ###Set The Cashflow ID in Variable and Write To Report Validation Sheet###
    ### Tabs with highlight does not return any text and method is not working ###
    ${IsClicked}    Run Keyword And Return Status    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Comments
    Run Keyword If    ${IsClicked}==${False}    Pause Execution    Manually click Comments tab then click OK.     ### Raised TACOE-1193/GDE-9343 for the issue
    mx LoanIQ click    ${LIQ_LoanNotebook_CommentsTab_Add_Button}
    mx LoanIQ enter    ${LIQ_CommentsEdit_Comment_Textfield}    /
    mx LoanIQ send keys    ^{V}
    ${CashflowID}    Mx LoanIQ Get Data    ${LIQ_CommentsEdit_Comment_Textfield}    value%rid
    mx LoanIQ close window    ${LIQ_CommentsEdit_Window}    
    ${CashflowID}    Remove String    ${CashflowID}    /
    ${CashflowID}    Strip String    ${CashflowID}    mode=both
    Log To Console    ${CashflowID}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflow_ID
    [Return]    ${CashflowID}
    
Get Cashflow Details Before Sending to Approval in Initial Loan Drawdown
    [Documentation]    This keyword is used to get the cashflow ID and write the value in the dataset
    ...    NOTE: Create Cashflow is the Pre requisite of thie Keyword
    ...    @author: fluberio    10DEC2020    - initial create
    [Arguments]    ${sBorrower_ShortName}
    
    ${Borrower_Shortname}    Acquire Argument Value    ${sBorrower_ShortName}
    
    ###Open Cashflow Details From Released Initial Loan Drawdown###
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialLoanDrawdown_CashflowWindow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Cashflows_Tree}    ${Borrower_Shortname}%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CashflowDetails
    mx LoanIQ send keys    {F8}
    
    ###Get the Actual Cashflow ID and Return to Loan###
    mx LoanIQ activate window    ${LIQ_UpdateInformation_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflow_UpdateDetails
    mx LoanIQ click    ${LIQ_Cashflows_UpdateInformation_CopyRID_Button}
    mx LoanIQ click    ${LIQ_UpdateInformation_Exit_Button}
    mx LoanIQ click    ${LIQ_Cashflows_DetailsForCashflow_OK_Button}
    mx LoanIQ close window    ${LIQ_Cashflows_Window}
    mx LoanIQ activate window    ${LIQ_Loan_Window}
       
    ###Set The Cashflow ID in Variable and Write To Report Validation Sheet###
    Mx LoanIQ Select Window Tab    ${LIQ_InitialDrawdown_Tab}    Comments
    mx LoanIQ click    ${LIQ_InitialDrawdown_Comment_AddButton}
    mx LoanIQ enter    ${LIQ_CommentsEdit_Comment_Textfield}    /
    mx LoanIQ send keys    ^{V}
    ${CashflowID}    Mx LoanIQ Get Data    ${LIQ_CommentsEdit_Comment_Textfield}    value%rid
    mx LoanIQ close window    ${LIQ_CommentsEdit_Window}    
    ${CashflowID}    Remove String    ${CashflowID}    /
    ${CashflowID}    Strip String    ${CashflowID}    mode=both
    Log To Console    ${CashflowID}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Cashflow_ID
    [Return]    ${CashflowID}

Validate Loan Drawdown Amounts in General Tab
    [Documentation]    This keyword validates the loan drawdown amounts in General Tab.
    ...    @author: dahijara    16DEC2020    - Initial create
    ...    @update: javinzon    18DEC2020    - Updated keyword name from 'Validate Loan Drawdown Amounts for CH EDU Bilateral Deal' 
    ...                                        to 'Validate Loan Drawdown Amounts in General Tab', updated documentation
    [Arguments]    ${sOrig_LoanGlobalOriginal}    ${sOrig_LoanGlobalCurrent}    ${sOrig_LoanHostBankGross}    ${sOrig_LoanHostBankNet}

    ### GetRuntime Keyword Pre-processing ###
    ${Orig_LoanGlobalOriginal}    Acquire Argument Value    ${sOrig_LoanGlobalOriginal}
    ${Orig_LoanGlobalCurrent}    Acquire Argument Value    ${sOrig_LoanGlobalCurrent}
    ${Orig_LoanHostBankGross}    Acquire Argument Value    ${sOrig_LoanHostBankGross}
    ${Orig_LoanHostBankNet}    Acquire Argument Value    ${sOrig_LoanHostBankNet}
	
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ click element if present    ${LIQ_Loan_UpdateMode_Button}      
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanWindow

    ### Global Original Amount ###
    ${New_LoanGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Amount}    value%Amount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${New_LoanGlobalOriginal}    ${Orig_LoanGlobalOriginal}
    Run Keyword If    ${Status}==${True}    Log    Loan Global Original Amount is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Global Original Amount is incorrect. Expected: ${Orig_LoanGlobalOriginal} - Actual: ${New_LoanGlobalOriginal}

    ### Global Current Amount ###
    ${New_LoanGlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Amount}    value%Amount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${New_LoanGlobalCurrent}    ${Orig_LoanGlobalCurrent}
    Run Keyword If    ${Status}==${True}    Log    Loan Global Current Amount is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Global Current Amount is incorrect. Expected: ${Orig_LoanGlobalCurrent} - Actual: ${New_LoanGlobalCurrent}
    
    ### Host Bank Gross Amount ###
    ${New_LoanHostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Amount}    value%Amount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${New_LoanHostBankGross}    ${Orig_LoanHostBankGross}
    Run Keyword If    ${Status}==${True}    Log    Loan Host Bank Gross Amount is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Expected Loan Host Bank Gross Amount is incorrect. Expected: ${Orig_LoanHostBankGross} - Actual: ${New_LoanHostBankGross}
    
    ### Host Bank Net Amount ###
    ${New_LoanHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Amount}    value%Amount
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${New_LoanHostBankNet}    ${Orig_LoanHostBankNet}          
    Run Keyword If    ${Status}==${True}    Log    Loan Host Bank Net Amount is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Host Bank Net Amount is incorrect. Expected: ${Orig_LoanHostBankNet} - Actual: ${New_LoanHostBankNet}

Validate Loan Drawdown Rates in Rates Tab
    [Documentation]    This keyword validates the loan drawdown rates in Rates Tab.
    ...    @author: dahijara    16DEC2020    - Initial create
    ...    @update: javinzon    18DEC2020    - Updated keyword name from 'Validate Loan Drawdown Rates for CH EDU Bilateral Deal' to
    ...                                        'Validate Loan Drawdown Rates in Rates Tab', updated documentation
    [Arguments]    ${sLoan_BaseRate}    ${sLoan_Spread}    ${sLoan_AllInRate}    

    ### GetRuntime Keyword Pre-processing ###
    ${Loan_BaseRate}    Acquire Argument Value    ${sLoan_BaseRate}
    ${Loan_Spread}    Acquire Argument Value    ${sLoan_Spread}
    ${Loan_AllInRate}    Acquire Argument Value    ${sLoan_AllInRate}
	
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ click element if present    ${LIQ_Loan_UpdateMode_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Rates
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanWindow

    ### Base Rate ###
    ${UI_LoanCurrentBaseRate}    Mx LoanIQ Get Data    ${LIQ_Loan_CurrentBaseRate}    value%data
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${UI_LoanCurrentBaseRate}    ${Loan_BaseRate}
    Run Keyword If    ${Status}==${True}    Log    Loan Base Rate is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Base Rate is incorrect. Expected: ${Loan_BaseRate} - Actual: ${UI_LoanCurrentBaseRate}

    ### Spread ###
    ${UI_LoanCurrentSpread}    Mx LoanIQ Get Data    ${LIQ_Loan_Spread}    value%data
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${UI_LoanCurrentSpread}    ${Loan_Spread}
    Run Keyword If    ${Status}==${True}    Log    Loan Spread is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Spread is incorrect. Expected: ${Loan_Spread} - Actual: ${UI_LoanCurrentSpread}

    ### All In Rate ###
    ${UI_LoanAllInRate}    Mx LoanIQ Get Data    ${LIQ_Loan_AllInRate}    value%data
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${UI_LoanAllInRate}    ${Loan_AllInRate}
    Run Keyword If    ${Status}==${True}    Log    Loan All-In-Rate is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan All-In-Rate is incorrect. Expected: ${Loan_AllInRate} - Actual: ${UI_LoanAllInRate}
    
Validate Loan Drawdown General Details in General Tab
    [Documentation]    This keyword validates the loan drawdown general details in General Tab.
    ...    @author: dahijara    16DEC2020    - Initial create
    ...    @update: javinzon    18DEC2020    - Updated keyword name from 'Validate Loan Drawdown General Details for CH EDU Bilateral Deal' to
    ...                                        'Validate Loan Drawdown General Details for CH EDU Bilateral Deal' and documentation
    [Arguments]    ${sLoan_PricingOption}    ${sLoan_EffectiveDate}    ${sLoan_RepricingFrequency}    ${sLoan_RepricingDate}    ${sLoan_PaymentMode}    ${sLoan_IntCycleFrequency}

    ### GetRuntime Keyword Pre-processing ###
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
    ${Loan_EffectiveDate}    Acquire Argument Value    ${sLoan_EffectiveDate}
    ${Loan_RepricingFrequency}    Acquire Argument Value    ${sLoan_RepricingFrequency}
    ${Loan_RepricingDate}    Acquire Argument Value    ${sLoan_RepricingDate}
    ${Loan_PaymentMode}    Acquire Argument Value    ${sLoan_PaymentMode}
    ${Loan_IntCycleFrequency}    Acquire Argument Value    ${sLoan_IntCycleFrequency}
	
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ click element if present    ${LIQ_Loan_UpdateMode_Button}      
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanWindow

    ### Pricing Option ###
    ${UI_PricingOption}    Mx LoanIQ Get Data    ${LIQ_Loan_PricingOption_Label}    text%data
    ${Status}    Run Keyword And Return Status    Should Contain    ${Loan_PricingOption}    ${UI_PricingOption}
    Run Keyword If    ${Status}==${True}    Log    Loan Pricing Option is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Pricing Option is incorrect. Expected: ${Loan_PricingOption} - Actual: ${UI_PricingOption}

    ### Effective Date ###
    ${UI_EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_Loan_EffectiveDate_Label}    text%data
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${UI_EffectiveDate}    ${Loan_EffectiveDate}
    Run Keyword If    ${Status}==${True}    Log    Loan Effective Date is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Effective Date is incorrect. Expected: ${Loan_EffectiveDate} - Actual: ${UI_EffectiveDate}

    ### Repricing Frequency ###
    ${UI_RepricingFrequency}    Mx LoanIQ Get Data    ${LIQ_Loan_RepricingFrequency_List}    value%data
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${UI_RepricingFrequency}    ${Loan_RepricingFrequency}
    Run Keyword If    ${Status}==${True}    Log    Loan Repricing Frequency is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Repricing Frequency is incorrect. Expected: ${Loan_RepricingFrequency} - Actual: ${UI_RepricingFrequency}

    ### Repricing Date ###
    ${UI_RepricingDate}    Mx LoanIQ Get Data    ${LIQ_Loan_RepricingDate_Label}    text%data
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${UI_RepricingDate}    ${Loan_RepricingDate}
    Run Keyword If    ${Status}==${True}    Log    Loan Repricing Date is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Repricing Date is incorrect. Expected: ${Loan_RepricingDate} - Actual: ${UI_RepricingDate}

    ### Payment Mode ###
    ${UI_PaymentMode}    Mx LoanIQ Get Data    ${LIQ_Loan_PaymentMode_List}    value%data
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${UI_PaymentMode}    ${Loan_PaymentMode}
    Run Keyword If    ${Status}==${True}    Log    Loan Payment Mode is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Payment Mode is incorrect. Expected: ${Loan_PaymentMode} - Actual: ${UI_PaymentMode}

    ### Int Cycle Frequency ###
    ${UI_IntCycleFrequency}    Mx LoanIQ Get Data    ${LIQ_Loan_IntCycleFreq_Dropdownlist}    value%data
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${UI_IntCycleFrequency}    ${Loan_IntCycleFrequency}
    Run Keyword If    ${Status}==${True}    Log    Loan Int Cycle Frequency is correct.
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Loan Int Cycle Frequency is incorrect. Expected: ${Loan_IntCycleFrequency} - Actual: ${UI_IntCycleFrequency}
