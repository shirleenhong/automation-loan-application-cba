*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate to Manual Funds Flow Notebook
    [Documentation]    This keyword will navigate to Manual Funds Flow 
    ...    @author: Archana 20Jul2020 - initial create
    Run Keyword    Navigate to Manual Funds Flow Notebook    
    
BUS_Select New Manual Fund Flow
    [Documentation]    This keyword is used to select new Manul Fund Flow
    ...    @author:Archana 20Jul2020 - initial create
    Run Keyword    Select New Manual Fund Flow
    
BUS_Manual FundFlow Details
    [Documentation]    This keyword is used to enter details in Manual FundFlow Notebook
    ...    @author:Archana 20Jul2020 - initial create
    Run Keyword    Manual FundFlow Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    
BUS_Select Expense Code
    [Documentation]    This keyword is used to select Expense Code
    ...    @author:Archana 20Jul2020 - initial create
    Run Keyword    Select Expense Code    ${ARGUMENT_1}
    
BUS_Select Security ID
    [Documentation]    This keyword is used to select Security ID
    ...    @author:Archana 20Jul2020 - initial create
    Run Keyword    Select Security ID    
    
BUS_Select Deal
    [Documentation]    This keyword is used to select Deal
    ...    @author:Archana 20Jul2020 - initial create
    Run Keyword    Select Deal    ${ARGUMENT_1}
    
BUS_Add IncomingFunds
    [Documentation]    This keyword is used to Add Incoming Funds
    ...    @author:Archana 20Jul2020 - initial create
    Run Keyword    Add IncomingFunds    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Select Customer
    [Documentation]    This keyword is used to select the Customer
    ...    @author:Archana 20Jul2020 - initial create
    Run Keyword    Select Customer    ${ARGUMENT_1}
    
BUS_Add OutgoingFunds
    [Documentation]    This keyword is used to Add Outgoing Funds
    ...    @author:Archana 20Jul2020 - initial create
    Run Keyword    Add OutgoingFunds    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Navigate Notebook Workflow - Cashflow Creation
    [Documentation]    This keyword is used to create cashflow in workflow
    ...    @author:Archana 22Jul2020 - initial create
    Run Keyword    Navigate Notebook Workflow - Cashflow Creation    
    
BUS_Close Cashflow Window
    [Documentation]    This keyword is used to close cashflow window
    ...    @author: Archana 22Jul2020 - initial create
    Run Keyword    Close Cashflow Window    
    
BUS_Send Manual Fund Flow to Approval
    [Documentation]    This keyword will send the Manual Fund Flow to Approval
    ...    @author: Archana 21Jul2020  - initial create
    Run Keyword    Send Manual Fund Flow to Approval       
    
BUS_Approve Manual Fund Flow
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Manual Fund Flow
    ...    @author: Archana 21Jul2020  - initial create
    Run Keyword    Approve Manual Fund Flow    
    
BUS_Select Existing Manual Fund Flow
    [Documentation]    This keyword is used to select Existing Manul Fund Flow
    ...    @author:Archana 20Jul2020 - initial create
    Run Keyword    Select Existing Manual Fund Flow    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Select Manual Fund Flow Transaction From List
    [Documentation]    This keyword is used to select Transaction from the List
    ...    @author: Archana 20Jul2020 - initial create
    Run Keyword    Select Manual Fund Flow Transaction From List    ${ARGUMENT_1}
    
BUS_Navigate to Release Cashflow - Manual Fund Flow
    [Documentation]    This  keyword will release the Manual GL
    ...    @author: Archana 21Jul2020 - initial create
    Run Keyword    Navigate to Release Cashflow - Manual Fund Flow    
    
BUS_Release Manual Fund Flow
    [Documentation]    This  keyword will release the Manual Fund Flow
    ...    @author: Archana 21Jul2020 - initial create
    Run Keyword    Release Manual Fund Flow    
    
BUS_Validate Events Tab for Manual Fund Flow
    [Documentation]    This  keyword will validate Manual Fund Flow Events in the Events tab
    ...    @author: Archana 21Jul2020 - initial create
    Run Keyword    Validate Events Tab for Manual Fund Flow    
    
BUS_Validation Of GL Entries
    [Documentation]    This keyword is used to validate the GL Entries of Manual Fund Flow Transaction
    ...    @author: Archana 21Jul2020 - initial create
    Run Keyword    Validation Of GL Entries
    
BUS_Close GL Entries_Manual Fund Flow Notebook
    [Documentation]    This keyword is used to close GL Entries Notebook
    ...    @author:Archana 22Jul2020 - initial create
    Run Keyword    Close GL Entries_Manual Fund Flow Notebook