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

PGF.currentSearchResults = {}
PGF.lastSearchEntryReset = time()
PGF.previousSearchExpression = ""
PGF.currentSearchExpression = ""
PGF.previousSearchLeaders = {}
PGF.currentSearchLeaders = {}
PGF.searchResultIDInfo = {}
PGF.numResultsBeforeFilter = 0
PGF.numResultsAfterFilter = 0

function PGF.ResetSearchEntries()
    -- make sure to wait at least some time between two resets
    if time() - PGF.lastSearchEntryReset > C.SEARCH_ENTRY_RESET_WAIT then
        PGF.previousSearchLeaders = PGF.Table_Copy_Shallow(PGF.currentSearchLeaders)
        PGF.currentSearchLeaders = {}
        PGF.previousSearchExpression = PGF.currentSearchExpression
        PGF.lastSearchEntryReset = time()
        PGF.searchResultIDInfo = {}
        PGF.numResultsBeforeFilter = 0
        PGF.numResultsAfterFilter = 0
    end
end

function PGF.GetUserSortingTable()
    local sorting = PGF.Dialog:GetSortingExpression()
    if PGF.Empty(sorting) then return 0, {} end
    -- example string:  "friends asc, age desc , foo asc, bar   desc , x"
    -- resulting table: { ["friends"] = "asc", ["age"] = "desc", ["foo"] = "asc", ["bar"] = "desc" }
    local c = 0
    local t = {}
    for k, v in string.gmatch(sorting, "(%w+)%s+(%w+),?") do
        c = c + 1
        t[k] = v
    end
    return c, t
end

function PGF.SortSearchResults(results)
    local sortTableSize, sortTable = PGF.GetUserSortingTable()
    if sortTableSize > 0 then -- use custom sorting if defined
        table.sort(results, PGF.SortByExpression)
    elseif PGF.IsRetail() then -- use our extended useful sorting
        table.sort(results, PGF.SortByUsefulOrder)
    end
    -- else keep the existing sorting as Wrath clients have a pretty big
    -- intelligent sorting algorithm in LFGBrowseUtil_SortSearchResults
end

function PGF.SortByExpression(searchResultID1, searchResultID2)
    local info1 = PGF.searchResultIDInfo[searchResultID1]
    local info2 = PGF.searchResultIDInfo[searchResultID2]
    if not info1 or not info2 then return false end -- race condition
    local sortTableSize, sortTable = PGF.GetUserSortingTable()
    for k, v in pairs(sortTable) do
        if info1.env[k] ~= info2.env[k] then -- works with unknown 'k' as 'nil ~= nil' is false (or 'nil == nil' is true)
            if v == "desc" then
                if type(info1.env[k]) == "boolean" then return info1.env[k] end -- true before false
                return info1.env[k] > info2.env[k]
            else -- works with unknown 'v', in this case sort ascending by default
                if type(info1.env[k]) == "boolean" then return info2.env[k] end -- false before true
                return info1.env[k] < info2.env[k]
            end
        end
    end
    -- no sorting defined or all properties are the same, fall back to default sorting
    return PGF.SortByUsefulOrder(searchResultID1, searchResultID2)
end

