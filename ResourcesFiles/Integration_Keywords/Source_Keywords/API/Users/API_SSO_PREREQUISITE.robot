*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Update Key Values of Input JSON File for User API
    [Documentation]    This keyword is used to update key values of JSON file and save to new file.
    ...    @author: jaquitan/clanding/chanario
    ...    @update: clanding    20DEC2018    - Changed userID to loginId, added profileId in lobs, removed outer lineOfBusiness inside lobs
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    07MAY2019    - added handling for multiple LOB
    ...    @update: xmiranda    19JUL2019    - Added a condition, line 193. If lobs has 'not tag' value, then the JSON value for the lobs would be an Empty List[]
    [Arguments]    ${sFilePath}    ${sFileName}    ${sLoginID}    ${sJobTitle}    ${sFName}    ${sLName}    ${sCountryCode}    ${sLocale}    ${iContactNum1}
    ...    ${iContactNum2}    ${sEmail}    ${sOSUserID}    ${sCentralUserType}    ${sCentralRoles}    ${sLOB}    ${sDefaultBussEntity}
    ...    ${sAddBussEntity}    ${sDefaultProcArea}    ${sAddProcArea}    ${sAddDept}    ${sPrimaryDept}    ${sLocation}    ${sRoles}
    ...    ${sStatus}    ${sUserLockStatus}    ${sUserType}    ${sProfielID}

    ${file_path}    Set Variable    ${Input_File_Path_Users}${templateinput_MultipleLOB}
    ${EMPTY}    Set Variable
    ${JSON_Object}    Load JSON From File    ${file_path}

    ## add demographic fields here
    ${New_JSON}    Run Keyword If    '${sLoginID}'=='null'    Set To Dictionary    ${JSON_Object}    loginId=${NONE}
    ...    ELSE IF    '${sLoginID}'==''    Set To Dictionary    ${JSON_Object}    loginId=${EMPTY}
    ...    ELSE IF    '${sLoginID}'=='Empty' or '${sLoginID}'=='empty'    Set To Dictionary    ${JSON_Object}    loginId=${EMPTY}
    ...    ELSE IF    '${sLoginID}'=='no tag'    Set Variable    ${JSON_Object}
    ...    ELSE    Set To Dictionary    ${JSON_Object}    loginId=${sLoginID}

    ${New_JSON}    Run Keyword If    '${sJobTitle}'=='null'    Set To Dictionary    ${New_JSON}    jobTitle=${NONE}
    ...    ELSE IF    '${sJobTitle}'==''    Set To Dictionary    ${New_JSON}    jobTitle=${EMPTY}
    ...    ELSE IF    '${sJobTitle}'=='Empty' or '${sJobTitle}'=='empty'    Set To Dictionary    ${New_JSON}    jobTitle=${EMPTY}
    ...    ELSE IF    '${sJobTitle}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    jobTitle=${sJobTitle}

    ${New_JSON}    Run Keyword If    '${sFName}'=='null'    Set To Dictionary    ${New_JSON}    firstName=${NONE}
    ...    ELSE IF    '${sFName}'==''    Set To Dictionary    ${New_JSON}    firstName=${EMPTY}
    ...    ELSE IF    '${sFName}'=='Empty' or '${sFName}'=='empty'    Set To Dictionary    ${New_JSON}    firstName=${EMPTY}
    ...    ELSE IF    '${sFName}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    firstName=${sFName}

    ${New_JSON}    Run Keyword If    '${sLName}'=='null'    Set To Dictionary    ${New_JSON}    surname=${NONE}
    ...    ELSE IF    '${sLName}'==''    Set To Dictionary    ${New_JSON}    surname=${EMPTY}
    ...    ELSE IF    '${sLName}'=='Empty' or '${sLName}'=='empty'    Set To Dictionary    ${New_JSON}    surname=${EMPTY}
    ...    ELSE IF    '${sLName}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    surname=${sLName}

    ${New_JSON}    Run Keyword If    '${sCountryCode}'=='null'    Set To Dictionary    ${New_JSON}    countryCode=${NONE}
    ...    ELSE IF    '${sCountryCode}'==''    Set To Dictionary    ${New_JSON}    countryCode=${EMPTY}
    ...    ELSE IF    '${sCountryCode}'=='Empty' or '${sCountryCode}'=='empty'    Set To Dictionary    ${New_JSON}    countryCode=${EMPTY}
    ...    ELSE IF    '${sCountryCode}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    countryCode=${sCountryCode}

    ${New_JSON}    Run Keyword If    '${sLocale}'=='null'    Set To Dictionary    ${New_JSON}    locale=${NONE}
    ...    ELSE IF    '${sLocale}'==''    Set To Dictionary    ${New_JSON}    locale=${EMPTY}
    ...    ELSE IF    '${sLocale}'=='Empty' or '${sLocale}'=='empty'    Set To Dictionary    ${New_JSON}    locale=${EMPTY}
    ...    ELSE IF    '${sLocale}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    locale=${sLocale}

    ${New_JSON}    Run Keyword If    '${iContactNum1}'=='null'    Set To Dictionary    ${New_JSON}    contactNumber1=${NONE}
    ...    ELSE IF    '${iContactNum1}'==''    Set To Dictionary    ${New_JSON}    contactNumber1=${EMPTY}
    ...    ELSE IF    '${iContactNum1}'=='Empty' or '${iContactNum1}'=='empty'    Set To Dictionary    ${New_JSON}    contactNumber1=${EMPTY}
    ...    ELSE IF    '${iContactNum1}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    contactNumber1=${iContactNum1}

    ${New_JSON}    Run Keyword If    '${iContactNum2}'=='null'    Set To Dictionary    ${New_JSON}    contactNumber2=${NONE}
    ...    ELSE IF    '${iContactNum2}'==''    Set To Dictionary    ${New_JSON}    contactNumber2=${EMPTY}
    ...    ELSE IF    '${iContactNum2}'=='Empty' or '${iContactNum2}'=='empty'    Set To Dictionary    ${New_JSON}    contactNumber2=${EMPTY}
    ...    ELSE IF    '${iContactNum2}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    contactNumber2=${iContactNum2}

    ${New_JSON}    Run Keyword If    '${sEmail}'=='null'    Set To Dictionary    ${New_JSON}    email=${NONE}
    ...    ELSE IF    '${sEmail}'==''    Set To Dictionary    ${New_JSON}    email=${EMPTY}
    ...    ELSE IF    '${sEmail}'=='Empty' or '${sEmail}'=='empty'    Set To Dictionary    ${New_JSON}    email=${EMPTY}
    ...    ELSE IF    '${sEmail}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    email=${sEmail}

    ${New_JSON}    Run Keyword If    '${sOSUserID}'=='null'    Set To Dictionary    ${New_JSON}    osUserId=${NONE}
    ...    ELSE IF    '${sOSUserID}'==''    Set To Dictionary    ${New_JSON}    osUserId=${EMPTY}
    ...    ELSE IF    '${sOSUserID}'=='Empty' or '${sOSUserID}'=='empty'    Set To Dictionary    ${New_JSON}    osUserId=${EMPTY}
    ...    ELSE IF    '${sOSUserID}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    osUserId=${sOSUserID}

    ${New_JSON}    Run Keyword If    '${sCentralUserType}'=='null'    Set To Dictionary    ${New_JSON}    centralUserType=${NONE}
    ...    ELSE IF    '${sCentralUserType}'==''    Set To Dictionary    ${New_JSON}    centralUserType=${EMPTY}
    ...    ELSE IF    '${sCentralUserType}'=='Empty' or '${sCentralUserType}'=='empty'    Set To Dictionary    ${New_JSON}    centralUserType=${EMPTY}
    ...    ELSE IF    '${sCentralUserType}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    centralUserType=${sCentralUserType}

    ${centralroleslist}    Split String    ${sCentralRoles}    ,
    ${centralrole_count}    Get Length    ${centralroleslist}
    ${centralrolesVal}    Get From List    ${centralroleslist}    0
    :FOR    ${INDEX_0}    IN RANGE    ${centralrole_count}
    \    Exit For Loop If    '${INDEX_0}'=='${centralrole_count}'
    \    Log    ${New_JSON}
    \    ${centralrolesDictionary}    Create Dictionary for Multiple Same Sub-Keyfield    ${centralroleslist}    ${INDEX_0}    role
    \    ${New_JSON}    Run Keyword If    '${centralrolesVal}'=='no tag'    Set Variable    ${New_JSON}
         ...    ELSE    Set To Dictionary    ${New_JSON}    centralRoles=${centralrolesDictionary}
    Log    ${New_JSON}
   ## get lineOfBusiness field values
   ${LOB_list}    Split String    ${sLOB}    ,
   ${LOB_count}    Get Length    ${LOB_list}
   ${deBusinessEntityList}    Split String    ${sDefaultBussEntity}    ,
   ${addbusinessEntityList}    Split String    ${sAddBussEntity}    ,
   ${defprocessingAreaList}    Split String    ${sDefaultProcArea}    ,
   ${processingAreaList}    Split String    ${sAddProcArea}    ,
   ${adddepartmentCodeList}    Split String    ${sAddDept}    ,
   ${primaryDepartmentList}    Split String    ${sPrimaryDept}    ,
   ${locationlist}    Split String    ${sLocation}    ,
   ${roleslist}    Split String    ${sRoles}    ,
   ${statuslist}    Split String    ${sStatus}    ,
   ${userLockStatuslist}    Split String    ${sUserLockStatus}    ,
   ${userTypelist}    Split String    ${sUserType}    ,
   ${profileIdList}    Split String    ${sProfielID}    ,

   ##list of different sub keyfields for defaultBusinessEntity/additionalBusinessEntity
   ${defaultBusinessEntity_sublist}    Set Variable    businessEntityName,defaultBranch
    
   ### Create empty list for 'no tag' lobs###
   ${Empty_List}    Create List    
    
   ## add 'line of business' fields here
   :FOR    ${INDEX_0}    IN RANGE    ${LOB_count}
   \    Exit For Loop If    ${INDEX_0}==${LOB_count} or '${sLOB}'==''
   \    Log    ${New_JSON}
   \    ${val_LOB}    Get From List    ${LOB_list}    ${INDEX_0}
   \
   \    ##check lineOfBusiness if null or empty or have valid value
   \    ${val_LOB_0}    Run Keyword If    '${sLOB}'!=''    Get From List    ${LOB_list}    0
   \    ${val_LOB}    Run Keyword If    '${val_LOB_0}'=='lineOfBusiness=""'    Set Variable    ${EMPTY}
        ...    ELSE IF    '${val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_LOB}
   \
   \
   \    ${defaultBusinessEntityDictionary}    Create Dictionary for Single Set of Multiple Different Sub-Keyfields    ${deBusinessEntityList}    ${INDEX_0}    ${defaultBusinessEntity_sublist}
   \    ${additionalBusinessEntityDictionary}    Create Dictionary for Multiple Set of Multiple Different Sub-Keyfields    ${addbusinessEntityList}    ${INDEX_0}    ${defaultBusinessEntity_sublist}
   \    ${defaultProcessingAreaDictionary}    Create Dictionary for Single Sub-Keyfield    ${defprocessingAreaList}    ${INDEX_0}    processingArea
   \    ${additionalProcessingAreaDictionary}    Create Dictionary for Multiple Same Sub-Keyfield    ${processingAreaList}    ${INDEX_0}    processingArea
   \    ${defaultprimaryDepartmentDictionary}    Create Dictionary for Single Sub-Keyfield    ${primaryDepartmentList}    ${INDEX_0}    departmentCode
   \    ${additionalDepartmentsDictionary}    Create Dictionary for Multiple Same Sub-Keyfield    ${adddepartmentCodeList}    ${INDEX_0}    departmentCode
   \    ${rolesDictionary}    Create Dictionary for Multiple Same Sub-Keyfield    ${roleslist}    ${INDEX_0}    role
   \    ${val_loc}    Get From List    ${locationlist}    ${INDEX_0}
   \    ${val_loc}    Run Keyword If    '${val_loc}'=='null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_loc}
   \    ${val_status}    Get From List    ${statuslist}    ${INDEX_0}
   \    ${val_status}    Run Keyword If    '${val_status}'=='null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_status}
   \    ${val_userLockStatus}    Get From List    ${userLockStatuslist}    ${INDEX_0}
   \    ${val_userLockStatus}    Run Keyword If    '${val_userLockStatus}'=='null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_userLockStatus}
   \    ${val_userType}    Get From List    ${userTypelist}    ${INDEX_0}
   \    ${val_userType}    Run Keyword If    '${val_userType}'=='null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_userType}
   \    ${val_profileid}    Get From List    ${profileIdList}    ${INDEX_0}
   \    ${val_profileid}    Run Keyword If    '${val_profileid}'=='null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_profileid}
   \
   \    ${lineOfBusinessDictionary}    Create Dictionary    lineOfBusiness=${val_LOB}
        ...    defaultBusinessEntity=${defaultBusinessEntityDictionary}    additionalBusinessEntity=${additionalBusinessEntityDictionary}
        ...    defaultProcessingArea=${defaultProcessingAreaDictionary}    additionalProcessingArea=${additionalProcessingAreaDictionary}
        ...    primaryDepartment=${defaultprimaryDepartmentDictionary}    additionalDepartments=${additionalDepartmentsDictionary}    location=${val_loc}
        ...    roles=${rolesDictionary}    status=${val_status}    userLockStatus=${val_userLockStatus}    userType=${val_userType}    profileId=${val_profileId}
   \
   \    ${deBusinessEntityVal}    Run Keyword And Continue On Failure    Get From List    ${deBusinessEntityList}    ${INDEX_0}
   \    ${addbusinessEntityVal}    Run Keyword And Continue On Failure    Get From List    ${addbusinessEntityList}    ${INDEX_0}
   \    ${defprocessingAreaVal}    Run Keyword And Continue On Failure    Get From List    ${defprocessingAreaList}    ${INDEX_0}
   \    ${processingAreaVal}    Run Keyword And Continue On Failure    Get From List    ${processingAreaList}    ${INDEX_0}
   \    ${adddepartmentCodeVal}    Run Keyword And Continue On Failure    Get From List    ${adddepartmentCodeList}    ${INDEX_0}
   \    ${primaryDepartmentVal}    Run Keyword And Continue On Failure    Get From List    ${primaryDepartmentList}    ${INDEX_0}
   \    ${rolesVal}    Run Keyword And Continue On Failure    Get From List    ${roleslist}    ${INDEX_0}
   \    ${locationVal}    Run Keyword And Continue On Failure    Get From List    ${locationlist}    ${INDEX_0}
   \    ${statusVal}    Run Keyword And Continue On Failure    Get From List    ${statuslist}    ${INDEX_0}
   \    ${userLockStatusVal}    Run Keyword And Continue On Failure    Get From List    ${userLockStatuslist}    ${INDEX_0}
   \    ${userTypeVal}    Run Keyword And Continue On Failure    Get From List    ${userTypelist}    ${INDEX_0}
   \    ${profileIdVal}    Run Keyword And Continue On Failure    Get From List    ${profileIdList}    ${INDEX_0}
   \
   \    Run Keyword If    '${deBusinessEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    defaultBusinessEntity
   \    Run Keyword If    '${addbusinessEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    additionalBusinessEntity
   \    Run Keyword If    '${defprocessingAreaVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    defaultProcessingArea
   \    Run Keyword If    '${processingAreaVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    additionalProcessingArea
   \    Run Keyword If    '${adddepartmentCodeVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    additionalDepartments
   \    Run Keyword If    '${primaryDepartmentVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    primaryDepartment
   \    Run Keyword If    '${rolesVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    roles
   \    Run Keyword If    '${locationVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    location
   \    Run Keyword If    '${statusVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    status
   \    Run Keyword If    '${userLockStatusVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    userLockStatus
        ...    ELSE IF    '${userLockStatusVal}'==''    Set To Dictionary    ${lineOfBusinessDictionary}    userLockStatus=UNLOCKED
   \    Run Keyword If    '${userTypeVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    userType
   \    Run Keyword If    '${profileIdVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    profileId
   \    ${lineOfBusiness_notag}    Get From Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness
   \    Run Keyword If    '${lineOfBusiness_notag}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness
   \
   \    ${New_JSON}    Run Keyword If    '${sLOB}'=='null'    Set To Dictionary    ${New_JSON}    lobs=${NONE}
        ...    ELSE IF    '${sLOB}'=='no tag'    Set To Dictionary    ${New_JSON}    lobs=${Empty_List}
        ...    ELSE IF    '${sLOB}'==''    Set To Dictionary    ${New_JSON}    lobs=${EMPTY}
        ...    ELSE IF    '${sLOB}'=='Empty' or '${sLOB}'=='empty'    Set To Dictionary    ${New_JSON}    lobs=${EMPTY}
        ...    ELSE    Add Object To Json    ${New_JSON}    $..lobs    ${lineOfBusinessDictionary}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    Log    ${Converted_JSON}
    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}

