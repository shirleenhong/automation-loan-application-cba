*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Populate Party Onboarding and Return Values
    [Documentation]    This keyword populates required fields in Party Onboarding.
    ...    @author: jcdelacruz
    ...    @update: amansuet    17MAR2020    - updated based on automation standard guidelines
    ...    @update: dahijara    30APR2020    - Updated logic for populating fields. 
    ...    @update: dahijara    09JUN2020    - Updated Next button locator and Get Element Attribute keyword
    ...    @update: javinzon    25SEP2020    - Added "and Return Values" in keyword name
    [Arguments]    ${sLocality}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${iBranch_Code}    ${bMultiEntity_Enabled}=False

    Mx Input Text    ${Party_PartyOnboarding_Locality_Dropdown}    ${sLocality}

    Mx Input Text    ${Party_PartyOnboarding_PartyType_Dropdown}    ${sParty_Type}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}

    Run Keyword If    '${sParty_Type}'=='Enterprise'    Wait Until Element Is Visible    ${Party_PartyOnboarding_LineOfBusiness_Table}    15s
    ...    ELSE    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${Party_PartyOnboarding_LineOfBusiness_Table}

    ### Validate if Commercial Lending is selected by default ###
    ${RowCount}    SeleniumLibraryExtended.Get Element Count    ${Party_PartyOnboarding_LineOfBusiness_Rows}
    :FOR    ${INDEX}    IN RANGE    1    ${RowCount} + 1
    \    
    \    ${LineOfBusiness_Name}    Get Text    ${Party_PartyOnboarding_LineOfBusiness_Rows}\[${INDEX}]${Party_PartyOnboarding_LOBName_TableRow}
    \    ${isLOBSelected}    Run Keyword If    '${LineOfBusiness_Name}'=='Commercial Lending'    SeleniumLibraryExtended.Get Element Attribute    ${Party_PartyOnboarding_LineOfBusiness_Rows}\[${INDEX}]${Party_PartyOnboarding_LOB_CheckBox}    aria-checked
    \    Run Keyword If    ${${isLOBSelected}}==${False}    Mx Click Element    ${Party_PartyOnboarding_LineOfBusiness_Rows}\[${INDEX}]${Party_PartyOnboarding_LOB_CheckBox}
    \    Exit For Loop If    '${LineOfBusiness_Name}'=='Commercial Lending'

    Mx Input Text    ${Party_PartyOnboarding_PartySubType_Dropdown}    ${sParty_Sub_Type}
    Mx Input Text    ${Party_PartyOnboarding_PartyCategory_Dropdown}    ${sParty_Category}

    ${Entity}    Get Value    ${Party_PartyOnboarding_Entity_Textbox}
    ${Assigned_Branch}    Get Value    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
 
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyOnboarding-{index}.png

    Mx Click Element    ${Party_Footer_Next_Button}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_PREEXISTENCECHECK_PAGETITLE}

    [Return]    ${Entity}    ${Assigned_Branch}

Validate Pre-Existence Check Page Fields if Correct
	[Documentation]    This keyword is used to validate if all field values are correct.
    ...    @author: amansuet    20MAR2020    - initial create
    ...    @update: dahijara    30APR2020    - Updated locators for locality and entity field
    ...    @update: javinzon    16SEP2020    - Updated parameter from ${sAssignedBranch} to ${sAssigned_Branch}
    [Arguments]    ${sLocality}    ${sEntity}    ${sAssigned_Branch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}
    
    Run Keyword If    '${sLocality}'!=''    Run Keyword And Continue On Failure    Textfield Value Should Be    ${Party_PreExistenceCheck_Locality_Dropdown}    ${sLocality}
    Run Keyword If    '${sEntity}'!=''    Run Keyword And Continue On Failure    Textfield Value Should Be    ${Party_PreExistenceCheck_Entity_Dropdown}    ${sEntity}
    Run Keyword If    '${sAssigned_Branch}'!=''    Run Keyword And Continue On Failure    Textfield Value Should Be    ${Party_PartyOnboarding_AssignedBranch_Dropdown}    ${sAssigned_Branch}
	Run Keyword If    '${sParty_Type}'!=''    Run Keyword And Continue On Failure    Textfield Value Should Be    ${Party_PartyOnboarding_PartyType_Dropdown}    ${sParty_Type}
	Run Keyword If    '${sParty_Sub_Type}'!=''    Run Keyword And Continue On Failure    Textfield Value Should Be    ${Party_PartyOnboarding_PartySubType_Dropdown}    ${sParty_Sub_Type}
	Run Keyword If    '${sParty_Category}'!=''    Run Keyword And Continue On Failure    Textfield Value Should Be    ${Party_PartyOnboarding_PartyCategory_Dropdown}    ${sParty_Category}
	
Validate Pre-Existence Check Page Fields if Disabled
    [Documentation]    This keyword is used to validate if all fields are disabled.
	...    @author: amansuet    20MAR2020    - initial create
    ...    @update: dahijara    30APR2020    - Updated locators for locality and entity field
	
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PreExistenceCheck_Locality_Dropdown}
	Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PreExistenceCheck_Entity_Dropdown}
	Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
	Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PartyOnboarding_PartyType_Dropdown}
	Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PartyOnboarding_PartySubType_Dropdown}
	Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PartyOnboarding_PartyCategory_Dropdown}

Validate Pre-Existence Check Page Values and Field State
    [Documentation]    This keyword is used to validate all field values are correct and all fields are disabled for Pre-Existence Check Page.
	...    @author: amansuet    20MAR2020    - initial create
	[Arguments]    ${sLocality}    ${sEntity}    ${sAssigned_Branch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}
	
	Validate Pre-Existence Check Page Fields if Correct    ${sLocality}    ${sEntity}    ${sAssigned_Branch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}
	Validate Pre-Existence Check Page Fields if Disabled

Populate Pre-Existence Check
   [Documentation]    This keyword populates pre-existence and click next to redirect to 
    ...    Quick Party Enterprise page.
    ...    @author: jcdelacruz
    ...    @update: ghabal - restructure writing details below
    ...    @update: jdelacru    20FEB2019    - Moved writing of Party ID and Enterprise Name in highlevel keyword
    ...    @update: gerhabal    26SEP2019    - updated Party ID scripts to check if they exist first in DB before generation, it should be unique
    ...    @update: amansuet    17MAR2020    - updated keyword
    ...    @update: dahijara    30APR2020    - update keyword to wait for screen loading.
    ...    @update: dahijara    09JUN2020    - Updated Next button locator
    [Arguments]    ${sEnterprise_Prefix}

    Mx Click Element     ${Party_PreExistenceCheck_EnterpriseName_TextBox} 
    Set Focus To Element    ${Party_PreExistenceCheck_EnterpriseName_TextBox}
    ${Generated_Value}    Generate Unique Number or Text for Party
    ${Party_ID}    Set Variable    ${Generated_Value}
    ${Enterprise_Name}    Catenate    ${sEnterprise_Prefix}    ${Generated_Value}
    
    Mx Activate And Input Text    ${Party_PreExistenceCheck_EnterpriseName_TextBox}    ${Enterprise_Name}  
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyPreExistenceCheckPage-{index}.png 
    Mx Click Element    ${Party_Footer_Next_Button}

    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${PARTY_PREEXISTENCECHECK_PAGETITLE}    ${PARTY_TIMEOUT}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_QUICKENTERPRISEPARTY_PAGETITLE}
    
    [Return]    ${Enterprise_Name}    ${Party_ID}
  
