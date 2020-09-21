*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***
Setup Repricing
    [Documentation]    This keyword is used to Setup the Repricing in Workflow tab
    ...    @author: ritragel
    ...    @update: mnanquil                 Instead of using workflow, this keyword will now click the add button
    ...    @update: bernchua    09DEC2018    Return loan alias
    ...    @update: bernchua    08MAR2019    Removed "Write Data To Excel" as per standards
    ...                                      Removed commented lines "Mx Click Element If Present" for Warning messages.
    ...    @update: bernchua    12MAR2019    Updated code for getting the UI value for the Borrower Base Rate (created a separate low-level keyword).
    ...                                      Removed getting & returning of Effective Date from Rollover/Conversion Notebook.
    ...    @update: hstone      28MAY2020    - Added Keyword Pre-processing
    ...                                      - Added Optional Argument: ${sRunTimeVar_NewLoanAlias}
    ...                                      - Added Keyword Post-processing
    [Arguments]    ${sRepricingType}    ${sBase_Rate}    ${sPricing_Option}    ${sRollover_Amount}    ${sRepricing_Frequency}    ${sAcceptRepricingFrequency}=N    ${sLoanRepricing}=Setup
    ...    ${sRunTimeVar_NewLoanAlias}=None

    ### Keyword Pre-processing ###
    ${RepricingType}    Acquire Argument Value    ${sRepricingType}
    ${Base_Rate}    Acquire Argument Value    ${sBase_Rate}
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${Rollover_Amount}    Acquire Argument Value    ${sRollover_Amount}
    ${Repricing_Frequency}    Acquire Argument Value    ${sRepricing_Frequency}
    ${acceptRepricingFrequency}    Acquire Argument Value    ${sAcceptRepricingFrequency}
    ${loanRepricing}    Acquire Argument Value    ${sLoanRepricing}

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Run keyword if    '${loanRepricing}' == 'Setup'    Run Keywords
    ...    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    Workflow  
    ...    AND    Run keyword if    '${loanRepricing}' == 'Setup'    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Setup  
    ...    ELSE IF    '${loanRepricing}' == 'Add'    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_Add_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_RepricingDetail_Window}    
    Select Repricing Detail Add Options    ${RepricingType}    ${Pricing_Option}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button} 
    mx LoanIQ activate window    ${LIQ_PendingRollover_Window}
    
    ${NewLoanAlias}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_Alias_Textfield}    NewLoanAlias 
    mx LoanIQ enter    ${LIQ_PendingRollover_RequestedAmt_JavaEdit}    ${Rollover_Amount}
    Log    ${Repricing_Frequency}
    Mx LoanIQ Select Combo Box Value   ${LIQ_PendingRollover_RepricingFrequency_Dropdown}    ${Repricing_Frequency}
    Mx LoanIQ Select Combo Box Value    ${LIQ_PendingRollover_Accrue_Dropdown}    to the actual due date
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ select    ${LIQ_PendingRollover_Save_Submenu}
    Verify If Warning Is Displayed
    Mx LoanIQ Select Window Tab    ${LIQ_PendingRollover_Tab}    Rates
    mx LoanIQ click    ${LIQ_PendingRollover_BaseRate_Button}
    Verify If Warning Is Displayed
    
    Run keyword if    '${acceptRepricingFrequency}'=='Y'    mx LoanIQ click    ${LIQ_InitialDrawdown_AcceptBaseRate}
    Log    ${Base_Rate}        
    
    ${UIBaseRate}    Run keyword if    '${acceptRepricingFrequency}'=='Y'    Get and Validate Borrower Base Rate    ${Base_Rate}
    ...    ELSE IF    '${acceptRepricingFrequency}'=='N'    Set Base Rate    ${Base_Rate}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_NewLoanAlias}    ${NewLoanAlias}

    [Return]    ${NewLoanAlias}
    
