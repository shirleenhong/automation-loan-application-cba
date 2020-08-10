*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***     

Navigate to View/Update Lender Share via Unscheduled Commitment Increase Notebook
    [Documentation]    This keyword is for navigating Lender Shares Window
    ...    @author:mgaling
    
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Window}
    mx LoanIQ select    ${LIQ_UnscheduledCommitmentIncrease_Options_ViewUpdateLenderShares}
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Shares_Window} 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UnscheduledCommitmentIncrease_Shares_Window}            VerificationData="Yes"

Validate PrimariesAssginees Section
    [Documentation]    This keyword is for validating values under Primaries/Assignees Section.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps
    [Arguments]    ${sHostBank_Lender}    ${sLender1}    ${sLender2}    ${sIncrease_Amount}    ${sHostBankLender_Percentage}    ${sLender1_Percentage}    ${sLender2_Percentage}    
    ...    ${sRunVar_Computed_HBActualAmount}=None    ${sRunVar_Computed_BDOActualAmount}=None    ${sRunVar_Computed_BPIActualAmount}=None   
    
    ### GetRuntime Keyword Pre-processing ###
    ${HostBank_Lender}    Acquire Argument Value    ${sHostBank_Lender}
    ${Lender1}    Acquire Argument Value    ${sLender1}
    ${Lender2}    Acquire Argument Value    ${sLender2}
    ${Increase_Amount}    Acquire Argument Value    ${sIncrease_Amount}
    ${HostBankLender_Percentage}    Acquire Argument Value    ${sHostBankLender_Percentage}
    ${Lender1_Percentage}    Acquire Argument Value    ${sLender1_Percentage}
    ${Lender2_Percentage}    Acquire Argument Value    ${sLender2_Percentage}

    
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Shares_Window}
    
    ${HB_UIActualAmount}    ${BDO_UIActualAmount}    ${BPI_UIActualAmount}    Get Primaries Actual Amount    ${HostBank_Lender}    ${Lender1}    ${Lender2}
    ${Computed_HBActualAmount}    ${Computed_BDOActualAmount}    ${Computed_BPIActualAmount}    Computed Actual Amount for Primaries    ${Increase_Amount}    ${HostBankLender_Percentage}    ${Lender1_Percentage}    ${Lender2_Percentage}  
    
    Should Be Equal    ${HB_UIActualAmount}    ${Computed_HBActualAmount}  
    Should Be Equal    ${BDO_UIActualAmount}    ${Computed_BDOActualAmount} 
    Should Be Equal    ${BPI_UIActualAmount}    ${Computed_BPIActualAmount}    
    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Primaries_Assignee
    
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_Computed_HBActualAmount}    ${Computed_HBActualAmount}
    Save Values of Runtime Execution on Excel File    ${sRunVar_Computed_BDOActualAmount}    ${Computed_BDOActualAmount}   
    Save Values of Runtime Execution on Excel File    ${sRunVar_Computed_BPIActualAmount}    ${Computed_BPIActualAmount}
    
    [Return]    ${Computed_HBActualAmount}    ${Computed_BDOActualAmount}    ${Computed_BPIActualAmount}    


Get Primaries Actual Amount
    [Documentation]    This keyword is for getting actual amount of Primaries.
    ...    @author:mgaling
    [Arguments]    ${HostBank_Lender}    ${Lender1}    ${Lender2}           
    
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Shares_Window}
    
    ${HB_UIActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UnscheduledCommitmentIncrease_PrimariesAssignees_JavaTree}    ${HostBank_Lender}%Actual Amount%amount 
    ${HB_UIActualAmount}    Remove String    ${HB_UIActualAmount}    ,
    ${HB_UIActualAmount}    Convert To Number    ${HB_UIActualAmount}    2
    
    ${Lender1_UIActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UnscheduledCommitmentIncrease_PrimariesAssignees_JavaTree}    ${Lender1}%Actual Amount%amount
    ${Lender1_UIActualAmount}    Remove String    ${Lender1_UIActualAmount}    ,
    ${Lender1_UIActualAmount}    Convert To Number    ${Lender1_UIActualAmount}    2
    
    ${Lender2_UIActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UnscheduledCommitmentIncrease_PrimariesAssignees_JavaTree}    ${Lender2}%Actual Amount%amount
    ${Lender2_UIActualAmount}    Remove String    ${Lender2_UIActualAmount}    ,
    ${Lender2_UIActualAmount}    Convert To Number    ${Lender2_UIActualAmount}    2  
    
    [Return]    ${HB_UIActualAmount}    ${Lender1_UIActualAmount}    ${Lender2_UIActualAmount} 
    
