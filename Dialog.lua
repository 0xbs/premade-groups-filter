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

local PGF = PremadeGroupsFilter
local L = select(2, ...)

function PGF.GameTooltip_AddWhite(left)
    GameTooltip:AddLine(left, 255, 255, 255)
end

function PGF.GameTooltip_AddDoubleWhite(left, right)
    GameTooltip:AddDoubleLine(left, right, 255, 255, 255, 255, 255, 255)
end

function PGF.Dialog_InfoButton_OnEnter(self, motion)
    local AddDoubleWhiteUsingKey = function (key)
        PGF.GameTooltip_AddDoubleWhite(key, L["dialog.tooltip." .. key]) end

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(L["dialog.tooltip.title"])
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["dialog.tooltip.variable"], L["dialog.tooltip.description"])
    AddDoubleWhiteUsingKey("name")
    AddDoubleWhiteUsingKey("comment")
    AddDoubleWhiteUsingKey("ilvl")
    AddDoubleWhiteUsingKey("hlvl")
    AddDoubleWhiteUsingKey("defeated")
    AddDoubleWhiteUsingKey("members")
    AddDoubleWhiteUsingKey("tanks")
    AddDoubleWhiteUsingKey("heals")
    AddDoubleWhiteUsingKey("dps")
    AddDoubleWhiteUsingKey("age")
    AddDoubleWhiteUsingKey("voice")
    AddDoubleWhiteUsingKey("myrealm")
    PGF.GameTooltip_AddDoubleWhite("normal/heroic/mythic/mythicplus", L["dialog.tooltip.difficulty"])
    PGF.GameTooltip_AddDoubleWhite("hm/brf/hfc/en/nh/tov", L["dialog.tooltip.raids"])
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["dialog.tooltip.op.logic"], L["dialog.tooltip.example"])
    PGF.GameTooltip_AddDoubleWhite("()", L["dialog.tooltip.ex.parentheses"])
    PGF.GameTooltip_AddDoubleWhite("not", L["dialog.tooltip.ex.not"])
    PGF.GameTooltip_AddDoubleWhite("and", L["dialog.tooltip.ex.and"])
    PGF.GameTooltip_AddDoubleWhite("or", L["dialog.tooltip.ex.or"])
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["dialog.tooltip.op.number"], L["dialog.tooltip.example"])
    PGF.GameTooltip_AddDoubleWhite("==", L["dialog.tooltip.ex.eq"])
    PGF.GameTooltip_AddDoubleWhite("~=", L["dialog.tooltip.ex.neq"])
    PGF.GameTooltip_AddDoubleWhite("<,>,<=,>=", L["dialog.tooltip.ex.lt"])
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["dialog.tooltip.op.string"], L["dialog.tooltip.example"])
    PGF.GameTooltip_AddDoubleWhite("name:find(\"x\")", L["dialog.tooltip.ex.find"])
    PGF.GameTooltip_AddDoubleWhite("name:match(\"x\")", L["dialog.tooltip.ex.match"])
    GameTooltip:Show()
end

function PGF.Dialog_InfoButton_OnLeave(self, motion)
    GameTooltip:Hide()
end

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

function PGF.Dialog_Act_OnClick(self, button, down)
    local dialog = PremadeGroupsFilterDialog
    local key = self:GetParent():GetAttribute("parentKey")
    local checked = self:GetChecked()
    PGF.model[key:lower()].act = checked
    if key == "Ilvl" then
        dialog.Noilvl.Act:SetEnabled(checked)
        if not checked then
            dialog.Noilvl.Act:SetChecked(false)
            PGF.Dialog_Act_OnClick(dialog.Noilvl.Act)
        end
    end
    PGF.Dialog_OnModelUpdate()
    PGF.DebugPrint("state of " .. key .. " changed to " .. tostring(checked))
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
    PGF.model[parentKey:lower()][selfKey:lower()] = val
    PGF.Dialog_ToggleCheckboxAccordingToMinMaxFields(parentKey)
    --PGF.Dialog_OnModelUpdate() -- line above does that
    PGF.DebugPrint(selfKey .. " of " .. parentKey .. " changed to " .. tostring(val))
end

function PGF.Dialog_Expression_OnTextChanged(self, userInput)
    -- we cannot set the OnTextChange directly, since the InputScrollFrameTemplate
    -- needs that for hiding/showing the gray instructions text
    if self == PremadeGroupsFilterDialog.Expression.EditBox then
        PGF.model.expression = self:GetText() or ""
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

function PGF:Dialog_RefreshButton_OnClick(self, button, down)
    PGF.DebugPrint("refresh clicked")
    PGF.Dialog_ClearFocus()
    LFGListSearchPanel_DoSearch(LFGListFrame.SearchPanel)
end

function PGF:Dialog_ResetButton_OnClick(self, button, down)
    PGF.DebugPrint("reset clicked")
    local dialog = PremadeGroupsFilterDialog
    -- TODO: reset the difficulty dropdown
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
    PGF:Dialog_RefreshButton_OnClick(dialog.RefreshButton)
    PGF.Dialog_ClearFocus()
