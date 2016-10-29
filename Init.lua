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

PremadeGroupsFilter = {}
PremadeGroupsFilterDB = PremadeGroupsFilterDB or {}

local PGF = select(2, ...)
PGF.L = {}
PGF.C = {}

local L = PGF.L
local C = PGF.C

C.NORMAL     = 1
C.HEROIC     = 2
C.MYTHIC     = 3
C.MYTHICPLUS = 4

C.DUNGEON = 1
C.RAID    = 2

C.DIFFICULTY_STRING = {
    [1] = "normal",
    [2] = "heroic",
    [3] = "mythic",
    [4] = "mythicplus",
}

C.COLOR_ENTRY_NEW       = { R = 0.3, G = 1.0, B = 0.3 }
C.COLOR_LOCKOUT_PARTIAL = { R = 1.0, G = 0.5, B = 0.1 }
C.COLOR_LOCKOUT_FULL    = { R = 1.0, G = 0.1, B = 0.1 }

C.FONTSIZE_TEXTBOX = 12
C.SEARCH_ENTRY_RESET_WAIT = 2 -- wait at least 2 seconds between two resets of known premade groups

C.ACTIVITY = {
    -- Warlords of Draenor (raids only)
    [37]  = { difficulty = C.NORMAL, type = C.RAID }, -- Highmaul
    [38]  = { difficulty = C.HEROIC, type = C.RAID }, -- Highmaul
    [399] = { difficulty = C.MYTHIC, type = C.RAID }, -- Highmaul

    [39]  = { difficulty = C.NORMAL, type = C.RAID }, -- Blackrock Foundry
    [40]  = { difficulty = C.HEROIC, type = C.RAID }, -- Blackrock Foundry
    [400] = { difficulty = C.MYTHIC, type = C.RAID }, -- Blackrock Foundry

    [409] = { difficulty = C.NORMAL, type = C.RAID }, -- Hellfire Citadel
    [410] = { difficulty = C.HEROIC, type = C.RAID }, -- Hellfire Citadel
    [412] = { difficulty = C.MYTHIC, type = C.RAID }, -- Hellfire Citadel

    -- Legion
    [413] = { difficulty = C.NORMAL, type = C.RAID }, -- The Emerald Nightmare
    [414] = { difficulty = C.HEROIC, type = C.RAID }, -- The Emerald Nightmare
    [415] = { difficulty = C.NORMAL, type = C.RAID }, -- The Nighthold
    [416] = { difficulty = C.HEROIC, type = C.RAID }, -- The Nighthold

    [417] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Random Dungeon
    [418] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Random Dungeon

    [425] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Eye of Azshara
    [426] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Darkheart Thicket
    [427] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Halls of Valor
    [428] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Neltharion's Lair
    [429] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Violet Hold
    [430] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Black Rook Hold
    [431] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Vault of the Wardens
    [432] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Maw of Souls
    [433] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- Court of Stars
    [434] = { difficulty = C.NORMAL, type = C.DUNGEON }, -- The Arcway

    [435] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Eye of Azshara
    [436] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Darkheart Thicket
    [437] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Halls of Valor
    [438] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Neltharion's Lair
    [439] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Violet Hold
    [440] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Black Rook Hold
    [441] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Vault of the Wardens
    [442] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Maw of Souls
    [443] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- Court of Stars
    [444] = { difficulty = C.HEROIC, type = C.DUNGEON }, -- The Arcway

    [445] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Eye of Azshara
    [446] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Darkheart Thicket
    [447] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Halls of Valor
    [448] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Neltharion's Lair
    [449] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Violet Hold
    [450] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Black Rook Hold
    [451] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Vault of the Wardens
    [452] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Maw of Souls
    [453] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Court of Stars
    [454] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- The Arcway

    [455] = { difficulty = C.MYTHIC, type = C.DUNGEON }, -- Karazhan

    [456] = { difficulty = C.NORMAL, type = C.RAID }, -- Trial of Valor
    [457] = { difficulty = C.HEROIC, type = C.RAID }, -- Trial of Valor

    [458] = { difficulty = C.NORMAL, type = C.RAID }, -- World Bosses Legion

    [459] = { difficulty = C.MYTHICPLUS, type = C.DUNGEON }, -- Eye of Azshara
    [460] = { difficulty = C.MYTHICPLUS, type = C.DUNGEON }, -- Darkheart Thicket
    [461] = { difficulty = C.MYTHICPLUS, type = C.DUNGEON }, -- Halls of Valor
    [462] = { difficulty = C.MYTHICPLUS, type = C.DUNGEON }, -- Neltharion's Lair
    [463] = { difficulty = C.MYTHICPLUS, type = C.DUNGEON }, -- Black Rook Hold
    [464] = { difficulty = C.MYTHICPLUS, type = C.DUNGEON }, -- Vault of the Wardens
    [465] = { difficulty = C.MYTHICPLUS, type = C.DUNGEON }, -- Maw of Souls
    [466] = { difficulty = C.MYTHICPLUS, type = C.DUNGEON }, -- Court of Stars
    [467] = { difficulty = C.MYTHICPLUS, type = C.DUNGEON }, -- The Arcway
}

local frame = CreateFrame("Frame")
local frameOnEvent = function(self, event, ...)
    if event == "ADDON_LOADED" then
        PGF.Dialog_OnLoad(PremadeGroupsFilterDialog)
    end
end
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", frameOnEvent)
