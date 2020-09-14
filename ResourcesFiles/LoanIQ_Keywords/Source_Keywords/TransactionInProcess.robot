*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate Transaction in WIP
    [Documentation]    This keyword logouts from the current user, logins to a different user and navigates a transaction in WIP.
    ...    
    ...    | Arguments |
    ...    
    ...    'Transaction' = These are the items listed under "Transactions". Ex. Outstandings, Payments
    ...    'TransactionStatus' = Ex. Awaiting Approval, Awaiting Release
    ...    'TransactionType' = Ex. Loan Initial Drawdown, Ongoing Fee Payment
    ...    'TransactionName' = A unique identifier of the transaction. Ex. Deal name, Alias
    ...    
    ...    @author: bernchua
    ...    @update: bernchua    11JAN2019    Added argument TargetDate with default value ${EMPTY}
    ...                                      Added loop and conditions on how to navigate WIP for the TargetDate
    ...    @update: fmamaril    15MAY2020    - added argument for keyword pre processing
    ...    @update: hstone      05JUN2020    - Replaced 'Mx LoanIQ DoubleClick    ${TransactionsList_Locator}    ${sTransactionType}' 
    ...                                        with 'Mx LoanIQ Select Or Doubleclick In Tree By Text    ${TransactionsList_Locator}    ${TransactionType}%d'
    ...                                      - Added 'Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/WIP_${Transaction}'
    ...    @update: hstone      03JUL2020    - Added setting condition when ${Transaction} value is equal to 'ManualTrans'
    ...    @update: clanding    20JUL2020    - Added ELSE condition in setting ${Transaction}
    [Arguments]    ${sTransaction}    ${sTransactionStatus}    ${sTransactionType}    ${sTransactionName}    ${sTargetDate}=${EMPTY}
    ### Keyword Pre-processing ###
    ${Transaction}    Acquire Argument Value    ${sTransaction}
    ${TransactionStatus}    Acquire Argument Value    ${sTransactionStatus}
    ${TransactionType}    Acquire Argument Value    ${sTransactionType}
    ${TransactionName}    Acquire Argument Value    ${sTransactionName}
    ${TargetDate}    Acquire Argument Value    ${sTargetDate}
    
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate    ${LIQ_TransactionInProcess_Window}
    Mx LoanIQ Active Javatree Item    ${LIQ_TransactionInProcess_Tree}    ${Transaction}
    mx LoanIQ maximize    ${LIQ_TransactionInProcess_Window}
    ${Transaction}    Run Keyword If    '${Transaction}'=='ManualTrans'    Set Variable    Manual Trans
    ...    ELSE    Set Variable    ${Transaction}
    ${TransactionsList_Locator}    Set Variable    JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=Group:Details;Tab:${Transaction};")
    :FOR    ${i}    IN RANGE    3
    \    Mx LoanIQ DoubleClick    ${TransactionsList_Locator}    ${TransactionStatus}
    \    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${TransactionsList_Locator}    ${TransactionType}%d
    \    Sleep    2s
    \    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/WIP_${Transaction}
    \    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ DoubleClick    ${TransactionsList_Locator}    ${TransactionName}
    \    Run Keyword If    ${STATUS}==False and '${TargetDate}'!='${EMPTY}'    Run Keywords
         ...    Transaction in Process Change Target Date    ${TargetDate}
         ...    AND    mx LoanIQ select    ${LIQ_TransactionInProcess_File_Refresh}
         ...    AND    mx LoanIQ click    ${LIQ_TransactionInProcess_CollapseAll_Button}
    \    Exit For Loop If    ${STATUS}==True

