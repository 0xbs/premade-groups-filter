-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2026 Bernhard Saumweber
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-------------------------------------------------------------------------------

local PGF = select(2, ...)
local L = PGF.L
local C = PGF.C

local PGFSettings = CreateFrame("Frame", "PremadeGroupsFilterSettingsFrame", nil, "PremadeGroupsFilterSettingsTemplate")
local reloadSettingsOnOpen = {}

local PGFSettingsTable = {
    {
        key = "dialogMovable",
        type = "checkbox",
        title = L["settings.dialogMovable.title"],
        tooltip = L["settings.dialogMovable.tooltip"],
        visible = true,
    },
    {
        key = "classNamesInTooltip",
        type = "checkbox",
        title = L["settings.classNamesInTooltip.title"],
        tooltip = L["settings.classNamesInTooltip.tooltip"],
        visible = true,
    },
    {
        key = "coloredGroupTexts",
        type = "checkbox",
        title = L["settings.coloredGroupTexts.title"],
        tooltip = L["settings.coloredGroupTexts.tooltip"],
        visible = true,
    },
    {
        key = "compactListEntries",
        type = "checkbox",
        title = L["settings.compactListEntries.title"],
        tooltip = L["settings.compactListEntries.tooltip"],
        warning = L["settings.warning.taint"],
        visible = PGF.IsRetail(),
        reload = true,
    },
    {
        type = "header",
        title = L["settings.section.mythicplus.title"],
        visible = true,
    },
    {
        key = "ratingInfo",
        type = "checkbox",
        title = L["settings.ratingInfo.title"],
        tooltip = L["settings.ratingInfo.tooltip"],
        image = "Interface\\AddOns\\PremadeGroupsFilter\\Textures\\SettingsRatingInfo",
        visible = true,
    },
    {
        key = "rioRatingColors",
        type = "checkbox",
        title = L["settings.rioRatingColors.title"],
        tooltip = L["settings.rioRatingColors.tooltip"],
        image = nil,
        visible = RaiderIO and true or false,
    },
    {
        key = "specIcon",
        type = "checkbox",
        title = L["settings.specIcon.title"],
        tooltip = L["settings.specIcon.tooltip"],
        image = "Interface\\AddOns\\PremadeGroupsFilter\\Textures\\SettingsSpecIcon",
        visible = PGF.SupportsSpecializations(),
    },
    {
        key = "classCircle",
        type = "checkbox",
        title = L["settings.classCircle.title"],
        tooltip = L["settings.classCircle.tooltip"],
        visible = false, -- circle not available in wrath and provided by default in retail since 10.2.7
    },
    {
        key = "classBar",
        type = "checkbox",
        title = L["settings.classBar.title"],
        tooltip = L["settings.classBar.tooltip"],
        image = "Interface\\AddOns\\PremadeGroupsFilter\\Textures\\SettingsClassBar",
        visible = true,
    },
    {
        key = "leaderCrown",
        type = "checkbox",
        title = L["settings.leaderCrown.title"],
        tooltip = L["settings.leaderCrown.tooltip"],
        image = "Interface\\AddOns\\PremadeGroupsFilter\\Textures\\SettingsLeaderCrown",
        visible = true,
    },
    {
        key = "missingRoles",
        type = "checkbox",
        title = L["settings.missingRoles.title"],
        tooltip = L["settings.missingRoles.tooltip"],
        image = "Interface\\AddOns\\PremadeGroupsFilter\\Textures\\SettingsMissingRoles",
        visible = PGF.SupportsDragonflightUI(),
    },
    {
        type = "header",
        title = L["settings.section.signup.title"],
        visible = true,
    },
    {
        key = "oneClickSignUp",
        type = "checkbox",
        title = L["settings.oneClickSignUp.title"],
        tooltip = L["settings.oneClickSignUp.tooltip"],
        warning = L["settings.warning.taint"],
        visible = true,
    },
    {
        key = "cancelOldestApp",
        type = "checkbox",
        title = L["settings.cancelOldestApp.title"],
        tooltip = L["settings.cancelOldestApp.tooltip"],
        visible = true,
    },
    {
        key = "persistSignUpNote",
        type = "checkbox",
        title = L["settings.persistSignUpNote.title"],
        tooltip = L["settings.persistSignUpNote.tooltip"],
        visible = true,
    },
    {
        key = "signupOnEnter",
        type = "checkbox",
        title = L["settings.signupOnEnter.title"],
        tooltip = L["settings.signupOnEnter.tooltip"],
        visible = true,
    },
    {
        key = "skipSignUpDialog",
        type = "checkbox",
        title = L["settings.skipSignUpDialog.title"],
        tooltip = L["settings.skipSignUpDialog.tooltip"],
        warning = L["settings.warning.taint"],
        visible = true,
    },
    {
        key = "signUpDeclined",
        type = "checkbox",
        title = L["settings.signUpDeclined.title"],
        tooltip = L["settings.signUpDeclined.tooltip"],
        warning = L["settings.warning.taint"],
        visible = PGF.IsRetail(),
        callback = function (enabled)
            -- clear existing declines when the setting is checked
            if enabled then
                LFGListFrame.declines = {}
            end
        end
    },
    {
        type = "note",
        text = L["settings.info.reload"],
        visible = PGF.IsRetail(),
    },
}

