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
local C = PGF.C

local DIFFICULTY_TEXT = {
    [C.NORMAL] = L["dialog.normal"],
    [C.HEROIC] = L["dialog.heroic"],
    [C.MYTHIC] = L["dialog.mythic"],
    [C.MYTHICPLUS] = L["dialog.mythicplus"],
}

-------------------------------------------------------------------------------
-- OnShow functions
-------------------------------------------------------------------------------

function PGF.Dialog_LoadMinMaxFromModel(dialog, model, key)
    dialog[key].Act:SetChecked(model[key:lower()].act)
    dialog[key].Min:SetText(model[key:lower()].min)
    dialog[key].Max:SetText(model[key:lower()].max)
end

function PGF.Dialog_LoadFromModel(dialog)
    local model = PremadeGroupsFilterState
    PGF.UsePFGButton:SetChecked(model.enabled)
    PGF.previousSearchExpression = model.expression
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Ilvl")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Defeated")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Members")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Tanks")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Heals")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Dps")
    dialog.Noilvl.Act:SetChecked(model.noilvl.act)
    dialog.Expression.EditBox:SetText(model.expression)
    dialog.Difficulty.Act:SetChecked(model.difficulty.act)
    dialog.Difficulty.DropDown.Text:SetText(DIFFICULTY_TEXT[model.difficulty.val])
end

function PGF.Dialog_UpdatePosition()
    local dialog = PremadeGroupsFilterDialog
    dialog:SetPoint("TOPLEFT", GroupFinderFrame, "TOPRIGHT")
    dialog:SetPoint("BOTTOMLEFT", GroupFinderFrame, "BOTTOMRIGHT")
    dialog:SetWidth(300)
end

function PGF.Dialog_OnShow(dialog)
    RequestRaidInfo() -- need the dungeon/raid lockout information later for filtering
    PGF.Dialog_LoadFromModel(dialog)
    PGF.Dialog_UpdatePosition(dialog)
end

-------------------------------------------------------------------------------
-- OnLoad functions
-------------------------------------------------------------------------------

function PGF.Dialog_DifficultyDropdown_Init(dropdown)
    local entries = {}
    local addEntry = function (entries, value)
        table.insert(entries, {
            title = DIFFICULTY_TEXT[value],
            value = value,
            func = PGF.Dialog_DifficultyDropdown_OnClick
        })
    end

    addEntry(entries, C.NORMAL)
    addEntry(entries, C.HEROIC)
    addEntry(entries, C.MYTHIC)
    addEntry(entries, C.MYTHICPLUS)

    PGF.PopupMenu_Register("DifficultyMenu", entries, PremadeGroupsFilterDialog, "TOPRIGHT", dropdown, "BOTTOMRIGHT", -15, 10, 95, 150)
    dropdown.Button:SetScript("OnClick", function () PGF.PopupMenu_Toggle("DifficultyMenu") end)
    dropdown:SetScript("OnHide", PGF.PopupMenu_Hide)
end

function PGF.Dialog_SetUpGenericField(self, key)
    self[key]:SetAttribute("parentKey", key)
    self[key].Title:SetText(L["dialog." .. key:lower()])
    self[key].Act:SetScript("OnClick", PGF.Dialog_Act_OnClick)
end

function PGF.Dialog_SetUpMinMaxField(self, key)
    PGF.Dialog_SetUpGenericField(self, key)
    self[key].Min:SetAttribute("parentKey", "Min")
    self[key].Max:SetAttribute("parentKey", "Max")
    self[key].To:SetText(L["dialog.to"])
    self[key].Min:SetScript("OnTextChanged", PGF.Dialog_MinMax_OnTextChanged)
    self[key].Max:SetScript("OnTextChanged", PGF.Dialog_MinMax_OnTextChanged)
    self[key].Min:SetScript("OnTabPressed", PGF.Dialog_Min_OnTabPressed)
    self[key].Max:SetScript("OnTabPressed", PGF.Dialog_Max_OnTabPressed)
end

