*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Compute SBLC Issuance Fee Amount Per Cycle
    [Documentation]    This keyword is used in computing the first Projected Cycle Due of the SBLC Issuance Fee and saves it to Excel.
    ...    Note that SystemDate is important for the computation, if you are going to pay Cycle Due use LIQ SystemDate
    ...    If you are going to pay for Projected Due, use Cycle Due Date instead
    ...    @author: bernchua
    ...    @update: fmamaril    29APR2019    Modify computation to cater to any type of Cycle
    ...    @update: ritragel    02SEP2019    Updated documentation
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing and post-processing; added optional runtime argument; added screenshot
    ...    @update: clanding    21JUL2020    - removed commented codes for Evaluate Issuance Fee for Quarterly Cycle
    [Arguments]    ${sCycleNumber}    ${sSystemDate}    ${sRunTimeVar_ProjectedCycleDue}=None    ${sAccrualRule}=None

    ### GetRuntime Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${sCycleNumber}
    ${SystemDate}    Acquire Argument Value    ${sSystemDate}
    ${AccrualRule}    Acquire Argument Value    ${sAccrualRule}

    mx LoanIQ activate    ${LIQ_SBLCGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Tab}    General
    ${iGlobalOriginal}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_GlobalOriginal_StaticText}    value%test
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Tab}    Rates
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_Rate_StaticText}    value%test
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_RateBasis_Combobox}    value%test
    ${iGlobalOriginal}    Remove String    ${iGlobalOriginal}    ,
    ${iGlobalOriginal}    Convert To Number    ${iGlobalOriginal}
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Integer    ${RateBasis}
    ${ProjectedCycleDue}    Evaluate Issuance Fee    ${iGlobalOriginal}    ${Rate}    ${RateBasis}    ${CycleNumber}    ${SystemDate}    ${AccrualRule}
    Log    Projected Cycle Due: ${ProjectedCycleDue}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCGuaranteeWindow_RatesTab_SBLCIssuanceFeeAmount

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ProjectedCycleDue}    ${ProjectedCycleDue}

    [Return]    ${ProjectedCycleDue}

# Evaluate Issuance Fee for Weekly Cycle
    # [Documentation]    This keyword evaluates the FIRST Projected Cycle Due on a 'Weekly' cycle.
    # ...    @author: bernchua
    # [Arguments]    ${PrincipalAmount}    ${Rate}    ${RateBasis}
    # ${Time}    Set Variable    7
    # ${Time}    Convert To Integer    ${Time}
    # ${ProjectedCycleDue}    Evaluate    (((${PrincipalAmount})*(${Rate}))*(${Time}))/${RateBasis}
    # ${ProjectedCycleDue}    Convert To Number    ${ProjectedCycleDue}    2
    # [Return]    ${ProjectedCycleDue}

Evaluate Issuance Fee
    [Documentation]    This keyword evaluates the Issuance Fee on bank Guarantee.
    ...    Note that SystemDate is important for the computation, if you are going to pay Cycle Due use LIQ SystemDate
    ...    If you are going to pay for Projected Due, use Cycle Due Date instead
    ...    @author: fmamaril
    ...    @update: ritragel    02SEP2019    Updated documentation
    ...    @update: ritragel    17SEP2020    Setting Default value as Due Date then adding an Option for End Date
    [Arguments]    ${iGlobalOriginal}    ${Rate}    ${RateBasis}    ${CycleNumber}    ${SystemDate}    ${sAccrualRule}=Pay in Arrears    
 
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Tab}    Accrual
    ${StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${CycleNumber}%Start Date%startdate
    ${AccrualRuleDate}    Run Keyword If    '${sAccrualRule}'=='Pay in Arrears'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${CycleNumber}%Due Date%duedate
    ...    ELSE IF    '${sAccrualRule}'=='Pay In Advance'    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${CycleNumber}%End Date%enddate
    Log    ${StartDate}
    Log    ${AccrualRuleDate}
    ${SystemDate}    Convert Date    ${SystemDate}     date_format=%d-%b-%Y
    ${StartDate}    Convert Date    ${StartDate}     date_format=%d-%b-%Y
    ${AccrualRuleDate}    Convert Date    ${AccrualRuleDate}     date_format=%d-%b-%Y
    
    ${NumberofDays}    Subtract Date From Date    ${AccrualRuleDate}    ${StartDate}    verbose
    Log    ${NumberofDays}
    
    ${NumberofDays}    Remove String    ${NumberofDays}     days    seconds    day
    ${NumberofDays}    Convert To Number    ${NumberofDays}
    ${NumberofDays}    Evaluate    ${NumberofDays}+1
    
    Log    ${Rate}
    Log    ${RateBasis}
    Log    ${iGlobalOriginal}
    
    ${ProjectedCycleDue}    Evaluate    (((${iGlobalOriginal}*${Rate})*${NumberofDays})/${RateBasis})
    ${ProjectedCycleDue}    Convert To Number    ${ProjectedCycleDue}    2

    [Return]    ${ProjectedCycleDue}

Navigate Existing Standby Letters of Credit
    [Documentation]    This keyword navigates the "Existing Standby Letters of Credit..." window and selects an existing SBLC/Guarantee.
    ...    @author: bernchua
    ...    @update: ehugo    02JUN2020    - added keyword pre-processing; added screenshot
    [Arguments]    ${sSBLC_Alias}

    ### GetRuntime Keyword Pre-processing ###
    ${SBLC_Alias}    Acquire Argument Value    ${sSBLC_Alias}

    mx LoanIQ activate    ${LIQ_ExistingStandbyLettersOfCredit_Window}
    mx LoanIQ enter    ${LIQ_ExistingStandbyLettersOfCredit_OpenNotebookInUpdateMode_Checkbox}    ON
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_ExistingStandbyLettersOfCredit_Tree}    ${SBLC_Alias}%d

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ExistingStandbyLettersOfCreditWindow_SelectExistingSBLC

Navigate To Fees On Lender Shares
    [Documentation]    This keyword navigates the SBLC/Guarantee Notebook and clicks "Fee On Lender shares" in the Payments menu.
    ...    @author: bernchua
    ...    @update: ehugo    02JUN2020    - added screenshot

    mx LoanIQ activate    ${LIQ_SBLCGuarantee_Window}
    ${InquiryMode_Enabled}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_SBLCGuarantee_InquiryMode_Button}        VerificationData="Yes"
    Run Keyword If    ${InquiryMode_Enabled}==True    mx LoanIQ click    ${LIQ_SBLCGuarantee_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_SBLCGuarantee_Payments_FeesOnLenderShares}
    mx LoanIQ activate    ${LIQ_CyclesForBankGuarantee_Window}

    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CyclesForBankGuaranteeWindow

Store Borrower Alias To Excel
    [Documentation]    This keyword stores and saves to Excel the Borrower Alias from the SBLC/Guarantee Notebook's General tab.
    ...    @author: bernchua
    [Arguments]    ${ExcelPath}    ${SheetName}    ${column}    ${row}
    Open Excel Document    ${ExcelPath}    0
    mx LoanIQ activate    ${LIQ_SBLCGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Tab}    General
    ${Borrower_Alias}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_Alias_StaticText}    label%text
    Write Data To Excel    ${SheetName}    ${column}    ${row}    ${Borrower_Alias}
    Save Excel Document    ${ExcelPath}

