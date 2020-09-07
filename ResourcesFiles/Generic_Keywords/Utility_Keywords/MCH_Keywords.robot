*** Settings ***
Resource    ../../../Configurations/Integration_Import_File.robot


*** Keywords ***

Login to MCH UI
    [Documentation]    This keyword is used to open browser and then login to MCH UI - FFC.
    ...    @author: clanding    21FEB2019    - initial create
    
    Open Browser    ${SERVER}:${PORT}${MDM_FFC_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible     ${FFC_Username_Locator}
    Mx Input Text    ${FFC_Username_Locator}    ${MDM_FFC_Username}
    Mx Input Text    ${FFC_Password_Locator}    ${MDM_FFC_Password}
    Click Element    ${Signin}
    Wait Until Element Is Visible     ${FFC_Dashboard}

Logout to MCH UI and Close Browser
    [Documentation]    This keyword is used to logout from MCH UI and then close browser.
    ...    @author: clanding    21FEB2019    - initial create
    ...    @update: ehugo    17JUN2020    - added 'Wait Until Loading Indicator Is Not Visible' before clicking the Admin button
    
    Wait Until Loading Indicator Is Not Visible
    Click Element    ${Admin}
    Click Element   ${Logout}
    Close All Browsers

Go to Dashboard and Click Source API Name
    [Documentation]    This keyword is used to click Dashboard and click Source for OpenAPI using API Name.
    ...    @author: clanding    21FEB2019    - initial create
    ...    @update: mnanquil    28FEB2019    - updated to handle multile source in FFC
    ...    @update: clanding    24APR2019    - add multiple check for OpenAPI_Source_Child_Row_Instance
    ...    @update: clanding    31MAY2019    - add Mx Scroll Element Into View
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: jdelacru    26JUL2019    - removed navigation for loops for splitter to cater when Output Type is given as argument
    ...                                      - Instance Name and Output Type cannot be given at the same time
    ...    @update: ehugo    16JUN2020    - added 'Wait Until Element Is Enabled' to wait for the Source before scrolling into it
    ...                                   - added 'Wait Until Element Is Not Visible' for the Loading_Indicator to properly get the text of Source
    [Arguments]    ${sSourceName}    ${sInstance}=None    ${sOutputType}=None

    Click Element    ${FFC_Dashboard}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    ${Summary_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Summary_Row}
    ${Summary_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Summary_Column}
    
    :FOR    ${SourceIndex}    IN RANGE    1    ${Summary_Column_Count}+1
    \    ${HeaderText}    Get Text    ${Summary_Header}\[${SourceIndex}]${Summary_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${SOURCE}'    

    :FOR    ${OpenAPIIndex}    IN RANGE    1    ${Summary_Row_Count}+1
    \    Wait Until Element Is Enabled    ${Summary_Row}\[${OpenAPIIndex}]${PerColumnValue}\[${SourceIndex}]${TextValue}    3s
    \    Mx Scroll Element Into View    ${Summary_Row}\[${OpenAPIIndex}]${PerColumnValue}\[${SourceIndex}]${TextValue}
    \    Wait Until Element Is Visible    ${Summary_Row}\[${OpenAPIIndex}]${PerColumnValue}\[${SourceIndex}]${TextValue}    3s
    \    Wait Until Element Is Not Visible    ${Loading_Indicator}
    \    ${SourceText}    Get Text    ${Summary_Row}\[${OpenAPIIndex}]${PerColumnValue}\[${SourceIndex}]${TextValue}
    \    Exit For Loop If    '${SourceText}'=='${sSourceName}'

    Run Keyword If    '${sInstance}'!='None'    Navigate Splitter through Instance Name    ${sSourceName}    ${sInstance}
    ...    ELSE IF    '${sOutputType}'!='None'    Navigate Splitter through Output Type    ${sSourceName}    ${sOutputType}
    
Filter by Reference Header and Save Message TextArea and Return Results Row List Value
    [Documentation]    This keyword is used to search Header Reference and filter using Expected Reference Value.
    ...    Then gets the row values using array of Header Names. Then gets the Message Text after clicking results row.
    ...    @author: clanding    21FEB2019    - initial create
    ...    @update: clanding    19MAR2019    - moved Double Click Element to Get Message TextArea Value and Save to File, added retry for Wait Until Element Is Visible    ${Results_Row}
    ...    @update: clanding    26APR2019    - added screenshot
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: jloretiz    03SEP2019    - added additional arguments for http method.
    ...    @update: amansuet    05SEP2019    - added condition for GET to have Results Row value as 1 only.
    ...    @update: jloretiz    08SEP2019    - removed HTTP method argument as its causing error.
    ...    @update: ehugo    16JUN2020    - added wait for Loading_Indicator to properly load the results pane
    ...    @update: ehugo    18JUN2020    - updated screenshot location
    [Arguments]    ${sHeaderRefName}    ${sExpectedRefValue}    ${sOutputFilePath}    ${sFileExtension}    @{aHeaderNames}    
    
    ${HTTPMETHODOPERATION}    Set Variable 
    
    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    
    :FOR    ${ResultsHeaderColIndex}    IN RANGE    1    ${Results_Column_Count}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${ElementVisible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${HeaderText}    Get Text    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${sHeaderRefName}'
    Log    ${ResultsHeaderColIndex}
    
    ${ResultsHeaderColIndex_After}    Evaluate    ${ResultsHeaderColIndex}+1
    ${ResultsHeaderColIndex}    Evaluate    ${ResultsHeaderColIndex}-1
    ${ResultsHeaderColIndex_After_Exist}    Run Keyword And Return Status    Page Should Contain Element    ${ResultsHeaderColIndex_After}    
    Run Keyword If    ${ResultsHeaderColIndex_After_Exist}==${True}    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex_After}]
    ...    ELSE    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]
    Mx Input Text    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]    ${sExpectedRefValue}
    
    ###Wait to properly load the results pane###
    Wait Until Loading Indicator Is Not Visible

    :FOR    ${Index}    IN RANGE    10
    \    ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Row}
    \    Exit For Loop If    ${Status}==${True}        
    
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/OpenAPI_Queues
    ${Multiple_List}    Create List    
    ${Results_Row_Count_With_Ref}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}

    Set Global Variable    ${RESULTS_ROW_WITHREF}    ${Results_Row_Count_With_Ref}
    :FOR    ${ResultsRowIndex_Ref}    IN RANGE    1    ${Results_Row_Count_With_Ref}+1
    \    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    ${ResultsRowIndex_Ref}    @{aHeaderNames}
    \    Append To List    ${Multiple_List}    ${ResultsRowList}    
    \    Get Message TextArea Value and Save to File    ${sOutputFilePath}    ${ResultsRowIndex_Ref}    ${ResultsHeaderColIndex}    ${sFileExtension}
    \    Run Keyword If    '${HTTPMETHODOPERATION}'=='GET'    Exit For Loop
    [Return]    ${Multiple_List}

Get Results Table Column Value by Header List and Return
    [Documentation]    This keyword is used to get results table column value by the given column header list or array and return.
    ...    @author: clanding    21FEB2019    - initial create
    ...    @update: jloretiz    10SEP2019    - added if condition for Operation.
    ...    @update: hstone    20SEP2019    - added else setting for ${HTTPMETHODOPERATION} (suggested by jobern)  
    [Arguments]    ${iResultsRowIndex}    @{aHeaderNames}
    
    ${HTTPMETHODOPERATION}    Set Variable    
    ${ResultsRowList}    Create List    
    ${HeaderNames_Count}    Get Length    ${aHeaderNames}
    :FOR    ${ArrayIndex}    IN RANGE    0    ${HeaderNames_Count}
    \    ${HeaderName}    Set Variable    @{aHeaderNames}[${ArrayIndex}]
    \    ${ResultsRowValue}    Get Results Table Column Value by Header Title and Return    ${iResultsRowIndex}    ${HeaderName}   
    \    Set Suite Variable    ${${HeaderName}}    ${ResultsRowValue}
    \    Run Keyword If    '${HeaderName}' == 'OPERATION'    Set Suite Variable    ${HTTPMETHODOPERATION}    ${ResultsRowValue}
         ...    ELSE    Set Suite Variable    ${HTTPMETHODOPERATION}
    \    Run Keyword If    '${HeaderName}' != 'ID'    Append To List    ${ResultsRowList}    ${ResultsRowValue}   
    \    Exit For Loop If    ${ArrayIndex}==${HeaderNames_Count}-1
    [Return]    ${ResultsRowList} 

Get Results Table Column Value by Header Title and Return
    [Documentation]    This keyword is used to get results table column value by the given column header name and return.
    ...    @author: clanding    21FEB2019    - initial create
    ...    @update: clanding    19MAR2019    - added multiple retry for reset of Filter view
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: ehugo    18JUN2020    - updated screenshot location
    [Arguments]    ${iResultsRowIndex}    ${sResultsHeaderTitle}
    
    :FOR    ${Index}    IN RANGE    10
    \    Mx Scroll Element Into View    ${Results_Header}\[1]${Results_Header_Text}
    \    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Header}\[1]${Results_Header_Text}
    \    Exit For Loop If    ${status}==${True}    
    
    ${Total_Count_Results_Header}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    :FOR    ${INDEX_Results_Col}    IN RANGE    1    ${Total_Count_Results_Header}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${INDEX_Results_Col}]${Results_Header_Text}
    \    ${ElementVisisble}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Header}\[${INDEX_Results_Col}]${Results_Header_Text}
    \    Run Keyword If    ${ElementVisisble}==${False}    Run Keywords    Mx Scroll Element Into View    ${Results_Header}\[${INDEX_Results_Col}]${Results_Header_Text}
         ...    AND    Wait Until Element Is Visible    ${Results_Header}\[${INDEX_Results_Col}]${Results_Header_Text}     
    \    ${Results_Header_Val}    Get Text    ${Results_Header}\[${INDEX_Results_Col}]${Results_Header_Text}
    \    Exit For Loop If    '${Results_Header_Val}'=='${sResultsHeaderTitle}'
    ${Column_Value}    Get Text    ${Results_Row}\[${iResultsRowIndex}]${PerColumnValue}\[${INDEX_Results_Col}]${TextValue}
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/ResultsRow_${iResultsRowIndex}${INDEX_Results_Col}
    [Return]    ${Column_Value}

