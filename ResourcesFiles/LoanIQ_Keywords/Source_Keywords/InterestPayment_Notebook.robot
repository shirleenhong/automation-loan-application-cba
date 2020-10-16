*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 

Navigate to the Scheduled Activity Filter
    [Documentation]    This keyword directs the LIQ User to the Scheduled Activity Filter window.
    ...    @author: rtarayao
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards and added take screenshot
    
    Select Actions    [Actions];Work In Process
    Mx LoanIQ Activate Window    ${LIQ_TransactionInProcess_Window}    
    Mx LoanIQ Select    ${LIQ_TransactionsInProcess_Queries_ScheduledActivity}
    Mx LoanIQ Activate Window    ${LIQ_ScheduledActivityFilter_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ScheduledActivityFilterWindow

Open Scheduled Activity Report
    [Documentation]    This keyword opens the Loan from Scheduled Activity Report window. 
    ...    @author: rtarayao
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    [Arguments]    ${sScheduledActivity_FromDate}     ${sScheduledActivity_ThruDate}    ${sDeal_Name}
    
    ### Keyword Pre-processing ###
    ${ScheduledActivity_FromDate}    Acquire Argument Value    ${sScheduledActivity_FromDate}
    ${ScheduledActivity_ThruDate}    Acquire Argument Value    ${sScheduledActivity_ThruDate}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    Mx LoanIQ Activate Window    ${LIQ_ScheduledActivityFilter_Window}
    Mx LoanIQ Enter    ${LIQ_ScheduledActivityFilter_From_Datefield}    ${ScheduledActivity_FromDate}
    Mx LoanIQ Enter    ${LIQ_ScheduledActivityFilter_Thru_Datefield}    ${ScheduledActivity_ThruDate}    
    Mx LoanIQ Click    ${LIQ_ScheduledActivityFilter_Deal_Button}
    Mx LoanIQ Activate Window    ${LIQ_DealSelect_Window}
    Mx LoanIQ Enter    ${LIQ_DealSelect_DealIdentifyBy_Textfield}    ${Deal_Name}        
    Mx LoanIQ Click    ${LIQ_DealSelect_Search_Button}    
    Mx LoanIQ Activate Window    ${LIQ_DealListByName_Results_Window}
    Mx LoanIQ DoubleClick    ${LIQ_DealListByName_Search_Result}    ${Deal_Name}       
    Mx LoanIQ Activate Window    ${LIQ_ScheduledActivityFilter_Window}  
    Mx LoanIQ Click    ${LIQ_ScheduledActivityFilter_OK_Button}
    Mx LoanIQ Activate Window    ${LIQ_ScheduledActivityReport_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ScheduledActivityReportWindow

Open Loan Notebook
    [Documentation]    This keyword opens the Loan from Scheduled Activity Report window. 
    ...    @author: rtarayao
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    [Arguments]    ${sScheduledActivityReport_Date}    ${sScheduledActivityReport_ActivityType}    ${sDeal_Name}    ${sLoan_Alias}
     
    ### Keyword Pre-processing ###
    ${ScheduledActivityReport_Date}    Acquire Argument Value    ${sScheduledActivityReport_Date}
    ${ScheduledActivityReport_ActivityType}    Acquire Argument Value    ${sScheduledActivityReport_ActivityType}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    Mx LoanIQ Activate Window    ${LIQ_ScheduledActivityReport_Window}
    Mx LoanIQ Click   ${LIQ_ScheduledActivityReport_CollapseAll_Button}             
    Mx Loaniq Expand    ${LIQ_ScheduledActivityReport_List}    ${ScheduledActivityReport_Date}
    Mx Loaniq Expand    ${LIQ_ScheduledActivityReport_List}    ${ScheduledActivityReport_Date};${ScheduledActivityReport_ActivityType}  
    Mx LoanIQ Click Javatree Cell   ${LIQ_ScheduledActivityReport_List}    ${Loan_Alias}%${Loan_Alias}%Alias
    Mx Native Type    {ENTER}
    Mx LoanIQ Activate Window    ${LIQ_Loan_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/LoanWindow
  
Initiate Loan Interest Payment
    [Documentation]    This keyword initiates the payment of Loan Interest.
    ...    This keyword also validates the Projected Cycle Due of the Loan Interest.
    ...    Updated the script to add for loop on the Loan Cycles.
    ...    @author: rtarayao
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...    @update: amansuet                 - fixed hardcoded locators
    [Arguments]    ${sCycleNumber}    ${sPro_Rate}

    ### Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    ${Pro_Rate}    Acquire Argument Value    ${sPro_Rate}

    Mx LoanIQ Activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select    ${LIQ_Loan_Options_Payment}
    Mx LoanIQ Activate window    ${LIQ_Loan_ChoosePayment_Window}
    Mx LoanIQ Enter    ${LIQ_Loan_ChoosePayment_InterestPayment_RadioButton}    ON
    Mx LoanIQ Click    ${LIQ_Loan_ChoosePayment_OK_Button}
    Mx LoanIQ Activate Window    ${LIQ_Loan_CyclesforLoan_Window}

    ${Pro_Rate}    Replace Variables    ${Pro_Rate}
    ${LIQ_Loan_CyclesforLoan_ProRateType_RadioButton}    Replace Variables    ${LIQ_Loan_CyclesforLoan_ProRateType_RadioButton}
    Mx LoanIQ Enter    ${LIQ_Loan_CyclesforLoan_ProRateType_RadioButton}    ON

    Get Loan Interest Cycle Dates    ${CycleNumber}
    Mx LoanIQ Click    ${LIQ_Loan_CyclesforLoan_OK_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}     
    Mx LoanIQ Activate Window    ${LIQ_Payment_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/InterestPaymentWindow

Initiate Loan Interest Payment (Scenario 8)
    [Documentation]    This keyword starts the payment of Loan Interest.
    ...    This keyword also validates the Projected Cycle Due of the Loan Interest.
    ...    @author: rtarayao
    ...    <update> @ghabal - commented 'Validate Loan Interest Projected Due' since the projected due date is not equal to cycle due date for Scenario 8
    [Arguments]    ${rowid}    ${CycleNumber}    ${Pro_Rate}

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ select    ${LIQ_Loan_Options_Payment}
    mx LoanIQ activate window    ${LIQ_Loan_ChoosePayment_Window}
    mx LoanIQ enter    ${LIQ_Loan_ChoosePayment_InterestPayment_RadioButton}    ON
    mx LoanIQ click    ${LIQ_Loan_ChoosePayment_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_Loan_CyclesforLoan_Window}   
    mx LoanIQ enter    JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=${Pro_Rate}")    ON
    Sleep    5s    
    mx LoanIQ click    ${LIQ_Loan_CyclesforLoan_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    mx LoanIQ activate window    ${LIQ_Payment_Window}

Validate Interest Repayment Details
    [Documentation]    This keyword validates the interest repayment details for a Fixed Principal and Interest type of payment.
    ...    @author: rtarayao
    [Arguments]    ${Deal_Name}    ${Facility_Name}    ${Loan_Borrower}    ${Loan_Alias}    ${Int_RepaymentEffectiveDate}    ${Computed_LoanIntProjectedCycleDue}
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Pending.* Payment.*")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*","displayed:=1").JavaStaticText("attached text:=${Deal_Name}")      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*","displayed:=1").JavaStaticText("attached text:=${Facility_Name}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*","displayed:=1").JavaStaticText("attached text:=${Loan_Borrower}")        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*","displayed:=1").JavaStaticText("attached text:=${Loan_Alias}")                  VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Payment_CashflowFromBorrower_RadioButton}    From Borrower 
    ${Int_EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_Payment_EffectiveDate_Textfield}    value
    Log    ${Int_EffectiveDate}
    Should Be Equal    ${Int_RepaymentEffectiveDate}    ${Int_EffectiveDate}
    Log    ${Int_RepaymentEffectiveDate} - Interest Repayment Effective Date from excel.
    Log    ${Int_EffectiveDate} - Interest Effective Date from UI.        
    
    ${Int_RequestedAmount}    Mx LoanIQ Get Data    ${LIQ_Payment_RequestedAmount_Textfield}    value
    ${Int_RequestedAmount}    Remove String    ${Int_RequestedAmount}    ,
    ${Int_RequestedAmount}    Convert To Number    ${Int_RequestedAmount}    2
    ${Int_RequestedAmount}    Evaluate    "%.2f" % ${Int_RequestedAmount}        
    Should Be Equal As Numbers    ${Computed_LoanIntProjectedCycleDue}    ${Int_RequestedAmount} 
    Log    ${Computed_LoanIntProjectedCycleDue} - Calculated Interest value coming from excel
    Log    ${Int_RequestedAmount} - Interest value from UI                
    
    Mx LoanIQ Close    ${LIQ_Payment_Window}
    mx LoanIQ activate window    ${LIQ_Repayment_Window}         

Validate Loan Interest Projected Due
    [Documentation]    This keyword checks the accuracy of the Loan Interest Projected Cycle Due.
    ...    @author: rtarayao
    [Arguments]    ${Computed_LoanIntProjectedCycleDue}    ${CycleNumber}
         
    ${UI_ProjectedCycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_CyclesforLoan_List}    ${CycleNumber}%Projected Cycle Due%test  
    ${UI_ProjectedCycleDue}    Remove String    ${UI_ProjectedCycleDue}    ,
    ${UI_ProjectedCycleDue}    Convert To Number    ${UI_ProjectedCycleDue}    2
    ${UI_ProjectedCycleDue}    Evaluate    "%.2f" % ${UI_ProjectedCycleDue}    
    Log    ${UI_ProjectedCycleDue} = This data is from the UI.    
    Log    ${Computed_LoanIntProjectedCycleDue}= This data is retrieved from Excel. 
    
    Should Be Equal    ${Computed_LoanIntProjectedCycleDue}    ${UI_ProjectedCycleDue}      

Get Loan Interest Cycle Dates
    [Documentation]    This keyword writes and saves the Loan Interest Cycle Dates in Excel. 
    ...    @author: rtarayao
    [Arguments]    ${CycleNumber} 
      
    ${UI_InterestCycleDueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_CyclesforLoan_List}    ${CycleNumber}%Due Date%test  
    ${UI_InterestCycleStartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_CyclesforLoan_List}    ${CycleNumber}%Start Date%test  
    
Compute Interest Payment Amount Per Cycle - Zero Cycle Due
    [Documentation]    This keyword is used in computing the first Projected Cycle Due of the Interest Payment and saves it to Excel.
    ...    @author: rtarayao
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards, removed unused keywords, added take screenshot and added keyword pre-processing  
    [Arguments]    ${sCycleNumber}    ${sSystemDate}    ${sRuntime_Variable}=None
    
    ### Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    ${SystemDate}    Acquire Argument Value    ${sSystemDate}

    Mx LoanIQ Activate    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/LoanWindow_GeneralTab
    ${PrincipalAmount}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Amount}    value%test
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Rates
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_Loan_AllInRate}    value%test
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_Loan_RateBasis_Dropdownlist}    value%test
    ${PrincipalAmount}    Remove String    ${PrincipalAmount}    ,
    ${PrincipalAmount}    Convert To Number    ${PrincipalAmount}
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Integer    ${RateBasis}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ${CycleDue}    Evaluate Interest Fee - Zero Cycle Due    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}    ${SystemDate}
    Log    ${CycleDue}
    ${CycleDue}    Convert To Number    ${CycleDue}    2
    ${CycleDue}    Evaluate    "%.2f" % ${CycleDue}

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${CycleDue}

    [Return]    ${CycleDue}

