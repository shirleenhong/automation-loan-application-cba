*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords *** 
Create Users in LoanIQ
    [Arguments]    ${sAdminUser}    ${sUserToCopy}    ${sPreferUserName}    ${sPassword}    ${sNumberOfUsers}
    [Documentation]    This keyword will create multiple users in LoanIQ
    ...    @author: mnanquilada    10APR2019    initial draft
    :FOR    ${INDEX}    IN RANGE    1    ${sNumberOfUsers}+1
    \    Run Keyword If    ${INDEX} < 10    Set Test Variable    ${INDEX}    0${INDEX}
    \    Login to Loan IQ   ${sAdminUser}    ${sPassword}
    \    Select Actions    [Actions];User Profile
    \    mx LoanIQ activate window    ${LIQ_User_Profile_Window}
    \    Verify Window    ${LIQ_User_Profile_Window}
    \    mx LoanIQ enter    ${LIQ_User_Profile_Textbox}     ${sUserToCopy}
    \    mx LoanIQ click    ${LIQ_User_Profile_Ok_Button}
    \    mx LoanIQ activate window    ${LIQ_User_Profile_Maintenance_Window}
    \    Verify Window    ${LIQ_User_Profile_Maintenance_Window}
    \    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_Save_As}
    \    mx LoanIQ activate window    ${LIQ_User_Profile_Maintenance_Save_As_Window}  
    \    Verify Window    ${LIQ_User_Profile_Maintenance_Save_As_Window}  
    \    mx LoanIQ enter    ${LIQ_User_Profile_Maintenance_Save_As_Textbox}     ${sPreferUserName}${INDEX}
    \    mx LoanIQ enter    ${LIQ_User_Profile_Maintenance_FirstName_Textbox}     ${sPreferUserName}${INDEX}
    \    mx LoanIQ enter    ${LIQ_User_Profile_Maintenance_LastName_Textbox}     ${sPreferUserName}${INDEX}
    \    mx LoanIQ click    ${LIQ_User_Profile_Maintenance_Save_As_Ok_Button}
    \    mx LoanIQ activate window    ${LIQ_User_Profile_Maintenance_Window}
    \    Verify Window    ${LIQ_User_Profile_Maintenance_Window}
    \    Mx LoanIQ Select Window Tab    ${LIQ_User_Profile_Maintenance_TabFolder}    Security Profile
    \    Mx LoanIQ Set    ${LIQ_User_Profile_Maintenance_Password_Never_Expires}    ON 
    \    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_File_Save}
    \    ${password}    Mx LoanIQ Get Data    ${LIQ_Password_Message_Window}    Password
    \    Log    ${password}
    \    mx LoanIQ click    ${LIQ_Information_OK_Button}
    \    ${password}    Fetch From Right    ${password}    set to
    \    ${password}    Fetch From Left    ${password}    . The user
    \    ${password}    Strip String    ${SPACE}${password}${SPACE}
    \    Log    Password of User is: ${password}
    \    Logout from Loan IQ
    \    Login to Loan IQ    ${sPreferUserName}${INDEX}    ${password}
    \    mx LoanIQ select    ${LIQ_Change_Password_Menu}
    \    mx LoanIQ activate window    ${LIQ_Change_Password_Window}
    \    Verify Window    ${LIQ_Change_Password_Window}
    \    mx LoanIQ enter    ${LIQ_Change_Password_Old_Pass_TextBox}     ${password}
    \    mx LoanIQ enter    ${LIQ_Change_Password_New_Pass_TextBox}     ${sPassword}
    \    mx LoanIQ enter    ${LIQ_Change_Password_Confirm_New_Pass_TextBox}     ${sPassword}
    \    mx LoanIQ click    ${LIQ_Change_Password_Ok_Button}
    \    ${status}    Run Keyword and Return Status    mx LoanIQ click    ${LIQ_Information_OK_Button}    
    \    Run Keyword If    '${status}'=='${False}'    Mx Native Type    {ENTER}
    \    Run Keyword If    '${status}'=='${False}'    Sleep    2s
    \    Run Keyword If    '${status}'=='${False}'    Mx Native Type    {ENTER}
    \    Run Keyword If    '${status}'=='${False}'    Sleep    2s
    \    Run Keyword If    '${status}'=='${False}'    Mx Native Type    {ENTER}
    \    Run Keyword If    '${status}'=='${True}'    mx LoanIQ click    ${LIQ_Information_OK_Button}
    \    Logout from Loan IQ  

Navigate to User Profile Notebook
    [Documentation]    This keyword navigates the LIQ User to the User Profile Notebook.
    ...    @author: rtarayao    15AUG2019    Initial Create
    [Arguments]    ${sUserID}    
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Active_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sUserID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}

Get User Processing Area Description and Code
    [Documentation]    This keyword returns both the processing area and processing code of the User.
    ...    @author: rtarayao    15AUG2019    Initial Create
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    ${ProcAreaDesc}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_ProcArea_StaticText}    text%LIQ_PROCAREA  
    Log    The User's processing area description is ${ProcAreaDesc}    
    mx LoanIQ click    ${LIQ_UserProfileMaint_ProcArea_Button}
    mx LoanIQ activate window    ${LIQ_ProcArea_Window}
    ${ProcAreaCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_ProcArea_JavaTree}    ${ProcAreaDesc}%Code%LIQ_PROCAREA_CODE
    Log    The User's processing area code is ${ProcAreaCode}
    mx LoanIQ click    ${LIQ_ProcArea_Cancel_Button}    
    [Return]    ${ProcAreaDesc}    ${ProcAreaCode}
    
Get User Branch Description and Code
    [Documentation]    This keyword returns both the processing area and processing code of the User.
    ...    @author: rtarayao    15AUG2019    Initial Create
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    ${BranchDesc}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_Branch_StaticText}    text%LIQ_BRANCH_DESC
    mx LoanIQ click    ${LIQ_UserProfileMaint_Branch_Button}
    mx LoanIQ activate window    ${LIQ_SelectBranch_Window}
    ${BranchCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_SelectBranch_JavaTree}    ${BranchDesc}%Code%LIQ_BRANCH_CODE
    Log    The User's processing area code is ${BranchCode}
    mx LoanIQ click    ${LIQ_SelectBranch_Cancel_Button}
    [Return]    ${BranchDesc}    ${BranchCode}


    
        
    
    
        
     
    
    
    
    
    
    
    
