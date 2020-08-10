*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Add Availability Change
    [Documentation]    This keyword adds availability Change Transaction to the Facility
    ...    @author: sahalder    13JUL2020    initial create
    
    Mx LoanIQ Activate    ${LIQ_FacilityNotebook_Window}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityNotebook_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    '${Status}'=='True'  mx LoanIQ select    ${LIQ_FacilityNotebook_Options_Update}
    Mx LoanIQ Select    ${LIQ_FacilityNotebook_Options_AvailabilityChange}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Activate    ${LIQ_AvailabilityChange_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityChangeTransactionWindow_GeneralTab

Add Availability Change and Fetch Current Facility Commitment Amount
    [Documentation]    This keyword adds availability Change Transaction to the Facility and fetches the current facility amount from the summary tab
    ...    @author: sahalder    17JUL2020    initial create
    Add Availability Change
    ${Fac_CurrentCmt}    Mx LoanIQ Get Data    ${LIQ_AvailabilityChange_Current_Amountfield}    input=Facility_CurrentCmt
    [Return]    ${Fac_CurrentCmt}
    
    
Add Changes in Availability Change General Tab
    [Documentation]    This keyword adds the changes to the Facility in the availability change general tab
    ...    @author: sahalder    13JUL2020    initial create
    [Arguments]    ${sChange_Amount}    ${sComment}    ${sCurrent_Commitment}    ${sAdjustment}
    
    ### GetRuntime Keyword Pre-processing ###
	${Change_Amount}    Acquire Argument Value    ${sChange_Amount}
	${Comment}    Acquire Argument Value    ${sComment}
	${Current_Commitment}    Acquire Argument Value    ${sCurrent_Commitment}
	${Adjustment}    Acquire Argument Value    ${sAdjustment}
    
    ${Current_Date}    Get System Date
    Mx LoanIQ Activate    ${LIQ_AvailabilityChange_Window}
    ${Current_Commitment}    Remove Comma and Convert to Number    ${Current_Commitment}    2
    ${Calc_New_Commitment}    Evaluate    ${Current_Commitment}+${Change_Amount}
    ${Calc_New_Commitment}    Remove Comma and Convert to Number    ${Calc_New_Commitment}    2
    Log To Console    ${Calc_New_Commitment}    
    ${New_Change_Amount}    Remove Comma, Negative Character and Convert to Number    ${Change_Amount}
    Mx LoanIQ Click    ${LIQ_AvailabilityChange_Change_Amountfield}
    
    Run Keyword If    '${Adjustment}'=='-'    Run Keywords
    ...    Mx Press Combination    Key.CTRL    Key.A
    ...    AND    Mx LoanIQ Send Keys    ${New_Change_Amount}    
    ...    AND    Mx LoanIQ Send Keys    ${Adjustment}
         
    Run Keyword If    '${Adjustment}'!='-'    Mx LoanIQ Send Keys    ${New_Change_Amount}   
    
    Mx LoanIQ Enter    ${LIQ_AvailabilityChange_Effective_Datefield}    ${Current_Date}
    Mx LoanIQ Click    ${LIQ_AvailabilityChange_Comment_field}    
    Mx LoanIQ Enter    ${LIQ_AvailabilityChange_Comment_field}    ${Comment}   
    ${New_Commitment}    Mx LoanIQ Get Data    ${LIQ_AvailabilityChange_New_Amountfield}    New_Commitment
    ${New_Commitment_Amt}    Remove Comma and Convert to Number    ${New_Commitment}    2
    Should Be Equal    ${New_Commitment_Amt}    ${Calc_New_Commitment}
    
    Mx LoanIQ Select    ${LIQ_AvailabilityChange_File_Save}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Loan_AvailChange_General
    [Return]    ${New_Commitment}
 
Send to Approval Availability Change
    [Documentation]    This keyword sends the Availability Change for approval
    ...    @author: sahalder    13JUL2020    initial create
    
    Mx LoanIQ Activate    ${LIQ_AvailabilityChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AvailabilityChange_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AvailabilityChangeWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AvailabilityChange_Workflow_Tab}    Send to Approval%d
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present     ${LIQ_Warning_Yes_Button}
    :FOR    ${i}    IN RANGE    3
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False

Approve Availability Change
    [Documentation]    This keyword approves the availability Change in work in process
    ...    @author: sahalder    13JUL2020    initial create
    [Arguments]    ${sDeal_Name}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    Mx LoanIQ Activate Window   ${LIQ_Window}
    Select Actions    [Actions];Work In Process
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    Facilities    
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Approval
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Commitment Availability Change
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Deal_Name}
    Mx LoanIQ Activate Window    ${LIQ_AvailabilityChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AvailabilityChange_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AvailabilityChangeWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AvailabilityChange_Workflow_Tab}    Approval%d
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    :FOR    ${i}    IN RANGE    3
     \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     \    ${Warning_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}     VerificationData="Yes"
     \    Exit For Loop If    ${Warning_Status}==False
     
