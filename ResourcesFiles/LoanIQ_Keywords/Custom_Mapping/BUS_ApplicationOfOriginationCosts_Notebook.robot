*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate to GL Entries_Upfront Fee payment
    [Documentation]    This keyword will be used to navigate to GL Entries from Upfront Fee payment from Borrower Window
    ...    @author: Archana 14Jul2020 - initial create
    Run Keyword    Navigate to GL Entries_Upfront Fee payment    
    
BUS_Close GL Entries_Upfront Fee payment Notebook
    [Documentation]    This keyword is used to close GL Entries Notebook
    ...    @author:Archana 14Jul2020 - initial create
    Run Keyword    Close GL Entries_Upfront Fee payment Notebook    
    
BUS_Navigate Notebook Workflow -Create Cashflow
    [Documentation]    This keyword is used to create cashflow in workflow
    ...    @author:Archana 14Jul2020 - initial create
    Run Keyword    Navigate Notebook Workflow -Create Cashflow    
    
BUS_Navigate to Pending Upfront Fee Payment Notebook
     [Documentation]    This keyword is used to Navigate to the Pending Transaction
    ...    @author: Archana 14Jul2020  -initial create 
    Run Keyword    Navigate to Pending Upfront Fee Payment Notebook    
    
BUS_Verification of Released Upfront Fee Payment Status
    [Documentation]    This keyword is used to verify the Released Upfront Fee Payment status
    ...    @author: Archana 14Jul2020 - initial create 
    Run Keyword    Verification of Released Upfront Fee Payment Status    
    
BUS_Navigate to Portfolio Positions Notebook
    [Documentation]    This keyword is used to navigate to Portfolio Positions
    ...    @author:Archana 14Jul2020 - initial create
    Run Keyword    Navigate to Portfolio Positions Notebook    
    
BUS_Select Portfolio Position
    [Documentation]    This keyword is used to select the Portfolio position
    ...    @author: Archana 14Jul2020 - initial create 
    Run Keyword    Select Portfolio Position    ${ARGUMENT_1}
    
BUS_Portfolio Settled Discount Change
    [Documentation]    This keyword is used to input details in Portfolio Settled Discount Chnage Window
    ...    @author: Archana 14Jul2020 - initial create
    Run Keyword    Portfolio Settled Discount Change    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_GLOffset Details
    [Documentation]    This keyword is used to input details to GLOffset details
    ...    @author: Archana 14Jul2020 - initial create
    Run Keyword    GLOffset Details    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Send to Approval Portfolio Selection Discount Change
    [Documentation]    This keyword sends the Portfolio Selection Discount Change to Approval. 
    ...    @author: Archana  14Jul2020  - initial create
    Run Keyword    Send to Approval Portfolio Selection Discount Change  
    
BUS_Approve Portfolio Selection Discount Change
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Portfolio Selection Discount Change.
    ...    @author: Archana 14Jul2020 - initial create  
    Run Keyword    Approve Portfolio Selection Discount Change    
    
BUS_Navigate to Pending Portfolio Selection Discount Change
    [Documentation]    This keyword is used to Navigate to Pending transaction is facility Notebook
    ...    @author: Archana 14Jul2020 - initial create
    Run Keyword    Navigate to Pending Portfolio Selection Discount Change    
    
BUS_Release Portfolio Selection Discount Change
    [Documentation]    This keyword navigates the 'Work In Process' window and release the Portfolio Selection Discount Change.
    ...    @author: Archana 14Jul2020  - initial create
    Run Keyword    Release Portfolio Selection Discount Change    
    
BUS_Verification of Portfolio Selection Discount Change
    [Documentation]    This keyword is used to verify the released status of Portfolio Selection Discount Change
    ...    @author:Archana 14Jul2020 - initial create
    Run Keyword    Verification of Portfolio Selection Discount Change 