*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 
Launch Loan Notebook
    [Documentation]    This keyword is for navigating Loan Notebook via Outstanding icon.
    ...    @author:mgaling
    ...    @update: rtarayao    19MAR2019    Deleted Read Data keyword.
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...    @update: dahijara    03JUL2020    - Added keyword for screenshot
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}    ${sLoan_Alias}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}

    Select Actions    [Actions];Outstanding
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Existing_RadioButton}    ON
    mx LoanIQ select list    ${LIQ_OutstandingSelect_Type_Dropdown}    Loan
    mx LoanIQ select list    ${LIQ_OutstandingSelect_SearchBy_Dropdown}    Deal/Facility 
    mx LoanIQ click    ${LIQ_OutstandingSelect_Deal_JavaButton}
    
    ###Selecting Deal###
    mx LoanIQ activate window    ${LIQ_DealSelect_Window}   
    mx LoanIQ enter    ${LIQ_DealSelect_DealIdentifyBy_Textfield}    ${Deal_Name}
    mx LoanIQ click    ${LIQ_DealSelect_Search_Button} 
    mx LoanIQ click    ${LIQ_DealListByName_OK_Button}
    Sleep    3s
    
    mx LoanIQ activate window   ${LIQ_OutstandingSelect_Window}
    mx LoanIQ select list    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect  
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    
    ###Select existing Loan###
    mx LoanIQ activate window    ${LIQ_ExistingLoans_Window} 
    Mx LoanIQ Set    ${LIQ_ExistingLoans_UpdateMode}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect_ExistingLoans
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_ExistingLoans_JavaTree}    ${Loan_Alias}%d
    Sleep    3s
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    mx LoanIQ close window    ${LIQ_ExistingLoans_Window} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_Notebook                
    
