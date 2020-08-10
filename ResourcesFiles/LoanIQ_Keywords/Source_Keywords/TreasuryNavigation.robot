*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Validate Base Rate Code
    [Documentation]    This keyword is used to validate Base Rate Code Description value in Funding Rates Details Window
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${eLocator}    VerificationData="Yes"
    ${Actual_RateCode}    Run Keyword If    '${Status}'=='True'    Mx LoanIQ Get Data    ${eLocator}    input=Actual_RateCode
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Base Rate Code Description is incorrect. Expected is  ${sExpectedValue}.  
    ${Validate_RateCode}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_RateCode}
    Run Keyword If    '${Validate_RateCode}'=='True'    Log    Base Rate Code Description is correct: ${Actual_RateCode}
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Base Rate Code Description is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_RateCode}.

Validate Funding Desk
    [Documentation]    This keyword is used to compare expected and actual funding desk value
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    
    ${Actual_Funding_Desk}    Mx LoanIQ Get Data    ${eLocator}    input=Actual_Funding_Desk  
    ${Validate_Funding_Desk}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_Funding_Desk}
    Run Keyword If    ${Validate_Funding_Desk}==${True}    Log    Funding Desk is correct: ${Actual_Funding_Desk}
    ...    ELSE    Log    Funding Desk is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_Funding_Desk}.


Validate Funding Desk Currency
    [Documentation]    This keyword is used to compare expected and actual currency value in Currency Exchange Rates List screen
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    
    ${Actual_Currency}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${eLocator}    input=Actual_Currency
    ${Validate_Currency}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_Currency}
    Run Keyword If    ${Validate_Currency}==${True}    Log    Funding Desk Currency is correct: ${Actual_Currency}
    ...    ELSE    Log    Funding Desk Currency is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_Currency}.

Validate Currency
    [Documentation]    This keyword is used to validate Currency value in Currency Exchange Rates List
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    
    ${Actual_Currency}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${eLocator}    input=Actual_Currency
    ${Validate_Currency}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_Currency}
    Run Keyword If    ${Validate_Currency}==${True}    Log    Currency is correct: ${Actual_Currency}
    ...    ELSE    Log    Currency is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_Currency}.

Validate Repricing Frequency
    [Documentation]    This keyword is used to validate Rate value in Funding Rates Details
    ...    e.g. Validate  Repricing Frequency(N Months/Years)    locator    expected_value
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    
    ${Actual_RepFreq}    Run Keyword And Continue On Failure     Mx LoanIQ Get Data    ${eLocator}    input=Actual_Rate
    ${Validate_RepricingCurr}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_RepFreq}
    Run Keyword If    ${Validate_RepricingCurr}==${True}    Log    Repricing Frequency is correct: ${Actual_RepFreq}
    ...    ELSE    Run Keyword And Continue On Failure    Log    Rate is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_RepFreq}.
    
Validate Base Rate
    [Documentation]    This keyword is used to compare expected and actual Base Rate Description
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    
    ${Actual_BaseRate}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${eLocator}    input=Actual_BaseRate
    ${Validate_BaseRate}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_BaseRate}
    Run Keyword If    ${Validate_BaseRate}==${True}    Log    Rate is correct: ${Actual_BaseRate}
    ...    ELSE    Log    Rate is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_BaseRate}.
   
Validate Base Rate Effective Date
    [Documentation]    This keyword is used to validate Rate value in Funding Rates Details
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    
    mx LoanIQ activate    ${LIQ_FundingRatesDetails_Window}    
    ${Actual_EffectiveDate}    Run Keyword And Continue On Failure   Mx LoanIQ Get Data    ${eLocator}    input=Actual_EffectiveDate
    ${Validate_EffectiveDate}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_EffectiveDate}
    Run Keyword If    '${Validate_EffectiveDate}'=='True'    Log    Effective Date is correct: ${Actual_EffectiveDate}
    ...    ELSE    Log    Rate is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_EffectiveDate}.

Validate Spread Rate
    [Documentation]    This keyword is used to validate Rate value in Funding Rates Details
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1    
    [Arguments]    ${eLocator}    ${sExpectedValue}
    
    ${Actual_SpreadRate}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${eLocator}    input=Actual_SpreadRate
    ${Validate_SpreadRate}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_SpreadRate}
    Run Keyword If    '${Validate_SpreadRate}'=='True'    Log    Spread Rate is correct: ${Actual_SpreadRate}  
    ...    ELSE    Log    Rate is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_SpreadRate}.

Validate Spread Rate and Spread Effective Date Not Empty
    [Documentation]    This keyword is used to compare expected and actual Spread Rate and Spread Effective Date
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1    
    [Arguments]    ${eLocator_SpreadRate}    ${sExpectedValue_SpreadRate}    ${eLocator_SpreadDate}    ${sExpectedValue_SpreadDate}
    
    ${Actual_SpreadRate}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${eLocator_SpreadRate}    input=Actual_SpreadRate
    ${Validate_SpreadRate}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue_SpreadRate}    ${Actual_SpreadRate}
    Run Keyword If    '${Validate_SpreadRate}'=='True'    Log    Spread Rate is correct: ${Actual_SpreadRate}  
    ...    ELSE    Log    Rate is incorrect. Expected value: ${sExpectedValue_SpreadRate}. Actual value: ${Actual_SpreadRate}.

    ${Actual_SpreadEffectiveDate}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${eLocator_SpreadDate}    input=Actual_SpreadEffectiveDate
    ${Validate_SpreadEffectiveDate}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue_SpreadDate}    ${Actual_SpreadEffectiveDate}
    Run Keyword If    '${Validate_SpreadEffectiveDate}'=='True'    Log    Spread Effective Date is correct: ${Actual_SpreadEffectiveDate}
    ...    ELSE    Log    Spread Rate is incorrect. Expected value: ${sExpectedValue_SpreadDate}. Actual value: ${Actual_SpreadEffectiveDate}.

Validate Spread Effective Date
    [Documentation]    This keyword is used to compare expected and actual Spread Effective Date
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator}    ${sExpectedValue}
    
    ${Actual_SpreadEffectiveDate}    Mx LoanIQ Get Data    ${eLocator}    input=Actual_SpreadEffectiveDate
    ${Validate_SpreadEffectiveDate}    Run Keyword And Return Status    Should Be Equal As Strings    ${sExpectedValue}    ${Actual_SpreadEffectiveDate}
    Run Keyword If    ${Validate_SpreadEffectiveDate}==${True}    Log    Spread Effective Date is correct: ${Actual_SpreadEffectiveDate}
    ...    ELSE    Log    Spread Rate is incorrect. Expected value: ${sExpectedValue}. Actual value: ${Actual_SpreadEffectiveDate}.

Select Treasury Navigation
    [Documentation]    This keyword opens Treasury Navigation window and selects value in the tree
    ...    e.g. Select Treasury Navigation    Funding Rates
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sTreasuryValue}
    
    mx LoanIQ click    ${LIQ_Treasury_Button}  
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Treasury_Navigation}    ${sTreasuryValue}%d
    mx LoanIQ activate window    ${LIQ_TreasuryNavigation_Window}    

Validate Rate History table
    [Documentation]    This keyword is used to validate Exchange Rate History table
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sConvertedDate_With_0}    ${iExpectedRate}
    
    mx LoanIQ click    ${LIQ_ExchangeRate_History_Button}
    mx LoanIQ activate window    ${LIQ_CrossCurrency_Hist_Window}
    Log    ${sConvertedDate_With_0}\t${iExpectedRate}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_CrossCurrency_Hist_Tree}    ${sConvertedDate_With_0}\t\t${iExpectedRate}    5                

Validate Rate History table for 400
    [Documentation]    This keyword is used to validate Exchange Rate History table
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sConvertedDate_With_0}    ${iExpectedRate}
        
    mx LoanIQ click    ${LIQ_ExchangeRate_History_Button}
    mx LoanIQ activate window    ${LIQ_CrossCurrency_Hist_Window}
    Log    ${sConvertedDate_With_0}\t${iExpectedRate}
    ${Val_Date}    Run Keyword If    '${iExpectedRate}'=='None'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CrossCurrency_Hist_Tree}    ${iExpectedRate}%Start Date%Val_Date 
    ${Val_Rate}    Run Keyword If    '${sConvertedDate_With_0}'=='None'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CrossCurrency_Hist_Tree}    ${sConvertedDate_With_0}%Rate%Val_Rate
    ${Val_Date1}    Run Keyword And Return Status    Should Not Be Empty    ${Val_Date}
    ${Val_Rate1}    Run Keyword And Return Status    Should Not Be Empty    ${Val_Rate}    
    Run Keyword If    ${Val_Date1}==${True} and ${Val_Rate1}==${True}       Mx LoanIQ Select String    ${LIQ_CrossCurrency_Hist_Tree}    ${sConvertedDate_With_0}\t\t${iExpectedRate}    5
    Run Keyword If    ${Val_Date1}==${False} and ${Val_Rate1}==${False}    Run Keywords    mx LoanIQ activate    ${LIQ_CrossCurrency_Hist_Window}    
    ...    AND    mx LoanIQ click    ${LIQ_CrossCurrency_Hist_Cancel_Button}
    ...    AND    Log    Correct!!!!!!! Effective Date '${sConvertedDate_With_0}' is not reflected in LoanIQ.
    [Return]    ${Val_Date1}    ${Val_Rate1}        
        
Verify Previous Record in History Table
    [Documentation]    This keyword is used to select previous end date from history screen
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eHistoryTreeLocator}    ${sBackdatedDate_With_0}
    
    mx LoanIQ activate window    ${LIQ_CrossCurrency_Hist_Window}
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${eHistoryTreeLocator}    ${sBackdatedDate_With_0}           

Validate Rate History Table in Funding Rate
    [Documentation]    This keyword is used to validate Funding Rate History table in Funding Rate screen.
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eHistoryButtonLocator}    ${eHistoryTreeLocator}    ${sConv_Date_Without_0}    ${sConv_Date_With_0}    ${iExpectedRate}    ${sBackdated_With_0}
    ...    ${sBackdated_Without_0}
    
    mx LoanIQ click    ${eHistoryButtonLocator}
    ${Validate_Effective_Date}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${eHistoryTreeLocator}    ${sConv_Date_With_0}%yes
    Run Keyword If    '${Validate_Effective_Date}' == 'True'    Log    Effective Date ${sConv_Date_Without_0} is displayed in the table.
    ...    ELSE    Log    Effective Date ${sConv_Date_Without_0} is not displayed in the table.           
    ${BaseRate_Hist_Rate}    Mx LoanIQ Store TableCell To Clipboard    ${eHistoryTreeLocator}    ${sConv_Date_With_0}%Rate%BaseRate_Hist_Rate   
    Run Keyword If    '${iExpectedRate}' == '${BaseRate_Hist_Rate}'    Log    Base Percentage Rate is: ${iExpectedRate}
    ...    ELSE    Log    Base Rate in History is incorrect. Expected value is: ${iExpectedRate}. Actual value is: ${BaseRate_Hist_Rate}.
    ${Val_Backdated}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${eHistoryTreeLocator}    ${sBackdated_With_0}%yes
    Run Keyword If    ${Val_Backdated}==${True}    Log    End Date for the previous Effective Date is correct: ${sBackdated_Without_0}.
    ...    ELSE    Log    End Date for the previous Effective Date is incorrect. Expected value: ${sBackdated_Without_0}.
   
