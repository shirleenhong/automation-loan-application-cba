*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Get the Notice Details in LIQ
    [Documentation]    This Keyword gets the necessary data for Notice Validation.
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: jaquitan    DDMMMYYYY    - updated arguments and variables
    ...    @update: jloretiz    13JUL2020    - fix the error on excel writing
    ...    @update: kduenas     09SEP2020    - updated arguments and variables
    [Arguments]    ${rowid}    ${sSubAddDays}    ${sDealName}    ${sNoticeType}    ${sZeroTempPath}
    
    ###Get System Date###
    ${SystemDate}    Get System Date
    ${SystemDate}    Convert Date    ${SystemDate}     date_format=%d-%b-%Y
    ${FromDate}    Subtract Time From Date    ${SystemDate}    ${sSubAddDays}days
    ${ThruDate}    Add Time To Date    ${SystemDate}    ${sSubAddDays}days
    Write Data To Excel for API_Data    Correspondence    From_Date    ${rowid}    ${FromDate}
    Write Data To Excel for API_Data   Correspondence    Thru_Date    ${rowid}    ${ThruDate}
    
    Search Existing Deal    ${sDealName}
    Get Notice ID thru Deal Notebook    ${FromDate}    ${ThruDate}    ${sNoticeType}

Get the Notice Details of Specific Contact in LIQ
    [Documentation]    This Keyword gets the necessary data for Notice Validation.
    ...    @author: makcamps    15JAN2021    - initial create
    ...    @update: makcamps	22JAN2021    - removed rowid from arguments and added arguments for writing method
    [Arguments]    ${sSubAddDays}    ${sDealName}    ${sNoticeType}    ${sZeroTempPath}    ${Contact}
    
    ###Get System Date###
    ${SystemDate}    Get System Date
    ${SystemDate}    Convert Date    ${SystemDate}     date_format=%d-%b-%Y
    ${FromDate}    Subtract Time From Date    ${SystemDate}    ${sSubAddDays}days
    ${ThruDate}    Add Time To Date    ${SystemDate}    ${sSubAddDays}days
    Write Data To Excel    Correspondence    From_Date    ${rowid}    ${FromDate}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel   Correspondence    Thru_Date    ${rowid}    ${ThruDate}    bTestCaseColumn=True    sColumnReference=rowid
    
    Search Existing Deal    ${sDealName}
    ${Notice_ID}    ${Notice_Customer_LegalName}    ${ContactName}    Get Notice ID thru Deal Notebook of Specific Contact    ${FromDate}    ${ThruDate}    ${sNoticeType}    ${Contact}
    
    Write Data To Excel    Correspondence    Notice_Identifier    ${rowid}     ${Notice_ID}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    ${rowid}     ${Notice_Customer_LegalName}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Contact    ${rowid}     ${ContactName}    bTestCaseColumn=True    sColumnReference=rowid
    
Get Notice Details for Fee Payment Notice Line Fee in LIQ
    [Documentation]    Get Notice Details (All In Rate, Balance, Amount and Rate Basis) for Fee Payment Notice - Line Fee in LIQ
    ...    @author: ehugo    08162019
    ...    @update: ehugo    08192019    Added retrieving of Balance Amount and Rate Basis
    ...    @update: kduenas  09122020    Added removal of negative character on Cycle Due
    [Arguments]    ${rowid}    ${sFacilityName}    ${sDealName}    ${sOngoingFee_Type}
    
    ###Deal Notebook Window###
    Search Existing Deal    ${sDealName}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    
    ###Facility Navigator Window###
    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityNavigator_FacilitySelection}    ${sFacilityName}%s
    mx LoanIQ click    ${LIQ_FacilityNavigator_OngoingFees_Button}   
    
    ###Fee List For Window###
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeeList_JavaTree}    ${sOngoingFee_Type}%d
    
    ###Line Fee Window - General Tab###
    mx LoanIQ activate window    ${LIQ_LineFeeNotebook_Window}
    ${Notice_AllIn_Rate}    Mx LoanIQ Get Data    ${LIQ_LineFee_CurrentRate_Field}    text%Notice_AllIn_Rate
    ${Notice_Balance_Amount}    Mx LoanIQ Get Data    ${LIQ_LineFee_BalanceAmount_Field}    text%Notice_Balance_Amount
    # ${Notice_Rate_Basis}    Mx LoanIQ Get Data    ${LIQ_LineFee_RateBasis_Field}    text%Notice_Rate_Basis
    
    ###Line Fee Window - Accrual Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_LineFee_Tab}    Accrual
    ${Cycle_Due}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_LineFee_Accrual_Cycles_JavaTree}    1%Cycle Due%var    Processtimeout=180
    ${Cycle_Due}    Remove String    ${Cycle_Due}    - 
    
    Write Data To Excel for API_Data    Correspondence    Notice_AllInRate    ${rowid}    ${Notice_AllIn_Rate}
    Write Data To Excel for API_Data    Correspondence    Notice_Amount    ${rowid}    ${Cycle_Due}
    Write Data To Excel for API_Data    Correspondence    Balance_Amount    ${rowid}    ${Notice_Balance_Amount}
    # Write Data To Excel for API_Data    Correspondence    Rate_Basis    ${rowid}    ${Notice_Rate_Basis}
    
    Close All Windows on LIQ
    
Get Notice Details for Fee Payment Notice Commitment Fee in LIQ
    [Documentation]    Get Notice Details (All In Rate, Amount, Balance Amount and Rate Basis) for Fee Payment Notice - Commitment Fee in LIQ
    ...    @author: ehugo    08162019
    ...    @update: ehugo    08192019    Added retrieving of Balance Amount and Rate Basis
    [Arguments]    ${rowid}    ${sFacilityName}    ${sDealName}    ${sOngoingFee_Type}
    
    ###Deal Notebook Window###
    Search Existing Deal    ${sDealName}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    
    ###Facility Navigator Window###
    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityNavigator_FacilitySelection}    ${sFacilityName}%s
    mx LoanIQ click    ${LIQ_FacilityNavigator_OngoingFees_Button}   
    
    ###Fee List For Window###
    mx LoanIQ activate window    ${LIQ_Facility_FeeList}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FeeList_JavaTree}    ${sOngoingFee_Type}%d
    
    ###Commitment Fee Window - General Tab###
    mx LoanIQ activate window    ${LIQ_CommitmentFeeNotebook_Window}
    ${Notice_AllIn_Rate}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_CurrentRate_Field}    text%Notice_AllIn_Rate
    ${Notice_Balance_Amount}    Mx LoanIQ Get Data    ${LIQ_CommitmentFee_BalanceAmount_Field}    text%Notice_Balance_Amount
    
    ###Commitment Fee Window - Accrual Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_CommitmentFee_Tab}    Accrual
    ${Cycle_Due}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_CommitmentFee_Acrual_JavaTree}    1%Cycle Due%var    Processtimeout=180
    
    Write Data To Excel for API_Data    Correspondence    Notice_AllInRate    ${rowid}    ${Notice_AllIn_Rate}
    Write Data To Excel for API_Data    Correspondence    Notice_Amount    ${rowid}    ${Cycle_Due}
    Write Data To Excel for API_Data    Correspondence    Balance_Amount    ${rowid}    ${Notice_Balance_Amount}
    
    Close All Windows on LIQ

Get Rate Basis via Facility Notebook in LIQ
    [Documentation]    Get Rate Basis via Facility Notebook >  Pricing > Modify Ongoing Fees > Facility Ongoing Fee in LIQ
    ...    @author: ehugo    08202019
    [Arguments]    ${rowid}    ${sFacilityName}    ${sDealName}    ${sOngoingFee_Type}
    
    ###Deal Notebook Window###
    Search Existing Deal    ${sDealName}
    mx LoanIQ select    ${LIQ_DealNotebook_Options_Facilities}
    
    ###Facility Navigator Window###
    mx LoanIQ activate window    ${LIQ_FacilityNavigator_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityNavigator_FacilitySelection}    ${sFacilityName}%d
    
    ###Facility Notebook - Pricing Tab###
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_FacilityNotebook_Tab}    Pricing
    mx LoanIQ click    ${LIQ_FacilityPricing_ModifyOngoingFees_Button}   
    
    ###Facility Pricing - Ongoing Fee Interest Window###
    mx LoanIQ activate window    ${LIQ_FacilityPricing_OngoingFeeInterest_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FacilityPricing_OngoingFeeInterest_Tree}    ${sOngoingFee_Type}%d
    
    ###Facility Fee Window###
    mx LoanIQ activate window    ${LIQ_Facility_Pricing_FeeSelection_Window}
    ${Notice_Rate_Basis}    Mx LoanIQ Get Data    ${LIQ_FeeSelection_RateBasis_List}    text%Notice_Rate_Basis
    
    Write Data To Excel for API_Data    Correspondence    Rate_Basis    ${rowid}    ${Notice_Rate_Basis}
    
    Close All Windows on LIQ

