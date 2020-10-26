*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Open Existing Inactive Loan from a Facility
    [Documentation]    This keyword opens an existing inactive loan on Existing Loan for Facility window.
    ...    @author: ghabal
    ...    @update: dfajardo 22JUL2020    -added pre process and screenshot
    [Arguments]    ${sLoan_Alias}

    ### GetRuntime Keyword Pre-processing ###
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}        

    mx LoanIQ activate    ${LIQ_ExistingLoanForFacility_Window}
    mx LoanIQ enter    ${LIQ_ExistingLoanForFacility_Update_Checkbox}    ON
    mx LoanIQ enter    ${LIQ_ExistingLoanForFacility_RemainOpen_Checkbox }    OFF
    Mx LoanIQ DoubleClick    ${LIQ_ExistingLoanForFacility_Tree}    ${Loan_Alias}
    mx LoanIQ activate window    ${LIQ_InactiveLoan_Window}
    Verify Window    ${LIQ_InactiveLoan_Window}
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_ExistingLoansForFacilityWindow
    
Verify Global Current Amount
    [Documentation]    This keyword is used to verify the Global Current Amount of an Inactive Loan under General tab
   ...    @author: ghabal
   ...    @update: dfajardo    22JUL2020    - Added Screenshot
    Mx LoanIQ Select Window Tab    ${LIQ_InactiveLoan_Tab}    General
    ${DisplayedGlobalCurrentAmount}    Mx LoanIQ Get Data    ${LIQ_InactiveLoan_GlobalCurrent}    testdata
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${DisplayedGlobalCurrentAmount}    0.00        
    ${result}    Run Keyword And Return Status    Should Be Equal As Numbers    ${DisplayedGlobalCurrentAmount}    0.00
    Run Keyword If   '${result}'=='True'    Log    "Global Current Amount is confirmed zero amount"    
    ...     ELSE    Log    "Termination Halted. Global Current Amount is not in zero amount"
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_InactiveLoan

Verify Cycle Due Amount 
    [Documentation]    This keyword is used to verify the Cycle Due Amount of an Inactive Loan under Accrual tab
    ...    @author: ghabal
    ...    @update: dfajardo: added pre processing and screenshot
    [Arguments]    ${sPayment_NumberOfCycles}  
    
    ### GetRuntime Keyword Pre-processing ###
    ${Payment_NumberOfCycles}    Acquire Argument Value    ${sPayment_NumberOfCycles}
      
    Mx LoanIQ Select Window Tab    ${LIQ_InactiveLoan_Tab}    Accrual
    ${CycleDueAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_InactiveLoan_CycleDueAmount}    ${Payment_NumberOfCycles}%Cycle Due%CycleDueAmount   
    Log    ${CycleDueAmount}
    ${result}    Run Keyword And Return Status    Should Be Equal As Strings    0.00    ${CycleDueAmount}    
    Run Keyword If   '${result}'=='True'    Log    "No pending payment for the loan is available"
    ...     ELSE    Log    "Termination Halted. Cycle Due Amount is not in zero amount" 
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_InactiveLoan

