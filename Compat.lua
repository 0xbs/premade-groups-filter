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

function PGF.GetSearchResultInfo(resultID)
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
    -- In rare cases such as when an application is full or rejected,
    -- C_LFGList.GetSearchResultInfo returns nil
    if not searchResultInfo then
        return nil
    end
    if searchResultInfo.activityIDs then
        searchResultInfo.activityID = searchResultInfo.activityIDs[1]
    end
    if searchResultInfo.leaderDungeonScoreInfo then
        searchResultInfo.leaderDungeonScoreInfo = searchResultInfo.leaderDungeonScoreInfo[1]
    end
    if searchResultInfo.leaderPvpRatingInfo then
        searchResultInfo.leaderPvpRatingInfo = searchResultInfo.leaderPvpRatingInfo[1]
    end
    return searchResultInfo
end

function PGF.GetSearchResultPlayerInfo(...)
    return C_LFGList.GetSearchResultPlayerInfo(...)
end

function PGF.GetSearchResultMemberInfo(...)
    local info = C_LFGList.GetSearchResultPlayerInfo(...)
    if info then
        return info.assignedRole, info.classFilename, info.className, info.specName, info.isLeader
    end
end
