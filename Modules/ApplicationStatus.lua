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

PGF.hardDeclinedGroups = {}
PGF.softDeclinedGroups = {}

function PGF.GetDeclinedGroupsKey(searchResultInfo)
    return searchResultInfo.activityID .. searchResultInfo.leaderName
end

function PGF.IsDeclinedGroup(lookupTable, searchResultInfo)
    if searchResultInfo.leaderName then -- leaderName is not available for brand new groups
        local lastDeclined = lookupTable[PGF.GetDeclinedGroupsKey(searchResultInfo)] or 0
        if lastDeclined > time() - C.DECLINED_GROUPS_RESET then
            return true
        end
    end
    return false
end

function PGF.IsHardDeclinedGroup(searchResultInfo)
    return PGF.IsDeclinedGroup(PGF.hardDeclinedGroups, searchResultInfo)
end

function PGF.IsSoftDeclinedGroup(searchResultInfo)
    return PGF.IsDeclinedGroup(PGF.softDeclinedGroups, searchResultInfo)
end

function PGF.OnLFGListApplicationStatusUpdated(id, newStatus)
    -- possible newStatus: declined, declined_full, declined_delisted, timedout
    local searchResultInfo = C_LFGList.GetSearchResultInfo(id)
    if not searchResultInfo.leaderName then return end -- leaderName is not available for brand new groups
    if newStatus == "declined" then
        PGF.hardDeclinedGroups[PGF.GetDeclinedGroupsKey(searchResultInfo)] = time()
    elseif newStatus == "declined_delisted" or newStatus == "timedout" then
        PGF.softDeclinedGroups[PGF.GetDeclinedGroupsKey(searchResultInfo)] = time()
    end
end
