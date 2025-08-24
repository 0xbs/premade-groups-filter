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

local DELVE_TIER_MIN = 1
local DELVE_TIER_MAX = 11
local DELVE_ZONE_MAPS = {
    -- https://wago.tools/maps/worldmap/2371
    2214, -- The Ringing Deeps
    2215, -- Hallowfall
    2248, -- Isle of Dorn
    2255, -- Azj-Kahet
    2256, -- Azj-Kahet - Lower
    2346, -- Undermine
    2371, -- K'aresh
}
local DELVE_ACTIVITY_MAP = {
    -- Delves from TWW
    { activityGroupID = 331, tier1ActivityID = 1295, keyword = "fungal" },      -- Fungal Folly
    { activityGroupID = 332, tier1ActivityID = 1296, keyword = "kriegval" },    -- Kriegval's Rest
    { activityGroupID = 333, tier1ActivityID = 1297, keyword = "earthcrawl" },  -- Earthcrawl Mines
    { activityGroupID = 335, tier1ActivityID = 1299, keyword = "waterworks" },  -- The Waterworks
    { activityGroupID = 336, tier1ActivityID = 1300, keyword = "dreadpit" },    -- The Dread Pit
    { activityGroupID = 337, tier1ActivityID = 1301, keyword = "nightfall" },   -- Nightfall Sanctum
    { activityGroupID = 338, tier1ActivityID = 1302, keyword = "mycomancer" },  -- Mycomancer Cavern
    { activityGroupID = 339, tier1ActivityID = 1303, keyword = "sinkhole" },    -- The Sinkhole
    { activityGroupID = 340, tier1ActivityID = 1304, keyword = "skittering" },  -- Skittering Breach
    { activityGroupID = 341, tier1ActivityID = 1305, keyword = "underkeep" },   -- The Underkeep
    { activityGroupID = 342, tier1ActivityID = 1306, keyword = "takrethan" },   -- Tak-Rethan Abyss
    { activityGroupID = 343, tier1ActivityID = 1307, keyword = "spiral" },      -- The Spiral Weave
    { activityGroupID = 373, tier1ActivityID = 1553, keyword = "excavation" },  -- Excavation Site 9
    { activityGroupID = 374, tier1ActivityID = 1564, keyword = "sidestreet" },  -- Sidestreet Sluice
    { activityGroupID = 394, tier1ActivityID = 1746, keyword = "archival" },    -- Archival Assault
}
setmetatable(DELVE_ACTIVITY_MAP, { __index = function() return { order = 0, keyword = "true" } end })

local NUM_DELVE_CHECKBOXES = 15

local DelvePanel = CreateFrame("Frame", "PremadeGroupsFilterDelvePanel", PGF.Dialog, "PremadeGroupsFilterDelvePanelTemplate")

function DelvePanel:GetBountifulDelves()
    local bountifulDelves = {}
    for _, mapID in ipairs(DELVE_ZONE_MAPS) do
        local delves = C_AreaPoiInfo.GetDelvesForMap(mapID)
        for _, poiID in ipairs(delves) do
            local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(mapID, poiID)
            local isBountiful = poiInfo.atlasName == "delves-bountiful"
            if isBountiful then
               table.insert(bountifulDelves, poiInfo.name)
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
        for i = 1, NUM_DELVE_CHECKBOXES do
            self.Delves["Delve"..i].Act:SetChecked(false)
            self.state["delve"..i] = false
        end
        self:TriggerFilterExpressionChange()
    end)
    self.Delves.SelectAll:Init(L["dialog.button.selectall.title"], L["dialog.button.selectall.tooltip"])
    self.Delves.SelectAll:SetScript("OnClick", function (btn)
        for i = 1, NUM_DELVE_CHECKBOXES do
            self.Delves["Delve"..i].Act:SetChecked(true)
            self.state["delve"..i] = true
        end
        self:TriggerFilterExpressionChange()
    end)
    self.Delves.SelectBountiful:Init(L["dialog.button.selectbountiful.title"], L["dialog.button.selectbountiful.tooltip"])
    self.Delves.SelectBountiful:SetScript("OnClick", function (btn)
        for i = 1, NUM_DELVE_CHECKBOXES do
            local isBountiful = self.Delves["Delve"..i].isBountiful or false
            self.Delves["Delve"..i].Act:SetChecked(isBountiful)
            self.state["delve"..i] = isBountiful
        end
        self:TriggerFilterExpressionChange()
    end)

    for i = 1, NUM_DELVE_CHECKBOXES do
        local delve = self.Delves["Delve"..i]
        local activityGroupID = DELVE_ACTIVITY_MAP[i].activityGroupID
        local tier1ActivityID = DELVE_ACTIVITY_MAP[i].tier1ActivityID
        local activityInfo = C_LFGList.GetActivityInfoTable(tier1ActivityID)
        local name = PGF.String_RemoveBrackets(activityInfo.fullName)

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

function DelvePanel:UpdateDelves()
    local bountifulDelves = self:GetBountifulDelves()
    for i = 1, NUM_DELVE_CHECKBOXES do
        local color = WHITE_FONT_COLOR
        local isBountiful = false
        local delve = self.Delves["Delve"..i]
        for _, bountifulDelveName in ipairs(bountifulDelves) do
            if PGF.IsMostLikelySameInstance(delve.name, bountifulDelveName) then
                color = NORMAL_FONT_COLOR
                isBountiful = true
            end
        end
        delve.Title:SetTextColor(color:GetRGB())
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
            if self.state["delve"..i] then
                expression = expression .. " or groupid == " .. DELVE_ACTIVITY_MAP[i].activityGroupID
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

DelvePanel:OnLoad()
PGF.Dialog:RegisterPanel("c121f4", DelvePanel)