Get Notice Details via Loan Notebook in LIQ
    [Documentation]    Get Notice Details (Effective Date, Term Start and End Date, Fixed Rate Option, Margin, All-in Rate and Interest Due) via Loan Notebook in LIQ
    ...    @author: ehugo       22AUG2019    - initial create
    ...    @update: jloretiz    13JUL2020    - fix the error on excel writing, added screenshots and updated screenshot location
    [Arguments]    ${rowid}    ${sFacilityName}    ${sDealName}    ${sLoanAlias}

    Select Actions    [Actions];Outstanding
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    Loan
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_SearchBy_Dropdown}    Deal/Facility
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Deal_TextField}    ${sDealName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${sFacilityName}    
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}    
    
    ###Existing Loans For Facility Window###
    mx LoanIQ activate window    ${LIQ_ExistingLoansForFacility_Window}
    ${Effective_Date}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_ExistingLoansForFacility_Loan_List}    ${sLoanAlias}%Effective Date%var    Processtimeout=180
    ${Effective_Date}    Run Keyword If    '${Effective_Date}'!='${EMPTY}'    Convert Date    ${Effective_Date}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    ${Repricing_Date}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_ExistingLoansForFacility_Loan_List}    ${sLoanAlias}%Repricing Date%var    Processtimeout=180
    ${Repricing_Date}    Run Keyword If    '${Repricing_Date}'!='${EMPTY}'    Convert Date    ${Repricing_Date}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    ${Maturity_Date}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_ExistingLoansForFacility_Loan_List}    ${sLoanAlias}%Maturity Date%var    Processtimeout=180
    ${Maturity_Date}    Run Keyword If    '${Maturity_Date}'!='${EMPTY}'    Convert Date    ${Maturity_Date}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ExistingLoansForFacility_Loan_List}    ${sLoanAlias}%d
    
    ###Loan Notebook - General Tab###
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    ${Global_Original}    Mx LoanIQ Get Data    ${LIQ_Loan_GlobalOriginal_Field}    text%Global_Original
    ${RateSetting_DueDate}    Mx LoanIQ Get Data    ${LIQ_Loan_GeneralTab_RateSettingDueDate_Textfield}    text%RateSetting_DueDate
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Loan_GeneralTab
    
    ###Loan Notebook - Rates Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Rates
    ${PenaltySpread_IsOff}    Run Keyword And Return Status    Mx LoanIQ Verify Object Exist    ${LIQ_Loan_RatesTab_PenaltySpread_Status_OFF}        VerificationData="Yes"
    Run Keyword If     ${PenaltySpread_IsOff}==False    Fail   Penalty Spread Status is not set to OFF.
    ${Base_Rate}    Mx LoanIQ Get Data    ${LIQ_Loan_RatesTab_BaseRate_Field}    text%Base_Rate
    ${Spread}    Mx LoanIQ Get Data    ${LIQ_Loan_RatesTab_Spread_Field}    text%Spread
    ${AllIn_Rate}    Mx LoanIQ Get Data    ${LIQ_Loan_AllInRate}    text%AllIn_Rate
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Loan_RatesTab
    
    ###Loan Notebook - Accrual Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ${Cycle_Due}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Loan_AccrualTab_Cycles_Table}    1%Cycle Due%var    Processtimeout=180    
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Correspondence_Loan_AccrualTab
    
    Write Data To Excel    Correspondence    Loan_EffectiveDate    ${rowid}    ${Effective_Date}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_RepricingDate    ${rowid}    ${Repricing_Date}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_MaturityDate    ${rowid}    ${Maturity_Date}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_BaseRate    ${rowid}    ${Base_Rate}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Spread    ${rowid}    ${Spread}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Notice_AllInRate    ${rowid}    ${AllIn_Rate}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Notice_Amount    ${rowid}    ${Cycle_Due}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_GlobalOriginal    ${rowid}    ${Global_Original}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_RateSetting_DueDate    ${rowid}    ${RateSetting_DueDate}    ${APIDataSet}    bTestCaseColumn=True    sColumnReference=rowid

    Close All Windows on LIQ
    
Get Paperclip Notice Details via Payment Notebook in LIQ
    [Documentation]    Get Paperclip Notice Details (Principal and Interests Payment Amounts) via Loan Notebook in LIQ
    ...    @author: ehugo    09162019
    [Arguments]    ${rowid}    ${sFacilityName}    ${sDealName}    ${sLoanAlias}
    Select Actions    [Actions];Outstanding
    mx LoanIQ activate window    ${LIQ_OutstandingSelect_Window}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Type_Dropdown}    Loan
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_SearchBy_Dropdown}    Deal/Facility
    mx LoanIQ enter    ${LIQ_OutstandingSelect_Deal_TextField}    ${sDealName}
    Mx LoanIQ Select Combo Box Value    ${LIQ_OutstandingSelect_Facility_Dropdown}    ${sFacilityName}    
    mx LoanIQ click    ${LIQ_OutstandingSelect_Search_Button}    
    
    ###Existing Loans For Facility Window###
    mx LoanIQ activate window    ${LIQ_ExistingLoansForFacility_Window}
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_ExistingLoansForFacility_Loan_List}    ${sLoanAlias}%d
    
    ###Loan Notebook - General Tab###
    mx LoanIQ activate window    ${LIQ_Loan_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Pending
    Mx LoanIQ Select String    ${LIQ_Loan_PendingTab_JavaTree}    Principal Payment
    Mx Native Type    {ENTER}    
    
    ###Principal Payment Window###
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    ${EffectiveDate_Principal}    Mx LoanIQ Get Data    ${LIQ_PrincipalPayment_EffectiveDate_Field}    EffectiveDate_Principal    
    ${EffectiveDate_Principal}    Run Keyword If    '${EffectiveDate_Principal}'!='${EMPTY}'    Convert Date    ${EffectiveDate_Principal}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    ${Outstanding_Principal}    Mx LoanIQ Get Data    ${LIQ_PrincipalPayment_Outstanding_Field}    Outstanding_Principal
    mx LoanIQ close window    ${LIQ_PrincipalPayment_Window}
    
    Mx LoanIQ Select String    ${LIQ_Loan_PendingTab_JavaTree}    Interest Payment
    Mx Native Type    {ENTER}
    
    ###Interest Payment Window###
    mx LoanIQ activate window    ${LIQ_InterestPayment_Window}
    ${EffectiveDate_Interest}    Mx LoanIQ Get Data    ${LIQ_InterestPayment_EffectiveDate_Textfield}    EffectiveDate_Interest
    ${EffectiveDate_Interest}    Run Keyword If    '${EffectiveDate_Interest}'!='${EMPTY}'    Convert Date    ${EffectiveDate_Interest}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    mx LoanIQ close window    ${LIQ_InterestPayment_Window}
    
    ###Accrual Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Accrual
    ${Projected_Cycle_Due}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Loan_AccrualTab_Cycles_Table}    1%Projected EOC due%var    Processtimeout=180
    ${Temp_Start_Date}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Loan_AccrualTab_Cycles_Table}    1%Start Date%var    Processtimeout=180
    ${Temp_End_Date}    Mx LoanIQ Store TableCell To Clipboard   ${LIQ_Loan_AccrualTab_Cycles_Table}    1%End Date%var    Processtimeout=180
    Mx LoanIQ Select String    ${LIQ_Loan_AccrualTab_Cycles_Table}    ${Projected_Cycle_Due}
    Mx Native Type    {ENTER}    
    
    ###Accrual Cycle Detail Window###
    mx LoanIQ activate window    ${LIQ_AccrualCycleDetail_Window}
    mx LoanIQ click    ${LIQ_AccrualCycleDetail_LineItems_Button}
    
    ###Line Items for Window###
    mx LoanIQ activate window    ${LIQ_LineItemsFor_Window}
    ${StartDate_Principal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineItemsFor_JavaTree}    ${Temp_Start_Date}%Start Date%var    Processtimeout=180
    ${StartDate_Principal}    Run Keyword If    '${StartDate_Principal}'!='${EMPTY}'    Convert Date    ${StartDate_Principal}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    ${EndDate_Principal}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineItemsFor_JavaTree}    ${Temp_Start_Date}%End Date%var    Processtimeout=180
    ${EndDate_Principal}    Run Keyword If    '${EndDate_Principal}'!='${EMPTY}'    Convert Date    ${EndDate_Principal}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    
    ${StartDate_Interest}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineItemsFor_JavaTree}    ${Temp_End_Date}%Start Date%var    Processtimeout=180
    ${StartDate_Interest}    Run Keyword If    '${StartDate_Interest}'!='${EMPTY}'    Convert Date    ${StartDate_Interest}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    ${EndDate_Interest}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_LineItemsFor_JavaTree}    ${Temp_End_Date}%End Date%var    Processtimeout=180
    ${EndDate_Interest}    Run Keyword If    '${EndDate_Interest}'!='${EMPTY}'    Convert Date    ${EndDate_Interest}    result_format=%d-%b-%Y    date_format=%d-%b-%Y
    
    mx LoanIQ close window    ${LIQ_LineItemsFor_Window}
    mx LoanIQ close window    ${LIQ_AccrualCycleDetail_Window}
    
    ###Rates Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_Loan_Tab}    Rates
    ${AllIn_Rate}    Mx LoanIQ Get Data    ${LIQ_Loan_AllInRate}    text%AllIn_Rate
    ${Rate_Basis}    Mx LoanIQ Get Data    ${LIQ_Loan_AnyStatus_RateBasis_Dropdownlist}    text%Rate_Basis
        
    Write Data To Excel for API_Data    Correspondence    EffectiveDate_PrincipalPayment    ${rowid}    ${EffectiveDate_Principal}
    Write Data To Excel for API_Data    Correspondence    EffectiveDate_InterestPayment    ${rowid}    ${EffectiveDate_Interest}
    Write Data To Excel for API_Data    Correspondence    Outstanding_PrincipalPayment    ${rowid}    ${Outstanding_Principal}
    Write Data To Excel for API_Data    Correspondence    ProjectedCycleDue_InterestPayment    ${rowid}    ${Projected_Cycle_Due}
    Write Data To Excel for API_Data    Correspondence    Notice_AllInRate    ${rowid}    ${AllIn_Rate}
    Write Data To Excel for API_Data    Correspondence    Rate_Basis    ${rowid}    ${Rate_Basis}
    Write Data To Excel for API_Data    Correspondence    StartDate_Principal    ${rowid}    ${StartDate_Principal}
    Write Data To Excel for API_Data    Correspondence    EndDate_Principal    ${rowid}    ${EndDate_Principal}
    Write Data To Excel for API_Data    Correspondence    StartDate_Interest    ${rowid}    ${StartDate_Interest}
    Write Data To Excel for API_Data    Correspondence    EndDate_Interest    ${rowid}    ${EndDate_Interest}
    
    ###Get number of days for Principal###
    ${StartDate_Principal}    Read Data From Excel for API_Data    Correspondence    StartDate_Principal    ${rowid}
    ${EndDate_Principal}    Read Data From Excel for API_Data    Correspondence    EndDate_Principal    ${rowid}
    ${Days_Principal}    Get Number Of Days Betweeen Two Dates    ${EndDate_Principal}    ${StartDate_Principal}
    ${Days_Principal}    Evaluate    ${Days_Principal} + 1
    Write Data To Excel for API_Data    Correspondence    Days_Principal    ${rowid}    ${Days_Principal}
    
    ###Get number of days for Interest###
    ${StartDate_Interest}    Read Data From Excel for API_Data    Correspondence    StartDate_Interest    ${rowid}
    ${EndDate_Interest}    Read Data From Excel for API_Data    Correspondence    EndDate_Interest    ${rowid}
    ${Days_Interest}    Get Number Of Days Betweeen Two Dates    ${EndDate_Interest}    ${StartDate_Interest}
    ${Days_Interest}    Evaluate    ${Days_Interest} + 1
    Write Data To Excel for API_Data    Correspondence    Days_Interest    ${rowid}    ${Days_Interest}
    
    ${AllIn_Rate}    Read Data From Excel for API_Data    Correspondence    Notice_AllInRate    ${rowid}
    ${Rate_Basis}    Read Data From Excel for API_Data    Correspondence    Rate_Basis    ${rowid}
    ${Amount_Principal}    Get Amount for Paperclip Notice    ${Outstanding_Principal}    ${AllIn_Rate}    ${Days_Principal}    ${Rate_Basis}
    Write Data To Excel for API_Data    Correspondence    Principal_Amount    ${rowid}    ${Amount_Principal}
    
    ${Amount_Interest}    Get Amount for Paperclip Notice    ${Outstanding_Principal}    ${AllIn_Rate}    ${Days_Interest}    ${Rate_Basis}
    Write Data To Excel for API_Data    Correspondence    Interest_Amount    ${rowid}    ${Amount_Interest}
    
    Close All Windows on LIQ

