-------------------------------------------------------------------------------
-- Premade Groups Filter - Save Slot Tabs
-------------------------------------------------------------------------------
-- Copyright (C) 2017 Jos_eu@curse
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

PremadeGroupsFilterTabs = PremadeGroupsFilterTabs or {}

local MAX_TABS = 9

local PGF = select(2, ...)
local L = PGF.L
local C = PGF.C

local Tabs = {
	activeTab = nil,
	activeCategory = nil
}

PGF.Tabs = Tabs

local InitIconArray

function Tabs.Tab_OnClick(self, button)
	local id = self:GetID()
	local data = PremadeGroupsFilterTabs[Tabs.activeCategory][id]
	local isRight = button == "RightButton"
	local isLeft = button == "LeftButton"
	local noData = data == nil
	local isEdit = IsControlKeyDown() and isRight
	local isRemove = IsAltKeyDown() and isRight
	local isDeselect = IsControlKeyDown() and isLeft
	local isNew = noData and isLeft
	PremadeGroupsFilterTabEditFrame:Hide()

	if noData then
		if isNew then
			-- copy state
			local state = {}
			PGF.Table_UpdateWithDefaults(state, PremadeGroupsFilterState)
			PremadeGroupsFilterState = state

			-- create new tab
			data = {
				state = state,
				name = "Slot "..id,
				icon = "Interface\\Icons\\INV_Misc_QuestionMark",
			}
			PremadeGroupsFilterTabs[Tabs.activeCategory][id] = data
			Tabs.Arrange()
			Tabs.Update()
		else
			Tabs.Update()
			return -- no data, no right click action
		end
	end

	if isDeselect and not noData then
		-- deselect tab
		Tabs.activeTab = nil

		-- deattach state from the tabs PremadeGroupsFilterTabs.state
		local state = {}
		PGF.Table_UpdateWithDefaults(state, PremadeGroupsFilterState)
		PremadeGroupsFilterState = state

		Tabs.Update()
		return
	end

	if isRemove then
		Tabs.Remove(id)
		return
	end

	PlaySound("igMainMenuOptionCheckBoxOn")

	if isRight or isEdit or isNew then
		-- ensure PremadeGroupsFilterDialog is visible
		if not PremadeGroupsFilterDialog:IsVisible() then
			PremadeGroupsFilterDialog:Show()
			Tabs.Attach()
		elseif isRight and not isEdit then
			PremadeGroupsFilterDialog:Hide()
			Tabs.Attach()
		end
	end

	if Tabs.activeTab ~= id then
		Tabs.activeTab = id
		Tabs.Update()

		-- update state to the saved data of the selected tab
		if data.state then
			PremadeGroupsFilterState = data.state
			PGF.Dialog_LoadFromModel(PremadeGroupsFilterDialog)
		end
	else
		Tabs.Update(id)
	end

	if isEdit or isNew then
		PremadeGroupsFilterTabEditFrame:Show()
		PremadeGroupsFilterTabEditEditBox:SetText(data.name)
	else
		-- do a search; also force enabled, as the user requested a PremadeGroupsFilter search
		PremadeGroupsFilterState.enabled = true
		PGF.UsePFGButton:SetChecked(true)
		LFGListSearchPanel_DoSearch(LFGListFrame.SearchPanel)
	end
end

function Tabs.OnDoSearch()
	if not Tabs.activeTab or Tabs.activeTab < 1 then return end
	local activeTabData = PremadeGroupsFilterTabs[Tabs.activeCategory][Tabs.activeTab]
	if PremadeGroupsFilterState.enabled and PremadeGroupsFilterDialog:IsVisible() and activeTabData then
		-- PGF is enabled, the edit window is shown and a tab is active => save current search to tab
		activeTabData.state = PremadeGroupsFilterState
	end
end

function Tabs.OnSelectCategory(self, categoryID, filters)
	local category = tostring(categoryID)
	if not PremadeGroupsFilterTabs[category] then
		PremadeGroupsFilterTabs[category] = {}
	end
	Tabs.activeCategory = category
	Tabs.activeTab = nil
	Tabs.Arrange()
	Tabs.Update()
end

