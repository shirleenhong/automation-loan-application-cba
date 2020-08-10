*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Create Input JSON for Base Rate API
    [Documentation]    This keyword is used to create single or multiple JSON payload for Base Rate API.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...                                      - removed ${APIDataSet} as an argument
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}
    ...    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}    ${sInstrumentType}    ${sLOB}
    ...    ${sBussEntityName}    ${sSubEntity}
    
    ${BaseRate_List}    Split String    ${sBaseRateCode}    ,
    ${BaseRate_Count}    Get Length    ${BaseRate_List}
    ${JSON_File}    Set Variable    ${sInputFilePath}${sInputJson}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    :FOR    ${Index}    IN RANGE    ${BaseRate_Count}
    \    ${New_JSON}    Update Key Values of Input JSON File for Base Rate API    ${Index}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}
         ...    ${iMidRate}    ${iSellRate}    ${iLastRate}    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}
         ...    ${sInstrumentType}    ${sLOB}    ${sBussEntityName}    ${sSubEntity}
    \    Log    ${New_JSON}
    \    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    \    Log    ${Converted_JSON}
    \    Run Keyword If    ${Index}==0    Append To File    ${dataset_path}${JSON_File}    ${Converted_JSON}
    \    Run Keyword If    ${Index}!=0    Append To File    ${dataset_path}${JSON_File}    ,${Converted_JSON}
    \    Exit For Loop If    ${Index}==${BaseRate_Count}
    
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSON_File}
    ${Converted_File}    Catenate    SEPARATOR=    [    ${File}    ]
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_File}