Get Amount for Paperclip Notice
    [Documentation]    Get Amount for Paperclip (Principal and Interests Payment) Notice
    ...    @author: ehugo    09232019
    [Arguments]    ${iPrincipalPayment_TotalAmount}    ${iAllIn_Rate}    ${sDays}    ${sRate_Basis}
    
    ${iPrincipalPayment_TotalAmount}    Remove String    ${iPrincipalPayment_TotalAmount}    ,
    ${iAllIn_Rate}    Convert Percentage to Decimal    ${iAllIn_Rate}
    ${sRate_Basis}    Get Substring    ${sRate_Basis.strip()}    -3
    
    ${Amount}    Evaluate    ${iPrincipalPayment_TotalAmount} * ${iAllIn_Rate} * ${sDays} / ${sRate_Basis}
    ${Amount}    Evaluate    "%.2f" % ${Amount}
    ${Amount}    Evaluate    "{:,}".format(${Amount})
    
    [Return]    ${Amount}
    
Save Notice via Notices Application in LIQ
    [Documentation]    This keyword search and send the Notice thru Notices Application.
    ...    @author:mgaling
    ...     @update: jaquitan    20Mar2019    - updated arguments datatype
    ...    @update:jaquitan 25Mar2019    added keyword for save notice
    [Arguments]    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}    ${sNotice_Customer_LegalName}    ${sNotice_Method}        
     
    ###Search for an Existing Notice### 
    Navigate to Notice Select Window
    Search Existing Notice    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}
    
    ###Validate Button and Fields###
    Validate Buttons and Fields in Notice Window
    
    ###Update Data and Send the Notice###
    Validate and Save Notice    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sNotice_Identifier}
    
Send Notice via Notices Application in LIQ
    [Documentation]    This keyword search and send the Notice thru Notices Application.
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: jaquitan    25Mar2019    - updated arguments datatype
    [Arguments]    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}    ${sNotice_Customer_LegalName}    ${sNotice_Method}        
     
    ###Search for an Existing Notice### 
    Navigate to Notice Select Window
    Search Existing Notice    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}
    
    ###Validate Button and Fields###
    Validate Buttons and Fields in Notice Window
    
    ###Update Data and Send the Notice###
    Validate and Send Notice    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sNotice_Identifier}  
    
Validate Notice in Business Event Output Window in LIQ
    [Documentation]    This kewyord navigates to Business Event Output Window thru Event Management Queue Option in LIQ.
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: jaquitan    20MAR2019    - updated arguments datatype and remove write to excel
    ...    @update: ehugo       20AUG2019    - removed Return in keyword name
    ...    @update: jloretiz    14JUL2019    - added screenshot and remove rowid in arguments, updated screenshot location
    ...    @update: kduenas     07OCT2020    - updated arguments
    [Arguments]    ${rowid}    ${sCustomer_IdentifiedBy}    ${sNotice_Customer_LegalName}    ${sNotice_Identifier}    ${sPath_XMLFile}    ${sTemp_Path}    ${sField_Name}
    
    ###Gets Current Date###  
    ${CurrentDate}    Get Current Date 
   
    Navigate to Business Event Output Window
    Validate Statuses Section 
    Populate Filter Section    ${CurrentDate}    ${CurrentDate}    ${sCustomer_IdentifiedBy}    ${sNotice_Customer_LegalName}
    Validate Event Output Record    ${sNotice_Identifier}
    Delete File If Exist    ${sPath_XMLFile}
    ${FieldValue}    Get Field Value from XML Section    ${sPath_XMLFile}    ${sTemp_Path}    ${sField_Name}
    Take Screenshot    ${screenshot_path}/Screenshots/Integration/Validate_Notice_EventOutputWindow
    
    [Return]    ${CurrentDate}    ${FieldValue} 
    
Validate Notice in Logged Exception List Window in LIQ
    [Documentation]    This keyword navigates to Logged Exception List Window thru Exception Queue option item in WIP.
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: jaquitan    20MAR2019    - updated arguments
    ...    @update: jloretiz    13JUL2019    - updated documentation
    [Arguments]    ${sBEO_StartDate}    ${sBEO_EndDate}    ${sDeal_Name}    ${sNotice_Identifier}
    
    Refresh Tables in LIQ
    Navigate to Logged Exception List Window
    Validate Logged Exception List Window    ${sBEO_StartDate}    ${sBEO_EndDate}    ${sDeal_Name}    ${sNotice_Identifier}
    