Validate Results Row Values Using Expected Value List
    [Documentation]    This keyword is used to validate actual value from Results table and expected value list.
    ...    @author: clanding    22FEB2019    - initial create
    [Arguments]    ${aActualList}    @{aExpectedList}
    
    ${ActualList_Count}    Get Length    ${aActualList}
    :FOR    ${ActualValList}    IN    @{aActualList}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${aExpectedList}    ${ActualValList}    
    \    ${Stat}    Run Keyword And Return Status    Should Be Equal    ${aExpectedList}    ${ActualValList}
    \    Run Keyword If    ${Stat}==${True}    Log    Expected and Actual matched! ${aExpectedList} = ${ActualValList}
         ...    ELSE    Log    Expected and Actual did not matched! ${aExpectedList} != ${ActualValList}    level=ERROR
    
Get Message TextArea Value and Save to File
    [Documentation]    This keyword is used to get Message Textarea value and save to Output File. sOutputFilePath includes file path and file name.
    ...    @author: clanding    22FEB2019    - initial create
    ...    @update: clanding    19MAR2019    - added multiple retry for Double Click Element
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: ehugo    16JUN2020    - added 'Wait Until Loading Indicator Is Not Visible' to properly get the value of textarea
    ...    @update: ehugo    18JUN2020    - updated screenshot location
    [Arguments]    ${sOutputFilePath}    ${iRowRef}    ${iColRef}    ${sFileExtension}
    
    :FOR    ${Index}    IN RANGE    5
    \    Double Click Element    ${Results_Row}\[${iRowRef}]${PerColumnValue}\[${iColRef}]${TextValue}
    \    Wait Until Loading Indicator Is Not Visible
    \    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Textarea}
    \    ${messageHeader}    Get Text    ${Message_Selected_Header}
    \    Exit For Loop If    ${status}==${True} and 'SELECTED:' in '${messageHeader}'
    
    Mx Scroll Element Into View    ${Textarea}
    ${FFC_RESPONSE}    Get Value   ${Textarea}
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/MessageTextArea_${iRowRef}
    Set Global Variable    ${FFC_RESPONSE}
    ${fileName}    Set Variable    ${dataset_path}${sOutputFilePath}_${iRowRef}.${sFileExtension}
    Delete File If Exist    ${dataset_path}${sOutputFilePath}_${iRowRef}.${sFileExtension}
    Create File    ${fileName}    ${FFC_Response}
    [Return]    ${fileName}    

Compare Input and Output JSON Files
    [Documentation]    This keyword is used to compare input and output json files and log errors if not equal.
    ...    @author: clanding    26FEB2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sFileName}
    
    ${InputJSON}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sFileName}.json    
    Run Keyword And Continue On Failure    Mx Compare Json Data    ${InputJSON}     ${FFC_RESPONSE}
    ${Stat}    Run Keyword And Return Status    Mx Compare Json Data    ${InputJSON}     ${FFC_RESPONSE}
    Run Keyword If    ${Stat}==${True}    Log    Input and Output JSON Files are matched. ${InputJSON} == ${FFC_RESPONSE}
    ...    ELSE    Log    Input and Output JSON Files does not matched. ${InputJSON} != ${FFC_RESPONSE}    level=ERROR

Compare Input and Output File for Delete and Get Users
    [Documentation]    This keyword is used to compare string for input and output files for Delete User.
    ...    @author: amansuet    16AUG2019    - initial create
    ...    @update: amansuet    04SEP2019    - updated keyword as this is used also in Get User API.
    [Arguments]    ${sInputFilePath}    ${sFileName}
    
    ${InputFile}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sFileName}.txt
    Run Keyword And Continue On Failure    Should Be Equal    ${InputFile}     ${FFC_RESPONSE}
    ${Stat}    Run Keyword And Return Status    Should Be Equal    ${InputFile}     ${FFC_RESPONSE}
    Run Keyword If    ${Stat}==${True}    Log    Input and Output Files are matched. ${InputFile} == ${FFC_RESPONSE}
    ...    ELSE    Log    Input and Output Files does not matched. ${InputFile} != ${FFC_RESPONSE}    level=ERROR

Get TextJMS XML Files and Rename with Base Rate Code, Repricing Frequency and Active Funding Desk and Compare to Input
    [Documentation]    This keyword is used to get sOutputFilePath (TextJMS) files and rename them to have the file name with Base Rate Code, 
    ...    Repricing Frequency and Funding Desk. Then delete TextJMS files with appended numbers.
    ...    @author: clanding    22FEB2019    - initial create
    ...    @update: clanding    18MAR2019    - removed For loop. inserted keyword to Compare Expected and Actual TextJMS for Base Rate TL
    ...                                      - added name to Active Funding Desk
    ...    @update: ehugo    18JUN2020    - added 'sXML_Filename' argument to properly delete the XML file if exist
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}    ${sXML_file}    ${sXML_Filename}
    
    ${BaseRate}    XML.Get Element Attribute    ${sXML_file}    baseRate    xpath=UpdateFundingRate
    ${FundingDesk}    XML.Get Element Attribute    ${sXML_file}    fundingDesk    xpath=UpdateFundingRate
    ${RepricingFrequency}    XML.Get Element Attribute    ${sXML_file}    repricingFrequency    xpath=UpdateFundingRate
    
    Delete File If Exist    ${sXML_Filename}
    Create File    ${dataset_path}${sOutputFilePath}_${BaseRate}_${RepricingFrequency}_${FundingDesk}.xml    ${sXML_file}    
    
    Run Keyword And Continue On Failure    Mx Compare Xml With Baseline File    ${dataset_path}${sInputFilePath}_${BaseRate}_${RepricingFrequency}_${FundingDesk}.xml    
    ...    ${dataset_path}${sOutputFilePath}_${BaseRate}_${RepricingFrequency}_${FundingDesk}.xml    
    ${Stat}    Run Keyword And Return Status    Mx Compare Xml With Baseline File    ${dataset_path}${sInputFilePath}_${BaseRate}_${RepricingFrequency}_${FundingDesk}.xml    
    ...    ${dataset_path}${sOutputFilePath}_${BaseRate}_${RepricingFrequency}_${FundingDesk}.xml
    Run Keyword If    ${Stat}==${True}    Log    ${dataset_path}${sInputFilePath}_${BaseRate}_${RepricingFrequency}_${FundingDesk}.xml and ${dataset_path}${sOutputFilePath}_${BaseRate}_${RepricingFrequency}_${FundingDesk}.xml are matched!
    ...    ELSE    Log    ${dataset_path}${sInputFilePath}_${BaseRate}_${RepricingFrequency}_${FundingDesk}.xml and ${dataset_path}${sOutputFilePath}_${BaseRate}_${RepricingFrequency}_${FundingDesk}.xml does not matched!    level=ERROR
    

Get TextJMS XML Files and Rename with Funding Desk, From Currency, To Currency, and Compare to Input
    [Documentation]    This keyword is used to get sOutputFilePath (TextJMS) files and rename them to have the file name with Base Rate Code, 
    ...    Repricing Frequency and Funding Desk. Then delete TextJMS files with appended numbers.
    ...    @author: mnanquil    07MAR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${aOutputFileName}    ${sOutputXML}
    ${length}    Get Length    ${aOutputFileName}    
    :FOR    ${INDEX}    IN RANGE    ${length}
    \    
    \    ${XML_file}    OperatingSystem.Get File    @{aOutputFileName}[${INDEX}]
    \    
    \    ${toCurrency}    XML.Get Element Attribute    ${XML_file}    currency    xpath=UpdateCrossCurrency
    \    ${FundingDesk}    XML.Get Element Attribute    ${XML_file}   fundingDesk    xpath=UpdateCrossCurrency 
    \    ${RepricingFrequency}    XML.Get Element Attribute    ${XML_file}    date    xpath=UpdateCrossCurrency    
    \    
    \    Delete File If Exist    @{aOutputFileName}[${INDEX}]
    \    Create File    ${dataset_path}${sOutputXML}_${FundingDesk}_${toCurrency}.xml    ${XML_file}    
    \    
    \    Run Keyword And Continue On Failure    Mx Compare Xml With Baseline File    ${dataset_path}${sInputFilePath}_${FundingDesk}_${toCurrency}.xml    
         ...    ${dataset_path}${sOutputXML}_${FundingDesk}_${toCurrency}.xml    
    \    ${Stat}    Run Keyword And Return Status    Mx Compare Xml With Baseline File    ${dataset_path}${sInputFilePath}_${FundingDesk}_${toCurrency}.xml    
         ...    ${dataset_path}${sOutputXML}_${FundingDesk}_${toCurrency}.xml
    \    Run Keyword If    ${Stat}==${True}    Log    ${dataset_path}${sInputFilePath}_${FundingDesk}_${toCurrency}.xml and ${dataset_path}${sOutputXML}_${FundingDesk}_${toCurrency}.xml are matched!
         ...    ELSE    Log    ${dataset_path}${sInputFilePath}_${FundingDesk}_${toCurrency}.xml and ${dataset_path}${sOutputXML}_${FundingDesk}_${toCurrency}.xml does not matched!    level=ERROR
    
    