function Tabs.Init()
	PGF.UsePFGButton:Hide()
	PremadeGroupsFilterState.enabled = false
	Tabs.activeCategory = tostring(LFGListFrame.selectedCategory or 1)
	local categories = C_LFGList.GetAvailableCategories(baseFilters);
	for i=1, MAX_TABS do
		local tab = _G["PremadeGroupsFilterTab"..i]
		local id = tab:GetID()
		tab:Hide()
		tab:SetScript("OnClick", Tabs.Tab_OnClick)
		tab:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			local data = PremadeGroupsFilterTabs[Tabs.activeCategory][self:GetID()]
			if data then
				GameTooltip:SetText(data.name)
				if data.state.expression then
					GameTooltip:AddLine(data.state.expression, 1 ,1, 1, true)
				end
			else
				GameTooltip:SetText("Create new search")
				GameTooltip:AddLine("Left-Click to add a new button", 1, 1, 1)
				GameTooltip:AddLine(" ", 1, 1, 1)
				GameTooltip:AddLine("Once created, to use a search button:", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
				GameTooltip:AddLine("Left-Click to perform the search", 1, 1, 1)
				GameTooltip:AddLine("Right-Click to toggle the search terms edit window", 1, 1, 1)
				GameTooltip:AddLine("Ctrl-Right-Click to change button name and icon", 1, 1, 1)
				GameTooltip:AddLine("Alt-Right-Click to remove button", 1, 1, 1)
				GameTooltip:AddLine(" ", 1, 1, 1)
				GameTooltip:AddLine("A search button auto saves the search terms used while selected. Use Ctrl-Left-Click to unselect a button.", 1, 1, 1, true)
			end
			GameTooltip:Show()
		end)
		tab:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		tab:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	end

	PGF.UsePFGButton:HookScript("OnClick", function(self)
		if not self:GetChecked() then
			Tabs.activeTab = nil
			Tabs.Update()
		end
	end)

	InitIconArray()

	return true
end

function Tabs.Attach()
	PremadeGroupsFilterTabsFrame:ClearAllPoints()
	if PremadeGroupsFilterDialog:IsVisible() then
		PremadeGroupsFilterTabsFrame:SetPoint("TOPLEFT", "PremadeGroupsFilterDialog", "TOPLEFT")
		PremadeGroupsFilterTabsFrame:SetPoint("BOTTOMRIGHT", "PremadeGroupsFilterDialog", "BOTTOMRIGHT")
	else
		PremadeGroupsFilterTabsFrame:SetPoint("TOPLEFT", "PVEFrame", "TOPLEFT")
		PremadeGroupsFilterTabsFrame:SetPoint("BOTTOMRIGHT", "PVEFrame", "BOTTOMRIGHT")
	end
end

function Tabs.Update(id)
	if id then
		local tab = _G["PremadeGroupsFilterTab"..id]
		tab:SetChecked(id == Tabs.activeTab)
	else
		for i=1, MAX_TABS do
			local tab = _G["PremadeGroupsFilterTab"..i]
			local id = tab:GetID()
			tab:SetChecked(id == Tabs.activeTab)
		end
	end
	PremadeGroupsFilterState.enabled = Tabs.activeTab and Tabs.activeTab > 0
end