Select Referral Using Reference ID
    [Documentation]    This keyword is used to select referral row on Open referrals section based on the reference ID and Return referral Task ID
    ...    @author: dahijara    30APR2020    - initial create
    [Arguments]    ${sRefID}    ${isSupervisor}=${False}

    ${status}    Set Variable    ${False}
    ${referralCount}    SeleniumLibraryExtended.Get Element Count    ${Party_Referrals_ReferralRow_Table}
    :FOR    ${index}    IN RANGE    1    ${referralCount}+1
    \    Mx Click Element    ${Party_Referrals_ReferralRow_Table}\[${index}]${Party_TableRadioButton_RadioButton}
    \    Run Keyword If   ${isSupervisor}==${True}    Focus on Last Row of the Table    ${Party_Referrals_Details_Row}
    \    ${status}    Run Keyword And Return Status    Wait Until Page Contains    ${sRefID}    5s
    \    ${taskID}    Run Keyword If    ${status}==${True}    Get Text    ${Party_Referrals_ReferralRow_Table}\[${index}]${Party_Referrals_TaskID_TableCell}
    \    Exit For Loop If    ${status}==${True}

    [Return]    ${taskID}

Focus on Last Row of the Table
    [Documentation]    This keyword is used to 
    ...    @author: dahijara    19MAY2020    - initial create
    [Arguments]    ${eTableRowLocator}

    ${iRowCount}    SeleniumLibraryExtended.Get Element Count    ${eTableRowLocator}
    ${status}    Run Keyword And Return Status    Mx Scroll Element Into View    ${eTableRowLocator}\[${iRowCount}]

Approve Registered Party
    [Documentation]    This Keyword approves the created party from Quick Party Onboarding using supervisor account.
    ...    @author: dahijara    05MAY2020    - initial create
    [Arguments]    ${Party_ID}

    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyLandingPage-{index}.png
    Mx Click Element    ${Party_HomePage_Notification_Icon}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_NOTIFICATIONTYPES_PAGETITLE}
    Mx Input Text    ${Party_NotificationTypes_TaskType_TextBox}    Referral
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyNotificationTypesPage-{index}.png
    Mx Click Element    ${Party_Next_Button}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_PROCESSREFERRALS_PAGETITLE}   
     
    ${TaskID}    Select Referral Using Reference ID    ${Party_ID}    ${True}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyProcessReferralsPage-{index}.png
    Run Keyword If    '${TaskID}'!='None'    Mx Click Element    ${Party_Approve_Button}
    ...    ELSE    Fail    Unable to Find Referral with Party ID:${Party_ID}

    [Return]    ${TaskID}

Populate Quick Enterprise Party
    [Documentation]    This keyword populates required fields in Quick Enterprise Party page.
    ...    @author: jcdelacruz
    ...    @update: gerhabal    25SEP2019    - added handling of Proceed button for warning message.   
    ...    @update: jdelacru    10DEC2019    - removed ${Business_Focus}, ${Business_Type}, ${Date_Formed}, 
    ...                         ${Email_Contact_Type}, ${Email}, ${Confirm_Email}, ${Mobile_Contact_Type}, 
    ...                         ${Country_Code},  and ${Number} as arguments
    ...    @update: jdelacru    04MAR2020    - Uncomment additional click for proceed button
    ...    @update: amansuet    18MAR2020    - updated based on automation standard guidelines and added optional argument for address 3 and 4
    ...    @update: dahijara    30APR2020    - used Mx Input text for inputing fields
    ...    @update: dahijara    09JUN2020    - Updated Next button locator
    ...    @update: javinzon    17SEP2020    - Updated arguments for Address 3 and 4 to be mandatory
    ...    @update: javinzon	21OCT2020	 - Updated Warning Popup to Warning Dialog, Updated Approval Required scripts, Added Validate Duplicate Short Name 
    ...    @update: javinzon    26OCT2020    - Updated keyword name from 'Validate Duplicate Short Name' to 'Validate Error Message in Quick Enterprise Party',
    ...                                        Added optional argument ${sExpected_Error_Message}.
    ...	   @update: javinzon	12NOV2020	 - Updated keywords for Warning Dialog and Approval Required Dialog                                           
    [Arguments]    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sAddress_Type}    ${sCountry_Region}    ${iPost_Code}
    ...    ${sDocument_Collection_Status}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${iGST_Number}
    ...    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}    ${sState_Province}    
    ...    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}    ${sExpected_Error_Message}=None
    
    Mx Input Text    ${Party_QuickEnterpriseParty_PartyId_TextBox}    ${sParty_ID}
    Mx Input Text    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}    ${iRegistered_Number}
    Mx Input Text    ${Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown}    ${sCountry_of_Tax_Domicile}
    Mx Input Text    ${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}    ${sCountry_of_Registration}
    Populate Enterprise Business Activity    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${sBusiness_Country}    ${bIs_Primary_Activity}
    Mx Input Text    ${Party_QuickEnterpriseParty_ShortName_TextBox}    ${sShort_Name}
    Run Keyword If    '${iGST_Number}'!=''    Click Button    ${Party_QuickEnterpriseParty_GoodsAndServiceTaxLiable_CheckBox}
    Run Keyword If    '${iGST_Number}'!=''    Mx Input Text    ${Party_QuickEnterpriseParty_GoodsAndServiceTaxNumber_TextBox}    ${iGST_Number}
    
    ### Address Details ###
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressType_Dropdown}    ${sAddress_Type}
    Mx Input Text    ${Party_QuickEnterpriseParty_CountryRegion_Dropdown}    ${sCountry_Region}
    Mx Input Text    ${Party_QuickEnterpriseParty_PostCode_TextBox}    ${iPost_Code}
    Populate Address Details    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sAddress_Line_3}    ${sAddress_Line_4}
    Mx Input Text    ${Party_QuickEnterpriseParty_DocumentCollectionStatus_Dropdown}    ${sDocument_Collection_Status}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyQuickEnterprisePartyPage-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}

    ### Error handler, DO NOT DELETE commented code below ###
    # Focus    ${Party_QuickEnterpriseParty_ErrorUnderlay_Box}
    # Mx Native Type    {ESC}
    # Sleep    5s
    # Focus    ${Party_QuickEnterpriseParty_ErrorUnderlay_Box}
    # Mx Native Type    {ESC}
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${Party_Next_Button}
    
    Proceed with Warning Dialog
    Proceed with Approval Required Dialog    ${sExpected_Error_Message}
    
Proceed with Warning Dialog
    [Documentation]    This keyword will proceed user to the Warning Dialog.
    ...    @author: javinzon    - initial create
    
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    ${isWarningDisplayed}    Run Keyword And Return Status    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_BiometricsWarning_Dialog}    30s
    Run Keyword If    ${isWarningDisplayed}==${True}    Mx Click Element    ${Party_QuickEnterpriseParty_ProceedWarning_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
   
Proceed with Approval Required Dialog
    [Documentation]    This keyword will proceed user to Approval Required Dialog and validate if there is an error.
    ...    @author: javinzon    - initial create
    [Arguments]    ${sExpected_Error_Message}
    
    ${isApprovalRequired}    Run Keyword And Return Status    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_ApprovalRequired_Dialog}    30s
    Run Keyword If    ${isApprovalRequired}==${True}    Run Keywords	Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalDialog-{index}.png
    ...	AND	    Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    ...	AND	    Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}
    ...	ELSE    Validate Error Message in Quick Enterprise Party    ${sExpected_Error_Message}
    
