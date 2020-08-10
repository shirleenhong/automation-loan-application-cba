*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
   
Open Existing Guarantee
    [Documentation]    This keyword is used to open the existing Guarantees
    ...    @author:Archana 12Jun2020
    ...            -Added Preprocessing keywords
    [Arguments]    ${sOutstandingSelect_Type}    ${sDeal_Name}    ${sFacility_Name}
    
    ###Pre-Processing Keyword###
    ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
   
    mx LoanIQ maximize   ${LIQ_Window}
    Select Actions    [Actions];Outstanding
    Mx LoanIQ Activate Window    ${LIQ_OutstandingSelect_Window}    
    Mx LoanIQ Enter    ${LIQ_OutstandingSelect_ExistingRadioButton}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Combobox}    ${OutstandingSelect_Type}
    Mx LoanIQ Click    ${LIQ_OustandingSelect_Deal_Button}
    mx LoanIQ enter    ${LIQ_DealSelect_DealIdentifyBy_Textfield}    ${Deal_Name}   
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Combo}    ${Facility_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect_Notebook     
    Mx LoanIQ Click    ${LIQ_OutstandingSelect_Search_Button}  
    
Select Standby Letters of Credit
    [Documentation]    This keyword is used to select the appropriate standby Letters of Credit
    ...    @author: Archana 16Jun2020
    ...           - Added Pre-processing Keywords
    [Arguments]    ${sAlias}   
    
    ###Pre-processing Keyword###
    ${Alias}    Acquire Argument Value    ${sAlias} 
       
    Mx LoanIQ Activate Window    ${LIQ_ExistingStandbyLettersOfCredit_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ExistingStandbyLettersofCredit_Javatree}    ${Alias}%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/StandByLOC  
    
Guaratee Draw
    [Documentation]    This keyword is used to select the Draw tab
    ...    @author:Archana  15Jun2020
    ...           - Added RuntimeVariable and post processing keyword
    [Arguments]    ${RuntimeVar_AvailabletoDraw}=None            
    Mx LoanIQ Activate Window    ${LIQ_BankGuarantee_Window}    
    Mx LoanIQ Select Window Tab    ${LIQ_BankGuarantee_Draw_Tab}    Draw
    Select Menu Item    ${LIQ_BankGuarantee_Window}    Options    Update
    ${AvailableToDraw}    Mx LoanIQ Get Data    ${LIQ_BankGuarantee_AvailableToDraw}    input=value
    Mx LoanIQ Click    ${LIQ_BankGuarantee_Create_Button}
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${Runtime_VarAvailabletoDraw}    ${AvailableToDraw}    
    [Return]    ${AvailableToDraw}    
    
Draw Against Bank Guarantee
    [Documentation]    This keyword is used to Draw the amount against Bank Guarantee
    ...    @author:Archana    15Jun2020
    ...           - Added Pre-processing Keywords and RuntimeVar
    [Arguments]    ${sCustomer}    ${sIssingBank}    ${RunTimeVar_DrawnAmount}=None
    
    ###Pre-processing Keyword###

    ${Customer}    Acquire Argument Value    ${sCustomer}
    ${IssingBank}    Acquire Argument Value    ${sIssingBank}
         
    Mx LoanIQ Activate Window    ${LIQ_DrawAgainstBankGuarantee_Window}
    ${DrawnAmount}    Mx LoanIQ Get Data    ${LIQ_DrawAgainstBankGuarantee_DrawnAmount}    input=value
    Mx LoanIQ Select String   ${LIQ_DrawAgainstBankGuarantee_Beneficiaries_Customer_Record_JavaTree}    ${Customer} 
    mx LoanIQ click element if present    ${LIQ_Warning_No_Button}              
    Mx LoanIQ Click    ${LIQ_DrawAgainstBankGuarantee_Delete_Button}    
    Mx LoanIQ Click    ${LIQ_DrawAgainstBankGuarantee_CreateFromIssuingBank_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Bank Guarantee
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}      
    Mx LoanIQ DoubleClick    ${LIQ_IssuingBank_Javatree}    ${IssingBank}    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ###Post-processing keyword###
    Save Values of Runtime Execution on Excel File    ${RunTimeVar_DrawnAmount}    ${DrawnAmount}
    [Return]    ${DrawnAmount}   

Navigate Notebook Workflow_GuaranteeDrawdown
    [Documentation]    This keyword navigates the Workflow tab of a Notebook, and does a specific transaction.
    ...    @author:Archana 16Jun2020 
    ...           - Added Pre-processing Keyword      
    [Arguments]    ${sLIQ_BankGuarantee_Payment_Window}    ${sLIQ_BankGuarantee_PaymentTab}    ${sLIQ_BankGuarantee_Workflow_JavaTree}    ${sTransaction}
    ###Pre-processing Keyword###
    ${LIQ_BankGuarantee_Payment_Window}    Acquire Argument Value    ${sLIQ_BankGuarantee_Payment_Window}
    ${LIQ_BankGuarantee_PaymentTab}    Acquire Argument Value    ${sLIQ_BankGuarantee_PaymentTab}
    ${LIQ_BankGuarantee_Workflow_JavaTree}    Acquire Argument Value    ${sLIQ_BankGuarantee_Workflow_JavaTree}
    ${Transaction}    Acquire Argument Value    ${sTransaction}       
    
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Payment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_BankGuarantee_PaymentTab}    Workflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_BankGuarantee_Workflow_JavaTree}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