Validate Specific History Row
    [Documentation]    This keyword is used to validate specific row in Exchange Rate History table
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: ehugo    22JUN2020    - added dataset_path for eventslist.txt
    [Arguments]    ${sConv_Date_With_0}    ${iExpectedRate}    ${sBackdated_With_0}    ${sBackdated_Without_0}   
    
    Mx LoanIQ DoubleClick    ${LIQ_CrossCurrency_Hist_Tree}    ${sConv_Date_With_0}
    mx LoanIQ activate window    ${LIQ_CrossCurrency_Rate_Window}         
    ${Actual_Rate}    Mx LoanIQ Get Data    ${LIQ_CrossCurrency_Rate_Hist_Field}    input=Actual_Rate
    ${Actual_Rate}    Strip String    ${Actual_Rate}    mode=right    characters=0 
    ${Actual_Rate}    Remove String    ${Actual_Rate}    ,
    ${Actual_Rate}    Convert To Number    ${Actual_Rate}    
    Run Keyword And Continue On Failure    Should Be Equal    ${Actual_Rate}    ${iExpectedRate}            
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sConv_Date_With_0}    ${LIQ_CrossCurrency_Start_Date_Hist_Field}
    ${Actual_Rate}    Mx LoanIQ Get Data    ${LIQ_CrossCurrency_Rate_Hist_Field}    input=Actual_Rate
    ${Actual_Effective_Date}    Mx LoanIQ Get Data    ${LIQ_CrossCurrency_Start_Date_Hist_Field}    input=Actual_Effective_Date
    mx LoanIQ click    ${LIQ_CrossCurrency_Rate_Hist_Cancel_Button}
    
    Delete File If Exist    ${dataset_path}${Input_File_Path_FXRates}eventslist.txt
    Mx LoanIQ Copy Content And Save To File    ${LIQ_CrossCurrency_Hist_Tree}    ${dataset_path}${Input_File_Path_FXRates}eventslist.txt
    ${Temp}    OperatingSystem.Get File    ${dataset_path}${Input_File_Path_FXRates}eventslist.txt
    ${Hist_Line}    Get Line Count    ${Temp}
    Run Keyword If    ${Hist_Line}>2    Verify Previous Record in History Table    ${LIQ_CrossCurrency_Hist_Tree}    ${sBackdated_With_0}
    
    mx LoanIQ click    ${LIQ_CrossCurrency_Hist_Cancel_Button} 
    mx LoanIQ click    ${LIQ_ExchangeRate_Cancel_Button}  
    mx LoanIQ click    ${LIQ_ExchangeRate_Exit_Button}                      
    [Return]    ${Actual_Effective_Date}    ${Actual_Rate}

Validate Specific History Row for Delete
    [Documentation]    This keyword is used to validate specific row in Exchange Rate History table
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sConv_Date_With_0}    ${iExpectedRate}
    
    Mx LoanIQ DoubleClick    ${LIQ_CrossCurrency_Hist_Tree}    ${sConv_Date_With_0}
    mx LoanIQ activate window    ${LIQ_CrossCurrency_Rate_Window}         
    ${Actual_Rate}    Mx LoanIQ Get Data    ${LIQ_CrossCurrency_Rate_Hist_Field}    input=Actual_Rate
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${Actual_Rate}    ${iExpectedRate}            
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sConv_Date_With_0}    ${LIQ_CrossCurrency_Start_Date_Hist_Field}
    ${Actual_Rate}    Mx LoanIQ Get Data    ${LIQ_CrossCurrency_Rate_Hist_Field}    input=Actual_Rate
    ${Actual_Effective_Date}    Mx LoanIQ Get Data    ${LIQ_CrossCurrency_Start_Date_Hist_Field}    input=Actual_Effective_Date
    mx LoanIQ click    ${LIQ_CrossCurrency_Rate_Hist_Cancel_Button}
    mx LoanIQ click    ${LIQ_CrossCurrency_Hist_Cancel_Button} 
    mx LoanIQ click    ${LIQ_ExchangeRate_Cancel_Button}  
    mx LoanIQ click    ${LIQ_ExchangeRate_Exit_Button}                      
    [Return]    ${Actual_Effective_Date}    ${Actual_Rate}

Validate Specific History Row with no previous record checking
    [Documentation]    This keyword is used to validate specific row in Exchange Rate History table
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sConv_Date_With_0}    ${iExpectedRate}   
    
    Mx LoanIQ DoubleClick    ${LIQ_CrossCurrency_Hist_Tree}    ${sConv_Date_With_0}
    mx LoanIQ activate window    ${LIQ_CrossCurrency_Rate_Window}         
    ${Actual_Rate}    Mx LoanIQ Get Data    ${LIQ_CrossCurrency_Rate_Hist_Field}    input=Actual_Rate
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${Actual_Rate}    ${iExpectedRate}            
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sConv_Date_With_0}    ${LIQ_CrossCurrency_Start_Date_Hist_Field}
    ${Actual_Rate}    Mx LoanIQ Get Data    ${LIQ_CrossCurrency_Rate_Hist_Field}    input=Actual_Rate
    ${Actual_Effective_Date}    Mx LoanIQ Get Data    ${LIQ_CrossCurrency_Start_Date_Hist_Field}    input=Actual_Effective_Date
    mx LoanIQ click    ${LIQ_CrossCurrency_Rate_Hist_Cancel_Button}
    mx LoanIQ click    ${LIQ_CrossCurrency_Hist_Cancel_Button} 
    mx LoanIQ click    ${LIQ_ExchangeRate_Cancel_Button}  
    mx LoanIQ click    ${LIQ_ExchangeRate_Exit_Button}                      
    [Return]    ${Actual_Effective_Date}    ${Actual_Rate}

Validate Specific History Row Funding Rates
    [Documentation]    This keyword is used to validate specific row in Exchange Rate History table
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eHistoryTreeLocator}    ${sConv_Date_With_0}    ${iExpectedRate}    ${eLocatorRate}    ${eLocatorStartDate}    ${eLocatorCancel1}    ${eLocatorCancel2}
    
    Log    ${sConv_Date_With_0}
    Mx LoanIQ Click Javatree Cell    ${eHistoryTreeLocator}    ${sConv_Date_With_0}%Start Date
    Mx Native Type    {ENTER}             
    Log    ${eLocatorRate}
    Log    ${iExpectedRate}
    ${Actual_New_Rate}    Mx LoanIQ Get Data     ${eLocatorRate}    input=Actual_New_Rate
    Log     ${Actual_New_Rate}
    Run Keyword If    '${iExpectedRate}'=='${Actual_New_Rate}'    Log    New Rate is correct: ${Actual_New_Rate}.
    ...    ELSE    Log    New Rate is incorrect. Expected value: ${iExpectedRate}. Actual value: ${Actual_New_Rate}.
    ${Actual_Effective_Date}    Mx LoanIQ Get Data    ${eLocatorStartDate}    input=Actual_Effective_Date
    Run Keyword If    '${Actual_Effective_Date}'=='${sConv_Date_With_0}'    Log    Effective Date is correct: ${Actual_Effective_Date}.
    ...    ELSE    Log    Effective Date is incorrect. Expected value: ${sConv_Date_With_0}. Actual value: ${Actual_Effective_Date}.                  
    mx LoanIQ click    ${eLocatorCancel1}
    mx LoanIQ click    ${eLocatorCancel2}

Validate Rate Events List      
    [Documentation]    This keyword is used to validate Event list row value
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sConv_Date_With_0}    ${iExpectedRate}
    
    mx LoanIQ click    ${LIQ_ExchangeRate_Events_Button}
    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Event_Window}     
    ${Comment_Msg}    Catenate    Exchange Rate changed to    ${iExpectedRate}    beginning    ${sConv_Date_With_0}.       
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${sConv_Date_With_0}\t${Comment_Msg}    5      
    mx LoanIQ click    ${LIQ_CurrencyExchangeRate_Event_Exit_Button}

Get Total Events Record
    [Documentation]    This keyword is used to get total row count in Events table.
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocatorTree}    ${sFilePath}    ${sConv_Date_With_0}    ${iExpectedRate}
    
    Delete File If Exist    ${sFilePath}eventslist.txt
    Mx LoanIQ Copy Content And Save To File    ${eLocatorTree}    ${sFilePath}eventslist.txt
    ${Temp}    OperatingSystem.Get File    ${sFilePath}eventslist.txt        
    ${Get_Total_Line}    Get Lines Containing String    ${Temp}    Exchange Rate
    ${Total_Line_Count_Temp}    Get Line Count    ${Get_Total_Line}
    ${Line_Count_With_Same_Date}    ${Total_Line_Count}    Run Keyword If    ${Total_Line_Count_Temp}==2    Get Events Record for Initial Post or Put    ${sConv_Date_With_0}    ${iExpectedRate}
    ...    ELSE IF    ${Total_Line_Count_Temp}==3    Get Events Record and Compare with Previous Record    ${eLocatorTree}    ${sFilePath}    ${sConv_Date_With_0}
    ...    ELSE IF    ${Total_Line_Count_Temp}>3    Get Events Record with Input Effective Date    ${eLocatorTree}    ${sFilePath}    ${sConv_Date_With_0}      
    [Return]    ${Line_Count_With_Same_Date}    ${Total_Line_Count}
    
Get Events Record with Input Effective Date
    [Documentation]    This keyword is used to get row count in Events table and row count of specific Effective Date.
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocatorTree}    ${sFilePath}    ${sEffDate}   
    
    Delete File If Exist    ${sFilePath}eventslist.txt
    Mx LoanIQ Copy Content And Save To File    ${eLocatorTree}    ${sFilePath}eventslist.txt
    ${Temp}    OperatingSystem.Get File    ${sFilePath}eventslist.txt        
    ${Get_Line}    Get Lines Containing String    ${Temp}    ${sEffDate}
    ${Line_Count_With_Same_Date}    Get Line Count    ${Get_Line}
    ${Total_Line_Count}    Get Line Count    ${Temp}
    [Return]    ${Line_Count_With_Same_Date}    ${Total_Line_Count}

