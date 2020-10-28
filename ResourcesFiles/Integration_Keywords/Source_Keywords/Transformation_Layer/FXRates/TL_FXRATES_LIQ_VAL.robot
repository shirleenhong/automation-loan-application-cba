*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot


*** Keywords ***
Validate FXRate in LoanIQ
    [Documentation]    This keyword is used to validate FX Rates in LoanIQ
    ...    @author: mnanquil    18MAR19    initial draft
    ...    @update: cfrancis    18JUL19    added logic to run Validate Currency Pairs only if Funding Desk Currency is AUD
    ...    @update: nbautist    08OCT20    replaced loan iq activation keyword to remove dependency on visibility while running test
    ...    @update: ccarriedo   27OCT20    added '${subEntity}'=='EUR' in start if pre-requisite and compute for FX rate, and added '${Funding_Desk_Currency}'=='EUR' in validate currency pair if existing steps
    [Arguments]    ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}
    ###START OF PRE-REQUISITES###
    ${Exchange_Currency}    Run Keyword If    '${subEntity}'=='AUD'    Catenate    ${From_Currency}    to    ${To_Currency}
    ...    ELSE IF    '${subEntity}'=='NY'    Catenate    ${To_Currency}    to    ${From_Currency}
    ...    ELSE IF    '${subEntity}'=='EUR'    Catenate    ${From_Currency}    to    ${To_Currency}
    ${Exchange_Currency_Global}    Set Variable    ${Exchange_Currency}
    Set Global Variable    ${Exchange_Currency_Global}  
    ###compute for FX rate###
    ${FXRate_float}    Compute for FX Rate from Mid Rate    ${Mid_Rate}
    ${FX_Rate_no_0}    ${FXRate_whole_no_0}    ${FXRate_dec_no_0}    Run Keyword If    '${subEntity}'=='AUD'    Convert Mid Rate    ${Mid_Rate}
    ...    ELSE IF    '${subEntity}'=='NY'    Get Significant Mid Rate    ${Mid_Rate}
    ...    ELSE IF    '${subEntity}'=='EUR'    Convert Mid Rate    ${Mid_Rate}
    ### convert days to be used in execution###
    ${Conv_Eff_Date_With_0}    Convert Date    ${Effective_Date}    result_format=%d-%b-%Y
    ${Backdated_Day}    Subtract Time From Date    ${Effective_Date}    1 d
    ${Conv_Backdated_Day_With_0}    Convert Date    ${Backdated_Day}    result_format=%d-%b-%Y
    ${Conv_Backdated_Day}=    Convert Date    ${Backdated_Day}    result_format=%#d-%b-%Y
    ${Effective_Date_Global}    Set Variable    ${Conv_Eff_Date_With_0}
    Set Global Variable    ${Effective_Date_Global}    
    # refresh table
    Mx LoanIQ Activate Window    ${LIQ_Window}
    Mx LoanIQ Select    ${LIQ_Options_RefreshAllCodeTables}
    Mx LoanIQ Click    ${LIQ_Warning_Yes_Button}
    # get funding details in LIQ
    ${Funding_Desk_Desc}    ${Funding_Desk_Currency}    Get Funding Desk Details from Table Maintenance    ${subEntity}
    # validate currency pair if existing
    Run Keyword If    '${Funding_Desk_Currency}'=='AUD'    Validate Currency Pairs    ${To_Currency}    ${From_Currency}
    ...    ELSE IF    '${Funding_Desk_Currency}'=='EUR'    Validate Currency Pairs By Funding Desk    ${To_Currency}    ${From_Currency}    ${Funding_Desk_Currency}
    ###END OF PRE-REQUISITES###
    # TREASURY NAVIGATION WINDOW
    Select Treasury Navigation    Currency Exchange Rates
    #CURRENCY EXCHANGE RATES LIST WINDOW
    Run Keyword And Continue On Failure    Validate Currency Exchange Rate List is displayed    ${Exchange_Currency}    ${To_Currency}    ${Funding_Desk_Desc}    ${Funding_Desk_Currency}    ${FXRate_whole_no_0}     ${FXRate_dec_no_0}
    # PLEASE ENTER CURRENCY EXCHANGE RATE WINDOW
    Run Keyword And Continue On Failure    Validate Specific Currency Exchage Rate    ${Exchange_Currency}    ${To_Currency}    ${Funding_Desk_Desc}    ${Funding_Desk_Currency}    ${FX_Rate_no_0}    ${FXRate_whole_no_0}     ${FXRate_dec_no_0}   
    # CURRENCY EXCHANGE RATE EVENTS LIST
    Run Keyword And Continue On Failure    Validate Rate Events List    ${Conv_Eff_Date_With_0}    ${FX_Rate_no_0}
    # CROSS CURRENCY RATE HISTORY WINDOW
    Run Keyword And Continue On Failure    Validate Rate History table    ${Conv_Eff_Date_With_0}    ${FX_Rate_no_0}         
    # SET RATE HISTORY WINDOW
    Run Keyword And Continue On Failure    Validate Specific History Row    ${Conv_Eff_Date_With_0}    ${FX_Rate_no_0}    ${Conv_Backdated_Day_With_0}    ${Conv_Backdated_Day}
    Close All Windows on LIQ
    
