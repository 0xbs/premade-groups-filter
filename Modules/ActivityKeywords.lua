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

C.ACTIVITY_ID_TO_KEYWORDS = {
    -- PvP Arena
    [   6] = { "arena2v2" }, -- Arena 2v2
    [   7] = { "arena3v3" }, -- Arena 3v3
    [ 936] = { "arena2v2" }, -- Arena 2v2 (Wrath)
    [ 937] = { "arena3v3" }, -- Arena 3v3 (Wrath)
    [ 938] = { "arena5v5" }, -- Arena 5v5 (Wrath)
    -- PvP Skirmish
    [  14] = { "arena2v2" }, -- Arena Skirmish (2v2)
    [ 360] = { "arena3v3" }, -- Arena Skirmish (3v3)
    [ 389] = { "arena2v2" }, -- Arena Skirmish (2v2)
    [ 390] = { "arena3v3" }, -- Arena Skirmish (3v3)
    [ 391] = { "arena2v2" }, -- Arena Skirmish (2v2)
    [ 392] = { "arena3v3" }, -- Arena Skirmish (3v3)
    [ 393] = { "arena2v2" }, -- Arena Skirmish (2v2)
    [ 394] = { "arena3v3" }, -- Arena Skirmish (3v3)
    [ 490] = { "arena3v3" }, -- Arena Skirmish (3v3)
    [ 491] = { "arena2v2" }, -- Arena Skirmish (2v2)
    [ 731] = { "arena2v2" }, -- Arena Skirmish (2v2)
    [ 732] = { "arena2v2" }, -- Arena Skirmish (2v2)
    [ 733] = { "arena3v3" }, -- Arena Skirmish (3v3)
    [ 734] = { "arena3v3" }, -- Arena Skirmish (3v3)
    -- Mega Dungeons (have the same mapID, but different keywords)
    [ 471] = { "legion", "kara", "lkara", "lowr", "sls4" }, -- Lower Karazhan (Mythic Keystone)
    [ 473] = { "legion", "kara", "ukara", "uppr", "sls4" }, -- Upper Karazhan (Mythic Keystone)
    [ 679] = { "bfa", "opm", "opmj", "yard", "sls4" }, -- Operation: Mechagon - Junkyard (Mythic Keystone)
    [ 683] = { "bfa", "opm", "opmw", "work", "sls4" }, -- Operation: Mechagon - Workshop (Mythic Keystone)
    [1016] = { "sl", "taz", "tazs", "strt", "sls4" }, -- Tazavesh: Streets of Wonder (Mythic Keystone)
    [1017] = { "sl", "taz", "tazg", "gmbt", "sls4" }, -- Tazavesh: So'leah's Gambit (Mythic Keystone)
    [1247] = { "df", "doti", "fall", "dfs3" }, -- Dawn of the Infinite: Galakrond's Fall (Mythic Keystone)
    [1248] = { "df", "doti", "rise", "dfs3" }, -- Dawn of the Infinite: Murozond's Rise (Mythic Keystone)
    [1250] = { "df", "doti", "fall", "dfs3" }, -- Galakrond's Fall (Mythic Keystone)
}

