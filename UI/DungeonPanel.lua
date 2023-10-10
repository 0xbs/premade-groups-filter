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

local DIFFICULTY_TEXT = {
    [1] = { key = C.NORMAL,     title = L["dialog.normal"] },
    [2] = { key = C.HEROIC,     title = L["dialog.heroic"] },
    [3] = { key = C.MYTHIC,     title = L["dialog.mythic"] },
    [4] = { key = C.MYTHICPLUS, title = L["dialog.mythicplus"] },
}

local SEASON_DUNGEONS = {
    -- Dragonflight Season 2
    [1] = { activityID = 1164, mapID = 405, keyword = "bh" },   -- Brackenhide Hollow
    [2] = { activityID = 1168, mapID = 406, keyword = "hoi" },  -- Halls of Infusion
    [3] = { activityID = 1172, mapID = 404, keyword = "nelt" }, -- Neltharus
    [4] = { activityID = 1188, mapID = 403, keyword = "uld" },  -- Uldaman: Legacy of Tyr
    [5] = { activityID = 518,  mapID = 245, keyword = "fh" },   -- Freehold
    [6] = { activityID = 462,  mapID = 206, keyword = "nl" },   -- Neltharion's Lair
    [7] = { activityID = 507,  mapID = 251, keyword = "undr" }, -- The Underrot
    [8] = { activityID = 1195, mapID = 438, keyword = "vp" },   -- Vortex Pinnacle

    -- Dragonflight Season 3
    --[1] = { activityID = 1247, mapID = 463, keyword = "fall" }, -- Dawn of the Infinite: Galakrond's Fall
    --[2] = { activityID = 1248, mapID = 464, keyword = "rise" }, -- Dawn of the Infinite: Murozond's Rise
    --[3] = { activityID = 530,  mapID = 248, keyword = "wm"   }, -- Waycrest Manor (Battle for Azeroth)
    --[4] = { activityID = 502,  mapID = 244, keyword = "ad"   }, -- Atal'Dazar (Battle for Azeroth)
    --[5] = { activityID = 460,  mapID = 198, keyword = "dht"  }, -- Darkheart Thicket (Legion)
    --[6] = { activityID = 463,  mapID = 199, keyword = "brh"  }, -- Black Rook Hold (Legion)
    --[7] = { activityID = 184,  mapID = 168, keyword = "teb"  },  -- The Everbloom (Warlords of Draenor)
    --[8] = { activityID = 1274, mapID = 456, keyword = "tott" }, -- Throne of the Tides (Cataclysm)

    -- note that there are currently one 8 checkboxes available in the xml file
    -- activityID can be found here: https://wago.tools/db2/GroupFinderActivity?sort[ID]=desc
    -- mapID      can be found here: https://wago.tools/db2/MapChallengeMode?page=1&sort[ID]=desc
}

local DungeonPanel = CreateFrame("Frame", "PremadeGroupsFilterDungeonPanel", PGF.Dialog, "PremadeGroupsFilterDungeonPanelTemplate")

