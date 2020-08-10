*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Validate LoanIQ for Multiple LOB Base Rate API
    [Documentation]    This keyword is used to validate LoanIQ for multiple Line of Business in Base Rate API.
    ...    @clanding    25MAR2019    - initial create
    [Arguments]    ${sLOB}    ${sSubEntity}    ${sBaseRateCode}    ${sRepricingFreq}    ${sEffDate}    ${sCurrency}
    ...    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sLIQError}=N

    ${SubEntity_List}    Split String    ${sSubEntity}    ,
    ${BaseRateCode_List}    Split String    ${sBaseRateCode}    ,
    ${RateTenor_List}    Split String    ${sRepricingFreq}    ,
    ${EffDate_List}    Split String    ${sEffDate}    ,
    ${Currency_List}    Split String    ${sCurrency}    ,
    ${BuyRate_List}    Split String    ${iBuyRate}    ,
    ${MidRate_List}    Split String    ${iMidRate}    ,
    ${LastRate_List}    Split String    ${iLastRate}    ,
    ${SellRate_List}    Split String    ${iSellRate}    ,
    ${SpreadRate_List}    Split String    ${iSpreadRate}    ,
    ${SpreadEffDate_List}    Split String    ${sSpreadEffDate}    ,
    ${LOB_list}    Split String    ${sLOB}    ,
    
    ${sLIQError}    Run Keyword If    '${sLIQError}'=='N'    Set Variable    N
    ...    ELSE IF    '${sLIQError}'=='Y'    Set Variable    Y
    ...    ELSE    '${sLIQError}'=='N'    Set Variable    N
    
    ${BaseRateCode_Count}    Get Length    ${BaseRateCode_List}
    :FOR    ${Index}    IN RANGE    ${BaseRateCode_Count}
    \    ${Val_LOB}    Get From List    ${LOB_list}    ${Index}
    \    ${LOB_List}    Split String    ${Val_LOB}    /
    \    ${Val_subEntity}    Get From List    ${SubEntity_List}    ${Index}
    \    ${SubEntity_List_LOB}    Split String    ${Val_subEntity}    /
    \    ${BaseRateCode}    Get From List    ${BaseRateCode_List}    ${Index}
    \    ${RateTenor}    Get From List    ${RateTenor_List}    ${Index}
    \    ${EffDate}    Get From List    ${EffDate_List}    ${Index}
    \    ${Currency}    Get From List    ${Currency_List}    ${Index}
    \    ${BuyRate}    Get From List    ${BuyRate_List}    ${Index}
    \    ${MidRate}    Get From List    ${MidRate_List}    ${Index}
    \    ${SellRate}    Get From List    ${SellRate_List}    ${Index}
    \    ${LastRate}    Get From List    ${LastRate_List}    ${Index}
    \    ${SpreadRate}    Get From List    ${SpreadRate_List}    ${Index}
    \    ${SpreadEffDate}    Get From List    ${SpreadEffDate_List}    ${Index}
    \    Validate LoanIQ for Single LOB Base Rate API    ${LOB_List}    ${SubEntity_List_LOB}    ${BaseRateCode}    ${RateTenor}    ${EffDate}    ${Currency}
         ...    ${BuyRate}    ${MidRate}    ${SellRate}    ${LastRate}    ${SpreadRate}    ${SpreadEffDate}    ${sLIQError}
    \    Exit For Loop If    ${Index}==${BaseRateCode_Count}
    
