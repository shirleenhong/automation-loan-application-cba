*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Get Notice Details for Fee Payment Notice Upfront Fee LIQ
    [Documentation]    Get Notice Details (Effective Date, Currency, Amount and Fee Type) for Fee Payment Notice - Upfront Fee in LIQ
    ...    @author: fluberio    23OCT2020    Initial Create
    [Arguments]    ${rowid}    ${sDealName}
    
    ###Switch to Original User###
	Logout from Loan IQ
	Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
	
    ###Deal Notebook Window###
    Search Existing Deal    ${sDealName}
    
    ###Navigate to Events Tab And Select Upfront Fee Notices###
    Mx LoanIQ Select Window Tab    ${LIQ_DealNotebook_Tab}    Events
    Mx LoanIQ Select Or DoubleClick In Javatree    ${LIQ_Events_Javatree}    Upfront Fee Payment from Borrower/Agent Released%d
    
    ### Get the Values of Effective Date, UpfrontFee Ammountn Currencym Fee Tyoe###
    ${Effective_Date}    Mx LoanIQ Get Data    ${LIQ_UpfrontFeeFromBorrower_EffectiveDate_Textfield}    text%Effective_Date
    ${UpfrontFee_Amount}    Mx LoanIQ Get Data    ${LIQ_UpfrontFeeFromBorrower_Amount_Textfield}    text%UpfrontFee_Amount
    ${Branch_Description}    Mx LoanIQ Get Data    ${LIQ_UpfrontFeeFromBorrower_Branch_ComboBox}    text%Branch_Description
    ${Currency}    Mx LoanIQ Get Data    ${LIQ_UpfrontFeeFromBorrower_Currency_ComboBox}    text%Currency
    mx LoanIQ click    ${LIQ_FeeDetail_Button}
    Sleep    4s
    ${Fee_Type}    mx_loanIQ_store_tableCell_to_clipboard    ${LIQ_FeeDetail_Selected_FeeType}    ${UpfrontFee_Amount}%Fee Type%Fee_Type
    ${Fee_Type}    Mx LoanIQ Get Data    ${LIQ_FeeDetail_Selected_FeeType}    text%Fee_Type
    Close All Windows on LIQ
    
    Write Data To Excel    Correspondence    Effective_Date    ${rowid}    ${Effective_Date}
    Write Data To Excel    Correspondence    UpfrontFee_Amount    ${rowid}    ${UpfrontFee_Amount}
    Write Data To Excel    Correspondence    Branch_Description    ${rowid}    ${Branch_Description}
    Write Data To Excel    Correspondence    Currency    ${rowid}    ${Currency}
    Write Data To Excel    Correspondence    Fee_Type    ${rowid}    ${Fee_Type}
    
    ${Account_Name}    Get Customer Name from Table Maintenance    ${Branch_Description}
    Write Data To Excel    Correspondence    Account_Name    ${rowid}    ${Account_Name}
    Close All Windows on LIQ

