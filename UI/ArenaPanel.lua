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
    [1] = { key = C.ARENA2V2, title = C_LFGList.GetActivityInfoTable(6).shortName }, -- Arena 2v2
    [2] = { key = C.ARENA3V3, title = C_LFGList.GetActivityInfoTable(7).shortName }, -- Arena 3v3
}

local ArenaPanel = CreateFrame("Frame", "PremadeGroupsFilterArenaPanel", PGF.Dialog, "PremadeGroupsFilterArenaPanelTemplate")

function ArenaPanel:OnLoad()
    PGF.Logger:Debug("ArenaPanel:OnLoad")
    self.name = "arena"

    -- Group
    self.Group.Title:SetText(L["dialog.filters.group"])

    PGF.UI_SetupDropDown(self, self.Group.Difficulty, "ArenaDifficultyMenu", L["dialog.difficulty"], DIFFICULTY_TEXT)
    PGF.UI_SetupMinMaxField(self, self.Group.PvPRating, "pvprating")
    PGF.UI_SetupMinMaxField(self, self.Group.Members, "members", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.Tanks, "tanks", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.Heals, "heals", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.DPS, "dps", self.groupWidth)
    PGF.UI_SetupAdvancedExpression(self)
end

function ArenaPanel:Init(state)
    PGF.Logger:Debug("Arenapanel:Init")
    self.state = state
    self.state.difficulty = self.state.difficulty or {}
    self.state.pvprating = self.state.pvprating or {}
    self.state.members = self.state.members or {}
    self.state.tanks = self.state.tanks or {}
    self.state.heals = self.state.heals or {}
    self.state.dps = self.state.dps or {}
    self.state.expression = self.state.expression or ""

    self.Group.Difficulty.Act:SetChecked(self.state.difficulty.act or false)
    self.Group.Difficulty.DropDown:SetKey(self.state.difficulty.val)
    self.Group.PvPRating.Act:SetChecked(self.state.pvprating.act or false)
    self.Group.PvPRating.Min:SetText(self.state.pvprating.min or "")
    self.Group.PvPRating.Max:SetText(self.state.pvprating.max or "")
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

    self.Advanced.Expression.EditBox:SetText(self.state.expression or "")
end

function ArenaPanel:OnShow()
    PGF.Logger:Debug("ArenaPanel:OnShow")
end

function ArenaPanel:OnHide()
    PGF.Logger:Debug("ArenaPanel:OnHide")
end

function ArenaPanel:OnReset()
    PGF.Logger:Debug("ArenaPanel:OnReset")
    self.state.difficulty.act = false
    self.state.pvprating.act = false
    self.state.pvprating.min = ""
    self.state.pvprating.max = ""
    self.state.tanks.act = false
    self.state.tanks.min = ""
    self.state.tanks.max = ""
    self.state.members.act = false
    self.state.members.min = ""
    self.state.members.max = ""
    self.state.heals.act = false
    self.state.heals.min = ""
    self.state.heals.max = ""
    self.state.dps.act = false
    self.state.dps.min = ""
    self.state.dps.max = ""
    self.state.expression = ""
    self:TriggerFilterExpressionChange()
    self:Init(self.state)
end

function ArenaPanel:OnUpdateExpression(expression, sorting)
    PGF.Logger:Debug("ArenaPanel:OnUpdateExpression")
    self.state.expression = expression
    self:Init(self.state)
end

function ArenaPanel:TriggerFilterExpressionChange()
    PGF.Logger:Debug("ArenaPanel:TriggerFilterExpressionChange")
    local expression = self:GetFilterExpression()
    local hint = expression == "true" and "" or expression
    self.Advanced.Expression.EditBox.Instructions:SetText(hint)
    PGF.Dialog:OnFilterExpressionChanged()
end

function ArenaPanel:GetFilterExpression()
    PGF.Logger:Debug("ArenaPanel:GetFilterExpression")
    local expression = "true" -- start with neutral element of logical and
    if self.state.difficulty.act and self.state.difficulty.val then
        expression = expression .. " and " .. C.DIFFICULTY_KEYWORD[self.state.difficulty.val]
    end
    if self.state.pvprating.act then
        if PGF.NotEmpty(self.state.pvprating.min) then expression = expression .. " and pvprating >= " .. self.state.pvprating.min end
        if PGF.NotEmpty(self.state.pvprating.max) then expression = expression .. " and pvprating <= " .. self.state.pvprating.max end
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

    local userExp = PGF.UI_NormalizeExpression(self.state.expression)
    if userExp ~= "" then expression = expression .. " and ( " .. userExp .. " )" end

    expression = expression:gsub("^true and ", "")
    return expression
end

function ArenaPanel:GetSortingExpression()
    return nil
end

ArenaPanel:OnLoad()
PGF.Dialog:RegisterPanel("c4f8", ArenaPanel)
