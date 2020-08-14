*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Base Rate Code in LoanIQ for TL Base Success
    [Documentation]    This keyword is used to convert Transformed Data into dictionary and validate in LoanIQ every record is successfully reflected.
    ...    @author: clanding    28FEB2019    - initial create
    [Arguments]    ${sTransformedData_FilePath}
    
    Open Excel    ${dataset_path}${sTransformedData_FilePath}
    ${Row_Count}    Get Row Count    Transformed_BaseRate
    Close Current Excel Document
    :FOR    ${Index}    IN RANGE    1    ${Row_Count}
    \    ${dTransformedData}    Create Dictionary Using Transformed Data and Return    ${dataset_path}${sTransformedData_FilePath}    ${Index}
    \    Log     Transformed data is ${dTransformedData}
    \    Run Keyword If    '&{dTransformedData}[subEntity]'!='null'    Validate Base Rate is Reflected in LIQ    ${dTransformedData}
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='null'    Log    All subentities have future dates!!! Please change Effective Date to less than or equal to LIQ Business Date.    level=WARN
    
    
Validate Base Rate Code in LoanIQ for TL Base Success for Future Date
    [Documentation]    This keyword is used to convert Transformed Data into dictionary and validate in LoanIQ every record including the future date.
    ...    @author: clanding    11MAR2019    - initial create
    [Arguments]    ${sTransformedData_FilePath}
    
    Open Excel    ${dataset_path}${sTransformedData_FilePath}    
    ${Row_Count}    Get Row Count    Transformed_BaseRate
    :FOR    ${Index}    IN RANGE    1    ${Row_Count}
    \    ${dTransformedData}    Create Dictionary Using Transformed Data and Return    ${dataset_path}${sTransformedData_FilePath}    ${Index}
    \    
    \    Run Keyword If    '&{dTransformedData}[subEntity]'=='AUD,NY'    Validate Base Rate is Reflected in LIQ    ${dTransformedData}
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='AUD'    Run Keywords    Validate Base Rate is Reflected in LIQ    ${dTransformedData}
         ...    AND    Validate Base Rate Code is Not Reflected in LIQ    ${dTransformedData}    NY
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='NY'    Run Keywords    Validate Base Rate is Reflected in LIQ    ${dTransformedData}
         ...    AND    Validate Base Rate Code is Not Reflected in LIQ    ${dTransformedData}    AUD
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='null'    Validate Base Rate Code is Not Reflected in LIQ    ${dTransformedData}    AUD,NY
    Close Current Excel Document
    
Validate Base Rate Code in LoanIQ for TL Base Failed
    [Documentation]    This keyword is used to convert Transformed Data into dictionary and validate in LoanIQ every record is NOT reflected.
    ...    @author: clanding    12MAR2019    - initial create
    ...    @author: jloretiz    16JAN2020    - transferred the closing of excel.
    [Arguments]    ${sTransformedData_FilePath}
    
    Open Excel    ${dataset_path}${sTransformedData_FilePath}    
    ${Row_Count}    Get Row Count    Transformed_BaseRate
    Close Current Excel Document
    :FOR    ${Index}    IN RANGE    1    ${Row_Count}
    \    ${dTransformedData}    Create Dictionary Using Transformed Data and Return    ${dataset_path}${sTransformedData_FilePath}    ${Index}
    \    
    \    Run Keyword If    '&{dTransformedData}[subEntity]'!='null'    Validate Base Rate Code is Not Reflected in LIQ    ${dTransformedData}    &{dTransformedData}[subEntity]
         ...    ELSE IF    '&{dTransformedData}[subEntity]'=='null'    Log    All subentities have future dates!!! Please change Effective Date to less than or equal to LIQ Business Date.    level=WARN
    
