*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Validate Branch and Process Area and Deal Calendar of Calendar Report
    [Documentation]    This Keyword is for Scenario 1 of DNR - Validate Calendar Report based on the Filters of Branch, Proc Area and Financial Center - CLAND_001
    ...    @author: fluberio    18NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    ### Get The Total Number of Row in the Given Excel Sheet ###
    ${Row_Count}    Get Total Row Count of Excel Sheet    &{ExcelPath}[Report_Path]${CBA_CALENDAR_REPORTFILE}.xlsx    &{ExcelPath}[Sheet_Name]
    
    ### Get the Branch Value in the Generated Report ###
    ${Actual_Branch}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Branch    1    sFilePath=&{ExcelPath}[Report_Path]${CBA_CALENDAR_REPORTFILE}.xlsx    readAllData=Y   
    
    ### Get The Processing Area in the Generated Report ### 
    ${Actual_Processing_Area}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Processing Area    1    &{ExcelPath}[Report_Path]${CBA_CALENDAR_REPORTFILE}.xlsx    readAllData=Y
    
    ### Get The Deal Calender in the Generated Report
    ${Actual_Deal_Calendar}    Read Data From Excel    &{ExcelPath}[Sheet_Name]    Deal Calendar    1    &{ExcelPath}[Report_Path]${CBA_CALENDAR_REPORTFILE}.xlsx    readAllData=Y  
    
    ### Validation of Expected and Actuals Values from Generated Report ###
    ${Row_Count}    Evaluate    ${Row_Count}-1
    :FOR    ${INDEX}    IN RANGE    0    ${Row_Count}
    \    Compare Two Strings    &{ExcelPath}[Branch]    @{Actual_Branch}[${INDEX}]   
    \    Compare Two Strings    &{ExcelPath}[Processing_Area]    @{Actual_Processing_Area}[${INDEX}]
    \    Compare Two Strings    &{ExcelPath}[Deal_Calender]    @{Actual_Deal_Calendar}[${INDEX}]

Write Details for Calendar Report
    [Documentation]    This keyword is used to write needed details in Calendar Report sheet.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Delete File If Exist    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_CALENDAR_REPORTFILE}.xlsx
    Copy File    &{ExcelPath}[Report_Path]${CBA_CALENDAR_REPORTFILE}.xlsx    &{ExcelPath}[Report_Path]&{ExcelPath}[File_Name]${CBA_CALENDAR_REPORTFILE}.xlsx
    Write Data To Excel    DNR    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_CALENDAR_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    CALND    Report_File_Name    ${TestCase_Name}    &{ExcelPath}[File_Name]${CBA_CALENDAR_REPORTFILE}.xlsx    ${DNR_DATASET}    bTestCaseColumn=True
    
Validate that the Calendar Report is Generated for Outstanding with RELEASED status
    [Documentation]    This keyword is used to extract details from Calendar Reports and validate the Specific Outsanding with RELEASED Status
    ...    @author: fluberio    01DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### Get Expected Details ###
    ${Outstanding_Alias}    Read Data From Excel    SC1_LoanDrawdown    Loan_Alias    ${rowid}    ${DNR_DATASET}
    ${Deal_Name}    Read Data From Excel    SC1_LoanDrawdown    Deal_Name    ${rowid}    ${DNR_DATASET}
    ${Facility_Name}    Read Data From Excel    SC1_LoanDrawdown    Facility_Name    ${rowid}    ${DNR_DATASET}
   
    ### Get Actual Details in the Report
    ${Outstanding_Status}    Read Data From Excel    Outstandings    Outstanding Status    ${Outstanding_Alias}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Outstanding Number
    ${Oustanding_Alias_Report}    Read Data From Excel    Outstandings    Outstanding Number    ${Outstanding_Alias}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Outstanding Number
    ${Deal_Name_Report}    Read Data From Excel    Outstandings    Deal Name    ${Outstanding_Alias}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Outstanding Number
    ${Facility_Name_Report}    Read Data From Excel    Outstandings    Facility Name    ${Outstanding_Alias}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Outstanding Number
       
    Compare Two Strings    &{ExcelPath}[Outstanding_Status]    ${Outstanding_Status}
    Compare Two Strings    ${Outstanding_Alias}    ${Oustanding_Alias_Report}
    Compare Two Strings    ${Deal_Name}    ${Deal_Name_Report.strip()}
    Compare Two Strings    ${Facility_Name}    ${Facility_Name_Report.strip()}

