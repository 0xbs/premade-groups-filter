-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2025 Bernhard Saumweber
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

local DELVE_ACTIVITY_MAP = {
    -- Main Delves from The War Within (Tier 1 activity IDs with their unique ActivityGroupIDs)
    [331] = { order = 1, keyword = "fungal", activityGroupID = 331 },      -- Fungal Folly
    [332] = { order = 2, keyword = "kriegval", activityGroupID = 332 },    -- Kriegval's Rest
    [333] = { order = 3, keyword = "earthcrawl", activityGroupID = 333 },  -- Earthcrawl Mines
    [334] = { order = 4, keyword = "zekvir", activityGroupID = 334 },      -- Zekvir's Lair
    [335] = { order = 5, keyword = "waterworks", activityGroupID = 335 },  -- The Waterworks
    [336] = { order = 6, keyword = "dreadpit", activityGroupID = 336 },    -- The Dread Pit
    [337] = { order = 7, keyword = "nightfall", activityGroupID = 337 },   -- Nightfall Sanctum
    [338] = { order = 8, keyword = "mycomancer", activityGroupID = 338 },  -- Mycomancer Cavern
    [339] = { order = 9, keyword = "sinkhole", activityGroupID = 339 },    -- The Sinkhole
    [340] = { order = 10, keyword = "skittering", activityGroupID = 340 }, -- Skittering Breach
    [341] = { order = 11, keyword = "underkeep", activityGroupID = 341 },  -- The Underkeep
    [342] = { order = 12, keyword = "takrethan", activityGroupID = 342 },  -- Tak-Rethan Abyss
    [343] = { order = 13, keyword = "spiral", activityGroupID = 343 },     -- The Spiral Weave
    [373] = { order = 14, keyword = "excavation", activityGroupID = 373 }, -- Excavation Site 9
    [374] = { order = 15, keyword = "sidestreet", activityGroupID = 374 }, -- Sidestreet Sluice
}
setmetatable(DELVE_ACTIVITY_MAP, { __index = function() return { order = 0, keyword = "true" } end })

local NUM_DELVE_CHECKBOXES = 15

local DelvePanel = CreateFrame("Frame", "PremadeGroupsFilterDelvePanel", PGF.Dialog, "PremadeGroupsFilterDelvePanelTemplate")

function DelvePanel:OnLoad()
    PGF.Logger:Debug("DelvePanel:OnLoad")
    self.name = "delve"
    self.dialogWidth = 420
    self.groupWidth = 245
    self.delveIDs = {}

    self:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
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

    for i = 1, NUM_DELVE_CHECKBOXES do
        local delve = self.Delves["Delve"..i]
        delve.activityID = nil
        delve.name = "..."
        delve:SetWidth(145)
        delve.Title:SetText("...")
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
    end
    self:TryInitDelves()
end

function DelvePanel:TryInitDelves()
    if not self.delveIDs or #self.delveIDs == 0 then
        self:InitDelves()
    end
end

function DelvePanel:InitDelves()
    PGF.Logger:Debug("DelvePanel:InitDelves")
    
    -- Get delve activity IDs (we use the base tier 1 IDs as references)
    self.delveIDs = {}
    for activityID, delveInfo in pairs(DELVE_ACTIVITY_MAP) do
        if delveInfo.order > 0 then
            table.insert(self.delveIDs, activityID)
        end
    end
    
    -- Sort by order
    table.sort(self.delveIDs, function(a, b)
        if DELVE_ACTIVITY_MAP[a].order ~= DELVE_ACTIVITY_MAP[b].order then
            return DELVE_ACTIVITY_MAP[a].order < DELVE_ACTIVITY_MAP[b].order
        end
        return a < b
    end)

    for i, activityID in ipairs(self.delveIDs) do
        if i <= NUM_DELVE_CHECKBOXES then
            local delveName = C_LFGList.GetActivityFullName(activityID) or ("Delve " .. activityID)
            local delve = self.Delves["Delve"..i]
            delve.activityID = activityID
            delve.name = delveName
            delve.Title:SetText(delveName)
        end
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

    for i = 1, NUM_DELVE_CHECKBOXES do
        self.Delves["Delve"..i].Act:SetChecked(self.state["delve"..i] or false)
    end
    self.Advanced.Expression.EditBox:SetText(self.state.expression or "")
