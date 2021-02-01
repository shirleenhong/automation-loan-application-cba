*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Select Pricing Change Transaction Menu 
    [Documentation]    This keyword selects the option Pricing Change Transaction from the Facility Notebook.
    ...    @author: mgaling  
    ...    @update: jdelacru    09OCT2019    - Added message box validation after selecting pricing change transaction menu
    ...    @update: clanding    10AUG2020    - Added screenshot, added pre processing keyword; removed sleep
    [Arguments]    ${sPricing_Status}
    
    ### Keyword Pre-processing ###
    ${Pricing_Status}    Acquire Argument Value    ${sPricing_Status}
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    mx LoanIQ select    ${LIQ_FacilityNotebook_Options_PricingChangeTransaction}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ activate window    ${LIQ_PCT_AvailablePricing_Window}       
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PCT_AvailablePricing_List}    ${Pricing_Status}%s     
    mx LoanIQ click    ${LIQ_PCT_AvailablePricing_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AvailablePricingWindow
    
Populate Pricing Change Notebook General Tab
     [Documentation]    This keyword is used to populate data in Pricing Change Notebook-General Tab.
    ...    @author: mgaling
    ...    @update: bernchua    08MAR2019    Updated keyword as per standards:    
    ...                                      - Removed "Auto Generate Only 4 Numeric Test Data" & "Get System Date". This keywords should be used in the high-level prior to calling of this keyword.
    ...                                      - Removed "Write Data To Excel" of ${TransactionNo} & ${PCT_EffectiveDate}
    ...    	                                 - Removed Argument ${TransactionNo_Prefix}
    ...    @update: clanding    10AUG2020    - Added screenshot; added pre processing keyword; replaced 'Mx Native Type' to 'Mx Press Combination'
    [Arguments]    ${sTransaction_Number}    ${sPCT_EffectiveDate}    ${sPricingChange_Description}
   
    ### Keyword Pre-processing ###
    ${Transaction_Number}    Acquire Argument Value    ${sTransaction_Number}
    ${PCT_EffectiveDate}    Acquire Argument Value    ${sPCT_EffectiveDate}
    ${PricingChange_Description}    Acquire Argument Value    ${sPricingChange_Description}
    
    mx LoanIQ activate    ${LIQ_PricingChangeTransaction_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_PCT_Tab}    ${GENERAL_TAB}   
    mx LoanIQ enter    ${LIQ_PCT_TransactionNo}    ${Transaction_Number}
    mx LoanIQ enter    ${LIQ_PCT_EffectiveDate}    ${PCT_EffectiveDate}
    mx LoanIQ enter    ${LIQ_PCT_Description}    ${PricingChange_Description}
    Mx Press Combination    Key.BACKSPACE
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PricingChangeTransactionNotebook
    
Navigate to Pricing Tab - Modify Interest Pricing
     [Documentation]    This keyword is used to navigate Interest Pricing.
    ...    @author: mgaling
    ...    @update: clanding    10AUG2020    - Added screenshot; replaced hard coded value to global variables
    
    mx LoanIQ activate    ${LIQ_PricingChangeTransaction_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_PCT_Tab}    ${PRICING_TAB}
    mx LoanIQ click    ${LIQ_PCT_ModifyInterestPricing_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PricingChangeTransactionNotebook

Clear Interest Pricing Current Values
     [Documentation]    This keyword is used to clear current Interest Pricing values.
    ...    @author: clanding    11AUG2020    - initial create

    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ click    ${LIQ_PCT_InterestPricing_Clear_Button}
    mx LoanIQ click    ${LIQ_Question_Yes_Button}
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}

Add Matrix Item
     [Documentation]    This keyword is used to modify Interest Pricing by adding Matrix Item.
    ...    @author: mgaling
    ...    @update: clanding    10AUG2020    - Added screenshot; added pre processing keyword
    [Arguments]    ${sPCT_InterestPricingItem}    ${sPCT_InterestPricingType}     ${sPCT_FinancialRatioType}    ${sMinimumValue}    ${sMaximumValue}
    
    ### Keyword Pre-processing ###
    ${PCT_InterestPricingItem}    Acquire Argument Value    ${sPCT_InterestPricingItem}
    ${PCT_InterestPricingType}    Acquire Argument Value    ${sPCT_InterestPricingType}
    ${PCT_FinancialRatioType}    Acquire Argument Value    ${sPCT_FinancialRatioType}
    ${MinimumValue}    Acquire Argument Value    ${sMinimumValue}
    ${MaximumValue}    Acquire Argument Value    ${sMaximumValue}

    mx LoanIQ click    ${LIQ_PCT_InterestPricing_Add_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${PCT_InterestPricingItem}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_Type_List}    ${PCT_InterestPricingType}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}
    mx LoanIQ activate    ${LIQ_FacilityPricing_InterestPricing_FinancialRatio_Window}
    mx LoanIQ select list    ${LIQ_FinancialRatio_Type}    ${PCT_FinancialRatioType}    
    mx LoanIQ enter    ${LIQ_FinancialRatio_MinimumValue_Field}    ${MinimumValue}
    mx LoanIQ enter    ${LIQ_FinancialRatio_MaximumValue_Field}    ${MaximumValue}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow
    mx LoanIQ click    ${LIQ_FinancialRatio_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow

Add Matrix Item - Mnemonic
    [Documentation]    This keyword is used to add matrix item with Mnemonic being checked.
    ...    @author: mgaling
    ...    @update: clanding    10AUG2020    - Added screenshot; added pre processing keyword
    [Arguments]    ${sPCT_InterestPricingItem}    ${sPCT_InterestPricingType}     ${sPCT_FinancialRatioType}    ${sMaximumValue}    ${sMnemonic_Value}
    
    ### Keyword Pre-processing ###
    ${PCT_InterestPricingItem}    Acquire Argument Value    ${sPCT_InterestPricingItem}
    ${PCT_InterestPricingType}    Acquire Argument Value    ${sPCT_InterestPricingType}
    ${PCT_FinancialRatioType}    Acquire Argument Value    ${sPCT_FinancialRatioType}
    ${Mnemonic_Value}    Acquire Argument Value    ${sMnemonic_Value}
    ${MaximumValue}    Acquire Argument Value    ${sMaximumValue}
    
   
    mx LoanIQ activate window     ${LIQ_Facility_InterestPricing_Window}
    mx LoanIQ click    ${LIQ_PCT_InterestPricing_Add_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${PCT_InterestPricingItem}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_Type_List}    ${PCT_InterestPricingType}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}
    mx LoanIQ activate    ${LIQ_FacilityPricing_InterestPricing_FinancialRatio_Window}
    mx LoanIQ select list    ${LIQ_FinancialRatio_Type}    ${PCT_FinancialRatioType}    
    mx LoanIQ enter    ${LIQ_FinancialRatio_MinimumValue_Field}    ${MaximumValue}
    Mx LoanIQ Check Or Uncheck    ${LIQ_FinancialRatio_Mnemonic_CheckBox}    ${ON}
    mx LoanIQ select list    ${LIQ_FinancialRatio_Mnemonic_List}    ${Mnemonic_Value}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow   
    mx LoanIQ click    ${LIQ_FinancialRatio_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow
    
Add After Option Item - First
    [Documentation]    Select the value for the First Option.
    ...    @author: mgaling
    ...    @update: clanding    10AUG2020    - Added screenshot; added pre processing keyword
    [Arguments]    ${sPCT_InterestPricingItem}    ${sPCT_InterestPricingType}    ${sOptionName}    ${sRateBasisInterestPricing}    ${sSpread}    ${sRateFormulaUsage}=None
    
    ### Keyword Pre-processing ###
    ${PCT_InterestPricingItem}    Acquire Argument Value    ${sPCT_InterestPricingItem}
    ${PCT_InterestPricingType}    Acquire Argument Value    ${sPCT_InterestPricingType}
    ${OptionName}    Acquire Argument Value    ${sOptionName}
    ${RateBasisInterestPricing}    Acquire Argument Value    ${sRateBasisInterestPricing}
    ${Spread}    Acquire Argument Value    ${sSpread}
    ${RateFormulaUsage}    Acquire Argument Value    ${sRateFormulaUsage}
    
    mx LoanIQ click    ${LIQ_PCT_InterestPricing_After_Button} 
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_AddItem_List}    ${PCT_InterestPricingItem}
    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_Type_List}    ${PCT_InterestPricingType}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_AddItem_OK_Button}
        
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_OptionName_List}    ${OptionName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_RateBasis_List}    ${RateBasisInterestPricing}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OptionCondition_OK_Button}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ${ON}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread}
    Run Keyword If    '${RateFormulaUsage}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_RateFormulaUsage_List}    ${RateFormulaUsage}
    ...    ELSE    Log    No Rate Formulate Usage provided
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button}
    mx LoanIQ click element if present    ${LIQ_PleaseConfirm_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow

Add After Option Item - Second
    [Documentation]    Select the value for the Second Option.
    ...    @author: mgaling
    ...    @update: clanding    10AUG2020    - Added screenshot; added pre processing keyword
    ...    @update: dahijara    09DEC2020    - Added optional condition for inputting Formula Text
    [Arguments]    ${sOptionName}    ${sRateBasisInterestPricing}    ${sSpread}    ${sRateFormulaUsage}=None    ${sFormulaText}=None
    
    ### Keyword Pre-processing ###
    ${OptionName}    Acquire Argument Value    ${sOptionName}
    ${RateBasisInterestPricing}    Acquire Argument Value    ${sRateBasisInterestPricing}
    ${Spread}    Acquire Argument Value    ${sSpread}
    ${RateFormulaUsage}    Acquire Argument Value    ${sRateFormulaUsage}
    ${FormulaText}    Acquire Argument Value    ${sFormulaText}
    
    mx LoanIQ activate    ${LIQ_FacilityPricing_Interest_OptionCondition_Window}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_OptionName_List}    ${OptionName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_RateBasis_List}    ${RateBasisInterestPricing}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OptionCondition_OK_Button}
    Run Keyword If    '${FormulaText}' != 'None'    Run Keywords    Mx LoanIQ click    ${LIQ_Facility_InterestPricing_FormulaCategoryFormulaText_TextField}
    ...    AND    Mx Press Combination    Key.CTRL    Key.A
    ...    AND    Mx Press Combination    Key.BACKSPACE
    ...    AND    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategoryFormulaText_TextField}    ${FormulaText}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ${ON}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread}
    Run Keyword If    '${RateFormulaUsage}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_Facility_InterestPricing_RateFormulaUsage_List}    ${RateFormulaUsage}
    ...    ELSE    Log    No Rate Formulate Usage provided
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button} 
    mx LoanIQ click element if present    ${LIQ_PleaseConfirm_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow

Add After Option Item - Third
    [Documentation]    Select the value for the Third Option.
    ...    @author: mnanquilada
    [Arguments]    ${sOptionName}    ${sRateBasisInterestPricing}    ${sSpread}
    ### Keyword Pre-processing ###
    ${OptionName}    Acquire Argument Value    ${sOptionName}
    ${RateBasisInterestPricing}    Acquire Argument Value    ${sRateBasisInterestPricing}
    ${Spread}    Acquire Argument Value    ${sSpread}
    mx LoanIQ activate    ${LIQ_FacilityPricing_Interest_OptionCondition_Window}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_OptionName_List}    ${OptionName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OptionCondition_RateBasis_List}    ${RateBasisInterestPricing}
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_OptionCondition_OK_Button}
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ON
    mx LoanIQ enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow
    mx LoanIQ click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button} 
    mx LoanIQ click element if present    ${LIQ_PleaseConfirm_Yes_Button} 
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow
    
