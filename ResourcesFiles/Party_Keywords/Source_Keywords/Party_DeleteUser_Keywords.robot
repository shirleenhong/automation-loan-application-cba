*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***

Delete User in Party Using LoginId
    [Documentation]    This keyword is used to delete single user in Party application
    ...    @author: dahijara    18SEP2019    - initial create
    ...    @update: rtarayao    21NOV2019    - removed close browser
    [Arguments]    ${sLoginID}
    
    Mx Input Text    ${Party_DeleteUser_UserId_TextBox}    ${sLoginID}
    Click Element    ${Party_DeleteUser_Search_Button}
    Wait Until Element Is Visible    ${Party_DeleteUser_TableRow}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${Party_DeleteUser_TableRow}   
    ${Count}    SeleniumLibraryExtended.Get Element Count    ${Party_DeleteUser_TableRow}
    
    @{CountList}    Create List
    :FOR    ${INDEX}    IN RANGE    1    ${Count}+1
    \    
    \    ${User_Table}    Get Text    ${Party_DeleteUser_Table}\[${INDEX}]${Party_DeleteUser_UserId_TableCol}
    \    
    \    Run Keyword And Continue On Failure    Should Be Equal    ${sLoginID}    ${User_Table}    
    \    
    \    ${USER_MATCH}    Run Keyword And Return Status    Should Be Equal    ${sLoginID}    ${User_Table}
    \    Run Keyword If    ${USER_MATCH}==${True}    Log    Users Matched! ${sLoginID} = ${User_Table}
         ...    ELSE    Log    Users are not Matched! ${sLoginID} != ${User_Table}    level=ERROR
    \    
    \    Click Element    ${Party_DeleteUser_Table}\[${INDEX}]${Party_DeleteUser_CheckBox_TableCol}
    \    
    \    Take Screenshot    Party_DeleteUserPage
    \    Run Keyword If    ${INDEX}>${Count}+1 and ${USER_MATCH}==${False}    Log    No Users Matched on the table!!
    \    Exit For Loop If    ${INDEX}==${Count}+1  
    
    Click Element    ${Party_DeleteUser_Next_Button}
    Wait Until Element Is Visible    ${Party_DeleteUser_Warning_Dialog}
    
    ${Warning_Messages}    SeleniumLibraryExtended.Get Element Attribute    ${Party_DeleteUser_Warning_Dialog}${Party_DeleteUser_WarningDialog_Message}    value    
    Run Keyword And Continue On Failure    Should Contain    ${Warning_Messages}    ${sLoginID}
    
    ${isMatched}    Run Keyword And Return Status    Should Contain    ${Warning_Messages}    ${sLoginID}
    Run Keyword If    ${isMatched}==${True}    Log    User ${sLoginID} exists in the list of user to be deleted! Warning Message: ${Warning_Messages}
    ...    ELSE    Log    User ${sLoginID} does not exist in the list of user to be deleted! Warning Message: ${Warning_Messages}    level=ERROR    

    Take Screenshot    Party_DeleteUserPage_WarningMessage
    Click Element    ${Party_DeleteUser_WarningDialog_Proceed_Button}
    
    Wait Until Element Is Visible    ${Party_DeleteUser_Status_Form}
    Wait Until Element Is Visible    ${Party_DeleteUser_Status_Form}${Party_DeleteUser_Status_Message}
    ${val_StatusMessage}    SeleniumLibraryExtended.Get Element Attribute    ${Party_DeleteUser_Status_Form}${Party_DeleteUser_Status_Message}    value

    Run Keyword And Continue On Failure    Should Be Equal    ${val_StatusMessage}    ${Party_UserDeletedSuccessfully}
    
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${val_StatusMessage}    ${Party_UserDeletedSuccessfully}
    Run Keyword If    ${isMatched}==${True}    Log    User is deleted successfully.
    ...    ELSE    Log    User is deleted successfully.    level=ERROR
    
    Take Screenshot    Party_DeleteUserPage_DeleteStatus