Validate the Notice Window in LIQ
    [Documentation]    This keyword validates the fields, status and Data in Notice Window.
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: jaquitan    20Mar2019    - updated arguments
    ...    @update: ehugo       19AUG2019    - added Balance Amount and Rate Basis arguments
    ...    @update: ehugo       22AUG2019    - added arguments - Loan Effective and Maturity Dates, Loan Global Original and Rate Setting Due Date
    ...    @update: ehugo       23AUG2019    - added validation of Drawdown Intent Notice
    ...    @update: ehugo       13SEP2019    - added argument - Repricing Date
    ...    @update: fluberio    26OCT2020    - added argument for Upfront Fee From Borrower/Agent/Third Party Intent Notice
    ...    @update: makcamps    05NOV2020    - added argument for Interest Payment Notice
    ...    @update: makcamps    15JAN2021    - added argument for Line Fee in Advance Payment Notice
    ...    @update: makcamps    09FEB2021    - added argument for Repricing Intent Notice
    [Arguments]    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}    ${sNotice_Status}    ${sNotice_Customer_LegalName}    
    ...    ${sContact}    ${sNoticeGroup_UserID}    ${sNotice_Method}
    ...    ${sNotice_Type}    ${sPath_XMLFile}    ${sDeal_Name}    ${sXML_NoticeType}    ${sLoan_PricingOption}    
    ...    ${iLoan_BaseRate}    ${iLoan_Spread}    ${iNotice_AllInRate}    ${sOngoingFee_Type}    ${sNotice_Amount}    ${sBalance_Amount}    ${sRate_Basis}
    ...    ${sLoan_EffectiveDate}    ${sLoan_MaturityDate}    ${sLoan_GlobalOriginal}    ${sLoan_RateSetting_DueDate}    ${sLoan_RepricingDate}
    ...    ${sEffectiveDate}=None    ${sUpfrontFee_Amount}=None    ${sFee_Type}=None    ${sCurrency}=None    ${sAccount_Name}=None
    ...    ${sLoan_BorrowerAmount}=None    ${sLoan_LenderAmount}=None    ${sLoan_PaymentAmount}=None
    
    ### Keyword Pre-processing ###
    ${Search_By}    Acquire Argument Value    ${sSearch_By}
    ${Notice_Identifier}    Acquire Argument Value    ${sNotice_Identifier}
    ${From_Date}    Acquire Argument Value    ${sFrom_Date}
    ${Thru_Date}    Acquire Argument Value    ${sThru_Date}
    ${Notice_Status}    Acquire Argument Value    ${sNotice_Status}
    ${Notice_Customer_LegalName}    Acquire Argument Value    ${sNotice_Customer_LegalName}
    ${Contact}    Acquire Argument Value    ${sContact}
    ${NoticeGroup_UserID}    Acquire Argument Value    ${sNoticeGroup_UserID}
    ${Notice_Method}    Acquire Argument Value    ${sNotice_Method}
    ${Notice_Type}    Acquire Argument Value    ${sNotice_Type}
    ${Path_XMLFile}    Acquire Argument Value    ${sPath_XMLFile}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${XML_NoticeType}    Acquire Argument Value    ${sXML_NoticeType}
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
    ${Loan_BaseRate}    Acquire Argument Value    ${iLoan_BaseRate}
    ${Loan_Spread}    Acquire Argument Value    ${iLoan_Spread}
    ${Notice_AllInRate}    Acquire Argument Value    ${iNotice_AllInRate}
    ${OngoingFee_Type}    Acquire Argument Value    ${sOngoingFee_Type}
    ${Notice_Amount}    Acquire Argument Value    ${sNotice_Amount}
    ${Balance_Amount}    Acquire Argument Value    ${sBalance_Amount}
    ${Rate_Basis}    Acquire Argument Value    ${sRate_Basis}
    ${Loan_EffectiveDate}    Acquire Argument Value    ${sLoan_EffectiveDate}
    ${Loan_MaturityDate}    Acquire Argument Value    ${sLoan_MaturityDate}
    ${Loan_GlobalOriginal}    Acquire Argument Value    ${sLoan_GlobalOriginal}
    ${Loan_RateSetting_DueDate}    Acquire Argument Value    ${sLoan_RateSetting_DueDate}
    ${Loan_RepricingDate}    Acquire Argument Value    ${sLoan_RepricingDate}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${UpfrontFee_Amount}    Acquire Argument Value    ${sUpfrontFee_Amount}
    ${Fee_Type}    Acquire Argument Value    ${sFee_Type}
    ${Currency}    Acquire Argument Value    ${sCurrency}
    ${Account_Name}    Acquire Argument Value    ${sAccount_Name}
    ${Loan_BorrowerAmount}    Acquire Argument Value    ${sLoan_BorrowerAmount}
    ${Loan_LenderAmount}    Acquire Argument Value    ${sLoan_LenderAmount}
    ${Loan_PaymentAmount}    Acquire Argument Value    ${sLoan_PaymentAmount}

    Refresh Tables in LIQ
    Navigate to Notice Select Window
    Search Existing Notice    ${Search_By}    ${Notice_Identifier}    ${From_Date}    ${Thru_Date}
    Validate Notice Status    ${Notice_Identifier}    ${Notice_Status}     ${Notice_Customer_LegalName}    ${Contact}    ${NoticeGroup_UserID}    ${Notice_Method}
    Run Keyword If    '${Notice_Type}' == 'Rate Setting Notice'    Run Keyword    Validate DRAWDOWN RATE SET Notice Details    ${Path_XMLFile}    ${Notice_Customer_LegalName}    
    ...    ${Contact}    ${Deal_Name}    ${XML_NoticeType}    ${Loan_PricingOption}    ${Loan_BaseRate}
    ...    ${Loan_Spread}    ${Notice_AllInRate}    ${Notice_Amount}    ${Loan_EffectiveDate}    ${Loan_MaturityDate}    ${Loan_RepricingDate}
    ...    ELSE IF    '${Notice_Type}' == 'Fee Payment Notice'    Run Keyword    Validate Fee Notice Details    ${Path_XMLFile}    ${Notice_Customer_LegalName}    ${Contact}    
    ...    ${Deal_Name}    ${XML_NoticeType}    ${OngoingFee_Type}    ${Notice_AllInRate}    ${Notice_Amount}    ${Balance_Amount}    ${Rate_Basis}
    ...    ELSE IF    '${Notice_Type}' == 'Principal Payment Notice'    Run Keyword    Validate Principal Payment Notice Details    ${Path_XMLFile}    ${Notice_Customer_LegalName}    ${Contact}
    ...    ${Deal_Name}    ${XML_NoticeType}    ${Loan_PricingOption}    ${Notice_Amount}    
    ...    ELSE IF    '${Notice_Type}' == 'Drawdown Intent Notice'    Run Keyword    Validate Drawdown Intent Notice Details    ${Path_XMLFile}    ${Notice_Customer_LegalName}    ${Contact}
    ...    ${Deal_Name}    ${XML_NoticeType}    ${Loan_GlobalOriginal}    ${Loan_EffectiveDate}    ${Loan_RateSetting_DueDate}
    ...    ELSE IF    '${Notice_Type}' == 'Upfront Fee From Borrower/Agent/Third Party Intent Notice'    Validate Upfront Fee Notice Details    ${Path_XMLFile}    ${Notice_Customer_LegalName}    ${Contact}    
    ...    ${Deal_Name}    ${XML_NoticeType}    ${EffectiveDate}    ${UpfrontFee_Amount}    ${Fee_Type}    ${Currency}    ${Account_Name}
    ...    ELSE IF    '${Notice_Type}' == 'Interest Payment Notice'    Run Keyword    Validate Interest Payment Notice Details    ${Path_XMLFile}    ${Fee_Type}    ${Notice_AllInRate}    ${EffectiveDate}
    ...    ${Notice_Customer_LegalName}    ${Currency}    ${Notice_Amount}
    ...    ELSE IF    '${Notice_Type}' == 'Line Fee in Advance Payment Notice'    Run Keyword    Validate Line Fee in Advance Notice Details    ${Path_XMLFile}    ${Notice_Customer_LegalName}    ${Contact}    
    ...    ${Deal_Name}    ${XML_NoticeType}    ${OngoingFee_Type}    ${Notice_AllInRate}    ${Notice_Amount}    ${Rate_Basis}
    ...    ELSE IF    '${Notice_Type}' == 'Repricing Intent Notice'    Run Keyword    Validate Rollover Intent Notice Details    ${Path_XMLFile}    ${Notice_Customer_LegalName}    ${Contact}    ${Deal_Name}
    ...    ${XML_NoticeType}    ${Notice_AllInRate}    ${Rate_Basis}    ${EffectiveDate}    ${Loan_RepricingDate}    ${Loan_PricingOption}    ${Currency}
    ...    ${Loan_BorrowerAmount}    ${Loan_LenderAmount}    ${Loan_PaymentAmount}

