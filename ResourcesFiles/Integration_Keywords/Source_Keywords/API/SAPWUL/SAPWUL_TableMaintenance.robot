*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***   
Open Table Maintenance
    [Documentation]    This keyword opens Table Maintenance Search Window.
    ...                @author: hstone    10SEP2019    Initial create
    mx LoanIQ click    ${LIQ_TableMaintenance_Button}
    mx LoanIQ activate window    ${LIQ_TableMaintenance_Window}
    Log     Table Maintenance Window is Opened

Close Table Maintenance
    [Documentation]    This keyword opens Table Maintenance Search Widndow.
    ...                @author: hstone    10SEP2019    Initial create
    mx LoanIQ close window   ${LIQ_TableMaintenance_Window}
    Log     Table Maintenance Window is Closed
    
Get Facility Type Code from Table Maintenance
    [Documentation]    This keyword gets the Table Maintenance Facility Type Code for the given Facility Type Argument.
    ...                @author: hstone    10SEP2019    Initial create
    [Arguments]    ${sFacilityType}
    Search in Table Maintenance    Facility Type
    mx LoanIQ activate window    ${LIQ_BrowseFacilityType_Window}
    ${FacilityTypeCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseFacilityType_JavaTree}    ${sFacilityType}%Code%value  
    Log     ${sFacilityType} Facility Type Code is ${FacilityTypeCode}
    mx LoanIQ close window    ${LIQ_BrowseFacilityType_Window}    
    [Return]    ${FacilityTypeCode}
    
Get Facility Processing Area Code from Table Maintenance
    [Documentation]    This keyword gets the Table Maintenance Facility Processing Area Code for the given Facility Processing Area Argument.
    ...                @author: hstone    10SEP2019    Initial create
    [Arguments]    ${sFacilityProcessingArea}
    Search in Table Maintenance    Processing Area
    mx LoanIQ activate window    ${LIQ_BrowseProcessingArea_Window}
    ${FacilityProcessingAreaCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_BrowseProcessingArea_JavaTree}    ${sFacilityProcessingArea}%Code%value  
    Log     ${sFacilityProcessingArea} Facility Type Code is ${FacilityProcessingAreaCode}
    mx LoanIQ close window    ${LIQ_BrowseProcessingArea_Window} 
    [Return]    ${FacilityProcessingAreaCode}
    
Get Facility Owning Branch Code and Zone from Table Maintenance
    [Documentation]    This keyword gets the Table Maintenance Facility Owning Branch Code for the given Facility Processing Area Argument.
    ...                @author: hstone    11SEP2019    Initial create
    [Arguments]    ${sFacilityOwningBranch}
    Search in Table Maintenance    Branch
    mx LoanIQ activate window    ${LIQ_Branch_Window}
    ${FacilityOwningBranchCode}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Branch_Tree}    ${sFacilityOwningBranch}%Code%value
    ${FacilityTimeRegion}    Mx LoanIQ Store TableCell To Clipboard    ${LIQ_Branch_Tree}    ${sFacilityOwningBranch}%Time Region%value  
    Log     ${sFacilityOwningBranch} Facility Type Code is ${FacilityOwningBranchCode}
    mx LoanIQ close window    ${LIQ_Branch_Window} 
    [Return]    ${FacilityOwningBranchCode}    ${FacilityTimeRegion}
