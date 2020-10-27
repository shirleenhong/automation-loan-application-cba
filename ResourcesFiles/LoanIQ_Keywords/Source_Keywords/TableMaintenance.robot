*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Search in Table Maintenance         
    [Documentation]    This keyword is used to search in Table Maintenance and doubleclick the value.
    ...    e.g. Search in Table Maintenance    Currency Pair
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sTableName}
    mx LoanIQ activate window    ${LIQ_TableMaintenance_Window}
    mx LoanIQ enter    ${LIQ_TableMaintenance_Search_Field}    ${sTableName}
    Mx LoanIQ DoubleClick    ${LIQ_TableMaintenance_Tables_JavaTree}    ${sTableName}       

Validate Currency Pairs
    [Documentation]    This keyword is used to validate currency pairs is existing in table maintenance.
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sToCurrencyVal}    ${sFromCurrencyVal}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Currency Pairs
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_BrowseCurrencyPair_Tree}    ${sFromCurrencyVal}\t${sToCurrencyVal}
    mx LoanIQ click    ${LIQ_BrowseCurrencyPairs_Exit_Button}    
    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}

Validate Currency Pairs By Funding Desk
    [Documentation]    This keyword is used to validate currency pairs by funding desk is existing in table maintenance.
    ...    @author: ccarriedo    27OCT2020    - initial create
    [Arguments]    ${sToCurrencyVal}    ${sFromCurrencyVal}    ${sFundingDeskVal}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Currency Pairs By Funding Desk
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_BrowseCurrencyPair_Tree}    ${sFromCurrencyVal}\t${sToCurrencyVal}\t${sFundingDeskVal}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Currency_Pairs_By_Funding_Desk
    mx LoanIQ click    ${LIQ_BrowseCurrencyPairs_Exit_Button}    
    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}

Get Funding Desk Details from Table Maintenance
    [Documentation]    This keyword is used to get funding desk description from table maintenance using cluster from json file.
    ...    @author: clanding
    ...    @update: clanding    12MAR2019    - added optional argument ${sExpectedStatus} and handle if value is None, updated Wait Until Keyword Succeeds
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sCluster}    ${sExpectedStatus}=None
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}    
    Search in Table Maintenance    Funding Desk
    Mx LoanIQ Set    ${LIQ_BrowseFundingDesk_ShowALL_RadioBtn}    ON  
    ${FundingDesk_Desc}    Wait Until Keyword Succeeds    5x    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseFundingDesk_Tree}    ${sCluster}%Description%FundingDesk_Desc
    ${FundingDesk_Currency}    Wait Until Keyword Succeeds    5x    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseFundingDesk_Tree}    ${sCluster}%Currency%FundingDesk_Currency
    ${FundingDesk_Stat}    Wait Until Keyword Succeeds    5x    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseFundingDesk_Tree}    ${sCluster}%%FundingDesk_Stat
    Run Keyword If    '${FundingDesk_Stat}'=='Y' and '${sExpectedStatus}'=='None'    Log    FUNDING DESK Status of ${sCluster} is ACTIVE.
    ...    ELSE IF    '${FundingDesk_Stat}'=='Y' and '${sExpectedStatus}'=='A'    Log    FUNDING DESK Status of ${sCluster} is ACTIVE.
    ...    ELSE IF    '${FundingDesk_Stat}'=='N' and '${sExpectedStatus}'=='A'    Log    FUNDING DESK Status of ${sCluster} is INACTIVE.    level=ERROR
    ...    ELSE IF    '${FundingDesk_Stat}'=='N' and '${sExpectedStatus}'=='I'    Log    FUNDING DESK Status of ${sCluster} is INACTIVE.
    ...    ELSE IF    '${FundingDesk_Stat}'=='Y' and '${sExpectedStatus}'=='I'    Log    FUNDING DESK Status of ${sCluster} is ACTIVE.    level=ERROR
    ...    ELSE    Log    FUNDING DESK Status of ${sCluster} is INACTIVE.    level=ERROR
    mx LoanIQ click    ${LIQ_BrowseFundingDesk_Exit_Button}
    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}
    [Return]    ${FundingDesk_Desc}    ${FundingDesk_Currency} 

Get Currency Description from Table Maintenance
    [Documentation]    This keyword used to get the currency description from table maintenance using the currency code from json file.
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sCurrencyCode}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button} 
    Search in Table Maintenance    Currency
    mx LoanIQ enter    ${LIQ_BrowseCurrency_Search_Field}    ${sCurrencyCode}      
    ${currency_description}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseCurrency_Tree}    ${sCurrencyCode}%Description%currency_description
    mx LoanIQ click    ${LIQ_BrowseCurrency_Exit_Btn}
    [Return]     ${currency_description}

Validate Cluster is Not Displayed in Table Maintenance
    [Documentation]    This keyword is used to get funding desk description from table maintenance using cluster from json file.
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sCluster}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Funding Desk
    ${Val_FundingDesk}    Run Keyword And Return Status    mx LoanIQ select    ${LIQ_BrowseFundingDesk_Tree}    ${sCluster}
    Run Keyword If    ${Val_FundingDesk}==False    Log    Correct!!!!! Funding Desk is not displayed.
    ...    ELSE    Log    Funding Desk is displayed.    level=ERROR    
    mx LoanIQ click    ${LIQ_BrowseFundingDesk_Exit_Button}
    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}

Get Funding Desk Details from Table Maintenance Invalid
    [Documentation]    This keyword is used to get funding desk description from table maintenance using cluster from json file.
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sCluster_JSON}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}    
    Search in Table Maintenance    Funding Desk
    Mx LoanIQ Set    ${LIQ_BrowseFundingDesk_ShowALL_RadioBtn}    ON  
    ${FundingDesk_Desc}    Wait Until Keyword Succeeds    3    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseFundingDesk_Tree}    ${sCluster_JSON}%Description%FundingDesk_Desc
    ${FundingDesk_Currency}    Wait Until Keyword Succeeds    3    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseFundingDesk_Tree}    ${sCluster_JSON}%Currency%FundingDesk_Currency
    ${FundingDesk_Stat}    Wait Until Keyword Succeeds    3    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseFundingDesk_Tree}    ${sCluster_JSON}%%FundingDesk_Stat
    
    Run Keyword If    '${FundingDesk_Stat}'=='Y'    Log    FUNDING DESK Status of ${sCluster_JSON} is ACTIVE.
    ...    ELSE IF    '${FundingDesk_Stat}'=='N'    Log    FUNDING DESK Status of ${sCluster_JSON} is INACTIVE.    level=ERROR
    ...    ELSE IF    '${FundingDesk_Stat}'==''    Log    FUNDING DESK Status of ${sCluster_JSON} is INVALID.    level=ERROR           
    
    mx LoanIQ click    ${LIQ_BrowseFundingDesk_Exit_Button}
    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}
    [Return]    ${FundingDesk_Desc}    ${FundingDesk_Currency}    ${FundingDesk_Stat}

