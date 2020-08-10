*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot


*** Keywords ***

Get Line of Business Value and Validate User in LIQ
    [Documentation]    This keyword is used to get Line of Business value from dataset and if COMRLENDING, proceed with LIQ validation.
    ...    @author: clanding    08APR2019    - initial create
    ...    @update: clanding    22APR2019    - update keyword name for Validate LoanIQ for Users Post Success
    ...    @update: clanding    07MAY2019    - added handling when inputs are multiple LOB
    [Arguments]    ${sRoles}    ${s2Code_CountryCode}    ${sLOB_From_Excel}    ${sLocale}    ${sDefaultBusinessEntity}
    ...    ${sJobTitle}    ${sAddDept}    ${sPrimDept}    ${sAddProcArea}    ${sDefProcArea}    ${sLocation}    ${sStatus}
    ...    ${sProfileID}    ${sFName}    ${sLName}    ${sEmail}    ${sLoginID}    ${iContactNum1}    ${sUserLockStatus}
    
    ${LOB_List}    Split String    ${sLOB_From_Excel}    ,
    ${LOB_Count}    Get Length    ${LOB_List}
    :FOR    ${Index}    IN RANGE    ${LOB_Count}
    \    ${LOB_Value}    Get From List    ${LOB_List}    ${Index}
    \    
    \    ${LIQ_JobFunctionList}    Split String    ${sRoles}    ,
    \    ${JobFunction_LIQ}    Get From List    ${LIQ_JobFunctionList}    ${Index}
    \    
    \    ${ProfileID_List}    Split String    ${sProfileID}    ,
    \    ${sProfileID_LIQ}    Get From List    ${ProfileID_List}    ${Index}
    \    
    \    ${DefaultBusinessEntity_List}    Split String    ${sDefaultBusinessEntity}    ,
    \    ${DefaultBusinessEntity_LIQ}    Get From List    ${DefaultBusinessEntity_List}    ${Index}
    \    
    \    ${AddDept_List}    Split String    ${sAddDept}    ,
    \    ${AddDept_LIQ}    Get From List    ${AddDept_List}    ${Index}
    \    
    \    ${PrimDept_List}    Split String    ${sPrimDept}    ,
    \    ${PrimDept_LIQ}    Get From List    ${PrimDept_List}    ${Index}
    \    
    \    ${AddProcArea_List}    Split String    ${sAddProcArea}    ,
    \    ${AddProcArea_LIQ}    Get From List    ${AddProcArea_List}    ${Index}
    \    
    \    ${DefProcArea_List}    Split String    ${sDefProcArea}    ,
    \    ${DefProcArea_LIQ}    Get From List    ${DefProcArea_List}    ${Index}
    \    
    \    ${Location_List}    Split String    ${sLocation}    ,
    \    ${Location_LIQ}    Get From List    ${Location_List}    ${Index}
    \    
    \    ${Status_List}    Split String    ${sStatus}    ,
    \    ${Status_LIQ}    Get From List    ${Status_List}    ${Index}
    \    
    \    ${UserLockStatus_List}    Split String    ${sUserLockStatus}    ,
    \    ${UserLockStatus_LIQ}    Get From List    ${UserLockStatus_List}    ${Index}
    \    
    \    Run Keyword If    '${LOB_Value}'=='COMRLENDING'    Validate LoanIQ for Users Post Success    ${JobFunction_LIQ}
         ...    ${s2Code_CountryCode}    ${sLocale}    ${DefaultBusinessEntity_LIQ}    ${sJobTitle}    ${AddDept_LIQ}    ${PrimDept_LIQ}
         ...    ${AddProcArea_LIQ}    ${DefProcArea_LIQ}    ${Location_LIQ}    ${Status_LIQ}    ${sProfileID_LIQ}    ${sFName}    ${sLName}    ${sEmail}
         ...    ${sLoginID}    ${iContactNum1}    ${UserLockStatus_LIQ}    ${Index}
    \
    \    Exit For Loop If    '${Index}'=='${LOB_Count}'

