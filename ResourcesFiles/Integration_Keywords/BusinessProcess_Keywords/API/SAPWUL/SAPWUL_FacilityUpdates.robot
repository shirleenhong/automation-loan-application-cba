*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Update Facility Type Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates the Facility Type of the Facility then Approve and Release the transaction
    ...    @author: ehugo    16SEP2019    Initial create
    ...    @update: hstone    20SEP2019    Moved to SAPWUL High Level Keywords
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number
    ${sCustomerProfileType}    ${bPrimaryBorrower}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Update Facility Type in Facility Change Transaction    &{FacilityDataSet}[Facility_Type]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ

    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem}    Create List    ${sCustomerProfileType}    ${bPrimaryBorrower}    ${sCustomerID}  
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}
    
Update Multiple Fields of Facility Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates multiple fields (Facility Type, Owning Branch, Processing Area, Effective Date) of the Facility then Approve and Release the transaction
    ...    @author: ehugo    23SEP2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Update Multiple Fields of Facility in Facility Change Transaction    &{FacilityDataSet}[Facility_Type]    &{FacilityDataSet}[Facility_OwningBranch]    &{FacilityDataSet}[Facility_ProcessingArea]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}
    
Update Facility Name
    [Documentation]    This keyword updates multiple fields (Facility Type, Owning Branch, Processing Area, Effective Date) of the Facility then Approve and Release the transaction
    ...    @author: ehugo    23SEP2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sNewFacilityName}    Auto Generate Name Test Data    &{FacilityDataSet}[Facility_NamePrefix]
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   ${sFacilityRowID}    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number
    ${sCustomerProfileType}    ${bPrimaryBorrower}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event
    ${sFacilityID}    Get Business Event ID
    
    ### Rename Facility ###
    Write Data To Excel    FacilityData    Facility_Name    ${sFacilityRowID}    ${sNewFacilityName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sNewFacilityName}    ${SAPWUL_DATASET}
    ${sNewFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[rowid]    ${SAPWUL_DATASET}
    Rename Facility Name at Facility Notebook    ${sNewFacilityName}
    Close All Windows on LIQ
    
    Search Deal    ${sDealName}
    ${sCustomerID}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem}    Create List    ${sCustomerProfileType}    ${bPrimaryBorrower}    ${sCustomerID}    
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sNewFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${INPUTTER_USERNAME}    ${sCustomerExternalIdItem_List} 

Update Facility Primary Borrower Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates the Facility Primary Borrower then Approve and Release the transaction
    ...    @author: ehugo    24SEP2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Update Facility Primary Borrower in Facility Change Transaction    &{FacilityDataSet}[Facility_BorrowerUpdate]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    ${sCustomerID2}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_BorrowerUpdate]
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    ${sCustomerProfileType2}    ${bPrimaryBorrower2}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_BorrowerUpdate]
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem2}    Create List    ${sCustomerProfileType2}    ${bPrimaryBorrower2}    ${sCustomerID2} 
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}    ${sCustomerExternalIdItem2}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}
    
Delete Borrower Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword deletes a Borrower then Approve and Release the transaction
    ...    @author: ehugo    24SEP2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Delete Borrower in Facility Change Transaction    &{FacilityDataSet}[Facility_BorrowerUpdate]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}       
    
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}

Add Borrower Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword adds a Borrower then Approve and Release the transaction
    ...    @author: amansuet    24SEP2019    - initial create
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number    ## For Validation
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID    ## For Validation
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Add Borrower in Facility Change Transaction    &{FacilityDataSet}[Facility_BorrowerUpdate]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]    ## For Validation
    ${sCustomerID2}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_BorrowerUpdate]    ## For Validation
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    ${sCustomerProfileType2}    ${bPrimaryBorrower2}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_BorrowerUpdate]
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem2}    Create List    ${sCustomerProfileType2}    ${bPrimaryBorrower2}    ${sCustomerID2} 
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}    ${sCustomerExternalIdItem2}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}

