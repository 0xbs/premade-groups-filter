-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2026 Bernhard Saumweber
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

local AGE_COLOR_NEW_SECONDS = 60
local AGE_COLOR_OLD_SECONDS = 15 * 60
local AGE_COLOR_OLD = CreateColor(0.5, 0.5, 0.5)

local function GetAgeColor(age)
    local ageRange = AGE_COLOR_OLD_SECONDS - AGE_COLOR_NEW_SECONDS
    local ratio = math.min(math.max((age - AGE_COLOR_NEW_SECONDS) / ageRange, 0), 1)
    local newColor = C.COLOR_ENTRY_NEW
    local oldColor = AGE_COLOR_OLD
    return CreateColor(
        newColor.R + (oldColor.r - newColor.R) * ratio,
        newColor.G + (oldColor.g - newColor.G) * ratio,
        newColor.B + (oldColor.b - newColor.B) * ratio
    )
end

function PGF.AddGroupAge(self, searchResultInfo)
    if not PremadeGroupsFilterSettings.groupAge then return end
    if not searchResultInfo or not searchResultInfo.age or searchResultInfo.age == 0 then return end

    local ageSecs = searchResultInfo.age
    local ageMins = math.floor(ageSecs / 60)
    local ageStr = ""
    local ageColor = GetAgeColor(ageSecs)

    if ageMins >= 60 then
        local hours = math.floor(ageMins / 60)
        local mins = ageMins % 60
        ageStr = hours .. "h " .. mins .. "m"
    elseif ageMins > 0 then
        ageStr = ageMins .. "m"
    else
        ageStr = "<1m"
        --ageStr = ageSecs .. "s"
    end

    local coloredAge = ageColor:WrapTextInColorCode(ageStr)
    local currentText = self.Playstyle:GetText() or ""
    if currentText ~= "" then
        self.Playstyle:SetText(coloredAge .. " - " .. currentText)
    else
        self.Playstyle:SetText(coloredAge)
    end
end
