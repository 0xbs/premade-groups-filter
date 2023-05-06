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

local roleRemainingKeyLookup = {
    ["TANK"] = "TANK_REMAINING",
    ["HEALER"] = "HEALER_REMAINING",
    ["DAMAGER"] = "DAMAGER_REMAINING",
}

function PGF.HasRemainingSlotsForLocalPlayerRole(memberCounts)
    local playerRole = GetSpecializationRole(GetSpecialization())
    return memberCounts[roleRemainingKeyLookup[playerRole]] > 0
end

function PGF.HasRemainingSlotsForLocalPlayerPartyRoles(memberCounts)
    local numGroupMembers = GetNumGroupMembers()
    local groupType = IsInRaid() and "raid" or "party"

    if numGroupMembers == 0 then
        -- not in a group
        return PGF.HasRemainingSlotsForLocalPlayerRole(memberCounts)
    end

    local partyRoles = { ["TANK"] = 0, ["HEALER"] = 0, ["DAMAGER"] = 0 }

    for i = 1, numGroupMembers do
        local unit = (i == 1) and "player" or (groupType .. (i - 1))

        local groupMemberRole = UnitGroupRolesAssigned(unit)
        if groupMemberRole == "NONE" then groupMemberRole = "DAMAGER" end

        partyRoles[groupMemberRole] = partyRoles[groupMemberRole] + 1
    end

    for role, remainingKey in pairs(roleRemainingKeyLookup) do
        if memberCounts[remainingKey] < partyRoles[role] then
            return false
        end
    end

    return true
end

function PGF.GetMemberCountsAfterJoin(memberCounts)
    local memberCountsAfterJoin = PGF.Table_Copy_Shallow(memberCounts)
    local groupType = IsInRaid() and "raid" or "party"
    local numGroupMembers = GetNumGroupMembers()
    -- not in group
    if numGroupMembers == 0 then
        local role = GetSpecializationRole(GetSpecialization())
        local roleRemaining = roleRemainingKeyLookup[role]
        memberCountsAfterJoin[role] = (memberCountsAfterJoin[role] or 0) + 1
        memberCountsAfterJoin[roleRemaining] = (memberCountsAfterJoin[roleRemaining] or 0) - 1
        return memberCountsAfterJoin
    end
    -- in group
    for i = 1, numGroupMembers do
        local unit = (i == 1) and "player" or (groupType .. (i - 1))
        local role = UnitGroupRolesAssigned(unit)
        if role == "NONE" then role = "DAMAGER" end
        local roleRemaining = roleRemainingKeyLookup[role]
        memberCountsAfterJoin[role] = (memberCountsAfterJoin[role] or 0) + 1
        memberCountsAfterJoin[roleRemaining] = (memberCountsAfterJoin[roleRemaining] or 0) - 1
    end
    return memberCountsAfterJoin
end

function PGF.HasRemainingSlotsForBloodlustAfterJoin(memberCounts)
    local memberCountsAfterJoin = PGF.GetMemberCountsAfterJoin(memberCounts)
    return memberCountsAfterJoin.HEALER_REMAINING > 0 or
            memberCountsAfterJoin.DAMAGER_REMAINING > 0
end

function PGF.HasRemainingSlotsForBattleRezzAfterJoin(memberCounts)
    local memberCountsAfterJoin = PGF.GetMemberCountsAfterJoin(memberCounts)
    return memberCountsAfterJoin.HEALER_REMAINING > 0 or
            memberCountsAfterJoin.DAMAGER_REMAINING > 0 or
            memberCountsAfterJoin.TANK_REMAINING > 0
end

function PGF.UnitHasProperty(unit, prop)
    local class = select(2, UnitClass(unit)) -- MAGE, WARRIOR, ...
    return C.DPS_CLASS_TYPE[class][prop]
end

function PGF.PlayerOrGroupHasProperty(prop)
    local numGroupMembers = GetNumGroupMembers()
    if numGroupMembers == 0 then
        return PGF.UnitHasProperty("player", prop)
    end
    local groupType = IsInRaid() and "raid" or "party"
    for i = 1, numGroupMembers do
        local unit = (i == 1) and "player" or (groupType .. (i - 1))
        if PGF.UnitHasProperty(unit, prop) then
            return true
        end
    end
    return false
end

function PGF.PlayerOrGroupHasBloodlust()
    return PGF.PlayerOrGroupHasProperty("bl")
end

function PGF.PlayerOrGroupHasBattleRezz()
    return PGF.PlayerOrGroupHasProperty("br")
end
