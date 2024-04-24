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

local UsePGFButton = CreateFrame("CheckButton", "UsePGFButton", LFGListFrame.SearchPanel, "UICheckButtonTemplate")

function UsePGFButton:OnLoad()
    PGF.Logger:Debug("UsePGFButton:OnLoad")
    self:SetSize(26, 26)
    self:SetHitRectInsets(-2, -30, -2, -2)
    self.Text:SetText(L["addon.name.short"])
    self.Text:SetFontObject("GameFontHighlight")
    self.Text:SetWidth(30)
    self:SetPoint("LEFT", LFGListFrame.SearchPanel.RefreshButton, "LEFT", -62, 0)
    self:SetPoint("TOP", LFGListFrame.SearchPanel.RefreshButton, "TOP", 0, -3)
    self:SetScript("OnClick", function (self, button, down)
        local enabled = self:GetChecked()
        PGF.Dialog:SetEnabled(enabled)
    end)
    self:SetScript("OnMouseUp", function (self, button)
        if button == "RightButton" then
            PGF.Dialog:ResetPosition()
        end
    end)
    self:SetScript("OnEnter", function (self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["addon.name.long"], 1, 1, 1)
        GameTooltip:AddLine(L["dialog.usepgf.tooltip"], nil, nil, nil, true)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["dialog.usepgf.usage"], nil, nil, nil, true)
        if PGF.numResultsBeforeFilter > 0 then
            local removed = PGF.numResultsBeforeFilter - PGF.numResultsAfterFilter
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(string.format(L["dialog.usepgf.results.server"], PGF.numResultsBeforeFilter))
            GameTooltip:AddLine(string.format(L["dialog.usepgf.results.removed"], removed))
            GameTooltip:AddLine(string.format(L["dialog.usepgf.results.displayed"], PGF.numResultsAfterFilter))
        end
        GameTooltip:Show()
    end)
    self:SetScript("OnLeave", function () GameTooltip:Hide() end)
    PGF.UsePGFButton = self
end

function UsePGFButton:UpdateChecked()
    PGF.Logger:Debug("UsePGFButton:UpdateChecked")
    local enabled = PGF.Dialog:GetEnabled()
    self:SetChecked(enabled)
end

hooksecurefunc("LFGListSearchPanel_SetCategory", function () UsePGFButton:UpdateChecked() end) -- works if loaded after PGFDialog
--hooksecurefunc("LFGListFrame_SetActivePanel", function () UsePGFButton:OnShow() end)
--hooksecurefunc("PVEFrame_ShowFrame", function () UsePGFButton:OnShow() end)
--PVEFrame:HookScript("OnShow", function () UsePGFButton:OnShow() end)

UsePGFButton:OnLoad()
PGF.UsePGFButton = UsePGFButton
