*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Variables ***
${sEnterpriseNameVar}
${sPartyIDVar}

*** Keywords ***

Navigate Process
    [Documentation]    This keyword navigates the user to Quick Party Onboarding page.
    ...    @author: jcdelacruz
    ...    @update: amansuet    17MAR2020    - updated based on automation standard guidelines
    ...    @update: dahijara    28APR2020    - used 'Mx Input Text' instead of 'Input Text'. And removed line "Press Key    ${Party_HomePage_Process_TextBox}    \\13"
    ...    @update: ritragel    13AUG2020    - added Press Keys since Press Key is now deprecated
    [Arguments]    ${sSelected_Module}

    Mx Input Text and Press Enter    ${Party_HomePage_Process_TextBox}    ${sSelected_Module}
    
Navigate Party Details Enquiry
    [Documentation]    This keyword navigates the user to Party Details Enquiry page.
    ...    @author: jcdelacruz
    ...    @update: gerhabal    16SEP2019    - added "Wait Until Browser Ready State" upon click of Next buttona nd increase 10s to 20s     
    ...    @update: amansuet    17MAR2020    - updated based on automation standard guidelines
    ...    @update: ritragel    13AUG2020    - added Press Keys since Press Key is now deprecated
    [Arguments]    ${sParty_id}
    Input Text    ${Party_HomePage_Process_TextBox}    Party Details Enquiry
    Press Keys    ${Party_HomePage_Process_TextBox}    RETURN
    Mx Input Text    ${Party_EnquireEnterpriseParty_PartyId_Text}     ${sParty_id}
    Wait Until Browser Ready State
    Wait Until Element Is Visible    ${Party_EnquireEnterpriseParty_Next_Button}
    Wait Until Element Is Enabled    ${Party_EnquireEnterpriseParty_Next_Button}       
    Mx Click Element    ${Party_EnquireEnterpriseParty_Next_Button}
    Wait Until Browser Ready State
    Wait Until Page Contains    Enquire Enterprise Party    20s
    
Validate Enterprise Party Details
    [Documentation]    This keyword validates the given Party Details from Enterprise Party Summary Details.
    ...    @author: jcdelacruz
    ...    @update: fmamaril
    ...    @update: amansuet    18MAR2020    - updated based on automation standard guidelines
    [Arguments]    ${sLocality}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${sParty_ID}    ${sEnterprise_Name}    ${iRegistered_Number}
    
    Wait Until Browser Ready State
    Compare Two Arguments    ${sLocality}    ${FBE_Locality_Text}
    Compare Two Arguments    ${sParty_Type}    ${FBE_PartyType_Text}
    Compare Two Arguments    ${sParty_Sub_Type}    ${FBE_PartySubType_Text}
    Compare Two Arguments    ${sParty_Category}    ${FBE_PartyCategory_Text}
    Compare Two Arguments    ${sParty_ID}    ${FBE_PartyId_Text}
    Compare Two Arguments    ${sEnterprise_Name}    ${FBE_EnterpriseName_Text}
    Compare Two Arguments    ${iRegistered_Number}    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}
    ${acceptance_status}     Get Value    ${FBE_AcceptanceStatus_Text}
    Should Be Equal    ${acceptance_status}    Accepted
      
Validate Enquire Enterprise Party Details
    [Documentation]    This keyword validates the given Party Details from Enquire Enterprise Party.
    ...    @author: jcdelacruz
    ...    @update: jdelacru    10DEC2019    - removed validating Date Formed
    ...    @update: amansuet    18MAR2020    - updated based on automation standard guidelines
    [Arguments]    ${sLocality}    ${sParty_Type}    ${sParty_Sub_Type}    ${sParty_Category}    ${sEnterprise_Name}    ${iRegistered_Number}    ${sDate_Formed}    ${sCountry_of_Tax_Domicile}    ${sCountry_of_Registration}
    
    Wait Until Browser Ready State
    Wait Until Browser Ready State 
    Compare Two Arguments    ${sLocality}    ${FBE_Locality_Text}
    Compare Two Arguments    ${sParty_Type}    ${FBE_PartyType_Text}
    Compare Two Arguments    ${sParty_Sub_Type}    ${FBE_PartySubType_Text}
    Compare Two Arguments    ${sParty_Category}    ${FBE_PartyCategory_Text}
    Compare Two Arguments    ${sEnterprise_Name}    ${Party_EnquireEnterpriseParty_EnterpriseName_Text}
    Compare Two Arguments    ${iRegistered_Number}    ${Party_QuickEnterpriseParty_RegisteredNumber_TextBox}
    Compare Two Arguments    ${sCountry_of_Tax_Domicile}    ${Party_EnquireEnterpriseParty_CountryOfTaxDomicile_Text}
    Compare Two Arguments    ${sCountry_of_Registration}    ${Party_EnquireEnterpriseParty_CountryOfRegistration_Text}  
    
Select Row That Contains Text
    [Arguments]    ${field_to_verify}    ${table_name}    ${element_to_be_clicked}    ${contains_cell_text}    ${element_to_activate}

    ${table_length}    SeleniumLibraryExtended.Get Element Count    ${table_name}
    :FOR   ${i}    IN RANGE    1   ${table_length}+1
    \    ${index}    Set Variable    [${i}]
    \    log    ${index}
    \    Mx Click Element    ${element_to_be_clicked}${index}
    \    Log     Field to verify is ${field_to_verify}
    \    ${status}    Run Keyword And Return Status    Wait Until Page Contains    ${field_to_verify}
    \    Exit For Loop If    '${status}'=='True'
    Mx Click Element    ${element_to_activate}
    ${cell_text}    Get Text    ${contains_cell_text}
    [Return]    ${cell_text}

Auto Generate Only 7 Numeric Test Data
    [Documentation]    This keyword concatenates current date as a unique 7 numeric test data
    ...    @author: ghabal  
    ...    @update: amansuet    - updated keyword
    [Arguments]    ${sName_Prefix}=None
    
    ${Result_Value}    Get Current Date    result_format=%H1%M%S  

    ${Generated_Value}    Run Keyword If    '${sName_Prefix}'!='None'    Catenate    SEPARATOR=    ${sName_Prefix}    ${Result_Value}
    ...    ELSE IF    '${sName_Prefix}'=='None'    Set Variable    ${Result_Value}

    [Return]    ${Generated_Value}
    