Get Base Rate Description from Table Maintenance
    [Documentation]    This keyword used to get the currency description from table maintenance using the currency code from json file.
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sBaseRateCode}
    Search in Table Maintenance    Base Rate
    Mx LoanIQ Set    ${LIQ_BrowseBaseRate_ShowAll_RadioBtn}    ON  
    mx LoanIQ enter    ${LIQ_BrowseBaseRate_Search_Field}    ${sBaseRateCode}      
    ${BaseRate_Description}    Wait Until Keyword Succeeds    3    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseBaseRate_Tree}    ${sBaseRateCode}%Description%BaseRate_Description
    ${RateCode_Status}         Wait Until Keyword Succeeds    3    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseBaseRate_Tree}    ${sBaseRateCode}%""%RateCode_Status
    Run Keyword If    '${BaseRate_Description}'=='' and '${RateCode_Status}'==''    Run Keyword And Continue On Failure    Fail    Base Rate Code Entered is not on the list.
    ${Status_Name}=    Run Keyword If    '${RateCode_Status}'=='Y'    Set Variable   Active
    ...    ELSE IF    '${RateCode_Status}'=='N'    Set Variable   Inactive       
    Log    Base Rate Code ${sBaseRateCode} is ${Status_Name}.
    mx LoanIQ click    ${LIQ_BrowseBaseRate_Exit_Btn}
    [Return]     ${BaseRate_Description}    ${Status_Name}
    
Validate Currency Pairs Invalid Data
    [Documentation]    This keyword is used to validate currency pairs is existing in table maintenance.
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sToCurrency_Val}    ${sFromCurrency_Val}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Currency Pairs
    mx LoanIQ activate window    ${LIQ_TableMaintenance_CurrencyPairs_Window}
    ${Denominator_Value}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseCurrencyPair_Tree}    ${sFromCurrency_Val}%Denominator%Denominator_Value      
    
    ${FromCurrency_Status}    Run Keyword And Return Status    Should Be Equal As Strings    ${sFromCurrency_Val}    ${Denominator_Value}
    
    Run Keyword If    ${FromCurrency_Status}==True    Log    from currency value on the payload is a valid value                
    ...    ELSE    Log    from currency provided on the payload is an invalid value    level=ERROR
    
    ${Numerator_Value}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseCurrencyPair_Tree}    ${sToCurrency_Val}%Numerator%Numerator_Value      
    ${ToCurrency_Status}    Run Keyword And Return Status    Should Be Equal As Strings    ${sToCurrency_Val}    ${Numerator_Value}
    
    Run Keyword If    ${ToCurrency_Status}==True    Log    to currency value on the payload is a valid value                
    ...    ELSE    Log    to currency provided on the payload is an invalid value    level=ERROR
   
    ${CurrencyPairs_Status}    Set Variable If    ${ToCurrency_Status}==True and ${FromCurrency_Status}==True    True    False     
    
    Run Keyword If    ${CurrencyPairs_Status}==True    Log    Currency Pairs are valid values.
    ...    ELSE    Log    Currency Pairs provided on the payload are invalid values    level=ERROR    
    
    mx LoanIQ activate window    ${LIQ_TableMaintenance_CurrencyPairs_Window}
    mx LoanIQ click    ${LIQ_BrowseCurrencyPairs_Exit_Button}  
    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}
    [Return]    ${CurrencyPairs_Status}

Validate Rate Code in Funding Rates Updates
    [Documentation]    This keyword is used to validate Rate Code Description value in Funding Rates Updates Window
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${eLocator}    VerificationData="Yes"
    ${Actual_RateCode}    Run Keyword If    '${Status}'=='True'    Mx LoanIQ Get Data    ${eLocator}    input=Actual_RateCode
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Rate Code Description is incorrect. Expected is  ${sExpectedValue}.  
    ${Validate_RateCode}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_RateCode}
    Run Keyword If    '${Validate_RateCode}'=='True'    Log    Rate Code Description is correct: ${Actual_RateCode}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Rate Code Description is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_RateCode}.
    
Validate Funding Desk in Funding Rates Updates
    [Documentation]    This keyword is used to validate Funding Desk value in Funding Rates Updates Window
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${eLocator}    VerificationData="Yes"
    ${Actual_Funding_Desk}    Run Keyword If    '${Status}'=='True'    Mx LoanIQ Get Data    ${eLocator}    input=Actual_Funding_Desk
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Funding Desk is incorrect. Expected is  ${sExpectedValue}.  
    ${Validate_Funding_Desk}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_Funding_Desk}
    Run Keyword If    '${Validate_Funding_Desk}'=='True'    Log    Funding Desk is correct: ${Actual_Funding_Desk}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Funding Desk is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_Funding_Desk}.

Validate Currency in Funding Rates Updates
    [Documentation]    This keyword is used to validate Currency Description value in Funding Rates Updates Window
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${eLocator}    VerificationData="Yes"
    ${Actual_Currency}    Run Keyword If    '${Status}'=='True'    Mx LoanIQ Get Data    ${eLocator}    input=Actual_Currency
    ...    ELSE    Run Keyword And Continue On Failure    Log    Currency is incorrect. Expected value: ${sExpectedValue}.
    ${Validate_Currency}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_Currency}
    Run Keyword If    '${Validate_Currency}'=='True'    Log    Currency is correct: ${Actual_Currency}
    ...    ELSE    Run Keyword And Continue On Failure    Log    Currency is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_Currency}.

Validate Repricing Frequency in Funding Rates Updates
    [Documentation]    This keyword is used to compare expected and actual Repricing Frequency
    ...    e.g. Validate  Repricing Frequency(N Months/Years)    locator    expected_value
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${eLocator}    VerificationData="Yes"
    ${Actual_RepFreq}    Run Keyword If    '${Status}'=='True'    Run Keyword And Continue On Failure    Mx LoanIQ Get Data     ${eLocator}    input=Actual_RepFreq
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Repricing Frequency is incorrect. Expected is  ${sExpectedValue}.    
    ${Validate_RepricingFreq}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_RepFreq}
    Run Keyword If    '${Validate_RepricingFreq}'=='True'    Log    Repricing Frequency is correct: ${Actual_RepFreq}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Repricing Frequency is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_RepFreq}. 
    
Validate Base Rate in Funding Rates Updates
    [Documentation]    This keyword is used to compare expected and actual Base Rate
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${eLocator}    VerificationData="Yes"
    ${Actual_BaseRate}    Run Keyword If    '${Status}'=='True'    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${eLocator}    input=Actual_BaseRate    
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Rate is incorrect. Expected value: ${sExpectedValue}       
    ${Validate_BaseRate}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_BaseRate}       
    Run Keyword If    '${Validate_BaseRate}'=='True'    Log    Rate is correct: ${Actual_BaseRate}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Rate is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_BaseRate}.

Validate Base Rate Effective Date in Funding Rates Updates
    [Documentation]    This keyword is used to compare expected and actual Base Rate Effective Date
    ...    e.g. Validate effective date    locator    expected_value
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    ${Status}    Run Keyword And Return Status     Mx LoanIQ Verify Object Exist    ${eLocator}    VerificationData="Yes"
    ${Actual_EffectiveDate}    Run Keyword If    '${Status}'=='True'   Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${eLocator}    input=Actual_EffectiveDate
    ...    ELSE    Run Keyword And Expect Error    Log     Effective Date is not equal. Expected date is: ${sExpectedValue}
    ${Validate_EffectiveDate}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_EffectiveDate}      
    Run Keyword If    '${Validate_EffectiveDate}'=='True'    Log    Effective Date is correct: ${Actual_EffectiveDate}
    ...    ELSE   Run Keyword And Continue On Failure    Fail    Effective Date is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_EffectiveDate}.

