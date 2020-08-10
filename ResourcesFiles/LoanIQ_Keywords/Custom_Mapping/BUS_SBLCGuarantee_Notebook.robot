*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Navigate Existing Standby Letters of Credit
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Navigate Existing Standby Letters of Credit    ${ARGUMENT_1}

BUS_Compute SBLC Issuance Fee Amount Per Cycle
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Compute SBLC Issuance Fee Amount Per Cycle    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Navigate To Fees On Lender Shares
    [Documentation]    This keyword is used to run the assigned low level keyword.
    ...    @author: ehugo    02JUN2020    - initial create

    Run Keyword    Navigate To Fees On Lender Shares
    
BUS_Create New Outstanding Select - SBLC
    [Documentation]   This keyword will create a new Outstanding Select
    ...    @author:Archana 11June20 - initial create
    ...    
    Run Keyword    Create New Outstanding Select - SBLC    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}
    
BUS_Verify Pricing Formula
    [Documentation]    This keyword will verify the Pricing Formula Defined in the Facility
    ...    @author:Archana 11June20 -initial create
    Run Keyword    Verify Pricing Formula    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
    
BUS_Add Banks 
    [Documentation]    This keyword will add a bank in the New SBLC Issuance 
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Add Banks    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Complete Workflow Items
    [Documentation]    This keyword will complete the initial work items in SBLC Issuance
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Complete Workflow Items    ${ARGUMENT_1}    ${ARGUMENT_2} 
    
BUS_Verify SBLC Issuance Status
    [Documentation]    This keyword will verify the SLBC Issuance Status 
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Verify SBLC Issuance Status    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    
    
BUS_Create New Outstanding Select
    [Documentation]   This keyword will create a new Outstanding Select 
    ...    @aunthor:Archana 11June20 - initial create
    Run Keyword    Create New Outstanding Select    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}    ${ARGUMENT_8}    ${ARGUMENT_9}  
    
BUS_Add Banks for Bilateral Deal with Multiple Risk Types
    [Documentation]    This keyword will add a bank in the New SBLC Issuance
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Add Banks for Bilateral Deal with Multiple Risk Types     ${ARGUMENT_1}   	 
    
BUS_Add Purpose
    [Documentation]    This keyword will add purpose in the New SBLC Issuance
    ...    @author:Archana 11June20 -initial create
    Run Keyword    Add Purpose    ${ARGUMENT_1}
    
BUS_Search for Deal
    [Documentation]    This keyword will search for a specific deal
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Search for Deal    ${ARGUMENT_1}
    
BUS_Navigate to SBLC Guarantee Notebook with Pending Status
    [Documentation]    This keyword navigates the User from Deal Notebook to the SBLC Guarantee Notebook with Pending Status.
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Navigate to SBLC Guarantee Notebook with Pending Status    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Verify SBLC in Work in Process
    [Documentation]    This keyword will verify the SBLC in Work in Process   
    ...    @author:Archana 11June20 -initial create
    Run Keyword    Verify SBLC in Work in Process    ${ARGUMENT_1}
    
BUS_Verify SBLC Issuance Status for Bilateral Deal with Multiple Risk Types 
    [Documentation]    This keyword will verify the SLBC Issuance Status  
    ...    @author:Archana 11June20 - initial create
    Run Keyword    Verify SBLC Issuance Status for Bilateral Deal with Multiple Risk Types    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}            

BUS_Search SBLC Guarantee Issuance
    [Documentation]    This keyword will verify the SLBC Issuance Status  
    ...    @author:dahijara    06JUL2020    - initial create

    Run Keyword    Search SBLC Guarantee Issuance    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}

BUS_Open SBLC Guarantee Notebook
    [Documentation]    This keyword will open the SBLC Guarantee Notebook via Deal Search.  
    ...    @author:clanding    27JUL2020    - initial create

    Run Keyword    Open SBLC Guarantee Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}

BUS_Navigate to Accrual Tab
    [Documentation]    This keyword will navigates the LIQ User to the SBLC Guarantee Accrual tab.  
    ...    @author:clanding    27JUL2020    - initial create

    Run Keyword    Navigate to Accrual Tab

BUS_Store Cycle Start Date, End Date, and Paid Fee
    [Documentation]    This keyword will save the Current Cycle Start Date, End Date, and Paid to Date values in Excel.  
    ...    @author:clanding    27JUL2020    - initial create

    Run Keyword    Store Cycle Start Date, End Date, and Paid Fee    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}

BUS_Compute Issuance Interest Payment Amount Per Cycle
    [Documentation]    This keyword will compute the first Projected Cycle Due of the Interest Payment and saves it to Excel.  
    ...    @author:clanding    27JUL2020    - initial create

    Run Keyword    Compute Issuance Interest Payment Amount Per Cycle    ${ARGUMENT_1}    ${ARGUMENT_2}

BUS_Validate SBLC Issuance Fee Per Cycle in Accrual Tab
    [Documentation]    This keyword will validate that the Computed SBLC Issuance Fee per Cycle is same as the Projected EOC accrual in Accrual tab.  
    ...    @author:clanding    27JUL2020    - initial create

    Run Keyword    Validate SBLC Issuance Fee Per Cycle in Accrual Tab    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}