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
    [C.NORMAL] = L["dialog.normal"],
    [C.HEROIC] = L["dialog.heroic"],
    [C.MYTHIC] = L["dialog.mythic"],
    [C.MYTHICPLUS] = L["dialog.mythicplus"],
    [C.ARENA2V2] = C_LFGList.GetActivityInfoTable(6).shortName, -- Arena 2v2
    [C.ARENA3V3] = C_LFGList.GetActivityInfoTable(7).shortName, -- Arena 3v3
}

-- Calling Minimize or Maximize (regardless of param isAutomaticAction) will always trigger the callback
-- causing yet another Minimize or Maximize call. To break the infinite loop, we simply remember in this var
-- when we do not wish to run the callback code.
PGF.ignoreNextMaximizeMinimizeCallback = false

function PGF.Dialog_LoadMinMaxFromModel(dialog, model, key)
    dialog[key].Act:SetChecked(model[key:lower()].act)
    dialog[key].Min:SetText(model[key:lower()].min)
    dialog[key].Max:SetText(model[key:lower()].max)
end

function PGF.Dialog_OnShow(dialog)
    RequestRaidInfo() -- need the dungeon/raid lockout information later for filtering
    local model = PGF.GetModel()
    PGF.UsePFGButton:SetChecked(model.enabled)
    PGF.previousSearchExpression = model.expression
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "MPRating")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "PVPRating")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Defeated")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Members")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Tanks")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Heals")
    PGF.Dialog_LoadMinMaxFromModel(dialog, model, "Dps")
    dialog.Expression.EditBox:SetText(model.expression)
    dialog.Sorting.SortingExpression:SetText(model.sorting)
    dialog.Difficulty.Act:SetChecked(model.difficulty.act)
    dialog.Difficulty.DropDown.Text:SetText(DIFFICULTY_TEXT[model.difficulty.val])
    PGF.Dialog_AdjustToMode(model.expert)
end

function PGF.Dialog_OnMouseDown(self, button)
    if not PremadeGroupsFilterSettings.dialogMovable then return end
    PremadeGroupsFilterDialog:StartMoving()
end

function PGF.Dialog_OnMouseUp(self, button)
    if not PremadeGroupsFilterSettings.dialogMovable then return end
    PremadeGroupsFilterDialog:StopMovingOrSizing()
    if button == "RightButton" then
        PGF.Dialog_ResetPosition()
    end
end

function PGF.Dialog_MinimizeButton_OnClick(self, button, down)
    if PGF.ignoreNextMaximizeMinimizeCallback then
        PGF.ignoreNextMaximizeMinimizeCallback = false
        return
    end
    local model = PGF.GetModel()
    model.expert = true
    PGF.Dialog_Reset(true)
    PGF.Dialog_AdjustToMode(model.expert)
end

function PGF.Dialog_MaximizeButton_OnClick(self, button, down)
    if PGF.ignoreNextMaximizeMinimizeCallback then
        PGF.ignoreNextMaximizeMinimizeCallback = false
        return
    end
    local model = PGF.GetModel()
    model.expert = false
    PGF.Dialog_Reset(true)
    PGF.Dialog_AdjustToMode(model.expert)
end

function PGF.Dialog_AdjustToMode(expert)
    PGF.ignoreNextMaximizeMinimizeCallback = true
    local dialog = PremadeGroupsFilterDialog
    if expert then
    	dialog.MaximizeMinimizeFrame:Minimize()
        dialog.Difficulty:Hide()
        dialog.MPRating:Hide()
        dialog.PVPRating:Hide()
        dialog.Defeated:Hide()
        dialog.Members:Hide()
        dialog.Tanks:Hide()
        dialog.Heals:Hide()
        dialog.Dps:Hide()
        dialog.SimpleExplanation:Hide()
        dialog.StateExplanation:Hide()
        dialog.MinExplanation:Hide()
        dialog.MaxExplanation:Hide()
        dialog.AdvancedExplanation:Hide()
        dialog.Inset:Hide()
        dialog.InfoButton:SetPoint("BOTTOMRIGHT", dialog.Sorting, "BOTTOMRIGHT", 2, -3)
        dialog.InfoButton:SetSize(32, 32)
        dialog.InfoButton.I:SetSize(32, 32)
        dialog.InfoButton.H:SetSize(32, 32)
        dialog.Sorting:Show()
        dialog.Expression:SetPoint("BOTTOM", 0, 58)
        dialog.Expression:SetHeight(130)
        dialog:SetSize(300, 218)
    else
        dialog.MaximizeMinimizeFrame:Maximize()
        dialog.Difficulty:Show()
        dialog.MPRating:Show()
        dialog.PVPRating:Show()
        dialog.Defeated:Show()
        dialog.Members:Show()
        dialog.Tanks:Show()
        dialog.Heals:Show()
        dialog.Dps:Show()
        dialog.SimpleExplanation:Show()
        dialog.StateExplanation:Show()
        dialog.MinExplanation:Show()
        dialog.MaxExplanation:Show()
        dialog.AdvancedExplanation:Show()
        dialog.Inset:Show()
        dialog.InfoButton:SetPoint("BOTTOMRIGHT", 0, 102)
        dialog.InfoButton:SetSize(46, 46)
        dialog.InfoButton.I:SetSize(46, 46)
        dialog.InfoButton.H:SetSize(46, 46)
        dialog.Sorting:Hide()
        dialog.Expression:SetPoint("BOTTOM", 0, 32)
        dialog.Expression:SetHeight(70)
        dialog:SetSize(300, 427)
    end
