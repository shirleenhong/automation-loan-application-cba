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
  
Get Notice ID thru Deal Notebook of Specific Contact
    [Documentation]    This keyword gets the Notice ID by navigating into Notices Window thru Deal Notebook.
    ...    @author: makcamps    15JAN2021    - initial create
    ...    @update: makcamps    22JAN2021    - removed writing of data, instead stored it to variable for return
    [Arguments]    ${sFrom_Date}    ${sThru_Date}    ${sNotice_Type}    ${sContact}
    
    ### Keyword Pre-processing###
    ${From_Date}    Acquire Argument Value    ${sFrom_Date}
    ${Thru_Date}    Acquire Argument Value    ${sThru_Date}
    ${Notice_Type}    Acquire Argument Value    ${sNotice_Type}
    ${Contact}    Acquire Argument Value    ${sContact}
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Queries_Notices}
    mx LoanIQ activate window    ${LIQ_NoticeSelectMessage_Window}
    mx LoanIQ enter    ${LIQ_NoticeSelectMessage_FromDate_Field}    ${From_Date} 
    mx LoanIQ enter    ${LIQ_NoticeSelectMessage_ThruDate_Field}    ${Thru_Date}        
    mx LoanIQ click    ${LIQ_NoticeSelectMessage_OK_Button} 
    
    ${Search_Threshold}    Set Variable    10
    ${Search_Threshold}    Convert To Integer    ${Search_Threshold} 
    
    :FOR    ${Current_Row}    IN RANGE    1    ${Search_Threshold}
    \    ${Notice_Customer_LegalName}    ${Status}    ${Orig_UserID}    ${Orig_NoticeMethod}    Select Notice Group with Contact as Ref    ${Notice_Type}    ${Current_Row}    ${Contact}
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
    
    Close All Windows on LIQ

    [Return]    ${Notice_ID}    ${Notice_Customer_LegalName}    ${Contact}

Get Notice Details via Loan Notebook
    [Documentation]    Get Notice Details (Effective Date, Term Start and End Date, Fixed Rate Option, Margin, All-in Rate and Interest Due) via Loan Notebook in LIQ
    ...    @author: makcamps    22JAN2021    - initial create
    ...    @update: makcamps    26JAN2021    - added get data and return value for pricing option
    [Arguments]    ${sFacilityName}    ${sDealName}    ${sLoanAlias}    ${sCycleNumber}=1

    ### Keyword Pre-processing ###
    ${FacilityName}    Acquire Argument Value    ${sFacilityName}    
    ${DealName}    Acquire Argument Value    ${sDealName}
    ${LoanAlias}    Acquire Argument Value    ${sLoanAlias}
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}

    ### Navigate to Existing Loans For Facility Window ###
    Search for Deal    ${DealName}
    Search for Existing Outstanding    Loan    ${FacilityName}
    
    ###Existing Loans For Facility Window###
    mx LoanIQ activate window    ${LIQ_ExistingLoansForFacility_Window}
    ${Effective_Date}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_ExistingLoansForFacility_Loan_List}    ${LoanAlias}%Effective Date%var
    ${Effective_Date}    Convert Date    ${Effective_Date}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    ${Repricing_Date}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_ExistingLoansForFacility_Loan_List}    ${LoanAlias}%Repricing Date%var
    ${Repricing_Date}    Convert Date    ${Repricing_Date}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    ${Maturity_Date}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_ExistingLoansForFacility_Loan_List}    ${LoanAlias}%Maturity Date%var
    ${Maturity_Date}    Convert Date    ${Maturity_Date}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    ${Pricing_Option}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_ExistingLoansForFacility_Loan_List}    ${LoanAlias}%Pricing Option%var
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Loan_ExistingLoansForFacility
    
    ### Navigate to Loan Notebook ###
    Open Existing Loan    ${LoanAlias}
    
    ###Loan Notebook - General Tab###
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${Global_Original}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Field}    text%Global_Original
    ${RateSetting_DueDate}    Mx LoanIQ Get Data    ${LIQ_Loan_GeneralTab_RateSettingDueDate_Textfield}    text%RateSetting_DueDate
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Loan_GeneralTab
    
    ###Loan Notebook - Rates Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Rates
    ${PenaltySpread_IsOff}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_RatesTab_PenaltySpread_Status_OFF}        VerificationData="Yes"
    Run Keyword If     ${PenaltySpread_IsOff}==${False}    Fail   Penalty Spread Status is not set to OFF.
    ...    ELSE    Log    Penalty Spread Status is set to OFF.
    ${Base_Rate}    Mx LoanIQ Get Data    ${LIQ_Loan_RatesTab_BaseRate_Field}    text%Base_Rate
    ${Spread}    Mx LoanIQ Get Data    ${LIQ_Loan_RatesTab_Spread_Field}    text%Spread
    ${AllIn_Rate}    Mx LoanIQ Get Data    ${LIQ_Loan_AllInRate}    text%AllIn_Rate
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Loan_RatesTab
    
    ###Loan Notebook - Accrual Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ${Cycle_Due}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Loan_AccrualTab_Cycles_Table}    ${CycleNumber}%Cycle Due%var    Processtimeout=180    
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Loan_AccrualTab

    Close All Windows on LIQ
        
    [Return]    ${Effective_Date}    ${Repricing_Date}    ${Maturity_Date}    ${Base_Rate}    ${Spread}
    ...    ${AllIn_Rate}    ${Cycle_Due}    ${Global_Original}    ${RateSetting_DueDate}    ${Pricing_Option}

