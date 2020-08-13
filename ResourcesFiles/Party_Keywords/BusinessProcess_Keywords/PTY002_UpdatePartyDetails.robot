*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot


*** Variables ***
${rowid}    1

*** Keywords ***
Update Party Details in Maintain Party Details Module
    [Documentation]    This keyword is used to update Party/Customer via Maintain Party Details Module.
    ...    @author: dahijara    27APR2020    - initial create.
    [Arguments]    ${ExcelPath}
    
    ### INPUTTER ###

    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 
    
    Search Process in Party    &{ExcelPath}[Selected_Module]

    Search Party ID in Party Details Page    &{ExcelPath}[Party_ID]

    Update Party Details in Enterprise Party Page    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Enterprise_Name]
    ...    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Short_Name]
    ...    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]
    ...    &{ExcelPath}[GST_Number]

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser
    
    ### SUPERVISOR ###
    ${Task_ID_From_Supervisor}    Approve Party via Supervisor Account    &{ExcelPath}[Party_ID]
    
    # ### INPUTTER ###
    Accept Approved Updated Party and Validate Details in Enterprise Party Screen    ${Task_ID_From_Supervisor}    &{ExcelPath}[Locality]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Party_Category]    &{ExcelPath}[Party_ID]    &{ExcelPath}[Enterprise_Name]
    ...    &{ExcelPath}[Registered_Number]    &{ExcelPath}[Country_of_Registration]    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Short_Name]
    ...    &{ExcelPath}[Business_Country]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]
    ...    &{ExcelPath}[GST_Number]

    ############################

    ### INPUTTER ###

    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 
    
    Search Process in Party    &{ExcelPath}[Selected_Module]

    Search Party ID in Party Details Page    &{ExcelPath}[Party_ID]

    Update Address Details in Enterprise Party Page    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[State_Province]    &{ExcelPath}[Town_City]
    ...    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    &{ExcelPath}[Address_Line_5]

    Run Keyword If    '${SSO_ENABLED}'=='NO'    Logout User on Party
    Close Browser
    
    ### SUPERVISOR ###
    ${Task_ID_From_Supervisor}    Approve Party via Supervisor Account    &{ExcelPath}[Party_ID]
    
    # ### INPUTTER ###
    Accept Approved Updated Party and Validate Address Details in Enterprise Party    ${Task_ID_From_Supervisor}    &{ExcelPath}[Party_ID]    &{ExcelPath}[Address_Type]    &{ExcelPath}[Country_Region]    &{ExcelPath}[Post_Code]    &{ExcelPath}[State_Province]    &{ExcelPath}[Town_City]
    ...    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    &{ExcelPath}[Address_Line_5]    &{ExcelPath}[Selected_Module]


    Validate Party Details in Loan IQ    &{ExcelPath}[Party_ID]    &{ExcelPath}[Short_Name]    &{ExcelPath}[Enterprise_Name]    &{ExcelPath}[GST_Number]    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Business_Country]
    ...    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Town_City]    &{ExcelPath}[Country_of_Registration]
    ...    &{ExcelPath}[Country_of_Tax_Domicile]    &{ExcelPath}[Post_Code]    