*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Get Notice Details via Loan Notebook
    [Documentation]    Get Notice Details (Effective Date, Term Start and End Date, Fixed Rate Option, Margin, All-in Rate and Interest Due) via Loan Notebook in LIQ
    ...    @author: makcamps   22JAN2021    - initial create
    [Arguments]    ${sFacilityName}    ${sDealName}    ${sLoanAlias}

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
    
    Write Data To Excel    Correspondence    Loan_EffectiveDate    ${rowid}    ${Effective_Date}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_RepricingDate    ${rowid}    ${Repricing_Date}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_MaturityDate    ${rowid}    ${Maturity_Date}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_BaseRate    ${rowid}    ${Base_Rate}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_Spread    ${rowid}    ${Spread}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Notice_AllInRate    ${rowid}    ${AllIn_Rate}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Notice_Amount    ${rowid}    ${Cycle_Due}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_GlobalOriginal    ${rowid}    ${Global_Original}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_RateSetting_DueDate    ${rowid}    ${RateSetting_DueDate}    ${ExcelPath}    bTestCaseColumn=True    sColumnReference=rowid

    Close All Windows on LIQ
    
Send Intent Notice for Loan Drawdown
    [Documentation]    This keyword is use to successfully sent out a Drawdown Intent Notice via Notice Application without validation in FFC
    ...    @author: makcamps    22JAN2021    - initial create
    [Arguments]    ${ExcelPath}
    
    Get Notice Details via Loan Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_Alias]
    
    Get the Notice Details of Specific Contact in LIQ    &{ExcelPath}[SubAdd_Days]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Notice_Type]    &{ExcelPath}[Zero_TempPath]00.xls    &{ExcelPath}[Contact]
    
    ${FromDate}    Read Data From Excel    Correspondence    From_Date    ${rowid}
    ${ThruDate}    Read Data From Excel    Correspondence    Thru_Date    ${rowid}
    
    ${NoticeIdentifier}    Read Data From Excel    Correspondence    Notice_Identifier    ${rowid}
    ${NoticeCustomerLegalName}    Read Data From Excel    Correspondence    Notice_Customer_LegalName    ${rowid} 
    
    ### Validate and Sent Notice ###
    Send Notice via Notices Application in LIQ     &{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    
    ...    ${NoticeCustomerLegalName}    &{ExcelPath}[Notice_Method]      
    
    ### Validate Event Management Queue ###   
    ${CurrentDate}    ${FieldValue}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{ExcelPath}[Customer_IdentifiedBy]    
    ...    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[Temp_File].json    &{ExcelPath}[Field_Name]
    
    Write Data To Excel    Correspondence    BEO_StartDate    ${rowid}    ${CurrentDate}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    BEO_EndDate    ${rowid}    ${CurrentDate}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Correlation_ID    ${rowid}    ${FieldValue}    bTestCaseColumn=True    sColumnReference=rowid
           
    ${BEOStartDate}    Read Data From Excel    Correspondence    BEO_StartDate    ${rowid}
    ${BEOEndDate}    Read Data From Excel    Correspondence    BEO_EndDate    ${rowid}
    ${CorrelationID}    Read Data From Excel    Correspondence    Correlation_ID    ${rowid}
    
    ### Send Call Back thru Postman ###
    ${MessageIdDecode}    Encode and Decode Bytes to String    ${CorrelationID}

    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{ExcelPath}[CallBack_Status]    &{ExcelPath}[errorMessage]    
    ...    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson].json
    
    Correspondence POST API    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputAPIResponse]    
    ...    &{ExcelPath}[ExpectedJson]    ${RESPONSECODE_200}
      
    ### Notice Window Validation ### 
    ${Contact}    Read Data From Excel    Correspondence    Contact   ${rowid}    
    ${Loan_EffectiveDate}    Read Data From Excel    Correspondence    Loan_EffectiveDate   ${rowid}
    ${Loan_GlobalOriginal}    Read Data From Excel    Correspondence    Loan_GlobalOriginal   ${rowid}
    ${Loan_RateSetting_DueDate}    Read Data From Excel    Correspondence    Loan_RateSetting_DueDate   ${rowid}
    
    Validate the Notice Window in LIQ    &{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}
    ...    ${Contact}    &{ExcelPath}[NoticeGroup_UserID]    &{ExcelPath}[Notice_Method]
    ...    &{ExcelPath}[Notice_Type]    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml    &{ExcelPath}[Deal_Name]    &{ExcelPath}[XML_NoticeType]    None
    ...    None    None    None    None    None    None    None
    ...    ${Loan_EffectiveDate}    None    ${Loan_GlobalOriginal}    ${Loan_RateSetting_DueDate}    &{ExcelPath}[Loan_RepricingDate]