function PGF.SortByUsefulOrder(searchResultID1, searchResultID2)
    if not searchResultID1 or not searchResultID2 then return false end -- race condition

    -- look-up via table should be faster
    local info1 = PGF.searchResultIDInfo[searchResultID1]
    local info2 = PGF.searchResultIDInfo[searchResultID2]
    if not info1 or not info2 then return false end -- race condition

    -- sort applications to the top
    local isApplication1 = info1.env.appstatus ~= "none" or info1.env.pendingstatus or false
    local isApplication2 = info2.env.appstatus ~= "none" or info2.env.pendingstatus or false
    if isApplication1 ~= isApplication2 then return isApplication1 end
    if info1.env.appduration ~= info2.env.appduration then return info1.env.appduration > info2.env.appduration end

    local searchResultInfo1 = info1.searchResultInfo
    local searchResultInfo2 = info2.searchResultInfo

    if PGF.SupportsSpecializations() then
        -- sort by partyfit
        local hasRemainingRole1 = PGF.HasRemainingSlotsForLocalPlayerRole(info1.memberCounts)
        local hasRemainingRole2 = PGF.HasRemainingSlotsForLocalPlayerRole(info2.memberCounts)
        if hasRemainingRole1 ~= hasRemainingRole2 then return hasRemainingRole1 end
    end

    -- sort by friends desc
    if searchResultInfo1.numBNetFriends ~= searchResultInfo2.numBNetFriends then
        return searchResultInfo1.numBNetFriends > searchResultInfo2.numBNetFriends
    end
    if searchResultInfo1.numCharFriends ~= searchResultInfo2.numCharFriends then
        return searchResultInfo1.numCharFriends > searchResultInfo2.numCharFriends
    end
    if searchResultInfo1.numGuildMates ~= searchResultInfo2.numGuildMates then
        return searchResultInfo1.numGuildMates > searchResultInfo2.numGuildMates
    end

    -- if dungeon, sort by mprating desc
    if info1.activityInfo.categoryID == C.CATEGORY_ID.DUNGEON or
       info2.activityInfo.categoryID == C.CATEGORY_ID.DUNGEON then
        if info1.env.mprating ~= info2.env.mprating then
            return info1.env.mprating > info2.env.mprating
        end
    end
    -- if arena or RBG, sort by pvprating desc
    if info1.activityInfo.categoryID == C.CATEGORY_ID.ARENA or
       info2.activityInfo.categoryID == C.CATEGORY_ID.ARENA or
       info1.activityInfo.categoryID == C.CATEGORY_ID.RATED_BATTLEGROUND or
       info2.activityInfo.categoryID == C.CATEGORY_ID.RATED_BATTLEGROUND then
        if info1.env.pvprating ~= info2.env.pvprating then
            return info1.env.pvprating > info2.env.pvprating
        end
    end

    if searchResultInfo1.isWarMode ~= searchResultInfo2.isWarMode then
        return searchResultInfo1.isWarMode == C_PvP.IsWarModeDesired()
    end

    return searchResultInfo1.age < searchResultInfo2.age
end

--- Ensures that all class-role/role-class and ranged/melees keywords are initialized to zero in the filter environment,
--- because the values would cause a semantic error otherwise (because they do not exist)
--- @generic V
--- @param env table<string, V> environment to be prepared
function PGF.InitClassRoleTypeKeywords(env)
    env.cloth = 0
    env.leather = 0
    env.mail = 0
    env.plate = 0
    env.ranged = 0
    env.ranged_strict = 0
    env.melees = 0
    env.melees_strict = 0
    for class, type in pairs(C.DPS_CLASS_TYPE) do
        local classPlural = class:lower() .. "s"
        env[classPlural] = 0
        for role, prefix in pairs(C.ROLE_PREFIX) do
            local classRolePlural = prefix .. "_" .. classPlural
            local roleClassPlural = class:lower() .. "_" .. C.ROLE_SUFFIX[role]
            env[classRolePlural] = 0
            env[roleClassPlural] = 0
        end
    end
end

--- Puts a table that maps localized boss names to a boolean that indicates if the boss was defeated
--- @generic V
--- @param resultID number search result identifier
--- @param env table<string, V> environment to be prepared
function PGF.PutEncounterNames(resultID, env)
    local encounterToBool = {}
    -- return false for all values not explicitly set to true
    local encounterToBoolMeta = {}
    encounterToBoolMeta.__index = function (table, key) return false end
    setmetatable(encounterToBool, encounterToBoolMeta)

    local encounterInfo = C_LFGList.GetSearchResultEncounterInfo(resultID); -- list of localized boss names
    if encounterInfo then
        for _, val in pairs(encounterInfo) do
            encounterToBool[val] = true
            encounterToBool[val:lower()] = true
        end
    end

    env.boss = encounterToBool
end