Update Expected API Response for User API
    [Documentation]    This keyword is used to update expected API Response.
    ...    @author: jaquitan/clanding
    ...    @update: clanding    20DEC2018    - Changed userID to loginId, added profileId inside lobs, removed outside lineOfBusiness
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    22APR2019    - updated value of default business entity, primary department and default processing area to null if no tag
    ...    @update: clanding    22APR2019    - updated value of userLockStatus when input is no tag and null to UNLOCKED
    ...    @update: clanding    07MAY2019    - added handling for multiple LOB
    ...    @update: xmiranda    22JUL2019    - Updated the code for line 374. If lobs has 'not tag' value, then the JSON value for the lobs would be an Empty List[]
    ...    @update: cfrancis    21JUL2020    - updated to add activationDate field inside LOB with a value of None
    ...    @update: cfranics    24JUL2020    - added logic to remove fields from dictionary for multiple LOB if value is null
    [Arguments]    ${sFilePath}    ${sFileName}    ${sLoginID}    ${sJobTitle}    ${sFName}    ${sLName}    ${sCountryCode}    ${sLocale}    ${iContactNum1}
    ...    ${iContactNum2}    ${sEmail}    ${sOSUserID}    ${sCentralUserType}    ${sCentralRoles}    ${sLOB}    ${sDefaultBussEntity}
    ...    ${sAddBussEntity}    ${sDefaultProcArea}    ${sAddProcArea}    ${sAddDept}    ${sPrimaryDept}    ${sLocation}    ${sRoles}
    ...    ${sStatus}    ${sUserLockStatus}    ${sUserType}    ${sProfielID}

    ${file_path}    Set Variable    ${Input_File_Path_Users}${templateinput_MultipleLOB}
    ${EMPTY}    Set Variable
    ${JSON_Object}    Load JSON From File    ${file_path}

    ## add demographic fields here
    ${New_JSON}    Run Keyword If    '${sLoginID}'=='null'    Set To Dictionary    ${JSON_Object}    loginId=${NONE}
    ...    ELSE IF    '${sLoginID}'=='no tag'    Set To Dictionary    ${JSON_Object}    loginId=${NONE}
    ...    ELSE    Set To Dictionary    ${JSON_Object}    loginId=${sLoginID}

    ${New_JSON}    Run Keyword If    '${sJobTitle}'=='null'    Set To Dictionary    ${New_JSON}    jobTitle=${NONE}
    ...    ELSE IF    '${sJobTitle}'=='no tag'    Set To Dictionary    ${New_JSON}    jobTitle=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    jobTitle=${sJobTitle}

    ${New_JSON}    Run Keyword If    '${sFName}'=='null'    Set To Dictionary    ${New_JSON}    firstName=${NONE}
    ...    ELSE IF    '${sFName}'=='no tag'    Set To Dictionary    ${New_JSON}    firstName=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    firstName=${sFName}

    ${New_JSON}    Run Keyword If    '${sLName}'=='null'    Set To Dictionary    ${New_JSON}    surname=${NONE}
    ...    ELSE IF    '${sLName}'=='no tag'    Set To Dictionary    ${New_JSON}    surname=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    surname=${sLName}

    ${New_JSON}    Run Keyword If    '${sCountryCode}'=='null'    Set To Dictionary    ${New_JSON}    countryCode=${NONE}
    ...    ELSE IF    '${sCountryCode}'=='no tag'    Set To Dictionary    ${New_JSON}    countryCode=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    countryCode=${sCountryCode}

    ${New_JSON}    Run Keyword If    '${sLocale}'=='null'    Set To Dictionary    ${New_JSON}    locale=${NONE}
    ...    ELSE IF    '${sLocale}'=='no tag'    Set To Dictionary    ${New_JSON}    locale=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    locale=${sLocale}

    ${New_JSON}    Run Keyword If    '${iContactNum1}'=='null'    Set To Dictionary    ${New_JSON}    contactNumber1=${NONE}
    ...    ELSE IF    '${iContactNum1}'=='no tag'    Set To Dictionary    ${New_JSON}    contactNumber1=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    contactNumber1=${iContactNum1}

    ${New_JSON}    Run Keyword If    '${iContactNum2}'=='null'    Set To Dictionary    ${New_JSON}    contactNumber2=${NONE}
    ...    ELSE IF    '${iContactNum2}'=='no tag'    Set To Dictionary    ${New_JSON}    contactNumber2=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    contactNumber2=${iContactNum2}

    ${New_JSON}    Run Keyword If    '${sEmail}'=='null'    Set To Dictionary    ${New_JSON}    email=${NONE}
    ...    ELSE IF    '${sEmail}'=='no tag'    Set To Dictionary    ${New_JSON}    email=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    email=${sEmail}

    ${New_JSON}    Run Keyword If    '${sOSUserID}'=='null'    Set To Dictionary    ${New_JSON}    osUserId=${NONE}
    ...    ELSE IF    '${sOSUserID}'=='no tag'    Set To Dictionary    ${New_JSON}    osUserId=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    osUserId=${sOSUserID}

    ${New_JSON}    Run Keyword If    '${sCentralUserType}'=='null'    Set To Dictionary    ${New_JSON}    centralUserType=${NONE}
    ...    ELSE IF    '${sCentralUserType}'=='no tag'    Set To Dictionary    ${New_JSON}    centralUserType=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    centralUserType=${sCentralUserType}
    
    ${centralroleslist}    Split String    ${sCentralRoles}    ,
    ${centralrole_count}    Get Length    ${centralroleslist}
    :FOR    ${INDEX_0}    IN RANGE    ${centralrole_count}
    \    Exit For Loop If    '${INDEX_0}'=='${centralrole_count}'
    \    ${centralroles_val}    Get From List    ${centralroleslist}    0
    \    ${centralrolesDictionary}    Run Keyword If    '${centralroles_val}'=='no tag'    Create List
         ...    ELSE    Create Dictionary for Multiple Same Sub-Keyfield    ${centralroleslist}    ${INDEX_0}    role
    \    ${New_JSON}    Set To Dictionary    ${New_JSON}    centralRoles=${centralrolesDictionary}

   ## get lineOfBusiness field values
   ${LOB_list}    Split String    ${sLOB}    ,
   ${LOB_count}    Get Length    ${LOB_list}
   ${deBusinessEntityList}    Split String    ${sDefaultBussEntity}    ,
   ${addbusinessEntityList}    Split String    ${sAddBussEntity}    ,
   ${defprocessingAreaList}    Split String    ${sDefaultProcArea}    ,
   ${processingAreaList}    Split String    ${sAddProcArea}    ,
   ${adddepartmentCodeList}    Split String    ${sAddDept}    ,
   ${primaryDepartmentList}    Split String    ${sPrimaryDept}    ,
   ${locationlist}    Split String    ${sLocation}    ,
   ${roleslist}    Split String    ${sRoles}    ,
   ${statuslist}    Split String    ${sStatus}    ,
   ${userLockStatuslist}    Split String    ${sUserLockStatus}    ,
   ${userTypelist}    Split String    ${sUserType}    ,
   ${profileIdList}    Split String    ${sProfielID}    ,
   
   ## remove from Dictionary a demographic field value if LOB_count > 1 and the value is null
   Run Keyword If    ${LOB_Count}>1 and '${sCentralUserType}'=='no tag'    Remove From Dictionary    ${New_JSON}    centralUserType
   Run Keyword If    ${LOB_Count}>1 and '${sLocale}'=='no tag'    Remove From Dictionary    ${New_JSON}    locale
   Run Keyword If    ${LOB_Count}>1 and '${iContactNum1}'=='no tag'    Remove From Dictionary    ${New_JSON}    contactNumber1
   Run Keyword If    ${LOB_Count}>1 and '${iContactNum2}'=='no tag'    Remove From Dictionary    ${New_JSON}    contactNumber2
   Run Keyword If    ${LOB_Count}>1 and '${sEmail}'=='no tag'    Remove From Dictionary    ${New_JSON}    email
   Run Keyword If    ${LOB_Count}>1 and '${sOSUserID}'=='no tag'    Remove From Dictionary    ${New_JSON}    osUserId
   Run Keyword If    ${LOB_Count}>1 and '${centralroles_val}'=='no tag'    Remove From Dictionary    ${New_JSON}    centralRoles

   ##list of different sub keyfields for defaultBusinessEntity/additionalBusinessEntity
   ${defaultBusinessEntity_sublist}    Set Variable    businessEntityName,defaultBranch
   Set Global Variable    ${defaultBusinessEntity_sublist}
   ${Empty_List}    Create List 
   ## add 'line of business' fields here
   :FOR    ${INDEX_0}    IN RANGE    ${LOB_count}
   \    Exit For Loop If    ${INDEX_0}==${LOB_count}
   \    Log    ${New_JSON}
   \    ${val_LOB}    Get From List    ${LOB_list}    ${INDEX_0}
   \
   \    ##check lineOfBusiness if null or empty or have valid value
   \    ${val_LOB_0}    Run Keyword If    '${sLOB}'!=''    Get From List    ${LOB_list}    0
   \    ${val_LOB}    Run Keyword If    '${val_LOB_0}'=='lineOfBusiness=""'    Set Variable    ${EMPTY}
        ...    ELSE IF    '${val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_LOB}
   \
   \    ${deBusinessEntityVal}    Run Keyword And Continue On Failure    Get From List    ${deBusinessEntityList}    ${INDEX_0}
   \    ${defaultBusinessEntityDictionary}    Run Keyword If    '${deBusinessEntityVal}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Create Dictionary for Single Set of Multiple Different Sub-Keyfields    ${deBusinessEntityList}    ${INDEX_0}    ${defaultBusinessEntity_sublist}
   \
   \    ${addbusinessEntityVal}    Run Keyword And Continue On Failure    Get From List    ${addbusinessEntityList}    ${INDEX_0}
   \    ${additionalBusinessEntityDictionary}    Run Keyword If    '${addbusinessEntityVal}'=='no tag'    Create List
        ...    ELSE    Create Dictionary for Multiple Set of Multiple Different Sub-Keyfields    ${addbusinessEntityList}    ${INDEX_0}    ${defaultBusinessEntity_sublist}
   \
   \    ${defprocessingAreaVal}    Run Keyword And Continue On Failure    Get From List    ${defprocessingAreaList}    ${INDEX_0}
   \    ${defaultProcessingAreaDictionary}    Run Keyword If    '${defprocessingAreaVal}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Create Dictionary for Single Sub-Keyfield    ${defprocessingAreaList}    ${INDEX_0}    processingArea
   \
   \    ${processingAreaVal}    Run Keyword And Continue On Failure    Get From List    ${processingAreaList}    ${INDEX_0}
   \    ${additionalProcessingAreaDictionary}    Run Keyword If    '${processingAreaVal}'=='no tag'    Create List
        ...    ELSE    Create Dictionary for Multiple Same Sub-Keyfield    ${processingAreaList}    ${INDEX_0}    processingArea
   \
   \    ${primaryDepartmentVal}    Run Keyword And Continue On Failure    Get From List    ${primaryDepartmentList}    ${INDEX_0}
   \    ${defaultprimaryDepartmentDictionary}    Run Keyword If    '${primaryDepartmentVal}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Create Dictionary for Single Sub-Keyfield    ${primaryDepartmentList}    ${INDEX_0}    departmentCode
   \
   \    ${adddepartmentCodeVal}    Run Keyword And Continue On Failure    Get From List    ${adddepartmentCodeList}    ${INDEX_0}
   \    ${additionalDepartmentsDictionary}    Run Keyword If    '${adddepartmentCodeVal}'=='no tag'    Create List
        ...    ELSE    Create Dictionary for Multiple Same Sub-Keyfield    ${adddepartmentCodeList}    ${INDEX_0}    departmentCode
   \
   \    ${rolesVal}    Get From List    ${roleslist}    ${INDEX_0}
   \    ${rolesDictionary}    Run Keyword If    '${rolesVal}'=='no tag'    Create List
        ...    ELSE    Create Dictionary for Multiple Same Sub-Keyfield    ${roleslist}    ${INDEX_0}    role
   \
   \    ${val_loc}    Get From List    ${locationlist}    ${INDEX_0}
   \    ${new_val_loc}    Run Keyword If    '${val_loc}'=='null'    Set Variable    ${NONE}
        ...    ELSE IF    '${val_loc}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_loc}
   \
   \    ${val_status}    Get From List    ${statuslist}    ${INDEX_0}
   \    ${new_val_status}    Run Keyword If    '${val_status}'=='null'    Set Variable    ${NONE}
        ...    ELSE IF    '${val_status}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_status}
   \
   \    ${val_userLockStatus}    Get From List    ${userLockStatuslist}    ${INDEX_0}
   \    ${new_val_userLockStatus}    Run Keyword If    '${val_userLockStatus}'=='null'    Set Variable    UNLOCKED
        ...    ELSE IF    '${val_userLockStatus}'=='no tag'    Set Variable    UNLOCKED
        ...    ELSE IF    '${val_userLockStatus}'==''    Set Variable    UNLOCKED
        ...    ELSE    Set Variable    ${val_userLockStatus}
   \
   \    ${val_userType}    Get From List    ${userTypelist}    ${INDEX_0}
   \    ${new_val_userType}    Run Keyword If    '${val_userType}'=='null'    Set Variable    ${NONE}
        ...    ELSE IF    '${val_userType}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_userType}
   \
   \    ${val_profileId}    Get From List    ${profileIdList}    ${INDEX_0}
   \    ${new_val_profileId}    Run Keyword If    '${val_profileId}'=='null'    Set Variable    ${NONE}
        ...    ELSE IF    '${val_profileId}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_profileId}
   \
   \    ${lineOfBusinessDictionary}    Create Dictionary    activationDate=${NONE}    lineOfBusiness=${val_LOB}
        ...    defaultBusinessEntity=${defaultBusinessEntityDictionary}    additionalBusinessEntity=${additionalBusinessEntityDictionary}
        ...    defaultProcessingArea=${defaultProcessingAreaDictionary}    additionalProcessingArea=${additionalProcessingAreaDictionary}
        ...    primaryDepartment=${defaultprimaryDepartmentDictionary}    additionalDepartments=${additionalDepartmentsDictionary}    location=${new_val_loc}
        ...    roles=${rolesDictionary}    status=${new_val_status}    userLockStatus=${new_val_userLockStatus}    userType=${new_val_userType}
        ...    profileId=${new_val_profileId}
   \
   \    Run Keyword If    ${LOB_Count}>1    Remove From Dictionary    ${lineOfBusinessDictionary}    activationDate
   \    Run Keyword If    ${LOB_Count}>1 and '${addbusinessEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    additionalBusinessEntity
   \    Run Keyword If    ${LOB_Count}>1 and '${defprocessingAreaVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    defaultProcessingArea
   \    Run Keyword If    ${LOB_Count}>1 and '${processingAreaVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    additionalProcessingArea
   \    Run Keyword If    ${LOB_Count}>1 and '${primaryDepartmentVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    primaryDepartment
   \    Run Keyword If    ${LOB_Count}>1 and '${adddepartmentCodeVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    additionalDepartments
   \    Run Keyword If    ${LOB_Count}>1 and '${new_val_loc}'=='${NONE}'    Remove From Dictionary    ${lineOfBusinessDictionary}    location
   \    Run Keyword If    ${LOB_Count}>1 and '${new_val_profileId}'=='${NONE}'    Remove From Dictionary    ${lineOfBusinessDictionary}    profileId
   \	Run Keyword If    ${LOB_Count}>1 and '${val_userLockStatus}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    userLockStatus
   \    Run Keyword If    ${LOB_Count}>1 and '${val_userType}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    userType
   \	Run Keyword If    ${LOB_Count}>1 and '${deBusinessEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    defaultBusinessEntity
   \	Run Keyword If    ${LOB_Count}>1 and '${rolesVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    roles
   \
   \    ${New_JSON}    Run Keyword If    '${sLOB}'=='null'    Set To Dictionary    ${New_JSON}    lobs=${NONE}
        ...    ELSE IF    '${sLOB}'=='no tag'    Set To Dictionary    ${New_JSON}    lobs=${Empty_List}
        ...    ELSE IF    '${sLOB}'==''    Set To Dictionary    ${New_JSON}    lobs=${EMPTY}
        ...    ELSE IF    '${sLOB}'=='Empty' or '${sLOB}'=='empty'    Set To Dictionary    ${New_JSON}    lobs=${EMPTY}
        ...    ELSE    Add Object To Json    ${New_JSON}    $..lobs    ${lineOfBusinessDictionary}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    Log    ${Converted_JSON}
    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}