Update Key Values of Input JSON File for Base Rate API
    [Documentation]    This keyword is used to update key values of JSON file and save to new file.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${iListIndex}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}
    ...    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}    ${sInstrumentType}    ${sLOB}
    ...    ${sBussEntityName}    ${sSubEntity}
    
    ${File_Path}    Set Variable    ${TEMPLATEINPUT}    
    ${EMPTY}    Set Variable    
    ${JSON_Object}    Load JSON From File    ${File_Path}
    
    ${baseRateCode_List}    Split String    ${sBaseRateCode}    ,
    ${baseRateCode_Val}    Get From List    ${baseRateCode_List}    ${iListIndex}
    ${New_JSON}    Run Keyword If    '${baseRateCode_Val}'=='null'    Set To Dictionary    ${JSON_Object}    baseRateCode=${NONE}
    ...    ELSE IF    '${baseRateCode_Val}'==''    Set To Dictionary    ${JSON_Object}    baseRateCode=${EMPTY}
    ...    ELSE IF    '${baseRateCode_Val}'=='Empty' or '${baseRateCode_Val}'=='empty'    Set To Dictionary    ${JSON_Object}    baseRateCode=${EMPTY}
    ...    ELSE IF    '${baseRateCode_Val}'=='no tag'    Set Variable    ${JSON_Object}
    ...    ELSE    Set To Dictionary    ${JSON_Object}    baseRateCode=${baseRateCode_Val}
    
    ${currency_List}    Split String    ${sCurrency}    ,
    ${currency_Val}    Get From List    ${currency_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${currency_Val}'=='null'    Set To Dictionary    ${New_JSON}    currency=${NONE}
    ...    ELSE IF    '${currency_Val}'==''    Set To Dictionary    ${New_JSON}    currency=${EMPTY}
    ...    ELSE IF    '${currency_Val}'=='Empty' or '${currency_Val}'=='empty'    Set To Dictionary    ${New_JSON}    currency=${EMPTY}
    ...    ELSE IF    '${currency_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    currency=${currency_Val}
    
    ${buyRate_List}    Split String    ${iBuyRate}    ,
    ${buyRate_Val}    Get From List    ${buyRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${buyRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    buyRate=${NONE}
    ...    ELSE IF    '${buyRate_Val}'==''    Set To Dictionary    ${New_JSON}    buyRate=${EMPTY}
    ...    ELSE IF    '${buyRate_Val}'=='Empty' or '${buyRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    buyRate=${EMPTY}
    ...    ELSE IF    '${buyRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    buyRate=${${buyRate_Val}}
    
    ${midRate_List}    Split String    ${iMidRate}    ,
    ${midRate_Val}    Get From List    ${midRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${midRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    midRate=${NONE}
    ...    ELSE IF    '${midRate_Val}'==''    Set To Dictionary    ${New_JSON}    midRate=${EMPTY}
    ...    ELSE IF    '${midRate_Val}'=='Empty' or '${midRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    midRate=${EMPTY}
    ...    ELSE IF    '${midRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    midRate=${${midRate_Val}}
    
    ${sellRate_List}    Split String    ${iSellRate}    ,
    ${sellRate_Val}    Get From List    ${sellRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${sellRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    sellRate=${NONE}
    ...    ELSE IF    '${sellRate_Val}'==''    Set To Dictionary    ${New_JSON}    sellRate=${EMPTY}
    ...    ELSE IF    '${sellRate_Val}'=='Empty' or '${sellRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    sellRate=${EMPTY}
    ...    ELSE IF    '${sellRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    sellRate=${${sellRate_Val}}
	
	${lastRate_List}    Split String    ${iLastRate}    ,
    ${lastRate_Val}    Get From List    ${lastRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${lastRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    lastRate=${NONE}
    ...    ELSE IF    '${lastRate_Val}'==''    Set To Dictionary    ${New_JSON}    lastRate=${EMPTY}
    ...    ELSE IF    '${lastRate_Val}'=='Empty' or '${lastRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    lastRate=${EMPTY}
    ...    ELSE IF    '${lastRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    lastRate=${${lastRate_Val}}
	
	${rateEffectiveDate_List}    Split String    ${sRateEffDate}    ,
    ${rateEffectiveDate_Val}    Get From List    ${rateEffectiveDate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${rateEffectiveDate_Val}'=='null'    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${NONE}
    ...    ELSE IF    '${rateEffectiveDate_Val}'==''    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${EMPTY}
    ...    ELSE IF    '${rateEffectiveDate_Val}'=='Empty' or '${rateEffectiveDate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${EMPTY}
    ...    ELSE IF    '${rateEffectiveDate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${rateEffectiveDate_Val}
	
	${spreadRate_List}    Split String    ${iSpreadRate}    ,
    ${spreadRate_Val}    Get From List    ${spreadRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${spreadRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    spreadRate=${NONE}
    ...    ELSE IF    '${spreadRate_Val}'==''    Set To Dictionary    ${New_JSON}    spreadRate=${EMPTY}
    ...    ELSE IF    '${spreadRate_Val}'=='Empty' or '${spreadRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    spreadRate=${EMPTY}
    ...    ELSE IF    '${spreadRate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    spreadRate=${${spreadRate_Val}}
	
	${spreadEffectiveDate_List}    Split String    ${sSpreadEffDate}    ,
    ${spreadEffectiveDate_Val}    Get From List    ${spreadEffectiveDate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${spreadEffectiveDate_Val}'=='null'    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${NONE}
    ...    ELSE IF    '${spreadEffectiveDate_Val}'==''    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${EMPTY}
    ...    ELSE IF    '${spreadEffectiveDate_Val}'=='Empty' or '${spreadEffectiveDate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${EMPTY}
    ...    ELSE IF    '${spreadEffectiveDate_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${spreadEffectiveDate_Val}
	
	${rateTenor_List}    Split String    ${sRateTenor}    ,
    ${rateTenor_Val}    Get From List    ${rateTenor_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${rateTenor_Val}'=='null'    Set To Dictionary    ${New_JSON}    rateTenor=${NONE}
    ...    ELSE IF    '${rateTenor_Val}'==''    Set To Dictionary    ${New_JSON}    rateTenor=${EMPTY}
    ...    ELSE IF    '${rateTenor_Val}'=='Empty' or '${rateTenor_Val}'=='empty'    Set To Dictionary    ${New_JSON}    rateTenor=${EMPTY}
    ...    ELSE IF    '${rateTenor_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    rateTenor=${rateTenor_Val}
    
    ${instrumentType_List}    Split String    ${sInstrumentType}    ,
    ${instrumentType_Val}    Get From List    ${instrumentType_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${instrumentType_Val}'=='null'    Set To Dictionary    ${New_JSON}    instrumentType=${NONE}
    ...    ELSE IF    '${instrumentType_Val}'==''    Set To Dictionary    ${New_JSON}    instrumentType=${EMPTY}
    ...    ELSE IF    '${instrumentType_Val}'=='Empty' or '${instrumentType_Val}'=='empty'    Set To Dictionary    ${New_JSON}    instrumentType=${EMPTY}
    ...    ELSE IF    '${instrumentType_Val}'=='no tag'    Set Variable    ${New_JSON}
    ...    ELSE    Set To Dictionary    ${New_JSON}    instrumentType=${instrumentType_Val}
	
   ${LOB_list}    Split String    ${sLOB}    ,
   ${Val_LOB_0}    Get From List    ${LOB_list}    ${iListIndex}
   ${LOB_list}    Split String    ${Val_LOB_0}    /
   ${LOB_count}    Get Length    ${LOB_list}
   
   ${businessEntityNameList}    Split String    ${sBussEntityName}    ,
   ${Val_businessEntityName_0}    Get From List    ${businessEntityNameList}    ${iListIndex}
   ${businessEntityName_list}    Split String    ${Val_businessEntityName_0}    /
   
   ${subEntityList}    Split String    ${sSubEntity}    ,
   ${Val_subEntity_0}    Get From List    ${subEntityList}    ${iListIndex}
   ${subEntity_List}    Split String    ${Val_subEntity_0}    /
   
   ${lineOfBusinessList}    Create List
   
   :FOR    ${Index_0}    IN RANGE    ${LOB_count}
   \    Log    ${Index_0}
   \    ${Val_LOB}    Get From List    ${LOB_list}    ${Index_0}
   \    
   \    ###check lineOfBusiness if null or empty or have valid value###
   \    ${Val_LOB_0}    Run Keyword If    '${sLOB}'!=''    Get From List    ${LOB_list}    0
   \    ${Val_LOB}    Run Keyword If    '${Val_LOB_0}'=='lineOfBusiness=""'    Set Variable    ${EMPTY}
        ...    ELSE IF    '${Val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE IF    '${Val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
        ...    ELSE    Set Variable    ${Val_LOB}
   \    
   \    ${businessEntityNameDictionary}    Create Array for Multiple Values    ${businessEntityName_list}    ${Index_0}    businessEntityName    |
   \    ${subEntityDictionary}    Create Array for Multiple Values    ${subEntity_List}    ${Index_0}    subEntity    |
   \    
   \    ${lineOfBusinessDictionary}    Create Dictionary    lineOfBusiness=${Val_LOB}
        ...    businessEntityName=${businessEntityNameDictionary}    subEntity=${subEntityDictionary}
   \    
   \    ${businessEntityNameVal}    Get From List    ${businessEntityNameList}    ${Index_0}
   \    ${subEntityVal}    Get From List    ${subEntityList}    ${Index_0}
   \    Run Keyword If    '${businessEntityNameVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    businessEntityName
   \    Run Keyword If    '${subEntityVal}'=='no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    subEntity
   \    Run Keyword If    '${Val_LOB}'=='lineOfBusiness=no tag'    Remove From Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness
   \    
   \    Append To List    ${lineOfBusinessList}    ${lineOfBusinessDictionary}    
   \    Exit For Loop If    ${Index_0}==${LOB_count} or '${sLOB}'==''
   
   ${LOBS_Dict}    Create List    
   
   ###add values to lobs
   ${New_JSON}    Run Keyword If    '${Val_LOB_0}'=='null'    Set To Dictionary    ${New_JSON}    lobs=${NONE}    
   ...    ELSE IF    '${Val_LOB_0}'==''    Set To Dictionary    ${New_JSON}    lobs=${LOBS_Dict}
   ...    ELSE IF    '${Val_LOB_0}'=='Empty' or '${Val_LOB_0}'=='empty'    Set To Dictionary    ${New_JSON}    lobs=${LOBS_Dict}
   ...    ELSE IF    '${Val_LOB_0}'=='no tag'    Set Variable    ${New_JSON}
   ...    ELSE    Set To Dictionary    ${New_JSON}    lobs=${lineOfBusinessList}
   Log    ${New_JSON}
   
   [Return]    ${New_JSON}

Handle LOBS value for multiple value
    [Documentation]    This keyword is used to input value to LOBS when value is no tag, null or empty.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${aLOBSList}    ${iDataIndex}    ${eJSON_Object}    ${aLineOfBusinessList}
    
    ${Val_LOBS}    Get From List    ${aLOBSList}    ${iDataIndex}
    ${LOBS_Dict}    Create List
    ${New_JSON}    Run Keyword If    '${Val_LOBS}'=='null'    Set To Dictionary    ${eJSON_Object}    lobs=${NONE}    
   ...    ELSE IF    '${Val_LOBS}'==''    Set To Dictionary    ${eJSON_Object}    lobs=${LOBS_Dict}
   ...    ELSE IF    '${Val_LOBS}'=='Empty' or '${Val_LOBS}'=='empty'    Set To Dictionary    ${eJSON_Object}    lobs=${LOBS_Dict}
   ...    ELSE IF    '${Val_LOBS}'=='no tag'    Remove From Dictionary    ${eJSON_Object}    lobs
   ...    ELSE    Set To Dictionary    ${eJSON_Object}    lobs=${aLineOfBusinessList}
   Log    ${New_JSON}

Create Expected API response for Base Rate API
    [Documentation]    This keyword is used to create single or multiple JSON payload for Base Rate API.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sInputFilePath}    ${sInputAPIResponse}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}
    ...    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}    ${sInstrumentType}    ${sLOB}
    ...    ${sBussEntityName}    ${sSubEntity}
    
    ${BaseRate_List}    Split String    ${sBaseRateCode}    ,
    ${BaseRate_Count}    Get Length    ${BaseRate_List}
    ${Index}    Set Variable    0
    ${JSON_File}    Set Variable    ${sInputFilePath}${sInputAPIResponse}.json
    Delete File If Exist    ${dataset_path}${JSON_File}
    :FOR    ${Index}    IN RANGE    ${BaseRate_Count}
    \    ${New_JSON}    Update Expected API Response for Base Rate API    ${Index}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}
         ...    ${iMidRate}    ${iSellRate}    ${iLastRate}    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}
         ...    ${sInstrumentType}    ${sLOB}    ${sBussEntityName}    ${sSubEntity}
    \    Log    ${New_JSON}
    \    ${Converted_JSON}    Evaluate    json.dumps(${New_JSON})        json
    \    Log    ${Converted_JSON}
    \    Run Keyword If    ${Index}==0    Append To File    ${dataset_path}${JSON_File}    ${Converted_JSON}
    \    Run Keyword If    ${Index}!=0    Append To File    ${dataset_path}${JSON_File}    ,${Converted_JSON}
    \    Exit For Loop If    ${Index}==${BaseRate_Count}
    
    ${File}    OperatingSystem.Get File    ${dataset_path}${JSON_File}
    ${Converted_File}    Catenate    SEPARATOR=    [    ${File}    ]
    Delete File If Exist    ${dataset_path}${JSON_File}
    Create File    ${dataset_path}${JSON_File}    ${Converted_File}

Update Expected API Response for Base Rate API
    [Documentation]    This keyword is used to update expected API Response.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${iListIndex}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}
    ...    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}    ${sInstrumentType}    ${sLOB}
    ...    ${sBussEntityName}    ${sSubEntity}
    
    ${File_Path}    Set Variable    ${TEMPLATEINPUT}    
    ${EMPTY}    Set Variable    
    ${JSON_Object}    Load JSON From File    ${File_Path}
    
    ${baseRateCode_List}    Split String    ${sBaseRateCode}    ,
    ${baseRateCode_Val}    Get From List    ${baseRateCode_List}    ${iListIndex}
    ${New_JSON}    Run Keyword If    '${baseRateCode_Val}'=='null'    Set To Dictionary    ${JSON_Object}    baseRateCode=${NONE}
    ...    ELSE IF    '${baseRateCode_Val}'==''    Set To Dictionary    ${JSON_Object}    baseRateCode=${EMPTY}
    ...    ELSE IF    '${baseRateCode_Val}'=='Empty' or '${baseRateCode_Val}'=='empty'    Set To Dictionary    ${JSON_Object}    baseRateCode=${EMPTY}
    ...    ELSE IF    '${baseRateCode_Val}'=='no tag'    Set To Dictionary    ${JSON_Object}    baseRateCode=${NONE}
    ...    ELSE    Set To Dictionary    ${JSON_Object}    baseRateCode=${baseRateCode_Val}
    
    ${currency_List}    Split String    ${sCurrency}    ,
    ${currency_Val}    Get From List    ${currency_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${currency_Val}'=='null'    Set To Dictionary    ${New_JSON}    currency=${NONE}
    ...    ELSE IF    '${currency_Val}'==''    Set To Dictionary    ${New_JSON}    currency=${EMPTY}
    ...    ELSE IF    '${currency_Val}'=='Empty' or '${currency_Val}'=='empty'    Set To Dictionary    ${New_JSON}    currency=${EMPTY}
    ...    ELSE IF    '${currency_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    currency=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    currency=${currency_Val}
    
    ${buyRate_List}    Split String    ${iBuyRate}    ,
    ${buyRate_Val}    Get From List    ${buyRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${buyRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    buyRate=${NONE}
    ...    ELSE IF    '${buyRate_Val}'==''    Set To Dictionary    ${New_JSON}    buyRate=${EMPTY}
    ...    ELSE IF    '${buyRate_Val}'=='Empty' or '${buyRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    buyRate=${EMPTY}
    ...    ELSE IF    '${buyRate_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    buyRate=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    buyRate=${${buyRate_Val}}
    
    ${midRate_List}    Split String    ${iMidRate}    ,
    ${midRate_Val}    Get From List    ${midRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${midRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    midRate=${NONE}
    ...    ELSE IF    '${midRate_Val}'==''    Set To Dictionary    ${New_JSON}    midRate=${EMPTY}
    ...    ELSE IF    '${midRate_Val}'=='Empty' or '${midRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    midRate=${EMPTY}
    ...    ELSE IF    '${midRate_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    midRate=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    midRate=${${midRate_Val}}
    
    ${sellRate_List}    Split String    ${iSellRate}    ,
    ${sellRate_Val}    Get From List    ${sellRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${sellRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    sellRate=${NONE}
    ...    ELSE IF    '${sellRate_Val}'==''    Set To Dictionary    ${New_JSON}    sellRate=${EMPTY}
    ...    ELSE IF    '${sellRate_Val}'=='Empty' or '${sellRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    sellRate=${EMPTY}
    ...    ELSE IF    '${sellRate_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    sellRate=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    sellRate=${${sellRate_Val}}
	
	${lastRate_List}    Split String    ${iLastRate}    ,
    ${lastRate_Val}    Get From List    ${lastRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${lastRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    lastRate=${NONE}
    ...    ELSE IF    '${lastRate_Val}'==''    Set To Dictionary    ${New_JSON}    lastRate=${EMPTY}
    ...    ELSE IF    '${lastRate_Val}'=='Empty' or '${lastRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    lastRate=${EMPTY}
    ...    ELSE IF    '${lastRate_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    lastRate=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    lastRate=${${lastRate_Val}}
	
	${rateEffectiveDate_List}    Split String    ${sRateEffDate}    ,
    ${rateEffectiveDate_Val}    Get From List    ${rateEffectiveDate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${rateEffectiveDate_Val}'=='null'    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${NONE}
    ...    ELSE IF    '${rateEffectiveDate_Val}'==''    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${EMPTY}
    ...    ELSE IF    '${rateEffectiveDate_Val}'=='Empty' or '${rateEffectiveDate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${EMPTY}
    ...    ELSE IF    '${rateEffectiveDate_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    rateEffectiveDate=${rateEffectiveDate_Val}
	
	${spreadRate_List}    Split String    ${iSpreadRate}    ,
    ${spreadRate_Val}    Get From List    ${spreadRate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${spreadRate_Val}'=='null'    Set To Dictionary    ${New_JSON}    spreadRate=${NONE}
    ...    ELSE IF    '${spreadRate_Val}'==''    Set To Dictionary    ${New_JSON}    spreadRate=${NONE}
    ...    ELSE IF    '${spreadRate_Val}'=='Empty' or '${spreadRate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    spreadRate=${NONE}
    ...    ELSE IF    '${spreadRate_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    spreadRate=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    spreadRate=${${spreadRate_Val}}
	
	${spreadEffectiveDate_List}    Split String    ${sSpreadEffDate}    ,
    ${spreadEffectiveDate_Val}    Get From List    ${spreadEffectiveDate_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${spreadEffectiveDate_Val}'=='null'    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${NONE}
    ...    ELSE IF    '${spreadEffectiveDate_Val}'==''    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${NONE}
    ...    ELSE IF    '${spreadEffectiveDate_Val}'=='Empty' or '${spreadEffectiveDate_Val}'=='empty'    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${NONE}
    ...    ELSE IF    '${spreadEffectiveDate_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    spreadEffectiveDate=${spreadEffectiveDate_Val}
	
	${rateTenor_List}    Split String    ${sRateTenor}    ,
    ${rateTenor_Val}    Get From List    ${rateTenor_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${rateTenor_Val}'=='null'    Set To Dictionary    ${New_JSON}    rateTenor=${NONE}
    ...    ELSE IF    '${rateTenor_Val}'==''    Set To Dictionary    ${New_JSON}    rateTenor=${EMPTY}
    ...    ELSE IF    '${rateTenor_Val}'=='Empty' or '${rateTenor_Val}'=='empty'    Set To Dictionary    ${New_JSON}    rateTenor=${EMPTY}
    ...    ELSE IF    '${rateTenor_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    rateTenor=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    rateTenor=${rateTenor_Val}
    
    ${instrumentType_List}    Split String    ${sInstrumentType}    ,
    ${instrumentType_Val}    Get From List    ${instrumentType_List}    ${iListIndex}
	${New_JSON}    Run Keyword If    '${instrumentType_Val}'=='null'    Set To Dictionary    ${New_JSON}    instrumentType=${NONE}
    ...    ELSE IF    '${instrumentType_Val}'==''    Set To Dictionary    ${New_JSON}    instrumentType=${EMPTY}
    ...    ELSE IF    '${instrumentType_Val}'=='Empty' or '${instrumentType_Val}'=='empty'    Set To Dictionary    ${New_JSON}    instrumentType=${EMPTY}
    ...    ELSE IF    '${instrumentType_Val}'=='no tag'    Set To Dictionary    ${New_JSON}    instrumentType=${NONE}
    ...    ELSE    Set To Dictionary    ${New_JSON}    instrumentType=${instrumentType_Val}
    	
	${LOB_list}    Split String    ${sLOB}    ,
	${Val_LOB_0}    Get From List    ${LOB_list}    ${iListIndex}
    ${LOB_list}    Split String    ${Val_LOB_0}    /
	${LOB_count}    Get Length    ${LOB_list}
   
	${businessEntityNameList}    Split String    ${sBussEntityName}    ,
	${Val_businessEntityName_0}    Get From List    ${businessEntityNameList}    ${iListIndex}
    ${businessEntityName_list}    Split String    ${Val_businessEntityName_0}    /
    
    ${subEntityList}    Split String    ${sSubEntity}    ,
    ${Val_subEntity_0}    Get From List    ${subEntityList}    ${iListIndex}
    ${subEntity_List}    Split String    ${Val_subEntity_0}    /
    
    ${lineOfBusinessList}    Create List
    
    :FOR    ${Index_0}    IN RANGE    ${LOB_count}
    \    Log    ${Index_0}
	\    ${Val_LOB}    Get From List    ${LOB_list}    ${Index_0}
	\    
	\    ###check lineOfBusiness if null or empty or have valid value###
	\    ${Val_LOB_0}    Run Keyword If    '${sLOB}'!=''    Get From List    ${LOB_list}    ${Index_0}
	\    ${Val_LOB}    Run Keyword If    '${Val_LOB_0}'=='lineOfBusiness=""'    Set Variable    ${EMPTY}
	     ...    ELSE IF    '${Val_LOB_0}'=='lineOfBusiness=null'    Set Variable    ${NONE}
	     ...    ELSE    Set Variable    ${Val_LOB}
	\    
	\    ${businessEntityNameDictionary}    Create Array for Multiple Values for Expected Response    ${businessEntityName_list}    ${Index_0}    businessEntityName    |
	\    ${subEntityDictionary}    Create Array for Multiple Values for Expected Response    ${subEntity_List}    ${Index_0}    subEntity    |
	\    
	\    ${lineOfBusinessDictionary}    Create Dictionary    lineOfBusiness=${Val_LOB}
	     ...    businessEntityName=${businessEntityNameDictionary}    subEntity=${subEntityDictionary}
	\    
	\    ${businessEntityNameVal}    Get From List    ${businessEntityNameList}    ${Index_0}
	\    ${subEntityVal}    Get From List    ${subEntityList}    ${Index_0}
	\    Run Keyword If    '${businessEntityNameVal}'=='no tag'    Set To Dictionary    ${lineOfBusinessDictionary}    businessEntityName=${NONE}
	\    Run Keyword If    '${subEntityVal}'=='no tag'    Set To Dictionary    ${lineOfBusinessDictionary}    subEntity=${NONE}
	\    Run Keyword If    '${Val_LOB}'=='no tag'    Set To Dictionary    ${lineOfBusinessDictionary}    lineOfBusiness=${NONE}
	\    
	\    Append To List    ${lineOfBusinessList}    ${lineOfBusinessDictionary}
	\    Exit For Loop If    ${Index_0}==${LOB_count} or '${sLOB}'==''
   
    ###add values to lobs###
    ${New_JSON}    Run Keyword If    '${sLOB}'=='null'    Set To Dictionary    ${New_JSON}    lobs=${NONE}
    ...    ELSE IF    '${sLOB}'==''    Set To Dictionary    ${New_JSON}    lobs=${EMPTY}
    ...    ELSE IF    '${sLOB}'=='Empty' or '${sLOB}'=='empty'    Set To Dictionary    ${New_JSON}    lobs=${EMPTY}
    ...    ELSE    Set To Dictionary    ${New_JSON}    lobs=${lineOfBusinessList}
    Log    ${New_JSON}
   
    [Return]    ${New_JSON}

Update Expected XML Elements for Base Rate wsFinalLIQDestination
    [Documentation]    This keyword is used to update XML Elements using the input json values for wsFinalLIQDestination for Base Rate API.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    25MAR2019    - added computation for Val_Rate when sent to LIQ, as per FBC-2591, update verification of spread rate and date
    [Arguments]    ${iListIndex}    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}    ${Val_BaseCode}    ${Val_Currency}    ${Val_RateEffDate}    ${Val_SpreadRate}    ${Val_SpreadEffDate}
    ...    ${Val_RateTenor}    ${Val_Subentity}    ${Val_Rate}
    
    ${Expected_wsFinalLIQDestination}    Set Variable    ${dataset_path}${sInputFilePath}${sExpected_wsFinalLIQDestination}_${Val_BaseCode}_${Val_RateTenor}_${Val_Subentity}.xml
    ${Template}    Set Variable    ${dataset_path}${sInputFilePath}template_TextJMS_baserate.xml
    Delete File If Exist    ${Expected_wsFinalLIQDestination}
    
    ${xpath}    Set Variable    UpdateFundingRate
    ${Converted_EffDate}    Convert Date    ${Val_RateEffDate}    result_format=%d-%b-%Y
    ${converted_spreaddate}    Run Keyword If    '${Val_SpreadEffDate}'=='null'    Set Variable    ${NONE}
    ...    ELSE IF    '${Val_SpreadEffDate}'==''    Set Variable    ${NONE}
    ...    ELSE IF    '${Val_SpreadEffDate}'=='no tag'    Set Variable    ${NONE}
    ...    ELSE    Convert Date    ${Val_SpreadEffDate}    result_format=%d-%b-%Y
    ${currency}    Get From List    ${Val_Currency}    ${iListIndex}
    ${ConvertedRate}    Evaluate    ${Val_Rate}*0.01
    ${ConvertedRate}    Convert To String    ${ConvertedRate}
    
    ${Updated_Template}    Set Element Attribute    ${Template}    baseRate    ${Val_BaseCode}    xpath=${xpath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    currency    ${Val_Currency}    xpath=${xpath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    effectiveDate    ${Converted_EffDate}    xpath=${xpath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    repricingFrequency    ${Val_RateTenor}    xpath=${xpath}
    ${Updated_Template}    Run Keyword If    ${converted_spreaddate}==${NONE}    Remove Element Attribute    ${Updated_Template}    spreadEffectiveDate    xpath=${xpath}
    ...    ELSE    Set Element Attribute    ${Updated_Template}    spreadEffectiveDate    ${converted_spreaddate}    xpath=${xpath}
    ${Updated_Template}    Run Keyword If    '${Val_SpreadRate}'=='null'    Remove Element Attribute    ${Updated_Template}    spreadRate    xpath=${xpath}
    ...    ELSE IF    '${Val_SpreadRate}'==''    Remove Element Attribute    ${Updated_Template}    spreadRate    xpath=${xpath}
    ...    ELSE IF    '${Val_SpreadRate}'=='no tag'    Remove Element Attribute    ${Updated_Template}    spreadRate    xpath=${xpath}
    ...    ELSE    Set Element Attribute    ${Updated_Template}    spreadRate    ${Val_SpreadRate}    xpath=${xpath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    fundingDesk    ${Val_Subentity}    xpath=${xpath}
    ${Updated_Template}    Set Element Attribute    ${Updated_Template}    rate    ${ConvertedRate}    xpath=${xpath}
    
    ${Attribute}    XML.Get Element Attributes    ${Updated_Template}    ${xpath}
    Log    ${Attribute}
    Save Xml    ${Updated_Template}    ${Expected_wsFinalLIQDestination}

Create Final wsFinalLIQDestination for Base Rate API
    [Documentation]    This keyword is used to create final wsFinalLIQDestination for each valid Base Rate Code.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}
    ...    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}    ${sLOB}    ${sSubEntity}
    
    ${LOB_List}    Split String    ${sLOB}    ,
    ${LOB_count}    Get Length    ${LOB_List}
    
    ${subEntity_List}    Split String    ${sSubEntity}    ,
    
    :FOR    ${Index}    IN RANGE    ${LOB_count}
    \    
    \    ${Val_LOB}    Get From List    ${LOB_List}    ${Index}
    \    ${lineOfBusiness_List}    Split String    ${Val_LOB}    /
    \    
    \    ${Val_subEntity}    Get From List    ${subEntity_List}    ${Index}
    \    ${subEntity_List_LOB}    Split String    ${Val_subEntity}    /
    \    ${LOBS_Subentity_dict}    Get Subentity value for individual lineOfBusiness    ${lineOfBusiness_List}    ${subEntity_List_LOB}
    \    ${LOB_Exists}    Run Keyword And Return Status    Get From Dictionary    ${LOBS_Subentity_Dict}    COMRLENDING
    \    ${LOBS_Subentity}    Run Keyword If    ${LOB_Exists}==True    Get From Dictionary    ${LOBS_Subentity_Dict}    COMRLENDING
         ...    ELSE    Log    COMRLENDING is not existing in the payload.
    \    ##for now (01/25/2019), COMRLENDING is the only LOB that is creating XML. If other lobs will be open, substitute var for LOBS on COMRLENDING.
    \    Run Keyword If    ${LOB_Exists}==True    Get individual Subentity value and Create XML    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}    
         ...    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}    ${sRateEffDate}    ${iSpreadRate}
         ...    ${sSpreadEffDate}    ${sRateTenor}    ${LOBS_Subentity}
         ...    ELSE    Log    COMRLENDING is not existing in the payload.
    \    Exit For Loop If    ${Index}==${LOB_count}

Get Subentity value for individual lineOfBusiness
    [Documentation]    This keyword is used to get LOBS value/s for individual base rate code.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${aLineOfBusinessList}    ${aSubentityList_LOB}
    
    ${LineOfBusiness_Count}    Get Length    ${aLineOfBusinessList}
    ${LOBS_Subentity_Dict}    Create Dictionary    
    :FOR    ${Index}    IN RANGE    ${LineOfBusiness_Count}
    \    ${Val_lineOfBusiness}    Get From List    ${aLineOfBusinessList}    ${Index}
    \    ${Val_subEntity_LOB}    Get From List    ${aSubentityList_LOB}    ${Index}
    \    Set To Dictionary    ${LOBS_Subentity_Dict}    ${Val_lineOfBusiness}=${Val_subEntity_LOB}
    \    Exit For Loop If    ${Index}==${LineOfBusiness_Count}
    [Return]    ${LOBS_Subentity_Dict}    
    
Get individual Subentity value and Create XML
    [Documentation]    This keyword is used to get individual subentity values for multiple subentities in one line of business values.
    ...    i.e. sample input in datasheet AUD|NY
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}
    ...    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}    ${sSubEntity}
    
    ${Subentity_List}    Split String    ${sSubEntity}    |
    ${Subentity_Count}    Get Length    ${Subentity_List}
    
    ${INDEX}    Set Variable    0
    :FOR    ${INDEX}    IN RANGE    ${Subentity_Count}
    \    ${Val_subentity}    Get From List    ${Subentity_List}    ${INDEX}
    \    Create Initial wsFinalLIQDestination for Base Rate API    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}    ${sBaseRateCode}    ${sCurrency}    
         ...    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}    ${Val_subentity}
    \    Exit For Loop If    ${INDEX}==${Subentity_Count}

Create Initial wsFinalLIQDestination for Base Rate API
    [Documentation]    This keyword is used to create initial wsFinalLIQDestination for each valid Base Rate Code.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    05APR2019    - added handling when rate value is null
    [Arguments]    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}
    ...    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}    ${sSubEntity}
    
    ###create list for base rate code###
    ${BaseRateCode_List}    Split String    ${sBaseRateCode}    ,
    ${BaseRateCode_count}    Get Length    ${BaseRateCode_List}
    
    ###create list for fields###
    ${BuyRate_List}    Split String    ${iBuyRate}    ,
    ${MidRate_List}    Split String    ${iMidRate}    ,
    ${SellRate_List}    Split String    ${iSellRate}    ,
    ${LastRate_List}    Split String    ${iLastRate}    ,
    ${Currency_List}    Split String    ${sCurrency}    ,
    ${RateEffDate_List}    Split String    ${sRateEffDate}    ,
    ${SpreadRate_List}    Split String    ${iSpreadRate}    ,
    ${SpreadEffDate_List}    Split String    ${sSpreadEffDate}    ,
    ${RateTenor_List}    Split String    ${sRateTenor}    ,
    
    ###get base rate code config###
    ${BASERATECODEConfig}    OperatingSystem.Get File    ${BASERATECODE_Config}
    ${BASERATECODE_Dict}    Convert Base Rate Config to Dictionary
    
    ###create file with error message###
    Delete File If Exist    ${dataset_path}${sInputFilePath}${Expected_Error_Message}
    Create File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    
    
    :FOR    ${Index}    IN RANGE    ${BaseRateCode_count}
    \    
    \    ${Val_BaseRateCode}    Get From List    ${BaseRateCode_List}    ${Index}
    \    ${Val_Currency}    Get From List    ${Currency_List}    ${Index}
    \    ${Val_RateEffDate}    Get From List    ${RateEffDate_List}    ${Index}
    \    ${Val_SpreadRate}    Get From List    ${SpreadRate_List}    ${Index}
    \    ${Val_SpreadEffDate}    Get From List    ${SpreadEffDate_List}    ${Index}
    \    ${Val_RateTenor}    Get From List    ${RateTenor_List}    ${Index}
    \    
    \    Log    Config check for Base Rate Code and Buy Rate
    \    ${Val_BuyRate}    Get From List    ${BuyRate_List}    ${Index}
    \    ${BUYRATE}    Run Keyword If    '${Val_BuyRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_BuyRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_BuyRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    BUYRATE
    \    ${BaseConfig_Buy_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${BUYRATE}
    \    ${BaseCode_Buy}    Run Keyword If    ${BaseConfig_Buy_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${BUYRATE}
    \    ${Expected_Error}    Run Keyword If    ${BaseConfig_Buy_exist}==True    Update Expected XML Elements for Base Rate wsFinalLIQDestination    ${Index}    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}    
         ...    ${BaseCode_Buy}    ${Val_Currency}    ${Val_RateEffDate}    ${Val_SpreadRate}    ${Val_SpreadEffDate}    ${Val_RateTenor}    ${sSubEntity}    ${Val_BuyRate}
         ...    ELSE IF    '${Val_BuyRate}'!='0' and '${Val_BuyRate}'!='null'    Catenate    There is no baseratecode configuration available at COMRLENDING corresponding to baseratecode-${Val_BaseRateCode}${SPACE}${SPACE}and Buyrate:${Val_BuyRate}
    \    
    \    Run Keyword If    '${Expected_Error}'!='None'    Append To File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    ${Expected_Error}${\n}    
    \    
    \    Log    Config check for Base Rate Code and Mid Rate
    \    ${Val_MidRate}    Get From List    ${MidRate_List}    ${Index}
    \    ${MIDRATE}    Run Keyword If    '${Val_MidRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_MidRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_MidRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    MIDRATE
    \    ${BaseConfig_Mid_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${MIDRATE}
    \    ${BaseCode_Mid}    Run Keyword If    ${BaseConfig_Mid_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${MIDRATE}
    \    ${Expected_Error}    Run Keyword If    ${BaseConfig_Mid_exist}==True    Update Expected XML Elements for Base Rate wsFinalLIQDestination    ${Index}    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}            
         ...    ${BaseCode_Mid}    ${Val_Currency}    ${Val_RateEffDate}    ${Val_SpreadRate}    ${Val_SpreadEffDate}    ${Val_RateTenor}    ${sSubEntity}    ${Val_MidRate}
         ...    ELSE IF    '${Val_MidRate}'!='0' and '${Val_MidRate}'!='null'    Catenate    There is no baseratecode configuration available at COMRLENDING corresponding to baseratecode-${Val_BaseRateCode}${SPACE}${SPACE}and Midrate:${Val_MidRate}
    \    
    \    Run Keyword If    '${Expected_Error}'!='None'    Append To File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    ${Expected_Error}${\n}
    \    
    \    Log    Config check for Base Rate Code and Sell Rate
    \    ${Val_SellRate}    Get From List    ${SellRate_List}    ${Index}
    \    ${SELLRATE}    Run Keyword If    '${Val_SellRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_SellRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_SellRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    SELLRATE
    \    ${BaseConfig_Sell_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${SELLRATE}
    \    ${BaseCode_Sell}    Run Keyword If    ${BaseConfig_Sell_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${SELLRATE}
    \    ${Expected_Error}    Run Keyword If    ${BaseConfig_Sell_exist}==True    Update Expected XML Elements for Base Rate wsFinalLIQDestination    ${Index}    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}            
         ...    ${BaseCode_Sell}    ${Val_Currency}    ${Val_RateEffDate}    ${Val_SpreadRate}    ${Val_SpreadEffDate}    ${Val_RateTenor}    ${sSubEntity}    ${Val_SellRate}
         ...    ELSE IF    '${Val_SellRate}'!='0' and '${Val_SellRate}'!='null'    Catenate    There is no baseratecode configuration available at COMRLENDING corresponding to baseratecode-${Val_BaseRateCode}${SPACE}${SPACE}and Sellrate:${Val_SellRate}
    \    
    \    Run Keyword If    '${Expected_Error}'!='None'    Append To File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    ${Expected_Error}${\n}
    \    
    \    Log    Config check for Base Rate Code and Last Rate
    \    ${Val_LastRate}    Get From List    ${LastRate_List}    ${Index}
    \    ${LASTRATE}    Run Keyword If    '${Val_LastRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_LastRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_LastRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    LASTRATE
    \    ${BaseConfig_Last_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${LASTRATE}
    \    ${BaseCode_Last}    Run Keyword If    ${BaseConfig_Last_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${LASTRATE}
    \    ${Expected_Error}    Run Keyword If    ${BaseConfig_Last_exist}==True    Update Expected XML Elements for Base Rate wsFinalLIQDestination    ${Index}    ${sInputFilePath}    ${sExpectedwsFinalLIQDestination}            
         ...    ${BaseCode_Last}    ${Val_Currency}    ${Val_RateEffDate}    ${Val_SpreadRate}    ${Val_SpreadEffDate}    ${Val_RateTenor}    ${sSubEntity}    ${Val_LastRate}
         ...    ELSE IF    '${Val_LastRate}'!='0' and '${Val_LastRate}'!='null'    Catenate    There is no baseratecode configuration available at COMRLENDING corresponding to baseratecode-${Val_BaseRateCode}${SPACE}${SPACE}and Lastrate:${Val_LastRate}
    \    
    \    Run Keyword If    '${Expected_Error}'!='None'    Append To File    ${dataset_path}${sInputFilePath}${Expected_Error_Message}    ${Expected_Error}${\n}
    \    
    \    Exit For Loop If    ${Index}==${BaseRateCode_count}

Convert Base Rate Config to Dictionary
    [Documentation]    This keyword is used to convert base rate config into dictionary to be used by robot script.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    
    ${BASERATECODEConfig}    OperatingSystem.Get File    ${BASERATECODE_Config}
    ${BASERATECODE_Count}    Get Line Count    ${BASERATECODEConfig}
    ${BASERATECODE_Dict}    Create Dictionary
    ${i}    Set Variable    0
    :FOR    ${i}    IN RANGE    ${BASERATECODE_Count}
    \    ${BASERATECODE}    Get Line    ${BASERATECODEConfig}    ${i}
    \    ${BASERATECODE_List}    Split String    ${BASERATECODE}    ${SPACE}=${SPACE}
    \    ${Key}    Get From List    ${BASERATECODE_List}    0
    \    ${Value}    Get From List    ${BASERATECODE_List}    1
    \    Set To Dictionary    ${BASERATECODE_Dict}    ${Key}=${Value}
    \    Exit For Loop If    '${i}'=='${BASERATECODE_Count}'
    Log    ${BASERATECODE_Dict}
    
    [Return]    ${BASERATECODE_Dict}
    
Verify Base Rate Code and Repricing Frequecy combination if existing in LIQ
    [Documentation]    This keyword is used to verify if base rate code and repricing frequency is not existing in LIQ, then add it.
    ...    @author: clanding
    ...    @update: clanding    22MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${aLineOfBusinessList}    ${sBaseRateCode}    ${sRateTenor}
    
    ${LOB_Count}    Get Length    ${aLineOfBusinessList}
    
    :FOR    ${INDEX}    IN RANGE    ${LOB_Count}
    \    
    \    ${Val_lineOfBusiness}    Get From List    ${aLineOfBusinessList}    ${INDEX}
    \    ${OptionNameDesc}    ${OptionName}    Run Keyword If    '${Val_lineOfBusiness}'=='COMRLENDING'    Get Option Name from Option Name and Base Rate Association    ${sBaseRateCode}
    \    ${RepricingFrequency_Text}    Run Keyword If    '${Val_lineOfBusiness}'=='COMRLENDING'    Get Base Rate Repricing Frequency Label    ${sRateTenor}
    \    ${RepricingFrequency}    Run Keyword If    '${Val_lineOfBusiness}'=='COMRLENDING'    Strip String    ${sRateTenor}    mode=left    characters=0    
    \    Run Keyword If    '${Val_lineOfBusiness}'=='COMRLENDING'    Add Option Name and Repricing Frequency    ${sBaseRateCode}    ${sRateTenor}    ${OptionNameDesc}    ${OptionName}
         ...    ELSE    Log    COMRLENDING is not existing in the payload.
    \    
    \    Exit For Loop If    ${INDEX}==${LOB_Count}

Create Individual Expected JSON for Base Rate API
    [Documentation]    This keyword is used to create indeividual expected JSON payload for Base Rate API using the dataset.
    ...    @author: clanding    25MAR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJson}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}
    ...    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}    ${sInstrumentType}    ${sLOB}
    ...    ${sBussEntityName}    ${sSubEntity}
        
    ${BaseRate_List}    Split String    ${sBaseRateCode}    ,
    ${BaseRate_Count}    Get Length    ${BaseRate_List}
    ${JSON_File}    Set Variable    ${sInputFilePath}${sInputJson}.json
    :FOR    ${Index}    IN RANGE    ${BaseRate_Count}
    \    
    \    ${New_JSON}    Update Expected API Response for Base Rate API    ${Index}    ${sBaseRateCode}    ${sCurrency}    ${iBuyRate}
         ...    ${iMidRate}    ${iSellRate}    ${iLastRate}    ${sRateEffDate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sRateTenor}
         ...    ${sInstrumentType}    ${sLOB}    ${sBussEntityName}    ${sSubEntity}
    \    
    \    Log    ${New_JSON}
    \    ${converted_json}    Evaluate    json.dumps(${New_JSON})        json
    \    Log    ${converted_json}
    \    
    \    Delete File If Exist    ${dataset_path}${sInputFilePath}${sInputJson}_${sBaseRateCode}_${sRateTenor}.json
    \    Create File    ${dataset_path}${sInputFilePath}${sInputJson}_${sBaseRateCode}_${sRateTenor}.json    ${converted_json}
    \    
    \    Exit For Loop If    ${Index}==${BaseRate_Count}

Create Expected Error List for Base Rate
    [Documentation]    This keyword is used to get keyfield values and get expected error from the value then create expected error list.
    ...    @author: clanding    28MAR2019    - initial create
    [Arguments]    ${sInputFilePath}    ${sInputJSON}
    
    Delete File If Exist    ${EXPECTED_ERROR_LIST}
    ${Val}    ${Key}    Get Data From JSON File and Handle No Output    ${sInputFilePath}${sInputJSON}    instrumentType    2    20
    
    Run Keyword If    ${Val}==${True}    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    2    Base_InstrumentType
    ${Val}    ${Key}    Get Data From JSON File and Handle No Output    ${sInputFilePath}${sInputJSON}    baseRateCode    2    20
    Run Keyword If    ${Val}==${True}    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    2    Base_BaseRateCode
    ...    AND    Set Global Variable    ${TECHNICAL_ERROR}    True
    ...    ELSE IF    ${Key}==${True}    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    1    Base_BaseRateCode
    ...    AND    Set Global Variable    ${TECHNICAL_ERROR}    True
    
    ${Val}    ${Key}    Get Data From JSON File and Handle No Output    ${sInputFilePath}${sInputJSON}    currency    3    3
    Run Keyword If    ${Val}==${True}    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    2    Base_Currency
    ...    AND    Set Global Variable    ${TECHNICAL_ERROR}    True
    ...    ELSE IF    ${Key}==${True}    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    1    Base_Currency
    ...    AND    Set Global Variable    ${TECHNICAL_ERROR}    True
    
    ${Val}    ${Key}    Get Data From JSON File and Handle No Output    ${sInputFilePath}${sInputJSON}    rateTenor    2    4
    Run Keyword If    ${Val}==${True}    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    2    Base_RateTenor
    ...    AND    Set Global Variable    ${TECHNICAL_ERROR}    True
    
    ${Val}    ${Key}    Get Data From JSON File and Handle No Output    ${sInputFilePath}${sInputJSON}    rateEffectiveDate    1    10
    Run Keyword If    ${Val}==${True}    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    2    Base_EffectiveDate
    ...    AND    Set Global Variable    ${TECHNICAL_ERROR}    True
    ...    ELSE IF    ${Key}==${True}    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    1    Base_EffectiveDate
    ...    AND    Set Global Variable    ${TECHNICAL_ERROR}    True
    ${Error_File_Not_Exist}    Run Keyword And Return Status    Should Not Exist    ${EXPECTED_ERROR_LIST}
    ${Functional_Error}    Run Keyword If    ${Error_File_Not_Exist}==${False}    Set Variable    False
    ...    ELSE    Set Variable    False
    
    ${Valid_Val}    ${Field_Value}    Get Data from JSON File and Handle Invalid LOB Value    ${sInputFilePath}${sInputJSON}    lineOfBusiness    2    30
    ${Field_Val_Length}    Get Length    ${Field_Value}
    Run Keyword If    '${Valid_Val}'=='${False}' and ${Field_Val_Length}<2    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message without Newline Character from Error Master List    ${ERROR_MASTER_LIST}    2    Gen_LOBS
    ...    AND    Append To File    ${EXPECTED_ERROR_LIST}    ${SPACE}-${SPACE}{'${Field_Value}'}.${\n}
    ...    AND    Set Global Variable    ${TECHNICAL_ERROR}    True
    ...    ELSE IF    '${Valid_Val}'=='${False}' and ${Field_Val_Length}>30    Run Keywords    Mx Execute Template With Multiple Data    Get Error Message without Newline Character from Error Master List    ${ERROR_MASTER_LIST}    2    Gen_LOBS
    ...    AND    Append To File    ${EXPECTED_ERROR_LIST}    ${SPACE}-${SPACE}{'${Field_Value}'}.${\n}
    ...    AND    Set Global Variable    ${TECHNICAL_ERROR}    True
    ...    ELSE IF    '${Valid_Val}'=='${False}' and '${TECHNICAL_ERROR}'!='${True}' and ${Field_Val_Length}>2    Run Keywords    Append To File    ${EXPECTED_ERROR_LIST}    ${Field_Value}${SPACE}:${SPACE}
    ...    AND    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    6    Gen_LOBS
    ...    AND    Set Global Variable    ${FUNCTIONAL_ERROR}    True
    
    ${Val_buyRate}    ${Key_buyRate}    Get Data From JSON File and Handle No Output    ${sInputFilePath}${sInputJSON}    buyRate    1    20
    ${Val_midRate}    ${Key_midRate}    Get Data From JSON File and Handle No Output    ${sInputFilePath}${sInputJSON}    midRate    1    20
    ${Val_sellRate}    ${Key_sellRate}    Get Data From JSON File and Handle No Output    ${sInputFilePath}${sInputJSON}    sellRate    1    20
    ${Val_lastRate}    ${Key_lastRate}    Get Data From JSON File and Handle No Output    ${sInputFilePath}${sInputJSON}    lastRate    1    20
    ${Error_File_Not_Exist}    Run Keyword And Return Status    Should Not Exist    ${EXPECTED_ERROR_LIST}
    ${Functional_Error_Exist}    Run Keyword And Return Status    Should Contain    ${EXPECTED_ERROR_LIST}    The LOB is not a subscriber to the API        
    ${Functional_Error}    Run Keyword If    ${Error_File_Not_Exist}==${True}    Set Variable    True
    ...    ELSE IF    ${Error_File_Not_Exist}==${False} and ${Valid_Val}==${False} and ${Functional_Error_Exist}==${True}    Set Variable    True    
    ...    ELSE    Set Variable    False
    Run Keyword If    ${Key_buyRate}==${True} and ${Key_midRate}==${True} and ${Key_sellRate}==${True} and ${Key_lastRate}==${True} and '${TECHNICAL_ERROR}'!='${True}'    Run Keywords    
    ...    Mx Execute Template With Multiple Data    Get Error Message from Error Master List    ${ERROR_MASTER_LIST}    1    Base_InterestRate
    ...    AND    Set Global Variable    ${FUNCTIONAL_ERROR}    True
