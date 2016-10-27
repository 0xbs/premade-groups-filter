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

local PGF = PremadeGroupsFilter
local L = select(2, ...)

PGF.CONST = {
    DEBUG = false,
    NORMAL = 1,
    HEROIC = 2,
    MYTHIC = 3,
    MYTHICPLUS = 4,
    DEFAULT = {
        DIFFICULTY = 3, -- MYTHIC, may not yet use constant here
        ILVL       = { MIN = 800, MAX = 850 },
        MEMBERS    = { MIN =   0, MAX =  40 },
        TANKS      = { MIN =   0, MAX =   2 },
        HEALS      = { MIN =   0, MAX =   8 },
        DPS        = { MIN =   0, MAX =  30 },
        DEFEATED   = { MIN =   0, MAX =  15 },
    },
    FONTSIZE_TEXTBOX = 12,
    COLOR = {
        ENTRY_NEW = { R = 0.3, G = 1.0, B = 0.3 },
    },
    SEARCH_ENTRY_RESET_WAIT = 2, -- wait at least 2 seconds between two resets of known premade groups
}

PGF.CONST.DIFFICULTY_STRING = {
    [1] = "normal",
    [2] = "heroic",
    [3] = "mythic",
    [4] = "mythicplus",
}

-- /run for i=455,480,1 do local n=C_LFGList.GetActivityInfo(i);print(i,n)end
PGF.CONST.ACTIVITY_DIFFICULTY = {
    -- Warlords of Draenor (raids only)
    [37]  = PGF.CONST.NORMAL, -- Highmaul
    [38]  = PGF.CONST.HEROIC, -- Highmaul
    [399] = PGF.CONST.MYTHIC, -- Highmaul

    [39]  = PGF.CONST.NORMAL, -- Blackrock Foundry
    [40]  = PGF.CONST.HEROIC, -- Blackrock Foundry
    [400] = PGF.CONST.MYTHIC, -- Blackrock Foundry

    [409] = PGF.CONST.NORMAL, -- Hellfire Citadel
    [410] = PGF.CONST.HEROIC, -- Hellfire Citadel
    [412] = PGF.CONST.MYTHIC, -- Hellfire Citadel

    -- Legion
    [413] = PGF.CONST.NORMAL, -- The Emerald Nightmare
    [414] = PGF.CONST.HEROIC, -- The Emerald Nightmare
    [415] = PGF.CONST.NORMAL, -- The Nighthold
    [416] = PGF.CONST.HEROIC, -- The Nighthold

    [417] = PGF.CONST.NORMAL, -- Random Dungeon
    [418] = PGF.CONST.HEROIC, -- Random Dungeon

    [425] = PGF.CONST.NORMAL, -- Eye of Azshara
    [426] = PGF.CONST.NORMAL, -- Darkheart Thicket
    [427] = PGF.CONST.NORMAL, -- Halls of Valor
    [428] = PGF.CONST.NORMAL, -- Neltharion's Lair
    [429] = PGF.CONST.NORMAL, -- Violet Hold
    [430] = PGF.CONST.NORMAL, -- Black Rook Hold
    [431] = PGF.CONST.NORMAL, -- Vault of the Wardens
    [432] = PGF.CONST.NORMAL, -- Maw of Souls
    [433] = PGF.CONST.NORMAL, -- Court of Stars
    [434] = PGF.CONST.NORMAL, -- The Arcway

    [435] = PGF.CONST.HEROIC, -- Eye of Azshara
    [436] = PGF.CONST.HEROIC, -- Darkheart Thicket
    [437] = PGF.CONST.HEROIC, -- Halls of Valor
    [438] = PGF.CONST.HEROIC, -- Neltharion's Lair
    [439] = PGF.CONST.HEROIC, -- Violet Hold
    [440] = PGF.CONST.HEROIC, -- Black Rook Hold
    [441] = PGF.CONST.HEROIC, -- Vault of the Wardens
    [442] = PGF.CONST.HEROIC, -- Maw of Souls
    [443] = PGF.CONST.HEROIC, -- Court of Stars
    [444] = PGF.CONST.HEROIC, -- The Arcway

    [445] = PGF.CONST.MYTHIC, -- Eye of Azshara
    [446] = PGF.CONST.MYTHIC, -- Darkheart Thicket
    [447] = PGF.CONST.MYTHIC, -- Halls of Valor
    [448] = PGF.CONST.MYTHIC, -- Neltharion's Lair
    [449] = PGF.CONST.MYTHIC, -- Violet Hold
    [450] = PGF.CONST.MYTHIC, -- Black Rook Hold
    [451] = PGF.CONST.MYTHIC, -- Vault of the Wardens
    [452] = PGF.CONST.MYTHIC, -- Maw of Souls
    [453] = PGF.CONST.MYTHIC, -- Court of Stars
    [454] = PGF.CONST.MYTHIC, -- The Arcway

    [455] = PGF.CONST.MYTHIC, -- Karazhan

    [456] = PGF.CONST.NORMAL, -- Trial of Valor
    [457] = PGF.CONST.HEROIC, -- Trial of Valor

    [458] = PGF.CONST.NORMAL, -- World Bosses Legion

    [459] = PGF.CONST.MYTHICPLUS, -- Eye of Azshara
    [460] = PGF.CONST.MYTHICPLUS, -- Darkheart Thicket
    [461] = PGF.CONST.MYTHICPLUS, -- Halls of Valor
    [462] = PGF.CONST.MYTHICPLUS, -- Neltharion's Lair
    [463] = PGF.CONST.MYTHICPLUS, -- Black Rook Hold
    [464] = PGF.CONST.MYTHICPLUS, -- Vault of the Wardens
    [465] = PGF.CONST.MYTHICPLUS, -- Maw of Souls
    [466] = PGF.CONST.MYTHICPLUS, -- Court of Stars
    [467] = PGF.CONST.MYTHICPLUS, -- The Arcway
}

