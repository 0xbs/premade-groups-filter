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
            frame:SetSize(18, 36)
            frame:SetPoint("CENTER")
            frame:SetPoint("RIGHT", self, "RIGHT", -12 - (numIcons - iconIndex) * 18, 0)

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

    local members = {}
    for i = 1, searchResultInfo.numMembers do
        local role, class, classLocalized = C_LFGList.GetSearchResultMemberInfo(self.resultID, i)
        local color = searchResultInfo.isDelisted and { r = 0.2, g = 0.2, b = 0.2 } or RAID_CLASS_COLORS[class]
        table.insert(members, {
            role = role,
            class = class,
            classLocalized = classLocalized,
            color = color,
            leader = i == 1,
        })
    end

    local ROLE_ORDER = {
        ["TANK"] = 1,
        ["HEALER"] = 2,
        ["DAMAGER"] = 3,
    }
    table.sort(members, function (a, b) -- sort by role, class
        if ROLE_ORDER[a.role] ~= ROLE_ORDER[b.role] then
            return ROLE_ORDER[a.role] < ROLE_ORDER[b.role]
        end
        return a.class < b.class
    end)

    local ROLE_ICON = {
        ["TANK"] = "roleicon-tiny-tank",
        ["HEALER"] = "roleicon-tiny-healer",
        ["DAMAGER"] = "roleicon-tiny-dps",
    }
    for i = 1, #members do
        frames[i]:Show()
        if PremadeGroupsFilterSettings.classBar then
            frames[i].ClassBar:Show()
            frames[i].ClassBar:SetColorTexture(members[i].color.r, members[i].color.g, members[i].color.b, 1)
        end
        if PremadeGroupsFilterSettings.classCircle then
            frames[i].ClassCircle:Show()
            frames[i].ClassCircle:SetColorTexture(members[i].color.r, members[i].color.g, members[i].color.b, 1)
            frames[i].RoleIcon:Show()
            frames[i].RoleIcon:SetAtlas(ROLE_ICON[members[i].role])
            frames[i].RoleIcon:SetDesaturated(searchResultInfo.isDelisted)
            frames[i].RoleIcon:SetAlpha(searchResultInfo.isDelisted and 0.5 or 1.0)
        end
        if PremadeGroupsFilterSettings.leaderCrown and members[i].leader then
            frames[i].LeaderCrown:Show()
            frames[i].LeaderCrown:SetDesaturated(searchResultInfo.isDelisted)
            frames[i].LeaderCrown:SetAlpha(searchResultInfo.isDelisted and 0.5 or 1.0)
        end
    end
end
