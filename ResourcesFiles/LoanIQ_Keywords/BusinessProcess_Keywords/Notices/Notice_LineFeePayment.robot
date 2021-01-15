*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
 
Send Notice for Line Fee
    [Documentation]    This keyword is use to successfully sent out a Fee Payment Notice via WIP - API_COR_TC02
    ...    @author: makcamps
    [Arguments]    ${ExcelPath}
    
    Get Notice Details for Fee Payment Notice Line Fee in LIQ    ${rowid}    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[OngoingFee_Type]
    
    Get Rate Basis via Facility Notebook in LIQ    ${rowid}    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[OngoingFee_Type]
    
    Get the Notice Details of specific Contact in LIQ    ${rowid}    &{ExcelPath}[SubAdd_Days]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Fee_Type]    &{ExcelPath}[Zero_TempPath]0.xls    &{ExcelPath}[Contact]
    
    ${FromDate}    Read Data From Excel for API_Data    Correspondence    From_Date    ${rowid}
    ${ThruDate}    Read Data From Excel for API_Data    Correspondence    Thru_Date    ${rowid}
    
    ${NoticeIdentifier}    Read Data From Excel for API_Data    Correspondence    Notice_Identifier    ${rowid}
    ${NoticeCustomerLegalName}    Read Data From Excel for API_Data    Correspondence    Notice_Customer_LegalName    ${rowid}
    
    ###Validate and Sent Notice###
    Send Notice via WIP in LIQ    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    &{ExcelPath}[Notice_Method]    Awaiting release        
    
    ###Validate Event Management Queue###
    ${CurrentDate}    ${FieldValue}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{ExcelPath}[Customer_IdentifiedBy]    
    ...    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[Temp_File].json    &{ExcelPath}[Field_Name]
           
    Write Data To Excel for API_Data    Correspondence    BEO_StartDate    ${rowid}    ${CurrentDate}
    Write Data To Excel for API_Data    Correspondence    BEO_EndDate    ${rowid}    ${CurrentDate}
    Write Data To Excel for API_Data    Correspondence    Correlation_ID    ${rowid}    ${FieldValue}
    
    ${BEOStartDate}    Read Data From Excel for API_Data    Correspondence    BEO_StartDate    ${rowid}
    ${BEOEndDate}    Read Data From Excel for API_Data    Correspondence    BEO_EndDate    ${rowid}
    ${CorrelationID}    Read Data From Excel for API_Data    Correspondence    Correlation_ID    ${rowid}
    
    ###Send Call Back thru Postman###
    ${CorrelationIdByte}    Encode String To Bytes    ${CorrelationID}     UTF-8
    ${MessageIdEncode}    B 32 Encode    ${CorrelationIdByte}
    ${MessageIdDecode}    Decode Bytes To String    ${MessageIdEncode}    UTF-8
    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{ExcelPath}[CallBack_Status]    &{ExcelPath}[errorMessage]    
    ...    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson].json
     
    Correspondence POST API    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[OutputFilePath]    
    ...    &{ExcelPath}[OutputAPIResponse]    &{ExcelPath}[ExpectedJson]    ${RESPONSECODE_200}
    
    ###Notice Window Validation### 
    ${Contact}    Read Data From Excel for API_Data    Correspondence    Contact   ${rowid}
    ${Notice_AllInRate}    Read Data From Excel for API_Data    Correspondence    Notice_AllInRate   ${rowid}
    ${Notice_Amount}    Read Data From Excel for API_Data    Correspondence    Notice_Amount   ${rowid}
    ${Balance_Amount}    Read Data From Excel for API_Data    Correspondence    Balance_Amount   ${rowid}
    ${Rate_Basis}    Read Data From Excel for API_Data    Correspondence    Rate_Basis   ${rowid}
    
    Validate the Notice Window in LIQ    &{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}
    ...    ${Contact}    &{ExcelPath}[NoticeGroup_UserID]    &{ExcelPath}[Notice_Method]
    ...    &{ExcelPath}[Notice_Type]    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml    &{ExcelPath}[Deal_Name]    &{ExcelPath}[XML_NoticeType]    None
    ...    None    None    ${Notice_AllInRate}    &{ExcelPath}[OngoingFee_Type]    ${Notice_Amount}    None    ${Rate_Basis}
    ...    None    None    None    None    None