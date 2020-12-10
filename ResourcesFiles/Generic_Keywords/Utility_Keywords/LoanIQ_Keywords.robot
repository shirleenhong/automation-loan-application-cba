*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***

Logout from Loan IQ
    [Documentation]    This keyword logs out the user from LIQ.
    ...    @author: fmamaril
    ...    @update: mnanquil    10APR2019    added condition to handle different window title 
	...    @update: jdelacru    16APR2019    remove condition to optimize keyword
	...    @update: bernchua    05JUN2019    added wait until keyword succeeds for setting of radio button
    ...    @update: amansuet    08APR2020    Moved from Generic to LoanIQ file
    ...    @update: amansuet    23APR2020    renamed keyword from 'Logout from LIQ' to 'Logout from Loan IQ' to align with the naming standards
    
    Mx LoanIQ Close    ${LIQ_Window}
    Wait Until Keyword Succeeds    5x    5s    mx LoanIQ enter    ${LIQ_Logout_AsDifferentUser_RadioButton}    ON
    mx LoanIQ click    ${LIQ_Logout_OK_Button}
    
Login to Loan IQ
    [Documentation]    This keyword logs in the user from LIQ.
    ...    @author: fmamaril    
    ...    @update: mnanqul 
    ...    Added a for loop to handle the waiting time for disclaimer ok button. This is for
    ...    Setting up the LIQ Application.
    ...    @update: amansuet    08APR2020    Moved from Generic to LoanIQ file 
    [Arguments]    ${Username}    ${Password}
    
    mx LoanIQ activate    ${LIQ_Login_Window}           
    mx LoanIQ enter    ${LIQ_Username_Field}    ${Username}
    mx LoanIQ enter    ${LIQ_Password_Field}    ${Password}
    mx LoanIQ click    ${LIQ_SignIn_Button}
    :FOR    ${INDEX}    IN RANGE    10
    \    ${status}    Run keyword and Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Disclaimer_Ok_JavaButton}    VerificationData="Yes"
    \    Exit For Loop If    '${status}' == 'True'   
    \    Run keyword if    '${status}' == 'False'    Log    Will try again to find the element: ${LIQ_Disclaimer_Ok_JavaButton}
    \    Run keyword if    ${INDEX} == 9    Fatal Error    Already tried to find the element for 10 times. Please check the issue.
    mx LoanIQ click    ${LIQ_Disclaimer_Ok_JavaButton}
    mx LoanIQ maximize    ${LIQ_Window}
    Sleep    3 

Open Existing Deal
    [Documentation]    This keyword opens an existing deal on LIQ.
    ...    @author: fmamaril
    ...    @update: bernchua    28SEP2018    Added - Mx Click Element If Present    ${LIQ_DealNotebook_InquiryMode_Button}
    ...    @update: amansuet    08APR2020    Moved from Generic to LoanIQ file and added Keyword Pre-processing
    ...    @update: hstone      11JUN2020    - Added Take Screenshot
    ...    @update: clanding    26NOV2020    - added mx LoanIQ click element if present    ${LIQ_Alerts_OK_Button}
    [Arguments]    ${sDeal_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    ### Keyword Process ###
    mx LoanIQ maximize    ${LIQ_Window}
    Select Actions    [Actions];Deal   
    mx LoanIQ enter    ${LIQ_DealSelect_DealIdentifyBy_Textfield}    ${Deal_Name}   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealSelect
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}  
    mx LoanIQ click element if present    ${LIQ_Alerts_OK_Button}
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook

Select Item in Work in Process
    [Documentation]    This keyword is used to open the Loan Initial Drawdown Notebook with an Awaiting Release Cashflow Status thru the LIQ WIP Icon.
    ...    @author: rtarayao/ghabal
    ...    changed 'Mx LoanIQ Select Or Doubleclick In Tree By Text' to 'Mx LoanIQ Select String'
    ...    @update: amansuet    23APR2020    Moved from Generic to LoanIQ file
    ...    @update: hstone      27APR2020    Added Kewyword Pre-processing: Acquire Argument Value
    ...    @update: hstone      22MAY2020    - Removed Sleep
    ...                                      - Added 'Wait Until Keyword Succeeds' for 'Mx Press Combination    Key.ENTER'
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing for other arguments
    [Arguments]    ${sTransactionItem}    ${sTransactionStatus}    ${sTransactionType}    ${sAlias}

    ### Keyword Pre-processing ###
    ${TransactionItem}    Acquire Argument Value    ${sTransactionItem}
    ${TransactionStatus}    Acquire Argument Value    ${sTransactionStatus}
    ${TransactionType}    Acquire Argument Value    ${sTransactionType}
    ${Alias}    Acquire Argument Value    ${sAlias}

    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ DoubleClick     ${LIQ_WorkInProgress_TransactionList}    ${TransactionItem}
    
    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${TransactionStatus}        
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${TransactionStatus} 

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${TransactionType}
    Run Keyword If    ${status}==True    Mx LoanIQ DoubleClick    ${LIQ_WorkInProgress_TransactionStatus_List}    ${TransactionType}  
   
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${TransactionType} 
    Mx Press Combination    Key.PAGE DOWN
    
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionStatus_List}    ${Alias}
    Wait Until Keyword Succeeds    3x    5 sec    Mx Press Combination    Key.ENTER 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/WorkInProgress
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OpenedNotebook