Sequence Validation for Multiple Files
    [Documentation]    This keyword is used to validate correct sequencing of Transformation Layer Base Rate on MCH FFC UI for multiple files.
    ...    @author: clanding    05MAR2019    - initial create
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: ehugo    18JUN2020    - updated screenshot location
    [Arguments]    ${sHeaderRefName}    ${sArchiveList_GSFilename}=None
        
    ${ARCHIVE_GSFILENAME_LIST}    Run Keyword If    ${sArchiveList_GSFilename}==None    Set Variable    ${ARCHIVE_GSFILENAME_LIST}
    ...    ELSE    Set Variable    ${sArchiveList_GSFilename}
    ${GSFile_Count}    Get Length    ${ARCHIVE_GSFILENAME_LIST}
    
    ${GSFile_Last}    Evaluate    ${GSFile_Count}-1    
    ${GSFilename_Last}    Get From List    ${ARCHIVE_GSFILENAME_LIST}    ${GSFile_Last}
    
    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    
    ###GET COLUMN INDEX FOR HEADER REFERENCE###
    :FOR    ${ResultsHeaderColIndex}    IN RANGE    1    ${Results_Column_Count}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Wait Until Element Is Visible    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${HeaderText}    Get Text    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${sHeaderRefName}'
    Log    ${ResultsHeaderColIndex} 
    
    ###GET ROW INDEX FOR REFERENCE VALUE###
    :FOR    ${ResultsRowIndex}    IN RANGE    1    ${Results_Row_Count}+1
    \    Mx Scroll Element Into View    ${Results_Row}\[${ResultsRowIndex}]${PerColumnValue}\[${ResultsHeaderColIndex}]${TextValue}
    \    Wait Until Element Is Visible    ${Results_Row}\[${ResultsRowIndex}]${PerColumnValue}\[${ResultsHeaderColIndex}]${TextValue}
    \    ${ResultsRowText}    Get Text    ${Results_Row}\[${ResultsRowIndex}]${PerColumnValue}\[${ResultsHeaderColIndex}]${TextValue}
    \    Log    ${ResultsRowIndex}
    \    Exit For Loop If    '${ResultsRowText}'=='${GSFilename_Last}'
    Log    ${ResultsRowIndex}
    
    ###VALIDATE SEQUENCING, STARTING FROM THE LAST FILE###
    ${New_ResultsRowIndex}    Set Variable    0
    :FOR    ${INDEX}    IN RANGE    ${GSFile_Count}-1    -1    -1
    \    
    \    ${GSFilename}    Get From List    ${ARCHIVE_GSFILENAME_LIST}    ${INDEX}
    \    ${New_ResultsRowIndex}    Run Keyword If    ${INDEX}==${GSFile_Last}    Set Variable    ${ResultsRowIndex}
         ...    ELSE    Evaluate    ${New_ResultsRowIndex}-1
    \    
    \    Mx Scroll Element Into View    ${Results_Row}\[${New_ResultsRowIndex}]${PerColumnValue}\[${ResultsHeaderColIndex}]${TextValue}
    \    Wait Until Element Is Visible    ${Results_Row}\[${New_ResultsRowIndex}]${PerColumnValue}\[${ResultsHeaderColIndex}]${TextValue}
    \    ${New_ResultsRowText}    Get Text    ${Results_Row}\[${New_ResultsRowIndex}]${PerColumnValue}\[${ResultsHeaderColIndex}]${TextValue}
    \    
    \    Run Keyword And Continue On Failure    Should Be Equal    ${GSFilename}    ${New_ResultsRowText}    
    \    ${Status}    Run Keyword And Return Status    Should Be Equal    ${GSFilename}    ${New_ResultsRowText}
    \    Run Keyword If    ${Status}==${True}    Log    Expected value: ${GSFilename} == Actual value: ${New_ResultsRowText}
         ...    ELSE    Log    Expected value: ${GSFilename} != Actual value: ${New_ResultsRowText}
    \    
    \    Run Keyword If    ${INDEX}==0    Take Screenshot    ${screenshot_path}/Screenshots/Integration/SequenceValidation    
    \    Exit For Loop If    ${INDEX}==-1
    
    [Return]    ${GSFilename_Last}    

Filter by Reference Header and Save Header Value and Return Results Row List Value
    [Documentation]    This keyword is used to search Header Reference and filter using Expected Reference Value.
    ...    Then gets the row values using array of Header Names. Then gets the value of the given Header and save to output file.
    ...    @author: clanding    12MAR2019    - initial create
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${sHeaderRefName}    ${sExpectedRefValue}    ${sOutputFilePath}    ${sFileExtension}    ${sGetHeaderValue}    @{aHeaderNames}
    
    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    
    :FOR    ${ResultsHeaderColIndex}    IN RANGE    1    ${Results_Column_Count}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Wait Until Element Is Visible    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${HeaderText}    Get Text    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${sHeaderRefName}'
    Log    ${ResultsHeaderColIndex}
    
    ${ResultsHeaderColIndex_After}    Evaluate    ${ResultsHeaderColIndex}+1
    ${ResultsHeaderColIndex}    Evaluate    ${ResultsHeaderColIndex}-1
    ${ResultsHeaderColIndex_After_Exist}    Run Keyword And Return Status    Page Should Contain Element    ${ResultsHeaderColIndex_After}    
    Run Keyword If    ${ResultsHeaderColIndex_After_Exist}==${True}    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex_After}]
    ...    ELSE    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]
    Mx Input Text    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]    ${sExpectedRefValue}
    Wait Until Element Is Visible    ${Results_Row}    
    
    ${Multiple_List}    Create List    
    ${Results_Row_Count_With_Ref}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    Set Global Variable    ${RESULTS_ROW_WITHREF}    ${Results_Row_Count_With_Ref}
    :FOR    ${ResultsRowIndex_Ref}    IN RANGE    1    ${Results_Row_Count_With_Ref}+1
    \    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    ${ResultsRowIndex_Ref}    @{aHeaderNames}
    \    Append To List    ${Multiple_List}    ${ResultsRowList}    
    \    Double Click Element    ${Results_Row}\[${ResultsRowIndex_Ref}]${PerColumnValue}\[${ResultsHeaderColIndex}]${TextValue}
    \    Get Header Value and Save to File    ${ResultsRowIndex_Ref}    ${sGetHeaderValue}    ${sOutputFilePath}    ${sFileExtension}
    [Return]    ${Multiple_List}

Get Header Value and Save to File
    [Documentation]    This keyword is used to get the value of the given sResultsHeaderTitle and save to Output File. sOutputFilePath includes file path and file name.
    ...    @author: clanding    12MAR2019    - initial create
    ...    @update: clanding    19MAR2019    - added multiple retry for double click element
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: ehugo    18JUN2020    - updated screenshot location
    [Arguments]    ${iResultsRowIndex}    ${sResultsHeaderTitle}    ${sOutputFilePath}    ${sFileExtension}
    
    ${Total_Count_Results_Header}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    :FOR    ${INDEX_Results_Col}    IN RANGE    1    ${Total_Count_Results_Header}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${INDEX_Results_Col}]${Results_Header_Text}
    \    Wait Until Element Is Visible    ${Results_Header}\[${INDEX_Results_Col}]${Results_Header_Text}    
    \    ${Results_Header_Val}    Get Text    ${Results_Header}\[${INDEX_Results_Col}]${Results_Header_Text}
    \    Exit For Loop If    '${Results_Header_Val}'=='${sResultsHeaderTitle}'
    ${Column_Value}    Get Text    ${Results_Row}\[${iResultsRowIndex}]${PerColumnValue}\[${INDEX_Results_Col}]${TextValue}
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/ResultsRow_${iResultsRowIndex}${INDEX_Results_Col}
    
    Delete File If Exist    ${dataset_path}${sOutputFilePath}.${sFileExtension}
    Create File    ${dataset_path}${sOutputFilePath}.${sFileExtension}    ${Column_Value}

Get TextJMS XML Files and Rename with Base Rate Code, Repricing Frequency and Inactive Funding Desk and Compare to Input
    [Documentation]    This keyword is used to get sOutputFilePath (TextJMS) files and rename them to have the file name with Base Rate Code, 
    ...    Repricing Frequency and Inactive Funding Desk. Then delete TextJMS files with appended numbers.
    ...    @author: clanding    18MAR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}    ${sXML_file}
    
    ${File}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}.xml    
    Run Keyword And Continue On Failure    Should Contain    ${sXML_file}    ${File}
    ${Stat}    Run Keyword And Return Status    Should Contain    ${sXML_file}    ${File}
    Run Keyword If    ${Stat}==${True}    Log    ${sXML_file} contains '${File}'.
    ...    ELSE    Log    ${sXML_file} does not contains '${File}'.    level=ERROR
    
Compare Expected and Actual TextJMS for Base Rate TL
    [Documentation]    This keyword is used to compare the expected and actual textJMS for Base Rate Transformation Layer.
    ...    @author: clanding    18MAR2019    - initial create
    ...    @update: ehugo    18JUN2020    - added getting of 'XML_Filename' to be used in 'Get TextJMS XML Files and Rename with Base Rate Code, Repricing Frequency and Active Funding Desk and Compare to Input'
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}
    
    :FOR    ${INDEX}    IN RANGE    1    ${RESULTS_ROW_WITHREF}+1
    \    ${XML_file}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_${INDEX}.xml
    \    ${XML_Filename}    Set Variable    ${dataset_path}${sOutputFilePath}_${INDEX}.xml
    \    ${FileIsXML}    Run Keyword And Return Status    XML.Get Element Attribute    ${XML_file}    baseRate    xpath=UpdateFundingRate
    \    
    \    Run Keyword If    ${FileIsXML}==${True}    Get TextJMS XML Files and Rename with Base Rate Code, Repricing Frequency and Active Funding Desk and Compare to Input    
         ...    ${sInputFilePath}    ${sOutputFilePath}    ${XML_file}    ${XML_Filename}
         ...    ELSE    Get TextJMS XML Files and Rename with Base Rate Code, Repricing Frequency and Inactive Funding Desk and Compare to Input    
         ...    ${sInputFilePath}    ${sOutputFilePath}    ${XML_file}
    \    
    \    Exit For Loop If    ${INDEX}==${RESULTS_ROW_WITHREF}+1

Filter by Multiple Reference Headers and Values and Return Column Index
    [Documentation]    This keyword is used to search mulitple Header Reference and filter using multiple Expected Reference Value.
    ...    Then gets the row values using array of Header Names.
    ...    @author: clanding    18MAR2019    - initial create
    [Arguments]    ${aHeaderRefNameList}    ${aExpectedRefList}
    
    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    ${HeaderRefCount}    Get Length    ${aHeaderRefNameList}
    :FOR    ${Index}    IN RANGE    0    ${HeaderRefCount}
    \    
    \    ${HeaderName}    Get From List    ${aHeaderRefNameList}    ${Index}
    \    ${HeaderValue}    Get From List    ${aExpectedRefList}    ${Index}
    \    ${ResultsHeaderColIndex}    Get Results Header Index and Filter Using Value    ${HeaderName}    ${HeaderValue}
    \    
    \    Exit For Loop If    ${Index}==${HeaderRefCount}
    [Return]    ${ResultsHeaderColIndex}
    
Get Results Header Index and Filter Using Value
    [Documentation]    This keyword is used to get the index of Results Header Name and return index.
    ...    @author: clanding    18MAR2019    - initial create
    ...    @update: clanding    26APR2019    - added screenshot
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    ...    @update: ehugo    16JUN2020    - added wait for Loading_Indicator to properly load the results pane
    ...    @update: ehugo    18JUN2020    - updated screenshot location
    [Arguments]    ${sHeader}    ${sValue}
    
    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    
    :FOR    ${ResultsHeaderColIndex}    IN RANGE    1    ${Results_Column_Count}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Wait Until Element Is Visible    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${HeaderText}    Get Text    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${sHeader}'
    
    ${ResultsHeaderColIndex_After}    Evaluate    ${ResultsHeaderColIndex}+1
    ${ResultsHeaderColIndex}    Evaluate    ${ResultsHeaderColIndex}-1
    ${ResultsHeaderColIndex_After_Exist}    Run Keyword And Return Status    Page Should Contain Element    ${ResultsHeaderColIndex_After}    
    Run Keyword If    ${ResultsHeaderColIndex_After_Exist}==${True}    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex_After}]
    ...    ELSE    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]
    Mx Input Text    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]    ${sValue}
    
    ###Wait to properly load the results pane###
    Wait Until Loading Indicator Is Not Visible

    Wait Until Element Is Visible    ${Results_Row}
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/ResultsRow_Value
    [Return]    ${ResultsHeaderColIndex}