Launch Manual Share Adjustment Notebook
    [Documentation]    This keyword is for navigating Manual Share Adjustment Notebook.
    ...    @author: mgaling
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    [Arguments]    ${sLoan_PricingOption}     
    
    ### GetRuntime Keyword Pre-processing ###
	${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
    
    mx LoanIQ activate window    JavaWindow("title:=${Loan_PricingOption} Loan.*")    
    mx LoanIQ select    JavaWindow("title:=${Loan_PricingOption} Loan.*").${LIQ_Options_ShareAdjustment}   
    
    mx LoanIQ activate window    ${LIQ_ChooseAdjustment_Window}
    Mx LoanIQ Set    ${LIQ_ChooseAdjustment_LenderShares_RadioButton}    ON 
    mx LoanIQ click    ${LIQ_ChooseAdjustment_OK_Button}   
    mx LoanIQ activate window    ${LIQ_ManualShareAdjustment_Window} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_Notebook
    
Populate General Tab in Manual Share Adjustment 
    [Documentation]    This keyword is for populating data in General Tab.
    ...    @author: mgaling
    ...    @update: jdelacru    22APR19    Added handling of warning message box 
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps   
    ...    @update: dahijara    19AUG2020    Removed Read and write from excel. Updated Arguments. Updated Mx Native Type with Mx Press Combination
    [Arguments]    ${sManualSharedAdj_Reason}    ${sManualSharedAdj_EffectiveDate}
    
    ### GetRuntime Keyword Pre-processing ###
	${ManualSharedAdj_Reason}    Acquire Argument Value    ${sManualSharedAdj_Reason}
    ${ManualSharedAdj_EffectiveDate}    Acquire Argument Value    ${sManualSharedAdj_EffectiveDate}
     
    Mx LoanIQ Select Window Tab    ${LIQ_ManualShareAdjustment_Tab}    General
    mx LoanIQ enter    ${LIQ_ManualShareAdjustment_EffectiveDate}    ${ManualSharedAdj_EffectiveDate}
    mx LoanIQ enter    ${LIQ_ManualShareAdjustment_ManualSharedAdj_Reason}    ${ManualSharedAdj_Reason}
    Mx Press Combination    Key.BACKSPACE
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_General_Tab
    mx LoanIQ select    ${LIQ_ManualShareAdjustment_FileSave}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 

Update Host Bank Lender Share
    [Documentation]    This keyword is for updating the Host Bank share.
    ...    @author:mgaling
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    ...    @update: dahijara    19AUG2020    Removed read and write from excel
    ...                                      Updated arguments, removed rowId and added RunVar
    ...                                      Removed sleep, added return value for Balance
    ...                                      Added Post Processing keyword.
    ...                                      Updated Send key with Mx Loan IQ Enter for adjustments.
    ...    @update: dahijara    20AUG2020    Updated logic for updating adjustments with negative value.
    [Arguments]    ${sLender_HostBank}    ${sAdjustment}    ${sRunVar_Balance}=None
    
    ### GetRuntime Keyword Pre-processing ###
	${Lender_HostBank}    Acquire Argument Value    ${sLender_HostBank}
	${Adjustment}    Acquire Argument Value    ${sAdjustment}
   
    mx LoanIQ activate window    ${LIQ_ManualShareAdjustment_Window}
    mx LoanIQ select    ${LIQ_ManualShareAdjustment_Options_ViewUpdateLenderShare}
    mx LoanIQ activate window    ${LIQ_LenderShares_Window} 
    
    ###Selecting Host Bank for Share Adjustment - Primaries/Assigness Section###
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender_HostBank}%d
    
    ###Getting the original New Balance value Servicing Group Share Window###    
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_ServicingGroupShare_Window}
    ${Balance}    Mx LoanIQ Get Data    ${LIQ_ServicingGroupShare_NewBalance}    value
    ${Balance}    Remove Comma and Convert to Number    ${Balance}
    
    ###Input Adjustment Value###
    Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroupShare_Adjustment}        VerificationData="Yes"
    ${Negative_Adjustment}    Strip String    ${Adjustment}    characters=0123456789,.
    Run Keyword If    '${Negative_Adjustment}'=='-'    Run Keywords    Mx LoanIQ Click    ${LIQ_ServicingGroupShare_Adjustment}
    ...    AND    Mx LoanIQ Send Keys    {RIGHT 1}
    ...    AND    Mx LoanIQ send keys    ${Adjustment}
    ...    AND    Mx LoanIQ send keys   -
    ...    ELSE    Mx LoanIQ enter    ${LIQ_ServicingGroupShare_Adjustment}   ${Adjustment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_HostBank_LenderShare
    mx LoanIQ click element if present    ${LIQ_ServicingGroupShare_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_HostBank_LenderShare
	
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Balance}    ${Balance}
    [Return]    ${Balance}
    
Verify the New Balance in Servicing Group Share Window
    [Documentation]    This keyword verifies the New Balance Value in Servicing Group Share Window.
    ...    @author:mgaling 
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    ...    @update: dahijara    19AUG2020    Removed reading and writing from excel, removed sleep.
    [Arguments]    ${sLender_HostBank}    ${sAdjustment}    ${sBalance}    ${sRunVar_NewBalance}=None
    
    ### GetRuntime Keyword Pre-processing ###
	${Balance}    Acquire Argument Value    ${sBalance}
	${Lender_HostBank}    Acquire Argument Value    ${sLender_HostBank}
	${Adjustment}    Acquire Argument Value    ${sAdjustment}
    
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender_HostBank}%d

    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_ServicingGroupShare_Window}
    mx LoanIQ enter    ${LIQ_ServicingGroupShare_Adjustment_Textfield}    ${Adjustment}
    ${NewBalance}    Mx LoanIQ Get Data    ${LIQ_ServicingGroupShare_NewBalance}    value
    ${NewBalance}    Remove Comma and Convert to Number    ${NewBalance}
    
    ${Calculated_Balance}    Evaluate    (${Balance})+(${Adjustment})
    ${Calculated_Balance}    Convert To Number    ${Calculated_Balance}    2
    ${NewBalance}    Convert to Number    ${NewBalance}    2
    Should Be Equal    ${NewBalance}    ${Calculated_Balance}        
    mx LoanIQ click    ${LIQ_ServicingGroupShare_OK_Button}
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_NewBalance}    ${NewBalance}
    [Return]    ${NewBalance}
    
