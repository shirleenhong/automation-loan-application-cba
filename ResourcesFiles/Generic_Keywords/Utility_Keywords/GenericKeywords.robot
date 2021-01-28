*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Mx Click Element
    [Arguments]    ${locator}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Page Contains Element    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Visible    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Enabled    ${locator}    1s
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click Element    ${locator}
    Wait Until Browser Ready State
       
Mx Double Click Element
    [Arguments]    ${locator}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Page Contains Element    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Visible    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Enabled    ${locator}    1s
    Wait Until Browser Ready State
    Set Focus to Element    ${locator}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Double Click Element    ${locator}
    Wait Until Browser Ready State
        
Wait Until Browser Ready State
    Execute Javascript    return window.load
    :FOR    ${i}    IN RANGE    1    200
    \    ${ready_status}    Execute Javascript    return document.readyState
    \    Exit For Loop If    "${ready_status}"=="complete"
    \    Sleep    1s      
            
Mx Input Text
    [Documentation]    This keyword is used to input text in elements
    ...    @update:    javinzon    - added condition for Mx Scroll Element due to failure in scripts
    [Arguments]    ${locator}    ${text}    ${bScrollToElement}=False
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Page Contains Element    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Visible    ${locator}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Enabled    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click Element    ${locator}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Clear Element Text    ${locator}
    Press Keys    ${locator}    ${text}
    Press Keys    ${locator}    TAB
    Wait Until Browser Ready State
    Run Keyword If    '${bScrollToElement}'=='True'    Mx Scroll Element Into View    ${locator}
    ...    ELSE    Log    Skip Scroll element

Mx Input Text and Press Enter
    [Arguments]    ${locator}    ${text}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Page Contains Element    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Visible    ${locator}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Enabled    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click Element    ${locator}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Clear Element Text    ${locator}
    Press Keys    ${locator}    RETURN
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Input Text    ${locator}    ${text}
    Press Keys    ${locator}    RETURN
    Wait Until Browser Ready State
  
Mx Input Amount
    [Arguments]    ${locator}    ${AllData}    #${OtherLocator}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Page Contains Element    ${locator}    50s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Visible    ${locator}    50s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Enabled    ${locator}    50s
    Clear Element Text    ${locator}
    # Wait Until Page Contains Element    ${OtherLocator}
    # Mx Click Element    ${OtherLocator}
    Click Element    ${locator}
    Press Key    ${locator}    ${AllData}    
    Press Key    ${locator}    \\11
    
Mx Compare
    [Arguments]    ${locator}    ${AllData}
    ${Actual_Value}    Mx Get Element Attribute    ${locator}    value
    Log To Console    ${Actual_Value}
    ${Expected}    Decode Bytes To String    ${AllData}    ASCII
    ${Actual_Value}    Replace String    ${Actual_Value}    ,    ${empty}
    ${Actual_Value}    Replace String    ${Actual_Value}    \n    ${empty}                   
    ${true}    Run Keyword And Return Status    Should Be Equal    ${Actual_Value}       ${Expected}          
    Log To Console    ${true}
    Set Global Variable    ${true}
        
Mx Get Text
    [Arguments]    ${locator}
    [Return]    ${returned_text}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Page Contains Element    ${locator}    10s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Visible    ${locator}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Enabled    ${locator}    10s
    ${returned_text}    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Get Text    ${locator}
    Should Not Be Empty    ${returned_text}  
    
Mx Get Element Attribute
    [Arguments]    ${locator}    ${attribute}
    [Return]    ${returned_text}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Page Contains Element    ${locator}    10s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Visible    ${locator}    20s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Enabled    ${locator}    10s
    ${returned_text}    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Get Element Attribute    ${locator}@${attribute}
    Should Not Be Empty    ${returned_text}          
       
Mx Select option from list
    [Arguments]   ${fieldlocator}    ${name}    ${listname}
    Wait Until Element Is Enabled    ${fieldlocator}    20s
    Clear Element Text    ${fieldlocator}
    Wait Until Keyword Succeeds    20x    2s    Input Text    ${fieldlocator}     ${name}
    Wait Until Keyword Succeeds    20x    2s    Click Element    ${listname}
    
Mx Check for a leap Year
    [Arguments]    ${Date}
    [Return]    ${noofdays}
    ${Date}    Get Current Date    result_format=%Y-%m-%d
    ${datetime}    Convert Date    ${Date}     datetime
    ${leapyear}    Run Keyword And Continue On Failure    Evaluate    ${datetime.year}/4.00    
    ${strleap}    Convert To String    ${leapyear}    
    ${split}    Split String    ${strleap}    separator=.
    ${noofdays}    Run Keyword If    "${split.pop(1)}"=="0"    Set Variable    366    ELSE    Set Variable    365
    Log To Console    ${noofdays}
    
Mx Move To Frame
    [Documentation]    Moves to number of frames as passed in argument.
    [Arguments]  @{List}
    :FOR    ${frame}    IN    @{List}
    \    Wait Until Page Contains Element    ${frame}    30s
    \    ${Status}    Run Keyword And Return Status    Select Frame    ${frame}
    [Return]    ${Status}
    
Mx Move To Frame And Click Element
    [Documentation]    Moves to number of frames till the element is found and click on that element. 
    [Arguments]    ${element}    ${list}
    Wait Until Browser Ready State
    ${Status}    Mx Move To Frame    @{list}
    Run Keyword If    '${Status}' == 'True'    Wait Until Page Contains Element    ${element}    10s    ELSE    Fail    Frame is not selected
    Wait Until Element Is Visible    ${element}    10s
    # Sleep    3s
    Click Element    ${element}
    Unselect Frame
    
Mx Move To Frame And Input Text
    [Documentation]    Moves to number of frames till the element is found and click on that element. 
    [Arguments]    ${element}    ${text}    ${list}
    ${Status}    Mx Move To Frame    @{list}
    Run Keyword If    '${Status}' == 'True'    Wait Until Page Contains Element    ${element}    10s    ELSE    Fail    Frame is not selected
    Wait Until Element Is Enabled    ${element}    10s
    Sleep    3s
    Mx Input Text    ${element}    ${text}
    Unselect Frame

Mx Set IE Capabilities
    [Documentation]    Keyword is used to set desired IE capabilities to launch tests on IE browser.
    ${defaultIECapabilities}=    Evaluate    sys.modules["selenium.webdriver"].DesiredCapabilities.INTERNETEXPLORER    sys,selenium.webdriver
    # Set To Dictionary    ${defaultIECapabilities}    enablePersistentHover=${FALSE}
    # Set To Dictionary    ${defaultIECapabilities}    requireWindowFocus=${FALSE}
    # Set To Dictionary    ${defaultIECapabilities}    ie.ensureCleanSession=${TRUE}
    Set To Dictionary    ${defaultIECapabilities}    ignoreZoomSetting=${TRUE}
    Set To Dictionary    ${defaultIECapabilities}    nativeEvents=${FALSE}
    Set To Dictionary    ${defaultIECapabilities}    ignoreProtectedModeSettings=${TRUE}
     # Set To Dictionary   ${defaultIECapabilities}   ie.forceCreateProcessApi=${TRUE}
    Set To Dictionary   ${defaultIECapabilities}   ie.browserCommandLineSwitches=-private
    
    
Creating the base directory
    [Arguments]    ${Project_Name}    ${DataSet}
    [Documentation]
    ...    This keyword is used to generate the base directory
    ${testfolder}    Convert To String    ${CURDIR}
    Log To Console    ${testfolder}
    ${split}    Split String    ${testfolder}    ${Project_Name}
    Log To Console    ${split}
    ${SVN_Path}    Get From List    ${split}    0
    Log To Console    ${SVN_Path}
    ${SVN}    Replace String    ${SVN_Path}    \\    \\\\
    Log To Console    ${SVN}
    ${RequiredPath}    Catenate    ${SVN}${Project_Name}\\\\${DataSet}
    Set Global Variable    ${RequiredPath}    
    Log To Console    ${RequiredPath}
    
Mx Open LIQ and UFT
    Mx Launch UFT    Visibility=True    UFTAddins=Java    Processtimeout=200
    Mx LoanIQ Launch    Processtimeout=300

Verify If Text Value Exist as Static Text on Page
    [Documentation]    This keyword verifies if static object exist in page
    ...    @author: fmamaril
    ...    <update> bernchua: Added wildcard before and after validated static text.
    ...    <update> bernchua: Added "displayed:=1" property in JavaWindow locator.
    [Arguments]    ${WindowName}    ${Text to Validate}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${WindowName}.*","displayed:=1").JavaStaticText("attached text:=.*${Text to Validate}.*")    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${WindowName}.*","displayed:=1").JavaStaticText("attached text:=.*${Text to Validate}.*")    VerificationData="Yes"    Processtimeout=5
    Run Keyword If   '${result}'=='True'    Log    "${Text to Validate}" is displayed on ${WindowName} window.
    ...     ELSE    Log    "${Text to Validate}" is not displayed on ${WindowName} window.

Verify If Text Value Exist as Java Tree on Page
    [Documentation]    This keyword verifies if java tree object exist in page
    ...    @author: makcamps    11JAN2021    - initial create
    [Arguments]    ${sWindowName}    ${sTextToValidate}

    ### Keyword Pre-processing ###
    ${WindowName}    Acquire Argument Value    ${sWindowName}
    ${TextToValidate}    Acquire Argument Value    ${sTextToValidate}

    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${WindowName}.*","displayed:=1").JavaTree("developer name:=.*${TextToValidate}.*")    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${WindowName}.*","displayed:=1").JavaTree("developer name:=.*${TextToValidate}.*")    VerificationData="Yes"    Processtimeout=5
    Run Keyword If   '${result}'=='True'    Log    "${TextToValidate}" is displayed on ${WindowName} window.
    ...     ELSE    Run Keyword And Continue On Failure    Fail    "${TextToValidate}" is not displayed on ${WindowName} window.
 
Verify If Text Value Exist in Textfield on Page
    [Documentation]    This keyword verifies if static object exist in page
    ...    @author: fmamaril
    ...    <update> bernchua: Added "displayed:=1" property in JavaWindow locator.
    [Arguments]    ${WindowName}    ${Text to Validate}  
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${WindowName}.*","displayed:=1").JavaEdit("value:=${Text to Validate}")    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure
    ...    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${WindowName}.*","displayed:=1").JavaEdit("value:=${Text to Validate}")    Processtimeout=5    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "${Text to Validate}" is displayed on ${WindowName} window.
    ...     ELSE    Log    "${Text to Validate}" is not displayed on ${WindowName} window.     
    
Validate Loan IQ Details
    [Documentation]    This keyword validates the displayed Loan IQ details in the application vs the data in excel
    ...    @author: jcdelacruz/ghabal
    ...    @update: bernchua    Added property 'value' in Mx LoanIQ Get Data keyword.
    ...    @update: jdelacru    13DEC2019    - Changed the argument in getting value for UI
    [Arguments]     ${Value_fromExcel}    ${Value_fromUI}
    ${Value_fromUI}  Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${Value_fromUI}    value%Value_fromUI
    Log    ${Value_fromExcel} - This is the data retrieved from Excel Sheet
    Log    ${Value_fromUI} - This is the data displayed in the UI/application
    Run Keyword And Continue On Failure    Should Be Equal   ${Value_fromUI}    ${Value_fromExcel}
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal   ${Value_fromUI}    ${Value_fromExcel}    
    Run Keyword If   '${result}'=='True'    Log    "${Value_fromExcel}" - data retrieved from Excel Sheet MATCHES "${Value_fromUI}" - the data displayed in the UI/application
    ...     ELSE    Log    "${Value_fromExcel}" - data retrieved from Excel Sheet DOES NOT MATCH "${Value_fromUI}" - the data displayed in the UI/application

Validate Window Title
    [Documentation]    This keyword validates any Window Name with simple text 
    ...    @author: ghabal
    [Arguments]    ${Window_Name}
    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    JavaWindow("title:=${Window_Name}.*","tagname:=${Window_Name}.*")    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure     Mx LoanIQ Verify Object Exist    JavaWindow("title:=${Window_Name}.*","tagname:=${Window_Name}.*")    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    "${Window_Name}" window has been displayed.
    ...     ELSE    Log    "${Window_Name}" window has been not displayed.         

Validate if Element is Disabled
    [Documentation]    This keyword validates if Element is disabled
    ...    @author: ghabal    
    [Arguments]     ${Field_fromUI}    ${Field_Label} 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}    enabled%0
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}    enabled%0
    Run Keyword If   '${result}'=='True'    Log    '${Field_Label}' element is confirmed disabled
    ...     ELSE    Log    '${Field_Label}' element is confirmed enabled

Validate if Element is Enabled
    [Documentation]    This keyword validates if Element is enabled
    ...    @author: ghabal    
    [Arguments]     ${Field_fromUI}    ${Field_Label} 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}    enabled%1
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}    enabled%1
    Run Keyword If   '${result}'=='True'    Log    '${Field_Label}' element is confirmed enabled
    ...     ELSE    Log    '${Field_Label}' element is confirmed disabled

Validate if Element is Unchecked
    [Documentation]    This keyword validates if Element is unchecked
    ...    @author: ghabal    
    [Arguments]     ${Field_fromUI}    ${Field_Label} 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}       value%0
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}   value%0
    Run Keyword If   '${result}'=='True'    Log    '${Field_Label}' element is confirmed unchecked
    ...     ELSE    Log    '${Field_Label}' element is confirmed checked

Validate if Element is Checked
    [Documentation]    This keyword validates if Element is checked
    ...    @author: ghabal    
    [Arguments]     ${Field_fromUI}    ${Field_Label} 
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}       value%1
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}   value%1
    Run Keyword If   '${result}'=='True'    Log    '${Field_Label}' element is confirmed checked
    ...     ELSE    Log    '${Field_Label}' element is confirmed unchecked

Compare Two Arguments
    [Documentation]    This keyword compare if two arguments from web app and excel are equal.
    ...    @author: jcdelacruz
    ...    @update: gerhabal    09SEP2019    - added condition to strip string to value from UI to remove space before comparing    
    [Arguments]    ${value_from_sheet}    ${value_from_ui}
    
    Wait Until Page Contains Element    ${value_from_ui}    
    ${value_from_ui}    Get Value    ${value_from_ui}
    ${value_from_ui}    Strip String    ${value_from_ui}
    Log    ${value_from_ui}
    Run Keyword And Continue On Failure    Should Be Equal   ${value_from_sheet}    ${value_from_ui}        
    Log    ${value_from_sheet} - This is the data retrieved from Excel Sheet
    Log    ${value_from_ui} - This is the data saved in the UI/application
    
Compare Two Normalized Arguments
    [Documentation]    This keyword compares two normalized arguments from web app and excel if they are equal. Both expected and actual text values are
    ...    both converted to upper case before comparison.
    ...    @author: nbautist    16NOV2020    - initial create
    [Arguments]    ${value_from_sheet}    ${value_from_ui}
    
    Wait Until Page Contains Element    ${value_from_ui}    
    ${value_from_ui}    Get Value    ${value_from_ui}
    ${value_from_ui}    Strip String    ${value_from_ui}
    Log    ${value_from_ui}
    ${value_from_sheet}    Convert To Uppercase    ${value_from_sheet}
    ${value_from_ui}    Convert To Uppercase    ${value_from_ui}
    Run Keyword And Continue On Failure    Should Be Equal   ${value_from_sheet}    ${value_from_ui}
            
Generate Name Test Data
    [Documentation]    This keyword generates value that can be added to a variable to make it unique.
    ...    @author: jcdelacruz
    [Arguments]    ${NameTestData}
    ${datetime.microsecond}    Get Current Date    result_format=%d%m%Y%H%M%S
    log to console    ${datetime.microsecond}
    ${GeneratedName} =    Catenate    SEPARATOR=    ${NameTestData}    ${datetime.microsecond}
    [Return]    ${GeneratedName}
    
Select Actions
    [Arguments]    ${sActionName}
    [Documentation]    This keyword selects specific Action in LIQ tree.
    ...    e.g. Select Actions    [Actions];Deal
    ...    @author: fmamaril
    ...    <update> bernchua 11/21/2018: added mx activate before click.
    ...    <update> ritragel 12/06/2018: added maximize after activating window
    ...    @update: ehugo    30JUN2020    - added keyword pre-processingl added screenshot

    ### GetRuntime Keyword Pre-processing ###
    ${ActionName}    Acquire Argument Value    ${sActionName}

    Mx LoanIQ Activate Window    ${LIQ_Window}
    Mx LoanIQ Maximize    ${LIQ_Window}    
    Mx LoanIQ Click    ${LIQ_Actions_Button}
    Mx LoanIQ Active Javatree Item    ${LIQ_Tree}    ${ActionName}
    Take Screenshot    ${Screenshot_Path}

Auto Generate Name Test Data
    [Arguments]    ${sNameTestData}    ${sTotalNumberToBeGenerated}=1
    [Documentation]    This keywod concatenates current date with given name as a uniques test data.
    ...    @author: fmamaril
    ...    @update: ritragel    30APR2019    Updated logging of the generated dataname
    ...    @update: sahalder    25JUN2020    Added keyword pre-processing steps
    ...    @update: clanding    30JUL2020    Fix tabbing on FOR loop
    
    ### GetRuntime Keyword Pre-processing ###
    ${NameTestData}    Acquire Argument Value    ${sNameTestData}
	${TotalNumberToBeGenerated}    Acquire Argument Value    ${sTotalNumberToBeGenerated}

    ${GeneratedNames}    Create List
    :FOR    ${INDEX}    IN RANGE    ${TotalNumberToBeGenerated}
    \    ${random_string}    Generate Random String    3    [UPPER]
    \    ${datetime.microsecond}    Get Current Date    result_format=%d%m%Y%H%M%S
    \    log    ${datetime.microsecond}
    \    ${GeneratedName} =   Catenate    SEPARATOR=  ${NameTestData}   ${datetime.microsecond}${random_string}
    \    Append To List    ${GeneratedNames}    ${GeneratedName}
    ${GeneratedName}    Set Variable    ${GeneratedNames}
    Log    ${GeneratedName}
    [Return]    @{GeneratedName}[0]

Validate Warning Message Box
    [Documentation]    This keyword validates warning message box
    ...    @author: fmamaril
    ...    @update: fmamaril    18MAR2019    Add Handling for Warning Yes Button
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_MessageBox}        VerificationData="Yes"
    Wait Until Keyword Succeeds    30s    3s    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_No_Button}    VerificationData="Yes"
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
Validate Question Message Box
    [Documentation]    This keyword validates question message box
    ...    @author: fmamaril
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Question_MessageBox}        VerificationData="Yes"
    Wait Until Keyword Succeeds    30s    3s    Mx LoanIQ Verify Object Exist    ${LIQ_Question_Yes_Button}        VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Question_No_Button}     VerificationData="Yes"

Validate Informational Message Box
    [Documentation]    This keyword validates warning message box
    ...    @author: rtarayao
    [Tags]    Validation
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Information_MessageBox}        VerificationData="Yes"
    Wait Until Keyword Succeeds    30s    3s    Mx LoanIQ Verify Object Exist    ${LIQ_Information_OK_Button}        VerificationData="Yes"
   
Open Existing Deal in Inquiry Mode
    [Documentation]    This keyword opens an existing deal on LIQ.
    ...    @author: fmamaril
    ...    <update> 9/28/18 bernchua: Added - Mx Click Element If Present    ${LIQ_DealNotebook_InquiryMode_Button}
    ...    <update> 10/30/18 ghabal: Removed - Mx Click Element If Present    ${LIQ_DealNotebook_InquiryMode_Button}
    [Arguments]    ${Deal_Name}
    mx LoanIQ maximize    ${LIQ_Window}
    Select Actions    [Actions];Deal   
    mx LoanIQ enter    ${LIQ_DealSelect_DealIdentifyBy_Textfield}    ${Deal_Name}   
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}
    mx LoanIQ click element if present    ${LIQ_DealNotebook_UpdateMode_Button}
        