Get Table Value Containing Row Value in Party Detail Search Dialog
    [Documentation]    This keyword is used get row value of column sHeaderName using sReferenceRowValue from column sReferenceHeaderValue
    ...    @author: clanding    10SEP2020    - initial create
    ...    @author: gagregado    28SEP2020   - created from essence and restructure for Party Details Enquiry search dialog table
    [Arguments]    ${sReferenceHeaderValue}    ${sReferenceRowValue}    ${sHeaderName}    
    
    ### Get Header Index of the Reference Value ###
    ${HeaderCount}    SeleniumLibraryExtended.Get Element Count    ${Party_Search_Dialog_SearchResultTableHeader}
    ${HeaderCount}    Evaluate    ${HeaderCount}+1
    :FOR    ${ReferenceHeaderIndex}    IN RANGE    1    ${HeaderCount}
    \    ${ReferenceHeaderValue}    Get Text    ${Party_Search_Dialog_SearchResultTableHeader}\[${ReferenceHeaderIndex}]//div
    \    Exit For Loop If    '${ReferenceHeaderValue}'=='${sReferenceHeaderValue}'
    
    ### Get Header Index of the Actual Value to be get ###
    ${HeaderCount}    SeleniumLibraryExtended.Get Element Count    ${Party_Search_Dialog_SearchResultTableHeader}
    ${HeaderCount}    Evaluate    ${HeaderCount}+1
    :FOR    ${HeaderIndex}    IN RANGE    1    ${HeaderCount}
    \    ${HeaderValue}    Get Text    ${Party_Search_Dialog_SearchResultTableHeader}\[${HeaderIndex}]//div
    \    Exit For Loop If    '${HeaderValue}'=='${sHeaderName}'
	
                                                                                            
    ${RefRowValueCount}    SeleniumLibraryExtended.Get Element Count    ${Party_Search_Dialog_SearchResultTableRow}//td\[contains(text(),"${sReferenceRowValue}")]/parent::tr/td\[${HeaderIndex}]
	Run Keyword If    ${RefRowValueCount}==0    Run Keyword And Continue On Failure    FAIL    Reference Row Value '${sReferenceRowValue}' not found.
	Return From Keyword If    ${RefRowValueCount}==0    REFNOTFOUND
	${RowValue}    Get Text    ${Party_Search_Dialog_SearchResultTableRow}//td\[contains(text(),"${sReferenceRowValue}")]/parent::tr/td\[${HeaderIndex}]
    
    [Return]    ${RowValue} 
    
   
    
Party Detail Enquiry Search by Dialog
    [Documentation]    This keyword is to perform search in dialog
    ...    @author: gagregado    28SEP2020    - initial create
    
    [Arguments]    ${eInputLocator}    ${sInputVal}

    Mx Input Text    ${eInputLocator}    ${sInputVal}
    Mx Click Element    ${Party_Search_Dialog_Search_Button}
    Wait Until Element Is Visible    ${Party_Search_Dialog_RowSelectedResult}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyDetailsEnquiry-{index}.png



Verify Party Detail Enquiry Search Row Value
    [Documentation]    This keyword is used get row value of and compare with the know value from dataset
    ...    @author: gagregado    28SEP2020    - initial create
    
    [Arguments]    ${sHeaderName}    ${rowKnownValue}    ${keyReferenceValue}    ${keyReferenceHeader}

    
    ${verifiedRowValue}    Get Table Value Containing Row Value in Party Detail Search Dialog     ${keyReferenceHeader}    ${keyReferenceValue}      ${sHeaderName}
    
    Compare Two Strings    ${verifiedRowValue}    ${rowKnownValue}
    

Get Text From Row and Compare
    [Documentation]    This keyword is used get text from element and perform comparison
    ...    @author: gagregado    29SEP2020    - initial create
    
    [Arguments]    ${sKnownValue}    ${locator}
    
    ${RowValue}    Get Text    ${locator}
    Compare Two Strings    ${RowValue}    ${sKnownValue}
   
    

###Updated Party Status Test Case
    
# Verify Party Details Page
    # [Documentation]    This keyword verifies the Party Details under Maintain Party Details Page
    # ...    @author: jdelacru
    # ...    @update: rtarayao    07FEB2020    - deleted validation on amend checkbox
    # Wait Until Element Is Visible    ${FBE_MaintainPartyDetails_PartyID_Field}
    # Wait Until Element Is Visible    ${FBE_MaintainPartyDetails_Search_Button}
    # Wait Until Element Is Visible    ${FBE_MaintainPartyDetails_Next_Button}



# Update Branch, Enterprise Name and Enterprise Business Activity
    # [Documentation]    This keyword
    # ...    @author: jdelacru
    # [Arguments]    ${Party_ID}    ${Branch_Code}    ${Enterprise_Name}    ${Industry_Sector}    ${Business_Activity}    ${Business_Focus}    ${Business_Type}    ${Is_Main_Activity}
    # Mx Input Text    ${FBE_MaintainPartyDetails_PartyID_Field}    ${Party_ID}
    # Mx Click Element    ${FBE_MaintainPartyDetails_Next_Button}
    # Wait Until Page Contains    Enterprise Party
    
    # #Enterprise Party Details
    # Mx Click Element    ${FBE_AssignedBranch_Search_Button}
    # Wait Until Element Is Visible    ${Party_PartyOnboarding_BranchList_Search_Button}
    # Mx Click Element    ${Party_PartyOnboarding_BranchList_Search_Button}
    # Mx Click Element    xpath = //td[following-sibling::td[contains(.,"${Branch_Code}")]]
    # Mx Click Element    ${Party_PartyOnboarding_BranchList_Next_Button}
    # Mx Input Text    ${FBE_EnterpriseName_Textfield}    ${Enterprise_Name}
    
    # #Enterprise Business Activity    
    # Click Button    ${FBE_MaintainBusinessAct_Checkbox}  
    # Wait Until Page Contains    Create Enterprise Business Activity
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}    ${Industry_Sector}
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}    ${Business_Activity}
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessFocus_Dropdown}    ${Business_Focus}
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessType_Dropdown}    ${Business_Type}
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}    ${Is_Main_Activity}
    # Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_SaveRow_Button}
    # Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Next_Button}
    # Mx Click Element    ${Party_Next_Button}
    # Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    # Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}
    
# Update Addresses
    # [Documentation]    This keyword
    # ...    @author: jdelacru
    # [Arguments]    ${Party_ID}    ${Address_Type}    ${Country_Region}    ${Post_Code}    ${Valid_To}    ${State_Province}    ${Town_City}    ${Address_Line_1}    ${Address_Line_2}    
    # ...    ${Address_Line_3}    ${Address_Line_4}    ${Address_Line_5}
    # Mx Input Text    ${FBE_MaintainPartyDetails_PartyID_Field}    ${Party_ID}
    # Mx Click Element    ${FBE_MaintainPartyDetails_Next_Button}
    # Wait Until Page Contains    Enterprise Party
    # #Addresses  
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # Mx Click Element    ${FBE_RelatedItems_Address_Menu}
    # Wait Until Page Contains    Party Address
    # Mx Input Text    ${FBE_PartyAddress_AddressType_Dropdown}    ${Address_Type}
    # Mx Input Text    ${FBE_PartyAddress_Location_Dropdown}    ${Country_Region}
    # Mx Input Text    ${FBE_PartyAddress_PostCode_TextField}    ${Post_Code}
    # Mx Input Text    ${FBE_PartyAddress_ValidTo_DatePicker}    ${Valid_To}
    # Mx Input Text    ${FBE_PartyAddress_StateProvince_Dropdown}    ${State_Province}
    # Mx Input Text    ${FBE_PartyAddress_TownCity_TextField}    ${Town_City}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine1_TextField}    ${Address_Line_1}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine2_TextField}    ${Address_Line_2}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine3_TextField}    ${Address_Line_3}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine4_TextField}    ${Address_Line_4}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine5_TextField}    ${Address_Line_5}
    # Mx Click Element    ${FBE_PartyAddress_SaveRow_Button}
    # Mx Click Element    ${FBE_PartyAddress_Next_Button}
    # Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    # Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}    
    
