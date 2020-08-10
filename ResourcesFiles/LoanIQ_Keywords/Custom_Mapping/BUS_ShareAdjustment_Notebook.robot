*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Share Adjustment in Facility Notebook
    [Documentation]    This creates amendment via Deal Notebook.
    ...    @author: mgaling
    ...    @update: hstone    19JUN2020     - Updated to correct argument names.
    Run Keyword    Share Adjustment in Facility Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}

BUS_Validate Lender Shares
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create
    Run Keyword    Validate Lender Shares    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Update Facility Lender Shares
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create
    Run Keyword    Update Facility Lender Shares    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}

BUS_Add Share Adjustment Comment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create
    Run Keyword    Add Share Adjustment Comment    ${ARGUMENT_1}

BUS_Submit Share Adjustment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    19JUN2020    - initial create
    Run Keyword    Submit Share Adjustment
    
BUS_View/Update Lender Shares Make Selection
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create
    Run Keyword    View/Update Lender Shares Make Selection    ${ARGUMENT_1}
    
BUS_Set Share Adjusment General Tab Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create
    Run Keyword    Set Share Adjusment General Tab Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}
    
BUS_View/Update Lender Shares From Adjustment Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create
    Run Keyword    View/Update Lender Shares From Adjustment Window
    
BUS_Adjust Host Bank Portfolio Shares
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create
    Run Keyword    Adjust Host Bank Portfolio Shares    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    
BUS_Navigate to Shared Adjustment Notebook Workflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create
    Run Keyword    Navigate to Shared Adjustment Notebook Workflow    ${ARGUMENT_1}
    

    