Navigate to Repayment Schedule from Loan Notebook
    [Documentation]    This keyword navigates the LIQ User to the Repayment Schedule window from Loan window.
    ...    @author: rtarayao
    ...    @update: hstone      01JUN2020     - Removed Extra Spaces
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${InquiryMode_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${InquiryMode_Status}==True    mx LoanIQ click    ${LIQ_Loan_InquiryMode_Button}
    ...    ELSE    Run Keyword    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_UpdateMode_Button}    VerificationData="Yes"
    mx LoanIQ select    ${LIQ_Loan_Options_RepaymentSchedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    
Check Loan Status If Inactive
    [Documentation]    This keyword is used to check if loan status is inactive
    ...    @author: ghabal
    ...    @update: dfajardo    22JUL2020    - Added Screenshot
    Run Keyword And Continue On Failure    mx LoanIQ activate window    ${LIQ_InactiveLoan_Window}
    ${result}    Run Keyword And Return Status    mx LoanIQ activate window    ${LIQ_InactiveLoan_Window}
    Run Keyword If   '${result}'=='True'    Log    "Loan Notebook is confirmed in 'Inactive' status"
    ...     ELSE    Log    "Loan Notebook is NOT in 'Inactive' status. Termination Halted. Please check your Loan."
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook_InactiveLoan
    mx LoanIQ close window    ${LIQ_InactiveLoan_Window}

Validate Updated Loan Amount After Payment - Capitalized Ongoing Fee
    [Documentation]    This keyword validates the current loan amount after payment of the capitalized ongoing fee.
    ...    @author: rtarayao 
    [Arguments]    ${Orig_LoanGlobalOriginal}    ${Orig_LoanGlobalCurrent}    ${Orig_LoanHostBankGross}    ${Orig_LoanHostBankNet}    ${Capitalization_PctofPayment}    ${HBSharePercentage}    ${CycleDue}
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ click element if present    ${LIQ_Loan_UpdateMode_Button}      
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General    
    
    ${New_LoanGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Amount}    value%Amount 
    ${New_LoanGlobalOriginal}    Remove String    ${New_LoanGlobalOriginal}     ,
    ${New_LoanGlobalOriginal}    Convert To Number    ${New_LoanGlobalOriginal}    2
    
    Should Be Equal    ${New_LoanGlobalOriginal}    ${Orig_LoanGlobalOriginal} 
    Log    There is no change in the Original amount of the Loan          
    
    ${New_LoanGlobalCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Amount}    value%Amount 
    ${New_LoanGlobalCurrent}    Remove String    ${New_LoanGlobalCurrent}     ,
    ${New_LoanGlobalCurrent}    Convert To Number    ${New_LoanGlobalCurrent}    2 
    
    ${GlobalCurrent_Difference}    Evaluate    ${New_LoanGlobalCurrent}-${Orig_LoanGlobalCurrent}    
    ${GlobalCurrent_Difference}    Convert To Number    ${GlobalCurrent_Difference}    2
      
    ${CapitalizationPercentage}    Evaluate    ${Capitalization_PctofPayment}/100       
    ${Computed_IncreasedAmount}    Evaluate    ${CycleDue}*${CapitalizationPercentage}
     
    ${Computed_IncreasedAmount}    Convert To Number    ${Computed_IncreasedAmount}    2 
    
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${GlobalCurrent_Difference}    ${Computed_IncreasedAmount}         
    Run Keyword If    ${Status}==True    Log    Loan Global Current Amount has increased by ${Computed_IncreasedAmount}. 
    Run Keyword If    ${Status}==False    Log    Loan Global Current Amount has not increased by the expected amount which is ${Computed_IncreasedAmount}.
    
    ####### Validate 'Host Bank Gross' Amounts
    ${New_LoanHostBankGross}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Amount}    value%Amount 
    ${New_LoanHostBankGross}    Remove String    ${New_LoanHostBankGross}     ,
    ${New_LoanHostBankGross}    Convert To Number    ${New_LoanHostBankGross}    2  
    
    ${GlobalHostBankGross_Difference}    Evaluate    ${New_LoanHostBankGross}-${Orig_LoanHostBankGross}    
    ${GlobalHostBankGross_Difference}    Convert To Number    ${GlobalHostBankGross_Difference}    2
    
    ${HBSharePct}    Evaluate    ${HBSharePercentage}/100
    ${Computed_LoanHostBankGross}    Evaluate    ${Computed_IncreasedAmount}*${HBSharePct}
    ${Computed_LoanHostBankGross}    Convert To Number    ${Computed_LoanHostBankGross}    2
    
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${GlobalHostBankGross_Difference}    ${Computed_LoanHostBankGross}          
    Run Keyword If    ${Status}==True    Log    Loan Host Bank Gross Amount has increased by ${Computed_LoanHostBankGross}. 
    Run Keyword If    ${Status}==False    Log    Loan Host Bank Gross Amount has not increased by the expected amount which is ${Computed_LoanHostBankGross}.
    
    ####### Validate 'Host Bank Net' Amounts
    ${New_LoanHostBankNet}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Amount}    value%Amount
    ${New_LoanHostBankNet}    Remove String    ${New_LoanHostBankNet}    ,
    ${New_LoanHostBankNet}    Convert To Number    ${New_LoanHostBankNet}    2  
    
    ${GlobalHostBankNet_Difference}    Evaluate    ${New_LoanHostBankNet}-${Orig_LoanHostBankNet}    
    ${GlobalHostBankNet_Difference}    Convert To Number    ${GlobalHostBankNet_Difference}    2
    
    ${HBSharePct}    Evaluate    ${HBSharePercentage}/100
    ${Computed_LoanHostBankBNet}    Evaluate    ${Computed_IncreasedAmount}*${HBSharePct}
    ${Computed_LoanHostBankBNet}    Convert To Number    ${Computed_LoanHostBankBNet}    2
    
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${GlobalHostBankNet_Difference}    ${Computed_LoanHostBankBNet}          
    Run Keyword If    ${Status}==True    Log    Loan Host Bank Net Amount has increased by ${Computed_LoanHostBankBNet}. 
    Run Keyword If    ${Status}==False    Log    Loan Host Bank Net Amount has not increased by the expected amount which is ${Computed_LoanHostBankBNet}.
    
Validate Loan Events Tab after Payment - Capiltalized Ongoing Fee
    [Documentation]    This keyword validates the Loan Events tab after payment of the capitalized Ongoing fee.
    ...    @author: rtarayao
       
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Loan_Event_JavaTree}    Increase Applied%yes

Validate Loan Pending Tab- Capitalized Ongoing Fee 
    [Documentation]    This keyword validates that after capitalized ongoing fee payment, the loan pending tab has no pending payment items.
    ...    @author: rtarayao
       
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Pending
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_PendingItems_Null}        VerificationData="Yes"
    
Validation on Loan Notebook - Pending Tab
    [Documentation]    This keyword is for validates Interest Payment Notebook Pending Tab.
    ...    @author: ghabal
       
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Pending
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_PendingItems_Null}        VerificationData="Yes"

Validation on Loan Notebook - Events Tab
    [Documentation]    This keyword is for validates Interest Payment Notebook Events Tab.
    ...    @author: ghabal
       
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Loan_Event_JavaTree}    Capitalization Rule Set%yes 
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Loan_Event_JavaTree}    Increase Applied%yes
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Loan_Event_JavaTree}    Interest Payment Released%yes
    
Get Interest Actual Due Date on Loan Notebook
    [Documentation]    This keyword will get the interest due date to be used on Scheduled Activity for Interest Payment.
    ...    @author: fmamaril    22MAR2019    
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards, added take screenshot and optional argument for keyword post processing
    [Arguments]    ${sRuntime_Variable}=None

    Mx LoanIQ Activate Window    ${LIQ_Loan_Window}
    ${InterestActualDueDate}    Mx LoanIQ Get Data    ${LIQ_Loan_ActualDueDate_Textfield}    value%Date
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/LoanWindow

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${InterestActualDueDate}

    [Return]    ${InterestActualDueDate}
    
Get Interest Adjusted Due Date on Loan Notebook
    [Documentation]    This keyword will get the interest adjusted due date to be used on Scheduled Activity for Interest Payment.
    ...    @author: cfrancis    - inital create
    [Arguments]    ${sRuntime_Variable}=None

    Mx LoanIQ Activate Window    ${LIQ_Loan_Window}
    ${InterestAdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_Loan_AdjustedDueDate_Textfield}    value%Date
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/LoanWindow

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${InterestAdjustedDueDate}

    [Return]    ${InterestAdjustedDueDate}
    
