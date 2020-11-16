*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Perform Bulk Party Upload and Verify If Successful
    [Documentation]    This test case is used to check for successful bulk party uploads.
    ...    @author: nbautist    03NOV2020    - initial create
    [Arguments]    ${ExcelPath}
    
    ### PREREQUISITE ###
    ${Filename_Path}    Create Bulk File for Upload    &{ExcelPath}[Party_Category]    &{ExcelPath}[Party_Type]
    ...    &{ExcelPath}[Party_Sub_Type]    &{ExcelPath}[GST_Liable]    &{ExcelPath}[Assigned_Branch_Code]    &{ExcelPath}[Digital_Banking_Via_Internet]    &{ExcelPath}[Digital_Banking_Via_Mobile]
    ...    &{ExcelPath}[Alternate_Party_ID]    &{ExcelPath}[Business_Country]    &{ExcelPath}[Is_Main_Activity]    &{ExcelPath}[Is_Primary_Activity]    &{ExcelPath}[Franchise_Affinity]
    ...    &{ExcelPath}[Business_Activity]    &{ExcelPath}[Import_Export]    &{ExcelPath}[Industry_Sector]    &{ExcelPath}[Tax_ID_GST_Number]    &{ExcelPath}[GST_Number]    
    ...    &{ExcelPath}[Parent]    &{ExcelPath}[Non_Resident_License_Permit]    &{ExcelPath}[Address_Type]    &{ExcelPath}[Address_Line_1]    
    ...    &{ExcelPath}[Address_Line_2]    &{ExcelPath}[Default_Address]    &{ExcelPath}[Address_Line_3]    &{ExcelPath}[Address_Line_4]    &{ExcelPath}[Town_City]    
    ...    &{ExcelPath}[State_Province]    &{ExcelPath}[Post_Code]    &{ExcelPath}[Line_Of_Business]    &{ExcelPath}[Number_of_Parties]
    ...    &{ExcelPath}[Enterprise_Prefix]    &{ExcelPath}[Short_Name_Prefix]    &{ExcelPath}[Country_Code]    &{ExcelPath}[Party_Type_Code]    &{ExcelPath}[Party_Sub_Type_Code]
    ...    &{ExcelPath}[State_Province_Code]    &{ExcelPath}[Address_Type_Code]    &{ExcelPath}[Industry_Sector_Code]    &{ExcelPath}[Business_Activity_Code]    &{ExcelPath}[Save_Path]
    ### END OF PREREQUISITE ###
        
    ### UPLOADING ###
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    Search Process in Party    &{ExcelPath}[Selected_Module]
    Upload Bulk Party File    ${Filename_Path}
    
    ### VERIFICATION ###
    Search Process In Party    ${PARTY_BULKPARTYUPLOADENQUIRY_PAGETITLE}
    Verify Bulk Party Upload Successful    ${Filename_Path}
    Verify Correct Party Details From Bulk Upload    &{ExcelPath}[Locality]    &{ExcelPath}[Entity]    &{ExcelPath}[Country_of_Tax_Domicile]
    Logout User on Party
    Verify Correct Bulk Party Details In LoanIQ