Compute Interest Payment Amount Per Cycle
    [Documentation]    This keyword is used in computing the first Projected Cycle Due of the Interest Payment and saves it to Excel.
    ...    @author: rtarayao
    ...    @update: rtarayao    17OCT2019    -     
    ...    @update: dahijara    06JUL2020    - Added keywords for Pre and Post processing and keyword for taking screenshot. Added optional argument for runtime variable
    [Arguments]    ${sCycleNumber}    ${sRunVar_ProjectedCycleDue}=None

    ### GetRuntime Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}    
    mx LoanIQ activate    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    General
    ${PrincipalAmount}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Amount}    value%test
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Rates
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_Loan_AllInRate}    value%test
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_Loan_RateBasis_Dropdownlist}    value%test
    ${PrincipalAmount}    Remove String    ${PrincipalAmount}    ,
    ${PrincipalAmount}    Convert To Number    ${PrincipalAmount}
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Integer    ${RateBasis}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    # ${ProjectedCycleDue}    Run Keyword If    '${Cycle}'=='Weekly'    Evaluate Interest Fee for Weekly Cycle    ${PrincipalAmount}    ${Rate}    ${RateBasis}
    # ...    ELSE IF    '${Cycle}'=='Quarterly'    Evaluate Issuance Fee for Quarterly Cycle    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${StartDate}
    ${ProjectedCycleDue}    Evaluate Interest Fee    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}
    Log    ${ProjectedCycleDue}
    ${ProjectedCycleDue}    Convert To Number    ${ProjectedCycleDue}    2
    ${ProjectedCycleDue}    Evaluate    "%.2f" % ${ProjectedCycleDue}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_GlobalCurrent

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_ProjectedCycleDue}    ${ProjectedCycleDue}
    [Return]    ${ProjectedCycleDue}

