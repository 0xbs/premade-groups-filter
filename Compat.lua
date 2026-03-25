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

function PGF.GetSearchResultInfo(resultID)
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
    -- In rare cases such as when an application is full or rejected,
    -- C_LFGList.GetSearchResultInfo returns nil
    if not searchResultInfo then
        return nil
    end
    -- Copy the table to avoid tainting the original Blizzard data
    local info = PGF.Table_Copy_Rec(searchResultInfo)
    if info.activityIDs then
        info.activityID = info.activityIDs[1]
    end
    if info.leaderDungeonScoreInfo then
        info.leaderDungeonScoreInfo = info.leaderDungeonScoreInfo[1]
    end
    if info.leaderPvpRatingInfo then
        info.leaderPvpRatingInfo = info.leaderPvpRatingInfo[1]
    end
    return info
end

function PGF.GetActivityInfoTable(resultID)
    -- Copy the table to avoid tainting the original Blizzard data
    return PGF.Table_Copy_Rec(C_LFGList.GetActivityInfoTable(resultID))
end

function PGF.GetSearchResultPlayerInfo(...)
    -- Copy the table to avoid tainting the original Blizzard data
    return PGF.Table_Copy_Rec(C_LFGList.GetSearchResultPlayerInfo(...))
end

function PGF.GetSearchResultMemberInfo(...)
    local info = C_LFGList.GetSearchResultPlayerInfo(...)
    if info then
        return info.assignedRole, info.classFilename, info.className, info.specName, info.isLeader, info.isLeaver
    end
end

function PGF.GetSearchResultMemberCounts(resultID)
    return PGF.Table_Copy_Rec(C_LFGList.GetSearchResultMemberCounts(resultID))
end

function PGF.GetSearchResultEncounterInfo(resultID)
    return PGF.Table_Copy_Rec(C_LFGList.GetSearchResultEncounterInfo(resultID))
end