Get Equal Due and Ajdusted Due Date and Write in Filter for Calendar Report
    [Documentation]    This keyword is used to get specific date and write needed details in Calendar Report sheet.
    ...    @author: clanding    07DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${ActualDueDate}    Read Data From Excel    SC1_LoanDrawdown    ActualDueDate    ${rowid}    ${DNR_DATASET}
    ${From_Date}    Get Specific Detail in Given Date    ${ActualDueDate}    D    -
    ${From_Month}    Get Specific Detail in Given Date    ${ActualDueDate}    M    -
    ${From_Year}    Get Specific Detail in Given Date    ${ActualDueDate}    Y    -    
    Write Data To Excel    DNR    From_Date    ${TestCase_Name}    ${From_Date}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Month    ${TestCase_Name}    ${From_Month}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Year    ${TestCase_Name}    ${From_Year}    ${DNR_DATASET}    bTestCaseColumn=True

    ${AdjustedDueDate}    Read Data From Excel    SC1_LoanDrawdown    AdjustedDueDate    ${rowid}    ${DNR_DATASET}
    ${To_Date}    Get Specific Detail in Given Date    ${AdjustedDueDate}    D    -
    ${To_Month}    Get Specific Detail in Given Date    ${AdjustedDueDate}    M    -
    ${To_Year}    Get Specific Detail in Given Date    ${AdjustedDueDate}    Y    -    
    Write Data To Excel    DNR    To_Date    ${TestCase_Name}    ${To_Date}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    To_Month    ${TestCase_Name}    ${To_Month}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    To_Year    ${TestCase_Name}    ${To_Year}    ${DNR_DATASET}    bTestCaseColumn=True

Get Different Due and Ajdusted Due Date and Write in Filter for Calendar Report
    [Documentation]    This keyword is used to get specific date and write needed details in Calendar Report sheet.
    ...    @author: clanding    07DEC2020    - initial create
    [Arguments]    ${ExcelPath}

    ${ActualDueDate}    Read Data From Excel    SC1_PaymentFees    ActualDueDate    ${rowid}    ${DNR_DATASET}
    ${From_Date}    Get Specific Detail in Given Date    ${ActualDueDate}    D    -
    ${From_Month}    Get Specific Detail in Given Date    ${ActualDueDate}    M    -
    ${From_Year}    Get Specific Detail in Given Date    ${ActualDueDate}    Y    -    
    Write Data To Excel    DNR    From_Date    ${TestCase_Name}    ${From_Date}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Month    ${TestCase_Name}    ${From_Month}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    From_Year    ${TestCase_Name}    ${From_Year}    ${DNR_DATASET}    bTestCaseColumn=True

    ${AdjustedDueDate}    Read Data From Excel    SC1_PaymentFees    AdjustedDueDate    ${rowid}    ${DNR_DATASET}
    ${To_Date}    Get Specific Detail in Given Date    ${AdjustedDueDate}    D    -
    ${To_Month}    Get Specific Detail in Given Date    ${AdjustedDueDate}    M    -
    ${To_Year}    Get Specific Detail in Given Date    ${AdjustedDueDate}    Y    -    
    Write Data To Excel    DNR    To_Date    ${TestCase_Name}    ${To_Date}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    To_Month    ${TestCase_Name}    ${To_Month}    ${DNR_DATASET}    bTestCaseColumn=True
    Write Data To Excel    DNR    To_Year    ${TestCase_Name}    ${To_Year}    ${DNR_DATASET}    bTestCaseColumn=True