Validate the Paperclip Notice Window in LIQ
    [Documentation]    This keyword validates the fields, status and Data in Paperclip Notice Window.
    ...    @author: ehugo
    [Arguments]    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}    ${sNotice_Status}    ${sNotice_Customer_LegalName}    
    ...    ${sContact}    ${sNoticeGroup_UserID}    ${sNotice_Method}
    ...    ${sNotice_Type}    ${sPath_XMLFile}    ${sDeal_Name}    ${sOutstanding_Principal}    ${sProjectedCycleDue_Interest}
    ...    ${iPrincipal_Amount}    ${iLoan_AllInRate}    ${iInterest_Amount}    ${sEffectiveDate_Principal}    ${sEffectiveDate_Interest}
    
    Refresh Tables in LIQ
    Navigate to Notice Select Window
    Search Existing Notice    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}
    Validate Notice Status    ${sNotice_Identifier}    ${sNotice_Status}     ${sNotice_Customer_LegalName}    ${sContact}    ${sNoticeGroup_UserID}    ${sNotice_Method}
    Validate PAPERCLIP INTENT Notice Details    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}
    ...    ${sDeal_Name}    ${sOutstanding_Principal}    ${sProjectedCycleDue_Interest}
    ...    ${iPrincipal_Amount}    ${iLoan_AllInRate}    ${iInterest_Amount}    ${sEffectiveDate_Principal}    ${sEffectiveDate_Interest}
        

Resend Notice via Notices Application in LIQ
    [Documentation]    This keyword search and resends the Notice thru Notices Application.
    ...    @author:cfrancis
    [Arguments]    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sStatus}
     
    ###Search for an Existing Notice### 
    Navigate to Notice Select Window
    Search Existing Notice    ${sSearch_By}    ${sNotice_Identifier}    ${sFrom_Date}    ${sThru_Date}
    
    ###Validate Button and Fields###
    Validate Buttons and Fields in Notice Window
    
    ###Update Data and Send the Notice###
    Validate and Resend Notice    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sNotice_Identifier}    ${sStatus}

Save Notice via WIP in LIQ
    [Documentation]    This keyword search and send the Notice thru WIP.
    ...    @author: mgaling
    ...    @update: jaquitan  26Mar2019  - changed arguments based on datatype
    [Arguments]    ${sNotice_Identifier}    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sNotice_Status}    
    
    ###Search for an Existing Notice### 
    Search Notice via WIP    Awaiting Release    ${sNotice_Identifier}    ${sNotice_Status}
    
    ###Validate Button and Fields###
    Validate Buttons and Fields in Notice Window
    
    ###Update Data and Send the Notice###
    Validate and Save Notice    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sNotice_Identifier}
    
Send Notice via WIP in LIQ
    [Documentation]    This keyword search and send the Notice thru WIP.
    ...    @author: mgaling
    ...    @update: jaquitan  26mar2019  - changed arguments based on datatype
    ...    @update: ehugo    08152019    used variable for 'Awaiting Release'
    [Arguments]    ${sNotice_Identifier}    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sNotice_Status}    
    
    ###Search for an Existing Notice### 
    Search Notice via WIP    ${Initial_Transaction_Status}    ${sNotice_Identifier}    ${sNotice_Status}
    
    ###Validate Button and Fields###
    Validate Buttons and Fields in Notice Window
    
    ###Update Data and Send the Notice###
    Validate and Send Notice    ${sNotice_Customer_LegalName}    ${sNotice_Method}    ${sNotice_Identifier}
    
    
Validate Resent Notice in Business Event Output Window in LIQ and Return CurrentDate and FieldValue
    [Documentation]    This kewyord navigates to Business Event Output Window thru Event Management Queue Option in LIQ.
    ...    @author: cfrancis
    ...    @update:jaquitan 21Mar2019 removed write, add return for current date and field value
    [Arguments]    ${rowid}    ${sCustomer_IdentifiedBy}    ${sNotice_Customer_LegalName}    ${sNotice_Identifier}    ${sPath_XMLFile}    ${sTemp_Path}    ${sField_Name}
    
    ###Gets Current Date###  
    ${CurrentDate}    Get Current Date 
   
    Navigate to Business Event Output Window
    Validate Statuses Section 
    Populate Filter Section    ${CurrentDate}    ${CurrentDate}    ${sCustomer_IdentifiedBy}    ${sNotice_Customer_LegalName}
    Validate Resent Notice Event Output Record    ${sNotice_Identifier}
    Delete File If Exist    ${sPath_XMLFile}
    ${FieldValue}    Get Field Value from XML Section    ${sPath_XMLFile}    ${sTemp_Path}    ${sField_Name}
                
    Write Data To Excel for API_Data    Correspondence    Correlation_ID    ${rowid}    ${Field_Value}
    [Return]    ${CurrentDate}    ${FieldValue}    


    
Validate Failed Notice in Logged Exception List Window in LIQ
    [Documentation]    This keyword navigates to Logged Exception List Window thru Exception Queue option item in WIP.
    ...    @author: mgaling
    ...    @update:jaquitan 21Mar2019 updated arguments
    [Arguments]    ${sDeal_Name}    ${sNotice_Identifier}    ${sWIP_ExceptionQueueDescription}
    
    Refresh Tables in LIQ
    Navigate to Logged Exception List Window
    Validate Logged Exception List Window - Failed    ${sDeal_Name}    ${sNotice_Identifier}    ${sWIP_ExceptionQueueDescription}    
      

    
Validate the Notice Window in LIQ thru WIP
    [Documentation]    This keyword navigates back to Notice Window thru WIP and validates data.
    ...    @author: mgaling
    ...    @update:jaquitan 21Mar2019 updated arguments
    ...    @update: ehugo    22AUG2019    added arguments - Interest Due, Loan Effective and Maturity Dates 
    ...    @update: ehugo    13SEP2019    added argument - Repricing Date
    [Arguments]    ${sNotice_Status}    ${sNotice_Identifier}    ${sNotice_Method}    ${sNotice_Customer_LegalName}    ${sContact}    ${sNotice_Type}    ${sPath_XMLFile}    ${sDeal_Name}
    ...    ${sXML_NoticeType}    ${sLoan_PricingOption}    ${iLoan_BaseRate}    ${iLoan_Spread}    ${iNotice_AllInRate}    ${sOngoingFee_Type}    ${sNotice_Amount}    ${sBalance_Amount}    ${sRate_Basis}    
    ...    ${sLoan_EffectiveDate}    ${sLoan_MaturityDate}    ${sLoan_RepricingDate}
    
    Search Notice via WIP    ${sNotice_Status}    ${sNotice_Identifier}    ${sNotice_Status}
    Run Keyword If    '${sNotice_Type}' == 'Rate Setting Notice'    Run Keyword    Validate DRAWDOWN RATE SET Notice Details    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    
    ...    ${sContact}    ${sDeal_Name}    ${sXML_NoticeType}    ${sLoan_PricingOption}    ${iLoan_BaseRate}
    ...    ${iLoan_Spread}    ${iNotice_AllInRate}    ${sNotice_Amount}    ${sLoan_EffectiveDate}    ${sLoan_MaturityDate}    ${sLoan_RepricingDate}
    ...    ELSE IF    '${sNotice_Type}' == 'Fee Payment Notice'    Run Keyword    Validate Fee Notice Details    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}    
    ...    ${sDeal_Name}    ${sXML_NoticeType}    ${sOngoingFee_Type}    ${iNotice_AllInRate}    ${sNotice_Amount}    ${sBalance_Amount}    ${sRate_Basis}
    ...    ELSE IF    '${sNotice_Type}' == 'Principal Payment Notice'    Run Keyword    Validate Principal Payment Notice Details    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}
    ...    ${sDeal_Name}    ${sXML_NoticeType}    ${sLoan_PricingOption}    ${sNotice_Amount}  
    Close All Windows on LIQ
   
Send Notice on Principal Payment in LIQ
    [Documentation]    This keyword is for generating Intent Notices under Work flow Tab.
    ...    @author:mgaling 
    ...    @update:jaquitan 21Mar2019 updated arguments and variables
    [Arguments]    ${rowid}    ${sSubAdd_Days}    ${sDeal_Name}    ${sFacility_Name}    ${sLoan_Alias}    ${sNotice_Method}    ${sZero_TempPath}   
    
    ###Get System Date###
    ${SystemDate}    Get System Date
    ${SystemDate}    Convert Date    ${SystemDate}     date_format=%d-%b-%Y
    ${FromDate}    Subtract Time From Date    ${SystemDate}    ${sSubAdd_Days}days
    ${ThruDate}    Add Time To Date    ${SystemDate}    ${sSubAdd_Days}days
    Write Data To Excel for API_Data    Correspondence    From_Date    ${rowid}    ${FromDate}
    Write Data To Excel for API_Data   Correspondence    Thru_Date    ${rowid}    ${ThruDate}
     
    Launch Loan Notebook    ${sDeal_Name}    ${sFacility_Name}    ${sLoan_Alias}
    Navigate from Loan to Repayment Schedule
    Create Pending Transaction for Payment Schedule    1    ${SystemDate}
    Navigate from General to Workflow - Principal Payment
    Validate and Send Notice on Principal Payment    ${rowid}    ${sNotice_Method}    ${sZero_TempPath}