Get 3-code country from the input 2-code country
    [Documentation]    This keyword is used to get the 3-code of the corresponding 2-code country from the input json.
    ...    @author: clanding/jaquitan
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @Update: dahijara    04OCT2019    - Updated code for getting value for 2-code country as the Get Row Values no longer returns the cell ID
    [Arguments]    ${sCountryCode_3Code}

    Open Excel    ${Countries_Codes}
    ${rowcount}    Get Row Count    countries_codes
    ${INDEX}    Set Variable    0
    ${rowval_list}    Create List
    ${rowval_dict}    Create Dictionary
    :FOR    ${INDEX}    IN RANGE    ${rowcount}
    \    ${rowvalues}    Get Row Values    countries_codes    ${INDEX}
    \    Log    ${rowvalues}
    # \    ${alpha3code}    Get From List    ${rowvalues}    0
    # \    ${Key}    Get From List    ${alpha3code}     1
    \    ${Key}    Get From List    ${rowvalues}    0
    \    ${Key}    Strip String    ${Key}    mode=both    characters=${SPACE}
    # \    ${alpha2code}    Get From List    ${rowvalues}    1
    # \    ${Val}    Get From List    ${alpha2code}     1
    \    ${Val}    Get From List    ${rowvalues}    1
    \    ${Val}    Strip String    ${Val}    mode=both    characters=${SPACE}
    \    Set To Dictionary    ${rowval_dict}    key=value    ${Key}=${Val}
    \    Append To List    ${rowval_list}    ${rowvalues}
    Log    ${rowval_list}
    Log    ${rowval_dict}
    
    
    ${dictionary_create}    Run Keyword And Return Status    Get From Dictionary    ${rowval_dict}    ${sCountryCode_3Code}
    ${sCountryCode_2Code}    Run Keyword If    ${dictionary_create}==True    Get From Dictionary    ${rowval_dict}    ${sCountryCode_3Code}
    ...    ELSE    Substring Country Code    ${sCountryCode_3Code}
    Close Current Excel Document
    [Return]    ${sCountryCode_2Code}

Get Country Desc from the input 2-code country
    [Documentation]    This keyword is used to get the 3-code of the corresponding 2-code country from the input json.
    ...    @author: clanding/jaquitan
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @Update: dahijara    04OCT2019    - Updated code for getting value for 2-code country description as the Get Row Values no longer returns the cell ID
    [Arguments]    ${sCountryCode_3Code}

    Open Excel    ${Countries_Codes}
    ${rowcount}    Get Row Count    countries_codes
    ${INDEX}    Set Variable    0
    ${rowval_list}    Create List
    ${rowval_dict}    Create Dictionary
    :FOR    ${INDEX}    IN RANGE    ${rowcount}
    \    ${rowvalues}    Get Row Values    countries_codes    ${INDEX}
    \    Log    ${rowvalues}
    # \    ${alpha3code}    Get From List    ${rowvalues}    0
    # \    ${Key}    Get From List    ${alpha3code}     1
    \    ${Key}    Get From List    ${rowvalues}    0
    \    ${Key}    Strip String    ${Key}    mode=both    characters=${SPACE}
    # \    ${countrydesc}    Get From List    ${rowvalues}    2
    # \    ${Val}    Get From List    ${countrydesc}     1
    \    ${Val}    Get From List    ${rowvalues}    2
    \    Set To Dictionary    ${rowval_dict}    key=value    ${Key}=${Val}
    \    Append To List    ${rowval_list}    ${rowvalues}
    \    Exit For Loop If    '${INDEX}'=='${rowcount}'
    Log    ${rowval_list}
    Log    ${rowval_dict}

    #${countrydesc}    Get From Dictionary    ${rowval_dict}    ${sCountryCode_3Code}
    ${dictionary_create}    Run Keyword And Return Status    Get From Dictionary    ${rowval_dict}    ${sCountryCode_3Code}
    ${countrydesc}    Run Keyword If    ${dictionary_create}==True    Continue Get Country Desc from the input 2-code country    ${rowval_dict}    ${sCountryCode_3Code}
    ...    ELSE    Substring Country Desc    ${sCountryCode_3Code}
    Close Current Excel Document
    [Return]    ${countrydesc}

Get Job Function Code from Config Setup
    [Documentation]    This keyword is used to get corresponding Job Function Code from the config setup of the SSO roles value from the input payload
    ...    After getting the corresponding Job Function code, it will get the Job Function Description from Table Maintenance.
    ...    @author: clanding/jaquitan
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: xmiranda    23JUL2019    - Replaced "True" and "False" with Boolean Variables ${True} and ${False}
    [Arguments]    ${input_roleslist}    ${INDEX}
    ${JobFunction}    OperatingSystem.Get File    ${JobFunction_Config}
    ${JobFunction_count}    Get Line Count    ${JobFunction}
    ${JobFunctionDict}    Create Dictionary
    ${i}    Set Variable    0
    :FOR    ${i}    IN RANGE    ${JobFunction_count}
    \    ${JobFunctionconfig}    Get Line    ${JobFunction}    ${i}
    \    ${JobFunctionconfiglist}    Split String    ${JobFunctionconfig}    =
    \    ${Key}    Get From List    ${JobFunctionconfiglist}    0
    \    ${value}    Get From List    ${JobFunctionconfiglist}    1
    \    Set To Dictionary    ${JobFunctionDict}    ${Key}=${value}
    \    Exit For Loop If    '${i}'=='${JobFunction_count}'
    Log    ${JobFunctionDict}

    ${rolelist}    Split String    ${input_roleslist}    ,
    ${LOB_Role}    Get From List    ${rolelist}    ${INDEX}
    ${LOB_RoleList}    Split String    ${LOB_Role}    /
    ${role_count}    Get Length    ${LOB_RoleList}
    ${i}    Set Variable    0
    ${LIQ_JobFunctionList}    Create List
    :FOR    ${i}    IN RANGE    ${role_count}
    \    ${jobfunction_val}    Get From List    ${LOB_RoleList}    ${i}
    \    ${dictionary_create}    Run Keyword And Return Status    Get From Dictionary    ${JobFunctionDict}    ${jobfunction_val}
    \    Run Keyword If    ${dictionary_create}==${False}    Log    No role matched
    \    ${LIQ_JobFunction}    Run Keyword If    ${dictionary_create}==True    Get From Dictionary    ${JobFunctionDict}    ${jobfunction_val}
    \    Run Keyword If     ${dictionary_create}==${True}   Append To List    ${LIQ_JobFunctionList}    ${LIQ_JobFunction}
    \    Exit For Loop If    '${i}'=='${role_count}'
    [Return]    ${LIQ_JobFunctionList}

