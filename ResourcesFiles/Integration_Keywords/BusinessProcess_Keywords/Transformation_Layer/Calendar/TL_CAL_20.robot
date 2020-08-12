*** Settings ***
Resource    ../../../../../Configurations/Integration_Import_File.robot

*** Keywords ***
Send Copp Clark When Another Files Are Being Processed
	[Documentation]    This keyword is used to send copp clark files while another set of copp clark files is being processed
	...    And verify that the first batch will be processed successfully in LIQ to SFTP site
	...    And verify that the second batch wil not be processed
	...    Then validate if first batch Copp Clark files are processed and moved to Archive folder.
	...    Then validate FFC and validate in LoanIQ if Holiday Calendar Dates for first batch are reflected.
	...    @author: jloretiz    21AUG2019    - initial create
	[Arguments]    ${ExcelPath}
	
	###PREREQUISITE###
    Login to Loan IQ    ${TL_USERNAME}    ${TL_PASSWORD}
    ${LIQ_Zone3}    Get LoanIQ Business Date per Zone and Return    ${ZONE3}
    Verify if Copp Clark Files Have No Missing File    &{ExcelPath}[InputCoppClarkFiles]
    ${CalendarID_List_File1}    Get Calendar ID from File 1 of Copp Clark Files and Return    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    Holidays
    ${CalendarID_List_File2}    Get Calendar ID from File 2 of Copp Clark Files and Return    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    Holidays
    ${CalendarID_List_Misc}    Get Calendar ID from Misc File of Copp Clark Files and Return    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    Holidays
    Validate Calendar ID if Existing in LIQ for Copp Clark Files    ${CalendarID_List_File1}    ${CalendarID_List_File2}    ${CalendarID_List_Misc}
    
    ${File1_XLSFile}    Get File Name From Copp Clark Files and Return File Name    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    ${File_1}
    ${File2_XLSFile}    Get File Name From Copp Clark Files and Return File Name    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    ${File_2}
    ${Misc_XLSFile}    Get File Name From Copp Clark Files and Return File Name    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputCoppClarkFiles]    ${Misc_File}
    Create Expected JSON for TL Calendar XLS File 1 and File 2    &{ExcelPath}[InputFilePath]    ${File1_XLSFile}    Holidays    &{ExcelPath}[InputJson]    ${File_1}
    Create Expected JSON for TL Calendar XLS File 1 and File 2    &{ExcelPath}[InputFilePath]    ${File2_XLSFile}    Holidays    &{ExcelPath}[InputJson]    ${File_2}
    Create Expected JSON for TL Calendar XLS Misc File    &{ExcelPath}[InputFilePath]    ${Misc_XLSFile}    Holidays    &{ExcelPath}[InputJson]    ${Misc_File}
    Consolidate JSON for 3 XLS Files    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]
    Create XML Using Expected JSON File    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[Expected_wsFinalLIQDestination]
    ###END OF PREREQUISITE###
    
    Send Multiple Files to SFTP and Validate If Files are Processed for Holiday    &{ExcelPath}[InputFilePath]    ${TL_CALENDAR_FOLDER}    &{ExcelPath}[InputCoppClarkFiles]    
    ...    ${TL_CALENDAR_ARCHIVE_FOLDER}
    Log    ${ARCHIVE_GSFILENAME_LIST}
    Get File Name From Archive List    ${ARCHIVE_GSFILENAME_LIST}    ${File_1}
    Run Keyword And Continue On Failure    Validate FFC with Empty Payload for TL Calendar     &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]    &{ExcelPath}[OutputFilePath]    &{ExcelPath}[Actual_CustomCBAPush_Response]
    Run Keyword And Continue On Failure    Validate Empty JSON File For Holiday Calendar Dates    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]
    
    ### GDE-2364 is raised for slowness of screen to load, hence, Loan IQ Validation is not yet tested. Validation will be made on Loan IQ database instead ###
    ### Run Keyword And Continue On Failure    Validate Holiday Calendar in LoanIQ    &{ExcelPath}[InputFilePath]    &{ExcelPath}[InputJson]