Get Option Name from Option Name and Base Rate Association
    [Documentation]    This keyword is used to get Option Name from Option Name and Base Rate Association using Base Rate Code
    ...    @author: clanding
    ...    @update: clanding    20MAR2019    - added Wait Until Keyword Succeeds
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: cfrancis    12SEP2019    - added selecting of all data including inactive
    [Arguments]    ${sBaseRateCode_From_JSON}
    
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Option Name And Base Rate Association
    Mx LoanIQ Activate Window    ${LIQ_OptionNameBaseRateAssoc_Window}
    Mx LoanIQ Set    ${LIQ_OptionNameBaseRateAssoc_ShowAll_RadioBtn}    ON
    ${BaseRateName}    Wait Until Keyword Succeeds    5x    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OptionNameBaseRateAssoc_Tree}    ${sBaseRateCode_From_JSON}%Base Rate%BaseRateName
    ${BaseRate_Length}    Get Length    ${BaseRateName}
    Run Keyword If    ${BaseRate_Length}>1     Log    Correct!! Base Rate code ${sBaseRateCode_From_JSON} is existing.    
    ...    ELSE    Fatal Error    Incorrect!! Base Rate code ${sBaseRateCode_From_JSON} is NOT existing.    
    ${OptionName}    Wait Until Keyword Succeeds    5x    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_OptionNameBaseRateAssoc_Tree}    ${sBaseRateCode_From_JSON}%Option Name%OptionName
    ${optionname_length}    Get Length    ${OptionName}
    Run Keyword If    ${optionname_length}>1     Log    Correct!! Option Name ${sBaseRateCode_From_JSON} is existing.    
    ...    ELSE    Fatal Error    Incorrect!! Option Name ${sBaseRateCode_From_JSON} is NOT existing.    
    Log    ${OptionName}\t${BaseRateName}
    Run Keyword And Continue On Failure    Mx LoanIQ DoubleClick    ${LIQ_OptionNameBaseRateAssoc_Tree}    ${OptionName}\t${BaseRateName}    15            
    mx LoanIQ activate window    ${LIQ_OptionNameBaseRateAssocUpd_Window}
    ${OptionNameDesc}    Mx LoanIQ Get Data    ${LIQ_OptionNameBaseRateAssocUpd_OptionName_JavaList}    input=value%OptionNameDesc
    mx LoanIQ click    ${LIQ_OptionNameBaseRateAssocUpd_Cancel_Button}
    mx LoanIQ click    ${LIQ_OptionNameBaseRateAssoc_Exit_Button}    
    [Return]    ${OptionNameDesc}    ${OptionName}

Add Option Name and Repricing Frequency
    [Documentation]    This keyword is used add Option Name and Repricing Frequency in Option Name And Base Rate Frequency Association table
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sBaseRateCode_From_JSON}    ${sRepricingFreq_From_JSON}    ${OptionNameDesc}    ${OptionName}
    
    ${RepricingFreq_Num}    Strip String    ${sRepricingFreq_From_JSON}    mode=right    characters=D
    ${D}    Run Keyword And Return Status    Should Contain    ${sRepricingFreq_From_JSON}    D
    ${M}    Run Keyword And Return Status    Should Contain    ${sRepricingFreq_From_JSON}    M
    ${Y}    Run Keyword And Return Status    Should Contain    ${sRepricingFreq_From_JSON}    Y
    ${RepricingFreq_Code}    Run Keyword If    ${D}==True    Set Variable    Days
    ...    ELSE IF    ${M}==True    Set Variable    Months
    ...    ELSE IF    ${Y}==True    Set Variable    Years
    ${RepricingFreq_Num}    Run Keyword If    ${D}==True    Strip String    ${sRepricingFreq_From_JSON}    mode=right    characters=D
    ...    ELSE IF    ${M}==True    Strip String    ${sRepricingFreq_From_JSON}    mode=right    characters=M
    ...    ELSE IF    ${Y}==True    Strip String    ${sRepricingFreq_From_JSON}    mode=right    characters=Y 
    ${RepricingFreq}    Catenate    ${RepricingFreq_Num}    ${RepricingFreq_Code}
    
    Search in Table Maintenance    Option Name And Base Rate Frequency Association
    mx LoanIQ activate window    ${LIQ_OptionNameBaseRateFreqAssoc_Window}
    Mx LoanIQ Set    ${LIQ_OptionNameBaseRateAssoc_ShowAll_RadioBtn}    ON
    mx LoanIQ click    ${LIQ_OptionNameBaseRateAssoc_Add_Button}
    mx LoanIQ activate window    ${LIQ_OptionNameBaseRateAssocInsert_Window}
    Run Keyword And Continue On Failure    mx LoanIQ select list    ${LIQ_OptionNameBaseRateAssocInsert_OptionName_JavaList}    ${OptionNameDesc}    
    Run Keyword And Continue On Failure    mx LoanIQ select list    ${LIQ_OptionNameBaseRateAssocInsert_BaseRate_JavaList}    ${RepricingFreq}    
    mx LoanIQ click    ${LIQ_OptionNameBaseRateAssocInsert_OK_Button}
    
    ${Error_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Error_MessageBox}    VerificationData="Yes"
    ${Err_Msg}    Set Variable    Error: Option Name And Base Rate Frequency Association needs to be unique on Option Name and Base Rate Frequency. This combination entered already exists.            
    Run Keyword If    ${Error_Exist}==True    Run Keywords    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    AND    mx LoanIQ click    ${LIQ_OptionNameBaseRateAssocInsert_Cancel_Button}
       
    Run Keyword If    ${Error_Exist}==False    Run Keywords    mx LoanIQ enter    ${LIQ_OptionalComment_User_Field}    Test Automation for API
    ...    AND    mx LoanIQ click    ${LIQ_OptionalComment_OK_Button}
    
    mx LoanIQ click    ${LIQ_OptionNameBaseRateAssoc_Exit_Button}      
    Mx LoanIQ DoubleClick    ${LIQ_TableMaintenance_Tables_JavaTree}    Option Name And Base Rate Frequency Association
    mx LoanIQ activate window    ${LIQ_OptionNameBaseRateFreqAssoc_Window}
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_OptionNameBaseRateFreqAssoc_Tree}    ${OptionName}\t${sRepricingFreq_From_JSON}
    ${OptionName_Exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_OptionNameBaseRateFreqAssoc_Tree}    ${OptionName}\t${sRepricingFreq_From_JSON}
    Run Keyword If    ${OptionName_Exist}==True    Log    Option Name '${OptionName}' is ADDED.
    ...    ELSE    Log    Option Name '${OptionName}' is NOT ADDED.
    mx LoanIQ activate window    ${LIQ_OptionNameBaseRateFreqAssoc_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ DoubleClick    ${LIQ_OptionNameBaseRateFreqAssoc_Tree}    ${OptionName}\t${sRepricingFreq_From_JSON}   
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${OptionNameDesc}    ${LIQ_OptionNameBaseRateAssocUpdate_OptionName_JavaList}
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${RepricingFreq}    ${LIQ_OptionNameBaseRateAssocUpdate_BaseRateFreq_JavaList_JavaList}
    
    Close All Windows on LIQ

Get Single Description from Table Maintanance
    [Documentation]    This keyword is used to get Description of any input from Table Maintenance.
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: jdelacru    25MAR2019    - commented clicking Show All radio button to avoid selection incorrect country
    [Arguments]    ${sInputText}    ${eLIQ_Window}    ${eLIQ_Tree}    ${eLIQ_ShowALLButton}    ${eLIQ_ExitButton}
    
    mx LoanIQ activate window    ${eLIQ_Window}
    # Mx LoanIQ Set    ${eLIQ_ShowALLButton}    ON
    ${Desc}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${eLIQ_Tree}    ${sInputText}%Description%Desc
    mx LoanIQ click    ${eLIQ_ExitButton}
    [Return]    ${Desc}

Get Code from Table Maintenance for Single Value
    [Documentation]    This keyword is used to get corresponding Code from Table Maintenance
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sInputDescription}    ${eLIQ_Window}    ${eLIQ_Tree}    ${eLIQ_ShowALLButton}    ${eLIQ_ExitButton}
    
    mx LoanIQ activate window    ${eLIQ_Window}
    Mx LoanIQ Set    ${eLIQ_ShowALLButton}    ON  
    ${LIQ_Code}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${eLIQ_Tree}    ${sInputDescription}%Code%LIQ_Code
    mx LoanIQ click    ${eLIQ_ExitButton}
    [Return]    ${LIQ_Code}
    
