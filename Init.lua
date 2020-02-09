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

PremadeGroupsFilter = {}
PremadeGroupsFilterState = PremadeGroupsFilterState or {}

local PGFAddonName = select(1, ...)
local PGF = select(2, ...)

PremadeGroupsFilter.Debug = PGF

PGF.L = {}
PGF.C = {}

local L = PGF.L
local C = PGF.C

C.NORMAL     = 1
C.HEROIC     = 2
C.MYTHIC     = 3
C.MYTHICPLUS = 4
C.ARENA2V2   = 5
C.ARENA3V3   = 6

-- corresponds to the third parameter of C_LFGList.GetActivityInfo()
C.TYPE_QUESTING = 1
C.TYPE_DUNGEON  = 2
C.TYPE_RAID     = 3
C.TYPE_ARENA    = 4
C.TYPE_SCENARIO = 5
C.TYPE_CUSTOM   = 6
C.TYPE_SKIRMISH = 7
C.TYPE_BG       = 8
C.TYPE_RBG      = 9
C.TYPE_ASHRAN   = 10

C.DIFFICULTY_STRING = {
    [1] = "normal",
    [2] = "heroic",
    [3] = "mythic",
    [4] = "mythicplus",
    [5] = "arena2v2",
    [6] = "arena3v3",
}

C.COLOR_ENTRY_NEW       = { R = 0.3, G = 1.0, B = 0.3 } -- green
C.COLOR_ENTRY_DECLINED  = { R = 0.5, G = 0.1, B = 0.1 } -- dark red
C.COLOR_LOCKOUT_PARTIAL = { R = 1.0, G = 0.5, B = 0.1 } -- orange
C.COLOR_LOCKOUT_FULL    = { R = 0.5, G = 0.1, B = 0.1 } -- red
C.COLOR_LOCKOUT_MATCH   = { R = 1.0, G = 1.0, B = 1.0 } -- white

C.FONTSIZE_TEXTBOX = 12
C.SEARCH_ENTRY_RESET_WAIT = 2 -- wait at least 2 seconds between two resets of known premade groups
C.DECLINED_GROUPS_RESET = 60 * 30 -- reset declined groups after 30 minutes

C.ROLE_PREFIX = {
    ["DAMAGER"] = "dps",
    ["HEALER"] = "heal",
    ["TANK"] = "tank",
}

C.ROLE_SUFFIX = {
    ["DAMAGER"] = "dps",
    ["HEALER"] = "heals",
    ["TANK"] = "tanks",
}

C.DPS_CLASS_TYPE = {
    ["DEATHKNIGHT"] = { range = false, melee = true },
    ["DEMONHUNTER"] = { range = false, melee = true },
    ["DRUID"]       = { range = true,  melee = true },
    ["HUNTER"]      = { range = true,  melee = true },
    ["PALADIN"]     = { range = false, melee = true },
    ["PRIEST"]      = { range = true,  melee = false },
    ["MAGE"]        = { range = true,  melee = false },
    ["MONK"]        = { range = false, melee = true },
    ["ROGUE"]       = { range = false, melee = true },
    ["SHAMAN"]      = { range = true,  melee = true },
    ["WARLOCK"]     = { range = true,  melee = false },
    ["WARRIOR"]     = { range = false, melee = true },
}

C.MODEL_DEFAULT = {
    enabled = true,
    expression = "",
    difficulty = {
        act = false,
        val = 3,
    },
    ilvl = {
        act = false,
        min = "",
        max = "",
    },
    noilvl = {
        act = false
    },
    members = {
        act = false,
        min = "",
        max = "",
    },
    tanks = {
        act = false,
        min = "",
        max = "",
    },
    heals = {
        act = false,
        min = "",
        max = "",
    },
    dps = {
        act = false,
        min = "",
        max = "",
    },
    defeated = {
        act = false,
        min = "",
        max = "",
    },
}

function PGF.OnAddonLoaded(name)
    if name == PGFAddonName then
        -- check if migration from 1.10 to 1.11 is necessary
        if PremadeGroupsFilterState.enabled ~= nil then
            local stateV110 = PremadeGroupsFilterState
            PremadeGroupsFilterState = {}
            PremadeGroupsFilterState.v110 = stateV110
        end
        -- update all state tables with the current set of defaults
        for _, v in pairs(PremadeGroupsFilterState) do
            PGF.Table_UpdateWithDefaults(v, PGF.C.MODEL_DEFAULT)
        end
    end
end

function PGF.OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then PGF.OnAddonLoaded(...) end
    if event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then PGF.OnLFGListApplicationStatusUpdated(...) end
end

local frame = CreateFrame("Frame", "PremadeGroupsFilterEventFrame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
frame:SetScript("OnEvent", PGF.OnEvent)