--- Initializes all class-role/role-class and ranged/melees keywords and increments them to their correct value
--- @generic V
--- @param resultID number search result identifier
--- @param searchResultInfo table<string, V> search result info from API
--- @param env table<string, V> environment to be prepared
function PGF.PutSearchResultMemberInfos(resultID, searchResultInfo, env)
    PGF.InitClassRoleTypeKeywords(env)
    for i = 1, searchResultInfo.numMembers do
        local role, class = C_LFGList.GetSearchResultMemberInfo(resultID, i)
        local classPlural = class:lower() .. "s" -- plural form of the class in english
        env[classPlural] = env[classPlural] + 1
        local armor = C.DPS_CLASS_TYPE[class].armor
        if armor then
            env[armor] = env[armor] + 1
        end
        if role then
            local classRolePlural = C.ROLE_PREFIX[role] .. "_" .. class:lower() .. "s"
            local roleClassPlural = class:lower() .. "_" .. C.ROLE_SUFFIX[role]
            env[classRolePlural] = env[classRolePlural] + 1
            env[roleClassPlural] = env[roleClassPlural] + 1
            if role == "DAMAGER" then
                if C.DPS_CLASS_TYPE[class].range and C.DPS_CLASS_TYPE[class].melee then
                    env.ranged = env.ranged + 1
                    env.melees = env.melees + 1
                elseif C.DPS_CLASS_TYPE[class].range then
                    env.ranged = env.ranged + 1
                    env.ranged_strict = env.ranged_strict + 1
                elseif C.DPS_CLASS_TYPE[class].melee then
                    env.melees = env.melees + 1
                    env.melees_strict = env.melees_strict + 1
                end
            end
        end
    end
end