PGF.model = {
    expression = "",
    difficulty = {
        act = false,
        val = PGF.CONST.DEFAULT.DIFFICULTY,
    },
    ilvl = {
        act = false,
        min = "", --PGF.CONST.DEFAULT.ILVL.MIN,
        max = "", --PGF.CONST.DEFAULT.ILVL.MAX,
    },
    noilvl = {
        act = false
    },
    members = {
        act = false,
        min = "", --PGF.CONST.DEFAULT.MEMBERS.MIN,
        max = "", --PGF.CONST.DEFAULT.MEMBERS.MAX,
    },
    tanks = {
        act = false,
        min = "", --PGF.CONST.DEFAULT.TANKS.MIN,
        max = "", --PGF.CONST.DEFAULT.TANKS.MAX,
    },
    heals = {
        act = false,
        min = "", --PGF.CONST.DEFAULT.HEALS.MIN,
        max = "", --PGF.CONST.DEFAULT.HEALS.MAX,
    },
    dps = {
        act = false,
        min = "", --PGF.CONST.DEFAULT.DPS.MIN,
        max = "", --PGF.CONST.DEFAULT.DPS.MAX,
    },
    defeated = {
        act = false,
        min = "", --PGF.CONST.DEFAULT.DEFEATED.MIN,
        max = "", --PGF.CONST.DEFAULT.DEFEATED.MAX,
    },
}

PGF.lastSearchEntryReset = time()
PGF.previousSearchExpression = ""
PGF.currentSearchExpression = ""
PGF.previousSearchLeaders = {}
PGF.currentSearchLeaders = {}

