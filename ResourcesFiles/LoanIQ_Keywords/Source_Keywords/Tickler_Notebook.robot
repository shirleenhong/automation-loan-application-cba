*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
   
Open Tickler
    [Documentation]    This keyword enters the details like Title in Open Tickler Window
    ...    @author : Archana
    [Arguments]    ${sTicklerTitle}    ${sRadioButton}=Yes  
    
    ##Keyword Preprocessing### 
    
    ${TicklerTitle}    Acquire Argument Value    ${sTicklerTitle}   
    ${RadioButton}    Acquire Argument Value    ${sRadioButton} 
       
    Select Actions    [Actions];Tickler    
    Mx LoanIQ Activate Window    ${LIQ_TicklerOpen_Window}   
    Mx LoanIQ Enter    ${LIQ_TicklerOpen_New_RadioButton}    ON
    Mx LoanIQ Enter    ${LIQ_TicklerOpen_TicklerTitle_Text}    ${TicklerTitle}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Tickler_Window  
    Mx LoanIQ Click    ${LIQ_TicklerOpen_Ok_Button} 

Tickler Details Window
    [Documentation]    This keyword enters the details like message in Tickler window
    ...    @author :Archana
    [Arguments]    ${sMessage}    ${sNewRadioButton}=ON   
    
##Keyword Preprocessing### 
    
    ${Message}    Acquire Argument Value    ${sMessage}   
    ${NewRadioButton}    Acquire Argument Value    ${sNewRadioButton} 
    
    Mx LoanIQ Activate Window    ${LIQ_Tickler_Window}    
    Mx LoanIQ Enter    ${LIQ_Tickler_Message_Text}    ${Message} 
    Mx LoanIQ Check Or Uncheck    ${LIQ_TicklerOpen_New_RadioButton}     ${NewRadioButton}
    Mx LoanIQ Click    ${LIQ_Tickler_UserDistributionList_Button}
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/CreateTickler_Window
    
User Distribution SelectionList   
    [Documentation]    This keyword is used to select the user distribution list
    ...    @author : Archana
    [Arguments]    ${UserID_Checkbox}  
    
##Keyword Preprocessing### 
    
    ${eExcelpath}    Acquire Argument Value    ${Excelpath}          
    
    Mx LoanIQ Select Or Doubleclick In Tree By Text    ${LIQ_UserDistributionSelectionList_User_Checkbox}    ${UserID_Checkbox}:item%s
    Take screenshot    ${screenshot_path}/Screenshots/LoanIQ/UserDistribution_Window
    Mx LoanIQ Click    ${LIQ_UserDistributionSelectionList_Ok_Button}    
    
Tickler Remainders for Once
    [Documentation]    This keyword is used to select the remainder details with remainding once
    ...    @author : Archana
    [Arguments]    ${sStartDate}    ${sTicklerUntil}    ${sRemindOnceRadioButton}=ON
    
##Keyword Preprocessing### 
    
    ${StartDate}    Acquire Argument Value    ${sStartDate}       
    ${TicklerUntil}    Acquire Argument Value    ${sTicklerUntil}
    ${RemindOnceRadioButton}    Acquire Argument Value    ${sRemindOnceRadioButton}
   
    Mx LoanIQ Enter    ${LIQ_Tickler_StartDate_Field}    ${StartDate} 
    Mx LoanIQ Check Or Uncheck    ${LIQ_Tickler_RemindOnce_RadioButton}    ${RemindOnceRadioButton}       
    Mx LoanIQ Enter    ${LIQ_Tickler_Until_Text}    ${TicklerUntil}  
    
