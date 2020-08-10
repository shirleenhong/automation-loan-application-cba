*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Navigate to Batch Administration
    [Documentation]    This keyword will navigate to batch administration
    ...    @author: mnanquil
    ...    11/5/2018
    Select Actions    [Actions];Batch Administration
    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    mx LoanIQ click element if present    ${LIQ_Batch_Admin_Inquiry_Mode_Button}
    
Execute Batch Administration
    [Documentation]    This keyword will execute batch administration
    ...    @author: mnanquil
    ...    11/5/2018
    [Arguments]    ${batchNet}    ${frequency}    ${zone}    ${fileLocation}    ${fileName}    ${systemDAte}=N
    ${systemDate1}    Get System Date
    Mx LoanIQ Select Combo Box Value   ${LIQ_Batch_Admin_Master_ComboBox}    MASTER
    mx LoanIQ click    ${LIQ_Batch_Admin_Add_Button}
    mx LoanIQ activate window    ${LIQ_Scheduled_Editor_Window}
	Mx LoanIQ Select Combo Box Value    ${LIQ_Scheduled_Editor_Frequency_ComboBox}    Once - Specific Date
	${date}    Mx LoanIQ Get Data    ${LIQ_Scheduled_Editor_Date}    data
	Run keyword if    '${systemDate}' == 'Y'    Set Global Variable    ${date}    ${systemDate1}
	Run keyword if    '${systemDate}' == 'N'    Set Global Variable    ${date}    
    mx LoanIQ click    ${LIQ_Scheduled_Editor_Cancel_Button}
    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    mx LoanIQ click     ${LIQ_Batch_Admin_Execution_Journal_Button}
	${status}    Run keyword and Return Status    mx LoanIQ select list    ${LIQ_Execution_Scheduled_ExecutionDate_ComboBox}    ${date}
	Run keyword if    '${status}' == 'True'    mx LoanIQ select    ${LIQ_Execution_Scheduled_File_Purge_Menu}
	Run keyword if    '${status}' == 'True'    mx LoanIQ enter    ${LIQ_Execution_Scheduled_File_Purge_From_Date}    ${date}
	Run keyword if    '${status}' == 'True'    mx LoanIQ enter    ${LIQ_Execution_Scheduled_File_Purge_To_Date}    ${date}
	Run keyword if    '${status}' == 'True'    mx LoanIQ click    ${LIQ_Execution_Scheduled_File_Purge_Ok_Button}  
	Run keyword if    '${status}' == 'True'    Mx LoanIQ Verify Object Exist    ${LIQ_Execution_Scheduled_Items_Count}    VerificationData="Yes"
	Run keyword if    '${status}' == 'True'    mx LoanIQ close window    ${LIQ_Execution_Window}
	Run keyword if    '${status}' == 'False'    mx LoanIQ close window    ${LIQ_Execution_Window}
	Log    =======================
	Mx LoanIQ Copy Content And Save To File    ${LIQ_Batch_Java_Tree}    BATCH2.txt
	${DATA}    OperatingSystem.Get file     ${fileLocation}BATCH2.txt
    ${lineCount}    Get Line Count    ${data}
    :FOR    ${INDEX}    IN RANGE    1    ${lineCount}
    \    ${lineDetail}    Get Line    ${DATA}        ${INDEX}
    \    ${status1}    Run keyword and Return Status    Should Contain    ${lineDetail}    "${frequency}"\t"${date}"
    \    Log    Status is: ${status1}
    \    Run keyword if    '${status1}' == 'True'    Mx LoanIQ Select String    ${LIQ_Batch_Java_Tree}    ${frequency}\t${date}
    \    Run keyword if    '${status1}' == 'True'    mx LoanIQ click    ${LIQ_Batch_Admin_Remove_Button}
    \    Run keyword if    '${status1}' == 'True'    Mx Native Type    {ENTER}
    \    Run keyword if    '${status1}' == 'True'    Exit For Loop
    \    Run keyword if    '${status1}' == 'False'    Log    Not Found                       
	Log    =======================           
    mx LoanIQ click    ${LIQ_Batch_Admin_Add_Button}
	Mx LoanIQ Select Combo Box Value    ${LIQ_Scheduled_Editor_Frequency_ComboBox}    Once - Specific Date
	Mx LoanIQ Select Combo Box Value    ${LIQ_Scheduled_Editor_Location_ComboBox}    ZONE3
    mx LoanIQ click    ${LIQ_Scheduled_Editor_Ok_Button}
	[Return]    ${date}
    