Validate LoanIQ for Users Post Success
    [Documentation]    This keyword is used to validate Users in LoanIQ for post success.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - changed userID to profileId, changed osUserId to loginId
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    22APR2019    - update variable name fo sCountryCode_2Code
    ...    @update: clanding    25APR2019    - updating argument to ${sJobFunctionVal} and removing getting of job function code in the config
    ...    @update: clanding    26APR2019    - add screenshot
    ...    @update: amansuet    09SEP2019    - added condition to skip branch validation if defaultBusinessEntity count contains only 1
    [Arguments]    ${sJobFunctionVal}    ${sCountryCode_2Code}    ${sLocale}    ${sDefaultBusinessEntity}    ${sJobTitle}
    ...    ${sAddDept}    ${sPrimDept}    ${sAddProcArea}    ${sDefProcArea}    ${sLocation}    ${sStatus}    ${sProfileID}
    ...    ${sFName}    ${sLName}    ${sEmail}    ${sLoginID}    ${iContactNum1}    ${sUserLockStatus}    ${Index_COMRLENDING}
    
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}

    Search in Table Maintenance    Country
    ${LIQ_CountryCode_Desc}    Get Single Description from Table Maintanance    ${sCountryCode_2Code}    ${LIQ_Country_Window}
    ...    ${LIQ_Country_Tree}    ${LIQ_Country_ShowALL_RadioButton}    ${LIQ_Country_Exit_Button}

    Search in Table Maintenance    Language
    ${locale}    Run Keyword If    '${sLocale}'=='no tag' or '${sLocale}'=='null'    Set Variable    en
    ...    ELSE    Set Variable    ${sLocale}
    ${LIQ_Language_Desc}    Get Single Description from Table Maintanance    ${locale}    ${LIQ_Language_Window}
    ...    ${LIQ_Language_Tree}    ${LIQ_Language_ShowALL_RadioButton}    ${LIQ_Language_Exit_Button}

    ${defaultBusinessEntity_List}    Split String    ${sDefaultBusinessEntity}    ,
    ${defaultBusinessEntity_ValList_0}    Get From List    ${defaultBusinessEntity_List}    ${Index_COMRLENDING}
    ${defaultBusinessEntity_ValList}    Split String    ${defaultBusinessEntity_ValList_0}    |
    ${defaultBusinessEntity_Count}    Get Length    ${defaultBusinessEntity_ValList}
    ${defaultBranch_val}    Run Keyword If    '${defaultBusinessEntity_Count}'>'1'    Get From List    ${defaultBusinessEntity_ValList}    1
    ...    ELSE    Set Variable    ${NONE}
    
    Run Keyword If    '${defaultBranch_val}'!='${NONE}'    Search in Table Maintenance    Branch
    ${LIQ_Branch_Desc}    Run Keyword If    '${defaultBranch_val}'!='${NONE}'    Get Single Description from Table Maintanance    ${defaultBranch_val}    ${LIQ_Branch_Window}
    ...    ${LIQ_Branch_Tree}    ${LIQ_Branch_ShowALL_RadioButton}    ${LIQ_Branch_Exit_Button}

    Search in Table Maintenance    Title
    ${LIQ_Title_Desc}    Get Single Description from Table Maintanance    ${sJobTitle}    ${LIQ_Title_Window}
    ...    ${LIQ_Title_Tree}    ${LIQ_Title_ShowALL_RadioButton}    ${LIQ_Title_Exit_Button}

    Search in Table Maintenance    Job Function
    ${LIQ_JobFunction_Desc}    Get Single Description from Table Maintanance    ${sJobFunctionVal}    ${LIQ_JobFunction_Window}
    ...    ${LIQ_JobFunction_Tree}    ${LIQ_JobFunction_ShowAllRadioButton}    ${LIQ_JobFunction_Exit_Button}

    Search in Table Maintenance    Department
    ${LIQ_DeptDescList}    ${PrimDept_Desc}    Get Multiple Description from Table Maintenance    ${sAddDept}    ${sPrimDept}
    ...    ${LIQ_Department_Window}    ${LIQ_Department_Tree}    ${LIQ_Department_ShowAllRadioButton}    ${LIQ_Department_Exit_Button}    ${Index_COMRLENDING}

    Search in Table Maintenance    Processing Area
    ${LIQ_addProc_Desc}    ${LIQ_defProc_Desc}    Get Multiple Description from Table Maintenance    ${sAddProcArea}    ${sDefProcArea}
    ...    ${LIQ_Processing_Area_Window}    ${LIQ_Processing_Area_Tree}    ${LIQ_Processing_Area_ShowAllRadioButton}    ${LIQ_Processing_Area_Exit_Button}    ${Index_COMRLENDING}

    ${location_List}    Split String    ${sLocation}    ,
    ${location_Val}    Get From List    ${location_List}    ${Index_COMRLENDING}
    Search in Table Maintenance    Location
    ${LIQ_Loc_Desc}    Get Single Description from Table Maintanance    ${location_Val}    ${LIQ_Location_Window}    ${LIQ_Location_Tree}    ${LIQ_Location_ShowAllRadioButton}    ${LIQ_Location_Exit_Button}

    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}
    
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
        Run Keyword If    '${sStatus}'=='INACTIVE'    Run Keywords    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    ...    AND    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Active_Checkbox}    OFF
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ${Error_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${Error_Exist}==True    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Log    Fail    User does not exists.

    ${Input_UserID}    Convert To Uppercase    ${sProfileID}
    ${Input_FName}    Convert To Uppercase    ${sFName}
    ${Input_LName}    Convert To Uppercase    ${sLName}
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
    Take Screenshot    LIQ_SearchUser
    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${Input_UserID}\t${LIQ_JobFunction_Desc}\t${Input_LName},${SPACE}${Input_FName}${SPACE}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    Take Screenshot    LIQ_UserProfile
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${Input_UserID}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==True    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    Validate Loan IQ Details    ${Input_FName}    ${LIQ_UserProfileMaint_FName_Textfield}
    Validate Loan IQ Details    ${Input_LName}    ${LIQ_UserProfileMaint_LName_Textfield}
    Validate Loan IQ Details    ${sEmail}    ${LIQ_UserProfileMaint_Email_Textfield}

    ${Country_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_CountryCode_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Country_Locator}    VerificationData="Yes"
    ${country_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Country_Locator}    VerificationData="Yes"
    Run Keyword If    ${country_stat}==True    Log    Country is correct!!
    ...    ELSE    Log    Country is incorrect!!    level=ERROR

    ${Language_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_Language_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Language_Locator}    VerificationData="Yes"
    ${language_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Language_Locator}    VerificationData="Yes"
    Run Keyword If    ${language_stat}==True    Log    Language is correct!!
    ...    ELSE    Log    Language is incorrect!!    level=ERROR

    ${Branch_Locator}    Run Keyword If    '${defaultBranch_val}'!='${NONE}'    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_Branch_Desc}
    Run Keyword If    '${defaultBranch_val}'!='${NONE}'    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Branch_Locator}    VerificationData="Yes"
    ${branch_stat}    Run Keyword If    '${defaultBranch_val}'!='${NONE}'    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Branch_Locator}    VerificationData="Yes"
    Run Keyword If    ${branch_stat}==True    Log    Branch is correct!!
    ...    ELSE IF    '${defaultBranch_val}'=='${NONE}'    Log    No Branch Validation Required for Get User API!!
    ...    ELSE    Log    Branch is incorrect!!    level=ERROR

    ${Title_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_Title_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Title_Locator}    VerificationData="Yes"
    ${title_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Title_Locator}    VerificationData="Yes"
    Run Keyword If    ${title_stat}==True    Log    Title is correct!!
    ...    ELSE    Log    Title is incorrect!!    level=ERROR

    ${JobFunction_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_JobFunction_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${JobFunction_Locator}    VerificationData="Yes"
    ${jobfunction_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${JobFunction_Locator}    VerificationData="Yes"
    Run Keyword If    ${jobfunction_stat}==True    Log    Job Function is correct!!
    ...    ELSE    Log    Job Function is incorrect!!    level=ERROR

    ${Location_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_Loc_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    ${location_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    Run Keyword If    ${location_stat}==True    Log    Location is correct!!
    ...    ELSE    Log    Location is incorrect!!    level=ERROR

    ${ProcArea_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_defProc_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${ProcArea_Locator}    VerificationData="Yes"
    ${procarea_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${ProcArea_Locator}    VerificationData="Yes"
    Run Keyword If    ${procarea_stat}==True    Log    Processing Area is correct!!
    ...    ELSE    Log    Processing Area is incorrect!!    level=ERROR

    ##add secondary processing area validation here - TACOE-624
    # Mx Click    ${LIQ_UserProfileMaint_SecProcArea_Button}

    # Mx Click    ${LIQ_SecArea_Cancel_Button}
    ${primaryDepartment_List}    Split String    ${sPrimDept}    ,
    ${primaryDepartment}    Get From List    ${primaryDepartment_List}    ${Index_COMRLENDING}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${primaryDepartment}\t${PrimDept_Desc}\tYes
    ${primdept_stat}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${primaryDepartment}\t${PrimDept_Desc}\tYes
    Run Keyword If    ${primdept_stat}==True    Log    Primary Department is correct!! '${primaryDepartment}\t${PrimDept_Desc}\tYes'
    ...    ELSE    Log    Primary Department is incorrect!! '${primaryDepartment}\t${PrimDept_Desc}\tYes'    level=ERROR
    
    ### DEPARTMENT SELECTION LIST POP UP WINDOW ###
    ##check if not Primary Indicator --value should be blank or NO.
    ${additionalDepartments_List}    Split String    ${sAddDept}    ,
    ${additionalDepartmentsVal}    Get From List    ${additionalDepartments_List}    ${Index_COMRLENDING}
    ${additionalDepartmentsVal_List}    Split String    ${additionalDepartmentsVal}    /
    ${dept_count}    Get Length    ${LIQ_DeptDescList}
    ${INDEX}    Set Variable    0
    :FOR    ${INDEX}    IN RANGE    ${dept_count}
    \    ${depcode_val}    Get From List    ${additionalDepartmentsVal_List}    ${INDEX}
    \    ${depdesc_val}    Get From List    ${LIQ_DeptDescList}    ${INDEX}
    \    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${depcode_val}\t${depdesc_val}\t
    \    ${dept_stat}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${depcode_val}\t${depdesc_val}\t
    \    Run Keyword If    ${dept_stat}==True    Log    Department is correct!! '${depcode_val}\t${depdesc_val}\t'
         ...    ELSE    Log    Department is incorrect!! '${depcode_val}\t${depdesc_val}\t'    level=ERROR
    \    Exit For Loop If    '${INDEX}'=='${dept_count}'
    
    ### USER STATUS POP UP WINDOW ###
    mx LoanIQ select    ${LIQ_Options_ChangeStatus}
    mx LoanIQ activate window    ${LIQ_UserStatus_Dialog}
    Take Screenshot    LIQ_UserProfile_Status
    ${status_List}    Split String    ${sStatus}    ,
    ${status_Val}    Get From List    ${status_List}    ${Index_COMRLENDING}
    ${LIQ_Status}    Run Keyword If    '${status_Val}'=='ACTIVE'    Set Variable    Active
    ...    ELSE IF    '${status_Val}'=='INACTIVE'    Set Variable    Inactive
    
    ##value 1 is equivalent to "ON", value 0 is for "OFF"
    ${Status_Locator}    Set Variable    JavaWindow("title:=User Status.*").JavaRadioButton("attached text:=${LIQ_Status}","value:=1")
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Status_Locator}    VerificationData="Yes"
    ${stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Status_Locator}    VerificationData="Yes"
    Run Keyword If    ${stat}==True    Log    Correct!! User status is '${LIQ_Status}'.
    ...    ELSE    Log    Incorrect!! User status is NOT '${LIQ_Status}'.    level=ERROR

    mx LoanIQ click    ${LIQ_UserStatus_Cancel_Button}
    
    ### PHONE/FAX POP UP WINDOW ###
    mx LoanIQ click    ${LIQ_UserProfileMaint_PhoneFax_Button}
    mx LoanIQ activate window    ${LIQ_PhoneFax_Window}
    Take Screenshot    LIQ_UserProfile_PhoneEmail
    Validate Loan IQ Details    ${iContactNum1}    ${LIQ_PhoneFax_PhoneNum1_Textfield}
    mx LoanIQ click    ${LIQ_PhoneFax_Cancel_Button}

    ##transform input, value 1 is equivalent to "CHECKED", value 0 is for "UNCHECKED"
    ${userLockStatus_List}    Split String    ${sUserLockStatus}    ,
    ${userLockStatus_Val}    Get From List    ${userLockStatus_List}    ${Index_COMRLENDING}
    ${UserLockedStatus}    Run Keyword If    '${userLockStatus_Val}'=='' or '${userLockStatus_Val}'=='UNLOCKED'   Set Variable    JavaWindow("title:=User Profile Maintenance.*").JavaCheckBox("attached text:=User Locked","value:=0")
    ...    ELSE IF    '${userLockStatus_Val}'=='LOCKED'    Set Variable    JavaWindow("title:=User Profile Maintenance.*").JavaCheckBox("attached text:=User Locked","value:=1")
    
    ###SECURITY PROFILE TAB ###
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Security Profile
    Take Screenshot    LIQ_UserProfile_SecurityProfile
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserLockedStatus}    VerificationData="Yes"
    ${stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserLockedStatus}    VerificationData="Yes"
    Run Keyword If    ${stat}==True    Log    User Locked is correct.
    ...    ELSE    Log    User Locked is incorrect.    level=ERROR
    ${Input_LoginID}    Convert To Uppercase    ${sLoginID}
    Validate Loan IQ Details    ${Input_LoginID}    ${LIQ_UserProfileMaint_Tab_UserLoginID}

    Close All Windows on LIQ

Get LoanIQ Data Before Any Transaction
    [Documentation]    This keyword is used to validate Users details in LoanIQ before performing any transactions and saving its values.
    ...    Pre-requisite: User must be existing in LoanIQ.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - changed userID to profileId, changed osUserId to loginId
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: dahijara    26AUG2019    - change hard coded boolean values to variables
    [Arguments]    ${sProfileID}

    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ###check for error message
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${Err_exist}==${True}    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Fail    User does not exists.

    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
    ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sProfileID}    60
    Run Keyword If    ${UserList_exist}==${False}    Fail    User '${sProfileID}' does not exist!!
    ...    ELSE    Log    User '${sProfileID}' exists.
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}

    ${input_userid}    Convert To Uppercase    ${sProfileID}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${input_userid}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    ${GLOBAL_LIQ_USERID}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_UserID_StaticText}    text%GLOBAL_LIQ_USERID
    ${GLOBAL_LIQ_FNAME}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_FName_Textfield}    input=GLOBAL_LIQ_FNAME
    ${GLOBAL_LIQ_LNAME}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_LName_Textfield}    input=GLOBAL_LIQ_LNAME
    ${GLOBAL_LIQ_BRANCH}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_Branch_StaticText}    text%GLOBAL_LIQ_BRANCH
    ${GLOBAL_LIQ_JOBFUNCTION}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_JobFunc_StaticText}    text%GLOBAL_LIQ_JOBFUNCTION
    ${GLOBAL_LIQ_TITLE}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_Title_StaticText}    text%GLOBAL_LIQ_TITLE
    ${GLOBAL_LIQ_COUNTRY}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_Country_StaticText}    text%GLOBAL_LIQ_COUNTRY
    ${GLOBAL_LIQ_LANGUAGE}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_Language_StaticText}    text%GLOBAL_LIQ_LANGUAGE
    ${GLOBAL_LIQ_LOCATION}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_Loc_StaticText}    text%GLOBAL_LIQ_LOCATION
    ${GLOBAL_LIQ_PROCAREA}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_ProcArea_StaticText}    text%GLOBAL_LIQ_PROCAREA

    ${GLOBAL_LIQ_EMAIL}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_Email_Textfield}    input=GLOBAL_LIQ_EMAIL
    ${GLOBAL_LIQ_DEPTCODE}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UserProfileMaint_Dept_Tree}    Yes%Code%GLOBAL_LIQ_DEPTCODE
    ${GLOBAL_LIQ_ADDDEPTCODE}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UserProfileMaint_Dept_Tree}    Yes%Code%GLOBAL_LIQ_ADDDEPTCODE

    ${GLOBAL_LIQ_ADDDEPTCODE}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_UserProfileMaint_Dept_Tree}    Yes%Code%GLOBAL_LIQ_ADDDEPTCODE

    mx LoanIQ select    ${LIQ_Options_ChangeStatus}
    mx LoanIQ activate window    ${LIQ_UserStatus_Dialog}
    ${GLOBAL_LIQ_STATUS}    Mx LoanIQ Get Data    ${LIQ_UserStatus_RadioButton_On}    attached text%GLOBAL_LIQ_STATUS

    mx LoanIQ click    ${LIQ_UserStatus_Cancel_Button}
    mx LoanIQ click    ${LIQ_UserProfileMaint_PhoneFax_Button}
    mx LoanIQ activate window    ${LIQ_PhoneFax_Window}
    ${GLOBAL_LIQ_PHONENUM1}    Mx LoanIQ Get Data    ${LIQ_PhoneFax_PhoneNum1_Textfield}    input=GLOBAL_LIQ_PHONENUM1
    mx LoanIQ click    ${LIQ_PhoneFax_Cancel_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Security Profile
    ${GLOBAL_LIQ_USERLOGINID}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_Tab_UserLoginID}    text%GLOBAL_LIQ_USERLOGINID
    ${UserLockedVal}    Mx LoanIQ Get Data    ${LIQ_UserProfileMaint_Tab_UserLocked}    value%UserLockedVal
    ${GLOBAL_LIQ_USERLOCKSTATUS}    Run Keyword If    '${UserLockedVal}'=='0'    Set Variable    UNLOCKED
    ...    ELSE IF    '${UserLockedVal}'=='1'    Set Variable    LOCKED

    ### set data to global
    Set Global Variable    ${GLOBAL_LIQ_USERID}
    Set Global Variable    ${GLOBAL_LIQ_FNAME}
    Set Global Variable    ${GLOBAL_LIQ_LNAME}
    Set Global Variable    ${GLOBAL_LIQ_BRANCH}
    Set Global Variable    ${GLOBAL_LIQ_JOBFUNCTION}
    Set Global Variable    ${GLOBAL_LIQ_TITLE}
    Set Global Variable    ${GLOBAL_LIQ_COUNTRY}
    Set Global Variable    ${GLOBAL_LIQ_LANGUAGE}
    Set Global Variable    ${GLOBAL_LIQ_LOCATION}
    Set Global Variable    ${GLOBAL_LIQ_PROCAREA}
    Set Global Variable    ${GLOBAL_LIQ_EMAIL}
    Set Global Variable    ${GLOBAL_LIQ_STATUS}
    Set Global Variable    ${GLOBAL_LIQ_PHONENUM1}
    Set Global Variable    ${GLOBAL_LIQ_DEPTCODE}
    Set Global Variable    ${GLOBAL_LIQ_USERLOGINID}
    Set Global Variable    ${GLOBAL_LIQ_USERLOCKSTATUS}
    Set Global Variable    ${GLOBAL_LIQ_ADDDEPTCODE}

    Close All Windows on LIQ