Evaluate Interest Fee - Zero Cycle Due
    [Documentation]    This keyword evaluates the FIRST Projected Cycle Due on a 'Weekly' cycle.
    ...    @author: rtarayao
    ...    @updated: modify computation to compute cycle due - use system date
    [Arguments]    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}    ${SystemDate}
    ${StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${CycleNumber}%Start Date%Start Date
    ${DueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${CycleNumber}%Due Date%Due Date
    Log    ${StartDate}
    Log    ${DueDate}
    ${SystemDate}    Convert Date    ${SystemDate}     date_format=%d-%b-%Y    
    ${StartDate}    Convert Date    ${StartDate}     date_format=%d-%b-%Y
    ${DueDate}    Convert Date    ${DueDate}     date_format=%d-%b-%Y    
    # ${Numberof Days}    Subtract Date From Date    ${EndDate}    ${StartDate}    verbose 
    # Log    ${Numberof Days}
    ${Numberof Days1}    Subtract Date From Date    ${SystemDate}    ${StartDate}    verbose
    ${Numberof Days2}    Subtract Date From Date    ${DueDate}    ${StartDate}    verbose
    # ${Numberof Days}    Remove String    ${Numberof Days}     days
    # ${Numberof Days}    Convert To Number    ${Numberof Days}
    # ${Numberof Days}   Evaluate    ${Numberof Days} + 1           
    Log    ${Numberof Days1}
    Log    ${Numberof Days2}
    ${Numberof Days1}    Remove String    ${Numberof Days1}     days    seconds    day
    ${Numberof Days1}    Convert To Number    ${Numberof Days1}
    ${Numberof Days2}    Remove String    ${Numberof Days2}     days    seconds    day
    ${Numberof Days2}    Convert To Number    ${Numberof Days2}
    ${Numberof Days}   Run Keyword If    ${Numberof Days1} >= ${Numberof Days2}    Set Variable     ${Numberof Days2}    
    ...    ELSE IF    ${Numberof Days1} < ${Numberof Days2}    Set Variable    ${Numberof Days1}                     
    ${CycleDue}    Evaluate    (((${PrincipalAmount})*(${Rate}))*(${Numberof Days}))/${RateBasis}
    ${CycleDue}    Convert To Number    ${CycleDue}    2
    [Return]    ${CycleDue} 

Evaluate Interest Fee
    [Documentation]    This keyword evaluates the FIRST Projected Cycle Due on a 'Weekly' cycle.
    ...    @author: fmamaril
    [Arguments]    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}
    ${StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${CycleNumber}%Start Date%Start Date
    ${EndDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${CycleNumber}%End Date%End Date
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
    # ${Time}    Convert To Integer    ${Time}
    ${ProjectedCycleDue}    Evaluate    (((${PrincipalAmount})*(${Rate}))*(${Numberof Days}))/${RateBasis}
    ${ProjectedCycleDue}    Convert To Number    ${ProjectedCycleDue}    2
    [Return]    ${ProjectedCycleDue} 
   
Input Effective Date and Requested Amount for Loan Interest Payment
    [Documentation]    This keyword inputs the Effective date for the Loan Interest Payment.
    ...    @author: rtarayao
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    [Arguments]    ${sInterestPayment_EffectiveDate}    ${sPayment_Amount}
    
    ### Keyword Pre-processing ###
    ${InterestPayment_EffectiveDate}    Acquire Argument Value    ${sInterestPayment_EffectiveDate}
    ${Payment_Amount}    Acquire Argument Value    ${sPayment_Amount}

    Mx LoanIQ Activate Window    ${LIQ_Payment_Window}  
    Mx LoanIQ Enter    ${LIQ_Payment_RequestedAmount_Textfield}    ${Payment_Amount}    
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_OK_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Enter    ${LIQ_Payment_EffectiveDate_Textfield}    ${InterestPayment_EffectiveDate}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button} 
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/InterestPaymentWindow
    Mx LoanIQ Select    ${LIQ_Payment_File_Save}
    
    :FOR    ${i}    IN RANGE    3
    \    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    \    ${status}    Run Keyword And Return Status    Validate Warning Message Box          
    \    Exit For Loop If    ${status}==False
    
Validate Loan Interest Payment Details
    [Documentation]    This keyword validates the Loan Interest Payment details.
    ...    @author: rtarayao
    [Arguments]    ${Deal_Name}    ${Facility_Name}    ${Loan_Borrower}    ${Loan_Alias}    ${Loan_InterestCycleDueDate}    ${Loan_InterestCycleStartDate}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Deal_Name}")      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Facility_Name}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Loan_Borrower}")        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Loan_Alias}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Loan_InterestCycleDueDate}", "index:=1")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Loan_InterestCycleStartDate}")     VerificationData="Yes"
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Payment_CashflowFromBorrower_RadioButton}    From Borrower

