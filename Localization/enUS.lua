-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2015 Elotheon-Arthas-EU
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

L["button.ok"] = "OK"
L["error.syntax"] = "|cffff0000Syntax error in filter expression|r\n\nThis means your filter expression is not built in the right way, e.g. there is a paranthesis missing or you wrote 'tanks=1' instead of 'tanks==1'.\n\nDetailed error message:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Semantic error in filter expression|r\n\nThis means your filter expression has correct syntax, but you most likely mispelled the name of a variable, e.g. tansk instead of tanks.\n\nDetailed error message:\n|cffaaaaaa%s|r"

L["dialog.reset"] = "Reset"
L["dialog.refresh"] = "Search"
L["dialog.expl.simple"] = "Activate checkbox, enter min and/or max and click Search."
L["dialog.expl.state"] = "Group should contain:"
L["dialog.expl.min"] = "min"
L["dialog.expl.max"] = "max"
L["dialog.expl.advanced"] = "If the options above are too limited, try an advanced expression query."
L["dialog.normal"] = "normal"
L["dialog.heroic"] = "heroic"
L["dialog.mythic"] = "mythic"
L["dialog.mythicplus"] = "mythic+"
L["dialog.to"] = "to"
L["dialog.difficulty"] = "Difficulty ......................"
L["dialog.members"]    = "Members ........................."
L["dialog.tanks"]      = "Tanks ..........................."
L["dialog.heals"]      = "Heals ..........................."
L["dialog.dps"]        = "DPS ............................."
L["dialog.ilvl"]       = "Item Level ......................"
L["dialog.noilvl"] = "or Item Level not specified"
L["dialog.defeated"] = "Bosses defeated (raids only)"
L["dialog.usepgf.tooltip"] = "Enable or disable Premade Groups Filter"
L["dialog.tooltip.title"] = "Advanced Filter Expressions"
L["dialog.tooltip.variable"] = "Variable"
L["dialog.tooltip.description"] = "Description"
L["dialog.tooltip.op.logic"] = "Logic Operators"
L["dialog.tooltip.op.number"] = "Number Operators"
L["dialog.tooltip.op.string"] = "String Operators"
L["dialog.tooltip.op.func"] = "Functions"
L["dialog.tooltip.findnumber"] = "filters numbers in descriptions"
L["dialog.tooltip.example"] = "Example"
L["dialog.tooltip.name"] = "name (big white text)"
L["dialog.tooltip.comment"] = "comment (gray text)"
L["dialog.tooltip.ilvl"] = "required item level"
L["dialog.tooltip.hlvl"] = "required honor level"
L["dialog.tooltip.defeated"] = "number of defeated raid bosses"
L["dialog.tooltip.members"] = "number of members"
L["dialog.tooltip.tanks"] = "number of tanks"
L["dialog.tooltip.heals"] = "number of healers"
L["dialog.tooltip.dps"] = "number of damage dealers"
L["dialog.tooltip.classes"] = "number of specific class"
L["dialog.tooltip.age"] = "age of group in minutes"
L["dialog.tooltip.voice"] = "has voice chat"
L["dialog.tooltip.myrealm"] = "leader is from my realm"
L["dialog.tooltip.noid"] = "instances where I don't have ID"
L["dialog.tooltip.matchingid"] = "groups with same killed bosses"
L["dialog.tooltip.seewebsite"] = "see website"
L["dialog.tooltip.difficulty"] = "difficulty"
L["dialog.tooltip.raids"] = "select only specific raid"
L["dialog.tooltip.dungeons"] = "select specific dungeon"
L["dialog.tooltip.arena"] = "select specific arena type"
L["dialog.tooltip.ex.parentheses"] = "(voice or not voice)"
L["dialog.tooltip.ex.not"] = "not myrealm"
L["dialog.tooltip.ex.and"] = "heroic and hfc"
L["dialog.tooltip.ex.or"] = "normal or heroic"
L["dialog.tooltip.ex.eq"] = "dps == 3"
L["dialog.tooltip.ex.neq"] = "members ~= 0"
L["dialog.tooltip.ex.lt"] = "hlvl >= 5"
L["dialog.tooltip.ex.find"] = "not name:find(\"wts\")"
L["dialog.tooltip.ex.match"] = "name:match(\"+(%d)\")==\"5\""