Validate LoanIQ for Single LOB Base Rate API
    [Documentation]    This keyword is used for get Line of Business value and if COMRLENDING, proceed with validation of LoanIQ.
    ...    @author: clanding
    ...    @update: clanding    25MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${aLineOfBusinessList}    ${aSubEntityList}    ${sBaseRateCode}    ${sRepricingFreq}    ${sEffDate}    ${sCurrency}
    ...    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}    ${iSpreadRate}    ${sSpreadEffDate}    ${sLIQError}
    
    ${LOB_Count}    Get Length    ${aLineOfBusinessList}
    
    :FOR    ${Index}    IN RANGE    ${LOB_Count}
    \    
    \    ${Val_LOB}    Get From List    ${aLineOfBusinessList}    ${Index}
    \    ${LOBS_Subentity_Dict}    Get Subentity value for individual lineOfBusiness    ${aLineOfBusinessList}    ${aSubEntityList}
    \    ${LOB_Exists}    Run Keyword And Return Status    Get From Dictionary    ${LOBS_Subentity_Dict}    COMRLENDING
    \    ${LOBS_subentity}    Run Keyword If    ${LOB_Exists}==${True}    Get From Dictionary    ${LOBS_Subentity_Dict}    COMRLENDING
         ...    ELSE    Log    COMRLENDING is not existing in the payload.
    \    Run Keyword If    '${Val_LOB}'=='COMRLENDING' and '${sLIQError}'=='N'    Validate LoanIQ for Base Rate API Success    ${Index}    ${LOBS_subentity}
         ...    ${sBaseRateCode}    ${sRepricingFreq}    ${sEffDate}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}
         ...    ${iLastRate}    ${iSpreadRate}    ${sSpreadEffDate}
         ...    ELSE IF    '${sLIQError}'=='Y'    Validate LoanIQ for Base Rate API Error    ${Index}    ${LOBS_subentity}
         ...    ${sBaseRateCode}    ${sRepricingFreq}    ${sEffDate}    ${sCurrency}    ${iBuyRate}    ${iMidRate}    ${iSellRate}
         ...    ${iLastRate}    ${iSpreadRate}    ${sSpreadEffDate}
         ...    ELSE    Log    COMRLENDING is not existing in the payload.
    \    
    \    Exit For Loop If    ${Index}==${LOB_Count}

