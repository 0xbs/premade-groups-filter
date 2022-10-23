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

-- find more IDs: /run for i=750,2000 do local info = C_LFGList.GetActivityInfoTable(i); if info then print(i, info.fullName) end end
PGF.ACTIVITY_TO_DIFFICULTY = {    
    [6] = C.ARENA2V2, -- Arena 2v2
    [7] = C.ARENA3V3, -- Arena 3v3
    
    -- Warlords of Draenor (raids only)
    [37]  = C.NORMAL, -- Highmaul
    [38]  = C.HEROIC, -- Highmaul
    [399] = C.MYTHIC, -- Highmaul

    [39]  = C.NORMAL, -- Blackrock Foundry
    [40]  = C.HEROIC, -- Blackrock Foundry
    [400] = C.MYTHIC, -- Blackrock Foundry

    [409] = C.NORMAL, -- Hellfire Citadel
    [410] = C.HEROIC, -- Hellfire Citadel
    [412] = C.MYTHIC, -- Hellfire Citadel

    [180] = C.MYTHICPLUS, -- Iron Docks
    [183] = C.MYTHICPLUS, -- Grimrail Depot

    -- Legion
    [413] = C.NORMAL, -- The Emerald Nightmare
    [414] = C.HEROIC, -- The Emerald Nightmare
    [415] = C.NORMAL, -- The Nighthold
    [416] = C.HEROIC, -- The Nighthold

    [417] = C.NORMAL, -- Random Dungeon
    [418] = C.HEROIC, -- Random Dungeon

    [425] = C.NORMAL, -- Eye of Azshara
    [426] = C.NORMAL, -- Darkheart Thicket
    [427] = C.NORMAL, -- Halls of Valor
    [428] = C.NORMAL, -- Neltharion's Lair
    [429] = C.NORMAL, -- Violet Hold
    [430] = C.NORMAL, -- Black Rook Hold
    [431] = C.NORMAL, -- Vault of the Wardens
    [432] = C.NORMAL, -- Maw of Souls
    [433] = C.NORMAL, -- Court of Stars
    [434] = C.NORMAL, -- The Arcway

    [435] = C.HEROIC, -- Eye of Azshara
    [436] = C.HEROIC, -- Darkheart Thicket
    [437] = C.HEROIC, -- Halls of Valor
    [438] = C.HEROIC, -- Neltharion's Lair
    [439] = C.HEROIC, -- Violet Hold
    [440] = C.HEROIC, -- Black Rook Hold
    [441] = C.HEROIC, -- Vault of the Wardens
    [442] = C.HEROIC, -- Maw of Souls
    [443] = C.HEROIC, -- Court of Stars
    [444] = C.HEROIC, -- The Arcway

    [445] = C.MYTHIC, -- Eye of Azshara
    [446] = C.MYTHIC, -- Darkheart Thicket
    [447] = C.MYTHIC, -- Halls of Valor
    [448] = C.MYTHIC, -- Neltharion's Lair
    [449] = C.MYTHIC, -- Violet Hold
    [450] = C.MYTHIC, -- Black Rook Hold
    [451] = C.MYTHIC, -- Vault of the Wardens
    [452] = C.MYTHIC, -- Maw of Souls
    [453] = C.MYTHIC, -- Court of Stars
    [454] = C.MYTHIC, -- The Arcway

    [455] = C.MYTHIC, -- Karazhan

    [456] = C.NORMAL, -- Trial of Valor
    [457] = C.HEROIC, -- Trial of Valor

    [458] = C.NORMAL, -- World Bosses Legion

    [459] = C.MYTHICPLUS, -- Eye of Azshara
    [460] = C.MYTHICPLUS, -- Darkheart Thicket
    [461] = C.MYTHICPLUS, -- Halls of Valor
    [462] = C.MYTHICPLUS, -- Neltharion's Lair
    [463] = C.MYTHICPLUS, -- Black Rook Hold
    [464] = C.MYTHICPLUS, -- Vault of the Wardens
    [465] = C.MYTHICPLUS, -- Maw of Souls
    [466] = C.MYTHICPLUS, -- Court of Stars
    [467] = C.MYTHICPLUS, -- The Arcway

    [468] = C.MYTHIC,     -- The Emerald Nightmare

    [470] = C.HEROIC,     -- Lower Karazhan
    [471] = C.MYTHICPLUS, -- Lower Karazhan
    [472] = C.HEROIC,     -- Upper Karazhan
    [473] = C.MYTHICPLUS, -- Upper Karazhan

    [474] = C.HEROIC,     -- Cathedral of Eternal Night
    [475] = C.MYTHIC,     -- Cathedral of Eternal Night
    [476] = C.MYTHICPLUS, -- Cathedral of Eternal Night

    [478] = C.HEROIC,     -- Tomb of Sargeras
    [479] = C.NORMAL,     -- Tomb of Sargeras

    [480] = C.MYTHIC,     -- Trial of Valor
    [481] = C.MYTHIC,     -- The Nighthold

    [482] = C.NORMAL,     -- Antorus, the Burning Throne
    [483] = C.HEROIC,     -- Antorus, the Burning Throne

    [484] = C.HEROIC,     -- Seat of the Triumvirate
    [485] = C.MYTHIC,     -- Seat of the Triumvirate
    [486] = C.MYTHICPLUS, -- Seat of the Triumvirate

    [492] = C.MYTHICPLUS, -- Tomb of Sargeras
    [493] = C.MYTHIC,     -- Antorus, the Burning Throne

    [494] = C.NORMAL,     -- Uldir
    [495] = C.HEROIC,     -- Uldir
    [496] = C.MYTHIC,     -- Uldir

    [497] = C.NORMAL,     -- Random Normal Dungeon BfA
    [498] = C.HEROIC,     -- Random Heroic Dungeon BfA

    [499] = C.MYTHIC,     -- Atal'Dazar
    [500] = C.HEROIC,     -- Atal'Dazar
    [501] = C.NORMAL,     -- Atal'Dazar
    [502] = C.MYTHICPLUS, -- Atal'Dazar

    [503] = C.NORMAL,     -- Temple of Sethraliss
    [504] = C.MYTHICPLUS, -- Temple of Sethraliss
    [505] = C.HEROIC,     -- Temple of Sethraliss

    [506] = C.NORMAL,     -- The Underrot
    [507] = C.MYTHICPLUS, -- The Underrot
    [508] = C.HEROIC,     -- The Underrot

    [509] = C.NORMAL,     -- The MOTHERLODE
    [510] = C.MYTHICPLUS, -- The MOTHERLODE
    [511] = C.HEROIC,     -- The MOTHERLODE

    [512] = C.NORMAL,     -- Kings' Rest
    [513] = C.MYTHIC,     -- Kings' Rest
    [514] = C.MYTHICPLUS, -- Kings' Rest
    [515] = C.HEROIC,     -- Kings' Rest

    [516] = C.NORMAL,     -- Freehold
    [517] = C.MYTHIC,     -- Freehold
    [518] = C.MYTHICPLUS, -- Freehold
    [519] = C.HEROIC,     -- Freehold

    [520] = C.NORMAL,     -- Shrine of the Storm
    [521] = C.MYTHIC,     -- Shrine of the Storm
    [522] = C.MYTHICPLUS, -- Shrine of the Storm
    [523] = C.HEROIC,     -- Shrine of the Storm

    [524] = C.NORMAL,     -- Tol Dagor
    [525] = C.MYTHIC,     -- Tol Dagor
    [526] = C.MYTHICPLUS, -- Tol Dagor
    [527] = C.HEROIC,     -- Tol Dagor

    [528] = C.NORMAL,     -- Waycrest Manor
    [529] = C.MYTHIC,     -- Waycrest Manor
    [530] = C.MYTHICPLUS, -- Waycrest Manor
    [531] = C.HEROIC,     -- Waycrest Manor

    [532] = C.NORMAL,     -- Siege of Boralus
    [533] = C.MYTHIC,     -- Siege of Boralus
    [534] = C.MYTHICPLUS, -- Siege of Boralus
    [535] = C.HEROIC,     -- Siege of Boralus

    [536] = C.NORMAL,     -- Waycrest Manor
    [537] = C.NORMAL,     -- Tol Dagor
    [538] = C.NORMAL,     -- Shrine of the Storm
    [539] = C.NORMAL,     -- Freehold
    [540] = C.NORMAL,     -- The MOTHERLODE
    [541] = C.NORMAL,     -- The Underrot
    [542] = C.NORMAL,     -- Temple of Sethraliss
    [543] = C.NORMAL,     -- Atal'Dazar

    [644] = C.MYTHIC,     -- The Underrot
    [645] = C.MYTHIC,     -- Temple of Sethraliss
    [646] = C.MYTHIC,     -- The MOTHERLODE

    [653] = C.NORMAL,     -- Random Island
    [654] = C.HEROIC,     -- Random Island
    [655] = C.MYTHIC,     -- Random Island

    [658] = C.MYTHIC,     -- Siege of Boralus
    [659] = C.MYTHICPLUS, -- Siege of Boralus
    [660] = C.MYTHIC,     -- Kings Rest
    [661] = C.MYTHICPLUS, -- Kings Rest

    [663] = C.NORMAL,     -- Battle of Dazar'alor
    [664] = C.HEROIC,     -- Battle of Dazar'alor
    [665] = C.MYTHIC,     -- Battle of Dazar'alor

    [666] = C.MYTHIC,     -- Crucible of Storms
    [667] = C.HEROIC,     -- Crucible of Storms
    [668] = C.NORMAL,     -- Crucible of Storms
    
    [669] = C.MYTHIC,     -- Operation: Mechagon

    [670] = C.MYTHIC,     -- The Eternal Palace
    [671] = C.HEROIC,     -- The Eternal Palace
    [672] = C.NORMAL,     -- The Eternal Palace

    [679] = C.MYTHICPLUS, -- Operation: Mechagon - Junkyard
    [682] = C.HEROIC,     -- Operation: Mechagon - Junkyard
    [683] = C.MYTHICPLUS, -- Operation: Mechagon - Workshop
    [684] = C.HEROIC,     -- Operation: Mechagon - Workshop

    [685] = C.MYTHIC,     -- Ny’alotha, the Waking City
    [686] = C.HEROIC,     -- Ny’alotha, the Waking City
    [687] = C.NORMAL,     -- Ny’alotha, the Waking City

    [688] = C.NORMAL,     -- Plaguefall
    [689] = C.HEROIC,     -- Plaguefall
    [690] = C.MYTHIC,     -- Plaguefall
    [691] = C.MYTHICPLUS, -- Plaguefall

    [692] = C.NORMAL,     -- De Other Side
    [693] = C.HEROIC,     -- De Other Side
    [694] = C.MYTHIC,     -- De Other Side
    [695] = C.MYTHICPLUS, -- De Other Side

    [696] = C.NORMAL,     -- Halls of Atonement
    [697] = C.HEROIC,     -- Halls of Atonement
    [698] = C.MYTHIC,     -- Halls of Atonement
    [699] = C.MYTHICPLUS, -- Halls of Atonement

    [700] = C.NORMAL,     -- Mists of Tirna Scithe
    [701] = C.HEROIC,     -- Mists of Tirna Scithe
    [702] = C.MYTHIC,     -- Mists of Tirna Scithe
    [703] = C.MYTHICPLUS, -- Mists of Tirna Scithe

    [704] = C.NORMAL,     -- Sanguine Depths
    [707] = C.HEROIC,     -- Sanguine Depths
    [706] = C.MYTHIC,     -- Sanguine Depths
    [705] = C.MYTHICPLUS, -- Sanguine Depths

    [708] = C.NORMAL,     -- Spires of Ascension
    [711] = C.HEROIC,     -- Spires of Ascension
    [710] = C.MYTHIC,     -- Spires of Ascension
    [709] = C.MYTHICPLUS, -- Spires of Ascension

    [712] = C.NORMAL,     -- The Necrotic Wake
    [715] = C.HEROIC,     -- The Necrotic Wake
    [714] = C.MYTHIC,     -- The Necrotic Wake
    [713] = C.MYTHICPLUS, -- The Necrotic Wake

    [716] = C.NORMAL,     -- Theater of Pain
    [719] = C.HEROIC,     -- Theater of Pain
    [718] = C.MYTHIC,     -- Theater of Pain
    [717] = C.MYTHICPLUS, -- Theater of Pain

    [720] = C.NORMAL,     -- Castle Nathria
    [722] = C.HEROIC,     -- Castle Nathria
    [721] = C.MYTHIC,     -- Castle Nathria

    [743] = C.NORMAL,     -- Sanctum of Domination
    [744] = C.HEROIC,     -- Sanctum of Domination
    [745] = C.MYTHIC,     -- Sanctum of Domination

    [746] = C.MYTHIC,     -- Tazavesh, the Veiled Market

    [1016] = C.MYTHICPLUS, -- Tazavesh: Streets of Wonder
    [1017] = C.MYTHICPLUS, -- Tazavesh: So'leah's Gambit
    [1018] = C.HEROIC,     -- Tazavesh: Streets of Wonder
    [1019] = C.HEROIC,     -- Tazavesh: So'leah's Gambit

    [1020] = C.NORMAL,     -- Sepulcher of the First Ones
    [1021] = C.HEROIC,     -- Sepulcher of the First Ones
    [1022] = C.MYTHIC,     -- Sepulcher of the First Ones

    [1157] = C.NORMAL,     -- Algeth'ar Academy
    [1158] = C.HEROIC,     -- Algeth'ar Academy
    [1159] = C.MYTHIC,     -- Algeth'ar Academy
    [1160] = C.MYTHICPLUS, -- Algeth'ar Academy

    [1161] = C.NORMAL,     -- Brackenhide Hollow
    [1162] = C.HEROIC,     -- Brackenhide Hollow
    [1163] = C.MYTHIC,     -- Brackenhide Hollow
    [1164] = C.MYTHICPLUS, -- Brackenhide Hollow

    [1165] = C.NORMAL,     -- Halls of Infusion
    [1166] = C.HEROIC,     -- Halls of Infusion
    [1167] = C.MYTHIC,     -- Halls of Infusion
    [1168] = C.MYTHICPLUS, -- Halls of Infusion

    [1169] = C.NORMAL,     -- Neltharus
    [1170] = C.HEROIC,     -- Neltharus
    [1171] = C.MYTHIC,     -- Neltharus
    [1172] = C.MYTHICPLUS, -- Neltharus

    [1173] = C.NORMAL,     -- Ruby Life Pools
    [1174] = C.HEROIC,     -- Ruby Life Pools
    [1175] = C.MYTHIC,     -- Ruby Life Pools
    [1176] = C.MYTHICPLUS, -- Ruby Life Pools

    [1177] = C.NORMAL,     -- The Azure Vault
    [1178] = C.HEROIC,     -- The Azure Vault
    [1179] = C.MYTHIC,     -- The Azure Vault
    [1180] = C.MYTHICPLUS, -- The Azure Vault

    [1181] = C.NORMAL,     -- The Nokhud Offensive
    [1182] = C.HEROIC,     -- The Nokhud Offensive
    [1183] = C.MYTHIC,     -- The Nokhud Offensive
    [1184] = C.MYTHICPLUS, -- The Nokhud Offensive

    [1185] = C.NORMAL,     -- Uldaman: Legacy of Tyr
    [1186] = C.HEROIC,     -- Uldaman: Legacy of Tyr
    [1187] = C.MYTHIC,     -- Uldaman: Legacy of Tyr
    [1188] = C.MYTHICPLUS, -- Uldaman: Legacy of Tyr

    [1189] = C.NORMAL,     -- Vault of the Incarnates
    [1190] = C.HEROIC,     -- Vault of the Incarnates
    [1191] = C.MYTHIC,     -- Vault of the Incarnates
}

