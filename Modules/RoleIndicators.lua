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

PGF.roleIndicators = {}
function PGF.GetOrCreateRoleIndicatorFrames(self, numIcons)
    -- creating frames each time will soon flood the UI with frames, so we create them once for each search result frame
    -- we store our frame in our own table to avoid any taint of the search result frame
    local frames = PGF.roleIndicators[self]
    if frames == nil then
        frames = {}
        for iconIndex = 1, numIcons do
            local frame = CreateFrame("Frame", nil, self, nil)
            frame:Hide()
            frame:SetFrameStrata("HIGH")
            frame:SetSize(18, 35)
            frame:SetPoint("CENTER", 0, 1)
            frame:SetPoint("RIGHT", self, "RIGHT", -13 - (numIcons - iconIndex) * 18, 0)

            frame.ClassBar = frame:CreateTexture("$parentClassBar", "OVERLAY")
            frame.ClassBar:SetSize(14, 3)
            frame.ClassBar:SetPoint("CENTER")
            frame.ClassBar:SetPoint("BOTTOM", 0, 3)

            frame.LeaderCrown = frame:CreateTexture("$parentLeaderCrown", "OVERLAY")
            frame.LeaderCrown:SetSize(10, 5)
            frame.LeaderCrown:SetPoint("TOP", 0, -5)
            frame.LeaderCrown:SetAtlas("groupfinder-icon-leader", false, "LINEAR")

            frame.ClassCircle = frame:CreateTexture("$parentClassCircle", "BACKGROUND")
            frame.ClassCircle:SetSize(16, 16)
            frame.ClassCircle:SetPoint("CENTER", 0, -1)
            frame.ClassCircleMask = frame:CreateMaskTexture()
            frame.ClassCircleMask:SetSize(18, 18)
            frame.ClassCircleMask:SetAllPoints(frame.ClassCircle)
            frame.ClassCircleMask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            frame.ClassCircle:AddMaskTexture(frame.ClassCircleMask)

            frame.RoleIcon = frame:CreateTexture("$parentRoleIcon", "ARTWORK")
            frame.RoleIcon:SetSize(12, 12)
            frame.RoleIcon:SetPoint("CENTER", 0, -1)

            frames[iconIndex] = frame
        end
        PGF.roleIndicators[self] = frames
    end
    return frames
end

function PGF.AddRoleIndicators(self, searchResultInfo)
    local numIcons = #self.DataDisplay.Enumerate.Icons -- should always be 5 for Enum.LFGListDisplayType.RoleEnumerate
    local frames = PGF.GetOrCreateRoleIndicatorFrames(self, numIcons)

    -- reset
    for i = 1, numIcons do
        frames[i]:Hide()
        frames[i].ClassBar:Hide()
        frames[i].LeaderCrown:Hide()
        frames[i].ClassCircle:Hide()
        frames[i].RoleIcon:Hide()
    end

    if not PremadeGroupsFilterSettings.classBar and
       not PremadeGroupsFilterSettings.classCircle and
       not PremadeGroupsFilterSettings.leaderCrown then
        return -- stop if all features are disabled
    end

    local _, appStatus, pendingStatus = C_LFGList.GetApplicationInfo(self.resultID)
    if appStatus ~= "none" or pendingStatus then
        return -- stop if already applied/invited/timedout/declined/declined_full/declined_delisted
    end

    local activityInfo = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)
    if activityInfo.displayType ~= Enum.LFGListDisplayType.RoleEnumerate then
        return -- only show rings on role enumerations like dungeon groups
    end

    local members = PGF.GetSearchResultMemberInfoTable(self.resultID, searchResultInfo.numMembers)
    for i = 1, #members do
        local color = searchResultInfo.isDelisted and { r = 0.2, g = 0.2, b = 0.2 } or members[i].classColor
        frames[i]:Show()
        if PremadeGroupsFilterSettings.classBar then
            frames[i].ClassBar:Show()
            frames[i].ClassBar:SetColorTexture(color.r, color.g, color.b, 1)
        end
        if PremadeGroupsFilterSettings.classCircle then
            frames[i].ClassCircle:Show()
            frames[i].ClassCircle:SetColorTexture(color.r, color.g, color.b, 1)
            frames[i].RoleIcon:Show()
            frames[i].RoleIcon:SetAtlas(members[i].roleAtlas)
            frames[i].RoleIcon:SetDesaturated(searchResultInfo.isDelisted)
            frames[i].RoleIcon:SetAlpha(searchResultInfo.isDelisted and 0.5 or 1.0)
        end
        if PremadeGroupsFilterSettings.leaderCrown and members[i].isLeader then
            frames[i].LeaderCrown:Show()
            frames[i].LeaderCrown:SetDesaturated(searchResultInfo.isDelisted)
            frames[i].LeaderCrown:SetAlpha(searchResultInfo.isDelisted and 0.5 or 1.0)
        end
    end
end
