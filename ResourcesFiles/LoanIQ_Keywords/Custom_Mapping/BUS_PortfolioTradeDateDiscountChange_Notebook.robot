*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Select Portfolio Position and Make Adjustment
    [Documentation]    This keyword is used to select the Portfolio position and make adjustment
    ...    @author: Archana 23JUL2020 - initial create
    Run Keyword    Select Portfolio Position and Make Adjustment    ${ARGUMENT_1}
    
BUS_Portfolio Trade Date Discount Change Details
    [Documentation]    This keyword is used to input details in Portfolio Trade Date Discount Chnage Window
    ...    @author: Archana 23JUL2020 - initial create
    Run Keyword    Portfolio Trade Date Discount Change Details    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Send to Approval Portfolio Trade Date Discount Change
    [Documentation]    This keyword sends the Portfolio Trade Date Discount Change to Approval. 
    ...    @author: Archana  23JUL2020 - initial create
    Run Keyword    Send to Approval Portfolio Trade Date Discount Change    
    
BUS_Approve Portfolio Trade Date Discount Change
    [Documentation]    This keyword navigates the 'Work In Process' window and approves the Portfolio Trade Date Discount Change.
    ...    @author: Archana 23JUL2020 - initial create
    Run Keyword    Approve Portfolio Trade Date Discount Change    
    
BUS_Navigate to Pending Portfolio Trade Date Discount Change
     [Documentation]    This keyword is used to Navigate to the Pending Transaction
    ...    @author: Archana 23JUL2020 - initial create
    Run Keyword    Navigate to Pending Portfolio Trade Date Discount Change
    
BUS_Release Portfolio Trade Date Discount Change
    [Documentation]    This keyword navigates the 'Work In Process' window and release the Portfolio Trade Date Discount Change.
    ...    @author: Archana 23JUL2020 - initial create
    Run Keyword    Release Portfolio Trade Date Discount Change    
    
BUS_Validate Events Tab for Portfolio Trade Date Discount Change
    [Documentation]    This  keyword will validate Portfolio Trade Date Discount Change Events in the Events tab
    ...    @author: Archana 23JUL2020 - initial create
    Run Keyword    Validate Events Tab for Portfolio Trade Date Discount Change    
    
BUS_Validation of Adjusted Amount
    [Documentation]    This keyword is used to validate the new adjusted Amount
    ...    @author :Archana  23JUL2020 - initial create
    Run Keyword    Validation of Adjusted Amount    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}   