Select Type of Schedule
    [Documentation]    This keyword selects a Schedule Type for a new Repayment Schedule
    ...                @author: bernchua    09AUG2019    Initial create
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    ...    @update: dahijara    25AUG2020    Added screenshot
    [Arguments]    ${sTypeOfSchedule}
    
    ### GetRuntime Keyword Pre-processing ###
    ${TypeOfSchedule}    Acquire Argument Value    ${sTypeOfSchedule}

    mx LoanIQ activate    ${LIQ_RepaymentSchedule_ScheduleType_Window}
    Mx LoanIQ Set    JavaWindow("title:=Choose a Type of Schedule").JavaRadioButton("label:=${TypeOfSchedule}")    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepaymentSchedule
    mx LoanIQ click    ${LIQ_RepaymentSchedule_ScheduleType_OK_Button}
    
Add Item in Flexible Schedule Window
    [Documentation]    This keyword will click the 'Add Item(s)' button in the Flexible Schedule window.
    ...                @author: bernchua    09AUG2019    Initial create
    mx LoanIQ activate    ${LIQ_FlexibleSchedule_Window}
    mx LoanIQ click    ${LIQ_FlexibleSchedule_AddItems_Button}

Tick Flexible Schedule Add Item Pay Thru Maturity
    [Documentation]    This keyword will tick the 'Pay Thru Maturity' checkbox in the Add Items window for Flexible Schedule
    ...                @author: bernchua    09AUG2019    Initial create
    mx LoanIQ activate    ${LIQ_FSched_AddItems_Window}
    Mx LoanIQ Set    ${LIQ_FSched_AddItems_PayThruMaturity_CheckBox}    ON
    
Click OK in Flexible Schedule Window
    [Documentation]    This keyword clicks the OK button in the Flexible Schedule window
    ...                @author: bernchua    09AUG2019    Initial create
    ...                @update: sahalder    22JUN2020    added Take Screenshot
    ...                @update: hstone      16JUL2020    Added 'mx LoanIQ click element if present    ${LIQ_FlexibleSchedule_Confirmation_Yes_Button}'
    mx LoanIQ activate    ${LIQ_FlexibleSchedule_Window}
    mx LoanIQ click    ${LIQ_FlexibleSchedule_OK_Button}
    mx LoanIQ click element if present    ${LIQ_FlexibleSchedule_Confirmation_Yes_Button}
    Verify If Warning Is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanNotebook-RepaymentSchedule
    
Save and Exit Repayment Schedule For Loan
    [Documentation]    This keyword saves the Repayment Schedule for the Loan
    ...                @author: bernchua    09AUG2019    Initial create
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    Verify If Warning Is Displayed
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Exit_Button}
    
Create Pending Transaction in Repayment Schedule
    [Documentation]    This high-level keyword will create a Pending Transaction for an item in the Loan's Repayment Schedule.
    ...                @author: bernchua    09AUG2019    Initial create
    ...                @update: gerhabal    09OCT2019    added new computation for principal amount which is a sum of principal amount + unpaid interest    
    [Arguments]    ${RepaymentSchedule_ItemNo}
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    ${Unpaid_Interest}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentSchedule_FixedPayment_List}    ${RepaymentSchedule_ItemNo}%Unpaid Interest%interest
    ${Principal_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentSchedule_FixedPayment_List}    ${RepaymentSchedule_ItemNo}%Principal%principal
    ${ActualDueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_CurrentSchedule_FixedPayment_List}    ${RepaymentSchedule_ItemNo}%Actual Due Date%duedate
    mx LoanIQ click    ${LIQ_RepaymentSchedule_CreatePending_Button}
    Verify If Warning Is Displayed
    ${Unpaid_Interest}    Remove String    ${Unpaid_Interest}    -
    ${Principal_Amount}    Remove String    ${Principal_Amount}    -
    ${Total_Amount}    Evaluate    ${Principal_Amount}+${Unpaid_Interest}
    [Return]    ${Unpaid_Interest}    ${Principal_Amount}    ${ActualDueDate}    ${Total_Amount}