Select Notice Group
    [Documentation]    This keyword selects a notice group in the Notice Group window
    ...    @update: ehugo       15AUG2019    - initial create
    ...    @update: amansuet    19NOV2019    - replaced native type keyword with Mx press
    ...    @update: jdelacru    09JAN2020    - removed excelpath as part of keyword MXLoanIQGetData
    ...    @update: jloretiz    15JUL2019    - added screenshots, updated the Active Window keyword and updated screenshot location
    ...                                      - change the logic to fix the error on Mx LoanIQ Get Data To Excel
    ...    @update: mcastro    08JAN2021    - Updated 'Mx LoanIQ Select Or DoubleClick In Javatree' to 'Mx LoanIQ Select Or Doubleclick In Tree By Text' to handle notices that contains the same text
    [Arguments]    ${Notice_Type}    ${Current_Row}
    
    Mx LoanIQ Activate Window    ${LIQ_NoticeGroupsFor_Window}
    Mx LoanIQ Select String    ${LIQ_NoticeGroupsFor_Items}    ${Notice_Type}   
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_NoticeGroupsFor_Items}    ${Notice_Type}%s
    
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

Select Notice Group with Contact as Ref
    [Documentation]    This keyword selects a notice group in the Notice Group window
    ...    @author: makcamps    15JAN2021    - initial create
    [Arguments]    ${sNotice_Type}    ${sCurrent_Row}    ${sContactName}

    ### Keyword Pre-processing###
    ${Notice_Type}    Acquire Argument Value    ${sNotice_Type}
    ${Current_Row}    Acquire Argument Value    ${sCurrent_Row}
    ${ContactName}    Acquire Argument Value    ${sContactName}

    Mx LoanIQ Activate Window    ${LIQ_NoticeGroupsFor_Window}
    Mx LoanIQ Select String    ${LIQ_NoticeGroupsFor_Items}    ${Notice_Type}   
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_NoticeGroupsFor_Items}    ${Notice_Type}%s
    
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
	\    ${Notice_Customer_LegalName}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Items_JavaTree}    ${ContactName}%Customer%Cust
    \    ${Status}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Items_JavaTree}    ${ContactName}%Status%Stat
    \    ${Orig_UserID}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Items_JavaTree}    ${ContactName}%User Id%Id
    \    ${Orig_NoticeMethod}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Items_JavaTree}    ${ContactName}%Notice Method%Notice
    \
    \    Run Keyword If    '${Orig_NoticeMethod}' == '${Email_Notice_Method}' and '${Status}' == '${Initial_Notice_Status}'    Exit For Loop
         ...    ELSE IF    '${Orig_NoticeMethod}' == '${CBA_Email_Notice_Method}' and '${Status}' == '${Initial_Notice_Status}'    Exit For Loop
         ...    ELSE IF    '${Index}' == '${RowCount-1}' and '${Status}' != '${Initial_Notice_Status}'    Exit For Loop      

    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Select_Notice_Group

    [Return]    ${Notice_Customer_LegalName}    ${Status}    ${Orig_UserID}    ${Orig_NoticeMethod}

