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
-- see https://wow.tools/dbc/?dbc=mapchallengemode
C.CHALLENGEMODE_MAP_ID_TO_ACTIVITY_ID = {
    [166] = 183,  -- Grimrail Depot                  --    S4
    [169] = 180,  -- Iron Docks                      --    S4
    [227] = 471,  -- Return to Karazhan: Lower       --    S4
    [234] = 473,  -- Return to Karazhan: Lower       --    S4
    [369] = 679,  -- Operation Mechagon - Junkyard   --    S4
    [370] = 683,  -- Operation Mechagon - Workshop   --    S4
    [375] = 703,  -- Mists of Tirna Scithe           -- S3
    [376] = 713,  -- The Necrotic Wake               -- S3
    [377] = 695,  -- De Other Side                   -- S3
    [378] = 699,  -- Halls of Atonement              -- S3
    [379] = 691,  -- Plaguefall                      -- S3
    [380] = 705,  -- Sanguine Depths                 -- S3
    [381] = 709,  -- Spires of Ascension             -- S3
    [382] = 717,  -- Theater of Pain                 -- S3
    [391] = 1016, -- Tazavesh: Streets of Wonder     -- S3 S4
    [392] = 1017, -- Tazavesh: So'leah's Gambit      -- S3 S4

    [2]   = 1192, -- Temple of the Jade Serpent      --       S1
    [165] = 1193, -- Shadowmoon Burial Grounds       --       S1
    [200] = 461,  -- Halls of Valor                  --       S1
    [210] = 466,  -- Court of Stars                  --       S1
    [399] = 1176, -- Ruby Life Pools                 --       S1
    [400] = 1184, -- The Nokhud Offensive            --       S1
    [401] = 1180, -- The Azure Vault                 --       S1
    [402] = 1160, -- Algeth'ar Academy               --       S1

    [403] = 1188, -- Uldaman: Legacy of Tyr          --          S2
    [404] = 1172, -- Neltharus                       --          S2
    [405] = 1164, -- Brackenhide Hollow              --          S2
    [406] = 1168, -- Halls of Infusion               --          S2
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