Click OK in Add Items for Flexible Schedule
    [Documentation]    This keyword will just click OK in the "Add Items" window for Flexible Schedule.
    ...                @author: bernchua    13AUG2019    Initial create
    mx LoanIQ click    ${LIQ_FSched_AddItems_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

Enter Flexible Schedule Add Item Number of Payments
    [Documentation]    This keyword will enter the "# of Payments" in the Add Items window for Flexible Schedule.
    ...                @author: bernchua    14AUG2019    Initial create
    [Arguments]    ${sFlexSched_NoOfPayments}
    mx LoanIQ activate    ${LIQ_FSched_AddItems_Window}
    mx LoanIQ enter    ${LIQ_FSched_AddItems_NoOFPayments_Field}    ${sFlexSched_NoOfPayments}
    
Set Flexible Schedule Add Item Frequency
    [Documentation]    This keyword will set the Frequency in the Add Items window for Flexible Schedule.
    ...                @author: bernchua    14AUG2019    Initial create
    [Arguments]    ${sFlexSched_Frequency}
    mx LoanIQ activate    ${LIQ_FSched_AddItems_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Frequency_Field}    ${sFlexSched_Frequency}    
    
Set Flexible Schedule Add Item Type
    [Documentation]    This keyword will set the Type in the Add Items window for Flexible Schedule.
    ...                @author: bernchua    14AUG2019    Initial create
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    [Arguments]    ${sFlexSched_Type}
    
    ### GetRuntime Keyword Pre-processing ###
    ${FlexSched_Type}    Acquire Argument Value    ${sFlexSched_Type}

    mx LoanIQ activate    ${LIQ_FSched_AddItems_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FSched_AddItems_Type_Field}    ${FlexSched_Type}
    
Tick Flexible Schedule Add Item PI Amount
    [Documentation]    This keyword will tick the "P&I Amount" check box in the Add Items window for Flexible Schedule.
    ...                @author: bernchua   14AUG2019    Initial create
    ...                @update: bernchu    09SEP2019    Updated keyword for dynamic checkbox locator; Added arguments for checkbox name
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    [Arguments]    ${sPrincipalOrInterest_Checkbox}
    
    ### GetRuntime Keyword Pre-processing ###
    ${PrincipalOrInterest_Checkbox}    Acquire Argument Value    ${sPrincipalOrInterest_Checkbox}

    mx LoanIQ activate    ${LIQ_FSched_AddItems_Window}
    Mx LoanIQ Set    JavaWindow("title:=Add Items").JavaCheckBox("attached text:=${PrincipalOrInterest_Checkbox}:")    ON
    
Enter Flexible Schedule Add Item PI Amount
    [Documentation]    This keyword will enter the "Principal Amount" or "P&I Amount" in the Add Items window for Flexible Schedule.
    ...                @author: bernchua    14AUG2019    Initial create
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    ...    @update: dahijara    25AUG2020    Added screenshot
    [Arguments]    ${sFlexSched_PIAmount}
    
    ### GetRuntime Keyword Pre-processing ###
    ${FlexSched_PIAmount}    Acquire Argument Value    ${sFlexSched_PIAmount}

    mx LoanIQ activate    ${LIQ_FSched_AddItems_Window}
    ${PayThruMaturity_STATUS}    Mx LoanIQ Get Data    ${LIQ_FSched_AddItems_PayThruMaturity_CheckBox}    enabled%status
    Run Keyword If    '${PayThruMaturity_STATUS}'=='1'    mx LoanIQ enter    ${LIQ_FSched_AddItems_PIAmount_Field_MaturityEnabled}    ${FlexSched_PIAmount}
    ...    ELSE IF    '${PayThruMaturity_STATUS}'=='0'    mx LoanIQ enter    ${LIQ_FSched_AddItems_PIAmount_Field_MaturityDisabled}    ${FlexSched_PIAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FSched_AddItems

Add Unscheduled Transaction In Repayment Schedule
    [Documentation]    This keyword will click the 'Add Unsch Tran.' in the Repayment Schedule window.
    ...                @author: bernchua    15AUG2019    Initial create
    [Arguments]    ${sItem_No}
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Click Javatree Cell    ${LIQ_RepaymentSchedule_CurrentSchedule_FixedPayment_List}    ${sItem_No}%Item        
    mx LoanIQ click    ${LIQ_RepaymentSchedule_AddUnschTran_Button}

Select Interest Accrual Cycle
    [Documentation]    This keyword will click the "Select Interest Accrual Cycle" button in the Add Transaction window.
    ...                @author: bernchua    15AUG2019    Initial create                    
    mx LoanIQ activate    ${LIQ_AddTransaction_Window}
    mx LoanIQ click    ${LIQ_AddTransaction_SelectInterestAccrual_Button}
        
Select Cycles for Loan Item
    [Documentation]    This keyword will select an item in the 'Cycles for Loan' window and select a specific 'Prorate With' option.
    ...                This will also return the Cycle amount.
    ...                @author: bernchua    15AUG2019    Initial create
    ...                @author: bernchua    21AUG2019    Added taking of screenshot
    [Arguments]    ${sProrate_With}    ${sCycle_No}
    mx LoanIQ activate window    ${LIQ_Loan_CyclesforLoan_Window}
    Mx LoanIQ Set    JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("label:=${sProrate_With}")    ON
    Run Keyword If    '${sProrate_With}'=='Projected Due'    Set Test Variable    ${sProrateWith}    Projected Cycle Due
    ${Cycle_Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_CyclesforLoan_List}    ${sCycle_No}%${sProrate_With}%amount
    Mx LoanIQ Select String    ${LIQ_Loan_CyclesforLoan_List}    ${sCycle_No}
    Take Screenshot    CyclesForLoan
    mx LoanIQ click    ${LIQ_Loan_CyclesforLoan_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    [Return]    ${Cycle_Amount}

Set Unscheudled Transaction Details
    [Documentation]    This keyword will set the 'Add Transaction' type to either Increase or Payment
    ...                @author: bernchua    15AUG2019    Initial create
    [Arguments]    ${sTransaction_Type}    ${sPrincipal_Amount}    ${sInterestDue_Amount}    ${sEffective_Date}    ${sApplication_Method}
    mx LoanIQ activate    ${LIQ_AddTransaction_Window}
    Mx LoanIQ Set    JavaWindow("title:=Add Transaction").JavaRadiobutton("attached text:=${sTransaction_Type}")    ON    
    mx LoanIQ enter    ${LIQ_AddTransaction_Principal_Textfield}    ${sPrincipal_Amount}
    mx LoanIQ enter    ${LIQ_AddTransaction_InterestDue_Textfield}    ${sInterestDue_Amount}
    mx LoanIQ enter    ${LIQ_AddTransaction_EffectiveDate_Textfield}    ${sEffective_Date}
    Mx LoanIQ Set    JavaWindow("title:=Add Transaction").JavaRadioButton("attached text:=.*${sApplication_Method}.*")    ON    
    mx LoanIQ click    ${LIQ_AddTransaction_OK_Button}
    
Get Repayment Schedule Current Loan Amount
    [Documentation]    This keyword will get the Loan Amounts - Current from the Repayment Schedule window.
    ...                @author: bernchua    15AUG2019    Initial create
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    ${Current_Amount}    Mx LoanIQ Get Data    ${LIQ_RepaymentSchedule_CurrentLoanAmount_Field}    value%amount
    [Return]    ${Current_Amount}
    
Go To Repayment Schedule Transaction NB
    [Documentation]    This keyword will click the 'Transaction NB' button in the Repayment Scheudle window.
    ...                @author: bernchua    15AUG2019    Initial create
    [Arguments]    ${sItem_No}
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Click Javatree Cell    ${LIQ_RepaymentSchedule_CurrentSchedule_FixedPayment_List}    ${sItem_No}%Item
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Transaction_NB_Button}
    Verify If Warning Is Displayed

Get Loan Risk Type
    [Documentation]    This keyword gets the Loan Risk type and returns the value.
    ...    @author: rtarayao    29AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General 
    ${LoanRiskType}    Mx LoanIQ Get Data    ${LIQ_Loan_RiskType_Text}    value%Loan Risk Type 
    Log    The Loan fee type is ${LoanRiskType}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Loan Risk Type
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${LoanRiskType}

Get Loan Currency
    [Documentation]    This keyword gets the Loan Currency and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General 
    ${LoanCCY}    Mx LoanIQ Get Data    ${LIQ_Loan_Currency_Text}    text%Currency  
    Log    The Loan Currency is ${LoanCCY}  
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Loan Currency
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${LoanCCY}
    
Get Loan Effective and Maturity Expiry Dates
    [Documentation]    This keyword gets the Loan Effective Date and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    ...    @update: cfrancis    13OCT2020    - Updated screenshot path
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General
    ${LoanEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_Loan_EffectiveDate_Text}    text%EffectiveDate 
     ${LoanMaturityDate}    Mx LoanIQ Get Data    ${LIQ_Loan_MaturityDate_Text}    text%MaturityDate
    Log    The Loan Effective and Maturity Dates are ${LoanEffectiveDate} and ${LoanMaturityDate} respectively.  
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/Loan_Effective_and_Maturity_Date
    [Return]    ${LoanEffectiveDate}    ${LoanMaturityDate}

Get Loan Host Bank Net and Gross Amount
    [Documentation]    This keyword gets the Loan Host Bank Net and Gross Amounts and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General
    ${HBGrossAmount}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankGross_Field}    value%HBGrossAmount 
    ${HBNetAmount}    Mx LoanIQ Get Data    ${LIQ_Loan_HostBankNet_Field}    value%HBNetAmount 
    Log    The Loan Host Bank Gross and Net Amounts are ${HBGrossAmount} and ${HBNetAmount} respectively. 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Issuance HB Values
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${HBGrossAmount}    ${HBNetAmount}  
    
Get Loan Global Original and Current Amount
    [Documentation]    This keyword gets the Loan Global Original and Current Amounts and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General
    ${GlobalOriginalAmount}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Field}    value%GlobalOrigAmount 
    ${GlobalCurrentAmount}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Field}    value%GlobalCurrentAmount 
    Log    The Loan Global Original and Current Amounts are ${GlobalOriginalAmount} and ${GlobalCurrentAmount} respectively. 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Loan Global Values
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${GlobalOriginalAmount}    ${GlobalCurrentAmount}   
    