Add Group Comment for Notices
    [Documentation]    This keyword add group comment for Notice window.
    ...    @author: dahijara    15DEC2020    - Initial create
    [Arguments]    ${sSubject}    ${sComment}

    ### Keyword Pre-processing ###
    ${Subject}    Acquire Argument Value    ${sSubject}
    ${Comment}    Acquire Argument Value    ${sComment}

    Mx LoanIQ Activate    ${LIQ_Notice_Notice_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NoticeWindow
    Mx LoanIQ Click    ${LIQ_Notice_GroupComment_Button}
    Mx LoanIQ Click Element if Present    ${LIQ_Warning_Yes_Button}

    Mx LoanIQ Activate    ${LIQ_Notice_CommentEdit_Window}
    Mx LoanIQ Enter    ${LIQ_Notice_CommentEdit_Subject_Textbox}    ${Subject}
    Mx LoanIQ Enter    ${LIQ_Notice_CommentEdit_Comment_Textbox}    ${Comment}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NoticeGroupComment
    Mx LoanIQ Click    ${LIQ_Notice_CommentEdit_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NoticeWindow

Exit Notice Window
    [Documentation]    This keyword closes the notice window
    ...    @author: dahijara    15DEC2020    - Initial Create

    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Notice
    Mx LoanIQ Close Window    ${LIQ_Notice_Notice_Window}

Generate From and Thru Dates for Notices
    [Documentation]    This Keyword generate From and Thru dates for filtering Notices.
    ...    @author: dahijara     15DEC2020    - initial create
    [Arguments]    ${sSubAddDays}    ${sRunVal_FromDate}=None    ${sRunVal_ThruDate}=None

    ### Keyword Pre-processing ###
    ${SubAddDays}    Acquire Argument Value    ${sSubAddDays}
    
    ###Get System Date###
    ${SystemDate}    Get Current Date of Local Machine    %d-%b-%Y
    ${SystemDate}    Convert Date    ${SystemDate}     date_format=%d-%b-%Y
    ${FromDate}    Subtract Time From Date    ${SystemDate}    ${sSubAddDays}days
    ${ThruDate}    Add Time To Date    ${SystemDate}    ${sSubAddDays}days

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVal_FromDate}    ${FromDate}
    Save Values of Runtime Execution on Excel File    ${sRunVal_ThruDate}    ${ThruDate}

    [Return]    ${FromDate}    ${ThruDate}

Get Notice ID via Deal Notebook 
    [Documentation]    This keyword gets the Notice ID by navigating into Notices Window thru Deal Notebook.
    ...    @author: dahijara    15DEC2020    - Initial create
    ...    @update: mcastro    15JAN2021   - Added condition to handle Event Fee Payment Notice Window
    [Arguments]    ${sFrom_Date}    ${sThru_Date}    ${sNotice_Type}    ${sRunVal_Notice_ID}=None    ${sRunVal_Notice_Customer_LegalName}=None    ${sRunVal_Contact}=None
    ### Keyword Pre-processing ###
    ${From_Date}    Acquire Argument Value    ${sFrom_Date}
    ${Thru_Date}    Acquire Argument Value    ${sThru_Date}
    ${Notice_Type}    Acquire Argument Value    ${sNotice_Type}

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
    
    ${Window_title}    Mx LoanIQ Get Data    ${LIQ_NoticeGroup_Window}    label%temp

    Mx LoanIQ Select String    ${LIQ_NoticeGroup_Items_JavaTree}    ${Notice_Customer_LegalName}\t${Contact}\t${Status}\t${Orig_UserID}\t${Orig_NoticeMethod}
    mx LoanIQ click    ${LIQ_NoticeGroup_EditHighlightNotices}
    mx LoanIQ activate window    ${LIQ_Notice_Window}

    ${Status}    Run Keyword and Return Status   Should Contain    ${Window_title}    Event Fee Payment
    ${Notice_ID}    Run Keyword If    ${Status}==${True}    Mx LoanIQ Get Data    ${LIQ_EventFeePaymentGroup_NoticeID_Field}    value%ID
    ...    ELSE    Mx LoanIQ Get Data    ${LIQ_Notice_NoticeID_Field}    value%ID
    
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Notice_NoticeGroup
    Close All Windows on LIQ

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunVal_Notice_ID}    ${Notice_ID}
    Save Values of Runtime Execution on Excel File    ${sRunVal_Notice_Customer_LegalName}    ${Notice_Customer_LegalName}
    Save Values of Runtime Execution on Excel File    ${sRunVal_Contact}    ${Contact}

    [Return]    ${Notice_ID}    ${Notice_Customer_LegalName}    ${Contact}