Get and Validate Borrower Base Rate
    [Documentation]    This keyword gets the UI value of the Borrower Base Rate from the "Set Base Rate" window, and validates it if it's equal to the supposed value.
    ...                @author: bernchua    12MAR2019    initial create
    [Arguments]        ${iBaseRate}
    mx LoanIQ activate    ${LIQ_SetBaseRate_Window}
    ${UIBaseRate}    Mx LoanIQ Get Data    ${LIQ_InitialDrawdown_BorrowerBaseRate_Textfield}    value%rate
    ${iBaseRate}    Convert To String    ${iBaseRate}
    ${UIBaseRate}    Convert To String    ${UIBaseRate}
    ${vaidateRates}    Run Keyword And Return Status    Should Be Equal    ${iBaseRate}    ${UIBaseRate}
    Run Keyword If    ${vaidateRates}==True    Run Keywords    mx LoanIQ click    ${LIQ_SetBaseRate_BorrowerBaseRate_OK_Button}
    ...    AND    Log    Borrower Base Rate successfully validated.
    ...    ELSE    Fail    Borrower Base Rate not validated.
    
Set Base Rate
    [Documentation]    This keyword is used to Set the Base Rate
    ...    @author: ritragel
    [Arguments]    ${Base_Rate}
    mx LoanIQ activate window    ${LIQ_SetBaseRate_Window}
    mx LoanIQ enter    ${LIQ_SetBaseRate_BorrowerBaseRate_TextField}    ${Base_Rate} 
    mx LoanIQ click    ${LIQ_SetBaseRate_BorrowerBaseRate_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ select    ${LIQ_PendingRollover_Save_Submenu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}

Set Currency FX Rate
    [Documentation]    This keyword will set the currency fx rate
    ...    @author: mnanquil
    ...    10/23/2018
    [Arguments]    ${currency}    ${facilityCurrency}    ${facilityCurrencyRate}    ${excelRate}    
    Mx LoanIQ Select Window Tab    ${LIQ_PendingRollover_Tab}    Currency
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Rollover/Conversion.*").JavaStaticText("attached text:=${currency}")    VerificationData="Yes"
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Rollover/Conversion.*").JavaStaticText("attached text:=${facilityCurrency}")       VerificationData="Yes"
    mx LoanIQ click    ${LIQ_Rollover_Currency_FXRate_Button}
    mx LoanIQ activate window    ${LIQ_Rollover_Currency_Window}
    mx LoanIQ click    JavaWindow("title:=Facility Currency.*").JavaButton("attached text:=${facilityCurrencyRate}.*")
    ${rate}    Mx LoanIQ Get Data    ${LIQ_Rollover_AUD_USD_Currency}    Rate    
    mx LoanIQ click    ${LIQ_Rollover_Currency_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Should Be Equal    ${excelRate}    ${rate}        
    [Return]    ${rate}
            
Send Loan Repricing for Approval
    [Documentation]    This keyword is used to Send the Transaction Rates for approval and approve it with different user
    ...    @author: ritragel
    ...    @update: jdelacru    12MAR2019    - Added error handler to cater those scenario with no Cashflows
    ...    @update: clanding    13AUG2020    - updated hard coded values to global variables; added screenshot
    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${WORKFLOW_TAB}  
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    ${SEND_TO_APPROVAL_STATUS}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingForDealWindow
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingForDealWindow 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingForDealWindow
    
Approve Loan Repricing
    [Documentation]    This keyword is used to Approved Rate Setting Notice
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    Workflow  
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}   
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     
Send to Rate Approval
    [Documentation]    This keyword is used to Send the Transaction Rates for approval and approve it with different user
    ...    @author: ritragel
    ...    @update: clanding    13AUG2020    - added screenshot; updated hard coded values to global variables
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${WORKFLOW_TAB}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingWindow_WorkflowTab
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    ${SEND_TO_RATE_APPROVAL_STATUS}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingWindow_WorkflowTab_Approval
    
     
Approve Rate Setting Notice
    [Documentation]    This keyword is used to Approved Rate Setting Notice
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    Workflow  
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Rate Approval 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Generate Rate Setting Notices
    [Documentation]    This keyword is used to Generate Rate Setting Notices
    ...    @author: ritragel
    ...    @update: bernchua    18MAR2019    Used keyword "Validate if Question or Warning Message is Displayed" for warning/question messages.
    [Arguments]    ${Customer_Legal_Name}    ${NoticeStatus}
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    Workflow  
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Generate Rate Setting Notices  
    Validate if Question or Warning Message is Displayed    
    mx LoanIQ activate window    ${LIQ_Notices_Window}   
    mx LoanIQ click    ${LIQ_Notices_OK_Button}      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_Rollover_Intent_Notice_Window}
    Mx LoanIQ Select String    ${LIQ_Notice_Information_Table}    ${Customer_Legal_Name}    
    mx LoanIQ click    ${LIQ_Rollover_EditHighlightedNotice_Button}       
    mx LoanIQ activate window    ${LIQ_Rollover_NoticeCreate_Window}
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=.*Notice created.*","displayed:=1").JavaEdit("text:=${Customer_Legal_Name}")    Verified_Customer    
    Should Be Equal As Strings    ${Customer_Legal_Name}    ${Verified_Customer}
    Log    ${Verified_Customer}    
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=.*Notice created.*","displayed:=1").JavaObject("tagname:=Group","text:=Status").JavaStaticText("text:=${NoticeStatus}")    Verified_Status    
    Should Be Equal As Strings    ${NoticeStatus}    ${Verified_Status}
    Log    ${Verified_Status} - Status is correct! 
    mx LoanIQ close window    ${LIQ_Rollover_NoticeCreate_Window}
    mx LoanIQ close window    ${LIQ_Rollover_Intent_Notice_Window} 
    