Update Expected XML Elements for wsFinalLIQDestination
    [Documentation]    This keyword is used to update XML Elements using the input json values for wsFinalLIQDestination.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - Changed userID to loginId, changed value of ${userProfileRID} from userID to profileId
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    22APR2019    - added handling for userLockStatus if value is no tag, null or empty
    [Arguments]    ${sFilePath}    ${sFileName}    ${sHTTPMethodType}    ${sLoginID}    ${sOSUserID}    ${sUserLockStatus}    ${sProfielID}
    ...    ${INDEX}

    ${Expected_wsFinalLIQDestination}    Set Variable    ${dataset_path}${sFilePath}${sFileName}.xml
    ${Template}    Run Keyword If    '${sHTTPMethodType}'=='POST'    Set Variable    ${Input_File_Path_Users}wsFinalLIQDestination_template_post.xml
    ...    ELSE IF    '${sHTTPMethodType}'=='PUT'    Set Variable    ${Input_File_Path_Users}wsFinalLIQDestination_template_put.xml
    ...    ELSE    Set Variable    ${Input_File_Path_Users}wsFinalLIQDestination_template_post.xml
    Delete File If Exist    ${Expected_wsFinalLIQDestination}

    ${XPath}    Run Keyword If    '${sHTTPMethodType}'=='POST'    Set Variable    ${XML_CreateUserSecurityProfile}
    ...    ELSE IF    '${sHTTPMethodType}'=='PUT' or '${sHTTPMethodType}'=='DELETE'    Set Variable    ${XML_UpdateUserSecurityProfile}
    ...    ELSE    Set Variable    CreateUserSecurityProfile

    ${userProfileRID}    Convert To Uppercase    ${sProfielID}
    ${userLoginID}    Convert To Uppercase    ${sLoginID}

    ${userLockStatus_list}    Split String    ${sUserLockStatus}    ,
    ${userLockStatus_val}    Get From List    ${userLockStatus_list}    ${INDEX}

    ${Updated_Template}    Set Element Attribute    ${Template}    userProfileRID    ${userProfileRID}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    loginId    ${userLoginID}    xpath=${XPath}
    ${Updated_Template}    Run Keyword If    '${sOSUserID}'=='no tag' or '${sOSUserID}'=='null'    Set Element Attribute    ${Updated_Template}    osUserId    ${sLoginID}    xpath=${XPath}
    ...    ELSE    Set Element Attribute    ${Updated_Template}    osUserId    ${sOSUserID}    xpath=${XPath}
    ${Updated_Template}    Run Keyword If    '${userLockStatus_val}'=='' or '${userLockStatus_val}'=='UNLOCKED'    Set Element Attribute    ${Updated_Template}    lockedIndication    N    xpath=${XPath}
    ...    ELSE IF    '${userLockStatus_val}'=='LOCKED'    Set Element Attribute    ${Updated_Template}    lockedIndication    Y    xpath=${XPath}
    ...    ELSE    Set Element Attribute    ${Updated_Template}    lockedIndication    N    xpath=${XPath}

    ${attr}    XML.Get Element Attributes    ${Updated_Template}    ${XPath}
    Save Xml    ${Updated_Template}    ${Expected_wsFinalLIQDestination}

Update Expected XML Elements for wsLIQUserDestination
    [Documentation]    This keyword is used to update XML Elements using the input json values for wsLIQUserDestination.
    ...    @author: clanding
    ...    @update: clanding    20DEC2018    - Changed userID to profileId
    ...    @update: clanding    05APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    25APR2019    - removing getting of job function code in the config, as per Allan for CBA config
    [Arguments]    ${sFilePath}    ${sFileName}    ${sHTTPMethodType}    ${sLoginID}    ${sJobTitle}    ${sFName}    ${sLName}    ${sLocale}    ${iContactNum1}    ${iContactNum2}    ${sEmail}
    ...    ${sDefaultBussEntity}    ${sDefaultProcArea}    ${sAddProcArea}    ${sPrimaryDept}    ${sLocation}    ${sStatus}    ${sProfielID}    ${sCountryCode_2Code}    ${LIQ_JobFunctionCode}    ${INDEX}

    ${Expected_wsLIQUserDestination}    Set Variable    ${dataset_path}${sFilePath}${sFileName}.xml
    ${Template}    Run Keyword If    '${sHTTPMethodType}'=='POST'    Set Variable    ${Input_File_Path_Users}wsLIQUserDestination_template_post.xml
    ...    ELSE IF    '${sHTTPMethodType}'=='PUT' or '${sHTTPMethodType}'=='DELETE'    Set Variable    ${Input_File_Path_Users}wsLIQUserDestination_template_put.xml
    ...    ELSE    Set Variable    ${Input_File_Path_Users}wsLIQUserDestination_template_post.xml
    Delete File If Exist    ${Expected_wsLIQUserDestination}

    ${XPath}    Run Keyword If    '${sHTTPMethodType}'=='POST'    Set Variable    CreateUserProfile
    ...    ELSE IF    '${sHTTPMethodType}'=='PUT' or '${sHTTPMethodType}'=='DELETE'    Set Variable    UpdateUserProfile
    ...    ELSE    Set Variable    CreateUserProfile
    ${xpath_Dept}    Run Keyword If    '${sHTTPMethodType}'=='POST'    Set Variable    */CreateUserDepartments/CreateDepartment
    ...    ELSE IF    '${sHTTPMethodType}'=='PUT' or '${sHTTPMethodType}'=='DELETE'    Set Variable    */UpdateUserDepartments/UpdateDepartment
    ...    ELSE    Set Variable    */CreateUserDepartments/CreateDepartment
    ${xpath_Proc}    Run Keyword If    '${sHTTPMethodType}'=='POST'    Set Variable    */CreateUserSecondaryProcessingAreas/CreateSecondaryProcessingArea
    ...    ELSE IF    '${sHTTPMethodType}'=='PUT' or '${sHTTPMethodType}'=='DELETE'    Set Variable    */UpdateUserSecondaryProcessingAreas/UpdateSecondaryProcessingArea
    ...    ELSE    Set Variable    */CreateUserSecondaryProcessingAreas/CreateSecondaryProcessingArea
    ${xpath_SecondaryProc}    Run Keyword If    '${sHTTPMethodType}'=='POST'    Set Variable    *CreateUserSecondaryProcessingAreas
    ...    ELSE IF    '${sHTTPMethodType}'=='PUT' or '${sHTTPMethodType}'=='DELETE'    Set Variable    *UpdateUserSecondaryProcessingAreas
    ...    ELSE    Set Variable    *CreateUserSecondaryProcessingAreas

    ${ID}    Convert To Uppercase    ${sProfielID}
    ${loginID}    Convert To Uppercase    ${sLoginID}
    ${Language}    Convert To Uppercase    ${sLocale}

    ${defaultBusinessEntity_List}    Split String    ${sDefaultBussEntity}    ,
    ${defaultBusinessEntity_ValList}    Get From List    ${defaultBusinessEntity_List}    ${INDEX}
    ${defaultBusinessEntity_ValList}    Split String    ${defaultBusinessEntity_ValList}    |
    ${defaultBranch_val}    Get From List    ${defaultBusinessEntity_ValList}    1

    ${defaultProcessingArea_List}    Split String    ${sDefaultProcArea}    ,
    ${processingArea_val}    Get From List    ${defaultProcessingArea_List}    ${INDEX}

    ${location_list}    Split String    ${sLocation}    ,
    ${location_val}    Get From List    ${location_list}    ${INDEX}

    ${status_list}    Split String    ${sStatus}    ,
    ${status_val}    Get From List    ${status_list}    ${INDEX}

    ${primaryDepartmentCode_list}    Split String    ${sPrimaryDept}    ,
    ${primaryDepartmentCode_val}    Get From List    ${primaryDepartmentCode_list}    ${INDEX}

    ${Updated_Template}    Set Element Attribute    ${Template}    id    ${ID}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    branch    ${defaultBranch_val}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    countryCode    ${sCountryCode_2Code}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    firstName    ${sFName}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    jobFunctionCode    ${LIQ_JobFunctionCode}    xpath=${XPath}
    ${Updated_Template}    Run Keyword If    '${Language}'=='no tag' or '${Language}'=='null'    Set Element Attribute    ${Updated_Template}    languageCode    EN    xpath=${XPath}
    ...    ELSE    Set Element Attribute    ${Updated_Template}    languageCode    ${Language}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    lastName    ${sLName}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    processingAreaCode    ${processingArea_val}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    titleCode    ${sJobTitle}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    eMailId    ${sEmail}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    phoneNumber1    ${iContactNum1}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    phoneNumber2    ${iContactNum2}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    salesTeamCode    ${LIQ_JobFunctionCode}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    locationId    ${location_val}    xpath=${XPath}
    ${userStatus}    Run Keyword If    '${status_val}'=='ACTIVE'    Set Variable    U
    ...    ELSE IF    '${status_val}'=='INACTIVE'    Set Variable    I
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    userStatus    ${userStatus}    xpath=${XPath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    departmentName    ${primaryDepartmentCode_val}    xpath=${xpath_Dept}
    ${primDept_stat}    Run Keyword And Return Status    Should Be Empty    ${primaryDepartmentCode_val}
    ${primaryDeptInd}    Run Keyword If    ${primDept_stat}==True    Set Variable    N
    ...    ELSE    Set Variable    Y
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    primaryDeptInd    ${primaryDeptInd}    xpath=${xpath_Dept}
    ${Updated_Template}    Run Keyword If    '${sHTTPMethodType}'=='PUT'    Set Element Attribute    ${Updated_Template}    loginId    ${loginID}    xpath=${XPath}
    ...    ELSE    Set Variable    ${Updated_Template}

    ${additionalProcessingArea_list}    Split String    ${sAddProcArea}    ,
    ${additionalProcessingArea_val}    Get From List    ${additionalProcessingArea_list}    ${INDEX}
    ${additionalProcessingArea_vallist}    Split String    ${additionalProcessingArea_val}    /
    ${additionalProcessingArea_Count}    Get Length    ${additionalProcessingArea_vallist}
    ${INDEX_0}    Set Variable    0
    :FOR    ${INDEX_0}    IN RANGE    ${additionalProcessingArea_Count}
    \    Exit For Loop If    '${INDEX_0}'==${additionalProcessingArea_Count}
    \    ${additionalProcessingArea}    Get From List    ${additionalProcessingArea_vallist}    ${INDEX_0}
    \    ${processingAreaCode}    Run Keyword If    '${sHTTPMethodType}'=='POST' or '${sHTTPMethodType}'==''    Catenate    SEPARATOR=
         ...    <CreateSecondaryProcessingArea version='1.0' processingAreaCode='    ${additionalProcessingArea}    ' />
         ...    ELSE IF    '${sHTTPMethodType}'=='PUT'    Catenate    SEPARATOR=
         ...    <UpdateSecondaryProcessingArea version='1.0' deleteIndicator='N' processingAreaCode='    ${additionalProcessingArea}    ' />
    \    Run Keyword If    '${additionalProcessingArea}'=='null'    Remove Element Attribute    ${Updated_Template}    processingAreaCode    xpath=${xpath_Proc}
         ...    ELSE IF    '${additionalProcessingArea}'=='no tag'    Remove Element Attribute    ${Updated_Template}    processingAreaCode    xpath=${xpath_Proc}
         ...    ELSE IF    '${INDEX_0}'=='0'    Set Element Attribute    ${Updated_Template}    processingAreaCode    ${additionalProcessingArea}    xpath=${xpath_Proc}
         ...    ELSE IF    ${INDEX_0}>0    Add Element    ${Updated_Template}    ${processingAreaCode}    xpath=${xpath_SecondaryProc}

    Save Xml    ${Updated_Template}    ${Expected_wsLIQUserDestination}

Get LOB Application from Input and Return Index
    [Documentation]    This keyword is used to get Line Of Business value from the input and return index of sExpectedLOB.
    ...    @author: clanding    05APR2019    - initial create
    [Arguments]    ${sLOB_From_Excel}    ${sExpectedLOB}
    
    ${LOB_List}    Split String    ${sLOB_From_Excel}    ,
    ${LOB_Count}    Get Length    ${LOB_List}
    ${INDEX}    Set Variable    0
    :FOR    ${INDEX}    IN RANGE    ${LOB_Count}
    \    ${LOB_Value}    Get From List    ${LOB_List}    ${INDEX}
    \    Exit For Loop If    '${LOB_Value}'=='${sExpectedLOB}'
    [Return]    ${INDEX}

Get LOB Application from Input and Validate If User is Already Existing in the Application
    [Documentation]    This keyword is used to get LOB value from dataset and verify if User is already existing in the application 'Validate User ID if existing in SSO' keyword.
    ...    @author: clanding    11APR2019    - initial create
    [Arguments]    ${sLOB_From_Excel}
    
    ${LOB_List}    Split String    ${sLOB_From_Excel}    ,
    ${LOB_Count}    Get Length    ${LOB_List}
    ${INDEX}    Set Variable    0
    :FOR    ${INDEX}    IN RANGE    ${LOB_Count}
    \    ${LOB_Value}    Get From List    ${LOB_List}    ${INDEX}
    \    ${LOBS_INPUT_EXIST}    Run Keyword And Return Status    Should Contain    ${SSO_GLOBAL_LOB}    ${LOB_Value}
    \    Run Keyword If    ${LOBS_INPUT_EXIST}==True    Fail    Input user for '${LOB_Value}' already exists in corresponding application. Update user will not support this.
         ...    ELSE    Log    Input user for '${LOB_Value}' does not yet exist. Insert will proceed.
    Set Global Variable    ${LOBS_INPUT_EXIST}

Create Prerequisites for COMRLENDING
    [Documentation]    This keyword is used to create expected wsFinalLIQDestination and wsLIQUserDestination XML and get Job Function Code for LIQ validation.
    ...    @author: clanding    15APR2019    - initial create
    ...    @update: clanding    25APR2019    - removing getting of job function code in the config, as per Allan for CBA config
    ...    @update: clanding    07MAY2019    - added handling Profile ID with multiple values
    [Arguments]    ${sFilePath}    ${sFileName_wsFinalLIQDestination}    ${sFileName_wsLIQUserDestination}    ${sHTTPMethodType}    ${sLoginID}    
    ...    ${sJobTitle}    ${sFName}    ${sLName}    ${sLocale}    ${iContactNum1}    ${iContactNum2}    ${sEmail}    ${sDefaultBussEntity}
    ...    ${sDefaultProcArea}    ${sAddProcArea}    ${sPrimaryDept}    ${sLocation}    ${sStatus}    ${sProfielID}    ${sOSUserID}    ${sUserLockStatus}
    ...    ${sRoles}    ${sCountryCode_2Code}    ${Index_COMRLENDING}
    
    ${ProfileID_List}    Split String    ${sProfielID}    ,
    ${ProfileID_Val}    Get From List    ${ProfileID_List}    ${Index_COMRLENDING}
    
    ${Roles_List}    Split String    ${sRoles}    ,
    ${Roles_Val}    Get From List    ${Roles_List}    ${Index_COMRLENDING}
    
    Run Keyword If    '${Index_COMRLENDING}'!=''    Update Expected XML Elements for wsFinalLIQDestination    ${sFilePath}    ${sFileName_wsFinalLIQDestination}    ${sHTTPMethodType}
    ...    ${sLoginID}    ${sOSUserID}    ${sUserLockStatus}    ${ProfileID_Val}    ${Index_COMRLENDING}
    
    Run Keyword If    '${Index_COMRLENDING}'!=''    Update Expected XML Elements for wsLIQUserDestination    ${sFilePath}    ${sFileName_wsLIQUserDestination}    ${sHTTPMethodType}
    ...    ${sLoginID}    ${sJobTitle}    ${sFName}    ${sLName}    ${sLocale}    ${iContactNum1}    ${iContactNum2}    ${sEmail}    ${sDefaultBussEntity}    ${sDefaultProcArea}
    ...    ${sAddProcArea}    ${sPrimaryDept}    ${sLocation}    ${sStatus}    ${ProfileID_Val}    ${sCountryCode_2Code}    ${Roles_Val}    ${Index_COMRLENDING}

Create Expected Error Message for User API
    [Documentation]    This keyword is used to process fields with invalid input for minimum field length and save expected error message.
    ...    @author:jaquitan/chanario
    ...    @update: clanding    20DEC2018    - Changed userID to loginId, changed loginId min/max to 2/20, added profileId,
    ...                                      - changed Get keyword for lineOfBusiness to 'Get Data from JSON Object and Handle Single Data'
    ...    @update: clanding    23APR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${InputFilePath}    ${InputJSONFile}
    
    Delete File If Exist    ${EXPECTED_ERROR_LIST}
    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    loginId    2    20    
    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_LoginID
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_LoginID
    
    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    firstName    1   20    
    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_FirstName
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_FirstName

    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    surname    1    20    
    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_SurName
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_SurName
    
    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    contactNumber1    5    40    
    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_ContactNumber1
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_ContactNumber1

    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    contactNumber2    5    40    
    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_ContactNumber2
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_ContactNumber2
    
    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    countryCode    3    3    
        Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_CountryCode
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_CountryCode
    
    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    locale    2    10    
        Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Locale
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Locale
    
    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    jobTitle    2    20    
        Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_JobTitle
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_JobTitle
    
    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    email    5    80    
        Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Email    
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Email
    
    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    osUserId    1    30    
        Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_OsUserId
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_OsUserId
    
     ${centralRoles}    Get Data from JSON file and handle list data    ${dataset_path}${InputFilePath}${InputJSONFile}.json    centralRoles 
    :FOR   ${role}   IN  @{centralRoles}
    \   Log  ${role}
    \   ${Val}    ${Key}    Get Data from JSON Object and Handle Single Data    ${role}    $..role    1    20
    \    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Role
         ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Role
    
    ${Val}    ${Key}    Get Data From JSON File and Handle Single Data   ${dataset_path}${InputFilePath}${InputJSONFile}.json    centralUserType    1    2    
        Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_CentralUserType
    ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_CentralUserType
    
    ${lobs}    Get Data from JSON file and handle list data    ${dataset_path}${InputFilePath}${InputJSONFile}.json    lobs    
    :FOR   ${lob}   IN  @{lobs}
    \   Log  ${lob}
    \   ${Val}    ${Key}    Get Data from JSON Object and Handle Single Data with inner field name    ${lob}    $..defaultBusinessEntity    businessEntityName    2    20
    \    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_BusinessEntityName
         ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_BusinessEntityName 
    \   ${Val}    ${Key}    Get Data from JSON Object and Handle Single Data with inner field name    ${lob}    $..defaultBusinessEntity    defaultBranch    2    10
    \    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_DefaultBranch
         ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_DefaultBranch
    \    
    \    @{additionalBusinessEntity}=    Get Data from JSON object and handle list data    ${lob}    additionalBusinessEntity    
    \    Handle AdditionalBusinessEntity    @{additionalBusinessEntity} 
    \
    \   ${Val}    ${Key}    Get Data from JSON Object and Handle Single Data with inner field name    ${lob}    $..defaultProcessingArea    processingArea    2    5
    \    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_ProcessingAreaCode
         ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_ProcessingAreaCode
    \
    \    @{additionalProcessingArea}=    Get Data from JSON object and handle list data    ${lob}    additionalProcessingArea    
    \    Handle AdditionalProcessingArea    @{additionalProcessingArea} 
    \
    \   ${Val}    ${Key}    Get Data from JSON Object and Handle Single Data with inner field name    ${lob}    $..primaryDepartment    departmentCode    1    5
    \    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_DepartmentCode
         ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_DepartmentCode
    \
    \    @{additionalDepartments}=    Get Data from JSON object and handle list data    ${lob}    additionalDepartments    
    \    Handle AdditionalDepartments    @{additionalDepartments} 
    \
    \   ${Val}    ${Key}    Get Data from JSON Object and Handle Single Data    ${lob}    $..location    1    20
    \    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Location
         ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Location
    \
    \    @{roles}=    Get Data from JSON object and handle list data    ${lob}    roles    
    \    Handle Roles    @{roles} 
    \
    \   ${Val}    ${Key}    Get Data from JSON Object and Handle Single Data    ${lob}    $..status    1    10
    \    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Status
         ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Status
    \
    \   ${Val}    ${Key}    Get Data from JSON Object and Handle Single Data    ${lob}    $..userType    1    2
    \    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_Type
         ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_Type    
    \
    \   ${Val}    ${Key}    Get Data from JSON Object and Handle Single Data    ${lob}    $..profileId    2    20
    \    Run Keyword If    ${Val}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    2    User_ProfileId
         ...    ELSE IF    ${Key}==True    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${Err_Master_List}    1    User_ProfileId

Create Query for Essence Branch and Return
    [Documentation]    This keyword is used to create sql query for Branch in Essence and return query.
    ...    @author: clanding    14MAY2019    - initial create
    ...    @update: jdelacru    16MAY2019    - Updated Name for connecting AU database for essence specific
    [Arguments]    ${sBranch}
    
    ${QUERY_BASE_HOLDING}    Catenate    ${SELECT_Q} ${BFBRANCHNAME} ${FROM_Q} ${BFBANKFUSION_USER}.${BFTB_BRANCH_TABLE} ${WHERE_Q} ${BFBRANCHSORTCODEPK} = '${sBranch}'
    ${BFBRANCHNAME_DB_Result}    Connect to Essence AU Database and Execute Query and Return List    ${QUERY_BASE_HOLDING}
    ${BFBRANCHNAME_DB_Result_0}    Get From List    ${BFBRANCHNAME_DB_Result}    0
    ${BFBRANCHNAME_DB}    Get From List    ${BFBRANCHNAME_DB_Result_0}    0
    
    [Return]    ${BFBRANCHNAME_DB}
    
Create Query for Party Branch and Return
    [Documentation]    This keyword is used to create sql query for Branch in Party and return query.
    ...    @author: jdelecru    16MAY2019    - initial create
    [Arguments]    ${sBranch}
    
    ${QUERY_BASE_HOLDING}    Catenate    ${SELECT_Q} ${BFBRANCHNAME} ${FROM_Q} ${AUBANKFUSION_USER}.${BFTB_BRANCH_TABLE} ${WHERE_Q} ${BFBRANCHSORTCODEPK} = '${sBranch}'
    ${BFBRANCHNAME_DB_Result}    Connect to Party Database and Execute Query and Return List    ${QUERY_BASE_HOLDING}
    ${BFBRANCHNAME_DB_Result_0}    Get From List    ${BFBRANCHNAME_DB_Result}    0
    ${BFBRANCHNAME_DB}    Get From List    ${BFBRANCHNAME_DB_Result_0}    0    
    
    [Return]    ${BFBRANCHNAME_DB}

Create Query for LIQ User and Return Results Count
    [Documentation]    This keyword is used to create sql query for User in LIQ and return results count.
    ...    @author: dahijara    12JUL2019    - initial create
    [Arguments]    ${sUserID}
    
    ${QUERY_USERID}    Catenate    ${SELECT_Q}    ${LOANIQ_UPT_UID_USERID}
    ...    ${FROM_Q}    ${LOANIQ_TLS_USER_PROFILE}    ${WHERE_Q}
    ...    ${LOANIQ_UPT_UID_USERID}    =    '${sUserID}'

    ${RESULTS_COUNT}     Connect to LIQ Database and Return Row Count    ${QUERY_USERID}
    
    [Return]    ${RESULTS_COUNT}    

Create Query for Active LIQ User and Return Results Count
    [Documentation]    This keyword is used to create sql query for Active User only in LIQ and return results count.
    ...    @author: amansuet    19AUG2019    - initial create
    [Arguments]    ${sUserID}
    
    ${QUERY_USERID}    Catenate    ${SELECT_Q}    ${LOANIQ_UPT_UID_USERID}
    ...    ${FROM_Q}    ${LOANIQ_TLS_USER_PROFILE}    ${WHERE_Q}
    ...    ${LOANIQ_UPT_UID_USERID}    =    '${sUserID}'    AND    ${LOANIQ_UPT_CDE_PROFILE}    =    'U'

    ${RESULTS_COUNT}     Connect to LIQ Database and Return Row Count    ${QUERY_USERID}
    
    [Return]    ${RESULTS_COUNT}

Create Query for Essence User and Return Results Count
    [Documentation]    This keyword is used to create sql query for User in Essence and return results count.
    ...    @author: dahijara    12JUL2019    - initial create
    [Arguments]    ${sUserID}
    
    ${QUERY_USERID}    Catenate    ${SELECT_Q}    ${ESSENCE_GLOBAL_BFNAMEPK}
    ...    ${FROM_Q}    ${ESSENCE_GLOBAL_BFTB_USER}    ${WHERE_Q}
    ...    ${ESSENCE_GLOBAL_BFNAMEPK}    =    '${sUserID}'

    ${RESULTS_COUNT}      Connect to Essence Global Database and Return Row Count    ${QUERY_USERID}
    
    [Return]    ${RESULTS_COUNT}    

    
Create Query for Party User and Return Results Count
    [Documentation]    This keyword is used to create sql query for User in Party and return results count.
    ...    @author: dahijara    12JUL2019    - initial create
    [Arguments]    ${sUserID}
    
    ${QUERY_USERID}    Catenate    ${SELECT_Q}    ${PARTY_BFNAMEPK}
    ...    ${FROM_Q}    ${PARTY_BFTB_USER}    ${WHERE_Q}
    ...    ${PARTY_BFNAMEPK}    =    '${sUserID}'

    ${RESULTS_COUNT}      Connect to Party Database and Return Row Count    ${QUERY_USERID}
    
    [Return]    ${RESULTS_COUNT}


Create JSON Input File for Delete User
    [Documentation]    This keyword is used to create json input file for delete user
    ...    @author: amansuet    15AUG2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sInputAPIResponse}
    
    Create File    ${dataset_path}${sInputFilePath}${sInputJson}.json 
    Create File    ${dataset_path}${sInputFilePath}${sInputAPIResponse}.json