Navigate Transaction in WIP for Circles
    [Documentation]    This keyword navigates the Circles transaction in WIP.
    ...    
    ...    | Arguments |
    ...    
    ...    'TransactionStatus' = Ex. Awaiting Approval, Awaiting Release
    ...    'LenderType' = Ex. Host Bank or Non-Host Bank
    ...    'LenderName' = Name of the Lender Bank
    ...    
    ...    @author: bernchua
    [Arguments]    ${TransactionStatus}    ${LenderType}    ${LenderName}
    ${Locator_CirclesTransaction}    Set Variable    JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=Group:Details;Tab:Circles;")
    Wait Until Keyword Succeeds    60    3    mx LoanIQ activate window    ${LIQ_TransactionInProcess_Window}
    mx LoanIQ select    ${LIQ_TransactionInProcess_File_Refresh}
    ${Button_Status}    Mx LoanIQ Get Data    ${LIQ_TransactionInProcess_CollapseAll_Button}    enabled%value
    Run Keyword If    '${Button_Status}'=='1'    mx LoanIQ click    ${LIQ_TransactionInProcess_CollapseAll_Button}
    Mx LoanIQ Active Javatree Item    ${LIQ_TransactionInProcess_Tree}    Circles
    mx LoanIQ maximize    ${LIQ_TransactionInProcess_Window}
    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ DoubleClick    ${Locator_CirclesTransaction}    ${TransactionStatus}
    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ DoubleClick    ${Locator_CirclesTransaction}    ${LenderType}
    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ DoubleClick    ${Locator_CirclesTransaction}    Primary
    Wait Until Keyword Succeeds    3x    5s    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${Locator_CirclesTransaction}    ${LenderName}%d
    