Release Loan Repricing
    [Documentation]    This keyword is used to Release Loan Repricing
    ...    @author: ritragel
    ...    @update:    15SEPT2020 Added Date argument for adding validation on double click on Release text.
    [Arguments]    ${sLoan_Repricingdate}=${EMPTY}
    Log    ${sLoan_Repricingdate}    
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    Workflow  
    Run Keyword If    '${sLoan_Repricingdate}'=='${EMPTY}'    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release
    ...    ELSE    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Release\t${sLoan_Repricingdate}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button} 
    
Compute F/X Rate and Percentage of Loan
    [Documentation]    This keyword will compute the fx rate and percentage of a facility
    ...    @author: mnanquil
    ...    10/23/2018
    ...    @update: bernchua    28MAR2019    Update to divide by 100 the percentageOfFacility
    ...    @update: fmamaril    16MAY2019    L
    [Arguments]    ${facilityAmount}    ${fxRate}        ${percentageOfFacility}
    ${percentageOfFacility}    Evaluate    ${percentageOfFacility}/100
    ${fxRate}    Convert To Number    ${fxRate}
    ${facilityAmount}    Convert To Number   ${facilityAmount}
    ${totalFacilityAmount}    Evaluate    ${facilityAmount}/${fxRate}
    ${totalFacilityAmount}    Evaluate    "%.2f" % ${totalFacilityAmount}
    ${totalPercentageFacility}    Evaluate    ${totalFacilityAmount}*${percentageOfFacility} 
    ${totalPercentageFacility}    Evaluate    "%.2f" % ${totalPercentageFacility}
    ${totalFacilityAmount}    Convert Number With Comma Separators    ${totalFacilityAmount}
    ${totalPercentageFacility}    Convert Number With Comma Separators    ${totalPercentageFacility}
    [Return]    ${totalFacilityAmount}    ${totalPercentageFacility}

Validate Amounts in Facility Currency
    [Documentation]    This keyword will validate the values in facility currency section of currency tab
    ...    @author: mnanquil
    ...    10/23/2018
    [Arguments]    ${currentAmount}    ${hostBankGross}
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Rollover/Conversion.*").JavaStaticText("attached text:=${currentAmount}")    VerificationData="Yes"
    # Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Rollover/Conversion.*").JavaStaticText("attached text:=${hostBankGross}", "height:=131")
    mx LoanIQ select    ${LIQ_PendingRollover_Exit_Submenu}                      
    
