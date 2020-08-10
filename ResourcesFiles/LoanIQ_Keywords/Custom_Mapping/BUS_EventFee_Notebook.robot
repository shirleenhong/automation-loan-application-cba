*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate Event Fee Notebook in WIP
    [Documentation]    This Keyword is use to navigate the event fee notebook from work in process
    ...    @author: archana      
    Run Keyword    Navigate Event Fee Notebook in WIP    ${Argument1}    ${Argument2}    ${Argument3}    ${Argument4}

BUS_Approve Event Fee via WIP LIQ Icon
       [Documentation]    This keyword navigates the event fee to be approved from Work in Process window
    ...    @author: archana     
    Run Keyword    Approve Event Fee via WIP LIQ Icon    ${Argument1}    ${Argument2}    ${Argument3}
    
BUS_Release Event Fee via WIP LIQ Icon
    [Documentation]    This keyword navigates the Event Fee to be approved from Work in Process window
    ...    @author: archana
    Run Keyword    Release Event Fee via WIP LIQ Icon    ${Argument1}    ${Argument2}    ${Argument3}
    
BUS_Open Event Fee Notebook via WIP - Awaiting Release
    [Documentation]    This keyword is used to open the Event Fee Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
    ...    @author: archana     
    Run Keyword    Open Event Fee Notebook via WIP - Awaiting Release    ${Argument1}    ${Argument2}    ${Argument3}    ${Argument4}
    
BUS_Open Event Fee Notebook via WIP - Awaiting Approval
    [Documentation]    This keyword is used to open the Event Fee Notebook with an Awaiting Approval Status thru the LIQ WIP Icon.
     ...    @author: archana      
    Run Keyword    Open Event Fee Notebook via WIP - Awaiting Approval    ${Argument1}    ${Argument2}    ${Argument3}    ${Argument4}

BUS_Activate Facility Notebook and Select Event Fee
        [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Activate Facility Notebook and Select Event Fee 
    
BUS_Save Event Fee Window
        [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Save Event Fee Window   
    
BUS_Validate Event Fee Notebook General Tab Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Validate Event Fee Notebook General Tab Details    ${Argument1}    ${Argument2}    ${Argument3}
     
BUS_Set Event Fee General Tab Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Set Event Fee General Tab Details    ${Argument1}    ${Argument2}    ${Argument3}    ${Argument4}    ${Argument5}    ${Argument6}    ${Argument7}  
       
BUS_Set Event Fee Frequency Tab Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Set Event Fee Frequency Tab Details    ${Argument1}    ${Argument2}    ${Argument3} 
    
BUS_Create Cashflow for Event Fee
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Create Cashflow for Event Fee
         
BUS_Send Event Fee to Approval
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Send Event Fee to Approval 
    
BUS_Approve Event Fee
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Approve Event Fee 
    
BUS_Release Event Fee
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    23JUL2020    - initial create

    Release Event Fee
    











                