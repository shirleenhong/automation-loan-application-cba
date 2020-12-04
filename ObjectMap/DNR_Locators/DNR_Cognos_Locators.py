### Login/Logout ###
DNR_Namespace_Dropdown_Locator = '//select[contains(@name,"CAMNamespace")]'
DNR_UserID_Textbox_Locator = '//input[contains(@name,"CAMUsername")]'
DNR_UserID_Password_Locator = '//input[contains(@name,"CAMPassword")]'
DNR_SignIn_Button_Locator = '//button[contains(text(),"Sign in")]'
DNR_PersonalMenu_Button_Locator = '//button[@aria-label="Personal menu"]'
DNR_SignOut_Button_Locator = '//span[text()="Sign out"]'

### Generic ###
DNR_Page_Locator = '//div[contains(text(),"${sPageName}")]'
DNR_Text_Locator = '//span[contains(text(),"‪${sText}")]'
DNR_ReportFolder_Link_Locator = '//div[contains(@title,"${sReport_Name}") and contains(@role,"link")]'
DNR_RootFolder_Locator = '//ul[@class="breadcrumbCompact"]//div[@aria-label="${sText}"]'
DNR_Loading_Indicator_Locator = '//table[contains(@class,"clsViewerProgress")]'

### Home Page ###
DNR_TeamContent_Menu_Button_Locator = '//button[@title="Team content"]'

### Team Content ###
DNR_TeamContent_RootFolder_Locator = '//span[@class="breadCrumbRoot"]'
DNR_TeamContent_CBAReports_FolderLink_Locator = '//div[contains(@title,"CBA Reports") and contains(@role,"link")]'
DNR_TeamContent_CBAReports_ReportLink_Locator = '//div[@title="${sReport_FileName}" and @role="link"]'
DNR_TeamContent_CBAReports_MoreButton_Locator = '//div[@title="${sReport_FileName}" and @role="link"]/following::div[@title="More"]'
DNR_TeamContent_CBAReports_RunAs_Button_Locator = '//span[text()="Run as"]'
DNR_TeamContent_CBAReports_ReportType_RadioButton_Locator = '//div[text()="${sReportType}" and contains(@id,"radioButton")]/preceding::div[contains(@class,"circle radioLeft")]'
DNR_TeamContent_CBAReports_Run_Button_Locator = '//button[@title="Run"]'

### Report Type Filter ###
DNR_TeamContent_CBAReports_ReportType_Frame_Locator = '//iframe[@id="rsIFrameManager_1"]'
DNR_TeamContent_CBAReports_UserRange_Text_Locator = '//span[text()="UserRange"]'
DNR_TeamContent_CBAReports_UserRange_RadioButton_Locator = '//span[text()="UserRange"]'
DNR_TeamContent_CBAReports_FromMonthYear_Calendar_Locator = '//table[contains(@id,"MinValue")]//input'
DNR_TeamContent_CBAReports_FromMonth_Calendar_Locator = '//td[contains(@id,"MinValue") and text()="${sFromMonth}"]'
DNR_TeamContent_CBAReports_ToMonthYear_Calendar_Locator = '//table[contains(@id,"MaxValue")]//input'
DNR_TeamContent_CBAReports_ToMonth_Calendar_Locator = '//td[contains(@id,"MaxValue") and text()="${sToMonth}"]'
DNR_TeamContent_CBAReports_FromDate_Calendar_Locator = '//div[contains(@id,"Workarea_Pane")]//td[contains(@id,"calDay") and contains(@id,"MinValue") and text()="${sFromDay}"]'
DNR_TeamContent_CBAReports_ToDate_Calendar_Locator = '//td[contains(@id,"calDay") and contains(@id,"MaxValue") and text()="${sToDay}"]'
DNR_TeamContent_CBAReports_Branch_Row_Locator = '//tr[contains(@aria-label,"${sBranchCode}")]'
DNR_TeamContent_CBAReports_BranchDescription_Row_Locator = '//tr[contains(@aria-label,"${sBranchDescription}")]'
DNR_TeamContent_CBAReports_ProcessingArea_Row_Locator = '//tr[contains(@aria-label,"${sProcessingArea}")]'
DNR_TeamContent_CBAReports_FinancialCentre_Row_Locator = '//tr[contains(@aria-label,"${sFinancialCentre}")]'
DNR_TeamContent_CBAReports_FinancialCentre_SelectAll_Button_Locator = '//span[contains(text(),"Financial Centre")]/following-sibling::div//a[contains(text(),"Select all")]'
DNR_TeamContent_CBAReports_Cancel_Button_Locator = '//td[@specname="pageFooter"]//button[text()="Cancel"]'
DNR_TeamContent_CBAReports_Back_Button_Locator = '//button[text()="< Back"]'
DNR_TeamContent_CBAReports_Next_Button_Locator = '//button[text()="Next >"]'
DNR_TeamContent_CBAReports_Finish_Button_Locator = '//button[text()="Finish"]'