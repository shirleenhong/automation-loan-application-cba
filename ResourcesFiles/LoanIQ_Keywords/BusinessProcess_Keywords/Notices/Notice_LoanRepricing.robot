*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Send Intent Notice for Loan Repricing
    [Documentation]    This keyword is use to successfully sent out a Repricing Intent Notice via Notice Application without validation in FFC
    ...    @author: makcamps    09FEB2021    - initial create
    [Arguments]    ${ExcelPath}

    ${Borrower_LoanAlias}    Read Data From Excel    SERV08_ComprehensiveRepricing    Loan_Alias    1

    ${Effective_Date}    ${Repricing_Date}    ${Maturity_Date}    ${Pricing_Option}    ${Borrower_Amount}    ${Lender_Amount}
    ...    ${Payment_Amount}    Get Notice Details via Loan Repricing Notebook    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Deal_Name]
    ...    ${Borrower_LoanAlias}    &{ExcelPath}[Loan_Alias]    &{ExcelPath}[Payment_Type]

    Get the Notice Details of Specific Contact in LIQ    &{ExcelPath}[SubAdd_Days]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Notice_Type]    &{ExcelPath}[Zero_TempPath]    &{ExcelPath}[Contact]

    Write Data To Excel    Correspondence    Loan_EffectiveDate    ${rowid}    ${Effective_Date}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_RepricingDate    ${rowid}    ${Repricing_Date}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_PricingOption    ${rowid}    ${Pricing_Option}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_BorrowerAmount    ${rowid}    ${Borrower_Amount}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_LenderAmount    ${rowid}    ${Lender_Amount}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Loan_PaymentAmount    ${rowid}    ${Payment_Amount}    bTestCaseColumn=True    sColumnReference=rowid
    
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
    ${Notice_AllInRate}    Read Data From Excel    Correspondence    Notice_AllInRate   ${rowid}
    ${Rate_Basis}    Read Data From Excel    Correspondence    Rate_Basis   ${rowid}
    ${Loan_EffectiveDate}    Read Data From Excel    Correspondence    Loan_EffectiveDate   ${rowid}
    ${Loan_RepricingDate}    Read Data From Excel    Correspondence    Loan_RepricingDate   ${rowid}
    ${Currency}    Read Data From Excel    Correspondence    Currency   ${rowid}
    ${Borrower_Amount}    Read Data From Excel    Correspondence    Loan_BorrowerAmount   ${rowid}
    ${Lender_Amount}    Read Data From Excel    Correspondence    Loan_LenderAmount   ${rowid}
    ${Payment_Amount}    Read Data From Excel    Correspondence    Loan_PaymentAmount   ${rowid}
    
    Validate the Notice Window in LIQ    &{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}
    ...    ${Contact}    &{ExcelPath}[NoticeGroup_UserID]    &{ExcelPath}[Notice_Method]
    ...    &{ExcelPath}[Notice_Type]    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml    &{ExcelPath}[Deal_Name]    &{ExcelPath}[XML_NoticeType]    ${Pricing_Option}
    ...    None    None    ${Notice_AllInRate}    None    None    None    ${Rate_Basis}
    ...    None    None    None    None    ${Loan_RepricingDate}
    ...    ${Loan_EffectiveDate}    None    None    ${Currency}    None
    ...    ${Borrower_Amount}    ${Lender_Amount}    ${Payment_Amount}