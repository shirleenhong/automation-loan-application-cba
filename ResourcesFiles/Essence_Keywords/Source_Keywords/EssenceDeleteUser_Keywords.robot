*** Settings ***
Resource       ../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Delete User in Essence Using LoginId
    [Documentation]    This keyword is used to delete single user in Essence application
    ...    @author: dahijara    18SEP2019    - initial create
    ...    @update: rtarayao    21NOV2019    - removed close browser
    [Arguments]    ${sLoginID}
    
    Mx Input Text    ${Essence_DeleteUser_UserId_TextBox}    ${sLoginID}
    Click Element    ${Essence_DeleteUser_Search_Button}
    Wait Until Element Is Visible    ${Essence_DeleteUser_TableRow}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${Essence_DeleteUser_TableRow}   
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Essence_DeleteUser_TableRow}
    
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count}+1
    \    
    \    ${User_Table}    Get Text    ${Essence_DeleteUser_Table}\[${INDEX}]${Essence_DeleteUser_UserId_TableCol}
    \    
    \    Run Keyword And Continue On Failure    Should Be Equal    ${sLoginID}    ${User_Table}    
    \    
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sLoginID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==${True}    Log    Users Matched! ${sLoginID} = ${User_Table}
         ...    ELSE    Log    Users are not Matched! ${sLoginID} != ${User_Table}    level=ERROR
    \    
    \    Click Element    ${Essence_DeleteUser_Table}\[${INDEX}]${Essence_DeleteUser_CheckBox_TableCol}
    \    
    \    Take Screenshot    Essence_DeleteUserPage
    \    Run Keyword If    ${INDEX}>${Count}+1 and ${USER_MATCH}==${False}    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${INDEX}==${Count}+1  
    
    Click Element    ${Essence_DeleteUser_Next_Button}
    Wait Until Element Is Visible    ${Essence_DeleteUser_Warning_Dialog}
    Wait Until Element Is Visible    ${Essence_DeleteUser_Warning_Dialog}${Essence_DeleteUser_WarningDialog_Message}
    ${Warning_Messages}    SeleniumLibraryExtended.Get Element Attribute    ${Essence_DeleteUser_Warning_Dialog}${Essence_DeleteUser_WarningDialog_Message}    value    
    Run Keyword And Continue On Failure    Should Contain    ${Warning_Messages}    ${sLoginID}
    
    ${isMatched}    Run Keyword And Return Status    Should Contain    ${Warning_Messages}    ${sLoginID}
    Run Keyword If    ${isMatched}==${True}    Log    User ${sLoginID} exists in the list of user to be deleted! Warning Message: ${Warning_Messages}
    ...    ELSE    Log    User ${sLoginID} does not exist in the list of user to be deleted! Warning Message: ${Warning_Messages}    level=ERROR    

    Take Screenshot    Essence_DeleteUserPage_WarningMessage
    Click Element    ${Essence_DeleteUser_WarningDialog_Proceed_Button}
    
    Wait Until Element Is Visible    ${Essence_DeleteUser_Status_Form}
    Wait Until Element Is Visible    ${Essence_DeleteUser_Status_Form}${Essence_DeleteUser_Status_Message}
    ${val_StatusMessage}    SeleniumLibraryExtended.Get Element Attribute    ${Essence_DeleteUser_Status_Form}${Essence_DeleteUser_Status_Message}    value

    Run Keyword And Continue On Failure    Should Be Equal    ${val_StatusMessage}    ${Essence_UserDeletedSuccessfully}
    
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${val_StatusMessage}    ${Essence_UserDeletedSuccessfully}
    Run Keyword If    ${isMatched}==${True}    Log    User is deleted successfully.
    ...    ELSE    Log    User is deleted successfully.    level=ERROR
    
    Take Screenshot    Essence_DeleteUserPage_DeleteStatus