*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Send Intent Notice for Loan Drawdown
    [Documentation]    This keyword is use to successfully sent out a Drawdown Intent Notice via Notice Application without validation in FFC
    ...    @author: makcamps    22JAN2021    - initial create
    ...    @update: makcamps	26JAN2021    - changed keyword used
    [Arguments]    ${ExcelPath}
    
    ${Effective_Date}    ${Repricing_Date}    ${Maturity_Date}    ${Base_Rate}    ${Spread}    ${AllIn_Rate}    ${Cycle_Due}    ${Global_Original}    
    ...    ${RateSetting_DueDate}    ${Pricing_Option}    Get Notice Details via Loan Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Loan_Alias]
    
    Get the Notice Details of Specific Contact in LIQ    &{ExcelPath}[SubAdd_Days]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Notice_Type]    &{ExcelPath}[Zero_TempPath]    &{ExcelPath}[Contact]

    Write Data To Excel    Correspondence    Loan_EffectiveDate    ${rowid}    ${Effective_Date}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_RepricingDate    ${rowid}    ${Repricing_Date}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_GlobalOriginal    ${rowid}    ${Global_Original}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_RateSetting_DueDate    ${rowid}    ${RateSetting_DueDate}    bTestCaseColumn=True    sColumnReference=rowid
    
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
    ${Loan_RepricingDate}    Read Data From Excel    Correspondence    Loan_RepricingDate   ${rowid}
    
    Validate the Notice Window in LIQ    &{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}
    ...    ${Contact}    &{ExcelPath}[NoticeGroup_UserID]    &{ExcelPath}[Notice_Method]
    ...    &{ExcelPath}[Notice_Type]    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml    &{ExcelPath}[Deal_Name]    &{ExcelPath}[XML_NoticeType]    None
    ...    None    None    None    None    None    None    None
    ...    ${Loan_EffectiveDate}    None    ${Loan_GlobalOriginal}    ${Loan_RateSetting_DueDate}    ${Loan_RepricingDate}

Send Rate Setting Notice for Loan Drawdown
    [Documentation]    This keyword is use to successfully sent out a Drawdown Rate Setting Notice via Notice Application without validation in FFC
    ...    @author: makcamps    26JAN2021    - initial create
    [Arguments]    ${ExcelPath}
    
    Get the Notice Details of Specific Contact in LIQ    &{ExcelPath}[SubAdd_Days]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Notice_Type]    &{ExcelPath}[Zero_TempPath]    &{ExcelPath}[Contact]
    
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
    
    ### Validate Notice Status ###
    ${Contact}    Read Data From Excel    Correspondence    Contact   ${rowid}
    Refresh Tables in LIQ
    Navigate to Notice Select Window
    Search Existing Notice    $&{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}
    Validate Notice Status    ${NoticeIdentifier}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}    ${Contact}    &{ExcelPath}[NoticeGroup_UserID]    &{ExcelPath}[Notice_Method]