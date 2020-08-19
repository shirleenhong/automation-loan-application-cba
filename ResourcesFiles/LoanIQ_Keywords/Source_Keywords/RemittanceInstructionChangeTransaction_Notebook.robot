*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Add Remittance Instruction
    [Documentation]    This keyword is used to add the Remittance Instruction
    ...    @author:Archana 30JUN2020
    ...           - Added pre-processing keyword
    [Arguments]    ${sBorrower}
     
    ###Pre-processing keyword###
    ${Borrower}    Acquire Argument Value    ${sBorrower}
           
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectBorrower_JavaTree}    ${Borrower}%s 
    Mx LoanIQ Click    ${LIQ_ActiveCustomer_RemittanceInstructions_Button}    
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
Select Remittance Method
    [Documentation]    This keyword is used to amend the contacts
    ...    @author:Archana 30JUN2020
    [Arguments]    ${sRemittance_Method}
    
    ###Pre-Processing Keyword###
    ${Remittance_Method}    Acquire Argument Value    ${sRemittance_Method}    
    
    Mx LoanIQ Activate    ${LIQ_RemittanceList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_RemittanceList_Method}    ${Remittance_Method}%d
    
Update Remittance Instruction Details
    [Documentation]    This keyword is used to update Remittance Instruction Details
    ...    @author:Archana 30JUN2020            
    Mx LoanIQ Activate    ${LIQ_RemittanceInstructionsDetails_Window}   
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Select Menu Item    ${LIQ_RemittanceInstructionsDetails_Window}    Options    Remittance Instruction Change Transaction
     
Remittance Instruction Change Details
    [Documentation]    This keyword is used to Change Remittance Instruction Details
    ...    @author:Archana 30JUN2020
    [Arguments]    ${sEffective_date}    ${sAccount_Name}
    
    ###Pre-processing Keyword###
    ${Effective_date}    Acquire Argument Value    ${sEffective_date}
    ${Account_Name}    Acquire Argument Value    ${sAccount_Name}
     
    Mx LoanIQ Activate    ${LIQ_RemittanceChangeTransaction_Window}
    Mx LoanIQ Enter    ${LIQ_RemittanceChangeTransaction_EffectiveDate}    ${Effective_date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RemittanceInstructionDetailsScreen
    ${RI_AccountName}    Mx LoanIQ Store RunTime Value By Colname    ${LIQ_RemittanceChangeTransaction_AccountName}    Account Name%New Value%RI_AccountName    
    Mx LoanIQ Click Javatree Cell    ${LIQ_RemittanceChangeTransaction_AccountName}    Account Name%${RI_AccountName}%New Value     
    Mx LoanIQ Send Keys    ${Account_Name}      
       
Remittance Instructions Change details for AccountName
    [Documentation]    This keyword is used to Change Remittance Instruction Details for AccountName
    ...    @author:Archana 30JUN2020
    [Arguments]    ${sNewAccount_Name}    ${sAccount_Number}    ${sNewAccount_Number}
    
    ###Pre-Processing Keyword###
    ${NewAccount_Name}    Acquire Argument Value    ${sNewAccount_Name}        
    ${Account_Number}    Acquire Argument Value    ${sAccount_Number}
    ${NewAccount_Number}    Acquire Argument Value    ${sNewAccount_Number}

    Mx LoanIQ Activate    ${LIQ_RemittanceChangeTransaction_AccountName_Window}
    Mx LoanIQ Enter    ${LIQ_RemittanceChangeTransaction_NewAccountName}    ${NewAccount_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NewAccountName
    Mx LoanIQ Click    ${LIQ_RemittanceChangeTransaction_NewAccount_Ok_Button}           
    
ChangeRemittanceInstructionTransaction_Send to Approval
    [Documentation]    This keyword will complete the initial work items in RemittanceInstruction change Transaction
    ...    @author:Archana 30JUN2020      
    Mx LoanIQ Activate    ${LIQ_RemittanceChangeTransaction_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_RemittanceChangeTransaction_Workflow_Tab}    Workflow
    mx LoanIQ click element if present    ${LIQ_RemittanceChangeTransaction_Warning_Yes_Button}
    Mx LoanIQ DoubleClick    ${LIQ_RemittanceChangeTransaction_ListItem}    Send to Approval                          
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    Log    Workflow Items are complete and ready for approval! 
    
Approve Remittance Instructions Change Transaction
    [Documentation]    This keyword will approve the Awaiting Approval - RemittanceInstruction Change Transaction
    ...    @author: archana 24JUN2020   
    mx LoanIQ activate window    ${LIQ_RemittanceChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_RemittanceChangeTransaction_Workflow_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_RemittanceChangeTransaction_ListItem}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Log    Remittance Instructions Change Transaction is now approved
    
Navigate to Pending Remittance Instructions Change Transaction
    [Documentation]    This keyword is used to Navigate to Pending Awaiting Release Transaction
    ...    @autor:Archana 30JUL2020
    Mx LoanIQ Activate    ${LIQ_RemittanceInstructionsDetails_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_RemittanceInstructionsDetails_TabSelection}    Pending
    Mx LoanIQ DoubleClick    ${LIQ_RemittanceInstructionsDetails_Pending_JavaTree}    Awaiting Release    
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    Mx LoanIQ Close Window    ${LIQ_RemittanceInstructionsDetails_Window}
    
Release Remittance Instructions Change Transaction in Workflow
    [Documentation]    This keyword will release the Remittance Instructions Change Transaction in Workflow tab
    ...    @author: Archana  30JUN2020 
    mx LoanIQ activate window    ${LIQ_RemittanceChangeTransaction_Window}       
    Mx LoanIQ Select Window Tab    ${LIQ_RemittanceChangeTransaction_Workflow_Tab}    Workflow 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ReleaseRemittanceInstructions
    Mx LoanIQ DoubleClick    ${LIQ_RemittanceChangeTransaction_ListItem}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}        
    Log    Remittance Instruction Change Transaction is complete
 
GetUIValue of Remittance Change Transaction Details
    [Documentation]    This keyword is used to fetch the new amended values
    ...    @author:Archana 30JUL2020
    [Arguments]    ${RuntimrVar_Old_value}=None    ${RuntimeVar_New_value}=None   
    mx LoanIQ activate window    ${LIQ_RemittanceChangeTransaction_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_RemittanceChangeTransaction_Workflow_Tab}    General
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/RemittanceCangeTransaction    
    ${Old_value}    Mx LoanIQ Store RunTime Value By Colname    ${LIQ_RemittanceChangeTransaction_AccountName}    Account Name%Old Value%Old_Value
    ${New_value}    Mx LoanIQ Store RunTime Value By Colname    ${LIQ_RemittanceChangeTransaction_AccountName}    Account Name%New Value%New_Value
    
    ###Post-Processing Keyword###
    Save Values of Runtime Execution on Excel File    ${RuntimrVar_Old_value}    ${Old_value}
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_New_value}    ${New_value}    
    [Return]    ${Old_value}    ${New_value}    
    
Validation of Amended Remittance Change Transaction Details
    [Documentation]    This keyword is used to validate the amended contact details
    ...    @author:Archana  24JUN2020
    [Arguments]    ${sNew_value}    ${sNewAccount_Name}
    
    ###Pre-processing keyword###    ${New_value}    Acquire Argument Value    ${sNew_value}
    ${New_AccountNumber}    Acquire Argument Value    ${sNewAccount_Name}    
      
    Should Be Equal    ${sNew_value}    ${sNewAccount_Name}    