Update Host Bank Share Value - Host bank shares section
    [Documentation]    This keyword is for updating Host Bank Share Value under Host bank shares section.
    ...    @author: mgaling
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    ...    @update: dahijara    19AUG2020    Removed Sleep, removed unused argument.
    ...                                      Replaced Mx Native Type with Mx Press Combination
    ...                                      Added screenshot
    ...    @update: dahijara    20AUG2020    Updated logic for updating adjustments with negative value.
    [Arguments]    ${sLender_HostBank}    ${sHostBank}    ${sAdjustment}
    
    ### GetRuntime Keyword Pre-processing ###
	${Lender_HostBank}    Acquire Argument Value    ${sLender_HostBank}
	${HostBank}    Acquire Argument Value    ${sHostBank}
	${Adjustment}    Acquire Argument Value    ${sAdjustment}
            
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LenderShares_HostBankShares_List}    ${Lender_HostBank}%d
    
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_LenderShares_HostBankShare_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_HostBankShare_ExpenseCodeList}    ${HostBank}%d                
    
    mx LoanIQ activate window    ${LIQ_PortfolioShareEdit_Window}
    
    Mx LoanIQ Click Javatree Cell    ${LIQ_PortfolioShareEdit_Funding}   0.00%0.00%+/- Adjustment
    ${Negative_Adjustment}    Strip String    ${Adjustment}    characters=0123456789,.
    Run Keyword If    '${Negative_Adjustment}'=='-'    Run Keywords    Mx LoanIQ send keys    ${Adjustment}
    ...    AND    Mx LoanIQ send keys   -
    ...    ELSE    Mx LoanIQ send keys    ${Adjustment}
    mx LoanIQ send keys    ${Adjustment}
    Mx Press Combination    Key.TAB
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_HostBank_ShareValue
    mx LoanIQ click    ${LIQ_PortfolioShareEdit_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_HostBank_ShareValue
   
Verify the New Balance for Host Bank Share Value - Host bank shares section
    [Documentation]    This keyword verifies the New Balance for Host Bank Share Value - Host bank shares section.
    ...    @author: mgaling
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    ...    @update: dahijara    19AUG2020    Updated arguments and removed reading from excel
    ...    @update: dahijara    20 AUG2020   added conversion for data to number to match data type. Added screenshot.
    [Arguments]    ${sNewBalance}    ${sHostBank}    ${sAdjustment}
    
    ### GetRuntime Keyword Pre-processing ###
	${NewBalance}    Acquire Argument Value    ${sNewBalance}
	${HostBank}    Acquire Argument Value    ${sHostBank}
	${Adjustment}    Acquire Argument Value    ${sAdjustment}
	           
    mx LoanIQ activate window    ${LIQ_LenderShares_HostBankShare_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_HostBankShare_ExpenseCodeList}    ${HostBank}%d
    mx LoanIQ activate window    ${LIQ_PortfolioShareEdit_Window}
    
    ${Legal_Amount}     Mx LoanIQ Get Data    ${LIQ_PortfolioShareEdit_Legal_Field}    value      
    ${Book_Amount}    Mx LoanIQ Get Data    ${LIQ_PortfolioShareEdit_Book_Field}    value 
    Should Be Equal    ${Legal_Amount}    ${Book_Amount}
   
    ${Legal_Amount}    Convert To Number    ${Legal_Amount}    2
    ${Adjustment}    Convert To Number    ${Adjustment}    2    
    Should Be Equal    ${Legal_Amount}    ${Adjustment}
   
    ${PSE_NewBalance}    Mx LoanIQ Get Data    ${LIQ_PortfolioShareEdit_NewBalance_Field}    value
    ${PSE_NewBalance}    Remove Comma and Convert to Number    ${PSE_NewBalance}
    ${NewBalance}    Remove Comma and Convert to Number    ${NewBalance}
    Should Be Equal    ${NewBalance}    ${PSE_NewBalance}                                              
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_HostBank_PortfolioShareEdit
    mx LoanIQ click    ${LIQ_PortfolioShareEdit_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_HostBank_PortfolioShareEdit
    mx LoanIQ activate window    ${LIQ_LenderShares_HostBankShare_Window}                
    mx LoanIQ click element if present    ${LIQ_HostBankShare_OK_Button}
    mx LoanIQ click element if present    ${LIQ_HostBankShare_OK_Button} 
   
Update NonHost Bank Lender Share
    [Documentation]    This keyword is for updating the Non-Host Bank Lender share.
    ...    @author: mgaling
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    ...    @update: dahijara    19AUG2020    Removed reading and writing from excel
    ...                                      Added post processing. removed sleep.
    [Arguments]    ${sLender_NonHostBank}    ${sNHB_Adjustment}    ${sRunVar_NHB_Balance}=None
    
    ### GetRuntime Keyword Pre-processing ###
	${Lender_NonHostBank}    Acquire Argument Value    ${sLender_NonHostBank}
	${NHB_Adjustment}    Acquire Argument Value    ${sNHB_Adjustment}
        
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender_NonHostBank}%d
    
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_ServicingGroupShare_Window}
    mx LoanIQ enter    ${LIQ_ServicingGroupShare_Adjustment_Textfield}    ${NHB_Adjustment}
    ${NHB_Balance}    Mx LoanIQ Get Data    ${LIQ_ServicingGroupShare_NewBalance}    value
    ${NHB_Balance}    Remove Comma and Convert to Number    ${NHB_Balance}
    
	Mx LoanIQ Verify Object Exist    ${LIQ_ServicingGroupShare_Adjustment}        VerificationData="Yes"
    mx LoanIQ click    ${LIQ_ServicingGroupShare_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_NonHostBankShare_Adjustments
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_NHB_Balance}    ${NHB_Balance}
	[Return]    ${NHB_Balance}