Select Notices Recipients
    [Documentation]    This keyword selects the recepient of the generated notices.
    ...    Values for sBorrowerDepesitor, sGuarrantors & sExporterSponsors should be Y or N
    ...    @author: dahijara    16DEC2020
    ...    @update: dahijara    13JAN2020    - Updated keyword name from 'Select Notices Recepients' to 'Select Notices Recipients'
    [Arguments]    ${sBorrowerDepesitor}=Y    ${sGuarrantors}=N    ${sExporterSponsors}=N
    
    ### Keyword Pre-processing ###
    ${BorrowerDepesitor}    Acquire Argument Value    ${sBorrowerDepesitor}
    ${Guarrantors}    Acquire Argument Value    ${sGuarrantors}
    ${ExporterSponsors}    Acquire Argument Value    ${sExporterSponsors}

    mx LoanIQ activate    ${LIQ_Notices_Window}

    Run Keyword If    '${BorrowerDepesitor}'=='Y'    Mx LoanIQ Set    ${LIQ_Notices_Borrower_Checkbox}    ON
    ...    ELSE    Mx LoanIQ Set    ${LIQ_Notices_Borrower_Checkbox}    OFF

    Run Keyword If    '${Guarrantors}'=='Y'    Mx LoanIQ Set    ${LIQ_Notices_Guarantors_Checkbox}    ON
    ...    ELSE    Mx LoanIQ Set    ${LIQ_Notices_Guarantors_Checkbox}    OFF

    Run Keyword If    '${ExporterSponsors}'=='Y'    Mx LoanIQ Set    ${LIQ_Notices_Exporters_Checkbox}    ON
    ...    ELSE    Mx LoanIQ Set    ${LIQ_Notices_Exporters_Checkbox}    OFF
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Notice
    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_NoticeGroup_Window}    
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Notice