Validate and Send Notice on Principal Payment
    [Documentation]    This keyword generates Intent Notice from Principal Payment Notebook.
    ...    @author: mgaling
    ...    @update:jaquitan 21Mar2019 updated arguments and variables
    [Arguments]    ${rowid}    ${sNotice_Method}    ${sZero_TempPath}    
    
    ###Scheduled Principal Payment Notebook###
    mx LoanIQ activate window    ${LIQ_PrincipalPayment_Window}
    Mx LoanIQ Select Window Tab    ${LIQ_PrincipalPayment_Tab}    Workflow
    ${Status}    Run Keyword And Return Status    Mx LoanIQ Select String    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices         
    Run Keyword If    ${Status}==True    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Payment_WorkflowItems}    Generate Intent Notices%d   
    Run Keyword If    ${Status}==False    Log    Fail    'Generate Intent Notices' item is not available  
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}  
    
    ###Notices Window###
    mx LoanIQ activate window    ${LIQ_Notices_Window}
    mx LoanIQ click    ${LIQ_Notices_OK_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}    
    
    ###Notice Group Window###
    mx LoanIQ activate window    ${LIQ_NoticeGroup_Window}
    
    ###Select item with Awaiting Release status and Email Notice Method###    
    Mx LoanIQ GetDataToExcel    ${LIQ_NoticeGroup_Items_JavaTree}    excelpath=${sZero_TempPath}
    Open Excel    ${sZero_TempPath}
    ${Value}=    Get Row Count    Sheet0
    ${Value}    Convert To Integer    ${Value}    
    
    :FOR    ${Testing}    IN RANGE    1    ${Value}
    \    ${NoticeCustomerLegalName}    Read Data From Excel for ZeroPath    ${sZero_TempPath}    Sheet0    Customer    ${Testing}
    \    ${Contact}    Read Data From Excel for ZeroPath    ${sZero_TempPath}    Sheet0    Contact    ${Testing}
    \    ${Status}    Read Data From Excel for ZeroPath    ${sZero_TempPath}    Sheet0    Status    ${Testing}
    \    ${OrigUserID}    Read Data From Excel for ZeroPath    ${sZero_TempPath}    Sheet0    User Id    ${Testing}
    \    ${OrigNoticeMethod}    Read Data From Excel for ZeroPath    ${sZero_TempPath}    Sheet0    Notice Method    ${Testing}    
    \
    \    Run Keyword If    '${OrigNoticeMethod}' == 'Email' and '${Status}' == 'Awaiting release'    Exit For Loop
    \    Run Keyword If    '${Testing}' == '${Value-1}' and '${Status}' != 'Awaiting release' and '${OrigNoticeMethod}' != 'Email'    Fail
    
    Mx LoanIQ Select String    ${LIQ_NoticeGroup_Items_JavaTree}    ${NoticeCustomerLegalName}\t${Contact}\t${Status}\t${OrigUserID}\t${OrigNoticeMethod}
               
    mx LoanIQ click    ${LIQ_NoticeGroup_EditHighlightNotices}
    Sleep    2s
    
    mx LoanIQ activate window    ${LIQ_NoticeGroup_Window}
    mx LoanIQ close window    ${LIQ_NoticeGroup_Window}        
    
    ###Notice Window###
    mx LoanIQ activate window    ${LIQ_Notice_Window}
    ${NoticeID}    Mx LoanIQ Get Data    ${LIQ_Notice_NoticeID_Field}    value%ID
    
    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%Awaiting release 
    mx LoanIQ select list    ${LIQ_Notice_NoticeMethod_List}    ${sNotice_Method}
          
    mx LoanIQ select    ${LIQ_Notice_FileSave_Menu}
    mx LoanIQ select    ${LIQ_Notice_OptionsSend_Menu}
    Mx LoanIQ Verify Runtime Property    ${LIQ_Notice_Status_StaticText}    attached text%Queued
    
    Write Data To Excel for API_Data    Correspondence    Notice_Identifier    ${rowid}    ${NoticeID}   
    Write Data To Excel for API_Data    Correspondence    Notice_Customer_LegalName    ${rowid}    ${NoticeCustomerLegalName}
    Write Data To Excel for API_Data    Correspondence    Contact   ${rowid}    ${Contact}
    
    Close All Windows on LIQ  
      
Validate DRAWDOWN RATE SET Notice Details
    [Documentation]    This keyword validates the Notice details in XML.
    ...    @author: mgaling
    ...    @update:jaquitan 21Mar2019 updated arguments and variables
    ...    @update: ehugo    22AUG2019    added arguments - Interest Due, Loan Effective and Maturity Dates
    ...    @update: ehugo    13SEP2019    added argument - Repricing Date
    ...    @update: kduenas    27OCT2020    removed Loan Term Validation - Effective and Maturity Date as this is no longer present in the rate notice 
    [Arguments]    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}    ${sDeal_Name}    ${sXML_NoticeType}    ${sLoan_PricingOption}    ${iLoan_BaseRate}
    ...    ${iLoan_Spread}    ${iLoan_AllInRate}    ${iInterest_Due}    ${sLoan_EffectiveDate}    ${sLoan_MaturityDate}    ${sLoan_RepricingDate}
    
    
    ${XMLFile}    OperatingSystem.Get File    ${sPath_XMLFile} 
    
    ###Customer Legal Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Customer_LegalName}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Customer_LegalName} is present
    ...    ELSE    Fail    ${sNotice_Customer_LegalName} is not present
    
    ###Contact Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sContact}
    Run Keyword If    ${Status}==True    Log    ${sContact} is present
    ...    ELSE    Fail    ${sContact} is not present
    
    ###Deal Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sDeal_Name}
    Run Keyword If    ${Status}==True    Log    ${sDeal_Name} is present
    ...    ELSE    Fail    ${sDeal_Name} is not present
    
    ###Notice Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sXML_NoticeType}
    Run Keyword If    ${Status}==True    Log    ${sXML_NoticeType} is present
    ...    ELSE    Fail    ${sXML_NoticeType} is not present
    
    ###Loan Pricing Option Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sLoan_PricingOption}
    Run Keyword If    ${Status}==True    Log    ${sLoan_PricingOption} is present
    ...    ELSE    Fail    ${sLoan_PricingOption} is not present
    
    ###Loan Base Rate Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${iLoan_BaseRate}
    Run Keyword If    ${Status}==True    Log    ${iLoan_BaseRate} is present
    ...    ELSE    Fail    ${iLoan_BaseRate} is not present
    
    ###Loan Spread Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${iLoan_Spread}
    Run Keyword If    ${Status}==True    Log    ${iLoan_Spread} is present
    ...    ELSE    Fail    ${iLoan_Spread} is not present
    
    ###Loan All in Rate Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${iLoan_AllInRate}
    Run Keyword If    ${Status}==True    Log    ${iLoan_AllInRate} is present
    ...    ELSE    Fail    ${iLoan_AllInRate} is not present

    ###Interest Due Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${iInterest_Due}
    Run Keyword If    ${Status}==True    Log    ${iInterest_Due} is present
    ...    ELSE    Fail    ${iInterest_Due} is not present

    # ###Loan Term Validation - Effective and Maturity Date###
    # ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    Term: ${sLoan_EffectiveDate} - ${sLoan_MaturityDate}
    # Run Keyword If    ${Status}==True    Log    Term: ${sLoan_EffectiveDate} - ${sLoan_MaturityDate} is present
    # ...    ELSE    Fail    Term: ${sLoan_EffectiveDate} - ${sLoan_MaturityDate} is not present
    
    ###Loan Term Validation - Effective and Repricing Date###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    Term: ${sLoan_EffectiveDate} - ${sLoan_RepricingDate}
    Run Keyword If    ${Status}==True    Log    Term: ${sLoan_EffectiveDate} - ${sLoan_RepricingDate} is present
    ...    ELSE    Fail    Term: ${sLoan_EffectiveDate} - ${sLoan_RepricingDate} is not present
    
    ###Loan Effective Date Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    Effective Date: ${sLoan_EffectiveDate}
    Run Keyword If    ${Status}==True    Log    Effective Date: ${sLoan_EffectiveDate} is present
    ...    ELSE    Fail    Effective Date: ${sLoan_EffectiveDate} is not present

