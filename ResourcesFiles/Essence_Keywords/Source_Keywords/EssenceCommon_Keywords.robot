*** Settings ***
Resource    ../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Login To Essence
    [Documentation]    This keyword is created to login in Essence
    ...    @author: mnanquil    19FEB2019    initial draft
    ...    @update: mnanquil    11APR2019    added replace variables to handle Essence URL.
    ...    @update: rtarayao    31OCT2019    - added logic to handle SSO flag
    ...    @update: jdelacru    06NOV2019    - added waiting time after loading landing page
     
    ${ESSENCE_SSO_URL}    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    Replace Variables    ${ESSENCE_SSO_URL}
    ${ESSENCE_URL}    Run Keyword If    '${SSO_ENABLED.upper()}'=='NO'    Replace Variables    ${ESSENCE_URL}
    
    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    Run Keywords    Open Browser    ${ESSENCE_SSO_URL}    ${BROWSER}
    ...    AND    Maximize Browser Window
    ...    AND    Wait Until Element Is Visible     ${Essence_SearchBox_Locator}
    ...    AND    Display Message    Page Successfully loaded.
    ...    AND    Capture Page Screenshot
    ...    ELSE IF    '${SSO_ENABLED.upper()}'=='NO'    Run Keywords    Open Browser    ${ESSENCE_URL}    ${BROWSER}
    ...    AND    Maximize Browser Window
    ...    AND    Wait Until Element Is Visible     ${Essence_Username_Textfield}    30s
    ...    AND    Mx Input Text    ${Essence_Username_Textfield}    ${ESS_USERNAME}
    ...    AND    Mx Input Text    ${Essence_Password_Textfield}    ${ESS_PASSWORD}
    ...    AND    Click Element    ${Essence_SignIn_Button}
    ...    AND    Wait Until Element Is Visible     ${Essence_SearchBox_Locator}
    ...    AND    Display Message    Page Successfully loaded.  
    ...    AND    Capture Page Screenshot     

Search Process in Essence
    [Documentation]    This keyword will search for the specific process in essence. 
    ...    @author: mnanquil    20FEB2019    - initial draft
    ...    @update: hstone      22APR2020    - Replaced 'Input Text' with 'Mx Select Element and Input Text Without Key Press'
    [Arguments]    ${sProcessName}
    ${sProcessName}    Set Variable    ${sProcessName}
    ${Essence_MenuProcessName_Locator}    Replace Variables    ${Essence_MenuProcessName_Locator}
    ${Essence_TabMenuName_Locator}    Replace Variables    ${Essence_TabMenuName_Locator}
    Wait Until Element Is Visible    ${Essence_SearchBox_Locator}
    Mx Select Element and Input Text Without Key Press    ${Essence_SearchBox_Locator}    ${sProcessName}
    Mx Click Element    ${Essence_MenuProcessName_Locator}
    Wait Until Element Is Visible    ${Essence_TabMenuName_Locator}
    Display Message    Successfully searched ${sProcessName}
    Capture Page Screenshot

Logout from Essence
    [Documentation]    This keyword is used to logout user from Party
    ...    @update: rtarayao    31OCT2019    - initial create
    ...    @update: dfajardo    19Jun2020    - Replaced undefined variables 'FBE_Help_Menu' and 'FBE_Logout_Button' with defined variables 'Essence_HelpMenu_Button' and 'Essence_LogOut_Button'
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${Essence_HelpMenu_Button}
    Mx Click Element    ${Essence_LogOut_Button}
    Run Keyword And Ignore Error    Wait Until Page Contains    © 2018 Finastra
    Wait Until Browser Ready State
	Close Browser

Get FBE System Date
    [Documentation]    This keyword is used to get FBE System Date from Essence
    ...    @author: hstone    21APR2020    - initial create

    Search Process in Essence    Change of Business Date
    ${FBE_System_Date}    Mx Get Element Value    ${Essence_ChangeOfBusinessDate_BankFusionBusinessDate_Textfield}

    [Return]    ${FBE_System_Date}
  
   
