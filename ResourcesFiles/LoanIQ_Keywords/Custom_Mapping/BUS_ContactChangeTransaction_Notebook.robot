*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate to "Profiles" Tab
    [Documentation]    This keyword navigates user to "Profiles" tab
    ...    @author: Archana  25JUN2020 - initial create
    Run Keyword    Navigate to "Profiles" Tab        

BUS_Add Contacts in Customer
    [Documentation]    This keyword is used to amend the contacts
    ...    @author:Archana 25JUN2020 - initial create
    Run Keyword    Add Contacts in Customer    ${ARGUMENT_1}
    
BUS_Add ContactList
    [Documentation]    This keyword is used to add ContactList
    ...    @author: Archana 25JUN2020 - initial create
    Run Keyword    Add ContactList    ${ARGUMENT_1}
    
BUS_ContactDetails
    [Documentation]    This keyword is used to amend contact details
    ...    @author:Archana  25JUN2020 - initial create
    Run Keyword    ContactDetails    ${ARGUMENT_1}
    
BUS_Amend Contact Details
    [Documentation]    This keyword is used to amend contact details
    ...    @author:Archana  24JUN2020 - initial create
    Run Keyword    Amend Contact Details    ${ARGUMENT_1}
    
BUS_ChangeContactTransaction_Send to Approval
    [Documentation]    This keyword will complete the initial work items in Contact change Transaction
    ...    @author:Archana 25JUN2020 - initial create
    Run Keyword    ChangeContactTransaction_Send to Approval
    
BUS_Approve Contact Change Transaction
    [Documentation]    This keyword will approve the Awaiting Approval - Contact Change Transaction
    ...    @author: archana 25JUN2020  - initial create
    Run Keyword    Approve Contact Change Transaction    
    
BUS_Release Contact Change Transaction in Workflow
    [Documentation]    This keyword will release the Contact Change Transaction in Workflow tab
    ...    @author: Archana  25JUN2020 - initial create
    Run Keyword    Release Contact Change Transaction in Workflow    
    
BUS_GetUIValue of ContactDetails
    [Documentation]    This keyword is used to fetch the new amended values
    ...    @author:Archana 30JUL2020   
    Run Keyword    GetUIValue of ContactDetails    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Validation of Amended ContactDetails
    [Documentation]    This keyword is used to validate the amended contact details
    ...    @author:Archana  25JUN2020 - initial create 
    Run Keyword    Validation of Amended ContactDetails    ${ARGUMENT_1}    ${ARGUMENT_2}        