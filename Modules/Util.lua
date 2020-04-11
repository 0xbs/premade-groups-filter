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

function PGF.Table_UpdateWithDefaults(table, defaults)
    for k, v in pairs(defaults) do
        if type(v) == "table" then
            if table[k] == nil then table[k] = {} end
            PGF.Table_UpdateWithDefaults(table[k], v)
        else
            if table[k] == nil then table[k] = v end
        end
    end
end

function PGF.Table_Copy_Shallow(table)
    local copiedTable = {}
    for k, v in pairs(table) do
        copiedTable[k] = v
    end
    return copiedTable
end

function PGF.Table_Copy_Rec(original)
    local copy
    if type(original) == "table" then
        copy = {}
        for k, v in pairs(original) do
            copy[k] = PGF.Table_Copy_Rec(v)
        end
    else
        copy = original
    end
    return copy
end

function PGF.Table_Subtract(minuend, subtrahend)
    local difference = {}
    local lookupTable = {}
    for i = 1, #subtrahend do
        lookupTable[subtrahend[i]] = true;
    end
    for i = #minuend, 1, -1 do
        if not lookupTable[minuend[i]] then
            table.insert(difference, minuend[i])
        end
    end
    return difference
end

function PGF.Table_ValuesAsKeys(table)
    local result = {}
    if not table then return result end
    for _, val in pairs(table) do
        result[val] = true
    end
    return result
end

function PGF.Table_Count(table)
    local count = 0
    if not table then return count end
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function PGF.String_TrimWhitespace(str)
    return str:match("^%s*(.-)%s*$")
end

function PGF.String_ExtractNumbers(str)
    local numbers = {}
    for number in string.gmatch(str, "%d+") do
        table.insert(numbers, tonumber(number))
    end
    return numbers
end

function PGF.NotEmpty(value) return value and value ~= "" end
function PGF.Empty(value) return not PGF.NotEmpty(value) end
