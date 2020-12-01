*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Filter by Reference Name and Validate Text in Response Message
    [Documentation]    This keyword is used to search Header Reference and filter using Expected Reference Value.
    ...    Then go through the result row and validate if the key and value text is present in message text area
    ...    @author: clanding    30NOV2020    - initial create
    [Arguments]    ${sHeaderRefName}    ${sExpectedRefValue}    ${sTextToValidate}     ${bPresent}=${True}

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

    ${Results_Row_Count}    SeleniumLibraryExtended.Get Element Count    ${Results_Row}
    : FOR    ${Row_Index}    IN RANGE    1    ${Results_Row_Count}+1
    \    Double Click Element    ${Results_Row}\[${Row_Index}]${PerColumnValue}\[${ResultsHeaderColIndex}]${TextValue}
    \    Wait Until Browser Ready State
    \    Mx Scroll Element Into View    ${Textarea}
    \    ${FFC_RESPONSE}    Get Value   ${Textarea}
    \    Log    Message text area value is ${FFC_RESPONSE}
    \    Run Keyword If     ${bPresent}==${True}    Run Keyword    Run Keyword And Continue On Failure   Should Contain    ${FFC_RESPONSE}    ${sTextToValidate}
         ...    ELSE IF    ${bPresent}==${False}    Run Keyword And Continue On Failure   Should Not Contain    ${FFC_RESPONSE}    ${sTextToValidate}
    \    ${Row_Index}    Evaluate    ${Row_Index}+1
    \    Exit For Loop If    ${Row_Index}==${Results_Row_Count}+1