Get Events Record and Compare with Previous Record
    [Documentation]    This keyword is used to get row count in Events table and compare with previous record.
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocatorTree}    ${sFilePath}    ${sEffDate}   
    
    Delete File If Exist    ${sFilePath}eventslist.txt
    Mx LoanIQ Copy Content And Save To File    ${eLocatorTree}    ${sFilePath}eventslist.txt
    ${Temp}    OperatingSystem.Get File    ${sFilePath}eventslist.txt        
    ${Get_Total_Line}    Get Lines Containing String    ${Temp}    Exchange Rate
    Log    ${Get_Total_Line}
    ${Get_Total_List}    Split String    ${Get_Total_Line}    separator="\t"
    Log    ${Get_Total_List}
    ${List_Length}    Get Length    ${Get_Total_List}
    ${Date_Loc}    Evaluate    ${List_Length}-2   
    ${Last_Date}    Get From List    ${Get_Total_List}    ${Date_Loc}
    
    ${Stat}    Subtract Date From Date    ${sEffDate}    ${Last_Date}    date1_format=%d-%b-%Y    date2_format=%d-%b-%Y
    ${Stat}    Convert To String    ${Stat}
    ${DateStat}    Run Keyword And Return Status    Should Start With    ${Stat}    -
    ${Line_Count_With_Same_Date}    Run Keyword If    ${DateStat}==${True}    Set Variable    1    
    ...    ELSE    Set Variable    2
    ${Total_Line_Count}    Run Keyword If    ${DateStat}==${True}    Set Variable    2
    ...    ELSE    Set Variable    3
    [Return]    ${Line_Count_With_Same_Date}    ${Total_Line_Count}

Get Events Record for Initial Post or Put
    [Documentation]    This keyword is used to check if Events have only 2 records, current business date and effective date from payload
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sConv_Date_With_0}    ${iExpectedRate}
    
    ${Get_Curr_Date}=    Get System Date on LIQ and Return Value
    ${Curr_Date_With_0}=    Convert Date    ${Get_Curr_Date}    result_format=%d-%b-%Y
    ${Comment_CBD}    Catenate    Exchange Rate changed to    ${iExpectedRate}    beginning    ${Curr_Date_With_0}.
    ${Comment_EffDate}    Catenate    Exchange Rate changed to    ${iExpectedRate}    beginning    ${sConv_Date_With_0}.
    ${CBD_exist}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${Comment_CBD}%Effective Date%val_comment    5
    ${CBD_exist}    Run Keyword And Return Status    Should Not Be Empty    ${CBD_exist}        
    ${EffDate_exist}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${Comment_EffDate}%Effective Date%val_comment    5
    ${EffDate_exist}    Run Keyword And Return Status    Should Not Be Empty    ${EffDate_exist}
    ${Line_Count}    Run Keyword If    ${CBD_exist}==${True} and ${EffDate_exist}==${True}    Set Variable    2
    ...    ELSE    Run Keywords    Log    Date is EMPTY.    level=WARN
    ...    AND    Set Variable    2
    ${Line_Count_With_Same_Date}    Run Keyword If    ${CBD_exist}==${True} and ${EffDate_exist}==${True}    Set Variable    1
    ...    ELSE    Run Keywords    Log    Date is EMPTY.    level=WARN
    ...    AND    Set Variable    1
    [Return]    ${Line_Count_With_Same_Date}    ${Line_Count}   

Validate Funding Rate Events List
    [Documentation]    This keyword is used to validate Event list row value
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eLocator_EventButton}    ${sConv_Date_With_0}    ${iExpectedRate}    ${eLocator_EventTree}    ${eLocator_ExitButton}
    
    Log    Validating Funding Rate Events List...
    mx LoanIQ click    ${eLocator_EventButton}
    ${Comment_Msg}    Catenate    Funding Rate changed to    ${iExpectedRate}    beginning    ${sConv_Date_With_0}
    ${Get_Curr_Date}=    Get Current Date    time_zone=local      
    ${Curr_Date}=    Convert Date    ${Get_Curr_Date}    result_format=%#d-%b-%Y
    ${Curr_Date_With_0}=    Convert Date    ${Get_Curr_Date}    result_format=%d-%b-%Y
     
    ${Actual_Comment_Msg}    Mx LoanIQ Store TableCell To Clipboard    ${eLocator_EventTree}    ${sConv_Date_With_0}%Comment%Actual_Comment_Msg
    ${Actual_Effective_Date}    Mx LoanIQ Store TableCell To Clipboard    ${eLocator_EventTree}    ${sConv_Date_With_0}%Effective Date%Actual_Effective_Date
    
    Run Keyword If    '${Actual_Comment_Msg}'=='${Comment_Msg}'    Log    Comment is correct: ${Actual_Comment_Msg}.
    ...    ELSE    Log    Comment is incorrect. Expected value: ${Comment_Msg}. Actual value: ${Actual_Comment_Msg}.
    Run Keyword If    '${Actual_Effective_Date}'=='${sConv_Date_With_0}'    Log    Effective Date ${Actual_Effective_Date} is logged in Events List.
    ...    ELSE    Log    Effective Date ${sConv_Date_With_0} is not logged in Events List.               
    mx LoanIQ click    ${eLocator_ExitButton}    
    
Validate Currency Exchange Rate List is displayed
    [Documentation]    This keyword is used to validate Currency Exchange Rates List will be displayed.
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: cfrancis    18JUL2019    - added logic to change funding desk for NY FX rates    
    [Arguments]    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}

    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}
    Run Keyword If    '${sFundingDesk_Currency}'=='USD'    mx LoanIQ select    ${LIQ_ExchangeRate_FundingDesk_List}    ${sFundingDesk_Desc}    
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sFundingDesk_Desc}    ${LIQ_ExchangeRate_FundingDesk_List}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Currency Exchange Rates.*").JavaStaticText("label:=${sFundingDesk_Currency}")            VerificationData="Yes"
    Log    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}
    ${ExchangeCurr_Exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}    5
    Run Keyword If    ${ExchangeCurr_Exist}==${True}    Log    ${sExchangeCurrency} and ${iFXRate_WholeNum}${iFXRate_DecNum} combination exist.
    ...    ELSE    Log    ${sExchangeCurrency} and ${iFXRate_WholeNum}${iFXRate_DecNum} combination does DOES NOT EXIST.    level=ERROR
    
Validate Currency Exchange Rate is Not Displayed in List
    [Documentation]    This keyword is used to validate Currency Exchange Rates being verified is not in the list.
    ...    @author: cfrancis    07AUG2918    - initial create
    [Arguments]    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}

    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}
    Run Keyword If    '${sFundingDesk_Currency}'=='USD'    mx LoanIQ select    ${LIQ_ExchangeRate_FundingDesk_List}    ${sFundingDesk_Desc}    
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sFundingDesk_Desc}    ${LIQ_ExchangeRate_FundingDesk_List}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Currency Exchange Rates.*").JavaStaticText("label:=${sFundingDesk_Currency}")            VerificationData="Yes"
    Log    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}
    ${ExchangeCurr_Exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}    5
    Run Keyword If    ${ExchangeCurr_Exist}==${False}    Log    ${sExchangeCurrency} and ${iFXRate_WholeNum}${iFXRate_DecNum} combination does not exist.
    ...    ELSE    Fail    ${sExchangeCurrency} and ${iFXRate_WholeNum}${iFXRate_DecNum} combination does EXIST.

Validate Specific Currency Exchage Rate
    [Documentation]    This keyword is used to validate specific rate when drilled in Currency Exchange Rates List.
    ...    @author: clanding
    ...    @update: bernchua    04DEC2018    - exchange rate value needed in LIQ transactions has zero at the end, need to set variable to global before removing zero.
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}
    
    Run Keyword And Continue On Failure    Mx LoanIQ DoubleClick    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}
    mx LoanIQ activate window    ${LIQ_ExchangeRate_Window}
    ${Exhange_Rate_Field_Value}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${LIQ_ExchangeRate_Field}    input=Exhange_Rate_Field_Value
    
    ${Exhange_Rate_Field_Value_Global}    Set Variable    ${Exhange_Rate_Field_Value}
    Set Global Variable    ${Exhange_Rate_Field_Value_Global}
    
    ${Exhange_Rate_Field_Value}    Strip String    ${Exhange_Rate_Field_Value}    mode=right    characters=0
    ${Exhange_Rate_Field_Value}    Remove String    ${Exhange_Rate_Field_Value}    ,
    ${Exhange_Rate_Field_Value}    Convert To Number    ${Exhange_Rate_Field_Value}
    
    Run Keyword And Continue On Failure    Should Be Equal    ${Exhange_Rate_Field_Value}    ${iFXRate}
    ${Temp}    Remove String    ${sFundingDesk_Desc}    (    )
    ${Temp}    Split String    ${Temp}
    Log    ${Temp}
    ${FundingDesk_Desc1}    Get From List    ${Temp}    0 
    ${FundingDesk_Desc2}    Get From List    ${Temp}    1    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter Currency Exchange Rate.*").JavaStaticText("label:=${FundingDesk_Desc1}.*${FundingDesk_Desc2}.*")       VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter Currency.*").JavaStaticText("label:=${sFundingDesk_Currency}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter Currency.*").JavaStaticText("label:=${sToCurrency}")    VerificationData="Yes"

Validate Currency Exchage Rate List is in Loan IQ
    [Documentation]    This keyword is used to validate Currency Exchange Rates List will not be displayed.
    ...    @author: clanding
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}

    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}    
    ${Val_FundingDesk}    Run Keyword And Return Status    Validate Loan IQ Details    ${sFundingDesk_Desc}    ${LIQ_ExchangeRate_FundingDesk_List}
    Run Keyword If    ${Val_FundingDesk}==${False}    Log    Correct!!!! Post/Put is not reflected in LoanIQ.  
    ${Val_FundingDesk_Curr}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Currency Exchange Rates.*").JavaStaticText("label:=${sFundingDesk_Currency}")    VerificationData="Yes"
    Run Keyword If    ${Val_FundingDesk_Curr}==${False}    Log    Correct!!!! Post/Put is not reflected in LoanIQ.
   
    Log    ${sExchangeCurrency}
    ${Val_ExchangeCurr_Yes}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}%yes    5
    ${Val_FXRate_WholeNum_No}    Run Keyword If    ${Val_ExchangeCurr_Yes}==${True}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_CurrencyExchangeRate_Tree}    ${iFXRate_WholeNum}%yes    5
    ${Val_FXRate_DecNum_No}    Run Keyword If    ${Val_ExchangeCurr_Yes}==${True}    Run Keyword And Return Status    Mx LoanIQ Verify Text In Javatree    ${LIQ_CurrencyExchangeRate_Tree}    ${iFXRate_DecNum}%yes    5
    [Return]    ${Val_ExchangeCurr_Yes}

