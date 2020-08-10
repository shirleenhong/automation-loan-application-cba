*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Execute EOD - Daily
    [Documentation]    This keyword will be used for the automated execution of Batch
    ...    @author: mananquil    
    ...    @update: rtarayao    14FEB2020    - updated &{ExcelPath}[Command_3] and &{ExcelPath}[Command_4]arguments for Execute Putty keyword
    [Arguments]    ${ExcelPath}  
    
    ###GET SYSTEM DATE####
    ${systemDate}    Get System Date
    
    ###GO TO BATCH ADMINISTRATION###
    Navigate to Batch Administration
    
    ###Validate Next Business Date
    ${nextBusinessDate}    Get Value Next Business Date    &{ExcelPath}[Zone]    &{ExcelPath}[Variable]
    Validate Next Business Date    ${nextBusinessDate}    &{ExcelPath}[Zone]    &{ExcelPath}[File_Location]
    
    ###EXECUTE BATCH ADMINISTRATION####
    ${date}    Execute Batch Administration    &{ExcelPath}[Batch_Net]    &{ExcelPath}[Frequency]    &{ExcelPath}[Zone]    &{ExcelPath}[File_Location]    &{ExcelPath}[File_Name]    
    
    ###RUN PUTTY####
    Execute Putty    &{ExcelPath}[Process]    &{ExcelPath}[Server]    &{ExcelPath}[Port_Number]    &{ExcelPath}[Username]    &{ExcelPath}[Password]    &{ExcelPath}[Command_1]    &{ExcelPath}[Command_2]
    
    ###VALIDATE EOD STATUS
    Validate Batch EOD Status    &{ExcelPath}[Frequency]    ${date}    &{ExcelPath}[File_Location]    &{ExcelPath}[File_Name]    &{ExcelPath}[Status_1]    &{ExcelPath}[Status_2]    &{ExcelPath}[Status_3]    &{ExcelPath}[Status_4]                    
    Validate Batch Admin Exec Journal Status    &{ExcelPath}[Frequency]    ${date}
    
    ###VALIDATE LIQ DATE####
    Validate System Date After EOD    ${systemDate}    &{ExcelPath}[Application_Path]    &{ExcelPath}[Application_Name]    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    
Execute EOD - Multiple Days
     [Documentation]    This keyword will be used for the automated execution of Batch for multiple days.
     ...   @author: mananquil
     ...   @update: rtarayao    14FEB2020    - corrected Execute Putty number of arguments declared. 
     [Arguments]    ${ExcelPath} 
     
           
    ###GET SYSTEM DATE####
    ${systemDate}    Get System Date
    
    ###GO TO BATCH ADMINISTRATION###
    Navigate to Batch Administration
    
    ###ADD DAYS TO CURRENT DATE###
    Add Days to Date for Batch EOD    &{ExcelPath}[Zone]    &{ExcelPath}[Variable]    &{ExcelPath}[Additonal_Day]    &{ExcelPath}[Use_Days]
    
    ${nextBusinessDate}    Read Data From Excel    Batch_EOD    Additonal_Day    ${rowid}
    Validate Next Business Date    ${nextBusinessDate}    &{ExcelPath}[Zone]    &{ExcelPath}[File_Location]
        
    ###EXECUTE BATCH ADMINISTRATION####
    ${date}    Execute Batch Administration    &{ExcelPath}[Batch_Net]    &{ExcelPath}[Frequency]    &{ExcelPath}[Zone]    &{ExcelPath}[File_Location]    &{ExcelPath}[File_Name]
    
    ###RUN PUTTY####
    Execute Putty    &{ExcelPath}[Process]    &{ExcelPath}[Server]    &{ExcelPath}[Port_Number]    &{ExcelPath}[Username]    &{ExcelPath}[Password]    &{ExcelPath}[Command_1]    &{ExcelPath}[Command_2]
    
    ###VALIDATE EOD STATUS
    Validate Batch EOD Status    &{ExcelPath}[Frequency]    ${date}    &{ExcelPath}[File_Location]    &{ExcelPath}[File_Name]    &{ExcelPath}[Status_1]    &{ExcelPath}[Status_2]    &{ExcelPath}[Status_3]    &{ExcelPath}[Status_4]                    
    
    ###VALIDATE LIQ DATE####
    Validate System Date After EOD    ${systemDate}    &{ExcelPath}[Application_Path]    &{ExcelPath}[Application_Name]    &{ExcelPath}[User_Name]    &{ExcelPath}[User_Password]
    
        
    
