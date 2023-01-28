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

-- TEST FILE
-- Run with: lua5.1 MainTest.lua

-- Define mocks for global functions
time = os.time
hooksecurefunc = function(name) end
GetSpecializationRole = function(spec) return "TANK" end
GetSpecialization = function() return { [1] = 3 } end
C_LFGList = {}
C_LFGList.GetApplicationInfo = function(resultID)
    if resultID == nil then error("resultID is nil") end
    if resultID == 300 then return resultID, "applied", nil, 250 end
    if resultID == 301 then return resultID, "declined", nil, 100 end
    if resultID == 302 then return resultID, "invited", nil, 200 end
    if resultID == 303 then return resultID, nil, nil, 0 end
    return resultID, "none", nil, 0
end
C_LFGList.GetSearchResultMemberCounts = function()
    return {
        ["TANK_REMAINING"] = 1,
        ["HEALER_REMAINING"] = 1,
        ["DAMAGER_REMAINING"] = 2,
    }
end
C_LFGList.GetSearchResultInfo = function(searchResultID)
    return {
        ["numBNetFriends"] = 0,
        ["numCharFriends"] = 0,
        ["numGuildMates"] = 0,
        ["isWarMode"] = 0,
        ["age"] = 10,
    }
end

-- Prepare test environment
local PGF = {}
assert(loadfile("Main.lua"))("Premade Groups Filter", PGF)

-- Define tests
local Tests = {
    SortByFriendsAndAge_Equal = function()
        local result = PGF.SortByFriendsAndAge(100, 101)
        assert(result == false)
    end,

    SortByFriendsAndAge_FirstNil = function()
        local result = PGF.SortByFriendsAndAge(nil, 101)
        assert(result == false)
    end,

    SortByFriendsAndAge_SecondNil = function()
        local result = PGF.SortByFriendsAndAge(100, nil)
        assert(result == false)
    end,

    SortByFriendsAndAge_BothNil = function()
        local result = PGF.SortByFriendsAndAge(nil, nil)
        assert(result == false)
    end,

    SortByFriendsAndAge_Table = function()
        local results = { nil, 300, 100, 302, nil, 301, 303, nil }
        table.sort(results, PGF.SortByFriendsAndAge)
        --for i = 1, #results do print(results[i]) end
        assert(results[1] == nil)
        assert(results[2] == nil)
        assert(results[3] == 301)
        assert(results[4] == 302)
        assert(results[5] == 300)
        assert(results[6] == 100)
        assert(results[7] == 303)
    end,
}

-- Run Tests
print("--- TESTS START ---")
local pass, total = 0, 0
for k, test in pairs(Tests) do
    local ok, err = pcall(test)
    if ok then
        pass = pass + 1
        print(string.format("\27[32mOK  \27[0m %-50s", k))
    else
        print(string.format("\27[31mFAIL\27[0m %-50s\n\t%s", k, err))
    end
    total = total + 1
end
print(string.format("%d total, %d pass, %d fail", pass, total, total- pass))
print("--- TESTS END ---")