Update Facility Owning Branch Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates Owning Branch of the Facility then Approve and Release the transaction
    ...    @author: hstone    26SEP2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Update Facility Owning Branch in Facility Change Transaction    &{FacilityDataSet}[Facility_OwningBranch]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
        ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}

Update Facility Processing Area Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates Processing Area of the Facility then Approve and Release the transaction
    ...    @author: hstone    26SEP2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Update Facility Processing Area in Facility Change Transaction    &{FacilityDataSet}[Facility_ProcessingArea]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}

Update Facility Effective Date Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates Effective Date of the Facility then Approve and Release the transaction
    ...    @author: hstone    26SEP2019    Initial create
    ...    @update: hstone    02OCT2019    Facility Effective Date Update on SAPWUL Test Data
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Update Facility Effective Date in Facility Change Transaction    &{FacilityDataSet}[Facility_EffectiveDate]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}
    
    ### Set Other Facility Updates ###
    ${sEffectiveDate}    Convert LIQ Date to Payload Date    &{FacilityDataSet}[Facility_EffectiveDate]    y-m-d
    ${sKey_List}    Create List    Payload_effectiveDate
    ${sVal_List}    Create List    ${sEffectiveDate}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}    ${sKey_List}    ${sVal_List}

Add Guarantor Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword adds a Guarantor then Approve and Release the transaction
    ...    @author: amansuet    25SEP2019    - initial create
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   ${sFacilityRowID}    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    ### Add Guarantor in Deal Notebook before Navigating to Facility Notebook ###
    Open Existing Deal    ${sDealName}
    Add Guarantor in Deal Notebook    &{FacilityDataSet}[Facility_Guarantor_NewGuarantor]    &{FacilityDataSet}[Facility_Guarantor_GuarantorType]    &{FacilityDataSet}[Facility_Guarantor_EffectiveDate]
    ...    &{FacilityDataSet}[Facility_Guarantor_ExpiryDate]    &{FacilityDataSet}[Facility_Guarantor_GlobalValue]
    Navigate to Facility Notebook from Deal Notebook    ${sFacilityName}
    
    ${sFacilityControlNumber}    Get Facility Control Number
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
        
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    ${CustomerID_Guarantor}    Get Customer ID from Active Guarantor Via Facility Notebook    &{FacilityDataSet}[Facility_Guarantor_NewGuarantor]
    Add Guarantor in Facility Change Transaction    &{FacilityDataSet}[Facility_Guarantor_NewGuarantor]    &{FacilityDataSet}[Facility_Guarantor_GuarantorType]    &{FacilityDataSet}[Facility_Guarantor_EffectiveDate]
    ...    &{FacilityDataSet}[Facility_Guarantor_ExpiryDate]    &{FacilityDataSet}[Facility_Guarantor_GlobalValue]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]    ## For Validation   ## For Validation
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    ${sCustomerProfileType2}    Set Variable    Guarantor
    ${bPrimaryBorrower2}    Set Variable    False
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem2}    Create List    ${sCustomerProfileType2}    ${bPrimaryBorrower2}    ${CustomerID_Guarantor}
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}    ${sCustomerExternalIdItem2}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}

