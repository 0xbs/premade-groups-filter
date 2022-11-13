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

function PGF.Dialog_ClearFocus()
    local dialog = PremadeGroupsFilterDialog
    dialog.MPRating.Min:ClearFocus()
    dialog.MPRating.Max:ClearFocus()
    dialog.PVPRating.Min:ClearFocus()
    dialog.PVPRating.Max:ClearFocus()
    dialog.Defeated.Min:ClearFocus()
    dialog.Defeated.Max:ClearFocus()
    dialog.Members.Min:ClearFocus()
    dialog.Members.Max:ClearFocus()
    dialog.Tanks.Min:ClearFocus()
    dialog.Tanks.Max:ClearFocus()
    dialog.Heals.Min:ClearFocus()
    dialog.Heals.Max:ClearFocus()
    dialog.Dps.Min:ClearFocus()
    dialog.Dps.Max:ClearFocus()
    dialog.Expression.EditBox:ClearFocus()
    dialog.Sorting.SortingExpression:ClearFocus()
end

function PGF.Dialog_OnModelUpdate()
    local exp = PGF.GetExpressionFromModel()
    if PGF.Empty(exp) or exp == "true" then exp = "" end
    exp = exp:gsub("^true and ", "")
    PremadeGroupsFilterDialog.Expression.EditBox.Instructions:SetText(exp)
end

function PGF.Dialog_UsePGF_OnClick(self, button, down)
    local checked = self:GetChecked()
    local model = PGF.GetModel()
    model.enabled = checked
    if checked then
        PremadeGroupsFilterDialog:Show()
    else
        PGF.Dialog_ClearFocus()
        PremadeGroupsFilterDialog:Hide()
    end
    LFGListSearchPanel_DoSearch(LFGListFrame.SearchPanel)
end

function PGF.Dialog_Act_OnClick(self, button, down)
    local dialog = PremadeGroupsFilterDialog
    local key = self:GetParent():GetAttribute("parentKey")
    local checked = self:GetChecked()
    local model = PGF.GetModel()
    model[key:lower()].act = checked
    PGF.Dialog_OnModelUpdate()
end

function PGF.Dialog_SetCheckbox(self, key, state)
    self[key].Act:SetChecked(state)
    PGF.Dialog_Act_OnClick(self[key].Act)
end

function PGF.Dialog_ToggleCheckboxAccordingToMinMaxFields(key)
    local self = PremadeGroupsFilterDialog
    local state = PGF.NotEmpty(self[key].Min:GetText()) or PGF.NotEmpty(self[key].Max:GetText())
    PGF.Dialog_SetCheckbox(self, key, state)
end

function PGF.Dialog_ResetGenericField(self, key)
    PGF.Dialog_SetCheckbox(self, key, false)
end

function PGF.Dialog_MinMax_OnTextChanged(self, userInput)
    local selfKey = self:GetAttribute("parentKey")
    local parentKey = self:GetParent():GetAttribute("parentKey")
    local val = self:GetText()
    local model = PGF.GetModel()
    model[parentKey:lower()][selfKey:lower()] = val
    PGF.Dialog_ToggleCheckboxAccordingToMinMaxFields(parentKey)
    --PGF.Dialog_OnModelUpdate() -- line above does that
end

function PGF.Dialog_Expression_OnTextChanged(self, userInput)
    -- we cannot set the OnTextChange directly, since the InputScrollFrameTemplate
    -- needs that for hiding/showing the gray instructions text
    if self == PremadeGroupsFilterDialog.Expression.EditBox then
        local model = PGF.GetModel()
        model.expression = self:GetText() or ""
        PGF.Dialog_OnModelUpdate()
    end
end

function PGF.Dialog_SortingExpression_OnTextChanged(self, userInput)
    -- we cannot set the OnTextChange directly, since the InputBoxInstructions
    -- needs that for hiding/showing the gray instructions text
    if self == PremadeGroupsFilterDialog.Sorting.SortingExpression then
        local model = PGF.GetModel()
        model.sorting = self:GetText() or ""
        PGF.Dialog_OnModelUpdate()
    end
end

