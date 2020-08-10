*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Enter Upfront Fee Distribution Details
    [Documentation]    This keyword is used to populate data in Fee Details Window.
    ...    @author: sahalder    04JUN2020    Initial Create
    [Arguments]    ${s_UpfrontFee_Amount}    ${s_sEffective_Date}=None 
    
    ### GetRuntime Keyword Pre-processing ###
    ${UpfrontFee_Amount}    Acquire Argument Value    ${s_UpfrontFee_Amount}
    ${sEffective_Date}    Acquire Argument Value    ${s_sEffective_Date}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_PaymentUpfrontFeeDistribution_Menu}
    mx LoanIQ activate window    ${LIQ_UpfrontFeeDistribution_Window}       
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeeDistribution_Window}    VerificationData="Yes"
    Run Keyword If    '${sEffective_Date}'!='None'    mx LoanIQ enter    ${LIQ_UpfrontFeeDistribution_EffectiveDate_Textfield}    ${sEffective_Date}
    Run Keyword If    '${UpfrontFee_Amount}'!='None'    mx LoanIQ enter    ${LIQ_UpfrontFeeDistribution_RequestedAmt_Textfield}    ${UpfrontFee_Amount}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UpfrontFeeDistribution_FeeAdd

Enter Fee Details
    [Documentation]    This keyword is used to populate data in Fee Details Window.
    ...    @author: sahalder    04JUN2020    Initial Create
    [Arguments]    ${s_Fee_Type}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Fee_Type}    Acquire Argument Value    ${s_Fee_Type}

    mx LoanIQ activate window    ${LIQ_UpfrontFeeDistribution_Window}
    mx LoanIQ click    ${LIQ_UpfrontFeeDistribution_FeeDetail_Button}
    :FOR    ${i}    IN RANGE    3
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    \    Exit For Loop If    ${Warning_Displayed}==False
    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeeDistribution_Window}    VerificationData="Yes"
    mx LoanIQ click    ${LIQ_FeeDetails_Add_Button}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UpfrontFeeDistribution_FeeDetails_Window}    VerificationData="Yes"
    mx LoanIQ select    ${LIQ_FeeDetail_FeeType_List}    ${Fee_Type}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/UpfrontFeeDistribution_FeeDetails
    mx LoanIQ click    ${LIQ_FeeDetail_FeeType_OK_Button} 
    
    mx LoanIQ click    ${LIQ_FeeDetails_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Approve Upfront Fee Distribution
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Upfront Fee Distribution.
    ...    @author: sahalder    04JUN2020    Initial Create
    
    mx LoanIQ activate window    ${LIQ_UpfrontFeeDistribution_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeeDistribution_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeeDistribution_Workflow_JavaTree}    Approval%d 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}     
    
Release Upfront Fee Distribution
    [Documentation]    This keyword navigates the 'Work In Process' window and release the Upfront Fee Distribution.
    ...    @author: sahalder    04JUN2020    Initial Create
    
    mx LoanIQ activate    ${LIQ_UpfrontFeeDistribution_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeeDistribution_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeeDistribution_Workflow_JavaTree}    Release%d
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Navigate Notebook Workflow in Distribute Upfront Fee Payment Notebook
    [Documentation]    This keyword navigates the Workflow tab of Distribute Upfront Fee Payment Notebook, and does a specific transaction.
    ...    @author: sahalder    10JUN2020    Initial Create
    ...    | Arguments |
    ...    
    ...    'Transaction' = The type of transaction listed under Workflow. Ex. Send to Approval, Approve, Release

    [Arguments]    ${s_Transaction}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${s_Transaction}

    mx LoanIQ activate window    ${LIQ_UpfrontFeeDistribution_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UpfrontFeeDistribution_Tab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_UpfrontFeeDistribution_Workflow_JavaTree}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}