Create Expected API Response for GET USER API
    [Documentation]    This keyword is used to create expected API response on FFC for GET User API.
    ...    @author: jloretiz    05SEP2019    - initial create
    ...    @update: amansuet    06SEP2019    - added country code as input value for update expected api response for corebanking and party.
    ...    @update: cfrancis    19SEP2019    - updated referencing of DataSet values from $ to &
    [Arguments]    ${APIDataSet}
    
    ${LOB_Dictionary}    Run Keyword If    '&{APIDataSet}[lineOfBusiness]'=='${COMRLENDING}'    Return GET API FFC Response as Dictionary for LIQ    ${APIDataSet}
    ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='${COREBANKING}' or '&{APIDataSet}[lineOfBusiness]'=='${PARTY}'    Return GET API FFC Response as Dictionary ESSENCE or PARTY    ${APIDataSet}
    
    Run Keyword If    '&{APIDataSet}[lineOfBusiness]'=='${COMRLENDING}'    Update Expected API Response for GET FFC LOANIQ    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputAPIResponse]    
    ...    &{LOB_Dictionary}[loginId]    &{LOB_Dictionary}[jobTitle]    &{LOB_Dictionary}[firstName]    &{LOB_Dictionary}[surname]    &{LOB_Dictionary}[countryCode]    
    ...    &{LOB_Dictionary}[locale]     &{LOB_Dictionary}[contactNumber1]    &{LOB_Dictionary}[contactNumber2]    &{LOB_Dictionary}[email]    &{LOB_Dictionary}[osUserId]    
    ...    &{LOB_Dictionary}[lineOfBusiness]    ${NONE}|&{LOB_Dictionary}[defaultBranch]    &{LOB_Dictionary}[defaultProcessingArea]    &{LOB_Dictionary}[additionalProcessingArea]    
    ...    &{LOB_Dictionary}[additionalDepartments]    &{LOB_Dictionary}[departmentCode]    &{LOB_Dictionary}[location]    &{LOB_Dictionary}[role]    &{LOB_Dictionary}[status]    
    ...    &{LOB_Dictionary}[userLockStatus]    &{LOB_Dictionary}[profileId]
    ...    ELSE IF    '&{APIDataSet}[lineOfBusiness]'=='${COREBANKING}' or '&{APIDataSet}[lineOfBusiness]'=='${PARTY}'    Update Expected API Response for GET User FFC COREBANKING or Party    &{APIDataSet}[InputFilePath]    
    ...    &{APIDataSet}[InputAPIResponse]    &{LOB_Dictionary}[loginId]    &{LOB_Dictionary}[userType]     &{LOB_Dictionary}[firstName]    &{LOB_Dictionary}[surname]     &{LOB_Dictionary}[osUserId]    &{LOB_Dictionary}[countryCode]
    ...    &{LOB_Dictionary}[locale]    &{LOB_Dictionary}[email]    &{LOB_Dictionary}[contactNumber1]    &{LOB_Dictionary}[jobTitle]    &{LOB_Dictionary}[businessEntityName]|&{LOB_Dictionary}[defaultBranch]
    ...    &{LOB_Dictionary}[role]    &{LOB_Dictionary}[userLockStatus]