function PGF.DoFilterSearchResults(results)
    --print(debugstack())
    --print("filtering, size is "..#results)

    if not PGF.Dialog:GetEnabled() then return results end
    if not results or #results == 0 then return results end

    local exp = PGF.Dialog:GetFilterExpression()
    PGF.Logger:Debug("Main: exp = "..exp)
    PGF.currentSearchExpression = exp

    local playerInfo = PGF.GetPlayerInfo()

    PGF.numResultsBeforeFilter = #results
    -- loop backwards through the results list so we can remove elements from the table
    for idx = #results, 1, -1 do
        local resultID = results[idx]
        local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
        -- /dump C_LFGList.GetSearchResultInfo(select(2, C_LFGList.GetSearchResults())[1])
        -- name and comment are now protected strings like "|Ks1969|k0000000000000000|k" which can only be printed
        local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID)
        -- /dump C_LFGList.GetApplicationInfo(select(2, C_LFGList.GetSearchResults())[1])
        local memberCounts = C_LFGList.GetSearchResultMemberCounts(resultID)
        local numGroupDefeated, numPlayerDefeated, maxBosses,
              matching, groupAhead, groupBehind = PGF.GetLockoutInfo(searchResultInfo.activityID, resultID)
        local activityInfo = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)

        local difficulty = C.ACTIVITY[searchResultInfo.activityID].difficulty

        local env = {}
        env.activity = searchResultInfo.activityID
        env.activityname = activityInfo.fullName:lower()
        env.leader = searchResultInfo.leaderName and searchResultInfo.leaderName:lower() or ""
        env.age = math.floor(searchResultInfo.age / 60) -- age in minutes
        env.agesecs = searchResultInfo.age -- age in seconds
        env.voice = searchResultInfo.voiceChat and searchResultInfo.voiceChat ~= ""
        env.voicechat = searchResultInfo.voiceChat
        env.ilvl = searchResultInfo.requiredItemLevel or 0
        env.hlvl = searchResultInfo.requiredHonorLevel or 0
        env.friends = searchResultInfo.numBNetFriends + searchResultInfo.numCharFriends + searchResultInfo.numGuildMates
        env.members = searchResultInfo.numMembers
        env.tanks = memberCounts.TANK
        env.heals = memberCounts.HEALER
        env.healers = memberCounts.HEALER
        env.dps = memberCounts.DAMAGER + memberCounts.NOROLE
        env.defeated = numGroupDefeated
        env.normal     = difficulty == C.NORMAL
        env.heroic     = difficulty == C.HEROIC
        env.mythic     = difficulty == C.MYTHIC
        env.mythicplus = difficulty == C.MYTHICPLUS
        env.myrealm = searchResultInfo.leaderName and searchResultInfo.leaderName ~= "" and searchResultInfo.leaderName:find('-') == nil or false
        env.partialid = numPlayerDefeated > 0
        env.fullid = numPlayerDefeated > 0 and numPlayerDefeated == maxBosses
        env.noid = not env.partialid and not env.fullid
        env.matchingid = groupAhead == 0 and groupBehind == 0
        env.bossesmatching = matching
        env.bossesahead = groupAhead
        env.bossesbehind = groupBehind
        env.maxplayers = activityInfo.maxNumPlayers
        env.suggestedilvl = activityInfo.ilvlSuggestion
        env.minlvl = activityInfo.minLevel
        env.categoryid = activityInfo.categoryID
        env.groupid = activityInfo.groupFinderActivityGroupID
        env.autoinv = searchResultInfo.autoAccept
        env.questid = searchResultInfo.questID
        env.declined = PGF.IsHardDeclinedGroup(searchResultInfo)
        env.harddeclined = env.declined
        env.softdeclined = PGF.IsSoftDeclinedGroup(searchResultInfo)
        env.warmode = searchResultInfo.isWarMode or false
        env.playstyle = searchResultInfo.playstyle
        env.earnconq  = searchResultInfo.playstyle == 1
        env.learning  = searchResultInfo.playstyle == 2
        env.beattimer = searchResultInfo.playstyle == 3
        env.push      = searchResultInfo.playstyle == 3
        env.mprating = searchResultInfo.leaderOverallDungeonScore or 0
        env.mpmaprating = 0
        env.mpmapname   = ""
        env.mpmapmaxkey = 0
        env.mpmapintime = false
        if searchResultInfo.leaderDungeonScoreInfo then
            env.mpmaprating = searchResultInfo.leaderDungeonScoreInfo.mapScore
            env.mpmapname   = searchResultInfo.leaderDungeonScoreInfo.mapName
            env.mpmapmaxkey = searchResultInfo.leaderDungeonScoreInfo.bestRunLevel
            env.mpmapintime = searchResultInfo.leaderDungeonScoreInfo.finishedSuccess
        end
        env.pvpactivityname = ""
        env.pvprating = 0
        env.pvptierx = 0
        env.pvptier = 0
        env.pvptiername = ""
        if searchResultInfo.leaderPvpRatingInfo then
            env.pvpactivityname = searchResultInfo.leaderPvpRatingInfo.activityName
            env.pvprating       = searchResultInfo.leaderPvpRatingInfo.rating
            env.pvptierx        = searchResultInfo.leaderPvpRatingInfo.tier
            env.pvptier         = C.PVP_TIER_MAP[searchResultInfo.leaderPvpRatingInfo.tier].tier
            env.pvptiername     = PVPUtil.GetTierName(searchResultInfo.leaderPvpRatingInfo.tier)
        end
        env.horde = searchResultInfo.leaderFactionGroup == 0
        env.alliance = searchResultInfo.leaderFactionGroup == 1
        env.crossfaction = searchResultInfo.crossFactionListing or false
        env.appstatus = appStatus
        env.pendingstatus = pendingStatus
        env.appduration = appDuration

        PGF.PutSearchResultMemberInfos(resultID, searchResultInfo, env)
        PGF.PutEncounterNames(resultID, env)

        if PGF.IsRetail() then -- changed a lot each expansion
            env.hasbr = env.druids > 0 or env.paladins > 0 or env.warlocks > 0 or env.deathknights > 0
            env.hasbl = env.shamans > 0 or env.evokers > 0 or env.hunters > 0 or env.mages > 0
            env.hashero = env.hasbl
            env.haslust = env.hasbl
        end
        if PGF.SupportsSpecializations() then
            env.brfit = env.hasbr or PGF.PlayerOrGroupHasBattleRezz() or PGF.HasRemainingSlotsForBattleRezzAfterJoin(memberCounts)
            env.blfit = env.hasbl or PGF.PlayerOrGroupHasBloodlust() or PGF.HasRemainingSlotsForBloodlustAfterJoin(memberCounts)
            env.partyfit = PGF.HasRemainingSlotsForLocalPlayerPartyRoles(memberCounts)
        end

        env.myilvl = playerInfo.avgItemLevelEquipped
        env.myilvlpvp = playerInfo.avgItemLevelPvp
        env.mymprating = playerInfo.mymprating
        env.myaffixrating = playerInfo.affixRating[searchResultInfo.activityID] or 0
        env.mydungeonrating = playerInfo.dungeonRating[searchResultInfo.activityID] or 0
        env.myavgaffixrating = playerInfo.avgAffixRating
        env.mymedianaffixrating = playerInfo.medianAffixRating
        env.myavgdungeonrating = playerInfo.avgDungeonRating
        env.mymediandungeonrating = playerInfo.medianDungeonRating

        PGF.PutActivityKeywords(env, searchResultInfo.activityID)

        if PGF.PutRaiderIOMetrics then
            PGF.PutRaiderIOMetrics(env, searchResultInfo.leaderName, searchResultInfo.activityID)
        end
        if PGF.PutPremadeRegionInfo then
            PGF.PutPremadeRegionInfo(env, searchResultInfo.leaderName)
        end

        PGF.searchResultIDInfo[resultID] = {
            env = env,
            searchResultInfo = searchResultInfo,
            memberCounts = memberCounts,
            activityInfo = activityInfo,
        }
        if PGF.DoesPassThroughFilter(env, exp) then
            -- leaderName is usually still nil at this point if the group is new, but we can live with that
            if searchResultInfo.leaderName then PGF.currentSearchLeaders[searchResultInfo.leaderName] = true end
        else
            table.remove(results, idx)
        end
    end
    PGF.numResultsAfterFilter = #results

    PGF.SortSearchResults(results)
    return results
