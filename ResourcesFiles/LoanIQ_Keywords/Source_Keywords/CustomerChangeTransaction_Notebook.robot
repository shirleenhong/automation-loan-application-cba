*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate to "Profiles" Tab
    [Documentation]    This keyword navigates user to "Profiles" tab
    ...    @author: Archana  24JUN2020
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    Profiles
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Profiles
    
Add Contacts in Customer
    [Documentation]    This keyword is used to amend the contacts
    ...    @author:Archana 24JUN2020
    ...           - Added pre-processing keyword
    [Arguments]    ${sBorrower}
     
    ###Pre-processing keyword###
    ${Borrower}    Acquire Argument Value    ${sBorrower}
           
    Mx LoanIQ Activate    ${LIQ_ActiveCustomer_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Customer_SelectBorrower_JavaTree}    ${Borrower}%s 
    Mx LoanIQ Click    ${LIQ_ActiveCustomer_Contacts_Button}    
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    
Add ContactList
    [Documentation]    This keyword is used to add ContactList
    ...    @author: Archana 24JUN2020
    ...           - Added pre-processing keyword
    [Arguments]    ${sShort_Name} 
    
    ###Pre-processing keyword###
    ${Short_Name}    Acquire Argument Value    ${sShort_Name}
        
    Mx LoanIQ Activate Window    ${LIQ_ContactList_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SelectName_JavaTree}    ${Short_Name}%d
    
ContactDetails
    [Documentation]    This keyword is used to amend contact details
    ...    @author:Archana  24JUN2020
    ...           - Added pre-processing keyword
    [Arguments]    ${sNick_Name} 
    
    ###pre-processing keyword###
    ${Nick_Name}    Acquire Argument Value    ${sNick_Name}
          
    Mx LoanIQ Activate Window    ${LIQ_ContactDetails_Window}    
    mx LoanIQ click element if present    ${LIQ_ContactDetails_Notebook_UpdateMode}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Select Menu Item    ${LIQ_ContactDetails_Window}    Options    Contact Change Transaction
    
Amend Contact Details
    [Documentation]    This keyword is used to amend contact details
    ...    @author:Archana  24JUN2020
    [Arguments]    ${sNickname}  
    
    ###Pre-processing keyword###
    ${Nickname}    Acquire Argument Value    ${sNickname}      
    Mx LoanIQ Activate    ${LIQ_ContactChangeTransactionApproval_Window}    
    Mx LoanIQ Click Javatree Cell    ${LIQ_SelectBorrower_JavaTree}    Nickname%JohnXX%New Value(s)
    Sleep    1s    
    Mx LoanIQ Send Keys    ${Nickname}
    Mx Press Combination    KEY.ENTER                
    
ChangeContactTransaction_Send to Approval
    [Documentation]    This keyword will complete the initial work items in Contact change Transaction
    ...    @author:Archana 24JUN2020     
    Mx LoanIQ Activate    ${LIQ_ContactChangeTransactionApproval_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ContactChangeTransaction_Workflow_Tab}    Workflow
    mx LoanIQ click element if present    ${LIQ_ContactChangeTransaction_Warning_Yes_Button}
    Mx LoanIQ DoubleClick    ${LIQ_ContactChangeTransaction_ListItem}    Send to Approval                          
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    Log    Workflow Items are complete and ready for approval! 
    
Approve Contact Change Transaction
    [Documentation]    This keyword will approve the Awaiting Approval - Contact Change Transaction
    ...    @author: archana 24JUN2020   
    mx LoanIQ activate window    ${LIQ_ContactChangeTransactionApproval_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ContactChangeTransaction_Workflow_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_ContactChangeTransaction_ListItem}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Log    Contact Change Transaction is now approved
    
Release Contact Change Transaction in Workflow
    [Documentation]    This keyword will release the Contact Change Transaction in Workflow tab
    ...    @author: Archana  24JUN2020   
    mx LoanIQ activate window    ${LIQ_ContactChangeTransactionApproval_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ContactChangeTransaction_Workflow_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_ContactChangeTransaction_ListItem}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}    
    Log    Contact Change Transaction is complete
    
GetUIValue of ContactDetails
    [Documentation]    This keyword is used to fetch the new amended values
    ...    @author:Archana 30JUL2020
    [Arguments]    ${RuntimrVar_Old_value}=None    ${RuntimeVar_New_value}=None   
    mx LoanIQ activate window    ${LIQ_ContactChangeTransactionApproval_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ContactChangeTransaction_Workflow_Tab}    General    
    ${Old_value}    Mx LoanIQ Store RunTime Value By Colname    ${LIQ_AmendedValue_JavaTree}    Nickname%Old Value(s)%varf
    ${New_value}    Mx LoanIQ Store RunTime Value By Colname    ${LIQ_AmendedValue_JavaTree}    Nickname%New Value(s)%NewValue
    
    ###Post-Processing Keyword###
    Save Values of Runtime Execution on Excel File    ${RuntimrVar_Old_value}    ${Old_value}
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_New_value}    ${New_value}
    [Return]    ${Old_value}    ${New_value}   

Validation of Amended ContactDetails
    [Documentation]    This keyword is used to validate the amended contact details
    ...    @author:Archana  24JUN2020
    [Arguments]    ${sNew_value}    ${sNickname}
    
    ###Pre-processing keyword###
    ${New_value}    Acquire Argument Value    ${sNew_value}
    ${Nickname}    Acquire Argument Value    ${sNickname}    
      
    Should Be Equal    ${New_value}    ${Nickname}    