Computed Actual Amount for Primaries
    [Documentation]    This keyword is for computing values of Primaries.
    ...    @author:mgaling
    [Arguments]    ${Increase_Amount}    ${HostBankLender_Percentage}    ${Lender1_Percentage}    ${Lender2_Percentage}        
    
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Shares_Window}
    
    ${Increase_Amount}    Remove String    ${Increase_Amount}    ,
    ${Increase_Amount}    Convert To Number    ${Increase_Amount}    2
    
    ${Computed_HBActualAmount}    Evaluate    ${Increase_Amount}*(${HostBankLender_Percentage}/100)
    ${Computed_HBActualAmount}    Convert To Number    ${Computed_HBActualAmount}    2
    
    ${Computed_Lender1ActualAmount}    Evaluate    ${Increase_Amount}*(${Lender1_Percentage}/100)
    ${Computed_Lender1ActualAmount}    Convert To Number    ${Computed_Lender1ActualAmount}    2
    
    ${Computed_Lender2ActualAmount}    Evaluate    ${Increase_Amount}*(${Lender2_Percentage}/100)
    ${Computed_Lender2ActualAmount}    Convert To Number    ${Computed_Lender2ActualAmount}    2
    
    [Return]    ${Computed_HBActualAmount}    ${Computed_Lender1ActualAmount}    ${Computed_Lender2ActualAmount}     
     
Validate Host Bank Shares Section
    [Documentation]    This keyword is for validating values under Host bank shares Section.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps
    [Arguments]    ${sComputed_HBActualAmount}    ${sHostBank_Lender}    ${sRunVar_HBShares_UIActualAmount}=None
    
    ### GetRuntime Keyword Pre-processing ###
    ${Computed_HBActualAmount}    Acquire Argument Value    ${sComputed_HBActualAmount}
    ${HostBank_Lender}    Acquire Argument Value    ${sHostBank_Lender}
    
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Shares_Window}
    
    ${HBShares_UIActualAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UnscheduledCommitmentIncrease_HostBankShares_JavaTree}    ${HostBank_Lender}%Actual Amount%amount      
    ${HBShares_UIActualAmount}    Remove String    ${HBShares_UIActualAmount}    ,
    ${HBShares_UIActualAmount}    Convert To Number    ${HBShares_UIActualAmount}    2
    
    Should Be Equal    ${HBShares_UIActualAmount}    ${Computed_HBActualAmount}
    Log    ${HBShares_UIActualAmount}=${Computed_HBActualAmount} 
    
    ### ConstRuntime Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVar_HBShares_UIActualAmount}    ${HBShares_UIActualAmount}
             
    [Return]    ${HBShares_UIActualAmount}
    
Validate Actual Total Amount under PrimariesAssginees Section 
    [Documentation]    This keyword is for validating Actual Total under Primaries/Assignees Section.
    ...    @author:mgaling  
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps and Screenshot steps   
    [Arguments]    ${sIncrease_Amount}    ${sComputed_HBActualAmount}    ${sComputed_Lender1ActualAmount}    ${sComputed_Lender2ActualAmount}  
    
    ### GetRuntime Keyword Pre-processing ###
    ${Increase_Amount}    Acquire Argument Value    ${sIncrease_Amount}
    ${Computed_HBActualAmount}    Acquire Argument Value    ${sComputed_HBActualAmount}
    ${Computed_Lender1ActualAmount}    Acquire Argument Value    ${sComputed_Lender1ActualAmount}     
    ${Computed_Lender2ActualAmount}    Acquire Argument Value    ${sComputed_Lender2ActualAmount}   
    
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Shares_Window}
    
    ${Conv_IncreaseAmount}    Remove String    ${Increase_Amount}    ,
    ${Conv_IncreaseAmount}    Convert To Number    ${Conv_IncreaseAmount}    2    
    
    ${Computed_ActualTotal}    Evaluate    (${Computed_HBActualAmount})+(${Computed_Lender1ActualAmount})+(${Computed_Lender2ActualAmount})
    
    Should Be Equal    ${Conv_IncreaseAmount}    ${Computed_ActualTotal}
    Log    ${Conv_IncreaseAmount}=${Computed_ActualTotal}    
    
    ${UI_ActualTotal}    Mx LoanIQ Get Data    ${LIQ_UnscheduledCommitmentIncrease_Shares_ActualTotal}    value%Total
    ${UI_ActualTotal}    Remove String    ${UI_ActualTotal}    ,
    ${UI_ActualTotal}    Convert To Number    ${UI_ActualTotal}    2 
    
    Should Be Equal    ${UI_ActualTotal}    ${Computed_ActualTotal}
    Log    ${UI_ActualTotal}=${Computed_ActualTotal}                   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Primaries_Assignee1
    