Validate LoanIQ for Base Rate API Success
    [Documentation]    This keyword is used to validate Base Rate if reflected in LoanIQ (COMRLENDING) 
    ...    on Funding Rates screen in Table Maintenance and Treasusry Navigation.
    ...    @author: clanding
    ...    @update: clanding    25MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1 
    [Arguments]    ${iListIndex}    ${sSubEntity}    ${sBaseRateCode}    ${sRepricingFreq}    ${sEffDate}    ${sCurrency}
    ...    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}    ${iSpreadRate}    ${sSpreadEffDate}

    ${BaseRateCode_List}    Split String    ${sBaseRateCode}    ,
    ${BaseRateCode_count}    Get Length    ${BaseRateCode_List}
    
    ${BuyRate_List}    Split String    ${iBuyRate}    ,
    ${MidRate_List}    Split String    ${iMidRate}    ,
    ${SellRate_List}    Split String    ${iSellRate}    ,
    ${LastRate_List}    Split String    ${iLastRate}    ,
    ${Currency_List}    Split String    ${sCurrency}    ,
    ${RateEffDate_List}    Split String    ${sEffDate}    ,
    ${SpreadRate_List}    Split String    ${iSpreadRate}    ,
    ${SpreadEffDate_List}    Split String    ${sSpreadEffDate}    ,
    ${RateTenor_List}    Split String    ${sRepricingFreq}    ,
    
    ${BASERATECODEConfig}    OperatingSystem.Get File    ${BASERATECODE_Config}
    ${BASERATECODE_Dict}    Convert Base Rate Config to Dictionary
    
    ${iListIndex}    Set Variable    0
    :FOR    ${iListIndex}    IN RANGE    ${BaseRateCode_count}
    \    
    \    ${Val_BaseRateCode}    Get From List    ${BaseRateCode_List}    ${iListIndex}
    \    ${Val_Currency}    Get From List    ${Currency_List}    ${iListIndex}
    \    ${Val_RateEffDate}    Get From List    ${RateEffDate_List}    ${iListIndex}
    \    ${Val_SpreadRate}    Get From List    ${SpreadRate_List}    ${iListIndex}
    \    ${Val_SpreadEffDate}    Get From List    ${SpreadEffDate_List}    ${iListIndex}
    \    ${Val_RateTenor}    Get From List    ${RateTenor_List}    ${iListIndex}
    \    
    \    Log    Config check for Base Rate Code and Buy Rate
    \    ${Val_BuyRate}    Get From List    ${BuyRate_List}    ${iListIndex}
    \    ${BUYRATE}    Run Keyword If    '${Val_BuyRate}'=='0'    Set Variable    None
         ...    ELSE IF    '${Val_BuyRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_BuyRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_BuyRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    BUYRATE
    \    ${BaseConfig_Buy_Exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${BUYRATE}
    \    ${Val_BuyRate}    Run Keyword If    ${BaseConfig_Buy_Exist}==${True}    Evaluate    ${Val_BuyRate}*0.01    
    \    ${BaseCode_Buy}    Run Keyword If    ${BaseConfig_Buy_Exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${BUYRATE}
    \    Run Keyword If    ${BaseConfig_Buy_Exist}==${True}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Reflected    ${BaseCode_Buy}
         ...    ${Val_RateTenor}    ${Val_BuyRate}    ${sSubEntity}    ${Val_RateEffDate}    ${Val_Currency}
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Reflected    ${BaseCode_Buy}    ${Val_RateTenor}    ${Val_BuyRate}    ${sSubEntity}
         ...    ${Val_RateEffDate}    ${Val_Currency}    ${Val_SpreadRate}    ${Val_SpreadEffDate}
         ...    ELSE    Log    No configuration for '${Val_BaseRateCode}.${BUYRATE}'.
    \    
    \    Log    Config check for Base Rate Code and Mid Rate
    \    ${Val_MidRate}    Get From List    ${MidRate_List}    ${iListIndex}
    \    ${MIDRATE}    Run Keyword If    '${Val_MidRate}'=='0'    Set Variable    None
         ...    ELSE IF    '${Val_MidRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_MidRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_MidRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    MIDRATE
    \    ${BaseConfig_Mid_Exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${MIDRATE}
    \    ${Val_MidRate}    Run Keyword If    ${BaseConfig_Mid_Exist}==${True}    Evaluate    ${Val_MidRate}*0.01
    \    ${BaseCode_Mid}    Run Keyword If    ${BaseConfig_Mid_Exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${MIDRATE}
    \    Run Keyword If    ${BaseConfig_Mid_Exist}==${True}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Reflected    ${BaseCode_Mid}
         ...    ${Val_RateTenor}    ${Val_MidRate}    ${sSubEntity}    ${Val_RateEffDate}    ${Val_Currency}
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Reflected    ${BaseCode_Mid}    ${Val_RateTenor}    ${Val_MidRate}    ${sSubEntity}
         ...    ${Val_RateEffDate}    ${Val_Currency}    ${Val_SpreadRate}    ${Val_SpreadEffDate}
         ...    ELSE    Log    No configuration for '${Val_BaseRateCode}.${MIDRATE}'.
    \    
    \    Log    Config check for Base Rate Code and Sell Rate
    \    ${Val_SellRate}    Get From List    ${SellRate_List}    ${iListIndex}
    \    ${SELLRATE}    Run Keyword If    '${Val_SellRate}'=='0'    Set Variable    None
         ...    ELSE IF    '${Val_SellRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_SellRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_SellRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    SELLRATE
    \    ${BaseConfig_Sell_Exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${SELLRATE}
    \    ${Val_SellRate}    Run Keyword If    ${BaseConfig_Sell_Exist}==${True}    Evaluate    ${Val_SellRate}*0.01
    \    ${BaseCode_Sell}    Run Keyword If    ${BaseConfig_Sell_Exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${SELLRATE}
    \    Run Keyword If    ${BaseConfig_Sell_Exist}==${True}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Reflected    ${BaseCode_Sell}
         ...    ${Val_RateTenor}    ${Val_SellRate}    ${sSubEntity}    ${Val_RateEffDate}    ${Val_Currency}
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Reflected    ${BaseCode_Sell}    ${Val_RateTenor}    ${Val_SellRate}    ${sSubEntity}
         ...    ${Val_RateEffDate}    ${Val_Currency}    ${Val_SpreadRate}    ${Val_SpreadEffDate}
         ...    ELSE    Log    No configuration for '${Val_BaseRateCode}.${SELLRATE}'.
    \    
    \    Log    Config check for Base Rate Code and Last Rate
    \    ${Val_LastRate}    Get From List    ${LastRate_List}    ${iListIndex}
    \    ${LASTRATE}    Run Keyword If    '${Val_LastRate}'=='0'    Set Variable    None
         ...    ELSE IF    '${Val_LastRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_LastRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_LastRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    LASTRATE
    \    ${BaseConfig_Last_Exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${LASTRATE}
    \    ${Val_LastRate}    Run Keyword If    ${BaseConfig_Last_Exist}==${True}    Evaluate    ${Val_LastRate}*0.01
    \    ${BaseCode_Last}    Run Keyword If    ${BaseConfig_Last_Exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${LASTRATE}
    \    Run Keyword If    ${BaseConfig_Last_Exist}==${True}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Reflected    ${BaseCode_Last}
         ...    ${Val_RateTenor}    ${Val_LastRate}    ${sSubEntity}    ${Val_RateEffDate}    ${Val_Currency}
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Reflected    ${BaseCode_Last}    ${Val_RateTenor}    ${Val_LastRate}    ${sSubEntity}
         ...    ${Val_RateEffDate}    ${Val_Currency}    ${Val_SpreadRate}    ${Val_SpreadEffDate}
         ...    ELSE    Log    No configuration for '${Val_BaseRateCode}.${LASTRATE}'.
    \    
    \    Exit For Loop If    ${iListIndex}==${BaseRateCode_count}

Validate LoanIQ for Base Rate API Error
    [Documentation]    This keyword is used to validate Base Rate if NOT reflected in LoanIQ (COMRLENDING) 
    ...    on Funding Rates screen in Table Maintenance and Treasusry Navigation.
    ...    @author: clanding    04APR2019    - initial create
    [Arguments]    ${iListIndex}    ${sSubEntity}    ${sBaseRateCode}    ${sRepricingFreq}    ${sEffDate}    ${sCurrency}
    ...    ${iBuyRate}    ${iMidRate}    ${iSellRate}    ${iLastRate}    ${iSpreadRate}    ${sSpreadEffDate}

    ${BaseRateCode_List}    Split String    ${sBaseRateCode}    ,
    ${BaseRateCode_count}    Get Length    ${BaseRateCode_List}
    
    ${BuyRate_List}    Split String    ${iBuyRate}    ,
    ${MidRate_List}    Split String    ${iMidRate}    ,
    ${SellRate_List}    Split String    ${iSellRate}    ,
    ${LastRate_List}    Split String    ${iLastRate}    ,
    ${Currency_List}    Split String    ${sCurrency}    ,
    ${RateEffDate_List}    Split String    ${sEffDate}    ,
    ${SpreadRate_List}    Split String    ${iSpreadRate}    ,
    ${SpreadEffDate_List}    Split String    ${sSpreadEffDate}    ,
    ${RateTenor_List}    Split String    ${sRepricingFreq}    ,
    
    ${BASERATECODEConfig}    OperatingSystem.Get File    ${BASERATECODE_Config}
    ${BASERATECODE_Dict}    Convert Base Rate Config to Dictionary
    
    ${iListIndex}    Set Variable    0
    :FOR    ${iListIndex}    IN RANGE    ${BaseRateCode_count}
    \    
    \    ${Val_BaseRateCode}    Get From List    ${BaseRateCode_List}    ${iListIndex}
    \    ${Val_Currency}    Get From List    ${Currency_List}    ${iListIndex}
    \    ${Val_RateEffDate}    Get From List    ${RateEffDate_List}    ${iListIndex}
    \    ${Val_SpreadRate}    Get From List    ${SpreadRate_List}    ${iListIndex}
    \    ${Val_SpreadEffDate}    Get From List    ${SpreadEffDate_List}    ${iListIndex}
    \    ${Val_RateTenor}    Get From List    ${RateTenor_List}    ${iListIndex}
    \    
    \    Log    Config check for Base Rate Code and Buy Rate
    \    ${Val_BuyRate}    Get From List    ${BuyRate_List}    ${iListIndex}
    \    ${BUYRATE}    Run Keyword If    '${Val_BuyRate}'=='0'    Set Variable    None
         ...    ELSE IF    '${Val_BuyRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_BuyRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_BuyRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    BUYRATE
    \    ${BaseConfig_Buy_Exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${BUYRATE}
    \    ${Val_BuyRate}    Run Keyword If    ${BaseConfig_Buy_Exist}==${True}    Evaluate    ${Val_BuyRate}*0.01    
    \    ${BaseCode_Buy}    Run Keyword If    ${BaseConfig_Buy_Exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${BUYRATE}
    \    Run Keyword If    ${BaseConfig_Buy_Exist}==${True}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Buy}
         ...    ${Val_RateTenor}    ${Val_BuyRate}    ${sSubEntity}    ${Val_RateEffDate}    ${Val_Currency}
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Buy}    ${Val_RateTenor}    ${Val_BuyRate}    ${sSubEntity}
         ...    ${Val_RateEffDate}    ${Val_Currency}    ${Val_SpreadRate}    ${Val_SpreadEffDate}
         ...    ELSE    Log    No configuration for '${Val_BaseRateCode}.${BUYRATE}'.
    \    
    \    Log    Config check for Base Rate Code and Mid Rate
    \    ${Val_MidRate}    Get From List    ${MidRate_List}    ${iListIndex}
    \    ${MIDRATE}    Run Keyword If    '${Val_MidRate}'=='0'    Set Variable    None
         ...    ELSE IF    '${Val_MidRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_MidRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_MidRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    MIDRATE
    \    ${BaseConfig_Mid_Exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${MIDRATE}
    \    ${Val_MidRate}    Run Keyword If    ${BaseConfig_Mid_Exist}==${True}    Evaluate    ${Val_MidRate}*0.01
    \    ${BaseCode_Mid}    Run Keyword If    ${BaseConfig_Mid_Exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${MIDRATE}
    \    Run Keyword If    ${BaseConfig_Mid_Exist}==${True}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Mid}
         ...    ${Val_RateTenor}    ${Val_MidRate}    ${sSubEntity}    ${Val_RateEffDate}    ${Val_Currency}
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Mid}    ${Val_RateTenor}    ${Val_MidRate}    ${sSubEntity}
         ...    ${Val_RateEffDate}    ${Val_Currency}    ${Val_SpreadRate}    ${Val_SpreadEffDate}
         ...    ELSE    Log    No configuration for '${Val_BaseRateCode}.${MIDRATE}'.
    \    
    \    Log    Config check for Base Rate Code and Sell Rate
    \    ${Val_SellRate}    Get From List    ${SellRate_List}    ${iListIndex}
    \    ${SELLRATE}    Run Keyword If    '${Val_SellRate}'=='0'    Set Variable    None
         ...    ELSE IF    '${Val_SellRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_SellRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_SellRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    SELLRATE
    \    ${BaseConfig_Sell_Exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${SELLRATE}
    \    ${Val_SellRate}    Run Keyword If    ${BaseConfig_Sell_Exist}==${True}    Evaluate    ${Val_SellRate}*0.01
    \    ${BaseCode_Sell}    Run Keyword If    ${BaseConfig_Sell_Exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${SELLRATE}
    #\    Run Keyword If    ${BaseConfig_Sell_Exist}==${True}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Sell}
         # ...    ${Val_RateTenor}    ${Val_SellRate}    ${sSubEntity}    ${Val_RateEffDate}    ${Val_Currency}
         # ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation Not Reflected    ${BaseCode_Sell}    ${Val_RateTenor}    ${Val_SellRate}    ${sSubEntity}
         # ...    ${Val_RateEffDate}    ${Val_Currency}    ${Val_SpreadRate}    ${Val_SpreadEffDate}
         # ...    ELSE    Log    No configuration for '${Val_BaseRateCode}.${SELLRATE}'.
    \    
    \    Log    Config check for Base Rate Code and Last Rate
    \    ${Val_LastRate}    Get From List    ${LastRate_List}    ${iListIndex}
    \    ${LASTRATE}    Run Keyword If    '${Val_LastRate}'=='0'    Set Variable    None
         ...    ELSE IF    '${Val_LastRate}'=='no tag'    Set Variable    None
         ...    ELSE IF    '${Val_LastRate}'=='null'    Set Variable    None
         ...    ELSE IF    '${Val_LastRate}'==''    Set Variable    None
         ...    ELSE    Set Variable    LASTRATE
    \    ${BaseConfig_Last_Exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    ${Val_BaseRateCode}.${LASTRATE}
    \    ${Val_LastRate}    Run Keyword If    ${BaseConfig_Last_Exist}==${True}    Evaluate    ${Val_LastRate}*0.01
    \    ${BaseCode_Last}    Run Keyword If    ${BaseConfig_Last_Exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    ${Val_BaseRateCode}.${LASTRATE}
    #\    Run Keyword If    ${BaseConfig_Last_Exist}==${True}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance Not Reflected    ${BaseCode_Last}
         # ...    ${Val_RateTenor}    ${Val_LastRate}    ${sSubEntity}    ${Val_RateEffDate}    ${Val_Currency}
         # ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation Not Reflected    ${BaseCode_Last}    ${Val_RateTenor}    ${Val_LastRate}    ${sSubEntity}
         # ...    ${Val_RateEffDate}    ${Val_Currency}    ${Val_SpreadRate}    ${Val_SpreadEffDate}
         # ...    ELSE    Log    No configuration for '${Val_BaseRateCode}.${LASTRATE}'.
    \    
    \    Exit For Loop If    ${iListIndex}==${BaseRateCode_count}

Validate Base Rate Effective Date Empty
    [Documentation]    This keyword is used to get LIQ System Current Business Date and validate if Effective Date is empty.
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    
    ${LIQ_SYS_DATE}    Get System Date on LIQ and Return Value
    Run Keyword And Ignore Error    Validate Base Rate Effective Date with Conversion    ${LIQ_SYS_DATE}
    Log    ${LIQ_SYS_DATE}
    Set Global Variable    ${LIQ_SYS_DATE}

Validate Spread Effective Date Empty
    [Documentation]    This keyword is used to get LIQ System Current Business Date and validate if Spread Effective Date is empty.
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    
    ${LIQ_SYS_DATE}    Get System Date on LIQ and Return Value
    Run Keyword And Ignore Error    Validate Base Rate Effective Date with Conversion    ${LIQ_SYS_DATE}
    Log    ${LIQ_SYS_DATE}
    Set Global Variable    ${LIQ_SYS_DATE}

Validate Base Rate Effective Date with Conversion
    [Documentation]    This keyword is used convert given date to dd-mmm-yyy format (18-Jul-2018).
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sDate}
    
    ${Date_BaseEffective_With_0}         Run Keyword And Continue On Failure    Convert Date With Zero    ${sDate}
    ${Date_BaseEffective_Without_0}      Run Keyword And Continue On Failure    Convert Date Without Zero    ${sDate}
    ${Backdated_Day}                Run Keyword And Continue On Failure    BackDate Date by N day    ${sDate}    1
    ${Conv_Backdated_Day_With_0}    Run Keyword And Continue On Failure    Convert Date With Zero    ${Backdated_Day}
    ${Conv_Backdated_Day}           Run Keyword And Continue On Failure    Convert Date Without Zero    ${Backdated_Day}
    Set Global Variable    ${BASE_EFFECTIVE_DATE_WITH_0}    ${Date_BaseEffective_With_0}    
    Set Global Variable    ${BASE_EFFECTIVE_DATE_WITHOUT_0}    ${Date_BaseEffective_Without_0}
    Set Global Variable    ${CONV_BACKDATED_DATE_WITH_0}    ${Conv_Backdated_Day_With_0}    
    Set Global Variable    ${CONV_BACKDATED_DATE_WITHOUT_0}    ${Conv_Backdated_Day}

Validate Spread Effective Date with Conversion
    [Documentation]    This keyword is used convert given date to dd-mmm-yyy format (18-Jul-2018).
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sDate}
    ${Date_SpreadEffective_With_0}              Run Keyword And Continue On Failure    Convert Date With Zero    ${sDate}
    ${Date_SpreadEffective_Without_0}           Run Keyword And Continue On Failure    Convert Date Without Zero    ${sDate}
    ${Spread_Backdated_Day}                Run Keyword And Continue On Failure    BackDate Date by N day    ${sDate}    1
    ${Spread_Conv_Backdated_Day_With_0}    Run Keyword And Continue On Failure    Convert Date With Zero    ${Spread_Backdated_Day}
    ${Spread_Conv_Backdated_Day_Without_0}           Run Keyword And Continue On Failure    Convert Date Without Zero    ${Spread_Backdated_Day}
    Set Global Variable    ${SPREAD_EFFECTIVE_DATE_WITH_0}    ${Date_SpreadEffective_With_0}
    Set Global Variable    ${SPREAD_EFFECTIVE_DATE_WITHOUT_0}    ${Date_SpreadEffective_Without_0}
    Set Global Variable    ${CONV_BACKDATED_SPREAD_DATE_WITH_0}    ${Spread_Conv_Backdated_Day_With_0}    
    Set Global Variable    ${CONV_BACKDATED_SPREAD_DATE_WITHOUT_0}    ${Spread_Conv_Backdated_Day_Without_0}
    
Get Base Rate Repricing Frequency Label
    [Documentation]    This keyword is for creating a locator for repricing frequency
    ...    by splitting and setting a valid frequency label. 
    ...    e.g 1M = 1 Months, 1Y = 1 Years, 10M = 10 Months
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sBase_RepricingFrequency}
    ${REPRICING_LENGTH}      Get Length    ${sBase_RepricingFrequency}
    ${Frequency}    Get Substring    ${sBase_RepricingFrequency}    -1
    @{Num}    Split String    ${sBase_RepricingFrequency}    ${Frequency}
    ${FrequencyNum}=    Get From List    ${Num}    0
    ${Frequency}=    Convert To Uppercase    ${Frequency}
    ${Repricing_Frequency_Text}    Run Keyword If    '${Frequency}'=='M'    Set Variable    ${FrequencyNum}${SPACE}${Months}    
    ...    ELSE IF    '${Frequency}'=='Y'    Set Variable    ${FrequencyNum}${SPACE}${Years}
    ...    ELSE IF    '${Frequency}'=='D'    Set Variable    ${FrequencyNum}${SPACE}${Days}
    ...    ELSE    Log    Invalid Frequency entered. Valid Frequencies are Months, Years and Days
    Log    Repricing Frequency is ${Repricing_Frequency_Text}.        
    Set Global Variable    ${REPRICING_LENGTH}    
    [Return]    ${Repricing_Frequency_Text}

Split Base Rate Repricing Frequency and Set Locator
    [Documentation]    This keyword is for creating a locator for repricing frequency
    ...    by splitting and setting a valid frequency label. 
    ...    e.g 1M = 1 Months, 1Y = 1 Years, 10M = 10 Months
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sWindowName}    ${sBase_RepricingFreq}
    ${Frequency}    Get Substring    ${sBase_RepricingFreq}    -1
    @{Num}    Split String    ${sBase_RepricingFreq}    ${Frequency}
    ${FrequencyNum}=    Get From List    ${Num}    0
    ${Frequency}=    Convert To Uppercase    ${Frequency}
    ${REPRICING_FREQUENCY_LABEL}    Run Keyword If    '${Frequency}'=='M'   Set Variable    ${FrequencyNum}${SPACE}${Months}    
    ...    ELSE IF    '${Frequency}'=='Y'    Set Variable    ${FrequencyNum}${SPACE}${Years}
    ...    ELSE IF    '${Frequency}'=='D'    Set Variable    ${FrequencyNum}${SPACE}${Days}
    ...    ELSE    Log    Valid Frequencies are Months, Years and Days
    Log    Repricing Frequency is ${REPRICING_FREQUENCY_LABEL}.
    ${Locator_Static_Text}    Set Variable    JavaWindow("title:=${sWindowName}.*").JavaStaticText("attached text:=${FrequencyNum}.*${Frequency}.*")
    ${Locator_List_Text}      Set Variable    JavaWindow("title:=${sWindowName}.*").JavaList("value:=${FrequencyNum}.*${Frequency}.*")
    Set Global Variable    ${REPRICING_FREQUENCY_LABEL}
    [Return]    ${Locator_Static_Text}    ${Locator_List_Text}

#Compute Base Rate Perentage and Validate Spread Rate
    #[Arguments]    ${spreadrate}
    #${spreadrate%}    ${spread_rate}    Run Keyword And Continue On Failure    Compute Base Rate Percentage    ${spreadrate}
    #Run Keyword And Continue On Failure    Validate Spread Rate    JavaWindow("title:=Funding Rate Details.*").JavaEdit("value:=${spreadRate%}")    ${spreadRate%}
   

Set Global Variable Values For Base Rates
    [Documentation]    This keyword is used to Set the fields needed for Base Rates into global variable.
    ...    @author: cmartill
    [Arguments]    ${baseRate_Code}    ${baseRate_OptionName}    ${base_interest_rate}    ${base_rate_percentage}    ${base_description}
    ...    ${base_rate_effectiveDate}    ${base_repricing_frequency}    ${base_currency}
    ${baseRateCode_Global}                  Set Variable    ${baseRate_Code}
    ${baseRateOptionName_Global}            Set Variable    ${baseRate_OptionName}
    ${baseInterestRate_Global}              Set Variable    ${base_interest_rate}
    ${baseInterestRatePercentage_Global}    Set Variable    ${base_rate_percentage}
    ${baseDescription_Global}               Set Variable    ${base_description}
    ${baseEffectiveDate_Global}             Set Variable    ${base_rate_effectiveDate}
    ${baseRepricingFrequency_Global}        Set Variable    ${base_repricing_frequency}
    ${baseCurrency_Global}                  Set Variable    ${base_currency}
    
    Set Global Variable    ${baseRateCode_Global}
    Set Global Variable    ${baseRateOptionName_Global}        
    Set Global Variable    ${baseInterestRate_Global}
    Set Global Variable    ${baseInterestRatePercentage_Global}    
    Set Global Variable    ${baseDescription_Global}
    Set Global Variable    ${baseEffectiveDate_Global}
    Set Global Variable    ${baseRepricingFrequency_Global}
    Set Global Variable    ${baseCurrency_Global}   