Search Existing Deal
     [Documentation]    This keyword search the existing deal on LIQ.
    ...    @author: mgaling
    ...    @update: fmamaril    15MAY2020    - added argument for keyword pre processing
    ...    @update: dahijara    10AUG2020    - Added screenshot
    [Arguments]    ${sDeal_Name}
    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
       
    Select Actions    [Actions];Deal
    mx LoanIQ activate    ${LIQ_DealSelect_Window}   
    mx LoanIQ enter    ${LIQ_DealSelect_DealIdentifyBy_Textfield}    ${Deal_Name}   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealSelect
    mx LoanIQ click    ${LIQ_DealSelect_Search_Button} 
    mx LoanIQ click    ${LIQ_DealListByName_OK_Button}
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ click element if present    ${LIQ_DealNotebook_InquiryMode_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/DealNotebook
    
Close Active Windows
    [Documentation]    This keyword closes main active windows on LIQ.
    ...    @author: fmamaril
    Mx LoanIQ Close    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Close    ${LIQ_OrigPrimaries_Window}
    Mx LoanIQ Close    ${LIQ_PrimariesList_Window}

Generate And Return Deal Name And Alias
    [Documentation]    This keyword generates and returns the Deal Name and Alias.
    ...                @author: bernchua
    [Arguments]    ${Deal_NamePrefix}    ${Deal_AliasPrefix}
    ${Deal_Name}    Generate Name Test Data    ${Deal_NamePrefix}
    ${Deal_Alias}    Generate Name Test Data    ${Deal_AliasPrefix}
    [Return]    ${Deal_Name}    ${Deal_Alias}

Generate Deal Name and Alias
    [Documentation]    This keyword generates deal name and alias on LIQ.
    ...    @author: fmamaril
    ...    @update: hstone    Updated rowid argument to be optional
    [Arguments]   ${Deal_NamePrefix}    ${Deal_AliasPrefix}    ${rowid}=None
    ${Deal_Name}    Auto Generate Name Test Data    ${Deal_NamePrefix}
    log    Deal Name: ${Deal_Name}
    ${Deal_Alias}    Auto Generate Name Test Data    ${Deal_AliasPrefix}
    log    Deal Alias: ${Deal_Alias}
    [Return]    ${Deal_Name}    ${Deal_Alias}
    
Generate Facility Name
    [Documentation]    This keyword generates facility name for LIQ.
    ...    @author: fmamaril
    ...    @update: fmamaril    04SEP2019    Update Facility Name generation
    [Arguments]   ${Facility_NamePrefix}
    ${Facility_Name}    Generate Name Test Data     ${Facility_NamePrefix}
    [Return]    ${Facility_Name}
            
Get System Date on LIQ and Save on Excel
    [Documentation]    This keyword gets the business date from LIQ and saves it on excel.
    ...    @author: fmamaril 
    ...    @update: jdelacru    10APR19    Moved writing to high level keyword
    [Arguments]    ${temp}    ${rowid}    ${DaysSubtractedFromSystemDate}    
    Mx LoanIQ Get Data    ${LIQ_Window}    label%${temp}
    ${SystemDate}    Fetch From Right    ${temp}    :${SPACE}    
    Log    System Date: ${SystemDate}  
    ${SystemDate}    Convert Date    ${SystemDate}     date_format=%d-%b-%Y
    Log    Converted Date: ${SystemDate}
    ${BackDate}    Subtract Time From Date    ${SystemDate}    ${DaysSubtractedFromSystemDate} days    result_format=%d-%b-%Y
    Log    Converted Date: ${BackDate}  
    [Return]    ${BackDate}
             
Get Current Date of Local Machine
    [Documentation]    This keyword is used to get the machine's current date and return the value.
    ...    @author: fmamaril 
    ...    @update: jdelacru    10APR19    Moved writing to high level and  deleted unecessary comments
    ...    @update: rtarayao    12AUG19    Changed the keyword name from "Get Current Date and Save on Excel" to Get Current Date of Local Machine.
    ...                                    Date is based on the Local Timezone.
    ...                                    Argument ${sDateFormat} is optional. User may opt to use other format.    
    [Arguments]    ${sDateFormat}=%Y-%m-%d    
    ${CurrentDate}    Get Current Date    result_format=${sDateFormat} 
    [Return]    ${CurrentDate}    

Get System Date
    [Documentation]    This keyword gets the LIQ System Date
    ...    @update: hstone    28APR2020    - Added Keyword Post-process: Save Runtime Value
    ...                                    - Added Optional Argument: ${sRunTimeVar_SystemDate}
    [Arguments]    ${sRunTimeVar_SystemDate}=None
    Mx Activate Window    ${LIQ_Window}
    ${temp}    Mx LoanIQ Get Data    ${LIQ_Window}    title%temp
    # log to console    Label: ${temp}
    ${SystemDate}    Fetch From Right    ${temp}    :${SPACE}    
    log    System Date: ${SystemDate}
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_SystemDate}    ${SystemDate}
    [RETURN]    ${SystemDate}  

Get Back Dated Current Date
    [Documentation]    This keyword gets the current system date and returns the back dated date by 'NumberOfDaysToBackDate'.
    ...    @author: bernchua
    [Arguments]    ${NumberOfDaysToBackDate}
    ${CurrentDate}    Get System Date
    ${CurrentDate}    Convert Date    ${CurrentDate}    date_format=%d-%b-%Y
    ${Date}    Subtract Time From Date    ${CurrentDate}    ${NumberOfDaysToBackDate} days    result_format=%d-%b-%Y
    [Return]    ${Date}

Get Future Date
    [Documentation]    This keyword adds 'NumberOfDaysToAdd' days to the 'Date',
    ...                and returns a business-day future date.
    ...                @author: bernchua
    [Arguments]    ${Date}    ${NumberOfDaysToAdd}
    ${Date}    Add Time To Date    ${Date}    ${NumberOfDaysToAdd} days    date_format=%d-%b-%Y    result_format=%d-%b-%Y
    
    ${Day}    Convert Date    ${Date}    date_format=%d-%b-%Y    result_format=%a
    
    ${Date}    Run Keyword If    '${Day}'=='Sat'    Add Time To Date    ${Date}    2 days    date_format=%d-%b-%Y    result_format=%d-%b-%Y
    ...    ELSE IF    '${Day}'=='Sun'    Add Time To Date    ${Date}    1 days    date_format=%d-%b-%Y    result_format=%d-%b-%Y
    ...    ELSE    Set Variable    ${Date}
    
    [Return]    ${Date}
            
Validate if Option Condition Window Exist
    [Documentation]    This keyword checks if the Option Condition window exists.
    ...    @author: bernchua
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_FacilityPricing_Interest_OptionCondition_Window}    VerificationData="Yes"
    Return From Keyword    ${status}
    
Check Add Item Type If Value Exists
    [Documentation]    This keyword checks the "Add Item" window if an item exists under 'Type' for add.
    ...    @author: bernchua
    [Arguments]    ${AddItemType}
    ${AddItemType_Value}    Mx LoanIQ Get Data    ${LIQ_AddItemType_List}    value%${AddItemType}
    ${AddItemType_IsEmpty}    Run Keyword And Return Status    Should Be Equal    ${AddItemType_Value}    ${EMPTY}
    Return From Keyword If    ${AddItemType_IsEmpty}==True    True
    Return From Keyword If    ${AddItemType_IsEmpty}==False    False
    
Verify If Warning Is Displayed
    [Documentation]    This keyword checks if a warning message is displayed, and clicks the 'Yes' button.
    ...    @author: bernchua
    :FOR    ${i}    IN RANGE    10
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    \    Exit For Loop If    ${status}==False
    
Verify If Information Message is Displayed
     [Documentation]    This keyword checks if a infomartion message is displayed, and clicks the 'OK' button.
    ...    @author: amansuet

    :FOR    ${i}    IN RANGE    10
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Information_OK_Button}    VerificationData="Yes"
    \    Run Keyword If    ${status}==True    Mx LoanIQ Click    ${LIQ_Information_OK_Button}
    \    Exit For Loop If    ${status}==False
    
Set Fee Selection Details
    [Documentation]    Sets the details in the Fee Selection window.
    ...    @author: bernchua
    [Arguments]    ${Fee_Category}    ${Fee_Type}    ${Fee_RateBasis}
    mx LoanIQ activate    ${LIQ_FeeSelection_Window}    
    Mx LoanIQ Select Combo Box Value    ${LIQ_FeeSelection_Category_Combobox}    ${Fee_Category}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FeeSelection_Type_Combobox}    ${Fee_Type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FeeSelection_RateBasis_Combobox}    ${Fee_RateBasis}    
    ${Verify_FeeCategory}    Run Keyword And Return Status    Validate Loan IQ Details    ${Fee_Category}    ${LIQ_FeeSelection_Category_Combobox}
    ${Verify_FeeType}    Run Keyword And Return Status    Validate Loan IQ Details    ${Fee_Type}    ${LIQ_FeeSelection_Type_Combobox}
    ${Verify_FeeRateBasis}    Run Keyword And Return Status    Validate Loan IQ Details    ${Fee_RateBasis}    ${LIQ_FeeSelection_RateBasis_Combobox}    
    Run Keyword If    ${Verify_FeeCategory}==True and ${Verify_FeeType}==True and ${Verify_FeeRateBasis}==True    mx LoanIQ click    ${LIQ_FeeSelection_OK_Button}

Set Option Condition Details
    [Documentation]    Sets the details in the Option Condition window.
    ...    @author: bernchua
    [Arguments]    ${Interest_OptionName}    ${Interest_RateBasis}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityPricing_Interest_OptionCondition_OptionName_Combobox}    ${Interest_OptionName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_FacilityPricing_Interest_OptionCondition_RateBasis_Combobox}    ${Interest_RateBasis}
    Validate Loan IQ Details    ${Interest_OptionName}    ${LIQ_FacilityPricing_Interest_OptionCondition_OptionName_Combobox}
    Validate Loan IQ Details    ${Interest_RateBasis}    ${LIQ_FacilityPricing_Interest_OptionCondition_RateBasis_Combobox}
    mx LoanIQ click    ${LIQ_FacilityPricing_Interest_OptionCondition_OK_Button}
    
Auto Generate Only 9 Numeric Test Data
    [Documentation]    This keyword concatenates current date as a unique 9 numeric test data
    ...    @author: ghabal  
    [Arguments]    ${NameTestData}
    [Return]    ${GeneratedName}
    ${datetime.microsecond}    Get Current Date    result_format=%H1%M43%S  
    log to console    ${datetime.microsecond}
    ${GeneratedName} =   Catenate    SEPARATOR=  ${NameTestData}   ${datetime.microsecond}
    
Auto Generate Only 5 Numeric Test Data
    [Documentation]    This keyword concatenates current date as a unique 5 numeric test data
    ...    @author: ghabal  
    [Arguments]    ${NameTestData}
    [Return]    ${GeneratedName}
    ${datetime.microsecond}    Get Current Date    result_format=%M1%S  
    log to console    ${datetime.microsecond}
    ${GeneratedName} =   Catenate    SEPARATOR=  ${NameTestData}   ${datetime.microsecond}

Auto Generate Only 4 Numeric Test Data
    [Documentation]    This keyword concatenates current date as a unique 3 numeric test data
    ...    @author: ghabal
    ...    @update: clanding    10AUG2020    - moved Return at the end of the script; added post processing
    [Arguments]    ${NameTestData}    ${sRunTimeVar_GeneratedName}=None
    ${datetime.microsecond}    Get Current Date    result_format=%M%S  
    log to console    ${datetime.microsecond}
    ${GeneratedName} =   Catenate    SEPARATOR=  ${NameTestData}   ${datetime.microsecond}
    
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_GeneratedName}    ${GeneratedName}
    [Return]    ${GeneratedName}
    
Verify Window
    [Documentation]    This keyword will validate if you are in the correct window
    ...    author: @ritragel
    [Arguments]    ${Window_Locator}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Window_Locator}    VerificationData="Yes"
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Window_Locator}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    You are in the correct Window
    ...     ELSE    Log    You are not in the correct Window 

# Read Data From Excel
#         [Documentation]    This keyword will be used for dynamically reading of Excel File supported by Python 3
#     ...    @author: ritragel    25OCT2019    Initial Create
#     [Arguments]    ${sSheetName}    ${sColumnName}    ${rowid}   ${sFilePath}=${ExcelPath}    ${readAllData}=N    ${bTestCaseColumn}=False
#     # Open Excel
#     Open Excel Document    ${sFilePath}    0
    
#     # Get the row id of the test case
#     ${iTestCaseRow}    Run Keyword If    '${bTestCaseColumn}'=='True'    Get Test Case Header Count    ${sSheetName}    Test_Case
#     Run Keyword If    '${iTestCaseRow}'=='None'    Set Test Variable    ${iTestCaseRow}    1
#     Log    ${iTestCaseRow}

#     # Get Column and Row Values
#     ${iColumnCount}    ${iRowCount}    Get Column and Row Index    ${sColumnName}    ${rowid}    ${sSheetName}    ${iTestCaseRow}
    
#     # Read Values
#     ${sDataAll}    Run Keyword If    '${readAllData}'=='Y'    Read Excel Column    ${iColumnCount}    0    ${sSheetName}
#     ${sDataSingle}    Run Keyword If    '${readAllData}'=='N'    Read Excel Cell    ${iRowCount}    ${iColumnCount}    ${sSheetName}   
    
#     Run Keyword If    '${readAllData}'=='Y'    Set Test Variable    ${sData}    ${sDataAll}
#     Run Keyword If    '${readAllData}'=='N'    Set Test Variable    ${sData}    ${sDataSingle}
    
#     Log    ${sData}

#     # Close File and Return Value
#     Close Current Excel Document
#     [Return]    ${sData}
    
# Write Data To Excel
#     [Documentation]    This keyword will be used for dynamically writing to Excel File supported by Python 3
#     ...    @author: ritragel    25OCT2019    Initial Create
#     [Arguments]    ${sSheetName}    ${sColumnName}    ${rowid}    ${newValue}   ${sFilePath}=${ExcelPath}    ${multipleValue}=N    ${bTestCaseColumn}=False
    
    # Open Excel
    # Open Excel Document    ${sFilePath}    0Wait Until Browser Ready State
 
#     # Get the row id of the test case
#     ${iTestCaseRow}    Run Keyword If    '${bTestCaseColumn}'=='True'    Get Test Case Header Count    ${sSheetName}    Test_Case
#     Run Keyword If    '${iTestCaseRow}'=='None'    Set Test Variable    ${iTestCaseRow}    1
#     Log    ${iTestCaseRow}

#     # Get Column and Row Values
#     ${iColumnCount}    ${iRowCount}    Get Column and Row Index    ${sColumnName}    ${rowid}    ${sSheetName}    ${iTestCaseRow}
#     ${iColumnLen}    Read Excel Column    ${iColumnCount}    0    ${sSheetName}      

#     # Write Values
#     Run Keyword If    '${multipleValue}'=='Y'    Write Excel Column    ${iColumnCount}    ${iColumnLen}    ${newValue}    1    ${sSheetName}       
#     Run Keyword If    '${multipleValue}'=='N'    Write Excel Cell    ${iRowCount}    ${iColumnCount}    ${newValue}    ${sSheetName}   
    
#     # Save and Close Document
#     Save Excel Document    ${sFilePath}
#     Close Current Excel Document

Get Test Case Header Count
    [Documentation]    This keyword will be used for dynamically writing to Excel File supported by Python 3
    ...    @author: ritragel    25OCT2019    Initial Create
    [Arguments]    ${sSheetName}    ${sTestCaseColumn}
 
    # Get totals
    ${aRow}    Read Excel Row    1    0    ${sSheetName}
    
    # Get Column Len
    ${iTestCaseColumnCount}    Get Length    ${aRow}
    :FOR    ${x}    IN RANGE    1    ${iTestCaseColumnCount}  
    \    ${header}    Read Excel Cell    1    ${x}    ${sSheetName}    # Check iteration
    \    Run Keyword If    "${header}"=="${sTestCaseColumn}"    Set Test Variable    ${iTestCaseColumnCount}    ${x}
    \    Exit For Loop If    "${header}"=="${sTestCaseColumn}"
    ${iTestCaseColumnCount}    Convert To Integer    ${iTestCaseColumnCount}    
    log    Column Count is: ${iTestCaseColumnCount}
    [Return]    ${iTestCaseColumnCount}

Get Column and Row Index
    [Documentation]   This keyword will get the index of the desired row and column value in the excel
    ...    @author: ritragel    25OCT2019    Initial Create
    [Arguments]    ${sColumnName}    ${rowid}    ${sSheetName}    ${iTestCaseRow}
    
    # Get totals
    ${aColumn}    Read Excel Column    1    0    ${sSheetName}
    ${aRow}    Read Excel Row    1    0    ${sSheetName}
    
    # Get Column Len
    ${iColumnCount}    Get Length    ${aRow}
    :FOR    ${x}    IN RANGE    1    ${iColumnCount}  
    \    ${header}    Read Excel Cell    1    ${x}    ${sSheetName}    # Check iteration
    \    Run Keyword If    "${header}"=="${sColumnName}"    Set Test Variable    ${iColumnCount}    ${x}
    \    Exit For Loop If    "${header}"=="${sColumnName}"
    ${iColumnCount}    Convert To Integer    ${iColumnCount}    
    log    Column Count is: ${iColumnCount}

    # Get Row Len
    ${iRowCount}    Get Length    ${aColumn}
    :FOR    ${y}    IN RANGE    1    ${iRowCount}    
    \    ${header}    Read Excel Cell    ${y}    ${iTestCaseRow}    ${sSheetName}    # Check Iteration
    \    Run Keyword If    "${header}"=="${rowid}"    Set Test Variable    ${iRowCount}    ${y}
    \    Exit For Loop If    "${header}"=="${rowid}"
    ${iRowCount}    Convert To Integer    ${iRowCount}    
    Log    Row Count is: ${iRowCount}
    [Return]    ${iColumnCount}    ${iRowCount}

Write Data to Excel Using Row Index
    [Documentation]    This keyword is used to write data to excel using coordinates and without rowid value. This keyword will get column index using column name,
    ...    then populate data for indicated row index.
    ...    @author: clanding    19FEB2019    - initial create
    ...    @update: clanding    19MAR2019    - added release of process
    ...    @update: dahijara    14NOV2019    - added keyword to close excel file after saving
    [Arguments]    ${sSheetName}    ${sColumnName}    ${iRowCount}    ${sNewValue}   ${sfilePath}=${ExcelPath}
    Log    ${sfilePath}
    Open Excel    ${sfilePath}
    ${ColumnCount}    Get Column Count    ${sSheetName}
    :FOR    ${x}    IN RANGE    0    ${ColumnCount}
    \    ${header}    Read Cell Data By Coordinates    ${sSheetName}    ${x}    0
    \    # Verify header
    \    Run Keyword If    "${header}"=="${sColumnName}"    Set Test Variable    ${ColumnCount}    ${x}
    \    Exit For Loop If    "${header}"=="${sColumnName}"
    Log    ${ColumnCount}
    
    Put String To Cell    ${sSheetName}    ${ColumnCount}    ${iRowCount}   ${sNewValue}
    Save Excel    ${sfilePath}
    Close Current Excel Document
    # ${lib}    Get Library Instance    ExcelLibrary
    # Call Method    ${lib.wb}    release_resources

Verify If Work In Process Window is Not Existing And Navigate
    [Documentation]    This keyword is use to verify if the work in process window is not existing and search 
    ...    @author: jcdelacruz
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_TransactionInProcess_Window}    VerificationData="Yes"
    Run Keyword If    '${Status}'=='False'    mx LoanIQ activate window   ${LIQ_Window}
    Run Keyword If    '${Status}'=='False'    Select Actions    [Actions];Work In Process 

Navigate Notebook Workflow
    [Documentation]    This keyword navigates the Workflow tab of a Notebook, and does a specific transaction.
    ...    
    ...    | Arguments |
    ...    
    ...    'Notebook_Locator' = Locator of the main Notebook window
    ...    'NotebookTab_Locator' = JavaTab locator of the Notebook
    ...    'NotebookWorkflow_Locator' = JavaTree locator of the Workflow object.
    ...    'Transaction' = The type of transaction listed under Workflow. Ex. Send to Approval, Approve, Release
    ...    
    ...    @author: bernchua
    ...    @update: bernchua    11APR2019    Added click element if present for breakfunding and informational messages
    ...    @update: bernchua    17JUL2019    Added condition for Deal Close transaction
    ...    @update: Archana     11June20     Added Pre-processing keyword
    ...    @update: dahijara    03JUL2020    Added keyword for screenshot
    ...    @update: clanding    05AUG2020    Updated hard coded values to global variable
    ...    @update: aramos      30SEP2020    Updated mx LOANIQ click element if present LIQ_Breakfunding_Yes_Button
    ...    @update: aramos      05OCT2020    Updated to insert new code for Transaction - Release Cashflows
    ...    @update: dahijara    09OCT2020    Added screenshot
    ...    @update: fluberio    12NOV2020    Added click element if present to handle EU scenario with multiple pricing options
    ...    @update: dahijara    19NOV2020    Added click element if present to handle RPA scenario for Loan repricing release
    ...    @update: dahijara    20NOV2020    Replaced Mx Click    ${LIQ_Cashflows_MarkSelectedItemForRelease_Button} to Mx LoanIQ select    ${LIQ_Cashflow_Options_MarkAllRelease}
    ...                                      Inserted Release Cashflow condition under Run Keyword If statement.
    ...    @update: mcastro     07DEC2020    Added condition for Rate Setting transaction to click No on Warning pop-up
    ...    @update: dahijara    26JAN2021    Added clicking of Yes on confirmation window when present for Rate Setting
    [Arguments]    ${sNotebook_Locator}    ${sNotebookTab_Locator}    ${sNotebookWorkflow_Locator}    ${sTransaction}    

    ###Pre-processing Keyword##
    
    ${Notebook_Locator}    Acquire Argument Value    ${sNotebook_Locator}
    ${NotebookTab_Locator}    Acquire Argument Value    ${sNotebookTab_Locator}
    ${NotebookWorkflow_Locator}    Acquire Argument Value    ${sNotebookWorkflow_Locator}
    ${Transaction}    Acquire Argument Value    ${sTransaction} 

    mx LoanIQ activate window    ${Notebook_Locator}
    Mx LoanIQ Select Window Tab    ${NotebookTab_Locator}    ${WORKFLOW_TAB}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NotebookWorkflow
    Mx LoanIQ Select Or DoubleClick In Javatree    ${NotebookWorkflow_Locator}    ${Transaction}%d
    Run Keyword If    '${Transaction}'=='Rate Setting'    Run Keywords    Mx LoanIQ click element if present    ${LIQ_LoanRepricing_ConfirmationWindow_Yes_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Question_No_Button}
    ...    ELSE    Validate if Question or Warning Message is Displayed
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NotebookWorkflow
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    3 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_Yes_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Cashflows_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Release Cashflows'    Run Keywords    Mx LoanIQ select    ${LIQ_Cashflow_Options_MarkAllRelease}
    ...    AND    Mx Click    ${LIQ_Cashflows_OK_Button}
    ...    AND     mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/NotebookWorkflow
        