Validate the Interest Pricing Values with Matrix Item
    [Documentation]    This keyword validates the values.
    ...    @author: mgaling
    ...    @update: clanding    10AUG2020    - Added screenshot
    [Tags]    Validation
    
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_Window}   
    mx LoanIQ click    ${LIQ_PCT_InterestPricing_Validate_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Validation_Congratulations_Window}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow
    mx LoanIQ click    ${LIQ_Congratulations_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow
    mx LoanIQ click    ${LIQ_PCT_InterestPricing_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityInterestPricingWindow
    
Pricing Change Transaction Send to Approval
      [Documentation]    This keyword is for Send to Approval in Pricing Change Transaction.
    ...    @author: mgaling
    ...    @update: clanding    10AUG2020    - Added screenshot; replaced hard coded values to global variables
    
    mx LoanIQ activate    ${LIQ_PricingChangeTransaction_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_PCT_Tab}    ${WORKFLOW_TAB}
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PCT_Workflow_JavaTree}    ${SEND_TO_APPROVAL_STATUS}%d
	Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PricingChangeTransactionNotebook
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate window   ${LIQ_PCT_AwaitingApproval_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AwaitingApprovalWindow

Pricing Change Transaction Approval
    [Documentation]    This keyword is for approval of Pricing Change Transaction Notebook.
    ...    @author: mgaling
    ...    @update: bernchua    08MAR2019    Updated clicking of warning messages to use "Validate if Question or Warning Message is Displayed"
    ...    @update: clanding    10AUG2020    - Added screenshot; added pre processing keyword; replaced sleep; replaced hard coded values to global variables
    [Arguments]    ${sWIPTransaction_Type}    ${sTransaction_Status_AwaitingApproval}    ${sFacilityTransaction_Type}    ${sDeal_Name}
    
    ### Keyword Pre-processing ###
    ${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}
    ${Transaction_Status_AwaitingApproval}    Acquire Argument Value    ${sTransaction_Status_AwaitingApproval}
    ${FacilityTransaction_Type}    Acquire Argument Value    ${sFacilityTransaction_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    ##Open Amendment Notebook thru WIP - Awaiting Approval     
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${Transaction_Status_AwaitingApproval}         
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${Transaction_Status_AwaitingApproval}
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    '${Transaction_Status_AwaitingApproval}' is not displayed in Work In Process.

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${FacilityTransaction_Type}
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${FacilityTransaction_Type}  
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    '${FacilityTransaction_Type}' is not displayed in Work In Process.    

    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WIP_Transaction
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${Deal_Name}%d
    
	mx LoanIQ activate window    ${LIQ_PricingChangeTransaction_Notebook}
	Mx LoanIQ Select Window Tab    ${LIQ_PCT_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PCT_Workflow_JavaTree}    ${APPROVAL_STATUS}%d  
    Validate if Question or Warning Message is Displayed
    mx LoanIQ activate window    ${LIQ_PCT_AwaitingRelease_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AwaitingReleaseWindow
    
Pricing Change Transaction Release
     [Documentation]    This keyword is for the release of Pricing Change Transaction Notebook.
    ...    @author: mgaling
    ...    @update: clanding    10AUG2020    - Added screenshot; added pre processing keyword; replaced sleep; replaced hard coded values to global variables
    [Arguments]    ${sWIPTransaction_Type}    ${sTransaction_Status_AwaitingRelease}    ${sFacilityTransaction_Type}    ${sDeal_Name}
    
    ### Keyword Pre-processing ###
    ${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}
    ${Transaction_Status_AwaitingRelease}    Acquire Argument Value    ${sTransaction_Status_AwaitingRelease}
    ${FacilityTransaction_Type}    Acquire Argument Value    ${sFacilityTransaction_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

        
    ##Open Amendment Notebook thru WIP - Awaiting Release Approval     
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${Transaction_Status_AwaitingRelease}         
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${Transaction_Status_AwaitingRelease}
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    '${Transaction_Status_AwaitingRelease}' is not displayed in Work In Process.

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${FacilityTransaction_Type}
    Run Keyword If    ${status}==${True}    Mx LoanIQ DoubleClick    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${FacilityTransaction_Type}
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    '${FacilityTransaction_Type}' is not displayed in Work In Process.
    
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/WorkInProgressWindow  
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_WorkInProcess_TransactionStatus_FacilityList}    ${Deal_Name}%d
    
    mx LoanIQ activate window    ${LIQ_PricingChangeTransaction_Notebook}
    Mx LoanIQ Select Window Tab    ${LIQ_PCT_Tab}    ${WORKFLOW_TAB}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PCT_Workflow_JavaTree}    ${RELEASE_STATUS}%d
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PricingChangeTransactionWindow
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ activate    ${LIQ_PCTNotebookReleased_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PCTNotebookReleased_WorkflowTab_NoItems}    VerificationData="Yes"
    mx LoanIQ activate    ${LIQ_PCTNotebookReleased_Window}
    mx LoanIQ select    ${LIQ_PCTNotebookReleased_FileExit_Menu}
    mx LoanIQ activate    ${LIQ_TransactionInProcess_Window}
    mx LoanIQ select    ${LIQ_TransactionsInProcess_FileExit_Menu}
    mx LoanIQ activate window    ${LIQ_PCT_Released_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/ReleasedWindow
    
##########Pricing Change Ongoing Fees##############
Save Ongoing Fee Rate in Facility Notebook  
    [Documentation]    This keyword is used to save the Ongoing Fee Rate of the Facility.
    ...    @author: rtarayao
    ...    @update: fmamaril    10MAR2019    Remove Write Data To Excel on Low Level Keyword
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added keyword pre and post processing
    ...                                      - fixed hardcoded locator
    ...                                      - modified keyword and make it  dynamic
    [Arguments]    ${sRuntime_Variable}=None

    Mx LoanIQ Activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_Pricing_Tab}    VerificationData="Yes"
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricing_OngoingFeeRate}    Unutilized%s
    ${Facility_OngoingFeeRateString}    Mx LoanIQ Get Data    ${LIQ_FacilityPricing_OngoingFeeRate}    Value
    ${Facility_OngoingFeeRatePercentage}    Run Keyword And Continue On Failure    Get Substring    ${Facility_OngoingFeeRateString}    28    -2
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityWindow_PricingTab

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${Facility_OngoingFeeRatePercentage}

    [Return]    ${Facility_OngoingFeeRatePercentage}

Navigate to Pricing Change Transaction Menu 
    [Documentation]    This keyword selects the option Pricing Change Transaction from the Facility Notebook.
    ...    @author: amansuet    26MAY2020    - initial create

    Mx LoanIQ Activate Window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select    ${LIQ_FacilityNotebook_Options_PricingChangeTransaction}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button} 
    Mx LoanIQ Activate Window    ${LIQ_PendingPricingChangeTransaction_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingPricingChangeTransactionWindow_GeneralTab

Input Pricing Change Transaction General Information          
    [Documentation]    This keyword is used to enter values for all fields in the general tab when doing Pricing Change Transaction.
    ...    @author: rtarayao
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added keyword pre and post processing
    ...                                      - fixed hardcoded locators
    ...                                      - removed unused keywords
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}    ${sPricingChange_TransactionNo}    ${sPricingChange_EffectiveDate}    ${sPricingChange_Desc}
    
    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${PricingChange_TransactionNo}    Acquire Argument Value    ${sPricingChange_TransactionNo}
    ${PricingChange_EffectiveDate}    Acquire Argument Value    ${sPricingChange_EffectiveDate}
    ${PricingChange_Desc}    Acquire Argument Value    ${sPricingChange_Desc}

    Mx LoanIQ Select Window Tab    ${LIQ_PricingChangeTransaction_Tab}    General    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_General_Tab}    VerificationData="Yes"

    ${Deal_Name}    Replace Variables    ${Deal_Name}
    ${LIQ_PricingChangeTransaction_GeneralTab_DealName}    Replace Variables    ${LIQ_PricingChangeTransaction_GeneralTab_DealName}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_GeneralTab_DealName}    VerificationData="Yes"

    ${Facility_Name}    Replace Variables    ${Facility_Name}
    ${LIQ_PricingChangeTransaction_GeneralTab_FacilityName}    Replace Variables    ${LIQ_PricingChangeTransaction_GeneralTab_FacilityName}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_GeneralTab_FacilityName}    VerificationData="Yes"

    Mx LoanIQ Enter    ${LIQ_PricingChangeTransaction_TransactionNo_Textfield}    ${PricingChange_TransactionNo}
    Mx LoanIQ Enter    ${LIQ_PricingChangeTransaction_EffectDate_Datefield}    ${PricingChange_EffectiveDate}    
    Mx LoanIQ Enter    ${LIQ_PricingChangeTransaction_Description_Textfield}    ${PricingChange_Desc}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PendingPricingChangeTransactionWindow_GeneralTab
    Validate Pricing Change General Information    ${PricingChange_TransactionNo}    ${PricingChange_EffectiveDate}    ${PricingChange_Desc}
    
