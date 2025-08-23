-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2025 Bernhard Saumweber
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

function PGF.Table_Invert(tbl)
    local inverted = {}
    for key, value in pairs(tbl) do
        inverted[value] = key
    end
    return inverted
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

-- Removes any text enclosed in common ASCII and CJK brackets
function PGF.String_RemoveBrackets(str)
    local patterns = {
        "%b()", "%b[]", "%b{}", "%b<>",
        "（.-）", "【.-】", "〔.-〕", "〈.-〉", "《.-》",
        "「.-」", "『.-』", "〖.-〗", "〘.-〙", "〚.-〛", "［.-］"
    }
    local changed = true
    while changed do
        changed = false
        local before = str
        for _, p in ipairs(patterns) do
            -- remove the bracketed chunk and any immediate leading whitespace
            str = str:gsub("%s*" .. p, "")
        end
        if str ~= before then changed = true end
    end

    -- normalize leftover whitespace
    str = str:gsub("%s%s+", " ")
        :gsub("^%s+", "")
        :gsub("%s+$", "")

    return str
end

function PGF.String_Tokenize(str, filter)
    -- normalize the string and remove ASCII and CJK punctuation
    lstr = str:lower():gsub("['＇]", ""):gsub("[:：%-－]", " ")
    local words = {}
    for w in lstr:gmatch("%S+") do
        if filter == nil or filter(w) then
            words[#words + 1] = w
        end
    end
    return words
end

function PGF.JaccardIndex(a, b)
    local setA, setB = {}, {}
    for _, w in ipairs(a) do setA[w] = true end
    for _, w in ipairs(b) do setB[w] = true end

    local intersection = 0
    local union = {}

    for w in pairs(setA) do
        union[w] = true
        if setB[w] then
            intersection = intersection + 1
        end
    end
    for w in pairs(setB) do
        union[w] = true
    end

    local unionSize = 0
    for _ in pairs(union) do unionSize = unionSize + 1 end

    if unionSize == 0 then return 0 end
    return intersection / unionSize
end

-- Find out if two slightly different instance names are actually referring to the same instance.
-- Instances are not names consistently across the game: sometimes an article is prepended or it has a suffix in parens.
-- This function tokenizes the names and calculates the Jaccard index of the two names.
--
-- Examples:
-- "Wasserwerke"                  vs. "Die Wasserwerke"
-- "Die Blutigen Tiefen"          vs. "Blutige Tiefen (Mythischer Schlüsselstein)"
-- "Tazavesh: Wundersame Straßen" vs. "Tazavesh: Straßen (Mythischer Schlüsselstein)"
-- "Der Smaragdgrüne Alptraum"    vs. "Der Smaragdgrüne Alptraum (Mythisch)"
function PGF.IsMostLikelySameInstance(name1, name2)
    if name1 == name2 then return true end

    -- try to remove brackets
    local normalized1 = PGF.String_RemoveBrackets(name1)
    local normalized2 = PGF.String_RemoveBrackets(name2)
    if normalized1 == normalized2 then return true end

    -- calculate similarity
    local isNotArticle = function (str)
        return str:match("^(the|die|der|das|il|el|la|le)$") == nil
    end
    local tokens1 = PGF.String_Tokenize(normalized1, isNotArticle)
    local tokens2 = PGF.String_Tokenize(normalized2, isNotArticle)
    local jaccardIndex = PGF.JaccardIndex(tokens1, tokens2)
    return jaccardIndex >= 0.5, jaccardIndex
end