Populate Enterprise Business Activity
    [Documentation]    This keyword populates required fields in Enterprise Business Activity modal.
    ...    @author: jcdelacruz
    ...    @update: gerhabal - added "Wait Until Page Contains Create Enterprise Business Activity" and "Wait Until Browser Ready State"  
    ...    @update: jdelacru    10-DEC2019   - removed business focus and business types as arguments
    ...    @update: amansuet    18MAR2020    - updated keyword and added condition on boolean arguments
    ...    @update: dahijara    30APR2020    - added wait for elements to load before doing any actions. Updated keywords for element clicking.
    ...    @update: dahijara    09JUN2020    - Updated Get Element Attribute keyword
    [Arguments]    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${sBusiness_Country}    ${bIs_Primary_Activity}

    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_BusinessActivity_CheckBox}
    Click Element    ${Party_QuickEnterpriseParty_BusinessActivity_CheckBox}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Create Enterprise Business Activity  
    Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_NewRow_Button}
    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}    ${sBusiness_Country}
    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}    ${sIndustry_Sector}
    Wait Until Browser Ready State
    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}    ${sBusiness_Activity}
    Wait Until Browser Ready State
    ${isChecked}    SeleniumLibraryExtended.Get Element Attribute    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}    aria-checked
    Run Keyword If    '${bIs_Main_Activity}'=='${TRUE}' and ${${isChecked}}==${False}    Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}
    ${isChecked}    SeleniumLibraryExtended.Get Element Attribute    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsPrimaryActivity_CheckBox}    aria-checked
    Run Keyword If    '${bIs_Primary_Activity}'=='${TRUE}' and ${${isChecked}}==${False}    Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsPrimaryActivity_CheckBox}
    Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_SaveRow_Button}
    Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Next_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    
Populate Address Details
    [Documentation]    This keyword populates address details modal.
    ...    @author: jcdelacruz
    ...    @update: amansuet    18MAR2020    - updated keyword and added conditional argument address 3 and 4
    ...    @update: javinzon    17SEP2020    - updated arguments for Address 3 and 4 to be mandatory
    ...    @update: javinzon    12NOV2020    - added Capture Page Screenshot Keyword
    [Arguments]    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sAddress_Line_3}    ${sAddress_Line_4}

    Mx Click Element    ${Party_QuickEnterpriseParty_RecordAddress_Button}   
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT} 
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineOne_TextBox}     ${sAddress_Line_1}
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineTwo_TextBox}     ${sAddress_Line_2}
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineThree_TextBox}     ${sAddress_Line_3}
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineFour_TextBox}     ${sAddress_Line_4}
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_TownCity_TextBox}   ${sTown_City}
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_StateProvince_Dropdown}    ${sState_Province}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyAddressDetailsDialog-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}

Approve Party via Supervisor Account
    [Documentation]    This keyword is used to approve created party via Quick Party Onboarding
    ...    @author: dahijara    05MAY2020    - initial create
    ...    @update: dahijara    09JUN2020    - Added keyword to update zone an branch
    ...    @update: javinzon    04NOV2020    - Added ELSE condition to Close Browser
    [Arguments]    ${sPartyID}    ${sUserZone}    ${sUserBranch}

    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_APPROVER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    
    Configure Zone and Branch    ${sUserZone}    ${sUserBranch}
    ${Task_ID_From_Supervisor}    Approve Registered Party    ${sPartyID}
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser

    [Return]    ${Task_ID_From_Supervisor}

Accept Approved Party
    [Documentation]    This keyword accepts the approved party of the supervisor account.
    ...    @author: jcdelacruz
    ...    @update: fmamaril    07AUG2019    Remove Error handler on Error processing Area; Remove login
    ...    @update: gerhabal    26SEP2019    Increase seconds of Wait Until Page Contains by 40s
    ...    @update: jdelacru    10DEC2019    - removed argument rowid
    ...    @update: amansuet    18MAR2020    - updated based on automation standard guidelines and replaced keyword to get table row value
    ...    @update: dahijara    05MAY2020    - Updated logic for validation points and wait keywords.
    ...    @update: dahijara    09JUN2020    - Updated Next button locator and Get Element Attribute Keyword
    ...    @update: ritragel    13AUG2020    - Removed validation of title page
    ...	   @update: javinzon	17SEP2020	 - Updated Approval radio button locator name
    [Arguments]    ${sTask_ID_From_Supervisor}    ${sPartyID}

    Mx Click Element    ${Party_HomePage_Notification_Icon}    
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_NOTIFICATIONTYPES_PAGETITLE}
    Mx Input Text    ${Party_NotificationTypes_TaskType_TextBox}    Approval
    Mx Click Element    ${Party_ProcessNotification_NotificationTypes_Approval_RadioButton}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyNotificationTypesPage-{index}.png
    Mx Click Element    ${Party_Next_Button}

    Wait Until Browser Ready State
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_APPROVALS_PAGETITLE}  
    ${Task_ID_From_User}    Select Referral Using Reference ID    ${sTask_ID_From_Supervisor}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalsPage-{index}.png
    Run Keyword If    '${Task_ID_From_User}'!='None'    Mx Click Element    ${Party_Next_Button}
    ...    ELSE    Fail    Unable to Find Referral with Task ID:${sTask_ID_From_Supervisor}    

    Wait Until Browser Ready State
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_DATAPROTECTIONSTATEMENT_PAGETITLE}
    Wait Until Page Contains Element    ${Party_DataProtectionStatement_Textarea}           
    Click Element    ${Party_DataProtectionStatement_TickToDenoteCompliance_CheckBox}
    ${isComplianceChkbxSelected}    SeleniumLibraryExtended.Get Element Attribute    ${Party_DataProtectionStatement_TickToDenoteCompliance_CheckBox}    aria-checked
    Run Keyword If    ${${isComplianceChkbxSelected}}==${False}    Fail    Data Protection Statement Compliance checkbox is NOT ticked.
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDataProtectionStatementPage-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}

    Wait Until Browser Ready State
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    ${EnterprisePartyID}    Get Value    ${Party_EnterpriseRelatedPartyStatus_EnterprisePartyId_Label}
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sPartyID}    ${EnterprisePartyID}
    Run Keyword If    ${isMatched}==${True}    Log    Party ID value is correct! Party ID:${EnterprisePartyID}    level=INFO
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Party ID value is incorrect! Party ID:${EnterprisePartyID}, Expected Party ID:${sPartyID}       
    Click Element    ${Party_EnterpriseRelatedPartyStatus_Accept_RadioButton}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyEnterpriseRelatedPartyStatusPage-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}

Validate Enterprise Summary Details
    [Documentation]    This keyword validates the Party details from Enterprise summary details page.
    ...    @author: dahijara    05MAY2020     - initial create
    ...    @update: javinzon    16SEP2020     - changed parameter from ${sAssignedBranch} to ${sUserBranch}
    ...    @update: javinzon    04NOV2020     - added Run Keyword And Ignore Error for Page screen validation,
    ...                                         updated validation for Tax Country cell
    ...    @update: javinzon    11NOV2020     - updated validation for Country of Tax and GST Number
    [Arguments]    ${sLocality}    ${sEntity}    ${sUserBranch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${sParty_ID}    
    ...    ${sEnterprise_Name}    ${sRegistered_Number}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}    ${sGTS_Number}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Run Keyword And Ignore Error    Validate Page Screen is Displayed    ${PARTY_ENTERPRISEPARTYSUMMARYDETAILS_PAGETITLE}

    Compare Two Arguments    ${sLocality}    ${Party_PreExistenceCheck_Locality_Dropdown}
    Compare Two Arguments    ${sEntity}    ${Party_QuickEnterpriseParty_Entity_Dropdown}
    Compare Two Arguments    ${sUserBranch}    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
    Compare Two Arguments    ${sParty_Type}    ${Party_QuickEnterpriseParty_PartyType_Dropdown}
    Compare Two Arguments    ${sParty_Sub_Type}    ${Party_QuickEnterpriseParty_PartySubType_Dropdown}
    Compare Two Arguments    ${sParty_Category}    ${Party_QuickEnterpriseParty_PartyCategory_Dropdown}
    Compare Two Arguments    ${sParty_ID}    ${Party_QuickEnterpriseParty_PartyId_TextBox}
    Compare Two Arguments    ${sEnterprise_Name}    ${Party_QuickEnterpriseParty_PartyName_TextBox}
    Compare Two Arguments    ${sRegistered_Number}    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}
    Compare Two Arguments    ${sCountryOfRegistration}    ${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}
    Compare Two Arguments    ${sCountryOfTaxDomicile}    ${Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown}

    ${GST_Number}    Get Table Value Containing Row Value in Party    ${Party_EnterpriseDetailsSummary_GeographicLocationsAndTaxNumbers_TableHeader}    ${Party_EnterpriseDetailsSummary_GeographicLocationsAndTaxNumbers_TableRow}    Country    ${sCountryOfTaxDomicile}    Goods & Service Tax Number
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sGTS_Number}    ${GST_Number}
    Run Keyword If    ${isMatched}==${True}    Log    Goods & Service Tax Number value is correct! GST Number:${GST_Number}    level=INFO
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Goods & Service Tax Number value is incorrect! Goods & Service Tax Number:${GST_Number}, Expected Goods & Service Tax Number:${sGTS_Number}       

    ${TaxCountry}    Get Table Value Containing Row Value in Party    ${Party_EnterpriseDetailsSummary_GeographicLocationsAndTaxNumbers_TableHeader}    ${Party_EnterpriseDetailsSummary_GeographicLocationsAndTaxNumbers_TableRow}    Goods & Service Tax Number    ${sGTS_Number}    Country
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sCountryOfTaxDomicile}    ${TaxCountry}
    Run Keyword If    ${isMatched}==${True}    Log    Country of Tax value is correct! Country of Tax:${TaxCountry}    level=INFO
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Country of Tax value is incorrect! Country of Tax:${TaxCountry}, Expected Country of Tax:${sCountryOfTaxDomicile}
     