end

function PGF.ColorGroupTexts(self, searchResultInfo)
    if not PremadeGroupsFilterSettings.coloredGroupTexts then return end

    -- try once again to update the leaderName (this information is not immediately available)
    if searchResultInfo.leaderName then PGF.currentSearchLeaders[searchResultInfo.leaderName] = true end
    -- self.ActivityName:SetText("[" .. searchResultInfo.activityID .. "/" .. self.resultID .. "] " .. self.ActivityName:GetText()) -- DEBUG
    if not searchResultInfo.isDelisted then
        -- color name if new
        if PGF.currentSearchExpression ~= "true"                        -- not trivial search
        and PGF.currentSearchExpression == PGF.previousSearchExpression -- and the same search
        and (searchResultInfo.leaderName and not PGF.previousSearchLeaders[searchResultInfo.leaderName]) then -- and leader is new
            local color = C.COLOR_ENTRY_NEW
            self.Name:SetTextColor(color.R, color.G, color.B)
        end
        -- color name if declined
        if PGF.IsSoftDeclinedGroup(searchResultInfo) then
            local color = C.COLOR_ENTRY_DECLINED_SOFT
            self.Name:SetTextColor(color.R, color.G, color.B)
        end
        if PGF.IsHardDeclinedGroup(searchResultInfo) then
            local color = C.COLOR_ENTRY_DECLINED_HARD
            self.Name:SetTextColor(color.R, color.G, color.B)
        end
        -- color activity if lockout
        local numGroupDefeated, numPlayerDefeated, maxBosses,
              matching, groupAhead, groupBehind = PGF.GetLockoutInfo(searchResultInfo.activityID, self.resultID)
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

function PGF.OnLFGListSearchEntryUpdate(self)
    local searchResultInfo = C_LFGList.GetSearchResultInfo(self.resultID)
    PGF.ColorGroupTexts(self, searchResultInfo)
    PGF.ColorApplications(self, searchResultInfo)
    PGF.AddRoleIndicators(self, searchResultInfo)
    PGF.AddRatingInfo(self, searchResultInfo)
end

function PGF.OnLFGListSearchPanelUpdateResultList(self)
    PGF.Logger:Debug("PGF.OnLFGListSearchPanelUpdateResultList")
    PGF.currentSearchResults = self.results
    PGF.ResetSearchEntries()
    PGF.FilterSearchResults()
end

function PGF.FilterSearchResults()
    PGF.Logger:Debug("PGF.FilterSearchResults")
    local copy = PGF.Table_Copy_Shallow(PGF.currentSearchResults)
    local results = PGF.DoFilterSearchResults(copy)
    -- publish
    LFGListFrame.SearchPanel.results = results
    LFGListFrame.SearchPanel.totalResults = #results
    LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel)
end

hooksecurefunc("LFGListSearchEntry_Update", PGF.OnLFGListSearchEntryUpdate)
hooksecurefunc("LFGListSearchPanel_UpdateResultList", PGF.OnLFGListSearchPanelUpdateResultList)