Get Projected Cycle Due From SBLC Cycles
    [Documentation]    This keyword stores and saves to Excel the FIRST cycle 'Projected Cycle Due' amount in the "Cycles for Bank Guarantee/Letter of Credit/Synd Fronted Bank" window.
    ...    @author: bernchua
    mx LoanIQ activate    ${LIQ_CyclesForBankGuarantee_Window}
    :FOR    ${i}    IN RANGE    5
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CyclesForBankGuarantee_Tree}    2%Projected Cycle Due%test
    \    ${ProjectedCycleDue}    Run Keyword If    ${status}==True    Run Keyword And Continue On Failure
         ...    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_CyclesForBankGuarantee_Tree}    2%Projected Cycle Due%test
    \    ${ProjectedCycleDue_NotEmpty}    Run Keyword And Return Status    Should Not Be Equal    ${ProjectedCycleDue}    ${EMPTY}
    \    Exit For Loop If    ${status}==True and ${ProjectedCycleDue_NotEmpty}==True and '${ProjectedCycleDue}'!='None'
    Log    ${ProjectedCycleDue}

Search for Deal
    [Documentation]    This keyword will search for a specific deal
    ...    @author: ritragel
    ...    @update: Archana    11JUN2020    - Added pre-processing keyword
    ...                                     - Removed commented lines
    ...    @update: hstone     20JUL2020    - Removed sleep
    ...                                     - Fixed documentation
    ...                                     - Removed extra spaces
    [Arguments]    ${sDeal_Name}

    ###Pre-processing keyword####
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}

    Select Actions    [Actions];Deal
    mx LoanIQ activate window    ${LIQ_DealSelect_Window}
    Verify Window    ${LIQ_DealSelect_Window}
    mx LoanIQ enter    ${LIQ_DealSelect_Search_TextField}     ${Deal_Name}
    mx LoanIQ click    ${LIQ_DealSelect_Ok_Button}
    Log    Deal is successfully opened

Create New Outstanding Select
    [Documentation]   This keyword will create a new Outstanding Select
    ...    This keyword also returns Loan Alias.
    ...    @author: ritragel/ghabal
    ...    @update: rtarayao    11MAR2019    Deleted Write Data, Read Data, and get system date keywords.
    ...    @update: rtarayao    02OCT2019    Added optional argument for Borrower selection
    ...    @update: Archana     11June20 -   Added Pre-processing and post-processing keywords
    ...                                      Updated Screenshot path
    ...    @update: dahijara    01JUL2020 - Updated Alias variable in Return and Save from ${Alias} to ${sAlias}.
    [Arguments]      ${sOutstandingSelect_Type}    ${sFacility_Name}    ${sAmount_Requested}    ${sPricing_Option}    ${sEffective_Date}    ${sExpiry_Date}    ${sBorrower}=None    ${sAdjustedExpiryDate}=None    ${sRunTimevarAlias}=None

####Pre-processing Keywords###
     ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}
     ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
     ${Amount_Requested}    Acquire Argument Value    ${sAmount_Requested}
     ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
     ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
     ${Expiry_Date}    Acquire Argument Value    ${sExpiry_Date}
     ${Borrower}    Acquire Argument Value    ${sBorrower}
     ${AdjustedExpiryDate}    Acquire Argument Value    ${sAdjustedExpiryDate}

    mx LoanIQ select    ${LIQ_OutstandingSelect_Submenu}
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    Verify Window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Type_Dropdown}    ${OutstandingSelect_Type}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_New_RadioButton}    ON
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Type_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Facility_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Currency_Dropwdown}     VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Alias_JavaEdit}       VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Borrower_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Deal_JavaButton}            VerificationData="Yes"
    mx LoanIQ select    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    mx LoanIQ select    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    ${Pricing_Option}
    Run Keyword if    '${Borrower}'!='None'    mx LoanIQ select    ${LIQ_OutstandingSelect_Borrower_Dropdown}    ${Borrower}
    ${sAlias}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Alias_JavaEdit}    alias_from_LoanIQ
    mx LoanIQ click    ${LIQ_OutstandingSelect_OK_Button}
    mx LoanIQ click element if present    ${LIQ_OutstandingSelect_Warning_Yes_Button}
    mx LoanIQ click element if present   ${LIQ_OutstandingSelect_InformationalMessage_OK_Button}
    mx LoanIQ activate window    ${LIQ_SBLCIssuance_Window}
    mx LoanIQ enter    ${LIQ_SBLCIssuance_Requested_TextField}    ${Amount_Requested}
    mx LoanIQ enter    ${LIQ_SBLCIssuance_EffectiveDate_TextField}    ${Effective_Date}
    mx LoanIQ enter    ${LIQ_SBLCIssuance_ExpiryDate_TextField}   ${Expiry_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect
    Run Keyword If    '${AdjustedExpiryDate}'!='None'    mx LoanIQ enter    ${LIQ_SBLCIssuance_AdjustextExpiry_TextField}    ${AdjustedExpiryDate}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Log    New SBLC issuance is created

####Post-Processing Keyword###
   Save Values of Runtime Execution on Excel File    ${sRunTimevarAlias}    ${sAlias}
    [Return]    ${sAlias}

Create New Outstanding Select - SBLC
    [Documentation]   This keyword will create a new Outstanding Select
    ...    @author: ritragel
    ...    @update:Archana 11June20 - Added Pre and Post processing Keywords
    ...                             -Added RunTime Variable "${sRunTimevarAlias}"
    ...    @update: clanding    20JUL2020    - removed '${LIQmx LoanIQ enter'; updated mx LoanIQ select to mx LoanIQ enter for inputting Effective_Date
    ...                                      - added selecting of Facility_Name; updated Sleep to FOR Loop checking of the next object if present
    ...                                      - re-arrange codes based from actual input
    [Arguments]    ${sOutstandingSelect_Type}    ${sFacility_Name}    ${sAmount_Requested}    ${sEffective_Date}    ${sPricing_Option}    ${sExpiry_Date}    ${sRunTimevarAlias}=None

    ####Pre-Processing Keywords####
    ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Amount_Requested}    Acquire Argument Value    ${sAmount_Requested}
    ${Effective_Date}    Acquire Argument Value    ${sEffective_Date}
    ${Pricing_Option}    Acquire Argument Value    ${sPricing_Option}
    ${Expiry_Date}    Acquire Argument Value    ${sExpiry_Date}

    mx LoanIQ select    ${LIQ_OutstandingSelect_Submenu}
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    Verify Window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Type_Dropdown}    ${OutstandingSelect_Type}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_New_RadioButton}    ON
    :FOR    ${Index}    IN RANGE    10
    \    ${Select_Type_Dropdown_Exists}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Type_Dropdown}
    \    Exit For Loop If    ${Select_Type_Dropdown_Exists}==${True}
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Type_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Facility_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Currency_Dropwdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Alias_JavaEdit}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Borrower_Dropdown}    VerificationData="Yes"
    Run Keyword And Continue On Failure    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Deal_JavaButton}    VerificationData="Yes"

    mx LoanIQ select    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    mx LoanIQ select    ${LIQ_OutstandingSelect_PricingOption_Dropdown}    ${Pricing_Option}
    ${Alias}    Mx LoanIQ Get Data    ${LIQ_OutstandingSelect_Alias_JavaEdit}    alias_from_LoanIQ
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect_${Alias}
    mx LoanIQ click    ${LIQ_OutstandingSelect_OK_Button}
    mx LoanIQ click element if present    ${LIQ_OutstandingSelect_Warning_Yes_Button}
    mx LoanIQ click element if present   ${LIQ_OutstandingSelect_InformationalMessage_OK_Button}
    mx LoanIQ click element if present   ${LIQ_Information_OK_Button}

    mx LoanIQ activate window    ${LIQ_SBLCIssuance_Window}
    mx LoanIQ enter    ${LIQ_SBLCIssuance_Requested_TextField}    ${Amount_Requested}
    mx LoanIQ enter    ${LIQ_SBLCIssuance_EffectiveDate_TextField}    ${Effective_Date}
    mx LoanIQ enter    ${LIQ_SBLCIssuance_ExpiryDate_TextField}   ${Expiry_Date}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSBLC
    mx LoanIQ click element if present    ${LIQ_OutstandingSelect_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_OutstandingSelect_Warning_Yes_Button}
    Log    New SBLC issuance is created

	####Post-Processing Keyword###
	Save Values of Runtime Execution on Excel File    ${sRunTimevarAlias}    ${Alias}
    [Return]    ${Alias}