Validate PAPERCLIP INTENT Notice Details
    [Documentation]    This keyword validates the Paperclip Intent Notice details in XML.
    ...    @author: ehugo
    [Arguments]    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}    ${sDeal_Name}    ${sOutstanding_Principal}    ${sProjectedCycleDue_Interest}
    ...    ${iPrincipal_Amount}    ${iLoan_AllInRate}    ${iInterest_Amount}    ${sEffectiveDate_Principal}    ${sEffectiveDate_Interest}    
    
    
    ${XMLFile}    OperatingSystem.Get File    ${sPath_XMLFile} 
    
    ###Customer Legal Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Customer_LegalName}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Customer_LegalName} is present
    ...    ELSE    Fail    ${sNotice_Customer_LegalName} is not present
    
    ###Contact Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sContact}
    Run Keyword If    ${Status}==True    Log    ${sContact} is present
    ...    ELSE    Fail    ${sContact} is not present
    
    ###Deal Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sDeal_Name}
    Run Keyword If    ${Status}==True    Log    ${sDeal_Name} is present
    ...    ELSE    Fail    ${sDeal_Name} is not present
    
    ###Principal Payment Total Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sOutstanding_Principal}
    Run Keyword If    ${Status}==True    Log    ${sOutstanding_Principal} is present
    ...    ELSE    Fail    ${sOutstanding_Principal} is not present
    
    ###Interest Payment Total Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sProjectedCycleDue_Interest}
    Run Keyword If    ${Status}==True    Log    ${sProjectedCycleDue_Interest} is present
    ...    ELSE    Fail    ${sProjectedCycleDue_Interest} is not present
    
    ###Principal Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${iPrincipal_Amount}
    Run Keyword If    ${Status}==True    Log    ${iPrincipal_Amount} is present
    ...    ELSE    Fail    ${iPrincipal_Amount} is not present
    
    ###Loan All in Rate Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${iLoan_AllInRate}
    Run Keyword If    ${Status}==True    Log    ${iLoan_AllInRate} is present
    ...    ELSE    Fail    ${iLoan_AllInRate} is not present

    ###Interest Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${iInterest_Amount}
    Run Keyword If    ${Status}==True    Log    ${iInterest_Amount} is present
    ...    ELSE    Fail    ${iInterest_Amount} is not present
    
    ###Effective Date - Principal Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sEffectiveDate_Principal}
    Run Keyword If    ${Status}==True    Log    ${sEffectiveDate_Principal} is present
    ...    ELSE    Fail    ${sEffectiveDate_Principal} is not present
    
    ###Effective Date - Interest Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sEffectiveDate_Interest}
    Run Keyword If    ${Status}==True    Log    ${sEffectiveDate_Interest} is present
    ...    ELSE    Fail    ${sEffectiveDate_Interest} is not present
    
Validate Principal Payment Notice Details
    [Documentation]    This keyword validates the Notice details in XML.
    ...    @author: mgaling
    ...    @update:jaquitan 21Mar2019 updated arguments and variables
    [Arguments]    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}    ${sDeal_Name}    ${sXML_NoticeType}    ${sLoan_PricingOption}    ${sNotice_Amount}                
    
    ${XMLFile}    OperatingSystem.Get File    ${sPath_XMLFile} 
    
    ###Customer Legal Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Customer_LegalName}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Customer_LegalName} is present
    ...    ELSE    Fail    ${sNotice_Customer_LegalName} is not present
    
    ###Contact Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sContact}
    Run Keyword If    ${Status}==True    Log    ${sContact} is present
    ...    ELSE    Fail    ${sContact} is not present
    
    ###Deal Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sDeal_Name}
    Run Keyword If    ${Status}==True    Log    ${sDeal_Name} is present
    ...    ELSE    Fail    ${sDeal_Name} is not present
    
    ###Notice Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sXML_NoticeType}
    Run Keyword If    ${Status}==True    Log    ${sXML_NoticeType} is present
    ...    ELSE    Fail    ${sXML_NoticeType} is not present
    
    ###Loan Pricing Option Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sLoan_PricingOption}
    Run Keyword If    ${Status}==True    Log    ${sLoan_PricingOption} is present
    ...    ELSE    Fail    ${sLoan_PricingOption} is not present 
    
    ###Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Amount}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Amount} is present
    ...    ELSE    Fail    ${sNotice_Amount} is not present

Validate Drawdown Intent Notice Details
    [Documentation]    This keyword validates the Notice details in XML.
    ...    @author: ehugo    23AUG2019
    [Arguments]    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}    ${sDeal_Name}    ${sXML_NoticeType}    ${sNotice_Amount}    ${sEffectiveDate}    ${sRateSetting_DueDate}
    
    ${XMLFile}    OperatingSystem.Get File    ${sPath_XMLFile} 
    
    ###Customer Legal Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Customer_LegalName}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Customer_LegalName} is present
    ...    ELSE    Fail    ${sNotice_Customer_LegalName} is not present
    
    ###Contact Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sContact}
    Run Keyword If    ${Status}==True    Log    ${sContact} is present
    ...    ELSE    Fail    ${sContact} is not present
    
    ###Deal Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sDeal_Name}
    Run Keyword If    ${Status}==True    Log    ${sDeal_Name} is present
    ...    ELSE    Fail    ${sDeal_Name} is not present
    
    ###Notice Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sXML_NoticeType}
    Run Keyword If    ${Status}==True    Log    ${sXML_NoticeType} is present
    ...    ELSE    Fail    ${sXML_NoticeType} is not present
    
    ###Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Amount}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Amount} is present
    ...    ELSE    Fail    ${sNotice_Amount} is not present
    
    ###Effective Date###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sEffectiveDate}
    Run Keyword If    ${Status}==True    Log    ${sEffectiveDate} is present
    ...    ELSE    Fail    ${sEffectiveDate} is not present
    
    ###Rate Setting Due Date###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sRateSetting_DueDate}
    Run Keyword If    ${Status}==True    Log    ${sRateSetting_DueDate} is present
    ...    ELSE    Fail    ${sRateSetting_DueDate} is not present
    
Validate Fee Notice Details
    [Documentation]    This keyword validates the Notice details in XML.
    ...    @author: mgaling
    ...    @update:jaquitan 21Mar2019 updated arguments and variables
    ...    @update: ehugo    08192019    added validation for Balance Amount and Rate Basis
    [Arguments]    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}    ${sDeal_Name}    ${sXML_NoticeType}    ${sOngoingFee_Type}    ${sNotice_AllInRate}    ${sNotice_Amount}    ${sBalance_Amount}    ${sRate_Basis}
                 
    
    ${XMLFile}    OperatingSystem.Get File    ${sPath_XMLFile} 
    
    ###Customer Legal Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Customer_LegalName}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Customer_LegalName} is present
    ...    ELSE    Fail    ${sNotice_Customer_LegalName} is not present
    
    ###Contact Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sContact}
    Run Keyword If    ${Status}==True    Log    ${sContact} is present
    ...    ELSE    Fail    ${sContact} is not present
    
    ###Deal Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sDeal_Name}
    Run Keyword If    ${Status}==True    Log    ${sDeal_Name} is present
    ...    ELSE    Fail    ${sDeal_Name} is not present
    
    ###Notice Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sXML_NoticeType}
    Run Keyword If    ${Status}==True    Log    ${sXML_NoticeType} is present
    ...    ELSE    Fail    ${sXML_NoticeType} is not present
    
    ###Fee Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sOngoingFee_Type}
    Run Keyword If    ${Status}==True    Log    ${sOngoingFee_Type} is present
    ...    ELSE    Fail    ${sOngoingFee_Type} is not present 
    
    ###All In Rate Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_AllInRate}
    Run Keyword If    ${Status}==True    Log    ${sNotice_AllInRate} is present
    ...    ELSE    Fail    ${sNotice_AllInRate} is not present 
    
    ###Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Amount}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Amount} is present
    ...    ELSE    Fail    ${sNotice_Amount} is not present 
    
    ###Balance Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sBalance_Amount}
    Run Keyword If    ${Status}==True    Log    ${sBalance_Amount} is present
    ...    ELSE    Fail    ${sBalance_Amount} is not present 
    
    ###Rate Basis Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sRate_Basis}
    Run Keyword If    ${Status}==True    Log    ${sRate_Basis} is present
    ...    ELSE    Fail    ${sRate_Basis} is not present 

Validate Upfront Fee Notice Details
    [Documentation]    This keyword validates the Upfront Fee Notice details in XML.
    ...    @author: fluberio    26OCT2020    initial create
    [Arguments]    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}    ${sDeal_Name}    ${sXML_NoticeType}    ${sEffectiveDate}    ${sUpfrontFee_Amount}    ${sFee_Type}    ${sCurrency}    ${sAccount_Name}
                 
    
    ${XMLFile}    OperatingSystem.Get File    ${sPath_XMLFile} 
    
    ###Customer Legal Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Customer_LegalName}
    Run Keyword If    ${Status}==${True}    Log    ${sNotice_Customer_LegalName} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sNotice_Customer_LegalName} is not present
    
    ###Contact Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sContact}
    Run Keyword If    ${Status}==${True}    Log    ${sContact} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sContact} is not present
    
    ###Deal Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sDeal_Name}
    Run Keyword If    ${Status}==${True}    Log    ${sDeal_Name} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sDeal_Name} is not present
    
    ###Notice Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sXML_NoticeType}
    Run Keyword If    ${Status}==${True}    Log    ${sXML_NoticeType} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sXML_NoticeType} is not present
    
    ###Effective Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sEffectiveDate}
    Run Keyword If    ${Status}==${True}    Log    ${sEffectiveDate} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sEffectiveDate} is not present 
    
    ###Upfront Fee Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sUpfrontFee_Amount}
    Run Keyword If    ${Status}==${True}    Log    ${sUpfrontFee_Amount} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sUpfrontFee_Amount} is not present 
    
    ###Fee Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sFee_Type}
    Run Keyword If    ${Status}==${True}    Log    ${sFee_Type} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sFee_Type} is not present 
    
    ###Currency Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sCurrency}
    Run Keyword If    ${Status}==${True}    Log    ${sCurrency} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sCurrency} is not present 
    
    ###Account Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sAccount_Name}    ignore_case=True
    Run Keyword If    ${Status}==${True}    Log    ${sAccount_Name} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sAccount_Name} is not present 