Get Loan Payment Mode and Interest Frequency Cycle
    [Documentation]    This keyword gets the Loan Payment mode and Interest Frequency Cycle returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General
    ${PaymentMode}    Mx LoanIQ Get Data    ${LIQ_Loan_PaymentMode_List}    value%PaymentMode 
    ${IntCycleFrequency}    Mx LoanIQ Get Data    ${LIQ_Loan_IntCycleFreq_Dropdownlist}    value%IntcycleFreq 
    Log    The Loan Payment Mode and Interest Cycle Frequency are ${PaymentMode} and ${IntCycleFrequency} respectively. 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Loan Global Values
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${PaymentMode}    ${IntCycleFrequency}
    
Get Loan Pricing Option Code
    [Documentation]    This keyword gets the Loan Pricing Option and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General 
    ${PricingOptionCode}    Mx LoanIQ Get Data    ${LIQ_Loan_PricingOption_Text}    text%PricingOption  
    Log    The Pricing Option Code is ${PricingOptionCode}  
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Loan Pricing Option
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${PricingOptionCode}
    
Get Pricing Code and Description Combined
    [Documentation]    This keyword returns the facility pricing code and description used.
    ...    @author: rtarayao    16AUG2019    Initial Create
    [Arguments]    ${sPricingCode}    ${sPricingDesc}
    Log    Pricing option code and description are ${sPricingCode} and ${sPricingDesc} respectively.
	    ${LoanPricingOption}    Catenate    SEPARATOR=/    ${sPricingCode}    ${sPricingDesc}        
    Log    The combined expense code and description is ${LoanPricingOption}          
    [Return]    ${LoanPricingOption}

Get Loan Spread and All In Rates
    [Documentation]    This keyword returns the Loan Rates, Spread and All In Rates.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    ...    @update: cfrancis    19OCT2020    - added removing five 0 and % for all in rate
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Rates 
    ${SpreadRate}    Mx LoanIQ Get Data    ${LIQ_Loan_Spread_Text}    value%Spread   
    ${SpreadRate}    Convert To String    ${SpreadRate}
    ${SpreadRate}    Remove String    ${SpreadRate}    .000000%    
    ${AllInRate}    Mx LoanIQ Get Data    ${LIQ_Loan_AllInRate}    value%AllInRate
    ${AllInRate}    Convert To String    ${AllInRate}
    ${AllInRate}    Remove String    ${AllInRate}    .000000%
    ${AllInRate}    Remove String    ${AllInRate}    00000%
    Log    The Loan Spread is ${SpreadRate}. 
    Log    The Loan All In Rates is ${AllInRate}      
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Loan Rates
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${SpreadRate}    ${AllInRate}
    