Generate Intent Notices for Payment
    [Documentation]    This keyword sends Payment Notices to the Borrower and Lender.
    ...    @author: rtarayao
    [Arguments]    ${LIQCustomer_ShortName}    ${Contact_Email}   

    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
     
    :FOR    ${i}    IN RANGE    1
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}        VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False
    
    mx LoanIQ activate window    ${LIQ_Notice_PaymentIntentNotice_Window}
    ${NoticeStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Notice_PaymentIntentNotice_Information_Table}    ${LIQCustomer_ShortName}%Status%test    
    Log    ${NoticeStatus}
    
    mx LoanIQ click    ${LIQ_Notice_PaymentIntentNotice_EditHighlightedNotice_Button}
    mx LoanIQ activate window    ${LIQ_Notice_PaymentIntentNotice_Edit_Window}   
    ${ContactEmail}    Mx LoanIQ Get Data    ${LIQ_Notice_PaymentIntentNotice_Edit_Email}    value%test
    Log    ${ContactEmail}
    Should Be Equal    ${Contact_Email}    ${ContactEmail}          
    mx LoanIQ activate window    ${LIQ_Notice_PaymentIntentNotice_Edit_Window}
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=.*Notice created.*").JavaEdit("text:=${LIQCustomer_ShortName}")    Verified_Customer    
    Should Be Equal As Strings    ${LIQCustomer_ShortName}    ${Verified_Customer}
    Log    ${Verified_Customer}    
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=.*Notice created.*").JavaStaticText("attached text:=${NoticeStatus}")    Verified_Status    
    Should Be Equal As Strings    ${NoticeStatus}    ${Verified_Status}
     
    mx LoanIQ close window    ${LIQ_Notice_PaymentIntentNotice_Edit_Window}  
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
         
    mx LoanIQ click    ${LIQ_Notice_PaymentIntentNotice_Exit_Button}
          
    mx LoanIQ click element if present    ${LIQ_Notice_Exit_Button}
        
Generate Intent Notices of an Interest Payment
    [Documentation]    This keyword generates Intent Notices of an Interest Payment
    ...    @author: ghabal    
    [Arguments]    ${LIQCustomer_ShortName}    ${Contact_Email}    ${Lender_LegalName}    ${InterestPaymentNotice_Status}   

    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}    
        
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    ${NoticeStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Notice_Information_Table}    ${LIQCustomer_ShortName}%Status%test    
    Log    ${NoticeStatus}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Notice_Information_Table}    ${LIQCustomer_ShortName}%s 
    
    mx LoanIQ click    ${LIQ_Notice_EditHighlightedNotice_Button}
    mx LoanIQ activate window    ${LIQ_Notice_IntentNotice_Window}   
    ${ContactEmail}    Mx LoanIQ Get Data    ${LIQ_Notice_IntentNotice_Email}    value%test
    Log    ${ContactEmail}
    Should Be Equal    ${Contact_Email}    ${ContactEmail}          
    mx LoanIQ activate window    ${LIQ_Notice_IntentNotice_Window}
    
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=Interest Payment Notice created.*","displayed:=1").JavaEdit("text:=${Lender_LegalName}")    Verified_Customer    
    Should Be Equal As Strings    ${Lender_LegalName}    ${Verified_Customer}
    Log    ${Verified_Customer}    
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=Interest Payment Notice created.*","displayed:=1").JavaObject("tagname:=Group","text:=Status").JavaStaticText("text:=${InterestPaymentNotice_Status}")    Verified_Status    
    Should Be Equal As Strings    ${InterestPaymentNotice_Status}    ${Verified_Status}
    Log    ${Verified_Status} - Status is correct!
        
    mx LoanIQ select    ${LIQ_InterestPayment_Notice_FileMenu_PreviewMenu}
    Sleep    3s        
    Take Screenshot
    Sleep    3s
    mx LoanIQ select    ${LIQ_SBLC_NoticePreview_FileMenu_ExitMenu}
        
    mx LoanIQ close window    ${LIQ_InterestPayment_Notice_Email_Window}
    mx LoanIQ click    ${LIQ_InterestPayment_Notice_Exit_Button}

Send Loan Payment to Approval
    [Documentation]    This keyword is used to Send the Loan Payment for Approval.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Send to Approval%s
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Send to Approval
                 
     :FOR    ${i}    IN RANGE    2
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
     
     Run Keyword And Continue On Failure    Verify Window    ${LIQ_Payment_AwaitingApproval_Status_Window} 