-- maps localized shortNames from C_LFGList.GetActivityInfoTable().shortName to difficulties
PGF.SHORTNAME_TO_DIFFICULTY = {
    [C_LFGList.GetActivityInfoTable(46).shortName]  = C.NORMAL,      -- 10 Normal
    [C_LFGList.GetActivityInfoTable(47).shortName]  = C.HEROIC,      -- 10 Heroic
    [C_LFGList.GetActivityInfoTable(48).shortName]  = C.NORMAL,      -- 25 Normal
    [C_LFGList.GetActivityInfoTable(49).shortName]  = C.HEROIC,      -- 25 Heroic
    [C_LFGList.GetActivityInfoTable(425).shortName] = C.NORMAL,      -- Normal
    [C_LFGList.GetActivityInfoTable(435).shortName] = C.HEROIC,      -- Heroic
    [C_LFGList.GetActivityInfoTable(445).shortName] = C.MYTHIC,      -- Mythic
    [C_LFGList.GetActivityInfoTable(459).shortName] = C.MYTHICPLUS,  -- Mythic+
    [C_LFGList.GetActivityInfoTable(6).shortName]   = C.ARENA2V2,    -- Arena 2v2
    [C_LFGList.GetActivityInfoTable(7).shortName]   = C.ARENA3V3,    -- Arena 3v3
}

