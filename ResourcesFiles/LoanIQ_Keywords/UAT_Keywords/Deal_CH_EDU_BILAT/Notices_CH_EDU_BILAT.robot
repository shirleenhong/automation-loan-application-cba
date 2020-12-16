*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Send Upfront Fee Intent Notice for CH EDU Bilateral Deal
    [Documentation]    This keyword is use to successfully send Upfront Fee Payment Intent Notice
    ...    @author: dahijara    15DEC2020    Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]

    Get Notice Details for Fee Payment Notice Upfront Fee LIQ    ${rowid}    ${Deal_Name}
    Get the Notice Details in LIQ via Deal Notebook    ${rowid}    &{ExcelPath}[SubAdd_Days]    ${Deal_Name}    &{ExcelPath}[Notice_Type]    &{ExcelPath}[Zero_TempPath]0.xls
    
    ${FromDate}    Read Data From Excel    Correspondence    From_Date    ${rowid}
    ${ThruDate}    Read Data From Excel    Correspondence    Thru_Date    ${rowid}
    
    ${NoticeIdentifier}    Read Data From Excel    Correspondence    Notice_Identifier    ${rowid}
    ${NoticeCustomerLegalName}    Read Data From Excel    Correspondence    Notice_Customer_LegalName    ${rowid}
    
    ### Validate and Send Notice ###
    Send Notice via WIP in LIQ    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    &{ExcelPath}[Notice_Method]    Awaiting release        
    
    ### Validate Event Management Queue ###
    ${CurrentDate}    ${FieldValue}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{ExcelPath}[Customer_IdentifiedBy]    
    ...    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[Temp_File].json    &{ExcelPath}[Field_Name]

    Write Data To Excel    Correspondence    BEO_StartDate    ${rowid}    ${CurrentDate}
    Write Data To Excel    Correspondence    BEO_EndDate    ${rowid}    ${CurrentDate}
    Write Data To Excel    Correspondence    Correlation_ID    ${rowid}    ${FieldValue}

    ${BEOStartDate}    Read Data From Excel    Correspondence    BEO_StartDate    ${rowid}
    ${BEOEndDate}    Read Data From Excel    Correspondence    BEO_EndDate    ${rowid}
    ${CorrelationID}    Read Data From Excel    Correspondence    Correlation_ID    ${rowid}
    
    ### Send Call Back thru Postman ###
    ${MessageIdDecode}    Get the MessageId Decode Value    ${CorrelationID}
    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{ExcelPath}[CallBack_Status]    &{ExcelPath}[errorMessage]    
    ...    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson].json
     
    Correspondence POST API    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[OutputFilePath]    
    ...    &{ExcelPath}[OutputAPIResponse]    &{ExcelPath}[ExpectedJson]    ${RESPONSECODE_200} 
    
    ### Notice Window Validation ### 
    ${Contact}    Read Data From Excel    Correspondence    Contact   ${rowid}
    ${NoticeGroup_UserID}    Read Data From Excel    Correspondence    NoticeGroup_UserID   ${rowid}

    Refresh Tables in LIQ
    Navigate to Notice Select Window
    Search Existing Notice    &{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}
    Validate Notice Status    ${NoticeIdentifier}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}    ${Contact}    ${NoticeGroup_UserID}    &{ExcelPath}[Notice_Method]