Execute Putty
    [Documentation]    This keyword will execute putty to trigger eod
    ...    @author: mnanquil    05NOV2018    - initial create
    ...    @update: rtarayao    14FEB2020    - deleted arguments ${command3} and ${command4} as they are no longer necessary
    ...                                      - disabled activation of window for Putty
    [Arguments]    ${process}    ${server}    ${portNumber}    ${username}    ${password}    ${command1}    ${command2}    
    Start Process    ${process}
    Mx Activate Window    ${PuttyConfiguration_Window}  
    mx LoanIQ enter    ${PuttyConfiguration_Server_Input}    ${server}
    mx LoanIQ enter    ${PuttyConfiguration_Port_Input}    ${portNumber}
    mx LoanIQ click    ${PuttyConfiguration_Load_Button}
    mx LoanIQ click    ${PuttyConfiguration_Open_Button}
    # Mx Activate Window    ${Putty_Window}
    Sleep    2s
    Mx Native Type    ${username}
    Mx Native Type    {ENTER}
    Sleep    2s
    Mx Native Type    ${password}
    Mx Native Type    {ENTER}
    Sleep    2s
    Mx Native Type    ${command1}
    Mx Native Type    {ENTER}
    Sleep    2s
    Mx Native Type    ${command2}
    Mx Native Type    {ENTER}
    Sleep    2s
    

Validate Batch EOD Status
    [Documentation]    This keyword will validate the status of EOD if it's already Skipped
    ...    @author: mnanquil
    ...    11/5/2018
    [Arguments]    ${frequency}    ${date}    ${fileLocation}    ${fileName}    ${status1}    ${status2}    ${status3}    ${status4}
    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    Mx LoanIQ Select String    ${LIQ_Batch_Java_Tree}    ${frequency}\t${date}
    mx LoanIQ click     ${LIQ_Batch_Admin_Execution_Journal_Button}
    mx LoanIQ select list    ${LIQ_Execution_Scheduled_ExecutionDate_ComboBox}    ${date}
    ${DATA}    OperatingSystem.Get file     ${fileLocation}${fileName}
    ${lineCount}    Get Line Count    ${data}
    mx LoanIQ close window    ${LIQ_Execution_Window } 
    :FOR    ${INDEX}    IN RANGE    ${lineCount}
    \    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    \    Mx LoanIQ Select String    ${LIQ_Batch_Java_Tree}    ${frequency}\t${date}
    \    mx LoanIQ click     ${LIQ_Batch_Admin_Execution_Journal_Button}
    \    mx LoanIQ activate window    ${LIQ_Execution_Window}
    \    mx LoanIQ select list    ${LIQ_Execution_Scheduled_ExecutionDate_ComboBox}    ${date}   
    \    Mx LoanIQ Copy Content And Save To File    ${LIQ_Execution_Scheduled_JavaTree}    ${fileName}
    \    mx LoanIQ close window    ${LIQ_Execution_Window } 
    \    ${DATA}    OperatingSystem.Get file     ${fileLocation}${fileName}
    \    ${status}    Run keyword and Return Status    Validate Batch EOD File    ${status1}    ${status2}    ${status3}    ${status4}    ${fileLocation}    ${fileName}
    \    Run keyword if    '${status}' == 'True'    Log    All of the lines are now in Skipped status
    \    Run keyword if    '${status}' == 'True'    mx LoanIQ close window    ${LIQ_Batch_Admin_Window}   
    \    Run keyword if    '${status}' == 'True'    Exit For Loop
    \    Run keyword if    '${status}' == 'False'   Log    Counter: ${INDEX}. Will validate again.
    \    Run keyword if    ${INDEX} == ${lineCount}    Fatal Error    Already tried ${lineCount} times but some of the lines are still not in skipped status.

Validate Batch Admin Exec Journal Status
    [Documentation]    This keyword checks the Exec Journal if all status are 'Skipped'
    ...    @author: bernchua
    ...    @update: gerhabal    12AUG2019    - increased range from 20 to 50 and waiting time from 20 to 30 to accomodate new Batch EoD longer process time    
    [Arguments]    ${frequency}    ${date}
    mx LoanIQ activate    ${LIQ_Batch_Admin_Window}
    Mx LoanIQ Select String    ${LIQ_Batch_Java_Tree}    ${frequency}\t${date}
    mx LoanIQ click     ${LIQ_Batch_Admin_Execution_Journal_Button}
    mx LoanIQ select list    ${LIQ_Execution_Scheduled_ExecutionDate_ComboBox}    ${date}
    mx LoanIQ activate    ${LIQ_Execution_Window}
    :FOR    ${i}    IN RANGE    50
    \    ${lastLine_Status}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Execution_Scheduled_JavaTree}    195%BPR Name%status
    \    Run Keyword If    '${lastLine_Status}'!='Skipped'    Run Keywords    Sleep    30
         ...    AND    mx LoanIQ select    ${LIQ_Execution_Scheduled_File_Refresh}
    \    Exit For Loop If    '${lastLine_Status}'=='Skipped'
    Run Keyword If    '${lastLine_Status}'!='Skipped'    Run Keywords    Close All Windows on LIQ
    ...    AND    Fail    EOD batch not successful.
    mx LoanIQ close window    ${LIQ_Execution_Window}
    mx LoanIQ close window    ${LIQ_Batch_Admin_Window}
    