function PGF.Dialog_ResetMinMaxField(self, key)
    PGF.Dialog_ResetGenericField(self, key)
    self[key].Min:SetText("")
    self[key].Max:SetText("")
    PGF.Dialog_MinMax_OnTextChanged(self[key].Min)
    PGF.Dialog_MinMax_OnTextChanged(self[key].Max)
end

function PGF.Dialog_Reset(excludeExpression)
    local dialog = PremadeGroupsFilterDialog
    -- TODO reset the difficulty dropdown
    PGF.Dialog_ResetGenericField(dialog, "Difficulty")
    PGF.Dialog_ResetMinMaxField(dialog, "MPRating")
    PGF.Dialog_ResetMinMaxField(dialog, "PVPRating")
    PGF.Dialog_ResetMinMaxField(dialog, "Members")
    PGF.Dialog_ResetMinMaxField(dialog, "Tanks")
    PGF.Dialog_ResetMinMaxField(dialog, "Heals")
    PGF.Dialog_ResetMinMaxField(dialog, "Dps")
    PGF.Dialog_ResetMinMaxField(dialog, "Defeated")
    dialog.Sorting.SortingExpression:SetText("")
    PGF.Dialog_SortingExpression_OnTextChanged(dialog.Sorting.SortingExpression)
    if not excludeExpression then
        dialog.Expression.EditBox:SetText("")
        PGF.Dialog_Expression_OnTextChanged(dialog.Expression.EditBox)
    end
    PGF.Dialog_ClearFocus()
end

function PGF.Dialog_RefreshButton_OnClick(self, button, down)
    PGF.Dialog_ClearFocus()
    PGF.Dialog_Expression_OnTextChanged(PremadeGroupsFilterDialog.Expression.EditBox)
    PGF.Dialog_SortingExpression_OnTextChanged(PremadeGroupsFilterDialog.Sorting.SortingExpression)
    LFGListSearchPanel_DoSearch(LFGListFrame.SearchPanel)
end

function PGF.Dialog_ResetButton_OnClick(self, button, down)
    PGF.StaticPopup_Show("PGF_CONFIRM_RESET")
end

function PGF.Dialog_ResetButton_OnConfirm(self, data)
     PGF.Dialog_Reset()
     PGF.Dialog_Expression_OnTextChanged(PremadeGroupsFilterDialog.Expression.EditBox)
     PGF:Dialog_RefreshButton_OnClick(PremadeGroupsFilterDialog.RefreshButton)
end

function PGF.Dialog_DifficultyDropdown_OnClick(item)
    local dialog = PremadeGroupsFilterDialog
    if item.value then
        PGF.Dialog_SetCheckbox(PremadeGroupsFilterDialog, "Difficulty", true)
        local model = PGF.GetModel()
        model.difficulty.val = item.value
        dialog.Difficulty.DropDown.Text:SetText(item.title)
        PGF.Dialog_OnModelUpdate()
    end
end

function PGF.Dialog_Min_OnTabPressed(self)
    self:GetParent().Max:SetFocus()
end

function PGF.Dialog_Max_OnTabPressed(self)
    self:GetParent().Min:SetFocus()
    -- TODO switch to next editbox instead
end

function PGF.Dialog_Toggle()
    local dialog = PremadeGroupsFilterDialog
    local model = PGF.GetModel()
    if PVEFrame:IsVisible() and LFGListFrame.activePanel == LFGListFrame.SearchPanel
            and LFGListFrame.SearchPanel:IsVisible() and model then
        PGF.UsePFGButton:SetChecked(model.enabled)
        if model.enabled then
            dialog:Show()
        end
    else
        dialog:Hide()
    end
end

hooksecurefunc("LFGListFrame_SetActivePanel", PGF.Dialog_Toggle)
hooksecurefunc("GroupFinderFrame_ShowGroupFrame", PGF.Dialog_Toggle)
hooksecurefunc("PVEFrame_ShowFrame", PGF.Dialog_Toggle)
hooksecurefunc("InputScrollFrame_OnTextChanged", PGF.Dialog_Expression_OnTextChanged)
hooksecurefunc("InputBoxInstructions_OnTextChanged", PGF.Dialog_SortingExpression_OnTextChanged)
PVEFrame:HookScript("OnShow", PGF.Dialog_Toggle)
PVEFrame:HookScript("OnHide", PGF.Dialog_Toggle)