Send Interest Payment to Approval
    [Documentation]    This keyword is used to Send the Loan Payment for Approval.
    ...    @author: rtarayao
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards and added take screenshot
    
    Mx LoanIQ Activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Send to Approval%s
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Send to Approval
                 
    Run Keyword And Ignore Error    Repeat Keyword    3    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
     
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_Payment_AwaitingApproval_Status_Window} 
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AwaitingApprovalStatusWindow

Send Loan Interest Payment to Approval
    [Documentation]    This keyword is used to Send the Loan Payment for Approval.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Send to Approval%s
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Send to Approval
                 
     :FOR    ${i}    IN RANGE    2
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
     
     Run Keyword And Continue On Failure    Verify Window    ${LIQ_Payment_AwaitingApproval_Status_Window} 

Send Loan Interest Payment to Approval (Scenario 8)
    [Documentation]    This keyword is used to Send the Loan Payment for Approval.
    ...    @author: rtarayao
    ...    <update> @ghabal - updated keyword to accomodate new locators for Interest Payment window
    
    mx LoanIQ activate    ${LIQ_InterestPayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_InterestPayment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Interest_WorkflowItems}    Send to Approval%s
    Mx LoanIQ DoubleClick    ${LIQ_Interest_WorkflowItems}    Send to Approval
                 
     :FOR    ${i}    IN RANGE    2
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
     
     Run Keyword And Continue On Failure    Verify Window    ${LIQ_Payment_AwaitingApproval_Status_Window} 

Open Interest Payment Notebook via WIP - Awaiting Generate Intent Notices
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
    
Navigate to Interest Payment Intent Notices Window
    [Documentation]    This keyword sends Interest Payment Notices to the Borrower and Lender.
    ...    @author: rtarayao
    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    Run Keyword And Ignore Error    Repeat Keyword    4    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}         
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    mx LoanIQ activate window    ${LIQ_IntentNotice_Window}

Navigate to Interest Payment Workflow Tab
    [Documentation]    This keyword navigates the LIQ User to the Payment Workflow Tab.
    ...    @author: rtarayao
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow

Open Interest Payment Notebook via WIP - Awaiting Release
    [Documentation]    This keyword is used to open the Payment Notebook with an Awaiting Release Cashflow Status thru the LIQ WIP Icon.
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
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    
Open Interest Payment Notebook via WIP - Awaiting Release Cashflow
    [Documentation]    This keyword is used to open the Interest Payment Notebook with an Awaiting Release Cashflow Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingReleaseCashflowsStatus}    ${WIP_PaymentType}    ${Loan_Alias}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflowsStatus}         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseCashflowsStatus} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_Payment_Window}
    
Open Interest Payment Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    ...                                      - removed unused keywords
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingApprovalStatus}    ${sWIP_PaymentType}    ${sLoan_Alias}

    ### Keyword Pre-processing ###
    ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
    ${WIP_AwaitingApprovalStatus}    Acquire Argument Value    ${sWIP_AwaitingApprovalStatus}
    ${WIP_PaymentType}    Acquire Argument Value    ${sWIP_PaymentType}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    Mx LoanIQ Click    ${LIQ_WorkInProgress_Button}
    Mx LoanIQ Activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WorkInProgressWindow
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus} 

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  

    Mx LoanIQ Maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    Mx Native Type    {PGDN}

    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    
    Mx LoanIQ Close Window    ${LIQ_WorkInProgress_Window} 
    Mx LoanIQ Activate    ${LIQ_Payment_Window}

Open Loan Interest Payment Notebook via WIP - Awaiting Approval (Scenario 4)
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
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
    
    
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    
    mx LoanIQ activate    ${LIQ_Payment_Window}

Open Loan Interest Payment Notebook via WIP - Awaiting Release (Scenario 4)
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    ...    <update> ghabal - recreated keyword dedicated for Scenario 4
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingReleaseStatus}    ${WIP_PaymentType}    ${Loan_Alias}    
          
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    #Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window} 
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseStatus} 

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType}  
   
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_PaymentType} 
    Mx Native Type    {PGDN} 
    
    
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%d
    Sleep    3s  
  
    # Mx Close Window    ${LIQ_WorkInProgress_Window} 
    
    # Mx Activate    ${LIQ_Payment_Window}

Open Loan Interest Payment Notebook
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
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
    
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}
    Mx Native Type    {ENTER}
    
    # Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%s
    Sleep    3s  
  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    
    mx LoanIQ activate    ${LIQ_Payment_Window}

Approve Interest Payment
    [Documentation]    This keyword approves the Loan Interest Payment.
    ...    @author: rtarayao 
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards and added take screenshot

    Mx LoanIQ Activate Window    ${LIQ_Payment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/InterestPaymentWindow_WorkflowTab
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Approval%yes
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Approval
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Run Keyword And Ignore Error    Repeat Keyword    3    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}

Approve Interest Payment (Scenario 8)
    [Documentation]    This keyword approves the Loan Interest Payment.
    ...    @author: rtarayao
    ...    <update> @ghabal - updated keyword to accomodate new locators for Interest Payment window     
   
    mx LoanIQ activate window    ${LIQ_InterestPayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_InterestPayment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Interest_WorkflowItems}    Approval%yes 
    Mx LoanIQ DoubleClick    ${LIQ_Interest_WorkflowItems}    Approval  
   
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
    :FOR    ${i}    IN RANGE    2
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False  

Navigate to Interest Payment Notebook from Loan Notebook
    [Documentation]    This keyword navigates the User to the Interest Payment Notebook from the Loan Notebook.
    ...    @author: rtarayao 
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Loan_Events_List}    Interest Payment Released%d    
    mx LoanIQ activate window    ${LIQ_Payment_Window}