Validate Batch EOD File
    [Documentation]    This keyword will validate the generated file for batch eod if all status is already skipped
    ...    @author: mnanquil
    ...    11/05/2018
    [Arguments]    ${data1}   ${data2}      ${data3}       ${data4}    ${fileLocation}    ${fileName}  
    ${DATA}    OperatingSystem.Get file     ${fileLocation}${fileName}
    ${lineCount}    Get Line Count    ${data}
     :FOR    ${INDEX}    IN RANGE    1    ${lineCount}
    \    ${lineDetail}    Get Line    ${DATA}        ${INDEX}
    \    ${status1}    Run keyword and Return Status    Should Contain    ${lineDetail}    ${data1}
    \    ${status2}    Run keyword if    '${status1}' == 'False'    Run Keyword    Run keyword and Return Status    Should Contain    ${lineDetail}    ${data2}
    \    ${status3}    Run keyword if    '${status2}' == 'False'    Run Keyword    Run keyword and Return Status    Should Contain    ${lineDetail}    ${data3}
    \    ${status4}    Run keyword if    '${status3}' == 'False'    Run Keyword    Run keyword and Return Status    Should Contain    ${lineDetail}    ${data4}
    \    Run keyword if    '${status4}' == 'False'    Run Keyword and Continue on Failure    Fail    Status: ${data4} not found

Validate System Date After EOD
    [Documentation]    This keyword will validate the system date after performing EOD
    ...    @author: mnanquil
    ...    11/5/2018
    ...    @update: gerhabal    07AUG2019    - updated passing of Username and Password for logging-in instead of being hardcoded 
    ...    @update: gerhabal    12AUG2019    - updated close and relaunch of application part    
    [Arguments]    ${oldSystemDate}    ${applicationPath}    ${applicationName}    ${Username}    ${Password}    
     :FOR    ${INDEX}    IN RANGE    5
    \    Close Application Via CMD    ${applicationName}    
    \    Launch LoanIQ Application    ${applicationPath}${applicationName} 
    \    Login to Loan IQ    ${Username}    ${Password}
    \    ${newSystemDate}    Get System Date
    \    ${status}    Run keyword and Return Status    Should Not Be Equal    ${oldSystemDate}    ${newSystemDate}
    \    Run keyword if    '${status}' == 'True'    Log    Old System Date: ${oldSystemDate} is not equal to New System Date: ${newSystemDate}         
    \    Run keyword if    '${status}' == 'True'    Exit For Loop
    \    Run keyword if    '${status}' == 'False'   Log    Will try to login again to check the new system date.
    \    Run keyword if    '${status}' == 'False'   Sleep    20s
    \    Run keyword if    ${INDEX} == 4    Fatal Error    Already tried 5 times but the dates are still equal
    Terminate Process
    
Add Days to Date for Batch EOD
    [Documentation]    This keyword will add days to the current date
    ...    How to use this keyword? 
    ...    1. if Use_Days in Excel is set to "N" this keyword will automatically go to Use Excel Date for EOD.
    ...    just supply the date for example 21-Mar-2019 not the number of days and set Use_Days in excel to "N"
    ...    2. if Use_Days in Excel is set to "Y" make sure that the additional days value should be for ex: 30 Days
    ...    not "21-Mar-2019".
    ...    @author: mnanquil
    ...    11/6/2018
    [Arguments]    ${zone}    ${variable}    ${numberOfDays}    ${addDays}
    Run keyword if    '${addDays}' == 'N'    Use Excel Date for EOD     ${zone}    ${variable}    ${numberOfDays}
    Run keyword if    '${addDays}' == 'Y'    Add Days to EOD    ${zone}    ${variable}    ${numberOfDays}     
    

