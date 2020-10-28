*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Search for Existing Outstanding
    [Documentation]    This is a low-level keyword that will be used to navigate to existing Outstanding (Loan/SBLC)
    ...    @author: ritragel
    ...    @update: hstone    23AUG22019    Added Take Screenshot on Outstanding Selection
    ...    @update: hstone    26MAY2020     - Added Keyword Pre-processing
    ...                                     - Removed Sleep, replaced with 'Wait Until Keyword Succeeds'
    ...    @update: clanding    13AUG2020    - Updated hard coded values to global variables; added path to screenshot
    [Arguments]    ${sOutstandingSelect_Type}    ${sFacility_Name}

    ### Keyword Pre-processing ###
    ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    mx LoanIQ select    ${LIQ_OutstandingSelect_Submenu}
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ enter    ${LIQ_OutstandingSelect_Existing_RadioButton}    ${ON} 
    mx LoanIQ select    ${LIQ_OutstandingSelect_Type_Dropdown}    ${OutstandingSelect_Type}    
    mx LoanIQ select    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}      
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ComprehensiveRepricing_OutstandingSelect
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_ExistingLoansForFacility_CreateRepricing_Button}      VerificationData="Yes"
    Run Keyword If    '${status}'=='True'    Log    Existing Loan/s for Facility is successfully displaying
    ...    ELSE    Log    No existing loans for the selected Facility
    Log    Search for Existing Outstanding keyword is complete
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Facility_ExistingLoan
                
Select Loan to Reprice
    [Documentation]    This is a low-level keyword that will be used to select a specific loan in Existing Loans For Facility window
    ...    @author: ritragel
    ...    @update: bernchua    26AUG2019    Used 'AND' for executing script under the same condition
    ...    @update: hstone    28AUG22019    Added Take Screenshot on Loan Selection
    ...    @update: hstone    29AUG2019    Added selection of existing loan via Current Amount
    ...    @update: hstone    26MAY2020    - Added Keyword Pre-processing
    ...    @update: amansuet    15JUN2020    - updated take screenshot
    [Arguments]    ${sLoan_Alias}    ${sCurrentAmt}=None

    ### Keyword Pre-processing ###
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
    ${CurrentAmt}    Acquire Argument Value    ${sCurrentAmt}

    Mx LoanIQ Activate Window    ${LIQ_ExistingLoansForFacility_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ExistingLoansForFacilityWindow
    ${status}    Run Keyword If    '${CurrentAmt}'!='None'    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_ExistingLoansForFacility_JavaTree}    ${CurrentAmt}
    ...    ELSE    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_ExistingLoansForFacility_JavaTree}    ${Loan_Alias} 
    Run Keyword If    '${status}'=='True'    Run Keywords    Mx LoanIQ Click    ${LIQ_ExistingLoansForFacility_CreateRepricing_Button}
    ...    AND    Log    Loan to Reprice is selected successfully!
    ...    ELSE    Log    The Loan you are trying to click is not in the JavaTree
    Log    Search for Existing Outstanding keyword is complete
    
Select Repricing Type
    [Documentation]    This is a reusable keyword for selecting what repricing to create: Quick/Comprehensive
    ...    @author: ritragel
    ...    @update: hstone    23AUG2019     - Added Take Screenshot on Repricing Type Selection
    ...    @update: hstine    26MAY2020     - Added Keyword Pre-processing
    ...    @update: amansuet    15JUN2020    - updated take screenshot
    ...    @update: clanding    13AUG2020    - updated hard coded values to global variables
    [Arguments]    ${sRepricing_Type}

    ### Keyword Pre-processing ###
    ${Repricing_Type}    Acquire Argument Value    ${sRepricing_Type}

    Mx LoanIQ activate Window    ${LIQ_CreateRepricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CreateRepricingWindow
    Run Keyword If    '${Repricing_Type}'=='Comprehensive Repricing'    Mx LoanIQ Enter    ${LIQ_CreateRepricing_ComprehensiveRepricing_RadioButton}    ${ON}    
    ...    ELSE IF    '${Repricing_Type}'=='Quick Repricing'    Mx LoanIQ Enter    ${LIQ_CreateRepricing_QuickRepricing_RadioButton}    ${ON}    
    Mx LoanIQ Click    ${LIQ_CreateRepricing_Ok_Button}     
    Log    Select Repricing Keyword is complete 
 
Select Loan Repricing for Deal
    [Documentation]    This keyword is to select specific Loans for Deal
    ...    @author: ritragel
    ...    @update: bernchua    26AUG2019    Updated validation if Loan Alias is exisiting; Used generic keyword for warning messages
    ...    @update: hstone      28AUG2019    Added Take Screenshot on Loan Selection
    ...    @update: bernchua    11SEP2019    Added clicking of question message if present "Include Scheduled Payments?"
    ...    @update: hstone      26MAY2020    - Added Keyword Pre-processing
    ...    @update: amansuet    15JUN2020    - updated take screenshot
    [Arguments]    ${sLoan_Alias}

    ### Keyword Pre-processing ###
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    Mx LoanIQ Activate Window    ${LIQ_LoanRepricingForDeal_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingForDealWindow
    
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_LoanRepricingForDeal_JavaTree}    ${Loan_Alias}
    Run Keyword If    ${STATUS}==True    Log    Loan is successfully selected
    ...    ELSE    Fail    The Loan you are trying to click is not existing
    Mx LoanIQ Click    ${LIQ_LoanRepricingForDeal_OK_Button}
    Verify If Warning Is Displayed
    Mx LoanIQ Click Element If Present    ${LIQ_IncludeScheduledPayments_Ok_Button}
    Log    Search for Existing Outstanding keyword is complete

Add Repricing Detail
    [Documentation]    This keyword is used to Add Repricing Detail Add Option
    ...    @author: ritragel
    ...    @update: hstone     26MAY2020     - Added Keyword Pre-processing
    [Arguments]    ${sRepricing_Add_Option}    ${sRowid}    ${sPricing_Option}

    ### Keyword Pre-processing ###
    ${Repricing_Add_Option}    Acquire Argument Value    ${sRepricing_Add_Option}
    ${rowid}    Acquire Argument Value    ${sRowid}
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    ${TotalExistingOutstanding}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    Total:%Amount%TotalExistingOutstanding 
    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_Add_Button} 
    Select Repricing Detail Add Options    ${Repricing_Add_Option}    ${Pricing_Option}
    ${TotalPrincipalPayment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    *** Principal Payment:%Amount%TotalPrincipalPayment    
    Should Be Equal    ${TotalExistingOutstanding}    ${TotalPrincipalPayment}     
    Write Data To Excel    SERV08_ComprehensiveRepricing    Amount    ${rowid}    ${TotalPrincipalPayment}
    Log    Add Repricing Detail Keyword is complete    
    
Add Principal Payment after New Outstanding Addition
    [Documentation]    This keyword is used to add and validate the principal payment after new outstandings addition
    ...    @author: hstone
    ...    @update: hstone      28MAY2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Added Optional Arguments: ${sRunTimeVar_ActualPrincipalPayment}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    ...                                      - Removed unnecessary spacing
    [Arguments]    ${sPricing_Option}    ${sNewRequestedAmt}    ${sRunTimeVar_ActualPrincipalPayment}=None

    ### Keyword Pre-processing ###
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${NewRequestedAmt}    Acquire Argument Value    ${sNewRequestedAmt}

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Take Screenshot    ComprehensiveRepricing_LoanRepricing
    ${TotalExistingOutstanding}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    Total:%Amount%TotalExistingOutstanding 
    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_Add_Button}
    Select Repricing Detail Add Options    Principal Payment    ${Pricing_Option}
    ${ActualPrincipalPayment}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    *** Principal Payment:%Amount%TotalPrincipalPayment 
    ${iActualPrincipalPayment}    Remove Comma and Convert to Number    ${ActualPrincipalPayment}
    ${iNewRequestedAmt}    Remove Comma and Convert to Number    ${NewRequestedAmt}
    ${TotalExistingOutstanding}    Remove Comma and Convert to Number    ${TotalExistingOutstanding}
    ${ExpectedPrincipalPayment}    Evaluate    ${TotalExistingOutstanding}-${iNewRequestedAmt}
    ${status}    Run Keyword And Return Status     Should Be Equal As Numbers    ${ExpectedPrincipalPayment}    ${iActualPrincipalPayment}
    Run Keyword If    '${status}'=='True'    Log    Passed: Principal Payment Amount Verified
    ...    ELSE    Log    Failed: Principal Payment Amount displayed is  ${iActualPrincipalPayment} instead of ${ExpectedPrincipalPayment}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ActualPrincipalPayment}    ${ActualPrincipalPayment}

    [Return]    ${ActualPrincipalPayment}
    
Navigate to Create Cashflow for Loan Repricing
    [Documentation]    This keyword is used to navigate from Generate to Workflow to Create Cashflow in Loan Repricing
    ...    @author: ritragel
    ...    @update: amansuet    15JUN2020    - updated to align with automation standards and added take screenshot
    ...    @update: clanding    13AUG2020    - updated hard coded values to global variables

    Mx LoanIQ Activate Window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${WORKFLOW_TAB}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingForDealWindow_WorkflowTab
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    ${CREATE_CASHFLOWS_TYPE}    
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}  
    Mx LoanIQ Activate Window    ${LIQ_LoanRepricing_Cashflow_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing_CashflowWindow

Select Repricing Detail Add Options
    [Documentation]    This keyword is used to Add Repricing Detail Add Option
    ...    @author: ritragel
    ...    @update: hstone     23AUG2019     - Added take screenshot for Repricing Detail Add Option
    ...    @update: hstone     26MAY2020     - Added 2 'mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}'
    ...                                      - Added 'mx LoanIQ click element if present    ${LIQ_Information_OK_Button}'
    ...    @update: hstone     28MAY2020     - Replaced Sleep with Implicit Wait
    ...                                      - Removed ':' on Repricing Options
    [Arguments]    ${Repricing_Add_Option}    ${Pricing_Option}
    Log     ${Repricing_Add_Option}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_RepricingDetail_Window}
    Run Keyword If    '${Repricing_Add_Option}'=='Rollover/Conversion To New'    Run Keywords    mx LoanIQ enter    ${LIQ_RepricingDetail_RolloverNew_RadioButton}    ON
    ...    AND    mx LoanIQ select    ${LIQ_RepricingDetail_RolloverExisting_Dropdown}    ${Pricing_Option}
    Run Keyword If    '${Repricing_Add_Option}'=='Rollover/Conversion to Existing'    Run Keywords    mx LoanIQ enter    ${LIQ_RepricingDetail_RolloverExisting_RadioButton}    ON 
    ...    AND    mx LoanIQ select    ${LIQ_RepricingDetail_RolloverExisting_Dropdown}    ${Pricing_Option}
    Run Keyword If    '${Repricing_Add_Option}'=='Principal Payment'    mx LoanIQ enter    ${LIQ_RepricingDetail_Principal_RadioButton}    ON
    Run Keyword If    '${Repricing_Add_Option}'=='Interest Payment'    mx LoanIQ enter    ${LIQ_RepricingDetail_Interest_RadioButton}    ON
    Run Keyword If    '${Repricing_Add_Option}'=='Auto Generate Individual Repayment'    mx LoanIQ enter    ${LIQ_RepricingDetail_AutoGenerateInvidualRepayment_RadioButton}    ON
    Run Keyword If    '${Repricing_Add_Option}'=='Auto Generate Interest Payment'    mx LoanIQ enter    ${LIQ_RepricingDetail_AutoGenerateInterestPayment_RadioButton}    ON
    Run Keyword If    '${Repricing_Add_Option}'=='Scheduled Items'    mx LoanIQ enter    ${LIQ_RepricingDetail_ScheduledItems_RadioButton}    ON       \
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepricingDetailAddOption
    mx LoanIQ click    ${LIQ_RepricingDetail_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Log    Repricing Detail Add Options is selected successfully  
    
#########=================================++++++++++++++++++++++++++++++++######################    
#### CASHFLOW LOAN REPRICING #####

Verify if Status is set to Do It - Loan Repricing
    [Documentation]    This keyword is used to validate the Loan Repricing Cashflow Status
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
     ${CashflowStatus}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_LoanRepricing_Cashflows_List}    ${LIQCustomer_ShortName}%Status%MStatus_Variable
    Log To Console    ${CashflowStatus} 
    ${status}    Run Keyword And Return Status    Should Be Equal As Strings    ${CashflowStatus}    PEND
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LoanRepricing_Cashflows_List}    ${LIQCustomer_ShortName}%s   
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_LoanRepricing_Cashflows_DoIt_Button}    
    ...    ELSE    Log    Status is already set to Do it
    Log    Verify Status is set to do it is complete     

Get Transaction Amount - Loan Repricing
    [Documentation]    This keyword is used to get transaction amount from Cashflow
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    ${BrwTransactionAmount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_LoanRepricing_Cashflows_List}    ${LIQCustomer_ShortName}%Tran Amount%Tran
    ${CashflowTranAmount}    Remove String    ${BrwTransactionAmount}    ,
    ${UiTranAmount}    Convert To Number    ${CashflowTranAmount}    2
    Log To Console    ${UiTranAmount} 
    [Return]    ${UiTranAmount}

Get Debit Amount - Loan Repricing
    [Documentation]    This keyword is used to get debit amount in GL Entries
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    Log    ${LIQCustomer_ShortName}

    ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${LIQCustomer_ShortName}%Debit Amt%Debit
    ${GLEntryAmt}    Remove String    ${DebitAmt}    ,
    ${UiGLEntryAmt}    Convert To Number    ${GLEntryAmt}    2
    Log To Console    ${UiGLEntryAmt} 
    [Return]    ${UiGLEntryAmt}    

