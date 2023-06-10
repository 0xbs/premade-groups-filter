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

-- Panel ID
-- cX  see C.CATEGORY_ID
-- f0  Default
-- f1  Recommended    -- raids
-- f2  NotRecommended -- raids
-- f4  PvE            -- custom
-- f8  PvP            -- custom

local PGFDialog = CreateFrame("Frame", "PremadeGroupsFilterDialog", PVEFrame, "PremadeGroupsFilterDialogTemplate")

function PGFDialog:OnLoad()
    PGF.Logger:Debug("PGFDialog:OnLoad")
    self.panels = {}
    self.activePanel = nil

    self:SetScript("OnShow", self.OnShow)
    self:SetScript("OnMouseDown", self.OnMouseDown)
    self:SetScript("OnMouseUp", self.OnMouseUp)

    self:SetBorder("ButtonFrameTemplateNoPortraitMinimizable")
    self:SetPortraitShown(false)
    self:SetTitle(L["addon.name.long"])
    self.MaximizeMinimizeFrame:SetOnMaximizedCallback(self.OnMaximize)
    self.MaximizeMinimizeFrame:SetOnMinimizedCallback(self.OnMinimize)

    self.ResetButton:SetText(L["dialog.reset"])
    self.ResetButton:SetScript("OnClick", self.OnResetButtonClick)
    self.RefreshButton:SetText(L["dialog.refresh"])
    self.RefreshButton:SetScript("OnClick", self.OnRefreshButtonClick)
end

function PGFDialog:OnShow()
    PGF.Logger:Debug("PGFDialog:OnShow")
end

function PGFDialog:OnHide()
    PGF.Logger:Debug("PGFDialog:OnHide")
end

function PGFDialog:OnMouseDown(button)
    if not PremadeGroupsFilterSettings.dialogMovable then return end
    self:StartMoving()
end

function PGFDialog:OnMouseUp(button)
    if not PremadeGroupsFilterSettings.dialogMovable then return end
    self:StopMovingOrSizing()
    if button == "RightButton" then
        self:ResetPosition(self)
    end
end

function PGFDialog:OnMaximize()
    PGF.Logger:Debug("PGFDialog:OnMaximize")
end

function PGFDialog:OnMinimize()
    PGF.Logger:Debug("PGFDialog:OnMinimize")
end

function PGFDialog:OnResetButtonClick()
    PGF.Logger:Debug("PGFDialog:OnResetButtonClick")
    PGF.StaticPopup_Show("PGF_CONFIRM_RESET")
end

function PGFDialog:OnResetConfirm()
    PGF.Logger:Debug("PGFDialog:OnResetConfirm")
    self.activePanel:OnReset()
end

function PGFDialog:OnRefreshButtonClick()
    PGF.Logger:Debug("PGFDialog:OnRefreshButtonClick")
    LFGListSearchPanel_DoSearch(LFGListFrame.SearchPanel)
end

function PGFDialog:Toggle()
    PGF.Logger:Debug("PGFDialog:Toggle")
    local isSearchPanelVisible = PVEFrame:IsVisible()
            and LFGListFrame.activePanel == LFGListFrame.SearchPanel
            and LFGListFrame.SearchPanel:IsVisible()
    -- TODO check if PGF checkbox is active
    if isSearchPanelVisible then
        self:Show()
    else
        self:Hide()
    end
end

function PGFDialog:UpdateActivePanel(categoryID, filters, baseFilters)
    PGF.Logger:Debug("PGFDialog:SetActivePanel(".. categoryID ..", "..filters..", "..baseFilters..")")
    local allFilters = bit.bor(baseFilters, filters);
    local id = "c"..categoryID.."f"..allFilters
    local panel = self.panels[id] or self.panels.default
    local state = self:GetPanelState(panel.name, id)
    if self.activePanel then self.activePanel:Hide() end
    self.activePanel = panel
    self.activePanel:Init(state)
    self.activePanel:Show()
end

function PGFDialog:GetPanelState(name, id)
    if not PremadeGroupsFilterState["panels"] then
        PremadeGroupsFilterState["panels"] = {}
    end
    if not PremadeGroupsFilterState["panels"][name] then
        PremadeGroupsFilterState["panels"][name] = {}
    end
    if not PremadeGroupsFilterState["panels"][name][id] then
        PremadeGroupsFilterState["panels"][name][id] = {}
    end
    return PremadeGroupsFilterState["panels"][name][id]
end

function PGFDialog:OnFilterExpressionChanged()
    PGF.Logger:Debug("PGFDialog:OnFilterExpressionChanged")
end

function PGFDialog:GetFilterExpression()
    PGF.Logger:Debug("PGFDialog:GetFilterExpression")
    if not self.activePanel then return nil end
    return self.activePanel:GetFilterExpression()
end

function PGFDialog:ResetPosition()
    PGF.Logger:Debug("PGFDialog:ResetPosition")
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", PVEFrame, "TOPRIGHT")
end

function PGFDialog:RegisterPanel(id, panel)
    PGF.Logger:Debug("PGFDialog:RegisterPanel("..id..")")
    self.panels[id] = panel
end

hooksecurefunc("LFGListSearchPanel_SetCategory", function(self, categoryID, filters, baseFilters)
    PGFDialog:UpdateActivePanel(categoryID, filters, baseFilters)
end)
hooksecurefunc("LFGListFrame_SetActivePanel", function () PGFDialog:Toggle() end)
hooksecurefunc("PVEFrame_ShowFrame", function () PGFDialog:Toggle() end)
PVEFrame:HookScript("OnShow", function () PGFDialog:Toggle() end)
PVEFrame:HookScript("OnHide", function () PGFDialog:Toggle() end)

PGFDialog:OnLoad()
PGF.Dialog = PGFDialog
