*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Get Notice Details for Principal Payment LIQ
    [Documentation]    Get Notice Details (Pricing Option, Requested Amount, Currency, and Effective Date) for Principal Payment in LIQ
    ...    @author:    makcamps    05NOV2020    Initial Create
    [Arguments]    ${rowid}    ${sDealName}    ${sFacilityName}    ${sLoanAlias}
    
    ###Switch to Original User###
	Logout from Loan IQ
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
	
    ###Loan Notebook Window###
    Navigate to an Existing Loan    ${sDealName}    ${sFacilityName}    ${sLoanAlias}    Y    N    N
    
    ###Navigate to Loan Window and Events Tab###
    Mx LoanIQ Select Window Tab    ${LIQ_FixedRateOptionLoan_Pending_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_FixedRateOptionLoan_Events_JavaTree}    Principal Payment Applied%d
    
    ## Get the Values of Effective Date, All In Rate Amount, Currency, All in Rate, Pricing Option###
    ${Effective_Date}    ${Requested_Amount}    ${Loan_Currency}    Get Notice Details in Principal Payment Notebook
    Close All Windows on LIQ
    
    Write Data To Excel    Correspondence    EffectiveDate_PrincipalPayment    ${rowid}    ${Effective_Date}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Principal_Amount    ${rowid}    ${Requested_Amount}    bTestCaseColumn=True    sColumnReference=rowid
    Write Data To Excel    Correspondence    Currency    ${rowid}    ${Loan_Currency}    bTestCaseColumn=True    sColumnReference=rowid

Send Notice For Principal Payment
    [Documentation]    This keyword is use to successfully sent out a Principal Payment Notice via WIP
    ...    @author:    makcamps    03NOV2020    Initial Create
    [Arguments]    ${ExcelPath}
    
    Get Notice Details for Principal Payment LIQ    ${rowid}    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    &{ExcelPath}[Loan_Alias]
    
    Get the Notice Details in LIQ    ${rowid}    &{ExcelPath}[SubAdd_Days]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Notice_Type]    &{ExcelPath}[Zero_TempPath]0.xls
    
    ${FromDate}    Read Data From Excel    Correspondence    From_Date    ${rowid}
    ${ThruDate}    Read Data From Excel    Correspondence    Thru_Date    ${rowid}
    
    ${NoticeIdentifier}    Read Data From Excel    Correspondence    Notice_Identifier    ${rowid}
    ${NoticeCustomerLegalName}    Read Data From Excel    Correspondence    Notice_Customer_LegalName    ${rowid}
    ${Notice_Method}    Read Data From Excel    Correspondence    Notice_Method   ${rowid}
    
    Send Notice via WIP in LIQ    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    ${Notice_Method}    Awaiting release        
   
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
    
    Validate FFC CBACorrespUpdateMQ API    ${CorrelationID}    &{ExcelPath}[OutputFilePath]    ${TEMPLATE_TEXTFILE}
    
    ${MessageIdDecode}    Get the MessageId Decode Value    ${CorrelationID}
    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{ExcelPath}[CallBack_Status]    &{ExcelPath}[errorMessage]    
    ...    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson].json
     
    Correspondence POST API    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[OutputFilePath]    
    ...    &{ExcelPath}[OutputAPIResponse]    &{ExcelPath}[ExpectedJson]    ${RESPONSECODE_200} 
    
    Validate FFC FFC1CMUpdateSourceMQ    ${dataset_path}&{ExcelPath}[OutputFilePath]&{ExcelPath}[OutputAPIResponse].json    ${CorrelationID}    &{ExcelPath}[OutputFilePath]    ${TEMPLATE_TEXTFILE} 
    
    ${Search_By}    Read Data From Excel    Correspondence    Search_By   ${rowid}
    ${Contact}    Read Data From Excel    Correspondence    Contact   ${rowid}
    ${Notice_Status}    Read Data From Excel    Correspondence    Notice_Status   ${rowid}
    ${NoticeGroup_UserID}    Read Data From Excel    Correspondence    NoticeGroup_UserID   ${rowid}
    ${XML_NoticeType}    Read Data From Excel    Correspondence    XML_NoticeType   ${rowid}
    ${EffectiveDate_PrincipalPayment}    Read Data From Excel    Correspondence    EffectiveDate_PrincipalPayment   ${rowid}
    ${Principal_Amount}    Read Data From Excel    Correspondence    Principal_Amount   ${rowid}
    ${Fee_Type}    Read Data From Excel    Correspondence    Fee_Type   ${rowid}
    ${Currency}    Read Data From Excel    Correspondence    Currency   ${rowid}

    Validate the Notice Window in LIQ    ${Search_By}    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    ${Notice_Status}    ${NoticeCustomerLegalName}
    ...    ${Contact}    ${NoticeGroup_UserID}    ${Notice_Method}
    ...    None    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml    &{ExcelPath}[Deal_Name]    ${XML_NoticeType}    ${Fee_Type}
    ...    None    None    None    None    ${Principal_Amount}    None    None
    ...    None    None    None    None    None
    ...    ${EffectiveDate_PrincipalPayment}    ${Principal_Amount}    ${Fee_Type}    ${Currency}    ${NoticeCustomerLegalName}