Validate and Send Event Fee Payment Notice
    [Documentation]    This keyword is used for sending the event fee payment notice.
    ...    @author: mcastro    06JAN2021    - Initial Create
    [Arguments]    ${sNotice_Customer_LegalName}    ${sNotice_Identifier}  

    ### Keyword Pre-processing ###
    ${Notice_Customer_LegalName}    Acquire Argument Value    ${sNotice_Customer_LegalName}
    ${Notice_Identifier}    Acquire Argument Value    ${sNotice_Identifier}

    Mx LoanIQ activate window    ${LIQ_EventFeePaymentGroup_Window}
     
    Validate Loan IQ Details    ${Notice_Customer_LegalName}    ${LIQ_EventFeePaymentGroup_Customer_Field} 
    Validate Loan IQ Details    ${Notice_Identifier}    ${LIQ_EventFeePaymentGroup_NoticeID_Field}
    Mx LoanIQ Verify Runtime Property    ${LIQ_EventFeePaymentGroup_StaticText}    attached text%Awaiting release       
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Notice_AwaitingRelease
    
    Mx LoanIQ select    ${LIQ_EventFeePaymentGroup_OptionsSend_Menu}
    Mx LoanIQ Verify Runtime Property    ${LIQ_EventFeePaymentGroup_StaticText}    attached text%Queued
    
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Notice_Queued
    
    Close All Windows on LIQ

Validate Notice Status for Event Fee Payment Notice
    [Documentation]    This Keyword validates the status of Event Fee payment in Notice Window and Notice Group after POST API transaction.
    ...    @author: mcastro    07JAN2021    - Initial Create
    [Arguments]    ${sNotice_Identifier}    ${sNotice_Status}     ${sNotice_Customer_LegalName}    ${sContact}    ${sNoticeGroup_UserID}    ${sNotice_Method}                
    
    ### Keyword Pre-processing ###
    ${Notice_Identifier}    Acquire Argument Value    ${sNotice_Identifier}
    ${Notice_Status}    Acquire Argument Value    ${sNotice_Status}
    ${Notice_Customer_LegalName}    Acquire Argument Value    ${sNotice_Customer_LegalName}
    ${Contact}    Acquire Argument Value    ${sContact}
    ${NoticeGroup_UserID}    Acquire Argument Value    ${sNoticeGroup_UserID}
    ${Notice_Method}    Acquire Argument Value    ${sNotice_Method}

    ### Notice Window Validation ###
    Mx LoanIQ activate window    ${LIQ_EventFeePaymentGroup_Window}
    Validate Loan IQ Details    ${Notice_Identifier}    ${LIQ_EventFeePaymentGroup_NoticeID_Field}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${LIQ_EventFeePaymentGroup_StaticText}    attached text%${Notice_Status}
    Log    ${Notice_Status}    
    
    ### Notice Listing Window ###
    Mx LoanIQ activate window    ${LIQ_NoticeListing_Window}   
    Mx LoanIQ click    ${LIQ_NoticeListing_NoticeGroup_Button}
    
    ###Notice Group Window Validation###
    Mx LoanIQ activate window    ${LIQ_NoticeGroup_Window}
    Mx LoanIQ click    ${LIQ_EventFeePaymentGroup_UnmarkAll_Button}
    Mx LoanIQ activate window    ${LIQ_NoticeGroup_Window}  
    mx LoanIQ click    ${LIQ_EventFeePaymentGroup_Refresh_Button}
    mx LoanIQ activate window    ${LIQ_NoticeGroup_Window}  
    Log    ${Notice_Customer_LegalName}
    Log    ${Contact}
    Log    ${Notice_Status}
    Log    ${NoticeGroup_UserID}
    Log    ${Notice_Method}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_EventFeePayment_Items_JavaTree}    ${Notice_Customer_LegalName}\t${Contact}\t${Notice_Status}\t${NoticeGroup_UserID}\t${Notice_Method}
    
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Notice_PostStatus
    
    Close All Windows on LIQ   

Close Commitment Change Group Window
    [Documentation]    This keyword closes the Commitment Change Group Window
    ...    @author: dahijara    15FEB2021    - Initial Create

    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Notice
    Mx LoanIQ Close Window    ${LIQ_Notice_CommitmentChangeGroup_Window}