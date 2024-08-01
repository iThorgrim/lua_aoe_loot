local config = {
	Prefix = "AOELoot",
	Functions = { 
		[1] = "OnStatusChange"
	}
}

AOE_LOOT_STATUS = AOE_LOOT_STATUS or false;

--[[ local "dry" function ]]--
local function SetAndSendStatus(self)
	self:SetChecked(AOE_LOOT_STATUS);
	SendClientRequest(config.Prefix, 1, AOE_LOOT_STATUS);
end

--[[ Build option ]]--
local InterfaceOptionsControlsPanelAoeLoot = CreateFrame("CheckButton", "InterfaceOptionsControlsPanelAoeLoot_GlobalName", InterfaceOptionsControlsPanel, "ChatConfigCheckButtonTemplate");
InterfaceOptionsControlsPanelAoeLoot:SetPoint("TOPLEFT", InterfaceOptionsControlsPanelAutoLootCorpse, "BOTTOMLEFT", 0, -8);
InterfaceOptionsControlsPanelAoeLoot:RegisterEvent("ADDON_LOADED");
InterfaceOptionsControlsPanelAoeLoot:Hide();

InterfaceOptionsControlsPanelAoeLoot:SetScript("OnEvent", function(self, event, addon)
	if (event == "ADDON_LOADED" and addon == "AOE_Loot") then
		SetAndSendStatus(self);
	end
end);

InterfaceOptionsControlsPanelAoeLoot:SetScript("OnShow", function(self)
	SetAndSendStatus(self);
end);

InterfaceOptionsControlsPanelAoeLoot:SetScript("OnClick", function(self)
	AOE_LOOT_STATUS = not AOE_LOOT_STATUS;
	SetAndSendStatus(self);
end);

InterfaceOptionsControlsPanelAutoLootKeyDropDown:SetPoint("TOPLEFT", InterfaceOptionsControlsPanelAoeLoot, "BOTTOMLEFT", -13, -24);
InterfaceOptionsControlsPanelAutoLootCorpse:SetScript("OnShow", function(self)
	InterfaceOptionsControlsPanelAoeLoot:Show();
end);

InterfaceOptionsControlsPanelAutoLootCorpse:SetScript("OnHide", function(self)
	InterfaceOptionsControlsPanelAoeLoot:Hide();
end);

--[[ Option locale ]]--
local locale_switch = {
	["frFR"] = { title = " Ramassage de zone", 	tooltip = "Fouille plusieurs cadavres à la fois dans un rayon de 50 mètres." },
	["enUS"] = { title = " Aoe loot", 			tooltip = "Loot all corpses at once within a 50-meter radius." };
}
local locale = locale_switch[GetLocale()] or locale_switch["enUS"];

InterfaceOptionsControlsPanelAoeLoot.tooltip = locale.tooltip;
InterfaceOptionsControlsPanelAoeLoot_GlobalNameText:SetText(locale.title);