StaticPopupDialogs["PEF_ERRORPOPUP"] = {
    text = "%s",
    button1 = L["button.ok"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

function PGF.DebugPrint(value)
    if PGF.CONST.DEBUG then print("[PGF][Debug] " .. value) end
end

function PGF.Table_Copy_Shallow(table)
    local copiedTable = {}
    for k, v in pairs(table) do
        copiedTable[k] = v
    end
    return copiedTable
end

function PGF.Table_Subtract(minuend, subtrahend)
    local difference = {}
    local lookupTable = {}
    for i = 1, #subtrahend do
        lookupTable[subtrahend[i]] = true;
    end
    for i = #minuend, 1, -1 do
        if not lookupTable[minuend[i]] then
            table.insert(difference, minuend[i])
        end
    end
    return difference
end

function PGF.NotEmpty(value) return value and value ~= "" end
function PGF.Empty(value) return not PGF.NotEmpty(value) end

function PGF.HandleSyntaxError(error)
    StaticPopup_Show("PEF_ERRORPOPUP", string.format(L["error.syntax"], error))
end

function PGF.HandleSemanticError(error)
    StaticPopup_Show("PEF_ERRORPOPUP", string.format(L["error.semantic"], error))
end

PGF.filterMetaTable = {
    __mode = "k",
    __index = function(table, key)
        local func, error = loadstring("return " .. key)
        if error then
            PGF.HandleSyntaxError(error)
            return nil
        end
        table[key] = func
        return func
    end,
    tonumber = tonumber
}

PGF.filter = setmetatable({}, PGF.filterMetaTable)

function PGF.GetExpressionFromMinMaxModel(key)
    local exp = ""
    if PGF.model[key].act then
        if PGF.NotEmpty(PGF.model[key].min) then exp = exp .. " and " .. key .. ">=" .. PGF.model[key].min end
        if PGF.NotEmpty(PGF.model[key].max) then exp = exp .. " and " .. key .. "<=" .. PGF.model[key].max end
    end
    return exp
end

function PGF.GetExpressionFromIlvlModel()
    local exp = PGF.GetExpressionFromMinMaxModel("ilvl")
    if PGF.model.noilvl.act and PGF.NotEmpty(exp) then
        exp = exp:gsub("^ and ", "")
        exp = " and (" .. exp .. " or ilvl==0)"
    end
    return exp
end

function PGF.GetExpressionFromDifficultyModel()
    if PGF.model.difficulty.act then
        return " and " .. PGF.CONST.DIFFICULTY_STRING[PGF.model.difficulty.val]
    end
    return ""
end

function PGF.GetExpressionFromAdvancedExpression()
    if PGF.model.expression and PGF.model.expression ~= "" then
        return " and " .. PGF.model.expression
    end
    return ""
end

function PGF.GetExpressionFromModel()
    local exp = "true" -- start with neutral element
    exp = exp .. PGF.GetExpressionFromDifficultyModel()
    exp = exp .. PGF.GetExpressionFromIlvlModel()
    exp = exp .. PGF.GetExpressionFromMinMaxModel("members")
    exp = exp .. PGF.GetExpressionFromMinMaxModel("tanks")
    exp = exp .. PGF.GetExpressionFromMinMaxModel("heals")
    exp = exp .. PGF.GetExpressionFromMinMaxModel("dps")
    exp = exp .. PGF.GetExpressionFromMinMaxModel("defeated")
    exp = exp .. PGF.GetExpressionFromAdvancedExpression()
    PGF.DebugPrint("Expression = " .. exp)
    exp = exp:gsub("^true and ", "")
    return exp
end

function PGF.ResetSearchEntries()
    -- make sure to wait at least some time between two resets
    if time() - PGF.lastSearchEntryReset > PGF.CONST.SEARCH_ENTRY_RESET_WAIT then
        PGF.previousSearchLeaders = PGF.Table_Copy_Shallow(PGF.currentSearchLeaders)
        PGF.currentSearchLeaders = {}
        PGF.previousSearchExpression = PGF.currentSearchExpression
        PGF.lastSearchEntryReset = time()
    end
end

function PGF.DoesPassThroughFilter(env, exp)
    --local exp = "mythic and tansk < 0 and members==4"  -- raises semantic error
    --local exp = "and and tanks==0 and members==4"      -- raises syntax error
    --local exp = "mythic and tanks==0 and members==4"   -- correct statement
    local filter = PGF.filter[exp]
    if filter then
        setfenv(filter, env)
        local hasFilterError, filterResult = pcall(filter)
        if hasFilterError then
            return filterResult
        else
            PGF.HandleSemanticError(filterResult)
            return true
        end
    end
    return true
end

function PGF.SortByFriendsAndAge(id1, id2)
    local _, _, _, _, _, _, _, age1, bnetFriends1, charFriends1, guildMates1 = C_LFGList.GetSearchResultInfo(id1);
    local _, _, _, _, _, _, _, age2, bnetFriends2, charFriends2, guildMates2 = C_LFGList.GetSearchResultInfo(id2);
    if bnetFriends1 ~= bnetFriends2 then return bnetFriends1 > bnetFriends2 end
    if charFriends1 ~= charFriends2 then return charFriends1 > charFriends2 end
    if guildMates1 ~= guildMates2 then return guildMates1 > guildMates2 end
    return age1 < age2
end

function PGF.OnLFGListSortSearchResults(results)
    PGF.ResetSearchEntries()
    local exp = PGF.GetExpressionFromModel()
    PGF.currentSearchExpression = exp
    if exp == "true" then return end -- skip trivial expression

    -- loop backwards through the results list so we can remove elements from the table
    for idx = #results, 1, -1 do
        local resultID = results[idx]
        local _, activity, name, comment, voiceChat, iLvl, honorLevel, age,
              numBNetFriends, numCharFriends, numGuildMates, _, leaderName,
              numMembers = C_LFGList.GetSearchResultInfo(resultID)
        local completedEncounters = C_LFGList.GetSearchResultEncounterInfo(resultID)
        local memberCounts = C_LFGList.GetSearchResultMemberCounts(resultID)

        local env = {}
        env.activity = activity
        env.name = name:lower()
        env.comment = comment:lower()
        env.leader = leaderName and leaderName:lower() or ""
        env.age = math.floor(age / 60) -- age in minutes
        env.voice = voiceChat and voiceChat ~= ""
        env.ilvl = iLvl or 0
        env.hlvl = honorLevel or 0
        env.friends = numBNetFriends + numCharFriends + numGuildMates
        env.members = numMembers
        env.tanks = memberCounts.TANK
        env.heals = memberCounts.HEALER
        env.dps = memberCounts.DAMAGER + memberCounts.NOROLE
        env.defeated = completedEncounters and #completedEncounters or 0
        env.normal     = PGF.CONST.ACTIVITY_DIFFICULTY[activity] == PGF.CONST.NORMAL
        env.heroic     = PGF.CONST.ACTIVITY_DIFFICULTY[activity] == PGF.CONST.HEROIC
        env.mythic     = PGF.CONST.ACTIVITY_DIFFICULTY[activity] == PGF.CONST.MYTHIC
        env.mythicplus = PGF.CONST.ACTIVITY_DIFFICULTY[activity] == PGF.CONST.MYTHICPLUS
        env.myrealm = leaderName and not leaderName:find('-')

        -- raids            normal             heroic             mythic
        env.hm   = activity ==  37 or activity ==  38 or activity == 399  -- Highmaul
        env.brf  = activity ==  39 or activity ==  40 or activity == 400  -- Blackrock Foundry
        env.hfc  = activity == 409 or activity == 410 or activity == 412  -- Hellfire Citadel
        env.en   = activity == 413 or activity == 414                     -- The Emerald Nightmare
        env.nh   = activity == 415 or activity == 416                     -- The Nighthold
        env.tov  = activity == 456 or activity == 457                     -- Trial of Valor

        -- dungeons         normal             heroic             mythic            mythic+
        env.eoa  = activity == 425 or activity == 435 or activity == 445 or activity == 459  -- Eye of Azshara
        env.dht  = activity == 426 or activity == 436 or activity == 446 or activity == 460  -- Darkheart Thicket
        env.hov  = activity == 427 or activity == 437 or activity == 447 or activity == 461  -- Halls of Valor
        env.nl   = activity == 428 or activity == 438 or activity == 448 or activity == 462  -- Neltharion's Lair
        env.vh   = activity == 429 or activity == 439 or activity == 449                     -- Violet Hold
        env.brh  = activity == 430 or activity == 440 or activity == 450 or activity == 463  -- Black Rook Hold
        env.votw = activity == 431 or activity == 441 or activity == 451 or activity == 464  -- Vault of the Wardens
        env.mos  = activity == 432 or activity == 442 or activity == 452 or activity == 465  -- Maw of Souls
        env.cos  = activity == 433 or activity == 443 or activity == 453 or activity == 466  -- Court of Stars
        env.aw   = activity == 434 or activity == 444 or activity == 454 or activity == 467  -- The Arcway
        env.kara =                                       activity == 455                     -- Karazhan

        if PGF.DoesPassThroughFilter(env, exp) then
            -- leaderName is usually still nil at this point if the group is new, but we can live with that
            if leaderName then PGF.currentSearchLeaders[leaderName] = true end
        else
            table.remove(results, idx)
        end
    end
    -- sort by age
    table.sort(results, PGF.SortByFriendsAndAge)
end

function PGF.OnLFGListUpdateSearchEntry(self)
    local leaderName = select(13, C_LFGList.GetSearchResultInfo(self.resultID))
    if PGF.currentSearchExpression ~= "true"                        -- not trivial search
    and PGF.currentSearchExpression == PGF.previousSearchExpression -- and the same search
    and not PGF.previousSearchLeaders[leaderName] then              -- and leader is new
        self.Name:SetTextColor(PGF.CONST.COLOR.ENTRY_NEW.R, PGF.CONST.COLOR.ENTRY_NEW.G, PGF.CONST.COLOR.ENTRY_NEW.B)
    end
end

hooksecurefunc("LFGListUtil_SortSearchResults", PGF.OnLFGListSortSearchResults)
hooksecurefunc("LFGListSearchEntry_Update", PGF.OnLFGListUpdateSearchEntry)
