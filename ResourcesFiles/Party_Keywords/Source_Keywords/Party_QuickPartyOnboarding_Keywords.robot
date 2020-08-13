*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***

Populate Party Onboarding
    [Documentation]    This keyword populates required fields in Party Onboarding.
    ...    @author: jcdelacruz
    ...    @update: amansuet    17MAR2020    - updated based on automation standard guidelines
    ...    @update: dahijara    30APR2020    - Updated logic for populating fields. 
    ...    @update: dahijara    09JUN2020    - Updated Next button locator and Get Element Attribute keyword
    [Arguments]    ${sLocality}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${iBranch_Code}    ${bMultiEntity_Enabled}=False

    Mx Input Text    ${Party_PartyOnboarding_Locality_Dropdown}    ${sLocality}

    Mx Input Text    ${Party_PartyOnboarding_PartyType_Dropdown}    ${sParty_Type}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}

    Run Keyword If    '${sParty_Type}'=='Enterprise'    Wait Until Element Is Visible    ${Party_PartyOnboarding_LineOfBusiness_Table}    15s
    ...    ELSE    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${Party_PartyOnboarding_LineOfBusiness_Table}

    #Validate if Commercial Lending is selected by default
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
    [Arguments]    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sAddress_Type}    ${sCountry_Region}    ${iPost_Code}
    ...    ${sDocument_Collection_Status}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${iGST_Number}
    ...    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}
    ...    ${sAddress_Line_3}=None    ${sAddress_Line_4}=None

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

    ##### Warning Popup #####
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    ${isWarningDisplayed}    Run Keyword And Return Status    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_BiometricsWarning_Dialog}    10s
    Run Keyword If    ${isWarningDisplayed}==${True}    Mx Click Element    ${Party_QuickEnterpriseParty_ProceedWarning_Button}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}

    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_ApprovalRequired_Dialog}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalDialog-{index}.png
    Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}

    Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}

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
    [Arguments]    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sAddress_Line_3}=None    ${sAddress_Line_4}=None

    Mx Click Element    ${Party_QuickEnterpriseParty_RecordAddress_Button}   
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT} 
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineOne_TextBox}    ${sAddress_Line_1}
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineTwo_TextBox}     ${sAddress_Line_2}
    Run Keyword If    '${sAddress_Line_3}'!='None' or '${sAddress_Line_3}'!='${EMPTY}'    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineThree_TextBox}     ${sAddress_Line_3}
    Run Keyword If    '${sAddress_Line_4}'!='None' or '${sAddress_Line_4}'!='${EMPTY}'    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_AddressLineFour_TextBox}     ${sAddress_Line_4}
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_TownCity_TextBox}   ${sTown_City}
    Mx Input Text    ${Party_QuickEnterpriseParty_AddressDetails_StateProvince_Dropdown}    ${sState_Province}
    Mx Click Element    ${Party_QuickEnterpriseParty_AddressDetails_Next_Button}


Approve Party via Supervisor Account
   [Documentation]    This keyword is used to approve created party via Quick Party Onboarding
    ...    @author: dahijara    05MAY2020    - initial create
    ...    @update: dahijara    09JUN2020    - Added keyword to update zone an branch
    [Arguments]    ${sPartyID}    ${sUserZone}    ${sUserBranch}

    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_APPROVER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    
    Configure Zone and Branch    ${sUserZone}    ${sUserBranch}
    ${Task_ID_From_Supervisor}    Approve Registered Party    ${sPartyID}
    
    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser

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
    Validate Page Screen is Displayed    ${PARTY_ENTERPRISERELATEDPARTYSTATUS_PAGETITLE}
    ${EnterprisePartyID}    Get Value    ${Party_EnterpriseRelatedPartyStatus_EnterprisePartyId_Label}
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sPartyID}    ${EnterprisePartyID}
    Run Keyword If    ${isMatched}==${True}    Log    Party ID value is correct! Party ID:${EnterprisePartyID}    level=INFO
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Party ID value is incorrect! Party ID:${EnterprisePartyID}, Expected Party ID:${sPartyID}       
    Click Element    ${Party_EnterpriseRelatedPartyStatus_RadioButton}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyEnterpriseRelatedPartyStatusPage-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}