Close Cashflows Window
    [Documentation]    This keyword is used to close Cashflow Window
    ...    author:Archana 17Jun2020
    Mx LoanIQ Click    ${LIQ_CashFlowForBankGuarantee_Ok_Button}    
              
Complete Workflow Items_GuaranteeDrawdown
    [Documentation]    This keyword will complete the initial work items in Guarantee Drawdpwn
    ...    @author: Archana 17Jun2020
    ...           - Added pre-processing keywords
    [Arguments]    ${sCustomer_Legal_Name}    ${sSBLC_Status}
    
    ###Pre-processing Keyword###
    ${Customer_Legal_Name}    Acquire Argument Value    ${sCustomer_Legal_Name}
    ${SBLC_Status}    Acquire Argument Value    ${sSBLC_Status}
        
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Payment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_BankGuarantee_PaymentTab}    Workflow
    mx LoanIQ click element if present    ${LIQ_SBLCIssuance_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Approvals
    Mx LoanIQ DoubleClick    ${LIQ_BankGuarantee_GenerateIntentNotices_ListItem}    Send to Approval                          
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    Log    Workflow Items are complete and ready for approval!    
    
Approve SBLC Guarantee Drawdown
    [Documentation]    This keyword will approve the Awaiting Approval - SBLC Guarantee Drawdown
    ...    @author: Archana 16Jun2020    
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Payment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_BankGuarantee_PaymentTab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_BankGuarantee_GenerateIntentNotices_ListItem}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Log    SBLC Guarantee is now approved  
    
Release SLBC GuaranteeDrawdown in Workflow
    [Documentation]    This keyword will release the SBLC Guarantee Drawdown in Workflow tab
    ...    @author: Archana 16Jun2020       
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Payment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_BankGuarantee_PaymentTab}    Workflow 
    Mx LoanIQ DoubleClick    ${LIQ_BankGuarantee_GenerateIntentNotices_ListItem}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}    
    Log    Guarantee Drawdown is complete
    :FOR    ${i}    IN RANGE    2
    \    ${Warning_Status}    Run Keyword And Return Status    Run Keyword And Ignore Error    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Window}    VerificationData="Yes"
    \    Exit For Loop If    ${Warning_Status}==False
    \    Run Keyword And Ignore Error    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_BankGuarantee_Payment_Released_Window}    VerificationData="Yes"
    Mx LoanIQ Select Window Tab    ${LIQ_BankGuarantee_PaymentTab}    Events
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_BankGuarantee_Events_Tree}    Released%yes        
    mx LoanIQ select    ${BankGuarantee_Payment_FileExit_Menu}    
    
