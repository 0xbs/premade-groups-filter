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

--- Sets member info keyword values based on the search result info
function PGF.PutSearchResultMemberInfos(resultID, searchResultInfo, env)
    -- init to zero
    env.ranged = 0
    env.melees = 0
    local specs = PGF.GetAllSpecializations()
    for specID, specInfo in pairs(specs) do
        env[specInfo.specKeyword] = 0
        env[specInfo.classKeyword] = 0
        env[specInfo.roleClassKeyword] = 0
        env[specInfo.classRoleKeyword] = 0
        env[specInfo.armor] = 0
    end

    -- increment keywords
    for i = 1, searchResultInfo.numMembers do
        local role, class, classLocalized, specLocalized = C_LFGList.GetSearchResultMemberInfo(resultID, i)
        local specInfo = PGF.GetSpecializationInfoByLocalizedName(class, specLocalized)
        if specInfo then
            if specInfo.role == "DAMAGER" then
                env.ranged = env.ranged + (specInfo.range and 1 or 0)
                env.melees = env.melees + (specInfo.melee and 1 or 0)
            end
            env[specInfo.specKeyword] = env[specInfo.specKeyword] + 1
            env[specInfo.classKeyword] = env[specInfo.classKeyword] + 1
            env[specInfo.roleClassKeyword] = env[specInfo.roleClassKeyword] + 1
            env[specInfo.classRoleKeyword] = env[specInfo.classRoleKeyword] + 1
            env[specInfo.armor] = env[specInfo.armor] + 1
        end
    end

    -- set aliases
    env.augs = env.augmentation_evokers
    env.discs = env.discipline_priests
    env.ranged_strict = env.ranged
    env.melees_strict = env.melees
end

function PGF.GetSearchResultMemberInfoTable(resultID, numMembers)
    local members = {}
    for i = 1, numMembers do
        local role, class, classLocalized, specLocalized, isLeader = C_LFGList.GetSearchResultMemberInfo(resultID, i)
        local specInfo = PGF.GetSpecializationInfoByLocalizedName(class, specLocalized)
        if specInfo then
            local memberInfo = PGF.Table_Copy_Shallow(specInfo)
            memberInfo.isLeader = isLeader
            memberInfo.leaderMarkup = isLeader and string.format("|A:%s:10:12:0:0|a", C.LEADER_ATLAS) or ""
            table.insert(members, memberInfo)
        end
    end
    -- sort reverse by role -> tank, heal, dps; then by class
    table.sort(members, function(a, b)
        if a.role ~= b.role then return b.role < a.role end
        return a.class < b.class
    end)
    return members
end
