*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Enter Interest Capitalization Details
     [Documentation]    This keyword is used to enter Interest Capitalization details
    ...    @author: ghabal
    ...    @update: jdelacru    05MAR2019    - Unchecking Allow Capitalization Over Facility Limit and Capitalization Frequency Applies
    ...    @update: sahalder    28MAY2020    - Added logic to handle the checkbox, Added Take Screenshot
    [Arguments]    ${s_Capitalization_Frequency}    ${s_From_Date}    ${s_To_Date}    ${s_Loan_Alias}    ${s_Checkbox_AllowCapitalizationOverFacilityLimit_Status}    ${s_Checkbox_CapitalizationFrequencyApplies_Status}
    
    ### GetRuntime Keyword Pre-processing ###
    ${Capitalization_Frequency}    Acquire Argument Value    ${s_Capitalization_Frequency}
    ${sFrom_Date}    Acquire Argument Value    ${s_From_Date}
    ${sTo_Date}    Acquire Argument Value    ${s_To_Date}
    ${sLoan_Alias}    Acquire Argument Value    ${s_Loan_Alias}
    ${Checkbox_AllowCapitalizationOverFacilityLimit_Status}    Acquire Argument Value    ${s_Checkbox_AllowCapitalizationOverFacilityLimit_Status}
    ${Checkbox_CapitalizationFrequencyApplies_Status}    Acquire Argument Value    ${s_Checkbox_CapitalizationFrequencyApplies_Status}
	
    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_InterestCapitalization}
    
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    
    Mx LoanIQ Set    ${LIQ_InterestCapitalization_ActiveInterestCapitalization_Checkbox}    ON
    
    mx LoanIQ enter    ${LIQ_InterestCapitalization_FromDate_DateField}    ${sFrom_Date}
    mx LoanIQ enter    ${LIQ_InterestCapitalization_ToDate_DateField}    ${sTo_Date}    
    
    ${LaonToCapitalize}    Mx LoanIQ Get Data    ${LIQ_InterestCapitalization_CapitalizeFrom_TextField}    LaonToCapitalize
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestCapitalization_ToLoan_DropdownList}    ${LaonToCapitalize}
    
    Run Keyword If   '${Checkbox_AllowCapitalizationOverFacilityLimit_Status}'=='Tick'    Mx LoanIQ Set    ${LIQ_InterestCapitalization_AllowCapitalizationOverFacilityLimit_Checkbox}    ON
    Run Keyword If   '${Checkbox_CapitalizationFrequencyApplies_Status}'=='Tick'    Mx LoanIQ Set    ${LIQ_InterestCapitalization_CapitalizationFrequencyApplies_Checkbox}    ON
    Run Keyword If   '${Checkbox_CapitalizationFrequencyApplies_Status}'=='Tick'    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestCapitalization_CapitalizationFrequency_DropdownList}    ${Capitalization_Frequency}
      
    mx LoanIQ click    ${LIQ_InterestCapitalization_OKButton}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanInterest_Capitalization_details1    
    
Enter Capitalize Interest Details
     [Documentation]    This keyword is used to enter Capitalize Interest details
    ...    @author: ghabal
    ...    @update: fmamaril    07MAY2019    Remove writing on low level keyword
    ...    @update: sahalder    28MAY2020    Removed sleep and added page synchronization keyword, Added Take Screenshot
    [Arguments]        ${s_LoanCapitalization_FromDate}    ${s_LoanCapitalization_ToDate}    ${s_PercentofPayment}
    
    ### GetRuntime Keyword Pre-processing ###
    ${LoanCapitalization_FromDate}    Acquire Argument Value    ${s_LoanCapitalization_FromDate}
    ${LoanCapitalization_ToDate}    Acquire Argument Value    ${s_LoanCapitalization_ToDate}
    ${PercentofPayment}    Acquire Argument Value    ${s_PercentofPayment}

    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ click element if present    ${LIQ_Loan_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_CapitalizeInterest} 
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button} 
    Mx LoanIQ Set    ${LIQ_InterestCapitalization_ActiveInterestCapitalization_Checkbox}    ON    
    mx LoanIQ enter    ${LIQ_InterestCapitalization_FromDate_DateField}    ${LoanCapitalization_FromDate}    
    mx LoanIQ enter    ${LIQ_InterestCapitalization_ToDate_DateField}    ${LoanCapitalization_ToDate}
    mx LoanIQ enter    ${LIQ_InterestCapitalization_PercentofPayment_InputField}    ${PercentofPayment}    
    ${CapitalizeFrom_Value}    Mx LoanIQ Get Data    ${LIQ_InterestCapitalization_CapitalizeFrom_TextField}    textdata
    Log    ${CapitalizeFrom_Value}
    Mx LoanIQ Select Combo Box Value    ${LIQ_InterestCapitalization_ToLoan_DropdownList}    ${CapitalizeFrom_Value}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanInterest_Capitalization_details2
    Wait Until Keyword Succeeds    10    5    mx LoanIQ click    ${LIQ_InterestCapitalization_OKButton}
    [RETURN]    ${CapitalizeFrom_Value}        
    
Validate Capitalize Interest Details
     [Documentation]    This keyword is used to validate Capitalize Interest details
    ...    @author: ghabal
    ...    @update: fmamaril    07MAY2019    Remove unnecessary spaces
    ...    @update: sahalder    28MAY2019    Added Runtime Keyword Pre-processing steps, Added Take Screenshot
    [Arguments]    ${s_LoanCapitalization_FromDate}    ${s_LoanCapitalization_ToDate}    ${s_PercentofPayment}    ${s_CapitalizeFromToLoan_Value}
    
    ### GetRuntime Keyword Pre-processing ###
    ${LoanCapitalization_FromDate}    Acquire Argument Value    ${s_LoanCapitalization_FromDate}
    ${LoanCapitalization_ToDate}    Acquire Argument Value    ${s_LoanCapitalization_ToDate}
    ${PercentofPayment}    Acquire Argument Value    ${s_PercentofPayment}
    ${CapitalizeFromToLoan_Value}    Acquire Argument Value    ${s_CapitalizeFromToLoan_Value}

    mx LoanIQ activate window    ${LIQ_InitialDrawdown_Window}
    mx LoanIQ click element if present    ${LIQ_Loan_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_InitialDrawdown_Options_CapitalizeInterest}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Validate if Element is Checked    ${LIQ_InterestCapitalization_ActiveInterestCapitalization_Checkbox}    Activate Interest Capitalization
    Validate Loan IQ Details    ${LoanCapitalization_FromDate}    ${LIQ_InterestCapitalization_FromDate_DateField}
    Validate Loan IQ Details    ${LoanCapitalization_ToDate}    ${LIQ_InterestCapitalization_ToDate_DateField}
    ${LIQ_InterestCapitalization_PercentofPayment_InputField}    Mx LoanIQ Get Data    ${LIQ_InterestCapitalization_PercentofPayment_InputField}    textdata
    Should Be Equal As Strings    ${LIQ_InterestCapitalization_PercentofPayment_InputField}    ${PercentofPayment}       
    Validate Loan IQ Details    ${CapitalizeFromToLoan_Value}    ${LIQ_InterestCapitalization_ToLoan_DropdownList}
    mx LoanIQ click    ${LIQ_InterestCapitalization_OKButton}
    mx LoanIQ select    ${LIQ_InitialDrawdown_FileMenu_Save}
    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    mx LoanIQ select    ${LIQ_InitialDrawdown_FileMenu_Exit}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/LoanInterest_Capitalization_Validate