Delete Guarantor Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword deletes a Guarantor then Approve and Release the transaction
    ...    @author: amansuet    25SEP2019    - initial create
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    ##PRE_REQUISITE##
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    Add Facility Change Transaction
    Add Guarantor in Facility Change Transaction    &{FacilityDataSet}[Facility_Guarantor_NewGuarantor]    &{FacilityDataSet}[Facility_Guarantor_GuarantorType]    &{FacilityDataSet}[Facility_Guarantor_EffectiveDate]
    ...    &{FacilityDataSet}[Facility_Guarantor_ExpiryDate]    &{FacilityDataSet}[Facility_Guarantor_GlobalValue]
    Navigate Notebook Workflow    ${LIQ_FacilityChangeTransaction_Window}    ${LIQ_FacilityChangeTransaction_Tab}    ${LIQ_FacilityChangeTransaction_Worflow_Tab}    Send to Approval
    Close All Windows on LIQ
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    Logout From Loan IQ
    ##END OF PRE-REQUISITE##
    
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 

    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number

    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
        
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    ${CustomerID_Guarantor}    Get Customer ID from Active Guarantor Via Facility Notebook    &{FacilityDataSet}[Facility_Guarantor_ExistingGuarantor]
    Delete Guarantor in Facility Change Transaction    &{FacilityDataSet}[Facility_Guarantor_NewGuarantor]
    Close All Windows on LIQ
    Navigate Transaction in WIP    Facilities    Awaiting Send to Approval    Facility Change Transaction    ${sDealName}
    Navigate Notebook Workflow    ${LIQ_FacilityChangeTransaction_Window}    ${LIQ_FacilityChangeTransaction_Tab}    ${LIQ_FacilityChangeTransaction_Worflow_Tab}    Send to Approval
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]    ## For Validation   ## For Validation
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    ${sCustomerProfileType2}    Set Variable    Guarantor
    ${bPrimaryBorrower2}    Set Variable    False
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}
    ${sCustomerExternalIdItem2}    Create List    ${sCustomerProfileType2}    ${bPrimaryBorrower2}    ${CustomerID_Guarantor}
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}    ${sCustomerExternalIdItem2}

    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}

Add New facility or Unscheduled Increase
    [Documentation]    This keyword Adds New facility or Unscheduled Increase and payload is generated successfully
    ...    @author: ehugo    25SEP2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sPrimaryPortfolio}    Read Data From Excel    DealData    Primary_Portfolio   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sExpenseCode}    Read Data From Excel    DealData    Deal_ExpenseCode   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    ###Get Expense Description in Table Maintenance###
    ${Expense_Description}    Get Expense Description in Table Maintenance    ${sExpenseCode}
    
    ###Add New Facility###
    Open Existing Deal    ${sDealName}
    ${sNew_FacilityName}    Auto Generate Name Test Data    &{FacilityDataSet}[Facility_NamePrefix]    
    Write Data To Excel    FacilityData    New_FacilityName    &{FacilityDataSet}[rowid]    ${sNew_FacilityName}    ${SAPWUL_DATASET}
    ${sNew_FacilityName}    Read Data From Excel    FacilityData    New_FacilityName   &{FacilityDataSet}[rowid]    ${SAPWUL_DATASET}
    Add New Facility without Facility Cmt Amt    ${sDealName}    &{FacilityDataSet}[Deal_Currency]    ${sNew_FacilityName}    &{FacilityDataSet}[Facility_Type]    &{FacilityDataSet}[Facility_Currency]
    
    Set Specific Facility Dates    &{FacilityDataSet}[Facility_AgreementDate]    ${EMPTY}    &{FacilityDataSet}[Facility_ExpiryDate]    &{FacilityDataSet}[Facility_MaturityDate]
    Set Facility Risk Type    &{FacilityDataSet}[Facility_RiskType]
    Set Facility Loan Purpose Type    &{FacilityDataSet}[Facility_LoanPurposeType]
    Add Borrower    &{FacilityDataSet}[Borrower_Currency]    &{FacilityDataSet}[Facility_BorrowerSGName]    &{FacilityDataSet}[Facility_BorrowerPercent]    &{FacilityDataSet}[Facility_Borrower]
    ...    &{FacilityDataSet}[Facility_GlobalLimit]    &{FacilityDataSet}[Facility_BorrowerMaturity]
    
    mx LoanIQ activate window    ${LIQ_FacilityNotebook_Window}
    Select Menu Item    ${LIQ_FacilityNotebook_Window}    File    Save
    mx LoanIQ click element if present    ${LIQ_Warning_Yes_Button}
    Close All Windows on LIQ
    Open Existing Deal    ${sDealName}
    
    ###Create Amendment###
    ${sEffectiveDate}    Get System Date on LIQ and Return Value
    ${sAmendmentNumber_Prefix}    Set Variable    U
    ${sComment}    Set Variable    SAPWUL Update 08 ${sEffectiveDate}
    ${sNew_TransactionAmount}    Set Variable    100000
    ${sNew_PercentOfCurrentBalance}    Set Variable    0.0000%
    ${AmendmentNumber}    Create New Transaction for Amendment to Add New facility or Unscheduled Increase    ${sNew_FacilityName}    ${sAmendmentNumber_Prefix}    ${sEffectiveDate}    ${sComment}    ${sNew_TransactionAmount}    ${sNew_PercentOfCurrentBalance}
    ...    &{FacilityDataSet}[Facility_MaturityDate]    ${sDealName}    &{FacilityDataSet}[Facility_Customer]    ${sExpenseCode}    ${Expense_Description}
    
    Write Data To Excel    FacilityData    Sapwul_Event    &{FacilityDataSet}[rowid]    Amendment Released No. ${AmendmentNumber}    ${SAPWUL_DATASET}
    ${Sapwul_Event}    Read Data From Excel    FacilityData    Sapwul_Event   &{FacilityDataSet}[rowid]    ${SAPWUL_DATASET}
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD}
    
    Navigate to Facility Notebook    ${sDealName}    ${sNew_FacilityName}
    ${sEffective_Date}    Get Facility Effective Date
    ${sFacilityControlNumber}    Get Facility Control Number
    ${sCustomerProfileType}    ${bPrimaryBorrower}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    ${sKey_List}    Create List    Payload_effectiveDate
    ${sVal_List}    Create List    ${sEffectiveDate}
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
    
    ${sCustomerID}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem}    Create List    ${sCustomerProfileType}    ${bPrimaryBorrower}    ${sCustomerID}   
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem}    ${sKey_List}    ${sVal_List}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    ${Sapwul_Event}    &{FacilityDataSet}[Sapwul_RowId]    ${sNew_FacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}

