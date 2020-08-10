*** Settings ***
Resource    ../../../../Configurations/LoanIQ_Import_File.robot

***Keyword***

Create Tickler
    [Documentation]    This keyword is used to Create Tickler
    ...    @ author :Archana
    [Arguments]    ${Excelpath}
    Open Tickler    &{Excelpath}[TicklerTitle] 
    Tickler Details Window    &{Excelpath}[Message]
    User Distribution SelectionList    &{Excelpath}[UserID_Checkbox]
    Tickler Remainders    &{Excelpath}[StartDate]    &{Excelpath}[TicklerRange]    &{Excelpath}[TicklerUntil]    &{Excelpath}[StartDate]    &{Excelpath}[TicklerRange]    &{Excelpath}[TicklerUntil]
    Save Tickler File 
    Open Existing Tickler    &{Excelpath}[ComboboxTitle]    &{Excelpath}[Tickler_Title]
    Tickler Lookup List
    Exit Tickler File
    
     
    
    
    
    