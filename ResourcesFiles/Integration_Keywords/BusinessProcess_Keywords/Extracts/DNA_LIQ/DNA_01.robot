*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***

Trigger Data Net Assurance Job
    [Documentation]    This keyword is used to trigger DataAssurance job..
    ...    @author: clanding    13OCT2020    - initial create
    [Arguments]    ${ExcelPath}
    
    Navigate to Batch Administration
    Remove Existing Schedule in Batch Administration    &{ExcelPath}[Extract_Files_Path]    &{ExcelPath}[Batch_Net]
    Purge Existing Execution Journal in Batch Administration    &{ExcelPath}[Batch_Net]
    Add Schedule in Batch Administration    &{ExcelPath}[Batch_Net]    &{ExcelPath}[Frequency]    &{ExcelPath}[Zone]    &{ExcelPath}[Delimiter]
    Log To Console    Waiting 5 minutes for the batch to trigger.
    Sleep    5m    ###Automatic trigger of batch is every 5 mins
    Validate Batch Job is Not Skipped in Execution Journal    &{ExcelPath}[Zone]    &{ExcelPath}[Refresh_Every_Time]    &{ExcelPath}[Refresh_Every_MinuteOrSecond]
    ...    ${DATA_ASSURANCE_JOB}    &{ExcelPath}[BPR_Name]    &{ExcelPath}[Delimiter]
    Validate Batch Job if Completed in Execution Journal    &{ExcelPath}[Zone]    &{ExcelPath}[Refresh_Every_Time]    &{ExcelPath}[Refresh_Every_MinuteOrSecond]
    ...    &{ExcelPath}[Last_Job_Name]    &{ExcelPath}[BPR_Name]    &{ExcelPath}[Delimiter]
    ${LIQ_Bus_Date}    Get LoanIQ Business Date per Zone and Return    &{ExcelPath}[Zone]
    ${LIQZoneBusinessDate}    Convert Date    ${LIQ_Bus_Date}    result_format=%Y-%m-%d    date_format=%d-%b-%Y
    Write Data to Excel    DNA    Business_Date    ${TestCase_Name}    ${LIQZoneBusinessDate}    ${DNA_DATASET}    bTestCaseColumn=True
    Write Data to Excel    DNA    Business_Date    DNA_03    ${LIQZoneBusinessDate}    ${DNA_DATASET}    bTestCaseColumn=True
    Write Data to Excel    DNA    Business_Date    DNA_04    ${LIQZoneBusinessDate}    ${DNA_DATASET}    bTestCaseColumn=True
    Write Data to Excel    DNA    Business_Date    DNA_06    ${LIQZoneBusinessDate}    ${DNA_DATASET}    bTestCaseColumn=True