Validate if Question or Warning Message is Displayed
    [Documentation]    This keyword checks continously if a Question or Warning message is displayed, and clicks OK.
    ...    @author: bernchua
    :FOR    ${i}    IN RANGE    10
    \    ${Question_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Question_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Question_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    \    ${Warning_Displayed}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Warning_Yes_Button}    VerificationData="Yes"
    \    Run Keyword If    ${Warning_Displayed}==True    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Exit For Loop If    ${Question_Displayed}==False and ${Warning_Displayed}==False
	
Search Loan
    [Documentation]    This keyword is used to search loan
    ...    @author: jcdelacruz  
    ...    @update: mnanquil
    ...    Added optional argument to set inactive checkbox to off. 
    ...    Default value is on      
    ...    @update: ehugo    01JUN2020    - added keyword pre-processing; added screenshot
    ...                                   - used 'Mx LoanIQ Select Combo Box Value' keyword in selecting value for 'LIQ_OutstandingSelect_Facility_Dropdown'
    [Arguments]    ${sType}    ${sSearch_By}    ${sFacility_Name}    ${inactiveCheckbox}=ON

    ### GetRuntime Keyword Pre-processing ###
    ${Type}    Acquire Argument Value    ${sType}
    ${Search_By}    Acquire Argument Value    ${sSearch_By}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}

    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}    
    mx LoanIQ select    ${LIQ_DealNotebook_Queries_OutstandingSelect}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Existing_RadioButton}    ON
    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Inactive_Checkbox}    ${inactiveCheckbox}
    mx LoanIQ select list    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Type}
    mx LoanIQ select list    ${LIQ_OutstandingSelect_SearchBy_Dropdown}    ${Search_By}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ExistingLoansForFacilityWindow

Copy Alias To Clipboard and Get Data
    [Documentation]    This keyword copies the Alias to clipboard from the Update Information window (F8), pastes it to a blank textbox, and gets the data.
    ...    @author: bernchua
    ...    @update: fmamaril    15MAY2020    - added argument for keyword post processing
    [Arguments]    ${Notebook_Locator}    ${sRuntime_Variable}=None
    mx LoanIQ activate    ${Notebook_Locator} 
    Mx Press Combination    Key.F8
    mx LoanIQ click    ${LIQ_UpdateInformation_CopyAlias_Button}
    mx LoanIQ click    ${LIQ_UpdateInformation_Exit_Button}
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Comments
    mx LoanIQ click    ${LIQ_DealNotebook_Comments_Add_Button}
    mx LoanIQ enter    ${LIQ_CommentsEdit_Comment_Textfield}    /
    mx LoanIQ send keys    ^{V}
    ${Alias}    Mx LoanIQ Get Data    ${LIQ_CommentsEdit_Comment_Textfield}    value%aflias
    mx LoanIQ close window    ${LIQ_CommentsEdit_Window}    
    ${Alias}    Remove String    ${Alias}    /
    ${Alias}    Strip String    ${Alias}    mode=both
    Log To Console    ${Alias}
    
    Save Values of Runtime Execution on Excel File    ${sRuntime_Variable}    ${Alias}
    [Return]    ${Alias}

Convert Number With Comma Separators
    [Documentation]    This keyword is used to convert numbers with comma separators.
    ...    It will also handle numbers with less than four(4) digits and will be returned as is. 
    ...    @author: mnanquil  
    ...    @update: rtarayao    19MAR2019    Updated container and variable format.
    ...    @update: bernchua    11SEP2019    Added convert to string at the start of the code 
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Added Optional Arguments: ${sRunTimeVar_Result}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    ...    @update: javinzon    16DEC2020    - Added Keywords to handle ${Number} with lengths 10,11 and 12
    [Arguments]    ${sNumber}    ${sRunTimeVar_Result}=None

    ### Keyword Pre-processing ###
    ${Number}    Acquire Argument Value    ${sNumber}
    ${Number}    Convert To String    ${Number}
    ${sDecimal}    Fetch From Right    ${Number}    .
    ${Number}    Fetch From Left    ${Number}    .
    ${sNumber2}    Set Variable    ${Number}
    ${sLength}    Get Length    ${Number}
    ${iLength}    Evaluate    int(${sLength})
    ${Number}    Set Variable    ${Number}
    ${6digits}    Run keyword if    ${iLength} == 4 or ${iLength} == 5 or ${iLength} == 6     Get Number 6 Digits    ${Number}
    ${9digits}    Run keyword if    ${iLength} == 7 or ${iLength} == 8 or ${iLength} == 9     Get Number 9 Digits    ${Number}
    ${12digits}    Run keyword if    ${iLength} == 10 or ${iLength} == 11 or ${iLength} == 12     Get Number 12 Digits    ${Number}
    Run keyword if    ${iLength} == 1 or ${iLength} == 2 or ${iLength} == 3     Set Global Variable    ${Number}    ${Number}
    Run keyword if    ${iLength} == 4 or ${iLength} == 5 or ${iLength} == 6     Set Global Variable    ${Number}    ${6digits}
    Run keyword if    ${iLength} == 7 or ${iLength} == 8 or ${iLength} == 9     Set Global Variable    ${Number}    ${9digits}
    Run keyword if    ${iLength} == 10 or ${iLength} == 11 or ${iLength} == 12     Set Global Variable    ${Number}    ${12digits}
    Log    ${Number}.${sDecimal}
    ${sDecimalLength}    Get Length    ${sDecimal}
    ${sDecimal1}    Run keyword if    ${sDecimalLength}==1    Set Variable    ${sDecimal}0
    Run keyword if    ${sDecimalLength}==1    Set Global Variable    ${sDecimal}    ${sDecimal1}
    ${Number}    Set Variable    ${Number}.${sDecimal}
       
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Result}    ${Number}
    [Return]    ${Number} 

Get Number 6 Digits
    [Arguments]    ${number}
    ${test}  Replace String Using Regexp    ${number}      (\\d{3}$)    ,\\1
    Log    ${test}
    [Return]    ${test}   

Get Number 9 Digits
    [Arguments]    ${number}
    ${number}  Replace String Using Regexp    ${number}      (\\d{3}$)    ,\\1
    Log    ${number}
    ${number1}    Fetch From Right    ${number}    ,
    ${number2}    Fetch From Left    ${number}    ,
    ${number2}    Replace String Using Regexp    ${number2}       (\\d{3}$)    ,\\1
    Log   ${number2},${number1}
    ${number3}    Set Variable    ${number2},${number1} 
    [Return]    ${number3}

Validate Window Title Status
    [Documentation]    This keyword validates a Notebook's window title status. Ex. Awaiting Approval, Awaiting Release.
    ...    
    ...    | Arguments |
    ...    'WindowName' = The name of the Notebook/Window.
    ...    'Status' = Window status to be validated. Ex. Awaiting Approval, Awaiting Release
    ...    
    ...    @author: bernchua
    ...    @update: hstone     11JUN2020     - Added Keyword Pre-processing
    ...                                      - Added Take Screenshot
    [Arguments]    ${sWindowName}    ${sStatus}

    ### Keyword Pre-processing ###
    ${WindowName}    Acquire Argument Value    ${sWindowName}
    ${Status}    Acquire Argument Value    ${sStatus}

    ${Window_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${Status}.*${WindowName}.*")    VerificationData="Yes"
    ${Window_Exist}    Run Keyword If    ${Window_Exist}==False    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=.*${WindowName}.*${Status}.*")    VerificationData="Yes"
    Run Keyword If    ${Window_Exist}==True    Log    ${WindowName} is ${Status}.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/${sWindowName}
    
Generate Intent Notices
    [Documentation]    This keyword navigates the transaction workflow and generates intent notices.
    ...    @author: bernchua
    ...    <update> @ghabal - commented section that handles 'Edit Highlighted Notices Button' since what is being displayed now is 'View Highlighted Notices Button' 
    ...    @update: mcastro    17DEC2020    - Added Take screenshots
    [Arguments]    ${Customer_Name}
    mx LoanIQ activate    ${LIQ_Notices_Window}    
    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_NoticeGroup_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IntentNoticeWindow    
    ${Notice_Contact}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Tree}    ${Customer_Name}%Contact%contact    
    ${Notice_Method}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_NoticeGroup_Tree}    ${Customer_Name}%Notice Method%method
    mx LoanIQ select    ${LIQ_NoticeGroup_File_Preview}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IntentNoticeWindow
    ${Error_Displayed}    Run Keyword And Return Status    mx LoanIQ click element if present    ${LIQ_Error_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/IntentNoticeWindow
  
    # Run Keyword If    ${Error_Displayed}==True    Run Keywords
    # ...    mx LoanIQ click    ${LIQ_NoticeGroup_EditHighlightedNotices_Button}
    # ...    AND    Verify If Text Value Exist in Textfield on Page    Notice created by    ${Customer_Name}
    # ...    AND    Verify If Text Value Exist in Textfield on Page    Notice created by    ${Notice_Contact}
    # ...    AND    Validate Loan IQ Details    ${Notice_Method}    ${LIQ_NoticeCreateBy_NoticeMethod_Combobox}
    # ...    AND    mx LoanIQ select    ${LIQ_NoticeCreateBy_File_Preview}
    # ...    AND    Sleep    10
    # ...    AND    mx LoanIQ close window    ${LIQ_NoticePreview_Window}
    # ...    AND    mx LoanIQ close window    ${LIQ_NoticeCreateBy_Window}
    # Mx Click    ${LIQ_NoticeGroup_Exit_Button}

Get Data From LoanIQ
    [Documentation]    This keyword get data from LoanIQ objects except JavaTrees.
    ...    
    ...    | Arguments |
    ...    'Notebook_Locator' = Locator of the Notebook to be activated where the Object_Locator is located.
    ...    'NotebookTab_Locator' = Locator of the Notebook's Tab object.
    ...    'NotebookTab_Name' = Name of the Tab in the Notebook where the Object_Locator is located.
    ...    'Object_Locator' = The actual locator of the object where the data will come from.
    ...    
    ...    @author: bernchua
    [Arguments]    ${Notebook_Locator}    ${NotebookTab_Locator}    ${NotebookTab_Name}    ${Object_Locator}
    mx LoanIQ activate    ${Notebook_Locator}
    Mx LoanIQ Select Window Tab    ${NotebookTab_Locator}    ${NotebookTab_Name}
    ${Data}    Mx LoanIQ Get Data    ${Object_Locator}    value%data    
    [Return]    ${Data}

Navigate to Payment Notebook via WIP
    [Documentation]    This keyword is used to open the Repayment Paper Clip Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    @author: rtarayao
    ...    @update: clanding    05AUG2020    - replaced Mx Native Key to Mx Press Combination; refactor arguments
    [Arguments]    ${sWIP_TransactionType}    ${sWIP_AwaitingApprovalStatus}    ${sWIP_PaymentType}    ${sLoan_Alias}    ${sLoan_Alias2}=None
           
    ### GetRuntime Keyword Pre-processing ###
    ${Loan_Alias}    Acquire Argument Value    ${sLoan_Alias}
    ${Loan_Alias2}    Acquire Argument Value    ${sLoan_Alias2}
    ${WIP_TransactionType}    Acquire Argument Value    ${sWIP_TransactionType}
    ${WIP_AwaitingApprovalStatus}    Acquire Argument Value    ${sWIP_AwaitingApprovalStatus}
    ${WIP_PaymentType}    Acquire Argument Value    ${sWIP_PaymentType}
    
    mx LoanIQ click    ${LIQ_WorkInProgress_Button}
    mx LoanIQ activate    ${LIQ_WorkInProgress_Window}   
    Mx LoanIQ Verify Object Exist    ${LIQ_WorkInProgress_Window}     VerificationData="Yes"
    Mx LoanIQ Select String    ${LIQ_WorkInProgress_TransactionList}    ${WIP_TransactionType}
    Mx Press Combination    Key.ENTER

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=Group:Details;Tab:${WIP_TransactionType};.*")    ${WIP_AwaitingApprovalStatus}        
    Run Keyword If    ${status}==True    Mx Press Combination    Key.ENTER

    ${status}    Run Keyword And Return Status    Mx LoanIQ Select String    JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=Group:Details;Tab:${WIP_TransactionType};.*")    ${WIP_PaymentType}
    Run Keyword If    ${status}==True   Mx Press Combination    Key.ENTER
   
    mx LoanIQ maximize    ${LIQ_WorkInProgress_Window}  
    Mx LoanIQ Select String    JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=Group:Details;Tab:${WIP_TransactionType};.*")    ${WIP_PaymentType} 
    Mx Press Combination    Key.PAGE DOWN
    Mx LoanIQ Select String    JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=Group:Details;Tab:${WIP_TransactionType};.*")    ${Loan_Alias} 
    Mx Press Combination    Key.ENTER
    
    Run Keyword If    '${Loan_Alias2}' != 'None'     Mx LoanIQ Select String    JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=Group:Details;Tab:${WIP_TransactionType};.*")    ${WIP_PaymentType} 
    Run Keyword If    '${Loan_Alias2}' != 'None'     Mx Press Combination    Key.PAGE DOWN
    Run Keyword If    '${Loan_Alias2}' != 'None'     Mx LoanIQ Select String    JavaWindow("title:=Transactions In Process.*").JavaTree("labeled_containers_path:=Group:Details;Tab:${WIP_TransactionType};.*")    ${Loan_Alias2}         
    Run Keyword If    '${Loan_Alias2}' != 'None'     Mx Press Combination    Key.ENTER
    mx LoanIQ close window    ${LIQ_WorkInProgress_Window}
 
    
Get Number Of Days Betweeen Two Dates
    [Documentation]    This keyword gets the total number of days between two dates.
    ...    @author: bernchua
    [Arguments]    ${Date1}    ${Date2}
    ${Date1}    Convert Date    ${Date1}    date_format=%d-%b-%Y
    ${Date2}    Convert Date    ${Date2}    date_format=%d-%b-%Y
    ${Total_Days}    Subtract Date From Date    ${Date1}    ${Date2}    verbose
    ${Total_Days}    Remove String    ${Total_Days}    days    ${SPACE}
    ${Total_Days}    Convert To Integer    ${Total_Days}
    [Return]    ${Total_Days}    

Open Facility Notebook
    [Documentation]    This keyword opens an existing facility on LIQ.
    ...    @author: mgaling
    ...    @author: ghabal change  'AMCH06a1_InterestPricingChange' sheet name to 'AMCH06_PricingChangeTransaction'
    ...    @update: clanding    10AUG2020    - removed Read Data From Excel; add pre processing keyword and screenshot
    [Arguments]    ${sFacility_Name}
    
    ### Keyword Pre-processing ###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    
    mx LoanIQ activate    ${LIQ_DealNotebook_Window}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    mx LoanIQ activate    ${LIQ_FacilityNavigator_Window}
    
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityNavigator_Tree}    ${Facility_Name}%d
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/FacilityNotebookWindow

Get Number 12 Digits
    [Arguments]    ${number}
    ${number}  Replace String Using Regexp    ${number}      (\\d{3}$)    ,\\1
    Log    ${number}
    ${number1}    Fetch From Right    ${number}    ,
    ${number2}    Fetch From Left    ${number}    ,
    ${number2}    Replace String Using Regexp    ${number2}       (\\d{3}$)    ,\\1   
    ${number3}    Fetch From Right    ${number2}    ,
    ${number4}    Fetch From Left    ${number2}    ,
    ${number5}    Replace String Using Regexp    ${number4}       (\\d{3}$)    ,\\1
    ${number5}    Set Variable    ${number5},${number3},${number1} 
    [Return]    ${number5}
    
Get Number 15 Digits
    [Arguments]    ${number}
    ${number}  Replace String Using Regexp    ${number}      (\\d{3}$)    ,\\1
    Log    ${number}
    ${number1}    Fetch From Right    ${number}    ,
    ${number2}    Fetch From Left    ${number}    ,
    ${number2}    Replace String Using Regexp    ${number2}       (\\d{3}$)    ,\\1
    ${number3}    Fetch From Right    ${number2}    ,
    ${number4}    Fetch From Left    ${number2}    ,
    ${number5}    Replace String Using Regexp    ${number4}       (\\d{3}$)    ,\\1
    ${number0}    Fetch From Right    ${number5}    ,
    ${number6}    Fetch From Left    ${number5}    ,
    ${number7}    Replace String Using Regexp    ${number6}       (\\d{3}$)    ,\\1
    ${number8}    Set Variable    ${number7},${number0},${number3},${number1}
    [Return]    ${number8}    

Validate Text of Warning Message
    [Documentation]    This keyword will validate the text of warning message
    ...    @author: mnanquilada
    ...    10/15/2018
    [Arguments]    ${textToValidate}
    ${text}    Mx LoanIQ Get Data    ${LIQ_Warning_MessageBox}    text%Text
    Run Keyword And Continue On Failure    Should Contain    ${text}    ${textToValidate}                     
    

Validate if Element is Not Editable
    [Documentation]    This keyword validates if Element is disabled
    ...    @author: chanario    
    [Arguments]     ${Field_fromUI}    ${Field_Label}
        
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}    editable%0
    ${result}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Verify Runtime Property    ${Field_fromUI}    editable%0
    Run Keyword If   '${result}'=='True'    Log    '${Field_Label}' element is confirmed disabled
    ...     ELSE    Log    '${Field_Label}' element is confirmed enabled    level=ERROR        

Remove Comma and Convert to Number
    [Documentation]    This keyword removes comma to amounts above hudred values, coverts to Number and two decimal figures
    ...    @author: chanario
    ...    @update: jdelacru
    ...    @update: ritragel    07MAR19    Updated condition, removed setting of variable
    ...    @update: hstone      29APR2020    - Added Keyword Pre-processing: Acquire Argument Value
    ...                                      - Added Optional Argument: ${sRunTimeVar_Result}
    ...                                      - Added Keyword Post-processing: Save Runtime Value
    [Arguments]     ${sNumberToBeConverted}     ${sRunTimeVar_Result}=None
    ### Keyword Pre-processing ###
    ${NumberToBeConverted}    Acquire Argument Value    ${sNumberToBeConverted}
    ${sStatus}    Run Keyword And Return Status    Should Contain    ${NumberToBeConverted}    ,
    ${result}    Run Keyword If    '${sStatus}'=='True'    Remove Comma and Evaluate to Number    ${NumberToBeConverted}
    ...    ELSE    Set Variable    ${NumberToBeConverted}
    ${result}    Evaluate    "%.2f" % ${result}
    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Result}    ${result}
    [Return]    ${result}
    
Remove Comma and Evaluate to Number
    [Documentation]    This keyword removes comma to amounts above hudred values, evaluates to Number.
    ...    @author: hstone    12MAY2020    - initial create
    ...    @update: dahijara    13OCT2020    - Update logic for evaluating. Previous logic returns incorrect value (ex. 1,788.08 is returned as 1788.8)
    [Arguments]     ${sNumberToBeConverted}
    ${sContainer}    Convert To String    ${sNumberToBeConverted}
    ${sContainer}    Remove String    ${sContainer}    ,
    ${Container_List}    Split String    ${sContainer}    .
    ${sWholeNum_Value}    Set Variable    @{Container_List}[0]
    ${sDecimal_Value}    Set Variable    @{Container_List}[1]

    ${result}    Evaluate    ${sWholeNum_Value}.${sDecimal_Value}

    [Return]    ${result}
    
Add Days to Date
    [Documentation]    This will add a number of days in the current date
    ...    @author: ritragel
    [Arguments]    ${Date}    ${NumberOfDaysToAdd}
    ${Date}    Convert Date    ${Date}    date_format=%d-%b-%Y
    ${Date}    Add Time To Date    ${Date}    ${NumberOfDaysToAdd} days    result_format=%d-%b-%Y
    [Return]    ${Date}

Subtract Days to Date
    [Documentation]    This will subtract a number of days in the current date
    ...    @author: ritragel
    [Arguments]    ${Date}    ${NumberOfDaysToSubract}
    ${Date}    Convert Date    ${Date}    date_format=%d-%b-%Y
    ${Date}    Subtract Time From Date    ${Date}    ${NumberOfDaysToSubract} days    result_format=%d-%b-%Y
    [Return]    ${Date}

