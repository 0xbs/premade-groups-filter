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
            frame.ClassBar:SetSize(16, 3)
            frame.ClassBar:SetPoint("CENTER", 1, 0)
            frame.ClassBar:SetPoint("BOTTOM", 0, 3)

            frame.LeaderCrown = frame:CreateTexture("$parentLeaderCrown", "OVERLAY")
            frame.LeaderCrown:SetSize(10, 5)
            frame.LeaderCrown:SetPoint("TOP", 1, -5)
            frame.LeaderCrown:SetAtlas("groupfinder-icon-leader", false, "LINEAR")

            frame.SpecIcon = frame:CreateTexture("$parentSpecIcon", "BACKGROUND", nil, 1)
            frame.SpecIcon:SetSize(16, 16)
            frame.SpecIcon:SetPoint("CENTER", 1, -2)
            frame.SpecIcon:SetTexCoord(.08, .92, .08, .92) -- zoom in to remove borders

            frame.ClassCircle = frame:CreateTexture("$parentClassCircle", "BACKGROUND", nil, 2)
            frame.ClassCircle:SetSize(16, 16)
            frame.ClassCircle:SetPoint("CENTER", 1, -2)
            frame.ClassCircleMask = frame:CreateMaskTexture()
            frame.ClassCircleMask:SetSize(18, 18)
            frame.ClassCircleMask:SetAllPoints(frame.ClassCircle)
            frame.ClassCircleMask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            frame.ClassCircle:AddMaskTexture(frame.ClassCircleMask)

            frame.RoleIcon = frame:CreateTexture("$parentRoleIcon", "ARTWORK")
            frame.RoleIcon:SetSize(12, 12)
            frame.RoleIcon:SetPoint("CENTER", 1, -2)

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
        frames[i].SpecIcon:Hide()
        frames[i].ClassCircle:Hide()
        frames[i].RoleIcon:Hide()
    end

    if not PremadeGroupsFilterSettings.classBar and
       not PremadeGroupsFilterSettings.classCircle and
       not PremadeGroupsFilterSettings.specIcon and
       not PremadeGroupsFilterSettings.leaderCrown and
       not PremadeGroupsFilterSettings.missingRoles then
        return -- stop if all features are disabled
    end

    local appStatus, isApplication, isDeclined = PGF.GetAppStatus(self.resultID, searchResultInfo)
    if isApplication or isDeclined then
        return -- stop if special status
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
        if PremadeGroupsFilterSettings.specIcon then
            frames[i].SpecIcon:Show()
            frames[i].SpecIcon:SetTexture(members[i].specIcon)
            frames[i].SpecIcon:SetDesaturated(searchResultInfo.isDelisted)
            frames[i].SpecIcon:SetAlpha(searchResultInfo.isDelisted and 0.5 or 1.0)
        end
        if PremadeGroupsFilterSettings.leaderCrown and members[i].isLeader then
            frames[i].LeaderCrown:Show()
            frames[i].LeaderCrown:SetDesaturated(searchResultInfo.isDelisted)
            frames[i].LeaderCrown:SetAlpha(searchResultInfo.isDelisted and 0.5 or 1.0)
        end
    end

    if PremadeGroupsFilterSettings.missingRoles then
        local roleAtlas = PGF.IsRetail() and C.ROLE_ATLAS_BORDERLESS or C.ROLE_ATLAS
        local i = #members + 1
        for role, remainingKey in pairs(C.ROLE_REMAINING_KEYS) do
            local memberCounts = C_LFGList.GetSearchResultMemberCounts(self.resultID)
            local remaining = memberCounts[remainingKey]
            for _ = 1, remaining do
                if i > numIcons then return end
                frames[i]:Show()
                frames[i].RoleIcon:Show()
                frames[i].RoleIcon:SetAtlas(roleAtlas[role])
                frames[i].RoleIcon:SetDesaturated(true)
                frames[i].RoleIcon:SetAlpha(searchResultInfo.isDelisted and 0.5 or 1.0)
                i = i + 1
            end
        end
    end
end