Verify Pricing Formula
    [Documentation]    This keyword will verify the Pricing Formula Defined in the Facility
    ...    @author: ritragel
    ...    @update: jdelacru    23APR19    Added argument for accrual rule Pay In Advance
    ...    @update: jdelacru    24APR19    Deleted Validation for Fronting Usage Fee
    ...    @update: archana     11June20    Added duplicate "mx LoanIQ click    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Button}"
    ...                                     since Mx LoanIQ click is only highlighting the button but not clicking
    ...                                     Added Pre-processing keywords
    ...                                     Updated Screenshot path
    ...    @update: dahijara    03JUL2020    - removed duplicated click action for Pricing formula button. Added keyword for press TAB before clicking the pricing formula button.
    ...    @update: clanding    22JUL2020    - added clicking of Yes button on a Warning pop up
    [Arguments]    ${sPricing_Formula_Lender}    ${sCycle_Frequency}    ${sPayInAdvance}=None

    ###Pre-processing keyword####
    ${Pricing_Formula_Lender}    Acquire Argument Value    ${sPricing_Formula_Lender}
    ${Cycle_Frequency}    Acquire Argument Value    ${sCycle_Frequency}
    ${PayInAdvance}    Acquire Argument Value    ${sPayInAdvance}

    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Rates_Tab}    Rates
    mx LoanIQ click element if present    ${LIQ_OutstandingSelect_Warning_Yes_Button}
    Mx LoanIQ Check Or Uncheck    ${LIQ_SBLCIssuance_FeeOnLenderShares_EnableCheckbox}    ON
    Sleep    1
    mx LoanIQ select    ${LIQ_SBLCIssuance_FeeOnLenderShares_AccrualRules_CycleFrequency_Dropdown}    ${Cycle_Frequency}
    Mx LoanIQ Select Combo Box Value    ${LIQ_SBLCIssuance_FeeOnLenderShares_Type_Dropdown}    Issuance Fee (BG/LC)
    Mx Press Combination    KEY.TAB
    mx LoanIQ click    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Button}
    mx LoanIQ activate window    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Window}
    ${Verified_Pricing_Formula_Lender}    Mx LoanIQ Get Data    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Label}    Verified_Pricing_Formula_Lender
    Should Be Equal As Strings    ${Pricing_Formula_Lender}    ${Verified_Pricing_Formula_Lender}
    Log    ${Verified_Pricing_Formula_Lender}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PricingFormula_Window
    mx LoanIQ click    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_OK_Button}
    Run Keyword If    '${PayInAdvance}'!='None'    Mx LoanIQ Select Combo Box Value    ${LIQ_SBLCGuarantee_AccrualRule_Dropdown}    ${PayInAdvance}
    Log    Pricing Formula is verified successfully

Add Banks
    [Documentation]    This keyword will add a bank in the New SBLC Issuance
    ...    @author: ritragel
    ...    @update: jloretiz    - update keyword to handle multiple banks
    ...    @update:Archana 11June20 - Added pre-processing keywords
    ...                               Updated Screenshot path
    [Arguments]    ${sCustomers}    ${sDelimiter}=,

    ####Pre-processing Keyword####
   ${Customers}    Acquire Argument Value    ${sCustomers}
   ${Delimiter}    Acquire Argument Value    ${sDelimiter}

    @{CustomerList}    Split String    ${Customers}    ${sDelimiter}
    Log    ${CustomerList}

    :FOR    ${Customer}    IN    @{CustomerList}
    \    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Banks_Tab}    Banks
    \    Sleep    1
    \    mx LoanIQ click    ${LIQ_SBLCIssuance_Beneficiaries_Add_Button}
    \    mx LoanIQ activate window    ${LIQ_SBLCIssuance_CustomerSelect_Window}
    \    mx LoanIQ enter    ${LIQ_SBLCIssuance_CustomerSelect_TextField}    ${Customer}
    \    mx LoanIQ click    ${LIQ_SBLCIssuance_CustomerSelect_OK_Button}
    \    Sleep    3
    \    Mx LoanIQ DoubleClick   ${LIQ_SBLCIssuance_Beneficiaries_Customer_Record_JavaTree}    ${Customer}
    \    #Mx LoanIQ Select Or DoubleClick In Javatree   ${LIQ_SBLCIssuance_Beneficiaries_Customer_Record_JavaTree}    ${Customer}%s
    \    Log    Customer is successfully entered as a Beneficiary
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Sleep    5
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Sleep    5
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Sleep    5
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    Sleep    5
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    mx LoanIQ activate    ${LIQ_ServicingGroup_Window}
    \    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    \    Sleep    5
    \    mx LoanIQ activate    ${LIQ_SBLCIssuance_Window}
    \    mx LoanIQ click    ${LIQ_SBLCIssuance_PreferredRemittanceInstruction}
    \    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Add_Button}
    \    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_PreferredRemittanceInstructions_Javatree}   Mark/Un-Mark All%s
    \    Mx Native Type    {SPACE}
    \    mx LoanIQ click    ${LIQ_PreferredRemittanceInstructions_Ok_Button}
    \    mx LoanIQ click    ${LIQ_ServicingGroupDetails_Ok_Button}
    \    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/AddBanks
    \    mx LoanIQ select    ${LIQ_SBLCIssuance_Save_Submenu}
    \    mx LoanIQ click element if present    ${LIQ_Warning_OK_Button}
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}

    Log    Banks are successfully added