Wait Until Loading Indicator Is Not Visible
    [Documentation]    This keyword is used to wait until loading indicator is not visible
    ...    @author: ehugo    17JUN2020    - initial create

    :FOR    ${Index}    IN RANGE    5
    \    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${Loading_Indicator}
    \    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${Loading_Indicator}
    \    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${Loading_Indicator}    5s
    \    ${Status}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${Loading_Indicator}    5s
    \    Exit For Loop If    ${Status}==${True}
    Sleep    1s
        
Save Message TextArea and Return Results Row List Value
    [Documentation]    This keyword is used to get the Message Text after clicking results row and return results row list value.
    ...    @author: clanding    18MAR2019    - initial create
    [Arguments]    ${iResultsHeaderColIndex}    ${sOutputFilePath}    ${sFileExtension}    @{aHeaderNames}
    
    ${Multiple_List}    Create List    
    ${Results_Row_Count_With_Ref}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    Set Global Variable    ${RESULTS_ROW_WITHREF}    ${Results_Row_Count_With_Ref}
    :FOR    ${ResultsRowIndex_Ref}    IN RANGE    1    ${Results_Row_Count_With_Ref}+1
    \    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    ${ResultsRowIndex_Ref}    @{aHeaderNames}
    \    Append To List    ${Multiple_List}    ${ResultsRowList}    
    \    Get Message TextArea Value and Save to File    ${sOutputFilePath}    ${ResultsRowIndex_Ref}    ${iResultsHeaderColIndex}    ${sFileExtension}
    [Return]    ${Multiple_List}

Compare Multiple Input and Output JSON for Base Rate
    [Documentation]    This keyword is used to compare multiple json for input and out files.
    ...    @author: clanding    18MAR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sFileName}
    
    ${InputJSON}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sFileName}.json
    ${FFC_RESPONSE}    Strip String    ${FFC_RESPONSE}    mode=left    characters=[
    ${JSON_FFC}    Strip String    ${FFC_RESPONSE}    mode=right    characters=]
    Log    ${JSON_FFC}
    
    ${JSON_FFC_List}    Split String    ${JSON_FFC}    },{
    Log    ${JSON_FFC_List}
    ${JsonCount}    Get Length    ${JSON_FFC_List}
    :FOR    ${Index}    IN RANGE    ${JsonCount}
    \    ${LastIndex}    Evaluate    ${JsonCount}-1    
    \    ${JSON_Value}    Get From List    ${JSON_FFC_List}    ${Index}
    \    ${IsEvenOrOdd}    Evaluate    int('${Index}')%2
    \    ${JSON_Value}    Run Keyword If    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}!=0    Catenate    SEPARATOR=    ${JSON_Value}    }
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}==0    Set Variable    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==1 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {    ${JSON_Value}
         ...    ELSE    Catenate    SEPARATOR=    {    ${JSON_Value}    }
    \    Log    ${JSON_Value}
    \    Create File    ${dataset_path}${sInputFilePath}tempfile.json    ${JSON_Value}
    \    ${JSON_Value}    Load JSON From File    ${dataset_path}${sInputFilePath}tempfile.json
    \    ${Val_baseRateCode}    Get Value From Json    ${JSON_Value}    $..baseRateCode
    \    ${Val_baseRateCode}    Get From List    ${Val_baseRateCode}    0
    \    ${Val_rateTenor}    Get Value From Json    ${JSON_Value}    $..rateTenor
    \    ${Val_rateTenor}    Get From List    ${Val_rateTenor}    0
    \    ${InputJSON}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sFileName}_${Val_baseRateCode}_${Val_rateTenor}.json
    \    
    \    ${JSON_Value}    Evaluate    json.dumps(${JSON_Value})    json
    \    Run Keyword And Continue On Failure    Mx Compare Json Data    ${InputJSON}     ${JSON_Value}
    \    ${Stat}    Run Keyword And Return Status    Mx Compare Json Data    ${InputJSON}     ${JSON_Value}
    \    Run Keyword If    ${Stat}==${True}    Log    Input and Output JSON Files are matched. ${InputJSON} == ${JSON_Value}
         ...    ELSE    Log    Input and Output JSON Files does not matched. ${InputJSON} != ${JSON_Value}    level=ERROR
    \    
    \    Delete File If Exist    ${dataset_path}${sInputFilePath}tempfile.json

Login FFC Correspondence
    [Documentation]    This keyword is used to open browser and then login to MCH UI - FFC.
    ...    @update: jaquitan    20MAR2019    
    Open Browser    ${CORRES_SERVER}:${CORRES_PORT}${MDM_FFC_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible     ${FFC_Username_Locator}
    Input Text    ${FFC_Username_Locator}    ${MDM_FFC_Username}
    Input Text    ${FFC_Password_Locator}    ${MDM_FFC_Password}
    Click Element    ${Signin}
    Wait Until Element Is Visible     ${FFC_Dashboard}
    

Logout FFC Correspondence
    [Documentation]    This keyword is used to logout MCH UI - FFC.
    ...    @update: jaquitan    20MAR2019   
    Wait Until Element Is Visible    ${admin_dropdown}
    Click Element    ${admin_dropdown}
    Click Element   ${Logout}
    Close Browser

Filter by Reference Header and Value and Expect No Row in Results Table
    [Documentation]    This keyword is used to search Header Reference and filter using Expected Reference Value.
    ...    Then no row is expected to be displayed in the Results Table.
    ...    @author: clanding    28MAR2019    - initial create
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${sHeaderRefName}    ${sExpectedRefValue}
    
    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    
    :FOR    ${ResultsHeaderColIndex}    IN RANGE    1    ${Results_Column_Count}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Wait Until Element Is Visible    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${HeaderText}    Get Text    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${sHeaderRefName}'
    Log    ${ResultsHeaderColIndex}
    
    ${ResultsHeaderColIndex_After}    Evaluate    ${ResultsHeaderColIndex}+1
    ${ResultsHeaderColIndex}    Evaluate    ${ResultsHeaderColIndex}-1
    ${ResultsHeaderColIndex_After_Exist}    Run Keyword And Return Status    Page Should Contain Element    ${ResultsHeaderColIndex_After}    
    Run Keyword If    ${ResultsHeaderColIndex_After_Exist}==${True}    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex_After}]
    ...    ELSE    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]
    Mx Input Text    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]    ${sExpectedRefValue}
    
    :FOR    ${Index}    IN RANGE    10
    \    ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Row}
    \    Exit For Loop If    ${Status}==${False}        
    
    Run Keyword And Continue On Failure    Wait Until Element Is Not Visible    ${Results_Row}
    ${ElementNotVisible}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${Results_Row}
    Run Keyword If    ${ElementNotVisible}==${True}    Log    Correct! No row is displayed. Data is not reflected in MCH UI.
    ...    ELSE IF    ${ElementNotVisible}==${False}    Log    Incorrect! Row is displayed. Data is reflected in MCH UI.    level=ERROR