Create Repayment Schedule - Loan Repricing
    [Documentation]    This keyword is used to input Loan Drawdown details in the General tab including Accrual End Date
    ...    @author: ritragel
    mx LoanIQ activate window    ${LIQ_PendingRollover_Window}
    mx LoanIQ select    ${LIQ_Rollover_Options_RepaymentSchedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}   
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    Mx LoanIQ Verify Object Exist    ${LIQ_RepaymentSchedule_CurrentSchedule_POBM_Text}        VerificationData="Yes"
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Reschedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate Loan Repayment Schedule Types
    mx LoanIQ enter    ${LIQ_RepaymentSchedule_ScheduleType_FPPI_RadioButton}    ON
    mx LoanIQ click    ${LIQ_RepaymentSchedule_ScheduleType_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

Navigate to Workflow and Review Repayment Schedule
    [Documentation]    This keyword will navigate to workflow tab and review the repayment schedule
    ...    @authro: ritragel
    mx LoanIQ activate window    ${LIQ_PendingRollover_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PendingRollover_Tab}    Workflow
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingRollover_Workflow_JavaTree}    Review Schedule%s    
    Run Keyword If    '${status}'=='True'    Review Repayment Schedule
    Run Keyword If    '${status}'=='False'    mx LoanIQ close window    ${LIQ_PendingRollover_Window} 

Review Repayment Schedule
    [Documentation]    This keyword will review the repayment schedule
    ...    @author: ritragel
    Mx LoanIQ DoubleClick    ${LIQ_PendingRollover_Workflow_JavaTree}    Review Schedule
    mx LoanIQ activate window    ${LIQ_RepaymentSchedule_Window}
    mx LoanIQ select    ${LIQ_RepaymentSchedule_Options_Resynchronize}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Save_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_RepaymentSchedule_Exit_Button}
    mx LoanIQ activate window    ${LIQ_PendingRollover_Window}
    mx LoanIQ close window    ${LIQ_PendingRollover_Window}
    
Set RolloverConversion Notebook General Details
    [Documentation]    Low-level keyword used to set the General tab details in the Rollover/Conversion Notebook
    ...                This keyword will return the 'Effective Date' and 'Loan_Alias' to be used in succeeding validations/transactions.
    ...                @author: bernchua    26AUG2019    Initial create
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    ...    @update: dahijara    25AUG2020    Added steps for saving. Added post processing and screenshot.
    [Arguments]    ${sRequested_Amount}    ${sRepricing_Frequency}    ${sRunVar_Effective_Date}=None    ${sRunVar_Loan_Alias}=None
    
    ### GetRuntime Keyword Pre-processing ###
    ${Requested_Amount}    Acquire Argument Value    ${sRequested_Amount}
    ${Repricing_Frequency}    Acquire Argument Value    ${sRepricing_Frequency}

    mx LoanIQ activate window    ${LIQ_RolloverConversion_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_RolloverConversion_Tab}    General
    mx LoanIQ enter    ${LIQ_RolloverConversion_RequestedAmt_Textfield}    ${Requested_Amount}
    Verify If Warning Is Displayed
    Mx LoanIQ Select Combo Box Value    ${LIQ_RolloverConversion_RepricingFrequency_List}    ${Repricing_Frequency}
    ${Effective_Date}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_EffectiveDate_Textfield}    value%date
    ${Loan_Alias}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_Alias_Textfield}    value%alias
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RolloverConversion

    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Effective_Date}    ${Effective_Date}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Loan_Alias}    ${Loan_Alias}
    [Return]    ${Effective_Date}    ${Loan_Alias}
    