Replace Guarantor Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword deletes a Guarantor then Approve and Release the transaction
    ...    @author: amansuet    25SEP2019    - initial create
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number

    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID
        
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    ${CustomerID_Guarantor}    Get Customer ID from Active Guarantor Via Facility Notebook    &{FacilityDataSet}[Facility_Guarantor_NewGuarantor]
    Replace Guarantor in Facility Change Transaction    &{FacilityDataSet}[Facility_Guarantor_ExistingGuarantor]    &{FacilityDataSet}[Facility_Guarantor_NewGuarantor]    &{FacilityDataSet}[Facility_Guarantor_GuarantorType]    &{FacilityDataSet}[Facility_Guarantor_EffectiveDate]
    ...    &{FacilityDataSet}[Facility_Guarantor_ExpiryDate]    &{FacilityDataSet}[Facility_Guarantor_GlobalValue]
    Close All Windows on LIQ
    Navigate Transaction in WIP    Facilities    Awaiting Send to Approval    Facility Change Transaction    ${sDealName}
    Navigate Notebook Workflow    ${LIQ_FacilityChangeTransaction_Window}    ${LIQ_FacilityChangeTransaction_Tab}    ${LIQ_FacilityChangeTransaction_Worflow_Tab}    Send to Approval
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]    ## For Validation   ## For Validation
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    ${sCustomerProfileType2}    Set Variable    Guarantor
    ${bPrimaryBorrower2}    Set Variable    False
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem2}    Create List    ${sCustomerProfileType2}    ${bPrimaryBorrower2}    ${CustomerID_Guarantor}
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}    ${sCustomerExternalIdItem2}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    ${sFacilityName}    ${sFacilityID}    
    ...    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}