Verify the New Balance for NonHost Bank Share
    [Documentation]    This keyword verifies the New Balance for Lender Shares (NonHost Bank).
    ...    @author: mgaling
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    ...    @update: dahijara    19AUG2020    Removed reading and writing from excel
    ...                                      Added post processing. removed sleep.
    ...                                      Updated keyword arguments
    ...                                      Added return value
    [Arguments]    ${sLender_NonHostBank}    ${sNHB_Adjustment}    ${sNHB_Balance}    ${sRunVar_NHB_NewBalance}=None
    
    ### GetRuntime Keyword Pre-processing ###
	${Lender_NonHostBank}    Acquire Argument Value    ${sLender_NonHostBank}
    ${NHB_Adjustment}    Acquire Argument Value    ${sNHB_Adjustment}
    ${NHB_Balance}    Acquire Argument Value    ${sNHB_Balance}

    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_LenderShares_PrimariesAssignees_List}    ${Lender_NonHostBank}%d
    
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_ServicingGroupShare_Window}
    ${NHB_NewBalance}    Mx LoanIQ Get Data    ${LIQ_ServicingGroupShare_NewBalance}    value
    ${NHB_NewBalance}    Remove Comma and Convert to Number    ${NHB_NewBalance}    2
    
    ${Calculated_NHBBalance}    Evaluate    (${NHB_Balance})+(${NHB_Adjustment})
    ${Calculated_NHBBalance}    Remove Comma and Convert to Number    ${Calculated_NHBBalance}    2
    
    Should Be Equal    ${NHB_NewBalance}    ${Calculated_NHBBalance}        
    mx LoanIQ click    ${LIQ_ServicingGroupShare_OK_Button}
    
    ###Validate Actual Total of the Primaries###
    mx LoanIQ activate window    ${LIQ_LenderShares_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_LenderShares_PrimariesAssignees_ActualTotal}    value%0.00 
    mx LoanIQ click    ${LIQ_LenderShares_OK_Button}               
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_NHB_NewBalance}    ${NHB_NewBalance}
    [Return]    ${NHB_NewBalance}
    
Navigate to Adjustment Create Cashflows
    [Documentation]    This keyword is for creating cashflows in Manual Share Adjustment Notebook.
    ...    @author:mgaling
    [Arguments]    ${Lender_NonHostBank}    ${Remittance_Description}
    
    mx LoanIQ activate window    ${LIQ_ManualShareAdjustment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualShareAdjustment_Tab}    Workflow
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualShareAdjustment_WorkflowItem}    Create Cashflows%d
     
