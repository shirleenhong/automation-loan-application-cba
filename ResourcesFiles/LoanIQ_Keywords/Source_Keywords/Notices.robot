*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Navigate to Notice Select Window
    [Documentation]    This keyword navigate to Notice Select Window.
    ...    @author:mgaling
    
    Select Actions    [Actions];Notices
    mx LoanIQ activate window    ${LIQ_NoticeSelect_Window}

Search Existing Notice
    [Documentation]    This keyword is to search an Existing Notice.
    ...    @author:mgaling
    ...    @upudate: jaquitan 20Mar2019 updated arguments
    [Arguments]    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}            
    
    mx LoanIQ activate window    ${LIQ_NoticeSelect_Window}
    Mx LoanIQ Set    ${LIQ_NoticeSelect_Existing_RadioButton}    ON 
    mx LoanIQ select list    ${LIQ_NoticeSelect_SelectBy_List}    ${sSearch_By}
    mx LoanIQ enter    ${LIQ_NoticeSelect_NoticeIdentifier_Field}    ${sNotice_Identifier}
    mx LoanIQ click    ${LIQ_NoticeSelect_Search_Button} 
    
    ###Notice Select Message###
    mx LoanIQ activate window    ${LIQ_NoticeSelectMessage_Window}
    mx LoanIQ enter    ${LIQ_NoticeSelectMessage_FromDate_Field}    ${sFrom_Date}
    mx LoanIQ enter    ${LIQ_NoticeSelectMessage_ThruDate_Field}    ${sThru_Date}                       
    mx LoanIQ click    ${LIQ_NoticeSelectMessage_OK_Button} 
    
    ###Notice Listing Window###
    mx LoanIQ activate window    ${LIQ_NoticeListing_Window}
    Mx LoanIQ Set    ${LIQ_NoticeListing_RemainOpenAfterSelection_CheckBox}    ON
    mx LoanIQ enter    ${LIQ_NoticeListing_Search_Field}    ${sNotice_Identifier}
    mx LoanIQ click    ${LIQ_NoticeListing_OK_Button}
    
    ###Setting Notice Window###
    mx LoanIQ activate window    ${LIQ_Notice_Window}    
 
Validate and Save Notice
    [Documentation]    This keyword is for validating and saving the Rate Setting Notice.
    ...    @author:mgaling
    ...    @update:jaquitan 20Mar2019 updated arguments
    [Arguments]    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sNotice_Identifier}      
    
    ###Rate Setting Notice Window###
    mx LoanIQ activate window    ${LIQ_Notice_Window}
     
    Validate Loan IQ Details    ${sNotice_Customer_LegalName}    ${LIQ_Notice_Customer_Field} 
    mx LoanIQ select list    ${LIQ_Notice_NoticeMethod_List}    ${sNotice_Method} 
    Validate Loan IQ Details    ${sNotice_Identifier}    ${LIQ_Notice_NoticeID_Field}
    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%Awaiting release       
    # Mx Select    ${LIQ_Notice_FileSave_Menu}
    
    mx LoanIQ select    ${LIQ_Notice_OptionsSend_Menu}
    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%Queued
    
    Take Screenshot    Correspondence_Notice_AwaitingRelease
       
    Close All Windows on LIQ

Validate and Send Notice
    [Documentation]    This keyword is for sending the Rate Setting Notice.
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: jaquitan    20Mar2019    - updated arguments
    ...    @update: jdelacru    09JAN2019    - deleted selection of notice method
    ...    @update: jloretiz    14JUL2019    - updated screenshot location
    [Arguments]    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sNotice_Identifier}  

    mx LoanIQ activate window    ${LIQ_Notice_Window}
     
    Validate Loan IQ Details    ${sNotice_Customer_LegalName}    ${LIQ_Notice_Customer_Field} 
    Validate Loan IQ Details    ${sNotice_Identifier}    ${LIQ_Notice_NoticeID_Field}
    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%Awaiting release       
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Notice_AwaitingRelease
    
    mx LoanIQ select    ${LIQ_Notice_OptionsSend_Menu}
    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%Queued
    
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Notice_Queued
    
    Close All Windows on LIQ
    
