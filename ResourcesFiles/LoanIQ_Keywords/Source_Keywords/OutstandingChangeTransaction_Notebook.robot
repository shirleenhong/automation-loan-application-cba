*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Open Loan Change Transaction NoteBook
    [Documentation]    This keyword is used to Open change Loan Transaction Notebook
    ...    @author: Archana    03Jul2020
   Mx LoanIQ Activate Window    ${LIQ_FixedRateOptionLoan_Window}
   Select Menu Item    ${LIQ_FixedRateOptionLoan_Window}    Options    Loan Change Transaction
   
Loan Change Transaction
    [Documentation]    This keyword is used to change loan transaction
    ...    @author :Archana    03Jul2020
    [Arguments]    ${sEffective_date}
    ###Pre-Processing Keyword###
    ${Effective_date}    Acquire Argument Value    ${sEffective_date}
        
    Mx LoanIQ Activate    ${LIQ_LoanChangeTransaction_Window}   
    Mx LoanIQ Enter    ${LIQ_LoanChangeTransaction_EffectiveDate}    ${Effective_date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanChangeTransaction
    Mx LoanIQ Click    ${LIQ_LoanChangeTransaction_Add_Button}
    
Select a Change Field
    [Documentation]    This keyword is used to select the change item
    ...    @author :Archana    03Jul2020
    [Arguments]    ${sChange_Item}
    ###Pre-processing Keyword###
    ${Change_Item}    Acquire Argument Value    ${sChange_Item}      
    Mx LoanIQ Activate Window    ${LIQ_SelectChangeField_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectChangeField_Tree}    ${Change_Item}%s
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanChangeField
    Mx LoanIQ Click    ${LIQ_SelectChangeField_OK_Button}
    
Add New Value On Loan Change Transaction
    [Documentation]    This keyword is used to add the new value on change item
    ...    @author :Archana    03Jul2020
    [Arguments]    ${sContractID_Value}    ${sNew_ContractID}
    ###Pre-Processing keyword###
    ${ContractID_Value}    Acquire Argument Value    ${sContractID_Value}
    ${New_ContractID}    Acquire Argument Value    ${sNew_ContractID}
        
    Mx LoanIQ Activate Window    ${LIQ_LoanChangeTransaction_Window}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_LoanChangeTransaction_NewValue_JavaTree}    ${ContractID_Value}%d
    Mx LoanIQ Activate Window    ${LIQ_ContractID_Window}    
    Mx LoanIQ Enter    ${LIQ_NewContractID}    ${New_ContractID}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanChangeTransactionNewValue
    Mx LoanIQ Click    ${LIQ_ContractID_Ok_Button}   
    
OutstandingChangeTransaction_Send to Approval
    [Documentation]    This keyword will complete the initial work items in Outstanding change Transaction
    ...    @author:Archana 03Jul2020      
    Mx LoanIQ Activate    ${LIQ_LoanChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanChangeTransaction_Tab}    Workflow    
    Mx LoanIQ DoubleClick    ${LIQ_LoanChangeTransaction_Worflow_Javatree}    Send to Approval                          
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    Log    Workflow Items are complete and ready for approval!  
    
Approve Outstanding Change Transaction
    [Documentation]    This keyword will approve the Awaiting Approval - Outstanding Change Transaction
    ...    @author: archana 03Jul2020   
    mx LoanIQ activate window    ${LIQ_LoanChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_LoanChangeTransaction_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_LoanChangeTransaction_Worflow_Javatree}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Log    Outstanding Change Transaction is now approved  
    
Release Pending Oustanding Change Transaction
    [Documentation]    This keyword will release the Pending Oustanding Change Transaction 
    ...    @author: Archana  03Jul2020         
    mx LoanIQ activate window    ${LIQ_FixedRateOptionLoan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FixedRateOptionLoan_Pending_Tab}    Pending 
    Mx LoanIQ DoubleClick    ${LIQ_FixedRateOptionLoan_ListItem}    Awaiting Release
    Mx LoanIQ Close Window    ${LIQ_FixedRateOptionLoan_Window} 
    
Release Outstanding Change Transaction in Workflow 
    [Documentation]    This keyword will release the Oustanding Change Transaction in Workflow Tab
    ...    @author:Archana 03Jul2020 
    [Arguments]    ${sOld_Value}=None    ${sNew_Value}=None    ${RuntimeVarOLD_ContractID}=None    ${RuntimeVarNEW_ContractID}=None
    ###Pre-processing keyword###
    ${Old_Value}    Acquire Argument Value    ${sOld_Value}
    ${sNew_Value}    Acquire Argument Value    ${sNew_Value}
   
    Mx LoanIQ Activate Window    ${LIQ_LoanChangeTransaction_Window}
    ${OLD_ContractID}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanChangeTransaction_NewValue_JavaTree}    Contract ID%Old Value%${Old_Value}
    ${NEW_ContractID}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LoanChangeTransaction_NewValue_JavaTree}    Contract ID%New Value%${sNew_Value}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingChangeTransaction    
    Mx LoanIQ Select Window Tab    ${LIQ_LoanChangeTransaction_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_LoanChangeTransaction_Worflow_Javatree}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}     
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Log    Outstanding Change Transaction is complete
    
    ###Post-processing keyword###
    Save Values of Runtime Execution on Excel File    ${RuntimeVarOLD_ContractID}    ${OLD_ContractID}
    Save Values of Runtime Execution on Excel File    ${RuntimeVarNEW_ContractID}    ${NEW_ContractID}
    [Return]    ${OLD_ContractID}    ${NEW_ContractID}   
    
GetUIVlaue of Changed Outstanding Transaction
    [Documentation]    This keyword is used to fetch the New Chnage value of Outstanding Transaction
    ...    @author: Archana 03Jul2020
    [Arguments]    ${sRuntimeVar_Contract_ID}=None
    ###Pre-processing keyword###
    ${RuntimeVar_Contract_ID}    Acquire Argument Value    ${sRuntimeVar_Contract_ID}            
    Mx LoanIQ Activate Window    ${LIQ_FixedRateOptionLoan_Window}
    ${Contract_ID}    Mx LoanIQ Get Data    ${LIQ_FixedRateOptionLoan_ContractID}    input=value
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NewContractID
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_Contract_ID}    ${Contract_ID}
    
    ###Post-Processing keyword###
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_Contract_ID}    ${Contract_ID}
    [Return]    ${Contract_ID}      
    
Validation of Outstanding Change Transaction
    [Documentation]    This keyword is used to Validate the Changed Outstanding Transactions
    ...    @autor:Archana 03Jul2020
    [Arguments]    ${sNEW_ContractID}=None    ${sContract_ID}=None
    ###Pre-Processing Keyword###
    ${NEW_ContractID}     Acquire Argument Value    ${sNEW_ContractID}
    ${sContract_ID}     Acquire Argument Value    ${sContract_ID}
      
    Should Be Equal    ${NEW_ContractID}    ${sContract_ID}    