Set RolloverConversion Notebook Rates
    [Documentation]    Low-level keyword used to go to the Rollover/Conversion Notebook - Rates Tab, set and validate the Rates.
    ...                @author: bernchua    26AUG2019    Initial create
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    ...    @update: dahijara    25AUG2020    Added screenshot.
    [Arguments]    ${sBorrower_BaseRate}    ${sAcceptRateFromPricing}=N
    
    ### GetRuntime Keyword Pre-processing ###
    ${Borrower_BaseRate}    Acquire Argument Value    ${sBorrower_BaseRate}
    ${AcceptRateFromPricing}    Acquire Argument Value    ${sAcceptRateFromPricing}

    mx LoanIQ activate window    ${LIQ_RolloverConversion_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_RolloverConversion_Tab}    Rates
    mx LoanIQ click    ${LIQ_RolloverConversion_BaseRate_Button}
    Verify If Warning Is Displayed
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RolloverConversion_BaseRate
    Set Base Rate Details    ${Borrower_BaseRate}    ${AcceptRateFromPricing}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RolloverConversion_BaseRate
    
Close RolloverConversion Notebook
    [Documentation]    Low-level keyword used to save and exit the Rollover/Conversion Notebook window.
    ...                @author: bernchua    27AGU2019    Initial create
    ...                @update: sahalder    25JUN2020    Added steps to handle warning/information
    mx LoanIQ activate window    ${LIQ_RolloverConversion_Window}    
    Save Notebook Transaction    ${LIQ_RolloverConversion_Window}    ${LIQ_RolloverConversion_Save_Menu}
    mx LoanIQ select    ${LIQ_RolloverConversion_FileExit_Menu}
    Verify If Warning Is Displayed
    Verify If Information Message is Displayed

Navigate from Rollover to Repayment Schedule
    [Documentation]    Keyword used to navigate the Rollover/Conversion Notebook to the Repayment Schedule
    ...                @author: bernchua    10SEP219    Initial create
    mx LoanIQ activate window    ${LIQ_RolloverConversion_Window}
    mx LoanIQ select    ${LIQ_Rollover_Options_RepaymentSchedule}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Set Payments for Loan Details
    [Documentation]    This keyword will set the data and validates it in the "Payments for Loan" window for Loan Repricing
    ...                This also returns the Principal, Interest and Total amounts
    ...                @author: bernchua    11SEP2019    Initial create
    ...                @update: bernchua    19SEP2019    Added arguments for amounts from Excel to be validated to UI amounts.
<<<<<<< HEAD
    ...                @update: aramos      17SEP2020    Added Decimal Suppresion on Evaluating Computed_TotalAmount
=======
>>>>>>> 44d21b76efb2bcbee497e6cad77d7a2fd9b6ac5f
    [Arguments]    ${sPrincipal_Amount}    ${sInterest_Amount}    ${sTotalPayment_Amount}
    mx LoanIQ activate window    ${LIQ_PaymentsForLoan_Window}
    ${UI_PrincipalAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PaymentsForLoan_JavaTree}    Principal%Amount Due%principal
    ${UI_InterestAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PaymentsForLoan_JavaTree}    Interest%Amount Due%interest
    ${Principal_Amount}    Remove Comma and Convert to Number    ${UI_PrincipalAmount}
    ${Interest_Amount}    Remove Comma and Convert to Number    ${UI_InterestAmount}
<<<<<<< HEAD
    
    Log     ${Principal_Amount}
    Log     ${Interest_Amount}
    ${Computed_TotalAmount}    Evaluate    ${Principal_Amount}+${Interest_Amount}
    ${StringComputed_TotalAmount}    Convert To String      ${Computed_TotalAmount}
    ${Computed_TotalAmount}    Convert To Number    ${StringComputed_TotalAmount}    2
    Log    ${Computed_TotalAmount}

=======
    ${Computed_TotalAmount}    Evaluate    ${Principal_Amount}+${Interest_Amount}
