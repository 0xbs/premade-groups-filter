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
        if searchResultInfo.activityIDs then
            searchResultInfo.activityID = searchResultInfo.activityIDs[1]
        end
        if searchResultInfo.leaderDungeonScoreInfo then
            searchResultInfo.leaderDungeonScoreInfo = searchResultInfo.leaderDungeonScoreInfo[1]
        end
        if searchResultInfo.leaderPvpRatingInfo then
            searchResultInfo.leaderPvpRatingInfo = searchResultInfo.leaderPvpRatingInfo[1]
        end
    end
    return searchResultInfo
end

function PGF.GetSearchResultMemberInfo(...)
    if PGF.IsRetail() then
        local info = C_LFGList.GetSearchResultPlayerInfo(...)
        -- DevTools_Dump(info)
        -- assignedRole="HEALER"
        -- classFilename="SHAMAN"
        -- className="Schamane"
        -- specName="Wiederherstellung"
        -- isLeader=false
        -- name="Foo"
        -- level=80
        -- lfgRoles = { tank=false, dps=false, healer=false }
        if info then
            return info.assignedRole, info.classFilename, info.className, info.specName, info.isLeader
        end
    else
        return C_LFGList.GetSearchResultMemberInfo(...)
    end
end