Validate Loan Events Tab after Interest Payment
    [Documentation]    This keyword validates the Loan Events tab after payment of the capitalized Ongoing fee.
    ...    @author: rtarayao
       
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Loan_Event_JavaTree}    Interest Payment Released%yes
   
Validate Interest Payment in Loan Accrual Tab
    [Documentation]    This keyword validates the payment made in the accrual tab.
    ...    @author: rtarayao
    ...    @update: amansuet    01JUN2020    - updated to align with automation standards, added take screenshot and added keyword pre-processing
    [Arguments]    ${sCycleNumber}    ${sComputed_LoanIntProjectedCycleDue}

    ### Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    ${Computed_LoanIntProjectedCycleDue}    Acquire Argument Value    ${sComputed_LoanIntProjectedCycleDue}

    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    
    ${PaidtoDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${CycleNumber}%Paid to date%test   
    ${PaidtoDate}    Remove String    ${PaidtoDate}    ,
    ${PaidtoDate}    Convert To Number    ${PaidtoDate}    2    
    Log    ${PaidtoDate}  
    Should Be Equal As Numbers    ${PaidtoDate}    ${Computed_LoanIntProjectedCycleDue}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/LoanWindow_AccrualTab
    Mx LoanIQ Activate Window    ${LIQ_Payment_Window}

Validate Interest Payment in Loan Accrual Tab - Paid Projected Cycle Due
    [Documentation]    This keyword validates the payment made in the accrual tab.
    ...    @author: rtarayao 
    [Arguments]    ${CycleNumber}    ${ProjectedCycleDue}
    
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    
    ${PaidtoDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${CycleNumber}%Paid to date%test
    ${PaidtoDate}    Remove String    ${PaidtoDate}    ,
    ${PaidtoDate}    Convert To Number    ${PaidtoDate}    2       
    Log    ${PaidtoDate}

         
    Should Be Equal As Numbers    ${ProjectedCycleDue}    ${PaidtoDate}
            
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    
Validate Interest Payment in Loan Accrual Tab (Scenario 4)
    [Documentation]    This keyword validates the payment made in the accrual tab.
    ...    @author: rtarayao 
    [Arguments]    ${Loan_CycleNumber}
    
    ${Computed_LoanIntProjectedCycleDue}    Read Data From Excel    SERV22_InterestPayments    Computed_LoanIntProjectedCycleDue    ${rowid} 
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    
    ${PaidtoDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${Loan_CycleNumber}%Paid to date%test
    ${PaidtoDate}    Remove String    ${PaidtoDate}    ,
    ${PaidtoDate}    Convert To Number    ${PaidtoDate}    2       
    Log    ${PaidtoDate}
    
    # ${CycleDue}    Mx LoanIQ Store RunTime Value By Colname    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${Loan_CycleNumber}%Cycle Due%test          tempExcelPath=${AppDetails_TempExcelPath}
    # Log    ${CycleDue}
         
    # Should Be Equal    ${Computed_LoanIntProjectedCycleDue}    ${PaidtoDate}
    # Should Be Equal    0.00    ${CycleDue}     
            
    mx LoanIQ activate window    ${LIQ_Payment_Window}  

Initiate Loan Interest Payment Details from Loan Notebook
    [Documentation]    This keyword initiates Loan Interest Payment Details from Loan Notebook
    ...    @author: ghabal
    ...    @update: jdelacru - added actions to select radio button in Cycles For Loan window
    Run Keyword And Continue On Failure    mx LoanIQ click element if present    ${LIQ_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_Loan_Options_Payment}
    mx LoanIQ activate window    ${LIQ_Loan_ChoosePayment_Window}    
    Mx LoanIQ Set    ${LIQ_Loan_ChoosePayment_InterestPayment_RadioButton}    ON
    mx LoanIQ click    ${LIQ_Loan_ChoosePayment_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_Loan_CyclesforLoan_Window}   
    mx LoanIQ enter    ${LIQ_Loan_CyclesforLoan_ProjectedDue_RadioButton}    ON
    mx LoanIQ click    ${LIQ_Loan_CyclesforLoan_OK_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Release Payment
    [Documentation]    This keyword is used to Release the Payment made.
    ...    @author: rtarayao
    ...    @update: cfrancis    - added clicking question button for confirming release
   
    mx LoanIQ activate    ${LIQ_Payment_Window}
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Release%yes
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Ignore Error    Repeat Keyword    3    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Run Keyword And Continue On Failure    Verify Window    ${LIQ_Payment_Released_Status_Window} 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_WorkflowItem_Null}        VerificationData="Yes"
    
Release Payment (Scenario 8)
    [Documentation]    This keyword is used to Release the Payment made.
    ...    @author: rtarayao
    ...    <update> @ghabal - updated keyword to accomodate new locators for Interest Payment window
    
    mx LoanIQ activate    ${LIQ_InterestPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InterestPayment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Interest_WorkflowItems}    Release%yes 
    Mx LoanIQ DoubleClick    ${LIQ_Interest_WorkflowItems}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    1
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False 
     Run Keyword And Continue On Failure    Verify Window    ${LIQ_Payment_Released_Status_Window}
     
     Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Payment_WorkflowItems_Release_Null}     VerificationData="Yes"
   
### Scenario 2 & 4
Initiate Loan Interest Payment - S2/S4
    [Documentation]    This keyword initiates the payment of Loan Interest.
    ...    This keyword also validates the Projected Cycle Due of the Loan Interest.
    ...    @author: rtarayao
    [Arguments]    ${rowid}    ${Loan_CycleNumber}    ${Pro_Rate}

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ select    ${LIQ_Loan_Options_Payment}
    mx LoanIQ activate window    ${LIQ_Loan_ChoosePayment_Window}
    mx LoanIQ enter    ${LIQ_Loan_ChoosePayment_InterestPayment_RadioButton}    ON
    mx LoanIQ click    ${LIQ_Loan_ChoosePayment_OK_Button}
 
    mx LoanIQ activate window    ${LIQ_Loan_CyclesforLoan_Window}   
    #Mx Enter    ${LIQ_Loan_CyclesforLoan_ProjectedDue_RadioButton}    ON
    mx LoanIQ enter    JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=${Pro_Rate}")    ON
    Get Loan Interest Cycle Dates - S2/S4   ${rowid}    ${Loan_CycleNumber}
    Validate Loan Interest Projected Due - S2/S4    ${rowid}    ${Loan_CycleNumber}
    mx LoanIQ click    ${LIQ_Loan_CyclesforLoan_OK_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_Payment_Window}

### Scenario 4 only 
Initiate Loan Interest Payment - Scenario 4 only
    [Documentation]    This keyword initiates the payment of Loan Interest.
    ...    This keyword also validates the Projected Cycle Due of the Loan Interest.
    ...    @author: rtarayao
    [Arguments]    ${rowid}    ${Loan_CycleNumber}    ${Pro_Rate}

    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ select    ${LIQ_Loan_Options_Payment}
    mx LoanIQ activate window    ${LIQ_Loan_ChoosePayment_Window}
    mx LoanIQ enter    ${LIQ_Loan_ChoosePayment_InterestPayment_RadioButton}    ON
    mx LoanIQ click    ${LIQ_Loan_ChoosePayment_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_Loan_CyclesforLoan_Window}   
    #Mx Enter    ${LIQ_Loan_CyclesforLoan_ProjectedDue_RadioButton}    ON
    mx LoanIQ enter    JavaWindow("title:=Cycles for Loan.*").JavaRadioButton("attached text:=${Pro_Rate}")    ON
    Get Loan Interest Cycle Dates - S2/S4   ${rowid}    ${Loan_CycleNumber}
    Validate Loan Interest Projected Due - Scenario 4 only    ${rowid}    ${Loan_CycleNumber}
    mx LoanIQ click    ${LIQ_Loan_CyclesforLoan_OK_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_Payment_Window}

Validate Loan Interest Projected Due - Scenario 4 only
    [Documentation]    This keyword checks the accuracy of the Loan Interest Projected Cycle Due.
    ...    @author: rtarayao
    ...    <updated @ghabal> created separate keyword and commented validation for Scenario 4
    [Arguments]    ${rowid}    ${Loan_CycleNumber}
    
	${Computed_LoanIntProjectedCycleDue}    Read Data From Excel    SERV22_InterestPayments    Computed_LoanIntProjectedCycleDue    ${rowid}
         
    ${UI_ProjectedCycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_CyclesforLoan_List}    ${Loan_CycleNumber}%Projected Cycle Due%test  
    ${UI_ProjectedCycleDue}    Remove String    ${UI_ProjectedCycleDue}    ,
    ${UI_ProjectedCycleDue}    Convert To Number    ${UI_ProjectedCycleDue}    2
    Log    ${UI_ProjectedCycleDue} = This data is from the UI.    
    Log    ${Computed_LoanIntProjected CycleDue}= This data is retrieved from Excel. 
    
    # Should Be Equal    ${Computed_LoanIntProjectedCycleDue}    ${UI_ProjectedCycleDue}   

Validate Loan Interest Projected Due - S2/S4
    [Documentation]    This keyword checks the accuracy of the Loan Interest Projected Cycle Due.
    ...    @author: rtarayao
    [Arguments]    ${rowid}    ${Loan_CycleNumber}
    
	${Computed_LoanIntProjectedCycleDue}    Read Data From Excel    SERV22_InterestPayments    Computed_LoanIntProjectedCycleDue    ${rowid}
         
    ${UI_ProjectedCycleDue}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_CyclesforLoan_List}    ${Loan_CycleNumber}%Projected Cycle Due%test  
    ${UI_ProjectedCycleDue}    Remove String    ${UI_ProjectedCycleDue}    ,
    ${UI_ProjectedCycleDue}    Convert To Number    ${UI_ProjectedCycleDue}    2
    Log    ${UI_ProjectedCycleDue} = This data is from the UI.    
    Log    ${Computed_LoanIntProjected CycleDue}= This data is retrieved from Excel. 
    
    Should Be Equal    ${Computed_LoanIntProjectedCycleDue}    ${UI_ProjectedCycleDue}      

Get Loan Interest Cycle Dates - S2/S4
    [Documentation]    This keyword writes and saves the Loan Interest Cycle Dates in Excel. 
    ...    @author: rtarayao
    [Arguments]    ${rowid}    ${Loan_CycleNumber} 
      
    ${UI_InterestCycleDueDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_CyclesforLoan_List}    ${Loan_CycleNumber}%Due Date%test  
    ${UI_InterestCycleStartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_CyclesforLoan_List}    ${Loan_CycleNumber}%Start Date%test  
    
	Write Data To Excel    SERV22_InterestPayments    Loan_InterestCycleDueDate    ${rowid}    ${UI_InterestCycleDueDate}
    Write Data To Excel    SERV22_InterestPayments    Loan_InterestCycleStartDate    ${rowid}    ${UI_InterestCycleStartDate}
         
Input Effective Date and Requested Amount for Loan Interest Payment - S2/S4
    [Documentation]    This keyword inputs the Effective date for the Loan Interest Payment.
    ...    @author: jdelacru
    [Arguments]    ${InterestPayment_EffectiveDate}
    
    mx LoanIQ activate window    ${LIQ_Payment_Window}
    
    ${CurrentCycDue}    Mx LoanIQ Get Data    ${LIQ_InterestPayment_CurrentCycDue_Text}    value    
    mx LoanIQ enter    ${LIQ_Payment_RequestedAmount_Textfield}    ${CurrentCycDue}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    
    
    Write Data To Excel    SERV22_InterestPayments    Payment_Amount    ${rowid}   ${CurrentCycDue}
    mx LoanIQ enter    ${LIQ_Payment_EffectiveDate_Textfield}    ${InterestPayment_EffectiveDate} 
    mx LoanIQ select    ${LIQ_Payment_File_Save}
    
    :FOR    ${i}    IN RANGE    3
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${status}    Run Keyword And Return Status    Validate Warning Message Box          
    \    Exit For Loop If    ${status}==False

Validate Loan Interest Payment Details - S2/S4
    [Documentation]    This keyword inputs the Effective date for the Loan Interest Payment.
    ...    @author: rtarayao
    [Arguments]    ${Deal_Name}    ${Facility_Name}    ${Loan_Borrower}    ${Loan_Alias}    ${rowid}
    

	${Loan_InterestCycleDueDate}    Read Data From Excel    SERV22_InterestPayments    Loan_InterestCycleDueDate    ${rowid}
    ${Loan_InterestCycleStartDate}    Read Data From Excel    SERV22_InterestPayments    Loan_InterestCycleStartDate    ${rowid}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Deal_Name}")      VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Facility_Name}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Loan_Borrower}")        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Loan_Alias}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Loan_InterestCycleDueDate}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.* Payment.*").JavaStaticText("attached text:=${Loan_InterestCycleStartDate}")     VerificationData="Yes"
	Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_Payment_CashflowFromAgent_RadioButton}    From Agent