# Validate Specific Currency Exchage Rate If Invalid
    # [Documentation]    This keyword is used to validate specific rate when drilled in Currency Exchange Rates List.
    # ...    @author: clanding
    # ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    # [Arguments]    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}
    # ...    ${sConv_EffDate_With_0}    ${iFXRate_No_0}
    
    # ${Temp}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}    5
    # Run Keyword If    ${Temp}==${True}    Validate Currency Exchange Rate If Existing    ${sExchangeCurrency}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}    ${iFXRate}    ${Temp}    ${sFundingDesk_Desc}    
    # ...    ${sFundingDesk_Currency}    ${sConv_EffDate_With_0}    ${iFXRate_No_0}    ${sToCurrency}
    # ...    ELSE    Log    Correct!!!!!! Post/Put is not reflected in LoanIQ. Exchange Rate: '${sExchangeCurrency}' with rate ${iFXRate_WholeNum}${iFXRate_DecNum} is not displayed in Currency Exchange Rate List.    

Validate Currency Exchange Rate If Existing
    [Documentation]    This keyword is used to validate currency exchange rate if existing in the table.
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]      ${sExchangeCurrency}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}    ${iFXRate}    ${Temp}    ${sFundingDesk_Desc}    
    ...    ${sFundingDesk_Currency}    ${sConv_EffDate_With_0}    ${iFXRate_No_0}    ${sToCurrency}
    
    Run Keyword And Continue On Failure    Mx LoanIQ DoubleClick    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}
    mx LoanIQ activate window    ${LIQ_ExchangeRate_Window}
    ${Exhange_Rate_Field_Value}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${LIQ_ExchangeRate_Field}    input=Exhange_Rate_Field_Value
    ${Exhange_Rate_Field_Value}    Strip String    ${Exhange_Rate_Field_Value}    mode=right    characters=0
    ${Exhange_Rate_Field_Value}    Remove String    ${Exhange_Rate_Field_Value}    ,
    ${Exhange_Rate_Field_Value}    Convert To Number    ${Exhange_Rate_Field_Value}    
    Run Keyword And Continue On Failure    Should Be Equal    ${Exhange_Rate_Field_Value}    ${iFXRate}    
    ${Temp}    Remove String    ${sFundingDesk_Desc}    (    )
    ${Temp}    Split String    ${Temp}
    Log    ${Temp}
    ${FundingDesk_Desc1}    Get From List    ${Temp}    0 
    ${FundingDesk_Desc2}    Get From List    ${Temp}    1    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter Currency Exchange Rate.*").JavaStaticText("label:=${FundingDesk_Desc1}.*${FundingDesk_Desc2}.*")       VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter Currency.*").JavaStaticText("label:=${sFundingDesk_Currency}")    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter Currency.*").JavaStaticText("label:=${sToCurrency}")                  VerificationData="Yes"
    ${Val_Date1}    ${Val_Rate1}    Run Keyword And Continue On Failure    Validate Rate History table for 400    ${sConv_EffDate_With_0}    ${iFXRate_No_0}
    Run Keyword And Continue On Failure    Run Keyword If    ${Val_Date1}==${True} and ${Val_Rate1}==${True}    Validate Specific History Row with no previous record checking    ${sConv_EffDate_With_0}    ${iFXRate_No_0}
    Run Keyword And Continue On Failure    Validate Rate Events List for 400    ${sConv_EffDate_With_0}    ${iFXRate_No_0}

Validate Currency Exchange Rate
    [Documentation]    This keyword is used to validate currency exchange rate if existing or non-existing in Currency Exchange Rate screen.
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    ...    @update: clanding    09JAN2020    - added ${sToCurrency} to Validate Currency Exchange Rate If Existing keyword
    [Arguments]    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate_WholeNum_With_0}     ${iFXRate_DecNum_With_0}    ${sConv_EffDate_With_0}    ${iFXRate_No_0}

    ${Val_ExchangeCurr_Yes}    Validate Currency Exchage Rate List is in Loan IQ    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate_WholeNum_With_0}     ${iFXRate_DecNum_With_0}
    Run Keyword If    ${Val_ExchangeCurr_Yes}==${True}    Run Keywords    Log    There is an existing data for From Currency/To Currency and Rate combination.    level=WARN    
    ...    AND    Validate Currency Exchange Rate If Existing    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    
    ...    ${iFXRate_No_0}    ${iFXRate_WholeNum_With_0}     ${iFXRate_DecNum_With_0}    ${sConv_EffDate_With_0}    ${iFXRate_No_0}    ${sToCurrency}
    ...    ELSE    Log    Correct!!!!!! Post/Put is not reflected in LoanIQ. Exchange Rate: '${sExchangeCurrency}' with rate ${iFXRate_WholeNum_With_0}${iFXRate_DecNum_With_0} is not displayed in Currency Exchange Rate List.
 
Retrieve Value from Rate History Table
    [Documentation]    This keyword is used to validate Exchange Rate History table
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sConv_Date_With_0}
    
    mx LoanIQ click    ${LIQ_ExchangeRate_History_Button}
    mx LoanIQ activate window    ${LIQ_CrossCurrency_Hist_Window}     

    ${HistoryLinecount_beforeAPI}    ${Historyvalue_beforeAPI}    Get History Record with Input Effective Date in LoanIQ before API    ${LIQ_CrossCurrency_Hist_Tree}    ${Input_File_Path_FXRates}
    mx LoanIQ click    ${LIQ_CrossCurrency_Hist_Cancel_Button} 
    mx LoanIQ click    ${LIQ_ExchangeRate_Cancel_Button}  
    mx LoanIQ click    ${LIQ_ExchangeRate_Exit_Button}
    [Return]    ${HistoryLinecount_beforeAPI}    ${Historyvalue_beforeAPI} 
    
Validate Rate History Table Invalid
    [Documentation]    This keyword is used to validate Exchange Rate History table
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sConv_Date_With_0_JSON}    ${iExpectedRate_JSON}    ${iHistoryLineCount_BeforeAPI}    ${sHistoryLineValue_BeforeAPI}           
    
    mx LoanIQ click    ${LIQ_ExchangeRate_History_Button}
    mx LoanIQ activate window    ${LIQ_CrossCurrency_Hist_Window}
    Log    ${sConv_Date_With_0_JSON}\t${iExpectedRate_JSON}
    ${History_Line_afterAPI}    ${History_Value_afterAPI}    Get History Record with Input Effective Date in LoanIQ before API    ${LIQ_CrossCurrency_Hist_Tree}    ${Input_File_Path_FXRates}
    
    ${History_Line_afterAPI}    Convert To String    ${History_Line_afterAPI}
    @{Split_LineCount}    Split String    ${History_Line_afterAPI}    .
    ${History_Line_afterAPI_whole}    Get From List    ${Split_LineCount}    0
    ${History_Line_afterAPI_whole}    Convert To Number    ${History_Line_afterAPI_whole}
    
    ${History_Linecount_Status}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${History_Line_afterAPI_whole}    ${iHistoryLineCount_BeforeAPI}            
    ${History_Value_Status}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${History_Value_afterAPI}    ${sHistoryLineValue_BeforeAPI}
    
    Run Keyword If    ${History_Linecount_Status}==${False} and ${History_Value_Status}==${False}      Fail    Future effective date has been applied in LoanIQ! 
    ...    ELSE IF    ${History_Linecount_Status}==${True} and ${History_Value_Status}==${False}    Fail    Future effective date has been applied in LoanIQ!     
    ...    ELSE IF    ${History_Linecount_Status}==${False} and ${History_Value_Status}==${True}    Fail    Incorrect History log behaviour in LoanIQ!         
    ...    ELSE    Log    Correct. Payload was not applied.        

    mx LoanIQ click    ${LIQ_CrossCurrency_Hist_Cancel_Button} 
    mx LoanIQ click    ${LIQ_ExchangeRate_Cancel_Button}  
    mx LoanIQ click    ${LIQ_ExchangeRate_Exit_Button}
     
Validate Rate Events List Invalid      
    [Documentation]    This keyword is used to validate Event list row value
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sConv_Date_With_0_JSON}    ${iExpectedRate_JSON}    ${iEventLineCount_BeforeAPI}    ${sEventLineValue_BeforeAPI}
    
    mx LoanIQ click    ${LIQ_ExchangeRate_Events_Button}
    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Event_Window}     
    
    ${Event_Linecount_afterAPI}    ${Eventline_value_afterAPI}    Get Events Record with Input Effective Date in LoanIQ before API    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${Input_File_Path_FXRates}
    ${Event_Linecount_afterAPI}    Convert To String    ${Event_Linecount_afterAPI}
    @{Split_LineCount}    Split String    ${Event_Linecount_afterAPI}    .
    ${Event_Linecount_afterAPI_whole}    Get From List    ${Split_LineCount}    0
    ${Event_Linecount_afterAPI_whole}    Convert To Number    ${Event_Linecount_afterAPI_whole}
    
    ${Event_Linecount_status}    Run Keyword And Return Status    Should Be Equal    ${Event_Linecount_afterAPI_whole}    ${iEventLineCount_BeforeAPI}            
    ${Eventline_value_status}    Run Keyword And Return Status    Should Be Equal    ${Eventline_value_afterAPI}    ${sEventLineValue_BeforeAPI}
    
    ${Comment_Msg}    Catenate    Exchange Rate changed to    ${iExpectedRate_JSON}    beginning    ${sConv_Date_With_0_JSON}.       
    ${Comment_Value}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${Comment_Msg}%Comment%Comment_Value    
    ${Comment_Status}    Run Keyword And Return Status    Should Be Equal As Strings    ${Comment_Msg}    ${Comment_Value}
    
    Run Keyword If    ${Comment_Status}==${True} and ${Event_Linecount_status}==${False} and ${Eventline_value_status}==${False}     Fail    Future effective date has been applied in LoanIQ!                
    ...    ELSE IF    ${Event_Linecount_status}==${True} and ${Eventline_value_status}==${True}    Log    Correct. Payload was not applied.    
    
    mx LoanIQ click    ${LIQ_CurrencyExchangeRate_Event_Exit_Button}  
    