Compare Input Data with LoanIQ Details
    [Documentation]    This keyword is used to compare LoanIQ data from Input data.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - changed userID to profileId, changed osUserId to loginId
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    29APR2019    - updating argument to ${LIQ_JobFunctionVal} and removing getting of job function code in the config
    ...    @update: dahijara    23AUG2019    - Added logic to get COMRLENDING status for multiple LOBs.
    ...    @update: dahijara    26AUG2019    - changed hard coded boolean values to variables
    
    [Arguments]    ${sInputFilePath}    ${sCountryCode_2Code}    ${sJobFunctionVal}    ${sLocale}    ${sDefBusinessEntity}    ${sJobTitle}
    ...    ${sAddDept}    ${sPrimDept}    ${sAddProcArea}    ${sDefProcArea}    ${sLocation}    ${sProfileID}    ${sFName}
    ...    ${sLName}    ${sEmail}    ${iContactNum1}    ${sStatus}    ${sLoginID}    ${sUserLockStatus}
    ...    ${Index_COMRLENDING}

    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    mx LoanIQ activate window    ${LIQ_TableMaintenance_Window}

    Search in Table Maintenance    Country
    ${LIQ_CountryCode_Desc}    Get Single Description from Table Maintanance    ${sCountryCode_2Code}    ${LIQ_Country_Window}
    ...    ${LIQ_Country_Tree}    ${LIQ_Country_ShowALL_RadioButton}    ${LIQ_Country_Exit_Button}

    Search in Table Maintenance    Language
    ${locale}    Run Keyword If    '${sLocale}'=='no tag' or '${sLocale}'=='null' or '${sLocale}'==''    Set Variable    en
    ...    ELSE    Set Variable    ${sLocale}
    ${LIQ_Language_Desc}    Get Single Description from Table Maintanance    ${locale}    ${LIQ_Language_Window}
    ...    ${LIQ_Language_Tree}    ${LIQ_Language_ShowALL_RadioButton}    ${LIQ_Language_Exit_Button}

    ${defaultBusinessEntity_List}    Split String    ${sDefBusinessEntity}    ,
    ${defaultBusinessEntity_ValList_0}    Get From List    ${defaultBusinessEntity_List}    ${Index_COMRLENDING}
    ${defaultBusinessEntity_ValList}    Split String    ${defaultBusinessEntity_ValList_0}    |
    ${defaultBranch_val}    Get From List    ${defaultBusinessEntity_ValList}    1
    Search in Table Maintenance    Branch
    ${LIQ_Branch_Desc}    Get Single Description from Table Maintanance    ${defaultBranch_val}    ${LIQ_Branch_Window}
    ...    ${LIQ_Branch_Tree}    ${LIQ_Branch_ShowALL_RadioButton}    ${LIQ_Branch_Exit_Button}

    Search in Table Maintenance    Title
    ${LIQ_Title_Desc}    Get Single Description from Table Maintanance    ${sJobTitle}    ${LIQ_Title_Window}
    ...    ${LIQ_Title_Tree}    ${LIQ_Title_ShowALL_RadioButton}    ${LIQ_Title_Exit_Button}

    Search in Table Maintenance    Job Function
    ##get Job Function code from config setup using 'role' value from json
    ${LIQ_JobFunction_Desc}    Get Single Description from Table Maintanance    ${sJobFunctionVal}    ${LIQ_JobFunction_Window}
    ...    ${LIQ_JobFunction_Tree}    ${LIQ_JobFunction_ShowAllRadioButton}    ${LIQ_JobFunction_Exit_Button}

    Search in Table Maintenance    Department
    ${LIQ_DeptDescList}    ${PrimDept_Desc}    Get Multiple Description from Table Maintenance    ${sAddDept}    ${sPrimDept}    ${LIQ_Department_Window}
    ...    ${LIQ_Department_Tree}    ${LIQ_Department_ShowAllRadioButton}    ${LIQ_Department_Exit_Button}    ${Index_COMRLENDING}

    Search in Table Maintenance    Processing Area
    ${LIQ_addProc_Desc}    ${LIQ_defProc_Desc}    Get Multiple Description from Table Maintenance    ${sAddProcArea}    ${sDefProcArea}    ${LIQ_Processing_Area_Window}
    ...    ${LIQ_Processing_Area_Tree}    ${LIQ_Processing_Area_ShowAllRadioButton}    ${LIQ_Processing_Area_Exit_Button}    ${Index_COMRLENDING}

    ${location_List}    Split String    ${sLocation}    ,
    ${location_Val}    Get From List    ${location_List}    ${Index_COMRLENDING}
    Search in Table Maintenance    Location
    ${LIQ_Loc_Desc}    Get Single Description from Table Maintanance    ${location_Val}    ${LIQ_Location_Window}    ${LIQ_Location_Tree}    ${LIQ_Location_ShowAllRadioButton}    ${LIQ_Location_Exit_Button}

    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}
    
    ${profileId_List}    Split String    ${sProfileID}    ,
    ${sProfileID}    Get From List    ${profileId_List}    ${Index_COMRLENDING}
    
    ${input_UserID}    Convert To Uppercase    ${sProfileID}
    ${input_FName}    Convert To Uppercase    ${sFName}
    ${input_LName}    Convert To Uppercase    ${sLName}
    ${NOCHANGE_LIQ_USERID}    Run Keyword And Return Status    Should Be Equal As Strings    ${input_UserID}    ${GLOBAL_LIQ_USERID}
    ${NOCHANGE_LIQ_TITLECODE}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_Title_Desc}    ${GLOBAL_LIQ_TITLE}
    ${NOCHANGE_LIQ_FNAME}    Run Keyword And Return Status    Should Be Equal As Strings    ${input_FName}    ${GLOBAL_LIQ_FNAME}
    ${NOCHANGE_LIQ_LNAME}    Run Keyword And Return Status    Should Be Equal As Strings    ${input_LName}    ${GLOBAL_LIQ_LNAME}
    ${NOCHANGE_LIQ_COUNTRYCODE}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_CountryCode_Desc}    ${GLOBAL_LIQ_COUNTRY}
    ${NOCHANGE_LIQ_EMAIL}    Run Keyword And Return Status    Should Be Equal As Strings    ${sEmail}    ${GLOBAL_LIQ_EMAIL}
    ${NOCHANGE_LIQ_BRANCH}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_Branch_Desc}    ${GLOBAL_LIQ_BRANCH}
    ${NOCHANGE_LIQ_CONTACTNUM1}    Run Keyword And Return Status    Should Be Equal As Strings    ${iContactNum1}    ${GLOBAL_LIQ_PHONENUM1}
    ${NOCHANGE_LIQ_JOBFUNTION}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_JobFunction_Desc}    ${GLOBAL_LIQ_JOBFUNCTION}
    ${Language_Empty}    Run Keyword And Return Status    Should Be Empty    ${LIQ_Language_Desc}
    ${LIQ_Language_Desc}    Run Keyword If    ${Language_Empty}==${True}    Set Variable    ${GLOBAL_LIQ_LANGUAGE}
    ...    ELSE    Set Variable    ${LIQ_Language_Desc}
    ${NOCHANGE_LIQ_LANGUAGE}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_Language_Desc}    ${GLOBAL_LIQ_LANGUAGE}
    ${primdeptCode_list}    Split String    ${sPrimDept}    ,
    ${input_primdeptcode}    Get From List    ${primdeptCode_list}    ${Index_COMRLENDING}
    ${NOCHANGE_LIQ_PRIMDEPT}    Run Keyword And Return Status    Should Be Equal As Strings    ${input_primdeptcode}    ${GLOBAL_LIQ_DEPTCODE}
    ${adddeptCode_list}    Split String    ${sAddDept}    ,
    ${input_adddeptcode}    Get From List    ${adddeptCode_list}    ${Index_COMRLENDING}
    ${NOCHANGE_LIQ_ADDDEPT}    Run Keyword And Return Status    Should Be Equal As Strings    ${input_adddeptcode}    ${GLOBAL_LIQ_ADDDEPTCODE}
    ${GLOBAL_LIQ_STATUS}    Convert To Uppercase    ${GLOBAL_LIQ_STATUS}
    ${sStatus_list}    Split String    ${sStatus}    ,
    ${sStatus_list}    Get From List    ${sStatus_list}    ${Index_COMRLENDING}
    ${NOCHANGE_LIQ_STATUS}    Run Keyword And Return Status    Should Be Equal As Strings    ${sStatus_list}    ${GLOBAL_LIQ_STATUS}
    ${loc_list}    Split String    ${sLocation}    ,
    ${input_location}    Get From List    ${loc_list}    ${Index_COMRLENDING}
    ${NOCHANGE_LIQ_LOCATION}    Run Keyword And Return Status    Should Be Equal As Strings    ${input_location}    ${GLOBAL_LIQ_LOCATION}
    ${NOCHANGE_LIQ_PROCAREA}    Run Keyword And Return Status    Should Be Equal As Strings    ${LIQ_defProc_Desc}    ${GLOBAL_LIQ_PROCAREA}
    ${input_loginId}    Convert To Uppercase    ${sLoginID}
    ${NOCHANGE_LIQ_LOGINID}    Run Keyword And Return Status    Should Be Equal As Strings    ${input_loginId}    ${GLOBAL_LIQ_USERLOGINID}
    ${userlocked_list}    Split String    ${sUserLockStatus}    ,
    ${input_userlocked}    Get From List    ${userlocked_list}    ${Index_COMRLENDING}
    ${NOCHANGE_LIQ_USERLOCKED}    Run Keyword And Return Status    Should Be Equal As Strings    ${input_userlocked}    ${GLOBAL_LIQ_USERLOCKSTATUS}

    Set Global Variable    ${NOCHANGE_LIQ_USERID}
    Set Global Variable    ${NOCHANGE_LIQ_TITLECODE}
    Set Global Variable    ${NOCHANGE_LIQ_FNAME}
    Set Global Variable    ${NOCHANGE_LIQ_LNAME}
    Set Global Variable    ${NOCHANGE_LIQ_COUNTRYCODE}
    Set Global Variable    ${NOCHANGE_LIQ_EMAIL}
    Set Global Variable    ${NOCHANGE_LIQ_BRANCH}
    Set Global Variable    ${NOCHANGE_LIQ_CONTACTNUM1}
    Set Global Variable    ${NOCHANGE_LIQ_JOBFUNTION}
    Set Global Variable    ${NOCHANGE_LIQ_LANGUAGE}
    Set Global Variable    ${NOCHANGE_LIQ_PRIMDEPT}
    Set Global Variable    ${NOCHANGE_LIQ_ADDDEPT}
    Set Global Variable    ${NOCHANGE_LIQ_STATUS}
    Set Global Variable    ${NOCHANGE_LIQ_LOCATION}
    Set Global Variable    ${NOCHANGE_LIQ_PROCAREA}
    Set Global Variable    ${NOCHANGE_LIQ_LOGINID}
    Set Global Variable    ${NOCHANGE_LIQ_USERLOCKED}

    ###Add Input Value to JSON for User Comparison Report for LIQ###
    ${File_Path}    Set Variable    ${sInputFilePath}${templateinput_SingleLOB}
    ${EMPTY}    Set Variable
    ${JSON_Object}    Load JSON From File    ${dataset_path}${File_Path}

    ${New_JSON}    Set To Dictionary    ${JSON_Object}    profileId=${input_UserID}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    jobTitle=${LIQ_Title_Desc}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    firstName=${input_FName}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    surname=${input_LName}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode=${LIQ_CountryCode_Desc}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    email=${sEmail}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    contactNumber1=${iContactNum1}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    locale=${LIQ_Language_Desc}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    primaryDepartment=${input_primdeptcode}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    additionalDepartments=${input_adddeptcode}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    status=${sStatus_list}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    defaultProcessingArea=${LIQ_defProc_Desc}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    loginId=${input_loginId}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    userLockStatus=${input_userlocked}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    location=${LIQ_Loc_Desc}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    role=${LIQ_JobFunction_Desc}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    branch=${LIQ_Branch_Desc}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    Log    ${Converted_JSON}
    ${JSONFile}    Set Variable    ${sInputFilePath}Input_LIQData.json
    Delete File If Exist    ${dataset_path}${JSONFile}
    Create File    ${dataset_path}${JSONFile}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSONFile}

