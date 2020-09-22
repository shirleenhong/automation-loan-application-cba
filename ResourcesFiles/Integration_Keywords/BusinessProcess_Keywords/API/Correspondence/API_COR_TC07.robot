*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
NO error for SENT CALL BACK when MESSAGE is NULL
    [Documentation]    This keyword is use to successfully sent out a FEE PAYMENT NOTICE via WIP with NO error when MESSAGE is NULL - API_COR_TC07
    ...    @author:mgaling
    ...    @update: jaquitan    21Mar2019    - updated keywords and variables, removed variables
    ...    @update: ehugo    08192019    added validation of Balance Amount and Rate Basis in LIQ Notice window
    ...    @update: ehugo    08222019    added arguments for Validate the Notice Window in LIQ keyword
    ...    @update: ehugo    13SEP2019    added argument for Validate Notice Window
    [Arguments]    ${APIDataSet}
    
    Get Notice Details for Fee Payment Notice Commitment Fee in LIQ    ${rowid}    &{APIDataSet}[Facility_Name]    &{APIDataSet}[Deal_Name]    &{APIDataSet}[OngoingFee_Type]
    
    Get Rate Basis via Facility Notebook in LIQ    ${rowid}    &{APIDataSet}[Facility_Name]    &{APIDataSet}[Deal_Name]    &{APIDataSet}[OngoingFee_Type]
    
    Get the Notice Details in LIQ    ${rowid}    &{APIDataSet}[SubAdd_Days]    &{APIDataSet}[Deal_Name]    &{APIDataSet}[Notice_Type]    &{APIDataSet}[Zero_TempPath]0.xls   
    
    ${FromDate}    Read Data From Excel for API_Data    Correspondence    From_Date    ${rowid}
    ${ThruDate}    Read Data From Excel for API_Data    Correspondence    Thru_Date    ${rowid}
    
    ${NoticeIdentifier}    Read Data From Excel for API_Data    Correspondence    Notice_Identifier    ${rowid}
    ${NoticeCustomerLegalName}    Read Data From Excel for API_Data    Correspondence    Notice_Customer_LegalName    ${rowid}  
    
    ###Validate and Sent Notice###
    Send Notice via WIP in LIQ    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    &{APIDataSet}[Notice_Method]    Awaiting release     
    
    ###Step 1-3: Validate Event Management Queue###
    ${CurrentDate}    ${FieldValue}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{APIDataSet}[Customer_IdentifiedBy]    
    ...    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
    ...    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[XML_File].xml
    ...    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[Temp_File].json    &{APIDataSet}[Field_Name]
           
    Write Data To Excel for API_Data    Correspondence    Correlation_ID    ${rowid}    ${FieldValue}
    
    ${CorrelationID}    Read Data From Excel for API_Data    Correspondence    Correlation_ID    ${rowid}
    
    ###Step 4: Send Call Back thru Postman###
    ${CorrelationIdByte}    Encode String To Bytes    ${CorrelationID}     UTF-8
    ${MessageIdEncode}    B 32 Encode    ${CorrelationIdByte}
    ${MessageIdDecode}    Decode Bytes To String    ${MessageIdEncode}    UTF-8

    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{APIDataSet}[CallBack_Status]    &{APIDataSet}[errorMessage]    
    ...    &{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json
     
    Correspondence POST API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]    
    ...    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[ExpectedJson]    ${RESPONSECODE_400}

    ###Step 5: FFC Validation CBACorrespUpdateMQ###
    #Validate FFC CBACorrespUpdateMQ API    ${CorrelationID}    &{APIDataSet}[OutputFilePath]    ${TEMPLATE_TEXTFILE}
    
    ###Step 6-7: Exception Queue Validation###
    Validate Failed Notice in Logged Exception List Window in LIQ    &{APIDataSet}[Deal_Name]    ${NoticeIdentifier}    &{APIDataSet}[WIP_ExceptionQueueDescription]
    
    ###Step 8: Send Call Back thru Postman###
    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{APIDataSet}[CallBack_Status2]    &{APIDataSet}[errorMessage]    
    ...    &{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json
     
    Correspondence POST API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]    
    ...    &{APIDataSet}[OutputAPIResponse]    &{APIDataSet}[ExpectedJson]    ${RESPONSECODE_200}
    
    ###Step 9: FFC Validation FFC1CMUpdateSourceMQ### 
    Validate FFC FFC1CMUpdateSourceMQ    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputAPIResponse].json    ${CorrelationID}    &{APIDataSet}[OutputFilePath]    ${TEMPLATE_TEXTFILE}         
    
    ###Notice Window Validation### 
    ${Contact}    Read Data From Excel for API_Data    Correspondence    Contact   ${rowid}     
    ${Notice_AllInRate}    Read Data From Excel for API_Data    Correspondence    Notice_AllInRate   ${rowid}
    ${Notice_Amount}    Read Data From Excel for API_Data    Correspondence    Notice_Amount   ${rowid}
    ${Balance_Amount}    Read Data From Excel for API_Data    Correspondence    Balance_Amount   ${rowid}
    ${Rate_Basis}    Read Data From Excel for API_Data    Correspondence    Rate_Basis   ${rowid}
    
    Validate the Notice Window in LIQ    &{APIDataSet}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    &{APIDataSet}[Notice_Status]    ${NoticeCustomerLegalName}    ${Contact}
    ...    &{APIDataSet}[NoticeGroup_UserID]    &{APIDataSet}[Notice_Method]    &{APIDataSet}[Notice_Type]    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[XML_File].xml    &{APIDataSet}[Deal_Name]    
    ...    &{APIDataSet}[XML_NoticeType]    &{APIDataSet}[Loan_PricingOption]    &{APIDataSet}[Loan_BaseRate]    &{APIDataSet}[Loan_Spread]    ${Notice_AllInRate}
    ...    &{APIDataSet}[OngoingFee_Type]    ${Notice_Amount}    ${Balance_Amount}    ${Rate_Basis}    &{APIDataSet}[Loan_EffectiveDate]    &{APIDataSet}[Loan_MaturityDate]
    ...    &{APIDataSet}[Loan_GlobalOriginal]    &{APIDataSet}[Loan_RateSetting_DueDate]    &{APIDataSet}[Loan_RepricingDate]
    
