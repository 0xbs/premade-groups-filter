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

local function RestoreComponents(self, textWidth)
    self.Name:SetWidth(textWidth)
    self.ActivityName:SetWidth(textWidth)
    self.PendingLabel:ClearAllPoints()
    self.PendingLabel:SetSize(70, 0)
    self.PendingLabel:SetJustifyH("RIGHT")
    self.ExpirationTime:ClearAllPoints()
    self.ExpirationTime:SetSize(35, 12)
    self.ExpirationTime:SetPoint("RIGHT", -35, -1)
    self.ExpirationTime:SetJustifyH("LEFT")
    self.CancelButton:SetFrameStrata("MEDIUM")
    self.CancelButton:ClearAllPoints()
    self.CancelButton:SetPoint("RIGHT", self.DataDisplay, "RIGHT", -8, 0)
    self.CancelButton:SetSize(26, 24)
    if self.ExpirationTime:IsShown() then
        self.PendingLabel:SetPoint("RIGHT", self.ExpirationTime, "LEFT", -3, 0);
    else
        self.PendingLabel:SetPoint("RIGHT", self.ExpirationTime, "RIGHT", -3, 0);
    end
end

local function MoveComponents(self)
    self.Name:SetWidth(176 - 70)
    self.ActivityName:SetWidth(176 - 70)
    self.PendingLabel:ClearAllPoints()
    self.PendingLabel:SetSize(70, 15)
    self.PendingLabel:SetPoint("TOP", 0, -4)
    self.PendingLabel:SetPoint("RIGHT", self.DataDisplay, "LEFT", 10, 0)
    self.PendingLabel:SetJustifyH("RIGHT")
    self.PendingLabel:SetText(self.PendingLabel:GetText():gsub(" - $", "", 1))
    self.ExpirationTime:ClearAllPoints()
    self.ExpirationTime:SetSize(70, 15)
    self.ExpirationTime:SetPoint("BOTTOM", 0, 4)
    self.ExpirationTime:SetPoint("RIGHT", self.DataDisplay, "LEFT", 10, 0)
    self.ExpirationTime:SetJustifyH("RIGHT")
    self.CancelButton:SetFrameStrata("HIGH")
    self.CancelButton:ClearAllPoints()
    self.CancelButton:SetPoint("RIGHT", self.DataDisplay, "RIGHT", -8, 0)
    self.CancelButton:SetSize(22, 20)
end

function PGF.ToggleAlwaysShowMembers(self, searchResultInfo, textWidth)
    if not PremadeGroupsFilterSettings.alwaysShowMembers then
        return -- stop if feature disabled
    end

    if LFGListFrame.SearchPanel.categoryID ~= GROUP_FINDER_CATEGORY_ID_DUNGEONS then
        return -- stop if not dungeons
    end

    RestoreComponents(self, textWidth)
    local appStatus, isApplication, isDeclined = PGF.GetAppStatus(self.resultID, searchResultInfo)
    if isApplication or isDeclined then
        MoveComponents(self)
        self.DataDisplay:SetShown(true)
    end
end