Get LoanIQ Business Date and Add to API Calendar File
    [Documentation]    This keyword will get the calendar date and add 1 day.
    ...    If the calendar date is already Friday this keyword will automatically 
    ...    set the day to Monday. 
    ...    @author: mnanquil
    ...    10/16/2018
    [Arguments]    ${copyFileName}    ${fileCopyLocation}    ${newFileName}
    ${date}    Get System Date
    ${day}    Get Substring    ${date}    0    2
    ${month}    Get Substring    ${date}    3    6
    ${year}    Get Substring    ${date}    7    11
    Run keyword if    '${month}'=='Jan'    Set Global Variable    ${month}    01
    Run keyword if    '${month}'=='Feb'    Set Global Variable    ${month}    02
    Run keyword if    '${month}'=='Mar'    Set Global Variable    ${month}    03
    Run keyword if    '${month}'=='Apr'    Set Global Variable    ${month}    04
    Run keyword if    '${month}'=='May'    Set Global Variable    ${month}    05
    Run keyword if    '${month}'=='Jun'    Set Global Variable    ${month}    06
    Run keyword if    '${month}'=='Jul'    Set Global Variable    ${month}    07
    Run keyword if    '${month}'=='Aug'    Set Global Variable    ${month}    08
    Run keyword if    '${month}'=='Sep'    Set Global Variable    ${month}    09
    Run keyword if    '${month}'=='Oct'    Set Global Variable    ${month}    10
    Run keyword if    '${month}'=='Nov'    Set Global Variable    ${month}    11
    Run keyword if    '${month}'=='Dec'    Set Global Variable    ${month}    12
    Log    ${month}
    ${CurrentDay}    Convert Date     ${year}-${month}-${day}    result_format=%A
    Log    ${CurrentDay}
    
    ${date1}    Run keyword if    '${CurrentDay}' == 'Monday'    Add Time To Date    ${year}-${month}-${day}    7 days
    Run keyword if    '${CurrentDay}' == 'Monday'    Set Global Variable    ${date}    ${date1}
    ${date2}    Run keyword if    '${CurrentDay}' == 'Tuesday'    Add Time To Date    ${year}-${month}-${day}    7 days
    Run keyword if    '${CurrentDay}' == 'Tuesday'    Set Global Variable    ${date}    ${date2}
    ${date3}    Run keyword if    '${CurrentDay}' == 'Wednesday'    Add Time To Date    ${year}-${month}-${day}    7 days
    Run keyword if    '${CurrentDay}' == 'Wednesday'    Set Global Variable    ${date}    ${date3}
    ${date4}    Run keyword if    '${CurrentDay}' == 'Thursday'    Add Time To Date    ${year}-${month}-${day}    7 days
    Run keyword if    '${CurrentDay}' == 'Thursday'    Set Global Variable    ${date}    ${date4}
    ${date5}    Run keyword if    '${CurrentDay}' == 'Friday'    Add Time To Date    ${year}-${month}-${day}    4 days
    Run keyword if    '${CurrentDay}' == 'Friday'    Set Global Variable    ${date}    ${date5}
    ${original_date}    Convert Date    ${date}    result_format=%Y-%m-%d
    ${date}    Convert Date    ${date}    result_format=%d-%b-%Y
    ${data}    OperatingSystem.Get File    ${fileCopyLocation}${copyFileName}
    ${data}    Set Variable    ${data}
    ${data}    Replace Variables    ${data}
    Create File    ${fileCopyLocation}${newFileName}    ${data}

Add 4 Days to Current Date and Set as Non-Business Day
    [Documentation]    This keyword gets the current system date and adds 4 days, to set that result date as a non business day in Calendar API.
    ...                @author: bernchua
    [Arguments]    ${copyFileName}    ${fileCopyLocation}    ${newFileName}
    ${CurrentDate}    Get System Date
    
    ${Day}    Convert Date    ${CurrentDate}    date_format=%d-%b-%Y    result_format=%a
    ${Day4Holiday}    Get Future Date    ${CurrentDate}    3
    
    ${Day}    Convert Date    ${Day4Holiday}    date_format=%d-%b-%Y    result_format=%a
    ${Day4Holiday}    Run Keyword If    '${Day}'=='Sat'    Get Future Date    ${CurrentDate}    2
    ...    ELSE IF    '${Day}'=='Sun'    Get Future Date    ${CurrentDate}    1
    ...    ELSE    Set Variable    ${Day4Holiday}
    
    ${original_date}    Set Variable    ${Day4Holiday}
    
    ${original_date}    Convert Date    ${original_date}    date_format=%d-%b-%Y    result_format=%Y-%m-%d
    ${data}    OperatingSystem.Get File    ${fileCopyLocation}${copyFileName}
    ${data}    Set Variable    ${data}
    ${data}    Replace Variables    ${data}
    Create File    ${fileCopyLocation}${newFileName}    ${data}
    
Validate Deal Notebook
    [Documentation]    This keyword validates the status of Deal Notebook and gets the needed data.
    ...    @author:mgaling
    
    mx LoanIQ activate window    ${LIQ_DealNotebook_Window}
    ${Current_Cmt}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_CurrentCmt_StaticText}    text%value
    ${Current_Cmt}    Remove String    ${Current_Cmt}    \ 
   
    ${Contr_Gross}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_ContrGross_StaticText}    text%value
    ${Contr_Gross}    Remove String    ${Contr_Gross}    \   
  
    ${Net_Cmt}    Mx LoanIQ Get Data    ${LIQ_ClosedDeal__DealNB_NetCmt_StaticText}    text%value
    ${Net_Cmt}    Remove String    ${Net_Cmt}    \              
    
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    Mx LoanIQ Select String    ${LIQ_Events_Javatree}    Closed    
    [Return]    ${Current_Cmt}    ${Contr_Gross}    ${Net_Cmt}  

Validate Loan Current Amount
    [Documentation]    This keyword will validate the loan current amount. maximum amont to validate is 3
    ...    @author: mnanquil
    ...    10/24/2018
    [Arguments]    ${currentAmount1}    ${currentAmount2}    ${currentAmount3}
    mx LoanIQ activate    ${LIQ_ExistingLoansForFacility_Window}
    Mx LoanIQ Select String   ${LIQ_ExistingLoansForFacility_Loan_List}    ${currentAmount1}
    Mx LoanIQ Select String   ${LIQ_ExistingLoansForFacility_Loan_List}    ${currentAmount2}  
    Mx LoanIQ Select String   ${LIQ_ExistingLoansForFacility_Loan_List}    ${currentAmount3}
    
Compute for Percentage of an Amount and Return with Comma Separator
    [Documentation]    This keyword will compute the percentage value of a certain amount
    ...    @author: mnanquil
    ...    10/25/2018
    [Arguments]    ${amount}    ${percentage}
    Log    ${amount}
    Log    ${percentage}
    ${percentage}    Convert To Number    ${percentage}    
    ${percentage}    Evaluate    ${percentage}/100
    ${percentageAmount}    Evaluate    ${amount}*${percentage}
    ${percentageAmount}    Convert To String    ${percentageAmount}
    ${percentageAmount}    Convert Number With Comma Separators    ${percentageAmount}
    [Return]    ${percentageAmount}    

Click OK In Notices Window
    [Documentation]    This keyword clicks the OK button in the Notices window.
    ...                @author: bernchua    
    mx LoanIQ activate    ${LIQ_Notices_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notices_Lenders_Checkbox}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notices_Borrower_Checkbox}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notices_Guarantors_Checkbox}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_Notices_Exporters_Checkbox}    VerificationData="Yes"
    Mx LoanIQ Set    ${LIQ_Notices_Borrower_Checkbox}    ON    
    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    Verify If Warning Is Displayed

Validate Content of PDF File
    [Documentation]    This keyword will validate the content of PDF File and return the number of occurence
    ...    @author: mnanquil
    ...    11/12/2018
    [Arguments]    ${fileName}    ${contentToValidate}
    ${counter2}    Set Variable    0
    @{lists}    Create List    
    ${text}    Convert Pdf To Text    ${fileName}    
    ${lineCount}    Get Line Count    ${text}
    :FOR    ${INDEX}    IN RANGE    ${lineCount}
    \    ${detail}    Get Line    ${text}    ${INDEX}
    \    ${status}    Run keyword and Return Status    Should Contain    ${detail}    ${contentToValidate}
    \    ${counter}    Run keyword if    '${status}' == 'True'    Evaluate    int(${INDEX})
    \    Run keyword if    '${status}' == 'True'    Set Global Variable    ${counter2}    ${counter}
    \    Run keyword if    '${status}' == 'True'    Log    line: ${INDEX}
    \    ${lines}    Run keyword if    '${status}' == 'True'    Set Variable    ${INDEX}
    \    ${lineNumber}    Run keyword if    '${status}' == 'True'    Set Variable    ${lines}
    \    Run keyword if    '${status}' == 'True'    Append To List    ${lists}    ${lineNumber}
    \    Run keyword if    '${status}' == 'False'    Log    not existing
    Run keyword if    ${counter2} == 0    Fatal Error    Content not found.  
    Log    Content found on Line/s: ${lists} 
    
Close Notice Group Window
    [Documentation]    This keyword closes the Notice Group window.
    ...                @author: bernchua
    mx LoanIQ click    ${LIQ_IntentNotice_Exit_Button}

Close Application Via CMD
    [Documentation]    This keyword will kill an existing process 
    ...    @author: mnanquil
    ...    11/28/2018
    [Arguments]    ${process}
    ${status}    Run     ‪C:\\Windows\\System32\\taskkill.exe /IM ${process} /F
    Log    ${status}   

Fail if Previous Test Case Failed
    [Documentation]    This keyword will fail the succeeding test cases if the prior tase case failed.
    ...    This keyword is intended to be use for Integration testing.
    ...    @author: mnanquil
    ...    11/28/2018
    Run Keyword If    '${PREV_TEST_STATUS}'=='FAIL'    Fail    Skipping test because '${PREV_TEST_NAME}' failed.
    
Launch LoanIQ Application
    [Documentation]    This keyword will launch loan iq
    ...    @author: mnanquil
    ...    11/28/2018
    [Arguments]    ${loanIQPath}        
    Mx LoanIQ Launch Exe    ${loanIQPath}
    ${status}    Run keyword and Return Status    mx LoanIQ click element if present    ${LIQ_Logon_Error_Ok_Button}    60
    Run keyword if    '${status}' == 'False'    mx LoanIQ click element if present     ${LIQ_LOGON_ERROR_OK_Button_Capital}    60
    
Refresh Tables in LIQ
    [Documentation]    This keyword is for refreshing the tables in LIQ.
    ...    @author: mgaling
    ...    @update: bernchua    09AUG2019    Added maximizing of main LIQ window    
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ select    ${LIQ_Options_RefreshAllCodeTables}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ maximize    ${LIQ_Window}

Display Message
    [Documentation]    This keyword will display a message via log and log to console with default font size of 5 and font color of blue.
    ...    @author: mnanquilada    20FEB2019    initial draft
    [Arguments]    ${sMessage}    ${iFontSize}=5    ${sFontColor}=blue
    Log    <font size="${iFontSize}" color="${sFontColor}">${sMessage}</font>    html=true
    Log To Console    ${sMessage}        

Create List for Multiple Data
    [Documentation]    This keyword handles creation of multiple data and will return the list as well depending on the number of data supplied. 
    ...    Example: Test1 | Test2 | Test3 and so on...
    ...    @author: rtarayao    28FEB2019    initial create
    [Arguments]    ${Delimiter}    @{aData}
    ${Data_Count}    Get Length    ${aData}
    Delete File If Exist    ${TEMPORARY_FILETEXT}
    Create File    ${TEMPORARY_FILETEXT}
    :FOR    ${ArrayIndex}    IN RANGE    0    ${Data_Count}
    \    ${Data}    Set Variable    @{aData}[${ArrayIndex}]
    \    Log    ${Data}    
    \    Run Keyword If    ${ArrayIndex}==${Data_Count}-1    Append To File    ${TEMPORARY_FILETEXT}    ${Data}
         ...    ELSE    Append To File    ${TEMPORARY_FILETEXT}    ${Data}${SPACE}${Delimiter}${SPACE}
    \    ${file}    OperatingSystem.Get File    ${TEMPORARY_FILETEXT}
    \    Log    ${file}
    Delete File If Exist    ${TEMPORARY_FILETEXT}
    [Return]    ${file}
  
Remove Percent sign and Convert to Number
    [Documentation]    This keyword removes comma to amounts above hudred values, coverts to Number and two decimal figures
    ...    @author: ritragel
    [Arguments]     ${NumberToBeConverted}  
    ${Status}    Run Keyword And Return Status    Should Contain    ${NumberToBeConverted}    %
    ${NumberToBeConverted}    Run Keyword If    '${Status}'=='True'    Remove String    ${NumberToBeConverted}    %
    ...    ELSE    Set Variable If    '${Status}'=='False'    ${NumberToBeConverted}
    ${nNumberToBeConverted}    Convert To Number    ${NumberToBeConverted}    2
    ${NumberToBeConverted}    Evaluate    "%.2f" % ${nNumberToBeConverted}
    ${NumberToBeConverted}    Convert To String    ${NumberToBeConverted}
    [Return]    ${NumberToBeConverted}

Validate Multiple Value in a Data
    [Documentation]    This keyword will validate if multiple value is present in a data.
    ...    @author: mnanquil    26MAR2019    initial draft
    [Arguments]    ${sData}    @{aDataToValidate}
    ${length}    Get Length    ${aDataToValidate}    
    :FOR    ${INDEX}    IN RANGE    ${length}
    \    ${status}    Run Keyword and Return Status    Should Contain    ${sData}    @{aDataToValidate}[${INDEX}]
    \    Run Keyword If    '${status}' == '${True}'    Log    ${sData} contains @{aDataToValidate}[${INDEX}]
    \    Run Keyword If    '${status}' == '${False}'    Run Keyword and Continue on Failure    Fail    ${sData} doesn't contains @{aDataToValidate}[${INDEX}]

Test Suite Tear Down
    [Documentation]    This keyword will tear down the processes use in test suite.
    ...    @author: mnanquil    11APR2019    - initial draft
    ...    @author: ritragel    11APR2019    - addded closing all LIQ Windows before logging out
    Run Keyword and Ignore Error    Close All Windows on LIQ
    Run Keyword and Ignore Error    Logout from Loan IQ   
    Run Keyword and Ignore Error    Close All Browsers
    Run Keyword and Ignore Error    Close All Connections
                     

Create Global List for Base Rate Data
    [Documentation]    This keyword creates a globally declared list to be used as storage for Base Rate data.
    ...                @author: bernchua    05APR2019    - initial create
    @{baseRateCode_List}                  Create List
    @{baseInterestRatePercentage_List}    Create List
    @{baseEffectiveDate_List}             Create List
    @{baseRepricingFrequency_List}        Create List
    @{baseCurrency_List}                  Create List
    Set Global Variable    ${baseRateCode_List}
    Set Global Variable    ${baseInterestRatePercentage_List}
    Set Global Variable    ${baseEffectiveDate_List}
    Set Global Variable    ${baseRepricingFrequency_List}
    Set Global Variable    ${baseCurrency_List}
    
Write Data to Excel Using List as Input Value
    [Documentation]    This keyword writes data to Excel using Lists as input values
    ...                @author: bernchua    05APR2019    - initial create
    [Arguments]        ${sSheetName}    ${sColumnName}    ${aDataList}
    ${list_size}    Get Length    ${aDataList}
    :FOR    ${i}    IN RANGE    ${list_size}
    \    ${row_number}    Evaluate    ${i}+1
    \    ${list_value}    Get From List    ${aDataList}    ${i}
    \    Write Data to Excel Using Row Index    ${sSheetName}    rowid    ${row_number}    ${row_number}
    \    Write Data to Excel Using Row Index    ${sSheetName}    ${sColumnName}    ${row_number}    ${list_value}

# Mx Execute Template With Specific Test Case Name
#     [Documentation]    This keyword will execute the template using the rowname instead of rowid
#     ...    @author: mnanquil    29APR2019    initial draft
#     [Arguments]    ${stemplateName}    ${sDataSet}    ${sDataRow}    ${sDataRowName}    ${sSheetName}
#     Open Excel    ${sDataSet} 
#     ${ColumnCount}    Get Column Count    ${sSheetName}
#     :FOR    ${x}    IN RANGE    0    ${ColumnCount}
#     \    ${header}    Read Cell Data By Coordinates    ${sSheetName}    ${x}    0
#     \    # Verify header
#     \    Run Keyword If    "${header}"=="${sDataRow}"    Set Test Variable    ${ColumnCount}    ${x}
#     \    Exit For Loop If    "${header}"=="${sDataRow}"
#     log    ${ColumnCount}
#     ${RowCountTotal}    Get Row Count    ${sSheetName}
#      :FOR    ${y}    IN RANGE    0    ${RowCountTotal}
#     \    ${header}    Read Cell Data By Coordinates    ${sSheetName}    0    ${y}
#     \    ${RowCount}    Set Variable    
#     \    Run Keyword If    "${header}"=="${rowid}"    Set Test Variable    ${RowCount}    ${y}
#     \    Exit For Loop If    "${header}"=="${rowid}"
#     Log    Current Row: ${RowCountTotal}
#     :FOR    ${counter}    IN RANGE    1    ${RowCountTotal}
#     \    ${header}    Read Cell Data By Coordinates    ${sSheetName}    ${ColumnCount}    ${counter}    
#     \    # Verify header
#     \    Run Keyword If    "${header}"=="${sDataRowName}"    Set Test Variable    ${ColumnCount}    ${x}
#     \    Exit For Loop If    "${header}"=="${sDataRowName}"
#     Set Test Variable    ${rowid}    ${counter}
#     Close Current Excel Document
#     Write Data to Excel Using Row Index    ${sSheetName}    rowid    ${rowid}    ${rowid}    ${sDataSet}
#     Mx Execute Template With Multiple Data    ${stemplateName}    ${sDataSet}    ${rowid}    ${sSheetName}

Validate Notebook Events Tab
    [Documentation]    This keyword validates that an event is shown in the Events Tab page of a Notebook
    ...    @author: bernchua    04JUN2019    initial create
    [Arguments]    ${sNotebook_Locator}    ${sNotebookTab_Locator}    ${sNotebook_EventsLocator}    ${sTransaction_Name}    ${sEvent_Name}
    mx LoanIQ activate    ${sNotebook_Locator}
    Mx LoanIQ Select Window Tab    ${sNotebookTab_Locator}    Events    
    ${STATUS}    Run Keyword And Return Status    Mx LoanIQ Select String    ${sNotebook_EventsLocator}    ${sEvent_Name}
    Run Keyword If    ${STATUS}==True    ${sTransaction_Name} is verified as ${sEvent_Name}
    ...    ELSE    Fail    ${sTransaction_Name} is not yet ${sEvent_Name}

Update Line Fee Dates
    [Documentation]    Updates the dates for line fee
    ...    @author: jloretiz    29SEP2019    - initial create
    [Arguments]    ${eNotebookLocator}    ${sEffectiveDate}    ${sFloatRate}    ${sActualDueDate}    ${sCycle}
    
    mx LoanIQ activate window    ${eNotebookLocator}
    mx LoanIQ select    ${LIQ_LineFee_Update_Menu}  
    mx LoanIQ select    ${LIQ_LineFee_Cycle}    ${sCycle}
    mx LoanIQ enter     ${LIQ_LineFee_ActualDue_Date}    ${sActualDueDate}
    mx LoanIQ enter     ${LIQ_LineFee_Effective_Date}    ${sEffectiveDate}
    mx LoanIQ enter     ${LIQ_LineFee_FloatRate_Date}    ${sFloatRate}
    mx LoanIQ select    ${LIQ_LineFee_Save_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    Take Screenshot    LineFee
    
    Log    Submenu selected successfully 

Select Menu Item
    [Documentation]    Standard keyword for Selecting a Menu and Submenu Item under any LoanIQ Notebook
    ...    @author: ritagel    26JUN2019    Creation
    [Arguments]    ${eNotebookLocator}    ${sMenu}    ${sSubMenu}
    mx LoanIQ activate window    ${eNotebookLocator}
    mx LoanIQ select    ${eNotebookLocator}.JavaMenu("label:=${sMenu}").JavaMenu("label:=${sSubMenu}")
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}    
    Log    Submenu selected successfully
    
Validate String Data In LIQ Object
    [Documentation]    This keyword validates the string data in a LIQ object
    ...                @author: bernchua    09JUL2019    Initial create
    ...                @update: bernchua    22AUG2019    Added conversion of value to string
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps        
    [Arguments]    ${sNotebookWindow_Locator}    ${sObject_Locator}    ${sObject_Data}
    
    ### GetRuntime Keyword Pre-processing ###
    ${NotebookWindow_Locator}    Acquire Argument Value    ${sNotebookWindow_Locator}
    ${Object_Locator}    Acquire Argument Value    ${sObject_Locator}
    ${Object_Data}    Acquire Argument Value    ${sObject_Data}

    mx LoanIQ activate    ${NotebookWindow_Locator}
    ${Object_Data}    Convert To String    ${Object_Data}
    ${UI_Data}    Mx LoanIQ Get Data    ${Object_Locator}    value%data
    ${STATUS}    Run Keyword And Return Status    Should Be Equal    ${Object_Data}    ${UI_Data}
    Run Keyword If    ${STATUS}==True    Log    ${Object_Data} is validated in LIQ UI.
    ...    ELSE    Fail    LIQ data validation unsuccessful.

Set Notebook to Update Mode
    [Documentation]    This keyword sets any LIQ Notebook to Update mode
    ...                @author: bernchua    09AUG2019    Initial create
    [Arguments]    ${sNotebook_Locator}    ${sInquiryModeButton_Locator}
    mx LoanIQ activate    ${sNotebook_Locator}
    mx LoanIQ click element if present    ${sInquiryModeButton_Locator}

