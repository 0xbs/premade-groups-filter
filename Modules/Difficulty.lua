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

-- /run for i=400,500 do local name = C_LFGList.GetActivityInfo(i); print(i, name) end
PGF.ACTIVITY_TO_DIFFICULTY = {
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
}

-- maps localized shortNames from C_LFGList.GetActivityInfo() to difficulties
PGF.SHORTNAME_TO_DIFFICULTY = {
    [select(2, C_LFGList.GetActivityInfo(46))] = C.NORMAL,      -- 10 Normal
    [select(2, C_LFGList.GetActivityInfo(47))] = C.HEROIC,      -- 10 Heroic
    [select(2, C_LFGList.GetActivityInfo(48))] = C.NORMAL,      -- 25 Normal
    [select(2, C_LFGList.GetActivityInfo(49))] = C.HEROIC,      -- 25 Heroic
    [select(2, C_LFGList.GetActivityInfo(425))] = C.NORMAL,     -- Normal
    [select(2, C_LFGList.GetActivityInfo(435))] = C.HEROIC,     -- Heroic
    [select(2, C_LFGList.GetActivityInfo(445))] = C.MYTHIC,     -- Mythic
    [select(2, C_LFGList.GetActivityInfo(459))] = C.MYTHICPLUS, -- Mythic+
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
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(46))] = C.NORMAL,      -- XXX (10 Normal)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(47))] = C.HEROIC,      -- XXX (10 Heroic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(48))] = C.NORMAL,      -- XXX (25 Normal)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(49))] = C.HEROIC,      -- XXX (25 Heroic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(425))] = C.NORMAL,     -- XXX (Normal)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(435))] = C.HEROIC,     -- XXX (Heroic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(445))] = C.MYTHIC,     -- XXX (Mythic)
    [PGF.ExtractNameSuffix(C_LFGList.GetActivityInfo(459))] = C.MYTHICPLUS, -- XXX (Mythic Keystone)
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
