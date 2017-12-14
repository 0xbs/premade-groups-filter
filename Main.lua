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

PGF.lastSearchEntryReset = time()
PGF.previousSearchExpression = ""
PGF.currentSearchExpression = ""
PGF.previousSearchLeaders = {}
PGF.currentSearchLeaders = {}

function PGF.GetExpressionFromMinMaxModel(model, key)
    local exp = ""
    if model[key].act then
        if PGF.NotEmpty(model[key].min) then exp = exp .. " and " .. key .. ">=" .. model[key].min end
        if PGF.NotEmpty(model[key].max) then exp = exp .. " and " .. key .. "<=" .. model[key].max end
    end
    return exp
end

function PGF.GetExpressionFromIlvlModel(model)
    local exp = PGF.GetExpressionFromMinMaxModel(model, "ilvl")
    if model.noilvl.act and PGF.NotEmpty(exp) then
        exp = exp:gsub("^ and ", "")
        exp = " and (" .. exp .. " or ilvl==0)"
    end
    return exp
end

function PGF.GetExpressionFromDifficultyModel(model)
    if model.difficulty.act then
        return " and " .. C.DIFFICULTY_STRING[model.difficulty.val]
    end
    return ""
end

function PGF.GetExpressionFromAdvancedExpression(model)
    if model.expression and model.expression ~= "" then
        return " and " .. model.expression
    end
    return ""
end

function PGF.GetModel()
    local tab = PVEFrame.activeTabIndex
    local category = LFGListFrame.SearchPanel.categoryID or LFGListFrame.CategorySelection.selectedCategory
    local filters = LFGListFrame.SearchPanel.filters or LFGListFrame.CategorySelection.selectedFilters or 0
    if not tab then return nil end
    if not category then return nil end
    if filters < 0 then filters = "n" .. filters end
    local modelKey = "t" .. tab .. "c" .. category .. "f" .. filters
    if PremadeGroupsFilterState[modelKey] == nil then
        local defaultState = {}
        -- if we have an old v1.10 state, take it instead of the default one
        local oldGlobalState = PremadeGroupsFilterState["v110"]
        if oldGlobalState ~= nil then
            defaultState = PGF.Table_Copy_Rec(oldGlobalState)
        end
        PGF.Table_UpdateWithDefaults(defaultState, C.MODEL_DEFAULT)
        PremadeGroupsFilterState[modelKey] = defaultState
    end
    return PremadeGroupsFilterState[modelKey]
end

function PGF.GetExpressionFromModel()
    local model = PGF.GetModel()
    if not model then return "true" end
    local exp = "true" -- start with neutral element
    exp = exp .. PGF.GetExpressionFromDifficultyModel(model)
    exp = exp .. PGF.GetExpressionFromIlvlModel(model)
    exp = exp .. PGF.GetExpressionFromMinMaxModel(model, "members")
    exp = exp .. PGF.GetExpressionFromMinMaxModel(model, "tanks")
    exp = exp .. PGF.GetExpressionFromMinMaxModel(model, "heals")
    exp = exp .. PGF.GetExpressionFromMinMaxModel(model, "dps")
    exp = exp .. PGF.GetExpressionFromMinMaxModel(model, "defeated")
    exp = exp .. PGF.GetExpressionFromAdvancedExpression(model)
    exp = exp:gsub("^true and ", "")
    return exp
end

function PGF.ResetSearchEntries()
    -- make sure to wait at least some time between two resets
    if time() - PGF.lastSearchEntryReset > C.SEARCH_ENTRY_RESET_WAIT then
        PGF.previousSearchLeaders = PGF.Table_Copy_Shallow(PGF.currentSearchLeaders)
        PGF.currentSearchLeaders = {}
        PGF.previousSearchExpression = PGF.currentSearchExpression
        PGF.lastSearchEntryReset = time()
    end
end

function PGF.SortByFriendsAndAge(id1, id2)
    local _, _, _, _, _, _, _, age1, bnetFriends1, charFriends1, guildMates1 = C_LFGList.GetSearchResultInfo(id1);
    local _, _, _, _, _, _, _, age2, bnetFriends2, charFriends2, guildMates2 = C_LFGList.GetSearchResultInfo(id2);
    if bnetFriends1 ~= bnetFriends2 then return bnetFriends1 > bnetFriends2 end
    if charFriends1 ~= charFriends2 then return charFriends1 > charFriends2 end
    if guildMates1 ~= guildMates2 then return guildMates1 > guildMates2 end
    return age1 < age2
end