# Update Bank Party Status
    # [Documentation]    This keyword
    # ...    @author: jdelacru
    # [Arguments]    ${Party_ID}
    # Mx Input Text    ${FBE_MaintainPartyDetails_PartyID_Field}    ${Party_ID}
    # Mx Click Element    ${FBE_MaintainPartyDetails_Next_Button}
    # Wait Until Page Contains    Enterprise Party
    
# Updated Preferred Language
    # [Documentation]    This keyword
    # ...    @author: jdelacru
    # [Arguments]    ${Party_ID}    ${Preferred_Language}
    # Mx Input Text    ${FBE_MaintainPartyDetails_PartyID_Field}    ${Party_ID}
    # Mx Click Element    ${FBE_MaintainPartyDetails_Next_Button}
    # Wait Until Page Contains    Enterprise Party
    
    # #Classification and Indicators - Preferred Language           
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # Mx Click Element    ${FBE_RelatedItems_ClassificationIndicators_Menu}
    # Wait Until Page Contains    Classifications And Indicators
    # Mx Input Text    ${FBE_ClassIndicator_PreferredLanguage_Dropdown}    ${Preferred_Language}
    # Mx Click Element    ${FBE_ClassIndicator_Next_Button}
    # Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    # Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}

# Approve Amendments
    # [Documentation]    This keyword approves the amendments from party update
    # ...    @author: jdelacru    
    # [Arguments]    ${Task_Description}    ${ColumnName}
    # Mx Click Element    ${Party_HomePage_Notification_Icon}
    # Mx Click Element    ${Party_ProcessNotification_NotificationTypes_Referral_RadioButton}
    # Mx Click Element    ${Party_Next_Button}
    # Wait Until Browser Ready State
    # ${Task_ID}    Select Row That Contains Text    ${Task_Description}    ${FBE_open_referral_table}    ${Party_ProcessNotification_ProcessReferrals_Referral_RadioButton}    ${FBE_open_referral_table_cell_4}     ${FBE_open_referral_body_form}
    # Write Data To Excel    PTY001_PartyUpdate    ${ColumnName}    ${rowid}    ${Task_ID}
    # Mx Click Element    ${FBE_Approve_Button}
    # [Return]    ${Task_ID}

# Accept Amendments
    # [Documentation]    This keyword accepts the accepts the approved amendments of the supervisor
    # ...    @author: jdelacru
    # ...    @update: gerhabal    28AUG2019    - increease sleep seconds from 10s to 20s    
    # [Arguments]    ${Task_ID}
    # Sleep    2s
    # Navigate Pending Approval
    # ${Task_ID_from_User}    Select Row That Contains Text    ${Task_ID}    ${FBE_approved_referral_table}    ${FBE_approvals_radio_button}    ${FBE_approved_referral_table_cell_4}    ${FBE_approved_referral_body_form}
    # Mx Click Element    ${Party_Next_Button}
    # Sleep    20s
    # Wait Until Browser Ready State
    # Mx Click Element    ${FBE_CloseActiveTab_Button}

# Validate Amendments for Enterprise Party
    # [Documentation]    This keyword validates all the updates on party
    # ...    @author: jdelacru
    # #Enquire Enterprise Party - Read
    # ${Location}    Read Data From Excel    PTY001_PartyUpdate    Location    ${rowid}
    # ${Branch_Name}    Read Data From Excel    PTY001_PartyUpdate    Branch_Name    ${rowid}
    # ${Enterprise_Name}    Read Data From Excel    PTY001_PartyUpdate    Enterprise_Name    ${rowid}
    # ${Business_Activity}    Read Data From Excel    PTY001_PartyUpdate    Business_Activity    ${rowid}
    # Wait Until Browser Ready State

    # #Enquire Enterprise Party - Validate
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Location}    ${FBE_EnquireEnterpriseParty_Location_Text}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Branch_Name}    ${FBE_EnquireEnterpriseParty_AssignedBranch_Text}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Enterprise_Name}    ${FBE_EnquireEnterpriseParty_EnterpriseName_Text}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Enterprise_Name}    ${FBE_EnquireEnterpriseParty_ShortName_Text}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Business_Activity}    ${FBE_EnquireEnterpriseParty_MaintainBussAct_Text}
    
    # #Business Activity - Read
    # ${Industry_Sector}    Read Data From Excel    PTY001_PartyUpdate    Industry_Sector    ${rowid}
    # ${Business_Focus}    Read Data From Excel    PTY001_PartyUpdate    Business_Focus    ${rowid}
    # ${Business_Type}    Read Data From Excel    PTY001_PartyUpdate    Business_Type    ${rowid}
    # ${Is_Main_Activity}    Read Data From Excel    PTY001_PartyUpdate    Is_Main_Activity    ${rowid}
    
    # #Business Activity - Validate
    # Mx Click Element    ${FBE_EnquireEnterpriseParty_BussAct_View_Button}
    # Wait Until Page Contains    Enquire Enterprise Business Activity
    # Mx Click Element    xpath = //td[following-sibling::td[contains(.,"${Industry_Sector}")]]
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Industry_Sector}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Business_Activity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Business_Focus}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessFocus_Dropdown}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Business_Type}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessType_Dropdown}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Is_Main_Activity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}
    # Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_EnquireEntBusinessAct_Next_Button}
    # Wait Until Page Contains    Enquire Enterprise Party
    