function Tabs.Arrange()
	local n = 0
	for i=1, MAX_TABS do
		local tab = _G["PremadeGroupsFilterTab"..i]
		local data = PremadeGroupsFilterTabs[Tabs.activeCategory][i]
		if data then
			n = i
			tab:Show()
			tab:SetNormalTexture(data.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
		elseif i>n then
			n = MAX_TABS
			tab:Show()
			tab:SetNormalTexture("Interface\\PaperDollInfoFrame\\Character-Plus")
		else
			tab:Hide()
		end
	end
end

function Tabs.Remove(id)
	table.remove(PremadeGroupsFilterTabs[Tabs.activeCategory], id)
	local activeTab = Tabs.activeTab
	if activeTab and activeTab > 0 and activeTab ~= id then
		if activeTab > id then
			Tabs.activeTab = activeTab-1
		end
	else
		Tabs.activeTab = nil

		-- detach state from the tabs PremadeGroupsFilterTabs.state
		local state = {}
		PGF.Table_UpdateWithDefaults(state, PremadeGroupsFilterState)
		PremadeGroupsFilterState = state
		PremadeGroupsFilterState.enabled = false
	end

	Tabs.Arrange()
	Tabs.Update()
end

function Tabs.SetIcon(id, texture)
	local tab = _G["PremadeGroupsFilterTab"..id]
	local data = PremadeGroupsFilterTabs[Tabs.activeCategory][id]
	data.icon = texture
	tab:SetNormalTexture(texture)
end

function Tabs.SetName(id, text)
	local tab = _G["PremadeGroupsFilterTab"..id]
	local data = PremadeGroupsFilterTabs[Tabs.activeCategory][id]
	data.name = text
end

function Tabs.Show()
	PremadeGroupsFilterTabsFrame:Show()
end

function Tabs.Hide()
	PremadeGroupsFilterTabsFrame:Hide()
	PremadeGroupsFilterTabEditFrame:Hide()
end

local initialized = false
function Tabs.ShowHide()
	if not initialized then initialized = Tabs.Init() end
	if PVEFrame:IsVisible()
			and LFGListFrame.activePanel == LFGListFrame.SearchPanel
			and LFGListFrame.SearchPanel:IsVisible() then
		PremadeGroupsFilterDialog:Hide()
		Tabs.Attach()
		Tabs.Arrange()
		Tabs.Update()
		Tabs.Show()
	else
		Tabs.Hide()
	end
end

hooksecurefunc("LFGListFrame_SetActivePanel", Tabs.ShowHide)
hooksecurefunc("PVEFrame_ShowFrame", Tabs.ShowHide)
hooksecurefunc("GroupFinderFrame_ShowGroupFrame", Tabs.ShowHide)
hooksecurefunc("LFGListSearchPanel_DoSearch", Tabs.OnDoSearch)
hooksecurefunc("LFGListCategorySelection_SelectCategory", Tabs.OnSelectCategory)
PVEFrame:HookScript("OnHide", Tabs.Hide)
PremadeGroupsFilterDialog:HookScript("OnShow", Tabs.Attach)
PremadeGroupsFilterDialog:HookScript("OnHide", Tabs.Attach)


-- The following icon select popup code is heavily burrowed from Blizzard_MacroUI
--

NUM_ICONS_PER_ROW = 5;
NUM_ICON_ROWS = 7;
NUM_MACRO_ICONS_SHOWN = NUM_ICONS_PER_ROW * NUM_ICON_ROWS;
MACRO_ICON_ROW_HEIGHT = 36;
local MACRO_ICON_FILENAMES = nil;

local iconArrayBuilt = false
InitIconArray = function()
	if ( not iconArrayBuilt ) then
		BuildIconArray(PremadeGroupsFilterTabEditFrame, "PremadeGroupsFilterTabEditButton", "PremadeGroupsFilterTabEditButtonTemplate", NUM_ICONS_PER_ROW, NUM_ICON_ROWS)
		iconArrayBuilt = true
	end
end

--[[
RefreshPlayerSpellIconInfo() builds the table MACRO_ICON_FILENAMES with known spells followed by all icons (could be repeats)
]]
function RefreshPlayerSpellIconInfo()
	if ( MACRO_ICON_FILENAMES ) then
		return;
	end

	-- We need to avoid adding duplicate spellIDs from the spellbook tabs for your other specs.
	local activeIcons = {};

	MACRO_ICON_FILENAMES = {};
	MACRO_ICON_FILENAMES[1] = "INV_MISC_QUESTIONMARK";
	local index = 2;
	local numFlyouts = 0;

	for i = 1, GetNumSpellTabs() do
		local tab, tabTex, offset, numSpells, _ = GetSpellTabInfo(i);
		offset = offset + 1;
		local tabEnd = offset + numSpells;
		for j = offset, tabEnd - 1 do
			--to get spell info by slot, you have to pass in a pet argument
			local spellType, ID = GetSpellBookItemInfo(j, "player");
			if (spellType ~= "FUTURESPELL") then
				local spellTexture = strupper(GetSpellBookItemTextureFileName(j, "player"));
				if ( not string.match( spellTexture, "INTERFACE\\BUTTONS\\") ) then
					local iconPath = gsub( spellTexture, "INTERFACE\\ICONS\\", "");
					if ( not activeIcons[iconPath] ) then
						MACRO_ICON_FILENAMES[index] = iconPath;
						activeIcons[iconPath] = true;
						index = index + 1;
					end
				end
			end
			if (spellType == "FLYOUT") then
				local _, _, numSlots, isKnown = GetFlyoutInfo(ID);
				if (isKnown and numSlots > 0) then
					for k = 1, numSlots do
						local spellID, overrideSpellID, isKnown = GetFlyoutSlotInfo(ID, k)
						if (isKnown) then
							local iconPath = gsub( strupper(GetSpellTextureFileName(spellID)), "INTERFACE\\ICONS\\", "");
							if ( not activeIcons[iconPath] ) then
								MACRO_ICON_FILENAMES[index] = iconPath;
								activeIcons[iconPath] = true;
								index = index + 1;
							end
						end
					end
				end
			end
		end
	end
	GetLooseMacroIcons( MACRO_ICON_FILENAMES );
	GetLooseMacroItemIcons( MACRO_ICON_FILENAMES );
	GetMacroIcons( MACRO_ICON_FILENAMES );
	GetMacroItemIcons( MACRO_ICON_FILENAMES );
end

function GetSpellorMacroIconInfo(index)
	if ( not index ) then
		return;
	end
	local texture = MACRO_ICON_FILENAMES[index];
	local texnum = tonumber(texture);
	if (texnum ~= nil) then
		return texnum;
	else
		return texture;
	end
end

function PremadeGroupsFilterTabEditFrame_Update(self)
	self = self or PremadeGroupsFilterTabEditFrame;
	local numMacroIcons = #MACRO_ICON_FILENAMES;
	local macroPopupIcon, macroPopupButton;
	local macroPopupOffset = FauxScrollFrame_GetOffset(PremadeGroupsFilterTabEditScrollFrame);
	local index;

	-- Icon list
	local texture;
	for i=1, NUM_MACRO_ICONS_SHOWN do
		macroPopupIcon = _G["PremadeGroupsFilterTabEditButton"..i.."Icon"];
		macroPopupButton = _G["PremadeGroupsFilterTabEditButton"..i];
		index = (macroPopupOffset * NUM_ICONS_PER_ROW) + i;
		texture = GetSpellorMacroIconInfo(index);

		if ( index <= numMacroIcons and texture ) then
			if(type(texture) == "number") then
				macroPopupIcon:SetTexture(texture);
			else
				macroPopupIcon:SetTexture("INTERFACE\\ICONS\\"..texture);
			end
			macroPopupButton:Show();
		else
			macroPopupIcon:SetTexture("");
			macroPopupButton:Hide();
		end
		if (PremadeGroupsFilterTabEditFrame.selectedIcon and (index == PremadeGroupsFilterTabEditFrame.selectedIcon) ) then
			macroPopupButton:SetChecked(true);
		elseif (PremadeGroupsFilterTabEditFrame.selectedIconTexture == texture ) then
			macroPopupButton:SetChecked(true);
		else
			macroPopupButton:SetChecked(false);
		end
	end

	-- Scrollbar stuff
	FauxScrollFrame_Update(PremadeGroupsFilterTabEditScrollFrame, ceil(numMacroIcons / NUM_ICONS_PER_ROW) + 1, NUM_ICON_ROWS, MACRO_ICON_ROW_HEIGHT );
end

function PremadeGroupsFilterTabEditButton_SelectTexture(selectedIcon)
	PremadeGroupsFilterTabEditFrame.selectedIcon = selectedIcon
	-- Clear out selected texture
	PremadeGroupsFilterTabEditFrame.selectedIconTexture = nil
	local curMacroInfo = GetSpellorMacroIconInfo( PremadeGroupsFilterTabEditFrame.selectedIcon)
	if(type(curMacroInfo) == "number") then
		Tabs.SetIcon(Tabs.activeTab, curMacroInfo)
	else
		Tabs.SetIcon(Tabs.activeTab, "INTERFACE\\ICONS\\"..curMacroInfo)
	end
end

function PremadeGroupsFilterTabEditButton_OnClick(self, button)
	PremadeGroupsFilterTabEditButton_SelectTexture(self:GetID() + (FauxScrollFrame_GetOffset( PremadeGroupsFilterTabEditScrollFrame) * NUM_ICONS_PER_ROW))
end

function PremadeGroupsFilterTabEditOkayButton_OnClick()
	PremadeGroupsFilterTabEditFrame:Hide()
end

function PremadeGroupsFilterTabEditFrame_CloseEdit()
	PremadeGroupsFilterTabEditFrame:Hide()
end

function PremadeGroupsFilterTabEditSetName(text)
	if Tabs.activeTab then
		Tabs.SetName(Tabs.activeTab, text)
	end
end

function PremadeGroupsFilterTabEditFrame_OnLoad(self)
	PremadeGroupsFilterTabEditScrollFrame.ScrollBar.scrollStep = 8 * MACRO_ICON_ROW_HEIGHT;
	InitIconArray()
end

function PremadeGroupsFilterTabEditFrame_OnShow(self)
	PremadeGroupsFilterTabEditEditBox:SetFocus()
	PlaySound("igCharacterInfoOpen")
	RefreshPlayerSpellIconInfo()
	PremadeGroupsFilterTabEditFrame_Update(self)
end