end

function PGF.Dialog_DifficultyDropdown_OnClick(item, dropdown, text)
    --local dropdown = D.Difficulty.DropDown
    if item.value then
        PGF.model.difficulty.val = item.value
        UIDropDownMenu_SetSelectedValue(dropdown, item.value)
        UIDropDownMenu_SetText(dropdown, text)
        PGF.Dialog_OnModelUpdate()
    end
end

function PGF.Dialog_DifficultyDropdown_AddItem(dropdown, difficulty, text)
    local info = UIDropDownMenu_CreateInfo()
    info.value = difficulty
    info.checked = PGF.model.difficulty.val == difficulty
    info.func = PGF.Dialog_DifficultyDropdown_OnClick
    info.arg1 = dropdown
    info.arg2 = text
    info.text = text
    UIDropDownMenu_AddButton(info)
end

function PGF.Dialog_DifficultyDropdown_Init(self, level)
    PGF.Dialog_DifficultyDropdown_AddItem(self, PGF.CONST.NORMAL, L["dialog.normal"])
    PGF.Dialog_DifficultyDropdown_AddItem(self, PGF.CONST.HEROIC, L["dialog.heroic"])
    PGF.Dialog_DifficultyDropdown_AddItem(self, PGF.CONST.MYTHIC, L["dialog.mythic"])
    PGF.Dialog_DifficultyDropdown_AddItem(self, PGF.CONST.MYTHICPLUS, L["dialog.mythicplus"])
end

function PGF.Dialog_Min_OnTabPressed(self)
    self:GetParent().Max:SetFocus()
end

function PGF.Dialog_Max_OnTabPressed(self)
    self:GetParent().Min:SetFocus()
    -- TODO switch to next editbox instead
end

function PGF.Dialog_SetUpGenericField(self, key)
    self[key]:SetAttribute("parentKey", key)
    self[key].Title:SetText(L["dialog." .. key:lower()])
    self[key].Act:SetScript("OnClick", PGF.Dialog_Act_OnClick)
end

function PGF.Dialog_SetUpMinMaxField(self, key)
    PGF.Dialog_SetUpGenericField(self, key)
    self[key].Min:SetText(PGF.model[key:lower()].min)
    self[key].Min:SetAttribute("parentKey", "Min")
    self[key].Max:SetText(PGF.model[key:lower()].max)
    self[key].Max:SetAttribute("parentKey", "Max")
    self[key].To:SetText(L["dialog.to"])
    self[key].Min:SetScript("OnTextChanged", PGF.Dialog_MinMax_OnTextChanged)
    self[key].Max:SetScript("OnTextChanged", PGF.Dialog_MinMax_OnTextChanged)
    self[key].Min:SetScript("OnTabPressed", PGF.Dialog_Min_OnTabPressed)
    self[key].Max:SetScript("OnTabPressed", PGF.Dialog_Max_OnTabPressed)
end

function PGF.Dialog_OnLoad()
    local dialog = PremadeGroupsFilterDialog

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

    local font = dialog.SimpleExplanation:GetFont()
    dialog.Expression.EditBox:SetFont(font, PGF.CONST.FONTSIZE_TEXTBOX)
    dialog.Expression.EditBox.Instructions:SetFont(font, PGF.CONST.FONTSIZE_TEXTBOX)

    UIDropDownMenu_Initialize(dialog.Difficulty.DropDown, PGF.Dialog_DifficultyDropdown_Init)
    UIDropDownMenu_SetText(dialog.Difficulty.DropDown, L["dialog.mythic"])
    UIDropDownMenu_SetWidth(dialog.Difficulty.DropDown, 90)
    PGF.DebugPrint("dialog onload completed")
end

function PGF.Dialog_Toggle()
    local dialog = PremadeGroupsFilterDialog
    if PVEFrame:IsVisible()
            and GroupFinderFrame.selection == LFGListPVEStub
            and LFGListFrame.activePanel == LFGListFrame.SearchPanel then
        dialog:Show()
    else
        dialog:Hide()
    end
end

function PGF.Dialog_UpdatePosition()
    local dialog = PremadeGroupsFilterDialog
    dialog:SetPoint("TOPLEFT", GroupFinderFrame, "TOPRIGHT")
    dialog:SetPoint("BOTTOMLEFT", GroupFinderFrame, "BOTTOMRIGHT")
    dialog:SetWidth(300)
end

function PGF.Dialog_OnShow(dialog)
    PGF.Dialog_UpdatePosition(dialog)
end

hooksecurefunc("LFGListFrame_SetActivePanel", PGF.Dialog_Toggle)
hooksecurefunc("GroupFinderFrame_ShowGroupFrame", PGF.Dialog_Toggle)
hooksecurefunc("InputScrollFrame_OnTextChanged", PGF.Dialog_Expression_OnTextChanged)
PVEFrame:SetScript("OnShow", PGF.Dialog_Toggle)
PVEFrame:SetScript("OnHide", PGF.Dialog_Toggle)