Validate Enquire Enterprise Business Activity Details
    [Documentation]    This keyword validates the Enterprise Business Activity Details from Enterprise summary details page.
    ...    @author: javinzon    17SEP2020    - initial create
    ...    @update: javinzon    03NOV2020    - updated validations for MainActivity and PrimaryActivity
    [Arguments]    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}

    Click Button    ${Party_EnterPrisePartySummaryDetails_BusinessActivity_View_Button}
    Wait Until Page Contains    Enquire Enterprise Business Activity
    
    Compare Two Arguments    ${sCountry}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}
    Compare Two Arguments    ${sIndustrySector}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}
    Compare Two Arguments    ${sBusinessActivity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown} 
    
    ${IsMainActivity_Actual}    SeleniumLibraryExtended.Get Element Attribute    ${Party_EnquirePartyDetails_BusinessActivity_Is_Main_Activity_Checkbox}    aria-checked
    Run Keyword If    '${IsMainActivity_Actual.upper()}'=='${bIsMainActivity.upper()}'    Log    Value for Main Activity is correct
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Value for Main Activity is incorrect
    
    ${IsPrimaryActivity_Actual}    SeleniumLibraryExtended.Get Element Attribute    ${Party_EnquirePartyDetails_BusinessActivity_Is_Main_Activity_Checkbox}    aria-checked
    Run Keyword If    '${IsPrimaryActivity_Actual.upper()}'=='${bIsPrimaryActivity.upper()}'    Log    Value for Primary Activity is correct 
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Value for Primary Activity is incorrect
     
Accept Approved Party and Validate Details in Enterprise Summary Details Screen
    [Documentation]    This keyword validates the Enterprise Business Activity Details from Enterprise summary details page.
    ...    @author: dahijara    05MAY2020     - initial create
    ...    @update: dahijara    09JUN2020     - added keyword to update zone and branch
    ...	   @update: javinzon	17SEP2020	  - updated argument ${sAssignedBranch} to ${sAssigned_Branch}, 
    ...											updated argument ${sAssignedBranch} to ${sUserBranch}
    ...											added keyword Validate Enquire Enterprise Business Activity Details
    [Arguments]    ${sTask_ID_From_Supervisor}    ${sPartyID}    ${sLocality}    ${sEntity}    ${sAssigned_Branch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    
    ...    ${sEnterprise_Name}    ${sRegistered_Number}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}
    ...    ${sGTS_Number}    ${sUserZone}    ${sUserBranch}    


    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}   
    
    Configure Zone and Branch    ${sUserZone}    ${sUserBranch}

    Accept Approved Party    ${sTask_ID_From_Supervisor}    ${sPartyID}

    Validate Enterprise Summary Details    ${sLocality}    ${sEntity}    ${sUserBranch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${sParty_ID}    
    ...    ${sEnterprise_Name}    ${sRegistered_Number}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}    ${sGTS_Number}  
    
    Validate Enquire Enterprise Business Activity Details    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser

Reject Party via Supervisor Account
   [Documentation]    This keyword is used to reject created party via Quick Party Onboarding
    ...    @author: dahijara    07MAY2020    - initial create
    ...    @author: gagregado   08OCT2020    - changed Party URL suffix to SSO
    ...    @author: javinzon    15OCT2020    - added 'Configure Zone and Branch' Keyword
    [Arguments]    ${sPartyID}    ${sUserZone}    ${sUserBranch}

    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_APPROVER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    
    Configure Zone and Branch    ${sUserZone}    ${sUserBranch}
    
    ${Task_ID_From_Supervisor}    Reject Registered Party    ${sPartyID}
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser

    [Return]    ${Task_ID_From_Supervisor}

Reject Registered Party
    [Documentation]    This Keyword rejects the created party from Quick Party Onboarding using supervisor account.
    ...    @author: dahijara    05MAY2020    - initial create
    [Arguments]    ${Party_ID}
    Mx Click Element    ${Party_HomePage_Notification_Icon}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_NOTIFICATIONTYPES_PAGETITLE}
    Mx Input Text    ${Party_NotificationTypes_TaskType_TextBox}    Referral
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyNotificationTypesPage-{index}.png
    Mx Click Element    ${Party_Next_Button}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_PROCESSREFERRALS_PAGETITLE}   
    
    ${TaskID}    Select Referral Using Reference ID    ${Party_ID}    ${True}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyProcessReferralsPage-{index}.png
    Run Keyword If    '${TaskID}'!='None'    Mx Click Element    ${Party_Reject_Button}
    ...    ELSE    Fail    Unable to Find Referral with Party ID:${Party_ID}

    [Return]    ${TaskID}    

Accept Rejected Party and Validate Details in Quick Enterprise Details Screen
    [Documentation]    This keyword validates the Enterprise Business Activity Details from Enterprise summary details page.
    ...    @author: dahijara    07MAY2020    - initial create
    ...    @author: gagregado   08OCT2020    - changed Party URL suffix to SSO  
    ...    @update: javinzon    15OCT2020    - added Configure Zone and Branch Keyword  
    ...    @update: javinzon    20NOV2020    - added ELSE condition for Close Browser Keyword
    [Arguments]    ${sUserZone}    ${sUserBranch}    ${sTask_ID_From_Supervisor}    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sAddress_Type}    ${sCountry_Region}    ${iPost_Code}
    ...    ${sDocument_Collection_Status}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${iGST_Number}
    ...    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}
    ...    ${sAddress_Line_3}=None    ${sAddress_Line_4}=None

    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_SSO_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}   
    
    Configure Zone and Branch    ${sUserZone}    ${sUserBranch}    

    Accept Rejected Party    ${sTask_ID_From_Supervisor}    ${sPartyID}

    Validate Quick Enterprise Party    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sAddress_Type}    ${sCountry_Region}    ${iPost_Code}
    ...    ${sDocument_Collection_Status}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${iGST_Number}
    ...    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}
    ...    ${sAddress_Line_3}    ${sAddress_Line_4}

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    ...    ELSE    Close Browser    