Validate LoanIQ for Users for Put
    [Documentation]    This keyword is used to validate Users in LoanIQ for put success.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - changed userID to profileId, changed osUserId to loginId
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    26APR2019    - add screenshot
    ...    @update: clanding    29APR2019    - updating argument to ${sJobFunctionVal} and removing getting of job function code in the config
    ...    @update: dahijara    19AUG2019    - updated keyword name to specify that this keyword is for PUT only and updated hard coded boolean values to variables
    [Arguments]    ${sJobFunctionVal}    ${sCountryCode_2Code}    ${sLocale}    ${sDefBusinessEntity}    ${sJobTitle}
    ...    ${sAddDept}    ${sPrimDept}    ${sDefProcArea}    ${sAddProcArea}    ${sLocation}    ${sProfileID}    ${sStatus}
    ...    ${iContactNum1}    ${sUserLockStatus}    ${sFName}    ${sLName}    ${sEmail}    ${sLoginID}
    ...    ${Index_COMRLENDING}
    
    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    
    Search in Table Maintenance    Country
    ${LIQ_CountryCode_Desc}    Get Single Description from Table Maintanance    ${sCountryCode_2Code}    ${LIQ_Country_Window}
    ...    ${LIQ_Country_Tree}    ${LIQ_Country_ShowALL_RadioButton}    ${LIQ_Country_Exit_Button}

    Search in Table Maintenance    Language
    ${locale}    Run Keyword If    '${sLocale}'=='no tag' or '${sLocale}'=='null'    Set Variable    en
    ...    ELSE    Set Variable    ${sLocale}
    ${LIQ_Language_Desc}    Get Single Description from Table Maintanance    ${locale}    ${LIQ_Language_Window}
    ...    ${LIQ_Language_Tree}    ${LIQ_Language_ShowALL_RadioButton}    ${LIQ_Language_Exit_Button}

    ${defaultBusinessEntity_List}    Split String    ${sDefBusinessEntity}    ,
    ${defaultBusinessEntity_ValList_0}    Get From List    ${defaultBusinessEntity_List}    ${Index_COMRLENDING}
    ${defaultBusinessEntity_ValList}    Split String    ${defaultBusinessEntity_ValList_0}    |
    ${defaultBranch_val}    Get From List    ${defaultBusinessEntity_ValList}    1
    Search in Table Maintenance    Branch
    ${LIQ_Branch_Desc}    Get Single Description from Table Maintanance    ${defaultBranch_val}    ${LIQ_Branch_Window}
    ...    ${LIQ_Branch_Tree}    ${LIQ_Branch_ShowALL_RadioButton}    ${LIQ_Branch_Exit_Button}

    Search in Table Maintenance    Title
    ${LIQ_Title_Desc}    Get Single Description from Table Maintanance    ${sJobTitle}    ${LIQ_Title_Window}
    ...    ${LIQ_Title_Tree}    ${LIQ_Title_ShowALL_RadioButton}    ${LIQ_Title_Exit_Button}

    Search in Table Maintenance    Job Function
    ##get Job Function code from config setup using 'role' value from json
    ${LIQ_JobFunction_Desc}    Get Single Description from Table Maintanance    ${sJobFunctionVal}    ${LIQ_JobFunction_Window}
    ...    ${LIQ_JobFunction_Tree}    ${LIQ_JobFunction_ShowAllRadioButton}    ${LIQ_JobFunction_Exit_Button}

    Search in Table Maintenance    Department
    ${LIQ_DeptDescList}    ${PrimDept_Desc}    Get Multiple Description from Table Maintenance    ${sAddDept}    ${sPrimDept}
    ...    ${LIQ_Department_Window}    ${LIQ_Department_Tree}    ${LIQ_Department_ShowAllRadioButton}    ${LIQ_Department_Exit_Button}    ${Index_COMRLENDING}

    Search in Table Maintenance    Processing Area
    ${LIQ_addProc_Desc}    ${LIQ_defProc_Desc}    Get Multiple Description from Table Maintenance    ${sPrimDept}    ${sAddProcArea}
    ...    ${LIQ_Processing_Area_Window}    ${LIQ_Processing_Area_Tree}    ${LIQ_Processing_Area_ShowAllRadioButton}    ${LIQ_Processing_Area_Exit_Button}    ${Index_COMRLENDING}

    ${location_List}    Split String    ${sLocation}    ,
    ${location_Val}    Get From List    ${location_List}    ${Index_COMRLENDING}
    Search in Table Maintenance    Location
    ${LIQ_Loc_Desc}    Get Single Description from Table Maintanance    ${location_Val}    ${LIQ_Location_Window}    ${LIQ_Location_Tree}    ${LIQ_Location_ShowAllRadioButton}    ${LIQ_Location_Exit_Button}

    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}

    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ###check for error message
    ${Err_exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${Err_exist}==${True}    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Fail    User does not exists.
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
	Take Screenshot    LIQ_SearchUser
    ${UserList_exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sProfileID}    60
    Run Keyword If    ${UserList_exist}==${False}    Fail    User '${sProfileID}' does not exist!!
    ...    ELSE    Log    User '${sProfileID}' exists.
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}    

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    
    Take Screenshot    LIQ_UserProfile
    ${input_userid}    Convert To Uppercase    ${sProfileID}
    ${UserID_Locator}    Run Keyword If    ${NOCHANGE_LIQ_USERID}==${True}    Set Static Text to Locator Single Text    User Profile Maintenance    ${GLOBAL_LIQ_USERID}
    ...    ELSE    Set Static Text to Locator Single Text    User Profile Maintenance    ${input_userid}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR

    ${input_FName}    Convert To Uppercase    ${sFName}
    Run Keyword If    ${NOCHANGE_LIQ_FNAME}==${True}    Validate Loan IQ Details    ${GLOBAL_LIQ_FNAME}    ${LIQ_UserProfileMaint_FName_Textfield}
    ...    ELSE    Validate Loan IQ Details    ${input_FName}    ${LIQ_UserProfileMaint_FName_Textfield}

    ${input_LName}    Convert To Uppercase    ${sLName}
    Run Keyword If    ${NOCHANGE_LIQ_LNAME}==${True}    Validate Loan IQ Details    ${GLOBAL_LIQ_LNAME}    ${LIQ_UserProfileMaint_LName_Textfield}
    ...    ELSE    Validate Loan IQ Details    ${input_LName}    ${LIQ_UserProfileMaint_LName_Textfield}

    Run Keyword If    ${NOCHANGE_LIQ_EMAIL}==${True}    Validate Loan IQ Details    ${GLOBAL_LIQ_EMAIL}    ${LIQ_UserProfileMaint_Email_Textfield}
    ...    ELSE    Validate Loan IQ Details    ${sEmail}    ${LIQ_UserProfileMaint_Email_Textfield}

    ${Country_Locator}    Run Keyword If    ${NOCHANGE_LIQ_COUNTRYCODE}==${True}    Set Static Text to Locator Single Text    User Profile Maintenance    ${GLOBAL_LIQ_COUNTRY}
    ...    ELSE    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_CountryCode_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Country_Locator}    VerificationData="Yes"
    ${country_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Country_Locator}    VerificationData="Yes"
    Run Keyword If    ${country_stat}==${True}    Log    Country is correct!!
    ...    ELSE    Log    Country is incorrect!!    level=ERROR

    ${Branch_Locator}    Run Keyword If    ${NOCHANGE_LIQ_BRANCH}==${True}    Set Static Text to Locator Single Text    User Profile Maintenance    ${GLOBAL_LIQ_BRANCH}
    ...    ELSE    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_Branch_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Branch_Locator}    VerificationData="Yes"
    ${branch_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Branch_Locator}    VerificationData="Yes"
    Run Keyword If    ${branch_stat}==${True}    Log    Branch is correct!!
    ...    ELSE    Log    Branch is incorrect!!    level=ERROR

    ${Language_Locator}    Run Keyword If    ${NOCHANGE_LIQ_LANGUAGE}==${True}    Set Static Text to Locator Single Text    User Profile Maintenance    ${GLOBAL_LIQ_LANGUAGE}
    ...    ELSE    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_Language_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Language_Locator}    VerificationData="Yes"
    ${language_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Language_Locator}    VerificationData="Yes"
    Run Keyword If    ${language_stat}==${True}    Log    Language is correct!!
    ...    ELSE    Log    Language is incorrect!!    level=ERROR

    ${Title_Locator}    Run Keyword If    ${NOCHANGE_LIQ_TITLECODE}==${True}    Set Static Text to Locator Single Text    User Profile Maintenance    ${GLOBAL_LIQ_TITLE}
    ...    ELSE    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_Title_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Title_Locator}    VerificationData="Yes"
    ${title_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Title_Locator}    VerificationData="Yes"
    Run Keyword If    ${title_stat}==${True}    Log    Title is correct!!
    ...    ELSE    Log    Title is incorrect!!    level=ERROR

    ${JobFunction_Locator}    Run Keyword If    ${NOCHANGE_LIQ_JOBFUNTION}==${True}    Set Static Text to Locator Single Text    User Profile Maintenance    ${GLOBAL_LIQ_JOBFUNCTION}
    ...    ELSE    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_JobFunction_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${JobFunction_Locator}    VerificationData="Yes"
    ${jobfunction_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${JobFunction_Locator}    VerificationData="Yes"
    Run Keyword If    ${jobfunction_stat}==${True}    Log    Job Function is correct!!
    ...    ELSE    Log    Job Function is incorrect!!    level=ERROR

    ${Location_Locator}    Run Keyword If    ${NOCHANGE_LIQ_LOCATION}==${True}    Set Static Text to Locator Single Text    User Profile Maintenance    ${GLOBAL_LIQ_LOCATION}
    ...    ELSE    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_Loc_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    ${location_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Location_Locator}    VerificationData="Yes"
    Run Keyword If    ${location_stat}==${True}    Log    Location is correct!!
    ...    ELSE    Log    Location is incorrect!!    level=ERROR

    ${ProcArea_Locator}    Run Keyword If    ${NOCHANGE_LIQ_LOCATION}==${True}    Set Static Text to Locator Single Text    User Profile Maintenance    ${GLOBAL_LIQ_PROCAREA}
    ...    ELSE    Set Static Text to Locator Single Text    User Profile Maintenance    ${LIQ_defProc_Desc}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${ProcArea_Locator}    VerificationData="Yes"
    ${procarea_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${ProcArea_Locator}    VerificationData="Yes"
    Run Keyword If    ${procarea_stat}==${True}    Log    Processing Area is correct!!
    ...    ELSE    Log    Processing Area is incorrect!!    level=ERROR

    ${primDept_List}    Split String    ${sPrimDept}    ,
    ${primDept}    Get From List    ${primDept_List}    ${Index_COMRLENDING}
    Run Keyword If    ${NOCHANGE_LIQ_PRIMDEPT}==${True}    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${GLOBAL_LIQ_DEPTCODE}
    ...    ELSE    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${primDept}\t${PrimDept_Desc}\tYes

    ${primdept_stat}    Run Keyword If    ${NOCHANGE_LIQ_PRIMDEPT}==${True}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${GLOBAL_LIQ_DEPTCODE}
    ...    ELSE    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${primDept}\t${PrimDept_Desc}\tYes
    Run Keyword If    ${primdept_stat}==${True}    Log    Primary Department is correct!! '${primDept}\t${PrimDept_Desc}\tYes'
    ...    ELSE    Log    Primary Department is incorrect!! '${primDept}\t${PrimDept_Desc}\tYes'    level=ERROR

    ##check if not Primary Indicator --value should be blank or NO.
    ${additionalDepartments_List}    Split String    ${sAddDept}    ,
    ${additionalDepartmentsVal}    Get From List    ${additionalDepartments_List}    ${Index_COMRLENDING}
    ${additionalDepartmentsVal_List}    Split String    ${additionalDepartmentsVal}    /
    ${dept_count}    Get Length    ${LIQ_DeptDescList}
    ${INDEX_0}    Set Variable    0
    :FOR    ${INDEX_0}    IN RANGE    ${dept_count}
    \    ${depdesc_val}    Get From List    ${LIQ_DeptDescList}    ${INDEX_0}
    \    ${depcode_val}    Get From List    ${additionalDepartmentsVal_List}    ${INDEX_0}
    \    Run Keyword If    ${NOCHANGE_LIQ_ADDDEPT}==${True}    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${GLOBAL_LIQ_ADDDEPTCODE}
         ...    ELSE    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${depcode_val}\t${depdesc_val}\t
    \    ${adddept_stat}    Run Keyword If    ${NOCHANGE_LIQ_ADDDEPT}==${True}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${GLOBAL_LIQ_ADDDEPTCODE}
         ...    ELSE    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_UserProfileMaint_Dept_Tree}    ${depcode_val}\t${depdesc_val}\t
    \    Run Keyword If    ${adddept_stat}==${True}    Log    Additional Department is correct!! Selected: '${GLOBAL_LIQ_ADDDEPTCODE}'
         ...    ELSE    Log    Additional Department is incorrect!! Selected: '${GLOBAL_LIQ_ADDDEPTCODE}    level=ERROR
    \    Exit For Loop If    '${INDEX_0}'=='${dept_count}'

    mx LoanIQ select    ${LIQ_Options_ChangeStatus}
    mx LoanIQ activate window    ${LIQ_UserStatus_Dialog}
    Take Screenshot    LIQ_UserProfile_Status
    ${status_list}    Split String    ${sStatus}    ,
    ${input_status}    Get From List    ${status_list}    ${Index_COMRLENDING}
    ${LIQ_Status}    Run Keyword If    '${input_status}'=='ACTIVE'    Set Variable    Active
    ...    ELSE IF    '${input_status}'=='INACTIVE'    Set Variable    Inactive

    ###value 1 is equivalent to "ON", value 0 is for "OFF"
    ${Status_Locator}    Run Keyword If    ${NOCHANGE_LIQ_STATUS}==${True}    Set Variable    JavaWindow("title:=User Status.*").JavaRadioButton("attached text:=${GLOBAL_LIQ_STATUS}","value:=1")
    ...    ELSE    Set Variable    JavaWindow("title:=User Status.*").JavaRadioButton("attached text:=${LIQ_Status}","value:=1")
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${Status_Locator}    VerificationData="Yes"
    ${stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${Status_Locator}    VerificationData="Yes"
    Run Keyword If    ${stat}==${True}    Log    Correct!! User status is '${LIQ_Status}'.
    ...    ELSE    Log    Incorrect!! User status is NOT '${LIQ_Status}'.    level=ERROR

    mx LoanIQ click    ${LIQ_UserStatus_Cancel_Button}
    mx LoanIQ click    ${LIQ_UserProfileMaint_PhoneFax_Button}
    mx LoanIQ activate window    ${LIQ_PhoneFax_Window}
    Take Screenshot    LIQ_UserProfile_PhoneEmail
    Run Keyword If    ${NOCHANGE_LIQ_CONTACTNUM1}==${True}    Validate Loan IQ Details    ${GLOBAL_LIQ_PHONENUM1}    ${LIQ_PhoneFax_PhoneNum1_Textfield}
    ...    ELSE    Validate Loan IQ Details    ${iContactNum1}    ${LIQ_PhoneFax_PhoneNum1_Textfield}
    mx LoanIQ click    ${LIQ_PhoneFax_Cancel_Button}

    ###transform input, value 1 is equivalent to "CHECKED", value 0 is for "UNCHECKED"
    ${userLockStatus_List}    Split String    ${sUserLockStatus}    ,
    ${userLockStatus_Val}    Run Keyword If    ${NOCHANGE_LIQ_USERLOCKED}==${True}    Set Variable    ${GLOBAL_LIQ_USERLOCKSTATUS}
    ...    ELSE    Get From List    ${userLockStatus_List}    ${Index_COMRLENDING}
    ${UserLockedStatus}    Run Keyword If    '${userLockStatus_Val}'=='' or '${userLockStatus_Val}'=='UNLOCKED'   Set Variable    JavaWindow("title:=User Profile Maintenance.*").JavaCheckBox("attached text:=User Locked","value:=0")
    ...    ELSE IF    '${userLockStatus_Val}'=='LOCKED'    Set Variable    JavaWindow("title:=User Profile Maintenance.*").JavaCheckBox("attached text:=User Locked","value:=1")

    ## validate Security Profile tab
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Security Profile
    Take Screenshot    LIQ_UserProfile_SecurityProfile
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserLockedStatus}    VerificationData="Yes"
    ${stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserLockedStatus}    VerificationData="Yes"
    Run Keyword If    ${stat}==${True}    Log    User Locked is correct.
    ...    ELSE    Log    User Locked is incorrect.    level=ERROR
    ${input_loginId}    Run Keyword If    ${NOCHANGE_LIQ_LOGINID}==${True}    Set Variable    ${GLOBAL_LIQ_USERLOGINID}
    ...    ELSE    Convert To Uppercase    ${sLoginID}
    Validate Loan IQ Details    ${input_loginId}    ${LIQ_UserProfileMaint_Tab_UserLoginID}

    Close All Windows on LIQ

Validate Loan IQ for Users with INACTIVE Status 
    [Documentation]    This keyword is used to validate Users in LoanIQ for delete success, no changes must be applied.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - changed userID to profileId
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: amansuet    16AUG2019    - updated script and added screenshot function
    [Arguments]    ${sProfileID}

    Search User in Loan IQ    ${sProfileID}    ${LOANIQ_USERSTATUS_INACTIVE}

    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
    Take Screenshot    LIQ_UserProfile
    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}

    ${Input_UserID}    Convert To Uppercase    ${sProfileID}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${Input_UserID}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR
    Take Screenshot    LIQ_UserID

    mx LoanIQ select    ${LIQ_Options_ChangeStatus}
    mx LoanIQ activate window    ${LIQ_UserStatus_Dialog}

    ## value 1 is equivalent to "ON", value 0 is for "OFF"
    ## when USER is deleted thru API, user will be INACTIVATED
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_UserStatus_Inactive_RadioButton}    VerificationData="Yes"
    ${stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_UserStatus_Inactive_RadioButton}    VerificationData="Yes"
    Run Keyword If    ${stat}==${True}    Log    Correct!! User status status is INACTIVE.
    ...    ELSE    Log    Incorrect!! User status is not INACTIVE.    level=ERROR
    Take Screenshot    LIQ_UserStatus

    mx LoanIQ click    ${LIQ_UserStatus_Cancel_Button}

    Close All Windows on LIQ

