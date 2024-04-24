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

local MiniPanel = CreateFrame("Frame", "PremadeGroupsFilterMiniPanel", PGF.Dialog, "PremadeGroupsFilterMiniPanelTemplate")

function MiniPanel:OnLoad()
    PGF.Logger:Debug("MiniPanel:OnLoad")
    self.name = "mini"

    PGF.UI_SetupAdvancedExpression(self)
    local fontFile, _, fontFlags = self.Advanced.Title:GetFont()
    self.Sorting.Title:SetText(L["dialog.sorting"])
    self.Sorting.Expression:SetFont(fontFile, C.FONTSIZE_TEXTBOX, fontFlags)
    self.Sorting.Expression:SetScript("OnTextChanged", InputBoxInstructions_OnTextChanged)
    self.Sorting.Expression:SetScript("OnEditFocusLost", function ()
        self.state.sorting = self.Sorting.Expression:GetText()
        self:TriggerFilterExpressionChange()
    end)
    self.Sorting.Expression.Instructions:SetFont(fontFile, C.FONTSIZE_TEXTBOX, fontFlags)
    self.Sorting.Expression.Instructions:SetText("friends desc, age asc")
end

function MiniPanel:Init(state)
    PGF.Logger:Debug("MiniPanel:Init")
    self.state = state
    self.state.expression = self.state.expression or ""
    self.state.sorting = self.state.sorting or ""
    self.Advanced.Expression.EditBox:SetText(self.state.expression)
    self.Sorting.Expression:SetText(self.state.sorting)
end

function MiniPanel:OnShow()
    PGF.Logger:Debug("MiniPanel:OnShow")
end

function MiniPanel:OnHide()
    PGF.Logger:Debug("MiniPanel:OnHide")
end

function MiniPanel:OnReset()
    PGF.Logger:Debug("MiniPanel:OnReset")
    self.state.expression = ""
    self.state.sorting = ""
    self:TriggerFilterExpressionChange()
    self:Init(self.state)
end

function MiniPanel:OnUpdateExpression(expression, sorting)
    PGF.Logger:Debug("MiniPanel:OnUpdateExpression")
    self.state.expression = expression
    self.state.sorting = sorting
    self:Init(self.state)
end

function MiniPanel:GetFilterExpression()
    PGF.Logger:Debug("MiniPanel:GetFilterExpression")
    local userExp = PGF.UI_NormalizeExpression(self.state.expression)
    if userExp == "" then
        return "true"
    else
        return userExp
    end
end

function MiniPanel:GetSortingExpression()
    return self.state.sorting
end

function MiniPanel:TriggerFilterExpressionChange()
    PGF.Logger:Debug("MiniPanel:TriggerFilterExpressionChange")
    PGF.Dialog:OnFilterExpressionChanged()
end

MiniPanel:OnLoad()
PGF.Dialog:RegisterPanel("mini", MiniPanel)