Get Multiple Description from Table Maintenance
    [Documentation]    This keyword is used to get Description of a single and list input from Table Maintenance.
    ...    @author: clanding
    [Arguments]    ${excel_input_list}    ${excel_input_singleval}    ${eLIQ_Window}    ${eLIQ_Tree}    ${eLIQ_ShowALLButton}    
    ...    ${eLIQ_ExitButton}    ${INDEX}
    
    ${single_list}    Split String    ${excel_input_singleval}    ,
    ${input_singleval}    Get From List    ${single_list}    ${INDEX}
    ${additional_list}    Split String    ${excel_input_list}    ,
    ${additional_listVal}    Get From List    ${additional_list}    ${INDEX}
    ${multipleval}    Run Keyword And Return Status    Should Contain    ${additional_listVal}    /        
    ${count}    Run Keyword If    ${multipleval}==True    Get Length    ${additional_list}
    ...    ELSE    Set Variable    1
    ${input_list}    Create List
    ${INDEX_0}    Set Variable    0
    :FOR    ${INDEX_0}    IN RANGE    ${count}
    \    Exit For Loop If    '${INDEX_0}'=='${count}'
    \    ${list}    Split String    ${additional_listVal}    /
    \    ${val}    Get From List    ${list}    ${INDEX_0}
    \    Append To List    ${input_list}    ${val}
    
    mx LoanIQ activate window    ${eLIQ_Window}
    Mx LoanIQ Set    ${eLIQ_ShowALLButton}    ON  

    ${count}    Get Length    ${input_list}
    ${INDEX}    Set Variable    0
    ${LIQ_DescList}    Create List    
    :FOR    ${INDEX}    IN RANGE    ${count}
    \    ${list_val}    Get From List    ${input_list}    ${INDEX}
    \    ${List_Desc}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${eLIQ_Tree}    
         ...    ${list_val}%Description%List_Desc
    \    Append To List    ${LIQ_DescList}    ${List_Desc}   
    \    Exit For Loop If    '${INDEX}'=='${count}'
    
    ${SingleVal_Desc}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${eLIQ_Tree}    ${input_singleval}%Description%SingleVal_Desc    30
    mx LoanIQ click    ${eLIQ_ExitButton}
    
    [Return]    ${LIQ_DescList}    ${SingleVal_Desc}
    
Get Funding Desk Status from Table Maintenance
    [Documentation]    This keyword is used to get funding desk status from table maintenance using funding desk value.
    ...    @author: clanding    13MAR2019    - initial create
    [Arguments]    ${sFundingDesk}
    
    Wait Until Keyword Succeeds    3    3s    mx LoanIQ activate window    ${LIQ_Window}    
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}    
    Search in Table Maintenance    Funding Desk
    Mx LoanIQ Set    ${LIQ_BrowseFundingDesk_ShowALL_RadioBtn}    ON
    mx LoanIQ activate window    ${LIQ_BrowseFundingRates_Window}
    ${FundingDesk_StatusVal}    Wait Until Keyword Succeeds    5x    3s    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseFundingDesk_Tree}    ${sFundingDesk}%%FundingDesk_StatusVal
    Run Keyword If    '${FundingDesk_StatusVal}'=='Y'    Log    FUNDING DESK Status of ${sFundingDesk} is ACTIVE.
    ...    ELSE IF    '${FundingDesk_StatusVal}'=='N'    Log    FUNDING DESK Status of ${sFundingDesk} is INACTIVE.
    ...    ELSE    Log    FUNDING DESK Status of ${sFundingDesk} is UNDEFINE.
    ${FundingDesk_Status}    Run Keyword If    '${FundingDesk_StatusVal}'=='Y'    Set Variable    A
    ...    ELSE IF    '${FundingDesk_StatusVal}'=='N'    Set Variable    I
    ...    ELSE    Set Variable    U
    mx LoanIQ click    ${LIQ_BrowseFundingDesk_Exit_Button}
    mx LoanIQ click    ${LIQ_TableMaintenance_Exit_Button}
    [Return]    ${FundingDesk_Status}

Open Holiday Calendars Table in Table Maintenance
    [Documentation]    This keyword is used to open the Holiday Calendars table in Table Maintenance
    ...    @author: ehugo    10JUN2020    - initial create
    
    Refresh Tables in LIQ
    Wait Until Keyword Succeeds    3    3s    mx LoanIQ activate window    ${LIQ_Window}    
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Holiday Calendars
    mx LoanIQ activate window    ${LIQ_BrowseHolidayCalendar_Window}

Verify Calendar ID if Existing in Previously Opened Holiday Calendars Table
    [Documentation]    This keyword is used to check if calendar id is existing in previously opened Browse from Holiday Calendars screen and status is Active.
    ...    @author: ehugo    10JUN2020    - initial create
    ...    @update: ehugo    18JUN2020    - updated screenshot location
    [Arguments]    ${sCalendarID}    ${sStatus}

    mx LoanIQ activate window    ${LIQ_BrowseHolidayCalendar_Window}
    ${CalendarID_Exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BrowseHolidayCalendar_Tables_JavaTree}    ${sCalendarID}
    Run Keyword If    ${CalendarID_Exist}==${False}    Run Keywords    Log    Calendar ID '${sCalendarID}' is NOT existing in Holiday Calendars table.    level=WARN
    ...    AND    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Calendar_ID
    ...    AND    Return From Keyword

    Return From Keyword If    ${CalendarID_Exist}!=${True}
    Log    Calendar ID '${sCalendarID}' is existing in Holiday Calendars table.
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Calendar_ID
    Mx LoanIQ DoubleClick    ${LIQ_BrowseHolidayCalendar_Tables_JavaTree}    ${sCalendarID}
    mx LoanIQ activate window    ${LIQ_HolidayCalendarUpdate_Window}    
    ${CalendarID_UI}    Mx LoanIQ Get Data    ${LIQ_HolidayCalendarUpdate_Code_TextBox}    value%CalendarID_UI
    Run Keyword And Continue On Failure    Should Be Equal    ${sCalendarID}    ${CalendarID_UI}
    ${CalendarID_Exist}    Run Keyword And Return Status    Should Be Equal    ${sCalendarID}    ${CalendarID_UI}    
    Run Keyword If    ${CalendarID_Exist}==${True}    Log    Calendar ID '${sCalendarID}' is existing in Holiday Calendars table.
    ...    ELSE    Log    Calendar ID '${sCalendarID}' is NOT existing in Holiday Calendars table.    level=WARN
    
    Run Keyword If    '${sStatus}'=='ON'    Validate if Element is Checked    ${LIQ_HolidayCalendarUpdate_Status_Checkbox}    Active
    ...    ELSE IF    '${sStatus}'=='OFF'    Validate if Element is Unchecked    ${LIQ_HolidayCalendarUpdate_Status_Checkbox}    Active
    
    mx LoanIQ click    ${LIQ_HolidayCalendarUpdate_Cancel_Button}

