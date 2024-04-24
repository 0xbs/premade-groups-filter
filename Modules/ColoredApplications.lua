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

function PGF.ColorApplications(self, searchResultInfo)
    if not self.NoSlotLeftBG then
        local noSlotLeftBg = self:CreateTexture("NoSlotLeftBG", "BACKGROUND")
        noSlotLeftBg:SetColorTexture(0.4, 0.0, 0.0, 1.0)
        noSlotLeftBg:SetPoint("TOPLEFT", 3, -2)
        noSlotLeftBg:SetPoint("BOTTOMRIGHT", -3, 0)
        self.NoSlotLeftBG = noSlotLeftBg
    end
    self.NoSlotLeftBG:Hide()

    if not PremadeGroupsFilterSettings.coloredApplications then return end
    if searchResultInfo.isDelisted then return end

    local activityInfo = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)
    if not activityInfo.isMythicPlusActivity then return end

    local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(self.resultID)
    local isApplication = (appStatus ~= "none" or pendingStatus)
    if not isApplication then return end

    local memberCounts = C_LFGList.GetSearchResultMemberCounts(self.resultID)
    local hasRemainingSlots = PGF.HasRemainingSlotsForLocalPlayerPartyRoles(memberCounts)
    if not hasRemainingSlots then
        self.NoSlotLeftBG:Show()
    end
end
