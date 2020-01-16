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

-- /run for i=650,750 do local name = C_LFGList.GetActivityInfo(i); print(i, name) end
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
}

-- maps localized shortNames from C_LFGList.GetActivityInfo() to difficulties
PGF.SHORTNAME_TO_DIFFICULTY = {
    [select(2, C_LFGList.GetActivityInfo(46))]  = C.NORMAL,      -- 10 Normal
    [select(2, C_LFGList.GetActivityInfo(47))]  = C.HEROIC,      -- 10 Heroic
    [select(2, C_LFGList.GetActivityInfo(48))]  = C.NORMAL,      -- 25 Normal
    [select(2, C_LFGList.GetActivityInfo(49))]  = C.HEROIC,      -- 25 Heroic
    [select(2, C_LFGList.GetActivityInfo(425))] = C.NORMAL,      -- Normal
    [select(2, C_LFGList.GetActivityInfo(435))] = C.HEROIC,      -- Heroic
    [select(2, C_LFGList.GetActivityInfo(445))] = C.MYTHIC,      -- Mythic
    [select(2, C_LFGList.GetActivityInfo(459))] = C.MYTHICPLUS,  -- Mythic+
    [select(2, C_LFGList.GetActivityInfo(6))]   = C.ARENA2V2,    -- Arena 2v2
    [select(2, C_LFGList.GetActivityInfo(7))]   = C.ARENA3V3,    -- Arena 3v3
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

-- maps localized name suffixes (the value in parens) from C_LFGList.GetActivityInfo() to difficulties
PGF.NAMESUFFIX_TO_DIFFICULTY = {
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(46))]  = C.NORMAL,      -- XXX (10 Normal)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(47))]  = C.HEROIC,      -- XXX (10 Heroic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(48))]  = C.NORMAL,      -- XXX (25 Normal)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(49))]  = C.HEROIC,      -- XXX (25 Heroic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(425))] = C.NORMAL,      -- XXX (Normal)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(435))] = C.HEROIC,      -- XXX (Heroic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(445))] = C.MYTHIC,      -- XXX (Mythic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(459))] = C.MYTHICPLUS,  -- XXX (Mythic Keystone)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(6))]   = C.ARENA2V2,    -- Arena 2v2
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(7))]   = C.ARENA3V3,    -- Arena 3v3
    --[PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(476))] = C.MYTHICPLUS, -- XXX (Mythic+)
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
