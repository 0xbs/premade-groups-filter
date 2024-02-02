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

--- Ensures that all class-role/role-class and ranged/melees keywords are initialized to zero in the filter environment,
--- because the values would cause a semantic error otherwise (because they do not exist)
--- @generic V
--- @param env table<string, V> environment to be prepared
local function InitClassRoleTypeKeywords(env)
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

--- Initializes all class-role/role-class and ranged/melees keywords and increments them to their correct value
--- @generic V
--- @param resultID number search result identifier
--- @param searchResultInfo table<string, V> search result info from API
--- @param env table<string, V> environment to be prepared
function PGF.PutSearchResultMemberInfos(resultID, searchResultInfo, env)
    InitClassRoleTypeKeywords(env)
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