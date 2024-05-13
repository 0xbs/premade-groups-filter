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

PremadeGroupsFilter = {}
PremadeGroupsFilterSettings = PremadeGroupsFilterSettings or {}

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
C.ARENA5V5   = 7

-- corresponds to the third parameter of C_LFGList.GetActivityInfoTable().categoryID
C.CATEGORY_ID = {
    QUESTING           = 1,
    DUNGEON            = 2,
    RAID               = 3,
    ARENA              = 4,
    SCENARIO           = 5,
    CUSTOM             = 6, -- both PvE and PvP
    SKIRMISH           = 7,
    BATTLEGROUND       = 8,
    RATED_BATTLEGROUND = 9,
    ASHRAN             = 10,
    ISLAND             = 111,
    THORGAST           = 113,
    WRATH_RAID         = 114,
    WRATH_QUESTING     = 116,
    WRATH_BATTLEGROUND = 118,
    WRATH_CUSTOM       = 120,
}

C.DIFFICULTY_KEYWORD = {
    [C.NORMAL] = "normal",
    [C.HEROIC] = "heroic",
    [C.MYTHIC] = "mythic",
    [C.MYTHICPLUS] = "mythicplus",
    [C.ARENA2V2] = "arena2v2",
    [C.ARENA3V3] = "arena3v3",
    [C.ARENA5V5] = "arena5v5",
}

-- Translates tier enum values into normalized values - check via /dump PVPUtil.GetTierName(1)
C.PVP_TIER_MAP = {
    [0] = { tier = 0, minRating =    0, quality = 0, }, -- Unranked
    [1] = { tier = 1, minRating = 1000, quality = 1, }, -- Combatant I
    [2] = { tier = 3, minRating = 1400, quality = 2, }, -- Challenger I
    [3] = { tier = 5, minRating = 1800, quality = 3, }, -- Rival I
    [4] = { tier = 7, minRating = 2100, quality = 4, }, -- Duelist
    [5] = { tier = 8, minRating = 2400, quality = 5, }, -- Elite
    [6] = { tier = 2, minRating = 1200, quality = 1, }, -- Combatant II
    [7] = { tier = 4, minRating = 1600, quality = 2, }, -- Challenger II
    [8] = { tier = 6, minRating = 1950, quality = 3, }, -- Rival II
}

C.COLOR_ENTRY_NEW           = { R = 0.3, G = 1.0, B = 0.3 } -- green
C.COLOR_ENTRY_DECLINED_SOFT = { R = 0.6, G = 0.3, B = 0.1 } -- dark orange
C.COLOR_ENTRY_DECLINED_HARD = { R = 0.6, G = 0.1, B = 0.1 } -- dark red
C.COLOR_LOCKOUT_PARTIAL     = { R = 1.0, G = 0.5, B = 0.1 } -- orange
C.COLOR_LOCKOUT_FULL        = { R = 0.5, G = 0.1, B = 0.1 } -- red
C.COLOR_LOCKOUT_MATCH       = { R = 1.0, G = 1.0, B = 1.0 } -- white

C.FONTSIZE_TEXTBOX = 12
C.SEARCH_ENTRY_RESET_WAIT = 2 -- wait at least 2 seconds between two resets of known premade groups
C.DECLINED_GROUPS_RESET = 60 * 15 -- reset declined groups after 15 minutes

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

C.ROLE_ATLAS = {
    ["TANK"] = "roleicon-tiny-tank",
    ["HEALER"] = "roleicon-tiny-healer",
    ["DAMAGER"] = "roleicon-tiny-dps",
}

C.LEADER_ATLAS = "groupfinder-icon-leader"

C.DPS_CLASS_TYPE = {
    ["DEATHKNIGHT"] = { range = false, melee = true,  armor = "plate",   br = true,  bl = false },
    ["DEMONHUNTER"] = { range = false, melee = true,  armor = "leather", br = false, bl = false },
    ["DRUID"]       = { range = true,  melee = true,  armor = "leather", br = true,  bl = false },
    ["EVOKER"]      = { range = true,  melee = false, armor = "mail",    br = false, bl = true  },
    ["HUNTER"]      = { range = true,  melee = true,  armor = "mail",    br = false, bl = true  },
    ["PALADIN"]     = { range = false, melee = true,  armor = "plate",   br = true,  bl = false },
    ["PRIEST"]      = { range = true,  melee = false, armor = "cloth",   br = false, bl = false },
    ["MAGE"]        = { range = true,  melee = false, armor = "cloth",   br = false, bl = true  },
    ["MONK"]        = { range = false, melee = true,  armor = "leather", br = false, bl = false },
    ["ROGUE"]       = { range = false, melee = true,  armor = "leather", br = false, bl = false },
    ["SHAMAN"]      = { range = true,  melee = true,  armor = "mail",    br = false, bl = true  },
    ["WARLOCK"]     = { range = true,  melee = false, armor = "cloth",   br = true,  bl = false },
    ["WARRIOR"]     = { range = false, melee = true,  armor = "plate",   br = false, bl = false },
}
setmetatable(C.DPS_CLASS_TYPE, { __index = function()
    return { range = false, melee = false, armor = "unknown", br = false, bl = false }
end })


local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local flavor = GetAddOnMetadata(PGFAddonName, "X-Flavor")
function PGF.IsRetail() return flavor == "Retail" end
function PGF.IsWrath() return flavor == "Wrath" end
function PGF.IsCata() return flavor == "Cata" end
function PGF.SupportsMythicPlus() return PGF.IsRetail() end -- Mythic Plus (as opposed to Challenge Mode with gear scaling) is supported from Legion onwards
function PGF.SupportsSpecializations() return PGF.IsRetail() end -- Specialization (as opposed to free talent trees) are supported from Mists of Pandaria onwards
function PGF.SupportsDragonflightUI() return PGF.IsRetail() end -- User Interface has changed drastically in Dragonflight

