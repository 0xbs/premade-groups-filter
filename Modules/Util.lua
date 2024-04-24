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
        lookupTable[subtrahend[i]] = true
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

function PGF.Table_Mean(tbl)
    local count = PGF.Table_Count(tbl)
    if count == 0 then return 0 end
    local total = 0
    for _, v in pairs(tbl) do total = total + tonumber(v) end
    return total / count
end

function PGF.Table_Median(tbl)
    local count = PGF.Table_Count(tbl)
    if count == 0 then return 0 end
    local keys = {}
    for k in pairs(tbl) do table.insert(keys, k) end
    table.sort(keys, function (a, b) return tbl[a] < tbl[b] end)
    if count % 2 == 0 then
        local m1 = tbl[keys[count / 2]]
        local m2 = tbl[keys[count / 2 + 1]]
        return (m1 + m2) / 2
    else
        return tbl[keys[(count + 1) / 2]]
    end
end

function PGF.IsMostLikelySameInstance(instanceName, activityName)
    -- instanceName is just the dungeon's name used in the lockout and challenge mode APIs, e.g. 'The Emerald Nightmare'
    local instanceNameLower = instanceName:lower()
    -- activityName has the difficulty in parens at the end, e.g. 'Emerald Nightmare (Heroic)'
    local activityNameWithoutDifficulty = string.gsub(activityName, "%s%([^)]+%)", ""):lower()

    -- more examples:
    -- instanceNameLower                  activityName
    -- "Die Blutigen Tiefen"          vs. "Blutige Tiefen (Mythischer Schlüsselstein)"
    -- "Tazavesh: Wundersame Straßen" vs. "Tazavesh: Straßen (Mythischer Schlüsselstein)"
    -- "Der Smaragdgrüne Alptraum"    vs. "Der Smaragdgrüne Alptraum (Mythisch)"

    -- check word by word if every word of the activityName is contained in the instanceName
    for token in string.gmatch(activityNameWithoutDifficulty, "[^%s]+") do
        if not string.find(instanceNameLower, token) then return false end
    end

    return true
end
