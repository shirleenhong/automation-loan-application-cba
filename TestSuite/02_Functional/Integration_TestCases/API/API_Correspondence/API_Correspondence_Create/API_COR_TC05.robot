*** Settings ***
Resource    ../../../../../../Configurations/LoanIQ_Import_File.robot

*** Test Cases ***
API_COR_TC05
    [Tags]    API_COR_TC05
	[Documentation]    API_COR_TC05 Ensure that user is able to successfully sent out a FEE PAYMENT NOTICE for BILATERAL Deal via WIP
    ...    Pre-Req: Commitment Fee Payment Test Case (Bilateral Deal)
    ...    Pre-Req in API_Data_Set: Deal_Name, Facility_Name
    ...    @author: mgaling
    Set Test Variable    ${rowid}    5    
    Mx Execute Template With Multiple Data    Send a SENT Callback for Notice for BILATERAL Deal via WIP   ${APIDataSet}    ${rowid}    Correspondence