Validate FBE Zone and Get Zone Business Date
    [Documentation]    This keyword is used to check FBE Zone and retrieve Zone's Business Date 
    ...    author: rtarayao    31JUL2020    - initial create
    [Arguments]    ${sZoneandCode}    ${sZoneName}=None    ${sBranch}=None
    ${ZoneandCodeList}    Split String    ${sZoneandCode}    |
    Log    ${ZoneandCodeList}
    ${sZoneandCodeLen}    Get Length    ${ZoneandCodeList}
    ${FBE_SystemDate_List}    Create List
    :FOR    ${Index}    IN RANGE    ${sZoneandCodeLen}
    \    ${sZoneandCode}    Get From List    ${ZoneandCodeList}    ${Index}    
    \    ${ZoneText}    Get Text    ${Essence_Zone_Textfield}
    \    Log    '${ZoneText.strip()}'=='${sZoneandCode}' 
    \    Run Keyword If    '${ZoneText.strip()}'=='${sZoneandCode}'    Log    Zone is correct
         ...    ELSE    Change FBE Zone    ${sZoneandCode}    ${sZoneName}    ${sBranch}
    \    ${FBE_SystemDate}    Get FBE System Date
    \    Append To List    ${FBE_SystemDate_List}    ${FBE_SystemDate}           
    \    Mx Click Element    ${Essence_ChangeofBusinessDate_Close_Button}
    
    [Return]    ${FBE_SystemDate_List}
    
    
Change FBE Zone
    [Documentation]    This keyword is used to change Essence Zone.
    ...    author: rtarayao    31JUL2020    - initial create
    ...    @update: clanding    11SEP2020    - added closing of tab
    [Arguments]    ${sZoneandCode}    ${sZoneName}    ${sBranch}
    Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${Essence_Zone_Textfield}
    Mx Input Text    ${Essence_Zone_DropdownList}    ${sZoneName}
    Mx Input Text    ${Essence_Branch_DropownList}    ${sBranch}
    Click Button    ${Essence_Next_Button}
    ${SuccessMessage}    Mx Get Element Value    ${Essence_SwitchZone_SuccessfulMessage_Text}
    Run Keyword If    '${SuccessMessage}'=='${ZONEBRANCH_SUCCESSMESSAGE}'    Log    Zone/Branch is successfully changed.
    ...    ELSE    FAIL    Zone/Branch switching is not successful or message is not dislayed. 
    ${ZoneText}    Get Text    ${Essence_Zone_Textfield}
    Run Keyword If    '${ZoneText.strip()}'=='${sZoneandCode}'    Log    Zone is correct
    ...    ELSE    FAIL    Zone switching is not successful.
    Click Element    ${Essence_Close_Menu_Locator}    

Get Table Value Containing Row Value in Essence
    [Documentation]    This keyword is used get row value of column sHeaderName using sReferenceRowValue from column sReferenceHeaderValue
    ...    @author: clanding    10SEP2020    - initial create
    [Arguments]    ${eTableHeaderLocator}    ${eTableRowLocator}    ${sReferenceHeaderValue}    ${sReferenceRowValue}    ${sHeaderName}    
    
    ### Get Header Index of the Reference Value ###
    ${HeaderCount}    SeleniumLibraryExtended.Get Element Count    ${eTableHeaderLocator}
    ${HeaderCount}    Evaluate    ${HeaderCount}+1
    :FOR    ${ReferenceHeaderIndex}    IN RANGE    1    ${HeaderCount}
    \    ${ReferenceHeaderValue}    Get Text    ${eTableHeaderLocator}\[${ReferenceHeaderIndex}]//div
    \    Exit For Loop If    '${ReferenceHeaderValue}'=='${sReferenceHeaderValue}'
    
    ### Get Header Index of the Actual Value to be get ###
    ${HeaderCount}    SeleniumLibraryExtended.Get Element Count    ${eTableHeaderLocator}
    ${HeaderCount}    Evaluate    ${HeaderCount}+1
    :FOR    ${HeaderIndex}    IN RANGE    1    ${HeaderCount}
    \    ${HeaderValue}    Get Text    ${eTableHeaderLocator}\[${HeaderIndex}]//div
    \    Exit For Loop If    '${HeaderValue}'=='${sHeaderName}'
	
    ${RefRowValueCount}    SeleniumLibraryExtended.Get Element Count    ${eTableRowLocator}//td\[contains(text(),"${sReferenceRowValue}")]/parent::tr/td\[${HeaderIndex}]
	Run Keyword If    ${RefRowValueCount}==0    Run Keyword And Continue On Failure    FAIL    Reference Row Value '${sReferenceRowValue}' not found.
	Return From Keyword If    ${RefRowValueCount}==0    REFNOTFOUND
	${RowValue}    Get Text    ${eTableRowLocator}//td\[contains(text(),"${sReferenceRowValue}")]/parent::tr/td\[${HeaderIndex}]
    
    [Return]    ${RowValue}    
    
Exit Displayed Process
    [Documentation]    This keyword is used to close existing Process in displayed.
    ...    @author: clanding    11SEP2020    - initial create    
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/GL/Essence_DisplayedProcess.png
    Click Element    ${Essence_Close_Menu_Locator}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/GL/Essence_NoDisplayProcess.png

    
    
    



    
    