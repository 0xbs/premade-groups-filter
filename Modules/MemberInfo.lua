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

C.ROLE_ATLAS = {
    ["TANK"] = "roleicon-tiny-tank",
    ["HEALER"] = "roleicon-tiny-healer",
    ["DAMAGER"] = "roleicon-tiny-dps",
}
C.LEADER_ATLAS = "groupfinder-icon-leader"

function PGF.GetSearchResultMemberInfoTable(resultID, numMembers)
    local members = {}
    for i = 1, numMembers do
        local role, class, classLocalized, specLocalized = C_LFGList.GetSearchResultMemberInfo(resultID, i)
        local classColor = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
        table.insert(members, {
            role = role,
            class = class,
            classLocalized = classLocalized,
            specLocalized = specLocalized,
            classColor = classColor,
            roleAtlas = C.ROLE_ATLAS[role],
            roleMarkup = string.format("|A:%s:0:0:0:0|a", C.ROLE_ATLAS[role]),
            isLeader = i == 1,
            leaderMarkup = i == 1 and string.format("|A:%s:10:12:0:0|a", C.LEADER_ATLAS) or "",
        })
    end
    -- sort reverse by role -> tank, heal, dps; then by class
    table.sort(members, function(a, b)
        if a.role ~= b.role then return b.role < a.role end
        return a.class < b.class
    end)
    return members
end