# Validate Amendments for Addresses
    # #Addresses - Read
    # ${Address_Type}    Read Data From Excel    PTY001_PartyUpdate    Address_Type    ${rowid}
    # ${Post_Code}    Read Data From Excel    PTY001_PartyUpdate    Post_Code    ${rowid}
    # ${Country_Region}    Read Data From Excel    PTY001_PartyUpdate    Country_Region    ${rowid}
    # ${Valid_To}    Read Data From Excel    PTY001_PartyUpdate    Valid_To    ${rowid}
    # ${State_Province}    Read Data From Excel    PTY001_PartyUpdate    State_Province    ${rowid}
    # ${Town_City}    Read Data From Excel    PTY001_PartyUpdate    Town_City    ${rowid}
    # ${Address_Line_1}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_1    ${rowid}
    # ${Address_Line_2}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_2    ${rowid}
    # ${Address_Line_3}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_3    ${rowid}
    # ${Address_Line_4}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_4    ${rowid}
    # ${Address_Line_5}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_5    ${rowid}
    
    # #Addresses - Validate
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # Mx Click Element    ${FBE_RelatedItems_Address_Menu}
    # Wait Until Page Contains    Party Address    
    # Mx Click Element    xpath = //td[following-sibling::td[following-sibling::td[contains(.,"${Post_Code}")]]]
    # Wait Until Browser Ready State
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Type}    ${FBE_PartyAddress_AddressType_Dropdown}    
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Post_Code}    ${FBE_PartyAddress_PostCode_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Country_Region}    ${FBE_PartyAddress_Location_Dropdown}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Valid_To}    ${FBE_PartyAddress_ValidTo_DatePicker}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${State_Province}    ${FBE_PartyAddress_StateProvince_Dropdown}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Town_City}    ${FBE_PartyAddress_TownCity_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_1}    ${FBE_EnquirePartyAddress_AddressLine1_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_2}    ${FBE_PartyAddress_AddressLine2_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_3}    ${FBE_PartyAddress_AddressLine3_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_4}    ${FBE_PartyAddress_AddressLine4_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_5}    ${FBE_PartyAddress_AddressLine5_TextField}
    # Mx Click Element    ${FBE_PartyAddress_Next_Button}
    
# Validate Amendments for Classification
    # #Classification and Indicators - Read
    # ${Preferred_Language}    Read Data From Excel    PTY001_PartyUpdate    Preferred_Language    ${rowid}
    
    # #Classification and Indicators - Validate
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # Mx Click Element    ${FBE_RelatedItems_ClassificationIndicators_Menu}
    # Wait Until Page Contains    Classifications And Indicators
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Preferred_Language}    ${FBE_ClassIndicator_PreferredLanguage_Dropdown}
    # Mx Click Element    ${FBE_ClassIndicator_Next_Button}

##============================================================================####
    
# Update Party Details 
    # [Documentation]    This keyword updates the details of Party
    # ...    @author: jdelacru
    # [Arguments]    ${Party_ID}    ${Branch_Code}    ${Location}    ${New_Status}    ${Enterprise_Name}    ${Is_Main_Activity_False}
    # ...    ${Industry_Sector}     ${Business_Activity}    ${Business_Focus}    ${Business_Type}    ${Is_Main_Activity}    ${Preferred_Language}  
    # ...    ${Address_Type}    ${Country_Region}    ${Post_Code}    ${Valid_To}    ${State_Province}    ${Town_City}
    # ...    ${Address_Line_1}    ${Address_Line_2}    ${Address_Line_3}    ${Address_Line_4}    ${Address_Line_5}
    # Mx Input Text    ${FBE_MaintainPartyDetails_PartyID_Field}    ${Party_ID}
    # Mx Click Element    ${FBE_MaintainPartyDetails_Next_Button}
    
    # #Enterprise Party
    # Wait Until Page Contains    Enterprise Party
    # Mx Click Element    ${FBE_AssignedBranch_Search_Button}
    # Wait Until Element Is Visible    ${Party_PartyOnboarding_BranchList_Search_Button}
    # Mx Click Element    ${Party_PartyOnboarding_BranchList_Search_Button}
    # Mx Click Element    xpath = //td[following-sibling::td[contains(.,"${Branch_Code}")]]
    # Mx Click Element    ${Party_PartyOnboarding_BranchList_Next_Button}
    # Mx Input Text    ${FBE_EnterpriseName_Textfield}    ${Enterprise_Name}
    
    # #Bank Party Status
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # Mx Click Element    ${FBE_RelatedItems_BankPartyStatus_Menu}
    # Wait Until Page Contains    Bank Party Status    
    # Mx Input Text    ${FBE_BankPartyStatus_Location_Dropdown}    ${Location}
    # Sleep    1s    
    # Mx Input Text    ${FBE_BankPartyStatus_NewStatus_Dropdown}    ${New_Status}
    # Mx Click Element    ${Party_PartyOnboarding_BranchList_Next_Button}
    # Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    # Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}
    
    # #Enterprise Business Activity    
    # Click Button    ${FBE_MaintainBusinessAct_Checkbox}  
    # Wait Until Page Contains    Create Enterprise Business Activity
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}    ${Industry_Sector}
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}    ${Business_Activity}
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessFocus_Dropdown}    ${Business_Focus}
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessType_Dropdown}    ${Business_Type}
    # Mx Input Text    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}    ${Is_Main_Activity}
    # Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_SaveRow_Button}
    # Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_Next_Button}
    
    # #Classification and Indicators - Preferred Language           
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # Mx Click Element    ${FBE_RelatedItems_ClassificationIndicators_Menu}
    # Wait Until Page Contains    Classifications And Indicators
    # Mx Input Text    ${FBE_ClassIndicator_PreferredLanguage_Dropdown}    ${Preferred_Language}
    # Mx Click Element    ${FBE_ClassIndicator_Next_Button}
    # Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    # Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}   
    
    # #Addresses  
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # Mx Click Element    ${FBE_RelatedItems_Address_Menu}
    # Wait Until Page Contains    Party Address
    # Mx Input Text    ${FBE_PartyAddress_AddressType_Dropdown}    ${Address_Type}
    # Mx Input Text    ${FBE_PartyAddress_Location_Dropdown}    ${Country_Region}
    # Mx Input Text    ${FBE_PartyAddress_PostCode_TextField}    ${Post_Code}
    # Mx Input Text    ${FBE_PartyAddress_ValidTo_DatePicker}    ${Valid_To}
    # Mx Input Text    ${FBE_PartyAddress_StateProvince_Dropdown}    ${State_Province}
    # Mx Input Text    ${FBE_PartyAddress_TownCity_TextField}    ${Town_City}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine1_TextField}    ${Address_Line_1}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine2_TextField}    ${Address_Line_2}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine3_TextField}    ${Address_Line_3}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine4_TextField}    ${Address_Line_4}
    # Mx Input Text    ${FBE_PartyAddress_AddressLine5_TextField}    ${Address_Line_5}
    # Mx Click Element    ${FBE_PartyAddress_SaveRow_Button}
    # Mx Click Element    ${FBE_PartyAddress_Next_Button}
    # Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    # Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}
    
    
    # Mx Click Element    ${Party_Next_Button}
    # Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    # Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}