Close All Windows on LIQ
    [Documentation]    This keyword i used to closed all existing windows on Loan IQ
    ...    @author: jcdelacruz/ghabal
    ...    <update @ghabal> added Mx Maximize to set screen back to normal view
    ...    added Mx Click Element If Present ${LIQ_Information_OK_Button} for Scenario 4
    ...    <update> bernchua 11/13/2018: added keyword wait until kewyord succeeds on acitvate window
    ...    @update:    fmamaril    03MAY2019    Modify handling to ignore error
    ...    @update: amansuet    23APR2020    Moved from Generic to LoanIQ file 
    Wait Until Keyword Succeeds    5x    5s    mx LoanIQ activate window    ${LIQ_Window} 
    Run Keyword And Ignore Error    mx LoanIQ select    ${LIQ_CloseAll_Window}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    mx LoanIQ maximize    ${LIQ_Window}
    
Select Java Tree Cell Value First Match
    [Documentation]    This keyword selrcts first instance of the target cell value on a column. Fails when there are no match found.
    ...    @author: hstone    27SEP2019    Initial create
    [Arguments]    ${sJavaTree_Locator}    ${sTargetCellValue}    ${sColumnName}    
    Set Test Variable    ${sFetchedEvent}    ${EMPTY}       
    ${JavaTree_Table}    Mx LoanIQ Store Java Tree Items To Array    ${sJavaTree_Locator}    Table
    ${JavaTree_Table}    Split To Lines    ${JavaTree_Table}
    ${JavaTree_ItemCount}    Get Length    ${JavaTree_Table}
    ${JavaTree_ItemCount_NoHeader}    Evaluate    ${JavaTree_ItemCount}-1
      
    :FOR    ${Row_Num}    IN RANGE    ${JavaTree_ItemCount_NoHeader}
    \    ${sFetchedEvent}    Get Java Tree Cell Value    ${sJavaTree_Locator}    ${Row_Num}    ${sColumnName}
    \    Run Keyword If    '${sTargetCellValue}'=='${sFetchedEvent}'    Run Keywords
         ...    Mx LoanIQ Select String     ${sJavaTree_Locator}     ${sTargetCellValue}   
         ...    AND    Exit For Loop
    [Return]    ${sFetchedEvent}
    
Get Java Tree Cell Value
    [Documentation]    This keyword gets the cell value of the supplied java tree locator given the row number and the column name. First entry has index of 0.
    ...    @author: hstone    13SEP2019    Initial create
    ...    @update: hstone    23SEP2019    Updated to Generic Java Tree Cell Value getter
    [Arguments]    ${sJavaTree_Locator}    ${sRowNum}    ${sColumnName}    

    ${JavaTree_Table}    Mx LoanIQ Store Java Tree Items To Array    ${sJavaTree_Locator}    Table
    ${JavaTree_Table}    Split To Lines    ${JavaTree_Table}
    ${JavaTree_ItemCount}    Get Length    ${JavaTree_Table}
    
    ${TableHeaders}    Replace String    @{JavaTree_Table}[0]    \r    ${Empty} 
    ${EventsHeader_List}    Split String    ${TableHeaders}    \t   
    ${Item_List}    Create List    
    
    :FOR    ${Item_Num}    IN RANGE    1    ${JavaTree_ItemCount}
    \    Exit For Loop If    ${Item_Num}==${JavaTree_ItemCount}
    \    ${Item_Row}    Replace String    ${JavaTree_Table}[${Item_Num}]    \r    ${Empty}
    \    ${Item_Row}    Strip String    ${Item_Row}    left    ,
    \    Log    ${Item_Num}:${JavaTree_Table}[${Item_Num}]
    \    ${Item_Details_List}    Split String    ${Item_Row}    \t
    \    ${Item_Dict}    Create Dictionary
    \    ${Item_Dict}    Create Dictionary for Key Value List    ${EventsHeader_List}    ${Item_Details_List}    
    \    Append To List    ${Item_List}    ${Item_Dict}

    Log    (Validate Get Java Tree Cell Value Event) Item_List = ${Item_List}
    ${result}    Get From Dictionary    @{Item_List}[${sRowNum}]    ${sColumnName}
    Log    (Validate Get Java Tree Cell Value Event) result = ${result}
    [Return]    ${result}    
    
