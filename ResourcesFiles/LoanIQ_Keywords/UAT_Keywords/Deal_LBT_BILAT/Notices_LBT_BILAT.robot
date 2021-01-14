*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Send Paperclip Intent Notice for LBT Bilateral Deal
    [Documentation]    This keyword is use to successfully send Paperclip Intent Notice for LBT Bilateral Deal
    ...    @author: javinzon    13JAN2021    - Initial Create
    [Arguments]    ${ExcelPath}
    
    Get the Notice Details in LIQ    ${rowid}    &{Excelpath}[SubAdd_Days]    &{Excelpath}[Deal_Name]    &{Excelpath}[Notice_Type]    &{Excelpath}[Zero_TempPath]

    ### Read Data from Dataset ###
    ${FromDate}    Read Data From Excel    Correspondence    From_Date    ${rowid}   ${APIDataSet}
    ${ThruDate}    Read Data From Excel    Correspondence    Thru_Date    ${rowid}   ${APIDataSet}
    ${NoticeIdentifier}    Read Data From Excel    Correspondence    Notice_Identifier    ${rowid}   ${APIDataSet}
    ${NoticeCustomerLegalName}    Read Data From Excel    Correspondence    Notice_Customer_LegalName    ${rowid}   ${APIDataSet}

    ### Send Notices via LIQ ###
    Send Notice via Notices Application in LIQ     &{Excelpath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    
    ...    ${NoticeCustomerLegalName}    &{Excelpath}[Notice_Method]      
    
    ### Validate Notices in LIQ ###
    ${StartEndDate}    ${CorrelationID}    Validate Notice in Business Event Output Window in LIQ    ${rowid}    &{Excelpath}[Customer_IdentifiedBy]    ${NoticeCustomerLegalName}    ${NoticeIdentifier}
    ...    ${dataset_path}&{Excelpath}[InputFilePath]&{Excelpath}[XML_File].xml
    ...    ${dataset_path}&{Excelpath}[InputFilePath]&{Excelpath}[Temp_File].json    &{Excelpath}[Field_Name]

    ### Write Data from Dataset ###
    Write Data To Excel    Correspondence    BEO_StartDate    ${rowid}    ${StartEndDate}    
    Write Data To Excel    Correspondence    BEO_EndDate    ${rowid}    ${StartEndDate}    
    Write Data To Excel    Correspondence    Correlation_ID    ${rowid}    ${CorrelationID}    
    
    ### Send Call Back thru Postman ###
    ${MessageIdDecode}    Encode and Decode Bytes to String    ${CorrelationID}
    
    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{Excelpath}[CallBack_Status]    &{Excelpath}[errorMessage]    
    ...    &{Excelpath}[InputFilePath]&{Excelpath}[InputJson].json
    Correspondence POST API    &{Excelpath}[InputFilePath]    &{Excelpath}[InputJson]    &{Excelpath}[OutputFilePath]    &{Excelpath}[OutputAPIResponse]    &{Excelpath}[OutputAPIResponse]    
    ...    ${RESPONSECODE_200}
           
    ### Notice Window Validation ### 
    ${Contact}    Read Data From Excel    Correspondence    Contact    ${rowid}   ${APIDataSet}
    ${Loan_EffectiveDate}    Read Data From Excel    Correspondence    Loan_EffectiveDate    ${rowid}   ${APIDataSet}
    ${Loan_MaturityDate}    Read Data From Excel    Correspondence    Loan_MaturityDate    ${rowid}   ${APIDataSet}
    ${Loan_BaseRate}    Read Data From Excel    Correspondence    Loan_BaseRate    ${rowid}   ${APIDataSet}
    ${Loan_Spread}    Read Data From Excel    Correspondence    Loan_Spread    ${rowid}   ${APIDataSet}
    ${Notice_AllInRate}    Read Data From Excel    Correspondence    Notice_AllInRate    ${rowid}   ${APIDataSet}
    ${Notice_Amount}    Read Data From Excel    Correspondence    Notice_Amount    ${rowid}   ${APIDataSet}

    Validate the Notice Window in LIQ    &{Excelpath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    &{Excelpath}[Notice_Status]    ${NoticeCustomerLegalName}    ${Contact}
    ...    &{Excelpath}[NoticeGroup_UserID]    &{Excelpath}[Notice_Method]    &{Excelpath}[Notice_Type]    ${dataset_path}&{Excelpath}[InputFilePath]&{Excelpath}[XML_File].xml    &{Excelpath}[Deal_Name]    
    ...    &{Excelpath}[XML_NoticeType]    &{Excelpath}[Loan_PricingOption]    ${Loan_BaseRate}    ${Loan_Spread}    ${Notice_AllInRate}
    ...    &{Excelpath}[OngoingFee_Type]    ${Notice_Amount}    &{Excelpath}[Balance_Amount]    &{Excelpath}[Rate_Basis]    ${Loan_EffectiveDate}    ${Loan_MaturityDate}
    ...    &{Excelpath}[Loan_GlobalOriginal]    &{Excelpath}[Loan_RateSetting_DueDate]    &{Excelpath}[Loan_RepricingDate]
