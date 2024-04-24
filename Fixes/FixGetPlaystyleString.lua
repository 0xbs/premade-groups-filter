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

function PGF.FixGetPlaystyleStringIfPlayerAuthenticated()
    -- By overwriting C_LFGList.GetPlaystyleString, we taint the code writing the tooltip (which does not matter),
    -- and also code related to the dropdows where you can select the playstyle. The only relevant protected function
    -- here is C_LFGList.SetEntryTitle, which is only called from LFGListEntryCreation_SetTitleFromActivityInfo.
    -- Players that do not have an authenticator attached to their account cannot set the title or comment when creating
    -- groups. Instead, Blizzard sets the title programmatically. If we taint this function, these players can not create
    -- groups anymore, so we check on an arbitrary mythic plus dungeon if the player is authenticated to create a group.
    local activityIdOfArbitraryMythicPlusDungeon = 1160 -- Algeth'ar Academy
    if not C_LFGList.IsPlayerAuthenticatedForLFG(activityIdOfArbitraryMythicPlusDungeon) then
        print(L["message.noplaystylefix"])
        return
    end

    -- Overwrite C_LFGList.GetPlaystyleString with a custom implementation because the original function is
    -- hardware protected, causing an error when a group tooltip is shown as we modify the search result list.
    -- Original code from https://github.com/ChrisKader/LFMPlus/blob/36bca68720c724bf26cdf739614d99589edb8f77/core.lua#L38
    -- but sligthly modified.
    C_LFGList.GetPlaystyleString = function(playstyle, activityInfo)
        if not ( activityInfo and playstyle and playstyle ~= 0
                and C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID).showPlaystyleDropdown ) then
            return nil
        end
        local globalStringPrefix
        if activityInfo.isMythicPlusActivity then
            globalStringPrefix = "GROUP_FINDER_PVE_PLAYSTYLE"
        elseif activityInfo.isRatedPvpActivity then
            globalStringPrefix = "GROUP_FINDER_PVP_PLAYSTYLE"
        elseif activityInfo.isCurrentRaidActivity then
            globalStringPrefix = "GROUP_FINDER_PVE_RAID_PLAYSTYLE"
        elseif activityInfo.isMythicActivity then
            globalStringPrefix = "GROUP_FINDER_PVE_MYTHICZERO_PLAYSTYLE"
        end
        return globalStringPrefix and _G[globalStringPrefix .. tostring(playstyle)] or nil
    end

    -- Disable automatic group titles to prevent tainting errors
    LFGListEntryCreation_SetTitleFromActivityInfo = function(_) end
end
