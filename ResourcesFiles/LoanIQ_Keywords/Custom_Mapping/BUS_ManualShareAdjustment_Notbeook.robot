*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Launch Loan Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: hstone    29APR2020    - initial create

    Run Keyword   Launch Loan Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Launch Manual Share Adjustment Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create

    Run Keyword   Launch Manual Share Adjustment Notebook    ${ARGUMENT_1}
    
BUS_Populate General Tab in Manual Share Adjustment
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create

    Run Keyword   Populate General Tab in Manual Share Adjustment    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Update Host Bank Lender Share
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create

    Run Keyword   Update Host Bank Lender Share    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Verify the New Balance in Servicing Group Share Window
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create
    ...    @update: dahijara    19AUG2020    - Added argument

    Run Keyword   Verify the New Balance in Servicing Group Share Window    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Update Host Bank Share Value - Host bank shares section
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create
    ...    @update: dahijara    19AUG2020    - Removed 1 argument.

    Run Keyword   Update Host Bank Share Value - Host bank shares section    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Verify the New Balance for Host Bank Share Value - Host bank shares section
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create

    Run Keyword   Verify the New Balance for Host Bank Share Value - Host bank shares section    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Update NonHost Bank Lender Share
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create

    Run Keyword   Update NonHost Bank Lender Share    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Verify the New Balance for NonHost Bank Share
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create
    ...    @update: dahijara    19AUG2020    - added 2 arguments

    Run Keyword   Verify the New Balance for NonHost Bank Share    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Adjustment Send to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create

    Run Keyword   Adjustment Send to Approval
    
BUS_Adjustment Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create

    Run Keyword   Adjustment Approval    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Adjustment Release
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create

    Run Keyword   Adjustment Release    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Navigate to Manual Share Adjustment Notebook Workflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    01JUL2020    - initial create

    Run Keyword   Navigate to Manual Share Adjustment Notebook Workflow    ${ARGUMENT_1}

    

    
