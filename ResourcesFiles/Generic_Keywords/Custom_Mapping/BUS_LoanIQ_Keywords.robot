*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***

BUS_Login To Loan IQ
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    08APR2020    - initial create

    Run Keyword    Login to Loan IQ    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Logout from Loan IQ
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    08APR2020    - initial create

    Run Keyword    Logout from Loan IQ

BUS_Open Existing Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    08APR2020    - initial create

    Run Keyword    Open Existing Deal    ${ARGUMENT_1}

BUS_Close All Windows on LIQ
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Close All Windows on LIQ

BUS_Select Item in Work in Process
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    23APR2020    - initial create

    Run Keyword    Select Item in Work in Process    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Search Existing Deal
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create
 
    Run Keyword    Search Existing Deal    ${ARGUMENT_1}
    
BUS_Navigate Notebook Workflow
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    11MAY2020    - initial create

    Run Keyword    Navigate Notebook Workflow    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Save Notebook Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    14MAY2020    - initial create

    Run Keyword    Save Notebook Transaction    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Verify If Warning Is Displayed
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    22MAY2020    - initial create

    Run Keyword    Verify If Warning Is Displayed
    
BUS_Search for Existing Outstanding
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    04JUN2020    - initial create

    Run Keyword    Search for Existing Outstanding    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Open Existing Loan
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: fmamaril    04JUN2020    - initial create

    Run Keyword    Open Existing Loan    ${ARGUMENT_1}    ${ARGUMENT_2} 
BUS_Validate and Update Branch and Processing Area in MIS Codes Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    02JUN2020    - initial create

    Run Keyword    Validate and Update Branch and Processing Area in MIS Codes Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Update Branch and Processing Area
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    02JUN2020    - initial create

    Run Keyword    Update Branch and Processing Area    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Validate Branch and Processing Area in MIS Codes Tab
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    02JUN2020    - initial create

    Run Keyword    Validate Branch and Processing Area in MIS Codes Tab    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Delete Existing Holiday on Calendar Table
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: dahijara    02JUN2020    - initial create

    Run Keyword    Delete Existing Holiday on Calendar Table

BUS_Get Method Description from Borrower
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    23JUL2020    - initial create

    Run Keyword    Get Method Description from Borrower    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Navigate to Payment Notebook via WIP
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    23JUL2020    - initial create

    Run Keyword    Navigate to Payment Notebook via WIP    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Open Facility Notebook
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: clanding    11AUG2020    - initial create

    Run Keyword    Open Facility Notebook    ${ARGUMENT_1}