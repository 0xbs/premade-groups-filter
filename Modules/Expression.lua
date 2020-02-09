-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2020 Elotheon-Arthas-EU
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

StaticPopupDialogs["PGF_ERRORPOPUP"] = {
    text = "%s",
    button1 = L["button.ok"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

function PGF.HandleSyntaxError(error)
    StaticPopup_Show("PGF_ERRORPOPUP", string.format(L["error.syntax"], error))
end

function PGF.HandleSemanticError(error)
    if error and (error:find("name") or error:find("comment") or error:find("findnumber")) then
        StaticPopup_Show("PGF_ERRORPOPUP", string.format(L["error.semantic.protected"], error))
    else
        StaticPopup_Show("PGF_ERRORPOPUP", string.format(L["error.semantic"], error))
    end
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
