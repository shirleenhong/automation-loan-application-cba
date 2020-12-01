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
    Set User Range Filter Using From and To and Branch and Download Report    &{ExcelPath}[From_Date]    &{ExcelPath}[To_Date]    &{ExcelPath}[Branch_Code]
    Logout from Cognos
   