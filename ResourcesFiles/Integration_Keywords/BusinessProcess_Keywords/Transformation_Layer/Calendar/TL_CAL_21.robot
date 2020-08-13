*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Variables ***
${Column_ISOCountryCode}    ISOCountryCode
${Column_CentreCode}        CentreCode
${Column_ISOMicCode}        ISO MIC Code
${Sheetname}                Holidays

*** Keywords ***
Send Copp Clark Files for New Created Calendar ID
    [Documentation]    This keyword is used to send copp clark files with newly created Calendar ID.
    ...    And verify that it will be processed successfullyin LIQ to SFTP site.
    ...    Then validate if Copp Clark files are processed and moved to Archive folder.
    ...    Then validate FFC and validate in LoanIQ if Holiday Calendar Dates are reflected.
    ...    @author: jloretiz    16AUG2019    - initial create
    ...    @update: jloretiz    26NOV2019    - update the names to XLSX from XLS
    [Arguments]    ${ExcelPath}
    
    ###PREREQUISITE###
    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${LIQ_Zone3}    Get LoanIQ Business Date per Zone and Return    ${ZONE3}
    Verify if Copp Clark Files Have No Missing File    &{ExcelPath}[InputCoppClarkFiles]

    ${File1_XLSXFile}    Get File Name From Copp Clark Files and Return File Name    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    ${File_1}
    ${File2_XLSXFile}    Get File Name From Copp Clark Files and Return File Name    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    ${File_2}
    ${Misc_XLSXFile}     Get File Name From Copp Clark Files and Return File Name    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    ${Misc_File}
    
    ${FileType}       Get Random File and Return
    ${Calendar_ID}    Generate Random Calendar ID and Return   ${FileType}
    Write Data To Excel for New Calendar ID    ${Sheetname}   ${Column_ISOCountryCode}    ${Column_CentreCode}    ${Column_ISOMicCode}    
    ...    ${Calendar_ID}    ${File1_XLSXFile}    ${File2_XLSXFile}    ${Misc_XLSXFile}    ${FileType}
       
    ${CalendarID_List_File1}    Get Calendar ID from File 1 of Copp Clark Files and Return    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    Holidays
    ${CalendarID_List_File2}    Get Calendar ID from File 2 of Copp Clark Files and Return    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    Holidays
    ${CalendarID_List_Misc}    Get Calendar ID from Misc File of Copp Clark Files and Return    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    Holidays
    Validate Calendar ID if Existing in LIQ for Copp Clark Files    ${CalendarID_List_File1}    ${CalendarID_List_File2}    ${CalendarID_List_Misc}

    Create Expected JSON for TL Calendar XLS File 1 and File 2    &{ExcelPath}[InputFilePath]    ${File1_XLSXFile}    Holidays    &{ExcelPath}[InputJson]    ${File_1}
    Create Expected JSON for TL Calendar XLS File 1 and File 2    &{ExcelPath}[InputFilePath]    ${File2_XLSXFile}    Holidays    &{ExcelPath}[InputJson]    ${File_2}
    Create Expected JSON for TL Calendar XLS Misc File    &{ExcelPath}[InputFilePath]    ${Misc_XLSXFile}    Holidays    &{ExcelPath}[InputJson]    ${Misc_File}
    Consolidate JSON for 3 XLS Files    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]
    Create XML Using Expected JSON File    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ###END OF PREREQUISITE###

    Send Multiple Files to SFTP and Validate If Files are Processed for Holiday    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDAR_ARCHIVE_FOLDER}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Get File Name From Archive List    ${ARCHIVE_GSFILENAME_LIST}    ${File_1}
    
    Run Keyword And Continue On Failure    Validate FFC for TL Calendar Success    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]    &{ExcelPath}[OutputFilePath]    
    ...    &{ExcelPath}[OutputFFCResponse]    &{ExcelPath}[Actual_wsFinalLIQDestination]    &{ExcelPath}[Actual_CustomCBAPush_Response]    &{ExcelPath}[Actual_ResponseMechanism]
    
    Run Keyword And Continue On Failure    Validate Holiday Calendar Dates in Loan IQ Database    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]
    
    ### GDE-2364 is raised for slowness of screen to load, hence, Loan IQ Validation is not yet tested. Validation will be made on Loan IQ database instead ###
    ### Run Keyword And Continue On Failure    Validate Holiday Calendar in LoanIQ    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]
    
