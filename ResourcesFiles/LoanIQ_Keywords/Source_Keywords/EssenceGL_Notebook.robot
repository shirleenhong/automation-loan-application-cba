*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Navigate to Essence GL
    [Documentation]    This keyword will navigate to Essence GL Entries  
    ...    @author: gerhabal    16JULY2019    - initial create
        
    Select Actions    [Actions];Accounting and Control
    mx LoanIQ activate window    ${LIQ_AccountingAndControl_Window}
    mx LoanIQ enter    ${LIQ_AccountingAndControl_EssenceGL}    ON
    Sleep    1   
    mx LoanIQ click    ${LIQ_AccountingAndControl_OK_Button}
    
Enter Essence GL Details
    [Documentation]    This keyword will enter details for the Essence GL
    ...    @author: gerhabal    16JULY2019    - initial create
    [Arguments]    ${LIQ_SystemDate}    ${Completed_Status}    
    
    mx LoanIQ activate window    ${LIQ_EssenceGL_Window}
    mx LoanIQ enter    ${LIQ_EssenceGL_FromDate_TextBox}    ${LIQ_SystemDate}
    mx LoanIQ enter    ${LIQ_EssenceGL_ToDate_TextBox}    ${LIQ_SystemDate}
    Mx LoanIQ Select Combo Box Value    ${LIQ_EssenceGL_Status_Dropdown}    ${Completed_Status}
    mx LoanIQ click    ${LIQ_EssenceGL_Search_Button}
      
Get Total row in the GL Screen Window List
    [Documentation]    This keyword will get Total row in the GL Screen Window List
    ...    @author: gerhabal    17JUL2019    - initial create  
    ...    @update: rtarayao    19FEB2020    - udpated the Mx LoanIQ Get Data input from rowcount to items count

    ${itemcount}    Mx LoanIQ Get Data    ${LIQ_EssenceGL_WindowList_JavaTree}    input=items count%tableRow    
    Log    ${itemcount}
    ${itemcount}    Convert To Integer    ${itemcount}
    [Return]    ${itemcount}        
