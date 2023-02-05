-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2022 Elotheon-Arthas-EU
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
local PGFSettingsTable = {
    {
        key = "dialogMovable",
        type = "checkbox",
        title = L["settings.dialogMovable.title"],
        tooltip = L["settings.dialogMovable.tooltip"],
    },
    {
        key = "classNamesInTooltip",
        type = "checkbox",
        title = L["settings.classNamesInTooltip.title"],
        tooltip = L["settings.classNamesInTooltip.tooltip"],
    },
    {
        key = "coloredGroupTexts",
        type = "checkbox",
        title = L["settings.coloredGroupTexts.title"],
        tooltip = L["settings.coloredGroupTexts.tooltip"],
    },
    {
        key = "coloredApplications",
        type = "checkbox",
        title = L["settings.coloredApplications.title"],
        tooltip = L["settings.coloredApplications.tooltip"],
    },
    {
        key = "ratingInfo",
        type = "checkbox",
        title = L["settings.ratingInfo.title"],
        tooltip = L["settings.ratingInfo.tooltip"],
    },
    {
        key = "classCircle",
        type = "checkbox",
        title = L["settings.classCircle.title"],
        tooltip = L["settings.classCircle.tooltip"],
    },
    {
        key = "classBar",
        type = "checkbox",
        title = L["settings.classBar.title"],
        tooltip = L["settings.classBar.tooltip"],
    },
    {
        key = "leaderCrown",
        type = "checkbox",
        title = L["settings.leaderCrown.title"],
        tooltip = L["settings.leaderCrown.tooltip"],
    },
    {
        key = "oneClickSignUp",
        type = "checkbox",
        title = L["settings.oneClickSignUp.title"],
        tooltip = L["settings.oneClickSignUp.tooltip"],
    },
    {
        key = "persistSignUpNote",
        type = "checkbox",
        title = L["settings.persistSignUpNote.title"],
        tooltip = L["settings.persistSignUpNote.tooltip"],
        callback = function(value) PGF.PersistSignUpNote() end,
    },
    {
        key = "signupOnEnter",
        type = "checkbox",
        title = L["settings.signupOnEnter.title"],
        tooltip = L["settings.signupOnEnter.tooltip"],
    },
    {
        key = "skipSignUpDialog",
        type = "checkbox",
        title = L["settings.skipSignUpDialog.title"],
        tooltip = L["settings.skipSignUpDialog.tooltip"],
    },
}

function PGFSettings:OnLoad()
    self.Header.Title:SetText(L["addon.name.long"])

    local view = CreateScrollBoxListLinearView()
    local top, bottom, left, right, horizontalSpacing, verticalSpacing = 10, 10, 0, 0, 10, 0
    view:SetPadding(top, bottom, left, right, horizontalSpacing, verticalSpacing)
    view:SetElementFactory(function(factory, elementData) self.CreateListItem(factory, elementData) end)
    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view)

    Settings.RegisterAddOnCategory(Settings.RegisterCanvasLayoutCategory(self, L["addon.name.long"]))
end

function PGFSettings.CreateListItem(factory, elementData)
    if elementData.type == "checkbox" then
        factory("PremadeGroupsFilterSettingsCheckBoxTemplate", function(item, elementData)
            item.Text:SetText(elementData.title)
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
        end)
    end
end

function PGFSettings:RefreshDataProvider()
    local dataProvider = CreateDataProvider()
    for i = 1, #PGFSettingsTable do
        dataProvider:Insert(PGFSettingsTable[i])
    end
    self.ScrollBox:SetDataProvider(dataProvider)
end

function PGFSettings:OnShow()
    -- PGF panel is shown
    self:RefreshDataProvider()
end

function PGFSettings:OnCommit()
    -- Options dialog close button pressed
end

function PGFSettings:OnDefault()
    -- Options dialog reset button pressed
end

function PGFSettings:OnRefresh()
    -- Options dialog opened
end

PGFSettings:SetScript("OnShow", PGFSettings.OnShow)
PGFSettings:OnLoad()