Update Expected API Response for GET User FFC COREBANKING or Party
    [Documentation]    This keyword is used to update expected GET API Response for FFC.
    ...    @author: jloretiz    28AUG2019    - initial create
    ...    @update: amansuet    06SEP2019    - added condition for locale field to have a value depending on the country code.
    [Arguments]    ${sFilePath}    ${sFileName}    ${sLoginID}    ${sUserType}    ${sFName}    ${sLName}    ${sOSUserID}    ${sCountryCode}    ${sLocale}
    ...    ${sEmail}     ${iContactNum1}    ${sJobTitle}    ${sDefaultBussEntity}    ${sRoles}    ${sUserLockStatus}

    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    ${sCountryCode}    
    ${file_path}    Set Variable    ${Input_File_Path_Users}${templateinput_SingleLOB}
    ${EMPTY}    Set Variable
    ${JSON_Object}    Load JSON From File    ${file_path}
    ${basicDetailsDictionary}    Create Dictionary
    ${entitlementDetailsDictionary}    Create Dictionary
    
    ${New_JSON}    Run Keyword If    '${sLoginID}'=='null'    Set To Dictionary    ${JSON_Object}    userId=${NONE}
    ...    ELSE IF    '${sLoginID}'=='no tag'    Set To Dictionary    ${JSON_Object}    userId=${NONE}
    ...    ELSE    Set To Dictionary    ${JSON_Object}    userId=${sLoginID}
    
    ###Basic Details###
    ${basicDetailsDictionary}    Run Keyword If    '${sUserType}'=='null'    Set To Dictionary    ${basicDetailsDictionary}    userType=${NONE}
    ...    ELSE IF    '${sUserType}'=='no tag'    Set To Dictionary    ${basicDetailsDictionary}    userType=${NONE}
    ...    ELSE    Set To Dictionary    ${basicDetailsDictionary}    userType=${sUserType}

    ${basicDetailsDictionary}    Run Keyword If    '${sFName}'=='null'    Set To Dictionary    ${basicDetailsDictionary}    firstName=${NONE}
    ...    ELSE IF    '${sFName}'=='no tag'    Set To Dictionary    ${basicDetailsDictionary}    firstName=${NONE}
    ...    ELSE    Set To Dictionary    ${basicDetailsDictionary}    firstName=${sFName}

    ${basicDetailsDictionary}    Run Keyword If    '${sLName}'=='null'    Set To Dictionary    ${basicDetailsDictionary}    lastName=${NONE}
    ...    ELSE IF    '${sLName}'=='no tag'    Set To Dictionary    ${basicDetailsDictionary}    lastName=${NONE}
    ...    ELSE   Set To Dictionary    ${basicDetailsDictionary}    lastName=${sLName}
    
    ${basicDetailsDictionary}    Run Keyword If    '${sOSUserID}'=='null'    Set To Dictionary    ${basicDetailsDictionary}    osUserId=${NONE}
    ...    ELSE IF    '${sOSUserID}'=='no tag'    Set To Dictionary    ${basicDetailsDictionary}    osUserId=${NONE}
    ...    ELSE    Set To Dictionary    ${basicDetailsDictionary}    osUserId=${sOSUserID}
    
    ${basicDetailsDictionary}    Run Keyword If    '${sLocale}'=='null'    Set To Dictionary    ${basicDetailsDictionary}    locale=${NONE}
    ...    ELSE IF    '${sLocale}'=='no tag'    Set To Dictionary    ${basicDetailsDictionary}    locale=${NONE}
    ...    ELSE    Set To Dictionary    ${basicDetailsDictionary}    locale=${sLocale}_${2Code_CountryCode}
    
    ${basicDetailsDictionary}    Run Keyword If    '${sEmail}'=='null'    Set To Dictionary    ${basicDetailsDictionary}    email=${NONE}
    ...    ELSE IF    '${sEmail}'=='no tag'    Set To Dictionary    ${basicDetailsDictionary}    email=${NONE}
    ...    ELSE    Set To Dictionary    ${basicDetailsDictionary}    email=${sEmail}
    
    ${basicDetailsDictionary}    Run Keyword If    '${iContactNum1}'=='null'    Set To Dictionary    ${basicDetailsDictionary}    phone=${NONE}
    ...    ELSE IF    '${iContactNum1}'=='no tag'    Set To Dictionary    ${basicDetailsDictionary}    phone=${NONE}
    ...    ELSE    Set To Dictionary    ${basicDetailsDictionary}    phone=${iContactNum1}
    
    ${basicDetailsDictionary}    Run Keyword If    '${sJobTitle}'=='null'    Set To Dictionary    ${basicDetailsDictionary}    businessTitle=${NONE}
    ...    ELSE IF    '${sJobTitle}'=='no tag'    Set To Dictionary    ${basicDetailsDictionary}    businessTitle=${NONE}
    ...    ELSE    Set To Dictionary    ${basicDetailsDictionary}    businessTitle=${sJobTitle}
    
    ${New_JSON}    Set To Dictionary    ${New_JSON}    basicDetails=${basicDetailsDictionary}
    
    ###Entitlement Details###
    ${defaultBusinessEntity_sublist}    Set Variable    businessEntityName,defaultBranch
    ${deBusinessEntityList}    Split String    ${sDefaultBussEntity}    ,
    ${roleslist}    Split String    ${sRoles}    ,
    ${deBusinessEntityVal}    Create Dictionary for Single Set of Multiple Different Sub-Keyfields    ${deBusinessEntityList}    ${0}    ${defaultBusinessEntity_sublist}
    ${EntityName}=    Get From Dictionary    ${deBusinessEntityVal}    businessEntityName
    ${Branch}=    Get From Dictionary    ${deBusinessEntityVal}    defaultBranch
    
    ${entitlementDetailsDictionary}    Run Keyword If    '${EntityName}'=='null'    Set To Dictionary    ${entitlementDetailsDictionary}    defaultEntity=${NONE}
    ...    ELSE IF    '${EntityName}'=='no tag'    Set To Dictionary    ${entitlementDetailsDictionary}    defaultEntity=${NONE}
    ...    ELSE    Set To Dictionary    ${entitlementDetailsDictionary}    defaultEntity=${EntityName}
    
    ${entitlementDetailsDictionary}    Run Keyword If    '${EntityName}'=='null'    Set To Dictionary    ${entitlementDetailsDictionary}    defaultEntityName=${NONE}
    ...    ELSE IF    '${EntityName}'=='no tag'    Set To Dictionary    ${entitlementDetailsDictionary}    defaultEntityName=${NONE}
    ...    ELSE    Set To Dictionary    ${entitlementDetailsDictionary}    defaultEntityName=${EntityName}
    
    ${entitlementDetailsDictionary}    Run Keyword If    '${EntityName}'=='null'    Set To Dictionary    ${entitlementDetailsDictionary}    defaultEntityBranch=${NONE}
    ...    ELSE IF    '${EntityName}'=='no tag'    Set To Dictionary    ${entitlementDetailsDictionary}    defaultEntityBranch=${NONE}
    ...    ELSE    Set To Dictionary    ${entitlementDetailsDictionary}    defaultEntityBranch=${Branch}
    
    ${rolesVal}    Get From List    ${roleslist}    ${0}
    ${rolesDictionary}    Run Keyword If    '${rolesVal}'=='no tag'    Create List
    ...    ELSE    Create Dictionary for Multiple Same Sub-Keyfield    ${roleslist}    ${0}    roleId
    
    ${entitlementDetailsDictionary}    Set To Dictionary    ${entitlementDetailsDictionary}    roles=${rolesDictionary}
    ${New_JSON}    Set To Dictionary    ${New_JSON}    entitlementDetails=${entitlementDetailsDictionary}
    
    ${userLockStatuslist}    Split String    ${sUserLockStatus}    ,
    ${val_userLockStatus}    Get From List    ${userLockStatuslist}    ${INDEX_0}
    ${new_val_userLockStatus}    Run Keyword If    '${val_userLockStatus}'=='null'    Set Variable    UNLOCKED
    ...    ELSE IF    '${val_userLockStatus}'=='no tag'    Set Variable    UNLOCKED
    ...    ELSE IF    '${val_userLockStatus}'==''    Set Variable    UNLOCKED
    ...    ELSE        Set Variable    ${val_userLockStatus}
    
    ${New_JSON}    Run Keyword If    '${val_userLockStatus}'=='null'    Set To Dictionary    ${New_JSON}    lockUser=N
    ...    ELSE IF    '${val_userLockStatus}'=='no tag'        Set To Dictionary    ${New_JSON}    lockUser=N
    ...    ELSE IF    '${val_userLockStatus}'=='UNLOCKED'      Set To Dictionary    ${New_JSON}    lockUser=N
    ...    ELSE IF    '${val_userLockStatus}'=='LOCKED'        Set To Dictionary    ${New_JSON}    lockUser=Y
    ...    ELSE       Set To Dictionary    ${New_JSON}    lockUser=${val_userLockStatus}
    
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}_FFC.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}

