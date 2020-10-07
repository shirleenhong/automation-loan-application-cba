*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Send a Drawdown Intent Notice via Notice Application
    [Documentation]    This keyword is use to successfully sent out a Drawdown Intent Notice via Notice Application - API_COR_TC03
    ...    @author:mgaling
    ...    @update: jaquitan    21Mar2019    - updated keywords, variables
    ...    @update: ehugo    19AUG2019    added validation of Balance Amount and Rate Basis in LIQ Notice window
    ...    @update: ehugo    22AUG2019    added arguments for Validate the Notice Window in LIQ keyword
    ...    @update: ehugo    23AUG2019    updated keyword name, added retrieving of Notice Details in LIQ
    ...    @update: ehugo    13AUG2019    added argument for Validate Notice Window
    [Arguments]    ${APIDataSet}
    
    Get Notice Details via Loan Notebook in LIQ    ${rowid}    &{APIDataSet}[Facility_Name]    &{APIDataSet}[Deal_Name]    &{APIDataSet}[Loan_Alias]
    
    Get the Notice Details in LIQ    ${rowid}    &{APIDataSet}[SubAdd_Days]    &{APIDataSet}[Deal_Name]    &{APIDataSet}[Notice_Type]    &{APIDataSet}[Zero_TempPath]00.xls
    
    ${FromDate}    Read Data From Excel for API_Data    Correspondence    From_Date    ${rowid}
    ${ThruDate}    Read Data From Excel for API_Data    Correspondence    Thru_Date    ${rowid}
    
    ${NoticeIdentifier}    Read Data From Excel for API_Data    Correspondence    Notice_Identifier    ${rowid}
    ${NoticeCustomerLegalName}    Read Data From Excel for API_Data    Correspondence    Notice_Customer_LegalName    ${rowid} 
    
    ###Step 1-4: Validate and Sent Notice###
    Send Notice via Notices Application in LIQ     &{APIDataSet}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    
    ...    ${NoticeCustomerLegalName}    &{APIDataSet}[Notice_Method]      
    
    ###Step 5-8 Validate Event Management Queue###
    
    ${CurrentDate}    ${FieldValue}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{APIDataSet}[Customer_IdentifiedBy]    
    ...    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
    ...    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[XML_File].xml
    ...    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[Temp_File].json    &{APIDataSet}[Field_Name]
    
    Write Data To Excel for API_Data    Correspondence    BEO_StartDate    ${rowid}    ${CurrentDate}
    Write Data To Excel for API_Data    Correspondence    BEO_EndDate    ${rowid}    ${CurrentDate}
    Write Data To Excel for API_Data    Correspondence    Correlation_ID    ${rowid}    ${FieldValue}
           
    ${BEOStartDate}    Read Data From Excel for API_Data    Correspondence    BEO_StartDate    ${rowid}
    ${BEOEndDate}    Read Data From Excel for API_Data    Correspondence    BEO_EndDate    ${rowid}
    ${CorrelationID}    Read Data From Excel for API_Data    Correspondence    Correlation_ID    ${rowid}
    
    ###Step 9: FFC Validation CBACorrespUpdateMQ###
    Validate FFC CBACorrespUpdateMQ API    ${CorrelationID}    &{APIDataSet}[OutputFilePath]    ${TEMPLATE_TEXTFILE}
    
    ###Step 10: Send Call Back thru Postman###

    ${CorrelationIdByte}    Encode String To Bytes    ${CorrelationID}     UTF-8
    ${MessageIdEncode}    B 32 Encode    ${CorrelationIdByte}
    ${MessageIdDecode}    Decode Bytes To String    ${MessageIdEncode}    UTF-8

    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{APIDataSet}[CallBack_Status]    &{APIDataSet}[errorMessage]    
    ...    &{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json
     
    # Correspondence POST API    ${dataset_path}&{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson].json    ${dataset_path}&{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse].json    &{APIDataSet}[ExpectedJson].json
    
    Correspondence POST API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[ExpectedJson]    ${RESPONSECODE_200}
    
    ###Step 11: Exception Queue Validation###
    Validate Notice in Logged Exception List Window in LIQ    ${BEOStartDate}    ${BEOEndDate}    &{APIDataSet}[Deal_Name]    ${NoticeIdentifier}    
    
    ###Step 12: FFC Validation FFC1CMUpdateSourceMQ### 
    Validate FFC FFC1CMUpdateSourceMQ    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputAPIResponse].json    ${CorrelationID}    &{APIDataSet}[OutputFilePath]    ${TEMPLATE_TEXTFILE}        
    
    ###Step 14: Notice Window Validation### 
    ${Contact}    Read Data From Excel for API_Data    Correspondence    Contact   ${rowid}    
    ${Loan_EffectiveDate}    Read Data From Excel for API_Data    Correspondence    Loan_EffectiveDate   ${rowid}
    ${Loan_GlobalOriginal}    Read Data From Excel for API_Data    Correspondence    Loan_GlobalOriginal   ${rowid}
    ${Loan_RateSetting_DueDate}    Read Data From Excel for API_Data    Correspondence    Loan_RateSetting_DueDate   ${rowid}
    
    Validate the Notice Window in LIQ    &{APIDataSet}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    &{APIDataSet}[Notice_Status]    ${NoticeCustomerLegalName}    ${Contact}
    ...    &{APIDataSet}[NoticeGroup_UserID]    &{APIDataSet}[Notice_Method]    &{APIDataSet}[Notice_Type]    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[XML_File].xml    &{APIDataSet}[Deal_Name]    
    ...    &{APIDataSet}[XML_NoticeType]    &{APIDataSet}[Loan_PricingOption]    &{APIDataSet}[Loan_BaseRate]    &{APIDataSet}[Loan_Spread]    &{APIDataSet}[Notice_AllInRate]
    ...    &{APIDataSet}[OngoingFee_Type]    &{APIDataSet}[Notice_Amount]    &{APIDataSet}[Balance_Amount]    &{APIDataSet}[Rate_Basis]    ${Loan_EffectiveDate}    &{APIDataSet}[Loan_MaturityDate]
    ...    ${Loan_GlobalOriginal}    ${Loan_RateSetting_DueDate}    &{APIDataSet}[Loan_RepricingDate]