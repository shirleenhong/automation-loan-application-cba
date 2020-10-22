### Party Login Page ###
Party_LoginPage_Form = '//form[@id="loginForm"]'
Party_Username_Textbox = '//input[@id="username"]'
Party_Password_Textbox = '//input[@id="password"]'
Party_SignIn_Button = '//input[@id="login"]'
Party_Search = '//input[@name="Search..."]'


### Party Dialog Search ###
Party_Search_Dialog_Search_Button = '//span[contains(@class,"Dialog")][text()="Party Search"]/ancestor::div/descendant::input[@uitype="Button"][@name="Search"]'
Party_Search_Dialog = '//span[contains(@class,"Dialog")][text()="Party Search"]'
Party_Search_Dialog_Branch = '//input[contains(@id,"Branch")][@type="combo"]'
Party_Search_Dialog_PatyID = '//div[@role="dialog"]/descendant::*[text()="Party ID"][@uitype="Label"]/../following-sibling::td/following-sibling::td/following-sibling::td/descendant::input[contains(@name,"partyId")]'
Party_Search_Dialog_PartyName='//div[@role="dialog"]/descendant::input[contains(@name,"partySearchKey")][contains(@name,"name")][not(contains(@name,"nameType"))]'
Party_Search_Dialog_PartyType = '//input[contains(@id,"partyType")][@type="combo"]' 
Party_Search_Dialog_PartySubType = '//input[contains(@id,"partySubType")][@type="combo"]'
Party_Search_Dialog_RowSelectedResult = '//div[contains(@class,"GridRow")][contains(@class,"GridRowSelected")]'

Party_Search_Dialog_LineOfBusiness = '//input[contains(@id,"LineOfBusiness")][@type="combo"]'
Party_Search_Dialog_PartyCategory = '//input[contains(@id,"partyCategory")][@type="combo"]'
Party_Search_Dialog_AccountType = '//input[contains(@id,"Account")][@type="combo"]'

Party_Search_Dialog_SearchResultTableHeader = '//span[contains(@class,"Dialog")][text()="Party Search"]/ancestor::div//div[contains(@uitype,"Table")]//div[contains(@class,"GridMasterHeader")]//th'
Party_Search_Dialog_SearchResultTableRow = '//span[contains(@class,"Dialog")][text()="Party Search"]/ancestor::div//div[contains(@uitype,"Table")]//div[contains(@class,"GridMasterView")]//tr'


### Party Home Page ###
Party_HomePage_Process_TextBox = '//input[@id="uxpMenuSearch"]'
Party_HomePage_Notification_Icon = '//span[@id="notification-icon" and @role="button"]'
Party_HomePage_ProcessName_MenuItem = '//div[contains(@class,"MenuItem")]//span[text()="${sProcess_Name}"]'
Party_HomePage_ProcessName_Tab = '//span[@class="tabLabel"][@title="${sProcess_Name}"]'
Party_HomePage_HelpMenu_Button = '//span[@id="uxpHelpMenu"]'
Party_HomePage_HelpMenu_Logout_Button = '//td[@id="logoutButton_text"]'

Party_Next_Button = '//input[@name="Next"]'
Party_Page_Title = '//div[@class="ux-form-title"][text()="${sPage_Name}"]'
Party_CloseDialog_Button = '//span[contains(@title,"Cancel") and @role="button"]'
Party_Dialog_SaveRow_Button = '//div[@role="dialog"]//button[contains(@id, "saveRow")]'
Party_Dialog_Next_Button = '//div[@role="dialog"]//input[contains(@id, "Next")]'
Party_Footer_Next_Button = '//div[contains(@class,"Visible")]//child::input[contains(@id,"Next")]'

Party_RaisedMessage_Notification = '//div[@class="message" and contains(text(),"Referral raised")]'
Party_Approve_Button = '//input[contains(@id, "Approve")]'
Party_Reject_Button = '//input[contains(@id, "Reject")]'
Party_Refer_Button = '//input[contains(@id, "Refer")]'
Party_Zone_Button = '//div[@title="Bank, Zone, Branch information"]//span//strong[contains(text(),"Zone")]'

### Generic Locator ###
Party_Loading_Image = '//div[@id="preloaderGlobal"]//img[@alt="Processing"]'

### Zone and Branch Selection ###
Party_ZoneBranchSelectionPage_Zone_TextBox = '//input[contains(@id,"zone")]'
Party_ZoneBranchSelectionPage_Branch_TextBox = '//input[contains(@id,"BrchName")]'
Party_ZoneBranchSelectionPage_CloseTab_Button = '//span[contains(@id,"ConfigureZoneBranchMF")]/following-sibling::span[@title="Close"]'
Party_ZoneBranchSelectionPage_SuccessMessage_Label = '//input[contains(@id,"showmessage") and @value="Zone/Branch Switched Successfully"]'

### Error Dialog ###
Party_Error_Dialog = '//div[contains(@id,"ERROR") and @role="dialog"]'
Party_Error_Ok_Button = '//div[contains(@id,"ERROR") and @role="dialog"]//descendant::input[@type="button" and @name="Ok"]'