Add Banks for Bilateral Deal with Multiple Risk Types
    [Documentation]    This keyword will add a bank in the New SBLC Issuance
    ...    @author: ritragel/ghabal
    ...    replaced Mx LoanIQ Select Or DoubleClick In Javatree to  Mx LoanIQ Select String
    ...    @update:Archana 11June20 - Added Pre-processing keyword
    [Arguments]    ${sCustomer}

    ###Pre-processing keyword###
    ${Customer}    Acquire Argument Value    ${sCustomer}

    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Banks_Tab}    Banks
    Sleep    1
    mx LoanIQ click    ${LIQ_SBLCIssuance_Beneficiaries_Add_Button}
    mx LoanIQ activate window    ${LIQ_SBLCIssuance_CustomerSelect_Window}
    mx LoanIQ enter    ${LIQ_SBLCIssuance_CustomerSelect_TextField}    ${Customer}
    mx LoanIQ click    ${LIQ_SBLCIssuance_CustomerSelect_OK_Button}
    Mx LoanIQ Select String   ${LIQ_SBLCIssuance_Beneficiaries_Customer_Record_JavaTree}    ${Customer}
    Mx Native Type    {ENTER}
    Log    Customer is successfully entered as a Beneficiary
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ activate    ${LIQ_ServicingGroup_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Add Banks
    mx LoanIQ click    ${LIQ_ServicingGroup_OK_Button}
    Log    Banks are successfully added

Add Purpose
    [Documentation]    This keyword will add purpose in the New SBLC Issuance
    ...    @author: ghabal
    ...    @update:Archana 11June20 - Added pre-processing keyword
    ...                               Updated Screenshotpath
    [Arguments]    ${sPurpose}

    ###Pre-processing keyword###
   ${Purpose}    Acquire Argument Value    ${sPurpose}

    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Banks_Tab}    Codes
    Mx LoanIQ Select Combo Box Value    ${LIQ_SBLCIssuance_Codes_Purpose}    ${Purpose}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Codes_Window

Complete Workflow Items
    [Documentation]    This keyword will complete the initial work items in SBLC Issuance
    ...    @author: ritragel
    ...    @update: fmamaril    31MAY2019    Remove items on Notices; To be tested on Correspondence
    ...    @update:Archana 11June20 - Added Pre-processing keyword
    [Arguments]    ${sCustomer_Legal_Name}    ${sSBLC_Status}
    ###Pre-processing keyword###

    ${Customer_Legal_Name}    Acquire Argument Value    ${sCustomer_Legal_Name}
    ${SBLC_Status}    Acquire Argument Value    ${sSBLC_Status}

    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Workflow_Tab}    Workflow
    mx LoanIQ click element if present    ${LIQ_SBLCIssuance_Warning_Yes_Button}
    Mx LoanIQ DoubleClick    ${LIQ_SBLCIssuance_GenerateIntentNotices_ListItem}    Send to Approval
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCSendtoApproval_Window
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Log    Workflow Items are complete and ready for approval!

Validate Error in Workflow for SBLC without Favouree
    [Documentation]    This keyword will trigger the workflow to display the error of no favouree SBLC
    ...    @author: jloretiz    29OCT2019    - Initial

    mx LoanIQ select    ${LIQ_SBLCIssuance_Save_Submenu}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Workflow_Tab}    Workflow
    mx LoanIQ click element if present    ${LIQ_SBLCIssuance_Warning_Yes_Button}
    Mx LoanIQ DoubleClick    ${LIQ_SBLCIssuance_GenerateIntentNotices_ListItem}    Send to Approval
    Sleep    3s

    ${Error_Exist}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Error_Window}        VerificationData="Yes"        VerificationData="Yes"
    Run Keyword If    ${Error_Exist}==True    Run Keywords    Log    The Error requiring a Favouree displayed!
    ...    AND    Take Screenshot    Error_Window
    ...    AND    mx LoanIQ click    ${LIQ_Error_OK_Button}
    ...    ELSE    Fail    The Error requiring a Favouree did not show up!

Complete Workflow Items for Bilateral Deal with Multiple Risk Types
    [Documentation]    This keyword will complete the initial work items in SBLC Issuance for Bilateral Deal with Multiple Risk Types
    ...    @author: ritragel/ghabal
    [Arguments]    ${Customer_Legal_Name}    ${SBLC_Status}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click element if present    ${LIQ_Notices_OK_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Workflow_Tab}    Workflow
    mx LoanIQ click element if present    ${LIQ_SBLCIssuance_Warning_Yes_Button}
    Mx LoanIQ DoubleClick    ${LIQ_SBLCIssuance_GenerateIntentNotices_ListItem}    Generate Intent Notices
    mx LoanIQ activate window    ${LIQ_Notices_Window}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    mx LoanIQ activate window    ${LIQ_SBLC_Intent_Notice_Window}
    Mx LoanIQ Select String    ${LIQ_SBLC_Intent_Notice_List}    Email
    mx LoanIQ click    ${LIQ_SBLC_EditHighlightedNotice_Button}
    mx LoanIQ activate window    ${LIQ_SBLC_Intent_Notice_Email_Window}
    ${Verified_Customer}    Mx LoanIQ Get Data    JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice created.*","displayed:=1").JavaEdit("text:=${Customer_Legal_Name}")    Verified_Customer
    Should Be Equal As Strings    ${Customer_Legal_Name}    ${Verified_Customer}
    Log    ${Verified_Customer}
    ${Verified_Status}    Mx LoanIQ Get Data    JavaWindow("title:=SBLC/Guarantee Issuance Intent Notice created.*","displayed:=1").JavaObject("tagname:=Group","text:=Status").JavaStaticText("text:=${SBLC_Status}")    Verified_Status
    Should Be Equal As Strings    ${SBLC_Status}    ${Verified_Status}
    Log    ${Verified_Status} - Status is correct!