C.MAP_ID_TO_KEYWORDS = {
    -- Raids
    [ 229] = { "classic", "ubrs" }, -- Upper Blackrock Spire
    [ 249] = { "classic", "wrath", "ony" }, -- Onyxia's Lair
    [ 309] = { "classic", "zg" }, -- Zul'Gurub
    [ 409] = { "classic", "mc" }, -- Molten Core
    [ 469] = { "classic", "bl" }, -- Blackwing Lair
    [ 509] = { "classic", "aq20" }, -- Ahn'Qiraj Ruins
    [ 531] = { "classic", "aq40" }, -- Ahn'Qiraj Temple
    [ 532] = { "tbc", "kara" }, -- Karazhan
    [ 533] = { "classic", "wrath", "naxx" }, -- Naxxramas
    [ 534] = { "tbc", "hyjal" }, -- Hyjal Past
    [ 544] = { "tbc", "mag" }, -- Magtheridon's Lair
    [ 548] = { "tbc", "ssc" }, -- Serpentshrine Cavern
    [ 550] = { "tbc", "tk" }, -- Tempest Keep
    [ 564] = { "tbc", "bt" }, -- Black Temple
    [ 565] = { "tbc", "gruul" }, -- Gruul's Lair
    [ 568] = { "tbc", "za" }, -- Zul'Aman
    [ 580] = { "tbc", "swp" }, -- The Sunwell
    [ 603] = { "wrath", "uld" }, -- Ulduar
    [ 615] = { "wrath", "os" }, -- The Obsidian Sanctum
    [ 616] = { "wrath", "eoe" }, -- The Eye of Eternity
    [ 624] = { "wrath", "voa" }, -- Vault of Archavon
    [ 631] = { "wrath", "icc" }, -- Icecrown Citadel
    [ 649] = { "wrath", "toc" }, -- Trial of the Crusader
    [ 669] = { "cata", "bwd" }, -- Blackwing Descent
    [ 671] = { "cata", "bot" }, -- The Bastion of Twilight
    [ 720] = { "cata", "fl" }, -- Firelands
    [ 724] = { "wrath", "rs" }, -- Ruby Sanctum
    [ 732] = { "cata", "bara" }, -- Baradin Hold
    [ 754] = { "cata", "tfw" }, -- Throne of the Four Winds
    [ 967] = { "cata", "ds" }, -- Dragon Soul
    [ 996] = { "mists", "toes" }, -- Terrace of Endless Spring
    [1008] = { "mists", "msv" }, -- Mogu'shan Vaults
    [1009] = { "mists", "hof" }, -- Heart of Fear
    [1098] = { "mists", "tot" }, -- Throne of Thunder
    [1136] = { "mists", "soo" }, -- Siege of Orgrimmar
    [1205] = { "wod", "brf" }, -- Blackrock Foundry
    [1228] = { "wod", "hm" }, -- Highmaul
    [1448] = { "wod", "hfc" }, -- Hellfire Citadel
    [1520] = { "legion", "en" }, -- The Emerald Nightmare
    [1530] = { "legion", "nh" }, -- The Nighthold
    [1648] = { "legion", "tov" }, -- Trial of Valor
    [1676] = { "legion", "tosg" }, -- Tomb of Sargeras
    [1712] = { "legion", "atbt" }, -- Antorus, the Burning Throne
    [1861] = { "bfa", "uldir" }, -- Uldir
    [2070] = { "bfa", "bod", "daz" }, -- Battle of Dazar'alor
    [2096] = { "bfa", "cs", "cru" }, -- Crucible of Storms
    [2164] = { "bfa", "tep", "ete" }, -- The Eternal Palace
    [2217] = { "bfa", "nya", "ny" }, -- Ny’alotha, the Waking City
    [2296] = { "sl", "cn" }, -- Castle Nathria
    [2450] = { "sl", "sod" }, -- Sanctum of Domination
    [2481] = { "sl", "sfo" }, -- Sepulcher of the First Ones
    [2522] = { "df", "voti" }, -- Vault of the Incarnates
    [2549] = { "df", "atdh", "amir" }, -- Amirdrassil, the Dream's Hope
    [2569] = { "df", "asc" }, -- Aberrus, the Shadowed Crucible
    -- Dungeons
    [ 643] = { "cata", "tott", "dfs3" }, -- Throne of the Tides
    [ 657] = { "cata", "vp", "dfs2" }, -- Vortex Pinnacle
    [ 959] = { "mists", "spm" }, -- Shado-Pan Monastery
    [ 960] = { "mists", "tjs", "dfs1" }, -- Temple of the Jade Serpent
    [ 961] = { "mists", "ssb" }, -- Stormstout Brewery
    [ 962] = { "mists", "gss" }, -- Gate of the Setting Sun
    [ 994] = { "mists", "msp" }, -- Mogu'shan Palace
    [1001] = { "mists", "sch" }, -- Scarlet Halls
    [1004] = { "mists", "scm" }, -- Scarlet Monastery
    [1007] = { "mists", "scholo" }, -- Scholomance
    [1011] = { "mists", "snt" }, -- Siege of Niuzao Temple
    [1176] = { "wod", "sbg", "dfs1" }, -- Shadowmoon Burial Grounds
    [1195] = { "wod", "id", "sls4" }, -- Iron Docks
    [1208] = { "wod", "gd", "sls4" }, -- Grimrail Depot
    [1279] = { "wod", "eb", "dfs3" }, -- The Everbloom
    [1456] = { "legion", "eoa" }, -- Eye of Azshara
    [1458] = { "legion", "nl", "dfs2" }, -- Neltharion's Lair
    [1466] = { "legion", "dht", "dfs3" }, -- Darkheart Thicket
    [1477] = { "legion", "hov", "dfs1" }, -- Halls of Valor
    [1492] = { "legion", "mos" }, -- Maw of Souls
    [1493] = { "legion", "votw" }, -- Vault of the Wardens
    [1501] = { "legion", "brh", "dfs3" }, -- Black Rook Hold
    [1516] = { "legion", "arc" }, -- The Arcway
    [1544] = { "legion", "nl" }, -- Assault on Violet Hold
    [1571] = { "legion", "cos", "dfs1" }, -- Court of Stars
    [1651] = { "legion", "kara" }, -- Return to Karazhan
    [1594] = { "bfa", "tml", "ml" }, -- The MOTHERLODE
    [1754] = { "bfa", "fh", "dfs2" }, -- Freehold
    [1762] = { "bfa", "kr" }, -- Kings' Rest
    [1763] = { "bfa", "ad", "dfs3" }, -- Atal'Dazar
    [1771] = { "bfa", "td" }, -- Tol Dagor
    [1822] = { "bfa", "sob", "siege" }, -- Siege of Boralus
    [1841] = { "bfa", "tur", "undr", "dfs2" }, -- The Underrot
    [1862] = { "bfa", "wm", "dfs3" }, -- Waycrest Manor
    [1864] = { "bfa", "sots" }, -- Shrine of the Storm
    [1877] = { "bfa", "tos", "tosl" }, -- Temple of Sethraliss
    [2097] = { "bfa", "opm" }, -- Operation: Mechagon
    [2284] = { "sl", "sd" }, -- Sanguine Depths
    [2285] = { "sl", "soa" }, -- Spires of Ascension
    [2286] = { "sl", "nw" }, -- The Necrotic Wake
    [2287] = { "sl", "hoa" }, -- Halls of Atonement
    [2289] = { "sl", "pf" }, -- Plaguefall
    [2290] = { "sl", "mots", "mists" }, -- Mists of Tirna Scithe
    [2291] = { "sl", "dos" }, -- De Other Side
    [2293] = { "sl", "top" }, -- Theater of Pain
    [2441] = { "sl", "taz" }, -- Tazavesh, the Veiled Market
    [2451] = { "df", "lot", "uld", "dfs2" }, -- Uldaman: Legacy of Tyr
    [2515] = { "df", "av", "dfs1" }, -- The Azure Vault
    [2516] = { "df", "no", "dfs1" }, -- The Nokhud Offensive
    [2519] = { "df", "nt", "nelt", "dfs2" }, -- Neltharus
    [2520] = { "df", "bh", "dfs2" }, -- Brackenhide Hollow
    [2521] = { "df", "rlp", "dfs1" }, -- Ruby Life Pools
    [2526] = { "df", "aa", "dfs1" }, -- Algeth'ar Academy
    [2527] = { "df", "hoi", "dfs2" }, -- Halls of Infusion
    [2579] = { "df", "doti" }, -- Dawn of the Infinite
}

local function PutActivityKeywordsDefaults(env)
    for activityID, keywords in pairs(C.ACTIVITY_ID_TO_KEYWORDS) do
        for _, keyword in pairs(keywords) do
            env[keyword] = false
        end
    end
    for mapID, keywords in pairs(C.MAP_ID_TO_KEYWORDS) do
        for _, keyword in pairs(keywords) do
            env[keyword] = false
        end
    end
end

function PGF.PutActivityKeywords(env, activityID)
    PutActivityKeywordsDefaults(env)
    -- try to find via activityID first
    local keywords = C.ACTIVITY_ID_TO_KEYWORDS[activityID]
    if keywords then
        for _, keyword in pairs(keywords) do
            env[keyword] = true
        end
        return -- done here
    end
    -- try to find via mapID
    local mapID = C.ACTIVITY[activityID].mapID
    if mapID and mapID > 0 then
        keywords = C.MAP_ID_TO_KEYWORDS[mapID]
        if keywords then
            for _, keyword in pairs(keywords) do
                env[keyword] = true
            end
        end
    end
end