Navigate to Share Accrual Cycle
    [Documentation]    Navigate in Share Accrual Loan Outstanding Non Zero Cycle Cycle Due Value
    ...    @author: sacuisia    30SEPT2020    -inital create
    [Arguments]    ${sPrimary_Lender}
    
   ${Primary_Lender}    Acquire Argument Value    ${sPrimary_Lender}
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    mx LoanIQ click    ${LIQ_Accrual_CycleDueOverview_Button}
    Mx LoanIQ DoubleClick    ${LIQ_SharesFor_Primaries_Tree}    ${Primary_Lender}
    Log    ${Primary_Lender}

Get ProjectedCycleDue
    [Documentation]    This keyword returns value for Loan Outstanding and enter requested amount in Interest Payment.
    ...    @author: sacuisia    05OCT2020    -initial create 
    
    ${projectedCycleDue}    Mx LoanIQ Get Data    ${LIQ_Payment_ProjectedCycleDue_Amount}    value%projectedCycleDue
    [Return]    ${projectedCycleDue}  
       
Get Requested Amount
    [Documentation]    This keyword returns value for Loan Outstanding and enter requested amount in Interest Payment.
    ...    @author: sacuisia    05OCT2020    -initial create
    
    ${requestedAmount}    Mx LoanIQ Get Data    ${LIQ_InterestPayment_RequestedAmount_field}    value%requestedAmount
    [Return]    ${requestedAmount}

Get Cycle Due Amount
    [Documentation]    This keyword returns value for Loan Outstanding Non Zero Cycle Cycle Due Value
    ...    @author: sacuisia    30SEPT2020    -inital create
    
    mx LoanIQ activate window    ${LIQ_ServicingGroup_AccrualCycle}
    ${CycleData}    Mx LoanIQ Get Data    ${LIQ_ServicingGroup_CycleDue}    value%CycleData
    [Return]    ${CycleData}
   
Get PaidToDate
    [Documentation]    This keyword returns value for Loan Outstanding Non Zero Cycle Cycle Due Value
    ...    @author: sacuisia    30SEPT2020    -inital create
    
    ${PaidData}    Mx LoanIQ Get Data    ${LIQ_ServicingGroup_Paid}    value%PaidData
    [Return]    ${PaidData}
    
Get Loan Accrued to Date Amount
    [Documentation]    This keyword returns the Issuance fee rate.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ${AccruedtodateAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    TOTAL:${SPACE}%Accrued to date%Accruedtodate    
    Log    The Issuance Accrued to Date amount is ${AccruedtodateAmount} 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Loan Accrual Screen
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${AccruedtodateAmount}
    
    
Navigate to Rates Tab - Loan Notebook
    [Documentation]    This keyword navigates to the Rates tab of the Loan Notebook.
    ...                @author: hstone    28AUG2019    Initial create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Rates   

Perform Online Accrual for a Loan Alias
    [Documentation]    This keyword will Perform an Online Accrual for a loan
    ...    @author: hstone
    [Arguments]    ${sLoanAlias}  
    mx LoanIQ activate window    ${LIQ_ExistingLoansForFacility_Window}   
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ExistingLoansForFacility_JavaTree}    ${sLoanAlias}%d   
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${InquiryMode_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${InquiryMode_Status}==True    mx LoanIQ click    ${LIQ_Loan_InquiryMode_Button}
    ...    ELSE    Run Keyword    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_UpdateMode_Button}    VerificationData="Yes"
    mx LoanIQ select    ${LIQ_Loan_Accounting_PerformOnlineAccrual_Menu}
    Verify If Warning Is Displayed
    ${InfoMessage}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Information_MessageBox}    VerificationData="Yes"
    Run Keyword If    ${InfoMessage}==True    mx LoanIQ click    ${LIQ_Information_OK_Button} 
    Log    Loan - Perform Online Accrual is complete
    
Select Reschedule Menu in Repayment Schedule
    [Documentation]    Keyword used to Reschedule the Repayment Scheudle of a Loan.
    ...                @author: bernchua    09SEP2019    Initial create
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Reschedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Resynchronize Loan Repayment Schedule
    [Documentation]    Keyword used to Resynchronize a Loan's Repayment Schedule
    ...                @author: bernchua    20SEP2019    Initial create
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Resynchronize}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
Get Loan Repricing Frequency and Date
    [Documentation]    This keyword gets the Loan Repricing Frequency and Date values.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General
    ${RepricngFrequency}    Mx LoanIQ Get Data    ${LIQ_Loan_RepricingFrequency_JavaList}    value%RepricingFreq 
    ${RepricingDate}    Mx LoanIQ Get Data    ${LIQ_Loan_RepricingDate_Text}    text%RepringDate
    Log    The Loan Repricing Frequency and Date values ${RepricngFrequency} and ${RepricingDate} respectively. 
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Set Test Variable    ${SCREENSHOT_FILENAME}    Loan Repricing Values
    Take Screenshot    ${SCREENSHOT_FILENAME}
    [Return]    ${RepricngFrequency}    ${RepricingDate}    
    
Close Loan Notebook
    [Documentation]    Keyword used to close the Loan Notebook
    ...                @author: bernchua    23SEP2019    Initial create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ close window    ${LIQ_Loan_Window}
       
Modify Pay In Advance Preposition for ComSee Use
    [Documentation]    This keyword updates the word In to in of the Payment Mode of the loan.
    ...    @author: rtarayao    16OCT2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${ModifiedPaymentMode}    Replace String    Pay In Advance    In    in    
    [Return]    ${ModifiedPaymentMode} 