Validate and Resend Notice
    [Documentation]    This keyword is for validating and resending a Sent Rate Setting Notice.
    ...    @author:cfrancis
    [Arguments]    ${Notice_Customer_LegalName}    ${Notice_Method}    ${Notice_Identifier}    ${Status}  
    
    ###Rate Setting Notice Window###
    mx LoanIQ activate window    ${LIQ_Notice_Window}
     
    Validate Loan IQ Details    ${Notice_Customer_LegalName}    ${LIQ_Notice_Customer_Field} 
    Validate Loan IQ Details    ${Notice_Method}    ${LIQ_Notice_NoticeMethod_List}
    Validate Loan IQ Details    ${Notice_Identifier}    ${LIQ_Notice_NoticeID_Field}
    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%${Status}
    Run Keyword If    '${Status}'=='Sent'    mx LoanIQ select    ${LIQ_Notice_OptionsEnableForResend_Menu}
    mx LoanIQ select    ${LIQ_Notice_OptionsSend_Menu}
    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%Queued
    Close All Windows on LIQ  
          
Search Notice via WIP
    [Documentation]    This keyword is for launching notice window via WIP.
    ...    @author:mgaling
    [Arguments]    ${TransactionStatus}    ${Notice_Identifier}    ${Notice_Status}    
          
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    Notices
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_NoticeTransactionStatus_List}    ${TransactionStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_NoticeTransactionStatus_List}    ${TransactionStatus}
    
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}
        
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_NoticeTransactionStatus_List}    ${Notice_Identifier}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_NoticeTransactionStatus_List}    ${Notice_Identifier} 
    
    Sleep    5s  
    
    ###Rate Setting Notice Window Validation###
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    Validate Loan IQ Details    ${Notice_Identifier}    ${LIQ_Notice_NoticeID_Field}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%${Notice_Status}    
    
Validate WIP Exception Queue Negative
    [Documentation]    This keyword is used to validate that the unsuccessful call back will be logged under WIP>Queries>Exception Queue
    ...    @author:chanario
    [Arguments]    ${Expected_Description}    ${DealName}    ${NoticeID}
              
    mx LoanIQ activate    ${LIQ_Activate_LIQWindow}    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}
    mx LoanIQ select    ${LIQ_WorkInProgress_Queries_ExceptionQueue}
    mx LoanIQ activate    ${LIQ_WorkInProgress_ExceptionQueue_Window}
    Sleep    5m
    mx LoanIQ click    ${LIQ_WorkInProgress_ExceptionQueue_RefreshButton}
    Wait Until Keyword Succeeds    9    3s    Mx LoanIQ Click Javatree Cell    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    ${DealName}%Transaction${SPACE}ID%${NoticeID}
    
    Log    Expected NoticeID = ${NoticeID}
    ${Actual_NoticeID}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}   ${NoticeID}%Transaction${SPACE}ID%NoticeID
    Log    Actual NoticeID = ${Actual_NoticeID}
    Should Be Equal    ${Actual_NoticeID}    ${NoticeID}
    
    ${Actual_Description}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    ${NoticeID}%Description%Actual_Description    
    Log    Expected Description = ${Expected_Description}
    Log    Actual Description = ${Actual_Description}           
    Should Be Equal    ${Actual_Description}    ${Expected_Description}
    
    Take Screenshot    Correspondence_Notice_ExceptionQueue

    mx LoanIQ activate    ${LIQ_WorkInProgress_ExceptionQueue_Window}
    mx LoanIQ close window    ${LIQ_WorkInProgress_ExceptionQueue_Window} 
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window}
    
Validate WIP Exception Queue Positive
    [Documentation]    This keyword is used to validate that successful call back will not be logged under WIP>Queries>Exception Queue
    ...    @author:cfrancis
    [Arguments]    ${DealName}    ${NoticeID}
              
    mx LoanIQ activate    ${LIQ_Activate_LIQWindow}    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}
    mx LoanIQ select    ${LIQ_WorkInProgress_Queries_ExceptionQueue}
    mx LoanIQ activate    ${LIQ_WorkInProgress_ExceptionQueue_Window}
    Sleep    5m
    mx LoanIQ click    ${LIQ_WorkInProgress_ExceptionQueue_RefreshButton}
    Wait Until Keyword Succeeds    9    3s    Mx LoanIQ Click Javatree Cell    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    ${DealName}%Transaction${SPACE}ID%${NoticeID}
    ${RefNoticeID}    Set Variable    ${NoticeID}
    ${Actual_NoticeID}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    ${DealName}%Transaction${SPACE}ID%NoticeID
    Log    ${Actual_NoticeID}
    ${ExceptionFound}    Run Keyword and Return Status    Should be Equal    ${RefNoticeID}    ${Actual_NoticeID}
    Run Keyword If    '${ExceptionFound}'=='False'    Log    Not Found in Exception Queue
    ...    ELSE    Fail    Found in Exception Queue
    
    mx LoanIQ activate    ${LIQ_WorkInProgress_ExceptionQueue_Window}
    mx LoanIQ close window    ${LIQ_WorkInProgress_ExceptionQueue_Window} 
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window}

