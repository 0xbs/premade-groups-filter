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
    if PGF.IsRetail() then
        if searchResultInfo.activityIDs and searchResultInfo.activityIDs[1] then
            searchResultInfo.activityID = searchResultInfo.activityIDs[1]
        end
        if searchResultInfo.leaderDungeonScoreInfo and searchResultInfo.leaderDungeonScoreInfo[1] then
            searchResultInfo.leaderDungeonScoreInfo = searchResultInfo.leaderDungeonScoreInfo[1]
        end
        if searchResultInfo.leaderPvpRatingInfo and searchResultInfo.leaderPvpRatingInfo[1] then
            searchResultInfo.leaderPvpRatingInfo = searchResultInfo.leaderPvpRatingInfo[1]
        end
    end
    return searchResultInfo
end
