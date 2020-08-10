*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
    
BUS_Launch Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Launch Outgoing Manual Cashflow Notebook

BUS_Populate Outgoing Manual Cashflow Notebook - General Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Populate Outgoing Manual Cashflow Notebook - General Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    ...    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}

BUS_Add Debit Offset in Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Add Debit Offset in Outgoing Manual Cashflow Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Save and Validate Data in Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Save and Validate Data in Outgoing Manual Cashflow Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Navigate to Cashflow in Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Navigate to Cashflow in Outgoing Manual Cashflow Notebook

BUS_Send Outgoing Manual Cashflow to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Send Outgoing Manual Cashflow to Approval

BUS_Approve Outgoing Manual Cashflow to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Approve Outgoing Manual Cashflow to Approval

BUS_Open Existing Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Open Existing Outgoing Manual Cashflow Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Release Cashflows for Outgoing Manual Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Release Cashflows for Outgoing Manual Cashflow    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    ...    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}

BUS_Release Outgoing Manual Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Release Outgoing Manual Cashflow

BUS_Validate Debit Offset Detail at Outgoing Manual Cashflow Table
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Validate Debit Offset Detail at Outgoing Manual Cashflow Table    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate GL Entries in Outgoing Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Validate GL Entries in Outgoing Manual Cashflow Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}