Create Dictionary for Key Value List
    [Documentation]    This keyword creates a dictionary a key value list.
    ...        @author: hstone    17SEP2019    Initial create
    [Arguments]    ${sKey_List}    ${sValue_List}
    ${Value_Total}    Get Length    ${sValue_List}
    ${Dictionary}    Create Dictionary 
    Log    Test Log = ${sValue_List}
    :FOR    ${Value_Num}    IN RANGE    ${Value_Total}
    \    ${key}    Set Variable    @{sKey_List}[${Value_Num}]
    \    Log    Test Log = @{sKey_List}[${Value_Num}]
    \    ${value}    Set Variable    @{sValue_List}[${Value_Num}]
    \    ${value}    Convert to Boolean Type if String is True of False    ${value}
    \    Set To Dictionary    ${Dictionary}    ${key}=${value}
    Log    (Create Dictionary for Key Value List) Dictionary = ${Dictionary}
    [Return]    ${Dictionary} 
    
Get Java Tree Row Count
    [Documentation]    This keyword gets the JavaTree total row count.
    ...    @author: hstone    13SEP2019    Initial create
    [Arguments]    ${sJavaTree_Locator}   
    ${JavaTree_Table}    Mx LoanIQ Store Java Tree Items To Array    ${sJavaTree_Locator}    Table
    ${JavaTree_Table}    Split To Lines    ${JavaTree_Table}
    ${JavaTree_ItemCount}    Get Length    ${JavaTree_Table}
    ${JavaTree_ItemCount}    Evaluate    ${JavaTree_ItemCount}-1
    Log    (Get Java Tree Row Count) JavaTree_ItemCount = ${JavaTree_ItemCount}
    [Return]    ${JavaTree_ItemCount}
    
Verify if String Exists as Java Tree Header
    [Documentation]    This keyword checks if the input string exists at the supplied Java Tree Locator.
    ...    @author: hstone    08JAN2020    Initial create
    [Arguments]    ${sJavaTree_Locator}    ${sStringToFind}    
    ${bExistenceStatus}    Set Variable    ${FALSE}
    
    ${JavaTree_Table}    Mx LoanIQ Store Java Tree Items To Array    ${sJavaTree_Locator}    Table
    ${JavaTree_Table}    Split To Lines    ${JavaTree_Table}
    ${TableHeaders}    Replace String    @{JavaTree_Table}[0]    \r    ${Empty} 
    ${TableHeader_List}    Split String    ${TableHeaders}    \t   
    
    :FOR    ${sTableHeader}    IN    @{TableHeader_List}
    \    Exit For Loop If    ${bExistenceStatus}==${TRUE}
    \    ${sTableHeader}    Convert To Uppercase    ${sTableHeader}
    \    ${sStringToFind}    Convert To Uppercase    ${sStringToFind}
    \    ${bExistenceStatus}    Run Keyword And Return Status    Should Be Equal As Strings    ${sTableHeader}    ${sStringToFind}     

    [Return]    ${bExistenceStatus}
    
Click Loan IQ Element
    [Documentation]    Click on element identified by locator.
    ...    @author:  ap    27AAUG2020    Initail create
    [Arguments]    ${sElement_Locator}
    mx LoanIQ click    ${sElement_Locator}
    
Select Loan IQ Java Window Tab
    [Documentation]    Used to select the Java window tab.
    ...    @author:  ap    27AAUG2020    Initail create
    ...    locator, input, Processtimeout=180
    [Arguments]    ${sJavaWindow_Locator}    ${sInput}    ${sTimeout}=180    
    Mx LoanIQ Select Window Tab    ${sJavaWindow_Locator}    ${sInput}    ${sTimeout}    

Open Deal Notebook If Not Present
    [Documentation]    This keyword opens an existing deal on LIQ if the Deal notebook does not exists.
    ...    @author: dahijara    - Initial create
    [Arguments]    ${sDeal_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    ### Keyword Process ###
    ###Open Deal Notebook If Not present###
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_Window}    VerificationData="Yes"
    Run Keyword If    ${Status}!=${True}    Open Existing Deal    ${Deal_Name}
    ...    ELSE    Log    Deal Notebook Is Already Displayed