Validate if Source API Name Does Exist
    [Documentation]    This keyword is used to validate if Source Name does not exist. If Source Name does not exist, it will not proceed on validation.
    ...    @author: clanding    28MAR2019    - initial create
    ...    @update: clanding    12JUN2019    - added \ on index for element, this is an update for robot to consider it as a string not an index of
    [Arguments]    ${sSourceName}    ${sInstance}=None

    Click Element    ${FFC_Dashboard}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    Click Element    ${RefreshButton}
    Wait Until Element Is Visible    ${Summary_Table}    30s
    ${Summary_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Summary_Row}
    ${Summary_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Summary_Column}
    
    :FOR    ${SourceIndex}    IN RANGE    1    ${Summary_Column_Count}+1
    \    ${HeaderText}    Get Text    ${Summary_Header}\[${SourceIndex}]${Summary_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${SOURCE}'    

    :FOR    ${OpenAPIIndex}    IN RANGE    1    ${Summary_Row_Count}+1
    \    ${SourceText}    Get Text    ${Summary_Row}\[${OpenAPIIndex}]${PerColumnValue}\[${SourceIndex}]${TextValue}
    \    Exit For Loop If    '${SourceText}'=='${sSourceName}'
    
    ${OpenAPI_Source_Parent_Row}    Replace Variables    ${OpenAPI_Source_Parent_Row}
    ${OpenAPI_Source_Child_Row_Instance}    Run Keyword If    '${sInstance}'!='None'    Replace Variables    ${OpenAPI_Source_Child_Row_Instance}
    ${OpenAPI_Source_Child_Row}    Run Keyword If    '${sInstance}'=='None'    Replace Variables    ${OpenAPI_Source_Child_Row}
    ${OpenAPI_Source_SecondChild_Row}    Run Keyword If    '${sInstance}'=='None'    Replace Variables    ${OpenAPI_Source_SecondChild_Row}
    
    ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible     ${OpenAPI_Source_Parent_Row}
        
    [Return]    ${Status}

Get TextJMS Response and Verify if Expected Error is Displayed
    [Documentation]    This keyword gets the global variable ${FFC_RESPONSE} and validate if the sExpectedMsg is visible in the Response file.
    ...    @author: clanding    04APR2019    - initial create
    [Arguments]    ${sExpectedMsg}
    
    Run Keyword And Continue On Failure    Should Contain    ${FFC_RESPONSE}    ${sExpectedMsg}
    ${ExpectedMsg_Exist}    Run Keyword And Return Status    Should Contain    ${FFC_RESPONSE}    ${sExpectedMsg}
    Run Keyword If    ${ExpectedMsg_Exist}==${True}    Log    Correct! '${sExpectedMsg}' is existing in '${FFC_RESPONSE}'.
    ...    ELSE IF    ${ExpectedMsg_Exist}==${False}    Log    Incorrect! '${sExpectedMsg}' is NOT existing in '${FFC_RESPONSE}'.    level=ERROR

Compare Expected and Actual Values from Results Table
    [Documentation]    This keyword is used to get data from sOutputFilePath (Filepath and Filename) and compare from expected value and log results.
    ...    @author: clanding    08APR2019    - inital create
    [Arguments]    ${sExpectedValue}    ${sOutputFilePath}    ${sFileExtension}
    
    :FOR    ${INDEX}    IN RANGE    1    ${RESULTS_ROW_WITHREF}+1
    \    
    \    ${sActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_${INDEX}.${sFileExtension}
    \    
    \    Run Keyword And Continue On Failure    Should Be Equal    ${sExpectedValue}    ${sActualValue}
    \    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sExpectedValue}    ${sActualValue}
    \    Run Keyword If    ${IsEqual}==${True}    Log    Expected and Actual values are equal. ${sExpectedValue} = ${sActualValue}
         ...    ELSE IF    ${IsEqual}==${False}    Log    Expected and Actual values are NOT equal. ${sExpectedValue} != ${sActualValue}    level=ERROR
    \    
    \    Exit For Loop If    ${INDEX}==${RESULTS_ROW_WITHREF}+1

Compare Expected FFC Response to Actual Value from Results Table for LOANIQ
    [Documentation]    This keyword is used to get actual value from Results table and validate it with expected FFC Response.
    ...    @author: jloretiz    02SEP2019    - initial create
    ...    @update: amansuet    06SEP2019    - added logging for compare json data similar with other keywords.
    ...    @update: amansuet    11SEP2019    - removed country code conversion as this is handled already in the pre-requisite.
    [Arguments]    ${sPartialValue}    ${sOutputFilePath}    ${sFileExtension}    ${sInputFilePath}    ${sInputAPIResonse}
    
    ${ExpectedValue}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sInputAPIResonse}.${sFileExtension}
    ${Convert_JSON}    evaluate    json.loads('''${ExpectedValue}''')    ${JSON}
    Delete Object From Json    ${Convert_JSON}    $..lobs..userType
    Delete Object From Json    ${Convert_JSON}    $..lobs..additionalBusinessEntity
    Delete Object From Json    ${Convert_JSON}    $..lobs..defaultBusinessEntity..businessEntityName
    Delete Object From Json    ${Convert_JSON}    $..centralUserType
    Delete Object From Json    ${Convert_JSON}    $..centralRoles
    ${Converted_JSON}    Evaluate    json.dumps(${Convert_JSON})        ${JSON}
    ${JSON_File}    Set Variable   ${sInputFilePath}${sInputAPIResonse}.${sFileExtension}
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_JSON}
    ${ActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_1.${sFileExtension}
    Run Keyword And Continue On Failure    Mx Compare Json Data    ${Converted_JSON}     ${ActualValue}
    ${Stat}    Run Keyword And Return Status    Mx Compare Json Data    ${Converted_JSON}     ${ActualValue}
    Run Keyword If    ${Stat}==${True}    Log    Input and Output JSON Files are matched. ${Converted_JSON} == ${ActualValue}
    ...    ELSE    Log    Input and Output JSON Files does not matched. ${Converted_JSON} != ${ActualValue}    level=ERROR

Compare Expected FFC Response to Actual Value from Results Table for GET ALL User API
    [Documentation]    This keyword is used to get actual value from Results table and validate it with expected FFC Response.
    ...    @author: amansuet    02SEP2019    - initial create
    [Arguments]    ${sOutputFilePath}    ${sFileExtension}    ${sInputFilePath}    ${sInputAPIResponse}
    
    ${ActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_1.${sFileExtension}
    ${ExpectedValue}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sInputAPIResponse}.${sFileExtension}
    Run Keyword And Continue On Failure    Mx Compare Json Data    ${ActualValue}     ${ExpectedValue}
    ${Stat}    Run Keyword And Return Status    Mx Compare Json Data    ${ActualValue}     ${ExpectedValue}
    Run Keyword If    ${Stat}==${True}    Log    Input and Output JSON Files are matched. ${ActualValue} == ${ExpectedValue}
    ...    ELSE    Log    Input and Output JSON Files does not matched. ${ActualValue} != ${ExpectedValue}    level=ERROR
    
Compare Expected FFC Response to Actual Value from Results Table
    [Documentation]    This keyword is used to get actual value from Results table and validate it with expected FFC Response for LOANIQ.
    ...    @author: jloretiz    02SEP2019    - initial create
    ...    @update: amansuet    06SEP2019    - added logging for compare json data similar with other keywords.
    [Arguments]    ${sPartialValue}    ${sOutputFilePath}    ${sFileExtension}    ${sInputFilePath}    ${sInputAPIResonse}
    
    ${ActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_1.${sFileExtension}
    ${Convert_JSON}    evaluate    json.loads('''${ActualValue}''')    ${JSON}
    Delete Object From Json    ${Convert_JSON}    $..roles..description
    Delete Object From Json    ${Convert_JSON}    $..defaultEntityBranchName
    Delete Object From Json    ${Convert_JSON}    $..additionalEntities
    Delete Object From Json    ${Convert_JSON}    $..lastUpdatedTime
    Delete Object From Json    ${Convert_JSON}    $..userTypeDescription
    ${Converted_JSON}    Evaluate    json.dumps(${Convert_JSON})        ${JSON}
    ${JSON_File}    Set Variable   ${sOutputFilePath}_1.${sFileExtension}
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_JSON}
    ${ExpectedValue}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sInputAPIResonse}_FFC.${sFileExtension}
    Run Keyword And Continue On Failure    Mx Compare Json Data    ${Converted_JSON}     ${ExpectedValue}
    ${Stat}    Run Keyword And Return Status    Mx Compare Json Data    ${Converted_JSON}     ${ExpectedValue}
    Run Keyword If    ${Stat}==${True}    Log    Input and Output JSON Files are matched. ${Converted_JSON} == ${ExpectedValue}
    ...    ELSE    Log    Input and Output JSON Files does not matched. ${Converted_JSON} != ${ExpectedValue}    level=ERROR

Compare Expected FFC Response to Actual Value from Results Table for Deleted User
    [Documentation]    This keyword is used to get actual value from Results table and validate it with expected FFC Response for Deleted user.
    ...    @author: jloretiz    11SEP2019    - initial create
    [Arguments]    ${sPartialValue}    ${sOutputFilePath}    ${sFileExtension}
    
    ${ActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_1.${sFileExtension}
    Run Keyword And Continue On Failure    Should Contain    ${ActualValue}     User does not exist: ${sPartialValue}
    ${IsExisting}    Run Keyword And Return Status    Should Contain    ${ActualValue}     User does not exist: ${sPartialValue}
    Run Keyword If    ${IsExisting}==${True}    Log    ${ActualValue} CONTAINS '${sPartialValue}'.
    ...    ELSE IF    ${IsExisting}==${False}    Log    ${ActualValue} DOES NOT CONTAIN '${sPartialValue}'.    level=ERROR   

Compare Expected FFC Response to Actual Value from Results Table for Deleted User on LOANIQ
    [Documentation]    This keyword is used to get actual value from Results table and validate it with expected FFC Response for Deleted user in LOANIQ.
    ...    @author: jloretiz    11SEP2019    - initial create
    [Arguments]    ${sPartialValue}    ${sOutputFilePath}    ${sFileExtension}
    
    ${ActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_1.${sFileExtension}
    Run Keyword And Continue On Failure    Should Contain    ${ActualValue}     ${sPartialValue}
    ${IsExisting}    Run Keyword And Return Status    Should Contain    ${ActualValue}     ${sPartialValue}
    Run Keyword If    ${IsExisting}==${True}    Log    ${ActualValue} CONTAINS '${sPartialValue}'.
    ...    ELSE IF    ${IsExisting}==${False}    Log    ${ActualValue} DOES NOT CONTAIN '${sPartialValue}'.    level=ERROR 

    Run Keyword And Continue On Failure    Should Contain    ${ActualValue}     "status":"INACTIVE"
    ${IsStatusInactive}    Run Keyword And Return Status    Should Contain    ${ActualValue}     "status":"INACTIVE"
    Run Keyword If    ${IsStatusInactive}==${True}    Log    ${ActualValue} CONTAINS "status":"INACTIVE".
    ...    ELSE IF    ${IsStatusInactive}==${False}    Log    ${ActualValue} DOES NOT CONTAIN "status":"INACTIVE".    level=ERROR 

Compare Partial Message to Actual Value from Results Table
    [Documentation]    This keyword is used to get actual value from Results table and validate if partial value is existing.
    ...    @author: clanding    08APR2019    - initial create
    ...    @author: dahijara    25JUL2019    - updated logic to handle addition of new LOB to an existing profile
    [Arguments]    ${sPartialValue}    ${sOutputFilePath}    ${sFileExtension}
    
    :FOR    ${INDEX}    IN RANGE    1    ${RESULTS_ROW_WITHREF}+1
    \    
    \    ${sActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_${INDEX}.${sFileExtension}
    \    ${IsExisting}    Run Keyword And Return Status    Should Contain    ${sActualValue}    ${sPartialValue}
    \    Run Keyword If    ${IsExisting}==${True}    Exit For Loop
    \    Exit For Loop If    ${INDEX}==${RESULTS_ROW_WITHREF}+1

    Run Keyword If    ${IsExisting}==${True}    Log    ${sActualValue} CONTAINS '${sPartialValue}'.
    ...    ELSE IF    ${IsExisting}==${False}    Log    ${sActualValue} DOES NOT CONTAIN '${sPartialValue}'.    level=ERROR   
    
Compare Input and Output XML from Results Table
    [Documentation]    This keyword is used to get sOutputFilePath (File Path and File Name of XML) from results table 
    ...    and compare from sInputFilePath (File Path and File Name of XML).
    ...    @author: clanding    08APR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}    ${sFileExtension}
    
    :FOR    ${INDEX}    IN RANGE    1    ${RESULTS_ROW_WITHREF}+1
    \    
    \    Run Keyword And Continue On Failure    Mx Compare Xml With Baseline File    ${dataset_path}${sInputFilePath}.${sFileExtension}
         ...    ${dataset_path}${sOutputFilePath}_${INDEX}.${sFileExtension}
    \    ${IsEqual}    Run Keyword And Return Status    Mx Compare Xml With Baseline File    ${dataset_path}${sInputFilePath}.${sFileExtension}
         ...    ${dataset_path}${sOutputFilePath}_${INDEX}.${sFileExtension}    
    \    Run Keyword If    ${IsEqual}==${True}    Log    XML are equal. ${dataset_path}${sInputFilePath}.${sFileExtension} = ${dataset_path}${sOutputFilePath}_${INDEX}.${sFileExtension}
         ...    ELSE IF    ${IsEqual}==${False}    Log    XML are NOT equal. ${dataset_path}${sInputFilePath}.${sFileExtension} != ${dataset_path}${sOutputFilePath}_${INDEX}.${sFileExtension}    level=ERROR
    \    
    \    Exit For Loop If    ${INDEX}==${RESULTS_ROW_WITHREF}+1

Compare Input and Output JSON for User
    [Documentation]    This keyword is used to compare multiple json for input and out files.
    ...    @author: clanding    08APR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sFileName}
    
    ${InputJSON}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}${sFileName}.json
    Run Keyword And Continue On Failure    Mx Compare Json Data    ${InputJSON}     ${FFC_RESPONSE}
    ${Stat}    Run Keyword And Return Status    Mx Compare Json Data    ${InputJSON}     ${FFC_RESPONSE}
    Run Keyword If    ${Stat}==${True}    Log    Input and Output JSON Files are matched. ${InputJSON} == ${FFC_RESPONSE}
    ...    ELSE    Log    Input and Output JSON Files does not matched. ${InputJSON} != ${FFC_RESPONSE}    level=ERROR

