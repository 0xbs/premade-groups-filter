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

L["addon.name.short"] = "PGF"
L["addon.name.long"] = "Premade Groups Filter"

L["error.syntax"] = "|cffff0000Syntax error in filter expression|r\n\nThis means your filter expression is not built in the right way, e.g. there is a paranthesis missing or you wrote 'tanks=1' instead of 'tanks==1'.\n\nDetailed error message:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Semantic error in filter expression|r\n\nThis means your filter expression has correct syntax, but you most likely mispelled the name of a variable, e.g. tansk instead of tanks.\n\nDetailed error message:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Semantic error in filter expression|r\n\nThe keywords 'name', 'comment' and 'findnumber' are no longer supported. Please remove them from your advanced filter expression or press the reset button.\n\nStarting with the Battle for Azeroth Prepatch, those value are protected by Blizzard and can no longer be evaluated by any addon.\n\nUse the default search bar above the group listing to filter for groups names.\n\nDetailed error message:\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "Premade Groups Filter: Will not apply fix for 'Interface action failed because of an AddOn' errors because you don't seem to have a fully secured account and otherwise can't create premade groups. See addon FAQ for more information and how to fix this issue."
L["message.settingsupgraded"] = "Premade Groups Filter: Migrated settings to version %s"

L["dialog.reset"] = "Reset"
L["dialog.reset.confirm"] = "Really reset all fields?"
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
L["dialog.difficulty"] = "Difficulty ........................."
L["dialog.members"]    = "Members ............................"
L["dialog.tanks"]      = "Tanks .............................."
L["dialog.heals"]      = "Heals .............................."
L["dialog.dps"]        = "DPS ................................"
L["dialog.mprating"]   = "M+ Rating .........................."
L["dialog.pvprating"]  = "PVP Rating ........................."
L["dialog.defeated"]   = "Raid bosses defeated"
L["dialog.sorting"] = "Sorting"
L["dialog.usepgf.tooltip"] = "Enable or disable Premade Groups Filter."
L["dialog.usepgf.usage"] = "To get maximum number of relevant results, use the search box together with PGF, as the number of results returned by the server is limited."
L["dialog.usepgf.results.server"] = "Groups sent by server: |cffffffff%d|r"
L["dialog.usepgf.results.removed"] = "Groups hidden by PGF: |cffffffff%d|r"
L["dialog.usepgf.results.displayed"] = "Groups displayed: |cffffffff%d|r"
L["dialog.tooltip.title"] = "Advanced Filter Expressions"
L["dialog.tooltip.variable"] = "Variable"
L["dialog.tooltip.description"] = "Description"
L["dialog.tooltip.op.logic"] = "Logic Operators"
L["dialog.tooltip.op.number"] = "Number Operators"
L["dialog.tooltip.op.string"] = "String Operators"
L["dialog.tooltip.op.func"] = "Functions"
L["dialog.tooltip.example"] = "Example"
L["dialog.tooltip.ilvl"] = "required item level"
L["dialog.tooltip.myilvl"] = "my item level"
L["dialog.tooltip.hlvl"] = "required honor level"
L["dialog.tooltip.pvprating"] = "PvP rating of group leader"
L["dialog.tooltip.mprating"] = "Mythic+ rating of group leader"
L["dialog.tooltip.defeated"] = "number of defeated raid bosses"
L["dialog.tooltip.members"] = "number of members"
L["dialog.tooltip.tanks"] = "number of tanks"
L["dialog.tooltip.heals"] = "number of healers"
L["dialog.tooltip.dps"] = "number of damage dealers"
L["dialog.tooltip.partyfit"] = "has spots for my party roles"
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
L["dialog.tooltip.timewalking"] = "select timewalking dungeon"
L["dialog.tooltip.arena"] = "select specific arena type"
L["dialog.tooltip.warmode"] = "warmode enabled"
L["dialog.copy.url.keywords"] = "Press CTRL+C to copy link to list of keywords"
L["dialog.filters.group"] = "Group"
L["dialog.filters.dungeons"] = "Dungeons"
L["dialog.filters.advanced"] = "Advanced Filter Expression"
L["dialog.partyfit"] = "Party Fit"
L["dialog.partyfit.tooltip"] = "Show only groups that still have slots for all your party members roles. Also works if you are alone."
L["dialog.notdeclined"] = "Not Declined"
L["dialog.notdeclined.tooltip"] = "Hide groups that declined you. Still shows groups where your application timed out."
L["dialog.blfit"] = "Bloodlust Fit"
L["dialog.blfit.tooltip"] = "If nobody in your group has bloodlust/heroism, show only groups that already have bloodlust/heroism, or after joining, there is still an open dps or healer slot. Also works if you are alone."
L["dialog.brfit"] = "Battle Res Fit"
L["dialog.brfit.tooltip"] = "If nobody in your group has a battle rezz, show only groups that already have a battle rezz, or after joining, there is still an open slot. Also works if you are alone."
L["dialog.matchingid"] = "Matching ID"
L["dialog.matchingid.tooltip"] = "Show only groups that have the exact same instance lockout than yourself. Always shows all groups where you not have lockout at all."

L["settings.dialogMovable.title"] = "Dialog Movable"
L["settings.dialogMovable.tooltip"] = "Allows you to move the dialog with the mouse. Right-click resets the position."
L["settings.classNamesInTooltip.title"] = "Class Names in Tooltip"
L["settings.classNamesInTooltip.tooltip"] = "Shows a list of classes by role in the tooltip of a premade group."
L["settings.coloredGroupTexts.title"] = "Colored Group Name"
L["settings.coloredGroupTexts.tooltip"] = "Shows group name in green if group is new and in red if you've previously been declined. Shows activity name in red if you have a lockout on that instance."
L["settings.classBar.title"] = "Bar in Class Color"
L["settings.classBar.tooltip"] = "Shows a small bar in class color below each role in the premade dungeon group list."
L["settings.classCircle.title"] = "Circle in Class Color"
L["settings.classCircle.tooltip"] = "Shows a circle in class color in the background of each role in the premade dungeon group list."
L["settings.leaderCrown.title"] = "Show Group Leader"
L["settings.leaderCrown.tooltip"] = "Shows a small crown above the group leader's role in the premade dungeon group list."
L["settings.ratingInfo.title"] = "Group Leader Rating"
L["settings.ratingInfo.tooltip"] = "Shows the Mythic+ or PvP rating of the group leader in the premade group list."
L["settings.oneClickSignUp.title"] = "One Click Sign Up"
L["settings.oneClickSignUp.tooltip"] = "Sign up for a group directly by clicking on it, instead of selecting it first, then clicking sign up."
L["settings.persistSignUpNote.title"] = "Persist Sign Up Note"
L["settings.persistSignUpNote.tooltip"] = "Persists the 'note to the group leader' when signing up to different groups. By default, the note is deleted when a new group is selected."
L["settings.signupOnEnter.title"] = "Sign Up On Enter"
L["settings.signupOnEnter.tooltip"] = "Automatically focus the 'note to the group leader' text box when signing up for a new group and confirm your application by pressing enter."
L["settings.skipSignUpDialog.title"] = "Skip Sign Up Dialog"
L["settings.skipSignUpDialog.tooltip"] = "Skip the role and note prompt if possible and immediately sign up to the group. Hold shift to always show the dialog."
L["settings.coloredApplications.title"] = "Colored Applications"
L["settings.coloredApplications.tooltip"] = "Shows a red background on pending applications for Mythic+ groups if the group has no slot left for your role."
