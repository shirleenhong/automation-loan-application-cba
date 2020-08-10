*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Get Ticking Fee Amount From Definition
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    27MAY2020    - initial create

    Run Keyword    Get Ticking Fee Amount From Definition    ${ARGUMENT_1}    

BUS_Create Ticking Fee Payment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    27MAY2020    - initial create

    Run Keyword    Create Ticking Fee Payment
    
BUS_Validate Ticking Fee Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    27MAY2020    - initial create

    Run Keyword    Validate Ticking Fee Details    ${ARGUMENT_1}     ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Set Ticking Fee General Tab Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    27MAY2020    - initial create

    Run Keyword    Set Ticking Fee General Tab Details    ${ARGUMENT_1}     ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Save Ticking Fee
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    27MAY2020    - initial create

    Run Keyword    Save Ticking Fee
    
BUS_Validate Ticking Fee Events
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    27MAY2020    - initial create

    Run Keyword    Validate Ticking Fee Events    ${ARGUMENT_1}
    
BUS_Validate Ticking Fee Notebook Pending Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    27MAY2020    - initial create

    Run Keyword    Validate Ticking Fee Notebook Pending Tab
    
BUS_Validate Ticking Fee In Deal Notebook's Events And Pending Tabs
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    27MAY2020    - initial create

    Run Keyword    Validate Ticking Fee In Deal Notebook's Events And Pending Tabs    ${ARGUMENT_1}

BUS_Validate Ticking Fee 'to Today' Projected Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Validate Ticking Fee 'to Today' Projected Amount

BUS_Validate Ticking Fee 'to Proj Deal Close Date' Projected Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Validate Ticking Fee 'to Proj Deal Close Date' Projected Amount

BUS_Complete Ticking Fee Definition Setup
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    30JUN2020    - initial create

    Run Keyword    Complete Ticking Fee Definition Setup  

BUS_Compute Ticking Fee 'To Today' Projected Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    06JUL2020    - initial create

    Run Keyword    Compute Ticking Fee 'To Today' Projected Amount    ${ARGUMENT_1}

BUS_Compute Ticking Fee 'To Proj Deal Close Date' Projected Amount
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    06JUL2020    - initial create

    Run Keyword    Compute Ticking Fee 'To Proj Deal Close Date' Projected Amount    ${ARGUMENT_1}

BUS_Navigate to Ticking Fee Workflow and Proceed With Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    22JUL2020    - initial create

    Run Keyword    Navigate to Ticking Fee Workflow and Proceed With Transaction    ${ARGUMENT_1}