*** Settings ***
Resource    ../../../../../Configurations/LoanIQ_Import_File.robot

*** Keywords ***
Clear SAPWUL Data
    [Documentation]    This keyword clears the test data for the SAPWUL Payload
    ...                @author: hstone    03SEP2019    Initial create
    ...                @update: hstone    16JAN2020    Added Payload_terminationDate clear at SAPWUL Data Set
    [Arguments]    ${SAPWULPayloadDataSet} 
    Clear SAPWUL Cell Data    SAPWUL_Payload    &{SAPWULPayloadDataSet}[rowid]    Payload_facilityName    Payload_facilityTypeCode    Payload_facilityControlNumber
    ...    Payload_owningBranchCode    Payload_processingAreaCode    Payload_customerExternalID    Internal_facilityId    Internal_userId    Internal_zone
    ...    Payload_terminationDate
    
    ${OtherPayloadVal_Clear_Data}    Set Variable    &{SAPWULPayloadDataSet}[OtherPayloadVal_Clear]
    Run Keyword If    '${OtherPayloadVal_Clear_Data}'!='-'    Clear Other Specified SAPWUL Cell Data    SAPWUL_Payload    &{SAPWULPayloadDataSet}[rowid]    ${OtherPayloadVal_Clear_Data}         

Clear SAPWUL Data for Active Facility Payload
    [Documentation]    This keyword clears the test data for the SAPWUL Payload with an active facility.
    ...                @author: hstone    16SEP2019    Initial create
    [Arguments]    ${rowid}
    Clear SAPWUL Cell Data    SAPWUL_Payload    ${rowid}    Payload_facilityName    Payload_facilityTypeCode    Payload_facilityControlNumber
    ...    Payload_owningBranchCode    Payload_processingAreaCode    Payload_customerExternalID    Internal_facilityId    Internal_userId    Internal_zone

Clear SAPWUL Data for Terminated Facility Payload
    [Documentation]    This keyword clears the test data for the SAPWUL Payload with a terminated facility.
    ...                @author: hstone    16SEP2019    Initial create
    [Arguments]    ${rowid}
    Clear SAPWUL Cell Data    SAPWUL_Payload    ${rowid}    Payload_facilityName    Payload_facilityTypeCode    Payload_facilityControlNumber
    ...    Payload_owningBranchCode    Payload_processingAreaCode    Payload_customerExternalID    Internal_facilityId    Internal_userId    Internal_zone
    ...    Payload_effectiveDate    Payload_terminationDate
         
Set Facility Data Payload Values in Reference to Table Maintenance
    [Documentation]    This keyword is used to prepare Facility Data Json Values based on the Table Maintenance Mapping Values.
    ...                @author: hstone    10SEP2019    Initial create
    [Arguments]    ${FacilityDataSet}
    Open Table Maintenance
    ${FacilityTypeCode}    Get Facility Type Code from Table Maintenance    &{FacilityDataSet}[Facility_Type]
    ${FacilityProcessingAreaCode}    Get Facility Processing Area Code from Table Maintenance    &{FacilityDataSet}[Facility_ProcessingArea]
    ${FacilityOwningBranchCode}    ${FacilityZone}    Get Facility Owning Branch Code and Zone from Table Maintenance    &{FacilityDataSet}[Facility_OwningBranch]
    Close Table Maintenance
    
    Set SAPWUL Data to Excel    SAPWUL_Payload    Payload_facilityTypeCode    &{FacilityDataSet}[Sapwul_RowId]    ${FacilityTypeCode}
    Set SAPWUL Data to Excel    SAPWUL_Payload    Payload_processingAreaCode    &{FacilityDataSet}[Sapwul_RowId]    ${FacilityProcessingAreaCode}  
    Set SAPWUL Data to Excel    SAPWUL_Payload    Payload_owningBranchCode    &{FacilityDataSet}[Sapwul_RowId]    ${FacilityOwningBranchCode}  
    Set SAPWUL Data to Excel    SAPWUL_Payload    Internal_zone    &{FacilityDataSet}[Sapwul_RowId]    ${FacilityZone} 
    