function DungeonPanel:OnLoad()
    PGF.Logger:Debug("DungeonPanel:OnLoad")
    self.name = "dungeon"
    self.dialogWidth = 420
    self.groupWidth = 245

    -- Group
    self.Group.Title:SetText(L["dialog.filters.group"])
    PGF.UI_SetupDropDown(self, self.Group.Difficulty, "DungeonDifficultyMenu", L["dialog.difficulty"], DIFFICULTY_TEXT, self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.MPRating, "mprating", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.Members, "members", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.Tanks, "tanks", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.Heals, "heals", self.groupWidth)
    PGF.UI_SetupMinMaxField(self, self.Group.DPS, "dps", self.groupWidth)
    PGF.UI_SetupCheckBox(self, self.Group.Partyfit, "partyfit", self.groupWidth)
    PGF.UI_SetupCheckBox(self, self.Group.BLFit, "blfit", self.groupWidth)
    PGF.UI_SetupCheckBox(self, self.Group.BRFit, "brfit", self.groupWidth)
    PGF.UI_SetupAdvancedExpression(self)

    -- Dungeons
    self.Dungeons.Title:SetText(L["dialog.filters.dungeons"])
    self.Dungeons.Alert.Icon:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
    self.Dungeons.Alert:SetScript("OnEnter", function (self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["dialog.dungeon.alert.single.title"], nil, nil, nil, nil, true)
        GameTooltip:AddLine(L["dialog.dungeon.alert.single.info"], 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    self.Dungeons.Alert:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    for i = 1, #SEASON_DUNGEONS do
        --local dungeonName = C_LFGList.GetActivityInfoTable(SEASON_DUNGEONS[i].activityID).fullName
        local dungeonName = C_ChallengeMode.GetMapUIInfo(SEASON_DUNGEONS[i].mapID)
        self.Dungeons["Dungeon"..i]:SetWidth(145)
        self.Dungeons["Dungeon"..i].Title:SetText(dungeonName)
        self.Dungeons["Dungeon"..i].Title:SetWidth(105)
        self.Dungeons["Dungeon"..i].Act:SetScript("OnClick", function(element)
            self.state["dungeon" .. i] = element:GetChecked()
            self:ToogleDungeonAlert()
            self:TriggerFilterExpressionChange()
        end)
    end
end

function DungeonPanel:Init(state)
    PGF.Logger:Debug("Dungeonpanel:Init")
    self.state = state
    self.state.difficulty = self.state.difficulty or {}
    self.state.mprating = self.state.mprating or {}
    self.state.members = self.state.members or {}
    self.state.tanks = self.state.tanks or {}
    self.state.heals = self.state.heals or {}
    self.state.dps = self.state.dps or {}
    self.state.expression = self.state.expression or ""

    self.Group.Difficulty.Act:SetChecked(self.state.difficulty.act or false)
    self.Group.Difficulty.DropDown:SetKey(self.state.difficulty.val)
    self.Group.MPRating.Act:SetChecked(self.state.mprating.act or false)
    self.Group.MPRating.Min:SetText(self.state.mprating.min or "")
    self.Group.MPRating.Max:SetText(self.state.mprating.max or "")
    self.Group.Members.Act:SetChecked(self.state.members.act or false)
    self.Group.Members.Min:SetText(self.state.members.min or "")
    self.Group.Members.Max:SetText(self.state.members.max or "")
    self.Group.Tanks.Act:SetChecked(self.state.tanks.act or false)
    self.Group.Tanks.Min:SetText(self.state.tanks.min or "")
    self.Group.Tanks.Max:SetText(self.state.tanks.max or "")
    self.Group.Heals.Act:SetChecked(self.state.heals.act or false)
    self.Group.Heals.Min:SetText(self.state.heals.min or "")
    self.Group.Heals.Max:SetText(self.state.heals.max or "")
    self.Group.DPS.Act:SetChecked(self.state.dps.act or false)
    self.Group.DPS.Min:SetText(self.state.dps.min or "")
    self.Group.DPS.Max:SetText(self.state.dps.max or "")

    self.Group.Partyfit.Act:SetChecked(self.state.partyfit or false)
    self.Group.BLFit.Act:SetChecked(self.state.blfit or false)
    self.Group.BRFit.Act:SetChecked(self.state.brfit or false)

    for i = 1, #SEASON_DUNGEONS do
        self.Dungeons["Dungeon"..i].Act:SetChecked(self.state["dungeon"..i] or false)
    end
    self.Advanced.Expression.EditBox:SetText(self.state.expression or "")
    self:ToogleDungeonAlert()
end

function DungeonPanel:OnShow()
    PGF.Logger:Debug("DungeonPanel:OnShow")
end

function DungeonPanel:OnHide()
    PGF.Logger:Debug("DungeonPanel:OnHide")
end

function DungeonPanel:OnReset()
    PGF.Logger:Debug("DungeonPanel:OnReset")
    self.state.difficulty.act = false
    self.state.mprating.act = false
    self.state.mprating.min = ""
    self.state.mprating.max = ""
    self.state.members.act = false
    self.state.members.min = ""
    self.state.members.max = ""
    self.state.tanks.act = false
    self.state.tanks.min = ""
    self.state.tanks.max = ""
    self.state.heals.act = false
    self.state.heals.min = ""
    self.state.heals.max = ""
    self.state.dps.act = false
    self.state.dps.min = ""
    self.state.dps.max = ""
    self.state.partyfit = false
    self.state.blfit = false
    self.state.brfit = false
    for i = 1, #SEASON_DUNGEONS do
        self.state["dungeon"..i] = false
    end
    self.state.expression = ""
    self:TriggerFilterExpressionChange()
    self:Init(self.state)
end

function DungeonPanel:OnUpdateExpression(expression, sorting)
    PGF.Logger:Debug("DungeonPanel:OnUpdateExpression")
    self.state.expression = expression
    self:Init(self.state)
end

function DungeonPanel:TriggerFilterExpressionChange()
    PGF.Logger:Debug("DungeonPanel:TriggerFilterExpressionChange")
    local expression = self:GetFilterExpression()
    local hint = expression == "true" and "" or expression
    self.Advanced.Expression.EditBox.Instructions:SetText(hint)
    PGF.Dialog:OnFilterExpressionChanged()
end

function DungeonPanel:GetFilterExpression()
    PGF.Logger:Debug("DungeonPanel:GetFilterExpression")
    local expression = "true" -- start with neutral element of logical and
    if self.state.difficulty.act and self.state.difficulty.val then
        expression = expression .. " and " .. C.DIFFICULTY_KEYWORD[self.state.difficulty.val]
    end
    if self.state.mprating.act then
        if PGF.NotEmpty(self.state.mprating.min) then expression = expression .. " and mprating >= " .. self.state.mprating.min end
        if PGF.NotEmpty(self.state.mprating.max) then expression = expression .. " and mprating <= " .. self.state.mprating.max end
    end
    if self.state.members.act then
        if PGF.NotEmpty(self.state.members.min) then expression = expression .. " and members >= " .. self.state.members.min end
        if PGF.NotEmpty(self.state.members.max) then expression = expression .. " and members <= " .. self.state.members.max end
    end
    if self.state.tanks.act then
        if PGF.NotEmpty(self.state.tanks.min) then expression = expression .. " and tanks >= " .. self.state.tanks.min end
        if PGF.NotEmpty(self.state.tanks.max) then expression = expression .. " and tanks <= " .. self.state.tanks.max end
    end
    if self.state.heals.act then
        if PGF.NotEmpty(self.state.heals.min) then expression = expression .. " and heals >= " .. self.state.heals.min end
        if PGF.NotEmpty(self.state.heals.max) then expression = expression .. " and heals <= " .. self.state.heals.max end
    end
    if self.state.dps.act then
        if PGF.NotEmpty(self.state.dps.min) then expression = expression .. " and dps >= " .. self.state.dps.min end
        if PGF.NotEmpty(self.state.dps.max) then expression = expression .. " and dps <= " .. self.state.dps.max end
    end
    if self.state.partyfit    then expression = expression .. " and partyfit"     end
    if self.state.blfit       then expression = expression .. " and blfit"        end
    if self.state.brfit       then expression = expression .. " and brfit"        end

    if self:GetNumDungeonsSelected() > 0 then
        expression = expression .. " and ( false" -- start with neutral element of logical or
        for i = 1, #SEASON_DUNGEONS do
            if self.state["dungeon"..i] then expression = expression .. " or " .. SEASON_DUNGEONS[i].keyword end
        end
        expression = expression .. " )"
        expression = expression:gsub("false or ", "")
    end

    local userExp = PGF.UI_NormalizeExpression(self.state.expression)
    if userExp ~= "" then expression = expression .. " and ( " .. userExp .. " )" end

    expression = expression:gsub("^true and ", "")
    return expression
end

function DungeonPanel:GetSortingExpression()
    return nil
end

function DungeonPanel:GetDesiredDialogWidth()
    return self.dialogWidth
end

function DungeonPanel:GetNumDungeonsSelected()
    local numDungeonsSelected = 0
    for i = 1, #SEASON_DUNGEONS do
        if self.state["dungeon"..i] then
            numDungeonsSelected = numDungeonsSelected + 1
        end
    end
    return numDungeonsSelected
end

function DungeonPanel:ToogleDungeonAlert()
    PGF.Logger:Debug("DungeonPanel:ToogleDungeonAlert")
    if self:GetNumDungeonsSelected() == 1 then
        self.Dungeons.Alert:Show()
    else
        self.Dungeons.Alert:Hide()
    end
end

function DungeonPanel:TogglePartyfit()
    PGF.Logger:Debug("DungeonPanel:TogglePartyfit")
    if self.state.partyfit then
        self.Group:SetHeight(85)
        self.Group.Members:Hide()
        self.Group.Tanks:Hide()
        self.Group.Heals:Hide()
        self.Group.DPS:Hide()
        self.state.members.act = false
        self.state.members.min = ""
        self.state.members.max = ""
        self.state.tanks.act = false
        self.state.tanks.min = ""
        self.state.tanks.max = ""
        self.state.heals.act = false
        self.state.heals.min = ""
        self.state.heals.max = ""
        self.state.dps.act = false
        self.state.dps.min = ""
        self.state.dps.max = ""
        self:Init(self.state)
        self:TriggerFilterExpressionChange()
    else
        self.Group:SetHeight(185)
        self.Group.Members:Show()
        self.Group.Tanks:Show()
        self.Group.Heals:Show()
    end
end

DungeonPanel:OnLoad()
PGF.Dialog:RegisterPanel("c2f4", DungeonPanel)