Validate User is Not Created in LoanIQ
    [Documentation]    This keyword is used to validate user is NOT CREATED in Loan IQ.
    ...    @jaquitan/chanario
    ...    @update: clanding    20DEC2018    - changed userID to profileId
    ...    @update: clanding    23APR2019    - updated keyword name and documentation, updated handling for failed condition, added screenshot
    [Arguments]    ${sProfileID}    ${sLName}    ${sFName}
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    Log    &{APIDataSet}[profileId]
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}
    ${UserID}    Set Variable    ${sProfileID}
    ${UserID_Length}    Get Length    ${sProfileID}
    ${UserID_substring}    Run Keyword If    ${UserID_Length}>8    Get Substring    ${UserID}    0    8
    ...    ELSE    Set Variable    ${UserID}

    ###check for error message
    ${Error_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${Error_Exist}==True    Run Keywords    Mx LoanIQ Verify Runtime Property    ${LIQ_Error_MessageBox}    value%No user found for ${UserID_substring}.
    ...    AND    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Log    User '${UserID_substring}' does not exists.
    ...    ELSE   Run Keywords    Search for First Name and Last Name in User Profile    ${sProfileID}    ${sLName}    ${sFName}
    ...    AND    Log    User '${UserID_substring}' exists.
    Close All Windows on LIQ

Search for First Name and Last Name in User Profile
    [Documentation]    This keyword is used to search for First Name and Last Name in User Profile notebook.
    ...    @update: clanding    23APR2019    - added documentation and refactor
    [Arguments]    ${sProfileID}    ${sLName}    ${sFName}
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
    ${Name}    Catenate    ${sLName},${SPACE}${sFName}${SPACE}
    ${Name}    Convert To Uppercase    ${Name}
    ${userIDVariable}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OpenAUserProfile_UserList_Tree}      ${Name}%User ID%userIDVariable
    ${Value_Length}    Get Length    ${userIDVariable}
    ${FieldEmpty}    Run Keyword And Return Status    Should Be Equal As Integers    ${Value_Length}    0
    Run Keyword If     ${FieldEmpty}==${True}    Log    User '${sProfileID}' does not exist.
    ...    ELSE    Fail    User is existing!