Open Deal Scheduled Activity Report
    [Documentation]    This keyword opens the Scheduled Activity Report from WIP to list all the transactions of a specific Deal.
    ...    @author: bernchua
    ...    @update: dahijara    06AUG2020    - Added screenshot
    ...    @update: dahijara    07AUG2020    - updated argument name per standard
    [Arguments]    ${sDealName}    ${sFromDate}    ${sThruDate}
    
    ### GetRuntime Keyword Pre-processing ###
    ${DealName}    Acquire Argument Value    ${sDealName}
    ${FromDate}    Acquire Argument Value    ${sFromDate}
    ${ThruDate}    Acquire Argument Value    ${sThruDate}

    Select Actions    [Actions];Work In Process
    mx LoanIQ activate    ${LIQ_TransactionInProcess_Window}
    mx LoanIQ select    ${LIQ_TransactionsInProcess_ScheduledActivity_Menu}
    mx LoanIQ enter    ${LIQ_ScheduledActivityFilter_FromDate_Field}    ${FromDate}
    mx LoanIQ enter    ${LIQ_ScheduledActivityFilter_ThruDate_Field}    ${ThruDate}
    mx LoanIQ click    ${LIQ_ScheduledActivityFilter_Deal_Button}
    Mx LoanIQ Set    ${LIQ_DelectSelect_Active_RadioButton}    ON
    mx LoanIQ enter    ${LIQ_DealSelect_DealIdentifyBy_Textfield}    ${DealName}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledActivity
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}
    mx LoanIQ click    ${LIQ_ScheduledActivityFilter_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledActivity
    
Open Transaction In Scheduled Activity Report
    [Documentation]    This keyword navigates the Scheduled Activity Report window and opens a specific transaction.
    ...    @author: bernchua
    ...    @update: dahijara    06AUG2020    - Added screenshot
    ...    @update: dahijara    07AUG2020    - updated argument name per standard. Replace Mx Native Type with Mx Press Combination
    [Arguments]    ${sDealName}    ${sDueDate}    ${sUniqueTransactionIdentifier}
    
    ### GetRuntime Keyword Pre-processing ###
    ${DealName}    Acquire Argument Value    ${sDealName}
    ${DueDate}    Acquire Argument Value    ${sDueDate}
    ${UniqueTransactionIdentifier}    Acquire Argument Value    ${sUniqueTransactionIdentifier}

    mx LoanIQ activate    ${LIQ_ScheduledActivityReport_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_ScheduledActivityReport_ViewBy_Combobox}    By Deal\\Date
    mx LoanIQ click    ${LIQ_ScheduledActivityReport_CollapseAll_Button}
    Mx Loaniq Expand    ${LIQ_ScheduledActivityReport_Tree}    ${DealName};${DueDate};${UniqueTransactionIdentifier}
    Mx LoanIQ Click Javatree Cell    ${LIQ_ScheduledActivityReport_Tree}    ${UniqueTransactionIdentifier}%${UniqueTransactionIdentifier}%Deal/Activity/Date
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledActivity
    Mx Press Combination    Key.ENTER
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ScheduledActivity

Navigate to Logged Exception List Window
    [Documentation]    This keyword navigates to Logged Exception List Window thru WIP.
    ...    @author:mgaling
    
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate window    ${LIQ_TransactionInProcess_Window}
    mx LoanIQ select    ${LIQ_WorkInProgress_ExceptionQueue_Queries}
    
    mx LoanIQ activate window    ${LIQ_WorkInProgress_LoggedExceptionList_Window}   
    
Validate Logged Exception List Window
     [Documentation]    This keyword populates Query Section and validates data in Logged Exception List Window.
     ...    @author: mgaling     DDMMMYYYY    - initial create
     ...    @update: jloretiz    13JUL2020    - removed unncessary sleep and fix spacing formats
     [Arguments]    ${BEO_StartDate}    ${BEO_EndDate}    ${Deal_Name}    ${Notice_Identifier}      
     
    mx LoanIQ activate window    ${LIQ_WorkInProgress_LoggedExceptionList_Window}
    mx LoanIQ enter    ${LIQ_LoggedExceptionList_FromDate_Field}    ${BEO_StartDate}
    mx LoanIQ enter    ${LIQ_LoggedExceptionList_ToDate_Field}    ${BEO_EndDate}
    mx LoanIQ click    ${LIQ_LoggedExceptionList_RefreshList_Button} 
    mx LoanIQ enter    ${LIQ_LoggedExceptionList_Deal_Field}    ${Deal_Name}        
       
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    items count%0
    Run Keyword If    ${status}==True    Log    ${Notice_Identifier} is not present.    
    ...    ELSE    Run Keyword    Logged Exception List Window with Data    ${DealName}    ${Notice_Identifier}                           
    
    mx LoanIQ activate window    ${LIQ_WorkInProgress_LoggedExceptionList_Window}
    Take Screenshot    Correspondence_Notice_ExceptionQueue
    mx LoanIQ close window    ${LIQ_WorkInProgress_LoggedExceptionList_Window}
                 
Validate Logged Exception List Window - Failed
    [Documentation]    This keyword is used to validate that the unsuccessful call back will be logged under WIP>Queries>Exception Queue
    ...    @author: mgaling
    ...    @update: ehugo    15AUG2019    Updated time to search for a logged exception. It will now search every 30 seconds until it reaches threshold of 5 minutes.
    ...    @update: fmamaril    16AUG2019    Deletd commented lines already handled by Wait Until
    ...    @update: ehugo    22AUG2019    Reverted back to 5 minutes waiting
    [Arguments]    ${Deal_Name}    ${NoticeID}    ${Expected_Description}    
    
    mx LoanIQ activate window    ${LIQ_WorkInProgress_LoggedExceptionList_Window}
    
    Sleep    5m    
    mx LoanIQ click    ${LIQ_LoggedExceptionList_RefreshList_Button}
    mx LoanIQ enter    ${LIQ_LoggedExceptionList_Deal_Field}    ${Deal_Name}
    Wait Until Keyword Succeeds    9    3s    Mx LoanIQ Click Javatree Cell    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    ${NoticeID}%${NoticeID}%Transaction${SPACE}ID
    Mx Native Type    {ENTER}
    
    ###Logged Exception ERR Window###
    mx LoanIQ activate window    ${LIQ_WorkInProgress_ExceptionQueue_LoggedExceptionERR_Window}
    
    ${Actual_NoticeID}    Mx LoanIQ Get Data    ${LIQ_LoggedExceptionERR_TranRID_StaticText}    attached text        
    Log    Expected NoticeID = ${NoticeID}
    Log    Actual NoticeID = ${Actual_NoticeID}
    Should Be Equal    ${Actual_NoticeID}    ${NoticeID}
    
    ${Actual_Description}    Mx LoanIQ Get Data    ${LIQ_LoggedExceptionERR_Description_Field}    value    
    Log    Expected Description = ${Expected_Description}
    Log    Actual Description = ${Actual_Description}           
    Run Keyword And Continue On Failure    Should Be Equal    ${Actual_Description}    ${Expected_Description}       
    mx LoanIQ click    ${LIQ_LoggedExceptionERR_Close_Button} 
    
    Take Screenshot    Correspondence_Notice_Exception
    
    Close All Windows on LIQ     

Search For Logged Exception
    [Documentation]    This keyword searches for a Deal Name with specified Notice ID in the Logged Exception List Window
    ...    @author: ehugo    08152019
    [Arguments]    ${Deal_Name}    ${NoticeID}
    mx LoanIQ click    ${LIQ_LoggedExceptionList_RefreshList_Button}
    mx LoanIQ enter    ${LIQ_LoggedExceptionList_Deal_Field}    ${Deal_Name}
    # Wait Until Keyword Succeeds    9x    3s    Mx LoanIQ Click Javatree Cell    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    ${NoticeID}%${NoticeID}%Transaction ID
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    ${NoticeID}%s
    Mx Native Type    {ENTER}
    
Logged Exception List Window with No Data
    [Documentation]    This keyword validates Logged Exception List Window with no data.  
    ...    @author: mgaling
    [Arguments]    ${Notice_Identifier}
    
    mx LoanIQ activate window    ${LIQ_WorkInProgress_LoggedExceptionList_Window}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Text In Javatree    ${LIQ_LoggedExceptionList_Items_JavaTree}    ${Notice_Identifier}%no  
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_LoggedExceptionList_Items_JavaTree}    ${Notice_Identifier}%no      
    Run Keyword If    ${status}==True    Log    Pass    ${Notice_Identifier} should not be present
    Run Keyword If    ${status}==False    Fail    ${Notice_Identifier} is present      
    