Verify Calendar ID if Existing in Holiday Calendars Table
    [Documentation]    This keyword is used to check if calendar id is existing in Browse from Holiday Calendars screen and status is Active.
    ...    @author: clanding    18JUN2019    - initial create
    [Arguments]    ${sCalendarID}    ${sStatus}
    
    Refresh Tables in LIQ
    Wait Until Keyword Succeeds    3    3s    mx LoanIQ activate window    ${LIQ_Window}    
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Holiday Calendars
    mx LoanIQ activate window    ${LIQ_BrowseHolidayCalendar_Window}
    ${CalendarID_Exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BrowseHolidayCalendar_Tables_JavaTree}    ${sCalendarID}
    Run Keyword If    ${CalendarID_Exist}==${True}    Run Keywords    Log    Calendar ID '${sCalendarID}' is existing in Holiday Calendars table.
    ...    AND    Take Screenshot    Calendar_ID
    ...    AND    Mx LoanIQ DoubleClick    ${LIQ_BrowseHolidayCalendar_Tables_JavaTree}    ${sCalendarID}
    ...    AND    Verify Calendar ID and Status in Holiday Calendar Update Window    ${sCalendarID}    ${sStatus}
    ...    ELSE   Run Keywords    Log    Calendar ID '${sCalendarID}' is NOT existing in Holiday Calendars table.    level=WARN
    ...    AND    Take Screenshot    Calendar_ID
    ...    AND    Close All Windows on LIQ

Verify Calendar ID and Status in Holiday Calendar Update Window
    [Documentation]    This keyword is used to validate if Calendar ID matches the input Calendar ID and Status is Active.
    ...    @author: clanding    19JUN2019    - initial create
    ...    @update: clanding    24JUL2019    - changed keyword for verifying checkbox state
    [Arguments]    ${sCalendarID}    ${sStatus}
    
    mx LoanIQ activate window    ${LIQ_HolidayCalendarUpdate_Window}    
    ${CalendarID_UI}    Mx LoanIQ Get Data    ${LIQ_HolidayCalendarUpdate_Code_TextBox}    value%CalendarID_UI
    Run Keyword And Continue On Failure    Should Be Equal    ${sCalendarID}    ${CalendarID_UI}
    ${CalendarID_Exist}    Run Keyword And Return Status    Should Be Equal    ${sCalendarID}    ${CalendarID_UI}    
    Run Keyword If    ${CalendarID_Exist}==${True}    Log    Calendar ID '${sCalendarID}' is existing in Holiday Calendars table.
    ...    ELSE    Log    Calendar ID '${sCalendarID}' is NOT existing in Holiday Calendars table.    level=WARN
    
    Run Keyword If    '${sStatus}'=='ON'    Validate if Element is Checked    ${LIQ_HolidayCalendarUpdate_Status_Checkbox}    Active
    ...    ELSE IF    '${sStatus}'=='OFF'    Validate if Element is Unchecked    ${LIQ_HolidayCalendarUpdate_Status_Checkbox}    Active
    
    mx LoanIQ click    ${LIQ_HolidayCalendarUpdate_Cancel_Button}
    Close All Windows on LIQ

Get Base Rate Frequency Status from Table Maintenance
    [Documentation]    This keyword is used to get Base Rate Code Frequency Status from Base Rate Frequency Table
    ...    @author: jdelacru    24JUL2019    - initial create
    ...    @update: jdelacru    05AUG2019    - created a separate keyword in returning Base Rate Frequency Status
    [Arguments]    ${sRepFreq_From_JSON}
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Base Rate Frequency
    mx LoanIQ activate window    ${LIQ_BaseRateFrequency_Window}
    Mx LoanIQ Set    ${LIQ_BaseRateFrequency_ShowAll_RadioBtn}    ON
    Run Keyword and Continue On Failure    Mx LoanIQ Select String    ${LIQ_BaseRateFrequency_Tree}    ${sRepFreq_From_JSON}
    ${Freq_IsPresent}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BaseRateFrequency_Tree}    ${sRepFreq_From_JSON}
    ${BaseRateFrequency_Status}    Run Keyword If    ${Freq_IsPresent}==${True}    Return Base Rate Frequency Status    ${sRepFreq_From_JSON}
    ...    ELSE    Log    Incorrect!! Base Rate Frequency ${sRepFreq_From_JSON} is NOT existing.    level=ERROR
    [Return]    ${BaseRateFrequency_Status}
    
Return Base Rate Frequency Status
    [Documentation]    This keyword return the status of the checkbox of Base Rate Frequency if checked or unchecked.
    ...    @author: jdelacru    05AUG2019    - initial create
    [Arguments]    ${sRepFreq_From_JSON}
    mx LoanIQ activate window    ${LIQ_BaseRateFrequency_Window}
    Mx LoanIQ DoubleClick    ${LIQ_BaseRateFrequency_Tree}    ${sRepFreq_From_JSON}     
    mx LoanIQ activate window    ${LIQ_BaseRateFrequencyUpd_Window}
    ${BaseRateFrequency_Status}    Get LIQ Checkbox Status    ${LIQ_BaseRateFrequencyUpd_Active_Checkbox}
    mx LoanIQ click    ${LIQ_BaseRateFrequencyUpd_Cancel_Button}
    mx LoanIQ close window    ${LIQ_BaseRateFrequency_Window}
    mx LoanIQ close window    ${LIQ_TableMaintenance_Window}    
    Close All Windows on LIQ
    [Return]    ${BaseRateFrequency_Status}

Add New Calendar ID
    [Documentation]    This keyword is used to add new Calendar ID into Loan IQ.
    ...    @author: clanding    06AUG2019    - initial create
    ...    @update: jloretiz    19AUG2019    - add return for row count
    [Arguments]    ${sCalendarID}    ${sDescription}    ${sUserComment}    ${sSatBusDay}=N    ${sSunBusDay}=N    ${sFriBusDay}=N
    
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    Holiday Calendars
    mx LoanIQ activate window    ${LIQ_BrowseHolidayCalendar_Window}
    
    ### Verify if Calendar ID is not yet existing ###
    ${sQuery}    Catenate    SELECT ${GB2_IND_ACTIVE} from ${LIQ7474_USER}.${TLS_FAM_GLOBAL2_TABLE} WHERE ${GB2_TID_TABLE_ID} = 'HCL'
    ...    AND ${GB2_CDE_CODE} = '${sCalendarID}'
    ${Row_Count}    Connect to LIQ Database and Return Row Count    ${sQuery}
    Run Keyword If    ${Row_Count}==0    Log    Calendar ID '${sCalendarID}' is NOT yet existing in Loan IQ. Proceed on adding.
    ...    ELSE    Fail    Calendar ID '${sCalendarID}' is already existing in Loan IQ. Choose another Calendar ID.
    
    ### Add new Calendar ID ###    
    mx LoanIQ click    ${LIQ_BrowseHolidayCalendar_Add_Button}
    mx LoanIQ enter    ${LIQ_HolidayCalendar_Insert_Code}    ${sCalendarID}
    mx LoanIQ enter    ${LIQ_HolidayCalendar_Insert_Description}    ${sDescription}
    Run Keyword If    '${sSatBusDay}'=='Y'    Mx LoanIQ Set    ${LIQ_HolidayCalendar_Insert_SaturdayOption}    ON
    Run Keyword If    '${sSunBusDay}'=='Y'    Mx LoanIQ Set    ${LIQ_HolidayCalendar_Insert_SundayOption}    ON
    Run Keyword If    '${sFriBusDay}'=='Y'    Mx LoanIQ Set    ${LIQ_HolidayCalendar_Insert_FridayOption}    ON
    mx LoanIQ click    ${LIQ_HolidayCalendar_Insert_Ok_Button}
    mx LoanIQ activate window    ${LIQ_HolidayCalendar_Option_User_Comment_Window}
    mx LoanIQ enter    ${LIQ_HolidayCalendar_Option_User_Comment_Text}    ${sUserComment}
    mx LoanIQ click    ${LIQ_HolidayCalendar_Option_User_Comment_Ok_Button}
    
    ### Verify if Calendar ID is successfully created ###
    mx LoanIQ activate window    ${LIQ_BrowseHolidayCalendar_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_BrowseHolidayCalendar_Tables_JavaTree}    ${sCalendarID}
    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BrowseHolidayCalendar_Tables_JavaTree}    ${sCalendarID}
    Take Screenshot    Calendar_ID
    Run Keyword If    ${IsSelected}==${True}    Log    Calendar ID '${sCalendarID}' is successfully created.
    ...    ELSE    Log    Calendar ID '${sCalendarID}' is NOT successfully created.    level=ERROR
    Close All Windows on LIQ
    [return]    ${Row_Count}


