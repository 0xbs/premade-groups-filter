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
local C = PGF.C

-- All local functions in this file are copies from the original LFGList.lua
-- because they are all local functions there as well, so we cannot call them directly.

local function LFGListAdvancedFiltersActivitiesNoneChecked(enabled)
    return #enabled.activities == 0;
end

local function LFGListAdvancedFiltersActivitiesAllChecked(enabled)
    local seasonGroups = C_LFGList.GetAvailableActivityGroups(GROUP_FINDER_CATEGORY_ID_DUNGEONS, bit.bor(Enum.LFGListFilter.CurrentSeason, Enum.LFGListFilter.PvE));
    local expansionGroups = C_LFGList.GetAvailableActivityGroups(GROUP_FINDER_CATEGORY_ID_DUNGEONS, bit.bor(Enum.LFGListFilter.CurrentExpansion, Enum.LFGListFilter.NotCurrentSeason, Enum.LFGListFilter.PvE));

    return #enabled.activities == (#seasonGroups + #expansionGroups);
end

local function LFGListAdvancedFiltersDifficultyNoneChecked(enabled)
    return not (enabled.difficultyNormal or enabled.difficultyHeroic or enabled.difficultyMythic or enabled.difficultyMythicPlus);
end

local function LFGListAdvancedFiltersDifficultyAllChecked(enabled)
    return enabled.difficultyNormal and enabled.difficultyHeroic and enabled.difficultyMythic and enabled.difficultyMythicPlus;
end

--for activities and difficulties, none checked and all checked are equivalent. Although visually we want to show all checked as the default.
local function LFGListAdvancedFiltersIsDefault(enabled)
    return (LFGListAdvancedFiltersActivitiesNoneChecked(enabled) or LFGListAdvancedFiltersActivitiesAllChecked(enabled))
            and (LFGListAdvancedFiltersDifficultyNoneChecked(enabled) or LFGListAdvancedFiltersDifficultyAllChecked(enabled))
            and not (enabled.needsTank or enabled.needsHealer or enabled.needsDamage or enabled.needsMyClass or enabled.hasTank or enabled.hasHealer
            or (enabled.minimumRating ~= 0));
end

local function LFGListAdvancedFiltersCheckAllDifficulties(enabled)
    enabled.difficultyNormal = true;
    enabled.difficultyHeroic = true;
    enabled.difficultyMythic = true;
    enabled.difficultyMythicPlus = true;
end

local function LFGListAdvancedFiltersCheckAllDungeons(enabled)
    local seasonGroups = C_LFGList.GetAvailableActivityGroups(GROUP_FINDER_CATEGORY_ID_DUNGEONS, bit.bor(Enum.LFGListFilter.CurrentSeason, Enum.LFGListFilter.PvE));
    local expansionGroups = C_LFGList.GetAvailableActivityGroups(GROUP_FINDER_CATEGORY_ID_DUNGEONS, bit.bor(Enum.LFGListFilter.CurrentExpansion, Enum.LFGListFilter.NotCurrentSeason, Enum.LFGListFilter.PvE));

    local allDungeons = {};

    tAppendAll(allDungeons, seasonGroups);
    tAppendAll(allDungeons, expansionGroups);

    enabled.activities = allDungeons;
end

local function UpdateFilterRedX()
    local redx = LFGListFrame.SearchPanel.FilterButton.ResetToDefaults;
    local enabled = C_LFGList.GetAdvancedFilter();
    if LFGListFrame.CategorySelection.selectedCategory ~= GROUP_FINDER_CATEGORY_ID_DUNGEONS
            or LFGListAdvancedFiltersIsDefault(enabled) then
        redx:Hide();
    else
        redx:Show();
    end
end

function PGF.GetAdvancedFilterDefaults()
    local enabled = C_LFGList.GetAdvancedFilter();
    enabled.needsTank = false;
    enabled.needsHealer = false;
    enabled.needsDamage = false;
    --enabled.needsMyClass = false; -- not reset on purpose to keep player value
    enabled.hasTank = false;
    enabled.hasHealer = false;
    enabled.minimumRating = 0;
    MinRatingFrame.MinRating:SetNumber(0);
    enabled.activities = {};
    LFGListAdvancedFiltersCheckAllDifficulties(enabled);
    LFGListAdvancedFiltersCheckAllDungeons(enabled);
    --C_LFGList.SaveAdvancedFilter(enabled);
    --UpdateFilterRedX();
    --LFGListSearchPanel_DoSearch(LFGListFrame.SearchPanel);
    return enabled
end

function PGF.SetAdvancedFilter(enabled)
    C_LFGList.SaveAdvancedFilter(enabled)
    MinRatingFrame.MinRating:SetNumber(enabled.minimumRating)
    UpdateFilterRedX()
end

-- struct AdvancedFilterOptions {
--   needsTank             bool
--   needsHealer           bool
--   needsDamage           bool
--   needsMyClass          bool
--   hasTank               bool
--   hasHealer             bool
--   activities            table<number> (list of activityGroupID)
--   minimumRating         number
--   difficultyNormal      bool
--   difficultyHeroic      bool
--   difficultyMythic      bool
--   difficultyMythicPlus  bool
-- }
