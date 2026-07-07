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

local DELVE_TIER_MIN = 1
local DELVE_TIER_MAX = 11
local DELVE_ZONE_MAPS = {
    -- Source: https://wago.tools/maps/worldmap/2371
    -- Usually the map with artwork in the corners and working "Show Explored" toggle is the right one

    -- Midnight
    2393, -- Silvermoon City
    2395, -- Eversong Woods
    2405, -- Voidstorm
    2413, -- Harandar
    2437, -- Zul'Aman
    2443, -- Silvermoon City
    2424, -- Isle of Quel'Danas
    2512, -- The Coiled Isle
}
local DELVE_ACTIVITY_MAP = {
    -- Source: https://wago.tools/db2/GroupFinderActivity?filter%5BGroupFinderCategoryID%5D=121&filter%5BFullName_lang%5D=%28Tier%201%29&page=1&sort%5BGroupFinderActivityGrpID%5D=asc

    -- Midnight
    { activityGroupID = 405, tier1ActivityID = 1823 }, -- Collegiate Calamity
    { activityGroupID = 406, tier1ActivityID = 1826 }, -- Parhelion Plaza
    { activityGroupID = 407, tier1ActivityID = 1837 }, -- Sunkiller Sanctum
    --{ activityGroupID = 408, tier1ActivityID = 1824 }, -- Torment's Rise (seasonal nemesis)
    { activityGroupID = 409, tier1ActivityID = 1848 }, -- Shadowguard Point
    { activityGroupID = 410, tier1ActivityID = 1859 }, -- The Grudge Pit
    { activityGroupID = 411, tier1ActivityID = 1870 }, -- Atal'Aman
    { activityGroupID = 412, tier1ActivityID = 1881 }, -- The Gulf of Memory
    { activityGroupID = 413, tier1ActivityID = 1892 }, -- The Shadow Enclave
    { activityGroupID = 414, tier1ActivityID = 1903 }, -- Twilight Crypts
    { activityGroupID = 415, tier1ActivityID = 1914 }, -- The Darkway
    --{ activityGroupID = 430, tier1ActivityID = 2006 }, -- Venomfall Deeps (seasonal nemesis)
    { activityGroupID = 431, tier1ActivityID = 2008 }, -- Gnarldor Isle
    { activityGroupID = 432, tier1ActivityID = 2019 }, -- The Ring of Glory
}
setmetatable(DELVE_ACTIVITY_MAP, { __index = function() return { activityGroupID = 0, tier1ActivityID = 0 } end })