Validate FXRate Not Updated in LoanIQ
    [Documentation]    This keyword is used to validate FX Rates in LoanIQ does not contain the new rate expected
    ...    @author: cfrancis    07AUG19    initial create
    [Arguments]    ${From_Currency}    ${To_Currency}    ${subEntity}    ${Mid_Rate}    ${Effective_Date}
    ###START OF PRE-REQUISITES###
    ${Exchange_Currency}    Run Keyword If    '${subEntity}'=='AUD'    Catenate    ${From_Currency}    to    ${To_Currency}
    ...    ELSE IF    '${subEntity}'=='NY'    Catenate    ${To_Currency}    to    ${From_Currency}
    ${Exchange_Currency_Global}    Set Variable    ${Exchange_Currency}
    Set Global Variable    ${Exchange_Currency_Global}  
    ###compute for FX rate###
    ${FXRate_float}    Compute for FX Rate from Mid Rate    ${Mid_Rate}
    ${FX_Rate_no_0}    ${FXRate_whole_no_0}    ${FXRate_dec_no_0}    Run Keyword If    '${subEntity}'=='AUD'    Convert Mid Rate    ${Mid_Rate}
    ...    ELSE IF    '${subEntity}'=='NY'    Get Significant Mid Rate    ${Mid_Rate}
   ### convert days to be used in execution###
    ${Conv_Eff_Date_With_0}    Convert Date    ${Effective_Date}    result_format=%d-%b-%Y
    ${Backdated_Day}    Subtract Time From Date    ${Effective_Date}    1 d
    ${Conv_Backdated_Day_With_0}    Convert Date    ${Backdated_Day}    result_format=%d-%b-%Y
    ${Conv_Backdated_Day}=    Convert Date    ${Backdated_Day}    result_format=%#d-%b-%Y
    ${Effective_Date_Global}    Set Variable    ${Conv_Eff_Date_With_0}
    Set Global Variable    ${Effective_Date_Global}    
    # refresh table
    mx LoanIQ activate    ${LIQ_Window}    
    mx LoanIQ select    ${LIQ_Options_RefreshAllCodeTables}
    mx LoanIQ click    ${LIQ_Warning_Yes_Button}
    # get funding details in LIQ
    ${Funding_Desk_Desc}    ${Funding_Desk_Currency}    Get Funding Desk Details from Table Maintenance    ${subEntity}
    # validate currency pair if existing
    Run Keyword If    '${Funding_Desk_Currency}'=='AUD'    Validate Currency Pairs    ${To_Currency}    ${From_Currency}
    ###END OF PRE-REQUISITES###
    # TREASURY NAVIGATION WINDOW
    Select Treasury Navigation    Currency Exchange Rates
    #CURRENCY EXCHANGE RATES LIST WINDOW
    Run Keyword And Continue On Failure    Validate Currency Exchange Rate is Not Displayed in List    ${Exchange_Currency}    ${To_Currency}    ${Funding_Desk_Desc}    ${Funding_Desk_Currency}    ${FXRate_whole_no_0}     ${FXRate_dec_no_0}
    Close All Windows on LIQ