Get Funding Desk Code from Table Maintenance
    [Documentation]    This keyword is used to get funding desk code via Branch in Table Maintenance.
    ...    @author: rtarayao    16AUG2019    Initial Create
    [Arguments]    ${sBranchDesc}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}    
    Search in Table Maintenance    Branch
    mx LoanIQ activate window    ${LIQ_Branch_Window}    
    Mx LoanIQ Set    ${LIQ_Branch_ShowALL_RadioButton}    ON  
    ${FundingDeskCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Branch_Tree}    ${sBranchDesc}%Funding Desk%FundingDeskCode    
    Log    Funding Desk code for ${sBranchDesc} is ${FundingDeskCode}    
    mx LoanIQ click    ${LIQ_Branch_Exit_Button}
    [Return]    ${FundingDeskCode}
    
Get Expense Description from Table Maintenance
    [Documentation]    This keyword returns the expense code description from Table Maintenance.
    ...    @author: rtarayao    16AUG2019    Initial Create
    [Arguments]    ${sExpenseCode}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}    
    Search in Table Maintenance    Expense
    mx LoanIQ activate window    ${LIQ_Expense_Window}    
    Mx LoanIQ Set    ${LIQ_Expense_ShowAll_RadioButton}    ON  
    ${ExpenseCodeDesc}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Expense_JavaTree}    ${sExpenseCode}%Description%ExpenseCodeDesc   
    Log    Expense description is ${ExpenseCodeDesc}    
    mx LoanIQ click    ${LIQ_Expense_Exit_Button}
    [Return]    ${ExpenseCodeDesc}
    
Get Portfolio Code from Table Maintenance
    [Documentation]    This keyword returns the portfolio code description from Table Maintenance.
    ...    @author: rtarayao    16AUG2019    Initial Create
    [Arguments]    ${sPortfolioDesc}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}    
    Search in Table Maintenance    Portfolio
    mx LoanIQ activate window    ${LIQ_Portfolio_Window}    
    Mx LoanIQ Set    ${LIQ_Portfolio_ShowAll_RadioButton}    ON  
    ${PortfolioCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Portfolio_Tree}    ${sPortfolioDesc}%Code%PortfolioCode  
    Log    Portfolio code for ${sPortfolioDesc} is ${PortfolioCode}    
    mx LoanIQ click    ${LIQ_Portfolio_Exit_Button}
    [Return]    ${PortfolioCode}

Get Branch Code from Table Maintenance
    [Documentation]    This keyword returns the branch code description from Table Maintenance.
    ...    @author: rtarayao    16AUG2019    Initial Create
    [Arguments]    ${sBranchDesc}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}    
    Search in Table Maintenance    Branch
    mx LoanIQ activate window    ${LIQ_Branch_Window}    
    Mx LoanIQ Set    ${LIQ_Branch_ShowALL_RadioButton}    ON  
    ${BranchCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Branch_Tree}    ${sBranchDesc}%Code%BranchCode  
    Log    Portfolio code for ${sBranchDesc} is ${BranchCode}    
    mx LoanIQ click    ${LIQ_Branch_Exit_Button}
    [Return]    ${BranchCode}

Check the Short Name Code in GL Short Name Window
    [Documentation]    This keyword is used to check the Short Name Code in LIQ Screen - G/L Short Name Window
    ...    @author: mgaling    23Aug2019    Initial Create
    [Arguments]    ${sCode}    ${sShortName_Desc}        
    
    mx LoanIQ activate window    ${LIQ_BrowseGLShortName_Window}
    mx LoanIQ enter    ${LIQ_BrowseGLShortName_Showall_RadioButton}    ON           
    
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_BrowseGLShortName_JavaTree}    ${sCode}\t${sShortName_Desc}
    ${IsSelected}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_BrowseGLShortName_JavaTree}    ${sCode}\t${sShortName_Desc}
    Run Keyword If    ${IsSelected}==${True}    Run Keywords    Mx Native Type    {ENTER}    
    ...    AND    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    ...    AND    mx LoanIQ activate window    ${LIQ_BrowseGLShortName_Update_Window}
    ...    AND    Take Screenshot    ${sCode}
    ...    ELSE    Log    '${sCode}' is not available in the table.    level=ERROR
    
    ${UICode}    Run Keyword If    ${IsSelected}==${True}    Mx LoanIQ Get Data    ${LIQ_BrowseGLShortName_Update_Code_Field}    text
    Should Be Equal    ${sCode}    ${UICode}    
    

Check the Natural Balance value in GL Short Name Update Window
    [Documentation]    This keyword is used to check the Natural Balance value in G/L Short Name Update Window
    ...    @author: mgaling    23Aug2019    Initial Create
    [Arguments]    ${sNaturalBalance}    
    
    mx LoanIQ activate window    ${LIQ_BrowseGLShortName_Update_Window}
    
    ${NBal_IsExisting}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_BrowseGLShortName_Update_NaturalBalance_List}    VerificationData="Yes"
    Take Screenshot    Natural Balance Field Validation        
    ${sUINaturalBalance}    Run Keyword If    ${NBal_IsExisting}==${True}    Mx LoanIQ Get Data    ${LIQ_BrowseGLShortName_Update_NaturalBalance_List}    text
    Run Keyword If    ${NBal_IsExisting}==${False}    Run Keyword And Continue On Failure    Should Be Empty    ${sNaturalBalance}
    ${IsEmpty}    Run Keyword If    ${NBal_IsExisting}==${False}    Run Keyword And Return Status    Should Be Empty    ${sNaturalBalance}
    Run Keyword If    ${IsEmpty}==${True}    Log    Extract data is empty.
    ...    ELSE IF    '${IsEmpty}'=='None'    Log    Keyword not applicable.
    ...    ELSE    Log    Extract is NOT empty: '${sNaturalBalance}'    level=ERROR    
    
    ${sUINaturalBalance_UppCase}    Run Keyword If    '${sNaturalBalance}'!='${EMPTY}'    Convert To Uppercase    ${sUINaturalBalance}
    ...    ELSE    Set Variable    ${EMPTY}
    Run Keyword And Continue On Failure    Should Be Equal    ${sUINaturalBalance_UppCase}    ${sNaturalBalance}
    ${IsEqual}    Run Keyword And Return Status    Should Be Equal    ${sUINaturalBalance_UppCase}    ${sNaturalBalance}
    Run Keyword If    ${IsEqual}==${True}    Log    Extract and Loan IQ values are matched! ${sUINaturalBalance_UppCase} = ${sNaturalBalance}
    ...    ELSE    Log    Extract and Loan IQ values are NOT matched! ${sUINaturalBalance_UppCase} != ${sNaturalBalance}    level=ERROR

    mx LoanIQ close window    ${LIQ_BrowseGLShortName_Update_Window}