Decrease Facility Commitment Amount
    [Documentation]    This keyword creates an ammendment for unscheduled commitment amount decrease.
    ...    @author: hstone    21OCT2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    
    Open Existing Deal    ${sDealName}
 
    ### Create Amendment ###
    ${sEffectiveDate}    Get System Date on LIQ and Return Value
    ${sAmendmentNumber_Prefix}    Set Variable    &{FacilityDataSet}[FacilityAmd_Prefix]
    ${sComment}    Set Variable    SAPWUL Update 08 ${sEffectiveDate}
    ${sNew_TransactionAmount}    Set Variable    100000
    ${sNew_PercentOfCurrentBalance}    Set Variable    10.0000%
    ${sAmd_Comment}    Set Variable    &{FacilityDataSet}[Test_Case] Ammendment
    Create New Transaction for Amendment    &{FacilityDataSet}[Facility_Name]    Unscheduled Commitment Decrease    ${sAmendmentNumber_Prefix}    
    ...    ${sEffectiveDate}    ${sAmd_Comment}    ${sNew_TransactionAmount}    ${sNew_PercentOfCurrentBalance}    ${sDealName}

Replace Borrower Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword deletes an existing Borrower and adds a new Borrower then Approve and Release the transaction
    ...    @author: amansuet    21OCT2019    - initial create
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}

    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sFacilityControlNumber}    Get Facility Control Number    ## For Validation
    
    ### Events Tab: Get Facility ID ###
    Navigate to Facility Business Event    Created
    ${sFacilityID}    Get Business Event ID    ## For Validation
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Replace Borrower in Facility Change Transaction    &{FacilityDataSet}[Facility_Borrower]    &{FacilityDataSet}[Facility_BorrowerUpdate]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}  
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Search Deal    ${sDealName}
    ${sCustomerID1}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]    ## For Validation
    ${sCustomerID2}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_BorrowerUpdate]    ## For Validation
    Close All Windows on LIQ
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    ${sCustomerProfileType2}    ${bPrimaryBorrower2}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_BorrowerUpdate]
    Close All Windows on LIQ
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem1}    Create List    ${sCustomerProfileType1}    ${bPrimaryBorrower1}    ${sCustomerID1}  
    ${sCustomerExternalIdItem2}    Create List    ${sCustomerProfileType2}    ${bPrimaryBorrower2}    ${sCustomerID2} 
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem1}    ${sCustomerExternalIdItem2}

    ### SAPWUL Data Save ###
    Run Keyword If    '&{FacilityDataSet}[Facility_ExistsAtPayload]'=='Y'    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]
    ...    ${sFacilityName}    ${sFacilityID}    ${sFacilityControlNumber}    ${SUPERVISOR_USERNAME}    ${sCustomerExternalIdItem_List}

Terminate future dated facility
    [Documentation]    This keyword verifies that future dated facility cannot be terminated
    ...    @author: fmamaril    30OCT2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    Add Facility Change Transaction
    Input Future Termination Effective Date in Facility Change Transaction
    
Update Facility Status from Expired to Active Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates Facility Status from Expired to Active then Approve and Release the transaction
    ...    @author: amansuet    25OCT2019    - initial create
    ...    @update: amansuet    05NOV2019    - updated
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}

    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    
    ### Validate if Facility Status is Expired ###
    Validate Facility Status    ${sFacilityName}    Expired
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facility Change Transaction Window###
    Set New Value of Dates under General Tab in Facility Change Transaction    Expiry Date    &{FacilityDataSet}[Facility_ExpiryDate]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    
    ### Validate if Facility Status is Set to Active ###
    Validate Facility Status    ${sFacilityName}    Active
    
    Close All Windows on LIQ
    
Update Facility Status from Active to Expired Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates Facility Status from Active to Expired then Approve and Release the transaction
    ...    @author: amansuet    05NOV2019    - initial create
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}

    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    
    ### Validate if Facility Status is Expired ###
    Validate Facility Status    ${sFacilityName}    Active
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facility Change Transaction Window###
    Set New Value of Dates under General Tab in Facility Change Transaction    Expiry Date    &{FacilityDataSet}[Facility_ExpiryDate]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    
    ### Validate if Facility Status is Set to Active ###
    Validate Facility Status    ${sFacilityName}    Expired
    
    Close All Windows on LIQ
    