# Approve Amendments TEMP
    # [Documentation]    This keyword approves the amendments from party update
    # ...    @author: jdelacru
    # [Arguments]    ${Enterprise_Party_Task_Description}    ${Party_Status_Task_Description}    ${Classfication_Indicators_Task_Description}    ${Address_Task_Description}  
    # Mx Click Element    ${Party_HomePage_Notification_Icon}
    # Mx Click Element    ${Party_ProcessNotification_NotificationTypes_Referral_RadioButton}
    # Mx Click Element    ${Party_Next_Button}
    # Wait Until Browser Ready State
    
    # ${Task_ID_For_Enterprise_Party}    Select Row That Contains Text    ${Enterprise_Party_Task_Description}    ${FBE_open_referral_table}    ${Party_ProcessNotification_ProcessReferrals_Referral_RadioButton}    ${FBE_open_referral_table_cell_4}     ${FBE_open_referral_body_form}
    # Write Data To Excel    PTY001_PartyUpdate    Task_ID_For_Enterprise_Party    ${rowid}    ${Task_ID_For_Enterprise_Party}
    # Mx Click Element    ${FBE_Approve_Button}    
    
    
    # # ${Task_ID_For_Party_Status}    Select Row That Contains Text    ${Party_Status_Task_Description}    ${FBE_open_referral_table}    ${Party_ProcessNotification_ProcessReferrals_Referral_RadioButton}    ${FBE_open_referral_table_cell_4}     ${FBE_open_referral_body_form}    
    # # Write Data To Excel    PTY001_PartyUpdate    Task_ID_For_Party_Status    ${rowid}    ${Task_ID_For_Party_Status}
    # # Mx Click Element    ${FBE_Approve_Button}
    
    # ${Task_ID_For_Classfication_Indicators}    Select Row That Contains Text    ${Classfication_Indicators_Task_Description}    ${FBE_open_referral_table}    ${Party_ProcessNotification_ProcessReferrals_Referral_RadioButton}    ${FBE_open_referral_table_cell_4}     ${FBE_open_referral_body_form}
    # Write Data To Excel    PTY001_PartyUpdate    Task_ID_For_Classfication_Indicators    ${rowid}    ${Task_ID_For_Classfication_Indicators}
    # Mx Click Element    ${FBE_Approve_Button}
    
    # ${Task_ID_For_Address}    Select Row That Contains Text    ${Address_Task_Description}    ${FBE_open_referral_table}    ${Party_ProcessNotification_ProcessReferrals_Referral_RadioButton}    ${FBE_open_referral_table_cell_4}     ${FBE_open_referral_body_form}   
    # Write Data To Excel    PTY001_PartyUpdate    Task_ID_For_Address    ${rowid}    ${Task_ID_For_Address}
    # Mx Click Element    ${FBE_Approve_Button}
    

# Accept Amendments TEMP
    # [Documentation]    This keyword accepts the accepts the approved amendments of the supervisor
    # ...    @author: jdelacru
    # ${Task_ID_For_Enterprise_Party}    Read Data From Excel    PTY001_PartyUpdate    Task_ID_For_Enterprise_Party    ${rowid}
    # ${Task_ID_For_Party_Status}    Read Data From Excel    PTY001_PartyUpdate    Task_ID_For_Party_Status    ${rowid}
    # ${Task_ID_For_Classfication_Indicators}    Read Data From Excel    PTY001_PartyUpdate    Task_ID_For_Classfication_Indicators    ${rowid}
    # ${Task_ID_For_Address}    Read Data From Excel    PTY001_PartyUpdate    Task_ID_For_Address    ${rowid}
    
    # Navigate Pending Approval
    
    # #Enterprise Party Details
    # ${Task_ID_From_User}    Select Row That Contains Text    ${Task_ID_For_Enterprise_Party}    ${FBE_approved_referral_table}    ${FBE_ApproveReferrals_RadioButton}    ${FBE_approved_referral_table_cell_4}    ${FBE_approved_referral_body_form}
    # Mx Click Element    ${Party_Next_Button}
    # Wait Until Browser Ready State
    # Mx Click Element    ${FBE_CloseActiveTab_Button}
    # Navigate Pending Approval
    
    # # #Party Status
    # # ${Task_ID_From_User}    Select Row That Contains Text    ${Task_ID_For_Party_Status}    ${FBE_approved_referral_table}    ${FBE_ApproveReferrals_RadioButton}    ${FBE_approved_referral_table_cell_4}    ${FBE_approved_referral_body_form}
    # # Mx Click Element    ${Party_Next_Button}
    # # Wait Until Browser Ready State
    # # Navigate Pending Approval
    
    # #Classification/Indicators
    # ${Task_ID_From_User}    Select Row That Contains Text    ${Task_ID_For_Classfication_Indicators}    ${FBE_approved_referral_table}    ${FBE_ApproveReferrals_RadioButton}    ${FBE_approved_referral_table_cell_4}    ${FBE_approved_referral_body_form}
    # Mx Click Element    ${Party_Next_Button}
    # Wait Until Browser Ready State
    # Mx Click Element    ${FBE_CloseActiveTab_Button}
    # Navigate Pending Approval
    
    # #Address
    # ${Task_ID_From_User}    Select Row That Contains Text    ${Task_ID_For_Address}    ${FBE_approved_referral_table}    ${FBE_ApproveReferrals_RadioButton}    ${FBE_approved_referral_table_cell_4}    ${FBE_approved_referral_body_form}
    # Mx Click Element    ${Party_Next_Button}
    # Wait Until Browser Ready State
    # Mx Click Element    ${FBE_CloseActiveTab_Button}
    
    
Navigate Pending Approval
    [Documentation]    This keyword navigates the process notifications from the notification icon
    ...    @author: jdelacru
    Mx Click Element    ${Party_HomePage_Notification_Icon}
    Mx Click Element    ${Party_ProcessNotification_NotificationTypes_Approval_RadioButton}
    Mx Click Element    ${Party_Next_Button}
    Wait Until Browser Ready State
    