Get Pricing Option Description from Table Maintenance
    [Documentation]    This keyword returns the expense code description from Table Maintenance.
    ...    @author: rtarayao    16AUG2019    Initial Create
    ...    @author: gerhabal    06SEP2019    updated argument from sPricingOptionCode to sExpenseCode     
    [Arguments]    ${sExpenseCode}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}    
    Search in Table Maintenance    Pricing Option Name
    mx LoanIQ activate window    ${LIQ_PricingOption_Window}    
    Mx LoanIQ Set    ${LIQ_PricingOption_ShowAll_RadioButton}    ON  
    ${PricingOptionDesc}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_PricingOption_Tree}    ${sExpenseCode}%Description%ExpenseCodeDesc   
    Log    Pricing Option description is ${PricingOptionDesc}    
    mx LoanIQ click    ${LIQ_PricingOption_Exit_Button}
    [Return]    ${PricingOptionDesc}
       
Validate the Processing Area Code in LIQ
    [Documentation]    This keyword is used to verify the available Processing Area Codes from CSV to LIQ Screen.
    ...    @author: mgaling    29Aug2019    Initial Create
    [Arguments]    ${aDistinctData_List}         
    
    ### Navigate to Processing Area Window ###
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Processing Area
    
    mx LoanIQ activate window    ${LIQ_BrowseProcessingArea_Window}
    
    ### Validates the Processing Area Codes ###
    
    ${count}    Get Length    ${aDistinctData_List}
    :FOR    ${INDEX}    IN RANGE    ${count}
    \    ${RowValue}    Set Variable    @{aDistinctData_List}[${INDEX}]
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_BrowseProcessingArea_JavaTree}    ${RowValue}
    \    Run Keyword If    ${status}==${True}    Run Keywords    Mx LoanIQ DoubleClick    ${LIQ_BrowseProcessingArea_JavaTree}    ${RowValue}
         ...    AND    mx LoanIQ activate window    ${LIQ_BrowseProcessingArea_Update_Window}
         ...    AND    Mx LoanIQ Verify Runtime Property    ${LIQ_BrowseProcessingArea_Update_Code_Field}    text%${RowValue}
         ...    AND    Take Screenshot    ${RowValue}        
         ...    AND    Log    ${RowValue} is available   
         ...    AND    mx LoanIQ click    ${LIQ_BrowseProcessingArea_Update_OK_Button}               
         ...    ELSE    Log    ${RowValue} is not Available    level=ERROR             
    
    Close All Windows on LIQ
    
Validate the Pricing Fee Type Code in LIQ
    [Documentation]    This keyword is used to verify the available Pricing Fee Type Codes from CSV to LIQ Screen.
    ...    @author: mgaling    30Aug2019    Initial Create
    [Arguments]    ${sRowValue}        
    
    Search in Table Maintenance    Pricing Fee Type
    mx LoanIQ activate window    ${LIQ_BrowsePricingFeeType_Window}
    
    ${Row_Desc}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowsePricingFeeType_JavaTree}    ${sRowValue}%Description%value    
    Mx LoanIQ Select String    ${LIQ_BrowsePricingFeeType_JavaTree}    ${sRowValue}\t${Row_Desc}
    Mx Native Type    {ENTER}
    
    mx LoanIQ activate window    ${LIQ_BrowsePricingFeeType_Update_Window}
    Mx LoanIQ Verify Runtime Property    ${LIQ_BrowsePricingFeeType_Update_Code_Field}    text%${sRowValue}
    Take Screenshot    ${sRowValue}        
    Log    ${sRowValue} is available   
    mx LoanIQ click    ${LIQ_BrowsePricingFeeType_Update_OK_Button}
    mx LoanIQ close window    ${LIQ_BrowsePricingFeeType_Window}    
    
Validate the Pricing Fee Category Code in LIQ
    [Documentation]    This keyword is used to verify the available Pricing Fee Category Codes from CSV to LIQ Screen.
    ...    @author: mgaling    30Aug2019    Initial Create
    [Arguments]    ${sRowValue}
    
    Search in Table Maintenance    Pricing Fee Category
    
    mx LoanIQ activate window    ${LIQ_BrowsePricingFeeCategory_Window}
    
    ${Row_Desc}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowsePricingFeeCategory_JavaTree}    ${sRowValue}%Description%value    
    Mx LoanIQ Select String    ${LIQ_BrowsePricingFeeCategory_JavaTree}    ${sRowValue}\t${Row_Desc}
    Mx Native Type    {ENTER} 
    
    mx LoanIQ activate window    ${LIQ_BrowsePricingFeeCategory_Update_Window}
    Mx LoanIQ Verify Runtime Property    ${LIQ_BrowsePricingFeeCategory_Update_Code_Field}    text%${sRowValue}
    Take Screenshot    ${sRowValue}        
    Log    ${sRowValue} is available   
    mx LoanIQ click    ${LIQ_BrowsePricingFeeCategory_Update_OK_Button}
    
    mx LoanIQ close window    ${LIQ_BrowsePricingFeeCategory_Window}    

Validate the Facility Type Code in LIQ
    [Documentation]    This keyword is used to verify the available Facility Type Category Codes from CSV to LIQ Screen.
    ...    @author: mgaling    02Sep2019    Initial Create
    [Arguments]    ${sRowValue}      
    
    mx LoanIQ activate window    ${LIQ_BrowseFacilityType_Window}
    
    ${Row_Desc}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseFacilityType_JavaTree}    ${sRowValue}%Description%value    
    Mx LoanIQ Select String    ${LIQ_BrowseFacilityType_JavaTree}    ${sRowValue}\t${Row_Desc}
    Mx Native Type    {ENTER} 
    
    mx LoanIQ activate window    ${LIQ_BrowseFacilityType_Update_Window}
    Mx LoanIQ Verify Runtime Property    ${LIQ_BrowseFacilityType_Update_Code_Field}    text%${sRowValue}
    Take Screenshot    ${sRowValue}        
    Log    ${sRowValue} is available   
    mx LoanIQ click    ${LIQ_BrowseFacilityType_Update_OK_Button}
      
Validate the Porfolio Codes in LIQ
    [Documentation]    This keyword validate the Portfolio Code from CSV in LIQ Portfolio Window
    ...    @author: mgaling    03SEP2020    - initial create
    ...    @update: mgaling    15OCT2020    - updated documentation and updated Mx Native Type    {ENTER} keyword into Mx Press Combination    KEY.ENTER
    ...                                     - added screenshot path
    [Arguments]    ${sRowValue}
    
    mx LoanIQ activate window    ${LIQ_Portfolio_Window}
    ${Row_Desc}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Portfolio_Tree}    ${sRowValue}%Description%value    
    Mx LoanIQ Select String    ${LIQ_Portfolio_Tree}    ${sRowValue}\t${Row_Desc}
    Mx Press Combination    KEY.ENTER 
    
    mx LoanIQ activate window    ${LIQ_BrowsePortfolio_Update_Window}
    Mx LoanIQ Verify Runtime Property    ${LIQ_BrowsePortfolio_Update_Code_Field}    text%${sRowValue}
    Log    ${sRowValue} is available
    Take Screenshot    ${screenshot_path}/Screenshots/DWE/${sRowValue}          
    mx LoanIQ close window    ${LIQ_BrowsePortfolio_Update_Window}    
    
    [Return]    ${Row_Desc}

