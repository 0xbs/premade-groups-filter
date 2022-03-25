-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2022 Elotheon-Arthas-EU
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

-- Warning: C_ChallengeMode.GetMapUIInfo(mapID) and activityInfo.fullName are using different names.
-- activityInfo has the difficulty in parens at the end, but also the names itself can be slightly different:
--   "Die Blutigen Tiefen" vs. "Blutige Tiefen (Mythischer Schlüsselstein)"
--   "Tazavesh: Wundersame Straßen" vs. "Tazavesh: Straßen (Mythischer Schlüsselstein)"
-- Only Mythic Plus activityIDs are relevant here.
-- /run for _,mapID in pairs(C_ChallengeMode.GetMapTable()) do local name = C_ChallengeMode.GetMapUIInfo(mapID); print(mapID..","..name) end
C.CHALLENGEMODE_MAP_ID_TO_ACTIVITY_ID = {
    [375] = 703,  -- Mists of Tirna Scithe
    [376] = 713,  -- The Necrotic Wake
    [377] = 695,  -- De Other Side
    [378] = 699,  -- Halls of Atonement
    [379] = 691,  -- Plaguefall
    [380] = 705,  -- Sanguine Depths
    [381] = 709,  -- Spires of Ascension
    [382] = 717,  -- Theater of Pain
    [391] = 1016, -- Tazavesh: Streets of Wonder
    [392] = 1017, -- Tazavesh: So'leah's Gambit
}

function PGF.GetThisWeeksAffixNameLocalized()
    local affixIDs = C_MythicPlus.GetCurrentAffixes()
    if not affixIDs then return nil end -- result might not have been loaded yet
    local tyrannicalOrFortifiedAffix = affixIDs[1]
    if not tyrannicalOrFortifiedAffix or not tyrannicalOrFortifiedAffix.id then return nil end
    local name, description, filedataid = C_ChallengeMode.GetAffixInfo(tyrannicalOrFortifiedAffix.id)
    return name
end

function PGF.GetPlayerInfo()
    local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvp = GetAverageItemLevel()

    local result = {}
    result.avgItemLevel = avgItemLevel
    result.avgItemLevelEquipped = avgItemLevelEquipped
    result.avgItemLevelPvp = avgItemLevelPvp
    result.affixRating = {}
    result.avgAffixRating = 0
    result.medianAffixRating = 0
    result.dungeonRating = {}
    result.avgDungeonRating = 0
    result.medianDungeonRating = 0

    local thisWeeksAffixNameLocalized = PGF.GetThisWeeksAffixNameLocalized()
    local mapIDs = C_ChallengeMode.GetMapTable() -- Shadowlands: 375-382,391,392
    if not mapIDs then return result end -- result might not have been loaded yet

    for _, mapID in pairs(mapIDs) do
        local activityID = C.CHALLENGEMODE_MAP_ID_TO_ACTIVITY_ID[mapID]
        local affixScores, bestOverAllScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(mapID)
        result.dungeonRating[activityID] = bestOverAllScore or 0 -- can be nil

        local affixScore = 0
        if affixScores then -- can be nil
            for _, affixInfo in pairs(affixScores) do -- contains 1 or 2 entries
                if affixInfo and affixInfo.name == thisWeeksAffixNameLocalized then
                    affixScore = affixInfo.score or 0
                end
            end
        end
        result.affixRating[activityID] = affixScore
    end

    result.avgAffixRating = PGF.Table_Mean(result.affixRating)
    result.medianAffixRating = PGF.Table_Median(result.affixRating)
    result.avgDungeonRating = PGF.Table_Mean(result.dungeonRating)
    result.medianDungeonRating = PGF.Table_Median(result.dungeonRating)
    return result
end
