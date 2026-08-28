-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2026 Bernhard Saumweber
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

-- Assumption: if there is no issecretvalue function, the value is never secret
local issecretvalue = issecretvalue or function () return false end
-- Assumption: clients without canaccesstable do not restrict table access
local canaccesstable = canaccesstable or function () return true end

local function IsAccessibleTable(value)
    return not issecretvalue(value) and canaccesstable(value)
end

function PGF.GetSearchResultInfo(resultID)
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
    -- In rare cases such as when an application is full or rejected,
    -- C_LFGList.GetSearchResultInfo returns nil.
    -- In restricted envs, the searchResultInfo table itself can be secret.
    if not searchResultInfo or not IsAccessibleTable(searchResultInfo) then
        return nil
    end
    return searchResultInfo
end

function PGF.GetSearchResultActivityID(searchResultInfo)
    local activityIDs = searchResultInfo.activityIDs
    if issecretvalue(activityIDs) then return nil end
    if activityIDs then
        if not IsAccessibleTable(activityIDs) then return nil end
        local activityID = activityIDs[1]
        return not issecretvalue(activityID) and activityID or nil
    end

    local activityID = searchResultInfo.activityID
    return not issecretvalue(activityID) and activityID or nil
end

function PGF.GetSearchResultLeaderDungeonScoreInfo(searchResultInfo)
    local scoreInfos = searchResultInfo.leaderDungeonScoreInfo
    if not scoreInfos or issecretvalue(scoreInfos) then return nil end
    if not IsAccessibleTable(scoreInfos) then return nil end
    return scoreInfos[1]
end

function PGF.GetSearchResultLeaderPvpRatingInfo(searchResultInfo)
    local ratingInfos = searchResultInfo.leaderPvpRatingInfo
    if not ratingInfos or issecretvalue(ratingInfos) then return nil end
    if not IsAccessibleTable(ratingInfos) then return nil end
    return ratingInfos[1]
end

function PGF.GetActivityInfoTable(resultID)
    return C_LFGList.GetActivityInfoTable(resultID)
end

function PGF.GetSearchResultPlayerInfo(...)
    return C_LFGList.GetSearchResultPlayerInfo(...)
end

function PGF.GetSearchResultMemberCounts(resultID)
    return C_LFGList.GetSearchResultMemberCounts(resultID)
end

function PGF.GetSearchResultEncounterInfo(resultID)
    return C_LFGList.GetSearchResultEncounterInfo(resultID)
end
