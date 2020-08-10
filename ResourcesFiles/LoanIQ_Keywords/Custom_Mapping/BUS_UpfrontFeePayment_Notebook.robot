*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Populate Upfront Fee Payment Notebook
     [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: Archana 14Jul2020 - initial create

    Run Keyword    Populate Upfront Fee Payment Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Populate Fee Details Window 
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: Archana 14Jul2020 - initial create

    Run Keyword    Populate Fee Details Window    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Send to Approval Upfront Fee Payment 
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: Archana 14Jul2020 - initial create

    Run Keyword    Send to Approval Upfront Fee Payment
    
BUS_Approve Upfront Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: Archana 14Jul2020 - initial create

    Run Keyword    Approve Upfront Fee Payment
    
BUS_Release Upfront Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: Archana 14Jul2020 - initial create

    Run Keyword    Release Upfront Fee Payment

BUS_Navigate to Upfront Fee Payment then Input Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    21JUL2020    - initial create
    
    Run Keyword    Navigate to Upfront Fee Payment then Input Details    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Navigate to Upfront Fee Payment Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    21JUL2020    - initial create
    
    Run Keyword    Navigate to Upfront Fee Payment Workflow and Proceed With Transaction    ${ARGUMENT_1}

BUS_Populate Upfront Fee From Borrower / Agent
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: jloretiz    02AUG2020    - initial create
    
    Run Keyword    Populate Upfront Fee From Borrower / Agent    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Save and Exit Upfront Fee From Borrower / Agent
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: jloretiz    02AUG2020    - initial create
    
    Run Keyword    Save and Exit Upfront Fee From Borrower / Agent