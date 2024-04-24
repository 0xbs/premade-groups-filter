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

function PGF.GetNameRealmFaction(leaderName)
    local name, realm, faction
    local factionMapping = {
        ["Alliance"] = 1,
        ["Horde"] = 2
    }

    if leaderName:find("-", nil, true) then
        name, realm = ("-"):split(leaderName)
    else
        name = leaderName
    end
    if not realm or realm == "" then
        realm = GetNormalizedRealmName()
    end

    faction = factionMapping[UnitFactionGroup("player")]

    return name, realm, faction
end

--- Fetches Raider.IO metrics if installed and provides them in the filter environment
--- @generic V
--- @param env table<string, V> environment to be prepared
--- @param leaderName string name of the group leader
function PGF.PutRaiderIOMetrics(env, leaderName, activityID)
    env.hasrio            = false
    env.norio             = true
    env.rio               = 0
    env.rioprev           = 0
    env.riomain           = 0
    env.riomainprev       = 0
    env.riokey5plus       = 0
    env.riokey10plus      = 0
    env.riokey15plus      = 0
    env.riokey20plus      = 0
    env.riokeymax         = 0
    env.rionormalprogress = 0
    env.rioheroicprogress = 0
    env.riomythicprogress = 0
    env.riomainprogress   = 0
    env.rionormalkills    = {}
    env.rioheroickills    = {}
    env.riomythickills    = {}
    env.rioraidbosscount  = 0
    setmetatable(env.rionormalkills, { __index = function() return 0 end })
    setmetatable(env.rioheroickills, { __index = function() return 0 end })
    setmetatable(env.riomythickills, { __index = function() return 0 end })
    if leaderName and RaiderIO and RaiderIO.GetProfile then
        -- new API
        local name, realm = PGF.GetNameRealmFaction(leaderName)
        local result = RaiderIO.GetProfile(name, realm)
        if not result and type(result) ~= "table" then
            return
        end
        env.hasrio = true
        env.norio = false
        if result.mythicKeystoneProfile then
            local p = result.mythicKeystoneProfile
            env.rio          = p.mplusCurrent and p.mplusCurrent.score or 0
            env.rioprev      = p.mplusPrevious and p.mplusPrevious.score or 0
            env.riomain      = p.mplusMainCurrent and p.mplusMainCurrent.score or 0
            env.riomainprev  = p.mplusMainPrevious and p.mplusMainPrevious.score or 0
            env.riokey5plus  = p.keystoneFivePlus or 0
            env.riokey10plus = p.keystoneTenPlus or 0
            env.riokey15plus = p.keystoneFifteenPlus or 0
            env.riokey20plus = p.keystoneTwentyPlus or 0
            env.riokeymax    = p.maxDungeonLevel or 0
        end
        if result.raidProfile then
            if result.raidProfile.currentRaid then
                env.rioraidbosscount = result.raidProfile.currentRaid.bossCount
            end
            if result.raidProfile.mainProgress and type(result.raidProfile.mainProgress) == "table" then
                for _, mainProgress in pairs(result.raidProfile.mainProgress) do
                    env.riomainprogress = math.max(env.riomainprogress, mainProgress.progressCount)
                end
            end

            --DevTools_Dump(result.raidProfile.progress)
            -- result.raidProfile.progress[i].difficulty     -- int
            -- result.raidProfile.progress[i].progressCount  -- itable<int, int>
            -- result.raidProfile.progress[i].killsPerBoss   -- int
            -- result.raidProfile.progress[i].raid           -- table<string, ?>
            -- result.raidProfile.progress[i].raid.mapId     -- int                 -- 2522 2569
            -- result.raidProfile.progress[i].raid.shortName -- string              -- VOTI ATSC
            -- result.raidProfile.progress[i].raid.name      -- string
            -- result.raidProfile.progress[i].raid.bossCount -- int
            -- result.raidProfile.progress[i].raid.id        -- int
            -- result.raidProfile.progress[i].raid.ordinal   -- int

            local mapID = C.ACTIVITY[activityID].mapID
            if result.raidProfile.progress and type(result.raidProfile.progress) == "table" then
                for _, progress in pairs(result.raidProfile.progress) do
                    if mapID and progress.raid and mapID == progress.raid.mapId then
                        if progress.difficulty == 1 then
                            env.rionormalprogress = progress.progressCount
                            for i, k in ipairs(progress.killsPerBoss) do
                                env.rionormalkills[i] = k
                            end
                        elseif progress.difficulty == 2 then
                            env.rioheroicprogress = progress.progressCount
                            for i, k in ipairs(progress.killsPerBoss) do
                                env.rioheroickills[i] = k
                            end
                        elseif progress.difficulty == 3 then
                            env.riomythicprogress = progress.progressCount
                            for i, k in ipairs(progress.killsPerBoss) do
                                env.riomythickills[i] = k
                            end
                        end
                    end
                end
            end
        end
    end
end
