*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Enter Upfront Fee Distribution Details
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: sahalder    08JUN2020    - initial create

    Run Keyword   Enter Upfront Fee Distribution Details    ${ARGUMENT_1}    ${ARGUMENT_2}
    

BUS_Increase Or Decrease Schedule 
    [Documentation]    This keyword is used to navigate to Uncheduled commitment decrease notebook
    ...    @author: Archana 07Jul2020
    Run Keyword    Increase Or Decrease Schedule
    
BUS_Amortization Schedule for Facility
    [Documentation]    This keyword is used to add Amoetization Schedule for Facility
    ...    @author: Archana 07Jul2020
    Run Keyword    Amortization Schedule for Facility
    
BUS_Add Schedule Item
    [Documentation]    This keyword is used to add Schedule Item
    ...    @author: Archana 07Jul2020
    Run Keyword    Add Schedule Item    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Add Amortization Schedule Status
    [Documentation]    This keyword is used to add amortization status
    ...    @author: Archana 07Jul2020
    Run Keyword    Add Amortization Schedule Status    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Modify Schedule
    [Documentation]    This keyword is used to Modify Schedule
    ...    @author: Archana 07Jul2020
    Run Keyword    Modify Schedule
    
BUS_Create Pending Transaction
    [Documentation]    This keyword is used to create Pending Transaction
    ...    @author:Archana 07Jul2020
    Run Keyword    Create Pending Transaction    ${ARGUMENT_1}
    
BUS_Create Transaction Notice
    [Documentation]    This keyword is used to create Transaction Notice
    ...    @author: Archana 07Jul2020
    Run Keyword    Create Transaction Notice    ${ARGUMENT_1}
    
BUS_Update Lender Shares
    [Documentation]    This keyword is used to update Lender Shares
    ...    @author:Archana 07Jul2020
    Run Keyword    Update Lender Shares    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}
    
BUS_Send to Approval Unscheduled Commitment Decrease
    [Documentation]    This keyword sends the Unscheduled Commitment Decrease Transaction for approval
    ...    @author: Archana 07Jul2020
    Run Keyword    Send to Approval Unscheduled Commitment Decrease    
    
BUS_Approve Unscheduled Commitment Decrease
    [Documentation]    This keyword will approve the Awaiting Approval - Unscheduled Commitment Decrease
    ...    @author: Archana 07Jul2020
    Run Keyword    Approve Unscheduled Commitment Decrease    
    
BUS_Release Pending Unscheduled Commitment Decrease in Workflow
    [Documentation]    This keyword will approve the Awaiting Release - Unscheduled Commitment Decrease
    ...    @author: Archana 07Jul2020
    Run Keyword    Release Pending Unscheduled Commitment Decrease in Workflow
    
BUS_Release Unscheduled Commitment Decrease in Workflow
    [Documentation]    This keyword will release the Unscheduled Commitment Decrease in Workflow Tab
    ...    @author:Archana 07Jul2020
    Run Keyword    Release Unscheduled Commitment Decrease in Workflow
    
BUS_Validation on Commitment Decrease Schedule
    [Documentation]    This keyword is used to validate the Commitment decrease Schedule
    ...    @author:Archana 07Jul2020
    Run Keyword    Validation on Commitment Decrease Schedule    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}      