Validate Code Tables in LIQ
    [Documentation]    This keyword validates that correct codes in Code Tables are displayed in LIQ
    ...    @author: ehugo    09Sep2019    Initial Create
    [Arguments]    ${sCurrentCode}
    
    Mx LoanIQ Select String    ${LIQ_BrowseCodeTables_JavaTree}    \t${sCurrent_Code.strip()}\t    Processtimeout=30
    Mx Native Type    {ENTER}
        
    ###Code Tables Update Window###
    mx LoanIQ activate window    ${LIQ_BrowseCodeTables_Update_Window}
    ${Code}    Mx LoanIQ Get Data    ${LIQ_BrowseCodeTables_Update_Code_Field}    Code    
    Log    Expected: ${sCurrent_Code.strip()}
    Log    Actual: ${Code}
    ${Verify_Equal}    Run Keyword And Return Status    Should Be Equal As Strings    ${sCurrent_Code.strip()}    ${Code.strip()}    
    Take Screenshot    Code_Table
    Run Keyword If    ${Verify_Equal}==False    Run Keyword And Continue On Failure    Fail    Incorrect Code value '${Code}' is displayed in LIQ.
    ...    ELSE    Log    Correct Code value '${Code}' is displayed in LIQ.
    
    Mx LoanIQ Close    ${LIQ_BrowseCodeTables_Update_Window}    

Get Expense Description in Table Maintenance
    [Documentation]    This keyword retrieves the Expense Description in Table Maintenance given the Expense Code
    ...    @author: ehugo    30Sep2019    Initial Create
    [Arguments]    ${sExpenseCode}
    
    Select Actions    [Actions];Table Maintenance
    Search in Table Maintenance    Expense
    
    mx LoanIQ activate window    ${LIQ_Expense_Window}
    Mx LoanIQ Select String    ${LIQ_Expense_JavaTree}    ${sExpenseCode}
    Mx Native Type    {ENTER}
    Run Keyword And Ignore Error    Mx LoanIQ Click Button On Window    .*Expense.*;Warning.*;Yes        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500        strProcessingObj="JavaWindow(\"title:=Processing.*\")"         WaitForProcessing=500
    
    mx LoanIQ activate window    ${LIQ_Expense_Update_Window}
    ${Description}    Mx LoanIQ Get Data    ${LIQ_Expense_Update_Description_Field}    Description  
    
    Close All Windows on LIQ
    
    [Return]    ${Description}

Get Processing Area Code from Table Maintenance
    [Documentation]    This keyword is used to get processing area code in the Table Maintenance.
    ...    @author: rtarayao    24SEP2019    - Initial Create
    [Arguments]    ${sProcessingAreaDesc}
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}    
    Search in Table Maintenance    Processing Area
    mx LoanIQ activate window    ${LIQ_Processing_Area_Window}    
    Mx LoanIQ Set    ${LIQ_Processing_Area_ShowAllRadioButton}    ON  
    ${ProcAreaCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Processing_Area_Tree}    ${sProcessingAreaDesc}%Code%ProcAreaCode    
    Log    The Processing Area code for ${sProcessingAreaDesc} is ${ProcAreaCode}    
    mx LoanIQ click    ${LIQ_Processing_Area_Exit_Button}
    [Return]    ${ProcAreaCode}

Set Automated Transactions in Table Maintenance
    [Documentation]    This keyword is used to add new Automated Transactions in Table Maintenance.
    ...    @author: jloretiz    28JUL2020    - initial Create
    [Arguments]    ${sProcessingArea}    ${sTransactionType}    ${sLeadDays}    ${sStatus}    ${sComment}

    ###Pre-processing of arguments###
    ${ProcessingArea}    Acquire Argument Value    ${sProcessingArea}
    ${TransactionType}    Acquire Argument Value    ${sTransactionType}
    ${LeadDays}    Acquire Argument Value    ${sLeadDays}
    ${Status}    Acquire Argument Value    ${sStatus}
    ${Comment}    Acquire Argument Value    ${sComment}

    ###Navigate to Automated Transactions###
    Mx LoanIQ Click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    ${AUTOMATED_TRANSACTIONS}

    ###Select Processing Area###
    Mx LoanIQ Activate Window    ${LIQ_AutomatedTransactions_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AutomatedTransactions_Dropdown}    ${ProcessingArea}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/BeforeAdding_TransactionType

    ###Add Transaction Type###
    Mx LoanIQ Click    ${LIQ_AutomatedTransactions_Add_Button}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AutomatedTransaction_TransactionType_Dropdown}    ${TransactionType}
    Mx LoanIQ Check Or Uncheck    ${LIQ_AutomatedTransaction_AutoGeneration_Checkbox}    ON
    Mx LoanIQ Enter    ${LIQ_AutomatedTransaction_LeadDays_TextField}    ${LeadDays}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AutomatedTransaction_GeneratedStatus_Dropdown}    ${Status}
    Mx LoanIQ Check Or Uncheck    ${LIQ_AutomatedTransaction_AutoRelease_Checkbox}    ON
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Adding_TransactionType
    Mx LoanIQ Click    ${LIQ_AutomatedTransaction_Ok_Button}
    Mx LoanIQ Click    ${LIQ_AutomatedTransactions_Ok_Button}

    ###Enter Optional Comment###
    Mx LoanIQ Activate Window    ${LIQ_EnterOptionalUserComment_Window}
    Mx LoanIQ Enter    ${LIQ_EnterOptionalUserComment_Field}    ${Comment}
    Mx LoanIQ Click    ${LIQ_EnterOptionalUserComment_OK_Button}

    ###Exit Table Maintenance###
    Mx LoanIQ Click    ${LIQ_TableMaintenance_Exit_Button}

Validate Transaction Type in Automated Transactions in Table Maintenance
    [Documentation]    This keyword is used to validate the newly added transaction type.
    ...    The transaction type should display in the automated transactions table in table maintenance.
    ...    @author: jloretiz    28JUL2020    - initial Create
    [Arguments]    ${sProcessingArea}    ${sTransactionCode}

    ###Pre-processing of arguments###
    ${ProcessingArea}    Acquire Argument Value    ${sProcessingArea}
    ${TransactionCode}    Acquire Argument Value    ${sTransactionCode}

    ###Navigate to Automated Transactions###
    Mx LoanIQ Click    ${LIQ_TableMaintenance_Button}
    Search in Table Maintenance    ${AUTOMATED_TRANSACTIONS}

    ###Select Processing Area###
    Mx LoanIQ Activate Window    ${LIQ_AutomatedTransactions_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_AutomatedTransactions_Dropdown}    ${ProcessingArea}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Validating_TransactionType
    
    ###Validate Transaction Type###
    ${IsExist}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_AutomatedTransactions_JavaTree}    ${TransactionCode}%yes
    Run Keyword If    ${IsExist}==${FALSE}    Fail    Transaction Type is not on the table!

    ###Exit Table Maintenance###
    Mx LoanIQ Click    ${LIQ_AutomatedTransactions_Ok_Button}
    Mx LoanIQ Click    ${LIQ_TableMaintenance_Exit_Button}