Validate Currency Exchage Rate List is Displayed Invalid
    [Documentation]    This keyword is used to validate Currency Exchange Rates, Funding desk and currency, invalid payload should not reflect in LoanIQ.
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sExchangeCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}    ${sCurrencyPairs_Status}    
    ...    ${sFundingDesk_beforeAPI}    ${iFxRate_BeforeAPI}

    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}    
    ${sFundingDesk_Desc_status}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sFundingDesk_Desc}    ${LIQ_ExchangeRate_FundingDesk_List}
    
    ${FundingDesk_afterAPI}  Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${LIQ_ExchangeRate_FundingDesk_List}    input=sFundingDesk_beforeAPI
    ${sFundingDesk_Desc_status_compare}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${sFundingDesk_beforeAPI}    ${FundingDesk_afterAPI}
    
    Run Keyword If    ${sFundingDesk_Desc_status}==${True} and ${sFundingDesk_Desc_status_compare}==${True}    Log    Cluster value is valid, existing Loan IQ data, awaiting further invalid field verification.    
    ...    ELSE IF    ${sFundingDesk_Desc_status}==${True} and ${sFundingDesk_Desc_status_compare}==${False}    Fail    Incorrect! Cluster value in payload is reflected.    
    
    ${sFundingDesk_Currency_status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Currency Exchange Rates.*").JavaStaticText("label:=${sFundingDesk_Currency}")            VerificationData="Yes"
    Run Keyword If    ${sFundingDesk_Currency_status}==${True}    Log    Cluster value is valid, existing Loan IQ data, awaiting further invalid field verification.    
    ...    ELSE    Log    Correct. Cluster value in payload is not reflected in LoanIQ.
   
    Log    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}
    ${Rate_afterAPI}    Run Keyword If    ${sCurrencyPairs_Status}==${True}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}%Rate%Rate_afterAPI    5
    ${Rate_compare}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${iFxRate_BeforeAPI}    ${Rate_afterAPI}
    
    ${fxrate_afterAPI}    Catenate    ${iFXRate_WholeNum}    ${iFXRate_DecNum}
    ${Rate_afterAPI_CompareJson}    Run Keyword and Return Status    Should Be Equal    ${fxrate_afterAPI}    ${Rate_afterAPI}        
               
    Run Keyword If    ${Rate_afterAPI_CompareJson}==${False}    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}
    Run Keyword If    ${Rate_afterAPI_CompareJson}==${False}    mx LoanIQ click    ${LIQ_ExchangeRate_Exit_Button}           
        
    ${sExchangeCurrency_fxrate_status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}    5
    
    Run Keyword If    ${sExchangeCurrency_fxrate_status}==${True} and ${sCurrencyPairs_Status}==${True}     Log    Exchange currency and rate value is valid, existing Loan IQ data, awaiting further invalid field verification.    
    ...    ELSE IF    ${sExchangeCurrency_fxrate_status}==${False} and ${sCurrencyPairs_Status}==${False}   Log    Correct. Exchange currency and rate value in payload is not reflected in LoanIQ.
    ...    ELSE IF    ${Rate_compare}==${True} and ${sExchangeCurrency_fxrate_status}==${True} and ${sCurrencyPairs_Status}==${False}    Fail    Incorrect payload value has been applied in LoanIQ.
    ...    ELSE IF    ${sExchangeCurrency_fxrate_status}==${False} and ${sCurrencyPairs_Status}==${True}    Log    Correct. Exchange currency and rate value in payload is not reflected in LoanIQ.
    ...    ELSE IF    ${Rate_compare}==${False} and ${sExchangeCurrency_fxrate_status}==${True} and ${sCurrencyPairs_Status}==${False}    Fail    Incorrect payload value has been applied in LoanIQ.    
    ...    ELSE IF    ${Rate_compare}==${True} and ${sExchangeCurrency_fxrate_status}==${False} and ${sCurrencyPairs_Status}==${True}    Log    Correct. Payload is not reflected in LoanIQ.    

    [Return]    ${sExchangeCurrency_fxrate_status}
           
Validate Currency Exchage Rate List is Displayed Invalid Cluster
    [Documentation]    This keyword is used to validate Currency Exchange Rates, Funding desk and currency, invalid payload should not reflect in LoanIQ, else will fail test.
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sExchangeCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}    ${sCurrencyPairs_Status}    ${sFundingDesk_Stat}    ${sFundingDesk_beforeAPI}    ${iFxRate_BeforeAPI}

    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}    
    ${sFundingDesk_Desc_status}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sFundingDesk_Desc}    ${LIQ_ExchangeRate_FundingDesk_List}
    
    ${FundingDesk_afterAPI}  Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${LIQ_ExchangeRate_FundingDesk_List}    input=sFundingDesk_beforeAPI
    ${sFundingDesk_Desc_status_compare}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${sFundingDesk_beforeAPI}    ${FundingDesk_afterAPI}
    
    Run Keyword If    ${sFundingDesk_Desc_status}==${True} and ${sFundingDesk_Desc_status_compare}==${False}    Fail    Incorrect Cluster payload value has been applied in LoanIQ.   
    ...    ELSE IF    ${sFundingDesk_Desc_status}==${True} and ${sFundingDesk_Desc_status_compare}==${True}    Fail    Incorrect Cluster must have been loaded before hand in LoanIQ!       
    ...    ELSE    Log    Correct. Invalid Cluster value in payload is not reflected in LoanIQ.    
    
    ${sFundingDesk_Currency_status}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Currency Exchange Rates.*").JavaStaticText("label:=${sFundingDesk_Currency}")            VerificationData="Yes"
    Run Keyword If    ${sFundingDesk_Currency_status}==${True} and '${sFundingDesk_Stat}'==''    Log    Cluster value is valid.
    ...    ELSE IF    ${sFundingDesk_Currency_status}==${True} and '${sFundingDesk_Stat}'=='N'    Fail    Incorrect payload value has been applied in LoanIQ.
    ...    ELSE IF    ${sFundingDesk_Currency_status}==${False}    Log    Correct. Cluster value in payload is not reflected in LoanIQ.
    
    Log    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}
    
    ${Rate_afterAPI}    Run Keyword If    ${sCurrencyPairs_Status}==${True}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}%Rate%Rate_afterAPI    5
    ${Rate_compare}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${iFxRate_BeforeAPI}    ${Rate_afterAPI}
    
    ${Rate_afterAPI_NULL}    Run Keyword and Return Status    Should Be Empty    ${Rate_afterAPI}
    ${fxrate_afterAPI}    Catenate    ${iFXRate_WholeNum}    ${iFXRate_DecNum}
    ${Rate_afterAPI_CompareJson}    Run Keyword and Return Status    Should Be Equal    ${fxrate_afterAPI}    ${Rate_afterAPI}        
               
    Run Keyword If    ${Rate_afterAPI_NULL}==${True} or ${Rate_afterAPI_CompareJson}==${False}    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}
    Run Keyword If    ${Rate_afterAPI_NULL}==${True} or ${Rate_afterAPI_CompareJson}==${False}    mx LoanIQ click    ${LIQ_ExchangeRate_Exit_Button}        
    
    ${sExchangeCurrency_fxrate_status}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}    5
    Run Keyword If    ${sExchangeCurrency_fxrate_status}==${True} and ${sCurrencyPairs_Status}==${True}    Log    Exchange currency and rate value is valid, existing Loan IQ data, awaiting further invalid field verification.    
    ...    ELSE IF    ${sExchangeCurrency_fxrate_status}==${False} and ${sCurrencyPairs_Status}==${False}    Log    Correct. Exchange currency and rate value in payload is not reflected in LoanIQ.
    ...    ELSE IF    ${sExchangeCurrency_fxrate_status}==${True} and ${sCurrencyPairs_Status}==${False} and ${Rate_compare}==${True}    Fail    Incorrect payload value has been applied in LoanIQ.
    ...    ELSE IF    ${sExchangeCurrency_fxrate_status}==${False} and ${sCurrencyPairs_Status}==${True}    Log    Correct. Exchange currency and rate value in payload is not reflected in LoanIQ.
    ...    ELSE IF    ${sExchangeCurrency_fxrate_status}==${True} and ${sCurrencyPairs_Status}==${False} and ${Rate_compare}==${False}    Fail    Incorrect payload value has been applied in LoanIQ.
    ...    ELSE    Log    Correct. Exchange currency and rate value in payload is not reflected in LoanIQ.
    
    [Return]    ${sExchangeCurrency_fxrate_status}           

Validate Specific Currency Exchage Rate Invalid    
    [Documentation]    This keyword is used to validate specific rate when drilled in Currency Exchange Rates List.
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sExchangeCurrency_JSON}    ${sToCurrency_JSON}    ${sFundingDesk_Currency}    ${iFXRate_JSON}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}    ${sFundingDesk_Stat}    ${iSpecificFxRate_BeforeAPI}
        
    ${Temp}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency_JSON}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}    5
    Run Keyword If    ${Temp}==${True}    Run Keyword And Continue On Failure    Mx LoanIQ DoubleClick    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency_JSON}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}    

    mx LoanIQ activate window    ${LIQ_ExchangeRate_Window}
    
    ${Exhange_Rate_Field_Value}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${LIQ_ExchangeRate_Field}    input=Exhange_Rate_Field_Value
    ${Exhange_Rate_Field_Value}    Strip String    ${Exhange_Rate_Field_Value}    mode=right    characters=0
    ${Exhange_Rate_Field_Value}    Remove String    ${Exhange_Rate_Field_Value}    ,
    ${Exhange_Rate_Field_Value}    Convert To Number    ${Exhange_Rate_Field_Value}
    ${Exhange_Rate_Field_Value_string}    Convert To String    ${Exhange_Rate_Field_Value}    
    ${Exchange_Rate_Status}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${Exhange_Rate_Field_Value}    ${iFXRate_JSON}    
    
    ${SpecificFxRate_status_compare}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Should Be Equal    ${iSpecificFxRate_BeforeAPI}    ${Exhange_Rate_Field_Value_string}
    
    
    Run Keyword If    ${Exchange_Rate_Status}==${True} and ${SpecificFxRate_status_compare}==${True}    Log    Validation: Either payload is applied or value has existed before    level=WARN
    ...    ELSE IF    ${Exchange_Rate_Status}==${True} and ${SpecificFxRate_status_compare}==${False}    Fail    Payload has been applied
    ...    ELSE    Log    Correct Payload has not been loaded. 

    ${Funding_Desk_drilldown}    Run Keyword And Return If    '${sFundingDesk_Stat}'=='Y'    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter Currency.*").JavaStaticText("label:=${sFundingDesk_Currency}")    VerificationData="Yes"
    Run Keyword If    ${Funding_Desk_drilldown}==${True}    Log    Validation: Either payload is applied or value has existed before    level=WARN
    ...    ELSE    Log    Correct. Payload is not applied.
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter Currency.*").JavaStaticText("label:=${sToCurrency_JSON}")    VerificationData="Yes"

Retrieve Value from Currency Exchange Rates List Window
    [Documentation]    This keyword is used to retrieve current data on the specific window prior to API
    ...    @author: chanario
    [Arguments]    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${sCurrencyPairs_Status}

    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}    
    ${sFundingDesk_beforeAPI}  Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${LIQ_ExchangeRate_FundingDesk_List}    input=sFundingDesk_beforeAPI      
    ${ExhangeRate_beforeAPI}    Run Keyword If    ${sCurrencyPairs_Status}==${True}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}%Rate%Rate_beforeAPI    
    ...    ELSE    Log    Exchange Currency from payload are invalid values, no data to retrieve from LoanIQ before API
    ${Specific_ExhangeRate_beforeAPI}    Run Keyword If    ${sCurrencyPairs_Status}==${True}    Run Keyword And Continue On Failure    Retrieve Specific Currency Exchange Rate    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${sCurrencyPairs_Status}       
    Run Keyword If    ${sCurrencyPairs_Status}==${False}    mx LoanIQ click    ${LIQ_ExchangeRate_Exit_Button}
    
    [Return]    ${sFundingDesk_beforeAPI}    ${ExhangeRate_beforeAPI}    ${Specific_ExhangeRate_beforeAPI}        