Get UIValue On FacilityNotebook
    [Documentation]    This keyword is used to do fetch values of outstanding and Avial amount to draw
    ...    @author:Archana 16Jun2020
    ...    @update :Archana 22Jun2020 - Added post processing keyword and RuntimeVar
    [Arguments]    ${RuntimeVar_OustandingAmount}=None    ${RuntimeVar_AvailToDraw}=None            
    Mx LoanIQ Activate Window    ${LIQ_FacilityNotebook_Window}
    ${OustandingAmount}    Mx LoanIQ Get Data    ${LIQ_Facility_OustandingAmount}    input=value
    Log    ${OustandingAmount}        
    ${AvailToDraw}    Mx LoanIQ Get Data    ${LIQ_Facility_AvailToDraw}    input=value 
    Log    ${AvailToDraw}    
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FacilityNotebook
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    File    Exit
    
    ###Post-processing keyword###
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_OustandingAmount}    ${OustandingAmount}
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_AvailToDraw}    ${AvailToDraw}
    [Return]    ${OustandingAmount}    ${AvailToDraw}    
  
Get UIValue On FacilityNotebook_PostDrawdown
    [Documentation]    This keyword is used to do fetch values of outstanding and Avial amount to draw
    ...    @author:Archana 16Jun2020  
    ...    @update:Archana 22Jun2020 - Added post-processing keyword and RuntimeVar
    [Arguments]    ${RuntimeVar_Post_OustandingAmount}=None    ${RuntimeVar_Post_AvailToDraw}=None     
    Mx LoanIQ Activate Window    ${LIQ_FacilityNotebook_Window}              
    ${Post_OustandingAmount}    Mx LoanIQ Get Data    ${LIQ_Facility_OustandingAmount}    input=value
    Log    ${Post_OustandingAmount}    
    ${Post_AvailToDraw}    Mx LoanIQ Get Data    ${LIQ_Facility_AvailToDraw}    input=value 
    Log    ${Post_AvailToDraw}    
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    File    Exit
    
    ###Post-processing keyword###
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_Post_OustandingAmount}    ${Post_OustandingAmount}
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_Post_AvailToDraw}    ${Post_AvailToDraw}    
    [Return]    ${Post_OustandingAmount}    ${Post_AvailToDraw}
    
Validation on Facility Notebook  
    [Documentation]    This keyword is used to do validations of outstanding and Avial amount to draw
    ...    @author:Archana 22Jun2020
    [Arguments]    ${Oustanding_Amount}    ${AvailTo_Draw}    ${Post_OustandingAmount}    ${Post_AvailToDraw}    ${Drawn_Amount}    ${RuntimeVar_OutstandingAmt_ValidateStatus}=None    ${RuntimeVar_AvailToDrawAmt_ValidateStatus}=None  
     ${Oustanding_Amount}    Remove Comma, Negative Character and Convert to Number    ${Oustanding_Amount}
     ${AvailTo_Draw}    Remove Comma, Negative Character and Convert to Number    ${AvailTo_Draw}
     ${Drawn_Amount}     Remove Comma, Negative Character and Convert to Number    ${Drawn_Amount}
     ${Post_OustandingAmount}    Remove Comma, Negative Character and Convert to Number    ${Post_OustandingAmount}
     ${Computed_OutstandingAmt}    Evaluate    ${Drawn_Amount}-${Oustanding_Amount}
     ${Computed_AvailToDraw}    Evaluate    ${AvailTo_Draw}+${Drawn_Amount}     
     ${Computed_OutstandingAmt}    Convert To String    ${Computed_OutstandingAmt}
     ${Computed_OutstandingAmt}    Remove Comma, Negative Character and Convert to Number    ${Computed_OutstandingAmt}    
     ${Computed_AvailToDraw}    Convert To String    ${Computed_AvailToDraw}
     ${Computed_AvailToDraw}    Convert Number With Comma Separators    ${Computed_AvailToDraw}
     ${OutstandingAmt_ValidateStatus}    Set Variable If    '${Post_OustandingAmount}'=='${Computed_OutstandingAmt}'    True
     ${AvailToDrawAmt_ValidateStatus}    Set Variable If    '${Post_AvailToDraw}'=='${Computed_AvailToDraw}'    True
     
    ###Post-processing keyword###
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_OutstandingAmt_ValidateStatus}    ${Post_OustandingAmount}
    Save Values of Runtime Execution on Excel File    ${RuntimeVar_OutstandingAmt_ValidateStatus}    ${Post_AvailToDraw}
    [Return]    ${OutstandingAmt_ValidateStatus}    ${AvailToDrawAmt_ValidateStatus}                           