Send Notice For Upfront Fee
    [Documentation]    This keyword is use to successfully sent out a Upfront Fee Payment Notice via WIP
    ...    @author: fluberio    23OCT2020    Initial Create
    [Arguments]    ${ExcelPath}
    
    Get Notice Details for Fee Payment Notice Upfront Fee LIQ    ${rowid}    &{ExcelPath}[Deal_Name]
    
    Get the Notice Details in LIQ    ${rowid}    &{ExcelPath}[SubAdd_Days]    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Notice_Type]    &{ExcelPath}[Zero_TempPath]0.xls
    
    ${FromDate}    Read Data From Excel for API_Data    Correspondence    From_Date    ${rowid}
    ${ThruDate}    Read Data From Excel for API_Data    Correspondence    Thru_Date    ${rowid}
    
    ${NoticeIdentifier}    Read Data From Excel for API_Data    Correspondence    Notice_Identifier    ${rowid}
    ${NoticeCustomerLegalName}    Read Data From Excel for API_Data    Correspondence    Notice_Customer_LegalName    ${rowid}
    
    #Step 1-3: Validate and Sent Notice###
    
    Send Notice via WIP in LIQ    ${NoticeIdentifier}    ${NoticeCustomerLegalName}    &{ExcelPath}[Notice_Method]    Awaiting release        
    
    ##Step 4-7: Validate Event Management Queue###
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
    
    ##Step 8: FFC Validation CBACorrespUpdateMQ###
    Validate FFC CBACorrespUpdateMQ API    ${CorrelationID}    &{ExcelPath}[OutputFilePath]    ${TEMPLATE_TEXTFILE}
    
    ###Step 9: Send Call Back thru Postman###
    ${CorrelationIdByte}    Encode String To Bytes    ${CorrelationID}     UTF-8
    ${MessageIdEncode}    B 32 Encode    ${CorrelationIdByte}
    ${MessageIdDecode}    Decode Bytes To String    ${MessageIdEncode}    UTF-8
    Update Key Values of input JSON file for Correspondence API    ${MessageIdDecode}    &{ExcelPath}[CallBack_Status]    &{ExcelPath}[errorMessage]    
    ...    &{ExcelPath}[InputFilePath]&{ExcelPath}[InputJson].json
     
    Correspondence POST API    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[OutputFilePath]    
    ...    &{ExcelPath}[OutputAPIResponse]    &{ExcelPath}[ExpectedJson]    ${RESPONSECODE_200}
        
    ###Step 10: Exception Queue Validation###
    #Validate Notice in Logged Exception List Window in LIQ    ${BEOStartDate}    ${BEOEndDate}    &{ExcelPath}[Deal_Name]    ${NoticeIdentifier}    
    
    ###Step 12: FFC Validation FFC1CMUpdateSourceMQ### 
    Validate FFC FFC1CMUpdateSourceMQ    ${dataset_path}&{ExcelPath}[OutputFilePath]&{ExcelPath}[OutputAPIResponse].json    ${CorrelationID}    &{ExcelPath}[OutputFilePath]    ${TEMPLATE_TEXTFILE} 
    
    ###Notice Window Validation### 
    ${Contact}    Read Data From Excel for API_Data    Correspondence    Contact   ${rowid}
    ${Notice_AllInRate}    Read Data From Excel for API_Data    Correspondence    Notice_AllInRate   ${rowid}
    ${Notice_Amount}    Read Data From Excel for API_Data    Correspondence    Notice_Amount   ${rowid}
    ${Balance_Amount}    Read Data From Excel for API_Data    Correspondence    Balance_Amount   ${rowid}
    ${Rate_Basis}    Read Data From Excel for API_Data    Correspondence    Rate_Basis   ${rowid}
    
    Validate the Notice Window in LIQ    &{ExcelPath}[Search_By]    ${NoticeIdentifier}    ${FromDate}    ${ThruDate}    &{ExcelPath}[Notice_Status]    ${NoticeCustomerLegalName}    ${Contact}
    ...    &{ExcelPath}[NoticeGroup_UserID]    &{ExcelPath}[Notice_Method]    &{ExcelPath}[Notice_Type]    ${dataset_path}&{ExcelPath}[InputFilePath]&{ExcelPath}[XML_File].xml    &{ExcelPath}[Deal_Name]    
    ...    &{ExcelPath}[XML_NoticeType]    &{ExcelPath}[Loan_PricingOption]    &{ExcelPath}[Loan_BaseRate]    &{ExcelPath}[Loan_Spread]    None
    ...    &{ExcelPath}[OngoingFee_Type]    None    None    None    &{ExcelPath}[Loan_EffectiveDate]    &{ExcelPath}[Loan_MaturityDate]
    ...    &{ExcelPath}[Loan_GlobalOriginal]    &{ExcelPath}[Loan_RateSetting_DueDate]    &{ExcelPath}[Loan_RepricingDate]
    ...    &{ExcelPath}[Effective_Date]    &{ExcelPath}[UpfrontFee_Amount]    &{ExcelPath}[Fee_Type]    &{ExcelPath}[Currency]    &{ExcelPath}[Account_Name]