# Validate Amendments TEMP
    # [Documentation]    This keyword validates all the updates on party
    # ...    @author: jdelacru
    # #Enquire Enterprise Party - Read
    # ${Location}    Read Data From Excel    PTY001_PartyUpdate    Location    ${rowid}
    # ${Branch_Name}    Read Data From Excel    PTY001_PartyUpdate    Branch_Name    ${rowid}
    # ${Enterprise_Name}    Read Data From Excel    PTY001_PartyUpdate    Enterprise_Name    ${rowid}
    # ${Business_Activity}    Read Data From Excel    PTY001_PartyUpdate    Business_Activity    ${rowid}
    # Wait Until Browser Ready State

    # #Enquire Enterprise Party - Validate
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Location}    ${FBE_EnquireEnterpriseParty_Location_Text}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Branch_Name}    ${FBE_EnquireEnterpriseParty_AssignedBranch_Text}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Enterprise_Name}    ${FBE_EnquireEnterpriseParty_EnterpriseName_Text}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Enterprise_Name}    ${FBE_EnquireEnterpriseParty_ShortName_Text}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Business_Activity}    ${FBE_EnquireEnterpriseParty_MaintainBussAct_Text}
    
    # #Business Activity - Read
    # ${Industry_Sector}    Read Data From Excel    PTY001_PartyUpdate    Industry_Sector    ${rowid}
    # ${Business_Focus}    Read Data From Excel    PTY001_PartyUpdate    Business_Focus    ${rowid}
    # ${Business_Type}    Read Data From Excel    PTY001_PartyUpdate    Business_Type    ${rowid}
    # ${Is_Main_Activity}    Read Data From Excel    PTY001_PartyUpdate    Is_Main_Activity    ${rowid}
    
    # #Business Activity - Validate
    # Mx Click Element    ${FBE_EnquireEnterpriseParty_BussAct_View_Button}
    # Wait Until Page Contains    Enquire Enterprise Business Activity
    # Mx Click Element    xpath = //td[following-sibling::td[contains(.,"${Industry_Sector}")]]
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Industry_Sector}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IndustrySector_Dropdown}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Business_Activity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessActivity_Dropdown}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Business_Focus}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessFocus_Dropdown}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Business_Type}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_BusinessType_Dropdown}
    # Run Keyword And Continue On Failure   Compare Two Arguments    ${Is_Main_Activity}    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_IsMainActivity_CheckBox}
    # Mx Click Element    ${Party_QuickEnterpriseParty_EnterpriseBusinessActivity_EnquireEntBusinessAct_Next_Button}
    # Wait Until Page Contains    Enquire Enterprise Party
    
    # #Addresses - Read
    # ${Address_Type}    Read Data From Excel    PTY001_PartyUpdate    Address_Type    ${rowid}
    # ${Post_Code}    Read Data From Excel    PTY001_PartyUpdate    Post_Code    ${rowid}
    # ${Country_Region}    Read Data From Excel    PTY001_PartyUpdate    Country_Region    ${rowid}
    # ${Valid_To}    Read Data From Excel    PTY001_PartyUpdate    Valid_To    ${rowid}
    # ${State_Province}    Read Data From Excel    PTY001_PartyUpdate    State_Province    ${rowid}
    # ${Town_City}    Read Data From Excel    PTY001_PartyUpdate    Town_City    ${rowid}
    # ${Address_Line_1}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_1    ${rowid}
    # ${Address_Line_2}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_2    ${rowid}
    # ${Address_Line_3}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_3    ${rowid}
    # ${Address_Line_4}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_4    ${rowid}
    # ${Address_Line_5}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_5    ${rowid}
    
    # #Addresses - Validate
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # Mx Click Element    ${FBE_RelatedItems_Address_Menu}
    # Wait Until Page Contains    Party Address    
    # Mx Click Element    xpath = //td[following-sibling::td[following-sibling::td[contains(.,"${Post_Code}")]]]
    # Wait Until Browser Ready State
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Type}    ${FBE_PartyAddress_AddressType_Dropdown}    
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Post_Code}    ${FBE_PartyAddress_PostCode_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Country_Region}    ${FBE_PartyAddress_Location_Dropdown}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Valid_To}    ${FBE_PartyAddress_ValidTo_DatePicker}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${State_Province}    ${FBE_PartyAddress_StateProvince_Dropdown}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Town_City}    ${FBE_PartyAddress_TownCity_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_1}    ${FBE_EnquirePartyAddress_AddressLine1_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_2}    ${FBE_PartyAddress_AddressLine2_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_3}    ${FBE_PartyAddress_AddressLine3_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_4}    ${FBE_PartyAddress_AddressLine4_TextField}
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Address_Line_5}    ${FBE_PartyAddress_AddressLine5_TextField}
    # Mx Click Element    ${FBE_PartyAddress_Next_Button}
    
    # # #Party Status - Read
    # # ${New_Status}    Read Data From Excel    PTY001_PartyUpdate    New_Status    ${rowid}
    
    # # #Party Status - Validate
    # # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # # Mx Click Element    ${FBE_RelatedItems_BankPartyStatus_Menu}
    # # Wait Until Browser Ready State
    # # Wait Until Page Contains    Bank Party Status Enquiry
    # # Run Keyword And Continue On Failure    Compare Two Arguments    ${New_Status}    ${FBE_BankPartyStatus_PartyStatus_Text}
    # # Mx Click Element    ${FBE_BankPartyStatus_Next_Button}
    
    # #Classification and Indicators - Read
    # ${Preferred_Language}    Read Data From Excel    PTY001_PartyUpdate    Preferred_Language    ${rowid}
    
    # #Classification and Indicators - Validate
    # Wait Until Keyword Succeeds    10x    2s    Mx Click Element    ${FBE_RelatedItems_Down_Arrow}
    # Mx Click Element    ${FBE_RelatedItems_ClassificationIndicators_Menu}
    # Wait Until Page Contains    Classifications And Indicators
    # Run Keyword And Continue On Failure    Compare Two Arguments    ${Preferred_Language}    ${FBE_ClassIndicator_PreferredLanguage_Dropdown}
    # Mx Click Element    ${FBE_ClassIndicator_Next_Button}
    
# Update Party FBE Enterprise 
    # [Arguments]    ${userName}    ${userPassword}    ${userLink}    ${port}    ${partyUrl}    ${selectedModule}    ${partyID}    ${branchCode}    ${enterpriseName}    ${industrySector}
    # ...    ${businessActivity}    ${businessFocus}    ${businessType}    ${isMainActivity}    ${supervisorUserName}    ${supervisorPassword}    ${enterprisePartyTaskDescription}
    # # Login User to Party    ${userName}    ${userPassword}    ${userLink}    ${port}    ${partyUrl}    
    # Navigate Process    ${selectedModule}
    # Verify Party Details Page
    # Update Branch, Enterprise Name and Enterprise Business Activity    ${partyID}    ${branchCode}    ${enterpriseName}    ${industrySector}
    # ...    ${businessActivity}    ${businessFocus}    ${businessType}    ${isMainActivity}
    # Logout User on Party
    # # Login User to Party    ${supervisorUserName}    ${supervisorPassword}    ${userLink}    ${port}    ${partyUrl}
    # ${Task_ID}    Approve Amendments    ${enterprisePartyTaskDescription}    Task_ID_For_Enterprise_Party
    # Logout User on Party
    # # Login User to Party    ${userName}    ${userPassword}    ${userLink}    ${port}    ${partyUrl}
    # Accept Amendments    ${Task_ID}
    # Navigate Party Details Enquiry    ${partyID}
    # Validate Amendments for Enterprise Party
    # Logout User on Party
    
