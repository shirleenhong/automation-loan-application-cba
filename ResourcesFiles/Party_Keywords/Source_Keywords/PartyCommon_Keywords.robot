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
    ...    @update: gabgrgado   01OCT2020    - added waits while waiting for party id field to be editable
    [Arguments]    ${sParty_id}
    Input Text    ${Party_HomePage_Process_TextBox}    Party Details Enquiry
    Press Keys    ${Party_HomePage_Process_TextBox}    RETURN
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    10x    2s     Mx Input Text    ${Party_EnquireEnterpriseParty_PartyId_Text}     ${sParty_id}
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
    
Navigate Maintain Party Details
    [Documentation]    This keyword navigates the user to Maintain Party Details page.
    ...    @author: nbautist
    [Arguments]    ${sParty_id}
    Input Text    ${Party_HomePage_Process_TextBox}    ${PARTY_MAINTAIN_PARTY_DETAILS_PAGETITLE}
    Press Keys    ${Party_HomePage_Process_TextBox}    RETURN
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    10x    2s     Mx Input Text    ${Party_EnquireEnterpriseParty_PartyId_Text}     ${sParty_id}
    Wait Until Browser Ready State
    Wait Until Element Is Visible    ${Party_EnquireEnterpriseParty_Next_Button}
    Wait Until Element Is Enabled    ${Party_EnquireEnterpriseParty_Next_Button}       
    Mx Click Element    ${Party_EnquireEnterpriseParty_Next_Button}
    Wait Until Browser Ready State
    Wait Until Page Contains    ${PARTY_MAINTAIN_PARTY_DETAILS_PAGETITLE}    20s

Select Row That Contains Text
    [Documentation]    This keyword concatenates current date as a unique 7 numeric test data
    ...    @update: gbagregado    30SEPT2020    - add documentation  
    [Arguments]    ${sField_to_verify}    ${sTable_name}    ${sElement_to_be_clicked}    ${sContains_cell_text}    ${sElement_to_activate}

    ${iTable_length}    SeleniumLibraryExtended.Get Element Count    ${sTable_name}
    :FOR   ${i}    IN RANGE    1   ${iTable_length}+1
    \    ${index}    Set Variable    [${i}]
    \    log    ${index}
    \    Mx Click Element    ${sElement_to_be_clicked}${index}
    \    Log     Field to verify is ${sField_to_verify}
    \    ${sStatus}    Run Keyword And Return Status    Wait Until Page Contains    ${sField_to_verify}
    \    Exit For Loop If    '${sStatus}'=='True'
    Mx Click Element    ${sElement_to_activate}
    ${cell_text}    Get Text    ${sContains_cell_text}
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

Get Text From Row and Compare
    [Documentation]    This keyword is used get text from element and perform comparison
    ...    @author: gagregado    29SEP2020    - initial create
    
    [Arguments]    ${sKnownValue}    ${sLocator}
    
    ${sRowValue}    Get Text    ${sLocator}
    Compare Two Strings    ${sRowValue}    ${sKnownValue}

Generate New Enterprise Name And Return Values
    [Documentation]    This keyword is used to generate unique enterprise name and return values
    ...    @author: javinzon    22SEP2020    - intial create 
    [Arguments]        ${sEnterprise_Prefix}
    
    ${Generated_Value}    Generate Unique Number or Text for Party
    ${New_Enterprise_Name}    Catenate    ${sEnterprise_Prefix}    ${Generated_Value}
    [return]    ${New_Enterprise_Name}    ${Generated_Value}
    
Navigate Pending Approval
    [Documentation]    This keyword navigates the process notifications from the notification icon
    ...    @author: jdelacru
    Mx Click Element    ${Party_HomePage_Notification_Icon}
    Mx Click Element    ${Party_ProcessNotification_NotificationTypes_Approval_RadioButton}
    Mx Click Element    ${Party_Next_Button}
    Wait Until Browser Ready State   

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
    ${liq_shortName}    Mx LoanIQ Get Data    ${LIQ_ActiveCustomer_Window_ShortName}    input=liq_shortName    
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
    
