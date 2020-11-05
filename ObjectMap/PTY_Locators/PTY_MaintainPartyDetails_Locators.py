### Maintain Party Details - Party Details Page ###
Party_MaintainPartyDetails_PartyDetails_PartyId_TextBox = '//input[contains(@id,"partyId") and not(contains(@id, "OffScreen"))]'

### Maintain Party Details - Enterprise Party Page ###
Party_MaintainPartyDetails_EnterpriseParty_RelatedItems_Menu = '//span[contains(@id, "relatedItems") and contains(text(),"Related Items")]'
Party_MaintainPartyDetails_EnterpriseParty_Addresses_MenuItem = '//td[contains(@id, "Addresses") and contains(text(),"Addresses")]'
Party_MaintainPartyDetails_EnterpriseParty_BusinessActivity_Checkbox = '//input[contains(@id,"businessActivity") and @type="checkbox"]'
Party_MaintainPartyDetails_EnterpriseParty_GTS_AddChange_Button = '//div[contains(@id,"TheGoods&ServiceTaxDetails")]//following::input[contains(@name, "Add/Change")]'

### Party Address Dialog ###
Party_MaintainPartyDetails_PartyAddress_AddressType_Dropdown = '//input[contains (@id, "partyAddressSpecDetails:addressType")]'
Party_MaintainPartyDetails_PartyAddress_AddressCountry_Dropdown = '//input[contains (@id, "partyAddressDetail:country")]'
Party_MaintainPartyDetails_PartyAddress_PostCode_Textbox = '//input[contains (@id, "partyAddressDetail:postCode")]'
Party_MaintainPartyDetails_PartyAddress_State_Dropdown = '//input[contains (@id, "partyAddressDetail:addressLine") and @type="combo"]'
Party_MaintainPartyDetails_PartyAddress_Town_Textbox = '//input[contains (@id, "partyAddressDetail:townOrCity")]'
Party_MaintainPartyDetails_PartyAddress_AddressLine1_Textbox = '//input[contains (@id, "partyAddressDetail:addressLine1") and @type="text" and not(contains(@type, "hidden"))]'
Party_MaintainPartyDetails_PartyAddress_AddressLine2_Textbox = '//input[contains (@id, "partyAddressDetail:addressLine2") and @type="text" and not(contains(@type, "hidden"))]'
Party_MaintainPartyDetails_PartyAddress_AddressLine3_Textbox = '//input[contains (@id, "partyAddressDetail:addressLine3") and @type="text" and not(contains(@type, "hidden"))]'
Party_MaintainPartyDetails_PartyAddress_AddressLine4_Textbox = '//input[contains (@id, "partyAddressDetail:addressLine4") and @type="text" and not(contains(@type, "hidden"))]'
Party_MaintainPartyDetails_PartyAddress_AddressLine5_Textbox = '//input[contains (@id, "partyAddressDetail:addressLine5") and @type="text" and not(contains(@type, "hidden"))]'
Party_MaintainPartyDetails_PartyAddress_RemoveRow_Button = '//div[@role="dialog"]//button[contains(@id, "removeRow")]'
Party_MaintainPartyDetails_PartyAddress_NewRow_Button = '//div[@role="dialog"]//button[contains(@id, "addRow")]'

### Good & Service Tax Details ###
Party_MaintainPartyDetails_GTSDetails_TaxCountry_Dropdown = '//div[@role="dialog"]//input[contains(@id, "taxCountry")]'
Party_MaintainPartyDetails_GTSDetails_GTSNumber_Textbox = '//div[@role="dialog"]//input[contains(@id, "taxIdRef")]'

### Maintain Party Details - Amend Successful Page ###
Party_MaintainPartyDetails_AmendSuccessful_Next_Button = '//div[contains(@process_name, "MaintainParty")]/following-sibling::div[contains(@class, "footerbuttons")]/input'