Retrieve Specific Currency Exchange Rate
    [Documentation]    This keyword is used to retrieve current data on the drilldown Currency Exchange Rate, Events and History window prior to API
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${sCurrencyPairs_Status}  
        
    Run Keyword And Continue On Failure    Mx LoanIQ DoubleClick    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}
    mx LoanIQ activate window    ${LIQ_ExchangeRate_Window}
    ${Specific_ExhangeRate_beforeAPI}    Run Keyword And Continue On Failure    Mx LoanIQ Get Data    ${LIQ_ExchangeRate_Field}    input=Exhange_Rate_Field_Value
      
    [Return]    ${Specific_ExhangeRate_beforeAPI}
 
Retrieve Value from Currency Validate Rate Events List
    [Documentation]    This keyword is used to retrieve current data on the drilldown Currency Exchange Rate, Events and History window prior to API
    ...    @author: chanario
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${sFilePath}
    
    mx LoanIQ click    ${LIQ_ExchangeRate_Events_Button}
    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Event_Window}     
    ${EventLinecount_beforeAPI}    ${Eventlinevalue_beforeAPI}    Get Events Record with Input Effective Date in LoanIQ before API    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${sFilePath}
    mx LoanIQ click    ${LIQ_CurrencyExchangeRate_Event_Exit_Button}

    [Return]    ${EventLinecount_beforeAPI}    ${Eventlinevalue_beforeAPI}               

Get History Record with Input Effective Date in LoanIQ before API
    [Documentation]    This keyword is used to get row count in Events table and row count of specific Effective Date.
    ...    @author: chanario
    [Arguments]    ${eLocatorTree}    ${sFilePath}
    Delete File If Exist    ${sFilePath}historylist.txt
    Mx LoanIQ Copy Content And Save To File    ${eLocatorTree}    ${sFilePath}historylist.txt
    ${Temp}    OperatingSystem.Get File    ${sFilePath}historylist.txt        
    ${line_count}    Get Line Count    ${Temp}
    ${line_value}    Get Line    ${Temp}    1        
    [Return]    ${line_count}    ${line_value}     

Get Events Record with Input Effective Date in LoanIQ before API
    [Documentation]    This keyword is used to get row count in Events table and row count of specific Effective Date.
    ...    @author: chanario
    [Arguments]    ${eLocatorTree}    ${sFilePath}
    Delete File If Exist    ${sFilePath}eventslist.txt
    Mx LoanIQ Copy Content And Save To File    ${eLocatorTree}    ${sFilePath}eventslist.txt
    ${Temp}    OperatingSystem.Get File    ${sFilePath}eventslist.txt        
    ${line_count}    Get Line Count    ${Temp}
    ${Eventline_value}    Get Line    ${Temp}    1       
    [Return]    ${line_count}    ${Eventline_value}     

Validate Rate Events List for 400      
    [Documentation]    This keyword is used to validate Event list row value
    ...    e.g. Validate Rate Events List    sConv_Date_With_0    iExpectedRate   
    ...    @author: clanding
    [Arguments]    ${sConv_Date_With_0}    ${iExpectedRate}
    mx LoanIQ click    ${LIQ_ExchangeRate_Events_Button}
    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Event_Window}     
    ${Comment_Msg}    Set Variable    Exchange Rate changed to 0.559590827 beginning None.
    ${sConv_Date_With_0}    Set Variable    None
    ${val_comment}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${sConv_Date_With_0}%Comment%val_comment    5
    ${val_comment}    Run Keyword And Return Status    Should Be Empty    ${val_comment}
    Run Keyword If    ${val_comment}==${False}    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${sConv_Date_With_0}\t${Comment_Msg}    5
    ...    ELSE    Run Keywords    mx LoanIQ activate    ${LIQ_CurrencyExchangeRate_Event_Window}    
    ...    AND    mx LoanIQ click    ${LIQ_CurrencyExchangeRate_Event_Exit_Button}
    ...    AND    Log    Correct!!!!!!! Effective Date '${sConv_Date_With_0}' is not reflected in LoanIQ.
    mx LoanIQ maximize    ${LIQ_Window}
    Close All Windows on LIQ       

Validate Rate Events List_Backup     
    [Documentation]    This keyword is used to validate Event list row value
    ...    e.g. Validate Rate Events List    sConv_Date_With_0    iExpectedRate   
    ...    @author: clanding
    [Arguments]    ${sConv_Date_With_0}    ${iExpectedRate}
    mx LoanIQ click    ${LIQ_ExchangeRate_Events_Button}
    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Event_Window}     
    ${Comment_Msg}    Catenate    Exchange Rate changed to    ${iExpectedRate}    beginning    ${sConv_Date_With_0}.       
    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${sConv_Date_With_0}\t${Comment_Msg}    5      
    ${Event_Line_Same_Date}    ${Event_Line}    Get Total Events Record    ${LIQ_CurrencyExchangeRate_Event_Tree}    ${Input_File_Path_FXRates}    ${sConv_Date_With_0}    ${iExpectedRate}
    mx LoanIQ click    ${LIQ_CurrencyExchangeRate_Event_Exit_Button}
    [Return]    ${Event_Line_Same_Date}    ${Event_Line}    

Validate Currency Exchage Rate List is Displayed Before Delete
    [Documentation]    This keyword is used to validate Currency Exchange Rates List will be displayed.
    ...    @author: clanding
    ...    @update: clanding    19MAR2019    - added checking for same Previous Start and End Date.
    [Arguments]    ${sExchangeCurrency}    ${sToCurrency}    ${sFundingDesk_Desc}    ${sFundingDesk_Currency}    ${iFXRate_WholeNum}    ${iFXRate_DecNum}

    mx LoanIQ activate window    ${LIQ_CurrencyExchangeRate_Window}    
    Run Keyword And Continue On Failure    Validate Loan IQ Details    ${sFundingDesk_Desc}    ${LIQ_ExchangeRate_FundingDesk_List}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Currency Exchange Rates.*").JavaStaticText("label:=${sFundingDesk_Currency}")            VerificationData="Yes"
    Log    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}
    ${ExchangeCurr_Exist}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_CurrencyExchangeRate_Tree}    ${sExchangeCurrency}\t${iFXRate_WholeNum}\t${iFXRate_DecNum}    5
    Run Keyword If    ${ExchangeCurr_Exist}==${True}    Log    ${sExchangeCurrency} and ${iFXRate_WholeNum}${iFXRate_DecNum} combination exist.
    ...    ELSE    Fatal Error    Change input!! ${sExchangeCurrency} and ${iFXRate_WholeNum}${iFXRate_DecNum} combination does DOES NOT EXIST.

Validate Base Rate History Table in Funding Rate    
    [Documentation]    This keyword is used to validate Funding Base Rate in History table
    ...    @author: cmartill
    ...    @update: clanding    19MAR2019    - added checking for same Previous Start and End Date.
    ...    @update: clanding    02APR2019    - added handling of data when there is only 1 row in Funding Rate History window.
    ...    @update: jdelacru    14FEB2020    - removed number arguments for keyword Mx LoanIQ Store TableCell To Clipboard
    ...    @update: ehugo    24JUN2020    - added condition to check if ${previous_startDate} and ${previous_Rate} have values before converting the dates
    [Arguments]    ${eHistoryButtonLocator}    ${eHistoryTreeLocator}    ${sConv_Date_Without_0}    ${sConv_Date_With_0}    ${iExpectedRate}    ${iExpectedRate_%}    ${sBackdated_With_0}    ${sBackdated_Without_0}
    
    mx LoanIQ activate window    ${LIQ_FundingRatesDetails_Window}
    mx LoanIQ click    ${eHistoryButtonLocator}
    Log    rate:${iExpectedRate}           
    
    ${iExpectedRate}     Convert To String    ${iExpectedRate} 
    ${status}    Run Keyword And Return Status   Should Match Regexp    ${iExpectedRate}    ^\s*(?=.*[1-9])\\d*(?:\.\\d{1,1})?\s*$
    ${zero}    Fetch From Right    ${iExpectedRate}    .
    ${zeroDecimal_status}    Run Keyword And Return Status    Should Be Equal As Strings    ${zero}    0
    
    ${iExpectedRate_%}    ${Base_Rate}    Run Keyword If    '${status}'=='True' and '${zeroDecimal_status}'=='True'  Convert to Whole Number    ${iExpectedRate}
    ...    ELSE IF    '${zeroDecimal_status}'=='False'    Compute Rate Percentage 6 Decimal Places    ${iExpectedRate}
    ${Base_Rate}    Convert To String    ${Base_Rate} 
    
    Log    ${sConv_Date_With_0}\t\t${Base_Rate}
    ${hasNoEndDate}    Run Keyword And Return Status    Mx LoanIQ Select String    ${eHistoryTreeLocator}    ${sConv_Date_With_0}\t\t${Base_Rate}
    Run Keyword If    '${hasNoEndDate}'=='True'    Mx LoanIQ DoubleClick    ${eHistoryTreeLocator}    ${sConv_Date_With_0}\t\t${Base_Rate}    
    ${Actual_New_Rate}    Run Keyword And Continue On Failure   Mx LoanIQ Get Data     ${LIQ_FundHistory_Rate_TextField}    input=Actual_New_Rate
    Run Keyword If    '${iExpectedRate_%}'=='${Actual_New_Rate}'    Log    New Rate is correct: ${Actual_New_Rate}.
    ...    ELSE    Log    New Rate in History Table does not match. Expected value: ${iExpectedRate_%}.
    ${Actual_Effective_Date}    Mx LoanIQ Get Data     JavaWindow("title:=Please Enter New Rate.*").JavaEdit("tagname:=Text","value:=${sConv_Date_With_0}.*")    input=Actual_Effective_Date
    Run Keyword If    '${Actual_Effective_Date}'=='${sConv_Date_With_0}'    Log    Effective Date is correct: ${Actual_Effective_Date}.
    ...    ELSE    Log    Latest Start Date in History Table is does not match. Expected value: ${sConv_Date_With_0}.  
    
    ${Actual_End_Date_Empty}       Run Keyword And Return Status    Mx LoanIQ Verify Object Exist     JavaWindow("title:=Please Enter New Rate.*").JavaEdit("tagname:=Text","text:=")    VerificationData="Yes"
    Run Keyword If    '${Actual_End_Date_Empty}'=='True'    Log    Base Rate of ${iExpectedRate_%} in History Table has no End date.
    mx LoanIQ click    ${LIQ_FundHistory_Cancel_NewRate_Btn}
    
    mx LoanIQ activate    JavaWindow("title:=Funding Rate.*History.*")
    ${previous_startDate}   Mx LoanIQ Store TableCell To Clipboard    ${eHistoryTreeLocator}    ${sBackdated_With_0}%Start Date%previous_startDate
    ${previous_Rate}        Mx LoanIQ Store TableCell To Clipboard    ${eHistoryTreeLocator}    ${sBackdated_With_0}%Rate%previous_Rate
    ${hasPreviousRow}    Run Keyword And Return Status    Mx LoanIQ Select String    ${eHistoryTreeLocator}    ${previous_startDate}\t${sBackdated_With_0}\t${previousRate}
    
    ${start}    Convert Date    ${sConv_Date_With_0}    result_format=timestamp    date_format=%d-%b-%Y
    ${end}    Run Keyword If    '${previous_startDate}'!='' and '${previous_Rate}'!=''    Convert Date    ${previous_startDate}    result_format=timestamp    date_format=%d-%b-%Y
    ${diff}    Run Keyword If    '${previous_startDate}'!='' and '${previous_Rate}'!=''    Subtract Date From Date    ${start}    ${end}
    
    Log    Previous Start Date: ${previous_startDate}.
    Log    Previous Rate: ${previous_Rate}.    
    Run Keyword If    '${previous_startDate}'=='' and '${previous_Rate}'==''    Run Keywords    mx LoanIQ click    ${LIQ_FundHistory_Cancel_Btn}    
    ...    AND    Log    No Previous History Shown.
    ...    ELSE IF    '${diff}'=='86400.0'    Run Keywords    Mx LoanIQ Select String    ${eHistoryTreeLocator}    ${previous_startDate}\t${previous_startDate}\t${previous_Rate}
    ...    AND    mx LoanIQ click    ${LIQ_FundHistory_Cancel_Btn}
    ...    ELSE IF    ${hasPreviousRow}==${False}    Run Keywords    Wait Until Keyword Succeeds    3x    5s    mx LoanIQ click    ${LIQ_FundHistory_Cancel_Btn}
    ...    AND    Log    No Previous History Shown.
    ...    ELSE    Verify Previous Rate Record in History Table in Funding Rate    ${eHistoryTreeLocator}    ${previous_startDate}    ${sBackdated_With_0}    ${previous_Rate}