Validate Pricing Change General Information
    [Documentation]    This keyword is used to validate the inputted values are accepted in the general tab when doing Pricing Change Transaction.
    ...    @author: rtarayao
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and fixed hardcoded locators
    [Arguments]    ${sPricingChange_TransactionNo}    ${sPricingChange_EffectiveDate}    ${sPricingChange_Desc}
    
    ${PricingChange_TransactionNo}    Replace Variables    ${sPricingChange_TransactionNo}
    ${LIQ_PricingChangeTransaction_GeneralTab_TransactionNumber}    Replace Variables    ${LIQ_PricingChangeTransaction_GeneralTab_TransactionNumber}
    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_GeneralTab_TransactionNumber}    VerificationData="Yes"

    ${PricingChange_EffectiveDate}    Replace Variables    ${sPricingChange_EffectiveDate}
    ${LIQ_PricingChangeTransaction_GeneralTab_EffectiveDate}    Replace Variables    ${LIQ_PricingChangeTransaction_GeneralTab_EffectiveDate}
    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_GeneralTab_EffectiveDate}    VerificationData="Yes"

    ${PricingChange_Desc}    Replace Variables    ${sPricingChange_Desc}
    ${LIQ_PricingChangeTransaction_GeneralTab_PricingChangeDescription}    Replace Variables    ${LIQ_PricingChangeTransaction_GeneralTab_PricingChangeDescription}
    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_GeneralTab_PricingChangeDescription}    VerificationData="Yes"
  
