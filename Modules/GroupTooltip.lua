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

local function AddMemberNames(tooltip, resultID, searchResultInfo)
    local names = {}
    local colors = {}
    local hasNames = false
    for i = 1, searchResultInfo.numMembers do
        local playerInfo = PGF.GetSearchResultPlayerInfo(resultID, i)
        names[i] = playerInfo.name
        colors[i] = RAID_CLASS_COLORS[playerInfo.classFilename] or NORMAL_FONT_COLOR
        hasNames = hasNames or playerInfo.name ~= nil
    end
    if not hasNames then return end

    local tooltipName = tooltip:GetName()
    local membersLine
    for i = 1, tooltip:NumLines() do
        local left = _G[tooltipName .. "TextLeft" .. i]
        if left and left:GetText() == MEMBERS_COLON then
            membersLine = i
            break
        end
    end
    if not membersLine then return end

    for i = 1, searchResultInfo.numMembers do
        if names[i] then
            local right = _G[tooltipName .. "TextRight" .. (membersLine + i)]
            right:SetText(names[i])
            right:SetTextColor(colors[i].r, colors[i].g, colors[i].b)
            right:Show()
        end
    end
end

function PGF.AddClassSpecListing(tooltip, resultID, searchResultInfo)
    tooltip:AddLine(" ")
    tooltip:AddLine(CLASS_ROLES)

    local members = PGF.GetSearchResultMemberInfoTable(resultID, searchResultInfo.numMembers)
    for _, m in pairs(members) do
        local roleClassSpec
        if m.specLocalized and m.specLocalized ~= "" then -- no real specs in classic editions
            roleClassSpec = string.format("%s %s - %s %s %s", m.roleMarkup, m.classLocalized, m.specLocalized, m.leaderMarkup, m.leaverMarkup)
        else
            roleClassSpec = string.format("%s %s %s", m.roleMarkup, m.classLocalized, m.leaderMarkup)
        end
        tooltip:AddLine(roleClassSpec, m.classColor.r, m.classColor.g, m.classColor.b)
    end
end

function PGF.AddClassCountListing(tooltip, resultID, searchResultInfo)
    tooltip:AddLine(" ")
    tooltip:AddLine(CLASS_ROLES)

    local roles = {}
    local classInfo = {}
    for i = 1, searchResultInfo.numMembers do
        local playerInfo = PGF.GetSearchResultPlayerInfo(resultID, i)
        local role = playerInfo.assignedRole
        local class = playerInfo.classFilename
        if role and class then -- can be nil, see #297
            classInfo[class] = {
                name = playerInfo.className or "?",
                color = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
            }
            if not roles[role] then roles[role] = {} end
            if not roles[role][class] then roles[role][class] = 0 end
            roles[role][class] = roles[role][class] + 1
        end
    end

    for role, classes in pairs(roles) do
        tooltip:AddLine(_G[role]..": ")
        for class, count in pairs(classes) do
            local text = "   "
            if count > 1 then text = text .. count .. " " else text = text .. "   " end
            text = text .. "|c" .. classInfo[class].color.colorStr ..  classInfo[class].name .. "|r "
            tooltip:AddLine(text)
        end
    end
end

function PGF.OnLFGListUtilSetSearchEntryTooltip(tooltip, resultID, autoAcceptOption)
    if not PremadeGroupsFilterSettings.classNamesInTooltip then return end

    local searchResultInfo = PGF.GetSearchResultInfo(resultID)
    if not searchResultInfo then return end
    local activityID = PGF.GetSearchResultActivityID(searchResultInfo)
    if not activityID then return end
    local activityInfo = PGF.GetActivityInfoTable(activityID)
    if not activityInfo then return end

    -- RoleCount       Raids, BGs, Custom Groups
    -- RoleEnumerate   Dungeons
    -- ClassEnumerate  Arena
    -- HideAll         ?
    -- PlayerCount     Quests
    -- Comment         ?

    if searchResultInfo.isDelisted or not tooltip:IsShown() then return end

    if activityInfo.displayType == Enum.LFGListDisplayType.RoleEnumerate or
            activityInfo.displayType == Enum.LFGListDisplayType.ClassEnumerate then
        AddMemberNames(tooltip, resultID, searchResultInfo)
    end

    -- do not add a second member listing where Blizzard already shows it
    if activityInfo.displayType == Enum.LFGListDisplayType.ClassEnumerate then return end

    -- restore age dropped in 10.2.7
    if searchResultInfo.age > 0 then
        tooltip:AddLine(" ")
        tooltip:AddLine(string.format(LFG_LIST_TOOLTIP_AGE, SecondsToTime(searchResultInfo.age, false, false, 1, false)));
    end

    if activityInfo.displayType ~= Enum.LFGListDisplayType.ClassEnumerate and
            activityInfo.displayType ~= Enum.LFGListDisplayType.RoleEnumerate then
        PGF.AddClassCountListing(tooltip, resultID, searchResultInfo)
    elseif not PGF.IsRetail() then -- retail has spec enumeration since 10.2.7
        PGF.AddClassSpecListing(tooltip, resultID, searchResultInfo)
    end
    tooltip:Show()
end

hooksecurefunc("LFGListUtil_SetSearchEntryTooltip", PGF.OnLFGListUtilSetSearchEntryTooltip)