Adjustment Send to Approval
    [Documentation]    This keyword is for sending adjustment to approval.
    ...    @author:mgaling
    ...    @update: jdelacru    28MAR19    Used of standard cashflow locators
    ...    @update: dahijara    20AUG2020    Added screenshot.
    mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}    
    mx LoanIQ activate window    ${LIQ_ManualShareAdjustment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualShareAdjustment_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_SentToApproval
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualShareAdjustment_WorkflowItem}    Send to Approval%d
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_SentToApproval
                    
Adjustment Approval
    [Documentation]    This keyword is for approving Adjustment.
    ...    @author:mgaling
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    ...    @update: dahijara    20AUG2020    Added screenshot. removed hardcoded sleep
    [Arguments]    ${sWIPTransaction_Type}    ${sOustandingsTransaction_Type}    ${sDeal_Name}    
    
    ### GetRuntime Keyword Pre-processing ###
	${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}
	${OustandingsTransaction_Type}    Acquire Argument Value    ${sOustandingsTransaction_Type}
	${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Approval    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Approval         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Approval   
    Run Keyword If    ${status}==False    Log    'Awaiting Approval' status is not available    

    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    ${OustandingsTransaction_Type}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    ${OustandingsTransaction_Type}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${OustandingsTransaction_Type}  
    Run Keyword If    ${status}==False    Log    Manual Loan Share Adjustment is not available          
    
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}   
    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Deal_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_Approval
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER
        
    mx LoanIQ activate window    ${LIQ_ManualShareAdjustment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualShareAdjustment_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_Approval
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualShareAdjustment_WorkflowItem}    Approval%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_Approval

Adjustment Release
    [Documentation]    This keyword is for releasing Adjustment.
    ...    @author:mgaling
    ...    @update: sahalder    01JUL2020    Added keyword pre-processing steps
    ...    @update: dahijara    20AUG2020    Added screenshot. removed hardcoded sleep
    [Arguments]    ${sWIPTransaction_Type}    ${sOustandingsTransaction_Type}    ${sDeal_Name}    
    
    ### GetRuntime Keyword Pre-processing ###
	${WIPTransaction_Type}    Acquire Argument Value    ${sWIPTransaction_Type}
	${OustandingsTransaction_Type}    Acquire Argument Value    ${sOustandingsTransaction_Type}
	${Deal_Name}    Acquire Argument Value    ${sDeal_Name}  
    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    mx LoanIQ activate window    ${LIQ_WorkInProgress_Window}   
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionList}    ${WIPTransaction_Type}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Release    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Release         
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Release   
    Run Keyword If    ${status}==False    Log    'Awaiting Release' status is not available    

    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    ${OustandingsTransaction_Type}    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    ${OustandingsTransaction_Type}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${OustandingsTransaction_Type}  
    Run Keyword If    ${status}==False    Log    Manual Loan Share Adjustment is not available          
    
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}   
    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ Select String    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Deal_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_Release
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER
                
    mx LoanIQ activate window    ${LIQ_ManualShareAdjustment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualShareAdjustment_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_Release
    Run Keyword And Continue On Failure    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualShareAdjustment_WorkflowItem}    Release%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_Release
    mx LoanIQ close window    ${LIQ_ManualShareAdjustment_Window}
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window}        
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Manual_Share_Adjustment_Release

Navigate to Manual Share Adjustment Notebook Workflow
    [Documentation]    This keyword navigates the Workflow tab of Manual Share Adjustment Notebook, and does a specific transaction.
    ...    
    ...    | Arguments |
    ...    
    ...    'Transaction' = The type of transaction listed under Workflow. Ex. Send to Approval, Approve, Release
    ...    
    ...    @author: sahalder    01JUL2020    initial create
    [Arguments]    ${sTransaction}    

    ###Pre-processing Keyword##
    ${Transaction}    Acquire Argument Value    ${sTransaction} 

    mx LoanIQ activate window    ${LIQ_ManualShareAdjustment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ManualShareAdjustment_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ManualShareAdjustment_WorkflowItem}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