Modify Ongoing Fees
    [Documentation]    This keyword is used to update and verify the values of the Ongoing Fees in the Pricing Change Transaction notebook.
    ...    @author: rtarayao
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added keyword pre and take screenshot
    ...                                      - fixed hardcoded locators
    ...                                      - removed unused keywords
    ...                                      - modified keyword as current process is not applicable anymore
    [Arguments]    ${sPricingChange_OngoingFeeStr}    ${sOngoingFeePercent}    ${sUnutilizedRate}

    ### Keyword Pre-processing ###
    ${PricingChange_OngoingFeeStr}    Acquire Argument Value    ${sPricingChange_OngoingFeeStr}
    ${OngoingFeePercent}    Acquire Argument Value    ${sOngoingFeePercent}
    ${UnutilizedRate}    Acquire Argument Value    ${sUnutilizedRate}

    Mx LoanIQ Select Window Tab    ${LIQ_PricingChangeTransaction_Tab}    Pricing   
    Mx LoanIQ Click    ${LIQ_PricingChangeTransaction_ModifyOngoingFees_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Verify If Information Message is Displayed
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_OngoingFeePricing_Window}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OngoingFeePricingWindow

    ## Validate Facility Ongoing Fee Exist
    Mx LoanIQ Activate Window    ${LIQ_PricingChangeTransaction_OngoingFeePricing_Window}
    ${PricingChange_OngoingFeeStr}    Replace Variables    ${PricingChange_OngoingFeeStr}
    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_FacilityOngoingFee_Item}    Replace Variables    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_FacilityOngoingFee_Item}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_FacilityOngoingFee_Item}    VerificationData="Yes"
    
    ## Modify Ongoing Fees
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_Item_Javatree}    Unutilized${SPACE} X Rate%d
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FormulaCatergory_Window}        VerificationData="Yes"
    Mx LoanIQ Enter    ${LIQ_Pricing_OngoingFees_FormulaCategory_Percent_Radiobutton}    ON
    Mx LoanIQ Enter    ${LIQ_Pricing_OngoingFees_FormulaCategory_Percent_Textfield}    ${OngoingFeePercent}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FormulaCategoryWindow
    mx LoanIQ Click    ${LIQ_Pricing_OngoingFees_FormulaCategory_OK_Button}

    ## Validate Updated Ongoing Fee Rate
    ${UnutilizedRate}    Replace Variables    ${UnutilizedRate}
    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_UnutilizedXRateValue_Item}    Replace Variables    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_UnutilizedXRateValue_Item}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_UnutilizedXRateValue_Item}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OngoingFeePricingWindow
    Mx LoanIQ click    ${LIQ_PricingChangeTransaction_OngoingFees_OK_Button}

