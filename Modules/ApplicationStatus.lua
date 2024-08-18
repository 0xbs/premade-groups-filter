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

function PGF.GetAppStatus(resultID, optionalSearchResultInfo)
    local searchResultInfo = optionalSearchResultInfo or C_LFGList.GetSearchResultInfo(resultID)
    local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID)
    local isApplication = appStatus ~= "none" or pendingStatus
    local isDeclined = appStatus == "declined" or appStatus == "declined_delisted" or appStatus == "declined_full"
    if LFGListFrame.declines then
        if not isDeclined and LFGListFrame.declines[searchResultInfo.partyGUID] then
            isDeclined = true
            appStatus = LFGListFrame.declines[searchResultInfo.partyGUID]
        end
    end
    return appStatus, isApplication, isDeclined
end

function PGF.GetGroupKey(searchResultInfo)
    if searchResultInfo.partyGUID then -- retail now provides a partyGUID
        return searchResultInfo.partyGUID
    elseif searchResultInfo.leaderName then -- leaderName is not available for very new groups
        return searchResultInfo.activityID .. searchResultInfo.leaderName
    else
        return nil
    end
end

function PGF.IsDeclinedGroup(lookupTable, searchResultInfo)
    local key = PGF.GetGroupKey(searchResultInfo)
    if not key then return false end
    local lastDeclined = lookupTable[key] or 0
    if lastDeclined > time() - C.DECLINED_GROUPS_RESET then
        return true
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
    local key = PGF.GetGroupKey(searchResultInfo)
    if not key then return end
    if newStatus == "declined" then
        PGF.hardDeclinedGroups[key] = time()
    elseif newStatus == "declined_delisted" or newStatus == "timedout" then
        PGF.softDeclinedGroups[key] = time()
    end
end