Get Credit Amount - Loan Repricing
    [Documentation]    This keyword is used to get credit amount in GL Entries
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    Log    ${LIQCustomer_ShortName}

    ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${LIQCustomer_ShortName}%Credit Amt%Credit
    ${GLEntryAmt}    Remove String    ${CreditAmt}    ,
    ${UiGLEntryAmt}    Convert To Number    ${GLEntryAmt}    2
    Log To Console    ${UiGLEntryAmt} 
    [Return]    ${UiGLEntryAmt}  
    
Get Host Bank Cash - Loan Repricing
    [Documentation]    This keyword is used to get Host Bank cash value
    ...    @author: ritragel
    ${UiHostBank}    Mx LoanIQ Get Data    ${LIQ_Repayment_Cashflows_HostBankCash_Workflow}    value%value 
    ${UiHostBank}    Strip String    ${UiHostBank}    mode=Right    characters=${SPACE}${SPACE}AUD          
    ${UiHostBank}    Remove Comma and Convert to Number    ${UiHostBank}
    [Return]    ${UiHostBank}              
    
Select Loan to Reprice - Scenario 2 & 4
    [Documentation]    This keyword selects the loan form the given loan alias
    ...    @author: jdelacru
    [Arguments]    ${Loan_Alias}
    mx LoanIQ activate    ${LIQ_ExistingLoansForFacility_Window}
    Mx LoanIQ Select String    ${LIQ_ExistingLoansForFacility_Loan_List}    ${Loan_Alias}
    mx LoanIQ click    ${LIQ_ExistingLoansForFacility_CreateRepricing_Button}
    mx LoanIQ enter    ${LIQ_CreateRepricing_ComprehensiveReprising_RadioButton}    ON
    mx LoanIQ click    ${LIQ_CreateRepricing_Ok_Button}
    # Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LoanRepricingForDeal_Result_List}    ${Loan_Alias}%s
    Mx LoanIQ Select String    ${LIQ_LoanRepricingForDeal_Result_List}    ${Loan_Alias}
    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_IncludeScheduledPayments_Ok_Button}    
    
Add Interest Payment for Loan Repricing
    [Documentation]    This keyword adds Interest Payment for the specified loan
    ...    @author: jdelacru
    ...    @update: hstone    Added take screenshot lines
    ...    @update: hstone      28MAY2020      - Added optional arguments: ${sCyclesForLoan}, ${sInterestRequestedAmount}
    ...                                        - Added Keyword Pre-processing
    ...                                        - Added Cycles for Loan Condition Select
    ...                                        - Added Interest Requested Amount Condition
    ...    @update: amansuet    15JUN2020      - added condition for Cycle Select if Cycle Loan is Cycle Due
    ...                                        - added return value as this will be use for Cashflow calculations
    ...                                        - Updated take screenshot
    ...    @update: clanding    13AUG2020     - Updated hardcoded values to global variables
    [Arguments]    ${sCyclesForLoan}=None    ${sInterestRequestedAmount}=None    ${sRunTimeVar_InterestPaymentRequestedAmount}=None

    ### Keyword Pre-processing ###
    ${CyclesForLoan}    Acquire Argument Value    ${sCyclesForLoan}
    ${InterestRequestedAmount}    Acquire Argument Value    ${sInterestRequestedAmount}

    ### Loan Repricing Window ###
    Mx LoanIQ Activate Window    ${LIQ_LoanRepricing_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingWindow_GeneralTab
    Mx LoanIQ Enter    ${LIQ_LoanRepricing_AutoReduceFacility_Checkbox}    ${ON}
    Mx LoanIQ Click    ${LIQ_LoanRepricingForDeal_Add_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}

    ### Repricing Detail Add Options Window ###
    Mx LoanIQ Activate Window   ${LIQ_RepricingDetailAddOptions_Window}
    Mx LoanIQ Enter    ${LIQ_RepricingDetailAddOptions_InterestPayment_RadioButton}    ${ON}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RepricingDetailAddOptionsWindow
    Mx LoanIQ Click    ${LIQ_RepricingDetailAddOptions_Ok_Button}

    ### Cycles for Loan Window Selection Condition ###
    Run Keyword If    '${sCyclesForLoan}'=='Lender Shares (Prepay Cycle)'    mx LoanIQ enter    ${LIQ_CyclesForLoan_LenderSharesPrepayCycle_RadioButton}    ${ON}
    ...    ELSE IF    '${sCyclesForLoan}'=='Cycle Due'    mx LoanIQ enter    ${LIQ_CyclesForLoan_CycleDue_RadioButton}    ${ON}
    ...    ELSE    mx LoanIQ enter    ${LIQ_CyclesForLoan_ProjectedDue_RadioButton}    ${ON}
	Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CyclesForLoanWindow
    Mx LoanIQ Click    ${LIQ_CyclesForLoan_Ok_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}

    ### Interest Payment Window ###
    Mx LoanIQ Activate Window    ${LIQ_InterestPayment_Window}
    Run Keyword If    '${InterestRequestedAmount}'!='None'    Mx Enter    ${LIQ_InterestPayment_RequestedAmount_Textfield}    ${InterestRequestedAmount}
    ${InterestPaymentRequestedAmount}    Run Keyword If    '${InterestRequestedAmount}'=='None' and '${sCyclesForLoan}'=='Cycle Due'    Mx LoanIQ Get Data    ${LIQ_InterestPayment_RequestedAmount_Textfield}    ${INTEREST_PAYMENT_REQUESTED_AMOUNT}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button} 
    Mx LoanIQ select    ${LIQ_InterestPayment_FileSave_Menu}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InterestPaymentWindow_GeneralTab
    Mx LoanIQ Select    ${LIQ_InterestPayment_FileExit_Menu}
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_InterestPaymentRequestedAmount}    ${InterestPaymentRequestedAmount}

    [Return]    ${InterestPaymentRequestedAmount}

Get Cycle Due Date for Loan Repricing
    [Documentation]    This keyword is used to get Cycle Due Date for Loan Repricing.
    ...    @author: clanding    13AUG2020     - initial create
    [Arguments]    ${sItemToBeDoubleclicked}    ${sRunTimeVar_CycleDueDate}=None
    
    ### Keyword Pre-processing ###
    ${ItemToBeDoubleclicked}    Acquire Argument Value    ${sItemToBeDoubleclicked}

    Wait Until Keyword Succeeds    3x    5 sec    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_LoanRepricing_GeneralTab_Description_JavaTree}    ${ItemToBeDoubleclicked}%d
    Mx LoanIQ Activate Window    ${LIQ_InterestPayment_Window}
    ${Cycle_Due_Date}    Mx LoanIQ Get Data    ${LIQ_InterestPayment_CycleDueDate_Text}    Cycle_Due_Date
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/InterestPaymentWindow
    mx LoanIQ close window    ${LIQ_Payment_Window}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_CycleDueDate}    ${Cycle_Due_Date}
    
    [Return]    ${Cycle_Due_Date}
    
Add New Outstandings
    [Documentation]    This keywword adds new outstandings for the specified loan
    ...    @author: jdelacru
    ...    @update: jdelacru    12MAR2019    - (1) Added additional clicks for Base Rate button (2) Return NewLoanAlias in high level
    ...    @update: hstone      22AUG2019    Added the feature to edit the Outstanding Requested Amount
    ...    @update: hstone      23AUG2019    Added Window Screenshots and commented out second rollover conversion base rate button click routine
    ...    @update: hstone      02SEP2019    Added Notebook save before going to rates tab to avoid second click of base rate button
    ...    @update: hstone      03SEP2019    Added Warning Confirmation before going to Rates Tab
    ...    @update: ritragel    12SEP2019    Added Repricing Frequency
    ...    @update: hstone      28MAY2020    - Added Keyword Pre-processing
    ...                                      - Added Optional Argument: ${sRunTimeVar_NewLoanAlias}
    ...                                      - Added Keyword Post-processing
    ...    @update: shirhong    01OCT2020    Added Repricing Date
    ...                                      - Added Warning Confirmation when saving Rollover Conversion
    ...                                      - Added Question Confirmation when clicking Base Rate button 
    [Arguments]    ${sPricing_Option}    ${sBorrower_Base_Rate}    ${sNewRequestedAmt}=None    ${sRepricingFrequency}=None    ${sRunTimeVar_NewLoanAlias}=None    ${sRepricingDate}=None

    ### Keyword Pre-processing ###
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${Borrower_Base_Rate}    Acquire Argument Value    ${sBorrower_Base_Rate}
    ${NewRequestedAmt}    Acquire Argument Value    ${sNewRequestedAmt}
    ${RepricingFrequency}    Acquire Argument Value    ${sRepricingFrequency}
    ${RepricingDate}    Acquire Argument Value    ${sRepricingDate}

    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    Take Screenshot    ${Screenshot_path}/Screenshots/LoanIQ/ComprehensiveRepricing_LoanRepricing
    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_Add_Button}
    mx LoanIQ enter    ${LIQ_RepricingDetailAddOptions_RolloverConversionToNew_RadioButton}    ON 
    mx LoanIQ select list    ${LIQ_RepricingDetailAddOptions_PricingOption_Dropdown}    ${Pricing_Option}
    Take Screenshot    ${Screenshot_path}/Screenshots/LoanIQ/ComprehensiveRepricing_RepricingDetailAddOptions
    mx LoanIQ click    ${LIQ_RepricingDetailAddOptions_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ activate window    ${LIQ_RolloverConversion_Window} 
    ${NewLoanAlias}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_Alias_Textfield}    NewLoanAlias
    Run Keyword If    '${NewRequestedAmt}'!='None'    mx LoanIQ enter    ${LIQ_RolloverConversion_RequestedAmt_TextField}    ${NewRequestedAmt}
    Run Keyword If    '${RepricingFrequency}'!='None'    mx LoanIQ select list    ${LIQ_PendingRollover_RepricingFrequency_Dropdown}    ${RepricingFrequency}
    Run Keyword If    '${RepricingDate}'!='None'    mx LoanIQ enter    ${LIQ_PendingRollover_RepricingDate}    ${RepricingDate}
    Take Screenshot    ${Screenshot_path}/Screenshots/LoanIQ/ComprehensiveRepricing_PendingRolloverConversion_GeneralTab
    mx LoanIQ select    ${LIQ_RolloverConversion_Save_Menu}
    Run Keyword If    '${RepricingDate}'!='None'    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_RolloverConversion_Tab}    Rates
    mx LoanIQ click    ${LIQ_RolloverConversion_BaseRate_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    # Mx Click Element If Present    ${LIQ_RolloverConversion_BaseRate_Button}
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    Run Keyword If    '${RepricingDate}'!='None'    mx LoanIQ click element if present    ${LIQ_Question_No_Button}  
    mx LoanIQ enter    ${LIQ_SetBaseRate_BorrowerBaseRate_Textfield}    ${Borrower_Base_Rate}
    Take Screenshot    ${Screenshot_path}/Screenshots/LoanIQ/ComprehensiveRepricing_PendingRolloverConversion_RatesTab 
    mx LoanIQ click    ${LIQ_SetBaseRate_Ok_Button}
    mx LoanIQ select    ${LIQ_RolloverConversion_FileExit_Menu}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_NewLoanAlias}    ${NewLoanAlias}

    [Return]    ${NewLoanAlias}
      
Create Cashflow for Loan Repricing
    [Documentation]    This keyword creates cashflow for the loan repricing
    ...    @author: jdelacru
    mx LoanIQ activate    ${LIQ_LoanRepricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_Tab}    Workflow
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricing_WorkflowItems}    Create Cashflows
    mx LoanIQ activate window    ${LIQ_LoanRepricingCashflow_Window}                 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LoanRepricingCashflow_Window}    VerificationData="Yes"
    
Select Preferred Remittance Instruction via Loan Repricing Cashflow Window
    [Documentation]    This keyword is used to select remittance instruction thru the Cashflow window for loan repricing
    ...    @author: jdelacru
    ...    @author: jdelacru/ghabal - commented # Mx Click ${LIQ_LoanRepricing_CashflowsForLoan_OK_Button} for Scenario 4
    [Arguments]    ${LIQCustomer_ShortName}    ${Remittance_Description}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LoanRepricing_Cashflows_List}    ${LIQCustomer_ShortName}%d
    mx LoanIQ activate    ${LIQ_LoanRepricing_Cashflows_DetailsforCashflow_Window}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LoanRepricing_Cashflows_DetailsforCashflow_Window}     VerificationData="Yes"
    mx LoanIQ click    ${LIQ_LoanRepricing_Cashflows_DetailsforCashflow_SelectRI_Button}  
    mx LoanIQ activate    ${LIQ_LoanRepricing_Cashflows_ChooseRemittance_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LoanRepricing_Cashflows_ChooseRemittance_List}    ${Remittance_Description}%s 
    mx LoanIQ click    ${LIQ_LoanRepricing_Cashflows_ChooseRemittance_OK_Button}
    mx LoanIQ click    ${LIQ_LoanRepricing_Cashflows_DetailsforCashflow_OK_Button}
    # Mx Click    ${LIQ_LoanRepricing_CashflowsForLoan_OK_Button}
    
Send Loan Repricing to Approval
    [Documentation]    This keyword is used to Send the Loan Repricing for Approval.
    ...    @author: jdelacru
    mx LoanIQ click element if present    ${LIQ_LoanRepricing_CashflowsForLoan_OK_Button}    
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_Tab}    Workflow
    Mx LoanIQ Select String    ${LIQ_LoanRepricing_WorkflowItems}    Send to Approval            
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricing_WorkflowItems}    Send to Approval
                 
     :FOR    ${i}    IN RANGE    2
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False        
                                   