Navigate Existing Ongoing Fees
    [Documentation]    This keyword is used to navigate to Modify Ongoing Fees window in the Pricing Change Transaction notebook.
    ...    @author: makcamps    01FEB2021    - initial create
    
    Mx LoanIQ Select Window Tab    ${LIQ_PricingChangeTransaction_Tab}    Pricing   
    Mx LoanIQ Click    ${LIQ_PricingChangeTransaction_ModifyOngoingFees_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Verify If Information Message is Displayed
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_OngoingFeePricing_Window}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OngoingFeePricingWindow

Modify Existing Ongoing Fees
    [Documentation]    This keyword is used to update and verify existing values of Ongoing Fees in the Pricing Change Transaction notebook.
    ...    @author: makcamps    01FEB2021    - initial create
    [Arguments]    ${sPricingChange_OngoingFeeStr}    ${sCurrentGlobalRate}    ${sOngoingFeePercent}    ${sGlobalRate}

    ### Keyword Pre-processing ###
    ${PricingChange_OngoingFeeStr}    Acquire Argument Value    ${sPricingChange_OngoingFeeStr}
    ${CurrentGlobalRate}    Acquire Argument Value    ${sCurrentGlobalRate}
    ${OngoingFeePercent}    Acquire Argument Value    ${sOngoingFeePercent}
    ${GlobalRate}    Acquire Argument Value    ${sGlobalRate}
    
    ## Validate Facility Ongoing Fee Exist
    Mx LoanIQ Activate Window    ${LIQ_PricingChangeTransaction_OngoingFeePricing_Window}
    ${PricingChange_OngoingFeeStr}    Replace Variables    ${PricingChange_OngoingFeeStr}
    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_FacilityOngoingFee_Item}    Replace Variables    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_FacilityOngoingFee_Item}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_FacilityOngoingFee_Item}    VerificationData="Yes"
    
    ## Modify Ongoing Fees
    Mx LoanIQ Select String    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_Item_Javatree}    Global Current${SPACE} X Rate (${CurrentGlobalRate})
    Mx Press Combination    Key.ENTER
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FormulaCatergory_Window}        VerificationData="Yes"
    Mx LoanIQ Enter    ${LIQ_Pricing_OngoingFees_FormulaCategory_Percent_Radiobutton}    ON
    Mx LoanIQ Enter    ${LIQ_Pricing_OngoingFees_FormulaCategory_Percent_Textfield}    ${OngoingFeePercent}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FormulaCategoryWindow
    mx LoanIQ Click    ${LIQ_Pricing_OngoingFees_FormulaCategory_OK_Button}

    ## Validate Updated Ongoing Fee Rate
    ${GlobalRate}    Replace Variables    ${GlobalRate}
    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_GlobalCurrentXRateValue_Item}    Replace Variables    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_GlobalCurrentXRateValue_Item}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_OngoingFeePricingWindow_GlobalCurrentXRateValue_Item}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/OngoingFeePricingWindow

