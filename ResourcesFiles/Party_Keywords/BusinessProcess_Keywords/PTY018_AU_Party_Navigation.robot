*** Settings ***
Resource    ../../../Configurations/Party_Import_File.robot

*** Keywords ***
Update Regions For User And Restore User Details
        [Documentation]    This keyword is used to check if zone can be removed successfully from user.
    ...    @author: nbautist    22OCT2020    - initial create
    [Arguments]    ${ExcelPath}
        
    ### Removal of zone from the user by the supervisor
    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL} 
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    Navigate Amend User    ${PARTY_USERNAME}
    Remove Associated Zone from User    &{ExcelPath}[AddRemove_UserZone]
    Logout User on Party
    ### Login as user to validate removed zone
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    Verify Zone Visibility in Zone Dropdown List    &{ExcelPath}[AddRemove_UserZone]    ${False}
    Logout User on Party
    
    ### Restore the removed zone by the supervisor
    Login User to Party    ${PARTY_SUPERVISOR_USERNAME}    ${PARTY_SUPERVISOR_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    Configure Zone and Branch    &{ExcelPath}[UserZone]    &{ExcelPath}[UserBranch]
    Navigate Amend User    ${PARTY_USERNAME}
    Add Associated Zone To User    &{ExcelPath}[AddRemove_UserZone]    &{ExcelPath}[AddRemove_UserBranch]
    Logout User on Party
    ### Login as user to validate restored zone
    Login User to Party    ${PARTY_USERNAME}    ${PARTY_PASSWORD}    ${USER_LINK}    ${USER_PORT}    ${PARTY_URL_SUFFIX}    ${PARTY_HTML_USER_CREDENTIALS}    ${SSO_ENABLED}    ${PARTY_URL}
    Verify Zone Visibility In Zone Dropdown List    &{ExcelPath}[AddRemove_UserZone]    ${True}
    Logout User on Party
    