Use Excel Date for EOD
    [Documentation]    This keyword will add days to the current date
    ...    @author: mnanquil
    ...    11/6/2018
    [Arguments]    ${zone}    ${variable}    ${numberOfDays}
    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    mx LoanIQ select    ${LIQ_Batch_Admin_Options_Environment}
    mx LoanIQ activate window    ${LIQ_Environment_Parameter_Window}
    Mx LoanIQ Select String    ${LIQ_Environment_Parameter_JavaTree}    ${zone}\t${variable}    
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_Environment_Param_Window}
    ${day}    Get Substring    ${numberOfDays}    0    2
    ${month}    Get Substring    ${numberOfDays}    3    6
    ${year}    Get Substring    ${numberOfDays}    7    11
    Run keyword if    '${month}'=='Jan'    Set Global Variable    ${month}    01
    Run keyword if    '${month}'=='Feb'    Set Global Variable    ${month}    02
    Run keyword if    '${month}'=='Mar'    Set Global Variable    ${month}    03
    Run keyword if    '${month}'=='Apr'    Set Global Variable    ${month}    04
    Run keyword if    '${month}'=='May'    Set Global Variable    ${month}    05
    Run keyword if    '${month}'=='Jun'    Set Global Variable    ${month}    06
    Run keyword if    '${month}'=='Jul'    Set Global Variable    ${month}    07
    Run keyword if    '${month}'=='Aug'    Set Global Variable    ${month}    08
    Run keyword if    '${month}'=='Sep'    Set Global Variable    ${month}    09
    Run keyword if    '${month}'=='Oct'    Set Global Variable    ${month}    10
    Run keyword if    '${month}'=='Nov'    Set Global Variable    ${month}    11
    Run keyword if    '${month}'=='Dec'    Set Global Variable    ${month}    12
    Log    ${month}
    ${addedDate}    Set Variable    ${month}-${day}-${year}    
    Set Global Variable    ${addedDate}    ${addedDate}
    mx LoanIQ enter    ${LIQ_Environment_Param_Value}    ${addedDate}
    mx LoanIQ click    ${LIQ_Environment_OK_Button}
    mx LoanIQ close window    ${LIQ_Environment_Parameter_Window}
    
Add Days to EOD
     [Documentation]    This keyword will add days to the current date
    ...    @author: mnanquil
    ...    11/6/2018
    [Arguments]    ${zone}    ${variable}    ${numberOfDays}
    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    mx LoanIQ select    ${LIQ_Batch_Admin_Options_Environment}
    mx LoanIQ activate window    ${LIQ_Environment_Parameter_Window}
    Mx LoanIQ Select String    ${LIQ_Environment_Parameter_JavaTree}    ${zone}\t${variable}    
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_Environment_Param_Window}
    ${date}    Mx LoanIQ Get Data    ${LIQ_Environment_Param_Value}    data
    ${month}    Get Substring    ${date}    0    2
    ${day}    Get Substring    ${date}    3    5
    ${year}    Get Substring    ${date}    6    10
    Run keyword if    '${month}'=='Jan'    Set Global Variable    ${month}    01
    Run keyword if    '${month}'=='Feb'    Set Global Variable    ${month}    02
    Run keyword if    '${month}'=='Mar'    Set Global Variable    ${month}    03
    Run keyword if    '${month}'=='Apr'    Set Global Variable    ${month}    04
    Run keyword if    '${month}'=='May'    Set Global Variable    ${month}    05
    Run keyword if    '${month}'=='Jun'    Set Global Variable    ${month}    06
    Run keyword if    '${month}'=='Jul'    Set Global Variable    ${month}    07
    Run keyword if    '${month}'=='Aug'    Set Global Variable    ${month}    08
    Run keyword if    '${month}'=='Sep'    Set Global Variable    ${month}    09
    Run keyword if    '${month}'=='Oct'    Set Global Variable    ${month}    10
    Run keyword if    '${month}'=='Nov'    Set Global Variable    ${month}    11
    Run keyword if    '${month}'=='Dec'    Set Global Variable    ${month}    12
    Log    ${month}
     ${addedDate}    Add Time To Date    ${year}-${month}-${day}    ${numberOfDays}
    Set Global Variable    ${date}    ${addedDate}
    ${CurrentDay}    Convert Date     ${addedDate}   result_format=%A
    Log    ${CurrentDay}
    ${date1}    Run keyword if    '${CurrentDay}' == 'Saturday'    Add Time To Date    ${addedDate}   2 days
    Run keyword if    '${CurrentDay}' == 'Saturday'    Set Global Variable    ${date}    ${date1}
    ${date2}    Run keyword if    '${CurrentDay}' == 'Sunday'    Add Time To Date    ${addedDate}    1 days
    Run keyword if    '${CurrentDay}' == 'Sunday'    Set Global Variable    ${date}    ${date2}
    ${date3}    Run keyword if    '${CurrentDay}' != 'Saturday'    Add Time To Date    ${addedDate}    0 days
    Run keyword if    '${CurrentDay}' != 'Saturday'    Set Global Variable    ${date}    ${date3}
    ${original_date}    Convert Date    ${date}    result_format=%Y-%m-%d
    ${date}    Convert Date    ${date}    result_format=%d-%b-%Y
    
    
    ${dateEnter}    Convert Date    ${original_date}     	result_format=%m-%d-%Y	   
    Set Global Variable    ${dateEnter}    
    mx LoanIQ enter    ${LIQ_Environment_Param_Value}    ${dateEnter}
    mx LoanIQ click    ${LIQ_Environment_OK_Button}
    mx LoanIQ close window    ${LIQ_Environment_Parameter_Window}
    
    