Do Generate Intent Notices for an Interest Payment (for Scenario 8)
    [Documentation]    This keyword generates Intent Notices of an Interest Payment
    ...    @author: ghabal            

    mx LoanIQ activate    ${LIQ_InterestPayment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_InterestPayment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Interest_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Interest_WorkflowItems}    Generate Intent Notices
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}    
        
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 

Open Loan Interest Payment Notebook (Scenario 8)
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    ...    <update> @ghabal - updated keyword to accomodate new locators for Interest Payment window    
    
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
    
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}
    Mx Native Type    {ENTER}
    
    # Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Loan_Alias}%s
    Sleep    3s  
  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    
    mx LoanIQ activate    ${LIQ_InterestPayment_Window}

Validation on Interest Payment Notebook - Events Tab
    [Documentation]    This keyword is for validates Interest Payment Notebook Events Tab.
    ...    @author: ghabal
    
    mx LoanIQ activate    ${LIQ_InterestPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_InterestPayment_Tab}    Events
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_Events_JavaTree}    Released%yes 

Navigate to Payment Workflow and Proceed With Transaction
    [Documentation]    This keyword is used in select an item in workflow for Payment Notebook.
    ...    @author: amansuet    01JUN2020    - initial create
    [Arguments]    ${sTransaction}
 
    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_Payment_Window}    ${LIQ_Payment_Tab}    ${LIQ_Payment_WorkflowItems}    ${Transaction}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PaymentWindow_WorkflowTab