Accept Rejected Party
    [Documentation]    This keyword accepts the rejected party of the supervisor account.
    ...    @author: dahijara    07MAY2020    - initia create.
    [Arguments]    ${sTask_ID_From_Supervisor}    ${sPartyID}

    Mx Click Element    ${Party_HomePage_Notification_Icon}    
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_NOTIFICATIONTYPES_PAGETITLE}
    Mx Input Text    ${Party_NotificationTypes_TaskType_TextBox}    Rejection
    Mx Click Element    ${Party_ProcessNotification_NotificationTypes_Rejection_RadioButton}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyNotificationTypesPage-{index}.png
    Mx Click Element    ${Party_Next_Button}

    Wait Until Browser Ready State
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_REJECTIONS_PAGETITLE}  
    ${Task_ID_From_User}    Select Referral Using Reference ID    ${sTask_ID_From_Supervisor}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyRejectionsPage-{index}.png
    Run Keyword If    '${Task_ID_From_User}'!='None'    Mx Click Element    ${Party_Next_Button}
    ...    ELSE    Fail    Unable to Find Referral with Task ID:${sTask_ID_From_Supervisor} 

    Wait Until Browser Ready State
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_QUICKENTERPRISEPARTY_PAGETITLE}

Validate Quick Enterprise Party
    [Documentation]    This keyword validates fields in Quick Enterprise Party page.
    ...    @author: dahijara    11MAY2020    - initial create
    [Arguments]    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sAddress_Type}    ${sCountry_Region}    ${iPost_Code}
    ...    ${sDocument_Collection_Status}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${iGST_Number}
    ...    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}
    ...    ${sAddress_Line_3}=None    ${sAddress_Line_4}=None

    Compare Two Arguments    ${sParty_ID}    ${Party_QuickEnterpriseParty_PartyId_TextBox}
    Compare Two Arguments    ${iRegistered_Number}    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}
    Compare Two Arguments    ${sCountry_of_Tax_Domicile}    ${Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown}
    Compare Two Arguments    ${sCountry_of_Registration}    ${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}
    Validate Enterprise Business Activity    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${sBusiness_Country}    ${bIs_Primary_Activity}
    Compare Two Arguments    ${sShort_Name}    ${Party_QuickEnterpriseParty_ShortName_TextBox}
    Compare Two Arguments    ${iGST_Number}    ${Party_QuickEnterpriseParty_GoodsAndServiceTaxNumber_TextBox}
    Compare Two Arguments    ${sAddress_Type}    ${Party_QuickEnterpriseParty_AddressType_Dropdown}
    Compare Two Arguments    ${sCountry_Region}    ${Party_QuickEnterpriseParty_CountryRegion_Dropdown}
    Compare Two Arguments    ${iPost_Code}    ${Party_QuickEnterpriseParty_PostCode_TextBox}
    Validate Address Details    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sAddress_Line_3}    ${sAddress_Line_4}
    Compare Two Arguments    ${sDocument_Collection_Status}    ${Party_QuickEnterpriseParty_DocumentCollectionStatus_Dropdown}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyQuickEnterprisePartyPage-{index}.png

Validate Enterprise Business Activity
    [Documentation]    This keyword validates fields in Enterprise Business Activity modal.
    ...    @author: dahijara    11MAY2020    - initial create
    [Arguments]    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${sBusiness_Country}    ${bIs_Primary_Activity}

    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_BusinessActivity_CheckBox}
    Click Element    ${Party_QuickEnterpriseParty_BusinessActivity_CheckBox}
    Click Element    ${Party_QuickEnterpriseParty_BusinessActivity_CheckBox}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Create Enterprise Business Activity  

    Compare Two Arguments    ${sBusiness_Country}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}
    Compare Two Arguments    ${sIndustry_Sector}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}
    Compare Two Arguments    ${sBusiness_Activity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}
    ${IsMainActivityChecked}    Get Element Attribute    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}    aria-checked
    Run Keyword If    '${bIs_Main_Activity}'=='${TRUE}' and ${${IsMainActivityChecked}}==${True}    Log    IsMainActivity value is correct!
    ...   ELSE    Run Keyword And Continue On Failure    Fail    IsMainActivity value is incorrect! Expected Value: '${bIs_Main_Activity}' | Actual Value: ${IsMainActivityChecked}
    ${isPrimaryActivityChecked}    Get Element Attribute    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsPrimaryActivity_CheckBox}    aria-checked
    Run Keyword If    '${bIs_Primary_Activity}'=='${TRUE}' and ${${isPrimaryActivityChecked}}==${True}        Log    IsPrimaryActivity value is correct!
    ...   ELSE    Run Keyword And Continue On Failure    Fail    IsPrimaryActivity value is incorrect! Expected Value: '${bIs_Primary_Activity}' | Actual Value: ${isPrimaryActivityChecked}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyEnterpriseBusinessActivityPage-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Next_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}

    
Validate Address Details
    [Documentation]    This keyword validates address details modal.
    ...    @author: dahijara    11MAY2020    - initial create
	[Arguments]    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sAddress_Line_3}=None    ${sAddress_Line_4}=None

    Mx Click Element    ${Party_QuickEnterpriseParty_RecordAddress_Button}    
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Compare Two Arguments    ${sAddress_Line_1}    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineOne_TextBox}
    Compare Two Arguments    ${sAddress_Line_2}    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineTwo_TextBox}
    Run Keyword If    '${sAddress_Line_3}'!='${None}' or '${sAddress_Line_3}' != '${EMPTY}'    Compare Two Arguments     ${sAddress_Line_3}    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineThree_TextBox}
    Run Keyword If    '${sAddress_Line_4}'!='${None}' or '${sAddress_Line_4}' != '${EMPTY}'    Compare Two Arguments     ${sAddress_Line_4}    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineFour_TextBox}
    Compare Two Arguments    ${sTown_City}    ${Party_QuickEnterpriseParty_AddressDetails_TownCity_TextBox}
    Compare Two Arguments    ${sState_Province}    ${Party_QuickEnterpriseParty_AddressDetails_StateProvince_Dropdown}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyAddressDetailsPage-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}
    
Populate Pre-Existence Check and Validate the Duplicate Enterprise Name
   [Documentation]    This keyword populates pre-existence with Duplicate Enterprise Name, checks if Action required is Reject and view the existing Party details 
    ...    @author: javinzon    28SEP2020    - initial create
    ...	   @update: javinzon	02OCT2020	 - added Party ID argument
    ...    @update: javinzon    14OCT2020    - updated keyword 'Capture Page ScreenShot' to 'Capture Page Screenshot' 
    [Arguments]    ${sEnterprise_Name}    ${sParty_ID}

    Mx Click Element     ${Party_PreExistenceCheck_EnterpriseName_TextBox} 
    Set Focus To Element    ${Party_PreExistenceCheck_EnterpriseName_TextBox}
    Mx Activate And Input Text    ${Party_PreExistenceCheck_EnterpriseName_TextBox}    ${sEnterprise_Name}  
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/DuplicateEnterpriseName-{index}.png 
    Mx Click Element    ${Party_Footer_Next_Button}

    Wait Until Element Is Not Visible    ${PARTY_PREEXISTENCECHECKRESULTFOUND_PAGETITLE}    ${PARTY_TIMEOUT} 
    ${Party_Name}    Get Table Value Containing Row Value in Party    ${Party_PreExistenceCheck_SearchResultTableHeader}    ${Party_PreExistenceCheck_SearchResultTableRow}    Party ID    ${sParty_ID}    Party Name  
    ${Action}    Get Table Value Containing Row Value in Party    ${Party_PreExistenceCheck_SearchResultTableHeader}    ${Party_PreExistenceCheck_SearchResultTableRow}    Party ID    ${sParty_ID}    Action  
    
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sEnterprise_Name}    ${Party_Name}
    Run Keyword If    ${isMatched}==${True}    Log    There is a Duplicate Enterprise Name  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    There is no Duplicate Enterprise Name   
    Run Keyword If    '${Action}'=='Reject'    Run Keywords      Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/DuplicateEnterpriseName-{index}.png 
    ...    AND    Mx Click Element    ${Party_PreExistenceCheck_View_Button}     
    ...    ELSE    Run Keyword and Continue on Failure    Fail    No duplicate found for Enterprise Name
    
    Validate Enterprise Name in Enquire Enterprise Party    ${Party_Name}
    
