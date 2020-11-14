*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Send Paperclip Intent Notice via Notice Application
    [Documentation]    This keyword is use to successfully sent out a PAPER CLIP INTENT NOTICE via Notice application - API_COR_TC26
    ...    @author: ehugo    06SEP2019
    [Arguments]    ${APIDataSet}
    
    Get Paperclip Notice Details via Payment Notebook in LIQ    ${rowid}    &{APIDataSet}[Facility_Name]    &{APIDataSet}[Deal_Name]    &{APIDataSet}[Loan_Alias]
    
    Get the Notice Details in LIQ    ${rowid}    &{APIDataSet}[SubAdd_Days]    &{APIDataSet}[Deal_Name]    &{APIDataSet}[Notice_Type]    &{APIDataSet}[Zero_TempPath]00.xls          
    
    ${FromDate}    Read Data From Excel for API_Data    Correspondence    From_Date    ${rowid}
    ${ThruDate}    Read Data From Excel for API_Data    Correspondence    Thru_Date    ${rowid}
    
    ${NoticeIdentifier}    Read Data From Excel for API_Data    Correspondence    Notice_Identifier    ${rowid}
    ${NoticeCustomerLegalName}    Read Data From Excel for API_Data    Correspondence    Notice_Customer_LegalName    ${rowid} 
        
    Send Notice via Notices Application in LIQ     &{APIDataSet}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    
    ...    ${NoticeCustomerLegalName}    &{APIDataSet}[Notice_Method]      
    
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
    
    Validate FFC CBACorrespUpdateMQ API    ${CorrelationID}    &{APIDataSet}[OutputFilePath]    ${TEMPLATE_TEXTFILE}
    
    ###Step 10: Send Call Back thru Postman###
    ${CorrelationIdByte}    Encode String To Bytes    ${CorrelationID}     UTF-8
    ${MessageIdEncode}    B 32 Encode    ${CorrelationIdByte}
    ${MessageIdDecode}    Decode Bytes To String    ${MessageIdEncode}    UTF-8
    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{APIDataSet}[CallBack_Status]    &{APIDataSet}[errorMessage]    
    ...    &{APIDataSet}[InputFilePath]&{APIDataSet}[InputJson].json
     
    ### Correspondence POST API    ${APIDataSet}
    Correspondence POST API    &{APIDataSet}[InputFilePath]    &{APIDataSet}[InputJson]    &{APIDataSet}[OutputFilePath]    &{APIDataSet}[OutputAPIResponse]    
    ...    &{APIDataSet}[ExpectedJson]    ${RESPONSECODE_200}
    
    ###Step 11: Exception Queue Validation###
    Validate Notice in Logged Exception List Window in LIQ    ${BEOStartDate}    ${BEOEndDate}    &{APIDataSet}[Deal_Name]    ${NoticeIdentifier}    
    
    ###Step 12: FFC Validation FFC1CMUpdateSourceMQ###
    Validate FFC FFC1CMUpdateSourceMQ    ${dataset_path}&{APIDataSet}[OutputFilePath]&{APIDataSet}[OutputAPIResponse].json    ${CorrelationID}    &{APIDataSet}[OutputFilePath]    ${TEMPLATE_TEXTFILE}  
    
    ###Step 13: Notice Window Validation### 
    ${Contact}    Read Data From Excel for API_Data    Correspondence    Contact    ${rowid}
    ${Rate_Basis}    Read Data From Excel for API_Data    Correspondence    Rate_Basis   ${rowid}
    ${EffectiveDate_PrincipalPayment}    Read Data From Excel for API_Data    Correspondence    EffectiveDate_PrincipalPayment   ${rowid}
    ${Outstanding_PrincipalPayment}    Read Data From Excel for API_Data    Correspondence    Outstanding_PrincipalPayment   ${rowid}
    ${EffectiveDate_InterestPayment}    Read Data From Excel for API_Data    Correspondence    EffectiveDate_InterestPayment   ${rowid}
    ${Notice_AllInRate}    Read Data From Excel for API_Data    Correspondence    Notice_AllInRate   ${rowid}
    ${ProjectedCycleDue_InterestPayment}    Read Data From Excel for API_Data    Correspondence    ProjectedCycleDue_InterestPayment   ${rowid}
    ${Principal_Amount}    Read Data From Excel for API_Data    Correspondence    Principal_Amount   ${rowid}
    ${Interest_Amount}    Read Data From Excel for API_Data    Correspondence    Interest_Amount   ${rowid}
    
    Validate the Paperclip Notice Window in LIQ    &{APIDataSet}[Search_By]    ${NoticeIdentifier}    ${From_Date}    ${Thru_Date}    &{APIDataSet}[Notice_Status]    ${NoticeCustomerLegalName}    
    ...    ${Contact}    &{APIDataSet}[NoticeGroup_UserID]    &{APIDataSet}[Notice_Method]
    ...    &{APIDataSet}[Notice_Type]    ${dataset_path}&{APIDataSet}[InputFilePath]&{APIDataSet}[XML_File].xml    &{APIDataSet}[Deal_Name]    
    ...    ${Outstanding_PrincipalPayment}    ${EffectiveDate_InterestPayment}
    ...    ${Principal_Amount}    ${Notice_AllInRate}    ${Interest_Amount}    ${EffectiveDate_PrincipalPayment}    ${EffectiveDate_InterestPayment}
    
    
