*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
BUS_Open Loan Change Transaction NoteBook
    [Documentation]    This keyword is used to Open change Loan Transaction Notebook
    ...    @author: Archana    03Jul2020
    Run Keyword    Open Loan Change Transaction NoteBook
    
BUS_Loan Change Transaction
    [Documentation]    This keyword is used to change loan transaction
    ...    @author :Archana    03Jul2020
    Run Keyword    Loan Change Transaction    ${ARGUMENT_1}
    
BUS_Select a Change Field
    [Documentation]    This keyword is used to select the change item
    ...    @author :Archana    03Jul2020
    Run Keyword    Select a Change Field    ${ARGUMENT_1}
    
BUS_Add New Value On Loan Change Transaction
    [Documentation]    This keyword is used to add the new value on change item
    ...    @author :Archana    03Jul2020
    Run Keyword    Add New Value On Loan Change Transaction    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_OutstandingChangeTransaction_Send to Approval
    [Documentation]    This keyword will complete the initial work items in Outstanding change Transaction
    ...    @author:Archana 03Jul2020
    Run Keyword    OutstandingChangeTransaction_Send to Approval    
    
BUS_Approve Outstanding Change Transaction
    [Documentation]    This keyword will approve the Awaiting Approval - Outstanding Change Transaction
    ...    @author: archana 03Jul2020
    Run Keyword    Approve Outstanding Change Transaction
    
BUS_Release Pending Oustanding Change Transaction
    [Documentation]    This keyword will release the Pending Oustanding Change Transaction 
    ...    @author: Archana  03Jul2020
    Run Keyword    Release Pending Oustanding Change Transaction    
    
BUS_Release Outstanding Change Transaction in Workflow 
    [Documentation]    This keyword will release the Oustanding Change Transaction in Workflow Tab
    ...    @author:Archana 03Jul2020
    Run Keyword    Release Outstanding Change Transaction in Workflow    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_GetUIVlaue of Changed Outstanding Transaction
    [Documentation]    This keyword is used to fetch the New Chnage value of Outstanding Transaction
    ...    @author: Archana 03Jul2020
    Run Keyword    GetUIVlaue of Changed Outstanding Transaction    ${ARGUMENT_1}
    
BUS_Validation of Outstanding Change Transaction
    [Documentation]    This keyword is used to Validate the Changed Outstanding Transactions
    ...    @autor:Archana 03Jul2020
    Run Keyword    Validation of Outstanding Change Transaction    ${ARGUMENT_1}    ${ARGUMENT_2} 