Validate Disabled Fields in Quick Enterprise Party Page
    [Documentation]    This keyword validates disabled fields in Quick Enterprise Party page and Address details dialog
    ...    @author: javinzon    08OCT2020    - initial create
    ...    @update: javinzon    14OCT2020    - updated keyword 'Capture Page ScreenShot' to 'Capture Page Screenshot' 
    [Arguments]    ${sCountry_Region}
    
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PreExistenceCheck_Locality_Dropdown}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
	Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PreExistenceCheck_Entity_Dropdown}
	Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PartyOnboarding_PartyType_Dropdown}
	Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PartyOnboarding_PartySubType_Dropdown}
	Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_PartyOnboarding_PartyCategory_Dropdown}
	
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_AlternativePartyId_TextBox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_Internet_Checkbox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_Mobile_Checkbox}
    
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_EnterpriseName_Textbox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_StateOfRegistration_Dropdown}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_NonResidentLicensePermit_Textbox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_DateFormed_Textbox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_BusinessActivity_Textbox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_EnterpiseStatus_Dropdown}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_WithholdingTaxLiable_CheckBox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_TaxExemptionReason_Dropdown}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_GoodsAndServiceTaxNumber_TextBox}
    
    ### Validate Disabled fields in Address Section ###
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_Address_TextBox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_CopyAddress_Button}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_AddressLookUp_Button}
    
    ### Validate Disabled fields in Email Section ###
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_Email_ContactType_Dropdown}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_Email_Email_TextBox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_Email_ConfirmEmail_TextBox}
    
    ### Validate Disabled fields in Mobile Section ###
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_Mobile_ContactType_Dropdown}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_Mpbile_MobileNumber_CountryCode_TextBox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_Mpbile_MobileNumber_Number_TextBox}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/QuickPartyOnboarding_DisabledFields-{index}.png
    
    ### Validate Disabled fields in Address Details Dialog ###
    Mx Input Text    ${Party_QuickEnterpriseParty_CountryRegion_Dropdown}    ${sCountry_Region}
    Mx Click Element    ${Party_QuickEnterpriseParty_RecordAddress_Button}
    Wait Until Page Contains    ${PARTY_ADDRESSDETAILS_PAGETITLE}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/QuickPartyOnboarding_DisabledFields-{index}.png
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_AddressDetails_Name_TextBox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_AddressDetails_PostCode_TextBox}
    Run Keyword And Continue On Failure    Element Should Be Disabled    ${Party_QuickEnterpriseParty_AddressDetails_Country_TextBox}
    Mx Click Element    ${Party_CloseDialog_Button}

Validate Branch in Party Onboarding Page
    [Documentation]    This test case is used to validate Branches in Branch List Dialog of Party Onboarding Page
    ...    @author: javinzon    13OCT2020    - initial create
    [Arguments]    ${sAssigned_Branch}    ${iBranch_Code}    ${sBranch_Name}    ${sBank_Name}    ${iCountry_Code}    ${iAssigned_Branch_Code}
    
    Mx Click Element    ${Party_PartyOnboarding_Search_Button}
    Wait Until Page Contains    ${PARTY_BRANCHLIST_PAGETITLE}
    
    ### Validate results when no parameter was given ###
    ${Branch_Code_List}    Split String    ${iBranch_Code}    |    
    ${Branch_Name_List}    Split String    ${sBranch_Name}    |
    ${Bank_Name_List}    Split String    ${sBank_Name}    |
    ${Country_Code_List}    Split String    ${iCountry_Code}    |
    
    Mx Click Element    ${Party_PartyOnboarding_BranchList_Search_Button}
    ${RowCount}    SeleniumLibraryExtended.Get Element Count    ${Party_PartyOnboarding_BranchList_SearchResultTableRow}
    
    :FOR    ${Index}    IN RANGE    ${RowCount}
    \    ${Branch_Code}    Get From List    ${Branch_Code_List}    ${Index}
    \    ${Actual_Branch_Name}    Get Table Value Containing Row Value in Party    ${Party_PartyOnboarding_BranchList_SearchResultTableHeader}    ${Party_PartyOnboarding_BranchList_SearchResultTableRow}    Branch Code    ${Branch_Code}    Branch Name
    \    ${Actual_Bank_Name}    Get Table Value Containing Row Value in Party    ${Party_PartyOnboarding_BranchList_SearchResultTableHeader}    ${Party_PartyOnboarding_BranchList_SearchResultTableRow}    Branch Code    ${Branch_Code}    Bank Name
    \    ${Actual_Country_Code}    Get Table Value Containing Row Value in Party    ${Party_PartyOnboarding_BranchList_SearchResultTableHeader}    ${Party_PartyOnboarding_BranchList_SearchResultTableRow}    Branch Code    ${Branch_Code}    Country Code
    \    Compare Two Strings    @{Branch_Name_List}[${Index}]    ${Actual_Branch_Name}
    \    Compare Two Strings    @{Bank_Name_List}[${Index}]    ${Actual_Bank_Name}
    \    Compare Two Strings    @{Country_Code_List}[${Index}]    ${Actual_Country_Code}    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/QuickPartyOnboarding_BranchField-{index}.png

    ### Validate results when a parameter was given ###
    Mx Input Text    ${Party_PartyOnboarding_BranchList_BranchName_TextBox}    ${sAssigned_Branch}
    Mx Click Element    ${Party_PartyOnboarding_BranchList_Search_Button}
    ${Branch_Name}    Get Table Value Containing Row Value in Party    ${Party_PartyOnboarding_BranchList_SearchResultTableHeader}    ${Party_PartyOnboarding_BranchList_SearchResultTableRow}    Branch Code    ${iAssigned_Branch_Code}    Branch Name
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/QuickPartyOnboarding_BranchField-{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}
    
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sAssigned_Branch}    ${Branch_Name}
    Run Keyword If    ${isMatched}==${True}    Log    Result is correct.
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Result is incorrect. Expected Value: '${sAssigned_Branch}' | Actual Value: ${Branch_Name}   