Get LIQ Checkbox Status
    [Documentation]    This Keyword get the status of LIQ checkbox if check or uncheck and return boolean result
    ...    @author: jdelacru    
    [Arguments]     ${checkboxLocator}
    ${result}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${checkboxLocator}    VerificationData="Yes"
    Run Keyword If   '${result}'=='True'    Log    Checkebox element is checked.
    ...     ELSE    Log    Checkbox element is unchecked.
    [Return]    ${result}

Auto Generate 7 Integers
    [Documentation]    This keyword concatenates current date as a unique 7 numeric test data
    ...    @author: gerhabal    27AUG2019    - initial create  
    
    ${datetime.microsecond}    Get Current Date    result_format=7%H%M%S  
    log to console    ${datetime.microsecond}
    ${GeneratedName} =   Catenate    SEPARATOR=  ${datetime.microsecond}
    [Return]    ${GeneratedName}

Save Notebook Transaction
    [Documentation]    Low-level keyword used to Save the changes made on a specific Notebook.
    ...                @author: bernchua    26AUG2019    Initial create
    ...                @update: sahalder    25JUN2020    Added keyword Pre-Processing steps
    [Arguments]    ${sNotebookWindow_Locator}    ${sNotebookMenu_Locator}
    
    ### GetRuntime Keyword Pre-processing ###
    ${NotebookWindow_Locator}    Acquire Argument Value    ${sNotebookWindow_Locator}
    ${NotebookMenu_Locator}    Acquire Argument Value    ${sNotebookMenu_Locator}    

    mx LoanIQ activate window    ${NotebookWindow_Locator}
    mx LoanIQ select    ${NotebookMenu_Locator}
    Verify If Warning Is Displayed
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}

Select By RID
    [Documentation]    This keyword is used to Select By RID (Options -> RID Select)
    ...    @author: ehugo    30AUG2019    Initial create
    [Arguments]    ${sDataObject}    ${sRID}
    
    ###Navigate to Options -> RID Select###
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ select    ${LIQ_Options_RIDSelect}
    
    ###Select by RID window###
    mx LoanIQ activate window    ${LIQ_SelectByRID_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_SelectByRID_DataObject_Field}    ${sDataObject}    
    mx LoanIQ enter    ${LIQ_SelectByRID_RID_Field}    ${sRID}    
    Take Screenshot    RID
    mx LoanIQ click    ${LIQ_SelectByRID_OK_Button}  

Get Accrual Row Count
    [Documentation]    This keyword returns the total number of Accrual Cycles in a javatree.
    ...    @author: rtarayao    05SEP2019    - initial create
    [Arguments]    ${sNotebook_Locator}    ${sAccrualCycle_Locator}
    mx LoanIQ activate window    ${sNotebook_Locator}
    ${rowcount}    Mx LoanIQ Get Data    ${sAccrualCycle_Locator}    input=rowcount%value
    ${rowcount}    Evaluate    ${rowcount}-3  
    Log    The total rowcount is ${rowcount}
    [Return]    ${rowcount}    

Return Expected User Status
    [Documentation]    This keyword is used to Return the correct expected User Status
    ...    @author: jloretiz    06SEP2019    - Initial create
    [Arguments]    ${sAPIDataSetVariable}    ${sResponseVariable}
    
    ${Expected}    Run Keyword If    '${sAPIDataSetVariable}'=='' or '${sAPIDataSetVariable}'==${NONE}    Set Variable    ${sResponseVariable}
    ...    ELSE IF    '${sAPIDataSetVariable}'=='ACTIVE'    Set Variable    INACTIVE
    ...    ELSE    Set Variable    ACTIVE
    
    [Return]    ${Expected}

Return No Tag Value for Empty Variables
    [Documentation]    This keyword is used to Return no tag value for Empty Variables
    ...    @author: jloretiz    06SEP2019    - Initial create
    [Arguments]    ${sVariable}
    
    ${EmptyList}    Create List
    ${Expected}    Run Keyword If    '${sVariable}'=='${EmptyList}' or '${sVariable}'=='${NONE}'     Set Variable    no tag
    ...    ELSE    Set Variable    ${sVariable}
    
    [Return]    ${Expected}
    
Get API Response from File for PUT and POST User API
    [Documentation]    This keyword is used to get API Response from File for PUT and POST User API
    ...    @author: amansuet    17SEP2019    - Initial create
    [Arguments]    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sHttpMethod}
    
    ${APIResponseFile}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputAPIResponse}.json
    
    Run Keyword If    '${sHttpMethod}'=='PUT'    Set Global Variable    ${PUTAPIRESPONSE}    ${APIResponseFile}
    ...    ELSE IF    '${sHttpMethod}'=='POST'    Set Global Variable    ${POSTAPIRESPONSE}    ${APIResponseFile}
    ...    ELSE    Fail    '${sHttpMethod}' method is not applicable for this keyword.

Return Expected User Lock Status
    [Documentation]    This keyword is used to Return the correct expected User Status
    ...    @author: jloretiz    06SEP2019    - Initial create
    [Arguments]    ${sStatus}
    
    ${Expected}    Run Keyword If    '${sStatus}'=='LOCKED'    Set Variable    UNLOCKED
    ...    ELSE    Set Variable    LOCKED
    
    [Return]    ${Expected}

Return GET API Response Data If APIDataSet is Empty
    [Documentation]    This keyword is used to Return the GET API Response Data if APIDataSet is empty.
    ...    @author: jloretiz    09SEP2019    - Initial create
    [Arguments]    ${sAPIDataSetVariable}    ${sResponseVariable}
    
    ${Expected}    Run Keyword If    '${sAPIDataSetVariable}'=='' or '${sAPIDataSetVariable}'==${NONE}    Set Variable    ${sResponseVariable}
    ...    ELSE    Set Variable    ${sAPIDataSetVariable}
    
    [Return]    ${Expected}

Convert Percentage to Decimal
    [Documentation]    This keyword is used to convert percentage (less than or equal to 99%) to decimal value.
    ...    @author: ehugo    10SEP2019    Initial create
    ...    @update: ehugo    04OCT2019    Added handling if given percentage value is 0%
    [Arguments]    ${iPercentage_Value}    
    
    ${Decimal_Value}    Set Variable    ${iPercentage_Value}
    ${Decimal_Value}    Remove String    ${Decimal_Value}    %
    ${Decimal_Value}    Convert To Number    ${Decimal_Value}        
    ${Decimal_Point}    Run Keyword If    ${Decimal_Value}>=10    Set Variable    0.
    ...    ELSE    Set Variable    0.0
    ${Decimal_Value}    Convert To String    ${Decimal_Value}
    ${Decimal_Value}    Remove String    ${Decimal_Value}    .
    ${Decimal_Value}    Set Variable    ${Decimal_Point}${Decimal_Value}
    ${Decimal_Value}    Set Variable    ${Decimal_Value.rstrip("0")}
    
    ${Decimal_Value}    Run Keyword If    '${Decimal_Value}'=='0.'    Remove String    ${Decimal_Value}    .
    ...    ELSE    Set Variable    ${Decimal_Value}
    
    [Return]    ${Decimal_Value}

Remove Comma and Convert to Number with exact percentage
    [Documentation]    This keyword removes comma to amounts above hudred values, coverts to Number with exact percentage
    ...    @author: fmamaril    11SEP2019
    [Arguments]     ${sNumberToBeConverted}
    ${sContainer}    Convert To String    ${sNumberToBeConverted}
    ${sStatus}    Run Keyword And Return Status    Should Contain    ${sNumberToBeConverted}    ,
    ${sContainer}    Run Keyword If    '${sStatus}'=='True'    Remove String    ${sNumberToBeConverted}    ,
    ...    ELSE    Set Variable    ${sNumberToBeConverted}    
    ${sContainer}    Convert To Number    ${sContainer}
    [Return]    ${sContainer}    

Convert Number with comma to Integer
    [Documentation]    This keyword is used to convert number with comma (e.g. 1,000.00 to 1000, 20,000.57 to 20000.57, 300.50 to 300.5) to integer.
    ...    @author: ehugo    11SEP2019    Initial create
    [Arguments]    ${iNumberWithComma}  
    
    ${Number_ContainsDot}    Run Keyword And Return Status    Should Contain    ${iNumberWithComma}    .
    ${iNumberWithComma}    Run Keyword If    ${Number_ContainsDot}==False    Set Variable    ${iNumberWithComma}.00
    ...    ELSE    Set Variable    ${iNumberWithComma}
    @{Split_Number}    Split String    ${iNumberWithComma}    .
    ${Left_Digits}    Set Variable    @{Split_Number}[0]
    ${Left_Digits}    Remove String    ${Left_Digits}    ,
    ${Right_Digits}    Set Variable    @{Split_Number}[1]
    ${Right_Digits}    Run Keyword If    @{Split_Number}[1]!=00    Set Variable    .${Right_Digits.rstrip("0")}
    ...    ELSE    Set Variable    ${EMPTY}
    ${Integer_Value}    Set Variable    ${Left_Digits}${Right_Digits}
    [Return]    ${Integer_Value}

Convert CSV Date Format to LIQ Date Format
    [Documentation]    This keyword is used to convert CSV Date Format (Y-m-d H:M:S) to LIQ Date Format (d-b-Y)
    ...    @author: ehugo    18SEP2019    Initial create
    [Arguments]    ${sCSVDate}  
    
    ${Converted_Date}    Convert Date    ${sCSVDate}    result_format=%d-%b-%Y    date_format=%Y-%m-%d %H:%M:%S
    [Return]    ${Converted_Date}
    
Convert CSV Date Format to LIQ Date Format without Zero
    [Documentation]    This keyword is used to convert CSV Date Format (Y-m-d H:M:S) to LIQ Date Format (d-b-Y) without Zero in Day
    ...    @author: ehugo    19SEP2019    Initial create
    [Arguments]    ${sCSVDate}  
    
    ${Converted_Date}    Convert Date    ${sCSVDate}    result_format=%#d-%b-%Y    date_format=%Y-%m-%d %H:%M:%S
    [Return]    ${Converted_Date}
    
Get Value from UI
    [Documentation]    This keyword is used to get value from UI, strip space and return the value
    ...    @author: gerhabal    17SEP2019    - intial create    
    [Arguments]    ${locator_from_ui}
    
    ${value_from_ui}    Get Value    ${locator_from_ui}
    ${value_from_ui}    Strip String    ${value_from_ui}
    Log    ${value_from_ui}
    [Return]    ${value_from_ui}

Open Excel
    [Documentation]    This keyword is used to to handle old way of opening excel file. 
    ...    UTF upgrade from 3.2 to 3.9.1.
    ...    @author: dahijara    29OCT2019    - intial create    
    [Arguments]    ${sFilePath}
    
    Open Excel Document    ${sFilePath}    0
    
Get Row Count
    [Documentation]    This keyword is used to to handle old way of getting row count from an excel file.
    ...    UTF upgrade from 3.2 to 3.9.1.
    ...    @author: dahijara    29OCT2019    - intial create
    ...    update: songchan    17DEC2020    - added value for max_num to correct the passing of arguments for sheetname    
    ...    update: dahijara    08JAN2021    - reverting updates last 17DEC2020. 
    [Arguments]    ${sSheetName}
    
    ${aColumn}    Read Excel Column    1    0    ${sSheetName}
    ${iRowCount}    Get Length    ${aColumn}
    [Return]    ${iRowCount}

Get Column Count
    [Documentation]    This keyword is used to to handle old way of getting column count from an excel file.
    ...    UTF upgrade from 3.2 to 3.9.1.
    ...    @author: dahijara    29OCT2019    - intial create    
    ...    update: songchan    17DEC2020    - added value for max_num to correct the passing of arguments for sheetname
    ...    update: dahijara    08JAN2021    - reverting updates last 17DEC2020. 
    [Arguments]    ${sSheetName}
    
    ${aRowValues}    Read Excel Row    1    0    ${sSheetName}
    ${iColCount}    Get Length    ${aRowValues}
    Log    ${iColCount}
    [Return]    ${iColCount}    
    
Get Row Values
    [Documentation]    This keyword is used to to handle old way of getting row values from an excel file.
    ...    UTF upgrade from 3.2 to 3.9.1.
    ...    @author: dahijara    29OCT2019    - intial create         
    [Arguments]    ${sSheetName}    ${iRowIndex}
    
    ${aRowValues}    Read Excel Row    ${iRowIndex}    0    ${sSheetName}
    [Return]    ${aRowValues}

Save Excel
    [Documentation]    This keyword is used to to handle old way of saving an excel file.
    ...    UTF upgrade from 3.2 to 3.9.1.
    ...    @author: dahijara    29OCT2019    - intial create    
    [Arguments]    ${sFileName}
    
    Save Excel Document    ${sFileName}
    
Put String To Cell
    [Documentation]    This keyword is used to to handle old way of saving an excel file.
    ...    UTF upgrade from 3.2 to 3.9.1.
    ...    @author: dahijara    29OCT2019    - intial create    
    [Arguments]    ${sSheetName}    ${iColIndex}     ${iRowIndex}    ${sValue}

    ${iRowIndex}    Evaluate    ${iRowIndex}+1
    ${iColIndex}    Evaluate    ${iColIndex}+1
    Write Excel Cell    ${iRowIndex}    ${iColIndex}    ${sValue}    ${sSheetName}
    
Read Cell Data By Coordinates
    [Documentation]    This keyword is used to to handle old way of saving an excel file.
    ...    UTF upgrade from 3.2 to 3.9.1.
    ...    @author: dahijara    29OCT2019    - intial create    
    [Arguments]    ${sSheetName}    ${iColIndex}     ${iRowIndex}
    
    ${iRowIndex}    Evaluate    ${iRowIndex}+1
    ${iColIndex}    Evaluate    ${iColIndex}+1
    ${sValue}    Read Excel Cell    ${iRowIndex}    ${iColIndex}    ${sSheetName}
    
    [Return]    ${sValue}

Convert Excel XLSX to XLS
    [Documentation]    This keyword is convert an existing XLSX file to XLS format.
    ...    @author: jloretiz    25NOV2019    - intial create    
    [Arguments]    ${sInputFilePath}    ${sCoppClarkFiles}    ${sFileType}
    
    ${FileList}    Split String    ${sCoppClarkFiles}    ,
    ${FileCount}    Get Length    ${FileList}
    :FOR    ${File}    IN    @{FileList}
    \
    \    ${File_Type}    Run Keyword If    '${sFileType}'=='File_1'    Set Variable    _1.xlsx
         ...    ELSE IF    '${sFileType}'=='File_2'    Set Variable    _2.xlsx
         ...    ELSE IF    '${sFileType}'=='Misc'    Set Variable    Misc
    \
    \    ${File_Name}    Run Keyword If    '${sFileType}'=='File_1'    Set Variable    Holidays_Banks_
         ...    ELSE IF    '${sFileType}'=='File_2'    Set Variable    Holidays_Banks_
         ...    ELSE IF    '${sFileType}'=='Misc'    Set Variable    Holidays_Misc
    \
    \    ${XLSX_File}    Run Keyword And Return Status    Should Contain    ${File}    ${File_Type}
    \    ${Holidays_Banks}    Run Keyword And Return Status    Should Contain    ${File}    ${File_Name}
    \    Exit For Loop If    ${XLSX_File}==${True} and ${Holidays_Banks}==${True}
    
    ${XLSXFile}    Set Variable    ${datasetpath}${sInputFilePath}${File}
    Convert Xlsx To Xls    ${XLSXFile}

Mx Execute Template With Specific Test Case Name
    [Documentation]    This keyword will execute the template using the rowname instead of rowid
    ...    @author: hstone    21FEB2020    - initial draft
    [Arguments]    ${stemplateName}    ${sDataSet}    ${sDataColumnName}    ${sDataRowName}    ${sDataSheetName}
    Open Excel    ${sDataSet}
    Log    Data Set Open: '${sDataSet}'

    ${DataColumn_List}    Read Excel Row    1    sheet_name=${sDataSheetName}
    Log    Data Set Sheet Name: '${sDataSheetName}'
    Log    Data Set Sheet Column Names: '${DataColumn_List}'

    ${DataColumnName_Index}    Get Index From List    ${DataColumn_List}    ${sDataColumnName}
    Log    Column Name Index : '${DataColumnName_Index}'
    Run Keyword If    ${DataColumnName_Index}<0    Fail    '${sDataColumnName}' is not found at '${DataColumn_List}' Data Sheet Column Names.
    ${DataColumnName_Index}    Evaluate    ${DataColumnName_Index}+1
    
    ${DataRow_List}    Read Excel Column    ${DataColumnName_Index}    sheet_name=${sDataSheetName}
    Log    Row Names for '${sDataColumnName}': '${DataRow_List}'

    ${DataRowName_Index}    Get Index From List    ${DataRow_List}    ${sDataRowName}
    Log    Row Name Index : '${DataRowName_Index}'
    Run Keyword If    ${DataColumnName_Index}<0    Fail    '${sDataRowName}' is not found at '${DataRow_List}' Data Row Values.
    ${DataRowValue_Index}    Evaluate    ${DataRowName_Index}+1

    ${rowid_Column_Index}    Get Index From List    ${DataColumn_List}    rowid
    Put String To Cell    ${sDataSheetName}    ${rowid_Column_Index}    ${DataRowValue_Index}   ${DataRowName_Index}
    Close Current Excel Document

    Mx Execute Template With Multiple Data    ${stemplateName}    ${sDataSet}    ${DataRowName_Index}    ${sDataSheetName}

Write Data To Excel
    [Documentation]    This keyword is used to Write Data To Excel.
    ...    @author: hstone    21FEB2020    - Initial Create
    ...    @update: hstone    17MAR2020    - Updated 'Run Keyword If    '${multipleValue}'=='N'' to '...    ELSE IF    '${multipleValue}'=='N''
    ...    @update: jloretiz    15JUN2020    - add argument for column reference choice
    [Arguments]    ${sSheetName}    ${sColumnName}    ${rowid}    ${newValue}   ${sFilePath}=${ExcelPath}    ${multipleValue}=N    ${bTestCaseColumn}=False
    ...    ${sColumnReference}=Test_Case
    
    ### Open Excel
    Open Excel Document    ${sFilePath}    0

    ### Write Values
    Run Keyword If    '${multipleValue}'=='Y'    Write Data To All Column Rows    ${sSheetName}    ${sColumnName}    ${newValue}
    ...    ELSE IF    '${multipleValue}'=='N'    Write Data To Cell    ${sSheetName}    ${sColumnName}    ${rowid}    ${newValue}    ${bTestCaseColumn}    ${sColumnReference}
    
    ### Save and Close Document
    Save Excel Document    ${sFilePath}
    Close Current Excel Document

Write Data To All Column Rows
    [Documentation]    This keyword will be used for writing data to all rows of a specified column.
    ...    @author: hstone    20FEB2020    Initial Create
    [Arguments]    ${sSheetName}    ${sColumnName}    ${sData}

    ${ColumnHeader_Index}    Get Index of a Column Header Value    ${sSheetName}    ${sColumnName}
    ${Row_Count_Total}    Read Excel Column    ${ColumnHeader_Index}    0    ${sSheetName}       
    Write Excel Column    ${ColumnHeader_Index}    ${Row_Count_Total}    ${sData}    1    ${sSheetName}       

Write Data To Cell
    [Documentation]    This keyword will be used for writing data to single excel cell.
    ...    @author: hstone    20FEB2020    Initial Create
    ...    @update: jloretiz    15JUN2020    - add argument for column reference choice
    [Arguments]    ${sSheetName}    ${sColumnName}    ${rowid}    ${sData}    ${bTestCaseColumn}    ${sColumnReference}=Test_Case

    ${TestCaseHeader_Index}    ${ColumnHeader_Index}    Get Column Header Index    ${sSheetName}    ${sColumnName}    ${bTestCaseColumn}    ${sColumnReference}
    ${RowId_Index}    Get Index of a Row Value using a Reference Header Index    ${sSheetName}    ${rowid}    ${TestCaseHeader_Index}
    Write Excel Cell    ${RowId_Index}    ${ColumnHeader_Index}    ${sData}    ${sSheetName}

Get Index of a Column Header Value
    [Documentation]    This keyword is used to get the index of a column header value at the Excel Sheet.
    ...    @author: hstone    19FEB2020    Initial Create
    ...    @update: clanding    08DEC2020    Added optional argument for column index: ${iColumnIndex}
    [Arguments]    ${sSheetName}    ${sColumnName}    ${bTestCaseColumn}=False    ${iColumnIndex}=1

    ${ColumnIndex}    Run Keyword If    '${iColumnIndex}'=='1'    Set Variable    1
    ...     ELSE    Set Variable    ${iColumnIndex}

    ${DataColumn_List}    Read Excel Row    ${ColumnIndex}    sheet_name=${sSheetName}
    Log    Data Set Sheet Name: '${sSheetName}'
    Log    Data Set Sheet Column Names: '${DataColumn_List}'

    ### Get Target Column Value Index ###
    ${ColumnName_Index}    Get Index From List    ${DataColumn_List}    ${sColumnName}
    Log    Column Name Index : '${ColumnName_Index}'

    ### Verify if Target Column Value can be found on the data column list acquired
    Run Keyword If    ${ColumnName_Index}<0    Fail    '${sColumnName}' is not found at '${DataColumn_List}' Data Column Values.
    ${ColumnName_Index}    Evaluate    ${ColumnName_Index}+1

    [Return]    ${ColumnName_Index}