local MAX_DELVE_CHECKBOXES = 15 -- maximum available checkboxes in the UI = XML file
local NUM_DELVE_CHECKBOXES = math.min(MAX_DELVE_CHECKBOXES, #DELVE_ACTIVITY_MAP)

local DelvePanel = CreateFrame("Frame", "PremadeGroupsFilterDelvePanel", PGF.Dialog, "PremadeGroupsFilterDelvePanelTemplate")

function DelvePanel:GetBountifulDelves()
    local bountifulDelves = {}
    for _, mapID in ipairs(DELVE_ZONE_MAPS) do
        local delves = C_AreaPoiInfo.GetDelvesForMap(mapID)
        if delves then -- make sure map is already in the game files
            for _, poiID in ipairs(delves) do
                local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(mapID, poiID)
                if poiInfo and poiInfo.atlasName == "delves-bountiful" and poiInfo.name then
                    table.insert(bountifulDelves, poiInfo.name)
                end
            end
        end
    end
    return bountifulDelves
end

function DelvePanel:OnLoad()
    PGF.Logger:Debug("DelvePanel:OnLoad")
    self.name = "delve"
    self.dialogWidth = 420
    self.groupWidth = 245

    self:RegisterEvent("AREA_POIS_UPDATED")
    self:SetScript("OnEvent", self.OnEvent)

    -- Group
    self.Group.Title:SetText(L["dialog.filters.group"])
    PGF.UI_SetupMinMaxField(self, self.Group.DelveTier, "delvetier", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.Members, "members", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.Tanks, "tanks", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.Heals, "heals", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.DPS, "dps", self.groupWidth)
    PGF.UI_SetupCheckBox(self, self.Group.Partyfit, "partyfit", self.groupWidth)
    PGF.UI_SetupCheckBox(self, self.Group.NotDeclined, "notdeclined", self.groupWidth)
    PGF.UI_SetupAdvancedExpression(self)

    -- Delves
    self.Delves.Title:SetText(L["dialog.filters.delves"])
    self.Delves.SelectNone:Init(L["dialog.button.selectnone.title"], L["dialog.button.selectnone.tooltip"])
    self.Delves.SelectNone:SetScript("OnClick", function (btn)
        for i = 1, MAX_DELVE_CHECKBOXES do
            local delve = self.Delves["Delve"..i]
            delve.Act:SetChecked(false)
            self.state["delve"..i] = false
        end
        self:TriggerFilterExpressionChange()
    end)
    self.Delves.SelectAll:Init(L["dialog.button.selectall.title"], L["dialog.button.selectall.tooltip"])
    self.Delves.SelectAll:SetScript("OnClick", function (btn)
        for i = 1, NUM_DELVE_CHECKBOXES do
            local delve = self.Delves["Delve"..i]
            local checked = delve.isAvailable
            delve.Act:SetChecked(checked)
            self.state["delve"..i] = checked
        end
        self:TriggerFilterExpressionChange()
    end)
    self.Delves.SelectBountiful:Init(L["dialog.button.selectbountiful.title"], L["dialog.button.selectbountiful.tooltip"])
    self.Delves.SelectBountiful:SetScript("OnClick", function (btn)
        for i = 1, NUM_DELVE_CHECKBOXES do
            local delve = self.Delves["Delve"..i]
            local checked = delve.isAvailable and delve.isBountiful or false
            delve.Act:SetChecked(checked)
            self.state["delve"..i] = checked
        end
        self:TriggerFilterExpressionChange()
    end)

    for i = 1, MAX_DELVE_CHECKBOXES do
        local delve = self.Delves["Delve"..i]
        delve.isAvailable = false
        delve.isBountiful = false
    end

    for i = 1, NUM_DELVE_CHECKBOXES do
        local delve = self.Delves["Delve"..i]
        local activityGroupID = DELVE_ACTIVITY_MAP[i].activityGroupID
        local tier1ActivityID = DELVE_ACTIVITY_MAP[i].tier1ActivityID
        local activityInfo = tier1ActivityID > 0 and PGF.GetActivityInfoTable(tier1ActivityID) or nil
        if activityGroupID > 0 and activityInfo and activityInfo.fullName then
            local name = PGF.String_RemoveBrackets(activityInfo.fullName)

            delve.isAvailable = true
            delve.activityGroupID = activityGroupID
            delve.tier1ActivityID = tier1ActivityID
            delve.name = name
            delve:SetWidth(145)
            delve.Title:SetText(name)
            delve.Title:SetWidth(105)
            delve.Act:SetScript("OnClick", function(element)
                self.state["delve" .. i] = element:GetChecked()
                self:TriggerFilterExpressionChange()
            end)
            delve:SetScript("OnEnter", function (self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(self.name, nil, nil, nil, nil, true)
                GameTooltip:Show()
            end)
            delve:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
        else
            -- delve not yet in the game files (patch not yet released)
            delve.Act:SetChecked(false)
            delve:Hide()
        end
    end

    -- Hide unused checkboxes
    for i = NUM_DELVE_CHECKBOXES + 1, MAX_DELVE_CHECKBOXES do
        self.Delves["Delve"..i].Act:SetChecked(false)
        self.Delves["Delve"..i]:Hide()
    end
end

function DelvePanel:Init(state)
    PGF.Logger:Debug("DelvePanel:Init")
    self.state = state
    self.state.delvetier = self.state.delvetier or {}
    self.state.members = self.state.members or {}
    self.state.tanks = self.state.tanks or {}
    self.state.heals = self.state.heals or {}
    self.state.dps = self.state.dps or {}
    self.state.expression = self.state.expression or ""

    self.Group.DelveTier.Act:SetChecked(self.state.delvetier.act or false)
    self.Group.DelveTier.Min:SetText(self.state.delvetier.min or "")
    self.Group.DelveTier.Max:SetText(self.state.delvetier.max or "")
    self.Group.Members.Act:SetChecked(self.state.members.act or false)
    self.Group.Members.Min:SetText(self.state.members.min or "")
    self.Group.Members.Max:SetText(self.state.members.max or "")
    self.Group.Tanks.Act:SetChecked(self.state.tanks.act or false)
    self.Group.Tanks.Min:SetText(self.state.tanks.min or "")
    self.Group.Tanks.Max:SetText(self.state.tanks.max or "")
    self.Group.Heals.Act:SetChecked(self.state.heals.act or false)
    self.Group.Heals.Min:SetText(self.state.heals.min or "")
    self.Group.Heals.Max:SetText(self.state.heals.max or "")
    self.Group.DPS.Act:SetChecked(self.state.dps.act or false)
    self.Group.DPS.Min:SetText(self.state.dps.min or "")
    self.Group.DPS.Max:SetText(self.state.dps.max or "")

    self.Group.Partyfit.Act:SetChecked(self.state.partyfit or false)
    self.Group.NotDeclined.Act:SetChecked(self.state.notdeclined or false)

    for i = 1, MAX_DELVE_CHECKBOXES do
        local delve = self.Delves["Delve"..i]
        local checked = delve.isAvailable and self.state["delve"..i] or false
        delve.Act:SetChecked(checked)
        self.state["delve"..i] = checked
    end
    self.Advanced.Expression.EditBox:SetText(self.state.expression or "")
end

function DelvePanel:UpdateDelves()
    local bountifulDelves = self:GetBountifulDelves()
    for i = 1, NUM_DELVE_CHECKBOXES do
        local color = WHITE_FONT_COLOR
        local isBountiful = false
        local delve = self.Delves["Delve"..i]
        if delve.isAvailable then
            for _, bountifulDelveName in ipairs(bountifulDelves) do
                if PGF.IsMostLikelySameInstance(delve.name, bountifulDelveName) then
                    color = NORMAL_FONT_COLOR
                    isBountiful = true
                end
            end
            delve.Title:SetTextColor(color:GetRGB())
        end
        delve.isBountiful = isBountiful
    end
end

function DelvePanel:OnEvent(event)
    if event == "AREA_POIS_UPDATED" then
        PGF.Logger:Debug("DungeonPanel:OnEvent(AREA_POIS_UPDATED)")
        self:UpdateDelves()
    end
end

function DelvePanel:OnShow()
    PGF.Logger:Debug("DelvePanel:OnShow")
    self:UpdateDelves()
end

function DelvePanel:OnHide()
    PGF.Logger:Debug("DelvePanel:OnHide")
end

function DelvePanel:OnReset()
    PGF.Logger:Debug("DelvePanel:OnReset")
    self.state.delvetier.act = false
    self.state.delvetier.min = ""
    self.state.delvetier.max = ""
    self.state.members.act = false
    self.state.members.min = ""
    self.state.members.max = ""
    self.state.tanks.act = false
    self.state.tanks.min = ""
    self.state.tanks.max = ""
    self.state.heals.act = false
    self.state.heals.min = ""
    self.state.heals.max = ""
    self.state.dps.act = false
    self.state.dps.min = ""
    self.state.dps.max = ""
    self.state.partyfit = false
    self.state.notdeclined = false
    for i = 1, MAX_DELVE_CHECKBOXES do
        self.state["delve"..i] = false
    end
    self.state.expression = ""
    self:TriggerFilterExpressionChange()
    self:Init(self.state)
end

function DelvePanel:OnUpdateExpression(expression, sorting)
    PGF.Logger:Debug("DelvePanel:OnUpdateExpression")
    self.state.expression = expression
    self:Init(self.state)
end

function DelvePanel:TriggerFilterExpressionChange()
    PGF.Logger:Debug("DelvePanel:TriggerFilterExpressionChange")
    local expression = self:GetFilterExpression()
    local hint = expression == "true" and "" or expression
    self.Advanced.Expression.EditBox.Instructions:SetText(hint)
    PGF.Dialog:OnFilterExpressionChanged()
end

function DelvePanel:GetFilterExpression()
    PGF.Logger:Debug("DelvePanel:GetFilterExpression")
    local expression = "true" -- start with neutral element of logical and

    if self.state.delvetier.act then
        if PGF.NotEmpty(self.state.delvetier.min) and PGF.NotEmpty(self.state.delvetier.max) then
            expression = expression .. " and findnumber(" .. self.state.delvetier.min .. "," .. self.state.delvetier.max .. ")"
        elseif PGF.NotEmpty(self.state.delvetier.min) then
            expression = expression .. " and findnumber(" .. self.state.delvetier.min .. "," .. DELVE_TIER_MAX .. ")"
        elseif PGF.NotEmpty(self.state.delvetier.max) then
            expression = expression .. " and findnumber(" .. DELVE_TIER_MIN .. "," .. self.state.delvetier.max .. ")"
        end
    end
    if self.state.members.act then
        if PGF.NotEmpty(self.state.members.min) then expression = expression .. " and members >= " .. self.state.members.min end
        if PGF.NotEmpty(self.state.members.max) then expression = expression .. " and members <= " .. self.state.members.max end
    end
    if self.state.tanks.act then
        if PGF.NotEmpty(self.state.tanks.min) then expression = expression .. " and tanks >= " .. self.state.tanks.min end
        if PGF.NotEmpty(self.state.tanks.max) then expression = expression .. " and tanks <= " .. self.state.tanks.max end
    end
    if self.state.heals.act then
        if PGF.NotEmpty(self.state.heals.min) then expression = expression .. " and heals >= " .. self.state.heals.min end
        if PGF.NotEmpty(self.state.heals.max) then expression = expression .. " and heals <= " .. self.state.heals.max end
    end
    if self.state.dps.act then
        if PGF.NotEmpty(self.state.dps.min) then expression = expression .. " and dps >= " .. self.state.dps.min end
        if PGF.NotEmpty(self.state.dps.max) then expression = expression .. " and dps <= " .. self.state.dps.max end
    end
    if self.state.partyfit then
        expression = expression .. " and partyfit"
    end
    if self.state.notdeclined then
        expression = expression .. " and not declined"
    end

    if self:GetNumDelvesSelected() > 0 then
        expression = expression .. " and ( false" -- start with neutral element of logical or
        for i = 1, NUM_DELVE_CHECKBOXES do
            local delve = self.Delves["Delve"..i]
            if delve.isAvailable and self.state["delve"..i] then
                expression = expression .. " or groupid == " .. delve.activityGroupID
            end
        end
        expression = expression .. " )"
        expression = expression:gsub("false or ", "")
    end

    local userExp = PGF.UI_NormalizeExpression(self.state.expression)
    if userExp ~= "" then expression = expression .. " and ( " .. userExp .. " )" end

    expression = expression:gsub("^true and ", "")
    return expression
end

function DelvePanel:GetSortingExpression()
    return nil
end

function DelvePanel:GetDesiredDialogWidth()
    return self.dialogWidth
end

function DelvePanel:GetNumDelvesSelected()
    local numDelvesSelected = 0
    for i = 1, NUM_DELVE_CHECKBOXES do
        local delve = self.Delves["Delve"..i]
        if delve.isAvailable and self.state["delve"..i] then
            numDelvesSelected = numDelvesSelected + 1
        end
    end
    return numDelvesSelected
end

DelvePanel:OnLoad()
PGF.Dialog:RegisterPanel("c121f4", DelvePanel)