Validate Equal Fee Cycle and Adjusted Due Date if Correct
    [Documentation]    This keyword is used to extract details from Calendar Reports and validate the in Fee sheet if Fee Cycle and Adjustd Due Date are correct.
    ...    @author: clanding    07DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### Get Expected Details ###
    ${Facility_Name}    Read Data From Excel    SC1_LoanDrawdown    Facility_Name    ${rowid}    ${DNR_DATASET}
    ${LIQ_ActualDueDate}    Read Data From Excel    SC1_LoanDrawdown    ActualDueDate    ${rowid}    ${DNR_DATASET}
    ${LIQ_AdjustedDueDate}    Read Data From Excel    SC1_LoanDrawdown    AdjustedDueDate    ${rowid}    ${DNR_DATASET}
    
    ### Get Actual Details in the Report
    ${FeeCycleDueDate}    Read Data From Excel    Fees    Fee Cycle Due Date    ${Facility_Name}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Facility Name
    ${FeeAdjustedDueDate}    Read Data From Excel    Fees    Fee Adjusted Due Date    ${Facility_Name}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Facility Name
    ${EventsStatus}    Read Data From Excel    Fees    Events Status    ${Facility_Name}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Facility Name
    
    ${Report_FeeCycleDueDate}    Get Date Value from Date Added or Amended Column    ${FeeCycleDueDate}    %d-%b-%Y
    ${Report_FeeAdjustedDueDate}    Get Date Value from Date Added or Amended Column    ${FeeAdjustedDueDate}    %d-%b-%Y
    ${Dataset_ActualDueDate}    Get Date Value from Date Added or Amended Column    ${LIQ_ActualDueDate}
    ${Dataset_AdjustedDueDate}    Get Date Value from Date Added or Amended Column    ${LIQ_AdjustedDueDate}
    Compare Two Strings    ${Dataset_ActualDueDate}    ${Report_FeeCycleDueDate.strip()}
    Compare Two Strings    ${Dataset_AdjustedDueDate}    ${Report_FeeAdjustedDueDate.strip()}
    Compare Two Strings    ${Dataset_AdjustedDueDate}    ${Report_FeeAdjustedDueDate.strip()}
    Compare Two Strings    ${DNR_RELEASED_STATUS}    ${EventsStatus.strip()}

Validate Different Fee Cycle and Adjusted Due Date if Correct
    [Documentation]    This keyword is used to extract details from Calendar Reports and validate the in Fee sheet if Fee Cycle and Adjustd Due Date are correct.
    ...    @author: clanding    07DEC2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### Get Expected Details ###
    ${Facility_Name}    Read Data From Excel    SC1_PaymentFees    Facility_Name    ${rowid}    ${DNR_DATASET}
    ${LIQ_ActualDueDate}    Read Data From Excel    SC1_PaymentFees    ActualDueDate    ${rowid}    ${DNR_DATASET}
    ${LIQ_AdjustedDueDate}    Read Data From Excel    SC1_PaymentFees    AdjustedDueDate    ${rowid}    ${DNR_DATASET}
    
    ### Get Actual Details in the Report
    ${FeeCycleDueDate}    Read Data From Excel    Fees    Fee Cycle Due Date    ${Facility_Name}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Facility Name
    ${FeeAdjustedDueDate}    Read Data From Excel    Fees    Fee Adjusted Due Date    ${Facility_Name}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Facility Name
    ${EventsStatus}    Read Data From Excel    Fees    Events Status    ${Facility_Name}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}    &{ExcelPath}[Report_Path]&{ExcelPath}[Report_File_Name]    bTestCaseColumn=True    sTestCaseColReference=Facility Name
    
    ${Report_FeeCycleDueDate}    Get Date Value from Date Added or Amended Column    ${FeeCycleDueDate}    %d-%b-%Y
    ${Report_FeeAdjustedDueDate}    Get Date Value from Date Added or Amended Column    ${FeeAdjustedDueDate}    %d-%b-%Y
    ${Dataset_ActualDueDate}    Get Date Value from Date Added or Amended Column    ${LIQ_ActualDueDate}
    ${Dataset_AdjustedDueDate}    Get Date Value from Date Added or Amended Column    ${LIQ_AdjustedDueDate}
    Compare Two Strings    ${Dataset_ActualDueDate}    ${Report_FeeCycleDueDate.strip()}
    Compare Two Strings    ${Dataset_AdjustedDueDate}    ${Report_FeeAdjustedDueDate.strip()}
    Compare Two Strings    ${DNR_RELEASED_STATUS}    ${EventsStatus.strip()}