Add Rollover/Coversion to Existing
    [Documentation]        This keyword is uset to add rollover/conversion to existing outstandings
    ...    @author: jdelacru
    [Arguments]    ${Pricing_Option}   ${Int_Cycle_Frequency}    ${Borrower_Base_Rate}    ${Requested_Amount_ToBeAdded}
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_Add_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}                           
    mx LoanIQ activate    ${LIQ_RepricingDetailAddOptions_Window}
    mx LoanIQ enter    ${LIQ_RepricingDetailAddOptions_RolloverConversionToExisting_RadioButton}    ON 
    mx LoanIQ select list    ${LIQ_RepricingDetailAddOptions_PricingOption_Dropdown}    ${Pricing_Option}
    mx LoanIQ click    ${LIQ_RepricingDetailAddOptions_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    #Add rollover/conversion details
    mx LoanIQ activate    ${LIQ_RolloverConversion_Window}
    ${NewLoanAlias}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_Alias_Textfield}    NewLoanAlias
    Write Data To Excel    SERV08C_LoanRepricingBilateral    New_Loan_Alias    ${rowid}    ${NewLoanAlias}      
    ${RequestedAmt}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_RequestedAmt_Textfield}    RequestedAmt
    ${RequestedAmt}    Remove Comma, Negative Character and Convert to Number    ${RequestedAmt}
    ${ConvertedRequested_Amount_ToBeAdded}    Remove Comma, Negative Character and Convert to Number    ${Requested_Amount_ToBeAdded}
    ${NewRequestedAmt}    Evaluate    ${RequestedAmt}+${ConvertedRequested_Amount_ToBeAdded}      
    mx LoanIQ enter    ${LIQ_RolloverConversion_RequestedAmt_Textfield}    ${NewRequestedAmt}
    Write Data To Excel    SERV08C_LoanRepricingBilateral    New_Requested_Amount    ${rowid}    ${NewRequestedAmt}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_RolloverConversion_IntCycleFreq_Dropdown}    ${Int_Cycle_Frequency}  
    Mx LoanIQ Select Window Tab    ${LIQ_RolloverConversion_Tab}    Rates
    mx LoanIQ click    ${LIQ_RolloverConversion_BaseRate_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_SetBaseRate_Window}    
    mx LoanIQ enter    ${LIQ_SetBaseRate_BorrowerBaseRate_Textfield}    ${Borrower_Base_Rate}
    mx LoanIQ click    ${LIQ_SetBaseRate_Ok_Button}
    mx LoanIQ activate    ${LIQ_RolloverConversion_Window}
    mx LoanIQ select    ${LIQ_RolloverConversion_FileExit_Menu}

Change Loan Repricing Effective Date
    [Documentation]    This keyword is use to change the requested amount of existing loan.
    [Arguments]    ${ExistingLoanAlias}    ${Loan_Amount}
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    ${SystemDate}    Get System Date    
    mx LoanIQ select    ${LIQ_LoanRepricing_ChangeEffectiveDate_Menu}
    mx LoanIQ enter    ${LIQ_EffectiveDate_TextBox}    ${SystemDate}
    mx LoanIQ click    ${LIQ_EffectiveDate_Ok_Button}    
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    Mx LoanIQ Select String    ${LIQ_LoanRepricing_Outstanding_List}    ${ExistingLoanAlias}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_ConversionFromFIXED_Notebook}
    mx LoanIQ select    ${LIQ_ConversionFromFIXED_ModifyRequestedAmt_Menu}
    mx LoanIQ enter    ${LIQ_ConversionFromFIXED_NewRequestedAmount_Textfield}    ${Loan_Amount}
    mx LoanIQ click    ${LIQ_ConversionFromFIXED_Ok_Button}
    mx LoanIQ activate window    ${LIQ_ConversionFromFIXED_Notebook}
    mx LoanIQ select    ${LIQ_ConversionFromFIXED_File_Exit}
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}                  

Get Transaction Amount and Validate GL Entries - Scenario 6
    [Documentation]    This keyword is used to get the Transaction amount from Cashflow and compare this to the records inside GL Entries
    ...    @author: ritragel
    [Arguments]    ${Borrower}    ${Lender1_ShortName}    ${Lender2_ShortName}    ${LenderSharePc1}    ${LenderSharePc2}    ${LenderSharePc3}    ${Host_Bank}
    
    
    ${Lend1TranAmount}    Get Transaction Amount - Scenario 6    ${Lender1_ShortName}
    ${Lend2TranAmount}    Get Transaction Amount - Scenario 6    ${Lender2_ShortName}
    
    ${ComputedTranAmount1}    Compute Lender Share Transaction Amount - Scenario 6   ${LenderSharePc2}
    Should Be Equal    ${Lend1TranAmount}    ${ComputedTranAmount1}
    
    ${ComputedTranAmount2}    Compute Lender Share Transaction Amount - Scenario 6   ${LenderSharePc3}   
    Should Be Equal    ${Lend2TranAmount}    ${ComputedTranAmount2}
    
    ${HostBankShares}    Get Host Bank Cash - Event Fee
    
    ${UiHostBankShares}    Compute Lender Share Transaction Amount - Scenario 6   ${LenderSharePc1}  
    Should Be Equal As Strings    ${HostBankShares}    ${UiHostBankShares}
    
    # GL Entries
    mx LoanIQ activate window    ${LIQ_EventFee_Cashflow_Window}    
    mx LoanIQ select    ${LIQ_EventFee_Queries_GLEntries_Cashflow} 
    mx LoanIQ activate window  ${LIQ_GL_Entries_Window}   
    mx LoanIQ maximize    ${LIQ_GL_Entries_Window} 

    
    ${TotalDebit}    Get Debit Amount - Scenario 6    ${Borrower}
    ${Lender1CreditAmount}    Get Credit Amount - Scenario 6    ${Lender1_ShortName}
    ${Lender2CreditAmount}    Get Credit Amount - Scenario 6    ${Lender2_ShortName}
    ${HostBankCreditAmount}    Get Credit Amount - Scenario 6    ${Host_Bank}
    
    
    Should Be Equal    ${Lend1TranAmount}    ${Lender1CreditAmount}
    Should Be Equal    ${Lend2TranAmount}    ${Lender2CreditAmount}  
    Should Be Equal    ${HostBankShares}    ${HostBankCreditAmount}  
    
    ${TotalCredit}    Evaluate    ${Lender1CreditAmount}+${Lender2CreditAmount}+${HostBankCreditAmount}
    ${status}    Run Keyword And Return Status    Should Be Equal    ${TotalDebit}    ${TotalCredit}  
    Run Keyword If    '${status}'=='True'    Log    Passed: Credit and Debit is balanced
    ...    ELSE    Log    Failed: Credit and Debit is not balanced  
    
    mx LoanIQ close window    ${LIQ_GL_Entries_Window}
    mx LoanIQ click    ${LIQ_EventFee_Cashflow_Ok_Button}
    
Get Transaction Amount - Scenario 6
    [Documentation]    This keyword is used to get transaction amount from Cashflow
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    ${BrwTransactionAmount}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_EventFee_Cashflows_List}    ${LIQCustomer_ShortName}%Tran Amount%Tran
    ${CashflowTranAmount}    Remove String    ${BrwTransactionAmount}    ,
    ${UiTranAmount}    Convert To Number    ${CashflowTranAmount}    2
    Log To Console    ${UiTranAmount} 
    [Return]    ${UiTranAmount}
 
Compute Lender Share Transaction Amount - Scenario 6
    [Documentation]    This keyword is used to compute for the Lender Share Transaction Amount.
    ...    @author: rtarayao  
    [Arguments]    ${LenderSharePct}
    
    Log    ${LenderSharePct}
    ${EventFee_CalculatedFixedPayment}    Read Data From Excel    SERV33_RecurringFee    EventFee_RequestedAmount    ${rowid}
    Log    ${EventFee_CalculatedFixedPayment} 
    
    ${status}    Run Keyword And Return Status    Should Contain    ${EventFee_CalculatedFixedPayment}    ,           
    Run Keyword If    '${status}'=='True'    Remove String    ${EventFee_CalculatedFixedPayment}    ,
    ${LenderSharePct}    Evaluate    ${LenderSharePct}/100
    ${LenderShareTranAmt}    Evaluate    ${EventFee_CalculatedFixedPayment}*${LenderSharePct}   
    ${LenderShareTranAmt}    Convert To Number    ${LenderShareTranAmt}    2
    Log    ${LenderShareTranAmt}
    [Return]    ${LenderShareTranAmt}
    
Get Host Bank Cash - Scenario 6
    [Documentation]    This keyword is used to get Host Bank cash value
    ...    @author: ritragel
    ${HostBankShares}    Mx LoanIQ Get Data    ${LIQ_EventFee_Cashflow_HostBankCash_JavaEdit}    value%value 
    ${UiHostBank}    Strip String    ${HostBankShares}    mode=Right    characters= AUD
    #${status}    Run Keyword And Return Status    Should Contain    ${UiHostBank}    ,
    #Run Keyword If    '${status}'=='True'    
    ${UiHostBank}    Remove String    ${UiHostBank}    ,
    ${HBShares}    Convert To Number    ${UiHostBank}    2
    [Return]    ${HBShares}
    
Get Debit Amount - Scenario 6
    [Documentation]    This keyword is used to get debit amount in GL Entries
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    ${DebitAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${LIQCustomer_ShortName}%Debit Amt%Debit
    ${GLEntryAmt}    Remove String    ${DebitAmt}    ,
    ${UiGLEntryAmt}    Convert To Number    ${GLEntryAmt}    2
    Log To Console    ${UiGLEntryAmt} 
    [Return]    ${UiGLEntryAmt}    

Get Credit Amount - Scenario 6
    [Documentation]    This keyword is used to get credit amount in GL Entries
    ...    @author: ritragel
    [Arguments]    ${LIQCustomer_ShortName}
    ${CreditAmt}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_GL_Entries_JavaTree}    ${LIQCustomer_ShortName}%Credit Amt%Credit
    ${GLEntryAmt}    Remove String    ${CreditAmt}    ,
    ${UiGLEntryAmt}    Convert To Number    ${GLEntryAmt}    2
    Log To Console    ${UiGLEntryAmt} 
    [Return]    ${UiGLEntryAmt}
    
    
Open Loan Repricing Notebook via WIP - Awaiting Approval w/ Future Target Date
    [Documentation]    This keyword is used to open the Loan Repricing Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...     @author: jdelacru
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingApprovalStatus}    ${WIP_OutstandingType}    ${Deal_Name}    ${Target_Date}  
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}    VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    mx LoanIQ select    ${LIQ_TransactionInProcess_File_ChangeTargetDate}
    mx LoanIQ enter    ${LIQ_ChangeTargetDate_DateField}    ${Target_Date}
    mx LoanIQ click    ${LIQ_ChangeTargetDate_Ok_Button}
            
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}    
   
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingApprovalStatus} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN} 
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Deal_Name}%s
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_LoanRepricing_Window}
    
Open Loan Repricing Notebook via WIP - Awaiting Rate Approval w/ Future Target Date
    [Documentation]    This keyword is used to open the Loan Repricing Notebook with an Awaiting Rate Approval Status thru the LIQ WIP Icon.
    ...     @author: jdelacru
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingRateApprovalStatus}    ${WIP_OutstandingType}    ${Deal_Name}    ${Target_Date}    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    mx LoanIQ select    ${LIQ_TransactionInProcess_File_ChangeTargetDate}
    mx LoanIQ enter    ${LIQ_ChangeTargetDate_DateField}    ${Target_Date}
    mx LoanIQ click    ${LIQ_ChangeTargetDate_Ok_Button}
            
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}  
    
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRateApprovalStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingRateApprovalStatus} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Deal_Name}%s
    Sleep    3s  
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window} 
    mx LoanIQ activate    ${LIQ_LoanRepricing_Window}
    
Send Loan Repricing Rates to Approval w/ Future Target Date
    [Documentation]    This keyword is used to Send the Loan Repricing Rates set for Approval.
    ...     @author: jdelacru
    [Arguments]    ${WIP_TransactionType}    ${WIP_AwaitingSendToRateApprovalStatus}    ${WIP_OutstandingType}    ${Deal_Name}    ${Target_Date}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
    mx LoanIQ select    ${LIQ_TransactionInProcess_File_ChangeTargetDate}
    mx LoanIQ enter    ${LIQ_ChangeTargetDate_DateField}    ${Target_Date}
    mx LoanIQ click    ${LIQ_ChangeTargetDate_Ok_Button}
            
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}
     
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingSendToRateApprovalStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingSendToRateApprovalStatus} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Deal_Name}%d
    Sleep    3s  
    mx LoanIQ activate    ${LIQ_LoanRepricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_LoanRepricing_WorkflowItems}    Send to Rate Approval%yes    
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricing_WorkflowItems}    Send to Rate Approval
    
Generate Rate Setting Notices - Scenario 6
    [Documentation]    This keyword is used to Generate Rate Setting Notices
    ...    @author: ritragel
    [Arguments]    ${Customer_Legal_Name}    ${NoticeStatus} 
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    Workflow  
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricing_WorkflowItems}    Generate Rate Setting Notices  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window    ${LIQ_Notices_Window}   
    mx LoanIQ click    ${LIQ_Notices_OK_Button}      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ activate window    ${LIQ_Rollover_Intent_Notice_Window}
    