Validate Base Rate is Reflected in LIQ
    [Documentation]    This keyword is used to validate Base Rate if reflected in LoanIQ (COMRLENDING) for every Subentity value
    ...    @author: clanding    28FEB2019    - initial create
    ...    @update: clanding    18MAR2019    - added checking for ${FundingDeskStat}
    ...    @update: bernchua    01APR2019    - Renamed funding desk status variable
    [Arguments]    ${dRowData}    ${Delimiter}=None
    
    ${SubentityList}    Run Keyword If    ${Delimiter}==${NONE}    Split String    &{dRowData}[subEntity]    ,
    ...    ELSE    Split String    &{dRowData}[subEntity]    ${Delimiter}
    ${SubentityCount}    Get Length    ${SubentityList}
    
    ${BASERATECODEConfig}    OperatingSystem.Get File    ${BASERATECODE_Config}
    ${BASERATECODE_Dict}    Convert Base Rate Config to Dictionary
    
    ${Val_RateTenor}    Strip String    &{dRowData}[rateTenor]    both    0
    ${Val_RateEffDate}    Set Variable    &{dRowData}[rateEffectiveDate]
    
    :FOR    ${Index}    IN RANGE    0    ${SubentityCount}
    \    
    \    ${sSubEntity}    Get From List    ${SubentityList}    ${Index}
    \    ${Funding_Desk_Status}    Get Funding Desk Status from Table Maintenance    ${sSubEntity}
    \    
    \    ${Stat_BuyRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[buyRate]    null
    \    ${Count}    Get Length    &{dRowData}[buyRate]
    \    ${RoundOff_Rate_with_0}    ${Val_Buyrate}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    &{dRowData}[buyRate]    6
         ...    ELSE    Set Variable    &{dRowData}[buyRate]    &{dRowData}[buyRate]
    \    ${Val_Buyrate}    Run Keyword If    ${Stat_BuyRate}==${True}    Set Variable    ${NONE}
         ...    ELSE    Evaluate    ${Val_Buyrate}*0.01
    \    ${BUYRATE}    Run Keyword If    ${Val_Buyrate}==${NONE}    Set Variable    ${NONE}
         ...    ELSE    Set Variable    BUYRATE
    \    ${BaseConfig_Buy_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${BUYRATE}
    \    ${BaseCode_Buy}    Run Keyword If    ${BaseConfig_Buy_exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${BUYRATE}
    \    Run Keyword If    ${BaseConfig_Buy_exist}==True and '${Val_Buyrate}'!='None' and '${Funding_Desk_Status}'=='A'    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Reflected    ${BaseCode_Buy}    ${Val_RateTenor}    
         ...    ${Val_Buyrate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]    
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Reflected    ${BaseCode_Buy}    ${Val_RateTenor}    ${Val_Buyrate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    &{dRowData}[currency]
         ...    ELSE IF    ${BaseConfig_Buy_exist}==True and '${Val_Buyrate}'!='None' and '${Funding_Desk_Status}'=='I'    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Buy}    ${Val_RateTenor}    
         ...    ${Val_Buyrate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]    
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Buy}    ${Val_RateTenor}    ${Val_Buyrate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    &{dRowData}[currency]
         ...    ELSE    Log    No configuration for '${BaseCode_Buy}.${BUYRATE}'.
    \    
    \    ${Stat_MidRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[midRate]    null
    \    ${Count}    Get Length    &{dRowData}[midRate]
    \    ${RoundOff_Rate_with_0}    ${Val_MidRate}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    &{dRowData}[midRate]    6
         ...    ELSE    Set Variable    &{dRowData}[midRate]    &{dRowData}[midRate]
    \    ${Val_MidRate}    Run Keyword If    ${Stat_MidRate}==${True}    Set Variable    ${NONE}
         ...    ELSE    Evaluate    ${Val_MidRate}*0.01
    \    ${MIDRATE}    Run Keyword If    ${Val_MidRate}==${NONE}    Set Variable    ${NONE}
         ...    ELSE    Set Variable    MIDRATE
    \    ${BaseConfig_Mid_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${MIDRATE}
    \    ${BaseCode_Mid}    Run Keyword If    ${BaseConfig_Mid_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${MIDRATE}
    \    Run Keyword If    ${BaseConfig_Mid_exist}==${True} and '${Val_MidRate}'!='None' and '${Funding_Desk_Status}'=='A'    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Reflected    ${BaseCode_Mid}    ${Val_RateTenor}    
         ...    ${Val_MidRate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Reflected    ${BaseCode_Mid}    ${Val_RateTenor}    ${Val_MidRate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    &{dRowData}[currency]
         ...    ELSE IF    ${BaseConfig_Mid_exist}==True and '${Val_MidRate}'!='None' and '${Funding_Desk_Status}'=='I'    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Mid}    ${Val_RateTenor}    
         ...    ${Val_MidRate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Mid}    ${Val_RateTenor}    ${Val_MidRate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    &{dRowData}[currency]
         ...    ELSE    Log    No configuration for '${BaseCode_Mid}.${MIDRATE}'.
    \    
    \    ${Stat_SellRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[sellRate]    null
    \    ${Count}    Get Length    &{dRowData}[sellRate]
    \    ${RoundOff_Rate_with_0}    ${Val_SellRate}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    &{dRowData}[sellRate]    6
         ...    ELSE    Set Variable    &{dRowData}[sellRate]    &{dRowData}[sellRate]
    \    ${Val_SellRate}    Run Keyword If    ${Stat_SellRate}==${True}    Set Variable    ${NONE}
         ...    ELSE    Evaluate    ${Val_SellRate}*0.01
    \    ${SELLRATE}    Run Keyword If    ${Val_SellRate}==${NONE}    Set Variable    ${NONE}
         ...    ELSE    Set Variable    SELLRATE
    \    ${BaseConfig_Sell_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${SELLRATE}
    \    ${BaseCode_Sell}    Run Keyword If    ${BaseConfig_Sell_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${SELLRATE}
    \    Run Keyword If    ${BaseConfig_Sell_exist}==True and '${val_Sellrate}'!='None' and '${Funding_Desk_Status}'=='A'    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Reflected    ${BaseCode_Sell}    ${Val_RateTenor}    
         ...    ${Val_SellRate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Reflected    ${BaseCode_Sell}    ${Val_RateTenor}    ${Val_SellRate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    &{dRowData}[currency]
         ...    ELSE IF    ${BaseConfig_Sell_exist}==True and '${val_Sellrate}'!='None' and '${Funding_Desk_Status}'=='I'    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Sell}    ${Val_RateTenor}    
         ...    ${Val_SellRate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Sell}    ${Val_RateTenor}    ${Val_SellRate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    &{dRowData}[currency]
         ...    ELSE    Log    No configuration for '${BaseCode_Sell}.${SELLRATE}'.
    \    
    \    ${Stat_LastRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[lastRate]    null
    \    ${Count}    Get Length    &{dRowData}[lastRate]
    \    ${RoundOff_Rate_with_0}    ${Val_LastRate}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    &{dRowData}[lastRate]    6
         ...    ELSE    Set Variable    &{dRowData}[lastRate]    &{dRowData}[lastRate]
    \    ${Val_LastRate}    Run Keyword If    ${Stat_LastRate}==${True}    Set Variable    ${NONE}
         ...    ELSE    Evaluate    ${Val_LastRate}*0.01
    \    ${LASTRATE}    Run Keyword If    ${Val_LastRate}==${NONE}    Set Variable    ${NONE}
         ...    ELSE    Set Variable    LASTRATE
    \    ${BaseConfig_Last_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${LASTRATE}
    \    ${BaseCode_Last}    Run Keyword If    ${BaseConfig_Last_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${LASTRATE}
    \    Run Keyword If    ${BaseConfig_Last_exist}==True and '${BaseCode_Last}'!='None' and '${Funding_Desk_Status}'=='A'    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Reflected    ${BaseCode_Last}    ${Val_RateTenor}    
         ...    ${Val_LastRate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Reflected    ${BaseCode_Last}    ${Val_RateTenor}    ${Val_LastRate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    &{dRowData}[currency]
         ...    ELSE IF    ${BaseConfig_Last_exist}==True and '${BaseCode_Last}'!='None' and '${Funding_Desk_Status}'=='I'    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Last}    ${Val_RateTenor}    
         ...    ${Val_LastRate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Last}    ${Val_RateTenor}    ${Val_LastRate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    &{dRowData}[currency]
         ...    ELSE    Log    No configuration for '${BaseCode_Last}.${LASTRATE}'.
    \    
    \    Exit For Loop If    ${Index}==${SubentityCount}

Validate Base Rate Code is Not Reflected in LIQ
    [Documentation]    This keyword is used to validate Base Rate if NOT reflected in LoanIQ (COMRLENDING) for every Subentity value since Effective Date is in future.
    ...    @author: clanding    07MAR2019    - initial create
    ...    @update: clanding    02APR2019    - added Run Keyword And Continue On Failure on validation points
    [Arguments]    ${dRowData}    ${sSubentityVal}    ${Delimiter}=None
    
    ${SubentityList}    Run Keyword If    '${Delimiter}'=='None'    Split String    ${sSubentityVal}    ,
    ...    ELSE    Split String    ${sSubentityVal}    ${Delimiter}
    ${SubentityCount}    Get Length    ${SubentityList}
    
    ${BASERATECODEConfig}    OperatingSystem.Get File    ${BASERATECODE_Config}
    ${BASERATECODE_Dict}    Convert Base Rate Config to Dictionary
    
    ${Val_RateTenor}    Strip String    &{dRowData}[rateTenor]    both    0
    ${Val_RateEffDate}    Set Variable    &{dRowData}[rateEffectiveDate]
    
    :FOR    ${Index}    IN RANGE    0    ${SubentityCount}
    \    
    \    ${sSubEntity}    Get From List    ${SubentityList}    ${Index}
    \    
    \    ${Stat_BuyRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[buyRate]    null
    \    ${Count}    Get Length    &{dRowData}[buyRate]
    \    ${RoundOff_Rate_with_0}    ${Val_Buyrate}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    &{dRowData}[buyRate]    6
         ...    ELSE    Set Variable    &{dRowData}[buyRate]    &{dRowData}[buyRate]
    \    ${Val_Buyrate}    Run Keyword If    ${Stat_BuyRate}==${True}    Set Variable    ${NONE}
         ...    ELSE    Evaluate    ${Val_Buyrate}*0.01
    \    ${BUYRATE}    Run Keyword If    ${Val_Buyrate}!=0 or ${Val_Buyrate}!=${NONE}    Set Variable    BUYRATE
    \    ${BaseConfig_Buy_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${BUYRATE}
    \    ${BaseCode_Buy}    Run Keyword If    ${BaseConfig_Buy_exist}==${True}    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${BUYRATE}
    \    Run Keyword If    ${BaseConfig_Buy_exist}==True and ${Val_Buyrate}!=${NONE}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Buy}    ${Val_RateTenor}    
         ...    ${Val_Buyrate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Buy}    ${Val_RateTenor}    ${Val_Buyrate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    
         ...    &{dRowData}[currency]
         ...    ELSE    Log    No configuration for '${BaseCode_Buy}.${BUYRATE}'.
    \         
    \    ${Stat_MidRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[midRate]    null
    \    ${Count}    Get Length    &{dRowData}[midRate]
    \    ${RoundOff_Rate_with_0}    ${Val_MidRate}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    &{dRowData}[midRate]    6
         ...    ELSE    Set Variable    &{dRowData}[midRate]    &{dRowData}[midRate]
    \    ${Val_MidRate}    Run Keyword If    ${Stat_MidRate}==${True}    Set Variable    ${NONE}
         ...    ELSE    Evaluate    ${Val_MidRate}*0.01
    \    ${MIDRATE}    Run Keyword If    ${Val_MidRate}!=0 or ${Val_MidRate}!=${NONE}    Set Variable    MIDRATE
    \    ${BaseConfig_Mid_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${MIDRATE}
    \    ${BaseCode_Mid}    Run Keyword If    ${BaseConfig_Mid_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${MIDRATE}
    \    Run Keyword If    ${BaseConfig_Mid_exist}==True and ${Val_MidRate}!=${NONE}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Mid}    ${Val_RateTenor}    
         ...    ${Val_MidRate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Mid}    ${Val_RateTenor}    ${Val_MidRate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    
         ...    &{dRowData}[currency]
         ...    ELSE    Log    No configuration for '${BaseCode_Mid}.${MIDRATE}'.
    \    
    \    ${Stat_SellRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[sellRate]    null
    \    ${RoundOff_Rate_with_0}    ${Val_SellRate}    Run Keyword If    ${Count}>8    Round Off on the Nth Decimal Place    &{dRowData}[sellRate]    6
         ...    ELSE    Set Variable    &{dRowData}[sellRate]    &{dRowData}[sellRate]
    \    ${Val_SellRate}    Run Keyword If    ${Stat_SellRate}==${True}    Set Variable    ${NONE}
         ...    ELSE    Evaluate    ${Val_SellRate}*0.01
    \    ${SELLRATE}    Run Keyword If    ${Val_SellRate}!=0 or ${Val_SellRate}!=${NONE}    Set Variable    SELLRATE
    \    ${BaseConfig_Sell_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${SELLRATE}
    \    ${BaseCode_Sell}    Run Keyword If    ${BaseConfig_Sell_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${SELLRATE}
    \    Run Keyword If    ${BaseConfig_Sell_exist}==True and ${val_Sellrate}!=${NONE}    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Sell}    ${Val_RateTenor}    
         ...    ${Val_SellRate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Sell}    ${Val_RateTenor}    ${Val_SellRate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    
         ...    &{dRowData}[currency]
         ...    ELSE    Log    No configuration for '${BaseCode_Sell}.${SELLRATE}'.
    \    
    \    ${Stat_LastRate}    Run Keyword And Return Status    Should Be Equal    &{dRowData}[lastRate]    null
    \    ${Val_LastRate}    Run Keyword If    ${Stat_LastRate}==${True}    Set Variable    ${NONE}
         ...    ELSE    Evaluate    &{dRowData}[lastRate]*0.01
    \    ${LASTRATE}    Run Keyword If    ${Val_LastRate}!=0 or ${Val_LastRate}!=${NONE}    Set Variable    LASTRATE
    \    ${BaseConfig_Last_exist}    Run Keyword And Return Status    Should Contain    ${BASERATECODEConfig}    &{dRowData}[baseRateCode].${LASTRATE}
    \    ${BaseCode_Last}    Run Keyword If    ${BaseConfig_Last_exist}==True    Get From Dictionary    ${BASERATECODE_Dict}    &{dRowData}[baseRateCode].${LASTRATE}
    \    Run Keyword If    ${BaseConfig_Last_exist}==True    Run Keywords    Run Keyword And Continue On Failure    Validate Funding Rates in Table Maintenance is Not Reflected    ${BaseCode_Last}    ${Val_RateTenor}    
         ...    ${Val_LastRate}    ${sSubEntity}    ${Val_RateEffDate}    &{dRowData}[currency]
         ...    AND    Run Keyword And Continue On Failure    Validate Funding Rates in Treasury Navigation is Not Reflected    ${BaseCode_Last}    ${Val_RateTenor}    ${Val_LastRate}    ${sSubEntity}    &{dRowData}[rateEffectiveDate]    
         ...    &{dRowData}[currency]
         ...    ELSE    Log    No configuration for '${BaseCode_Last}.${LASTRATE}'.
    \    
    \    Exit For Loop If    ${Index}==${SubentityCount}
    
Validate Funding Rates in Table Maintenance is Reflected
    [Documentation]    This keyword is used to validate liq scenarios in Table Maintenance > Funding Rates for Base Rates (Create, Update & Delete).
    ...    @author: clanding    28FEB2019    - initial create, clone from Validation Loan IQ Base Rates in Table Maintenance
    ...    @update: clanding    19MAR2019    - update when ${sRepricingFreq} is empty
    ...    @update: clanding    25MAR2019    - updated '${sRepricingFreq}'=='UNKN'
    ...    @update: jdelacru    14FEB2020    - removed additional number arguments for select string
    [Arguments]    ${sBaseRateCode}    ${sRepricingFreq}    ${iRate}    ${sFundingDesk}    ${sEffDate}    ${sCurrency}
    
    ${NewRatePercent_5Dec}    ${NewRate}    Compute Rate Percentage to N Decimal Values and Return    ${iRate}    5
    ${NewRatePercent_6Dec}    ${NewRate}    Compute Rate Percentage to N Decimal Values and Return    ${iRate}    6
    
    ${sRepricingFreq}    Run Keyword If    '${sRepricingFreq}'==''    Set Variable    None
    ...    ELSE    Set Variable    ${sRepricingFreq}
    
    ${RepricingFreq_Text}    Run Keyword If    '${sRepricingFreq}'!='None'    Get Base Rate Repricing Frequency Label    ${sRepricingFreq}
    ${RepricingFreq_Text}    Run Keyword If    '${sRepricingFreq}'!='None'    Strip String    ${RepricingFreq_Text}    both    0
    
    mx LoanIQ activate window    ${LIQ_Window}    
    mx LoanIQ select    ${LIQ_Options_RefreshAllCodeTables}
    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    
    ###OPTION NAME AND BASE RATE ASSOCIATION###
    ${OptionNameDesc}    ${OptionName}    Get Option Name from Option Name and Base Rate Association    ${sBaseRateCode.upper()}
    ${BaseRateFrequencyStat}    Get Base Rate Frequency Status from Table Maintenance    ${sRepricingFreq.upper()}
    ${RepricingFreq_Text}    Run Keyword If    ${BaseRateFrequencyStat}==${False}    Set Variable    ${EMPTY}
    ...    ELSE    Set Variable    ${RepricingFreq_Text}

    ###FUNDING DESK###
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    ${BaseRate_Desc}    ${BaseRate_Status}    Get Base Rate Description from Table Maintenance    ${sBaseRateCode.upper()}
    ${FundingDeskStat}    Get Funding Desk Status from Table Maintenance    ${sFundingDesk}
    ${FundingDesk_Desc}    ${FundingDesk_Currency}    Run Keyword If    '${sFundingDesk}'!='None'    Run Keyword And Continue On Failure    
    ...    Get Funding Desk Details from Table Maintenance    ${sFundingDesk}    ${FundingDeskStat}
    ...    ELSE    Run Keyword And Ignore Error     Log    Cluster is null/empty.    level=WARN
    ${Currency_Desc}    Get Currency Description from Table Maintenance    ${sCurrency}
    Search in Table Maintenance    Funding Rates
    
    ###VALIDATION IF DATES ARE EMPTY###
    ${EffDate_With_0}	Run Keyword If    '${sEffDate}'!='${NONE}'    Convert Date    ${sEffDate}    result_format=%d-%b-%Y
    ...    ELSE    Log    Effective Date value is invalid: ${sEffDate}.    level=ERROR
    
    ${EffDate_Without_0}	Run Keyword If    '${sEffDate}'!='${NONE}'    Convert Date    ${sEffDate}    result_format=%#d-%b-%Y
    ...    ELSE    Log    Effective Date value is invalid: ${sEffDate}.    level=ERROR
    
    ###SETTING THE VALUES FOR GLOBAL###
    Set Global Variable Values For Base Rates    ${sBaseRateCode.upper()}    ${OptionNameDesc}    ${iRate}    ${NewRatePercent_6Dec}    ${BaseRate_Desc}    ${EffDate_With_0}    
    ...    ${RepricingFreq_Text}    ${sCurrency}
    
    Log    Row: ${sBaseRateCode.upper()} - ${sFundingDesk} - ${sRepricingFreq} - ${sCurrency} - ${iRate} - ${EffDate_With_0}. 
    
    ###TABLE MAINTENANCE > BROWSE FUNDING RATES WINDOW - CLICKING A ROW###
    ###WITH CLUSTER and REPRICING FREQUENCY###
    ${hasCluster_with_repfreq}         Run Keyword If    '${sFundingDesk}'!='None' and '${sFundingDesk}'!='I' and '${sRepricingFreq}'!='None'    Run Keyword And Return Status     
    ...    Mx LoanIQ Select String    ${LIQ_BrowseFundingRates_Tree}    
    ...    ${sBaseRateCode.upper()}\t${sFundingDesk}\t${sRepricingFreq}\t${sCurrency}\t${EffDate_With_0}\t${NewRate}
    Run Keyword If    '${hasCluster_with_repfreq}'=='True'   Wait Until Keyword Succeeds    3    3s     Mx LoanIQ DoubleClick    ${LIQ_BrowseFundingRates_Tree}    
    ...    ${sBaseRateCode.upper()}\t${sFundingDesk}\t${sRepricingFreq}\t${sCurrency}\t${EffDate_With_0}\t${NewRate}
    ...    ELSE IF    '${hasCluster_with_repfreq}'=='False'    Log    
    ...    ${sBaseRateCode.upper()} - ${sFundingDesk} - ${sRepricingFreq} - ${sCurrency} - ${EffDate_Without_0} - ${NewRate} does not exists in the table.
    ...    ELSE    Log    Keyword not applicable
    Run Keyword If    ${hasCluster_with_repfreq}==True    Take Screenshot    TableMaintenance_FundingDesk
        
    ###WITHOUT CLUSTER and WITH REPRICING FREQUENCY###
    ${hasNoCluster_with_repfreq}    Run Keyword If    '${sFundingDesk}'=='None' and '${sRepricingFreq}'!='None'    Run Keyword And Return Status     Mx LoanIQ Select String    
    ...    ${LIQ_BrowseFundingRates_Tree}    ${sBaseRateCode.upper()}\t\t${sRepricingFreq}\t${sCurrency}\t${EffDate_With_0}\t${NewRate}
    Run Keyword If    '${hasNoCluster_with_repfreq}'=='True'    Wait Until Keyword Succeeds    3    3s    Mx LoanIQ DoubleClick    ${LIQ_BrowseFundingRates_Tree}    
    ...    ${sBaseRateCode.upper()}\t\t${sRepricingFreq}\t${sCurrency}\t${EffDate_With_0}\t${NewRate}
    ...    ELSE IF    '${hasNoCluster_with_repfreq}'=='False'    Log    
    ...    ${sBaseRateCode.upper()} - - ${sRepricingFreq} - ${sCurrency} - ${EffDate_Without_0} - ${NewRate} does not exists in the table.
    ...    ELSE    Log    Keyword not applicable
    Run Keyword If    ${hasNoCluster_with_repfreq}==True    Take Screenshot    TableMaintenance_FundingDesk
    
    ###WITH CLUSTER and WITHOUT REPRICING FREQUENCY###
    ${hasCluster_without_repfreq}      Run Keyword If    '${sFundingDesk}'!='None' and '${sRepricingFreq}'=='None'    Run Keyword And Return Status     Mx LoanIQ Select String    
    ...    ${LIQ_BrowseFundingRates_Tree}    ${sBaseRateCode.upper()}\t${sFundingDesk}\t\t${sCurrency}\t${EffDate_With_0}\t${NewRate}
    Run Keyword If    '${hasCluster_without_repfreq}'=='True'    Wait Until Keyword Succeeds    3    3s    Mx LoanIQ DoubleClick    ${LIQ_BrowseFundingRates_Tree}    
    ...    ${sBaseRateCode.upper()}\t${sFundingDesk}\t\t${sCurrency}\t${EffDate_With_0}\t${NewRate}
    ...    ELSE IF    '${hasCluster_without_repfreq}'=='False'    Log    
    ...    ${sBaseRateCode.upper()} - ${sFundingDesk} - - ${sCurrency} - ${EffDate_Without_0} - ${NewRate} does not exists in the table.
    ...    ELSE    Log    Keyword not applicable
    Run Keyword If    ${hasCluster_without_repfreq}==True    Take Screenshot    TableMaintenance_FundingDesk
    
    ###WITHOUT CLUSTER and WITHOUT REPRICING FREQUENCY###
    ${hasNoCluster_without_repfreq}    Run Keyword If    '${sFundingDesk}'=='None'    Run Keyword And Return Status     Mx LoanIQ Select String    
    ...    ${LIQ_BrowseFundingRates_Tree}    ${sBaseRateCode.upper()}\t\t\t${sCurrency}\t${EffDate_With_0}\t${NewRate}
    ...    ELSE IF    '${sFundingDesk}'=='None' and '${sRepricingFreq}'==''    Run Keyword And Return Status     Mx LoanIQ Select String    
    ...    ${LIQ_BrowseFundingRates_Tree}    ${sBaseRateCode.upper()}\t\t\t${sCurrency}\t${EffDate_With_0}\t${NewRate}
    Run Keyword If    '${hasNoCluster_without_repfreq}'=='True'    Wait Until Keyword Succeeds    3    3s    Mx LoanIQ DoubleClick    ${LIQ_BrowseFundingRates_Tree}    
    ...    ${sBaseRateCode.upper()}\t\t\t${sCurrency}\t${EffDate_With_0}\t${NewRate}
    ...    ELSE IF    '${hasNoCluster_without_repfreq}'=='False'    Log    
    ...    ${sBaseRateCode.upper()} - - - ${sCurrency}\t${EffDate_Without_0}\t${NewRate} does not exists in the table.
    ...    ELSE    Log    Keyword not applicable
    Take Screenshot    TableMaintenance_FundingDesk
   
    Run Keyword If    '${hasCluster_with_repfreq}'=='False' and '${hasCluster_with_repfreq}'!='None'    Log    Base Rate Code of ${sBaseRateCode.upper()} with Repricing Frequency of ${sRepricingFreq} and Funding Desk of ${sFundingDesk} with Effective Date ${EffDate_Without_0} does not exists in the table.    level=ERROR
    ...    ELSE IF    '${hasNoCluster_with_repfreq}'=='False' and '${hasNoCluster_with_repfreq}'!='None'    Log    Base Rate Code of ${sBaseRateCode.upper()} with Repricing Frequency of ${sRepricingFreq} with Effective Date ${EffDate_Without_0} and without Cluster does not exists in the table.    level=ERROR
    ...    ELSE IF    '${hasCluster_without_repfreq}'=='False' and '${hasCluster_without_repfreq}'!='None'    Log    Base Rate Code of ${sBaseRateCode.upper()} with Funding desk ${sFundingDesk} with Effective Date ${EffDate_Without_0} and No Repricing Frequency does not exists in the table.    level=ERROR
    ...    ELSE IF    '${hasNoCluster_without_repfreq}'=='False' and '${hasNoCluster_without_repfreq}'!='None'    Log    Base Rate Code of ${sBaseRateCode.upper()} without Repricing Frequency and Funding Desk does with Effective Date ${EffDate_Without_0} not exists in the table.    level=ERROR
    
    ###SETTING AND VALIDATION FOR LOCATORS###
    ${LIQ_FundingRatesUpdate_FundingDesk_List}    Run Keyword If    '${sFundingDesk}'!='None'    Set List Text with 2 words to Locator    Funding Rates Update    ${FundingDesk_Desc}
    ...    ELSE    Log To Console    Cluster or Funding Desk is Empty. 
    
    ${LIQ_FundingRatesUpdate_Repricing_Freq_StaticText}    ${LIQ_FundingRatesUpdate_Repricing_Freq_List}    Run Keyword If    '${sRepricingFreq}'!='None' and '${BaseRateFrequencyStat}'=='${True}'     Split Base Rate Repricing Frequency and Set Locator    Funding Rates Update    ${sRepricingFreq}    
    ...    ELSE IF    '${BaseRateFrequencyStat}'=='${False}'    Set Variable    None    JavaWindow("title:=Funding Rates Update").JavaList("value:=")

    ${LIQ_FundingRatesUpdate_Repricing_Freq_StaticText_UNKN}    Run Keyword If    '${sRepricingFreq}'=='UNKN'    Set Variable    JavaWindow("title:=Funding Rates Details.*").JavaStaticText("label:=Unknown.*","attached text:=Unknown.*")    
    ${LIQ_FundingRatesUpdate_StaticList}    Set Variable    ${LIQ_FundingRatesUpdate_StaticList}
    Run Keyword If    '${sRepricingFreq}'=='None'    Log    Repricing Frequency is empty. No setting of locator.
    
    ${status_space}    Run Keyword And Return Status    Should Contain    ${Currency_Desc}    ${SPACE}
    ${LIQ_FundingRatesUpdate_Currency_List}    Run Keyword If    '${status_space}'=='True'    Run Keyword And Continue On Failure    Set List Text with 2 words to Locator    Funding Rates Update    ${Currency_Desc}
    Run Keyword If    '${status_space}'=='False'    Log    Currency Description is one word.    
    
    ${LIQ_FundingRatesUpdate_Rate_Edit}              Set Edit Text to Locator Single Text     Funding Rates Update    ${NewRatePercent_5Dec}
    ${LIQ_FundingRatesUpdate_EffectiveDate_Text}     Set Static Text to Locator Single Text   Funding Rates Update    ${EffDate_With_0}    
    
    Log    RepFreq locator: ${LIQ_FundingRatesUpdate_Repricing_Freq_List}.
    Log    RepFreq Description: ${RepricingFreq_Text}.
    
    ###TABLE MAINTENANCE VALIDATION > FUNDING RATES WINDOW > FUNDING RATES UPDATES WINDOW###
    Run Keyword And Continue On Failure    Validate if Element is Checked    ${LIQ_FundingRatesUpdate_Active_Checkbox}    Active
    Run Keyword And Continue On Failure    Validate Rate Code in Funding Rates Updates    JavaWindow("title:=Funding Rates Update.*").JavaList("text:=${BaseRate_Desc}.*")    ${BaseRate_Desc}
    Run Keyword If    '${sFundingDesk}'!='None'    Run Keyword And Continue On Failure    Validate Funding Desk in Funding Rates Updates    ${LIQ_FundingRatesUpdate_FundingDesk_List}    ${FundingDesk_Desc}
    ...    ELSE    Log    Cluster / Funding Desk is Empty.

    Log    ${LIQ_FundingRatesUpdate_Repricing_Freq_List}
    Run Keyword If    '${sRepricingFreq}'=='None' or '${sRepricingFreq}'==''    Log    Repricing Frequency is Empty.
    ...    ELSE IF    '${sRepricingFreq}'=='UNKN'    Run Keyword And Continue On Failure    Validate Repricing Frequency in Funding Rates Updates         ${LIQ_FundingRatesUpdate_StaticList}    Unknown
    ...    ELSE    Run Keyword And Continue On Failure    Validate Repricing Frequency in Funding Rates Updates    ${LIQ_FundingRatesUpdate_Repricing_Freq_List}    ${RepricingFreq_Text}

    Run Keyword If    '${status_space}'=='True'    Run Keyword And Continue On Failure    Validate Currency in Funding Rates Updates    ${LIQ_FundingRatesUpdate_Currency_List}    ${Currency_Desc}
    Run Keyword If    '${status_space}'=='False'   Run Keyword And Continue On Failure    Validate Currency in Funding Rates Updates    JavaWindow("title:=Funding Rates Update.*").JavaList("text:=${Currency_Desc}.*")    ${Currency_Desc}
    Run Keyword And Continue On Failure    Validate Base Rate in Funding Rates Updates    ${LIQ_FundingRatesUpdate_Rate_Edit}     ${NewRatePercent_5Dec}
    
    Run Keyword If    '${VALUE_DATE}' > '${PUBLISH_DATE}'    Log    Processing GS File even Value Date ${VALUE_DATE} is greater than Rate Publish Date ${PUBLISH_DATE}.
    Run Keyword If    '${PROCESSING_DATE}' > '${PUBLISH_DATE}'     Log    Processing GS File even Processing Date ${PROCESSING_DATE} is greater than Rate Publish Date ${PUBLISH_DATE}.
    
    Take Screenshot    TableMaintenance_FundingRatesUpdates
    
    mx LoanIQ click    ${LIQ_FundingRatesUpdate_Cancel_Btn}
    mx LoanIQ click    ${LIQ_BrowseFundingRates_Exit_Button}
    mx LoanIQ close window    ${LIQ_TableMaintenance_Window}
    
    Close All Windows on LIQ

Validate Funding Rates in Table Maintenance is Not Reflected
    [Documentation]    This keyword is used to validate records not displaying in LIQ Table Maintenance > Funding Rates for Base Rates.
    ...    @author: clanding    07MAR2019    - initial create, clone from Validate Funding Rates in Table Maintenance
    ...    @update: clanding    19MAR2019    - added handling for empty ${sRepricingFreq}
    ...    @update: jdelacru    02JUL2019    - used Mx Click Element If Present for Warning Message Box
    ...    @update: cfrancis    12SEP2019    - added showing all data for funding rates table when searched
    [Arguments]    ${sBaseRateCode}    ${sRepricingFreq}    ${iRate}    ${sFundingDesk}    ${sEffDate}    ${sCurrency}
    
    ${NewRatePercent_5Dec}    ${NewRate}    Compute Rate Percentage to N Decimal Values and Return    ${iRate}    5
    ${NewRatePercent_6Dec}    ${NewRate}    Compute Rate Percentage to N Decimal Values and Return    ${iRate}    6
    
    ${sRepricingFreq}    Run Keyword If    '${sRepricingFreq}'==''    Set Variable    None
    ...    ELSE    Set Variable    ${sRepricingFreq}
    
    ${RepricingFreq_Text}    Run Keyword If    '${sRepricingFreq}'!='None'    Get Base Rate Repricing Frequency Label    ${sRepricingFreq}
    ${RepricingFreq_Text}    Run Keyword If    '${sRepricingFreq}'!='None'    Strip String    ${RepricingFreq_Text}    both    0
    
    mx LoanIQ activate window    ${LIQ_Window}    
    mx LoanIQ select    ${LIQ_Options_RefreshAllCodeTables}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    ###OPTION NAME AND BASE RATE ASSOCIATION###
    ${OptionNameDesc}    ${OptionName}    Get Option Name from Option Name and Base Rate Association    ${sBaseRateCode.upper()}
    
    ###FUNDING DESK###
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    ${BaseRate_Desc}    ${BaseRate_Status}    Get Base Rate Description from Table Maintenance    ${sBaseRateCode.upper()}
    ${FundingDeskStat}    Get Funding Desk Status from Table Maintenance    ${sFundingDesk}
    ${FundingDesk_Desc}    ${FundingDesk_Currency}    Run Keyword If    '${sFundingDesk}'!='None'    Run Keyword And Continue On Failure    
    ...    Get Funding Desk Details from Table Maintenance    ${sFundingDesk}    ${FundingDeskStat}
    ...    ELSE    Run Keyword And Ignore Error     Log    Cluster is null/empty.    level=WARN
    ${Currency_Desc}    Get Currency Description from Table Maintenance    ${sCurrency}
    Search in Table Maintenance    Funding Rates
    Mx LoanIQ Set    ${LIQ_BrowseFundingDesk_ShowALL_RadioBtn}    ON
    
    ###VALIDATION IF DATES ARE EMPTY###
    ${EffDate_With_0}	Run Keyword If    '${sEffDate}'!='${NONE}'    Convert Date    ${sEffDate}    result_format=%d-%b-%Y
    ...    ELSE    Log    Effective Date value is invalid: ${sEffDate}.    level=ERROR
    
    ${EffDate_Without_0}	Run Keyword If    '${sEffDate}'!='${NONE}'    Convert Date    ${sEffDate}    result_format=%#d-%b-%Y
    ...    ELSE    Log    Effective Date value is invalid: ${sEffDate}.    level=ERROR
    
    Log    Row: ${sBaseRateCode.upper()} - ${sFundingDesk} - ${sRepricingFreq} - ${sCurrency} - ${iRate} - ${EffDate_With_0}. 
    
    ###TABLE MAINTENANCE > BROWSE FUNDING RATES WINDOW - CLICKING A ROW###
    ${Row_Selected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BrowseFundingRates_Tree}    
    ...    ${sBaseRateCode.upper()}\t${sFundingDesk}\t${sRepricingFreq}\t${sCurrency}\t${EffDate_With_0}\t${NewRate}    10
    Run Keyword If    ${Row_Selected}==${False}    Log    Correct!! Base Rate is not existing in Table Maintenance.
    ...    ELSE IF    ${Row_Selected}==${True}    Log    Incorrect!! Base Rate is existing in Table Maintenance.    level=ERROR
    ...    ELSE    Log    Keyword not applicable.
    
    Close All Windows on LIQ

Validate Funding Rates in Treasury Navigation is Reflected
    [Documentation]    This keyword is used to validate liq scenarios in Treasury for Base Rates (Create, Update & Delete).
    ...    @author: cmartill
    ...    @updated: clanding    28JAN2019    - Updated Arguments. Remove getting dat from json file.
    ...    @updated: clanding    01MAR2019    - Refactor based from CBA Evergreen Automation Checklist and PointSheet_v1.0.1. 
    ...                                       - Moved spread rate and spread effective date to last part of arguments to make it optional.
    ...    @update: clanding    19MAR2019     - Update when ${sRepricingFreq} is empty, fixed codes for Spread Rate and Date
    [Arguments]    ${sBaseRateCode}    ${sRepricingFreq}    ${iRate}    ${sFundingDesk}    ${sEffDate}    ${sCurrency}
    ...    ${sSpreadRate}=None    ${sSpreadEffDate}=None
    
    ${InterestRate_Clipboard}        Evaluate    ${iRate}*100
    ${NewRatePercent_6Dec}    ${NewRate}    Compute Rate Percentage to N Decimal Values and Return    ${iRate}    6
    
    ${SpreadRate%}    ${SpreadRate}    Run Keyword If    '${sSpreadRate}'=='None'    Compute Rate Percentage to N Decimal Values and Return    0    6
    ...    ELSE IF    '${sSpreadRate}'==''    Compute Rate Percentage to N Decimal Values and Return    0    6
    ...    ELSE IF    '${sSpreadRate}'=='no tag'    Compute Rate Percentage to N Decimal Values and Return    0    6    
    ...    ELSE    Compute Rate Percentage to N Decimal Values and Return    ${sSpreadRate}    6
    
    ${sRepricingFreq}    Run Keyword If    '${sRepricingFreq}'==''    Set Variable    None
    ...    ELSE    Set Variable    ${sRepricingFreq}
    
    ${Repricing_Frequency_Text}    Run Keyword If    '${sRepricingFreq}'!='None'    Get Base Rate Repricing Frequency Label    ${sRepricingFreq}
    ${Repricing_Frequency_Text}    Run Keyword If    '${sRepricingFreq}'!='None'    Strip String    ${Repricing_Frequency_Text}    mode=both    characters=0
    
    ##REFRESH ALL CODE TABLES###
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ select    ${LIQ_Options_RefreshAllCodeTables}
    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    
    ###OPTION NAME AND BASE RATE ASSOCIATION FOR ADMIN ONLY###
    ${OptionNameDesc}    ${OptionName}    Get Option Name from Option Name and Base Rate Association    ${sBaseRateCode.upper()}
    ${sRepricingFreq}    Strip String    ${sRepricingFreq}    mode=both    characters=0
    
    ###GETTING THE PRE-REQUISITE VALUES FROM TABLE MAINTENANCE WINDOW###
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    ${BaseRate_Description}    ${BaseRate_Status}    Get Base Rate Description from Table Maintenance    ${sBaseRateCode.upper()}
    ${FundingDeskStat}    Get Funding Desk Status from Table Maintenance    ${sFundingDesk}
    ${Funding_Desk_Desc}    ${Funding_Desk_Currency}    Run Keyword If    '${sFundingDesk}'!='None'    Run Keyword And Continue On Failure    
    ...    Get Funding Desk Details from Table Maintenance    ${sFundingDesk}    ${FundingDeskStat}
    ...    ELSE    Run Keyword And Ignore Error     Log    Cluster is null/empty.
    ${Currency_Description}    Get Currency Description from Table Maintenance    ${sCurrency}   
    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}
    
    ###VALIDATION IF DATES ARE EMPTY###
    Run Keyword If    '${sEffDate}'=='None'    Run Keyword And Continue On Failure    Validate Base Rate Effective Date Empty 
    ...    ELSE    Run Keyword And Continue On Failure   Validate Base Rate Effective Date with Conversion    ${sEffDate}    
    Run Keyword If    '${sSpreadRate}'=='None'    Log    Spread Rate and Spread Effective are empty. Valid. (Optional).
    ...    ELSE IF    '${sSpreadRate}'==''    Log    Spread Rate and Spread Effective are empty. Valid. (Optional).
    ...    ELSE IF    '${sSpreadRate}'=='no tag'    Log    Spread Rate and Spread Effective are empty. Valid. (Optional).    
    ...    ELSE    Validate Spread Effective Date with Conversion    ${sSpreadEffDate}
    
    ###TREASURY WINDOW###
    Select Treasury Navigation    Funding Rates 
    mx LoanIQ activate    ${LIQ_FundingRates_Window}
    mx LoanIQ maximize    ${LIQ_FundingRates_Window}
    
    ###SETTING THE VALUES FOR GLOBAL###
    Set Global Variable Values For Base Rates    ${sBaseRateCode.upper()}    ${OptionNameDesc}    ${iRate}    ${NewRatePercent_6Dec}    ${BaseRate_Description}    ${BASE_EFFECTIVE_DATE_WITH_0}    
    ...    ${Repricing_Frequency_Text}    ${sCurrency}
    Log    Row: ${sBaseRateCode.upper()} - ${Funding_Desk_Desc} - ${Repricing_Frequency_Text} - ${sCurrency} - ${iRate} - ${BASE_EFFECTIVE_DATE_WITH_0}.
    
    ###CLICK THE BASE RATE CODE###
    ###WITH CLUSTER and REPRICING FREQUENCY###
    ${isBaseRateCodeExists}    Run Keyword If    '${sFundingDesk}'!='None' and '${sRepricingFreq}'!='None'    Run Keyword And Return Status     Mx LoanIQ Select String    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t${Funding_Desk_Desc}\t${Repricing_Frequency_Text}\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}
    Run Keyword If    ${isBaseRateCodeExists}==${True}    Take Screenshot    TreasuryNavigation_FundingRates
    Run Keyword If    ${isBaseRateCodeExists}==${True}    Mx LoanIQ DoubleClick    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t${Funding_Desk_Desc}\t${Repricing_Frequency_Text}\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}
    ...    ELSE IF    ${isBaseRateCodeExists}==${False}    Log    Base Rate Code of ${sBaseRateCode.upper()} with Funding Desk of ${Funding_Desk_Desc} and Repricing Frequency of ${Repricing_Frequency_Text} does not exists in the table. Some of the fields doesn't match.
    Run Keyword If    ${isBaseRateCodeExists}==${False} and '${isBaseRateCodeExists}'!='None'    Fail    Base Rate Code of ${sBaseRateCode.upper()} with Funding Desk of ${Funding_Desk_Desc} and Repricing Frequency of ${Repricing_Frequency_Text} and Effective Date of ${BASE_EFFECTIVE_DATE_WITH_0} does not exists in the table.
    
    ###WITHOUT CLUSTER and WITH REPRICING FREQUENCY###
    ${isBaseRateCodeExists_without_cluster}    Run Keyword If    '${sFundingDesk}'=='None' and '${sRepricingFreq}'!='None'    Run Keyword And Return Status     Mx LoanIQ Select String    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t\t${Repricing_Frequency_Text}\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}
    Run Keyword If    ${isBaseRateCodeExists_without_cluster}==${True}    Take Screenshot    TreasuryNavigation_FundingRates
    Run Keyword If    ${isBaseRateCodeExists_without_cluster}==${True}    Mx LoanIQ DoubleClick    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t\t${Repricing_Frequency_Text}\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}
    ...    ELSE IF    ${isBaseRateCodeExists_without_cluster}==${False}    Log    Base Rate Code of ${sBaseRateCode.upper()} without Funding Desk and with Repricing Frequency of ${Repricing_Frequency_Text} does not exists in the table. Some of the fields doesn't match.     
    Run Keyword If    ${isBaseRateCodeExists_without_cluster}==${False} and '${isBaseRateCodeExists_without_cluster}'!='None'    Fail    Base Rate Code of ${sBaseRateCode.upper()} without Funding Desk and with Repricing Frequency of ${Repricing_Frequency_Text} and Effective Date of ${BASE_EFFECTIVE_DATE_WITH_0} does not exists in the table.
    
    ###WITHOUT REPRICING FREQUENCY###
    ${isBaseRateCodeExists_without_repfreq}    Run Keyword If    '${sFundingDesk}'!='None' and '${sRepricingFreq}'=='None'    Run Keyword And Return Status     Mx LoanIQ Select String    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t${Funding_Desk_Desc}\t\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}
    Run Keyword If    ${isBaseRateCodeExists_without_repfreq}==${True}    Take Screenshot    TreasuryNavigation_FundingRates
    Run Keyword If    ${isBaseRateCodeExists_without_repfreq}==${True}    Mx LoanIQ DoubleClick    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t${Funding_Desk_Desc}\t\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}     
    ...    ELSE IF    ${isBaseRateCodeExists_without_repfreq}==${False}    Log    Base Rate Code of ${sBaseRateCode.upper()} with Funding Desk of ${Funding_Desk_Desc} without Repricing Frequency does not exists in the table. Some of the fields doesn't match.
    Run Keyword If    ${isBaseRateCodeExists_without_repfreq}==${False} and '${isBaseRateCodeExists_without_repfreq}'!='None'    Fail    Base Rate Code of ${sBaseRateCode.upper()} with Funding Desk of ${Funding_Desk_Desc} without Repricing Frequency and Effective Date of ${BASE_EFFECTIVE_DATE_WITH_0} does not exists in the table.
    
    ###WITHOUT CLUSTER AND REPRICING FREQUENCY###
    ${isBaseRateCodeExists_without_cluster_repfreq}    Run Keyword If    '${sFundingDesk}'=='None' and '${sRepricingFreq}'=='None'    Run Keyword And Return Status     Mx LoanIQ Select String    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t\t\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}
    Run Keyword If    ${isBaseRateCodeExists_without_cluster_repfreq}==${True}    Take Screenshot    TreasuryNavigation_FundingRates
    Run Keyword If    ${isBaseRateCodeExists_without_cluster_repfreq}==${True}    Mx LoanIQ DoubleClick    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t\t\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}     
    ...    ELSE IF    ${isBaseRateCodeExists_without_cluster_repfreq}==${False}    Log    Base Rate Code of ${sBaseRateCode.upper()} without Funding Desk and Repricing Frequency does not exists in the table. Some of the fields doesn't match.
    Run Keyword If    ${isBaseRateCodeExists_without_cluster_repfreq}==${False} and '${isBaseRateCodeExists_without_cluster_repfreq}'!='None'    Fail    Base Rate Code of ${sBaseRateCode.upper()} without Funding Desk and Repricing Frequency with Effective Date of ${BASE_EFFECTIVE_DATE_WITH_0} does not exists in the table.    
    
    ###ACTIVATE FUNDING RATE DETAILS WINDOW###
    mx LoanIQ activate window    ${LIQ_FundingRatesDetails_Window}
    Take Screenshot    TreasuryNavigation_FundingRatesDetails
   
    ###SETTING OF LOCATORS###
    ${LIQ_FundingDesk_BaseRateDescription_Text}     Set Attached Text and Label Locator Single Text        Funding Rate Details    ${BaseRate_Description}
    ${LIQ_FundingDesk_Desciption_Text}    Run Keyword If    '${sFundingDesk}'!='None'    Set Attached and Label Text with 2 words to Locator    Funding Rate Details    ${Funding_Desk_Desc}
    ...    ELSE    Log To Console    Cluster or Funding Desk is Empty.
    ${LIQ_FundingRatesUpdate_Repricing_Freq_StaticText_1}     Set Attached Text and Label Locator Single Text        Funding Rate Details    ${Repricing_Frequency_Text}
    ${LIQ_FundingRatesUpdate_Repricing_Freq_StaticText_UNKN}    Run Keyword If    '${sRepricingFreq}'=='UNKN'    Set Variable    JavaWindow("title:=Funding Rates Details.*").JavaStaticText("label:=Unknown.*","attached text:=Unknown.*")
    Run Keyword If    '${sRepricingFreq}'=='None'    Log    Repricing Frequency is empty. No setting of locator.
    ${LIQ_FundingDesk_Currency_Text}     Set Attached Text and Label Locator Single Text    Funding Rate Details    ${sCurrency}
    ###END OF SETTING OF LOCATORS###  
     
    ###VALIDATE FUNDING RATES DETAILS WINDOW###
    Run Keyword And Continue On Failure    Validate Base Rate    ${LIQ_FundingDesk_BaseRateDescription_Text}    ${BaseRate_Description}
    Run Keyword If    '${sFundingDesk}'!='None'    Run Keyword And Continue On Failure    Validate Funding Desk    ${LIQ_FundingDesk_Desciption_Text}    ${Funding_Desk_Desc}
    ...    ELSE    Log    Funding Desk and Repricing Frequency is empty (Optional)    
    Run Keyword If    '${sRepricingFreq}'!='None'    Run Keyword And Continue On Failure    Validate Repricing Frequency    ${LIQ_FundingRatesUpdate_Repricing_Freq_StaticText_1}    ${repricing_frequency_label} 
    ...    ELSE IF    '${sRepricingFreq}'=='UNKN'    Run Keyword And Continue On Failure    Validate Repricing Frequency    ${LIQ_FundingRatesUpdate_Repricing_Freq_StaticText_UNKN}    Unknown
    ...    ELSE IF    '${sRepricingFreq}'=='None'    Log    Repricing Frequency is empty (optional)     
    Run Keyword And Continue On Failure    Validate Currency                      ${LIQ_FundingDesk_Currency_Text}    ${sCurrency}
    Run Keyword And Continue On Failure    Validate Base Rate                     JavaWindow("title:=Funding Rate Details.*").JavaEdit("index:=0","text:=${NewRatePercent_6Dec}.*","value:=${NewRatePercent_6Dec}.*")    ${NewRatePercent_6Dec}
    Run Keyword And Continue On Failure    Validate Base Rate Effective Date      JavaWindow("title:=Funding Rate Details.*").JavaEdit("tagname:=Text","path:=Text;Shell;","text:=${BASE_EFFECTIVE_DATE_WITH_0}","value:=${BASE_EFFECTIVE_DATE_WITH_0}")    ${BASE_EFFECTIVE_DATE_WITH_0}
    
    Log    Spread Date: ${sSpreadEffDate}
    Log    Spread Rate: ${sSpreadRate}
    
    ###SPREAD RATE AND SPREAD EFFECTIVE VALIDATION###
    Run Keyword If    '${sSpreadRate}'=='None'    Log    Spread Rate and Spread Effective are empty. Valid. (Optional).    ## add validation of old spread rate/date
    ...    ELSE IF    '${sSpreadRate}'==''    Log    Spread Rate and Spread Effective are empty. Valid. (Optional).    ## add validation of old spread rate/date
    ...    ELSE IF    '${sSpreadRate}'=='no tag'    Log    Spread Rate and Spread Effective are empty. Valid. (Optional).    ## add validation of old spread rate/date    
    ...    ELSE    Run Keywords    Validate Spread Rate    JavaWindow("title:=Funding Rate Details.*").JavaEdit("attached text:=Spread:.*","text:=${SpreadRate%}","value:=${SpreadRate%}")    ${SpreadRate%}
    ...    AND    Validate Spread Effective Date    JavaWindow("title:=Funding Rate Details.*").JavaEdit("attached text:=Effective Date:.*")        ${SpreadRate%}    
    
    ###VALIDATE FUNDING RATE BASE HISTORY LIST###
    Run Keyword If    '${sEffDate}' == 'None'    Run Keyword And Continue On Failure    Validate Base Rate History Table in Funding Rate    ${LIQ_History_Button}            
    ...    ${LIQ_History_Tree_Field}    ${BASE_EFFECTIVE_DATE_WITHOUT_0}    ${BASE_EFFECTIVE_DATE_WITH_0}    ${iRate}    ${NewRatePercent_6Dec}    ${CONV_BACKDATED_DATE_WITH_0}    ${CONV_BACKDATED_DATE_WITHOUT_0}
    ...    ELSE    Run Keyword And Continue On Failure    Validate Base Rate History Table in Funding Rate    ${LIQ_History_Button}    ${LIQ_History_Tree_Field}    
    ...    ${BASE_EFFECTIVE_DATE_WITHOUT_0}    ${BASE_EFFECTIVE_DATE_WITH_0}    ${iRate}    ${NewRatePercent_6Dec}    ${CONV_BACKDATED_DATE_WITH_0}    ${CONV_BACKDATED_DATE_WITHOUT_0}       
    Run Keyword If    '${sEffDate}' == 'None'    Take Screenshot    TreasuryNavigation_FundingRatesHistory
    
    ###VALIDATE FUNDING RATE SPREAD HISTORY LIST###
    Run Keyword If    '${sSpreadRate}'=='None'    Log    Spread Effective Date is Empty.
    ...    ELSE IF    '${sSpreadRate}'==''    Log    Spread Effective Date is Empty.
    ...    ELSE IF    '${sSpreadRate}'=='no tag'    Log    Spread Effective Date is Empty.    
    ...    ELSE    Run Keyword And Continue On Failure    Validate Spread Rate History Table in Funding Rate    ${LIQ_SpreadHistory_Btn}    
    ...    ${LIQ_SpreadHistory_Tree_Field}    ${SPREAD_EFFECTIVE_DATE_WITHOUT_0}    ${SPREAD_EFFECTIVE_DATE_WITH_0}    ${sSpreadRate}    ${SpreadRate%}    
    ...    ${CONV_BACKDATED_SPREAD_DATE_WITH_0}    ${CONV_BACKDATED_SPREAD_DATE_WITHOUT_0}
    
    ${Line_Count}    Validate Events Table without Content    
    Log    ${Line_Count}!=1 and '${SpreadRate%}'!='None' and '${sSpreadRate}'!='None' and '${sSpreadRate}'!='' and '${sSpreadRate}'!='no tag'
    ###VALIDATE EVENTS LIST###
    Run Keyword If    ${Line_Count}!=1 and '${SpreadRate%}'=='None'    Run Keyword And Continue On Failure    Validate Events Rate Record in Events Table in Funding Rate    ${LIQ_FundingEventsList_Tree_Field}    ${BASE_EFFECTIVE_DATE_WITH_0}    ${SPREAD_EFFECTIVE_DATE_WITH_0}    ${iRate}    ${sSpreadRate}
    ...    ELSE IF    ${Line_Count}!=1 and '${sSpreadRate}'=='None'    Run Keyword And Continue On Failure    Validate Events Rate Record in Events Table in Funding Rate    ${LIQ_FundingEventsList_Tree_Field}    ${BASE_EFFECTIVE_DATE_WITH_0}    ${SPREAD_EFFECTIVE_DATE_WITH_0}    ${iRate}    ${sSpreadRate} 
    ...    ELSE IF    ${Line_Count}!=1 and '${sSpreadRate}'==''    Run Keyword And Continue On Failure    Validate Events Rate Record in Events Table in Funding Rate    ${LIQ_FundingEventsList_Tree_Field}    ${BASE_EFFECTIVE_DATE_WITH_0}    ${SPREAD_EFFECTIVE_DATE_WITH_0}    ${iRate}    ${sSpreadRate}
    ...    ELSE IF    ${Line_Count}!=1 and '${sSpreadRate}'=='no tag'    Run Keyword And Continue On Failure    Validate Events Rate Record in Events Table in Funding Rate    ${LIQ_FundingEventsList_Tree_Field}    ${BASE_EFFECTIVE_DATE_WITH_0}    ${SPREAD_EFFECTIVE_DATE_WITH_0}    ${iRate}    ${sSpreadRate}    
    ...    ELSE IF    ${Line_Count}!=1 and '${sSpreadRate}'!='no tag' and '${sSpreadRate}'!='None' and '${sSpreadRate}'!=''    Run Keyword And Continue On Failure    Validate Events Spread Record in Events Table in Funding Rate    ${SPREAD_EFFECTIVE_DATE_WITH_0}    ${SpreadRate}
    ...    ELSE    Log    Events will only record change in Rates and Effective Dates.
    Take Screenshot    TreasuryNavigation_FundingRatesEvents    
    Run Keyword If    ${Line_Count}==1    Run Keywords    mx LoanIQ activate window    ${LIQ_FundingRatesDetails_Window}    
    ...    AND    mx LoanIQ click    ${LIQ_FundingRate_Exit_Btn}
    ...    AND    mx LoanIQ activate    ${LIQ_FundingRates_Window}
    ...    AND    Log    Events List Has No Content.
    
    Close All Windows on LIQ

Validate Funding Rates in Treasury Navigation is Not Reflected
    [Documentation]    This keyword is used to validate records not displaying in LIQ Treasury Navigation > Funding Rates for Base Rates.
    ...    @author: clanding    07MAR2019    - initial create, clone from Validation Loan IQ Base Rates in Treasury Navigation
    ...                                      - removed maximize and activate window for Funding Rates
    [Arguments]    ${sBaseRateCode}    ${sRepricingFreq}    ${iRate}    ${sFundingDesk}    ${sEffDate}    ${sCurrency}
    ...    ${sSpreadRate}=None    ${sSpreadEffDate}=None
    
    ${InterestRate_Clipboard}        Evaluate    ${iRate}*100
    ${NewRatePercent_6Dec}    ${NewRate}    Compute Rate Percentage to N Decimal Values and Return    ${iRate}    6
    
    ${SpreadRate%}    ${SpreadRate}    Run Keyword If    '${sSpreadRate}'=='None'    Compute Rate Percentage to N Decimal Values and Return    0    6
    ...    ELSE IF    '${sSpreadRate}'=='${EMPTY}'    Compute Rate Percentage to N Decimal Values and Return    0    6
    ...    ELSE IF    '${sSpreadRate}'=='no tag'    Compute Rate Percentage to N Decimal Values and Return    0    6    
    ...    ELSE    Compute Rate Percentage to N Decimal Values and Return    ${sSpreadRate}    6
    
    ${sRepricingFreq}    Run Keyword If    '${sRepricingFreq}'==''    Set Variable    None
    ...    ELSE    Set Variable    ${sRepricingFreq}
    
    ${Repricing_Frequency_Text}    Run Keyword If    '${sRepricingFreq}'!='None'    Get Base Rate Repricing Frequency Label    ${sRepricingFreq}
    ${Repricing_Frequency_Text}    Run Keyword If    '${sRepricingFreq}'!='None'    Strip String    ${Repricing_Frequency_Text}    both    0
    
    ##REFRESH ALL CODE TABLES###
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ select    ${LIQ_Options_RefreshAllCodeTables}
    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    
    ###OPTION NAME AND BASE RATE ASSOCIATION FOR ADMIN ONLY###
    ${OptionNameDesc}    ${OptionName}    Get Option Name from Option Name and Base Rate Association    ${sBaseRateCode.upper()}
    ${sRepricingFreq}    Strip String    ${sRepricingFreq}    mode=both    characters=0
    
    ###GETTING THE PRE-REQUISITE VALUES FROM TABLE MAINTENANCE WINDOW###
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    ${BaseRate_Description}    ${BaseRate_Status}    Get Base Rate Description from Table Maintenance    ${sBaseRateCode.upper()}
    ${FundingDeskStat}    Get Funding Desk Status from Table Maintenance    ${sFundingDesk}
    ${Funding_Desk_Desc}    ${Funding_Desk_Currency}    Run Keyword If    '${sFundingDesk}'!='None'    Run Keyword And Continue On Failure    
    ...    Get Funding Desk Details from Table Maintenance    ${sFundingDesk}    ${FundingDeskStat}
    ...    ELSE    Run Keyword And Ignore Error     Log    Cluster is null/empty.
    ${Currency_Description}    Get Currency Description from Table Maintenance    ${sCurrency}   
    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}
    
    ###VALIDATION IF DATES ARE EMPTY###
    Run Keyword If    '${sEffDate}'=='None'    Run Keyword And Continue On Failure    Validate Base Rate Effective Date Empty 
    ...    ELSE    Run Keyword And Continue On Failure   Validate Base Rate Effective Date with Conversion    ${sEffDate}
    Run Keyword If    '${sSpreadRate}'=='None'    Log    Spread Rate and Spread Effective are empty. Valid. (Optional).
    ...    ELSE IF    '${sSpreadRate}'=='${EMPTY}'    Log    Spread Rate and Spread Effective are empty. Valid. (Optional).
    ...    ELSE IF    '${sSpreadRate}'=='no tag'    Log    Spread Rate and Spread Effective are empty. Valid. (Optional).    
    ...    ELSE    Validate Spread Effective Date with Conversion    ${sSpreadEffDate}
    
    ###TREASURY WINDOW###
    Select Treasury Navigation    Funding Rates 
    mx LoanIQ activate    ${LIQ_FundingRates_Window}
    
    ###SETTING THE VALUES FOR GLOBAL###
    Set Global Variable Values For Base Rates    ${sBaseRateCode.upper()}    ${OptionNameDesc}    ${iRate}    ${NewRatePercent_6Dec}    ${BaseRate_Description}    ${BASE_EFFECTIVE_DATE_WITH_0}    
    ...    ${Repricing_Frequency_Text}    ${sCurrency}
    Log    Row: ${sBaseRateCode.upper()} - ${Funding_Desk_Desc} - ${Repricing_Frequency_Text} - ${sCurrency} - ${iRate} - ${BASE_EFFECTIVE_DATE_WITH_0}.
    
    ${Row_Selected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BaseRate_Table_Row}    
    ...    ${sBaseRateCode.upper()}\t${Funding_Desk_Desc}\t${Repricing_Frequency_Text}\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}    10
    Run Keyword If    ${Row_Selected}==${False}    Log    Correct!! Base Rate is not existing in Treasury Navigation.
    ...    ELSE IF    ${Row_Selected}==${True}    Log    Incorrect!! Base Rate is existing in Treasury Navigation.    level=ERROR
    ...    ELSE    Log    Keyword not applicable. 
    
    ${isBaseRateCodeExists_without_cluster}    Run Keyword If    '${sFundingDesk}'=='None' and '${sRepricingFreq}'!='None'    Run Keyword And Return Status    
    ...    Mx LoanIQ Select String    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t\t${Repricing_Frequency_Text}\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}    10
    Run Keyword If    ${isBaseRateCodeExists_without_cluster}==${False}    Log    Correct!! Base Rate is not existing in Treasury Navigation.
    ...    ELSE IF    ${isBaseRateCodeExists_without_cluster}==${True}    Log    Incorrect!! Base Rate is existing in Treasury Navigation.    level=ERROR
    ...    ELSE    Log    Keyword not applicable.
    
    ${isBaseRateCodeExists_without_repfreq}    Run Keyword If    '${sFundingDesk}'!='None' and '${sRepricingFreq}'=='None'    Run Keyword And Return Status    Mx LoanIQ Select String    
    ...    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t${Funding_Desk_Desc}\t\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}    10
    Run Keyword If    ${isBaseRateCodeExists_without_repfreq}==${False}    Log    Correct!! Base Rate is not existing in Treasury Navigation.
    ...    ELSE IF    ${isBaseRateCodeExists_without_repfreq}==${True}    Log    Incorrect!! Base Rate is existing in Treasury Navigation.    level=ERROR
    ...    ELSE    Log    Keyword not applicable.  
    
    ${isBaseRateCodeExists_without_cluster_repfreq}    Run Keyword If    '${sFundingDesk}'=='None' and '${sRepricingFreq}'=='None'    Run Keyword And Return Status     Mx LoanIQ Select String    
    ...    ${LIQ_BaseRate_Table_Row}    ${sBaseRateCode.upper()}\t\t\t${sCurrency}\t${iRate}\t${BASE_EFFECTIVE_DATE_WITH_0}    10
    Run Keyword If    ${isBaseRateCodeExists_without_cluster_repfreq}==${False}    Log    Correct!! Base Rate is not existing in Treasury Navigation.
    ...    ELSE IF    ${isBaseRateCodeExists_without_cluster_repfreq}==${True}    Log    Incorrect!! Base Rate is existing in Treasury Navigation.    level=ERROR
    ...    ELSE    Log    Keyword not applicable.
    Take Screenshot    TreasuryNavigation_FundingRates
    
    Close All Windows on LIQ
    
Validate Base Rate Code in LoanIQ for TL Base Success for Multiple Files
    [Documentation]    This keyword is used to convert Transformed Data into dictionary and validate multiple Base Rate in LoanIQ.
    ...    @author: clanding    28FEB2019    - initial create
    ...    @update: jdelacru    12AUG2019    - Update Transform Base
    :FOR    ${TransformedData}    IN    @{TRANSFORMEDDATA_LIST}
    \    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success    ${TransformedData}

Validate Base Rate Code in LoanIQ for TL Base Success for Last Index
    [Documentation]    This keyword is used to convert Transformed Data into dictionary and validate the latest Base Rate record that has been processed in LoanIQ.
    ...    @author: jdelacru    12AUG2019    - initial create
    Log    ${TRANSFORMEDDATA_LIST}
    ${TransformedFileCount}    Get Length    ${TRANSFORMEDDATA_LIST}
    ${LastIndex}    Evaluate    ${TransformedFileCount}-1
    Reverse List    ${TRANSFORMEDDATA_LIST}
    Log    ${TRANSFORMEDDATA_LIST}
    ${TransformedData}    Get From List    ${TRANSFORMEDDATA_LIST}    ${LastIndex}
    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success    ${TransformedData}
    
Validate Base Rate Code in LoanIQ for TL Base Success on Future Date for Multiple Files
    [Documentation]    This keyword is used to convert Transformed Data into dictionary and validate multiple Base Rate with future date in LoanIQ.
    ...    @author: jdelacru    14AUG2019    - initial create
    :FOR    ${TransformedData}    IN    @{TRANSFORMEDDATA_LIST}
    \    Run Keyword And Continue On Failure    Validate Base Rate Code in LoanIQ for TL Base Success    ${TransformedData}
 
Validate Inactive Tenor Code Cannot be Used for Pricing Option in LoanIQ
    [Documentation]    This keyword is used to verify that Inactive Tenor Codes cannot be used as Pricing Option in LoanIQ
    ...    @author: cfrancis    09SEP2019    - initial create
    [Arguments]    ${sTransformedData_FilePath}    ${sDealName}
    Open Existing Deal    ${sDealName}
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Pricing Rules
    mx LoanIQ click    ${LIQ_PricingRules_AddOption_Button}
    Open Excel    ${dataset_path}${sTransformedData_FilePath}
    ${Row_Count}    Get Row Count    Transformed_BaseRate
    :FOR    ${Index}    IN RANGE    1    ${Row_Count}
    \    ${dTransformedData}    Create Dictionary Using Transformed Data and Return    ${dataset_path}${sTransformedData_FilePath}    ${Index}
    \    ${PricingOption}    Run Keyword and Continue on Failure    Convert Pricing Option from Base Rate Code and Available Rate    &{dTransformedData}[baseRateCode]
         ...    &{dTransformedData}[buyRate]    &{dTransformedData}[midRate]    &{dTransformedData}[sellRate]    &{dTransformedData}[lastRate]
    \    ${RateTenor}    Run Keyword and Continue on Failure   Trim Leading 0 from Rate Tenor    &{dTransformedData}[rateTenor] 
    \    Run Keyword and Continue on Failure    Verify Pricing Option Frequency is not Available    ${PricingOption}    ${RateTenor}
    Close Current Excel Document
Verify Pricing Option Frequency is not Available
    [Documentation]    This keyword verifies the pricing option is not present
    ...    @author: cfrancis    10SEP2019    - initial create
    [Arguments]    ${sPricingOption}    ${sRateTenor}
    mx LoanIQ activate window    ${LIQ_InterestPricingOption_Window}
    Mx LoanIQ Verify Object Exist    ${LIQ_InterestPricingOption_Dropdown}    VerificationData="Yes"
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestPricingOption_Dropdown}    ${sPricingOption}
    Take Screenshot    PricingOption_Selected
    mx LoanIQ click    ${LIQ_InterestPricingOption_Frequency_Button}
    ${Status}    Run Keyword and Return Status    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_FrequencySelectionList_Available_JavaTree}    ${sRateTenor}%s
    Log    ${Status}
    Run Keyword If    ${Status}==${False} and '${sPricingOption}' != 'Default'    Log    Correct!! Base Rate Code ${sPricingOption} with ${sRateTenor} Tenor is not existing in Pricing Option.
    ...    ELSE IF    ${Status}==${True}    Run Keyword and Continue on Failure    Fail    Incorrect!! Base Rate Code ${sPricingOption} with ${sRateTenor} Tenor is existing in Pricing Option.
    ...    ELSE    Run Keyword and Continue on Failure    Fail    Keyword not applicable for Pricing Option ${sPricingOption} and ${sRateTenor} Tenor.
    Take Screenshot    PricingOption_Frequency
    mx LoanIQ click    ${LIQ_FrequencySelectionList_Cancel_Button}
    
Convert Pricing Option from Base Rate Code and Available Rate
    [Documentation]    This keyword converts the Base Rate Code and Given Rate to the Pricing Option
    ...    @author: cfrancis    11SEP2019    - initial create
    [Arguments]    ${sBaseRateCode}    ${sBuyRate}    ${sMidRate}    ${sSellRate}    ${sLastRate}
    ${PricingOption}    Run Keyword If    '${sBaseRateCode}' == 'BANKBILL' and '${sBuyRate}' != 'null'    Set Variable    BBSY - Bid
    ...    ELSE IF    '${sBaseRateCode}' == 'BANKBILL' and '${sMidRate}' != 'null'    Set Variable    BBSW - Mid
    ...    ELSE IF    '${sBaseRateCode}' == 'BKBM' and '${sBuyRate}' != 'null'    Set Variable    BKBM Option
    ...    ELSE IF    '${sBaseRateCode}' == 'THBFIX' and '${sBuyRate}' != 'null'    Set Variable    THBFIX Option
    ...    ELSE IF    '${sBaseRateCode}' == 'HIBOR' and '${sBuyRate}' != 'null'    Set Variable    HKD HIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'JIBOR' and '${sLastRate}' != 'null'    Set Variable    JIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'SIBOR' and '${sBuyRate}' != 'null'    Set Variable    SIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'CIBOR' and '${sLastRate}' != 'null'    Set Variable    CIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'EURIBOR' and '${sBuyRate}' != 'null'    Set Variable    EURIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'JIBAR' and '${sLastRate}' != 'null'    Set Variable    JIBAR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'LIBOR' and '${sBuyRate}' != 'null' or '${sLastRate}' != 'null'    Set Variable    GBP LIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'LMIR' and '${sBuyRate}' != 'null'    Set Variable    LMIR / Daily LIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'NIBOR' and '${sLastRate}' != 'null'    Set Variable    NIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'PRIBOR' and '${sLastRate}' != 'null'    Set Variable    PRIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'SOR' and '${sBuyRate}' != 'null'    Set Variable    SGD Swap Offer Rate (SOR)
    ...    ELSE IF    '${sBaseRateCode}' == 'STIBOR' and '${sBuyRate}' != 'null'    Set Variable    STIBOR Option
    ...    ELSE IF    '${sBaseRateCode}' == 'CDOR' and '${sLastRate}' != 'null'    Set Variable    CAD Bankers Acceptance - Mid (CDOR)
    ...    ELSE IF    '${sBaseRateCode}' == 'FED-FUND' and '${sBuyRate}' != 'null'    Set Variable    Federal Funds Rate
    ...    ELSE IF    '${sBaseRateCode}' == 'TIIE' and '${sBuyRate}' != 'null'    Set Variable    TIIE Option
    ...    ELSE IF    '${sBaseRateCode}' == 'TIIE' and '${sBuyRate}' != 'null'    Set Variable    Euro Overnight Index Average (EONIA)
    ...    ELSE    Set Variable    Default
    [Return]    ${PricingOption}
    
Trim Leading 0 from Rate Tenor
    [Documentation]    This keyword removes leading 0s from Rate Tenor on the Transformed Data List
    ...    @author cfrancis    11SEP2019    - initial create
    [Arguments]    ${sRateTenor}
    @{RateTenor}    Split String To Characters    ${sRateTenor}
    ${TrimmedRateTenor}    Run Keyword If    '@{RateTenor}[0]' == '0' and '@{RateTenor}[1]' == '0'    Get Substring    ${sRateTenor}    2
    ...    ELSE IF    '@{RateTenor}[0]' == '0' and '@{RateTenor}[1]' != '0'    Get Substring    ${sRateTenor}    1
    ...    ELSE    Set Variable    ${sRateTenor}
    [Return]    ${TrimmedRateTenor}
