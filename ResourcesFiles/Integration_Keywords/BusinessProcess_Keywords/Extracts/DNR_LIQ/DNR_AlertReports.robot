*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Validate Report Prompt from Alert Report
    [Documentation]    This keyword is to validate the fields in the Report_Prompt sheet in the Alerts Report
    ...    Fields to Validate: Report Name, From Date and To Date
    ...    @author: songchan    18NOV2020    - intial create
    [Arguments]    ${ExcelPath}

    Validate Multiple Value if Existing in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_ALERTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Deal from Alert Report
    [Documentation]    This keyword is to validate the fields in the Deal sheet in the Alerts Report
    ...    Fields to Validate: Deal Name, Deal Tracking Number, Alert Heading, Alert Content, User Name, Date Added / Amended
    ...    @author: songchan    19NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_ALERTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]

Validate Facility from Alert Report
    [Documentation]    This keyword is to validate the fields in the Facility sheet in the Alerts Report
    ...    Fields to Validate: Deal Name, Deal Tracking Number, Facility Name, 
    ...    Facility FCN, Alert Heading, Alert Content, User Name, Date Added / Amended
    ...    @author: songchan    20NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_ALERTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]    
 
Validate Outstanding from Alert Report
    [Documentation]    This keyword is to validate the fields in the Outstanding sheet in the Alerts Report
    ...    Fields to Validate: Deal Name, Deal Tracking Number, Alias Number, 
    ...    Alert Heading, Alert Content, User Name, Date Added / Amended
    ...    @author: songchan    20NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_ALERTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]    

Validate Customer from Alert Report
    [Documentation]    This keyword is to validate the fields in the Customer sheet in the Alerts Report
    ...    Fields to Validate: Customer Name, CIF Number, Alert Heading, Alert Content,
    ...    User Name, Data Added/Amended
    ...    @author: songchan    20NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Validate Sequencing of Columns if Correct in Excel Sheet    &{ExcelPath}[Report_Path]${CBA_ALERTS_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    ...    &{ExcelPath}[Columns_To_Validate]    &{ExcelPath}[Delimiter]    

Write Details for Alert Report
    [Documentation]    This keyword is used to write needed details in Alert Report sheet.
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_ALERTS_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_ALERTS_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_ALERTS_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_ALERTS_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    ALERT    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_ALERTS_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True

Validate Alert Details for Deal are Correct from Alert Report
    [Documentation]    This keyword is used to extract details from Alert Report and verify if details are correct.
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Name    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Deal_Tracking_Number}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Tracking Number    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Alert_Heading}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Alert Heading    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${User_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    User Name    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Date_Added_Amended}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Date Added / Amended    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    
    Compare Two Strings    &{ExcelPath}[Deal_Name]    ${Deal_Name.strip()}
    Compare Two Strings    &{ExcelPath}[Deal_Tracking_Number]    ${Deal_Tracking_Number.strip()}
    Compare Two Strings    &{ExcelPath}[Alert_Heading]    ${Alert_Heading.strip()}
    Compare Two Strings    &{ExcelPath}[User_Name]    ${User_Name.strip()}
    
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${Date_Added_Amended}    %d-%b-%Y
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Date_Added_Amended]
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}

Validate Alert Details for Facility are Correct from Alert Report
    [Documentation]    This keyword is used to extract details from Alert Report and verify if details are correct.
    ...    @author: clanding    02DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Name    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Deal_Tracking_Number}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Tracking Number    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Facility_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Facility Name    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Facility_FCN}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Facility FCN    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Alert_Heading}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Alert Heading    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${User_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    User Name    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Date_Added_Amended}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Date Added / Amended    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    
    Compare Two Strings    &{ExcelPath}[Deal_Name]    ${Deal_Name.strip()}
    Compare Two Strings    &{ExcelPath}[Deal_Tracking_Number]    ${Deal_Tracking_Number.strip()}
    Compare Two Strings    &{ExcelPath}[Alert_Heading]    ${Alert_Heading.strip()}
    Compare Two Strings    &{ExcelPath}[User_Name]    ${User_Name.strip()}
    Compare Two Strings    &{ExcelPath}[Facility_Name]    ${Facility_Name.strip()}
    Compare Two Strings    &{ExcelPath}[Facility_FCN]    ${Facility_FCN.strip()}
    
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${Date_Added_Amended}    %d-%b-%Y
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Date_Added_Amended]
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}
    
Validate Alert Details for Outstandings are Correct from Alert Report
    [Documentation]    This keyword is used to extract details from Alert Report and verify if details are correct.
    ...    @author: clanding    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ${Deal_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Name    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Deal_Tracking_Number}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Tracking Number    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Alias_Number}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Alias Number    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Alert_Heading}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Alert Heading    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${User_Name}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    User Name    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    ${Date_Added_Amended}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Date Added / Amended    ${ExcelPath}[Alert_Content]    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Alert Content
    
    Compare Two Strings    &{ExcelPath}[Deal_Name]    ${Deal_Name.strip()}
    Compare Two Strings    &{ExcelPath}[Deal_Tracking_Number]    ${Deal_Tracking_Number.strip()}
    Compare Two Strings    &{ExcelPath}[Alias_Number]    ${Alias_Number.strip()}
    Compare Two Strings    &{ExcelPath}[Alert_Heading]    ${Alert_Heading.strip()}
    Compare Two Strings    &{ExcelPath}[User_Name]    ${User_Name.strip()}
    
    ${Report_Date_Value}    Get Date Value from Date Added or Amended Column    ${Date_Added_Amended}    %d-%b-%Y
    ${Dataset_Date_Value}    Get Date Value from Date Added or Amended Column    &{ExcelPath}[Date_Added_Amended]
    Compare Two Strings    ${Dataset_Date_Value}    ${Report_Date_Value.strip()}