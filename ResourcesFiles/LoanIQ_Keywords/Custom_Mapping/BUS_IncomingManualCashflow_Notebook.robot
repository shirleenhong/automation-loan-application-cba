*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
    
BUS_Launch Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Launch Incoming Manual Cashflow Notebook

BUS_Populate Incoming Manual Cashflow Notebook - General Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Populate Incoming Manual Cashflow Notebook - General Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    ...    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}

BUS_Add Credit Offset in Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Add Credit Offset in Incoming Manual Cashflow Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Save and Validate Data in Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Save and Validate Data in Incoming Manual Cashflow Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Navigate to Cashflow in Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Navigate to Cashflow in Incoming Manual Cashflow Notebook

BUS_Send Incoming Manual Cashflow to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Send Incoming Manual Cashflow to Approval

BUS_Approve Incoming Manual Cashflow to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Approve Incoming Manual Cashflow to Approval

BUS_Open Existing Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Open Existing Incoming Manual Cashflow Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Release Cashflows for Incoming Manual Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Release Cashflows for Incoming Manual Cashflow    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    ...    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}    ${ARGUMENT_10}    ${ARGUMENT_11}    ${ARGUMENT_12}

BUS_Release Incoming Manual Cashflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Release Incoming Manual Cashflow

BUS_Validate Credit Offset Detail at Incoming Manual Cashflow Table
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Validate Credit Offset Detail at Incoming Manual Cashflow Table    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Validate GL Entries in Incoming Manual Cashflow Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    07JUL2020    - initial create

    Run Keyword   Validate GL Entries in Incoming Manual Cashflow Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}