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
PremadeGroupsFilterState = PremadeGroupsFilterState or {}

local PGFAddonName = select(1, ...)
local PGF = select(2, ...)

PremadeGroupsFilter.Debug = PGF

PGF.L = {}
PGF.C = {}

local L = PGF.L
local C = PGF.C

C.SAVED_STATE_VERSION = 14

C.NORMAL     = 1
C.HEROIC     = 2
C.MYTHIC     = 3
C.MYTHICPLUS = 4

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
}

C.COLOR_ENTRY_NEW       = { R = 0.3, G = 1.0, B = 0.3 }
C.COLOR_LOCKOUT_PARTIAL = { R = 1.0, G = 0.5, B = 0.1 }
C.COLOR_LOCKOUT_FULL    = { R = 1.0, G = 0.1, B = 0.1 }

C.FONTSIZE_TEXTBOX = 12
C.SEARCH_ENTRY_RESET_WAIT = 2 -- wait at least 2 seconds between two resets of known premade groups

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
        PGF.Table_UpdateWithDefaults(PremadeGroupsFilterState, PGF.C.MODEL_DEFAULT)
    end
end

function PGF.OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then PGF.OnAddonLoaded(...) end
    if event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" then PGF.LFGListOnSearchResultsReceived(...) end
    if event == "LFG_LIST_SEARCH_FAILED" then PGF.LFGListOnSearchResultsReceived(...) end
end

local frame = CreateFrame("Frame", "PremadeGroupsFilterEventFrame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
frame:RegisterEvent("LFG_LIST_SEARCH_FAILED")
frame:SetScript("OnEvent", PGF.OnEvent)