Get Latest Interest Cycle Row 
    [Documentation]    This keyword selects a cycle fee payment for Cycle Due amount.
    ...    @author: cfrancis    16OCT2020    - Initial Create 
    
    mx LoanIQ activate window    ${LIQ_Loan_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ${rowcount}    Mx LoanIQ Get Data    ${LIQ_Loan_AccrualTab_Cycles_Table}    input=items count%value
    ${rowcount}    Evaluate    ${rowcount} - 2
    Log    The total rowcount is ${rowcount}
    [Return]    ${rowcount}
    
Initiate Loan Latest Cycle Interest Payment
    [Documentation]    This keyword initiates the payment of Loan Interest for the latest cycle due.
    ...    @author: cfrancis    16OCT2020    - Initial Create
    [Arguments]    ${sCycleNumber}    ${sPro_Rate}

    ### Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    ${Pro_Rate}    Acquire Argument Value    ${sPro_Rate}

    Mx LoanIQ Activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select    ${LIQ_Loan_Options_Payment}
    Mx LoanIQ Activate window    ${LIQ_Loan_ChoosePayment_Window}
    Mx LoanIQ Enter    ${LIQ_Loan_ChoosePayment_InterestPayment_RadioButton}    ON
    Mx LoanIQ Click    ${LIQ_Loan_ChoosePayment_OK_Button}
    Mx LoanIQ Activate Window    ${LIQ_Loan_CyclesforLoan_Window}

    ${Pro_Rate}    Replace Variables    ${Pro_Rate}
    ${LIQ_Loan_CyclesforLoan_ProRateType_RadioButton}    Replace Variables    ${LIQ_Loan_CyclesforLoan_ProRateType_RadioButton}
    Mx LoanIQ Enter    ${LIQ_Loan_CyclesforLoan_ProRateType_RadioButton}    ON

    Get Loan Interest Cycle Dates    ${CycleNumber}
    ${Due_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Loan_CyclesforLoan_List}    ${sCycleNumber}%Due Date%amount
    Mx LoanIQ Select String    ${LIQ_Loan_CyclesforLoan_List}    ${Due_Date}
    Mx LoanIQ Click    ${LIQ_Loan_CyclesforLoan_OK_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}     
    Mx LoanIQ Activate Window    ${LIQ_Payment_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/InterestPaymentWindow