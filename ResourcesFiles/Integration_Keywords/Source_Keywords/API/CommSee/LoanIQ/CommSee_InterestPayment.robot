*** Settings ***
Resource     ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
    
Generate Intent Notices of an Interest Payment-CommSee
    [Documentation]    This keyword generates Intent Notices of an Interest Payment
    ...    @author: ghabal    
    [Arguments]    ${LIQCustomer_ShortName}    

    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow
    Mx LoanIQ Verify Text In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%yes    
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}    
        
    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
      
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
     
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    ${NoticeStatus}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Notice_Information_Table}    ${LIQCustomer_ShortName}%Status%test    
    Log    ${NoticeStatus}
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_Notice_Information_Table}    ${LIQCustomer_ShortName}%s 
    
    # mx LoanIQ click    ${LIQ_Notice_EditHighlightedNotice_Button}
    # mx LoanIQ activate window    ${LIQ_Notice_IntentNotice_Window}   
    # ${ContactEmail}    Mx LoanIQ Get Data    ${LIQ_Notice_IntentNotice_Email}    value%test
    # Log    ${ContactEmail}
    # Should Be Equal    ${Contact_Email}    ${ContactEmail}          
    # mx LoanIQ activate window    ${LIQ_Notice_IntentNotice_Window}
    
    # ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=Interest Payment Notice created.*","displayed:=1").JavaEdit("text:=${Lender_LegalName}")    Verified_Customer    
    # Should Be Equal As Strings    ${Lender_LegalName}    ${Verified_Customer}
    # Log    ${Verified_Customer}    
    # ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=Interest Payment Notice created.*","displayed:=1").JavaObject("tagname:=Group","text:=Status").JavaStaticText("text:=${InterestPaymentNotice_Status}")    Verified_Status    
    # Should Be Equal As Strings    ${InterestPaymentNotice_Status}    ${Verified_Status}
    # Log    ${Verified_Status} - Status is correct!
        
    # mx LoanIQ select    ${LIQ_InterestPayment_Notice_FileMenu_PreviewMenu}
    # Sleep    3s        
    # Take Screenshot
    # Sleep    3s
    # mx LoanIQ select    ${LIQ_SBLC_NoticePreview_FileMenu_ExitMenu}
        
    # mx LoanIQ close window    ${LIQ_InterestPayment_Notice_Email_Window}
    mx LoanIQ click    ${LIQ_InterestPayment_Notice_Exit_Button}

Release Interest Payment
    [Documentation]    This keyword will release the Loan Drawdown
    ...    @author: ritragel
    ...    @update: ritragel    06MAR19    Added handling of closing Cashflows window
    mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}   
    mx LoanIQ activate    ${LIQ_Payment_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_Payment_Tab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_Payment_WorkflowItems}    Complete Cashflows 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 