*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 

Navigate to Business Event Output Window
    [Documentation]    This keyword navigates to Business Event Output Window thru Events Management -Queue option.
    ...    @author:mgaling
    
    mx LoanIQ activate window    ${LIQ_Activate_LIQWindow}     
    mx LoanIQ select    ${LIQ_OptionsEventsManagementQueue_Menu}
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    
Validate Statuses Section
    [Documentation]    This keyword selects all checkbox under Statuses Section.
    ...    @author:mgaling
    
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    mx LoanIQ click    ${LIQ_BusinessEventOutput_SelectAll_Button}
    
    ###Validation on Checkbox under Statuses Section### 
    Mx LoanIQ Verify Runtime Property    ${LIQ_BusinessEventOutput_Completed_CheckBox}    value%1
    Mx LoanIQ Verify Runtime Property    ${LIQ_BusinessEventOutput_Balance_CheckBox}    value%1
    Mx LoanIQ Verify Runtime Property    ${LIQ_BusinessEventOutput_Pending_CheckBox}    value%1
    Mx LoanIQ Verify Runtime Property    ${LIQ_BusinessEventOutput_PendingBalance_CheckBox}    value%1
    Mx LoanIQ Verify Runtime Property    ${LIQ_BusinessEventOutput_Error_CheckBox}    value%1
    Mx LoanIQ Verify Runtime Property    ${LIQ_BusinessEventOutput_Inactive_CheckBox}    value%1
    Mx LoanIQ Verify Runtime Property    ${LIQ_BusinessEventOutput_Confirmed_CheckBox}    value%1
    Mx LoanIQ Verify Runtime Property    ${LIQ_BusinessEventOutput_Delivered_CheckBox}    value%1
    Mx LoanIQ Verify Runtime Property    ${LIQ_BusinessEventOutput_Failed_CheckBox}    value%1

Populate Filter Section
    [Documentation]    This keyword populate the fields under the Filter Section in Business Event Output Window.
    ...    @author:mgaling
    ...    @update:jaquitan 20Mar2019 updated arguments
    [Arguments]    ${sBEO_StartDate}    ${sBEO_EndDate}    ${sCustomer_IdentifiedBy}    ${sNotice_Customer_LegalName}         
    
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    mx LoanIQ enter    ${LIQ_BusinessEventOutput_StartDate_Field}    ${sBEO_StartDate} 
    mx LoanIQ enter    ${LIQ_BusinessEventOutput_EndDate_Field}    ${sBEO_EndDate}
    mx LoanIQ click    ${LIQ_BusinessEventOutput_LookUp_Button}
    mx LoanIQ select    ${LIQ_BusinessEventOutput_LookUp_LookUp_Menu}    Customer
      
    ###Customer Select Window##
    mx LoanIQ activate window    ${LIQ_CustomerSelect_Window}
    mx LoanIQ select list    ${LIQ_CustomerSelect_Search_Filter}    ${sCustomer_IdentifiedBy}
    mx LoanIQ enter    ${LIQ_CustomerSelect_Search_Inputfield}    ${sNotice_Customer_LegalName}       
    mx LoanIQ click    ${LIQ_CustomerSelect_OK_Button}  

Validate Event Output Record
    [Documentation]    This keyword validates the Notice ID Status under Eevent Output Records Section.
    ...    @author:mgaling
    ...    @update:jaquitan     01April2019     changed java tree select , reason: not scrolling to the correct data using {ENTER} native type 
    ...    when records are more than the screen capacity
    [Arguments]    ${sNotice_Identifier}    
    
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    mx LoanIQ click    ${LIQ_BusinessEventOutput_Refresh_Button} 
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    mx LoanIQ maximize    ${LIQ_BusinessEventOutput_Window}    
    
    Mx LoanIQ Verify Object Exist    ${LIQ_BusinessEventOutput_Records}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Click Javatree Cell    ${LIQ_BusinessEventOutput_Records}    ${sNotice_Identifier}%${sNotice_Identifier}%Owner ID    
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Click Javatree Cell    ${LIQ_BusinessEventOutput_Records}    ${sNotice_Identifier}%${sNotice_Identifier}%Owner ID        
    Run Keyword If    ${Status}==True    Log    ${sNotice_Identifier} is available
    ...    ELSE    Fail    ${sNotice_Identifier} is not available
    Mx Native Type    {ENTER}
    
    mx LoanIQ activate window    ${LIQ_EventOutputRecord_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_EventOutputRecord_Status_Link}    value%Delivered    
    
    Take Screenshot    Correspondence_Notice_Delivered
   
    mx LoanIQ close window    ${LIQ_BusinessEventOutput_Window}
    
Validate Resent Notice Event Output Record
    [Documentation]    This keyword validates the Resent Notice ID Status under Event Output Records Section.
    ...    @author:cfrancis
    [Arguments]    ${Notice_Identifier}    
    
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    mx LoanIQ click    ${LIQ_BusinessEventOutput_Refresh_Button} 
    Sleep    10s   
    mx LoanIQ activate window    ${LIQ_BusinessEventOutput_Window}
    mx LoanIQ maximize    ${LIQ_BusinessEventOutput_Window}    
    
    Mx LoanIQ Verify Object Exist    ${LIQ_BusinessEventOutput_Records}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Click Javatree Cell    ${LIQ_BusinessEventOutput_Records}    ${Notice_Identifier}%${Notice_Identifier}%Owner ID
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Click Javatree Cell    ${LIQ_BusinessEventOutput_Records}    ${Notice_Identifier}%${Notice_Identifier}%Owner ID
    Run Keyword If    ${Status}==True    Mx Native Type    {DOWN}     
    
    Run Keyword If    ${Status}==True    Mx Native Type    {ENTER}    
    ...    ELSE    Fail    ${Notice_Identifier} is not available
    
    mx LoanIQ activate window    ${LIQ_EventOutputRecord_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_EventOutputRecord_Status_Link}    value%Delivered
    
    mx LoanIQ close window    ${LIQ_BusinessEventOutput_Window} 

Get Field Value from XML Section
    [Documentation]    This Keyword gets the Correlation ID under XML Section in Event Output Record.
    ...    @author:mgaling
    ...    @update:jaquitan 20Mar2019 updated arguments
    [Arguments]    ${sFile_Path}    ${sTemp_Path}    ${sField_Name}   
    
    Delete File If Exist    ${sFile_Path} 
    mx LoanIQ activate window    ${LIQ_EventOutputRecord_Window}
    Mx Select All Data And Save To Notepad    ${LIQ_EventOutputRecord_XML_Section}    ${sFile_Path}
       
    ${Data}    Get Element Text    ${sFile_Path}
    ${List}    Split String    ${Data}    "array"
    ${Value_0}    Get From List    ${List}    0
    ${JSON}    Catenate    SEPARATOR=    ${Value_0}    }}}}
    Delete File If Exist    ${sTemp_Path}
    Create File    ${sTemp_Path}    ${JSON}      
    ${json_object}    Load JSON From File    ${sTemp_Path}
    ${Field_Value}    Get Value From Json    ${json_object}    $..${sField_Name} 
    ${Field_Value}    Get From List  ${Field_Value}    0 
    [Return]    ${Field_Value} 
    mx LoanIQ close window    ${LIQ_EventOutputRecord_Window}              