Navigate Work In Process
    [Documentation]    This keyword is used to navigate the work in process window w/ future target date
    ...     @author: jdelacru
    [Arguments]    ${WIP_TransactionType}
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    
Release Loan Repricing - Scenario 6
    [Documentation]    This keyword is use to release the loan repricing for Scenario 6
    [Arguments]    ${WIP_AwaitingReleaseStatus}    ${WIP_OutstandingType}    ${Deal_Name}        ${Requested_Amount_ToBeAdded}
    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_AwaitingReleaseStatus} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType}  
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${WIP_OutstandingType} 
    Mx Native Type    {PGDN}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Deal_Name}%d
    Sleep    3s
    
    mx LoanIQ activate window   ${LIQ_LoanRepricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LoanRepricing_WorkflowItems}    Release%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LoanRepricing_WorkflowNoItems}    VerificationData="Yes"
    
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_Tab}    General
    ${ConvertedRequestedAmountToBeAdded}    Convert Number With Comma Separators    ${Requested_Amount_ToBeAdded}
    Mx LoanIQ Select String    ${LIQ_LoanRepricing_Outstanding_List}    *** Increase:\t\t${ConvertedRequestedAmountToBeAdded} 

Validate Loan Repricing from Facility
    [Documentation]    This keyword is use to validate loan repricing on facility notebook
    ...    @author: jdelacru
    [Arguments]    ${NewRequestedAmout}    ${Current_Commitment}
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    mx LoanIQ select    ${LIQ_LoanRepricing_Facility_Menu}
    
    #Avail to Draw Validation
    ${CurrentCmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    CurrentCmt
    ${Outstandings}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    Outstandings
    ${ConvertedCurrentCmt}    Remove Comma and Convert to Number    ${CurrentCmt}
    ${ConvertedOutstandings}    Remove Comma and Convert to Number    ${Outstandings}
    ${ComputedAvailToDraw}    Evaluate    ${ConvertedCurrentCmt}-${ConvertedOutstandings}
    ${FetchedAvailToDraw}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    AvailToDraw
    ${ConvertedFetchedAvailToDraw}    Remove Comma and Convert to Number    ${FetchedAvailToDraw}
    Should Be Equal As Integers    ${ComputedAvailToDraw}    ${ConvertedFetchedAvailToDraw}    
    
    #Current Commitment
    Should Be Equal As Integers    ${Current_Commitment}    ${ConvertedCurrentCmt}
    
    #Outstandings
    Should Be Equal As Integers    ${NewRequestedAmout}    ${ConvertedOutstandings}    
    
Validate Existing and New Loans
    [Documentation]    This keyword is use to validate existing loan and the newly created loan from loan repricing in loan notebook
    ...    @author: jdelacru    
    [Arguments]    ${ExistingLoan}    ${NewLoan}    ${NewRequestedAmount}    ${Loan_Amount}    ${Requested_Amount_ToBeAdded}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_OutstandingSelect_Menu}
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    
    #Previous Loan
    mx LoanIQ activate window    ${LIQ_ExistingLoansForFacility_JavaTree}
    Mx LoanIQ Select String    ${LIQ_ExistingLoansForFacility_JavaTree}    ${ExistingLoan}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_Loan_Window}
     
    ${OldLoanAmount}    Remove Comma and Convert to Number    ${Loan_Amount}
    ${RequestedAmountThatBeenAdded}    Remove Comma and Convert to Number    ${Requested_Amount_ToBeAdded}   
    ${ComputedOldLoan}    Evaluate    ${OldLoanAmount}-${RequestedAmountThatBeenAdded}    

    ${ExistingCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Field}    ExistingCurrent
    ${ConvertedExistingCurrent}    Remove Comma and Convert to Number    ${ExistingCurrent}    
    Should Be Equal As Integers    ${ConvertedExistingCurrent}    ${ComputedOldLoan}
    mx LoanIQ select    ${LIQ_LoanNotebook_FileExit_Menu}    
    
    #New Loan
    mx LoanIQ activate window    ${LIQ_ExistingLoansForFacility_JavaTree}
    Mx LoanIQ Select String    ${LIQ_ExistingLoansForFacility_JavaTree}    ${NewLoan}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${NewCurrent}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalCurrent_Field}    ExistingCurrent
    ${ConvertedNewCurrent}    Remove Comma and Convert to Number    ${NewCurrent}    
    Should Be Equal As Integers    ${ConvertedNewCurrent}    ${NewRequestedAmount}
    mx LoanIQ select    ${LIQ_LoanNotebook_FileExit_Menu}

Get Current Commitment and Save to Excel
    [Documentation]    This keyword is used to get the current commitment fee of the facility from Deal Notebook
    ...    @author: jdelacru
    [Arguments]    ${FacilityName}
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}    
    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}
    Mx LoanIQ Select String    ${LIQ_FacilityNavigator_Tree}    ${FacilityName}
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    ${CurrentCommitment}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    CurrentCommitment
    ${ConvertedCurrentCommitment}    Remove Comma and Convert to Number    ${CurrentCommitment}
    Write Data To Excel    SERV08C_LoanRepricingBilateral    Current_Commitment    ${rowid}    ${ConvertedCurrentCommitment}
    mx LoanIQ close window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ close window    ${LIQ_FacilityNavigator_Window}
    
Validate Loan Amounts in General Tab
    [Documentation]    This keyword will validate the loan amounts in java tree
    ...    @author: mnanquil
    ...    10/24/2018
    ...    <update> bernchua 12/5/2018: added code to go to General Tab
    ...    @update: dahijara    23SEP2020    Added pre processing keywords and Screenshot.
    [Arguments]    ${sAmount}    ${sFacility}
    ### GetRuntime Keyword Pre-processing ###
    ${Amount}    Acquire Argument Value    ${sAmount}
    ${Facility}    Acquire Argument Value    ${sFacility}

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    General    
    Mx LoanIQ Select String   ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    ${Amount}\t${Facility}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingWindow
    Log    Successfully validated amount of ${Amount} with facility ${Facility}    

Change Effective Date for Loan Repricing
    [Documentation]    This keyword will change the Effective Date in the Loan Repricing Notebook
    ...    @author: bernchua    12MAR2019    initial create
    ...    @update: sahalder    09JUL2020    Added keyword pre-processing steps    
    [Arguments]        ${sEffectiveDate}
    
    ### GetRuntime Keyword Pre-processing ###
	${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}   
    mx LoanIQ select    ${LIQ_LoanRepricing_ChangeEffectiveDate_Menu}
    mx LoanIQ enter    ${LIQ_EffectiveDate_TextBox}    ${EffectiveDate}
    mx LoanIQ click    ${LIQ_EffectiveDate_Ok_Button}
    Validate if Question or Warning Message is Displayed
    ${STATUS}    Run Keyword And Return Status    mx LoanIQ click    ${LIQ_Error_OK_Button}            
    Run Keyword If    ${STATUS}==True    mx LoanIQ click    ${LIQ_EffectiveDate_Cancel_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanMerge_EffectiveDate      
    
Generate Rate Setting Notices - Scenario 8
    [Documentation]    This keyword is used to Generate Rate Setting Notices
    ...    @author: ritragel
    [Arguments]    ${Customer_Legal_Name}    ${NoticeStatus}   
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    Workflow  
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricing_WorkflowItems}    Generate Rate Setting Notices  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ activate window    ${LIQ_Notices_Window}   
    mx LoanIQ click    ${LIQ_Notices_OK_Button}      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ activate window    ${LIQ_Rollover_Intent_Notice_Window} 
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

Release Loan Repricings
    [Documentation]    This keyword is used to Release the Loan Repricing.
    ...     @author: mnanquil
    mx LoanIQ activate window   ${LIQ_LoanRepricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LoanRepricing_WorkflowItems}    Release%d
    :FOR    ${i}    IN RANGE    5
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False  
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_LoanRepricing_WorkflowNoItems}    VerificationData="Yes"
    
Validate GL Entries After Release
    [Documentation]    This keyword will validate the gl entries for scenario 8
    ...    @author: mnanquil
    ...    @author: bernchua    08MAR2019    Updated keyword name
    ...    @update: dahijara    24SEP2020    Added pre processing keywords and screenshot.
    [Arguments]    ${sDebitAmt1}    ${sDebitAmt2}    ${sCreditAmt}
    ### GetRuntime Keyword Pre-processing ###
    ${DebitAmt1}    Acquire Argument Value    ${sDebitAmt1}
    ${DebitAmt2}    Acquire Argument Value    ${sDebitAmt2}
    ${CreditAmt}    Acquire Argument Value    ${sCreditAmt}

    mx LoanIQ activate window   ${LIQ_LoanRepricing_Window}
    mx LoanIQ select    ${LIQ_LoanRepricing_GLEntries_Menu}
    Mx LoanIQ Click Javatree Cell   ${LIQ_GL_Entries_JavaTree}    ${DebitAmt1}%${DebitAmt1}%Debit Amt
    Mx LoanIQ Click Javatree Cell   ${LIQ_GL_Entries_JavaTree}    ${DebitAmt2}%${DebitAmt2}%Debit Amt    
    Mx LoanIQ Click Javatree Cell    ${LIQ_GL_Entries_JavaTree}    ${CreditAmt}%${CreditAmt}%Credit Amt
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing_GLEntriesWindow
    mx LoanIQ click    ${LIQ_GL_Entries_Exit_Button}
    
Validate Events Tab
    [Documentation]    This keyword will validate the events tab on loan repricing window
    ...    @author: mnanquil
    ...    10/24/2018
    [Arguments]    ${status}
    mx LoanIQ activate window   ${LIQ_LoanRepricing_Window}
     Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_Tab}    Events
     Mx LoanIQ Select String    ${LIQ_LoanRepricing_Events_Tab_JavaTree}    ${status}    
    mx LoanIQ close window    ${LIQ_LoanRepricing_Window}

Select Multiple Loan to Merge
    [Documentation]    This keyword selects two term drawdowns to merge
    ...    @author: chanario
    ...    @update: sahalder    09JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sLoan1_Alias}    ${sLoan2_Alias}
    
    ### GetRuntime Keyword Pre-processing ###
	${Loan1_Alias}    Acquire Argument Value    ${sLoan1_Alias}
	${Loan2_Alias}    Acquire Argument Value    ${sLoan2_Alias}    

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}    
    Mx LoanIQ Multiple Select In Java Tree    ${LIQ_LoanRepricingForDeal_JavaTree}    ${Loan2_Alias};${Loan1_Alias}    
    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanMerge_MultipleLoans

Add Loan Repricing Option
    [Documentation]    This keyword is used to Add Repricing Detail Add Option
    ...    @author: chanario
    ...    @update: bernchua    04JUN2019    Removed writing of data as per standards; Added return value
    ...                                      Removed getting length of computed total amount
    ...                                      Removed condition of setting the base rate code
    ...                                      Replaced condition for clicking informational message to Mx Click Element If Present
    ...    @update: sahalder    08JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sRepricing_Add_Option}    ${sPricing_Option}    ${sFacility}    ${sBorrower}    ${sLoan1Alias}    ${sLoan2Alias}    ${sLoan1}    ${sLoan2}    ${sBaseRateCode_API}
    
    ### GetRuntime Keyword Pre-processing ###
	${Repricing_Add_Option}    Acquire Argument Value    ${sRepricing_Add_Option}
	${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
	${Facility}    Acquire Argument Value    ${sFacility}
	${Borrower}    Acquire Argument Value    ${sBorrower}
	${Loan1Alias}    Acquire Argument Value    ${sLoan1Alias}
	${Loan2Alias}    Acquire Argument Value    ${sLoan2Alias}
	${Loan1}    Acquire Argument Value    ${sLoan1}
	${Loan2}    Acquire Argument Value    ${sLoan2}
	${BaseRateCode_API}    Acquire Argument Value    ${sBaseRateCode_API}

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    
    ${TotalExistingOutstanding}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    Total:%Amount%TotalExistingOutstanding     
    ${Loan1_ExistingOutstanding}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    BBSY - Bid (${Loan1Alias})%Amount%Loan1_ExistingOutstanding
    ${Loan2_ExistingOutstanding}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    BBSY - Bid (${Loan2Alias})%Amount%Loan2_ExistingOutstanding
    
    ${Loan1_Amount}    Remove comma and convert to number    ${Loan1}    
    ${Loan2_Amount}    Remove comma and convert to number    ${Loan2}   
    ${RequestedAmount_Expected}    Evaluate    ${Loan1_Amount}+${Loan2_Amount}
    ${RequestedAmount_Expected}    Evaluate    "%.2f" % ${RequestedAmount_Expected}
    ${RequestedAmount_Expected}    Convert to String    ${RequestedAmount_Expected}
    ${TotalExistingOutstanding_Expected}    Convert Number With Comma Separators    ${RequestedAmount_Expected}
    
    Run Keyword And Continue On Failure    Should Be Equal    ${Loan1_ExistingOutstanding}    ${Loan1}
    Run Keyword And Continue On Failure    Should Be Equal    ${Loan2_ExistingOutstanding}    ${Loan2}
    Run Keyword And Continue On Failure    Should Be Equal    ${TotalExistingOutstanding}    ${TotalExistingOutstanding_Expected}
    
    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_Add_Button}
    mx LoanIQ activate window    ${LIQ_RepricingDetail_Window}
    Mx LoanIQ Set    ${LIQ_RepricingDetail_RolloverNew_RadioButton}    ON
    mx LoanIQ select    ${LIQ_RepricingDetail_RolloverExisting_Dropdown}    ${Pricing_Option}
    
    ${Selected_Facility}    Mx LoanIQ Get Data    ${LIQ_RepricingDetail_Facility}    Selected_Facility            
    ${Selected_Borrower}    Mx LoanIQ Get Data    ${LIQ_RepricingDetail_Borrower}    Selected_Borrower    
    
    ${Facility_status}    Run Keyword And Return Status    Should Be Equal    ${Selected_Facility}    ${Facility}
    ${Borrower_status}    Run Keyword And Return Status    Should Be Equal    ${Selected_Borrower}    ${Borrower}         
    
    Run Keyword If    ${Facility_status}==True    Log    Facility Name is verified!
    ...    ELSE    mx LoanIQ select    ${LIQ_RepricingDetail_Facility}    ${Facility}
    Run Keyword If    ${Facility_status}==True    Log    Borrower is verified!
    ...    ELSE    mx LoanIQ select    ${LIQ_RepricingDetail_Borrower}    ${Borrower}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing_Detais        
    mx LoanIQ click    ${LIQ_RepricingDetail_OK_Button} 
    Verify If Warning Is Displayed
    
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    [Return]    ${TotalExistingOutstanding_Expected}
    