Get Table Value Containing Row Value in Party
    [Documentation]    This keyword is used get row value of column sHeaderName using sReferenceRowValue from column sReferenceHeaderValue
    ...    @author: javinzon    30SEP2020    - initial create
    [Arguments]    ${eTableHeaderLocator}    ${eTableRowLocator}    ${sReferenceHeaderValue}    ${sReferenceRowValue}    ${sHeaderName}    
    
    ### Get Header Index of the Reference Value ###
    ${HeaderCount}    SeleniumLibraryExtended.Get Element Count    ${eTableHeaderLocator}
    ${HeaderCount}    Evaluate    ${HeaderCount}+1
    :FOR    ${ReferenceHeaderIndex}    IN RANGE    1    ${HeaderCount}
    \    ${ReferenceHeaderValue}    Get Text    ${eTableHeaderLocator}\[${ReferenceHeaderIndex}]//div
    \    Exit For Loop If    '${ReferenceHeaderValue}'=='${sReferenceHeaderValue}'
    
    ### Get Header Index of the Actual Value to be get ###
    ${HeaderCount}    SeleniumLibraryExtended.Get Element Count    ${eTableHeaderLocator}
    ${HeaderCount}    Evaluate    ${HeaderCount}+1
    :FOR    ${HeaderIndex}    IN RANGE    1    ${HeaderCount}
    \    ${HeaderValue}    Get Text    ${eTableHeaderLocator}\[${HeaderIndex}]//div
    \    Exit For Loop If    '${HeaderValue}'=='${sHeaderName}'
	
    ${RefRowValueCount}    SeleniumLibraryExtended.Get Element Count    ${eTableRowLocator}//td\[contains(text(),"${sReferenceRowValue}")]/parent::tr/td\[${HeaderIndex}]
	Run Keyword If    ${RefRowValueCount}==0    Run Keyword And Continue On Failure    FAIL    Reference Row Value '${sReferenceRowValue}' not found.
	Return From Keyword If    ${RefRowValueCount}==0    REFNOTFOUND
	${RowValue}    Get Text    ${eTableRowLocator}//td\[contains(text(),"${sReferenceRowValue}")]/parent::tr/td\[${HeaderIndex}]
    
    [Return]    ${RowValue}    
    
Navigate Amend User
    [Documentation]    This keyword navigates the user to Amend User page.
    ...    @author: nbautist    23OCT2020    - initial creation
    [Arguments]    ${sUser_ID}
    
    Input Text    ${Party_HomePage_Process_TextBox}    ${PARTY_AMEND_USER_PAGETITLE}
    Press Keys    ${Party_HomePage_Process_TextBox}    RETURN
    Wait Until Browser Ready State
    Wait Until Keyword Succeeds    10x    2s     Mx Input Text    ${Party_AmendUser_UserId_TextBox}     ${sUser_ID}
    Wait Until Browser Ready State
    Wait Until Element Is Visible    ${Party_AmendUser_Next_Button}
    Wait Until Element Is Enabled    ${Party_AmendUser_Next_Button}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Party_AmendUser_SearchUser_Dialog_TitleBar}
    Run Keyword If    ${status}==${True}    Mx Click Element    ${Party_AmendUser_Next_Button}
    Wait Until Browser Ready State
    Wait Until Page Contains    ${PARTY_AMEND_USER_PAGETITLE}    20s
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/AmendUserPage-{index}.png
    