Release Availability Change
    [Documentation]    This keyword releases the approved availability Change in work in process
    ...    @author: sahalder    13JUL2020    initial create
    [Arguments]    ${sDeal_Name}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    
    Mx LoanIQ Activate Window   ${LIQ_Window}
    Select Actions    [Actions];Work In Process
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Transactions_List}    Facilities    
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    Commitment Availability Change
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_Outstanding_List}    ${Deal_Name}
    Mx LoanIQ Activate    ${LIQ_AvailabilityChange_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_AvailabilityChange_Tab}    Workflow
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/AvailabilityChangeWindow_WorkflowTab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AvailabilityChange_Workflow_Tab}    Release%d
    Mx LoanIQ Click Element If Present    ${LIQ_Question_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present     ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Click Element If Present    ${LIQ_Warning_Yes_Button}
    Mx LoanIQ Verify Object Exist    ${LIQ_AvailabilityChange_WorkflowNoItems_Tab}    VerificationData="Yes"
    Mx LoanIQ Select    ${LIQ_AvailabilityChange_File_Exit}
    Mx LoanIQ Click Element If Present     ${LIQ_Reminder_OK_Button}
    Mx LoanIQ Activate Window    ${LIQ_TransactionInProcess_Window}
    Mx LoanIQ Select    ${LIQ_TransactionsInProcess_FileExit_Menu}     
    
Validate Availability Change
    [Documentation]    This keyword validates that the changes in Availability is correctly reflected in the Facility Summary.
    ...    @author: sahalder    13JUL2020    initial create 
    [Arguments]    ${sDeal_Name}    ${sFacility_Name}    ${sCmt_Amt}

    ### Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Cmt_Amt}    Acquire Argument Value    ${sCmt_Amt}

    Select Actions    [Actions];Facility
    Mx LoanIQ Enter    ${LIQ_FacilitySelect_DealName_Textfield}    ${Deal_Name}
    Mx LoanIQ Select List    ${LIQ_FacilitySelect_IdentifyBy_List}    Name
    Mx LoanIQ Enter    ${LIQ_FacilitySelect_FacilityName_Textfield}    ${Facility_Name}
    Mx LoanIQ Click    ${LIQ_FacilitySelect_OK_Button}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityWindow_SummaryTab
    ${Outstanding_Amt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_Outstandings_Textfield}    input=Outstanding_Amt
    ${Outstanding_Amt}    Remove Comma and Convert to Number    ${Outstanding_Amt}    2
    ${Facility_Cmt}    Mx LoanIQ Get Data    ${LIQ_FacilitySummary_AvailToDraw_Textfield}    input=Facility_Cmt
    ${Facility_Cmt}    Remove Comma and Convert to Number    ${Facility_Cmt}    2
    ${Cmt_Amt}    Remove Comma and Convert to Number    ${Cmt_Amt}    2
    ${Calc_AvailToDraw}    Evaluate    ${Cmt_Amt}-${Outstanding_Amt}
    ${Calc_AvailToDraw}    Remove Comma and Convert to Number    ${Calc_AvailToDraw}    2    
    Should Be Equal    ${Facility_Cmt}    ${Calc_AvailToDraw}
    Mx LoanIQ Select    ${LIQ_FacilityNotebook_File_Exit}  