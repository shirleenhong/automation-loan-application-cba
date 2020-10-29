*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Send Notice via Notice Application
    [Documentation]    This keyword is use to successfully sent out a NOTICE via Notice Application - API_COR_TC01
    ...    @author: mgaling     DDMMMYYYY    - initial create
    ...    @update: jaquitan    20MAR2019    - updated keywords, variables
    ...    @Update: jaquitan    25MAR2019    - added keywword for sending notice
    ...    @update: ehugo       19AUG2019    - added validation of Balance Amount and Rate Basis in LIQ Notice window
    ...    @update: ehugo       23AUG2019    - added retrieving of Notice Details via Loan Notebook in LIQ
    ...    @update: ehugo       13SEP2019    - added argument in Validate Notice Details
    ...    @update: amansuet    27NOV2019    - updated keyword for UTF UPGRADE 4.0
    ...    @update: jloretiz    10JUL2020    - updated keywords, writing and reading to excel, put comments, updated variable name
    ...    @update: makcamps    27OCT2020    - updated arguments in Get the Notice Details in LIQ and Validate Notice in Business Event Output Window in LIQ
    [Arguments]    ${APIDictionary}
    
    ### Get Notice Details in LIQ ###
    Get Notice Details via Loan Notebook in LIQ    ${rowid}    &{APIDictionary}[Facility_Name]    &{APIDictionary}[Deal_Name]    &{APIDictionary}[Loan_Alias]
    Get the Notice Details in LIQ    ${rowid}    &{APIDictionary}[SubAdd_Days]    &{APIDictionary}[Deal_Name]    &{APIDictionary}[Notice_Type]    &{APIDictionary}[Zero_TempPath]

    ### Read Data from Dataset ###
    ${FromDate}    Read Data From Excel    Correspondence    From_Date    ${rowid}   ${APIDataSet}
    ${ThruDate}    Read Data From Excel    Correspondence    Thru_Date    ${rowid}   ${APIDataSet}
    ${NoticeIdentifier}    Read Data From Excel    Correspondence    Notice_Identifier    ${rowid}   ${APIDataSet}
    ${NoticeCustomerLegalName}    Read Data From Excel    Correspondence    Notice_Customer_LegalName    ${rowid}   ${APIDataSet}

    ### Send Notices via LIQ ###
    Send Notice via Notices Application in LIQ     &{APIDictionary}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    
    ...    ${NoticeCustomerLegalName}    &{APIDictionary}[Notice_Method]      
    
    ### Validate Notices in LIQ ###
    ${StartEndDate}    ${CorrelationID}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{APIDictionary}[Customer_IdentifiedBy]    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
    ...    ${dataset_path}&{APIDictionary}[InputFilePath]&{APIDictionary}[XML_File].xml
    ...    ${dataset_path}&{APIDictionary}[InputFilePath]&{APIDictionary}[Temp_File].json    &{APIDictionary}[Field_Name]
    
    ### Write Data from Dataset ###
    Write Data To Excel    Correspondence    BEO_StartDate    ${rowid}    ${StartEndDate}    ${APIDataSet}    bTestCaseColumn=True
    Write Data To Excel    Correspondence    BEO_EndDate    ${rowid}    ${StartEndDate}    ${APIDataSet}    bTestCaseColumn=True
    Write Data To Excel    Correspondence    Correlation_ID    ${rowid}    ${CorrelationID}    ${APIDataSet}    bTestCaseColumn=True

    ### Validate FFC with Correlation ID from LIQ ###
    Validate FFC CBACorrespUpdateMQ API    ${CorrelationID}    &{APIDictionary}[OutputFilePath]    ${TEMPLATE_TEXTFILE}
    
    ### Send Call Back thru Postman ###
    ${CorrelationIdByte}    Encode String To Bytes    ${CorrelationID}     UTF-8
    ${MessageIdEncode}    B 32 Encode    ${CorrelationIdByte}
    ${MessageIdDecode}    Decode Bytes To String    ${MessageIdEncode}    UTF-8
    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{APIDictionary}[CallBack_Status]    &{APIDictionary}[errorMessage]    
    ...    &{APIDictionary}[InputFilePath]&{APIDictionary}[InputJson].json
    Correspondence POST API    &{APIDictionary}[InputFilePath]    &{APIDictionary}[InputJson]    &{APIDictionary}[OutputFilePath]    &{APIDictionary}[OutputAPIResponse]    &{APIDictionary}[OutputAPIResponse]    
    ...    ${RESPONSECODE_200}
    
    ### Exception Queue Validation ###
    Validate Notice in Logged Exception List Window in LIQ    ${StartEndDate}    ${StartEndDate}    &{APIDictionary}[Deal_Name]    ${NoticeIdentifier}    
    
    ### FFC Validation FFC1CMUpdateSourceM###
    Validate FFC FFC1CMUpdateSourceMQ    ${dataset_path}&{APIDictionary}[OutputFilePath]&{APIDictionary}[OutputAPIResponse].json    ${CorrelationID}    &{APIDictionary}[OutputFilePath]    ${TEMPLATE_TEXTFILE}      
    
    ### Notice Window Validation ### 
    ${Contact}    Read Data From Excel    Correspondence    Contact    ${rowid}   ${APIDataSet}
    ${Loan_EffectiveDate}    Read Data From Excel    Correspondence    Loan_EffectiveDate    ${rowid}   ${APIDataSet}
    ${Loan_MaturityDate}    Read Data From Excel    Correspondence    Loan_MaturityDate    ${rowid}   ${APIDataSet}
    ${Loan_BaseRate}    Read Data From Excel    Correspondence    Loan_BaseRate    ${rowid}   ${APIDataSet}
    ${Loan_Spread}    Read Data From Excel    Correspondence    Loan_Spread    ${rowid}   ${APIDataSet}
    ${Notice_AllInRate}    Read Data From Excel    Correspondence    Notice_AllInRate    ${rowid}   ${APIDataSet}
    ${Notice_Amount}    Read Data From Excel    Correspondence    Notice_Amount    ${rowid}   ${APIDataSet}

    Validate the Notice Window in LIQ    &{APIDictionary}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    &{APIDictionary}[Notice_Status]    ${NoticeCustomerLegalName}    ${Contact}
    ...    &{APIDictionary}[NoticeGroup_UserID]    &{APIDictionary}[Notice_Method]    &{APIDictionary}[Notice_Type]    ${dataset_path}&{APIDictionary}[InputFilePath]&{APIDictionary}[XML_File].xml    &{APIDictionary}[Deal_Name]    
    ...    &{APIDictionary}[XML_NoticeType]    &{APIDictionary}[Loan_PricingOption]    ${Loan_BaseRate}    ${Loan_Spread}    ${Notice_AllInRate}
    ...    &{APIDictionary}[OngoingFee_Type]    ${Notice_Amount}    &{APIDictionary}[Balance_Amount]    &{APIDictionary}[Rate_Basis]    ${Loan_EffectiveDate}    ${Loan_MaturityDate}
    ...    &{APIDictionary}[Loan_GlobalOriginal]    &{APIDictionary}[Loan_RateSetting_DueDate]    &{APIDictionary}[Loan_RepricingDate]
       