Remove Associated Zone from User
    [Documentation]    This keyword removes an associated zone from the user.
    ...    @author: nbautist    23OCT2020    - initial creation
    [Arguments]    ${sZone}
    
    ${sZone}    Replace Variables    ${sZone}
    ${Party_AmendUser_Remove_Zone_Locator}    Replace Variables    ${Party_AmendUser_Remove_Zone_Locator}
    Mx Click Element    ${Party_AmendUser_Remove_Zone_Locator}
    Mx Click Element    ${Party_AmendUser_Remove_Row_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/AmendUserPage-{index}.png
    Mx Click Element    ${Party_AmendUser_Next_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/AmendUserPage-{index}.png
    
Add Associated Zone To User
    [Documentation]    This keyword adds an associated zone to the user.
    ...    @author: nbautist    26OCT2020    - initial creation
    [Arguments]    ${sUserZone}    ${sUserBranch}
    
    Mx Click Element    ${Party_AmendUser_New_Row_Button}
    Mx Input Text    ${Party_AmendUser_New_Zone_TextBox}    ${sUserZone}
    Mx Input Text    ${Party_AmendUser_New_BranchName_TextBox}    ${sUserBranch}
    Mx Click Element    ${Party_AmendUser_Save_Row_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/AmendUserPage-{index}.png
    Mx Click Element    ${Party_AmendUser_Next_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/AmendUserPage-{index}.png

Change Default Zone
    [Documentation]    This keyword changes the default zone of the user.
    ...    @author: nbautist    27OCT2020    - initial creation
    [Arguments]    ${sUserZone}
    
    Mx Click Element    ${Party_AmendUser_Default_Zone_Search_Button}
    Wait Until Element Is Visible    ${Party_AmendUser_Select_Zone_Branch_Dialog_Title}    20s
    Mx Input Text    ${Party_AmendUser_Select_Zone_Branch_Textbox}    ${sUserZone}
    Mx Click Element    ${Party_AmendUser_Select_Zone_Branch_Next_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/AmendUserPage-{index}.png

Restore Default Zone
    [Documentation]    This keyword changes the default zone of the user.
    ...    @author: nbautist    27OCT2020    - initial creation
    [Arguments]    ${sUserZone}
    
    Change Default Zone    ${sUserZone}
    Mx Click Element    ${Party_AmendUser_Next_Button}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/AmendUserPage-{index}.png
    
Get Default Zone
    [Documentation]    This keyword gets the default zone of the user.
    ...    @author: nbautist    27OCT2020    - initial creation
    
    ${Value}    SeleniumLibraryExtended.Get Element Attribute    ${Party_AmendUser_Default_Zone_Selected}    value
    ${Items_Raw}    SeleniumLibraryExtended.Get Element Attribute    ${Party_AmendUser_Default_Zone_Items}    data
    ${Items_Raw}    Fetch From Right    ${Items_Raw}    items: [
    ${Items}    Fetch From Left    ${Items_Raw}    ]}
    ${Count}    Get Count   ${Items}    03description
    ${Count}    Evaluate    ${Count}+1    

    :FOR    ${Index}    IN RANGE    1    ${Count}
    \    ${Country_Pair}    Fetch From Left    ${Items}    ,{
    \    ${Items}    Remove String    ${Items}    ${Country_Pair}
    \    ${Items}    Strip String    ${Items}    mode=left    characters=,
    \    ${Country_Pair}    Replace String    ${Country_Pair}    ""    "None"
    \    ${Country_Pair_Dictionary}    Evaluate    ${Country_Pair}
    \    ${Country_Code}    Get From Dictionary    ${Country_Pair_Dictionary}    03referenceID
    \    ${Zone}    Run Keyword If    "${Country_Code}"=="${Value}"    Get From Dictionary    ${Country_Pair_Dictionary}    03description
    \    Exit For Loop If    '${Zone}'!='${None}'

    [Return]    ${Zone}

Enter Short Name and Validate Duplicate Error
    [Documentation]    This keyword enters the short name in Maintain Party Details and validates if changes can be sent for approval or will prompt duplicate short name error
    ...    @author: nbautist    29OCT2020    - initial creation
    [Arguments]    ${Short_Name}
    
    Mx Input Text    ${Party_QuickEnterpriseParty_ShortName_TextBox}    ${Short_Name}
    Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/MaintainPartyDetailsPage-{index}.png
    Mx Click Element    ${Party_Footer_Next_Button}
    
    ### Approval Required Dialog ###
    ${isApprovalRequired}    Run Keyword And Return Status    Wait Until Page Contains Element    ${Party_QuickEnterpriseParty_ApprovalRequired_Dialog}    30s
    Run Keyword If    ${isApprovalRequired}==${True}    Run Keywords	Capture Page Screenshot    ${screenshot_path}/Screenshots/Party/PartyApprovalDialog-{index}.png
    ...    AND	    Mx Click Element    ${Party_QuickEnterpriseParty_AskForApproval_Button}
    ...    AND	    Wait Until Page Contains Element    ${Party_RaisedMessage_Notification}
    ...    ELSE    Validate Error Message in Quick Enterprise Party    ${DUPLICATE_SHORTNAME_ERROR_MESSAGE}