Validate LoanIQ Party FBE Enterprise 
    [Documentation]    This keyword is used to validate the updates from essence party to loan iq
    ...    @author:jaquitan
    [Arguments]    ${rowid}        
    #get data from file
    ${Party_ID}    Read Data From Excel    PTY001_PartyUpdate    Party_ID    ${rowid}
    ${Branch_Name}    Read Data From Excel    PTY001_PartyUpdate    Branch_Name    ${rowid}
    ${Enterprise_Name}    Read Data From Excel    PTY001_PartyUpdate    Enterprise_Name    ${rowid}
    
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    Select Actions    [Actions];Customer
    mx LoanIQ activate window        ${LIQ_CustomerSelect_Window}
    Validate Window Title    Customer Select
    Mx LoanIQ Select Combo Box Value    ${LIQ_CustomerSelect_Search_Filter}      Customer ID
    mx LoanIQ enter    ${LIQ_CustomerSelect_Search_Inputfield}     ${Party_ID}  
    mx LoanIQ click    ${LIQ_CustomerSelect_Search_Button}
    mx LoanIQ click    ${LIQ_CustomerListByCustomerID_OK_ButtonJavaWindow}
    mx LoanIQ activate window    ${LIQ_ActiveCustomer_Window}
   
    #get data from loaniq
    ${liq_partyId}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_CustomerID}    input=liq_partyId
    ${liq_shortName}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_ShortName}    input=liq_shortNam    
    ${liq_legalName}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_LegalName}    input=liq_legalName
    ${liq_branch}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_Branch}    input=liq_branch
    
    #validate data from file and liq
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Party_ID}    ${liq_partyId} 
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Enterprise_Name}    ${liq_shortName} 
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Enterprise_Name}    ${liq_legalName} 
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Branch_Name}    ${liq_branch} 
    
    Mx LoanIQ Select Window Tab    ${LIQ_Active_Customer_Notebook_TabSelection}    SIC
    #get data from file
    ${Business_Activity}    Read Data From Excel    PTY001_PartyUpdate    Business_Activity    ${rowid}
    ${Prefix_for_SIC}    Read Data From Excel    PTY001_PartyUpdate    Prefix_for_SIC    ${rowid}
    #get data from liq
    ${liq_primary}    Mx LoanIQ Get Data    ${LIQ_Active_Customer_Notebook_SICTab_PrimarySICText}    input=liq_primary
    #validate
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Prefix_for_SIC}${SPACE}/${SPACE}${Business_Activity}    ${liq_primary}
    Close All Windows on LIQ

# Update Party FBE Addresses 
    # [Arguments]    ${userName}    ${userPassword}    ${userLink}    ${port}    ${partyUrl}    ${selectedModule}    ${partyID}
    # ...    ${addressType}    ${countryRegion}    ${postCode}    ${validTo}    ${stateProvince}
    # ...    ${townCity}    ${addressLine1}    ${addressLine2}    ${addressLine3}    ${addressLine4}    ${addressLine5}
    # ...    ${supervisorUserName}    ${supervisorPassword}    ${addressTaskDescription}    
    # # Login User to Party    ${userName}    ${userPassword}    ${userLink}    ${port}    ${partyUrl} 
    # Navigate Process    ${selectedModule}
    # Verify Party Details Page
    # Update Addresses    ${partyID}    ${addressType}    ${countryRegion}    ${postCode}    ${validTo}    ${stateProvince}    
    # ...    ${townCity}    ${addressLine1}    ${addressLine2}    ${addressLine3}    ${addressLine4}    ${addressLine5}
    # Logout User on Party
    # # Login User to Party    ${supervisorUserName}    ${supervisorPassword}    ${userLink}    ${port}    ${partyUrl}    
    # ${Task_ID}    Approve Amendments    ${addressTaskDescription}    Task_ID_For_Address
    # Logout User on Party
    # # Login User to Party    ${userName}    ${userPassword}    ${userLink}    ${port}    ${partyUrl}
    # Accept Amendments    ${Task_ID}
    # Navigate Party Details Enquiry    ${partyID}
    # Validate Amendments for Addresses
    # Logout User on Party

Validate LoanIQ Party Addresses 
    [Documentation]    This keyword is used to validate the updates from essence party to loan iq
    ...    @author:jaquitan
    [Arguments]    ${rowid}    ${partyID}
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    Select Actions    [Actions];Customer
    mx LoanIQ activate window    ${LIQ_CustomerSelect_Window}
    Validate Window Title    Customer Select
    Mx LoanIQ Select Combo Box Value    ${LIQ_CustomerSelect_Search_Filter}      Customer ID
    mx LoanIQ enter    ${LIQ_CustomerSelect_Search_Inputfield}    ${partyID}     
    mx LoanIQ click    ${LIQ_CustomerSelect_Search_Button}
    mx LoanIQ click    ${LIQ_CustomerListByCustomerID_OK_ButtonJavaWindow}
    mx LoanIQ activate window    ${LIQ_ActiveCustomer_Window}
    mx LoanIQ select    ${LIQ_Active_Customer_Notebook_OptionsMenu_LegalAddress}
    
    # get data from file
    ${Address_Type}    Read Data From Excel    PTY001_PartyUpdate    Address_Type    ${rowid}
    ${Post_Code}    Read Data From Excel    PTY001_PartyUpdate    Post_Code    ${rowid}
    ${Country_Region}    Read Data From Excel    PTY001_PartyUpdate    Country_Region    ${rowid}
    ${State_Province}    Read Data From Excel    PTY001_PartyUpdate    State_Province    ${rowid}
    ${Town_City}    Read Data From Excel    PTY001_PartyUpdate    Town_City    ${rowid}
    ${Address_Line_1}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_1    ${rowid}
    ${Address_Line_2}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_2    ${rowid}
    ${Address_Line_3}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_3    ${rowid}
    ${Address_Line_4}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_4    ${rowid}
    ${Address_Line_5}    Read Data From Excel    PTY001_PartyUpdate    Address_Line_5    ${rowid}
    
    #get data from liq
    ${liq_addressCode}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_AddressCode}    input=liq_addressCode
    ${liq_postal}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_ZipCostalCode}    input=liq_postal
    ${liq_countryRegion}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_Country}    input=liq_countryRegion
    ${liq_province}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_Province}    input=liq_province
    ${liq_townCity}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_City}    input=liq_townCity
    ${liq_addressLine1}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_Line1}    input=liq_addressLine1
    ${liq_addressLine2}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_Line2}    input=liq_addressLine2
    ${liq_addressLine3}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_Line3}    input=liq_addressLine3
    ${liq_addressLine4}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_Line4}    input=liq_addressLine4
    ${liq_addressLine5}    Mx LoanIQ Get Data    ${LIQ_ViewAddress_Line5}    input=liq_addressLine5
    
    #validate
    ${Address_Type_UpperCase}    Convert To Uppercase    ${Address_Type}     
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Address_Type_UpperCase}    ${liq_addressCode}
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Post_Code}    ${liq_postal}
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Country_Region}    ${liq_countryRegion}
    # Run Keyword And Continue On Failure   Should Be Equal As Strings    ${State_Province}    ${liq_province}    #not yet used due to liq issue
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Town_City}    ${liq_townCity}
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Address_Line_1}    ${liq_addressLine1}
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Address_Line_2}    ${liq_addressLine2}
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Address_Line_3}    ${liq_addressLine3}
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Address_Line_4}    ${liq_addressLine4}
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Address_Line_5}    ${liq_addressLine5}
    mx LoanIQ click    ${LIQ_ViewAddress_Ok_CancelButton}
    Close All Windows on LIQ
    