function PGFSettings:OnLoad()
    self.Header.Title:SetText(L["addon.name.long"])

    local view = CreateScrollBoxListLinearView()
    local top, bottom, left, right, horizontalSpacing, verticalSpacing = 10, 10, 0, 0, 10, 0
    view:SetPadding(top, bottom, left, right, horizontalSpacing, verticalSpacing)
    view:SetElementFactory(function(factory, elementData) self.CreateListItem(factory, elementData) end)
    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view)

    local category, layout = Settings.RegisterCanvasLayoutCategory(self, L["addon.name.long"])
    Settings.RegisterAddOnCategory(category)
    PGF.settingsCategory = category
end

function PGFSettings.CreateListItem(factory, elementData)
    if elementData.type == "checkbox" then
        factory("PremadeGroupsFilterSettingsCheckBoxTemplate", function(item, elementData)
            local title = elementData.title
            if elementData.reload then
                title = title .. " *"
            end
            item.Text:SetText(title)
            item.Tooltip:SetTooltipFunc(function()
                GameTooltip_AddHighlightLine(SettingsTooltip, elementData.title)
                GameTooltip_AddNormalLine(SettingsTooltip, elementData.tooltip)
            end)
            item.CheckBox:SetChecked(PremadeGroupsFilterSettings[elementData.key] or false)
            item.CheckBox:SetScript("OnClick", function(button, buttonName, down)
                PremadeGroupsFilterSettings[elementData.key] = button:GetChecked()
                if elementData.callback then
                    elementData.callback(button:GetChecked())
                end
            end)
            if PGF.SupportsDragonflightUI() and elementData.image then
                item.Image:SetTexture(elementData.image)
            end
            if elementData.warning then
                item.Warning:SetTooltipFunc(function()
                    GameTooltip_AddNormalLine(SettingsTooltip, elementData.warning)
                end)
                item.Warning:Show()
            else
                item.Warning:Hide()
            end
        end)
    elseif elementData.type == "header" then
        factory("PremadeGroupsFilterSettingsListSectionHeaderTemplate", function(item, elementData)
            item.Title:SetText(elementData.title)
        end)
    elseif elementData.type == "note" then
        factory("PremadeGroupsFilterSettingsNoteTemplate", function(item, elementData)
            item.Text:SetText(elementData.text)
        end)
    end
end

function PGFSettings:RefreshDataProvider()
    local dataProvider = CreateDataProvider()
    for i = 1, #PGFSettingsTable do
        if PGFSettingsTable[i].visible then
            dataProvider:Insert(PGFSettingsTable[i])
        end
    end
    self.ScrollBox:SetDataProvider(dataProvider)
end

function PGFSettings:OnShow()
    -- PGF panel is shown
    for i = 1, #PGFSettingsTable do
        if PGFSettingsTable[i].reload then
            reloadSettingsOnOpen[PGFSettingsTable[i].key] = PremadeGroupsFilterSettings[PGFSettingsTable[i].key]
        end
    end
    self:RefreshDataProvider()
end

function PGFSettings:OnCommit()
    -- Options dialog close button pressed
    for key, initialValue in pairs(reloadSettingsOnOpen) do
        if PremadeGroupsFilterSettings[key] ~= initialValue then
            C_UI.Reload()
            return
        end
    end
end

function PGFSettings:OnDefault()
    -- Options dialog reset button pressed
end

function PGFSettings:OnRefresh()
    -- Options dialog opened
end

function PGF.OpenSettings()
    Settings.OpenToCategory(PGF.settingsCategory.ID)
end

PGFSettings:SetScript("OnShow", PGFSettings.OnShow)
PGFSettings:OnLoad()
