*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Get First Name of a User
    [Documentation]    This keyword is used to search for user and get First Name value.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${Input_UserID}

    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${Input_UserID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ${Error_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${Error_Exist}==True    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Log    Fail    User does not exists.
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_SearchUser
    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${Input_UserID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LIQ_UserProfile
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${Input_UserID}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==True    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    ${LName_UI}  Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_LName_Textfield}    value%LName_UI
    ${FName_UI}  Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_FName_Textfield}    value%FName_UI
    
    mx LoanIQ close window    ${LIQ_UserProfileMaint_Window}
    [Return]    ${FName_UI}    ${LName_UI}