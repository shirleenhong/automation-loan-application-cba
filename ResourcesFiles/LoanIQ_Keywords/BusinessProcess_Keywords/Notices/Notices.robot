*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Send Notice by Notice Application
    [Documentation]    This keyword is used to successfully sent out a NOTICE by Notice Application without FFC Validation
    ...    @author: makcamps    11FEB2021    - Initial Create
    ...    @author: makcamps    22FEB2021    - changed getting notice ID keyword to Get Notice ID thru Deal Notebook of Specific Contact
    [Arguments]    ${ExcelPath}

    Search Existing Deal    &{ExcelPath}[Deal_Name]

    ${FromDate}    ${ThruDate}    Generate From and Thru Dates for Notices    &{ExcelPath}[SubAdd_Days]

    Write Data To Excel    Correspondence    From_Date    ${rowid}    ${FromDate}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel   Correspondence    Thru_Date    ${rowid}    ${ThruDate}    bTestCaseColumn=True    sColumnReference=rowid

    ### Get Notice Details in LIQ ###
    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    ${Contact}    Get Notice ID thru Deal Notebook of Specific Contact    ${FromDate}    ${ThruDate}    &{ExcelPath}[Notice_Type]    &{ExcelPath}[Contact]
    Write Data To Excel    Correspondence    Notice_Identifier    ${rowid}     ${NoticeIdentifier}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    ${rowid}     ${NoticeCustomerLegalName}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Contact    ${rowid}     ${Contact}    bTestCaseColumn=True    sColumnReference=rowid

    ### Send Notices via LIQ ###
    Send Notice via Notices Application in LIQ     &{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    
    ...    ${NoticeCustomerLegalName}    &{ExcelPath}[Notice_Method]

    ### Validate Notices in LIQ ###
    ${StartEndDate}    ${CorrelationID}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{ExcelPath}[Customer_IdentifiedBy]    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[Temp_File].json    &{ExcelPath}[Field_Name]

    ### Write Data from Dataset ###
    Write Data To Excel    Correspondence    BEO_StartDate    ${rowid}    ${StartEndDate}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    BEO_EndDate    ${rowid}    ${StartEndDate}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Correlation_ID    ${rowid}    ${CorrelationID}    bTestCaseColumn=True    sColumnReference=rowid
    
    ### Send Call Back thru Postman ###
    ${MessageIdDecode}    Encode and Decode Bytes to String    ${CorrelationID}

    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{ExcelPath}[CallBack_Status]    &{ExcelPath}[errorMessage]    
    ...    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson].json
    Correspondence POST API    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[OutputAPIResponse]    &{ExcelPath}[OutputAPIResponse]    
    ...    ${RESPONSECODE_200}

    ### Validate Notice Status ###
    Refresh Tables in LIQ
    Navigate to Notice Select Window
    Search Existing Notice    $&{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}
    Validate Notice Status    ${NoticeIdentifier}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}    ${Contact}    &{ExcelPath}[NoticeGroup_UserID]    &{ExcelPath}[Notice_Method]