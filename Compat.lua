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
    return not issecretvalue(value) and type(value) == "table" and canaccesstable(value)
end

function PGF.IsLFGRestricted()
    if not C_RestrictedActions or not C_RestrictedActions.GetAddOnRestrictionState then return false end
    local rt = Enum.AddOnRestrictionType
    local rs = Enum.AddOnRestrictionState

    local function IsRestricted(restriction)
        -- Include Activating: IsAddOnRestrictionActive returns false during
        -- ADDON_RESTRICTION_STATE_CHANGED, before restrictions are enforced.
        return C_RestrictedActions.GetAddOnRestrictionState(restriction) ~= rs.Inactive
    end

    -- Keep filtering available inside instances before and between pulls.
    return IsRestricted(rt.Map) and (
        IsRestricted(rt.Combat) or
        IsRestricted(rt.Encounter) or
        IsRestricted(rt.ChallengeMode))
end

function PGF.GetSearchResultInfo(resultID)
    if PGF.IsLFGRestricted() then return nil end
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
    -- In rare cases such as when an application is full or rejected,
    -- C_LFGList.GetSearchResultInfo returns nil.
    -- In restricted envs, the searchResultInfo table itself can be secret.
    if not IsAccessibleTable(searchResultInfo) or not searchResultInfo then
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
        if type(activityID) ~= "number" or issecretvalue(activityID) then return nil end
        return activityID
    end

    local activityID = searchResultInfo.activityID
    if type(activityID) ~= "number" or issecretvalue(activityID) then return nil end
    return activityID
end

function PGF.GetSearchResultLeaderDungeonScoreInfo(searchResultInfo)
    local scoreInfos = searchResultInfo.leaderDungeonScoreInfo
    if not IsAccessibleTable(scoreInfos) or not scoreInfos then return nil end
    return scoreInfos[1]
end

function PGF.GetSearchResultLeaderPvpRatingInfo(searchResultInfo)
    local ratingInfos = searchResultInfo.leaderPvpRatingInfo
    if not IsAccessibleTable(ratingInfos) or not ratingInfos then return nil end
    return ratingInfos[1]
end

function PGF.GetActivityInfoTable(activityID)
    return C_LFGList.GetActivityInfoTable(activityID)
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