Add Current Value to JSON for User Comparison Report for LIQ
    [Documentation]    This keyword is used to add current values from LoanIQ Application for JSON and save in file.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - changed userID to profileId, changed osuserID to loginId
    ...    @update: clanding    22APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}

    ${File_Path}    Set Variable    ${sInputFilePath}${templateinput_SingleLOB}
    ${JSON_Object}    Load JSON From File    ${dataset_path}${File_Path}

    ${New_JSON}    Set To Dictionary    ${JSON_Object}    profileId=${GLOBAL_LIQ_USERID}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    jobTitle=${GLOBAL_LIQ_TITLE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    firstName=${GLOBAL_LIQ_FNAME}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    surname=${GLOBAL_LIQ_LNAME}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    countryCode=${GLOBAL_LIQ_COUNTRY}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    email=${GLOBAL_LIQ_EMAIL}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    contactNumber1=${GLOBAL_LIQ_PHONENUM1}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    locale=${GLOBAL_LIQ_LANGUAGE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    primaryDepartment=${GLOBAL_LIQ_DEPTCODE}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    additionalDepartments=${GLOBAL_LIQ_ADDDEPTCODE}
    ${GLOBAL_LIQ_STATUS}    Convert To Uppercase    ${GLOBAL_LIQ_STATUS}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    status=${GLOBAL_LIQ_STATUS}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    defaultProcessingArea=${GLOBAL_LIQ_PROCAREA}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    loginId=${GLOBAL_LIQ_USERLOGINID}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    userLockStatus=${GLOBAL_LIQ_USERLOCKSTATUS}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    branch=${GLOBAL_LIQ_BRANCH}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    location=${GLOBAL_LIQ_LOCATION}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    role=${GLOBAL_LIQ_JOBFUNCTION}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    Log    ${Converted_JSON}
    ${JSONFile}    Set Variable    ${sOutputFilePath}Current_LIQData.json
    Delete File If Exist    ${dataset_path}${JSONFile}
    Create File    ${dataset_path}${JSONFile}    ${Converted_JSON}
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSONFile}

Search User in Loan IQ    
    [Documentation]    This keyword is used to search User in LoanIQ.
    ...    The value for sStatus should either be ACTIVE or INACTIVE. Default value is ACTIVE.
    ...    @author: clanding
    ...    @update: amansuet    20AUG2019    - updated based on standards, updated script to handle active and inactive users
    ...    @update: amansuet    06SEP2019    - added another condition to accept BOTH for status value where active and inactive users are both selected.
    [Arguments]    ${sProfileID}    ${sStatus}=ACTIVE

    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_Actions_Button}

    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
    
    Run Keyword If    '${sStatus}'=='ACTIVE'    Run Keywords    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Active_Checkbox}    ON
    ...    AND    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    OFF
    ...    ELSE IF    '${sStatus}'=='INACTIVE'    Run Keywords    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Active_Checkbox}    OFF
    ...    AND    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    ...    ELSE IF    '${sStatus}'=='BOTH'    Run Keywords    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Active_Checkbox}    ON
    ...    AND    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON

    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}

    ## check for error message
    ${Error_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${Error_Exist}==True    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Log    Fail    User does not exists.

Compare Input and Actual LIQ Data
    [Documentation]    This keyword is used to get input and actual LIQ data and compare them.
    ...    @author: clanding    22APR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sOutputFilePath}
    
    ${Current_LIQData}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}Current_LIQData.json    
    ${Input_LIQData}    OperatingSystem.Get File    ${dataset_path}${sInputFilePath}Input_LIQData.json    
    ${IsMatched}    Run Keyword And Return Status    Mx Compare Json Data    ${Current_LIQData}    ${Input_LIQData}
    Run Keyword If    ${IsMatched}==${True}    Log    Input values and current values are equal and have no changes. ${Input_LIQData} == ${Current_LIQData}    level=WARN
    ...    ELSE IF    ${IsMatched}==${False}    Log    Input values and current values have differences. ${Input_LIQData} != ${Current_LIQData}    level=WARN