Verify Previous Rate Record in History Table in Funding Rate
    [Documentation]    This keyword verifies if there's previous rate record on the history table in Funding Rates.
    ...    @author: cmartill
    ...    @updated by clanding 01/28/19: updated date checking from get data to verify exist.
    [Arguments]    ${eHistoryTreeLocator}    ${previous_startDate}    ${sBackdated_With_0}    ${previous_Rate}
    ${rate%}    ${rate}    Compute Rate Percentage 6 Decimal Places    ${previous_Rate}    
    ${hasPreviousRow}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${eHistoryTreeLocator}    ${previous_startDate}\t${sBackdated_With_0}\t${previousRate}
    Run Keyword If    '${hasPreviousRow}'=='True'         Mx LoanIQ DoubleClick    ${eHistoryTreeLocator}    ${previous_startDate}\t${sBackdated_With_0}\t${previous_Rate}
    ${Actual_Previous_Rate}    Run Keyword And Continue On Failure   Mx LoanIQ Get Data     ${LIQ_FundHistory_Rate_TextField}    input=Actual_New_Rate
    Run Keyword If    '${rate%}'=='${Actual_Previous_Rate}'    Log    Expected Previous Rate: ${rate%} is equal to Actual Previous Rate : ${Actual_Previous_Rate}.
    ...    ELSE    Log    Previous Rate in History Table does not match. Expected value: ${previous_Rate}.
    
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter New Rate.*").JavaEdit("tagname:=Text","value:=${previous_startDate}.*")    VerificationData="Yes"
    ${stat}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    JavaWindow("title:=Please Enter New Rate.*").JavaEdit("tagname:=Text","value:=${previous_startDate}.*")        VerificationData="Yes"
    Run Keyword If    ${stat}==${True}    Log    Expected Previous Start Date '${previous_startDate}' is correct. 
    ...    ELSE    Log    Previous Start Date in History Table is does not match. Expected value: ${previous_startDate}.
    
    ${Actual_Previous_End_Date_NotEmpty}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist     JavaWindow("title:=Please Enter New Rate.*").JavaEdit("tagname:=Text","text:=${sBackdated_With_0}")    VerificationData="Yes"
    ${Previous_End_Date}    Run Keyword If    '${Actual_Previous_End_Date_NotEmpty}'=='True'    Run Keywords    Mx LoanIQ Get Data     JavaWindow("title:=Please Enter New Rate.*").JavaEdit("text:=${sBackdated_With_0}")    input=Previous_End_Date
    ...    AND    Log    Previous End Date of Rate is correct. Expected: ${sBackdated_With_0}.
    ...    ELSE    Log    Previous End Date in History Table does not match. Expected value: ${sBackdated_With_0}. 
    mx LoanIQ click    ${LIQ_FundHistory_Cancel_NewRate_Btn}
    mx LoanIQ click    ${LIQ_FundHistory_Cancel_Btn}


Validate Spread Rate History Table in Funding Rate
    [Documentation]    This keyword is used to validate Funding Spread Rate in History table
    ...    @author: cmartill
    ...    @update: clanding    26MAR2019    - refactor according to CBA Evergreen Automation Checklist and PointSheet v1.0.1
    [Arguments]    ${eHistoryButtonLocator}    ${eHistoryTreeLocator}    ${converted_date_without_zero}    ${sConv_Date_With_0}    ${iExpectedRate}    ${iExpectedRate_%}    ${spread_Conv_Backdated_Day_With_0}    ${spread_Conv_Backdated_Day}
    mx LoanIQ activate window    ${LIQ_FundingRatesDetails_Window}    
    mx LoanIQ click    ${eHistoryButtonLocator}
    ## SPECIFIC COMPUTATION FOR HISTORY
    Log    rate:${iExpectedRate}
   
    ${iExpectedRate}     Convert To String    ${iExpectedRate} 
    ${status}    Run Keyword And Return Status   Should Match Regexp    ${iExpectedRate}    ^\s*(?=.*[1-9])\\d*(?:\.\\d{1,1})?\s*$
    ${zero}    Fetch From Right    ${iExpectedRate}    .
    ${zeroDecimal_status}    Run Keyword And Return Status    Should Be Equal As Strings    ${zero}    0
    
    ${iExpectedRate_%}    ${spread_rate}    Run Keyword If    '${status}'=='True' and '${zeroDecimal_status}'=='True'  Convert to Whole Number    ${iExpectedRate}
    ...    ELSE IF    '${zeroDecimal_status}'=='False' and '${status}'=='True'    Compute Rate Percentage 6 Decimal Places    ${iExpectedRate}
    ...    ELSE IF    '${zeroDecimal_status}'=='False' and '${status}'=='False'   Compute Rate Percentage 6 Decimal Places    ${iExpectedRate}
    ${spread_rate}    Convert To String    ${spread_rate}
    Log    strings ${sConv_Date_With_0} - ${spread_rate}
    mx LoanIQ activate window    JavaWindow("title:=Funding Rate.*Spread.*History.*")
    ${spreadrate}    Strip String    ${SPACE}${spread_rate}${SPACE}        
               
    # ${iExpectedRate_%}    ${spread_rate}    Run Keyword If    ${status}==${False}    Compute Rate Percentage 6 Decimal Places    ${iExpectedRate}
     
    ## CONDITION TO CHECK IF HAS END DATE OR NONE.
    ${hasNoEndDate}    Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${eHistoryTreeLocator}    ${sConv_Date_With_0}\t""\t${spreadrate}
    Run Keyword If    '${hasNoEndDate}'=='True'         Mx LoanIQ DoubleClick    ${eHistoryTreeLocator}    ${sConv_Date_With_0}\t""\t${spreadrate}   
    ## PLEASE ENTER NEW RATE WINDOW WILL SHOW AND VALIDATE THE DETAILS
    ${Actual_New_Rate}    Run Keyword And Continue On Failure   Mx LoanIQ Get Data     ${LIQ_SpreadHistory_NewRate_Spread_Textfield}    input=Actual_New_Rate
    Run Keyword If    '${iExpectedRate_%}'=='${Actual_New_Rate}'    Log    New Spread Rate is correct: ${Actual_New_Rate}.
    ...    ELSE    Log    New Spread Rate in History Table does not match. Expected value: ${iExpectedRate_%}.
    ${Actual_Effective_Date}    Mx LoanIQ Get Data     JavaWindow("title:=Please Enter New Value.*").JavaEdit("tagname:=Text","value:=${sConv_Date_With_0}.*")    input=Actual_Effective_Date
    Run Keyword If    '${Actual_Effective_Date}'=='${sConv_Date_With_0}'    Log    Effective Date is correct: ${Actual_Effective_Date}.
    ...    ELSE    Log    Latest Start Date in History Table is does not match. Expected value: ${sConv_Date_With_0}.  
    
    ${Actual_End_Date_Empty}       Run Keyword And Return Status    Mx LoanIQ Verify Object Exist     JavaWindow("title:=Please Enter.*New.*Value.*").JavaEdit("attached text:=","text:=")    VerificationData="Yes"
    Run Keyword If    '${Actual_End_Date_Empty}'=='True'    Log    Spread Rate of ${iExpectedRate_%} in History Table has no End date.
    mx LoanIQ click    ${LIQ_SpreadHistory_NewRate_Cancel_Btn}
    
    ## PRE-CHECK PREVIOUS DATE
    mx LoanIQ activate    ${LIQ_SpreadHistory_Window}
    ${previous_StartDate}         Mx LoanIQ Store TableCell To Clipboard    ${eHistoryTreeLocator}    ${spread_Conv_Backdated_Day_With_0}%Start Date%previous_SRstartDate    10    
    ${previous_SpreadRate}        Mx LoanIQ Store TableCell To Clipboard    ${eHistoryTreeLocator}    ${spread_Conv_Backdated_Day_With_0}%Spread%previous_SpreadRate    10
    
    Log    Previous Start Date: ${previous_StartDate}.
    Log    Previous Rate: ${previous_SpreadRate}.    
    Run Keyword If    '${previous_StartDate}'=='' and '${previous_SpreadRate}'==''    Run Keywords  mx LoanIQ click    ${LIQ_SpreadHistory_Cancel_Btn}    
    ...    AND    Log    No Previous History Shown.
    ...    ELSE    Verify Previous Spread Record in History Table in Funding Rate    ${eHistoryTreeLocator}    ${previous_StartDate}    ${spread_Conv_Backdated_Day_With_0}    ${previous_SpreadRate}  

    