function PGF.DoFilterSearchResults(results)
    --print(debugstack())
    --print("filtering, size is "..#results)

    PGF.ResetSearchEntries()
    local exp = PGF.GetExpressionFromModel()
    PGF.currentSearchExpression = exp
    local model = PGF.GetModel()
    if not model or not model.enabled then return false end
    if not results or #results == 0 then return false end
    if exp == "true" then return false end -- skip trivial expression

    -- loop backwards through the results list so we can remove elements from the table
    for idx = #results, 1, -1 do
        local resultID = results[idx]
        local _, activity, name, comment, voiceChat, iLvl, honorLevel, age,
              numBNetFriends, numCharFriends, numGuildMates, _, leaderName,
              numMembers = C_LFGList.GetSearchResultInfo(resultID)
        local defeatedBossNames = C_LFGList.GetSearchResultEncounterInfo(resultID)
        local memberCounts = C_LFGList.GetSearchResultMemberCounts(resultID)
        local numGroupDefeated, numPlayerDefeated, maxBosses,
              matching, groupAhead, groupBehind = PGF.GetLockoutInfo(activity, resultID)
        local avName, avShortName, avCategoryID, avGroupID, avILevel, avFilters,
              avMinLevel, avMaxPlayers, avDisplayType, avOrderIndex,
              avUseHonorLevel, avShowQuickJoin = C_LFGList.GetActivityInfo(activity)
        local difficulty = PGF.GetDifficulty(activity, avName, avShortName)

        local env = {}
        env.activity = activity
        env.name = name:lower()
        env.activityname = avName:lower()
        env.comment = comment:lower()
        env.leader = leaderName and leaderName:lower() or ""
        env.age = math.floor(age / 60) -- age in minutes
        env.voice = voiceChat and voiceChat ~= ""
        env.voicechat = voiceChat
        env.ilvl = iLvl or 0
        env.hlvl = honorLevel or 0
        env.friends = numBNetFriends + numCharFriends + numGuildMates
        env.members = numMembers
        env.tanks = memberCounts.TANK
        env.heals = memberCounts.HEALER
        env.healers = memberCounts.HEALER
        env.dps = memberCounts.DAMAGER + memberCounts.NOROLE
        env.defeated = numGroupDefeated
        env.normal     = difficulty == C.NORMAL
        env.heroic     = difficulty == C.HEROIC
        env.mythic     = difficulty == C.MYTHIC
        env.mythicplus = difficulty == C.MYTHICPLUS
        env.myrealm = leaderName and leaderName ~= "" and not leaderName:find('-')
        env.partialid = numPlayerDefeated > 0
        env.fullid = numPlayerDefeated > 0 and numPlayerDefeated == maxBosses
        env.noid = not env.partialid and not env.fullid
        env.matchingid = groupAhead == 0 and groupBehind == 0
        env.bossesmatching = matching
        env.bossesahead = groupAhead
        env.bossesbehind = groupBehind
        env.maxplayers = avMaxPlayers
        env.suggestedilvl = avILevel
        env.minlvl = avMinLevel
        env.categoryid = avCategoryID
        env.groupid = avGroupID

        for i = 1, numMembers do
            local role, class = C_LFGList.GetSearchResultMemberInfo(resultID, i);
            local classPlural = class:lower() .. "s" -- plural form of the class in english
            env[classPlural] = (env[classPlural] or 0) + 1
            if role then
                local classRolePlural = C.ROLE_PREFIX[role] .. "_" .. class:lower() .. "s"
                local roleClassPlural = class:lower() .. "_" .. C.ROLE_SUFFIX[role]
                env[classRolePlural] = (env[classRolePlural] or 0) + 1
                env[roleClassPlural] = (env[roleClassPlural] or 0) + 1
            end
        end

        env.arena2v2 = activity == 6 or activity == 491
        env.arena3v3 = activity == 7 or activity == 490

        -- raids            normal             heroic             mythic
        env.hm   = activity ==  37 or activity ==  38 or activity == 399  -- Highmaul
        env.brf  = activity ==  39 or activity ==  40 or activity == 400  -- Blackrock Foundry
        env.hfc  = activity == 409 or activity == 410 or activity == 412  -- Hellfire Citadel
        env.en   = activity == 413 or activity == 414 or activity == 468  -- The Emerald Nightmare
        env.nh   = activity == 415 or activity == 416 or activity == 481  -- The Nighthold
        env.tov  = activity == 456 or activity == 457 or activity == 480  -- Trial of Valor
        env.tos  = activity == 479 or activity == 478 or activity == 492  -- Tomb of Sargeras
        env.atbt = activity == 482 or activity == 483 or activity == 493  -- Antorus, the Burning Throne

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
                                   or activity == 470                    or activity == 471  -- Lower Karazahn
                                   or activity == 472                    or activity == 473  -- Upper Karazhan
        env.lkara =                   activity == 470                    or activity == 471  -- Lower Karazahn
        env.ukara =                   activity == 472                    or activity == 473  -- Upper Karazhan
        env.coen =                    activity == 474 or activity == 475 or activity == 476  -- Cathedral of Eternal Night
        env.sott =                    activity == 484 or activity == 485 or activity == 486  -- Seat of the Triumvirate

        local numbers = PGF.String_ExtractNumbers(name .. " " .. comment)
        env.findnumber = function (min, max)
            for _, v in ipairs(numbers) do
                if (not min or v >= min) and (not max or v <= max) then
                    return true
                end
            end
            return false
        end

        setmetatable(env, { __index = function(table, key) return 0 end }) -- set non-initialized values to 0
        if PGF.DoesPassThroughFilter(env, exp) then
            -- leaderName is usually still nil at this point if the group is new, but we can live with that
            if leaderName then PGF.currentSearchLeaders[leaderName] = true end
        else
            table.remove(results, idx)
        end
    end
    -- sort by age
    table.sort(results, PGF.SortByFriendsAndAge)
    LFGListFrame.SearchPanel.totalResults = #results
    return true
end

function PGF.OnLFGListSearchEntryUpdate(self)
    local resultID, activity, _, _, _, _, _, _, _, _, _, isDelisted, leaderName = C_LFGList.GetSearchResultInfo(self.resultID)
    -- try once again to update the leaderName (this information is not immediately available)
    if leaderName then PGF.currentSearchLeaders[leaderName] = true end
    --self.ActivityName:SetText("[" .. activity .. "/" .. resultID .. "] " .. self.ActivityName:GetText()) -- DEBUG
    if not isDelisted then
        -- color name if new
        if PGF.currentSearchExpression ~= "true"                        -- not trivial search
        and PGF.currentSearchExpression == PGF.previousSearchExpression -- and the same search
        and (leaderName and not PGF.previousSearchLeaders[leaderName]) then              -- and leader is new
            local color = C.COLOR_ENTRY_NEW
            self.Name:SetTextColor(color.R, color.G, color.B);
        end
        -- color activity if lockout
        local numGroupDefeated, numPlayerDefeated, maxBosses,
              matching, groupAhead, groupBehind = PGF.GetLockoutInfo(activity, resultID)
        local color
        if numPlayerDefeated > 0 and numPlayerDefeated == maxBosses then
            color = C.COLOR_LOCKOUT_FULL
        elseif numPlayerDefeated > 0 and groupAhead == 0 and groupBehind == 0 then
            color = C.COLOR_LOCKOUT_MATCH
        end
        if color then
            self.ActivityName:SetTextColor(color.R, color.G, color.B)
        end
    end
end

function PGF.OnLFGListSearchEntryOnEnter(self)
    local resultID = self.resultID
    local _, activity, _, _, _, _, _, _, _, _, _, isDelisted, _, numMembers = C_LFGList.GetSearchResultInfo(resultID)
    local _, _, _, _, _, _, _, _, displayType = C_LFGList.GetActivityInfo(activity);

    -- do not show members where Blizzard already does that
    if displayType == LE_LFG_LIST_DISPLAY_TYPE_CLASS_ENUMERATE then return end
    if isDelisted or not GameTooltip:IsShown() then return end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(CLASS_ROLES);

    local roles = {}
    local classInfo = {}
    for i = 1, numMembers do
        local role, class, classLocalized = C_LFGList.GetSearchResultMemberInfo(resultID, i);
        classInfo[class] = {
            name = classLocalized,
            color = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
        }
        if not roles[role] then roles[role] = {} end
        if not roles[role][class] then roles[role][class] = 0 end
        roles[role][class] = roles[role][class] + 1
    end

    for role, classes in pairs(roles) do
        GameTooltip:AddLine(_G[role]..": ")
        for class, count in pairs(classes) do
            local text = "   "
            if count > 1 then text = text .. count .. " " else text = text .. "   " end
            text = text .. "|c" .. classInfo[class].color.colorStr ..  classInfo[class].name .. "|r "
            GameTooltip:AddLine(text)
        end
    end
    GameTooltip:Show()
end

hooksecurefunc("LFGListSearchEntry_Update", PGF.OnLFGListSearchEntryUpdate)
hooksecurefunc("LFGListSearchEntry_OnEnter", PGF.OnLFGListSearchEntryOnEnter)
hooksecurefunc("LFGListUtil_SortSearchResults", PGF.DoFilterSearchResults)