Verify SBLC in Work in Process
    [Documentation]    This keyword will verify the SBLC in Work in Process
    ...    @author: ritragel
    ...    @update:Archana 11June20 - Added Pre-processing keyword
    ...    @update: dahijara    03JUL2020    - Added keyword for screenshot
    [Arguments]    ${sDeal_Name}

    ###Pre-processing Keyword###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    Sleep    1
    Select Actions    [Actions];Work In Process
    mx LoanIQ activate window    ${LIQ_TransactionsInProcess_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TransactionInProcess
    Mx LoanIQ Double Click In Javalist    ${LIQ_TransactionsInProcess_Transations_JavaTree}    Outstandings
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    Awaiting Release
    Mx LoanIQ DoubleClick    ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    SBLC/Guarantee Issuance
    Mx LoanIQ Select Or Doubleclick In Tree By Text   ${LIQ_TransactionsInProcess_TargetDate_JavaTree}    ${Deal_Name}%d
    Log    SBLC Issuance is present in Work in Process
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TransactionInProcess
    mx LoanIQ close window    ${LIQ_TransactionsInProcess_Window}

Release SLBC Issuance in Workflow
    [Documentation]    This keyword will release the SBLC Issuance in Workflow tab
    ...    @author: ritragel
    ...    @update: rtarayao    23AUG2019    - Removed Comments and Mx Wait keyword
    ...    @update: dahijara    03JUL2020    - Added keyword for screenshot
    mx LoanIQ activate window    ${LIQ_SBLCIssuance_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Workflow_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_SBLCIssuance_Release_ListItem}    Release
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Workflow
    Log    Online Accrual is complete

Verify SBLC Issuance Status
    [Documentation]    This keyword will verify the SLBC Issuance Status
    ...    @author: ritragel
    ...    @updata: jdelacru    24APR19    Deleted validation for Fronting Usage Fee
    ...    @update:Archana 11June20 -Added Pre-processing keyword
    ...                              Updated Screenshot path
    [Arguments]    ${sDeal_Name}    ${sOutstandingSelect_Type}    ${sFacility_Name}    ${sAlias}    ${sCycle_Number}

    ###Pre-processing keyword###

    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Alias}    Acquire Argument Value    ${sAlias}
    ${Cycle_Number}    Acquire Argument Value    ${sCycle_Number}

    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    ${test}    Mx LoanIQ Get Data    ${LIQ_Window}    label%test
    ${Sys_Date}    Fetch From Right    ${test}    :${SPACE}
    log    System Date: ${Sys_Date}
    Select Actions    [Actions];Outstanding
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Existing_RadioButton}    ON
    Sleep    2
    mx LoanIQ select    ${LIQ_OutstandingSelect_Type_Dropdown}    ${OutstandingSelect_Type}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Deal_JavaEdit}    ${Deal_Name}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    Mx LoanIQ DoubleClick    ${LIQ_ExistingOutstandingSelect_JavaTree}    ${Alias}
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Window}
    mx LoanIQ click element if present    ${LIQ_SBLCGuarantee_InquiryMode_Button}
    Mx LoanIQ Select Window Tab    ${LIQ_ActiveSBLC_Rates_Tab}    Rates
    ${Accrual_Date}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_Rates_StartDate}    Accrual_Date
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Events_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SBLCIssuance_Events_ListItem}    Released%s
    Log    SBLC Issuance sucessfully released
    Perform Online Accrual    ${Deal_Name}    ${Facility_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLC_IssuanceStatus
    mx LoanIQ click element if present    ${LIQ_SBLC_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_SBLC_InformationalMessage_OK_Button}
    Log    Accrual is complete!

Verify SBLC Issuance Status for Bilateral Deal with Multiple Risk Types
    [Documentation]    This keyword will verify the SLBC Issuance Status
    ...    @author: ritragel/ghabal
    ...    @udpate: Disabled closing of windows for bank guarantee window and existing standby letters window. Closing of all LIQ windows are declared in the highlevel keywords.
    ...    @update:Archana 11June20 - Added pre-processing keyword
    ...                             -Deleted commented lines
    ...    @update: dahijara    03JUL2020 - Added keyword for screenshot
    [Arguments]    ${sDeal_Name}    ${sOutstandingSelect_Type}    ${sFacility_Name}    ${sAlias}    ${sCycle_Number}
    ###Pre-processing Keyword####

    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Alias}    Acquire Argument Value    ${sAlias}
    ${Cycle_Number}    Acquire Argument Value    ${sCycle_Number}

    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    ${test}    Mx LoanIQ Get Data    ${LIQ_Window}    label%test
    ${Sys_Date}    Fetch From Right    ${test}    :${SPACE}
    log    System Date: ${Sys_Date}
    Select Actions    [Actions];Outstanding
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Existing_RadioButton}    ON
    Sleep    2
    mx LoanIQ select    ${LIQ_OutstandingSelect_Type_Dropdown}    ${OutstandingSelect_Type}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Deal_JavaEdit}    ${Deal_Name}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    Mx LoanIQ DoubleClick    ${LIQ_ExistingOutstandingSelect_JavaTree}    ${Alias}
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_ActiveSBLC_Rates_Tab}    Rates
    ${Accrual_Date}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_Rates_StartDate}    Accrual_Date
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Events_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SBLCIssuance_Events_ListItem}    Released%s
    Mx LoanIQ Select Window Tab    ${LIQ_ActiveSBLC_Accrual_Tab}    Accrual
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ActiveSBLC_IssuanceFee_JavaTree}    ${Cycle_Number}%s
    Perform Online Accrual    ${Deal_Name}    ${Facility_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Events
    Log    Accrual is complete!
    Log    SBLC Issuance sucessfully released

Perform Online Accrual
    [Documentation]    This keyword will Perform an Online Accrual
    ...    @author: ritragel
    [Arguments]    ${Deal_Name}    ${Facility_Name}
    mx LoanIQ activate window    ${LIQ_SBLC_Window}
    mx LoanIQ click element if present    ${LIQ_SBLCGuarantee_InquiryMode_Button}
    mx LoanIQ select    ${LIQ_SBLC_PerformOnlineAccrual_Menu}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Log    Online Accrual is complete

Approve SBLC Issuance
    [Documentation]    This keyword will approve the Awaiting Approval - SBLC Issuance
    ...    @author: ritragel
    ...    @update: rtarayao    12MAR2019    Deleted the logout, login, and Search Deal keywords.
    ...    @update: jdelacru    23APR19    Deleted Facility Navigation and added WIP navigation in High Level
    ...    @update: jdelacru    24APR19    Deleted Arguments
    ...    @update: clanding    20JUL2020    Added screenot
    mx LoanIQ activate window    ${LIQ_SBLCGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Workflow_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCGuarantee_Workflow
    Mx LoanIQ DoubleClick    ${LIQ_SBLCIssuance_Workflow_ListItem}    Approval
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Question_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Approval
    Log    SBLC Issuance is now approved

Open SBLC Guarantee Notebook
    [Documentation]    This keyword is used to Open the SBLC Guarantee Notebook via Deal Search.
    ...    @author: rtarayao
    ...    <update>mgaling: Added step for Outstanding Type,
    ...    @update: clanding    22JUL2020    - added pre-processing keywords; refactor arguments per standard; added screenshot
    [Arguments]    ${sDeal_Name}    ${sOutstanding_Type}    ${sFacility_Name}    ${sSBLC_Alias}

    ### GetRuntime Keyword Pre-processing ###
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${Outstanding_Type}    Acquire Argument Value    ${sOutstanding_Type}
	${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
	${SBLC_Alias}    Acquire Argument Value    ${sSBLC_Alias}

    Open Existing Deal    ${Deal_Name}

    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_InquiryMode_Button}                VerificationData="Yes"
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_DealNotebook_InquiryMode_Button}
    ...    ELSE    Run Keyword    Mx LoanIQ Verify Object Exist    ${LIQ_DealNotebook_UpdateMode_Button}     VerificationData="Yes"

    mx LoanIQ select    ${LIQ_DealNotebook_Queries_OutstandingSelect}
    mx LoanIQ activate    ${LIQ_OutstandingSelect_Window}
    Mx LoanIQ Verify Object Exist    ${LIQ_OutstandingSelect_Window}    VerificationData="Yes"
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    ${Outstanding_Type}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    mx LoanIQ activate    ${LIQ_ExistingLettersofCredit_Window}
    Mx LoanIQ Verify Object Exist    ${LIQ_ExistingLettersofCredit_Window}    VerificationData="Yes"
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ExistingLettersofCredit_Window
    Mx LoanIQ DoubleClick    ${LIQ_ExistingLettersofCredit_LettersofCredit_List}    ${SBLC_Alias}

Navigate to Accrual Tab
    [Documentation]    This keyword navigates the LIQ User to the SBLC Guarantee Accrual tab.
    ...    @author: rtarayao
    ...    @update: fmamaril    30APR2019    Remove unnecesary spaces
    ...    @update: clanding    22JUL2020    - added screenshot
    mx LoanIQ activate window    ${LIQ_SBLCGuarantee_Window}
    ${Inquiry_Status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_SBLCGuarantee_InquiryMode_Button}    VerificationData="Yes"
    Run Keyword If    ${Inquiry_Status}==True    mx LoanIQ click    ${LIQ_SBLCGuarantee_InquiryMode_Button}
    ...    ELSE IF    ${Inquiry_Status}==False    Mx LoanIQ Verify Object Exist    ${LIQ_SBLCGuarantee_UpdateMode_Button}                             VerificationData="Yes"
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    Accrual
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCGuaranteeWindow_AccrualTab

Store Cycle Start Date, End Date, and Paid Fee
    [Documentation]    This keyword is used to save the Current Cycle Start Date, End Date, and Paid to Date values in Excel.
    ...    @author: rtarayao
    ...    @author: fmamaril    30APR2019    Remove writing and delete unnecessary arguments
    ...    @update: clanding    22JUL2020    - added pre-processing keywords, refactor argument per standard, added screenshot
    ...                                      - added post-processing keywords
    [Arguments]    ${iSBLC_CycleNumber}    ${sRunTimeVar_Current_Cycle_Due}=None    ${sRunTimeVar_Cycle_StartDate}=None
    ...    ${sRunTimeVar_Cycle_EndDate}=None    ${sRunTimeVar_Cycle_Paid_to_Date}=None

    ### GetRuntime Keyword Pre-processing ###
    ${SBLC_CycleNumber}    Acquire Argument Value    ${iSBLC_CycleNumber}

    mx LoanIQ activate window    ${LIQ_SBLCGuarantee_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${SBLC_CycleNumber}%s
    ${Current_Cycle_Due}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${SBLC_CycleNumber}%Cycle Due%CycleDue_Variable
    ${Cycle_StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${SBLC_CycleNumber}%Start Date%StartDate_Variable
    ${Cycle_EndDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${SBLC_CycleNumber}%End Date%EndDate_Variable
    ${Paid_to_Date}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${SBLC_CycleNumber}%Paid to date%PaidtoDate_Variable
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCGuaranteeWindow_Accrual

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Current_Cycle_Due}    ${Current_Cycle_Due}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Cycle_StartDate}    ${Cycle_StartDate}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Cycle_EndDate}    ${Cycle_EndDate}
    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_Cycle_Paid_to_Date}    ${Paid_to_Date}

    [Return]    ${Current_Cycle_Due}    ${Cycle_StartDate}    ${Cycle_EndDate}    ${Paid_to_Date}

