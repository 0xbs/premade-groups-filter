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

function PGF.Dialog_ClearFocus()
    local dialog = PremadeGroupsFilterDialog
    dialog.Ilvl.Min:ClearFocus()
    dialog.Ilvl.Max:ClearFocus()
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
end

function PGF.Dialog_OnModelUpdate()
    local exp = PGF.GetExpressionFromModel()
    if PGF.Empty(exp) or exp == "true" then exp = "" end
    exp = exp:gsub("^true and ", "")
    PremadeGroupsFilterDialog.Expression.EditBox.Instructions:SetText(exp)
end

function PGF.Dialog_UsePGF_OnClick(self, button, down)
    local checked = self:GetChecked()
    PremadeGroupsFilterState.enabled = checked
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
    PremadeGroupsFilterState[key:lower()].act = checked
    if key == "Ilvl" then
        dialog.Noilvl.Act:SetEnabled(checked)
        if not checked then
            dialog.Noilvl.Act:SetChecked(false)
            PGF.Dialog_Act_OnClick(dialog.Noilvl.Act)
        end
    end
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
    PremadeGroupsFilterState[parentKey:lower()][selfKey:lower()] = val
    PGF.Dialog_ToggleCheckboxAccordingToMinMaxFields(parentKey)
    --PGF.Dialog_OnModelUpdate() -- line above does that
end

function PGF.Dialog_Expression_OnTextChanged(self, userInput)
    -- we cannot set the OnTextChange directly, since the InputScrollFrameTemplate
    -- needs that for hiding/showing the gray instructions text
    if self == PremadeGroupsFilterDialog.Expression.EditBox then
        PremadeGroupsFilterState.expression = self:GetText() or ""
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

function PGF.Dialog_Reset()
    local dialog = PremadeGroupsFilterDialog
    -- TODO reset the difficulty dropdown
    PGF.Dialog_ResetGenericField(dialog, "Difficulty")
    PGF.Dialog_ResetMinMaxField(dialog, "Ilvl")
    PGF.Dialog_ResetGenericField(dialog, "Noilvl")
    PGF.Dialog_ResetMinMaxField(dialog, "Members")
    PGF.Dialog_ResetMinMaxField(dialog, "Tanks")
    PGF.Dialog_ResetMinMaxField(dialog, "Heals")
    PGF.Dialog_ResetMinMaxField(dialog, "Dps")
    PGF.Dialog_ResetMinMaxField(dialog, "Defeated")
    dialog.Expression.EditBox:SetText("")
    PGF.Dialog_Expression_OnTextChanged(dialog.Expression.EditBox)
    PGF.Dialog_ClearFocus()
end

function PGF.Dialog_RefreshButton_OnClick(self, button, down)
    PGF.Dialog_ClearFocus()
    PGF.Dialog_Expression_OnTextChanged(PremadeGroupsFilterDialog.Expression.EditBox)
    LFGListSearchPanel_DoSearch(LFGListFrame.SearchPanel)
end

function PGF.Dialog_ResetButton_OnClick(self, button, down)
    PGF.Dialog_Reset()
    PGF.Dialog_Expression_OnTextChanged(PremadeGroupsFilterDialog.Expression.EditBox)
    PGF:Dialog_RefreshButton_OnClick(PremadeGroupsFilterDialog.RefreshButton)
end

function PGF.Dialog_DifficultyDropdown_OnClick(item)
    local dialog = PremadeGroupsFilterDialog
    if item.value then
        PGF.Dialog_SetCheckbox(PremadeGroupsFilterDialog, "Difficulty", true)
        PremadeGroupsFilterState.difficulty.val = item.value
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
    if PremadeGroupsFilterState.enabled
            and PVEFrame:IsVisible()
            and LFGListFrame.activePanel == LFGListFrame.SearchPanel
            and LFGListFrame.SearchPanel:IsVisible() then
        dialog:Show()
    else
        dialog:Hide()
    end
end

local buttonHooksInitialized = false
function PGF.OnLFGListFrameSetActivePanel(self, panel)
    PGF.Dialog_Toggle()
    if not buttonHooksInitialized and panel == self.SearchPanel then
        buttonHooksInitialized = true
        local buttons = self.SearchPanel.ScrollFrame.buttons
        for i = 1, #buttons do
            buttons[i]:HookScript("OnEnter", PGF.OnLFGListSearchEntryOnEnter)
        end
    end
end

hooksecurefunc("LFGListFrame_SetActivePanel", PGF.OnLFGListFrameSetActivePanel)
hooksecurefunc("GroupFinderFrame_ShowGroupFrame", PGF.Dialog_Toggle)
hooksecurefunc("PVEFrame_ShowFrame", PGF.Dialog_Toggle)
hooksecurefunc("InputScrollFrame_OnTextChanged", PGF.Dialog_Expression_OnTextChanged)
PVEFrame:SetScript("OnShow", PGF.Dialog_Toggle)
PVEFrame:SetScript("OnHide", PGF.Dialog_Toggle)