function PGF.Dialog_SetUpUsePGFCheckbox()
    local button = CreateFrame("CheckButton", "UsePFGButton", LFGListFrame.SearchPanel, "UICheckButtonTemplate")
    button:SetSize(26, 26)
    button:SetHitRectInsets(-2, -30, -2, -2)
    button.text:SetText("PGF")
    button.text:SetFontObject("GameFontHighlight")
    button.text:SetWidth(30)
    button:SetPoint("LEFT", LFGListFrame.SearchPanel.RefreshButton, "LEFT", -62, 0)
    button:SetPoint("TOP", LFGListFrame.SearchPanel.RefreshButton, "TOP", 0, -3)
    button:SetScript("OnClick", PGF.Dialog_UsePGF_OnClick)
    button:SetScript("OnEnter", function (self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["dialog.usepgf.tooltip"])
    end)
    button:SetScript("OnLeave", function () GameTooltip:Hide() end)
    PGF.UsePFGButton = button
end

function PGF.Dialog_OnLoad()
    local dialog = PremadeGroupsFilterDialog -- keep that
    dialog:SetScript("OnShow", PGF.Dialog_OnShow)

    dialog.InsetBg:SetPoint("TOPLEFT", 4, -62)
    dialog.InsetBg:SetPoint("BOTTOMRIGHT", -6, 26)
    dialog.Title:SetText("Premade Groups Filter")
    dialog.ResetButton:SetText(L["dialog.reset"])
    dialog.ResetButton:SetScript("OnClick", PGF.Dialog_ResetButton_OnClick)
    dialog.RefreshButton:SetText(L["dialog.refresh"])
    dialog.RefreshButton:SetScript("OnClick", PGF.Dialog_RefreshButton_OnClick)
    dialog.SimpleExplanation:SetText(L["dialog.expl.simple"])
    dialog.StateExplanation:SetText(L["dialog.expl.state"])
    dialog.MinExplanation:SetText(L["dialog.expl.min"])
    dialog.MaxExplanation:SetText(L["dialog.expl.max"])
    dialog.Advanced.Explanation:SetText(L["dialog.expl.advanced"])
    dialog.Advanced.InfoButton:EnableMouse(true)
    dialog.Advanced.InfoButton:SetScript("OnEnter", PGF.Dialog_InfoButton_OnEnter)
    dialog.Advanced.InfoButton:SetScript("OnLeave", PGF.Dialog_InfoButton_OnLeave)
    dialog.Ilvl.Min:SetMaxLetters(3)
    dialog.Ilvl.Max:SetMaxLetters(3)
    dialog.Noilvl.Title:SetWidth(210)
    dialog.Noilvl.Act:SetEnabled(false)
    dialog.Defeated.Title:SetWordWrap(true)
    dialog.Defeated.Title:SetHeight(28)

    PGF.Dialog_SetUpGenericField(dialog, "Difficulty")
    PGF.Dialog_SetUpMinMaxField(dialog, "Ilvl")
    PGF.Dialog_SetUpGenericField(dialog, "Noilvl")
    PGF.Dialog_SetUpMinMaxField(dialog, "Members")
    PGF.Dialog_SetUpMinMaxField(dialog, "Tanks")
    PGF.Dialog_SetUpMinMaxField(dialog, "Heals")
    PGF.Dialog_SetUpMinMaxField(dialog, "Dps")
    PGF.Dialog_SetUpMinMaxField(dialog, "Defeated")
    PGF.Dialog_SetUpUsePGFCheckbox()

    local font = dialog.SimpleExplanation:GetFont()
    dialog.Expression.EditBox:SetFont(font, C.FONTSIZE_TEXTBOX)
    dialog.Expression.EditBox.Instructions:SetFont(font, C.FONTSIZE_TEXTBOX)
    --dialog.Expression.EditBox:SetScript("OnTextChanged", PGF.Dialog_Expression_OnTextChanged) -- overrides Blizz

    PGF.Dialog_DifficultyDropdown_Init(dialog.Difficulty.DropDown)
end

PremadeGroupsFilter.Dialog_OnLoad = PGF.Dialog_OnLoad