Validate Generals Tab in Rollover/Conversion to BBSY
    [Documentation]    This keyword is used to verify values on the Rollover/Conversion to BBSY Window under General Tab
    ...    @author: chanario
    ...    @update: bernchua    01APR2019    Removed wirting to Excel and returns the Loan Alias instead.
    ...    @update: bernchua    01APR2019    Removed lines for Effective Date setting/validation; It should be done after execution of this keyword.
    ...    @update: sahalder    09JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sBase_Rate}    ${sLoan1_Amount}    ${sLoan2_Amount}    ${sRepricingFrequency_Expected}    ${sLoanMerge_Amount}    ${sRisk_Type}
    
    ### GetRuntime Keyword Pre-processing ###
		${Base_Rate}    Acquire Argument Value    ${sBase_Rate}
		${Loan1_Amount}    Acquire Argument Value    ${sLoan1_Amount}
		${Loan2_Amount}    Acquire Argument Value    ${sLoan2_Amount}
		${RepricingFrequency_Expected}    Acquire Argument Value    ${sRepricingFrequency_Expected}
		${LoanMerge_Amount}    Acquire Argument Value    ${sLoanMerge_Amount}
		${Risk_Type}    Acquire Argument Value    ${sRisk_Type}

    mx LoanIQ activate window    ${LIQ_Rollover_Window}
    
    ## Validate Risk Type ##
    
    ${RiskType_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_AwaitingSendToApprovalRollover_LoanRiskType}            VerificationData="Yes"
    Run Keyword If    ${RiskType_Status}==False    Run Keywords
    ...    mx LoanIQ click    ${LIQ_AwaitingSendToApprovalRollover_RiskType_Button}
    ...    AND    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PendingRollover_RiskType_Tree}    ${Risk_Type}%d
    ...    ELSE    Log    Correct Risk Type is set!
       
    ## Validate Requested Amount ##
    
    ${RequestedAmount}    Mx LoanIQ Get Data    ${LIQ_AwaitingSendToApprovalRollover_RequestedAmount_Textfield}    RequestedAmount        
    ${RequestedAmt_Status}    Run Keyword And Return Status    Should Be Equal As Strings    ${RequestedAmount}    ${LoanMerge_Amount}
    Run Keyword If    ${RequestedAmt_Status}==False    mx LoanIQ enter    ${LIQ_AwaitingSendToApprovalRollover_RequestedAmount_Textfield}    ${LoanMerge_Amount}     
    ...    ELSE    Log    Correct Requested Amount!
    
    ## Validate Repricing Frequency ##
    
    ${RepricingFrequency}    Mx LoanIQ Get Data    ${LIQ_AwaitingSendToApprovalRollover_RepricingFreq_DropdownList}    RepricingFrequency
    ${RepricingFrequency_status}    Run Keyword And Return Status    Should Be Equal    ${RepricingFrequency}    ${RepricingFrequency_Expected}
    
    Run Keyword If    ${RepricingFrequency_status}==False    Run Keywords
    ...    mx LoanIQ select list    ${LIQ_AwaitingSendToApprovalRollover_RepricingFreq_DropdownList}    ${RepricingFrequency_Expected}           
    ...    AND    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    ...    ELSE    Log    Correct Repricing Frequency!
    
    ## Validate Cycle Frequency ##
    
    ${CycleFrequency}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_IntCycleFreq_Dropdown}    CycleFrequency
    ${CycleFrequency_status}    Run Keyword And Return Status    Should Be Equal    ${CycleFrequency}    ${RepricingFrequency_Expected}
    
    ## Retrieve New Loan Alias created after merge and write to Excel ##
    ${LoanMergeAlias}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_Alias_Textfield}    label%alias
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanMerge_Rollover_GeneralTab
    Validate Base Rate in Rollover/Conversion to BBSY    ${Base_Rate}    ${LoanMergeAlias}    ${LoanMerge_Amount}
    [Return]    ${LoanMergeAlias}

Validate Base Rate in Rollover/Conversion to BBSY
    [Documentation]    This keyword is used to verify the Base Rate value for the new Loan created after merging
    ...    @author: chanario
    ...    @update: bernchua    05JUN2019    removed validation of 'Send to Approval' status
    ...    @update: sahalder    16JUL2020    Added step for screenshots
    ...    @updated:dahijara    28SEP2020    Corrected path for screenshot
    ...                                      Updated action from Click to Select for Exiting Rollover/Conversion window.
    [Arguments]    ${Base_Rate}    ${Alias_LoanMerge}    ${RequestedAmount_Expected}
    
    mx LoanIQ activate window    ${LIQ_RolloverConversion_Window}
            
    Mx LoanIQ Select Window Tab    ${LIQ_RolloverConversion_Tab}    Rates
        
    mx LoanIQ click    ${LIQ_RolloverConversion_BaseRateButton}    
    Verify If Warning Is Displayed
    mx LoanIQ click element if present    ${LIQ_Question_No_Button}
    Verify If Warning Is Displayed
    mx LoanIQ activate window    ${LIQ_SetBaseRate_Window}
    mx LoanIQ click    ${LIQ_RolloverConversion_BaseRateButton}    
    Verify If Warning Is Displayed
    Validate if Question or Warning Message is Displayed
    Verify If Warning Is Displayed
    
    ## Validate initial Values of Set Base Rate Window ##
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_RolloverConversion
    ${BaseRateFromPricing}    Mx LoanIQ Get Data    ${LIQ_SetBaseRate_BaseRateFromPricing_Textfield}    BaseRateFromPricing
    Should Be Equal    ${BaseRateFromPricing}    ${Base_Rate}
        
    ${BorrowerBaseRate}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_BorrowerBaseRate}    BorrowerBaseRate
    Should Be Equal    ${BorrowerBaseRate}    0.000000%
    
    ## Accept Rate as 2.45% ##
    mx LoanIQ click    ${LIQ_RolloverConversion_AcceptBaseRate}
    
    ${BorrowerBaseRate}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_BorrowerBaseRate}    BorrowerBaseRate
    Should Be Equal    ${BorrowerBaseRate}    ${Base_Rate}
    
    mx LoanIQ click    ${LIQ_RolloverConversion_BaseRate_OKButton}
    mx LoanIQ select    ${LIQ_RolloverConversion_FileExit_Menu}
    
    ## Validate combined Loan amount after merge on the Loan Repricing Notebook ##
    
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    ${NewOutstadingAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    BBSY - Bid (${Alias_LoanMerge})%Amount%NewOutstadingAmount        
    Should Be Equal    ${NewOutstadingAmount}    ${RequestedAmount_Expected}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_RolloverConversion
    
Validation on the Loan Repricing Notebook After Loan Merge
    
    [Documentation]    This keyword is used to verify data on the Loan Repricing notebook after Merge namely GL Entries, CashFlow and Lender Shares
    ...    @author: chanario
    [Arguments]    ${Loan1_Amount}    ${Loan2_Amount}    ${ShortName}    ${Currency}    ${Legal_Entity}
    ...    ${Lender1_ShortName}    ${Lender2_ShortName}    ${Branch}    ${LoanMerge_Amount}    ${GLEntriesPercentageAmt}                   
    ...    ${LegalEntity_ExpectedAmount}    ${Lender1_ExpectedAmount}    ${Lender2_ExpectedAmount}
    
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    
    mx LoanIQ select    ${LIQ_RolloverConversion_Queries_GLEntries}    
    mx LoanIQ activate window    ${LIQ_RolloverConversion_GLEntries_Window}
    mx LoanIQ maximize    ${LIQ_RolloverConversion_GLEntries_Window}
    
    ## Compute For expected values on the GL Entries ##
    ${Loan1_Amount}    Remove comma and convert to number    ${Loan1_Amount}    
    ${Loan2_Amount}    Remove comma and convert to number    ${Loan2_Amount}
    ${LoanMerge_Amount}    Remove comma and convert to number    ${LoanMerge_Amount}   
    Log    ${LoanMerge_Amount}
    
    ${DebitCBA_ExpectedAmount}    Evaluate    (${LoanMerge_Amount}*${GLEntriesPercentageAmt})/100
    ${DebitCBA_ExpectedAmount}    Evaluate    "%.2f" % ${DebitCBA_ExpectedAmount}
    ${length}    Get Length    ${DebitCBA_ExpectedAmount}
    ${length}    Evaluate    int(${length})
    ${DebitCBA_ExpectedAmount}    Convert to String    ${DebitCBA_ExpectedAmount}
    ${DebitCBA_ExpectedAmount}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${DebitCBA_ExpectedAmount}    
    ${DebitCBA_ExpectedAmount}    Convert to String    ${DebitCBA_ExpectedAmount}
    
    ${CreditCBA1_ExpectedAmount}    Evaluate    (${Loan1_Amount}*${GLEntriesPercentageAmt})/100
    ${CreditCBA1_Expected}    Evaluate    "%.2f" % ${CreditCBA1_ExpectedAmount}
    ${length}    Get Length    ${CreditCBA1_Expected}
    ${length}    Evaluate    int(${length})
    ${CreditCBA1_ExpectedAmount}    Convert to String    ${CreditCBA1_Expected}
    ${CreditCBA1_ExpectedAmount}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${CreditCBA1_ExpectedAmount}    
        
    ${CreditCBA2_ExpectedAmount}    Evaluate    (${Loan2_Amount}*${GLEntriesPercentageAmt})/100
    ${CreditCBA2_Expected}    Evaluate    "%.2f" % ${CreditCBA2_ExpectedAmount}
    ${length}    Get Length    ${CreditCBA2_Expected}
    ${length}    Evaluate    int(${length})
    ${CreditCBA2_ExpectedAmount}    Convert to String    ${CreditCBA2_Expected}
    ${CreditCBA2_ExpectedAmount}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${CreditCBA2_ExpectedAmount}        
    
    ${TotalCredit_ExpectedAmount}    Evaluate    ${CreditCBA1_Expected}+${CreditCBA2_Expected}
    ${TotalCredit_Expected}    Evaluate    "%.2f" % ${TotalCredit_ExpectedAmount}
    ${length}    Get Length    ${TotalCredit_Expected}
    ${length}    Evaluate    int(${length})
    ${TotalCredit_ExpectedAmount}    Convert to String    ${TotalCredit_Expected}
    ${TotalCredit_ExpectedAmount}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${TotalCredit_ExpectedAmount}        
    Log    ${TotalCredit_ExpectedAmount}
    
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_RolloverConversion_GLEntries_Table}    ${DebitCBA_ExpectedAmount}%s    
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_RolloverConversion_GLEntries_Table}    ${CreditCBA1_ExpectedAmount}%s
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_RolloverConversion_GLEntries_Table}    ${CreditCBA2_ExpectedAmount}%s
    
    ${TotalCreditAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RolloverConversion_GLEntries_Table}    ${SPACE}Total For:${SPACE}${Branch}%Credit Amt%TotalCreditAmount
    ${TotalDebitAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RolloverConversion_GLEntries_Table}    ${Currency}%Debit Amt%amount

    Should Be Equal    ${TotalDebitAmount}    ${DebitCBA_ExpectedAmount}
    Should Be Equal    ${TotalCreditAmount}    ${TotalCredit_ExpectedAmount}            
    
    mx LoanIQ click    ${LIQ_RolloverConversion_GLEntries_Exit_Button}
    
    mx LoanIQ select    ${LIQ_RolloverConversion_Options_Cashflow}
    
    Verify If Text Value Exist in Textfield on Page    Error:    There are no cashflows.
    mx LoanIQ click    ${LIQ_Error_OK_Button}
    
    #####
    mx LoanIQ select    ${LIQ_RolloverConversion_Options_LenderShares}
    
    ${LegalEntity_ActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RolloverConversion_LenderShares_Table}    ${Legal_Entity}%Actual Amount%LegalEntity_ActualAmount
    
    Should Be Equal    ${LegalEntity_ActualAmount}    ${LegalEntity_ExpectedAmount}
    
    ${Lender1_ActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RolloverConversion_LenderShares_Table}    ${Lender1_ShortName}%Actual Amount%Lender1_ActualAmount
    
    Should Be Equal    ${Lender1_ActualAmount}    ${Lender1_ExpectedAmount}
    
    ${Lender2_ActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_RolloverConversion_LenderShares_Table}    ${Lender1_ShortName}%Actual Amount%Lender2_ActualAmount
    
    Should Be Equal    ${Lender2_ActualAmount}    ${Lender2_ExpectedAmount}
    ##Double check button to click
    mx LoanIQ click    ${LIQ_RolloverConversion_LenderShares_Cancel} 
    
