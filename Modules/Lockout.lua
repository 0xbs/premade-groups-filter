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

local LOCKOUT_D = {
    [1]  = C.NORMAL, -- normal dungeon
    [2]  = C.HEROIC, -- heroic dungeon
    [23] = C.MYTHIC, -- mythic dungeon
    [14] = C.NORMAL, -- normal raid
    [15] = C.HEROIC, -- heroic raid
    [16] = C.MYTHIC, -- mythic raid
}

function PGF.IsMatchingInstance(lockoutName, activityName, lockoutDifficulty, activityDifficulty)
    -- no match if difficulty does not match
    if not (LOCKOUT_D[lockoutDifficulty] == activityDifficulty) then return false end
    return PGF.IsMostLikelySameInstance(lockoutName, activityName)
end

function PGF.GetLockoutInfo(activity, resultID)
    local activityInfo = C_LFGList.GetActivityInfoTable(activity)
    local difficulty = C.ACTIVITY[activity].difficulty
    local encounterInfo = C_LFGList.GetSearchResultEncounterInfo(resultID)
    local groupDefeatedBossNames = PGF.Table_ValuesAsKeys(encounterInfo)
    local numGroupDefeated = PGF.Table_Count(encounterInfo)

    -- there are no IDs for normal and mythic+ dungeons
    if activityInfo.categoryID == C.CATEGORY_ID.DUNGEON and (difficulty == C.NORMAL or difficulty == C.MYTHICPLUS) then
        return numGroupDefeated, 0, 0, 0, 0, 0
    end

    local numSavedInstances = GetNumSavedInstances()
    for index = 1, numSavedInstances do
        local instanceName, instanceID, instanceReset, instanceDifficulty,
            locked, extended, instanceIDMostSig, isRaid, maxPlayers,
            difficultyName, maxBosses, defeatedBosses = GetSavedInstanceInfo(index)
        if C.ACTIVITY[activity].mapID == 608 then maxBosses = 3 end -- Violet Hold has fixed 3 bosses
        if (extended or locked) and PGF.IsMatchingInstance(instanceName, activityInfo.fullName, instanceDifficulty, difficulty) then
            local playerDefeatedBossNames = PGF.GetPlayerDefeatedBossNames(index, maxBosses)
            local numPlayerDefeated = PGF.Table_Count(playerDefeatedBossNames)
            local matching, groupAhead, groupBehind = PGF.GetMatchingBossInfo(groupDefeatedBossNames, playerDefeatedBossNames)
            return numGroupDefeated, numPlayerDefeated, maxBosses, matching, groupAhead, groupBehind
        end
    end
    return numGroupDefeated, 0, 0, 0, 0, 0
end

function PGF.GetMatchingBossInfo(groupDefeatedBossNames, playerDefeatedBossesNames)
    local matching = 0
    local groupAhead = 0
    local groupBehind = 0
    local matchingBossNames = {}

    for name, _ in pairs(groupDefeatedBossNames) do
        if playerDefeatedBossesNames[name] == true then
            matchingBossNames[name] = true
            matching = matching + 1
        end
    end

    for name, _ in pairs(groupDefeatedBossNames) do
        if not matchingBossNames[name] then
            groupAhead = groupAhead + 1
        end
    end

    for name, _ in pairs(playerDefeatedBossesNames) do
        if not matchingBossNames[name] then
            groupBehind = groupBehind + 1
        end
    end

    return matching, groupAhead, groupBehind
end

function PGF.GetPlayerDefeatedBossNames(savedInstanceIndex, maxBosses)
    local result = {}
    for bossIndex = 1, maxBosses do
        local bossName, _, isKilled = GetSavedInstanceEncounterInfo(savedInstanceIndex, bossIndex)
        if isKilled then result[bossName] = true end
    end
    return result
end