Validate Actual Net All Total Amount under Host Bank Shares Section 
    [Documentation]    This keyword is for validating Actual Net All Total under Host Bank Shares Section.
    ...    @author:mgaling
    ...    @update: sahalder    06AUG2020    Added keyword pre-processing steps
    [Arguments]    ${sHBShares_UIActualAmount} 
    
    ### GetRuntime Keyword Pre-processing ###
    ${HBShares_UIActualAmount}    Acquire Argument Value    ${sHBShares_UIActualAmount}      
    
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Shares_Window}
     
    ${UI_ActualNetAllTotal}    Mx LoanIQ Get Data    ${LIQ_UnscheduledCommitmentIncrease_Shares_ActualNetAllTotal}    value%Total
    ${UI_ActualNetAllTotal}    Remove String    ${UI_ActualNetAllTotal}    ,
    ${UI_ActualNetAllTotal}    Convert To Number    ${UI_ActualNetAllTotal}    2    
    
    Should Be Equal    ${HBShares_UIActualAmount}    ${UI_ActualNetAllTotal}
    Log    ${HBShares_UIActualAmount}=${UI_ActualNetAllTotal}        
    mx LoanIQ click    ${LIQ_UnscheduledCommitmentIncrease_Shares_OK_Button}
    
Generate Intent Notices in Unscheduled Commitment Increase Notebook
    [Documentation]    This keyword is for generating Intent Notices under Work flow Tab.
    ...    @author:mgaling 
    
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UnscheduledCommitmentIncrease_Tab}    Workflow
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_UnscheduledCommitmentIncrease_WorkflowTab_JavaTree}    Generate Intent Notices         
    Run Keyword If    ${status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UnscheduledCommitmentIncrease_WorkflowTab_JavaTree}    Generate Intent Notices%d   
    Run Keyword If    ${status}==False    Log    Fail    Generate Intent Notices is not available    
    
    mx LoanIQ activate window    ${LIQ_Notices_Window}
    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    
    mx LoanIQ activate window    ${LIQ_CommitmentChangeGroup_Window}
    mx LoanIQ click    ${LIQ_CommitmentChangeGroup_Exit_Button}
    
    mx LoanIQ activate window    ${LIQ_UnscheduledCommitmentIncrease_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UnscheduledCommitmentIncrease_Tab}    Workflow
    Mx LoanIQ Verify Runtime Property    ${LIQ_UnscheduledCommitmentIncrease_WorkflowTab_JavaTree}    items count%0  
    mx LoanIQ close window    ${LIQ_UnscheduledCommitmentIncrease_Window}      
    
Navigate To Amendment Notebook Workflow
    [Documentation]    This keyword navigates the Workflow tab of a Notebook, and does a specific transaction.
    ...    
    ...    | Arguments |
    ...    
    ...    'Transaction' = The type of transaction listed under Workflow. Ex. Send to Approval, Approve, Release
    ...    
    ...    @author:    sahalder    06AUG2020    initial create
    [Arguments]    ${sTransaction}    

    ###Pre-processing Keyword##
    
    ${Transaction}    Acquire Argument Value    ${sTransaction} 

    mx LoanIQ activate window    ${LIQ_AmendmentNotebook}
    Mx LoanIQ Select Window Tab    ${LIQ_AMD_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NotebookWorkflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_AMD_Workflow_JavaTree}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NotebookWorkflow             
         
    
    

             