Verify User Status is Correct
    [Documentation]    This keyword is used to verify user Status
    ...    @author: jloretiz    05SEP2019    - initial create
    [Arguments]    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sExpectedStatus}
    
    ${Response_File}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputAPIResponse}.${JSON}
    ${Converted_JSON}    evaluate    json.loads('''${Response_File}''')    ${JSON}
    
    ${Value_Status}    Get Value From Json    ${Converted_JSON}    $..lobs..status
    ${Status}    Get From List    ${Value_Status}    0
    
    Log    Expected=${sExpectedStatus} Actualt=${Status} 
    Log    FILE=${sOutputAPIResponse}
    
    ${IsMatched}    Run Keyword And Return Status    Should Be Equal As Strings    ${Status}    ${sExpectedStatus}
    Run Keyword If    ${IsMatched}==${True}    Log    User Status ${Status} is correct.
    ...    ELSE IF    ${IsMatched}==${False}    Log    User Status ${Status} is not correct.    level=ERROR
    
Verify User Lock Status is Correct
    [Documentation]    This keyword is used to verify user Status
    ...    @author: jloretiz    075SEP2019    - initial create
    [Arguments]    ${sOutputFilePath}    ${sOutputAPIResponse}    ${sExpectedStatus}
    
    ${Response_File}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${sOutputAPIResponse}.${JSON}
    ${Converted_JSON}    evaluate    json.loads('''${Response_File}''')    ${JSON}
    
    ${Value_Status}    Get Value From Json    ${Converted_JSON}    $..lobs..userLockStatus
    ${Status}    Get From List    ${Value_Status}    0
    
    ${IsMatched}    Run Keyword And Return Status    Should Be Equal As Strings    ${Status}    ${sExpectedStatus}
    Run Keyword If    ${IsMatched}==${True}    Log    User Lock Status ${Status} is correct.
    ...    ELSE IF    ${IsMatched}==${False}    Log    User Lock Status ${Status} is not correct.    level=ERROR