Validate Buttons and Fields in Notice Window
    [Documentation]    This keyword validates the fields and buttons on Notice Window
    ...    @author: mgaling
    
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    
    ###Buttons###
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_Customer_Button}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_Contact_Button}    VerificationData="Yes"
    
    ###Fields###
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_NoticeMethod_JavaStaticText}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_NoticeID_JavaStaticText}       VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_Email_JavaStaticText}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_Language_JavaStaticText}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_Regarding_JavaStaticText}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_Text_JavaStaticText}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_Status_JavaStaticText}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_DateLastSent_JavaStaticText}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_TimeLastSent_JavaStaticText}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notice_LastSentBy_JavaStaticText}    VerificationData="Yes"
                 
Validate Notice Status
    [Documentation]    This Keyword validates the status of Notice in Notice Window and Notice Group after POST API transaction.
    ...    @author:mgaling
    [Arguments]    ${Notice_Identifier}    ${Notice_Status}     ${Notice_Customer_LegalName}    ${Contact}    ${NoticeGroup_UserID}    ${Notice_Method}                
    
    ###Notice Window Validation###
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    Validate Loan IQ Details    ${Notice_Identifier}    ${LIQ_Notice_NoticeID_Field}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%${Notice_Status}
    Log    ${Notice_Status}    
    
    ###Notice Listing Window###
    mx LoanIQ activate window    ${LIQ_NoticeListing_Window}   
    mx LoanIQ click    ${LIQ_NoticeListing_NoticeGroup_Button}
    
    ###Notice Group Window Validation###
    mx LoanIQ activate window    ${LIQ_NoticeGroup_Window}
    mx LoanIQ click    ${LIQ_NoticeGroup_Unmarkall_Button}
    Sleep    10s    
    mx LoanIQ click    ${LIQ_NoticeGroup_Refresh_Button}
    Sleep    10s  
    mx LoanIQ activate window    ${LIQ_NoticeGroup_Window}  
    Log    ${Notice_Customer_LegalName}
    Log    ${Contact}
    Log    ${Notice_Status}
    Log    ${NoticeGroup_UserID}
    Log    ${Notice_Method}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_NoticeGroup_Items_JavaTree}    ${Notice_Customer_LegalName}\t${Contact}\t${Notice_Status}\t${NoticeGroup_UserID}\t${Notice_Method}
    
    Take Screenshot    Correspondence_Notice_PostStatus
    
    Close All Windows on LIQ     

