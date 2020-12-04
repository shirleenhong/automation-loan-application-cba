*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Report Prompt from Comments Report
    [Documentation]    This keyword is used to validate fields in Report Prompt_1 sheet name in the Comments Report.
    ...    Fields to Validate: Report Name, From Date, To Date
    ...    @author: clanding    18NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Deal Columns from Comments Report
    [Documentation]    This keyword is used to validate columns in Deal_2 sheet name if existing and if in correct sequence in the Comments Report.
    ...    Columns to Validate: Deal Name, Deal Tracking Number, Comment Heading, Comment Detail, User ID, Date Added / Amended
    ...    @author: clanding    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Facility Columns from Comments Report
    [Documentation]    This keyword is used to validate columns in Facility_3 sheet name if existing and if in correct sequence in the Comments Report.
    ...    Columns to Validate: Deal Name, Deal Tracking Number, Facility Name, Facility FCN, Comment Heading, Comment Detail, User ID, Date Added / Amended
    ...    @author: clanding    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Outstanding Columns from Comments Report
    [Documentation]    This keyword is used to validate columns in Outstanding_4 sheet name if existing and if in correct sequence in the Comments Report.
    ...    Columns to Validate: Deal Name, Deal Tracking Number, Alias Number, Comment Heading, Comment Detail, User ID, Date Added / Amended
    ...    @author: clanding    20NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Customer Columns from Comments Report
    [Documentation]    This keyword is used to validate columns in Customer_5 sheet name if existing and if in correct sequence in the Comments Report.
    ...    Columns to Validate: Customer Name, CIF Number, Comment Heading, Comment Detail, User ID, Date Added / Amended
    ...    @author: fluberio    23NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Write Details for Comments Report
    [Documentation]    This keyword is used to write needed details in Comments Report sheet.
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_COMMENTS_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_COMMENTS_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_COMMENTS_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_COMMENTS_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CMMNT    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_COMMENTS_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True

Validate Comments Details for Deal are Correct from Comments Report
    [Documentation]    This keyword is used to extract details from Comments Report and verify if details are correct.
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Name    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${Deal_Tracking_Number}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Tracking Number    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${Comment_Heading}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Comment Heading    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${User_ID}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    User ID    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${Date_Added_Amended}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Date Added / Amended    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    
    Compare Two Strings    &{ExcelPath}[Deal_Name]    ${Deal_Name.strip()}
    Compare Two Strings    &{ExcelPath}[Deal_Tracking_Number]    ${Deal_Tracking_Number.strip()}
    Compare Two Strings    &{ExcelPath}[Comment_Heading]    ${Comment_Heading.strip()}
    Compare Two Strings    &{ExcelPath}[User_ID]    ${User_ID.strip()}
    
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${Date_Added_Amended}    %d-%b-%Y
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Date_Added_Amended]
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}

Validate Comments Details for Outstanding are Correct from Comments Report
    [Documentation]    This keyword is used to extract details from Comments Report and verify if details are correct.
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Name    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${Deal_Tracking_Number}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Tracking Number    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${Comment_Heading}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Comment Heading    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${Alias_Number}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Alias Number    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${User_ID}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    User ID    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${Date_Added_Amended}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Date Added / Amended    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    
    Compare Two Strings    &{ExcelPath}[Deal_Name]    ${Deal_Name.strip()}
    Compare Two Strings    &{ExcelPath}[Deal_Tracking_Number]    ${Deal_Tracking_Number.strip()}
    Compare Two Strings    &{ExcelPath}[Alias_Number]    ${Alias_Number.strip()}
    Compare Two Strings    &{ExcelPath}[Comment_Heading]    ${Comment_Heading.strip()}
    Compare Two Strings    &{ExcelPath}[User_ID]    ${User_ID.strip()}
    
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${Date_Added_Amended}    %d-%b-%Y
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Date_Added_Amended]
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}

Validate Comments Details for Customer are Correct from Comments Report
    [Documentation]    This keyword is used to extract details from Comments Report and verify if details are correct.
    ...    @author: clanding    04DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Customer_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Customer Name    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${CIF_Number}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    CIF Number    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${Comment_Heading}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Comment Heading    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${User_ID}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    User ID    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    ${Date_Added_Amended}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Date Added / Amended    ${ExcelPath}[Comment_Detail]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Comment Detail
    
    Compare Two Strings    &{ExcelPath}[Customer_Name]    ${Customer_Name.strip()}
    Compare Two Strings    &{ExcelPath}[CIF_Number]    ${CIF_Number.strip()}
    Compare Two Strings    &{ExcelPath}[Comment_Heading]    ${Comment_Heading.strip()}
    Compare Two Strings    &{ExcelPath}[User_ID]    ${User_ID.strip()}
    
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${Date_Added_Amended}    %d-%b-%Y
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Date_Added_Amended]
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}