Create Payload Expected JSON Files
    [Documentation]    This keyword is used to prepare the payload expected JSON File/s.
    ...    @author: hstone    03SEP2019    Initial create
    ...    @update: rtarayao    19FEB202    - updated the conditional logic to handle single or multiple active status.
    [Arguments]    ${SAPWULPayloadDataSet}
    ${sPayloadStatus}    Set Variable    &{SAPWULPayloadDataSet}[Payload_status]
    
    ${JsonDictionary_List}    Run Keyword If    "${sPayloadStatus}"=="Terminated"   Create SAPWUL JSON Dictionary for Terminated Facility       ${SAPWULPayloadDataSet}
    ...    ELSE    Create SAPWUL JSON Dictionary for Active Facility        ${SAPWULPayloadDataSet}
    
    ${JsonDictionary_List}    Add SAPWUL JSON Nested List    ${JsonDictionary_List}    customerExternalID    
    ...    &{SAPWULPayloadDataSet}[customerExternalID_keys]    &{SAPWULPayloadDataSet}[Payload_customerExternalID]
    
    ${JsonDictionary_List}    Add SAPWUL JSON Nested Dictionary    ${JsonDictionary_List}    internal    &{SAPWULPayloadDataSet}[internal_keys]    &{SAPWULPayloadDataSet}[Internal_userType]    
    ...    &{SAPWULPayloadDataSet}[Internal_facilityId]    &{SAPWULPayloadDataSet}[Internal_userId]    &{SAPWULPayloadDataSet}[Internal_eventDescription]    &{SAPWULPayloadDataSet}[Internal_zone]    
    
    ### JSON Save Routine ###
    Save Dictionary to JSON File    ${JsonDictionary_List}    ${SAPWUL_EXPECTEDJSON_PATH}    &{SAPWULPayloadDataSet}[Test_Case]
    Save Dictionary List Items to Individual JSON File    ${JsonDictionary_List}    ${SAPWUL_EXPECTEDJSON_PATH}    ${SAPWUL_FILENAME_PREFIX}    facilityName    

Create SAPWUL JSON Dictionary for Active Facility
    [Documentation]    This keyword is used to prepare the sapwul json dictionary for an active facility.
    ...                @author: hstone    15JAN2020    Initial create
    [Arguments]    ${SAPWULPayloadDataSet}
    ${JsonDictionary_List}    Create SAPWUL JSON Dictionary    &{SAPWULPayloadDataSet}[Payload_keys]    facilityName    &{SAPWULPayloadDataSet}[Payload_action]    
    ...    &{SAPWULPayloadDataSet}[Payload_facilityName]    &{SAPWULPayloadDataSet}[Payload_facilityTypeCode]    &{SAPWULPayloadDataSet}[Payload_facilityControlNumber]    
    ...    &{SAPWULPayloadDataSet}[Payload_owningBranchCode]    &{SAPWULPayloadDataSet}[Payload_processingAreaCode]    &{SAPWULPayloadDataSet}[Payload_effectiveDate]    
    ...    &{SAPWULPayloadDataSet}[Payload_status]    &{SAPWULPayloadDataSet}[Payload_hasExposure]
    [Return]    ${JsonDictionary_List}

Create SAPWUL JSON Dictionary for Terminated Facility
    [Documentation]    This keyword is used to prepare the sapwul json dictionary for a terminated facility.
    ...                @author: hstone    15JAN2020    Initial create
    [Arguments]    ${SAPWULPayloadDataSet}
    ${JsonDictionary_List}    Create SAPWUL JSON Dictionary    &{SAPWULPayloadDataSet}[Payload_keys]    facilityName    &{SAPWULPayloadDataSet}[Payload_action]    
    ...    &{SAPWULPayloadDataSet}[Payload_facilityName]    &{SAPWULPayloadDataSet}[Payload_facilityTypeCode]    &{SAPWULPayloadDataSet}[Payload_facilityControlNumber]    
    ...    &{SAPWULPayloadDataSet}[Payload_owningBranchCode]    &{SAPWULPayloadDataSet}[Payload_processingAreaCode]    &{SAPWULPayloadDataSet}[Payload_effectiveDate]    
    ...    &{SAPWULPayloadDataSet}[Payload_status]    &{SAPWULPayloadDataSet}[Payload_hasExposure]     &{SAPWULPayloadDataSet}[Payload_terminationDate]
    [Return]    ${JsonDictionary_List}

