*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Generate DNR Report for Alerts
    [Documentation]    This keyword is used to login to Cognos and download DNR report.
    ...    @author: clanding    16NOV2020    - initial create
    [Arguments]    ${ExcelPath}

    Login to Cognos    &{ExcelPath}[Report_Path]    ${True}
    Go to Specific Report from Team Content Menu CBA Reports    ${ALERTS_REPORTS}
    Run As Report Type    ${CBA_ALERTS_REPORTFILE}    ${EXCEL_REPORTTYPE}
    Set User Range Filter Using From and To and Branch and Download Report    &{ExcelPath}[From_Month]    &{ExcelPath}[To_Month]    &{ExcelPath}[From_Date]    &{ExcelPath}[To_Date]
    ...    &{ExcelPath}[Branch_Code]    ${CBA_ALERTS_REPORTFILE}    &{ExcelPath}[Report_Path]
    Check if File Exist    &{ExcelPath}[Report_Path]    ${CBA_ALERTS_REPORTFILE}
    Logout from Cognos    ${True}

Generate DNR Report for Facility Performance
    [Documentation]    This keyword is used to login to Cognos and download DNR report.
    ...    @author: clanding    25NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Login to Cognos    &{ExcelPath}[Report_Path]    ${True}
    Go to Specific Report from Team Content Menu CBA Reports    ${FACILITY_PERFORMANCE_REPORTS}
    Run As Report Type    ${CBA_LIQPERFORMANCE_REPORTFILE}    ${EXCEL_REPORTTYPE}
    Set Branch and Download Report    &{ExcelPath}[Branch_Code]    &{ExcelPath}[File_Name]${CBA_LIQPERFORMANCE_REPORTFILE}    &{ExcelPath}[Report_Path]
    Check if File Exist    &{ExcelPath}[Report_Path]    ${CBA_LIQPERFORMANCE_REPORTFILE}
    Logout from Cognos    ${True}

Generate DNR Report for Calendar
    [Documentation]    This keyword is used to login to Cognos and download DNR report.
    ...    @author: clanding    27NOV2020    - initial create
    [Arguments]    ${ExcelPath}
 
    Login to Cognos    &{ExcelPath}[Report_Path]    ${True}
    Go to Specific Report from Team Content Menu CBA Reports    ${CALENDAR_REPORTS}
    Run As Report Type    ${CBA_CALENDAR_REPORTFILE}    ${EXCEL_REPORTTYPE}
    Set Filter Using Branch Description and Processing Area and Financial Centre and From and To Date and Download Report    &{ExcelPath}[From_Date]
    ...    &{ExcelPath}[To_Date]    &{ExcelPath}[Branch_Description]    &{ExcelPath}[Processing_Area]    ${CBA_CALENDAR_REPORTFILE}    &{ExcelPath}[Report_Path]    &{ExcelPath}[Financial_Centre]
    ...    &{ExcelPath}[From_Month]    &{ExcelPath}[To_Month]    &{ExcelPath}[From_Year]    &{ExcelPath}[To_Year]
    Check if File Exist    &{ExcelPath}[Report_Path]    ${CBA_CALENDAR_REPORTFILE}
    Logout from Cognos    ${True}
 
Generate DNR Report for Liquidity
    [Documentation]    This keyword is used to login to Cognos and download DNR report.
    ...    @author: clanding    27NOV2020    - initial create
    [Arguments]    ${ExcelPath}
 
    Login to Cognos    &{ExcelPath}[Report_Path]    ${True}
    Go to Specific Report from Team Content Menu CBA Reports    ${LIQUIDITY_REPORTS}
    Run As Report Type    ${CBA_LIQUIDITY_REPORTFILE}    ${EXCEL_REPORTTYPE}
    Set Branch and Download Report    &{ExcelPath}[Branch_Code]    ${CBA_LIQUIDITY_REPORTFILE}    &{ExcelPath}[Report_Path]
    Check if File Exist    &{ExcelPath}[Report_Path]    ${CBA_LIQUIDITY_REPORTFILE}
    Logout from Cognos    ${True}

Generate DNR Report for Comments
    [Documentation]    This keyword is used to login to Cognos and download DNR report.
    ...    @author: clanding    27NOV2020    - initial create
    [Arguments]    ${ExcelPath}
 
    Login to Cognos    &{ExcelPath}[Report_Path]    ${True}
    Go to Specific Report from Team Content Menu CBA Reports    ${COMMENTS_REPORTS}
    Run As Report Type    ${CBA_COMMENTS_REPORTFILE}    ${EXCEL_REPORTTYPE}
    Set User Range Filter Using From and To and Branch and Download Report    &{ExcelPath}[From_Month]    &{ExcelPath}[To_Month]    &{ExcelPath}[From_Date]    &{ExcelPath}[To_Date]
    ...    &{ExcelPath}[Branch_Code]    ${CBA_COMMENTS_REPORTFILE}    &{ExcelPath}[Report_Path]
    Check if File Exist    &{ExcelPath}[Report_Path]    ${CBA_COMMENTS_REPORTFILE}
    Logout from Cognos    ${True}
 
Generate DNR Report for Loans and Accruals
    [Documentation]    This keyword is used to login to Cognos and download DNR report.
    ...    @author: clanding    27NOV2020    - initial create
    [Arguments]    ${ExcelPath}
 
    Login to Cognos    &{ExcelPath}[Report_Path]    ${True}
    Go to Specific Report from Team Content Menu CBA Reports    ${LOANSACCRUALS_REPORTS}
    Run As Report Type    ${CBA_LOANSACCRUALS_REPORTFILE}    ${EXCEL_REPORTTYPE}
    Set Branch and Download Report    &{ExcelPath}[Branch_Code]    ${CBA_LOANSACCRUALS_REPORTFILE}    &{ExcelPath}[Report_Path]
    Check if File Exist    &{ExcelPath}[Report_Path]    ${CBA_LOANSACCRUALS_REPORTFILE}
    Logout from Cognos    ${True}