Navigate to an Existing Loan
    [Documentation]    This keyword opens an existing loan on LIQ.
    ...    @author: hstone     01JUN2020     - Initial Create
    ...    @update: hstone     18JUN2020     - Added arguments: ${sActive_Checkbox}, ${sInactive_Checkbox}, ${sPending_Checkbox}
    ...                                      - Added keyword Pre-processing for the new arguments
    ...                                      - Added handling condition for Active, Inactive and Pending Checkbox
    ...                                      - Moved from LoanDrawdown_Notebook.robot to Loan_Notebook.robot
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}    ${sLoan_Alias}    ${sActive_Checkbox}=Y    ${sInactive_Checkbox}=N    ${sPending_Checkbox}=N

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
    ${Active_Checkbox}    Acquire Argument Value    ${sActive_Checkbox}
    ${Inactive_Checkbox}    Acquire Argument Value    ${sInactive_Checkbox}
    ${Pending_Checkbox}    Acquire Argument Value    ${sPending_Checkbox}

    ${Active_Checkbox}    Convert To Uppercase    ${Active_Checkbox}
    ${Inactive_Checkbox}    Convert To Uppercase    ${Inactive_Checkbox}
    ${Pending_Checkbox}    Convert To Uppercase    ${Pending_Checkbox}

    ### Select Outstanding at Actions Menu ###
    mx LoanIQ maximize    ${LIQ_Window}
    Select Actions    [Actions];Outstanding

    ### Search for Existing Loans using the Deal and Facility value ###
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Deal_TextField}    ${Deal_Name}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}

    Run Keyword If    '${Active_Checkbox}'=='Y'    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Active_Checkbox}    ON
    ...    ELSE IF    '${Active_Checkbox}'=='N'    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Active_Checkbox}    OFF
    ...    ELSE    Fail    Invalid Input for Active Checkbox. Only 'Y' or 'N' is accepted.

    Run Keyword If    '${Inactive_Checkbox}'=='Y'    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Inactive_Checkbox}    ON
    ...    ELSE IF    '${Inactive_Checkbox}'=='N'    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Inactive_Checkbox}    OFF
    ...    ELSE    Fail    Invalid Input for Inactive Checkbox. Only 'Y' or 'N' is accepted.

    Run Keyword If    '${Pending_Checkbox}'=='Y'    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Pending_Checkbox}    ON
    ...    ELSE IF    '${Pending_Checkbox}'=='N'    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Pending_Checkbox}    OFF
    ...    ELSE    Fail    Invalid Input for Pending Checkbox. Only 'Y' or 'N' is accepted.

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSearch
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}

    ### Open Loan Notebook ###
    mx LoanIQ activate    ${LIQ_ExistingLoanForFacility_Window}
    mx LoanIQ enter    ${LIQ_ExistingLoanForFacility_Update_Checkbox}    ON
    mx LoanIQ enter    ${LIQ_ExistingLoanForFacility_RemainOpen_Checkbox }    OFF
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_ExistingLoanForFacility_Tree}    ${Loan_Alias}%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanSelect
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_General

Navigate to Loan Pending Tab and Proceed with the Pending Transaction
    [Documentation]    This keyword navigates to the loan pending tab and proceeds with the transaction.
    ...    @author: hstone
    [Arguments]    ${sPendingTransaction}

    ### Keyword Pre-processing ###
    ${PendingTransaction}    Acquire Argument Value    ${sPendingTransaction}

    Navigate Notebook Pending Tab    ${LIQ_Loan_Window}    ${LIQ_Loan_Tab}    ${LIQ_Loan_PendingTab_JavaTree}    ${PendingTransaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_Pending
    
Navigate to Existing Loan
    [Documentation]    This keyword navigates the LIQ User to the Loan Notebook.
    ...    @author: rtarayao 
    ...    @update: rtarayao - deleted all read data from excel actions, loan_alias must be read outside the keyword
    ...    @update: bernchua    09AUG2019    Added ticking of 'Existing' radio button.
    ...    @update: hstone      29MAY2020    - Added Keyword Pre-processing
	...    @update: amansuet    01JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
	...    @update: sahalder    26JUN2020    - moved the keyword from LoanDrawdown_Notebook to Loan_Notebook
	...    @update: clanding    13AUG2020    - updated hard coded values to global variables
    [Arguments]    ${sOutstanding_Type}    ${sLoan_FacilityName}    ${sLoan_Alias}
    
    ### Keyword Pre-processing ###
    ${Outstanding_Type}    Acquire Argument Value    ${sOutstanding_Type}
    ${Loan_FacilityName}    Acquire Argument Value    ${sLoan_FacilityName}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    Mx LoanIQ Activate Window    ${LIQ_OutstandingSelect_Window}
    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Existing_RadioButton}    ${ON}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Outstanding_Type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Loan_FacilityName}
    Mx LoanIQ Click    ${LIQ_OutstandingSelect_Search_Button}
    Mx LoanIQ Activate Window    ${LIQ_ExistingOutstandings_Window}
    Mx LoanIQ Maximize    ${LIQ_ExistingOutstandings_Window}    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ExistingOutstandings_Table}    ${Loan_Alias}%d
    Mx LoanIQ Close Window    ${LIQ_ExistingOutstandings_Window}
    Mx LoanIQ Activate Window    ${LIQ_Loan_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/LoanWindow

Navigate to Flexible Schedule Item Modification
    [Documentation]    This keyword navigates to repayment flexible schedule item modification window.
    ...    @author: hstone    16JUL2020    - Initial Create
    [Arguments]    ${sItem_Number}

    ### Keyword Pre-processing ###
    ${Item_Number}    Acquire Argument Value    ${sItem_Number}

    Mx LoanIQ Activate Window    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Click Javatree Cell    ${LIQ_RepaymentSchedule_Frequency_JavaTree}    ${Item_Number}%Item
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/RepaymentSchedule
    Mx LoanIQ Click    ${LIQ_RepaymentSchedule_ModifyItem_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

Modify Repayment Schedule Item at Flexible Schedule
    [Documentation]    This keyword modifies a repayment schedule item.
    ...    @author: hstone    16JUL2020    - Initial Create
    [Arguments]    ${sItem_Number}    ${sColumn_Name}    ${sNew_Value}

    ### Keyword Pre-processing ###
    ${Item_Number}    Acquire Argument Value    ${sItem_Number}
    ${Column_Name}    Acquire Argument Value    ${sColumn_Name}
    ${New_Value}    Acquire Argument Value    ${sNew_Value}

    Mx LoanIQ Activate Window    ${LIQ_FlexibleSchedule_Window}
    Enter Text on Java Tree Text Field    ${LIQ_FlexibleSchedule_JavaTree}    ${Item_Number}    ${Column_Name}    ${New_Value}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FlexibleSchedule

Select Resync Settings in Flexible Schedule
    [Documentation]    This keyword is for selecting resync settings in Flexible Schedule window.
    ...    @author: hstone    16JUL2020     - Initial Create
    [Arguments]    ${sResync_Setting}

    ### Keyword Pre-processing ###
    ${Resync_Setting}    Acquire Argument Value    ${sResync_Setting}

    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FlexibleSchedule_ResyncSettings_Dropdown}    ${Resync_Setting}

Click on Calculate Payments in Flexible Schedule
    [Documentation]    This keyword is for clicking Calculate Payments Button in Flexible Schedule window.
    ...    @author: hstone    16JUL2020     - Initial Create
    
    mx LoanIQ activate window    ${LIQ_FlexibleSchedule_Window}
    mx LoanIQ click    ${LIQ_FlexibleSchedule_CalculatePayments_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Resynchronize Repayment Schedule
    [Documentation]    This keyword is used for resynchronizing repayment schedule.
    ...    @author: hstone    16JUL2020     - Initial Create

    Mx LoanIQ Activate Window    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Resynchronize}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}