Verify Deal Event XML
    [Documentation]    This keyword verifies XML Section Details of the Deal Event
    ...                @author: hstone    18SEP2019    Initial create
    [Arguments]    ${DealDataSet} 
    Close All Windows on LIQ
    ${hasSapwulEvent}    Set Variable    &{DealDataSet}[Sapwul_Event]
    ${hasTrigger}    Set Variable     &{DealDataSet}[Sapwul_hasTrigger]
    Navigate to Deal Business Event    &{DealDataSet}[Deal_Name]    &{DealDataSet}[Sapwul_Event]
    
    Run Keyword If    '${hasSapwulEvent}'=='None' or '${hasTrigger}'=='N'    Validate NO SAPWUL Related Trigger Business Events
    ...    ELSE   Run Keywords
    ...    Validate SAPWUL Related Trigger on Business Events
    ...    AND    Validate Business Event XML Section Details    ${SAPWUL_EXPECTEDJSON_PATH}    &{DealDataSet}[Test_Case]   
    
    Close All Windows on LIQ

Verify Facility Event XML
    [Documentation]    This keyword verifies XML Section Details of the Facility Event
    ...                @author: hstone    18SEP2019    Initial create
    [Arguments]    ${FacilityDataSet}
    Close All Windows on LIQ
    ${Deal_Name}    Read Data From Excel    DealData    Deal_Name   &{FacilityDataSet}[Deal_RowID]    ${SAPWUL_DATASET}
    ${hasSapwulTrigger}    Set Variable    &{FacilityDataSet}[Sapwul_Event] 
    Navigate to Facility Notebook    ${Deal_Name}    &{FacilityDataSet}[Facility_Name]
    Navigate to Facility Business Event    &{FacilityDataSet}[Sapwul_Event]
    
    Run Keyword If    '${hasSapwulTrigger}'=='None'    Validate NO SAPWUL Related Trigger Business Events
    ...    ELSE    Run Keywords    
    ...    Validate SAPWUL Related Trigger on Business Events
    ...    AND    Validate Business Event XML Section Details    ${SAPWUL_EXPECTEDJSON_PATH}    &{FacilityDataSet}[Test_Case]   
    
    Close All Windows on LIQ
    
Verify FFC SAPWUL Facility Payload 
    [Documentation]    This keyword verifies if SAPWUL Facility Payload exists at FFC
    ...                @author: hstone    18SEP2019    Initial create
    [Arguments]    ${SAPWULPayloadDataSet}
    
    Validate FFC Facility Payload    &{SAPWULPayloadDataSet}[Test_Case]    &{SAPWULPayloadDataSet}[Payload_facilityName]    &{SAPWULPayloadDataSet}[Internal_facilityId]

Verify Deal Primaries Event XML
    [Documentation]    This keyword verifies XML Section Details of the Deal Primaries Event
    ...                @author: hstone    18SEP2019    Initial create
    [Arguments]    ${DealDataSet}
    Close All Windows on LIQ
    ${hasSapwulEvent}    Set Variable    &{DealDataSet}[Sapwul_Event]
    ${hasTrigger}    Set Variable     &{DealDataSet}[Sapwul_hasTrigger]
    Navigate to Lender Circle Notebook Business Events     &{DealDataSet}[Deal_Name]   &{DealDataSet}[Primary_Lender]     &{DealDataSet}[Sapwul_Event]
    
    Run Keyword If    '${hasSapwulEvent}'=='None' or '${hasTrigger}'=='N'    Validate NO SAPWUL Related Trigger Business Events
    ...    ELSE   Run Keywords
    ...    Validate SAPWUL Related Trigger on Business Events
    ...    AND    Validate Business Event XML Section Details    ${SAPWUL_EXPECTEDJSON_PATH}    &{DealDataSet}[Test_Case]   
    
    Close All Windows on LIQ