Verify Security Details in Output XML for User API
    [Documentation]    This keyword is used to get sOutputFilePath (File Path and File Name of XML) from results table 
    ...    and verify if security details such as Profile ID, Login ID and Lock Indicator from sInputFilePath (File Path and File Name of XML)
    ...    are existing in the XML file.
    ...    @author: clanding    15MAY2019    - initial create
    ...    @update: dahijara    20AUG2019    - added condition in setting input values to accomodate PUT method.
    ...    @update: dahijara    22JUN2020    - added agrgument required for Compare Security Details in Output XML for User API
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}    ${sFileExtension}    ${sHTTPMethod}
    ${RESULTS_ROW_WITHREF}    Set Variable    1
    :FOR    ${INDEX}    IN RANGE    1    ${RESULTS_ROW_WITHREF}+1
    \    
    \    Compare Security Details in Output XML for User API    ${sInputFilePath}    ${sOutputFilePath}    ${sFileExtension}    ${sHTTPMethod}    loginId    ${INDEX}
    \    Compare Security Details in Output XML for User API    ${sInputFilePath}    ${sOutputFilePath}    ${sFileExtension}    ${sHTTPMethod}    userProfileRID    ${INDEX}
    \    Compare Security Details in Output XML for User API    ${sInputFilePath}    ${sOutputFilePath}    ${sFileExtension}    ${sHTTPMethod}    osUserId    ${INDEX}
    \    Compare Security Details in Output XML for User API    ${sInputFilePath}    ${sOutputFilePath}    ${sFileExtension}    ${sHTTPMethod}    lockedIndication    ${INDEX}
    \    
    \    Exit For Loop If    ${INDEX}==${RESULTS_ROW_WITHREF}+1

Verify Security Details in Output XML for Delete User API
    [Documentation]    This keyword is used for Delete User API to get sOutputFilePath (File Path and File Name of XML) from results table 
    ...    and verify if Update User Profile such as Login ID and User Status from sInputFilePath (File Path and File Name of XML)
    ...    are existing in the XML file.
    ...    @author: amansuet    16AUG2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}    ${sFileExtension}
    ${RESULTS_ROW_WITHREF}    Set Variable    1
    :FOR    ${INDEX}    IN RANGE    1    ${RESULTS_ROW_WITHREF}+1
    \    
    \    ${Input_LoginID}    XML.Get Element Attribute    ${dataset_path}${sInputFilePath}.${sFileExtension}    loginId    xpath=UpdateUserProfile        
    \    ${Input_UserStatus}    XML.Get Element Attribute    ${dataset_path}${sInputFilePath}.${sFileExtension}    userStatus    xpath=UpdateUserProfile
    \    
    \    ${Output_XML}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_${INDEX}.${sFileExtension}
    \    
    \    Run Keyword And Continue On Failure    Should Contain    ${Output_XML}    loginId='${Input_LoginID}'   
    \    ${IsExisting}    Run Keyword And Return Status    Should Contain    ${Output_XML}    loginId='${Input_LoginID}'
    \    Run Keyword If    ${IsExisting}==${True}    Log    Login ID is existing in the output XML: ${Output_XML}
         ...    ELSE IF    ${IsExisting}==${False}    Log    Login ID is NOT existing in the output XML: ${Output_XML}
    \    
    \    Run Keyword And Continue On Failure    Should Contain    ${Output_XML}    userStatus='${Input_UserStatus}'
    \    ${IsExisting}    Run Keyword And Return Status    Should Contain    ${Output_XML}    userStatus='${Input_UserStatus}'
    \    Run Keyword If    ${IsExisting}==${True}    Log    User Status is existing in the output XML: ${Output_XML}
         ...    ELSE IF    ${IsExisting}==${False}    Log    User Status is NOT existing in the output XML: ${Output_XML}
    \    
    \    Exit For Loop If    ${INDEX}==${RESULTS_ROW_WITHREF}+1

Split Request ID From Splitter Queue for TL and Return Final Request ID
    [Documentation]    This keyword is used to split string the request if from Splitter Queue and then return the request id to be used on 
    ...    filtering other queuenames for transformation layer transactions.
    ...    @author: clanding    31MAY2019    - initial create
    [Arguments]    ${sRequestID}    ${sDelimiter}
    
    ${Value_List}    Split String    ${sRequestID}     ${sDelimiter}
    ${Value_Length}    Get Length    ${Value_List}
    :FOR    ${Index}    IN RANGE    ${Value_Length}
    \    ${Value}    Get From List    ${Value_List}    ${Index}
    
    [Return]    ${Value}

Validate Response from CBA Push Queue
    [Documentation]    This keyword is used to validate if the response details are correct from Custom CBA Push queue.
    ...    ${sFileOfResponseJSON} includes file path and file name.
    ...    @author: clanding    31MAY2019    - initial create
    [Arguments]    ${sFileOfResponseJSON}    ${sExpectedRequestID}    ${sExpectedAPIMethod}    ${sExpectedAPIName}    ${sExpectedConsolidationStatus}
    
    ${JSON_Object}    Load JSON From File    ${datasetpath}${sFileOfResponseJSON}.${JSON}
    ${RequestID_JSONList}    Get Value From Json    ${JSON_Object}    requestId
    ${RequestID_JSON}    Get From List    ${RequestID_JSONList}    0
    ${APIMethod_JSONList}    Get Value From Json    ${JSON_Object}    apiMethod
    ${APIMethod_JSON}    Get From List    ${APIMethod_JSONList}    0
    ${APIName_JSONList}    Get Value From Json    ${JSON_Object}    apiName
    ${APIName_JSON}    Get From List    ${APIName_JSONList}    0
    ${ConsolidationStatus_JSONList}    Get Value From Json    ${JSON_Object}    consolidationStatus
    ${ConsolidationStatus_JSON}    Get From List    ${ConsolidationStatus_JSONList}    0
    
    Run Keyword And Continue On Failure    Should Be Equal    ${sExpectedRequestID}    ${RequestID_JSON}
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${sExpectedRequestID}    ${RequestID_JSON}
    Run Keyword If    ${Status}==${True}    Log    Request ID is correct. ${sExpectedRequestID} == ${RequestID_JSON}
    ...    ELSE IF    ${Status}==${False}    Log    Request ID is incorrect. ${sExpectedRequestID} != ${RequestID_JSON}    level=ERROR
    
    Run Keyword And Continue On Failure    Should Be Equal    ${sExpectedAPIMethod}    ${APIMethod_JSON}
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${sExpectedAPIMethod}    ${APIMethod_JSON}
    Run Keyword If    ${Status}==${True}    Log    API Method is correct. ${sExpectedAPIMethod} == ${APIMethod_JSON}
    ...    ELSE IF    ${Status}==${False}    Log    API Method is incorrect. ${sExpectedAPIMethod} != ${APIMethod_JSON}    level=ERROR
    
    Run Keyword And Continue On Failure    Should Be Equal    ${sExpectedAPIName}    ${APIName_JSON}
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${sExpectedAPIName}    ${APIName_JSON}
    Run Keyword If    ${Status}==${True}    Log    API Name is correct. ${sExpectedAPIName} == ${APIName_JSON}
    ...    ELSE IF    ${Status}==${False}    Log    API Name is incorrect. ${sExpectedAPIName} != ${APIName_JSON}    level=ERROR
    
    Run Keyword And Continue On Failure    Should Be Equal    ${sExpectedConsolidationStatus}    ${ConsolidationStatus_JSON}
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${sExpectedConsolidationStatus}    ${ConsolidationStatus_JSON}
    Run Keyword If    ${Status}==${True}    Log    Consolidation Status is correct. ${sExpectedConsolidationStatus} == ${ConsolidationStatus_JSON}
    ...    ELSE IF    ${Status}==${False}    Log    Consolidation Status is incorrect. ${sExpectedConsolidationStatus} != ${ConsolidationStatus_JSON}    level=ERROR

Filter by Reference Header and Save Message TextArea for Specified File and Return Results Row List Value
    [Documentation]    This keyword is used to search Header Reference and filter using Expected Reference Value.
    ...    Then gets the row values using array of Header Names. Then gets the Message Text for the specified file.
    ...    @author: cfrancis    20JUN2019    - initial create
    ...    @update: jdelacru    15JUL2019    - Added Exit For Loop so the code will not go through all the records in MessageResponseProcessor 
    ...    @update: ehugo    18JUN2020    - updated screenshot location
    [Arguments]    ${sHeaderRefName}    ${sExpectedRefValue}    ${sInputFileName}    ${sOutputFilePath}    ${sFileExtension}    @{aHeaderNames}
    
    ${Results_Column_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Header}
    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    
    :FOR    ${ResultsHeaderColIndex}    IN RANGE    1    ${Results_Column_Count}+1
    \    Mx Scroll Element Into View    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${ElementVisible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    ${HeaderText}    Get Text    ${Results_Header}\[${ResultsHeaderColIndex}]${Results_Header_Text}
    \    Exit For Loop If    '${HeaderText}'=='${sHeaderRefName}'
    Log    ${ResultsHeaderColIndex}
    
    ${ResultsHeaderColIndex_After}    Evaluate    ${ResultsHeaderColIndex}+1
    ${ResultsHeaderColIndex}    Evaluate    ${ResultsHeaderColIndex}-1
    ${ResultsHeaderColIndex_After_Exist}    Run Keyword And Return Status    Page Should Contain Element    ${ResultsHeaderColIndex_After}    
    Run Keyword If    ${ResultsHeaderColIndex_After_Exist}==${True}    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex_After}]
    ...    ELSE    Mx Scroll Element Into View    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]
    Mx Input Text    ${Results_FilterPanel}\[${ResultsHeaderColIndex}]    ${sExpectedRefValue}
    
    :FOR    ${Index}    IN RANGE    10
    \    ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Row}
    \    Exit For Loop If    ${Status}==${True}        
    
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/OpenAPI_Queues
    ${Multiple_List}    Create List    
    ${Results_Row_Count_With_Ref}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    Set Global Variable    ${RESULTS_ROW_WITHREF}    ${Results_Row_Count_With_Ref}
    :FOR    ${ResultsRowIndex_Ref}    IN RANGE    1    ${Results_Row_Count_With_Ref}+1
    \    @{ResultsRowList}    Get Results Table Column Value by Header List and Return    ${ResultsRowIndex_Ref}    @{aHeaderNames}
    \    Append To List    ${Multiple_List}    ${ResultsRowList}    
    \    ${fileName}    ${Status}    Get Message TextArea Value and Verify then Save to File    ${sInputFileName}    ${sOutputFilePath}    ${ResultsRowIndex_Ref}    ${ResultsHeaderColIndex}    ${sFileExtension}
    \    Log    ${Multiple_List}
    \    Exit For Loop If    ${Status}==${True}
    [Return]    ${Multiple_List}
    