end

function DelvePanel:OnEvent(event)
    if (event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" or event == "GROUP_ROSTER_UPDATE") and self.state then
        PGF.Logger:Debug("DelvePanel:OnEvent(" .. event .. ")")
        if event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" then
            self:InitDelves()
        end
        self:UpdateAdvancedFilters()
    end
end

function DelvePanel:OnShow()
    PGF.Logger:Debug("DelvePanel:OnShow")
    self:TryInitDelves()
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
    for i = 1, NUM_DELVE_CHECKBOXES do
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
    self:UpdateAdvancedFilters()
    PGF.Dialog:OnFilterExpressionChanged()
end

function DelvePanel:GetFilterExpression()
    PGF.Logger:Debug("DelvePanel:GetFilterExpression")
    local expression = "true" -- start with neutral element of logical and
    
    if self.state.delvetier.act then
        if PGF.NotEmpty(self.state.delvetier.min) then expression = expression .. " and delvetier >= " .. self.state.delvetier.min end
        if PGF.NotEmpty(self.state.delvetier.max) then expression = expression .. " and delvetier <= " .. self.state.delvetier.max end
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
            if self.delveIDs[i] and self.state["delve"..i] then
                local keyword = DELVE_ACTIVITY_MAP[self.delveIDs[i]].keyword
                if keyword then
                    expression = expression .. " or " .. keyword
                end
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
        if self.state["delve"..i] then
            numDelvesSelected = numDelvesSelected + 1
        end
    end
    return numDelvesSelected
end

function DelvePanel:UpdateAdvancedFilters()
    local enabled = PGF.GetAdvancedFilterDefaults()
    
    if self.state.delvetier.act then
        enabled.minimumDelveLevel = PGF.NotEmpty(self.state.delvetier.min) and tonumber(self.state.delvetier.min) or 1
        enabled.maximumDelveLevel = PGF.NotEmpty(self.state.delvetier.max) and tonumber(self.state.delvetier.max) or 11
    end
    if self.state.tanks.act then
        enabled.hasTank = PGF.NotEmpty(self.state.tanks.min) and tonumber(self.state.tanks.min) > 0
        enabled.needsTank = PGF.NotEmpty(self.state.tanks.max) and tonumber(self.state.tanks.max) == 0
    end
    if self.state.heals.act then
        enabled.hasHealer = PGF.NotEmpty(self.state.heals.min) and tonumber(self.state.heals.min) > 0
        enabled.needsHealer = PGF.NotEmpty(self.state.heals.max) and tonumber(self.state.heals.max) == 0
    end
    if self.state.dps.act then
        enabled.needsDamage = PGF.NotEmpty(self.state.dps.max) and tonumber(self.state.dps.max) < 3
    end
    if self.state.partyfit then
        local partyRoles = PGF.GetPartyRoles()
        enabled.needsTank = partyRoles["TANK"] > 0
        enabled.needsHealer = partyRoles["HEALER"] > 0
        enabled.needsDamage = partyRoles["DAMAGER"] > 0
    end
    if self:GetNumDelvesSelected() > 0 then
        local selectedDelves = {}
        for i = 1, NUM_DELVE_CHECKBOXES do
            if self.delveIDs[i] and self.state["delve"..i] then
                local activityGroupID = DELVE_ACTIVITY_MAP[self.delveIDs[i]].activityGroupID
                if activityGroupID then
                    table.insert(selectedDelves, activityGroupID)
                end
            end
        end
        enabled.activities = selectedDelves
    end
    PGF.SetAdvancedFilter(enabled)
end

DelvePanel:OnLoad()
PGF.Dialog:RegisterPanel("c121", DelvePanel)