Validate SBLC Issuance Fee Per Cycle in Accrual Tab
    [Documentation]    This keyword is used to validate that the Computed SBLC Issuance Fee per Cycle is same as the Projected EOC accrual in Accrual tab.
    ...    @author: rtarayao
    ...    @update: clanding    22JUL2020    - added pre-processing keywords, refactor argument per standard, added screenshot
    [Arguments]    ${iSBLC_CycleNumber}    ${sSheet_Name}    ${iRowId}    ${sComputed_ProjectedCycleDue}

    ### GetRuntime Keyword Pre-processing ###
    ${SBLC_CycleNumber}    Acquire Argument Value    ${iSBLC_CycleNumber}
    ${Sheet_Name}    Acquire Argument Value    ${sSheet_Name}
	${rowid}    Acquire Argument Value    ${iRowId}
	${Computed_ProjectedCycleDue}    Acquire Argument Value    ${sComputed_ProjectedCycleDue}

    mx LoanIQ activate    ${LIQ_SBLCGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    Accrual
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${SBLC_CycleNumber}%s
    ${Projected_EOC_Accrual}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${SBLC_CycleNumber}%Projected EOC accrual%EOCDue_Variable
    ${Projected_EOC_Accrual}    Convert To Number    ${Projected_EOC_Accrual}    2
    ${Projected_Cycle_Due_Value}    Read Data From Excel    ${Sheet_Name}    Computed_ProjectedCycleDue    ${rowid}
    ${Projected_Cycle_Due_Value}    Convert To Number    ${Projected_Cycle_Due_Value}    2
    Run Keyword And Continue On Failure   Should Be Equal    ${Projected_EOC_Accrual}    ${Projected_Cycle_Due_Value}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCGuaranteeWindow_Accrual

Compute Issuance Interest Payment Amount Per Cycle
    [Documentation]    This keyword is used in computing the first Projected Cycle Due of the Interest Payment and saves it to Excel.
    ...    @author: rtarayao
    ...    @update: clanding    22JUL2020    - added pre-processing keywords, refactor argument per standard, added screenshot
    ...                                      - added post-processing keywords
    [Arguments]    ${iCycleNumber}    ${sRunTimeVar_ProjectedCycleDue}=None

    ### GetRuntime Keyword Pre-processing ###
    ${CycleNumber}    Acquire Argument Value    ${iCycleNumber}

    mx LoanIQ activate window    ${LIQ_SBLCGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Tab}    General
    ${PrincipalAmount}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_GlobalOriginal_StaticText}    value%test
    ${StartDate}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_EffectiveDate_StaticText}    value%test
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCGuaranteeWindow_GeneralTab

    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Tab}    Rates
    ${Rate}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_Rate_StaticText}    value%test
    ${Cycle}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_CycleFrequency_Combobox}    value%test
    ${RateBasis}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_RateBasis_Combobox}    value%test
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCGuaranteeWindow_RatesTab

    ${PrincipalAmount}    Remove String    ${PrincipalAmount}    ,
    ${PrincipalAmount}    Convert To Number    ${PrincipalAmount}
    ${Rate}    Remove String    ${Rate}    %
    ${Rate}    Convert To Number    ${Rate}
    ${Rate}    Evaluate    ${Rate}/100
    ${RateBasis}    Remove String    ${RateBasis}    Actual/
    ${RateBasis}    Convert To Integer    ${RateBasis}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    Accrual
    ${ProjectedCycleDue}    Evaluate Issuance Interest Fee    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}
    Log    ${ProjectedCycleDue}
    ${ProjectedCycleDue}    Convert To Number    ${ProjectedCycleDue}    2
    ${ProjectedCycleDue}    Evaluate    "%.2f" % ${ProjectedCycleDue}

    Save Values of Runtime Execution on Excel File    ${sRunTimeVar_ProjectedCycleDue}    ${ProjectedCycleDue}
    [Return]    ${ProjectedCycleDue}