Validation on the Loan Repricing Notebook for Loan Outstanding Amounts after Merge
    [Documentation]    This keyword is used to verify data on the Loan Repricing notebook for Loan Outstanding amounts for both existing and new
    ...    @author: chanario
    [ARGUMENTS]    ${Loan1_Amount}    ${Loan2_Amount}    ${LoanMerge_Amount}    ${LoanMerge_Alias}    ${Base_Rate}    ${Loan1_Outstanding_AfterMerge}    ${Loan2_Outstanding_AfterMerge}
    
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    General
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    ${Loan1_Amount}
    
    mx LoanIQ activate window    ${LIQ_RolloverConversion_Window}    
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Rollover/Conversion.*").JavaEdit("text:=${Loan1_Outstanding_AfterMerge}")            VerificationData="Yes"
    Mx Native Type    {ESC}
    
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    ${Loan2_Amount}
    
    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*Rollover/Conversion.*").JavaEdit("value:=${Loan2_Outstanding_AfterMerge}")            VerificationData="Yes"
    Mx Native Type    {ESC}
    Log    BBSY - Bid (${LoanMerge_Alias})\t${LoanMerge_Amount}
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    BBSY - Bid (${LoanMerge_Alias})\t\t${LoanMerge_Amount}
    
    ${RequestedAmt_AfterMerge}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_RequestedAmt_Textfield}    input=RequestedAmt_AfterMerge    
    Should Be Equal    ${RequestedAmt_AfterMerge}    ${LoanMerge_Amount}

    Mx LoanIQ Select Window Tab    ${LIQ_PendingRollover_Tab}    Rates
    
    ${CurrentRate}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_Current}    input=CurrentRate    
    ${FromPricingRate}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_Pricing}    input=FromPricingRate
    
    Should Be Equal    ${CurrentRate}    ${Base_Rate}
    Should Be Equal    ${FromPricingRate}    ${Base_Rate}
           

Validation on the Facility Notebook after Merge
    [Documentation]    This keyword is used to verify data on the Facility Notebook of the newly created Loan after Merge
    ...    @author: chanario
    [ARGUMENTS]    ${LoanMerge_Amount}    ${LegalEntity}    ${Lender1}    ${Lender2}    ${Facility}    ${Loan1_Alias}    ${Loan2_Alias}    ${LoanMerge_Alias}    ${Loan1_Amount}    ${Loan2_Amount}
    ...    ${GlobalFacility_ProposedCmtBeforeMerge}    ${GlobalFacility_CurrentCmtBeforeMerge_WithComma}    ${GlobalFacility_OutstandingsBeforeMerge}    ${GlobalFacility_AvailToDrawBeforeMerge}
    ...    ${HostBank_ProposedCmtBeforeMerge}    ${HostBank_ContrGrossBeforeMerge}    ${HostBank_OutstandingsBeforeMerge}    ${HostBank_AvailToDrawBeforeMerge}    ${Facility_HostBankContrGross_Percentage}
    ...    ${Facility_HostBankOutstandings_Percentage}    ${Facility_HostBankAvailToDraw_Percentage}    ${LenderShareHost_Percentage}    ${Lender1ShareHost_Percentage}    ${Lender2ShareHost_Percentage}      
    
    mx LoanIQ activate window    ${LIQ_RolloverConversion_Window}        
    mx LoanIQ select    ${LIQ_RolloverConversion_Options_Facility}    
    
    ## Get Global Facility Amounts ##
        
    ${GlobalFacility_ProposedCmtAfterMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_ProposedCmt_Textfield}    input=GlobalFacility_ProposedCmtAfterMerge
    ${GlobalFacility_CurrentCmtAfterMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_CurrentCmt_Amount}    input=GlobalFacility_CurrentCmtAfterMerge
    ${GlobalFacility_OutstandingsAfterMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_Outstandings_Amount}    input=GlobalFacility_OutstandingsAfterMerge        
    ${GlobalFacility_AvailToDrawAfterMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_GlobalFacAmt_AvailToDraw_Amount}    input=GlobalFacility_AvailToDrawAfterMerge                
    
    ## Get Host Bank Amounts ##
    
    ${HostBank_ProposedCmtAfterMerge}    Mx LoanIQ Get Data    ${LIQ_FacilityNotebook_HostProposedCmt}    input=HostBank_ProposedCmtAfterMerge
    ${HostBank_ContrGrossAfterMerge}    Mx LoanIQ Get Data    ${LIQ_FacilityNotebook_HostContrGross}    input=HostBank_ContrGrossAfterMerge
    ${HostBank_OutstandingsAfterMerge}    Mx LoanIQ Get Data    ${LIQ_FacilityNotebook_HostOutstandings}    input=HostBank_OutstandingsAfterMerge        
    ${HostBank_AvailToDrawAfterMerge}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_HostBank_AvailToDraw_Amount}    input=HostBank_AvailToDrawAfterMerge                

    ## Compare Before Merge and After Merge Amounts for Global Facility ##     
    
    Should Be Equal    ${GlobalFacility_ProposedCmtBeforeMerge}    ${GlobalFacility_ProposedCmtAfterMerge}
    Should Be Equal    ${GlobalFacility_CurrentCmtBeforeMerge_WithComma}    ${GlobalFacility_CurrentCmtAfterMerge}
    Should Be Equal    ${GlobalFacility_OutstandingsBeforeMerge}    ${GlobalFacility_OutstandingsAfterMerge}
    Should Be Equal    ${GlobalFacility_AvailToDrawBeforeMerge}    ${GlobalFacility_AvailToDrawAfterMerge}
    
    ## Compare Before Merge and After Merge Amounts for Host Bank Share Gross Amounts ##     
    
    Should Be Equal    ${HostBank_ProposedCmtBeforeMerge}    ${HostBank_ProposedCmtAfterMerge}
    Should Be Equal    ${HostBank_ContrGrossBeforeMerge}    ${HostBank_ContrGrossAfterMerge}
    Should Be Equal    ${HostBank_OutstandingsBeforeMerge}    ${HostBank_OutstandingsAfterMerge}
    Should Be Equal    ${HostBank_AvailToDrawBeforeMerge}    ${HostBank_AvailToDrawAfterMerge}     
        
    ###Compute for Expected Amounts after Loan Merge###    
    
    ##Compute for Host Bank Contr. Gross##
    
    ${GlobalFacility_CurrentCmtBeforeMerge}    Remove comma and convert to number    ${GlobalFacility_CurrentCmtBeforeMerge_WithComma}
    ${GlobalFacility_HostContrGross_Expected}    Evaluate    (${GlobalFacility_CurrentCmtBeforeMerge}*${Facility_HostBankContrGross_Percentage})/100
    ${GlobalFacility_HostContrGross_Expected}    Evaluate    "%.2f" % ${GlobalFacility_HostContrGross_Expected}
    ${length}    Get Length    ${GlobalFacility_HostContrGross_Expected}
    ${length}    Evaluate    int(${length})
    ${GlobalFacility_HostContrGross_ExpectedString}    Convert to String    ${GlobalFacility_HostContrGross_Expected}
    ${GlobalFacility_HostContrGross_Expected}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${GlobalFacility_HostContrGross_ExpectedString}    
    ${GlobalFacility_HostContrGross_Expected}    Convert to String    ${GlobalFacility_HostContrGross_Expected}
    
    ##Compute for Host Bank Outstandings##
    ${LoanMerge_AmountNoComma}    Remove comma and convert to number    ${LoanMerge_Amount}
    ${GlobalFacility_HostOutstandings_Expected}    Evaluate    (${LoanMerge_AmountNoComma}*${Facility_HostBankOutstandings_Percentage})/100
    ${GlobalFacility_HostOutstandings_Expected}    Evaluate    "%.2f" % ${GlobalFacility_HostOutstandings_Expected}
    ${length}    Get Length    ${GlobalFacility_HostOutstandings_Expected}
    ${length}    Evaluate    int(${length})
    ${GlobalFacility_HostOutstandings_ExpectedString}    Convert to String    ${GlobalFacility_HostOutstandings_Expected}
    ${GlobalFacility_HostOutstandings_Expected}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${GlobalFacility_HostOutstandings_ExpectedString}    
    ${GlobalFacility_HostOutstandings_Expected}    Convert to String    ${GlobalFacility_HostOutstandings_Expected}
    
    ##Compute for Host Bank Available To Draw##
    ${LoanMerge_AmountNoComma}    Remove comma and convert to number    ${GlobalFacility_AvailToDrawBeforeMerge}
    ${GlobalFacility_HostAvailableToDraw_Expected}    Evaluate    (${LoanMerge_AmountNoComma}*${Facility_HostBankAvailToDraw_Percentage})/100
    ${GlobalFacility_HostAvailableToDraw_Expected}    Evaluate    "%.2f" % ${GlobalFacility_HostAvailableToDraw_Expected}
    ${length}    Get Length    ${GlobalFacility_HostAvailableToDraw_Expected}
    ${length}    Evaluate    int(${length})
    ${GlobalFacility_HostAvailableToDraw_ExpectedString}    Convert to String    ${GlobalFacility_HostAvailableToDraw_Expected}
    ${GlobalFacility_HostAvailableToDraw_Expected}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${GlobalFacility_HostAvailableToDraw_ExpectedString}    
    ${GlobalFacility_HostAvailableToDraw_Expected}    Convert to String    ${GlobalFacility_HostAvailableToDraw_Expected}
    
    ${GlobalFacility_HostAvailableToDraw_Expected}    Set Variable If    '${GlobalFacility_HostAvailableToDraw_Expected}'=='None'    0.00
    ...    ${GlobalFacility_HostAvailableToDraw_Expected}
    
    ## Recheck Values for computed contr gross, outstanding and avail to draw for Host Banks ##
    
    Should Be Equal    ${GlobalFacility_HostContrGross_Expected}    ${HostBank_ContrGrossAfterMerge}
    Should Be Equal    ${GlobalFacility_HostOutstandings_Expected}    ${HostBank_OutstandingsAfterMerge}
    Should Be Equal    ${GlobalFacility_HostAvailableToDraw_Expected}    ${HostBank_AvailToDrawAfterMerge}
        
    Validate Lender Share on Facility after Merge    ${GlobalFacility_CurrentCmtBeforeMerge}    ${LegalEntity}    ${Lender1}    ${Lender2}    ${LenderShareHost_Percentage}    ${Lender1ShareHost_Percentage}    ${Lender2ShareHost_Percentage}          

    Validate Circle Notebook on Facility after Merge    ${LegalEntity}    ${Facility}    ${GlobalFacility_CurrentCmtBeforeMerge_WithComma}
    
    Validate Outstanding Loans List after Merge    ${Facility}    ${Loan1_Alias}    ${Loan2_Alias}    ${LoanMerge_Alias}    ${Loan1_Amount}    ${Loan2_Amount}    ${LoanMerge_Amount}
   
    
Validate Lender Share on Facility after Merge
    [Documentation]    This keyword validates Lender Share data on the Facility Notebook after Loan Merge.
    ...    @author: chanario
    [ARGUMENTS]    ${GlobalFacility_CurrentCmt_ExpectedString}    ${HostBank}    ${Lender1}    ${Lender2}    ${LenderShareHost_Percentage}    ${Lender1ShareHost_Percentage}    ${Lender2ShareHost_Percentage}      
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}    
    mx LoanIQ select    ${LIQ_FacilityNotebook_Queries_LenderShares}
    
    ###Get Lender Share Amounts###
    
    ${ActualAmount_Host}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_Queries_LenderShares_JavaTree}    ${HostBank}%Actual Amount%ActualAmount_Host
    ${ActualAmount_Lender1}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_Queries_LenderShares_JavaTree}    ${Lender1}%Actual Amount%ActualAmount_Lender1
    ${ActualAmount_Lender2}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_Queries_LenderShares_JavaTree}    ${Lender2}%Actual Amount%ActualAmount_Lender2           

    ${ActualAmount_HostbankShares}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Facility_Queries_LenderShares_HostBank_JavaTree}    ${HostBank}%Actual Amount%ActualAmount_HostbankShares        

    ###Compute for Lender Share Expected Amounts###
    
    ${ActualAmount_Host_Expected}    Evaluate    (${GlobalFacility_CurrentCmt_ExpectedString}*${LenderShareHost_Percentage})/100
    ${ActualAmount_Host_Expected}    Evaluate    "%.2f" % ${ActualAmount_Host_Expected}
    ${length}    Get Length    ${ActualAmount_Host_Expected}
    ${length}    Evaluate    int(${length})
    ${ActualAmount_Host_ExpectedString}    Convert to String    ${ActualAmount_Host_Expected}
    ${ActualAmount_Host_Expected}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${ActualAmount_Host_ExpectedString}    
    ${ActualAmount_Host_Expected}    Convert to String    ${ActualAmount_Host_Expected}
    
    ${ActualAmount_Lender1_Expected}    Evaluate    (${GlobalFacility_CurrentCmt_ExpectedString}*${Lender1ShareHost_Percentage})/100    
    ${ActualAmount_Lender1_Expected}    Evaluate    "%.2f" % ${ActualAmount_Lender1_Expected}
    ${length}    Get Length    ${ActualAmount_Lender1_Expected}
    ${length}    Evaluate    int(${length})
    ${ActualAmount_Lender1_ExpectedString}    Convert to String    ${ActualAmount_Lender1_Expected}
    ${ActualAmount_Lender1_Expected}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${ActualAmount_Lender1_ExpectedString}    
    ${ActualAmount_Lender1_Expected}    Convert to String    ${ActualAmount_Lender1_Expected}
    
    ${ActualAmount_Lender2_Expected}    Evaluate    (${GlobalFacility_CurrentCmt_ExpectedString}*${Lender2ShareHost_Percentage})/100
    ${ActualAmount_Lender2_Expected}    Evaluate    "%.2f" % ${ActualAmount_Lender2_Expected}
    ${length}    Get Length    ${ActualAmount_Lender2_Expected}
    ${length}    Evaluate    int(${length})
    ${ActualAmount_Lender2_ExpectedString}    Convert to String    ${ActualAmount_Lender2_Expected}
    ${ActualAmount_Lender2_Expected}    Run Keyword If    ${length} >= 7    Convert Number With Comma Separators    ${ActualAmount_Lender2_ExpectedString}    
    ${ActualAmount_Lender2_Expected}    Convert to String    ${ActualAmount_Lender2_Expected}
    
    ###Validate Expected Values vs Current Values###
    
    Should Be Equal    ${ActualAmount_Host}    ${ActualAmount_Host_Expected}         
    Should Be Equal    ${ActualAmount_Lender1}    ${ActualAmount_Lender1_Expected}  
    Should Be Equal    ${ActualAmount_Lender2}    ${ActualAmount_Lender2_Expected}      
    Should Be Equal    ${ActualAmount_HostbankShares}    ${ActualAmount_Host_Expected}  
     
    Mx Native Type    {ESC}