Get Value Next Business Date
    [Documentation]    This keyword will get the value for next business date
    ...    @author: mnanquil
    ...    11/13/2018
    [Arguments]    ${zone}    ${variable}
    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    mx LoanIQ select    ${LIQ_Batch_Admin_Options_Environment}
    mx LoanIQ activate window    ${LIQ_Environment_Parameter_Window}
    Mx LoanIQ Select String    ${LIQ_Environment_Parameter_JavaTree}    ${zone}\t${variable}    
    Mx Native Type    {ENTER}
    mx LoanIQ activate window    ${LIQ_Environment_Param_Window}
    ${date}    Mx LoanIQ Get Data    ${LIQ_Environment_Param_Value}    data
    ${month}    Get Substring    ${date}    0    2
    ${day}    Get Substring    ${date}    3    5
    ${year}    Get Substring    ${date}    6    10
    Run keyword if    '${month}'=='01'    Set Global Variable    ${month}    Jan
    Run keyword if    '${month}'=='02'    Set Global Variable    ${month}    Feb
    Run keyword if    '${month}'=='03'    Set Global Variable    ${month}    Mar
    Run keyword if    '${month}'=='04'    Set Global Variable    ${month}    Apr
    Run keyword if    '${month}'=='05'    Set Global Variable    ${month}    May
    Run keyword if    '${month}'=='06'    Set Global Variable    ${month}    Jun
    Run keyword if    '${month}'=='07'    Set Global Variable    ${month}    Jul
    Run keyword if    '${month}'=='08'    Set Global Variable    ${month}    Aug
    Run keyword if    '${month}'=='09'    Set Global Variable    ${month}    Sep
    Run keyword if    '${month}'=='10'    Set Global Variable    ${month}    Oct
    Run keyword if    '${month}'=='11'    Set Global Variable    ${month}    Nov
    Run keyword if    '${month}'=='12'    Set Global Variable    ${month}    Dec
    ${date}    Set Variable    ${day}-${month}-${year}
    mx LoanIQ click    ${LIQ_Environment_Cancel_Button}
    mx LoanIQ close window    ${LIQ_Environment_Parameter_Window}
    [Return]    ${date}
    
Validate Next Business Date
    [Documentation]    This keyword will validate the next business date
    ...    @author: mnanquil
    [Arguments]    ${nextBusinessDate}    ${zone}    ${fileLocation}
    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    mx LoanIQ close window    ${LIQ_Batch_Admin_Window}
     Select Actions    [Actions];Batch Administration
    mx LoanIQ activate window    ${LIQ_Batch_Admin_Window}
    mx LoanIQ click    ${LIQ_Batch_Admin_Inquiry_Mode_Button}
     Mx LoanIQ Copy Content And Save To File    ${LIQ_Batch_Admin_TimeZone_JavaTree}    TIMEZONE.txt      
     ${data}    OperatingSystem.Get File    ${fileLocation}TIMEZONE.txt
     ${lineCount}    Get Line Count    ${data}
     :FOR    ${INDEX}    IN RANGE    0    ${lineCount}
     \    ${lineDetail}    Get Line    ${data}    ${INDEX}
     \    ${status}    Run keyword and Return Status    Should Contain    ${lineDetail}    ${zone}
     \    Run keyword if    '${status}' == 'True'    Should Contain    ${lineDetail}    ${nextBusinessDate}
     \    Run keyword if    '${status}' == 'True'    Log    Successfully validated: ${nextBusinessDate}
     \    Run keyword if    '${status}' == 'True'    Exit For Loop
     \    Run keyword if    '${lineCount}' == '${INDEX}'    Run keyword and Continue on Failure    Fail    Please check the next business date for ${zone}. 
               
    
    
    
       
        
                               
    
    
        
         
        
        
            
        
        
    
                
                    
                
