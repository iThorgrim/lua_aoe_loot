local AIO = AIO or require("AIO");
local AddonHandler = AIO.AddHandlers("AOELoot", {});

if AIO.AddAddon() then
    function AddonHandler.OnStatusChange(player, status)
        player:SetData("AOE_LOOT_STATUS", status and true or false)
    end
else
    AOE_LOOT_STATUS = AOE_LOOT_STATUS or false;
    AIO.AddSavedVarChar("AOE_LOOT_STATUS");

    --[[ local "dry" function ]]--
    local function SetAndSendStatus(self)
        self:SetChecked(AOE_LOOT_STATUS);
        AIO.Handle("AOELoot", "OnStatusChange", AOE_LOOT_STATUS);
    end

    --[[ Build option ]]--
    local InterfaceOptionsControlsPanelAoeLoot = CreateFrame("CheckButton", "InterfaceOptionsControlsPanelAoeLoot_GlobalName", InterfaceOptionsControlsPanel, "ChatConfigCheckButtonTemplate");
    InterfaceOptionsControlsPanelAoeLoot:SetPoint("TOPLEFT", InterfaceOptionsControlsPanelAutoLootCorpse, "BOTTOMLEFT", 0, -8);
    InterfaceOptionsControlsPanelAoeLoot:Hide();
    SetAndSendStatus(InterfaceOptionsControlsPanelAoeLoot);

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
end