Evaluate Issuance Interest Fee
    [Documentation]    This keyword evaluates the FIRST Projected Cycle Due on a 'Weekly' cycle.
    ...    @author: fmamaril
    ...    @update: fmamaril    02MAY2019    Update locators for JavaTree on Accrual Tab
    [Arguments]    ${PrincipalAmount}    ${Rate}    ${RateBasis}    ${CycleNumber}
    ${StartDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${CycleNumber}%Start Date%Start Date
    ${EndDate}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    ${CycleNumber}%End Date%End Date
    Log    ${StartDate}
    Log    ${EndDate}
    ${StartDate}    Convert Date    ${StartDate}     date_format=%d-%b-%Y
    ${EndDate}    Convert Date    ${EndDate}     date_format=%d-%b-%Y
    ${Numberof Days}    Subtract Date From Date    ${EndDate}    ${StartDate}    verbose
    Log    ${Numberof Days}
    ${Numberof Days}    Remove String    ${Numberof Days}     days
    ${Numberof Days}    Convert To Number    ${Numberof Days}
    ${Numberof Days}   Evaluate    ${Numberof Days} + 1
    # ${Time}    Set Variable    7
    # ${Time}    Convert To Integer    ${Time}
    ${ProjectedCycleDue}    Evaluate    (((${PrincipalAmount})*(${Rate}))*(${Numberof Days}))/${RateBasis}
    ${ProjectedCycleDue}    Convert To Number    ${ProjectedCycleDue}    2
    [Return]    ${ProjectedCycleDue}

Verify Pricing Formula - Multiple Risk
    [Documentation]    This keyword will verify the Pricing Formula Defined in the Facility for multiple risk
    ...    @author: fmamaril
    [Arguments]    ${Pricing_Formula_Lender}    ${Pricing_Formula_Issuing}    ${Cycle_Frequency}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Rates_Tab}    Rates
    Mx LoanIQ Check Or Uncheck    ${LIQ_SBLCIssuance_FeeOnLenderShares_EnableCheckbox}    ON
    Sleep    1
    mx LoanIQ select    ${LIQ_SBLCIssuance_FeeOnLenderShares_AccrualRules_CycleFrequency_Dropdown}    ${Cycle_Frequency}
    Mx LoanIQ Select Combo Box Value    ${LIQ_SBLCIssuance_FeeOnLenderShares_Type_Dropdown}    Fronting Usage Fee (SFBG)
    mx LoanIQ click    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Button}
    mx LoanIQ activate window    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Window}
    ${Verified_Pricing_Formula_Lender}    Mx LoanIQ Get Data    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Label}    Verified_Pricing_Formula_Lender
    Should Be Equal As Strings    ${Pricing_Formula_Lender}    ${Verified_Pricing_Formula_Lender}
    Log    ${Verified_Pricing_Formula_Lender}
    mx LoanIQ click    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_OK_Button}
    # Mx LoanIQ Select Combo Box Value    ${LIQ_SBLCIssuance_FeeOnLenderShares_Type_Dropdown}    Fronting Usage Fee (SFBG)
    # Mx Click    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Button}
    # Mx Activate Window    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_Window}
    # ${Verified_Pricing_Formula_Issuing}    Mx LoanIQ Get Data    ${LIQ_SBLCIssuance_FeeOnIssuingBankShares_PricingFormula_Label}    Verified_Pricing_Formula_Issuing
    # Should Be Equal As Strings    ${Pricing_Formula_Issuing}    ${Verified_Pricing_Formula_Issuing}
    # Log    ${Verified_Pricing_Formula_Issuing}
    # Mx Click    ${LIQ_SBLCIssuance_FeeOnLenderShares_PricingFormula_OK_Button}
    # Log    Pricing Formula is verified successfully

Verify Notices Modal Window for Borrower
    [Documentation]    This keyword is used to check wheter the Borrower/Depositor Checkbox is ticked before proceeding to the Main Notices window.
    ...    @author: rtarayao    12MAR2019    Initial Create
    ...    @update: rtarayao    01APR2019    Added for loop to handle warning and question messages.
    mx LoanIQ activate window    ${LIQ_Notices_Window}
    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Runtime Property    ${LIQ_Notices_BorrowerDepositor_Checkbox}       value%1
    Run Keyword If    ${status}==True    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    ...    ELSE    Log    Borrower/Depositor checkbox is not ticked.
    :FOR    ${i}    IN RANGE    5
    \    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    \    ${status}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_IntentNotice_Window}                VerificationData="Yes"
    \    Exit For Loop If    ${status}==True


Navigate to SBLC Guarantee Notebook with Pending Status
    [Documentation]    This keyword navigates the User from Deal Notebook to the SBLC Guarantee Notebook with Pending Status.
    ...    @rtarayao: rtarayao    12MAR2019    Deleted the logout, login, and Search Deal keywords.
    ...    @update :Archana       11June20    Added pre-processing keyword
    ...    @update: dahijara    03JUL2020    - Added keyword for screenshot
    [Arguments]    ${sFacility_Name}    ${sAlias}    ${sOutstandingSelect_Type}

    ###Pre-processing Keyword###
    ${Facility_Name}    Acquire Argument Value    ${sFacility_Name}
    ${Alias}    Acquire Argument Value    ${sAlias}
    ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}

    mx LoanIQ select    ${LIQ_OutstandingSelect_Submenu}
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Pending_RadioButton}    ON
    Sleep    2
    mx LoanIQ select    ${LIQ_OutstandingSelect_Type_Dropdown}    ${OutstandingSelect_Type}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${Facility_Name}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    mx LoanIQ activate window    ${LIQ_Pending_SBLC_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingSBLC
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Pending_SBLC_JavaTree}    ${Alias}%d
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/PendingSBLC

Navigate to Existing SBLC Guarantee
    [Documentation]    This keyword navigates the LIQ User to the SBLC Guarantee Notebook.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    [Arguments]    ${sOutstandingType}    ${sDealName}    ${sFacilityName}    ${sOutstandingAlias}
    Select Actions    [Actions];Outstanding
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    Mx LoanIQ Set    ${LIQ_OutstandingSelect_Existing_RadioButton}    ON
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    ${sOutstandingType}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Deal_JavaEdit}    ${sDealName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${sFacilityName}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    mx LoanIQ activate window    ${LIQ_ExistingOutstandings_Window}
    mx LoanIQ maximize    ${LIQ_ExistingOutstandings_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ExistingOutstandings_Table}    ${sOutstandingAlias}%d
    mx LoanIQ close window    ${LIQ_ExistingOutstandings_Window}
    mx LoanIQ activate window    ${LIQ_SBLCGuarantee_Window}

Get Issuance Fee Type
    [Documentation]    This keyword gets the Issuance fee type and returns the value.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    Rates
    ${IssuanceFeeType}    Mx LoanIQ Get Data    ${LIQ_BankGuarantee_FeeType_Dropdown}    value%Issuance Fee Type
    Log    The Issuance fee type is ${IssuanceFeeType}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Fee_Type
    [Return]    ${IssuanceFeeType}

Get SBLC Accrual CCY
    [Documentation]    This keyword gets the Issuance Accrual CCY and returns the value.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    Rates
    ${AccrualCCY}    Mx LoanIQ Get Data    ${LIQ_BankGuarantee_AccrualCCY_Text}    value%AccrualCCY
    Log    The Issuance Accrual CCY is ${AccrualCCY}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Accrual_CCY
    [Return]    ${AccrualCCY}

Get Issuance Accrual Dates
    [Documentation]    This keyword returns the Issuance accrual start, end, and adjusted due dates.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    Rates
    ${StartDate}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_Rates_StartDate}    value%StartDate
    ${EndDate}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_Rates_EndDate}    value%EndDate
    ${AdjustedDueDate}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_Rates_AdjustedDueDate}    value%AdjustedDueDate
    Log    The Issuance Accrual Dates are ${StartDate}, ${EndDate}, and ${AdjustedDueDate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Accrual_Dates
    [Return]    ${StartDate}    ${EndDate}    ${AdjustedDueDate}

Get Issuance Rate
    [Documentation]    This keyword returns the Issuance fee rate.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    Rates
    ${IssuanceRate}    Mx LoanIQ Get Data    ${LIQ_SBLCGuarantee_Rate_StaticText}    value%IssuanceRate
    ${IssuanceRate}    Convert To String    ${IssuanceRate}
    ${IssuanceRate}    Remove String    ${IssuanceRate}    .000000%
    Log    The Issuance Rate is ${IssuanceRate}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Rate
    [Return]    ${IssuanceRate}

Get Issuance Accrued to Date Amount
    [Documentation]    This keyword returns the Issuance total accrued to date amount.
    ...    @author: rtarayao    23AUG2019    - Initial Create
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    Accrual
    ${AccruedtodateAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    TOTAL:${SPACE}%Accrued to date%Accruedtodate
    Log    The Issuance Accrued to Date amount is ${AccruedtodateAmount}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Accrual_Screen
    [Return]    ${AccruedtodateAmount}

Get Issuance Paid to Date Amount
    [Documentation]    This keyword returns the Issuance total paid to date amount.
    ...    @author: cfrancis    15SEP2020    - Initial Create
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    Accrual
    ${PaidtodateAmount}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BankGuarantee_Accrual_JavaTree}    TOTAL:${SPACE}%Paid to date%Paidtodate
    Log    The Issuance Paid to Date amount is ${PaidtodateAmount}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Paid_To_Date
    [Return]    ${PaidtodateAmount}

Get Issuance Risk Type
    [Documentation]    This keyword gets the Issuance Risk type and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    General
    ${IssuanceRiskType}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_RiskType_Text}    value%Issuance Risk Type
    Log    The Issuance fee type is ${IssuanceRiskType}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Risk_Type
    [Return]    ${IssuanceRiskType}

