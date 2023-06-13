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
    PGF.UI_SetupAdvancedExpression(self)
end

function ArenaPanel:Init(state)
    PGF.Logger:Debug("Arenapanel:Init")
    self.state = state
    self.state.difficulty = self.state.difficulty or {}
    self.state.pvprating = self.state.pvprating or {}
    self.state.expression = self.state.expression or ""

    self.Group.Difficulty.Act:SetChecked(self.state.difficulty.act or false)
    self.Group.Difficulty.DropDown:SetKey(self.state.difficulty.val)
    self.Group.PvPRating.Act:SetChecked(self.state.pvprating.act or false)
    self.Group.PvPRating.Min:SetText(self.state.pvprating.min or "")
    self.Group.PvPRating.Max:SetText(self.state.pvprating.max or "")

    self.Advanced.Expression.EditBox:SetText(self.state.expression or "")
    self.Advanced.Info:SetScript("OnEnter", PGF.Dialog_InfoButton_OnEnter)
    self.Advanced.Info:SetScript("OnLeave", PGF.Dialog_InfoButton_OnLeave)
    self.Advanced.Info:SetScript("OnClick", PGF.Dialog_InfoButton_OnClick)
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

    if PGF.NotEmpty(self.state.expression) then
        local userExp = PGF.RemoveCommentLines(self.state.expression)
        expression = expression .. " and ( " .. userExp .. " )"
    end
    expression = expression:gsub("^true and ", "")
    return expression
end

function ArenaPanel:GetSortingExpression()
    return nil
end

ArenaPanel:OnLoad()
PGF.Dialog:RegisterPanel("c4f8", ArenaPanel)
