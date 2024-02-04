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

--- Sets member info keyword values based on the search result info
function PGF.PutSearchResultMemberInfos(resultID, searchResultInfo, env)
    -- init to zero
    env.ranged = 0
    env.ranged_strict = 0
    env.melees = 0
    env.melees_strict = 0
    for class, classInfo in pairs(C.DPS_CLASS_TYPE) do
        local classKeyword = class:lower() .. "s"
        env[classKeyword] = 0
        env[classInfo.armor] = 0
        for role, prefix in pairs(C.ROLE_PREFIX) do
            local classRoleKeyword = prefix .. "_" .. classKeyword
            local roleClassKeyword = class:lower() .. "_" .. C.ROLE_SUFFIX[role]
            env[classRoleKeyword] = 0
            env[roleClassKeyword] = 0
        end
    end

    -- increment keywords
    for i = 1, searchResultInfo.numMembers do
        local role, class = C_LFGList.GetSearchResultMemberInfo(resultID, i)
        local classKeyword = class:lower() .. "s" -- plural form of the class in english
        env[classKeyword] = env[classKeyword] + 1
        local armor = C.DPS_CLASS_TYPE[class].armor
        if armor then
            env[armor] = env[armor] + 1
        end
        if role then
            local classRoleKeyword = C.ROLE_PREFIX[role] .. "_" .. classKeyword
            local roleClassKeyword = class:lower() .. "_" .. C.ROLE_SUFFIX[role]
            env[classRoleKeyword] = env[classRoleKeyword] + 1
            env[roleClassKeyword] = env[roleClassKeyword] + 1
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
