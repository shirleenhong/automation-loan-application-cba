*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Add Facility Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create

    Run Keyword    Add Facility Change Transaction

BUS_Modify Maturity Date in Facility Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create

    Run Keyword    Modify Maturity Date in Facility Change Transaction    ${ARGUMENT_1}

BUS_Send to Approval Facility Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create

    Run Keyword    Send to Approval Facility Change Transaction

BUS_Approve Facility Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create

    Run Keyword    Approve Facility Change Transaction    ${ARGUMENT_1}

BUS_Release Facility Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create

    Run Keyword    Release Facility Change Transaction    ${ARGUMENT_1}

BUS_Validate Facility Change Transaction
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: amansuet    22JUN2020    - initial create

    Run Keyword    Validate Facility Change Transaction    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

US_Add Borrowing Base Deatils
    [Documentation]    This keyword is used to add Borrowing base details
    ...    @author:Archana 19Jun2020 - initial create
    Run Keyword    Add Borrowing Base Deatils    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}
    
BUS_Verification of Borrower Base Created in Facility Change Transaction
    [Documentation]    This keyword is used to verify the Borrower Base created
    ...  @author:Archana 19Jun2020 - initial create
    Run Keyword    Verification of Borrower Base Created in Facility Change Transaction    ${ARGUMENT_1}     
    
BUS_Add Facility Borrower Base in Facility Change Transaction
    [Documentation]    This keyword updates the  Borrowing base of the Facility
    ...    @author: Archana 22Jun2020 - initial create
    Run Keyword    Add Facility Borrower Base in Facility Change Transaction    

BUS_Approve Borrower BaseCreation 
    [Documentation]    This keyword will approve the Awaiting Approval - Borrower Base Creation
    ...    @author: Archana 22Jun2020 - initial create
    Run Keyword    Approve Borrower BaseCreation    
    
BUS_Release Borrower BaseCreation in Workflow
    [Documentation]    This keyword is used to release a transaction-Borrower base Creation
    ...    @author:Archana 22Jun2020 - initial create
    Run Keyword    Release Borrower BaseCreation in Workflow
    
BUS_Update Expiry and Maturity Date in Facility Change Transaction
    [Documentation]    This keyword is used to release a transaction-Borrower base Creation
    ...    @author:dfajardo     22JUL2020     - initial create
    Run Keyword    Update Expiry and Maturity Date in Facility Change Transaction
    
BUS_Update Terminate Date in Facility Change Transaction  
    [Documentation]    This keyword is used to release a transaction-Borrower base Creation
    ...    @author:dfajardo     22JUL2020     - initial create
    Run Keyword    Update Terminate Date in Facility Change Transaction  
     