Save Ongoing Fees in Pricing Change Transaction Window for Global Current
    [Documentation]    This keyword verifies the Ongoing Fees values in the Price Change Transaction notebook, and save the values in excel.
    ...    @author: makcamps    01FEB2021    - initial create
    [Arguments]    ${sRuntime_Variable}=None
    
    mx LoanIQ click element if present    ${LIQ_PricingChangeTransaction_OngoingFees_OK_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Pricing_OngoingFees_Pricing_Tab}    VerificationData="Yes"
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PricingChangeTransaction_PricingTab_OngoingFee}    Global Current%s
    ${PricingChangeTransaction_OngoingFeeRateString}    Mx LoanIQ Get Data    ${LIQ_PricingChangeTransaction_PricingTab_OngoingFee}    Value
    ${PricingChangeTransaction_OngoingFeeRatePercentage}    Run Keyword And Continue On Failure    Get Substring    ${PricingChangeTransaction_OngoingFeeRateString}    28    -2
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AwaitingSendToApprovalPricingChangeTransactionWindow_PricingTab

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${PricingChangeTransaction_OngoingFeeRatePercentage}

    [Return]    ${PricingChangeTransaction_OngoingFeeRatePercentage}

Save Ongoing Fees in Pricing Change Transaction Window  
    [Documentation]    This keyword verifies the Ongoing Fees values in the Price Change Transaction notebook, and save the values in excel.
    ...    @author: rtarayao
    ...    @update: fmamaril    10MAR2019    Remove Write Data To Excel on Low Level Keyword
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added keyword pre and post processing
    ...                                      - fixed hardcoded locator
    ...                                      - modified keyword as current process is not applicable anymore
    [Arguments]    ${sRuntime_Variable}=None
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Pricing_OngoingFees_Pricing_Tab}    VerificationData="Yes"
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PricingChangeTransaction_PricingTab_OngoingFee}    Unutilized%s
    ${PricingChangeTransaction_OngoingFeeRateString}    Mx LoanIQ Get Data    ${LIQ_PricingChangeTransaction_PricingTab_OngoingFee}    Value
    ${PricingChangeTransaction_OngoingFeeRatePercentage}    Run Keyword And Continue On Failure    Get Substring    ${PricingChangeTransaction_OngoingFeeRateString}    28    -2
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AwaitingSendToApprovalPricingChangeTransactionWindow_PricingTab

    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${PricingChangeTransaction_OngoingFeeRatePercentage}

    [Return]    ${PricingChangeTransaction_OngoingFeeRatePercentage}

Select Pricing Change Transaction Send to Approval
    [Documentation]    This keyword sends the pricing change transaction for approval.
    ...    @author: rtarayao 
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards

    Mx LoanIQ Select Window Tab    ${LIQ_PricingChangeTransaction_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PricingChangeTransactionWindow_WorkflowTab
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree   ${LIQ_PricingChangeTransaction_WorkflowAction}    Send to Approval%yes           
    Mx LoanIQ DoubleClick    ${LIQ_PricingChangeTransaction_WorkflowAction}    Send to Approval
    
    :FOR    ${i}    IN RANGE    3
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}             
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False

Approve Price Change Transaction
    [Documentation]    This keyword is used to approve the pricing change transaction.
    ...    @author: rtarayao
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added take screenshot
    ...                                      - modified keyword as current process is not applicable anymore
        
    Mx LoanIQ Select Window Tab    ${LIQ_PricingChangeTransaction_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PricingChangeTransactionWindow_WorkflowTab
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PricingChangeTransaction_WorkflowAction}    Approval%yes       
    Mx LoanIQ DoubleClick    ${LIQ_PricingChangeTransaction_WorkflowAction}    Approval    
    
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    3
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}             
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False
        
Select Pricing Change Transaction Release   
    [Documentation]    This keyword releases the pricing change transaction.
    ...    @author: rtarayao 
    ...    @update: fmamaril    23APR2019    Delete Activation of Window for Deal and Facility
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added take screenshot

    Mx LoanIQ Select Window Tab    ${LIQ_PricingChangeTransaction_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PricingChangeTransactionWindow_WorkflowTab
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PricingChangeTransaction_WorkflowAction}    Release%yes    
    Mx LoanIQ DoubleClick    ${LIQ_PricingChangeTransaction_WorkflowAction}    Release 
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_No_Button}   
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    3
    \    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}             
    \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False