Get Notice ID thru Deal Notebook
    [Documentation]    This keyword gets the Notice ID by navigating into Notices Window thru Deal Notebook.
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: ehugo       15AUG2019    - added functionality to select the next notice group, used variables for notice status and notice method
    ...    @update: jloretiz    15JUL2019    - added screenshots, remove unnecessary sleep keyword, updated the writing to excel keyword and updated screenshot location
    ...    @update: fluberio    26OCT2020    - added writing of Notice Details in Excel Path  
    [Arguments]    ${From_Date}    ${Thru_Date}    ${Notice_Type}         
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Queries_Notices}
    mx LoanIQ activate window    ${LIQ_NoticeSelectMessage_Window}
    mx LoanIQ enter    ${LIQ_NoticeSelectMessage_FromDate_Field}    ${From_Date} 
    mx LoanIQ enter    ${LIQ_NoticeSelectMessage_ThruDate_Field}    ${Thru_Date}        
    mx LoanIQ click    ${LIQ_NoticeSelectMessage_OK_Button} 
    
    ${Search_Threshold}    Set Variable    10
    ${Search_Threshold}    Convert To Integer    ${Search_Threshold} 
    
    :FOR    ${Current_Row}    IN RANGE    1    ${Search_Threshold}
    \    ${Notice_Customer_LegalName}    ${Contact}    ${Status}    ${Orig_UserID}    ${Orig_NoticeMethod}    Select Notice Group    ${Notice_Type}    ${Current_Row}
    \    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Notice_NoticeGroup
    \
    \    Run Keyword If    '${Orig_NoticeMethod}' == '${Email_Notice_Method}' and '${Status}' == '${Initial_Notice_Status}'    Exit For Loop
         ...    ELSE IF    '${Orig_NoticeMethod}' == '${CBA_Email_Notice_Method}' and '${Status}' == '${Initial_Notice_Status}'    Exit For Loop
         ...    ELSE IF    '${Current_Row}' == '${Search_Threshold}' and '${Status}' != '${Initial_Notice_Status}'    Fail
    \    
    \    mx LoanIQ close window    ${LIQ_NoticeGroup_Window}    
    
    Mx LoanIQ Select String    ${LIQ_NoticeGroup_Items_JavaTree}    ${Notice_Customer_LegalName}\t${Contact}\t${Status}\t${Orig_UserID}\t${Orig_NoticeMethod}
    mx LoanIQ click    ${LIQ_NoticeGroup_EditHighlightNotices}
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    ${Notice_ID}    Mx LoanIQ Get Data    ${LIQ_Notice_NoticeID_Field}    value%ID
    
    Write Data To Excel    Correspondence    Notice_Identifier    ${rowid}     ${Notice_ID}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    ${rowid}     ${Notice_Customer_LegalName}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Contact    ${rowid}     ${Contact}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    
    Run Keyword If    '${SCENARIO}'=='4'    Run Keywords    Write Data To Excel    Correspondence    Notice_Identifier    ${rowid}     ${Notice_ID}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    Correspondence    Notice_Customer_LegalName    ${rowid}     ${Notice_Customer_LegalName}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    ...    AND    Write Data To Excel    Correspondence    Contact    ${rowid}     ${Contact}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    
    Close All Windows on LIQ

Select Notice Group
    [Documentation]    This keyword selects a notice group in the Notice Group window
    ...    @update: ehugo       15AUG2019    - initial create
    ...    @update: amansuet    19NOV2019    - replaced native type keyword with Mx press
    ...    @update: jdelacru    09JAN2020    - removed excelpath as part of keyword MXLoanIQGetData
    ...    @update: jloretiz    15JUL2019    - added screenshots, updated the Active Window keyword and updated screenshot location
    ...                                      - change the logic to fix the error on Mx LoanIQ Get Data To Excel
    [Arguments]    ${Notice_Type}    ${Current_Row}

    Mx LoanIQ Activate Window    ${LIQ_NoticeGroupsFor_Window}
    Mx LoanIQ Select String    ${LIQ_NoticeGroupsFor_Items}    ${Notice_Type}   
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_NoticeGroupsFor_Items}    ${Notice_Type}%s
    
    Log    CurrentRow: ${Current_Row}
    :FOR    ${i}    IN RANGE    0    ${Current_Row}
    \    Mx Press Combination    Key.DOWN
    Mx Press Combination    Key.ENTER
    Mx LoanIQ Activate Window    ${LIQ_NoticeGroup_Window}
    
    ###Select item with Awaiting Release status and Email Notice Method###
    ${Collection}    Mx LoanIQ Store Java Tree Items To Array    ${LIQ_NoticeGroup_Items_JavaTree}    Collection
    ${Collection}    Split To Lines    ${Collection}
    ${RowCount}    Get Length    ${Collection}

	:FOR    ${Index}    IN RANGE    0    ${RowCount}
	\    ${Notice_Customer_LegalName}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Items_JavaTree}    Y%Customer%Cust
    \    ${Contact}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Items_JavaTree}    Y%Contact%Cont
    \    ${Status}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Items_JavaTree}    Y%Status%Stat
    \    ${Orig_UserID}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Items_JavaTree}    Y%User Id%Id
    \    ${Orig_NoticeMethod}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Items_JavaTree}    Y%Notice Method%Notice
    \
    \    Run Keyword If    '${Orig_NoticeMethod}' == '${Email_Notice_Method}' and '${Status}' == '${Initial_Notice_Status}'    Exit For Loop
         ...    ELSE IF    '${Orig_NoticeMethod}' == '${CBA_Email_Notice_Method}' and '${Status}' == '${Initial_Notice_Status}'    Exit For Loop
         ...    ELSE IF    '${Index}' == '${RowCount-1}' and '${Status}' != '${Initial_Notice_Status}'    Exit For Loop      

    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Select_Notice_Group

    [Return]    ${Notice_Customer_LegalName}    ${Contact}    ${Status}    ${Orig_UserID}    ${Orig_NoticeMethod}
        
