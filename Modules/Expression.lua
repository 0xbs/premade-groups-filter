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

function PGF.HandleSyntaxError(error)
    PGF.StaticPopup_Show("PGF_ERROR_EXPRESSION", string.format(L["error.syntax"], error))
end

function PGF.HandleSemanticError(error)
    if error and (error:find("name") or error:find("comment") or error:find("findnumber")) then
        PGF.StaticPopup_Show("PGF_ERROR_EXPRESSION", string.format(L["error.semantic.protected"], error))
    else
        PGF.StaticPopup_Show("PGF_ERROR_EXPRESSION", string.format(L["error.semantic"], error))
    end
end

function PGF.DoesPassThroughFilter(env, exp)
    --local exp = "mythic and tansk < 0 and members==4"  -- raises semantic error
    --local exp = "and and tanks==0 and members==4"      -- raises syntax error
    --local exp = "mythic and tanks==0 and members==4"   -- correct statement
    local func, err = loadstring("return " .. exp)
    if err then
        PGF.HandleSyntaxError(err)
        return true -- do not filter in case of error
    end
    setfenv(func, env)
    local status, result = pcall(func)
    if status then
        if type(result) == "boolean" then
            return result -- successful execution
        else
            PGF.HandleSemanticError("expression did not evaluate to boolean, but to '" .. tostring(result) .. "' of type " .. type(result))
            return true -- do not filter in case of error
        end
    else
        PGF.HandleSemanticError(result)
        return true -- do not filter in case of error
    end
end
