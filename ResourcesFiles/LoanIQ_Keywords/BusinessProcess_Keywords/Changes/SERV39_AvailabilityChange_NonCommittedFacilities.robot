*** Settings ***
Resource     ../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

Availability Change for Non Committed Facilities
    [Documentation]    This keyword performs an Availability change for an existing facility
    ...    @author: sahalder    13JUL2020    initial create
    [Arguments]    ${ExcelPath}
    
    ###LIQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    ###Facility Notebook###
    Verify If Facility Window Does Not Exist
    Navigate to Facility Notebook    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]
         
    ###Availability Change Transaction Notebook###
    ${Facility_CurrentCmt}    Add Availability Change and Fetch Current Facility Commitment Amount
    Write Data To Excel    SERV39_AvailabilityChange    Current_Commitment    &{ExcelPath}[rowid]    ${Facility_CurrentCmt}
    ${New_Commitment}    Add Changes in Availability Change General Tab    &{ExcelPath}[Change_Amount]    &{ExcelPath}[Comment]    ${Facility_CurrentCmt}    &{ExcelPath}[Adjustment(+/-)]
    Write Data To Excel    SERV39_AvailabilityChange    New_Commitment    &{ExcelPath}[rowid]    ${New_Commitment}
    
    ###Availability Change Notebook###
    Send to Approval Availability Change
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###WIP - Availability Change Notebook###
    Approve Availability Change    &{ExcelPath}[Deal_Name]
    
    ###Loan IQ Window###
    Logout from Loan IQ
    Login to Loan IQ    ${MANAGER_USERNAME}    ${MANAGER_PASSWORD}
    
    #WIP - Availability Change Notebook
    Release Availability Change    &{ExcelPath}[Deal_Name]
    
    #Facility Notebook
    Validate Availability Change    &{ExcelPath}[Deal_Name]    &{ExcelPath}[Facility_Name]    ${New_Commitment}