Get Column Header Index
    [Documentation]    This keyword is used to get the Column Header Index of Test_Case and given Column Name at the Excel Sheet.
    ...    @author: hstone    19FEB2020    Initial Create
    [Arguments]    ${sSheetName}    ${sColumnName}    ${bTestCaseColumn}=False    ${sTestCaseColReference}=Test_Case

    Log    (Get Column Header Index) sTestCaseColReference = '${sTestCaseColReference}'

    ${DataColumn_List}    Read Excel Row    1    sheet_name=${sSheetName}
    Log    Data Set Sheet Name: '${sSheetName}'
    Log    Data Set Sheet Column Names: '${DataColumn_List}'

    ### Get Test Case Header Count/Index ###
    ${TestCaseHeaderName_Index}    Get Index From List    ${DataColumn_List}    ${sTestCaseColReference}
    Log    Fetched Test Case Column Index : '${TestCaseHeaderName_Index}'

    ### Set Default Test Case Column Header Index
    ${TestCaseHeaderName_Index}    Run Keyword If    ${TestCaseHeaderName_Index}<0 or '${bTestCaseColumn}'=='False'   Set Variable    2
    ### Set Test Case Column Header Index Based on Actual Index on Excel Data Column Name List
    ...    ELSE    Evaluate    ${TestCaseHeaderName_Index}+1
    Log    Evaluated Test Case Column Index : '${TestCaseHeaderName_Index}'

    ### Get Target Column Value Index ###
    ${ColumnName_Index}    Get Index From List    ${DataColumn_List}    ${sColumnName}
    Log    Column Name Index : '${ColumnName_Index}'

    ### Verify if Target Column Value can be found on the data column list acquired
    Run Keyword If    ${ColumnName_Index}<0    Fail    '${sColumnName}' is not found at '${DataColumn_List}' Data Column Values.
    ${ColumnName_Index}    Evaluate    ${ColumnName_Index}+1

    [Return]    ${TestCaseHeaderName_Index}    ${ColumnName_Index}

Get Index of a Row Value using a Reference Header Index
    [Documentation]    This keyword is used to get index of a row value using a reference header index
    ...    @author: hstone    19FEB2020    Initial Create
    [Arguments]    ${sSheetName}    ${sRowValue}    ${sReferenceHeader_Index}

    ### Read Excel Sheet ###
    ${DataRow_List}    Read Excel Column    ${sReferenceHeader_Index}    sheet_name=${sSheetName}
    ${DataRowId_List}    Read Excel Column    1    sheet_name=${sSheetName}
    Log    Row Names Under Reference Header with Index '${sReferenceHeader_Index}' : '${DataRow_List}'

    ### Get Target Row Value Index ###
    ${IsPresentInList}    Run Keyword And Return Status    List Should Contain Value    ${DataRow_List}    ${sRowValue}
    ${IsPresentInList_As_Int}    ${RowValue_Int}    Check if Row Value Exists on List as Int    ${DataRow_List}    ${sRowValue}
    ${DataRowName_Index}    Run Keyword If    ${IsPresentInList}==${True}    Get Index From List    ${DataRow_List}    ${sRowValue}
    ...    ELSE IF    ${IsPresentInList_As_Int}==${True}    Get Index From List    ${DataRow_List}    ${RowValue_Int}
    ...    ELSE    Get Index From List    ${DataRowId_List}    ${sRowValue}
    Log    Row Name Index for '${sRowValue}' : '${DataRowName_Index}'

    ### Verify if Target Row Value can be found on the data row list acquired
    Run Keyword If    ${DataRowName_Index}<0    Fail    '${sRowValue}' is not found at '${DataRow_List}' Data Row Values.
    ${DataRowValue_Index}    Evaluate    ${DataRowName_Index}+1

    [Return]    ${DataRowValue_Index}

Check if Row Value Exists on List as Int
    [Documentation]    This keyword is used to check if value exists on a list as a string
    ...    @author: hstone    13APR2020    Initial Create
    [Arguments]    ${lTarget_List}    ${sValue}

    ${IsPresentInList}    Set Variable    ${False}

    ### Get Int Conversion Status ###
    ${IsIntConvPassed}    Run Keyword And Return Status    Convert To Integer    ${sValue}

    ### Proceed with Int Conversion and List Check if Conversion Passed. If Conversion Failed, set return value to False
    ${IsPresentInList}    ${RowValue_Int}    Run Keyword If    ${IsIntConvPassed}==${True}    Check if a String Exists as Int on a List    ${lTarget_List}    ${sValue}
    
    [Return]    ${IsPresentInList}    ${RowValue_Int}

Check if a String Exists as Int on a List
    [Documentation]    This keyword is used to check if a string exists as an integer on a list.
    ...    @author: hstone    13APR2020    Initial Create
    [Arguments]    ${lTarget_List}    ${sValue}

    ${Value_Int}    Convert To Integer    ${sValue}
    ${IsPresentInList}    Run Keyword And Return Status    List Should Contain Value    ${lTarget_List}    ${Value_Int}

    [Return]    ${IsPresentInList}    ${Value_Int}

Read Data From Excel
    [Documentation]    This keyword will be used for dynamically reading of Excel File supported by Python 3
    ...    @author: ritragel    25OCT2019    Initial Create
    ...    @update: hstone      16MAR2020    Code Optimization: Replaced Keyw
    ...    @update: shirhong    17NOV2020    Update Read Data From Cell: add Header Index for reading diff rows. Default is 1
    [Arguments]    ${sSheetName}    ${sColumnName}    ${rowid}   ${sFilePath}=${ExcelPath}    ${readAllData}=N    ${bTestCaseColumn}=True    ${sTestCaseColReference}=rowid    ${iHeaderIndex}=1
    ### Open Excel
    Open Excel Document    ${sFilePath}    0
    
    Log    (Read Data From Excel) sTestCaseColReference = '${sTestCaseColReference}'

    ### Read Values
    ${sData}    Run Keyword If    '${readAllData}'=='Y'    Read Data From All Column Rows    ${sSheetName}    ${sColumnName}
    ...    ELSE IF    '${readAllData}'=='N'    Read Data From Cell    ${sSheetName}    ${sColumnName}    ${rowid}    ${bTestCaseColumn}    ${sTestCaseColReference}    ${iHeaderIndex}

    Log    Excel Date Read from Excel : '${sData}'
    ### Close File and Return Value
    Close Current Excel Document
    [Return]    ${sData}

Read Data From All Column Rows
    [Documentation]    This keyword will be used for reading data from all rows of a specified column.
    ...    @author: hstone    16MAR2020    Initial Create
    ...    @update: clanding    08DEC2020    Added optional argument for column index: ${iColumnIndex}
    [Arguments]    ${sSheetName}    ${sColumnName}     ${iColumnIndex}=1

    ${ColumnHeader_Index}    Get Index of a Column Header Value    ${sSheetName}    ${sColumnName}    iColumnIndex=${iColumnIndex}
    ${Column_Data}    Read Excel Column    ${ColumnHeader_Index}    0    ${sSheetName}
    Remove Values From List    ${Column_Data}    ${sColumnName}

    [Return]    ${Column_Data}

Read Data From Cell
    [Documentation]    This keyword will be used for reading data from single excel cell.
    ...    @author: hstone    16MAR2020    Initial Create
    ...    @author: shirhong    17NOV2020    Add condition for reading of diff rows not equal to first row
    [Arguments]    ${sSheetName}    ${sColumnName}    ${rowid}    ${bTestCaseColumn}    ${sTestCaseColReference}=None    ${iHeaderIndex}=1

    Log    (Read Data From Cell) sTestCaseColReference = '${sTestCaseColReference}'

    ${TestCaseHeader_Index}    ${ColumnHeader_Index}    Run Keyword If    '${sTestCaseColReference}'=='None'    Get Column Header Index    ${sSheetName}    ${sColumnName}    ${bTestCaseColumn}
    ...    ELSE IF    '${iHeaderIndex}'!='1'    Get Column Header Index Using Dynamic Header    ${sSheetName}    ${sColumnName}    ${bTestCaseColumn}    ${sTestCaseColReference}    ${iHeaderIndex}
    ...    ELSE    Get Column Header Index    ${sSheetName}    ${sColumnName}    ${bTestCaseColumn}    ${sTestCaseColReference}
    ${RowId_Index}    Get Index of a Row Value using a Reference Header Index    ${sSheetName}    ${rowid}    ${TestCaseHeader_Index}
    ${Cell_Data}    Read Excel Cell    ${RowId_Index}    ${ColumnHeader_Index}    ${sSheetName}


    [Return]    ${Cell_Data}

Subtract Time from From Date and Returns Weekday
    [Documentation]    This keyword subtracts time from a date, and if the date calculated falls on a weekend, this keyword will return the closest Monday.
    ...                Default Input Date format is LIQ Date Format (%d-%b-%Y)
    ...                Default Result Date format is LIQ Date Format (%d-%b-%Y)
    ...    @author: hstone    18MAR2020    Initial create
    [Arguments]    ${sDate}    ${sDays_To_Subtract}    ${sInput_Date_Format}=%d-%b-%Y    ${sResult_Date_Format}=%d-%b-%Y

    ### Set Variable for Day Subrtraction ###
    ${Time_To_Subtract}    Run Keyword If    ${sDays_To_Subtract}>1    Set Variable    ${sDays_To_Subtract}${SPACE}days
    ...    ELSE IF    ${sDays_To_Subtract}==1    Set Variable    ${sDays_To_Subtract}${SPACE}day
    ...    ELSE    Fail    '${sDays_To_Subtract}' is not a valid value for days to subtract. Value should be greater than or equal to 1.

    ### Calculate for the subtracted date ###
    ${Date_Result}    Subtract Time From Date    ${sDate}    ${Time_To_Subtract}    result_format=${sResult_Date_Format}    date_format=${sInput_Date_Format}
    Log    (Subtract Time from LIQ Date Format) Subtracted Date Result : '${Date_Result}'

    ### Get the Day Equivalent of the Date Part ###
    ${Day_Result}    Convert Date    ${Date_Result}    result_format=%A    date_format=${sInput_Date_Format}

    ### If the day falls on a weekend, at days so that the date will fall on the closest Monday ###
    ${Date_Result_Monday}    Run Keyword If    '${Day_Result}'=='Saturday'    Add Time To Date    ${Date_Result}    2 days    result_format=${sResult_Date_Format}    date_format=${sInput_Date_Format}
    ...    ELSE IF    '${Day_Result}'=='Sunday'    Add Time To Date    ${Date_Result}    1 day     result_format=${sResult_Date_Format}    date_format=${sInput_Date_Format}

    ### If the the closest monday calculation has a result, use the closest monday date result; If none, use the date result ####
    ${Final_Result}    Run Keyword If    '${Date_Result_Monday}'=='None'    Set Variable    ${Date_Result}
    ...    ELSE    Set Variable    ${Date_Result_Monday}

    [Return]    ${Final_Result}

Add Time from From Date and Returns Weekday
    [Documentation]    This keyword adds time from a date, and if the date calculated falls on a weekend, this keyword will return the closest Monday.
    ...                Default Input Date format is LIQ Date Format (%d-%b-%Y)
    ...                Default Result Date format is LIQ Date Format (%d-%b-%Y)
    ...    @author: hstone    18MAR2020    Initial create
    ...    @update: hstone    11JUN2020    - Added Keyword Pre=processing
    ...                                    - Added Keyword Post-processing
    ...                                    - Added Optional Argument: ${sRuntimeVar_Result}
    [Arguments]    ${sDate}    ${sDays_To_Add}    ${sInput_Date_Format}=%d-%b-%Y    ${sResult_Date_Format}=%d-%b-%Y    ${sRuntimeVar_Result}=None

    ### Keyword Pre-processing ###
    ${Date}    Acquire Argument Value    ${sDate}
    ${Days_To_Add}    Acquire Argument Value    ${sDays_To_Add}
    ${Input_Date_Format}    Acquire Argument Value    ${sInput_Date_Format}
    ${Result_Date_Format}    Acquire Argument Value    ${sResult_Date_Format}

    ### Set Variable for Day Addition ###
    ${Time_To_Add}    Run Keyword If    ${Days_To_Add}>1    Set Variable    ${Days_To_Add}${SPACE}days
    ...    ELSE IF    ${Days_To_Add}==1    Set Variable    ${Days_To_Add}${SPACE}day
    ...    ELSE    Fail    '${Days_To_Add}' is not a valid value for days to add. Value should be greater than or equal to 1.

    ### Calculate for the added date ###
    ${Date_Result}    Add Time To Date    ${Date}    ${Time_To_Add}    result_format=${Result_Date_Format}    date_format=${Input_Date_Format}
    Log    (Subtract Time from LIQ Date Format) Subtracted Date Result : '${Date_Result}'

    ### Get the Day Equivalent of the Date Part ###
    ${Day_Result}    Convert Date    ${Date_Result}    result_format=%A    date_format=${Input_Date_Format}

    ### If the day falls on a weekend, at days so that the date will fall on the closest Monday ###
    ${Date_Result_Monday}    Run Keyword If    '${Day_Result}'=='Saturday'    Add Time To Date    ${Date_Result}    2 days    result_format=${Result_Date_Format}    date_format=${Input_Date_Format}
    ...    ELSE IF    '${Day_Result}'=='Sunday'    Add Time To Date    ${Date_Result}    1 day     result_format=${Result_Date_Format}    date_format=${Input_Date_Format}

    ### If the the closest monday calculation has a result, use the closest monday date result; If none, use the date result ####
    ${Final_Result}    Run Keyword If    '${Date_Result_Monday}'=='None'    Set Variable    ${Date_Result}
    ...    ELSE    Set Variable    ${Date_Result_Monday}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRuntimeVar_Result}    ${Final_Result}

    [Return]    ${Final_Result}

Acquire Date Value Specified in Excel Data
    [Documentation]    This keyword is used to extract the date value based on what is entered by the user at the SAPWUL Excel Data date inputs.
    ...    @author: hstone    07APR2020    Initial create
    [Arguments]    ${sDate}

    ${List_Date}    Split String    ${sDate}    :
    ${Length_Date}    Get Length    ${List_Date}
    ${Input_Date}    Convert To Uppercase    @{List_Date}[${INPUT_DATE}]
    
    ### Check if Input Date is System Date, System Date with Offset or User Desired Input Date
    ${Result_Date}    Run Keyword If    '${Input_Date}'=='${SYSTEM_DATE}' and ${Length_Date}==1    Get System Date
    ...    ELSE IF    '${Input_Date}'=='${SYSTEM_DATE}' and ${Length_Date}==2    Calculate for System Date Offset    @{List_Date}[${DATE_OFFSET_IN_DAYS}]
    ...    ELSE    Set Variable    ${sDate}

    [Return]    ${Result_Date}

Calculate for System Date Offset
    [Documentation]    This keyword used to calculate the system date offset supplied.
    ...    @author: hstone    07APR2020    Initial create
    [Arguments]    ${sSystem_Date_Offset_Value}

    ${System_Date}    Get System Date
    ${Offset_Days}    Remove String    ${sSystem_Date_Offset_Value}    +    -

    ${System_Date_With_Offset}    Run Keyword If    '+' in '${sSystem_Date_Offset_Value}'    Add Time from From Date and Returns Weekday    ${System_Date}    ${Offset_Days}
    ...    ELSE IF    '-' in '${sSystem_Date_Offset_Value}'    Subtract Time from From Date and Returns Weekday    ${System_Date}    ${Offset_Days}
    ...    ELSE    Fail    Invalid Offset Days Input. Value should contain '+' or '-'.

    [Return]    ${System_Date_With_Offset}
    
Driver Script
    [Documentation]    This keyword is used to execute list of scenarios on excel file.
    ...    @author: dahijara    24MAR2020    - initial create
    ...    @update: amansuet    17APR2020    - updated condition to write passed,failed and no run in excel and added log results
    ...    @update: hstone      08MAY2020    - Replaced 'Scenario List' sheet name with 'Test Case List'
    ...                                      - Replaced 'Scenario Name' with 'Test Case Name'
    [Arguments]    ${sExcelFilePath}

    ${ScenarioList_Sheet}    Set Variable    Test Case List

    #Open Scenario List Sheet
    Open Excel    ${sExcelFilePath}
    ${RowCount}    Get Row Count    ${ScenarioList_Sheet}
    Log    ${RowCount}

    #Get Scenario name and Run column index
    ${ScenarioList_ColHdrList}    Get Row Values    ${ScenarioList_Sheet}    1
    ${ScenarioNameCol_Index}    Get List Index    ${ScenarioList_ColHdrList}    Test Case Name
    ${RunCol_Index}    Get List Index    ${ScenarioList_ColHdrList}    Run (Yes/No)
    ${RunStatusCol_Index}    Get List Index    ${ScenarioList_ColHdrList}    Run Status
    ${TimeStampCol_Index}    Get List Index    ${ScenarioList_ColHdrList}    Timestamp

    ${ScenarioNameCol_Index}    Evaluate    ${ScenarioNameCol_Index}+1
    ${RunCol_Index}    Evaluate    ${RunCol_Index}+1
    ${RunStatusCol_Index}    Evaluate    ${RunStatusCol_Index}+1
    ${TimeStampCol_Index}    Evaluate    ${TimeStampCol_Index}+1

    # Get Scenario List
    ${ScenarioList}    Read Excel Column    ${ScenarioNameCol_Index}    sheet_name=${ScenarioList_Sheet}
    ${RunValueList}    Read Excel Column    ${RunCol_Index}    sheet_name=${ScenarioList_Sheet}    
    ${ScenarioCount}    Get Length    ${ScenarioList}
    Close Current Excel Document

    :FOR    ${ScenarioCtr}    IN RANGE    1    ${ScenarioCount}
    \    ${ScenarioName}    Set Variable    ${ScenarioList}[${ScenarioCtr}]
    \    Set Global Variable    ${SCENARIONAME_CURRENT}    ${ScenarioName}
    \    Exit For Loop If    'None' in '${ScenarioName}'
    \    Log    SCENARIO NAME: ${ScenarioName}
    # Get Current Time and Date
    \    ${RuntimeStamp}    Get Current Date    result_format=datetime
    # Execute Scenarios
    \    ${Run_Value}    Set Variable    ${RunValueList}[${ScenarioCtr}]
    \    ${Run_Value}    Run Keyword If    '${Run_Value}'!='None'    Set Variable    ${Run_Value.upper()}
    \    ${isRunPassed}    Run Keyword If    '${Run_Value}' == 'YES'    Run Keyword And Return Status    Execute Scenario Steps    ${sExcelFilePath}    ${ScenarioName}
    ...    ELSE    Set Variable    None
    \    ${isRunPassed_Value}    Run Keyword If    ${isRunPassed}==${True}    Set Variable    Passed
    ...    ELSE IF    ${isRunPassed}==${False}    Set Variable    Failed
    ...    ELSE IF    '${isRunPassed}'=='None'    Set Variable    No Run
    \    Run Keyword If    ${isRunPassed}==${False}    Run Keyword And Continue On Failure    Fail    Test Case: '${ScenarioName}' Failed.
    \    Log    Run Status : ${isRunPassed_Value}
    # Write to Excel Execution Status
    \    ${CurrScenarioRow}    Evaluate    ${ScenarioCtr}+1
    \    Open Excel    ${sExcelFilePath}
    \    Write Excel Cell    ${CurrScenarioRow}    ${RunStatusCol_Index}    ${isRunPassed_Value}    ${ScenarioList_Sheet}
    \    Write Excel Cell    ${CurrScenarioRow}    ${TimeStampCol_Index}    ${RuntimeStamp}    ${ScenarioList_Sheet}
    \    Save Excel Document    ${sExcelFilePath}
    \    Close Current Excel Document

Execute Scenario Steps
    [Documentation]    This keyword is used to execute business keywords from an excel file.
    ...    @author: dahijara    31MAR2020    - initial create
	...    @update: amansuet    21APR2020    - added condition to log results.
	...    @update: hstone      05MAY20202   - Added 'Exit For Loop' when an  keyword fails
    [Arguments]    ${sExcelFilePath}    ${sScenarioSheetName}

    Open Excel    ${sExcelFilePath}
    ${RowCount}    Get Row Count    ${sScenarioSheetName}
    Log    ${RowCount}

    #Get Column Index
    ${ColumnHeaderList}    Get Row Values    ${sScenarioSheetName}    1
    ${TestStepCol_Index}    Get List Index    ${ColumnHeaderList}    Test_Step
    ${TestStepCol_Index}    Evaluate    ${TestStepCol_Index}+1

    #Get Steps List
    ${TestStepsList}    Read Excel Column    ${TestStepCol_Index}    sheet_name=${sScenarioSheetName}
    ${TestStepsCount}    Get Length    ${TestStepsList}
    Close Current Excel Document
    :FOR    ${stepCtr}    IN RANGE    1    ${TestStepsCount}
    \    ${Keyword}    Return Keyword and Set Arguments To Global Variables    ${sExcelFilePath}    ${sScenarioSheetName}    ${stepCtr}    ${TestStepCol_Index} 
    \    Exit For Loop If    'None' in '${Keyword}'
    \    ${isKeywordPassed}    Run Keyword And Return Status    ${Keyword}
    \    Run Keyword If    ${isKeywordPassed}==${False}    Run Keywords    Run Keyword And Continue On Failure    FAIL    Executed keyword has failed.
    ...    AND    Log    Test Step: '${Keyword}' Failed.    level=ERROR
    ...    AND    Exit For Loop
    ...    ELSE    Log    Test Step: '${Keyword}' Passed.

