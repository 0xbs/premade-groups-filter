-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2020 Elotheon-Arthas-EU
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

local function matching(lockoutName, activityName, lockoutDifficulty, activityDifficulty)
    -- no match if difficulty does not match
    if not (LOCKOUT_D[lockoutDifficulty] == activityDifficulty) then return false end

    -- lockoutName is just the dungeon's name, e.g. 'The Emerald Nightmare'
    local lockoutNameLower = lockoutName:lower()
    -- activityName has the difficulty in parens at the end, e.g. 'Emerald Nightmare (Heroic)'
    local activityNameWithoutDifficulty = string.gsub(activityName, "(%w+) %(%w+%)", "%1"):lower()

    -- if one of the names is contained in the other, we have a match
    -- this could break in the future if Blizz adds two instances with the *same difficulty*, where the activity
    -- is eligible for lockouts on this difficulty and the dungeons must be named e.g. 'Karazhan' and 'Upper Karazhan'
    if string.find(activityNameWithoutDifficulty, lockoutNameLower) then return true end
    if string.find(lockoutNameLower, activityNameWithoutDifficulty) then return true end

    return false
end

function PGF.GetLockoutInfo(activity, resultID)
    local avName, avShortName, avCategoryID = C_LFGList.GetActivityInfo(activity)
    local difficulty = PGF.GetDifficulty(activity, avName, avShortName)
    local encounterInfo = C_LFGList.GetSearchResultEncounterInfo(resultID)
    local groupDefeatedBossNames = PGF.Table_ValuesAsKeys(encounterInfo)
    local numGroupDefeated = PGF.Table_Count(encounterInfo)

    -- there are no IDs for normal and mythic+ dungeons
    if avCategoryID == C.TYPE_DUNGEON and (difficulty == C.NORMAL or difficulty == C.MYTHICPLUS) then
        return numGroupDefeated, 0, 0, 0, 0, 0
    end

    local numSavedInstances = GetNumSavedInstances()
    for index = 1, numSavedInstances do
        local instanceName, instanceID, instanceReset, instanceDifficulty,
            locked, extended, instanceIDMostSig, isRaid, maxPlayers,
            difficultyName, maxBosses, defeatedBosses = GetSavedInstanceInfo(index)
        if activity == 449 then maxBosses = 3 end -- Violet Hold has fixed 3 bosses during the weekly lockout
        if (extended or locked) and matching(instanceName, avName, instanceDifficulty, difficulty) then
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
