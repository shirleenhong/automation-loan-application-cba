*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Verify if Standby Letters of Credit Exist
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Verify if Standby Letters of Credit Exist    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Set Up Existing Letters of Credit Settings for SBLC Decrease
    [Documentation]    This keyword modifies the settings in Existing Letter of Credit Window in preparation for SBLC decrease
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Set Up Existing Letters of Credit Settings for SBLC Decrease    ${ARGUMENT_1}
    
BUS_Populate Bank Guarantee/Letter of Credit/Synd Fronted Bank Decrease Fields
    [Documentation]    This keyword populates the fields from Pending SBLC Decrease window
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Populate Bank Guarantee/Letter of Credit/Synd Fronted Bank Decrease Fields    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Validate View/Update Lender Shares Details
    [Documentation]    This keyword verifies the Requested Amount and New Balance values in Lender Shares Details
    ...    @author:Archana 11june20 - initial create
    Run Keyword    Validate View/Update Lender Shares Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    
BUS_Validate View/Update Issuing Bank Shares Details
    [Documentation]    This keyword verifies the Requested Amount and New Balance values in Issuing Bank Shares Details
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Validate View/Update Issuing Bank Shares Details    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Send SBLC Decrease for Approval
    [Documentation]    This keyword is used to send the SBLC Decrease for approval
    ...    @author:clanding    27JUL2020    - initial create
    
    Run Keyword    Send SBLC Decrease for Approval

BUS_Approve SBLC Decrease
    [Documentation]    This keyword is used to approve the SBLC Decrease from Workflow items
    ...    @author:clanding    27JUL2020    - initial create
    
    Run Keyword    Approve SBLC Decrease

BUS_Release SBLC Decrease
    [Documentation]    This keyword is used to release the SLBC Decrease from Workflow Items
    ...    @author:clanding    27JUL2020    - initial create
    
    Run Keyword    Release SBLC Decrease