>>>>>>> 44d21b76efb2bcbee497e6cad77d7a2fd9b6ac5f
    ${Computed_TotalAmount}    Convert Number With Comma Separators    ${Computed_TotalAmount}
    ${VALIDATE_PrincipalAmount}    Run Keyword And Return Status    Should Be Equal    ${UI_PrincipalAmount}    ${sPrincipal_Amount}
    ${VALIDATE_InterestAmount}    Run Keyword And Return Status    Should Be Equal    ${UI_InterestAmount}    ${sInterest_Amount}
    ${VALIDATE_TotalAmount}    Run Keyword And Return Status    Should Be Equal    ${Computed_TotalAmount}    ${sTotalPayment_Amount}
    Run Keyword If    ${VALIDATE_PrincipalAmount}==True    Log    Principal Amount is validated
    ...    ELSE    Fail    Principal Amount not validated successfully
    Run Keyword If    ${VALIDATE_InterestAmount}==True    Log    Interest Amount is validated
    ...    ELSE    Fail    Interest Amount not validated successfully
    Run Keyword If    ${VALIDATE_TotalAmount}==True    Log    Total Amount is validated
    ...    ELSE    Fail    Total Amount not validated successfully
    Mx LoanIQ Set    ${LIQ_PaymentsForLoan_Interest_Checkbox}    ON
    Mx LoanIQ Set    ${LIQ_PaymentsForLoan_Principal_Checkbox}    ON
    Run Keyword If    ${VALIDATE_PrincipalAmount}==True and ${VALIDATE_InterestAmount}==True and ${VALIDATE_TotalAmount}==True    mx LoanIQ enter    ${LIQ_PaymentsForLoan_Amount_Textfield}    ${sTotalPayment_Amount}
    ...    ELSE    Fail    Payment amount cannot be entered because amounts validation failed.
    Take Screenshot    PaymentsForLoan-Window
    mx LoanIQ click    ${LIQ_PaymentsForLoan_Create_Button}
    Return From Keyword If    ${VALIDATE_PrincipalAmount}==True and ${VALIDATE_InterestAmount}==True and ${VALIDATE_TotalAmount}==True    ${UI_PrincipalAmount}    ${UI_InterestAmount}    ${Computed_TotalAmount}
    
Set Spread Details for Conversion
    [Documentation]    This keyword modifies the spread data of the Rollover Notebook
    ...                @author: fmamaril    12SEP2019    Initial create
    [Arguments]    ${iSpread}
    mx LoanIQ click    ${LIQ_RolloverConversion_Spread_Button}
    mx LoanIQ activate window    ${LIQ_OverrideSpread_Window}
    mx LoanIQ enter    ${LIQ_InitialDrawdown_SpreadRate_TextField}    ${iSpread}
    mx LoanIQ click    ${LIQ_InitialDrawdown_SpreadRate_OKButton}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}


Navigate to Rollover Conversion Notebook Workflow
    [Documentation]    This keyword navigates the Workflow tab of Rollover Conversion Notebook, and does a specific transaction.
    ...    
    ...    | Arguments |
    ...    
    ...    'Notebook_Locator' = Locator of the main Notebook window
    ...    'NotebookTab_Locator' = JavaTab locator of the Notebook
    ...    'NotebookWorkflow_Locator' = JavaTree locator of the Workflow object.
    ...    'Transaction' = The type of transaction listed under Workflow. Ex. Send to Approval, Approve, Release
    
    ...    @author: sahalder    24JUN2020    - initial create
    
    [Arguments]    ${sTransaction}    ${sScreenshot_Name}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}
    ${Screenshot_Name}    Acquire Argument Value    ${sScreenshot_Name}
    
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/${sScreenshot_Name}

Set FX Rates Rollover or Conversion
    [Documentation]    This keyword set the FX rates of USD Rollover or Conversion from workflow before Rate Approval
    ...    @author: dahijara    27AUG2019    - Initial Keyword
    [Arguments]    ${sCurrency}
    ### GetRuntime Keyword Pre-processing ###
    ${Currency}    Acquire Argument Value    ${sCurrency}

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    Workflow   
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    Set F/X Rate
    mx LoanIQ activate window    ${LIQ_FacilityCurrency_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    mx LoanIQ click    JavaWindow("title:=Facility Currency.*","displayed:=1").JavaButton("attached text:=Use Facility.*to ${sCurrency} Rate")
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow
    mx LoanIQ click    ${LIQ_FacilityCurrency_Facility_Rate_Ok_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InitialDrawdown_Workflow