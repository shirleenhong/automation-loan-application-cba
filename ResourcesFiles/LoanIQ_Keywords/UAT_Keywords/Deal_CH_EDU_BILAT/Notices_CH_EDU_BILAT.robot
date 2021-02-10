*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Send Upfront Fee Intent Notice for CH EDU Bilateral Deal
    [Documentation]    This keyword is use to successfully send Upfront Fee Payment Intent Notice
    ...    @author: dahijara    15DEC2020    Initial Create
    ...    @update: mcastro    05FEB2021    Removed ${ExcelPath} on Writing Data to Excel
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    &{ExcelPath}[rowid]

    Get Notice Details for Fee Payment Notice Upfront Fee LIQ    ${rowid}    ${Deal_Name}
    ${FromDate}    ${ThruDate}    Generate From and Thru Dates for Notices    &{ExcelPath}[SubAdd_Days]

    Write Data To Excel    Correspondence    From_Date    ${rowid}    ${FromDate}
    Write Data To Excel   Correspondence    Thru_Date    ${rowid}    ${ThruDate}

    Search Existing Deal    ${Deal_Name}
    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    ${Contact}    Get Notice ID via Deal Notebook    ${FromDate}    ${ThruDate}    &{ExcelPath}[Notice_Type]
    Write Data To Excel    Correspondence    Notice_Identifier    ${rowid}     ${NoticeIdentifier}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    ${rowid}     ${NoticeCustomerLegalName}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Contact    ${rowid}     ${Contact}    bTestCaseColumn=True    sColumnReference=rowid
    
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


Send Ongoing Fee Payment Intent Notice for CH EDU Bilateral Deal
    [Documentation]    This keyword is use to successfully send Ongoing Fee Payment Intent Notice
    ...    @author: dahijara    13JAN2021    Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FromDate}    ${ThruDate}    Generate From and Thru Dates for Notices    &{ExcelPath}[SubAdd_Days]

    Write Data To Excel    Correspondence    From_Date    ${rowid}    ${FromDate}
    Write Data To Excel   Correspondence    Thru_Date    ${rowid}    ${ThruDate}

    Search Existing Deal    ${Deal_Name}
    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    ${Contact}    Get Notice ID via Deal Notebook    ${FromDate}    ${ThruDate}    &{ExcelPath}[Notice_Type]
    Write Data To Excel    Correspondence    Notice_Identifier    ${rowid}     ${NoticeIdentifier}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    ${rowid}     ${NoticeCustomerLegalName}
    Write Data To Excel    Correspondence    Contact    ${rowid}     ${Contact}
    
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

Send Repricing Intent Notice for CH EDU Bilateral Deal
    [Documentation]    This keyword is used to successfully send loan repricing Intent Notice
    ...    @author: dahijara    20JAN2021    Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1
    ${FromDate}    ${ThruDate}    Generate From and Thru Dates for Notices    &{ExcelPath}[SubAdd_Days]
    Write Data To Excel    Correspondence    From_Date    ${rowid}    ${FromDate}
    Write Data To Excel   Correspondence    Thru_Date    ${rowid}    ${ThruDate}

    ### Get Notice Details in LIQ ###
    Search Existing Deal    ${Deal_Name}
    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    ${Contact}    Get Notice ID via Deal Notebook    ${FromDate}
    ...    ${ThruDate}    &{ExcelPath}[Notice_Type]
    Write Data To Excel    Correspondence    Notice_Identifier    ${rowid}     ${NoticeIdentifier}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    ${rowid}     ${NoticeCustomerLegalName}
    Write Data To Excel    Correspondence    Contact    ${rowid}     ${Contact}
    
    ### Validate and Send Notice ###
    Send Notice via WIP in LIQ    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    &{ExcelPath}[Notice_Method]    ${AWAITING_RELEASE_NOTICE_STATUS}
    
    ### Validate Event Management Queue ###
    ${CurrentDate}    ${FieldValue}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{ExcelPath}[Customer_IdentifiedBy]    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
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
    Validate Notice Status    ${NoticeIdentifier}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}
    ...    ${Contact}    ${NoticeGroup_UserID}    &{ExcelPath}[Notice_Method]

Send Repricing Rate Setting Notice for CH EDU Bilateral Deal
    [Documentation]    This keyword is used to successfully send loan repricing Rate Setting Notice
    ...    @author: dahijara    21JAN2021    Initial Create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    CRED01_DealSetup    Deal_Name    1

    ${FromDate}    ${ThruDate}    Generate From and Thru Dates for Notices    &{ExcelPath}[SubAdd_Days]
    Write Data To Excel    Correspondence    From_Date    ${rowid}    ${FromDate}
    Write Data To Excel   Correspondence    Thru_Date    ${rowid}    ${ThruDate}

    ### Get Rate Setting Notice Details in LIQ ###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    Search Existing Deal    ${Deal_Name}
    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    ${Contact}    Get Notice ID via Deal Notebook    ${FromDate}    ${ThruDate}    &{ExcelPath}[Notice_Type]
    Write Data To Excel    Correspondence    Notice_Identifier    ${rowid}     ${NoticeIdentifier}
    Write Data To Excel    Correspondence    Notice_Customer_LegalName    ${rowid}     ${NoticeCustomerLegalName}
    Write Data To Excel    Correspondence    Contact    ${rowid}     ${Contact}
    
    ### Validate and Send Notice ###
    Send Notice via WIP in LIQ    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    &{ExcelPath}[Notice_Method]    ${AWAITING_RELEASE_NOTICE_STATUS}
    
    ### Validate Event Management ###
    ${CurrentDate}    ${FieldValue}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{ExcelPath}[Customer_IdentifiedBy]
    ...    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml
    ...    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[Temp_File].json    &{ExcelPath}[Field_Name]
    Close All Windows on LIQ
    Write Data To Excel    Correspondence    BEO_StartDate    ${rowid}    ${CurrentDate}
    Write Data To Excel    Correspondence    BEO_EndDate    ${rowid}    ${CurrentDate}
    Write Data To Excel    Correspondence    Correlation_ID    ${rowid}    ${FieldValue}

    ${BEOStartDate}    Read Data From Excel    Correspondence    BEO_StartDate    ${rowid}
    ${BEOEndDate}    Read Data From Excel    Correspondence    BEO_EndDate    ${rowid}
    ${CorrelationID}    Read Data From Excel    Correspondence    Correlation_ID    ${rowid}
    
    ### Send Call back via API ###
    ${MessageIdDecode}    Get the MessageId Decode Value    ${CorrelationID}
    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{ExcelPath}[CallBack_Status]
    ...    &{ExcelPath}[errorMessage]    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson].json
     
    Correspondence POST API    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[OutputFilePath]    
    ...    &{ExcelPath}[OutputAPIResponse]    &{ExcelPath}[ExpectedJson]    ${RESPONSECODE_200} 
    
    ### Notice Validation in LIQ ### 
    ${Contact}    Read Data From Excel    Correspondence    Contact   ${rowid}
    ${NoticeGroup_UserID}    Read Data From Excel    Correspondence    NoticeGroup_UserID   ${rowid}
    Refresh Tables in LIQ
    Navigate to Notice Select Window
    Search Existing Notice    &{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}
    Validate Notice Status    ${NoticeIdentifier}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}
    ...    ${Contact}    ${NoticeGroup_UserID}    &{ExcelPath}[Notice_Method]