Validate Enterprise Summary Details
    [Documentation]    This keyword validates the Party details from Enterprise summary details page.
    ...    @author: dahijara    05MAY2020     - initial create
    [Arguments]    ${sLocality}    ${sEntity}    ${sAssignedBranch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${sParty_ID}    
    ...    ${sEnterprise_Name}    ${sRegistered_Number}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}    ${sGTS_Number}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_ENTERPRISEPARTYSUMMARYDETAILS_PAGETITLE}

    Compare Two Arguments    ${sLocality}    ${Party_PreExistenceCheck_Locality_Dropdown}
    Compare Two Arguments    ${sEntity}    ${Party_QuickEnterpriseParty_Entity_Dropdown}
    Compare Two Arguments    ${sAssignedBranch}    ${Party_PartyOnboarding_AssignedBranch_Dropdown}
    Compare Two Arguments    ${sParty_Type}    ${Party_QuickEnterpriseParty_PartyType_Dropdown}
    Compare Two Arguments    ${sParty_Sub_Type}    ${Party_QuickEnterpriseParty_PartySubType_Dropdown}
    Compare Two Arguments    ${sParty_Category}    ${Party_QuickEnterpriseParty_PartyCategory_Dropdown}
    Compare Two Arguments    ${sParty_ID}    ${Party_QuickEnterpriseParty_PartyId_TextBox}
    Compare Two Arguments    ${sEnterprise_Name}    ${Party_QuickEnterpriseParty_PartyName_TextBox}
    Compare Two Arguments    ${sRegistered_Number}    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}
    Compare Two Arguments    ${sCountryOfRegistration}    ${Party_QuickEnterpriseParty_CountryOfRegistration_Dropdown}
    Compare Two Arguments    ${sCountryOfTaxDomicile}    ${Party_QuickEnterpriseParty_CountryOfTaxDomicile_Dropdown}

    ${GST_Number}    Get Text    ${Party_EnterpriseDetailsSummary_TaxNumber_Cell}
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sGTS_Number}    ${GST_Number}
    Run Keyword If    ${isMatched}==${True}    Log    Goods & Service Tax Number value is correct! Party ID:${GST_Number}    level=INFO
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Goods & Service Tax Number value is incorrect! Goods & Service Tax Number:${GST_Number}, Expected Goods & Service Tax Number:${sGTS_Number}       

    ${TaxCountry}    Get Text    ${Party_EnterpriseDetailsSummary_TaxCountry_Cell}
    ${isMatched}    Run Keyword And Return Status    Should Be Equal    ${sGTS_Number}    ${GST_Number}
    Run Keyword If    ${isMatched}==${True}    Log    Country of Tax value is correct! Party ID:${TaxCountry}    level=INFO
    ...    ELSE    Run Keyword And Continue On Failure    Fail    Country of Tax value is incorrect! Country of Tax:${TaxCountry}, Expected Country of Tax:${sCountryOfTaxDomicile}     

Validate Enterprise Business Activity Details
    [Documentation]    This keyword validates the Enterprise Business Activity Details from Enterprise summary details page.
    ...    @author: dahijara    05MAY2020     - initial create
    [Arguments]    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}

    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Validate Page Screen is Displayed    ${PARTY_ENTERPRISEPARTYSUMMARYDETAILS_PAGETITLE}

    Click Button    ${Party_QuickEnterpriseParty_BusinessActivity_CheckBox}
    Wait Until Loading Page Is Not Visible    ${PARTY_TIMEOUT}
    Wait Until Page Contains    Create Enterprise Business Activity  

    ${IsMainActivity}    Get Value    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}
    ${IsPrimaryActivity}    Get Value    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}

    Compare Two Arguments    ${sCountry}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Country_Dropdown}
    Compare Two Arguments    ${sIndustrySector}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}
    Compare Two Arguments    ${sBusinessActivity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}    

Accept Approved Party and Validate Details in Enterprise Summary Details Screen
    [Documentation]    This keyword validates the Enterprise Business Activity Details from Enterprise summary details page.
    ...    @author: dahijara    05MAY2020     - initial create
    ...    @update: dahijara    09JUN2020    - added keyword to update zone and branch
    [Arguments]    ${sTask_ID_From_Supervisor}    ${sPartyID}    ${sLocality}    ${sEntity}    ${sAssignedBranch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    
    ...    ${sEnterprise_Name}    ${sRegistered_Number}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}    ${sCountry}    ${sIndustrySector}    ${sBusinessActivity}    ${bIsMainActivity}    ${bIsPrimaryActivity}
    ...    ${sGTS_Number}    ${sUserZone}    ${sUserBranch}


    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}   
    
    Configure Zone and Branch    ${sUserZone}    ${sUserBranch}

    Accept Approved Party    ${sTask_ID_From_Supervisor}    ${sPartyID}

    Validate Enterprise Summary Details    ${sLocality}    ${sEntity}    ${sAssignedBranch}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${sParty_ID}    
    ...    ${sEnterprise_Name}    ${sRegistered_Number}    ${sCountryOfRegistration}    ${sCountryOfTaxDomicile}    ${sShortName}    ${sGTS_Number}

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser

Reject Party via Supervisor Account
   [Documentation]    This keyword is used to reject created party via Quick Party Onboarding
    ...    @author: dahijara    07MAY2020    - initial create
    [Arguments]    ${sPartyID}

    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_APPROVER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    
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
    ...    @author: dahijara    07MAY2020     - initial create
    [Arguments]    ${sTask_ID_From_Supervisor}    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sAddress_Type}    ${sCountry_Region}    ${iPost_Code}
    ...    ${sDocument_Collection_Status}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${iGST_Number}
    ...    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}
    ...    ${sAddress_Line_3}=None    ${sAddress_Line_4}=None

    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}   
    
    Accept Rejected Party    ${sTask_ID_From_Supervisor}    ${sPartyID}

    Validate Quick Enterprise Party    ${sParty_ID}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}    ${sAddress_Type}    ${sCountry_Region}    ${iPost_Code}
    ...    ${sDocument_Collection_Status}    ${sIndustry_Sector}    ${sBusiness_Activity}    ${bIs_Main_Activity}    ${iGST_Number}
    ...    ${sAddress_Line_1}    ${sAddress_Line_2}    ${sTown_City}    ${sState_Province}    ${sBusiness_Country}    ${bIs_Primary_Activity}    ${iRegistered_Number}    ${sShort_Name}
    ...    ${sAddress_Line_3}    ${sAddress_Line_4}

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser    

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
