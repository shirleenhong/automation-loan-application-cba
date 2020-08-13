*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***

Login User to Party
    [Documentation]    This keyword used to launch browser and login user to Party app.
    ...    @author: jcdelacruz
    ...    @update: fmamaril    22APR2019    Added arguments for the URL and cater SSO/NSSO
    ...    @update: amansuet    17MAR2020    - optimized script and updated based on automation standard guidelines
    [Arguments]    ${sUsername}    ${sPassword}    ${sUser_Link}    ${sUser_Port}    ${sParty_SSO_URL_Suffix}    ${sParty_HTML_Credentials}    ${sSSO_Enabled}    ${sParty_SSO_URL}
    
    Log    ${sParty_HTML_Credentials} 
    ${PARTY_HTML_CREDENTIALS}    Replace Variables    ${sParty_HTML_Credentials}
    Log    ${PARTY_HTML_CREDENTIALS}
    
    Log    ${sParty_SSO_URL}
    ${PARTY_SSO_URL}    Replace Variables    ${sParty_SSO_URL}    
    Log    ${PARTY_SSO_URL}

    Run Keyword If    '${sSSO_Enabled}'=='YES'    Open Browser    ${PARTY_SSO_URL}    ${BROWSER}    
    ...    ELSE    Open Browser    http://${PARTY_URL}    ${BROWSER}    
    Maximize Browser Window
    Wait Until Browser Ready State
    Run Keyword If    '${sSSO_Enabled}'=='NO'    Run Keywords    Mx Input Text    ${Party_Username_Textbox}    ${sUsername}
    ...    AND    Mx Input Text    ${Party_Password_Textbox}    ${sPassword}
    ...    AND    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyLoginPage-{index}.png            
    ...    AND    Mx Click Element    ${Party_SignIn_Button}

    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${Party_SignIn_Button}    ${PARTY_TIMEOUT}
    Wait Until Browser Ready State
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${Party_HomePage_Process_TextBox}    ${PARTY_TIMEOUT}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}

Logout User on Party
    [Documentation]    This keyword is used to logout user from Party app.
    ...    @update: gerhabal    10SEP2019    - added    "Run Keyword And Continue On Failure" before "Wait Until Page Contains" keyword
    ...    @update: amansuet    20MAR2020    - optimized script and updated based on automation standard guidelines
    
    Mx Click Element    ${Party_HomePage_HelpMenu_Button}
    Mx Click Element    ${Party_HomePage_HelpMenu_Logout_Button}

    ${IsVisible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Party_LoginPage_Form}
    Run Keyword If    ${IsVisible}==${True}    Log    User have successfully logout.
    ...    ELSE    Log    User have unsuccessfully logout.    level=ERROR
    Wait Until Element Is Visible    ${Party_LoginPage_Form}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyLoginPage-{index}.png 
	Close Browser

Search Process in Party
    [Documentation]    This keyword will search for the specific process in party. 
    ...    @author: clanding    16APR2019    - initial create
    ...    @update: amansuet    20MAR2020    - moved from PartyCommon to Party Generic Keyword
    [Arguments]    ${sProcess_Name}
    
    ${sProcess_Name}    Set Variable    ${sProcess_Name}
    ${Party_HomePage_ProcessName_MenuItem}    Replace Variables    ${Party_HomePage_ProcessName_MenuItem}
    ${Party_HomePage_ProcessName_Tab}    Replace Variables    ${Party_HomePage_ProcessName_Tab}
    Wait Until Element Is Visible    ${Party_HomePage_Process_TextBox}
    Input Text    ${Party_HomePage_Process_TextBox}    ${sProcess_Name}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartySearchPage-{index}.png
    Mx Click Element    ${Party_HomePage_ProcessName_MenuItem}
    Wait Until Element Is Visible    ${Party_HomePage_ProcessName_Tab}
    Display Message    Successfully searched ${sProcess_Name}
    Capture Page Screenshot

Validate Page Screen is Displayed
    [Documentation]    This keyword is used to validate page screen if successfully displayed.
    ...    @author: amansuet    20MAR2020    - initial create
    [Arguments]    ${sPage_Name}
    
    ${sPage_Name}    Replace Variables    ${sPage_Name}
    ${Party_Page_Title}    Replace Variables    ${Party_Page_Title}
    ${IsVisible}    Run Keyword And Return Status    Element Should Be Visible    ${Party_Page_Title}
    Run Keyword If    ${IsVisible}==${True}    Log    '${sPage_Name}' is successfully displayed.
    ...    ELSE    Log    '${sPage_Name}' is NOT displayed.    level=ERROR
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/${sPage_Name}-{index}.png
    Element Should Be Visible    ${Party_Page_Title}

Generate Unique Number or Text for Party
    [Documentation]    This keyword generates a unique number or text for Party app.
    ...    @author: amansuet    20MAR2020    - initial create
    [Arguments]    ${sName_Prefix}=None
    
    ${Result_In_Numbers}    Get Current Date    result_format=%H1%M%S  

    ${Generated_Value}    Run Keyword If    '${sName_Prefix}'!='None'    Catenate    SEPARATOR=    ${sName_Prefix}    ${Result_In_Numbers}
    ...    ELSE IF    '${sName_Prefix}'=='None'    Set Variable    ${Result_In_Numbers}

    [Return]    ${Generated_Value}

Wait Until Loading Page Is Not Visible
    [Documentation]    This keyword is used to wait until loading is completed for Party Application. Default timeout is 30s
    ...    @author: gerhabal    28APR2020    - intial create
    [Arguments]    ${sTimer}=30s

    ${isVisible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Party_Loading_Image}    10s
    Run Keyword If     ${isVisible}==${True}    Wait Until Element Is Not Visible    ${Party_Loading_Image}    ${sTimer}    

Get Short Name Value and Return
    [Documentation]    This keyword is used to get shortname value using party id and short name prefix.
    ...    @author: amansuet    18MAR2020
    [Arguments]    ${sShort_Name_Prefix}    ${sParty_ID}

    ${Short_Name}    Catenate    SEPARATOR=    ${sShort_Name_Prefix}    ${SPACE}${sParty_ID}

    [Return]    ${Short_Name}

Configure Zone and Branch
    [Documentation]    This keyword is used change zone and branch of the user.
    ...    @author: dahijara    09JUN2020    - initial create
    [Arguments]    ${sZone}    ${sBranchName}

    Mx Click Element    ${Party_Zone_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_ZONEANDBRANCHSELECTION_PAGETITLE}
    Mx Input Text    ${Party_ZoneBranchSelectionPage_Zone_TextBox}    ${sZone}
    Mx Input Text    ${Party_ZoneBranchSelectionPage_Branch_TextBox}    ${sBranchName}
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/ZoneAndBranchSelectionPage-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_MESSAGE_PAGETITLE}
    Wait Until Page Contains Element    ${Party_ZoneBranchSelectionPage_SuccessMessage_Label}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/MessagePage-{index}.png
    Mx Click Element    ${Party_ZoneBranchSelectionPage_CloseTab_Button}