C.SETTINGS_DEFAULT = {
    version = 1,
    dialogMovable = true,
    classNamesInTooltip = true,
    coloredGroupTexts = true,
    coloredApplications = true,
    ratingInfo = true,
    classCircle = false,
    classBar = false,
    leaderCrown = false,
    oneClickSignUp = true,
    persistSignUpNote = true,
    signupOnEnter = false,
    skipSignUpDialog = false,
}

function PGF.MigrateStateV4()
    if PremadeGroupsFilterState.version < 4 then
        for k, v in pairs(PremadeGroupsFilterState) do
            if type(v) == "table" then
                v.expert = PremadeGroupsFilterState.expert
            end
        end
        PremadeGroupsFilterState.expert = nil
        PremadeGroupsFilterState.version = 4
        print(string.format(L["message.settingsupgraded"], "4"))
    end
end

function PGF.MigrateStateV5()
    if PremadeGroupsFilterState.version < 5 then
        local mapping = {
            ["t1c1f0"] = { key = "c1f4", enabled = false, panel = "expression" }, -- quests
            ["t1c2f0"] = { key = "c2f4", enabled = true,  panel = "dungeon"    }, -- dungeons
            ["t1c3f1"] = { key = "c3f5", enabled = true,  panel = "raid"       }, -- raids new
            ["t1c3f2"] = { key = "c3f6", enabled = true,  panel = "raid"       }, -- raids old
            ["t1c6f0"] = { key = "c6f4", enabled = false, panel = "expression" }, -- custom pve
            ["t2c4f0"] = { key = "c4f8", enabled = true,  panel = "arena"      }, -- arena
            ["t2c6f0"] = { key = "c6f8", enabled = false, panel = "expression" }, -- custom pvp
            ["t2c7f0"] = { key = "c7f8", enabled = false, panel = "expression" }, -- skirmish
            ["t2c8f0"] = { key = "c8f8", enabled = false, panel = "expression" }, -- bg
            ["t2c9f0"] = { key = "c9f8", enabled = true,  panel = "rbg"        }, -- rbg
        }
        local state5 = {
            version = 5
        }
        for k, v in pairs(PremadeGroupsFilterState) do
            if type(v) == "table" and mapping[k] then
                state5[mapping[k].key] = {
                    enabled = mapping[k].enabled and v.enabled,
                    minimized = v.expert,
                    expression = {
                        expression = v.expression,
                        sorting = v.sorting,
                    },
                    [mapping[k].panel] = {
                        expression = v.expression,
                        sorting = v.sorting,
                    },
                }
            end
        end
        PremadeGroupsFilterState = state5
        print(string.format(L["message.settingsupgraded"], "5"))
    end
end

function PGF.MigrateStateV6()
    if PremadeGroupsFilterState.version < 6 then
        for k, v in pairs(PremadeGroupsFilterState) do
            -- expression panel is now called mini
            if type(v) == "table" and v.expression then
                v.mini = v.expression
                v.expression = nil
            end
        end
        PremadeGroupsFilterState.version = 6
        print(string.format(L["message.settingsupgraded"], "6"))
    end
end

function PGF.MigrateSettingsV2()
    if not PremadeGroupsFilterSettings.version or PremadeGroupsFilterSettings.version < 2 then
        if PGF.IsRetail() then -- disable features now provided by default
            PremadeGroupsFilterSettings.classCircle = false
            PremadeGroupsFilterSettings.classBar = false
            PremadeGroupsFilterSettings.leaderCrown = false -- does not work well because of different icon order
        end
        PremadeGroupsFilterSettings.version = 2
    end
end

function PGF.OnAddonLoaded(name)
    if name == PGFAddonName then
        -- update new settings with defaults
        PGF.Table_UpdateWithDefaults(PremadeGroupsFilterSettings, PGF.C.SETTINGS_DEFAULT)
        PGF.MigrateSettingsV2()

        -- initialize dialog state and migrate to latest version
        if PremadeGroupsFilterState == nil or PremadeGroupsFilterState.version == nil then
            PremadeGroupsFilterState = {
                version = 6,
                c2f4 = { enabled = true, }, -- Dungeons
                c3f5 = { enabled = true, }, -- Raids
                c3f6 = { enabled = true, }, -- Raids
                c114f4 = { enabled = true, }, -- Raids (Wrath)
                c114f5 = { enabled = true, }, -- Raids (Wrath)
                c114f6 = { enabled = true, }, -- Raids (Wrath)
                c4f8 = { enabled = true, }, -- Arena
                c9f8 = { enabled = true, }, -- RBG
            }
        end
        PGF.MigrateStateV4()
        PGF.MigrateStateV5()
        PGF.MigrateStateV6()

        -- request various player information from the server
        RequestRaidInfo()
        if PGF.SupportsMythicPlus() then
            C_MythicPlus.RequestCurrentAffixes()
            C_MythicPlus.RequestMapInfo()
        end
        if PGF.SupportsSpecializations() then
            PGF.InitSpecializations()
        end
    end
end

function PGF.OnPlayerLogin()
    PGF.FixGetPlaystyleStringIfPlayerAuthenticated()
    PGF.FixReportAdvertisement()
    PGF.PersistSignUpNote()
end

function PGF.OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then PGF.OnAddonLoaded(...) end
    if event == "PLAYER_LOGIN" then PGF.OnPlayerLogin() end
    if event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then PGF.OnLFGListApplicationStatusUpdated(...) end
end

local frame = CreateFrame("Frame", "PremadeGroupsFilterEventFrame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
frame:SetScript("OnEvent", PGF.OnEvent)