Update Facility Status from Active to Matured Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates Facility Status from Active to Matured then Approve and Release the transaction
    ...    @author: amansuet    05NOV2019    - initial create
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}

    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    
    ### Validate if Facility Status is Expired ###
    Validate Facility Status    ${sFacilityName}    Active
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Set New Value of Dates under General Tab in Facility Change Transaction    Expiry Date    &{FacilityDataSet}[Facility_ExpiryDate]
    Set New Value of Dates under General Tab in Facility Change Transaction    Maturity Date    &{FacilityDataSet}[Facility_MaturityDate]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    
    ### Validate if Facility Status is Set to Active ###
    Validate Facility Status    ${sFacilityName}    Matured
    
    Close All Windows on LIQ
    
Update Facility Status from Matured to Active Then Approve and Release the Facility Change Transaction
    [Documentation]    This keyword updates Facility Status from Matured to Active then Approve and Release the transaction
    ...    @author: amansuet    05NOV2019    - initial create
    [Arguments]    ${FacilityDataSet}
    
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}

    Write Data To Excel    FacilityData    Deal_Name    &{FacilityDataSet}[rowid]    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    &{FacilityDataSet}[rowid]    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    
    ### Validate if Facility Status is Expired ###
    Validate Facility Status    ${sFacilityName}    Matured
    
    ###Facility Window###
    Add Facility Change Transaction
    
    ###Facilty Change Transaction Window###
    Set New Value of Dates under General Tab in Facility Change Transaction    Maturity Date    &{FacilityDataSet}[Facility_MaturityDate]    
    Set New Value of Dates under General Tab in Facility Change Transaction    Expiry Date    &{FacilityDataSet}[Facility_ExpiryDate]
    Send to Approval Facility Change Transaction
    Close All Windows on LIQ
    
    ###Logout LIQ and Login as Approver###
    Logout From Loan IQ
    Login to Loan IQ    ${SUPERVISOR_USERNAME}    ${SUPERVISOR_PASSWORD}
    
    ###Approve and Release Facility Change Transaction###
    Approve Facility Change Transaction    ${sDealName}
    Close All Windows on LIQ
    Release Facility Change Transaction    ${sDealName}
    
    Logout From Loan IQ
    Login to Loan IQ    ${INPUTTER_USERNAME}    ${INPUTTER_PASSWORD} 
    
    Navigate to Facility Notebook    ${sDealName}    ${sFacilityName}
    
    ### Validate if Facility Status is Set to Active ###
    Validate Facility Status    ${sFacilityName}    Active
    
    Close All Windows on LIQ
    
Create Deal Amendment - Unscheduled Commitment Increase
    [Documentation]    This keyword extends the facility expiration/maturity dates thru deal amendment
    ...    @author: hstone    12DEC2019    Initial create
    [Arguments]    ${FacilityDataSet}
    ${sDealName}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityRowID}    Read Data From Excel    DealData    Deal_FacilityRowID1   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${sFacilityName}    Read Data From Excel    FacilityData    Facility_Name   ${sFacilityRowID}    ${SAPWUL_DATASET}
    
    Write Data To Excel    FacilityData    Deal_Name    ${sFacilityRowID}    ${sDealName}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_Name    ${sFacilityRowID}    ${sFacilityName}    ${SAPWUL_DATASET}
    
    Open Existing Deal    ${sDealName}
 
    ### Create Amendment ###
    ${sEffectiveDate}    Get System Date on LIQ and Return Value
    ${sAmendmentNumber_Prefix}    Set Variable    U
    ${sComment}    Set Variable    &{FacilityDataSet}[Test_Case]_${sEffectiveDate}
    ${sAmd_Comment}    Set Variable    &{FacilityDataSet}[Test_Case]_Unscheduled Commitment Increase
    Create Unscheduled Commitment Increase    &{FacilityDataSet}[Facility_Name]    Unscheduled Commitment Increase    ${sAmendmentNumber_Prefix}    
    ...    ${sEffectiveDate}    ${sAmd_Comment}    &{FacilityDataSet}[Facility_NewTransAmt]    &{FacilityDataSet}[Facility_NewPercentOfCurBal]    ${sDealName}