Validate LOANIQ User Lock Status
    [Documentation]    This keyword is used to validate user lock status in LoanIQ
    ...    @author: jloretiz    075SEP2019    - initial create
    [Arguments]    ${sUserLockStatus}    ${sStatus}    ${sProfileID}    ${sLoginID}    ${sFName}    ${sLName}    ${sJobFunctionVal}

    Refresh Tables in LIQ
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    
    Search in Table Maintenance    Job Function
    ${LIQ_JobFunction_Desc}    Get Single Description from Table Maintanance    ${sJobFunctionVal}    ${LIQ_JobFunction_Window}
    ...    ${LIQ_JobFunction_Tree}    ${LIQ_JobFunction_ShowAllRadioButton}    ${LIQ_JobFunction_Exit_Button}

    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}

    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_Window}
        Run Keyword If    '${sStatus}'=='INACTIVE'    Run Keywords    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Inactive_Checkbox}    ON
    ...    AND    Mx LoanIQ Set    ${LIQ_OpenAUserProfile_Active_Checkbox}    OFF
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_OpenAUserProfile_IdentifyUserBy_Textfield}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_Search_Button}
    
    ${Error_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OpenAUserProfile_Error_Dialog}    VerificationData="Yes"    Processtimeout=100        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${Error_Exist}==True    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    Log    Fail    User does not exists.
    
    ${Input_UserID}    Convert To Uppercase    ${sProfileID}
    ${Input_FName}    Convert To Uppercase    ${sFName}
    ${Input_LName}    Convert To Uppercase    ${sLName}
    
    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
    Take Screenshot    LIQ_SearchUser
    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${Input_UserID}\t${LIQ_JobFunction_Desc}\t${Input_LName},${SPACE}${Input_FName}${SPACE}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}
    Take Screenshot    LIQ_UserProfile
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${Input_UserID}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==True    Log    User ID is correct!!
    
    ${UserLockedStatus}    Run Keyword If    '${sUserLockStatus}'=='' or '${sUserLockStatus}'=='UNLOCKED'   Set Variable    JavaWindow("title:=User Profile Maintenance.*").JavaCheckBox("attached text:=User Locked","value:=0")
    ...    ELSE IF    '${sUserLockStatus}'=='LOCKED'    Set Variable    JavaWindow("title:=User Profile Maintenance.*").JavaCheckBox("attached text:=User Locked","value:=1")
    
    ###SECURITY PROFILE TAB ###
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Security Profile
    Take Screenshot    LIQ_UserProfile_SecurityProfile
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserLockedStatus}    VerificationData="Yes"
    ${stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserLockedStatus}    VerificationData="Yes"
    Run Keyword If    ${stat}==True    Log    User Locked is correct.
    ...    ELSE    Log    User Locked is incorrect.    level=ERROR
    ${Input_LoginID}    Convert To Uppercase    ${sLoginID}

    Close All Windows on LIQ
    
Validate User is Existing for LIQ in GET All User Success
    [Documentation]    This keyword is used to validate Users in LoanIQ if user is existing. No validation on fields or status required.
    ...    @update: amansuet    06SEP2019    - initial create
    [Arguments]    ${sProfileID}

    Search User in Loan IQ    ${sProfileID}    ${LOANIQ_USERSTATUS_BOTH_ACTIVE_INACTIVE}

    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
    Take Screenshot    LIQ_UserProfile
    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}

    ${Input_UserID}    Convert To Uppercase    ${sProfileID}
    ${UserID_Locator}    Set Static Text to Locator Single Text    User Profile Maintenance    ${Input_UserID}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    ${userid_stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${UserID_Locator}    VerificationData="Yes"
    Run Keyword If    ${userid_stat}==${True}    Log    User ID is correct!!
    ...    ELSE    Log    User ID is incorrect!!    level=ERROR
    Take Screenshot    LIQ_UserID

    Close All Windows on LIQ

Create User in LOANIQ
    [Documentation]    This keyword is used to create user in LOANIQ.
    ...    @author: jloretiz    11SEP2019    - initial create
	...    @update: jloretiz    17SEP2019    - added configuration for osUserId
    [Arguments]    ${APIDataSet}
    
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_User_Profile_Window}
    Verify Window    ${LIQ_User_Profile_Window}
    mx LoanIQ enter    ${LIQ_User_Profile_Textbox}     LIQAD118
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ click    ${LIQ_User_Profile_Ok_Button}
    mx LoanIQ activate window    ${LIQ_User_Profile_Maintenance_Window}
    Verify Window    ${LIQ_User_Profile_Maintenance_Window}
    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_Save_As}
    mx LoanIQ activate window    ${LIQ_User_Profile_Maintenance_Save_As_Window}  
    Verify Window    ${LIQ_User_Profile_Maintenance_Save_As_Window} 
    mx LoanIQ enter    ${LIQ_User_Profile_Maintenance_Save_As_Textbox}     &{APIDataSet}[profileId]
    mx LoanIQ enter    ${LIQ_User_Profile_Maintenance_FirstName_Textbox}     &{APIDataSet}[firstName]
    mx LoanIQ enter    ${LIQ_User_Profile_Maintenance_LastName_Textbox}     &{APIDataSet}[surname]
    mx LoanIQ click    ${LIQ_User_Profile_Maintenance_Save_As_Ok_Button}
    mx LoanIQ activate window    ${LIQ_User_Profile_Maintenance_Window}
    Verify Window    ${LIQ_User_Profile_Maintenance_Window}
    
    mx LoanIQ enter    ${LIQ_UserProfileMaint_Email_Textfield}    &{APIDataSet}[email]
    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_UserProfileMaint_Tab}    Security Profile
    mx LoanIQ enter    ${LIQ_UserProfileMaint_OSUserID_TextField}     &{APIDataSet}[osUserId]
    
    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_File_Save}    
    Mx LoanIQ Click Button On Window    User Profile Maintenance.*;Informational Message.*;OK        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    mx LoanIQ activate window    ${LIQ_User_Profile_Maintenance_Window}
    Verify Window    ${LIQ_User_Profile_Maintenance_Window}
    mx LoanIQ close window    ${LIQ_User_Profile_Maintenance_Window}
    
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_User_Profile_Window}
    Verify Window    ${LIQ_User_Profile_Window}
    mx LoanIQ enter    ${LIQ_User_Profile_Textbox}     &{APIDataSet}[profileId]
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ click    ${LIQ_User_Profile_Ok_Button}
    mx LoanIQ activate window    ${LIQ_User_Profile_Maintenance_Window}
    Verify Window    ${LIQ_User_Profile_Maintenance_Window}
    mx LoanIQ close window    ${LIQ_User_Profile_Maintenance_Window}
    
Update User in LOANIQ
    [Documentation]    This keyword is used to update user in LOANIQ.
    ...    @author: jloretiz    16SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    Select Actions    [Actions];User Profile
    mx LoanIQ activate window    ${LIQ_User_Profile_Window}
    Verify Window    ${LIQ_User_Profile_Window}
    mx LoanIQ select    ${LIQ_OpenAUserProfile_IdentifyUserBy_List}    User ID
    mx LoanIQ enter    ${LIQ_User_Profile_Textbox}     &{APIDataSet}[profileId]
    mx LoanIQ click    ${LIQ_User_Profile_Ok_Button}
    mx LoanIQ activate window    ${LIQ_User_Profile_Maintenance_Window}
    Verify Window    ${LIQ_User_Profile_Maintenance_Window}
    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_Update}
    mx LoanIQ enter    ${LIQ_UserProfileMaint_FName_Textfield}     &{APIDataSet}[firstName]
    mx LoanIQ enter    ${LIQ_UserProfileMaint_LName_Textfield}     &{APIDataSet}[surname]
    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_File_Save}
    mx LoanIQ close window    ${LIQ_User_Profile_Maintenance_Window}
    
Set ACTIVE Loan IQ User to INACTIVE 
    [Documentation]    This keyword is used to set status of Active Loan IQ User to INACTIVE.
    ...    @update: amansuet    18SEP2019    - initial create
    [Arguments]    ${sProfileID}    ${sStatus}

    Search User in Loan IQ    ${sProfileID}    ${LOANIQ_USERSTATUS_ACTIVE}

    mx LoanIQ activate window    ${LIQ_OpenAUserProfile_UserList_Window}
    Take Screenshot    LIQ_UserProfile
    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}

    mx LoanIQ activate window    ${LIQ_UserProfileMaint_Window}
    mx LoanIQ click    ${LIQ_UserProfileMaint_InqMode_Button}

    mx LoanIQ select    ${LIQ_Options_ChangeStatus}
    mx LoanIQ activate window    ${LIQ_UserStatus_Dialog}
    Take Screenshot    LIQ_UserStatus_Active
    
    ## Set Status to INACTIVE ##
    Run Keyword If    '${sStatus}'=='INACTIVE'    Mx LoanIQ Set    ${LIQ_UserStatus_Inactive_RadioButton_ToSet}    ON
    Take Screenshot    LIQ_UserStatus_Set_Inactive
    mx LoanIQ click    ${LIQ_UserStatus_OK_Button}
    mx LoanIQ select    ${LIQ_User_Profile_Maintenance_File_Save}
    
    Close All Windows on LIQ

Verify User Status in LIQ
    [Documentation]    This keyword is used to verify user status by searching in User Profile Window
    ...    @author: jloretiz    23JAN2020    - initial create
    [Arguments]    ${sProfileID}    ${sStatus}=ACTIVE

    Search User in Loan IQ    ${sProfileID}    ${sStatus}
    Mx LoanIQ Select String    ${LIQ_OpenAUserProfile_UserList_Tree}    ${sProfileID}
    mx LoanIQ click    ${LIQ_OpenAUserProfile_UserList_OK_Button}
    Set Notebook to Update Mode    ${LIQ_UserProfileMaint_Window}    ${LIQ_NotebookInInquiryMode_Button}
    Take Screenshot    LIQ_UserStatus_${sStatus}