Select Events Tab then Verify the Events
    [Documentation]    This keyword verifies the activities done in the pricing change transaction notebook.
    ...    @author: rtarayao
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added keyword pre-processing and added take screenshot
    ...                                      - fixed hard coded locators and removed unused arguments
    [Arguments]    ${sCreated_Event}    ${sOngoingFeePricingChanged_Event}
    
    ### Keyword Pre-processing ###
    ${Created_Event}    Acquire Argument Value    ${sCreated_Event}
    ${OngoingFeePricingChanged_Event}    Acquire Argument Value    ${sOngoingFeePricingChanged_Event}

    Mx LoanIQ Select Window Tab    ${LIQ_PricingChangeTransaction_Tab}    Events
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PricingChangeTransactionWindow_EventsTab
    ${Created_Event}    Replace Variables    ${Created_Event}
    ${LIQ_PricingChangeTransaction_Create_Event}    Replace Variables    ${LIQ_PricingChangeTransaction_Create_Event}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_Create_Event}    VerificationData="Yes"
    
    ${OngoingFeePricingChanged_Event}    Replace Variables    ${OngoingFeePricingChanged_Event}
    ${LIQ_PricingChangeTransaction_OngoingFeePricingChanged_Event}    Replace Variables    ${LIQ_PricingChangeTransaction_OngoingFeePricingChanged_Event}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_OngoingFeePricingChanged_Event}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PricingChangeTransaction_Event}    Sent to Approval%yes
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PricingChangeTransaction_Event}    Approved%yes
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_PricingChangeTransaction_Event}    Released%yes
    
Close the Pricing Change Transaction Window
    [Documentation]    This keyword is used to close the pricing change transaction notebook.
    ...    @author: rtarayao 
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added take screenshot

    Mx LoanIQ select    ${LIQ_PricingChangeTransaction_File_Exit} 
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_Window}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Should Not Be True    ${status}==True
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/PricingChangeTransactionWindow

Validate Updated Ongoing Fees in Facility Notebook                   
    [Documentation]    This keyword verifies and compares the Ongoing fees inputted values made in the Price Change Transaction notebook with the values displayed in the Facility notebook.
    ...    @author: rtarayao
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added take screenshot
    ...                                      - modified keyword to make it dynamic  and remove read data from excel and fixed hardcorded locators
    [Arguments]    ${sPricingChange_OngoingFeeRate_SavedStr}

    ### Keyword Pre-processing ###
    ${PricingChange_OngoingFeeRate_SavedStr}    Acquire Argument Value    ${sPricingChange_OngoingFeeRate_SavedStr}

    Mx LoanIQ Activate    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_Pricing_Tab}    VerificationData="Yes"
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricing_OngoingFeeRate}    Unutilized%s
    ${Facility_OngoingFeeRateString}    Mx LoanIQ Get Data    ${LIQ_FacilityPricing_OngoingFeeRate}    Value
    ${Facility_OngoingFeeRatePercentage}    Run Keyword And Continue On Failure    Get Substring    ${Facility_OngoingFeeRateString}    28    -2
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityWindow_PricingTab
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${Facility_OngoingFeeRatePercentage}    ${PricingChange_OngoingFeeRate_SavedStr}

Compare Previous and Current Ongoing Fee Values of the Facility Notebook
    [Documentation]    This keyword compares the Previous value versus the Current value of the Ongoing Fee in the Facility.
    ...    @author: rtarayao
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added take screenshot
    ...                                      - modified keyword to make it dynamic and remove read data from excel and fixed hardcorded locators
    [Arguments]    ${sOngoingFeeRate_SaveOriginal}

    ### Keyword Pre-processing ###
    ${OngoingFeeRate_SaveOriginal}    Acquire Argument Value    ${sOngoingFeeRate_SaveOriginal}

    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_Pricing_Tab}    VerificationData="Yes"
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricing_OngoingFeeRate}    Unutilized%s
    ${Facility_OngoingFeeRateString}    Mx LoanIQ Get Data    ${LIQ_FacilityPricing_OngoingFeeRate}    Value
    ${Facility_OngoingFeeRatePercentage}    Run Keyword And Continue On Failure    Get Substring    ${Facility_OngoingFeeRateString}    28    -2
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityWindow_PricingTab
  
    Should Not Be Equal As Strings    ${Facility_OngoingFeeRatePercentage}    ${OngoingFeeRate_SaveOriginal}
    
    Log    ${OngoingFeeRate_SaveOriginal}
    Log    ${Facility_OngoingFeeRatePercentage}
    
Update Interest Pricing via Pricing Change Transaction
    [Documentation]    This keyword adds interest pricing on facility.
    ...    @author: fmamaril    16MAR2019
    ...    @update: amansuet    26MAY2020    - updated to align with automation standards and added keyword pre-processing and take screenshot
    ...                                      - fixed hardcoded locators
    ...                                      - removed unused keywords
    ...                                      - modified keyword as current process is not applicable anymore
    [Arguments]    ${sOptionName}    ${sSpread}    ${sPercentOfRateFormulaUsage}=None

    ### Keyword Pre-processing ###
    ${OptionName}    Acquire Argument Value    ${sOptionName}
    ${Spread}    Acquire Argument Value    ${sSpread}
    ${PercentOfRateFormulaUsage}    Acquire Argument Value    ${sPercentOfRateFormulaUsage}

    Mx LoanIQ Activate Window     ${LIQ_PricingChangeTransaction_OngoingFeePricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PricingChangeTransaction_Tab}    Pricing   
    Mx LoanIQ Click    ${LIQ_PricingChangeTransaction_ModifyInterestPricing_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Information_OK_Button}

    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_InterestPricing_Window}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/InterestPricingWindow

    ## Validate Facility Interest Pricing Exist
    Mx LoanIQ Activate Window    ${LIQ_PricingChangeTransaction_InterestPricing_Window}
    ${OptionName}    Replace Variables    ${OptionName}
    ${LIQ_PricingChangeTransaction_InterestPricingWindow_InterestPricing_Item}    Replace Variables    ${LIQ_PricingChangeTransaction_InterestPricingWindow_InterestPricing_Item}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_InterestPricingWindow_InterestPricing_Item}    VerificationData="Yes"

    ## Modify Interest Pricing
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PricingChangeTransaction_InterestPricingWindow_Item_Javatree}    PCT%d
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FormulaCatergory_Window}    VerificationData="Yes"
    Mx LoanIQ Enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ON
    Mx LoanIQ Enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread}
    Run Keyword If    '${PercentOfRateFormulaUsage}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_FormulaCategory_PercentOfRateFormulaUsage_List}    ${PercentOfRateFormulaUsage}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FormulaCategoryWindow
    Mx LoanIQ Click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button}

    ## Validate Updated Interest Pricing Rate
    ${Spread}    Replace Variables    ${Spread}
    ${LIQ_PricingChangeTransaction_InterestPricingWindow_FixRateOptionValue_Item}    Replace Variables    ${LIQ_PricingChangeTransaction_InterestPricingWindow_FixRateOptionValue_Item}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_InterestPricingWindow_FixRateOptionValue_Item}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/InterestPricingWindow
    Mx LoanIQ click    ${LIQ_PricingChangeTransaction_InterestPricing_OK_Button}
    
