*** Settings ***
Resource    ../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***

BUS_Open Existing Guarantee
    [Documentation]    This keyword is used to open the existing Guarantees
    ...    @author:Archana 17Jun20 - initial create
    Run Keyword    Open Existing Guarantee    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}
   
BUS_Select Standby Letters of Credit
    [Documentation]    This keyword is used to select the appropriate standby Letters of Credit
    ...    @author: Archana 17Jun20 - initial create
    Run Keyword    Select Standby Letters of Credit    ${ARGUMENT_1}    
    
BUS_Guaratee Draw
    [Documentation]    This keyword is used to select the Draw tab
    ...    @author:Archana  17Jun20 - initial create
    Run Keyword    Guaratee Draw    ${ARGUMENT_1}    
    
BUS_Draw Against Bank Guarantee
    [Documentation]    This keyword is used to Draw the amount against Bank Guarantee
    ...    @author:Archana    17Jun20 - initial create
    Run Keyword    Draw Against Bank Guarantee    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    
    
BUS_Navigate Notebook Workflow_GuaranteeDrawdown
    [Documentation]    This keyword navigates the Workflow tab of a Notebook, and does a specific transaction.
    ...    @author:Archana 17Jun20 - initial create
    Run Keyword    Navigate Notebook Workflow_GuaranteeDrawdown    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}
    
BUS_Complete Workflow Items_GuaranteeDrawdown
    [Documentation]    This keyword will complete the initial work items in Guarantee Drawdpwn
    ...    @author: Archana 17Jun20 - initial create
    Run Keyword    Complete Workflow Items_GuaranteeDrawdown    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Approve SBLC Guarantee Drawdown
    [Documentation]    This keyword will approve the Awaiting Approval - SBLC Guarantee Drawdown
    ...    @author: Archana 23Jun2020 - initial create
    Run Keyword    Approve SBLC Guarantee Drawdown    
    
BUS_Release SLBC GuaranteeDrawdown in Workflow
    [Documentation]    This keyword will release the SBLC Guarantee Drawdown in Workflow tab
    ...    @author: Archana 23Jun2020 - initial create
    Run Keyword    Release SLBC GuaranteeDrawdown in Workflow
    
BUS_Get UIValue On FacilityNotebook_PostDrawdown
    [Documentation]    This keyword is used to do fetch values of outstanding and Avial amount to draw
    ...    @author:Archana 23Jun2020  - initial create
    Run Keyword    Get UIValue On FacilityNotebook_PostDrawdown    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Get UIValue On FacilityNotebook
    [Documentation]    This keyword is used to do fetch values of outstanding and Avial amount to draw
    ...    @author:Archana 23Jun2020 - initial create
    Run Keyword    Get UIValue On FacilityNotebook    ${ARGUMENT_1}    ${ARGUMENT_2}
    
BUS_Validation on Facility Notebook  
    [Documentation]    This keyword is used to do validations of outstanding and Avial amount to draw
    ...    @author:Archana 23Jun2020 - initial create
    Run Keyword    Validation on Facility Notebook    ${ARGUMENT_1}    ${ARGUMENT_2}    ${ARGUMENT_3}    ${ARGUMENT_4}    ${ARGUMENT_5}    ${ARGUMENT_6}    ${ARGUMENT_7}