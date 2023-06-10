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

local ExpressionPanel = CreateFrame("Frame", "PremadeGroupsFilterExpressionPanel", PGF.Dialog, "PremadeGroupsFilterExpressionPanelTemplate")

function ExpressionPanel:OnLoad()
    PGF.Logger:Debug("ExpressionPanel:OnLoad")
    self.name = "expression"

    InputScrollFrame_OnLoad(self.Advanced.Expression)
    self.Advanced.Title:SetText(L["dialog.filters.advanced"])
    local fontFile, _, fontFlags = self.Advanced.Title:GetFont()
    self.Advanced.Expression.EditBox:SetFont(fontFile, C.FONTSIZE_TEXTBOX, fontFlags)
    self.Advanced.Expression.EditBox.Instructions:SetFont(fontFile, C.FONTSIZE_TEXTBOX, fontFlags)
    self.Advanced.Expression.EditBox:SetScript("OnTextChanged", InputScrollFrame_OnTextChanged)
end

function ExpressionPanel:Init(state)
    PGF.Logger:Debug("ExpressionPanel:Init")
    self.state = state
    self.state.expression = self.state.expression or ""
    self.Advanced.Expression.EditBox:SetText(self.state.expression)
end

function ExpressionPanel:OnShow()
    PGF.Logger:Debug("ExpressionPanel:OnShow")
end

function ExpressionPanel:OnHide()
    PGF.Logger:Debug("ExpressionPanel:OnHide")
end

function ExpressionPanel:OnReset()
    PGF.Logger:Debug("ExpressionPanel:OnReset")
    self.state.expression = ""
    self:Init(self.state)
end

function ExpressionPanel:GetFilterExpression()
    PGF.Logger:Debug("ExpressionPanel:GetFilterExpression")
    local userExp = PGF.RemoveCommentLines(self.state.expression)
    if PGF.Empty(userExp) then return "true" end
    return userExp
end

function ExpressionPanel:OnExpressionTextChanged()
    PGF.Logger:Debug("ExpressionPanel:OnExpressionTextChanged")
    self.state.expression = self.Advanced.Expression.EditBox:GetText()
    self:TriggerFilterExpressionChange()
end

function ExpressionPanel:TriggerFilterExpressionChange()
    PGF.Logger:Debug("ExpressionPanel:TriggerFilterExpressionChange")
    PGF.Dialog:OnFilterExpressionChanged()
end

hooksecurefunc("InputScrollFrame_OnTextChanged", function (self)
    PGF.Logger:Debug("InputScrollFrame_OnTextChanged")
    if self == ExpressionPanel.Advanced.Expression.EditBox then
        ExpressionPanel:OnExpressionTextChanged()
    end
end)

ExpressionPanel:OnLoad()
PGF.Dialog:RegisterPanel("default", ExpressionPanel)