Navigate to PCT Existing Interest Pricing
    [Documentation]    This keyword is used to navigate to Modify Interest Pricing window in the Pricing Change Transaction notebook
    ...    @author: makcamps    01FEB2021    - initial create
    Mx LoanIQ Activate Window     ${LIQ_PricingChangeTransaction_OngoingFeePricing_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PricingChangeTransaction_Tab}    Pricing   
    Mx LoanIQ Click    ${LIQ_PricingChangeTransaction_ModifyInterestPricing_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Information_OK_Button}

Update Existing Interest Pricing via PCT
    [Documentation]    This keyword adds interest pricing on facility.
    ...    @author: makcamps    01FEB2021    - initial create
    [Arguments]    ${sOptionName}    ${sComputation}    ${sPricingCode}    ${sPricingPercent}    ${sCurrentSpread}    ${sSpread}    ${sPercentOfRateFormulaUsage}=None

    ### Keyword Pre-processing ###
    ${OptionName}    Acquire Argument Value    ${sOptionName}
    ${Computation}    Acquire Argument Value    ${sComputation}
    ${PricingCode}    Acquire Argument Value    ${sPricingCode}
    ${PricingPercent}    Acquire Argument Value    ${sPricingPercent}
    ${CurrentSpread}    Acquire Argument Value    ${sCurrentSpread}
    ${Spread}    Acquire Argument Value    ${sSpread}
    ${PercentOfRateFormulaUsage}    Acquire Argument Value    ${sPercentOfRateFormulaUsage}    

    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_InterestPricing_Window}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/InterestPricingWindow

    ## Validate Facility Interest Pricing Exist
    Mx LoanIQ Activate Window    ${LIQ_PricingChangeTransaction_InterestPricing_Window}
    ${OptionName}    Replace Variables    ${OptionName}
    ${LIQ_PricingChangeTransaction_InterestPricingWindow_InterestPricing_Item}    Replace Variables    ${LIQ_PricingChangeTransaction_InterestPricingWindow_InterestPricing_Item}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_InterestPricingWindow_InterestPricing_Item}    VerificationData="Yes"

    ## Modify Interest Pricing
    Mx LoanIQ DoubleClick    ${LIQ_PricingChangeTransaction_InterestPricingWindow_Item_Javatree}    (${SPACE}${Computation}(${SPACE}${PricingCode}${SPACE},${SPACE}${PricingPercent}${SPACE}${SPACE})${SPACE}${SPACE}+${SPACE}Spread${SPACE}(${CurrentSpread})${SPACE})${SPACE}X${SPACE}PCT${SPACE}(1)
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_FormulaCatergory_Window}    VerificationData="Yes"
    Mx LoanIQ Enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Radiobutton}    ON
    Mx LoanIQ Enter    ${LIQ_Facility_InterestPricing_FormulaCategory_Percent_Textfield}    ${Spread}
    Run Keyword If    '${PercentOfRateFormulaUsage}' != 'None'    Mx LoanIQ Select Combo Box Value    ${LIQ_FormulaCategory_PercentOfRateFormulaUsage_List}    ${PercentOfRateFormulaUsage}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FormulaCategoryWindow
    Mx LoanIQ Click    ${LIQ_Facility_InterestPricing_FormulaCategory_OK_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_PleaseConfirm_Yes_Button}

    ## Validate Updated Interest Pricing Rate
    ${Spread}    Replace Variables    ${Spread}
    ${LIQ_PricingChangeTransaction_InterestPricingWindow_FixRateOptionValue_Item}    Replace Variables    ${LIQ_PricingChangeTransaction_InterestPricingWindow_FixRateOptionValue_Item}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_PricingChangeTransaction_InterestPricingWindow_FixRateOptionValue_Item}    VerificationData="Yes"
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/InterestPricingWindow

Select Financial Ratio in Interest Pricing List
    [Documentation]    This keyword is used to select Financial Ration in Interest Pricing List
    ...    @author: clanding    11AUG2020    - initial create
    [Arguments]    ${sPCT_FinancialRatioType}

    ### Keyword Pre-processing ###
    ${PCT_FinancialRatioType}    Acquire Argument Value    ${sPCT_FinancialRatioType}
    
    mx LoanIQ activate    ${LIQ_Facility_InterestPricing_Window}
	Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_PCT_InterestPricing_List}    ${PCT_FinancialRatioType}%s
	Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/InterestPricingWindow