function PGF.ExtractNameSuffix(name)
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        -- Chinese clients use different parenthesis
        return name:lower():match("[(（]([^)）]+)[)）]")
    else
        -- however we cannot use the regex above for every language
        -- because the Chinese parenthesis somehow breaks the recognition
        -- of other Western special characters such as Umlauts
        return name:lower():match("%(([^)]+)%)")
    end
end

-- maps localized name suffixes (the value in parens) from C_LFGList.GetActivityInfoTable().fullName to difficulties
PGF.NAMESUFFIX_TO_DIFFICULTY = {
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(46).fullName)]  = C.NORMAL,      -- XXX (10 Normal)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(47).fullName)]  = C.HEROIC,      -- XXX (10 Heroic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(48).fullName)]  = C.NORMAL,      -- XXX (25 Normal)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(49).fullName)]  = C.HEROIC,      -- XXX (25 Heroic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(425).fullName)] = C.NORMAL,      -- XXX (Normal)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(435).fullName)] = C.HEROIC,      -- XXX (Heroic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(445).fullName)] = C.MYTHIC,      -- XXX (Mythic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(459).fullName)] = C.MYTHICPLUS,  -- XXX (Mythic Keystone)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(6).fullName)]   = C.ARENA2V2,    -- Arena 2v2
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(7).fullName)]   = C.ARENA3V3,    -- Arena 3v3
    --[PGF.ExtractNameSuffix(C_LFGList.GetActivityInfoTable(476).fullName)] = C.MYTHICPLUS, -- XXX (Mythic+)
}

function PGF.GetDifficulty(activity, name, shortName)
    local difficulty

    -- try to extract from shortName
    difficulty = PGF.SHORTNAME_TO_DIFFICULTY[shortName]
    if PGF.NotEmpty(difficulty) then
        --print("difficulty from shortName:", difficulty)
        return difficulty
    end

    -- try to extract from name
    difficulty = PGF.NAMESUFFIX_TO_DIFFICULTY[PGF.ExtractNameSuffix(name)]
    if PGF.NotEmpty(difficulty) then
        --print("difficulty from name:", difficulty)
        return difficulty
    end

    -- try to find it in our hardcoded table
    difficulty = PGF.ACTIVITY_TO_DIFFICULTY[activity]
    if PGF.NotEmpty(difficulty) then
        --print("difficulty from activity:", difficulty)
        return difficulty
    end

    --print("difficulty not found, assuming normal")
    return C.NORMAL
end