Validate Circle Notebook on Facility after Merge
    [Documentation]    This keyword validates Circle Notebook data on the Facility Notebook after Loan Merge.
    ...    @author: chanario
    [ARGUMENTS]    ${Hostbank}    ${Facility}    ${GlobalFacility_CurrentCmt_Expected}
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}    
    mx LoanIQ select    ${LIQ_FacilityNotebook_Options_DealNotebook}
    mx LoanIQ select    ${LIQ_DealNotebook_Payments_TickingFeeDefinition_Menu}
    mx LoanIQ select    ${LIQ_DealNotebook_DistributionPrimaries_Menu}
    mx LoanIQ activate window     ${LIQ_PrimariesList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PrimariesList_JavaTree}    ${Hostbank}%d
    mx LoanIQ click element if present    ${LIQ_NotificationInformation_OK_Button}
    
    ${TermGlobalCommitmentAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Circle_Amounts_JavaTree}    ${Facility}%Global Commitment%TermGlobalCommitmentAmount
    Run Keyword And Continue On Failure    Should Be Equal    ${TermGlobalCommitmentAmount}    ${GlobalFacility_CurrentCmt_Expected}
    
    Mx Native Type    {ESC}
    
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Primaries_Window}    
    Mx Native Type    {ESC}
    
Validate Outstanding Loans List after Merge
    [Documentation]    This keyword validates Outstanding Select data on the Facility Notebook after Loan Merge.
    ...    @author: chanario
    [ARGUMENTS]    ${Facility}    ${Loan1_Alias}    ${Loan2_Alias}    ${LoanMerge_Alias}    ${Loan1_Amount}    ${Loan2_Amount}    ${LoanMerge_Amount} 
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Queries_OutstandingSelect}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility}
    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Inactive_Checkbox}    ON
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    
    mx LoanIQ activate window    ${LIQ_ExistingLoansForFacility_Window}
    
    ###Get Existing Loans Amounts###
    
    ${Loan1CurrentAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ExistingLoansForFacility_JavaTree}    ${Loan1_Alias}%Current Amount%Loan1CurrentAmt
    ${Loan2CurrentAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ExistingLoansForFacility_JavaTree}    ${Loan2_Alias}%Current Amount%Loan2CurrentAmt
    ${LoanMergeCurrentAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ExistingLoansForFacility_JavaTree}    ${LoanMerge_Alias}%Current Amount%LoanMergeCurrentAmt
    
    ${Loan1OriginalAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ExistingLoansForFacility_JavaTree}    ${Loan1_Alias}%Original Amount%Loan1OriginalAmt
    ${Loan2OriginalAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ExistingLoansForFacility_JavaTree}    ${Loan2_Alias}%Original Amount%Loan2OriginalAmt
    ${LoanMergeOriginalAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ExistingLoansForFacility_JavaTree}    ${LoanMerge_Alias}%Original Amount%LoanMergeOriginalAmt
    
    ###Validate Expected Values vs Current Values###
    
    Should Be Equal    ${Loan1CurrentAmt}    0.00
    Should Be Equal    ${Loan2CurrentAmt}    0.00
    Should Be Equal    ${LoanMergeCurrentAmt}    ${LoanMerge_Amount}
    
    Should Be Equal    ${Loan1OriginalAmt}    ${Loan1_Amount}
    Should Be Equal    ${Loan2OriginalAmt}    ${Loan2_Amount}
    Should Be Equal    ${LoanMergeOriginalAmt}    ${LoanMerge_Amount}
    
Validate Interest Payments Amount
    [Documentation]    This keyword is used to validate interest payment at Lone Repricing.
    ...    @author: hstone
    ...	   @update: hstone      28AUG2019    - Added take screenshot
    ...    @update: hstone      28MAY2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Removed unnecessary spacing
    [Arguments]    ${sPricingOption}    ${sPrevLoanAlias}    ${sExpectedInterestAmt}

    ### Keyword Pre-processing ###
    ${PricingOption}    Acquire Argument Value    ${sPricingOption}
    ${PrevLoanAlias}    Acquire Argument Value    ${sPrevLoanAlias}
    ${ExpectedInterestAmt}    Acquire Argument Value    ${sExpectedInterestAmt}

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    Take Screenshot    ComprehensiveRepricing_LoanRepricing
    ${InterestLoanAlias}    Catenate    SEPARATOR=    (    ${PrevLoanAlias}    )    
    ${InterestRowLabel}    Catenate    ${PricingOption}    Interest Payment    ${InterestLoanAlias}           
    ${ActualInterestAmt}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    ${InterestRowLabel}%Amount%ActualInterestAmt 
    ${ActualInterestAmt}    Remove Comma and Convert to Number    ${ActualInterestAmt}
    ${iExpectedInterestAmt}    Remove Comma and Convert to Number    ${ExpectedInterestAmt}
    ${status}    Run Keyword And Return Status    Should Be Equal    ${iExpectedInterestAmt}    ${ActualInterestAmt}   
    Run Keyword If    '${status}'=='True'    Log    Passed: Interest Payments Amount Verified
    ...    ELSE    Log    Failed: Interest Payments Amount displayed is ${ActualInterestAmt} instead of ${iExpectedInterestAmt}

Select Existing Outstandings for Loan Repricing
    [Documentation]    Low-level keyword used to select an Existing Outstanding in the Loan Repricing Notebook
    ...                This keyword also returns the amount to be used in succeeding validations
    ...                @author: bernchua    26AUG2019    Initial create
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    [Arguments]    ${sPricing_Option}    ${sLoan_Alias}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    ${Existing_Outstanding}    Set Variable    ${Pricing_Option} (${Loan_Alias})
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    ${Amount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricing_Outstanding_List}    ${Existing_Outstanding}%Amount%amount
    Mx LoanIQ Select String    ${LIQ_LoanRepricing_Outstanding_List}    ${Existing_Outstanding}
    [Return]    ${Amount}
    
Cick Add in Loan Repricing Notebook
    [Documentation]    Low-level keyword used to click the 'Add' button in the Loan Repricing Notebook
    ...                @author: bernchua    26AUG2019    Initial create
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_Add_Button}
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_RepricingDetail_Window}    VerificationData="Yes"
    Run Keyword If    ${STATUS}==True    Log    Repricing Detail Add Options window successfully displayed.
    ...    ELSE    Fail    Loan Repricing Add not successful.
    