Update Expected API Response for GET FFC LOANIQ
    [Documentation]    This keyword is used to update expected GET API Response.
    ...    @author: jloretiz    28AUG2019    - initial create
    ...    @update: amansuet    09SEP2019    - added condition fo jobTitle to replace Officer as CLR
    ...    @update: rtarayao    29NOV2019    - added code to convert country code from 3 to 2
    [Arguments]    ${sFilePath}    ${sFileName}    ${sLoginID}    ${sJobTitle}    ${sFName}    ${sLName}    ${sCountryCode}    ${sLocale}    ${iContactNum1}
    ...    ${iContactNum2}    ${sEmail}    ${sOSUserID}    ${sLOB}    ${sDefaultBussEntity}
    ...    ${sDefaultProcArea}    ${sAddProcArea}    ${sAddDept}    ${sPrimaryDept}    ${sLocation}    ${sRoles}
    ...    ${sStatus}    ${sUserLockStatus}    ${sProfielID}

    ${file_path}    Set Variable    ${Input_File_Path_Users}${templateinput_MultipleLOB}
    ${EMPTY}    Set Variable
    ${EmptyList}    Create List
    ${JSON_Object}    Load JSON From File    ${file_path}
    ${sLocale}    Convert To Uppercase    ${sLocale}
    ${2Code_CountryCode}    Get 3-code country from the input 2-code country    ${sCountryCode}
    
    ## add demographic fields here
    ${New_JSON}    Run Keyword If    '${sLoginID}'=='null'    Set To Dictionary    ${JSON_Object}    loginId=${NONE}
    ...    ELSE IF    '${sLoginID}'=='no tag'    Set To Dictionary    ${JSON_Object}    loginId=${NONE}
    ...    ELSE    Set To Dictionary    ${JSON_Object}    loginId=${sLoginID}

    ${New_JSON}    Run Keyword If    '${sJobTitle}'=='null'    Set To Dictionary    ${New_JSON}    jobTitle=${NONE}
    ...    ELSE IF    '${sJobTitle}'=='no tag'    Set To Dictionary    ${New_JSON}    jobTitle=${NONE}
    ...    ELSE IF    '${sJobTitle}'=='Officer'    Set To Dictionary    ${New_JSON}    jobTitle=CLR
    ...    ELSE    Set To Dictionary    ${New_JSON}    jobTitle=${sJobTitle}

    ${New_JSON}    Run Keyword If    '${sFName}'=='null'    Set To Dictionary    ${New_JSON}    firstName=${NONE}
    ...    ELSE IF    '${sFName}'=='no tag'    Set To Dictionary    ${New_JSON}    firstName=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    firstName=${sFName}

    ${New_JSON}    Run Keyword If    '${sLName}'=='null'    Set To Dictionary    ${New_JSON}    surname=${NONE}
    ...    ELSE IF    '${sLName}'=='no tag'    Set To Dictionary    ${New_JSON}    surname=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    surname=${sLName}

    ${New_JSON}    Run Keyword If    '${sCountryCode}'=='null'    Set To Dictionary    ${New_JSON}    countryCode=${NONE}
    ...    ELSE IF    '${sCountryCode}'=='no tag'    Set To Dictionary    ${New_JSON}    countryCode=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    countryCode=${2Code_CountryCode}

    ${New_JSON}    Run Keyword If    '${sLocale}'=='null'    Set To Dictionary    ${New_JSON}    locale=${NONE}
    ...    ELSE IF    '${sLocale}'=='no tag'    Set To Dictionary    ${New_JSON}    locale=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    locale=${sLocale}

    ${New_JSON}    Run Keyword If    '${iContactNum1}'=='null'    Set To Dictionary    ${New_JSON}    contactNumber1=${NONE}
    ...    ELSE IF    '${iContactNum1}'=='no tag'    Set To Dictionary    ${New_JSON}    contactNumber1=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    contactNumber1=${iContactNum1}

    ${New_JSON}    Run Keyword If    '${sLOB}'=='${PARTY}' or '${sLOB}'=='${COREBANKING}'    Set To Dictionary    ${New_JSON}    contactNumber2=${NONE}
    ...    ELSE IF    '${iContactNum2}'=='null'    Set To Dictionary    ${New_JSON}    contactNumber2=${NONE}
    ...    ELSE IF    '${iContactNum2}'=='no tag'    Set To Dictionary    ${New_JSON}    contactNumber2=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    contactNumber2=${iContactNum2}

    ${New_JSON}    Run Keyword If    '${sEmail}'=='null'    Set To Dictionary    ${New_JSON}    email=${NONE}
    ...    ELSE IF    '${sEmail}'=='no tag'    Set To Dictionary    ${New_JSON}    email=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    email=${sEmail}

    ${New_JSON}    Run Keyword If    '${sOSUserID}'=='null'    Set To Dictionary    ${New_JSON}    osUserId=${NONE}
    ...    ELSE IF    '${sOSUserID}'=='no tag'    Set To Dictionary    ${New_JSON}    osUserId=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    osUserId=${sOSUserID}


    ${FinalAdditionalDepartments}    Run Keyword If    '${sAddDept}'=='${EmptyList}'    Set Variable    no tag
    ...    ELSE IF    Set Variable   ${sAddDept}

   ## get lineOfBusiness field values
   ${LOB_list}    Split String    ${sLOB}    ,
   ${LOB_count}    Get Length    ${LOB_list}
   ${deBusinessEntityList}    Split String    ${sDefaultBussEntity}    ,
   ${defprocessingAreaList}    Split String    ${sDefaultProcArea}    ,
   ${processingAreaList}    Split String    ${sAddProcArea}    ,
   ${adddepartmentCodeList}    Split String    ${FinalAdditionalDepartments}    ,
   ${primaryDepartmentList}    Split String    ${sPrimaryDept}    ,
   ${locationlist}    Split String    ${sLocation}    ,
   ${roleslist}    Split String    ${sRoles}    ,
   ${statuslist}    Split String    ${sStatus}    ,
   ${userLockStatuslist}    Split String    ${sUserLockStatus}    ,
   ${profileIdList}    Split String    ${sProfielID}    ,

   ##list of different sub keyfields for defaultBusinessEntity/additionalBusinessEntity
   ${defaultBusinessEntity_sublist}    Set Variable    businessEntityName,defaultBranch
   Set Global Variable    ${defaultBusinessEntity_sublist}
   ${Empty_List}    Create List 
   ## add 'line of business' fields here
   :FOR    ${INDEX_0}    IN RANGE    ${LOB_count}
   \    Exit For Loop If    ${INDEX_0}==${LOB_count}
   \    Log    ${New_JSON}
   \    ${val_LOB}    Get From List    ${LOB_list}    ${INDEX_0}
   \
   \    ##check lineOfBusiness if null or empty or have valid value
   \    ${val_LOB_0}    Run Keyword If    '${sLOB}'!=''    Get From List    ${LOB_list}    0
   \    ${val_LOB}    Run Keyword If    '${val_LOB_0}'=='lineOfBusiness=""'    Set Variable    ${EMPTY}
        ...    ELSE IF    '${val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_LOB}
   \
   \    ${deBusinessEntityVal}    Run Keyword And Continue On Failure    Get From List    ${deBusinessEntityList}    ${INDEX_0}
   \    ${defaultBusinessEntityDictionary}    Run Keyword If    '${deBusinessEntityVal}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Create Dictionary for Single Set of Multiple Different Sub-Keyfields    ${deBusinessEntityList}    ${INDEX_0}    ${defaultBusinessEntity_sublist}    ${sLOB}
   \
   \    ${defprocessingAreaVal}    Run Keyword And Continue On Failure    Get From List    ${defprocessingAreaList}    ${INDEX_0}
   \    ${defaultProcessingAreaDictionary}    Run Keyword If    '${defprocessingAreaVal}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Create Dictionary for Single Sub-Keyfield    ${defprocessingAreaList}    ${INDEX_0}    processingArea
   \
   \    ${processingAreaVal}    Run Keyword And Continue On Failure    Get From List    ${processingAreaList}    ${INDEX_0}
   \    ${additionalProcessingAreaDictionary}    Run Keyword If    '${processingAreaVal}'=='no tag'    Create List
        ...    ELSE    Create Dictionary for Multiple Same Sub-Keyfield    ${processingAreaList}    ${INDEX_0}    processingArea
   \
   \    ${primaryDepartmentVal}    Run Keyword And Continue On Failure    Get From List    ${primaryDepartmentList}    ${INDEX_0}
   \    ${defaultprimaryDepartmentDictionary}    Run Keyword If    '${primaryDepartmentVal}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Create Dictionary for Single Sub-Keyfield    ${primaryDepartmentList}    ${INDEX_0}    departmentCode
   \
   \    ${adddepartmentCodeVal}    Run Keyword And Continue On Failure    Get From List    ${adddepartmentCodeList}    ${INDEX_0}
   \    ${additionalDepartmentsDictionary}    Run Keyword If    '${sLOB}'=='${COMRLENDING}'    Create List
        ...    ELSE IF    '${adddepartmentCodeVal}'=='no tag'    Create List
        ...    ELSE    Create Dictionary for Multiple Same Sub-Keyfield    ${adddepartmentCodeList}    ${INDEX_0}    departmentCode
   \
   \    ${rolesVal}    Get From List    ${roleslist}    ${INDEX_0}
   \    ${rolesDictionary}    Run Keyword If    '${rolesVal}'=='no tag'    Create List
        ...    ELSE    Create Dictionary for Multiple Same Sub-Keyfield    ${roleslist}    ${INDEX_0}    role
   \
   \    ${val_loc}    Get From List    ${locationlist}    ${INDEX_0}
   \    ${new_val_loc}    Run Keyword If    '${val_loc}'=='null'    Set Variable    ${NONE}
        ...    ELSE IF    '${val_loc}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_loc}
   \
   \    ${val_status}    Get From List    ${statuslist}    ${INDEX_0}
   \    ${new_val_status}    Run Keyword If    '${sLOB}'=='${PARTY}' or '${sLOB}'=='${COREBANKING}'    Set Variable    ${NONE}
        ...    ELSE IF    '${val_status}'=='null'    Set Variable    ${NONE}
        ...    ELSE IF    '${val_status}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_status}
   \
   \    ${val_userLockStatus}    Get From List    ${userLockStatuslist}    ${INDEX_0}
   \    ${new_val_userLockStatus}    Run Keyword If    '${val_userLockStatus}'=='null'    Set Variable    UNLOCKED
        ...    ELSE IF    '${val_userLockStatus}'=='no tag'    Set Variable    UNLOCKED
        ...    ELSE IF    '${val_userLockStatus}'==''    Set Variable    UNLOCKED
        ...    ELSE    Set Variable    ${val_userLockStatus}
   \
   \    ${val_profileId}    Get From List    ${profileIdList}    ${INDEX_0}
   \    ${new_val_profileId}    Run Keyword If    '${sLOB}'=='${PARTY}' or '${sLOB}'=='${COREBANKING}'    Set Variable    ${NONE}
        ...    ELSE IF    '${val_profileId}'=='null'    Set Variable    ${NONE}
        ...    ELSE IF    '${val_profileId}'=='no tag'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${val_profileId}
   \
   \    ${lineOfBusinessDictionary}    Create Dictionary    lineOfBusiness=${val_LOB}
        ...    defaultBusinessEntity=${defaultBusinessEntityDictionary}   defaultProcessingArea=${defaultProcessingAreaDictionary}    
        ...    additionalProcessingArea=${additionalProcessingAreaDictionary}    primaryDepartment=${defaultprimaryDepartmentDictionary}    
        ...    additionalDepartments=${additionalDepartmentsDictionary}    location=${new_val_loc}    roles=${rolesDictionary}    
        ...    status=${new_val_status}    userLockStatus=${new_val_userLockStatus}    profileId=${new_val_profileId}
   \
   \    ${New_JSON}    Run Keyword If    '${sLOB}'=='null'    Set To Dictionary    ${New_JSON}    lobs=${NONE}
        ...    ELSE IF    '${sLOB}'=='no tag'    Set To Dictionary    ${New_JSON}    lobs=${Empty_List}
        ...    ELSE IF    '${sLOB}'==''    Set To Dictionary    ${New_JSON}    lobs=${EMPTY}
        ...    ELSE IF    '${sLOB}'=='Empty' or '${sLOB}'=='empty'    Set To Dictionary    ${New_JSON}    lobs=${EMPTY}
        ...    ELSE    Add Object To Json    ${New_JSON}    $..lobs    ${lineOfBusinessDictionary}

    Log    ${New_JSON}
    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    Log    ${Converted_JSON}
    ${JSON_File}    Set Variable    ${sFilePath}${sFileName}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_JSON}
    ${file}    OperatingSystem.Get File    ${dataset_path}${JSON_File}

Return GET API FFC Response as Dictionary for LIQ
    [Documentation]    This keyword is used get the value on JSON file from GET API response for LIQ
    ...    And create the dictionary and return.
    ...    @author: jloretiz    04SEP2019    - initial create
    ...    @update: amansuet    11SEP2019    - updated input value for jobTitle as it was previously using apidataset. Used 2 code for country code.
    ...    @update: cfrancis    19SEP2019    - changed referencing of variable countrycode with index from $ to &
    ...    @update: rtarayao    29NOV2019    - removed country code conversion
    [Arguments]    ${APIDataSet}
    
    ${ExpectedValue}    OperatingSystem.Get File    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputAPIResponse].${JSON}
    ${Converted_JSON}    evaluate    json.loads('''${ExpectedValue}''')    ${JSON}
    ${file_path}    Set Variable    ${Input_File_Path_Users}${templateinput_MultipleLOB}
    ${EMPTY}    Set Variable
    ${JSON_Object}    Load JSON From File    ${file_path}
    
    ###Get Values From JSON File###
    ${Value_ProfileID}    Get Value From Json    ${Converted_JSON}    $..lobs..profileId
    ${Value_LOB}    Get Value From Json    ${Converted_JSON}    $..lobs..lineOfBusiness
    ${Value_DefBRanch}    Get Value From Json    ${Converted_JSON}    $..lobs..defaultBusinessEntity..defaultBranch
    ${Value_DefBussName}    Get Value From Json    ${Converted_JSON}    $..lobs..defaultBusinessEntity..businessEntityName
    ${Value_DefProcessingArea}    Get Value From Json    ${Converted_JSON}    $..lobs..defaultProcessingArea..processingArea
    ${Value_AddProcessingArea}    Get Value From Json    ${Converted_JSON}    $..lobs..additionalProcessingArea..processingArea
    ${Value_AddDepartments}    Get Value From Json    ${Converted_JSON}    $..lobs..additionalDepartments
    ${Value_PrimDepartments}    Get Value From Json    ${Converted_JSON}    $..lobs..primaryDepartment..departmentCode
    ${Value_Location}    Get Value From Json    ${Converted_JSON}    $..lobs..location
    ${Value_Roles}    Get Value From Json    ${Converted_JSON}    $..lobs..roles..role 
    ${Value_Status}    Get Value From Json    ${Converted_JSON}    $..lobs..status
    ${Value_User}    Get Value From Json    ${Converted_JSON}    $..lobs..userType
    ${Value_UserLockStatus}    Get Value From Json    ${Converted_JSON}    $..lobs..userLockStatus
    ${Value_AddBranch}    Get Value From Json    ${Converted_JSON}    $..lobs..additionalBusinessEntity
    
    ${ProfileID}    Get From List    ${Value_ProfileID}    0
    ${LOB}    Get From List    ${Value_LOB}    0
    ${DefBranch}    Get From List    ${Value_DefBRanch}    0
    ${DefBussName}    Get From List    ${Value_DefBussName}    0 
    ${DefProcessingArea}    Get From List    ${Value_DefProcessingArea}    0
    ${AddProcessingArea}    Get From List    ${Value_AddProcessingArea}    0
    ${AdditionalDepartments}    Get From List    ${Value_AddDepartments}    0
    ${PrimaryDepartments}    Get From List    ${Value_PrimDepartments}    0
    ${Location}    Get From List    ${Value_Location}    0
    ${Roles}    Get From List    ${Value_Roles}    0
    ${Status}    Get From List    ${Value_Status}    0
    ${UserType}    Get From List    ${Value_User}    0
    ${UserLockStatus}    Get From List    ${Value_UserLockStatus}    0
    ${AddBussEntity}    Get From List    ${Value_AddBranch}    0
    ${Locale}    Convert To Lowercase    &{Converted_JSON}[locale]
    
    ###Demographics###
    ${New_JSON}    Set To Dictionary    ${JSON_Object}     loginId=&{Converted_JSON}[loginId]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        jobTitle=&{Converted_JSON}[jobTitle]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        firstName=&{Converted_JSON}[firstName]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        surname=&{Converted_JSON}[surname]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        countryCode=&{Converted_JSON}[countryCode]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        locale=${Locale}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        contactNumber1=&{Converted_JSON}[contactNumber1]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        contactNumber2=&{Converted_JSON}[contactNumber2]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        email=&{Converted_JSON}[email]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        osUserId=&{Converted_JSON}[osUserId]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        centralRoles=&{Converted_JSON}[centralRoles]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        centralUserType=&{Converted_JSON}[centralUserType]
    
    ###Line Of Business###
    ${New_JSON}    Set To Dictionary    ${New_JSON}        lineOfBusiness=${LOB}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        defaultBranch=${DefBranch}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        defaultBusinessEntityName=${DefBussName}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        defaultProcessingArea=${DefProcessingArea}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        additionalProcessingArea=${AddProcessingArea}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        departmentCode=${PrimaryDepartments}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        additionalDepartments=${additionalDepartments}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        location=${Location}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        role=${Roles}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        status=${Status}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        userLockStatus=${UserLockStatus}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        userType=${UserType}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        profileId=${ProfileID}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        addBussEntity=${AddBussEntity}
    
    ${Dump_JSON}    Evaluate    json.dumps(${New_JSON})        json
    ${Converted_JSON}    evaluate    json.loads('''${Dump_JSON}''')    ${JSON}
    
    [Return]    ${Converted_JSON}
    
