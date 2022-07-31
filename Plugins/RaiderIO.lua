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
function PGF.PutRaiderIOMetrics(env, leaderName)
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
        if RaiderIO.GetProfile then
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
                if result.raidProfile.progress and type(result.raidProfile.progress) == "table" then
                    for _, progress in pairs(result.raidProfile.progress) do
                        if progress.difficulty == 1 then
                            env.rionormalprogress = progress.progressCount
                            env.rionormalkills = progress.killsPerBoss
                        elseif progress.difficulty == 2 then
                            env.rioheroicprogress = progress.progressCount
                            env.rioheroickills = progress.killsPerBoss
                        elseif progress.difficulty == 3 then
                            env.riomythicprogress = progress.progressCount
                            env.riomythickills = progress.killsPerBoss
                        end
                    end
                end
            end
        elseif RaiderIO.GetPlayerProfile then
            -- old API
            local result = RaiderIO.GetPlayerProfile(RaiderIO.ProfileOutput.DATA, leaderName)
            if result and type(result) == "table" then
                for _, data in pairs(result) do
                    if data and data.dataType == RaiderIO.DataProvider.MYTHICPLUS and data.profile then
                        env.hasrio       = true
                        env.norio        = false
                        env.rio          = data.profile.mplusCurrent and data.profile.mplusCurrent.score or 0
                        env.rioprev      = data.profile.mplusPrevious and data.profile.mplusPrevious.score or 0
                        env.riomain      = data.profile.mplusMainCurrent and data.profile.mplusMainCurrent.score or 0
                        env.riomainprev  = data.profile.mplusMainPrevious and data.profile.mplusMainPrevious.score or 0
                        env.riokey5plus  = data.profile.keystoneFivePlus or 0
                        env.riokey10plus = data.profile.keystoneTenPlus or 0
                        env.riokey15plus = data.profile.keystoneFifteenPlus or 0
                        env.riokey20plus = data.profile.keystoneTwentyPlus or 0
                        env.riokeymax    = data.profile.maxDungeonLevel or 0
                    end
                    if data and data.dataType == RaiderIO.DataProvider.RAIDING and data.profile then
                        if data.profile.currentRaid then
                            env.rioraidbosscount = data.profile.currentRaid.bossCount
                        end
                        if data.profile.mainProgress and type(data.profile.mainProgress) == "table" then
                            for _, mainProgress in pairs(data.profile.mainProgress) do
                                env.riomainprogress = math.max(env.riomainprogress, mainProgress.progressCount)
                            end
                        end
                        if data.profile.progress and type(data.profile.progress) == "table" then
                            for _, progress in pairs(data.profile.progress) do
                                if progress.difficulty == 1 then
                                    env.rionormalprogress = progress.progressCount
                                    env.rionormalkills = progress.killsPerBoss
                                elseif progress.difficulty == 2 then
                                    env.rioheroicprogress = progress.progressCount
                                    env.rioheroickills = progress.killsPerBoss
                                elseif progress.difficulty == 3 then
                                    env.riomythicprogress = progress.progressCount
                                    env.riomythickills = progress.killsPerBoss
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
