-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2024 Bernhard Saumweber
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

local DIFFICULTY_TEXT = {
    [1] = { key = C.NORMAL, title = L["dialog.normal"] },
    [2] = { key = C.HEROIC, title = L["dialog.heroic"] },
    [3] = { key = C.MYTHIC, title = L["dialog.mythic"] },
}

local RaidPanel = CreateFrame("Frame", "PremadeGroupsFilterRaidPanel", PGF.Dialog, "PremadeGroupsFilterRaidPanelTemplate")

function RaidPanel:OnLoad()
    PGF.Logger:Debug("RaidPanel:OnLoad")
    self.name = "raid"

    -- Group
    self.Group.Title:SetText(L["dialog.filters.group"])

    PGF.UI_SetupDropDown(self, self.Group.Difficulty, "RaidDifficultyMenu", L["dialog.difficulty"], DIFFICULTY_TEXT)
    PGF.UI_SetupMinMaxField(self, self.Group.Members, "members")
    PGF.UI_SetupMinMaxField(self, self.Group.Tanks, "tanks")
    PGF.UI_SetupMinMaxField(self, self.Group.Heals, "heals")
    PGF.UI_SetupMinMaxField(self, self.Group.DPS, "dps")
    PGF.UI_SetupMinMaxField(self, self.Group.Defeated, "defeated")
    PGF.UI_SetupCheckBox(self, self.Group.MatchingId, "matchingid", 290/2)
    PGF.UI_SetupAdvancedExpression(self)
end

function RaidPanel:Init(state)
    PGF.Logger:Debug("Raidpanel:Init")
    self.state = state
    self.state.difficulty = self.state.difficulty or {}
    self.state.members = self.state.members or {}
    self.state.tanks = self.state.tanks or {}
    self.state.heals = self.state.heals or {}
    self.state.dps = self.state.dps or {}
    self.state.defeated = self.state.defeated or {}
    self.state.expression = self.state.expression or ""

    self.Group.Difficulty.Act:SetChecked(self.state.difficulty.act or false)
    self.Group.Difficulty.DropDown:SetKey(self.state.difficulty.val)
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
    self.Group.Defeated.Act:SetChecked(self.state.defeated.act or false)
    self.Group.Defeated.Min:SetText(self.state.defeated.min or "")
    self.Group.Defeated.Max:SetText(self.state.defeated.max or "")

    self.Group.MatchingId.Act:SetChecked(self.state.matchingid or false)

    self.Advanced.Expression.EditBox:SetText(self.state.expression or "")
end

function RaidPanel:OnShow()
    PGF.Logger:Debug("RaidPanel:OnShow")
end

function RaidPanel:OnHide()
    PGF.Logger:Debug("RaidPanel:OnHide")
end

function RaidPanel:OnReset()
    PGF.Logger:Debug("RaidPanel:OnReset")
    self.state.difficulty.act = false
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
    self.state.defeated.act = false
    self.state.defeated.min = ""
    self.state.defeated.max = ""
    self.state.matchingid = false
    self.state.expression = ""
    self:TriggerFilterExpressionChange()
    self:Init(self.state)
end

function RaidPanel:OnUpdateExpression(expression, sorting)
    PGF.Logger:Debug("RaidPanel:OnUpdateExpression")
    self.state.expression = expression
    self:Init(self.state)
end

function RaidPanel:TriggerFilterExpressionChange()
    PGF.Logger:Debug("RaidPanel:TriggerFilterExpressionChange")
    local expression = self:GetFilterExpression()
    local hint = expression == "true" and "" or expression
    self.Advanced.Expression.EditBox.Instructions:SetText(hint)
    PGF.Dialog:OnFilterExpressionChanged()
end

function RaidPanel:GetFilterExpression()
    PGF.Logger:Debug("RaidPanel:GetFilterExpression")
    local expression = "true" -- start with neutral element of logical and
    if self.state.difficulty.act and self.state.difficulty.val then
        expression = expression .. " and " .. C.DIFFICULTY_KEYWORD[self.state.difficulty.val]
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
    if self.state.defeated.act then
        if PGF.NotEmpty(self.state.defeated.min) then expression = expression .. " and defeated >= " .. self.state.defeated.min end
        if PGF.NotEmpty(self.state.defeated.max) then expression = expression .. " and defeated <= " .. self.state.defeated.max end
    end
    if self.state.matchingid  then expression = expression .. " and matchingid"   end

    local userExp = PGF.UI_NormalizeExpression(self.state.expression)
    if userExp ~= "" then expression = expression .. " and ( " .. userExp .. " )" end

    expression = expression:gsub("^true and ", "")
    return expression
end

function RaidPanel:GetSortingExpression()
    return nil
end

RaidPanel:OnLoad()
PGF.Dialog:RegisterPanel("c3f5", RaidPanel) -- Retail
PGF.Dialog:RegisterPanel("c3f6", RaidPanel) -- Retail
PGF.Dialog:RegisterPanel("c114f4", RaidPanel) -- Wrath
PGF.Dialog:RegisterPanel("c114f5", RaidPanel) -- Wrath
PGF.Dialog:RegisterPanel("c114f6", RaidPanel) -- Wrath