Save Repayment Schedule For Loan
    [Documentation]    This keyword saves the Repayment Schedule for the Loan
    ...                @author: hstone    16JUL2020    Initial create
    mx LoanIQ activate    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    Verify If Warning Is Displayed
    
Validate Repayment Schedule Item Cell Value For Loan
    [Documentation]    This keyword validates the repayment schedule item details.a
    ...                @author: hstone    17JUL2020    Initial create
    [Arguments]    ${sItem_Number}    ${sColumn}    ${sExpected_Cell_Value}    ${sColumn_Type}=Amount    ${sAmount_Type}=Negative

    ### Keyword Pre-processing ###
    ${Item_Number}    Acquire Argument Value    ${sItem_Number}
    ${Column}    Acquire Argument Value    ${sColumn}
    ${Expected_Cell_Value}    Acquire Argument Value    ${sExpected_Cell_Value}

    ${Expected_Cell_Value}    Run Keyword If    '${sColumn_Type}'=='Amount' and '${sAmount_Type}'=='Negative'    Set Variable    -${Expected_Cell_Value}
    ${UI_Cell_Value}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_Frequency_JavaTree}    ${Item_Number}%${Column}%cellValue
    Compare Two Strings    ${Expected_Cell_Value}    ${UI_Cell_Value}    Repayment Schedule Item Cell Validation: Item No. (${Item_Number}), Column (${Column})

Validate Repayment Schedule Resync Settings Value
    [Documentation]    This keyword validates the repayment schedule resync settings value
    ...                @author: hstone    28JUL2020    Initial create
    [Arguments]    ${sExpected_ResyncSettings}

    ### Keyword Pre-processing ###
    ${Expected_ResyncSettings}    Acquire Argument Value    ${sExpected_ResyncSettings}

    Mx LoanIQ Activate Window    ${LIQ_RepaymentSchedule_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/RepaymentSchedule
    ${Actual_ResycnSettings}    Mx LoanIQ Get Data    ${LIQ_RepaymentSchedule_ResyncSettings_Dropdown}    value%temp
    Compare Two Strings    ${Expected_ResyncSettings}    ${Actual_ResycnSettings}    Resync Settings Validation

Validate Repayment Schedule Last Payment Remaining Value
    [Documentation]    This keyword validates the repayment schedule last payment remaining value.
    ...                @author: hstone    29JUL2020    Initial create
    ...                @update: hstone    07AUG2020    Added Else Condition on Validation Result
    [Arguments]    ${sExpected_RemainingValue}

    ### Keyword Pre-processing ###
    ${Expected_RemainingValue}    Acquire Argument Value    ${sExpected_RemainingValue}

    Mx LoanIQ Activate Window    ${LIQ_RepaymentSchedule_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/RepaymentSchedule

    ${Comparison_Status}    Set Variable    False
    ${Prev_RemainingVal_Comparison_Status}    Set Variable    False
    ${Prev_RemainingValue}    Set Variable    None
    ${Prev_Remaining_Value_Equal_Count}    Set Variable    0

    :FOR    ${ItemNum}    IN RANGE    1    999999
    \    Log    ${ItemNum}
    \    ${Actual_RemainingValue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RepaymentSchedule_Frequency_JavaTree}    ${ItemNum}%Remaining%value
    \    ${Comparison_Status}    Run Keyword And Return Status    Compare Two Strings    ${Expected_RemainingValue}    ${Actual_RemainingValue}    Remaining Value Validation
    \    ${Prev_RemainingVal_Comparison_Status}    Run Keyword And Return Status    Compare Two Strings    ${Prev_RemainingValue}    ${Actual_RemainingValue}    Previous and Current Remaining Value Fetch Comparison
    \    Exit For Loop If    '${Comparison_Status}'=='True' or '${Prev_RemainingVal_Comparison_Status}'=='True'
    \    ${Prev_RemainingValue}    Set Variable    ${Actual_RemainingValue}

    Run Keyword If    '${Comparison_Status}'=='True'    Log    Last Payment Remaining Validation Passed
    ...    ELSE IF    '${Prev_RemainingVal_Comparison_Status}'=='True'    Run Keyword And Continue On Failure    Fail    Last Payment Remaining Validation Failed. Last Payment Remaining Value is '${Prev_RemainingValue}' instead of '${Expected_RemainingValue}'
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Condition is NOT Supported by Validate Repayment Schedule Last Payment Remaining Value