Get SAPWUL Facility Payload Data
    [Documentation]    This keyword gets the Facility Data for the needed for making expected SAPWUL Payload JSON Files.
    ...                @author: hstone    14JAN2020    Initial create
    [Arguments]    ${FacilityDataSet}
    Open Existing Deal    &{FacilityDataSet}[Deal_Name]

    ### Summary Tab: Get Customer ID ###
    ${CustomerID}    Get Customer ID from Active Customer Notebook Via Deal Notebook    &{FacilityDataSet}[Facility_Borrower]
    
    Open Facility Notebook      &{FacilityDataSet}[Facility_Name]

    ### Summary Tab: Facility Data ###
    ${FacilityControlNumber}    Get Facility Control Number
    ${FacilityType}    Get Facility Type
    ${FacilityOwningBranch}    Get Facility Owning Branch
    ${FacilityProcessingArea}    Get Facility Processing Area
    Take Screenshot    FacilityNotebook_Summary Tab
    
    ### Sublimit/Cust Tab: Get Facility Borrower  Details ###
    ${sCustomerProfileType}    ${bPrimaryBorrower}    Get Borrower Details From Facility Notebook    &{FacilityDataSet}[Facility_Borrower]
    Take Screenshot    FacilityNotebook_Sublimit and Cust Tab
    
    ### Events Tab: Get Facility ID ###
    ${FacilityTerminationDate}     Get Facility Event Effective Date    Terminated
    Navigate to Facility Business Event    Terminated
    ${FacilityID}    Get Business Event ID
    Take Screenshot    FacilityNotebook_EventsTab

    ### Set Other Facility Updates ###
    ${sEffectiveDate}    Convert LIQ Date to Payload Date    &{FacilityDataSet}[Facility_EffectiveDate]    y-m-d
    ${sTerminationDate}    Convert LIQ Date to Payload Date    ${FacilityTerminationDate}    y-m-d
    ${sKey_List}    Create List    Payload_effectiveDate    Payload_terminationDate
    ${sVal_List}    Create List    ${sEffectiveDate}    ${sTerminationDate} 
    
    ### Create Customer External ID Item and Customer External ID List ###
    ${sCustomerExternalIdItem}    Create List    ${sCustomerProfileType}    ${bPrimaryBorrower}    ${CustomerID}    
    ${sCustomerExternalIdItem_List}    Create Customer External ID List    ${sCustomerExternalIdItem}
    
    ### Facility Data Save ###
    Write Data To Excel    FacilityData    Facility_Type    &{FacilityDataSet}[rowid]    ${FacilityType}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_OwningBranch    &{FacilityDataSet}[rowid]    ${FacilityOwningBranch}    ${SAPWUL_DATASET}
    Write Data To Excel    FacilityData    Facility_ProcessingArea    &{FacilityDataSet}[rowid]    ${FacilityProcessingArea}    ${SAPWUL_DATASET}
       
    ### SAPWUL Data Save ###
    Set SAPWUL Test Data    &{FacilityDataSet}[Sapwul_Event]    &{FacilityDataSet}[Sapwul_RowId]    &{FacilityDataSet}[Facility_Name]    ${FacilityID}    
    ...    ${FacilityControlNumber}    ${INPUTTER_USERNAME}    ${sCustomerExternalIdItem_List}    ${sKey_List}    ${sVal_List} 