Get List Index
    [Documentation]    This keyword is used to get index from a list.
    ...    @author: dahijara    31MAR2020    - initial create
    [Arguments]    ${aList}    ${sListValue}

    ${ListCount}    Get Length    ${aList}
    ${List_Index}    Set Variable    ${EMPTY}
    :FOR    ${index}    IN RANGE    0    ${ListCount}
    \    Exit For Loop If    ${index} == ${ListCount}
    \    Exit For Loop If    '${aList}[${index}]' == 'None'
    \    ${List_Index}    Run Keyword If    '${aList}[${index}]' == '${sListValue}'    Set Variable    ${index}
    \    Exit For Loop If    '${List_Index}' != 'None' and '${List_Index}' != '${EMPTY}'
    Run Keyword If    '${List_Index}' == 'None' or '${List_Index}' == '${EMPTY}'    Fail    '${sListValue}' Does Not Exist in ${aList}.
    Log    List Value Index: ${List_Index}
    [Return]    ${List_Index}

Return Keyword and Set Arguments To Global Variables
    [Documentation]    This keyword is used to set list of arguments from an excel file to global variable, And Return business keyword name.
    ...    @author: dahijara    24MAR2020    - initial create
    [Arguments]    ${sExcelFilePath}    ${sSheetName}    ${iRowIndex}    ${ColHeaderIndex}

    Open Excel    ${sExcelFilePath}
    ${iRowIndex}    Evaluate    ${iRowIndex}+1
    ${RowValues}    Read Excel Row    ${iRowIndex}    sheet_name=${sSheetName}
    ${ValuesCount}    Get Length    ${RowValues}
    ${Keyword_Index}    Evaluate    ${ColHeaderIndex}-1
    ${FirstArgument_Index}    Evaluate    ${Keyword_Index}+1

    # Get Business Keyword
    ${Keyword}    Set Variable    ${RowValues}[${Keyword_Index}]
    ${Keyword}    Catenate    SEPARATOR=    BUS_    ${Keyword}
    Log    ${Keyword}
    ${ArgCounter}    Set Variable    0

    #Set Keyword Arguments From Excel file to Global Var
    :FOR    ${index}    IN RANGE    ${FirstArgument_Index}    ${ValuesCount}
    \    ${ArgCounter}    Evaluate    ${ArgCounter}+1
    \    Log    ${RowValues}[${index}]
    \    Exit For Loop If    '${RowValues}[${index}]' == 'None'
    \    Run Keyword If    '${RowValues}[${index}]'=='Blank'    Set Global Variable    ${ARGUMENT_${ArgCounter}}    None
         ...    ELSE    Set Global Variable    ${ARGUMENT_${ArgCounter}}    ${RowValues}[${index}]

    Close Current Excel Document
    [Return]    ${Keyword}

Acquire Argument Values From List
    [Documentation]    This keyword is used to acquire arguments values on the list supplied.
    ...    @author: hstone    09JUN2020    - initial create
    [Arguments]    @{sArguments_List}

    ### Extract Argument List ###
    ${Argument_List}    Set Variable    @{sArguments_List}[0]
    
    ### Extraction Loop Initialization ###
    ${Arguments_Count}    Get Length    ${Argument_List}
    ${Argument_Index}    Set Variable    0
    ${Argument_Value_List}    Create List

    :FOR    ${Argument_Index}    IN RANGE    ${Arguments_Count}
    \    ${Argument_Value}    Acquire Argument Value    @{Argument_List}[${Argument_Index}]
    \    Append To List    ${Argument_Value_List}    ${Argument_Value}

    [Return]    ${Argument_Value_List}

Acquire Argument Value
    [Documentation]    This keyword is used to acquire arguments value based on the 'sArgument_Excel_Value' input and return the extracted value.
    ...    @author: amansuet    31MAR2020    - initial create
    ...    @update: amansuet    14APR2020    - updated arguments on the updated keywords and optimize script
    ...    @update: amansuet    14APR2020    - added optional argument ${sArugment_Type} used in Set Runtime Execution Value only.
    ...    @update: hstone      04MAY2020    - Replaced Fail Statement with 'Set Variable    ${sArgument_Excel_Value}' at Else Condition on 'Extract Argument Values' Block
    ...    @update: hstone      11MAY2020    - Added a condition for handling integer values and floats from the old framework
    [Arguments]    ${sArgument_Value}    ${sArgument_Type}=None
    ### Get Split String Status
    ${SplitStringStatus}    Run Keyword And Return Status    Split String    ${sArgument_Value}    :
    ${Extracted_Argument_Value}    Run Keyword If    ${SplitStringStatus}==${True}    Extract Argument From String    ${sArgument_Value}    ${sArgument_Type}
    ...    ELSE    Set Variable    ${sArgument_Value}
    [Return]    ${Extracted_Argument_Value}
    
Extract Argument From String
    [Documentation]    This keyword is used to extract argument value from a string origin.
    ...    @author: hstone    31MAR2020    - initial create
    ...    @update: hstone    10JUN2020    - Added '${Arg_User_Input}    Remove String    ${Arg_User_Input}    ''
    [Arguments]    ${sArgument_Excel_Value}    ${sArgument_Type}=None

    ${List_Argument_Excel_Value}    Split String    ${sArgument_Excel_Value}    :
    ${Length_Argument_Excel_Value}    Get Length    ${List_Argument_Excel_Value}
    ${Arg_User_Input}    Convert To Uppercase    @{List_Argument_Excel_Value}[${ARGUMENT_USER_INPUT}]
    ${Arg_User_Input}    Remove String    ${Arg_User_Input}    '
    
    # Set Variables for Runtime
    ${Arg_Prefix_Input}    Run Keyword If    ${Length_Argument_Excel_Value}==3 and '${Arg_User_Input}'=='${RUNTIME}'    Set Variable    @{List_Argument_Excel_Value}[${ARGUMENT_PREFIX_INPUT}]    
    
    # Set Variables for GetRuntime
    ${Variable_TestCase_Input}    Run Keyword If    ${Length_Argument_Excel_Value}==3 and '${Arg_User_Input}'=='${GETRUNTIME}'    Set Variable    @{List_Argument_Excel_Value}[${ARGUMENT_VARIABLE_INPUT}]
    ${Variable_Name_Input}    Run Keyword If    ${Length_Argument_Excel_Value}==3 and '${Arg_User_Input}'=='${GETRUNTIME}'    Set Variable    @{List_Argument_Excel_Value}[${ARGUMENT_SECOND_VARIABLE_INPUT}]

    # Extract Argument Values
    ${Extracted_Argument_Value}    Run Keyword If    '${Arg_User_Input}'=='${RUNTIME}' and '${sArgument_Type}'!='None'    Set Runtime Execution Value    ${Length_Argument_Excel_Value}    ${Arg_Prefix_Input}    ${sArgument_Type}
    ...    ELSE IF    '${Arg_User_Input}'=='${GETRUNTIME}' and '${sArgument_Type}'=='None'    Get Runtime Execution Value    ${Length_Argument_Excel_Value}    ${Variable_TestCase_Input}    ${Variable_Name_Input}
    ...    ELSE IF    ${Length_Argument_Excel_Value}==1 and '${Arg_User_Input}'!='${RUNTIME}' and '${Arg_User_Input}'!='${GETRUNTIME}'    Set Variable    ${sArgument_Excel_Value}
    ...    ELSE    Set Variable    ${sArgument_Excel_Value}

    [Return]    ${Extracted_Argument_Value}

Set Runtime Execution Value
    [Documentation]    This keyword is used to generated values of runtime.
    ...    @author: amansuet    06APR2020    - initial create
    ...    @update: amansuet    14APR2020    - removed unused argument
    ...    @update: amansuet    24APR2020    - merge generate runtime value
    [Arguments]    ${iLength_Argument_Excel_Value}    ${sArg_Prefix_Input}    ${sArgument_Type}

    ${Extracted_Argument_Value}    Run Keyword If    ${iLength_Argument_Excel_Value}==3 and '${sArg_Prefix_Input}'!='' and '${sArgument_Type}'=='${ARG_TYPE_UNIQUE_NAME_VALUE}'    Auto Generate Name Test Data    ${sArg_Prefix_Input}
    ...    ELSE IF    ${iLength_Argument_Excel_Value}==2 and '${sArgument_Type}'=='${ARG_TYPE_UNIQUE_NAME_VALUE}'    Auto Generate Name Test Data    ${CONSTANT_ROBOT_PREFIX}
    ...    ELSE IF    ${iLength_Argument_Excel_Value}==3 and '${sArg_Prefix_Input}'!='' and '${sArgument_Type}'=='${ARG_TYPE_UNIQUE_DIGIT}'    Auto Generate Only 5 Numeric Test Data    ${sArg_Prefix_Input}
    ...    ELSE IF    ${iLength_Argument_Excel_Value}==2 and '${sArgument_Type}'=='${ARG_TYPE_UNIQUE_DIGIT}'    Auto Generate Only 5 Numeric Test Data    ${CONSTANT_ROBOT_PREFIX}
    ...    ELSE    Fail    Invalid Argument Type. Argument Type Value : '${sArgument_Type}'

    [Return]    ${Extracted_Argument_Value}

Get Runtime Execution Value
    [Documentation]    This keyword is used to get the generated values of runtime from the excel file.
    ...    @author: amansuet    06APR2020    - initial create
    ...    @update: amansuet    14APR2020    - removed unused argument
    [Arguments]    ${iLength_Argument_Excel_Value}    ${sVariable_TestCase_Input}    ${sVariable_Name_Input}

    ${Extracted_Argument_Value}    Run Keyword If    ${iLength_Argument_Excel_Value}==3 and '${sVariable_TestCase_Input}'!='' and '${sVariable_Name_Input}'!=''    Read Data From Runtime Excel File    ${sVariable_TestCase_Input}    ${sVariable_Name_Input}

    [Return]    ${Extracted_Argument_Value}

Save Values of Runtime Execution on Excel File
    [Documentation]    This keyword is used to save the generated values of runtime to the excel file.
    ...    @author: amansuet    31MAR2020    - initial create
    [Arguments]    ${sArgument_Excel_Value}    ${sExtracted_Argument_Value}
 
    ${List_Argument_Excel_Value}    Split String    ${sArgument_Excel_Value}    :
    ${Length_Argument_Excel_Value}    Get Length    ${List_Argument_Excel_Value}
    ${Arg_User_Input}    Convert To Uppercase    @{List_Argument_Excel_Value}[${ARGUMENT_USER_INPUT}]
    ${Variable_Name_Input}    Run Keyword If    ${Length_Argument_Excel_Value}>=2    Set Variable    @{List_Argument_Excel_Value}[${ARGUMENT_VARIABLE_INPUT}]

    Run Keyword If    ${Length_Argument_Excel_Value}==1 and '${Arg_User_Input}'!='${RUNTIME}'    Log    User input non-runtime value.
    ...    ELSE IF    ${Length_Argument_Excel_Value}>=2 and '${Arg_User_Input}'=='${RUNTIME}' and '${Variable_Name_Input}'!=''    Write Data to Runtime Excel File    ${SCENARIONAME_CURRENT}    ${Variable_Name_Input}    ${sExtracted_Argument_Value}
    ...    ELSE    Fail    Invalid Argument Value for Runtime. Runtime format should be = 'Runtime:<VariableName>' or 'Runtime:<VariableName>:<Prefix>'.

Write Data to Runtime Excel File
    [Documentation]    This keyword is used to write data on Runtime Excel File.
    ...    @author: hstone    30MAR2020    Initial Create
    [Arguments]    ${sTestCase}    ${sName}    ${sValue}
 
    # Formulate Data Name
    ${sDataName}    Catenate    SEPARATOR=_    ${sTestCase}    ${sName}
 
    # Open Excel
    Open Excel Document    ${RUNTIME_EXCEL_FILE}    0
 
    # Read Data Names from Excel
    ${lColumnData}    Read Excel Column    ${RUNTIME_EXCEL_COLUMN_DATA_NAME}    ${RUNTIME_EXCEL_READ_ALL}    ${RUNTIME_EXCEL_SHEET}
    
    # Get the index of the generated data name
    ${iDataNameIndex}    Get Index From List    ${lColumnData}    ${sDataName}
 
    # Verify if Target Column Value can be found on the data column list acquired
    Run Keyword If    ${iDataNameIndex}<0    Append Data to Runtime Excel File    ${lColumnData}    ${sDataName}    ${sValue}
    ...    ELSE    Update Data on Runtime Excel File    ${iDataNameIndex}    ${sDataName}    ${sValue}
 
    # Save and Close Document
    Save Excel Document    ${RUNTIME_EXCEL_FILE}
    Close Current Excel Document
 
Append Data to Runtime Excel File
    [Documentation]    This keyword is used to append data to runtime excel file.
    ...    @author: hstone    30MAR2020    Initial Create
    [Arguments]    ${lColumnData}    ${sDataName}    ${sValue}
 
    ${ColumntData}    Copy List    ${lColumnData}
    Remove Values From List    ${ColumntData}    ${NONE}
    Log    ${ColumntData}
 
    # Get Total Columnt Data Count
    ${iTotalColumnData}    Get Length    ${ColumntData}
 
    # Formulate target row number to append
    ${TargetRowNumber}    Evaluate    ${iTotalColumnData}+1
 
    # Write Data Name
    Write Excel Cell     ${TargetRowNumber}     ${RUNTIME_EXCEL_COLUMN_DATA_NAME}     ${sDataName}    ${RUNTIME_EXCEL_SHEET}
 
    # Write Data Value
    Write Excel Cell     ${TargetRowNumber}     ${RUNTIME_EXCEL_COLUMN_DATA_VALUE}     ${sValue}    ${RUNTIME_EXCEL_SHEET}
 
Update Data on Runtime Excel File
    [Documentation]    This keyword is used to update data on runtime excel file.
    ...    @author: hstone    30MAR2020    Initial Create
    [Arguments]    ${iDataNameIndex}    ${sDataName}    ${sValue}
 
    # Formulate target row number to update
    ${TargetRowNumber}    Evaluate    ${iDataNameIndex}+1
 
    # Write Data Value
    Write Excel Cell     ${TargetRowNumber}     ${RUNTIME_EXCEL_COLUMN_DATA_VALUE}     ${sValue}    ${RUNTIME_EXCEL_SHEET}
 
Read Data From Runtime Excel File
    [Documentation]    This keyword is used to write data on Runtime Excel File.
    ...    @author: hstone    30MAR2020    Initial Create
    [Arguments]    ${sTestCase}    ${sName}
 
    # Formulate Data Name
    ${sDataName}    Catenate    SEPARATOR=_    ${sTestCase}    ${sName}
 
    # Open Excel
    Open Excel Document    ${RUNTIME_EXCEL_FILE}    0
 
    # Read Data Names from Excel
    ${lColumnData}    Read Excel Column    ${RUNTIME_EXCEL_COLUMN_DATA_NAME}    ${RUNTIME_EXCEL_READ_ALL}    ${RUNTIME_EXCEL_SHEET}
    
    # Get the index of the generated data name
    ${iDataNameIndex}    Get Index From List    ${lColumnData}    ${sDataName}
 
    # Verify if Target Column Value can be found on the data column list acquired
    Run Keyword If    ${iDataNameIndex}<0    Fail    DataName Not Found: TestCase = '${sTestCase}'; VariableName = '${sName}'.
 
    # Formulate target row number to update
    ${TargetRowNumber}    Evaluate    ${iDataNameIndex}+1
    
    # Read Data Value
    ${Value}     Read Excel Cell     ${TargetRowNumber}     ${RUNTIME_EXCEL_COLUMN_DATA_VALUE}     ${RUNTIME_EXCEL_SHEET}
 
    # Close Document
    Close Current Excel Document
    
    [Return]     ${Value}
    
Convert to Boolean Type if String is True of False
    [Documentation]    This keyword is used to convert a string to boolean type when the string's value is true or false (Case Insensitive).
    ...                @author: hstone    17SEP2019    Initial create
    [Arguments]    ${sString}
    ${sString_UpperCase}    Convert To Uppercase    ${sString}
    ${result}    Run Keyword If    '${sString_UpperCase}'=='TRUE' or '${sString_UpperCase}'=='FALSE'    Set Variable    ${${sString}}
    ...    ELSE    Set Variable   ${sString}
    [Return]    ${result}

Compare Two Numbers
    [Documentation]    This keyword is used for comparison of two numbers if they are equal or not
    ...                @author: hstone    19MAY2020    Initial create
    [Arguments]    ${Num1}    ${Num2}

    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${Num1}    ${Num2}

Convert Number to Percentage Format
    [Documentation]    This keyword converts a number (String) to percentage Format
    ...                @author: hstone    19MAY2020    Initial create
    [Arguments]    ${sInput}    ${sDecimal_Count}

    ${Result}    Convert To Number    ${sInput}
    ${Result}    Evaluate  "%.${sDecimal_Count}f" % ${Result}
    ${Result}    Convert To String    ${Result}
    ${Result}    Catenate    SEPARATOR=    ${Result}    %
    Log    ${Result}

    [Return]    ${Result}

Convert Percentage to Decimal Value
    [Documentation]    This keyword converts a percentage to its decimal value.
    ...                @author: hstone    19MAY2020    Initial create
    [Arguments]    ${sInput}

    @{Input}    Split String    ${sInput}    %
    ${Result}    Convert To Number    @{Input}[0]
    ${Result}    Evaluate    ${Result}/100
    ${Result}    Convert To String    ${Result}
    Log    ${Result}

    [Return]    ${Result}

Navigate Notebook Pending Transaction
    [Documentation]    This keyword navigates the Pending tab of a Notebook, and does a specific transaction.
    ...    @author: hstone    28MAY2020      - Initial Create
    [Arguments]    ${Notebook_Locator}    ${NotebookTab_Locator}    ${NotebookPendingTab_Locator}    ${Transaction}
    mx LoanIQ activate window    ${Notebook_Locator}
    Mx LoanIQ Select Window Tab    ${NotebookTab_Locator}    Pending
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${NotebookPendingTab_Locator}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed

Write Data to Excel Using Row Index and Column Index
    [Documentation]    This keyword is used to write data to excel using coordinates and without rowid and columnname value.
    ...    This keyword will populate data for indicated row number and column number.
    ...    Column Number and Row Number starts with 1.
    ...    @author: dahijara    15APR2020    - added keyword to close excel file after saving
    [Arguments]    ${sSheetName}    ${iColumnNum}    ${iRowNum}    ${sNewValue}   ${sfilePath}=${ExcelPath}
    
    Log    ${sfilePath}
    Open Excel    ${sfilePath}   
    Write Excel Cell    ${iRowNum}    ${iColumnNum}    ${sNewValue}    ${sSheetName}
    Save Excel    ${sfilePath}
    Close Current Excel Document    

Navigate Notebook Pending Tab
    [Documentation]    This keyword navigates the pending tab of a Notebook, and does a specific transaction.
    ...    @author: hstone
    [Arguments]    ${Notebook_Locator}    ${NotebookTab_Locator}    ${NotebookPendingTab_Locator}    ${Transaction}
    mx LoanIQ activate window    ${Notebook_Locator}
    Mx LoanIQ Select Window Tab    ${NotebookTab_Locator}    Pending
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${NotebookPendingTab_Locator}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}

Add All Amounts
    [Documentation]    This keyword adds all amounts supplied.
    ...    @author: hstone      19JUN2020     - Initial Create
    [Arguments]    @{sAmount_List}

    ### Keyword Pre-processing ###
    ${Amount_List}    Acquire Argument Values From List    ${sAmount_List}
    
    ${Total}    Set Variable    0
    ${Total}    Convert To Number    ${Total}

    :FOR    ${Amount}    IN    @{Amount_List}
    \    ${AmountToBeAdded}    Remove String    ${Amount}    ,
    \    ${AmountToBeAdded_Num}    Convert To Number    ${AmountToBeAdded}
    \    ${Total}    Evaluate    "%.2f" % (${Total}+${AmountToBeAdded_Num})

    ${Result}    Convert Number With Comma Separators    ${Total}

    [Return]    ${Result}

Select Customer by Short Name
    [Documentation]    This keyword selects the customer using the customer' short name. This is a generic keyword that may be used on customer selection on other notebooks.
    ...    @author: hstone    03JUL2020     - initial create
    [Arguments]    ${sLIQCustomer_ShortName}
    
    ### Keyword Pre-processing ###
    ${LIQCustomer_ShortName}    Acquire Argument Value    ${sLIQCustomer_ShortName}

    Mx LoanIQ Activate    ${LIQ_CustomerSelect_Window}
    Mx LoanIQ Enter    ${LIQ_CustomerSelect_Search_Inputfield}     ${LIQCustomer_ShortName}
    Take Screenshot    ${Screenshot_Path}/Screenshots/LoanIQ/CustomerSelectWindow
    Mx LoanIQ Click    ${LIQ_CustomerSelect_OK_Button}