Get Issuance Currency
    [Documentation]    This keyword gets the Issuance Currency and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    General
    ${IssuanceCCY}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_Currency_Text}    text%Currency
    Log    The Issuance Currency is ${IssuanceCCY}
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Currency
    [Return]    ${IssuanceCCY}

Get Issuance Effective and Maturity Expiry Dates
    [Documentation]    This keyword gets the Issuance Effective Date and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    General
    ${IssuanceEffectiveDate}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_EffectiveDate_Text}    text%EffectiveDate
     ${IssuanceAdjustedExpiryDate}    Mx LoanIQ Get Data    ${LIQ_Active_AdjustextExpiry_Text}    text%AdjExpiryDate
    Log    The Issuance Effective and Expiry Dates are ${IssuanceEffectiveDate} and ${IssuanceAdjustedExpiryDate} respectively.
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Effective_and_Adj_Expiry_Date
    [Return]    ${IssuanceEffectiveDate}    ${IssuanceAdjustedExpiryDate}

Get Issuance Host Bank Net and Gross Amount
    [Documentation]    This keyword gets the Issuance Host Bank Net and Gross Amounts and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    mx LoanIQ activate window    ${LIQ_BankGuarantee_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    General
    ${HBGrossAmount}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_HostBankGross_Text}    value%HBGrossAmount
    ${HBNetAmount}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_HostBankNet_Text}    value%HBNetAmount
    Log    The Issuance Host Bank Gross and Net Amounts are ${HBGrossAmount} and ${HBNetAmount} respectively.
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_HB_Values
    [Return]    ${HBGrossAmount}    ${HBNetAmount}

Get Issuance Global Original and Current Amount
    [Documentation]    This keyword gets the Issuance Global Original and Current Amounts and returns the value.
    ...    @author: rtarayao    26AUG2019    - Initial Create
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCGuarantee_Window_Tab}    General
    ${GlobalOriginalAmount}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_GlobalOriginal_Text}    value%GlobalOrigAmount
    ${GlobalCurrentAmount}    Mx LoanIQ Get Data    ${LIQ_ActiveSBLC_GlobalCurrent_Text}    value%GlobalCurrentAmount
    Log    The Issuance Global Original and Current Amounts are ${GlobalOriginalAmount} and ${GlobalCurrentAmount} respectively.
    Screenshot.Set Screenshot Directory    ${Screenshot_Path}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Global_Values
    [Return]    ${GlobalOriginalAmount}    ${GlobalCurrentAmount}

Navigate Notebook Workflow_SBLCIssuance
    [Documentation]    This keyword navigates the Workflow tab of a Notebook, and does a specific transaction.
    ...    @author:Archana
    ...    @update: dahijara    03JUL2020    - Added keyword for screenshot
    ...                                      - Fixed Locator for clicking item in JavaTree by adding '}' on the end of locator
    [Arguments]    ${sTransaction}

    ###Pre-processing Keyword##

    ${Transaction}    Acquire Argument Value    ${sTransaction}

    mx LoanIQ activate window    ${LIQ_SBLCIssuance_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_SBLCIssuance_Workflow_Tab}    Workflow
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Workflow_Tab
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_SBLCIssuance_Workflow_ListItem}    ${Transaction}%d
    Validate if Question or Warning Message is Displayed
    Run Keyword If    '${Transaction}'=='Release'    Run Keywords
    ...    Repeat Keyword    2 times    mx LoanIQ click element if present    ${LIQ_BreakFunding_No_Button}
    ...    AND    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    ...    ELSE IF    '${Transaction}'=='Close'    mx LoanIQ click element if present    ${LIQ_Information_OK_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/SBLCIssuance_Workflow_Tab

Search SBLC Guarantee Issuance
    [Documentation]    This keyword is used to do the 'Rate Approval' process for the initial Loan drawdown
    ...    @author: ghabal
    ...    @update: rtarayao    12MAR2019    Deleted Search Deal keyword.
	...    @update:Archana      11June20     Added Pre-processing keyword
    ...    @update: dahijara    03JUL2020    - Added screenshot keyword
    ...    @update: dahijara    06JUL2020    - Moved keyword form LoanDrawdown_Notebook.robot to SBBLCGuarantee_Notebook.robot
    ...    @update: dahijara    07JUL2020    - Replaced ''Sleep' with 'Wait Until Keyword Succeeds'.
    [Arguments]    ${sOutstandingSelect_Type}    ${sFacilityName_Revolver}    ${sAlias}
    ###Pre-processing Keyword###
    ${OutstandingSelect_Type}    Acquire Argument Value    ${sOutstandingSelect_Type}
    ${FacilityName_Revolver}    Acquire Argument Value    ${sFacilityName_Revolver}
    ${Alias}    Acquire Argument Value    ${sAlias}

    mx LoanIQ select    ${LIQ_OutstandingSelect_Submenu}
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Pending_RadioButton}    ON
    Wait Until Keyword Succeeds    5x    5s    mx LoanIQ select    ${LIQ_OutstandingSelect_Type_Dropdown}    ${OutstandingSelect_Type}
    mx LoanIQ select    ${LIQ_OutstandingSelect_Facility_Dropdown}   ${FacilityName_Revolver}
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}
    mx LoanIQ activate window    ${LIQ_Pending_SBLC_Window}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/OutstandingSelect
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Pending_SBLC_JavaTree}    ${Alias}%d