Set Repricing Detail Add Options
    [Documentation]    Low-level keyword used to set and validate details in the 'Repricing Detail Add Option' window.
    ...                @author: bernchua    27AUG2019    Initial create
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    [Arguments]    ${sRepricing_AddOption}    ${sPricing_Option}    ${sFacility_Name}    ${sBorrower_Name}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Repricing_AddOption}    Acquire Argument Value    ${sRepricing_AddOption}
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Borrower_Name}    Acquire Argument Value    ${sBorrower_Name}

    mx LoanIQ activate window    ${LIQ_RepricingDetail_Window}
    Mx LoanIQ Set    JavaWindow("title:=Repricing Detail.*").JavaRadioButton("label:=.*${Repricing_AddOption}.*")    ON
    Run Keyword If    '${Repricing_AddOption}'=='Rollover/Conversion to New' or '${Repricing_AddOption}'=='Rollover/Conversion to Existing'    Run Keywords
    ...    Mx LoanIQ Select Combo Box Value    ${LIQ_RepricingDetail_Facility}    ${Facility_Name}
    ...    AND    Mx LoanIQ Select Combo Box Value    ${LIQ_RepricingDetail_PricingOption}    ${Pricing_Option}
    ...    AND    Mx LoanIQ Select Combo Box Value    ${LIQ_RepricingDetail_Borrower}    ${Borrower_Name}
    mx LoanIQ click    ${LIQ_RepricingDetail_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

Select Repricing Detail Add Options - Principal Payment
    [Documentation]    Low-level keyword used to set Repricing Detail Add Options to Principal Payment
    ...                @author: jloretiz    09JAN2019    - Initial create
    mx LoanIQ activate window    ${LIQ_RepricingDetail_Window}
    Mx LoanIQ Set    JavaWindow("title:=Repricing Detail.*").JavaRadioButton("label:=.*Principal Payment.*")    ON
    mx LoanIQ click    ${LIQ_RepricingDetail_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

Validate Loan Repricing New Outstanding Amount
    [Documentation]    Low-level keyword used to validate the displayed Amounts in the Loan Repricing Notebook JavaTee
    ...                @author: bernchua    27AUG2019    Initial create
    ...                @author: bernchua    11SEP2019    Updated keyword documentation
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    ...                @update: dahijara    25AUG2020    Added arguments, inserted set variable for description from test case level. Added screenshot
    ...                @update: cfrancis    19OCT2020    Updated UI_NewAmount to remove comma and convert to number
    [Arguments]    ${sPricing_Option}    ${sLoan_Alias}    ${sNewOutstanding_Amount}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
    ${NewOutstanding_Amount}    Acquire Argument Value    ${sNewOutstanding_Amount}

    ${Description}    Set Variable    ${Pricing_Option} (${Loan_Alias})
    
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    ${UI_NewAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricing_Outstanding_List}    ${Description}%Amount%amount
    ${UI_NewAmount}    Remove Comma and Convert to Number    ${UI_NewAmount}
    ${VALIDATE_NEWAMOUNT}    Run Keyword And Return Status    Should Be Equal    ${NewOutstanding_Amount}    ${UI_NewAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing_Outstanding
    Run Keyword If    ${VALIDATE_NEWAMOUNT}==True    Log    Amount for ${Description} successfully validated.
    ...    ELSE    Fail    Amount for ${Description} not validated successfully.     
 
Validate Loan Repricing New Outstanding Amount with Description
    [Documentation]    Low-level keyword used to validate the displayed Amounts in the Loan Repricing Notebook JavaTee with description
    ...                @author: aramos    14SEP2020    Initial Create
    [Arguments]    ${sPricing_Option}    ${sLoan_Alias}    ${ExtraDesc}    ${sNewOutstanding_Amount}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
    ${NewOutstanding_Amount}    Acquire Argument Value    ${sNewOutstanding_Amount}

    ${Description}    Set Variable    ${Pricing_Option} ${ExtraDesc} (${Loan_Alias})
    Log    ${Description}

    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    ${UI_NewAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricing_Outstanding_List}    ${Description}%Amount%amount
    ${VALIDATE_NEWAMOUNT}    Run Keyword And Return Status    Should Be Equal    ${NewOutstanding_Amount}    ${UI_NewAmount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing_Outstanding
    Run Keyword If    ${VALIDATE_NEWAMOUNT}==True    Log    Amount for ${Description} successfully validated.
    ...    ELSE    Fail    Amount for ${Description} not validated successfully.  
    
Validate Loan Repricing Effective Date
    [Documentation]    Low-level keyword used to validate the displayed 'Effective Date' in the Loan Repricing Notebook - General Tab.
    ...                @author: bernchua     27AUG2019    Initial create
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    ...    @update: dahijara    25AUG2020    Added screenshot
    [Arguments]    ${sEffective_Date}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
    
    mx LoanIQ activate window    ${LIQ_LoanRepricingForDeal_Window}
    ${UI_EffectiveDate}    Mx LoanIQ Get Data    ${LIQ_LoanRepricing_EffectiveDate_Text}    value%date
    ${VALIDATE_EFFECTIVEDATE}    Run Keyword And Return Status    Should Be Equal    ${Effective_Date}    ${UI_EffectiveDate}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricing_Outstanding
    Run Keyword If    ${VALIDATE_EFFECTIVEDATE}==True    Log    Loan Repricing Effective Date successfully validated.
    ...    ELSE    Fail    Loan Repricing Effective Date not validated successfully.
    
Confirm Cashflows for Loan Repricing
    [Documentation]    This keyword is used to confirm Cashflows for Loan Repricing
    ...    @author: hstone
    mx LoanIQ click    ${LIQ_LoanRepricing_CashflowsForLoan_OK_Button}

Select Loan to Process
    [Documentation]    This keyword is used to select an existing Loan to process in Loan Repricing
    ...    @author: ritragel    27SEP2019 Initial Create
    [Arguments]    ${sLoanAlias}
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    Mx LoanIQ Select String    ${LIQ_LoanRepricingForDealAdd_JavaTree}    ${sLoanAlias}
    Log    ${sLoanAlias} is selected
    

Add Repricing Details
    [Documentation]    This keyword is used for flexible roll over selection
    ...    @author: ritragel    09SEP2019
    [Arguments]    ${sRepricing_Detail}    ${sPricing_Option}=None
    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    mx LoanIQ click    ${LIQ_LoanRepricingForDeal_Add_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}                           
    mx LoanIQ activate    ${LIQ_RepricingDetailAddOptions_Window}
    mx LoanIQ enter    JavaWindow("label:=Repricing Detail.*","displayed:=1").JavaRadioButton("label:=${sRepricing_Detail}")    ON 
    Run Keyword if    '${sPricing_Option}'!='None'    mx LoanIQ select list    ${LIQ_RepricingDetailAddOptions_PricingOption_Dropdown}    ${sPricing_Option}
    mx LoanIQ click    ${LIQ_RepricingDetailAddOptions_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    
Verify Interest Payment
    [Documentation]    Verification of interest payment after adding to the Rollover
    ...    @author: ritragel    09SEP2019
    ...    @update: xmiranda    27SEP2019    - updated the Requested Amount Text field. 
    [Arguments]    ${sRequested Amount}    ${sEffectiveDate}
    mx LoanIQ activate window    ${LIQ_InterestPayment_Window}
    ${LIQ_InterestPayment_RequestedAmount_Textfield_Final}    Set Variable    JavaWindow("title:=.* Interest Payment.*").JavaEdit("editable:=1","value:=${sRequested_Amount}")
    mx LoanIQ enter    ${LIQ_InterestPayment_RequestedAmount_Textfield_Final}    ${sRequested_Amount}
    # Mx Enter    ${LIQ_InterestPayment_RequestedAmount_Textfield}    ${sRequested_Amount}
    ${sUI_Date}    Mx LoanIQ Get Data    ${LIQ_InterestPayment_EffectiveDate_Textfield}    value%date
    Should Be Equal As Strings    ${sUI_Date}    ${sEffectiveDate}
    Select Menu Item    ${LIQ_InterestPayment_Window}    File    Save
    Select Menu Item    ${LIQ_InterestPayment_Window}    File    Exit
    
Get Alias and Populate details on Rates Tab
    [Documentation]    This keywword gets the alias and populate the details on rates tab for rollover
    ...    @author: fmamaril    24SEP2019    Initial Create
    [Arguments]    ${iBorrower_Base_Rate}
    mx LoanIQ activate window    ${LIQ_RolloverConversion_Window} 
    ${NewLoanAlias}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_Alias_Textfield}    NewLoanAlias
    Mx LoanIQ Select Window Tab    ${LIQ_RolloverConversion_Tab}    Rates
    mx LoanIQ click    ${LIQ_RolloverConversion_BaseRate_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window    ${LIQ_SetBaseRate_Window}    
    Run keyword and Ignore Error    mx LoanIQ enter    ${LIQ_SetBaseRate_BorrowerBaseRate_Textfield}    ${iBorrower_Base_Rate}
    Run keyword and Ignore Error    mx LoanIQ click    ${LIQ_SetBaseRate_Ok_Button}
    Run keyword and Ignore Error    mx LoanIQ click    ${LIQ_RolloverConversion_BaseRate_Button}   
    Run keyword and Ignore Error    mx LoanIQ enter    ${LIQ_SetBaseRate_BorrowerBaseRate_Textfield}    ${iBorrower_Base_Rate}
    Run keyword and Ignore Error    mx LoanIQ click    ${LIQ_SetBaseRate_Ok_Button}
    Take Screenshot    ComprehensiveRepricing_PendingRolloverConversion_RatesTab     
    mx LoanIQ select    ${LIQ_RolloverConversion_FileExit_Menu}
    [Return]    ${NewLoanAlias}   

Add Changes for Quick Repricing
    [Documentation]    This keywword enters the changes required for quick repricing of the outstanding and sends it for approval
    ...    @author: sahalder    01JUN2020    Initial Create
    [Arguments]    ${s_Borrower_Base_Rate}    ${s_ReqChangeAmt}
    
    ### GetRuntime Keyword Pre-processing ###
    ${ReqChangeAmt}    Acquire Argument Value    ${s_ReqChangeAmt}
    ${Borrower_Base_Rate}    Acquire Argument Value    ${s_Borrower_Base_Rate}   

    mx LoanIQ activate window    ${LIQ_LoanRepricing_QuickRepricing_Window}
    ${NewLoanAlias}    Mx LoanIQ Get Data    ${LIQ_LoanRepricing_QuickRepricing_Alias_Textfield}    NewLoanAlias
    Run Keyword If    '${ReqChangeAmt}'!='None'    mx LoanIQ enter    ${LIQ_LoanRepricing_QuickRepricing_ReqChangeAmount_Textfield}    ${ReqChangeAmt}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/QuickRepricing_GeneralTab
	${SystemDate}    Get System Date    
    mx LoanIQ enter    ${LIQ_LoanRepricing_QuickRepricing_EffectiveDate_Textfield}    ${SystemDate}
    mx LoanIQ select    ${LIQ_LoanRepricing_QuickRepricing_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_QuickRepricing_Tab}    Rates
    mx LoanIQ click    ${LIQ_LoanRepricing_QuickRepricing_BaseRate_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    # Mx Click Element If Present    ${LIQ_RolloverConversion_BaseRate_Button}
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    # Mx Click Element If Present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ enter    ${LIQ_SetBaseRate_BorrowerBaseRate_Textfield}    ${Borrower_Base_Rate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/QuickRepricing_RatesTab
    mx LoanIQ click    ${LIQ_SetBaseRate_Ok_Button}
    
	[Return]    ${NewLoanAlias}

Approve Loan Repricing And Send to Rate Approval
    [Documentation]    This keyword is used to Approved Rate Setting Notice and to Send the Transaction Rates for approval and approve it with different user
    ...    @author: sahalder    03JUN2020    Initial Create   
    mx LoanIQ activate window    ${LIQ_LoanRepricing_QuickRepricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_QuickRepricing_Tab}    Workflow  
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricing_QuickRepricingForDeal_Workflow_JavaTree}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}   
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/QuickRepricing_Workflow
    mx LoanIQ activate window    ${LIQ_LoanRepricing_QuickRepricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_QuickRepricing_Tab}    Workflow  
    Mx LoanIQ DoubleClick    ${LIQ_LoanRepricing_QuickRepricingForDeal_Workflow_JavaTree}    Send to Rate Approval

Navigate to Loan Repricing Workflow and Proceed With Transaction
    [Documentation]    This keyword navigates to the Loan Drawdown Workflow using the desired Transaction
    ...  @author: hstone    26MAY2020    Initial create
    ...    @update: amansuet    15JUN2020    - updated take screenshot
    [Arguments]    ${sTransaction}

    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}

    Navigate Notebook Workflow    ${LIQ_LoanRepricingForDeal_Window}    ${LIQ_LoanRepricingForDeal_Workflow_Tab}    ${LIQ_LoanRepricingForDeal_Workflow_JavaTree}    ${Transaction}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingWindow_WorkflowTab

Add Rollover Conversion to New
    [Documentation]    This keyword is used to Rollover Conversion to New.
    ...    @author: hstone     28MAY2020     - Initial Create
    ...    @update: amansuet    15JUN2020    - added condition to get Increase amount value and return for Cashflow calculation
    ...                                      - updated take screenshot
    ...                                      - added post processing keyword for returned values
    ...    @update: clanding    13AUG2020    - updated hard coded values to global variables
    [Arguments]    ${sPricing_Option}    ${sBorrower_Base_Rate}    ${sNewRequestedAmt}=None    ${sRepricingFrequency}=None    ${sRunTimeVar_NewLoanAlias}=None    ${sRunTimeVar_IncreaseAmount}=None

    ### Keyword Pre-processing ###
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${Borrower_Base_Rate}    Acquire Argument Value    ${sBorrower_Base_Rate}
    ${NewRequestedAmt}    Acquire Argument Value    ${sNewRequestedAmt}
    ${RepricingFrequency}    Acquire Argument Value    ${sRepricingFrequency}

    ### Loan Repricing Window
    Mx LoanIQ Activate Window    ${LIQ_LoanRepricingForDeal_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanRepricingForDealWindow_GeneralTab
    Mx LoanIQ Click    ${LIQ_LoanRepricingForDeal_Add_Button}

    ### Repricing Detail Add Window ###
    Select Repricing Detail Add Options    ${ROLLOVER_CONVERSION_TO_NEW}    ${Pricing_Option}

    ### Rollover Conversion Window
    Mx LoanIQ Activate Window    ${LIQ_RolloverConversion_Window} 
    ${NewLoanAlias}    Mx LoanIQ Get Data    ${LIQ_RolloverConversion_Alias_Textfield}    ${NEW_LOAN_ALIAS}
    Run Keyword If    '${NewRequestedAmt}'!='None'    Mx LoanIQ Enter    ${LIQ_RolloverConversion_RequestedAmt_TextField}    ${NewRequestedAmt}
    Run Keyword If    '${RepricingFrequency}'!='None'    Mx LoanIQ Select List    ${LIQ_PendingRollover_RepricingFrequency_Dropdown}    ${RepricingFrequency}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RolloverConversionWindow_GeneralTab
    Mx LoanIQ Select    ${LIQ_RolloverConversion_Save_Menu}     
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_RolloverConversion_Tab}    ${RATES_TAB}
    Mx LoanIQ Click    ${LIQ_RolloverConversion_BaseRate_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Enter    ${LIQ_SetBaseRate_BorrowerBaseRate_Textfield}    ${Borrower_Base_Rate}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RolloverConversionWindow_GeneralTab
    Mx LoanIQ Click    ${LIQ_SetBaseRate_Ok_Button}
    Mx LoanIQ Select    ${LIQ_RolloverConversion_FileExit_Menu}

    ### Get Increase Amount
    Mx LoanIQ Activate Window    ${LIQ_LoanRepricingForDeal_Window}
    ${IncreaseAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanRepricingForDealAdd_JavaTree}    *** Increase:%Amount%IncreaseAmount

    Log    Keyword Finished: 'Add Rollover Conversion to New'

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_NewLoanAlias}    ${NewLoanAlias}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_IncreaseAmount}    ${IncreaseAmount}

    [Return]    ${NewLoanAlias}    ${IncreaseAmount}

Get Calculated Cycle Due Amount and Validate
    [Documentation]    This keyword is for calculating cycle due amount and return.
    ...    @author: amansuet    18JUN2020    - initial create
    ...    @update: clanding    13AUG2020    - added using Cycle Due Date value if provided
	[Arguments]    ${iBalance_Amount}    ${iAllInRate_Pct}    ${sRate_Basis}    ${iUI_CycleDue}    ${sStart_Date}    ${sCycleDueDate}=None    ${sRuntimeVar_CalculatedCycleDue}=None

    ### Keyword Pre-processing ###
    ${Balance_Amount}    Acquire Argument Value    ${iBalance_Amount}
    ${AllInRate_Pct}    Acquire Argument Value    ${iAllInRate_Pct}
    ${Rate_Basis}    Acquire Argument Value    ${sRate_Basis}
    ${UI_CycleDue}    Acquire Argument Value    ${iUI_CycleDue}
    ${Start_Date}    Acquire Argument Value    ${sStart_Date}
    ${CycleDueDate}    Acquire Argument Value    ${sCycleDueDate}

	${CurrentSystemDate}    Run Keyword If    '${sCycleDueDate}'=='None'    Get System Date
	...    ELSE    Set Variable    ${CycleDueDate}

	###Get Number of Days###
	${CycleDue_CurrentNoofDays}    Subtract Date From Date    ${CurrentSystemDate}    ${Start_Date}    result_format=verbose    date1_format=%d-%b-%Y    date2_format=%d-%b-%Y
    Log    ${CycleDue_CurrentNoofDays}
    ${CycleDue_CurrentNoofDays}    Remove String    ${CycleDue_CurrentNoofDays}    day    s
    ${CycleDue_CurrentNoofDays}    Convert To Number    ${CycleDue_CurrentNoofDays}

    ###Calculation of Cycle Due###
    ${Calculated_CycleDue}    Evaluate    ((${Balance_Amount}*(${AllInRate_Pct}/100))*(${CycleDue_CurrentNoofDays}))/(${Rate_Basis})
    ${RoundedOff_CycleDue}    Convert To Number    ${Calculated_CycleDue}    2

    ###Validate UI Projected and Calculated Cycle Due###
    ${CycleDue}    Remove String    ${UI_CycleDue}    ,
    ${CycleDue}    Convert To Number    ${CycleDue}    2
    Should Be Equal    ${CycleDue}    ${RoundedOff_CycleDue}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntimeVar_CalculatedCycleDue}    ${Calculated_CycleDue}

    [Return]    ${Calculated_CycleDue}


Navigate to Existing Outstanding
    [Documentation]    This keyword is for navigating to the existing outstanding inside the facility notebook
    ...    @author: sahalder    09JUL2020    - initial create
    ...    @update: dahijara    28SEP2020    - Removed locator as part of argument. Directly passed the locator to Mx LoanIQ Select keyword
    ...                                      - Added Screenshot
	[Arguments]    ${sOutstandingSelect_Type}    ${sFacility_Name}

    ### Keyword Pre-processing ###
    ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    
    mx LoanIQ select    ${LIQ_FacilityNotebook_Options_DealNotebook}
    Search for Existing Outstanding    ${OutstandingSelect_Type}    ${Facility_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelectWindow
    
Navigate to Loan Repricing Notebook Workflow
    [Documentation]    This keyword navigates the Workflow tab of a Loan Repricing Notebook, and does a specific transaction.
    ...    
    ...    | Arguments |
    ...    
    ...    'Transaction' = The type of transaction listed under Workflow. Ex. Send to Approval, Approve, Release
    ...    
    ...    @author: bernchua    09JUL2020    initial create
    
    [Arguments]    ${sTransaction}    

    ###Pre-processing Keyword##
    ${Transaction}    Acquire Argument Value    ${sTransaction} 

    mx LoanIQ activate window    ${LIQ_LoanRepricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanRepricing_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NotebookWorkflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LoanRepricing_WorkflowItems}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NotebookWorkflow