Get Message TextArea Value and Verify then Save to File
    [Documentation]    This keyword is used to get Message Textarea value and save to Output File. sOutputFilePath includes file path and file name.
    ...    @author: cfrancis    20JUN2019    - initial create
    ...    @update: jdelacru    15JUL2019    - added ${Status} as return value for validating requestID in MessageResponseProcessor
    ...    @update: ehugo    18JUN2020    - updated screenshot location
    [Arguments]    ${sInputFileName}    ${sOutputFilePath}    ${iRowRef}    ${iColRef}    ${sFileExtension}
    
    :FOR    ${Index}    IN RANGE    5
    \    Double Click Element    ${Results_Row}\[${iRowRef}]${PerColumnValue}\[${iColRef}]${TextValue}
    \    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Textarea}
    \    Exit For Loop If    ${status}==${True}
    
    Mx Scroll Element Into View    ${Textarea}
    ${FFC_RESPONSE}    Get Value   ${Textarea}
    ${Status}    Run Keyword and Return Status    Should Contain    ${FFC_RESPONSE}    ${sInputFileName}
    Log    ${sInputFileName}
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/MessageTextArea_${iRowRef}
    Set Global Variable    ${FFC_RESPONSE}
    ${fileName}    Set Variable    ${dataset_path}${sOutputFilePath}.${sFileExtension}
    Delete File If Exist    ${dataset_path}${sOutputFilePath}.${sFileExtension}
    Run Keyword If    ${Status}==${True}    Create File    ${fileName}    ${FFC_Response}
    [Return]    ${fileName}    ${Status}
    
Validate Response Mechanism
    [Documentation]    This keyword is used to validate if the response details are correct from Response Mechanism.
    ...    ${sFileOfResponseJSON} includes file path and file name.
    ...    @author: cfrancis    21JUN2019    - initial create
    [Arguments]    ${sFileOfResponseJSON}    ${sExpectedRequestID}    ${sExpectedAPIMethod}    ${sExpectedAPIName}    ${sExpectedConsolidationStatus}
    
    ${JSON_Object}    Load JSON From File    ${datasetpath}${sFileOfResponseJSON}.${JSON}
    ${RequestID_JSONList}    Get Value From Json    ${JSON_Object}    requestId
    ${RequestID_JSON}    Get From List    ${RequestID_JSONList}    0
    ${APIMethod_JSONList}    Get Value From Json    ${JSON_Object}    apiMethod
    ${APIMethod_JSON}    Get From List    ${APIMethod_JSONList}    0
    ${APIName_JSONList}    Get Value From Json    ${JSON_Object}    apiName
    ${APIName_JSON}    Get From List    ${APIName_JSONList}    0
    ${ConsolidationStatus_JSONList}    Get Value From Json    ${JSON_Object}    consolidationStatus
    ${ConsolidationStatus_JSON}    Get From List    ${ConsolidationStatus_JSONList}    0
    
    Run Keyword And Continue On Failure    Should Be Equal    ${sExpectedRequestID}    ${RequestID_JSON}
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${sExpectedRequestID}    ${RequestID_JSON}
    Run Keyword If    ${Status}==${True}    Log    Request ID is correct. ${sExpectedRequestID} == ${RequestID_JSON}
    ...    ELSE IF    ${Status}==${False}    Log    Request ID is incorrect. ${sExpectedRequestID} != ${RequestID_JSON}    level=ERROR
    
    Run Keyword And Continue On Failure    Should Be Equal    ${sExpectedAPIMethod}    ${APIMethod_JSON}
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${sExpectedAPIMethod}    ${APIMethod_JSON}
    Run Keyword If    ${Status}==${True}    Log    API Method is correct. ${sExpectedAPIMethod} == ${APIMethod_JSON}
    ...    ELSE IF    ${Status}==${False}    Log    API Method is incorrect. ${sExpectedAPIMethod} != ${APIMethod_JSON}    level=ERROR
    
    Run Keyword And Continue On Failure    Should Be Equal    ${sExpectedAPIName}    ${APIName_JSON}
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${sExpectedAPIName}    ${APIName_JSON}
    Run Keyword If    ${Status}==${True}    Log    API Name is correct. ${sExpectedAPIName} == ${APIName_JSON}
    ...    ELSE IF    ${Status}==${False}    Log    API Name is incorrect. ${sExpectedAPIName} != ${APIName_JSON}    level=ERROR
    
    Run Keyword And Continue On Failure    Should Be Equal    ${sExpectedConsolidationStatus}    ${ConsolidationStatus_JSON}
    ${Status}    Run Keyword And Return Status    Should Be Equal    ${sExpectedConsolidationStatus}    ${ConsolidationStatus_JSON}
    Run Keyword If    ${Status}==${True}    Log    Consolidation Status is correct. ${sExpectedConsolidationStatus} == ${ConsolidationStatus_JSON}
    ...    ELSE IF    ${Status}==${False}    Log    Consolidation Status is incorrect. ${sExpectedConsolidationStatus} != ${ConsolidationStatus_JSON}    level=ERROR

Compare Expected and Actual TextJMS for Calendar TL
    [Documentation]    This keyword is used to compare the expected and actual textJMS for Calendar Transformation Layer.
    ...    @author: clanding    16JUL2019    - initial create
    ...    @update: clanding    31JUL2019    - added condition to handle CreateHolidayCalendarDate in XML
    ...    @update: ehugo    17JUN2020    - added getting '${XML_Filename}' to pass the value of variable to 'Get TextJMS XML Files and Rename with Holiday Code and Date and Compare to Input'
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}
    
    :FOR    ${INDEX}    IN RANGE    1    ${RESULTS_ROW_WITHREF}+1
    \    
    \    ${XML_file}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_${INDEX}.xml
    \    ${XML_Filename}    Set Variable    ${dataset_path}${sOutputFilePath}_${INDEX}.xml
    \    ${HolidayCode_XML_Create}    Run Keyword And Return Status    XML.Get Element Attribute    ${XML_file}    cHolidayCode    xpath=CreateHolidayCalendarDate
    \    ${HolidayCode_XML_Update}    Run Keyword And Return Status    XML.Get Element Attribute    ${XML_file}    cHolidayCode    xpath=UpdateHolidayCalendarDate
    \    
    \    ${Xpath}    Run Keyword If    ${HolidayCode_XML_Create}==${True}    Set Variable    CreateHolidayCalendarDate
         ...    ELSE IF    ${HolidayCode_XML_Update}==${True}    Set Variable    UpdateHolidayCalendarDate
    \    
    \    Get TextJMS XML Files and Rename with Holiday Code and Date and Compare to Input    ${sInputFilePath}    ${sOutputFilePath}    ${XML_file}    ${XML_Filename}    ${Xpath}
    \    Exit For Loop If    ${INDEX}==${RESULTS_ROW_WITHREF}+1

Get TextJMS XML Files and Rename with Holiday Code and Date and Compare to Input
    [Documentation]    This keyword is used to get sOutputFilePath (TextJMS) files and rename them to have the file name with Holiday Code 
    ...    and Holiday Date. Then delete TextJMS files with appended numbers.
    ...    @author: clanding    16JUL2019    - initial create
    ...    @update: clanding    31JUL2019    - added handling for CreateHolidayCalendarDate in XML
    ...    @update: ehugo    17JUN2020    - added '${sXML_Filename}' argument to properly delete the XML file if exist
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}    ${sXML_file}    ${sXML_Filename}    ${sXpath}=None
    
    ${Xpath}    Run Keyword If    '${sXpath}'=='None'    Set Variable    UpdateHolidayCalendarDate
    ...    ELSE    Set Variable    ${sXpath}
    
    ${HolidayCode}    XML.Get Element Attribute    ${sXML_file}    cHolidayCode    xpath=${Xpath}
    ${HolidayDate}    XML.Get Element Attribute    ${sXML_file}    cHolidayDate    xpath=${Xpath}
    
    Log    ${sXML_Filename}
    Delete File If Exist    ${sXML_Filename}
    Create File    ${dataset_path}${sOutputFilePath}_${HolidayCode}_${HolidayDate}.xml    ${sXML_file}    
    
    Run Keyword And Continue On Failure    Mx Compare Xml With Baseline File    ${dataset_path}${sInputFilePath}_${HolidayCode}_${HolidayDate}.xml    
    ...    ${dataset_path}${sOutputFilePath}_${HolidayCode}_${HolidayDate}.xml    
    ${Stat}    Run Keyword And Return Status    Mx Compare Xml With Baseline File    ${dataset_path}${sInputFilePath}_${HolidayCode}_${HolidayDate}.xml    
    ...    ${dataset_path}${sOutputFilePath}_${HolidayCode}_${HolidayDate}.xml
    Run Keyword If    ${Stat}==${True}    Log    ${dataset_path}${sInputFilePath}_${HolidayCode}_${HolidayDate}.xml and ${dataset_path}${sOutputFilePath}_${HolidayCode}_${HolidayDate}.xml are matched!
    ...    ELSE    Log    ${dataset_path}${sInputFilePath}_${HolidayCode}_${HolidayDate}.xml and ${dataset_path}${sOutputFilePath}_${HolidayCode}_${HolidayDate}.xml does not matched!    level=ERROR