# Update Party FBE Language    
    # [Arguments]    ${userName}    ${userPassword}    ${userLink}    ${port}    ${partyUrl}    ${selectedModule}    ${partyID}    ${preferredLangauge}    ${supervisorUserName}    ${supervisorPassword}
    # ...    ${classificationIndicatorsTaskDescription}          
    # # Login User to Party    ${userName}    ${userPassword}    ${userLink}    ${port}    ${partyUrl}
    # Navigate Process    ${selectedModule}
    # Verify Party Details Page
    # Updated Preferred Language    ${partyID}    ${preferredLangauge}
    # Logout User on Party
    # # Login User to Party    ${supervisorUserName}    ${supervisorPassword}    ${userLink}    ${port}    ${partyUrl}
    # ${Task_ID}    Approve Amendments    ${classificationIndicatorsTaskDescription}    Task_ID_For_Classfication_Indicators
    # Logout User on Party
    # # Login User to Party    ${userName}    ${userPassword}    ${userLink}    ${port}    ${partyUrl}
    # Accept Amendments    ${Task_ID}
    # Navigate Party Details Enquiry    ${partyID}
    # Validate Amendments for Classification
    # Logout User on Party
    
Validate LoanIQ Party Language    
    [Documentation]    This keyword is used to validate the updates from essence party to loan iq
    ...    @author:jaquitan
    [Arguments]    ${rowid}    ${partyID}
    mx LoanIQ activate window    ${LIQ_Window}
    mx LoanIQ maximize    ${LIQ_Window}
    Select Actions    [Actions];Customer
    mx LoanIQ activate window    ${LIQ_CustomerSelect_Window}
    Validate Window Title    Customer Select
    Mx LoanIQ Select Combo Box Value    ${LIQ_CustomerSelect_Search_Filter}      Customer ID
    mx LoanIQ enter    ${LIQ_CustomerSelect_Search_Inputfield}     ${partyID} 
    mx LoanIQ click    ${LIQ_CustomerSelect_Search_Button}
    mx LoanIQ click    ${LIQ_CustomerListByCustomerID_OK_ButtonJavaWindow}
    mx LoanIQ activate window    ${LIQ_ActiveCustomer_Window}
    
    #get data from file
    ${Preferred_Language}    Read Data From Excel    PTY001_PartyUpdate    Preferred_Language    ${rowid}
    
    #get data from liq
    ${liq_language}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_Language}    input=liq_language
    
    #validate
    Run Keyword And Continue On Failure   Should Be Equal As Strings    ${Preferred_Language}    ${liq_language}
    Close All Windows on LIQ    

Launch PARTY Page
    [Documentation]    This keyword is used to open browser and launch PARTY main page.
    ...    @author: clanding
    ...    @update: clanding    16APR2019    - add message and screenshot
    ...    @update: rtarayao    23OCT2019    - added logic to handle SSO flag
    ...    @update: jdelacru    06NOV2019    - added waiting time after loading landing page
    
    ${PARTY_SSO_URL}    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    Replace Variables    ${PARTY_SSO_URL}
    ${PARTY_URL}    Run Keyword If    '${SSO_ENABLED.upper()}'=='NO'    Replace Variables    ${PARTY_URL}
    
    Run Keyword If    '${SSO_ENABLED.upper()}'=='YES'    Run Keywords    Open Browser    ${PARTY_SSO_URL}    ${BROWSER}
    ...    AND    Maximize Browser Window
    ...    AND    Wait Until Element Is Visible     ${Party_HomePage_Process_TextBox}
    ...    AND    Display Message    Page Successfully loaded.
    ...    AND    Capture Page Screenshot
    ...    ELSE IF    '${SSO_ENABLED.upper()}'=='NO'    Run Keywords    Open Browser    ${PARTY_URL}    ${BROWSER}
    ...    AND    Maximize Browser Window
    ...    AND    Wait Until Element Is Visible     ${Party_Username_Textbox}    30s
    ...    AND    Mx Input Text    ${Party_Username_Textbox}    ${PARTY_USERNAME}
    ...    AND    Mx Input Text    ${Party_Password_Textbox}    ${PARTY_PASSWORD}
    ...    AND    Click Element    ${Party_SignIn_Button}
    ...    AND    Wait Until Element Is Visible     ${Party_HomePage_Process_TextBox}
    ...    AND    Display Message    Page Successfully loaded.  
    ...    AND    Capture Page Screenshot     

Search User ID in Enquire User Page PARTY
    [Documentation]    This keyword is used to search User ID on PARTY main page.
    ...    @author: clanding
    [Arguments]    ${input_userid}    ${input_usertype}    ${input_countrycode}
    Wait Until Element Is Visible     ${Party_HomePage_Process_TextBox}    timeout=20s
    Input Text    ${Party_HomePage_Process_TextBox}    Enquire User
    Press key    ${Party_HomePage_Process_TextBox}   ${Keyboard_Enter}
    


Populate Pre-Existence Check with No Suffix
    [Documentation]    This keyword populates pre-existence check with no suffix condition
    ...    @author: fmamaril    26JUN2019
    [Arguments]    ${sEnterpriseName}
    Mx Click Element     ${Party_PreExistenceCheck_EnterpriseName_TextBox} 
    Set Focus to Element    ${Party_PreExistenceCheck_EnterpriseName_TextBox}
    Mx Activate And Input Text    ${Party_PreExistenceCheck_EnterpriseName_TextBox}    ${sEnterpriseName}   
    Mx Double Click Element    ${Party_Next_Button}
    Mx Double Click Element    ${Party_Next_Button}
    Wait Until Page Contains    Quick Enterprise Party    10s    
       


Verify if Value is Existing then Get Table Row Value
    [Documentation]    This keyword is used get row value of column sHeaderName when page contains value of sField_To_Verify.
    ...    @author: amansuet 18MAR2020    - initial create
    [Arguments]    ${eTableHeaderLocator}    ${eTableRowLocator}    ${eElement_To_Clicked}    ${sField_To_Verify}    ${sHeader_Name}
    
    ### Get Header Index of the Actual Value to get ###
    ${HeaderCount}    SeleniumLibraryExtended.Get Element Count    ${eTableHeaderLocator}
    ${HeaderCount}    Evaluate    ${HeaderCount}+1
    :FOR    ${HeaderIndex}    IN RANGE    1    ${HeaderCount}
    \    ${HeaderValue}    Get Text    ${eTableHeaderLocator}\[${HeaderIndex}]//div
    \    Exit For Loop If    '${HeaderValue}'=='${sHeaderName}'
    
    ### Verify Value is Existing ###
    ${RowCount}    SeleniumLibraryExtended.Get Element Count    ${eTableRowLocator}
    ${RowCount}    Evaluate    ${RowCount}+1
    :FOR    ${Index}    IN RANGE    1    ${RowCount}
    \    log    ${Index}
    \    Mx Click Element    ${eElement_To_Clicked}\[${Index}]//tbody//tr//div
    \    Log     Field to verify is ${sField_To_Verify}
    \    ${status}    Run Keyword And Return Status    Wait Until Page Contains    ${sField_To_Verify}
    \    Exit For Loop If    '${status}'=='${TRUE}'
    
    ${Row_Value}    Get Text    ${eElement_To_Clicked}\[${Index}]//td\[${HeaderIndex}]
    
    [Return]    ${Row_Value}