Validate Mandatory Fields in Quick Enterprise Party Page    
    [Documentation]    This test case is used to validate mandatory fields in Quick Enterprise Party Page.
    ...    Mandatory Fields as of this writting are as follows: PartyID, Registered Number, Country of Registration, Short name, Goods and service tax number
    ...    Address type, Post code, Document collection status, Country, Industry Sector, Business Activity, Address Line 1, Town/City 
    ...    @author: javinzon    15OCT2020    - initial create
    [Arguments]    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${iGST_Number}    ${sCountryRegion}    ${iPostCode}
    
    Click Button    ${Party_QuickEnterpriseParty_GoodsAndServiceTaxLiable_CheckBox}
    Mx Click Element    ${Party_Footer_Next_Button}

    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible   ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_PartyId_TextBox}    
    Run Keyword If    ${isMandatory}==${True}    Log    Party ID is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Party ID should be mandatory.   
    
    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible   ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}
    Run Keyword If    ${isMandatory}==${True}    Log    Registered Number is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Registered Number should be mandatory.   
    
    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible   ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}
    Run Keyword If    ${isMandatory}==${True}    Log    Country of Registration is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Country of Registration should be mandatory.   

    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible   ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_ShortName_TextBox}
    Run Keyword If    ${isMandatory}==${True}    Log    Short Name is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Short Name should be mandatory.   
    
    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible   ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_GoodsAndServiceTaxNumber_TextBox}
    Run Keyword If    ${isMandatory}==${True}    Log    Goods And Service Tax Number is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Goods And Service Tax Number should be mandatory.     
        
    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible   ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_AddressType_Dropdown}
    Run Keyword If    ${isMandatory}==${True}    Log    Address Type is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Address Type should be mandatory.    

    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible   ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_PostCode_TextBox}
    Run Keyword If    ${isMandatory}==${True}    Log    Post Code is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Post Code should be mandatory.     
    
    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible   ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_DocumentCollectionStatus_Dropdown}
    Run Keyword If    ${isMandatory}==${True}    Log    Document Collection Status is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Document Collection Status should be mandatory.    
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/QuickPartyOnboarding_MandatoryFields-{index}.png
    
    ### Validate Mandatory Fields in Business Activity Dialog ###
    Mx Scroll Element Into View    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
    Mx Input Text    ${Party_QuickEnterpriseParty_PartyId_TextBox}    ${sParty_ID}
    Mx Input Text    ${Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown}    ${sCountry_of_Tax_Domicile}
    Mx Input Text    ${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}    ${sCountry_of_Registration}
    Mx Input Text    ${Party_QuickEnterpriseParty_GoodsAndServiceTaxNumber_TextBox}    ${iGST_Number}
    Click Element    ${Party_QuickEnterpriseParty_BusinessActivity_CheckBox}
    Wait Until Page Contains    Create Enterprise Business Activity
    Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_NewRow_Button}
    Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Next_Button}
    
    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible    ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}
    Run Keyword If    ${isMandatory}==${True}    Log    Country is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Country should be mandatory.    

    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible    ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}
    Run Keyword If    ${isMandatory}==${True}    Log    Industry Sector is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail   Industry Sector should be mandatory.     
    
    ${isMandatory}    Run Keyword And Return Status    Element Should Be Visible    ${Party_QuickEnterpriseParty_Error_TextBox}${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}
    Run Keyword If    ${isMandatory}==${True}    Log    Business Activity is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Business Activity should be mandatory.
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/QuickPartyOnboarding_MandatoryFields-{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}
    
    ### Validate Mandatory Fields in Address Details Dialog ### 
    Mx Input Text    ${Party_QuickEnterpriseParty_CountryRegion_Dropdown}    ${sCountryRegion}
    Mx Input Text    ${Party_QuickEnterpriseParty_PostCode_TextBox}    ${iPostCode}
    Mx Click Element    ${Party_QuickEnterpriseParty_RecordAddress_Button}
    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}
    
    ${AddressLine1_ConfigDetails}    Get Element Attribute   ${Party_QuickEnterpriseParty_AddressDetails_AddressLineOne_TextBox}    data-configuration-details
    ${isMandatory}    Run Keyword And Return Status    Should Contain    ${AddressLine1_ConfigDetails}    {"mandatory":"F"}
    Run Keyword If    ${isMandatory}==${True}    Log    Address Line 1 is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Address Line 1 should be mandatory.    

    ${TownCity_ConfigDetails}    Get Element Attribute   ${Party_QuickEnterpriseParty_AddressDetails_TownCity_TextBox}    data-configuration-details
    ${isMandatory}    Run Keyword And Return Status    Should Contain    ${TownCity_ConfigDetails}    {"mandatory":"F"}
    Run Keyword If    ${isMandatory}==${True}    Log    Town/City is a mandatory field.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail   Town/City should be mandatory.   
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/QuickPartyOnboarding_MandatoryFields-{index}.png
    Mx Click Element    ${Party_CloseDialog_Button}

Validate Error Message in Quick Enterprise Party
    [Documentation]    This test case is used to get and validate error message in Error dialog.
    ...    @author: javinzon    21OCT2020    - initial create
    ...	   @update: javinzon	23OCT2020	 - removed white space in Keyword name
    ...    @update: javinzon    26OCT2020    - updated keyword name from 'Validate Duplicate Short Name' to 'Validate Error Message in Quick 
    ...                                        Enterprise Party', updated documentation, added argument ${sExpected_Error_Message}.
    ...    @update: javinzon	09NOV2020	 - added SeleniumLibraryExtended in Get Element Attirbute keyword
    ...    @update: javinzon    17NOV2020    - updated screenshot name from 'DuplicateShortName' to 'ErrorMessage' 
    [Arguments]    ${sExpected_Error_Message}
    
    ${isErrorDisplayed}    Run Keyword And Return Status    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_Errors_Dialog}    30s
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/DuplicateShortName-{index}.png
    ${ErrorMessage}    SeleniumLibraryExtended.Get Element Attribute    ${Party_QuickEnterpriseParty_ErrorsDialog_TextArea}    value

    ${isMatched}    Run Keyword And Return Status    Should Contain    ${ErrorMessage}    ${sExpected_Error_Message}
    Run Keyword If    ${isMatched}==${True}    Mx Click Element    ${Party_QuickEnterpriseParty_ErrorsDialog_GoBack_Button}
    ...    ELSE    Run Keyword and Continue on Failure    Fail   Error message: '${sExpected_Error_Message}' is expected.

Validate Enterprise Name in Enquire Enterprise Party
    [Documentation]    This keyword is used to get and validate Enterprise name in Enquire Enterprise Party Page.
    ...    @author: javinzon    29OCT2020    - intial create
    [Arguments]    ${sEnterprise_Name}
    
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/EnterpriseName-{index}.png
    ${Existing_EnterpriseName}    Get Value    ${Party_EnquirePartyDetails_EnterpriseName_TextBox}
    Log    ${Existing_EnterpriseName}
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${Existing_EnterpriseName}    ${sEnterprise_Name}
    Run Keyword If    ${isMatched}==${True}    Run Keywords    Log    Enterprise Name '${sEnterprise_Name}' is already existing.
    ...    AND    Logout User on Party    
    ...    ELSE    Run Keyword and Continue on Failure    Fail    Party details displayed are not for '${sEnterprise_Name}'.
             
Populate Pre-Existence Check and Validate Duplicate Enterprise Name Across Entities
    [Documentation]    This keyword populates pre-existence with Duplicate Enterprise Name, checks if Entity and Action are correct, 
    ...    then switch to other entity to view the existing Party details.
    ...    @author: javinzon    29OCT2020    - initial create
    [Arguments]    ${sEnterprise_Name}    ${sParty_ID}    ${sSwitch_UserZone}    ${sSwitch_UserBranch}    ${sEntity_Expected}

    Mx Click Element     ${Party_PreExistenceCheck_EnterpriseName_TextBox} 
    Set Focus To Element    ${Party_PreExistenceCheck_EnterpriseName_TextBox}
    Mx Activate And Input Text    ${Party_PreExistenceCheck_EnterpriseName_TextBox}    ${sEnterprise_Name}  
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/DuplicateEnterpriseNameAcrossEntities-{index}.png 
    Mx Click Element    ${Party_Footer_Next_Button}

    Wait Until Element Is Not Visible    ${PARTY_GLOBALDEDUPRESULT_PAGETITLE}    ${PARTY_TIMEOUT} 
    ${Entity_Result}    Get Table Value Containing Row Value in Party    ${Party_PreExistenceCheck_SearchResultTableHeader}    ${Party_PreExistenceCheck_SearchResultTableRow}    Party ID    ${sParty_ID}    Entity  
    ${Action_Result}    Get Table Value Containing Row Value in Party    ${Party_PreExistenceCheck_SearchResultTableHeader}    ${Party_PreExistenceCheck_SearchResultTableRow}    Party ID    ${sParty_ID}    Action  
    
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sEntity_Expected}    ${Entity_Result}
    Run Keyword If    ${isMatched}==${True} and '${Action_Result}'=='Reject'    Run Keywords    Log    Enterprise Name:'${sEnterprise_Name}' is already existing in Party ID '${sParty_ID}' created from '${sEntity_Expected}' Entity.
    ...   AND    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/DuplicateEnterpriseNameAcrossEntities-{index}.png
    ...   AND    Mx Click Element    ${Party_CloseTab_Button}
    ...   AND    Configure Zone and Branch    ${sSwitch_UserZone}    ${sSwitch_UserBranch}
    ...   AND    Navigate Party Details Enquiry    ${sParty_ID}
    ...   AND    Validate Enterprise Name in Enquire Enterprise Party    ${sEnterprise_Name}
    ...   ELSE    Run Keyword and Continue on Failure    Fail    There is no Duplicate Enterprise Name   
    
