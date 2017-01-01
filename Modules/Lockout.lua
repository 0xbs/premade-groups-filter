-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2015 Elotheon-Arthas-EU
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

local LOCKOUT_D = {
    [1]  = C.NORMAL, -- normal dungeon
    [2]  = C.HEROIC, -- heroic dungeon
    [23] = C.MYTHIC, -- mythic dungeon
    [14] = C.NORMAL, -- normal raid
    [15] = C.HEROIC, -- heroic raid
    [16] = C.MYTHIC, -- mythic raid
}

local function matching(instanceName, name, instanceDifficulty, difficulty)
    return PGF.StartsWith(instanceName:lower(), name:lower()) and LOCKOUT_D[instanceDifficulty] == difficulty
end

function PGF.HasDungeonOrRaidLockout(activity)
    local avName, avShortName, avCategoryID = C_LFGList.GetActivityInfo(activity)
    local difficulty = PGF.GetDifficulty(activity, avName, avShortName)

    -- there are no IDs for normal and mythic+ dungeons
    if avCategoryID == C.TYPE_DUNGEON and (difficulty == C.NORMAL or difficulty == C.MYTHICPLUS) then
        return false, false
    end

    local numSavedInstances = GetNumSavedInstances()
    for index = 1, numSavedInstances do
        local instanceName, instanceID, instanceReset, instanceDifficulty,
            locked, extended, instanceIDMostSig, isRaid, maxPlayers,
            difficultyName, maxBosses, defeatedBosses = GetSavedInstanceInfo(index)
        if activity == 449 then maxBosses = 3 end -- Violet Hold has fixed 3 bosses during the weekly lockout
        if (extended or locked) and matching(instanceName, avName, instanceDifficulty, difficulty) then
            return true, maxBosses == defeatedBosses
        end
    end
    return false, false
end