Return GET API FFC Response as Dictionary ESSENCE or PARTY
    [Documentation]    This keyword is used get the value on JSON file from GET API response for ESSENCE or PARTY
    ...    And create the dictionary and return.
    ...    @author: jloretiz    04SEP2019    - initial create
    [Arguments]    ${APIDataSet}
    
    ${ExpectedValue}    OperatingSystem.Get File    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputAPIResponse].${JSON}
    ${Converted_JSON}    evaluate    json.loads('''${ExpectedValue}''')    ${JSON}
    ${file_path}    Set Variable    ${Input_File_Path_Users}${templateinput_MultipleLOB}
    ${EMPTY}    Set Variable
    ${JSON_Object}    Load JSON From File    ${file_path}
    
    ###Get Values From JSON File###
    ${Value_LOB}    Get Value From Json    ${Converted_JSON}    $..lobs..lineOfBusiness
    ${Value_DefBRanch}    Get Value From Json    ${Converted_JSON}    $..lobs..defaultBusinessEntity..defaultBranch
    ${Value_DefBussName}    Get Value From Json    ${Converted_JSON}    $..lobs..defaultBusinessEntity..businessEntityName
    ${Value_Roles}    Get Value From Json    ${Converted_JSON}    $..lobs..roles..role 
    ${Value_Status}    Get Value From Json    ${Converted_JSON}    $..lobs..status
    ${Value_User}    Get Value From Json    ${Converted_JSON}    $..lobs..userType
    ${Value_UserLockStatus}    Get Value From Json    ${Converted_JSON}    $..lobs..userLockStatus
    ${Value_AddBranch}    Get Value From Json    ${Converted_JSON}    $..lobs..additionalBusinessEntity
    ${Value_AddZone}    Get Value From Json    ${Converted_JSON}    $..lobs..additionalBusinessEntity
    
    ${LOB}    Get From List    ${Value_LOB}    0
    ${DefBranch}    Get From List    ${Value_DefBRanch}    0
    ${DefBussName}    Get From List    ${Value_DefBussName}    0
    ${Roles}    Get From List    ${Value_Roles}    0
    ${Status}    Get From List    ${Value_Status}    0
    ${UserType}    Get From List    ${Value_User}    0
    ${UserLockStatus}    Get From List    ${Value_UserLockStatus}    0
    ${Locale}    Convert To Lowercase    &{Converted_JSON}[locale]
    
    ###Demographics###
    ${New_JSON}    Set To Dictionary    ${JSON_Object}     loginId=&{Converted_JSON}[loginId]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        jobTitle=&{Converted_JSON}[jobTitle]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        firstName=&{Converted_JSON}[firstName]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        surname=&{Converted_JSON}[surname]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        countryCode=&{Converted_JSON}[countryCode]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        locale=${Locale}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        contactNumber1=&{Converted_JSON}[contactNumber1]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        contactNumber2=&{Converted_JSON}[contactNumber2]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        email=&{Converted_JSON}[email]
    ${New_JSON}    Set To Dictionary    ${New_JSON}        osUserId=&{Converted_JSON}[osUserId]

    ###Line Of Business###
    ${New_JSON}    Set To Dictionary    ${New_JSON}        lineOfBusiness=${LOB}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        defaultBranch=${DefBranch}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        businessEntityName=${DefBussName}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        role=${Roles}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        status=${Status}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        userLockStatus=${UserLockStatus}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        userType=${UserType}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        addBranch=${Value_AddBranch}
    ${New_JSON}    Set To Dictionary    ${New_JSON}        addZone=${Value_AddZone}
    
    ${Dump_JSON}    Evaluate    json.dumps(${New_JSON})        json
    ${Converted_JSON}    evaluate    json.loads('''${Dump_JSON}''')    ${JSON}
    
    [Return]    ${Converted_JSON}
    
Create Expected API Response for Get All User API
    [Documentation]    This keyword is used to create json input file for get all user
    ...    @author: amansuet    05SEP2019    - initial create
    [Arguments]    ${sOutputFilePath}    ${OutputAPIResponse}    ${sFileExtension}    ${sInputFilePath}    ${sInputAPIResponse}    ${sLOB}
    
    Delete File If Exist    ${dataset_path}${sInputFilePath}${sInputAPIResponse}.${sFileExtension}
    ${Converted_JSON}    Run Keyword If    '${sLOB}'=='PARTY' or '${sLOB}'=='COREBANKING'    Updated Expected Response on Get All User API for Party and Essence    ${sOutputFilePath}    
    ...    ${OutputAPIResponse}    ${sFileExtension}
    ...    ELSE IF    '${sLOB}'=='COMRLENDING'    Updated Expected Response on Get All User API for LIQ    ${sOutputFilePath}    ${OutputAPIResponse}    ${sFileExtension}
    Create File    ${dataset_path}${sInputFilePath}${sInputAPIResponse}.${sFileExtension}    ${Converted_JSON}

Updated Expected Response on Get All User API for Party and Essence
    [Documentation]    This keyword is used to update expected response for get all user api for Party and Essence
    ...    @author: amansuet    06SEP2019    - initial create
    [Arguments]    ${sOutputFilePath}    ${OutputAPIResponse}    ${sFileExtension}
    
    ${ActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${OutputAPIResponse}.${sFileExtension}
    ${FinalValue}    Replace String    ${ActualValue}    "loginId":    "userId":
    ${FinalValue}    Replace String    ${FinalValue}    "surname":    "lastName":
    ${FinalValue}    Replace String    ${FinalValue}    "userLockStatus":    "isUserLocked":
    ${FinalValue}    Replace String    ${FinalValue}    "updatedTimeStamp":    "lastUpdatedTime":
    ${Convert_JSON}    evaluate    json.loads('''${FinalValue}''')    ${JSON}
    
    Delete Object From Json    ${Convert_JSON}    $.._meta..offset
    Delete Object From Json    ${Convert_JSON}    $..users..status
    ${entityId}    Create Dictionary    entityId=AU
    Add Object To Json    ${Convert_JSON}    $..users[*]    ${entityId}

    ${isUserLocked_List}    Get Value From Json    ${Convert_JSON}    $..users..isUserLocked
    ${isUserLocked_Count}    Get Length    ${isUserLocked_List}
    :FOR    ${INDEX_0}    IN RANGE    ${isUserLocked_Count}
    \    Exit For Loop If    ${INDEX_0}==${isUserLocked_Count}
    \    ${isUserLocked_val}    Get From List    ${isUserLocked_List}    ${INDEX_0}
    \    ${Convert_JSON}    Run Keyword If    '${isUserLocked_val}'=='LOCKED'    Update Value To Json    ${Convert_JSON}    $..users[${INDEX_0}].isUserLocked    Y
         ...    ELSE IF    '${isUserLocked_val}'=='UNLOCKED'    Update Value To Json    ${Convert_JSON}    $..users[${INDEX_0}].isUserLocked    N
    ${Converted_JSON}    Evaluate    json.dumps(${Convert_JSON})        ${JSON}
    
    [Return]    ${Converted_JSON}
    
Updated Expected Response on Get All User API for LIQ
    [Documentation]    This keyword is used to update expected response for get all user api for LIQ
    ...    @author: amansuet    06SEP2019    - initial create
    [Arguments]    ${sOutputFilePath}    ${OutputAPIResponse}    ${sFileExtension}
    
    ${ActualValue}    OperatingSystem.Get File    ${dataset_path}${sOutputFilePath}${OutputAPIResponse}.${sFileExtension}
    ${Convert_JSON}    evaluate    json.loads('''${ActualValue}''')    ${JSON}
    
    ${loginId_List}    Get Value From Json    ${Convert_JSON}    $..users..loginId
    ${loginId_Count}    Get Length    ${loginId_List}
    :FOR    ${INDEX_0}    IN RANGE    ${loginId_Count}
    \    Exit For Loop If    ${INDEX_0}==${loginId_Count}
    \    ${loginId_val}    Get From List    ${loginId_List}    ${INDEX_0}
    \    Run Keyword If    '${loginId_val}'=='null' or '${loginId_val}'=='' or '${loginId_val}'=='None' or '${loginId_val}'=='no tag'
         ...    Run Keywords    Delete Object From Json    ${Convert_JSON}    $..users[${INDEX_0}].loginId
         ...    AND    Delete Object From Json    ${Convert_JSON}    $..users[${INDEX_0}].userLockStatus
    ${Converted_JSON}    Evaluate    json.dumps(${Convert_JSON})        ${JSON}
    
    [Return]    ${Converted_JSON}

Validate Updated Fields via LOB UI using GET Single API 
    [Documentation]    This keyword is used to validate updated fields.
    ...    @author: jloretiz    17SEP2019    - initial create
    ...    @update: cfrancis    07SEP2020    - added condition for additionalprocessingarea
    [Arguments]    ${sFieldToCompare}    ${sFieldtoCheck}
    
    ## Get GET Single USER API Response ##
    ${GETSingleValue}    Set Variable    ${GETSINGLEAPIRESPONSE}
    ${Convert_JSON_GetSingle}    evaluate    json.loads('''${GETSingleValue}''')    ${JSON}
    ${getSingleResponse}    Run Keyword If    '${sFieldtoCheck}' == 'additionalProcessingArea'    Get Value From Json    ${Convert_JSON_GetSingle}    $..processingArea
    ...    ELSE    Get Value From Json    ${Convert_JSON_GetSingle}    $..${sFieldtoCheck}
    ${finalResponse}    Run Keyword If    '${sFieldtoCheck}' == 'additionalProcessingArea'    Get From List    ${getSingleResponse}    1
    ...    ELSE    Get From List    ${getSingleResponse}    0

    ## Validate Field Values are Matched ##
    Run Keyword And Continue On Failure    Should Be Equal    ${sFieldToCompare}     ${finalResponse} 
    ${Stat}    Run Keyword And Return Status    Should Be Equal    ${sFieldToCompare}     ${finalResponse} 
    Run Keyword If    ${Stat}==${True}    Log    '${sFieldtoCheck}' field from PUT API Response and GET ALL USER API Response are matched. ${sFieldToCompare} == ${finalResponse} 
    ...    ELSE    Log    '${sFieldtoCheck}' field from PUT API Response and GET ALL USER API Response does not matched. ${sFieldToCompare} != ${finalResponse}     level=ERROR
    
Validate Updated Fields via LOB UI using GET ALL API 
    [Documentation]    This keyword is used to validate updated fields.
    ...    @author: jloretiz    17SEP2019    - initial create
    [Arguments]    ${sLoginId}    ${sFieldToCompare}    ${sFieldtoCheck}
    
    ## Get GET ALL USER API Response ##
    ${GETAllValue}    Set Variable    ${GETALLAPIRESPONSE}
    ${Convert_JSON_Get}    evaluate    json.loads('''${GETAllValue}''')    ${JSON}
    ${loginId_List}    Get Value From Json    ${Convert_JSON_Get}    $..loginId
    ${loginId_Count}    Get Length    ${loginId_List}
    :FOR    ${INDEX}    IN RANGE    ${loginId_Count}
    \    ${loginId_Value}    Get From List    ${loginId_List}    ${INDEX}
    \    Exit For Loop If    '${loginId_Value}'=='${sLoginId}'
    ${getAllResponse}    Get Value From Json    ${Convert_JSON_Get}    $..users[${INDEX}].${sFieldtoCheck}
    ${finalResponse}    Get From List    ${getAllResponse}    0

    ## Validate Field Values are Matched ##
    Run Keyword And Continue On Failure    Should Be Equal    ${sFieldToCompare}     ${finalResponse} 
    ${Stat}    Run Keyword And Return Status    Should Be Equal    ${sFieldToCompare}     ${finalResponse} 
    Run Keyword If    ${Stat}==${True}    Log    '${sFieldtoCheck}' field from PUT API Response and GET ALL USER API Response are matched. ${sFieldToCompare} == ${finalResponse} 
    ...    ELSE    Log    '${sFieldtoCheck}' field from PUT API Response and GET ALL USER API Response does not matched. ${sFieldToCompare} != ${finalResponse}     level=ERROR

Generate Random Valid Offset for Get All User per LOB
    [Documentation]    This keyword is used to generate a random valid offset value to be used for get all user API
    ...    @author: cfrancis    17SEP2019    - initial create
    [Arguments]    ${sLOB}    ${sLimit}=50
    
    ${totalUsersCount}    Create Query for All Users per LOB and Return Total Count    ${sLOB}
    ${pageCount}    Evaluate    ${totalUsersCount} / ${sLimit} + 1
    ${IndexLimit}    Evaluate    ${pageCount} - 1
    ${IndexLimit}    Convert to Integer    ${IndexLimit}
    ${OffsetLimit}    Evaluate    ${pageCount} * ${sLimit} - ${sLimit}
    ${PossibleOffset}    Create List
    ${Index}    Set Variable    0
    :FOR    ${INDEX}    IN RANGE    ${pageCount}
    \    ${OffsetValue}    Evaluate    ${INDEX} * ${sLimit}
    \    Append To List    ${PossibleOffset}    ${OffsetValue}
    ${Random}    Generate Single Random Number and Return    1    ${IndexLimit}
    ${RandomOffset}    Get From List    ${PossibleOffset}    ${Random}
    ${RandomOffset}    Convert to Integer    ${RandomOffset}
    Set Global Variable    ${GETALLUSER_OFFSET}    ${RandomOffset}