Get the Available Business Activity Options 
    [Documentation]    This keyword is used to compare and validate if the available Business Activity Options are correct.
    ...    @author: javinzon    06OCT2020    - initial create
    ...    @update: clanding    06NOV2020    - removed \ in the \    ...
    [Arguments]    ${sIndustry_Sector}
     
    ${Industry_Sector_FileName}    Replace String    ${sIndustry_Sector}    ${SPACE}    _  
    ${Industry_Sector_FileName}    Remove String    ${Industry_Sector_FileName}    ,    and_
    ${Expected_BusinessActivity}    OperatingSystem.Get File    ${BUSINESSACTIVITY_DIRECTORY}\\${Industry_Sector_FileName}.txt
    ${Expected_BusinessActivity_Line_Count}    Get Line Count    ${Expected_BusinessActivity}
    :FOR    ${LineCount}    IN RANGE    ${Expected_BusinessActivity_Line_Count}
    \    ${BusinessActivity_List_Line_Content}    Get Line    ${Expected_BusinessActivity}    ${LineCount}
    \    ${BusinessActivity_Dropdown_Content}    Get Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown_List}//div[contains(@item, "${LineCount}")]
    \    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${BusinessActivity_List_Line_Content}    ${BusinessActivity_Dropdown_Content}       
    \    Run Keyword If    ${isMatched}==${True}    Log    Business Activity '${BusinessActivity_Dropdown_Content}' is matched in Valid Business Activty List with value:${\n}${BusinessActivity_List_Line_Content}.
         ...    ELSE    Run Keyword And Continue On Failure    Fail    Business Activity '${BusinessActivity_Dropdown_Content}' is NOT matched in Valid Business Activty List with value:${\n}${BusinessActivity_List_Line_Content}. 
    
Validate Available Options in Business Activity Field
    [Documentation]    This keyword validates the Available Options in Business Activity Field across All Industry Sectors. 
    ...    @author: javinzon    02OCT2020    - initial create
    [Arguments]    ${sBusiness_Country}    
    
    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_BusinessActivity_CheckBox}
    Click Element    ${Party_QuickEnterpriseParty_BusinessActivity_CheckBox}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Create Enterprise Business Activity  
    Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_NewRow_Button}
    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}    ${sBusiness_Country}
    Wait Until Browser Ready State
    
    ${IndustrySector_List_Content}    OperatingSystem.Get File    ${INDUSTRYSECTOR_LIST}
    ${IndustrySector_List_Count}    Get Line Count    ${IndustrySector_List_Content}
    :FOR    ${LineCount}    IN RANGE    ${IndustrySector_List_Count}
    \    ${IndustrySector_List_Line_Content}    Get Line    ${IndustrySector_List_Content}    ${LineCount}
    \    Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}    ${IndustrySector_List_Line_Content}
    \    Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Arrow}
    \    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/BusinessActivityOptions-{index}.png 
    \    Get the Available Business Activity Options   ${IndustrySector_List_Line_Content}
    \    Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Label}
    
    Mx Click Element    ${Party_CloseDialog_Button}
    
Populate and Validate Length of Fields in Quick Enterprise Party
    [Documentation]    This test case is used to populate and validate field length of the following fields in Quick Enterprise Party:
    ...    Post Code, Address Line 1, Address Line 2, Address Line 3, Address Line 4, Address City, Short Name.
    ...    @author:    javinzon    06NOV2020    - initial create
    [Arguments]    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sAddress_Type}    ${sCountry_Region}    ${iPost_Code}    ${iInvalid_Post_Code}
    ...    ${sDocument_Collection_Status}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${iGST_Number}
    ...    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sInvalid_Address_Line_1}    ${sInvalid_Address_Line_2}    ${sInvalid_Address_Line_3}    
    ...    ${sInvalid_Address_Line_4}    ${sTown_City}    ${sInvalid_Town_City}    ${sState_Province}    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}    
    ...    ${sPostCode_Error_Message}    ${sAddressLine_Error_Message}    ${sAddressCity_Error_Message}
    
    ### Validate Post Code Field Length ###
    Populate Quick Enterprise Party    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sAddress_Type}    ${sCountry_Region}    ${iInvalid_Post_Code}    
    ...    ${sDocument_Collection_Status}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${iGST_Number}    ${sAddress_Line_1}    ${sAddress_Line_2}
    ...    ${sAddress_Line_3}    ${sAddress_Line_4}    ${sTown_City}    ${sState_Province}    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}    ${sPostCode_Error_Message}
    Mx Scroll Element Into View    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
    Mx Input Text    ${Party_QuickEnterpriseParty_PostCode_TextBox}    ${iPost_Code}   
        
    ### Validate Address Line 1 Field Length ###
    Populate Address Details    ${sInvalid_Address_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sAddress_Line_3}    ${sAddress_Line_4}
    Mx Click Element    ${Party_Footer_Next_Button}
    Proceed with Warning Dialog
    Proceed with Approval Required Dialog    ${sAddressLine_Error_Message}
    
    ### Validate Address Line 2 Field Length ###
    Mx Scroll Element Into View    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
    Populate Address Details    ${sAddress_Line_1}    ${sInvalid_Address_Line_2}    ${sTown_City}    ${sState_Province}    ${sAddress_Line_3}    ${sAddress_Line_4}
    Mx Click Element    ${Party_Footer_Next_Button}
    Proceed with Warning Dialog
    Proceed with Approval Required Dialog    ${sAddressLine_Error_Message}
    
    ### Validate Address Line 3 Field Length ###
    Mx Scroll Element Into View    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
    Populate Address Details    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sInvalid_Address_Line_3}    ${sAddress_Line_4}
    Mx Click Element    ${Party_Footer_Next_Button}
    Proceed with Warning Dialog
    Proceed with Approval Required Dialog    ${sAddressLine_Error_Message}
    
    ### Validate Address Line 4 Field Length ###
    Mx Scroll Element Into View    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
    Populate Address Details    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sAddress_Line_3}    ${sInvalid_Address_Line_4}
    Mx Click Element    ${Party_Footer_Next_Button}
    Proceed with Warning Dialog
    Proceed with Approval Required Dialog    ${sAddressLine_Error_Message}
    
    ### Validate Address City Field Length ###
    Mx Scroll Element Into View    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
    Populate Address Details    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sInvalid_Town_City}    ${sState_Province}    ${sAddress_Line_3}    ${sAddress_Line_4}
    Mx Click Element    ${Party_Footer_Next_Button}
    Proceed with Warning Dialog
    Proceed with Approval Required Dialog    ${sAddressCity_Error_Message}
    
    ### Validate ShortName Field Length ###
    ${ShortName_MaxLength}    SeleniumLibraryExtended.Get Element Attribute   ${Party_QuickEnterpriseParty_ShortName_TextBox}    maxlength
    ${isMaximum}    Run Keyword And Return Status    Should Contain    ${ShortName_MaxLength}    25
    Run Keyword If    ${isMaximum}==${True}    Log    Maximum Length of Short Name field is 25 characters only.  
    ...   ELSE    Run Keyword and Continue on Failure    Fail    Length of Short Name field should not be more than 25 characters.     
    
   
    