Compare Multiple Input and Output JSON for TL Calendar
    [Documentation]    This keyword is used to compare multiple json for input and output files.
    ...    @author: clanding    16JUL2019    - initial create
    ...    @update: clanding    25JUL2019    - updated validation for input and output json files
    [Arguments]    ${sInputFilePath}    ${sFileName}
    
    ${JSON_FFC}    Strip String    ${FFC_RESPONSE}    mode=left    characters=[
    ${JSON_FFC}    Strip String    ${JSON_FFC}    mode=right    characters=]
    Log    ${JSON_FFC}
    
    ${JSON_FFC_List}    Split String    ${JSON_FFC}    },{"lobs":
    Log    ${JSON_FFC_List}
    ${JsonCount}    Get Length    ${JSON_FFC_List}
    :FOR    ${Index}    IN RANGE    ${JsonCount}
    \    ${LastIndex}    Evaluate    ${JsonCount}-1    
    \    ${JSON_Value}    Get From List    ${JSON_FFC_List}    ${Index}
    \    ${IsEvenOrOdd}    Evaluate    int('${Index}')%2
    \    ${JSON_Value}    Run Keyword If    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}!=0    Catenate    SEPARATOR=    ${JSON_Value}    }
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==0 and ${LastIndex}==0    Set Variable    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==0 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {"lobs":    ${JSON_Value}
         ...    ELSE IF    ${IsEvenOrOdd}==1 and ${Index}==${LastIndex}    Catenate    SEPARATOR=    {"lobs":    ${JSON_Value}
         ...    ELSE    Catenate    SEPARATOR=    {"lobs":    ${JSON_Value}    }
    \    Log    ${JSON_Value}
    \    Create File    ${dataset_path}${sInputFilePath}tempfile.json    ${JSON_Value}
    \    ${OutputJSON}    Load JSON From File    ${dataset_path}${sInputFilePath}tempfile.json
    \    ${Val_calendarId}    Get Value From Json    ${OutputJSON}    $..calendarId
    \    ${Val_calendarId}    Get From List    ${Val_calendarId}    0
    \    ${InputJSON}    Load JSON From File    ${dataset_path}${sInputFilePath}${sFileName}_ID_${Val_calendarId}.json
    \    
    \    ### Validate Date Details section ###
    \    Get Date Details Values in Input and Verify if Existing in Output File    ${InputJSON}    ${OutputJSON}
    \    
    \    ### Validate all fields excluding dateDetails ###
    \    ${OutputJSON_NodateDetails}    Delete Object From Json    ${OutputJSON}    $..dateDetails
    \    ${InputJSON_NodateDetails}    Delete Object From Json    ${InputJSON}    $..dateDetails
    \    ${InputJSON}    Evaluate    json.dumps(${InputJSON})    json
    \    ${OutputJSON}    Evaluate    json.dumps(${OutputJSON})    json
    \    Run Keyword And Continue On Failure    Mx Compare Json Data    ${InputJSON}     ${OutputJSON}
    \    ${Stat}    Run Keyword And Return Status    Mx Compare Json Data    ${InputJSON}     ${OutputJSON}
    \    Run Keyword If    ${Stat}==${True}    Log    Input and Output JSON Files are matched. ${InputJSON} == ${OutputJSON}
         ...    ELSE    Log    Input and Output JSON Files does not matched. ${InputJSON} != ${OutputJSON}    level=ERROR
    \    
    \    Delete File If Exist    ${dataset_path}${sInputFilePath}tempfile.json

Navigate Splitter through Instance Name
    [Documentation]    This keyword is use to navigate splitter if the given argument is Instance Name
    ...    @author: jdelacru    26JUL2019    - initial create
    [Arguments]    ${sSourceName}    ${sInstance}
    
    ${OpenAPI_Source_Parent_Row}    Replace Variables    ${OpenAPI_Source_Parent_Row}
    ${OpenAPI_Source_Child_Row_Instance}    Replace Variables    ${OpenAPI_Source_Child_Row_Instance}
    ${OpenAPI_Source_Child_Row}    Run Keyword If    '${sInstance}'=='None'    Replace Variables    ${OpenAPI_Source_Child_Row}
    ${OpenAPI_Source_SecondChild_Row}    Run Keyword If    '${sInstance}'=='None'    Replace Variables    ${OpenAPI_Source_SecondChild_Row}
    
    :FOR    ${INDEX}    IN RANGE    10
    \    
    \    Wait Until Element Is Visible     ${OpenAPI_Source_Parent_Row}
    \    Double Click Element    ${OpenAPI_Source_Parent_Row}
    \    Sleep    2s
    \    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible     ${OpenAPI_Source_Child_Row_Instance}
    \    
    \    Exit For Loop If    ${status}==${True}
    
    :FOR    ${INDEX}    IN RANGE    10
    \    
    \    ${IsVisible}    Run Keyword If    '${sInstance}'!='None'    Run Keyword And Return Status    Wait Until Element Is Visible     ${OpenAPI_Source_Child_Row_Instance}
    \    
    \    Run Keyword If    ${IsVisible}==${True}    Double Click Element    ${OpenAPI_Source_Child_Row_Instance}
         ...    ELSE    Run Keywords    Double Click Element    ${OpenAPI_Source_Parent_Row}
         ...    AND    Wait Until Element Is Visible     ${OpenAPI_Source_Child_Row_Instance}
         ...    AND    Double Click Element    ${OpenAPI_Source_Child_Row_Instance}
    \    
    \    ${status}    Run Keyword If    '${sInstance}'=='None'    Run Keyword And Return Status    Wait Until Element Is Visible     ${OpenAPI_Source_SecondChild_Row}    1s
    \    Run Keyword If    '${status}'=='${True}'    Run Keyword If    '${sInstance}'=='None'    Double Click Element    ${OpenAPI_Source_SecondChild_Row}
         ...    ELSE IF    '${status}'=='${False}'    Run Keyword If    '${sInstance}'=='None'    Double Click Element    ${OpenAPI_Source_Child_Row}
    \    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Table_Caption}    30s    
    \    
    \    Exit For Loop If    ${status}==${True}

Navigate Splitter through Output Type
    [Documentation]    This keyword is use to navigate splitter if the given argument is Output Type
    ...    @author: jdelacru    26JUL2019    - initial create
    [Arguments]    ${sSourceName}    ${sOutputType}
    
    ${OpenAPI_Source_Parent_Row}    Replace Variables    ${OpenAPI_Source_Parent_Row}
    ${OpenAPI_Source_Child_Row_Success_Instance}    Replace Variables    ${OpenAPI_Source_Child_Row_Success_Instance}
    ${OpenAPI_Source_Child_Row}    Run Keyword If    '${sOutputType}'=='None'    Replace Variables    ${OpenAPI_Source_Child_Row}
    ${OpenAPI_Source_SecondChild_Row}    Run Keyword If    '${sOutputType}'=='None'    Replace Variables    ${OpenAPI_Source_SecondChild_Row}
    
    :FOR    ${INDEX}    IN RANGE    10
    \    
    \    Wait Until Element Is Visible     ${OpenAPI_Source_Parent_Row}
    \    Double Click Element    ${OpenAPI_Source_Parent_Row}
    \    Sleep    2s
    \    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible     ${OpenAPI_Source_Child_Row_Success_Instance}
    \    
    \    Exit For Loop If    ${status}==${True}
    
    :FOR    ${INDEX}    IN RANGE    10
    \    
    \    ${IsVisible}    Run Keyword If    '${sOutputType}'!='None'    Run Keyword And Return Status    Wait Until Element Is Visible     ${OpenAPI_Source_Child_Row_Success_Instance}
    \    
    \    Run Keyword If    ${IsVisible}==${True}    Double Click Element    ${OpenAPI_Source_Child_Row_Success_Instance}
         ...    ELSE    Run Keywords    Double Click Element    ${OpenAPI_Source_Parent_Row}
         ...    AND    Wait Until Element Is Visible     ${OpenAPI_Source_Child_Row_Success_Instance}
         ...    AND    Double Click Element    ${OpenAPI_Source_Child_Row_Success_Instance}
    \    
    \    ${status}    Run Keyword If    '${sOutputType}'=='None'    Run Keyword And Return Status    Wait Until Element Is Visible     ${OpenAPI_Source_SecondChild_Row}    1s
    \    Run Keyword If    '${status}'=='${True}'    Run Keyword If    '${sOutputType}'=='None'    Double Click Element    ${OpenAPI_Source_SecondChild_Row}
         ...    ELSE IF    '${status}'=='${False}'    Run Keyword If    '${sOutputType}'=='None'    Double Click Element    ${OpenAPI_Source_Child_Row}
    \    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Results_Table_Caption}    30s    
    \    
    \    Exit For Loop If    ${status}==${True}

Validate Multiple Expected Value List From Results Row Values
    [Documentation]    This keyword is used to validate multiple expected value lists from set of actual values from Results table.
    ...    @author: dahijara    31JUL2019    - initial create
    [Arguments]    ${aActualList}    @{aExpectedList}
    
    ${ExpectedListCount}    Get Length    ${aExpectedList}
    :FOR    ${INDEX}    IN RANGE    ${ExpectedListCount}
    \    ${ExpectedVal}    Get From List    ${aExpectedList}    ${INDEX}
    \    ${ActualVal}    Get From List    ${aActualList}    ${INDEX}
    \    Run Keyword And Continue On Failure    Should Be Equal    ${ExpectedVal}    ${ActualVal}    
    \    ${Stat}    Run Keyword And Return Status    Should Be Equal    ${ExpectedVal}    ${ActualVal}
    \    Run Keyword If    ${Stat}==${True}    Log    Expected and Actual matched! ${ExpectedVal} = ${ActualVal}
         ...    ELSE    Log    Expected and Actual not matched! ${ExpectedVal} != ${ActualVal}    level=ERROR

Compare Security Details in Output XML for User API
    [Documentation]    This keyword is used to get sOutputFilePath (File Path and File Name of XML) from results table 
    ...    and verify if security details based from passed parameters
    ...    are existing in the input and output XML file.
    ...    @author: dahijara    21AUG2019    - initial create
    ...    @update: dahijara    22JUL2020    - added argument for ${INDEX} for gettingthe correct path for output xml.
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}    ${sFileExtension}    ${sHTTPMethod}    ${sXMLAttributeName}    ${INDEX}

    ${Input_Value}    Run Keyword If    '${sHTTPMethod}'=='POST'    XML.Get Element Attribute    ${dataset_path}${sInputFilePath}.${sFileExtension}    ${sXMLAttributeName}    xpath=${XML_CreateUserSecurityProfile}
    ...    ELSE IF    '${sHTTPMethod}'=='PUT'    XML.Get Element Attribute    ${dataset_path}${sInputFilePath}.${sFileExtension}    ${sXMLAttributeName}    xpath=${XML_UpdateUserSecurityProfile}
    ...    ELSE    XML.Get Element Attribute    ${dataset_path}${sInputFilePath}.${sFileExtension}    ${sXMLAttributeName}    xpath=${XML_CreateUserSecurityProfile}

    ${Output_XML}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}_${INDEX}.${sFileExtension}

    Run Keyword And Continue On Failure    Should Contain    ${Output_XML}    ${sXMLAttributeName}='${Input_Value}'   
    ${IsExisting}    Run Keyword And Return Status    Should Contain    ${Output_XML}    ${sXMLAttributeName}='${Input_Value}'
    Run Keyword If    ${IsExisting}==${True}    Log    ${sXMLAttributeName} '${Input_Value}' is existing in the output XML: ${Output_XML}
    ...    ELSE IF    ${IsExisting}==${False}    Log    ${sXMLAttributeName} '${Input_Value}' is NOT existing in the output XML: ${Output_XML}

    
