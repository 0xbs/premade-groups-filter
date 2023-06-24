-------------------------------------------------------------------------------
-- Premade Groups Filter - LFM Panel
-------------------------------------------------------------------------------
-- Copyright (C) 2023 Teelo-Jubei'thos-OCE, Elotheon-Arthas-EU
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

local LFMPanel = CreateFrame("Frame", "PremadeGroupsFilterLFMPanel", PGF.Dialog, "PremadeGroupsFilterLFMPanelTemplate")

function LFMPanel:OnLoad()
    PGF.Logger:Debug("LFMPanel:OnLoad")
    self.name = "lfm"

    -- Group
    self.Group.Title:SetText(L["dialog.filters.group"])
    PGF.UI_SetupMinMaxField(self, self.Group.ItemLevel, "itemlevel")
    PGF.UI_SetupMinMaxField(self, self.Group.MPRating, "mprating")
    PGF.UI_SetupCheckBox(self, self.Group.Tank, "tank")
    PGF.UI_SetupCheckBox(self, self.Group.Healer, "healer")
    PGF.UI_SetupCheckBox(self, self.Group.DPS, "dps")
end

function LFMPanel:Init(state)
    PGF.Logger:Debug("LFMPanel:Init")
    self.state = state
    self.state.itemlevel = self.state.itemlevel or {}
    self.state.mprating = self.state.mprating or {}

    self.Group.ItemLevel.Act:SetChecked(self.state.itemlevel.act or false)
    self.Group.ItemLevel.Min:SetText(self.state.itemlevel.min or "")
    self.Group.ItemLevel.Max:SetText(self.state.itemlevel.max or "")
    self.Group.MPRating.Act:SetChecked(self.state.mprating.act or false)
    self.Group.MPRating.Min:SetText(self.state.mprating.min or "")
    self.Group.MPRating.Max:SetText(self.state.mprating.max or "")
    self.Group.Tank.Act:SetChecked(self.state.tank)
    self.Group.Healer.Act:SetChecked(self.state.healer)
    self.Group.DPS.Act:SetChecked(self.state.dps)
    
    self.RefreshButton:SetText(L["dialog.refresh"])
    self.RefreshButton:SetScript("OnClick", function () self:OnRefreshButtonClick() end)
end

function LFMPanel:OnShow()
    PGF.Logger:Debug("LFMPanel:OnShow")
    PGF.Dialog.MaximizeMinimizeFrame:Hide()
    PGF.Dialog.ResetButton:Hide()
    PGF.Dialog.RefreshButton:Hide()
end

function LFMPanel:OnHide()
    PGF.Logger:Debug("LFMPanel:OnHide")
    PGF.Dialog.MaximizeMinimizeFrame:Show()
    PGF.Dialog.ResetButton:Show()
    PGF.Dialog.RefreshButton:Show()
end

function LFMPanel:OnReset()
    PGF.Logger:Debug("LFMPanel:OnReset")
    self.state.itemlevel.act = false
    self.state.itemlevel.min = ""
    self.state.itemlevel.max = ""
    self.state.mprating.act = false
    self.state.mprating.min = ""
    self.state.mprating.max = ""
    self.state.tank = true
    self.state.healer = true
    self.state.dps = true
    self:Init(self.state)
end

function LFMPanel:OnUpdateExpression(expression, sorting)
    PGF.Logger:Debug("LFMPanel:OnUpdateExpression")
end

function LFMPanel:TriggerFilterExpressionChange()
    PGF.Logger:Debug("LFMPanel:TriggerFilterExpressionChange")
end

function LFMPanel:GetFilterExpression()
    PGF.Logger:Debug("LFMPanel:GetFilterExpression")
    return "true"
end

function LFMPanel:GetSortingExpression()
    return nil
end

function LFMPanel:TogglePartyfit()
    PGF.Logger:Debug("LFMPanel:TogglePartyfit")
end

function LFMPanel:Refresh()
    PGF.Logger:Debug("LFMPanel:Refresh")
    local applicants = {LFGListFrame.ApplicationViewer.ScrollBox.ScrollTarget:GetChildren()}
    for _, data in pairs(applicants) do
        if data.numMembers == 1 then -- I don't have enough accounts to test how multiple applications works
            local applicant = data.Member1
            local name = applicant.Name:GetText()
            local rating = applicant.Rating:GetText()
            rating = tonumber(rating)
            local itemLevel = applicant.ItemLevel:GetText()
            itemLevel = tonumber(itemLevel)
            local role1 = applicant.RoleIcon1.role
            local role2 = applicant.RoleIcon2.role
            local role3 = applicant.RoleIcon3.role
            
            local decline = false
            
            if self.state.itemlevel and self.state.itemlevel.act then
                local min = self.state.itemlevel.min
                if not min or min == "" then min = 0 end
                min = tonumber(min)
                
                if min > itemLevel then decline = true end
                
                local max = self.state.itemlevel.max
                if not max or max == "" then max = 9001 end -- over nine thousannnnnd
                max = tonumber(max)
                
                if itemLevel > max then decline = true end
            end
            
            if self.state.mprating and self.state.mprating.act then
                local min = self.state.mprating.min
                if not min or min == "" then min = 0 end
                min = tonumber(min)
                
                if min > rating then decline = true end
                
                local max = self.state.mprating.max
                if not max or max == "" then max = 9001 end
                
                if rating > max then decline = true end
            end
            
            if not decline then
                local allow = false
                if self.state.tank then
                    if (role1 == "TANK") or (role2 == "TANK") or (role3 == "TANK") then
                        allow = true
                    end
                end
                
                if self.state.healer then
                    if (role1 == "HEALER") or (role2 == "HEALER") or (role3 == "HEALER") then
                        allow = true
                    end
                end
                
                if self.state.dps then
                    if (role1 == "DAMAGER") or (role2 == "DAMAGER") or (role3 == "DAMAGER") then
                        allow = true
                    end
                end
                
                if not allow then decline = true end
            end            
            
            if decline then
                PGF.Logger:Debug("Declining: "..name)
                data.DeclineButton:Click()
            end
        end
    end
end

-- testing found the Decline Button does not work if Click() is not called in response to a hardware event
-- so this will only work when the player clicks this custom refresh button
function LFMPanel:OnRefreshButtonClick()
    PGF.Logger:Debug("LFMPanel:OnRefreshButtonClick")
    self:Refresh()
end

LFMPanel:OnLoad()
PGF.Dialog:RegisterPanel("c-1f0", LFMPanel)