end

function PGF.Dialog_ResetPosition()
    local dialog = PremadeGroupsFilterDialog
    dialog:ClearAllPoints()
    dialog:SetPoint("TOPLEFT", PVEFrame, "TOPRIGHT")
    dialog:SetWidth(300)
end

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
    addEntry(entries, C.ARENA2V2)
    addEntry(entries, C.ARENA3V3)

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
    button.text:SetText(L["addon.name.short"])
    button.text:SetFontObject("GameFontHighlight")
    button.text:SetWidth(30)
    button:SetPoint("LEFT", LFGListFrame.SearchPanel.RefreshButton, "LEFT", -62, 0)
    button:SetPoint("TOP", LFGListFrame.SearchPanel.RefreshButton, "TOP", 0, -3)
    button:SetScript("OnClick", PGF.Dialog_UsePGF_OnClick)
    button:SetScript("OnMouseUp", function (self, button)
        if button == "RightButton" then
            PGF.Dialog_ResetPosition()
        end
    end)
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
    dialog:SetScript("OnMouseDown", PGF.Dialog_OnMouseDown)
    dialog:SetScript("OnMouseUp", PGF.Dialog_OnMouseUp)

    dialog:SetBorder("ButtonFrameTemplateNoPortraitMinimizable")
	dialog:SetPortraitShown(false)
    dialog:SetTitle(L["addon.name.long"])
    dialog.MaximizeMinimizeFrame:SetOnMaximizedCallback(PGF.Dialog_MaximizeButton_OnClick)
    dialog.MaximizeMinimizeFrame:SetOnMinimizedCallback(PGF.Dialog_MinimizeButton_OnClick)
    --dialog.MaximizeMinimizeFrame:SetMinimizedCVar("miniPremadeGroupsFilter")

    dialog.ResetButton:SetText(L["dialog.reset"])
    dialog.ResetButton:SetScript("OnClick", PGF.Dialog_ResetButton_OnClick)
    dialog.RefreshButton:SetText(L["dialog.refresh"])
    dialog.RefreshButton:SetScript("OnClick", PGF.Dialog_RefreshButton_OnClick)
    dialog.SimpleExplanation:SetText(L["dialog.expl.simple"])
    dialog.StateExplanation:SetText(L["dialog.expl.state"])
    dialog.MinExplanation:SetText(L["dialog.expl.min"])
    dialog.MaxExplanation:SetText(L["dialog.expl.max"])
    dialog.AdvancedExplanation:SetText(L["dialog.expl.advanced"])
    dialog.InfoButton:EnableMouse(true)
    dialog.InfoButton:SetScript("OnEnter", PGF.Dialog_InfoButton_OnEnter)
    dialog.InfoButton:SetScript("OnLeave", PGF.Dialog_InfoButton_OnLeave)
    dialog.InfoButton:SetScript("OnClick", PGF.Dialog_InfoButton_OnClick)
    dialog.MPRating.Min:SetMaxLetters(4)
    dialog.MPRating.Max:SetMaxLetters(4)
    dialog.PVPRating.Min:SetMaxLetters(4)
    dialog.PVPRating.Max:SetMaxLetters(4)
    dialog.Sorting.SortingTitle:SetText(L["dialog.sorting"])
    dialog.Sorting.SortingExpression.Instructions:SetText("friends desc, age asc")

    PGF.Dialog_SetUpGenericField(dialog, "Difficulty")
    PGF.Dialog_SetUpMinMaxField(dialog, "MPRating")
    PGF.Dialog_SetUpMinMaxField(dialog, "PVPRating")
    PGF.Dialog_SetUpMinMaxField(dialog, "Members")
    PGF.Dialog_SetUpMinMaxField(dialog, "Tanks")
    PGF.Dialog_SetUpMinMaxField(dialog, "Heals")
    PGF.Dialog_SetUpMinMaxField(dialog, "Dps")
    PGF.Dialog_SetUpMinMaxField(dialog, "Defeated")
    PGF.Dialog_SetUpUsePGFCheckbox()

    local fontFile, _, fontFlags = dialog.SimpleExplanation:GetFont()
    dialog.Expression.EditBox:SetFont(fontFile, C.FONTSIZE_TEXTBOX, fontFlags)
    dialog.Expression.EditBox.Instructions:SetFont(fontFile, C.FONTSIZE_TEXTBOX, fontFlags)
    --dialog.Expression.EditBox:SetScript("OnTextChanged", PGF.Dialog_Expression_OnTextChanged) -- overrides Blizz
    dialog.Sorting.SortingExpression:SetFont(fontFile, C.FONTSIZE_TEXTBOX, fontFlags)
    dialog.Sorting.SortingExpression.Instructions:SetFont(fontFile, C.FONTSIZE_TEXTBOX, fontFlags)
    --dialog.Sorting.SortingExpression:SetScript("OnTextChanged", PGF.Dialog_SortingExpression_OnTextChanged) -- overrides Blizz

    PGF.Dialog_DifficultyDropdown_Init(dialog.Difficulty.DropDown)
end

PremadeGroupsFilter.Dialog_OnLoad = PGF.Dialog_OnLoad
PremadeGroupsFilter.ResetPosition = PGF.Dialog_ResetPosition