Logged Exception List Window with Data
    [Documentation]    This keyword validates Logged Exception List Window with no data.  
    ...    @author: mgaling
    [Arguments]    ${DealName}    ${Notice_Identifier}    
    
    mx LoanIQ activate window    ${LIQ_WorkInProgress_LoggedExceptionList_Window}
    
    Wait Until Keyword Succeeds    9    3s    Mx LoanIQ Click Javatree Cell    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    ${DealName}%Transaction${SPACE}ID%${Notice_Identifier}
    ${RefNoticeID}    Set Variable    ${Notice_Identifier}
    ${Actual_NoticeID}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_WorkInProgress_ExceptionQueue_JavaTree}    ${DealName}%Transaction${SPACE}ID%NoticeID
    Log    ${Actual_NoticeID}
    ${ExceptionFound}    Run Keyword and Return Status    Should be Equal    ${RefNoticeID}    ${Actual_NoticeID}
    Run Keyword If    '${ExceptionFound}'=='False'    Log    Not Found in Exception Queue
    ...    ELSE    Fail    Found in Exception Queue
    
Transaction in Process Change Target Date
    [Documentation]    This keyword changes the target date in the Transaction In Process window.
    ...                @author: bernchua
    [Arguments]        ${Target_Date}
    Wait Until Keyword Succeeds    3x    5s    mx LoanIQ activate    ${LIQ_TransactionInProcess_Window}
    mx LoanIQ select    ${LIQ_TransactionInProcess_File_ChangeTargetDate}
    mx LoanIQ enter    ${LIQ_ChangeTargetDate_DateField}    ${Target_Date}
    mx LoanIQ click    ${LIQ_ChangeTargetDate_Ok_Button}