Select Existing Deal
     [Documentation]    This keyword selects the existing deal on LIQ. This is a generic keyword that may be used on deal selection on other notebooks.
    ...    @author: hstone    03JUL2020     - initial create
    [Arguments]    ${sDeal_Name}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
       
    mx LoanIQ activate    ${LIQ_DealSelect_Window}   
    mx LoanIQ enter    ${LIQ_DealSelect_DealIdentifyBy_Textfield}    ${Deal_Name}
    mx LoanIQ click    ${LIQ_DealSelect_Search_Button} 
    mx LoanIQ click    ${LIQ_DealListByName_OK_Button}

Convert List to a Token Separated String
     [Documentation]    This keyword accepts a list then returns a pipe separated list by default.
    ...    @author: hstone    06JUL2020     - initial create
    [Arguments]    ${sList}    ${sToken}=|

    ${List_Length}    Get Length    ${sList}
    ${String_Result}    Set Variable

    FOR    ${List_Index}    IN RANGE    ${List_Length}
    \    ${String_Result}    Run Keyword If    ${List_Index}==0    Catenate    ${String_Result}    @{sList}[${List_Index}]
         ...    ELSE     Catenate    SEPARATOR=${sToken}  ${String_Result}    @{sList}[${List_Index}]

    [Return]    ${String_Result}

Compare Two Strings
    [Documentation]    This keyword compares two strings.
    ...    ${sValidationComment}: Pertains to what is being validated  e.g. Facilty Notebook Effective Date Text Validation
    ...    @author: hstone    28MAY2020      - Initial Create
    ...    @update: clanding    10SEP2020    - added convert to string
    [Arguments]    ${sString1}    ${sString2}    ${sValidationComment}=None

    ${String1}    Convert To String    ${sString1}
    ${String2}    Convert To String    ${sString2}
    ${String1}    Strip String    ${String1}
    ${String2}    Strip String    ${String2}
    ${Result}    Run Keyword And Return Status    Should Be Equal As Strings    ${String1}    ${String2}

    Run Keyword If    '${Result}'=='True' and '${sValidationComment}'=='None'    Log    String Comparison Validation Passed.
    ...    ELSE IF    '${Result}'=='True' and '${sValidationComment}'!='None'    Log    ${sValidationComment} : String Comparison Validation Passed.
    ...    ELSE IF    '${Result}'=='False' and '${sValidationComment}'=='None'    Run Keyword And Continue On Failure    Fail    String Comparison Validation Failed. '${String1}' is not equal to '${String2}'.
    ...    ELSE IF    '${Result}'=='False' and '${sValidationComment}'!='None'    Run Keyword And Continue On Failure    Fail    ${sValidationComment} : String Comparison Validation Failed. '${String1}' is not equal to '${String2}'.
    ...    ELSE    Fail    INVALID INPUT, PLEASE CHECK KEYWORD: 'Compare Two Strings'.

Enter Text on Java Tree Text Field
    [Documentation]    This keyword enters a text on the Java Tree text field.
    ...    @author: hstone    16JUL2020      - Initial Create
    [Arguments]    ${sJavaTree_Locator}    ${sItem_Number}    ${sColumn_Name}    ${sText_Value}

    ${sItem_Number}     Evaluate    ${sItem_Number}-1
    Mx LoanIQ Select JavaTreeCell To Enter With RowNumber    ${sJavaTree_Locator}    ${sItem_Number}%${sText_Value}%${sColumn_Name}

    :FOR     ${BACKSPACE_PRESS_INDEX}     IN RANGE     20
    \     Mx Press Combination    Key.BACKSPACE

    ${Text_Value_List}    Convert To List    ${sText_Value}
    ${Text_Value_Length}    Get Length    ${Text_Value_List}

    :FOR     ${KEY_PRESS_INDEX}     IN RANGE     ${Text_Value_Length}
    \     Mx Press Combination    Key.@{Text_Value_List}[${KEY_PRESS_INDEX}]

    Mx LoanIQ Click    ${sJavaTree_Locator}

Mx Execute Template With Multiple Test Case Name
    [Documentation]    This keyword will execute the template using the rowname instead of rowid and multiple row names are allowed.
    ...    @author: clanding    27AUG2020    - initial create
    ...    @update: clanding    07OCT2020    - changed FOR loop to use index; set global the index in the FOR loop
    [Arguments]    ${stemplateName}    ${sDataSet}    ${sDataColumnName}    ${sDataRowNames}    ${sDataSheetName}    ${sDelimiter}=None

    ${DataRowNames_List}    Run Keyword If    '${sDelimiter}'=='None'    Split String    ${sDataRowNames}    |
    ...    ELSE    Split String    ${sDataRowNames}    ${sDelimiter}
    
    ${DataRowNames_Count}    Get Length    ${DataRowNames_List}
    :FOR    ${Index}    IN RANGE    ${DataRowNames_Count}
    \    ${DataRowNames}    Get From List    ${DataRowNames_List}    ${Index}
    \    Open Excel    ${sDataSet}
    \    Log    Data Set Open: '${sDataSet}'
    \
    \    ${DataColumn_List}    Read Excel Row    1    sheet_name=${sDataSheetName}
    \    Log    Data Set Sheet Name: '${sDataSheetName}'
    \    Log    Data Set Sheet Column Names: '${DataColumn_List}'
    \
    \    ${DataColumnName_Index}    Get Index From List    ${DataColumn_List}    ${sDataColumnName}
    \    Log    Column Name Index : '${DataColumnName_Index}'
    \    Run Keyword If    ${DataColumnName_Index}<0    Fail    '${sDataColumnName}' is not found at '${DataColumn_List}' Data Sheet Column Names.
    \    ${DataColumnName_Index}    Evaluate    ${DataColumnName_Index}+1
    \
    \    ${DataRow_List}    Read Excel Column    ${DataColumnName_Index}    sheet_name=${sDataSheetName}
    \    Log    Row Names for '${sDataColumnName}': '${DataRow_List}'
    \
    \    ${DataRowValue_Index}    Get Index From List    ${DataRow_List}    ${DataRowNames}
    \    Log    Row Name Index : '${DataRowValue_Index}'
    \    Run Keyword If    ${DataColumnName_Index}<0    Fail    '${DataRowNames}' is not found at '${DataRow_List}' Data Row Values.
    \    
    \    ${rowid_Column_Index}    Get Index From List    ${DataColumn_List}    rowid
    \    Put String To Cell    ${sDataSheetName}    ${rowid_Column_Index}    ${DataRowValue_Index}   ${DataRowValue_Index}
    \    Close Current Excel Document
    \    Set Global Variable    ${DATAROW_INDEX}    ${Index}
    \    Set Global Variable    ${TestCase_Name}    ${DataRowNames}
    \    Mx Execute Template With Multiple Data    ${stemplateName}    ${sDataSet}    ${DataRowValue_Index}    ${sDataSheetName}

Mx Select Element and Input Text Without Key Press
    [Documentation]    This keyword is used to navigate to the web element and input desired text.
    ...    @author: hstone    16MAR2020    Initial Create
    [Arguments]    ${locator}    ${text}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Page Contains Element    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Visible    ${locator}
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Enabled    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Click Element    ${locator}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Clear Element Text    ${locator}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Mx Activate And Input Text    ${locator}    ${text}
    Wait Until Browser Ready State

Mx Get Element Value
    [Documentation]    This keyword is used to navigate to the web element and input desired text.
    ...    @author: hstone    16MAR2020    Initial Create
    [Arguments]    ${locator}
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Page Contains Element    ${locator}    1s
    Wait Until Keyword Succeeds    ${retry}    ${retry_interval}    Wait Until Element Is Visible    ${locator}
    Wait Until Browser Ready State
    ${value}    Get Value    ${locator}
    Wait Until Browser Ready State

    [Return]    ${value}

Get LIQ System Date
    [Documentation]    This keyword is used to get the LIQ System Date with the option to input desired date format
    ...    @author: hstone    16MAR2020    Initial Create
    [Arguments]    ${date_format}=%d-%b-%Y

    ### Get LIQ System Date
    ${temp}    Mx LoanIQ Get Data    ${LIQ_Window}    title%temp
    ${SystemDate}    Fetch From Right    ${temp}    :${SPACE}    
    log    System Date: ${SystemDate}

    ### LIQ Date Conversion Routine
    ${IsLIQDateFormat}    Run Keyword And Return Status    Should Be Equal As Strings    %d-%b-%Y    ${date_format}
    ${LIQ_System_Date}    Run Keyword If    ${IsLIQDateFormat}==${True}    Set Variable    ${SystemDate}
    ...    ELSE    Convert Date    ${SystemDate}    result_format=${date_format}    date_format=%d-%b-%Y

    [RETURN]    ${LIQ_System_Date}

Tick/Untick and Validate If Checkbox Value Is Updated
    [Documentation]    This keyword is used to tick or untick checkbox and check if the new field value matches the old value.
    ...    @author: dahijara    18MAY2020    - initial create. 
    [Arguments]    ${sFieldName}    ${sNewValue}    ${sLocator}

    ${sUIValue}    SeleniumLibraryExtended.Get Element Attribute    ${sLocator}    aria-checked
    Run Keyword If    '${${sUIValue}}'!='${${sNewValue}}'    Click Element    ${sLocator}

    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${${sUIValue}}    ${${sNewValue}}
    Run Keyword If    ${isMatched}!=${True}    Log    "${sFieldName}" is UPDATED! Prev Value: ${sUIValue} | New Value: ${sUIValue}
    ...    ELSE    Log    "${sFieldName}" is NOT UPDATED! Prev Value: ${sUIValue} | New Value: ${sUIValue}    level=WARN

Populate and Validate If Field Value Is Updated
    [Documentation]    This keyword is used to populate and check if the new field value matches the old value.
    ...    @author: dahijara    18MAY2020    - initial create. 
    [Arguments]    ${sFieldName}    ${sNewValue}    ${sLocator}

    ${sUIValue}    Get Value    ${sLocator}
    Mx Input Text    ${sLocator}    ${sNewValue}
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sUIValue}    ${sNewValue}
    Run Keyword If    ${isMatched}!=${True}    Log    "${sFieldName}" is UPDATED! Prev Value: ${sUIValue} | New Value: ${sUIValue}
    ...    ELSE    Log    "${sFieldName}" is NOT UPDATED! Prev Value: ${sUIValue} | New Value: ${sUIValue}    level=WARN

Split the Value with Decimal and Return the Whole Number
    [Documentation]    This Keyword is used to split the Value having decimal number (Sample: 1000.07 to 1000 and 07) and return the whole number
    ...    @author: fluberio    30OCT2020    - initial create.
    [Arguments]    ${sValue}
    
    ${sValue}    Convert To String    ${sValue}
    ${Container_List}    Split String    ${sValue}    .
    ${sWholeNum_Value}    Set Variable    @{Container_List}[0]
    ${sDecimal_Value}    Set Variable    @{Container_List}[1]

    [RETURN]    ${sWholeNum_Value}
    
Get the Row Id for Given Pricing Option
    [Documentation]    This keyword is used to set the row id of the correspoding Pricing Option
    ...    @update: fluberio    29OCT2020    - initial create
    [Arguments]    ${sPricing_Option}
    
    ${rowId}    Run Keyword If    '${sPricing_Option}' == 'Euro LIBOR Option'    Set Variable    1
    ...    ELSE IF    '${sPricing_Option}' == 'NIBOR Option'    Set Variable    2
    ...    ELSE IF    '${sPricing_Option}' == 'USD LIBOR Option'    Set Variable    3
    ...    ELSE IF    '${sPricing_Option}' == 'GBP LIBOR Option'    Set Variable    4
    
    [Return]    ${rowId}
 
Return Given Number with Specific Decimal Places without Rounding
    [Documentation]    This keyword return the given number with the given number of Decimal Places without roundinf off the number
    ...    @author: fluberio    12MAY2020    - initial create
    ...    @update: clanding    11DEC2020    - added handling when sNumberToBeConverted does not have any decimal
    [Arguments]     ${sNumberToBeConverted}    ${sNumberOfDecimalPlaces}
    ${sContainer}    Convert To String    ${sNumberToBeConverted}
    ${sContainer}    Remove String    ${sContainer}    ,
    ${Container_List}    Split String    ${sContainer}    .
    ${sWholeNum_Value}    Set Variable    @{Container_List}[0]
    ${With_Decimal}    Run Keyword And Return Status    Set Variable    @{Container_List}[1]
    ${sDecimal_Value}    Run Keyword If    ${With_Decimal}==${True}    Set Variable    @{Container_List}[1]
    ...    ELSE    Set Variable    0
    
    ${sDecimal_Value}    Get Substring    ${sDecimal_Value}    0    ${sNumberOfDecimalPlaces}
    ${result}    Evaluate    ${sWholeNum_Value}.${sDecimal_Value}

    [Return]    ${result}
    
Get Column Header Index Using Dynamic Header
    [Documentation]    This keyword is used to get the Column Header Index of Test_Case and given Column Name at the Excel Sheet using dynamic header or row. Default is 1.
    ...    @author: shirhong    17NOV2020    Initial Create
    [Arguments]    ${sSheetName}    ${sColumnName}    ${bTestCaseColumn}=False    ${sTestCaseColReference}=Test_Case    ${iHeaderIndex}=1

    Log    (Get Column Header Index) sTestCaseColReference = '${sTestCaseColReference}'

    ${DataColumn_List}    Read Excel Row    ${iHeaderIndex}    sheet_name=${sSheetName}
    Log    Data Set Sheet Name: '${sSheetName}'
    Log    Data Set Sheet Column Names: '${DataColumn_List}'

    ### Get Test Case Header Count/Index ###
    ${TestCaseHeaderName_Index}    Get Index From List    ${DataColumn_List}    ${sTestCaseColReference}
    Log    Fetched Test Case Column Index : '${TestCaseHeaderName_Index}'

    ### Set Default Test Case Column Header Index
    ${TestCaseHeaderName_Index}    Run Keyword If    ${TestCaseHeaderName_Index}<0 or '${bTestCaseColumn}'=='False'   Set Variable    2
    ### Set Test Case Column Header Index Based on Actual Index on Excel Data Column Name List
    ...    ELSE    Evaluate    ${TestCaseHeaderName_Index}+1
    Log    Evaluated Test Case Column Index : '${TestCaseHeaderName_Index}'

    ### Get Target Column Value Index ###
    ${ColumnName_Index}    Get Index From List    ${DataColumn_List}    ${sColumnName}
    Log    Column Name Index : '${ColumnName_Index}'

    ### Verify if Target Column Value can be found on the data column list acquired
    Run Keyword If    ${ColumnName_Index}<0    Fail    '${sColumnName}' is not found at '${DataColumn_List}' Data Column Values.
    ${ColumnName_Index}    Evaluate    ${ColumnName_Index}+1

    [Return]    ${TestCaseHeaderName_Index}    ${ColumnName_Index}

Generate Deal Name and Alias with 5 Numeric Test Data
    [Documentation]    This keyword generates deal name and alias.
    ...    @author:    mcastro    27NOV2020    - Initial Create
    [Arguments]   ${Deal_NamePrefix}    ${Deal_AliasPrefix}
    ${Deal_Name}    Auto Generate Only 5 Numeric Test Data    ${Deal_NamePrefix}
    log    Deal Name: ${Deal_Name}
    ${Deal_Alias}    Auto Generate Only 5 Numeric Test Data    ${Deal_AliasPrefix}
    log    Deal Alias: ${Deal_Alias}
    [Return]    ${Deal_Name}    ${Deal_Alias}

Generate Facility Name with 5 Numeric Test Data
    [Documentation]    This keyword generates facility name with 5 numeric text.
    ...    @author: mcastro    02DEC2020    - Initial Create
    [Arguments]   ${Facility_NamePrefix}
    
    ${Facility_Name}    Auto Generate Only 5 Numeric Test Data     ${Facility_NamePrefix}
    [Return]    ${Facility_Name}

Generate Facility Name with 4 Numeric Test Data
    [Documentation]    This keyword generates facility name with 5 numeric text.
    ...    @author: songhan    25JAN2021    - Initial Create
    [Arguments]   ${Facility_NamePrefix}
    
    ${Facility_Name}    Auto Generate Only 4 Numeric Test Data     ${Facility_NamePrefix}
    [Return]    ${Facility_Name}
    
Check if File Exist
    [Documentation]    This keyword is used to check if the file exists in the specified path with multiple retries.
    ...    @author: clanding    27NOV2020    - initial Create
    [Arguments]    ${sPath}    ${sFile_Name}    ${sFile_Type}=xlsx    ${iRange}=300
    
    :FOR    ${Index}    IN RANGE    ${iRange}
    \    ${IsFileExist}    Run Keyword And Return Status    OperatingSystem.File Should Exist    ${sPath}\\${sFile_Name}.${sFile_Type}
    \    Exit For Loop If    ${IsFileExist}==${True}
    Run Keyword If    ${IsFileExist}==${True}    Log    '${sPath}\\${sFile_Name}.${sFile_Type}' is found.
    ...    ELSE    Run Keyword And Continue on Failure    Fail    '${sFile_Name}' is not found at '${sPath}'.

Generate Deal Name and Alias with Numeric Test Data
    [Documentation]    This keyword generates deal name and alias by appending numeric characters.
    ...    Add additional condition if  there is a need for another specific number of numeric characters.
    ...    @author:    dahijara    03DEC2020    - Initial Create
    [Arguments]   ${sDeal_NamePrefix}    ${sDeal_AliasPrefix}    ${sNumofSuffix}
    ${Deal_Name}    Run Keyword If    '${sNumofSuffix}'=='4'    Auto Generate Only 4 Numeric Test Data    ${sDeal_NamePrefix}
    ...    ELSE IF    '${sNumofSuffix}'=='5'    Auto Generate Only 5 Numeric Test Data    ${sDeal_NamePrefix}
    Log    Deal Name: ${Deal_Name}

    ${Deal_Alias}    Run Keyword If    '${sNumofSuffix}'=='4'    Auto Generate Only 4 Numeric Test Data    ${sDeal_AliasPrefix}
    ...    ELSE IF    '${sNumofSuffix}'=='5'    Auto Generate Only 5 Numeric Test Data    ${sDeal_AliasPrefix}
    Log    Deal Alias: ${Deal_Alias}
    [Return]    ${Deal_Name}    ${Deal_Alias}

Get Correct Dataset From Dataset List
    [Documentation]    This keyword gets the correct dataset file for new UAT deals
    ...    @author:    nbautist    09DEC2020    - Initial Create
    [Arguments]    ${lValues}
    
    Set Global Variable    ${ExcelPath}    ${dataset_path}&{lValues}[Path]&{lValues}[Filename]

Subtract 2 Numbers
    [Documentation]    This keyword is used to get the difference of iNumber2 from iNumber1.
    ...    @author: clanding    14DEC2020    - initial create
    [Arguments]    ${iNumber1}    ${iNumber2}    ${iDecimal_Place}=2    

    ${Number1}    Remove Comma and Convert to Number    ${iNumber1}
    ${Number2}    Remove Comma and Convert to Number    ${iNumber2}

    ${DifferenceAmount}    Evaluate    "%.${iDecimal_Place}f" % (${Number2}-${Number1})    
    
    [Return]    ${DifferenceAmount}

Remove Comma Separators in Numbers
    [Documentation]    This keyword is used to remove , in the number. 
    ...    @author: clanding    10DEC2020    - initial create
    [Arguments]    ${sNumber}    ${bInclude_Decimal}=${True}    ${sRunTimeVar_Result}=None

    ### Keyword Pre-processing ###
    ${Number}    Acquire Argument Value    ${sNumber}

    ${String}    Convert To String    ${Number}
    ${Number}    Remove String    ${String}    ,

    ${Container_List}    Split String    ${Number}    .
    ${WholeNum_Value}    Set Variable    @{Container_List}[0]
    ${Decimal_Value}    Set Variable    @{Container_List}[1]
    
    ${Include_Decimal}    Run Keyword If    '${Decimal_Value}'=='00'    Set Variable    ${False}
    ...    ELSE    Set Variable    ${bInclude_Decimal}

    ${Number}    Run Keyword If    ${Include_Decimal}==${True}    Set Variable    ${WholeNum_Value}.${Decimal_Value}
    ...    ELSE    Set Variable    ${WholeNum_Value}

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Result}    ${Number}
    [Return]    ${Number}

Close Generate Notice Window
    [Documentation]    This keyword closes the notice group window
    ...    @author: mcastro    14DEC2020    - Initial Create
    ...    @update: kmagday    16Dec2020    - Added space in documentation to fix the error.

    Mx LoanIQ Close Window    ${LIQ_NoticeGroup_Window}

Split String and Return as a List
    [Documentation]    This keyword accepts a string and delimeter and returns an Array
    ...    @author: kmagday    19JAN2021    - Initial create
    [Arguments]    ${sData}    ${sDelimiter}

    ###Pre-processing Keyword##
    ${Data}    Acquire Argument Value    ${sData}
    ${Delimeter}    Acquire Argument Value    ${sDelimiter}

    @{SplittedString}    Split String    ${Data}    ${Delimeter}
    [Return]    @{SplittedString}