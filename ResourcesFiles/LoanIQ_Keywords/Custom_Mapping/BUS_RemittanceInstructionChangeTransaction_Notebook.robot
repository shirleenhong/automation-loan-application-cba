*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
 
BUS_Add Remittance Instruction
    [Documentation]    This keyword is used to add the Remittance Instruction
    ...    @author:Archana 30JUN2020 - initial create
    Run Keyword    Add Remittance Instruction    ${ARGUMENT_1}
    
BUS_Select Remittance Method
    [Documentation]    This keyword is used to amend the contacts
    ...    @author:Archana 30JUN2020 - initial create
    Run Keyword    Select Remittance Method    ${ARGUMENT_1}
    
BUS_Update Remittance Instruction Details
    [Documentation]    This keyword is used to update Remittance Instruction Details
    ...    @author:Archana 30JUN2020 - initial create
    Run Keyword    Update Remittance Instruction Details    
    
BUS_Remittance Instruction Change Details
    [Documentation]    This keyword is used to Change Remittance Instruction Details
    ...    @author:Archana 30JUN2020 - initial create
    Run Keyword    Remittance Instruction Change Details    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Remittance Instructions Change details for AccountName
    [Documentation]    This keyword is used to Change Remittance Instruction Details for AccountName
    ...    @author:Archana 30JUN2020 - initial create
    Run Keyword    Remittance Instructions Change details for AccountName    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_ChangeRemittanceInstructionTransaction_Send to Approval
    [Documentation]    This keyword will complete the initial work items in RemittanceInstruction change Transaction
    ...    @author:Archana 30JUN2020 - initial create
    Run Keyword    ChangeRemittanceInstructionTransaction_Send to Approval    
    
BUS_Approve Remittance Instructions Change Transaction
    [Documentation]    This keyword will approve the Awaiting Approval - RemittanceInstruction Change Transaction
    ...    @author: archana 24JUN2020 - initial create
    Run Keyword    Approve Remittance Instructions Change Transaction    
    
BUS_Navigate to Pending Remittance Instructions Change Transaction
    [Documentation]    This keyword is used to Navigate to Pending Awaiting Release Transaction
    ...    @autor:Archana 30JUL2020 - initial create
    Run Keyword    Navigate to Pending Remittance Instructions Change Transaction    
    
BUS_Release Remittance Instructions Change Transaction in Workflow
    [Documentation]    This keyword will release the Remittance Instructions Change Transaction in Workflow tab
    ...    @author: Archana  30JUN2020 - initial create
    Run Keyword    Release Remittance Instructions Change Transaction in Workflow    
  
BUS_GetUIValue of Remittance Change Transaction Details
    [Documentation]    This keyword is used to fetch the new amended values
    ...    @author:Archana 30JUL2020 - initial create
    Run Keyword    GetUIValue of Remittance Change Transaction Details    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Validation of Amended Remittance Change Transaction Details
    [Documentation]    This keyword is used to validate the amended contact details
    ...    @author:Archana  24JUN2020 - initial create
    Run Keyword    Validation of Amended Remittance Change Transaction Details    ${ARGUMENT_1}    ${ARGUMENT_2}        