Validate Interest Payment Notice Details
    [Documentation]    This keyword validates the Upfront Fee Notice details in XML.
    ...    @author: makcamps    05NOV2020    initial create
    [Arguments]    ${sPath_XMLFile}    ${sFee_Type}    ${iNotice_AllInRate}    ${sEffectiveDate}    ${sNotice_Customer_LegalName}    ${sCurrency}    ${sNotice_Amount}
                 
    
    ${XMLFile}    OperatingSystem.Get File    ${sPath_XMLFile} 
    
    ###Fee Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sFee_Type}
    Run Keyword If    ${Status}==${True}    Log    ${sFee_Type} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sFee_Type} is not present 
    
    ###Rate Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${iNotice_AllInRate}
    Run Keyword If    ${Status}==${True}    Log    ${iNotice_AllInRate} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${iNotice_AllInRate} is not present
    
    ###Effective Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sEffectiveDate}
    Run Keyword If    ${Status}==${True}    Log    ${sEffectiveDate} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sEffectiveDate} is not present 
    
    ###Customer Legal Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Customer_LegalName}
    Run Keyword If    ${Status}==${True}    Log    ${sNotice_Customer_LegalName} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sNotice_Customer_LegalName} is not present
    
    ###Currency Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sCurrency}
    Run Keyword If    ${Status}==${True}    Log    ${sCurrency} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sCurrency} is not present 
    
    ###All in Rate Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Amount}
    Run Keyword If    ${Status}==${True}    Log    ${sNotice_Amount} is present
    ...    ELSE    Run Keyword And Continue On Failure    FAIL    ${sNotice_Amount} is not present 
    
Validate Line Fee in Advance Notice Details
    [Documentation]    This keyword validates the Notice details in XML.
    ...    @author: makcamps    15JAN2021    - initial create
    ...    @update: makcamps    08FEB2021    - removed all in rate in validation, not available in xml
    [Arguments]    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}    ${sDeal_Name}    ${sXML_NoticeType}    ${sOngoingFee_Type}    ${sNotice_AllInRate}    ${sNotice_Amount}    ${sRate_Basis}
                 
    
    ${XMLFile}    OperatingSystem.Get File    ${sPath_XMLFile} 
    
    ###Customer Legal Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Customer_LegalName}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Customer_LegalName} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${sNotice_Customer_LegalName} is not present
    
    ###Contact Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sContact}
    Run Keyword If    ${Status}==True    Log    ${sContact} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${sContact} is not present
    
    ###Deal Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sDeal_Name}
    Run Keyword If    ${Status}==True    Log    ${sDeal_Name} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${sDeal_Name} is not present
    
    ###Notice Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sXML_NoticeType}
    Run Keyword If    ${Status}==True    Log    ${sXML_NoticeType} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${sXML_NoticeType} is not present
    
    ###Fee Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sOngoingFee_Type}
    Run Keyword If    ${Status}==True    Log    ${sOngoingFee_Type} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${sOngoingFee_Type} is not present
    
    ###Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sNotice_Amount}
    Run Keyword If    ${Status}==True    Log    ${sNotice_Amount} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${sNotice_Amount} is not present 
    
    ###Rate Basis Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${sRate_Basis}
    Run Keyword If    ${Status}==True    Log    ${sRate_Basis} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${sRate_Basis} is not present  
    
Validate Rollover Intent Notice Details
    [Documentation]    This keyword validates the Notice details in XML.
    ...    @author: makcamps    08FEB2021    - initial create
    [Arguments]    ${sPath_XMLFile}    ${sNotice_Customer_LegalName}    ${sContact}    ${sDeal_Name}    ${sXML_NoticeType}
    ...    ${sNotice_AllInRate}    ${sRate_Basis}    ${sEffectiveDate}    ${sLoan_RepricingDate}    ${sLoan_PricingOption}
    ...    ${sCurrency}    ${sLoan_BorrowerAmount}    ${sLoan_LenderAmount}    ${sLoan_PaymentAmount}
    
    ### Keyword Pre-processing ###
    ${Path_XMLFile}    Acquire Argument Value    ${sPath_XMLFile}
    ${Notice_Customer_LegalName}    Acquire Argument Value    ${sNotice_Customer_LegalName}
    ${Contact}    Acquire Argument Value    ${sContact}
    ${Deal_Name}    Acquire Argument Value    ${sDeal_Name}
    ${XML_NoticeType}    Acquire Argument Value    ${sXML_NoticeType}
    ${Notice_AllInRate}    Acquire Argument Value    ${sNotice_AllInRate}
    ${Rate_Basis}    Acquire Argument Value    ${sRate_Basis}
    ${EffectiveDate}    Acquire Argument Value    ${sEffectiveDate}
    ${Loan_RepricingDate}    Acquire Argument Value    ${sLoan_RepricingDate}
    ${Loan_PricingOption}    Acquire Argument Value    ${sLoan_PricingOption}
    ${Currency}    Acquire Argument Value    ${sCurrency}
    ${Loan_BorrowerAmount}    Acquire Argument Value    ${sLoan_BorrowerAmount}
    ${Loan_LenderAmount}    Acquire Argument Value    ${sLoan_LenderAmount}
    ${Loan_PaymentAmount}    Acquire Argument Value    ${sLoan_PaymentAmount}

    ${XMLFile}    OperatingSystem.Get File    ${Path_XMLFile} 
    
    ###Customer Legal Name Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Notice_Customer_LegalName}
    Run Keyword If    ${Status}==${True}    Log    ${Notice_Customer_LegalName} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${Notice_Customer_LegalName} is not present
    
    ###Contact Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Contact}
    Run Keyword If    ${Status}==${True}    Log    ${Contact} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${Contact} is not present
    
    ###Deal Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Deal_Name}
    Run Keyword If    ${Status}==${True}    Log    ${Deal_Name} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${Deal_Name} is not present
    
    ###Notice Type Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${XML_NoticeType}
    Run Keyword If    ${Status}==${True}    Log    ${XML_NoticeType} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${XML_NoticeType} is not present
    
    ###Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Notice_AllInRate}
    Run Keyword If    ${Status}==${True}    Log    ${Notice_AllInRate} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${Notice_AllInRate} is not present
    
    ###Rate Basis Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Rate_Basis}
    Run Keyword If    ${Status}==${True}    Log    ${Rate_Basis} is present
    ...    ELSE    Run Keyword and Continue on Failure    Fail    ${Rate_Basis} is not present 
    
    ###Effective Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${EffectiveDate}
    Run Keyword If    ${Status}==${True}    Log    ${EffectiveDate} is present
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${EffectiveDate} is not present 
    
    ###Repricing Date Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Loan_RepricingDate}
    Run Keyword If    ${Status}==${True}    Log    ${Loan_RepricingDate} is present
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${Loan_RepricingDate} is not present
    
    ###Loan Pricing Option Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Loan_PricingOption}
    Run Keyword If    ${Status}==${True}    Log    ${Loan_PricingOption} is present
    ...    ELSE    Fail    ${Loan_PricingOption} is not present 
    
    ###Currency Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Currency}
    Run Keyword If    ${Status}==${True}    Log    ${Currency} is present
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${Currency} is not present 
    
    ###Loan Borrower Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Loan_BorrowerAmount}
    Run Keyword If    ${Status}==${True}    Log    ${Loan_BorrowerAmount} is present
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${Loan_BorrowerAmount} is not present
    
    ###Loan Lender Amount Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Loan_LenderAmount}
    Run Keyword If    ${Status}==${True}    Log    ${Loan_LenderAmount} is present
    ...    ELSE    Fail    ${Loan_LenderAmount} is not present 
    
    ###Loan Payment Validation###
    ${Status}    Run Keyword And Return Status    Should Contain    ${XMLFile}    ${Loan_PaymentAmount}
    Run Keyword If    ${Status}==${True}    Log    ${Loan_PaymentAmount} is present
    ...    ELSE    Run Keyword And Continue On Failure    Fail    ${Loan_PaymentAmount} is not present 