Tickler Remainders for Every Occurance
    [Documentation]    This keyword is used to select the remainder details with remaind every occurance with range
    ...    @author : Archana
    [Arguments]    ${sStartDate}    ${sTicklerRange}    ${sTicklerUntil}    ${Remind}    ${sRemindEveryRadioButton}=ON    
    
    ##Keyword Preprocessing### 
    
    ${StartDate}    Acquire Argument Value    ${sStartDate}   
    ${TicklerRange}    Acquire Argument Value    ${sTicklerRange} 
    ${TicklerUntil}    Acquire Argument Value    ${sTicklerUntil}
    ${RemindOnceRadioButton}    Acquire Argument Value    ${sRemindEveryRadioButton}
    
    Mx LoanIQ Enter    ${LIQ_Tickler_StartDate_Field}    ${StartDate} 
    ${Remind}    Run Keyword And Return Status    Mx LoanIQ Enter    ${LIQ_Tickler_RemindEvery_RadioButton}    ${sRemindEveryRadioButton} 
    Log To Console    ${Remind}    
    Set Global Variable    ${Remind}    
    Mx LoanIQ Enter    ${LIQ_Tickler_Range_Text}   ${TicklerRange}  
    Mx LoanIQ Enter    ${LIQ_Tickler_Until_Text}    ${TicklerUntil}  
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/TicklerRemind_Window
    

    ### Keyword Post-processing ###
    Save Values of Runtime Execution on Excel File    ${sRemindEveryRadioButton}    ${Remind}
 
    [Return]    ${Remind}
         
    
    
Tickler Remainders
    [Documentation]    This keyword is used to select the Remainder details that is remind once or Remind Every occurance
    ...    @author :Archana
    [Arguments]    ${sStartDate}    ${sTicklerRange}    ${sTicklerUntil}    ${Remind}=True    ${sRemindEveryRadioButton}=ON    ${sRemindOnceRadioButton}=ON    
    
    Tickler Remainders for Every Occurance    ${sStartDate}    ${sTicklerRange}    ${sTicklerUntil}    ${sRemindEveryRadioButton}
    Run Keyword if     ${Remind}!=True    Tickler Remainders for Once    ${sStartDate}    ${sTicklerUntil}    ${sRemindOnceRadioButton}   
           

    
Save Tickler File 
    [Documentation]    This keyword is used to save the Tickler file
    ...    @author:Archana
    Select Menu Item    ${LIQ_Tickler_Window}    File    Save
    Select Menu Item    ${LIQ_Tickler_Window}    File    Exit
    
Open Existing Tickler
    [Documentation]    This keyword is used to open the existing tickler
    ...    @author:Archana
    [arguments]    ${sComboboxTitle}    ${sTickler_Title}    ${sLIQ_TicklerOpen_Existing_RadioButton}=ON
    
    ###Keyword Preprocessing### 
    
    ${ComboboxTitle}    Acquire Argument Value    ${sComboboxTitle}   
    ${Tickler_Title}    Acquire Argument Value    ${sTickler_Title} 
    ${LIQ_TicklerOpen_Existing_RadioButton}    Acquire Argument Value    ${sLIQ_TicklerOpen_Existing_RadioButton}
  
    
    Select Actions    [Actions];Tickler
    Mx LoanIQ Activate    ${LIQ_TicklerOpen_Window}
    Mx LoanIQ Enter    ${LIQ_TicklerOpen_Existing_RadioButton}   
    Mx LoanIQ Select Combo Box Value    ${LIQ_TicklerOpen_Title_Combobox}    ${ComboboxTitle}
   
    Mx LoanIQ Enter    ${LIQ_TicklerOpen_TicklerTitle_Text}    ${Tickler_Title}   
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/ExistingTickler_Window 
    Mx LoanIQ Click    ${LIQ_TicklerOpen_Search_Button}
           
Tickler Lookup List
    [Documentation]    This keyword is used to display the tickler lookup list
    ...    @author :Archana
    Mx LoanIQ Activate Window    ${LIQ_TicklerLookupList_Window}    
    Mx LoanIQ Click    ${LIQ_TicklerLookupList_TicklerList} 
    Take Screenshot    ${screenshot_path}/Screenshots/LoanIQ/Tickler Lookup List_Window  
    Mx LoanIQ Click    ${LIQ_TicklerLookupList_Ok_Button}     
    
Exit Tickler File
    [Documentation]    This keyword is used to exit the window file
    ...    @author: Archana
    Select Menu Item    ${LIQ_Tickler_Window}    File    Exit

    
    
  

    
    
    
       
    

