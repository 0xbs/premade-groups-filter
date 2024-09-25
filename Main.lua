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

local PGF = select(2, ...)
local L = PGF.L
local C = PGF.C

PGF.currentSearchResults = {}
PGF.lastSearchEntryReset = time()
PGF.previousSearchExpression = ""
PGF.currentSearchExpression = ""
PGF.previousSearchGroupKeys = {}
PGF.currentSearchGroupKeys = {}
PGF.searchResultIDInfo = {}
PGF.numResultsBeforeFilter = 0
PGF.numResultsAfterFilter = 0

function PGF.ResetSearchEntries()
    -- make sure to wait at least some time between two resets
    if time() - PGF.lastSearchEntryReset > C.SEARCH_ENTRY_RESET_WAIT then
        PGF.previousSearchGroupKeys = PGF.Table_Copy_Shallow(PGF.currentSearchGroupKeys)
        PGF.currentSearchGroupKeys = {}
        PGF.previousSearchExpression = PGF.currentSearchExpression
        PGF.lastSearchEntryReset = time()
        PGF.searchResultIDInfo = {}
        PGF.numResultsBeforeFilter = 0
        PGF.numResultsAfterFilter = 0
    end
end

function PGF.GetUserSortingTable()
    local sorting = PGF.Dialog:GetSortingExpression()
    if PGF.Empty(sorting) then return {} end
    -- example string:  "friends asc, age desc , bar   desc , x"
    -- resulting sortTable = {
    --     [1] = { key = "friends", order = "asc" },
    --     [2] = { key = "age",     order = "desc" },
    --     [3] = { key = "bar",     order = "desc" },
    -- }
    local t = {}
    for k, v in string.gmatch(sorting, "(%w+)%s+(%w+),?") do
        table.insert(t, { key = k, order = v })
    end
    return t
end

function PGF.SortSearchResults(results)
    local sortTable = PGF.GetUserSortingTable()
    if sortTable and #sortTable > 0 then -- use custom sorting if defined
        table.sort(results, PGF.SortByExpression)
    elseif PGF.IsRetail() then -- use our extended useful sorting
        table.sort(results, PGF.SortByUsefulOrder)
    end
    -- else keep the existing sorting as Wrath clients have a pretty big
    -- intelligent sorting algorithm in LFGBrowseUtil_SortSearchResults
end

function PGF.SortByExpression(searchResultID1, searchResultID2)
    if not searchResultID1 or not searchResultID2 then return false end -- race condition

    -- look-up via table should be faster
    local info1 = PGF.searchResultIDInfo[searchResultID1]
    local info2 = PGF.searchResultIDInfo[searchResultID2]
    if not info1 or not info2 then return false end -- race condition

    local sortTable = PGF.GetUserSortingTable()
    for _, sort in ipairs(sortTable) do
        if info1.env[sort.key] ~= info2.env[sort.key] then -- works with unknown keys as 'nil ~= nil' is false (or 'nil == nil' is true)
            if sort.order == "desc" then
                if type(info1.env[sort.key]) == "boolean" then return info1.env[sort.key] end -- true before false
                return info1.env[sort.key] > info2.env[sort.key]
            else -- works with unknown 'v', in this case sort ascending by default
                if type(info1.env[sort.key]) == "boolean" then return info2.env[sort.key] end -- false before true
                return info1.env[sort.key] < info2.env[sort.key]
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
    if info1.env.apporder ~= info2.env.apporder then
        return info1.env.apporder > info2.env.apporder
    end

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
        -- appStatus flow:
        --   none ─┬─▶ applied ─┬─▶ invited ───┬─▶ inviteaccepted
        --         └─▶ failed   ├─▶ cancelled  └─▶ invitedeclined
        --                      ├─▶ declined
        --                      ├─▶ declined_delisted
        --                      ├─▶ declined_full
        --                      └─▶ timedout
        -- pendingStatus flow (used for role check if in a group before transition of appStatus to applied):
        --   <nil> ◀──▶ applied ──▶ cancelled
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
        env.harddeclined = PGF.IsHardDeclinedGroup(searchResultInfo)
        env.softdeclined = PGF.IsSoftDeclinedGroup(searchResultInfo)
        env.declined = env.harddeclined or env.softdeclined
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
        env.isapp = appStatus ~= "none" or pendingStatus or false
        env.apporder = env.isapp and resultID or 0 -- allows sorting applications to the top via `apporder desc`

        PGF.PutSearchResultMemberInfos(resultID, searchResultInfo, env)
        PGF.PutEncounterNames(resultID, env)

        if PGF.IsRetail() then -- changed a lot each expansion
            env.hasbr = env.druids > 0 or env.paladins > 0 or env.warlocks > 0 or env.deathknights > 0
            env.hasbl = env.shamans > 0 or env.evokers > 0 or env.hunters > 0 or env.mages > 0
            env.hashero = env.hasbl
            env.haslust = env.hasbl
            env.dispells = env.shamans + env.evokers +  env.priests + env.mages + env.paladins + env.monks + env.druids

            -- tier token filters
            env.dreadful = env.deathknights + env.warlocks +  env.demonhunters
            env.mystic = env.hunters + env.mages + env.druids
            env.venerated = env.shamans + env.priests + env.paladins
            env.zenith = env.warriors + env.evokers + env.monks + env.rogues
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
            local groupKey = PGF.GetGroupKey(searchResultInfo)
            -- group key can be nil if falling back to leaderName, which is nil at this point if the group is new
            if groupKey then PGF.currentSearchGroupKeys[groupKey] = true end
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
    local groupKey = PGF.GetGroupKey(searchResultInfo)
    -- try once again to update the group key if we had to fall back to the leaderName
    if groupKey then PGF.currentSearchGroupKeys[groupKey] = true end
    if not searchResultInfo.isDelisted then
        -- color name if new
        if PGF.currentSearchExpression ~= "true"                          -- not trivial search
        and PGF.currentSearchExpression == PGF.previousSearchExpression   -- and the same search
        and (groupKey and not PGF.previousSearchGroupKeys[groupKey]) then -- and group is new
            local color = C.COLOR_ENTRY_NEW
            self.Name:SetTextColor(color.R, color.G, color.B)
        end
        -- color name if declined
        if PGF.IsSoftDeclinedGroup(searchResultInfo) then
            local color = C.COLOR_ENTRY_DECLINED_SOFT
            self.Name:SetTextColor(color.R, color.G, color.B)
            self.PendingLabel:SetTextColor(color.R, color.G, color.B)
        end
        if PGF.IsHardDeclinedGroup(searchResultInfo) then
            local color = C.COLOR_ENTRY_DECLINED_HARD
            self.Name:SetTextColor(color.R, color.G, color.B)
            self.PendingLabel:SetTextColor(color.R, color.G, color.B)
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
    --self.Name:SetText("r:"..self.resultID .. " a:"..select(2, C_LFGList.GetApplicationInfo(self.resultID)).." "..self.Name:GetText())
    PGF.ColorGroupTexts(self, searchResultInfo)
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