Verify Previous Spread Record in History Table in Funding Rate
    [Documentation]    This keyword verifies if there's previous spread rate record on the history table in Funding Rates.
    ...    @author: cmartill
    [Arguments]    ${eHistoryTreeLocator}    ${previous_startDate}    ${sBackdated_With_0}    ${previous_Rate}
    
    ${rate%}    ${rate}    Compute Rate Percentage 6 Decimal Places    ${previous_Rate}    
    
    ${hasPreviousRow}      Run Keyword And Return Status    Run Keyword And Continue On Failure    Mx LoanIQ Select String    ${eHistoryTreeLocator}    ${previous_startDate}\t${sBackdated_With_0}\t${previousRate}
    Run Keyword If    '${hasPreviousRow}'=='True'    Mx LoanIQ DoubleClick    ${eHistoryTreeLocator}    ${previous_startDate}\t${sBackdated_With_0}\t${previous_Rate}
    
    ${Actual_Previous_Rate}    Run Keyword And Continue On Failure   Mx LoanIQ Get Data     ${LIQ_SpreadHistory_NewRate_Spread_Textfield}    input=Actual_Previous_Rate
    Run Keyword If    '${rate%}'=='${Actual_Previous_Rate}'    Log    Expected Previous Spread Rate: ${rate%} is equal to Actual Previous Spread Rate : ${Actual_Previous_Rate}.
    ...    ELSE    Log    Previous Rate in History Table does not match. Expected value: ${previous_Rate}.
    
    ${Actual_Previous_Start_Date}    Mx LoanIQ Get Data     JavaWindow("title:=Please Enter New.*Value.*").JavaEdit("tagname:=Text","value:=${previous_startDate}.*")    input=Actual_Previous_Start_Date
    Run Keyword If    '${Actual_Previous_Start_Date}'=='${previous_startDate}'    Log    Expected Previous Spread Start Date: ${previous_startDate} is equal to Actual Previous Spread Start Date: ${Actual_Previous_Start_Date}. 
    ...    ELSE    Log    Previous Start Date in History Table is does not match. Expected value: ${previous_startDate}.  
    
    ${Actual_Previous_End_Date_NotEmpty}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist     JavaWindow("title:=Please Enter New.*Value.*").JavaEdit("tagname:=Text","text:=${sBackdated_With_0}")    VerificationData="Yes"
    ${Previous_Spread_End_Date}    Run Keyword If    '${Actual_Previous_End_Date_NotEmpty}'=='True'    Run Keywords    Mx LoanIQ Get Data     JavaWindow("title:=Please Enter New.*Value.*").JavaEdit("text:=${sBackdated_With_0}")    input=Previous_Spread_End_Date
    ...    AND    Log    Previous End Date of Spread is correct. Expected: ${sBackdated_With_0}.
    ...    ELSE    Log    Previous End Date of Spread in History Table does not match. Expected value: ${sBackdated_With_0}. 
    mx LoanIQ click    ${LIQ_SpreadHistory_NewRate_Cancel_Btn}
    mx LoanIQ click    ${LIQ_SpreadHistory_Cancel_Btn}

Validate Events Table without Content
    [Documentation]    Initial Create
    ...    @update: jdelacru    14FEB2020    - Added Click Elemement If Present for Funding History Cancel Button
    ...    @update: ehugo    22JUN2020    - added dataset_path for tem.txt
    Mx Click Element If Present    ${LIQ_FundHistory_Cancel_Btn}
    mx LoanIQ activate window    ${LIQ_FundingRatesDetails_Window}
    mx LoanIQ click    ${LIQ_FundEvents_Btn}    
    mx LoanIQ activate window    ${LIQ_FundingEvents_Window}
    
    Delete File If Exist     ${dataset_path}${Input_File_Path_BaseRates}tem.txt
    Create File    ${dataset_path}${Input_File_Path_BaseRates}tem.txt    
    Mx LoanIQ Copy Content And Save To File    ${LIQ_FundingEventsList_Tree_Field}    ${dataset_path}${Input_File_Path_BaseRates}tem.txt
    ${test1}    OperatingSystem.Get File    ${dataset_path}${Input_File_Path_BaseRates}tem.txt
    ${linecount}    Get Line Count    ${test1}
    Run Keyword If    ${linecount}==1    mx LoanIQ click    ${LIQ_FundingEvents_Exit_Btn}
    [Return]    ${linecount}
    
Validate Events Rate Record in Events Table in Funding Rate
    [Documentation]    This keyword verifies the record of the events on the events list.
    ...    @update: jdelacru    14FEB2020    - removed number arguments for Store Table Cell Value and Select String keywords
    [Arguments]    ${eLocatorTree}    ${rate_converted_date_with_0}    ${spread_converted_date_with_0}    ${intrate}    ${spreadrate}
    mx LoanIQ activate window    ${LIQ_FundingEvents_Window}
    ${rate_%}        Run Keyword If    '${intrate}'!='None'       Compute Rate Percentage 5 Decimal Places    ${intrate}
    ...    ELSE    Fail    Interest Rate is incorrect.
    ${baserate%}      Convert To String    ${rate_%}
    ${rate}=    Run Keyword If    '${rate%}'!='None'    Remove String    ${baserate%}    %
    ${rate_comment}    Run Keyword And Continue On Failure    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_FundingEventsList_Tree_Field}    ${rate_converted_date_with_0}%Comment%rate_comment
    Log    value: ${rate_comment}
    ${rate_event_status}    Run Keyword And Return Status    Should Contain    ${rate_comment}    ${baserate%}
    Run Keyword If    '${rate_event_status}'=='True'    Run Keywords    Mx LoanIQ Select String    ${LIQ_FundingEventsList_Tree_Field}    ${rate_converted_date_with_0}\tFunding Rate changed to ${rate}    
    ...    AND    Log    Funding Rate changed to ${baserate%} beginning ${rate_converted_date_with_0}.
    Run Keyword If    '${rate_event_status}'=='False'    Log    Funding Rate changed to ${baserate%} beginning ${rate_converted_date_with_0} does not exists in Events Table.
    mx LoanIQ click    ${LIQ_FundingRatesEvents_Exit_Button}
    mx LoanIQ click    ${LIQ_FundingRatesDetails_Exit_Button}    
    mx LoanIQ activate    ${LIQ_FundingRates_Window}
    
Validate Events Spread Record in Events Table in Funding Rate
    [Documentation]    This keyword verifies the record of the events on the events list.
    [Arguments]    ${spread_converted_date_with_0}    ${spreadrate} 
    mx LoanIQ activate window    ${LIQ_FundingEvents_Window}
    Log    Spread Rate: ${spreadrate}
    Log    Spread EffectiveDate: ${spread_converted_date_with_0}
    
    ${status_spreadRate}    Run Keyword And Return Status    Should Be Equal    ${spreadrate}    None  Log    Spread Rate is Null
    ${status_spreadEffectiveDate}    Run Keyword And Return Status    Should Be Equal    ${spread_converted_date_with_0}    None    Log    Spread Effective Date is Null
        
    Run Keyword If    ${status_spreadRate}==${True} and ${status_spreadEffectiveDate}==${True}       Run Keywords    Log    Spread Rate is Null/Empty. Hence, it will not reflect in Events Table.
    ...    AND    mx LoanIQ click     ${LIQ_FundingEvents_Exit_Btn}    
    Run Keyword If    ${status_spreadRate}==${False} and ${status_spreadEffectiveDate}==${False}     Validate Spread Rate and Spread Effective Date Not Null in Events Table    ${spreadrate}    ${spread_converted_date_with_0}    
    mx LoanIQ click    ${LIQ_FundingRatesEvents_Exit_Button}
    mx LoanIQ click    ${LIQ_FundingRatesDetails_Exit_Button}    
    mx LoanIQ activate    ${LIQ_FundingRates_Window}
     
Validate Spread Rate and Spread Effective Date Not Null in Events Table
    [Documentation]    This keyword verifies the record of spread rate and spread effective date on the events list.
    [Arguments]    ${spreadrate}    ${spread_converted_date_with_0}
    ${spreadrate_%}    Compute Rate Percentage 5 Decimal Places    ${spreadrate}
    ${spreadrate%}    Convert To String    ${spreadrate_%}
    ${spread_rate}=    Run Keyword If    '${spreadrate%}'!='None'    Remove String    ${spreadrate%}    %
    
    ${status_select}    Run Keyword And Return Status   Mx LoanIQ Select String    ${LIQ_FundingEventsList_Tree_Field}    ${spread_converted_date_with_0}\tFunding Rate Spread changed to ${spreadrate}   
    Run Keyword If    '${status_select}'=='True'    Run Keywords    Log    Funding Rate Spread changed to ${spreadrate%} beginning ${spread_converted_date_with_0} exists in the Events Table.
    ...    AND    mx LoanIQ click    ${LIQ_FundingEvents_Exit_Btn}

    Run Keyword If    '${status_select}'=='False'  mx LoanIQ click    ${LIQ_FundingEvents_Exit_Btn}
    ...    ELSE    Log    Funding Rate Spread changed to ${spreadrate%} beginning ${spread_converted_date_with_0} does not exist in the Events Table.                 
 
Get Base Rate from Funding Rate Details
     [Documentation]    This keyword gets the Base Rate value from the "Funding Rate Details" window using the Base Rate Code, Repricing Frequency and Currency
     ...    @author: bernchua    05APR2019    - initial create
     ...    @update: sahalder    09JUL2020    Added keyword pre-processing steps    
     [Arguments]        ${sBaseRateCode}    ${sRepricingFrequency}    ${sCurrency}
     
     ### GetRuntime Keyword Pre-processing ###
	 ${BaseRateCode}    Acquire Argument Value    ${sBaseRateCode}
	 ${RepricingFrequency}    Acquire Argument Value    ${sRepricingFrequency}
	 ${Currency}    Acquire Argument Value    ${sCurrency}   

     Select Treasury Navigation    Funding Rates 
     mx LoanIQ activate    ${LIQ_FundingRates_Window}
     Mx LoanIQ DoubleClick    ${LIQ_BaseRate_Table_Row}    ${BaseRateCode}\tAustralian (Sydney)\t${RepricingFrequency}\t${Currency}
     Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/FundingRates_BaseRates
     ${BaseRatePercentage}    Mx LoanIQ Get Data    ${LIQ_FundingRateDetails_Rate_Text}    value%rate
     Close All Windows on LIQ
     [Return]    ${BaseRatePercentage}
     
Get Currency Exchange Rate from Treasury Navigation
    [Documentation]    This keyword gets the Currency Exchange Rate from the Treasury Navigation > Currency Exchange Rate
    ...                @author: bernchua    12APR2019    - initial create
    [Arguments]        ${sCurrencyExchange}
    Select Treasury Navigation    Currency Exchange Rates
    mx LoanIQ activate    ${LIQ_CurrencyExchangeRate_Window}
    Mx LoanIQ DoubleClick    ${LIQ_CurrencyExchangeRate_Tree}    ${sCurrencyExchange}
    ${BaseRatePercentage}    Mx LoanIQ Get Data    ${LIQ_ExchangeRate_Field}    value%rate
    Close All Windows on LIQ
    [Return]    ${BaseRatePercentage}
